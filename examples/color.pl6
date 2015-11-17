use v6;
use Color;

my $c = Color.new(rgb => [22, 42, 55]); #[0].^signature.perl.say;
say [204, 60.0, 21.6];
say Color.hsv;

# say $c.cmyk;

# c => 0.6, k => 0.784314, m => 0.236364, y => 0
# my $white        = Color.new(255, 255, 255);
# my $almost_black = Color.new('#111');
#
# my $gray = $white / 2;
# say $gray.hex; # prints "#808080"
#
# say $almost_black + 25; # prints "42, 42, 42"
