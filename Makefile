# path to RETRO68
RETRO68=/Users/zane/Retro68-build/toolchain

PREFIX=$(RETRO68)/m68k-apple-macos
AS=$(RETRO68)/bin/m68k-apple-macos-as
CC=$(RETRO68)/bin/m68k-apple-macos-gcc
LD=$(RETRO68)/bin/m68k-apple-macos-ld
OBJCOPY=$(RETRO68)/bin/m68k-apple-macos-objcopy
OBJDUMP=$(RETRO68)/bin/m68k-apple-macos-objdump

all: bin/rom16M_swap.bin obj/rdisk1M5.s obj/rdisk7M5.s obj/driver1M5.s obj/driver7M5.s obj/entry_rel.sym obj/driver_abs.sym

obj:
	mkdir obj

bin:
	mkdir bin


obj/entry.o: entry.s obj
	$(AS) $< -o $@

obj/entry_rel.sym: obj obj/entry.o
	$(OBJDUMP) -t obj/entry.o > $@


obj/rdisk1M5.o: rdisk.c obj
	$(CC) -DRDiskSize=1572864 -c -Os $< -o $@

obj/rdisk7M5.o: rdisk.c obj
	$(CC) -DRDiskSize=7864320 -c -Os $< -o $@

obj/rdisk1M5.s: obj obj/rdisk1M5.o
	$(OBJDUMP) -d obj/rdisk1M5.o > $@

obj/rdisk7M5.s: obj obj/rdisk7M5.o
	$(OBJDUMP) -d obj/rdisk1M5.o > $@


obj/driver1M5.o: obj obj/entry.o obj/rdisk1M5.o
	$(LD) -Ttext=40851D70 -o $@ obj/entry.o obj/rdisk1M5.o

obj/driver7M5.o: obj obj/entry.o obj/rdisk7M5.o
	$(LD) -Ttext=40851D70 -o $@ obj/entry.o obj/rdisk7M5.o

obj/driver1M5.s: obj obj/driver1M5.o
	$(OBJDUMP) -d obj/driver1M5.o > $@

obj/driver7M5.s: obj obj/driver7M5.o
	$(OBJDUMP) -d obj/driver7M5.o > $@

obj/driver_abs.sym: obj obj/driver1M5.o
	$(OBJDUMP) -t obj/driver1M5.o > $@


bin/driver1M5.bin: bin obj/driver1M5.o
	$(OBJCOPY) -O binary obj/driver1M5.o $@

bin/driver7M5.bin: bin obj/driver7M5.o
	$(OBJCOPY) -O binary obj/driver7M5.o $@


bin/rom2M.bin: baserom.bin RDisk1M5.dsk bin bin/driver1M5.bin obj/driver_abs.sym obj/entry_rel.sym 
	cp baserom.bin $@ # Copy base rom
	# Patch driver
	dd if=bin/driver1M5.bin of=$@ bs=1 seek=335248 skip=32 conv=notrunc # Copy driver code
	printf '\x78' | dd of=$@ bs=1 seek=335168 count=1 conv=notrunc # Set resource flags
	printf '\x4F' | dd of=$@ bs=1 seek=335216 count=1 conv=notrunc # Set driver flags
	cat obj/entry_rel.sym | grep "DOpen" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335224 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DPrime" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335226 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DControl" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335228 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DStatus" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335230 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DClose" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335232 count=2 conv=notrunc
	dd if=RDisk1M5.dsk of=$@ bs=1024 seek=512 count=1536 conv=notrunc # copy disk image

bin/rom8M.bin: baserom.bin RDisk7M5.dsk bin bin/driver7M5.bin obj/driver_abs.sym obj/entry_rel.sym 
	cp baserom.bin $@ # Copy base rom
	# Patch driver
	dd if=bin/driver7M5.bin of=$@ bs=1 seek=335248 skip=32 conv=notrunc # Copy driver code
	printf '\x78' | dd of=$@ bs=1 seek=335168 count=1 conv=notrunc # Set resource flags
	printf '\x4F' | dd of=$@ bs=1 seek=335216 count=1 conv=notrunc # Set driver flags
	cat obj/entry_rel.sym | grep "DOpen" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335224 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DPrime" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335226 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DControl" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335228 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DStatus" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335230 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "DClose" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335232 count=2 conv=notrunc
	dd if=RDisk7M5.dsk of=$@ bs=1024 seek=512 count=7680 conv=notrunc # copy disk image

bin/rom8M_swap.bin: bin/rom8M.bin
	dd if=bin/rom8M.bin of=$@ conv=swab # swap bytes

bin/rom2M_swap.bin: bin/rom2M.bin
	dd if=bin/rom2M.bin of=$@ conv=swab # swap bytes

bin/rom16M_swap.bin: bin/rom2M_swap.bin bin/rom8M_swap.bin
	cat bin/rom8M_swap.bin > $@
	cat bin/rom2M_swap.bin >> $@


.PHONY: clean
clean:
	rm -fr bin obj
