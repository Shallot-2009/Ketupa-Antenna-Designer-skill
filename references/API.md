# Ketupa Antenna HTTP API 1.0.0

Start the offline service:

```powershell
.\bin\windows\ketupa-antenna.exe serve `
  --host 127.0.0.1 --port 8765 `
  --output-root "C:\AntennaWork\api"
```

## Routes

### `GET /health`

Returns status, version, author, emails, and UTC time.

### `GET /v1/capabilities`

Returns the verified rectangular family plus the complete offline catalog. Each catalog item includes stable key, family, variant, VBS template, support tier, and generated backend set.

### `POST /v1/interpret`

```json
{
  "prompt": "Design a 10 GHz pyramidal horn antenna"
}
```

Optional explicit parameters:

```json
{
  "prompt": "Design a 2.4 GHz axial-mode helix",
  "antenna_type": "axial_helix",
  "parameters": {
    "N": 6,
    "helixD": 38,
    "direction": "Left"
  }
}
```

The response contains `antenna_type`, `antenna_family`, `variant`, `synthesis_tier`, `template`, normalized `parameters`, `parameter_sources`, source `evidence`, `assumptions`, `conflicts`, `missing_parameters`, `warnings`, confidence, and `ready_for_design`.

### `POST /v1/design`

Verified rectangular patch:

```json
{
  "prompt": "2.4 GHz rectangular patch, er=3, h=1 mm, inset feed",
  "output_name": "verified_patch",
  "use_calibration": false
}
```

Catalog family:

```json
{
  "prompt": "Design a 10 GHz pyramidal horn antenna",
  "output_name": "horn_10g"
}
```

The verified response contains `design` and three-backend `files`. A catalog-family response contains `interpretation` and legacy-package `files`, including `vbs` and `model_contract`.

### `POST /v1/analyze`

```json
{
  "result_file": "C:\\AntennaWork\\verified_patch\\results\\S11.s1p",
  "target_frequency_ghz": 2.4
}
```

### `POST /v1/learn`

```json
{
  "design_file": "C:\\AntennaWork\\verified_patch\\design.json",
  "result_file": "C:\\AntennaWork\\verified_patch\\results\\S11.s1p"
}
```

Learn only from a converged, port-valid, physically reviewed result.

## Encoding

HTTP request and response bodies use `application/json; charset=utf-8`. The Windows CLI uses ASCII-safe JSON Unicode escapes so PowerShell 5.1 and Windows Server 2016 do not corrupt Chinese; a JSON parser restores the original characters.

## Security

- The built-in server has no TLS or authentication.
- Bind to `127.0.0.1` for local-only use.
- For LAN use, restrict Windows Firewall rules to trusted subnets.
- For public use, place the service behind an authenticated HTTPS reverse proxy.
- The request body limit is 2 MB.
