ZAPC = zapc
CC ?= cc
CFLAGS ?= -Wall -g -Og
BUILD_DIR = build
OUT_DIR = out
TARGET = $(OUT_DIR)/zempl

SRCS_C = $(wildcard src/*.c)
SRCS_ZAP = $(wildcard src/*.zp)

OBJS = $(patsubst src/%.c,$(BUILD_DIR)/%.o,$(SRCS_C)) \
       $(patsubst src/%.zp,$(BUILD_DIR)/%.o,$(SRCS_ZAP))

all: $(TARGET)

$(BUILD_DIR) $(OUT_DIR):
	mkdir -p $@

$(TARGET): $(BUILD_DIR) $(OUT_DIR) $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

$(BUILD_DIR)/%.o: src/%.zp | $(BUILD_DIR)
	$(ZAPC) $< -c -o $@

$(BUILD_DIR)/%.o: src/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	$(TARGET)

clean:
	rm -rf $(BUILD_DIR) $(OUT_DIR)

.PHONY: all run clean
