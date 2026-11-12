/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 */

#pragma once

// control-rr: diffuse-albedo capture from the material pass.
//
// Three hooks:
//   1. create_pipeline — any pixel shader that reads g_tLightBufferDiffuse
//      is patched (albedo_patch.hpp) to also write its albedo to
//      SV_Target1, and the pipeline gets an RGBA16F second target.
//   2. bind_pipeline / bind_render_targets — while a patched pipeline is
//      bound with a single render target, our albedo texture is appended
//      as target 1. Unpatched pipelines drawing with it bound simply
//      don't write it.
//   3. rr.hpp — AcquireForRead/ReleaseAfterRead around the guide decode:
//      transition to SRV, consume, transition back, clear. Command lists
//      execute in order, so clearing at the consume point leaves the
//      target ready for the next frame's material pass.
//
// The material pass draws at render resolution into an RGBA16F scene
// colour target with no blending (devkit snapshot 2026-09-27: 1706x960,
// one RTV + depth), which is why a second target of the same size fits.

#include <d3d12.h>

#include <atomic>
#include <cstdlib>
#include <cstring>
#include <mutex>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <include/reshade.hpp>

#include "../../utils/data.hpp"
#include "../../utils/hash.hpp"
#include "../../utils/pipeline.hpp"
#include "./albedo_patch.hpp"

