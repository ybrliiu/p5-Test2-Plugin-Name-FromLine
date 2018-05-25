package Test2::Plugin::Name::FromLine::GuessTestLineFormatter;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Test::More ();

use parent qw( Test2::Plugin::Name::FromLine::Formatter );
use Class::Accessor::Lite (
  new => 0,
  ro  => [qw( test_keywords orig_line_num )],
);

use constant TEST_KEYWORDS => do {
  my %table;

  # contain all Test::More functions.
  @table{@Test::More::EXPORT} = (1) x @Test::More::EXPORT;

  # not contain fuzzy name functions
  my @fuzzy_functions = qw( is ok );
  @table{qw( is ok )} = (0) x @fuzzy_functions;

  # not contain without test functions 
  my @without_test_functions
    = qw( pass fail plan done_testing diag not explain subtest BAIL_OUT $TODO );
  @table{@without_test_functions} = (0) x @without_test_functions;

  # contain Test::(Fatal | Exception) functions
  my @exception_functions = qw( lives_ok dies_ok );
  @table{@exception_functions} = (1) x @exception_functions;

  # add fuzzy strings
  my @fuzzy_strings = (
    ( map { "$_ " }     @fuzzy_functions ),
    ( map { $_ . '\(' } @fuzzy_functions ),
  );
  @table{@fuzzy_strings} = (1) x @fuzzy_strings;

  [ grep { $table{$_} } keys %table ];
};

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
  $self->{test_keywords} = [ @{ $args->{test_keywords} // [] }, @{ TEST_KEYWORDS() } ];
  $self->{orig_line_num} = $self->line_num;
  $self->{line}          = $self->guess_test_line;
  $self;
}

sub guess_test_line {
  my $self = shift;
  my $tmp_line = $self->file_data->[$self->line_num - 1];
  if ( grep { $tmp_line =~ /$_/ } @{ $self->test_keywords } ) {
    $tmp_line;
  } else {
    if ($self->line_num > 0) {
      $self->line_num( $self->line_num - 1 );
      $self->guess_test_line;
    } else {
      warn "Cannot find test line.";
      $self->orig_line_num;
    }
  }
}

1;

