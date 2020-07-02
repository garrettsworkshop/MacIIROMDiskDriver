#include <Memory.h>
#include <Devices.h>
#include <Files.h>
#include <Disks.h>
#include <Errors.h>
#include <Events.h>
#include <OSUtils.h>

#include "rdisk.h"

const char RDiskIcon[285] = {
	// Icon
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b10000000, 0b00000000, 0b00000000, 0b00000001,
	0b10001111, 0b00011110, 0b00111100, 0b01111001,
	0b10001001, 0b00010010, 0b00100100, 0b01001001,
	0b10001001, 0b00010010, 0b00100100, 0b01001001,
	0b10001001, 0b00010010, 0b00100100, 0b01001001,
	0b10001111, 0b00011110, 0b00111100, 0b01111001,
	0b11000000, 0b00000000, 0b00000000, 0b00000001,
	0b01010101, 0b01010101, 0b11010101, 0b01010101,
	0b01111111, 0b11111111, 0b01111111, 0b11111111,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	// Mask
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b11111111, 0b11111111, 0b11111111, 0b11111111,
	0b01111111, 0b11111111, 0b11111111, 0b11111111,
	0b01111111, 0b11111111, 0b11111111, 0b11111111,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	0b00000000, 0b00000000, 0b00000000, 0b00000000,
	27, 'G', 'a', 'r', 'r', 'e', 't', 't', '\'', 's', ' ', 
	'W', 'o', 'r', 'k', 's', 'h', 'o', 'p', ' ', 
	'R', 'O', 'M', ' ', 'D', 'i', 's', 'k', 0
};

static void RDiskDecodeSettings(RDiskStorage_t *c, char *enable, char* boot, char* mount, char* ram) {
	char rKey, aKey, legacy_startup, legacy_ram;
	// Read PRAM and keys
	RDiskReadXPRAM(1, 4, &legacy_startup);
	RDiskReadXPRAM(1, 5, &legacy_ram);
	rKey = RDiskIsRPressed();
	aKey = RDiskIsAPressed();
	// Decode settings
	if (c->postBoot) {
		*enable = 1;
		*boot = 1; // Boot set so first access works
		*mount = 1;
		*ram = 0;
	} else if (rKey) { // R boots from ROM disk
		*enable = 1;
		*boot = 1;
		*mount = 0;
		*ram = aKey; // A enables RAM disk
	} else if (legacy_startup) {
		*enable = 1;
		*boot = (legacy_startup & 0xFD) && (legacy_startup != 0xFD);
		*mount = !*boot && legacy_startup & 0x02;
		*ram = legacy_ram;
	} else {
		*enable = 0;
		*boot = 0;
		*mount = 0;
		*ram = 0;
	}
}

// Switch to 24-bit mode and copy
void RDiskCopy24(Ptr sourcePtr, Ptr destPtr, unsigned long byteCount) {
	char mode = true32b;
	SwapMMUMode(&mode);
	BlockMove(sourcePtr, destPtr, byteCount);
	SwapMMUMode(&mode);
}

#pragma parameter __D0 RDiskOpen(__A0, __A1)
OSErr RDiskOpen(IOParamPtr p, DCtlPtr d) {
	DrvQElPtr dq;
	int drvNum;
	Ptr copy24;
	RDiskStorage_t *c;

	// Do nothing if already opened
	if (d->dCtlStorage) { return noErr; }

	// Figure out first available drive number
	drvNum = 1;
	for (dq = (DrvQElPtr)(GetDrvQHdr())->qHead; dq; dq = (DrvQElPtr)dq->qLink) {
		if (dq->dQDrive >= drvNum) { drvNum = dq->dQDrive + 1; }
	}
	
	// Allocate storage struct
	d->dCtlStorage = NewHandleSysClear(sizeof(RDiskStorage_t));
	if (!d->dCtlStorage) { return openErr; }
	
	// Allocate copy function buffer and copy RDiskCopy24 to it
	copy24 = NewPtrSys(64);
	if (!copy24) { DisposeHandle(d->dCtlStorage); return openErr; }
	BlockMove(&RDiskCopy24, copy24, 64);

	// Lock our storage struct and get master pointer
	HLock(d->dCtlStorage);
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Initialize storage struct fields
	//c->initialized = 0;
	//c->removed = 0;
	//c->postBoot = 0;
	//c->ramdisk = NULL;
	c->copy24 = (RDiskCopy_t)copy24;

	// Set drive status
	c->status.writeProt = -1;
	c->status.diskInPlace = 8; // 8 means nonejectable disk
	c->status.dQDrive = drvNum;
	c->status.dQRefNum = d->dCtlRefNum;
	c->status.driveSize = RDiskSize / 512;
	c->status.driveS1 = (RDiskSize / 512) >> 16;

	// Set driver flags
	/*d->dCtlFlags |= dReadEnableMask | dWritEnableMask | 
					dCtlEnableMask | dStatEnableMask | 
					dNeedLockMask;*/ // 0x4F

	// Add drive to drive queue and return
	RDiskAddDrive(c->status.dQRefNum, drvNum, (DrvQElPtr)&c->status.qLink);
	return noErr;
}

