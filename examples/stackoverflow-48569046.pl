use 5.010;
use strict;
use warnings;

use Data::Dumper;
use Data::Visitor::Tiny;
use Time::Moment;

my $ref = [
    {
        '$match' => { "lastModifiedDate" => "ISODate(\"2016-08-10T04:55:46.053+0000\")", }
    },
    { '$project' => { name => 1 } },
];

my $visitor = sub {
    my (undef, $valueref) = @_;
    return if ref;
    return unless /^ISODate\("([^"]+)"\)$/;
    $$valueref = Time::Moment->from_string($1, lenient => 1);
};

visit( $ref, $visitor);

say Dumper($ref);
say "Date parsed as: " . $ref->[0]{'$match'}{lastModifiedDate};

# COPYRIGHT

# vim: set ts=4 sts=4 sw=4 et tw=75:
