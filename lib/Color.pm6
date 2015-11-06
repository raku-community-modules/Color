use v6;
class class Color:version<1.001001> {
    has Int $.r = 0;
    has Int $.g = 0;
    has Int $.b = 0;
    has Int $.a = 255;

    method new (Str $hex is copy) {
        $hex ~~ s/^ '#'//;
        $hex.chars == 3 and $hex ~~ s/(.)(.)(.)/$0$0$1$1$2$2/;
        my ( $r, $g, $b ) = map { :16($_) }, $hex.comb(/../);
        return self.bless(:$r, :$g, :$b);
    }
};

multi infix:<+> (Color $obj, Int $n) is export {
    RGB.new(
        r => $obj.r + $n,
        g => $obj.g + $n,
        b => $obj.b + $n,
    );
}

multi infix:<+> (Int $n, Color $obj) is export {
    RGB.new(
        r => $obj.r + $n,
        g => $obj.g + $n,
        b => $obj.b + $n,
    );
}

multi infix:<+> (Color $obj1, Color $obj2) is export {
    RGB.new(
        r => $obj1.r + $obj2.r,
        g => $obj1.g + $obj2.g,
        b => $obj1.b + $obj2.b,
    );
}

# See conversion formulas for CYMK and others here:
# http://www.rapidtables.com/convert/color/cmyk-to-rgb.htm

# ◐	9680	25D0	 	CIRCLE WITH LEFT HALF BLACK
# ◑	9681	25D1	 	CIRCLE WITH RIGHT HALF BLACK
# my $lighter = RGB.new('ccc') ◐ 10;
# my $lighter = RGB.new('ccc') ◑ 10;
# my $lighter = RGB.new('ccc') + 22.5;
