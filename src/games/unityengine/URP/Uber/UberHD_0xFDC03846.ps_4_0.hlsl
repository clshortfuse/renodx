#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[138];
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
  r0.zw = r0.xy * cb0[132].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[132].zz + -cb0[131].xy;
  r0.xy = cb0[131].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[132].w > 0) {
    r1.yz = cb0[132].xy * r1.xx;
    sincos(r1.y, r2.x, r3.x);
    r1.y = r2.x / r3.x;
    r1.z = 1 / r1.z;
    r1.y = r1.y * r1.z + -1;
    r1.yz = r0.xy * r1.yy + r0.zw;
  } else {
    r1.w = 1 / r1.x;
    r1.w = cb0[132].x * r1.w;
    r1.x = cb0[132].y * r1.x;
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
  r0.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  if (cb0[135].z > 0) {
    r1.xy = -cb0[135].xy + r1.yz;
    r1.yz = cb0[135].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[134].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[135].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[134].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[134].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[125].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[125].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[125].xy;
  r1.yz = r0.zw * cb0[125].xy + r1.xy;
  r1.x = r0.y * cb0[125].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[125].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[125].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[125].z + 1u);
  }
  if (cb0[126].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[126].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[126].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xy = v1.xy * cb0[137].xy + cb0[137].zw;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = -0.5 + r1.w;
  r0.w = r0.w + r0.w;
  r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.x = sqrt(r1.x);
  r1.x = cb0[136].y * -r1.x + 1;
  r1.yzw = r0.xyz * r0.www;
  r1.yzw = cb0[136].xxx * r1.yzw * injectedData.fxFilmGrain;
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}