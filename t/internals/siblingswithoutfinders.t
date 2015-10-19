
use strict;
use warnings;

use Test::More;

# ABSTRACT: Ensure arbitrary objects that don't have "find_first" don't barf

use Test::More;
use lib 't/lib';
use SubIs qw( sub_is assoc_sub_is next_sub_is );
use PPI::Util qw( _Document );

my $dom = _Document(
    \"
  sub foo {
  }
"
);

my $sub = $dom->find_first('PPI::Statement::Sub');

my $badnode = BadNode->new( { parent => $sub } );

sub_is( $badnode, 'foo', "Siblings not considered, parent only" );
next_sub_is( $badnode, undef, "no ->find_first on sibling means sibling is not traversed" );
assoc_sub_is( $badnode, 'foo', "no ->find_first on sibling defers to parent" );

done_testing;

{

    package BadNode;
    sub new { bless { %{ $_[1] || {} } }, $_[0] }
    sub class   { 'BadNode' }
    sub content { '' }
    sub parent  { BadNode2->new( { parent => $_[0]->{parent} } ) }
}
{

    package BadNode2;
    sub new { bless { %{ $_[1] || {} } }, $_[0] }
    sub class    { 'BadNode' }
    sub content  { '' }
    sub parent   { $_[0]->{parent} }
    sub children { return BadNode3->new() }
}
{

    package BadNode3;
    sub new { bless { %{ $_[1] || {} } }, $_[0] }
    sub class   { 'BadNode' }
    sub content { '' }
}
