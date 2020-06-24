
obj/rdisk_braun_reloc.o:     file format elf32-m68k


Disassembly of section .text:

40851d70 <BBraunROMDisk>:
	...
40851da0:	4e75           	rts
40851da2:	8d42           	.short 0x8d42
40851da4:	4272 6175 6e52 	clrw %a2@(000000006e524f4d)@(0000000000000000)
40851daa:	4f4d 
40851dac:	4469 736b      	negw %a1@(29547)
	...

40851db2 <RomDrvCopy>:
40851db2:	598f           	subql #4,%sp
40851db4:	1f7c 0001 0003 	moveb #1,%sp@(3)
40851dba:	41ef 0003      	lea %sp@(3),%a0
40851dbe:	1010           	moveb %a0@,%d0
40851dc0:	a05d           	.short 0xa05d
40851dc2:	1080           	moveb %d0,%a0@
40851dc4:	202f 0010      	movel %sp@(16),%d0
40851dc8:	226f 000c      	moveal %sp@(12),%a1
40851dcc:	206f 0008      	moveal %sp@(8),%a0
40851dd0:	a02e           	.short 0xa02e
40851dd2:	41ef 0003      	lea %sp@(3),%a0
40851dd6:	1010           	moveb %a0@,%d0
40851dd8:	a05d           	.short 0xa05d
40851dda:	1080           	moveb %d0,%a0@
40851ddc:	588f           	addql #4,%sp
40851dde:	4e75           	rts
40851de0:	8a52           	orw %a2@,%d5
40851de2:	6f6d           	bles 40851e51 <RomDrvOpen+0x3d>
40851de4:	4472 7643      	negw %a2@(0000000000000043,%d7:w:8)
40851de8:	6f70           	bles 40851e5a <RomDrvOpen+0x46>
40851dea:	7900           	.short 0x7900
	...

40851dee <RomDrvAddDrive>:
40851dee:	4280           	clrl %d0
40851df0:	302f 0006      	movew %sp@(6),%d0
40851df4:	4840           	swap %d0
40851df6:	302f 0004      	movew %sp@(4),%d0
40851dfa:	206f 0008      	moveal %sp@(8),%a0
40851dfe:	a04e           	.short 0xa04e
40851e00:	4e75           	rts
40851e02:	8e52           	orw %a2@,%d7
40851e04:	6f6d           	bles 40851e73 <RomDrvOpen+0x5f>
40851e06:	4472 7641      	negw %a2@(0000000000000041,%d7:w:8)
40851e0a:	6464           	bccs 40851e70 <RomDrvOpen+0x5c>
40851e0c:	
40851e14 <RomDrvOpen>:
40851e14:	48e7 1030      	moveml %d3/%a2-%a3,%sp@-
40851e18:	2649           	moveal %a1,%a3
40851e1a:	203c 4085 1d70 	movel #1082465648,%d0
40851e20:	a055           	.short 0xa055
40851e22:	598f           	subql #4,%sp
40851e24:	2ebc 0000 0308 	movel #776,%sp@
40851e2a:	2057           	moveal %sp@,%a0
40851e2c:	588f           	addql #4,%sp
40851e2e:	2068 0002      	moveal %a0@(2),%a0
40851e32:	b0fc 0000      	cmpaw #0,%a0
40851e36:	671a           	beqs 40851e52 <RomDrvOpen+0x3e>
40851e38:	7601           	moveq #1,%d3
40851e3a:	6008           	bras 40851e44 <RomDrvOpen+0x30>
40851e3c:	2050           	moveal %a0@,%a0
40851e3e:	b0fc 0000      	cmpaw #0,%a0
40851e42:	6710           	beqs 40851e54 <RomDrvOpen+0x40>
40851e44:	3468 0006      	moveaw %a0@(6),%a2
40851e48:	b68a           	cmpl %a2,%d3
40851e4a:	6ef0           	bgts 40851e3c <RomDrvOpen+0x28>
40851e4c:	260a           	movel %a2,%d3
40851e4e:	5283           	addql #1,%d3
40851e50:	60ea           	bras 40851e3c <RomDrvOpen+0x28>
40851e52:	7601           	moveq #1,%d3
40851e54:	7032           	moveq #50,%d0
40851e56:	a722           	.short 0xa722
40851e58:	2748 0014      	movel %a0,%a3@(20)
40851e5c:	a029           	.short 0xa029
40851e5e:	206b 0014      	moveal %a3@(20),%a0
40851e62:	2450           	moveal %a0@,%a2
40851e64:	7040           	moveq #64,%d0
40851e66:	a51e           	.short 0xa51e
40851e68:	2248           	moveal %a0,%a1
40851e6a:	2548 001e      	movel %a0,%a2@(30)
40851e6e:	674e           	beqs 40851ebe <RomDrvOpen+0xaa>
40851e70:	7040           	moveq #64,%d0
40851e72:	41f9 4085 1db2 	lea 40851db2 <RomDrvCopy>,%a0
40851e78:	a02e           	.short 0xa02e
40851e7a:	202a 001e      	movel %a2@(30),%d0
40851e7e:	a055           	.short 0xa055
40851e80:	2540 0026      	movel %d0,%a2@(38)
40851e84:	157c fff0 0002 	moveb #-16,%a2@(2)
40851e8a:	157c 0008 0003 	moveb #8,%a2@(3)
40851e90:	3543 000c      	movew %d3,%a2@(12)
40851e94:	302b 0018      	movew %a3@(24),%d0
40851e98:	3540 000e      	movew %d0,%a2@(14)
40851e9c:	357c 0c00 0012 	movew #3072,%a2@(18)
40851ea2:	426a 0014      	clrw %a2@(20)
40851ea6:	486a 0006      	pea %a2@(6)
40851eaa:	3f03           	movew %d3,%sp@-
40851eac:	3f00           	movew %d0,%sp@-
40851eae:	4eb9 4085 1dee 	jsr 40851dee <RomDrvAddDrive>
40851eb4:	508f           	addql #8,%sp
40851eb6:	4240           	clrw %d0
40851eb8:	4cdf 0c08      	moveml %sp@+,%d3/%a2-%a3
40851ebc:	4e75           	rts
40851ebe:	70e9           	moveq #-23,%d0
40851ec0:	60f6           	bras 40851eb8 <RomDrvOpen+0xa4>
40851ec2:	4e75           	rts
40851ec4:	8a52           	orw %a2@,%d5
40851ec6:	6f6d           	bles 40851f35 <RomDrvPrime+0x63>
40851ec8:	4472 764f      	negw %a2@(000000000000004f,%d7:w:8)
40851ecc:	7065           	moveq #101,%d0
40851ece:	6e00 0000      	bgtw 40851ed0 <RomDrvOpen+0xbc>

