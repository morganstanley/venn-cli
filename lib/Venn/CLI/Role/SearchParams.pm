package Venn::CLI::Role::SearchParams;

=head1 NAME

Venn::CLI::Role::SearchParams

=head1 DESCRIPTION

Search Params role

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

use Mouse::Role;
use Mouse::Util::TypeConstraints;

=head1 OPTIONS

Standard search parameters generator

=cut

sub search_parameters {
    my ($self) = @_;

    my $search = {};

    for my $k (keys %{$self->meta->{attributes}}) {
        my $v = $self->meta->{attributes}{$k};

        next if ref($v) =~ /NoGetopt/; # skip non-getopt attributes
        next if $k =~ /^_|^output_format$/; # skip baseclass defaults

        $search->{$k} = $self->$k if defined $self->$k;
    }

    return $search;
}

1;
