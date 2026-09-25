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
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

float3 vanillaNarkACES(float3 color) {
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  float3 exposed_color = cb0[6].xxx * color;
  return (exposed_color * (a * exposed_color + b)) / (exposed_color * (c * exposed_color + d) + e);
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xw = float2(0,0);
  r1.yz = cb0[2].yx;
  r2.xyz = v2.xyw + -r1.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r2.x = 1 + -r2.x;
  r2.yzw = v2.xyw + -r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r2.yz, r2.w).xyzw;
  r2.y = 1 + -r3.x;
  r3.xyz = v2.xyw + r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.z = 1 + -r3.x;
  r3.xyz = v2.xyw + r1.xyx;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.w = 1 + -r3.x;
  r3.x = max(r2.w, r2.x);
  r3.x = max(r3.x, r2.y);
  r3.x = max(r3.x, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.x + -r2.x;
  r2.x = 9.99999975e-06 + r2.x;
  if (r2.x > cb0[20].y) {
    r3.xyzw = v1.xyxy + -r1.xyzw;
    r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
    r1.xyzw = v1.xyxy + r1.zwxy;
    r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
    r1.x = renodx::color::y::from::NTSC1953(r1.xyz);
    r1.y = renodx::color::y::from::NTSC1953(r5.xyz);
    r1.z = renodx::color::y::from::NTSC1953(r3.xyz);
    r1.w = renodx::color::y::from::NTSC1953(r4.xyz);
    r2.x = max(r1.x, r1.w);
    r2.x = max(r2.x, r1.z);
    r2.x = max(r2.x, r1.y);
    r2.z = min(r1.x, r1.w);
    r2.z = min(r2.z, r1.z);
    r2.z = min(r2.z, r1.y);
    r2.z = -9.99999997e-07 + r2.z;
    r3.xyzw = r1.wzwz + -r1.xyxy;
    r1.xyzw = cb0[20].xxxx * cb0[2].xyxy;
    r1.xyzw = r3.xyzw * r1.xyzw;
    r3.xyzw = r1.zwzw * float4(-0.166666672,-0.166666672,0.166666672,0.166666672) + v1.xyxy;
    r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
    r3.xyz = r4.xyz + r3.xyz;
    r4.xyz = float3(0.5,0.5,0.5) * r3.xyz;
    r1.xyzw = r1.xyzw * float4(-0.5,-0.5,0.5,0.5) + v1.xyxy;
    r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
    r1.xyz = r5.xyz + r1.xyz;
    r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
    r1.xyz = r3.xyz * float3(0.25,0.25,0.25) + r1.xyz;
    r1.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
    r0.xyz = (r1.w < r2.z) || (r1.w > r2.x) ? r4.xyz : r1.xyz;
  }
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[13].xxx * CUSTOM_BLOOM + r0.xyz;
  r0.xyz = Bt709AcesTonemap(r0.xyz, cb0[6].x);
  r1.xyz = handleUserLUT(r0.xyz, t2, s2_s, cb0[4].w, 1);
  r0.xyz = fastSrgbEncodeSafe(r0.xyz);
  r0.xyz = lerp(r0.xyz, r1.xyz, cb0[9].w);
  r2.xzw = fastSrgbDecodeSafe(r0.xyz);
  float compression_scale = 1.f;
  GamutCompression(r2.xzw, compression_scale);
  // vibrance
  r1.w = max(r2.z, r2.w);
  r1.w = max(r2.x, r1.w);
  r3.x = min(r2.z, r2.w);
  r3.x = min(r3.x, r2.x);
  r1.w = saturate(-r3.x + r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb0[6].z * r1.w;
  r3.x = renodx::color::y::from::NTSC1953(r2.xzw);
  r0.xyz = r2.xzw + -r3.xxx;
  r0.xyz = r1.www * r0.xyz + float3(1,1,1);
  r0.xyz = r2.xzw * r0.xyz;
  // tint
  r1.xyz = r0.xyz * cb0[10].xyz + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r0.xyz;
  // contrast
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[6].yyy + float3(0.5,0.5,0.5);
  // dither
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = step(cb0[8].y, r2.y);
  r1.w = cb0[8].x * r1.w * CUSTOM_NOISE;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  GamutDecompression(r0.xyz, compression_scale);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = saturate(r0.w);
  return;
}