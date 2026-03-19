#!/usr/bin/env bash
# Szenario A – OTOBO Ersteinrichtung
#
# Ausführung: einmalig nach der OTOBO-Erstinstallation (installer.pl), vor seed-otobo.sh.
#
# Erstellt via OTOBO-Kernel-API (docker exec):
#   - Gruppen:         isms-team, isms-audit
#   - Queues:          Risiken (::Strategisch/::Operativ/::Technisch)
#                      Aufgaben (::Audit/::Schulung/::Lieferant), Incidents
#   - Ticket-Zustände: identifiziert → bewertet → behandlung-geplant →
#                      in-behandlung → akzeptiert
#   - Dynamic Fields:  RisikoWahrscheinlichkeit, RisikoSchadenshoehe, RisikoWert,
#                      BezugsobjektTyp, BezugsobjektID, Risikoebene
#   - Webservice:      GenericTicketConnectorREST (Import aus OTOBO-Installationspaket)
#   - Agent-Users:     isms-manager, isms-auditor
#   - Customer-User:   isms-demo (für Demo-Seed-Skripte)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"

if [[ -f "${SCRIPT_DIR}/../.env" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/../.env"
fi

CONTAINER="${OTOBO_CONTAINER:-otobo-web}"
OTOBO_URL="https://tickets.${DOMAIN}"

step "OTOBO – Warte auf Service"
wait_for_http "${OTOBO_URL}/otobo/index.pl" "OTOBO"

step "OTOBO – Ersteinrichtung via Kernel-API"

docker exec -i \
  -e "DOMAIN=${DOMAIN}" \
  -e "OTOBO_ADMIN_PASSWORD=${OTOBO_DEMO_PASSWORD:-}" \
  "${CONTAINER}" \
  perl - << 'PERL'
use strict;
use warnings;
use utf8;
use Encode qw(encode_utf8);

binmode STDOUT, ':utf8';

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => { LogPrefix => 'otobo-setup' },
);

my $Domain = $ENV{DOMAIN} // 'example.com';

sub _ok   { print encode_utf8("  \033[32mOK\033[0m    $_[0]\n") }
sub _skip { print encode_utf8("  \033[33mSKIP\033[0m  $_[0]\n") }
sub _err  { print encode_utf8("  \033[31mERR\033[0m   $_[0]\n") }
sub _sect { print encode_utf8("\n\033[1;37m── $_[0]\033[0m\n") }

# ── 1. Gruppen ──────────────────────────────────────────────────────────────
_sect('Gruppen');

my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
my %GroupIDs;

for my $Entry (
    [ 'isms-team',  'ISMS Team – Vollzugriff auf alle ISMS-Queues' ],
    [ 'isms-audit', 'ISMS Audit – Lesezugriff, keine Ticket-Erstellung' ],
) {
    my ( $Name, $Comment ) = @$Entry;
    my %Existing = reverse $GroupObject->GroupList( Valid => 0 );
    if ( $Existing{$Name} ) {
        $GroupIDs{$Name} = $Existing{$Name};
        _skip("Group '$Name' (ID=$Existing{$Name})");
        next;
    }
    my $ID = $GroupObject->GroupAdd(
        Name    => $Name,
        Comment => $Comment,
        ValidID => 1,
        UserID  => 1,
    );
    if ($ID) { $GroupIDs{$Name} = $ID; _ok("Group '$Name' (ID=$ID)") }
    else      { _err("Group '$Name'") }
}

my $TeamGroupID  = $GroupIDs{'isms-team'}  // 1;
my $AuditGroupID = $GroupIDs{'isms-audit'} // 1;

# ── 2. Queues ───────────────────────────────────────────────────────────────
_sect('Queues');

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# Reihenfolge: Eltern-Queues zuerst
my @Queues = qw(
    Risiken
    Risiken::Strategisch
    Risiken::Operativ
    Risiken::Technisch
    Aufgaben
    Aufgaben::Audit
    Aufgaben::Schulung
    Aufgaben::Lieferant
    Incidents
);

for my $QueueName (@Queues) {
    if ( $QueueObject->QueueLookup( Queue => $QueueName ) ) {
        _skip("Queue '$QueueName'");
        next;
    }
    my $ID = $QueueObject->QueueAdd(
        Name            => $QueueName,
        ValidID         => 1,
        GroupID         => $TeamGroupID,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        FollowUpID      => 1,    # Folgeanfragen möglich
        FollowUpLock    => 0,
        UserID          => 1,
    );
    if ($ID) { _ok("Queue '$QueueName' (ID=$ID)") }
    else      { _err("Queue '$QueueName'") }
}

# ── 3. Ticket-Zustände ──────────────────────────────────────────────────────
_sect('Ticket-Zustaende');

my $StateObject = $Kernel::OM->Get('Kernel::System::State');
my %StateTypes  = reverse $StateObject->StateTypeList( UserID => 1 );

my @States = (
    { Name => 'identifiziert',       Type => 'new'    },
    { Name => 'bewertet',            Type => 'open'   },
    { Name => 'behandlung-geplant',  Type => 'open'   },
    { Name => 'in-behandlung',       Type => 'open'   },
    { Name => 'akzeptiert',          Type => 'closed' },
);

for my $S (@States) {
    my %Existing = $StateObject->StateGet( Name => $S->{Name} );
    if ( $Existing{ID} ) {
        _skip("State '$S->{Name}'");
        next;
    }
    my $TypeID = $StateTypes{ $S->{Type} } // 1;
    my $ID     = $StateObject->StateAdd(
        Name    => $S->{Name},
        TypeID  => $TypeID,
        ValidID => 1,
        UserID  => 1,
    );
    if ($ID) { _ok("State '$S->{Name}' (ID=$ID)") }
    else      { _err("State '$S->{Name}'") }
}

# ── 4. Dynamic Fields ───────────────────────────────────────────────────────
_sect('Dynamic Fields');

my $DFObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ExistingDFs   = $DFObject->DynamicFieldList( ResultType => 'HASH', Valid => 0 ) // {};
my %ExistingByName = reverse %{$ExistingDFs};

my @Fields = (
    {
        Name      => 'RisikoWahrscheinlichkeit',
        Label     => 'Wahrscheinlichkeit',
        FieldType => 'Dropdown',
        Order     => 100,
        Config    => {
            PossibleValues => {
                1 => '1 - Selten',
                2 => '2 - Moeglich',
                3 => '3 - Wahrscheinlich',
                4 => '4 - Fast sicher',
            },
            DefaultValue       => '',
            PossibleNone       => 1,
            TranslatableValues => 0,
        },
    },
    {
        Name      => 'RisikoSchadenshoehe',
        Label     => 'Schadenshoehe',
        FieldType => 'Dropdown',
        Order     => 101,
        Config    => {
            PossibleValues => {
                1 => '1 - Gering',
                2 => '2 - Mittel',
                3 => '3 - Hoch',
                4 => '4 - Kritisch',
            },
            DefaultValue       => '',
            PossibleNone       => 1,
            TranslatableValues => 0,
        },
    },
    {
        Name      => 'RisikoWert',
        Label     => 'Risikowert (WxS)',
        FieldType => 'Text',
        Order     => 102,
        Config    => { DefaultValue => '', Link => '' },
    },
    {
        Name      => 'BezugsobjektTyp',
        Label     => 'Bezugsobjekt-Typ',
        FieldType => 'Dropdown',
        Order     => 103,
        Config    => {
            PossibleValues => {
                'Asset'         => 'Asset',
                'Prozess'       => 'Prozess',
                'OE'            => 'Organisationseinheit',
                'Extern'        => 'Externer Akteur',
                'Regulatorisch' => 'Regulatorisch',
            },
            DefaultValue       => '',
            PossibleNone       => 1,
            TranslatableValues => 0,
        },
    },
    {
        Name      => 'BezugsobjektID',
        Label     => 'Bezugsobjekt-ID',
        FieldType => 'Text',
        Order     => 104,
        Config    => { DefaultValue => '', Link => '' },
    },
    {
        Name      => 'Risikoebene',
        Label     => 'Risikoebene',
        FieldType => 'Dropdown',
        Order     => 105,
        Config    => {
            PossibleValues => {
                'Strategisch' => 'Strategisch',
                'Operativ'    => 'Operativ',
                'Technisch'   => 'Technisch',
            },
            DefaultValue       => '',
            PossibleNone       => 1,
            TranslatableValues => 0,
        },
    },
);

for my $F (@Fields) {
    if ( $ExistingByName{ $F->{Name} } ) {
        _skip("DynamicField '$F->{Name}'");
        next;
    }
    my $ID = $DFObject->DynamicFieldAdd(
        Name       => $F->{Name},
        Label      => $F->{Label},
        FieldOrder => $F->{Order},
        FieldType  => $F->{FieldType},
        ObjectType => 'Ticket',
        Config     => $F->{Config},
        ValidID    => 1,
        UserID     => 1,
    );
    if ($ID) { _ok("DynamicField '$F->{Name}' (ID=$ID)") }
    else      { _err("DynamicField '$F->{Name}'") }
}

# ── 5. NIS2-Meldepflichten-Workflow ────────────────────────────────────────
_sect('NIS2-Meldepflichten-Workflow');

# Queue
if ( !$QueueObject->QueueLookup( Queue => 'Meldepflichten' ) ) {
    my $ID = $QueueObject->QueueAdd(
        Name            => 'Meldepflichten',
        ValidID         => 1,
        GroupID         => $TeamGroupID,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        FollowUpID      => 1,
        FollowUpLock    => 1,    # Folgeanfragen nur mit Berechtigung
        UserID          => 1,
    );
    if ($ID) { _ok("Queue 'Meldepflichten' (ID=$ID)") }
    else      { _err("Queue 'Meldepflichten'") }
}
else { _skip("Queue 'Meldepflichten'") }

# Ticket-Zustände für Meldepflicht-Workflow
# Spiegeln die NIS2-Meldefristen: 24h / 72h / 1 Monat
my @NIS2States = (
    { Name => 'meldepflicht-erkannt',         Type => 'new'    },
    { Name => 'erstmeldung-erstattet',         Type => 'open'   },
    { Name => 'folgemeldung-erstattet',        Type => 'open'   },
    { Name => 'abschlussmeldung-erstattet',    Type => 'closed' },
    { Name => 'meldepflicht-entfallen',        Type => 'closed' },
);

for my $S (@NIS2States) {
    my %Existing = $StateObject->StateGet( Name => $S->{Name} );
    if ( $Existing{ID} ) {
        _skip("State '$S->{Name}'");
        next;
    }
    my $TypeID = $StateTypes{ $S->{Type} } // 1;
    my $ID     = $StateObject->StateAdd(
        Name    => $S->{Name},
        TypeID  => $TypeID,
        ValidID => 1,
        UserID  => 1,
    );
    if ($ID) { _ok("State '$S->{Name}' (ID=$ID)") }
    else      { _err("State '$S->{Name}'") }
}

# Dynamic Fields für Meldepflicht-Tickets
my @NIS2Fields = (
    {
        Name      => 'MeldepflichtArt',
        Label     => 'Meldungsart',
        FieldType => 'Dropdown',
        Order     => 200,
        Config    => {
            PossibleValues => {
                'erstmeldung'        => 'Erstmeldung (24h)',
                'folgemeldung'       => 'Folgemeldung (72h)',
                'abschlussmeldung'   => 'Abschlussmeldung (30 Tage)',
            },
            DefaultValue => '', PossibleNone => 1, TranslatableValues => 0,
        },
    },
    {
        Name      => 'MeldepflichtFrist',
        Label     => 'Meldefrist',
        FieldType => 'Dropdown',
        Order     => 201,
        Config    => {
            PossibleValues => {
                '24h'    => '24 Stunden (NIS2 Erstmeldung)',
                '72h'    => '72 Stunden (NIS2 Folgemeldung)',
                '30d'    => '30 Tage (NIS2 Abschlussmeldung)',
                'sofort' => 'Sofort (kritische Infrastruktur)',
            },
            DefaultValue => '', PossibleNone => 1, TranslatableValues => 0,
        },
    },
    {
        Name      => 'MeldepflichtBehoerde',
        Label     => 'Zustaendige Behoerde',
        FieldType => 'Dropdown',
        Order     => 202,
        Config    => {
            PossibleValues => {
                'BSI'        => 'BSI (Bundesamt fuer Sicherheit in der Informationstechnik)',
                'BNetzA'     => 'Bundesnetzagentur',
                'BaFin'      => 'BaFin (Finanzsektor)',
                'Landesbehoerde' => 'Zustaendige Landesbehoerde',
                'ENISA'      => 'ENISA (grenzueberschreitend)',
            },
            DefaultValue => 'BSI', PossibleNone => 0, TranslatableValues => 0,
        },
    },
    {
        Name      => 'MeldungsReferenznummer',
        Label     => 'Meldungs-Referenznummer',
        FieldType => 'Text',
        Order     => 203,
        Config    => { DefaultValue => '', Link => '' },
    },
    {
        Name      => 'VorfallErsterkennungZeit',
        Label     => 'Zeitpunkt der Ersterkennung',
        FieldType => 'DateTime',
        Order     => 204,
        Config    => {
            DefaultValue  => 0,
            YearsPeriodPast   => 2,
            YearsPeriodFuture => 0,
        },
    },
);

for my $F (@NIS2Fields) {
    if ( $ExistingByName{ $F->{Name} } ) {
        _skip("DynamicField '$F->{Name}'");
        next;
    }
    my $ID = $DFObject->DynamicFieldAdd(
        Name       => $F->{Name},
        Label      => $F->{Label},
        FieldOrder => $F->{Order},
        FieldType  => $F->{FieldType},
        ObjectType => 'Ticket',
        Config     => $F->{Config},
        ValidID    => 1,
        UserID     => 1,
    );
    if ($ID) { _ok("DynamicField '$F->{Name}' (ID=$ID)") }
    else      { _err("DynamicField '$F->{Name}'") }
}

# ── 7. Webservice ───────────────────────────────────────────────────────────
_sect('Webservice');

my $WSObject   = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
my $WSName     = 'GenericTicketConnectorREST';

my %WSByName = reverse %{ $WSObject->WebserviceList( Valid => 0 ) // {} };

if ( $WSByName{$WSName} ) {
    _skip("Webservice '$WSName'");
}
else {
    my $YAMLFile = '/opt/otobo/scripts/webservices/GenericTicketConnectorREST.yml';
    if ( -e $YAMLFile ) {
        open my $fh, '<', $YAMLFile or die "Cannot open $YAMLFile: $!";
        local $/;
        my $YAML   = <$fh>;
        close $fh;
        my $Config = $YAMLObject->Load( Data => $YAML );
        my $ID     = $WSObject->WebserviceAdd(
            Name    => $WSName,
            Config  => $Config,
            ValidID => 1,
            UserID  => 1,
        );
        if ($ID) { _ok("Webservice '$WSName' (ID=$ID)") }
        else      { _err("Webservice '$WSName'") }
    }
    else {
        _err("YAML nicht gefunden: $YAMLFile");
        print "  Webservice manuell anlegen: Admin → GenericInterface → Webservice hinzufuegen\n";
    }
}

# ── 8. Customer-User ────────────────────────────────────────────────────────
_sect('Customer-User');

my $CUObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my %CU       = $CUObject->CustomerUserDataGet( User => 'isms-demo' );

if ( $CU{UserLogin} ) {
    _skip("CustomerUser 'isms-demo'");
}
else {
    my $ID = $CUObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'ISMS',
        UserLastname   => 'Demo',
        UserCustomerID => 'isms-demo',
        UserLogin      => 'isms-demo',
        UserEmail      => "isms-demo\@${Domain}",
        UserPassword   => 'Isms-Demo-2024!',
        ValidID        => 1,
        UserID         => 1,
    );
    if ($ID) { _ok("CustomerUser 'isms-demo'") }
    else      { _err("CustomerUser 'isms-demo'") }
}

# ── 9. Agent-Users ──────────────────────────────────────────────────────────
_sect('Agent-Users');

my $UserObject = $Kernel::OM->Get('Kernel::System::User');
my %UserByLogin = reverse $UserObject->UserList( Type => 'Short', Valid => 0 );

my @Agents = (
    {
        Login    => 'isms-manager',
        First    => 'ISMS',
        Last     => 'Manager',
        Password => 'Isms-Manager-2024!',
    },
    {
        Login    => 'isms-auditor',
        First    => 'ISMS',
        Last     => 'Auditor',
        Password => 'Isms-Auditor-2024!',
    },
);

for my $A (@Agents) {
    if ( $UserByLogin{ $A->{Login} } ) {
        _skip("Agent '$A->{Login}'");
        next;
    }
    my $Email = "$A->{Login}\@${Domain}";
    my $ID    = $UserObject->UserAdd(
        UserFirstname => $A->{First},
        UserLastname  => $A->{Last},
        UserLogin     => $A->{Login},
        UserEmail     => $Email,
        UserPassword  => $A->{Password},
        ValidID       => 1,
        UserID        => 1,
    );
    if ($ID) {
        # Gruppe zuweisen
        $GroupObject->PermissionGroupUserAdd(
            GID        => $TeamGroupID,
            UID        => $ID,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
                note      => 1,
                owner     => 1,
                priority  => 1,
                rw        => 1,
            },
            UserID => 1,
        );
        _ok("Agent '$A->{Login}' (ID=$ID)");
    }
    else {
        _err("Agent '$A->{Login}'");
    }
}

# ── 10. Fertig ──────────────────────────────────────────────────────────────
print encode_utf8("\n\033[32mOTOBO Ersteinrichtung abgeschlossen.\033[0m\n");
print encode_utf8(<<'MSG');

Standard-Passwoerter (bitte in OTOBO Admin-Oberflaeche aendern!):
  isms-manager:  Isms-Manager-2024!
  isms-auditor:  Isms-Auditor-2024!
  isms-demo:     Isms-Demo-2024!

Naechste Schritte:
  1. OTOBO Admin → System Configuration: Dynamic Fields den Ticket-Masken zuweisen
  2. Demo-Daten laden: ./demo/seed-otobo.sh
MSG

1;
PERL

success "OTOBO Ersteinrichtung abgeschlossen."
