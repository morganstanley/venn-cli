package Venn::CLI::Command::add_environment;

use v5.14;

use Mouse;
use Venn::CLI::Types qw( NoEmptyStr );
extends qw(Venn::CLI::Command);

with qw(
    Venn::CLI::Role::Environment
    Venn::CLI::Role::CommonAction
);

has '+action_type' => ( default => 'environment' );

has 'esxcpu_overcommit' => (
    is            => 'ro',
    isa           => NoEmptyStr,
    documentation => 'Overcommit value for the CPU of clusters having this environment',
);

has 'esxram_overcommit' => (
    is            => 'ro',
    isa           => NoEmptyStr,
    documentation => 'Overcommit value for the memory of clusters having this environment',
);

has 'filerio_overcommit' => (
    is            => 'ro',
    isa           => NoEmptyStr,
    documentation => 'Overcommit value for filers having this environment',
);

has 'nas_overcommit' => (
    is            => 'ro',
    isa           => NoEmptyStr,
    documentation => 'Overcommit value for shares having this environment',
);

sub run {
    my ($self, $environment) = @_;

    return $self->add(
        [qw(
            esxcpu
            esxram
            filerio
            nas
        )],
        $environment,
    );
}

no Mouse;
__PACKAGE__->meta->make_immutable;


__DATA__

=head1 NAME

Venn::CLI::Command::add_environment - Defines a new environment for providers

=head1 SYNOPSIS

$ venn add_environment <environment> [--description val]

=head1 OPTIONS

=over 4

=item B<--description>

A description of the environment

=item B<--esxcpu_overcommit>

Overcommit value for the CPU of clusters having this environment

=item B<--esxram_overcommit>

Overcommit value for the memory of clusters having this environment

=item B<--nas_overcommit>

Overcommit value for shares having this environment

=item B<--filerio_overcommit>

Overcommit value for filers having this environment

=back

=head1 AUTHOR

Venn Engineering

Josh Arenberg, Norbert Csongradi, Ryan Kupfer, Hai-Long Nguyen

=head1 LICENSE

Copyright 2013,2014,2015 Morgan Stanley

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end
