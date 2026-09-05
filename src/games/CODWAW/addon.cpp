/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define RENODX_MODS_SWAPCHAIN_VERSION 2
#define CODWAW_DX9_READBACK_CACHE_OPTIMIZED 1
#define CODWAW_DX9_GPU_READBACK_BLIT 1
#define RENODX_FPS_LIMIT_HR_TIMER
#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include <Windows.h>
#include <d3d9.h>

#include <embed/shaders.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iomanip>
#include <iterator>
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

#ifndef RENODX_PSYCHO_SLIDER_LAYOUT_VERSION
#error "CODWAW: shared.h is missing the Psycho slider layout from this package."
#endif
#ifndef RENODX_PRAGMAP_SLIDER_LAYOUT_VERSION
#error "CODWAW: shared.h is missing the Pragmap slider layout from this package."
#endif

namespace {
// UpgradeRTV clone-hot-swap helper macros removed.
// They were defined but never used by this addon's shader table.

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000),
    __ALL_CUSTOM_SHADERS,
    
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;
#if 0  // Automatic DX9 output unclamper disabled
float dx9_auto_output_unclamp_mode = 2.f;
#endif
float force_windowed_borderless = 1.f;

constexpr float TONE_MAP_TYPE_VANILLA = 0.f;
constexpr float TONE_MAP_TYPE_RENODRT = 3.f;
constexpr float TONE_MAP_TYPE_PSYCHO = 24.f;
constexpr float TONE_MAP_TYPE_PRAGMAP = 31.f;

inline bool IsCustomToneMapperEnabled() {
  return shader_injection.tone_map_type != TONE_MAP_TYPE_VANILLA;
}

inline bool IsRenoDRTEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_RENODRT;
}

inline bool IsPsychoEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_PSYCHO;
}

inline bool IsPragmapEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_PRAGMAP;
}

void ApplySwapChainEncoding(float value) {
  const bool is_hdr10 = value == 4.f;

  renodx::mods::swapchain::SetUseHDR10(is_hdr10);
  renodx::mods::swapchain::use_resize_buffer = value < 4.f;
  shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
}


#if 0  // Automatic DX9 output unclamper disabled; CPU blit/readback remains enabled
// ============================================================================
// Guarded D3D9 terminal output unclamping
// ============================================================================
//
// A terminal sqrt(saturate(...)) sequence is not enough to prove that a shader
// writes final scene color. BO1 uses the same encoding pattern in surface,
// character, weapon, fog, sky, shadow-adjacent, and packed/intermediate passes.
// Blindly patching all matches can expose black skybox borders, remove fog
// masking, flatten object shading, or corrupt packed textures.
//
// Fog/sky hashes are therefore hard-blocked in every mode. Curated post-process
// shaders retain the original full unclamp. Explicitly known weapon/viewmodel
// lighting shaders also receive the full terminal unclamp: their earlier
// material, normal, shadow, attenuation, and visibility saturations remain
// untouched, so only the final HDR ceiling is removed.
//
// Level 3 applies the same terminal-only highlight unclamp as the supplied
// weapon HLSL examples to every accepted viewmodel and world geometry-lighting
// shader:
//
//   sqrt(saturate(finalLighting)) -> sqrt(max(finalLighting, 0))
//
// No brightness multiplier is added, and no earlier material, texture, BRDF,
// shadow, attenuation, fog, color, or intermediate saturation is changed.
// Simple fog, sky, copy, LUT, and blend-only shaders are rejected. Level 4 is a
// safe alias of level 3 instead of enabling a broader destructive scan.
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
constexpr uint32_t DX9_REGISTER_INPUT = 1u;
constexpr uint32_t DX9_REGISTER_COLOR_OUTPUT = 8u;
constexpr uint32_t DX9_REGISTER_SAMPLER = 10u;

constexpr uint32_t DX9_DCL_USAGE_MASK = 0x0000001Fu;
constexpr uint32_t DX9_DCL_USAGE_INDEX_MASK = 0x000F0000u;
constexpr uint32_t DX9_DCL_USAGE_INDEX_SHIFT = 16u;
constexpr uint32_t DX9_DECL_USAGE_TEXCOORD = 5u;
constexpr uint32_t DX9_DECL_USAGE_COLOR = 10u;

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

// Known final post-process output shaders. Sky/cloud entries are intentionally
// excluded: unclamping them can reveal black texture borders or defeat fog masks.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_POST_ALLOWLIST = {
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
    0x93610C4Cu,  // LUT pass: strict matcher currently leaves it unchanged.
    0xC9558BEFu,
    0xCAB1BCB8u,
};

// Exact known weapon/viewmodel-lighting shaders available to the curated model
// mode. These receive the full terminal unclamp rather than the guarded scanner
// path. Only the final output saturation is removed; all earlier BRDF, shadow,
// attenuation, fog, and material masks stay exactly as authored by the game.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST = {
    0xBACB9CF2u,  // Weapon/viewmodel spotlight lighting.
    0xCDCD3EAEu,  // Related weapon/viewmodel lighting variant.
};

// Exact weapon/viewmodel examples that must be fully unclamped by level 3.
// These shaders end with the equivalent of:
//
//   output = sqrt(saturate(finalLighting * hdrControl.x));
//
// Level 3 rewrites only that terminal expression to:
//
//   output = sqrt(max(finalLighting * hdrControl.x, 0));
//
// This is the same transformation used by the supplied HLSL examples. It does
// not remove any earlier material, normal, shadow, attenuation, fog, or BRDF
// clamps. Exact hashes bypass the guarded geometry reconstruction.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_LEVEL3_VIEWMODEL_ALLOWLIST = {
    0x44B59D36u,  // weapon2: final mul_sat + sqrt output.
    0xBACB9CF2u,  // weapon1: final mul_sat + sqrt output.
    0xCDCD3EAEu,  // related weapon/viewmodel lighting variant.
    0xE07AC027u,  // weapon3: final mul_sat + sqrt output.
};

// Known sky/cloud passes enabled only for the level-3/4 sky test. They remain
// blocked in curated modes and are still limited to the strict terminal sqrt
// rewrite; direct oC0 rewrites remain disabled for them.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_LEVEL3_SKY_TEST_ALLOWLIST = {
    0x94BC7D3Eu,
    0xDAC6E2D9u,
};

// Add confirmed fog, packed-data, or special-effect hashes here. The two known
// sky hashes above are intentionally not in this permanent denylist so level 3
// can test them through the strict terminal-only path.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_DENYLIST = {
    // 0x00000000u,
};

bool DX9AutoUnclampModeAllowsHash(uint32_t mode, uint32_t hash) {
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(hash)) return false;
  if (DX9_AUTO_UNCLAMP_LEVEL3_SKY_TEST_ALLOWLIST.contains(hash)
      && mode < DX9_AUTO_UNCLAMP_HEURISTIC_SQRT) {
    return false;
  }

  switch (mode) {
    case DX9_AUTO_UNCLAMP_CURATED_POST_SKY:
      return DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(hash);

    case DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL:
      return DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(hash)
          || DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST.contains(hash);

    case DX9_AUTO_UNCLAMP_HEURISTIC_SQRT:
    case DX9_AUTO_UNCLAMP_HEURISTIC_ALL:
      return true;

    default:
      return false;
  }
}

bool DX9AutoUnclampModeAllowsDirectOutput(uint32_t mode, uint32_t hash) {
  (void)mode;
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(hash)) return false;

  // A broad direct oC0 saturation rewrite can remove material/fog masks and was
  // responsible for the flat, unshaded appearance in the old level 4. Keep this
  // path strictly hash-curated in every mode. Automatic scanning is limited to
  // terminal sqrt chains, where only the final highlight ceiling is touched.
  return DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(hash);
}

enum class DX9AutoUnclampPatchKind : uint32_t {
  NONE = 0u,
  SQRT_OUTPUT,
  SQRT_OUTPUT_GUARDED,
  DIRECT_OUTPUT,
};

struct DX9InstructionInfo {
  size_t token_offset = 0u;
  uint16_t opcode = 0u;
  uint8_t operand_count = 0u;
  uint32_t instruction_token = 0u;
};

struct DX9ShaderStats {
  uint32_t texture_samples = 0u;
  uint32_t dot_products = 0u;
  uint32_t multiplies = 0u;
  uint32_t multiply_adds = 0u;
  uint32_t adds = 0u;
  uint32_t lerps = 0u;
  uint32_t compares = 0u;

