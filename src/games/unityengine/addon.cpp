/*
 * Copyright (C) 2023 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <chrono>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/shader.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/random.hpp"
#include "./dump_uber.hpp"
#include "./shared.h"

namespace {

float unityTonemapper = 0.f; // 1 = none, 2 = neutral/sapphire/custom, 3 = ACES
constexpr auto DUMP_UBER_INITIAL_WINDOW = std::chrono::seconds(1);
constexpr auto DUMP_UBER_PERIODIC_INTERVAL = std::chrono::seconds(5);

enum class DumpUberScheduleState : std::uint8_t {
  IDLE,
  INITIAL_WINDOW,
  COOLDOWN,
  PERIODIC_FRAME,
};

DumpUberScheduleState dump_uber_schedule_state = DumpUberScheduleState::IDLE;
std::chrono::steady_clock::time_point dump_uber_schedule_deadline = {};
bool dump_uber_schedule_observed = false;
float g_use_swapchain_proxy = 0.f;
float g_upgrade_internal_lut = 1.f;
float countMid = 0.f;
float countOffset = 0.f;
float count2Mid = 0.f;
float count2Offset = 0.f;
float gammaSpace = 0.f;
bool gammaSpaceLock = false;
float blitCopyHack = 0.f;
float blitCopyCheck = 0.f;
bool forceDetect = false;
float FSRcheck = 0.f;
bool lutSampler = false;
bool lutBuilder = false;
bool sneakyBuilder = false;
float InternalLutCheck = 0.f;
bool finalBlitCheck;

ShaderInjectData shader_injection;

#define UpgradeRTVShader(value)              \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .on_draw = [](auto* cmd_list) {                                                           \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                       \
            bool changed = false;                                                                   \
            for (auto rtv : rtvs) {                                                                 \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv); \
            }                                                                                       \
            if (changed) {                                                                          \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                  \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});      \
            }                                                                                       \
            return true; }, \
      },                                     \
  }

// LutGen, LutBuilder3D
// can hide
bool SneakyBuilderTonemap1(reshade::api::command_list* cmd_list) {
  //unityTonemapper = 1.5f;
  unityTonemapper = unityTonemapper <= 1.f ? 1.5f : unityTonemapper;
  forceDetect = true;
  sneakyBuilder = true;
  lutBuilder = true;
  return true;
}
#define SneakyBuilder1OnDraw(value)            \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = SneakyBuilderTonemap1,    \
      },                                       \
  }
bool SneakyBuilderTonemap2(reshade::api::command_list* cmd_list) {
  unityTonemapper = 2;
  forceDetect = true;
  sneakyBuilder = true;
  lutBuilder = true;
  return true;
}
#define SneakyBuilder2OnDraw(value)            \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = SneakyBuilderTonemap2,    \
      },                                       \
  }
bool SneakyBuilderTonemap3(reshade::api::command_list* cmd_list) {
  unityTonemapper = 3;
  forceDetect = true;
  sneakyBuilder = true;
  lutBuilder = true;
  return true;
}
#define SneakyBuilder3OnDraw(value)            \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = SneakyBuilderTonemap3,    \
      },                                       \
  }
// LutBuilderHdr NoTonemap, Lut3DBaker NoTonemap, Lut2DBaker, LutBuilderLdr,
// can have multiple draws
bool LutBuilderTonemap1(reshade::api::command_list* cmd_list) {
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  forceDetect = true;
  lutBuilder = true;
  return true;
}
#define Builder1OnDraw(value)                  \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = LutBuilderTonemap1,       \
      },                                       \
  }
bool LutBuilderTonemap2(reshade::api::command_list* cmd_list) {
  unityTonemapper = 2;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  forceDetect = true;
  lutBuilder = true;
  return true;
}
#define Builder2OnDraw(value)                  \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = LutBuilderTonemap2,       \
      },                                       \
  }
bool LutBuilderTonemap3(reshade::api::command_list* cmd_list) {
  unityTonemapper = 3;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  forceDetect = true;
  lutBuilder = true;
  return true;
}
#define Builder3OnDraw(value)                  \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = LutBuilderTonemap3,       \
      },                                       \
  }
bool Count(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  return true;
}
bool Clamped(reshade::api::command_list* cmd_list) {
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  return true;
}
bool CountClamped(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  return true;
}
bool CountLinear(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  return true;
}
#define CountLinearOnDraw(value)               \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = CountLinear,              \
      },                                       \
  }
bool CountLinearClamped(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  return true;
}
bool Gamma(reshade::api::command_list* cmd_list) {
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  return true;
}
bool GammaClamped(reshade::api::command_list* cmd_list) {
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  return true;
}
bool CountGamma(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  return true;
}
bool CountGammaClamped(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  return true;
}
bool CountTonemap1(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  forceDetect = true;
  return true;
}
#define CountTonemap1OnDraw(value)             \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = CountTonemap1,            \
      },                                       \
  }
bool CountTonemap1Clamped(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  return true;
}
bool CountLinearTonemap1(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  forceDetect = true;
  return true;
}
#define CountLinearTonemap1OnDraw(value)          \
  {                                               \
      value,                                      \
      {                                           \
          .crc32 = value,                         \
          .code = __##value,                      \
          .on_draw = CountLinearTonemap1,         \
      },                                          \
  }
bool CountLinearTonemap1Clamped(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
#define CountLinearTonemap1ClampedOnDraw(value)   \
  {                                               \
      value,                                      \
      {                                           \
          .crc32 = value,                         \
          .code = __##value,                      \
          .on_draw = CountLinearTonemap1Clamped,  \
      },                                          \
  }
bool CountGammaTonemap1(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  forceDetect = true;
  return true;
}
#define CountGammaTonemap1OnDraw(value)           \
  {                                               \
      value,                                      \
      {                                           \
          .crc32 = value,                         \
          .code = __##value,                      \
          .on_draw = CountGammaTonemap1,          \
      },                                          \
  }
bool CountGammaTonemap1Clamped(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  shader_injection.count2New += 1.f;
  count2Mid += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  unityTonemapper = unityTonemapper <= 1.f ? 1 : unityTonemapper;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
#define CountGammaTonemap1ClampedOnDraw(value)    \
  {                                               \
      value,                                      \
      {                                           \
          .crc32 = value,                         \
          .code = __##value,                      \
          .on_draw = CountGammaTonemap1Clamped,   \
      },                                          \
  }
bool CountLinearTonemap2(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  unityTonemapper = 2;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
bool CountLinearTonemap2Luminance(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  unityTonemapper = 2.5f;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
bool CountLinearTonemap3(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  unityTonemapper = 3;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
bool CountLinearTonemap35(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  unityTonemapper = 3.5f;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
#define CountLinearACES709OnDraw(value)        \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = CountLinearTonemap35,     \
      },                                       \
  }
bool CountGammaTonemap35(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  unityTonemapper = 3.5f;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  forceDetect = true;
  return true;
}
#define CountGammaACES709OnDraw(value)         \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = CountGammaTonemap35,      \
      },                                       \
  }
// HDRP Uber
bool UberHDRP(reshade::api::command_list* cmd_list) {
  /*countMid += 1.f;
  shader_injection.countNew += 1.f;*/
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? (unityTonemapper >= 2.f ? 1.f : shader_injection.isClamped) : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberHDRPOnDraw(value)                  \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberHDRP,                 \
      },                                       \
  }
// PostFX Uber
bool UberPFXLinear(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberPFXLinearOnDraw(value)             \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberPFXLinear,            \
      },                                       \
  }
bool UberPFXGamma(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberPFXGammaOnDraw(value)              \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberPFXGamma,             \
      },                                       \
  }
// URP/PP
bool UberHD(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? (unityTonemapper >= 2.f ? 1.f : shader_injection.isClamped) : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberHDOnDraw(value)                    \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberHD,                   \
      },                                       \
  }
bool UberHDLinear(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? (unityTonemapper >= 2.f ? 1.f : shader_injection.isClamped) : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberHDLinearOnDraw(value)              \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberHDLinear,             \
      },                                       \
  }
bool UberHDGamma(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? (unityTonemapper >= 2.f ? 1.f : shader_injection.isClamped) : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberHDGammaOnDraw(value)               \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberHDGamma,              \
      },                                       \
  }
bool UberLinear(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberLinearOnDraw(value)                \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberLinear,               \
      },                                       \
  }
bool UberGamma(reshade::api::command_list* cmd_list) {
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberGammaOnDraw(value)                 \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberGamma,                \
      },                                       \
  }
bool UberNeutralLinear(reshade::api::command_list* cmd_list) {
  unityTonemapper = 2;
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberNeutralLinearOnDraw(value)         \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberNeutralLinear,        \
      },                                       \
  }
bool UberNeutralGamma(reshade::api::command_list* cmd_list) {
  unityTonemapper = 2;
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberNeutralGammaOnDraw(value)          \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberNeutralGamma,         \
      },                                       \
  }
bool UberACESLinear(reshade::api::command_list* cmd_list) {
  unityTonemapper = 3;
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 0.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberACESLinearOnDraw(value)            \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberACESLinear,           \
      },                                       \
  }
bool UberACESGamma(reshade::api::command_list* cmd_list) {
  unityTonemapper = 3;
  countMid += 1.f;
  shader_injection.countNew += 1.f;
  gammaSpace = 1.f;
  gammaSpaceLock = true;
  forceDetect = true;
  shader_injection.isClamped = shader_injection.isClamped == 0.f ? 1.f : shader_injection.isClamped;
  lutSampler = true;
  return true;
}
#define UberACESGammaOnDraw(value)             \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = UberACESGamma,            \
      },                                       \
  }
bool blitCopy(reshade::api::command_list* cmd_list) {
  blitCopyCheck = 1.f;
  unityTonemapper = shader_injection.blitCopyHack == 1.f ? (unityTonemapper <= 1.f ? 1 : unityTonemapper) : unityTonemapper;
  countMid += shader_injection.blitCopyHack >= 1.f ? 1.f : 0.f;
  shader_injection.countNew += shader_injection.blitCopyHack >= 1.f ? 1.f : 0.f;
  shader_injection.count2New += shader_injection.blitCopyHack == 1.f ? 1.f : 0.f;
  count2Mid += shader_injection.blitCopyHack == 1.f ? 1.f : 0.f;
  return true;
}
#define BlitCopyOnDraw(value)                  \
  {                                            \
      value,                                   \
      {                                        \
          .crc32 = value,                      \
          .code = __##value,                   \
          .on_draw = blitCopy,                 \
      },                                       \
  }

renodx::mods::shader::CustomShaders custom_shaders = {};

struct ShaderItem {
  uint32_t key;
  renodx::mods::shader::CustomShader val;
};

const ShaderItem INITIAL_SHADERS[] = {
    ////// HDRP START //////
    UberHDRPOnDraw(0x45C0BC06),
    UberHDRPOnDraw(0x59A9259E),
    UberHDRPOnDraw(0x7158A819),
    UberHDRPOnDraw(0x2248992F),
    UberHDRPOnDraw(0x18151718),
    UberHDRPOnDraw(0xA7F94682),
    UberHDRPOnDraw(0xA53F9357),
    UberHDRPOnDraw(0xB9857DFB),
    UberHDRPOnDraw(0xE59F5A45),
    UberHDRPOnDraw(0xF6574655),
    UberHDRPOnDraw(0x29F16183),
    UberHDRPOnDraw(0x17E28214),
    UberHDRPOnDraw(0x4CF0CF09),
    UberHDRPOnDraw(0x96F6F68C),
    UberHDRPOnDraw(0xAE389F39),
    UberHDRPOnDraw(0xE37D7F68),
    UberHDRPOnDraw(0x0DCDFAE0),
    UberHDRPOnDraw(0x00E804D9),
    UberHDRPOnDraw(0x1D15C861),
    UberHDRPOnDraw(0x1DD23EA0),
    UberHDRPOnDraw(0x3BD8B8FD),
    UberHDRPOnDraw(0x3F04EE8D),
    UberHDRPOnDraw(0x4BAB5541),
    UberHDRPOnDraw(0x5F120263),
    UberHDRPOnDraw(0x6A47E083),
    UberHDRPOnDraw(0x8FEBA362),
    UberHDRPOnDraw(0x9A3E18AA),
    UberHDRPOnDraw(0x9A994A5E),
    UberHDRPOnDraw(0x9B5C1401),
    UberHDRPOnDraw(0x9B9E38C3),
    UberHDRPOnDraw(0x9F0BEDCA),
    UberHDRPOnDraw(0x16F88A15),
    UberHDRPOnDraw(0x23F1EC4F),
    UberHDRPOnDraw(0x87DFDDEA),
    UberHDRPOnDraw(0x719C0C73),
    UberHDRPOnDraw(0x744F5F34),
    UberHDRPOnDraw(0x802BDE1D),
    UberHDRPOnDraw(0x2194C4A3),
    UberHDRPOnDraw(0x3530AC89),
    UberHDRPOnDraw(0x6194BBEB),
    UberHDRPOnDraw(0x6983BFA7),
    UberHDRPOnDraw(0x44791CF0),
    UberHDRPOnDraw(0x490447DA),
    UberHDRPOnDraw(0x10525777),
    UberHDRPOnDraw(0xA322A00F),
    UberHDRPOnDraw(0xB81F1E24),
    UberHDRPOnDraw(0xC6B954D6),
    UberHDRPOnDraw(0xC6F22BEE),
    UberHDRPOnDraw(0xC52310D2),
    UberHDRPOnDraw(0xCF6E0603),
    UberHDRPOnDraw(0xD6B5AD4A),
    UberHDRPOnDraw(0xD36BB165),
    UberHDRPOnDraw(0xDB01F22E),
    UberHDRPOnDraw(0xE6B97032),
    UberHDRPOnDraw(0xE363E5C8),
    UberHDRPOnDraw(0xE12729AC),
    UberHDRPOnDraw(0xECEF72F5),
    UberHDRPOnDraw(0xF1A75575),
    UberHDRPOnDraw(0xF8BA0FA2),
    UberHDRPOnDraw(0xF110C44D),
    UberHDRPOnDraw(0xFA609710),
    UberHDRPOnDraw(0xFDF96092),
    UberHDRPOnDraw(0xEFE2ADAE),
      // final pass
    CountLinearOnDraw(0x0CF3B8B8),
    CountLinearOnDraw(0x0E1A7B34),
    CountLinearOnDraw(0x0E6EFF3C),
    CountLinearOnDraw(0x0E8D6C4C),
    CountLinearOnDraw(0x0FA783B7),
    CountLinearOnDraw(0x1A0928AF),
    CountLinearOnDraw(0x1B6B4125),
    CountLinearOnDraw(0x002A3518),
    CountLinearOnDraw(0x02AB22C6),
    CountLinearOnDraw(0x3D8F662C),
    CountLinearOnDraw(0x3DA6127F),
    CountLinearOnDraw(0x4BD9F109),
    CountLinearOnDraw(0x4DE06BC3),
    CountLinearOnDraw(0x4E2A63EE),
    CountLinearOnDraw(0x5A977943),
    CountLinearOnDraw(0x08F6AF40),
    CountLinearOnDraw(0x31B9B1AB),
    CountLinearOnDraw(0x38B55FCE),
    CountLinearOnDraw(0x44D2D279),
    CountLinearOnDraw(0x48DCE4C7),
    CountLinearOnDraw(0x51F1D5CA),
    CountLinearOnDraw(0x54D67961),
    CountLinearOnDraw(0x55D603B1),
    CountLinearOnDraw(0x067F6831),
    CountLinearOnDraw(0x68B1161B),
    CountLinearOnDraw(0x73F01A45),
    CountLinearOnDraw(0x78C63EB0),
    CountLinearOnDraw(0x78ED6152),
    CountLinearOnDraw(0x85DF4472),
    CountLinearOnDraw(0x91D61E3F),
    CountLinearOnDraw(0x110E8EE6),
    CountLinearOnDraw(0x222AC31F),
    CountLinearOnDraw(0x810A1D59),
    CountLinearOnDraw(0x1310A22D),
    CountLinearOnDraw(0x3069A872),
    CountLinearOnDraw(0x8883FAEA),
    CountLinearOnDraw(0x13808C73),
    CountLinearOnDraw(0x27812EF8),
    CountLinearOnDraw(0x28075F34),
    CountLinearOnDraw(0x40072B90),
    CountLinearOnDraw(0x44080C9A),
    CountLinearOnDraw(0x774090A7),
    CountLinearOnDraw(0x2548186A),
    CountLinearOnDraw(0x78363901),
    CountLinearOnDraw(0xA5CF0E57),
    CountLinearOnDraw(0xA6DA2B34),
    CountLinearOnDraw(0xA73C3123),
    CountLinearOnDraw(0xA5809BF4),
    CountLinearOnDraw(0xAB2CD6E2),
    CountLinearOnDraw(0xAC34C8D9),
    CountLinearOnDraw(0xAC51C144),
    CountLinearOnDraw(0xAE7EE10F),
    CountLinearOnDraw(0xB2B44A63),
    CountLinearOnDraw(0xB26F4E2D),
    CountLinearOnDraw(0xBBC1FA0B),
    CountLinearOnDraw(0xBD481C0C),
    CountLinearOnDraw(0xBDA2DF56),
    CountLinearOnDraw(0xBF447ED7),
    CountLinearOnDraw(0xCE6260A3),
    CountLinearOnDraw(0xD0BF0A3A),
    CountLinearOnDraw(0xD4E338C4),
    CountLinearOnDraw(0xD8C621CB),
    CountLinearOnDraw(0xD22CD417),
    CountLinearOnDraw(0xDD2F76F2),
    CountLinearOnDraw(0xED0AF2E7),
    CountLinearOnDraw(0xEEFA69A4),
    CountLinearOnDraw(0xF9FE3D5A),
    CountLinearOnDraw(0xFFB14DDC),
    CountLinearOnDraw(0xA7E4A5B2),
    CountLinearOnDraw(0x3068FF2D),
      /// Builder 3D ///
        // No Tonemap
    SneakyBuilder1OnDraw(0xE6786595),
    SneakyBuilder1OnDraw(0x5BD02347),
        // Neutral
    SneakyBuilder2OnDraw(0x7E72688E),
    SneakyBuilder2OnDraw(0x61FFF3FD),
    SneakyBuilder2OnDraw(0xD849047B),
        // ACES
    SneakyBuilder3OnDraw(0x7F27D36D),
    SneakyBuilder3OnDraw(0x17CE181A),
    SneakyBuilder3OnDraw(0x3661DD34),
    SneakyBuilder3OnDraw(0x3917A841),
    SneakyBuilder3OnDraw(0x6811A33B),
    SneakyBuilder3OnDraw(0xF5AC76A9),
    SneakyBuilder3OnDraw(0x56369810),

        // Custom
    SneakyBuilder2OnDraw(0x3B4291E8),
    SneakyBuilder2OnDraw(0x7D343D34),
    SneakyBuilder2OnDraw(0x534F0886),
    ////// HDRP END //////
    ////// CRP START //////
    CustomShaderEntryCallback(0xA4DA5EBA, &CountLinearTonemap3),
    ////// URP START //////
      /// Builder Hdr ///
        // No Tonemap
    Builder1OnDraw(0x6C5FFF35),
    Builder1OnDraw(0x9B213AF8),
    Builder1OnDraw(0x39CEB40A),
    Builder1OnDraw(0x404D05C7),
    Builder1OnDraw(0x508ABDBD),
    Builder1OnDraw(0x20D6EA4D),
    Builder1OnDraw(0x8576F73A),
    Builder1OnDraw(0x04F466E8),
    Builder1OnDraw(0xD73B437F),
    Builder1OnDraw(0x89B011BE),
        // Neutral
    Builder2OnDraw(0x6C506E30),
    Builder2OnDraw(0x819CADDA),
    Builder2OnDraw(0x850A0BF8),
    Builder2OnDraw(0x15F8BFBD),
    Builder2OnDraw(0x00C2E62A),
    Builder2OnDraw(0x8A61E2C4),
    Builder2OnDraw(0x1F81C511),  // custom params
        // ACES
    Builder3OnDraw(0x5E10541B),
    Builder3OnDraw(0x13A5D726),
    Builder3OnDraw(0x31B52561),
    Builder3OnDraw(0x042C6BD1),
    Builder3OnDraw(0x64B708E6),
    Builder3OnDraw(0x246CE154),
    Builder3OnDraw(0xCE436C36),
    Builder3OnDraw(0xE6EC2E40),
    Builder3OnDraw(0xAE8C0E90),
    Builder3OnDraw(0xBAF1CCB4),
    Builder3OnDraw(0x1F679F37),
    Builder3OnDraw(0xA43D2B2D),
        // Custom
    Builder2OnDraw(0x93FBDA60),
      /// Builder Ldr ///
    Builder1OnDraw(0x62F196B6),
    Builder1OnDraw(0x48B66B90),
    Builder1OnDraw(0x13EEF169),
    Builder1OnDraw(0x085F1ADA),
    Builder1OnDraw(0x731B4F3C),
    Builder1OnDraw(0x0906E676),
    Builder1OnDraw(0x562744E8),
    Builder1OnDraw(0x574581C7),
    Builder1OnDraw(0xB3DF43CA),
    Builder1OnDraw(0xDA75BEB5),
    Builder1OnDraw(0xED457D04),
    Builder1OnDraw(0xFFA5BFB6),
    Builder1OnDraw(0xE736DD70),
    Builder1OnDraw(0x453D9983),
    Builder1OnDraw(0xABAD60A0),
    Builder1OnDraw(0x63098018),
      // GenUberLut
    Builder1OnDraw(0x894B73C7),
    Builder1OnDraw(0xDA07C0CD),
    Builder1OnDraw(0xEFB0C6F3),
    Builder1OnDraw(0xCD470040),
    Builder1OnDraw(0x94FB997A),
    Builder1OnDraw(0x21D72E29),
    Builder1OnDraw(0x6E73582E),
    Builder1OnDraw(0xD86138D0),
    Builder1OnDraw(0x387E19AA),
    Builder1OnDraw(0xE23B9B48),
      /// Uber ///
        // NoTonemap
    UberLinearOnDraw(0x00A6DC6D),
    UberLinearOnDraw(0x71A2C76F),
    UberLinearOnDraw(0xD1414798),
    UberLinearOnDraw(0xDC56B686),
    UberLinearOnDraw(0xE9E072CB),
    UberLinearOnDraw(0x2A1C50A3),
    UberLinearOnDraw(0x2B67D8D5),
    UberLinearOnDraw(0x3C1076FD),
    UberLinearOnDraw(0x76DB4A6B),
    UberLinearOnDraw(0x81F618AE),
    UberLinearOnDraw(0x2546D5B8),
    UberLinearOnDraw(0xF211C0FB),
    UberLinearOnDraw(0x5D2E23EB),
    UberLinearOnDraw(0x0948E708),
    UberLinearOnDraw(0x3168A95B),
    UberLinearOnDraw(0x9862BA48),
    UberLinearOnDraw(0x28710E71),
    UberLinearOnDraw(0x1906BE79),
    UberLinearOnDraw(0x15A063ED),
    UberLinearOnDraw(0x22F1555A),
    UberLinearOnDraw(0xBB09D0B3),
    UberLinearOnDraw(0xB2FA9650),
    UberLinearOnDraw(0x614D4290),
    UberLinearOnDraw(0x333D4088),
    UberLinearOnDraw(0x2B398141),
    UberLinearOnDraw(0xDF97E9E0),
    UberLinearOnDraw(0xA1BB94CF),
    UberLinearOnDraw(0xA9C30A53),
    UberLinearOnDraw(0xB75D73F2),
    UberLinearOnDraw(0x4892C014),
    UberLinearOnDraw(0x077C4EBE),
    UberLinearOnDraw(0x70F983D7),
    UberLinearOnDraw(0x5808E5C6),
    UberLinearOnDraw(0x3816ADE8),
    UberLinearOnDraw(0x9BD5D660),
    UberLinearOnDraw(0xA57C372D),
    UberLinearOnDraw(0x943DD65F),
    UberLinearOnDraw(0x6BC3D81A),
    UberGammaOnDraw(0x6BFABBE2),
    UberLinearOnDraw(0x5EE0EFE9),
    UberLinearOnDraw(0x7C36C890),
    UberLinearOnDraw(0x8596AD69),
    UberLinearOnDraw(0x83BB5283),
    UberLinearOnDraw(0x53F75ED5),
    UberLinearOnDraw(0x80C9179E),
    UberLinearOnDraw(0xB8F165EF),
    UberLinearOnDraw(0x34FDFCCA),
    UberLinearOnDraw(0xDE9C4A17),
    UberLinearOnDraw(0x0C95BEDA),
    UberLinearOnDraw(0x0D586669),
    UberLinearOnDraw(0xCF58B964),
    UberLinearOnDraw(0x44894E92),
    UberLinearOnDraw(0x67BE60E8),
    UberLinearOnDraw(0x57A835DD),
    UberLinearOnDraw(0xEA0DA356),
    UberLinearOnDraw(0xBEF83327),
    UberLinearOnDraw(0xDD53453F),
    UberLinearOnDraw(0xCF4215DF),
    UberLinearOnDraw(0xC228F88E),
    UberLinearOnDraw(0xC241D030),
    UberLinearOnDraw(0x4A833CC2),
    UberLinearOnDraw(0x1E8BAB2B),
    UberLinearOnDraw(0x653DB2AA),
    UberLinearOnDraw(0x620B1A71),
    UberLinearOnDraw(0x75812DD3),
    UberLinearOnDraw(0xFA04705A),
    UberLinearOnDraw(0xEC2E44B0),
    UberLinearOnDraw(0x7BB9330C),
    UberLinearOnDraw(0x1618D91F),
    UberLinearOnDraw(0x719D77DA),
    UberLinearOnDraw(0x71969DA6),
    UberLinearOnDraw(0x4B2F7132),
    UberLinearOnDraw(0x82A8E8D5),
    UberLinearOnDraw(0x4492D315),
    UberLinearOnDraw(0x8B0129A4),
    UberLinearOnDraw(0x08CFBDB7),
    UberLinearOnDraw(0x969ECAC4),
    UberLinearOnDraw(0x309787A8),
    UberLinearOnDraw(0x7F1E137D),
    UberLinearOnDraw(0xA0F1B778),
    UberLinearOnDraw(0x307A97FD),
    UberLinearOnDraw(0xA32B02F0),
    UberLinearOnDraw(0x76D0ACF3),
    UberLinearOnDraw(0xF0695EEC),
    UberLinearOnDraw(0x379F6448),
    UberLinearOnDraw(0x06779954),
    UberLinearOnDraw(0x5D7DCAA9),
    UberLinearOnDraw(0xB6CB924F),
    UberLinearOnDraw(0x1B985159),
    UberLinearOnDraw(0x3503DCAE),
    UberLinearOnDraw(0x5A6D38E4),
    UberLinearOnDraw(0x5CD23656),
    UberLinearOnDraw(0xD587A4E3),
    UberLinearOnDraw(0xFB956876),
    UberLinearOnDraw(0x6E92F78E),
    UberLinearOnDraw(0xFDB5E48B),
    UberLinearOnDraw(0xD5DD013F),
    UberLinearOnDraw(0xC37BC9A9),
    UberLinearOnDraw(0x55CAA7AE),
    UberLinearOnDraw(0x56470D5E),
    UberLinearOnDraw(0x03075C9E),
    UberLinearOnDraw(0x6B6F1A57),
    UberLinearOnDraw(0x659A2E8E),
    UberLinearOnDraw(0xC4210E7C),
    UberLinearOnDraw(0x14DFEA72),
    UberLinearOnDraw(0x3A4565C5),
    UberLinearOnDraw(0x4C68E3B1),
    UberLinearOnDraw(0x4D788167),
    UberLinearOnDraw(0xAD1DCECB),
    UberLinearOnDraw(0x94BD15F2),
    UberLinearOnDraw(0xE48189ED),
    UberLinearOnDraw(0xE715EAC1),
    UberLinearOnDraw(0x29E4578F),
    UberLinearOnDraw(0xC1C66F71),
    UberLinearOnDraw(0x0F969392),
    UberLinearOnDraw(0xB2904AA2),
    UberLinearOnDraw(0xBD82D2DB),
    UberLinearOnDraw(0x40DE2C8B),
    UberLinearOnDraw(0xA0247B8C),
    UberLinearOnDraw(0x3C788F94),
    UberLinearOnDraw(0xD31C4BBF),
    UberLinearOnDraw(0x20D072D9),
    UberLinearOnDraw(0x73B0B517),
    UberLinearOnDraw(0xA0CF8CD2),
    UberLinearOnDraw(0x5242FDB5),
    UberLinearOnDraw(0x5D3FE42F),
    UberLinearOnDraw(0x6259FB49),
    UberLinearOnDraw(0xBD82D2DB),
    UberLinearOnDraw(0x1695FEB2),
    UberLinearOnDraw(0x13EE3146),
    UberLinearOnDraw(0x32A94D85),
    UberLinearOnDraw(0x1F2E8B17),
    UberGammaOnDraw(0x6A501208),
    UberGammaOnDraw(0xE3B6F1F7),
    UberGammaOnDraw(0xA6918C83),
    UberGammaOnDraw(0xB68E535D),
    UberGammaOnDraw(0xAE4C1F32),
    UberGammaOnDraw(0x36C8462C),
    UberGammaOnDraw(0x7BF140C8),
    UberGammaOnDraw(0x6C62EB79),
    UberGammaOnDraw(0x6D14DFE7),
    UberGammaOnDraw(0x743B1716),
    UberGammaOnDraw(0xB8273F73),
    UberGammaOnDraw(0x8D662497),
    UberGammaOnDraw(0x96AF3D66),
    UberGammaOnDraw(0x91F65AEA),
    UberGammaOnDraw(0x7721FCA2),
    UberGammaOnDraw(0x014A40C4),
    UberGammaOnDraw(0xD8E61F5F),
    UberGammaOnDraw(0xDE7ECF75),
    UberGammaOnDraw(0xE4BA540E),
    UberGammaOnDraw(0x1CDF4AD9),
    UberGammaOnDraw(0x1D4D40B0),
    UberGammaOnDraw(0x4A87FC29),
    UberGammaOnDraw(0xFAE40278),
    UberGammaOnDraw(0xFC0CC93E),
    UberGammaOnDraw(0xFEECAC6F),
    UberGammaOnDraw(0x319DDF0E),
    UberGammaOnDraw(0xAE1D9195),
    UberGammaOnDraw(0x9048747B),
    UberGammaOnDraw(0x33D922FC),
    UberGammaOnDraw(0xEC8E7025),
    UberGammaOnDraw(0xFA46C05A),
    UberGammaOnDraw(0x83FD887F),
    UberGammaOnDraw(0x728AA1F4),
    UberGammaOnDraw(0xC494E837),
    UberGammaOnDraw(0xF1A15ADD),
    UberGammaOnDraw(0x3CF9B383),
    UberGammaOnDraw(0x9D87265E),
    UberGammaOnDraw(0x7F8E8E9C),
    UberGammaOnDraw(0x643FA86F),
    UberGammaOnDraw(0x9E3C720E),
    UberGammaOnDraw(0xBF6C7569),
    UberGammaOnDraw(0xB166FD33),
    UberGammaOnDraw(0x5D9AE38B),
    UberGammaOnDraw(0x4712DE01),
    UberGammaOnDraw(0x8DB27254),
    UberGammaOnDraw(0xB9D0A622),
    UberGammaOnDraw(0x31CF94AC),
    UberGammaOnDraw(0xD9D3B706),
    UberGammaOnDraw(0x1F260B38),
    UberGammaOnDraw(0x23D6369B),
    UberGammaOnDraw(0x96DF466B),
    UberGammaOnDraw(0x2DFCB189),
    UberGammaOnDraw(0xD564EE7C),
    UberGammaOnDraw(0x8474AC22),
    UberGammaOnDraw(0x1B97BA95),
    UberGammaOnDraw(0xC1CF9772),
    UberGammaOnDraw(0x80C287F6),
    UberGammaOnDraw(0x4001F368),
    UberGammaOnDraw(0x4B921EFA),
    UberGammaOnDraw(0x2DBE5C71),
    UberGammaOnDraw(0x0AC99FA7),
    UberGammaOnDraw(0x8E8A64BA),
    UberGammaOnDraw(0x53609A70),
    UberGammaOnDraw(0x99D2E489),
    UberGammaOnDraw(0xB2EAED3B),
    UberGammaOnDraw(0x68430C14),
    UberGammaOnDraw(0x681C8D13),
    UberGammaOnDraw(0x1E11059F),
    UberGammaOnDraw(0xEC26FAEC),
    UberGammaOnDraw(0x396CDE5E),
    UberGammaOnDraw(0x0E00166F),
    UberGammaOnDraw(0xF1376E70),
    UberGammaOnDraw(0x74B19CB7),
    UberGammaOnDraw(0x1666FB47),
    UberGammaOnDraw(0x278DE973),
    UberGammaOnDraw(0xB6BE8953),
    UberGammaOnDraw(0x0366BBC6),
    UberGammaOnDraw(0x1ECDAAB2),
    UberGammaOnDraw(0x40CCE791),
    UberGammaOnDraw(0x621C5D59),
    UberGammaOnDraw(0x7301C8FE),
    UberGammaOnDraw(0xB960B2A2),
    UberGammaOnDraw(0x4E2766BA),
    UberGammaOnDraw(0xE168D263),
    UberGammaOnDraw(0xCE3E675F),
    UberGammaOnDraw(0x3B9FD98B),
    UberGammaOnDraw(0x33F3F6CA),
    UberGammaOnDraw(0x104DD7BC),
    UberGammaOnDraw(0x465C678F),
    UberGammaOnDraw(0x0FE4F40F),
    UberGammaOnDraw(0xA60776EB),
    UberGammaOnDraw(0x04553AC1),
    UberGammaOnDraw(0x5B5616C8),
    UberGammaOnDraw(0x8F947DFD),
    UberGammaOnDraw(0xAB1DCA6C),
    UberGammaOnDraw(0xF69ABF2A),
    UberGammaOnDraw(0x08DE4385),
    UberGammaOnDraw(0xDCB65C99),
    UberGammaOnDraw(0x893ACDCC),
    UberGammaOnDraw(0x351CCD43),
        // Neutral
    UberNeutralLinearOnDraw(0x0B383A2F),
    UberNeutralGammaOnDraw(0x0EA73DAA),
    UberNeutralLinearOnDraw(0x01FDB021),
    UberNeutralLinearOnDraw(0x6A5ACB6F),
    UberNeutralLinearOnDraw(0x009A1C24),
    UberNeutralLinearOnDraw(0x9C04ADC2),
    UberNeutralLinearOnDraw(0x36DEAC10),
    UberNeutralLinearOnDraw(0x66C3EBEB),
    UberNeutralLinearOnDraw(0x96A8E4B9),
    UberNeutralLinearOnDraw(0x5217FBA3),
    UberNeutralLinearOnDraw(0x5456BDEE),
    UberNeutralLinearOnDraw(0x7404F723),
    UberNeutralLinearOnDraw(0x8613B876),
    UberNeutralGammaOnDraw(0x179468F9), // no LUT
    UberNeutralLinearOnDraw(0x28721650),
    UberNeutralLinearOnDraw(0xA1AACAEA),
    UberNeutralLinearOnDraw(0xA6C2AA23),
    UberNeutralLinearOnDraw(0xA8F6504E),
    UberNeutralLinearOnDraw(0xAABF3985),
    UberNeutralLinearOnDraw(0xAC471C80),
    UberNeutralLinearOnDraw(0xAD809271),
    UberNeutralLinearOnDraw(0xB68DCF9E),
    UberNeutralLinearOnDraw(0xB1439B81),
    UberNeutralLinearOnDraw(0xB2327C12),
    UberNeutralLinearOnDraw(0xB4966496),
    UberNeutralLinearOnDraw(0xC999597C),
    UberNeutralLinearOnDraw(0xE73E4C20),
    UberNeutralLinearOnDraw(0xE914B17F),
    UberNeutralLinearOnDraw(0xED86C942),
    UberNeutralLinearOnDraw(0xD5C07171),
    UberNeutralLinearOnDraw(0xD72DF71C),
    UberNeutralLinearOnDraw(0xDB50CB2D),
    UberNeutralLinearOnDraw(0xDDF23BBB),
    UberNeutralLinearOnDraw(0xF849180D),
    UberNeutralLinearOnDraw(0x312AE5CE),
    UberNeutralLinearOnDraw(0x4CBE7398),
    UberNeutralLinearOnDraw(0x04D5BD3C),
    UberNeutralLinearOnDraw(0x2CAF46E1),
    UberNeutralLinearOnDraw(0x151F7D68),
    UberNeutralLinearOnDraw(0x215FEC7F),
    UberNeutralLinearOnDraw(0xD0CC8CE2),
    UberNeutralLinearOnDraw(0xD1FDEBCD),
    UberNeutralLinearOnDraw(0xC680A959),
    UberNeutralLinearOnDraw(0x00C855E4),
    UberNeutralLinearOnDraw(0x54CAE2A0),
    UberNeutralLinearOnDraw(0xC06DEF33),
    UberNeutralLinearOnDraw(0x59762D4A),
    UberNeutralLinearOnDraw(0x5F655887),
    UberNeutralGammaOnDraw(0x692D142C),
    UberNeutralGammaOnDraw(0x5C329C6B),
    UberNeutralGammaOnDraw(0xCE6048CA), // no LUT
        // ACES
    UberACESLinearOnDraw(0x1C42C445),
    UberACESGammaOnDraw(0x2B44DD32),
    UberACESLinearOnDraw(0x2C36979C),
    UberACESLinearOnDraw(0x4B92CD8E),
    UberACESLinearOnDraw(0xEF39E7C4),
    UberACESLinearOnDraw(0xFDA8A0F6),
    UberACESLinearOnDraw(0x9A27FDCD),
    UberACESLinearOnDraw(0x9D2A9AD7),
    UberACESLinearOnDraw(0x9F4A9AEC),
    UberACESLinearOnDraw(0x51B31CD0),
    UberACESLinearOnDraw(0x60CD88E9),
    UberACESLinearOnDraw(0x63F63B73),
    UberACESLinearOnDraw(0x65EDD253),
    UberACESLinearOnDraw(0x72D26F35),
    UberACESLinearOnDraw(0x232C3736),
    UberACESLinearOnDraw(0x501CABD3),
    UberACESLinearOnDraw(0x622FF869),
    UberACESLinearOnDraw(0x709B90C7),
    UberACESLinearOnDraw(0x08331DE7),
    UberACESLinearOnDraw(0xA6AFBE57),
    UberACESLinearOnDraw(0xA9329B7F),
    UberACESLinearOnDraw(0xAD251165),
    UberACESLinearOnDraw(0xB4323752),
    UberACESLinearOnDraw(0xBB673EBA),
    UberACESLinearOnDraw(0xC9F897D5),
    UberACESLinearOnDraw(0xC38BA808),
    UberACESLinearOnDraw(0xC593D007),
    UberACESLinearOnDraw(0xCD0AF2B1),
    UberACESLinearOnDraw(0xCD7C2AB8),
    UberACESLinearOnDraw(0xD8C3ADEB),
    UberACESLinearOnDraw(0xE651D798),
    UberACESLinearOnDraw(0xEB8C3409),
    UberACESLinearOnDraw(0x6FEECA44),
    UberACESLinearOnDraw(0x07AF61F8),
    UberACESLinearOnDraw(0x6F7A89B5),
    UberACESLinearOnDraw(0x182FA95D),
    UberACESLinearOnDraw(0x215E5311),
    UberACESLinearOnDraw(0xC01FA28B),
    UberACESLinearOnDraw(0xB28D0124),
    UberACESLinearOnDraw(0x2C0EA618),
    UberACESLinearOnDraw(0x3B30C94A),
    UberACESLinearOnDraw(0x98999C03),
    UberACESLinearOnDraw(0x65D6A1C7),
    UberACESLinearOnDraw(0x3063B396),
    UberACESLinearOnDraw(0x03522F65),
    UberACESLinearOnDraw(0x6345B89E),
    UberACESLinearOnDraw(0x42A50C71),
    UberACESLinearOnDraw(0x49BD568C),
    UberACESLinearOnDraw(0x60B48ADF),
    UberACESLinearOnDraw(0x0DE9EBCF),
    UberACESLinearOnDraw(0x1B8038E6),
    UberACESLinearOnDraw(0x9BF686BC),
    UberACESLinearOnDraw(0xE5C37261),
    UberACESLinearOnDraw(0x7B4E81D3),
    UberACESLinearOnDraw(0x8F6AB88F),
    UberACESLinearOnDraw(0xE1F3EA92),
    UberACESLinearOnDraw(0xDA822A11),
    UberACESLinearOnDraw(0xE9A455B7),
    UberACESLinearOnDraw(0xF949F5A6),
    UberACESLinearOnDraw(0xF92506D6),
    UberACESLinearOnDraw(0xFA5BE462),
    UberACESLinearOnDraw(0xFC440F74),
    UberACESLinearOnDraw(0xBBEE8C39),
    UberACESLinearOnDraw(0xBCD1665D),
    UberACESLinearOnDraw(0x8434F830),
    UberACESLinearOnDraw(0x56DCBA40),
    UberACESLinearOnDraw(0x464C5DC7),
    UberACESLinearOnDraw(0xE5AC38E1),
    UberACESGammaOnDraw(0x230619DF),
    UberACESGammaOnDraw(0x74A3CCC8),
    UberACESGammaOnDraw(0x6695772D),
    UberACESGammaOnDraw(0x822AE84C),
    UberACESLinearOnDraw(0x02985F48),
    UberACESGammaOnDraw(0x03F17B55),
    UberACESGammaOnDraw(0x8516BF4C),
    UberACESLinearOnDraw(0x82804C2E),
    UberACESLinearOnDraw(0xDB1A9E91),
    UberACESGammaOnDraw(0x343E55D9),
    UberACESGammaOnDraw(0x0D96CCBA),
    UberACESLinearOnDraw(0x0D6E178C),
    UberACESLinearOnDraw(0xB01C6167),
        // HD
    UberHDLinearOnDraw(0x0E7B6A15),
    UberHDLinearOnDraw(0x0E883404),
    UberHDLinearOnDraw(0x0EC64D75),
    UberHDLinearOnDraw(0x0D429D27),
    UberHDLinearOnDraw(0x0C271B4A),
    UberHDLinearOnDraw(0xBCC1D592),
    UberHDLinearOnDraw(0x4EBF9C02),
    UberHDGammaOnDraw(0x0F750BE1),
	  UberHDLinearOnDraw(0x0F4188A5),
	  UberHDGammaOnDraw(0x1C581A77),
    UberHDGammaOnDraw(0x1D589C5B),
	  UberHDGammaOnDraw(0x1DE54A2D),
	  UberHDLinearOnDraw(0x1E7FFDBB),
    UberHDLinearOnDraw(0x1E832EAE),
	  UberHDLinearOnDraw(0x1E66576A),
      UberHDLinearOnDraw(0x2B6A08BE),
    UberHDGammaOnDraw(0x2BD1D620),
    UberHDGammaOnDraw(0x2DD1178D),
	  UberHDLinearOnDraw(0x2E10432D),
	  UberHDLinearOnDraw(0x02E86441),
      UberHDLinearOnDraw(0x3E059D01),
    UberHDLinearOnDraw(0x3F8E8017),
	  UberHDLinearOnDraw(0x4B537637),
	  UberHDLinearOnDraw(0x4D2B6B11),
	  UberHDLinearOnDraw(0x4D9C39DC),
	  UberHDLinearOnDraw(0x4DD5AD48),
      UberHDLinearOnDraw(0x4DD5AD48),
	  UberHDLinearOnDraw(0x5A9A3BCA),
	  UberHDGammaOnDraw(0x5A18ED06),
	  UberHDGammaOnDraw(0x5AA3D681),
	  UberHDLinearOnDraw(0x5C913D88),
	  UberHDLinearOnDraw(0x5FFE3248),
	  UberHDGammaOnDraw(0x6B9C2610),
	  UberHDLinearOnDraw(0x6C71F0B5),
	  UberHDLinearOnDraw(0x06D31F1D),
	  UberHDGammaOnDraw(0x6E3B0BB9),
	  UberHDLinearOnDraw(0x6ECE071D),
    UberHDLinearOnDraw(0x7AA25CB8),
    UberHDLinearOnDraw(0x7AB9E205),
    UberHDLinearOnDraw(0x7BF974DA),
	  UberHDLinearOnDraw(0x7CA9D945),
	  UberHDLinearOnDraw(0x07D3D894),
	  UberHDLinearOnDraw(0x7E2F585E),
	  UberHDLinearOnDraw(0x07E6710E),
    UberHDLinearOnDraw(0x7EE888FF),
    UberHDLinearOnDraw(0x7FAFD139),
    UberHDGammaOnDraw(0x8FF6134C),
	  UberHDLinearOnDraw(0x9B813389),
	  UberHDLinearOnDraw(0x9CFC6AFA),
	  UberHDLinearOnDraw(0x9DF20CC3),
	  UberHDLinearOnDraw(0x10D74361),
      UberHDLinearOnDraw(0x12BF2AB6),
	  UberHDLinearOnDraw(0x14AC9B94),
    UberHDLinearOnDraw(0x42B4F952),
    UberHDLinearOnDraw(0x51D248BE),
    UberHDGammaOnDraw(0x56ABE46D),
    UberHDLinearOnDraw(0x057FB6C7),
    UberHDLinearOnDraw(0x65A1E707),
    UberHDLinearOnDraw(0x66ADC764),
	  UberHDLinearOnDraw(0x69FE571B),
	  UberHDLinearOnDraw(0x70F25296),
      UberHDLinearOnDraw(0x71A0CA80),
	  UberHDLinearOnDraw(0x83CC7F92),
	  UberHDLinearOnDraw(0x95B85C10),
	  UberHDLinearOnDraw(0x127B53F7),
    UberHDLinearOnDraw(0x216A76C7),
    UberHDLinearOnDraw(0x262EEB5C),
	  UberHDGammaOnDraw(0x351B1F11),
      UberHDLinearOnDraw(0x389B546B),
	  UberHDLinearOnDraw(0x450C7E5A),
    UberHDLinearOnDraw(0x467F2718),
    UberHDLinearOnDraw(0x495F21AA),
    UberHDLinearOnDraw(0x715ED95A),
	  UberHDLinearOnDraw(0x721D4F40),
	  UberHDLinearOnDraw(0x0733A496),
	  UberHDGammaOnDraw(0x778CFAC9),
    UberHDGammaOnDraw(0x868D8699),
    UberHDLinearOnDraw(0x2450FC89),
	  UberHDLinearOnDraw(0x2781E558),
	  UberHDLinearOnDraw(0x2998DD23),
	  UberHDLinearOnDraw(0x3087C1DD),
	  UberHDLinearOnDraw(0x3655F826),
      UberHDLinearOnDraw(0x3919C7EC),
	  UberHDLinearOnDraw(0x4069CE6C),
	  UberHDLinearOnDraw(0x4233DBE0),
	  UberHDLinearOnDraw(0x5839BFE1),
	  UberHDGammaOnDraw(0x6134CFC2),
	  UberHDLinearOnDraw(0x7213BEF2),
	  UberHDLinearOnDraw(0x8429CE0B),
	  UberHDLinearOnDraw(0x36303D11),
	  UberHDLinearOnDraw(0x038607D0),
	  UberHDLinearOnDraw(0x65113B28),
    UberHDLinearOnDraw(0x84753C8B),
	  UberHDLinearOnDraw(0x134700A7),
    UberHDGammaOnDraw(0x32597878),
    UberHDLinearOnDraw(0x52648650),
    UberHDLinearOnDraw(0xA2A40DEB),
    UberHDGammaOnDraw(0x2229222B),
	  UberHDLinearOnDraw(0xA9DCD389),
	  UberHDLinearOnDraw(0xA42C0E37),
      UberHDLinearOnDraw(0xAA5903B4),
	  UberHDLinearOnDraw(0xADCCB7BB),
	  UberHDLinearOnDraw(0xADFD88AD),
	  UberHDLinearOnDraw(0xAE047DF6),
    UberHDGammaOnDraw(0xAEE6F24B),
    UberHDLinearOnDraw(0xB2C57CC2),
	  UberHDLinearOnDraw(0xB8D14E32),
	  UberHDLinearOnDraw(0xB39F3D8A),
	  UberHDGammaOnDraw(0xB82B9879),
    UberHDLinearOnDraw(0xB86A8EAD),
    UberHDGammaOnDraw(0xB2866BD3),
	  UberHDLinearOnDraw(0xB4780190),
	  UberHDLinearOnDraw(0xB9579276),
	  UberHDGammaOnDraw(0xBD32C87E),
	  UberHDLinearOnDraw(0xBE6E7005),
    UberHDLinearOnDraw(0xBE37E21E),
	  UberHDLinearOnDraw(0xC01E64C3),
	  UberHDLinearOnDraw(0xC5D7F1A1),
      UberHDLinearOnDraw(0xC9A67BB4),
    UberHDLinearOnDraw(0xC9B217F6),
    UberHDLinearOnDraw(0xC36A912D),
	  UberHDLinearOnDraw(0xC1639FBF),
      UberHDLinearOnDraw(0xC7061E2F),
	  UberHDLinearOnDraw(0xC2976820),
      UberHDLinearOnDraw(0xCA9D46B7),
    UberHDLinearOnDraw(0xCBDCEF29),
	  UberHDGammaOnDraw(0xD1E36C9E),
      UberHDLinearOnDraw(0xD3CE0801),
	  UberHDGammaOnDraw(0xD0045A15),
      UberHDLinearOnDraw(0xD457F90B),
	  UberHDLinearOnDraw(0xD4543B6E),
	  UberHDLinearOnDraw(0xD86170D7),
	  UberHDLinearOnDraw(0xE0D21C32),
      UberHDLinearOnDraw(0xE42F2B50),
	  UberHDLinearOnDraw(0xE76D5295),
	  UberHDGammaOnDraw(0xE127B526),
	  UberHDLinearOnDraw(0xE279EC1D),
    UberHDGammaOnDraw(0xEBD11C1A),
	  UberHDGammaOnDraw(0xECD72BE5),
	  UberHDLinearOnDraw(0xF2CB5D37),
	  UberHDLinearOnDraw(0xF5C4F3FE),
	  UberHDLinearOnDraw(0xF9D83ECD),
	  UberHDLinearOnDraw(0xF09D3285),
      UberHDLinearOnDraw(0xFA31E139),
	  UberHDLinearOnDraw(0xFDC03846),
    UberHDLinearOnDraw(0x2B004199),
	  UberHDGammaOnDraw(0x3BB091D1),
    UberHDGammaOnDraw(0x6FC5EBBD),
    UberHDGammaOnDraw(0x21E04E36),
    UberHDGammaOnDraw(0x24A850DA),
    UberHDLinearOnDraw(0x29B597F9),
    UberHDLinearOnDraw(0x34E2CD45),
    UberHDGammaOnDraw(0x4424716A),
    UberHDGammaOnDraw(0xF0DB2F63),
	UberHDLinearOnDraw(0x8C592D8D),
    UberHDLinearOnDraw(0x09012773),
    UberHDLinearOnDraw(0x342E56C7),
    UberHDLinearOnDraw(0xA8A0A101),
    UberHDLinearOnDraw(0x72C37E3A),
    UberHDLinearOnDraw(0x66CCE9A2),
    ////// URP END //////
    ////// CUSTOM START //////
    Builder3OnDraw(0xF9658F60), // SadCatStudios_ColorGradingLut
    Builder1OnDraw(0x6C531A2E), // SadCatStudios_ColorGradingLut
    UberHDLinearOnDraw(0xFF079BBC), // SadCatS
    // tudios_FinalBlit
    UberHDLinearOnDraw(0x99B7B0BF), // SadCatStudios_FinalBlit
    CustomShaderEntryCallback(0x459D4153, &CountLinear),    // Colour Correction
    CustomShaderEntryCallback(0xB0826385, &CountLinear),
    CustomShaderEntryCallback(0x6D550A49, &CountLinear),  // PS1 Post Processing
    CustomShaderEntryCallback(0x3513581C, &Count),
    CustomShaderEntryCallback(0x457A0F57, &Count),
    CustomShaderEntryCallback(0x700A4C32, &Count),    // ShaderGraphs ScreenFxShader
    CustomShaderEntryCallback(0x2D1C3A64, &Count),    // Beat Saber Main effect
    CustomShaderEntryCallback(0xD44C30D0, &Count),    // Beat Saber Main effect
    CustomShaderEntryCallback(0x07FD3D55, &CountGammaTonemap1),   // Neva
    CustomShaderEntryCallback(0xECED3960, &CountTonemap1),    // PostProcess
    CustomShaderEntryCallback(0xE4D51B68, &CountTonemap1),    // PostProcess
    CustomShaderEntryCallback(0xB0E8A766, &CountTonemap1),    // PostProcess
    CustomShaderEntryCallback(0x850F1FE0, &CountTonemap1),    // Unlit Fullscreen Overlay
    //CustomShaderEntry(0x144BC65C),
    CustomShaderEntryCallback(0x4C1E450F, &Count),    // RetroPixelPro
    CustomShaderEntryCallback(0x918C7E0C, &Count),    // ScreenRender
    CustomShaderEntryCallback(0x4C6C9444, &Count),    // Blend MorganTweak
    CustomShaderEntryCallback(0xBD332C3A, &CountLinearTonemap1),   // PostFx GlowComposite
    CustomShaderEntryCallback(0xFDB96CFD, &CountLinearTonemap1),   // Brightness Contrast Gamma
    CustomShaderEntryCallback(0x3E8A6AF2, &CountTonemap1),   // CameraFilterPack 2Lut
    CustomShaderEntryCallback(0x6EA997C7, &CountTonemap1),   // CameraFilterPack 2Lut
    CustomShaderEntryCallback(0x16F8A02E, &Count),   // CameraFilterPack TV Arcade 2
    CustomShaderEntryCallback(0x12F06F96, &CountLinearTonemap1),   // CameraFilterPack Lut Plus
    //CustomShaderEntryCallback(0xB47E4A58, &CountLinear),    // Water Effect
    CustomShaderEntryCallback(0xFE4139AC, &CountLinearTonemap2),    // TLSA
    /*CustomShaderEntry(0xB63D2C4A),
    CustomShaderEntry(0xD665F9CB),*/
    CustomShaderEntryCallback(0x21AB084F, &CountLinearTonemap1),  // Gamma (Republique)
    //CustomShaderEntry(0x5BDBDECE),
    CustomShaderEntryCallback(0x0D0F308B, &CountLinearTonemap2),    // Kyoto PostProcess
    CustomShaderEntryCallback(0x50962AFA, &CountGammaTonemap1),    // EtG gammagamma
    CustomShaderEntryCallback(0xB7AFA999, &CountGammaTonemap1),    // EtG pixelator
    CustomShaderEntryCallback(0xB587B9F9, &CountLinearTonemap3),    // Frame Composite (Wheel World)
    CustomShaderEntryCallback(0x2CD4F51E, &UberACESLinear),    // BT ToneMapping
    CustomShaderEntryCallback(0x60F16875, &UberACESLinear),    // BT ToneMapping
    CustomShaderEntryCallback(0xF143281D, &UberACESLinear),    // BT ToneMapping
    CustomShaderEntryCallback(0xFDD23A9F, &CountGamma),      // Owlcat FinalBlit
    CustomShaderEntryCallback(0x08D3C61F, &CountGamma),      // Owlcat FinalBlit
    CustomShaderEntryCallback(0x7614050A, &CountGamma),      // Owlcat FinalBlit
    CustomShaderEntryCallback(0x082EFBB5, &CountGamma),      // Owlcat FinalBlit
    CustomShaderEntryCallback(0xDCD93B86, &CountGamma),      // Owlcat postfinal
    CustomShaderEntryCallback(0xA9BA06AC, &CountGamma),      // Owlcat postfinal
    CustomShaderEntryCallback(0x837E8B2F, &CountLinear),      // Owlcat FinalBlit
    CustomShaderEntryCallback(0x49FD2384, &CountLinear),      // Owlcat FinalBlit
    CustomShaderEntryCallback(0x6738FBF0, &CountLinear),    // eternal threads
    CustomShaderEntryCallback(0x733AC097, &CountLinear),      // pp tonemap
    CustomShaderEntryCallback(0x2975BCA8, &CountLinear),  // SEB
    CustomShaderEntryCallback(0xF2CD9B88, &CountLinear),  // SEB
    CustomShaderEntryCallback(0xC7DFE6F4, &CountLinear),  // 5Lives Fog of War
    CustomShaderEntryCallback(0xCE4A6EDF, &CountLinearTonemap2),  // ShNecro, no need count
    CustomShaderEntryCallback(0x7A4615AA, &CountLinearTonemap2),  // ShNecro
    CustomShaderEntryCallback(0xF3110A04, &CountGammaTonemap1),    // NOAH Blur
    CustomShaderEntryCallback(0x5DBC623F, &CountGammaTonemap1),    // urpcustom Uberpost
    CustomShaderEntryCallback(0x80C692FC, &CountGammaTonemap1),    // urpcustom Uberpost
    //CustomShaderEntryCallback(0x7A4615AA, &CountLinear),  // ShNecro
    CustomShaderEntryCallback(0xD8341E94, &CountLinearTonemap1Clamped), // RedHook pp LUT
    CustomShaderEntryCallback(0x64031CB8, &CountLinearTonemap1Clamped), // RedHook pp LUT
    CustomShaderEntryCallback(0xD0434E6B, &CountTonemap1), // TintedVignette
    CustomShaderEntryCallback(0x74AAB469, &CountTonemap1),  // Beat Saber
    CustomShaderEntryCallback(0xCEEF2538, &CountClamped), // CRT
    CustomShaderEntryCallback(0xD063498D, &Count), // VolFx Dither
    CustomShaderEntryCallback(0x1772A606, &Count), // VHS
    CustomShaderEntryCallback(0x2B66789E, &CountClamped), // ResolutionPresenterSharpen
    CustomShaderEntryCallback(0x4785A73B, &CountLinearClamped), // PS1PostProcessing
    CustomShaderEntryCallback(0x0B302CFA, &CountClamped), // Endroad Sharpen
    CustomShaderEntryCallback(0x8B223C82, &CountLinearTonemap2),    // Squire tonemap
    CustomShaderEntryCallback(0x90ED3547, &CountTonemap1Clamped),  // TGB ColorGrading3D
    CustomShaderEntryCallback(0xEF459349, [](reshade::api::command_list* cmd_list) {    // ClampShader
    shader_injection.isClamped = 1.f;
    return true;
    }),
    CustomShaderEntryCallback(0x3BB46D74, &CountTonemap1),  // MK Glow SM40
    /*CustomShaderEntry(0x6CA6AD34),  // FinalVisualAdjustments
    CustomShaderEntry(0x3D4B34E8),*/
    //CustomShaderEntry(0x25AD4F0D),
    ////// CUSTOM END //////
    ////// DIVISION START //////
      // Bloom
    CustomShaderEntryCallback(0x5D9A0B26, &CountTonemap1),       // Fast Bloom
    CustomShaderEntryCallback(0x9CE6441F, &CountTonemap1),       // Fast Bloom
    //CustomShaderEntry(0x831FCA18),
    CustomShaderEntryCallback(0xAC07576C, &CountTonemap1),       // SENaturalBloom
    CustomShaderEntryCallback(0x5D511B6E, &CountTonemap1),       // SENaturalBloom
    CustomShaderEntryCallback(0xE9CA44CE, &CountTonemap1Clamped),       // SENaturalBloom
    CustomShaderEntryCallback(0xAEFFC61C, &CountTonemap1),       // Blend for bloom
    CustomShaderEntryCallback(0xB9321BA4, &CountTonemap1),       // Blend for bloom
    CustomShaderEntryCallback(0xBFB24DA6, &CountTonemap1),       // Blend for bloom
    CustomShaderEntryCallback(0xE60F40B0, &CountTonemap1),       // Blend for bloom
    CustomShaderEntryCallback(0xB7ED38A4, &CountTonemap1),       // Blend for bloom
    CustomShaderEntryCallback(0x26E0E961, &CountTonemap1),       // Blend for bloom
    CustomShaderEntryCallback(0xE6CCD6DB, &Count),       // Blend for bloom
    CustomShaderEntryCallback(0x34CE249A, &CountTonemap1Clamped),       // Blend for bloom
    CustomShaderEntryCallback(0xA588D1CD, &CountTonemap1Clamped),       // PostBloomRich
    CustomShaderEntryCallback(0xD7C38DB2, [](reshade::api::command_list* cmd_list) {    // Blend for bloom (build)
    if(shader_injection.isClamped == 0.f){}
    else if(shader_injection.isClamped == 1.f){
      shader_injection.isClamped = 1.5f;
    } else if(shader_injection.isClamped == 1.5f){
      shader_injection.isClamped = 1.f;
    } else {}
    return true;
    }),
    CustomShaderEntryCallback(0xEB56F7CB, [](reshade::api::command_list* cmd_list) {    // Blend for bloom (build)
    if(shader_injection.isClamped == 0.f){}
    else if(shader_injection.isClamped == 1.f){
      shader_injection.isClamped = 1.5f;
    } else if(shader_injection.isClamped == 1.5f){
      shader_injection.isClamped = 1.f;
    } else {}
    return true;
    }),
    CustomShaderEntryCallback(0xBFBBCB6C, &CountTonemap1),    // PostProcessing Bloom
    //CustomShaderEntry(0x7976D6A7),
    //CustomShaderEntry(0x5830BEA5),      // Blend for bloom
    //CustomShaderEntry(0x05A07123),      // XULMREDUX bloom
    //CustomShaderEntryCallback(0xF2636FE5, &CountGamma),
    CustomShaderEntryCallback(0x05A07123, &CountGammaTonemap1), // XULMREDUX bloom
    CustomShaderEntryCallback(0x93DFC667, &CountGammaTonemap1), // XULMREDUX bloom
    //
    CustomShaderEntryCallback(0x0BF02D38, &CountClamped),               // Noise and Grain
    CustomShaderEntryCallback(0xAECBCB31, &CountClamped),               // Noise and Grain
    CustomShaderEntryCallback(0x9954D6B3, &Clamped),               // Noise and Grain
    CustomShaderEntryCallback(0xFFC39101, &CountClamped),               // Noise and Grain
    CustomShaderEntryCallback(0x9591A1F5, &Count),               // Noise Shader RGB
    CustomShaderEntryCallback(0xD3A987FC, &Count),               // Noise Shader RGB
    CustomShaderEntryCallback(0xED7E59E5, &CountTonemap1),               // Image Filter
    CustomShaderEntryCallback(0x29ED5553, &CountLinearTonemap2),               // tonemapper
    CustomShaderEntryCallback(0xB02DE8EC, &Count),               // Gamma Effect
    //CustomShaderEntry(0x1AF93E2F),  // Noise and Grain
    CustomShaderEntryCallback(0xB55175D9, &CountGammaTonemap1),  // Screen Sobel Outline
    CustomShaderEntryCallback(0x2C9E24A9, &Count),          // ColorsBrightness (CameraFilterPack)
    CustomShaderEntryCallback(0x4A979145, &CountLinearTonemap1),       // brightness
    CustomShaderEntryCallback(0xADFFB914, &Count),    // CRT/PostProcess
    CustomShaderEntryCallback(0xEB5B9780, &Count),    // CRT/FinalPostProcess
    CustomShaderEntryCallback(0x33503511, &CountGamma), // crt filter
    CustomShaderEntryCallback(0x81E0C934, &CountTonemap1),  // fxaa3
    CustomShaderEntryCallback(0x2020F088, &CountLinearTonemap2Luminance),  // TonemappingColorGrading
    CustomShaderEntryCallback(0x1F2DBC68, &CountLinearTonemap2Luminance),  // TonemappingColorGrading
    CustomShaderEntryCallback(0xE5A94842, &CountLinearTonemap2Luminance),  // Deluxe TonemapperLuminosityExtended
    CustomShaderEntryCallback(0x208798AE, &CountLinearTonemap1Clamped),  // TonemappingColorGrading
    CustomShaderEntryCallback(0x398D8E38, &CountLinearTonemap35),  // TonemappingColorGrading
    CustomShaderEntryCallback(0xDDF9230F, &CountLinearTonemap35),  // TonemappingColorGrading
    CustomShaderEntryCallback(0x9C3DAA03, &CountLinearTonemap35),  // TonemappingColorGrading
    CustomShaderEntryCallback(0x9EFFF420, &CountGammaTonemap35),  // TonemappingColorGrading
    CustomShaderEntryCallback(0xFE8BBC85, &CountGammaTonemap35),  // TonemappingColorGrading
    CustomShaderEntryCallback(0x9311D7EE, &Count),    // ContrastComposite
    CustomShaderEntryCallback(0xB8B6A6D1, &Count),    // Lens Aberrations (vignette)
    //CustomShaderEntryCallback(0x10D5D9E2, &Count),    // Lens Aberrations (vignette)
    //CustomShaderEntry(0x953D591D),    // Motion Vectors
    CustomShaderEntryCallback(0xCE378E1B, &CountTonemap1),    // ImageEffects RetroFX
    CustomShaderEntryCallback(0x9325D090, &CountTonemap1),          // sunshafts composite
    //CustomShaderEntry(0x103B8DEE),  // SunShaftsComposite
    CustomShaderEntryCallback(0x2D5EAC88, &CountTonemap1),    // SunShaftsComposite
    CustomShaderEntryCallback(0x920023D7, &CountTonemap1),    // SunShaftsComposite
    CustomShaderEntryCallback(0x3F2260DA, &CountTonemap1),    // SunShaftsComposite
    CustomShaderEntryCallback(0xD1C9755F, &CountTonemap1),    // SunShaftsComposite
    CustomShaderEntryCallback(0xD698A33C, &CountTonemap1),    // SunShaftsComposite
    CustomShaderEntryCallback(0x12AF162C, &CountClamped),    // Time of Day GodRays
    CustomShaderEntryCallback(0x0B98227D, &Count),    // Time of Day Scattering
    CustomShaderEntryCallback(0xD3757677, &CountTonemap1),       // Pixelate
    CustomShaderEntryCallback(0xCFF050AD, &CountTonemap1),       // Snapshot Bloom
    CustomShaderEntryCallback(0x3E73EC75, &CountTonemap1),       // Gamma Effect
    CustomShaderEntryCallback(0xC6262486, &CountTonemap1),       // Stylized Fog
    CustomShaderEntryCallback(0x3177F565, &Count),       // Motion Effect
    CustomShaderEntryCallback(0x9B572899, &CountLinearTonemap2),  //PugRP Color Resolve
    //CustomShaderEntryCallback(0xA6AE1DEC, &CountTonemap1),       // Depth Gray Scale
      // Colorful
    CustomShaderEntryCallback(0x7108F19B, &CountTonemap1),       // BCG
    CustomShaderEntryCallback(0xB103EAA6, &Count),       // BCG
    CustomShaderEntryCallback(0xD2FB319D, &Count),    // BCG
    CustomShaderEntryCallback(0x080159F7, &CountLinear),    // LookupFilter3D
    CustomShaderEntryCallback(0xFD95CDDE, &CountTonemap1),       // HSV (maybe gamma ?)
    CustomShaderEntryCallback(0xB2C03C2D, &CountTonemap1),       // Photo Filter
    CustomShaderEntryCallback(0xCFF050AD, &CountTonemap1),       // Photo Filter
    //CustomShaderEntryCallback(0xCD332963, &CountTonemap1),       // Shadows Midtons Highlights
    CustomShaderEntryCallback(0xDDC38AD4, &CountTonemap1),    // Levels
    //CustomShaderEntry(0xDD3C4A2A),
    CustomShaderEntryCallback(0x06A3136A, &CountTonemap1),       // Levels
    CustomShaderEntryCallback(0xCB4380C4, &CountTonemap1),       // Sharpen
    CustomShaderEntryCallback(0x79888BD7, &CountTonemap1),       // Chromatic Aberration
      // CC
    CustomShaderEntryCallback(0x50D362B8, &CountTonemap1),       // Fast Vignette
    CustomShaderEntryCallback(0xDAEBFDF2, &CountGammaTonemap1),  // Lookup Filter (maybe not gamma)
    CustomShaderEntryCallback(0x9D622AC2, &CountTonemap1Clamped),       // Levels
    CustomShaderEntryCallback(0x6A14715D, &CountTonemap1),       // ContrastVignette
    CustomShaderEntryCallback(0x85B7FDE5, &CountTonemap1),       // Sharpen
    CustomShaderEntryCallback(0xC7947A06, &Count),       // Sharpen
    CustomShaderEntryCallback(0xE13B385C, &CountTonemap1),       // Photo Filter
    CustomShaderEntryCallback(0x16ED739A, &Count),               // Analog TV
    // ImageEffects Cinematic
    CustomShaderEntryCallback(0xA4675F12, &Count),       // Bloom
    CustomShaderEntryCallback(0xD0F9D8F0, &Count),       // Bloom
    CustomShaderEntryCallback(0x1693016B, &CountLinear),       // Bloom
    CustomShaderEntryCallback(0x50ADC1A6, &CountGamma),       // Bloom
    // Amplify Color
    CustomShaderEntryCallback(0x01C485EF, &CountLinearClamped),
    CustomShaderEntryCallback(0x8D9A4865, &CountGammaTonemap1Clamped),
    CustomShaderEntryCallback(0x864A0CDA, &CountLinear),
    CustomShaderEntryCallback(0xDF0F14A0, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xF3B603D6, &CountLinear),
    CustomShaderEntryCallback(0x341D49EC, &CountGammaTonemap1Clamped),
    CustomShaderEntryCallback(0x0C2FC484, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x970EA5A1, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0xD70AE6DF, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0xA298CF0E, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0x79DCD887, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0x1C3CDF5D, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0xDC3C3CFB, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0x5B553876, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0x6CB18C43, &CountLinearTonemap2),
    CustomShaderEntryCallback(0x7C3F36C2, &CountLinear),
    CustomShaderEntryCallback(0x97B3FC51, &GammaClamped),
    CustomShaderEntryCallback(0xEEFE9737, &CountGammaTonemap1Clamped),
    CustomShaderEntryCallback(0xB063DC49, &Count),  // Bloom Final
    CustomShaderEntryCallback(0x7D8CC42F, &Count),  // Bloom Final
    CustomShaderEntryCallback(0xF1E9DC64, &CountGammaTonemap1Clamped),  // Depth Mask Blend
    CustomShaderEntryCallback(0xC441EEAD, &CountLinearTonemap2),  // uc2
      // Scion Combination Pass
    CustomShaderEntryCallback(0x0DA28928, &CountTonemap1),
    CustomShaderEntryCallback(0x2E658124, &CountLinearTonemap2),
    CustomShaderEntryCallback(0xEA7AD761, &CountLinearTonemap2),
    CustomShaderEntryCallback(0xEAA69A55, &CountLinearTonemap2),
    CustomShaderEntryCallback(0xC497E04E, &CountLinearTonemap2),
    CustomShaderEntryCallback(0x32EAC77E, &CountLinearTonemap2),
    CustomShaderEntryCallback(0xE7ACEE4B, &CountLinearTonemap2),
    CustomShaderEntryCallback(0xA7D81F41, &CountLinearTonemap2),
    CustomShaderEntryCallback(0x8A6BD876, &CountLinearTonemap2),
    CustomShaderEntryCallback(0x2B178FB4, &CountLinearTonemap2),
    CustomShaderEntryCallback(0x944D0BD3, &CountLinearTonemap2),
    CustomShaderEntryCallback(0x12FB835F, &CountTonemap1),
    CustomShaderEntryCallback(0x638CC010, &CountTonemap1Clamped),
    //CustomShaderEntry(0x73E76C3C),
    CustomShaderEntryCallback(0x5456E1AA, &CountTonemap1),
    CustomShaderEntryCallback(0x956198C2, &CountTonemap1),
    CustomShaderEntryCallback(0xA5B9C43C, &CountTonemap1),
    CustomShaderEntryCallback(0xA206F965, &CountTonemap1),
      // Beautify
    CustomShaderEntryCallback(0x98451591, &CountLinear),
    CustomShaderEntryCallback(0x8B3EF05B, &CountLinearTonemap1),
    CustomShaderEntryCallback(0xCF0602FB, &CountGammaTonemap1),
    CustomShaderEntryCallback(0x1C3A2078, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xA0712B3B, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xA759D5F2, &CountGammaTonemap1),
    CustomShaderEntryCallback(0x2E21732F, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xE9ADE0A5, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xF1C7A343, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xFADC6670, &CountGammaTonemap1),
    CustomShaderEntryCallback(0x446676D2, &CountGammaTonemap1),
    CustomShaderEntryCallback(0x57ED3CED, &CountGammaTonemap1),
    CustomShaderEntryCallback(0xE668E543, &CountGamma),
      // Prism Effects
    CustomShaderEntryCallback(0x1367C2D3, &CountLinearTonemap1Clamped),
    CustomShaderEntryCallback(0x6968824B, &CountLinearTonemap1Clamped),
      // SC Post Effect
    //CustomShaderEntry(0x65F50A96),    // LUT
      // Video Glitches
    CustomShaderEntryCallback(0xE0B71ABA, &CountLinear),  // Broken Screen
    CustomShaderEntryCallback(0x6D9A07CE, &CountLinear),  // something
    CustomShaderEntryCallback(0xD941025F, &CountLinear),  // something
    CustomShaderEntryCallback(0x156A2067, &CountLinear),  // something
    CustomShaderEntryCallback(0x1F2132C7, &CountLinear),  // Spectrum Offset
    ////// DIVISION END //////
    ////// UBER START //////
      /// PostFX ///
        // LUT
    UberPFXLinearOnDraw(0x0E014F53),
    UberPFXLinearOnDraw(0x1A33E5A1),
    UberPFXLinearOnDraw(0x1AF361CB),
    UberPFXGammaOnDraw(0x1D28756B),
    UberPFXGammaOnDraw(0x1E0C52C3),
    UberPFXLinearOnDraw(0x2AE8DF79),
    UberPFXGammaOnDraw(0x2F0122E5),
    UberPFXLinearOnDraw(0x3DA8F050),
    UberPFXLinearOnDraw(0x4E7CC7FC),
    UberPFXLinearOnDraw(0x4EE6BD0C),
    UberPFXLinearOnDraw(0x5C4F96D7),
    UberPFXGammaOnDraw(0x5EC7C557),
    UberPFXLinearOnDraw(0x5EED6FFE),
    UberPFXLinearOnDraw(0x6A5E9052),
    UberPFXLinearOnDraw(0x6EB6CA05),
    UberPFXLinearOnDraw(0x06F08670),
    UberPFXLinearOnDraw(0x6FD9F5E5),
    UberPFXLinearOnDraw(0x7B7C2BA0),
    UberPFXLinearOnDraw(0x7BB0D55E),
    UberPFXGammaOnDraw(0x7CE9A128),
    UberPFXLinearOnDraw(0x7DD56503),
    UberPFXGammaOnDraw(0x7E22BDE5),
    UberPFXLinearOnDraw(0x7E130053),
    UberPFXLinearOnDraw(0x07EBFFF9),
    UberPFXLinearOnDraw(0x7F1AF2FE),
    UberPFXLinearOnDraw(0x8B198D6C),
    UberPFXLinearOnDraw(0x08B287D0),
    UberPFXGammaOnDraw(0x8C89A7D0),
    UberPFXGammaOnDraw(0x8ED83A94),
    UberPFXGammaOnDraw(0x9B557C06),
    UberPFXLinearOnDraw(0x9FDCD9DC),
    UberPFXLinearOnDraw(0x012ED329),
    UberPFXLinearOnDraw(0x16C17744),
    UberPFXGammaOnDraw(0x41FED193),
    UberPFXLinearOnDraw(0x43CD25CE),
    UberPFXLinearOnDraw(0x44B1B227),
    UberPFXGammaOnDraw(0x46AE5D9D),
    UberPFXLinearOnDraw(0x56DF66B4),
    UberPFXGammaOnDraw(0x59A191DD),
    UberPFXLinearOnDraw(0x59FADBF3),
    UberPFXLinearOnDraw(0x76E8C9E0),
    UberPFXGammaOnDraw(0x082D188C),
    UberPFXLinearOnDraw(0x93F0A8E4),
    UberPFXLinearOnDraw(0x99D271BE),
    UberPFXLinearOnDraw(0x100B5477),
    UberPFXGammaOnDraw(0x186D7E4F),
    UberPFXLinearOnDraw(0x291E8F1F),
    UberPFXLinearOnDraw(0x295A7D10),
    UberPFXLinearOnDraw(0x560EE7EC),
    UberPFXLinearOnDraw(0x569EAA5C),
    UberPFXLinearOnDraw(0x585D07A9),
    UberPFXLinearOnDraw(0x702E161F),
    UberPFXLinearOnDraw(0x731E3D80),
    UberPFXGammaOnDraw(0x734AEDAD),
    UberPFXLinearOnDraw(0x752CA615),
    UberPFXLinearOnDraw(0x761CCEC0),
    UberPFXLinearOnDraw(0x803F8E92),
    UberPFXLinearOnDraw(0x825FFF1B),
    UberPFXLinearOnDraw(0x959B3FB7),
    UberPFXLinearOnDraw(0x2938FC01),
    UberPFXLinearOnDraw(0x2987F4C0),
    UberPFXGammaOnDraw(0x5311B657),
    UberPFXLinearOnDraw(0x6420BDE4),
    UberPFXLinearOnDraw(0x6848BE5C),
    UberPFXLinearOnDraw(0x7007E15E),
    UberPFXLinearOnDraw(0x7734F02F),
    UberPFXLinearOnDraw(0x8903C9E4),
    UberPFXLinearOnDraw(0x18001AFA),
    UberPFXLinearOnDraw(0x45068D82),
    UberPFXLinearOnDraw(0x51459A11),
    UberPFXLinearOnDraw(0x52481F8D),
    UberPFXLinearOnDraw(0x96169D7E),
    UberPFXGammaOnDraw(0x851392C2),
    UberPFXGammaOnDraw(0x27388162),
    UberPFXLinearOnDraw(0x31702713),
    UberPFXLinearOnDraw(0x81535823),
    UberPFXLinearOnDraw(0xA5AC1F7D),
    UberPFXGammaOnDraw(0xA9BA96AB),
    UberPFXLinearOnDraw(0xA34CD90A),
    UberPFXLinearOnDraw(0xA79BF32E),
    UberPFXGammaOnDraw(0xA85A414E),
    UberPFXGammaOnDraw(0xA316B6FD),
    UberPFXLinearOnDraw(0xA810454B),
    UberPFXGammaOnDraw(0xAB3D0513),
    UberPFXLinearOnDraw(0xB8F5FE1F),
    UberPFXGammaOnDraw(0xB9A25923),
    UberPFXLinearOnDraw(0xB48DB980),
    UberPFXLinearOnDraw(0xB5617B06),
    UberPFXLinearOnDraw(0xBACB2204),
    UberPFXLinearOnDraw(0xC0C13C33),
    UberPFXLinearOnDraw(0xC3D644A6),
    UberPFXLinearOnDraw(0xC3EA0270),
    UberPFXLinearOnDraw(0xC8CF5A64),
    UberPFXLinearOnDraw(0xC8D99279),
    UberPFXLinearOnDraw(0xC987FCF3),
    UberPFXLinearOnDraw(0xCAB9C0D8),
    UberPFXLinearOnDraw(0xCACDD22E),
    UberPFXLinearOnDraw(0xCDEB8FA1),
    UberPFXLinearOnDraw(0xD2C3B7E9),
    UberPFXLinearOnDraw(0xD26F4D0B),
    UberPFXGammaOnDraw(0xD342B20A),
    UberPFXLinearOnDraw(0xD758B0D4),
    UberPFXLinearOnDraw(0xD7048ECF),
    UberPFXGammaOnDraw(0xE1A21B07),
    UberPFXGammaOnDraw(0xE3FA4292),
    UberPFXLinearOnDraw(0xE9A6F5FA),
    UberPFXGammaOnDraw(0xE42ECD73),
    UberPFXLinearOnDraw(0xE49EE0CB),
    UberPFXLinearOnDraw(0xEA3FB96C),
    UberPFXGammaOnDraw(0xEB9BE1DA),
    UberPFXLinearOnDraw(0xECDC6EC9),
    UberPFXGammaOnDraw(0xEE5CA39C),
    UberPFXLinearOnDraw(0xF1C2CE47),
    UberPFXLinearOnDraw(0xF9B0D779),
    UberPFXLinearOnDraw(0xF24BB452),
    UberPFXLinearOnDraw(0xF45BE267),
    UberPFXLinearOnDraw(0xF627C833),
    UberPFXLinearOnDraw(0xF7099E42),
    UberPFXLinearOnDraw(0xFB3D67A8),
    UberPFXLinearOnDraw(0xFB651628),
    UberPFXLinearOnDraw(0xFBA36CFC),
    UberPFXLinearOnDraw(0xFC2F2508),
    UberPFXLinearOnDraw(0xFDB4A670),
    UberPFXLinearOnDraw(0xFE41EA26),
    UberPFXLinearOnDraw(0xFEC00B8A),
    UberPFXLinearOnDraw(0x01D2D2B8),
        // no LUT
    CountLinearTonemap1ClampedOnDraw(0x0A015C2E),  // maybe dont
    CountGammaTonemap1ClampedOnDraw(0x1B172164),
    CountGammaTonemap1ClampedOnDraw(0x1CAABDB2),
    CountGammaTonemap1ClampedOnDraw(0x1DE983F0),
    CountLinearTonemap1ClampedOnDraw(0x2AA95E6B),
    CountGammaTonemap1ClampedOnDraw(0x03AD1809),
    CountLinearTonemap1ClampedOnDraw(0x4D5D5505),
    CountLinearTonemap1ClampedOnDraw(0x4D8CEA0C),
    CountGammaTonemap1ClampedOnDraw(0x6F0C66BA),
    CountLinearTonemap1ClampedOnDraw(0x7CE8D532),
    CountGammaTonemap1ClampedOnDraw(0x7FA6CC54),
    CountLinearTonemap1ClampedOnDraw(0x8CF8B4BE),
    CountGammaTonemap1ClampedOnDraw(0x8E352C1D),
    CountGammaTonemap1ClampedOnDraw(0x9B2BBC4D),
    CountGammaTonemap1ClampedOnDraw(0x9D5E980F),
    CountGammaTonemap1ClampedOnDraw(0x9F02B611),
    CountLinearTonemap1ClampedOnDraw(0x34E90A30),
    CountGammaTonemap1ClampedOnDraw(0x54DC05DE),
    CountLinearTonemap1ClampedOnDraw(0x73B11B12),
    CountGammaTonemap1ClampedOnDraw(0x76CDAAAC),
    CountLinearTonemap1ClampedOnDraw(0x87CB27C6),
    CountGammaTonemap1ClampedOnDraw(0x153D1995),
    CountGammaTonemap1ClampedOnDraw(0x0616D26C),
    CountGammaTonemap1ClampedOnDraw(0x662E01AB),
    CountLinearTonemap1ClampedOnDraw(0x910F1AF7),
    CountLinearTonemap1ClampedOnDraw(0x915C7D30),
    CountGammaTonemap1ClampedOnDraw(0x2339A919),
    CountLinearTonemap1ClampedOnDraw(0x9031E6E6),
    CountGammaTonemap1ClampedOnDraw(0x84868CA0),
    CountGammaTonemap1ClampedOnDraw(0x363122F4),
    CountGammaTonemap1ClampedOnDraw(0x599066C8),
    CountGammaTonemap1ClampedOnDraw(0x3806037E),
    CountGammaTonemap1ClampedOnDraw(0xAB3A8C76),
    CountGammaTonemap1ClampedOnDraw(0xAE488FB0),
    CountLinearTonemap1ClampedOnDraw(0xB41582C3),
    CountGammaTonemap1ClampedOnDraw(0xBB36315A),
    CountGammaTonemap1ClampedOnDraw(0xBBF7CCB9),
    CountGammaTonemap1ClampedOnDraw(0xC6297BAD),
    CountLinearTonemap1ClampedOnDraw(0xC6971BF6),
    CountLinearTonemap1ClampedOnDraw(0xD73AD73D),
    CountLinearTonemap1ClampedOnDraw(0xD741C111),
    CountLinearTonemap1ClampedOnDraw(0xD8737CC0),
    CountLinearTonemap1ClampedOnDraw(0xD68115B9),
    CountLinearTonemap1ClampedOnDraw(0xDB886B89),
    CountGammaTonemap1ClampedOnDraw(0xDDC88868),
    CountGammaTonemap1ClampedOnDraw(0xF3FC5F05),
    CountLinearTonemap1ClampedOnDraw(0xF84B07BA),
    CountGammaTonemap1ClampedOnDraw(0x5B924DC5),
    CountGammaTonemap1ClampedOnDraw(0xCE0AF0C9),
      /// PP
        // SRGB internal LUT
    UberGammaOnDraw(0x0DA637B5),
    UberLinearOnDraw(0x1B34A194),
    UberLinearOnDraw(0x1C8D5E9F),
    UberLinearOnDraw(0x01C94781),
    UberGammaOnDraw(0x1E7D1A75),
    UberLinearOnDraw(0x2B2B673C),
    UberGammaOnDraw(0x3F4B346E),
    UberGammaOnDraw(0x3F7E2590),
    UberLinearOnDraw(0x4A9DC131),
    UberLinearOnDraw(0x4B0DE7CD),
    UberLinearOnDraw(0x4B3614D0),
    UberLinearOnDraw(0x4FCB780B),
    UberLinearOnDraw(0x5C5C0415),
    UberGammaOnDraw(0x05D7FD3F),
    UberGammaOnDraw(0x5ED6AF8F),
    UberGammaOnDraw(0x6A2FFE0C),
    UberGammaOnDraw(0x6B383D5D),
    UberGammaOnDraw(0x6CEA644C),
    UberLinearOnDraw(0x8CBAADE3),
    UberGammaOnDraw(0x8ED94D63),
    UberGammaOnDraw(0x9C2BCF45),
    UberGammaOnDraw(0x9DC0BD71),
    UberLinearOnDraw(0x9EA7EE21),
    UberGammaOnDraw(0x26D16BD4),
    UberGammaOnDraw(0x28E64619),
    UberGammaOnDraw(0x29B13A00),
    UberLinearOnDraw(0x30C5A882),
    UberGammaOnDraw(0x34A63AC7),
    UberLinearOnDraw(0x47DDAF39),
    UberGammaOnDraw(0x73A5E561),
    UberGammaOnDraw(0x092D4CC5),
    UberLinearOnDraw(0x485D45AC),
    UberGammaOnDraw(0x703FCC89),
    UberGammaOnDraw(0x0731C889),
    UberLinearOnDraw(0x937ECFDB),
    UberLinearOnDraw(0x1082E750),
    UberGammaOnDraw(0x1237D610),
    UberGammaOnDraw(0x3085E401),
    UberGammaOnDraw(0x4546DE90),
    UberGammaOnDraw(0x05004E3A),
    UberGammaOnDraw(0x6409B3A8),
    UberLinearOnDraw(0x6529C56E),
    UberLinearOnDraw(0x8191B510),
    UberGammaOnDraw(0x10579C17),
    UberLinearOnDraw(0x23448FC5),
    UberLinearOnDraw(0x31271C46),
    UberGammaOnDraw(0x38927BBD),
    UberGammaOnDraw(0x42383A0E),
    UberGammaOnDraw(0x97379D6B),
    UberLinearOnDraw(0x206927BB),
    UberLinearOnDraw(0x371438B8),
    UberLinearOnDraw(0x378482BA),
    UberGammaOnDraw(0x15621136),
    UberGammaOnDraw(0x70157207),
    UberGammaOnDraw(0xA21B6CD5),
    UberGammaOnDraw(0xAC23ED8C),
    UberLinearOnDraw(0xB1A3409D),
    UberGammaOnDraw(0xB5D55000),
    UberGammaOnDraw(0xB7AC8C16),
    UberGammaOnDraw(0xB339A072),
    UberGammaOnDraw(0xB811DE51),
    UberGammaOnDraw(0xBB6740C1),
    UberGammaOnDraw(0xBC98901E),
    UberGammaOnDraw(0xC85DC52C),
    UberLinearOnDraw(0xC493FA01),
    UberLinearOnDraw(0xC7503CA9),
    UberLinearOnDraw(0xD92C0A23),
    UberGammaOnDraw(0xDEF5AB02),
    UberLinearOnDraw(0xE002CDC8),
    UberLinearOnDraw(0xE3F4F2E4),
    UberGammaOnDraw(0xE4952B04),
    UberLinearOnDraw(0xE723937A),
    UberLinearOnDraw(0xF8EA7355),
    UberGammaOnDraw(0xF647C7C7),
    UberLinearOnDraw(0xFBF8FE52),
    UberLinearOnDraw(0xFDE5FE89),
    UberGammaOnDraw(0xFE221F8E),
    UberGammaOnDraw(0x24D21B11),
      /// HDR internal LUT ///
        // LUT
    UberHDGammaOnDraw(0x0CA6FA43),
    UberHDLinearOnDraw(0x0D600615),
    UberHDGammaOnDraw(0x1AA327C4),
    UberHDGammaOnDraw(0x01AF86C9),
    UberHDLinearOnDraw(0x1BF2161B),
    UberHDLinearOnDraw(0x1F59543C),
    UberHDLinearOnDraw(0x2E293919),
    UberHDLinearOnDraw(0x2EB942D3),
    UberHDGammaOnDraw(0x2EE0A27B),
    UberHDLinearOnDraw(0x2F17859B),
    UberHDLinearOnDraw(0x03AB4108),
    UberHDOnDraw(0x3BF59C8D),
    UberHDLinearOnDraw(0x3C71577B),
    UberHDGammaOnDraw(0x03CBA401),
    UberHDLinearOnDraw(0x3D7D2ACF),
    UberHDLinearOnDraw(0x4A872453),
    UberHDLinearOnDraw(0x4B3A4726),
    UberHDLinearOnDraw(0x4C89E2E6),
    UberHDLinearOnDraw(0x5D0FF321),
    UberHDLinearOnDraw(0x5FCCEC0F),
    UberHDLinearOnDraw(0x6BE60185),
    UberHDGammaOnDraw(0x06C7255C),
    UberHDLinearOnDraw(0x6D14F22A),
    UberHDGammaOnDraw(0x06EEEE16),
    UberHDGammaOnDraw(0x6F30CACB),
    UberHDLinearOnDraw(0x7C7A90FB),
    UberHDLinearOnDraw(0x7E2A04D8),
    UberHDGammaOnDraw(0x7FE85B88),
    UberHDLinearOnDraw(0x8B00D455),
    UberHDGammaOnDraw(0x8C10BEAF),
    UberHDLinearOnDraw(0x8C673209),
    UberHDLinearOnDraw(0x8E8030DA),
    UberHDGammaOnDraw(0x8F0A4568),
    UberHDLinearOnDraw(0x9A32E38C),
    UberHDLinearOnDraw(0x9BC48214),
    UberHDLinearOnDraw(0x9C62C0D7),
    UberHDLinearOnDraw(0x9CB51433),
    UberHDLinearOnDraw(0x9CC447BF),
    UberHDLinearOnDraw(0x9DBEB2FA),
    UberHDLinearOnDraw(0x9DD6F785),
    UberHDLinearOnDraw(0x9F35FFF7),
    UberHDGammaOnDraw(0x10A31D94),
    UberHDLinearOnDraw(0x13E3E9C2),
    UberHDLinearOnDraw(0x18DC6A24),
    UberHDLinearOnDraw(0x19B5C9D3),
    UberHDGammaOnDraw(0x30B1D393),
    UberHDGammaOnDraw(0x30E315A6),
    UberHDLinearOnDraw(0x32AFF662),
    UberHDGammaOnDraw(0x32B27DC5),
    UberHDLinearOnDraw(0x37EE06EC),
    UberHDLinearOnDraw(0x41CA1DD6),
    UberHDGammaOnDraw(0x42D5A5B2),
    UberHDLinearOnDraw(0x45B1DBE4),
    UberHDLinearOnDraw(0x46D3ECE8),
    UberHDGammaOnDraw(0x58F9D31B),
    UberHDGammaOnDraw(0x60B79FE3),
    UberHDLinearOnDraw(0x63D93240),
    UberHDLinearOnDraw(0x69C7EC21),
    UberHDLinearOnDraw(0x71F55427),
    UberHDGammaOnDraw(0x78EF9B01),
    UberHDLinearOnDraw(0x79C0F979),
    UberHDLinearOnDraw(0x82AF3065),
    UberHDGammaOnDraw(0x82FF3964),
    UberHDLinearOnDraw(0x085B95F5),
    UberHDLinearOnDraw(0x86D12314),
    UberHDLinearOnDraw(0x86E67F52),
    UberHDGammaOnDraw(0x0105BFBA),
    UberHDLinearOnDraw(0x116ED5A6),
    UberHDLinearOnDraw(0x123EB0AB),
    UberHDGammaOnDraw(0x164B94AF),
    UberHDGammaOnDraw(0x177B85BE),
    UberHDLinearOnDraw(0x272EB112),
    UberHDLinearOnDraw(0x404CC9B9),
    UberHDLinearOnDraw(0x440F1911),
    UberHDGammaOnDraw(0x478DF3D8),
    UberHDLinearOnDraw(0x505A6061),
    UberHDLinearOnDraw(0x599DC26E),
    UberHDLinearOnDraw(0x609D706C),
    UberHDOnDraw(0x664C7B0C),
    UberHDLinearOnDraw(0x666FB3A8),
    UberHDLinearOnDraw(0x691CF2FB),
    UberHDLinearOnDraw(0x728A5929),
    UberHDLinearOnDraw(0x783ABD54),
    UberHDLinearOnDraw(0x808BC2A2),
    UberHDGammaOnDraw(0x821B9FB1),
    UberHDGammaOnDraw(0x869CB3F0),
    UberHDLinearOnDraw(0x916E68A2),
    UberHDLinearOnDraw(0x957EC72A),
    UberHDLinearOnDraw(0x995B36D9),
    UberHDLinearOnDraw(0x1666C38C),
    UberHDLinearOnDraw(0x2258B26B),
    UberHDLinearOnDraw(0x2706BB7A),
    UberHDLinearOnDraw(0x3675BEA9),
    UberHDLinearOnDraw(0x5032F099),
    UberHDGammaOnDraw(0x5616E459),
    UberHDOnDraw(0x6073A121),
    UberHDGammaOnDraw(0x7209AC65),
    UberHDLinearOnDraw(0x7910DC27),
    UberHDLinearOnDraw(0x8135A20B),
    UberHDGammaOnDraw(0x9326C2CF),
    UberHDLinearOnDraw(0x9861B876),
    UberHDGammaOnDraw(0x15032A70),
    UberHDLinearOnDraw(0x17771A6C),
    UberHDLinearOnDraw(0x43621B25),
    UberHDLinearOnDraw(0x52401FF0),
    UberHDLinearOnDraw(0x063470DC),
    UberHDGammaOnDraw(0x80309D55),
    UberHDGammaOnDraw(0x80912E62),
    UberHDLinearOnDraw(0x81198D61),
    UberHDLinearOnDraw(0x98834C99),
    UberHDLinearOnDraw(0x99257EBF),
    UberHDLinearOnDraw(0x99273E5D),
    UberHDLinearOnDraw(0x18486417),
    UberHDGammaOnDraw(0x86692346),
    UberHDGammaOnDraw(0xA1B5810B),
    UberHDLinearOnDraw(0xA2FE36C0),
    UberHDLinearOnDraw(0xA04D746C),
    UberHDLinearOnDraw(0xA31D6E8F),
    UberHDLinearOnDraw(0xA46C1ECB),
    UberHDLinearOnDraw(0xA66D3ADA),
    UberHDLinearOnDraw(0xA885A390),
    UberHDGammaOnDraw(0xA932CAC7),
    UberHDLinearOnDraw(0xA9229E77),
    UberHDLinearOnDraw(0xA34705B5),
    UberHDGammaOnDraw(0xAA43A92F),
    UberHDLinearOnDraw(0xAB9BAF73),
    UberHDOnDraw(0xABB348D3),
    UberHDLinearOnDraw(0xABD0CDAB),
    UberHDLinearOnDraw(0xAF565E99),
    UberHDLinearOnDraw(0xAFBE175C),
    UberHDGammaOnDraw(0xB4FCC459),
    UberHDLinearOnDraw(0xB05DD1FC),
    UberHDLinearOnDraw(0xB94F0EC5),
    UberHDLinearOnDraw(0xB8308863),
    UberHDLinearOnDraw(0xBCA28AB5),
    UberHDLinearOnDraw(0xBD3E0603),
    UberHDLinearOnDraw(0xBE55DA79),
    UberHDLinearOnDraw(0xBE655D3E),
    UberHDGammaOnDraw(0xBEDE7F5E),
    UberHDLinearOnDraw(0xC1D1E672),
    UberHDGammaOnDraw(0xC3DC274E),
    UberHDLinearOnDraw(0xC05FCCFB),
    UberHDGammaOnDraw(0xC8C2F1A0),
    UberHDLinearOnDraw(0xC13DFB36),
    UberHDLinearOnDraw(0xC63B24BB),
    UberHDLinearOnDraw(0xC77C6136),
    UberHDLinearOnDraw(0xC783A02A),
    UberHDLinearOnDraw(0xC7555B4A),
    UberHDLinearOnDraw(0xC59328DA),
    UberHDLinearOnDraw(0xCF7B19D4),
    UberHDLinearOnDraw(0xCFEEF3DE),
    UberHDGammaOnDraw(0xD0CC549E),
    UberHDGammaOnDraw(0xD3EB3C80),
    UberHDLinearOnDraw(0xD6B24AEB),
    UberHDLinearOnDraw(0xD11EBDA2),
    UberHDGammaOnDraw(0xD32FF805),
    UberHDLinearOnDraw(0xD3985CC4),
    UberHDLinearOnDraw(0xD213345E),
    UberHDLinearOnDraw(0xD924189F),
    UberHDLinearOnDraw(0xDA13BFBD),
    UberHDLinearOnDraw(0xDB814E6C),
    UberHDLinearOnDraw(0xDCAD3BF2),
    UberHDGammaOnDraw(0xDF21D66E),
    UberHDLinearOnDraw(0xDFF706F5),
    UberHDLinearOnDraw(0xE0E4140C),
    UberHDLinearOnDraw(0xE3C1F14A),
    UberHDLinearOnDraw(0xE46F9DE9),
    UberHDLinearOnDraw(0xE81BC431),
    UberHDLinearOnDraw(0xE5994A4B),
    UberHDLinearOnDraw(0xE9243462),
    UberHDGammaOnDraw(0xEB0157F3),
    UberHDLinearOnDraw(0xEB594928),
    UberHDGammaOnDraw(0xEC929462),
    UberHDLinearOnDraw(0xECD0DFE1),
    UberHDLinearOnDraw(0xEF7C8F91),
    UberHDGammaOnDraw(0xF4E5CCA5),
    UberHDGammaOnDraw(0xF5E818A0),
    UberHDLinearOnDraw(0xF47A06A5),
    UberHDLinearOnDraw(0xF455EE3C),
    UberHDLinearOnDraw(0xFA2F9A68),
    UberHDLinearOnDraw(0xFC0ECCE8),
    UberHDLinearOnDraw(0xFF4E4EF2),
    UberHDLinearOnDraw(0x41B1FF38),
    UberHDLinearOnDraw(0x71A4E35E),
    UberHDLinearOnDraw(0xD25C43B1),
        // No LUT
    CustomShaderEntryCallback(0xA1EA3B3E, &Gamma),
    CountGammaTonemap1OnDraw(0x3E60912E),
    CountGammaTonemap1OnDraw(0x4CEC1E87),
    CountLinearTonemap1OnDraw(0x5C428D81),
    CountLinearTonemap1OnDraw(0x6DD82EF0),
    CountLinearTonemap1OnDraw(0x9DA6D2DA),
    CountLinearTonemap1OnDraw(0x9E21F0DF),
    CountGammaTonemap1OnDraw(0x53DF7115),
    CountGammaTonemap1OnDraw(0x56C90ED5),
    CountGammaTonemap1OnDraw(0x70B49FD5),
    CountGammaTonemap1OnDraw(0x70EEA44B),
    CountLinearTonemap1OnDraw(0x83B430B4),
    CountGammaTonemap1OnDraw(0x83F6DE09),
    CountLinearTonemap1OnDraw(0x92C3775F),
    // 0x2365EDDF
    CountLinearTonemap1OnDraw(0x4757CDEB),
    CountGammaTonemap1OnDraw(0x6946B0AB),
    CountLinearTonemap1OnDraw(0x93281DC0),
    CountLinearTonemap1OnDraw(0x455563C6),
    CountGammaTonemap1OnDraw(0x79295705),
    // 0xA1EA3B3E
    CountLinearTonemap1OnDraw(0xA8773EA9),
    CountLinearTonemap1OnDraw(0xB47EF759),
    CountLinearTonemap1OnDraw(0xBA534ADB),
    CountGammaTonemap1OnDraw(0xBFCFF9BC),
    CountGammaTonemap1OnDraw(0xC7B8A4A1),
    CountLinearTonemap1OnDraw(0xC25C244C),
    CountGammaTonemap1OnDraw(0xD12C9D2F),
    CountGammaTonemap1OnDraw(0xD633A7EE),
    CountGammaTonemap1OnDraw(0xE832FE2B),
    CountGammaTonemap1OnDraw(0xE9177A14),
    CountGammaTonemap1OnDraw(0xEAD9C39B),
    CountLinearTonemap1OnDraw(0xEBC7375B),
    CountGammaTonemap1OnDraw(0xEBE0CEAA),
    CountGammaTonemap1OnDraw(0xED61F24A),
    CountGammaTonemap1OnDraw(0xF25F3D34),
    CountGammaTonemap1OnDraw(0xF89DA645),
    CountLinearTonemap1OnDraw(0xF95C788E),
    CountGammaTonemap1OnDraw(0xFF444EF2),
    CountGammaTonemap1OnDraw(0xF180FFF6),
    CountGammaTonemap1OnDraw(0x34A4537A),
        // Sapphire
    CountLinearACES709OnDraw(0x2B0930CC),
    CountLinearACES709OnDraw(0x8D4D9A63),
    CountLinearACES709OnDraw(0x8DF1BF80),
    CountLinearACES709OnDraw(0x14A5B821),
    CountLinearACES709OnDraw(0x15E132D9),
    CountLinearACES709OnDraw(0x171A0A90),
    CountLinearACES709OnDraw(0x85653627),
    CountLinearACES709OnDraw(0xAE663C8F),
    CountLinearACES709OnDraw(0xBA4DCC6E),
    CountLinearACES709OnDraw(0xE01E2588),
        // HoF
    CountLinearACES709OnDraw(0x88B63A53),
    CountLinearACES709OnDraw(0x72285EF2),
    CountLinearACES709OnDraw(0xA98C7CAA),
    CountLinearACES709OnDraw(0xC680CDDE),
    CountLinearACES709OnDraw(0xE94F0830),
    /*CountLinearACES709OnDraw(0x7E70DA8D),
    CountLinearACES709OnDraw(0x9F77F2C9),
    CountLinearACES709OnDraw(0x32C33FE2),
    CountLinearACES709OnDraw(0x69D09E7E),
    CountLinearACES709OnDraw(0x75C4E8F2),
    CountLinearACES709OnDraw(0x0121EB5A),
    CountLinearACES709OnDraw(0x2133A066),
    CountLinearACES709OnDraw(0xA0E6F747),
    CountLinearACES709OnDraw(0xA98C7CAA),
    CountLinearACES709OnDraw(0xAB54902E),
    CountLinearACES709OnDraw(0xAED0ED65),
    CountLinearACES709OnDraw(0xF4D5896D),*/
      // Chromatic Aberration
    CountTonemap1OnDraw(0xEEE589B3),
    CountTonemap1OnDraw(0x937A4C13),
    CountTonemap1OnDraw(0x3F6031DA),
    CountTonemap1OnDraw(0x0E6D86E9),
    CountTonemap1OnDraw(0x0FE990F5),
    CountTonemap1OnDraw(0x0343CDEF),
    CountTonemap1OnDraw(0xEA78C466),
      // Vignetting
    CountTonemap1OnDraw(0x1BA9B943),
    CountTonemap1OnDraw(0x23E39077),
    CountTonemap1OnDraw(0x28A6A0C0),
    CountTonemap1OnDraw(0x35E7772D),
    CountTonemap1OnDraw(0x88608A73),
    CountTonemap1OnDraw(0x85285389),
    CountTonemap1OnDraw(0x8A9A33D9),
    CountTonemap1OnDraw(0xB1186381),
    CountTonemap1OnDraw(0xEE465E2D),
      // Color Correction
    CustomShaderEntryCallback(0x488FE86B, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x116B98EA, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x5E9BB86D, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x1EFD76DD, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x13345F57, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x046341CB, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x04AB98F4, &CountTonemap1Clamped),
    CustomShaderEntryCallback(0x9B1835E7, &CountTonemap1Clamped),       // Curves
    CustomShaderEntryCallback(0x481EBC17, &CountTonemap1Clamped),       // Curves
    CustomShaderEntryCallback(0x775F62CB, &CountTonemap1Clamped),       // Effect
    CustomShaderEntryCallback(0x4F6C23CE, &CountTonemap1Clamped),       // LUT
    CustomShaderEntryCallback(0x7FDF2753, &CountTonemap1Clamped),       // 3d LUT
    CustomShaderEntryCallback(0xCCF1CAE8, &CountTonemap1Clamped),       // 3d LUT
    CustomShaderEntryCallback(0x7EA242C9, &CountLinearTonemap1Clamped),       // 3d LUT
        // Neutral
    CustomShaderEntryCallback(0x794570B1, &CountLinearTonemap2),  // Unlit Composite
        // Beautify
    CustomShaderEntryCallback(0xECBDB4D4, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xBF6B8004, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x33BF2974, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x55A62D93, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x7CEC71DC, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xBFB6E777, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xBD2444A7, &CountLinearTonemap35),
    //CustomShaderEntryCallback(0xB046A9EB, &CountLinearTonemap35),
    //CustomShaderEntryCallback(0x4483E5EF, &CountLinearTonemap35),
    //CustomShaderEntryCallback(0x18174CED, &CountLinearTonemap35),
    //CustomShaderEntryCallback(0x833594DC, &CountLinearTonemap35),
    //CustomShaderEntryCallback(0xC224A268, &CountLinearTonemap35),
    //CustomShaderEntryCallback(0xCD56DC9B, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x2E1F9ED4, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x107ACDC1, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xC25D14FB, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x59FA5E75, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xA9146B0D, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xEB8FE10D, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xF2C3C778, &CountLinearTonemap35),
    CustomShaderEntryCallback(0x8EFD32D4, &CountLinearTonemap35),
    CustomShaderEntryCallback(0xD70BBE87, &CountLinearTonemap3),
    CustomShaderEntryCallback(0xBCBEAF16, &CountLinearTonemap3),
    CustomShaderEntryCallback(0xA9F01758, &CountLinearTonemap3),
      // Final Pass
    CustomShaderEntryCallback(0x75838EB7, &CountLinear),
    CustomShaderEntryCallback(0xC7216130, &CountLinear),
    ////// PP END //////
    ////// POSTFINAL START //////
      // 
    CustomShaderEntryCallback(0x1EF2268F, &CountLinear),  
    CustomShaderEntryCallback(0x366EE13E, &CountLinear),
    CustomShaderEntryCallback(0x9D4EE658, &CountLinear),
    CustomShaderEntryCallback(0xC3D75217, &CountLinear),
    CustomShaderEntryCallback(0xD8CBEF60, &CountLinear),
    CustomShaderEntryCallback(0xC8194FF2, &CountLinear),
    CustomShaderEntryCallback(0x5D490E8A, &CountLinear),
    CustomShaderEntryCallback(0x3715DB93, &CountLinear),
    CustomShaderEntryCallback(0x1EE4CF1C, &CountLinear),
    CustomShaderEntryCallback(0xD90A4513, &CountGamma),
    CustomShaderEntryCallback(0x780BC110, &CountGamma),
    CustomShaderEntryCallback(0x685DF333, &CountLinear),
    CustomShaderEntryCallback(0x80C53B73, &CountLinear),
    CustomShaderEntryCallback(0xAEE78EFC, &CountGamma),      // BlitSpace
    CustomShaderEntryCallback(0xFD37FE01, &CountGamma),      // BlitSpace
    CustomShaderEntryCallback(0x4AF45563, &CountLinear),      // BlitSpace
    CustomShaderEntryCallback(0xB1CE8C1C, &CountLinear),
    CustomShaderEntryCallback(0x1BD93430, &CountLinear),
    CustomShaderEntryCallback(0xE819EC01, &CountLinear),
      // FXAA
    CustomShaderEntryCallback(0x0D7738C5, &CountLinear),
    CustomShaderEntryCallback(0x3E0783E6, &Count),
    CustomShaderEntryCallback(0x0175C0E5, &CountLinear),
    CustomShaderEntryCallback(0x5CC458E2, &Count),
    CustomShaderEntryCallback(0x623A834B, &CountLinear),
    CustomShaderEntryCallback(0x83775429, &CountLinear),
    CustomShaderEntryCallback(0xA95311EA, &CountLinear),
    CustomShaderEntryCallback(0xABF2B519, &CountLinear),
    CustomShaderEntryCallback(0xB2E77E10, &CountLinear),
    CustomShaderEntryCallback(0xCC8B6ACF, &CountLinear),
    CustomShaderEntryCallback(0xD00B5B47, &Count),
    CustomShaderEntryCallback(0xDCD2C9A2, &CountLinear),
    CustomShaderEntryCallback(0xE6835798, &Count),
    CustomShaderEntryCallback(0x0D8F51E1, &CountLinear),
    CustomShaderEntryCallback(0x0D090F81, &CountLinear),
    CustomShaderEntryCallback(0xEFA7823D, &CountLinear),
    CustomShaderEntryCallback(0xA978F0C8, &Count),
    CustomShaderEntryCallback(0xD19EDE35, &Count),
    CustomShaderEntryCallback(0xF8281A99, &Count),
    CustomShaderEntryCallback(0xAF2362F1, &Count),
      // postFX AA
    CustomShaderEntryCallback(0x0366C4CE, &CountLinear),
    CustomShaderEntryCallback(0xF4CA60E0, &CountLinear),
    CustomShaderEntryCallback(0x53E384E8, &Count),
    CustomShaderEntryCallback(0x6C84328D, &CountLinear),
    CustomShaderEntryCallback(0x22216D01, &Count),
    CustomShaderEntryCallback(0x8C0BCB63, &Count),
    CustomShaderEntryCallback(0xA52F70F8, &Count),
    CustomShaderEntryCallback(0x9E60BC82, &CountTonemap1),
    CustomShaderEntryCallback(0xB13A3CBB, &CountLinear),
    CustomShaderEntryCallback(0xB8B233F1, &CountLinear),
      // Unknown space
    CustomShaderEntryCallback(0x9E4CBF41, &Count),
    CustomShaderEntryCallback(0x4528B1BE, &Count),
    CustomShaderEntryCallback(0xA559F61E, &Count),
      // rcas
    CustomShaderEntryCallback(0x7CEF5F47, &CountLinear),
    CustomShaderEntryCallback(0x7DD6578D, &CountLinear),
    CustomShaderEntryCallback(0x7E3B8386, &Count),    // (LBA TQ)
    CustomShaderEntryCallback(0x08B68C4E, &CountLinear),
    CustomShaderEntryCallback(0x72E35D2A, &CountLinear),
    CustomShaderEntryCallback(0x1609F94E, &CountLinear),
    CustomShaderEntryCallback(0xE96B977C, &CountLinear),
    CustomShaderEntryCallback(0xB1DF8B20, &CountLinear),
    CustomShaderEntryCallback(0x1F20DEB9, &Count),
    CustomShaderEntryCallback(0x1F20DEB9, &Count),
    CustomShaderEntryCallback(0x0D4651C9, &CountLinear),      // gamesfarm postfx
    CustomShaderEntryCallback(0x0299214E, &CountLinear),      // gamesfarm postfx
    CustomShaderEntryCallback(0x244A72BB, &CountLinear),      // gamesfarm postfx
    CustomShaderEntryCallback(0x244A72BB, &CountGammaClamped),      // postfx grain
    //Fsr1NoReplace(0xFC718347),    // EASU (LBA)
    CustomShaderEntryCallback(0xC32E5F94, &Count),    // HxVolumetricApply
    ////// POSTFINAL END    //////
    ////// LUTBUILDER START //////
      /// 2D Baker ///
    Builder1OnDraw(0x6BA3776A),
    Builder1OnDraw(0x67A66D2D),
    Builder1OnDraw(0xDE54BEC4),  // TLD merger
        // user LUT
    Builder1OnDraw(0x425A05B0),
    Builder1OnDraw(0x7EAF565D),
    Builder1OnDraw(0xA7199AE8),
        // Neutral
    Builder2OnDraw(0x93CAF565),
        // ACES
    Builder3OnDraw(0x4E674C6E),
      /// 3D Baker ///
        // No Tonemap
    Builder1OnDraw(0x34EF56B6),
    Builder1OnDraw(0x995B320A),
    Builder1OnDraw(0x96DE38F9),
        // Neutral
    Builder2OnDraw(0xBE750C14),
    Builder2OnDraw(0xC0683CB5),
    Builder2OnDraw(0xB79884AA),
    Builder2OnDraw(0xFF0BEDB7),
        // ACES
    Builder3OnDraw(0x0D6DE82C),
    Builder3OnDraw(0x5B6D435F),
    Builder3OnDraw(0x6EA48EC8),
    Builder3OnDraw(0x47A1239F),
    Builder3OnDraw(0xD58102C7),
    Builder3OnDraw(0xB80155E4),
        // Custom
    Builder2OnDraw(0x9192FB27),
      /// Post Fx Lut Generator ///
        // No Tonemap
    SneakyBuilder1OnDraw(0x30261E46),
    SneakyBuilder1OnDraw(0x38B119B1),
    SneakyBuilder1OnDraw(0x09E8D72B),
        // Neutral (variable parameters)
    SneakyBuilder2OnDraw(0x6A8BFC0E),
    SneakyBuilder2OnDraw(0x3F73DF46),
    SneakyBuilder2OnDraw(0xFE6C02F9),
        // ACES
    SneakyBuilder3OnDraw(0xF70A0EED),
    SneakyBuilder3OnDraw(0x33891579),
    SneakyBuilder3OnDraw(0x65D3755B),
    SneakyBuilder3OnDraw(0x56B8D689),
    SneakyBuilder3OnDraw(0xAA3605C8),
    //__ALL_CUSTOM_SHADERS,
    BlitCopyOnDraw(0x8674BE1F),
    BlitCopyOnDraw(0x49E25D6C),
    BlitCopyOnDraw(0x1FDE7AD7),
    BlitCopyOnDraw(0xC605BA2F),
    CustomShaderEntryCallback(0x20133A8B, [](reshade::api::command_list* cmd_list) {
    finalBlitCheck = renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list);
    return renodx::utils::swapchain::HasBackBufferRenderTarget(cmd_list);
    }),
    // LIS BtS Remaster
    UpgradeRTVShader(0xD1DBB0E2), // FXAA
    UpgradeRTVShader(0x3F2260DA), // Sunshafts Composite
    UpgradeRTVShader(0x82ABB5A1), // Sunshafts Composite
    UpgradeRTVShader(0x71A08591), // PostFX DoF
    //CustomSwapchainShader(0x20133A8B),
};

