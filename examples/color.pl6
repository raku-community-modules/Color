use v6;
use Color;

my $c = Color.new(rgb => [22, 42]); #[0].^signature.perl.say;
say [$c.r, $c.g, $c.b, $c.a];


# my $white        = Color.new(255, 255, 255);
# my $almost_black = Color.new('#111');
#
# my $gray = $white / 2;
# say $gray.hex; # prints "#808080"
#
# say $almost_black + 25; # prints "42, 42, 42"
