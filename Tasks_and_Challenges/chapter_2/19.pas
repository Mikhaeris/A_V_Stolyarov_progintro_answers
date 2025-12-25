program Counter;
type
    int_t = integer;
var
    { a }
    count_words: int_t;

    { b }
    count_even_words: int_t;
    count_odd_words: int_t;

    { c }
    count_words_len_more_seven: int_t;
    count_words_len_less_or_equal_two: int_t;

    { d }
    count_words_Az: int_t;

    { e }
    max_word_len: int_t;
    min_word_len: int_t;

    { f }
    max_spaces_sequence: int_t;

    { g }
    balance_brackets: boolean;

    { h }
    open_and_close_brackets: int_t;

procedure GlobalReset();
begin
    { a }
    count_words := 0;
    
    { b }
    count_even_words := 0;
    count_odd_words := 0;

    { c }
    count_words_len_more_seven := 0;
    count_words_len_less_or_equal_two := 0;

    { d }
    count_words_Az := 0;

    { e }
    max_word_len := 0;
    min_word_len := high(int_t);

    { f }
    max_spaces_sequence := 0;

    { g }
    balance_brackets := false;

    { h }
    open_and_close_brackets := 0
end;

function CheckSp(var c: char): boolean;
begin
    CheckSp := (c = ' ') or (c = #9) or (c = #10);
end;

procedure report(var num_str: int_t);
begin
    writeln('Num_str - ', num_str);
    writeln('a) count words: ', count_words);
    writeln('b) count words: even: ', count_even_words, ' odd: ', count_odd_words);
    writeln('c) count words more than seven: ', count_words_len_more_seven,
         #10'   count words less or equal two: ', count_words_len_less_or_equal_two);
    writeln('d) count words start with ''A'' and finist with ''z'': ', count_words_Az);
    if count_words = 0 then
        min_word_len := 0;
    writeln('e) count words: ', count_words,
         #10'   max word len: ', max_word_len,
         #10'   min word len: ', min_word_len);
    writeln('f) max word len: ', max_word_len,
         #10'   max spaces sequence: ', max_spaces_sequence);
    write('g) balance_brackets: ');
    if balance_brackets then
        writeln('YES')
    else
        writeln('NO');
    writeln('h) count open and close brackets: ', open_and_close_brackets);
    writeln;
end;

var
    c, prev_c: char;
    num_str: int_t;

    word_len: int_t;
    word_start: char;
    word_finish: char;

    count_spaces: int_t;
    
    have_brackets: boolean;
    brackets: int_t;
begin
    prev_c := ' ';
    num_str := 1;
    word_len := 0;
    count_spaces := 0;
    have_brackets := false;
    brackets := 0;
    
    GlobalReset();

    while not eof do
    begin
        { end line }
        if prev_c = #10 then
        begin
            if have_brackets and (brackets = 0) then
                balance_brackets := true;
            report(num_str);

            GlobalReset();
            
            num_str := num_str + 1;

            { reset }
            count_spaces := 0;
            have_brackets := false;
            brackets := 0
        end;

        read(c);

        { word start }
        if CheckSp(prev_c) and not CheckSp(c) then
        begin
            word_start := c;
            if max_spaces_sequence < count_spaces then
                max_spaces_sequence := count_spaces;
            count_spaces := 0
        end;

        { word end }
        if (CheckSp(c) or eof) and not CheckSp(prev_c) then
        begin
            word_finish := prev_c;

            if word_len = 0 then
                continue;

            { a }
            count_words := count_words + 1;
            
            { b }
            if (word_len mod 2) = 0 then
                count_even_words := count_even_words + 1
            else
                count_odd_words := count_odd_words + 1;

            { c }
            if word_len > 7 then
                count_words_len_more_seven := count_words_len_more_seven + 1;
            if word_len <= 2 then
                count_words_len_less_or_equal_two := count_words_len_less_or_equal_two + 1;

            { d }
            if (word_start = 'A') and (word_finish = 'z') then
                count_words_Az := count_words_Az + 1;

            { e }
            if max_word_len < word_len then
                max_word_len := word_len;
            if min_word_len > word_len then
                min_word_len := word_len;

            word_len := 0
        end;

        { h }
        if (prev_c = '(') and (c = ')') then
            open_and_close_brackets := open_and_close_brackets + 1;

        prev_c := c;
        if c = ' ' then
            count_spaces := count_spaces + 1;
        if CheckSp(c) or eof then
            continue;

        { in word }
        word_len := word_len + 1;

        { f }
        if c = '(' then
        begin
            have_brackets := true;
            brackets := brackets + 1
        end
        else if c = ')' then
        begin
            have_brackets := true;
            brackets := brackets - 1
        end;

        if brackets < 0 then
            balance_brackets := false
    end;
    report(num_str)
end.