const ShaderItem OTHER_SHADERS[] = {
    __ALL_CUSTOM_SHADERS};

static std::once_flag g_build_shaders_once;

void MergeShaders() {
  std::call_once(g_build_shaders_once, [] {
    custom_shaders.reserve(std::size(OTHER_SHADERS) + std::size(INITIAL_SHADERS));

    // Register initial shaders first
    for (const auto& kv : INITIAL_SHADERS) {
      custom_shaders.try_emplace(kv.val.crc32, kv.val);
    }

    for (const auto& kv : OTHER_SHADERS) {
      custom_shaders.try_emplace(kv.val.crc32, kv.val);
    }
  });
}

float current_settings_mode = 0;
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .tint = 0xDB9D47,
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapType",
        .binding = &shader_injection.toneMapType,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "Frostbite", "RenoDRT (Hermite Spline)", "DICE"},
        .tint = 0x38F6FC,
        .is_visible = []() { return settings[0]->GetValue() >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPeakNits",
        .binding = &shader_injection.toneMapPeakNits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .tint = 0x38F6FC,
        .min = 48.f,
        .max = 10000.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
        .is_logarithmic = true,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGameNits",
        .binding = &shader_injection.toneMapGameNits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .tint = 0x38F6FC,
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapUINits",
        .binding = &shader_injection.toneMapUINits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .tint = 0x38F6FC,
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapGammaCorrection",
        .binding = &shader_injection.toneMapGammaCorrection,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "SDR EOTF Emulation",
        .section = "Tone Mapping",
        .tooltip = "Emulates output decoding used on SDR displays.",
        .labels = {"Off", "2.2", "BT.1886"},
        .tint = 0x38F6FC,
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapPerChannel",
        .binding = &shader_injection.toneMapPerChannel,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .tint = 0x38F6FC,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapColorSpace",
        .binding = &shader_injection.toneMapColorSpace,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .tint = 0x38F6FC,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tonemapCheck == 3.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueProcessor",
        .binding = &shader_injection.toneMapHueProcessor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .labels = {"OKLab", "ICtCp", "darktable UCS"},
        .tint = 0x38F6FC,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueShift",
        .binding = &shader_injection.toneMapHueShift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .tint = 0x38F6FC,
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 3.f && shader_injection.toneMapPerChannel == 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapHueCorrection",
        .binding = &shader_injection.toneMapHueCorrection,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tint = 0x38F6FC,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "toneMapShoulderStart",
        .binding = &shader_injection.toneMapShoulderStart,
        .default_value = 1.f,
        .label = "Rolloff/Shoulder Start",
        .section = "Tone Mapping",
        .tint = 0x38F6FC,
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return (shader_injection.toneMapType == 2.f || shader_injection.toneMapType == 4.f) && (abs(shader_injection.tonemapCheck) == 1.f); },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeExposure",
        .binding = &shader_injection.colorGradeExposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeHighlights",
        .binding = &shader_injection.colorGradeHighlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeShadows",
        .binding = &shader_injection.colorGradeShadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >=1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeContrast",
        .binding = &shader_injection.colorGradeContrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeSaturation",
        .binding = &shader_injection.colorGradeSaturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeBlowout",
        .binding = &shader_injection.colorGradeBlowout,
        .default_value = 50.f,
        .label = "Highlights Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlights color.",
        .tint = 0x452F7A,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeDechroma",
        .binding = &shader_injection.colorGradeDechroma,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .tint = 0x452F7A,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType >= 2.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeFlare",
        .binding = &shader_injection.colorGradeFlare,
        .default_value = 25.f,
        .label = "Flare",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeClip",
        .binding = &shader_injection.colorGradeClip,
        .default_value = 0.f,
        .label = "Clipping",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.toneMapType == 3.f; },
        .parse = [](float value) { return value; },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeInternalLUTStrength",
        .binding = &shader_injection.colorGradeInternalLUTStrength,
        .default_value = 100.f,
        .label = "Internal LUT Strength",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .is_enabled = []() { return InternalLutCheck != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeInternalLUTScaling",
        .binding = &shader_injection.colorGradeInternalLUTScaling,
        .default_value = 0.f,
        .label = "Internal LUT Scaling",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .is_enabled = []() { return InternalLutCheck != 0.f; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeInternalLUTShaper",
        .binding = &shader_injection.colorGradeInternalLUTShaper,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "LUT Shaper",
        .section = "Color Grading",
        .labels = {"Vanilla", "PQ"},
        .tint = 0x452F7A,
        .is_enabled = []() { return InternalLutCheck != 0.f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeUserLUTStrength",
        .binding = &shader_injection.colorGradeUserLUTStrength,
        .default_value = 100.f,
        .label = "User LUT Strength",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeUserLUTScaling",
        .binding = &shader_injection.colorGradeUserLUTScaling,
        .default_value = 0.f,
        .label = "User LUT Scaling",
        .section = "Color Grading",
        .tint = 0x452F7A,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeLUTSampling",
        .binding = &shader_injection.colorGradeLUTSampling,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "LUT Sampling",
        .section = "Color Grading",
        .labels = {"Vanilla", "Tetrahedral"},
        .tint = 0x452F7A,
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "colorGradeColorSpace",
        .binding = &shader_injection.colorGradeColorSpace,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Output Color Space",
        .section = "Color Grading",
        .tooltip = "Emulates display color temperature."
                   "\nOff for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93."
                   "\nJPN CRT 2 for BT.601 ARIB-TR-B9 9300k 27 MPCD."
                   "\nUS CRT for BT.601 (NTSC-U).",
        .labels = {"Off", "JPN Modern", "JPN CRT", "JPN CRT 2", "US CRT"},
        .tint = 0x452F7A,
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Set game to Borderless Window and restart it to remove this warning."
                 "If already Borderless, enable Swapchain Proxy in Advanced Settings.",
        .section = "Warning",
        .tint = 0xD82D19,
        .is_visible = []() { return !finalBlitCheck && shader_injection.swapchainProxy == 0.f; },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Missing output shader. Automatic shader dump requested."
                 "\nSet LUT Shaper to Vanilla for correct output. (may clamp to SDR)",
        .section = "Warning",
        .tint = 0xD82D19,
        .is_visible = []() { return InternalLutCheck == 1.f; },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Tonemap and color grading are currently not tweakable in real time."
                 "\nAny change will only take effect next time LUT is generated.",
        .section = "Warning",
        .tint = 0x38F6FC,
        .is_visible = []() { return InternalLutCheck == 4.f; },
        .is_sticky = true,
    },
    new renodx::utils::settings::Setting{
        .key = "fxBloom",
        .binding = &shader_injection.fxBloom,
        .default_value = 50.f,
        .label = "Bloom",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxLens",
        .binding = &shader_injection.fxLens,
        .default_value = 50.f,
        .label = "Lens Dirt/Flare",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxDoF",
        .binding = &shader_injection.fxDoF,
        .default_value = 100.f,
        .label = "Depth of Field",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxCA",
        .binding = &shader_injection.fxCA,
        .default_value = 50.f,
        .label = "Chromatic Aberration",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxVignette",
        .binding = &shader_injection.fxVignette,
        .default_value = 50.f,
        .label = "Vignette",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxNoise",
        .binding = &shader_injection.fxNoise,
        .default_value = 50.f,
        .label = "Dithering Noise",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrain",
        .binding = &shader_injection.fxFilmGrain,
        .default_value = 50.f,
        .label = "Film Grain",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxFilmGrainType",
        .binding = &shader_injection.fxFilmGrainType,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Film Grain Type",
        .section = "Effects",
        .labels = {"Vanilla", "Perceptual"},
        .tint = 0x4D7180,
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fxHdrBoost",
        .binding = &shader_injection.fxHdrBoost,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FakeHDR Boost",
        .section = "Effects",
        .tint = 0x4D7180,
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return shader_injection.tonemapCheck < 2.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0xDB9D47,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("toneMapType", 3.f);
          renodx::utils::settings::UpdateSetting("toneMapPerChannel", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapColorSpace", 2.f);
          renodx::utils::settings::UpdateSetting("toneMapHueProcessor", 1.f);
          renodx::utils::settings::UpdateSetting("toneMapHueShift", 50.f);
          renodx::utils::settings::UpdateSetting("toneMapHueCorrection", 0.f);
          renodx::utils::settings::UpdateSetting("toneMapShoulderStart", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeBlowout", 50.f);
          renodx::utils::settings::UpdateSetting("colorGradeDechroma", 0.f);
          renodx::utils::settings::UpdateSetting("colorGradeFlare", 25.f);
          renodx::utils::settings::UpdateSetting("colorGradeClip", 0.f);
          renodx::utils::settings::UpdateSetting("colorGradeInternalLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeInternalLUTScaling", 0.f);
          renodx::utils::settings::UpdateSetting("colorGradeInternalLUTShaper", 1.f);
          renodx::utils::settings::UpdateSetting("colorGradeUserLUTStrength", 100.f);
          renodx::utils::settings::UpdateSetting("colorGradeUserLUTScaling", 0.f);
          renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 1.f);
        },
        .is_visible = []() { return shader_injection.tonemapCheck != 0.f; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "AutoHDR Look",
        .section = "Color Grading Templates",
        .group = "button-line-1",
        .tint = 0x452F7A,
        .on_change = []() {
          renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.27f);
          renodx::utils::settings::UpdateSetting("colorGradeContrast", 55.f);
        },
        .is_visible = []() { return shader_injection.tonemapCheck >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "rolloffUI",
        .binding = &shader_injection.rolloffUI,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "UI Behavior",
        .section = "Compatibility",
        .tooltip = "Only affects a few selected shaders",
        .labels = {"Do nothing", "Rolloff (peak)", "Clamp (sdr)"},
        .tint = 0x1C1C3C,
        .is_visible = []() { return current_settings_mode >= 2; },
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("colorGradeInternalLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeInternalLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeInternalLUTShaper", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeUserLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("colorGradeUserLUTScaling", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeLUTSampling", 0.f);
  renodx::utils::settings::UpdateSetting("colorGradeColorSpace", 0.f);
  renodx::utils::settings::UpdateSetting("fxBloom", 50.f);
  renodx::utils::settings::UpdateSetting("fxLens", 50.f);
  renodx::utils::settings::UpdateSetting("fxVignette", 50.f);
  renodx::utils::settings::UpdateSetting("fxDoF", 100.f);
  renodx::utils::settings::UpdateSetting("fxCA", 50.f);
  renodx::utils::settings::UpdateSetting("fxNoise", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrain", 50.f);
  renodx::utils::settings::UpdateSetting("fxFilmGrainType", 0.f);
}

struct __declspec(uuid("A1B2C3D4-5678-90AB-CDEF-0123456789AB")) BlendOnlyData {
  reshade::api::pipeline pipeline = {};
};

constexpr reshade::api::pipeline_layout PIPELINE_LAYOUT{0};

void CreateBlendPipeline(reshade::api::device *device) {
  auto *d = device->create_private_data<BlendOnlyData>();

  reshade::api::blend_desc bd = {};
  bd.blend_enable[0] = true;
  bd.source_color_blend_factor[0] = reshade::api::blend_factor::one;
  bd.dest_color_blend_factor[0]   = reshade::api::blend_factor::one;
  bd.color_blend_op[0]            = reshade::api::blend_op::add;
  bd.source_alpha_blend_factor[0] = reshade::api::blend_factor::one;
  bd.dest_alpha_blend_factor[0]   = reshade::api::blend_factor::one;
  bd.alpha_blend_op[0]            = reshade::api::blend_op::add;

  reshade::api::pipeline_subobject sub = {};
  sub.type  = reshade::api::pipeline_subobject_type::blend_state;
  sub.count = 1;
  sub.data  = &bd;

  device->create_pipeline(PIPELINE_LAYOUT, 1, &sub, &d->pipeline);
}

void DestroyBlendPipeline(reshade::api::device *device) {
  auto *d = device->get_private_data<BlendOnlyData>();
  if (d != nullptr && d->pipeline.handle != 0) {
    device->destroy_pipeline(d->pipeline);
    d->pipeline = {};
    device->destroy_private_data<BlendOnlyData>();
  }
}

bool Blend_OnDrawIndexed(reshade::api::command_list* cmd_list,
                         uint32_t index_count, uint32_t instance_count,
                         uint32_t first_index, int32_t vertex_offset,
                         uint32_t first_instance)
{
  // get RenoDX shader state and pixel state (same pattern used in the Unreal addon)
  auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
  if (shader_state == nullptr) return false;

  auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);
  const uint32_t pixel_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
  if (pixel_hash == 0u) return false;
  if (pixel_hash == 0x807D5E31u) {
    auto *device = cmd_list->get_device();
    auto *d = device->get_private_data<BlendOnlyData>();
    if (d != nullptr && d->pipeline.handle != 0) {
      // bind only the output-merger stage to change blend state only
      cmd_list->bind_pipeline(reshade::api::pipeline_stage::output_merger, d->pipeline);
    }
  }

  return false;
}

void AddLiRTEDUpgrades() {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=192,.height=192},
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=256,.height=256},
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=384,.height=384},
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=512,.height=512},
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=768,.height=768},
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=1024,.height=1024},
      });
}

