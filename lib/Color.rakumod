use Color::Conversion;
use Color::Utilities;
use Color::Manipulation;

class Color:ver<1.004001>:auth<zef:raku-community-modules> {
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

    multi method new(Real:D :$r, Real:D :$g, Real:D :$b, Real:D :$a, *%c) {
        self.bless: :$r, :$g, :$b, :$a, |%c
    }

    multi method new(Real:D $c, Real:D $m, Real:D $y, Real:D $k, *%c) {
        self.new: cmyk => [ $c, $m, $y, $k ], |%c
    }

    multi method new(Real:D $r, Real:D $g, Real:D $b, *%c ) {
        self.bless: :$r, :$g, :$b, |%c
    }

    multi method new(Real:D :$r, Real:D :$g, Real:D :$b, *%c) {
        self.bless: :$r, :$g, :$b, |%c
    }

    multi method new(Str:D $hex is copy where 8 <= .chars <= 9, *%c) {
        self.bless: :alpha-math, |parse-hex $hex, |%c
    }

    multi method new(Str:D $hex is copy where 3 <= .chars <= 7, *%c) {
        self.bless: |parse-hex $hex, |%c
    }

    multi method new(Str:D :$hex, *%c) { self.new: $hex, |%c }

    multi method new(
      Array() :$rgb where .defined && $_ ~~ [Real, Real, Real], *%c
    ) {
        clip-to 0, $_, 255 for @$rgb;
        self.bless: r => $rgb[0], g => $rgb[1], b => $rgb[2], |%c
    }

    multi method new(
      Array() :$rgbd where .defined && $_ ~~ [Real, Real, Real], *%c
    ) {
        clip-to 0, $_, 1 for @$rgbd;
        self.bless:
          r => $rgbd[0] * 255,
          g => $rgbd[1] * 255,
          b => $rgbd[2] * 255,
          |%c
    }

    multi method new(
      Array() :$rgba where .defined && $_ ~~ [Real, Real, Real, Real], *%c
    ) {
        clip-to 0, $_, 255 for @$rgba;
        self.bless:
          r => $rgba[0],
          g => $rgba[1],
          b => $rgba[2],
          a => $rgba[3],
          :alpha-math,
          |%c
    }

    multi method new(
      Array() :$rgbad where .defined && $_ ~~ [Real, Real, Real, Real], *%c
    ) {
        clip-to 0, $_, 1 for @$rgbad;
        self.bless:
          r => $rgbad[0] * 255,
          g => $rgbad[1] * 255,
          b => $rgbad[2] * 255,
          a => $rgbad[3] * 255,
          :alpha-math,
          |%c
    }

    multi method new(
      Array() :$cmyk where .defined && $_ ~~ [Real, Real, Real, Real], *%c
    ) {
        self.bless: |cmyk2rgb $cmyk, |%c
    }

    multi method new(
      Array() :$hsl where .defined && $_ ~~ [Real, Real, Real], *%c
    ) {
        self.bless: |hsl2rgb $hsl, |%c
    }

    multi method new(
      Array() :$hsla where .defined && $_ ~~ [Real, Real, Real, Real], *%c
    ) {
        self.bless: |hsla2rgba $hsla, |%c
    }

    multi method new(Array() :$hsv where .defined && $_ ~~ [Real, Real, Real], *%c
    ) {
        self.bless: |hsv2rgb $hsv, |%c
    }

    multi method new(
      Array() :$hsva where .defined && $_ ~~ [Real, Real, Real, Real], *%c
    ) {
        self.bless: |hsva2rgba $hsva, |%c
    }

##########################################################################
# Methods
##########################################################################
    method cmyk()  { rgb2cmyk  $.r, $.g, $.b }
    method hsl()   { rgb2hsl   $.r, $.g, $.b }
    method hsla()  { rgba2hsla $.r, $.g, $.b, $.a }
    method hsv()   { rgb2hsv   $.r, $.g, $.b }
    method hsva()  { rgba2hsva $.r, $.g, $.b, $.a }
    method rgb()   { map { .round }, $.r, $.g, $.b      }
    method rgba()  { map { .round }, $.r, $.g, $.b, $.a }
    method rgbd()  { $.r/255, $.g/255, $.b/255           }
    method rgbad() { $.r/255, $.g/255, $.b/255, $.a/255  }
    method hex()   { ($.r, $.g, $.b).map: *.fmt('%02X') }

