package Test2::Plugin::Name::FromLine;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Test2::API qw( test2_add_callback_context_init );

our $VERSION = '0.01_1';

sub import {
  my ($class, %args) = (shift, @_);

  # 警告抑止 : use だと loaded too late to be used as the global formatter と警告が出る
  require Test2::Plugin::Name::FromLine::Formatter;
  require Test2::Plugin::Name::FromLine::GuessTestLineFormatter;

  my $formatter_class = 'Test2::Plugin::Name::FromLine::'
    . ( $args{does_guess_test_line} ? 'GuessTestLineFormatter' : 'Formatter' );
  test2_add_callback_context_init(sub {
    my $ctx = shift;
    callback($ctx, $formatter_class, \%args);
  });
}

sub callback {
  my ($ctx, $formatter_class, $args) = @_;
  my $frame = $ctx->trace->frame;
  # just call from test file.
  if ($frame->[0] eq 'main') {
    $ctx->hub->format(
        $formatter_class->new({
        line_num  => $frame->[2],
        file_name => $frame->[1],
        %$args,
      })
    );
  }
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

