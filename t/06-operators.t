#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

diag 'Operator tests (alpha math turned off by default)';
subtest {
    my $c1 = Color.new( rgba => [110, 120, 130, 140] );
    my $c2 = Color.new( rgba => [ 10,  20,  30,  40] );
    my $c3 = Color.new( rgba => [  2,   1,   2,   1] );

    is-deeply ($c1 + $c2).rgba, [120, 140, 160, 140], 'Color + Color';
    is-deeply ($c1 + 10).rgba,  [120, 130, 140, 140], 'Color + number';
    is-deeply (10 + $c1).rgba,  [120, 130, 140, 140], 'number + Color';

    is-deeply ($c1 - $c2).rgba, [100, 100, 100, 140], 'Color - Color';
    is-deeply ($c1 - 10).rgba,  [100, 110, 120, 140], 'Color - number';
    is-deeply (200 - $c1).rgba, [ 90,  80,  70, 140], 'number - Color';

    is-deeply ($c1 / $c2).rgba, [11, 6, 4.333, 140],    'Color / Color';
    is-deeply ($c1 / 10).rgba,  [11, 12, 13, 140],      'Color / number';
    is-deeply (200 / $c2).rgba, [ 20,  10,  6.667, 40], 'number / Color';
    is-deeply ($c1 / 0).rgba,   [ 0,  0,  0,  140],     'Color / 0 (no die)';

    is-deeply ($c1 * $c3).rgba, [220, 120, 255, 140], 'Color * Color';
    is-deeply ($c2 * 10).rgba,  [100, 200, 255,  40], 'Color * number';
    is-deeply (2 * $c2).rgba,   [ 20,  40,  60,  40], 'number * Color';
}, 'operator tests with alpha_math turned off';

diag 'Try again with enabled alpha math';
subtest {
    my $c1 = Color.new( rgba => [110, 120, 130, 140], alpha_math => True );
    my $c2 = Color.new( rgba => [ 10,  20,  30,  40], alpha_math => True );
    my $c3 = Color.new( rgba => [  2,   1,   2,   1], alpha_math => True );

    is-deeply ($c1 + $c2).rgba, [120, 140, 160, 180], 'Color + Color';
    is-deeply ($c1 + 10).rgba,  [120, 130, 140, 150], 'Color + number';
    is-deeply (10 + $c1).rgba,  [120, 130, 140, 150], 'number + Color';

    is-deeply ($c1 - $c2).rgba, [100, 100, 100, 100], 'Color - Color';
    is-deeply ($c1 - 10).rgba,  [100, 110, 120, 130], 'Color - number';
    is-deeply (200 - $c1).rgba, [ 90,  80,  70,  60], 'number - Color';

    is-deeply ($c1 / $c2).rgba, [11, 6, 4.333, 3.5],    'Color / Color';
    is-deeply ($c1 / 10).rgba,  [11, 12, 13, 14],       'Color / number';
    is-deeply (200 / $c2).rgba, [ 20,  10,  6.667,  5], 'number / Color';
    is-deeply ($c1 / 0).rgba,   [ 0,  0,  0,  0],       'Color / 0 (no die)';

    is-deeply ($c1 * $c3).rgba, [220, 120, 255, 140], 'Color * Color';
    is-deeply ($c2 * 10).rgba,  [100, 200, 255, 255], 'Color * number';
    is-deeply (2 * $c2).rgba,   [ 20,  40,  60,  80], 'number * Color';
}, 'operator tests with alpha_math turned on';

diag 'Our fancy-pants unicode ops';
subtest {
    my $c = Color.new( hsl  => [25, 50, 50] );
    isa-ok $c ◐ 20, 'Color';
    isa-ok $c ◑ 20, 'Color';
    isa-ok $c 🞅 20, 'Color';
    isa-ok $c 🞉 20, 'Color';
    isa-ok $c ¡ 20, 'Color';

    is-deeply ($c ◐ 20).hsl, $c.lighten(20).hsl,     '◐ does .lighten';
    is-deeply ($c ◑ 20).hsl, $c.darken(20).hsl,      '◑ does .darken';
    is-deeply ($c 🞅 20).hsl, $c.desaturate(20).hsl, '🞅 does .desaturate';
    is-deeply ($c 🞉 20).hsl, $c.saturate(20).hsl,   '🞉 does .saturate';
    is-deeply ($c ¡ 20).rgba, $c.invert.rgba,        '¡ does .invert';
}, 'unicode operators';
