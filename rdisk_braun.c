#include <Memory.h>
#include <Devices.h>
#include <Files.h>
#include <Disks.h>
#include <Errors.h>
#include <Events.h>
#include <OSUtils.h>

#define NEED_DRVSTAT 1
#define NEED_ACCRUN 1

/* If NEED_ACCRUN is set, the dNeedTime (0x60) flag should be set in the header, and the
 * delayticks field in the header should be set to something sensible.
 */

#define kRomDrvSize (0x00180000L)
#define kRomDrvLocation ((char*)0x40880000)
#define BufPtr ((Ptr*)0x10C)
#define MemTop ((Ptr*)0x108)

// This function is here just to put padding at the
// beginning of the output file
void BBraunROMDisk() {
	__asm__ __volatile__
	(
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t"
		".long  0x00000000\n\t":::);
}

typedef void (*RomDrvCopyFunc)(unsigned char *, unsigned char *, unsigned long);

struct RomDrvContext {
	DrvSts2 drvsts;
	Ptr origcopyfunc;
	Ptr origdisk;      /* keep unstripped pointers for Dispose*/
	RomDrvCopyFunc copyfunc;
	unsigned char * disk;
	char initialized;
	char useram;
	char ram24;
	char alreadyalloced;
};
typedef struct RomDrvContext RomDrvContext;

OSErr RomDrvAddDrive(short drvrRefNum, short drvNum, DrvQElPtr dq) {
	__asm__ __volatile__
	(
		"clr.l  %%D0		\n\t"
		"move.w %1,%%D0		\n\t"
		"swap   %%D0		\n\t"
		"move.w %0,%%D0		\n\t"
		"movea.l %2,%%A0	\n\t"
		".word  0xA04E		\n\t"
	: /* outputs */
	: "g"(drvrRefNum), "g"(drvNum), "g"(dq) /* inputs */
	: /* clobbered */);
}

void RomDrvCopy(unsigned char *source, unsigned char *dest, unsigned long count) {
	signed char mode = true32b;
	SwapMMUMode(&mode);
	BlockMove(source, dest, count);
	SwapMMUMode(&mode);
}

#pragma parameter __D0 RomDrvOpen(__A0, __A1)
short RomDrvOpen(IOParamPtr p, DCtlPtr d) {
	DrvSts2 *dsptr;
	DrvQElPtr dq;
	int drvnum = 1;
	RomDrvContext *ctx;

	// Reference BBraunROMDisk() just so it ends up 
	// at the beginning of the output file
	StripAddress(&BBraunROMDisk);
		
	for(dq = (DrvQElPtr)(GetDrvQHdr())->qHead; dq; dq = (DrvQElPtr)dq->qLink) {
		if(dq->dQDrive >= drvnum) drvnum = dq->dQDrive+1;
	}
	
	d->dCtlStorage = NewHandleSysClear(sizeof(RomDrvContext));
	HLock(d->dCtlStorage);
	ctx = *(RomDrvContext**)d->dCtlStorage;
	ctx->origcopyfunc = NewPtrSys(64);
	if(!ctx->origcopyfunc) {
		return openErr;
	}
	BlockMove(&RomDrvCopy, ctx->origcopyfunc, 64);
	ctx->copyfunc = (RomDrvCopyFunc)StripAddress(ctx->origcopyfunc);
	
	dsptr = &ctx->drvsts;
	dsptr->writeProt = 0xF0;
	dsptr->diskInPlace = 8;
	dsptr->dQDrive = drvnum;
	dsptr->dQRefNum = d->dCtlRefNum;
	dsptr->driveSize = (kRomDrvSize/512L) & 0xFFFF;
	dsptr->driveS1 = ((kRomDrvSize/512L) & 0xFFFF0000) >> 16;
	RomDrvAddDrive(dsptr->dQRefNum, drvnum, (DrvQElPtr)&dsptr->qLink);
	
		
	return noErr;	
}

