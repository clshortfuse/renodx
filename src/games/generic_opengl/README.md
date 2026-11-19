# Generic OpenGL RenoDX development build

This is a configurable starting point for OpenGL mods. It supports GLSL and ARB
source replacement, replacement sources stored in external files, and an opt-in
fixed-function compatibility path. It does not automatically identify a game's
tonemapper or turn every OpenGL game into a finished HDR mod.

## Install and capture

1. Use an addon-enabled ReShade OpenGL loader matching the game architecture.
   These builds were tested with ReShade 6.8.0 / addon API 18. Older ReShade builds
   may not expose ARB uploads; absence of captures must not be read as success.
2. Put **one** matching `renodx-generic_opengl.addon32` or `.addon64` beside the
   game's executable and `opengl32.dll`. Use it instead of a game-specific RenoDX
   addon during development. Do not replace a working game mod just to install it.
3. Copy the contents of the supplied `profile` directory into an executable-local
   directory named `renodx-opengl`. Its `profile.json` initially enables capture
   only. No user-wide or machine-wide environment/configuration is changed.
4. Start the game, visit the scene of interest, then close it. Sources appear in
   `renodx-opengl/dump`. Inspect the `[Generic OpenGL]` entries in `ReShade.log`.

This profile belongs to the executable directory, independent of the launcher's
working directory. Change profile/source files with the game closed; restart to
reload them. Already-compiled programs are not live-recompiled by this addon.

## GLSL and ARB replacements

Names have the form `0x12345678.ps.glsl` or `0x12345678.ps.arb`. The CRC32 is over
the original submitted source with trailing NUL terminators removed. The stage
is `vs`, `ps`, `gs`, `hs`, `ds`, or `cs`. ARB vertex and fragment programs use `vs`
and `ps`. Keep the captured filename unchanged when editing a replacement.

Copy an original from `dump` to `replacements`, edit that copy, and set
`replace_shaders` to `true`. Never start by deleting every clamp. First verify an
unchanged replacement, then modify the specific scene-color clamp you identified.
Keep mask, shadow, alpha and interpolation clamps unless evidence says otherwise.

The addon validates GLSL compilation or ARB upload before substituting bytes.
It logs `Submitting replacement` and subsequently `Driver accepted replacement`.
Invalid/missing source files leave the original source in place. A GLSL shader
that compiles can still fail the game's program link if its uniforms, attributes,
varyings, version or stage interfaces are incompatible. That link failure is not
automatically rolled back. Keep those interfaces compatible with the original.
Binary program caches, SPIR-V and non-ARB vendor assembly are not replaced.

## External files and engine-loaded shaders

To organize replacements by readable filenames, map an original capture key to a
file under `renodx-opengl`:

```json
"replacements": {
  "0x12345678.ps.glsl": "external/lighting.glsl",
  "0x87654321.ps.arb": "external/interaction.arb"
}
```

Use real hashes from your captures. Explicit mappings override the same-named
file in `replacements`. Files must stay inside the profile directory.

This also replaces shaders originally loaded from game files or archives once
the engine submits their source to OpenGL. It does not intercept arbitrary file
reads or patch archives. If you prefer the engine's own external shader loader,
use that engine's override folder and reload mechanism; names, archive precedence
and shader preprocessing remain engine-specific. Capture the source actually
submitted, which may differ from the file on disk after engine preprocessing.

## Shader parameters (OpenGL cbuffer equivalent)

The addon can supply **64 float values**, packed as **16 vec4 values / 256 bytes**,
to your replacement shaders. No compiler needs to be distributed with the addon:
the installed OpenGL driver compiles GLSL/ARB source. Compiling the addon itself
still requires the repository's normal development tools.

Add a `parameters` object to `profile.json`, or merge the supplied
`profile/parameters.example.json` into your existing profile. Array order defines
the layout: values 0–3 become `renodx_params[0].xyzw`, values 4–7 become
`renodx_params[1].xyzw`, and so on. Unused values are zero. The example puts
exposure at `[0].x`, saturation at `[0].y`, and paper white at `[0].z`.

