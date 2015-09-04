package VennCLIBuildPL;

use strict;
use warnings;
use Module::Build;

use lib qw(lib);
use Venn::CLI::Dependencies;
BEGIN { eval { require Venn::CLI::LocalBuild; Venn::CLI::LocalBuild->import }; }

my $fake_builder = Module::Build->new(module_name => 'Venn::CLI');
my @actions = $fake_builder->known_actions;
my @code;
for my $action (@actions) {
    push @code, sprintf(
        'sub ACTION_%s { BEGIN { eval { require Venn::CLI::LocalBuild; Venn::CLI::LocalBuild->import }; } $_[0]->SUPER::ACTION_%s }',
        $action, $action);
}

my $class = Module::Build->subclass(
    class => 'Module::Build::Venn::CLI',
    code => join("\n", @code),
);

my $builder = $class->new(
    module_name         => 'Venn::CLI',
    license             => 'perl',
    dist_author         => 'Venn Engineering <venn_dev@morganstanley.com>',
    dist_version_from   => 'lib/Venn/CLI.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Venn::*' ],
    create_makefile_pl => 'traditional',
    requires => \%Venn::CLI::Dependencies::DEPENDENCIES,
    bin_files => { 'bin/venn' => 'bin/venn' },
);
$builder->add_build_element('bin');
$builder->add_build_element('etc');

$builder->create_build_script();
