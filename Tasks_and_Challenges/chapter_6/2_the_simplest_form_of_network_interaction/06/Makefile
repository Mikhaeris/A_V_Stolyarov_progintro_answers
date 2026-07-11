CC = clang
CFLAGS = -Wall -Wextra -g

BUILD = build

SERVER_SRC = server.c
CLIENT_SRC = client.c

SERVER = $(BUILD)/server
CLIENT = $(BUILD)/client

all: $(SERVER) $(CLIENT)

$(SERVER): $(SERVER_SRC)
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<

$(CLIENT): $(CLIENT_SRC)
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf $(BUILD)

.PHONY: all clean
