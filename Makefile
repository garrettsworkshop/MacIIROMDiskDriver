PREFIX=m68k-apple-macos
AS=$(PREFIX)-as
CC=$(PREFIX)-gcc
LD=$(PREFIX)-ld
OBJCOPY=$(PREFIX)-objcopy
OBJDUMP=$(PREFIX)-objdump

all: bin/IIxIIcxSE30/IIxIIcxSE30_8M.bin bin/IIci/IIci_8M.bin bin/IIfx/IIfx_8M.bin bin/IIsi/IIsi_8M.bin bin/GWSys71_8M.bin bin/GWSys6_8M.bin bin/GWSys7Diagnostics_8M.bin obj/rdisk.s obj/driver.s obj/driver_abs.sym

obj:
	mkdir $@
bin:
	mkdir $@
bin/IIsi: bin
	mkdir $@
bin/IIxIIcxSE30: bin
	mkdir $@
bin/IIci: bin
	mkdir $@
bin/IIfx: bin
	mkdir $@


obj/entry.o: entry.s obj
	$(AS) $< -o $@

obj/entry_rel.sym: obj obj/entry.o
	$(OBJDUMP) -t obj/entry.o > $@


obj/rdisk.o: rdisk.c obj
	$(CC) -Wall -march=68030 -c -Os $< -o $@

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

bin/baserom_romdisk_ramtest.bin: bin roms/baserom.bin bin/driver.bin obj/driver_abs.sym obj/entry_rel.sym 
	cp roms/baserom.bin $@ # Copy base rom
	# Patch driver
	dd if=bin/driver.bin of=$@ bs=1 seek=335248 skip=32 conv=notrunc # Copy driver code
	printf '\x78' | dd of=$@ bs=1 seek=335168 count=1 conv=notrunc # Set resource flags
	printf '\x4F' | dd of=$@ bs=1 seek=335216 count=1 conv=notrunc # Set driver flags
	cat obj/entry_rel.sym | grep "[0-9]\s*DOpen" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335224 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "[0-9]\s*DPrime" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335226 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "[0-9]\s*DControl" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335228 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "[0-9]\s*DStatus" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335230 count=2 conv=notrunc
	cat obj/entry_rel.sym | grep "[0-9]\s*DClose" | cut -c5-8 | xxd -r -p - | dd of=$@ bs=1 seek=335232 count=2 conv=notrunc

bin/baserom_romdisk_noramtest.bin: bin bin/baserom_romdisk_ramtest.bin
	cp bin/baserom_romdisk_ramtest.bin $@ # Copy base rom
	# Disable RAM test
	printf '\x4E\xD6' | dd of=$@ bs=1 seek=288736 count=2 conv=notrunc
	printf '\x4E\xD6' | dd of=$@ bs=1 seek=289016 count=2 conv=notrunc


bin/GWSys71_8M.bin: bin bin/baserom_romdisk_noramtest.bin disks/RDisk7M5.dsk
	# Copy base rom with ROM disk driver
	cp bin/baserom_romdisk_noramtest.bin $@
	# Patch ROM disk driver parameter table
	printf '\x00\x01\x2A\x29' | dd of=$@ bs=1 seek=335260 count=4 conv=notrunc # Patch CDR patch offset
	printf '\x40\x89\x2A\x14' | dd of=$@ bs=1 seek=335268 count=4 conv=notrunc # Patch CDR name address
	printf '\x44' | dd of=$@ bs=1 seek=335273 count=1 conv=notrunc # Patch CDR disable byte
	printf '\x00\x78\x00\x00' | dd of=$@ bs=1 seek=335276 count=4 conv=notrunc # Patch ROM disk size
	# Copy ROM disk image
	dd if=disks/RDisk7M5.dsk of=$@ bs=1024 seek=512 conv=notrunc


bin/GWSys6_4M.bin: bin bin/baserom_romdisk_noramtest.bin disks/RDisk3M5.dsk
	# Copy base rom with ROM disk driver
	cp bin/baserom_romdisk_noramtest.bin $@
	# Patch ROM disk driver parameter table
	printf '\xFF\xFF\xFF\xFF' | dd of=$@ bs=1 seek=335260 count=4 conv=notrunc # Patch CDR patch offset
	printf '\x00\x00\x00\x00' | dd of=$@ bs=1 seek=335268 count=4 conv=notrunc # Patch CDR name address
	printf '\x44' | dd of=$@ bs=1 seek=335273 count=1 conv=notrunc # Patch CDR disable byte
	printf '\x00\x38\x00\x00' | dd of=$@ bs=1 seek=335276 count=4 conv=notrunc # Patch ROM disk size
	# Copy ROM disk image
	dd if=disks/RDisk3M5.dsk of=$@ bs=1024 seek=512 conv=notrunc

bin/GWSys6_8M.bin: bin/GWSys6_4M.bin
	cat bin/GWSys6_4M.bin  > $@
	cat bin/GWSys6_4M.bin >> $@


