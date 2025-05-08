#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Thu May  8 19:21:04 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[20];
}

/// Correct black levels after applying a black floor offset
float3 CorrectBlack(float3 color_pre_offset, float3 color_post_offset, float offset) {
  if (offset <= 0.f) return color_post_offset;  // don't scale if black floor is not raised

  float3 linearized_pre_offset = renodx::math::SignPow(color_pre_offset, 2.2f);
  float3 linearized_post_offset = renodx::math::SignPow(color_post_offset, 2.2f);
  float linearized_offset = pow(offset, 2.2f);
  float3 corrected_color = renodx::lut::CorrectBlack(linearized_pre_offset, linearized_post_offset, linearized_offset, 0.1f);

  float3 gammified_correct_color = renodx::math::SignPow(corrected_color, 1.f / 2.2f);

  return lerp(color_post_offset, gammified_correct_color, RENODX_COLOR_GRADE_SCALING);
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    float2 v2: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * float2(2, 2) + float2(-1, -1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = min(1, r0.x);
  r0.x = cb0[8].x * r0.x;
  r0.x = r0.x * 7 + 1;
  r1.xyzw = t0.Sample(s2_s, v2.xy).xyzw;
  r0.yz = float2(-0.498039216, -0.498039216) + r1.xy;
  r1.xy = r0.yz * float2(0.100000001, 0.100000001) + v1.xy;
  r0.yz = r0.yz * float2(0.100000001, 0.100000001) + v2.xy;
  r2.xyzw = t2.Sample(s1_s, r0.yz).xyzw;
  r2.xyzw = saturate(-r2.xyzw * cb0[19].xxxx + float4(1, 1, 1, 1));

  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;  // game render

  r0.xyzw = r1.xyzw * r0.xxxx;

  r1.xyz = (cb0[15].xyz * r0.xyz);
  float3 color_hdr, color_sdr;
  if (RENODX_TONE_MAP_TYPE) {
    color_hdr = renodx::math::SignPow(r1.rgb, 2.2f);
    color_sdr = renoDRTSmoothClamp(color_hdr);
    r1.rgb = renodx::math::SignPow((color_sdr), 1.f / 2.2f);
  }

  r1.rgb = saturate(r1.rgb);

  r3.xyz = r1.xyz * r1.xyz;
  r4.xyz = r3.xyz * r1.xyz;
  r5.w = r4.x;
  r6.xyz = float3(1, 1, 1) + -r1.xyz;
  r7.xyz = r6.xyz * r6.xyz;
  r8.xyz = r7.yxz * r6.yxz;
  r3.xyz = r6.xyz * r3.xyz;
  r1.xyz = r7.xzy * r1.xzy;
  r5.x = r8.y;
  r5.y = r1.x;
  r5.z = r3.x;
  r5.x = dot(r5.xyzw, cb0[12].xyzw);
  r1.x = r8.z;
  r8.y = r1.z;
  r8.z = r3.y;
  r1.z = r3.z;
  r8.w = r4.y;
  r1.w = r4.z;
  r5.z = dot(r1.xyzw, cb0[14].xyzw);
  r5.y = dot(r8.xyzw, cb0[13].xyzw);
  r0.xyz = r5.xyz * cb0[9].xxx;

  float3 color_pre_offset = r0.rgb;

  r0.rgb += cb0[9].yyy; // offset

  float3 color_post_offset = r0.rgb;

  r0.rgb = CorrectBlack(color_pre_offset, color_post_offset, cb0[9].y);

  r1.x = saturate(dot(r0.xyz, float3(0.219999999, 0.707000017, 0.0710000023)));
  r1.xyzw = r1.xxxx + -r0.xyzw;
  r0.xyzw = cb0[10].xxxx * r1.xyzw + r0.xyzw;
  r0.xyzw = float4(1, 1, 1, 1) + -r0.xyzw;
  o0.xyzw = -r2.xyzw * r0.xyzw + float4(1, 1, 1, 1);

  o0.rgb = ApplyToneMap(o0.rgb, color_hdr, color_sdr);
  o0.a = saturate(o0.a);

  return;
}
