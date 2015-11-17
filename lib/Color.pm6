use v6;
class Color:version<1.001001> {
    subset ValidRGB of Real where 0 <= $_ <= 255;
    has ValidRGB $.r = 0;
    has ValidRGB $.g = 0;
    has ValidRGB $.b = 0;
    has ValidRGB $.a = 255;
    has Bool $.alpha-math is rw = False;

    ##########################################################################
    # Call forms
    ##########################################################################
    proto method new(|) { * }

    multi method new (Real:D :$r, Real:D :$g, Real:D :$b, Real:D :$a, ) {
        return self.bless(:$r, :$g, :$b, :$a);
    }

    multi method new (Real:D $c, Real:D $m, Real:D $y, Real:D $k, ) {
        return Color.new( cmyk => [ $c, $m, $y, $k ] );
    }

    multi method new (Real:D $r, Real:D $g, Real:D $b ) {
        return self.bless(:$r, :$g, :$b);
    }

    multi method new (Str:D $hex is copy where 8 <= .chars <= 9 ) {
        return self.bless( :alpha-math, |parse-hex $hex );
    }

    multi method new (Str:D $hex is copy where 3 <= .chars <= 7 ) {
        return self.bless( |parse-hex $hex );
    }

    multi method new (Str:D :$hex) { return Color.new($hex); }

    multi method new ( Array() :$rgb where $_ ~~ [Real, Real, Real] ) {
        clip-to 0, $_, 255 for @$rgb;
        return self.bless( r => $rgb[0], g => $rgb[1], b => $rgb[2] );
    }

    multi method new ( Array() :$rgbd where $_ ~~ [Real, Real, Real] ) {
        clip-to 0, $_, 1 for @$rgbd;
        return self.bless(
            r => $rgbd[0] * 255,
            g => $rgbd[1] * 255,
            b => $rgbd[2] * 255,
        );
    }

    multi method new ( Array() :$rgba where $_ ~~ [Real, Real, Real, Real] ) {
        clip-to 0, $_, 255 for @$rgba;
        return self.bless(
            r => $rgba[0],
            g => $rgba[1],
            b => $rgba[2],
            a => $rgba[3],
            :alpha-math,
        );
    }

    multi method new ( Array() :$rgbad where $_ ~~ [Real, Real, Real, Real] ) {
        clip-to 0, $_, 1 for @$rgbad;
        return self.bless(
            r => $rgbad[0] * 255,
            g => $rgbad[1] * 255,
            b => $rgbad[2] * 255,
            a => $rgbad[3] * 255,
            :alpha-math,
        );
    }

    multi method new ( Array() :$cmyk where $_ ~~ [Real, Real, Real, Real] )
    { return self.bless( |cmyk2rgb $cmyk ) }

    multi method new ( Array() :$hsl where $_ ~~ [Real, Real, Real] )
    { return self.bless( |hsl2rgb $hsl ) }

    multi method new ( Array() :$hsv where $_ ~~ [Real, Real, Real] )
    { return self.bless( |hsv2rgb $hsv ) }

    ##########################################################################
    # Methods
    ##########################################################################
    method cmyk  () { return rgb2cmyk $.r, $.g, $.b; }
    method hsl   () { return rgb2hsl  $.r, $.g, $.b; }
    method hsv   () { return rgb2hsv  $.r, $.g, $.b; }
    method rgb   () { return map { .round }, $.r, $.g, $.b;      }
    method rgba  () { return map { .round }, $.r, $.g, $.b, $.a; }
    method rgbd  () { return $.r/255, $.g/255, $.b/255;                       }
    method rgbad () { return $.r/255, $.g/255, $.b/255, $.a/255;              }
    method hex   () { return map { .fmt('%02X') }, $.r, $.g, $.b;             }
    method hex3  () {
        # Round the hex; the 247 bit is so we don't get hex 100 for high RGBs
        return map {
            my $x = $_;
            $x= 247 if $_ > 247;
            $x.round(16).base(16).substr(0,1)
        }, $.r, $.g, $.b;
    }
    method hex8  () { return map { .fmt('%02X') }, $.r, $.g, $.b, $.a;        }

    method darken  ( Real $Δ ) { return self.lighten(-$Δ); }
    method lighten ( Real $Δ ) {
        my ( $h, $s, $l ) = self.hsl;
        $l += $Δ;
        clip-to 0, $l, 100;
        return Color.new( hsl => [$h, $s, $l] );
    }
    method desaturate ( Real $Δ ) { return self.saturate(-$Δ); }
    method saturate   ( Real $Δ ) {
        my ( $h, $s, $l ) = self.hsl;
        $s += $Δ;
        clip-to 0, $s, 100;
        return Color.new( hsl => [$h, $s, $l] );
    }
    method invert () {
        return Color.new( 255-$.r, 255-$.g, 255-$.b );
    }

