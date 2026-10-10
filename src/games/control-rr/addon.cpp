/*
 * Copyright (C) 2026 Carlos Lopez, speedlemur
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/shaders.h>

#include <d3d12.h>
#include <wrl/client.h>

#include <deps/imgui/imgui.h>
#include <atomic>
#include <cmath>
#include <cstdint>
#include <mutex>
#include <shared_mutex>
#include <sstream>
#include <map>
#include <unordered_set>
#include <vector>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../utils/data.hpp"
#include "../../utils/descriptor.hpp"
#include "../../utils/pipeline_layout.hpp"
#include "../../utils/date.hpp"
#include "../../utils/platform.hpp"
#include "../../utils/settings.hpp"

#if !defined(NDEBUG) && !defined(CONTROL_RR_DEV)
#define CONTROL_RR_DEV 1
#endif

namespace control_rr {
inline std::mutex detour_mutex;
}

// Control: DLSS Ray Reconstruction + frame-generation support.
//
// Denoiser bypass (the replaced DLF shaders below) plus DLSS Ray
// Reconstruction, fully in-process (rr.hpp) — NGX
// runtime detours swap the game's SR evaluate for DLSSD; guide production
// captures at the DIFFUSE DLF spatial dispatches we already replace
// (dlf_spatial_diffuse register map: t0 GBuffer1 = encoded normals + gloss,
// t1 GBuffer2, t7 hit info) via the descriptor-heap mirror, and
// at the LSAO resolve (t3 material table, t5 EnvBRDF).
//
#include "./diagnostics.hpp"
#include "./dlssg_probe.hpp"
#include "./sl_hdr10.hpp"
#include "./rr.hpp"

namespace {

// Denoiser: 0 = game's own, 1 = DLSS Super Resolution, 2 = DLSS Ray
// Reconstruction. Modes 1 and 2 both bypass the game's denoiser (raw RT
// into DLSS); 2 additionally swaps the SR evaluate for RR. The two other
// combinations — game denoiser + RR, or raw RT + nothing — are not useful
// and are not offered.
float denoiser_setting = 2.f;
float rr_preset_setting = 1.f;  // index into {D, E, F}
float sr_preset_setting = 0.f;  // index into {Default, J, K, L, M}
float rr_responsivity_setting = 0.f;  // constant DLSSD.ResponsivityMask; 0 = not sent

// Specular motion vectors use the reflection pass's per-ray hit arrays and
// are supplied through GBuffer.SpecularMvec. Enabled by default, with no UI toggle.
bool RawRtEnabled() { return denoiser_setting >= 1.f; }
bool RrEnabled() { return denoiser_setting >= 2.f; }

// dropdown index -> NGX preset hint value
constexpr unsigned int RR_PRESET_VALUES[] = {4u, 5u, 6u};        // D, E, F (RR2, needs driver >= 580)
constexpr unsigned int SR_PRESET_VALUES[] = {0u, 10u, 11u, 12u, 13u};  // Default, J, K, L, M

const std::unordered_set<uint32_t> DLF_HASHES = {
    // Pass roles follow Remedy's shader containers:
    // data/shaders/build/pc_dxil/deferredlight_filtering_*.obj.
    0x600347E7,  // specular TAA pre-accumulator
    0x591FC46F,  // diffuse TAA pre-accumulator
    0x2A6F7863,  // diffuse spatial Y
    0x9018E4F2,  // diffuse spatial X
    0x87EDDD47,  // specular spatial Y
    0xBA41374D,  // specular spatial X
};

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0x600347E7),
    CustomShaderEntry(0x591FC46F),
    CustomShaderEntry(0x2A6F7863),
    CustomShaderEntry(0x9018E4F2),
    CustomShaderEntry(0x87EDDD47),
    CustomShaderEntry(0xBA41374D),
};

std::atomic<reshade::api::device*> current_device = nullptr;
void DrainRetiredSnapshots(reshade::api::command_queue* queue);
void ClearSnapshotState();

// Odd render width or height makes Control's own mip-generation shader drift:
// it samples the parent at (x + 0.5) / destWidth, which only lands on the
// midpoint of four parent texels when the parent is EXACTLY twice the child.
// 1707 halves to 853, and 853 * 2 = 1706, so each step along the row advances
// 2.0012 texels instead of 2 - about a pixel of drift by the right edge, and
// it compounds per mip level. The firefly clamp in the DLF pre-accumulators
// reads those mips, so the clamp threshold varies across the screen and the
// ray-traced signal comes out noisy before any denoiser sees it. Worst on RR
// preset F, faintly visible even with the game's own denoiser.
// The render size is chosen by the game before our hooks run. An even value
// can be set in renderer.ini with the game closed.
renodx::utils::settings::Setting* odd_resolution_warning = nullptr;
renodx::utils::settings::Setting* odd_resolution_advice = nullptr;

// NGX result codes we can explain to a user. 0xBAD00004 is FeatureNotFound,
// which in practice means nvngx_dlssd.dll is not where NGX looks for it.
renodx::utils::settings::Setting* rr_failed_warning = nullptr;
renodx::utils::settings::Setting* sr_failed_warning = nullptr;

// Read once at attach: the swap chain is built the new way or not at all.
// Off by default - HDR only, and an SDR user with frame generation already
// working would lose it. The value the session booted with is kept so the
// overlay can say "restart" when the saved one differs.
float fg_sl_hdr10_setting = 0.f;
float fg_sl_hdr10_boot_value = 0.f;

void UpdateRrFailureLabel() {
  if (rr_failed_warning == nullptr || !rr::rr_failed.load()) return;
  static unsigned int labelled = 0xFFFFFFFFu;
  const unsigned int err = rr::rr_last_error.load();
  if (labelled == err) return;
  labelled = err;
  std::stringstream s;
  if (err == 0xBAD00004u) {
    s << "Ray Reconstruction is off: nvngx_dlssd.dll is missing."
      << " Put it next to Control_DX12.exe. Using Super Resolution for now.";
  } else {
    s << "Ray Reconstruction could not start (0x" << std::hex << err << std::dec
      << "). Using Super Resolution for now.";
  }
  rr_failed_warning->label = s.str();
}

void UpdateSrFailureLabel() {
  if (sr_failed_warning == nullptr || !rr::sr_failed.load()) return;
  static unsigned int labelled = 0xFFFFFFFFu;
  const unsigned int error = rr::sr_last_error.load();
  if (labelled == error) return;
  labelled = error;
  std::stringstream s;
  s << "SR preset override failed (0x" << std::hex << error << std::dec
    << "). The game's default SR is active. Select Default, then select the preset again to retry.";
  sr_failed_warning->label = s.str();
}

bool OddRenderSize() {
  const uint32_t w = rr::render_width;
  const uint32_t h = rr::render_height;
  return w != 0 && h != 0 && (((w & 1u) != 0u) || ((h & 1u) != 0u));
}

// The warning names the user's ACTUAL numbers, so the instruction is "change
// 1707 to 1706" rather than a rule they have to apply themselves.
void UpdateOddResolutionLabels() {
  if (odd_resolution_warning == nullptr || !OddRenderSize()) return;
  const uint32_t w = rr::render_width;
  const uint32_t h = rr::render_height;
  static uint32_t labelled_w = 0;
  static uint32_t labelled_h = 0;
  if (labelled_w == w && labelled_h == h) return;
  labelled_w = w;
  labelled_h = h;
  std::stringstream warn;
  warn << "Your render resolution is " << w << "x" << h << ". Odd numbers break the game's"
       << " mip filtering, which adds noise.";
  odd_resolution_warning->label = warn.str();
  std::stringstream fix;
  fix << "Fix: open renderer.ini next to the game exe and set";
  if ((w & 1u) != 0u) fix << " m_iRenderResolutionX to " << (w & ~1u);
  if ((w & 1u) != 0u && (h & 1u) != 0u) fix << " and";
  if ((h & 1u) != 0u) fix << " m_iRenderResolutionY to " << (h & ~1u);
  fix << ".";
  odd_resolution_advice->label = fix.str();
}

#ifdef CONTROL_RR_DEV
// Every 2D texture the game creates, counted by size. At an ODD render width
// (1707) anything that halves must round, so a census makes 853-vs-854 style
// inconsistency visible anywhere in the frame - no need to guess which pass
// to inspect.
std::mutex census_mutex;
std::map<std::pair<uint32_t, uint32_t>, uint32_t> texture_census;

void OnInitResource(
    reshade::api::device*, const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data*, reshade::api::resource_usage initial_state,
    reshade::api::resource resource) {
  if (desc.type != reshade::api::resource_type::texture_2d) return;
  if (desc.texture.width < 8 || desc.texture.height < 8) return;
  {
    const std::lock_guard lock(census_mutex);
    ++texture_census[{desc.texture.width, desc.texture.height}];
  }
  // Identity for anything near half the render width. The census proves the
  // 853/854 split exists; this says WHICH texture is which, with the format,
  // usage flags and handle needed to find it in a snapshot.
  const uint32_t w = desc.texture.width;
  const uint32_t h = desc.texture.height;
  const uint32_t rw = rr::render_width;
  const uint32_t rh = rr::render_height;
  const bool half_of_render = (rw > 2 && rh > 2)
                              && (w == rw / 2 || w == (rw + 1) / 2)
                              && (h == rh / 2 || h == (rh + 1) / 2);
  // Most of these are created before the SR feature exists, so render_width
  // is still zero: catch the band around half of 1707x960 outright.
  const bool in_band = (w >= 840 && w <= 870 && h >= 460 && h <= 500);
  if (!half_of_render && !in_band) return;
  static std::atomic<int> logged = 0;
  if (logged.fetch_add(1) >= 64) return;
  std::stringstream s;
  s << "half-res texture #" << logged.load() << ": " << w << "x" << h
    << (((w & 1u) != 0u) ? " [ODD WIDTH]" : " [even width]")
    << " fmt=" << static_cast<uint32_t>(desc.texture.format)
    << " levels=" << desc.texture.levels << " layers=" << desc.texture.depth_or_layers
    << " usage=0x" << std::hex << static_cast<uint32_t>(desc.usage)
    << " flags=0x" << static_cast<uint32_t>(desc.flags)
    << " initial=0x" << static_cast<uint32_t>(initial_state)
    << " handle=0x" << resource.handle << std::dec
    << " (render " << rw << "x" << rh << ", half would be " << (rw / 2) << " or " << ((rw + 1) / 2) << ")";
  reshade::log::message(reshade::log::level::info, ("control-rr: " + s.str()).c_str());
}

void LogTextureCensus() {
  std::vector<std::pair<std::pair<uint32_t, uint32_t>, uint32_t>> rows;
  {
    const std::lock_guard lock(census_mutex);
    rows.assign(texture_census.begin(), texture_census.end());
  }
  std::stringstream s;
  s << "texture census (" << rows.size() << " distinct sizes):";
  for (const auto& row : rows) {
    s << " " << row.first.first << "x" << row.first.second << "(" << row.second << ")";
    if ((row.first.first & 1u) != 0u || (row.first.second & 1u) != 0u) s << "[ODD]";
  }
  reshade::log::message(reshade::log::level::info, ("control-rr: " + s.str()).c_str());
}
#endif  // CONTROL_RR_DEV

void ApplyToggle() {
  auto* device = current_device.load();
  if (device == nullptr) return;
  bool enable = RawRtEnabled();
  if (enable) {
    renodx::utils::shader::AddRuntimeReplacement(device, 0x600347E7, __0x600347E7);
    renodx::utils::shader::AddRuntimeReplacement(device, 0x591FC46F, __0x591FC46F);
    renodx::utils::shader::AddRuntimeReplacement(device, 0x2A6F7863, __0x2A6F7863);
    renodx::utils::shader::AddRuntimeReplacement(device, 0x9018E4F2, __0x9018E4F2);
    renodx::utils::shader::AddRuntimeReplacement(device, 0x87EDDD47, __0x87EDDD47);
    renodx::utils::shader::AddRuntimeReplacement(device, 0xBA41374D, __0xBA41374D);
  } else {
    renodx::utils::shader::RemoveRuntimeReplacements(device, DLF_HASHES);
  }
  std::stringstream s;
  s << "control-toggle: applied " << (enable ? "ON (replacements added)" : "OFF (replacements removed)");
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

// The swapchain's format and colour space, once at creation and on every
// resize. With OptiScaler installed this is how we see whether anything
// beneath us has changed the output - the HDR10 question turns entirely on
// these two values.
void OnInitSwapchainLog(reshade::api::swapchain* swapchain, bool resize) {
  if (swapchain == nullptr) return;
  auto* native = reinterpret_cast<IDXGISwapChain*>(swapchain->get_native());
  if (native == nullptr) return;
  DXGI_SWAP_CHAIN_DESC desc = {};
  if (FAILED(native->GetDesc(&desc))) return;
  std::stringstream s;
  s << "control-rr: swapchain " << (resize ? "resize" : "create") << " " << desc.BufferDesc.Width
    << "x" << desc.BufferDesc.Height << " fmt=" << static_cast<int>(desc.BufferDesc.Format)
    << " buffers=" << desc.BufferCount << " flags=0x" << std::hex << desc.Flags << std::dec
    << " windowed=" << desc.Windowed;
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

void OnInitDeviceApply(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::d3d12) return;
  current_device = device;
  ApplyToggle();
  rr::TryArmFromLoadedModules();
  // Retry installation during device initialization if Streamline is loaded.
  // The startup watcher also handles loading before or between device events.
  if (sl_hdr10::enabled.load()) sl_hdr10::TryInstall();
}

void OnDestroyDeviceApply(reshade::api::device* device) {
  control_diag::Scope trace("device.destroy");
  control_diag::Mark("device.destroy.pointer", reinterpret_cast<uint64_t>(device));
  reshade::api::device* expected = device;
  current_device.compare_exchange_strong(expected, nullptr);
  ClearSnapshotState();
}

// At init_device the saved setting has not been read from the ini yet, so the
// boot apply uses the default (On). Re-apply once on the first present, when
// settings are guaranteed loaded, so a saved Off boots Off.
std::atomic<bool> boot_state_applied = false;

void OnPresentApplyOnce(
    reshade::api::command_queue* queue, reshade::api::swapchain*,
    const reshade::api::rect*, const reshade::api::rect*,
    uint32_t, const reshade::api::rect*) {
  if (!boot_state_applied.exchange(true)) {
    ApplyToggle();
    rr::SetRrEnabled(RrEnabled());
    rr::SetRrPreset(RR_PRESET_VALUES[static_cast<int>(rr_preset_setting)]);
    rr::SetSrPreset(SR_PRESET_VALUES[static_cast<int>(sr_preset_setting)]);
    rr::responsivity_value = rr_responsivity_setting;
    std::stringstream s;
    s << "control-rr: consumers at boot - RR " << (rr::rr_enabled ? "ON" : "off")
      << ", FG bridge " << (sl_hdr10::enabled.load() ? "ON" : "off");
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
  rr::ApplyPendingFeatureChanges(queue);
  DrainRetiredSnapshots(queue);
  if (sl_hdr10::enabled.load()) dlssg_probe::Poll();
  UpdateOddResolutionLabels();
  UpdateRrFailureLabel();
  UpdateSrFailureLabel();
  // belt and braces alongside the LoadLibrary hooks
  rr::TryArmFromLoadedModules();
}

// ---------------------------------------------------------------------------
// RR guide capture — resolves the game's G-buffer resources as they are
// bound and hands them to the in-process consumer in rr.hpp.
// ---------------------------------------------------------------------------

std::atomic<uint64_t> last_gbuffer1 = 0;
std::atomic<uint64_t> last_gbuffer2 = 0;
std::atomic<uint64_t> last_material = 0;
std::atomic<uint64_t> last_envbrdf = 0;
#ifdef CONTROL_RR_DEV
std::atomic<uint64_t> last_hitinfo = 0;
#endif
std::atomic<uint64_t> last_matid = 0;
std::atomic<uint64_t> last_hitpos = 0;

// Snapshots of the reflection hit arrays, copied on the game's command list
// right before the reflection dispatch. The game reuses these arrays as
// scratch later in the frame, so reading them live at DLSS-evaluate time
// returns another pass's data — the copy happens while they still hold the
// reflection trace.
struct HitSnapshot {
  reshade::api::resource texture = {0};
  reshade::api::resource_desc desc = {};
  bool has_content = false;  // false until the first copy: initial state is copy_dest
};
HitSnapshot snap_matid;
HitSnapshot snap_hitpos;

// Our own copies of the two UI-compositor buffers. They must be copies: the
// originals are the game's working targets and are overwritten later in the
// frame, long before anything downstream would read them.
HitSnapshot snap_hudless;
HitSnapshot snap_ui;
std::atomic<uint64_t> last_hudless_src = 0;
std::atomic<uint64_t> last_ui_src = 0;

std::mutex retired_snapshot_mutex;
std::vector<reshade::api::resource> retired_snapshots;

void RetireSnapshot(reshade::api::resource resource) {
  control_diag::Mark("snapshot.retire", resource.handle);
  if (resource.handle == 0u) return;
  const std::lock_guard lock(retired_snapshot_mutex);
  retired_snapshots.push_back(resource);
}

void DrainRetiredSnapshots(reshade::api::command_queue* queue) {
  std::vector<reshade::api::resource> resources;
  {
    const std::lock_guard lock(retired_snapshot_mutex);
    if (retired_snapshots.empty()) return;
    resources.swap(retired_snapshots);
  }
  control_diag::Scope trace("snapshot.drain");
  control_diag::Mark("snapshot.wait_idle.begin", resources.size(), reinterpret_cast<uint64_t>(queue));
  queue->wait_idle();
  control_diag::Mark("snapshot.wait_idle.end");
  if (auto* device = current_device.load(); device != nullptr) {
    for (const auto resource : resources) {
      control_diag::Mark("snapshot.destroy.begin", resource.handle);
      device->destroy_resource(resource);
      control_diag::Mark("snapshot.destroy.end", resource.handle);
    }
  }
}

void ClearSnapshotState() {
  control_diag::Scope trace("snapshot.clear");
  rr::SetGuide("matid", nullptr);
  rr::SetGuide("hitpos", nullptr);
  dlssg_probe::Publish(dlssg_probe::hudless_buffer, nullptr, 0, 0, 0, 0);
  dlssg_probe::Publish(dlssg_probe::ui_buffer, nullptr, 0, 0, 0, 0);
  sl_hdr10::bridge.hudless_source.store(nullptr);
  snap_matid = {};
  snap_hitpos = {};
  snap_hudless = {};
  snap_ui = {};
  last_matid.store(0);
  last_hitpos.store(0);
  last_hudless_src.store(0);
  last_ui_src.store(0);
  const std::lock_guard lock(retired_snapshot_mutex);
  retired_snapshots.clear();
}


// Capture at the DIFFUSE spatial dispatches (t0 = GBuffer1, t1 = GBuffer2 per
// the dlf_spatial_diffuse register map). These are the passes that bind
// t7 = g_tHitInfo.
const std::unordered_set<uint32_t> CAPTURE_HASHES = {0x2A6F7863, 0x9018E4F2};
// LSAO resolve: t3 = g_sbMaterialDataPart1, t5 = g_tEnvBRDF. Only dispatched
// while the in-game SSAO setting is ON.
constexpr uint32_t LSAO_HASH = 0x3233A377;
// RT reflection shading pass. Reads the DXR
// trace's per-ray hit-attribute arrays: t26 g_tMaterialId (uint, 2darray,
// slice = ray; 0xFFFE = no more rays, 0xFFFF = sky), t28
// g_tPosition_TexcoordY (float4 2darray, .xyz = VIEW-space hit position).
constexpr uint32_t REFL_HASH = 0xABEC7E90;
// UI compositor. Control keeps the HUD as its own layer and blends it onto
// the scene here, which makes this the one dispatch in the frame where both
// halves exist separately: u0 is the finished image WITHOUT the HUD (it is
// read-modify-written here), t0 is the HUD alone, premultiplied with a real
// alpha channel. Both are needed by anything that has to reason about the
// UI independently of the scene.
// HDR only. In SDR the game composites into the scene copy directly and the
// alpha is gone, so this dispatch does not exist and nothing here runs.
constexpr uint32_t UI_COMPOSITE_HASH = 0xA6FDCF2F;

struct PushedCbv {
  uint64_t buffer = 0;
  uint64_t offset = 0;
};

struct __declspec(uuid("c0febeef-0001-4b1d-9e0e-5d5c5b5a5958")) RRCommandListData {
  reshade::api::pipeline_layout compute_layout = {0};
  std::vector<reshade::api::descriptor_table> compute_tables;
  // constant buffers pushed as ROOT descriptors, by layout parameter index.
  // Control binds sys_constants (b0) this way, so it never appears in a
  // descriptor table — recording it here is what lets us later ask "which
  // buffer did the shader we identified by hash actually have bound".
  std::vector<PushedCbv> compute_cbvs;
  std::shared_mutex mutex;
};

void OnBindDescriptorTables(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout layout,
    uint32_t first,
    uint32_t count,
    const reshade::api::descriptor_table* tables) {
  if ((!rr::rr_enabled.load() || rr::rr_failed.load())
      && (!sl_hdr10::enabled.load() || !dlssg_probe::active.load())) return;
  if ((static_cast<uint32_t>(stages) & static_cast<uint32_t>(reshade::api::shader_stage::compute)) == 0u) return;

  RRCommandListData* data;
  renodx::utils::data::CreateOrGet(cmd_list, data);
  const std::unique_lock lock(data->mutex);
  data->compute_layout = layout;
  if (data->compute_tables.size() < first + count) {
    data->compute_tables.resize(first + count);
  }
  for (uint32_t i = 0; i < count; ++i) {
    data->compute_tables[first + i] = tables[i];
  }
}

bool IsUavRange(reshade::api::descriptor_type type) {
  switch (type) {
    case reshade::api::descriptor_type::texture_unordered_access_view:
    case reshade::api::descriptor_type::buffer_unordered_access_view:
      return true;
    default:
      return false;
  }
}

bool IsSrvRange(reshade::api::descriptor_type type) {
  switch (type) {
    case reshade::api::descriptor_type::texture_shader_resource_view:
    case reshade::api::descriptor_type::buffer_shader_resource_view:
    case reshade::api::descriptor_type::sampler_with_resource_view:
      return true;
    default:
      return false;
  }
}

// Record root-descriptor constant buffers per command list. This only takes
// note of what was bound where — nothing is read or judged here. The buffer
// is chosen later, at a dispatch we have identified by shader hash, which is
// what makes the capture provenance-based rather than content-sniffed.
void OnPushDescriptors(
    reshade::api::command_list* cmd_list,
    reshade::api::shader_stage stages,
    reshade::api::pipeline_layout,
    uint32_t param_index,
    const reshade::api::descriptor_table_update& update) {
  if (!rr::rr_enabled.load() || rr::rr_failed.load()) return;
  if ((static_cast<uint32_t>(stages) & static_cast<uint32_t>(reshade::api::shader_stage::compute)) == 0u) return;
  if (update.type != reshade::api::descriptor_type::constant_buffer) return;
  if (update.count == 0) return;

  const auto& range = static_cast<const reshade::api::buffer_range*>(update.descriptors)[0];
  if (range.buffer.handle == 0u) return;

  RRCommandListData* data;
  renodx::utils::data::CreateOrGet(cmd_list, data);
  const std::unique_lock lock(data->mutex);
  if (data->compute_cbvs.size() <= param_index) {
    data->compute_cbvs.resize(param_index + 1);
  }
  data->compute_cbvs[param_index] = {range.buffer.handle, range.offset};
}

// Resolve the resource bound at compute register t<reg> (space 0) by walking
// the pipeline layout's descriptor ranges — same approach as the devkit's
// snapshot binding resolution.
// Walks the bound compute layout for the resource at register t<reg> (SRV)
// or u<reg> (UAV), space 0. Same walk either way - only the range type test
// differs - so both share this.
reshade::api::resource ResolveComputeBinding(
    reshade::api::device* device,
    renodx::utils::descriptor::DeviceData* descriptor_data,
    RRCommandListData* rr_data,
    uint32_t reg,
    bool want_uav,
    bool log_details) {
#if !defined(CONTROL_RR_DEV) && !defined(CONTROL_RR_DIAGNOSTICS)
  log_details = false;
#endif
  const auto* layout_data = renodx::utils::pipeline_layout::GetPipelineLayoutData(rr_data->compute_layout);
  if (layout_data == nullptr) {
    if (log_details) {
      reshade::log::message(reshade::log::level::warning, "control-rr: no layout data for bound compute layout");
    }
    return {0};
  }

  const auto param_count = layout_data->params.size();
  for (size_t param_index = 0; param_index < param_count && param_index < rr_data->compute_tables.size(); ++param_index) {
    const auto& param = layout_data->params[param_index];

    uint32_t range_count = 0;
    const reshade::api::descriptor_range* ranges = nullptr;
    if (param.type == reshade::api::pipeline_layout_param_type::descriptor_table) {
      range_count = param.descriptor_table.count;
      ranges = param.descriptor_table.ranges;
    } else {
      continue;
    }

    auto table = rr_data->compute_tables[param_index];
    if (table.handle == 0u) continue;

    for (uint32_t j = 0; j < range_count; ++j) {
      const auto& range = ranges[j];
      if (range.count == 0u || range.count == UINT32_MAX) continue;

      if (log_details) {
        std::stringstream s;
        s << "control-rr: layout param[" << param_index << "] range[" << j << "]"
          << " type=" << static_cast<uint32_t>(range.type)
          << " t" << range.dx_register_index << "+" << range.count
          << " space=" << range.dx_register_space
          << " binding=" << range.binding;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }

      if (want_uav ? !IsUavRange(range.type) : !IsSrvRange(range.type)) continue;
      if (range.dx_register_space != 0) continue;
      if (reg < range.dx_register_index || reg >= range.dx_register_index + range.count) continue;

      const uint32_t index_in_range = reg - range.dx_register_index;

      uint32_t base_offset = 0;
      reshade::api::descriptor_heap heap = {0};
      device->get_descriptor_heap_offset(table, range.binding, 0, &heap, &base_offset);

      auto heap_pair = descriptor_data->heaps.find(heap.handle);
      if (heap_pair == descriptor_data->heaps.end()) {
        if (log_details) {
          reshade::log::message(reshade::log::level::warning, "control-rr: heap not in mirror");
        }
        continue;
      }
      auto& slots = heap_pair->second;
      if (base_offset + index_in_range >= slots.size()) {
        if (log_details) {
          std::stringstream s;
          s << "control-rr: heap mirror too small (" << slots.size() << " <= "
            << base_offset + index_in_range << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        }
        continue;
      }

      auto& heap_slot = slots[base_offset + index_in_range];
      if (!heap_slot.HasResourceView() || heap_slot.resource_view.handle == 0u) {
        if (log_details) {
          std::stringstream s;
          s << "control-rr: t" << reg << " slot empty in mirror (type="
            << static_cast<uint32_t>(heap_slot.type) << ")";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        }
        continue;
      }
      return device->get_resource_from_view(heap_slot.resource_view);
    }
  }
  return {0};
}

// Which layout parameter carries constant-buffer register b<reg>, space 0.
// Only root/push descriptors are considered: Control binds sys_constants
// that way, so the descriptor-table walk used for the SRVs cannot reach it.
int ResolveComputeCbvParam(
    const renodx::utils::pipeline_layout::PipelineLayoutData* layout_data, uint32_t reg) {
  const auto param_count = layout_data->params.size();
  for (size_t i = 0; i < param_count; ++i) {
    const auto& param = layout_data->params[i];
    if (param.type != reshade::api::pipeline_layout_param_type::push_descriptors) continue;
    const auto& range = param.push_descriptors;
    if (range.type != reshade::api::descriptor_type::constant_buffer) continue;
    if (range.dx_register_space != 0) continue;
    if (reg < range.dx_register_index) continue;
    if (range.count != UINT32_MAX && reg >= range.dx_register_index + range.count) continue;
    return static_cast<int>(i);
  }
  return -1;
}

// ---------------------------------------------------------------------------
// Camera-matrix capture — the production source of the matrices the spec-MV
// pass consumes (published via rr::SetCameraMatrices).
//
// Control writes only the constants a pass actually reads. The diffuse
// spatial passes we capture guides at read neither g_mClipToView nor any
// other matrix we need, so those bytes are whatever the ring slot held
// before — plausible garbage that changes every frame.
//
// The SPECULAR spatial passes DO read g_mClipToView (+224) AND
// g_mPreviousViewToView (+544) — per their RDEFs, and our own replacement
// unprojects with the former (dlf_spatial_spec.hlsli, packoffset(c14)). So
// both matrices are live at this dispatch. The game's constant ring is a
// CPU-mappable upload heap that recycles within the frame, so the read
// happens here, same-frame, at the dispatch that binds it.
//
// NOT added to CAPTURE_HASHES on purpose: the specular pass binds
// t7 = history_tex where the diffuse pass binds hit_info, so capturing
// guides here would feed a colour history texture in as hit distance.
// ---------------------------------------------------------------------------
constexpr uint32_t MATRIX_SOURCE_HASH = 0x87EDDD47;  // specular spatial Y

void CaptureCameraMatrices(RRCommandListData* rr_data) {
  // A matrix is usable only for the dispatch that just refreshed it. Any
  // failed capture makes this frame use the ordinary game motion vectors.
  rr::InvalidateCameraMatrices();
  const auto* layout_data =
      renodx::utils::pipeline_layout::GetPipelineLayoutData(rr_data->compute_layout);
  if (layout_data == nullptr) return;
  const int param = ResolveComputeCbvParam(layout_data, 0);
  if (param < 0 || static_cast<size_t>(param) >= rr_data->compute_cbvs.size()) return;
  const auto& cbv = rr_data->compute_cbvs[param];
  if (cbv.buffer == 0u) return;

  auto* buffer = reinterpret_cast<ID3D12Resource*>(cbv.buffer);
  D3D12_HEAP_PROPERTIES heap_props = {};
  D3D12_HEAP_FLAGS heap_flags = D3D12_HEAP_FLAG_NONE;
  if (FAILED(buffer->GetHeapProperties(&heap_props, &heap_flags))
      || heap_props.Type != D3D12_HEAP_TYPE_UPLOAD) {
    return;
  }
  if (buffer->GetDesc().Width < cbv.offset + rr::kSysConstBytes) return;

  void* mapped = nullptr;
  D3D12_RANGE read_range = {
      static_cast<SIZE_T>(cbv.offset),
      static_cast<SIZE_T>(cbv.offset + rr::kSysConstBytes),
  };
  if (FAILED(buffer->Map(0, &read_range, &mapped))) return;
  const auto* f = reinterpret_cast<const float*>(static_cast<const uint8_t*>(mapped) + cbv.offset);

  const uint32_t rw = rr::render_width;
  const uint32_t rh = rr::render_height;
  const float* c2v = f + (224 / 4);
  const float* p2v = f + (544 / 4);

  // NOT tested against +24: the specular pass reads g_vInvScreenRes (+8), not
  // g_vInvOutputRes (+24), so +24 is stale HERE. The structural checks below
  // need no known value.

  // Structure of an inverse row-vector perspective projection: the off-axis
  // terms of rows 0/1 are zero, [2][2] is zero, and [3][2] is exactly 1.
  // Independent of any value we would have to guess.
  //
  // Row 3 columns 0/1 carry DLSS sub-pixel jitter and need not be zero.
  auto z = [](float v) { return fabsf(v) < 1e-6f; };
  const bool shape_ok = z(c2v[1]) && z(c2v[2]) && z(c2v[3])
                        && z(c2v[4]) && z(c2v[6]) && z(c2v[7])
                        && z(c2v[8]) && z(c2v[9]) && z(c2v[10])
                        && fabsf(c2v[14] - 1.0f) < 1e-4f
                        && fabsf(c2v[0]) > 1e-6f && fabsf(c2v[5]) > 1e-6f;
  // aspect falls straight out: (1/sx)/(1/sy) = sy/sx = width/height
  const float aspect = (fabsf(c2v[5]) > 1e-9f) ? (c2v[0] / c2v[5]) : 0.0f;
  const float expect_aspect = (rh != 0) ? (static_cast<float>(rw) / static_cast<float>(rh)) : 0.0f;
  const bool aspect_ok = fabsf(aspect - expect_aspect) < 0.02f;
  // Camera rotation is allowed to be large. Reject only malformed/non-finite
  // homogeneous transforms; SetCameraMatrices performs the inverse checks.
  bool p2v_ok = fabsf(p2v[15] - 1.0f) < 1e-4f;
  for (int i = 0; i < 16; ++i) p2v_ok = p2v_ok && std::isfinite(p2v[i]);

  const bool all_ok = shape_ok && aspect_ok && p2v_ok;

  // Publish only what passed. A rejected frame intentionally remains invalid.
  if (all_ok) rr::SetCameraMatrices(c2v, p2v);

#ifdef CONTROL_RR_DEV
  static std::atomic<uint64_t> seen = 0;
  static std::atomic<uint64_t> good = 0;
  static std::atomic<int> last_state = -1;
  static std::atomic<int> full_logs = 0;

  const uint64_t n = seen.fetch_add(1) + 1;
  if (all_ok) good.fetch_add(1);
  const int state = all_ok ? 1 : 0;
  const bool changed = (last_state.exchange(state) != state);

  if (changed) {  // state changes only; no periodic census (render-thread file write)
    std::stringstream s;
    s.precision(9);
    s << "control-rr: matrices(specular 0x87EDDD47) " << (all_ok ? "OK" : "BAD")
      << " shape=" << shape_ok
      << " aspect=" << aspect << "/" << expect_aspect
      << " p2v=" << p2v_ok
      << " buf=0x" << std::hex << cbv.buffer << std::dec << "+" << cbv.offset
      << " good=" << good.load() << "/" << n;
    reshade::log::message(all_ok ? reshade::log::level::info : reshade::log::level::warning,
                          s.str().c_str());
  }
  // A few full matrices either way, so the verdict can be checked offline
  // rather than trusted from the booleans above.
  if (full_logs.load() < 6 && changed) {
    full_logs.fetch_add(1);
    std::stringstream s;
    s.precision(9);
    s << "control-rr: matrices " << (all_ok ? "OK" : "BAD") << " clip_to_view:";
    for (int i = 0; i < 16; ++i) s << " " << c2v[i];
    s << " | prev_view_to_view:";
    for (int i = 0; i < 16; ++i) s << " " << p2v[i];
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
#endif

  D3D12_RANGE no_write = {0, 0};
  buffer->Unmap(0, &no_write);
}

std::atomic<bool> capture_logged_dlf = false;
std::atomic<bool> capture_logged_lsao = false;
std::atomic<bool> capture_logged_refl = false;
std::atomic<bool> capture_logged_ui = false;
// Capture callbacks share snapshot state. Keep their existing serialization
// separate from the descriptor mirror, which the game's other threads update.
std::mutex capture_mutex;

// Resolve captured resources at matching dispatches. Avoid periodic logging:
// synchronous log writes can stall the render thread.
bool OnDispatchCapture(reshade::api::command_list* cmd_list, uint32_t, uint32_t, uint32_t) {
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;
  auto* compute_state = renodx::utils::shader::GetCurrentComputeState(shader_state);
  auto shader_hash = renodx::utils::shader::GetCurrentShaderHash(compute_state);

  const bool is_dlf = CAPTURE_HASHES.contains(shader_hash);
  const bool is_lsao = (shader_hash == LSAO_HASH);
  const bool is_matrix_src = (shader_hash == MATRIX_SOURCE_HASH);
  const bool is_refl = (shader_hash == REFL_HASH);
  const bool is_ui = (shader_hash == UI_COMPOSITE_HASH);
  if (!is_dlf && !is_lsao && !is_matrix_src && !is_refl && !is_ui) return false;
  control_diag::Scope trace("capture.dispatch");
  control_diag::Mark("capture.shader", shader_hash, reinterpret_cast<uint64_t>(cmd_list));

  const bool rr_capture = rr::rr_enabled.load() && !rr::rr_failed.load();
  const bool fg_capture = sl_hdr10::enabled.load() && dlssg_probe::active.load();
  if (((is_dlf || is_lsao || is_matrix_src || is_refl) && !rr_capture)
      || (is_ui && !fg_capture)) {
    return false;
  }

  auto* device = cmd_list->get_device();
  auto* descriptor_data = renodx::utils::data::Get<renodx::utils::descriptor::DeviceData>(device);
  if (descriptor_data == nullptr) return false;

  auto* rr_data = renodx::utils::data::Get<RRCommandListData>(cmd_list);
  if (rr_data == nullptr) return false;

  const std::unique_lock capture_lock(capture_mutex);
  const std::shared_lock rr_lock(rr_data->mutex);

  const bool log_this = is_dlf  ? !capture_logged_dlf.exchange(true)
                        : is_refl ? !capture_logged_refl.exchange(true)
                        : is_ui   ? !capture_logged_ui.exchange(true)
                                  : !capture_logged_lsao.exchange(true);
  if (is_ui && log_this) {
    reshade::log::message(reshade::log::level::info,
                          "control-rr: UI compositor dispatch seen - the HUD is a separate layer here");
  }

  auto resolve = [&](uint32_t reg, bool uav) {
    const std::unique_lock descriptor_lock(descriptor_data->mutex);
    const auto resource = ResolveComputeBinding(device, descriptor_data, rr_data, reg, uav, log_this);
    // Retain the native resource before dropping the mirror lock. The game
    // owns the bound dispatch resources; this reference also keeps each one
    // alive throughout our CPU-side capture work outside that lock.
    return Microsoft::WRL::ComPtr<ID3D12Resource>(reinterpret_cast<ID3D12Resource*>(resource.handle));
  };

  auto capture = [&](const char* name, uint32_t reg, std::atomic<uint64_t>& last, bool expect_render_res) {
    const auto retained = resolve(reg, false);
    const reshade::api::resource resource = {reinterpret_cast<uint64_t>(retained.Get())};
    if (resource.handle == 0u) {
      if (log_this) {
        std::stringstream s;
        s << "control-rr: " << name << " (t" << reg << ") resolution failed at dispatch 0x"
          << std::hex << shader_hash;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
      return;
    }
    auto desc = device->get_resource_desc(resource);
    // Accept small render sizes, including 853x480 at 1440p Ultra Performance,
    // so resolution changes can replace the captured guide resources.
    if (expect_render_res && (desc.texture.width < 320 || desc.texture.height < 180)) {
      if (log_this) {
        std::stringstream s;
        s << "control-rr: " << name << " resolved but not render-res ("
          << desc.texture.width << "x" << desc.texture.height << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
      return;
    }
    const auto previous = last.exchange(resource.handle);
    if (previous != resource.handle) {
      rr::SetGuide(name, reinterpret_cast<ID3D12Resource*>(resource.handle));
      // pointer churn is routine (the game reallocates the material table
      // as it grows) — only the FIRST capture per slot is log-worthy
      if (previous == 0u || log_this) {
        std::stringstream s;
        s << "control-rr: " << name << " captured 0x" << std::hex << resource.handle;
        if (desc.type == reshade::api::resource_type::buffer) {
          s << " buffer size=" << std::dec << desc.buffer.size;
        } else {
          s << " fmt=" << std::dec << static_cast<uint32_t>(desc.texture.format)
            << " " << desc.texture.width << "x" << desc.texture.height;
          // Query the native description for the reflection hit-array size.
          const auto d3d_desc = reinterpret_cast<ID3D12Resource*>(resource.handle)->GetDesc();
          s << " layers=" << d3d_desc.DepthOrArraySize << " (reshade " << desc.texture.depth_or_layers << ")";
        }
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }
  };

  if (is_dlf) {
    capture("gbuffer1", 0, last_gbuffer1, true);
    capture("gbuffer2", 1, last_gbuffer2, true);
#ifdef CONTROL_RR_DEV
    capture("hitinfo", 7, last_hitinfo, true);
#endif
  } else if (is_lsao) {
    capture("material", 3, last_material, false);
    capture("envbrdf", 5, last_envbrdf, false);
  } else if (is_refl) {
    auto snapshot = [&](const char* name, uint32_t reg, std::atomic<uint64_t>& last, HitSnapshot& snap) {
      const auto retained = resolve(reg, false);
      const reshade::api::resource resource = {reinterpret_cast<uint64_t>(retained.Get())};
      if (resource.handle == 0u) return;
      auto desc = device->get_resource_desc(resource);
      const auto previous = last.exchange(resource.handle);
      const bool same_shape = snap.texture.handle != 0u && snap.desc.texture.width == desc.texture.width
                              && snap.desc.texture.height == desc.texture.height
                              && snap.desc.texture.depth_or_layers == desc.texture.depth_or_layers
                              && snap.desc.texture.format == desc.texture.format;
      if (!same_shape) {
        rr::SetGuide(name, nullptr);
        RetireSnapshot(snap.texture);
        snap = {};
        reshade::api::resource_desc copy_desc = desc;
        copy_desc.heap = reshade::api::memory_heap::gpu_only;
        copy_desc.usage = reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::shader_resource;
        copy_desc.flags = reshade::api::resource_flags::none;
        if (!device->create_resource(copy_desc, nullptr, reshade::api::resource_usage::copy_dest, &snap.texture)) {
          reshade::log::message(reshade::log::level::warning, "control-rr: hit snapshot creation failed");
          snap.texture = {0};
          return;
        }
        snap.desc = copy_desc;
        std::stringstream s;
        s << "control-rr: " << name << " snapshot " << desc.texture.width << "x" << desc.texture.height
          << " layers=" << desc.texture.depth_or_layers << " fmt=" << static_cast<uint32_t>(desc.texture.format)
          << " (source 0x" << std::hex << resource.handle << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      } else if (previous != resource.handle && log_this) {
        std::stringstream s;
        s << "control-rr: " << name << " source changed to 0x" << std::hex << resource.handle;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
      // The source is a compute SRV. Use NON_PIXEL_SHADER_RESOURCE because
      // PIXEL_SHADER_RESOURCE is not valid on this compute command list.
      const reshade::api::resource_usage src_state = reshade::api::resource_usage::shader_resource_non_pixel;
      // A new snapshot is already in copy_dest. Transition it back to that
      // state only after a previous copy has left it in the SRV state.
      const reshade::api::resource res[2] = {resource, snap.texture};
      const reshade::api::resource_usage before[2] = {src_state,
                                                      reshade::api::resource_usage::shader_resource_non_pixel};
      const reshade::api::resource_usage to_copy[2] = {reshade::api::resource_usage::copy_source,
                                                       reshade::api::resource_usage::copy_dest};
      cmd_list->barrier(snap.has_content ? 2u : 1u, res, before, to_copy);
      cmd_list->copy_resource(resource, snap.texture);
      const reshade::api::resource_usage after[2] = {src_state,
                                                     reshade::api::resource_usage::shader_resource_non_pixel};
      cmd_list->barrier(2, res, to_copy, after);
      snap.has_content = true;
      rr::SetGuide(name, reinterpret_cast<ID3D12Resource*>(snap.texture.handle));
    };
    snapshot("matid", 26, last_matid, snap_matid);
    snapshot("hitpos", 28, last_hitpos, snap_hitpos);
  }

  if (is_ui) {
    // u0 = the frame without the HUD, t0 = the HUD with its alpha. Copy both
    // before the dispatch runs, because it composites one into the other.
    auto copy_out = [&](const char* name, uint32_t reg, bool uav, std::atomic<uint64_t>& last,
                        HitSnapshot& snap, dlssg_probe::PublishedBuffer& published,
                        reshade::api::resource_usage src_state) {
      const auto retained = resolve(reg, uav);
      const reshade::api::resource resource = {reinterpret_cast<uint64_t>(retained.Get())};
      if (resource.handle == 0u) {
        // Control is heavily bindless, so a failed resolve is a real
        // possibility and must not pass quietly.
        static std::atomic<int> failures = 0;
        if (failures.fetch_add(1) < 4) {
          std::stringstream s;
          s << "control-rr: " << name << " (" << (uav ? "u" : "t") << reg
            << ") did NOT resolve at the UI compositor - nothing captured";
          reshade::log::message(reshade::log::level::warning, s.str().c_str());
        }
        return;
      }
      auto desc = device->get_resource_desc(resource);
      const bool same_shape = snap.texture.handle != 0u && snap.desc.texture.width == desc.texture.width
                              && snap.desc.texture.height == desc.texture.height
                              && snap.desc.texture.format == desc.texture.format;
      if (!same_shape) {
        // Withdraw the copy before it goes away. The tagging hook runs on the
        // presenting thread and would otherwise read a pointer we just freed;
        // a resolution change is exactly when this happens.
        dlssg_probe::Publish(published, nullptr, 0, 0, 0, 0);
        if (&published == &dlssg_probe::hudless_buffer) {
          sl_hdr10::bridge.hudless_source.store(nullptr);
        }
        RetireSnapshot(snap.texture);
        snap = {};
        reshade::api::resource_desc copy_desc = desc;
        copy_desc.heap = reshade::api::memory_heap::gpu_only;
        copy_desc.usage = reshade::api::resource_usage::copy_dest
                          | reshade::api::resource_usage::shader_resource;
        copy_desc.flags = reshade::api::resource_flags::none;
        if (!device->create_resource(copy_desc, nullptr, reshade::api::resource_usage::copy_dest,
                                     &snap.texture)) {
          reshade::log::message(reshade::log::level::warning, "control-rr: UI snapshot creation failed");
          snap.texture = {0};
          return;
        }
        snap.desc = copy_desc;
        std::stringstream s;
        s << "control-rr: " << name << " snapshot " << desc.texture.width << "x" << desc.texture.height
          << " fmt=" << static_cast<uint32_t>(desc.texture.format) << " (source 0x" << std::hex
          << resource.handle << ")";
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
      last.store(resource.handle);
      const reshade::api::resource res[2] = {resource, snap.texture};
      const reshade::api::resource_usage before[2] = {src_state,
                                                      reshade::api::resource_usage::shader_resource};
      const reshade::api::resource_usage to_copy[2] = {reshade::api::resource_usage::copy_source,
                                                       reshade::api::resource_usage::copy_dest};
      cmd_list->barrier(snap.has_content ? 2u : 1u, res, before, to_copy);
      cmd_list->copy_resource(resource, snap.texture);
      const reshade::api::resource_usage after[2] = {src_state,
                                                     reshade::api::resource_usage::shader_resource};
      cmd_list->barrier(2, res, to_copy, after);
      snap.has_content = true;
    };
    // u0 is read-modify-written by this dispatch, so it is in
    // unordered_access; t0 is a compute SRV, which is non-pixel only.
    copy_out("hudless", 0, true, last_hudless_src, snap_hudless, dlssg_probe::hudless_buffer,
             reshade::api::resource_usage::unordered_access);
    copy_out("ui", 0, false, last_ui_src, snap_ui, dlssg_probe::ui_buffer,
             reshade::api::resource_usage::shader_resource_non_pixel);
    // Hand both to frame generation. The barriers above leave each copy in
    // shader_resource, whose ReShade value IS the D3D12 state bit pattern
    // (PIXEL 0x80 | NON_PIXEL 0x40), and that is the state they will be in at
    // Present, which is when Streamline reads them.
    if (snap_hudless.has_content && snap_ui.has_content) {
      const auto shader_resource_state =
          static_cast<uint32_t>(reshade::api::resource_usage::shader_resource);
      // Frame generation compares the final colour against the hud-less one,
      // so both have to be in the same encoding. Once the back buffer is PQ,
      // handing over this raw FP16 snapshot makes that comparison meaningless
      // and the error concentrates on edges under motion. Give the bridge the
      // snapshot and tag its PQ-encoded copy instead.
      sl_hdr10::bridge.hudless_source.store(
          reinterpret_cast<void*>(snap_hudless.texture.handle));
      auto* encoded = sl_hdr10::bridge.hudless_encoded;
      const bool use_encoded = sl_hdr10::enabled.load() && encoded != nullptr;
      dlssg_probe::Publish(
          dlssg_probe::hudless_buffer,
          use_encoded ? static_cast<void*>(encoded)
                      : reinterpret_cast<void*>(snap_hudless.texture.handle),
          snap_hudless.desc.texture.width, snap_hudless.desc.texture.height,
          use_encoded ? static_cast<uint32_t>(DXGI_FORMAT_R10G10B10A2_UNORM)
                      : static_cast<uint32_t>(snap_hudless.desc.texture.format),
          use_encoded ? static_cast<uint32_t>(D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE)
                      : shader_resource_state);
      dlssg_probe::Publish(dlssg_probe::ui_buffer,
                           reinterpret_cast<void*>(snap_ui.texture.handle),
                           snap_ui.desc.texture.width, snap_ui.desc.texture.height,
                           static_cast<uint32_t>(snap_ui.desc.texture.format),
                           shader_resource_state);
    }
  }

  // Capture only constants at the specular pass: its t7 is history, whereas
  // the diffuse pass used for guide capture binds hit information there.
  if (is_matrix_src) CaptureCameraMatrices(rr_data);

  return false;
}

bool OnDispatchIndirectCapture(
    reshade::api::command_list* cmd_list,
    reshade::api::indirect_command type,
    reshade::api::resource, uint64_t, uint32_t, uint32_t) {
  if (type == reshade::api::indirect_command::draw
      || type == reshade::api::indirect_command::draw_indexed) {
    return false;
  }
  return OnDispatchCapture(cmd_list, 0, 0, 0);
}

void OnInitCommandList(reshade::api::command_list* cmd_list) {
  // Retry installation as command lists are created. The startup watcher
  // handles earlier loads; this returns immediately once the hook is installed.
  if (sl_hdr10::enabled.load()) sl_hdr10::TryInstall();
  RRCommandListData* data;
  renodx::utils::data::CreateOrGet(cmd_list, data);
}

void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  cmd_list->destroy_private_data<RRCommandListData>();
}

// The game destroys its G-buffers on a render-resolution change. A guide
// pointer left on a destroyed texture is read by the decode dispatch on the
// next evaluate — a driver access violation. Forget it; the next DLF
// dispatch re-captures the replacement and the evaluate hook falls back to
// the game's SR until then.
void OnDestroyResource(reshade::api::device*, reshade::api::resource resource) {
  auto forget = [&](std::atomic<uint64_t>& last, const char* name) {
    uint64_t expected = resource.handle;
    if (expected != 0u && last.compare_exchange_strong(expected, 0u)) {
      rr::SetGuide(name, nullptr);
      std::stringstream s;
      s << "control-rr: " << name << " destroyed by the game — guide forgotten";
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  };
  forget(last_gbuffer1, "gbuffer1");
  forget(last_gbuffer2, "gbuffer2");
  forget(last_material, "material");
  forget(last_envbrdf, "envbrdf");
#ifdef CONTROL_RR_DEV
  forget(last_hitinfo, "hitinfo");
#endif
  // matid/hitpos guides point at OUR snapshots, not the game's arrays — nothing to forget
  uint64_t expected = resource.handle;
  last_matid.compare_exchange_strong(expected, 0u);
  expected = resource.handle;
  last_hitpos.compare_exchange_strong(expected, 0u);
}

// ---------------------------------------------------------------------------

renodx::utils::settings::Settings settings = {
    odd_resolution_warning = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Odd render resolution detected.",
        .section = "Ray Tracing",
        .tint = 0xFF0000,
        .is_visible = []() { return OddRenderSize(); },
    },
    odd_resolution_advice = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "See renderer.ini.",
        .section = "Ray Tracing",
        .tint = 0xFF0000,
        .is_visible = []() { return OddRenderSize(); },
    },
    rr_failed_warning = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Ray Reconstruction is off.",
        .section = "Ray Tracing",
        .tint = 0xFF0000,
        .is_visible = []() { return rr::rr_failed.load(); },
    },
    sr_failed_warning = new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "SR preset override failed.",
        .section = "Ray Tracing",
        .tint = 0xFF0000,
        .is_visible = []() { return rr::sr_failed.load(); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Preset F needs a newer driver, so preset E is being used instead.",
        .section = "Ray Tracing",
        .tint = 0xFFAA00,
        .is_visible = []() { return rr::rr_preset_downgraded.load(); },
    },
    new renodx::utils::settings::Setting{
        .key = "Denoiser",
        .binding = &denoiser_setting,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Denoiser",
        .section = "Ray Tracing",
        .tooltip = "Who denoises the ray tracing. Game: Control's own denoiser."
                   " DLSS Super Resolution: the game's denoiser is bypassed and"
                   " DLSS reconstructs from the raw signal. DLSS Ray"
                   " Reconstruction: the same, using NVIDIA's denoising model.",
        .labels = {"Game", "DLSS Super Resolution", "DLSS Ray Reconstruction"},
        .on_change_value = [](float, float) {
          ApplyToggle();
          rr::SetRrEnabled(RrEnabled());
        },
    },
    new renodx::utils::settings::Setting{
        .key = "RRPreset",
        .binding = &rr_preset_setting,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "RR preset",
        .section = "Ray Tracing",
        .labels = {"D", "E", "F"},
        .on_change_value = [](float, float value) {
          rr::SetRrPreset(RR_PRESET_VALUES[static_cast<int>(value)]);
        },
    },
    new renodx::utils::settings::Setting{
        .key = "SRPreset",
        .binding = &sr_preset_setting,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "SR preset",
        .section = "Ray Tracing",
        .labels = {"Default", "J", "K", "L", "M"},
        .on_change_value = [](float, float value) {
          rr::SetSrPreset(SR_PRESET_VALUES[static_cast<int>(value)]);
        },
    },
    new renodx::utils::settings::Setting{
        .key = "RRResponsivity",
        .binding = &rr_responsivity_setting,
        .default_value = 0.f,
        .label = "RR responsivity (experimental)",
        .section = "Ray Tracing",
        .tooltip = "Preset F only. Biases how fast Ray Reconstruction reacts"
                   " to change: negative = more stable, positive = more"
                   " responsive. 0 = default.",
        .min = -1.f,
        .max = 1.f,
        .format = "%.2f",
        .on_change_value = [](float, float value) { rr::responsivity_value = value; },
    },
#ifdef CONTROL_RR_DEV
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Dump frame + census",
        .section = "Ray Tracing",
        .tooltip = "Writes the DLSS inputs, our guides AND the upscaler's"
                   " output to renodx-dev/dump, plus a census of every texture"
                   " size the game has created, to the log. Diagnostics.",
        .on_change = []() {
          rr::RequestDump();
          LogTextureCensus();
          reshade::log::message(reshade::log::level::info,
                                "control-rr: dump + census requested from the overlay");
        },
    },
#endif
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "DLSS frame generation via OptiScaler. HDR only.",
        .section = "Frame generation",
    },
    new renodx::utils::settings::Setting{
        .key = "FgSlHdr10",
        .binding = &fg_sl_hdr10_setting,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "HDR10 bridge (HDR only, restart required)",
        .section = "Frame generation",
        .tooltip = "Required for DLSS frame generation. OptiScaler: FGInput=Upscaler,"
                   " FGOutput=DLSSG, ForceReflex=2.",
        .on_change_value = [](float, float) {},
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Restart required.",
        .section = "Frame generation",
        .tint = 0xFF0000,
        .is_visible = []() { return fg_sl_hdr10_setting != fg_sl_hdr10_boot_value; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "NVIDIA's overlay shows which preset is actually running. Run one of these"
                 " in PowerShell as administrator, then restart the game:",
        .section = "DLSS indicator",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Copy \"indicator on\" command",
        .section = "DLSS indicator",
        .group = "button-line-indicator",
        .on_change = []() {
          ImGui::SetClipboardText("Set-ItemProperty 'HKLM:\\SOFTWARE\\NVIDIA Corporation\\Global\\NGXCore' ShowDlssIndicator 1024 -Type DWord");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Copy \"indicator off\" command",
        .section = "DLSS indicator",
        .group = "button-line-indicator",
        .on_change = []() {
          ImGui::SetClipboardText("Set-ItemProperty 'HKLM:\\SOFTWARE\\NVIDIA Corporation\\Global\\NGXCore' ShowDlssIndicator 0 -Type DWord");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "speedlemur's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/", "speedlemur87816"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/", "shortfuse"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "speedlemur: mod creator",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "ShortFuse: RenoDX creator + maintainer",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("Denoiser", 0.f);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX - Control";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "DLSS Ray Reconstruction for Control's ray tracing";

// Keep the addon loaded for the process lifetime so installed hooks cannot
// outlive its code. ReShade may release its addon reference when a temporary
// device is destroyed; the watcher thread's module reference lasts only until
// that thread exits (ucrt/startup/thread.cpp).
extern "C" IMAGE_DOS_HEADER __ImageBase;
static void PinModule() {
  HMODULE self = nullptr;
  if (GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
                         reinterpret_cast<LPCWSTR>(&__ImageBase), &self)
      == 0) {
    std::stringstream s;
    s << "control-rr: could NOT pin the addon module (error 0x" << std::hex << GetLastError()
      << ") - the DLL may unload mid-boot and crash the game";
    reshade::log::message(reshade::log::level::error, s.str().c_str());
  }
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      PinModule();
      control_diag::Init(h_module);

      // Runtime (bind-time) shadow-PSO replacement only — no cbuffer
      // injection, no root-signature or layout modification of any kind.
      renodx::mods::shader::force_pipeline_cloning = true;

      // REQUIRED for the live denoiser toggle: Add/RemoveRuntimeReplacements
      // only takes effect on the async bind-time replacement path.
      renodx::utils::shader::use_replace_async = true;

      // Enables the descriptor-heap mirror that OnDispatchCapture resolves
      // GBuffer1 through.
      // Descriptor contents must be mirrored from heap creation onward so a
      // live RR/FG toggle can resolve tables that were populated earlier.
      // The expensive per-frame copies remain consumer-gated below.
      renodx::utils::descriptor::trace_descriptor_tables = true;

      // In-process RR: watch for the NGX runtime and detour its D3D12
      // exports (CreateFeature/EvaluateFeature). See rr.hpp.
      rr::InstallLoaderHooks();

      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchainLog);
      reshade::register_event<reshade::addon_event::init_device>(OnInitDeviceApply);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDeviceApply);
      reshade::register_event<reshade::addon_event::present>(OnPresentApplyOnce);
      reshade::register_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::register_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
#ifdef CONTROL_RR_DEV
      reshade::register_event<reshade::addon_event::init_resource>(OnInitResource);
#endif
      reshade::register_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::register_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::register_event<reshade::addon_event::dispatch>(OnDispatchCapture);
      reshade::register_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDispatchIndirectCapture);

      break;
    case DLL_PROCESS_DETACH:
      control_diag::Mark("process.detach", reinterpret_cast<uint64_t>(lpv_reserved));
      rr::UninstallHooks();
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchainLog);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDeviceApply);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDeviceApply);
      reshade::unregister_event<reshade::addon_event::present>(OnPresentApplyOnce);
      reshade::unregister_event<reshade::addon_event::init_command_list>(OnInitCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
      reshade::unregister_event<reshade::addon_event::destroy_resource>(OnDestroyResource);
#ifdef CONTROL_RR_DEV
      reshade::unregister_event<reshade::addon_event::init_resource>(OnInitResource);
#endif
      reshade::unregister_event<reshade::addon_event::bind_descriptor_tables>(OnBindDescriptorTables);
      reshade::unregister_event<reshade::addon_event::push_descriptors>(OnPushDescriptors);
      reshade::unregister_event<reshade::addon_event::dispatch>(OnDispatchCapture);
      reshade::unregister_event<reshade::addon_event::draw_or_dispatch_indirect>(OnDispatchIndirectCapture);
      break;
  }

  renodx::utils::settings::use_presets = false;  // no vanilla/1/2/3 presets for this mod
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);

  if (fdw_reason == DLL_PROCESS_ATTACH) {
    // Read only on process attach, after settings::Use loaded the saved value.
    // Thread attach/detach must not mutate session boot state.
    fg_sl_hdr10_boot_value = fg_sl_hdr10_setting;
    sl_hdr10::enabled = (fg_sl_hdr10_setting != 0.f);
    if (sl_hdr10::enabled.load()) sl_hdr10::WatchForStreamline();
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders);
  renodx::utils::descriptor::Use(fdw_reason);

  if (fdw_reason == DLL_PROCESS_DETACH) {
    reshade::unregister_addon(h_module);
  }

  return TRUE;
}
