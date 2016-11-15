/* This linker script generated from xt-genldscripts.tpp for LSP /home/rajivr/MultiCoreWare/MP/sys-x86-linux/subsys.xtsys/package/cores/P6_1/xtensa-elf/lib/rtos-ram */
/* Linker Script for default link */
/*  Customer ID=256; Build=0x63880; Copyright (c) 2005-2016 Tensilica Inc.  */
/*
 *  This is one of four linker scripts generated for general-purpose,
 *  and for use by RTOS in particular.
 *
 *  These scripts have the property that the -Ttext, -Tdata and -Tbss
 *  linker options generally work as expected (unlike the default linker
 *  scripts generated by xt-genldscripts).  That is, these options
 *  move the text, data and/or bss sections in memory as specified.
 *  This approach implies there is NO memory overflow or overlap checking
 *  on the .text, .data and .bss sections because these are directed to
 *  an unrestricted MEMORY region in the linker script (covering 4 GB).
 *
 *  Note:  these linker scripts do not yet have easy support of ROMs
 *	other than the system ROM (eg. of instruction and data ROMs).
 *  Note:  no configuration file *system* info is reflected in these linker
 *	scripts except system ROM, system RAM, and vector locations/sizes.
 *
 *  The four linker scripts emit/pack sections as follows:
 *
 *			<> = vaddr = paddr
 *			{} = vaddr (copied-from-packed or zeroed)
 *			[] = paddr (packed)
 *  rtos-ram LSP:
 *	RAM contents:	<ramvecs>...  <text+rodata><data><bss>
 *	ROM contents:	(none)
 *	---
 *	Linker script for RAM images.
 *	This has no unpack table; the various discontiguous RAM sections
 *	(vectors, etc) are loaded by an external ELF loader.
 *
 *  rtos-ramp LSP:
 *	RAM contents:	{ramvecs}...  <text+rodata+unpack><data>[ramvecs] <bss>
 *	ROM contents:	(none)
 *	---
 *	This script is similar to rtosram.ld, but packs RAM vectors after
 *	the .data section.  The RAM vectors must be unpacked in the image's
 *	initialization code (before any C code).  This arrangement is
 *	necessary when the image gets loaded by anything more complicated
 *	than an assembler loop that immediately jumps to the code, because
 *	otherwise loading the RAM vectors would corrupt operation of
 *	the loading process (eg. VxWorks bootrom has a full kernel
 *	running during boot loading, with TFTP/FTP/RSH/TCP/IP/etc. tasks).
 *	It is also necessary when one needs one contiguous block of bytes,
 *	eg. for compression.
 *
 *  rtos-rom LSP:
 *	RAM contents:	{ramvecs}...  {text+rodata}{data}{bss}
 *	ROM contents:	<romvecs>...  <srom+unpack>[text+rodata][data][ramvecs]
 *	---
 *	Linker script for ROM images, where most sections are copied to RAM
 *	before being executed.  This is a typical scenario when executing
 *	directly from ROM is too slow for normal operation.  The unpacking
 *	code is typically put in the .srom.* sections (or in the reset vector
 *	if it is large enough).
 *
 *  rtos-res LSP:
 *	RAM contents:	{ramvecs}...  {data}{bss}
 *	ROM contents:	<romvecs>...  <srom+text+rodata+unpack>[data][ramvecs]
 *	---
 *	Linker script for ROM images, where code executes directly out of ROM.
 *	Initialized data and RAM vectors need to be copied to RAM, so this
 *	image also needs unpacking code early in initialization.
 *
 *
 *  VxWorks uses these linker scripts as follows:
 *	Image type:	Script			Flags   (lohi = RAM_LOW_ADRS
 *	----------	------			-----        or RAM_HIGH_ADRS)
 *	RAM:		rtosramp.ld	RAM	-Ttext=lohi
 *	ROM-resident:	rtosres.ld	ROM	-Tdata=lohi -Ttext=ROM_TEXT_ADRS
 *	ROM-uncmp:	rtosrom.ld	ROM	-Ttext=lohi
 *	ROM-cmp-inner:	rtosramp.ld	RAM	-Ttext=lohi
 *	ROM-cmp-outer:	rtosrom.ld	ROM	-Ttext=lohi
 *
 */
