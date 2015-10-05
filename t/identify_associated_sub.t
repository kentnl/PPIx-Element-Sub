use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( assoc_sub_is );
use PPI::Util qw( _Document );

# ABSTRACT: test identify_associated_sub

{
    my $dom = _Document('t/corpus/noscope.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "no scopes means no subs" );
}

{
    my $dom = _Document('t/corpus/aftersub.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements after last sub are unassociated" );
}

{
    my $dom = _Document('t/corpus/beforesub.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements before a sub are associated with it" );
}
{
    my $dom = _Document('t/corpus/betweensubs.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), 'bar', "statements between subs are associated with the second" );
}
{
    my $dom = _Document('t/corpus/deepaftersibling.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), undef, "statements after the last sub are unassociated(deeply)" );
}
{
    my $dom = _Document('t/corpus/deepbeforesibling.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'),
        'foo', "statements in a previous sibling of the first sub are associated to it" );
}
{
    my $dom = _Document('t/corpus/deepchild.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements deep inside a sub are associated with it" );
}
{
    my $dom = _Document('t/corpus/inlinesub.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements hanging right of a sub are associated with it" );
}
{
    my $dom = _Document('t/corpus/insidesub.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements inside a sub are associated with it" );
}
{
    my $dom = _Document('t/corpus/doublesub.pm');
    assoc_sub_is( $dom->find_first('PPI::Token::Comment'), 'foo', "statements inside a first sub are associated with the first" );
}

done_testing;

