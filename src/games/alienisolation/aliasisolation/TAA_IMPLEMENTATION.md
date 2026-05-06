# Alias Isolation TAA Implementation

This folder contains the RenoDX port of Alias Isolation's temporal
anti-aliasing for Alien Isolation.

The runtime is draw-driven. It watches known game shader CRC32 hashes, captures
the resources exposed by those draws, patches the game's camera constant buffers
for jitter, dispatches the embedded TAA compute shader before the original post
draw continues, then copies the resolved result back into the game's HDR color
resource.

Required in-game settings:

- Anti-aliasing: `SMAA T1x`
- Motion Blur: `On`

`SMAA T1x` selects the branch this port expects. Motion Blur keeps the
camera-motion pass active, which supplies velocity and depth for TAA.

## Current Design

- TAA dispatch is manual in `runtime/taa.hpp`.
- RenoDX core is not modified for Alias Isolation.
- RenoDX utilities are used where they already fit: shader CRC32 tracking,
  pipeline-layout tracking, current shader/render state, resource-view lifetime
  callbacks, settings, and `mods::shader` replacements.
- Small game-specific helpers stay in this folder. That includes the reduced
  register tracker and compute-state restore logic.
- Non-TAA replacement shaders are registered in Alien Isolation's existing
  `custom_shaders` map in `addon.cpp`.

`renodx::utils::render::RenderPass` is intentionally not used for TAA. The TAA
resolve needs exact barriers, copy-back, ping-pong history, same-frame
velocity/depth validation, and compute-only state restore before a graphics
draw continues. With stock RenoDX core, the manual path is simpler and clearer.

## File Map

| File | Role |
| --- | --- |
| `aliasisolation.hpp` | Entry point included by `addon.cpp`; owns settings, callback registration, CRC32 hash routing, Texture3D view normalization, and draw routing. |
| `runtime/config.hpp` | Compile-time toggles for optional barrel-distortion and bloom replacement paths. |
| `runtime/constant_buffers.hpp` | Master enable binding, frame counters, TAA sample index, and the Hammersley jitter sequence. |
| `runtime/descriptor_tracker.hpp` | Tracks only the registers Alias Isolation needs from ReShade descriptor pushes: pixel `t0`, pixel `t8`, vertex `b0`, vertex `b1`, and pixel `b2`. |
| `runtime/jitter.hpp` | Tracks camera constant buffers, patches mapped data on unmap, stores no-jitter matrices, and applies per-frame projection jitter. |
| `runtime/taa.hpp` | Captures color/velocity/depth, owns history textures and compute objects, dispatches TAA, copies the result back, and restores compute state. |
| `runtime/logging.hpp` | Alias Isolation log helpers. Logging is currently default-enabled for verification. |
| `shaders/aliasisolation_taa.cs_5_0.hlsl` | Embedded compute shader for the temporal resolve. |

Removed from the port: a separate pipeline tracker, pipeline replacer,
shader-ID table, and resource-view sanitizer header.

## Frame Flow

1. `aliasisolation::Use` registers ReShade callbacks and enables the RenoDX
   helper utilities this runtime depends on.
2. `push_descriptors` updates `descriptor_tracker::CommandListData` with the
   small fixed register set needed later at draw time.
3. Draw callbacks call `aliasisolation::HandleDraw`.
4. `HandleDraw` reads current RenoDX shader CRC32 hashes and identifies SMAA,
   RGBM encode, DoF encode, and camera-motion passes.
5. `jitter::CaptureConstantBuffers` records the game camera cbuffers exposed by
   those passes.
6. ReShade map/unmap callbacks patch tracked cbuffers after the game writes
   them and before the GPU consumes them.
7. The camera-motion draw captures RTV 0 as velocity and pixel `t8` as depth.
8. The DoF encode draw, or RGBM fallback, runs TAA once for the frame if
   same-frame velocity/depth are available.
9. `taa::DispatchCompute` binds the embedded compute shader, dispatches it,
   copies current history back into the game color resource, restores compute
   state, and returns control to the original draw.
10. `present` promotes current matrix state, advances the frame counter, and
    advances the TAA sample only if the resolve succeeded.

## Shader Hashes

Known draw-pass hashes live in `aliasisolation.hpp::shader_hashes`.

