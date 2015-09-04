package Venn::CLI::Role::RequireNoKey;

=head1 NAME

Venn::CLI::Role::RequireNoKey

=head1 DESCRIPTION

Requires that no key be specified in the command.

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

=head2 check_keys(\@keys)

Check:
    only allow no keys

=cut

sub check_keys {
    my ( $self, $keys_array_ref ) = @_;

    # Check key count, as we only allow one key to be passed
    if (scalar(@$keys_array_ref) != 0) {
        say sprintf("No keys allowed for the '%s' command", $self->verb);
        exit 1;
    }

    return $keys_array_ref;
}

1;
