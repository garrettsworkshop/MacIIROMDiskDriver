#include <Memory.h>
#include <Devices.h>
#include <Files.h>
#include <Disks.h>
#include <Errors.h>
#include <Events.h>
#include <OSUtils.h>

#include "rdtraps.h"

// This function is here just to put padding at the
// beginning of the output file
void GWROMDisk() {
	StripAddress(&GWROMDisk);
	StripAddress(&GWROMDisk);
	StripAddress(&GWROMDisk);
	StripAddress(&GWROMDisk);
	StripAddress(&GWROMDisk);
	StripAddress(&GWROMDisk);
}

#define RDiskSize (0x00180000L)
#define RDiskBuf ((char*)0x40880000)
#define BufPtr ((Ptr*)0x10C)
#define MemTop ((Ptr*)0x108)
#define MMU32bit ((char*)0x0CB2)

#define Copy24Size (64)
typedef void (*ROMDiskCopy_t)(char *, char *, unsigned long);
void Copy24(char *source, char *dest, unsigned long count) {
	char mode = true32b;
	SwapMMUMode(&mode);
	BlockMove(source, dest, count);
	SwapMMUMode(&mode);
}

typedef struct RDiskStorage_s {
	DrvSts2 drvsts;
	ROMDiskCopy_t copy24;
	char init_done;
	Ptr copy24_alloc;
	char *ramdisk;
	Ptr ramdisk_alloc;
	char ramdisk_valid;
} RDiskStorage_t;

#pragma parameter __D0 RDiskOpen(__A0, __A1)
OSErr RDiskOpen(IOParamPtr p, DCtlPtr d) {
	DrvQElPtr dq;
	int drvnum = 1;
	RDiskStorage_t *c;

	// Do nothing if already opened
	if (d->dCtlStorage) { return noErr; }

	// Reference GWROMDisk() just so it ends up 
	// at the beginning of the output file
	StripAddress(&GWROMDisk);
	
	// Figure out first available drive number
	for (dq = (DrvQElPtr)(GetDrvQHdr())->qHead; dq; dq = (DrvQElPtr)dq->qLink) {
		if (dq->dQDrive >= drvnum) { drvnum = dq->dQDrive + 1; }
	}
	
	// Allocate storage struct
	d->dCtlStorage = NewHandleSysClear(sizeof(RDiskStorage_t));
	if (!d->dCtlStorage) { return openErr; }

	// Allocate space for 24-bit copy routine in system heap and move it there
	c->copy24_alloc = NewPtrSys(Copy24Size);
	if (!c->copy24_alloc) {
		if (d->dCtlStorage) {
			HUnlock(d->dCtlStorage);
			DisposeHandle(d->dCtlStorage);
		}
		return openErr;
	}
	BlockMove(&Copy24, c->copy24_alloc, Copy24Size);
	c->copy24 = (ROMDiskCopy_t)StripAddress(c->copy24_alloc);

	// Lock our storage struct and get master pointer
	HLock(d->dCtlStorage);
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Set drive status
	c->drvsts.writeProt = -1;
	c->drvsts.diskInPlace = 0x08;
	c->drvsts.dQDrive = drvnum;
	c->drvsts.dQRefNum = d->dCtlRefNum;
	c->drvsts.driveSize = (RDiskSize >> 9) & 0xFFFF;
	c->drvsts.driveS1 = ((RDiskSize >> 9) & 0xFFFF0000) >> 16;

	//FIXME: Set driver flags?
	/* d->dCtlFlags |= dReadEnableMask | dWritEnableMask | 
					dCtlEnableMask | dStatEnableMask | 
					dNeedLockMask; */

	// Add drive to drive queue and return
	RDAddDrive(status->dQRefNum, drvNum, (DrvQElPtr)&status->qLink);
	return noErr;
}

