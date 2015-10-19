use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom    = _Document('t/corpus/inlinesub.pm');
my $marker = $dom->find_first('PPI::Token::Comment');
sub_is( $marker, 'foo', "statements hanging right of a sub declaration are owned by that sub" );
next_sub_is( $marker, undef, "statements inside the only sub have no successor sub" );
assoc_sub_is( $marker, 'foo', "statements inside a sub are associated with the sub" );

done_testing;