40851ed2 <RomDrvPrime>:
40851ed2:	48e7 1c3a      	moveml %d3-%d5/%a2-%a4/%fp,%sp@-
40851ed6:	2448           	moveal %a0,%a2
40851ed8:	2849           	moveal %a1,%a4
40851eda:	2069 0014      	moveal %a1@(20),%a0
40851ede:	b0fc 0000      	cmpaw #0,%a0
40851ee2:	6700 0158      	beqw 4085203c <RomDrvPrime+0x16a>
40851ee6:	2650           	moveal %a0@,%a3
40851ee8:	4a2b 002e      	tstb %a3@(46)
40851eec:	6616           	bnes 40851f04 <RomDrvPrime+0x32>
40851eee:	177c 0001 002e 	moveb #1,%a3@(46)
40851ef4:	50eb 0002      	st %a3@(2)
40851ef8:	42ab 0022      	clrl %a3@(34)
40851efc:	277c 4088 0000 	movel #1082654720,%a3@(42)
40851f02:	002a 
40851f04:	322a 002c      	movew %a2@(44),%d1
40851f08:	3001           	movew %d1,%d0
40851f0a:	0240 000f      	andiw #15,%d0
40851f0e:	0c40 0001      	cmpiw #1,%d0
40851f12:	6766           	beqs 40851f7a <RomDrvPrime+0xa8>
40851f14:	0c40 0003      	cmpiw #3,%d0
40851f18:	6766           	beqs 40851f80 <RomDrvPrime+0xae>
40851f1a:	4a40           	tstw %d0
40851f1c:	6756           	beqs 40851f74 <RomDrvPrime+0xa2>
40851f1e:	302a 0006      	movew %a2@(6),%d0
40851f22:	0240 00ff      	andiw #255,%d0
40851f26:	0c40 0002      	cmpiw #2,%d0
40851f2a:	6760           	beqs 40851f8c <RomDrvPrime+0xba>
40851f2c:	0c40 0003      	cmpiw #3,%d0
40851f30:	6600 0116      	bnew 40852048 <RomDrvPrime+0x176>
40851f34:	4a2b 0002      	tstb %a3@(2)
40851f38:	6600 0114      	bnew 4085204e <RomDrvPrime+0x17c>
40851f3c:	4a2b 0030      	tstb %a3@(48)
40851f40:	6600 00d4      	bnew 40852016 <RomDrvPrime+0x144>
40851f44:	202a 0024      	movel %a2@(36),%d0
40851f48:	226b 002a      	moveal %a3@(42),%a1
40851f4c:	d3ce           	addal %fp,%a1
40851f4e:	206a 0020      	moveal %a2@(32),%a0
40851f52:	a22e           	.short 0xa22e
40851f54:	202a 0024      	movel %a2@(36),%d0
40851f58:	2540 0028      	movel %d0,%a2@(40)
40851f5c:	d08e           	addl %fp,%d0
40851f5e:	2940 0010      	movel %d0,%a4@(16)
40851f62:	202c 0010      	movel %a4@(16),%d0
40851f66:	2540 002e      	movel %d0,%a2@(46)
40851f6a:	4243           	clrw %d3
40851f6c:	3003           	movew %d3,%d0
40851f6e:	4cdf 5c38      	moveml %sp@+,%d3-%d5/%a2-%a4/%fp
40851f72:	4e75           	rts
40851f74:	2c6c 0010      	moveal %a4@(16),%fp
40851f78:	60a4           	bras 40851f1e <RomDrvPrime+0x4c>
40851f7a:	2c6a 002e      	moveal %a2@(46),%fp
40851f7e:	609e           	bras 40851f1e <RomDrvPrime+0x4c>
40851f80:	202c 0010      	movel %a4@(16),%d0
40851f84:	2c40           	moveal %d0,%fp
40851f86:	ddea 002e      	addal %a2@(46),%fp
40851f8a:	6092           	bras 40851f1e <RomDrvPrime+0x4c>
40851f8c:	3601           	movew %d1,%d3
40851f8e:	0243 0040      	andiw #64,%d3
40851f92:	0801 0006      	btst #6,%d1
40851f96:	6600 00aa      	bnew 40852042 <RomDrvPrime+0x170>
40851f9a:	282a 0024      	movel %a2@(36),%d4
40851f9e:	4a2b 0002      	tstb %a3@(2)
40851fa2:	663c           	bnes 40851fe0 <RomDrvPrime+0x10e>
40851fa4:	4aab 0022      	tstl %a3@(34)
40851fa8:	6736           	beqs 40851fe0 <RomDrvPrime+0x10e>
40851faa:	4a2b 0030      	tstb %a3@(48)
40851fae:	6610           	bnes 40851fc0 <RomDrvPrime+0xee>
40851fb0:	2004           	movel %d4,%d0
40851fb2:	226a 0020      	moveal %a2@(32),%a1
40851fb6:	206b 002a      	moveal %a3@(42),%a0
40851fba:	d1ce           	addal %fp,%a0
40851fbc:	a22e           	.short 0xa22e
40851fbe:	603e           	bras 40851ffe <RomDrvPrime+0x12c>
40851fc0:	2a2b 0026      	movel %a3@(38),%d5
40851fc4:	202a 0020      	movel %a2@(32),%d0
40851fc8:	a055           	.short 0xa055
40851fca:	2f04           	movel %d4,%sp@-
40851fcc:	2f00           	movel %d0,%sp@-
40851fce:	202b 002a      	movel %a3@(42),%d0
40851fd2:	d08e           	addl %fp,%d0
40851fd4:	2f00           	movel %d0,%sp@-
40851fd6:	2045           	moveal %d5,%a0
40851fd8:	4e90           	jsr %a0@
40851fda:	4fef 000c      	lea %sp@(12),%sp
40851fde:	601e           	bras 40851ffe <RomDrvPrime+0x12c>
40851fe0:	2a2b 0026      	movel %a3@(38),%d5
40851fe4:	202a 0020      	movel %a2@(32),%d0
40851fe8:	a055           	.short 0xa055
40851fea:	2f04           	movel %d4,%sp@-
40851fec:	2f00           	movel %d0,%sp@-
40851fee:	202b 002a      	movel %a3@(42),%d0
40851ff2:	d08e           	addl %fp,%d0
40851ff4:	2f00           	movel %d0,%sp@-
40851ff6:	2045           	moveal %d5,%a0
40851ff8:	4e90           	jsr %a0@
40851ffa:	4fef 000c      	lea %sp@(12),%sp
40851ffe:	2544 0028      	movel %d4,%a2@(40)
40852002:	200e           	movel %fp,%d0
40852004:	d084           	addl %d4,%d0
40852006:	2940 0010      	movel %d0,%a4@(16)
4085200a:	202c 0010      	movel %a4@(16),%d0
4085200e:	2540 002e      	movel %d0,%a2@(46)
40852012:	6000 ff58      	braw 40851f6c <RomDrvPrime+0x9a>
40852016:	262b 0026      	movel %a3@(38),%d3
4085201a:	282a 0024      	movel %a2@(36),%d4
4085201e:	266b 002a      	moveal %a3@(42),%a3
40852022:	d7ce           	addal %fp,%a3
40852024:	202a 0020      	movel %a2@(32),%d0
40852028:	a055           	.short 0xa055
4085202a:	2f04           	movel %d4,%sp@-
4085202c:	2f0b           	movel %a3,%sp@-
4085202e:	2f00           	movel %d0,%sp@-
40852030:	2043           	moveal %d3,%a0
40852032:	4e90           	jsr %a0@
40852034:	4fef 000c      	lea %sp@(12),%sp
40852038:	6000 ff1a      	braw 40851f54 <RomDrvPrime+0x82>
4085203c:	76bf           	moveq #-65,%d3
4085203e:	6000 ff2c      	braw 40851f6c <RomDrvPrime+0x9a>
40852042:	4243           	clrw %d3
40852044:	6000 ff26      	braw 40851f6c <RomDrvPrime+0x9a>
40852048:	76d4           	moveq #-44,%d3
4085204a:	6000 ff20      	braw 40851f6c <RomDrvPrime+0x9a>
4085204e:	76d4           	moveq #-44,%d3
40852050:	6000 ff1a      	braw 40851f6c <RomDrvPrime+0x9a>
40852054:	4e75           	rts
40852056:	8b52           	orw %d5,%a2@
40852058:	6f6d           	bles 408520c7 <RDiskControl+0x19>
4085205a:	4472 7650      	negw %a2@(0000000000000050,%d7:w:8)
4085205e:	7269           	moveq #105,%d1
40852060:	6d65           	blts 408520c7 <RDiskControl+0x19>
	...

