# Offline Prompt Interpreter

Run `ketupa-antenna interpret --prompt <text>` before generation. The dependency-free Chinese/English interpreter reports the exact antenna family/variant, synthesis tier, normalized parameters, source evidence, assumptions, conflicts, missing parameters, warnings, and `ready_for_design`.

Require one catalog family and one target frequency. Prefer specific variants over generic nouns and reject unresolved conflicts instead of substituting another shape. Explicit CLI/API values may override recognized prompt fields and are recorded in `parameter_sources`.

The output tiers are:

- `verified`: rectangular microstrip patch; three generated backends and result-export checks.
- `legacy_synthesized`: exact legacy VBS contract with wavelength/formula starting values.
- `template_parameterized`: exact complex-geometry VBS contract with auditable prompt/default values.

Run `ketupa-antenna families` to list all offline keys. Generated legacy packages contain `design.json` and `model_contract.json`; the latter records the ordered VBS argument list, value, and source.

If `ready_for_design` is false, stop and clarify the family, frequency, or conflicting parameters. Do not call `design` and do not fall back to a rectangular patch. For example, `elliptical` alone is ambiguous, while `5.8 GHz elliptical patch antenna` maps to `elliptical_patch`.
