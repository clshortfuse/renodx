#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.xy = r0.xy + r0.xy;
  r0.x = -r0.x * r0.x + 1;
  r0.x = cb0[4].z * r0.x;
  r0.y = r0.x * r0.y;
  r0.xw = float2(0,0);
  r1.xy = v1.xy + -r0.xy;
  r1.xyzw = t0.Sample(s2_s, r1.xy).xyzw;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.474000007,0.474000007,0.474000007) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.z = cb0[4].y * r1.z;
  r0.z = 1.01810002 * r1.z;
  r0.zw = v1.xy + r0.zw;
  r0.xy = r0.zw + -r0.xy;
  r0.xy = r0.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  float3 hdrColor = r0.xyz;
  float3 sdrColor = renodx::tonemap::renodrt::NeutralSDR(hdrColor);
  float3 curvesInput = injectedData.toneMapType <= 1.f ? hdrColor : sdrColor;
  r0.xyz = curvesInput;
  r0.xyzw = log2(r0.xyzw);
  r0.xyzw = float4(0.474000007,0.474000007,0.474000007,0.474000007) * r0.xyzw;
  r0.xyzw = exp2(r0.xyzw);
  r0.xyzw = float4(1.01810002,1.01810002,1.01810002,1.01810002) * r0.xzyw;
  float3 preCG = r0.xzy;
  r2.x = r0.y;
  r2.y = 0;
  r2.xyzw = t2.Sample(s3_s, r2.xy).xyzw;
  r1.z = log2(r0.w);
  r1.z = 2.10970473 * r1.z;
  r1.z = exp2(r1.z);
  o0.w = 0.962813556 * r1.z;
  r0.yw = float2(0,0);
  r3.xyzw = t2.Sample(s3_s, r0.xy).xyzw;
  r0.xyzw = t2.Sample(s3_s, r0.zw).xyzw;
  r2.x = r3.x;
  r2.y = r0.y;
  r0.xyz = r2.xyz + -r0.yyy;
  r0.xyz = cb0[4].xxx * r0.xyz + r2.yyy;
  r0.xyz = lerp(preCG, r0.xyz, injectedData.colorGradeUserLUTStrength);
  r0.xyz = r1.yyy * float3(1.01810002,1.01810002,1.01810002) + r0.xyz;
  r0.w = 1.01810002 * r1.x;
  r0.xyz = r0.xyz * r0.www;
  r1.xyzw = t3.Sample(s1_s, v1.xy).xyzw;
  r0.xyz = lerp(1.f, r1.xyz, injectedData.fxVignette) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.10970473,2.10970473,2.10970473) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  o0.xyz = float3(0.962813556,0.962813556,0.962813556) * r0.xyz;
  if (injectedData.toneMapType != 0.f) {
    o0.xyz = RestoreSaturationLoss(curvesInput, o0.xyz);
    o0.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, min(1.f, curvesInput), o0.xyz, 1.f);
  }
  o0.w = saturate(o0.w);
  return;
}