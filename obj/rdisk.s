
obj/rdisk.o:     file format elf32-m68k


Disassembly of section .text:

00000000 <GWROMDisk>:
	...
  30:	4e75           	rts
  32:	8947           	.short 0x8947
  34:	5752           	subqw #3,%a2@
  36:	4f4d           	.short 0x4f4d
  38:	4469 736b      	negw %a1@(29547)
	...

0000003e <RDiskAddDrive>:
  3e:	4280           	clrl %d0
  40:	302f 0006      	movew %sp@(6),%d0
  44:	4840           	swap %d0
  46:	302f 0004      	movew %sp@(4),%d0
  4a:	206f 0008      	moveal %sp@(8),%a0
  4e:	a04e           	.short 0xa04e
  50:	4e75           	rts
  52:	8d52           	orw %d6,%a2@
  54:	4469 736b      	negw %a1@(29547)
  58:	4164           	.short 0x4164
  5a:	6444           	bccs a0 <RDiskOpen+0x2>
  5c:	7269           	moveq #105,%d1
  5e:	7665           	moveq #101,%d3
	...

00000062 <RDiskCopy24>:
  62:	598f           	subql #4,%sp
  64:	1f7c 0001 0003 	moveb #1,%sp@(3)
  6a:	41ef 0003      	lea %sp@(3),%a0
  6e:	1010           	moveb %a0@,%d0
  70:	a05d           	.short 0xa05d
  72:	1080           	moveb %d0,%a0@
  74:	202f 0010      	movel %sp@(16),%d0
  78:	226f 000c      	moveal %sp@(12),%a1
  7c:	206f 0008      	moveal %sp@(8),%a0
  80:	a02e           	.short 0xa02e
  82:	41ef 0003      	lea %sp@(3),%a0
  86:	1010           	moveb %a0@,%d0
  88:	a05d           	.short 0xa05d
  8a:	1080           	moveb %d0,%a0@
  8c:	588f           	addql #4,%sp
  8e:	4e75           	rts
  90:	8b52           	orw %d5,%a2@
  92:	4469 736b      	negw %a1@(29547)
  96:	436f           	.short 0x436f
  98:	7079           	moveq #121,%d0
  9a:	3234 0000      	movew %a4@(0000000000000000,%d0:w),%d1

0000009e <RDiskOpen>:
  9e:	48e7 1030      	moveml %d3/%a2-%a3,%sp@-
  a2:	2649           	moveal %a1,%a3
  a4:	4aa9 0014      	tstl %a1@(20)
  a8:	6708           	beqs b2 <RDiskOpen+0x14>
  aa:	4240           	clrw %d0
  ac:	4cdf 0c08      	moveml %sp@+,%d3/%a2-%a3
  b0:	4e75           	rts
  b2:	203c 0000 0000 	movel #0,%d0
  b8:	a055           	.short 0xa055
  ba:	598f           	subql #4,%sp
  bc:	2ebc 0000 0308 	movel #776,%sp@
  c2:	2057           	moveal %sp@,%a0
  c4:	588f           	addql #4,%sp
  c6:	2068 0002      	moveal %a0@(2),%a0
  ca:	b0fc 0000      	cmpaw #0,%a0
  ce:	671a           	beqs ea <RDiskOpen+0x4c>
  d0:	7601           	moveq #1,%d3
  d2:	6008           	bras dc <RDiskOpen+0x3e>
  d4:	2050           	moveal %a0@,%a0
  d6:	b0fc 0000      	cmpaw #0,%a0
  da:	6710           	beqs ec <RDiskOpen+0x4e>
  dc:	3468 0006      	moveaw %a0@(6),%a2
  e0:	b68a           	cmpl %a2,%d3
  e2:	6ef0           	bgts d4 <RDiskOpen+0x36>
  e4:	260a           	movel %a2,%d3
  e6:	5283           	addql #1,%d3
  e8:	60ea           	bras d4 <RDiskOpen+0x36>
  ea:	7601           	moveq #1,%d3
  ec:	702a           	moveq #42,%d0
  ee:	a722           	.short 0xa722
  f0:	2748 0014      	movel %a0,%a3@(20)
  f4:	6752           	beqs 148 <RDiskOpen+0xaa>
  f6:	a029           	.short 0xa029
  f8:	206b 0014      	moveal %a3@(20),%a0
  fc:	2050           	moveal %a0@,%a0
  fe:	4228 001e      	clrb %a0@(30)
 102:	42a8 0020      	clrl %a0@(32)
 106:	42a8 0024      	clrl %a0@(36)
 10a:	4228 0028      	clrb %a0@(40)
 10e:	91c8           	subal %a0,%a0
 110:	117c fff0 0002 	moveb #-16,%a0@(2)
 116:	117c 0008 0003 	moveb #8,%a0@(3)
 11c:	3143 000c      	movew %d3,%a0@(12)
 120:	302b 0018      	movew %a3@(24),%d0
 124:	3140 000e      	movew %d0,%a0@(14)
 128:	317c 0c00 0012 	movew #3072,%a0@(18)
 12e:	4268 0014      	clrw %a0@(20)
 132:	4878 0006      	pea 6 <GWROMDisk+0x6>
 136:	3f03           	movew %d3,%sp@-
 138:	3f00           	movew %d0,%sp@-
 13a:	4eb9 0000 0000 	jsr 0 <GWROMDisk>
 140:	508f           	addql #8,%sp
 142:	4240           	clrw %d0
 144:	6000 ff66      	braw ac <RDiskOpen+0xe>
 148:	70e9           	moveq #-23,%d0
 14a:	6000 ff60      	braw ac <RDiskOpen+0xe>
 14e:	4e75           	rts
 150:	8952           	orw %d4,%a2@
 152:	4469 736b      	negw %a1@(29547)
 156:	4f70           	.short 0x4f70
 158:	656e           	bcss 1c8 <RDiskPrime+0x42>
	...

