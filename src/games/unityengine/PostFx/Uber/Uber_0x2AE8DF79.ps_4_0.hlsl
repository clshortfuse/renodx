#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture3D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[44];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[22].xy * v1.xy;
  r0.xy = float2(0.0078125,0.0078125) * r0.xy;
  r0.xyzw = t4.SampleLevel(s4_s, r0.xy, 0).xyzw;
  r0.w = asint(cb0[43].y);
  r0.xyz = r0.www * float3(1.61803401,1.61803401,1.61803401) + r0.xyz;
  r0.xyz = frac(r0.xyz);
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyz = r2.xyz * r1.xxx;
  if (cb0[40].y < 0.5) {
    r2.xy = -cb0[38].xy + v1.xy;
    r2.yz = cb0[39].xx * abs(r2.yx) * min(1.f, injectedData.fxVignette);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r2.x = r2.z * r0.w;
    r2.xy = saturate(r2.xy);
    r2.xy = log2(r2.xy);
    r2.xy = cb0[39].zz * r2.xy;
    r2.xy = exp2(r2.xy);
    r0.w = dot(r2.xy, r2.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.w = r0.x * 2 + -1;
    r0.w = r1.w * 0.0392156877 + r0.w;
    r2.xyz = float3(1,1,1) + -cb0[37].xyz;
    r2.xyz = r0.www * r2.xyz + cb0[37].xyz;
    r2.xyz = r2.xyz * r1.xyz;
    r1.w = -1 + r2.w;
    r3.w = r0.w * r1.w + 1;
  } else {
    r4.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
    r0.w = renodx::color::srgb::DecodeSafe(r4.w);
    r1.w = r0.x * 2 + -1;
    r0.w = r1.w * 0.0392156877 + r0.w;
    r4.xyz = float3(1,1,1) + -cb0[37].xyz;
    r4.xyz = r0.www * r4.xyz + cb0[37].xyz;
    r4.xyz = r1.xyz * r4.xyz + -r1.xyz;
    r2.xyz = cb0[40].xxx * r4.xyz + r1.xyz;
    r1.x = -1 + r2.w;
    r3.w = r0.w * r1.x + 1;
  }
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = cb0[40].www * r0.xyz;
  r0.xyz = cb0[43].zzz * r0.xyz;
  r3.xyz = r0.xyz * float3(0.00392156886,0.00392156886,0.00392156886) + r2.xyz;
  r0.xyzw = cb0[36].zzzz * r3.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t2.Sample(s2_s, r0.xyz).wxyz;
  } else {
    r1.yzw = renodx::lut::SampleTetrahedral(t2, r0.xyz, 1 / cb0[36].x);
  }
  if (cb0[43].x > 0.5) {
    r1.x = renodx::color::y::from::BT709(saturate(r1.yzw));
  } else {
    r1.x = r0.w;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r1.yzw = PostToneMapScale(r1.yzw);
  }
  o0.xyzw = r1.yzwx;
  return;
}