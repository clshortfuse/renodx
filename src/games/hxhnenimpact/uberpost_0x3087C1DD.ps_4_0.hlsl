#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[149];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r1.xyz = -r1.xyz * cb0[128].xxx + float3(1,1,1);
  r1.xyz = -r2.xyz * r1.xyz + float3(1,1,1);
  r1.xyz = cb0[128].yyy * r1.xyz * injectedData.fxBloom;
  r0.xyz = max(r1.xyz, r0.xyz);
  r1.xyzw = t4.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r2.xyz = max(r1.xyz, r0.xyz);
  r0.w = saturate(renodx::color::y::from::BT709(r2.xyz));
  r2.xyz = r1.xyz * r1.xyz;
  r1.xyz = r2.xyz * float3(2,2,2) + r1.xyz;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + -r0.xyz;
  r0.xyz = cb0[144].xxx * r1.xyz * injectedData.fxBlur + r0.xyz;
  r1.x = renodx::color::y::from::BT709(r0.xyz);
  r0.w = r0.w * -0.4 + 0.1;
  r1.xyz = r1.xxx + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xy = v1.xy;
  r1.z = 0;
  r1.xyz = -cb0[144].yzw + r1.xyz;
  r1.xyz = r1.xyz / cb0[145].xyz;
  r1.w = 0.5625 * r1.y;
  r0.w = dot(r1.xzw, r1.xzw);
  r0.w = rsqrt(r0.w);
  r0.w = r1.x * r0.w;
  r0.w = saturate(r1.x / r0.w);
  r0.w = 1 + -r0.w;
  r1.xy = float2(1,1) + -cb0[148].xy;
  r2.xyz = cb0[148].xxx * cb0[147].xyz;
  r1.xzw = r2.xyz * r0.www + r1.xxx;
  r1.xyz = r2.xyz * r1.yyy + r1.xzw;
  r2.xyz = cb0[147].www * cb0[146].xyz;
  r2.xyz = r2.xyz * r0.www;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  if (cb0[139].z > 0) {
    r1.xy = -cb0[139].xy + v1.xy;
    r1.yz = cb0[139].zz * abs(r1.xy);
    r1.x = cb0[138].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[139].w * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[138].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[138].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  } else {
    r0.xyz = applyVignette(r0.xyz, v1, injectedData.fxVignette);
  }
  r0.xyz = cb0[129].www * r0.zxy;
  r0.gbr = lutShaper(r0.gbr);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.yzw = cb0[129].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[129].xy;
  r1.yz = r0.zw * cb0[129].xy + r1.xy;
  r1.x = r0.y * cb0[129].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[129].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[129].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.rgb = renodx::lut::SampleTetrahedral(t2, r0.gbr, cb0[129].z + 1u);
  }
  if (cb0[130].w > 0) {
    r0.xyz = saturate(r0.xyz);
    r1.xyz = log2(r0.xyz);
    r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyz = max(float3(0,0,0), r1.xyz);
    r2.xyz = cb0[130].zzz * r1.zxy;
    r0.w = floor(r2.x);
    r2.xw = float2(0.5,0.5) * cb0[130].xy;
    r2.yz = r2.yz * cb0[130].xy + r2.xw;
    r2.x = r0.w * cb0[130].y + r2.y;
    r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[130].y;
    r4.y = 0;
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t3.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.w = r1.z * cb0[130].z + -r0.w;
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.www * r2.xyz + r3.xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[130].www * r2.xyz + r1.xyz;
    r2.xyz = r1.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
    r2.xyz = r1.xyz * r2.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
    r0.xyz = r2.xyz * r1.xyz;
  }
  if (injectedData.fxFilmGrain > 0.f) {
    r0.xyz = applyFilmGrain(r0.xyz, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.xyz = PostToneMapScale(r0.xyz);
  o0.w = 1;
  return;
}