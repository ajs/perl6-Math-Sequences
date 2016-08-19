# Top-level module just imports the rest.

use CompUnit::Util :re-export;

need Math::Sequences::Integer;
need Math::Sequences::Real;

BEGIN re-export('Math::Sequences::Integer');
BEGIN re-export('Math::Sequences::Real');

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
