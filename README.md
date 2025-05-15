# zcimtools

A container based upon Debian bookworm that contains a bunch of tools,
emulators, images, et al. for 8080/8085/Z80 systems.

## Contents

* Altair Tools disk utility
* Amsterdam Compiler Kit
* CP/M Programs
* CPM Tools disk image utilities
* Intel Macro 80 Cross-Assembler
* Intel Interp 80
* Intel PL/M-80 Cross Compilers v2.0 and v4.0
* Intel ISIS Programs
* LAR Library Archiver
* lbrate archive tool
* ld80 cross linker
* nomarch archive tool
* Pasmo cross-assembler
* rz80
* OpenSimH Emulators and Simtools
* SimH "Classic" v3.12-5 Emulators
* Thames ISIS Emulator
* unarj archive tool
* YAZE Emulator
* YAZE-AG Emulator
* Z80Pack Emulator
* z88dk toolkit
* zmac cross assembler
* ZXCC CP/M
* Disk Utilities

## Altair Tools Disk Utility

The [Altair Tools](https://github.com/phatchman/altair_tools.git)
includes a disk utility program that provides access to MITS Altair disk images.

## Amsterdam Compiler Kit

The [Amsterdam Compiler Kit](http://tack.sf.net/) is a complete compiler toolchain consisting of
front end compilers for a number of different languages, code generators,
support libraries, and all the tools necessary to go from source code to
executable on any of the platforms it supports.

### Languages

* ANSI C (K&R also supported)
* B
* Pascal
* Modula 2
* Basic

### Platforms

The kit supports a number of platforms, including **CP/M**(`cpm`) and **PDP-11 v7 Unix**(`pdpv7`). It is configured to make **CP/M** the default platform.


## CPM Tools disk image utilities

This package allows to access CP/M file systems similar to the well-known mtools package, which accesses MSDOS file systems. It can be used for file exchange with a Z80-PC simulator.

Currently it contains:

*    `cpmls` - list sorted directory with output similar to `ls`, `DIR`, **P2DOS** `DIR` and **CP/M v3** `DIR[FULL]`.
*    `cpmcp` - copy files from and to CP/M file systems
*    `cpmrm` - erase files from CP/M file systems
*    `cpmchmod` - change file permissions
*    `cpmchattr` - change file attributes
*    `mkfs.cpm` - make a CP/M file system
*    `fsck.cpm` - check and repair a CP/M file system (only simple errors can be repaired so far).
*    `fsed.cpm` - view CP/M file system

## Intel Macro 80 Cross-Assembler

This is the Macro 80 Cross-Assembler originally created by Intel. Obviously, it uses Intel mnemonics and generates
an Intel Hex format output file as well as a listing file.

## Intel Interp 80

Not much documentation. The Intel Software Simulation of the MCS-8 8080 CPU and Memory.

## Intel PL/M-80 Cross Compilers v2.0 and v4.0

Two versions of a PL/M-80 Cross Compiler. The program produces Intel Hex format output as well as a listing file.

## LAR Library Archiver

[LAR](https://www.seasip.info/Unix/Lar/index.html) is a UNIX program to manipulate archive files in the CP/M LBR (LiBRary) format.
It is an updated version of Stephen C. Hemminger's original.

## lbrate archive tool

[lbrate](https://zgedneil.nfshost.com/lbrate.html) extracts/decompresses files from the CP/M LBR format. (It can also list and test such archives.) It does this in an unzip-like manner, mostly hiding the details of individually compressed and renamed files, and transparently deals with any required decompression/renaming.

It can also decompress individual CP/M-style Q/Z/Y (squeezed, crunched, etc.) files directly.

### zcim-lbrlist

I created a tool `zcim-lbrlist` for use with [ZCim](https://www.z80cim.org/) based upon `lbrate`.
It gathers information about the LBR archives and their contents and outputs it in **JSON** format
for further analysis.


## ld80 cross linker

[ld80](http://48k.ca/ld80.html) is a linker for `.rel` object files as seen on CP/M and TRS-80 machines.
It is a clone of Microsoft's original L80 linker and was written by Gábor Kiss.

## nomarch archive tool

[nomarch](https://zgedneil.nfshost.com/nomarch.html) extracts files from the old .arc (or .ark) archive format. It can also list and test such archives.

### zcim-arclist

I created a tool `zcim-arclist` for use with [ZCim](https://www.z80cim.org/) based upon `nomarch`.
It gathers information about the **ARC**/**ARK** archives and their contents and outputs it in **JSON** format
for further analysis.

## Pasmo cross-assembler

[Pasmo](https://pasmo.speccy.org/) is a Z80 cross assembler, written in standard C++ that compiles
easily in multiple platforms. Actually can generate object code in the following formats:
raw binary, Intel HEX, PRL for CP/M Plus RSX, Plus3Dos (Spectrum +3 disk), TAP, TZX and
CDT (Spectrum and Amstrad CPC emulators tape images), AmsDos (Amstrad CPC disk)
and MSX (for use with BLOAD from disk in Basic).

## OpenSimH Emulators and Simtools

[Open SIMH](https://opensimh.org/) is a framework and family of computer simulators,
initiated by Bob Supnik and continued with contributions (large and small) from many others,
with the primary goal of enabling the preservation of knowledge contained in, and providing
the ability to execute/experience, old/historic software via simulation of the hardware on
which it ran. This goal has been successfully achieved and has for these years created a
diverse community of users and developers.

The [simtools](https://github.com/open-simh/simtools) are also included,
although they are not normally used with Altair(8080/Z80) simulations.

## rz80

[rz80](http://48k.ca/rz80.html) takes a Z-80 program in `.com`, `.hex` or `.cas` format and runs it until it hits
a HALT instruction or a JP/JR that branches to itself (i.e., a trivial infinite loop).
Useful for developing or unit testing Z-80 code without the overhead of a GUI emulator for a Z-80 system.

## SimH "Classic" v3.12-5 Emulators

[SimH](https://simh.trailing-edge.com/) (History Simulator) is a collection of simulators for
historically significant or just plain interesting computer hardware and software from the past.
The goal of the project is to create highly portable system simulators and to publish them as
open-source software on the Internet, with freely available copies of significant or representative software.

### go-classic and go-opensimh utilities

Since there is significant overlap between the OpenSIMH and the "Classic" SIMH programs, there is
a "switch" in the file system that indicates which is the current default program.

The initial setting is for the "`opensimh`" programs. This means if you execute `altair`, you will get the **OpenSIMH** version of the emulator. In order to switch to the classic versions,
execute the `go-classic` program. After executing the script, `altair` would execute the **Classic v3.12-5 version** of the emulator. To switch back, use the `go-opensimh` program.

Note: you can always execute a specific emulator using its full path. eg. `/opt/simh/opensimh/bin/altairz80` or `/opt/simh/classic/bin/altair`.

## Thames ISIS Emulator

[thames](https://www.seasip.info/Unix/Thames/index.html) is an ISIS-II emulator,
allowing the [tools](http://www.cpm.z80.de/binary.html) used to build CP/M 3 to be run under Unix.

### Intel ISIS Programs

A number of existing ISIS programs may be accessed using wrapper scripts using **thames**.
In each case, a specific version is used (in parens). Other versions are available.
The wrapper script names all begin with `isis-`, so the **plm80** ISIS program
is accessed using the script `isis-plm80`.

* asm80 (2.0)
* hexobj (2.2)
* ixref (1.1)
* lib (2.1)
* link (1.3)
* locate (2.1)
* objhex (2.2)
* plm80 (3.0)

## unarj archive tool

A **modified** version of the UNARJ unarchive tool modified to run on modern systems. It is used to unarchive **ARJ** files, much like `nomarch` does for **ARK** and **ARC** files.

## YAZE Emulator

[Yaze](https://github.com/lipro-cpm4l/yaze) is a Z80 and CP/M emulator designed to run on Unix systems.

The package consists of an instruction set simulator,
a CP/M-2.2 BIOS written in C which runs on the Unix host,
a monitor which loads CP/M into the simulated processor's RAM
and makes Unix directories or files look like CP/M disks,
and a separate program (`cdm`) which creates and manipulates
CP/M disk images for use with `yaze` (and `yaze-ag`).

## YAZE-AG Emulator

[YAZE-AG](https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/#documentation) - Yet Another Z80 Emulator by AG (final release 2.51.3)

In order to support both the **YAZE** and **YAZE-AG** emulators,
the driver script for **YAZE-AG** Emulator has been renamed to `yaze-ag`.

## Z80Pack Emulator

[z80pack](https://www.icl1900.co.uk/unix4fun/z80pack/index.html) is a Zilog Z80 and Intel 8080 cross development package for UNIX and Windows systems distributed with all sources under a BSD style license. Included are:

* `z80sim` - Generic Z80/8080 CPU emulation with ICE like user interface, similar to hardware emulators from Zilog and Mostek and others
* `z80asm` - Z80 cross assembler to bootstrap a Z80 or 8080 system from an UNIX or Windows host
* `cpmsim` - Emulation of a complete system for running CP/M 1, CP/M 2, CPM 3 and MP/M 2 (bootable OS disk images included)
* `altairsim` - Emulation of an Altair 8800 system with 8080 or Z80 CPU, 64KB RAM, Cromemco Dazzler graphics, Tarbell SD disk controller with four 8" SD disk drives, front panel, 88SIO-2 connected to the host terminal, line printer connected to host file
* `imsaisim` - Emulation of an IMSAI 8080 system with 8080 or Z80 CPU, 64KB RAM, Cromemco Dazzler graphics, IMSAI FIF disk controller with four 8" SD disk drives, front panel, SIO-2 connected to the host terminal, line printer connected to host file
* `cromemcosim` - Emulation of a Cromemco Z-1 with Z80 CPU, 7 x 64KB banked memory, Cromemco Dazzler graphics, Cromemco 4FDC/16FDC disk controller with four 5.25" and 8" disk drives with support for DS and DD, front panel, UART on FDC card connected to the host terminal, additional TU-ART for more serial terminals and parallel printers

## z88dk

[Z88DK](https://www.z88dk.org/) is a collection of software development tools that targets
the 8080 and z80 family of machines. It allows development of programs in C, assembly language
or any mixture of the two. What makes z88dk unique is its ease of use, built-in support for
many z80 machines and its extensive set of assembly language library subroutines implementing
the C standard and extensions.

## zmac cross assembler

[zmac](http://48k.ca/zmac.html) is a Z-80 macro cross-assembler.
It has all the features you'd expect. It assembles the specified input file
(with a '.z' extension if there is no pre-existing extension and the file as given doesn't exist)
and produces program output in many different formats.
It also produces a nicely-formatted listing of the machine code and cycle counts alongside the source in a ".lst" file.


## ZXCC CP/M

[ZXCC](https://www.seasip.info/Unix/Zxcc/) is a two-purpose CP/M 2/3 emulator allowing:

*   [Hi-Tech C for CP/M](http://www.hitech.com.au/) to be used as a cross-compiler under Unix.
*   The CP/M build tools (MAC, RMAC, GENCOM, LINK) to be used under Linux.

### CP/M Programs

A number of CP/M programs are made available by using a ZXCC wrapper script.

* `asm.com` Digital Research 8080 Assembler v2.0
* `cref80.com` Digital Research Cross Reference Tool
* `dis.com` Intel format disassembler
* `f80.com` Microsoft Fortran-80 compiler
* `l80.com` Microsoft Link-80 linker v3.44
* `lib80.com` Digital Research Library Tool
* `link.com` Digital Research Linker v1.3
* `load.com` Digital Research File Loader
* `m80.com` Microsoft M80 Assembler
* `mac.com` Digital Research Macro Assembler v2.0
* `makesym.com` SLR Systems Symbol Table Tool
* `slrib.com` SLR Systems SuperLibrarian v1.30
* `slrnk.com` SLR Systems SuperLinker v1.31
* `slrnk1.com` SLR Systems SuperLinker v1.31
* `z80asm.com` SLR Systems Z80 Assembler v1.32
* `z80dis.com` Z80 format disassembler
* `zsm.com` Zilog/Mostek Z80 Assembler v3.4
* `zsm4.com` Z80/Z180/Z280 Macro-Assembler V4.7


## Disk Utilities

A [collection of utilities](https://github.com/keirf/disk-utilities)
for ripping, dumping, analyzing, and modifying disk images.

### `disk-analyse` Disk image conversion tool.

#### Read-only support:

* Kryoflux STREAM
* DiscFerret (.DFI)
* Amiga diskread (.DAT)
* SPS/CTRaw

#### Read/write support:

* SPS/IPF
* ADF, Extended ADF
* LibDisk (.DSK)
* Supercard Pro (.SCP)
* ImageDisk (.IMD)
* Sector Image (.IMG)
* HxC Floppy Emulator (.HFE) (orig,v3)
