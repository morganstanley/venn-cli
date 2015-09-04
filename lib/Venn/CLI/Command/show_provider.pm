package Venn::CLI::Command::show_provider;

use v5.14;

use Venn::CLI::Dependencies;
use Pod::Usage;
use Mouse;
extends qw(Venn::CLI::Command);
with qw(
           Venn::CLI::Role::GenericVerb
           Venn::CLI::Role::Provider
           Venn::CLI::Role::RequireSingleKey
   );

sub run {
        my ($self, $key) = @_;

            # Determine the full path of the request
            my $path;
            # Three scenarios:
            # 1.) List all providers of all types
            # 2.) List all providers of a specific type
            # 3.) List all providers of a specific type with a specific name (key)
        if ($self->provider_type eq 'all') {
                    # User wants all providers of any type to be returned
                    $path = $self->verb_rest_uri;
                }
        elsif (defined $self->provider_type && $self->provider_type ne 'all' && $key eq '') {
                    # user has specified a specific provider type but no specific key, so they want all providers of that type
                    $path = sprintf "%s/%s", $self->verb_rest_uri, $self->provider_type;
                }
        elsif (defined $self->provider_type && $self->provider_type ne 'all' && defined $key) {
                    # user has specified provider type and key, so do a specific search for that entity
                    $path = sprintf "%s/%s/%s", $self->verb_rest_uri, $self->provider_type, $key;
                }
            else {
                        # we should not be here...
                        die "ERROR: Unexpected combination of params were passed to ".$self->verb_path;
                    }

            my $response = $self->submit_to_api($path, 'GET');

            return $self->print_response($response);
    }

no Mouse;
__PACKAGE__->meta->make_immutable;

__DATA__

=head1 NAME

Venn::CLI::Command::show_provider - Returns information about a provider

=head1 SYNOPSIS

$ venn show_provider all

$ venn show_provider <provider_type>

$ venn show_provider <provider_type> <provider_name>

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
