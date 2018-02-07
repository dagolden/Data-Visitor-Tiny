use v5.10;
use strict;
use warnings;

package Data::Visitor::Tiny;
# ABSTRACT: Recursively walk data structures

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw/visit/;

sub visit {
    my ( $ref, $fcn ) = @_;
    my $type = ref($ref);

    if ( $type eq 'ARRAY' ) {
        for my $v (@$ref) {
            local $_ = $v;
            $fcn->();
            visit( $v, $fcn ) if ref($v) eq 'ARRAY' || ref($v) eq 'HASH';
        }
    }
    elsif ( $type eq 'HASH' ) {
        for my $k ( keys %$ref ) {
            my $v = $ref->{$k};
            local $_ = $v;
            $fcn->();
            visit( $v, $fcn ) if ref($v) eq 'ARRAY' || ref($v) eq 'HASH';
        }
    }
    else {
        ...;
    }

}

1;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Visitor::Tiny;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

=for :list
* Maybe other modules do related things.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
