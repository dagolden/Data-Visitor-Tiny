use v5.10;
use strict;
use warnings;

package Data::Visitor::Tiny;
# ABSTRACT: Recursively walk data structures

our $VERSION = '0.001';

use Carp qw/croak/;
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
    croak("'$ref' is not an ARRAY or HASH")
      unless $type eq 'ARRAY' || $type eq 'HASH';
    my @elems = $type eq 'ARRAY' ? ( 0 .. $#$ref ) : ( sort keys %$ref );
    for my $idx (@elems) {
        my ( $v, $vr );
        $v  = $type eq 'ARRAY' ? $ref->[$idx]      : $ref->{$idx};
        $vr = $type eq 'ARRAY' ? \( $ref->[$idx] ) : \( $ref->{$idx} );
        local $_ = $v;
        # Wrap $fcn in dummy for loop to guard against bare 'next' in $fcn
        for my $dummy (0) { $fcn->( $idx, $vr, $ctx ) }
        if ( ref($v) eq 'ARRAY' || ref($v) eq 'HASH' ) {
            $ctx->{_depth}++;
            _visit( $v, $fcn, $ctx );
            $ctx->{_depth}--;
        }
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
