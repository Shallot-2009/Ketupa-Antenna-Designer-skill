# Offline Antenna Catalog 1.0.0

The catalog routes Chinese, English, and mixed prompts without a network or language model. `antenna_type` is the stable key accepted by `--antenna-type` and the HTTP API.

## Support tiers

- `verified`: deterministic synthesis plus VBS, AEDT COM Python, PyAEDT, port checks, solve/report generation, and Touchstone export were validated for the rectangular patch.
- `legacy_synthesized`: the original HFSS geometry contract is preserved and supplied with analytical wavelength-scaled starting dimensions. Port existence and AEDT project save are guarded, but RF performance is not pre-verified.
- `template_parameterized`: the exact complex legacy VBS contract is mapped and auditable. Defaults are starting values and require stronger geometry/performance review.

## Stable keys

| Family | Keys |
|---|---|
| Patch | `rectangular_patch`, `square_patch`, `circular_patch`, `elliptical_patch` |
| Dipole / monopole | `wire_dipole`, `planar_dipole`, `wire_monopole` |
| Horn | `pyramidal_horn`, `e_plane_horn`, `h_plane_horn`, `conical_horn`, `elliptical_horn` |
| Waveguide | `rectangular_waveguide`, `circular_waveguide` |
| Helix | `axial_helix`, `tapered_axial_helix`, `quadrifilar_helix`, `normal_mode_helix` |
| Spiral / sinuous | `archimedean_spiral`, `conical_archimedean_spiral`, `log_spiral`, `conical_log_spiral`, `planar_sinuous`, `conical_sinuous` |
| Tapered slot | `vivaldi`, `linear_taper_slot` |
| Log periodic | `log_periodic_toothed`, `log_periodic_trapezoid` |
| PIFA | `pifa_trace`, `pifa_pin`, `pifa_plate` |
| Bowtie | `bowtie`, `rounded_bowtie`, `bowtie_slot` |
| Biconical | `bicone`, `discone` |
| Slot | `slot`, `microstrip_slot` |

Use `ketupa-antenna families` for the machine-readable current list, including display name, family, variant, template, tier, and generated backend set.

## Disambiguation examples

- “elliptical horn” maps to `elliptical_horn`, never to a generic horn.
- “elliptical” alone is rejected as ambiguous; “elliptical patch” maps to `elliptical_patch` and generates ellipse geometry rather than a rectangular fallback.
- “bowtie slot” maps to `bowtie_slot`, never to the basic slot.
- “rectangular waveguide” maps to `rectangular_waveguide`, never to a patch.
- “circular patch” maps to `circular_patch`; shape flag and patch axes follow the matching VBS contract.
- “right-handed axial-mode helix, 5 turns” maps handedness and turn count into `direction` and `N`.
- “E-plane sectoral horn” and “H-plane sectoral horn” use different non-flared aperture defaults in the orthogonal plane.

## Generated legacy package

```text
design.json                  family, variant, prompt evidence, effective parameters
model_contract.json          exact ordered VBS argument contract and value sources
summary.md                   engineering boundary and run instructions
legacy_vbs/build_model.vbs   selected HFSS geometry plus strict port/save guard
legacy_vbs/run_model.cmd     path-independent Windows launcher
legacy_vbs/run_model.ps1     PowerShell launcher
results/                     model-created or model-failed marker
hfss_project/                saved AEDT project location
```

The package creates and saves a parameterized starting model. It does not claim convergence, target S11, gain, bandwidth, efficiency, manufacturability, or regulatory compliance.
