use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom    = _Document('t/corpus/beforeuselessblock.pm');
my $marker = $dom->find_first('PPI::Token::Comment');
sub_is( $marker, undef, "statements outside a sub are unowned" );
next_sub_is( $marker, undef, "statements have no successor sub" );
assoc_sub_is( $marker, undef, "statements with no subs are unassociated" );

done_testing;
