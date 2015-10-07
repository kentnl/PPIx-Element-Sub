use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom    = _Document('t/corpus/beforesub.pm');
my $marker = $dom->find_first('PPI::Token::Comment');
sub_is( $marker, undef, "statements outside a sub are unowned" );
next_sub_is( $marker, 'foo', "statements before a sub find the subsequent sub" );
assoc_sub_is( $marker, 'foo', "statements before a sub are associated with that sub" );

done_testing;
