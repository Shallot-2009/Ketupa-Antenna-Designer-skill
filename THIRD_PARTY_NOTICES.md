# Third-Party Notices

The Windows executable in this distribution is built with a CPython/Nuitka
toolchain. The project license in `LICENSE.txt` applies only to material for
which the Ketupa copyright holder can grant those rights. Third-party
components remain under their respective licenses.

The release package conservatively includes notices for runtime or compression
code that may be present in the one-file executable:

| Component | License / permission | License file |
|---|---|---|
| CPython runtime | Python Software Foundation License Version 2 and historical Python licenses | `third_party_licenses/PYTHON_LICENSE.txt` |
| Nuitka runtime library | AGPLv3 with the Nuitka Runtime Library Exception, which permits compiled target code to be conveyed under terms of the author's choice | `third_party_licenses/NUITKA_AGPL-3.0.txt`, `third_party_licenses/NUITKA_RUNTIME_EXCEPTION.txt` |
| Zstandard | BSD 3-Clause | `third_party_licenses/ZSTANDARD_LICENSE.txt` |
| zlib | zlib License | `third_party_licenses/ZLIB_LICENSE.txt` |
| HACL* code used by the Python toolchain when applicable | Apache License 2.0 | `third_party_licenses/HACL_APACHE-2.0.txt` |

`ansys-aedt-core`/PyAEDT, `pywin32`, Ansys Electronics Desktop, and HFSS are
not bundled in this repository. Generated backend scripts may call those
separately installed products or libraries, which remain governed by their own
licenses.

Ansys, Ansys Electronics Desktop, and HFSS are trademarks of their respective
owners. Ketupa Antenna Designer is an independent project and is not affiliated
with, sponsored by, or endorsed by Ansys, Inc.
