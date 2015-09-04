package Venn::CLI::Role::Environment;

=head1 NAME

Venn::CLI::Role::Environment

=head1 DESCRIPTION

Environment role

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

with qw(
    Venn::CLI::Role::GenericVerb
    Venn::CLI::Role::RequireSingleKey
);

has 'description' => (
    is            => 'ro',
    isa           => NoEmptyStr,
    documentation => 'The description for the environment being added',
);

sub add {
    my ($self, $fields, $environment) = @_;

    my $path = $self->action_path($environment);
    $self->bail_if_exists($path, 'environment');

    die "--description is required!" unless $self->description;

    my %payload = ( description => $self->description );

    for my $key (@$fields) {
        my $accessor = "${key}_overcommit";
        $payload{overcommit}->{$key}  = $self->nullable($self->$accessor) if $self->$accessor;
    }

    my $response = $self->submit_to_api($path, 'PUT', \%payload);

    # Take the response from the REST request and print it
    return $self->print_response($response);
}

sub update {
    my ($self, $fields, $environment) = @_;

    my $path = $self->action_path($environment);
    my $current = $self->get_for_update($path, 'environment');

    my %payload = ( description => $self->description // $current->{description} );

    for my $key (@$fields) {
        my $accessor = "${key}_overcommit";
        $payload{overcommit}->{$key}  = defined $self->$accessor
                                        ? $self->nullable($self->$accessor)
                                        : $current->{overcommit}->{$key};
    }

    my $response = $self->submit_to_api($path, 'PUT', \%payload);

    # Take the response from the REST request and print it
    return $self->print_response($response);
}

1;
