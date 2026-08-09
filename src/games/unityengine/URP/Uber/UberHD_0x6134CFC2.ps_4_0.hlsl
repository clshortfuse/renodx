#include "../../common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[16];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[8].xxxx * r0.xyzw * injectedData.fxCA;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.yz = v1.xy * cb0[13].zw + float2(0.5,0.5);
  r2.xz = floor(r1.yz);
  r1.yz = frac(r1.yz);
  r3.xyzw = -r1.yzyz * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r1.yzyz * r3.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r4.xy = r1.yz * float2(0.5,0.5) + float2(-1,-1);
  r4.zw = r1.yz * r1.yz;
  r4.xy = r4.zw * r4.xy + float2(0.666666687,0.666666687);
  r3.xyzw = r1.yzyz * r3.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r1.yz = float2(1,1) + -r4.xy;
  r1.yz = r1.yz + -r3.xy;
  r1.yz = r1.yz + -r3.zw;
  r3.zw = r3.zw + r4.xy;
  r3.xy = r3.xy + r1.yz;
  r4.zw = float2(1,1) / r3.zw;
  r4.zw = r4.xy * r4.zw + float2(-1,-1);
  r5.xy = float2(1,1) / r3.xy;
  r4.xy = r1.yz * r5.xy + float2(1,1);
  r5.xyzw = r4.zwxw + r2.xzxz;
  r5.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r5.xyzw;
  r5.xyzw = cb0[13].xyxy * r5.xyzw;
  r5.xyzw = min(float4(1,1,1,1), r5.xyzw);
  r6.xyzw = t1.SampleLevel(s0_s, r5.xy, 0).xyzw;
  r5.xyzw = t1.SampleLevel(s0_s, r5.zw, 0).xyzw;
  r5.xyzw = r5.xyzw * r3.xxxx;
  r5.xyzw = r3.zzzz * r6.xyzw + r5.xyzw;
  r4.xyzw = r4.zyxy + r2.xzxz;
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r4.xyzw = cb0[13].xyxy * r4.xyzw;
  r4.xyzw = min(float4(1,1,1,1), r4.xyzw);
  r6.xyzw = t1.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r4.xyzw = t1.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyzw = r4.xyzw * r3.xxxx;
  r4.xyzw = r3.zzzz * r6.xyzw + r4.xyzw;
  r4.xyzw = r4.xyzw * r3.yyyy;
  r3.xyzw = r3.wwww * r5.xyzw + r4.xyzw;
  if (cb0[3].x > 0) {
    r1.yzw = r3.xyz * r3.www;
    r3.xyz = float3(8,8,8) * r1.yzw;
  }
  r1.yzw = cb0[2].xxx * r3.xyz * injectedData.fxBloom;
  r0.x = r1.x;
  r0.y = r2.y;
  r0.xyz = r1.yzw * cb0[2].yzw + r0.xyz;
  if (cb0[10].z > 0) {
    r1.xy = -cb0[10].xy + v1.xy;
    r1.yz = cb0[10].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[9].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[10].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[9].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[9].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[0].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[0].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[0].xy;
  r1.yz = r0.zw * cb0[0].xy + r1.xy;
  r1.x = r0.y * cb0[0].y + r1.y;
  r2.xyzw = t3.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[0].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t3.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[0].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t3, r0.yzx, cb0[0].z + 1u);
  }
  if (cb0[1].w > 0) {
    r1.xyz = handleUserLUT(r0.xyz, t4, s0_s, cb0[1].xyz, 2, true);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[1].www * r1.xyz + r0.xyz;
  }
  if (cb0[15].x > 0) {
    r1.x = dot(float3(0.393000007,0.768999994,0.188999996), r0.xyz);
    r1.y = dot(float3(0.349000007,0.68599999,0.167999998), r0.xyz);
    r1.z = dot(float3(0.272000015,0.533999979,0.130999997), r0.xyz);
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = cb0[15].xxx * r1.xyz + r0.xyz;
  }
  if(injectedData.fxFilmGrainType == 0.f){
  r1.xy = v1.xy * cb0[12].xy + cb0[12].zw;
  r1.xyzw = t2.Sample(s1_s, r1.xy).xyzw;
  r0.w = -0.5 + r1.w;
  r0.w = r0.w + r0.w;
  r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.x = sqrt(r1.x);
  r1.x = cb0[11].y * -r1.x + 1;
  r1.yzw = r0.xyz * r0.www;
  r1.yzw = cb0[11].xxx * r1.yzw * injectedData.fxFilmGrain;
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xy = v1.xy * cb0[14].xy + cb0[14].zw;
  r1.xyzw = t5.Sample(s2_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = r0.w >= 0 ? 1 : -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.xyz = PostToneMapScale(r0.xyz, true);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}