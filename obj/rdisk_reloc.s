
obj/rdisk_reloc.o:     file format elf32-m68k


Disassembly of section .text:

40851d70 <GWROMDisk>:
	...
40851da0:	4e75           	rts
40851da2:	8947           	.short 0x8947
40851da4:	5752           	subqw #3,%a2@
40851da6:	4f4d           	.short 0x4f4d
40851da8:	4469 736b      	negw %a1@(29547)
	...

40851dae <RDiskAddDrive>:
40851dae:	4280           	clrl %d0
40851db0:	302f 0006      	movew %sp@(6),%d0
40851db4:	4840           	swap %d0
40851db6:	302f 0004      	movew %sp@(4),%d0
40851dba:	206f 0008      	moveal %sp@(8),%a0
40851dbe:	a04e           	.short 0xa04e
40851dc0:	4e75           	rts
40851dc2:	8d52           	orw %d6,%a2@
40851dc4:	4469 736b      	negw %a1@(29547)
40851dc8:	4164           	.short 0x4164
40851dca:	6444           	bccs 40851e10 <RDiskOpen+0x2>
40851dcc:	7269           	moveq #105,%d1
40851dce:	7665           	moveq #101,%d3
	...

40851dd2 <RDiskCopy24>:
40851dd2:	598f           	subql #4,%sp
40851dd4:	1f7c 0001 0003 	moveb #1,%sp@(3)
40851dda:	41ef 0003      	lea %sp@(3),%a0
40851dde:	1010           	moveb %a0@,%d0
40851de0:	a05d           	.short 0xa05d
40851de2:	1080           	moveb %d0,%a0@
40851de4:	202f 0010      	movel %sp@(16),%d0
40851de8:	226f 000c      	moveal %sp@(12),%a1
40851dec:	206f 0008      	moveal %sp@(8),%a0
40851df0:	a02e           	.short 0xa02e
40851df2:	41ef 0003      	lea %sp@(3),%a0
40851df6:	1010           	moveb %a0@,%d0
40851df8:	a05d           	.short 0xa05d
40851dfa:	1080           	moveb %d0,%a0@
40851dfc:	588f           	addql #4,%sp
40851dfe:	4e75           	rts
40851e00:	8b52           	orw %d5,%a2@
40851e02:	4469 736b      	negw %a1@(29547)
40851e06:	436f           	.short 0x436f
40851e08:	7079           	moveq #121,%d0
40851e0a:	3234 0000      	movew %a4@(0000000000000000,%d0:w),%d1

