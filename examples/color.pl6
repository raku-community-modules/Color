use v6;
use Color;

my $c = Color.new( hsl => [ 152, 80, 50 ] );
# my $c = Color.new(r	=> 0, g	=> 0.183333, b => 1);
say [25, 229, 134];
say [$c.r, $c.g, $c.b];


# my $white        = Color.new(255, 255, 255);
# my $almost_black = Color.new('#111');
#
# my $gray = $white / 2;
# say $gray.hex; # prints "#808080"
#
# say $almost_black + 25; # prints "42, 42, 42"
