ZAPC ?= zapc

SRCS   := $(wildcard src/*.zp)
ENTRY  := src/main.zp
TARGET := out/zempl

all: $(TARGET)

$(TARGET): $(SRCS)
	mkdir -p $(dir $@)
	$(ZAPC) $(ENTRY) -o $(TARGET)

run: $(TARGET)
	$(TARGET)

clean:
	rm -rf out

.PHONY: all run clean
