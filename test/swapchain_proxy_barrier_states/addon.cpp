/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <windows.h>

#include <array>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <memory>
#include <span>
#include <unordered_map>
#include <vector>

#include <include/reshade.hpp>

#include "src/utils/draw.hpp"
#include "src/utils/resource.hpp"
#include "src/utils/resource_upgrade.hpp"

namespace {

std::filesystem::path module_path;
std::vector<uint8_t> vertex_shader;
std::vector<uint8_t> pixel_shader;
renodx::utils::resource::ResourceUpgradeInfo clone_target = {
    .usage_set = static_cast<uint32_t>(
        reshade::api::resource_usage::shader_resource
        | reshade::api::resource_usage::render_target
        | reshade::api::resource_usage::copy_dest),
    .use_resource_view_cloning_and_upgrade = true,
};
std::unordered_map<uint64_t, std::unique_ptr<renodx::utils::draw::SwapchainProxyPass>> proxy_passes;
bool proxy_run_logged = false;

std::vector<uint8_t> ReadShader(const std::filesystem::path& path) {
  std::ifstream input(path, std::ios::binary);
  return std::vector<uint8_t>(
      std::istreambuf_iterator<char>(input),
      std::istreambuf_iterator<char>());
}

void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() != reshade::api::device_api::vulkan) return;
  const auto directory = module_path.parent_path();
  vertex_shader = ReadShader(directory / "swap_chain_proxy_vertex_shader.spv");
  pixel_shader = ReadShader(directory / "swap_chain_proxy_pixel_shader.spv");
  if (vertex_shader.empty() || pixel_shader.empty()) {
    reshade::log::message(
        reshade::log::level::error,
        "Vulkan swapchain proxy test failed to load SPIR-V shaders.");
  }
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  (void)resize;
  if (swapchain->get_device()->get_api() != reshade::api::device_api::vulkan) {
    return;
  }

  const uint32_t back_buffer_count = swapchain->get_back_buffer_count();
  for (uint32_t index = 0u; index < back_buffer_count; ++index) {
    const auto back_buffer = swapchain->get_back_buffer(index);
    renodx::utils::resource::UpdateResourceInfo(
        back_buffer,
        [](renodx::utils::resource::ResourceInfo* info) {
          if (!info->is_swap_chain) return;
          clone_target.new_format = info->desc.texture.format;
          info->clone_target = &clone_target;
          info->clone_enabled = false;
          info->clone_can_deactivate = false;
        });
  }
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  (void)resize;
  for (auto& [back_buffer_handle, proxy_pass] : proxy_passes) {
    (void)back_buffer_handle;
    proxy_pass->Destroy(swapchain->get_device());
  }
  proxy_passes.clear();
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
  if (swapchain->get_device()->get_api() != reshade::api::device_api::vulkan
      || vertex_shader.empty()
      || pixel_shader.empty()) {
    return;
  }

  const auto back_buffer = swapchain->get_current_back_buffer();
  auto& proxy_pass = proxy_passes[back_buffer.handle];
  if (proxy_pass == nullptr) {
    proxy_pass = std::make_unique<renodx::utils::draw::SwapchainProxyPass>(
        renodx::utils::draw::SwapchainProxyPass{
            .vertex_shader = std::span<const uint8_t>(vertex_shader),
            .pixel_shader = std::span<const uint8_t>(pixel_shader),
            .revert_state = false,
            .use_compatibility_mode = true,
            .proxy_format = clone_target.new_format,
        });
  }

  if (!proxy_pass->Render(swapchain, queue)) {
    reshade::log::message(
        reshade::log::level::error,
        "Vulkan swapchain proxy compatibility pass failed.");
    return;
  }
  if (!proxy_run_logged) {
    reshade::log::message(
        reshade::log::level::info,
        "Vulkan swapchain proxy compatibility pass ran.");
    proxy_run_logged = true;
  }
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME =
    "RenoDX Vulkan Swapchain Proxy Barrier Test";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "Exercises compatibility proxy barriers in a real Vulkan swapchain";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, LPVOID reserved) {
  (void)reserved;
  switch (reason) {
    case DLL_PROCESS_ATTACH: {
      if (!reshade::register_addon(h_module)) return FALSE;
      static std::array<wchar_t, 32768> path = {};
      const DWORD length = GetModuleFileNameW(
          h_module, path.data(), static_cast<DWORD>(path.size()));
      if (length == 0u || length == path.size()) return FALSE;
      module_path = std::filesystem::path(path.data(), path.data() + length);

      renodx::utils::resource::upgrade::use_resource_cloning = true;
      renodx::utils::resource::upgrade::Use(reason);
      reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    }
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      renodx::utils::resource::upgrade::Use(reason);
      reshade::unregister_addon(h_module);
      break;
    default:
      break;
  }
  return TRUE;
}