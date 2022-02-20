use Color;

unit package Color::Operators;

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

sub clip-to($min, $v is rw, $max) { $v = ($min max $v) min $max }

sub op($obj1, $obj2, Str:D $op) {
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

# vim: expandtab shiftwidth=4
