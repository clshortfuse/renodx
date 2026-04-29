#pragma once

#include <array>
#include <cstdint>
#include <cstring>
#include <span>

namespace alienisolation::aliasisolation {

enum class ShaderId : uint32_t {
  Unknown,
  MainPostVs,
  SmaaVs,
  RgbmEncodeVs,
  RgbmEncodePs,
  DofEncodePs,
  CameraMotionPs,
  SmaaSpatialPs,
  ShadowLinearizePs,
  ShadowDownsamplePs,
  BloomMergePs,
  Count,
};

struct DxbcChecksum {
  std::array<uint32_t, 4> words = {};
};

inline bool MatchesDxbcChecksum(std::span<const uint8_t> code, const DxbcChecksum& checksum) {
  if (code.size() < 20u) return false;
  if (code[0] != 'D' || code[1] != 'X' || code[2] != 'B' || code[3] != 'C') return false;

  std::array<uint32_t, 4> actual = {};
  std::memcpy(actual.data(), code.data() + 4u, sizeof(actual));
  return actual == checksum.words;
}

inline ShaderId IdentifyVertexShader(std::span<const uint8_t> code) {
  if (MatchesDxbcChecksum(code, {{0x40af2521, 0x0abe7ef9, 0x8cafc30b, 0xa48433af}})) return ShaderId::MainPostVs;
  if (MatchesDxbcChecksum(code, {{0x021e3541, 0xc8808c25, 0x81beb6be, 0x342bfddd}})) return ShaderId::SmaaVs;
  if (MatchesDxbcChecksum(code, {{0xa851671d, 0xbe79cf68, 0x2e6d9376, 0x567ba13c}})) return ShaderId::RgbmEncodeVs;
  return ShaderId::Unknown;
}

inline ShaderId IdentifyPixelShader(std::span<const uint8_t> code) {
  if (MatchesDxbcChecksum(code, {{0x4fcfc7f7, 0x5c5e12cf, 0x059e8b33, 0x11f8489b}})) return ShaderId::RgbmEncodePs;
  if (MatchesDxbcChecksum(code, {{0x29ed6504, 0x77d5438c, 0xe9c206c8, 0xb1f27ba2}})) return ShaderId::DofEncodePs;
  if (MatchesDxbcChecksum(code, {{0x1fb3edd4, 0xe984323b, 0x11bcf154, 0x5a029c94}})) return ShaderId::CameraMotionPs;
  if (MatchesDxbcChecksum(code, {{0x02b5231b, 0x8b3879b8, 0x7db9bc8d, 0xf46a9d78}})) return ShaderId::SmaaSpatialPs;
  if (MatchesDxbcChecksum(code, {{0x3c7b9d08, 0x7b3adf54, 0x3bfc6b9d, 0x1b0ec92e}})) return ShaderId::ShadowLinearizePs;
  if (MatchesDxbcChecksum(code, {{0x8d485646, 0x7d707454, 0x95bf6cb1, 0x09b85460}})) return ShaderId::ShadowDownsamplePs;
  if (MatchesDxbcChecksum(code, {{0xc0fbe484, 0x2d952c03, 0x993de248, 0x56ad9263}})) return ShaderId::BloomMergePs;
  return ShaderId::Unknown;
}

inline const char* ShaderIdName(ShaderId id) {
  switch (id) {
    case ShaderId::MainPostVs:
      return "MainPostVs";
    case ShaderId::SmaaVs:
      return "SmaaVs";
    case ShaderId::RgbmEncodeVs:
      return "RgbmEncodeVs";
    case ShaderId::RgbmEncodePs:
      return "RgbmEncodePs";
    case ShaderId::DofEncodePs:
      return "DofEncodePs";
    case ShaderId::CameraMotionPs:
      return "CameraMotionPs";
    case ShaderId::SmaaSpatialPs:
      return "SmaaSpatialPs";
    case ShaderId::ShadowLinearizePs:
      return "ShadowLinearizePs";
    case ShaderId::ShadowDownsamplePs:
      return "ShadowDownsamplePs";
    case ShaderId::BloomMergePs:
      return "BloomMergePs";
    default:
      return "Unknown";
  }
}

}  // namespace alienisolation::aliasisolation
