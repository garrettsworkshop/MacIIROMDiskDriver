# path to RETRO68
RETRO68=/Users/zane/Retro68-build/toolchain

PREFIX=$(RETRO68)/m68k-apple-macos
AS=$(RETRO68)/bin/m68k-apple-macos-as
CC=$(RETRO68)/bin/m68k-apple-macos-gcc
LD=$(RETRO68)/bin/m68k-apple-macos-ld
OBJCOPY=$(RETRO68)/bin/m68k-apple-macos-objcopy
OBJDUMP=$(RETRO68)/bin/m68k-apple-macos-objdump

all: bin/rom.bin obj/rdisk.s obj/driver.s obj/entry_rel.sym obj/driver_abs.sym

obj:
	mkdir obj

bin:
	mkdir bin


obj/entry.o: entry.s obj
	$(AS) $< -o $@

obj/entry_rel.sym: obj obj/entry.o
	$(OBJDUMP) -t obj/entry.o > $@


obj/rdisk.o: rdisk.c obj
	$(CC) -c -O1 $< -o $@

obj/rdisk.s: obj obj/rdisk.o
	$(OBJDUMP) -d obj/rdisk.o > $@


obj/driver.o: obj obj/entry.o obj/rdisk.o
	$(LD) -Ttext=40851D70 -o $@ obj/entry.o obj/rdisk.o

obj/driver.s: obj obj/driver.o
	$(OBJDUMP) -d obj/driver.o > $@

obj/driver_abs.sym: obj obj/driver.o
	$(OBJDUMP) -t obj/driver.o > $@


bin/driver.bin: bin obj/driver.o
	$(OBJCOPY) -O binary obj/driver.o $@


bin/rom.bin: baserom.bin RDisk1M5.dsk bin bin/driver.bin obj/entry_rel.sym 
	cp baserom.bin $@ # copy base rom
	dd if=bin/driver.bin of=$@ bs=1 seek=335266 skip=50 conv=notrunc # Copy driver code
	printf '\x78' | dd of=$@ bs=1 seek=335168 count=1 conv=notrunc # Set resource flags
	printf '\x4F' | dd of=$@ bs=1 seek=335216 count=1 conv=notrunc # Set driver flags
	cat obj/entry_rel.sym | grep "DOpen" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335224 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DPrime" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335226 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DControl" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335228 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DStatus" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335230 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DClose" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335232 count=2 conv=notrunc
	dd if=RDisk1M5.dsk of=$@ bs=1024 seek=512 count=1536 conv=notrunc # copy disk image

.PHONY: clean
clean:
	rm -fr bin obj
