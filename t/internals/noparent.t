
use strict;
use warnings;

use Test::More;

# ABSTRACT: Ensure arbitrary objects that don't have parents don't barf

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );

my $badnode = BadNode->new();

sub_is( $badnode, undef, "no ->parent means unresolvable" );
next_sub_is( $badnode, undef, "no ->parent means unresolvable" );
assoc_sub_is( $badnode, undef, "no ->parent means unresolvable" );

done_testing;

{
    package BadNode;
    sub new { bless { %{ $_[1] || {} } }, $_[0] }
}

