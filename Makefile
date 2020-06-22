# path to RETRO68
RETRO68=/Users/zane/Retro68-build/toolchain

PREFIX=$(RETRO68)/m68k-apple-macos
CC=$(RETRO68)/bin/m68k-apple-macos-gcc
CXX=$(RETRO68)/bin/m68k-apple-macos-g++
OBJCOPY=$(RETRO68)/bin/m68k-apple-macos-objcopy
OBJDUMP=$(RETRO68)/bin/m68k-apple-macos-objdump
REZ=$(RETRO68)/bin/Rez

LDFLAGS=-lRetroConsole
RINCLUDES=$(PREFIX)/RIncludes
REZFLAGS=-I$(RINCLUDES)

all: bin/rom.bin

obj:
	mkdir obj

bin:
	mkdir bin

bin/sym:
	mkdir bin/sym

obj/rdisk.o: rdisk.c obj
	$(CC) -c -O1 $< -o $@

obj/rdisk.s: obj obj/rdisk.o
	$(OBJDUMP) -d obj/rdisk.o > obj/rdisk.s

bin/rdisk.bin: bin obj/rdisk.o
	$(OBJCOPY) -O binary obj/rdisk.o $@

bin/rom.bin: bin bin/sym bin/rdisk.bin obj/rdisk.s
	cp baserom.bin bin/rom.bin
	printf '\x18' | dd of=bin/rom.bin bs=1 seek=335168 count=1 conv=notrunc # resource flags
	printf '\x4F' | dd of=bin/rom.bin bs=1 seek=335216 count=1 conv=notrunc # driver flags
	cat obj/rdisk.s | grep "<.*DiskOpen>\:" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335224 count=2 conv=notrunc
	cat obj/rdisk.s | grep "<.*DiskPrime>\:" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335226 count=2 conv=notrunc
	cat obj/rdisk.s | grep "<.*DiskControl>\:" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335228 count=2 conv=notrunc
	cat obj/rdisk.s | grep "<.*DiskStatus>\:" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335230 count=2 conv=notrunc
	cat obj/rdisk.s | grep "<.*DiskClose>\:" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335232 count=2 conv=notrunc
	cat bin/rdisk.bin | dd of=bin/rom.bin bs=1 seek=335244 conv=notrunc

.PHONY: clean
clean:
	rm -fr bin obj