namespace control_albedo {

// Release builds keep warnings and errors only.
inline void Log(const std::string& msg, reshade::log::level level = reshade::log::level::info) {
#if !defined(CONTROL_RR_DEV) && !defined(CONTROL_RR_DIAGNOSTICS)
  if (level == reshade::log::level::info) return;
#endif
  reshade::log::message(level, ("control-rr albedo: " + msg).c_str());
}

// --- patched pipeline registry ---
inline std::mutex registry_mutex;
inline std::unordered_set<uint32_t> patched_hashes;     // CRC32 of every patched PS blob
inline std::unordered_set<uint64_t> patched_pipelines;  // pipelines built with one
// Fallback for pipelines create_pipeline never saw (ReShade skips the event
// for ID3D12PipelineLibrary loads): a patched clone bound in place of the
// game's pipeline at bind time — the same mechanism this mod uses for its
// own shader replacements. Keyed by the game's pipeline handle.
inline std::unordered_map<uint64_t, reshade::api::pipeline> clones;
inline std::atomic<uint32_t> patched_count = 0;
inline std::atomic<uint32_t> skipped_count = 0;
inline std::atomic<uint32_t> pipeline_count = 0;
inline std::atomic<uint32_t> clone_count = 0;
inline std::atomic<bool> self_checked = false;

// --- albedo target (one, at the material pass's resolution) ---
inline std::mutex target_mutex;
inline reshade::api::device* target_device = nullptr;
inline reshade::api::resource target_res = {0};
inline reshade::api::resource_view target_rtv = {0};
inline uint32_t target_width = 0;
inline uint32_t target_height = 0;
// Replaced targets are never destroyed: an in-flight command list may
// still reference them. One per resolution change, so this stays tiny.
inline std::vector<reshade::api::resource> graveyard;
inline std::atomic<uint32_t> binds_this_frame = 0;
inline std::atomic<uint32_t> frames_consumed = 0;
inline std::atomic<bool> capture_enabled = true;
inline std::atomic<uint32_t> mismatch_logged = 0;

// per-command-list binding state
struct __declspec(uuid("6f1c2a84-9b0e-4c57-8d2a-3e5f7a9b1c0d")) CmdState {
  uint32_t count = 0;
  reshade::api::resource_view rtvs[8] = {};
  reshade::api::resource_view dsv = {0};
  bool patched = false;    // current pipeline writes albedo
  bool augmented = false;  // our target is currently bound as RT1
};

inline CmdState* State(reshade::api::command_list* cmd_list) {
  CmdState* state = nullptr;
  renodx::utils::data::CreateOrGet<CmdState>(cmd_list, state);
  return state;
}

// One-time sanity check on the first patched blob: disassemble it with the
// game's own d3dcompiler_47 and confirm the inserted instructions are there.
inline void SelfCheck(const void* code, size_t size) {
#if !defined(CONTROL_RR_DEV) && !defined(CONTROL_RR_DIAGNOSTICS)
  return;
#endif
  if (self_checked.exchange(true)) return;
  using PFN_D3DDisassemble = HRESULT(WINAPI*)(LPCVOID, SIZE_T, UINT, LPCSTR, ID3DBlob**);
  HMODULE module = LoadLibraryW(L"d3dcompiler_47.dll");
  auto* fn = module != nullptr
                 ? reinterpret_cast<PFN_D3DDisassemble>(GetProcAddress(module, "D3DDisassemble"))
                 : nullptr;
  if (fn == nullptr) {
    Log("self-check skipped (d3dcompiler_47 unavailable)", reshade::log::level::warning);
    return;
  }
  ID3DBlob* text = nullptr;
  const HRESULT hr = fn(code, size, 0, nullptr, &text);
  if (FAILED(hr) || text == nullptr) {
    std::stringstream s;
    s << "SELF-CHECK FAILED: D3DDisassemble rejected the first patched blob, hr=0x" << std::hex << hr;
    Log(s.str(), reshade::log::level::error);
    return;
  }
  const std::string_view asm_text(static_cast<const char*>(text->GetBufferPointer()), text->GetBufferSize());
  const bool has_mov = asm_text.find("mov o1.xyz") != std::string_view::npos;
  const bool has_dcl = asm_text.find("dcl_output o1") != std::string_view::npos;
  const bool has_sig = asm_text.find("SV_Target                1") != std::string_view::npos;
  std::stringstream s;
  s << "self-check: disassembly " << (has_mov && has_dcl && has_sig ? "OK" : "INCOMPLETE") << " (mov o1="
    << has_mov << ", dcl o1=" << has_dcl << ", signature=" << has_sig << ")";
  Log(s.str(), has_mov && has_dcl && has_sig ? reshade::log::level::info : reshade::log::level::error);
  text->Release();
}

// --- hook 1: patch at pipeline creation ---
inline bool OnCreatePipeline(reshade::api::device* device, reshade::api::pipeline_layout /*layout*/,
                             uint32_t subobject_count, const reshade::api::pipeline_subobject* subobjects) {
  const reshade::api::pipeline_subobject* ps_sub = nullptr;
  const reshade::api::pipeline_subobject* rt_sub = nullptr;
  for (uint32_t i = 0; i < subobject_count; ++i) {
    if (subobjects[i].type == reshade::api::pipeline_subobject_type::pixel_shader) ps_sub = &subobjects[i];
    if (subobjects[i].type == reshade::api::pipeline_subobject_type::render_target_formats) rt_sub = &subobjects[i];
  }
  if (ps_sub == nullptr) return false;
  auto* desc = static_cast<reshade::api::shader_desc*>(ps_sub->data);
  if (desc == nullptr || desc->code == nullptr || desc->code_size < 64) return false;

  // cheap reject: the name only appears in the reflection data of the material pass
  const std::string_view code(static_cast<const char*>(desc->code), desc->code_size);
  if (code.find("g_tLightBufferDiffuse") == std::string_view::npos) return false;

  const uint32_t crc = renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(desc->code), desc->code_size);
  std::stringstream tag;
  tag << "PS 0x" << std::hex << std::uppercase << crc << std::dec;

  if (rt_sub == nullptr || rt_sub->count != 1) {
    std::stringstream s;
    s << "SKIP " << tag.str() << ": render target count is " << (rt_sub != nullptr ? rt_sub->count : 0)
      << ", expected 1";
    Log(s.str(), reshade::log::level::warning);
    ++skipped_count;
    return false;
  }

  const auto result = PatchMaterialShader(static_cast<const uint8_t*>(desc->code), desc->code_size);
  if (!result.ok) {
    std::stringstream s;
    s << "SKIP " << tag.str() << ": " << result.reason;
    Log(s.str(), reshade::log::level::warning);
    ++skipped_count;
    return false;
  }

