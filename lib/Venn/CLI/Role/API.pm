package Venn::CLI::Role::API;

=head1 NAME

Venn::CLI::Role::API - Role to support API submission operations

=head1 DESCRIPTION

This class has been extracted from Venn::CLI::Command to allow creation
of a standalone client library for Venn without duplicating code.

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
use MouseX::Getopt qw( NoGetopt );
use Venn::CLI::Types qw( NoEmptyStr );

use YAML::XS;
use Data::Dumper;

has 'debug' => (
    is            => 'ro',
    isa           => 'Bool',
    metaclass     => 'NoGetopt',
    documentation => 'Display diagnostic information',
);

has 'ua' => (
    is            => 'rw',
    isa           => 'LWP::UserAgent',
    metaclass     => 'NoGetopt',
    lazy          => 1,
    builder       => '_build_ua',
    documentation => 'LWP::UserAgent instance for API interaction',
);

=head1 COMMON ATTRIBUTES

These attributes options are common to (and inherited by) all subcommands

=cut

has 'api_environment' => (
    is            => 'rw',
    isa           => NoEmptyStr,
    metaclass     => 'NoGetopt',
    builder       => '_build_api_environment',
    documentation => 'Environment of execution (derived from, and not to be confused with, global option <env>)',
);

has 'api_broker' => (
    is            => 'rw',
    isa           => NoEmptyStr,
    metaclass     => 'NoGetopt',
    lazy          => 1, # needed because other attributes are used in the creation of this attribute
    builder       => '_build_api_broker',
    documentation => 'Base path for the Venn REST API',
);

has 'rest_timeout' => (
    is            => 'rw',
    isa           => 'Int',
    metaclass     => 'NoGetopt',
    documentation => 'Timeout for the REST connection',
);

has 'api_version' => (
    is            => 'rw',
    isa           => NoEmptyStr,
    metaclass     => 'NoGetopt',
    default       => 'v1',
    documentation => 'Stores the version of the REST API',
);

has 'last_response'    => (
    is            => 'rw',
    metaclass     => 'NoGetopt',
    documentation => 'UA response object',
);

=head2 _build_ua()

Builds the UserAgent object

=cut

sub _build_ua {
    my ( $self ) = @_;

    my $ua = LWP::UserAgent->new();
    $ua->timeout($self->rest_timeout);
    $ua->env_proxy;

    return $ua;
}

=head2 _build_api_environment()

Builds the environment/scope of execution based on CWD and is overrideable with user args.

=cut

