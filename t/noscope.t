use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom    = _Document('t/corpus/noscope.pm');
my $marker = $dom->find_first('PPI::Token::Comment');
sub_is( $marker, undef, "no scopes means no subs" );
next_sub_is( $marker, undef, "no scopes means no subsequent subs" );
assoc_sub_is( $marker, undef, "no scopes means no associated subs" );

done_testing;
