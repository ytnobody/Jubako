package MyTest::API::MyClass;
use strict;

sub new {
    my $class = shift;
    return bless { @_ }, $class;
}

1;
