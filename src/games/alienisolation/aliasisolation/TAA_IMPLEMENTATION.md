# Alias Isolation TAA Implementation

This folder contains the RenoDX port of Alias Isolation's temporal
anti-aliasing for `src/games/alienisolation`. The integration keeps the TAA
compute dispatch manual for functional parity, but uses RenoDX utilities for
shader CRC32 tracking, resource/view metadata, pipeline-layout decoding, current
render state, and non-TAA shader replacement.

The runtime depends on two in-game settings:

- Anti-aliasing: `SMAA T1x`
- Motion Blur: `On`

`SMAA T1x` gives this port the final AA branch it expects, and motion blur keeps
the camera-motion pass active so the TAA resolve can reuse the velocity target.

## File Map

| File | Role |
| --- | --- |
| `aliasisolation.hpp` | Public entry point used by `addon.cpp`; adds settings, registers callbacks, owns known CRC32 hash constants, normalizes Texture3D view creation, and routes draw events to jitter/TAA. |
| `runtime/config.hpp` | Compile-time toggles for optional barrel-distortion and bloom replacement paths. |
| `runtime/constant_buffers.hpp` | Master enable binding, frame counters, TAA sample index, and the Alias Isolation Hammersley jitter sequence. |
| `runtime/descriptor_tracker.hpp` | Tracks only the fixed D3D11-style registers still needed from `push_descriptors`: pixel `t0`, pixel `t8`, vertex `b0`, vertex `b1`, and pixel `b2`. |
| `runtime/jitter.hpp` | Tracks game camera cbuffers, patches mapped data on unmap, stores current/previous no-jitter matrices, and applies per-frame projection jitter. |
| `runtime/taa.hpp` | Captures velocity/depth/color resources, owns history textures and compute state, dispatches the TAA compute shader, and copies the result back into the game's color resource. |
| `runtime/logging.hpp` | Compile-time gated Alias Isolation logging helpers. Logging is currently default-enabled for verification. |
| `shaders/aliasisolation_taa.cs_5_0.hlsl` | Embedded compute shader that performs the temporal resolve. |

Alias Isolation's non-TAA replacement shaders are registered in
`src/games/alienisolation/addon.cpp` through the existing
`renodx::mods::shader::CustomShaders` map. There is no separate Alias Isolation
pipeline tracker, replacer, shader-ID table, or resource-view sanitizer header.

## Port Differences From Original ASI

This section compares the RenoDX port against the original
`aliasIsolation/src/dll/taa.cpp` path.

