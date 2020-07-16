#include <Memory.h>
#include <Devices.h>
#include <Files.h>
#include <Disks.h>
#include <Errors.h>
#include <Events.h>
#include <OSUtils.h>

#include "rdisk.h"

// Decode keyboard/PRAM settings
static void RDiskDecodeSettings(RDiskStorage_t *c, Ptr unmount, Ptr mount, Ptr ram) {
	// Decode settings
	if (RDiskIsRPressed()) { // R boots from ROM disk
		*unmount = 0; // Don't unmount so we boot from this drive
		*mount = 0; // No need to mount later since we are boot disk
		*ram = RDiskIsAPressed(); // A enables RAM disk
	} else {
		// Read PRAM
		char legacy_startup, legacy_ram;
		RDiskReadXPRAM(1, 4, &legacy_startup);
		RDiskReadXPRAM(1, 5, &legacy_ram);
		if (legacy_startup & 1) { // Boot from ROM disk
			*unmount = 0; // Don't unmount so we boot from this drive
			*mount = 0; // No need to mount later since we are boot disk
			*ram = legacy_ram & 1;
		} else if (legacy_startup & 2) { // Mount ROM disk
			*unmount = 1; // Unmount to not boot from our disk
			*mount = 1; // Mount in accRun
			*ram = legacy_ram & 1;
		} else {
			*unmount = 1; // Unmount
			*mount = 0; // Don't mount again
			*ram = 0; // Don't allocate RAM disk
		}
	}
}

// Switch to 32-bit mode and copy
#pragma parameter RDiskCopy24(__A0, __A1, __D0)
void RDiskCopy24(Ptr sourcePtr, Ptr destPtr, unsigned long byteCount) {
	char mode = true32b;
	SwapMMUMode(&mode);
	BlockMove(sourcePtr, destPtr, byteCount);
	SwapMMUMode(&mode);
}

// Figure out the first available drive number >= 5
static int RDiskFindDrvNum() {
	DrvQElPtr dq;
	int drvNum = 5;
	for (dq = (DrvQElPtr)(GetDrvQHdr())->qHead; dq; dq = (DrvQElPtr)dq->qLink) {
		if (dq->dQDrive >= drvNum) { drvNum = dq->dQDrive + 1; }
	}
	return drvNum;
}

#pragma parameter __D0 RDiskOpen(__A0, __A1)
OSErr RDiskOpen(IOParamPtr p, DCtlPtr d) {
	int drvNum;
	RDiskStorage_t *c;
	char legacy_startup, legacy_ram;

	// Do nothing if already opened
	if (d->dCtlStorage) { return noErr; }

	// Do nothing if inhibited
	RDiskReadXPRAM(1, 4, &legacy_startup);
	RDiskReadXPRAM(1, 5, &legacy_ram);
	if ((legacy_startup & 0x07) == 0x04) { return noErr; } 

	// Allocate storage struct
	d->dCtlStorage = NewHandleSysClear(sizeof(RDiskStorage_t));
	if (!d->dCtlStorage) { return openErr; }

	// Lock our storage struct and get master pointer
	HLock(d->dCtlStorage);
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Find first available drive number
	drvNum = RDiskFindDrvNum();

	// Set drive status
	//c->status.track = 0;
	c->status.writeProt = -1; // nonzero is write protected
	c->status.diskInPlace = 8; // 8 is nonejectable disk
	c->status.installed = 1; // drive installed
	//c->status.sides = 0;
	//c->status.qType = 1;
	c->status.dQDrive = drvNum;
	//c->status.dQFSID = 0;
	c->status.dQRefNum = d->dCtlRefNum;
	c->status.driveSize = RDiskSize / 512;
	//c->status.driveS1 = (RDiskSize / 512) >> 16;

	// Decompress icon
	#ifdef RDISK_COMPRESS_ICON_ENABLE
	char *src = &RDiskIconCompressed[0];
	char *dst = &c->icon[0];
	UnpackBits(&src, &dst, RDISK_ICON_SIZE);
	#endif

	// Add drive to drive queue and return
	RDiskAddDrive(c->status.dQRefNum, drvNum, (DrvQElPtr)&c->status.qLink);
	return noErr;
}

