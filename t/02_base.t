use strict;
use warnings;
use v5.14;
use Data::Dumper;
use Test2::API qw( context intercept test2_stack );
use Test2::Bundle::More;
use Test2::Plugin::Name::FromLine;

sub trim { my $s = shift; $s =~ s{^\n|\n$}{}gr; }

sub test_test(&) {
  my $code = shift;

  my $formatter = Test2::API::test2_formatter();
  my $handles = $formatter->handles;

  local $handles->[0];
  local $handles->[1];
  local $handles->[2];

  open $handles->[0], '>', \(my $stdout = '');
  open $handles->[1], '>', \(my $stderr = '');
  open $handles->[2], '>', \(my $todo = '');

  $code->();

  # hack executed test count and status
  # 本当は Test2::API::Instance を生成してやって上げたほうがお行儀がいいけどめんどくさすぎる
  my ($hub) = test2_stack->all;
  $hub->set_count( $hub->count - 1 );
  $hub->set_failed(0);
  $hub->set__passing(1);

  +{
    stdout => trim($stdout),
    stderr => trim($stderr),
    todo   => trim($todo),
  };
}

is test_test {
  is 1, 1;
}->{stdout}, trim(q{
ok 1 - L41:   is 1, 1;
}), 'is 1, 1 => ok';

my $output = test_test {
  is 1, 0;
};
is $output->{stdout}, 'not ok 2 - L47:   is 1, 0;';
is $output->{stderr}, trim(q{
# Failed test 'L47:   is 1, 0;'
# at t/02_base.t line 47.
# +-----+----+-------+
# | GOT | OP | CHECK |
# +-----+----+-------+
# | 1   | eq | 0     |
# +-----+----+-------+
}), 'is 1, 0 => not ok';

done_testing;
