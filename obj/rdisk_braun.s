
obj/rdisk_braun.o:     file format elf32-m68k


Disassembly of section .text:

00000000 <BBraunROMDisk>:
	...
  30:	4e75           	rts
  32:	8d42           	.short 0x8d42
  34:	4272 6175 6e52 	clrw %a2@(000000006e524f4d)@(0000000000000000)
  3a:	4f4d 
  3c:	4469 736b      	negw %a1@(29547)
	...

00000042 <RomDrvCopy>:
  42:	598f           	subql #4,%sp
  44:	1f7c 0001 0003 	moveb #1,%sp@(3)
  4a:	41ef 0003      	lea %sp@(3),%a0
  4e:	1010           	moveb %a0@,%d0
  50:	a05d           	.short 0xa05d
  52:	1080           	moveb %d0,%a0@
  54:	202f 0010      	movel %sp@(16),%d0
  58:	226f 000c      	moveal %sp@(12),%a1
  5c:	206f 0008      	moveal %sp@(8),%a0
  60:	a02e           	.short 0xa02e
  62:	41ef 0003      	lea %sp@(3),%a0
  66:	1010           	moveb %a0@,%d0
  68:	a05d           	.short 0xa05d
  6a:	1080           	moveb %d0,%a0@
  6c:	588f           	addql #4,%sp
  6e:	4e75           	rts
  70:	8a52           	orw %a2@,%d5
  72:	6f6d           	bles e1 <RomDrvOpen+0x3d>
  74:	4472 7643      	negw %a2@(0000000000000043,%d7:w:8)
  78:	6f70           	bles ea <RomDrvOpen+0x46>
  7a:	7900           	.short 0x7900
	...

0000007e <RomDrvAddDrive>:
  7e:	4280           	clrl %d0
  80:	302f 0006      	movew %sp@(6),%d0
  84:	4840           	swap %d0
  86:	302f 0004      	movew %sp@(4),%d0
  8a:	206f 0008      	moveal %sp@(8),%a0
  8e:	a04e           	.short 0xa04e
  90:	4e75           	rts
  92:	8e52           	orw %a2@,%d7
  94:	6f6d           	bles 103 <RomDrvOpen+0x5f>
  96:	4472 7641      	negw %a2@(0000000000000041,%d7:w:8)
  9a:	6464           	bccs 100 <RomDrvOpen+0x5c>
  9c:	
