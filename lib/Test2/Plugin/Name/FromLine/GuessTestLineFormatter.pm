package Test2::Plugin::Name::FromLine::GuessTestLineFormatter;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Test2::Bundle::More ();

use parent qw( Test2::Plugin::Name::FromLine::Formatter );
use Test2::Util::HashBase qw( -test_keywords -orig_line_num );

use constant DEFAULT_TEST_KEYWORDS => do {
  my %table;

  # contain all Test::More functions.
  @table{@Test2::Bundle::More::EXPORT} = (1) x @Test2::Bundle::More::EXPORT;

  # not contain fuzzy name functions
  my @fuzzy_functions = qw( is ok );
  @table{qw( is ok )} = (0) x @fuzzy_functions;

  # not contain without test functions 
  my @without_test_functions = qw(
    pass fail skip todo diag note
    plan skip_all done_testing BAIL_OUT
    subtest
    explain
  );
  @table{@without_test_functions} = (0) x @without_test_functions;

  # add fuzzy strings
  my @fuzzy_strings = (
    ( map { "$_ " } @fuzzy_functions ),
    ( map { quotemeta "$_(" } @fuzzy_functions ),
  );
  @table{@fuzzy_strings} = (1) x @fuzzy_strings;

  [ grep { $table{$_} } keys %table ];
};

sub new {
  my $class = shift;
  my $self  = $class->SUPER::new(@_);
  my $args  = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
  $self->{+TEST_KEYWORDS} = [ @{ $args->{test_keywords} // [] }, @{ +DEFAULT_TEST_KEYWORDS } ];
  $self->{+ORIG_LINE_NUM} = $self->line_num;
  $self->{+LINE}          = $self->guess_test_line;
  $self;
}

sub guess_test_line {
  my $self = shift;
  my $tmp_line = $self->file_data->[$self->line_num - 1];
  if ( grep { $tmp_line =~ /$_/ } @{ $self->test_keywords } ) {
    $tmp_line;
  } else {
    if ($self->line_num > 0) {
      $self->set_line_num( $self->line_num - 1 );
      $self->guess_test_line;
    } else {
      warn "Cannot find the line from test file.";
      $self->orig_line_num;
    }
  }
}

1;

