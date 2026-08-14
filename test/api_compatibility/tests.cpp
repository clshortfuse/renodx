/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
#include <span>
#include <string>
#include <type_traits>
#include <unordered_map>
#include <vector>

#include <include/reshade.hpp>

#include "src/mods/shader.hpp"
#include "src/utils/render.hpp"

#ifndef CustomOpenGLVulkanShaders
#error "The initial Vulkan PR CustomOpenGLVulkanShaders macro must remain available."
#endif

namespace {

namespace shader = renodx::mods::shader;
namespace render = renodx::utils::render;

using OpenGLVulkanShaderFactory = shader::CustomShader (*)(
    std::uint32_t,
    std::span<const std::uint8_t>,
    std::span<const std::uint8_t>);

static_assert(std::is_same_v<decltype(shader::ViewBinding::space), std::uint32_t>);
static_assert(std::is_same_v<decltype(&shader::CreateOpenGLVulkanShader), OpenGLVulkanShaderFactory>);
static_assert(requires(render::RenderPass pass) {
  pass.descriptor_tables;
  pass.descriptor_table_updates;
});

const std::uint8_t __0xC0C0C0C0_gl[] = {0x01};
const std::uint8_t __0xC0C0C0C0_vk[] = {0x02};
const std::unordered_map<std::uint32_t, shader::CustomShader> g_initial_pr_shader_registration = {
    CustomOpenGLVulkanShaders(0xC0C0C0C0),
};

}  // namespace

int main() {
  const shader::ViewBinding binding;
  if (binding.space != 50u) return 1;
  if (g_initial_pr_shader_registration.at(0xC0C0C0C0).code_by_device.size() != 2u) return 1;
  return 0;
}
