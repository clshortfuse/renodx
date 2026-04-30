# Alias Isolation TAA Implementation

This folder contains the RenoDX port of Alias Isolation's temporal anti-aliasing
for `src/games/alienisolation`. The integration is intentionally self-contained:
`addon.cpp` includes `aliasisolation/aliasisolation.hpp`, and all game-specific
TAA, jitter, shader identification, descriptor tracking, and helper fixes live
under `aliasisolation/runtime`.

The runtime depends on two in-game settings:

- Anti-aliasing: `SMAA T1x`
- Motion Blur: `On`

`SMAA T1x` gives this port the final AA shader branch it expects, and motion
blur keeps the game's camera-motion pass active so Alias Isolation can reuse the
velocity target.

## File Map

| File | Role |
| --- | --- |
| `aliasisolation.hpp` | Public entry point used by `addon.cpp`; adds settings, registers ReShade callbacks, and routes draw events to jitter/TAA. |
| `runtime/constant_buffers.hpp` | Shared master enable binding, frame counters, TAA sample index, and Alias Isolation's Hammersley jitter sequence. |
| `runtime/descriptor_tracker.hpp` | Reconstructs D3D11-style bound SRVs, cbuffers, RTVs, viewports, and current shader IDs from ReShade callbacks. |
| `runtime/jitter.hpp` | Tracks game camera cbuffers, patches mapped data on unmap, stores current/previous no-jitter matrices, and applies the per-frame projection jitter. |
| `runtime/taa.hpp` | Captures velocity/depth/color resources, owns history textures and compute state, dispatches the TAA compute shader, and copies the result back into the game's color resource. |
| `runtime/pipeline_tracker.hpp` | Detects important game pipelines by DXBC checksum and tracks which shader IDs are currently bound. |
| `runtime/pipeline_replacer.hpp` | Clones pipelines for Alias Isolation's non-TAA shader replacements, such as the shadow fixes. |
| `runtime/resource_view_sanitizer.hpp` | Fills missing Texture3D resource-view descriptions before RenoDX's resource upgrade helpers inspect them. |
| `runtime/shader_ids.hpp` | DXBC checksum table for the game passes this port recognizes. |
| `shaders/aliasisolation_taa.cs_5_0.hlsl` | Embedded compute shader that performs the temporal resolve. |

## How It Hooks Into `addon.cpp`

`addon.cpp` touches Alias Isolation in four places:

1. It includes `./aliasisolation/aliasisolation.hpp`.
2. During `DLL_PROCESS_ATTACH`, it calls
   `alienisolation::aliasisolation::AppendSettings(settings, &shader_injection)`.
   This inserts the `Alias Isolation` settings section and binds the toggle to
   `ShaderInjectData::custom_alias_isolation_taa`.
3. The main preset reset calls
   `alienisolation::aliasisolation::OnPresetOff()`, which disables Alias
   Isolation TAA and sharpening.
4. At the end of `DllMain`, it calls
   `alienisolation::aliasisolation::Use(fdw_reason, &shader_injection)` for both
   attach and detach. That function registers or unregisters all ReShade
   callbacks owned by this folder.

The main addon also sets up the larger Alien: Isolation HDR path that Alias
Isolation runs inside:

- `renodx::mods::swapchain::use_resource_cloning = true`
- Back-buffer-sized `b8g8r8a8_typeless` and `r8g8b8a8_typeless` resources are
  upgraded to `r16g16b16a16_typeless`.
- Tonemap, SMAA, and final shaders use `UpgradeRTVReplaceShader(...)` so their
  render targets are hot-swapped to the upgraded resources.
- `antialiasing/final_SMAA_T1x_0x05F61FE8.ps_5_0.hlsl` has a special
  `custom_alias_isolation_taa > 0` branch. When Alias Isolation is on, that final pass
  samples the already-resolved color, optionally applies RCAS sharpening, applies
  film grain, and skips the vanilla SMAA blend.

The Alias Isolation runtime does not use RenoDX's CRC32 custom shader replacement
for the TAA pass. The compute shader is compiled by the normal CMake shader
embedding path into `__aliasisolation_taa`, then `taa.hpp` creates and dispatches
the compute pipeline manually.

## Callback Wiring

`aliasisolation::Use` registers these ReShade callbacks:

| Callback | Owner | Purpose |
| --- | --- | --- |
| `init_swapchain` / `destroy_swapchain` | `jitter` | Cache/reset the screen size used for jitter scaling. |
| `init_command_list` / `destroy_command_list` / `reset_command_list` | `descriptor_tracker` | Maintain per-command-list binding state. |
| `create_resource_view` | `resource_view_sanitizer` | Normalize unknown Texture3D view descriptions. |
| `init_pipeline` / `destroy_pipeline` | `pipeline_replacer`, `pipeline_tracker` | Identify game shaders by DXBC checksum and create replacement pipelines where needed. |
| `bind_pipeline` | `pipeline_replacer`, `descriptor_tracker` | Rebind replacement pipelines when enabled and track current shader IDs. |
| `bind_render_targets_and_depth_stencil` | `jitter`, `descriptor_tracker` | Track fullscreen render state and current RTVs. |
| `bind_viewports` | `jitter`, `descriptor_tracker` | Track fullscreen viewport state. |
| `push_descriptors` | `descriptor_tracker` | Map ReShade descriptor updates back to shader registers like `t0`, `t8`, `b0`, `b1`, and `b2`. |
| `map_buffer_region` / `unmap_buffer_region` | `jitter` | Patch tracked camera cbuffers after the game writes them. |
| `draw`, `draw_indexed`, `draw_or_dispatch_indirect` | `aliasisolation.hpp` | Run the draw-driven capture and TAA insertion logic. |
| `destroy_device` | `aliasisolation.hpp` | Destroy history, compute objects, replacement pipelines, and jitter state. |
| `present` | `aliasisolation.hpp` | Advance frame state after the frame is presented. |

The draw callbacks all call `HandleDraw`. If Alias Isolation is disabled,
`HandleDraw` returns without changing the command list.

## Frame Flow

The TAA insertion point is draw-driven. ReShade calls the draw hook before the
game draw executes, so the runtime dispatches compute, copies the resolved result
back into the color texture that the upcoming draw will sample, restores the
previous graphics state, and then lets the original draw continue.

| Phase | Trigger | Code path | Reads | Writes / side effects |
| --- | --- | --- | --- | --- |
| Startup | `addon.cpp::DllMain` | `AppendSettings`, then `aliasisolation::Use` | `ShaderInjectData` pointer | Adds settings, binds `custom_alias_isolation_taa`, registers Alias Isolation callbacks. |
| Pipeline identity | `init_pipeline`, `bind_pipeline` | `pipeline_tracker`, `pipeline_replacer` | Pipeline shader bytecode | Records `ShaderId`s by DXBC checksum and binds replacement pipelines when enabled. |
| Descriptor tracking | RTV/viewport binds and `push_descriptors` | `descriptor_tracker` | ReShade descriptor updates | Reconstructs per-command-list D3D11-style shader registers, RTVs, and viewport state. |
| Cbuffer capture | Draw callback | `jitter::CaptureConstantBuffers` | Current `ShaderId`s and cbuffer registers | Tracks `DefaultXSC`, `DefaultVSC`, and `DefaultPSC` resources for later map/unmap patching. |
| Jitter patch | `map_buffer_region`, `unmap_buffer_region` | `jitter::OnMapBufferRegion`, `jitter::OnUnmapBufferRegion` | Mapped tracked cbuffers, fullscreen render state | Patches projection/motion/shadow matrices before the GPU consumes them. |
| Camera-motion capture | Draw using `CameraMotionPs` | `taa::CaptureCameraMotion` | RTV 0 and pixel `t8` | Creates/reuses velocity SRV, stores depth SRV, records capture frame. |
| TAA insertion | Draw using `DofEncodePs`, or RGBM fallback | `taa::MaybeRun`, `taa::Run` | Pixel `t0`, velocity, depth, previous history | Validates same-frame inputs, dispatches compute, copies current history back into game color. |
| Original post draw | Hook returns `false` | Game draw continues | Resolved game color resource | Upcoming draw samples resolved color normally. |
| Frame advance | `present` | `jitter::FinishFrame`, `constant_buffers::BeginFrame` | Current no-jitter matrix, TAA dispatch flag | Promotes previous matrix state, increments frame index, clears per-frame TAA flag. |

