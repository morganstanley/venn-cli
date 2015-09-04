package Venn::CLI::Role::Mapping;

=head1 NAME

Venn::CLI::Role::Mapping

=head1 DESCRIPTION

Mapping role

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
use Mouse::Util::TypeConstraints;
use MouseX::Types::Mouse qw( Str ArrayRef );

with qw(
    Venn::CLI::Role::URIEscape
);

has '+provider_type' => (
    required      => 0,
);

has 'primary_field' => (
    is            => 'ro',
    isa           => Str,
    documentation => 'The primary field of the provider',
);

sub is_mapped {
    my ($self, $cli_type, $provider_type, $primary_field, $attribute_type, $attribute_value) = @_;

    $self->verbose_message("Checking if %s: %s is already mapped to %s: %s (%s)",
        $attribute_type, $attribute_value, $cli_type, $primary_field, $provider_type);

    my $path = sprintf "%s/%s/%s/%s/%s", $self->verb_rest_uri, $provider_type, $primary_field,
        $attribute_type, $self->uri_escape_string($attribute_value);

    my $response = $self->submit_to_api($path, 'GET');

    return $response->is_success;
}

## no critic (RequireArgUnpacking)
sub map_attribute {
    my $self = shift;
    my ($cli_type, $provider_type, $primary_field, $attribute_type, $attribute_value) = @_;

    if ($self->is_mapped(@_)) {
        $self->verbose_message("%s: %s is already mapped to %s: %s (%s)",
            $attribute_type, $attribute_value, $cli_type, $primary_field, $provider_type);
        return 1;
    }

    $self->verbose_message("Mapping %s: %s to %s: %s (%s)", $attribute_type, $attribute_value,
        $cli_type, $primary_field, $provider_type);

    my $path = sprintf "%s/%s/%s/%s/%s", $self->verb_rest_uri, $provider_type, $primary_field,
        $attribute_type, $self->uri_escape_string($attribute_value);

    my $response = $self->submit_to_api($path, 'PUT');

    if (! $response->is_success) {
        my $reason = $self->parse_response($response);
        $self->error_message("Unable to map %s: %s to %s: %s (%s): %s", $attribute_type, $attribute_value,
            $cli_type, $primary_field, $provider_type, $reason->{error});
        $self->debug_message("Code: %s\nContent: %s", $response->code, $response->decoded_content);
    }
    return 1;
}
## use critic (RequireArgUnpacking)

sub unmap_attribute {
    my ($self, $cli_type, $provider_type, $primary_field, $attribute_type, $attribute_value) = @_;

    $self->verbose_message("Unmapping %s: %s from %s: %s (%s)", $attribute_type, $attribute_value,
        $cli_type, $primary_field, $provider_type);

    my $path = sprintf "%s/%s/%s/%s/%s", $self->verb_rest_uri, $provider_type, $primary_field,
        $attribute_type, $self->uri_escape_string($attribute_value);

    my $response = $self->submit_to_api($path, 'DELETE');

    if (! $response->is_success) {
        my $reason = $self->parse_response($response);
        $self->error_message("Unable to unmap %s: %s from %s: %s (%s): %s", $attribute_type, $attribute_value,
            $cli_type, $primary_field, $provider_type, $reason->{error});
        $self->debug_message("Code: %s\nContent: %s", $response->code, $response->decoded_content);
    }
    return 1;
}

sub handle_all {
    my ($self, $type, $attribute_type, $attribute_value) = @_;

    my $method = $type . "_attribute";
    die "Cannot perform $method\n" unless $self->can($method);

    die "abstract, $method dhould be implemented for providers";

    # like:
    # my @clusters = $self->cluster ? @{$self->cluster} : ();
    # for my $cluster (@clusters) {
    #    $self->$method('cluster', 'cpu', $cluster, $attribute_type, $attribute_value);
    #    $self->$method('cluster', 'ram', $cluster, $attribute_type, $attribute_value);
    # }
}

1;
