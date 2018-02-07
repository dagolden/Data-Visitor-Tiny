use v5.10;
use strict;
use warnings;

package Data::Visitor::Tiny;
# ABSTRACT: Recursively walk data structures

our $VERSION = '0.001';

use Carp qw/croak/;
use Exporter 5.57 qw/import/;

our @EXPORT = qw/visit/;

=func visit

    visit( $ref, sub { ... } );

The C<visit> function takes a hashref or arrayref and recursively visits
all values via pre-order traversal, calling the provided callback for each
value.  Only hashrefs and arrayrefs are recursed into; objects, even if they
override hash or array dereference, are only ever treated as values;

Within the callback, the C<$_> variable is set to the value of the node.
The callback also receives three arguments: C<$key>, C<$valueref>, and
C<$context>.  The C<$key> is the hash key or array index of the value.  The
C<$valueref> is a scalar reference to the value; use it to modify the value
in place.  The C<$context> is a hashref for tracking state throughout the
visiting process.  Context keys beginning with '_' are reserved for
C<Data::Visitor::Tiny>; you may store whatever other keys/values you need.
The only key provided currently is C<_depth>, which starts at 0 and
reflects how deep the visitor has recursed.

The C<visit> function returns the context object.

=cut

sub visit {
    my ( $ref, $fcn ) = @_;
    my $ctx = { _depth => 0 };
    _visit( $ref, $fcn, $ctx );
    return $ctx;
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

    my $hoh = {
        a => { b => 1, c => 2 },
        d => { e => 3, f => 4 },
    };

    # print leaf (non-ref) values
    visit( $hoh, sub { return if ref; say } );

    # transform leaf value for a given key
    visit(
        $hoh,
        sub {
            my ( $key, $valueref ) = @_;
            $$valueref = "replaced" if $key eq 'e';
        }
    );
    say $hoh->{d}{e}; # "replaced"

=head1 DESCRIPTION

This module provides a simple framework for recursively iterating over a
data structure of hashrefs and/or arrayrefs.

=head1 SEE ALSO

=for :list
* L<Data::Visitor>
* L<Data::Visitor::Lite>
* L<Data::Rmap>
* L<Data::Traverse>

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
