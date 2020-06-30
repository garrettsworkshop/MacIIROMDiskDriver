.EQU	killCode,	 1
.EQU	noQueueBit,	 9
.EQU	kioTrap,	 6
.EQU	kioResult,	16
.EQU	kcsCode,	26
.EQU	JIODone,	0x08FC

dc.l	0x00000000, 0x00000000, 0x00000000, 0x00000000
dc.l	0x00000000, 0x00000000, 0x00000000, 0x00000000
.ascii	"\9GWROMDisk\0"
.align 4

BootCheckEntry:
	* Boot if reference number == -5
	cmp 		#-5, 8(%A2)
	beq.b 		BootCheckRet
	* Otherwise don't boot if reference number != -50
	cmp			#-50, 8(%A2)
	bne.b		BootCheckRet
	* Call to check PRAM
	movem.l		%A0-%A7/%D0-%D7, -(%SP)
	jsr			RDiskBootCheckPRAM
	cmp			#0, %D0
	movem.l		(%SP)+, %A0-%A7/%D0-%D7
BootCheckRet:
	rts
	jmp BootCheckEntry

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
	tst.w		%D0
	ble.b		MyIODone
	clr.w		%D0
	rts

MyIODone:
	move.l		JIODone, -(%SP)
	rts