40852064 <RomDrvClose>:
40852064:	2f0b           	movel %a3,%sp@-
40852066:	2f0a           	movel %a2,%sp@-
40852068:	2449           	moveal %a1,%a2
4085206a:	2069 0014      	moveal %a1@(20),%a0
4085206e:	b0fc 0000      	cmpaw #0,%a0
40852072:	6724           	beqs 40852098 <RomDrvClose+0x34>
40852074:	2650           	moveal %a0@,%a3
40852076:	206b 0022      	moveal %a3@(34),%a0
4085207a:	b0fc 0000      	cmpaw #0,%a0
4085207e:	6702           	beqs 40852082 <RomDrvClose+0x1e>
40852080:	a01f           	.short 0xa01f
40852082:	206b 001e      	moveal %a3@(30),%a0
40852086:	a01f           	.short 0xa01f
40852088:	206a 0014      	moveal %a2@(20),%a0
4085208c:	a02a           	.short 0xa02a
4085208e:	206a 0014      	moveal %a2@(20),%a0
40852092:	a023           	.short 0xa023
40852094:	42aa 0014      	clrl %a2@(20)
40852098:	4240           	clrw %d0
4085209a:	245f           	moveal %sp@+,%a2
4085209c:	265f           	moveal %sp@+,%a3
4085209e:	4e75           	rts
408520a0:	8b52           	orw %d5,%a2@
408520a2:	6f6d           	bles 40852111 <RDiskControl+0x63>
408520a4:	4472 7643      	negw %a2@(0000000000000043,%d7:w:8)
408520a8:	6c6f           	bges 40852119 <RDiskControl+0x6b>
408520aa:	7365           	.short 0x7365
	...