000000a4 <RomDrvOpen>:
  a4:	48e7 1030      	moveml %d3/%a2-%a3,%sp@-
  a8:	2649           	moveal %a1,%a3
  aa:	203c 0000 0000 	movel #0,%d0
  b0:	a055           	.short 0xa055
  b2:	598f           	subql #4,%sp
  b4:	2ebc 0000 0308 	movel #776,%sp@
  ba:	2057           	moveal %sp@,%a0
  bc:	588f           	addql #4,%sp
  be:	2068 0002      	moveal %a0@(2),%a0
  c2:	b0fc 0000      	cmpaw #0,%a0
  c6:	671a           	beqs e2 <RomDrvOpen+0x3e>
  c8:	7601           	moveq #1,%d3
  ca:	6008           	bras d4 <RomDrvOpen+0x30>
  cc:	2050           	moveal %a0@,%a0
  ce:	b0fc 0000      	cmpaw #0,%a0
  d2:	6710           	beqs e4 <RomDrvOpen+0x40>
  d4:	3468 0006      	moveaw %a0@(6),%a2
  d8:	b68a           	cmpl %a2,%d3
  da:	6ef0           	bgts cc <RomDrvOpen+0x28>
  dc:	260a           	movel %a2,%d3
  de:	5283           	addql #1,%d3
  e0:	60ea           	bras cc <RomDrvOpen+0x28>
  e2:	7601           	moveq #1,%d3
  e4:	7032           	moveq #50,%d0
  e6:	a722           	.short 0xa722
  e8:	2748 0014      	movel %a0,%a3@(20)
  ec:	a029           	.short 0xa029
  ee:	206b 0014      	moveal %a3@(20),%a0
  f2:	2450           	moveal %a0@,%a2
  f4:	7040           	moveq #64,%d0
  f6:	a51e           	.short 0xa51e
  f8:	2248           	moveal %a0,%a1
  fa:	2548 001e      	movel %a0,%a2@(30)
  fe:	674e           	beqs 14e <RomDrvOpen+0xaa>
 100:	7040           	moveq #64,%d0
 102:	41f9 0000 0000 	lea 0 <BBraunROMDisk>,%a0
 108:	a02e           	.short 0xa02e
 10a:	202a 001e      	movel %a2@(30),%d0
 10e:	a055           	.short 0xa055
 110:	2540 0026      	movel %d0,%a2@(38)
 114:	157c fff0 0002 	moveb #-16,%a2@(2)
 11a:	157c 0008 0003 	moveb #8,%a2@(3)
 120:	3543 000c      	movew %d3,%a2@(12)
 124:	302b 0018      	movew %a3@(24),%d0
 128:	3540 000e      	movew %d0,%a2@(14)
 12c:	357c 0c00 0012 	movew #3072,%a2@(18)
 132:	426a 0014      	clrw %a2@(20)
 136:	486a 0006      	pea %a2@(6)
 13a:	3f03           	movew %d3,%sp@-
 13c:	3f00           	movew %d0,%sp@-
 13e:	4eb9 0000 0000 	jsr 0 <BBraunROMDisk>
 144:	508f           	addql #8,%sp
 146:	4240           	clrw %d0
 148:	4cdf 0c08      	moveml %sp@+,%d3/%a2-%a3
 14c:	4e75           	rts
 14e:	70e9           	moveq #-23,%d0
 150:	60f6           	bras 148 <RomDrvOpen+0xa4>
 152:	4e75           	rts
 154:	8a52           	orw %a2@,%d5
 156:	6f6d           	bles 1c5 <RomDrvPrime+0x63>
 158:	4472 764f      	negw %a2@(000000000000004f,%d7:w:8)
 15c:	7065           	moveq #101,%d0
 15e:	6e00 0000      	bgtw 160 <RomDrvOpen+0xbc>

