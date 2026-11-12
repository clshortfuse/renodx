/*
 * Copyright (C) 2026 speedlemur
 * SPDX-License-Identifier: MIT
 *
 * control-rr: supplies frame generation with the hud-less and UI buffers
 * Control does not provide, by attaching to the host's Streamline instance.
 *
 * Streamline registers four required tags for DLSS-G: depth, motion vectors,
 * hud-less colour and UI colour+alpha. The host driving the upscaler tags the
 * first two; the last two do not exist in Control's pipeline as such, so the
 * addon copies them out at the game's UI compositor and this file appends
 * them to every slSetTagForFrame call that goes past. Without them the UI is
 * interpolated as part of the picture and smears.
 *
 * We never init Streamline, never change anyone's options, and never touch a
 * tag somebody else set. If Streamline is not loaded every function here is
 * a no-op.
 */

#pragma once

#include <windows.h>
#include <detours.h>

#include <atomic>
#include <sstream>
#include <string>
#include <vector>

#include <sl.h>
#include <sl_core_api.h>


#include <include/reshade.hpp>

namespace dlssg_probe {

inline void Log(const std::string& msg) {
  control_diag::Mark(msg.c_str());
  reshade::log::message(reshade::log::level::info, ("dlssg-probe: " + msg).c_str());
}
inline void LogWarn(const std::string& msg) {
  control_diag::Mark(msg.c_str());
  reshade::log::message(reshade::log::level::warning, ("dlssg-probe: " + msg).c_str());
}

// Both tag entry points are detoured. slSetTag logs and forwards;
// slSetTagForFrame also appends our buffers.
inline PFun_slSetTag* real_sl_set_tag = nullptr;
inline PFun_slSetTagForFrame* real_sl_set_tag_for_frame = nullptr;
inline std::atomic<bool> resolved = false;
inline std::atomic<bool> unavailable = false;
inline std::atomic<bool> active = false;

inline const char* BufferTypeName(sl::BufferType type) {
  switch (type) {
    case sl::kBufferTypeDepth: return "Depth";
    case sl::kBufferTypeMotionVectors: return "MotionVectors";
    case sl::kBufferTypeHUDLessColor: return "HUDLessColor";
    case sl::kBufferTypeUIColorAndAlpha: return "UIColorAndAlpha";
    case sl::kBufferTypeScalingInputColor: return "ScalingInputColor";
    case sl::kBufferTypeScalingOutputColor: return "ScalingOutputColor";
    case sl::kBufferTypeBackbuffer: return "Backbuffer";
    case sl::kBufferTypeExposure: return "Exposure";
    default: return "other";
  }
}

// ---------------------------------------------------------------------------
// The two buffers nobody supplies.
//
// Tags are independent of one another and may be set in separate calls as each
// buffer becomes available (Streamline programming guide, "Tagging
// recommendations"). Adding ours to a call that is already happening for this
// frame is therefore a legitimate way to set them, and it means we never have
// to produce a frame token of our own - producing one advances Streamline's
// internal counter, which would desynchronise whoever else is counting.
//
// The addon fills these in at the UI compositor; until it does, both natives
// are null and we pass every call straight through.
// ---------------------------------------------------------------------------

struct PublishedBuffer {
  std::atomic<void*> native{nullptr};
  std::atomic<uint32_t> width{0};
  std::atomic<uint32_t> height{0};
  std::atomic<uint32_t> format{0};  // native DXGI format
  //! D3D12_RESOURCE_STATES the resource will be in when frame generation reads
  //! it during Present. Mandatory and must be right (sl_core_types.h Resource).
  std::atomic<uint32_t> state{0};
  std::atomic<uint64_t> frame{0};  // our frame counter when it was last written
};

inline PublishedBuffer hudless_buffer;
inline PublishedBuffer ui_buffer;
inline std::atomic<uint64_t> frame_counter{0};

inline void Publish(PublishedBuffer& buffer, void* native, uint32_t width, uint32_t height,
                    uint32_t format, uint32_t state) {
  buffer.width.store(width, std::memory_order_relaxed);
  buffer.height.store(height, std::memory_order_relaxed);
  buffer.format.store(format, std::memory_order_relaxed);
  buffer.state.store(state, std::memory_order_relaxed);
  buffer.frame.store(frame_counter.load(std::memory_order_relaxed), std::memory_order_relaxed);
  // Last, with a release: a reader that sees the pointer sees the rest too.
  buffer.native.store(native, std::memory_order_release);
}

// One line the first time each buffer type is seen, then silence.
inline void NoteTags(const sl::ResourceTag* tags, uint32_t count, const char* via) {
#if defined(CONTROL_RR_DEV) || defined(CONTROL_RR_DIAGNOSTICS)
  if (tags == nullptr) return;
  static std::atomic<uint64_t> seen_mask = 0;
  for (uint32_t i = 0; i < count; ++i) {
    const auto type = static_cast<uint32_t>(tags[i].type);
    if (type >= 64u) continue;
    const uint64_t bit = 1ull << type;
    if ((seen_mask.fetch_or(bit) & bit) != 0u) continue;
    std::stringstream s;
    s << "tag " << BufferTypeName(tags[i].type) << " (id " << type << ") supplied via " << via
      << " - resource " << (tags[i].resource != nullptr ? tags[i].resource->native : nullptr);
    Log(s.str());
  }
#endif
}

inline sl::Result HookedSetTag(const sl::ViewportHandle& viewport, sl::ResourceTag* tags,
                               uint32_t num_tags, sl::CommandBuffer* cmd) {
  NoteTags(tags, num_tags, "slSetTag");
  return real_sl_set_tag(viewport, tags, num_tags, cmd);
}

inline sl::Result HookedSetTagForFrame(const sl::FrameToken& frame, const sl::ViewportHandle& viewport,
                                       const sl::ResourceTag* tags, uint32_t num_tags,
                                       sl::CommandBuffer* cmd) {
  control_diag::Scope trace("fg.tags");
  control_diag::Mark("fg.tags.frame", static_cast<uint32_t>(frame), num_tags);
  NoteTags(tags, num_tags, "slSetTagForFrame");

  if (!active.load()) {
    return real_sl_set_tag_for_frame(frame, viewport, tags, num_tags, cmd);
  }

  auto* hudless_native = hudless_buffer.native.load(std::memory_order_acquire);
  auto* ui_native = ui_buffer.native.load(std::memory_order_acquire);
  if (hudless_native == nullptr || ui_native == nullptr) {
    return real_sl_set_tag_for_frame(frame, viewport, tags, num_tags, cmd);
  }

  // These live for the duration of the call, which is all that is needed:
  // slSetTagForFrame takes the tag list by const pointer and copies what it
  // keeps, and the guide's own example passes stack resources the same way.
  sl::Resource hudless_res(sl::ResourceType::eTex2d, hudless_native, hudless_buffer.state.load());
  hudless_res.width = hudless_buffer.width.load();
  hudless_res.height = hudless_buffer.height.load();
  hudless_res.nativeFormat = hudless_buffer.format.load();
  sl::Resource ui_res(sl::ResourceType::eTex2d, ui_native, ui_buffer.state.load());
  ui_res.width = ui_buffer.width.load();
  ui_res.height = ui_buffer.height.load();
  ui_res.nativeFormat = ui_buffer.format.load();

  const sl::Extent hudless_extent{.width = hudless_res.width, .height = hudless_res.height};
  const sl::Extent ui_extent{.width = ui_res.width, .height = ui_res.height};

  // eValidUntilPresent, per the guide's instruction to start there for every
  // DLSS-G input: these are OUR copies, written once a frame and touched by
  // nothing else, so they still hold this frame's content at Present. Also
  // means Streamline holds a reference and manages their state itself - we
  // must not transition them, only report the state correctly above.
  std::vector<sl::ResourceTag> extended;
  extended.reserve(static_cast<size_t>(num_tags) + 2u);
  for (uint32_t i = 0; i < num_tags; ++i) extended.push_back(tags[i]);
  extended.emplace_back(&hudless_res, sl::kBufferTypeHUDLessColor,
                        sl::ResourceLifecycle::eValidUntilPresent, &hudless_extent);
  extended.emplace_back(&ui_res, sl::kBufferTypeUIColorAndAlpha,
                        sl::ResourceLifecycle::eValidUntilPresent, &ui_extent);

  const auto result = real_sl_set_tag_for_frame(frame, viewport, extended.data(),
                                                static_cast<uint32_t>(extended.size()), cmd);
  control_diag::Mark("fg.tags.result", static_cast<uint32_t>(result));

  // Loud once, then only when something changes or goes wrong. The staleness
  // figures matter: if the compositor for this frame has not run by the time
  // this call is made, we are handing over last frame's HUD, which would show
  // up as a trailing UI rather than as an outright failure.
  static std::atomic<uint32_t> logged = 0;
  static std::atomic<uint32_t> last_result = 0xFFFFFFFFu;
  const auto result_code = static_cast<uint32_t>(result);
  const bool first_few = logged.fetch_add(1) < 1;
  if (first_few || last_result.exchange(result_code) != result_code) {
    const auto now = frame_counter.load();
    std::stringstream s;
    s << "supplied HUDLessColor + UIColorAndAlpha for frame " << static_cast<uint32_t>(frame)
      << " -> result " << result_code << " (" << (result_code == 0 ? "eOk" : "FAILED") << ")"
      << " | hudless " << hudless_res.width << "x" << hudless_res.height
      << " fmt=" << hudless_res.nativeFormat << " state=0x" << std::hex << hudless_res.state
      << std::dec << " age=" << (now - hudless_buffer.frame.load()) << " frames"
      << " | ui " << ui_res.width << "x" << ui_res.height << " fmt=" << ui_res.nativeFormat
      << " state=0x" << std::hex << ui_res.state << std::dec
      << " age=" << (now - ui_buffer.frame.load()) << " frames";
    if (result_code == 0) {
      Log(s.str());
    } else {
      LogWarn(s.str());
    }
  }
  return result;
}

// Attaches to Streamline only if it is already in the process (found by
// module name); loads and pins nothing. Both tag entry points are core
// interposer exports.
inline bool Resolve() {
  if (resolved.load()) return true;
  if (unavailable.load()) return false;
  HMODULE interposer = GetModuleHandleW(L"sl.interposer.dll");
  if (interposer == nullptr) return false;  // no Streamline in the process yet

  const std::lock_guard install_lock(control_rr::detour_mutex);
  if (resolved.load()) return true;
  if (unavailable.load()) return false;

  auto* set_tag = reinterpret_cast<PFun_slSetTag*>(GetProcAddress(interposer, "slSetTag"));
  auto* set_tag_frame =
      reinterpret_cast<PFun_slSetTagForFrame*>(GetProcAddress(interposer, "slSetTagForFrame"));
  if (set_tag == nullptr || set_tag_frame == nullptr) {
    LogWarn("sl.interposer.dll has no tag entry points - hud-less and UI will not be supplied");
    unavailable.store(true);
    return false;
  }
  real_sl_set_tag = set_tag;
  real_sl_set_tag_for_frame = set_tag_frame;
  LONG error = DetourTransactionBegin();
  const bool transaction_started = error == NO_ERROR;
  if (error == NO_ERROR) error = DetourUpdateThread(GetCurrentThread());
  if (error == NO_ERROR) {
    error = DetourAttach(reinterpret_cast<void**>(&real_sl_set_tag), HookedSetTag);
  }
  if (error == NO_ERROR) {
    error = DetourAttach(reinterpret_cast<void**>(&real_sl_set_tag_for_frame), HookedSetTagForFrame);
  }
  if (error != NO_ERROR) {
    if (transaction_started) DetourTransactionAbort();
  } else {
    error = DetourTransactionCommit();
  }
  if (error != NO_ERROR) {
    LogWarn("could not detour the tag functions");
    real_sl_set_tag = nullptr;
    real_sl_set_tag_for_frame = nullptr;
    return false;
  }
  resolved.store(true);
  Log("watching slSetTag / slSetTagForFrame - hud-less and UI will be appended");
  return true;
}

// Called from the present handler.
inline void Poll() {
  // Counted every present, whether or not Streamline is here, so that the
  // "age" figures in the tag log mean frames and not calls.
  frame_counter.fetch_add(1, std::memory_order_relaxed);
  Resolve();
}

}  // namespace dlssg_probe