bin/GWSys7Diagnostics_8M.bin: bin bin/baserom_romdisk_ramtest.bin disks/RDisk7M5-diagnostics.dsk
	# Copy base rom with ROM disk driver
	cp bin/baserom_romdisk_ramtest.bin $@
	# Patch ROM disk driver parameter table
	printf '\xFF\xFF\xFF\xFF' | dd of=$@ bs=1 seek=335260 count=4 conv=notrunc # Patch CDR patch offset
	printf '\x00\x00\x00\x00' | dd of=$@ bs=1 seek=335268 count=4 conv=notrunc # Patch CDR name address
	printf '\x44' | dd of=$@ bs=1 seek=335273 count=1 conv=notrunc # Patch CDR disable byte
	printf '\x00\x78\x00\x00' | dd of=$@ bs=1 seek=335276 count=4 conv=notrunc # Patch ROM disk size
	# Copy ROM disk image
	dd if=disks/RDisk7M5-diagnostics.dsk of=$@ bs=1024 seek=512 conv=notrunc


bin/IIxIIcxSE30/IIxIIcxSE30_512k.bin: bin/IIxIIcxSE30 roms/IIxIIcxSE30.bin
	cat roms/IIxIIcxSE30.bin > $@; cat roms/IIxIIcxSE30.bin >> $@

bin/IIxIIcxSE30/IIxIIcxSE30_1M.bin: bin/IIxIIcxSE30 bin/IIxIIcxSE30/IIxIIcxSE30_512k.bin
	cat bin/IIxIIcxSE30/IIxIIcxSE30_512k.bin > $@; cat bin/IIxIIcxSE30/IIxIIcxSE30_512k.bin >> $@

bin/IIxIIcxSE30/IIxIIcxSE30_2M.bin: bin/IIxIIcxSE30 bin/IIxIIcxSE30/IIxIIcxSE30_1M.bin
	cat bin/IIxIIcxSE30/IIxIIcxSE30_1M.bin > $@; cat bin/IIxIIcxSE30/IIxIIcxSE30_1M.bin >> $@

bin/IIxIIcxSE30/IIxIIcxSE30_4M.bin: bin/IIxIIcxSE30 bin/IIxIIcxSE30/IIxIIcxSE30_2M.bin
	cat bin/IIxIIcxSE30/IIxIIcxSE30_2M.bin > $@; cat bin/IIxIIcxSE30/IIxIIcxSE30_2M.bin >> $@

bin/IIxIIcxSE30/IIxIIcxSE30_8M.bin: bin/IIxIIcxSE30 bin/IIxIIcxSE30/IIxIIcxSE30_4M.bin
	cat bin/IIxIIcxSE30/IIxIIcxSE30_4M.bin > $@; cat bin/IIxIIcxSE30/IIxIIcxSE30_4M.bin >> $@
	

bin/IIci/IIci_1M.bin: bin/IIci roms/IIci.bin
	cat roms/IIci.bin > $@; cat roms/IIci.bin >> $@

bin/IIci/IIci_2M.bin: bin/IIci bin/IIci/IIci_1M.bin
	cat bin/IIci/IIci_1M.bin > $@; cat bin/IIci/IIci_1M.bin >> $@

bin/IIci/IIci_4M.bin: bin/IIci bin/IIci/IIci_2M.bin
	cat bin/IIci/IIci_2M.bin > $@; cat bin/IIci/IIci_2M.bin >> $@

bin/IIci/IIci_8M.bin: bin/IIci bin/IIci/IIci_4M.bin
	cat bin/IIci/IIci_4M.bin > $@; cat bin/IIci/IIci_4M.bin >> $@
	

bin/IIfx/IIfx_1M.bin: bin/IIfx roms/IIfx.bin
	cat roms/IIfx.bin > $@; cat roms/IIfx.bin >> $@

bin/IIfx/IIfx_2M.bin: bin/IIfx bin/IIfx/IIfx_1M.bin
	cat bin/IIfx/IIfx_1M.bin > $@; cat bin/IIfx/IIfx_1M.bin >> $@

bin/IIfx/IIfx_4M.bin: bin/IIfx bin/IIfx/IIfx_2M.bin
	cat bin/IIfx/IIfx_2M.bin > $@; cat bin/IIfx/IIfx_2M.bin >> $@

bin/IIfx/IIfx_8M.bin: bin/IIfx bin/IIfx/IIfx_4M.bin
	cat bin/IIfx/IIfx_4M.bin > $@; cat bin/IIfx/IIfx_4M.bin >> $@
	

bin/IIsi/IIsi_1M.bin: bin/IIsi roms/IIsi.bin
	cat roms/IIsi.bin > $@; cat roms/IIsi.bin >> $@

bin/IIsi/IIsi_2M.bin: bin/IIsi bin/IIsi/IIsi_1M.bin
	cat bin/IIsi/IIsi_1M.bin > $@; cat bin/IIsi/IIsi_1M.bin >> $@

bin/IIsi/IIsi_4M.bin: bin/IIsi bin/IIsi/IIsi_2M.bin
	cat bin/IIsi/IIsi_2M.bin > $@; cat bin/IIsi/IIsi_2M.bin >> $@

bin/IIsi/IIsi_8M.bin: bin/IIsi bin/IIsi/IIsi_4M.bin
	cat bin/IIsi/IIsi_4M.bin > $@; cat bin/IIsi/IIsi_4M.bin >> $@


.PHONY: clean
clean:
	rm -fr bin obj
