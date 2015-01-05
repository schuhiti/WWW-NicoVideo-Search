# NAME

WWW::NicoVideo::Search - Perl interface to nicovideo snapshot search API.

# SYNOPSIS

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


# DESCRIPTION

WWW::NicoVideo::Search - Perl interface to nicovideo snapshot search API.

# AUTHOR

aoicat afuhineco +github @gmail.com

# COPYRIGHT

Copyright 2014- aoicat

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[ニコニコ動画 『スナップショット検索API』 ガイド](http://search.nicovideo.jp/docs/api/snapshot.html)
