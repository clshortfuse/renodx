#include "../../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[23];
}

// Party Animals

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xw = float2(0,0);
  r1.yz = cb0[2].yx;
  r2.xyz = v2.xyw + -r1.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r2.x = cb1[7].x * r2.x + cb1[7].y;
  r2.x = 1 / r2.x;
  r2.yzw = v2.xyw + -r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r2.yz, r2.w).xyzw;
  r2.y = cb1[7].x * r3.x + cb1[7].y;
  r2.y = 1 / r2.y;
  r3.xyz = v2.xyw + r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.z = cb1[7].x * r3.x + cb1[7].y;
  r2.z = 1 / r2.z;
  r3.xyz = v2.xyw + r1.xyx;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.w = cb1[7].x * r3.x + cb1[7].y;
  r2.w = 1 / r2.w;
  r3.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r3.y = max(r2.w, r2.x);
  r3.y = max(r3.y, r2.y);
  r3.y = max(r3.y, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.y + -r2.x;
  r2.x = 9.99999975e-06 + r2.x;
  r4.xyzw = v1.xyxy + -r1.xyzw;
  r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r1.xyzw = v1.xyxy + r1.zwxy;
  r6.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.x = renodx::color::y::from::NTSC1953(r1.xyz);
  r1.y = renodx::color::y::from::NTSC1953(r6.xyz);
  r1.z = renodx::color::y::from::NTSC1953(r4.xyz);
  r1.w = renodx::color::y::from::NTSC1953(r5.xyz);
  r2.z = max(r1.x, r1.w);
  r2.z = max(r2.z, r1.z);
  r2.z = max(r2.z, r1.y);
  r1.x = min(r1.x, r1.w);
  r1.x = min(r1.x, r1.z);
  r1.x = min(r1.x, r1.y);
  r1.x = -9.99999997e-07 + r1.x;
  r1.y = r3.x * 2 + -r1.x;
  r1.y = r1.y + -r2.z;
  r1.x = r2.z + -r1.x;
  r1.x = saturate(cb0[7].w / r1.x);
  r1.z = -cb0[8].z + r2.y;
  r1.z = cb0[8].w / abs(r1.z);
  r1.w = r1.z > 1 ? 1.000000 : 0;
  r1.z = saturate(cb0[15].z * r1.z);
  r1.z = max(r1.w, r1.z);
  r1.w = saturate(cb0[7].y / r2.x);
  r1.x = r1.y * r1.x;
  r1.x = r1.x * r1.w;
  r1.x = cb0[7].x * r1.x;
  r1.x = max(-cb0[7].z, r1.x);
  r1.x = min(cb0[7].z, r1.x);
  r1.x = r1.x * r1.z + 1;
  r1.yzw = r1.xxx * r0.xyz;
  r4.xyzw = t2.Sample(s3_s, v1.xy).wxyz;
  if (cb0[22].z < cb0[2].z) {
    r5.xyzw = t1.SampleLevel(s1_s, v2.xy, v2.w).xyzw;
    r2.x = cb1[7].z * r5.x + cb1[7].w;
    r2.x = 1 / r2.x;
    r2.z = -cb0[18].x + r2.x;
    r2.w = r2.x < cb0[18].x ? 1.000000 : 0;
    r2.z = -cb0[19].x * r2.w + abs(r2.z);
    r2.z = cb0[18].y * r2.z;
    r2.z = 0.5 * r2.z;
    r2.x = r2.z / r2.x;
    r2.z = cb0[22].z / cb0[2].z;
    r2.w = r4.x + -r2.x;
    r4.x = r2.z * r2.w + r2.x;
  }
  r4.x = saturate(r4.x);
  r0.xyz = -r0.xyz * r1.xxx + r4.yzw;
  r0.xyz = r4.xxx * r0.xyz + r1.yzw;
  r1.xyzw = t3.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[13].xxx * CUSTOM_BLOOM + r0.xyz;
  r0.xyz = Bt709AcesTonemap(r0.xyz, cb0[6].x);
  float compression_scale = 1.f;
  GamutCompression(r0.xyz, compression_scale);
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.y = min(r0.y, r0.z);
  r1.y = min(r1.y, r0.x);
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[6].z * r1.x;
  r1.y = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.yzw = -r1.yyy + r0.xyz;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[10].xyz + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[6].yyy + float3(0.5,0.5,0.5);
  r1.xy = -cb0[15].xy + w1.xy;
  r1.z = cb0[17].x * r1.y;
  r1.x = dot(r1.xz, r1.xz);
  r1.x = saturate(cb0[16].w * r1.x + cb0[21].z);
  r1.yzw = r3.xxx * cb0[16].xyz + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = step(cb0[8].y, r2.y);
  r1.w = cb0[8].x * r1.w;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = r0.w;
  GamutDecompression(o0.xyz, compression_scale);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}