| Area | Original Alias Isolation | RenoDX port |
| --- | --- | --- |
| Hooking model | Hooks D3D11 methods directly with MinHook: `Draw`, `VSSetShader`, `PSSetShader`, `Map`, `Unmap`, resize, and present. | Uses ReShade add-on callbacks for descriptor pushes, RTV/viewport binds, map/unmap, draw, present, and resource lifetime. |
| Shader identity | Stores raw `ID3D11VertexShader*` and `ID3D11PixelShader*` pointers when shaders are created. | Uses `renodx::utils::shader::GetCurrentVertexShaderHash` and `GetCurrentPixelShaderHash` during draw callbacks, comparing against local CRC32 constants in `aliasisolation.hpp`. |
| Replacement shaders | Intercepts shader creation and swaps raw shader objects at bind time. | Registers replacement bytecode in Alien Isolation's existing `custom_shaders` map and lets `renodx::mods::shader` build/bind replacement pipelines. Replacements are gated by `constant_buffers::IsEnabled()`. |
| Draw coverage | Runs from the D3D11 `Draw` hook. | Handles `draw`, `draw_indexed`, and `draw_or_dispatch_indirect`. |
| Resource discovery | Queries live D3D11 context state with calls like `PSGetShaderResources`, `VSGetConstantBuffers`, `OMGetRenderTargets`, and `RSGetViewports`. | Reconstructs only the needed descriptor registers from ReShade `push_descriptors`; uses `renodx::utils::state` for current RTV 0 during camera-motion capture. |
| TAA execution context | Records TAA on a deferred context, finishes a command list, then executes it on the immediate context. | Dispatches compute directly on the current ReShade command list before the original draw continues. |
| State handling | Calls `ClearState()` on the deferred context and relies on `ExecuteCommandList(..., true)` to restore immediate-context state. | Captures and restores only compute pipeline/descriptors after dispatch, leaving the current graphics draw state untouched. |
| History format | Requires `DXGI_FORMAT_R11G11B10_FLOAT` for the main color resource and history textures. | Supports `r11g11b10_float` plus HDR-upgraded `r16g16b16a16_typeless` / `r16g16b16a16_float` paths. |
| History initialization | Creates two history textures on first use or resolution change, but does not seed them from current color. | Recreates history when size/format changes and seeds both history textures from the current color resource. |
| Resource transitions | Uses D3D11's implicit resource state model. | Emits explicit ReShade barriers around velocity SRV use, history UAV/copy use, and color copy-back. |
| Velocity/depth capture | Captures velocity when `CameraMotionPs` is set and depth from pixel `t8` during draw. | Captures current RTV 0 and pixel `t8` during the `CameraMotionPs` draw, creates/reuses the velocity SRV, and records the frame index. |
| Stale input handling | Uses the last captured velocity/depth resources. | Rejects the resolve if velocity/depth were not captured in the same frame as the insertion point. |
| Resolve luminance | Uses the old incorrect BT.601-style luma formula for blend weighting. | Uses RenoDX `Yf`, which is BT.709 Stockman luminance. |
| Jitter patching | Hooks D3D11 `Map`/`Unmap` and polls current RTV/viewport during `Unmap`. | Uses ReShade map/unmap callbacks, tracked mapped ranges, and cached RTV/viewport state from callbacks. |
| Frame advancement | `finishFrame` resets per-frame state and promotes the previous no-jitter matrix in the original render flow. | ReShade `present` calls `jitter::FinishFrame()` and then `constant_buffers::BeginFrame()`. The TAA sample index advances only after successful dispatch/copy-back. |

The most important behavioral changes are HDR-format support, explicit resource
lifetime, same-frame velocity/depth validation, seeded history, BT.709 Stockman
luminance for resolve weighting, direct command-list dispatch, and
RenoDX/ReShade callback-based state reconstruction.

## How It Hooks Into `addon.cpp`

`addon.cpp` touches Alias Isolation in these places:

1. It includes `./aliasisolation/aliasisolation.hpp`.
2. It appends the `Alias Isolation` settings section and binds the toggle to
   `ShaderInjectData::custom_alias_isolation_taa`.
3. `OnPresetOff()` disables Alias Isolation TAA and sharpening.
4. It registers Alias Isolation replacement shaders in the existing
   `custom_shaders` map:
   - optional `MAIN_POST_VS` barrel-distortion removal
   - always-on shadow linearize replacement
   - always-on shadow downsample replacement
   - optional bloom merge replacement
5. It calls `alienisolation::aliasisolation::Use(fdw_reason, &shader_injection)`
   from `DllMain`.

The replacement entries use `.on_replace` to stay toggle-gated and `.on_inject`
to suppress RenoDX shader-injection constants for these original Alias Isolation
replacement shaders. The manual TAA compute shader is not registered as a
`mods::shader` replacement; `taa.hpp` creates and dispatches it directly from
the embedded `__aliasisolation_taa` bytecode.

## Callback Wiring

`aliasisolation::Use` registers these callbacks:

| Callback | Owner | Purpose |
| --- | --- | --- |
| `init_swapchain` / `destroy_swapchain` | `jitter` | Cache/reset the screen size used for jitter scaling. |
| `init_command_list` / `destroy_command_list` / `reset_command_list` | `descriptor_tracker` | Maintain per-command-list descriptor-register state. |
| `create_resource_view` | `aliasisolation.hpp` | Normalize unknown Texture3D view descriptions before RenoDX resource helpers inspect them. |
| `bind_render_targets_and_depth_stencil` | `jitter` | Track fullscreen render state for safe cbuffer patching. |
| `bind_viewports` | `jitter` | Track fullscreen viewport state. |
| `push_descriptors` | `descriptor_tracker` | Map ReShade descriptor updates back to `t0`, `t8`, `b0`, `b1`, and `b2`. |
| `map_buffer_region` / `unmap_buffer_region` | `jitter` | Patch tracked camera cbuffers after the game writes them. |
| `draw`, `draw_indexed`, `draw_or_dispatch_indirect` | `aliasisolation.hpp` | Read RenoDX current shader hashes, run draw-driven capture, and insert TAA. |
| `destroy_device` | `aliasisolation.hpp` | Destroy history, compute objects, velocity SRV, and jitter state. |
| `present` | `aliasisolation.hpp` | Advance frame state after the frame is presented. |