408520ae <RDiskControl>:
408520ae:	2f0b           	movel %a3,%sp@-
408520b0:	2f0a           	movel %a2,%sp@-
408520b2:	2449           	moveal %a1,%a2
408520b4:	0c68 0041 001a 	cmpiw #65,%a0@(26)
408520ba:	6600 00a0      	bnew 4085215c <RDiskControl+0xae>
408520be:	2069 0014      	moveal %a1@(20),%a0
408520c2:	b0fc 0000      	cmpaw #0,%a0
408520c6:	6700 0098      	beqw 40852160 <RDiskControl+0xb2>
408520ca:	2650           	moveal %a0@,%a3
408520cc:	4a2b 002f      	tstb %a3@(47)
408520d0:	6706           	beqs 408520d8 <RDiskControl+0x2a>
408520d2:	4aab 0022      	tstl %a3@(34)
408520d6:	6718           	beqs 408520f0 <RDiskControl+0x42>
408520d8:	426a 0022      	clrw %a2@(34)
408520dc:	302a 0004      	movew %a2@(4),%d0
408520e0:	0240 dfff      	andiw #-8193,%d0
408520e4:	3540 0004      	movew %d0,%a2@(4)
408520e8:	4240           	clrw %d0
408520ea:	245f           	moveal %sp@+,%a2
408520ec:	265f           	moveal %sp@+,%a3
408520ee:	4e75           	rts
408520f0:	4a38 0cb2      	tstb cb2 <BBraunROMDisk-0x408510be>
408520f4:	6730           	beqs 40852126 <RDiskControl+0x78>
408520f6:	7018           	moveq #24,%d0
408520f8:	4840           	swap %d0
408520fa:	a51e           	.short 0xa51e
408520fc:	2008           	movel %a0,%d0
408520fe:	2748 0022      	movel %a0,%a3@(34)
40852102:	4a80           	tstl %d0
40852104:	67d2           	beqs 408520d8 <RDiskControl+0x2a>
40852106:	a055           	.short 0xa055
40852108:	2740 002a      	movel %d0,%a3@(42)
4085210c:	2f3c 0018 0000 	movel #1572864,%sp@-
40852112:	2f00           	movel %d0,%sp@-
40852114:	2f3c 4088 0000 	movel #1082654720,%sp@-
4085211a:	206b 0026      	moveal %a3@(38),%a0
4085211e:	4e90           	jsr %a0@
40852120:	4fef 000c      	lea %sp@(12),%sp
40852124:	60b2           	bras 408520d8 <RDiskControl+0x2a>
40852126:	177c 0001 0030 	moveb #1,%a3@(48)
4085212c:	7001           	moveq #1,%d0
4085212e:	a51e           	.short 0xa51e
40852130:	2748 0022      	movel %a0,%a3@(34)
40852134:	277c 0080 0000 	movel #8388608,%a3@(42)
4085213a:	002a 
4085213c:	2f3c 0018 0000 	movel #1572864,%sp@-
40852142:	2f3c 0080 0000 	movel #8388608,%sp@-
40852148:	2f3c 4088 0000 	movel #1082654720,%sp@-
4085214e:	206b 0026      	moveal %a3@(38),%a0
40852152:	4e90           	jsr %a0@
40852154:	4fef 000c      	lea %sp@(12),%sp
40852158:	6000 ff7e      	braw 408520d8 <RDiskControl+0x2a>
4085215c:	70ef           	moveq #-17,%d0
4085215e:	608a           	bras 408520ea <RDiskControl+0x3c>
40852160:	4240           	clrw %d0
40852162:	6086           	bras 408520ea <RDiskControl+0x3c>
40852164:	4e75           	rts
40852166:	8c52           	orw %a2@,%d6
40852168:	4469 736b      	negw %a1@(29547)
4085216c:	436f           	.short 0x436f
4085216e:	6e74           	bgts 408521e4 <RDiskStatus+0x6e>
40852170:	726f           	moveq #111,%d1
40852172:	6c00 0000      	bgew 40852174 <RDiskControl+0xc6>