// Init is called at beginning of first prime (read/write) call
static void RDiskInit(IOParamPtr p, DCtlPtr d, RDiskStorage_t *c) {
	char unmountEN, mountEN, ramEN;
	// Mark init done
	c->initialized = 1;
	// Decode settings
	RDiskDecodeSettings(c, &unmountEN, &mountEN, &ramEN);

	// If RAM disk enabled, try to allocate RAM disk buffer if not already
	if (ramEN & !c->ramdisk) {
		if (*MMU32bit) { // 32-bit mode
			unsigned long minBufPtr, newBufPtr;
			// Compute if there is enough high memory
			minBufPtr = ((unsigned long)*MemTop / 2) + 1024;
			newBufPtr = (unsigned long)*BufPtr - RDiskSize;	
			if (newBufPtr > minBufPtr && (unsigned long)*BufPtr > newBufPtr) {
				// Allocate RAM disk buffer by lowering BufPtr
				*BufPtr = (Ptr)newBufPtr;
				// Set RAM disk buffer pointer.
				c->ramdisk = *BufPtr;
				// Copy ROM disk image to RAM disk
				BlockMove(RDiskBuf, c->ramdisk, RDiskSize);
				// Clearing write protect marks RAM disk enabled
				c->status.writeProt = 0;
			}
		} else { // 24-bit mode
			// Put RAM disk just past 8MB
			c->ramdisk = (Ptr)(8 * 1024 * 1024);
			// Copy ROM disk image to RAM disk
			copy24(RDiskBuf, c->ramdisk, RDiskSize);
			// Clearing write protect marks RAM disk enabled
			c->status.writeProt = 0;
			//FIXME: what if we don't have enough RAM? 
			// Will this wrap around and overwrite low memory?
			// That's not the worst, since the system would just crash,
			// but it would be better to switch to read-only status
		}
	}

	// Unmount if not booting from ROM disk
	if (unmountEN) { c->status.diskInPlace = 0; }

	// If mount enabled, enable accRun to post disk inserted event later
	if (mountEN) { 
		d->dCtlDelay = 150; // Set accRun delay (150 ticks is 2.5 sec.)
		d->dCtlFlags |= dNeedTimeMask; // Enable accRun
	}
}

