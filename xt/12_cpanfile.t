use strict;
use warnings;
use utf8;
use Test::More;
use Path::Tiny;
use xt::CLI;

sub cpm_with_cpanfile {
    my ($contents) = @_;

    my $cpanfile = Path::Tiny->tempfile;
    $cpanfile->spew($contents);

    my $r = cpm_install "--cpanfile", "$cpanfile";
}

subtest basic => sub {
    my $r = cpm_with_cpanfile(q{requires "App::FatPacker";});
    like $r->err, qr/^DONE install App-FatPacker/m;
    like $r->err, qr/1 distribution installed/;
    ok -f $r->local . "/bin/fatpack";
};

subtest specific_version => sub {
    TODO: {
        local $TODO = "Fails to resolve older version";
        my $r = cpm_with_cpanfile(q{requires "App::FatPacker", "==0.009018";});
        like $r->err, qr/^DONE install App-FatPacker-0.009018/m;
        like $r->err, qr/1 distribution installed/;
        ok -f $r->local . "/bin/fatpack";
    };
};

subtest range => sub {
    my $r = cpm_with_cpanfile(q{requires "App::FatPacker", ">=0.01";});
    like $r->err, qr/^DONE install App-FatPacker/m;
    like $r->err, qr/1 distribution installed/;
    ok -f $r->local . "/bin/fatpack";
};

done_testing;
