#pragma once

// Doom 3 renders into the WGL default framebuffer. A color-only replacement
// loses the depth/stencil buffer required by its stencil shadow renderer.
#include <Windows.h>
#include <include/reshade.hpp>
#include <array>
#include <cmath>
#include <string>
#include <unordered_map>
#include <vector>
#include "../../utils/resource_upgrade.hpp"
#include "../../utils/device_proxy.hpp"
#include "../../utils/swapchain.hpp"
#include "./pre_ui_tonemap_shaders.hpp"
#include "./shared.h"

namespace doom3::opengl {
using namespace reshade::api;
constexpr uint64_t DEFAULT_FRAMEBUFFER = uint64_t{0x8218} << 40;
constexpr resource_view DEFAULT_DEPTH = {DEFAULT_FRAMEBUFFER | 0x821A};

// Where the current frame is relative to dhewm3's views. RB_BeginDrawingView
// enables GL_DEPTH_TEST for every 3D view and disables it for the 2D GUI view
// (HUD, menus, console), so depth state alone separates scene from UI draws.
enum class FrameStage : uint8_t { START, SCENE, DONE };

// ShaderInjectData::tone_map_type values the pre-UI pass implements.
inline constexpr float TONE_MAP_TYPE_RENODRT = 3.f;
inline constexpr float TONE_MAP_TYPE_PSYCHOV30 = 30.f;

struct Framebuffer {
  resource back_buffer = {};
  resource depth = {};
  resource_view depth_view = {};
  bool failed = false;
  bool logged_color = false;
  bool logged_copy = false;
  bool logged_copy_upgrade = false;
  uint64_t validated_rtv = 0;
  // Pre-UI tone map.
  FrameStage stage = FrameStage::START;
  bool depth_test = false;
  bool tone_map_failed = false;
  bool logged_tone_map = false;
  uint32_t frame_draws = 0;
  unsigned program = 0;
  std::array<int, 5> uniforms = {-1, -1, -1, -1, -1};  // TONE_MAP_UNIFORMS
  resource scratch = {};
  resource_desc scratch_desc = {};
};
inline std::unordered_map<device*, Framebuffer> framebuffers;
inline ShaderInjectData* injection = nullptr;
inline renodx::utils::resource::ResourceUpgradeInfo color_target = {
    .new_format = format::r16g16b16a16_float,
    .use_resource_view_hot_swap = true,
    .usage_set = static_cast<uint32_t>(resource_usage::render_target | resource_usage::shader_resource | resource_usage::copy_source | resource_usage::copy_dest),
    .view_upgrades = renodx::utils::resource::VIEW_UPGRADES_RGBA16F,
    .use_resource_view_cloning_and_upgrade = true,
};

inline PROC GetGLProc(const char* name) {
  const auto module = GetModuleHandleW(L"opengl32.dll");
  if (module == nullptr) return nullptr;
  if (const auto proc = GetProcAddress(module, name)) return proc;
  using GetProc = PROC(WINAPI*)(LPCSTR);
  const auto get_proc = reinterpret_cast<GetProc>(GetProcAddress(module, "wglGetProcAddress"));
  if (get_proc == nullptr) return nullptr;
  const auto proc = get_proc(name);
  const auto value = reinterpret_cast<intptr_t>(proc);
  return value == -1 || (value >= 0 && value <= 3) ? nullptr : proc;
}

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
  if (device->get_api() != device_api::opengl || !renodx::utils::device_proxy::UseProxyRequested()) return;
  // ReShade imports the D3D11 HDR texture through a temporary Vulkan device.
  // Steam's Vulkan overlay intercepts that non-presenting device and can crash
  // in nvoglv32 during vkCreateDevice, even with Steam's overlay UI disabled.
  // Apply the layer's manifest opt-out before the first proxy resource import.
  // This changes only this process; OpenGL/D3D11 overlay hooks are unaffected.
  if (SetEnvironmentVariableW(L"DISABLE_VK_LAYER_VALVE_steam_overlay_1", L"1")) {
    reshade::log::message(reshade::log::level::info,
        "[Doom3 GL] Disabled Steam Vulkan overlay for HDR texture interop in this process.");
  } else {
    reshade::log::message(reshade::log::level::warning,
        "[Doom3 GL] Could not disable Steam Vulkan overlay for HDR texture interop.");
  }
  auto& state = framebuffers[device];
  state.back_buffer = swapchain->get_current_back_buffer();
  auto desc = device->get_resource_desc({DEFAULT_DEPTH.handle});
  // Do not guess stencil precision or sample count. The FBO must match WGL.
  if (desc.texture.format == format::unknown || desc.texture.width == 0 || desc.texture.height == 0) {
    state.failed = true;
    reshade::log::message(reshade::log::level::error, "[Doom3 GL] Cannot describe default depth/stencil; Doom 3 framebuffer fix is inactive.");
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
    reshade::log::message(reshade::log::level::error, "[Doom3 GL] Depth/stencil creation failed; Doom 3 framebuffer fix is inactive.");
    return;
  }
  // ReShade publishes the default RTV after init_swapchain. Prepare its clone at the first draw.
  reshade::log::message(reshade::log::level::info, "[Doom3 GL] Matching depth/stencil initialized; FP16 clone will be prepared on first draw.");
}

// Pre-UI tone map. The finished 3D scene is tone mapped in place right before
// the first 2D GUI draw, so Doom 3 composites its HUD and menus over an already
// mapped scene. The UI then keeps UI Brightness and is never compressed by the
// scene curve. The shaders live in pre_ui_tonemap_shaders.hpp.
inline constexpr std::array<const char*, 5> TONE_MAP_UNIFORMS = {"tone", "grade", "extra", "psycho", "modes"};

// GL entry points for the pass. They go through ReShade's hooks like the game's
// calls, but none of them raises a draw event, so the pass never re-enters BindScene.
struct ToneMapGL {
  void(APIENTRY* get_integerv)(unsigned, int*) = nullptr;
  void(APIENTRY* get_booleanv)(unsigned, unsigned char*) = nullptr;
  unsigned char(APIENTRY* is_enabled)(unsigned) = nullptr;
  void(APIENTRY* enable)(unsigned) = nullptr;
  void(APIENTRY* disable)(unsigned) = nullptr;
  void(APIENTRY* viewport)(int, int, int, int) = nullptr;
  void(APIENTRY* color_mask)(unsigned char, unsigned char, unsigned char, unsigned char) = nullptr;
  void(APIENTRY* polygon_mode)(unsigned, unsigned) = nullptr;
  void(APIENTRY* bind_texture)(unsigned, unsigned) = nullptr;
  void(APIENTRY* rectf)(float, float, float, float) = nullptr;
  void(APIENTRY* active_texture)(unsigned) = nullptr;
  unsigned(APIENTRY* create_shader)(unsigned) = nullptr;
  void(APIENTRY* shader_source)(unsigned, int, const char* const*, const int*) = nullptr;
  void(APIENTRY* compile_shader)(unsigned) = nullptr;
  void(APIENTRY* get_shaderiv)(unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* get_shader_info_log)(unsigned, int, int*, char*) = nullptr;
  void(APIENTRY* attach_shader)(unsigned, unsigned) = nullptr;
  void(APIENTRY* delete_shader)(unsigned) = nullptr;
  unsigned(APIENTRY* create_program)() = nullptr;
  void(APIENTRY* link_program)(unsigned) = nullptr;
  void(APIENTRY* get_programiv)(unsigned, unsigned, int*) = nullptr;
  void(APIENTRY* get_program_info_log)(unsigned, int, int*, char*) = nullptr;
  void(APIENTRY* delete_program)(unsigned) = nullptr;
  void(APIENTRY* use_program)(unsigned) = nullptr;
  int(APIENTRY* get_uniform_location)(unsigned, const char*) = nullptr;
  void(APIENTRY* uniform4f)(int, float, float, float, float) = nullptr;
};

template <typename T>
inline bool LoadGLProc(T& proc, const char* name) {
  proc = reinterpret_cast<T>(GetGLProc(name));
  return proc != nullptr;
}

