
use v6;
use Test;
use lib 'lib';
use Color;

# Short 3-hex
subtest {
    my $c = Color.new('#fac');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new('#fac')";

subtest {
    my $c = Color.new('fac');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new('fac')";

# Short 4-hex
subtest {
    my $c = Color.new('#face');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 238, 'alpha is correct';
}, ".new('#face')";

subtest {
    my $c = Color.new('face');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 238, 'alpha is correct';
}, ".new('face')";

# Full 6-hex
subtest {
    my $c = Color.new('#0abcde');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new('#0abcde')";

subtest {
    my $c = Color.new('0abcde');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new('0abcde')";

# Full 8-hex
subtest {
    my $c = Color.new('#0abcdef4');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 244, 'alpha is correct';
}, ".new('#0abcdef4')";

subtest {
    my $c = Color.new('0abcdef4');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 244, 'alpha is correct';
}, ".new('0abcdef4')";

done-testing;
