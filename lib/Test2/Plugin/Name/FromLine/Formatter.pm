package Test2::Plugin::Name::FromLine::Formatter;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';

use parent qw( Test2::Formatter::TAP );
use Class::Accessor::Lite (
  new => 0,
  ro  => [qw( work_dir file_name file_path file_data line line_num )],
);

use Cwd qw( getcwd );
use Path::Tiny qw( path );

my $WORK_DIR = getcwd;
my %File_cache = ();

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
  $self->{work_dir}  = $args->{work_dir}  // $WORK_DIR;
  $self->{file_name} = $args->{file_name} // die "${class} required attribute file_name.";
  $self->{line_num}  = $args->{line_num}  // die "${class} required attribute line_num.";
  $self->{file_path} = $args->{file_path} // $self->work_dir . '/' . $self->file_name;
  $self->{file_data} = $args->{file_data} //
    ( $File_cache{$self->file_name} //= [ split /\n/, path($self->file_path)->slurp ] );
  $self;
}

sub print_optimal_pass {
  my ($self, $e, $num, $f) = @_;
  # Test2::Formatter::TAP でもこんな感じだったけど
  # 直接オブジェクトのハッシュいじってるけど大丈夫これ?
  if ( $e->isa('Test2::Event::Ok') ) {
    unless ($e->name) {
      $e->set_name("L@{[ $self->line_num ]}: @{[ $self->line ]}");
    }
  }
  $self->SUPER::print_optimal_pass($e, $num, $f);
}

1;