**GLSL uniform buffer (UBO):** declare this exact block in your replacement:

```glsl
layout(std140) uniform RenoDX {
    vec4 renodx_params[16];
};
```

The addon finds the block by name and binds its buffer for each affected draw or
compute dispatch. `ubo_binding` chooses the temporary indexed binding (default
13); it does not require an explicit `layout(binding=13)` qualifier in GLSL.
The block must be 256 bytes. Use OpenGL 3.2+ for this implementation's indexed
64-bit range queries, or compatible extensions. Do not mix unrelated members
into the block. This supplies floats; it does not translate arbitrary HLSL
`cbuffer` layouts or automatically insert shader declarations.

**Older GLSL / fixed-function custom fragment shader:** use an ordinary array:

```glsl
uniform vec4 renodx_params[16];
```

The driver may optimize out unused array elements; the addon uploads the active
portion. `examples/parameters_uniform.glsl` shows a GLSL 1.20 fragment template.

**ARB assembly:** use `program.local[80]` onward with `arb_mode: "local"`, or
`program.env[80]` onward with `arb_mode: "env"`. `arb_start` changes that start
index; the configured values must fit the driver's parameter limit. Only the
needed vec4 slots are uploaded. For example, exposure is `.x` of the first slot.
Choose unused slots in the replacement; overwriting a parameter the shader still
needs changes its result even though the game state is restored after drawing.

Open ReShade's **OpenGL Shader Parameters** panel for sliders and Reset buttons.
Slider values persist in `ReShade.ini`. Alternatively, create
`renodx-opengl/parameter_values.json` containing, for example:

```json
{"exposure": 2.0, "saturation": 1.1}
```

Edits to this file apply on presentation, checked at most twice per second,
without relinking shaders. Unknown names, invalid types and out-of-range values
reject the whole update. File overrides are live values, not automatically saved
slider settings. Profile structure and shader source changes still need a restart.

Injection is restricted to programs recognized as replacements, plus the addon's
own optional fixed-function fragment program. After each draw it restores the
game's ordinary uniform values, ARB parameters, uniform-block mapping, indexed
UBO range and generic UBO binding. A shader with the same uniform name but no
recognized replacement remains untouched.

Coverage includes the six legacy draw hooks below, core-named instanced draws,
draw-range/base-vertex draws, multidraw arrays/elements, indirect arrays/elements
and multidraw indirect, and direct/indirect compute dispatch. Unsupported entry
points include vendor/extension-only aliases, indirect-count draws,
`glMultiDrawElementsBaseVertex`, and `glDrawRangeElementsBaseVertex`. Separable
program pipelines and binary-only program caches need a game adapter. Display
lists that change programs internally and simultaneous use of a shared program
from multiple rendering threads are not supported. Check the log for successful
extension-hook installation. A deleted but still bound GLSL program stops receiving
parameters; unbind it before deletion in custom code.

## Fixed-function compatibility path

Enable `fixed_function.enabled` only after checking a game's rendering path.
The adapter applies to draws with no GLSL program/pipeline and no enabled ARB vertex or
fragment program. It brackets `glBegin/glEnd`, `glDrawArrays`, `glDrawElements`,
`glCallList`, and `glCallLists`, then restores the program and modified clamp
state. Hooks run before the draw, including immediate-mode draws.

Two independent options are available:

* Set `unclamp_vertex_color` and/or `unclamp_fragment_color` to `true` to disable
  those legacy clamp states during eligible draws. Keep `fragment_shader` empty
  to retain the original fixed-function rendering. A float destination is still
  necessary to retain values above 1.0.
* Set `fragment_shader` to a relative GLSL file to replace fragment processing
  while retaining fixed-function vertex processing. Examples for untextured color
  and single-texture modulation are included. They are teaching templates, not
  automatic emulation of a game's texture combiners, fog, materials or lighting.