#pragma parameter __D0 RDiskPrime(__A0, __A1)
OSErr RDiskPrime(IOParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	char cmd;
	Ptr disk;

	// Return disk offline error if dCtlStorage null
	if (!d->dCtlStorage) { return notOpenErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Initialize if this is the first prime call
	if (!c->initialized) { RDiskInit(p, d, c); }

	// Return disk offline error if virtual disk not inserted
	if (!c->status.diskInPlace) { return offLinErr; }

	// Get pointer to RAM or ROM disk buffer
	disk = (c->ramdisk ? c->ramdisk : RDiskBuf) + d->dCtlPosition;
	//  Bounds checking
	if (d->dCtlPosition >= RDiskSize || p->ioReqCount >= RDiskSize || 
		d->dCtlPosition + p->ioReqCount >= RDiskSize) { return paramErr; }

	// Service read or write request
	cmd = p->ioTrap & 0x00FF;
	if (cmd == aRdCmd) { // Read
		// Read from disk into buffer.
		if (*MMU32bit) { BlockMove(disk, p->ioBuffer, p->ioReqCount); }
		else { copy24(disk, StripAddress(p->ioBuffer), p->ioReqCount); }
	} else if (cmd == aWrCmd) { // Write
		// Fail if write protected or RAM disk buffer not set up
		if (c->status.writeProt || !c->ramdisk) { return wPrErr; }
		// Write from buffer into disk.
		if (*MMU32bit) { BlockMove(p->ioBuffer, disk, p->ioReqCount); }
		else { copy24(StripAddress(p->ioBuffer), disk, p->ioReqCount); }
	} else { return noErr; } //FIXME: Fail if cmd isn't read or write?

	// Update count and position/offset, then return
	d->dCtlPosition += p->ioReqCount;
	p->ioActCount = p->ioReqCount;
	return noErr;
}

#pragma parameter __D0 RDiskControl(__A0, __A1)
OSErr RDiskControl(CntrlParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	// Fail if dCtlStorage null
	if (!d->dCtlStorage) { return notOpenErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;
	// Handle control request based on csCode
	switch (p->csCode) {
		case killCode:
			return noErr;
		case kFormat:
			if (!c->status.diskInPlace || c->status.writeProt ||
				!c->ramdisk) { return controlErr; } 
			long zero[32];
			for (int i = 0; i < 32; i++) { zero[i] = 0; }
			for (int i = 0; i < 32; i++) {
				copy24((Ptr)zero, c->ramdisk + i * sizeof(zero), sizeof(zero));
			}
			return noErr;
		case kVerify:
			if (!c->status.diskInPlace) { return controlErr; }
			return noErr;
		case kEject:
			// "Reinsert" disk if ejected illegally
			if (c->status.diskInPlace) { 
				PostEvent(diskEvt, c->status.dQDrive);
			}
			return controlErr; // Eject not allowed so return error
		case accRun:
			d->dCtlFlags &= ~dNeedTimeMask; // Disable accRun
			c->status.diskInPlace = 8; // 8 is nonejectable disk
			PostEvent(diskEvt, c->status.dQDrive); // Post disk inserted event
			return noErr;
		case kDriveIcon: case kMediaIcon: // Get icon
			#ifdef RDISK_COMPRESS_ICON_ENABLE
			*(Ptr*)p->csParam = (Ptr)c->icon;
			#else
			*(Ptr*)p->csParam = (Ptr)RDiskIcon;
			#endif
			return noErr;
		case kDriveInfo:
			//  high word (bytes 2 & 3) clear
			//  byte 1 = primary + fixed media + internal
			//  byte 0 = drive type (0x10 is RAM disk) / (0x11 is ROM disk)
			if (c->status.writeProt) { *(long*)p->csParam = 0x00000410; }
			else { *(long*)p->csParam = 0x00000411; }
			return noErr;
		case 24: // Return SCSI partition size
			*(long*)p->csParam = RDiskSize / 512;
			return noErr;
		case 2351: // Post-boot
			c->initialized = 1; // Skip initialization
			d->dCtlDelay = 30; // Set accRun delay (30 ticks is 0.5 sec.)
			d->dCtlFlags |= dNeedTimeMask; // Enable accRun
			return noErr;
		default: return controlErr;
	}
}

#pragma parameter __D0 RDiskStatus(__A0, __A1)
OSErr RDiskStatus(CntrlParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	// Fail if dCtlStorage null
	if (!d->dCtlStorage) { return notOpenErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;
	// Handle status request based on csCode
	switch (p->csCode) {
		case kDriveStatus:
			BlockMove(*d->dCtlStorage, &p->csParam, sizeof(DrvSts2));
			return noErr;
		default: return statusErr;
	}
}

#pragma parameter __D0 RDiskClose(__A0, __A1)
OSErr RDiskClose(IOParamPtr p, DCtlPtr d) {
	// If dCtlStorage not null, dispose of it
	if (!d->dCtlStorage) { return noErr; }
	RDiskStorage_t *c = *(RDiskStorage_t**)d->dCtlStorage;
	HUnlock(d->dCtlStorage);
	DisposeHandle(d->dCtlStorage);
	d->dCtlStorage = NULL;
	return noErr;
}
