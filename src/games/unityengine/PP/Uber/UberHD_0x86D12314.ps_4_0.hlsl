#include "../../common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[41];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.y = dot(r1.zw, r1.zw);
  r1.xyzw = r1.xyzw * r0.yyyy;
  r1.xyzw = cb0[35].wwww * r1.xyzw * injectedData.fxCA;
  r2.xyzw = t3.SampleLevel(s3_s, float2(0.166666999,0), 0).xyzw;
  r3.xyzw = t3.SampleLevel(s3_s, float2(0.5,0), 0).xyzw;
  r4.xyzw = t3.SampleLevel(s3_s, float2(0.833333015,0), 0).xyzw;
  r0.yz = saturate(v1.xy);
  r0.yz = cb0[26].xx * r0.yz;
  r5.xyzw = t1.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r1.xyzw = saturate(r1.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r6.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, r1.zw, 0).xyzw;
  r2.w = 1;
  r3.w = 1;
  r6.xyzw = r6.xyzw * r3.xyzw;
  r5.xyzw = r5.xyzw * r2.xyzw + r6.xyzw;
  r4.w = 1;
  r1.xyzw = r1.xyzw * r4.xyzw + r5.xyzw;
  r0.yzw = r3.xyz + r2.xyz;
  r2.xyz = r0.yzw + r4.xyz;
  r2.w = 3;
  r1.xyzw = r1.xyzw / r2.xyzw;
  r0.xyz = r1.xyz * r0.xxx;
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
    r2.xyz = r1.xyz * r0.xyz;
    r1.x = -1 + r1.w;
    r2.w = r0.w * r1.x + 1;
  } else {
    r3.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
    r0.w = renodx::color::srgb::DecodeSafe(r3.w);
    r1.xyz = float3(1,1,1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r0.xyz * r1.xyz + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.xyz + r0.xyz;
    r0.x = -1 + r1.w;
    r2.w = r0.w * r0.x + 1;
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t4.Sample(s4_s, r0.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t4, r0.xyz, 1 / cb0[36].x);
  }
  r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = r2.w * 2 + -1;
  r0.y = saturate(r0.x * renodx::math::FLT_MAX + 0.5);
  r0.y = r0.y * 2 + -1;
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.y * r0.x;
  r0.xyz = applyDither(r1.xyz, r0.x * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}