  uint32_t input_declarations = 0u;
  uint32_t texcoord_declaration_mask = 0u;
  uint32_t sampler_declaration_mask = 0u;
  bool declares_color0 = false;
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
uint32_t g_dx9_auto_unclamp_guarded_count = 0u;
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

DX9ShaderStats DX9CollectShaderStats(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions) {
  DX9ShaderStats stats = {};

  for (const auto& instruction : instructions) {
    switch (instruction.opcode) {
      case DX9_OP_TEXLD:
        ++stats.texture_samples;
        break;
      case DX9_OP_DP3:
      case DX9_OP_DP4:
        ++stats.dot_products;
        break;
      case DX9_OP_MUL:
        ++stats.multiplies;
        break;
      case DX9_OP_MAD:
        ++stats.multiply_adds;
        break;
      case DX9_OP_ADD:
      case DX9_OP_SUB:
        ++stats.adds;
        break;
      case DX9_OP_LRP:
        ++stats.lerps;
        break;
      case DX9_OP_CMP:
        ++stats.compares;
        break;
      case DX9_OP_DCL:
        if (tokens != nullptr && instruction.operand_count >= 2u) {
          const uint32_t usage_token =
              tokens[instruction.token_offset + 1u];
          const uint32_t register_token =
              tokens[instruction.token_offset + 2u];
          const uint32_t register_type = DX9GetRegisterType(register_token);
          const uint32_t register_number = DX9GetRegisterNumber(register_token);

          if (register_type == DX9_REGISTER_INPUT) {
            ++stats.input_declarations;

            const uint32_t usage = usage_token & DX9_DCL_USAGE_MASK;
            const uint32_t usage_index =
                (usage_token & DX9_DCL_USAGE_INDEX_MASK)
                >> DX9_DCL_USAGE_INDEX_SHIFT;

            if (usage == DX9_DECL_USAGE_TEXCOORD && usage_index < 32u) {
              stats.texcoord_declaration_mask |= 1u << usage_index;
            } else if (usage == DX9_DECL_USAGE_COLOR && usage_index == 0u) {
              stats.declares_color0 = true;
            }
          } else if (
              register_type == DX9_REGISTER_SAMPLER
              && register_number < 32u) {
            stats.sampler_declaration_mask |= 1u << register_number;
          }
        }
        break;
      default:
        break;
    }
  }

  return stats;
}

bool DX9HasDeclaredSampler(
    const DX9ShaderStats& stats,
    uint32_t sampler_register) {
  return sampler_register < 32u
      && (stats.sampler_declaration_mask & (1u << sampler_register)) != 0u;
}

bool DX9HasMaterialLightingSignature(const DX9ShaderStats& stats) {
  // BO1 material shaders normally expose at least one of these slots:
  //   s1 = normal map, s2 = shadow map, s4 = specular map.
  // Viewmodels additionally tend to use s11/s15, handled separately below.
  return DX9HasDeclaredSampler(stats, 1u)
      || DX9HasDeclaredSampler(stats, 2u)
      || DX9HasDeclaredSampler(stats, 4u);
}

bool DX9LooksLikeSkyFogOrUtility(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  const bool has_texcoord8 =
      (stats.texcoord_declaration_mask & (1u << 8u)) != 0u;
  const bool has_model_lighting = DX9HasDeclaredSampler(stats, 11u);
  const bool has_reflection_probe = DX9HasDeclaredSampler(stats, 15u);

  // A confirmed BO1 viewmodel declaration signature always wins over the
  // structural sky filter. Some weapon variants use only one of s11/s15.
  if (has_texcoord8 && (has_model_lighting || has_reflection_probe)) {
    return false;
  }

  // Normal/shadow/specular resources are strong evidence of material lighting.
  if (DX9HasMaterialLightingSignature(stats)) return false;

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // Copy, LUT, fog-composite and many sky/cloud passes commonly end in these
  // operations. They must not enter an automatic unclamp path.
  if (terminal_candidate.opcode == DX9_OP_TEXLD
      || terminal_candidate.opcode == DX9_OP_LRP
      || terminal_candidate.opcode == DX9_OP_CMP) {
    return true;
  }

  // No dot-product lighting means the terminal saturation is much more likely
  // to be a mask, fog/sky blend, UI/effect value or packed intermediate.
  if (stats.dot_products == 0u) return true;

  // Reject lightweight non-material shaders. This catches unknown sky variants
  // even when their hash is not yet in the hard denylist.
  if (stats.texture_samples <= 2u
      && stats.dot_products <= 2u
      && lighting_math < 12u) {
    return true;
  }

  if (instruction_count < 24u && lighting_math < 10u) return true;

  return false;
}

bool DX9LooksLikeAdditionalSkyShader(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  const bool has_texcoord8 =
      (stats.texcoord_declaration_mask & (1u << 8u)) != 0u;
  const bool has_model_lighting = DX9HasDeclaredSampler(stats, 11u);
  const bool has_reflection_probe = DX9HasDeclaredSampler(stats, 15u);

  // Never classify likely viewmodels as sky.
  if (has_texcoord8 && (has_model_lighting || has_reflection_probe)) {
    return false;
  }

  // Never classify ordinary material lighting as sky.
  if (DX9HasMaterialLightingSignature(stats)) return false;

  // Restrict the broad sky path to arithmetic-produced highlight outputs.
  if (terminal_candidate.opcode != DX9_OP_MUL
      && terminal_candidate.opcode != DX9_OP_MAD
      && terminal_candidate.opcode != DX9_OP_ADD
      && terminal_candidate.opcode != DX9_OP_SUB) {
    return false;
  }

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // Broad test path for additional sky/cloud shaders. Keep the range moderate
  // so obvious utility passes remain rejected.
  return stats.texture_samples <= 4u
      && stats.dot_products <= 2u
      && lighting_math >= 4u
      && lighting_math <= 32u
      && instruction_count >= 12u
      && instruction_count <= 128u;
}

bool DX9LooksLikeGeometryLighting(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  if (DX9LooksLikeSkyFogOrUtility(
          stats,
          terminal_candidate,
          instruction_count)) {
    return false;
  }

  // Geometry highlight output should be produced by arithmetic, not a direct
  // texture/cmp/lerp terminal operation.
  if (terminal_candidate.opcode != DX9_OP_MUL
      && terminal_candidate.opcode != DX9_OP_MAD
      && terminal_candidate.opcode != DX9_OP_ADD
      && terminal_candidate.opcode != DX9_OP_SUB) {
    return false;
  }

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;
  const bool has_material_resources = DX9HasMaterialLightingSignature(stats);

  // Broader level-3 material match. The prior test required too little proof in
  // some places but still missed many real lit surfaces. Prefer resource-backed
  // evidence, then allow a high-complexity fallback for compiler variants.
  if (has_material_resources
      && stats.texture_samples >= 2u
      && stats.dot_products >= 1u
      && lighting_math >= 6u
      && instruction_count >= 18u) {
    return true;
  }

  if (stats.input_declarations >= 4u
      && stats.texture_samples >= 3u
      && stats.dot_products >= 3u
      && lighting_math >= 12u
      && instruction_count >= 35u) {
    return true;
  }

  return false;
}

bool DX9LooksLikeBroadGeometryLighting(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  if (DX9LooksLikeSkyFogOrUtility(
          stats,
          terminal_candidate,
          instruction_count)) {
    return false;
  }

  if (terminal_candidate.opcode != DX9_OP_MUL
      && terminal_candidate.opcode != DX9_OP_MAD
      && terminal_candidate.opcode != DX9_OP_ADD
      && terminal_candidate.opcode != DX9_OP_SUB) {
    return false;
  }

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // Level 4 is broader than level 3, but still requires actual lighting work and
  // always uses the guarded terminal reconstruction for unknown geometry.
  if (DX9HasMaterialLightingSignature(stats)
      && stats.texture_samples >= 1u
      && stats.dot_products >= 1u
      && lighting_math >= 4u
      && instruction_count >= 14u) {
    return true;
  }

  return stats.input_declarations >= 3u
      && stats.texture_samples >= 3u
      && stats.dot_products >= 2u
      && lighting_math >= 10u
      && instruction_count >= 28u;
}

bool DX9LooksLikeViewmodelLighting(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  // BO1's confirmed first-person weapon shaders finish with a saturated MUL
  // before square-root output encoding. Keep this requirement so ordinary fog,
  // copy, LUT and blend passes cannot enter the full viewmodel path.
  if (terminal_candidate.opcode != DX9_OP_MUL) return false;

  const bool has_texcoord8 =
      (stats.texcoord_declaration_mask & (1u << 8u)) != 0u;
  const bool has_model_lighting_sampler =
      (stats.sampler_declaration_mask & (1u << 11u)) != 0u;
  const bool has_reflection_probe_sampler =
      (stats.sampler_declaration_mask & (1u << 15u)) != 0u;

  // These are the stable declarations shared by all supplied BO1 weapon
  // examples: COLOR0, TEXCOORD8, the s11 model-lighting volume and usually the
  // s15 reflection probe. Do not require a literal LRP opcode because the D3D9
  // compiler may lower the hero-lighting blend to MAD/ADD instructions.
  if (!stats.declares_color0 || !has_texcoord8) return false;
  if (!has_model_lighting_sampler && !has_reflection_probe_sampler) return false;
  if (stats.input_declarations < 6u) return false;

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // The thresholds are intentionally lower than the previous detector. The old
  // values rejected real weapon variants after compiler scheduling changed their
  // TEX/DP/LRP counts, even though their resource and input signatures matched.
  const bool model_lighting_signature =
      has_model_lighting_sampler
      && stats.texture_samples >= 4u
      && stats.dot_products >= 4u
      && lighting_math >= 12u
      && instruction_count >= 45u;

  const bool reflection_viewmodel_signature =
      has_reflection_probe_sampler
      && stats.texture_samples >= 5u
      && stats.dot_products >= 6u
      && lighting_math >= 16u
      && instruction_count >= 60u;

  return model_lighting_signature || reflection_viewmodel_signature;
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

uint32_t DX9GetSwizzleComponent(uint32_t token, uint32_t component) {
  if (component >= 4u) return UINT32_MAX;
  const uint32_t swizzle = DX9GetSourceSwizzle(token);
  return (swizzle >> (component * 2u)) & 0x3u;
}

bool DX9MatchesViewmodelSqrtOutput(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    size_t candidate_index,
    uint32_t source_temp_register) {
  // The generic matcher only accepted this exact form:
  //
  //   rsq r0.x, r0.x
  //   rcp oC0.x, r0.x
  //
  // BO1 viewmodel variants may instead use a second temporary and/or move the
  // completed RGB value to oC0 after the reciprocal. Track the data flow rather
  // than requiring one register-allocation layout.
  std::array<bool, 3u> saw_rsq = {false, false, false};
  std::array<uint32_t, 3u> rsq_register = {
      UINT32_MAX, UINT32_MAX, UINT32_MAX};
  std::array<bool, 3u> saw_sqrt_value = {false, false, false};
  std::array<uint32_t, 3u> sqrt_register = {
      UINT32_MAX, UINT32_MAX, UINT32_MAX};
  std::array<uint32_t, 3u> sqrt_component = {
      UINT32_MAX, UINT32_MAX, UINT32_MAX};
  std::array<bool, 3u> wrote_output = {false, false, false};

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
          && DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (component < 3u
            && DX9IsTempComponentSource(
                source,
                source_temp_register,
                component)) {
          saw_rsq[component] = true;
          rsq_register[component] = DX9GetRegisterNumber(dest);
          continue;
        }
      }
    }

