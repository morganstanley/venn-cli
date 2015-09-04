package Venn::CLI::Role::ProviderAssignmentGroups;

=head1 NAME

Venn::CLI::Role::ProviderAssignmentGroups

=head1 DESCRIPTION

Provider Assignment Groups role

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
use MouseX::Types::Mouse qw( Bool );

=head1 PRIVATE ATTRIBUTES

Options that are common to providers that support assignmentgroup options actions

=cut

has 'assignmentgroup' => (
    is            => 'ro',
    isa           => Bool,
    documentation => 'Display the assignmentgroups for this provider',
);

has 'assignmentgroup_metadata' => (
    is            => 'ro',
    isa           => Bool,
    documentation => 'Display the assignmentgroups with metadata for this provider',
);

around 'action_path' => sub {
    my $orig = shift;
    my $self = shift;

    my $action_path = $self->$orig(@_);

    return $action_path . '/assignmentgroup?with_metadata=1' if $self->assignmentgroup_metadata;
    return $action_path . '/assignmentgroup' if $self->assignmentgroup;
    return $action_path;
};

1;
