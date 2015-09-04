package Venn::CLI;

=head1 NAME

Venn::CLI - Base class for the CLI

=head1 DESCRIPTION

This class provides the ability to specify global options that are common to all subcommands.
To specify global options, override global_opt_spec subroutine with an arrayref of hashes.
Format: Key is the name of the flag in GetOptions format, and the value is the usage description of the option.

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

our $VERSION = '0.0.2';

use v5.14;

use Pod::Usage;
use Data::Dumper;
use Mouse;
extends qw(MouseX::App::Cmd);
use namespace::autoclean;

=head1 METHODS

=head2 global_opt_spec()

Loads into $self->app->global_options

=cut

sub global_opt_spec {
    return (
        [ "help"    => "Display a command's full help" ],
        [ "env=s"   => 'Environment of execution (dev/qa/prod)' ],
        [ "dryrun"  => 'Generate the URI for the request, but do not execute the request' ],
    );
}

=head2 plugin_search_path()

Returns an arrayref of namespaces to search for commands.
This is passed directly into Module::Pluggable::Object.

=cut

sub plugin_search_path {
    return [
        "Venn::CLI::Command", # generic commandset
        "Venn::CLI::ExtraCommand", # implementation-specific commandset
    ];
}

=head1 AUTHOR

Venn Engineering

=cut

no Mouse;
__PACKAGE__->meta->make_immutable;
