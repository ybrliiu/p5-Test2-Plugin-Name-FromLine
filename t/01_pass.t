use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Test2::Bundle::More;
use Test2::Tools::Exception;
use Test2::Plugin::Name::FromLine;

dies { pass 'hoge' }, undef;

done_testing;
