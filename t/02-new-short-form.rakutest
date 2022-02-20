#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

diag 'Short 3-hex';
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

diag 'Short 4-hex';
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

diag 'Full 6-hex';
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

diag 'Full 8-hex';
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

diag 'RGB tuple';
subtest {
    my $c = Color.new( 22, 42, 72 );
    isa-ok $c, 'Color';
    is $c.r, 22, 'red is correct';
    is $c.g, 42, 'green is correct';
    is $c.b, 72, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( 22, 42, 72 )";

diag 'CMYK tuple';
subtest {
    my $c = Color.new( .55, .25, .85, .12 );
    isa-ok $c, 'Color';
    is $c.r, 100.98, 'red is correct';
    is $c.g, 168.3, 'green is correct';
    is $c.b, 33.66, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( .55, .25, .85, .12 )";

done-testing;
