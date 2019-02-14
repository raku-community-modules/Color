##############################################################################
# Utilities
##############################################################################

unit module Color::Utilities;

sub calc-hue ($r is copy, $g is copy, $b is copy ) is export {
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

sub parse-hex (Str:D $hex is copy) is export
{
    $hex ~~ s/^ '#'//;
    3 <= $hex.chars <= 4 and $hex ~~ s:g/(.)/$0$0/;
    my ( $r, $g, $b, $a ) = map { :16($_).Int }, $hex.comb(/../);
    $a //= 255;
    return %( :$r, :$g, :$b, :$a );
}

sub clip-to ($min, $v is rw, $max) is export { $v = ($min max $v) min $max }
