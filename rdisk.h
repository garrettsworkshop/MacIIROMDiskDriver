#ifndef RDTRAPS_H
#define RDTRAPS_H

#define RDiskSize (0x00180000L)
#define RDiskBuf ((char*)0x40880000)
#define BufPtr ((Ptr*)0x10C)
#define MemTop ((Ptr*)0x108)
#define MMU32bit ((char*)0xCB2)
#define JIODone ((char*)0x8FC)

#pragma parameter __D0 RDReadXPRAM(__D0, __D1, __A0)
OSErr RDiskReadXPRAM(short numBytes, short whichByte, void *dest) = {0x4840, 0x3001, 0xA051};

// Other definition of RDiskAddDrive with register calling convention
//#pragma parameter __D0 RDiskAddDrive(__D1, __D0, __A0)
//OSErr RDiskAddDrive(short numBytes, short whichByte, void *dest) = {0x4840, 0x3001, 0xA04E};

OSErr RDiskAddDrive(short drvrRefNum, short drvNum, DrvQElPtr dq) {
	__asm__ __volatile__ (
		"clr.l		%%D0		\n\t"
		"move.w		%1,%%D0		\n\t"
		"swap		%%D0		\n\t"
		"move.w		%0,%%D0		\n\t"
		"movea.l	%2,%%A0		\n\t"
		".word  	0xA04E		\n\t"
		: /* outputs */
		: "g"(drvrRefNum), "g"(drvNum), "g"(dq) /* inputs */
		: /* clobbered */);
}

inline char RDiskIsRPressed() { return *((char*)0x175) & 0x80; }
inline char RDiskIsAPressed() { return *((char*)0x174) & 0x01; }

void RDiskBreak() = { 0xA9FF };

typedef void (*RDiskCopy_t)(char *, char *, unsigned long);

#endif