    method hex3() {
        # Round the hex; the 247 bit is so we don't get hex 100 for high RGBs
        ($.r, $.g, $.b).map: {
            ($_ min 247).round(16).base(16).substr(0,1)
        }
    }
    method hex4() {
        # Round the hex; the 247 bit is so we don't get hex 100 for high RGBs
        ($.r, $.g, $.b, $.a).map: {
            ($_ min 247).round(16).base(16).substr(0,1)
        }
    }
    method hex8() { ($.r, $.g, $.b, $.a).map: *.fmt('%02X') }

    method darken(Real $Δ) { self.lighten(-$Δ); }
    method lighten(Real $Δ) {
        my Color $c := self.new: hsl => [lighten( |self.hsl, $Δ )];
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }
    method desaturate(Real $Δ) { self.saturate(-$Δ) }
    method saturate(Real $Δ) {
        my Color $c := self.new: hsl => [saturate( |self.hsl, $Δ )];
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }
    method invert() {
        my Color $c := self.new: 255-$.r, 255-$.g, 255-$.b;
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }
    method rotate(Real $α) {
        my Color $c := self.new: |rotate $.r, $.g, $.b, $α;
        $c.alpha($!a) unless $!a == 255;
        $c.alpha-math = $!alpha-math;
        $c
    }

    method to-string(Str $type = 'hex') {
        do given $type {
            when m:i/^ hex \d? $/ { '#' ~ self."$type"().join('') }
            when m:i/^ [ rgba?d? | cmyk | hs<[vl]>a? ] $/ {
                ( my $out_type = $type ) ~~ s/d$//;
                "$out_type\(" ~ self."$type"().join(", ") ~ ")"
            }
            when * { fail "Invalid format ($type) to convert to specified"; }
        }
    }

# MARTIMM: better methods to get and set alpha channel
    multi method alpha(ValidRGB $alpha) { $!a = $alpha; $!alpha-math = True }
    multi method alpha() { $!a }

    method gist { self.to-string('hex') }
    method Str  { self.to-string('hex') }
}

##########################################################################
# Operators
##########################################################################
multi infix:<+>(Color $c1, Real  $c2) is export { Color.new(|op $c1, $c2, '+') }
multi infix:<+>(Real  $c1, Color $c2) is export { Color.new(|op $c1, $c2, '+') }
multi infix:<+>(Color $c1, Color $c2) is export { Color.new(|op $c1, $c2, '+') }
multi infix:<->(Color $c1, Real  $c2) is export { Color.new(|op $c1, $c2, '-') }
multi infix:<->(Real  $c1, Color $c2) is export { Color.new(|op $c1, $c2, '-') }
multi infix:<->(Color $c1, Color $c2) is export { Color.new(|op $c1, $c2, '-') }
multi infix:<*>(Color $c1, Real  $c2) is export { Color.new(|op $c1, $c2, '*') }
multi infix:<*>(Real  $c1, Color $c2) is export { Color.new(|op $c1, $c2, '*') }
multi infix:<*>(Color $c1, Color $c2) is export { Color.new(|op $c1, $c2, '*') }
multi infix:</>(Color $c1, Real  $c2) is export { Color.new(|op $c1, $c2, '/') }
multi infix:</>(Real  $c1, Color $c2) is export { Color.new(|op $c1, $c2, '/') }
multi infix:</>(Color $c1, Color $c2) is export { Color.new(|op $c1, $c2, '/') }
multi infix:<◐>(Color $c1, Real:D $Δ) is export { $c1.lighten($Δ) }
multi infix:<◑>(Color $c1, Real:D $Δ) is export { $c1.darken($Δ) }
multi infix:<🞅>(Color $c1, Real:D $Δ) is export { $c1.desaturate($Δ) }
multi infix:<🞉>(Color $c1, Real:D $Δ) is export { $c1.saturate($Δ) }
multi postfix:<¡>(Color $c1) is export { $c1.invert }

##############################################################################
# Operator helpers
##############################################################################

