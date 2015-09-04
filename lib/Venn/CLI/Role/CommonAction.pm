package Venn::CLI::Role::CommonAction;

=head1 NAME

Venn::CLI::Role::CommonAction

=head1 DESCRIPTION

Common Action role

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

=cut

use v5.14;

use Mouse::Role;
use Venn::CLI::Types qw( NoEmptyStr );
use Mouse::Util::TypeConstraints;

with 'Venn::CLI::Role::Action';

=head1 PRIVATE ATTRIBUTES

Options that are common to virt-related actions

=cut

has '+action_type' => (
    isa           => enum([qw[ personality environment ]]),
    documentation => 'Type of action (personality/environment)',
);

# Set the URI path for this specific verb's role (attribute definition in VerbAttributes.pm)
sub _build_verb_path { return 'action/common' }

1;