| Hash constant | Stage | Purpose |
| --- | --- | --- |
| `SMAA_VS` | Vertex | Finds `DefaultXSC` at vertex `b0`. |
| `RGBM_ENCODE_VS` | Vertex | Finds `DefaultVSC` at vertex `b1`; also part of RGBM fallback insertion. |
| `RGBM_ENCODE_PS` | Pixel | RGBM fallback insertion point with `RGBM_ENCODE_VS`. |
| `DOF_ENCODE_PS` | Pixel | Preferred TAA insertion point. |
| `CAMERA_MOTION_PS` | Pixel | Finds `DefaultPSC`, velocity RTV 0, and depth pixel `t8`. |

Replacement shader hashes also live in `shader_hashes`, but the replacement
bytecode is registered in `addon.cpp` through `renodx::mods::shader`:

- `SHADOW_LINEARIZE_PS`
- `SHADOW_DOWNSAMPLE_PS`
- optional `MAIN_POST_VS`
- optional `BLOOM_MERGE_PS`

The original ASI matched DXBC checksum words. This port uses the full-bytecode
CRC32 identity used by RenoDX dumped shader filenames and replacement tables.

## Register And Resource Map

| Source | Register/resource | Stored in | Used for |
| --- | --- | --- | --- |
| `SMAA_VS` | Vertex `b0` | `jitter::tracked.default_xsc` | Main projection jitter. |
| `RGBM_ENCODE_VS` | Vertex `b1` | `jitter::tracked.default_vsc` | RGBM/post projection jitter. |
| `CAMERA_MOTION_PS` | Pixel `b2` | `jitter::tracked.default_psc` | Velocity matrix and shadow jitter correction. |
| `CAMERA_MOTION_PS` | RTV 0 | `taa::resources.velocity_resource` plus owned SRV | Velocity input for TAA. |
| `CAMERA_MOTION_PS` | Pixel `t8` | Borrowed `taa::resources.depth_srv` | Depth input for TAA. |
| DoF/RGBM insertion | Pixel `t0` | Borrowed color SRV; resource is copy-back target | Current HDR color input and resolved output destination. |

TAA compute shader bindings:

| Register | Shader name | Bound value |
| --- | --- | --- |
| `s0` | `linear_sampler` | Linear sampler for Catmull-Rom history reconstruction. |
| `s1` | `point_sampler` | Point sampler for current color, velocity, and depth taps. |
| `t0` | `current_color_texture` | Current HDR color SRV from pixel `t0`. |
| `t1` | `previous_history_texture` | Previous ping-pong history SRV. |
| `t2` | `velocity_texture` | SRV created from the camera-motion RTV. |
| `t3` | `depth_texture` | Borrowed depth SRV from camera-motion pixel `t8`. |
| `u0` | `current_history_output` | Current ping-pong history UAV. |
| `b11` | `ShaderInjectData` | RenoDX shader-injection push constants from `shared.h`. |

## TAA Invariants

- Dispatch at most once per frame.
- Advance `taa_sample_index` only after dispatch and copy-back succeed.
- Use velocity/depth only if captured in the same frame as the insertion point.
- Seed both history textures from current color when history is created.
- Restore compute state after dispatch without rebinding the active graphics
  draw state.
- Treat velocity SRV as owned by the runtime and depth/color SRVs as borrowed.
- Keep jittered matrices separate from no-jitter matrices used for velocity and
  shadow correction.
- Return `false` from draw hooks so the original game draw continues.

Supported history formats:

| Color case | History resource format | History view format |
| --- | --- | --- |
| `r16g16b16a16_typeless` resource | `r16g16b16a16_typeless` | `r16g16b16a16_float` |
| `r16g16b16a16_float` resource | `r16g16b16a16_float` | `r16g16b16a16_float` |
| `r11g11b10_float` resource | `r11g11b10_float` | `r11g11b10_float` |
| `r16g16b16a16_float` view over another resource | `r16g16b16a16_typeless` | `r16g16b16a16_float` |

## Jitter Behavior

Alias Isolation jitters projection by editing CPU-mapped game cbuffers. The
runtime identifies those cbuffers from known shader/register pairs, then patches
mapped data on unmap.

| Cbuffer | Tracked from | Main changes | Guards |
| --- | --- | --- | --- |
| `DefaultXSC` | `SMAA_VS` vertex `b0` | Updates `SecondaryProj`, `ViewProj`, and `SecondaryViewProj`. | Skips planar reflections and shadow-like views. |
| `DefaultVSC` | `RGBM_ENCODE_VS` vertex `b1` | Updates `ProjMatrix`, `PrevViewProj`, and `PrevSecViewProj`. | Skips if the expected jitter is already present. |
| `DefaultPSC` | `CAMERA_MOTION_PS` pixel `b2` | Rewrites motion matrices and removes current jitter from `Spotlight0_Transform`. | Requires current and previous no-jitter view-projection matrices. |

