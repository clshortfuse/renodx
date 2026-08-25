# DOOM (2016) RenoDX HDR (experimental)

This game-local addon targets only the inspected GOG x64 Vulkan executable,
`DOOMx64vk.exe` SHA-256
`A32DF8FFA042090F14FE0A200F1C5D7DDDF9C947FAC223916C252F826F1ECF11`.

Build the `doom2016` target, deploy `renodx-doom2016.addon64` beside the game,
and cold-start DOOM with Windows HDR enabled. Use the `Release` artifact for
gameplay and acceptance; `Debug` intentionally enables framework assertions and
is only for attached development diagnostics. Do not combine the addon with
Auto HDR, RTX HDR, RenderDoc, Nsight, or the RenoDX DevKit during final
acceptance.

The captured post-process pass writes two full-resolution `R11G11B10_FLOAT`
targets. The addon keeps the game's scene/effect/color-grade work before its
native SDR curve, uses that float resource as the HDR carrier, then replaces the
last upsample pass to composite the separately sampled GUI and encode HDR10.
DOOM retains a compatible game-facing `RGBA16F` swapchain clone; a thin proxy
copies the already encoded PQ values into the real RGB10A2 swapchain. It never
inverse-tone-maps the completed SDR backbuffer.

PsychoV-30 is derived from the supplied `test30 (2).hlsl`, raw SHA-256
`01E075AB1E9FD79469E160FCD05F54277DE8B47C76CC3C4A425E4DAA7F164F58`.
The game-local copy changes only its RenoDX include path and calls the mapper
with explicit `compression = 0` auto-compression semantics. PsychoV-24,
PsychoV-25 and the P25 NRG shim come from RenoDX commit `4f0a278d`; the NRG
shim changes only its erroneous `DISHONORED2` include guard.

Output mode is applied when Vulkan creates the swapchain. Until DOOM-specific
swapchain recreation is proven safe, restart the game after changing Output
Mode. Tone-mapper changes use pipelines pre-created during startup and do not
perform live pipeline compilation or destruction.

`Preset Off` restores the saved neutral SDR/Vanilla settings, but the Vulkan
swapchain format and color space cannot be changed atomically in the inspected
runtime. Restart DOOM after selecting Off so the original SDR pipeline and
swapchain state are selected from a cold start.

PsychoV-25 currently executes at full resolution and remains provisional until
the sustained DOOM GPU timing gate is completed. `Cone Response = 50` is the
normal PsychoV response (`1.0` in the shader); `0` is an achromatic diagnostic
endpoint and is not a neutral color setting. Peak-dependent hue movement in
highly saturated PsychoV highlights is mapper behavior measured before the PQ
encoder, not an HDR10 signaling error.

The inspected Vulkan device path does not enable `VK_EXT_hdr_metadata`, so this
experimental build selects RGB10A2/ST2084 and writes valid PQ but does not yet
publish explicit static HDR metadata. Gameplay HUD, menus and the startup path
were exercised; subtitles, automap, all loading transitions and every video
path have not received exhaustive acceptance coverage.

During runtime validation, disable third-party implicit Vulkan layers such as
RTSS, OBS Vulkan capture and the Steam overlay/Fossilize layers. Their combined
proxy path produced unbounded Win32 handle growth in the inspected setup. The
performance statistics drawn in DOOM's upper-right corner are the game's own
overlay and are not RTSS.
