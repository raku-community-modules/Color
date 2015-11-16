#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

subtest {
    my $c = Color.new( hex => '#0abcde');
    isa-ok $c, 'Color';
    can-ok $c, qw/
        r  g  b  a  cmyk  hsl  hsv  rgb  rgba  rgbd  rgbad
        hex  hex3  hex8  darken  lighten
    /;
}, 'method/ISA check';

subtest {
    my $c = Color.new( hex => '#0abcde');
    is $c.r, 10, 'red';
    is $c.g, 188, 'green';
    is $c.b, 222, 'blue';
    is $c.a, 255, 'alpha';
}, 'component colour accessors';

subtest {
    my $c = Color.new( hex => '#0abcde');
    is-deeply $c.cmyk,  [.955, .153, 0, .129], 'cmyk';
    is-deeply $c.hsl,   [190, 91.4, 45.5],     'hsl';
    is-deeply $c.hsv,   [190, 95.5, 87.1],     'hsv';
    is-deeply $c.rgb,   [10, 188, 222],        'rgb';
    is-deeply $c.rgba,  [10, 188, 222, 255],   'rgba';
    is-deeply $c.rgbd,  [.039, .737, .871],    'rgbd';
    is-deeply $c.rgbad, [.039, .737, .871, 1], 'rgbad';
    is $c.hex,  '0abcde',   'hex';
    is $c.hex3, '0bd',      'hex3';
    is $c.hex8, '0abcdeff', 'hex8';
}, 'format conversion';

subtest {
    my $c = Color.new( hsl => [25, 50, 50] );
    isa-ok $c.darken(20),     'Color';
    isa-ok $c.lighten(20),    'Color';
    isa-ok $c.saturate(20),   'Color';
    isa-ok $c.desaturate(20), 'Color';
    isa-ok $c.invert,         'Color';

    is-deeply $c.darken(20).hsl,     [25, 50, 30],        'darken by 20%'    ;
    is-deeply $c.lighten(20).hsl,    [25, 50, 70],        'lighten by 20%'   ;
    is-deeply $c.desaturate(20).hsl, [25, 30, 70],        'desaturate by 20%';
    is-deeply $c.saturate(20).hsl,   [25, 70, 70],        'saturate by 20%'  ;
    is-deeply $c.invert.rgba,        [64, 139, 192, 255], 'invert colour'    ;
}, 'color manipulation';
