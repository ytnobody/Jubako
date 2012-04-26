package Jubako;
use strict;
use warnings;
use parent qw( Class::Accessor::Fast );
use Class::Load qw( :all );
use Config::Pit;
use String::CamelCase ();

our $VERSION = '0.02';
our $AUTOLOAD;

__PACKAGE__->mk_accessors( qw( config objects prefix env ) );

sub new {
    my ( $class, $env ) = @_;
    my %args;
    $args{env} = $env || 'default';
    $args{prefix} ||= $class;
    $args{config} = pit_get( $args{env} ) || {};
    $args{objects} = {};
    return $class->SUPER::new( \%args );
}

sub _get {
    my ( $self, $key ) = @_;
    my $config = $self->config->{$key} || {};
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

First, create your container class.

  # your container class ( lib/MyApp/API.pm )
  package MyApp::API;
  use parent( Jubako );
  1;

Then, create your API class.

  # some your API class ( lib/MyApp/API/LWP.pm )
  package MyApp::API::LWP;
  use parent qw( LWP::UserAgent );
  1;

Next step, configure API using Config::Pit.

  # configure API using Config::Pit. 
  use Config::Pit;
  Config::Pit::set( "development", data => {
      'LWP' => {
         timeout => 3,
         agent => 'MyApp::API::LWP/0.01',
      },
  } );
  ### AND YOU HAVE TO RUN AVOBE SCRIPT!

When using your container...
  
  use MyApp::API;
  my $api = MyApp::API->new( 'development' );
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

