package Venn::CLI::Command::map_capability;

use v5.14;

use Mouse;
extends qw(Venn::CLI::Command);
with qw(
    Venn::CLI::Role::GenericVerb
    Venn::CLI::Role::Provider
    Venn::CLI::Role::Mapping
);

sub run {
    my ($self, $capability) = @_;

    return $self->handle_all('map', 'capability', $capability);
}

no Mouse;
__PACKAGE__->meta->make_immutable;

__DATA__

=head1 NAME

Venn::CLI::Command::map_capability - Maps a capability to providers

=head1 SYNOPSIS

$ venn map_capability <capability> [--option val ...]

=head1 OPTIONS

=over 4

=item B<--provider_type>

Provider type (cpu, ram, ...)

Must be used in conjunction with --primary_field

=item B<--primary_field>

The primary field of the given provider_type (e.g. if ram, then the name of the cluster)

Must be used in conjunction with --provider_type

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