## Critical Invariants

These are the assumptions that keep the port stable. Treat them as regression
checks when changing the TAA path.

| Invariant | Why it matters | Enforced by |
| --- | --- | --- |
| TAA dispatches at most once per frame. | Prevents multiple history writes and multiple jitter sample advances in one frame. | `frame_state.taa_ran_this_frame` in `taa::MaybeRun`. |
| `taa_sample_index` advances only after dispatch and copy-back succeed. | Keeps camera jitter synchronized with valid history. | `constant_buffers::MarkTaaDispatched`. |
| Velocity/depth capture is same-frame as insertion. | Avoids reprojecting with stale motion/depth. | `taa::resources.capture_frame` check in `taa::Run`. |
| `CameraMotionPs` capture happens before DoF/RGBM insertion. | The resolve needs velocity and depth before it can run. | Game pass order plus `taa::Run` input validation. |
| Draw hooks return `false`. | Lets the original game draw continue after the pre-draw compute insertion. | `aliasisolation::HandleDraw`. |
| Graphics state is restored after compute dispatch. | Prevents the manual compute pass from corrupting the following graphics draw. | `renodx::utils::state::CommandListState` restore in `taa::DispatchCompute`. |
| Compute layout matches `s0-s1`, `t0-t3`, `u0`, and `b11`. | Keeps runtime descriptor and shader-injection binding aligned with `aliasisolation_taa.cs_5_0.hlsl`. | `taa::EnsureComputePipeline`. |
| Resolve math is RGB-only and the history write remains `RGBR`. | Alpha is original Alias Isolation packing, not independent resolved color data. | Final write in `aliasisolation_taa.cs_5_0.hlsl`. |
| Velocity SRV is owned; depth SRV is borrowed. | Prevents lifetime mistakes when destroying runtime resources. | `taa::EnsureVelocitySrv`, `taa::DestroyVelocitySrv`, borrowed `depth_srv` storage. |
| History matches color size and format. | Keeps copy-back valid and avoids format reinterpretation bugs. | `taa::EnsureHistory`. |
| Cbuffer jitter is fullscreen-only. | Avoids jittering shadow, reflection, and smaller post-processing passes. | `jitter::IsFullscreenPass`. |

## Register And Resource Map

Tracked game state:

