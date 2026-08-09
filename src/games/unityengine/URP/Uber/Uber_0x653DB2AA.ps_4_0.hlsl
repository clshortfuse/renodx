#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[143];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[139].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[139].zz + -cb0[138].xy;
  r0.xy = cb0[138].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[139].w > 0) {
    r1.yz = cb0[139].xy * r1.xx;
    sincos(r1.y, r2.x, r3.x);
    r1.y = r2.x / r3.x;
    r1.z = 1 / r1.z;
    r1.y = r1.y * r1.z + -1;
    r1.yz = r0.xy * r1.yy + r0.zw;
  } else {
    r1.w = 1 / r1.x;
    r1.w = cb0[139].x * r1.w;
    r1.x = cb0[139].y * r1.x;
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
    r1.x = (r1.x < -r1.x) ? -r2.x : r2.x;
    r1.x = r1.w * r1.x + -1;
    r1.yz = r0.xy * r1.xx + r0.zw;
  }
  r0.xyzw = t0.SampleBias(s0_s, r1.yz, cb0[5].x).xyzw;
  r2.xyzw = t1.SampleBias(s0_s, r1.yz, cb0[5].x).xyzw;
  if (cb0[135].x > 0) {
    r3.xyz = r2.xyz * r2.www;
    r2.xyz = float3(8,8,8) * r3.xyz;
  }
  r2.xyz = cb0[134].xxx * r2.xyz * injectedData.fxBloom;
  r0.xyz = r2.xyz * cb0[134].yzw + r0.xyz;
  if (cb0[142].z > 0) {
    r1.xy = -cb0[142].xy + r1.yz;
    r1.yz = cb0[142].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[141].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[142].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[141].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[141].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[132].www * r0.xyz;
  if (cb0[133].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[133].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[133].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  r0.xyz = lutShaper(r0.xyz, false, 1);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyw = cb0[132].zzz * r0.xyz;
  r0.w = floor(r0.w);
  r1.xy = float2(0.5,0.5) * cb0[132].xy;
  r1.yz = r0.xy * cb0[132].xy + r1.xy;
  r1.x = r0.w * cb0[132].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r0.x = cb0[132].y;
  r0.y = 0;
  r0.xy = r1.xz + r0.xy;
  r1.xyzw = t2.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[132].z + -r0.w;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.xyz, cb0[132].z + 1u);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}