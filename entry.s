.EQU	killCode,	 1
.EQU	noQueueBit,	 9
.EQU	kioTrap,	 6
.EQU	kioResult,	16
.EQU	kcsCode,	26
.EQU	JIODone,	0x08FC

dc.l	0x00000000, 0x00000000, 0x00000000, 0x00000000
dc.l	0x00000000, 0x00000000, 0x00000000, 0x00000000

RDiskSig:
.ascii	"\5RDisk\0"
.align 4
RDiskDBGDisPos:
dc.l 0x00000031
RDiskCDRDisPos:
dc.l 0xFFFFFFFF
RDiskDBGNameAddr:
dc.l 0x4088002A
RDiskCDRNameAddr:
dc.l 0x00000000
RDiskDBGDisByte:
dc.b 0x44
RDiskCDRDisByte:
dc.b 0x44
RDiskRAMRequired:
.ascii	"16"

.align 4
RDiskSize:
dc.l 0x00780000

DOpen:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDOpen
	movem.l		(%SP)+, %A0-%A1
	rts

DClose:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDClose
	movem.l		(%SP)+, %A0-%A1
	rts

DPrime:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDPrime
	movem.l		(%SP)+, %A0-%A1
	bra.b		IOReturn

DControl:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDCtl
	movem.l		(%SP)+, %A0-%A1
	cmpi.w		#killCode, kcsCode(%A0)
	bne.b		IOReturn
	rts

DStatus:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDStat
	movem.l		(%SP)+, %A0-%A1

IOReturn:
	move.w		kioTrap(%A0), %D1
	btst		#noQueueBit, %D1
	beq.b		Queued

NotQueued:
	tst.w		%D0
	ble.b		ImmedRTS
	clr.w		%D0

ImmedRTS:
	move.w		%D0, kioResult(%A0)
	rts

Queued:
	move.l		JIODone, -(%SP)
	rts
