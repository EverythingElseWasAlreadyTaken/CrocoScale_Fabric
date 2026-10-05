# CrocoScale fabric functional tests

Every IO BEL of the fabric has a functional test that runs the real flow:
synthesize a user design onto the fabric, place and route it, generate the
bitstream, load that bitstream into the fabric RTL through the configuration
port and simulate it. The testbench drives the BEL's SoC-side pins on
`eFPGA_top` and compares every SoC-side output against a reference model.
A passing test therefore covers the tile wiring, the supertile matrices, the
switch-matrix config bits and the BEL config bits, not just the BEL RTL.

## The tests

| Test (`DESIGN`) | BEL(s) | Config bits under test | What is checked |
|---|---|---|---|
| `axi_m_loopback` | AXI_M (west, rows 1..10) | `TIE_OFF_WSTRB`, `TIE_OFF_ARSIZE`, `TIE_OFF_AWCACHE` | all 142 SoC outputs from 42 SoC inputs (combinational) |
| `axil_s_loopback` | AXIL_S (west, rows 11..16) | none | all 41 SoC outputs from 67 SoC inputs (combinational) |
| `soc_debug_loopback` | SOC_DEBUG x4 (south, cols 1..4) | per instance: none, inversion, bypass, all | `DEBUG_IN`, `USR_IRQ` every cycle (registers, bypass paths) |
| `ext_pmod_reg` | EXT_PMOD (north, cols 1..2) | none | `PMOD_IO_O`, `PMOD_IO_OE_O` every cycle |
| `ext_pmod_bypass` | EXT_PMOD | both bypasses, static OE, open drain | as above, plus combinational paths |
| `ext_pmod_loop` | EXT_PMOD (+ AXIL_S as stimulus) | loopback | as above, pads must be ignored |
| `npu_ctrl_skew_off` | NPU_CTRL_CFG (north, cols 3..4) (+ AXIL_S) | none | all 37 NPU outputs, one cycle later |
| `npu_ctrl_skew_on` | NPU_CTRL_CFG (+ AXIL_S) | `TIE_OFF_SKEW_EN` | as above, skew clamped to 1 |
| `npu_accum_loopback` | NPU_ACCUM banks A and B (north/south, cols 5..9) | bank B `WRITE_LOCK=8'h5A` | `NPU_ADDR/WE/WDATA/READ_BANK_SEL`, two register stages |
| `npu_slice_loopback` | NPU_SLICE x8 (east, rows 1..16) | a different combination per slice | all slice outputs, two register stages |
| `full_io` | all 18 IO BELs at once | EXT_PMOD bypass, NPU_CTRL skew on, the rest as above | every IO output of `eFPGA_top`; routing with all IO pins in use |

`sequential_16bit_en_tb.v` is the original FABulous demo testbench. It uses
the old user-IO tiles (`I_top`, `O_top`, ...), which no longer exist in this
fabric, so it does not build any more.

## Running a test

Prerequisites:

- Yosys, nextpnr-generic and Icarus Verilog on `PATH` (e.g. the OSS CAD Suite).
- `bit_gen` from the **FABulous-OWAS** environment on `PATH`, because the
  fabric configures its border rows (`IncludeBorderRows`); e.g.
  `export PATH=<FABulous-OWAS>/.venv/bin:$PATH`.
- The generated fabric in `Fabric/` and `.FABulous/`. It is committed, so a
  fresh checkout can run the tests directly. When regenerating it (after
  changing a tile, or via `FABulous.tcl`), the FABulous version used must
  support config bits in the border rows and have them enabled
  (`IncludeBorderRows`, enabled automatically when a top or bottom-row tile
  has config bits). Without that, FABulous still reports success but the top
  wrapper has no frame registers for the border rows, so their tiles cannot
  be configured and every test fails.

All commands run in this directory. `build-test-design` synthesizes, places
and routes the design and writes the bitstream to `build/<DESIGN>.bin`/`.hex`;
`run-simulation` loads the bitstream into the fabric RTL and runs the
testbench; `clean` removes `build/`.

### The combined test (default)

`full_io` is the Taskfile default:

```sh
task build-test-design run-simulation
task clean
```

which is the same as `DESIGN=full_io TOP_WRAPPER=full_io_top`. `task` on its
own (alias of `fab-sim`) additionally regenerates the fabric first (see the
note on border-row config bits above) and cleans up afterwards. A pass ends with

```
296 cycles x 36 output groups checked twice, 0 failing cycles, 0 mismatches
TEST PASSED
```

and exit code 0. A failure prints up to 30 lines of the form
`MISMATCH cycle N: <group> got <value> expected <value> (diff <xor>)`, then
stops with `$fatal` and a non-zero exit code; the group names the BEL and pin
(e.g. `NPU_SLICE XBAR_SEL`) and the diff shows which bits are wrong.

### A single test

Each test is a user design `user_design/<DESIGN>.v`, a top wrapper
`user_design/<DESIGN>_top.v` and a testbench `Test/<DESIGN>_tb.v`:

```sh
task build-test-design run-simulation DESIGN=axi_m_loopback TOP_WRAPPER=axi_m_loopback_top
task clean
```

`build-test-design` synthesizes, places and routes the design and writes the
bitstream to `build/<DESIGN>.bin`/`.hex`; `run-simulation` compiles the fabric
RTL with the testbench and runs it. A passing test ends with `TEST PASSED` and
exit code 0; a failing one prints the mismatches and stops with `$fatal`
(non-zero exit). All tests in a row:

```sh
for d in axi_m_loopback axil_s_loopback soc_debug_loopback ext_pmod_reg ext_pmod_bypass \
         ext_pmod_loop npu_ctrl_skew_off npu_ctrl_skew_on npu_accum_loopback \
         npu_slice_loopback full_io; do
    task build-test-design run-simulation DESIGN=$d TOP_WRAPPER=${d}_top > build_$d.log 2>&1 \
        && echo "$d passed" || echo "$d FAILED (see build_$d.log)"
done
task clean
```

The single tests take a minute or two each; `full_io` takes longer.

## How a test works

After changing a tile, run `run_fab` and then the tests. Each test follows
the same pattern:

- **Loopback through the fabric.** The fabric logic (`<DESIGN>.v`) feeds the
  BEL's fabric-side outputs back into its fabric-side inputs, giving every
  input a *distinct* function of the outputs (rotations, XORs, `a ^ (b & c)`).
  A swapped or misrouted pin therefore changes some result. Design and
  testbench use the same mapping, so keep them in sync when changing one.
- **BEL placement and config.** The top wrapper (`<DESIGN>_top.v`) pins each
  BEL with `(* keep, BEL="X<x>Y<y>.A" *)` at its master tile and sets the
  config bits under test as BEL parameters.
- **Reference model.** The testbench loads the bitstream, then drives random
  values on the SoC-side inputs every cycle (on the falling clock edge) and
  checks the SoC-side outputs just before the next change and again right
  after it, so both registered and combinational (bypass) paths are covered.
  BELs with registers get a cycle-accurate model; the first few cycles fill
  uninitialised registers and are not checked.
- **Stimulus from AXIL_S.** BELs without fabric-side outputs (NPU_CTRL_CFG)
  and the EXT_PMOD loopback mode need an input into the fabric that the
  testbench controls. Fabric flip-flops start as X in RTL simulation, so a
  self-contained counter or loop would stay X; these tests take the fabric
  inputs from the AXIL_S BEL, whose SoC-side inputs reach the fabric
  unregistered.
- **One bitstream per config** for BELs that exist once (EXT_PMOD,
  NPU_CTRL_CFG); BELs with several instances test one config per instance.

Every test was mutation-tested when it was written: one config bit and one
loopback function were broken on purpose, and the test had to fail on exactly
those bits with a non-zero exit. Do the same after changing a test.

## Things to know

- **Shared buses.** Several instances of a BEL share one `eFPGA_top` bus per
  pin, ordered x ascending, then y descending: NPU_ACCUM bank B (south) is
  slice 0 and bank A slice 1; NPU_SLICE slice 0 of the bus is the bottom
  instance, so README slice `[s]` is bus slice `7-s`. SOC_DEBUG instance `k`
  (column `k+1`) is slice `k`.
- **`MAX_BITBYTES`.** The bitstream is about 18 KB because the border rows
  carry configuration frames. `MAX_BITBYTES` (32768) must be the same in
  `Taskfile.yml`, `Makefile` and every testbench's `localparam`; `makehex.py`
  aborts with an `AssertionError` when the bitstream outgrows it.
- **Two files per design.** The Taskfile's synthesis reads both
  `<DESIGN>.v` and `<TOP_WRAPPER>.v`, so they must be different files.
- **Mismatch output.** `full_io` prints the group, the actual and expected
  value and their XOR, so one wrong bit is easy to tell from a broken bus.

## Simulating with Vivado xsim

`task run-simulation SIMULATOR=xvlog` runs the same testbench under AMD
Vivado's xsim. It needs `xvlog`, `xelab` and `xsim` on `PATH` from a Vivado
installation; nothing else in the flow changes.

The value of the xsim path is the analysis mode, not the simulator. xvlog reads
the fabric and the user design as IEEE 1364-2005 Verilog, whereas the Icarus
flow uses `iverilog -g2012`, so constructs that are legal only in
SystemVerilog fail here and pass there. The testbench is exempt and compiles
with `-sv`, because it uses `$fatal` and an unsized array bound.

Two behaviours are worth knowing. xsim writes VCD and has no FST writer, so
`WAVEFORM_TYPE` does not apply and the waveform lands at
`build/<design>_xsim.vcd`. And xsim exits 0 even after `$fatal`, so the task
greps its log for a fatal report and fails on that instead of trusting the exit
status.

If `xelab` stops at `cannot find crt1.o`, its linker is not picking up the host
C runtime; point it at the directory holding those objects, for example
`LIBRARY_PATH=/usr/lib/x86_64-linux-gnu task run-simulation SIMULATOR=xvlog`.
