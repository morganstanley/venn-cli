package Venn::CLI::Command::show_capability;

use v5.14;

use Venn::CLI::Dependencies;
use Data::Dumper;
use Pod::Usage;
use Mouse;
use Venn::CLI::Types qw( NoEmptyStr );
extends qw(Venn::CLI::Command);

# Shared options and private Mouse attributes
with qw(
    Venn::CLI::Role::GenericVerb
    Venn::CLI::Role::Attribute
    Venn::CLI::Role::RequireSingleKey
);

has '+attribute_type' => ( default => 'capability' );

sub run {
    my ($self, $capability) = @_;

    my $response = $self->submit_to_api($self->attribute_path($capability), 'GET');

    # Take the response from the REST request and print it
    return $self->print_response($response);
}

no Mouse;
__PACKAGE__->meta->make_immutable;


__DATA__

=head1 NAME

Venn::CLI::Command::show_capability - Shows information about a capability

=head1 SYNOPSIS

$ venn show_capability <capability>

=head1 OPTIONS

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
