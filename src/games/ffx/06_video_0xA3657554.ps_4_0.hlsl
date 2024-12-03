#include "./common.hlsl"
#include "./shared.h"

SamplerState YChannelState_s : register(s0);
SamplerState UChannelState_s : register(s1);
SamplerState VChannelState_s : register(s2);
Texture2D<float4> YChannel : register(t0);
Texture2D<float4> UChannel : register(t1);
Texture2D<float4> VChannel : register(t2);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;
  r0.xy = v1.xy * float2(1, -1) + float2(0, 1);
  r1.xyzw = VChannel.Sample(VChannelState_s, r0.xy).yzxw;
  r2.xyzw = UChannel.Sample(UChannelState_s, r0.xy).xyzw;
  r0.xyzw = YChannel.Sample(YChannelState_s, r0.xy).xyzw;
  r1.x = r0.x;
  r1.y = r2.x;
  r1.w = 1;
  o0.y = saturate(dot(float4(1, -0.344000012, -0.713999987, 0.528999984), r1.xyzw));
  o0.x = saturate(dot(float3(1, 1.40199995, -0.700999975), r1.xzw));
  o0.z = saturate(dot(float3(1, 1.77199996, -0.885999978), r1.xyw));

  if (injectedData.toneMapType == 0.f) return;
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);

  float videoPeak = injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);
  o0.rgb = renodx::tonemap::inverse::bt2446a::BT709(o0.rgb, 100.f, videoPeak);
  o0.rgb /= videoPeak;  // Normalize to 1.0f = peak;

  // o0.rgb = 1.f;

  o0.rgb *= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;

  o0.rgb = PostToneMapScale(o0.rgb);

  return;
}
