package Venn::CLI::Command::show_container;

use v5.14;

use Venn::CLI::Dependencies;
use Pod::Usage;
use Mouse;
extends qw(Venn::CLI::Command);
with qw(
           Venn::CLI::Role::GenericVerb
           Venn::CLI::Role::RequireSingleKey
           Venn::CLI::Role::Container
  );

sub run {
        my ($self, $container) = @_;

            my $path = sprintf "%s/%s/%s", $self->verb_rest_uri, $self->container_type, $container;

            my $response = $self->submit_to_api($path, 'GET');

            return $self->print_response($response);
    }

no Mouse;
__PACKAGE__->meta->make_immutable;

__DATA__

=head1 NAME

Venn::CLI::Command::show_container - Returns information about a container in Venn

=head1 SYNOPSIS

$ venn show_container <container_type> <name>

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