my sub op($obj1, $obj2, Str:D $op) {
    my %r;
    for <r g b> {
        my $v1 = $obj1 ~~ Color ?? $obj1."$_"() !! $obj1;
        my $v2 = $obj2 ~~ Color ?? $obj2."$_"() !! $obj2;
        %r{$_} = ::('&infix:<' ~ $op ~ '>')($v1, $v2);
        %r{$_} = 0 if $op eq '/' and $v2 == 0;
    }

    %r<a> = $obj1 ~~ Color ?? $obj1.a !! $obj2.a;
    if $obj1.?alpha-math or $obj2.?alpha-math {
        %r<a> = ::('&infix:<' ~$op~ '>')($obj1.?a // $obj1, $obj2.?a // $obj2);
        %r<a> = 0
          if $op eq '/' and ( $obj2 ~~ Color ?? $obj2.a == 0 !! $obj2 == 0 );
    }

    clip-to 0, $_, 255 for values %r;
    %r
}

# See conversion formulas for CMYK and others here:
# http://www.rapidtables.com/convert/color/cmyk-to-rgb.htm

# ◐	9680	25D0	 	CIRCLE WITH LEFT HALF BLACK
# ◑	9681	25D1	 	CIRCLE WITH RIGHT HALF BLACK
# U+1F789 	🞉  EXTREMELY HEAVY WHITE CIRCLE
# U+1F785 	🞅 	f0 9f 9e 85 	MEDIUM BOLD WHITE CIRCLE
# 0xA1 ¡  	INVERTED EXCLAMATION MARK
# my $lighter = RGB.new('ccc') ◐ 10;
# my $lighter = RGB.new('ccc') ◑ 10;
# my $lighter = RGB.new('ccc') + 22.5;

=begin pod

=head1 NAME

Color - Format conversion, manipulation, and math operations on colors

=head1 SYNOPSIS

=begin code :lang<raku>

use Color;

my $white        = Color.new(255, 255, 255);
my $almost_black = Color.new('#111');
say Color.new(:hsv<152 80 50>).hex; # convert HSV to HEX
say "$white is way lighter than $almost_black";

my $lighter_pink = Color.new('#ED60A2').lighten(20);
my $lighter_pink = Color.new('#ED60A2') ◐ 20; # same as above

my $saturated_pink = Color.new('#ED60A2').saturate(20);
my $saturated_pink = Color.new('#ED60A2') 🞉 20; # same as above

# Create an inverted colour scheme:
$_ = .invert for @colours_in_my_colourscheme;

# Some ops to use on Color objects
my $gray = $white / 2;
say $gray.hex; # prints "#808080"
say $almost_black + 25; # prints "42, 42, 42"

=end code

=head1 DESCRIPTION

This module allows you to perform mathematical operations on RGB color tuples,
as well as convert them into other color formats, like hex, and manipulate
them by, for example, making them lighter, darker, or more or less saturated.

=head1 CONSTRUCTOR

=head2 C<new>

=begin code :lang<raku>

my $rgb = Color.new('abc');
Color.new('#abc');
Color.new('face');
Color.new('#face');
Color.new('abcdef');
Color.new('#abcdef');
Color.new('abcdefaa');
Color.new('#abcdefaa');
Color.new(:hex<abc>); # same applies to all other hex variants
Color.new( 255, 100, 25 ); # RGB
Color.new( .5, .1, .3, .4 ); # CMYK
Color.new( rgb => [ 255, 100, 25 ] );
Color.new(:rgb<255 100 25>); # same works on other formats
Color.new( rgbd => [.086, .165, .282] ); # decimal RGB
Color.new( rgba => [ 22, 42, 72, 88 ] );
Color.new( rgbad => [ .086, .165, .282, .345 ] );
Color.new( cmyk => [.55, .25, .85, .12] );
Color.new( hsl => [ 72, 78, 65] );
Color.new( hsla => [ 72, 78, 65, 42] );
Color.new( hsv => [ 90, 60, 70] );
Color.new( hsva => [ 90, 60, 70, 88] );

=end code

Creates new C<Color> object. All of the above formats are supported.
B<Note:> internally, the color will be converted to RGBA, which might
incur slight precision loss when converting from other formats.

=head1 ATTRIBUTES

=head2 C<alpha-math>

=begin code :lang<raku>

my $c = Color.new('abc');
$c.alpha-math = True;

my $c = Color.new('abca');
$c.alpha-math = False;

=end code

Boolean. Specifies whether operator math from C<Color::Operators> should affect
the alpha channel. Colors constructed from RGBA automatically get this
attribute set to C<True>, rest of formats have it set as C<False>.

=head1 MANIPULATION METHODS

=head1 C<alpha>

=begin code :lang<raku>

my Color $c .= new('#ff0088');
say $c.alpha;                   # OUTPUT: 255
$c.alpha(128);
say $c.alpha-math;              # OUTPUT: True

=end code

Get or set the alpha channel value.

=head2 C<darken>

=begin code :lang<raku>

say $c.darken(10).cmyk; # darken by 10%

=end code

Creates a new C<Color> object that is darkened by the percentage given as the
argument.

=head2 C<desaturate>

=begin code :lang<raku>

say $c.desaturate(20).cmyk;

=end code

Creates a new C<Color> object that is desaturated by the percentage given as
the argument.

=head2 C<invert>

=begin code :lang<raku>

say $c.invert.cmyk;

=end code

Creates a new C<Color> object that is inverted (black becomes white, etc).

=head2 C<lighten>

=begin code :lang<raku>

say $c.lighten(10).cmyk; # lighten by 10%

=end code

Creates a new C<Color> object that is lightened by the percentage given as the
argument.

=head2 C<saturate>

=begin code :lang<raku>

say $c.saturate(20).cmyk;

=end code

Creates a new C<Color> object that is saturated by the percentage given as
the argument.

=head2 C<rotate>

=begin code :lang<raku>

$inverse = $c.rotate( 180 );

=end code

Creates a new C<Color> object, rotated around the HSL color wheel
by the angle $α (in degrees).

For all methods C<darken>, C<desaturate>, C<invert>, C<lighten>, C<saturate>
and C<rotate> the colors will have their alpha channel copied from the
input color. The attribute alpha-math is copied as well.

=head1 CONVERSION METHODS

=head2 C<to-string>

=begin code :lang<raku>

$c.to-string('cmyk'); #   cmyk(0.954955, 0.153153, 0, 0.129412)
$c.to-string('hsl');  #   hsl(189.622642, 91.379310, 45.490196)
$c.to-string('hsla'); #   hsl(189.622642, 91.379310, 45.490196, 255)
$c.to-string('hsv');  #   hsv(189.622642, 95.495495, 87.058824)
$c.to-string('hsva'); #   hsva(189.622642, 95.495495, 87.058824, 255)
$c.to-string('rgb');  #   rgb(10, 188, 222)
$c.to-string('rgba'); #   rgba(10, 188, 222, 255)
$c.to-string('rgbd'); #   rgb(0.039216, 0.737255, 0.870588)
$c.to-string('rgbad');#   rgba(0.039216, 0.737255, 0.870588, 1)
$c.to-string('hex');  #   #0ABCDE
$c.to-string('hex3'); #   #1CE
$c.to-string('hex8'); #   #0ABCDEFF

=end code

Converts the color to the format given by the argument and returns a string
representation of it. See above for the format of the string for each
color format.

B<Note:> the C<.gist> and C<.Str> methods of the C<Color> object
are equivalent to C<.to-string('hex')>.

=head2 C<cmyk>

=begin code :lang<raku>

say $c.cmyk; # (<106/111>, <17/111>, 0.0, <11/85>)

=end code

Converts the color to CMYK format and returns a list containing each color
(ranging `0`..`1`).

=head2 C<hex>

=begin code :lang<raku>

say $c.hex; #  (0A BC DE);

=end code

Returns a list of 3 2-digit hex numbers representing the color.

=head2 C<hex3>

=begin code :lang<raku>

say $c.hex3; #  (1 C E);

=end code

Returns a list of 3 1-digit hex numbers representing the color. They will
be rounded and they need to be doubled (i.e. the above would be C<11CCEE>)
to get the actual value.

=head2 C<hex4>

=begin code :lang<raku>

say $c.hex4; #  (1 C E F);

=end code

Returns a list of 4 1-digit hex numbers representing the color. They will
be rounded and they need to be doubled (i.e. the above would be C<11CCEEFF>)
to get the actual value.

=head2 C<hex8>

=begin code :lang<raku>

say $c.hex8; #  (0A BC DE FF);

=end code

Returns a list of 4 2-digit hex numbers representing the color, including
the Alpha space.

=head2 C<hsl>

=begin code :lang<raku>

say $c.hsl; # (<10050/53>, <10600/111>, <1480/17>),

=end code

Converts the colour to HSL format and returns the three values
(hue, saturation, lightness). The S/L are returned as percentages, not decimals,
so 50% saturation is returned as C<50>, not C<.5>.

=head2 C<hsla>

=begin code :lang<raku>

say $c.hsla; # (<10050/53>, <10600/111>, <1480/17>, 255),

=end code

Converts the color to HSL format and returns the three values,
and alpha channel.

=head2 C<hsv>

=begin code :lang<raku>

say $c.hsv; # (<10050/53>, <10600/111>, <1480/17>),

=end code

Converts the colour to HSV format and returns the three values
(hue, saturation, value). The S/V are returned as percentages, not decimals,
so 50% saturation is returned as C<50>, not C<.5>.

=head2 C<hsva>

=begin code :lang<raku>

say $c.hsva; # (<10050/53>, <10600/111>, <1480/17>, 255),

=end code

Converts the color to HSV format and returns the three values,
and alpha channel.

=head2 C<rgb>

=begin code :lang<raku>

say $c.rgb; # (10, 188, 222)

=end code

Converts the color to RGB format and returns a list of the three colors.

=head2 C<rgba>

=begin code :lang<raku>

say $c.rgba; # (10, 188, 222, 255);

=end code

Converts the color to RGBA format and returns a list of the three colors,
and alpha channel.

=head2 C<rgbd>

=begin code :lang<raku>

say $c.rgbd; # (<2/51>, <188/255>, <74/85>)

=end code

Converts the color to RGB format ranging C<0>..C<1> and returns a list of
the three colours.

=head2 C<rgbad>

=begin code :lang<raku>

say $c.rgbad; # (<2/51>, <188/255>, <74/85>, 1.0)

=end code

Converts the color to RGBA format ranging C<0>..C<1> and returns a list of
the three colours, and alpha channel.

=head1 OPERATORS

=head2 C<+>

=begin code :lang<raku>

Color.new('424') + 10;
10 + Color.new('424');
Color.new('424') + Color.new('424');

=end code

Add individual RGB values of each color. Plain numbers are added to each
value. If L</alpha-math> is turned on, alpha channel is affected as well.
The operation returns a new C<Color> object.

=head2 C<->

=begin code :lang<raku>

Color.new('424') - 10;
10 - Color.new('424');
Color.new('424') - Color.new('666');

=end code

Subtract individual RGB values of each color. Plain numbers are subtracted
from each value. If L</alpha-math> is turned on, alpha channel is affected
as well. The operation returns a new C<Color> object.

=head2 C<*>

=begin code :lang<raku>

Color.new('424') * 10;
10 * Color.new('424');
Color.new('424') * Color.new('424');

=end code

Multiply individual RGB values of each color. Plain numbers are multiplied
with each value. If L</alpha-math> is turned on, alpha channel is affected
as well. The operation returns a new C<Color> object.

=head2 C</>

=begin code :lang<raku>

Color.new('424') / 10;
Color.new('424') / 0; # doesn't die; sets values to 0
10 / Color.new('424');
Color.new('424') / Color.new('424');

=end code

Divide individual RGB values of each color. Plain numbers are divided
with each value. If L</alpha-math> is turned on, alpha channel is affected
as well. The operation returns a new C<Color> object. Illegal operation
of division by zero, doesn't die and simply sets the value to C<0>.

=head2 C<◐>

=begin code :lang<raku>

say $c ◐ 20; # lighten by 20%

=end code

C<U+25D0 (e2 97 90): CIRCLE WITH LEFT HALF BLACK [◐]>. Same as C</lighten>

=head2 C<◑>

=begin code :lang<raku>

say $c ◑ 20; # darken by 20%

=end code

C<U+25D1 (e2 97 91): CIRCLE WITH RIGHT HALF BLACK [◑]>. Same as C</darken>

=head2 C<🞉>

=begin code :lang<raku>

say $c 🞉 20; # saturate by 20%

=end code

C<U+1F789 (f0 9f 9e 89): EXTREMELY HEAVY WHITE CIRCLE [🞉]>.
Same as C</desaturate>

=head2 C<¡>

=begin code :lang<raku>

say $c¡; # invert colour

=end code

C<U+00A1 (c2 a1): INVERTED EXCLAMATION MARK [¡]>. Same as C</invert>

=head1 STRINGIFICATION

=begin code :lang<raku>

say $c;
say "$c";

=end code

The C<Color> object overrides C<.Str> and C<.gist> methods to be
equivalent to C<.to-string('hex')>.

=head1 Functional interface

The color conversion, manipulation and utility functions are defined within
the modules C<Color::Conversion>, C<Color::Manipulation> and C<Color::Utilities> and can
be used without the OO interface. The names of functions are the same as those of methods.

=head1 AUTHOR

Zoffix Znet

Source can be located at: https://github.com/raku-community-modules/Color .
Comments and Pull Requests are welcome.

=head1 CONTRIBUTORS

Thanks to timotimo++, jnthn++, psch++, RabidGravy++, ab5tract++, moritz++, holli++,
and anyone else who I forgot who helped me with questions on IRC.

=head1 COPYRIGHT AND LICENSE

Copyright 2015 - 2018 Zoffix Znet

Copyright 2019 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
