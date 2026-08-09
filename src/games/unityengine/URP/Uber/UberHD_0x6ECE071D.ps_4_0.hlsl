#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
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
  r0.zw = r0.xy * cb0[137].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[137].zz + -cb0[136].xy;
  r0.xy = cb0[136].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[137].w > 0) {
    r1.yz = cb0[137].xy * r1.xx;
    sincos(r1.y, r2.x, r3.x);
    r1.y = r2.x / r3.x;
    r1.z = 1 / r1.z;
    r1.y = r1.y * r1.z + -1;
    r1.yz = r0.xy * r1.yy + r0.zw;
  } else {
    r1.w = 1 / r1.x;
    r1.w = cb0[137].x * r1.w;
    r1.x = cb0[137].y * r1.x;
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
  r0.xyzw = t0.SampleBias(s0_s, r1.yz, cb0[21].x).xyzw;
  r2.xyzw = t1.SampleBias(s0_s, r1.yz, cb0[21].x).xyzw;
  if (cb0[133].x > 0) {
    r3.xyz = r2.xyz * r2.www;
    r2.xyz = float3(8,8,8) * r3.xyz;
  }
  r2.xyz = cb0[132].xxx * r2.xyz * injectedData.fxBloom;
  r0.xyz = r2.xyz * cb0[132].yzw + r0.xyz;
  if (cb0[140].z > 0) {
    r1.xy = -cb0[140].xy + r1.yz;
    r1.yz = cb0[140].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[139].w * r1.y;
    r1.x = dot(r1.xz, r1.xz);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[140].w * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[139].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[139].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[130].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xyz = cb0[130].zzz * r0.xyz;
  r0.y = floor(r1.x);
  r1.xw = float2(0.5,0.5) * cb0[130].xy;
  r1.yz = r1.yz * cb0[130].xy + r1.xw;
  r1.x = r0.y * cb0[130].y + r1.y;
  r2.xyzw = t3.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[130].y;
  r3.y = 0;
  r1.xy = r3.xy + r1.xz;
  r1.xyzw = t3.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r0.x = r0.x * cb0[130].z + -r0.y;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r1.xyz + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t3, r0.yzx, cb0[130].z + 1u);
  }
  if (cb0[131].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t4, s0_s, cb0[131].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[131].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = v1.xy * cb0[142].xy + cb0[142].zw;
  r1.xyzw = t2.SampleBias(s1_s, r1.xy, cb0[21].x).xyzw;
  r1.x = -0.5 + r1.w;
  r1.x = r1.x + r1.x;
  r1.y = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.y = sqrt(r1.y);
  r1.y = cb0[141].y * -r1.y + 1;
  r1.xzw = r1.xxx * r0.xyz;
  r1.xzw = cb0[141].xxx * r1.xzw * injectedData.fxFilmGrain;
  r0.xyz = r1.xzw * r1.yyy + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  r1.x = r0.x + r0.y;
  r1.x = r1.x + r0.z;
  r1.x = 0.333333343 * r1.x;
  o0.w = max(r1.x, r0.w);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}