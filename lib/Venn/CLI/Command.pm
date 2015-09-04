package Venn::CLI::Command;

=head1 NAME

Venn::CLI::Command - Base class for all CLI subcommands

=head1 DESCRIPTION

This class provides option and attribute definitions that are common to all subcommands.
NOTE: This is NOT where global options are specified (please see Venn::CLI for that)

=cut

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
use warnings;

use Mouse;
use namespace::autoclean;
use FindBin;
use Try::Tiny;
use Data::Dumper;
use Pod::Usage;
use Pod::Find qw(pod_where);
use Venn::CLI::Types qw( NoEmptyStr );
use Text::ASCIITable;
use Text::ASCIITable::Wrap qw( wrap );
use JSON::XS ();
use YAML::XS ();
use LWP::UserAgent;
use Time::ParseDate;
use Scalar::Util qw( reftype );
extends 'MouseX::App::Cmd::Command';
with qw( Venn::CLI::Role::API
         Venn::CLI::Role::ConfigLoader
);

=head1 COMMON OPTIONS

These options are common to all subcommands (not to be confused with global options)

=cut

has '+configfile' => (
    default => \&_build_configfile, # NOTE: A builder construct cannot be used here
);

=head1 COMMON ATTRIBUTES

These attributes options are common to (and inherited by) all subcommands

=cut

has 'default_exit_code' => (
    is            => 'rw',
    isa           => 'Str',
    metaclass     => 'NoGetopt',
    documentation => 'Stores the default exit code that is returned to the user in the event that the HTTP response has no mapping',
);

has 'exit_code_mappings' => (
    is            => 'rw',
    isa           => 'HashRef',
    metaclass     => 'NoGetopt',
    documentation => 'Stores the mappings of HTTP response code => client exit code',
);

has 'webapp_prefix' => (
    is            => 'rw',
    isa           => NoEmptyStr,
    metaclass     => 'NoGetopt',
    documentation => 'Stores the prefix used in the webapp URI path',
    default       => 'venn',
);

has 'verb' => (
    is              => 'ro',
    isa             => 'Str',
    metaclass       => 'NoGetopt',
    documentation   => 'A quick way to find the verb name for the executing action',
    default         => sub {
        my $self = shift;
        my @verb = split('::',ref($self));
        return $verb[3];
    }
);


=head1 METHODS

=head2 check_options()

=cut

sub check_options {
    my ( $self ) = @_;

    $self->debug_message("Checking global options...");
    if (!$self->api_environment) {
        say "No environment was found";
    }

    # Check the verb-specific options
    try {
        inner();
    } catch {
        die "ERROR: Verb-Specific Options: $_\n";
    };
    return 1;
}

=head2 show_help()

Prints the POD for the current command.

=cut

sub show_help {
    my ($self) = @_;

    pod2usage({
        exitval  => 1,
        -verbose => 99,
        -input => pod_where({ -inc => 1 }, ref $self),
    });
    return;
}

=head2 execute()

Augment me for functionality
Checks for --help or -h before executing

=cut

## no critic (RequireArgUnpacking)
sub execute {
    my $self = shift;
    my ( undef, $keys ) = @_;

    $self->show_help if $self->app->global_options->help;

    # check global options, and make sure we have one (and only one) key
    if ( $self->check_options() && $self->check_keys($keys) ) {
        try {
            if ($self->can('run')) {
                my @args = @$keys;
                $self->run(@args);
            }
            else {
                # Magic is here! This calls the augmented execute subroutine in the child.
                inner();
            }
        }
        catch {
            warn "ERROR: $_";
        };
    }

    if ($self->last_response) {
        exit $self->exit_code_mappings->{$self->last_response->code} // $self->default_exit_code;
    }
    exit 0;
}
## use critic (RequireArgUnpacking)

=head2 parse_date($date_string)

Takes the user-provided date string and converts it to a format that the API is expecting

=cut

sub parse_date {
    my ($self, $date_string) = @_;

    my $epoch_time = parsedate(
        $date_string,
        WHOLE => 1,
        DATE_REQUIRED => 1,
        VALIDATE => 1,
        PREFER_FUTURE => 1,
    );
    if (!$epoch_time) {
        die "Unable to parse date \"$date_string\"\n";
    } else {
        $self->debug_message("Time converted to %d", $epoch_time);
    }
    return $epoch_time;
}

=head2 nullable($val)

Allows passing NULL as an option to mean undefined.

=cut

sub nullable {
    my ($self, $value) = @_;

    $value = undef if (defined $value && ($value =~ /^null$/i || $value eq '~'));
    return $value;
}

=head2 check_keys(\@keys)

Default check_keys (no action)

=cut

sub check_keys {
    my ( $self, $keys_array_ref ) = @_;

    return 1;
}

=head2 to_array_ref($string)

Helper method to convert comma-delimited lists to array refs

=cut

sub to_array_ref {
    my ($self, $string) = @_;

    # return undef if argument-less, for payload similfication mapping to work properly in the CLI
    return undef if !$string; ## no critic (Subroutines::ProhibitExplicitReturnUndef)

    my @tmp = split(/,/,$string);
    return \@tmp;
}

=head2 _build_configfile()

Builds up the path for the config file, based on the directory of execution

=cut

sub _build_configfile {
    my ($self) = @_;
    if ( -r "$FindBin::Bin/../etc/cli/config.yml" ) {
        # For most scenarios whereby the CLI is run from bin
        return "$FindBin::Bin/../etc/cli/config.yml";
    } else {
        # For tests (primarily), 'bin' is different...so change the location of the config file
        return "$FindBin::Bin/../../etc/cli/config.yml";
    }
}
=head1 AUTHOR

Venn Engineering

=cut

no Mouse;
__PACKAGE__->meta->make_immutable;
