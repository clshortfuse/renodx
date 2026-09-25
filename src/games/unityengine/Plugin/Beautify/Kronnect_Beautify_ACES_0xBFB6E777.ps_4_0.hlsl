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
cbuffer cb1 : register(b1){
  float4 cb1[8];
}
cbuffer cb0 : register(b0){
  float4 cb0[24];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(RENODX_TONE_MAP_TYPE == 0.f){
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(8,8,8), r0.xyz);
  }
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
  r3.x = max(r2.w, r2.x);
  r3.x = max(r3.x, r2.y);
  r3.x = max(r3.x, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.x + -r2.x;
  r3.xyzw = v1.xyxy + -r1.xyzw;
  r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.xyzw = v1.xyxy + r1.zwxy;
  r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.x = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r1.x = renodx::color::y::from::NTSC1953(r1.xyz);
  r1.y = renodx::color::y::from::NTSC1953(r5.xyz);
  r1.z = renodx::color::y::from::NTSC1953(r3.xyz);
  r1.w = renodx::color::y::from::NTSC1953(r4.xyz);
  r2.z = max(r1.x, r1.w);
  r2.z = max(r2.z, r1.z);
  r2.z = max(r2.z, r1.y);
  r1.x = min(r1.x, r1.w);
  r1.x = min(r1.x, r1.z);
  r1.x = min(r1.x, r1.y);
  r1.x = -9.99999997e-07 + r1.x;
  r1.y = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.y = r1.y * 2 + -r1.x;
  r1.y = r1.y + -r2.z;
  r1.x = r2.z + -r1.x;
  r1.z = -cb0[9].z + r2.y;
  r1.z = cb0[9].w / abs(r1.z);
  r1.w = r1.z > 1 ? 1.000000 : 0;
  r1.z = saturate(cb0[16].z * r1.z);
  r1.z = max(r1.w, r1.z);
  r1.w = 9.99999975e-06 + r2.x;
  r1.xw = saturate(cb0[8].wy / r1.xw);
  r1.x = r1.y * r1.x;
  r1.x = r1.x * r1.w;
  r1.x = cb0[8].x * r1.x;
  r1.x = max(-cb0[8].z, r1.x);
  r1.x = min(cb0[8].z, r1.x);
  r1.x = r1.x * r1.z + 1;
  r1.yzw = r1.xxx * r0.xyz;
  r3.xyzw = t2.Sample(s4_s, v1.xy).wxyz;
  if (cb0[23].z < cb0[2].z) {
    r4.xyzw = t1.SampleLevel(s1_s, v2.xy, v2.w).xyzw;
    r2.x = cb1[7].z * r4.x + cb1[7].w;
    r2.x = 1 / r2.x;
    r2.z = -cb0[19].x + r2.x;
    r2.w = r2.x < cb0[19].x ? 1.000000 : 0;
    r2.z = -cb0[20].x * r2.w + abs(r2.z);
    r2.z = cb0[19].y * r2.z;
    r2.z = 0.5 * r2.z;
    r2.x = r2.z / r2.x;
    r2.z = cb0[23].z / cb0[2].z;
    r2.w = r3.x + -r2.x;
    r3.x = r2.z * r2.w + r2.x;
  }
  r3.x = saturate(r3.x);
  r0.xyz = -r0.xyz * r1.xxx + r3.yzw;
  r0.xyz = r3.xxx * r0.xyz + r1.yzw;
  r1.xyzw = t3.Sample(s2_s, float2(0.5,0.5)).xyzw;
  r0.xyz = Bt709AcesTonemap(r0.xyz, cb0[7].x);
  /*r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = max(float3(0,0,0), r0.xyz);*/
  //r0.xyz = fastSrgbEncodeSafe(r0.xyz);
  /*r1.x = -1 + cb0[5].w;
  r2.xzw = min(float3(1,1,1), r0.xyz);
  r1.z = r2.w * r1.x;
  r2.xz = r2.xz * r1.xx + float2(0.5,0.5);
  r3.zw = cb0[5].xy * r2.xz;
  r1.z = floor(r1.z);
  r3.y = r1.z * cb0[5].y + r3.z;
  r3.x = cb0[5].y + r3.y;
  r4.xyzw = t4.Sample(s3_s, r3.yw).xyzw;
  r3.xyzw = t4.Sample(s3_s, r3.xw).xyzw;
  r1.x = r2.w * r1.x + -r1.z;
  r2.xzw = r3.xyz + -r4.xyz;
  r1.xzw = r1.xxx * r2.xzw + r4.xyz;*/
  r1.xzw = handleUserLUT(r0.xyz, t4, s3_s, 0, 1);
  r0.xyz = fastSrgbEncodeSafe(r0.xyz);
  r1.xzw = r1.xzw + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xzw + r0.xyz;
  r2.xzw = fastSrgbDecodeSafe(r0.xyz);
  float compression_scale = 1.f;
  GamutCompression(r2.xzw, compression_scale);
  r3.x = max(r2.z, r2.w);
  r3.x = max(r3.x, r2.x);
  r3.y = min(r2.z, r2.w);
  r3.y = min(r3.y, r2.x);
  r3.x = saturate(r3.x + -r3.y);
  r3.x = 1 + -r3.x;
  r3.x = cb0[7].z * r3.x;
  r3.y = renodx::color::y::from::NTSC1953(r2.xzw);
  r0.xyz = r0.xyz * r1.xzw + -r3.yyy;
  r0.xyz = r3.xxx * r0.xyz + float3(1,1,1);
  r0.xyz = r2.xzw * r0.xyz;
  r1.xzw = r0.xyz * cb0[11].xyz + -r0.xyz;
  r0.xyz = cb0[11].www * r1.xzw + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[7].yyy + float3(0.5,0.5,0.5);
  r3.y = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xz = cb0[22].xx * float2(1.14,2.99) + float2(1,1);
  r3.x = r3.y / r1.x;
  r3.z = r3.y * r1.z;
  r1.xzw = r3.xyz;
  if(RENODX_TONE_MAP_TYPE == 0.f){
    r1.xzw = saturate(r1.xzw);
  }
  float max_channel_scale = 1.f;
  NeutwoMaxCh(r1.xzw, max_channel_scale);
  r1.y = 1.44269502 * r1.y;
  r1.y = exp2(r1.y);
  r1.y = saturate(-cb0[22].y + r1.y);
  r0.xyz = -r1.xzw + r0.xyz;
  r0.xyz = r1.yyy * r0.xyz + r1.xzw;
  r1.xy = -cb0[16].xy + w1.xy;
  r1.z = cb0[18].x * r1.y;
  r1.x = dot(r1.xz, r1.xz);
  r1.x = saturate(cb0[17].w * r1.x + cb0[22].z);
  r1.yzw = r3.yyy * cb0[17].xyz + -r0.xyz;
  r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = step(cb0[9].y, r2.y);
  r1.w = cb0[9].x * r1.w;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = r0.w;
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