void AddTGTFoAUpgrades() {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .ignore_size = false,
          .usage_include = reshade::api::resource_usage::render_target,
          .usage_exclude = reshade::api::resource_usage::unordered_access | reshade::api::resource_usage::undefined,
      });
}

void AddIndex0Upgrade() {
      renodx::mods::swapchain::resource_upgrade_infos.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .index = 0,
          .ignore_size = false,
          .usage_include = reshade::api::resource_usage::render_target,
      });
}

void AddLISBtSUpgrades() {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .index = 0,
          .ignore_size = false,
          .usage_include = reshade::api::resource_usage::render_target,
      });
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .ignore_size = true,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
      });
}

void AddSolateriaUpgrades() {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .index = 0,
          .dimensions = {1024,32},
          .usage_include = reshade::api::resource_usage::render_target,
      });
}

void AddSmolInternalLutUpgrade() {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {256,16},
          .usage_include = reshade::api::resource_usage::render_target,
      });
}

void AddGamePatches() {
  auto process_path = renodx::utils::platform::GetCurrentProcessPath();
  auto filename = process_path.filename().string();
  auto product_name = renodx::utils::platform::GetProductName(process_path);
  if (filename == "Fall of Avalon.exe") {
    AddTGTFoAUpgrades();
  } else if (filename == "Life is Strange - Before the Storm.exe") {
    AddLISBtSUpgrades();
    shader_injection.isClamped = 2.f;
  } else if (filename == "TheEternalDie.exe") {
    AddLiRTEDUpgrades();
  } else if (filename == "Dimhaven Enigmas.exe" || filename == "Dimhaven - The Lost Source.exe") {
    AddIndex0Upgrade();
  } else if (filename == "OPUS_ Prism Peak.exe"){
    AddSmolInternalLutUpgrade();
    AddIndex0Upgrade();
  } else if (filename == "Solateria.exe"){
    g_upgrade_internal_lut = 0.f;
    AddSolateriaUpgrades();
  } else if (filename == "Tales of Xillia Remastered.exe" || filename == "CONSTANCE.exe") {
    AddSmolInternalLutUpgrade();
  } else if(filename == "Ultros.exe" || filename == "Batbarian Testament of the Primordials.exe"
    || filename == "nslt.exe" || filename == "AuRevoir.exe" || filename == "ShootasBloodAndTeef.exe"
  || filename == "Copycat.exe" || filename == "Make Way.exe" || filename == "Digimon World Next Order.exe"
  || filename == "Quern.exe" || filename == "reverse1999.exe" || filename == "NineSols.exe" || filename == "Distance.exe"
  || filename == "SlimeRancher.exe" || filename == "Source of Madness.exe" || filename == "Stirring Abyss.exe"
  || filename == "thief.exe" || filename == "STASIS2.exe" || filename == "Elementallis.exe"){
    shader_injection.isClamped = 2.f;
    } else if(filename == "It Steals.exe"){
    shader_injection.isClamped = 3.f;
  } else {
    return;
  }
  reshade::log::message(reshade::log::level::info, std::format("Applied patches for {} ({}).", filename, product_name).c_str());
}

