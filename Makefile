# path to RETRO68
RETRO68=/Users/zane/Retro68-build/toolchain

PREFIX=$(RETRO68)/m68k-apple-macos
CC=$(RETRO68)/bin/m68k-apple-macos-gcc
LD=$(RETRO68)/bin/m68k-apple-macos-ld
OBJCOPY=$(RETRO68)/bin/m68k-apple-macos-objcopy
OBJDUMP=$(RETRO68)/bin/m68k-apple-macos-objdump

all: bin/rom.bin obj/rdisk.s obj/rdisk_reloc.s obj/rdisk_rel.sym obj/rdisk_abs.sym bin/rdisk_nonreloc.bin

obj:
	mkdir obj

bin:
	mkdir bin

obj/rdisk.o: rdisk.c obj
	$(CC) -c -O1 $< -o $@

obj/rdisk_reloc.o: obj obj/rdisk.o
	$(LD) -Ttext=40851D70 -o $@ obj/rdisk.o

obj/rdisk.s: obj obj/rdisk.o
	$(OBJDUMP) -d obj/rdisk.o > $@

obj/rdisk_reloc.s: obj obj/rdisk_reloc.o
	$(OBJDUMP) -d obj/rdisk_reloc.o > $@

obj/rdisk_rel.sym: obj obj/rdisk.o
	$(OBJDUMP) -t obj/rdisk.o > $@

obj/rdisk_abs.sym: obj obj/rdisk_reloc.o
	$(OBJDUMP) -t obj/rdisk_reloc.o > $@

bin/rdisk.bin: bin obj/rdisk_reloc.o
	$(OBJCOPY) -O binary obj/rdisk_reloc.o $@

bin/rdisk_nonreloc.bin: bin obj/rdisk.o
	$(OBJCOPY) -O binary obj/rdisk.o $@

bin/rom.bin: bin bin/rdisk.bin obj/rdisk_rel.sym 
	cp baserom_braun_2m_0.9.bin bin/rom.bin
	cat bin/rdisk.bin | dd of=bin/rom.bin bs=1 seek=335266 skip=50 conv=notrunc # Copy driver code
	printf '\x78' | dd of=bin/rom.bin bs=1 seek=335168 count=1 conv=notrunc # Set resource flags
	printf '\x4F' | dd of=bin/rom.bin bs=1 seek=335216 count=1 conv=notrunc # Set driver flags
	# Copy entry points
	cat obj/rdisk_rel.sym | grep "Open" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335224 count=2 conv=notrunc
	cat obj/rdisk_rel.sym | grep "Prime" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335226 count=2 conv=notrunc
	cat obj/rdisk_rel.sym | grep "Control" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335228 count=2 conv=notrunc
	cat obj/rdisk_rel.sym | grep "Status" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335230 count=2 conv=notrunc
	cat obj/rdisk_rel.sym | grep "Close" | cut -c5-8 | xxd -r -p - | dd of=bin/rom.bin bs=1 seek=335232 count=2 conv=notrunc
	# Copy ROM disk	
	dd if=RDisk1M5 of=bin/rom.bin bs=1024 seek=512 count=1536 conv=notrunc

.PHONY: clean
clean:
	rm -fr bin obj
