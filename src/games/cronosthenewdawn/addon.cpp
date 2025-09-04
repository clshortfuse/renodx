/*
 * Copyright (C) 2025 Ersh
 * SPDX-License-Identifier: MIT
 */

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>

#include <embed/0xD72DEB56.h>
#include <embed/0x42C2D7C2.h>
#include <embed/0x9D44D205.h>
#include <embed/0x6EB9926A.h>
#include <embed/0xE09CBF5F.h>
#include <embed/0x7A55D23A.h>
#include <embed/0x56863D5C.h>
#include <embed/0x13DD512A.h>
#include <embed/0xEF518D7F.h>
#include <embed/0x33AA90EB.h>
#include <embed/0xDE6B1981.h>
#include <embed/0x3A642BA6.h>
#include <embed/0x5480C654.h>
#include <embed/0x4DD36963.h>
#include <embed/0xD429DA60.h>
#include <embed/0xB7FDD0B1.h>
#include <embed/0x4A657EFC.h>
#include <embed/0x4D926E1C.h>
#include <embed/0x728BDCDB.h>
#include <embed/0x1F7B51A5.h>

#include <embed/0xC87F7532.h>
#include <embed/0x79FB0C54.h>
#include <embed/0x6C796330.h>
#include <embed/0x0ECBF85E.h>
#include <embed/0x9B22432D.h>
#include <embed/0xF4962825.h>
#include <embed/0xAB6082E4.h>
#include <embed/0xB5BC0C6C.h>
#include <embed/0x91B01C96.h>
#include <embed/0x063C3F08.h>
#include <embed/0x8146D205.h>
#include <embed/0x218A2E65.h>
#include <embed/0x99F97A36.h>
#include <embed/0xE357D692.h>
#include <embed/0x007524A4.h>
#include <embed/0xAD0A58C0.h>
#include <embed/0x8736B011.h>
#include <embed/0xFAD4B2E2.h>
#include <embed/0x7B1947FF.h>
#include <embed/0xC97E8E9B.h>

#include "../../mods/shader.hpp"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    CustomShaderEntry(0xD72DEB56),
    CustomShaderEntry(0x42C2D7C2),
    CustomShaderEntry(0x9D44D205),
    CustomShaderEntry(0x6EB9926A),
    CustomShaderEntry(0xE09CBF5F),
    CustomShaderEntry(0x7A55D23A),
    CustomShaderEntry(0x56863D5C),
    CustomShaderEntry(0x13DD512A),
    CustomShaderEntry(0xEF518D7F),
    CustomShaderEntry(0x33AA90EB),
    CustomShaderEntry(0xDE6B1981),
    CustomShaderEntry(0x3A642BA6),
    CustomShaderEntry(0x5480C654),
    CustomShaderEntry(0x4DD36963),
    CustomShaderEntry(0xD429DA60),
    CustomShaderEntry(0xB7FDD0B1),
    CustomShaderEntry(0x4A657EFC),
    CustomShaderEntry(0x4D926E1C),
    CustomShaderEntry(0x728BDCDB),
    CustomShaderEntry(0x1F7B51A5),

    CustomShaderEntry(0xC87F7532),
    CustomShaderEntry(0x79FB0C54),
    CustomShaderEntry(0x6C796330),
    CustomShaderEntry(0x0ECBF85E),
    CustomShaderEntry(0x9B22432D),
    CustomShaderEntry(0xF4962825),
    CustomShaderEntry(0xAB6082E4),
    CustomShaderEntry(0xB5BC0C6C),
    CustomShaderEntry(0x91B01C96),
    CustomShaderEntry(0x063C3F08),
    CustomShaderEntry(0x8146D205),
    CustomShaderEntry(0x218A2E65),
    CustomShaderEntry(0x99F97A36),
    CustomShaderEntry(0xE357D692),
    CustomShaderEntry(0x007524A4),
    CustomShaderEntry(0xAD0A58C0),
    CustomShaderEntry(0x8736B011),
    CustomShaderEntry(0xFAD4B2E2),
    CustomShaderEntry(0x7B1947FF),
    CustomShaderEntry(0xC97E8E9B),
};

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX - Cronos: The New Dawn";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::on_init_pipeline_layout = [](reshade::api::device* device, auto, auto) {
        return device->get_api() == reshade::api::device_api::d3d12;
      };

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::mods::shader::Use(fdw_reason, custom_shaders);

  return TRUE;
}
