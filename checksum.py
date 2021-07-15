import sys
import struct

with open(sys.argv[1], mode='rb') as file:
	file.read(4) # discard first four bytes
	rombin = file.read() # read rest of file
	cksum = 0
	count = 0;
	for i in struct.unpack('>' + str(len(rombin)/2) + 'H', rombin):
		cksum += i
		count += 1
	cksum &= 0xFFFFFFFF
	print(hex(cksum))
