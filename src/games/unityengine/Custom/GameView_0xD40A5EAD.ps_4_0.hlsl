#include "../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[33];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD2,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy * v3.zz;
  r0.xyzw = t0.Sample(s2_s, r0.xy).xyzw;
  r0.xy = float2(255,255) * r0.xy;
  r0.xy = round(r0.xy);
  r0.xy = float2(-128,-128) + r0.xy;
  r0.xy = cb0[27].xx * r0.xy;
  r0.xy = cb0[27].zz * r0.xy;
  r0.xy = v1.ww * r0.xy;
  r0.xy = r0.xy * float2(0.00392156886,0.00392156886) + v2.xy;
  r0.zw = cb0[13].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.xyz = saturate(r1.xyz);
  }
  r1.xyz = cb0[13].zzz * r1.xyz;
  r2.xyz = r1.xyz;
  r0.z = 1;
  while (true) {
    r0.w = cmp((int)r0.z >= 4);
    if (r0.w != 0) break;
    r3.xy = cb0[r0.z+13].xy + r0.xy;
    r3.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      r3.xyz = saturate(r3.xyz);
    }
    r2.xyz = r3.xyz * cb0[r0.z+13].zzz + r2.xyz;
    r0.z = (int)r0.z + 1;
  }
  r0.xyz = cb0[14].www * r2.xyz;
  r1.xyzw = t2.Sample(s3_s, w2.xy).xyzw;
  r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
  r0.xyz = cb0[32].yyy * r1.xyz + r0.xyz;
  r1.xy = v4.xy / v4.ww;
  r1.xy = r1.xy * cb0[21].zw + cb0[22].xy;
  r1.xyzw = t3.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = sign(r0.w);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = cb0[24].x;
  return;
}