| State | Source callback | Stored in | Why it matters |
| --- | --- | --- | --- |
| Screen size | `init_swapchain` | `jitter::render_state.screen_width/height` | Scales jitter offsets and gates fullscreen-only cbuffer patching. |
| Current shader IDs | `init_pipeline`, `bind_pipeline` | `CommandListData::shaders` | Identifies `SmaaVs`, `RgbmEncodeVs`, `RgbmEncodePs`, `DofEncodePs`, and `CameraMotionPs`. |
| Render targets | `bind_render_targets_and_depth_stencil` | `CommandListData::render_targets` | Supplies camera-motion RTV 0 and validates fullscreen cbuffer patching. |
| Viewport | `bind_viewports` | `CommandListData::viewports` | Part of the fullscreen guard for jitter. |
| SRVs | `push_descriptors` | `CommandListData::*_srvs` | Supplies color `t0` and depth `t8`. |
| Cbuffers | `push_descriptors` | `CommandListData::*_cbs` | Finds the game camera cbuffers that will later be patched on map/unmap. |

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
| `s0` | `linear_sampler` | Linear sampler used by the optimized Catmull-Rom history reconstruction. |
| `s1` | `point_sampler` | Point sampler used for current-color, velocity, and depth neighborhood taps. |
| `t0` | `current_color_texture` | Current HDR color SRV from pixel `t0` at the insertion point. Its dimensions drive the dispatch bounds. |
| `t1` | `previous_history_texture` | Previous ping-pong history SRV, using the supported history view format. |
| `t2` | `velocity_texture` | SRV created from the camera-motion RTV with the same typed view format as the RTV. |
| `t3` | `depth_texture` | Borrowed depth SRV captured from camera-motion pixel `t8`. |
| `u0` | `current_history_output` | Current ping-pong history UAV. The shader writes `float4(resolved.rgb, resolved.r)`. |
| `b11` | `ShaderInjectData` | RenoDX shader-injection push constants from `shared.h`. |

Owned TAA resources:

| Resource | Created by | Lifetime notes |
| --- | --- | --- |
| Two history textures with SRV/UAV views | `taa::EnsureHistory` | Recreated when resolution or HDR format changes. Seeded from the current color resource on creation. |
| Velocity SRV | `taa::EnsureVelocitySrv` | Recreated when the velocity resource or typed view format changes. |
| Compute pipeline layout, pipeline, and samplers | `taa::EnsureComputePipeline` | Destroyed on device destruction or TAA resource teardown. |

## Jitter Injection

Alias Isolation jitters the game's camera projection by editing mapped constant
buffers on the CPU. The runtime first identifies the game's camera cbuffers from
known shader/register pairs, then patches mapped data on unmap before the GPU
uses it.

> **Key behavior:** Jitter is tied to successful resolves, not merely to
> presented frames. If the runtime misses velocity, depth, or the insertion
> point, the next frame reuses the same jitter sample.

Jitter sample generation:

| Step | Operation | Formula / code | Result |
| --- | --- | --- | --- |
| Pick sample | Permute a 16-sample sequence. | `sample = (taa_sample_index * 7) % 16` | Reorders samples to avoid walking the pattern linearly. |
| Compute normalized X | Place X at the center of one of 16 bins. | `(sample + 0.5) / 16` | Normalized horizontal sample. |
| Compute normalized Y | Use the Alias Isolation Hammersley radical inverse. | `HammersleySample(sample, 238308531)` | Normalized vertical sample. |
| Convert to projection offset | Center around zero and scale by screen dimensions. | `(value - 0.5) * 2 / width_or_height` | Clip/projection-space jitter offset. |
| Hold sample when needed | Return zero after TAA already ran this frame; do not advance on missed resolves. | `CurrentFrameJitter`, `MarkTaaDispatched` | Keeps camera jitter and history in sync. |

Cbuffer patch pipeline:

| Stage | Code path | Condition | Effect |
| --- | --- | --- | --- |
| Track cbuffer resource | `jitter::CaptureConstantBuffers` | Current draw uses a known shader/register pair. | Stores `DefaultXSC`, `DefaultVSC`, or `DefaultPSC` resource handles. |
| Observe map | `jitter::OnMapBufferRegion` | Mapped resource matches a tracked cbuffer. | Records mapped pointer, kind, and size. |
| Guard patch | `jitter::IsFullscreenPass` | RTV and viewport match the swapchain size. | Allows camera-pass patching and rejects shadow/reflection/smaller passes. |
| Patch data | `jitter::OnUnmapBufferRegion` | Tracked mapped buffer passes size and fullscreen checks. | Applies jitter or velocity/shadow matrix fixes before GPU use. |
| Advance matrix state | `jitter::FinishFrame` during present | Current no-jitter view-projection was captured. | Promotes current no-jitter matrix to previous-frame state. |

