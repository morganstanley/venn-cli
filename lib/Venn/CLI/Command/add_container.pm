package Venn::CLI::Command::add_container;

use v5.14;

use Venn::CLI::Dependencies;
use Pod::Usage;
use Mouse;
use Venn::CLI::Types qw( NoEmptyStr );
extends qw(Venn::CLI::Command);
with qw(
           Venn::CLI::Role::GenericVerb
           Venn::CLI::Role::Container
  );

has 'organization' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Organization, used for location',
        );

has 'hub' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Hub, used for location',
        );

has 'continent' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Continent, used for location',
        );

has 'country' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Organization, used for location',
        );

has 'campus' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Organization, used for location',
        );

has 'city' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Organization, used for location',
        );

has 'building' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Organization, used for location',
        );

has 'rack_name' => (
        is   => 'ro',
            isa  => NoEmptyStr,
            #required   => 1,
            documentation => 'Rack for the filer',
        );

sub run {
        my ( $self, $key ) = @_;

            my $path = sprintf "%s/%s/%s", $self->verb_rest_uri, $self->container_type, $key;
            $self->bail_if_exists($path, 'container');

            my $response = $self->submit_to_api($path, 'PUT', {
                        organization =>  $self->organization,
                                hub          =>  $self->hub,
                                continent    =>  $self->continent,
                                country      =>  $self->country,
                                campus       =>  $self->campus,
                                city         =>  $self->city,
                                building     =>  $self->building,
                                rack_name    =>  $self->rack_name,
                            });

            return $self->print_response($response);
    }

no Mouse;
__PACKAGE__->meta->make_immutable;

__DATA__

=head1 NAME

Venn::CLI::Command::add_container - Defines a new container in Venn

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
