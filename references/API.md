# Ketupa Antenna HTTP API 1.0.0

Start the service:

```powershell
.\bin\windows\ketupa-antenna.exe serve --host 127.0.0.1 --port 8765 --output-root "C:\AntennaWork\api"
```

## Routes

### `GET /health`

Returns service status, version, author, emails and UTC time.

### `GET /v1/capabilities`

Returns verified family, feed types, generated backends, result formats and offline capability.

### `POST /v1/design`

Example body:

```json
{
  "prompt": "2.4 GHz rectangular patch, er=3, h=1 mm, probe feed",
  "output_name": "wifi_2p4",
  "use_calibration": false
}
```

Explicit fields can be used instead of, or together with, `prompt`:

```json
{
  "frequency_ghz": 2.4,
  "relative_permittivity": 3.0,
  "substrate_height_mm": 1.0,
  "loss_tangent": 0.002,
  "feed_type": "probe",
  "compact": true,
  "boundary": "ABC",
  "solver": "HFSS",
  "sweep_type": "Discrete",
  "output_name": "wifi_2p4"
}
```

### `POST /v1/analyze`

```json
{
  "result_file": "C:\\AntennaWork\\wifi_2p4\\results\\S11.s1p",
  "target_frequency_ghz": 2.4
}
```

### `POST /v1/learn`

```json
{
  "design_file": "C:\\AntennaWork\\wifi_2p4\\design.json",
  "result_file": "C:\\AntennaWork\\wifi_2p4\\results\\S11.s1p"
}
```

Only learn from a converged and reviewed result.

## Security

- The built-in server has no TLS and no authentication.
- Bind to `127.0.0.1` for local-only use.
- For LAN use, restrict Windows Firewall rules to trusted subnets.
- For production/public use, place it behind an authenticated HTTPS reverse proxy and apply request limits.
- The request body limit is 2 MB.

