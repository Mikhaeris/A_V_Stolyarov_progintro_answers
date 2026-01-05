program Task29;
type
    pair = record
        a: integer;
        b: real;
    end;

    twoptrs = record
        g, h: ^pair;
        t: ^integer;
    end;

    twoptrsptr = ^twoptrs;

procedure proc1(p: twoptrsptr);
begin
    writeln('m.a: ', p^.g^.a, ' | m.b: ', p^.g^.b);
    writeln('n.a: ', p^.h^.a, ' | n.b: ', p^.h^.b);
    writeln('x: ', p^.t^);
end;

var
    tp2: twoptrs;
    m, n: pair;
    x: integer;
begin
    m.a := 11;
    m.b := 22;

    n.a := 333;
    n.b := 444;

    x := 9;

    tp2.g := @m;
    tp2.h := @n;
    tp2.t := @x;

    proc1(@tp2)
end.
