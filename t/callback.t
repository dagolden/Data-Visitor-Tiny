use 5.010;
use strict;
use warnings;
use Test::More 0.96;
binmode( Test::More->builder->$_, ":utf8" )
  for qw/output failure_output todo_output/;

use Data::Visitor::Tiny qw/visit/;

my $deep = {
    larry => {
        color   => 'red',
        fruit   => 'apple',
        friends => [ { name => 'Moe' }, { name => 'Curly' } ],
    },
    moe => {
        color   => 'yellow',
        fruit   => 'banana',
        friends => [ { name => 'Curly' } ],
    },
    curly => {
        color   => 'purple',
        fruit   => 'plum',
        friends => [ { name => 'Larry', nickname => 'Lray' } ],
    },
};

subtest "Callback gets arguments" => sub {
    my $input = { a => 1 };
    my $fcn = sub {
        my ( $k, $c, $vr ) = @_;
        ok( ref($k) eq '',        "arg 0 type correct" );
        ok( ref($c) eq 'HASH',    "arg 1 type correct" );
        ok( ref($vr) eq 'SCALAR', "arg 2 type correct" );
        is( $k,           'a', "arg 0 correct" );
        is( $c->{_depth}, 0,   "arg 1 correct" );
        is( $$vr,         $_,  "arg 2 correct" );
    };
    my @values;
    visit( { a => 1 }, $fcn );
};

done_testing;

# COPYRIGHT

# vim: set ts=4 sts=4 sw=4 et tw=75:
