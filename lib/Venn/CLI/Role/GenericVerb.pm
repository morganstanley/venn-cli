package Venn::CLI::Role::GenericVerb;

=head1 NAME

Venn::CLI::Role::GenericVerb

=head1 DESCRIPTION

Generic Verb role

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
use Venn::CLI::Types qw( NoEmptyStr );

=head1 OPTIONS

Options for all verbs that are required for generic Venn operations

=cut

has 'output_format' => (
    is            => 'ro',
    isa           => enum([qw/ yaml json dumper /]),
    documentation => 'Format of the results returned by the API (yaml/json/dumper, default==yaml))',
    default       => 'yaml',
);

=head1 PRIVATE ATTRIBUTES

Private attributes that are associated with generic Venn operations

=cut

has 'verb_path' => (
    is              => 'ro',
    isa             => NoEmptyStr,
    metaclass       => 'NoGetopt',
    lazy            => 1,
    builder         => '_build_verb_path',
    documentation   => 'Base attribute for api verb (set by builder in verb-specific role)',
    # default is located in verb-specific role (e.g. Role::ProviderAttributes)
);

has 'verb_rest_uri' => (
    is              => 'ro',
    isa             => NoEmptyStr,
    metaclass       => 'NoGetopt',
    lazy            => 1,
    builder         => '_build_verb_rest_uri',
    documentation   => 'Core path for verb-specific REST calls',
);

sub _build_verb_rest_uri {
    my ($self) = @_;

    return sprintf "%s/%s/%s", $self->api_broker, $self->api_version, $self->verb_path;
}

=head2 sub get_for_update($path, $resourcename)

Generic test before updating a resource, to confirm that it  exists.
Returns the object.

=cut

sub get_for_update {
    my ($self, $path, $resourcename) = @_;
    return 1 if $ENV{VENN_URI_TESTS};

    my $obj = $self->submit_to_api($path, 'GET');
    die "$resourcename doesn't exist. Use add.\n" if $obj->code == 404;
    die "Service unavailable - please escalate to venn_dev\n" if $obj->code == 503 || $obj->code == 500;
    die "The request to locate the target object of the update was unsuccessful - please escalate to venn_dev.\n" unless $obj->is_success;
    return $self->parse_response($obj->decoded_content);
}

=head2 sub bail_if_exists($path, $resourcename)

Generic test before adding a resource, to confirm that it doesn't already exist.

=cut

sub bail_if_exists {
    my ($self, $path, $resourcename) = @_;

    return 1 if $ENV{VENN_URI_TESTS};
    my $get_test = $self->submit_to_api($path, 'GET');
    die "$resourcename already exists. Use update.\n" if $get_test->is_success;
    return 1;
}

1;
