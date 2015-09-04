#!/ms/dist/perl5/bin/perl5.14 -w
#-*- mode: CPerl;-*-

use v5.14;
use warnings;

BEGIN {
    use FindBin qw($Bin);
    use lib "$Bin/../..";
    use lib "$Bin/../../lib";
}

use t::Dependencies;
use Venn::CLI::Dependencies;
use t::bootstrap::Instance;
use CLI::Test::Client;
use Data::Dumper;

use Test::Most tests => 17; die_on_fail();

$ENV{VENN_TEST_DB_AUTODEPLOY} = 1;

my $venn = t::bootstrap::Instance->new(
    executable => $ENV{CATALYST_HOME}.'/script/venn_server.pl',
    set_env => 1,
);

my $cli = "$Bin/../../bin/venn";
my $tc = CLI::Test::Client->new;

# add_environment
{
    $tc->run_ok($cli, 'add_environment', 'testing',
                '--description', 'CLI testing',
            );
warn Data::Dumper::Dumper($tc);
    is_deeply(
        $tc->yaml,
        { environment => 'testing', description => 'CLI testing', overcommit => {} },
        'add_environment result ok',
    );
}

# update_environment
{
    $tc->run_ok($cli, 'update_environment', 'testing',
                '--description', 'CLI testing updated',
            );

    ok($tc->yaml->{description} eq 'CLI testing updated', "description updated");
}

# show_environment
{
    $tc->run_ok($cli, 'show_environment', 'testing');

    ok($tc->yaml->{environment} eq 'testing', "show_environment env ok");
    ok($tc->yaml->{description} eq 'CLI testing updated', "show_environment description ok");
}

# del_environment
{
    $tc->run_ok($cli, 'del_environment', 'testing');

    like(
        $tc->stdout,
        qr/testing deleted/,
        'del_environment result ok',
    );
}

done_testing();
