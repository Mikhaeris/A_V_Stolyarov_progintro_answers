program ManyArgs;

type
    int_t = integer;
var
    { a }
    longest_str: string;

    { g }
    first_str: string;

procedure Report();
begin
    writeln('a) length: ', Length(longest_str), ' str: ', longest_str)
end;

{ b }
function CheckRepeatChar(var str: string): boolean;
const
    AsciiLength = 128;
var
    chars: array [0..AsciiLength] of int_t;

    i: int_t;
    n: int_t;
begin
    CheckRepeatChar := false;
    for i := 0 to AsciiLength do
        chars[i] := 0;

    for i := 1 to Length(str) do
    begin
        n := ord(str[i]);
        chars[n] := chars[n] + 1;

        if chars[n] > 1 then
        begin
            CheckRepeatChar := true;
            break
        end
    end
end;

{ c }
function CheckTermsForC(var str: string): boolean;
var
    CharAt: boolean;
    CountDots: int_t;

    i: int_t;
begin
    CharAt := true;
    CountDots := 0;

    for i := 1 to Length(str) do
    begin
        if str[i] = '@' then
            CharAt := true;
        
        if str[i] = '.' then
            CountDots := CountDots + 1
    end;

    CheckTermsForC := CharAt and (CountDots > 1)
end;

{ d }
function HaveOnlyNumbers(var str: string): boolean;
var
    i: int_t;
begin
    HaveOnlyNumbers := true;

    for i := 1 to Length(str) do
    begin
        if not (('0' <= str[i]) and (str[i] <= '9')) then
        begin
            HaveOnlyNumbers := false;
            break
        end
    end
end;

{ e }
function ConsistsOnlyOneChar(var str: string): boolean;
var
    i: int_t;
    firstChar: char;
begin
    ConsistsOnlyOneChar := true;
    if Length(str) = 1 then
        exit;
    
    firstChar := str[1];
    for i := 2 to Length(str) do
    begin
        if str[i] <> firstChar then
        begin
            ConsistsOnlyOneChar := false;
            exit
        end
    end
end;

{ f }
function HaveLatinChar(var str: string): boolean;
var
    i: int_t;
begin
    HaveLatinChar := false;
    for i := 1 to Length(str) do
    begin
        if (('a' <= str[i]) and (str[i] <= 'z')) or
           (('A' <= str[i]) and (str[i] <= 'Z')) then
            HaveLatinChar := true
    end
end;

{ g }
function ContainRepeatWithFirstArg(var str: string): boolean;
var
    i, j: int_t;
begin
    ContainRepeatWithFirstArg := false;
    if str = first_str then
        exit;
    for i := 1 to Length(str) do
    begin
        for j := 1 to Length(first_str) do
        begin
            if str[i] = first_str[j] then
            begin
                ContainRepeatWithFirstArg := true;
                exit
            end
        end
    end
end;

var
    i: int_t;
    curr_str: string;
begin
    { a }
    longest_str := '';
    { g }
    if ParamCount > 1 then
        first_str := ParamStr(1)
    else
        first_str := '';

    curr_str := '';
    for i := 1 to ParamCount do
    begin
        { debug }
        writeln('[', i, ']: ', ParamStr(i));

        curr_str := ParamStr(i);
        
        { a }
        if Length(curr_str) > Length(longest_str) then
            longest_str := curr_str;

        { b }
        if not CheckRepeatChar(curr_str) then
            writeln('b) ', curr_str);
        
        { c }
        if CheckTermsForC(curr_str) then
            writeln('c) ', curr_str);

        { d }
        if HaveOnlyNumbers(curr_str) then
            writeln('d) ', curr_str);

        { e }
        if ConsistsOnlyOneChar(curr_str) then
            writeln('e) ', curr_str);

        { f }
        if HaveLatinChar(curr_str) then
            writeln('f) ', curr_str);

        { g }
        if ContainRepeatWithFirstArg(curr_str) then
            writeln('g) ', curr_str);

        { reset }
        SetLength(curr_str, 0);
    end;
    
    if ParamCount > 1 then
        Report;
end.
