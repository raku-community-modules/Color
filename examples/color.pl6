use v6;
use Color;

my $c = Color.new( hsv => [ 229, 100, 100 ] );
say $c.r, $c.b, $c.g;


# my $white        = Color.new(255, 255, 255);
# my $almost_black = Color.new('#111');
#
# my $gray = $white / 2;
# say $gray.hex; # prints "#808080"
#
# say $almost_black + 25; # prints "42, 42, 42"