  // Never freed: ReShade reads it during creation and the shader details
  // keep the pointer; one allocation per material pipeline.
  void* copy = malloc(result.blob.size());
  if (copy == nullptr) return false;
  memcpy(copy, result.blob.data(), result.blob.size());
  desc->code = copy;
  desc->code_size = result.blob.size();

  auto* formats = static_cast<reshade::api::format*>(rt_sub->data);
  const auto rt0_format = formats[0];
  formats[1] = reshade::api::format::r16g16b16a16_float;
  const_cast<reshade::api::pipeline_subobject*>(rt_sub)->count = 2;

  const uint32_t new_crc = renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(copy), result.blob.size());
  {
    const std::lock_guard<std::mutex> lock(registry_mutex);
    patched_hashes.insert(new_crc);
  }
  const uint32_t n = ++patched_count;
  std::stringstream s;
  s << "patched " << tag.str() << " -> 0x" << std::hex << std::uppercase << new_crc << std::dec << " ("
    << code.size() << " -> " << result.blob.size() << " bytes, " << (result.sm51 ? "sm5.1" : "sm5.0")
    << ", lbd id " << result.lbd_id << ", alpha copies " << result.alpha_copies << ", rt0 format "
    << static_cast<uint32_t>(rt0_format) << ") #" << n << " on device " << static_cast<void*>(device);
  Log(s.str());
  SelfCheck(copy, result.blob.size());
  return true;
}

// Builds a patched clone of a material pipeline that reached init_pipeline
// unpatched. Returns false (logged) when it cannot.
inline bool CloneMaterialPipeline(reshade::api::device* device, reshade::api::pipeline_layout layout,
                                  uint32_t subobject_count, const reshade::api::pipeline_subobject* subobjects,
                                  reshade::api::pipeline pipeline, const reshade::api::shader_desc* ps,
                                  uint32_t crc) {
  std::stringstream tag;
  tag << "pipeline " << reinterpret_cast<void*>(pipeline.handle) << " PS 0x" << std::hex << std::uppercase << crc;

  const reshade::api::pipeline_subobject* rt_sub = nullptr;
  for (uint32_t i = 0; i < subobject_count; ++i) {
    if (subobjects[i].type == reshade::api::pipeline_subobject_type::render_target_formats) rt_sub = &subobjects[i];
  }
  if (rt_sub == nullptr || rt_sub->count != 1) {
    Log("clone SKIP " + tag.str() + ": render target count is not 1", reshade::log::level::warning);
    return false;
  }
  const auto result = PatchMaterialShader(static_cast<const uint8_t*>(ps->code), ps->code_size);
  if (!result.ok) {
    Log("clone SKIP " + tag.str() + ": " + result.reason, reshade::log::level::warning);
    return false;
  }

  auto* clone_subs = renodx::utils::pipeline::ClonePipelineSubObjects(subobjects, subobject_count);
  for (uint32_t i = 0; i < subobject_count; ++i) {
    auto& sub = clone_subs[i];
    if (sub.type == reshade::api::pipeline_subobject_type::pixel_shader) {
      auto* desc = static_cast<reshade::api::shader_desc*>(sub.data);
      free(const_cast<void*>(desc->code));
      desc->code = malloc(result.blob.size());
      memcpy(const_cast<void*>(desc->code), result.blob.data(), result.blob.size());
      desc->code_size = result.blob.size();
    } else if (sub.type == reshade::api::pipeline_subobject_type::render_target_formats) {
      const auto rt0 = static_cast<const reshade::api::format*>(sub.data)[0];
      free(sub.data);
      auto* formats = static_cast<reshade::api::format*>(malloc(sizeof(reshade::api::format) * 2));
      formats[0] = rt0;
      formats[1] = reshade::api::format::r16g16b16a16_float;
      sub.data = formats;
      sub.count = 2;
    }
  }
  reshade::api::pipeline clone = {0};
  const bool created = device->create_pipeline(layout, subobject_count, clone_subs, &clone);
  renodx::utils::pipeline::DestroyPipelineSubobjects(clone_subs, subobject_count);
  if (!created || clone.handle == 0u) {
    Log("clone FAILED " + tag.str() + ": create_pipeline rejected the patched clone", reshade::log::level::error);
    return false;
  }
  {
    const std::lock_guard<std::mutex> lock(registry_mutex);
    clones[pipeline.handle] = clone;
    patched_pipelines.insert(pipeline.handle);
  }
  const uint32_t n = ++clone_count;
  std::stringstream s;
  s << "cloned " << tag.str() << " -> " << reinterpret_cast<void*>(clone.handle) << " (create_pipeline never saw it; "
    << result.alpha_copies << " alpha copies) #" << n;
  Log(s.str());
  SelfCheck(result.blob.data(), result.blob.size());
  return true;
}