const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
    {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
    {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
    {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
    {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless},
    //{"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
    {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
    //{"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
    //{"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
    {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
    //{"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
    {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
    //{"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
};

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

const std::unordered_map<
    std::string,                             // Filename or ProductName
    std::unordered_map<std::string, float>>  // {Key, Value}
    GAME_DEFAULT_SETTINGS = {
        {
            "AER.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "AI-LIMIT.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R8G8B8A8_UNORM", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R8G8B8A8_UNORM_SRGB", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "Among The Sleep.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Anger Foot.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
            },
        },
        {
            "Aragami.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "AtelierReslerianaRW.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "AuRevoir.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
            },
        },
        {
            "cactus.exe", // Assault Android Cactus+
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
            },
        },
        {
            "BadNorth.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "BattleTech.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Scaling_Offset", 1.f},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Becalm.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Bendy - Lone Wolf.exe",
            {
                {"Swapchain_Encoding", 1.f},
                {"Blit_Copy_Hack", 0.f},
            },
        },
        {
            "Descenders.exe",
            {
              {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Dimhaven - The Lost Source.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
            },
        },
        {
            "Diplomacy is Not an Option.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_ANY},
                {"Blit_Copy_Hack", 3.f},
            },
        },
        {
            "Distance.exe",
            {
              {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},  
              {"Upgrade_R10G10B10A2_TYPELESS", UPGRADE_TYPE_ANY},
              {"Swapchain_Encoding", 1.f},
              {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Dreamfall Chapters.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Dungeons2.exe",
            {
              {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},  
              {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "d4.exe",
            {
              {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},  
              {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Dungeons 4.exe",
            {
              {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},  
              {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Eastshade.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "EXO ONE.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Scaling_Offset", 1.f},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Fall of Avalon.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Going Under.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "GUNTOUCHABLES.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Humankind.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R10G10B10A2_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "KingdomsAndCastles.exe",
            {
                {"Swapchain_Encoding", 1.f},
                {"Scaling_Offset", 1.f},
                {"Tonemap_Offset", 1.f},
                {"Blit_Copy_Hack", 2.f},
            },
        },
        {
            "Kingmaker.exe",  // Pathfinder
            {
                {"Swapchain_Encoding", 1.f},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Kona.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "LEGO Party.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Life is Strange - Before the Storm.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
            },
        },
        {
            "LittleBigAdventureTwinsensQuest.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R10G10B10A2_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "TheEternalDie.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R10G10B10A2_TYPELESS", UPGRADE_TYPE_ANY},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "Necropolis.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Oblivion Override.exe",
            {
                {"Swapchain_Encoding", 1.f},
                {"Scaling_Offset", 1.f},
                {"Tonemap_Offset", 1.f},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "OPUS_ Prism Peak.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Scaling_Offset", 1.f},
                {"Tonemap_Offset", 1.f},
            },
        },
        {
            "OsirisNewDawn.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
            },
        },
        {
            "Outward Definitive Edition.exe",
            {
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "PartyAnimals.exe",
            {
                {"Use_Swapchain_Proxy", 1.f},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "Reignbreaker.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
            },
        },
        {
            "Replaced.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_ANY},
            },
        },
        {
            "RimWorldWin64.exe",
            {
                {"Swapchain_Encoding", 1.f},
            },
        },
        {
            "SatelliteReignWindows.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Schedule I.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R8G8B8A8_UNORM", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R8G8B8A8_UNORM_SRGB", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
                {"Upgrade_R10G10B10A2_TYPELESS", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "SeaOfSolitude.exe",
            {
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "Shape of Dreams.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Scaling_Offset", 1.f},
                {"Tonemap_Offset", 1.f},
            },
        },
        {
            "SlimeRancher.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
                {"Swapchain_Encoding", 1.f},
            },
        },
        {
            "Snake Force.exe",
            {
                {"Scaling_Offset", 3.f},
                {"Blit_Copy_Hack", 3.f},
            },
        },
        {
            "SodaCrisis.exe",
            {
                {"Scaling_Offset", 3.f},
                {"Blit_Copy_Hack", 3.f},
            },
        },
        {
            "Solasta.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
                {"Blit_Copy_Hack", 3.f},
            },
        },
        {
            "Solateria.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "Star Trucker.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_RATIO},
            },
        },
        {
            "Sunless Skies.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_ANY},
            },
        },
        {
            "Chronicles.exe",   // Summoner's War:
            {
                {"Upgrade_R10G10B10A2_TYPELESS", UPGRADE_TYPE_OUTPUT_SIZE},
            },
        },
        {
            "TheForest.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "The Rogue Prince of Persia.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_OUTPUT_SIZE},
                {"Upgrade_CopyDestinations", 2.f},
            },
        },
        {
            "UnrulyHeroes.exe",
            {
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "VRising.exe",
            {
                {"Upgrade_R11G11B10_FLOAT", UPGRADE_TYPE_ANY},
            },
        },
        {
            "Mechanicus.exe",  // W40k
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Scaling_Offset", 1.f},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
        {
            "WH40KRT.exe",  // W40k Rogue Trader
            {
                {"Scaling_Offset", 2.f},
            },
        },
        {
            "WFTOGame.exe",
            {
                {"Upgrade_R8G8B8A8_TYPELESS", UPGRADE_TYPE_NONE},
                {"Use_Swapchain_Proxy", 1.f},
            },
        },
};

float g_upgrade_copy_destinations = 0.f;
float g_use_resource_cloning = 0.f;
float g_force_pipeline_cloning = 0.f;
float g_resize_internal_lut = 0.f;
float toggleBlitHack = 0.f;

void AddAdvancedSettings() {
  auto process_path = renodx::utils::platform::GetCurrentProcessPath();
  auto filename = process_path.filename().string();
  auto default_settings = GAME_DEFAULT_SETTINGS.find(filename);

  {
    std::stringstream s;
    if (default_settings == GAME_DEFAULT_SETTINGS.end()) {
      auto product_name = renodx::utils::platform::GetProductName(process_path);

      default_settings = GAME_DEFAULT_SETTINGS.find(product_name);

      if (default_settings == GAME_DEFAULT_SETTINGS.end()) {
        s << "No default settings for ";
      } else {
        s << "Marked default values for ";
        gammaSpaceLock = true;
      }
      s << filename;
      s << " (" << product_name << ")";
    } else {
      s << "Marked default values for ";
      s << filename;
      gammaSpaceLock = true;
    }
    reshade::log::message(reshade::log::level::info, s.str().c_str());
  }

  auto add_setting = [&](auto* setting) {
    if (default_settings != GAME_DEFAULT_SETTINGS.end()) {
      auto values = default_settings->second;
      if (auto values_pair = values.find(setting->key);
          values_pair != values.end()) {
        setting->default_value = static_cast<float>(values_pair->second);
        std::stringstream s;
        s << "Default value for ";
        s << setting->key;
        s << ": ";
        s << setting->default_value;
        reshade::log::message(reshade::log::level::info, s.str().c_str());
      }
    }
    renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
    settings.push_back(setting);
  };
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Swapchain_Encoding",
        .binding = &gammaSpace,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .can_reset = false,
        .label = "Swapchain Encoding",
        .section = "Compatibility",
        .tooltip = "Disabled if detected automatically.",
        .labels = {"Linear", "Gamma"},
        .tint = 0x1C1C3C,
        //.is_enabled = []() { return !gammaSpaceLock; },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    gammaSpace = setting->GetValue();
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Scaling_Offset",
        .binding = &countOffset,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling offset",
        .section = "Compatibility",
        .tooltip = "Moves Game Brightness application if possible.",
        .labels = {"0", "1", "2", "3", "4", "5"},
        .tint = 0x1C1C3C,
        .is_enabled = []() { return shader_injection.countOld + countOffset > 1.f; },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    countOffset = setting->GetValue();
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Tonemap_Offset",
        .binding = &count2Offset,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Tonemap offset",
        .section = "Compatibility",
        .tooltip = "Moves Tonemap/Color Grading application if possible.",
        .labels = {"0", "1", "2", "3", "4", "5"},
        .tint = 0x1C1C3C,
        .is_enabled = []() { return shader_injection.tonemapCheck < 2.f && shader_injection.count2Old + count2Offset > 1.f; },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    count2Offset = setting->GetValue();
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Blit_Copy_Hack",
        .binding = &blitCopyHack,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Blit Copy Hack",
        .section = "Compatibility",
        .tooltip = "\nHijacks Copy shader to apply Tonemap/Color Grade/Scaling."
                   "\nAuto triggers when no other shader is available."
                   "\nAffected by offsets",
        .labels = {"Off", "Auto", "On", "Scaling only"},
        .tint = 0x1C1C3C,
        .is_enabled = []() { return toggleBlitHack; },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    blitCopyHack = setting->GetValue();
  }
  settings.push_back({new renodx::utils::settings::Setting{
      .value_type = renodx::utils::settings::SettingValueType::TEXT,
      .label = "Settings below require game restart to take effect.",
      .section = "Resource Upgrades",
      .is_visible = []() { return settings[0]->GetValue() >= 2; },
  }});
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Use_Swapchain_Proxy",
        .binding = &g_use_swapchain_proxy,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Proxy",
        .section = "Resource Upgrades",
        .labels = {
            "Off",
            "On",
            "On (Compatibility Mode)",
        },
        .tint = 0xAFD8B5,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    g_use_swapchain_proxy = setting->GetValue();
    if(g_use_swapchain_proxy >= 1.f){
    /*renodx::mods::swapchain::swap_chain_proxy_vertex_shader = __swap_chain_proxy_vertex_shader;
    renodx::mods::swapchain::swap_chain_proxy_pixel_shader = __swap_chain_proxy_pixel_shader;*/
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };
      renodx::mods::swapchain::swapchain_proxy_compatibility_mode = g_use_swapchain_proxy == 2.f;
    shader_injection.swapchainProxy = 1.f;
    }
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Use_Resource_Cloning",
        .binding = &g_use_resource_cloning,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Use Resource Cloning",
        .section = "Resource Upgrades",
        .labels = {
            "Off",
            "On",
        },
        .tint = 0xAFD8B5,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    g_use_resource_cloning = setting->GetValue();
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Force_Pipeline_Cloning",
        .binding = &g_force_pipeline_cloning,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Force Pipeline Cloning",
        .section = "Resource Upgrades",
        .tooltip = "Not sure how it works, mostly to solve issues with dx12 (I think).",
        .labels = {
            "Off",
            "On",
        },
        .tint = 0xAFD8B5,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    g_force_pipeline_cloning = setting->GetValue();
    renodx::mods::shader::force_pipeline_cloning = g_force_pipeline_cloning == 1.f;
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_CopyDestinations",
        .binding = &g_upgrade_copy_destinations,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Upgrade Copy Destinations",
        .section = "Resource Upgrades",
        .tooltip = "Includes upgrading texture copy destinations.",
        .labels = {
            "Off",
            "On",
            "Auto-Upgrade",
        },
        .tint = 0xAFD8B5,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);
    g_upgrade_copy_destinations = setting->GetValue();
    renodx::mods::swapchain::use_auto_upgrade = g_upgrade_copy_destinations == 2.f;
  }
  for (const auto& [key, format] : UPGRADE_TARGETS) {
    auto* new_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_" + key,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = key,
        .section = "Resource Upgrades",
        .labels = {
            "Off",
            "Output size",
            "Output ratio",
            "Any size",
        },
        .tint = 0xDF7211,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    if(key == "R8G8B8A8_TYPELESS") new_setting->default_value = 1.f;
    add_setting(new_setting);
    auto value = new_setting->GetValue();
    if (value > 0) {
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = format,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .ignore_size = (value == UPGRADE_TYPE_ANY),
          .use_resource_view_cloning = g_use_resource_cloning == 1.f,
          .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
                                                 ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                 : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
          /*.usage_include = reshade::api::resource_usage::render_target
                           | reshade::api::resource_usage::unordered_access
                           | (g_upgrade_copy_destinations == 1.f
                                  ? (reshade::api::resource_usage::copy_dest | reshade::api::resource_usage::copy_source)
                                  : reshade::api::resource_usage::undefined),*/
          .usage_include = g_upgrade_copy_destinations == 1.f
                          ? reshade::api::resource_usage::undefined
                          : (reshade::api::resource_usage::render_target | reshade::api::resource_usage::unordered_access),
      });
      std::stringstream s;
      s << "Applying user resource upgrade for ";
      s << format << ": " << value;
      reshade::log::message(reshade::log::level::info, s.str().c_str());
    }
  }
  /*{
    auto* setting = new renodx::utils::settings::Setting{
        .key = "Resize_Internal_Lut",
        .binding = &g_resize_internal_lut,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Resize Internal LUT",
        .section = "Resource Upgrades",
        .labels = {
            "Off",
            "On",
        },
        .tint = 0x896895,
        .is_global = true,
        //.is_visible = []() { return settings[0]->GetValue() >= 2; },
        .is_visible = []() { return false; },
    };
    add_setting(setting);
    g_resize_internal_lut = setting->GetValue();
    shader_injection.internalLutResized = 1.f;
    if(g_resize_internal_lut == 1.f){
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=256, .height=16},
          .new_dimensions = {.width=1024, .height=32},
          .usage_include = reshade::api::resource_usage::render_target,
      });
    }
    shader_injection.internalLutResized = g_resize_internal_lut;
  }*/
  {
    auto* scrgb_setting = new renodx::utils::settings::Setting{
        .key = "Upgrade_UseSCRGB",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Swap Chain Format",
        .section = "Resource Upgrades",
        .tooltip = "Selects use of HDR10 or scRGB swapchain.",
        .labels = {
            "HDR10",
            "scRGB",
        },
        .tint = 0x896895,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(scrgb_setting);

    shader_injection.processing_use_scrgb = scrgb_setting->GetValue();
    renodx::mods::swapchain::SetUseHDR10(scrgb_setting->GetValue() == 0);
  }
  {
    auto* force_borderless_setting = new renodx::utils::settings::Setting{
        .key = "ForceBorderless",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Force Borderless Window",
        .section = "Resource Upgrades",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .tint = 0x896895,
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(force_borderless_setting);
    if (force_borderless_setting->GetValue() == 0) {
      renodx::mods::swapchain::force_borderless = false;
    }
  }
  {
    auto* setting = new renodx::utils::settings::Setting{
        .key = "PreventFullscreen",
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Prevent Exclusive Fullscreen",
        .section = "Resource Upgrades",
        .labels = {
            "Disabled",
            "Enabled",
        },
        .tint = 0x896895,
        .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
        .is_global = true,
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    };
    add_setting(setting);

    renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
  }
  {
    add_setting(new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Version: " + std::string(renodx::utils::date::ISO_DATE),
        .section = "About",
        .tooltip = std::string(__DATE__),
    });
    add_setting(new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-2",
        .tooltip = "RenoDX server",
        .tint = 0x5865F2,
        .on_change = []() { renodx::utils::platform::LaunchURL("https://discord.gg/ren", "odx"); },
    });
    add_setting(new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Github",
        .section = "Links",
        .group = "button-line-2",
        .tooltip = "RenoDX repository",
        .on_change = []() { renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx"); },
    });
  }
}