00000162 <RomDrvPrime>:
 162:	48e7 1c3a      	moveml %d3-%d5/%a2-%a4/%fp,%sp@-
 166:	2448           	moveal %a0,%a2
 168:	2849           	moveal %a1,%a4
 16a:	2069 0014      	moveal %a1@(20),%a0
 16e:	b0fc 0000      	cmpaw #0,%a0
 172:	6700 0158      	beqw 2cc <RomDrvPrime+0x16a>
 176:	2650           	moveal %a0@,%a3
 178:	4a2b 002e      	tstb %a3@(46)
 17c:	6616           	bnes 194 <RomDrvPrime+0x32>
 17e:	177c 0001 002e 	moveb #1,%a3@(46)
 184:	50eb 0002      	st %a3@(2)
 188:	42ab 0022      	clrl %a3@(34)
 18c:	277c 4088 0000 	movel #1082654720,%a3@(42)
 192:	002a 
 194:	322a 002c      	movew %a2@(44),%d1
 198:	3001           	movew %d1,%d0
 19a:	0240 000f      	andiw #15,%d0
 19e:	0c40 0001      	cmpiw #1,%d0
 1a2:	6766           	beqs 20a <RomDrvPrime+0xa8>
 1a4:	0c40 0003      	cmpiw #3,%d0
 1a8:	6766           	beqs 210 <RomDrvPrime+0xae>
 1aa:	4a40           	tstw %d0
 1ac:	6756           	beqs 204 <RomDrvPrime+0xa2>
 1ae:	302a 0006      	movew %a2@(6),%d0
 1b2:	0240 00ff      	andiw #255,%d0
 1b6:	0c40 0002      	cmpiw #2,%d0
 1ba:	6760           	beqs 21c <RomDrvPrime+0xba>
 1bc:	0c40 0003      	cmpiw #3,%d0
 1c0:	6600 0116      	bnew 2d8 <RomDrvPrime+0x176>
 1c4:	4a2b 0002      	tstb %a3@(2)
 1c8:	6600 0114      	bnew 2de <RomDrvPrime+0x17c>
 1cc:	4a2b 0030      	tstb %a3@(48)
 1d0:	6600 00d4      	bnew 2a6 <RomDrvPrime+0x144>
 1d4:	202a 0024      	movel %a2@(36),%d0
 1d8:	226b 002a      	moveal %a3@(42),%a1
 1dc:	d3ce           	addal %fp,%a1
 1de:	206a 0020      	moveal %a2@(32),%a0
 1e2:	a22e           	.short 0xa22e
 1e4:	202a 0024      	movel %a2@(36),%d0
 1e8:	2540 0028      	movel %d0,%a2@(40)
 1ec:	d08e           	addl %fp,%d0
 1ee:	2940 0010      	movel %d0,%a4@(16)
 1f2:	202c 0010      	movel %a4@(16),%d0
 1f6:	2540 002e      	movel %d0,%a2@(46)
 1fa:	4243           	clrw %d3
 1fc:	3003           	movew %d3,%d0
 1fe:	4cdf 5c38      	moveml %sp@+,%d3-%d5/%a2-%a4/%fp
 202:	4e75           	rts
 204:	2c6c 0010      	moveal %a4@(16),%fp
 208:	60a4           	bras 1ae <RomDrvPrime+0x4c>
 20a:	2c6a 002e      	moveal %a2@(46),%fp
 20e:	609e           	bras 1ae <RomDrvPrime+0x4c>
 210:	202c 0010      	movel %a4@(16),%d0
 214:	2c40           	moveal %d0,%fp
 216:	ddea 002e      	addal %a2@(46),%fp
 21a:	6092           	bras 1ae <RomDrvPrime+0x4c>
 21c:	3601           	movew %d1,%d3
 21e:	0243 0040      	andiw #64,%d3
 222:	0801 0006      	btst #6,%d1
 226:	6600 00aa      	bnew 2d2 <RomDrvPrime+0x170>
 22a:	282a 0024      	movel %a2@(36),%d4
 22e:	4a2b 0002      	tstb %a3@(2)
 232:	663c           	bnes 270 <RomDrvPrime+0x10e>
 234:	4aab 0022      	tstl %a3@(34)
 238:	6736           	beqs 270 <RomDrvPrime+0x10e>
 23a:	4a2b 0030      	tstb %a3@(48)
 23e:	6610           	bnes 250 <RomDrvPrime+0xee>
 240:	2004           	movel %d4,%d0
 242:	226a 0020      	moveal %a2@(32),%a1
 246:	206b 002a      	moveal %a3@(42),%a0
 24a:	d1ce           	addal %fp,%a0
 24c:	a22e           	.short 0xa22e
 24e:	603e           	bras 28e <RomDrvPrime+0x12c>
 250:	2a2b 0026      	movel %a3@(38),%d5
 254:	202a 0020      	movel %a2@(32),%d0
 258:	a055           	.short 0xa055
 25a:	2f04           	movel %d4,%sp@-
 25c:	2f00           	movel %d0,%sp@-
 25e:	202b 002a      	movel %a3@(42),%d0
 262:	d08e           	addl %fp,%d0
 264:	2f00           	movel %d0,%sp@-
 266:	2045           	moveal %d5,%a0
 268:	4e90           	jsr %a0@
 26a:	4fef 000c      	lea %sp@(12),%sp
 26e:	601e           	bras 28e <RomDrvPrime+0x12c>
 270:	2a2b 0026      	movel %a3@(38),%d5
 274:	202a 0020      	movel %a2@(32),%d0
 278:	a055           	.short 0xa055
 27a:	2f04           	movel %d4,%sp@-
 27c:	2f00           	movel %d0,%sp@-
 27e:	202b 002a      	movel %a3@(42),%d0
 282:	d08e           	addl %fp,%d0
 284:	2f00           	movel %d0,%sp@-
 286:	2045           	moveal %d5,%a0
 288:	4e90           	jsr %a0@
 28a:	4fef 000c      	lea %sp@(12),%sp
 28e:	2544 0028      	movel %d4,%a2@(40)
 292:	200e           	movel %fp,%d0
 294:	d084           	addl %d4,%d0
 296:	2940 0010      	movel %d0,%a4@(16)
 29a:	202c 0010      	movel %a4@(16),%d0
 29e:	2540 002e      	movel %d0,%a2@(46)
 2a2:	6000 ff58      	braw 1fc <RomDrvPrime+0x9a>
 2a6:	262b 0026      	movel %a3@(38),%d3
 2aa:	282a 0024      	movel %a2@(36),%d4
 2ae:	266b 002a      	moveal %a3@(42),%a3
 2b2:	d7ce           	addal %fp,%a3
 2b4:	202a 0020      	movel %a2@(32),%d0
 2b8:	a055           	.short 0xa055
 2ba:	2f04           	movel %d4,%sp@-
 2bc:	2f0b           	movel %a3,%sp@-
 2be:	2f00           	movel %d0,%sp@-
 2c0:	2043           	moveal %d3,%a0
 2c2:	4e90           	jsr %a0@
 2c4:	4fef 000c      	lea %sp@(12),%sp
 2c8:	6000 ff1a      	braw 1e4 <RomDrvPrime+0x82>
 2cc:	76bf           	moveq #-65,%d3
 2ce:	6000 ff2c      	braw 1fc <RomDrvPrime+0x9a>
 2d2:	4243           	clrw %d3
 2d4:	6000 ff26      	braw 1fc <RomDrvPrime+0x9a>
 2d8:	76d4           	moveq #-44,%d3
 2da:	6000 ff20      	braw 1fc <RomDrvPrime+0x9a>
 2de:	76d4           	moveq #-44,%d3
 2e0:	6000 ff1a      	braw 1fc <RomDrvPrime+0x9a>
 2e4:	4e75           	rts
 2e6:	8b52           	orw %d5,%a2@
 2e8:	6f6d           	bles 357 <RDiskControl+0x19>
 2ea:	4472 7650      	negw %a2@(0000000000000050,%d7:w:8)
 2ee:	7269           	moveq #105,%d1
 2f0:	6d65           	blts 357 <RDiskControl+0x19>
	...