static OSErr RDiskInit(IOParamPtr p, DCtlPtr d, RDiskStorage_t *c) {
	char rdiskEN, mountEN, bootEN, ramEN;

	// Mark init done
	c->initialized = 1;

	// Decode settings
	RDiskDecodeSettings(c, &rdiskEN, &bootEN, &mountEN, &ramEN);

	// If ROM disk not enabled, remove drive from drive queue
	if (!rdiskEN) {
		QHdrPtr head = GetDrvQHdr();
		DrvQElPtr dq = (DrvQElPtr)head->qHead;
		// Remove our drive from the system drive queue
		// Loop through entire drive queue, searching for our deive
		while ((dq != (DrvQElPtr)(head->qTail)) && 
			   (dq->dQRefNum != d->dCtlRefNum)) {
			dq = (DrvQElPtr)(dq->qLink);
		}
		// If we found our drive, remove it from the queue
		if (dq->dQRefNum == d->dCtlRefNum) {
			Dequeue((QElemPtr)dq, head);
		}
		// Mark drive removed and offline
		c->removed = 1;
		c->status.diskInPlace = 0; // 0 means no disk in drive
		return offLinErr;
	}

	// If RAM disk enabled, try to allocate RAM disk buffer
	if (ramEN) {
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
			c->ramdisk = (char*)(8 * 1024 * 1024);
			// Copy ROM disk image to RAM disk
			((RDiskCopy_t)StripAddress(c->copy24))(
				RDiskBuf, StripAddress(c->ramdisk), RDiskSize);
			// Clearing write protect marks RAM disk enabled
			c->status.writeProt = 0;
			//FIXME: what if we don't have enough RAM? 
			// Will this wrap around and overwrite low memory?
			// That's not the worst, since the system would just crash,
			// but it would be better to switch to read-only status
		}
	}

	// If boot disabled...
	if (!bootEN) {
		// Set drive offline
		c->status.diskInPlace = 0; // 0 means no disk in drive
		// Enable accRun to post disk inserted event if mount enabled
		if (mountEN) {
			d->dCtlDelay = 150;
			d->dCtlFlags |= dNeedTimeMask;
		}
		return offLinErr;
	}

	return noErr;
}

