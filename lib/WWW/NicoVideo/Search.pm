package WWW::NicoVideo::Search;

use utf8;
use strict;
use 5.008_005;
our $VERSION = '0.01';

use JSON::Any;
use LWP::UserAgent;

use WWW::NicoVideo::Search::Response;

my $AGENT_NAME = "@{[__PACKAGE__]}/$VERSION)";
my $API_ENDPOINT = 'http://api.search.nicovideo.jp/api/snapshot/';

sub new {
    my $pkg = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    my $ua = $args{ua} ||
        new LWP::UserAgent(agent => $AGENT_NAME, %{$args{uaopts}});

    bless { ua => $ua }, $pkg;
}

sub search {
    my $self = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    $self->{query_json} = mk_query_json(%args);

    my $req = HTTP::Request->new( 'POST', $API_ENDPOINT );
    $req->header( 'Content-Type' => 'application/json' );
    $req->content($self->{query_json});

    WWW::NicoVideo::Search::Response->new($self->{ua}->request($req));
}

sub mk_query_json {
    my %args = @_ == 1 ? %{$_[0]} : @_;

    $args{sort_by} //= "start_time";
    $args{order} //= "desc";
    $args{from} //= 0;
    $args{size} //= 10;
    $args{search} //= ["tags_exact"];
    $args{join} //= ["cmsid", "start_time", "length_seconds", "title"];

    my $query = {
        query => $args{query},
        service => ["video"],
        search => $args{search},
        join => $args{join},
        sort_by => $args{sort_by},
        order => $args{order},
        from => $args{from},
        size => $args{size},
        issuer => $AGENT_NAME,
    };
    $query->{filters} = $args{filters} if $args{filters};

    my $j = JSON::Any->new;
    return $j->objToJson($query);
}

1;
__END__

=encoding utf-8

=head1 NAME

WWW::NicoVideo::Search - Perl interface to nicovideo snapshot search API.

=head1 SYNOPSIS

  use WWW::NicoVideo::Search;

  my $nvs = WWW::NicoVideo::Search->new;
  my $res = $nvs->search({ query => "sm9" }); # search as tag_exact mode
                                              # returns csmid, start_time
                                              # length_seconds, title
                                              # order by start_time.

  exit if $res->{is_error}; 

  $res->{stats}{total}; # number of total hits

  my $values = $res->{hits}{values}; # array ref of search response hash
  foreach my $v (@$values) {
      $v->{csmid}; # video id
  }

=head1 DESCRIPTION

WWW::NicoVideo::Search is Perl interface to nicovideo snapshot search API.

=head1 AUTHOR

aoicat afuhineco +github @gmail.com

=head1 COPYRIGHT

Copyright 2014- aoicat

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<http://search.nicovideo.jp/docs/api/snapshot.html>, ニコニコ動画 『スナップショット検索API』 ガイド.

=cut