Patched cbuffers:

| Cbuffer | Tracked from | Main changes | Guards / notes |
| --- | --- | --- | --- |
| `DefaultXSC` | `SmaaVs` vertex `b0` | Caches no-jitter `ViewProj`; updates `SecondaryProj`, `ViewProj`, and `SecondaryViewProj` with `JitterAdd(x, y)`. | Skips planar reflections via identity `SecondaryProj`; skips shadow-like views by comparing reconstructed camera position with `CameraPosition`. |
| `DefaultVSC` | `RgbmEncodeVs` vertex `b1` | Applies jitter to `ProjMatrix`, `PrevViewProj`, and `PrevSecViewProj`. | Uses a simple existing-jitter check to avoid repeated application. |
| `DefaultPSC` | `CameraMotionPs` pixel `b2` | Rewrites motion matrices so `MotionBlurCurrInvViewProjection = curr_inv_view_proj_no_jitter * prev_view_proj_no_jitter`, sets `MotionBlurPrevViewProjection` to identity, and removes current jitter from `Spotlight0_Transform`. | Requires current and previous no-jitter view-projection matrices. Stabilizes velocity vectors and shadows. |

During `aliasisolation::OnPresent`, `jitter::FinishFrame` runs before
`constant_buffers::BeginFrame`. `BeginFrame` increments the frame index and
clears `taa_ran_this_frame`.

## TAA Dispatch

`taa::MaybeRun` is called from every draw hook while Alias Isolation is enabled,
but the guards below make the compute resolve run at most once per frame.

Dispatch sequence:

| Stage | Code path | Requirement | Result if successful |
| --- | --- | --- | --- |
| Choose insertion point | `taa::MaybeRun` | Current draw is `DofEncodePs`, or later `RgbmEncodeVs + RgbmEncodePs` fallback. | Uses pixel `t0` as current HDR color. |
| Reject duplicates | `taa::MaybeRun` | `frame_state.taa_ran_this_frame` is false. | Allows one resolve attempt for the frame. |
| Validate captured inputs | `taa::Run` | Velocity SRV and depth SRV exist, and `capture_frame == frame_index`. | Prevents stale motion/depth from being used. |
| Validate history | `taa::EnsureHistory` | History size/format matches current color resource. | Reuses history or recreates and seeds both textures from current color. |
| Validate compute state | `taa::EnsureComputePipeline` | Layout, pipeline, and samplers exist. | Creates push-descriptor layout for `s0-s1`, `t0-t3`, `u0`, push constants for `b11`, and the embedded `__aliasisolation_taa` pipeline. |
| Dispatch compute | `taa::DispatchCompute` | All SRVs/UAVs and samplers are available. | Dispatches `(width + 7) / 8` by `(height + 7) / 8` thread groups. |
| Copy back | `taa::DispatchCompute` | Current history contains resolved output. | Copies current history resource back into the game's color resource. |
| Restore draw state | `taa::DispatchCompute` | Previous graphics state was captured. | Reapplies the state so the original game draw continues normally. |
| Advance TAA state | `taa::Run` | Dispatch and copy-back succeeded. | Ping-pongs history index and calls `MarkTaaDispatched`. |

Supported history formats:

| Color resource/view case | History resource format | History view format |
| --- | --- | --- |
| `r16g16b16a16_typeless` resource | `r16g16b16a16_typeless` | `r16g16b16a16_float` |
| `r16g16b16a16_float` resource | `r16g16b16a16_float` | `r16g16b16a16_float` |
| `r11g11b10_float` resource | `r11g11b10_float` | `r11g11b10_float` |
| `r16g16b16a16_float` view over another resource | `r16g16b16a16_typeless` | `r16g16b16a16_float` |

Resource transitions around dispatch:

| Resource | Before compute | During compute / copy | Restored to |
| --- | --- | --- | --- |
| Velocity resource | Render target | Shader resource | Render target |
| Current history | Shader resource | UAV, then copy source | Shader resource |
| Game color resource | Shader resource | Copy destination | Shader resource |

