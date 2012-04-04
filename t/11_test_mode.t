use strict;
use Test::More;
use lib qw( t );
use MyTest::API;

my $config = do ( 't/config.pl' );
my $c = MyTest::API->new( env => 'test_mode', config => $config );

isa_ok $c, 'MyTest::API';
isa_ok $c, 'Jubako';

isa_ok $c->my_class, 'MyTest::API::MyClass';
is_deeply $config->{test_mode}->{MyClass}, { %{$c->my_class} };

done_testing;