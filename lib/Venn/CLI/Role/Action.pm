package Venn::CLI::Role::Action;

=head1 NAME

Venn::CLI::Role::Action

=head1 DESCRIPTION

Action role

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
with qw(Venn::CLI::Role::URIEscape);
requires '_build_verb_path';

=head1 PRIVATE ATTRIBUTES

Options that are common to all compound action verbs

=cut

has 'action_type' => (
    is            => 'ro',
    required      => 1,
    metaclass     => 'NoGetopt', # Note that unlike other more 'generic' verbs,
                                 # this attribute is set automatically based on
                                 # the verb used
    documentation => 'Type of action',
);

=head2 action_path($key)

Builds the URI for an action, $key is optional

=cut

sub action_path {
    my ($self, @args) = @_;

    return join '/',
      $self->verb_rest_uri,
      $self->action_type,
      map {$self->uri_escape_string($_)} @args,
      ;
}

=head2 action_search_path(\%search_params)

Builds the search URI for an action

=cut

sub action_search_path {
    my ($self, $search_params) = @_;

    my $escaped_params = $self->uri_escape($search_params) // '';

    return sprintf "%s/%s%s",
      $self->verb_rest_uri,
      $self->action_type,
      $escaped_params,
      ;
}

1;