40852176 <RDiskStatus>:
40852176:	2f0a           	movel %a2,%sp@-
40852178:	2469 0014      	moveal %a1@(20),%a2
4085217c:	b4fc 0000      	cmpaw #0,%a2
40852180:	6718           	beqs 4085219a <RDiskStatus+0x24>
40852182:	0c68 0008 001a 	cmpiw #8,%a0@(26)
40852188:	6614           	bnes 4085219e <RDiskStatus+0x28>
4085218a:	701e           	moveq #30,%d0
4085218c:	43e8 001c      	lea %a0@(28),%a1
40852190:	2052           	moveal %a2@,%a0
40852192:	a02e           	.short 0xa02e
40852194:	4240           	clrw %d0
40852196:	245f           	moveal %sp@+,%a2
40852198:	4e75           	rts
4085219a:	70ee           	moveq #-18,%d0
4085219c:	60f8           	bras 40852196 <RDiskStatus+0x20>
4085219e:	70ee           	moveq #-18,%d0
408521a0:	60f4           	bras 40852196 <RDiskStatus+0x20>
408521a2:	4e75           	rts
408521a4:	8b52           	orw %d5,%a2@
408521a6:	4469 736b      	negw %a1@(29547)
408521aa:	5374 6174 7573 	subqw #1,%a4@(0000000075730000)@(0000000000000000)
408521b0:	0000 
