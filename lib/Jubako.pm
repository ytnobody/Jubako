package Jubako;
use strict;
use warnings;
use parent qw( Class::Accessor::Fast );
use Class::Load qw( :all );
use String::CamelCase ();

our $VERSION = '0.01';
our $AUTOLOAD;

__PACKAGE__->mk_accessors( qw( config objects prefix env ) );

sub new {
    my ( $class, %args ) = @_;
    $args{env} ||= 'default';
    $args{prefix} ||= $class;
    $args{config} ||= {};
    $args{objects} = {};
    return $class->SUPER::new( \%args );
}

sub _get {
    my ( $self, $key ) = @_;
    my $env = $self->env;
    my $config = $self->config->{$env}->{$key} || $self->config->{default}->{$key};
    my $klass = join '::', $self->prefix, $key;
    unless ( is_class_loaded( $klass ) ) {
        load_class( $klass );
    }
    $self->{objects}->{$key} ||= $klass->new( %$config );
    return $self->{objects}->{$key};
}

sub AUTOLOAD {
    my $self = shift;
    my ( $key ) = $AUTOLOAD =~ /([^:']+$)/;
    return $self->_get( String::CamelCase::camelize( $key ) );
}

1;
__END__

=head1 NAME

Jubako - Configurable Tiny Object Container

=head1 SYNOPSIS

  # your container class ( lib/MyApp/API.pm )
  package MyApp::API;
  use parent;
  1;
  
  # some your API class ( lib/MyApp/API/LWP.pm )
  package MyApp::API::LWP;
  use parent qw( LWP::UserAgent );
  1;
  
  # config file for your container ( config.pl )
  {
    default => {
      'LWP' => {
         timeout => 3,
         agent => 'MyApp::API::LWP/0.01',
      },
    },
    development => {
      'LWP' => {
         timeout => 30,
         agent => 'MyApp::API::LWP(DEVELOPMENT)/0.01',
      },
    },
  }
  
  # finally, you may do it.
  use MyApp::API;
  my $container = MyApp::API->new( env => 'development', config => do( 'config.pl' ) );
  my $res = $container->LWP->get( $url );

=head1 DESCRIPTION

Jubako is an object container class.

=head1 AUTHOR

satoshi azuma E<lt>ytnobody at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

