#ifndef RENODX_SHADERS_COLOR_YCBCR_HLSL
#define RENODX_SHADERS_COLOR_YCBCR_HLSL

#include "./rgb.hlsl"

namespace renodx {
namespace color {

namespace ycbcr {
namespace from {

// Limited (studio) -> "full" convention used by Decode():
//   Y  expanded to full swing
//   Cb/Cr mapped so that 0.5 is neutral and span matches full chroma swing
float3 Limited(float3 ycbcr_limited) {
  const float Yoff = 16.f / 255.f;              // 0.06274509803921568627450980392157
  const float chroma_offset = 128.f / 255.f;    // 0.50196078431372549019607843137255
  const float Yscale = 255.f / (235.f - 16.f);  // 1.1643835616438356164383561643836
  const float Cscale = 255.f / (240.f - 16.f);  // 1.1383928571428571428571428571429

  float Y = (ycbcr_limited.x - Yoff) * Yscale;
  float Cb = (ycbcr_limited.y - chroma_offset) * Cscale + chroma_offset;
  float Cr = (ycbcr_limited.z - chroma_offset) * Cscale + chroma_offset;

  return float3(Y, Cb, Cr);
}

}  // namespace from

float3 Decode(float3 ycbcr_full, float3 k) {
  const float chroma_offset = 128.f / 255.0f;  // 0.50196078431372549019607843137255
  const float Y = ycbcr_full.x;
  const float Cb = ycbcr_full.y - chroma_offset;
  const float Cr = ycbcr_full.z - chroma_offset;

  const float Rp = Y + (2.0f - 2.0f * k.r) * Cr;
  const float Bp = Y + (2.0f - 2.0f * k.b) * Cb;
  const float Gp = Y - (k.r / k.g) * (Rp - Y) - (k.b / k.g) * (Bp - Y);
  return float3(Rp, Gp, Bp);
}

}  // namespace ycbcr

namespace bt601 {
namespace from {
float3 YCbCr(float3 ycbcr_full) {
  // 0.714466, 0.345614, 1.402194, 1.771046
  return ycbcr::Decode(ycbcr_full, NTSC_U_1953_TO_XYZ_MAT[1].xyz);
}
float3 YCbCrLimited(float3 ycbcr_limited) {
  // 1.596247, 2.016146, 0.813343, 0.393445
  return YCbCr(ycbcr::from::Limited(ycbcr_limited));
}
}  // namespace from
}  // namespace bt601

namespace bt709 {
namespace from {
float3 YCbCr(float3 ycbcr_full) {
  // 0.468208, 0.187314, 1.574722, 1.855615
  return ycbcr::Decode(ycbcr_full, BT709_TO_XYZ_MAT[1].xyz);
}
float3 YCbCrLimited(float3 ycbcr_limited) {
  // 1.792652, 2.112419, 0.533004, 0.213237
  return YCbCr(ycbcr::from::Limited(ycbcr_limited));
}
}  // namespace from
}  // namespace bt709

}  // namespace color
}  // namespace renodx
#endif  // RENODX_SHADERS_COLOR_YCBCR_HLSL