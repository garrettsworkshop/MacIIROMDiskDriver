#include <Memory.h>
#include <Devices.h>
#include <Files.h>
#include <Disks.h>
#include <Errors.h>
#include <Events.h>
#include <OSUtils.h>

#include "rdisk.h"

// Decode keyboard/PRAM settings
static void RDDecodeSettings(Ptr unmountEN, Ptr mountEN, Ptr ramEN, Ptr dbgEN, Ptr cdrEN) {
	// Sample R and A keys repeatedly
	char r = 0, a = 0;
	long tmax = TickCount() + 60;
	for (long i = 0; i < 1000000; i++) {
		a |= RDiskIsAPressed();
		r |= RDiskIsRPressed() | a;
		if (r) { break; }
		if (TickCount() > tmax) { break; }
	}

	// Read PRAM
	char legacy_startup, legacy_ram;
	RDiskReadXPRAM(1, 4, &legacy_startup);
	RDiskReadXPRAM(1, 5, &legacy_ram);

	// Decode settings: unmount (don't boot), mount (after boot), RAM disk
	if (r) { // R boots from ROM disk
		*unmountEN = 0; // Don't unmount so we boot from this drive
		*mountEN = 0; // No need to mount later since we are boot disk
		*ramEN = a; // A enables RAM disk
		*dbgEN = 0;
		*cdrEN = 0;
	} else {
		if (legacy_startup & 0x01) { // Boot from ROM disk
			*unmountEN = 0; // Don't unmount so we boot from this drive
			*mountEN = 0; // No need to mount later since we are boot disk
			*ramEN = legacy_ram & 0x01; // Allocate RAM disk if bit 0 == 1
			*dbgEN = legacy_startup & 0x04; // MacsBug enabled if bit 2 == 1
			*cdrEN = legacy_startup & 0x08; // CD-ROM enabled if bit 3 == 1
		} else if (!(legacy_startup & 0x02)) { // Mount ROM disk
			*unmountEN = 1; // Unmount to not boot from our disk
			*mountEN = 1; // Mount in accRun
			*ramEN = legacy_ram & 0x01; // Allocate RAM disk if bit 0 == 1
			*dbgEN = 1; // CD-ROM ext. always enabled in mount mode
			*cdrEN = 1; // MacsBug always enabled in mount mode
		} else {
			*unmountEN = 1; // Unmount
			*mountEN = 0; // Don't mount again
			*ramEN = 0; // Don't allocate RAM disk
			*dbgEN = 1; // CD-ROM ext. always enabled in unmount mode
			*cdrEN = 1; // MacsBug always enabled in unmount mode
		}
	}
}

// Switch to 32-bit mode and copy
#pragma parameter C24(__A0, __A1, __D0)
void __attribute__ ((noinline)) C24(Ptr sourcePtr, Ptr destPtr, unsigned long byteCount) {
	signed char mode = true32b;
	SwapMMUMode(&mode);
	BlockMove(sourcePtr, destPtr, byteCount);
	SwapMMUMode(&mode);
}

// Switch to 32-bit mode and get
#pragma parameter __D0 G24(__A2)
char __attribute__ ((noinline)) G24(Ptr pos) {
	long ret;
	signed char mode = true32b;
	SwapMMUMode(&mode);
	ret = *pos; // Peek
	SwapMMUMode(&mode);
	return ret;
}

// Switch to 32-bit mode and set
#pragma parameter S24(__A2, __D3)
void __attribute__ ((noinline)) S24(Ptr pos, char patch) {
	signed char mode = true32b;
	SwapMMUMode(&mode);
	*pos = patch; // Poke
	SwapMMUMode(&mode);
}

// Figure out the first available drive number >= 5
static int RDFindDrvNum() {
	DrvQElPtr dq;
	int drvNum = 5;
	for (dq = (DrvQElPtr)(GetDrvQHdr())->qHead; dq; dq = (DrvQElPtr)dq->qLink) {
		if (dq->dQDrive >= drvNum) { drvNum = dq->dQDrive + 1; }
	}
	return drvNum;
}