    method to-string(Str $type = 'hex') {
        return do given $type {
            when m:i/^ hex \d? $/ { '#' ~ self."$type"().join('') }
            when m:i/^ [ rgba?d? | cmyk | hs<[vl]> ] $/ {
                ( my $out_type = $type ) ~~ s/d$//;
                "$out_type\(" ~ self."$type"().join(", ") ~ ")"
            }
            when * { fail "Invalid format ($type) to convert to specified"; }
        }
    }
};

##############################################################################
# Conversion formulas
# The math was taken from http://www.rapidtables.com/
##############################################################################

sub rgb2hsv ( $r is copy, $g is copy, $b is copy ) {
    my ( $h, $Δ, $c_max ) = calc-hue( $r, $g, $b );

    my $s = $c_max == 0 ?? 0 !! $Δ / $c_max;
    my $v = $c_max;

    return ($h, $s*100, $v*100);
}

sub rgb2hsl ( $r is copy, $g is copy, $b is copy ) is export {
    my ( $h, $Δ, $c_max, $c_min ) = calc-hue( $r, $g, $b );
    my $l = ($c_max + $c_min) / 2;
    my $s = $Δ / (1 - abs(2*$l - 1));
    return ($h, $s*100, $l*100);
}

sub rgb2cmyk ( $r is copy, $g is copy, $b is copy ) {
    $_ /= 255 for $r, $g, $b;

    # Formula cortesy http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm
    my $k = 1 - max $r, $g, $b;
    my $c = (1 - $r - $k) / (1 - $k);
    my $m = (1 - $g - $k) / (1 - $k);
    my $y = (1 - $b - $k) / (1 - $k);
    return ($c, $m, $y, $k);
}

sub cmyk2rgb ( @ ($c is copy, $m is copy, $y is copy, $k is copy) ) {
    clip-to 0, $_, 1 for $c, $m, $y, $k;
    my $r = 255 * (1-$c) * (1-$k);
    my $g = 255 * (1-$m) * (1-$k);
    my $b = 255 * (1-$y) * (1-$k);
    return %(:$r, :$g, :$b);
}

sub hsl2rgb ( @ ($h is copy, $s is copy, $l is copy) ) is export {
    $s /= 100;
    $l /= 100;
    $h -= 360 while $h >= 360;
    $h += 360 while $h < 0;
    clip-to 0, $s, 1;
    clip-to 0, $l, 1;

    # Formula cortesy of http://www.rapidtables.com/convert/color/hsl-to-rgb.htm
    my $c = (1 - abs(2*$l - 1)) * $s;
    my $x = $c * (
        1 - abs( (($h/60) % 2) - 1 )
    );
    my $m = $l - $c/2;
    return rgb-from-c-x-m( $h, $c, $x, $m );
}

sub hsv2rgb ( @ ($h is copy, $s is copy, $v is copy) ){
    $s /= 100;
    $v /= 100;
    $h -= 360 while $h >= 360;
    $h += 360 while $h < 0;
    clip-to 0, $s, 1;
    clip-to 0, $v, 1;

    # Formula cortesy of http://www.rapidtables.com/convert/color/hsv-to-rgb.htm
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h/60) % 2) - 1 ) );
    my $m = $v - $c;
    return rgb-from-c-x-m( $h, $c, $x, $m );
}

sub rgb-from-c-x-m ($h, $c, $x, $m) {
    my ($r, $g, $b);
    given $h {
        when   0..^60  { ($r, $g, $b) = ($c, $x, 0) }
        when  60..^120 { ($r, $g, $b) = ($x, $c, 0) }
        when 120..^180 { ($r, $g, $b) = (0, $c, $x) }
        when 180..^240 { ($r, $g, $b) = (0, $x, $c) }
        when 240..^300 { ($r, $g, $b) = ($x, 0, $c) }
        when 300..^360 { ($r, $g, $b) = ($c, 0, $x) }
    }
    ( $r, $g, $b ) = map { ($_+$m) * 255 }, $r, $g, $b;
    return %(r => $r, g => $g, b => $b);
}

##############################################################################
# Utilities
##############################################################################

sub calc-hue ($r is copy, $g is copy, $b is copy ) {
    $_ /= 255 for $r, $g, $b;

    my $c_max = max $r, $g, $b;
    my $c_min = min $r, $g, $b;
    my \Δ = $c_max - $c_min;

    my $h = do given $c_max {
        when Δ == 0 { 0                        }
        when $r     { 60 * ( ($g - $b)/Δ % 6 ) }
        when $g     { 60 * ( ($b - $r)/Δ + 2 ) }
        when $b     { 60 * ( ($r - $g)/Δ + 4 ) }
    };

    return ($h, Δ, $c_max, $c_min);
}

sub parse-hex (Str:D $hex is copy) {
    $hex ~~ s/^ '#'//;
    3 <= $hex.chars <= 4 and $hex ~~ s:g/(.)/$0$0/;
    my ( $r, $g, $b, $a ) = map { :16($_) }, $hex.comb(/../);
    $a //= 255;
    return %( :$r, :$g, :$b, :$a );
}

sub clip-to ($min, $v is rw, $max) { $v = ($min max $v) min $max }