// Requires a current context; the first call happens inside a game draw.
inline const ToneMapGL* GetToneMapGL() {
  static ToneMapGL gl;
  static const bool loaded =
      LoadGLProc(gl.get_integerv, "glGetIntegerv") && LoadGLProc(gl.get_booleanv, "glGetBooleanv")
      && LoadGLProc(gl.is_enabled, "glIsEnabled") && LoadGLProc(gl.enable, "glEnable")
      && LoadGLProc(gl.disable, "glDisable") && LoadGLProc(gl.viewport, "glViewport")
      && LoadGLProc(gl.color_mask, "glColorMask") && LoadGLProc(gl.polygon_mode, "glPolygonMode")
      && LoadGLProc(gl.bind_texture, "glBindTexture") && LoadGLProc(gl.rectf, "glRectf")
      && LoadGLProc(gl.active_texture, "glActiveTexture") && LoadGLProc(gl.create_shader, "glCreateShader")
      && LoadGLProc(gl.shader_source, "glShaderSource") && LoadGLProc(gl.compile_shader, "glCompileShader")
      && LoadGLProc(gl.get_shaderiv, "glGetShaderiv") && LoadGLProc(gl.get_shader_info_log, "glGetShaderInfoLog")
      && LoadGLProc(gl.attach_shader, "glAttachShader") && LoadGLProc(gl.delete_shader, "glDeleteShader")
      && LoadGLProc(gl.create_program, "glCreateProgram") && LoadGLProc(gl.link_program, "glLinkProgram")
      && LoadGLProc(gl.get_programiv, "glGetProgramiv") && LoadGLProc(gl.get_program_info_log, "glGetProgramInfoLog")
      && LoadGLProc(gl.delete_program, "glDeleteProgram") && LoadGLProc(gl.use_program, "glUseProgram")
      && LoadGLProc(gl.get_uniform_location, "glGetUniformLocation") && LoadGLProc(gl.uniform4f, "glUniform4f");
  return loaded ? &gl : nullptr;
}

template <size_t N>
inline unsigned CompileToneMapShader(const ToneMapGL& gl, unsigned type, const char* const (&sources)[N]) {
  const unsigned shader = gl.create_shader(type);
  gl.shader_source(shader, static_cast<int>(N), sources, nullptr);
  gl.compile_shader(shader);
  int compiled = 0;
  gl.get_shaderiv(shader, 0x8B81 /* GL_COMPILE_STATUS */, &compiled);
  if (compiled != 0) return shader;
  char info[1024] = {};
  gl.get_shader_info_log(shader, sizeof(info), nullptr, info);
  reshade::log::message(reshade::log::level::error,
      (std::string("[Doom3 GL] Pre-UI tone map shader failed to compile: ") + info).c_str());
  gl.delete_shader(shader);
  return 0;
}