#pragma parameter __D0 RomDrvPrime(__A0, __A1)
short RomDrvPrime(IOParamPtr p, DCtlPtr d) {
	long off;
	RomDrvContext *ctx;
	
	if(!d->dCtlStorage) return offLinErr;
	
	ctx = *(RomDrvContext**)d->dCtlStorage;
	
	if(!ctx->initialized) {
		ctx->initialized = 1;

		ctx->drvsts.writeProt = 0xFF;
		ctx->origdisk = NULL;
		ctx->disk = (unsigned char *)kRomDrvLocation;
		
	}

	switch(p->ioPosMode & 0x000F) {
	case fsAtMark: off = d->dCtlPosition; break;
	case fsFromStart: off = p->ioPosOffset; break;
	case fsFromMark: off = d->dCtlPosition + p->ioPosOffset; break;
	default: break;
	}

	if((p->ioTrap & 0x00ff) == aRdCmd) {
		/* bit 6 indicates this should be a verify operation */
		if(!(p->ioPosMode & 0x40)) {
			unsigned long count = p->ioReqCount;
			if(ctx->drvsts.writeProt == 0 && ctx->origdisk) {
				// If the data is in RAM, we can access it in 24bit mode, and can
				// avoid the overhead of the extra function call and 2 MMU switches.
				if (!ctx->ram24) {
					BlockMoveData(ctx->disk + off, p->ioBuffer, count);
				} else {
					ctx->copyfunc((unsigned char *)(ctx->disk + off), (unsigned char *)StripAddress(p->ioBuffer), count);
				}	
			} else {
				ctx->copyfunc((unsigned char *)(ctx->disk + off), (unsigned char*)StripAddress(p->ioBuffer), count);
			}
			p->ioActCount = count;
			d->dCtlPosition = off + count;
			p->ioPosOffset = d->dCtlPosition;
		}
		return noErr;
	} else if(((p->ioTrap & 0x00ff) == aWrCmd) && (ctx->drvsts.writeProt == 0)) {
		if (!ctx->ram24) {
			BlockMoveData(p->ioBuffer, ctx->disk + off, p->ioReqCount);
		} else {
			ctx->copyfunc((unsigned char *)StripAddress(p->ioBuffer), (unsigned char *)(ctx->disk + off), p->ioReqCount);
		}	
		p->ioActCount = p->ioReqCount;
		d->dCtlPosition = off + p->ioReqCount;
		p->ioPosOffset = d->dCtlPosition;
		return noErr;
	}

	return wPrErr;
}

#pragma parameter __D0 RomDrvClose(__A0, __A1)
short RomDrvClose(IOParamPtr p, DCtlPtr d) {
	RomDrvContext *ctx;
	
	if(!d->dCtlStorage) return noErr;
	ctx = *(RomDrvContext**)d->dCtlStorage;
	if(ctx->origdisk) DisposePtr(ctx->origdisk);
	DisposePtr(ctx->origcopyfunc);
	HUnlock(d->dCtlStorage);
	DisposeHandle(d->dCtlStorage);
	d->dCtlStorage = NULL;
	
	return noErr;
}

#pragma parameter __D0 RDiskControl(__A0, __A1)
OSErr RDiskControl(IOParamPtr p, DCtlPtr d) {
#if NEED_ACCRUN
		if(((CntrlParamPtr)p)->csCode == accRun) {
			RomDrvContext *ctx;
			if(!d->dCtlStorage) return noErr;
			ctx = *(RomDrvContext**)d->dCtlStorage;
			if(ctx->useram  && !ctx->origdisk) {
				if (*((unsigned char *)0x0CB2)) { /* if we're already in 32-bit mode, allocate like this */
					ctx->origdisk = NewPtrSys(kRomDrvSize);
					if(ctx->origdisk) {
						ctx->disk = (unsigned char *)StripAddress((Ptr)ctx->origdisk);
						ctx->copyfunc((unsigned char *)kRomDrvLocation, ctx->disk, kRomDrvSize);
					}
				} else {
					ctx->ram24 = 1;
					ctx->origdisk = NewPtrSys(1); /* just a dummy pointer to make rest of code work */
					ctx->disk = (unsigned char *)(8*1048576);
					ctx->copyfunc((unsigned char *)kRomDrvLocation, ctx->disk, kRomDrvSize);
				}		
			}
			d->dCtlDelay = 0;
			d->dCtlFlags &= ~dNeedTimeMask;
			return noErr;
		}
#endif
		return controlErr;
}

#pragma parameter __D0 RDiskStatus(__A0, __A1)
OSErr RDiskStatus(IOParamPtr p, DCtlPtr d) {
#if NEED_DRVSTAT
		if(!d->dCtlStorage) return statusErr;
		
		if(((CntrlParamPtr)p)->csCode == drvStsCode) {
			BlockMove(*d->dCtlStorage, &((CntrlParamPtr)p)->csParam, sizeof(DrvSts2));
			return noErr;
		}
#endif
		return statusErr;
}