40851e0e <RDiskOpen>:
40851e0e:	48e7 1030      	moveml %d3/%a2-%a3,%sp@-
40851e12:	2649           	moveal %a1,%a3
40851e14:	4aa9 0014      	tstl %a1@(20)
40851e18:	6708           	beqs 40851e22 <RDiskOpen+0x14>
40851e1a:	4240           	clrw %d0
40851e1c:	4cdf 0c08      	moveml %sp@+,%d3/%a2-%a3
40851e20:	4e75           	rts
40851e22:	203c 4085 1d70 	movel #1082465648,%d0
40851e28:	a055           	.short 0xa055
40851e2a:	598f           	subql #4,%sp
40851e2c:	2ebc 0000 0308 	movel #776,%sp@
40851e32:	2057           	moveal %sp@,%a0
40851e34:	588f           	addql #4,%sp
40851e36:	2068 0002      	moveal %a0@(2),%a0
40851e3a:	b0fc 0000      	cmpaw #0,%a0
40851e3e:	671a           	beqs 40851e5a <RDiskOpen+0x4c>
40851e40:	7601           	moveq #1,%d3
40851e42:	6008           	bras 40851e4c <RDiskOpen+0x3e>
40851e44:	2050           	moveal %a0@,%a0
40851e46:	b0fc 0000      	cmpaw #0,%a0
40851e4a:	6710           	beqs 40851e5c <RDiskOpen+0x4e>
40851e4c:	3468 0006      	moveaw %a0@(6),%a2
40851e50:	b68a           	cmpl %a2,%d3
40851e52:	6ef0           	bgts 40851e44 <RDiskOpen+0x36>
40851e54:	260a           	movel %a2,%d3
40851e56:	5283           	addql #1,%d3
40851e58:	60ea           	bras 40851e44 <RDiskOpen+0x36>
40851e5a:	7601           	moveq #1,%d3
40851e5c:	702a           	moveq #42,%d0
40851e5e:	a722           	.short 0xa722
40851e60:	2748 0014      	movel %a0,%a3@(20)
40851e64:	6752           	beqs 40851eb8 <RDiskOpen+0xaa>
40851e66:	a029           	.short 0xa029
40851e68:	206b 0014      	moveal %a3@(20),%a0
40851e6c:	2050           	moveal %a0@,%a0
40851e6e:	4228 001e      	clrb %a0@(30)
40851e72:	42a8 0020      	clrl %a0@(32)
40851e76:	42a8 0024      	clrl %a0@(36)
40851e7a:	4228 0028      	clrb %a0@(40)
40851e7e:	91c8           	subal %a0,%a0
40851e80:	117c fff0 0002 	moveb #-16,%a0@(2)
40851e86:	117c 0008 0003 	moveb #8,%a0@(3)
40851e8c:	3143 000c      	movew %d3,%a0@(12)
40851e90:	302b 0018      	movew %a3@(24),%d0
40851e94:	3140 000e      	movew %d0,%a0@(14)
40851e98:	317c 0c00 0012 	movew #3072,%a0@(18)
40851e9e:	4268 0014      	clrw %a0@(20)
40851ea2:	4878 0006      	pea 6 <GWROMDisk-0x40851d6a>
40851ea6:	3f03           	movew %d3,%sp@-
40851ea8:	3f00           	movew %d0,%sp@-
40851eaa:	4eb9 4085 1dae 	jsr 40851dae <RDiskAddDrive>
40851eb0:	508f           	addql #8,%sp
40851eb2:	4240           	clrw %d0
40851eb4:	6000 ff66      	braw 40851e1c <RDiskOpen+0xe>
40851eb8:	70e9           	moveq #-23,%d0
40851eba:	6000 ff60      	braw 40851e1c <RDiskOpen+0xe>
40851ebe:	4e75           	rts
40851ec0:	8952           	orw %d4,%a2@
40851ec2:	4469 736b      	negw %a1@(29547)
40851ec6:	4f70           	.short 0x4f70
40851ec8:	656e           	bcss 40851f38 <RDiskPrime+0x42>
	...

40851ecc <RDiskInit>:
40851ecc:	206f 000c      	moveal %sp@(12),%a0
40851ed0:	117c 0001 001e 	moveb #1,%a0@(30)
40851ed6:	50e8 0002      	st %a0@(2)
40851eda:	42a8 0020      	clrl %a0@(32)
40851ede:	42a8 0024      	clrl %a0@(36)
40851ee2:	4228 0028      	clrb %a0@(40)
40851ee6:	4240           	clrw %d0
40851ee8:	4e75           	rts
40851eea:	8952           	orw %d4,%a2@
40851eec:	4469 736b      	negw %a1@(29547)
40851ef0:	496e           	.short 0x496e
40851ef2:	6974           	bvss 40851f68 <RDiskPrime+0x72>
	...

