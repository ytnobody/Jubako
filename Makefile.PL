use inc::Module::Install;
name 'Jubako';
all_from 'lib/Jubako.pm';

requires 'Class::Accessor::Fast';
requires 'Class::Load';
requtres 'String::CamelCase';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
