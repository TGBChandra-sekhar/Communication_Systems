# DDS Sine Wave Generator (Verilog)

## Overview

This project implements a **Direct Digital Synthesizer (DDS)** based sine wave generator using **Verilog HDL**.
The design uses a **32-bit phase accumulator** and a **256-point sine lookup table (LUT)** to generate a digital sine waveform.

DDS is widely used in:

* Software Defined Radio (SDR)
* GNSS signal generation
* Digital communication systems
* Radar waveform synthesis

---

## DDS Architecture

```
            +------------------+
FCW ------->| Phase Accumulator|------+
            +------------------+      |
                                      v
                                +-----------+
                                |  Sine LUT |
                                | (256 pt)  |
                                +-----------+
                                      |
                                      v
                                  sine_out
```

### Components

1. **Phase Accumulator (32-bit)**
   Accumulates the frequency control word (FCW) every clock cycle.

2. **LUT Address**
   The **8 MSBs** of the phase accumulator are used as the address for the sine lookup table.

3. **Sine Lookup Table (256 points)**
   Stores precomputed sine values in **Q1.15 fixed-point format**.

---

## DDS Frequency Equation

The output frequency of the DDS is given by:

```
Fout = (FCW × Fclk) / 2^N
```

Where:

* `Fout` = Output sine wave frequency
* `FCW`  = Frequency Control Word
* `Fclk` = System clock frequency
* `N`    = Phase accumulator width (32 bits in this design)

---

## FCW Calculation

To generate a desired output frequency:

```
FCW = (Fout × 2^N) / Fclk
```

For this design:

```
N = 32
2^32 = 4294967296
```

---

## Example Calculation

Assume:

```
System Clock (Fclk) = 40.92 MHz
Desired Output (Fout) = 4.092 MHz
```

FCW:

```
FCW = (4.092e6 × 2^32) / 40.92e6
FCW = 429496730 ≈ 32'd429496730
```

---

## Example Table

| Clock Frequency | Desired Output | FCW       |
| --------------- | -------------- | --------- |
| 100 MHz         | 1 MHz          | 42949673  |
| 100 MHz         | 5 MHz          | 214748364 |
| 100 MHz         | 10 MHz         | 429496729 |

---

## LUT Details

* LUT Size: **256 entries**
* Data Format: **Q1.15 fixed-point**
* Output Range:

```
+32767  →  +1.0
-32768  →  -1.0
```

Example values:

```
0000
0324
0647
096A
0C8B
...
```

The LUT is initialized using:

```verilog
$readmemh("sine_lut.hex", sine_lut);
```

---

## Verilog Implementation

Main modules:

```
 dds_sine_wave.v
```

LUT file:

```
 sine_lut.hex
```

Testbench:

```
tb_dds_sine_wave.v
```

---

## Simulation Output

The DDS produces a **digitally synthesized sine waveform**.

```
sine_out

 32767 |      /\        /\        /\
       |     /  \      /  \      /  \
       |    /    \    /    \    /    \
     0 |---/------\--/------\--/------\----
       |  /        \/        \/        \
-32768 |
```

---

## Key Features

* Fully **synthesizable Verilog RTL**
* **32-bit frequency resolution**
* **256-point sine LUT**
* FPGA friendly architecture
* Suitable for **digital communication systems**

---

## Future Improvements

Possible extensions of this project:

* Quarter-wave LUT optimization
* Phase dithering to reduce spurs
* CORDIC based sine generator
* BPSK / QPSK modulation using DDS carrier
* Higher resolution LUT (1024 / 4096 points)

---

## Author

**Chandra Sekhar Tanuku**
---
B.Tech Electronics and Communication Engineering
Focus Areas: **VLSI Design, FPGA, Digital Communication Systems**