#pragma parameter __D0 RDOpen(__A0, __A1)
OSErr RDOpen(IOParamPtr p, DCtlPtr d) {
	int drvNum;
	RDiskStorage_t *c;
	char legacy_startup;

	// Do nothing if already opened
	if (d->dCtlStorage) { return noErr; }

	// Do nothing if inhibited
	RDiskReadXPRAM(1, 4, &legacy_startup);
	if (legacy_startup & 0x80) { return noErr; } 

	// Allocate storage struct
	d->dCtlStorage = NewHandleSysClear(sizeof(RDiskStorage_t));
	if (!d->dCtlStorage) { return openErr; }

	// Lock our storage struct and get master pointer
	HLock(d->dCtlStorage);
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Find first available drive number
	drvNum = RDFindDrvNum();

	// Get debug and CD-ROM disable settings from ROM table
	c->dbgDisByte = RDiskDBGDisByte;
	c->cdrDisByte = RDiskCDRDisByte;
	
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
static void RDInit(IOParamPtr p, DCtlPtr d, RDiskStorage_t *c) {
	char unmountEN, mountEN, ramEN, dbgEN, cdrEN;
	// Mark init done
	c->initialized = 1;
	// Decode settings
	RDDecodeSettings(&unmountEN, &mountEN, &ramEN, &dbgEN, &cdrEN);
	
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
			//FIXME: what if we don't have enough RAM? 
			// Will this wrap around and overwrite low memory?
			// That's not the worst, since the system would just crash,
			// but it would be better to switch to read-only status
			copy24(RDiskBuf, c->ramdisk, RDiskSize);
			// Clearing write protect marks RAM disk enabled
			c->status.writeProt = 0;
		}
	}

	// Patch
	if (RDiskDBGDisPos < RDiskSize) {
		if (c->ramdisk && !dbgEN) {
			poke24(c->ramdisk + RDiskDBGDisPos, c->dbgDisByte);
		} else if (dbgEN) {
			peek24(RDiskBuf + RDiskDBGDisPos, c->dbgDisByte);
		}
	}
	if (RDiskCDRDisPos < RDiskSize) {
		if (c->ramdisk && !cdrEN) {
			poke24(c->ramdisk + RDiskCDRDisPos, c->cdrDisByte);
		} else if (cdrEN) {
			peek24(RDiskBuf + RDiskCDRDisPos, c->cdrDisByte);
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

#pragma parameter __D0 RDPrime(__A0, __A1)
OSErr RDPrime(IOParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	char cmd;
	Ptr disk;

	// Return disk offline error if dCtlStorage null
	if (!d->dCtlStorage) { return notOpenErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Initialize if this is the first prime call
	if (!c->initialized) { RDInit(p, d, c); }

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
		if (!c->ramdisk && RDiskDBGDisPos >= d->dCtlPosition && 
			RDiskDBGDisPos < d->dCtlPosition + p->ioReqCount) {
			p->ioBuffer[RDiskDBGDisPos - d->dCtlPosition] = c->dbgDisByte;
		}
		if (!c->ramdisk && RDiskCDRDisPos >= d->dCtlPosition && 
			RDiskCDRDisPos < d->dCtlPosition + p->ioReqCount) {
			p->ioBuffer[RDiskCDRDisPos - d->dCtlPosition] = c->cdrDisByte;
		}
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

#pragma parameter __D0 RDCtl(__A0, __A1)
OSErr RDCtl(CntrlParamPtr p, DCtlPtr d) {
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
			long long z = 0;
			Ptr pz;
			if (*MMU32bit) { pz = (Ptr)&z; }
			else { pz = StripAddress((Ptr)&z); }
			for (int i = 0; i < 4095; i++) {
				copy24(c->ramdisk + i * sizeof(z), pz, sizeof(z));
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
			if (c->status.writeProt) { *(long*)p->csParam = 0x00000411; }
			else { *(long*)p->csParam = 0x00000410; }
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

#pragma parameter __D0 RDStat(__A0, __A1)
OSErr RDStat(CntrlParamPtr p, DCtlPtr d) {
	//RDiskStorage_t *c;
	// Fail if dCtlStorage null
	if (!d->dCtlStorage) { return notOpenErr; }
	// Dereference dCtlStorage to get pointer to our context
	//c = *(RDiskStorage_t**)d->dCtlStorage;
	// Handle status request based on csCode
	switch (p->csCode) {
		case kDriveStatus:
			BlockMove(*d->dCtlStorage, &p->csParam, sizeof(DrvSts2));
			return noErr;
		default: return statusErr;
	}
}

#pragma parameter __D0 RDClose(__A0, __A1)
OSErr RDClose(IOParamPtr p, DCtlPtr d) {
	// If dCtlStorage not null, dispose of it
	if (!d->dCtlStorage) { return noErr; }
	//RDiskStorage_t *c = *(RDiskStorage_t**)d->dCtlStorage;
	HUnlock(d->dCtlStorage);
	DisposeHandle(d->dCtlStorage);
	d->dCtlStorage = NULL;
	return noErr;
}
