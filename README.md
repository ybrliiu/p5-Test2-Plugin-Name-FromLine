# NAME

Test2::Plugin::Name::FromLine - Auto fill test names

# SYNOPSIS

use Test::More;
use Test2::Plugin::Name::FromLine (does\_guess\_test\_line => 1);

ok (my $vvvvvvvvvvv # auto fill name like: 'ok 1 - L3: ok (my $vvvvvvvvvvv'
  = 100 \* 100);

done\_testing;

# DESCRIPTION

Test2::Plugin::Name::FromLine is test utility that fills test names from its file.
Just use this module in test and this module fill test names to all test except named one.

# AUTHOR

mp0liiu &lt;mp0liiu@gmail.com&lt;gt>

# SEE ALSO

This is Test::Name::FromLine.
This is inspired from [http://subtech.g.hatena.ne.jp/motemen/20101214/1292316676](http://subtech.g.hatena.ne.jp/motemen/20101214/1292316676).

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
