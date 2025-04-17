#include "./common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[143];
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
  r0.w = cmp(0 < cb0[131].x);
  if (r0.w != 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8,8,8) * r2.xyz;
  }
  r1.xyz = cb0[130].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[130].yzw + r0.xyz;
  r0.w = cmp(0 < cb0[138].z);
  if (r0.w != 0) {
    r1.xy = -cb0[138].xy + v1.xy;
    r1.yz = cb0[138].zz * abs(r1.xy) * min(1, injectedData.fxVignette);
    r1.x = cb0[137].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[138].w * r0.w * max(1, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[137].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[137].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[128].www * r0.zxy;
  r0.rgb = lutShaper(r0.rgb);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.yzw = cb0[128].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[128].xy;
  r1.yz = r0.zw * cb0[128].xy + r1.xy;
  r1.x = r0.y * cb0[128].y + r1.y;
  r2.xyzw = t3.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[128].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t3.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[128].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.rgb = renodx::lut::SampleTetrahedral(t3, r0.gbr, cb0[128].z + 1u);
  }
  r0.w = cmp(0 < cb0[129].w);
  if (r0.w != 0) {
    r0.xyz = saturate(r0.xyz);
    r1.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
    r2.xyz = log2(r0.xyz);
    r2.xyz = float3(0.416666657,0.416666657,0.416666657) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
    r1.xyz = r3.xyz ? r1.xyz : r2.xyz;
    r2.xyz = cb0[129].zzz * r1.zxy;
    r0.w = floor(r2.x);
    r2.xw = float2(0.5,0.5) * cb0[129].xy;
    r2.yz = r2.yz * cb0[129].xy + r2.xw;
    r2.x = r0.w * cb0[129].y + r2.y;
    r3.xyzw = t4.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[129].y;
    r4.y = 0;
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t4.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r0.w = r1.z * cb0[129].z + -r0.w;
    r2.xyz = r2.xyz + -r3.xyz;
    r2.xyz = r0.www * r2.xyz + r3.xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[129].www * r2.xyz + r1.xyz;
    r2.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r1.xyz;
    r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r1.xyz;
    r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
    r3.xyz = log2(abs(r3.xyz));
    r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r1.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r1.xyz);
    r0.xyz = r1.xyz ? r2.xyz : r3.xyz;
  }

  r1.xy = v1.xy * cb0[140].xy + cb0[140].zw;
  r1.xyzw = t2.SampleBias(s1_s, r1.xy, cb0[19].x).xyzw;
  r0.w = -0.5 + r1.w;
  r0.w = r0.w + r0.w;
  r1.x = renodx::color::y::from::BT709(r0.rgb);
    r1.r = renodx::math::SignSqrt(r1.r);
  r1.x = cb0[139].y * -r1.x + 1;
  r1.yzw = r0.xyz * r0.www;
  r1.yzw = cb0[139].xxx * r1.yzw * injectedData.fxFilmGrain;
    if(injectedData.fxFilmGrainType == 0.f){
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.rgb = applyFilmGrain(r0.rgb, v1);
  }
  r1.xy = v1.xy * cb0[142].xy + cb0[142].zw;
  r1.xyzw = t5.SampleBias(s2_s, r1.xy, cb0[19].x).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = cmp(r0.w >= 0);
  r1.x = r1.x ? 1 : -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
    r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  r0.xyz = r0.www * float3(0.00392156886,0.00392156886,0.00392156886) * injectedData.fxNoise + r0.xyz;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
    o0.rgb = r0.rgb;
    o0.rgb = PostToneMapScale(o0.rgb);
  o0.w = 1;
  return;
}