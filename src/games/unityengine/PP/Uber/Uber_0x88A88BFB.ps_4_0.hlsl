#include "../../common.hlsli"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[37];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz * CUSTOM_CHROMATIC_ABERRATION;
  r1.xy = cb0[31].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r1.y = cmp(0 < cb0[28].w);
  r2.yw = float2(0,0);
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.zw = v1.xy;
  r6.x = 0;
  while (true) {
    r6.y = cmp((int)r6.x >= (int)r0.w);
    if (r6.y != 0) break;
    r6.y = (int)r6.x;
    r6.y = 0.5 + r6.y;
    r2.x = r6.y / r1.x;
    r6.yz = float2(-0.5,-0.5) + r1.zw;
    r7.xy = r6.yz * cb0[28].zz + float2(0.5,0.5);
    r6.yz = r6.yz * cb0[28].zz + -cb0[29].xy;
    r6.yz = cb0[29].zw * r6.yz;
    r6.w = dot(r6.yz, r6.yz);
    r6.w = sqrt(r6.w);
    if (r1.y != 0) {
      r7.zw = cb0[28].xy * r6.ww;
      sincos(r7.z, r8.x, r9.x);
      r7.z = r8.x / r9.x;
      r7.w = 1 / r7.w;
      r7.z = r7.z * r7.w + -1;
      r7.zw = r6.yz * r7.zz + r7.xy;
    } else {
      r8.x = 1 / r6.w;
      r8.x = cb0[28].x * r8.x;
      r6.w = cb0[28].y * r6.w;
      r8.y = min(1, abs(r6.w));
      r8.z = max(1, abs(r6.w));
      r8.z = 1 / r8.z;
      r8.y = r8.y * r8.z;
      r8.z = r8.y * r8.y;
      r8.w = r8.z * 0.0208350997 + -0.0851330012;
      r8.w = r8.z * r8.w + 0.180141002;
      r8.w = r8.z * r8.w + -0.330299497;
      r8.z = r8.z * r8.w + 0.999866009;
      r8.w = r8.y * r8.z;
      r8.w = r8.w * -2 + 1.57079637;
      r8.w = abs(r6.w) > 1 ? r8.w : 0;
      r8.y = r8.y * r8.z + r8.w;
      r6.w = min(1, r6.w);
      r6.w = r6.w < -r6.w ? -r8.y : r8.y;
      r6.w = r8.x * r6.w + -1;
      r7.zw = r6.yz * r6.ww + r7.xy;
    }
    r7.zw = saturate(r7.zw);
    r6.yz = cb0[26].xx * r7.zw;
    r7.xyzw = t1.SampleLevel(s1_s, r6.yz, 0).xyzw;
    r8.xyzw = t3.SampleLevel(s3_s, r2.xy, 0).xyzw;
    r3.xyz = r8.xyz;
    r4.xyzw = r7.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.zw = r1.zw + r0.yz;
    r6.x = (int)r6.x + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r0.xyz = r0.yzw * r0.xxx;
  r1.w = saturate(r1.w);
  r0.yzx = lutShaper(r0.xyz, false, 2);
  if (CUSTOM_LUT_SAMPLE == 0.f) {
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r3.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r2.z = cb0[36].y;
  r0.zw = r1.xz + r2.zw;
  r2.xyzw = t4.Sample(s4_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t4, r0.yzx, cb0[36].z + 1u);
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r2.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r2.w * 2 + -1;
  r1.x = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r1.x = r1.x * 2 + -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r1.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r1.xyz = PostToneMapScale(r1.xyz, true);
  } else {
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  }
  o0.xyzw = r1.xyzw;
  return;
}