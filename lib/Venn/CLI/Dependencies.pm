package Venn::CLI::Dependencies;

=head1 NAME

Venn::CLI::Dependencies

=head1 DESCRIPTION

Library dependency declarations.

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

our %DEPENDENCIES;

BEGIN {
    %DEPENDENCIES = (
        ######================ LWP::UserAgent ==================
        'LWP'                => '6.04',
        'Crypt::SSLeay'       => '0.58',
        'Encode::Locale'      => '1.02',
        'File::Listing'       => '6.02',
        'HTML::Form'          => '6.00',
        'HTML::Parser'        => '3.68',
        'HTTP::Cookies'       => '6.00',
        'HTTP::Daemon'        => '6.00',
        'HTTP::Date'          => '6.00',
        'HTTP::Message'       => '6.02',
        'HTTP::Negotiate'     => '6.00',
        'IO::Compress'        => '2.030',
        'IO::Socket::SSL'      => '1.38',
        'LWP::MediaTypes'     => '6.01',
        'LWP::Protocol::https' => '6.02',
        'Mozilla::CA'         => '20110409',
        'Net::HTTP'           => '6.01',
        'Net::SSLeay'         => '1.42',
        'Socket6'            => '0.23',
        'TimeDate'           => '1.20',
        'URI'                => '1.58',
        'WWW::RobotRules'     => '6.01',
        'LWP::Authen::Negotiate' => '0.08',
        'GSSAPI'             => '0.28',
        ######=================== Mouse =====================
        'Mouse'              => '1.01',
        'MouseX::App::Cmd'     => '0.11',
        'App::Cmd'            => '0.307',
        'Getopt::Long::Descriptive' => '0.092',
        'Params::Validate'    => '1.08',
        'Module::Implementation' => '0.07',
        'Sub::Exporter'       => '0.982',
        'Data::OptList'       => '0.108',
        'Sub::Install'        => '0.925',
        'Module::Runtime'     => '0.013',
        'Try::Tiny'           => '0.16',
        'Params::Util'        => '1.04',
        'MouseX::Getopt'      => '0.34',
        'MouseX::Types'          => '0.05',
        'MouseX::ConfigFromFile' => '0.05',
        'MouseX::Types::Path::Class' => '0.07',
        'Path::Class'         => '0.32',
        ######============= Text::Table ==================
        'Text::ASCIITable'    => '0.20',
        ######============= JSON ==================
        'JSON::XS'            => '2.32',
        'common::sense'       => '3.6',
        ######============= YAML ==================
        'YAML::LibYAML'       => '0.41',
        ######============= Moose =================
        'Moose'               => '2.1403',
        'Module::Runtime'     => '0.014',
        'Class::Load'         => '0.20',
        'Data::OptList'       => '0.108',
        'Params::Util'        => '1.07',
        'Sub::Install'        => '0.925',
        'Module::Implementation' => '0.07',
        'Try::Tiny'           => '0.22',
        'Package::DeprecationManager' => '0.11',
        'List::MoreUtils'     => '0.405',
        'Exporter::Tiny'      => '0.042',
        'Sub::Exporter'       => '0.987',
        'Sub::Name'           => '0.12',
        'MRO::Compat'         => '0.12',
        'Devel::OverloadInfo' => '0.002',
        'Package::Stash'      => '0.34',
        'Sub::Identify'       => '0.10',
        'Eval::Closure'       => '0.06',
        'namespace::clean'    => '0.24',
        'B::Hooks::EndOfScope' => '0.14',
        'Devel::GlobalDestruction' => '0.11',
        'Sub::Exporter::Progressive' => '0.001011',
        'Scalar::List::Utils'  => '1.41',
        'namespace::autoclean' => '0.23',
    );
}

## no critic BuiltinFunctions::ProhibitStringyEval

BEGIN {
    # venn core local dependencies
    eval 'use Venn::CLI::LocalDependencies';
}

## use critic

1;
