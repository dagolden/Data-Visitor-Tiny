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
    my $ctx = { _depth => 0 };
    _visit( $ref, $fcn, $ctx );
    return;
}

sub _visit {
    my ( $ref, $fcn, $ctx ) = @_;
    my $type = ref($ref);
    my @elems = $type eq 'ARRAY' ? ( 0 .. $#$ref ) : ( sort keys %$ref );
    for my $idx (@elems) {
        my ( $v, $vr );
        if ( $type eq 'ARRAY' ) {
            $v  = $ref->[$idx];
            $vr = \( $ref->[$idx] );
        }
        else {
            $v  = $ref->{$idx};
            $vr = \( $ref->{$idx} );
        }
        local $_ = $v;
        my $t = ref($v);
        $fcn->( $idx, $ctx, $vr );
        visit( $v, $fcn ) if $t eq 'ARRAY' || $t eq 'HASH';
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
