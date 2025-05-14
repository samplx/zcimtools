# Intel PL/M-80 Cross Compiler v2

This compiler is normally installed as `plm80` and `plm80v2` in the `Docker` image.

## Some comments from the original README

This archive contains the FORTRAN IV source code for the PL/M-80
cross compiler.  It bears the Intel's copyright, but at some time
in the late 1970's the code was made available by Intel.  The
history of all of this, and the conditions behind it, have become
a bit merky over the years; however, to the best of my knowledge,
you are free to use it for personal and educational applications.
The copy provided in this package was extracted from the standard
distribution tapes for the Michigan Terminal System, an operating
system for IBM mainframe hardware used by about six universities
around the world.

The compiler has been successfully installed on an IBM mainframe
running both the MTS operating system and the more common VM/CMS.
The source code has been compiled by the FORTRAN-G1, FORTRAN-HX,
and VS/FORTRAN compilers.  It should be compilable by any other
FORTRAN compilers that accept the 1966 (FORTRAN IV) standard
since the code seems to confirm rather well to that standard.
Getting a working version on an 8080 or Z80 micro computer may
be a problem, though, but only because of the size of the two
modules.  I have not tried this, but I suspect MicroSoft's
FORTRAN product for MSDOS systems should be able to handle it.

# Details

This is the Intel PL/M-80 Cross Compiler in a usable setup for modern
UNIX systems. The compiler is a 2 pass compiler written in Fortran IV,
to use it under UNIX, a GNU Fortran compiler (f77 or gfortran) is required.

To install the compiler:

```bash
make
make install
make clean
```

This will install the compiler passes and the compiler driver in directory
bin under the `/opt/z80pack` directory. If it should be installed elsewhere, like
`/usr/local`, override the `PREFIX` make variable.

To test the compiler:

```bash
cd examples
plm80 plmsamp.plm
```

As a result the files `plmsamp.prn` with the compiler listing and
`plmsamp.hex` with the object code are generated.

The Intel `.hex` format files produced by the complier can be loaded with `LOAD` or
`MLOAD` on **CP/M** systems and then be excuted.
