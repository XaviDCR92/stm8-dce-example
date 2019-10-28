# Link-time dead code elimination for the STM8
## Overview
This small code example demonstrates the new capabilities that have been implemented
into the STM8 port of GNU ld that allows using --gc-sections and thus remove unused code at link-time.
Feel free to comment out or create any symbols so you can see how final memory usage is affected.

## Usage
```
make
```

This is the expected output from make:
```
sdcc src/main.c -DSTM8S003 -mstm8 --out-fmt-elf -c --debug --opt-code-size --gas --function-sections --data-sections -Iinc/ -MM > obj/main.d
sdcc src/main.c -DSTM8S003 -mstm8 --out-fmt-elf -c --debug --opt-code-size --gas --function-sections --data-sections -Iinc/ -o obj/main.o
sdcc src/bar.c -DSTM8S003 -mstm8 --out-fmt-elf -c --debug --opt-code-size --gas --function-sections --data-sections -Iinc/ -MM > obj/bar.d
sdcc src/bar.c -DSTM8S003 -mstm8 --out-fmt-elf -c --debug --opt-code-size --gas --function-sections --data-sections -Iinc/ -o obj/bar.o
stm8-ld obj/main.o obj/bar.o -o obj/STM8.elf -T./elf32stm8.x --print-memory-usage --gc-sections -Map obj/map_STM8.map 
Memory region         Used Size  Region Size  %age Used
      interrupts:           4 B        128 B      3.12%
             RAM:           5 B        894 B      0.56%
           STACK:          0 GB        128 B      0.00%
          eeprom:          0 GB        128 B      0.00%
            fuse:          0 GB         11 B      0.00%
            lock:          0 GB         1 KB      0.00%
             ROM:         100 B         8 KB      1.22%
       signature:          0 GB         1 KB      0.00%
 user_signatures:          0 GB         1 KB      0.00%
rm obj/bar.d obj/main.d
```

On the other hand, it demonstrates how SDCC can now output *.o files by generating
GAS-compatible assembly code and calling stm8-as afterwards. This allows support for other
tools from the GNU binutils package, such as objdump, size, readelf, etc.

## Toolchain download links
### GNU as-compatible SDCC
https://github.com/XaviDCR92/sdcc-gas
### GNU binutils package modified to support the STM8
https://github.com/XaviDCR92/stm8-binutils-gdb
(forked from https://stm8-binutils-gdb.sourceforge.io)
## Background
As of SDCC 3.9.0, ELF and DWARF2 support were implemented via the in-house linker, sdld. Another package,
stm8-binutils-gdb, provides a port of both GNU binutils and the GNU debugger for the STM8. However, this
implementation worked partially. These were some of the issues I faced when using the SDCC toolchain:

* Unused code was not being removed at link-time since SDCC did not implement an equivalent for
GCC's -ffunction-sections or -fdata-sections.
* Unused code was not being removed at link-time since sdld lacked such feature.
* stm8-size would not report valid results. Instead, it placed all symbols into the .text section.
* stm8-objdump -S would not return any code, even if debugging symbols existed.
* stm8-nm output would be cluttered with tons of intermediate and unneeded labels created
by the compiler during the compiling and assembling steps.
* No compatibility with *.a files created from GNU ar, so no support for closed-source third-party
libraries that could be created using the GNU toolchain.

## Known issues
* An ad-hoc linker script has been provided here since stm8-binutils-gdb currently generates a generic script
whose memory limits are not defined by any part.
* SDCC's Makefile compiles libc and other libraries in its own object format (*.rel), so the sources must be
moved to the project and compiled separately using the GNU toolchain. Otherwise, you will get an undefined reference
link-time error when performing some operations such as integer division. This will be solved once these forks are
integrated into the main branch.
* These forks are new and experimental, so other unexpected issues could occur. In such case, please report them
so we can get a robust and stable implementation.
