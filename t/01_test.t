use Test2::Bundle::More;
use Test2::Plugin::UTF8;
use Test2::Plugin::Name::FromLine (does_guess_test_line => 1);

my $num = 3;
is 3, $num;
ok 1;
ok 1 + 2;
ok (
  10 + 20
);

done_testing;
