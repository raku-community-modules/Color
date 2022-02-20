use Color::Utilities;

unit module Color::Conversion;

##############################################################################
# Conversion formulas
# The math was taken from http://www.rapidtables.com/
##############################################################################

sub rgb2hsv($r is copy, $g is copy, $b is copy) is export {
    my ($h, $Δ, $c_max) = calc-hue($r, $g, $b);

    my $s := $c_max == 0 ?? 0 !! $Δ / $c_max;
    my $v := $c_max;

    $h, $s*100, $v*100
}

sub rgba2hsva($r, $g, $b, $a) is export {
    my ($h, $s, $v) = rgb2hsv($r, $g, $b);

    $h, $s, $v, $a
}

sub rgb2hsl($r is copy, $g is copy, $b is copy) is export {
    my ($h, $Δ, $c_max, $c_min) = calc-hue($r, $g, $b);
    my $l := ($c_max + $c_min) / 2;
    my $s := $Δ == 0 ?? 0 !! $Δ / (1 - abs(2*$l - 1));

    $h, $s*100, $l*100
}

sub rgba2hsla($r, $g, $b, $a) is export {
    my ($h, $s, $l) = rgb2hsl( $r, $g, $b);
    $h, $s, $l, $a
}

sub rgb2cmyk($r is copy, $g is copy, $b is copy) is export  {
    $_ /= 255 for $r, $g, $b;

    # Formula courtesy http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm
    my $k := 1 - max $r, $g, $b;
    my $c := (1 - $r - $k) / (1 - $k);
    my $m := (1 - $g - $k) / (1 - $k);
    my $y := (1 - $b - $k) / (1 - $k);
    $c, $m, $y, $k
}

sub cmyk2rgb( @ ($c is copy, $m is copy, $y is copy, $k is copy) ) is export  {
    clip-to 0, $_, 1 for $c, $m, $y, $k;
    my $r := 255 * (1-$c) * (1-$k);
    my $g := 255 * (1-$m) * (1-$k);
    my $b := 255 * (1-$y) * (1-$k);
    %(:$r, :$g, :$b)
}

sub hsl2rgb( @ ($h is copy, $s is copy, $l is copy) ) is export {
    $s /= 100;
    $l /= 100;
    $h -= 360 while $h >= 360;
    $h += 360 while $h < 0;
    clip-to 0, $s, 1;
    clip-to 0, $l, 1;

    # Formula courtesy of http://www.rapidtables.com/convert/color/hsl-to-rgb.htm
    my $c := (1 - abs(2*$l - 1)) * $s;
    my $x := $c * (1 - abs( (($h/60) % 2) - 1 ));
    my $m := $l - $c/2;
    rgb-from-c-x-m $h, $c, $x, $m
}

sub hsla2rgba( @ ($h, $s, $l, $a) ) is export {
    %(hsl2rgb(($h, $s, $l)), :$a)
}

sub hsv2rgb( @ ($h is copy, $s is copy, $v is copy) )  is export {
    $s /= 100;
    $v /= 100;
    $h -= 360 while $h >= 360;
    $h += 360 while $h < 0;
    clip-to 0, $s, 1;
    clip-to 0, $v, 1;

    # Formula cortesy of http://www.rapidtables.com/convert/color/hsv-to-rgb.htm
    my $c := $v * $s;
    my $x := $c * (1 - abs( (($h/60) % 2) - 1 ) );
    my $m := $v - $c;
    rgb-from-c-x-m $h, $c, $x, $m
}

sub hsva2rgba( @ ($h, $s, $v, $a) ) is export {
    %(hsv2rgb(($h, $s, $v)), :$a)
}

sub rgb-from-c-x-m($h, $c, $x, $m) is export {
    my ($r, $g, $b);
    given $h {
        when   0..^60  { ($r, $g, $b) = ($c, $x, 0) }
        when  60..^120 { ($r, $g, $b) = ($x, $c, 0) }
        when 120..^180 { ($r, $g, $b) = (0, $c, $x) }
        when 180..^240 { ($r, $g, $b) = (0, $x, $c) }
        when 240..^300 { ($r, $g, $b) = ($x, 0, $c) }
        when 300..^360 { ($r, $g, $b) = ($c, 0, $x) }
    }
    ( $r, $g, $b ) = ($r,$g,$b).map: { ($_+$m) * 255 }
    %(r => $r.Real, g => $g.Real, b => $b.Real)
}

# vim: expandtab shiftwidth=4
