package App::cpm::Worker::Resolver;
use strict;
use warnings;
use utf8;

use HTTP::Tiny;
use CPAN::Meta::YAML;
use App::cpm::Version;

sub new {
    my ($class, %option) = @_;
    my $ua = HTTP::Tiny->new(timeout => 15, keep_alive => 1);
    bless { %option, ua => $ua }, $class;
}

sub work {
    my ($self, $job) = @_;
    my $res = $self->{ua}->get( "$self->{cpanmetadb}/$job->{package}" );
    if (!$res->{success}) {
        return { ok => 0 };
    }

    foreach my $line ( split /\n/, $res->{content} ) {
        my ($package, $meta_version, $distfile) = split /\s+/, $line;
        my $version = $meta_version eq "undef" ? 0 : $meta_version;

        if (App::cpm::Version->satisfied( $package, $version, $job->{version} )) {
            return {
                ok => 1,
                distfile => $distfile,
                version => $meta_version,
                provide => +{package => $package, version => $version},
            };
        }
    }
    warn "-> Couldn't find $job->{package} $job->{version}\n";
    return { ok => 0 };
}

1;
