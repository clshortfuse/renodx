#include "./shared.h"

cbuffer _Globals : register(b4) {
  row_major float4x4 YUVtoRGB : packoffset(c100);
  float GrayScaleValue : packoffset(c104);
  float2 BrightnessSetting : packoffset(c105);
}

SamplerState YPlaneSampler_s : register(s4);
SamplerState cRPlaneSampler_s : register(s5);
SamplerState cBPlaneSampler_s : register(s6);
Texture2D<float4> YPlaneSampler : register(t4);
Texture2D<float4> cRPlaneSampler : register(t5);
Texture2D<float4> cBPlaneSampler : register(t6);

void main(
    float4 v0: SV_Position0,
    float4 v1: COLOR0,
    float2 v2: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1;

  r0.x = YPlaneSampler.Sample(YPlaneSampler_s, v2.xy).x;
  r0.y = cRPlaneSampler.Sample(cRPlaneSampler_s, v2.xy).x;
  r0.z = cBPlaneSampler.Sample(cBPlaneSampler_s, v2.xy).x;
  r0.w = YUVtoRGB._m30;
  r1.x = dot(YUVtoRGB._m00_m01_m02_m03, r0.xyzw);
  r1.y = dot(YUVtoRGB._m10_m11_m12_m13, r0.xyzw);
  r1.z = dot(YUVtoRGB._m20_m21_m22_m23, r0.xyzw);
  r0.xyz = -r1.xyz + r0.xxx;
  r0.xyz = GrayScaleValue * r0.xyz + r1.xyz;
  r0.xyz = v1.xyz * r0.xyz;
  r0.w = YUVtoRGB._m33 * v1.w;
  o0.xyzw = r0.xyzw * BrightnessSetting.xxxx + BrightnessSetting.yyyy;

  o0.rgb = max(0, o0.rgb);

  return;
}
