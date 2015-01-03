package WWW::NicoVideo::Search::Response;

use utf8;
use strict;
use 5.008_005;
our $VERSION = '0.01';

use JSON::Any;

my %errid = (
    "101" => '検索がメンテナンス中である',
    "300" => '検索クエリが不正',
    "701" => '検索クエリで取得できないフィールドを指定した',
    "1001" => 'クエリが指定時間内に捌けなかった'
);

sub new {
    my $pkg = shift;
    my $http_response = shift;
    my $res = parse($http_response->decoded_content);

    bless $res, $pkg;
}

sub parse {
    my $content = shift;
    my @chunks = split /\n/, $content;
    my $j = JSON::Any->new;

    my $response = { hits => {}, stats => {} };
    $response->{is_error} = 0;

    foreach my $c (@chunks) {
        my $chunk = $j->jsonToObj($c);
        $response->{dqnid} = $chunk->{dqnid};

        if ($chunk->{errid}) {
            $response->{is_error} = 1;
            $response->{dqsid} = $chunk->{dqsid};
            $response->{errid} = $chunk->{errid};
            $response->{errdesc} = $errid{$chunk->{errid}};
            $response->{desc} = $chunk->{desc};
            $response->{level} = $chunk->{level};
            $response->{opid} = $chunk->{opid};
            return $response;
        }

        if ($chunk->{type} eq 'hits') {
            if ($chunk->{endofstream}) {
                $response->{hits}{streamended} = 1;
                next;
            }
            $response->{hits}{values} = $chunk->{values};

        } elsif ($chunk->{type} eq 'stats') {

            if ($chunk->{endofstream}) {
                $response->{stats}{streamended} = 1;
                next;
            }
            my $values  = ${$chunk->{values}}[0];
            foreach my $k (keys %{$values}) {
                $response->{stats}{$k} = $values->{$k};
            }
        }

    }
    return $response;
}
