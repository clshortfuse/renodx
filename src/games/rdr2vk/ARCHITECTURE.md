# RDR2 Vulkan architecture

The mod keeps HDR scene detail through the game's effects, gives the scene and the interface separate brightness, and converts the result to HDR10. The C++ code decides where to record the extra drawing work and how long its GPU objects live; the shaders do the color math.

The [README](README.md) covers setup, status, and the checks still owed in the game. This file covers how the code is organized and the rules it relies on.

## Terms

| Term | Meaning |
|---|---|
| Recording | The CPU writes instructions for the GPU to run later. Several CPU threads can record at once, in a different order from the one in which their work is submitted. |
| Command list | A recorded batch of GPU instructions; Vulkan calls it a command buffer. A secondary list is a batch run from inside another list. |
| Submit | Hands recorded lists to a GPU queue. `VK_SUCCESS` means Vulkan accepted them, not that the GPU has run them. |
| View | Describes how an operation reads or writes a texture or buffer. It is not a copy, and destroying it does not free the storage. |
| Render pass | A group of draws into the same targets, which says whether existing contents are kept (`LOAD`) or cleared. |
| Pipeline / layout | A pipeline is the drawing configuration (shaders, blending, tests). Its layout lists the resource and settings slots the shaders use. |
| Descriptor | Identifies a view or data range for a shader slot. Push descriptors are supplied directly instead of being allocated from a shared pool. |
| Graphics snapshot | The saved drawing configuration, not saved pixels. |
| Backbuffer / swapchain | A swapchain cycles through a few output images, the backbuffers. Acquiring one grants its use; the GPU may still be waiting on it. |
| Clone | The RGBA16F copy of a backbuffer that the game draws into instead, so values above SDR white survive until HDR10 encoding. |
| Barrier | Orders GPU accesses to a resource. Recording one does not make the CPU wait. |
| Owner / borrower | An owner must clean an object up. A borrower may use it only while it is alive. A handle value can be reused for a new object after the old one is destroyed. |

## Files

```mermaid
flowchart TD
    A["addon.cpp: settings and setup order"] --> H["vulkan_hooks.hpp: acquire, begin and submit hooks"]
    H --> S["scene_tracking.hpp: what each recording drew"]
    S --> O["output.hpp: per-backbuffer GPU objects and final output"]
    O --> C["Shared RenoDX: rendering, clones, state and resources"]
    A --> P["resource_fixes / pipeline_layouts: narrow policies"]
    P --> C
    H --> L["vulkan_types / shared.h: shared declarations"]
```

Dependencies run one way: `addon -> vulkan_hooks -> scene_tracking -> output -> shared RenoDX`. The hooks own their original function pointers, not GPU objects.

| Entry point (namespace `rdr2vk`) | What it does |
|---|---|
| `output::Use(reason)` | Registers the swapchain, presentation, and cleanup callbacks. Uses the shared swapchain setup but replaces its final present step. |
| `output::RenderSceneBrightness(...)` | Records the scene copy and the brightness draw. The caller holds the swapchain state lock and knows the image's current usage. |
| `output::OnAcquireBackBuffer(...)` | Starts a new use of an image after a successful acquire and clears what was known about its previous use. |
| `output::GetDeviceSwapchains(...)` | Copies the swapchain owners for a device. Callers lock and recheck each one before use. |
| `scene_tracking::Use(reason)` | Registers the recording, classification, and submission callbacks and turns on descriptor binding history. |
| `scene_tracking::OnBeforeUIDraw(...)` | At the first real UI draw onto a backbuffer, records a brightness pass in front of it when that is safe. |
| `scene_tracking::OnSceneDrawRecorded(...)` | Notes that a scene draw was recorded. |
| `scene_tracking::RecordingScope` | Keeps the command buffer's begin flags available during the original begin call. |
| `scene_tracking::SubmissionScope` / `PublishSubmission(...)` | Collect decisions made during one submit call and keep them only if the submit returns `VK_SUCCESS`. |
| `vulkan_hooks::Use(reason)` | Installs and removes the native acquire, begin, and submit hooks. They forward every argument and result unchanged. |

`vulkan_types.hpp` declares the few Vulkan types the hooks need, with size and offset checks, so the mod does not need the Vulkan SDK.

## From recording to output

```mermaid
flowchart TD
    A["Acquire succeeds: start a new image use"] --> B["Begin: keep flags, reset recording facts"]
    B --> C["Threads record scene and UI draws"]
    C --> D["Before the first UI draw: record a brightness pass, disabled"]
    D --> E["Submit: merge lists, choose a pass in submit order"]
    E --> F{"Original submit returns VK_SUCCESS?"}
    F -->|Yes| G["Keep the facts; output handles scene-only frames"]
    F -->|No| X["Drop the facts; mark this image use as failed"]
    G --> I["Present: final UI Brightness scaling and HDR10"]
```

