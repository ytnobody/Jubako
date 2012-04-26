use strict;
use Test::More;
use Config::Pit;
use lib qw( t );
use MyTest::API;

my $config = do ( 't/config.pl' );
Config::Pit::switch( "test_mode" );
Config::Pit::set( "MyTest::API", data => $config->{test_mode} );

my $c = MyTest::API->new( 'test_mode' );

isa_ok $c, 'MyTest::API';
isa_ok $c, 'Jubako';
isa_ok $c->my_class, 'MyTest::API::MyClass';
is_deeply $c->config, $config->{test_mode};
is_deeply $config->{test_mode}->{MyClass}, { %{$c->my_class} };

END {
    Config::Pit::set( "MyTest::API", data => undef );
};

done_testing;