inline void OnInitPipeline(reshade::api::device* device, reshade::api::pipeline_layout layout,
                           uint32_t subobject_count, const reshade::api::pipeline_subobject* subobjects,
                           reshade::api::pipeline pipeline) {
  if (pipeline.handle == 0u) return;
  for (uint32_t i = 0; i < subobject_count; ++i) {
    if (subobjects[i].type != reshade::api::pipeline_subobject_type::pixel_shader) continue;
    const auto* desc = static_cast<const reshade::api::shader_desc*>(subobjects[i].data);
    if (desc == nullptr || desc->code == nullptr || desc->code_size == 0) return;
    const uint32_t crc = renodx::utils::hash::ComputeCRC32(static_cast<const uint8_t*>(desc->code), desc->code_size);
    {
      const std::lock_guard<std::mutex> lock(registry_mutex);
      if (patched_hashes.contains(crc)) {
        patched_pipelines.insert(pipeline.handle);
        const uint32_t n = ++pipeline_count;
        if (n <= 8 || n % 32 == 0) {
          std::stringstream s;
          s << "pipeline " << reinterpret_cast<void*>(pipeline.handle) << " uses patched PS 0x" << std::hex
            << std::uppercase << crc << std::dec << " (#" << n << ")";
          Log(s.str());
        }
        return;
      }
    }
    // A material shader that create_pipeline did not patch: clone instead.
    const std::string_view code(static_cast<const char*>(desc->code), desc->code_size);
    if (code.find("g_tLightBufferDiffuse") == std::string_view::npos) return;
    CloneMaterialPipeline(device, layout, subobject_count, subobjects, pipeline, desc, crc);
    return;
  }
}

inline void OnDestroyPipeline(reshade::api::device* device, reshade::api::pipeline pipeline) {
  reshade::api::pipeline clone = {0};
  {
    const std::lock_guard<std::mutex> lock(registry_mutex);
    patched_pipelines.erase(pipeline.handle);
    auto it = clones.find(pipeline.handle);
    if (it != clones.end()) {
      clone = it->second;
      clones.erase(it);
    }
  }
  if (clone.handle != 0u) device->destroy_pipeline(clone);
}

// --- hook 2: bind our target alongside the scene colour ---

