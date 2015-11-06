#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

my $c = Color.new( hex => '#0abcde');

subtest {
    my $c = Color.new( hex => '#0abcde');
    isa-ok $c, 'Color';
    is $c.r, 10, 'red is correct';
    is $c.g, 188, 'green is correct';
    is $c.b, 222, 'blue is correct';
    is $c.a, 255, 'alpha is correct';
}, ".new( hex => '#0abcde')";
my $c =