// Returns false when the pass did not run; permanent problems also set
// tone_map_failed so later frames fall back to the full-frame display tone map.
inline bool ToneMapScene(command_list* cmd, Framebuffer& state) {
  const auto* gl = GetToneMapGL();
  if (gl == nullptr) {
    state.tone_map_failed = true;
    reshade::log::message(reshade::log::level::error, "[Doom3 GL] Pre-UI tone map needs OpenGL 2.0 entry points; using the display tone map instead.");
    return false;
  }
  auto* device = cmd->get_device();
  const auto clone = renodx::utils::resource::upgrade::GetResourceClone(state.back_buffer);
  if ((clone.handle >> 40) != 0x0DE1) return false;  // GL_TEXTURE_2D
  const auto desc = device->get_resource_desc(clone);
  if (desc.texture.samples > 1) {
    state.tone_map_failed = true;
    reshade::log::message(reshade::log::level::warning, "[Doom3 GL] Pre-UI tone map does not support multisampled framebuffers; using the display tone map instead.");
    return false;
  }

  if (state.program == 0) {
    const unsigned vertex = CompileToneMapShader(*gl, 0x8B31 /* GL_VERTEX_SHADER */, {TONE_MAP_VERTEX_SHADER});
    const unsigned fragment = CompileToneMapShader(*gl, 0x8B30 /* GL_FRAGMENT_SHADER */, TONE_MAP_FRAGMENT_SHADER);
    if (vertex != 0 && fragment != 0) {
      const unsigned program = gl->create_program();
      gl->attach_shader(program, vertex);
      gl->attach_shader(program, fragment);
      gl->link_program(program);
      int linked = 0;
      gl->get_programiv(program, 0x8B82 /* GL_LINK_STATUS */, &linked);
      if (linked != 0) {
        state.program = program;
      } else {
        char info[1024] = {};
        gl->get_program_info_log(program, sizeof(info), nullptr, info);
        reshade::log::message(reshade::log::level::error,
            (std::string("[Doom3 GL] Pre-UI tone map program failed to link: ") + info).c_str());
        gl->delete_program(program);
      }
    }
    if (vertex != 0) gl->delete_shader(vertex);
    if (fragment != 0) gl->delete_shader(fragment);
    if (state.program == 0) {
      state.tone_map_failed = true;
      return false;
    }
    for (size_t i = 0; i < TONE_MAP_UNIFORMS.size(); ++i) {
      state.uniforms[i] = gl->get_uniform_location(state.program, TONE_MAP_UNIFORMS[i]);
    }
  }

  // The scene cannot be sampled while it is the render target, so read a copy.
  if (state.scratch.handle == 0 || state.scratch_desc.texture.width != desc.texture.width
      || state.scratch_desc.texture.height != desc.texture.height
      || state.scratch_desc.texture.format != desc.texture.format) {
    if (state.scratch.handle != 0) device->destroy_resource(state.scratch);
    state.scratch = {};
    state.scratch_desc = resource_desc(desc.texture.width, desc.texture.height, 1, 1, desc.texture.format, 1,
                                       memory_heap::gpu_only, resource_usage::shader_resource | resource_usage::copy_dest);
    if (!device->create_resource(state.scratch_desc, nullptr, resource_usage::copy_dest, &state.scratch)) {
      state.scratch = {};
      state.tone_map_failed = true;
      reshade::log::message(reshade::log::level::error, "[Doom3 GL] Pre-UI tone map copy texture creation failed; using the display tone map instead.");
      return false;
    }
  }
  // API calls raise no addon events, so OnCopy is not involved.
  cmd->copy_texture_region(clone, 0, nullptr, state.scratch, 0, nullptr);

  // Save and neutralize everything the fullscreen rectangle would be affected
  // by. Depth test is already off at the 2D boundary; the bound scene FBO is
  // the target and is left untouched.
  int program = 0;
  int active_texture = 0;
  int texture = 0;
  int viewport[4] = {};
  int polygon_mode[2] = {};
  unsigned char color_mask[4] = {};
  gl->get_integerv(0x8B8D /* GL_CURRENT_PROGRAM */, &program);
  gl->get_integerv(0x84E0 /* GL_ACTIVE_TEXTURE */, &active_texture);
  gl->active_texture(0x84C0 /* GL_TEXTURE0 */);
  gl->get_integerv(0x8069 /* GL_TEXTURE_BINDING_2D */, &texture);
  gl->get_integerv(0x0BA2 /* GL_VIEWPORT */, viewport);
  gl->get_integerv(0x0B40 /* GL_POLYGON_MODE */, polygon_mode);
  gl->get_booleanv(0x0C23 /* GL_COLOR_WRITEMASK */, color_mask);
  constexpr std::array<unsigned, 7> CAPS = {
      0x0BE2 /* GL_BLEND */, 0x0BC0 /* GL_ALPHA_TEST */, 0x0C11 /* GL_SCISSOR_TEST */,
      0x0B90 /* GL_STENCIL_TEST */, 0x0B44 /* GL_CULL_FACE */, 0x0BF2 /* GL_COLOR_LOGIC_OP */,
      0x809E /* GL_SAMPLE_ALPHA_TO_COVERAGE */};
  std::array<bool, CAPS.size()> caps_enabled = {};
  for (size_t i = 0; i < CAPS.size(); ++i) {
    caps_enabled[i] = gl->is_enabled(CAPS[i]) != 0;
    if (caps_enabled[i]) gl->disable(CAPS[i]);
  }
  const bool filled = polygon_mode[0] == 0x1B02 /* GL_FILL */ && polygon_mode[1] == 0x1B02;
  if (!filled) gl->polygon_mode(0x0408 /* GL_FRONT_AND_BACK */, 0x1B02);
  gl->color_mask(1, 1, 1, 1);
  gl->viewport(0, 0, static_cast<int>(desc.texture.width), static_cast<int>(desc.texture.height));
  gl->bind_texture(0x0DE1 /* GL_TEXTURE_2D */, static_cast<unsigned>(state.scratch.handle));

  const auto& data = *injection;
  // Same order as TONE_MAP_UNIFORMS. Flare and highlight blowout use the
  // renodx::draw::ToneMapPass slider mapping.
  const std::array<std::array<float, 4>, TONE_MAP_UNIFORMS.size()> values = {{
      {data.peak_white_nits / data.diffuse_white_nits, data.tone_map_exposure, data.tone_map_highlights, data.tone_map_shadows},
      {data.tone_map_contrast, 0.10f * std::pow(data.tone_map_flare, 10.f), data.tone_map_saturation, 1.f - data.tone_map_highlight_saturation},
      {data.tone_map_blowout, data.tone_map_per_channel, data.diffuse_white_nits / data.graphics_white_nits, 0.f},
      {data.psychov30_compression, data.psychov30_gamut_compression, data.psychov30_cone_response, data.psychov30_purity_scale},
      {data.tone_map_type == TONE_MAP_TYPE_PSYCHOV30 ? 1.f : 0.f, data.psychov30_gamut_mode, data.psychov30_source_boundary, 0.f},
  }};
  gl->use_program(state.program);
  for (size_t i = 0; i < values.size(); ++i) {
    gl->uniform4f(state.uniforms[i], values[i][0], values[i][1], values[i][2], values[i][3]);
  }
  gl->rectf(-1.f, -1.f, 1.f, 1.f);

  gl->use_program(static_cast<unsigned>(program));
  gl->bind_texture(0x0DE1, static_cast<unsigned>(texture));
  gl->active_texture(static_cast<unsigned>(active_texture));
  gl->viewport(viewport[0], viewport[1], viewport[2], viewport[3]);
  gl->color_mask(color_mask[0], color_mask[1], color_mask[2], color_mask[3]);
  if (!filled) {
    gl->polygon_mode(0x0404 /* GL_FRONT */, static_cast<unsigned>(polygon_mode[0]));
    gl->polygon_mode(0x0405 /* GL_BACK */, static_cast<unsigned>(polygon_mode[1]));
  }
  for (size_t i = 0; i < CAPS.size(); ++i) {
    if (caps_enabled[i]) gl->enable(CAPS[i]);
  }

  if (!state.logged_tone_map) {
    state.logged_tone_map = true;
    reshade::log::message(reshade::log::level::info,
        ("[Doom3 GL] Scene tone mapped before UI at scene draw " + std::to_string(state.frame_draws) + " of the frame.").c_str());
  }
  return true;
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
    const auto check = reinterpret_cast<unsigned(APIENTRY*)(unsigned)>(GetGLProc("glCheckFramebufferStatus"));
    if (check == nullptr || check(0x8D40) != 0x8CD5) {
      found->second.failed = true;
      reshade::log::message(reshade::log::level::error, "[Doom3 GL] Scene FBO is incomplete; stop the test and disable the display proxy.");
      const resource_view original = {found->second.back_buffer.handle};
      cmd->bind_render_targets_and_depth_stencil(1, &original, DEFAULT_DEPTH);
      return;
    }
    found->second.validated_rtv = rtv.handle;
  }
  if (!found->second.logged_color) {
    found->second.logged_color = true;
    reshade::log::message(reshade::log::level::info, "[Doom3 GL] Scene draws redirected to FP16 with depth/stencil.");
  }

  auto& state = found->second;
  ++state.frame_draws;
  if (state.stage == FrameStage::DONE) return;
  if (state.stage == FrameStage::START) {
    const bool enabled = injection != nullptr && !state.tone_map_failed && injection->custom_tone_map_before_ui != 0.f
                         && (injection->tone_map_type == TONE_MAP_TYPE_RENODRT
                             || injection->tone_map_type == TONE_MAP_TYPE_PSYCHOV30);
    if (enabled && state.depth_test) {
      state.stage = FrameStage::SCENE;
      injection->custom_scene_tone_mapped = 0.f;
    } else {
      // Disabled, or a 2D draw came first (menus, loading screens): the whole
      // frame is UI. Likewise, 3D views drawn after the GUI has started (the
      // PDA player model) are treated as UI.
      state.stage = FrameStage::DONE;
      if (injection != nullptr) injection->custom_scene_tone_mapped = enabled ? 1.f : 0.f;
    }
    return;
  }
  if (state.depth_test) return;
  // First 2D GUI draw after the 3D views. Without a GUI draw the frame keeps
  // the flag at 0 and the display shader tone maps the whole frame as before.
  state.stage = FrameStage::DONE;
  injection->custom_scene_tone_mapped = ToneMapScene(cmd, state) ? 1.f : 0.f;
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
// Diagnostic trace for the screen-copy path. Capped so it cannot flood ReShade.log.
inline int copy_trace_count = 0;
inline void TraceCopy(const char* what, resource source, resource dest, bool depth) {
  if (copy_trace_count >= 40) return;
  ++copy_trace_count;
  const std::string message = std::string("[Doom3 GL] copy trace: ") + what +
      " source=" + std::to_string(source.handle) +
      " dest=" + std::to_string(dest.handle) +
      " depth=" + (depth ? "1" : "0");
  reshade::log::message(reshade::log::level::info, message.c_str());
}