0000015c <RDiskInit>:
 15c:	206f 000c      	moveal %sp@(12),%a0
 160:	117c 0001 001e 	moveb #1,%a0@(30)
 166:	50e8 0002      	st %a0@(2)
 16a:	42a8 0020      	clrl %a0@(32)
 16e:	42a8 0024      	clrl %a0@(36)
 172:	4228 0028      	clrb %a0@(40)
 176:	4240           	clrw %d0
 178:	4e75           	rts
 17a:	8952           	orw %d4,%a2@
 17c:	4469 736b      	negw %a1@(29547)
 180:	496e           	.short 0x496e
 182:	6974           	bvss 1f8 <RDiskPrime+0x72>
	...

00000186 <RDiskPrime>:
 186:	48e7 1c30      	moveml %d3-%d5/%a2-%a3,%sp@-
 18a:	2448           	moveal %a0,%a2
 18c:	2649           	moveal %a1,%a3
 18e:	2069 0014      	moveal %a1@(20),%a0
 192:	b0fc 0000      	cmpaw #0,%a0
 196:	6700 00c6      	beqw 25e <RDiskPrime+0xd8>
 19a:	2050           	moveal %a0@,%a0
 19c:	4a28 001e      	tstb %a0@(30)
 1a0:	6738           	beqs 1da <RDiskPrime+0x54>
 1a2:	322a 002c      	movew %a2@(44),%d1
 1a6:	3001           	movew %d1,%d0
 1a8:	0240 000f      	andiw #15,%d0
 1ac:	0c40 0001      	cmpiw #1,%d0
 1b0:	6746           	beqs 1f8 <RDiskPrime+0x72>
 1b2:	0c40 0003      	cmpiw #3,%d0
 1b6:	6746           	beqs 1fe <RDiskPrime+0x78>
 1b8:	4a40           	tstw %d0
 1ba:	6736           	beqs 1f2 <RDiskPrime+0x6c>
 1bc:	7800           	moveq #0,%d4
 1be:	102a 0007      	moveb %a2@(7),%d0
 1c2:	0c00 0002      	cmpib #2,%d0
 1c6:	6740           	beqs 208 <RDiskPrime+0x82>
 1c8:	0c00 0003      	cmpib #3,%d0
 1cc:	6700 009c      	beqw 26a <RDiskPrime+0xe4>
 1d0:	4243           	clrw %d3
 1d2:	3003           	movew %d3,%d0
 1d4:	4cdf 0c38      	moveml %sp@+,%d3-%d5/%a2-%a3
 1d8:	4e75           	rts
 1da:	117c 0001 001e 	moveb #1,%a0@(30)
 1e0:	50e8 0002      	st %a0@(2)
 1e4:	42a8 0020      	clrl %a0@(32)
 1e8:	42a8 0024      	clrl %a0@(36)
 1ec:	4228 0028      	clrb %a0@(40)
 1f0:	60b0           	bras 1a2 <RDiskPrime+0x1c>
 1f2:	282b 0010      	movel %a3@(16),%d4
 1f6:	60c6           	bras 1be <RDiskPrime+0x38>
 1f8:	282a 002e      	movel %a2@(46),%d4
 1fc:	60c0           	bras 1be <RDiskPrime+0x38>
 1fe:	282b 0010      	movel %a3@(16),%d4
 202:	d8aa 002e      	addl %a2@(46),%d4
 206:	60b6           	bras 1be <RDiskPrime+0x38>
 208:	3601           	movew %d1,%d3
 20a:	0243 0040      	andiw #64,%d3
 20e:	0801 0006      	btst #6,%d1
 212:	6650           	bnes 264 <RDiskPrime+0xde>
 214:	2a04           	movel %d4,%d5
 216:	0685 4088 0000 	addil #1082654720,%d5
 21c:	4a38 0cb2      	tstb cb2 <RDiskClose+0x9e2>
 220:	6720           	beqs 242 <RDiskPrime+0xbc>
 222:	202a 0024      	movel %a2@(36),%d0
 226:	226a 0020      	moveal %a2@(32),%a1
 22a:	2045           	moveal %d5,%a0
 22c:	a02e           	.short 0xa02e
 22e:	202a 0024      	movel %a2@(36),%d0
 232:	2540 0028      	movel %d0,%a2@(40)
 236:	d880           	addl %d0,%d4
 238:	2744 0010      	movel %d4,%a3@(16)
 23c:	2544 002e      	movel %d4,%a2@(46)
 240:	6090           	bras 1d2 <RDiskPrime+0x4c>
 242:	202a 0020      	movel %a2@(32),%d0
 246:	a055           	.short 0xa055
 248:	a091           	.short 0xa091
 24a:	2f2a 0024      	movel %a2@(36),%sp@-
 24e:	2f00           	movel %d0,%sp@-
 250:	2f05           	movel %d5,%sp@-
 252:	4eb9 0000 0000 	jsr 0 <GWROMDisk>
 258:	4fef 000c      	lea %sp@(12),%sp
 25c:	60d0           	bras 22e <RDiskPrime+0xa8>
 25e:	76bf           	moveq #-65,%d3
 260:	6000 ff70      	braw 1d2 <RDiskPrime+0x4c>
 264:	4243           	clrw %d3
 266:	6000 ff6a      	braw 1d2 <RDiskPrime+0x4c>
 26a:	76d4           	moveq #-44,%d3
 26c:	6000 ff64      	braw 1d2 <RDiskPrime+0x4c>
 270:	4e75           	rts
 272:	8a52           	orw %a2@,%d5
 274:	4469 736b      	negw %a1@(29547)
 278:	5072 696d 6500 	addqw #8,%a2@(0000000000006500)@(0000000000000000)
	...