Jitter is tied to successful TAA resolves, not merely to presented frames. If
the runtime misses velocity, depth, or the insertion point, the next frame keeps
the same sample.

## Differences From Original ASI

| Area | Original ASI | RenoDX port |
| --- | --- | --- |
| Hooking | Direct D3D11 method hooks. | ReShade add-on callbacks. |
| Shader identity | Raw shader pointers and DXBC checksum words. | RenoDX CRC32 shader hashes. |
| Replacements | Swap shader objects at bind time. | `mods::shader` replacements in `addon.cpp`. |
| TAA dispatch | Deferred D3D11 context command list. | Current ReShade command list before the original draw continues. |
| State restore | Deferred context clear/execute behavior. | Local compute-only state capture/restore. |
| Resource states | D3D11 implicit state model. | Explicit ReShade barriers. |
| History | `R11G11B10_FLOAT`, not seeded from current color. | HDR-upgraded formats supported; history seeded from current color. |
| Velocity/depth | Last captured inputs may be reused. | Same-frame capture is required. |
| Resolve luminance | Old incorrect BT.601-style luma formula. | RenoDX `Yf`, BT.709 Stockman luminance. |

The compute shader keeps the original `RGBR` history write behavior. Its only
intentional functional difference is the luminance calculation above; the rest
of the shader cleanup is structural.

## Current Log Validation

Latest checked log:

`C:\Program Files (x86)\Steam\steamapps\common\Alien Isolation\ReShade.log`

Observed working evidence:

- Runtime attaches and detects `3840x2160`.
- CRC32 routing observes RGBM encode VS/PS, SMAA VS, camera-motion PS, and DoF
  encode PS.
- `DefaultXSC`, `DefaultVSC`, and `DefaultPSC` are tracked.
- Velocity SRV and depth SRV are captured from camera motion.
- TAA history and compute pipeline are created.
- Shadow linearize and shadow downsample replacements are used through
  `mods::shader`.
- Repeated `dispatched TAA` lines appear after same-frame camera-motion capture.
- Toggle off/on transitions recover: capture and dispatch resume after toggles.
- The final log line is `AliasIsolation: detach`.

Expected warnings in the checked log:

- One early `TAA insertion reached without velocity/depth` before the first
  camera-motion capture.
- Stale camera-motion warnings during menu/pause/toggle transitions.
- One non-Alias `mods::shader::OnInitPipelineLayout(Forcing cbuffer...)`
  warning.

Those warnings are acceptable because capture and dispatch resume afterward.
There are no persistent Alias Isolation `failed`, `missing`, or `unsupported`
warnings in the working section of the log.

## Debug Checklist

When TAA does not run, check in this order:

1. Game settings are `SMAA T1x` and Motion Blur `On`.
2. RenoDX setting `Alias Isolation TAA` is enabled.
3. Log shows observed hashes for SMAA, RGBM, DoF, and camera motion.
4. Log shows `DefaultXSC`, `DefaultVSC`, and `DefaultPSC` tracking.
5. Camera-motion capture sees RTV 0 and pixel `t8` in the same frame.
6. DoF insertion, or RGBM fallback, has pixel `t0`.
7. History accepts the color format and creates at the expected resolution.
8. Compute pipeline is created and TAA dispatch logs once per active frame.
9. If stale-capture warnings appear, verify capture and dispatch resume after
   leaving menu/pause/toggle transitions.

## Change Checklist

When editing this runtime:

- If shader hashes change, update `aliasisolation.hpp::shader_hashes` and verify
  observed-hash logs.
- If game register assumptions change, update `descriptor_tracker::CommandListData`
  and the register map above.
- If TAA shader bindings change, update `taa::EnsureComputePipeline`,
  `taa::DispatchCompute`, the HLSL declarations, and the binding table above.
- If supported HDR formats change, update `taa::GetSupportedHistoryFormat`.
- Preserve once-per-frame dispatch, same-frame velocity/depth validation,
  history ping-pong, copy-back, compute-state restore, and draw-hook return
  values.
- Preserve fullscreen-only jitter guards and keep no-jitter matrix state
  separate from patched game matrices.

Quick read path:

1. `aliasisolation.hpp::HandleDraw`
2. `taa.hpp::CaptureCameraMotion`
3. `taa.hpp::MaybeRun`
4. `taa.hpp::DispatchCompute`
5. `jitter.hpp`
6. `shaders/aliasisolation_taa.cs_5_0.hlsl`
