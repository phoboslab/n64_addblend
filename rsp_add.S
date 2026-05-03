## Auto-generated file, transpiled with RSPL
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 240
#define SCREEN_STRIDE_RGBA32 (320 * 4)
#define SCREEN_STRIDE_RGBA16 (320 * 2)
#define LINES_PER_BATCH 2
#define SCREEN_WIDTH_BATCH 640
#define BATCH_SIZE_RGBA32 ((320 * 4) * 2)
#define BATCH_SIZE_RGBA16 ((320 * 2) * 2)
#include <rsp_queue.inc>

.set noreorder
.set noat
.set nomacro

#undef zero
#undef at
#undef v0
#undef v1
#undef a0
#undef a1
#undef a2
#undef a3
#undef t0
#undef t1
#undef t2
#undef t3
#undef t4
#undef t5
#undef t6
#undef t7
#undef s0
#undef s1
#undef s2
#undef s3
#undef s4
#undef s5
#undef s6
#undef s7
#undef t8
#undef t9
#undef k0
#undef k1
#undef gp
#undef sp
#undef fp
#undef ra
.equ hex.$zero, 0
.equ hex.$at, 1
.equ hex.$v0, 2
.equ hex.$v1, 3
.equ hex.$a0, 4
.equ hex.$a1, 5
.equ hex.$a2, 6
.equ hex.$a3, 7
.equ hex.$t0, 8
.equ hex.$t1, 9
.equ hex.$t2, 10
.equ hex.$t3, 11
.equ hex.$t4, 12
.equ hex.$t5, 13
.equ hex.$t6, 14
.equ hex.$t7, 15
.equ hex.$s0, 16
.equ hex.$s1, 17
.equ hex.$s2, 18
.equ hex.$s3, 19
.equ hex.$s4, 20
.equ hex.$s5, 21
.equ hex.$s6, 22
.equ hex.$s7, 23
.equ hex.$t8, 24
.equ hex.$t9, 25
.equ hex.$k0, 26
.equ hex.$k1, 27
.equ hex.$gp, 28
.equ hex.$sp, 29
.equ hex.$fp, 30
.equ hex.$ra, 31
#define vco 0
#define vcc 1
#define vce 2

.data
  RSPQ_BeginOverlayHeader
    RSPQ_DefineCommand RGBA8888_TO_5551, 8
  RSPQ_EndOverlayHeader

  RSPQ_EmptySavedState

.bss
  TEMP_STATE_MEM_START:
    .align 4
    BUFF_IN: .ds.b 2560
    .align 1
    BUFF_OUT: .ds.b 640
  TEMP_STATE_MEM_END:

.text
OVERLAY_CODE_START:

RGBA8888_TO_5551:
  lui $at, 0x04                                      ## L:75   |      ^ | u32 ptr_in_end = ptr_in + ((320 * 4) * 240);
  addiu $s4, $zero, 639                              ## L:82   |      2 | u32 dma_size_out = (320 * 2) - 1;
  ori $at, $at, 0xB000                               ## L:75   |      3 | u32 ptr_in_end = ptr_in + ((320 * 4) * 240);
  ori $s6, $zero, %lo(BUFF_OUT)                      ## L:80   |      4 | u32 dmem_out_start = BUFF_OUT;
  addu $s7, $a0, $at                                 ## L:75   |      5 | u32 ptr_in_end = ptr_in + ((320 * 4) * 240);
  addiu $at, $zero, 31744                            ## L:78   |      6 | VCONST_RGB.x = 0b0'11111'00000'00000;
  addiu $s5, $zero, 2559                             ## L:81   |      7 | u32 dma_size_in = ((320 * 4) * 2) - 1;
  mtc2 $at, $v28.e0                                  ## L:78   |      8 | VCONST_RGB.x = 0b0'11111'00000'00000;
  LABEL_RGBA8888_TO_5551_0001:
  mfc0 $ra, COP0_DMA_BUSY                            ## L:36   |      9 | RA = get_dma_busy();
  bne $ra, $zero, LABEL_RGBA8888_TO_5551_0001        ## L:36   |   **12 | RA = get_dma_busy();
  nop                                                ## L:36   |    *14 | RA = get_dma_busy();
  LABEL_RGBA8888_TO_5551_0003:
  ori $s3, $zero, %lo(BUFF_IN)                       ## L:87   |     15 | u32 dmem_in = BUFF_IN;
  mtc0 $s3, COP0_DMA_SPADDR                          ## L:20   |     16 | @Barrier("DMA") set_dma_addr_rsp(addrDMEM); ## Barrier: 0x1
  mtc0 $a0, COP0_DMA_RAMADDR                         ## L:21   |     17 | @Barrier("DMA") set_dma_addr_rdram(addrRDRAM); ## Barrier: 0x1
  addiu $a0, $a0, 2560                               ## L:90   |     18 | ptr_in += ((320 * 4) * 2);
  addiu $s2, $s3, 2560                               ## L:91   |     19 | u32 dmem_in_batch_end = dmem_in + ((320 * 4) * 2);
  mtc0 $s5, COP0_DMA_READ                            ## L:22   |     20 | @Barrier("DMA") set_dma_read(size); ## Barrier: 0x1
  LABEL_RGBA8888_TO_5551_0007:
  mfc0 $ra, COP0_DMA_BUSY                            ## L:98   |     21 | RA = get_dma_busy();
  or $s0, $zero, $s6                                 ## L:101  |     22 | dmem_out = dmem_out_start;
  bne $ra, $zero, LABEL_RGBA8888_TO_5551_0007        ## L:101  |    *24 | dmem_out = dmem_out_start;
  addiu $s1, $s3, 1280                               ## L:100  |    *26 | dmem_in_end = dmem_in + (320 * 4);
  LABEL_RGBA8888_TO_5551_0009:
  lfv $v27, 0, 0, $s3                                ## L:47   |     27 | asm_op("lfv", px_r, 0,	0, dmem_in);
  lfv $v27, 8, 16, $s3                               ## L:48   |     28 | asm_op("lfv", px_r, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:49   |     29 | dmem_in += 1;
  lfv $v26, 0, 0, $s3                                ## L:51   |     30 | asm_op("lfv", px_g, 0,	0, dmem_in);
  lfv $v26, 8, 16, $s3                               ## L:52   |     31 | asm_op("lfv", px_g, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:53   |     32 | dmem_in += 1;
  vmudh $v27, $v27, $v30.e4                          ## L:59   |      ^ | px_r:sint *= (1 << (8 - 5));
  lfv $v25, 0, 0, $s3                                ## L:55   |     33 | asm_op("lfv", px_b, 0,	0, dmem_in);
  lfv $v25, 8, 16, $s3                               ## L:56   |     34 | asm_op("lfv", px_b, 8, 16, dmem_in);
  addiu $s3, $s3, 30                                 ## L:57   |     35 | dmem_in += 32 - 2;
  vmudh $v26, $v26, $v30.e4                          ## L:60   |      ^ | px_g:sint *= (1 << (8 - 5));
  vand $v27, $v27, $v28.e0                           ## L:66   |     36 | px_r &= VCONST_RGB.x;
  lfv $v24, 0, 0, $s3                                ## L:47   |      ^ | asm_op("lfv", px_r, 0,	0, dmem_in);
  lfv $v24, 8, 16, $s3                               ## L:48   |     37 | asm_op("lfv", px_r, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:49   |     38 | dmem_in += 1;
  vmudh $v25, $v25, $v30.e4                          ## L:61   |      ^ | px_b:sint *= (1 << (8 - 5));
  vand $v26, $v26, $v28.e0                           ## L:65   |     39 | px_g &= VCONST_RGB.x;
  lfv $v23, 0, 0, $s3                                ## L:51   |      ^ | asm_op("lfv", px_g, 0,	0, dmem_in);
  lfv $v23, 8, 16, $s3                               ## L:52   |     40 | asm_op("lfv", px_g, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:53   |     41 | dmem_in += 1;
  vmudn $v12, $v27, $v30.e6                          ## L:68   |      ^ | px_out =	px_r:uint * 2;
  vmadl $v12, $v26, $v31.e3                          ## L:69   |    *43 | asm_op("vmadl", px_out, px_g, VSHIFT8.w);
  lfv $v22, 0, 0, $s3                                ## L:55   |      ^ | asm_op("lfv", px_b, 0,	0, dmem_in);
  vmadl $v12, $v25, $v30.e0                          ## L:70   |     44 | asm_op("vmadl", px_out, px_b, VSHIFT.x);
  lfv $v22, 8, 16, $s3                               ## L:56   |      ^ | asm_op("lfv", px_b, 8, 16, dmem_in);
  vmudh $v24, $v24, $v30.e4                          ## L:59   |     45 | px_r:sint *= (1 << (8 - 5));
  vmudh $v23, $v23, $v30.e4                          ## L:60   |     46 | px_g:sint *= (1 << (8 - 5));
  addiu $s3, $s3, 30                                 ## L:57   |      ^ | dmem_in += 32 - 2;
  lfv $v21, 0, 0, $s3                                ## L:47   |     47 | asm_op("lfv", px_r, 0,	0, dmem_in);
  lfv $v21, 8, 16, $s3                               ## L:48   |     48 | asm_op("lfv", px_r, 8, 16, dmem_in);
  vmudh $v22, $v22, $v30.e4                          ## L:61   |      ^ | px_b:sint *= (1 << (8 - 5));
  addiu $s3, $s3, 1                                  ## L:49   |     49 | dmem_in += 1;
  vand $v24, $v24, $v28.e0                           ## L:66   |      ^ | px_r &= VCONST_RGB.x;
  lfv $v20, 0, 0, $s3                                ## L:51   |     50 | asm_op("lfv", px_g, 0,	0, dmem_in);
  vand $v23, $v23, $v28.e0                           ## L:65   |      ^ | px_g &= VCONST_RGB.x;
  lfv $v20, 8, 16, $s3                               ## L:52   |     51 | asm_op("lfv", px_g, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:53   |     52 | dmem_in += 1;
  lfv $v19, 0, 0, $s3                                ## L:55   |     53 | asm_op("lfv", px_b, 0,	0, dmem_in);
  vmudn $v11, $v24, $v30.e6                          ## L:68   |      ^ | px_out =	px_r:uint * 2;
  sqv $v12, 0, 0, $s0                                ## L:119  |     54 | store(px_out0, dmem_out, 0);
  vmadl $v11, $v23, $v31.e3                          ## L:69   |      ^ | asm_op("vmadl", px_out, px_g, VSHIFT8.w);
  vmadl $v11, $v22, $v30.e0                          ## L:70   |     55 | asm_op("vmadl", px_out, px_b, VSHIFT.x);
  lfv $v19, 8, 16, $s3                               ## L:56   |      ^ | asm_op("lfv", px_b, 8, 16, dmem_in);
  vmudh $v21, $v21, $v30.e4                          ## L:59   |     56 | px_r:sint *= (1 << (8 - 5));
  addiu $s3, $s3, 30                                 ## L:57   |      ^ | dmem_in += 32 - 2;
  lfv $v18, 0, 0, $s3                                ## L:47   |     57 | asm_op("lfv", px_r, 0,	0, dmem_in);
  vmudh $v20, $v20, $v30.e4                          ## L:60   |      ^ | px_g:sint *= (1 << (8 - 5));
  vmudh $v19, $v19, $v30.e4                          ## L:61   |    *59 | px_b:sint *= (1 << (8 - 5));
  lfv $v18, 8, 16, $s3                               ## L:48   |      ^ | asm_op("lfv", px_r, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:49   |     60 | dmem_in += 1;
  vand $v21, $v21, $v28.e0                           ## L:66   |      ^ | px_r &= VCONST_RGB.x;
  vand $v20, $v20, $v28.e0                           ## L:65   |     61 | px_g &= VCONST_RGB.x;
  lfv $v17, 0, 0, $s3                                ## L:51   |      ^ | asm_op("lfv", px_g, 0,	0, dmem_in);
  lfv $v17, 8, 16, $s3                               ## L:52   |     62 | asm_op("lfv", px_g, 8, 16, dmem_in);
  addiu $s3, $s3, 1                                  ## L:53   |     63 | dmem_in += 1;
  lfv $v16, 0, 0, $s3                                ## L:55   |     64 | asm_op("lfv", px_b, 0,	0, dmem_in);
  vmudn $v10, $v21, $v30.e6                          ## L:68   |      ^ | px_out =	px_r:uint * 2;
  vmadl $v10, $v20, $v31.e3                          ## L:69   |     65 | asm_op("vmadl", px_out, px_g, VSHIFT8.w);
  lfv $v16, 8, 16, $s3                               ## L:56   |      ^ | asm_op("lfv", px_b, 8, 16, dmem_in);
  vmadl $v10, $v19, $v30.e0                          ## L:70   |     66 | asm_op("vmadl", px_out, px_b, VSHIFT.x);
  addiu $s3, $s3, 30                                 ## L:57   |      ^ | dmem_in += 32 - 2;
  lfv $v15, 0, 0, $s3                                ## L:47   |     67 | asm_op("lfv", px_r, 0,	0, dmem_in);
  vmudh $v18, $v18, $v30.e4                          ## L:59   |      ^ | px_r:sint *= (1 << (8 - 5));
  lfv $v15, 8, 16, $s3                               ## L:48   |     68 | asm_op("lfv", px_r, 8, 16, dmem_in);
  vmudh $v17, $v17, $v30.e4                          ## L:60   |      ^ | px_g:sint *= (1 << (8 - 5));
  addiu $s3, $s3, 1                                  ## L:49   |     69 | dmem_in += 1;
  lfv $v14, 0, 0, $s3                                ## L:51   |    *71 | asm_op("lfv", px_g, 0,	0, dmem_in);
  vand $v18, $v18, $v28.e0                           ## L:66   |      ^ | px_r &= VCONST_RGB.x;
  lfv $v14, 8, 16, $s3                               ## L:52   |     72 | asm_op("lfv", px_g, 8, 16, dmem_in);
  vand $v17, $v17, $v28.e0                           ## L:65   |      ^ | px_g &= VCONST_RGB.x;
  vmudh $v16, $v16, $v30.e4                          ## L:61   |     73 | px_b:sint *= (1 << (8 - 5));
  vmudn $v09, $v18, $v30.e6                          ## L:68   |    *75 | px_out =	px_r:uint * 2;
  sqv $v10, 0, 32, $s0                               ## L:121  |      ^ | store(px_out2, dmem_out, 32);
  vmadl $v09, $v17, $v31.e3                          ## L:69   |     76 | asm_op("vmadl", px_out, px_g, VSHIFT8.w);
  vmadl $v09, $v16, $v30.e0                          ## L:70   |     77 | asm_op("vmadl", px_out, px_b, VSHIFT.x);
  addiu $s3, $s3, 1                                  ## L:53   |      ^ | dmem_in += 1;
  vmudh $v15, $v15, $v30.e4                          ## L:59   |     78 | px_r:sint *= (1 << (8 - 5));
  lfv $v13, 0, 0, $s3                                ## L:55   |      ^ | asm_op("lfv", px_b, 0,	0, dmem_in);
  vmudh $v14, $v14, $v30.e4                          ## L:60   |     79 | px_g:sint *= (1 << (8 - 5));
  lfv $v13, 8, 16, $s3                               ## L:56   |      ^ | asm_op("lfv", px_b, 8, 16, dmem_in);
  vand $v15, $v15, $v28.e0                           ## L:66   |   **82 | px_r &= VCONST_RGB.x;
  vand $v14, $v14, $v28.e0                           ## L:65   |     83 | px_g &= VCONST_RGB.x;
  addiu $s3, $s3, 30                                 ## L:57   |      ^ | dmem_in += 32 - 2;
  vmudh $v13, $v13, $v30.e4                          ## L:61   |     84 | px_b:sint *= (1 << (8 - 5));
  sqv $v09, 0, 48, $s0                               ## L:122  |      ^ | store(px_out3, dmem_out, 48);
  vmudn $v08, $v15, $v30.e6                          ## L:68   |    *86 | px_out =	px_r:uint * 2;
  sqv $v11, 0, 16, $s0                               ## L:120  |      ^ | store(px_out1, dmem_out, 16);
  vmadl $v08, $v14, $v31.e3                          ## L:69   |     87 | asm_op("vmadl", px_out, px_g, VSHIFT8.w);
  vmadl $v08, $v13, $v30.e0                          ## L:70   |     88 | asm_op("vmadl", px_out, px_b, VSHIFT.x);
  sqv $v08, 0, 64, $s0                               ## L:123  |  ***92 | store(px_out4, dmem_out, 64);
  bne $s3, $s1, LABEL_RGBA8888_TO_5551_0009          ## L:125  |     93 | dmem_out += 80;
  addiu $s0, $s0, 80                                 ## L:125  |    *95 | dmem_out += 80;
  LABEL_RGBA8888_TO_5551_000A:
  mtc0 $s6, COP0_DMA_SPADDR                          ## L:28   |     96 | @Barrier("DMA") set_dma_addr_rsp(addrDMEM); ## Barrier: 0x1
  mtc0 $a1, COP0_DMA_RAMADDR                         ## L:29   |     97 | @Barrier("DMA") set_dma_addr_rdram(addrRDRAM); ## Barrier: 0x1
  addiu $a1, $a1, 640                                ## L:129  |     98 | ptr_out += (320 * 2);
  bne $s3, $s2, LABEL_RGBA8888_TO_5551_0007          ## L:129  |     99 | ptr_out += (320 * 2);
  mtc0 $s4, COP0_DMA_WRITE                           ## L:30   |   *101 | @Barrier("DMA") set_dma_write(size); ## Barrier: 0x1
  LABEL_RGBA8888_TO_5551_0006:
  bne $a0, $s7, LABEL_RGBA8888_TO_5551_0003          ## L:129  |    102 | ptr_out += (320 * 2);
  nop                                                ## L:129  |   *104 | ptr_out += (320 * 2);
  LABEL_RGBA8888_TO_5551_000B:
  mfc0 $ra, COP0_DMA_BUSY                            ## L:36   |    105 | RA = get_dma_busy();
  bne $ra, $zero, LABEL_RGBA8888_TO_5551_000B        ## L:36   |  **108 | RA = get_dma_busy();
  nop                                                ## L:36   |   *110 | RA = get_dma_busy();
  LABEL_RGBA8888_TO_5551_000C:
  j RSPQ_Loop                                        ## L:37   |    111 | 
  nop                                                ## L:37   |   *113 | 

OVERLAY_CODE_END:

#define zero $0
#define v0 $2
#define v1 $3
#define a0 $4
#define a1 $5
#define a2 $6
#define a3 $7
#define t0 $8
#define t1 $9
#define t2 $10
#define t3 $11
#define t4 $12
#define t5 $13
#define t6 $14
#define t7 $15
#define s0 $16
#define s1 $17
#define s2 $18
#define s3 $19
#define s4 $20
#define s5 $21
#define s6 $22
#define s7 $23
#define t8 $24
#define t9 $25
#define k0 $26
#define k1 $27
#define gp $28
#define sp $29
#define fp $30
#define ra $31

.set at
.set macro