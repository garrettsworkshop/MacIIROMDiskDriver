# path to RETRO68
RETRO68=/Users/zane/Retro68-build/toolchain

PREFIX=$(RETRO68)/m68k-apple-macos
CC=$(RETRO68)/bin/m68k-apple-macos-gcc
CXX=$(RETRO68)/bin/m68k-apple-macos-g++
OBJCOPY=$(RETRO68)/bin/m68k-apple-macos-objcopy
REZ=$(RETRO68)/bin/Rez

LDFLAGS=-lRetroConsole
RINCLUDES=$(PREFIX)/RIncludes
REZFLAGS=-I$(RINCLUDES)

all: bin/rdisk.bin

obj:
	mkdir obj

bin:
	mkdir bin

obj/rdisk.o: rdisk.c obj
	$(CC) -c -O1 $< -o $@

bin/rdisk.bin: obj/rdisk.o bin
	$(OBJCOPY) -O binary obj/rdisk.o $@

.PHONY: clean
clean:
	rm -fr bin obj
