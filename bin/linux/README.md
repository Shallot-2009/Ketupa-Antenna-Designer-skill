# Linux runtime note

Version 1.0.0 contains a native Windows black-box engine. Nuitka binaries must
be built on their target operating system and cannot be safely cross-compiled
from this Windows build host.

On Linux, install the Skill metadata normally and connect to a Windows-hosted
Ketupa HTTP API as documented in `references/API.md`. Generated PyAEDT scripts
remain suitable for a compatible Linux AEDT/PyAEDT host.

Do not rename the Windows `.exe` and present it as a native Linux binary.

