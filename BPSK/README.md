# BPSK Signal Generator in Verilog (DDS + LFSR)

## Overview

This project implements a **BPSK (Binary Phase Shift Keying) signal generator** using **Verilog HDL**.
The design combines three fundamental digital communication blocks:

1. **DDS Sine Wave Generator** – generates the carrier signal
2. **LFSR Binary Data Generator** – generates pseudo-random binary data
3. **BPSK Modulator** – performs phase inversion of the carrier based on data

The system operates with a **40.92 MHz system clock** and produces:

* **Carrier frequency:** 4.092 MHz
* **Binary data rate:** 1.023 MHz

This frequency relationship is commonly used in **spread spectrum and GNSS-style signal generation systems**.

---

## System Block Diagram

```text
                40.92 MHz System Clock
                        │
                        ▼
               +----------------+
               |  Clock Divider |
               |   (÷40)        |
               | 1.023 MHz      |
               +----------------+
                        │
                        ▼
               +----------------+
               |  LFSR Binary   |
               | Data Generator |
               | (PRBS Source)  |
               +----------------+
                        │
                        ▼
DDS Carrier ─────────► BPSK Modulator ─────────► BPSK Output
 (4.092 MHz)            (Phase Flip)
```

---

# Clocking Strategy

The design uses **three related frequencies derived from a single system clock**.

| Signal       | Frequency     | Purpose                 |
| ------------ | ------------- | ----------------------- |
| System Clock | **40.92 MHz** | Main FPGA clock         |
| Carrier      | **4.092 MHz** | DDS generated sine wave |
| Binary Data  | **1.023 MHz** | LFSR data rate          |

These frequencies have a fixed ratio:

```text
40.92 MHz : 4.092 MHz : 1.023 MHz
      10 : 1 : 0.25
```

This ensures the **carrier contains multiple samples per data bit**, producing a clean BPSK waveform.

---

# Clock Divider (clk_div_40)

The module `clk_div_40` generates a **1.023 MHz enable pulse** from the **40.92 MHz system clock**.

## Why it is needed

The LFSR should **not update every clock cycle**, otherwise the data would change too fast and distort the BPSK waveform.
Instead, the LFSR updates at a **controlled symbol rate** of **1.023 MHz**.

## Divider Principle

The divider counts **40 clock cycles**:

```text
40.92 MHz / 40 = 1.023 MHz
```

A counter runs from **0 to 39** and produces a **single-cycle enable pulse** when the counter resets.

```verilog
if (count == 6'd39)
    count <= 0;
else
    count <= count + 1;

clk_1p023 <= (count == 0);
```

This signal acts as a **symbol clock enable** for the LFSR.

---

# Binary Data Generator (LFSR)

The module `binary_data` implements a **10-bit Linear Feedback Shift Register (LFSR)**.

Feedback polynomial:

```text
x^10 + x^3 + 1
```

Implementation:

```verilog
feed_back = register[0] ^ register[7];
```

Operation:

* Updates **only when enable = 1**
* Produces a **pseudo-random binary sequence**
* Output bit: `register[0]`

The enable input ensures the **data rate is 1.023 MHz**.

---

# DDS Sine Wave Generator

The module `dds_sine_wave` implements a **Direct Digital Synthesizer (DDS)**.

## Architecture

```text
FCW → Phase Accumulator → LUT Address → Sine LUT → Output
```

Key components:

* **32-bit phase accumulator**
* **256-point sine lookup table**
* **Q1.15 fixed-point output**

## Frequency Formula

DDS output frequency:

```text
Fout = (FCW × Fclk) / 2^32
```

For this design:

```text
Fclk = 40.92 MHz
Fout = 4.092 MHz
```

Calculated FCW:

```text
FCW ≈ 429496730
```

This value is used in the design:

```verilog
fcw = 32'd429496730
```

---

# BPSK Modulator

BPSK encodes binary data by **changing the phase of the carrier**.

| Binary Bit | Output   |
| ---------- | -------- |
| 0          | +sin(ωt) |
| 1          | −sin(ωt) |

Implementation:

```verilog
if(binary_in)
    bpsk_out <= -sine_in;
else
    bpsk_out <= sine_in;
```

This produces a **180° phase shift** when the data bit is `1`.

---

# Resulting Signal

The final output is a **BPSK-modulated carrier**:

```text
Binary Data:  0 0 0 0 | 1 1 1 1 | 0 0 0 0

Carrier:      /\/\ /\/\ /\/\ /\/\

BPSK Output:  /\/\ /\/\ /\/\ | \/\/ \/\/ \/\/
```

Each data bit controls the **phase of several carrier cycles**, resulting in a clean modulation waveform.

---

# Testbench

The testbench generates the system clock:

```verilog
always #12.21896 clk = ~clk; // 40.92 MHz
```

Reset is asserted for one clock cycle before normal operation.

---

# Key Features

* Single clock domain (40.92 MHz)
* DDS carrier generation
* LFSR pseudo-random binary data
* Clock-enable based symbol rate control
* Hardware-efficient BPSK phase inversion
* Fully synthesizable Verilog design

---

# Possible Extensions

* QPSK modulation
* PN / Gold code generators
* BPSK demodulator
* BER measurement
* AWGN channel modeling

  
---

## Author

**Chandra Sekhar Tanuku**
---
* B.Tech Electronics and Communication Engineering
* Focus Areas: **VLSI Design, FPGA, Digital Communication Systems**

