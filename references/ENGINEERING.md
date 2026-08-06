# Engineering and Validation Boundary

## Verified rectangular-patch synthesis

The existing engine uses closed-form rectangular-patch and microstrip models, iterative resonance back-checking, Hammerstad-Jensen impedance evaluation, feed-specific geometry, and optional result-driven length calibration.

The retained 1,000,000-case regression covered 0.3–30 GHz, relative permittivity 1.5–12, wavelength-scaled substrate thickness, probe/inset/edge feed, ABC/PML/FEBI, Chinese/English prompts, compact/standard size, resonance and 50-ohm back-checks, VBS contracts, and sampled static generation of all three backends. The machine-readable record is `validation_summary_1000000.json`.

Real Windows AEDT 2026.1 checks were previously completed for VBS probe/inset, AEDT COM Python probe/inset, and PyAEDT probe/edge. Recorded cases retained a non-empty excitation list, Local Variables, an AEDT project, S11, realized gain, radiation pattern, and Touchstone output. See `hfss_validation_20260805.json`.

The new release was compared against the prior 1.0.0 binary for the same rectangular-patch request. Dimensions, electrical data, materials, simulation settings, calibration data, warnings, and all three generated backend script hashes were identical.

## Multi-family offline catalog validation

The catalog has 38 stable family/variant keys. The 30,000-case regression used randomized frequency, permittivity, substrate thickness, helix turn/handedness, spiral/sinuous arms, and tapered-slot curve style. It checked exact family routing, normalized values, contiguous VBS argument contracts, and 100 sampled package generations.

Result: 30,000 executed, 30,000 passed, 0 failed. See `catalog_validation_30000.json`.

The Python 3.10.11 test suite also exercises every registered prompt, Chinese parameter binding, short-symbol disambiguation, every legacy package, strict port/save guards, API routes, all original rectangular-patch backends, S-parameter parsing, and calibration.

## What multi-family validation does not prove

No claim is made that every legacy family was solved and converged in every AEDT version. Static contract and package validation does not prove target resonance, bandwidth, efficiency, gain, pattern, mesh convergence, manufacturability, or regulatory compliance.

Only `rectangular_patch` is fully synthesis-and-solve verified. `legacy_synthesized` and `template_parameterized` outputs are engineering starting models.

## Windows compatibility boundary

- Build runtime: Python 3.10.11.
- Black-box packager: PyInstaller 5.13.2.
- UPX: disabled.
- API baseline target: Windows 10 and Windows Server 2016 or newer.
- CLI/file JSON: ASCII-safe Unicode escapes; HTTP JSON: UTF-8.

This establishes a static/runtime compatibility baseline on the build host. It is not a substitute for executing the final installer, AEDT version, license, and generated model on every target Windows edition.

## Final HFSS review checklist

- Correct geometry family and requested variant.
- Non-empty excitation list and correct integration line/orientation.
- Correct solution type, mode, and reference conductor.
- Boundary distance at the lowest frequency.
- Actual frequency-dependent Dk/Df, conductor thickness, roughness, and conductivity.
- Adaptive mesh and S-parameter convergence.
- Discrete final sweep when signoff requires fields at each frequency.
- Input impedance, S11, efficiency, realized gain, and radiation pattern.
- Enclosure, connector, solder, launch, and finite-ground effects.
- Manufacturing tolerance and tuning allowance.
