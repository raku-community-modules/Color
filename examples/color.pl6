use v6;
use Color;

use Color;
my $white        = Color.new(255, 255, 255);
my $almost_black = Color.new('#111');
say Color.new(:hsv<152 80 50>).hex; # convert HSV to HEX
say "$white is way lighter than $almost_black";