## TAA Resolve Algorithm

`shaders/aliasisolation_taa.cs_5_0.hlsl` is a cleaned-up port of Alias
Isolation's decompiled compute resolve. It runs one thread per output pixel,
derives dimensions from `current_color_texture`, and writes the current resolved
frame to `current_history_output`. The shader includes `shared.h`, so RenoDX
helpers and `ShaderInjectData` are available through `b11`, but the current
resolve path does not rely on runtime debug variants.

Current-frame filtering and bounds are built together in
`BuildCurrentNeighborhood`:

| Item | Details |
| --- | --- |
| Current filter | Full 3x3 point-sampled neighborhood. Center weight is `1`, cardinal weights are `exp(-2.29)`, diagonal weights are `exp(-2.29 * 2)`, and normalization is about `0.691522062`. |
| Broad bounds | Min/max over the full 3x3 neighborhood. |
| Tight bounds | Min/max over the center-plus-cardinals cross. |
| Final clip box | Halfway between broad and tight bounds: `broad + 0.5 * (tight - broad)`. |
| Representation | `CurrentTap` stores each tap's offset, weight, and whether it participates in tight bounds. `CurrentNeighborhood` returns filtered RGB plus clip min/max RGB. |

Per-pixel resolve:

| Step | Operation | Inputs | Output | Purpose |
| --- | --- | --- | --- | --- |
| 1 | Build current UV | `SV_DispatchThreadID`, current color dimensions | Pixel-center UV | Locates the output pixel in normalized texture space. |
| 2 | Build current neighborhood | `current_color_texture`, `point_sampler` | Filtered current RGB and clip bounds | Gives the resolve local color context. |
| 3 | Choose velocity | `velocity_texture`, `depth_texture`, center plus diagonal taps | Depth-guided velocity | Uses the velocity from the nearest absolute depth to reduce foreground/background bleed. |
| 4 | Reproject history | Current UV and chosen velocity | Previous-frame UV | Finds where the current pixel came from in history. |
| 5 | Sample history | Previous UV, `previous_history_texture`, `linear_sampler` | Historical RGB or filtered-current fallback | Uses a nine-tap optimized Catmull-Rom reconstruction when the reprojected UV is on screen. |
| 6 | Clip history | Historical RGB, filtered current RGB, current clip bounds | Clipped historical RGB | Clips history toward the filtered current color inside the RGB color box. |
| 7 | Compute blend | RenoDX `Yf` from BT.709, clip bounds, velocity/subpixel terms | Current-frame blend amount | Keeps more history when it is plausibly inside the luma range and adjusts for subpixel velocity. |
| 8 | Resolve color | Clipped history, filtered current, blend | Resolved RGB | `max(0, lerp(clipped_history, filtered_current, blend))`; there is no upper clamp. |
| 9 | Write history | Resolved RGB | `current_history_output` | Writes `RGBR` as `float4(resolved_color, resolved_color.r)` to preserve the original packed behavior. |

History clipping is RGB-only. The alpha lane is ignored during the resolve and
only restored at the final write by duplicating red into alpha, matching the
original compute output packing.

After the dispatch, `taa::DispatchCompute` copies `current_history_output`'s
resource back into the game color resource that the original post-processing
draw is about to sample. That is why the original draw can continue normally
after the hook returns.

## Pipeline Tracking And Replacements

The Alias Isolation port identifies game shaders by DXBC checksum words in
`shader_ids.hpp`. These checksums are the DXBC header checksum used by the
original ASI, not the CRC32 names used by RenoDX dumped shader files.

`pipeline_tracker` records shader IDs when pipelines are created and maintains
the currently bound shader IDs per command list. The descriptor tracker stores
those IDs in `CommandListData::shaders`, which is why `taa.hpp` can ask questions
like "is the current pixel shader `CameraMotionPs`?" during a draw callback.

