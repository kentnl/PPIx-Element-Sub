use strict;
use warnings;

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom = _Document('t/corpus/doublesub.pm');
my (@comments) = @{ $dom->find('PPI::Token::Comment') };

subtest "comment 0" => sub {
    my $marker = $comments[0];
    sub_is( $marker, 'foo', "statements inside a the first sub are owned by that sub" );
    next_sub_is( $marker, 'bar', "statements inside the first sub have the second sub as successor" );
    assoc_sub_is( $marker, 'foo', "statements inside the first sub are associated with the first sub" );
};
subtest "comment 1" => sub {
    my $marker = $comments[1];
    sub_is( $marker, 'bar', "statements inside a the second sub are owned by that sub" );
    next_sub_is( $marker, undef, "statements inside the second sub have no successor sub" );
    assoc_sub_is( $marker, 'bar', "statements inside the second sub are associated with the second sub" );
};

done_testing;
