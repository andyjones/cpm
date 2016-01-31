package App::cpm::Version;

use strict;
use warnings;

use CPAN::Meta::Requirements;

sub satisfied {
    my ($class, $package, $version, $want_version) = @_;
    return 1 unless $want_version;
    return unless $version;

    my $requirements = CPAN::Meta::Requirements->new;
    $requirements->add_string_requirement($package, $want_version);
    return $requirements->accepts_module($package, $version);
}

1;
