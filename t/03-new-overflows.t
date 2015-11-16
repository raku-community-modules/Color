#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

subtest {
    my $c = Color.new(  rgba => [ 300, 300, -10, -10 ] );
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 255, 'green is correct';
    is $c.b, 0, 'blue is correct';
    is $c.a, 0, 'alpha is correct';
}, "RGBA overflow";

subtest {
    my $c = Color.new( hsl => [ 370, 200, 200 ] );
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 255, 'green is correct';
    is $c.b, 255, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, "HSL overflow (top)";

subtest {
    my $c = Color.new( hsl => [ -10, -10, -10 ] );
    isa-ok $c, 'Color';
    is $c.r, 0, 'red is correct';
    is $c.g, 0, 'green is correct';
    is $c.b, 0, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, "HSL overflow (bottom)";

subtest {
    my $c = Color.new( hsv => [ 370, 200, 200 ] );
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 0, 'green is correct';
    is $c.b, 0.00000425, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, "HSV overflow (top)";

subtest {
    my $c = Color.new( hsv => [ -10, -10, -10 ] );
    isa-ok $c, 'Color';
    is $c.r, 0, 'red is correct';
    is $c.g, 0, 'green is correct';
    is $c.b, 0, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, "HSV overflow (bottom)";

subtest {
    my $c = Color.new( cmyk => [ 2, 2, -2, -2 ] );
    isa-ok $c, 'Color';
    is $c.r, 0, 'red is correct';
    is $c.g, 0, 'green is correct';
    is $c.b, 255, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, "CMYK overflow";

done-testing;
