package Venn::CLI::Role::Attribute;

=head1 NAME

Venn::CLI::Role::Attribute

=head1 DESCRIPTION

Attribute role

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

use strict;
use warnings;
use v5.14;

use Mouse::Role;
use Venn::CLI::Types qw( NoEmptyStr );
use Mouse::Util::TypeConstraints;
requires '_build_verb_path';

=head1 OPTIONS

Options for all verbs that are required for Venn attribute operations

=cut

has 'attribute_type' => (
    is            => 'rw',
    isa           => 'Str',
    required      => 1,
    metaclass     => 'NoGetopt',
    documentation => 'Type of attribute',
);

# Set the URI path for this specific verb's role (attribute definition in VerbAttributes.pm)
sub _build_verb_path { return 'attribute' }

sub attribute_path {
    my ($self, $key) = @_;

    return sprintf "%s/%s/%s", $self->verb_rest_uri, $self->attribute_type, $key;
}

1;
