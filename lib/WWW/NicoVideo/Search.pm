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

WWW::NicoVideo::Search - Blah blah blah

=head1 SYNOPSIS

  use WWW::NicoVideo::Search;

=head1 DESCRIPTION

WWW::NicoVideo::Search is

=head1 AUTHOR

aoicat E<lt>afuhineco@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2014- aoicat

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
