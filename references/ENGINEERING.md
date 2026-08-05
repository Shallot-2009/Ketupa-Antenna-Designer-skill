# Engineering and Validation Boundary

## Deterministic synthesis

The engine uses closed-form rectangular-patch and microstrip models, iterative resonance back-checking, continuous Hammerstad-Jensen impedance evaluation, feed-specific geometry, and optional result-driven length calibration.

## 1,000,000-case regression

The reproducible run used seed `20260805` and covered:

- 0.3 to 30 GHz, log-uniform.
- Relative permittivity 1.5 to 12.
- Electrically scaled substrate thickness, bounded from 0.03 to 5 mm.
- Probe, inset and edge feed.
- ABC, PML and FEBI selections.
- Alternating Chinese and English input.
- Compact and standard-size requests.
- Resonance back-check, 50-ohm line back-check, VBS argument contracts and sampled static generation of all three backends.

Result:

- Executed: 1,000,000.
- Passed: 1,000,000.
- Failed: 0.
- Maximum analytical resonance back-check error: `1.0036416142611415e-07 ppm`.
- Maximum 50-ohm back-check error: `9.999965300266922e-10 ohm`.

See `validation_summary_1000000.json` for the machine-readable record.

## Real AEDT backend validation

Windows AEDT 2026.1 was used to build and solve representative 2.4 GHz projects:

- VBS: probe and inset feed.
- Native AEDT COM Python: probe and inset feed.
- PyAEDT (`ansys-aedt-core 1.3.0`): probe and edge feed.

All recorded cases retained a non-empty excitation list, exposed Local Variables, saved an AEDT project, and produced S11, realized-gain, radiation-pattern, and Touchstone files. The PyAEDT plot images were also visually checked for plotted data. The machine-readable record is `hfss_validation_20260805.json`.

## What was not tested one million times

The suite did not run one million HFSS solves. It does not prove meshing, port validity, convergence, bandwidth, efficiency, gain, pattern, thermal behavior or manufacturability. Those require AEDT, a license, material data and engineering review.

## Final HFSS review checklist

- Correct mode and port integration line.
- Adaptive frequency located near the intended narrowband resonance.
- Mesh and S-parameter convergence.
- Discrete final sweep where signoff requires saved fields at each frequency.
- Actual laminate Dk/Df versus frequency.
- Copper thickness, roughness and finite conductivity.
- Finite ground and enclosure effects.
- Connector, solder and launch geometry.
- Efficiency, realized gain and radiation pattern in addition to S11.
- Manufacturing tolerance and tuning allowance.
