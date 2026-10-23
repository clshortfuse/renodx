/*
 * Copyright (C) 2026 Musa Haji
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define DEBUG_SLIDERS_OFF

#include "./shared.h"

#if FORCE_HDR10
#include <wrl/client.h>
#include <array>
#include <memory>
#include <mutex>
#include <unordered_map>
#include <utility>
#include <vector>

#endif

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#if FORCE_HDR10
#include "../../mods/swapchain.hpp"
#endif
#include "../../utils/date.hpp"
#include "../../utils/random.hpp"
#if FORCE_HDR10
#include "../../utils/render.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/resource_upgrade.hpp"
#endif
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"

namespace {

ShaderInjectData shader_injection;

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "- Requires HDR on in game\n"
                 "- Requires DX12\n",
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDX"},
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 10000.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 150.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT.709", "LMS"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 150.f,
        .label = "UI Brightness",
        .section = "UI",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "UIGammaCorrection",
        .binding = &shader_injection.gamma_correction_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI SDR EOTF Emulation",
        .section = "UI",
        .tooltip = "Emulates a 2.2 EOTF for the UI",
        .labels = {"Off", "2.2"},
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTStrength",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Color Grade Strength",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeLUTScaling",
        .binding = &shader_injection.color_grade_scaling,
        .default_value = 100.f,
        .label = "Color Grade Scaling",
        .section = "Color Grading",
        .tooltip = "Scales the color grade LUT to full range when size is clamped.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "FxFilmGrainType",
        .binding = &shader_injection.custom_film_grain_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Vanilla", "Perceptual"},
    },
    new renodx::utils::settings::Setting{
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 50.f,
        .label = "FilmGrain",
        .section = "Effects",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.custom_film_grain_type != 0.f; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .section = "Options",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Purist",
        .section = "Options",
        .group = "button-line-1",
        .tooltip = "Follows the original artistic intent more closely.",
        .on_change = []() {
          renodx::utils::settings::ResetSettings();
          renodx::utils::settings::UpdateSettings({
              {"ToneMapWorkingColorSpace", 0.f},
              {"ColorGradeLUTScaling", 0.f},
              {"FxFilmGrainType", 0.f},
          });
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "Ce9bQHQrSV");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDR Den Discord",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Musa's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/musaqh"); },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "ShortFuse's Ko-Fi",
        .section = "Links",
        .group = "button-line-3",
        .tint = 0xFF5A16,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://ko-fi.com/shortfuse"); },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 250.f},
      {"ToneMapWorkingColorSpace", 0.f},
      {"ToneMapUINits", 250.f},
      {"UIGammaCorrection", 0.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeFlare", 0.f},
      {"ColorGradeLUTStrength", 100.f},
      {"ColorGradeLUTScaling", 0.f},
      {"FxFilmGrainType", 0.f},
      {"FxGrainStrength", 50.f},
  });
}

bool fired_on_init_swapchain = false;

#if FORCE_HDR10
struct FinalHDR10Pass {
  renodx::utils::render::RenderPass pass;
  Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> rtv_heap;
  reshade::api::resource facade = {0u};

  bool Initialize(
      reshade::api::device* device,
      reshade::api::resource physical_back_buffer,
      reshade::api::resource r16f_facade) {
    const auto physical_desc = device->get_resource_desc(physical_back_buffer);
    const auto facade_desc = device->get_resource_desc(r16f_facade);
    if (physical_desc.texture.format != reshade::api::format::r10g10b10a2_unorm
        || facade_desc.texture.format != reshade::api::format::r16g16b16a16_float
        || physical_desc.texture.width != facade_desc.texture.width
        || physical_desc.texture.height != facade_desc.texture.height) {
      return false;
    }

    auto* native_device = reinterpret_cast<ID3D12Device*>(static_cast<uintptr_t>(device->get_native()));
    auto* native_back_buffer = reinterpret_cast<ID3D12Resource*>(static_cast<uintptr_t>(physical_back_buffer.handle));
    if (native_device == nullptr || native_back_buffer == nullptr) return false;

    D3D12_DESCRIPTOR_HEAP_DESC heap_desc = {};
    heap_desc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    heap_desc.NumDescriptors = 1u;
    heap_desc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
    const HRESULT hr = native_device->CreateDescriptorHeap(&heap_desc, IID_PPV_ARGS(rtv_heap.GetAddressOf()));
    if (FAILED(hr)) {
      std::stringstream s;
      s << "callistoprotocol::FinalHDR10Pass(CreateDescriptorHeap failed, hr=0x";
      s << std::hex << static_cast<uint32_t>(hr) << std::dec << ')';
      reshade::log::message(reshade::log::level::error, s.str().c_str());
      return false;
    }

    const D3D12_CPU_DESCRIPTOR_HANDLE native_rtv = rtv_heap->GetCPUDescriptorHandleForHeapStart();
    D3D12_RENDER_TARGET_VIEW_DESC rtv_desc = {};
    rtv_desc.Format = DXGI_FORMAT_R10G10B10A2_UNORM;
    rtv_desc.ViewDimension = D3D12_RTV_DIMENSION_TEXTURE2D;
    native_device->CreateRenderTargetView(native_back_buffer, &rtv_desc, native_rtv);

    facade = r16f_facade;
    pass.render_target_slots.views = {{static_cast<uint64_t>(native_rtv.ptr)}};
    pass.render_target_slots.resource_descs = {physical_desc};
    pass.shader_resource_slots.resources = {facade};
    pass.shader_resource_slots.view_descs = {
        reshade::api::resource_view_desc(reshade::api::format::r16g16b16a16_float)};
    pass.sampler_descs = {reshade::api::sampler_desc{}};
    pass.pipeline_subobjects.vertex_shader = __swap_chain_proxy_vertex_shader;
    pass.pipeline_subobjects.pixel_shader = __swap_chain_proxy_pixel_shader;
    pass.pipeline_subobjects.render_target_formats = {reshade::api::format::r10g10b10a2_unorm};
    pass.auto_generate_render_target_formats = false;
    pass.auto_generate_viewport = false;
    pass.viewports = {{
        .x = 0.f,
        .y = 0.f,
        .width = static_cast<float>(physical_desc.texture.width),
        .height = static_cast<float>(physical_desc.texture.height),
        .min_depth = 0.f,
        .max_depth = 1.f,
    }};
    pass.auto_generate_scissors = false;
    pass.scissors = {{
        .left = 0,
        .top = 0,
        .right = static_cast<int32_t>(physical_desc.texture.width),
        .bottom = static_cast<int32_t>(physical_desc.texture.height),
    }};
    pass.render_target_load_op = reshade::api::render_pass_load_op::discard;
    pass.revert_state_after_render = false;
    pass.use_render_pass = false;
    return true;
  }

  void Destroy(reshade::api::device* device) {
    pass.DestroyAll(device);
    rtv_heap.Reset();
    facade = {0u};
  }
};

struct SwapchainPresentationState {
  reshade::api::device* device = nullptr;
  bool reported_missing_facade = false;
  std::unordered_map<uint64_t, std::unique_ptr<FinalHDR10Pass>> passes;
};

std::mutex presentation_mutex;
std::unordered_map<void*, bool> facade_requested_by_window;
std::unordered_map<reshade::api::swapchain*, SwapchainPresentationState> presentation_states;
thread_local bool suppress_barrier_mirroring = false;

void DestroyPresentationState(SwapchainPresentationState* state) {
  if (state == nullptr) return;
  for (auto& [back_buffer, pass] : state->passes) {
    (void)back_buffer;
    pass->Destroy(state->device);
  }
  state->passes.clear();
}

#if RESHADE_API_VERSION >= 17
bool OnCreateSwapchain(
    reshade::api::device_api device_api,
    reshade::api::swapchain_desc& desc,
    void* hwnd) {
#else
bool OnCreateSwapchain(reshade::api::swapchain_desc& desc, void* hwnd) {
  constexpr auto device_api = reshade::api::device_api::d3d11;
#endif
  const bool use_r16f_facade =
      device_api == reshade::api::device_api::d3d12
      && desc.back_buffer.texture.format == reshade::api::format::r16g16b16a16_float
      && (static_cast<uint32_t>(desc.back_buffer.usage)
          & static_cast<uint32_t>(reshade::api::resource_usage::render_target))
             != 0u;

  {
    const std::lock_guard lock(presentation_mutex);
    facade_requested_by_window[hwnd] = use_r16f_facade;
  }
  renodx::mods::swapchain::use_resource_cloning = use_r16f_facade;
  return false;
}
#endif

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
#if FORCE_HDR10
  bool use_r16f_facade = false;
  {
    const std::lock_guard lock(presentation_mutex);
    if (const auto request = facade_requested_by_window.find(swapchain->get_hwnd());
        request != facade_requested_by_window.end()) {
      use_r16f_facade = request->second;
    }
    if (use_r16f_facade && swapchain->get_device()->get_api() == reshade::api::device_api::d3d12) {
      auto& state = presentation_states[swapchain];
      state.device = swapchain->get_device();
    }
  }
  renodx::mods::swapchain::use_resource_cloning = use_r16f_facade;

  {
    std::stringstream s;
    s << "callistoprotocol::OnInitSwapchain(resize=" << (resize ? "true" : "false");
    s << ", format=" << swapchain->get_device()->get_resource_desc(swapchain->get_current_back_buffer()).texture.format;
    s << ", r16f_facade=" << (use_r16f_facade ? "true" : "false");
    s << ", back_buffers=";
    for (uint32_t index = 0; index < swapchain->get_back_buffer_count(); ++index) {
      if (index != 0u) s << ',';
      s << PRINT_PTR(swapchain->get_back_buffer(index).handle);
    }
    s << ')';
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }
#endif

  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    auto* peak_setting = renodx::utils::settings::FindSetting("ToneMapPeakNits");
    if (peak_setting != nullptr) {
      peak_setting->default_value = peak.value();
      peak_setting->can_reset = true;
    }
  }
}

#if FORCE_HDR10
void OnBarrier(
    reshade::api::command_list* cmd_list,
    uint32_t count,
    const reshade::api::resource* resources,
    const reshade::api::resource_usage* old_states,
    const reshade::api::resource_usage* new_states) {
  if (suppress_barrier_mirroring
      || cmd_list->get_device()->get_api() != reshade::api::device_api::d3d12
      || count == 0u
      || resources == nullptr
      || old_states == nullptr
      || new_states == nullptr) {
    return;
  }

  std::vector<reshade::api::resource> facade_resources;
  std::vector<reshade::api::resource_usage> facade_old_states;
  std::vector<reshade::api::resource_usage> facade_new_states;
  facade_resources.reserve(count);
  facade_old_states.reserve(count);
  facade_new_states.reserve(count);

  for (uint32_t index = 0u; index < count; ++index) {
    if (resources[index].handle == 0u) continue;

    reshade::api::resource facade = {0u};
    renodx::utils::resource::GetResourceInfo(
        resources[index],
        [&](const renodx::utils::resource::ResourceInfo& info) {
          if (info.destroyed
              || !info.is_swap_chain
              || !info.clone_enabled
              || info.desc.texture.format != reshade::api::format::r10g10b10a2_unorm
              || info.clone_desc.texture.format != reshade::api::format::r16g16b16a16_float) {
            return;
          }
          facade = info.clone;
        });
    if (facade.handle == 0u) continue;

    facade_resources.push_back(facade);
    facade_old_states.push_back(old_states[index]);
    facade_new_states.push_back(new_states[index]);
  }

  if (facade_resources.empty()) return;
  suppress_barrier_mirroring = true;
  cmd_list->barrier(
      static_cast<uint32_t>(facade_resources.size()),
      facade_resources.data(),
      facade_old_states.data(),
      facade_new_states.data());
  suppress_barrier_mirroring = false;
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  (void)source_rect;
  (void)dest_rect;
  (void)dirty_rect_count;
  (void)dirty_rects;
  if (queue == nullptr || swapchain->get_device()->get_api() != reshade::api::device_api::d3d12) return;

  const std::lock_guard lock(presentation_mutex);
  const auto state_pair = presentation_states.find(swapchain);
  if (state_pair == presentation_states.end()) return;
  auto& state = state_pair->second;

  const auto physical_back_buffer = swapchain->get_current_back_buffer();
  const auto facade = renodx::utils::resource::upgrade::GetResourceClone(
      physical_back_buffer,
      {.require_enabled = true, .allow_create = true, .activate = false});
  if (facade.handle == 0u) {
    if (!state.reported_missing_facade) {
      state.reported_missing_facade = true;
      reshade::log::message(
          reshade::log::level::warning,
          "callistoprotocol::OnPresent(skipped: R16F swapchain facade is unavailable)");
    }
    return;
  }
  state.reported_missing_facade = false;

  auto pass_pair = state.passes.find(physical_back_buffer.handle);
  if (pass_pair == state.passes.end()) {
    auto new_pass = std::make_unique<FinalHDR10Pass>();
    if (!new_pass->Initialize(swapchain->get_device(), physical_back_buffer, facade)) {
      reshade::log::message(
          reshade::log::level::error,
          "callistoprotocol::OnPresent(failed to initialize final HDR10 pass)");
      return;
    }
    pass_pair = state.passes.emplace(physical_back_buffer.handle, std::move(new_pass)).first;
  }

  auto* cmd_list = queue->get_immediate_command_list();
  if (cmd_list == nullptr) return;

  const std::array transition_resources = {facade, physical_back_buffer};
  const std::array pre_transition_old_states = {
      reshade::api::resource_usage::present,
      reshade::api::resource_usage::present,
  };
  const std::array pre_transition_new_states = {
      reshade::api::resource_usage::shader_resource,
      reshade::api::resource_usage::render_target,
  };
  const std::array post_transition_old_states = {
      reshade::api::resource_usage::shader_resource,
      reshade::api::resource_usage::render_target,
  };
  const std::array post_transition_new_states = {
      reshade::api::resource_usage::present,
      reshade::api::resource_usage::present,
  };

  const bool previous_suppression = std::exchange(suppress_barrier_mirroring, true);
  cmd_list->barrier(
      static_cast<uint32_t>(transition_resources.size()),
      transition_resources.data(),
      pre_transition_old_states.data(),
      pre_transition_new_states.data());
  const bool rendered = pass_pair->second->pass.Render(cmd_list, queue);
  cmd_list->barrier(
      static_cast<uint32_t>(transition_resources.size()),
      transition_resources.data(),
      post_transition_old_states.data(),
      post_transition_new_states.data());
  suppress_barrier_mirroring = previous_suppression;

  if (!rendered) {
    pass_pair->second->Destroy(swapchain->get_device());
    state.passes.erase(pass_pair);
    reshade::log::message(
        reshade::log::level::error,
        "callistoprotocol::OnPresent(final HDR10 pass failed)");
  }
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  const std::lock_guard lock(presentation_mutex);
  if (const auto state = presentation_states.find(swapchain); state != presentation_states.end()) {
    DestroyPresentationState(&state->second);
    presentation_states.erase(state);
  }
  if (!resize) {
    facade_requested_by_window.erase(swapchain->get_hwnd());
  }
  renodx::mods::swapchain::use_resource_cloning = false;
}

void OnDestroyDevice(reshade::api::device* device) {
  const std::lock_guard lock(presentation_mutex);
  for (auto state = presentation_states.begin(); state != presentation_states.end();) {
    if (state->second.device != device) {
      ++state;
      continue;
    }
    DestroyPresentationState(&state->second);
    state = presentation_states.erase(state);
  }
}
#endif

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for The Callisto Protocol";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

#if FORCE_HDR10
      reshade::register_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::barrier>(OnBarrier);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
#endif

      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;  // So overlays dont kill the game
      };

      renodx::utils::random::binds.push_back(&shader_injection.custom_random);  // film grain

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_index = 13;

#if FORCE_HDR10
        renodx::mods::swapchain::prevent_full_screen = false;
        renodx::mods::swapchain::force_borderless = false;
        renodx::mods::swapchain::force_screen_tearing = false;
        renodx::mods::swapchain::ignored_device_apis = {
            reshade::api::device_api::d3d9,
            reshade::api::device_api::d3d10,
            reshade::api::device_api::d3d11,
            reshade::api::device_api::opengl,
            reshade::api::device_api::vulkan,
        };
        renodx::mods::swapchain::use_resource_cloning = false;
        renodx::mods::swapchain::use_resource_cloning_dx12_only = true;
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
        renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
        renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;
        renodx::mods::swapchain::SetUseHDR10();
#endif

        initialized = true;
      }
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // detect peak nits

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
#if FORCE_HDR10
      reshade::unregister_event<reshade::addon_event::create_swapchain>(OnCreateSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::barrier>(OnBarrier);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
#endif
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);  // film grain
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
#if FORCE_HDR10
  renodx::mods::swapchain::Use(fdw_reason);
#endif

  return TRUE;
}