#!perl6

use v6;
use Test;
use lib 'lib';
use Color;
use Color::Operators;

diag 'Tests on alpha channel behavior';

subtest {

  my Color $color .= new('#ff0000');
  is $color.alpha, 255, 'alpha channel not transparent';
  is $color.alpha-math, False, 'no alpha channel math';
  $color.alpha(128);
  is $color.alpha, 128, 'alpha channel 50% transparent';
  is $color.alpha-math, True, 'alpha channel math';

}, 'Test set alpha';


subtest {

  my Color $color1 .= new('#8f8f00');
  $color1.alpha(128);

  my Color $color2 = $color1.lighten(10);
  is $color2.alpha, 128, 'alpha channel still at 50% transparent after lighten';

  $color2 = $color1.darken(10);
  is $color2.alpha, 128, 'alpha channel still at 50% transparent after darken';

  $color2 = $color1.desaturate(10);
  is $color2.alpha, 128, 'alpha channel still at 50% transparent after desaturate';

  $color2 = $color1.saturate(10);
  is $color2.alpha, 128, 'alpha channel still at 50% transparent after saturate';

  $color2 = $color1.invert;
  is $color2.alpha, 128, 'alpha channel still at 50% transparent after invert';

  $color2 = $color1.rotate(10);
  is $color2.alpha, 128, 'alpha channel still at 50% transparent after rotate';

}, 'Test follow alpha on darken, saturate etc';


done-testing;
