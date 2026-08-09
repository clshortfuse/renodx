#include "../../common.hlsl"

Texture2D<float4> t6 : register(t6);
Texture3D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
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
  r2.y = 0;
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.yz = v1.xy;
  r1.w = 0;
  while (true) {
    r2.z = cmp((int)r1.w >= (int)r0.w);
    if (r2.z != 0) break;
    r2.z = (int)r1.w;
    r2.z = 0.5 + r2.z;
    r2.x = r2.z / r1.x;
    r2.zw = saturate(r1.yz);
    r2.zw = cb0[26].xx * r2.zw;
    r6.xyzw = t0.SampleLevel(s0_s, r2.zw, 0).xyzw;
    r7.xyzw = t4.SampleLevel(s4_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.yz = r1.yz + r0.yz;
    r1.w = (int)r1.w + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r2.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  r3.xyzw = saturate(-r2.xywy * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r0.yzw = r3.xyz * float3(2,2,2) + r4.xyz;
  r3.xy = saturate(-r2.zy * cb0[34].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r0.yzw = r3.xyz + r0.yzw;
  r3.xyzw = saturate(r2.zwxw * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r0.yzw = r4.xyz * float3(2,2,2) + r0.yzw;
  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r0.yzw = r4.xyz * float3(4,4,4) + r0.yzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r0.yzw = r3.xyz * float3(2,2,2) + r0.yzw;
  r3.xyzw = saturate(r2.zywy * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r0.yzw = r4.xyz + r0.yzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r0.yzw = r3.xyz * float3(2,2,2) + r0.yzw;
  r2.xy = saturate(r2.xy * cb0[34].xx + v1.xy);
  r2.xy = cb0[26].xx * r2.xy;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r0.yzw = r2.xyz + r0.yzw;
  r0.yzw = cb0[34].yyy * r0.yzw * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r0.yzw = float3(0.0625,0.0625,0.0625) * r0.yzw;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLens;
  r3.xyz = cb0[35].xyz * r0.yzw;
  r1.xyz = r1.xyz * r0.xxx + r3.xyz;
  r0.xyz = r2.xyz * r0.yzw + r1.xyz;
  if (cb0[40].y < 0.5) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1.f, injectedData.fxVignette);
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
    r0.w = cb0[39].y * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r2.x = -1 + r1.w;
    r0.w = r0.w * r2.x + 1;
  } else {
    r2.xyzw = t6.Sample(s6_s, v1.xy).xyzw;
    r2.x = renodx::color::srgb::DecodeSafe(r2.w);
    r2.yzw = float3(1,1,1) + -cb0[37].xyz;
    r2.yzw = r2.xxx * r2.yzw + cb0[37].xyz;
    r2.yzw = r0.xyz * r2.yzw + -r0.xyz;
    r1.xyz = cb0[40].xxx * r2.yzw + r0.xyz;
    r0.x = -1 + r1.w;
    r0.w = r2.x * r0.x + 1;
  }
  r0.xyz = cb0[36].zzz * r1.xyz;
  r0.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t5.Sample(s5_s, r0.xyz).wxyz;
  } else {
    r1.yzw = renodx::lut::SampleTetrahedral(t5, r0.xyz, 1 / cb0[36].x);
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