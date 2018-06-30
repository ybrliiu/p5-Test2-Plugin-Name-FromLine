package Test2::Plugin::Name::FromLine;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Test2::API qw( test2_formatter_set );
use Test2::Plugin::Name::FromLine::Formatter;

our $VERSION = '0.01_1';

sub import {
  my ($class, %args) = (shift, @_);

  my $file_name = (caller)[1];
  my $formatter = Test2::Plugin::Name::FromLine::Formatter->new(file_name => $file_name);
  test2_formatter_set($formatter);
}

1;

__END__

=encoding utf8

=head1 NAME

Test2::Plugin::Name::FromLine - Auto fill test names

=head1 SYNOPSIS

use Test::More;
use Test2::Plugin::Name::FromLine (does_guess_test_line => 1);

ok (my $vvvvvvvvvvv # auto fill name like: 'ok 1 - L3: ok (my $vvvvvvvvvvv'
  = 100 * 100);

done_testing;

=head1 DESCRIPTION

Test2::Plugin::Name::FromLine is test utility that fills test names from its file.
Just use this module in test and this module fill test names to all test except named one.

=head1 AUTHOR

mp0liiu E<lt>mp0liiu@gmail.com<gt>

=head1 SEE ALSO

This is Test::Name::FromLine.
This is inspired from L<http://subtech.g.hatena.ne.jp/motemen/20101214/1292316676>.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

