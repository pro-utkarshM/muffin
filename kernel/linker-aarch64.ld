/* Tell the linker that we want an AArch64 ELF output file */
OUTPUT_FORMAT(elf64-littleaarch64)
OUTPUT_ARCH(aarch64)

/* We want the symbol _start to be our entry point */
ENTRY(_start)

/* Define the program headers we want so the bootloader gives us the right */
/* MMU permissions */
PHDRS
{
    text    PT_LOAD;
    rodata  PT_LOAD;
    data    PT_LOAD;
}

SECTIONS
{
    /* Kernel starts at higher half of virtual memory */
    . = 0xffffffff80000000;

    .text : {
        *(.text.boot)
        *(.text .text.*)
    } :text

    /* Move to the next memory page for .rodata */
    . = ALIGN(4096);

    .rodata : {
        *(.rodata .rodata.*)
    } :rodata

    /* Move to the next memory page for .data */
    . = ALIGN(4096);

    .data : {
        *(.data .data.*)
    } :data

    /* BSS section */
    .bss : {
        __bss_start = .;
        *(.bss .bss.*)
        *(COMMON)
        __bss_end = .;
    } :data

    /* Discard unnecessary sections */
    /DISCARD/ : {
        *(.eh_frame*)
        *(.note .note.*)
    }
}