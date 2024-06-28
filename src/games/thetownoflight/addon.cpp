/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <embed/0x9D6291BC.h>
#include <embed/0xB103EAA6.h>

#include <chrono>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include "../../mods/shaderReplaceMod.hpp"
#include "../../mods/swapChainUpgradeMod.hpp"
#include "../../utils/userSettingUtil.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
  CustomShaderEntry(0x9D6291BC),  // Color grading LUT + fog + fade
  CustomShaderEntry(0xB103EAA6),  // Post process (e.g. contrast) + user gamma adjustment (defaulted to 1)
};

}  // namespace

// NOLINTBEGIN(readability-identifier-naming)

extern "C" __declspec(dllexport) const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) const char* DESCRIPTION = "RenoDX for The Town of Light";

// NOLINTEND(readability-identifier-naming)

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::r8g8b8a8_unorm, reshade::api::format::r16g16b16a16_float}
      );
#if 1  // NOLINT Seemingly unused (they might be used for copies of the scene buffer used as UI background)
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::r8g8b8a8_typeless, reshade::api::format::r16g16b16a16_float}
      );
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::r8g8b8a8_unorm_srgb, reshade::api::format::r16g16b16a16_float}
      );
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::b8g8r8a8_typeless, reshade::api::format::r16g16b16a16_float}
      );
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::b8g8r8a8_unorm, reshade::api::format::r16g16b16a16_float}
      );
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back(
        {reshade::api::format::b8g8r8a8_unorm_srgb, reshade::api::format::r16g16b16a16_float}
      );
#endif

      break;

    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  // TODO(Filoppi): add user shader settings for tonemapping (paper white, peak brightness), and allow selecting between sRGB vs 2.2 gamma
  // TODO(Filoppi): add a final shader pass that does linearization, at the moment the mod requires an external ReShade shader to be linearized (with gamma 2.2) and for paper white scaling (80->203 nits)

  renodx::mods::swapchain::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
