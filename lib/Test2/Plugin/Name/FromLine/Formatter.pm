package Test2::Plugin::Name::FromLine::Formatter;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Cwd ();
use Carp ();
use Path::Tiny ();

use parent qw( Test2::Formatter::TAP );
use Test2::Util::HashBase qw(
  -work_dir -file_name -file_path -file_data -line
  line_num
);

my $WORK_DIR = Cwd::getcwd();
my %File_cache = ();

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
  $self->{+WORK_DIR}  = $args->{work_dir}  // $WORK_DIR;
  $self->{+FILE_NAME} = $args->{file_name} // Carp::croak q{Attribute 'file_name' required.};
  $self->{+LINE_NUM}  = $args->{line_num}  // Carp::croak q{Attribute 'line_num' required.};
  $self->{+FILE_PATH} = $args->{file_path} // $self->work_dir . '/' . $self->file_name;
  $self->{+FILE_DATA} = $args->{file_data} //
    ( $File_cache{$self->file_name} //= [ split /\n/, Path::Tiny::path($self->file_path)->slurp ] );
  $self;
}

sub print_optimal_pass {
  my ($self, $e, $num, $f) = @_;
  if ( $e->isa('Test2::Event::Ok') ) {
    $e->set_name("L@{[ $self->line_num ]}: @{[ $self->line ]}") unless $e->name;
  }
  $self->SUPER::print_optimal_pass($e, $num, $f);
}

1;

