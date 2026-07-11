CC = clang
CFLAGS = -Wall -Wextra -g
SRC = server.c
OUT = build/server

$(OUT): $(SRC)
	@mkdir -p build
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

run: $(OUT)
	./$(OUT)

clean:
	rm -rf build

.PHONY: run clean