`aliasisolation::Use` also calls `renodx::utils::resource::Use`,
`renodx::utils::pipeline_layout::Use`, `renodx::utils::shader::Use`, and
`renodx::utils::state::Use`. `mods::shader::Use` is still called from
`addon.cpp` for the global Alien Isolation shader replacement system.

## Frame Flow

The TAA insertion point is draw-driven. ReShade calls the draw hook before the
game draw executes, so the runtime dispatches compute, copies the resolved
result back into the color texture that the upcoming draw will sample, restores
the previous compute state, and then lets the original draw continue.

| Phase | Trigger | Code path | Reads | Writes / side effects |
| --- | --- | --- | --- | --- |
| Startup | `addon.cpp::DllMain` | `AppendSettings`, replacement registration, `aliasisolation::Use` | `ShaderInjectData` pointer | Adds settings, registers callbacks, and enables RenoDX helper utilities. |
| Shader hash routing | Draw callback | `aliasisolation::HandleDraw` | `renodx::utils::shader` current VS/PS hashes | Detects SMAA, RGBM, DoF, and camera-motion passes by CRC32. |
| Descriptor tracking | `push_descriptors` | `descriptor_tracker` | ReShade descriptor updates | Tracks pixel `t0`, pixel `t8`, vertex `b0`, vertex `b1`, and pixel `b2`. |
| Cbuffer capture | Draw callback | `jitter::CaptureConstantBuffers` | Hash-match booleans and cbuffer registers | Tracks `DefaultXSC`, `DefaultVSC`, and `DefaultPSC` resources for later map/unmap patching. |
| Jitter patch | `map_buffer_region`, `unmap_buffer_region` | `jitter` | Mapped tracked cbuffers, fullscreen render state | Patches projection/motion/shadow matrices before GPU use. |
| Camera-motion capture | Draw using `CameraMotionPs` | `taa::CaptureCameraMotion` | `renodx::utils::state` RTV 0 and pixel `t8` | Creates/reuses velocity SRV, stores depth SRV, records capture frame. |
| TAA insertion | Draw using `DofEncodePs`, or RGBM fallback | `taa::MaybeRun`, `taa::Run` | Pixel `t0`, velocity, depth, previous history | Validates same-frame inputs, dispatches compute, copies current history back into game color. |
| Original post draw | Hook returns `false` | Game draw continues | Resolved game color resource | Upcoming draw samples resolved color normally. |
| Frame advance | `present` | `jitter::FinishFrame`, `constant_buffers::BeginFrame` | Current no-jitter matrix, TAA dispatch flag | Promotes previous matrix state, increments frame index, clears per-frame TAA flag. |

## Critical Invariants

