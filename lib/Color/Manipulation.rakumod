use Color::Utilities;
use Color::Conversion;

unit module Color::Manipulation;

proto sub darken(|) is export {*}
multi sub darken(%hsl, Real:D $Δ) {
    lighten %hsl<h>, %hsl<s>, %hsl<l>, -$Δ
}
multi sub darken($h, $s, $l, Real:D $Δ) {
    lighten $h, $s, $l, -$Δ
}

proto sub lighten(|) is export {*}
multi sub lighten(%hsl, Real:D $Δ) {
    lighten %hsl<h>, %hsl<s>, %hsl<l>, $Δ
}
multi sub lighten($h, $s, $l is copy, Real:D $Δ) {
    $l += $Δ;
    clip-to 0, $l, 100;
    $h, $s, $l
}

proto sub desaturate(|) is export {*}
multi sub desaturate(%hsl, Real:D $Δ) {
    saturate %hsl<h>, %hsl<s>, %hsl<l>, -$Δ
}
multi sub desaturate($h, $s, $l, Real:D $Δ) {
    saturate( $h, $s, $l, -$Δ);
}

proto sub saturate(|) is export {*}
multi sub saturate(%hsl, Real:D $Δ) {
    saturate %hsl<h>, %hsl<s>, %hsl<l>, $Δ
}
multi sub saturate($h, $s is copy, $l, Real:D $Δ) {
    $s += $Δ;
    clip-to 0, $s, 100;
    $h, $s, $l
}

proto sub invert(|) is export {*}
multi sub invert(%rgb) {
    invert %rgb<r>, %rgb<g>, %rgb<b>
}
multi sub invert($r, $g, $b) {
    255-$r, 255-$g, 255-$b;
}

sub rotate($r, $g, $b, $α) is export {
    my ($h, $s, $l) = rgb2hsl($r, $g, $b);

    $h += $α;

    if $h > 360 {
        $h -= 360;
    }
    elsif $h < 0 {
        $h += 360;
    }

    hsl2rgb @($h, $s, $l)
}

# vim: expandtab shiftwidth=4
