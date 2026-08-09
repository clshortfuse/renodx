#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[43];
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

  r0.xy = float2(-0.5,-0.5) + w1.xy;
  r0.zw = r0.xy * cb0[28].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[28].zz + -cb0[29].xy;
  r0.xy = cb0[29].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[28].w > 0) {
    r1.yz = cb0[28].xy * r1.xx;
    sincos(r1.y, r2.x, r3.x);
    r1.y = r2.x / r3.x;
    r1.z = 1 / r1.z;
    r1.y = r1.y * r1.z + -1;
    r1.yz = r0.xy * r1.yy + r0.zw;
  } else {
    r1.w = 1 / r1.x;
    r1.w = cb0[28].x * r1.w;
    r1.x = cb0[28].y * r1.x;
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
  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.yz).xyzw;
  r0.xyz = saturate(r1.xyz * r0.xxx);
  r1.w = saturate(r1.w);
  r0.yzx = lutShaper(r0.xyz, false, 2);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r2.xy = float2(0.5,0.5) * cb0[36].xy;
  r2.yz = r0.zw * cb0[36].xy + r2.xy;
  r2.x = r0.y * cb0[36].y + r2.y;
  r3.xyzw = t2.Sample(s2_s, r2.xz).xyzw;
  r4.x = cb0[36].y;
  r4.y = 0;
  r0.zw = r4.xy + r2.xz;
  r2.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[36].z + 1u);
  }
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (cb0[42].x > 0.5) {
    r1.w = renodx::color::y::from::BT709(saturate(r1.xyz));
  }
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyzw = r1.xyzw;
  return;
}