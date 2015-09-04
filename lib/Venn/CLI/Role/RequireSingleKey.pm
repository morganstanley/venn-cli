package Venn::CLI::Role::RequireSingleKey;

=head1 NAME

Venn::CLI::Role::RequireSingleKey

=head1 DESCRIPTION

Requires a key to be specified in the command

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
    only allow one key
    special condition for 'help' key
    % key means all

=cut

sub check_keys {
    my ( $self, $keys_array_ref ) = @_;

    # Check key count, as we only allow one key to be passed
    if (scalar(@$keys_array_ref) != 1) {
        my @maybe_options = grep { /^-/ } @$keys_array_ref;
        if (@maybe_options) {
            say sprintf "Please provide one (and only one!) key to %s. You may have passed an ambiguous option: %s",
                $self->verb, join(', ', map { "'$_'" } @$keys_array_ref);
        }
        else {
            say sprintf "Please provide one (and only one!) key to %s, you passed: %s",
                $self->verb, join(', ', map { "'$_'" } @$keys_array_ref);
        }
        exit(1);
    }

    # Check that the key is not == 'help'
    if ($keys_array_ref->[0] eq 'help') {
        # TODO - call help for $self->verb here
    }

    # HACK: % means all
    $keys_array_ref->[0] = '' if $keys_array_ref->[0] eq '%';

    return $keys_array_ref;
}

1;
