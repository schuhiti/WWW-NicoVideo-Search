use utf8;
use strict;
use warnings;

use Test::More;
use WWW::NicoVideo::Search;

my $nvs = WWW::NicoVideo::Search->new;

my $res = $nvs->search({
        query => "sm9",
        search => ["tags_exact"],
        join => ["cmsid", "title", "length_seconds", "tags"],
        sort_by => "start_time",
        order => "asc",
    });

isa_ok( $res, 'WWW::NicoVideo::Search::Response' );

my $v = ${$res->{hits}{values}}[0];
ok( $v->{cmsid} eq "sm9", "cmsid is correct" );
ok( $v->{length_seconds} == 319, "length_seconds is correct" );
ok( $v->{title} eq "新・豪血寺一族 -煩悩解放 - レッツゴー！陰陽師", "title is correct" );
ok( $v->{tags} =~ m/^sm9 | sm9 | sm9$/, "tags contain specified tag" );

done_testing;
1;
