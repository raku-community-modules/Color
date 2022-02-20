[![Actions Status](https://github.com/raku-community-modules/Color/workflows/test/badge.svg)](https://github.com/raku-community-modules/Color/actions)

NAME
====

Color - Format conversion, manipulation, and math operations on colors

SYNOPSIS
========

```raku
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
```

DESCRIPTION
===========

This module allows you to perform mathematical operations on RGB color tuples, as well as convert them into other color formats, like hex, and manipulate them by, for example, making them lighter, darker, or more or less saturated.

OPERATORS
=========

```raku
use Color;
use Color::Operators;
```

Note: as of this writing (Nov 17, 2015), merely importing the operators made Rakudo compile 20 seconds slower, hence the operators are in a separate module that you'll need to import.

CONSTRUCTOR
===========

`new`
-----

```raku
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
```

Creates new `Color` object. All of the above formats are supported. **Note:** internally, the color will be converted to RGBA, which might incur slight precision loss when converting from other formats.

ATTRIBUTES
==========

`alpha-math`
------------

```raku
my $c = Color.new('abc');
$c.alpha-math = True;

my $c = Color.new('abca');
$c.alpha-math = False;
```

Boolean. Specifies whether operator math from `Color::Operators` should affect the alpha channel. Colors constructed from RGBA automatically get this attribute set to `True`, rest of formats have it set as `False`.

MANIPULATION METHODS
====================

`alpha`
=======

```raku
my Color $c .= new('#ff0088');
say $c.alpha;                   # OUTPUT: 255
$c.alpha(128);
say $c.alpha-math;              # OUTPUT: True
```

Get or set the alpha channel value.

`darken`
--------

```raku
say $c.darken(10).cmyk; # darken by 10%
```

Creates a new `Color` object that is darkened by the percentage given as the argument.

`desaturate`
------------

```raku
say $c.desaturate(20).cmyk;
```

Creates a new `Color` object that is desaturated by the percentage given as the argument.

`invert`
--------

```raku
say $c.invert.cmyk;
```

Creates a new `Color` object that is inverted (black becomes white, etc).

`lighten`
---------

```raku
say $c.lighten(10).cmyk; # lighten by 10%
```

Creates a new `Color` object that is lightened by the percentage given as the argument.

`saturate`
----------

```raku
say $c.saturate(20).cmyk;
```

Creates a new `Color` object that is saturated by the percentage given as the argument.

`rotate`
--------

```raku
$inverse = $c.rotate( 180 );
```

Creates a new `Color` object, rotated around the HSL color wheel by the angle $α (in degrees).

For all methods `darken`, `desaturate`, `invert`, `lighten`, `saturate` and `rotate` the colors will have their alpha channel copied from the input color. The attribute alpha-math is copied as well.

CONVERSION METHODS
==================

`to-string`
-----------

```raku
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
```

Converts the color to the format given by the argument and returns a string representation of it. See above for the format of the string for each color format.

**Note:** the `.gist` and `.Str` methods of the `Color` object are equivalent to `.to-string('hex')`.

`cmyk`
------

```raku
say $c.cmyk; # (<106/111>, <17/111>, 0.0, <11/85>)
```

Converts the color to CMYK format and returns a list containing each color (ranging `0`..`1`).

`hex`
-----

```raku
say $c.hex; #  (0A BC DE);
```

Returns a list of 3 2-digit hex numbers representing the color.

`hex3`
------

```raku
say $c.hex3; #  (1 C E);
```

Returns a list of 3 1-digit hex numbers representing the color. They will be rounded and they need to be doubled (i.e. the above would be `11CCEE`) to get the actual value.

`hex4`
------

```raku
say $c.hex4; #  (1 C E F);
```

Returns a list of 4 1-digit hex numbers representing the color. They will be rounded and they need to be doubled (i.e. the above would be `11CCEEFF`) to get the actual value.

`hex8`
------

```raku
say $c.hex8; #  (0A BC DE FF);
```

Returns a list of 4 2-digit hex numbers representing the color, including the Alpha space.

`hsl`
-----

```raku
say $c.hsl; # (<10050/53>, <10600/111>, <1480/17>),
```

Converts the colour to HSL format and returns the three values (hue, saturation, lightness). The S/L are returned as percentages, not decimals, so 50% saturation is returned as `50`, not `.5`.

`hsla`
------

```raku
say $c.hsla; # (<10050/53>, <10600/111>, <1480/17>, 255),
```

Converts the color to HSL format and returns the three values, and alpha channel.

`hsv`
-----

```raku
say $c.hsv; # (<10050/53>, <10600/111>, <1480/17>),
```

Converts the colour to HSV format and returns the three values (hue, saturation, value). The S/V are returned as percentages, not decimals, so 50% saturation is returned as `50`, not `.5`.

`hsva`
------

```raku
say $c.hsva; # (<10050/53>, <10600/111>, <1480/17>, 255),
```

Converts the color to HSV format and returns the three values, and alpha channel.

`rgb`
-----

```raku
say $c.rgb; # (10, 188, 222)
```

Converts the color to RGB format and returns a list of the three colors.

`rgba`
------

```raku
say $c.rgba; # (10, 188, 222, 255);
```

Converts the color to RGBA format and returns a list of the three colors, and alpha channel.

`rgbd`
------

```raku
say $c.rgbd; # (<2/51>, <188/255>, <74/85>)
```

Converts the color to RGB format ranging `0`..`1` and returns a list of the three colours.

`rgbad`
-------

```raku
say $c.rgbad; # (<2/51>, <188/255>, <74/85>, 1.0)
```

Converts the color to RGBA format ranging `0`..`1` and returns a list of the three colours, and alpha channel.

CUSTOM OPERATORS
================

`+`
---

```raku
Color.new('424') + 10;
10 + Color.new('424');
Color.new('424') + Color.new('424');
```

Add individual RGB values of each color. Plain numbers are added to each value. If [/alpha-math](/alpha-math) is turned on, alpha channel is affected as well. The operation returns a new `Color` object.

`-`
---

```raku
Color.new('424') - 10;
10 - Color.new('424');
Color.new('424') - Color.new('666');
```

Subtract individual RGB values of each color. Plain numbers are subtracted from each value. If [/alpha-math](/alpha-math) is turned on, alpha channel is affected as well. The operation returns a new `Color` object.

`*`
---

```raku
Color.new('424') * 10;
10 * Color.new('424');
Color.new('424') * Color.new('424');
```

Multiply individual RGB values of each color. Plain numbers are multiplied with each value. If [/alpha-math](/alpha-math) is turned on, alpha channel is affected as well. The operation returns a new `Color` object.

`/`
---

```raku
Color.new('424') / 10;
Color.new('424') / 0; # doesn't die; sets values to 0
10 / Color.new('424');
Color.new('424') / Color.new('424');
```

Divide individual RGB values of each color. Plain numbers are divided with each value. If [/alpha-math](/alpha-math) is turned on, alpha channel is affected as well. The operation returns a new `Color` object. Illegal operation of division by zero, doesn't die and simply sets the value to `0`.

`◐`
---

```raku
say $c ◐ 20; # lighten by 20%
```

`U+25D0 (e2 97 90): CIRCLE WITH LEFT HALF BLACK [◐]`. Same as `/lighten`

`◑`
---

```raku
say $c ◑ 20; # darken by 20%
```

`U+25D1 (e2 97 91): CIRCLE WITH RIGHT HALF BLACK [◑]`. Same as `/darken`

`🞉`
---

```raku
say $c 🞉 20; # saturate by 20%
```

`U+1F789 (f0 9f 9e 89): EXTREMELY HEAVY WHITE CIRCLE [🞉]`. Same as `/desaturate`

`¡`
---

```raku
say $c¡; # invert colour
```

`U+00A1 (c2 a1): INVERTED EXCLAMATION MARK [¡]`. Same as `/invert`

STRINGIFICATION
===============

```raku
say $c;
say "$c";
```

The `Color` object overrides `.Str` and `.gist` methods to be equivalent to `.to-string('hex')`.

Functional interface
====================

The color conversion, manipulation and utility functions are defined within the modules `Color::Conversion`, `Color::Manipulation` and `Color::Utilities` and can be used without the OO interface. The names of functions are the same as those of methods.

AUTHOR
======

Zoffix Znet

Source can be located at: https://github.com/raku-community-modules/Color . Comments and Pull Requests are welcome.

CONTRIBUTORS
============

Thanks to timotimo++, jnthn++, psch++, RabidGravy++, ab5tract++, moritz++, holli++, and anyone else who I forgot who helped me with questions on IRC.

COPYRIGHT AND LICENSE
=====================

Copyright 2015 - 2018 Zoffix Znet

Copyright 2019 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

