use v6;

sub rgb2hsl ( $r is copy, $g is copy, $b is copy ) {
    $_ /= 255 for $r, $g, $b;

    # Formula cortesy http://www.rapidtables.com/convert/color/rgb-to-hsl.htm
    my $c_max = max $r, $g, $b;
    my $c_min = min $r, $g, $b;
    my \Δ = $c_max - $c_min;

    my $h = Δ == 0 ?? 0 !! do {
        given $c_max {
            when $r { 60 * ( ($g - $b)/Δ % 6 ) }
            when $g { 60 * ( ($b - $r)/Δ + 2 ) }
            when $b { 60 * ( ($r - $g)/Δ + 4 ) }
        }
    };

    my $l = Δ / 2;
    my $s = Δ / (1 - abs(2*$l - 1));

    return %(:$h, :$s, :$l);
}

say rgb2hsl(10, 188, 222).perl;

# my $c = Color.new(rgb => [22, 42, 55]); #[0].^signature.perl.say;
# say [$c.r, $c.g, $c.b, $c.a];

# say $c.cmyk;

# c => 0.6, k => 0.784314, m => 0.236364, y => 0
# my $white        = Color.new(255, 255, 255);
# my $almost_black = Color.new('#111');
#
# my $gray = $white / 2;
# say $gray.hex; # prints "#808080"
#
# say $almost_black + 25; # prints "42, 42, 42"
