use strict;
use Test::More;

my $class = 'App::cpm::Version';
use_ok($class);

subtest "no version requirement" => sub {
    ok $class->satisfied('MyPackage', 1.00, '');
};

subtest "distribution lacks a version" => sub {
    ok !$class->satisfied('MyPackage', undef, 1.00);
};

subtest "at least version" => sub {
    # requires 'MyPackage', 1.00;
    ok !$class->satisfied('MyPackage', 0.99, 1.00);

    # requires 'MyPackage', 1.00;
    ok $class->satisfied('MyPackage', 1.01, 1.00);

    # requires 'MyPackage', '>=1.00';
    ok $class->satisfied('MyPackage', 1.01, '>=1.00');
};

subtest "specific version" => sub {
    # requires 'MyPackage', '==1.00';
    ok !$class->satisfied('MyPackage', 1.01, '==1.00');
    ok $class->satisfied('MyPackage', 1.01, '==1.01');
};

done_testing;
