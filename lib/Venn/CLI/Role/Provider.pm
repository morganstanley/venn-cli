package Venn::CLI::Role::Provider;

=head1 NAME

Venn::CLI::Role::Provider

=head1 DESCRIPTION

Provider role

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
use Mouse::Util::TypeConstraints;
requires '_build_verb_path';

=head1 OPTIONS

Options for all verbs that are required for generic Venn operations

=cut

has 'provider_type' => (
    is            => 'rw',
    isa           => 'Str',
    required      => 1,
    documentation => 'Type of provider',
);

# Set the URI path for this specific verb's role (attribute definition in VerbAttributes.pm)
sub _build_verb_path { return 'provider' }

1;