40851ef6 <RDiskPrime>:
40851ef6:	48e7 1c30      	moveml %d3-%d5/%a2-%a3,%sp@-
40851efa:	2448           	moveal %a0,%a2
40851efc:	2649           	moveal %a1,%a3
40851efe:	2069 0014      	moveal %a1@(20),%a0
40851f02:	b0fc 0000      	cmpaw #0,%a0
40851f06:	6700 00c6      	beqw 40851fce <RDiskPrime+0xd8>
40851f0a:	2050           	moveal %a0@,%a0
40851f0c:	4a28 001e      	tstb %a0@(30)
40851f10:	6738           	beqs 40851f4a <RDiskPrime+0x54>
40851f12:	322a 002c      	movew %a2@(44),%d1
40851f16:	3001           	movew %d1,%d0
40851f18:	0240 000f      	andiw #15,%d0
40851f1c:	0c40 0001      	cmpiw #1,%d0
40851f20:	6746           	beqs 40851f68 <RDiskPrime+0x72>
40851f22:	0c40 0003      	cmpiw #3,%d0
40851f26:	6746           	beqs 40851f6e <RDiskPrime+0x78>
40851f28:	4a40           	tstw %d0
40851f2a:	6736           	beqs 40851f62 <RDiskPrime+0x6c>
40851f2c:	7800           	moveq #0,%d4
40851f2e:	102a 0007      	moveb %a2@(7),%d0
40851f32:	0c00 0002      	cmpib #2,%d0
40851f36:	6740           	beqs 40851f78 <RDiskPrime+0x82>
40851f38:	0c00 0003      	cmpib #3,%d0
40851f3c:	6700 009c      	beqw 40851fda <RDiskPrime+0xe4>
40851f40:	4243           	clrw %d3
40851f42:	3003           	movew %d3,%d0
40851f44:	4cdf 0c38      	moveml %sp@+,%d3-%d5/%a2-%a3
40851f48:	4e75           	rts
40851f4a:	117c 0001 001e 	moveb #1,%a0@(30)
40851f50:	50e8 0002      	st %a0@(2)
40851f54:	42a8 0020      	clrl %a0@(32)
40851f58:	42a8 0024      	clrl %a0@(36)
40851f5c:	4228 0028      	clrb %a0@(40)
40851f60:	60b0           	bras 40851f12 <RDiskPrime+0x1c>
40851f62:	282b 0010      	movel %a3@(16),%d4
40851f66:	60c6           	bras 40851f2e <RDiskPrime+0x38>
40851f68:	282a 002e      	movel %a2@(46),%d4
40851f6c:	60c0           	bras 40851f2e <RDiskPrime+0x38>
40851f6e:	282b 0010      	movel %a3@(16),%d4
40851f72:	d8aa 002e      	addl %a2@(46),%d4
40851f76:	60b6           	bras 40851f2e <RDiskPrime+0x38>
40851f78:	3601           	movew %d1,%d3
40851f7a:	0243 0040      	andiw #64,%d3
40851f7e:	0801 0006      	btst #6,%d1
40851f82:	6650           	bnes 40851fd4 <RDiskPrime+0xde>
40851f84:	2a04           	movel %d4,%d5
40851f86:	0685 4088 0000 	addil #1082654720,%d5
40851f8c:	4a38 0cb2      	tstb cb2 <GWROMDisk-0x408510be>
40851f90:	6720           	beqs 40851fb2 <RDiskPrime+0xbc>
40851f92:	202a 0024      	movel %a2@(36),%d0
40851f96:	226a 0020      	moveal %a2@(32),%a1
40851f9a:	2045           	moveal %d5,%a0
40851f9c:	a02e           	.short 0xa02e
40851f9e:	202a 0024      	movel %a2@(36),%d0
40851fa2:	2540 0028      	movel %d0,%a2@(40)
40851fa6:	d880           	addl %d0,%d4
40851fa8:	2744 0010      	movel %d4,%a3@(16)
40851fac:	2544 002e      	movel %d4,%a2@(46)
40851fb0:	6090           	bras 40851f42 <RDiskPrime+0x4c>
40851fb2:	202a 0020      	movel %a2@(32),%d0
40851fb6:	a055           	.short 0xa055
40851fb8:	a091           	.short 0xa091
40851fba:	2f2a 0024      	movel %a2@(36),%sp@-
40851fbe:	2f00           	movel %d0,%sp@-
40851fc0:	2f05           	movel %d5,%sp@-
40851fc2:	4eb9 4085 1dd2 	jsr 40851dd2 <RDiskCopy24>
40851fc8:	4fef 000c      	lea %sp@(12),%sp
40851fcc:	60d0           	bras 40851f9e <RDiskPrime+0xa8>
40851fce:	76bf           	moveq #-65,%d3
40851fd0:	6000 ff70      	braw 40851f42 <RDiskPrime+0x4c>
40851fd4:	4243           	clrw %d3
40851fd6:	6000 ff6a      	braw 40851f42 <RDiskPrime+0x4c>
40851fda:	76d4           	moveq #-44,%d3
40851fdc:	6000 ff64      	braw 40851f42 <RDiskPrime+0x4c>
40851fe0:	4e75           	rts
40851fe2:	8a52           	orw %a2@,%d5
40851fe4:	4469 736b      	negw %a1@(29547)
40851fe8:	5072 696d 6500 	addqw #8,%a2@(0000000000006500)@(0000000000000000)
	...

