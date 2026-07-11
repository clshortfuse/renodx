// RenoDX swapchain output preset/color-space synchronization starting shape.
// This is a snippet asset, not standalone C++. Adapt setting names and lifecycle
// hooks to the target addon. The key invariant is that shader preset, nits, and
// swapchain color space move together during presentation.

#if 0

std::optional<reshade::api::color_space> next_color_space = std::nullopt;
std::optional<reshade::api::color_space> current_color_space = std::nullopt;

void SyncSwapChainOutputPreset() {
  auto queue_color_space = [](reshade::api::color_space color_space) {
    if (current_color_space.has_value() && current_color_space.value() == color_space) {
      next_color_space = std::nullopt;
      return;
    }
    next_color_space = color_space;
  };

  const bool is_hdr10 = renodx::mods::swapchain::target_format == reshade::api::format::r10g10b10a2_unorm;
  const bool is_hdr_output = output_mode_setting->GetValue() != 0.f;

  if (is_hdr_output) {
    shader_injection.peak_white_nits = tone_map_peak_nits_setting->GetValue();
    shader_injection.diffuse_white_nits = tone_map_game_nits_setting->GetValue();
    shader_injection.graphics_white_nits = tone_map_ui_nits_setting->GetValue();
    shader_injection.swap_chain_output_preset = is_hdr10 ? 1.f : 2.f;
    queue_color_space(is_hdr10
                          ? reshade::api::color_space::hdr10_st2084
                          : reshade::api::color_space::extended_srgb_linear);
    return;
  }

  shader_injection.peak_white_nits = 1.f;
  shader_injection.diffuse_white_nits = 1.f;
  shader_injection.graphics_white_nits = 1.f;
  shader_injection.swap_chain_output_preset = is_hdr10 ? 0.f : 2.f;
  queue_color_space(is_hdr10
                        ? reshade::api::color_space::srgb_nonlinear
                        : reshade::api::color_space::extended_srgb_linear);
}

void OnPresent(reshade::api::command_queue*,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect*,
               const reshade::api::rect*,
               uint32_t,
               const reshade::api::rect*) {
  if (swapchain == nullptr || !renodx::mods::swapchain::IsUpgraded(swapchain)) return;

  SyncSwapChainOutputPreset();
  if (next_color_space.has_value()) {
    const auto pending_color_space = next_color_space.value();
    renodx::utils::swapchain::ChangeColorSpace(swapchain, pending_color_space);
    current_color_space = pending_color_space;
    next_color_space = std::nullopt;
  }
}

#endif