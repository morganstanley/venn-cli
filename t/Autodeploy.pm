package t::Autodeploy;

use v5.14;
use warnings;

BEGIN {
    $ENV{VENN_POLICY_DIR} //= 'venn-virt';
    $ENV{VENN_NOAUTH} //= 1;
    $ENV{VENN_ENV} //= 'sqlite';
}

sub execute {
    my ($self, $schema) = @_;

    $t::Methods::SCHEMA = $schema;
    $schema->deploy();

    return;
}

1;
