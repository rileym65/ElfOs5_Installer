PROJECT=eosinst2
BASE=../../Image/bin
KERNEL=../../Kernel
BIN=\
	../Common/chdir.bin \
	../Common/chmod.bin \
	../Common/dir.bin \
	../Common/lbr.bin \
	../Common/xr.bin \
	../Common/kernel.prg
HEX=\
	../Common/sector0.hex \
	../Common/md.hex \
	../Common/bin.hex \
	../Common/os.hex \
	sector1.hex \
	sector2.hex
OBJS=\
	buildmd.prg \
	buildlat.prg \
	compute.prg \
	copy.prg \
	crlf.prg \
	d_idewrite.prg \
	data.prg \
	decptr.prg \
	dsecplus.prg \
	filldir.prg \
	getdata.prg \
	incau.prg \
	incptr.prg \
	incsec.prg \
	itoa32.prg \
	lmptosec.prg \
	loadr7r8.prg \
	main.prg \
	sectolmp.prg \
	storer7r8.prg \
	tobcd32.prg \
	writeboot.prg \
	writefile.prg \
	zero.prg \
	zerocheck.prg

.SUFFIXES: .asm .prg

$(PROJECT).hex: data.inc equ.inc $(OBJS)
	link02 @link.lnk -s -S eosinst.sym -h -o $(PROJECT).hex

ram: data.inc equ.inc $(OBJS)
	asm02 -L -l -DRAM main.asm
	link02 @link.lnk -s -S eosinst.sym -h -o $(PROJECT)r.hex

main.prg: main.asm data.inc equ.inc
	asm02 -L -l main.asm

data.prg: main.asm data.inc equ.inc
	asm02 -L -l data.asm

.asm.prg:
	asm02 -L -l $<

data.inc: makedata $(BIN) $(HEX)
	./makedata >data.inc

equ.inc: makedata $(BIN) $(HEX)
	./makedata >data.inc

makedata: makedata.c
	$(CC) $(DEFS) $(INCDIR) $(INCS) -c makedata.c
	$(CC) $(DEFS) $(LIBDIR) makedata.o $(LIBS) -o makedata

../Common/chdir.bin: $(BASE)/chdir.bin
	cd ../Common; cp $(BASE)/chdir.bin .

../Common/chmod.bin: $(BASE)/chmod.bin
	cd ../Common; cp $(BASE)/chmod.bin .

../Common/dir.bin: $(BASE)/dir.bin
	cd ../Common; cp $(BASE)/dir.bin .

../Common/lbr.bin: $(BASE)/lbr.bin
	cd ../Common; cp $(BASE)/lbr.bin .

../Common/xr.bin: $(BASE)/xr.bin
	cd ../Common; cp $(BASE)/xr.bin .

../Common/kernel.prg: $(KERNEL)/kernel.prg
	cd ../Common; cp $(KERNEL)/kernel.prg .

clean:
	-rm data.inc
	-rm equ.inc
	-rm *.lst
	-rm *.prg
	-rm $(PROJECT).hex

main.o:      header.h main.c

