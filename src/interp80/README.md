This is the Intel INTERP/80 Cross 8080 Emulator in a usable setup for modern
UNIX systems. The emulator is written in Fortran 66, to use it under UNIX,
a GNU Fortran compiler (f77 or gfortran) is required.

To install the emulator:

cd src
make
make install
make clean

This will install the emulator and a driver shell script in directory bin
under your home directory. If it should be installed elsewhere, like
/usr/local/bin, modify Makefile in directory src.

To test the emulator:

cd examples
i80 example.in example.hex

In this example the emulator loads symbol table and program from example.hex
and executes the debugging commands from example.in. A file example.out with
the output of the batch run is generated.

For a console debug session use i80 example.hex. The symbol table and program
are loaded and the emulator can be operated from the console now.

The port to GNU Fortran 77 was done by Ron Young <rly1@embarqmail.com>.
The assignment of I/O channels for a UNIX system and a shell driver script
was done by Udo Munk <udo.munk@freenet.de>.

October 2007, Udo Munk

GNU Fortran 77 is not maintained anymore, we use GNU Fortran 95 now.

January 2014, Udo Munk
