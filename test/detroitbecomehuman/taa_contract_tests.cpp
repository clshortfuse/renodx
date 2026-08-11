/*
 * SPDX-License-Identifier: MIT
 */

#include <array>
#include <bit>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <limits>
#include <span>
#include <string_view>
#include <type_traits>

#include "src/games/detroitbecomehuman/dlss_bridge_abi.h"
#include "src/games/detroitbecomehuman/taa_contract.hpp"

namespace {

namespace taa_contract = renodx::games::detroitbecomehuman::taa_contract;

template <typename T>
concept HasVerificationFlags = requires(T value) {
  value.verification_flags;
};

static_assert(!HasVerificationFlags<taa_contract::DecodedConstants>);
static_assert(
    DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY >= taa_contract::kConstantsSize);
static_assert(
    sizeof(DetroitDlssTemporalConstantsSnapshot::constants)
    == DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY);
static_assert(taa_contract::kExposureTextureChannel == 1u);
static_assert(taa_contract::kDepthIsInverted);
static_assert(
    taa_contract::GetNgxJitterOffset(0.125f, -0.375f)
    == taa_contract::Float2{0.125f, -0.375f});
static_assert(
    taa_contract::GetNgxMotionVectorScale(3440u, 1440u)
    == taa_contract::Float2{-3440.f, -1440.f});
static_assert(std::is_same_v<
              decltype(taa_contract::Constants::viewport_origin_size),
              taa_contract::Int4>);
static_assert(std::is_same_v<
              decltype(taa_contract::Constants::viewport_top_left_minus_one),
              taa_contract::Int4>);
static_assert(std::is_same_v<
              decltype(taa_contract::Constants::debug_coord_x),
              std::uint32_t>);
static_assert(std::is_same_v<
              decltype(taa_contract::Constants::debug_coord_y),
              std::uint32_t>);

bool Expect(bool condition, std::string_view description) {
  if (condition) return true;
  std::cerr << "FAIL: " << description << '\n';
  return false;
}

template <typename T>
void Write(
    std::array<std::byte, taa_contract::kConstantsSize>* payload,
    std::size_t offset,
    const T& value) {
  std::memcpy(payload->data() + offset, &value, sizeof(value));
}

std::array<std::byte, taa_contract::kConstantsSize> MakePayload() {
  using taa_contract::Float4;
  using taa_contract::Int4;

  std::array<std::byte, taa_contract::kConstantsSize> payload = {};
  for (std::size_t index = 0u; index < 64u; ++index) {
    Write(&payload, index * sizeof(float), static_cast<float>(index + 1u));
  }

  Write(&payload, 256u, Float4{65.f, 66.f, 67.f, 68.f});
  Write(&payload, 272u, Float4{69.f, 70.f, 71.f, 72.f});
  Write(&payload, 288u, Float4{73.f, 74.f, 75.f, 76.f});
  Write(&payload, 304u, Int4{77, 78, 79, 80});
  Write(&payload, 320u, Int4{81, 82, 83, 84});
  Write(&payload, 336u, Float4{85.f, 86.f, 87.f, 88.f});
  Write(&payload, 352u, 89.f);
  Write(&payload, 356u, 90.f);
  Write(&payload, 360u, 91.f);
  Write(&payload, 364u, 92.f);
  Write(&payload, 368u, Float4{93.f, 94.f, 95.f, 96.f});
  Write(&payload, 384u, Float4{97.f, 98.f, 99.f, 100.f});
  Write(&payload, 400u, Float4{101.f, 102.f, 103.f, 104.f});
  Write(&payload, 416u, 105.f);
  Write(&payload, 420u, 106.f);
  Write(&payload, 424u, 107.f);
  Write(&payload, 428u, UINT32_C(0xA1A2A3A4));
  Write(&payload, 432u, 108.f);
  Write(&payload, 436u, 109.f);
  Write(&payload, 440u, 110.f);
  Write(&payload, 444u, 111.f);
  Write(&payload, 448u, Float4{112.f, 113.f, 114.f, 115.f});
  Write(&payload, 464u, UINT32_C(0xB1B2B3B4));
  Write(&payload, 468u, UINT32_C(0xC1C2C3C4));
  Write(&payload, 472u, 116.f);
  Write(&payload, 476u, UINT32_C(0xD1D2D3D4));
  Write(&payload, 480u, UINT32_C(0xE1E2E3E4));
  Write(&payload, 484u, UINT32_C(0xF1F2F3F4));
  Write(&payload, 488u, UINT32_C(0xFEDCBA98));
  Write(&payload, 492u, UINT32_C(0x89ABCDEF));
  return payload;
}

bool TestShaderInterface() {
  using taa_contract::SampledBinding;
  using taa_contract::StorageBinding;

  constexpr std::array<SampledBinding, 8u> expected_sampled = {{
      {0u, "PrevAADepthTex"},
      {1u, "CurrColorTex"},
      {2u, "PrevColorTex"},
      {3u, "CurrZBuffer"},
      {4u, "MotionVectorTex"},
      {5u, "AvgLumMap"},
      {6u, "TAAFlagsTexture"},
      {7u, "PrevSpeedAndFlagsTex"},
  }};
  constexpr std::array<StorageBinding, 4u> expected_storage = {{
      {16u, "OutColorPass", "r32ui"},
      {17u, "OutAADepth", "r16f"},
      {18u, "OutPrevSpeedAndFlagsTex", "r16ui"},
      {19u, "HalfResContours", "r8ui"},
  }};

  bool passed = true;
  passed &= Expect(taa_contract::kShaderCrc == 0xB5506A45u, "TAA CRC changed");
  passed &= Expect(
      taa_contract::kWorkgroupSize == std::array<std::uint32_t, 3u>{8u, 8u, 1u},
      "compute workgroup changed");
  passed &= Expect(taa_contract::kConstantsBinding == 52u, "UBO binding changed");
  passed &= Expect(taa_contract::kConstantsSize == 496u, "UBO size changed");
  passed &= Expect(
      taa_contract::kRequiredSampledBindings == expected_sampled,
      "active sampled bindings changed");
  passed &= Expect(
      taa_contract::kRequiredStorageBindings == expected_storage,
      "storage bindings or formats changed");
  passed &= Expect(
      !taa_contract::IsRequiredSampledBinding(9u),
      "inactive b9 became required");
  return passed;
}

bool TestNgxInputConventions() {
  const auto ultrawide_scale =
      taa_contract::GetNgxMotionVectorScale(3440u, 1440u);
  const auto regular_scale =
      taa_contract::GetNgxMotionVectorScale(1920u, 1080u);
  const auto zero_scale = taa_contract::GetNgxMotionVectorScale(0u, 0u);

  bool passed = true;
  passed &= Expect(
      taa_contract::kExposureTextureChannel == 1u,
      "NGX exposure must be sourced from AvgLumMap channel G");
  passed &= Expect(
      taa_contract::kDepthIsInverted,
      "NGX must receive Detroit depth as inverted");
  passed &= Expect(
      ultrawide_scale == taa_contract::Float2{-3440.f, -1440.f},
      "3440x1440 normalized motion vectors need negative pixel scaling");
  passed &= Expect(
      regular_scale == taa_contract::Float2{-1920.f, -1080.f},
      "ordinary 1920x1080 extent needs negative pixel scaling");
  passed &= Expect(
      zero_scale.x == 0.f
          && zero_scale.y == 0.f
          && std::signbit(zero_scale.x)
          && std::signbit(zero_scale.y),
      "zero extent must remain signed negative zero without unsigned underflow");
  return passed;
}

bool TestDeterministicDecode() {
  using taa_contract::Float4;
  using taa_contract::Int4;

  const auto decoded = taa_contract::DecodeConstants(MakePayload());
  bool passed = true;
  passed &= Expect(decoded.has_value(), "exact 496-byte payload must decode");
  if (!decoded.has_value()) return false;

  passed &= Expect(
      std::bit_cast<float>(decoded->raw.matrices[0u][0u]) == 1.f
          && std::bit_cast<float>(decoded->raw.matrices[0u][31u]) == 32.f
          && std::bit_cast<float>(decoded->raw.matrices[1u][0u]) == 33.f
          && std::bit_cast<float>(decoded->raw.matrices[1u][31u]) == 64.f,
      "matrix regions decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.proj_setup == Float4{65.f, 66.f, 67.f, 68.f},
      "proj_setup decoded at wrong offset");
  passed &= Expect(
      decoded->raw.render_target_size_inv == Float4{69.f, 70.f, 71.f, 72.f}
          && decoded->raw.src_texture_size_inv == Float4{73.f, 74.f, 75.f, 76.f},
      "inverse size candidates decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.viewport_origin_size == Int4{77, 78, 79, 80}
          && decoded->raw.viewport_top_left_minus_one == Int4{81, 82, 83, 84}
          && decoded->raw.viewport_origin_top_left_upsampled
                 == Float4{85.f, 86.f, 87.f, 88.f},
      "viewport values decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.history == 89.f
          && decoded->raw.responsive == 90.f
          && decoded->raw.rain == 91.f
          && decoded->raw.disocclusion == 92.f,
      "history flags decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.dejitter0 == Float4{93.f, 94.f, 95.f, 96.f}
          && decoded->raw.dejitter1 == Float4{97.f, 98.f, 99.f, 100.f}
          && decoded->raw.pixel_to_clip == Float4{101.f, 102.f, 103.f, 104.f},
      "dejitter values decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.contour_depth == 105.f
          && decoded->raw.min_exposure == 106.f
          && decoded->raw.prev_exposure_comp == 107.f
          && decoded->raw.padding_428 == UINT32_C(0xA1A2A3A4),
      "contour/exposure values decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.jitter_x == 108.f
          && decoded->raw.jitter_y == 109.f
          && decoded->raw.upsampling == 110.f
          && decoded->raw.inv_upsampling == 111.f,
      "jitter/upsampling values decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.resampled_uv_scale == Float4{112.f, 113.f, 114.f, 115.f}
          && decoded->raw.debug_frame == UINT32_C(0xB1B2B3B4)
          && decoded->raw.contour_enable == UINT32_C(0xC1C2C3C4)
          && decoded->raw.prev_upsampling == 116.f,
      "resampling/debug values decoded at wrong offsets");
  passed &= Expect(
      decoded->raw.padding_476 == UINT32_C(0xD1D2D3D4)
          && decoded->raw.debug_options == UINT32_C(0xE1E2E3E4)
          && decoded->raw.features == UINT32_C(0xF1F2F3F4)
          && decoded->raw.debug_coord_x == UINT32_C(0xFEDCBA98)
          && decoded->raw.debug_coord_y == UINT32_C(0x89ABCDEF),
      "tail values decoded at wrong offsets");
  passed &= Expect(
      decoded->plausibility.IsPlausible(),
      "finite positive deterministic payload must be plausible");
  return passed;
}

bool TestDecodeRejectsWrongSize() {
  const std::array<std::byte, 0u> empty_payload = {};
  const std::array<std::byte, taa_contract::kConstantsSize - 1u>
      boundary_short_payload = {};
  const std::array<std::byte, taa_contract::kConstantsSize + 1u>
      boundary_oversized_payload = {};
  const std::array<std::byte, DETROIT_DLSS_TEMPORAL_CONSTANTS_CAPACITY>
      transport_capacity_payload = {};

  bool passed = true;
  passed &= Expect(
      !taa_contract::DecodeConstants(empty_payload).has_value(),
      "empty payload must fail closed");
  passed &= Expect(
      !taa_contract::DecodeConstants(boundary_short_payload).has_value(),
      "495-byte payload must fail closed");
  passed &= Expect(
      !taa_contract::DecodeConstants(boundary_oversized_payload).has_value(),
      "497-byte payload must fail closed instead of truncating");
  passed &= Expect(
      !taa_contract::DecodeConstants(transport_capacity_payload).has_value(),
      "transport-capacity payload must fail instead of overflowing the 496-byte contract");

  const auto exact_payload = MakePayload();
  passed &= Expect(
      taa_contract::DecodeConstants(exact_payload).has_value(),
      "496-byte boundary payload must decode");
  return passed;
}

bool TestExactSubspanHonorsPayloadBoundary() {
  constexpr std::byte kLeadingGuard{0x5Au};
  constexpr std::byte kTrailingGuard{0xA5u};
  std::array<std::byte, taa_contract::kConstantsSize + 2u> guarded = {};
  guarded.front() = kLeadingGuard;
  guarded.back() = kTrailingGuard;

  const auto payload = MakePayload();
  std::memcpy(guarded.data() + 1u, payload.data(), payload.size());

  const std::span<const std::byte> full_span{guarded};
  const auto exact_span = full_span.subspan(1u, taa_contract::kConstantsSize);
  const auto decoded = taa_contract::DecodeConstants(exact_span);

  bool passed = true;
  passed &= Expect(
      decoded.has_value(),
      "an exact 496-byte subspan must decode at a nonzero transport offset");
  passed &= Expect(
      !taa_contract::DecodeConstants(full_span).has_value(),
      "guarded 498-byte transport span must not be truncated implicitly");
  passed &= Expect(
      guarded.front() == kLeadingGuard && guarded.back() == kTrailingGuard,
      "decoder must not cross either payload boundary");
  if (decoded.has_value()) {
    passed &= Expect(
        decoded->raw.debug_coord_y == UINT32_C(0x89ABCDEF),
        "the final four bytes at offsets 492-495 must remain readable");
  }
  return passed;
}

bool TestPlausibilityDoesNotVerifyRuntimeSemantics() {
  auto non_finite_payload = MakePayload();
  Write(
      &non_finite_payload,
      432u,
      std::numeric_limits<float>::quiet_NaN());
  const auto non_finite = taa_contract::DecodeConstants(non_finite_payload);

  auto zero_size_payload = MakePayload();
  Write(&zero_size_payload, 272u, 0.f);
  const auto zero_size = taa_contract::DecodeConstants(zero_size_payload);

  auto zero_scale_payload = MakePayload();
  Write(&zero_scale_payload, 440u, 0.f);
  const auto zero_scale = taa_contract::DecodeConstants(zero_scale_payload);

  auto reset_history_payload = MakePayload();
  Write(&reset_history_payload, 472u, 0.f);
  const auto reset_history = taa_contract::DecodeConstants(reset_history_payload);

  bool passed = true;
  passed &= Expect(
      non_finite.has_value()
          && !non_finite->plausibility.all_float_candidates_finite
          && !non_finite->plausibility.IsPlausible(),
      "NaN must be preserved but fail finite plausibility");
  passed &= Expect(
      zero_size.has_value()
          && zero_size->plausibility.all_float_candidates_finite
          && !zero_size->plausibility.size_candidates_positive
          && !zero_size->plausibility.IsPlausible(),
      "zero inverse size must remain raw but fail positive plausibility");
  passed &= Expect(
      zero_scale.has_value()
          && zero_scale->plausibility.all_float_candidates_finite
          && !zero_scale->plausibility.scale_candidates_positive
          && !zero_scale->plausibility.IsPlausible(),
      "zero upsampling scale must remain raw but fail positive plausibility");
  passed &= Expect(
      reset_history.has_value()
          && reset_history->plausibility.scale_candidates_positive
          && reset_history->plausibility.IsPlausible(),
      "nonpositive previous upsampling is a reset marker, not malformed constants");
  return passed;
}

bool TestLiveNgxFrameParameterPolicy() {
  taa_contract::Constants constants = {};
  constants.render_target_size_inv = {
      3440.f, 1440.f, 1.f / 3440.f, 1.f / 1440.f};
  constants.src_texture_size_inv = constants.render_target_size_inv;
  constants.viewport_origin_size = {0, 0, 3440, 1440};
  constants.jitter_x = 0.125f;
  constants.jitter_y = -0.37500003f;
  constants.upsampling = 1.f;
  constants.inv_upsampling = 1.f;
  constants.prev_upsampling = 1.f;
  constants.history = 0.9f;

  const auto live = taa_contract::BuildNgxFrameParameters(
      constants, 3440u, 1440u, 3440u, 1440u);
  bool passed = true;
  passed &= Expect(live.IsValid(), "captured native-scale b52 fields must validate");
  passed &= Expect(
      live.motion_vector_scale == taa_contract::Float2{-3440.f, -1440.f},
      "validated frame must use normalized current-minus-previous conversion");
  passed &= Expect(
      live.jitter_x == constants.jitter_x && live.jitter_y == constants.jitter_y,
      "validated frame must preserve Detroit pixel-space jitter at the NGX boundary");
  passed &= Expect(live.reset == 0u, "stable 0.9 history must not reset DLSS");

  constants.render_target_size_inv = {
      3440.f, 1440.f, 1.f / 3440.f, 1.f / 1440.f};
  constants.src_texture_size_inv = {
      1720.f, 720.f, 1.f / 1720.f, 1.f / 720.f};
  // Live Build 12158144 SR capture: viewport remains output-sized and the
  // temporal tuning pair remains 1/1. Actual scale is proven by resource and
  // src_texture_size extents.
  constants.viewport_origin_size = {0, 0, 3440, 1440};
  constants.upsampling = 1.f;
  constants.inv_upsampling = 1.f;
  constants.prev_upsampling = 1.f;
  const auto sr = taa_contract::BuildNgxFrameParameters(
      constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      sr.IsValid()
          && sr.motion_vector_scale == taa_contract::Float2{-1720.f, -720.f}
          && sr.reset == 0u,
      "captured SR b52 must use output viewport/target and reduced source extents");

  auto swapped_sr_constants = constants;
  swapped_sr_constants.render_target_size_inv =
      swapped_sr_constants.src_texture_size_inv;
  const auto swapped_sr = taa_contract::BuildNgxFrameParameters(
      swapped_sr_constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      !swapped_sr.IsValid() && !swapped_sr.dimensions_valid,
      "SR render_target_size must not be validated against the input extent");

  constants.prev_upsampling = 0.f;
  const auto first_sr_frame = taa_contract::BuildNgxFrameParameters(
      constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      first_sr_frame.IsValid() && first_sr_frame.history_valid
          && first_sr_frame.reset == 1u,
      "missing previous scale must be accepted as an explicit history reset");

  constants.prev_upsampling = 1.f;
  constants.jitter_x = -0.5f;
  constants.jitter_y = 0.5f;
  const auto jitter_boundary = taa_contract::BuildNgxFrameParameters(
      constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      jitter_boundary.IsValid(),
      "inclusive half-pixel jitter boundaries must remain valid");
  constants.jitter_x = -0.5001f;
  const auto excessive_jitter = taa_contract::BuildNgxFrameParameters(
      constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      !excessive_jitter.IsValid() && !excessive_jitter.jitter_valid,
      "jitter outside [-0.5, 0.5] must fail closed");

  constants.jitter_x = 0.f;
  constants.viewport_origin_size = {1, 0, 3440, 1440};
  const auto offset_viewport = taa_contract::BuildNgxFrameParameters(
      constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      !offset_viewport.IsValid() && !offset_viewport.viewport_valid,
      "nonzero temporal viewport origin must fail closed");
  constants.viewport_origin_size = {0, 0, 1720, 720};
  const auto partial_viewport = taa_contract::BuildNgxFrameParameters(
      constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      !partial_viewport.IsValid() && !partial_viewport.viewport_valid,
      "legacy render-sized temporal viewport must fail the captured output contract");

  constants.viewport_origin_size = {0, 0, 3440, 1440};
  constants.upsampling = 2.f;
  constants.inv_upsampling = 1.f;
  const auto nonreciprocal_temporal_scale =
      taa_contract::BuildNgxFrameParameters(
          constants, 1720u, 720u, 3440u, 1440u);
  passed &= Expect(
      !nonreciprocal_temporal_scale.IsValid()
          && !nonreciprocal_temporal_scale.scale_valid,
      "nonreciprocal temporal scale tuning fields must fail closed");

  constants.render_target_size_inv = {
      3440.f, 1440.f, 1.f / 3440.f, 1.f / 1440.f};
  constants.src_texture_size_inv = constants.render_target_size_inv;
  constants.viewport_origin_size = {0, 0, 3440, 1440};
  constants.upsampling = 1.f;
  constants.inv_upsampling = 1.f;
  constants.prev_upsampling = 1.f;
  constants.history = 0.f;
  const auto cut = taa_contract::BuildNgxFrameParameters(
      constants, 3440u, 1440u, 3440u, 1440u);
  passed &= Expect(cut.IsValid() && cut.reset == 1u, "zero native history must reset DLSS");

  constants.history = 0.9f;
  constants.jitter_x = std::numeric_limits<float>::quiet_NaN();
  const auto invalid = taa_contract::BuildNgxFrameParameters(
      constants, 3440u, 1440u, 3440u, 1440u);
  passed &= Expect(
      !invalid.IsValid() && !invalid.jitter_valid,
      "non-finite jitter must fail closed even when other b52 fields match");
  return passed;
}

}  // namespace

int main() {
  bool passed = true;
  passed &= TestShaderInterface();
  passed &= TestNgxInputConventions();
  passed &= TestDeterministicDecode();
  passed &= TestDecodeRejectsWrongSize();
  passed &= TestExactSubspanHonorsPayloadBoundary();
  passed &= TestPlausibilityDoesNotVerifyRuntimeSemantics();
  passed &= TestLiveNgxFrameParameterPolicy();
  return passed ? 0 : 1;
}