static OSErr RDiskInit(IOParamPtr p, DCtlPtr d, RDiskStorage_t *c) {
	char startup, ram;

	// Return if initialized. Otherwise mark init done
	if (c->init_done) { return noErr; }
	else { c->init_done = 1; }

	// Read PRAM
	RDReadXPRAM(1, 4, &startup);
	RDReadXPRAM(1, 5, &ram);

	// Either enable ROM disk or remove ourselves from the drive queue
	if (startup || RDIsRPressed()) { // If ROM disk boot set in PRAM or R pressed,
		// Set ROM disk attributes
		c->drvsts.writeProt = -1; // Set write protected
		// Clear RAM disk structure fields (even though we used NewHandleSysClear)
		c->ramdisk = NULL;
		c->ramdisk_alloc = NULL;
		c-> ramdisk_valid = 0;
		// If RAM disk set in PRAM or A pressed, enable RAM disk
		if (ram || RDISAPressed()) { 
			unsigned long minBufPtr, newBufPtr;
			// Clearing write protect marks RAM disk enabled
			c->drvsts.writeProt = 0;
			// Compute if there is enough high memory
			minBufPtr = ((unsigned long)*MemTop / 2) + 1024;
			newBufPtr = (unsigned long)*BufPtr - RDiskSize;
			// If in 32-bit mode and there is enough high memory, set ramdisk pointer now
			if (*MMU32bit & newBufPtr > minBufPtr && (unsigned long)*BufPtr > newBufPtr) {
				// Allocate RAM disk buffer by lowering BufPtr
				*BufPtr = (Ptr)newBufPtr;
				// Set RAM disk buffer pointer. Defer copying until accRun
				// Don't set ramdisk_alloc because there is nothing to free.
				c->ramdisk = *BufPtr;
			}
			// Enable accRun to allocate and copy later
			d->dCtlFlags |= dNeedTimeMask;
			d->dCtlDelay = 0x10;
		}
		return noErr;
	} else { // Otherwise if R not held down and ROM boot not set in PRAM,
		// Remove our driver from the drive queue
		DrvQElPtr dq;
		QHdrPtr QHead = (QHdrPtr)0x308;
		// Loop through entire drive queue, searching for our device or stopping at the end.
		dq = (DrvQElPtr)QHead->qHead;
		while((dq != (DrvQElPtr)(QHead->qTail)) && (dq->dQRefNum != d->dCtlRefNum)) {
			dq = (DrvQElPtr)(dq->qLink);
		}
		// If we found our driver, remove it from the queue
		if (dq->dQRefNum == d->dCtlRefNum) {
			Dequeue((QElemPtr)dq, QHead);
			if (c->ramdisk_alloc) { DisposePtr(c->ramdisk_alloc); }
			if (c->copy24_alloc) { DisposePtr(c->copy24_alloc); }
			HUnlock(d->dCtlStorage);
			DisposeHandle(d->dCtlStorage);
		}
		d->dCtlStorage = NULL;

		// Return disk offline error
		return offLinErr;
	}
}