    if (instruction.opcode == DX9_OP_RCP
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (component < 3u
            && saw_rsq[component]
            && DX9IsTempComponentSource(
                source,
                rsq_register[component],
                component)) {
          const uint32_t dest_type = DX9GetRegisterType(dest);
          const uint32_t dest_register = DX9GetRegisterNumber(dest);

          if (dest_type == DX9_REGISTER_COLOR_OUTPUT
              && dest_register == 0u) {
            wrote_output[component] = true;
            continue;
          }

          if (dest_type == DX9_REGISTER_TEMP) {
            saw_sqrt_value[component] = true;
            sqrt_register[component] = dest_register;
            sqrt_component[component] = component;
            continue;
          }
        }
      }
    }

    if (instruction.opcode == DX9_OP_MOV
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t dest_type = DX9GetRegisterType(dest);
      const uint32_t dest_register = DX9GetRegisterNumber(dest);
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (dest_type == DX9_REGISTER_COLOR_OUTPUT && dest_register == 0u) {
        if (write_mask == DX9_WRITE_W) continue;
        if ((write_mask & DX9_WRITE_RGB) == 0u) continue;
        if (DX9GetRegisterType(source) != DX9_REGISTER_TEMP
            || (source & DX9_SOURCE_MODIFIER_MASK) != 0u) {
          return false;
        }

        const uint32_t source_register = DX9GetRegisterNumber(source);
        for (uint32_t output_component = 0u;
             output_component < 3u;
             ++output_component) {
          const uint32_t output_bit = 1u << output_component;
          if ((write_mask & output_bit) == 0u) continue;

          const uint32_t source_component =
              DX9GetSwizzleComponent(source, output_component);
          bool matched_component = false;

          for (uint32_t sqrt_index = 0u;
               sqrt_index < 3u;
               ++sqrt_index) {
            if (!saw_sqrt_value[sqrt_index]) continue;
            if (sqrt_register[sqrt_index] != source_register) continue;
            if (sqrt_component[sqrt_index] != source_component) continue;
            matched_component = true;
            break;
          }

          if (!matched_component) return false;
          wrote_output[output_component] = true;
        }
        continue;
      }
    }

    // Ignore unrelated scalar/alpha work after the lighting result, but reject
    // an unexpected RGB overwrite of the source temporary or the final color
    // output. This keeps the relaxed matcher tied to the terminal sqrt chain.
    if (instruction.operand_count > 0u
        && DX9OpcodeMayHaveSaturatedColorDestination(instruction.opcode)) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t dest_type = DX9GetRegisterType(dest);
      const uint32_t dest_register = DX9GetRegisterNumber(dest);
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if ((write_mask & DX9_WRITE_RGB) != 0u
          && ((dest_type == DX9_REGISTER_TEMP
               && dest_register == source_temp_register)
              || (dest_type == DX9_REGISTER_COLOR_OUTPUT
                  && dest_register == 0u))) {
        return false;
      }
    }
  }

  return std::ranges::all_of(saw_rsq, [](bool value) { return value; })
      && std::ranges::all_of(wrote_output, [](bool value) { return value; });
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
    uint32_t mode,
    uint32_t source_crc32) {
  DX9AutoUnclampPlan plan = {};
  if (mode == DX9_AUTO_UNCLAMP_OFF || instructions.size() < 2u) return plan;
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(source_crc32)) return plan;

  const bool is_curated_post =
      DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(source_crc32);
  const bool is_curated_model =
      DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST.contains(source_crc32);
  const bool is_exact_viewmodel =
      DX9_AUTO_UNCLAMP_LEVEL3_VIEWMODEL_ALLOWLIST.contains(source_crc32);
  const bool is_exact_sky_test =
      mode >= DX9_AUTO_UNCLAMP_HEURISTIC_SQRT
      && DX9_AUTO_UNCLAMP_LEVEL3_SKY_TEST_ALLOWLIST.contains(source_crc32);
  const DX9ShaderStats stats = DX9CollectShaderStats(tokens, instructions);

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

    const bool is_heuristic_viewmodel_candidate =
        mode >= DX9_AUTO_UNCLAMP_HEURISTIC_SQRT
        && (is_exact_viewmodel
            || DX9LooksLikeViewmodelLighting(
                stats,
                instruction,
                instructions.size()));

    const bool is_structural_extra_sky =
        mode >= DX9_AUTO_UNCLAMP_HEURISTIC_SQRT
        && !is_curated_post
        && !is_curated_model
        && !is_exact_viewmodel
        && !is_exact_sky_test
        && DX9LooksLikeAdditionalSkyShader(
            stats,
            instruction,
            instructions.size());

    const bool is_structural_sky_or_utility =
        !is_curated_post
        && !is_curated_model
        && !is_exact_viewmodel
        && !is_exact_sky_test
        && !is_structural_extra_sky
        && DX9LooksLikeSkyFogOrUtility(
            stats,
            instruction,
            instructions.size());

    const bool matches_strict_sqrt =
        register_type == DX9_REGISTER_TEMP
        && DX9MatchesTerminalSqrtOutput(
            tokens,
            instructions,
            candidate_index,
            register_number);

    const bool matches_viewmodel_sqrt =
        register_type == DX9_REGISTER_TEMP
        && is_heuristic_viewmodel_candidate
        && DX9MatchesViewmodelSqrtOutput(
            tokens,
            instructions,
            candidate_index,
            register_number);

    if (matches_strict_sqrt || matches_viewmodel_sqrt) {
      bool allow_sqrt = false;
      bool use_guarded_geometry = false;

      switch (mode) {
        case DX9_AUTO_UNCLAMP_CURATED_POST_SKY:
          allow_sqrt = is_curated_post;
          break;

        case DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL:
          // Explicit weapon/viewmodel hashes use the full terminal unclamp.
          // Their internal shading clamps remain untouched, and the smaller
          // patch is much more likely to fit instruction-heavy ps_3_0 shaders.
          allow_sqrt = is_curated_post || is_curated_model;
          use_guarded_geometry = false;
          break;

        case DX9_AUTO_UNCLAMP_HEURISTIC_SQRT:
        case DX9_AUTO_UNCLAMP_HEURISTIC_ALL: {
          // Level 4 deliberately aliases level 3. Both modes now apply the same
          // weapon-style terminal highlight unclamp to almost every strict terminal
          // sqrt chain, while still protecting known and structural sky/fog/utility
          // shaders. The two confirmed sky hashes are explicitly allowed for this
          // test build. There is no guarded reconstruction or brightness multiplier.
          if (is_structural_sky_or_utility) break;

          const bool is_broad_viewmodel =
              is_heuristic_viewmodel_candidate;

          // Broad heuristic mode: if the shader ends in a proven terminal
          // sqrt(saturate(...)) output chain, allow the same final-only unclamp used
          // by the supplied weapon HLSL examples. This intentionally reaches world
          // geometry and most other lit shaders. Structural fog/utility passes remain
          // filtered, while the confirmed sky hashes and additional sky-like shaders
          // bypass that filter for testing.
          allow_sqrt = is_curated_post
              || is_curated_model
              || is_exact_viewmodel
              || is_exact_sky_test
              || is_structural_extra_sky
              || is_broad_viewmodel
              || matches_strict_sqrt;

          // Every accepted shader uses:
          //
          //   sqrt(saturate(finalLighting))
          //       -> sqrt(max(finalLighting, 0))
          //
          // This is exactly the supplied weapon-HLSL transformation.
          use_guarded_geometry = false;
          break;
        }

        default:
          break;
      }

      if (!allow_sqrt) continue;

      if (use_guarded_geometry) {
        // Legacy guarded reconstruction retained for source compatibility.
        // Level 3 and level 4 no longer select this path.
        if (instructions.size() > 504u || free_temp_count < 2u) continue;

        plan.kind = DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED;
        plan.instruction_index = candidate_index;
        plan.free_temps[0] = free_temps[0];
        plan.free_temps[1] = free_temps[1];
        plan.free_temp_count = 2u;
        return plan;
      }

      // Full unclamp adds two arithmetic instructions.
      if (instructions.size() > 510u || free_temp_count < 1u) continue;

      plan.kind = DX9AutoUnclampPatchKind::SQRT_OUTPUT;
      plan.instruction_index = candidate_index;
      plan.free_temps[0] = free_temps[0];
      plan.free_temp_count = 1u;
      return plan;
    }

    // Direct final-output rewrites are hash-curated only. Do not infer them from
    // a viewmodel/geometry signature: that broader path caused flat shading.
    const bool allow_direct_output =
        DX9AutoUnclampModeAllowsDirectOutput(mode, source_crc32);

    if (allow_direct_output
        && register_type == DX9_REGISTER_COLOR_OUTPUT
        && register_number == 0u
        && instructions.size() <= 510u
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

  std::vector<uint32_t> inserted;

  if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT) {
    const uint32_t zero_temp = plan.free_temps[0];

    // Remove only _sat from the original RGB-producing instruction.
    patched_tokens[dest_offset] = original_dest & ~DX9_DEST_SATURATE;

    // rZero.rgb = rColor.rgb - rColor.rgb;  // exact 0 for finite input
    inserted.push_back(DX9MakeInstruction(DX9_OP_SUB, 3u));
    inserted.push_back(DX9MakeTempDest(
        zero_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(original_register));

    // rColor.rgb = max(rColor.rgb, rZero.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MAX, 3u));
    inserted.push_back(DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(zero_temp));
  } else if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED) {
    const uint32_t raw_temp = plan.free_temps[0];
    const uint32_t aux_temp = plan.free_temps[1];

    // First evaluate the original expression without saturation into rRaw.
    patched_tokens[dest_offset] = DX9SetRegister(
        original_dest & ~DX9_DEST_SATURATE,
        DX9_REGISTER_TEMP,
        raw_temp);

    // Then replay the exact original saturated instruction into rColor. Keeping
    // both versions lets us construct a constant-free 16.0 cap:
    //
    //   vanilla = saturate(raw)
    //   limit   = vanilla * 16
    //   color   = max(min(raw, limit), 0)
    //
    // Below 1.0, min(raw, 16*raw) remains raw. Above 1.0, vanilla is 1 and
    // the recovered linear value is capped at 16.0. The following original
    // rsq/rcp chain can therefore output up to sqrt(16) = 4.0.
    const size_t candidate_dword_count = 1u + candidate.operand_count;
    inserted.insert(
        inserted.end(),
        source_tokens + candidate.token_offset,
        source_tokens + candidate.token_offset + candidate_dword_count);

    // rAux.rgb = rColor.rgb + rColor.rgb;  // 2 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(original_register));

    // rAux.rgb = rAux.rgb + rAux.rgb;  // 4 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(aux_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rAux.rgb = rAux.rgb + rAux.rgb;  // 8 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(aux_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rAux.rgb = rAux.rgb + rAux.rgb;  // 16 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(aux_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rColor.rgb = min(rRaw.rgb, rAux.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MIN, 3u));
    inserted.push_back(DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(raw_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rAux.rgb = rColor.rgb - rColor.rgb;  // safe zero after the finite cap
    inserted.push_back(DX9MakeInstruction(DX9_OP_SUB, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(original_register));

    // rColor.rgb = max(rColor.rgb, rAux.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MAX, 3u));
    inserted.push_back(DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(aux_temp));
  } else if (plan.kind == DX9AutoUnclampPatchKind::DIRECT_OUTPUT) {
    const uint32_t color_temp = plan.free_temps[0];
    const uint32_t zero_temp = plan.free_temps[1];

    // Redirect the original oC0.rgb write into a free temporary and remove
    // only _sat. The original write mask and partial-precision modifier remain.
    patched_tokens[dest_offset] = DX9SetRegister(
        original_dest & ~DX9_DEST_SATURATE,
        DX9_REGISTER_TEMP,
        color_temp);

    inserted.push_back(DX9MakeInstruction(DX9_OP_SUB, 3u));
    inserted.push_back(DX9MakeTempDest(
        zero_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(color_temp));
    inserted.push_back(DX9MakeTempSource(color_temp));

    // oC0.rgb = max(rColor.rgb, rZero.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MAX, 3u));
    inserted.push_back(original_dest & ~DX9_DEST_SATURATE);
    inserted.push_back(DX9MakeTempSource(color_temp));
    inserted.push_back(DX9MakeTempSource(zero_temp));
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
    case DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED:
      return "guarded geometry sqrt RGB";
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

    // PERFORMANCE: most BO1 shaders are created more than once across device/state
    // rebuilds. Reuse already-patched bytecode before reparsing and rebuilding it.
    // This preserves the existing cache semantics; it only moves the lookup earlier.
    const uint64_t early_cache_key =
        (static_cast<uint64_t>(source_crc32) << 32u)
        | static_cast<uint32_t>(shader_desc->code_size);
    {
      std::scoped_lock lock(g_dx9_auto_unclamp_mutex);
      const auto cache_it = g_dx9_auto_unclamp_cache.find(early_cache_key);
      if (cache_it != g_dx9_auto_unclamp_cache.end()
          && cache_it->second.source_crc32 == source_crc32
          && cache_it->second.source_size == shader_desc->code_size) {
        shader_desc->code = cache_it->second.bytecode.data();
        shader_desc->code_size =
            cache_it->second.bytecode.size() * sizeof(uint32_t);
        modified = true;
        continue;
      }
    }

    std::vector<DX9InstructionInfo> instructions;
    if (!DX9ParseShader(source_tokens, token_count, instructions)) continue;

    const DX9AutoUnclampPlan plan =
        DX9BuildAutoUnclampPlan(
            source_tokens,
            instructions,
            mode,
            source_crc32);
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
      } else if (
          plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED) {
        ++g_dx9_auto_unclamp_guarded_count;
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
        stream << ", guarded=" << g_dx9_auto_unclamp_guarded_count;
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

#endif  // Automatic DX9 output unclamper

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

// Fast reverse lookup for callbacks that arrive with the clone handle itself.
// The key is the FP16 clone handle. The cached original is validated against
// RenoDX live tracking before it is used, so stale mappings are discarded.
struct DX9CloneLookupCacheEntry {
  reshade::api::resource original = {0u};
};

std::mutex g_dx9_clone_lookup_cache_mutex;
std::unordered_map<uint64_t, DX9CloneLookupCacheEntry>
    g_dx9_clone_lookup_cache;


// Reusable CPU-visible FP16 staging surface for GetRenderTargetData.
// The old implementation allocated and destroyed this surface for every
// incompatible FP16 -> 8-bit readback.
struct DX9ReadbackStagingCache {
  reshade::api::device* device = nullptr;
  reshade::api::resource resource = {0u};
  reshade::api::resource_desc desc = {};
};

std::mutex g_dx9_readback_staging_mutex;
DX9ReadbackStagingCache g_dx9_readback_staging_cache;

uint32_t g_dx9_clone_cache_hits = 0u;
uint32_t g_dx9_clone_cache_misses = 0u;
uint32_t g_dx9_staging_reuses = 0u;
uint32_t g_dx9_staging_creates = 0u;


void RememberDX9CloneMapping(const DX9CopyEndpoint& endpoint) {
  if (!endpoint.has_clone
      || endpoint.clone.handle == 0u
      || endpoint.original.handle == 0u
      || endpoint.clone.handle == endpoint.original.handle) {
    return;
  }

  std::scoped_lock lock(g_dx9_clone_lookup_cache_mutex);

  g_dx9_clone_lookup_cache[
      static_cast<uint64_t>(endpoint.clone.handle)] = {
          .original = endpoint.original,
      };
}


bool TryResolveDX9CloneFromCache(
    reshade::api::device* device,
    reshade::api::resource input,
    DX9CopyEndpoint& endpoint) {
  if (device == nullptr || input.handle == 0u) return false;

  DX9CloneLookupCacheEntry cached = {};

  {
    std::scoped_lock lock(g_dx9_clone_lookup_cache_mutex);

    const auto it = g_dx9_clone_lookup_cache.find(
        static_cast<uint64_t>(input.handle));

    if (it == g_dx9_clone_lookup_cache.end()) {
      ++g_dx9_clone_cache_misses;
      return false;
    }

    cached = it->second;
  }

  if (cached.original.handle == 0u) return false;

  bool valid = false;

  renodx::utils::resource::GetLiveResourceInfo(
      cached.original,
      [&](const renodx::utils::resource::ResourceInfo& info) {
        if (info.destroyed
            || info.resource.handle == 0u
            || info.clone.handle != input.handle) {
          return;
        }

        endpoint.has_live_tracking = true;
        endpoint.input_is_clone = true;
        endpoint.original = info.resource;
        endpoint.original_desc =
            info.desc.type != reshade::api::resource_type::unknown
                ? info.desc
                : endpoint.original_desc;
        endpoint.clone = input;
        endpoint.clone_desc =
            info.clone_desc.type != reshade::api::resource_type::unknown
                ? info.clone_desc
                : endpoint.input_desc;
        endpoint.has_clone = true;
        endpoint.clone_enabled = info.clone_enabled;

        valid = true;
      });

  if (valid) {
    ++g_dx9_clone_cache_hits;
    return true;
  }

  // Resource was destroyed/recreated or the handle was reused.
  {
    std::scoped_lock lock(g_dx9_clone_lookup_cache_mutex);
    g_dx9_clone_lookup_cache.erase(
        static_cast<uint64_t>(input.handle));
  }

  ++g_dx9_clone_cache_misses;
  return false;
}


bool DX9StagingDescMatches(
    const reshade::api::resource_desc& cached,
    const reshade::api::resource_desc& wanted) {
  if (cached.type == reshade::api::resource_type::unknown
      || wanted.type == reshade::api::resource_type::unknown) {
    return false;
  }

  return cached.type == wanted.type
      && cached.heap == wanted.heap
      && cached.usage == wanted.usage
      && cached.texture.format == wanted.texture.format
      && cached.texture.width == wanted.texture.width
      && cached.texture.height == wanted.texture.height
      && cached.texture.depth_or_layers
          == wanted.texture.depth_or_layers
      && cached.texture.levels == wanted.texture.levels
      && cached.texture.samples == wanted.texture.samples;
}


bool EnsureDX9ReadbackStaging(
    reshade::api::device* device,
    const reshade::api::resource_desc& wanted_desc,
    reshade::api::resource& staging) {
  if (device == nullptr) return false;

  auto& cache = g_dx9_readback_staging_cache;

  if (cache.device == device
      && cache.resource.handle != 0u
      && DX9StagingDescMatches(cache.desc, wanted_desc)) {
    staging = cache.resource;
    ++g_dx9_staging_reuses;
    return true;
  }

  // Same live D3D9 device but dimensions/format changed: release the old cached
  // surface before replacing it. If the device itself changed, simply forget the
  // old handle; the old D3D9 device owns and reclaims its resources on teardown.
  if (cache.device == device && cache.resource.handle != 0u) {
    device->destroy_resource(cache.resource);
  }

  cache = {};
  cache.device = device;

  if (!device->create_resource(
          wanted_desc,
          nullptr,
          reshade::api::resource_usage::copy_dest,
          &cache.resource)) {
    cache = {};
    return false;
  }

  cache.desc = wanted_desc;
  staging = cache.resource;
  ++g_dx9_staging_creates;
  return true;
}


void InvalidateDX9ReadbackStaging(
    reshade::api::device* device) {
  auto& cache = g_dx9_readback_staging_cache;

  if (device != nullptr
      && cache.device == device
      && cache.resource.handle != 0u) {
    device->destroy_resource(cache.resource);
  }

  cache = {};
}


void ClearDX9ReadbackOptimizationCaches() {
  {
    std::scoped_lock lock(g_dx9_clone_lookup_cache_mutex);
    g_dx9_clone_lookup_cache.clear();
  }

  // Do not call through a possibly-destroyed D3D9 device from DLL detach.
  // The device owns the cached staging allocation and frees it during teardown.
  g_dx9_readback_staging_cache = {};
}


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

  // Any normal original-resource lookup gives us the clone handle essentially
  // for free. Remember that pair now so a later callback that arrives with the
  // FP16 clone handle can resolve it without scanning every tracked resource.
  RememberDX9CloneMapping(endpoint);

  const bool may_be_clone_handle =
      endpoint.input_desc.type != reshade::api::resource_type::unknown
      && endpoint.input_desc.texture.format
          == reshade::api::format::r16g16b16a16_float;

  if (may_be_clone_handle
      && (!endpoint.has_clone || endpoint.input_is_clone)) {
    // Fast path: validate the cached original through RenoDX's direct live lookup.
    if (TryResolveDX9CloneFromCache(
            device,
            input,
            endpoint)) {
      RememberDX9CloneMapping(endpoint);
      return endpoint;
    }

    // Slow path only for the first encounter of a clone or after invalidation.
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

    RememberDX9CloneMapping(endpoint);
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


// ============================================================================
// D3D9 GPU HDR -> SDR readback blit
// ============================================================================
//
// The game asks D3D9 GetRenderTargetData to copy what it thinks is its original
// 8-bit render target into a CPU-visible surface. RenoDX resource cloning means
// the current image may instead live in an R16G16B16A16_FLOAT clone.
//
// The old compatibility fallback solved that by reading FP16 back to the CPU and
// converting every pixel there. That is correct, but the synchronous readback +
// per-pixel half conversion + sRGB pow() work can create large frametime spikes.
//
// This path keeps resource cloning intact and moves the conversion back to the
// GPU:
//
//   FP16 clone -> fullscreen ps_3_0 blit -> original 8-bit render target
//              -> normal same-format GetRenderTargetData copy -> game surface
//
// The existing CPU converter remains below this path as a correctness fallback.

constexpr bool DX9_GPU_READBACK_BLIT_ENABLED = true;

uint32_t g_dx9_gpu_blit_success_logs = 0u;
uint32_t g_dx9_gpu_blit_failure_logs = 0u;

struct DX9GPUReadbackBlitVertex {
  float x;
  float y;
  float z;
  float w;
  float u;
  float v;
};

struct DX9GPUReadbackBlitCache {
  IDirect3DDevice9* device = nullptr;  // Borrowed; owned by ReShade/D3D9.
  IDirect3DVertexShader9* vertex_shader = nullptr;
  IDirect3DPixelShader9* pixel_shader = nullptr;
  IDirect3DVertexDeclaration9* vertex_declaration = nullptr;
  IDirect3DStateBlock9* state_block = nullptr;

  // Only needed when the FP16 clone is a plain render-target surface rather than
  // an IDirect3DTexture9. It is reused instead of allocated on every readback.
  IDirect3DTexture9* source_scratch_texture = nullptr;
  uint32_t source_scratch_width = 0u;
  uint32_t source_scratch_height = 0u;
};

std::mutex g_dx9_gpu_blit_mutex;
DX9GPUReadbackBlitCache g_dx9_gpu_blit_cache;

template <typename T>
void ReleaseDX9COM(T*& object) {
  if (object != nullptr) {
    object->Release();
    object = nullptr;
  }
}

void DestroyDX9GPUReadbackBlitCacheLocked() {
  auto& cache = g_dx9_gpu_blit_cache;

  ReleaseDX9COM(cache.source_scratch_texture);
  ReleaseDX9COM(cache.state_block);
  ReleaseDX9COM(cache.vertex_declaration);
  ReleaseDX9COM(cache.pixel_shader);
  ReleaseDX9COM(cache.vertex_shader);

  cache = {};
}

void DestroyDX9GPUReadbackBlitCache(reshade::api::device* device = nullptr) {
  std::scoped_lock lock(g_dx9_gpu_blit_mutex);

  if (device != nullptr) {
    if (device->get_api() != reshade::api::device_api::d3d9) return;

    auto* native_device =
        reinterpret_cast<IDirect3DDevice9*>(device->get_native());
    if (native_device == nullptr
        || g_dx9_gpu_blit_cache.device != native_device) {
      return;
    }
  }

  DestroyDX9GPUReadbackBlitCacheLocked();
}

void OnDX9ReadbackDestroyDevice(reshade::api::device* device) {
  DestroyDX9GPUReadbackBlitCache(device);
}

void OnDX9ReadbackDestroySwapchain(
    reshade::api::swapchain* swapchain,
    bool resize) {
  (void)resize;
  if (swapchain == nullptr) return;

  // D3D9 Reset requires addon-owned default-pool resources to be released.
  DestroyDX9GPUReadbackBlitCache(swapchain->get_device());
}

void LogDX9GPUBlitFailure(const char* reason) {
  if (g_dx9_gpu_blit_failure_logs >= 8u) return;
  ++g_dx9_gpu_blit_failure_logs;

  std::stringstream stream;
  stream << "[RenoDX DX9 Readback GPU Blit] " << reason;
  reshade::log::message(
      reshade::log::level::warning,
      stream.str().c_str());
}

struct ScopedDX9NativeSurface {
  IDirect3DSurface9* surface = nullptr;
  bool owns_reference = false;

  ~ScopedDX9NativeSurface() {
    if (owns_reference && surface != nullptr) {
      surface->Release();
    }
  }

  ScopedDX9NativeSurface() = default;
  ScopedDX9NativeSurface(const ScopedDX9NativeSurface&) = delete;
  ScopedDX9NativeSurface& operator=(const ScopedDX9NativeSurface&) = delete;
};

bool AcquireDX9NativeSurface(
    reshade::api::resource resource,
    const reshade::api::resource_desc& desc,
    uint32_t subresource,
    ScopedDX9NativeSurface& output) {
  if (resource.handle == 0u) return false;

  if (desc.type == reshade::api::resource_type::surface) {
    output.surface =
        reinterpret_cast<IDirect3DSurface9*>(resource.handle);
    output.owns_reference = false;
    return output.surface != nullptr && subresource == 0u;
  }

  if (desc.type == reshade::api::resource_type::texture_2d) {
    auto* texture =
        reinterpret_cast<IDirect3DTexture9*>(resource.handle);
    if (texture == nullptr) return false;

    IDirect3DSurface9* surface = nullptr;
    const HRESULT hr = texture->GetSurfaceLevel(subresource, &surface);
    if (FAILED(hr) || surface == nullptr) return false;

    output.surface = surface;
    output.owns_reference = true;
    return true;
  }

  return false;
}

struct ScopedDX9NativeTexture {
  IDirect3DTexture9* texture = nullptr;
  bool owns_reference = false;

  ~ScopedDX9NativeTexture() {
    if (owns_reference && texture != nullptr) {
      texture->Release();
    }
  }

  ScopedDX9NativeTexture() = default;
  ScopedDX9NativeTexture(const ScopedDX9NativeTexture&) = delete;
  ScopedDX9NativeTexture& operator=(const ScopedDX9NativeTexture&) = delete;
};

bool TryAcquireDX9TextureContainer(
    reshade::api::resource resource,
    const reshade::api::resource_desc& desc,
    ScopedDX9NativeTexture& output) {
  if (resource.handle == 0u) return false;

  if (desc.type == reshade::api::resource_type::texture_2d) {
    output.texture =
        reinterpret_cast<IDirect3DTexture9*>(resource.handle);
    output.owns_reference = false;
    return output.texture != nullptr;
  }

  if (desc.type != reshade::api::resource_type::surface) return false;

  auto* surface =
      reinterpret_cast<IDirect3DSurface9*>(resource.handle);
  if (surface == nullptr) return false;

  IDirect3DTexture9* texture = nullptr;
  const HRESULT hr = surface->GetContainer(
      __uuidof(IDirect3DTexture9),
      reinterpret_cast<void**>(&texture));
  if (FAILED(hr) || texture == nullptr) return false;

  output.texture = texture;
  output.owns_reference = true;
  return true;
}

bool EnsureDX9GPUReadbackPipelineLocked(IDirect3DDevice9* device) {
  if (device == nullptr) return false;

  auto& cache = g_dx9_gpu_blit_cache;

  if (cache.device != nullptr && cache.device != device) {
    DestroyDX9GPUReadbackBlitCacheLocked();
  }

  cache.device = device;

  if (cache.vertex_shader == nullptr) {
    const HRESULT hr = device->CreateVertexShader(
        reinterpret_cast<const DWORD*>(std::data(__dx9_readback_blit_vertex)),
        &cache.vertex_shader);
    if (FAILED(hr) || cache.vertex_shader == nullptr) {
      LogDX9GPUBlitFailure("Could not create the cached vs_3_0 blit shader");
      return false;
    }
  }

  if (cache.pixel_shader == nullptr) {
    const HRESULT hr = device->CreatePixelShader(
        reinterpret_cast<const DWORD*>(std::data(__dx9_readback_blit_pixel)),
        &cache.pixel_shader);
    if (FAILED(hr) || cache.pixel_shader == nullptr) {
      LogDX9GPUBlitFailure("Could not create the cached ps_3_0 SDR conversion shader");
      return false;
    }
  }

  if (cache.vertex_declaration == nullptr) {
    static const D3DVERTEXELEMENT9 declaration[] = {
        {0u, 0u, D3DDECLTYPE_FLOAT4, D3DDECLMETHOD_DEFAULT,
         D3DDECLUSAGE_POSITION, 0u},
        {0u, 16u, D3DDECLTYPE_FLOAT2, D3DDECLMETHOD_DEFAULT,
         D3DDECLUSAGE_TEXCOORD, 0u},
        D3DDECL_END(),
    };

    const HRESULT hr = device->CreateVertexDeclaration(
        declaration,
        &cache.vertex_declaration);
    if (FAILED(hr) || cache.vertex_declaration == nullptr) {
      LogDX9GPUBlitFailure("Could not create the cached fullscreen vertex declaration");
      return false;
    }
  }

  if (cache.state_block == nullptr) {
    const HRESULT hr = device->CreateStateBlock(
        D3DSBT_ALL,
        &cache.state_block);
    if (FAILED(hr) || cache.state_block == nullptr) {
      LogDX9GPUBlitFailure("Could not create the cached D3D9 state block");
      return false;
    }
  }

  return true;
}

bool EnsureDX9GPUReadbackScratchTextureLocked(
    IDirect3DDevice9* device,
    uint32_t width,
    uint32_t height) {
  auto& cache = g_dx9_gpu_blit_cache;

  if (cache.source_scratch_texture != nullptr
      && cache.source_scratch_width == width
      && cache.source_scratch_height == height) {
    return true;
  }

  ReleaseDX9COM(cache.source_scratch_texture);
  cache.source_scratch_width = 0u;
  cache.source_scratch_height = 0u;

  const HRESULT hr = device->CreateTexture(
      width,
      height,
      1u,
      D3DUSAGE_RENDERTARGET,
      D3DFMT_A16B16G16R16F,
      D3DPOOL_DEFAULT,
      &cache.source_scratch_texture,
      nullptr);

  if (FAILED(hr) || cache.source_scratch_texture == nullptr) {
    LogDX9GPUBlitFailure("Could not create/reuse the FP16 sampling scratch texture");
    return false;
  }

  cache.source_scratch_width = width;
  cache.source_scratch_height = height;
  return true;
}

bool PrepareDX9GPUReadbackSourceTextureLocked(
    IDirect3DDevice9* device,
    reshade::api::resource source,
    const reshade::api::resource_desc& source_desc,
    IDirect3DTexture9*& texture_out,
    ScopedDX9NativeTexture& direct_texture) {
  texture_out = nullptr;

  // Fastest case: RenoDX clone is already a texture (or a surface belonging to
  // one), so it can be sampled directly with no extra copy.
  if (TryAcquireDX9TextureContainer(
          source,
          source_desc,
          direct_texture)) {
    texture_out = direct_texture.texture;
    return texture_out != nullptr;
  }

  // D3D9 can also expose swapchain/render-target clones as plain surfaces. Those
  // cannot be sampled by ps_3_0, so copy the FP16 surface into one reusable FP16
  // render-target texture, then sample that texture.
  if (!EnsureDX9GPUReadbackScratchTextureLocked(
          device,
          source_desc.texture.width,
          source_desc.texture.height)) {
    return false;
  }

  ScopedDX9NativeSurface source_surface;
  if (!AcquireDX9NativeSurface(
          source,
          source_desc,
          0u,
          source_surface)) {
    return false;
  }

  IDirect3DSurface9* scratch_surface = nullptr;
  const HRESULT get_surface_hr =
      g_dx9_gpu_blit_cache.source_scratch_texture->GetSurfaceLevel(
          0u,
          &scratch_surface);
  if (FAILED(get_surface_hr) || scratch_surface == nullptr) {
    return false;
  }

  const HRESULT blit_hr = device->StretchRect(
      source_surface.surface,
      nullptr,
      scratch_surface,
      nullptr,
      D3DTEXF_NONE);

  scratch_surface->Release();

  if (FAILED(blit_hr)) {
    LogDX9GPUBlitFailure("Could not copy the FP16 surface into the sampling texture");
    return false;
  }

  texture_out = g_dx9_gpu_blit_cache.source_scratch_texture;
  return true;
}

struct ScopedDX9RenderStateRestore {
  IDirect3DDevice9* device = nullptr;
  IDirect3DStateBlock9* state_block = nullptr;
  std::array<IDirect3DSurface9*, 4u> render_targets = {};
  std::array<bool, 4u> has_render_target = {};
  IDirect3DSurface9* depth_stencil = nullptr;
  bool has_depth_stencil = false;
  uint32_t render_target_count = 1u;
  bool captured = false;

  bool Capture(
      IDirect3DDevice9* native_device,
      IDirect3DStateBlock9* cached_state_block) {
    device = native_device;
    state_block = cached_state_block;
    if (device == nullptr || state_block == nullptr) return false;

    D3DCAPS9 caps = {};
    if (SUCCEEDED(device->GetDeviceCaps(&caps))) {
      render_target_count =
          std::clamp<uint32_t>(caps.NumSimultaneousRTs, 1u, 4u);
    }

    for (uint32_t slot = 0u; slot < render_target_count; ++slot) {
      IDirect3DSurface9* target = nullptr;
      if (SUCCEEDED(device->GetRenderTarget(slot, &target))
          && target != nullptr) {
        render_targets[slot] = target;
        has_render_target[slot] = true;
      }
    }

    IDirect3DSurface9* depth = nullptr;
    if (SUCCEEDED(device->GetDepthStencilSurface(&depth))
        && depth != nullptr) {
      depth_stencil = depth;
      has_depth_stencil = true;
    }

    if (FAILED(state_block->Capture())) {
      return false;
    }

    captured = true;
    return true;
  }

  ~ScopedDX9RenderStateRestore() {
    if (device != nullptr && captured) {
      for (uint32_t slot = 0u; slot < render_target_count; ++slot) {
        if (slot == 0u || has_render_target[slot]) {
          device->SetRenderTarget(
              slot,
              has_render_target[slot] ? render_targets[slot] : nullptr);
        }
      }

      device->SetDepthStencilSurface(
          has_depth_stencil ? depth_stencil : nullptr);

      state_block->Apply();
    }

    for (auto*& target : render_targets) {
      if (target != nullptr) {
        target->Release();
        target = nullptr;
      }
    }

    if (depth_stencil != nullptr) {
      depth_stencil->Release();
      depth_stencil = nullptr;
    }
  }
};

bool BlitDX9HDRCloneToOriginalSDR(
    reshade::api::device* device,
    reshade::api::resource float_source,
    const reshade::api::resource_desc& float_source_desc,
    reshade::api::resource sdr_target,
    const reshade::api::resource_desc& sdr_target_desc) {
  if (!DX9_GPU_READBACK_BLIT_ENABLED
      || device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9
      || float_source.handle == 0u
      || sdr_target.handle == 0u
      || float_source.handle == sdr_target.handle) {
    return false;
  }

  if (!IsFloat16RGBA(float_source_desc.texture.format)
      || !IsSupportedSDRReadbackFormat(sdr_target_desc.texture.format)
      || !SameTextureExtent(float_source_desc, sdr_target_desc)
      || float_source_desc.texture.depth_or_layers != 1u
      || sdr_target_desc.texture.depth_or_layers != 1u
      || float_source_desc.texture.samples != 1u
      || sdr_target_desc.texture.samples != 1u
      || IsCPUVisibleReadbackHeap(sdr_target_desc.heap)) {
    return false;
  }

  auto* native_device =
      reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  if (native_device == nullptr) return false;

  std::scoped_lock blit_lock(g_dx9_gpu_blit_mutex);

  if (!EnsureDX9GPUReadbackPipelineLocked(native_device)) {
    return false;
  }

  ScopedDX9NativeTexture direct_source_texture;
  IDirect3DTexture9* source_texture = nullptr;
  if (!PrepareDX9GPUReadbackSourceTextureLocked(
          native_device,
          float_source,
          float_source_desc,
          source_texture,
          direct_source_texture)
      || source_texture == nullptr) {
    return false;
  }

  ScopedDX9NativeSurface target_surface;
  if (!AcquireDX9NativeSurface(
          sdr_target,
          sdr_target_desc,
          0u,
          target_surface)
      || target_surface.surface == nullptr) {
    return false;
  }

  ScopedDX9RenderStateRestore restore;
  if (!restore.Capture(
          native_device,
          g_dx9_gpu_blit_cache.state_block)) {
    return false;
  }

  // Native calls bypass ReShade's state tracker, so explicitly remove any old
  // texture bindings that could alias the original SDR render target. The state
  // block restores them after the blit.
  for (DWORD stage = 0u; stage < 16u; ++stage) {
    native_device->SetTexture(stage, nullptr);
  }

  if (FAILED(native_device->SetRenderTarget(0u, target_surface.surface))) {
    return false;
  }

  for (uint32_t slot = 1u; slot < restore.render_target_count; ++slot) {
    native_device->SetRenderTarget(slot, nullptr);
  }

  native_device->SetDepthStencilSurface(nullptr);

  D3DVIEWPORT9 viewport = {
      0u,
      0u,
      sdr_target_desc.texture.width,
      sdr_target_desc.texture.height,
      0.0f,
      1.0f,
  };
  if (FAILED(native_device->SetViewport(&viewport))) return false;

  RECT scissor = {
      0,
      0,
      static_cast<LONG>(sdr_target_desc.texture.width),
      static_cast<LONG>(sdr_target_desc.texture.height),
  };
  native_device->SetScissorRect(&scissor);

  native_device->SetRenderState(D3DRS_ZENABLE, FALSE);
  native_device->SetRenderState(D3DRS_ZWRITEENABLE, FALSE);
  native_device->SetRenderState(D3DRS_ALPHATESTENABLE, FALSE);
  native_device->SetRenderState(D3DRS_ALPHABLENDENABLE, FALSE);
  native_device->SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, FALSE);
  native_device->SetRenderState(D3DRS_STENCILENABLE, FALSE);
  native_device->SetRenderState(D3DRS_FOGENABLE, FALSE);
  native_device->SetRenderState(D3DRS_SCISSORTESTENABLE, FALSE);
  native_device->SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  native_device->SetRenderState(
      D3DRS_COLORWRITEENABLE,
      D3DCOLORWRITEENABLE_RED
          | D3DCOLORWRITEENABLE_GREEN
          | D3DCOLORWRITEENABLE_BLUE
          | D3DCOLORWRITEENABLE_ALPHA);

  // The pixel shader performs the nonlinear encoding explicitly so the target
  // should store its output literally, regardless of any game's prior sRGB state.
  native_device->SetRenderState(D3DRS_SRGBWRITEENABLE, FALSE);

  native_device->SetSamplerState(0u, D3DSAMP_ADDRESSU, D3DTADDRESS_CLAMP);
  native_device->SetSamplerState(0u, D3DSAMP_ADDRESSV, D3DTADDRESS_CLAMP);
  native_device->SetSamplerState(0u, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
  native_device->SetSamplerState(0u, D3DSAMP_MINFILTER, D3DTEXF_POINT);
  native_device->SetSamplerState(0u, D3DSAMP_MIPFILTER, D3DTEXF_NONE);
  native_device->SetSamplerState(0u, D3DSAMP_SRGBTEXTURE, 0u);

  if (FAILED(native_device->SetVertexDeclaration(
          g_dx9_gpu_blit_cache.vertex_declaration))) {
    return false;
  }
  if (FAILED(native_device->SetVertexShader(
          g_dx9_gpu_blit_cache.vertex_shader))) {
    return false;
  }
  if (FAILED(native_device->SetPixelShader(
          g_dx9_gpu_blit_cache.pixel_shader))) {
    return false;
  }
  if (FAILED(native_device->SetTexture(0u, source_texture))) {
    return false;
  }

  const float inv_size[4] = {
      1.0f / static_cast<float>(sdr_target_desc.texture.width),
      1.0f / static_cast<float>(sdr_target_desc.texture.height),
      0.0f,
      0.0f,
  };
  native_device->SetVertexShaderConstantF(0u, inv_size, 1u);

  static const DX9GPUReadbackBlitVertex vertices[] = {
      {-1.0f,  1.0f, 0.0f, 1.0f, 0.0f, 0.0f},
      { 1.0f,  1.0f, 0.0f, 1.0f, 1.0f, 0.0f},
      {-1.0f, -1.0f, 0.0f, 1.0f, 0.0f, 1.0f},
      { 1.0f, -1.0f, 0.0f, 1.0f, 1.0f, 1.0f},
  };

  const HRESULT draw_hr = native_device->DrawPrimitiveUP(
      D3DPT_TRIANGLESTRIP,
      2u,
      vertices,
      sizeof(DX9GPUReadbackBlitVertex));

  native_device->SetTexture(0u, nullptr);

  if (FAILED(draw_hr)) {
    LogDX9GPUBlitFailure("Fullscreen HDR -> SDR DrawPrimitiveUP failed");
    return false;
  }

  return true;
}

bool TryConvertDX9FloatReadbackWithGPUBlit(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    reshade::api::resource dest,
    const reshade::api::resource_desc& dest_desc) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9
      || dest.handle == 0u
      || !IsCPUVisibleReadbackHeap(dest_desc.heap)) {
    return false;
  }

  const reshade::api::resource float_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource_desc float_source_desc =
      SelectCloneDescForCopy(source_endpoint);

  const reshade::api::resource sdr_original = source_endpoint.original;
  const reshade::api::resource_desc& sdr_original_desc =
      source_endpoint.original_desc;

  if (float_source.handle == 0u
      || sdr_original.handle == 0u
      || float_source.handle == sdr_original.handle
      || !IsFloat16RGBA(float_source_desc.texture.format)
      || !IsSupportedSDRReadbackFormat(sdr_original_desc.texture.format)
      || !IsSupportedSDRReadbackFormat(dest_desc.texture.format)
      || sdr_original_desc.texture.format != dest_desc.texture.format
      || !SameTextureExtent(float_source_desc, sdr_original_desc)
      || !SameTextureExtent(sdr_original_desc, dest_desc)
      || float_source_desc.texture.samples != 1u
      || sdr_original_desc.texture.samples != 1u
      || dest_desc.texture.samples != 1u) {
    return false;
  }

  if (!BlitDX9HDRCloneToOriginalSDR(
          device,
          float_source,
          float_source_desc,
          sdr_original,
          sdr_original_desc)) {
    return false;
  }

  // The original 8-bit target now contains the current SDR representation.
  // Finish with native GetRenderTargetData, which is the D3D9 operation the game
  // originally wanted and avoids sending this replacement copy back through the
  // ReShade callback stack.
  auto* native_device =
      reinterpret_cast<IDirect3DDevice9*>(device->get_native());
  if (native_device == nullptr) return false;

  ScopedDX9NativeSurface original_surface;
  ScopedDX9NativeSurface readback_surface;
  if (!AcquireDX9NativeSurface(
          sdr_original,
          sdr_original_desc,
          0u,
          original_surface)
      || !AcquireDX9NativeSurface(
          dest,
          dest_desc,
          0u,
          readback_surface)) {
    return false;
  }

  const HRESULT readback_hr = native_device->GetRenderTargetData(
      original_surface.surface,
      readback_surface.surface);
  if (FAILED(readback_hr)) {
    LogDX9GPUBlitFailure(
        "GPU SDR blit succeeded but native GetRenderTargetData failed");
    return false;
  }

  if (g_dx9_gpu_blit_success_logs < 8u) {
    ++g_dx9_gpu_blit_success_logs;

    std::stringstream stream;
    stream << "[RenoDX DX9 Readback GPU Blit] GPU-converted FP16 -> SDR -> CPU (";
    stream << float_source_desc.texture.width << "x";
    stream << float_source_desc.texture.height << ", ";
    stream << float_source_desc.texture.format << " -> ";
    stream << sdr_original_desc.texture.format << ")";
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
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

  // Serialize use of the single cached staging resource. D3D9 is normally an
  // immediate-context API, but this also keeps multi-threaded callback use safe.
  std::scoped_lock staging_lock(g_dx9_readback_staging_mutex);

  if (!EnsureDX9ReadbackStaging(
          device,
          staging_desc,
          staging)) {
    LogDX9ReadbackFailure(
        "Could not create/reuse the float16 CPU staging surface",
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
    InvalidateDX9ReadbackStaging(device);
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
  // ResolveDX9CopyEndpoint already queried this descriptor. Reuse it instead of
  // asking the resource tracker/device for the same description a second time.
  const reshade::api::resource_desc& dest_desc = dest_endpoint.input_desc;

  // Preferred path: refresh the game's original 8-bit resource from the FP16
  // clone with a GPU fullscreen blit, then issue a normal same-format readback.
  if (TryConvertDX9FloatReadbackWithGPUBlit(
          cmd_list,
          source_endpoint,
          dest,
          dest_desc)) {
    return true;
  }

  // Existing zero-conversion redirect remains as a compatibility fast path for
  // cases where the original SDR resource is already current.
  if (TryRedirectDX9CloneReadbackToOriginal(
          cmd_list,
          source_endpoint,
          dest,
          dest_desc)) {
    return true;
  }

  // Last resort: the original cached CPU FP16 -> SDR conversion.
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
#if 0  // Automatic DX9 output unclamper disabled
    new renodx::utils::settings::Setting{
        .key = "DX9AutoOutputUnclamp",
        .binding = &dx9_auto_output_unclamp_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Automatic Output Unclamp",
        .section = "HDR Pipeline",
        .tooltip = "Sky-test build: Level 3 applies the weapon-style terminal "
                   "highlight unclamp to almost every strict terminal sqrt output and "
                   "also to the two confirmed BO1 sky/cloud hashes and additional "
                   "sky-like shaders. The rewrite is only "
                   "sqrt(saturate(finalLighting)) -> sqrt(max(finalLighting, 0)); no "
                   "brightness multiplier, guarded reconstruction, or internal material "
                   "changes are used. Structural fog and utility shaders remain filtered. "
                   "Level 4 is a safe alias of level 3. Requires restart.",
        .labels = {
            "Off",
            "Curated post (sky/fog protected)",
            "Curated post + known viewmodels",
            "Broad highlights + broader sky test",
            "Same as level 3 (sky test alias)",
        },
        .is_global = true,
        .is_visible = []() { return false; },
    },
#endif  // Automatic DX9 output unclamper setting
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT", "Psycho", "Pragmap"},
        .parse = [](float value) {
          if (value < 0.5f) return TONE_MAP_TYPE_VANILLA;
          if (value < 1.5f) return TONE_MAP_TYPE_RENODRT;
          if (value < 2.5f) return TONE_MAP_TYPE_PSYCHO;
          return TONE_MAP_TYPE_PRAGMAP;
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
        .default_value = 1.f,
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
        .key = "HDRBoost",
        .binding = &shader_injection.hdr_boost,
        .default_value = 0.f,
        .label = "HDR Boost",
        .section = "Tone Mapping",
        .tooltip = "Applies the common.hlsl HDRBoost power curve before RenoDRT, Psycho, or Pragmap. 0 disables it; 20 matches the common.hlsl default power of 0.20. Values above 50 are intentionally unavailable because the original curve can extrapolate above that point.",
        .min = 0.f,
        .max = 50.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    // ---------------------------------------------------------------------
    // Psycho
    // ---------------------------------------------------------------------
    new renodx::utils::settings::Setting{
        .key = "PsychoCompression",
        .binding = &shader_injection.psycho_compression,
        .default_value = 0.f,
        .label = "Psycho Compression",
        .section = "Color Grading",
        .tooltip = "Psycho response compression. 0 = automatic; positive values select a manual response power.",
        .min = 0.f,
        .max = 400.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoConeResponse",
        .binding = &shader_injection.psycho_cone_response,
        .default_value = 50.f,
        .label = "Psycho Cone Response",
        .section = "Color Grading",
        .tooltip = "Scales Psycho cone response. 50 = 1.00 neutral.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoPurity",
        .binding = &shader_injection.psycho_purity,
        .default_value = 100.f,
        .label = "Psycho Purity",
        .section = "Color Grading",
        .tooltip = "Controls Psycho adaptation-relative LMS purity. 100% = neutral.",
        .min = 0.f,
        .max = 200.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPsychoEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoGamutCompression",
        .binding = &shader_injection.psycho_gamut_compression,
        .default_value = 100.f,
        .label = "Psycho Gamut Compression",
        .section = "Color Grading",
        .tooltip = "Controls Psycho target-gamut projection strength.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPsychoEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoGamutMode",
        .binding = &shader_injection.psycho_gamut_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Psycho Gamut Mode",
        .section = "Color Grading",
        .labels = {"BT709", "BT2020"},
        .is_enabled = []() { return IsPsychoEnabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    // ---------------------------------------------------------------------
    // Pragmap
    // ---------------------------------------------------------------------
    new renodx::utils::settings::Setting{
        .key = "PragmapHueStrength",
        .binding = &shader_injection.pragmap_hue_strength,
        .default_value = 75.f,
        .label = "Pragmap Hue Strength",
        .section = "Color Grading",
        .tooltip = "Controls Pragmap's Bezold-Brucke hue shift. 75% matches the supplied default.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPragmapEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PragmapBlowoutStrength",
        .binding = &shader_injection.pragmap_blowout_strength,
        .default_value = 75.f,
        .label = "Pragmap Blowout Strength",
        .section = "Color Grading",
        .tooltip = "Controls Pragmap's highlight blowout/desaturation. 75% matches the supplied default.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPragmapEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
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
        // New key so an older hidden BloomBrightness=300 preset cannot
        // silently force this new post-tonemap bloom shader to 300%.
        .key = "BloomStrength",
        .binding = &shader_injection.bloom_brightness,
        .default_value = 100.f,
        .label = "Bloom Strength",
        .section = "Bloom",
        .tooltip = "Controls post-tonemap bloom strength. 0 = off, 100 = original/current bloom, 200 = double strength.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return true; },
    },
    new renodx::utils::settings::Setting{
        .key = "BloomFlareSize",
        .binding = &shader_injection.bloom_flare_size,
        .default_value = 100.f,
        .label = "Flare Size",
        .section = "Bloom",
        .tooltip = "Controls how much of broad, screen-covering lens flare is retained. 0 keeps mostly the bright core; 100 retains the full flare extent.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false;},
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

// ============================================================================
// D3D9 windowed -> borderless windowed, sized from the real backbuffer
// ============================================================================
//
// Do not derive borderless size from GetClientRect() and do not blindly stretch
// the HWND to the monitor. Both can disagree with an explicitly-sized D3D9
// backbuffer.
//
// Instead, OnPresent obtains the ACTUAL swapchain backbuffer resource and passes
// its texture dimensions here. A borderless popup has no non-client frame, so
// making its outer size equal to the backbuffer size also makes its client area
// equal to the backbuffer size.
//
// This keeps the game's D3D9 presentation/readback dimensions coherent and does
// not modify any of the DX9 CPU blit/readback handlers below.

void ApplyWindowedBorderless(
    HWND hwnd,
    uint32_t backbuffer_width,
    uint32_t backbuffer_height) {
  if (force_windowed_borderless < 0.5f) return;
  if (hwnd == nullptr || !IsWindow(hwnd)) return;
  if (backbuffer_width == 0u || backbuffer_height == 0u) return;

  const LONG_PTR style = GetWindowLongPtrW(hwnd, GWL_STYLE);
  const LONG_PTR ex_style = GetWindowLongPtrW(hwnd, GWL_EXSTYLE);

  // Never touch child windows.
  if ((style & WS_CHILD) != 0) return;

  // Only convert a normal framed/windowed HWND.
  // An exclusive/fullscreen popup normally has none of these frame bits, so it
  // remains completely untouched.
  constexpr LONG_PTR WINDOWED_FRAME_BITS =
      WS_CAPTION | WS_THICKFRAME | WS_BORDER | WS_DLGFRAME;

  if ((style & WINDOWED_FRAME_BITS) == 0) return;

  HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);

  MONITORINFO monitor_info = {};
  monitor_info.cbSize = sizeof(monitor_info);
  if (!GetMonitorInfoW(monitor, &monitor_info)) return;

  const RECT& monitor_rect = monitor_info.rcMonitor;
  const int monitor_width = monitor_rect.right - monitor_rect.left;
  const int monitor_height = monitor_rect.bottom - monitor_rect.top;

  const int target_width = static_cast<int>(backbuffer_width);
  const int target_height = static_cast<int>(backbuffer_height);

  // Full native-resolution windowed mode becomes monitor-filling borderless.
  // Smaller D3D9 backbuffers stay at their actual render size and are centered.
  const int target_x =
      (target_width == monitor_width)
          ? monitor_rect.left
          : monitor_rect.left + ((monitor_width - target_width) / 2);

  const int target_y =
      (target_height == monitor_height)
          ? monitor_rect.top
          : monitor_rect.top + ((monitor_height - target_height) / 2);

  LONG_PTR borderless_style = style;
  borderless_style &= ~(WS_CAPTION | WS_THICKFRAME | WS_BORDER | WS_DLGFRAME |
                        WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
  borderless_style |= WS_POPUP | WS_VISIBLE;

  LONG_PTR borderless_ex_style = ex_style;
  borderless_ex_style &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE |
                           WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);

  if (borderless_style != style) {
    SetWindowLongPtrW(hwnd, GWL_STYLE, borderless_style);
  }

  if (borderless_ex_style != ex_style) {
    SetWindowLongPtrW(hwnd, GWL_EXSTYLE, borderless_ex_style);
  }

  // Do not force Z-order/focus changes. Only apply the frame change, position,
  // and dimensions that correspond to the real D3D9 backbuffer.
  SetWindowPos(
      hwnd,
      nullptr,
      target_x,
      target_y,
      target_width,
      target_height,
      SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOACTIVATE |
          SWP_FRAMECHANGED | SWP_SHOWWINDOW);
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  if (queue == nullptr) return;

  auto* device = queue->get_device();
  if (device == nullptr) return;

  if (device->get_api() == reshade::api::device_api::opengl) {
    shader_injection.custom_flip_uv_y = 1.f;
  }

  if (swapchain == nullptr) return;

  HWND hwnd = reinterpret_cast<HWND>(swapchain->get_hwnd());
  if (hwnd == nullptr) return;

  uint32_t backbuffer_width = 0u;
  uint32_t backbuffer_height = 0u;

  // Use the real presentation resource dimensions. This is the important
  // difference from the previous borderless attempts.
  const reshade::api::resource backbuffer = swapchain->get_back_buffer(0u);
  if (backbuffer.handle != 0u) {
    const reshade::api::resource_desc backbuffer_desc =
        device->get_resource_desc(backbuffer);

    backbuffer_width = backbuffer_desc.texture.width;
    backbuffer_height = backbuffer_desc.texture.height;
  }

  ApplyWindowedBorderless(
      hwnd,
      backbuffer_width,
      backbuffer_height);
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

        // Always register Present so Windowed Borderless works even when the
        // display proxy is disabled.
        reshade::register_event<reshade::addon_event::present>(OnPresent);

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
              .key = "SwapChainWindowedBorderless",
              .binding = &force_windowed_borderless,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Windowed Borderless",
              .section = "Display Output",
              .tooltip = "Converts normal Windowed mode to borderless using the actual D3D9 swapchain backbuffer dimensions. Use the monitor native resolution for full-monitor borderless.",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          force_windowed_borderless = setting->GetValue();
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
          if (!use_device_proxy) {
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
       
        const reshade::api::format scene_intermediate_formats[] = {
    reshade::api::format::b8g8r8a8_unorm,
};

const float scene_intermediate_aspect_ratios[] = {
    16.f / 9.f,    // Standard widescreen
    16.f / 10.f,
    24.f / 10.f,   // 3840x1600
    43.f / 18.f,   // 3440x1440
    64.f / 27.f,   // 5120x2160
};

for (const auto old_format : scene_intermediate_formats) {
  for (const float aspect_ratio : scene_intermediate_aspect_ratios) {
    renodx::mods::swapchain::resource_upgrade_infos.push_back({
        .old_format = old_format,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = false,
        .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = false,
        .aspect_ratio = aspect_ratio,
        .aspect_ratio_tolerance = 0.001f,
        .usage_include = reshade::api::resource_usage::render_target,
        .name = "Scene Intermediate",
    });
  }
}
      


     
    
        
        // D3D9 copy/readback interception. These callbacks are ignored for the
        // D3D11/D3D12 display-proxy side and are recursion-guarded internally.
        // Release the cached native D3D9 blit objects before Reset/device teardown.
        reshade::register_event<reshade::addon_event::destroy_device>(
            OnDX9ReadbackDestroyDevice);
        reshade::register_event<reshade::addon_event::destroy_swapchain>(
            OnDX9ReadbackDestroySwapchain);
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
      ClearDX9ReadbackOptimizationCaches();
#if 0  // Automatic DX9 output unclamper disabled
      reshade::unregister_event<reshade::addon_event::create_pipeline>(
          OnCreatePipelineDX9AutoOutputUnclamp);
      ClearDX9AutoOutputUnclampCache();
#endif
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(
          OnDX9ResolveTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(
          OnDX9CopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_resource>(
          OnDX9CopyResource);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(
          OnDX9ReadbackDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_device>(
          OnDX9ReadbackDestroyDevice);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

#if 0  // Automatic DX9 output unclamper disabled
  // Register after RenoDX's shader module so hash-based embedded replacements
  // are resolved first and this patcher only sees the final ps_3_0 bytecode.
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::create_pipeline>(
        OnCreatePipelineDX9AutoOutputUnclamp);
  }
#endif

  return TRUE;
}
