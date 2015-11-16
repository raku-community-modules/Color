#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

diag 'Short 3-hex';
subtest {
    my $c = Color.new( hex => '#fac');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hex => '#fac')";

subtest {
    my $c = Color.new( hex => 'fac');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hex => 'fac')";

subtest {
    my $c = Color.new(:hex<fac>);
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new(:hex<fac>)";

diag 'Short 4-hex';
subtest {
    my $c = Color.new( hex => '#face');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 238, 'alpha is correct';
}, ".new( hex => '#face')";

subtest {
    my $c = Color.new( hex => 'face');
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 238, 'alpha is correct';
}, ".new( hex => 'face')";

subtest {
    my $c = Color.new( :hex<face> );
    isa-ok $c, 'Color';
    is $c.r, 255, 'red is correct';
    is $c.g, 170, 'green is correct';
    is $c.b, 204, 'blue is correct';
    is $c.a, 238, 'alpha is correct';
}, ".new( :hex<face> )";

diag 'Full 6-hex';
subtest {
    my $c = Color.new( hex => '#0abcde');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hex => '#0abcde')";

subtest {
    my $c = Color.new( hex => '0abcde');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hex => '0abcde')";

subtest {
    my $c = Color.new( :hex<0abcde>);
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( :hex<0abcde> )";

diag 'Full 8-hex';
subtest {
    my $c = Color.new( hex => '#0abcdef4');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 244, 'alpha is correct';
}, ".new( hex => '#0abcdef4')";

subtest {
    my $c = Color.new( hex => '0abcdef4');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 244, 'alpha is correct';
}, ".new( hex => '0abcdef4')";

subtest {
    my $c = Color.new( :hex<0abcdef4> );
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 244, 'alpha is correct';
}, ".new( :hex<0abcdef4> )";

diag 'RGB tuple';
subtest {
    my $c = Color.new( rgb => [22, 42, 72] );
    isa-ok $c, 'Color';
    is $c.r, 22, 'red is correct';
    is $c.g, 42, 'green is correct';
    is $c.b, 72, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( rgb => [22, 42, 72] )";

subtest {
    my $c = Color.new(:rgb<22 42 72>);
    isa-ok $c, 'Color';
    is $c.r, 22, 'red is correct';
    is $c.g, 42, 'green is correct';
    is $c.b, 72, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new(:rgb<22 42 72>)";

diag 'RGB tuple (decimal form)';
subtest {
    my $c = Color.new( rgbd => [.086, .165, .282] );
    isa-ok $c, 'Color';
    is $c.r, 21.93, 'red is correct';
    is $c.g, 42.075, 'green is correct';
    is $c.b, 71.91, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( rgbd => [.086, .165, .282] )";

subtest {
    my $c = Color.new( :rgbd<.086 .165 .282> );
    isa-ok $c, 'Color';
    is $c.r, 21.93, 'red is correct';
    is $c.g, 42.075, 'green is correct';
    is $c.b, 71.91, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( :rgbd<.086 .165 .282> )";

diag 'RGBA tuple';
subtest {
    my $c = Color.new( rgba => [ 22, 42, 72, 88 ] );
    isa-ok $c, 'Color';
    is $c.r, 22, 'red is correct';
    is $c.g, 42, 'green is correct';
    is $c.b, 72, 'blue is correct';
    is $c.a, 88, 'alpha is correct';
}, ".new( rgba => [ 22, 42, 72, 88 ] )";

subtest {
    my $c = Color.new( :rgba<22 42 72 88> );
    isa-ok $c, 'Color';
    is $c.r, 22, 'red is correct';
    is $c.g, 42, 'green is correct';
    is $c.b, 72, 'blue is correct';
    is $c.a, 88, 'alpha is correct';
}, ".new( :rgba<22 42 72 88> )";

diag 'RGBA tuple (decimal form)';
subtest {
    my $c = Color.new( rgbad => [ .086, .165, .282, .345 ] );
    isa-ok $c, 'Color';
    is $c.r, 21.93, 'red is correct';
    is $c.g, 42.075, 'green is correct';
    is $c.b, 71.91, 'blue is correct';
    is $c.a, 87.975, 'alpha is correct';
}, ".new( rgbad => [ .086, .165, .282, .345 ] )";

subtest {
    my $c = Color.new( :rgbad< .086 .165 .282 .345> );
    isa-ok $c, 'Color';
    is $c.r, 21.93, 'red is correct';
    is $c.g, 42.075, 'green is correct';
    is $c.b, 71.91, 'blue is correct';
    is $c.a, 87.975, 'alpha is correct';
}, ".new( :rgbad< .086 .165 .282 .345> )";

diag 'CMYK tuple';
subtest {
    my $c = Color.new( cmyk => [.55, .25, .85, .12] );
    isa-ok $c, 'Color';
    is $c.r, 100.98, 'red is correct';
    is $c.g, 168.3, 'green is correct';
    is $c.b, 33.66, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( cmyk => [.55, .25, .85, .12] )";

subtest {
    my $c = Color.new( :cmyk<.55 .25 .85 .12> );
    isa-ok $c, 'Color';
    is $c.r, 100.98, 'red is correct';
    is $c.g, 168.3, 'green is correct';
    is $c.b, 33.66, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( :cmyk<.55 .25 .85 .12> )";

diag 'HSL tuple';
subtest {
    my $c = Color.new( hsl => [ 72, 78, 65] );
    isa-ok $c, 'Color';
    is $c.r, 207.519, 'red is correct';
    is $c.g, 235.365, 'green is correct';
    is $c.b, 96.135, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hsl => [ 72, 78, 65] )";

subtest {
    my $c = Color.new( :hsl< 72 78 65> );
    isa-ok $c, 'Color';
    is $c.r, 207.519, 'red is correct';
    is $c.g, 235.365, 'green is correct';
    is $c.b, 96.135, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( :hsl< 72 78 65> )";

diag 'HSV tuple';
subtest {
    my $c = Color.new( hsv => [ 90, 60, 70] );
    isa-ok $c, 'Color';
    is $c.r, 124.95, 'red is correct';
    is $c.g, 178.5, 'green is correct';
    is $c.b, 71.4, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hsv => [ 90, 60, 70] )";

subtest {
    my $c = Color.new( :hsv<90 60 70> );
    isa-ok $c, 'Color';
    is $c.r, 124.95, 'red is correct';
    is $c.g, 178.5, 'green is correct';
    is $c.b, 71.4, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( :hsv<90 60 70> )";

done-testing;
