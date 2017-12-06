#!perl6

use v6;
use Test;
use lib 'lib';
use Color;
use Color::Operators;

diag 'Tests on alpha channel behavior';

subtest {

  my Color $red .= new('#ff0000');
  is $red.alpha, 255, 'alpha channel not transparent';
  $red.alpha(128);
  is $red.alpha, 128, 'alpha channel 50% transparent';

}, 'Test set alpha';


done-testing;
