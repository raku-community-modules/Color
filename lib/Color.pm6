use v6;
class Color:version<1.001001> {
    has Real $.r = 0;
    has Real $.g = 0;
    has Real $.b = 0;
    has Real $.a = 255;

    multi method new (Str:D $hex is copy) {
        $hex ~~ s/^ '#'//;
        $hex.chars == 3 and $hex ~~ s/(.)(.)(.)/$0$0$1$1$2$2/;
        my ( $r, $g, $b ) = map { :16($_) }, $hex.comb(/../);
        return self.bless(:$r, :$g, :$b);
    }

    multi method new (Array :$hsv where .elems == 3) {
        return self.bless( |hsv2rgb $hsv )
    }
};

sub hsv2rgb ( @ ($h is copy, $s is copy, $v is copy) ){
    $s /= 100;
    $v /= 100;
    clip-to 0, $h, 359.999999;
    clip-to 0, $s, 1;
    clip-to 0, $v, 1;

    # Formula cortesy of http://www.rapidtables.com/convert/color/hsv-to-rgb.htm
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h/60) % 2) - 1 ) );
    my $m = $v - $c;
    my ( $r, $g, $b );
    given $h {
        when   0..^60  { ($r, $g, $b) = ($c, $x, 0) }
        when  60..^120 { ($r, $g, $b) = ($x, $c, 0) }
        when 120..^180 { ($r, $g, $b) = (0, $c, $x) }
        when 180..^240 { ($r, $g, $b) = (0, $x, $c) }
        when 240..^300 { ($r, $g, $b) = ($x, 0, $c) }
        when 300..^360 { ($r, $g, $b) = ($c, 0, $x) }
    }
    $r = ($r+$m) * 255;
    $g = ($g+$m) * 255;
    $b = ($b+$m) * 255;
    return %(r => $r, g => $g, b => $b);
}

sub clip-to ($min, $v is rw, $max) { $v = ($min max $v) min $max }

multi infix:<+> (Color $obj, Int $n) is export {
    Color.new(
        r => $obj.r + $n,
        g => $obj.g + $n,
        b => $obj.b + $n,
    );
}

multi infix:<+> (Int $n, Color $obj) is export {
    Color.new(
        r => $obj.r + $n,
        g => $obj.g + $n,
        b => $obj.b + $n,
    );
}

multi infix:<+> (Color $obj1, Color $obj2) is export {
    Color.new(
        r => $obj1.r + $obj2.r,
        g => $obj1.g + $obj2.g,
        b => $obj1.b + $obj2.b,
    );
}

# See conversion formulas for CYMK and others here:
# http://www.rapidtables.com/convert/color/cmyk-to-rgb.htm

# ◐	9680	25D0	 	CIRCLE WITH LEFT HALF BLACK
# ◑	9681	25D1	 	CIRCLE WITH RIGHT HALF BLACK
# U+1F789 	🞉  EXTREMELY HEAVY WHITE CIRCLE
# U+1F785 	🞅 	f0 9f 9e 85 	MEDIUM BOLD WHITE CIRCLE
# 0xA1 ¡  	INVERTED EXCLAMATION MARK
# my $lighter = RGB.new('ccc') ◐ 10;
# my $lighter = RGB.new('ccc') ◑ 10;
# my $lighter = RGB.new('ccc') + 22.5;
