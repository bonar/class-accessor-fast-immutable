
use strict;
use warnings;

use Test::More tests => 17;

BEGIN {
    use_ok('Class::Accessor::Fast');
    use_ok('Class::Accessor::Fast::Immutable');
}

{
    package Bonar;
    use base 'Class::Accessor::Fast';
    __PACKAGE__->mk_accessors(qw/
        foo
        bar
    /);

    1;
}

my ($test);

{ # create instance (now this instance is mutable)
    $test = Bonar->new();
    isa_ok($test, 'Bonar');
    ok(!defined $test->foo, 'foo not defined yet');
    ok(!defined $test->bar, 'bar not defined yet');

    $test->foo(1);
    $test->bar(1);

    is($test->foo, 1, 'foo defined');
    is($test->bar, 1, 'bar defined');

    $test->foo(2);
    $test->bar(2);

    is($test->foo, 2, 'foo updated');
    is($test->bar, 2, 'bar updated');
}

{ # immutablize
    ok($test->can('make_immutable'), 'instance can make_immutable');
    isa_ok($test->make_immutable, 'Class::Accessor::Fast');

    # readable
    is($test->foo, 2, 'foo is 2');
    is($test->bar, 2, 'bar is 2');

    # but not writable
    eval { $test->foo(2); };
    ok($@, 'foo set failed');
    eval { $test->bar(2); };
    ok($@, 'bar set failed');

    is($test->foo, 2, 'foo is 2 (not changed)');
    is($test->bar, 2, 'bar is 2 (not changed)');


}




