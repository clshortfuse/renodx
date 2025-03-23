#include "../common.hlsl"

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture3D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t8.SampleLevel(s1_s, v1.xy, 0).xyz;
  r0.x = 6.28319979 * r0.x;
  sincos(r0.x, r0.x, r1.x);
  r1.y = r0.x;
  r2.xyzw = r1.xxyy * r0.zzzz + v1.xxyy;
  r0.xz = r1.xy * r0.zz;
  r1.xy = float2(10,10) * r2.xz;
  r1.zw = r2.yw * float2(-10,-10) + float2(10,10);
  r1.xy = saturate(min(r1.xy, r1.zw));
  r1.zw = r0.xz * r1.xy + v1.xy;
  r0.xz = r1.xy * r0.xz;
  r0.w = t8.SampleLevel(s1_s, r1.zw, 0).w;
  r0.xz = r0.xz * r0.ww + v1.xy;
  r1.xyz = t0.SampleLevel(s0_s, r0.xz, 0).xyz;
  r2.xyz = t4.SampleLevel(s1_s, r0.xz, 0).xyz;
  r3.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r0.yyy * r3.xyz + r1.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = -cb0[13].xxx * r2.xyz + r1.xyz;
  r0.yw = r0.xz * cb0[9].xy + cb0[9].zw;
  r2.x = t0.SampleLevel(s1_s, r0.yw, 0).x;
  r3.x = t1.SampleLevel(s1_s, r0.yw, 0).x;
  r0.yw = r0.xz * cb0[10].xy + cb0[10].zw;
  r2.y = t0.SampleLevel(s1_s, r0.yw, 0).y;
  r3.y = t1.SampleLevel(s1_s, r0.yw, 0).y;
  r0.yw = r0.xz * cb0[11].xy + cb0[11].zw;
  r4.xyzw = t1.SampleLevel(s1_s, r0.xz, 0).xyzw;
  r2.z = t0.SampleLevel(s1_s, r0.yw, 0).z;
  r3.z = t1.SampleLevel(s1_s, r0.yw, 0).z;
  r0.xyz = -r4.xyz + r3.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r3.xyz = t6.SampleLevel(s1_s, v1.xy, 0).xyz;
  r3.xyz = cb0[8].xxx * r3.xyz;
  r1.xyz = r3.xyz * r2.xyz + r1.xyz;
  r0.xyz = r3.xyz * r0.xyz + r4.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.w = t3.SampleLevel(s0_s, v1.xy, 0).x;
  r2.xy = r0.ww * cb0[14].xz + cb0[14].yw;
  r0.w = cmp(r0.w < cb0[20].z);
  r0.w = r0.w ? r2.x : r2.y;
  r0.w = min(1, abs(r0.w));
  r0.w = r0.w * r0.w;
  r0.w = saturate(r0.w * cb0[1].z + -0.5);
  r0.w = max(r0.w, r4.w);
  r0.w = min(1, r0.w);
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r1.xyz = t2.SampleLevel(s1_s, v1.xy, 0).xyz;
  r0.xyz = r1.xyz * injectedData.fxBloom + r0.xyz;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb0[19].x * r0.w * injectedData.fxVignette;
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.rgb = applyUserTonemapFCP(r0.rgb, t5, s1_s);
  r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = r1.xyz + r1.xyz;
  r2.xyz = float3(1,1,1) + -cb0[17].xyz;
  r1.xyz = -r1.xyz * r2.xyz + float3(1,1,1);
  r2.xyz = cb0[17].xyz * r0.xyz;
  r0.xyz = cmp(r0.xyz >= float3(0.5,0.5,0.5));
  r0.xyz = r0.xyz ? float3(1,1,1) : 0;
  r1.xyz = -r2.xyz * float3(2,2,2) + r1.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  r0.a = renodx::color::y::from::BT709(r0.rgb);
  r1.xyz = r0.www + -r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = -r0.xyz * r0.www + cb0[3].xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = saturate(r0.w * cb0[4].z + cb0[4].w);
  r2.xy = cb0[4].xy * r0.ww;
  r0.xyz = r2.xxx * r1.xyz + r0.xyz;
  r1.xyz = float3(0.349999994,0.349999994,0.349999994) + -r0.xyz;
  r0.xyz = r2.yyy * r1.xyz + r0.xyz;
  r1.xy = v1.xy * cb0[7].xy + cb0[7].zw;
  r1.xyzw = t7.Sample(s1_s, r1.xy).xyzw;
  r1.xyz = cb0[6].xyz * r1.xyz + -r0.xyz;
  r0.w = saturate(cb0[6].w * r1.w + cb0[5].x);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.w = 1 + -r0.w;
  r0.w = cb0[19].y * r0.w;
  if (injectedData.fxFilmGrainType == 0.f) {
    r1.xy = floor(v0.xy);
    uint seed = (uint)cb0[19].z;
    uint multplier = 0x0019660d;
    seed += (uint(r1.x) * multplier + uint(r1.y));
    seed = (seed >> 16) ^ (seed ^ 61);
    seed *= 9;
    seed = seed ^ (seed >> 4);
    seed *= 0x27d4eb2d;
    seed = seed ^ (seed >> 15);
    r1.x = seed * 4.65661287e-10 + -1;
    r0.xyz = r1.xxx * r0.www * injectedData.fxFilmGrain + r0.xyz;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  } else {
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
    r0.rgb = applyFilmGrain(r0.rgb, v1);
  }
  r0.a = renodx::color::y::from::BT709(r0.rgb);
  r0.rgb = PostToneMapScale(r0.rgb);
  o0.xyzw = r0.xyzw;
  o1.x = r0.w;
  o1.yzw = float3(0,0,0);
  return;
}