| Invariant | Why it matters | Enforced by |
| --- | --- | --- |
| TAA dispatches at most once per frame. | Prevents multiple history writes and multiple jitter sample advances in one frame. | `frame_state.taa_ran_this_frame` in `taa::MaybeRun`. |
| `taa_sample_index` advances only after dispatch and copy-back succeed. | Keeps camera jitter synchronized with valid history. | `constant_buffers::MarkTaaDispatched`. |
| Velocity/depth capture is same-frame as insertion. | Avoids reprojecting with stale motion/depth. | `taa::resources.capture_frame` check in `taa::Run`. |
| Draw hooks return `false`. | Lets the original game draw continue after the pre-draw compute insertion. | `aliasisolation::HandleDraw`. |
| Compute state is restored after dispatch. | Prevents the manual compute pass from leaking compute bindings into later compute work. | `taa::CaptureComputeState` / `taa::RestoreComputeState`. |
| Compute layout matches `s0-s1`, `t0-t3`, `u0`, and `b11`. | Keeps runtime descriptor and shader-injection binding aligned with `aliasisolation_taa.cs_5_0.hlsl`. | `taa::EnsureComputePipeline`. |
| Resolve math is RGB-only and the history write remains `RGBR`. | Alpha is original Alias Isolation packing, not independent color data. | Final write in `aliasisolation_taa.cs_5_0.hlsl`. |
| Velocity SRV is owned; depth SRV is borrowed. | Prevents lifetime mistakes when destroying runtime resources. | `taa::EnsureVelocitySrv`, `taa::DestroyVelocitySrv`, borrowed `depth_srv` storage. |
| Cbuffer jitter is fullscreen-only. | Avoids jittering shadow, reflection, and smaller post-processing passes. | `jitter::IsFullscreenPass`. |

## Register And Resource Map

Tracked runtime state:

| State | Source | Stored in | Why it matters |
| --- | --- | --- | --- |
| Screen size | `init_swapchain` | `jitter::render_state.screen_width/height` | Scales jitter offsets and gates fullscreen-only cbuffer patching. |
| Current shader hashes | `renodx::utils::shader` draw-time state | Local variables in `HandleDraw` | Identifies `SmaaVs`, `RgbmEncodeVs`, `RgbmEncodePs`, `DofEncodePs`, and `CameraMotionPs`. |
| Render target 0 | `renodx::utils::state` current render targets | Local value passed to `taa::CaptureCameraMotion` | Supplies camera-motion velocity RTV 0. |
| Viewport | `bind_viewports` | `jitter::render_state` | Part of the fullscreen guard for jitter. |
| SRVs | `push_descriptors` | `CommandListData::pixel_srv_t0`, `pixel_srv_t8` | Supplies color `t0` and depth `t8`. |
| Cbuffers | `push_descriptors` | `CommandListData::vertex_cb_b0`, `vertex_cb_b1`, `pixel_cb_b2` | Finds the game camera cbuffers that will later be patched on map/unmap. |

Known game registers:

| Register/resource | Recognized during | Runtime owner | Used for |
| --- | --- | --- | --- |
| Vertex `b0` | `SmaaVs` | `jitter::tracked.default_xsc` | `DefaultXSC` projection jitter. |
| Vertex `b1` | `RgbmEncodeVs` | `jitter::tracked.default_vsc` | `DefaultVSC` projection jitter. |
| Pixel `b2` | `CameraMotionPs` | `jitter::tracked.default_psc` | Motion-vector and shadow jitter correction. |
| RTV 0 | `CameraMotionPs` | `taa::resources.velocity_resource` plus owned SRV | Velocity input for TAA. |
| Pixel `t8` | `CameraMotionPs` | Borrowed `taa::resources.depth_srv` | Depth input for TAA. |
| Pixel `t0` | `DofEncodePs` or RGBM fallback | Borrowed local `color_srv`; resource is copy-back target | Current HDR color input and resolved-output destination. |

TAA compute registers:

| Register | Shader name | Bound resource / notes |
| --- | --- | --- |
| `s0` | `linear_sampler` | Linear sampler used by optimized Catmull-Rom history reconstruction. |
| `s1` | `point_sampler` | Point sampler used for current-color, velocity, and depth taps. |
| `t0` | `current_color_texture` | Current HDR color SRV from pixel `t0` at the insertion point. |
| `t1` | `previous_history_texture` | Previous ping-pong history SRV. |
| `t2` | `velocity_texture` | SRV created from the camera-motion RTV with the same typed view format. |
| `t3` | `depth_texture` | Borrowed depth SRV captured from camera-motion pixel `t8`. |
| `u0` | `current_history_output` | Current ping-pong history UAV. |
| `b11` | `ShaderInjectData` | RenoDX shader-injection push constants from `shared.h`. |

## Jitter Injection

Alias Isolation jitters the game's camera projection by editing mapped constant
buffers on the CPU. The runtime first identifies the game's camera cbuffers from
known shader/register pairs, then patches mapped data on unmap before the GPU
uses it.

