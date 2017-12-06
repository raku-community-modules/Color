use v6;


class Color:ver<1.002001>
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

    multi method new (Real:D :$r, Real:D :$g, Real:D :$b, Real:D :$a, ) {
        return self.bless(:$r, :$g, :$b, :$a);
    }

    multi method new (Real:D $c, Real:D $m, Real:D $y, Real:D $k, ) {
        return Color.new( cmyk => [ $c, $m, $y, $k ] );
    }

    multi method new (Real:D $r, Real:D $g, Real:D $b, ) {
        return self.bless(:$r, :$g, :$b);
    }

    multi method new (Real:D :$r, Real:D :$g, Real:D :$b, ) {
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
        return Color.new( hsl => [
          lighten( |self.hsl, $Δ )
        ]);
    }
    method desaturate ( Real $Δ ) { return self.saturate(-$Δ); }
    method saturate   ( Real $Δ ) {
        return Color.new( hsl => [
          saturate( |self.hsl, $Δ )
        ]);
    }
    method invert () {
        return Color.new( 255-$.r, 255-$.g, 255-$.b );
    }
    method rotate( Real $α )
    {
      return Color.new( |rotate( $.r, $.g, $.b, $α ) );
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

    # MARTIMM: better methods to get and set alpha channel
    multi method alpha ( ValidRGB $alpha ) { $!a = $alpha; $!alpha-math = True; }
    multi method alpha ( ) { $!a }

    method gist { return self.to-string('hex') };
    method Str  { return self.to-string('hex') };
};