inline bool OnCopy(command_list* cmd, resource source, uint32_t source_subresource,
                   const subresource_box* source_box, resource dest, uint32_t dest_subresource,
                   const subresource_box* dest_box, filter_mode) {
  TraceCopy("enter", source, dest, false);
  const auto found = framebuffers.find(cmd->get_device());
  if (found == framebuffers.end() || found->second.failed || source_subresource != 0 || dest_subresource != 0) {
    TraceCopy("rejected: no state, failed, or subresource", source, dest, false);
    return false;
  }
  if (copying) return false;
  const bool depth = source.handle == DEFAULT_DEPTH.handle || source.handle == found->second.depth.handle;
  const auto color_clone = renodx::utils::resource::upgrade::GetResourceClone(found->second.back_buffer);
  if (!depth && source.handle != found->second.back_buffer.handle && source.handle != color_clone.handle) {
    TraceCopy("rejected: source is not the default color target", source, dest, false);
    return false;
  }
  resource actual_source = found->second.depth;
  if (!depth) {
    if (PrepareColor(found->second.back_buffer).handle == 0) return false;
    actual_source = renodx::utils::resource::upgrade::GetResourceClone(found->second.back_buffer);
  }
  // Only handle 2D screen-copy textures, never array/volume/cubemap copies.
  if ((actual_source.handle >> 40) != 0x0DE1 || (dest.handle >> 40) != 0x0DE1) return false;
  const auto src_desc = cmd->get_device()->get_resource_desc(actual_source);
  auto dst_desc = cmd->get_device()->get_resource_desc(dest);
  if (src_desc.texture.samples != dst_desc.texture.samples) return false;
  if (depth && src_desc.texture.format != dst_desc.texture.format) return false;
  const auto bind = reinterpret_cast<void(APIENTRY*)(unsigned, unsigned)>(GetGLProc("glBindFramebuffer"));
  const auto gen = reinterpret_cast<void(APIENTRY*)(int, unsigned*)>(GetGLProc("glGenFramebuffers"));
  const auto del = reinterpret_cast<void(APIENTRY*)(int, const unsigned*)>(GetGLProc("glDeleteFramebuffers"));
  const auto attach = reinterpret_cast<void(APIENTRY*)(unsigned, unsigned, unsigned, unsigned, int)>(GetGLProc("glFramebufferTexture2D"));
  const auto check = reinterpret_cast<unsigned(APIENTRY*)(unsigned)>(GetGLProc("glCheckFramebufferStatus"));
  const auto blit = reinterpret_cast<void(APIENTRY*)(int,int,int,int,int,int,int,int,unsigned,unsigned)>(GetGLProc("glBlitFramebuffer"));
  const auto get = reinterpret_cast<void(APIENTRY*)(unsigned,int*)>(GetGLProc("glGetIntegerv"));
  const auto is_enabled = reinterpret_cast<unsigned char(APIENTRY*)(unsigned)>(GetGLProc("glIsEnabled"));
  const auto enable = reinterpret_cast<void(APIENTRY*)(unsigned)>(GetGLProc("glEnable"));
  const auto disable = reinterpret_cast<void(APIENTRY*)(unsigned)>(GetGLProc("glDisable"));
  const auto read_buffer = reinterpret_cast<void(APIENTRY*)(unsigned)>(GetGLProc("glReadBuffer"));
  const auto draw_buffer = reinterpret_cast<void(APIENTRY*)(unsigned)>(GetGLProc("glDrawBuffer"));
  if (!bind || !gen || !del || !attach || !check || !blit || !get || !is_enabled || !enable || !disable || !read_buffer || !draw_buffer) return false;
  int read_fbo = 0, draw_fbo = 0;
  get(0x8CAA, &read_fbo);
  get(0x8CA6, &draw_fbo);
  const bool scissor = is_enabled(0x0C11) != 0;
  const bool srgb = is_enabled(0x8DB9) != 0;
  // Doom 3's screen copies (_currentRender for heat haze and weapon distortion,
  // _scratch, mirror and camera textures) are RGB8. Blitting the FP16 scene into
  // them clips HDR and quantizes it, which shows up as a square wherever a
  // distortion quad redraws the copy. Re-specify the game's own texture as
  // RGBA16F (same name, so its bindings follow) and sample alpha as 1 like RGB8.
  // Only level 0 is replaced: these images start as mipmapped 16x16 defaults
  // (R_RGBA8Image), but CopyFramebuffer re-specifies level 0 and switches the
  // texture to GL_LINEAR, so the stale small mips are never sampled.
  // Only 8-bit color targets: Doom 3's _currentDepth copy (soft particles) is
  // reported with the color clone as its source and must stay a depth texture.
  const bool legacy_color_dest = dst_desc.texture.format == format::r8g8b8_unorm
                                 || dst_desc.texture.format == format::r8g8b8x8_unorm
                                 || dst_desc.texture.format == format::r8g8b8a8_unorm;
  if (!depth && legacy_color_dest) {
    const auto bind_texture = reinterpret_cast<void(APIENTRY*)(unsigned, unsigned)>(GetGLProc("glBindTexture"));
    const auto tex_image = reinterpret_cast<void(APIENTRY*)(unsigned, int, int, int, int, int, unsigned, unsigned, const void*)>(GetGLProc("glTexImage2D"));
    const auto tex_parameter = reinterpret_cast<void(APIENTRY*)(unsigned, unsigned, int)>(GetGLProc("glTexParameteri"));
    int unpack_buffer = 0;
    get(0x88EF /* GL_PIXEL_UNPACK_BUFFER_BINDING */, &unpack_buffer);
    if (bind_texture && tex_image && tex_parameter && unpack_buffer == 0) {
      int texture = 0;
      get(0x8069 /* GL_TEXTURE_BINDING_2D */, &texture);
      bind_texture(0x0DE1, static_cast<unsigned>(dest.handle));
      tex_image(0x0DE1, 0, 0x881A /* GL_RGBA16F */, static_cast<int>(dst_desc.texture.width),
                static_cast<int>(dst_desc.texture.height), 0, 0x1908 /* GL_RGBA */, 0x1406 /* GL_FLOAT */, nullptr);
      tex_parameter(0x0DE1, 0x8E45 /* GL_TEXTURE_SWIZZLE_A */, 1 /* GL_ONE */);
      bind_texture(0x0DE1, static_cast<unsigned>(texture));
      dst_desc = cmd->get_device()->get_resource_desc(dest);
      if (!found->second.logged_copy_upgrade) {
        found->second.logged_copy_upgrade = true;
        reshade::log::message(reshade::log::level::info, "[Doom3 GL] Screen copy textures upgraded to RGBA16F so distortion effects keep HDR.");
      }
    }
  }
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
    const auto get_error = reinterpret_cast<unsigned(APIENTRY*)()>(GetGLProc("glGetError"));
    if (get_error) {
      const std::string error_text = "blit glGetError=" + std::to_string(get_error());
      TraceCopy(error_text.c_str(), source, dest, depth);
    }
  }
  if (!complete) TraceCopy("blit skipped: framebuffer incomplete", source, dest, depth);
  if (scissor) enable(0x0C11);
  if (srgb) enable(0x8DB9);
  bind(0x8CA8, read_fbo);
  bind(0x8CA9, draw_fbo);
  del(2, fbos);
  copying = false;
  if (complete && !found->second.logged_copy) {
    found->second.logged_copy = true;
    reshade::log::message(reshade::log::level::info, "[Doom3 GL] Screen copy routed through GPU framebuffer blit.");
  }
  return complete;
}

