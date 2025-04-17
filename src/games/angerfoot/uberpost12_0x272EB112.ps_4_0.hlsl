#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[41];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = cmp(cb0[40].y < 0.5);
  if (r0.w != 0) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r1.x = r1.z * r0.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r0.w = dot(r1.xy, r1.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w;
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r2.xyz = r1.xyz * r0.xyz;
    r1.x = -1 + r1.w;
    r2.w = r0.w * r1.x + 1;
  } else {
    r3.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
    r0.w = 0.0773993805 * r3.w;
    r1.x = 0.0549999997 + r3.w;
    r1.x = 0.947867334 * r1.x;
    r1.x = max(1.1920929e-07, abs(r1.x));
    r1.x = log2(r1.x);
    r1.x = 2.4000001 * r1.x;
    r1.x = exp2(r1.x);
    r1.y = cmp(0.0404499993 >= r3.w);
    r0.w = r1.y ? r0.w : r1.x;
    r1.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.xyz + r0.xyz;
    r0.x = -1 + r1.w;
    r2.w = r0.w * r0.x + 1;
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;
  r0.xyz = lutShaper(r0.rgb);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t3.Sample(s3_s, r0.xyz).xyzw;
  } else {
    r1.rgb = renodx::lut::SampleTetrahedral(t3, r0.rgb, 1 / cb0[36].x);
  }
  o0.w = r0.w;
  if (injectedData.fxFilmGrain > 0.f) {
    r1.rgb = applyFilmGrain(r1.rgb, w1, injectedData.fxFilmGrainType != 0.f);
  }
  if (injectedData.fxNoise > 0.f) {
    r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
    r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
    r0.x = r2.w * 2 + -1;
    r0.y = saturate(r0.x * 3.40282347e+38 + 0.5);
    r0.y = r0.y * 2 + -1;
    r0.x = 1 + -abs(r0.x);
    r0.x = sqrt(r0.x);
    r0.x = 1 + -r0.x;
    r0.x = r0.y * r0.x;
    r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
    r0.xyz = r0.xxx * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r1.xyz;
    r1.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  }
  o0.rgb = r1.rgb;
  return;
}
