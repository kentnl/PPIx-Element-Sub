use strict;
use warnings;

package SubIs;

use Exporter 5.57 qw( import );
use Test::Builder;
use PPIx::Element::Sub qw( identify_sub identify_next_sub identify_associated_sub );

our @EXPORT = qw( sub_is next_sub_is assoc_sub_is );

sub sub_is($$$) {
    my ( $element, $name, $reason ) = @_;
    my $builder    = Test::Builder->new();
    my $identified = identify_sub($element);
    if ( not defined $name ) {
        return 1 if $builder->is_eq( $identified, undef, $reason );
        $builder->diag("undef expected, got result");
    }
    else {

        return 1
          if $builder->ok( defined $identified, "$reason: got an object" )
          and $builder->is_eq( $identified->name, $name, "$reason: name matches" );
    }
    $builder->diag( "element class:" . $element->class );
    $builder->diag( "element content:" . $element->content );
    if ( defined $identified ) {
        $builder->diag( "got result:" . $identified->class );
        $builder->diag( "got content:" . $identified->content );
    }
}

sub next_sub_is($$$) {
    my ( $element, $name, $reason ) = @_;
    my $builder    = Test::Builder->new();
    my $identified = identify_next_sub($element);
    if ( not defined $name ) {
        return 1 if $builder->ok( !defined $identified, $reason );
        $builder->diag("undef expected, got result");
    }
    else {
        return 1
          if $builder->ok( defined $identified, "$reason: got an object" )
          and $builder->is_eq( $identified->name, $name, "$reason: name matches" );
    }
    $builder->diag( "element class:" . $element->class );
    $builder->diag( "element content:" . $element->content );
    if ( defined $identified ) {
        $builder->diag( "got result:" . $identified->class );
        $builder->diag( "got content:" . $identified->content );
    }
}

sub assoc_sub_is($$$) {
    my ( $element, $name, $reason ) = @_;
    my $builder    = Test::Builder->new();
    my $identified = identify_associated_sub($element);
    if ( not defined $name ) {
        return 1 if $builder->ok( !defined $identified, $reason );
        $builder->diag("undef expected, got result");
    }
    else {
        return 1
          if $builder->ok( defined $identified, "$reason: got an object" )
          and $builder->is_eq( $identified->name, $name, "$reason: name matches" );
    }
    $builder->diag( "element class:" . $element->class );
    $builder->diag( "element content:" . $element->content );
    if ( defined $identified ) {
        $builder->diag( "got result:" . $identified->class );
        $builder->diag( "got content:" . $identified->content );
    }
}