inline void OnDestroySwapchain(swapchain* swapchain, bool) {
  auto* device = swapchain->get_device();
  const auto found = framebuffers.find(device);
  if (found == framebuffers.end()) return;
  // WGL context destruction can precede ReShade teardown. Never call GL in
  // that case; context destruction releases the resources itself.
  using CurrentContext = HGLRC(WINAPI*)();
  const auto current = reinterpret_cast<CurrentContext>(GetProcAddress(GetModuleHandleW(L"opengl32.dll"), "wglGetCurrentContext"));
  if (current && reinterpret_cast<uintptr_t>(current()) == device->get_native()) {
    if (found->second.depth_view.handle) device->destroy_resource_view(found->second.depth_view);
    if (found->second.depth.handle) device->destroy_resource(found->second.depth);
    if (found->second.scratch.handle) device->destroy_resource(found->second.scratch);
    if (found->second.program != 0) GetToneMapGL()->delete_program(found->second.program);
  }
  framebuffers.erase(found);
}

// ReShade reports glEnable/glDisable(GL_DEPTH_TEST) as a depth_enable state.
inline void OnBindPipelineStates(command_list* cmd, uint32_t count, const dynamic_state* states, const uint32_t* values) {
  for (uint32_t i = 0; i < count; ++i) {
    if (states[i] != dynamic_state::depth_enable) continue;
    const auto found = framebuffers.find(cmd->get_device());
    if (found != framebuffers.end()) found->second.depth_test = values[i] != 0;
    return;
  }
}

