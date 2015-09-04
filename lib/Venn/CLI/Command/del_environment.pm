package Venn::CLI::Command::del_environment;

use v5.14;

use Mouse;
extends qw(Venn::CLI::Command);

# Shared options and private Mouse attributes
with qw(
    Venn::CLI::Role::Attribute
    Venn::CLI::Role::GenericVerb
    Venn::CLI::Role::RequireSingleKey
);

has '+attribute_type' => ( default => 'environment' );

sub run {
    my ($self, $environment) = @_;

    my $response = $self->submit_to_api(
        $self->attribute_path($environment), 'DELETE'
    );

    # Take the response from the REST request and print it
    return $self->print_response($response);
}

no Mouse;
__PACKAGE__->meta->make_immutable;


__DATA__

=head1 NAME

Venn::CLI::Command::del_environment - Deletes an unused environment

=head1 SYNOPSIS

$ venn del_environment <environment>

=head1 DESCRIPTION

Deletes an environment that has no associated providers.

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
