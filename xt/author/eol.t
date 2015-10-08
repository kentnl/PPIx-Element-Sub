use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.18

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/PPIx/Element/Sub.pm',
    't/00-compile/lib_PPIx_Element_Sub_pm.t',
    't/00-report-prereqs.dd',
    't/00-report-prereqs.t',
    't/aftersub.t',
    't/beforesub.t',
    't/betweensubs.t',
    't/corpus/aftersub.pm',
    't/corpus/beforesub.pm',
    't/corpus/betweensubs.pm',
    't/corpus/deepaftersibling.pm',
    't/corpus/deepbeforesibling.pm',
    't/corpus/deepchild.pm',
    't/corpus/doublesub.pm',
    't/corpus/inlinesub.pm',
    't/corpus/insidesub.pm',
    't/corpus/noscope.pm',
    't/deepaftersibling.t',
    't/deepbeforesibling.t',
    't/deepchild.t',
    't/doublesub.t',
    't/inlinesub.t',
    't/insidesub.t',
    't/internals/noparent.t',
    't/lib/SubIs.pm',
    't/noscope.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