/*void OnInitDevice(reshade::api::device* device) {
  if (device->get_api() == reshade::api::device_api::d3d12) {
    renodx::mods::shader::force_pipeline_cloning = true;
  }
}*/

bool fired_on_init_swapchain = false;

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (peak.has_value()) {
    settings[2]->default_value = peak.value();
    settings[2]->can_reset = true;
  }
}

void UpdateDumpUberSchedule(float previous_internal_lut_check) {
  if (!dump_uber_schedule_observed || previous_internal_lut_check != InternalLutCheck) {
    std::stringstream message;
    message << "[DUMP OUTPUT] InternalLutCheck "
            << (dump_uber_schedule_observed ? "changed" : "observed")
            << ": " << previous_internal_lut_check << " -> " << InternalLutCheck;
    reshade::log::message(reshade::log::level::info, message.str().c_str());
    dump_uber_schedule_observed = true;
  }

  if (InternalLutCheck != 1.f) {
    dump_uber::SetDumpEnabled(false, "InternalLutCheck changed away from 1");
    dump_uber_schedule_state = DumpUberScheduleState::IDLE;
    dump_uber_schedule_deadline = {};
    return;
  }

  const auto now = std::chrono::steady_clock::now();
  if (previous_internal_lut_check == 0.f) {
    dump_uber::SetDumpEnabled(true, "InternalLutCheck changed from 0 to 1");
    dump_uber_schedule_state = DumpUberScheduleState::INITIAL_WINDOW;
    dump_uber_schedule_deadline = now + DUMP_UBER_INITIAL_WINDOW;
    return;
  }

  switch (dump_uber_schedule_state) {
    case DumpUberScheduleState::INITIAL_WINDOW:
      if (now >= dump_uber_schedule_deadline) {
        dump_uber::SetDumpEnabled(false, "initial one-second search window elapsed");
        dump_uber_schedule_state = DumpUberScheduleState::COOLDOWN;
        dump_uber_schedule_deadline = now + DUMP_UBER_PERIODIC_INTERVAL;
      }
      break;
    case DumpUberScheduleState::COOLDOWN:
      if (now >= dump_uber_schedule_deadline) {
        dump_uber::SetDumpEnabled(true, "periodic retry while InternalLutCheck remains 1");
        dump_uber_schedule_state = DumpUberScheduleState::PERIODIC_FRAME;
      }
      break;
    case DumpUberScheduleState::PERIODIC_FRAME:
      dump_uber::SetDumpEnabled(false, "periodic one-frame search completed");
      dump_uber_schedule_state = DumpUberScheduleState::COOLDOWN;
      dump_uber_schedule_deadline = now + DUMP_UBER_PERIODIC_INTERVAL;
      break;
    case DumpUberScheduleState::IDLE:
      dump_uber_schedule_state = DumpUberScheduleState::COOLDOWN;
      dump_uber_schedule_deadline = now + DUMP_UBER_PERIODIC_INTERVAL;
      break;
  }
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
      const float previous_internal_lut_check = InternalLutCheck;
        if(unityTonemapper != shader_injection.tonemapCheck){
            if(trunc(unityTonemapper) == 3){
        settings[1]->labels = {"Vanilla", "None", "ACES", "RenoDRT (Daniele)", "RenoDRT (Reinhard)"};
        settings[10]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[17]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[18]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[19]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[20]->is_enabled = []() { return shader_injection.toneMapType == 4.f; };
        shader_injection.tonemapCheck = unityTonemapper;
            } else if(trunc(unityTonemapper) == 2){
        settings[1]->labels = {"Vanilla", "None", "RenoDRT (Daniele)", "RenoDRT (Reinhard)", "RenoDRT (Hermite Spline)"};
        if(unityTonemapper == 2.5f){
        settings[6]->labels = {"Per Channel", "Luminance"};
        settings[9]->is_enabled = []() { return shader_injection.toneMapType >= 3.f && shader_injection.toneMapPerChannel != 0.f; };
        } else {
        settings[6]->labels = {"Luminance", "Per Channel"};
        settings[9]->is_enabled = []() { return shader_injection.toneMapType >= 3.f && shader_injection.toneMapPerChannel == 0.f; };
        }
        settings[10]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[17]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[18]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[19]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        settings[20]->is_enabled = []() { return shader_injection.toneMapType >= 3.f; };
        shader_injection.tonemapCheck = unityTonemapper;
            } else if(trunc(unityTonemapper) == 1){
        settings[1]->labels = {"Vanilla", "None", "Frostbite", "RenoDRT (Hermite Spline)", "DICE"};
        settings[10]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
        settings[17]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
        settings[18]->is_enabled = []() { return shader_injection.toneMapType >= 2.f; };
        settings[19]->is_enabled = []() { return shader_injection.toneMapType == 3.f; };
        settings[20]->is_enabled = []() { return shader_injection.toneMapType == 3.f; };
        shader_injection.tonemapCheck = unityTonemapper;
            }
        }
        if(lutSampler && lutBuilder){
          InternalLutCheck = 3.f;
        } else if(lutSampler){
          InternalLutCheck = sneakyBuilder || InternalLutCheck == 4.f ? 4.f : 2.f;
          sneakyBuilder = false;
        } else if(lutBuilder){
          InternalLutCheck = 1.f;
        } else {
          InternalLutCheck = 0.f;
          sneakyBuilder = false;
        }
        UpdateDumpUberSchedule(previous_internal_lut_check);
        shader_injection.countOld = fmax(1.f, countMid - countOffset);
        shader_injection.count2Old = fmax(1.f, count2Mid - count2Offset);
        countMid = 0.f;
        count2Mid = 0.f;
        shader_injection.countNew = 0.f;
        shader_injection.count2New = 0.f;
        unityTonemapper = InternalLutCheck == 4.f || sneakyBuilder ? unityTonemapper : 0;
        lutSampler = false;
        lutBuilder = false;
        if(shader_injection.gammaSpace != gammaSpace){
            shader_injection.gammaSpace = gammaSpace;
            renodx::utils::settings::UpdateSetting("Swapchain_Encoding", shader_injection.gammaSpace);
            renodx::utils::settings::SaveGlobalSettings();
        }
        if(blitCopyHack >= 2.f){
          shader_injection.blitCopyHack = blitCopyHack - 1.f;
        } else if(blitCopyHack == 1.f && !forceDetect){
          shader_injection.blitCopyHack = 1.f;
        } else {
          shader_injection.blitCopyHack = 0.f;
        }
        forceDetect = false;
        toggleBlitHack = blitCopyCheck;
        blitCopyCheck = 0.f;
        shader_injection.isClamped = shader_injection.isClamped < 2.f ? 0.f : shader_injection.isClamped;
        //finalBlitDraws = 0.f;
}

