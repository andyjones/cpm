use strict;
use warnings;
use utf8;
use Test::More;
use App::cpm::Worker::Resolver;

my $r = App::cpm::Worker::Resolver->new(
    cpanmetadb => "http://cpanmetadb.plackperl.org/v1.0/history",
);

subtest "latest version" => sub {
    my $res = $r->work(+{ package => "Plack", version => 1 });

    like $res->{distfile}, qr/Plack/;
    ok exists $res->{version};
};

subtest "older version" => sub {
    my $res = $r->work(+{ package => "Plack", version => '==1' });

    like $res->{distfile}, qr/Plack/;
    is $res->{version} => '1.0000';
};

done_testing;
