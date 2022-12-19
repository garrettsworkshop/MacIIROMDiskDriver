#ifndef RDISK_SYSCALL_H
#define RDISK_SYSCALL_H

#include <Disks.h>
#include <OSUtils.h>

#pragma parameter __D0 RDReadXPRAM(__D0, __D1, __A0)
OSErr RDReadXPRAM(short numBytes, short whichByte, Ptr dest) = {0x4840, 0x3001, 0xA051};

#pragma parameter __D0 RDiskAddDrive(__D1, __D0, __A0)
OSErr RDiskAddDrive(short drvrRefNum, short drvNum, DrvQElPtr dq) = {0x4840, 0x3001, 0xA04E};

#endif