Jitter is tied to successful resolves, not merely to presented frames. If the
runtime misses velocity, depth, or the insertion point, the next frame reuses
the same jitter sample.

| Cbuffer | Tracked from | Main changes | Guards / notes |
| --- | --- | --- | --- |
| `DefaultXSC` | `SmaaVs` vertex `b0` | Caches no-jitter `ViewProj`; updates `SecondaryProj`, `ViewProj`, and `SecondaryViewProj` with `JitterAdd(x, y)`. | Skips planar reflections via identity `SecondaryProj`; skips shadow-like views by comparing reconstructed camera position with `CameraPosition`. |
| `DefaultVSC` | `RgbmEncodeVs` vertex `b1` | Applies jitter to `ProjMatrix`, `PrevViewProj`, and `PrevSecViewProj`. | Uses an existing-jitter check to avoid repeated application. |
| `DefaultPSC` | `CameraMotionPs` pixel `b2` | Rewrites motion matrices, sets `MotionBlurPrevViewProjection` to identity, and removes current jitter from `Spotlight0_Transform`. | Requires current and previous no-jitter view-projection matrices. |

## TAA Dispatch

`aliasisolation::HandleDraw` calls `taa::MaybeRun` only at the known DoF/RGBM
insertion points while Alias Isolation is enabled. `taa::MaybeRun` keeps the
same guards internally so the compute resolve can run at most once per frame.

| Stage | Code path | Requirement | Result if successful |
| --- | --- | --- | --- |
| Choose insertion point | `taa::MaybeRun` | Current draw is `DofEncodePs`, or later `RgbmEncodeVs + RgbmEncodePs` fallback. | Uses pixel `t0` as current HDR color. |
| Validate captured inputs | `taa::Run` | Velocity SRV and depth SRV exist, and `capture_frame == frame_index`. | Prevents stale motion/depth from being used. |
| Validate history | `taa::EnsureHistory` | History size/format matches current color resource. | Reuses history or recreates and seeds both textures from current color. |
| Validate compute state | `taa::EnsureComputePipeline` | Layout, pipeline, and samplers exist. | Creates push-descriptor layout and embedded `__aliasisolation_taa` pipeline. |
| Dispatch compute | `taa::DispatchCompute` | All SRVs/UAVs and samplers are available. | Dispatches `(width + 7) / 8` by `(height + 7) / 8` thread groups. |
| Copy back | `taa::DispatchCompute` | Current history contains resolved output. | Copies current history resource back into the game's color resource. |
| Restore compute state | `taa::DispatchCompute` | Previous compute pipeline/descriptors were captured. | Reapplies compute state without rebinding current graphics draw state. |
| Advance TAA state | `taa::Run` | Dispatch and copy-back succeeded. | Ping-pongs history index and calls `MarkTaaDispatched`. |

Supported history formats:

| Color resource/view case | History resource format | History view format |
| --- | --- | --- |
| `r16g16b16a16_typeless` resource | `r16g16b16a16_typeless` | `r16g16b16a16_float` |
| `r16g16b16a16_float` resource | `r16g16b16a16_float` | `r16g16b16a16_float` |
| `r11g11b10_float` resource | `r11g11b10_float` | `r11g11b10_float` |
| `r16g16b16a16_float` view over another resource | `r16g16b16a16_typeless` | `r16g16b16a16_float` |

## TAA Resolve Shader

`shaders/aliasisolation_taa.cs_5_0.hlsl` is a cleaned-up port of Alias
Isolation's decompiled compute resolve. It runs one thread per output pixel,
derives dimensions from `current_color_texture`, and writes the current resolved
frame to `current_history_output`.

The only intentional functional difference from the original shader body is the
luminance calculation: blend weighting now uses RenoDX `Yf` BT.709 Stockman
luminance instead of the old incorrect BT.601-style luma formula. The rest of
the shader restructuring is meant to preserve behavior, including the final
`RGBR` history write.

## Shader Hash Routing And Replacements

