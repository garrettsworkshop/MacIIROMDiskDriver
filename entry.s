.EQU	killCode,	 1
.EQU	noQueueBit,	 9
.EQU	kioTrap,	 6
.EQU	kioResult,	16
.EQU	kcsCode,	26
.EQU	JIODone,	0x08FC

dc.l	0x00000000, 0x00000000, 0x00000000, 0x00000000
dc.l	0x00000000, 0x00000000, 0x00000000, 0x00000000
.ascii	"\5RDisk\0"
.align 4

DOpen:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDiskOpen
	movem.l		(%SP)+, %A0-%A1
	rts

DClose:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDiskClose
	movem.l		(%SP)+, %A0-%A1
	rts

DPrime:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDiskPrime
	movem.l		(%SP)+, %A0-%A1
	bra.b		IOReturn

DControl:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDiskControl
	movem.l		(%SP)+, %A0-%A1
	cmpi.w		#killCode, kcsCode(%A0)
	bne.b		IOReturn
	rts

DStatus:
	movem.l		%A0-%A1, -(%SP)
	bsr			RDiskStatus
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