000002f4 <RomDrvClose>:
 2f4:	2f0b           	movel %a3,%sp@-
 2f6:	2f0a           	movel %a2,%sp@-
 2f8:	2449           	moveal %a1,%a2
 2fa:	2069 0014      	moveal %a1@(20),%a0
 2fe:	b0fc 0000      	cmpaw #0,%a0
 302:	6724           	beqs 328 <RomDrvClose+0x34>
 304:	2650           	moveal %a0@,%a3
 306:	206b 0022      	moveal %a3@(34),%a0
 30a:	b0fc 0000      	cmpaw #0,%a0
 30e:	6702           	beqs 312 <RomDrvClose+0x1e>
 310:	a01f           	.short 0xa01f
 312:	206b 001e      	moveal %a3@(30),%a0
 316:	a01f           	.short 0xa01f
 318:	206a 0014      	moveal %a2@(20),%a0
 31c:	a02a           	.short 0xa02a
 31e:	206a 0014      	moveal %a2@(20),%a0
 322:	a023           	.short 0xa023
 324:	42aa 0014      	clrl %a2@(20)
 328:	4240           	clrw %d0
 32a:	245f           	moveal %sp@+,%a2
 32c:	265f           	moveal %sp@+,%a3
 32e:	4e75           	rts
 330:	8b52           	orw %d5,%a2@
 332:	6f6d           	bles 3a1 <RDiskControl+0x63>
 334:	4472 7643      	negw %a2@(0000000000000043,%d7:w:8)
 338:	6c6f           	bges 3a9 <RDiskControl+0x6b>
 33a:	7365           	.short 0x7365
	...

