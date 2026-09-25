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

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xw = float2(0,0);
  r0.yz = cb0[2].yx;
  r1.xyz = v2.xyw + -r0.xyx;
  r1.xyzw = t1.SampleLevel(s1_s, r1.xy, r1.z).xyzw;
  r1.x = cb1[7].x * r1.x + cb1[7].y;
  r1.x = 1 / r1.x;
  r1.yzw = v2.xyw + r0.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r1.yz, r1.w).xyzw;
  r1.y = cb1[7].x * r2.x + cb1[7].y;
  r1.y = 1 / r1.y;
  r1.z = max(r1.y, r1.x);
  r1.x = min(r1.y, r1.x);
  r2.xyz = v2.xyw + -r0.zww;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r1.y = cb1[7].x * r2.x + cb1[7].y;
  r1.y = 1 / r1.y;
  r1.z = max(r1.z, r1.y);
  r2.xyz = v2.xyw + r0.zww;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r1.w = cb1[7].x * r2.x + cb1[7].y;
  r1.w = 1 / r1.w;
  r1.z = max(r1.z, r1.w);
  r1.x = min(r1.x, r1.y);
  r1.x = min(r1.x, r1.w);
  r1.x = r1.z + -r1.x;
  r1.x = 9.99999975e-06 + r1.x;
  r1.x = saturate(cb0[8].y / r1.x);
  r2.xyzw = v1.xyxy + r0.zwxy;
  r0.xyzw = v1.xyxy + -r0.xyzw;
  r3.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r1.z = renodx::color::y::from::NTSC1953(r2.xyz);
  r1.w = renodx::color::y::from::NTSC1953(r3.xyz);
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r0.y = renodx::color::y::from::NTSC1953(r2.xyz);
  r0.z = min(r1.w, r0.y);
  r0.y = max(r1.w, r0.y);
  r0.y = max(r0.y, r0.x);
  r0.x = min(r0.z, r0.x);
  r0.x = min(r0.x, r1.z);
  r0.y = max(r0.y, r1.z);
  r0.x = -9.99999997e-07 + r0.x;
  r0.z = r0.y + -r0.x;
  r0.z = saturate(cb0[8].w / r0.z);
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r2.w;
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.xyz = min(float3(8,8,8), r2.xyz);
  }
  r0.w = renodx::color::y::from::NTSC1953(r2.xyz);
  r0.x = r0.w * 2 + -r0.x;
  r0.x = r0.x + -r0.y;
  r0.x = r0.x * r0.z;
  r0.x = r0.x * r1.x;
  r0.x = cb0[8].x * r0.x;
  r0.x = max(-cb0[8].z, r0.x);
  r0.x = min(cb0[8].z, r0.x);
  r0.y = -cb0[9].z + r1.y;
  r0.z = step(cb0[9].y, r1.y);
  r0.z = cb0[9].x * r0.z;
  r0.y = cb0[9].w / abs(r0.y);
  r0.w = r0.y > 1 ? 1.000000 : 0;
  r0.y = saturate(cb0[16].z * r0.y);
  r0.y = max(r0.w, r0.y);
  r0.x = r0.x * r0.y + 1;
  r0.xyw = r2.xyz * r0.xxx;
  r0.xyw = Bt709AcesTonemap(r0.xyw, cb0[7].x);
  /*r0.xyw = max(float3(0,0,0), r0.xyw);
  r0.xyw = log2(r0.xyw);
  r0.xyw = float3(0.416666657,0.416666657,0.416666657) * r0.xyw;
  r0.xyw = exp2(r0.xyw);
  r0.xyw = r0.xyw * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyw = max(float3(0,0,0), r0.xyw);
  r1.xyz = min(float3(1,1,1), r0.xyw);
  r1.w = -1 + cb0[5].w;
  r2.x = r1.z * r1.w;
  r2.x = floor(r2.x);
  r1.z = r1.z * r1.w + -r2.x;
  r1.xy = r1.xy * r1.ww + float2(0.5,0.5);
  r3.zw = cb0[5].xy * r1.xy;
  r3.y = r2.x * cb0[5].y + r3.z;
  r3.x = cb0[5].y + r3.y;
  r2.xyzw = t3.Sample(s3_s, r3.yw).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.xw).xyzw;
  r1.xyw = r3.xyz + -r2.xyz;
  r1.xyz = r1.zzz * r1.xyw + r2.xyz;*/
  r1.xyz = handleUserLUT(r0.xyw, t3, s3_s, 0, 1);
  r0.xyw = fastSrgbEncodeSafe(r0.xyw);
  r1.xyz = r1.xyz + -r0.xyw;
  r0.xyw = cb0[10].www * r1.xyz + r0.xyw;
  r2.xyz = fastSrgbDecodeSafe(r0.xyw);
  float compression_scale = 1.f;
  GamutCompression(r2.xyz, compression_scale);
  r1.w = max(r2.y, r2.z);
  r1.w = max(r2.x, r1.w);
  r2.w = min(r2.y, r2.z);
  r2.w = min(r2.x, r2.w);
  r1.w = saturate(-r2.w + r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb0[7].z * r1.w;
  r2.w = renodx::color::y::from::NTSC1953(r2.xyz);
  r0.xyw = r0.xyw * r1.xyz + -r2.www;
  r0.xyw = r1.www * r0.xyw + float3(1,1,1);
  r0.xyw = r2.xyz * r0.xyw;
  r1.xyz = r0.xyw * cb0[11].xyz + -r0.xyw;
  r0.xyw = cb0[11].www * r1.xyz + r0.xyw;
  r0.xyw = float3(-0.5,-0.5,-0.5) + r0.xyw;
  r0.xyw = r0.xyw * cb0[7].yyy + float3(0.5,0.5,0.5);
  r1.y = renodx::color::y::from::NTSC1953(r0.xyw);
  r2.xy = cb0[22].xx * float2(1.14,2.99) + float2(1,1);
  r1.x = r1.y / r2.x;
  r1.z = r2.y * r1.y;
  r1.xzw = r1.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r1.xzw = saturate(r1.xzw);
  }
  float max_channel_scale = 1.f;
  NeutwoMaxCh(r1.xzw, max_channel_scale);
  r0.xyw = -r1.xzw + r0.xyw;
  r2.xyzw = t2.Sample(s2_s, float2(0.5,0.5)).xyzw;
  r2.x = 1.44269502 * r2.y;
  r2.x = exp2(r2.x);
  r2.x = saturate(-cb0[22].y + r2.x);
  r0.xyw = r2.xxx * r0.xyw + r1.xzw;
  r1.xyz = r1.yyy * cb0[17].xyz + -r0.xyw;
  r2.xy = -cb0[16].xy + w1.xy;
  r2.z = cb0[18].x * r2.y;
  r1.w = dot(r2.xz, r2.xz);
  r1.w = saturate(cb0[17].w * r1.w + cb0[22].z);
  r0.xyw = r1.www * r1.xyz + r0.xyw;
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = r0.zzz * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyw;
  NeutwoMaxChInverse(o0.xyz, max_channel_scale);
  GamutDecompression(o0.xyz, compression_scale);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}