40851ff0 <RDiskControl>:
40851ff0:	70ef           	moveq #-17,%d0
40851ff2:	4e75           	rts
40851ff4:	8c52           	orw %a2@,%d6
40851ff6:	4469 736b      	negw %a1@(29547)
40851ffa:	436f           	.short 0x436f
40851ffc:	6e74           	bgts 40852072 <RDiskClose+0x32>
40851ffe:	726f           	moveq #111,%d1
40852000:	6c00 0000      	bgew 40852002 <RDiskControl+0x12>

40852004 <RDiskStatus>:
40852004:	2f0a           	movel %a2,%sp@-
40852006:	2469 0014      	moveal %a1@(20),%a2
4085200a:	b4fc 0000      	cmpaw #0,%a2
4085200e:	6718           	beqs 40852028 <RDiskStatus+0x24>
40852010:	0c68 0008 001a 	cmpiw #8,%a0@(26)
40852016:	6614           	bnes 4085202c <RDiskStatus+0x28>
40852018:	701e           	moveq #30,%d0
4085201a:	43e8 001c      	lea %a0@(28),%a1
4085201e:	2052           	moveal %a2@,%a0
40852020:	a02e           	.short 0xa02e
40852022:	4240           	clrw %d0
40852024:	245f           	moveal %sp@+,%a2
40852026:	4e75           	rts
40852028:	70ee           	moveq #-18,%d0
4085202a:	60f8           	bras 40852024 <RDiskStatus+0x20>
4085202c:	70ee           	moveq #-18,%d0
4085202e:	60f4           	bras 40852024 <RDiskStatus+0x20>
40852030:	4e75           	rts
40852032:	8b52           	orw %d5,%a2@
40852034:	4469 736b      	negw %a1@(29547)
40852038:	5374 6174 7573 	subqw #1,%a4@(0000000075730000)@(0000000000000000)
4085203e:	0000 

40852040 <RDiskClose>:
40852040:	2f0a           	movel %a2,%sp@-
40852042:	2449           	moveal %a1,%a2
40852044:	2069 0014      	moveal %a1@(20),%a0
40852048:	b0fc 0000      	cmpaw #0,%a0
4085204c:	671a           	beqs 40852068 <RDiskClose+0x28>
4085204e:	2050           	moveal %a0@,%a0
40852050:	2068 0024      	moveal %a0@(36),%a0
40852054:	b0fc 0000      	cmpaw #0,%a0
40852058:	6702           	beqs 4085205c <RDiskClose+0x1c>
4085205a:	a01f           	.short 0xa01f
4085205c:	206a 0014      	moveal %a2@(20),%a0
40852060:	a02a           	.short 0xa02a
40852062:	206a 0014      	moveal %a2@(20),%a0
40852066:	a023           	.short 0xa023
40852068:	42aa 0014      	clrl %a2@(20)
4085206c:	4240           	clrw %d0
4085206e:	245f           	moveal %sp@+,%a2
40852070:	4e75           	rts
40852072:	8a52           	orw %a2@,%d5
40852074:	4469 736b      	negw %a1@(29547)
40852078:	436c           	.short 0x436c
4085207a:	6f73           	bles 408520ef <RDiskClose+0xaf>
4085207c:	6500 0000      	bcsw 4085207e <RDiskClose+0x3e>
