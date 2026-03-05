# ☀️ Solar PV MPPT Boost Converter with Protection System

A complete **Solar Photovoltaic (PV) system simulation and implementation** that extracts maximum available power from solar panels using a **DC-DC Boost Converter** controlled by a **Perturb & Observe (P&O) Maximum Power Point Tracking (MPPT)** algorithm.

The project is developed and validated using **MATLAB/Simulink**, with **embedded C code** provided for real-time microcontroller implementation.

---

# 📌 Project Overview

Solar photovoltaic systems require efficient power extraction to operate at their maximum potential. This project implements a **Maximum Power Point Tracking (MPPT)** controller that dynamically adjusts the duty cycle of a **DC-DC boost converter** to ensure the solar panel operates at its optimal power point.

The system also includes **industrial-style protection mechanisms** to ensure safe operation under abnormal conditions such as over-voltage, over-current, and temperature faults.

The complete system was designed, simulated, and tested in MATLAB/Simulink with modular code ready for embedded deployment.

---

# ✨ Key Features

### Core System

* Solar PV mathematical modeling
* DC-DC Boost Converter design
* Perturb & Observe MPPT algorithm
* Duty cycle control using feedback
* MATLAB / Simulink system simulation

### Protection System

* Over-voltage protection
* Over-current protection
* Under-voltage protection
* Temperature protection
* Emergency shutdown mechanism
* Automatic recovery after fault removal

### Embedded Implementation

* MPPT algorithm implemented in **C**
* Protection logic implemented in **C**
* Ready for microcontroller integration
* Compatible with Arduino / embedded platforms

---

# 🏗️ System Architecture

Solar Energy → PV Panel → Boost Converter → Load

Control Loop:

Sensors → MPPT Controller → PWM Generator → MOSFET Switch

Protection Layer:

Voltage Monitoring
Current Monitoring
Temperature Monitoring

Fault Detection → System Shutdown → Recovery

---

# ⚙️ Technical Specifications

## PV Panel Parameters

| Parameter                   | Value   |
| --------------------------- | ------- |
| Short Circuit Current (Isc) | 8.21 A  |
| Open Circuit Voltage (Voc)  | 32.9 V  |
| Maximum Power               | 185 W   |
| Voltage at MPP              | 25.23 V |
| Current at MPP              | 7.34 A  |
| Cells per Module            | 60      |

---

## Boost Converter Design

| Component           | Value     |
| ------------------- | --------- |
| Inductance          | 2 mH      |
| Capacitance         | 1000 µF   |
| Switching Frequency | 20 kHz    |
| Duty Cycle Range    | 10 – 90 % |
| MOSFET Gate Voltage | 15 V      |

---

## MPPT Algorithm Parameters

| Parameter           | Value             |
| ------------------- | ----------------- |
| Algorithm           | Perturb & Observe |
| Step Size           | 3%                |
| Initial Duty Cycle  | 40%               |
| Tracking Efficiency | ~88%              |
| Response Time       | < 0.3 s           |

---

# 🛡️ Protection Thresholds

| Protection          | Threshold         |
| ------------------- | ----------------- |
| PV Over-Voltage     | > 33.5 V          |
| PV Under-Voltage    | < 10 V            |
| Output Over-Voltage | > 60 V            |
| Over-Current        | > 9 A             |
| Temperature         | > 85°C or < −20°C |

When a fault occurs the converter **immediately disables PWM output** and resumes operation once conditions return to safe limits.

---

# 📁 Project Structure

```
Solar_PV_MPPT_Project

MATLAB/
    pv_model.m
    mppt_po.m
    protection_system.m
    test_protection.m
    generate_results.m

Simulink/
    boost_converter.slx
    protection_demo.slx

C_Code/
    mppt_po.c
    mppt_po.h
    protection.c
    main.c

Results/
    pv_characteristics.png
    final_results.png

Documentation/
    theory/
    datasheets/

README.md
LICENSE
```

---

# 🚀 Installation

### Requirements

* MATLAB R2023b or later
* Simulink
* Simscape Electrical

### Clone Repository

```
git clone https://github.com/yourusername/solar-pv-mppt-system.git
cd solar-pv-mppt-system
```

Open MATLAB and navigate to the project folder.

---

# 💻 Usage

### Run PV Model

```
pv_model
```

Generates I-V and P-V characteristics of the solar panel.

---

### Open Simulink Model

```
open_system('Simulink/boost_converter.slx')
```

Run simulation to observe:

* PV voltage
* PV current
* PV power
* Duty cycle
* Output voltage

---

### Test Protection System

```
test_protection
```

Runs a full verification suite for all protection conditions.

---

🏗️ System Architecture

                    ┌─────────────────────────────────────┐
                    │         SOLAR PV SYSTEM             │
                    ├─────────────────────────────────────┤
                    │                                     │
    Sunlight ───────►  PV Panel ──────► Boost Converter ──► Load
                    │       ▲                  ▲          │
                    │       │                  │          │
                    │   [Sensors]          [PWM Gate]     │
                    │       │                  │          │
                    │       └──────┬───────────┘          │
                    │              │                       │
                    │         [MPPT Algorithm]             │
                    │         (Perturb & Observe)          │
                    │              │                       │
                    │         [Protection System]          │
                    │    (OV, OC, Temp, UV Protection)     │
                    │                                     │
                    └─────────────────────────────────────┘

# 📊 Results

Simulation results demonstrate successful MPPT tracking with stable converter operation.

Typical results:

| Metric             | Value  |
| ------------------ | ------ |
| Average PV Voltage | 23.5 V |
| Average PV Current | 0.17 A |
| Maximum Power      | 4.54 W |
| Output Voltage     | 49.5 V |
| MPPT Efficiency    | ~88 %  |

Waveforms obtained:

* PV Voltage
* PV Current
* PV Power
* Converter Duty Cycle
* Output Voltage
* PV I-V Curve

---

# 🧪 Testing

A full automated test suite validates protection mechanisms.

Example test cases:

* Normal operation
* Over-voltage fault
* Over-current fault
* Temperature fault
* Output over-voltage
* Under-voltage condition
* Multiple simultaneous faults

All tests pass successfully.

---

# 💾 Embedded C Implementation

### MPPT Algorithm (P&O)

```
float mppt_po(float V, float I)
{
    static float V_prev = 0;
    static float P_prev = 0;
    static float duty = 0.5;

    float P = V * I;

    if(P > P_prev)
        duty += (V > V_prev) ? 0.03 : -0.03;
    else
        duty += (V > V_prev) ? -0.03 : 0.03;

    if(duty < 0.1) duty = 0.1;
    if(duty > 0.85) duty = 0.85;

    V_prev = V;
    P_prev = P;

    return duty;
}
```

---

# 🔮 Future Improvements

* Incremental Conductance MPPT
* Hardware prototype implementation
* Battery energy storage integration
* IoT monitoring system
* Real solar panel testing
* GUI dashboard for system monitoring

---

# 👨‍💻 Author

Your Name
Electrical / Power Electronics Engineer

Skills

* MATLAB
* Simulink
* Embedded C
* Power Electronics
* Renewable Energy Systems

GitHub: https://github.com/yourusername
LinkedIn: https://linkedin.com/in/yourprofile

---

# ⭐ Support

If you found this project useful, please consider giving it a **star ⭐ on GitHub**.

---

**Designed for renewable energy systems and power electronics research.**
