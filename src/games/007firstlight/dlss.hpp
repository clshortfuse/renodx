#pragma once

#include <sstream>
#include <vector>

#include "../../utils/dlss/streamline_v2.hpp"
#include "../../utils/log.hpp"
#include "../../utils/vtable.hpp"

namespace firstlight::dlss {

inline float dlssg_hud_ghosting_fix = 1.f;
inline bool attached = false;
inline bool hook_installed = false;
inline bool logged_waiting_for_streamline = false;
inline bool logged_ui_tag_suppression = false;

inline sl::Result (*Real_slSetTag)(
    const sl::ViewportHandle& viewport,
    const sl::ResourceTag* tags,
    uint32_t numTags,
    sl::CommandBuffer* cmdBuffer) = nullptr;

inline decltype(&slSetTagForFrame) Real_slSetTagForFrame = nullptr;

inline bool ShouldSuppressResourceTag(sl::BufferType type) {
  if (dlssg_hud_ghosting_fix == 0.f) return false;
  if (type == sl::kBufferTypeUIColorAndAlpha) return true;
  if (type == sl::kBufferTypeHUDLessColor) return true;
  return false;
}

inline uint32_t CountSuppressedTags(const sl::ResourceTag* tags, uint32_t numTags) {
  if (tags == nullptr) return 0u;

  uint32_t suppressed_count = 0u;
  for (uint32_t i = 0u; i < numTags; ++i) {
    if (ShouldSuppressResourceTag(tags[i].type)) {
      ++suppressed_count;
    }
  }
  return suppressed_count;
}

inline void LogSuppressedUITag(uint32_t suppressed_count) {
  if (logged_ui_tag_suppression || suppressed_count == 0u) return;
  logged_ui_tag_suppression = true;

  std::stringstream s;
  s << "007 DLSSG: suppressing " << suppressed_count
    << " UI/HUD Streamline tag(s) to avoid HDR FG HUD ghosting.";
  reshade::log::message(reshade::log::level::info, s.str().c_str());
}

inline std::vector<sl::ResourceTag> BuildFilteredTags(const sl::ResourceTag* tags, uint32_t numTags, uint32_t suppressed_count) {
  std::vector<sl::ResourceTag> filtered_tags;
  filtered_tags.reserve(numTags - suppressed_count);

  for (uint32_t i = 0u; i < numTags; ++i) {
    if (ShouldSuppressResourceTag(tags[i].type)) continue;
    filtered_tags.push_back(tags[i]);
  }

  return filtered_tags;
}

inline sl::Result HookedSlSetTag(
    const sl::ViewportHandle& viewport,
    const sl::ResourceTag* tags,
    uint32_t numTags,
    sl::CommandBuffer* cmdBuffer) {
  const auto suppressed_count = CountSuppressedTags(tags, numTags);
  if (suppressed_count == 0u) {
    return Real_slSetTag(viewport, tags, numTags, cmdBuffer);
  }

  LogSuppressedUITag(suppressed_count);
  auto filtered_tags = BuildFilteredTags(tags, numTags, suppressed_count);
  if (filtered_tags.empty()) return sl::Result::eOk;

  return Real_slSetTag(viewport, filtered_tags.data(), static_cast<uint32_t>(filtered_tags.size()), cmdBuffer);
}

inline sl::Result HookedSlSetTagForFrame(
    const sl::FrameToken& frame,
    const sl::ViewportHandle& viewport,
    const sl::ResourceTag* tags,
    uint32_t numTags,
    sl::CommandBuffer* cmdBuffer) {
  const auto suppressed_count = CountSuppressedTags(tags, numTags);
  if (suppressed_count == 0u) {
    return Real_slSetTagForFrame(frame, viewport, tags, numTags, cmdBuffer);
  }

  LogSuppressedUITag(suppressed_count);
  auto filtered_tags = BuildFilteredTags(tags, numTags, suppressed_count);
  if (filtered_tags.empty()) return sl::Result::eOk;

  return Real_slSetTagForFrame(frame, viewport, filtered_tags.data(), static_cast<uint32_t>(filtered_tags.size()), cmdBuffer);
}

inline const std::vector<renodx::utils::vtable::HookItem> kStreamlineDLSSGOptionsHooks = {
    {"slSetTag",
     reinterpret_cast<void**>(&Real_slSetTag),
     reinterpret_cast<void*>(&HookedSlSetTag)},
    {"slSetTagForFrame",
     reinterpret_cast<void**>(&Real_slSetTagForFrame),
     reinterpret_cast<void*>(&HookedSlSetTagForFrame)},
};

inline void TryInstallStreamlineHook() {
  if (hook_installed) return;

  auto* sl_interposer = GetModuleHandleA("sl.interposer.dll");
  if (sl_interposer == nullptr) {
    if (!logged_waiting_for_streamline) {
      logged_waiting_for_streamline = true;
      renodx::utils::log::w("007 DLSSG: sl.interposer.dll is not loaded yet; UI alpha fix hook will retry later.");
    }
    return;
  }

  if (renodx::utils::vtable::Hook(sl_interposer, kStreamlineDLSSGOptionsHooks)) {
    hook_installed = true;
    renodx::utils::log::i("007 DLSSG: Streamline UI/HUD tag suppression hook installed.");
  } else {
    renodx::utils::log::w("007 DLSSG: Streamline hook was not installed.");
  }
}

inline void OnInitDevice(reshade::api::device* device) {
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d12) return;
  TryInstallStreamlineHook();
}

inline void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (attached) return;
      attached = true;
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      break;
    case DLL_PROCESS_DETACH:
      if (!attached) return;
      attached = false;
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      hook_installed = false;
      logged_waiting_for_streamline = false;
      logged_ui_tag_suppression = false;
      break;
    default:
      break;
  }
}

}  // namespace firstlight::dlss
