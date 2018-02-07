use 5.010;
use strict;
use warnings;

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

# COPYRIGHT

# vim: set ts=4 sts=4 sw=4 et tw=75:
