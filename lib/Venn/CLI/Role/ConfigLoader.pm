package Venn::CLI::Role::ConfigLoader;

=head1 NAME

Venn::CLI::Role::ConfigLoader

=head1 DESCRIPTION

This role is used by MouseX::ConfigFromFile abstract role extension to parse a YAML config
file and apply it to the defined attributes of the Venn::CLI application

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

use strict;
use warnings;
use v5.14;

use YAML::XS;
use Mouse::Role;
with 'MouseX::ConfigFromFile';

=head2 get_config_from_file($file)

Loads a YAML config file and returns the hashref of that config (for processing by Config::Any)

=cut

sub get_config_from_file {
    my ($class, $file) = @_;

    if (ref $file eq 'CODE') {
        # From the configfile builder
        return YAML::XS::LoadFile($file->());
    } else {
        # From a manually-specified file
        return YAML::XS::LoadFile($file);
    }
}

1;
