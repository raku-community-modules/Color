#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

subtest {
    my $c = Color.new( hex => '#0abcde');
    isa-ok $c, 'Color';
    can-ok $c, $_, "can do $_" for qw/
        r  g  b  a  cmyk  hsl  hsla hsv  hsva rgb  rgba  rgbd  rgbad
        hex  hex3  hex4  hex8  darken  lighten
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
    is-deeply $c.cmyk,  (<106/111>, <17/111>, 0.0, <11/85>),  'cmyk';
    is-deeply $c.hsl,   (<10050/53>, <2650/29>, <2320/51>),   'hsl';
    is-deeply $c.hsla,  (<10050/53>, <2650/29>, <2320/51>, 255), 'hsla';
    is-deeply $c.hsv,   (<10050/53>, <10600/111>, <1480/17>), 'hsv';
    is-deeply $c.hsva,  (<10050/53>, <10600/111>, <1480/17>, 255), 'hsva';
    is-deeply $c.rgb,   (10, 188, 222),                       'rgb';
    is-deeply $c.rgba,  (10, 188, 222, 255),                  'rgba';
    is-deeply $c.rgbd,  (<2/51>, <188/255>, <74/85>),         'rgbd';
    is-deeply $c.rgbad, (<2/51>, <188/255>, <74/85>, 1.0),    'rgbad';
    is $c.hex,  <0A BC DE>,    'hex';
    is $c.hex3, <1 C E>,       'hex3';
    is $c.hex4, <1 C E F>,     'hex4';
    is Color.new(255, 240, 218).hex3, <F F E>,       'hex3 (rounding)';
    is Color.new(  0, 218, 214).hex3, <0 E D>,       'hex3 (rounding, more)';
    is $c.hex8, <0A BC DE FF>, 'hex8';
}, 'format conversion';

subtest {
    my $c = Color.new( hex => '#0abcde');
    is $c.to-string('cmyk'),  'cmyk(0.954955, 0.153153, 0, 0.129412)',   'cmyk';
    
    { # allow for trailing zero to be missing
        ok so($c.to-string('hsl') eq 'hsl(189.622642, 91.379310, 45.490196)'
                                   | 'hsl(189.622642, 91.37931, 45.490196)'
        ),   'hsl';

        ok so($c.to-string('hsla') eq 'hsla(189.622642, 91.379310, 45.490196, 255)'
                                   | 'hsla(189.622642, 91.37931, 45.490196, 255)'
        ),   'hsla';
    }
    
    is $c.to-string('hsv'),   'hsv(189.622642, 95.495495, 87.058824)',   'hsv';
    is $c.to-string('hsva'),   'hsva(189.622642, 95.495495, 87.058824, 255)',   'hsva';
    is $c.to-string('rgb'),   'rgb(10, 188, 222)',                       'rgb';
    is $c.to-string('rgba'),  'rgba(10, 188, 222, 255)',                 'rgba';
    is $c.to-string('rgbd'),  'rgb(0.039216, 0.737255, 0.870588)',       'rgbd';
    is $c.to-string('rgbad'), 'rgba(0.039216, 0.737255, 0.870588, 1)',  'rgbad';
    is $c.to-string('hex'),   '#0ABCDE',   'hex';
    is "$c", $c.to-string('hex'), 'stringification';
    is $c.gist, $c.to-string('hex'), '.gist';
    is $c.to-string('hex3'),  '#1CE',      'hex3';
    is $c.to-string('hex8'),  '#0ABCDEFF', 'hex8';
    dies-ok { $c.to-string('foobar') }, 'died on invalid format';
}, '.to-string()';

subtest {
    my $c = Color.new( hsl => [25, 50, 50] );
    isa-ok $c.darken(20),     'Color';
    isa-ok $c.lighten(20),    'Color';
    isa-ok $c.saturate(20),   'Color';
    isa-ok $c.desaturate(20), 'Color';
    isa-ok $c.invert,         'Color';

    is-deeply $c.darken(20).hsl,     (25.0, 50.0, 30.0),  'darken by 20%'    ;
    is-deeply $c.lighten(20).hsl,    (25.0, 50.0, 70.0),  'lighten by 20%'   ;
    is-deeply $c.desaturate(20).hsl, (25.0, 30.0, 50.0),  'desaturate by 20%';
    is-deeply $c.saturate(20).hsl,   (25.0, 70.0, 50.0),  'saturate by 20%'  ;
    is-deeply $c.invert.rgba,        (64, 138, 191, 255), 'invert colour'    ;
}, 'color manipulation';

subtest {
    my $c = Color.new( 255.0, 0.0, 0.0 );
    is-deeply $c, $c.rotate( 360 ), 'turning color wheel way around';
    is-deeply $c.invert, $c.rotate( 180 ), 'turning color wheel halfway around';
}

done-testing;
