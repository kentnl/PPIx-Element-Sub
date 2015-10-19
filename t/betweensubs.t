use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom    = _Document('t/corpus/betweensubs.pm');
my $marker = $dom->find_first('PPI::Token::Comment');
sub_is( $marker, undef, "statements outside a sub are unowned" );
next_sub_is( $marker, 'bar', "statements betweewn subs have a successor of the second" );
assoc_sub_is( $marker, 'bar', "statements between subs are associated with the second" );

done_testing;