00000280 <RDiskControl>:
 280:	70ef           	moveq #-17,%d0
 282:	4e75           	rts
 284:	8c52           	orw %a2@,%d6
 286:	4469 736b      	negw %a1@(29547)
 28a:	436f           	.short 0x436f
 28c:	6e74           	bgts 302 <RDiskClose+0x32>
 28e:	726f           	moveq #111,%d1
 290:	6c00 0000      	bgew 292 <RDiskControl+0x12>

00000294 <RDiskStatus>:
 294:	2f0a           	movel %a2,%sp@-
 296:	2469 0014      	moveal %a1@(20),%a2
 29a:	b4fc 0000      	cmpaw #0,%a2
 29e:	6718           	beqs 2b8 <RDiskStatus+0x24>
 2a0:	0c68 0008 001a 	cmpiw #8,%a0@(26)
 2a6:	6614           	bnes 2bc <RDiskStatus+0x28>
 2a8:	701e           	moveq #30,%d0
 2aa:	43e8 001c      	lea %a0@(28),%a1
 2ae:	2052           	moveal %a2@,%a0
 2b0:	a02e           	.short 0xa02e
 2b2:	4240           	clrw %d0
 2b4:	245f           	moveal %sp@+,%a2
 2b6:	4e75           	rts
 2b8:	70ee           	moveq #-18,%d0
 2ba:	60f8           	bras 2b4 <RDiskStatus+0x20>
 2bc:	70ee           	moveq #-18,%d0
 2be:	60f4           	bras 2b4 <RDiskStatus+0x20>
 2c0:	4e75           	rts
 2c2:	8b52           	orw %d5,%a2@
 2c4:	4469 736b      	negw %a1@(29547)
 2c8:	5374 6174 7573 	subqw #1,%a4@(0000000075730000)@(0000000000000000)
 2ce:	0000 

000002d0 <RDiskClose>:
 2d0:	2f0a           	movel %a2,%sp@-
 2d2:	2449           	moveal %a1,%a2
 2d4:	2069 0014      	moveal %a1@(20),%a0
 2d8:	b0fc 0000      	cmpaw #0,%a0
 2dc:	671a           	beqs 2f8 <RDiskClose+0x28>
 2de:	2050           	moveal %a0@,%a0
 2e0:	2068 0024      	moveal %a0@(36),%a0
 2e4:	b0fc 0000      	cmpaw #0,%a0
 2e8:	6702           	beqs 2ec <RDiskClose+0x1c>
 2ea:	a01f           	.short 0xa01f
 2ec:	206a 0014      	moveal %a2@(20),%a0
 2f0:	a02a           	.short 0xa02a
 2f2:	206a 0014      	moveal %a2@(20),%a0
 2f6:	a023           	.short 0xa023
 2f8:	42aa 0014      	clrl %a2@(20)
 2fc:	4240           	clrw %d0
 2fe:	245f           	moveal %sp@+,%a2
 300:	4e75           	rts
 302:	8a52           	orw %a2@,%d5
 304:	4469 736b      	negw %a1@(29547)
 308:	436c           	.short 0x436c
 30a:	6f73           	bles 37f <RDiskClose+0xaf>
 30c:	6500 0000      	bcsw 30e <RDiskClose+0x3e>
