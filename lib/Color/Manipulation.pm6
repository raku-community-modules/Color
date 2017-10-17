unit module Color::Manipulation;

use Color::Utilities;
use Color::Conversion;

multi sub darken  ( %hsl, Real $Δ ) is export  {
  lighten( %hsl<h>, %hsl<s>, %hsl<l>, -$Δ);
}

multi sub darken  ( $h, $s, $l, Real $Δ ) is export  {
  lighten( $h, $s, $l, -$Δ);
}

multi sub lighten ( %hsl, Real $Δ ) is export  {
  lighten( %hsl<h>, %hsl<s>, %hsl<l>, $Δ);
}

multi sub lighten ( $h, $s, $l is copy  , Real $Δ ) is export  {
    $l += $Δ;
    clip-to 0, $l, 100;
    return $h, $s, $l;
}

multi sub desaturate ( %hsl, Real $Δ ) is export  {
  saturate( %hsl<h>, %hsl<s>, %hsl<l>, -$Δ);
}

multi sub desaturate ( $h, $s, $l, Real $Δ ) is export  {
  saturate( $h, $s, $l, -$Δ);
}

multi sub saturate ( %hsl, Real $Δ ) is export  {
  saturate( %hsl<h>, %hsl<s>, %hsl<l>, $Δ);
}

multi sub saturate ( $h, $s is copy, $l, Real $Δ ) is export  {
    $s += $Δ;
    clip-to 0, $s, 100;
    return $h, $s, $l;
}

multi sub invert (%rgb) is export {
  invert( %rgb<r>, %rgb<g>, %rgb<b> )
}

multi sub invert ($r, $g, $b) is export {
    return 255-$r, 255-$g, 255-$b;
}

sub rotate( $r, $g, $b, $α ) is export {
    my ($h, $s, $l) = rgb2hsl( $r, $g, $b );

    $h += $α;

    if $h > 360 {
        $h -= 360;
    } elsif $h < 0 {
        $h += 360;
    }

  return hsl2rgb( @($h, $s, $l) );
}
