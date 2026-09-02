# RenoDX Mod Verification Checklist

Use this only when a durable mod-local checklist is requested or a committed verification document already exists.

- Build target: `{mod}`
- Expected artifact: `renodx-{mod}.addon64` or `.addon32`
- Build preset/target used:
- Game binary folder:
- Linked/copied files:
  - ReShade loader:
  - DevKit addon:
  - Game addon:
- Runtime checks:
  - ReShade loads.
  - DevKit loads when needed.
  - Game addon loads and shows the expected RenoDX title.
  - Relevant settings respond.
  - Target shader replacement is active.
  - Resource upgrades/clones preserve HDR values when applicable.
  - Proxy/output shader uses a proven float signal and does not inverse-tonemap final SDR.
  - SDR/HDR output toggles update shader preset and swapchain color space together.
  - Final output mode/color space follows the selected setting.