#include "./common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[139];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r0.w = cmp(0 < cb0[131].x);
  if (r0.w != 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8, 8, 8) * r2.xyz;
  }
  r1.xyz = cb0[130].xxx * r1.xyz * injectedData.fxBlooom;
  r0.xyz = r1.xyz * cb0[130].yzw + r0.xyz;
  r0.w = cmp(0 < cb0[138].z);
  if (r0.w != 0) {
    r1.xy = -cb0[138].xy + v1.xy;
    r1.yz = cb0[138].zz * abs(r1.xy);
    r1.x = cb0[137].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[138].w * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[137].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[137].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  float3 preLUT = cb0[128].www * r0.rgb;
  r0.rgb = saturate(preLUT);
  r0.w = cmp(0 < cb0[129].w);
  if (r0.w != 0) {
    r1.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r0.xyz;
    r2.xyz = log2(r0.xyz);
    r2.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r3.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r0.xyz);
    r1.xyz = r3.xyz ? r1.xyz : r2.xyz;
    r2.xyz = cb0[129].zzz * r1.zxy;
    r0.w = floor(r2.x);
    r2.xw = float2(0.5, 0.5) * cb0[129].xy;
    r2.yz = r2.yz * cb0[129].xy + r2.xw;
    r2.x = r0.w * cb0[129].y + r2.y;
    r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[129].y;
    r4.y = 0;
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t3.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.w = r1.z * cb0[129].z + -r0.w;
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.www * r2.xyz + r3.xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[129].www * r2.xyz + r1.xyz;
    r2.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r1.xyz;
    r3.xyz = float3(0.0549999997, 0.0549999997, 0.0549999997) + r1.xyz;
    r3.xyz = float3(0.947867334, 0.947867334, 0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r1.xyz);
    r0.xyz = r1.xyz ? r2.xyz : r3.xyz;
  }
  r0.xyw = cb0[128].zzz * r0.xyz;
  r0.w = floor(r0.w);
  r1.xy = float2(0.5, 0.5) * cb0[128].xy;
  r1.yz = r0.xy * cb0[128].xy + r1.xy;
  r1.x = r0.w * cb0[128].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r0.x = cb0[128].y;
  r0.y = 0;
  r0.xy = r1.xz + r0.xy;
  r1.xyzw = t2.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[128].z + -r0.w;
  r0.yzw = r1.xyz + -r2.xyz;
  o0.xyz = r0.xxx * r0.yzw + r2.xyz;
  o0.w = 1;
  if (injectedData.toneMapType == 0.f) {
    o0.rgb = lerp(preLUT, o0.rgb, injectedData.colorGradeLUTStrength);
  } else if (injectedData.toneMapType == 1.f) {
    o0.rgb = preLUT;
  } else {
    o0.rgb = sampleLUT(preLUT, t2, s0_s, cb0[128].rgb, injectedData.upgradePerChannel != 0.f);
  }
  if (injectedData.fxBlooom > 0.f) {
    o0.rgb = PostToneMapScale(o0.rgb);
  }
  return;
}
