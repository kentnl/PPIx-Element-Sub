use 5.006;    # our
use strict;
use warnings;

package PPIx::Element::Sub;

our $VERSION = '0.001000';

# ABSTRACT: Find subroutines associated with any element.

# AUTHORITY

our @EXPORT_OK = qw( identify_sub identify_next_sub identify_associated_sub );

use Exporter 5.57 qw( import );
use Scalar::Util qw( refaddr );

sub identify_sub {
    my ($element) = @_;

    # any <sub Foo;> contains itself.
    return $element if $element->isa('PPI::Statement::Sub');

    # no parents => can't find a sub => must be main execution
    return unless $element->can('parent') and defined( my $parent = $element->parent );

    # If we have a parent, ask it for which sub we're in.
    return identify_sub($parent);
}

sub identify_next_sub {
    my ($element) = @_;

    # Parentless nodes can't have siblings
    return unless $element->can('parent') and defined( my $parent = $element->parent );

    # parents without children can't give us siblings
    # but *their* parents could
    return identify_next_sub($parent) unless $parent->can('children');

    my $own_addr  = refaddr($element);
    my $seen_self = 0;

    # Search direct siblings deeply
    for my $sibling ( $parent->children ) {

        # Iterate forwards until self is found.
        if ( not $seen_self ) {
            $seen_self = 1 if refaddr($sibling) eq $own_addr;
            next;
        }

        # For successive siblings
        # return the first sub found
        return $sibling if $sibling->isa('PPI::Statement::Sub');

        next unless $sibling->can('find_first');

        # If a sibling has children, a sub could be one of them
        if ( defined( my $result = $sibling->find_first('PPI::Statement::Sub') ) ) {
            return $result;
        }
    }

    # When no sibling is a sub, assume that the sub is further down
    # the document, making it a sibling that succeeds a parent, or a descendent
    # of a parents sibling.
    return identify_next_sub($parent);
}

sub identify_associated_sub {
    my ($element) = @_;

    # First, resolve to the containers, as all comments inside a
    # sub are related to the sub itself
    if ( my $parent = identify_sub($element) ) {
        return $parent;
    }

    # Otherwise, look into the next-sibling tree to find the subsequent sub
    return identify_next_sub($element);
}

1;

=func identify_sub

Given an C<element>, ascertain the logical C<sub> that contains it.

  my $sub = identify_sub( $element )

Due to structure of C<PPI> documents, this is simply the nearest C<parent> of
C<element> that is a C<sub>, which could be the C<element> itself.

  package Foo;  # undef
                # ↑
  sub           # sub 'bar'
  bar           # ↑
  {             # ↑
                # ↑
  }             # ↑
                # undef

Returns C<undef> if no C<sub> parent can be derived.

=func identify_next_sub

Given an C<element>, ascertain the I<next> C<sub> that appears logically
I<after> it in the document.

  my $sub = identify_next_sub( $element );

Returns C<undef> if no C<next> <sub> can be found.

  package Foo;  # sub 'bar'
                # ↑
  sub           # quux
  bar           # ↑
  {             # ↑
                # ↑
  }             # ↑
                # ↑
  sub quux      # undef
  {             # ↑
  }             # ↑

=func identify_associated_sub

This is a combination of C<identify_sub> and C<identify_next_sub> aimed at
comments, as logically, any comment inside a C<sub> pertains to the C<sub>
itself, but any comment B<before> a C<sub> may also pertain to that C<sub>.

  my $sub = identify_associated_sub( $element );

Any C<element> inside a C<sub> is associated with the C<sub> itself.

Any C<element> I<before> a C<sub> is associated with the subsequent C<sub>

  package Foo;  # sub 'bar'
                # ↑
  sub           # ↑
  bar           # ↑
  {             # ↑
                # ↑
  }             # ↑
                # sub 'quux'
  sub quux      # ↑
  {             # ↑
  }             # ↑
                # undef

Returns C<undef> if no C<sub> can be determined.

=head1 SYNOPSIS

  use PPIx::Element::Sub qw( identify_associated_sub );

  my $assoc_sub = identify_associated_sub( $comment_element );

=head1 DESCRIPTION

This module contains a handful of utility functions for finding logical C<PPI>
nodes in the relative proximity of any given C<element>.

It contains three primary exportable utility functions:

=over 4

=item C<identify_sub> - Find a logically enclosing sub

=item C<identify_next_sub> - Find a logically succeeding sub

=item C<identify_associated_sub> - Find a logically enclosing sub, or if none,
a logically succeeding sub.

=back