/*
 *  Virtual memory ranges where sections can be directed
 *  (these are called 'segments' in Xtensa internal documentation).
 *
 *  Entries are of the form:
 *	name (attr) : ORIGIN = e, LENGTH = e
 *	name (attr) : org = e, len = e
 *	name (attr) : o = e, l = e
 *  where attr is a combination of:
 *	R=readonly
 *	W=read/write
 *	X=executable
 *	A=allocated
 *	I=L=initialized
 *	!=invert sense of following attributes
 */
MEMORY
{
  dram1_0_seg :                       	org = 0x3FFC0000, len = 0x20000
  dram0_0_seg :                       	org = 0x3FFE0000, len = 0x20000
  sysram_B0_seg :                     	org = 0x61000000, len = 0x178
  sysram_B1_seg :                     	org = 0x61000178, len = 0x8
  sysram_B2_seg :                     	org = 0x61000180, len = 0x38
  sysram_B3_seg :                     	org = 0x610001B8, len = 0x8
  sysram_B4_seg :                     	org = 0x610001C0, len = 0x38
  sysram_B5_seg :                     	org = 0x610001F8, len = 0x8
  sysram_B6_seg :                     	org = 0x61000200, len = 0x38
  sysram_B7_seg :                     	org = 0x61000238, len = 0x8
  sysram_B8_seg :                     	org = 0x61000240, len = 0x38
  sysram_B9_seg :                     	org = 0x61000278, len = 0x8
  sysram_B10_seg :                    	org = 0x61000280, len = 0x38
  sysram_B11_seg :                    	org = 0x610002B8, len = 0x48
  sysram_B12_seg :                    	org = 0x61000300, len = 0x40
  sysram_B13_seg :                    	org = 0x61000340, len = 0x7FFCC0
  /*  Entry covering the entire address space, to avoid linker errors
      due to mixing sections that are directed to MEMORY regions and
      others that are not:  */
  ALLMEMORY :				org = 0, len = 0xFFFFFFFF
}

PHDRS
{
/*
 *  ELF linker scripts can contain explicit program headers
 *  (which tell the loader what to load where), eg.:
 *	PHDRS { <entries>... }
 *  where <entries> are of the form:
 *	NAME TYPE [ FILEHDR ] [ PHDRS ] [ AT ( ADDRESS ) ] [ FLAGS ( FLAGS ) ] ;
 */
  sysram_l0_phdr PT_LOAD;
  dram1_0_phdr PT_LOAD;
  dram0_0_phdr PT_LOAD;
  sysram_B0_phdr PT_LOAD;
  sysram_B1_phdr PT_LOAD;
  sysram_B2_phdr PT_LOAD;
  sysram_B3_phdr PT_LOAD;
  sysram_B4_phdr PT_LOAD;
  sysram_B5_phdr PT_LOAD;
  sysram_B6_phdr PT_LOAD;
  sysram_B7_phdr PT_LOAD;
  sysram_B8_phdr PT_LOAD;
  sysram_B9_phdr PT_LOAD;
  sysram_B10_phdr PT_LOAD;
  sysram_B11_phdr PT_LOAD;
  sysram_B12_phdr PT_LOAD;
  sysram_B13_phdr PT_LOAD;
  sysram0_phdr PT_LOAD;
  sharedram_l0_phdr PT_LOAD;
  mmio0_phdr PT_LOAD;
}


/*  Default entry point:  */
ENTRY(_start)

/*  Memory boundary addresses:  */
_memmap_mem_sysram_l_start = 0x4;
_memmap_mem_sysram_l_end   = 0x10000000;
_memmap_mem_dram1_start = 0x3ffc0000;
_memmap_mem_dram1_end   = 0x3ffe0000;
_memmap_mem_dram0_start = 0x3ffe0000;
_memmap_mem_dram0_end   = 0x40000000;
_memmap_mem_sysram_B_start = 0x61000000;
_memmap_mem_sysram_B_end   = 0x61800000;
_memmap_mem_sysram_start = 0x61800000;
_memmap_mem_sysram_end   = 0x64000000;
_memmap_mem_sharedram_l_start = 0xf0000000;
_memmap_mem_sharedram_l_end   = 0xfd000000;
_memmap_mem_mmio_start = 0xfd000000;
_memmap_mem_mmio_end   = 0xfe000000;

