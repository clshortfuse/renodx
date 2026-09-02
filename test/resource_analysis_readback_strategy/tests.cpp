/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <iostream>

#include "src/addons/devkit/mcp/resource_readback.hpp"

namespace resource_readback = renodx::addons::devkit::mcp::resource_readback;

int main() {
  const auto vulkan_swapchain = resource_readback::BuildPlan(
      reshade::api::device_api::vulkan,
      true,
      reshade::api::format::r10g10b10a2_unorm,
      3440u,
      1440u);
  if (!vulkan_swapchain.use_buffer
      || vulkan_swapchain.row_pitch != 3440u * sizeof(std::uint32_t)
      || vulkan_swapchain.slice_pitch != 3440u * 1440u * sizeof(std::uint32_t)
      || vulkan_swapchain.source_before_copy != reshade::api::resource_usage::present
      || vulkan_swapchain.source_during_copy != reshade::api::resource_usage::copy_source
      || vulkan_swapchain.source_after_copy != reshade::api::resource_usage::present) {
    std::cerr << "Vulkan swapchain readback must use a tightly packed buffer and present/copy_source/present transitions.\n";
    return 1;
  }

  const auto vulkan_texture = resource_readback::BuildPlan(
      reshade::api::device_api::vulkan,
      false,
      reshade::api::format::r10g10b10a2_unorm,
      3440u,
      1440u);
  if (vulkan_texture.use_buffer) {
    std::cerr << "Non-swapchain Vulkan textures must retain the existing texture readback path.\n";
    return 1;
  }

  for (const auto device_api : {
           reshade::api::device_api::d3d11,
           reshade::api::device_api::d3d12,
           reshade::api::device_api::opengl,
       }) {
    const auto other_api = resource_readback::BuildPlan(
        device_api,
        true,
        reshade::api::format::r10g10b10a2_unorm,
        3440u,
        1440u);
    if (other_api.use_buffer) {
      std::cerr << "Non-Vulkan APIs must retain the existing texture readback path.\n";
      return 1;
    }
  }

  return 0;
}
