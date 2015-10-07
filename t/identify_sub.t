use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is );
use PPI::Util qw( _Document );

# ABSTRACT: test identify_sub

{
    my $dom = _Document('t/corpus/deepbeforesibling.pm');
    sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements in a previous sibling of a sub not in subs" );
}
{
    my $dom = _Document('t/corpus/deepchild.pm');
    sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements deep in a sub are in that sub" );
}
{
    my $dom = _Document('t/corpus/inlinesub.pm');
    sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements hanging right of a sub are in that sub" );
}
{
    my $dom = _Document('t/corpus/insidesub.pm');
    sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements inside a sub are in that sub" );
}

done_testing;