#pragma parameter __D0 RDiskPrime(__A0, __A1)
OSErr RDiskPrime(IOParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	char cmd;
	char *disk;
	long offset;

	// Return disk offline error if dCtlStorage null
	if (!d->dCtlStorage) { return offLinErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;
	// Return disk offline error if virtual disk not inserted
	if (!c->status.diskInPlace) { return offLinErr; }

	// Initialize if this is the first prime call
	if (!c->initialized) { 
		OSErr ret = RDiskInit(p, d, c);
		if (ret != noErr) { return ret; }
	}

	// Get pointer to RAM or ROM disk buffer
	disk = c->ramdisk ? c->ramdisk : RDiskBuf;
	// Add offset to buffer pointer according to positioning mode
	switch (p->ioPosMode & 0x000F) {
		case fsAtMark: offset = d->dCtlPosition; break;
		case fsFromStart: offset = p->ioPosOffset; break;
		case fsFromMark: offset = d->dCtlPosition + p->ioPosOffset; break;
		default: break;
	}
	disk += offset;
	//  Bounds checking disabled
	if (offset >= RDiskSize || p->ioReqCount >= RDiskSize || 
		offset + p->ioReqCount >= RDiskSize) { return posErr; }

	// Service read or write request
	cmd = p->ioTrap & 0x00FF;
	if (cmd == aRdCmd) { // Read
		// Return immediately if verify operation requested
		//FIXME: follow either old (verify) or new (read uncached) convention
		if (p->ioPosMode & rdVerifyMask) {
			return noErr;
		}
		// Read from disk into buffer.
		if (*MMU32bit) { BlockMove(disk, p->ioBuffer, p->ioReqCount); }
		else { 
			((RDiskCopy_t)StripAddress(c->copy24))(
				disk, StripAddress(p->ioBuffer), p->ioReqCount);
		}
		// Update count
		p->ioActCount = p->ioReqCount;
		d->dCtlPosition = offset + p->ioReqCount;
		p->ioPosOffset = d->dCtlPosition;
		return noErr;
	} else if (cmd == aWrCmd) { // Write
		// Fail if write protected or RAM disk buffer not set up
		if (c->status.writeProt || !c->ramdisk) { return wPrErr; }
		// Write from buffer into disk.
		if (*MMU32bit) { BlockMove(p->ioBuffer, disk, p->ioReqCount); }
		else { 
			((RDiskCopy_t)StripAddress(c->copy24))(
				StripAddress(p->ioBuffer), disk, p->ioReqCount);
		}
		// Update count and position/offset
		p->ioActCount = p->ioReqCount;
		d->dCtlPosition = offset + p->ioReqCount;
		p->ioPosOffset = d->dCtlPosition;
		return noErr;
	} else { return noErr; }
	//FIXME: Should we fail if cmd isn't read or write?
}

#pragma parameter __D0 RDiskControl(__A0, __A1)
OSErr RDiskControl(CntrlParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	// Fail if dCtlStorage null
	if (!d->dCtlStorage) { return controlErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;
	// Handle control request based on csCode
	switch (p->csCode) {
		case 6: // Format
			if (!c->status.diskInPlace || c->status.writeProt || !c->ramdisk) { 
				return controlErr;
			} else  {
				char zero[64];
				for (int i = 0; i < sizeof(zero); i++) { zero[i] = 0; }
				for (int i = 0; i < RDiskSize / 64; i++) {
					if (*MMU32bit) { BlockMove(zero, c->ramdisk, sizeof(zero)); }
					else { 
						((RDiskCopy_t)StripAddress(c->copy24))(
							StripAddress(zero), c->ramdisk, sizeof(zero));
					}
				}
			}
			return noErr;
		case 5: // Verify (after format)
			if (!c->status.diskInPlace || c->status.writeProt || !c->ramdisk) { 
				return controlErr;
			} else { return noErr; }
		case accRun:
			// Disable accRun
			d->dCtlFlags &= ~dNeedTimeMask;
			// If drive present in drive queue, set drive online
			if (!c->removed) {
				c->status.diskInPlace = 8; // 8 means nonejectable disk
				PostEvent(diskEvt, c->status.dQDrive);
			}
			return noErr;
		case 21: case 22: // Get icon
			*(Ptr*)&p->csParam = (Ptr)&RDiskIcon;
			return noErr;
		case 128:
			c->postBoot = 1;
			return noErr;
		default: return controlErr;
	}
}

#pragma parameter __D0 RDiskStatus(__A0, __A1)
OSErr RDiskStatus(CntrlParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	// Fail if dCtlStorage null
	if (!d->dCtlStorage) { return statusErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;
	// Handle status request based on csCode
	switch (p->csCode) {
		case drvStsCode:
			BlockMove(*d->dCtlStorage, &p->csParam, sizeof(DrvSts2));
			return noErr;
		case 128: // Get size
			*((long*)p->csParam) = RDiskSize;
			return noErr;
		default: return statusErr;
	}
}

#pragma parameter __D0 RDiskClose(__A0, __A1)
OSErr RDiskClose(IOParamPtr p, DCtlPtr d) {
	// If dCtlStorage not null, dispose of it and its contents
	if (!d->dCtlStorage) { return noErr; }
	RDiskStorage_t *c = *(RDiskStorage_t**)d->dCtlStorage;
	if (c->copy24) { DisposePtr((Ptr)c->copy24); }
	HUnlock(d->dCtlStorage);
	DisposeHandle(d->dCtlStorage);
	d->dCtlStorage = NULL;
	return noErr;
}