#pragma parameter __D0 RDiskPrime(__A0, __A1)
OSErr RDiskPrime(IOParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	char cmd;
	char *disk;
	unsigned long offset;

	// Return disk offline error if dCtlStorage null
	if (!d->dCtlStorage) { return offLinErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Initialize if this is the first prime call
	if (!c->init_done) { 
		OSErr ret = RDiskInit(p, d, c);
		if (ret != noErr) { return ret; } // Return error if init failed
	 }

	// Get pointer to RAM or ROM disk buffer
	disk = c->ramdisk && c->ramdisk_valid ? c->ramdisk : RDiskBuf;

	// Add offset to buffer pointer according to positioning mode
	switch (p->ioPosMode & 0x000F) {
		case fsAtMark: offset = d->dCtlPosition; break;
		case fsFromStart:
			offset = p->ioPosOffset;
			//FIXME: if (offset < 0) { fail }
			break;
		case fsFromMark: offset=  d->dCtlPosition + p->ioPosOffset; break;
		default: offset = 0; break; //FIXME: Error if unsupported ioPosMode?
	}
	// FIXME: if (offset >= RDiskSize) { fail }
	disk += offset;

	// Service read or write request
	cmd = p->ioTrap & 0x00FF;
	if (cmd == aRdCmd) { // Read
		// Return immediately if verify operation requested
		//FIXME: follow either old (verify) or new (read uncached) convention
		if (p->ioPosMode & rdVerifyMask) { return noErr; }
		// Read from disk into buffer.
		if (*MMU32bit) { BlockMove(disk, (char*)p->ioBuffer, p->ioReqCount); }
		else { // 24-bit addressing
			char *buffer = (char*)Translate24To32(StripAddress(p->ioBuffer));
			c->copy24(disk, buffer, p->ioReqCount);
		}
		// Update count
		p->ioActCount = p->ioReqCount;
		p->ioPosOffset = d->dCtlPosition = offset + p->ioReqCount;
		return noErr;
	} else if (cmd == aWrCmd) { // Write
		// Fail if write protected or RAM disk buffer not set up
		if (c->drvsts.writeProt || disk == c->ramdisk) { return wPrErr; }
		// Write from buffer into disk.
		if (*MMU32bit) { BlockMove((char*)p->ioBuffer, disk, p->ioReqCount); }
		else { // 24-bit addressing
			char *buffer = (char*)Translate24To32(StripAddress(p->ioBuffer));
			c->copy24(buffer, disk, p->ioReqCount);
		}
		// Update count and position/offset
		p->ioActCount = p->ioReqCount;
		p->ioPosOffset = d->dCtlPosition = offset + p->ioReqCount;
		return noErr;
	} else { return noErr; }
	//FIXME: Should we fail if cmd isn't read or write?
}

static OSErr RDiskAccRun(IOParamPtr p, DCtlPtr d, RDiskStorage_t *c) {
	// Disable accRun
	d->dCtlDelay = 0;
	d->dCtlFlags &= ~dNeedTimeMask;

	// Set RAM disk buffer if our disk is writable and no RAM buffer set
	if (!c->drvsts.writeProt && !c->ramdisk) {
		if (*MMU32bit) { // If in 32-bit mode, (implies System 7)
			// Allocate RAM disk buffer on system heap (System 7 can resize system heap)
			c->ramdisk_alloc = NewPtrSys(RDiskSize);
			if (c->ramdisk_alloc) { // If allocation successful,
				// Set RAM disk buffer pointer
				c->ramdisk = c->ramdisk_alloc;
			}
		} else { // Otherwise in 24-bit mode,
			// Put buffer just beyond the 8 MB of RAM which is usable in 24-bit mode
			c->ramdisk = (char*)(8 * 1024 * 1024);
			//FIXME: what if we don't have enough RAM? 
			// Will this wrap around and overwrite low memory?
			// That's not the worst, since the system would just crash,
			// but it would be better to switch to read-only status
		}
		// Clear ramdisk_valid just in case, since ROM disk not yet copied to RAM disk
		c->ramdisk_valid = 0;
	}

	if (!c->ramdisk) { // If RAM disk buffer couldn't be allocated,
		// Mark write protected if we couldn't allocate RAM buffer?
		c->drvsts.writeProt = -1;
	} else if (c->ramdisk && !c->ramdisk_valid) { // Else if buffer exists but is not valid,
		// Copy ROM disk to RAM disk buffer if not yet copied
		if (*MMU32bit) { BlockMove(RDiskBuf, c->ramdisk, RDiskSize); }
		else { c->copy24(RDiskBuf, c->ramdisk, RDiskSize); }
		c->ramdisk_valid = 1;
	}

	return noErr; // Always return success
}

#pragma parameter __D0 RDiskControl(__A0, __A1)
OSErr RDiskControl(IOParamPtr p, DCtlPtr d) {
	RDiskStorage_t *c;
	// Do nothing if dCtlStorage null
	if (!d->dCtlStorage) { return noErr; }
	// Dereference dCtlStorage to get pointer to our context
	c = *(RDiskStorage_t**)d->dCtlStorage;

	// Handle control request based on csCode
	switch (((CntrlParamPtr)p)->csCode) {
		case accRun: return RDiskAccRun(p, d, c);
		default: return controlErr;
	}
}

#pragma parameter __D0 RDiskStatus(__A0, __A1)
OSErr RDiskStatus(IOParamPtr p, DCtlPtr d) {
	// Fail if dCtlStorage null or unsupported status call code
	if (!d->dCtlStorage) { return statusErr; } //FIXME: Return offLinErr instead?

	// Handle status request based on csCode
	switch (((CntrlParamPtr)p)->csCode) {
		case drvStsCode:
			BlockMove(*d->dCtlStorage, &((CntrlParamPtr)p)->csParam, sizeof(DrvSts2));
			return noErr;
		default: return statusErr;
	}
	return noErr;
}

#pragma parameter __D0 RDiskClose(__A0, __A1)
OSErr RDiskClose(IOParamPtr p, DCtlPtr d) {
	// If dCtlStorage not null, dispose of it and its contents
	if (d->dCtlStorage) {
		RDiskStorage_t *c = *(RDiskStorage_t**)d->dCtlStorage;
		if (c->ramdisk_alloc) { DisposePtr(c->ramdisk_alloc); }
		if (c->copy24_alloc) { DisposePtr(c->copy24_alloc); }
		HUnlock(d->dCtlStorage);
		DisposeHandle(d->dCtlStorage);
	}
	d->dCtlStorage = NULL;
	return noErr;
}
