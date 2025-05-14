# Intel MAC80 Macro Cross Assembler

This is the Intel MAC80 Cross Assembler in a usable setup for modern
UNIX systems. The assembler is written in Fortran 66, to use it under
UNIX, a GNU Fortran compiler (f77 or gfortran) is required.

To install the assembler:

cd src
make
make install
make clean

This will install the assembler and a driver shell script in directory bin
under your home directory. If it should be installed elsewhere, like
/usr/local/bin, modify Makefile in directory src.

To test the assembler:

cd examples
m80 example.mac

As a result the files example.prn with the assembler listing and
example.hex with the object code are generated.

The .hex file produced by the assembler can be loaded with LOAD or
MLOAD on CP/M systems and then be executed.

The port to GNU Fortran 77 was done by Ron Young <rly1@embarqmail.com>.
The assignment of I/O channels for a UNIX system and a shell driver script
was done by Udo Munk <udo.munk@freenet.de>.

October 2007, Udo Munk

GNU Fortran 77 is not maintained anymore, we use GNU Fortran 95 now.

January 2014, Udo Munk