// Creates (or recreates) the albedo target to match render target 0.
inline bool EnsureTarget(reshade::api::device* device, reshade::api::resource_view rtv0) {
  const reshade::api::resource res0 = device->get_resource_from_view(rtv0);
  if (res0.handle == 0u) return false;
  const reshade::api::resource_desc desc = device->get_resource_desc(res0);
  if (desc.type != reshade::api::resource_type::texture_2d) return false;

  const std::lock_guard<std::mutex> lock(target_mutex);
  if (target_res.handle != 0u && target_device == device && target_width == desc.texture.width
      && target_height == desc.texture.height) {
    return true;
  }
  if (desc.texture.samples != 1) {
    if (mismatch_logged.fetch_add(1) < 3) {
      std::stringstream s;
      s << "material pass target is multisampled (" << desc.texture.samples << "x) — capture disabled";
      Log(s.str(), reshade::log::level::warning);
    }
    return false;
  }

  reshade::api::resource_desc new_desc(
      desc.texture.width, desc.texture.height, 1, 1, reshade::api::format::r16g16b16a16_float, 1,
      reshade::api::memory_heap::gpu_only,
      reshade::api::resource_usage::render_target | reshade::api::resource_usage::shader_resource);
  reshade::api::resource new_res = {0};
  if (!device->create_resource(new_desc, nullptr, reshade::api::resource_usage::render_target, &new_res)) {
    Log("albedo target creation FAILED", reshade::log::level::error);
    return false;
  }
  reshade::api::resource_view new_rtv = {0};
  if (!device->create_resource_view(new_res, reshade::api::resource_usage::render_target,
                                    reshade::api::resource_view_desc(reshade::api::format::r16g16b16a16_float),
                                    &new_rtv)) {
    Log("albedo RTV creation FAILED", reshade::log::level::error);
    device->destroy_resource(new_res);
    return false;
  }
  if (target_res.handle != 0u) graveyard.push_back(target_res);
  target_res = new_res;
  target_rtv = new_rtv;
  target_width = desc.texture.width;
  target_height = desc.texture.height;
  target_device = device;
  std::stringstream s;
  s << "albedo target created " << desc.texture.width << "x" << desc.texture.height << " (scene colour format "
    << static_cast<uint32_t>(desc.texture.format) << ", " << graveyard.size() << " retired)";
  Log(s.str());
  return true;
}

inline void Reconcile(reshade::api::command_list* cmd_list, CmdState* state) {
  bool want = capture_enabled.load() && state->patched && state->count == 1 && state->rtvs[0].handle != 0u;
  reshade::api::resource_view rtv = {0};
  if (want) {
    want = EnsureTarget(cmd_list->get_device(), state->rtvs[0]);
    if (want) {
      const std::lock_guard<std::mutex> lock(target_mutex);
      rtv = target_rtv;
    }
  }
  if (want == state->augmented) return;
  if (want) {
    const reshade::api::resource_view rtvs[2] = {state->rtvs[0], rtv};
    cmd_list->bind_render_targets_and_depth_stencil(2, rtvs, state->dsv);
    ++binds_this_frame;
  } else {
    cmd_list->bind_render_targets_and_depth_stencil(state->count, state->rtvs, state->dsv);
  }
  state->augmented = want;
}

inline void OnBindRenderTargets(reshade::api::command_list* cmd_list, uint32_t count,
                                const reshade::api::resource_view* rtvs, reshade::api::resource_view dsv) {
  CmdState* state = State(cmd_list);
  if (state == nullptr) return;
  state->count = count > 8 ? 8 : count;
  for (uint32_t i = 0; i < state->count; ++i) state->rtvs[i] = rtvs[i];
  state->dsv = dsv;
  state->augmented = false;  // the game just replaced whatever we had bound
  Reconcile(cmd_list, state);
}

inline void OnBindPipeline(reshade::api::command_list* cmd_list, reshade::api::pipeline_stage stages,
                           reshade::api::pipeline pipeline) {
  if ((static_cast<uint32_t>(stages) & static_cast<uint32_t>(reshade::api::pipeline_stage::pixel_shader)) == 0u) {
    return;
  }
  CmdState* state = State(cmd_list);
  if (state == nullptr) return;
  reshade::api::pipeline clone = {0};
  {
    const std::lock_guard<std::mutex> lock(registry_mutex);
    state->patched = patched_pipelines.contains(pipeline.handle);
    if (state->patched) {
      auto it = clones.find(pipeline.handle);
      if (it != clones.end()) clone = it->second;
    }
  }
  // clone path: the game just bound its own pipeline; swap in the patched one
  if (clone.handle != 0u && capture_enabled.load()) {
    cmd_list->bind_pipeline(reshade::api::pipeline_stage::all, clone);
  }
  Reconcile(cmd_list, state);
}

inline void OnResetCommandList(reshade::api::command_list* cmd_list) {
  CmdState* state = State(cmd_list);
  if (state != nullptr) *state = CmdState();
}