Acquire calls `output::OnAcquireBackBuffer` for `VK_SUCCESS` and `VK_SUBOPTIMAL_KHR`. ReShade runs its list callbacks inside the original submit, before its result is known, so decisions made there stay tentative until `PublishSubmission`. The present callback records the final output on ReShade's immediate command list.

### Scene brightness and UI brightness

Let `G` be Game Brightness and `U` UI Brightness. After the scene is complete and before the first real UI draw onto the backbuffer, the brightness pass multiplies the decoded scene by `G / U`. The game then draws its UI as usual. Final output multiplies everything by `U` and encodes BT.2020 PQ. The scene ends up at `G` and the UI at `U`. Alpha is left unchanged.

Until final output, the image is encoded BT.709 in the RGBA16F clone, which keeps negative and above-one values. Decoding uses gamma 2.2 when SDR EOTF Emulation is on and sRGB otherwise; PsychoV turns the emulation off.

| Shader rule | Reason |
|---|---|
| `0xFCD82342` is UI. | Only a real UI draw onto the backbuffer marks where scene brightness goes. |
| `0x2C748C70` is scene composition. | Its pause blending must finish before `G / U`; scaling its inputs would change the blend. |
| Offscreen `0x071AB204` pause-background copies are not the UI boundary. | Pause processing and the background copy are still part of the scene. |
| FXAA `0x599298B6` is scene output. | It can follow a tone mapper recorded in another list. |
| Copy `0x1FC46AC9`, MSAA copy `0xF60E4A26`, and TAA sharpening `0xEF9E7CFC` count as scene only with a known scene source. | They also serve menus. Copies read set 1 binding 186; sharpening reads binding 156. |
| Draws that write only alpha or stencil are not UI. | The RGB write mask decides, including dynamic masks. An unknown mask is treated as unknown. |

Scene sources are resolved from the shared resource records of live views, never by asking the driver about a view that may be gone. When a source resource is destroyed, it leaves the source history, so a reused handle cannot pass as a scene source. Destruction also advances a counter; if it moved while a submit was in flight, that submit does not restore its pending source list.

### Why the brightness pass is recorded disabled

A thread can record UI before another records the scene, so recording time cannot decide which pass runs. Each suitable list records its own pass with its own settings upload and `scene_brightness_enabled = 0`. During submission, the first pass that follows scene work in submit order is switched on. The others stay off, but with unequal brightness they still contain a full-screen copy and draw.

Facts from secondary lists are merged into their parent before that choice.

With equal brightness the pass is not recorded at all. If accepted work has a scene but no UI, presentation runs `output::RenderSceneBrightness` before the final output, writing its settings through an update command so that no buffer still in use on the GPU is overwritten.

A stale acquire, a scene drawn after the UI, a pass selected twice, a queue change, or a pass that could not be recorded turns separation off for that image use and logs the reason once per backbuffer. A later failure can still switch off a pass selected earlier in the same submit, but not work an earlier submit already handed over.

### Interrupting the game's pass before the UI

`scene_tracking::OnBeforeUIDraw` makes the decisions; `output::RenderSceneBrightness` records the GPU work.

1. Confirm the target is the backbuffer clone, the draw writes RGB, the image use is current, and the list can be interrupted.
2. Require one color target, stored color, depth and stencil, no active queries, and push descriptor support. Never interrupt a list that continues its parent's render pass, a list that may run more than once at the same time, or one whose begin flags are unknown.
3. Save the graphics snapshot, including pipeline bindings, and the attachment descriptions. Prepare this list's settings upload in the `shared.h` layout.
4. Apply pending clears, end the game's pass, and record the scene copy and brightness draw.
5. Resume the game's attachments with `LOAD` and zero clear values, restore the snapshot, and let the UI draw continue.

Where ReShade caches render passes, the clear values are part of the cache key; fixed zeros keep it from adding an entry each time the game's clear color changes.

## Swapchain lifetime

```mermaid
flowchart TD
    A["Shared swapchain setup"] --> B["Init: retire any earlier state for this swapchain"]
    B --> C["Check images; create the shared float clones"]
    C --> D["Create passes, scene copy, views, settings buffer, sampler"]
    D -->|Ready| E["Publish the state"]
    C -->|Failure| F["Close the state under its lock"]
    D -->|Failure| F
    E -->|Destroy or recreate| F
    F --> G["Unlock; wait for the queue to go idle"]
    G --> H["Destroy the mod's GPU objects; leave borrowed images alone"]
    H -->|Recreate| A
```

Every init is a new lifetime, even when Vulkan reuses the swapchain pointer and reports `resize == false`. Each backbuffer entry is bound to one backbuffer and one clone for its whole life. Retirement closes the state and takes its entries under the lock, then waits for the queue and destroys the GPU objects after unlocking, while the queue and device still exist.

