use strict;
use warnings;

use Test::More;
use WWW::NicoVideo::Search;

my $nvs = WWW::NicoVideo::Search->new;

my $res = $nvs->search({query => "sm9"});

ok( $res->is_success, "Request Successed" );

done_testing;
1;
