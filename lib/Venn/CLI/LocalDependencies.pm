package Venn::CLI::LocalDependencies;

use v5.14;
use warnings;

=head1 NAME

Venn::CLI::LocalDependencies

=head1 DESCRIPTION

loadS Firm-specific module directories.

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

my %dependencies;

BEGIN {
    %dependencies = %Venn::CLI::Dependencies::DEPENDENCIES;

    # Fixing up MS dependencies
    my %overrides = (
        'Net::SSLeay'         => '1.42-1.0.0',
        'XML::Parser'         => '2.41-2.0.1-1',
        'libwww::perl'        => '6.04',
        'libxml::enno'        => '1.02',
        'Scalar::List::Utils' => '1.41',
        ######============= EON IDs ===============
        'MSDW::Eon'           => '1.1.3',
        'CDB_File'            => '0.97',
        'Time-modules'        => '99.111701',
        'Crypt-SSLeay'       => '0.58-1.0.0',
        'Net-SSLeay'         => '1.42-1.0.0',
        'GSSAPI'             => '0.28-1.10', # Used by LWP::Authen::Negotiate
    );

    $dependencies{$_} = $overrides{$_} for keys %overrides;

    # convert :: modules to -, according to MDP
    %dependencies = map { s/::/-/sgr, $dependencies{$_} } keys %dependencies; ## no critic [ValuesAndExpressions::ProhibitCommaSeparatedStatements]
}

use MSDW::Version
    _croak => 0,
    #_debug => 1,
    %dependencies;

1;