This applies to all eligible fixed-function draws in the context, including UI.
Mixed material types need a game-specific selector/adapter before enabling a
custom fragment program. The examples are not suitable as blanket replacements
for arbitrary games. Core-profile contexts are excluded from the fixed-function
adapter (GLSL parameter injection can run there). With parameters disabled only
the six legacy hooks are installed; enabling parameters also installs the extra
draw hooks listed above. Raster pixel operations and lists that change programs
internally remain outside this adapter.
Display-list compilation is left untouched; the profile is applied at playback.

## Optional HDR output

Leave `hdr_proxy` off during initial shader investigation. To enable the D3D11
HDR10/PQ display proxy, add or merge this into the game's existing `ReShade.ini`
and restart:

```ini
[INSTALL]
HookDirectX=1
```

Then set `hdr_proxy` to `true`. Missing DirectX hooks disable just the proxy with
a log message. The overlay exposes scene encoding, paper white and peak output
brightness. Match scene encoding to the buffer's actual linear/sRGB/gamma domain.
The output shader uses `SwapChainPass` for decoding and HDR10 encoding/scaling;
it does not inverse-tonemap a clipped final SDR image.

For games drawing directly to the WGL default framebuffer, the experimental
`redirect_default_framebuffer` option redirects its color into RGBA16F and keeps
matching depth/stencil. It requires `hdr_proxy` and currently supports one
swapchain per device. It is derived from the Doom 3 adapter. The first swapchain
initialization happens at presentation; verify subsequent frames, clears,
copies, resize, and stencil rendering in your game.

This does not automatically upgrade every offscreen texture. Trace intermediate
render targets, copies, resolves and screenshot paths for further UNORM clamps.
Game-specific format upgrades and UI separation still belong in the eventual
game addon. Fixed-function clamps, explicit shader clamps and storage-format
clamps are different things; removing one does not remove the others.

`steam_vulkan_workaround` disables Steam's Vulkan overlay layer **only in this
process when the HDR proxy is enabled**, before ReShade's temporary Vulkan memory
query. It does not disable Steam's OpenGL/D3D overlay hooks. Keep it enabled for
the startup conflict observed on the development machine.

## Build and verification

Source target: `generic_opengl`, derived from `src/games/generic`. Build with the
repository's normal Visual Studio developer environment:

```text
cmake --build --preset clang-x86-debug --target generic_opengl
cmake --build --preset clang-x64-debug --target generic_opengl
```

Outputs: `build32/Debug/renodx-generic_opengl.addon32` and
`build/Debug/renodx-generic_opengl.addon64`. Generated proxy shader headers are
under each build directory's `generic_opengl.include/embed` directory.

The supplied builds are development/debug builds. Tests use an isolated WGL
program rather than replacing the installed Doom 3 addon. On NVIDIA RTX 4080 SUPER
driver 616.56, both architectures passed actual floating-point pixel readbacks
for GLSL replacement, ARB replacement, external-file mapping, invalid GLSL
fallback, fixed-function immediate/array/indexed/display-list draws, legacy
color unclamping, state restoration, and unchanged capture-only rendering.

The test program also exercises FP16 default-framebuffer redirection and HDR10
proxy presentation, with float readback confirming values above 1.0 immediately
before presentation. It also tests graceful HDR disablement without DirectX hooks.
To reproduce, use `tests/run.ps1 -Arch x86 -ReShadeLoader <32-bit DLL>` (or `x64`
and a 64-bit DLL) from the matching Visual Studio developer PowerShell after
building. It creates an isolated test directory under `build32` or `build`.
Parameter tests cover ordinary uniforms and UBOs, vec4 packing, exact binding/range
restoration, instanced draws, live updates without relinking, atomic rejection of
invalid values, untouched unmatched programs, ARB local and environment slots,
the private fixed-function fragment shader, and compute dispatch into an SSBO.
These tests do not establish compatibility with every game,
GPU vendor, engine material system, or multithreaded/multiwindow renderer.
For each game, compare an unchanged replacement with vanilla, inspect the
pre-output float resource for values above 1.0, and verify scene/UI behavior,
depth/stencil, resizing, fullscreen transitions and both direct/Steam launches.
