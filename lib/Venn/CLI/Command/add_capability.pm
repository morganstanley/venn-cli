package Venn::CLI::Command::add_capability;

use v5.14;

use Venn::CLI::Dependencies;
use Data::Dumper;
use Pod::Usage;
use Mouse;
use MouseX::Types::Mouse qw( Bool );
use Venn::CLI::Types qw( NoEmptyStr );
extends qw(Venn::CLI::Command);

# Shared options and private Mouse attributes
with qw(
    Venn::CLI::Role::GenericVerb
    Venn::CLI::Role::Attribute
    Venn::CLI::Role::RequireSingleKey
);

has '+attribute_type' => ( default => 'capability' );

has 'description' => (
    is            => 'ro',
    isa           => NoEmptyStr,
    required      => 1,
    documentation => 'The description for the capability being added',
);

has 'explicit' => (
    is            => 'ro',
    isa           => Bool,
    documentation => 'This will set the capability as explicit (use --noexplicit to turn this off)',
);

sub run {
    my ($self, $capability) = @_;

    # Determine the full path of the request
    my $path = $self->attribute_path($capability);
    $self->bail_if_exists($path, 'capability');

    my $response = $self->submit_to_api($path, 'PUT', {
        description       => $self->description,
        explicit          => $self->explicit ? 1 : 0,
    });

    # Take the response from the REST request and print it
    return $self->print_response($response);
}

no Mouse;
__PACKAGE__->meta->make_immutable;


__DATA__

=head1 NAME

Venn::CLI::Command::add_capability - Defines a new capability for providers

=head1 SYNOPSIS

$ venn add_capability <capability> [ --description val --[no]explicit ]

=head1 OPTIONS

=over 4

=item B<--description>

A description of the capability

=item B<--explicit>

Marks the capability as explicit (used in placement algorithm)

=item B<--noexplicit>

Marks the capability as non-explicit (used in placement algorithm)

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
