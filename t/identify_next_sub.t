use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( next_sub_is );
use PPI::Util qw( _Document );

# ABSTRACT: test identify_next_sub

{
    my $dom = _Document('t/corpus/insidesub.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements inside a sub look outside that sub for next-sub" );
}
{
    my $dom = _Document('t/corpus/doublesub.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'),
        'bar', "statements inside a first sub have a 'next-sub' of the subsequent sub" );
}

done_testing;