Known draw-pass hashes live in `aliasisolation.hpp::shader_hashes`. During draw
callbacks, `HandleDraw` reads the current RenoDX shader hashes and compares them
against:

- `SMAA_VS`
- `RGBM_ENCODE_VS`
- `RGBM_ENCODE_PS`
- `DOF_ENCODE_PS`
- `CAMERA_MOTION_PS`

The original ASI matched the DXBC header checksum words. This port uses the
same full-bytecode CRC32 identity used by RenoDX dumped shader filenames and
replacement tables.

Replacement hashes are also defined in `shader_hashes`, but their replacement
bytecode is registered in `addon.cpp` through `renodx::mods::shader`:

- `SHADOW_LINEARIZE_PS`
- `SHADOW_DOWNSAMPLE_PS`
- optional `MAIN_POST_VS`
- optional `BLOOM_MERGE_PS`

This means replacement pipeline creation, replacement binding, and pipeline
lifetime are handled by RenoDX's shader utility path instead of Alias
Isolation-specific code.

## Debug Runbook

`ALIENISOLATION_ALIAS_LOGGING` is currently default-enabled in
`runtime/logging.hpp`. When TAA does not run, check this path in order:

| Order | Check | Expected evidence |
| --- | --- | --- |
| 1 | User-facing settings | In-game AA is `SMAA T1x`, Motion Blur is `On`, and RenoDX `Alias Isolation TAA` is enabled. |
| 2 | Shader hash observation | Log lines for observed `SMAA VS`, `RGBM encode VS`, `RGBM encode PS`, `DoF encode PS`, and `camera motion PS` hashes. |
| 3 | Replacement gates | Log lines like `using mods::shader replacement shadow linearize PS` while Alias Isolation is enabled. |
| 4 | Cbuffer tracking | `jitter::CaptureConstantBuffers` tracks `DefaultXSC`, `DefaultVSC`, and `DefaultPSC` from `b0`, `b1`, and `b2`. |
| 5 | Camera-motion capture | `taa::CaptureCameraMotion` sees RTV 0 and pixel `t8` during `CameraMotionPs`. |
| 6 | Insertion point | `taa::MaybeRun` reaches `DofEncodePs`, or the RGBM fallback, with pixel `t0` color SRV. |
| 7 | Same-frame validation | Camera-motion `capture_frame` matches the insertion frame. |
| 8 | History setup | `taa::EnsureHistory` accepts the color format and creates history at the expected resolution. |
| 9 | Compute dispatch | `taa::DispatchCompute` creates the compute layout/pipeline, dispatches once, and copies history back to game color. |
| 10 | Final shader path | Final SMAA T1x Alias branch is active and not falling through to vanilla SMAA blending. |

Stale camera-motion warnings can appear during pause/menu/toggle transitions.
They are acceptable if capture and dispatch resume afterward.

## Change Checklist

| Change area | Must update / preserve |
| --- | --- |
| Shader identity | Update CRC32 constants in `aliasisolation.hpp::shader_hashes` and verify observed-hash logs. |
| Replacement shaders | Update the `custom_shaders` entries in `addon.cpp` and keep `.on_replace` toggle gating plus `.on_inject` suppression. |
| Game register assumptions | Update the register map and fixed fields in `descriptor_tracker::CommandListData`. |
| TAA shader registers | Update `taa::EnsureComputePipeline`, `taa::DispatchCompute`, shader declarations, and the compute register map together. |
| TAA resolve math | Preserve the intentional `float3` resolve path and final `RGBR` write unless copy-back/output assumptions are also changed. |
| Resource formats | Update `taa::GetSupportedHistoryFormat` and history creation/copy-back assumptions. |
| Insertion point | Preserve once-per-frame dispatch, same-frame velocity/depth validation, compute-state restore, and draw-hook return value. |
| Jitter behavior | Preserve fullscreen gating and keep no-jitter matrix state separate from patched game matrices. |

For a quick code-reading path, start at `aliasisolation.hpp::HandleDraw`, then
read `taa.hpp::CaptureCameraMotion`, `taa.hpp::MaybeRun`, `jitter.hpp`, and the
compute shader in `shaders/aliasisolation_taa.cs_5_0.hlsl`.
