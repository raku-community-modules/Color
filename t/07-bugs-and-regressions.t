#!perl6

use v6;
use Test;
use lib 'lib';
use Color;

is Color.new('000').hsl, (0, 0, 0), 'black->hsl does not die (Issue #3)';

done-testing;