/*  Memory segment boundary addresses:  */
_memmap_seg_dram1_0_start = 0x3ffc0000;
_memmap_seg_dram1_0_max   = 0x3ffe0000;
_memmap_seg_dram0_0_start = 0x3ffe0000;
_memmap_seg_dram0_0_max   = 0x40000000;
_memmap_seg_sysram_B0_start = 0x61000000;
_memmap_seg_sysram_B0_max   = 0x61000178;
_memmap_seg_sysram_B1_start = 0x61000178;
_memmap_seg_sysram_B1_max   = 0x61000180;
_memmap_seg_sysram_B2_start = 0x61000180;
_memmap_seg_sysram_B2_max   = 0x610001b8;
_memmap_seg_sysram_B3_start = 0x610001b8;
_memmap_seg_sysram_B3_max   = 0x610001c0;
_memmap_seg_sysram_B4_start = 0x610001c0;
_memmap_seg_sysram_B4_max   = 0x610001f8;
_memmap_seg_sysram_B5_start = 0x610001f8;
_memmap_seg_sysram_B5_max   = 0x61000200;
_memmap_seg_sysram_B6_start = 0x61000200;
_memmap_seg_sysram_B6_max   = 0x61000238;
_memmap_seg_sysram_B7_start = 0x61000238;
_memmap_seg_sysram_B7_max   = 0x61000240;
_memmap_seg_sysram_B8_start = 0x61000240;
_memmap_seg_sysram_B8_max   = 0x61000278;
_memmap_seg_sysram_B9_start = 0x61000278;
_memmap_seg_sysram_B9_max   = 0x61000280;
_memmap_seg_sysram_B10_start = 0x61000280;
_memmap_seg_sysram_B10_max   = 0x610002b8;
_memmap_seg_sysram_B11_start = 0x610002b8;
_memmap_seg_sysram_B11_max   = 0x61000300;
_memmap_seg_sysram_B12_start = 0x61000300;
_memmap_seg_sysram_B12_max   = 0x61000340;
_memmap_seg_sysram_B13_start = 0x61000340;
_memmap_seg_sysram_B13_max   = 0x61800000;

_rom_store_table = 0;
_ResetTable_base = 0x50600000;
PROVIDE(_memmap_vecbase_reset = 0x61000000);
PROVIDE(_memmap_reset_vector = 0x50000000);
/* Various memory-map dependent cache attribute settings: */
_memmap_cacheattr_wb_base = 0x10041041;
_memmap_cacheattr_wt_base = 0x30043043;
_memmap_cacheattr_bp_base = 0x40044044;
_memmap_cacheattr_unused_mask = 0x0FF00F00;
_memmap_cacheattr_wb_trapnull = 0x14441441;
_memmap_cacheattr_wba_trapnull = 0x14441441;
_memmap_cacheattr_wbna_trapnull = 0x24442442;
_memmap_cacheattr_wt_trapnull = 0x34443443;
_memmap_cacheattr_bp_trapnull = 0x44444444;
_memmap_cacheattr_wb_strict = 0x10041041;
_memmap_cacheattr_wt_strict = 0x30043043;
_memmap_cacheattr_bp_strict = 0x40044044;
_memmap_cacheattr_wb_allvalid = 0x14441441;
_memmap_cacheattr_wt_allvalid = 0x34443443;
_memmap_cacheattr_bp_allvalid = 0x44444444;
PROVIDE(_memmap_cacheattr_reset = _memmap_cacheattr_wb_trapnull);
/*
 *  Other commands and functions of interest:
 *	PROVIDE(var = value);
 *	ABSOLUTE(e)		non-section-relative expr
 *	ADDR(e)			vaddr
 *	LOADADDR(e)		paddr (=vaddr if not AT())
 *	ALIGN(e)		(. + e - 1) & ~(e - 1)
 *	NEXT(e)			like ALIGN(), but if MEMORY is used, may skip to next available region
 *	DEFINED(sym)		1 if sym defined, else 0
 *	SIZEOF(section)		size of section if allocated
 *	SIZEOF_HEADERS		size in byte of output file's headers
 *	MAX(e1,e2)
 *	MIN(e1,e2)
 */