sub _build_api_environment {
    my ( $self ) = @_;

    # this allows us to create env mappings. e.g. if you only have
    # dev and prod, you could map qa -> dev here.
    my $final_environment;
    my $env = $self->can('app') ? ($self->app->global_options->env // '') : '';
    given ($env) {
        when (/^(?:dev|qa|uat|prod)$/) {
            # environment must have been valid
            if ($self->app->global_options->env eq 'uat') {
                # overridden for the time being that we do not have qa infra
                $self->debug_message("UAT is currently mapped to QA, changing environment...");
                $final_environment = 'qa';
            }
            else {
                $final_environment = $self->app->global_options->env;
            }
        }
        default {
            $self->debug_message("Defaulting to dev based on execution path");
            $final_environment = 'dev';
        }
    }

    return $final_environment;
}

=head2 _build_api_broker()

Generates the URI for the API endpoint

=cut

sub _build_api_broker {
    my ( $self ) = @_;

    # TODO: move to config

    return sprintf("%s/api", $ENV{VENN_SERVER}) if $ENV{VENN_SERVER};

    my ($host, $port, $prefix);
    my $virtual = $0 =~ /venn_farm/ ? 'venn-farm' : 'virtual';
    given ($self->api_environment // '') {
        when (/prod/) {
            $host   = $ENV{VENN_HOST}   // "$virtual.webfarm.ms.com";
            $port   = $ENV{VENN_PORT}   // 80;
            $prefix = $ENV{VENN_PREFIX} // $self->webapp_prefix;
        }
        when (/qa/) {
            $host   = $ENV{VENN_HOST}   // "$virtual.webfarm-qa.ms.com";
            $port   = $ENV{VENN_PORT}   // 80;
            $prefix = $ENV{VENN_PREFIX} // $self->webapp_prefix;
        }
        default {
            # Default to dev conditions (always override-able by the the env variables)
            $host   = $ENV{VENN_HOST}
                // qx( /bin/hostname --fqdn ) // 'localhost'; ## no critic (ProhibitBacktickOperators)
            chomp $host;
            $port   = $ENV{VENN_PORT}   // $self->_find_dev_port // 3000;
            $prefix = $ENV{VENN_PREFIX} // undef;
        }
    }
    my $broker  = "http://$host";
    $broker    .= ":$port"   if $port;
    $broker    .= "/$prefix" if $prefix;
    $self->debug_message("Using %s broker: %s", $self->api_environment, $broker);

    return $broker . '/api';
}

=head2 _find_dev_port

Finds the port the dev server is running on.

=cut

sub _find_dev_port {
    my ($self) = @_;

    my $ps = qx( ps uxww ); ## no critic (ProhibitBacktickOperators)
    if ($ps =~ /venn_server\.pl.*-p (\d+)/) {
        return $1 if $1 >= 1024 && $1 <= 65535;
    }
    return;
}

=head2 submit_to_api($path, $http_method, $payload)

Submits a payload to the API path using the given http_method.

This will set the Content-Type HTTP header, requesting a certain
output format (ascii, json, yaml, etc.)

=cut

sub submit_to_api {
    my ($self, $path, $http_method, $payload) = @_;

    my $content_type = 'application/json';

    # Ensure that we don't pass undefined arguments as 'undef' to the API
    my $simplified_payload_json;
    if ($payload) {
        my %simplified_payload = map { defined $payload->{$_} ? ( $_ => $payload->{$_} ) : () } keys %$payload;
        $simplified_payload_json = $self->hash2json(\%simplified_payload);
        $self->debug_message("JSON-Encoded Payload: %s", $simplified_payload_json);
    }

    $self->verbose_message("%s => %s", $http_method, $path);
    exit 0 if
      $self->can('app') && $self->app->global_options->dryrun; # Don't execute the request if we're doing a dryrun

    # API does not support POST requests (PUT is used for both insert and update)
    my $response;
    given ($http_method) {
        when (/^GET$/i)    { $response = $self->ua->get($path,
                             'Content-Type' => $content_type); }
        when (/^POST$/i)   { $response = $self->ua->post($path,
                             'Content-Type' => $content_type,
                             'Content' => $simplified_payload_json); }
        when (/^PUT$/i)    { $response = $self->ua->put($path,
                             'Content-Type' => $content_type,
                             'Content' => $simplified_payload_json); }
        when (/^DELETE$/i) { $response = $self->ua->delete($path,
                             'Content-Type' => $content_type); }
        default            { die "Invalid http request type passed to submit_to_api()"; }
    }

    $self->debug_message("Code: %s\nContent: %s", $response->code, $response->decoded_content);

    return $self->last_response($response);
}

=head2 parse_response($response)

Parses the response from the server. We always expect JSON back now.

=cut

sub parse_response {
    my ($self, $response) = @_;

    if (blessed $response && $response->isa('HTTP::Response')) {
        $response = $response->decoded_content;
    }

    my $parsed_data = eval { JSON::XS::decode_json($response) };
    if ($@) {
        $self->debug_message("Unexpected response: %s", $response);
        die "Unable to parse response from the server $@\n";
    }

    return $parsed_data;
}

=head2 print_response($response, $dataroot)

Outputs the response from the API based on the requested output formatting.
Optionally, takes a second argument (string) that is is the root of the data being extracted for printing.
    Requested format: $self->output_format

=cut

sub print_response {
    my ($self, $response, $dataroot) = @_;

    # The request has failed for some reason, but we're expecting a failure payload
    if (! $response->is_success) {
        warn $response->status_line . "\n" if $self->debug;
    }

    my $raw_content = $response->decoded_content;
    die "No failure data payload was returned from the API\n" unless $raw_content;

    $self->debug_message("Results: %s", Dumper($raw_content));

    my $data = $self->parse_response($response);

    given ($self->output_format // '') {
        when (/^yaml$/) { print YAML::XS::Dump($data); }
        when (/^json$/) { print JSON::XS::encode_json($data); }
        when (/^dumper$/) { say Dumper($data); }
        default {
            die 'Invalid output format specified';
        }
    }
    return;
}

=head2 hash2json(\%hash)

Converts a hash to json.

=cut

sub hash2json {
    my ($self, $hash) = @_;

    my $coder = JSON::XS->new->ascii->allow_nonref;
    my $encoded_data = $coder->encode($hash);
    return $encoded_data;
}

=head2 debug_message($message_format, @args)

Print a debug message.

=cut

sub debug_message {
    my ($self, $message_format, @args) = @_;
    say sprintf("+++ " . $message_format, @args) if $self->debug;
    return;
}

=head2 verbose_message($message_format, @args)

Print a verbose message.

=cut

sub verbose_message {
    my ($self, $message_format, @args) = @_;
    say STDERR sprintf($message_format, @args); # if $self->verbose;
    return;
}

=head2 error_message($message_format, @args)

Prints an error message to STDERR

=cut

sub error_message {
    my ($self, $message_format, @args) = @_;
    say STDERR sprintf($message_format, @args);
    return;
}

1;
