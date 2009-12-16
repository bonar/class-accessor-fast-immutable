
use inc::Module::Install;

name     'Class-Accessor-Fast-Immutable';
license  'perl';
version  '0.01';
abstract_from 'lib/Class/Accessor/Fast/Immutable.pm';

requires      'Class::Accessor::Fast' => '0';
test_requires 'Test::More'       => '0.94';

WriteAll;