0000033e <RDiskControl>:
 33e:	2f0b           	movel %a3,%sp@-
 340:	2f0a           	movel %a2,%sp@-
 342:	2449           	moveal %a1,%a2
 344:	0c68 0041 001a 	cmpiw #65,%a0@(26)
 34a:	6600 00a0      	bnew 3ec <RDiskControl+0xae>
 34e:	2069 0014      	moveal %a1@(20),%a0
 352:	b0fc 0000      	cmpaw #0,%a0
 356:	6700 0098      	beqw 3f0 <RDiskControl+0xb2>
 35a:	2650           	moveal %a0@,%a3
 35c:	4a2b 002f      	tstb %a3@(47)
 360:	6706           	beqs 368 <RDiskControl+0x2a>
 362:	4aab 0022      	tstl %a3@(34)
 366:	6718           	beqs 380 <RDiskControl+0x42>
 368:	426a 0022      	clrw %a2@(34)
 36c:	302a 0004      	movew %a2@(4),%d0
 370:	0240 dfff      	andiw #-8193,%d0
 374:	3540 0004      	movew %d0,%a2@(4)
 378:	4240           	clrw %d0
 37a:	245f           	moveal %sp@+,%a2
 37c:	265f           	moveal %sp@+,%a3
 37e:	4e75           	rts
 380:	4a38 0cb2      	tstb cb2 <RDiskStatus+0x8ac>
 384:	6730           	beqs 3b6 <RDiskControl+0x78>
 386:	7018           	moveq #24,%d0
 388:	4840           	swap %d0
 38a:	a51e           	.short 0xa51e
 38c:	2008           	movel %a0,%d0
 38e:	2748 0022      	movel %a0,%a3@(34)
 392:	4a80           	tstl %d0
 394:	67d2           	beqs 368 <RDiskControl+0x2a>
 396:	a055           	.short 0xa055
 398:	2740 002a      	movel %d0,%a3@(42)
 39c:	2f3c 0018 0000 	movel #1572864,%sp@-
 3a2:	2f00           	movel %d0,%sp@-
 3a4:	2f3c 4088 0000 	movel #1082654720,%sp@-
 3aa:	206b 0026      	moveal %a3@(38),%a0
 3ae:	4e90           	jsr %a0@
 3b0:	4fef 000c      	lea %sp@(12),%sp
 3b4:	60b2           	bras 368 <RDiskControl+0x2a>
 3b6:	177c 0001 0030 	moveb #1,%a3@(48)
 3bc:	7001           	moveq #1,%d0
 3be:	a51e           	.short 0xa51e
 3c0:	2748 0022      	movel %a0,%a3@(34)
 3c4:	277c 0080 0000 	movel #8388608,%a3@(42)
 3ca:	002a 
 3cc:	2f3c 0018 0000 	movel #1572864,%sp@-
 3d2:	2f3c 0080 0000 	movel #8388608,%sp@-
 3d8:	2f3c 4088 0000 	movel #1082654720,%sp@-
 3de:	206b 0026      	moveal %a3@(38),%a0
 3e2:	4e90           	jsr %a0@
 3e4:	4fef 000c      	lea %sp@(12),%sp
 3e8:	6000 ff7e      	braw 368 <RDiskControl+0x2a>
 3ec:	70ef           	moveq #-17,%d0
 3ee:	608a           	bras 37a <RDiskControl+0x3c>
 3f0:	4240           	clrw %d0
 3f2:	6086           	bras 37a <RDiskControl+0x3c>
 3f4:	4e75           	rts
 3f6:	8c52           	orw %a2@,%d6
 3f8:	4469 736b      	negw %a1@(29547)
 3fc:	436f           	.short 0x436f
 3fe:	6e74           	bgts 474 <RDiskStatus+0x6e>
 400:	726f           	moveq #111,%d1
 402:	6c00 0000      	bgew 404 <RDiskControl+0xc6>

00000406 <RDiskStatus>:
 406:	2f0a           	movel %a2,%sp@-
 408:	2469 0014      	moveal %a1@(20),%a2
 40c:	b4fc 0000      	cmpaw #0,%a2
 410:	6718           	beqs 42a <RDiskStatus+0x24>
 412:	0c68 0008 001a 	cmpiw #8,%a0@(26)
 418:	6614           	bnes 42e <RDiskStatus+0x28>
 41a:	701e           	moveq #30,%d0
 41c:	43e8 001c      	lea %a0@(28),%a1
 420:	2052           	moveal %a2@,%a0
 422:	a02e           	.short 0xa02e
 424:	4240           	clrw %d0
 426:	245f           	moveal %sp@+,%a2
 428:	4e75           	rts
 42a:	70ee           	moveq #-18,%d0
 42c:	60f8           	bras 426 <RDiskStatus+0x20>
 42e:	70ee           	moveq #-18,%d0
 430:	60f4           	bras 426 <RDiskStatus+0x20>
 432:	4e75           	rts
 434:	8b52           	orw %d5,%a2@
 436:	4469 736b      	negw %a1@(29547)
 43a:	5374 6174 7573 	subqw #1,%a4@(0000000075730000)@(0000000000000000)
 440:	0000 
