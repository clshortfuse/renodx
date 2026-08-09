#include "../../common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[44];
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
  r2.yw = float2(0,0);
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.yz = v1.xy;
  r1.w = 0;
  while (true) {
    r6.x = cmp((int)r1.w >= (int)r0.w);
    if (r6.x != 0) break;
    r6.x = (int)r1.w;
    r6.x = 0.5 + r6.x;
    r2.x = r6.x / r1.x;
    r6.xy = saturate(r1.yz);
    r6.xy = cb0[26].xx * r6.xy;
    r6.xyzw = t0.SampleLevel(s0_s, r6.xy, 0).xyzw;
    r7.xyzw = t4.SampleLevel(s4_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.yz = r1.yz + r0.yz;
    r1.w = (int)r1.w + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r1.xyz = r0.yzw * r0.xxx;
  r0.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  r3.xyzw = saturate(-r0.xywy * cb0[34].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = r3.xyzw * float4(2,2,2,2) + r4.xyzw;
  r2.xy = saturate(-r0.zy * cb0[34].xx + v1.xy);
  r2.xy = cb0[26].xx * r2.xy;
  r4.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = saturate(r0.zwxw * cb0[34].xxxx + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(2,2,2,2) + r3.xyzw;
  r2.xy = saturate(v1.xy);
  r2.xy = cb0[26].xx * r2.xy;
  r5.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(4,4,4,4) + r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xyzw = saturate(r0.zywy * cb0[34].xxxx + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw + r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.xy = saturate(r0.xy * cb0[34].xx + v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r3.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r4.xyz = float3(0.0625,0.0625,0.0625) * r0.xyz;
  r3.xyz = cb0[34].zzz * r3.xyz * injectedData.fxLens;
  r0.xyzw = float4(0.0625,0.0625,0.0625,1) * r0.xyzw;
  r5.xyz = cb0[35].xyz * r0.xyz;
  r5.w = 0.0625 * r0.w;
  r0.xyzw = r5.xyzw + r1.xyzw;
  r1.xyz = r3.xyz * r4.xyz;
  r1.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  if (cb0[41].y < 0.5) {
    r1.x = saturate(renodx::color::y::from::NTSC1953(r0.xyz));
    r1.x = -0.3 + r1.x;
    r1.yz = -cb0[39].xy + v1.xy;
    r3.yz = cb0[40].xx * abs(r1.zy) * min(1.f, injectedData.fxVignette);
    r1.y = cb0[22].x / cb0[22].y;
    r1.y = -1 + r1.y;
    r1.y = cb0[40].w * r1.y + 1;
    r3.x = r3.z * r1.y;
    r3.xy = saturate(r3.xy);
    r1.yz = log2(r3.xy);
    r1.yz = cb0[40].zz * r1.yz;
    r1.yz = exp2(r1.yz);
    r1.y = dot(r1.yz, r1.yz);
    r1.y = 1 + -r1.y;
    r1.y = max(0, r1.y);
    r1.y = log2(r1.y);
    r1.y = cb0[40].y * r1.y * max(1.f, injectedData.fxVignette);
    r1.y = exp2(r1.y);
    r3.xyz = float3(1,1,1) + -cb0[38].yzw;
    r3.xyz = r1.yyy * r3.xyz + cb0[38].yzw;
    r4.xyz = float3(1,1,1) + -r3.xyz;
    r1.xzw = r1.xxx * r4.xyz + r3.xyz;
    r1.xzw = r1.xzw * r0.xyz;
    r2.x = -1 + r0.w;
    r3.w = r1.y * r2.x + 1;
  } else {
    r4.xyzw = t7.Sample(s7_s, v1.xy).xyzw;
    r4.xyz = float3(1,1,1) + -cb0[38].yzw;
    r4.xyz = r4.www * r4.xyz + cb0[38].yzw;
    r4.xyz = r0.xyz * r4.xyz + -r0.xyz;
    r1.xzw = cb0[41].xxx * r4.xyz + r0.xyz;
    r0.x = -1 + r0.w;
    r3.w = r4.w * r0.x + 1;
  }
  r0.yzx = lutShaper(r1.xzw);
  if(injectedData.colorGradeLUTSampling == 0.f) {
  r0.yzw = cb0[36].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[36].xy;
  r1.yz = r0.zw * cb0[36].xy + r1.xy;
  r1.x = r0.y * cb0[36].y + r1.y;
  r4.xyzw = t5.Sample(s5_s, r1.xz).xyzw;
  r2.z = cb0[36].y;
  r0.zw = r1.xz + r2.zw;
  r1.xyzw = t5.Sample(s5_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[36].z + -r0.y;
  r0.yzw = r1.xyz + -r4.xyz;
  r0.xyz = r0.xxx * r0.yzw + r4.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t5, r0.yzx, cb0[36].z + 1u);
  }
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r1.xy = cb0[22].xy / cb0[37].yy;
  r1.xy = w1.xy * r1.xy + cb0[37].zw;
  r1.xyzw = t6.Sample(s6_s, r1.xy).xyzw;
  r1.x = -0.5 + r1.w;
  r1.x = cb0[37].x * r1.x;
  r0.w = r0.w * 2 + -1;
  r0.w = min(1, abs(r0.w));
  r0.w = 1 + -r0.w;
  r0.xyz = r1.xxx * r0.www + r0.xyz;
  if (cb0[43].x > 0.5) {
    r3.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  }
  if (injectedData.countOld == injectedData.countNew) {
    r3.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r3.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyzw = r3.xyzw;
  return;
}