#!/usr/bin/env bash
set -e

PROG_NAME="main"
PROG_DIR="./build/release/"

Args=(
    'fGh'
    'Abc Dcg abc h@j.k.l'
    'h@j.k.l'
    'h@ads'
    '1111 113'
    'M'
)

Ans=(
    $'fGh'
    $'Abc\nDcg\nh@j.k.l'
    $'h@j.k.l'
    ''
    '1111'
    'M'
)

for idx in "${!Args[@]}"; do
    output="$("${PROG_DIR}${PROG_NAME}" ${Args[$idx]})"

    if [[ "$output" == "${Ans[$idx]}" ]]; then
        printf "OK:\n%s\n\n" "${Args[$idx]}"
    else
	printf "TEST: $idx\n"
        printf "FAIL:\n%s\n\n" "${Args[$idx]}"
        printf "Expected:\n%s\n" "${Ans[$idx]}"
        printf "Got:\n%s\n" "$output"
    fi
done