`pipeline_replacer` handles non-TAA Alias Isolation shader fixes. It clones a
pipeline when a known replaceable shader is found and swaps in embedded Alias
Isolation bytecode for the clone. At bind time, if Alias Isolation is enabled, it
binds the clone instead of the original pipeline. The always-enabled replacement
paths are the shadow linearize/downsample pixel shaders. Barrel distortion
removal and bloom merge replacement are compile-time options and default to off
in `runtime/config.hpp`.

## Debug Runbook

Define `ALIENISOLATION_ALIAS_LOGGING` to enable detailed runtime logging. When
TAA does not run, check this path in order:

| Order | Check | Expected evidence |
| --- | --- | --- |
| 1 | User-facing settings | In-game AA is `SMAA T1x`, Motion Blur is `On`, and RenoDX `Alias Isolation TAA` is enabled. |
| 2 | Shader detection | `shader_ids.hpp` identifies `SmaaVs`, `RgbmEncodeVs`, `RgbmEncodePs`, `DofEncodePs`, and `CameraMotionPs`. |
| 3 | Cbuffer tracking | `jitter::CaptureConstantBuffers` tracks `DefaultXSC`, `DefaultVSC`, and `DefaultPSC` from `b0`, `b1`, and `b2`. |
| 4 | Camera-motion capture | `taa::CaptureCameraMotion` sees RTV 0 and pixel `t8` during `CameraMotionPs`. |
| 5 | Insertion point | `taa::MaybeRun` reaches `DofEncodePs`, or the RGBM fallback, with pixel `t0` color SRV. |
| 6 | Same-frame validation | Camera-motion `capture_frame` matches the insertion frame. |
| 7 | History setup | `taa::EnsureHistory` accepts the color format and creates history at the expected resolution. |
| 8 | Compute dispatch | `taa::DispatchCompute` creates the compute layout/pipeline, dispatches once, and copies history back to game color. |
| 9 | Final shader path | Final SMAA T1x Alias branch is active and not falling through to vanilla SMAA blending. |

If the image jitters, flickers, or drifts:

| Symptom | First checks |
| --- | --- |
| Camera jitter advances but history does not stabilize | Confirm `taa_sample_index` advances only after successful copy-back. |
| Shadows, reflections, or small passes flicker | Confirm the fullscreen guard is not patching non-camera passes. |
| Motion-vector instability | Check `DefaultPSC` patching and same-frame velocity/depth capture. |
| Previous-frame reprojection feels wrong | Confirm `jitter::FinishFrame` receives a valid current no-jitter matrix before promoting it to previous-frame state. |

## Change Checklist

Before changing this integration, verify the affected item against the current
code:

| Change area | Must update / preserve |
| --- | --- |
| Shader identity | Update `shader_ids.hpp` checksums and verify `pipeline_tracker` detections. |
| Game register assumptions | Update the register map and every access through `descriptor_tracker::GetView` or `GetBufferRange`. |
| TAA shader registers | Update `taa::EnsureComputePipeline`, `taa::DispatchCompute`, shader declarations, and the TAA compute register map together. |
| TAA resolve math | Preserve the intentional `float3` resolve path and final `RGBR` write unless the runtime copy-back/output assumptions are also changed. |
| Resource formats | Update `taa::GetSupportedHistoryFormat` and history creation/copy-back assumptions. |
| Insertion point | Preserve once-per-frame dispatch, same-frame velocity/depth validation, graphics-state restore, and draw-hook return value. |
| Jitter behavior | Preserve fullscreen gating and keep no-jitter matrix state separate from patched game matrices. |

For a quick code-reading path, start at `aliasisolation.hpp::HandleDraw`, then
read `taa.hpp::CaptureCameraMotion`, `taa.hpp::MaybeRun`, `jitter.hpp`, and the
compute shader in `shaders/aliasisolation_taa.cs_5_0.hlsl`.