bool initialized = false;

bool IsCustomShader(std::uint32_t shader_hash) {
  return custom_shaders.contains(shader_hash);
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX for Unity Engine";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      if (!initialized) {
      MergeShaders();
      //renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
      renodx::mods::swapchain::swapchain_proxy_revert_state = true;
      //renodx::mods::shader::force_pipeline_cloning = true;
      //renodx::mods::shader::expected_constant_buffer_space = 50;
      renodx::mods::shader::expected_constant_buffer_index = 13;
      //renodx::mods::shader::allow_multiple_push_constants = true;
      //renodx::mods::shader::revert_constant_buffer_ranges = true;
      renodx::mods::swapchain::expected_constant_buffer_index = 13;
      renodx::mods::swapchain::expected_constant_buffer_space = 50;
      renodx::mods::swapchain::use_resource_cloning = true;
      renodx::utils::random::binds.push_back(&shader_injection.random);
      AddAdvancedSettings();
      AddGamePatches();
      //  internal LUT
      if(g_upgrade_internal_lut == 1.f){
      renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .dimensions = {.width=1024, .height=32},
          .usage_include = reshade::api::resource_usage::render_target,
      });
    }
      //reshade::register_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::register_event<reshade::addon_event::init_device>(CreateBlendPipeline);
      reshade::register_event<reshade::addon_event::destroy_device>(DestroyBlendPipeline);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::draw_indexed>(Blend_OnDrawIndexed);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
        initialized = true;
      }
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_addon(h_module);
      //reshade::unregister_event<reshade::addon_event::init_device>(OnInitDevice);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      break;
  }
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if(g_use_swapchain_proxy >= 1.f){
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  } else {
  renodx::mods::swapchain::Use(fdw_reason);
  }
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::Use(fdw_reason);

  dump_uber::SetShaderInAddonCallback(&IsCustomShader);
  dump_uber::Use(fdw_reason);

  return TRUE;
}
