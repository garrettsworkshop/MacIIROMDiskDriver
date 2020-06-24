#ifndef RDTRAPS_H
#define RDTRAPS_H

#pragma parameter __D0 RDReadXPRAM(__D0, __D1, __A0)
OSErr RDReadXPRAM(short numBytes, short whichByte, void *dest) = {0x4840, 0x3001, 0xA051};

#pragma parameter __D0 RDAddDrive(__D1, __D0, __A0)
OSErr RDAddDrive(short drvrRefNum, short drvNum, DrvQElPtr dq) = {0x4840, 0x3001, 0xA04E};

inline char RDIsRPressed() { return *((char*)0x175) & 0x80; }
inline char RDISAPressed() { return *((char*)0x174) & 0x01; }

#endif