ZAPC = zapc
CC ?= cc
CFLAGS ?= -Wall
BUILD_DIR = build
OUT_DIR = out
TARGET = $(OUT_DIR)/zempl

OBJS = $(BUILD_DIR)/main.o \
       $(BUILD_DIR)/util.o \
       $(BUILD_DIR)/zpr.o

all: $(TARGET)

$(BUILD_DIR) $(OUT_DIR):
	mkdir -p $@

$(TARGET): $(BUILD_DIR) $(OUT_DIR) $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

$(BUILD_DIR)/main.o: src/main.zap | $(BUILD_DIR)
	$(ZAPC) src/main.zap -c -o $@

$(BUILD_DIR)/%.o: src/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	$(TARGET)

clean:
	rm -rf $(BUILD_DIR) $(OUT_DIR)

.PHONY: all run clean
