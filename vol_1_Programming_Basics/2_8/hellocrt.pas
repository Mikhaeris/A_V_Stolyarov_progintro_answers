program HelloCrt;
uses crt;
const
    TheMessage = 'Hello, world!';
    DelayDuration = 5000; { 5 seconds }
var
    x, y: integer;
begin
    clrscr;
    x := (ScreenWidth - length(TheMessage)) div 2;
    y := ScreenHeight div 2;
    GotoXY(x, y);
    write(TheMessage);
    GotoXY(1, 1);
    delay(DelayDuration);
    clrscr
end.
