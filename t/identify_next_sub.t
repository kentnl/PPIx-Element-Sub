use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( next_sub_is );
use PPI::Util qw( _Document );

# ABSTRACT: test identify_next_sub

{
    my $dom = _Document('t/corpus/noscope.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "no scopes means no subs" );
}

{
    my $dom = _Document('t/corpus/aftersub.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements after last sub are not before a sub" );
}

{
    my $dom = _Document('t/corpus/beforesub.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements before a sub are before that sub" );
}
{
    my $dom = _Document('t/corpus/betweensubs.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), 'bar', "statements between subs are before the second" );
}
{
    my $dom = _Document('t/corpus/deepaftersibling.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements in a subsequent sibling of a sub not before a sub" );
}
{
    my $dom = _Document('t/corpus/deepbeforesibling.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements in a previous sibling of a sub are before a sub" );
}
{
    my $dom = _Document('t/corpus/deepchild.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements deep a sub look outside that sub for next-sub" );
}
{
    my $dom = _Document('t/corpus/inlinesub.pm');
    next_sub_is( $dom->find_first('PPI::Token::Comment'),
        undef, "statements hanging right of a sub look outside that sub for next-sub" );
}
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

