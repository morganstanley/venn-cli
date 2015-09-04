package Venn::CLI::Command::help;

use v5.14;

use Venn::CLI::Dependencies;
use Data::Dumper;
use Pod::Usage;
use Mouse;
extends qw(Venn::CLI::Command);

sub run {
    my ($self, $key) = @_;

    if ($key) {
        my ($cmd, $opt, $args) = $self->app->prepare_command($key);
        say $cmd->show_help;
    }
    else {
        my $usage = $self->app->usage->text;
        my $command = $0;

        # chars normally used to describe options
        my $opt_descriptor_chars = qr/[\[\]<>\(\)]/;

        if ($usage =~ /^(.+?) \s* (?: $opt_descriptor_chars | $ )/x) {
            # try to match subdispatchers too
            $command = $1;
        }

        # evil hack ;-)
        bless
          $self->app->{usage} = sub { return "$command help <command>\n" }
          => "Getopt::Long::Descriptive::Usage";

        $self->app->execute_command( $self->app->_prepare_command("commands") ); ## no critic (ProtectPrivateSubs)
    }
    return;
}

sub command_names {
    return qw/help --help/;
}

sub description {
    return "This command will either list all of the application commands and their " .
           "abstracts, or display the usage screen for a subcommand with its " .
           "description.\n";
}


no Mouse;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Venn::CLI::Command::help - Venn CLI Help

=head1 SYNOPSIS

$ venn help

$ venn help <command>

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
