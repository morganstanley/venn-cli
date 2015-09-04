package Venn::CLI::Types;

=head1 NAME

Venn::CLI::Types

=head1 DESCRIPTION

Venn CLI Type Library

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
use strict;
use warnings;

use Venn::CLI::Dependencies;
use MouseX::Types -declare => [qw(
    NoEmptyStr
)];

# import builtin types
use MouseX::Types::Mouse qw( Str );

subtype NoEmptyStr,
  as Str,
  where { length($_) > 0 }, # if where clause is false, display below message
  message { "String cannot be empty" };

1;