inline void OnPresent(command_queue*, swapchain* swapchain, const rect*, const rect*, uint32_t, const rect*) {
  const auto found = framebuffers.find(swapchain->get_device());
  if (found == framebuffers.end()) return;
  // The display proxy has consumed this frame's flag; the next frame decides its own.
  found->second.stage = FrameStage::START;
  found->second.frame_draws = 0;
}

inline void Use(DWORD reason, ShaderInjectData* data) {
  if (reason == DLL_PROCESS_ATTACH) {
    injection = data;
    reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
    reshade::register_event<reshade::addon_event::draw>(OnDraw);
    reshade::register_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
    reshade::register_event<reshade::addon_event::clear_render_target_view>(OnClearColor);
    reshade::register_event<reshade::addon_event::clear_depth_stencil_view>(OnClearDepth);
    reshade::register_event<reshade::addon_event::copy_texture_region>(OnCopy);
    reshade::register_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
    reshade::register_event<reshade::addon_event::present>(OnPresent);
  } else if (reason == DLL_PROCESS_DETACH) {
    reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
    reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
    reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
    reshade::unregister_event<reshade::addon_event::draw_indexed>(OnDrawIndexed);
    reshade::unregister_event<reshade::addon_event::clear_render_target_view>(OnClearColor);
    reshade::unregister_event<reshade::addon_event::clear_depth_stencil_view>(OnClearDepth);
    reshade::unregister_event<reshade::addon_event::copy_texture_region>(OnCopy);
    reshade::unregister_event<reshade::addon_event::bind_pipeline_states>(OnBindPipelineStates);
    reshade::unregister_event<reshade::addon_event::present>(OnPresent);
  }
}
}  // namespace doom3::opengl