inline void OnDestroyCommandList(reshade::api::command_list* cmd_list) {
  renodx::utils::data::Delete<CmdState>(cmd_list);
}

// --- hook 3: consumption by the guide decode (rr.hpp) ---

inline ID3D12Resource* acquired = nullptr;
inline reshade::api::resource_view acquired_rtv = {0};

// Transitions the albedo target to SRV state on cmd_list and returns it, or
// nullptr when there is none / it does not match the guide size.
inline ID3D12Resource* AcquireForRead(ID3D12GraphicsCommandList* cmd_list, uint32_t width, uint32_t height) {
  reshade::api::resource res = {0};
  reshade::api::resource_view rtv = {0};
  {
    const std::lock_guard<std::mutex> lock(target_mutex);
    if (target_res.handle == 0u) return nullptr;
    if (target_width != width || target_height != height) {
      if (mismatch_logged.fetch_add(1) < 3) {
        std::stringstream s;
        s << "albedo target " << target_width << "x" << target_height << " does not match guide size " << width
          << "x" << height << " — not used";
        Log(s.str(), reshade::log::level::warning);
      }
      return nullptr;
    }
    res = target_res;
    rtv = target_rtv;
  }
  auto* resource = reinterpret_cast<ID3D12Resource*>(res.handle);
  D3D12_RESOURCE_BARRIER barrier = {};
  barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  barrier.Transition.pResource = resource;
  barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
  barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  cmd_list->ResourceBarrier(1, &barrier);
  acquired = resource;
  acquired_rtv = rtv;
  return resource;
}

// Transitions back to render target and clears, ready for the next frame.
inline void ReleaseAfterRead(ID3D12GraphicsCommandList* cmd_list) {
  if (acquired == nullptr) return;
  D3D12_RESOURCE_BARRIER barrier = {};
  barrier.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
  barrier.Transition.pResource = acquired;
  barrier.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
  barrier.Transition.StateBefore = D3D12_RESOURCE_STATE_NON_PIXEL_SHADER_RESOURCE;
  barrier.Transition.StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET;
  cmd_list->ResourceBarrier(1, &barrier);
  const float zero[4] = {0.f, 0.f, 0.f, 0.f};
  const D3D12_CPU_DESCRIPTOR_HANDLE handle = {static_cast<SIZE_T>(acquired_rtv.handle)};
  cmd_list->ClearRenderTargetView(handle, zero, 0, nullptr);
  acquired = nullptr;

  const uint32_t binds = binds_this_frame.exchange(0);
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
  const uint32_t frame = ++frames_consumed;
  if (frame <= 5 || frame % 600 == 0) {
    std::stringstream s;
    s << "guide consumed albedo (frame " << frame << ", " << binds << " augmented binds since last, "
      << patched_count.load() << " PS patched, " << skipped_count.load() << " skipped, "
      << pipeline_count.load() << " pipelines, " << clone_count.load() << " clones)";
    Log(s.str());
  }
#endif
}

inline void Install() {
  reshade::register_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
  reshade::register_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
  reshade::register_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
  reshade::register_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
  reshade::register_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargets);
  reshade::register_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
  reshade::register_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
  Log("installed (material-pass albedo capture)");
}

inline void Uninstall() {
  reshade::unregister_event<reshade::addon_event::create_pipeline>(OnCreatePipeline);
  reshade::unregister_event<reshade::addon_event::init_pipeline>(OnInitPipeline);
  reshade::unregister_event<reshade::addon_event::destroy_pipeline>(OnDestroyPipeline);
  reshade::unregister_event<reshade::addon_event::bind_pipeline>(OnBindPipeline);
  reshade::unregister_event<reshade::addon_event::bind_render_targets_and_depth_stencil>(OnBindRenderTargets);
  reshade::unregister_event<reshade::addon_event::reset_command_list>(OnResetCommandList);
  reshade::unregister_event<reshade::addon_event::destroy_command_list>(OnDestroyCommandList);
}

}  // namespace control_albedo
