#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

// Moonlighter 2: The Endless Vault

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[143].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[143].zz + -cb0[142].xy;
  r0.xy = cb0[142].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[143].w > 0) {
    r1.y = cb0[143].x * r1.x;
    sincos(r1.y, r2.x, r3.x);
    r1.y = r2.x / r3.x;
    r1.z = r1.x * cb0[143].y + 6.10351563e-005;
    r1.z = 1 / r1.z;
    r1.y = r1.y * r1.z + -1;
    r1.yz = r0.xy * r1.yy + r0.zw;
  } else {
    r1.w = 1 / r1.x;
    r1.w = cb0[143].x * r1.w;
    r1.x = cb0[143].y * r1.x;
    r2.x = min(1, abs(r1.x));
    r2.y = max(1, abs(r1.x));
    r2.y = 1 / r2.y;
    r2.x = r2.x * r2.y;
    r2.y = r2.x * r2.x;
    r2.z = r2.y * 0.0208350997 + -0.0851330012;
    r2.z = r2.y * r2.z + 0.180141002;
    r2.z = r2.y * r2.z + -0.330299497;
    r2.y = r2.y * r2.z + 0.999866009;
    r2.z = r2.x * r2.y;
    r2.z = r2.z * -2 + 1.57079637;
    r2.z = abs(r1.x) > 1 ? r2.z : 0;
    r2.x = r2.x * r2.y + r2.z;
    r1.x = min(1, r1.x);
    r1.x = r1.x < -r1.x ? -r2.x : r2.x;
    r1.x = r1.w * r1.x + -1;
    r1.yz = r0.xy * r1.xx + r0.zw;
  }
  r0.xy = -cb0[132].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(r1.yz, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xw = -cb0[136].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xw = min(r1.yz, r1.xw);
  r2.xyzw = t1.SampleBias(s0_s, r1.xw, cb0[4].x).xyzw;
  r2.xyz = cb0[139].xxx * r2.xyz * injectedData.fxBloom;
  r0.xyz = r2.xyz * cb0[139].yzw + r0.xyz;
  if (cb0[146].z > 0) {
    r1.xy = -cb0[146].xy + r1.yz;
    r1.yz = cb0[146].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[145].w * r1.y;
    r1.x = dot(r1.xz, r1.xz);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[146].w * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[145].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[145].xyz;
    r1.xyz = r1.xyz * r0.xyz;
  } else {
    r1.xyz = r0.xyz;
  }
  r1.xyz = cb0[137].www * r1.xyz;
  if (cb0[138].w > 0) {
    r2.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r3.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[138].xyz);
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb0[138].www * r3.xyz + r2.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r1.xyw = cb0[137].zzz * r1.xyz;
  r1.w = floor(r1.w);
  r2.xy = float2(0.5,0.5) * cb0[137].xy;
  r2.yz = r1.xy * cb0[137].xy + r2.xy;
  r2.x = r1.w * cb0[137].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[137].y;
  r1.y = 0;
  r1.xy = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.x = r1.z * cb0[137].z + -r1.w;
  r1.yzw = r2.xyz + -r3.xyz;
  r1.xyz = r1.xxx * r1.yzw + r3.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[137].z + 1u);
  }
  r0.w = saturate(r0.w);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}