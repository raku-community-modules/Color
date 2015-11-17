#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

subtest {
    my $c = Color.new( rgba => [ 300, 300, -10, -10 ] );
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
}, "hsv overflow (bottom)";

subtest {
    is Color.new( hsl => [ -50, 50, 50 ] ).to-string('hsl'),
        Color.new( hsl => [ 310, 50, 50 ] ).to-string('hsl'), '-50 == 310';
    is Color.new( hsl => [ 700, 50, 50 ] ).to-string('hsl'),
        Color.new( hsl => [ 340, 50, 50 ] ).to-string('hsl'), '700 == 340';
    is Color.new( hsl => [ -1050, 50, 50 ] ).to-string('hsl'),
        Color.new( hsl => [ 30, 50, 50 ] ).to-string('hsl'), '-1050 == 30';
    is Color.new( hsl => [ 1700, 50, 50 ] ).to-string('hsl'),
        Color.new( hsl => [ 260, 50, 50 ] ).to-string('hsl'), '1700 == 260';
}, "HSL hue overflow (should just overflow into a proper angle)";

subtest {
    my $c = Color.new( hsv => [ 370, 200, 200 ] );
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 42.5, 'green is correct';
    is $c.b, 0, 'blue is correct';
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
    is Color.new( hsv => [ -50, 50, 50 ] ).to-string('hsv'),
        Color.new( hsv => [ 310, 50, 50 ] ).to-string('hsv'), '-50 == 310';
    is Color.new( hsv => [ 700, 50, 50 ] ).to-string('hsv'),
        Color.new( hsv => [ 340, 50, 50 ] ).to-string('hsv'), '700 == 340';
    is Color.new( hsv => [ -1050, 50, 50 ] ).to-string('hsv'),
        Color.new( hsv => [ 30, 50, 50 ] ).to-string('hsv'), '-1050 == 30';
    is Color.new( hsv => [ 1700, 50, 50 ] ).to-string('hsv'),
        Color.new( hsv => [ 260, 50, 50 ] ).to-string('hsv'), '1700 == 260';
}, "HSV hue overflow (should just overflow into a proper angle)";

subtest {
    my $c = Color.new( cmyk => [ 2, 2, -2, -2 ] );
    isa-ok $c, 'Color';
    is $c.r, 0, 'red is correct';
    is $c.g, 0, 'green is correct';
    is $c.b, 255, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, "CMYK overflow";

done-testing;
