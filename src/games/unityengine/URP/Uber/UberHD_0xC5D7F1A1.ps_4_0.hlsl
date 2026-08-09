#include "../../common.hlsl"

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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[139].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[139].zz + -cb0[138].xy;
  r0.xy = cb0[138].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[139].w > 0) {
    r1.zw = cb0[139].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[139].x * r2.x;
    r1.x = cb0[139].y * r1.x;
    r2.y = min(1, abs(r1.x));
    r2.z = max(1, abs(r1.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = (abs(r1.x) > 1) ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r1.x = min(1, r1.x);
    r1.x = (r1.x < -r1.x) ? -r2.y : r2.y;
    r1.x = r2.x * r1.x + -1;
    r1.zw = r0.xy * r1.xx + r0.zw;
  }
  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[140].xxxx * r0.xyzw * injectedData.fxCA;
  r2.xyzw = t0.SampleBias(s0_s, r1.zw, cb0[5].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r3.xyzw = r0.xyzw * cb0[139].zzzz + float4(0.5,0.5,0.5,0.5);
  r0.xyzw = r0.xyzw * cb0[139].zzzz + -cb0[138].xyxy;
  r0.xyzw = cb0[138].zwzw * r0.xyzw;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[139].w > 0) {
    r2.yz = cb0[139].xy * r1.xx;
    sincos(r2.y, r4.x, r5.x);
    r2.y = r4.x / r5.x;
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z + -1;
    r2.yz = r0.xy * r2.yy + r3.xy;
  } else {
    r2.w = 1 / r1.x;
    r2.w = cb0[139].x * r2.w;
    r1.x = cb0[139].y * r1.x;
    r4.x = min(1, abs(r1.x));
    r4.y = max(1, abs(r1.x));
    r4.y = 1 / r4.y;
    r4.x = r4.x * r4.y;
    r4.y = r4.x * r4.x;
    r4.z = r4.y * 0.0208350997 + -0.0851330012;
    r4.z = r4.y * r4.z + 0.180141002;
    r4.z = r4.y * r4.z + -0.330299497;
    r4.y = r4.y * r4.z + 0.999866009;
    r4.z = r4.x * r4.y;
    r4.z = r4.z * -2 + 1.57079637;
    r4.z = (abs(r1.x) > 1) ? r4.z : 0;
    r4.x = r4.x * r4.y + r4.z;
    r1.x = min(1, r1.x);
    r1.x = (r1.x < -r1.x) ? -r4.x : r4.x;
    r1.x = r2.w * r1.x + -1;
    r2.yz = r0.xy * r1.xx + r3.xy;
  }
  r4.xyzw = t0.SampleBias(s0_s, r2.yz, cb0[5].x).xyzw;
  r0.x = dot(r0.zw, r0.zw);
  r0.x = sqrt(r0.x);
  if (cb0[139].w > 0) {
    r1.xy = cb0[139].xy * r0.xx;
    sincos(r1.x, r1.x, r3.x);
    r0.y = r1.x / r3.x;
    r1.x = 1 / r1.y;
    r0.y = r0.y * r1.x + -1;
    r1.xy = r0.zw * r0.yy + r3.zw;
  } else {
    r0.y = 1 / r0.x;
    r0.y = cb0[139].x * r0.y;
    r0.x = cb0[139].y * r0.x;
    r2.y = min(1, abs(r0.x));
    r2.z = max(1, abs(r0.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = (abs(r0.x) > 1) ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r0.x = min(1, r0.x);
    r0.x = (r0.x < -r0.x) ? -r2.y : r2.y;
    r0.x = r0.y * r0.x + -1;
    r1.xy = r0.zw * r0.xx + r3.zw;
  }
  r0.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[5].x).xyzw;
  if (cb0[142].z > 0) {
    r1.xy = -cb0[142].xy + r1.zw;
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
    r0.x = r2.x;
    r0.y = r4.y;
    r0.xyz = r0.xyz * r1.xyz;
  } else {
    r0.x = r2.x;
    r0.y = r4.y;
  }
  r0.xyz = cb0[132].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
    if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.yzw = cb0[132].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[132].xy;
  r1.yz = r0.zw * cb0[132].xy + r1.xy;
  r1.x = r0.y * cb0[132].y + r1.y;
  r2.xyzw = t1.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[132].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t1.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[132].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
    } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t1, r0.yzx, cb0[132].z + 1u);
    }
  if (cb0[133].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t2, s0_s, cb0[133].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[133].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}