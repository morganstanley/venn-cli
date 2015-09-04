package Venn::CLI::Command::add_provider;

use v5.14;

use Venn::CLI::Dependencies;
use Data::Dumper;
use Pod::Usage;
use Mouse;
use Venn::CLI::Types qw( NoEmptyStr );
extends qw(Venn::CLI::Command);
with qw(
           Venn::CLI::Role::GenericVerb
           Venn::CLI::Role::Provider
  );

has 'available_date' => (
        is => 'ro',
            isa => NoEmptyStr,
            #required  => 1,
            documentation => 'The date at which this new provider can be considered by the placement engine as usable (MMDDYYYY)',
            trigger => sub {
                        my ($self, $date_string) = @_;
                                $self->{available_date} = $self->parse_date($date_string);
                                return;
                            }
              );

has 'size' => (
        is => 'ro',
            isa => NoEmptyStr,
            #required  => 1,
            documentation => 'The size of the new provider (units may vary per provider_type)',
        );

has 'overcommit_ratio' => (
        is => 'ro',
            isa => NoEmptyStr,
            #required  => 1,
            documentation => 'The ratio by which the new provider can be over-allocated',
        );

sub run {
        my ( $self, $key ) = @_;

            my $path = sprintf "%s/%s/%s", $self->verb_rest_uri, $self->provider_type, $key;
            $self->bail_if_exists($path, 'provider');

            my $response = $self->submit_to_api($path, 'PUT', {
                        providertype_name  => $self->provider_type,
                                available_date     => $self->available_date,
                                size               => $self->size,
                                overcommit_ratio   => $self->overcommit_ratio,
                            });

            return $self->print_response($response);
    }

no Mouse;
__PACKAGE__->meta->make_immutable;

__DATA__

=head1 NAME

Venn::CLI::Command::add_provider - Defines a new provider in Venn

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

=end
