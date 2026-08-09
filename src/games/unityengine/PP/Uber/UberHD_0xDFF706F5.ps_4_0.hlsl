#include "../../common.hlsl"

Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[43];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz * injectedData.fxCA;
  r1.xy = cb0[31].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r1.y = cmp(0 < cb0[28].w);
  r2.y = 0;
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.zw = v1.xy;
  r2.z = 0;
  while (true) {
    r2.w = cmp((int)r2.z >= (int)r0.w);
    if (r2.w != 0) break;
    r2.w = (int)r2.z;
    r2.w = 0.5 + r2.w;
    r2.x = r2.w / r1.x;
    r6.xy = float2(-0.5,-0.5) + r1.zw;
    r6.zw = r6.xy * cb0[28].zz + float2(0.5,0.5);
    r6.xy = r6.xy * cb0[28].zz + -cb0[29].xy;
    r6.xy = cb0[29].zw * r6.xy;
    r2.w = dot(r6.xy, r6.xy);
    r2.w = sqrt(r2.w);
    if (r1.y != 0) {
      r7.xy = cb0[28].xy * r2.ww;
      sincos(r7.x, r7.x, r8.x);
      r7.x = r7.x / r8.x;
      r7.y = 1 / r7.y;
      r7.x = r7.x * r7.y + -1;
      r7.xy = r6.xy * r7.xx + r6.zw;
    } else {
      r7.z = 1 / r2.w;
      r7.z = cb0[28].x * r7.z;
      r2.w = cb0[28].y * r2.w;
      r7.w = min(1, abs(r2.w));
      r8.x = max(1, abs(r2.w));
      r8.x = 1 / r8.x;
      r7.w = r8.x * r7.w;
      r8.x = r7.w * r7.w;
      r8.y = r8.x * 0.0208350997 + -0.0851330012;
      r8.y = r8.x * r8.y + 0.180141002;
      r8.y = r8.x * r8.y + -0.330299497;
      r8.x = r8.x * r8.y + 0.999866009;
      r8.y = r8.x * r7.w;
      r8.y = r8.y * -2 + 1.57079637;
      r8.y = abs(r2.w) > 1 ? r8.y : 0;
      r7.w = r7.w * r8.x + r8.y;
      r2.w = min(1, r2.w);
      r2.w = (r2.w < -r2.w) ? -r7.w : r7.w;
      r2.w = r7.z * r2.w + -1;
      r7.xy = r6.xy * r2.ww + r6.zw;
    }
    r7.xy = saturate(r7.xy);
    r6.xy = cb0[26].xx * r7.xy;
    r6.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).xyzw;
    r7.xyzw = t2.SampleLevel(s2_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.zw = r1.zw + r0.yz;
    r2.z = (int)r2.z + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = cb0[36].zzzz * r1.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t3.Sample(s3_s, r0.xyz).wxyz;
  } else {
    r1.yzw = renodx::lut::SampleTetrahedral(t3, r0.xyz, 1 / cb0[36].x);
  }
  if (cb0[42].x > 0.5) {
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