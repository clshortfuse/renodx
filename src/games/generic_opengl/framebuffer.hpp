#pragma once

// Optional single-window default-framebuffer adapter, derived from Doom 3.
// Preserve matching depth/stencil when replacing the WGL color target.
#include "gl_api.hpp"
#include <Windows.h>
#include <include/reshade.hpp>
#include <unordered_map>
#include <vector>
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/device_proxy.hpp"
#include "../../utils/swapchain.hpp"

namespace generic_opengl::framebuffer {
using namespace reshade::api;
constexpr uint64_t DEFAULT_FRAMEBUFFER = uint64_t{0x8218} << 40;
constexpr resource_view DEFAULT_DEPTH = {DEFAULT_FRAMEBUFFER | 0x821A};

struct Framebuffer {
  swapchain* owner = nullptr;
  resource back_buffer = {};
  resource depth = {};
  resource_view depth_view = {};
  bool failed = false;
  bool logged_color = false;
  bool logged_copy = false;
  uint64_t validated_rtv = 0;
};
inline std::unordered_map<device*, Framebuffer> framebuffers;
inline renodx::utils::resource::ResourceUpgradeInfo color_target = {
    .new_format = format::r16g16b16a16_float,
    .use_resource_view_hot_swap = true,
    .usage_set = static_cast<uint32_t>(resource_usage::render_target | resource_usage::shader_resource | resource_usage::copy_source | resource_usage::copy_dest),
    .view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F,
    .use_resource_view_cloning_and_upgrade = true,
};

inline resource_view PrepareColor(const resource back_buffer) {
  const auto existing = renodx::utils::resource::upgrade::GetResourceViewClone({back_buffer.handle});
  if (existing.handle != 0) return existing;
  std::vector<uint64_t> views;
  if (!renodx::utils::resource::UpdateResourceInfo(back_buffer, [&](auto* info) {
        if (info->destroyed) return;
        // Retain a target installed by the shared display proxy. It owns the
        // interop texture; we only supply the initial default-FBO clone.
        if (info->clone_target == nullptr) info->clone_target = &color_target;
        info->clone_enabled = true;
        views.assign(info->resource_view_handles.begin(), info->resource_view_handles.end());
      })) return {};
  renodx::utils::resource::upgrade::UpdateResourceViewsCloneState(views, true, true);
  return renodx::utils::resource::upgrade::GetResourceViewClone({back_buffer.handle});
}

inline void OnInitSwapchain(swapchain* swapchain, bool) {
  auto* device = swapchain->get_device();
  if (!profile.default_framebuffer || device->get_api() != device_api::opengl || !renodx::utils::device_proxy::UseProxyRequested()) return;
  if (framebuffers.contains(device)) {
    Log("Default-framebuffer adapter supports one swapchain per device; additional initialization skipped", true);
    return;
  }
  auto& state = framebuffers[device];
  state.owner = swapchain;
  state.back_buffer = swapchain->get_current_back_buffer();
  auto desc = device->get_resource_desc({DEFAULT_DEPTH.handle});
  // Do not guess stencil precision or sample count. The FBO must match WGL.
  if (desc.texture.format == format::unknown || desc.texture.width == 0 || desc.texture.height == 0) {
    state.failed = true;
    reshade::log::message(reshade::log::level::error, "[Generic OpenGL] Cannot describe default depth/stencil; The game framebuffer fix is inactive.");
    return;
  }
  desc.type = resource_type::texture_2d;
  desc.heap = memory_heap::gpu_only;
  desc.flags = resource_flags::none;
  desc.texture.levels = 1;
  desc.usage = resource_usage::depth_stencil | resource_usage::copy_source | resource_usage::copy_dest;
  if (!device->create_resource(desc, nullptr, resource_usage::depth_stencil, &state.depth)
      || !device->create_resource_view(state.depth, resource_usage::depth_stencil,
          resource_view_desc(desc.texture.samples > 1 ? resource_view_type::texture_2d_multisample : resource_view_type::texture_2d, desc.texture.format, 0, 1, 0, 1), &state.depth_view)) {
    if (state.depth.handle != 0) device->destroy_resource(state.depth);
    state.depth = {};
    state.failed = true;
    reshade::log::message(reshade::log::level::error, "[Generic OpenGL] Depth/stencil creation failed; The game framebuffer fix is inactive.");
    return;
  }
  // ReShade publishes the default RTV after init_swapchain. Prepare its clone at the first draw.
  reshade::log::message(reshade::log::level::info, "[Generic OpenGL] Matching depth/stencil initialized; FP16 clone will be prepared on first draw.");
}

inline void BindScene(command_list* cmd) {
  const auto found = framebuffers.find(cmd->get_device());
  if (found == framebuffers.end() || found->second.failed) return;
  const auto& rtvs = renodx::utils::swapchain::GetRenderTargets(cmd);
  if (rtvs.size() != 1) return;
  bool scene_target = rtvs[0].handle == found->second.back_buffer.handle;
  if (!scene_target) {
    renodx::utils::resource::GetResourceViewInfo(rtvs[0], [&](const auto& info) {
      scene_target = info.is_clone && info.original_resource.handle == found->second.back_buffer.handle;
    });
  }
  if (!scene_target) return;
  const auto rtv = PrepareColor(found->second.back_buffer);
  if (rtv.handle == 0) return;
  // This callback runs after the shared clone rewrite, which binds no DSV
  // for OpenGL. Restore the game-local DSV before the actual game draw.
  cmd->bind_render_targets_and_depth_stencil(1, &rtv, found->second.depth_view);
  if (found->second.validated_rtv != rtv.handle) {
    const auto check = reinterpret_cast<unsigned(APIENTRY*)(unsigned)>(GLProc("glCheckFramebufferStatus"));
    if (check == nullptr || check(0x8D40) != 0x8CD5) {
      found->second.failed = true;
      reshade::log::message(reshade::log::level::error, "[Generic OpenGL] Scene FBO is incomplete; stop the test and disable the display proxy.");
      const resource_view original = {found->second.back_buffer.handle};
      cmd->bind_render_targets_and_depth_stencil(1, &original, DEFAULT_DEPTH);
      return;
    }
    found->second.validated_rtv = rtv.handle;
  }
  if (!found->second.logged_color) {
    found->second.logged_color = true;
    reshade::log::message(reshade::log::level::info, "[Generic OpenGL] Scene draws redirected to FP16 with depth/stencil.");
  }
}
inline bool OnDraw(command_list* cmd, uint32_t, uint32_t, uint32_t, uint32_t) {
  BindScene(cmd);
  return false;
}
inline bool OnDrawIndexed(command_list* cmd, uint32_t, uint32_t, uint32_t, int32_t, uint32_t) {
  BindScene(cmd);
  return false;
}
inline bool OnClearColor(command_list* cmd, resource_view rtv, const float* color, uint32_t count, const rect* rects) {
  const auto found = framebuffers.find(cmd->get_device());
  if (found == framebuffers.end() || found->second.failed || rtv.handle != found->second.back_buffer.handle) return false;
  const auto clone = PrepareColor(found->second.back_buffer);
  if (clone.handle == 0) return false;
  cmd->clear_render_target_view(clone, color, count, rects);
  return true;
}
inline bool OnClearDepth(command_list* cmd, resource_view dsv, const float* depth,
                         const uint8_t* stencil, uint32_t count, const rect* rects) {
  const auto found = framebuffers.find(cmd->get_device());
  if (found == framebuffers.end() || found->second.failed || dsv.handle != DEFAULT_DEPTH.handle) return false;
  cmd->clear_depth_stencil_view(found->second.depth_view, depth, stencil, count, rects);
  return true;
}

// Framebuffer copies may change format (FP16 scene -> legacy RGB screen
// texture). CopyImageSubData cannot do that conversion. Use an explicit GPU
// framebuffer blit, without CPU readback or a final-frame inverse tone map.
inline thread_local bool copying = false;
inline bool OnCopy(command_list* cmd, resource source, uint32_t source_subresource,
                   const subresource_box* source_box, resource dest, uint32_t dest_subresource,
                   const subresource_box* dest_box, filter_mode) {
  const auto found = framebuffers.find(cmd->get_device());
  if (found == framebuffers.end() || found->second.failed || source_subresource != 0 || dest_subresource != 0) return false;
  if (copying) return false;
  const bool depth = source.handle == DEFAULT_DEPTH.handle || source.handle == found->second.depth.handle;
  const auto color_clone = renodx::utils::resource::upgrade::GetResourceClone(found->second.back_buffer);
  if (!depth && source.handle != found->second.back_buffer.handle && source.handle != color_clone.handle) return false;
  resource actual_source = found->second.depth;
  if (!depth) {
    if (PrepareColor(found->second.back_buffer).handle == 0) return false;
    actual_source = renodx::utils::resource::upgrade::GetResourceClone(found->second.back_buffer);
  }
  // Only handle 2D screen-copy textures, never array/volume/cubemap copies.
  if ((actual_source.handle >> 40) != 0x0DE1 || (dest.handle >> 40) != 0x0DE1) return false;
  const auto src_desc = cmd->get_device()->get_resource_desc(actual_source);
  const auto dst_desc = cmd->get_device()->get_resource_desc(dest);
  if (src_desc.texture.samples != dst_desc.texture.samples) return false;
  if (depth && src_desc.texture.format != dst_desc.texture.format) return false;
  const auto bind = reinterpret_cast<void(APIENTRY*)(unsigned, unsigned)>(GLProc("glBindFramebuffer"));
  const auto gen = reinterpret_cast<void(APIENTRY*)(int, unsigned*)>(GLProc("glGenFramebuffers"));
  const auto del = reinterpret_cast<void(APIENTRY*)(int, const unsigned*)>(GLProc("glDeleteFramebuffers"));
  const auto attach = reinterpret_cast<void(APIENTRY*)(unsigned, unsigned, unsigned, unsigned, int)>(GLProc("glFramebufferTexture2D"));
  const auto check = reinterpret_cast<unsigned(APIENTRY*)(unsigned)>(GLProc("glCheckFramebufferStatus"));
  const auto blit = reinterpret_cast<void(APIENTRY*)(int,int,int,int,int,int,int,int,unsigned,unsigned)>(GLProc("glBlitFramebuffer"));
  const auto get = reinterpret_cast<void(APIENTRY*)(unsigned,int*)>(GLProc("glGetIntegerv"));
  const auto is_enabled = reinterpret_cast<unsigned char(APIENTRY*)(unsigned)>(GLProc("glIsEnabled"));
  const auto enable = reinterpret_cast<void(APIENTRY*)(unsigned)>(GLProc("glEnable"));
  const auto disable = reinterpret_cast<void(APIENTRY*)(unsigned)>(GLProc("glDisable"));
  const auto read_buffer = reinterpret_cast<void(APIENTRY*)(unsigned)>(GLProc("glReadBuffer"));
  const auto draw_buffer = reinterpret_cast<void(APIENTRY*)(unsigned)>(GLProc("glDrawBuffer"));
  if (!bind || !gen || !del || !attach || !check || !blit || !get || !is_enabled || !enable || !disable || !read_buffer || !draw_buffer) return false;
  int read_fbo = 0, draw_fbo = 0;
  get(0x8CAA, &read_fbo);
  get(0x8CA6, &draw_fbo);
  const bool scissor = is_enabled(0x0C11) != 0;
  const bool srgb = is_enabled(0x8DB9) != 0;
  // WGL entry points pass through ReShade. Recursive copy events must fall
  // through to its native blit rather than enter this handler again.
  copying = true;
  unsigned fbos[2] = {};
  gen(2, fbos);
  bind(0x8CA8, fbos[0]);
  attach(0x8CA8, depth ? 0x8D00 : 0x8CE0, 0x0DE1, static_cast<unsigned>(actual_source.handle), 0);
  read_buffer(depth ? 0 : 0x8CE0);
  bind(0x8CA9, fbos[1]);
  attach(0x8CA9, depth ? 0x8D00 : 0x8CE0, 0x0DE1, static_cast<unsigned>(dest.handle), 0);
  draw_buffer(depth ? 0 : 0x8CE0);
  const bool complete = check(0x8CA8) == 0x8CD5 && check(0x8CA9) == 0x8CD5;
  if (complete) {
    disable(0x0C11);
    disable(0x8DB9);
    blit(source_box ? source_box->left : 0, source_box ? source_box->top : 0,
         source_box ? source_box->right : src_desc.texture.width, source_box ? source_box->bottom : src_desc.texture.height,
         dest_box ? dest_box->left : 0, dest_box ? dest_box->top : 0,
         dest_box ? dest_box->right : dst_desc.texture.width, dest_box ? dest_box->bottom : dst_desc.texture.height,
         depth ? 0x0100 : 0x4000, 0x2600);
  }
  if (scissor) enable(0x0C11);
  if (srgb) enable(0x8DB9);
  bind(0x8CA8, read_fbo);
  bind(0x8CA9, draw_fbo);
  del(2, fbos);
  copying = false;
  if (complete && !found->second.logged_copy) {
    found->second.logged_copy = true;
    reshade::log::message(reshade::log::level::info, "[Generic OpenGL] Screen copy routed through GPU framebuffer blit.");
  }
  return complete;
}

inline void OnDestroySwapchain(swapchain* swapchain, bool) {
  auto* device = swapchain->get_device();
  const auto found = framebuffers.find(device);
  if (found == framebuffers.end() || found->second.owner != swapchain) return;
  // WGL context destruction can precede ReShade teardown. Never call GL in
  // that case; context destruction releases the resources itself.
  using CurrentContext = HGLRC(WINAPI*)();
  const auto current = reinterpret_cast<CurrentContext>(GetProcAddress(GetModuleHandleW(L"opengl32.dll"), "wglGetCurrentContext"));
  if (current && reinterpret_cast<uintptr_t>(current()) == device->get_native()) {
    if (found->second.depth_view.handle) device->destroy_resource_view(found->second.depth_view);
    if (found->second.depth.handle) device->destroy_resource(found->second.depth);
  }
  framebuffers.erase(found);
}

inline void Use(DWORD reason) {
  if (reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
    reshade::register_event<reshade::addon_event::draw>(OnDraw);
    reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
    reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearColor);
    reshade::register_event<reshade::addon_event::clear_depth_stencil_view>(OnClearDepth);
    reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopy);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
    reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
    reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
    reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearColor);
    reshade::unregister_event<reshade::addon_event::clear_depth_stencil_view>(OnClearDepth);
    reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopy);
  }
}
}  // namespace generic_opengl::framebuffer
