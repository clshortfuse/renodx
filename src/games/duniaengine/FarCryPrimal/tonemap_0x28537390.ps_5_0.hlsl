#include "../common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t3.SampleLevel(s0_s, v1.xy, 0).x;
  r0.yz = r0.xx * cb0[14].xz + cb0[14].yw;
  r0.x = cmp(r0.x < cb0[20].z);
  r0.x = r0.x ? r0.y : r0.z;
  r0.x = min(1, abs(r0.x));
  r0.x = r0.x * r0.x;
  r0.x = saturate(r0.x * cb0[1].z + -0.5);
  r1.xyzw = t1.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r0.x = max(r1.w, r0.x);
  r0.x = min(1, r0.x);
  r0.yzw = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.xyz = r1.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
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
  r0.rgb = applyUserTonemapFCP(r0.rgb, t4, s1_s);
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
  r1.xy = v1.xy * cb0[7].xy + cb0[7].zw;
  r1.xyzw = t5.Sample(s1_s, r1.xy).xyzw;
  r0.w = saturate(cb0[6].w * r1.w + cb0[5].x);
  r1.xyz = cb0[6].xyz * r1.xyz + float3(-1,-1,-1);
  r1.xyz = r0.www * r1.xyz + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
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
    r0.a = seed * 4.65661287e-10 + -1;
    r0.xyz = r0.www * cb0[19].yyy * injectedData.fxFilmGrain + r0.xyz;
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