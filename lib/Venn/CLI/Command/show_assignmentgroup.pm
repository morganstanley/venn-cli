package Venn::CLI::Command::show_assignmentgroup;

use v5.14;

use Mouse;
use MouseX::Types::Mouse qw( Bool Str );
extends qw( Venn::CLI::Command );
with qw( Venn::CLI::Role::GenericVerb );

has 'friendly' => (
    is => 'ro',
    isa => Str,
    documentation => 'Show the assignmentgroup for given friendly name',
);

has 'identifier' => (
    is => 'ro',
    isa => Str,
    documentation => 'Show the assignmentgroup for given identifier',
);

has 'with_metadata' => (
    is => 'ro',
    isa => Bool,
    documentation => 'Include metadata for the assignmentgroup',
);

has 'with_assignments' => (
    is => 'ro',
    isa => Bool,
    documentation => 'Include the assignment records for the assignmentgroup',
);

has 'with_assignment_provider' => (
    is => 'ro',
    isa => Bool,
    documentation => 'Include the providers with the assignments (only works with --with_assignments)',
);

augment 'check_options' => sub {
    my ( $self ) = @_;
    #say "+++ Checking verb-specific options...";

    return 1;
};

augment 'execute' => sub {
    my ( $self, undef, $keys ) = @_;

    die "Must provide --friendly or --identifier" unless ( $self->friendly || $self->identifier );

    #Determine the full path of the request
    my $path = sprintf "%s/", $self->verb_rest_uri;
    $path .= 'friendly/' . $self->friendly if $self->friendly;
    $path .= 'identifier/' . $self->identifier if $self->identifier;

    my @params;
    push @params, 'with_assignments=1'         if $self->with_assignments;
    push @params, 'with_assignment_provider=1' if $self->with_assignment_provider;
    push @params, 'with_metadata=1'            if $self->with_metadata;
    $path .= '?' . join('&', @params) if scalar @params;

    my $response = $self->submit_to_api($path, 'GET');

    $self->print_response($response);
};

sub _build_verb_path { return 'assignmentgroup'; }

no Mouse;
__PACKAGE__->meta->make_immutable;

__DATA__

=head1 NAME

Venn::CLI::Command::show_assignmentgroup - Returns information about an assignmentgroup

=head1 SYNOPSIS

show assignmentgroup data:
$ venn show_assignmentgroup [ --friendly $friendlyname | --identifier $identifier ]

=head1 OPTIONS

B<--with_metadata>: include assignmentgroup metadata

B<--with_assignments>: include assignment records that are part of the assignmentgroup

B<--with_assignment_provider>: include assignment provider data (needs --with_assignments)

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