/*
 *  Mapping of input sections to output sections when linking.
 *
 *  Entries are of the form:
 *	SECNAME START BLOCK(ALIGN) (NOLOAD) : AT ( LDADR )
 *		{ CONTENTS } >REGION :PHDR [... or :NONE] =FILL
 *  or
 *	/DISCARD/ : { IGNORED_SECTIONS... }
 *
 *  Also in sections:
 *	BYTE(e) SHORT(e) LONG(e) QUAD(e) SQUAD(e)
 */

SECTIONS
{

  /*  -Ttext moves vaddr of what follows:  */
  .text 0x61000340 : ALIGN(4)
  {
    _stext = .;
    _text_start = ABSOLUTE(.);
    *(.entry.text)
    *(.init.literal)
    KEEP(*(.init))
    *(.literal .text .literal.* .text.* .stub .gnu.warning .gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)
    *(.fini.literal)
    KEEP(*(.fini))
    *(.gnu.version)
    *(.sysram.rodata)
    *(.rodata)
    *(.rodata.*)
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    __XT_EXCEPTION_TABLE__ = ABSOLUTE(.);
    KEEP (*(.xt_except_table))
    KEEP (*(.gcc_except_table))
    *(.gnu.linkonce.e.*)
    *(.gnu.version_r)
    KEEP (*(.eh_frame))
    /*  C++ constructor and destructor tables, properly ordered:  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    KEEP (*crtbegin.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
    /*  C++ exception handlers table:  */
    __XT_EXCEPTION_DESCS__ = ABSOLUTE(.);
    *(.xt_except_desc)
    *(.gnu.linkonce.h.*)
    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);
    *(.xt_except_desc_end)
    *(.dynamic)
    *(.gnu.version_d)
    . = ALIGN(4);		/* this table MUST be 4-byte aligned */
    _bss_table_start = ABSOLUTE(.);
    LONG(_dram1_bss_start)
    LONG(_dram1_bss_end)
    LONG(_dram0_bss_start)
    LONG(_dram0_bss_end)
    LONG(_bss_start)
    LONG(_bss_end)
    _bss_table_end = ABSOLUTE(.);
    *(.SharedResetVector.literal)
    *(.sysram.literal .sysram.text)
    _text_end = ABSOLUTE(.);
    _etext = .;
  } >ALLMEMORY :sysram_B13_phdr

  /*  -Tdata moves vaddr of what follows:  */
  .data : ALIGN(4)
  {
    _data_start = ABSOLUTE(.);
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d.*)
    KEEP(*(.gnu.linkonce.d.*personality*))
    *(.data1)
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.sdata2)
    *(.sdata2.*)
    *(.gnu.linkonce.s2.*)
    KEEP(*(.jcr))
    *(.sysram.data)
    _data_end = ABSOLUTE(.);
  } >ALLMEMORY :sysram_B13_phdr

  /*  -Tbss moves vaddr of what follows:  */
  .bss (NOLOAD) : ALIGN(8)
  {
    . = ALIGN (8);
    _bss_start = ABSOLUTE(.);
    *(.dynsbss)
    *(.sbss)
    *(.sbss.*)
    *(.gnu.linkonce.sb.*)
    *(.scommon)
    *(.sbss2)
    *(.sbss2.*)
    *(.gnu.linkonce.sb2.*)
    *(.dynbss)
    *(.bss)
    *(.bss.*)
    *(.gnu.linkonce.b.*)
    *(COMMON)
    *(.sysram.bss)
    . = ALIGN (8);
    _bss_end = ABSOLUTE(.);
    _end = ALIGN(0x8);
    PROVIDE(end = ALIGN(0x8));
    _stack_sentry = ALIGN(0x8);
    _memmap_seg_sysram_B13_end = ALIGN(0x8);
  } >ALLMEMORY :NONE
  PROVIDE(__stack = 0x61800000);
  _heap_sentry = 0x61800000;

  .dram1.rodata : ALIGN(4)
  {
    _dram1_rodata_start = ABSOLUTE(.);
    *(.dram1.rodata)
    _dram1_rodata_end = ABSOLUTE(.);
  } >dram1_0_seg :dram1_0_phdr

  .dram1.literal : ALIGN(4)
  {
    _dram1_literal_start = ABSOLUTE(.);
    *(.dram1.literal)
    _dram1_literal_end = ABSOLUTE(.);
  } >dram1_0_seg :dram1_0_phdr

  .dram1.data : ALIGN(4)
  {
    _dram1_data_start = ABSOLUTE(.);
    *(.dram1.data)
    _dram1_data_end = ABSOLUTE(.);
  } >dram1_0_seg :dram1_0_phdr

  .dram1.bss (NOLOAD) : ALIGN(8)
  {
    . = ALIGN (8);
    _dram1_bss_start = ABSOLUTE(.);
    *(.dram1.bss)
    . = ALIGN (8);
    _dram1_bss_end = ABSOLUTE(.);
    _memmap_seg_dram1_0_end = ALIGN(0x8);
  } >dram1_0_seg :NONE

  .dram0.rodata : ALIGN(4)
  {
    _dram0_rodata_start = ABSOLUTE(.);
    *(.dram0.rodata)
    _dram0_rodata_end = ABSOLUTE(.);
  } >dram0_0_seg :dram0_0_phdr

  .dram0.literal : ALIGN(4)
  {
    _dram0_literal_start = ABSOLUTE(.);
    *(.dram0.literal)
    _dram0_literal_end = ABSOLUTE(.);
  } >dram0_0_seg :dram0_0_phdr

  .dram0.data : ALIGN(4)
  {
    _dram0_data_start = ABSOLUTE(.);
    *(.dram0.data)
    _dram0_data_end = ABSOLUTE(.);
  } >dram0_0_seg :dram0_0_phdr

  .dram0.bss (NOLOAD) : ALIGN(8)
  {
    . = ALIGN (8);
    _dram0_bss_start = ABSOLUTE(.);
    *(.dram0.bss)
    . = ALIGN (8);
    _dram0_bss_end = ABSOLUTE(.);
    _memmap_seg_dram0_0_end = ALIGN(0x8);
  } >dram0_0_seg :NONE

  .WindowVectors.text : ALIGN(4)
  {
    _WindowVectors_text_start = ABSOLUTE(.);
    KEEP (*(.WindowVectors.text))
    _WindowVectors_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B0_end = ALIGN(0x8);
  } >sysram_B0_seg :sysram_B0_phdr

  .Level2InterruptVector.literal : ALIGN(4)
  {
    _Level2InterruptVector_literal_start = ABSOLUTE(.);
    *(.Level2InterruptVector.literal)
    _Level2InterruptVector_literal_end = ABSOLUTE(.);
    _memmap_seg_sysram_B1_end = ALIGN(0x8);
  } >sysram_B1_seg :sysram_B1_phdr

  .Level2InterruptVector.text : ALIGN(4)
  {
    _Level2InterruptVector_text_start = ABSOLUTE(.);
    KEEP (*(.Level2InterruptVector.text))
    _Level2InterruptVector_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B2_end = ALIGN(0x8);
  } >sysram_B2_seg :sysram_B2_phdr

  .DebugExceptionVector.literal : ALIGN(4)
  {
    _DebugExceptionVector_literal_start = ABSOLUTE(.);
    *(.DebugExceptionVector.literal)
    _DebugExceptionVector_literal_end = ABSOLUTE(.);
    _memmap_seg_sysram_B3_end = ALIGN(0x8);
  } >sysram_B3_seg :sysram_B3_phdr

  .DebugExceptionVector.text : ALIGN(4)
  {
    _DebugExceptionVector_text_start = ABSOLUTE(.);
    KEEP (*(.DebugExceptionVector.text))
    _DebugExceptionVector_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B4_end = ALIGN(0x8);
  } >sysram_B4_seg :sysram_B4_phdr

  .NMIExceptionVector.literal : ALIGN(4)
  {
    _NMIExceptionVector_literal_start = ABSOLUTE(.);
    *(.NMIExceptionVector.literal)
    _NMIExceptionVector_literal_end = ABSOLUTE(.);
    _memmap_seg_sysram_B5_end = ALIGN(0x8);
  } >sysram_B5_seg :sysram_B5_phdr

  .NMIExceptionVector.text : ALIGN(4)
  {
    _NMIExceptionVector_text_start = ABSOLUTE(.);
    KEEP (*(.NMIExceptionVector.text))
    _NMIExceptionVector_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B6_end = ALIGN(0x8);
  } >sysram_B6_seg :sysram_B6_phdr

  .KernelExceptionVector.literal : ALIGN(4)
  {
    _KernelExceptionVector_literal_start = ABSOLUTE(.);
    *(.KernelExceptionVector.literal)
    _KernelExceptionVector_literal_end = ABSOLUTE(.);
    _memmap_seg_sysram_B7_end = ALIGN(0x8);
  } >sysram_B7_seg :sysram_B7_phdr

  .KernelExceptionVector.text : ALIGN(4)
  {
    _KernelExceptionVector_text_start = ABSOLUTE(.);
    KEEP (*(.KernelExceptionVector.text))
    _KernelExceptionVector_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B8_end = ALIGN(0x8);
  } >sysram_B8_seg :sysram_B8_phdr

  .UserExceptionVector.literal : ALIGN(4)
  {
    _UserExceptionVector_literal_start = ABSOLUTE(.);
    *(.UserExceptionVector.literal)
    _UserExceptionVector_literal_end = ABSOLUTE(.);
    _memmap_seg_sysram_B9_end = ALIGN(0x8);
  } >sysram_B9_seg :sysram_B9_phdr

  .UserExceptionVector.text : ALIGN(4)
  {
    _UserExceptionVector_text_start = ABSOLUTE(.);
    KEEP (*(.UserExceptionVector.text))
    _UserExceptionVector_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B10_end = ALIGN(0x8);
  } >sysram_B10_seg :sysram_B10_phdr

  .DoubleExceptionVector.literal : ALIGN(4)
  {
    _DoubleExceptionVector_literal_start = ABSOLUTE(.);
    *(.DoubleExceptionVector.literal)
    _DoubleExceptionVector_literal_end = ABSOLUTE(.);
    _memmap_seg_sysram_B11_end = ALIGN(0x8);
  } >sysram_B11_seg :sysram_B11_phdr

  .DoubleExceptionVector.text : ALIGN(4)
  {
    _DoubleExceptionVector_text_start = ABSOLUTE(.);
    KEEP (*(.DoubleExceptionVector.text))
    _DoubleExceptionVector_text_end = ABSOLUTE(.);
    _memmap_seg_sysram_B12_end = ALIGN(0x8);
  } >sysram_B12_seg :sysram_B12_phdr
  .debug  0 :  { *(.debug) }
  .line  0 :  { *(.line) }
  .debug_srcinfo  0 :  { *(.debug_srcinfo) }
  .debug_sfnames  0 :  { *(.debug_sfnames) }
  .debug_aranges  0 :  { *(.debug_aranges) }
  .debug_pubnames  0 :  { *(.debug_pubnames) }
  .debug_info  0 :  { *(.debug_info) }
  .debug_abbrev  0 :  { *(.debug_abbrev) }
  .debug_line  0 :  { *(.debug_line) }
  .debug_frame  0 :  { *(.debug_frame) }
  .debug_str  0 :  { *(.debug_str) }
  .debug_loc  0 :  { *(.debug_loc) }
  .debug_macinfo  0 :  { *(.debug_macinfo) }
  .debug_weaknames  0 :  { *(.debug_weaknames) }
  .debug_funcnames  0 :  { *(.debug_funcnames) }
  .debug_typenames  0 :  { *(.debug_typenames) }
  .debug_varnames  0 :  { *(.debug_varnames) }
  .xt.insn 0 :
  {
    KEEP (*(.xt.insn))
    KEEP (*(.gnu.linkonce.x.*))
  }
  .xt.prop 0 :
  {
    KEEP (*(.xt.prop))
    KEEP (*(.xt.prop.*))
    KEEP (*(.gnu.linkonce.prop.*))
  }
  .xt.lit 0 :
  {
    KEEP (*(.xt.lit))
    KEEP (*(.xt.lit.*))
    KEEP (*(.gnu.linkonce.p.*))
  }
  .debug.xt.callgraph 0 :
  {
    KEEP (*(.debug.xt.callgraph .debug.xt.callgraph.* .gnu.linkonce.xt.callgraph.*))
  }
}

