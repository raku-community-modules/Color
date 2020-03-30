use v6;


class Color:ver<1.002008>
{
    use Color::Conversion;
    use Color::Utilities;
    use Color::Manipulation;

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

    multi method new (Real:D :$r, Real:D :$g, Real:D :$b, Real:D :$a, *%c) {
        return self.bless(:$r, :$g, :$b, :$a, |%c);
    }

    multi method new (Real:D $c, Real:D $m, Real:D $y, Real:D $k, *%c) {
        return self.new( cmyk => [ $c, $m, $y, $k ], |%c );
    }

    multi method new (Real:D $r, Real:D $g, Real:D $b, *%c ) {
        return self.bless(:$r, :$g, :$b, |%c);
    }

    multi method new (Real:D :$r, Real:D :$g, Real:D :$b, *%c) {
        return self.bless(:$r, :$g, :$b, |%c);
    }

    multi method new (Str:D $hex is copy where 8 <= .chars <= 9, *%c) {
        return self.bless( :alpha-math, |parse-hex $hex, |%c );
    }

    multi method new (Str:D $hex is copy where 3 <= .chars <= 7, *%c) {
        return self.bless( |parse-hex $hex, |%c );
    }

    multi method new (Str:D :$hex, *%c) { return self.new($hex, |%c); }

    multi method new ( Array() :$rgb where $_ ~~ [Real, Real, Real], *%c ) {
        clip-to 0, $_, 255 for @$rgb;
        return self.bless( r => $rgb[0], g => $rgb[1], b => $rgb[2], |%c );
    }

    multi method new ( Array() :$rgbd where $_ ~~ [Real, Real, Real], *%c ) {
        clip-to 0, $_, 1 for @$rgbd;
        return self.bless(
            r => $rgbd[0] * 255,
            g => $rgbd[1] * 255,
            b => $rgbd[2] * 255,
            |%c
        );
    }

    multi method new ( Array() :$rgba where $_ ~~ [Real, Real, Real, Real], *%c ) {
        clip-to 0, $_, 255 for @$rgba;
        return self.bless(
            r => $rgba[0],
            g => $rgba[1],
            b => $rgba[2],
            a => $rgba[3],
            :alpha-math,
            |%c
        );
    }

    multi method new ( Array() :$rgbad where $_ ~~ [Real, Real, Real, Real], *%c ) {
        clip-to 0, $_, 1 for @$rgbad;
        return self.bless(
            r => $rgbad[0] * 255,
            g => $rgbad[1] * 255,
            b => $rgbad[2] * 255,
            a => $rgbad[3] * 255,
            :alpha-math,
            |%c
        );
    }

    multi method new ( Array() :$cmyk where $_ ~~ [Real, Real, Real, Real], *%c )
    { return self.bless( |cmyk2rgb $cmyk, |%c ) }

    multi method new ( Array() :$hsl where $_ ~~ [Real, Real, Real], *%c )
    { return self.bless( |hsl2rgb $hsl, |%c ) }

    multi method new ( Array() :$hsla where $_ ~~ [Real, Real, Real, Real], *%c )
    { return self.bless( |hsla2rgba $hsla, |%c ) }

    multi method new ( Array() :$hsv where $_ ~~ [Real, Real, Real], *%c )
    { return self.bless( |hsv2rgb $hsv, |%c ) }

    multi method new ( Array() :$hsva where $_ ~~ [Real, Real, Real, Real], *%c )
    { return self.bless( |hsva2rgba $hsva, |%c ) }

    ##########################################################################
    # Methods
    ##########################################################################
    method cmyk  () { return rgb2cmyk  $.r, $.g, $.b; }
    method hsl   () { return rgb2hsl   $.r, $.g, $.b; }
    method hsla  () { return rgba2hsla $.r, $.g, $.b, $.a; }
    method hsv   () { return rgb2hsv   $.r, $.g, $.b; }
    method hsva  () { return rgba2hsva $.r, $.g, $.b, $.a; }
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
    method hex4  () {
        # Round the hex; the 247 bit is so we don't get hex 100 for high RGBs
        return map {
            my $x = $_;
            $x= 247 if $_ > 247;
            $x.round(16).base(16).substr(0,1)
        }, $.r, $.g, $.b, $.a;
    }
    method hex8  () { return map { .fmt('%02X') }, $.r, $.g, $.b, $.a;        }

    method darken  ( Real $Δ ) { return self.lighten(-$Δ); }
    method lighten ( Real $Δ ) {
        my Color $c = self.new( hsl => [lighten( |self.hsl, $Δ )]);
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }
    method desaturate ( Real $Δ ) { return self.saturate(-$Δ); }
    method saturate   ( Real $Δ ) {
        my Color $c = self.new( hsl => [saturate( |self.hsl, $Δ )]);
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }
    method invert () {
        my Color $c = self.new( 255-$.r, 255-$.g, 255-$.b );
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }
    method rotate( Real $α )
    {
        my Color $c = self.new( |rotate( $.r, $.g, $.b, $α ) );
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }

    method to-string(Str $type = 'hex') {
        return do given $type {
            when m:i/^ hex \d? $/ { '#' ~ self."$type"().join('') }
            when m:i/^ [ rgba?d? | cmyk | hs<[vl]>a? ] $/ {
                ( my $out_type = $type ) ~~ s/d$//;
                "$out_type\(" ~ self."$type"().join(", ") ~ ")"
            }
            when * { fail "Invalid format ($type) to convert to specified"; }
        }
    }

    # MARTIMM: better methods to get and set alpha channel
    multi method alpha ( ValidRGB $alpha ) { $!a = $alpha; $!alpha-math = True; }
    multi method alpha ( ) { $!a }

    method gist { return self.to-string('hex') };
    method Str  { return self.to-string('hex') };
};
