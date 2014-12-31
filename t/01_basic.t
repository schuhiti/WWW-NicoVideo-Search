use strict;
use Test::More;
use WWW::NicoVideo::Search;

isa_ok( WWW::NicoVideo::Search->new, 'WWW::NicoVideo::Search' );
ok( defined $WWW::NicoVideo::Search::VERSION, 'VERSION defined' );

done_testing;
