package t::LocalDependencies;

use v5.14;
use warnings;

=head1 NAME

t::LocalDependencies

=head1 DESCRIPTION

Loads Firm-specific module directories.

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
    %dependencies = %t::Dependencies::DEPENDENCIES;

    # Fixing up MS dependencies
    my %overrides = (
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
