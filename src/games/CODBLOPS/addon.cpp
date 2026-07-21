/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define RENODX_MODS_SWAPCHAIN_VERSION 2
#define RENODX_FPS_LIMIT_HR_TIMER
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iomanip>
#include <limits>
#include <mutex>
#include <ranges>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {
#define UpgradeRTVReplaceShader(value)       \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .code = __##value,                 \
          .on_draw = [](auto* cmd_list) {                                                             \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                         \
            bool changed = false;                                                                     \
            for (auto rtv : rtvs) {                                                                   \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv);   \
            }                                                                                         \
            if (changed) {                                                                            \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                    \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0}); \
            }                                                                                         \
            return true; }, \
      },                                     \
  }

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
renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000),
    __ALL_CUSTOM_SHADERS,
    
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;
float dx9_auto_output_unclamp_mode = 1.f;

constexpr float TONE_MAP_TYPE_VANILLA = 0.f;
constexpr float TONE_MAP_TYPE_RENODRT = 3.f;
constexpr float TONE_MAP_TYPE_PSYCHOV22 = 22.f;

inline bool IsCustomToneMapperEnabled() {
  return shader_injection.tone_map_type != TONE_MAP_TYPE_VANILLA;
}

inline bool IsRenoDRTEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_RENODRT;
}

inline bool IsPsychoV22Enabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_PSYCHOV22;
}

void ApplySwapChainEncoding(float value) {
  const bool is_hdr10 = value == 4.f;

  renodx::mods::swapchain::SetUseHDR10(is_hdr10);
  renodx::mods::swapchain::use_resize_buffer = value < 4.f;
  shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
}


// ============================================================================
// Allowlisted D3D9 terminal output unclamping
// ============================================================================
//
// A terminal sqrt(saturate(...)) sequence is not enough to prove that a shader
// writes final scene color. BO1 uses the same encoding pattern in many surface,
// character, weapon, shadow-adjacent, and packed/intermediate passes. Patching
// all such shaders can produce pink silhouettes, broken shading, and stretched
// or corrupted textures.
//
// The default mode therefore patches only a small hash allowlist of known
// post-processing and sky/cloud shaders. Model/material lighting is separated
// into an explicit experimental mode. Broad heuristic modes remain available
// for debugging, but are intentionally labelled unsafe.
//
// Supported terminal forms:
//
//   1. sqrt(saturate(rgb)) output chains:
//
//        mul_sat r0.xyz, ...
//        rsq     r0.x, r0.x
//        rsq     r0.y, r0.y
//        rsq     r0.z, r0.z
//        rcp     oC0.x, r0.x
//        rcp     oC0.y, r0.y
//        rcp     oC0.z, r0.z
//
//      becomes the bytecode equivalent of:
//
//        rgb = original_expression;
//        rgb = max(rgb, 0.0f);
//        output = sqrt(rgb);
//
//   2. A direct final RGB _sat write to oC0.xyz. The original instruction is
//      redirected through a free temporary register, then max(rgb, 0) is
//      written to oC0.xyz.
//
// The lower zero bound is deliberately retained. Blindly clearing _sat before
// an rsq/rcp square-root sequence would allow negative values to create NaNs.
//
// The patch runs after RenoDX's normal shader replacement hook is registered,
// so embedded hash-based replacements are processed first. The patched shader
// bytecode is cached for the lifetime of the addon.

constexpr uint32_t DX9_AUTO_UNCLAMP_OFF = 0u;
constexpr uint32_t DX9_AUTO_UNCLAMP_CURATED_POST_SKY = 1u;
constexpr uint32_t DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL = 2u;
constexpr uint32_t DX9_AUTO_UNCLAMP_HEURISTIC_SQRT = 3u;
constexpr uint32_t DX9_AUTO_UNCLAMP_HEURISTIC_ALL = 4u;

constexpr uint32_t DX9_PS_3_0_VERSION = 0xFFFF0300u;
constexpr uint32_t DX9_SHADER_END = 0x0000FFFFu;
constexpr uint32_t DX9_SHADER_COMMENT_OPCODE = 0x0000FFFEu;
constexpr uint32_t DX9_OPCODE_MASK = 0x0000FFFFu;
constexpr uint32_t DX9_INSTRUCTION_LENGTH_MASK = 0x0F000000u;
constexpr uint32_t DX9_INSTRUCTION_LENGTH_SHIFT = 24u;
constexpr uint32_t DX9_COMMENT_LENGTH_MASK = 0x7FFF0000u;
constexpr uint32_t DX9_COMMENT_LENGTH_SHIFT = 16u;
constexpr uint32_t DX9_INSTRUCTION_PREDICATED = 0x10000000u;

constexpr uint32_t DX9_PARAMETER_TOKEN = 0x80000000u;
constexpr uint32_t DX9_REGISTER_NUMBER_MASK = 0x000007FFu;
constexpr uint32_t DX9_REGISTER_TYPE_MASK = 0x70001800u;
constexpr uint32_t DX9_WRITE_MASK_MASK = 0x000F0000u;
constexpr uint32_t DX9_WRITE_MASK_SHIFT = 16u;
constexpr uint32_t DX9_DEST_MODIFIER_MASK = 0x00F00000u;
constexpr uint32_t DX9_DEST_SATURATE = 0x00100000u;
constexpr uint32_t DX9_DEST_PARTIAL_PRECISION = 0x00200000u;
constexpr uint32_t DX9_SOURCE_SWIZZLE_MASK = 0x00FF0000u;
constexpr uint32_t DX9_SOURCE_SWIZZLE_SHIFT = 16u;
constexpr uint32_t DX9_SOURCE_MODIFIER_MASK = 0x0F000000u;

constexpr uint32_t DX9_REGISTER_TEMP = 0u;
constexpr uint32_t DX9_REGISTER_COLOR_OUTPUT = 8u;

constexpr uint16_t DX9_OP_MOV = 1u;
constexpr uint16_t DX9_OP_ADD = 2u;
constexpr uint16_t DX9_OP_SUB = 3u;
constexpr uint16_t DX9_OP_MAD = 4u;
constexpr uint16_t DX9_OP_MUL = 5u;
constexpr uint16_t DX9_OP_RCP = 6u;
constexpr uint16_t DX9_OP_RSQ = 7u;
constexpr uint16_t DX9_OP_DP3 = 8u;
constexpr uint16_t DX9_OP_DP4 = 9u;
constexpr uint16_t DX9_OP_MIN = 10u;
constexpr uint16_t DX9_OP_MAX = 11u;
constexpr uint16_t DX9_OP_LRP = 18u;
constexpr uint16_t DX9_OP_DCL = 31u;
constexpr uint16_t DX9_OP_DEFB = 47u;
constexpr uint16_t DX9_OP_DEFI = 48u;
constexpr uint16_t DX9_OP_TEXLD = 66u;
constexpr uint16_t DX9_OP_DEF = 81u;
constexpr uint16_t DX9_OP_CMP = 88u;

constexpr uint32_t DX9_WRITE_X = 0x1u;
constexpr uint32_t DX9_WRITE_Y = 0x2u;
constexpr uint32_t DX9_WRITE_Z = 0x4u;
constexpr uint32_t DX9_WRITE_W = 0x8u;
constexpr uint32_t DX9_WRITE_RGB = 0x7u;

constexpr uint32_t DX9_SWIZZLE_X = 0x00u;
constexpr uint32_t DX9_SWIZZLE_Y = 0x55u;
constexpr uint32_t DX9_SWIZZLE_Z = 0xAAu;
constexpr uint32_t DX9_SWIZZLE_W = 0xFFu;
constexpr uint32_t DX9_SWIZZLE_XYZW = 0xE4u;

// Known scene/post-process and sky/cloud output shaders. These are the only
// shaders patched by the default mode. A hash still has to pass the strict
// terminal-output bytecode matcher before it is modified.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_POST_SKY_ALLOWLIST = {
    0x1167C22Au,
    0x23B35169u,
    0x357DE7FDu,
    0x59760569u,
    0x706435ADu,
    0x70F19652u,
    0x783482DEu,
    0x79E32AF8u,
    0x81444CACu,
    0x88954051u,
    0x8F5D2EFFu,
    0x93610C4Cu,  // LUT pass: current matcher intentionally leaves it unchanged.
    0xC9558BEFu,
    0xCAB1BCB8u,
    0x94BC7D3Eu,  // Sky/cloud.
    0xDAC6E2D9u,  // Sky/cloud.
};

// Exact matches to the supplied spotlight/model-lighting example. These are
// kept out of the default mode because surface shaders can feed special model,
// shadow, thermal/highlight, or intermediate paths in some scenes.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST = {
    0xBACB9CF2u,
    0xCDCD3EAEu,
};

// Add hashes here when a shader is confirmed to contain packed data or a
// special effect that should never be changed, even in heuristic modes.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_DENYLIST = {
    // 0x00000000u,
};

bool DX9AutoUnclampModeAllowsHash(uint32_t mode, uint32_t hash) {
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(hash)) return false;

  switch (mode) {
    case DX9_AUTO_UNCLAMP_CURATED_POST_SKY:
      return DX9_AUTO_UNCLAMP_POST_SKY_ALLOWLIST.contains(hash);

    case DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL:
      return DX9_AUTO_UNCLAMP_POST_SKY_ALLOWLIST.contains(hash)
          || DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST.contains(hash);

    case DX9_AUTO_UNCLAMP_HEURISTIC_SQRT:
    case DX9_AUTO_UNCLAMP_HEURISTIC_ALL:
      return true;

    default:
      return false;
  }
}

bool DX9AutoUnclampModeAllowsDirectOutput(uint32_t mode) {
  return mode == DX9_AUTO_UNCLAMP_CURATED_POST_SKY
      || mode == DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL
      || mode == DX9_AUTO_UNCLAMP_HEURISTIC_ALL;
}

enum class DX9AutoUnclampPatchKind : uint32_t {
  NONE = 0u,
  SQRT_OUTPUT,
  DIRECT_OUTPUT,
};

struct DX9InstructionInfo {
  size_t token_offset = 0u;
  uint16_t opcode = 0u;
  uint8_t operand_count = 0u;
  uint32_t instruction_token = 0u;
};

struct DX9AutoUnclampPlan {
  DX9AutoUnclampPatchKind kind = DX9AutoUnclampPatchKind::NONE;
  size_t instruction_index = 0u;
  std::array<uint32_t, 2u> free_temps = {0u, 0u};
  uint32_t free_temp_count = 0u;
};

struct DX9CachedAutoUnclampShader {
  uint32_t source_crc32 = 0u;
  size_t source_size = 0u;
  DX9AutoUnclampPatchKind kind = DX9AutoUnclampPatchKind::NONE;
  std::vector<uint32_t> bytecode;
};

std::mutex g_dx9_auto_unclamp_mutex;
std::unordered_map<uint64_t, DX9CachedAutoUnclampShader>
    g_dx9_auto_unclamp_cache;
uint32_t g_dx9_auto_unclamp_sqrt_count = 0u;
uint32_t g_dx9_auto_unclamp_direct_count = 0u;
uint32_t g_dx9_auto_unclamp_log_count = 0u;

uint32_t DX9GetRegisterType(uint32_t token) {
  return ((token >> 28u) & 0x7u) | ((token >> 8u) & 0x18u);
}

uint32_t DX9GetRegisterNumber(uint32_t token) {
  return token & DX9_REGISTER_NUMBER_MASK;
}

uint32_t DX9GetWriteMask(uint32_t token) {
  return (token & DX9_WRITE_MASK_MASK) >> DX9_WRITE_MASK_SHIFT;
}

uint32_t DX9GetSourceSwizzle(uint32_t token) {
  return (token & DX9_SOURCE_SWIZZLE_MASK) >> DX9_SOURCE_SWIZZLE_SHIFT;
}

uint32_t DX9EncodeRegisterType(uint32_t type) {
  return ((type & 0x7u) << 28u) | ((type & 0x18u) << 8u);
}

uint32_t DX9SetRegister(uint32_t token, uint32_t type, uint32_t number) {
  token &= ~(DX9_REGISTER_TYPE_MASK | DX9_REGISTER_NUMBER_MASK);
  token |= DX9_PARAMETER_TOKEN;
  token |= DX9EncodeRegisterType(type);
  token |= number & DX9_REGISTER_NUMBER_MASK;
  return token;
}

uint32_t DX9MakeInstruction(uint16_t opcode, uint32_t operand_count) {
  return static_cast<uint32_t>(opcode)
      | ((operand_count << DX9_INSTRUCTION_LENGTH_SHIFT)
         & DX9_INSTRUCTION_LENGTH_MASK);
}

uint32_t DX9MakeTempDest(
    uint32_t register_number,
    uint32_t write_mask,
    bool partial_precision) {
  uint32_t token = DX9_PARAMETER_TOKEN;
  token |= DX9EncodeRegisterType(DX9_REGISTER_TEMP);
  token |= register_number & DX9_REGISTER_NUMBER_MASK;
  token |= (write_mask << DX9_WRITE_MASK_SHIFT) & DX9_WRITE_MASK_MASK;
  if (partial_precision) token |= DX9_DEST_PARTIAL_PRECISION;
  return token;
}

uint32_t DX9MakeTempSource(
    uint32_t register_number,
    uint32_t swizzle = DX9_SWIZZLE_XYZW) {
  uint32_t token = DX9_PARAMETER_TOKEN;
  token |= DX9EncodeRegisterType(DX9_REGISTER_TEMP);
  token |= register_number & DX9_REGISTER_NUMBER_MASK;
  token |= (swizzle << DX9_SOURCE_SWIZZLE_SHIFT)
      & DX9_SOURCE_SWIZZLE_MASK;
  return token;
}

bool DX9OpcodeMayHaveSaturatedColorDestination(uint16_t opcode) {
  switch (opcode) {
    case DX9_OP_MOV:
    case DX9_OP_ADD:
    case DX9_OP_SUB:
    case DX9_OP_MAD:
    case DX9_OP_MUL:
    case DX9_OP_DP3:
    case DX9_OP_DP4:
    case DX9_OP_MIN:
    case DX9_OP_MAX:
    case DX9_OP_LRP:
    case DX9_OP_TEXLD:
    case DX9_OP_CMP:
      return true;
    default:
      return false;
  }
}

bool DX9ParseShader(
    const uint32_t* tokens,
    size_t token_count,
    std::vector<DX9InstructionInfo>& instructions) {
  instructions.clear();

  if (tokens == nullptr || token_count < 2u) return false;
  if (tokens[0] != DX9_PS_3_0_VERSION) return false;

  size_t token_offset = 1u;
  while (token_offset < token_count) {
    const uint32_t instruction_token = tokens[token_offset];
    const uint16_t opcode =
        static_cast<uint16_t>(instruction_token & DX9_OPCODE_MASK);

    if (opcode == static_cast<uint16_t>(DX9_SHADER_END)) {
      instructions.push_back({
          .token_offset = token_offset,
          .opcode = opcode,
          .operand_count = 0u,
          .instruction_token = instruction_token,
      });
      return true;
    }

    if (opcode == static_cast<uint16_t>(DX9_SHADER_COMMENT_OPCODE)) {
      const size_t comment_dwords =
          (instruction_token & DX9_COMMENT_LENGTH_MASK)
          >> DX9_COMMENT_LENGTH_SHIFT;
      if (token_offset + 1u + comment_dwords > token_count) return false;
      token_offset += 1u + comment_dwords;
      continue;
    }

    const uint32_t operand_count =
        (instruction_token & DX9_INSTRUCTION_LENGTH_MASK)
        >> DX9_INSTRUCTION_LENGTH_SHIFT;
    if (token_offset + 1u + operand_count > token_count) return false;

    instructions.push_back({
        .token_offset = token_offset,
        .opcode = opcode,
        .operand_count = static_cast<uint8_t>(operand_count),
        .instruction_token = instruction_token,
    });

    token_offset += 1u + operand_count;
  }

  return false;
}

std::array<bool, 32u> DX9FindUsedTemporaryRegisters(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions) {
  std::array<bool, 32u> used = {};

  for (const auto& instruction : instructions) {
    if (instruction.opcode == static_cast<uint16_t>(DX9_SHADER_END)) continue;

    uint32_t first_parameter = 0u;
    uint32_t parameter_count = instruction.operand_count;

    // dcl stores a usage token first and the actual register second.
    if (instruction.opcode == DX9_OP_DCL) {
      first_parameter = 1u;
      parameter_count = instruction.operand_count > 1u ? 1u : 0u;
    // def/defi/defb contain literal data after the first register token.
    } else if (instruction.opcode == DX9_OP_DEF
               || instruction.opcode == DX9_OP_DEFI
               || instruction.opcode == DX9_OP_DEFB) {
      parameter_count = std::min<uint32_t>(instruction.operand_count, 1u);
    }

    for (uint32_t parameter = 0u;
         parameter < parameter_count;
         ++parameter) {
      const uint32_t token =
          tokens[instruction.token_offset + 1u + first_parameter + parameter];
      if ((token & DX9_PARAMETER_TOKEN) == 0u) continue;
      if (DX9GetRegisterType(token) != DX9_REGISTER_TEMP) continue;

      const uint32_t register_number = DX9GetRegisterNumber(token);
      if (register_number < used.size()) used[register_number] = true;
    }
  }

  return used;
}

bool DX9IsTempComponentSource(
    uint32_t token,
    uint32_t register_number,
    uint32_t component) {
  static constexpr std::array<uint32_t, 4u> COMPONENT_SWIZZLES = {
      DX9_SWIZZLE_X,
      DX9_SWIZZLE_Y,
      DX9_SWIZZLE_Z,
      DX9_SWIZZLE_W,
  };

  if (component >= COMPONENT_SWIZZLES.size()) return false;
  return DX9GetRegisterType(token) == DX9_REGISTER_TEMP
      && DX9GetRegisterNumber(token) == register_number
      && DX9GetSourceSwizzle(token) == COMPONENT_SWIZZLES[component]
      && (token & DX9_SOURCE_MODIFIER_MASK) == 0u;
}

bool DX9IsSingleComponentWrite(uint32_t write_mask) {
  return write_mask == DX9_WRITE_X
      || write_mask == DX9_WRITE_Y
      || write_mask == DX9_WRITE_Z
      || write_mask == DX9_WRITE_W;
}

uint32_t DX9WriteMaskToComponent(uint32_t write_mask) {
  switch (write_mask) {
    case DX9_WRITE_X: return 0u;
    case DX9_WRITE_Y: return 1u;
    case DX9_WRITE_Z: return 2u;
    case DX9_WRITE_W: return 3u;
    default: return UINT32_MAX;
  }
}

bool DX9IsOutputAlphaMove(
    const uint32_t* tokens,
    const DX9InstructionInfo& instruction) {
  if (instruction.opcode != DX9_OP_MOV || instruction.operand_count < 2u) {
    return false;
  }

  const uint32_t dest = tokens[instruction.token_offset + 1u];
  return DX9GetRegisterType(dest) == DX9_REGISTER_COLOR_OUTPUT
      && DX9GetRegisterNumber(dest) == 0u
      && DX9GetWriteMask(dest) == DX9_WRITE_W;
}

bool DX9MatchesTerminalSqrtOutput(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    size_t candidate_index,
    uint32_t temp_register) {
  std::array<bool, 3u> saw_rsq = {false, false, false};
  std::array<bool, 3u> saw_rcp = {false, false, false};

  for (size_t index = candidate_index + 1u;
       index + 1u < instructions.size();
       ++index) {
    const auto& instruction = instructions[index];
    if ((instruction.instruction_token & DX9_INSTRUCTION_PREDICATED) != 0u) {
      return false;
    }

    if (instruction.opcode == DX9_OP_RSQ
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9GetRegisterType(dest) == DX9_REGISTER_TEMP
          && DX9GetRegisterNumber(dest) == temp_register
          && DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (DX9IsTempComponentSource(source, temp_register, component)) {
          if (component < 3u) saw_rsq[component] = true;
          // An optional alpha square root is allowed but not modified.
          continue;
        }
      }
    }

    if (instruction.opcode == DX9_OP_RCP
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9GetRegisterType(dest) == DX9_REGISTER_COLOR_OUTPUT
          && DX9GetRegisterNumber(dest) == 0u
          && DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (DX9IsTempComponentSource(source, temp_register, component)) {
          if (component < 3u) {
            if (!saw_rsq[component]) return false;
            saw_rcp[component] = true;
          }
          // An optional alpha reciprocal is allowed but not modified.
          continue;
        }
      }
    }

    if (DX9IsOutputAlphaMove(tokens, instruction)) continue;

    // Any other operation after the candidate means the saturation is not a
    // strict terminal sqrt/output clamp and is intentionally left alone.
    return false;
  }

  return std::ranges::all_of(saw_rsq, [](bool value) { return value; })
      && std::ranges::all_of(saw_rcp, [](bool value) { return value; });
}

bool DX9MatchesDirectFinalOutput(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    size_t candidate_index) {
  for (size_t index = candidate_index + 1u;
       index + 1u < instructions.size();
       ++index) {
    if (!DX9IsOutputAlphaMove(tokens, instructions[index])) return false;
  }
  return true;
}

DX9AutoUnclampPlan DX9BuildAutoUnclampPlan(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    uint32_t mode) {
  DX9AutoUnclampPlan plan = {};
  if (mode == DX9_AUTO_UNCLAMP_OFF || instructions.size() < 2u) return plan;

  // Adding the lower-bound reconstruction costs two arithmetic instructions.
  // ps_3_0 has a 512-slot limit; use the total instruction count as a
  // conservative guard rather than trying to estimate special opcode costs.
  if (instructions.size() > 510u) return plan;

  const auto used_temps = DX9FindUsedTemporaryRegisters(tokens, instructions);
  std::array<uint32_t, 32u> free_temps = {};
  uint32_t free_temp_count = 0u;
  for (uint32_t temp = 0u; temp < used_temps.size(); ++temp) {
    if (!used_temps[temp]) free_temps[free_temp_count++] = temp;
  }

  for (size_t candidate_index = instructions.size() - 1u;
       candidate_index-- > 0u;) {
    const auto& instruction = instructions[candidate_index];
    if (!DX9OpcodeMayHaveSaturatedColorDestination(instruction.opcode)) {
      continue;
    }
    if (instruction.operand_count == 0u) continue;
    if ((instruction.instruction_token & DX9_INSTRUCTION_PREDICATED) != 0u) {
      continue;
    }

    const uint32_t dest = tokens[instruction.token_offset + 1u];
    if ((dest & DX9_DEST_SATURATE) == 0u) continue;
    if (DX9GetWriteMask(dest) != DX9_WRITE_RGB) continue;

    const uint32_t register_type = DX9GetRegisterType(dest);
    const uint32_t register_number = DX9GetRegisterNumber(dest);

    if (register_type == DX9_REGISTER_TEMP
        && free_temp_count >= 1u
        && DX9MatchesTerminalSqrtOutput(
            tokens,
            instructions,
            candidate_index,
            register_number)) {
      plan.kind = DX9AutoUnclampPatchKind::SQRT_OUTPUT;
      plan.instruction_index = candidate_index;
      plan.free_temps[0] = free_temps[0];
      plan.free_temp_count = 1u;
      return plan;
    }

    if (DX9AutoUnclampModeAllowsDirectOutput(mode)
        && register_type == DX9_REGISTER_COLOR_OUTPUT
        && register_number == 0u
        && free_temp_count >= 2u
        && DX9MatchesDirectFinalOutput(
            tokens,
            instructions,
            candidate_index)) {
      plan.kind = DX9AutoUnclampPatchKind::DIRECT_OUTPUT;
      plan.instruction_index = candidate_index;
      plan.free_temps[0] = free_temps[0];
      plan.free_temps[1] = free_temps[1];
      plan.free_temp_count = 2u;
      return plan;
    }
  }

  return plan;
}

bool DX9ApplyAutoUnclampPlan(
    const uint32_t* source_tokens,
    size_t token_count,
    const std::vector<DX9InstructionInfo>& instructions,
    const DX9AutoUnclampPlan& plan,
    std::vector<uint32_t>& patched_tokens) {
  if (plan.kind == DX9AutoUnclampPatchKind::NONE) return false;
  if (plan.instruction_index >= instructions.size()) return false;

  const auto& candidate = instructions[plan.instruction_index];
  if (candidate.operand_count == 0u) return false;

  const size_t dest_offset = candidate.token_offset + 1u;
  const size_t insert_offset =
      candidate.token_offset + 1u + candidate.operand_count;
  if (dest_offset >= token_count || insert_offset > token_count) return false;

  patched_tokens.assign(source_tokens, source_tokens + token_count);

  const uint32_t original_dest = patched_tokens[dest_offset];
  const bool partial_precision =
      (original_dest & DX9_DEST_PARTIAL_PRECISION) != 0u;
  const uint32_t original_register = DX9GetRegisterNumber(original_dest);

  std::array<uint32_t, 8u> inserted = {};

  if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT) {
    const uint32_t zero_temp = plan.free_temps[0];

    // Remove only _sat from the original RGB-producing instruction.
    patched_tokens[dest_offset] = original_dest & ~DX9_DEST_SATURATE;

    // rZero.rgb = rColor.rgb - rColor.rgb;  // exact 0 for finite input
    inserted[0] = DX9MakeInstruction(DX9_OP_SUB, 3u);
    inserted[1] = DX9MakeTempDest(
        zero_temp,
        DX9_WRITE_RGB,
        partial_precision);
    inserted[2] = DX9MakeTempSource(original_register);
    inserted[3] = DX9MakeTempSource(original_register);

    // rColor.rgb = max(rColor.rgb, rZero.rgb);
    inserted[4] = DX9MakeInstruction(DX9_OP_MAX, 3u);
    inserted[5] = DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision);
    inserted[6] = DX9MakeTempSource(original_register);
    inserted[7] = DX9MakeTempSource(zero_temp);
  } else if (plan.kind == DX9AutoUnclampPatchKind::DIRECT_OUTPUT) {
    const uint32_t color_temp = plan.free_temps[0];
    const uint32_t zero_temp = plan.free_temps[1];

    // Redirect the original oC0.rgb write into a free temporary and remove
    // only _sat. The original write mask and partial-precision modifier remain.
    patched_tokens[dest_offset] = DX9SetRegister(
        original_dest & ~DX9_DEST_SATURATE,
        DX9_REGISTER_TEMP,
        color_temp);

    inserted[0] = DX9MakeInstruction(DX9_OP_SUB, 3u);
    inserted[1] = DX9MakeTempDest(
        zero_temp,
        DX9_WRITE_RGB,
        partial_precision);
    inserted[2] = DX9MakeTempSource(color_temp);
    inserted[3] = DX9MakeTempSource(color_temp);

    // oC0.rgb = max(rColor.rgb, rZero.rgb);
    inserted[4] = DX9MakeInstruction(DX9_OP_MAX, 3u);
    inserted[5] = original_dest & ~DX9_DEST_SATURATE;
    inserted[6] = DX9MakeTempSource(color_temp);
    inserted[7] = DX9MakeTempSource(zero_temp);
  } else {
    return false;
  }

  patched_tokens.insert(
      patched_tokens.begin() + static_cast<std::ptrdiff_t>(insert_offset),
      inserted.begin(),
      inserted.end());
  return true;
}

uint32_t DX9CRC32(const void* data, size_t size) {
  static const std::array<uint32_t, 256u> TABLE = []() {
    std::array<uint32_t, 256u> table = {};
    for (uint32_t index = 0u; index < table.size(); ++index) {
      uint32_t value = index;
      for (uint32_t bit = 0u; bit < 8u; ++bit) {
        value = (value >> 1u)
            ^ ((value & 1u) != 0u ? 0xEDB88320u : 0u);
      }
      table[index] = value;
    }
    return table;
  }();

  const auto* bytes = static_cast<const uint8_t*>(data);
  uint32_t crc = 0xFFFFFFFFu;
  for (size_t index = 0u; index < size; ++index) {
    crc = TABLE[(crc ^ bytes[index]) & 0xFFu] ^ (crc >> 8u);
  }
  return crc ^ 0xFFFFFFFFu;
}

const char* DX9AutoUnclampKindName(DX9AutoUnclampPatchKind kind) {
  switch (kind) {
    case DX9AutoUnclampPatchKind::SQRT_OUTPUT:
      return "terminal sqrt RGB";
    case DX9AutoUnclampPatchKind::DIRECT_OUTPUT:
      return "direct final RGB";
    default:
      return "none";
  }
}

bool OnCreatePipelineDX9AutoOutputUnclamp(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  (void)layout;

  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9
      || subobjects == nullptr) {
    return false;
  }

  const uint32_t mode = std::clamp(
      static_cast<uint32_t>(std::lround(dx9_auto_output_unclamp_mode)),
      DX9_AUTO_UNCLAMP_OFF,
      DX9_AUTO_UNCLAMP_HEURISTIC_ALL);
  if (mode == DX9_AUTO_UNCLAMP_OFF) return false;

  bool modified = false;

  for (uint32_t subobject_index = 0u;
       subobject_index < subobject_count;
       ++subobject_index) {
    const auto& subobject = subobjects[subobject_index];
    if (subobject.type != reshade::api::pipeline_subobject_type::pixel_shader
        || subobject.count != 1u
        || subobject.data == nullptr) {
      continue;
    }

    auto* shader_desc =
        static_cast<reshade::api::shader_desc*>(subobject.data);
    if (shader_desc->code == nullptr
        || shader_desc->code_size < sizeof(uint32_t) * 2u
        || (shader_desc->code_size % sizeof(uint32_t)) != 0u) {
      continue;
    }

    const auto* source_tokens =
        static_cast<const uint32_t*>(shader_desc->code);
    const size_t token_count =
        shader_desc->code_size / sizeof(uint32_t);
    if (source_tokens[0] != DX9_PS_3_0_VERSION) continue;

    const uint32_t source_crc32 =
        DX9CRC32(shader_desc->code, shader_desc->code_size);
    if (!DX9AutoUnclampModeAllowsHash(mode, source_crc32)) continue;

    std::vector<DX9InstructionInfo> instructions;
    if (!DX9ParseShader(source_tokens, token_count, instructions)) continue;

    const DX9AutoUnclampPlan plan =
        DX9BuildAutoUnclampPlan(source_tokens, instructions, mode);
    if (plan.kind == DX9AutoUnclampPatchKind::NONE) continue;

    std::vector<uint32_t> patched_tokens;
    if (!DX9ApplyAutoUnclampPlan(
            source_tokens,
            token_count,
            instructions,
            plan,
            patched_tokens)) {
      continue;
    }

    // Parse the rebuilt stream once more before passing it to D3D9. This catches
    // malformed token lengths locally and leaves the original shader untouched.
    std::vector<DX9InstructionInfo> validation_instructions;
    if (!DX9ParseShader(
            patched_tokens.data(),
            patched_tokens.size(),
            validation_instructions)) {
      continue;
    }

    const uint64_t cache_key =
        (static_cast<uint64_t>(source_crc32) << 32u)
        | static_cast<uint32_t>(shader_desc->code_size);

    std::scoped_lock lock(g_dx9_auto_unclamp_mutex);
    auto [cache_it, inserted] = g_dx9_auto_unclamp_cache.try_emplace(
        cache_key,
        DX9CachedAutoUnclampShader{
            .source_crc32 = source_crc32,
            .source_size = shader_desc->code_size,
            .kind = plan.kind,
            .bytecode = std::move(patched_tokens),
        });

    // A CRC/size collision is extremely unlikely, but never reuse a cache entry
    // whose recorded source metadata does not match this shader.
    if (!inserted
        && (cache_it->second.source_crc32 != source_crc32
            || cache_it->second.source_size != shader_desc->code_size)) {
      continue;
    }

    shader_desc->code = cache_it->second.bytecode.data();
    shader_desc->code_size =
        cache_it->second.bytecode.size() * sizeof(uint32_t);
    modified = true;

    if (inserted) {
      if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT) {
        ++g_dx9_auto_unclamp_sqrt_count;
      } else if (plan.kind == DX9AutoUnclampPatchKind::DIRECT_OUTPUT) {
        ++g_dx9_auto_unclamp_direct_count;
      }

      if (g_dx9_auto_unclamp_log_count < 64u) {
        ++g_dx9_auto_unclamp_log_count;
        std::stringstream stream;
        stream << "[RenoDX DX9 Auto Unclamp] Patched 0x";
        stream << std::uppercase << std::hex << std::setw(8)
               << std::setfill('0') << source_crc32;
        stream << std::dec << " (";
        stream << DX9AutoUnclampKindName(plan.kind);
        stream << ", mode=" << mode;
        stream << ", totals: sqrt=" << g_dx9_auto_unclamp_sqrt_count;
        stream << ", direct=" << g_dx9_auto_unclamp_direct_count;
        stream << ")";
        reshade::log::message(
            reshade::log::level::info,
            stream.str().c_str());
      }
    }
  }

  return modified;
}

void ClearDX9AutoOutputUnclampCache() {
  std::scoped_lock lock(g_dx9_auto_unclamp_mutex);
  g_dx9_auto_unclamp_cache.clear();
}

// ============================================================================
// D3D9 cloned-resource copy/readback fix
// ============================================================================
//
// ReShade reports IDirect3DDevice9::GetRenderTargetData through copy_resource.
// It reports UpdateSurface/StretchRect through copy_texture_region, and some
// StretchRect/MSAA paths through resolve_texture_region.
//
// The game may create an 8-bit system-memory surface and read an upgraded
// R16G16B16A16_FLOAT scene/swapchain clone into it. D3D9 cannot directly copy
// between those different formats. The original call can therefore fail and
// leave the destination black or unchanged.
//
// This handler:
//   1. Chains GPU copies through matching RenoDX clones when both sides have one.
//   2. For a float16 -> 8-bit CPU readback, first reads the float clone into a
//      matching CPU-visible float16 staging surface.
//   3. Converts that staging image into the game's original 8-bit destination.
//   4. Returns true only after fully replacing the incompatible original copy.
//
// The CPU fallback is intentionally restricted to D3D9, full-surface copies,
// equal dimensions, R16G16B16A16_FLOAT sources and common 32-bit SDR formats.

constexpr bool DX9_READBACK_FIX_ENABLED = true;

// RenoDX's scRGB/HDR clone is normally linear. Enable this to hand the game a
// conventional SDR/screenshot-like nonlinear representation.
constexpr bool DX9_READBACK_ENCODE_SRGB = true;

// Preserve the source alpha by default. Change to true only if the game's
// readback consumer requires an opaque X8/A8 surface.
constexpr bool DX9_READBACK_FORCE_OPAQUE_ALPHA = false;

thread_local bool g_inside_dx9_replacement_copy = false;

uint32_t g_dx9_readback_success_logs = 0;
uint32_t g_dx9_readback_failure_logs = 0;
uint32_t g_dx9_chain_logs = 0;

struct ScopedDX9ReplacementCopy {
  ScopedDX9ReplacementCopy() { g_inside_dx9_replacement_copy = true; }
  ~ScopedDX9ReplacementCopy() { g_inside_dx9_replacement_copy = false; }

  ScopedDX9ReplacementCopy(const ScopedDX9ReplacementCopy&) = delete;
  ScopedDX9ReplacementCopy& operator=(const ScopedDX9ReplacementCopy&) = delete;
};

struct DX9CopyEndpoint {
  reshade::api::resource input = {0u};
  reshade::api::resource original = {0u};
  reshade::api::resource clone = {0u};

  reshade::api::resource_desc input_desc = {};
  reshade::api::resource_desc original_desc = {};
  reshade::api::resource_desc clone_desc = {};

  bool has_live_tracking = false;
  bool has_clone = false;
  bool input_is_clone = false;
  bool clone_enabled = false;
};

bool IsTextureResource(const reshade::api::resource_desc& desc) {
  return desc.type == reshade::api::resource_type::surface
      || desc.type == reshade::api::resource_type::texture_1d
      || desc.type == reshade::api::resource_type::texture_2d
      || desc.type == reshade::api::resource_type::texture_3d;
}

bool SameTextureExtent(const reshade::api::resource_desc& left,
                       const reshade::api::resource_desc& right) {
  if (!IsTextureResource(left) || !IsTextureResource(right)) return false;

  return left.texture.width == right.texture.width
      && left.texture.height == right.texture.height
      && left.texture.depth_or_layers == right.texture.depth_or_layers;
}

bool ExactCopyCompatible(const reshade::api::resource_desc& source_desc,
                         const reshade::api::resource_desc& dest_desc) {
  if (source_desc.type != dest_desc.type) return false;
  if (!SameTextureExtent(source_desc, dest_desc)) return false;

  return source_desc.texture.format == dest_desc.texture.format
      && source_desc.texture.levels == dest_desc.texture.levels
      && source_desc.texture.samples == dest_desc.texture.samples;
}

DX9CopyEndpoint ResolveDX9CopyEndpoint(
    reshade::api::device* device,
    reshade::api::resource input) {
  DX9CopyEndpoint endpoint = {};
  endpoint.input = input;
  endpoint.original = input;

  if (device == nullptr || input.handle == 0u) return endpoint;

  endpoint.input_desc =
      renodx::utils::resource::GetResourceDesc(device, input);
  endpoint.original_desc = endpoint.input_desc;

  endpoint.has_live_tracking =
      renodx::utils::resource::GetLiveResourceInfo(
          input,
          [&](const renodx::utils::resource::ResourceInfo& info) {
            endpoint.original =
                info.resource.handle != 0u ? info.resource : input;
            endpoint.original_desc =
                info.desc.type != reshade::api::resource_type::unknown
                    ? info.desc
                    : endpoint.input_desc;

            endpoint.clone = info.clone;
            endpoint.clone_desc = info.clone_desc;
            endpoint.has_clone =
                info.clone.handle != 0u
                && info.clone_desc.type
                    != reshade::api::resource_type::unknown;
            endpoint.input_is_clone = info.is_clone;
            endpoint.clone_enabled = info.clone_enabled;
          });

  // RenoDX generally tracks the parent/original entry. If ReShade gives this
  // callback the clone handle itself, locate the parent whose clone matches it.
  if (!endpoint.has_clone || endpoint.input_is_clone) {
    bool found_parent = false;
    renodx::utils::resource::ForEachResourceInfo(
        [&](const renodx::utils::resource::ResourceInfo& info) {
          if (found_parent) return;
          if (info.destroyed || info.clone.handle != input.handle) return;

          found_parent = true;
          endpoint.has_live_tracking = true;
          endpoint.input_is_clone = true;
          endpoint.original = info.resource;
          endpoint.original_desc = info.desc;
          endpoint.clone = input;
          endpoint.clone_desc =
              info.clone_desc.type != reshade::api::resource_type::unknown
                  ? info.clone_desc
                  : endpoint.input_desc;
          endpoint.has_clone = true;
          endpoint.clone_enabled = info.clone_enabled;
        });
  }

  return endpoint;
}

reshade::api::resource SelectCloneForCopy(const DX9CopyEndpoint& endpoint) {
  if (endpoint.has_clone && endpoint.clone.handle != 0u) {
    return endpoint.clone;
  }
  return endpoint.input;
}

reshade::api::resource_desc SelectCloneDescForCopy(
    const DX9CopyEndpoint& endpoint) {
  if (endpoint.has_clone
      && endpoint.clone_desc.type
          != reshade::api::resource_type::unknown) {
    return endpoint.clone_desc;
  }
  return endpoint.input_desc;
}

bool IsFloat16RGBA(reshade::api::format format) {
  return format == reshade::api::format::r16g16b16a16_float;
}

bool IsSupportedSDRReadbackFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
    case reshade::api::format::r8g8b8a8_unorm:
    case reshade::api::format::r8g8b8a8_unorm_srgb:
    case reshade::api::format::r8g8b8x8_unorm:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

bool IsBGRAReadbackFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

bool IsX8ReadbackFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
    case reshade::api::format::r8g8b8x8_unorm:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

bool IsCPUVisibleReadbackHeap(reshade::api::memory_heap heap) {
  return heap == reshade::api::memory_heap::gpu_to_cpu
      || heap == reshade::api::memory_heap::cpu_only;
}

float HalfToFloat(uint16_t value) {
  const uint32_t sign = (value >> 15u) & 0x1u;
  const uint32_t exponent = (value >> 10u) & 0x1Fu;
  const uint32_t mantissa = value & 0x3FFu;

  float result = 0.0f;

  if (exponent == 0u) {
    // Half subnormal: mantissa / 1024 * 2^-14 = mantissa * 2^-24.
    result = std::ldexp(static_cast<float>(mantissa), -24);
  } else if (exponent == 0x1Fu) {
    if (mantissa == 0u) {
      result = std::numeric_limits<float>::infinity();
    } else {
      result = std::numeric_limits<float>::quiet_NaN();
    }
  } else {
    result = std::ldexp(
        1.0f + static_cast<float>(mantissa) / 1024.0f,
        static_cast<int>(exponent) - 15);
  }

  return sign != 0u ? -result : result;
}

float SanitizeUnit(float value) {
  if (!std::isfinite(value)) return 0.0f;
  return std::clamp(value, 0.0f, 1.0f);
}

float LinearToSRGB(float linear) {
  linear = SanitizeUnit(linear);

  if (linear <= 0.0031308f) {
    return 12.92f * linear;
  }

  return 1.055f * std::pow(linear, 1.0f / 2.4f) - 0.055f;
}

uint8_t FloatToUNorm8(float value, bool encode_srgb) {
  value = encode_srgb ? LinearToSRGB(value) : SanitizeUnit(value);
  return static_cast<uint8_t>(
      std::clamp(
          static_cast<int>(std::lround(value * 255.0f)),
          0,
          255));
}

void WriteSDRPixel(
    uint8_t* dest,
    reshade::api::format dest_format,
    float red,
    float green,
    float blue,
    float alpha) {
  const uint8_t r = FloatToUNorm8(red, DX9_READBACK_ENCODE_SRGB);
  const uint8_t g = FloatToUNorm8(green, DX9_READBACK_ENCODE_SRGB);
  const uint8_t b = FloatToUNorm8(blue, DX9_READBACK_ENCODE_SRGB);

  const bool force_opaque =
      DX9_READBACK_FORCE_OPAQUE_ALPHA
      || IsX8ReadbackFormat(dest_format);

  const uint8_t a =
      force_opaque ? 255u : FloatToUNorm8(alpha, false);

  if (IsBGRAReadbackFormat(dest_format)) {
    dest[0] = b;
    dest[1] = g;
    dest[2] = r;
    dest[3] = a;
  } else {
    dest[0] = r;
    dest[1] = g;
    dest[2] = b;
    dest[3] = a;
  }
}

void LogDX9ReadbackFailure(
    const char* reason,
    const reshade::api::resource_desc& source_desc,
    const reshade::api::resource_desc& dest_desc) {
  if (g_dx9_readback_failure_logs >= 8u) return;
  ++g_dx9_readback_failure_logs;

  std::stringstream stream;
  stream << "[RenoDX DX9 Readback] " << reason;
  stream << " (source: " << source_desc.texture.format;
  stream << ", destination: " << dest_desc.texture.format;
  stream << ", size: " << source_desc.texture.width;
  stream << "x" << source_desc.texture.height << ")";
  reshade::log::message(
      reshade::log::level::warning,
      stream.str().c_str());
}

bool TryChainDX9CopyResource(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    const DX9CopyEndpoint& dest_endpoint) {
  if (!source_endpoint.has_clone || !dest_endpoint.has_clone) return false;

  const reshade::api::resource selected_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource selected_dest =
      SelectCloneForCopy(dest_endpoint);

  if (selected_source.handle == 0u || selected_dest.handle == 0u) return false;

  // Nothing to replace if the application already supplied both clone handles.
  if (selected_source.handle == source_endpoint.input.handle
      && selected_dest.handle == dest_endpoint.input.handle) {
    return false;
  }

  const reshade::api::resource_desc selected_source_desc =
      SelectCloneDescForCopy(source_endpoint);
  const reshade::api::resource_desc selected_dest_desc =
      SelectCloneDescForCopy(dest_endpoint);

  if (!ExactCopyCompatible(
          selected_source_desc,
          selected_dest_desc)) {
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_resource(selected_source, selected_dest);
  }

  if (g_dx9_chain_logs < 8u) {
    ++g_dx9_chain_logs;
    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] Chained copy_resource through clones: ";
    stream << selected_source_desc.texture.format;
    stream << " -> " << selected_dest_desc.texture.format;
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}

bool TryRedirectDX9CloneReadbackToOriginal(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    reshade::api::resource dest,
    const reshade::api::resource_desc& dest_desc) {
  if (!source_endpoint.input_is_clone) return false;
  if (source_endpoint.original.handle == 0u
      || source_endpoint.original.handle
          == source_endpoint.input.handle) {
    return false;
  }
  if (!IsCPUVisibleReadbackHeap(dest_desc.heap)) return false;
  if (!ExactCopyCompatible(
          source_endpoint.original_desc,
          dest_desc)) {
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_resource(source_endpoint.original, dest);
  }

  if (g_dx9_chain_logs < 8u) {
    ++g_dx9_chain_logs;
    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] Redirected clone readback to its ";
    stream << "matching original SDR resource (";
    stream << source_endpoint.original_desc.texture.format;
    stream << " -> " << dest_desc.texture.format << ")";
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}

bool TryConvertDX9FloatReadbackToSDR(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    reshade::api::resource dest,
    const reshade::api::resource_desc& dest_desc) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (device == nullptr) return false;

  const reshade::api::resource float_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource_desc float_source_desc =
      SelectCloneDescForCopy(source_endpoint);

  if (float_source.handle == 0u) return false;
  if (!IsTextureResource(float_source_desc)
      || !IsTextureResource(dest_desc)) {
    return false;
  }
  if (!IsFloat16RGBA(float_source_desc.texture.format)) return false;
  if (!IsSupportedSDRReadbackFormat(dest_desc.texture.format)) return false;
  if (!IsCPUVisibleReadbackHeap(dest_desc.heap)) return false;
  if (!SameTextureExtent(float_source_desc, dest_desc)) return false;
  if (float_source_desc.texture.depth_or_layers != 1u
      || dest_desc.texture.depth_or_layers != 1u) {
    return false;
  }
  if (float_source_desc.texture.samples != 1u
      || dest_desc.texture.samples != 1u) {
    return false;
  }

  // GetRenderTargetData is a whole-surface operation, so make a matching
  // CPU-visible float surface first. Its format matches the cloned source,
  // allowing D3D9 to perform the GPU readback legally.
  reshade::api::resource_desc staging_desc = float_source_desc;
  staging_desc.heap = reshade::api::memory_heap::gpu_to_cpu;
  staging_desc.usage = reshade::api::resource_usage::copy_dest;
  staging_desc.flags = {};
  staging_desc.texture.depth_or_layers = 1u;
  staging_desc.texture.levels = 1u;
  staging_desc.texture.samples = 1u;

  reshade::api::resource staging = {0u};
  if (!device->create_resource(
          staging_desc,
          nullptr,
          reshade::api::resource_usage::copy_dest,
          &staging)) {
    LogDX9ReadbackFailure(
        "Could not create the float16 CPU staging surface",
        float_source_desc,
        dest_desc);
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_resource(float_source, staging);
  }

  reshade::api::subresource_data source_data = {};
  if (!device->map_texture_region(
          staging,
          0u,
          nullptr,
          reshade::api::map_access::read_only,
          &source_data)) {
    device->destroy_resource(staging);
    LogDX9ReadbackFailure(
        "Could not map the float16 CPU staging surface",
        float_source_desc,
        dest_desc);
    return false;
  }

  reshade::api::subresource_data dest_data = {};
  if (!device->map_texture_region(
          dest,
          0u,
          nullptr,
          reshade::api::map_access::write_only,
          &dest_data)) {
    device->unmap_texture_region(staging, 0u);
    device->destroy_resource(staging);
    LogDX9ReadbackFailure(
        "Could not map the game's 8-bit readback surface",
        float_source_desc,
        dest_desc);
    return false;
  }

  const uint32_t width = float_source_desc.texture.width;
  const uint32_t height = float_source_desc.texture.height;

  const auto* source_base =
      static_cast<const uint8_t*>(source_data.data);
  auto* dest_base =
      static_cast<uint8_t*>(dest_data.data);

  for (uint32_t y = 0u; y < height; ++y) {
    const auto* source_row =
        source_base + static_cast<size_t>(y) * source_data.row_pitch;
    auto* dest_row =
        dest_base + static_cast<size_t>(y) * dest_data.row_pitch;

    for (uint32_t x = 0u; x < width; ++x) {
      const auto* source_pixel =
          reinterpret_cast<const uint16_t*>(
              source_row + static_cast<size_t>(x) * 8u);
      auto* dest_pixel =
          dest_row + static_cast<size_t>(x) * 4u;

      WriteSDRPixel(
          dest_pixel,
          dest_desc.texture.format,
          HalfToFloat(source_pixel[0]),
          HalfToFloat(source_pixel[1]),
          HalfToFloat(source_pixel[2]),
          HalfToFloat(source_pixel[3]));
    }
  }

  device->unmap_texture_region(dest, 0u);
  device->unmap_texture_region(staging, 0u);
  device->destroy_resource(staging);

  if (g_dx9_readback_success_logs < 8u) {
    ++g_dx9_readback_success_logs;

    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] Replaced incompatible float16 -> SDR ";
    stream << "GetRenderTargetData copy (";
    stream << float_source_desc.texture.format;
    stream << " -> " << dest_desc.texture.format;
    stream << ", " << width << "x" << height << ")";
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}

bool OnDX9CopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {
  if (!DX9_READBACK_FIX_ENABLED
      || g_inside_dx9_replacement_copy
      || cmd_list == nullptr
      || source.handle == 0u
      || dest.handle == 0u) {
    return false;
  }

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return false;
  }

  const DX9CopyEndpoint source_endpoint =
      ResolveDX9CopyEndpoint(device, source);
  const DX9CopyEndpoint dest_endpoint =
      ResolveDX9CopyEndpoint(device, dest);

  // First handle normal GPU scratch copies where both original resources were
  // cloned/upgraded. This is the D3D9 equivalent of resource chaining.
  if (TryChainDX9CopyResource(
          cmd_list,
          source_endpoint,
          dest_endpoint)) {
    return true;
  }

  // Then handle GetRenderTargetData. If ReShade supplied the clone handle
  // directly and RenoDX still has a matching original SDR surface, prefer that
  // zero-conversion path before falling back to CPU float16 -> 8-bit conversion.
  const reshade::api::resource_desc dest_desc =
      renodx::utils::resource::GetResourceDesc(device, dest);

  if (TryRedirectDX9CloneReadbackToOriginal(
          cmd_list,
          source_endpoint,
          dest,
          dest_desc)) {
    return true;
  }

  if (TryConvertDX9FloatReadbackToSDR(
          cmd_list,
          source_endpoint,
          dest,
          dest_desc)) {
    return true;
  }

  return false;
}

bool OnDX9CopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {
  if (!DX9_READBACK_FIX_ENABLED
      || g_inside_dx9_replacement_copy
      || cmd_list == nullptr
      || source.handle == 0u
      || dest.handle == 0u) {
    return false;
  }

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return false;
  }

  const DX9CopyEndpoint source_endpoint =
      ResolveDX9CopyEndpoint(device, source);
  const DX9CopyEndpoint dest_endpoint =
      ResolveDX9CopyEndpoint(device, dest);

  if (!source_endpoint.has_clone || !dest_endpoint.has_clone) return false;

  const reshade::api::resource selected_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource selected_dest =
      SelectCloneForCopy(dest_endpoint);

  const reshade::api::resource_desc selected_source_desc =
      SelectCloneDescForCopy(source_endpoint);
  const reshade::api::resource_desc selected_dest_desc =
      SelectCloneDescForCopy(dest_endpoint);

  // The original source/destination boxes remain valid only when cloning kept
  // each resource's dimensions unchanged.
  if (!SameTextureExtent(
          source_endpoint.original_desc,
          selected_source_desc)
      || !SameTextureExtent(
          dest_endpoint.original_desc,
          selected_dest_desc)
      || selected_source_desc.texture.format
          != selected_dest_desc.texture.format) {
    return false;
  }

  if (selected_source.handle == source.handle
      && selected_dest.handle == dest.handle) {
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_texture_region(
        selected_source,
        source_subresource,
        source_box,
        selected_dest,
        dest_subresource,
        dest_box,
        filter);
  }

  return true;
}

bool OnDX9ResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    uint32_t dest_x,
    uint32_t dest_y,
    uint32_t dest_z,
    reshade::api::format format) {
  if (!DX9_READBACK_FIX_ENABLED
      || g_inside_dx9_replacement_copy
      || cmd_list == nullptr
      || source.handle == 0u
      || dest.handle == 0u) {
    return false;
  }

  (void)format;

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return false;
  }

  const DX9CopyEndpoint source_endpoint =
      ResolveDX9CopyEndpoint(device, source);
  const DX9CopyEndpoint dest_endpoint =
      ResolveDX9CopyEndpoint(device, dest);

  if (!source_endpoint.has_clone || !dest_endpoint.has_clone) return false;

  const reshade::api::resource selected_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource selected_dest =
      SelectCloneForCopy(dest_endpoint);

  const reshade::api::resource_desc selected_source_desc =
      SelectCloneDescForCopy(source_endpoint);
  const reshade::api::resource_desc selected_dest_desc =
      SelectCloneDescForCopy(dest_endpoint);

  if (!SameTextureExtent(
          source_endpoint.original_desc,
          selected_source_desc)
      || !SameTextureExtent(
          dest_endpoint.original_desc,
          selected_dest_desc)
      || selected_source_desc.texture.format
          != selected_dest_desc.texture.format) {
    return false;
  }

  if (selected_source.handle == source.handle
      && selected_dest.handle == dest.handle) {
    return false;
  }

  const reshade::api::format selected_format =
      selected_dest_desc.texture.format;

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->resolve_texture_region(
        selected_source,
        source_subresource,
        source_box,
        selected_dest,
        dest_subresource,
        dest_x,
        dest_y,
        dest_z,
        selected_format);
  }

  return true;
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "DX9AutoOutputUnclamp",
        .binding = &dx9_auto_output_unclamp_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = true,
        .label = "Automatic Output Unclamp",
        .section = "HDR Pipeline",
        .tooltip = "Default patches only allowlisted post-process and sky/cloud "
                   "shaders. Model/material lighting is experimental because "
                   "the same terminal clamp pattern is also used by special or "
                   "intermediate passes. Heuristic modes may break characters, "
                   "weapons, shadows, and textures. Requires a game restart "
                   "after changing.",
        .labels = {
            "Off",
            "Curated post + sky",
            "Curated + model lighting (experimental)",
            "Heuristic sqrt outputs (unsafe)",
            "Heuristic sqrt + direct (unsafe)",
        },
        .is_global = true,
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT", "PsychoV22"},
        .parse = [](float value) {
          if (value < 0.5f) return TONE_MAP_TYPE_VANILLA;
          if (value < 1.5f) return TONE_MAP_TYPE_RENODRT;
          return TONE_MAP_TYPE_PSYCHOV22;
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
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
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return IsRenoDRTEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22Compression",
        .binding = &shader_injection.psychov22_compression,
        .default_value = 0.f,
        .label = "PsychoV22 Compression",
        .section = "Color Grading",
        .tooltip = "PsychoV22 shoulder curve. 0 = auto compression, 50 = 1.00, 100 = 2.00, 200 = 4.00.",
        .min = 0.f,
        .max = 400.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22ConeResponse",
        .binding = &shader_injection.psychov22_cone_response,
        .default_value = 50.f,
        .label = "PsychoV22 Cone Response",
        .section = "Color Grading",
        .tooltip = "Scales PsychoV22 cone response. 50 = 1.00 neutral. Higher values increase PsychoV22 contrast/purity response.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22GamutCompression",
        .binding = &shader_injection.psychov22_gamut_compression,
        .default_value = 100.f,
        .label = "PsychoV22 Gamut Compression",
        .section = "Color Grading",
        .tooltip = "PsychoV22 gamut compression strength.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV22GamutMode",
        .binding = &shader_injection.psychov22_gamut_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "PsychoV22 Gamut Mode",
        .section = "Color Grading",
        .labels = {"BT709", "BT2020"},
        .is_enabled = []() { return IsPsychoV22Enabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 60.f,
        .label = "FPS Limit",
        .section = "FPS Limit",
        .min = 30.f,
        .max = 500.f,
        .parse = [](float value) { return value * 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
};

const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
    /* {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
    {"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
    {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
    {"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
    {"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
    {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
    {"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
    {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
    {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
    {"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
    {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
    {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless}, */
};

void OnPresetOff() {
  //   renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  //   renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  //   renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  //   renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  //   renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  //   renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  if (device->get_api() == reshade::api::device_api::opengl) {
    shader_injection.custom_flip_uv_y = 1.f;
  }
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Generic)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::constant_buffer_offset = 50 * 4; 
        renodx::mods::swapchain::set_color_space = false; 
        renodx::mods::swapchain::use_device_proxy = true;
          renodx::mods::swapchain::use_resource_cloning = true;
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

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainForceBorderless",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Force Borderless",
              .section = "Display Output",
              .tooltip = "Forces fullscreen to be borderless for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainPreventFullscreen",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Prevent Fullscreen",
              .section = "Display Output",
              .tooltip = "Prevent exclusive fullscreen for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 5.f,
              .label = "Encoding",
              .section = "Display Output",
              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},
              .is_enabled = []() { return IsCustomToneMapperEnabled(); },
              .on_change_value = [](float previous, float current) {
                ApplySwapChainEncoding(current);
              },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          ApplySwapChainEncoding(setting->GetValue());
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxy",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Use Display Proxy",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy = setting->GetValue() == 1.f;
          renodx::mods::swapchain::use_device_proxy = use_device_proxy;
          renodx::mods::swapchain::set_color_space = !use_device_proxy;
          if (use_device_proxy) {
            reshade::register_event<reshade::addon_event::present>(OnPresent);
          } else {
            shader_injection.custom_flip_uv_y = 0.f;
          }
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyBaseWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Base Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::device_proxy_wait_idle_source =
              (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyProxyWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Proxy Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::device_proxy_wait_idle_destination =
              (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        for (const auto& [key, format] : UPGRADE_TARGETS) {
          auto* setting = new renodx::utils::settings::Setting{
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
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          settings.push_back(setting);

          auto value = setting->GetValue();
          if (value > 0) {
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
                .old_format = format,
                .new_format = reshade::api::format::r16g16b16a16_float,
                .ignore_size = (value == UPGRADE_TYPE_ANY),
                .use_resource_view_cloning = true,
                .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
                                                       ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                       : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
                .usage_include = reshade::api::resource_usage::render_target,
            });
            std::stringstream s;
            s << "Applying user resource upgrade for ";
            s << format << ": " << value;
            reshade::log::message(reshade::log::level::info, s.str().c_str());
          }
        }
       
        // Upgrade only render-target resources and keep resource-view cloning
        // enabled so clears, RTVs and SRV variants continue to reference the same
        // upgraded resource.
       
        // Keep B8G8R8A8 upgrades restricted to the known 960x540 target.
        // The old unrestricted B8G8R8A8_UNORM rule matched every UI and overlay
        // surface and made this size restriction ineffective.
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
             .ignore_size = false,
              .use_resource_view_cloning = true,
              .use_resource_view_hot_swap = false,
              .aspect_ratio = 16.f / 9.f,
              .aspect_ratio_tolerance = 0.001f,
              .usage_include = reshade::api::resource_usage::render_target,
              .name = "Scene Intermediate",
        }); 

        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::r16g16b16a16_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
             .ignore_size = false,
              .use_resource_view_cloning = true,
              .use_resource_view_hot_swap = false,
              .aspect_ratio = 16.f / 9.f,
              .aspect_ratio_tolerance = 0.001f,
              .usage_include = reshade::api::resource_usage::render_target,
              .name = "Scene Intermediate",
        }); 



     
    
        
        // D3D9 copy/readback interception. These callbacks are ignored for the
        // D3D11/D3D12 display-proxy side and are recursion-guarded internally.
        reshade::register_event<reshade::addon_event::copy_resource>(
            OnDX9CopyResource);
        reshade::register_event<reshade::addon_event::copy_texture_region>(
            OnDX9CopyTextureRegion);
        reshade::register_event<reshade::addon_event::resolve_texture_region>(
            OnDX9ResolveTextureRegion);

        initialized = true;
      }
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::create_pipeline>(
          OnCreatePipelineDX9AutoOutputUnclamp);
      ClearDX9AutoOutputUnclampCache();
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(
          OnDX9ResolveTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(
          OnDX9CopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_resource>(
          OnDX9CopyResource);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  // Register after RenoDX's shader module so hash-based embedded replacements
  // are resolved first and this patcher only sees the final ps_3_0 bytecode.
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::create_pipeline>(
        OnCreatePipelineDX9AutoOutputUnclamp);
  }

  return TRUE;
}
