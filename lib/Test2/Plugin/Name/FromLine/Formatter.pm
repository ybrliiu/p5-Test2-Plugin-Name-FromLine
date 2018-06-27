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

sub init {
  my $self = shift;
  $self->{+FILE_NAME} // Carp::croak q{Attribute 'file_name' required.};
  $self->{+WORK_DIR}  //= $WORK_DIR;
  $self->{+FILE_PATH} //= $self->work_dir . '/' . $self->file_name;
  $self->{+FILE_DATA} //= 
    ( $File_cache{$self->file_name} //= [ split /\n/, Path::Tiny::path($self->file_path)->slurp ] );
  $self->SUPER::init();
}

sub new_root {
  my $class = shift;
  ref $class ? $class : $class->SUPER::new_root(@_);
}

sub write {
  my ($self, $e, $num, $f) = @_;
  if ( $e->isa('Test2::Event::Ok') ) {
    my $line_num = $e->trace->frame->[2];
    my $name = "L${line_num}: " . ( $e->name // $self->file_data->[ $line_num - 1 ] );
    $e->set_name($name);
    if ( ref $f eq 'HASH' ) {
      $f->{assert}->{details} = $name;
    }
    # my $details = $e->facet_data->{assert}->{details};
    # warn $details;
  }
  $self->SUPER::write($e, $num, $f);
}

1;

