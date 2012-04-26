use strict;
use Test::More;
use Config::Pit;
use lib qw( t );
use MyTest::API;

my $config = do ( 't/config.pl' );
Config::Pit::set( "default", data => $config->{default} );

my $c = MyTest::API->new;

isa_ok $c, 'MyTest::API';
isa_ok $c, 'Jubako';

isa_ok $c->my_class, 'MyTest::API::MyClass';
is_deeply $c->config, $config->{default};
is_deeply $config->{default}->{MyClass}, { %{$c->my_class} };

END {
    Config::Pit::set( "default", data => undef );
};

done_testing;