### Final output

Each backbuffer has its own final output pass, bound once at setup to that backbuffer, its clone, the output shaders, and the settings. Presentation looks the entry up by the acquired image index and renders it. **Presentation never asks the swapchain for its images.** On Vulkan, ReShade answers `get_back_buffer`, `get_current_back_buffer`, and `get_back_buffer_count` with `vkGetSwapchainImagesKHR`, and the Steam overlay's layer leaks a semaphore on every such call. The images recorded at setup stay valid: Vulkan never changes a swapchain's images, and when the game recreates its swapchain, ReShade sends `destroy_swapchain` and then `init_swapchain`, which rebuilds the entries.

### Owners

| Object | Owner | Ends |
|---|---|---|
| Backbuffer | The game; output borrows it | With the swapchain. |
| RGBA16F clone | Shared RenoDX resource code; output borrows it | At shared clone cleanup. |
| Output and brightness passes, scene copy, views, layout, pipeline, sampler, no-UI settings buffer | `output::BackBufferState`, one per backbuffer | At swapchain retirement. A pass owns what it generated even after a partial setup. |
| Mapped settings uploads | The command list's `CommandListData` | Reused at a legal list reset; freed when the list is destroyed. |
| Recorded targets, sources, and candidates | The recording | At list reset or begin. |
| Accepted scene, UI, usage, and source facts | The current image use | Set after an accepted submit; cleared at the next successful acquire. |
| Pending decisions | One `SubmissionScope` | When the original submit returns. |

Settings uploads live in a deque, because recorded commands hold their addresses and a growing vector would move them.

### Locks

- The swapchain registry is private to output. Code copies an owner out of it, releases it, and only then takes that owner's state lock.
- The state lock guards closing, the backbuffer entries, accepted facts, and use of the output's GPU objects. After taking it, code rechecks closing, index, acquisition, and backbuffer/clone identity as needed.
- Descriptor and pipeline records have their own short locks. Source resolution copies binding information, releases that lock, then checks live resources.
- No lock is held across queue waits or window changes. After a window change, presentation looks up the shared data again.

### Failures

Setup checks ownership, size, format, sample count, and push descriptor support, and creates the output sampler itself so that a failure is caught before the state is published. A failed setup is not retried until the swapchain is recreated. A failure at presentation disables that backbuffer until recreation and keeps its GPU objects until the queue is idle. A failed HDR output is logged as an error; there is no silent SDR fallback.

## Setup order in addon.cpp

| Attach step | Why |
|---|---|
| 1. Register the add-on; early `resource_fixes::Use` | Clear-only repairs must run before the shared end-of-pass code drops pending clears. |
| 2. Settings, random, shared swapchain, shared shader setup | Configures pipeline layout eligibility and HDR10 output. |
| 3. `output::Use` | After the shared swapchain setup. |
| 4. `scene_tracking::Use` | |
| 5. `vulkan_hooks::Use` | Installs the hooks when the device is created. |
| 6. `resource_fixes::UseDescriptorFilters` | After the shared descriptor handler is elected, so another add-on's callbacks are never replaced. |
| 7. GPU-specific `init_device` callback | Applies the NVIDIA-only upgrade after the shared defaults. |

Detach runs: descriptor filters, hooks, scene tracking, output, early repairs, GPU callback, shared code, unregister. If removing the hooks fails, the original pointers stay in place. Unloading the add-on while the game runs is not supported.

## Shader and resource rules

- `shared.h` defines `ShaderInjectData`: 21 floats, 84 bytes, with `scene_brightness_enabled` at byte 80. Per-list uploads and the no-UI buffer use the same layout.
- The R11G11B10 to RGBA16F upgrade is NVIDIA-only and limited to textures exactly the size of the backbuffer. The backbuffer clone is a separate mechanism.
- Clear-only repairs apply when the build's ReShade headers are older than API 20. Copies between formats that no longer match after an upgrade are converted when neither side is a clone.
- Settings are added only to pipeline layouts with a pixel-visible range; layouts shared with compute still qualify.
- Descriptor filters look only at live texture clones. Other updates pass through unchanged.

## Known limits

| Limit | Effect |
|---|---|
| Dynamic offsets after the pre-UI pass | With ReShade API 18 headers, restoring the graphics snapshot does not replay descriptor dynamic offsets. |
| Descriptor pool reuse | Source binding history inherits the shared tracker's limits when pools are reset and reused. |
| ReShade's cached render passes and framebuffers | Destroying the mod's views does not free them. |
| One device | The hooks assume every device shares the same native function addresses. |
| Descriptor handler election | If another add-on takes over the shared descriptor handler later, it may not keep this mod's filters. |
| Crash investigation | The `rdr2vkprobe` add-on records object lifetimes, creation failures, and memory trends without changing the mod. |
