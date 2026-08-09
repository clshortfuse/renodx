#include "../../common.hlsl"

Texture2D<float4> t12 : register(t12);
Texture2D<float4> t11 : register(t11);
Texture2D<float4> t10 : register(t10);
Texture2D<float4> t9 : register(t9);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s12_s : register(s12);
SamplerState s11_s : register(s11);
SamplerState s10_s : register(s10);
SamplerState s9_s : register(s9);
SamplerState s8_s : register(s8);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[26];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r2.xyzw = float4(1,1,-1,0) * cb0[10].xyxy;
  r3.xyzw = -r2.xywy * cb0[11].xxxx + w2.xyxy;
  r4.xyzw = t2.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s3_s, r3.zw).xyzw;
  r0.yzw = r3.xyz * float3(2,2,2) + r4.xyz;
  r3.xy = -r2.zy * cb0[11].xx + w2.xy;
  r3.xyzw = t2.Sample(s3_s, r3.xy).xyzw;
  r0.yzw = r3.xyz + r0.yzw;
  r3.xyzw = r2.zwxw * cb0[11].xxxx + w2.xyxy;
  r4.xyzw = t2.Sample(s3_s, r3.xy).xyzw;
  r0.yzw = r4.xyz * float3(2,2,2) + r0.yzw;
  r4.xyzw = t2.Sample(s3_s, w2.xy).xyzw;
  r0.yzw = r4.xyz * float3(4,4,4) + r0.yzw;
  r3.xyzw = t2.Sample(s3_s, r3.zw).xyzw;
  r0.yzw = r3.xyz * float3(2,2,2) + r0.yzw;
  r3.xyzw = r2.zywy * cb0[11].xxxx + w2.xyxy;
  r4.xyzw = t2.Sample(s3_s, r3.xy).xyzw;
  r0.yzw = r4.xyz + r0.yzw;
  r3.xyzw = t2.Sample(s3_s, r3.zw).xyzw;
  r0.yzw = r3.xyz * float3(2,2,2) + r0.yzw;
  r2.xy = r2.xy * cb0[11].xx + w2.xy;
  r2.xyzw = t2.Sample(s3_s, r2.xy).xyzw;
  r0.yzw = r2.xyz + r0.yzw;
  r0.yzw = cb0[11].yyy * r0.yzw * injectedData.fxBloom;
  r0.yzw = float3(0.0625,0.0625,0.0625) * r0.yzw;
  r1.xyz = r1.xyz * r0.xxx + r0.yzw;
  r2.xyzw = t3.Sample(s4_s, v2.xy).xyzw;
  r3.xyzw = t4.Sample(s5_s, r2.xy).xyzw;
  r0.x = 1 + -cb0[12].y;
  r1.w = 1 + cb0[12].z;
  r0.x = r0.x * r1.w + -cb0[12].z;
  r0.x = r2.z + -r0.x;
  r0.x = saturate(r0.x / cb0[12].z);
  r4.xyzw = t5.Sample(s6_s, r2.xy).xyzw;
  r4.xyz = cb0[12].xxx * r4.xyz;
  r4.xyz = r4.xyz * r0.xxx;
  r2.xy = r2.xy * cb0[13].xy + cb0[13].zw;
  r5.xyzw = t6.Sample(s7_s, r2.xy).xyzw;
  r0.x = 1 + -cb0[14].y;
  r2.xyz = saturate(r5.xyz + -r0.xxx);
  r5.xyz = cb0[14].zzz * r2.xyz;
  r5.xyz = r5.xyz * r2.www;
  r6.xyz = float3(1,1,1) + -r1.xyz;
  r1.xyz = r5.xyz * r6.xyz + r1.xyz;
  r3.xyz = r3.xyz * cb0[11].zzz * injectedData.fxLens + r4.xyz;
  r2.xyz = r2.xyz * cb0[14].xxx + r3.xyz;
  r0.xyz = r2.xyz * r0.yzw;
  r0.xyz = r0.xyz * r2.www + r1.xyz;
  if (cb0[23].x > 0) {
    r1.xy = float2(-0.5,-0.5) + v2.yx;
    r1.zw = cb1[6].yx / cb1[6].xy;
    r1.xy = r1.xy * r1.zw;
    r1.zw = float2(-0.5,-0.5) + v2.xy;
    r1.xy = (cb1[6].y < cb1[6].x) ? r1.zx : r1.yw;
    r1.xy = float2(0.699999988,0.699999988) * r1.xy;
    r2.x = dot(float2(0.707106769,0.707106769), r1.xy);
    r2.y = dot(float2(-0.707106769,0.707106769), r1.xy);
    r1.xy = float2(0.5,0.5) + r2.xy;
    r2.xyzw = t7.Sample(s10_s, r1.xy).xyzw;
    r1.xyzw = t8.Sample(s11_s, r1.xy).xyzw;
    r0.w = 1 + cb0[23].z;
    r0.w = cb0[23].y * r0.w + -cb0[23].z;
    r0.w = r2.x + -r0.w;
    r0.w = saturate(r0.w / cb0[23].z);
    r1.x = r0.w < 1 ? 1.0 : 0;
    r1.x = r1.w * r1.x;
    r1.yzw = cb0[22].xyz * r0.www + -r0.xyz;
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
  }
  r1.xyzw = t9.Sample(s9_s, v2.xy).xyzw;
  r0.w = 1 + -cb0[21].x;
  r1.w = 1 + cb0[21].y;
  r0.w = r0.w * r1.w + -cb0[21].y;
  r1.xyz = r1.zxy + -r0.www;
  r1.xyz = saturate(r1.xyz / cb0[21].yyy);
  r2.xyz = (r1.xyz < (1.0).xxx) ? float3(1,1,1) : 0;
  r3.xyz = cb0[22].zxy * r1.xyz + -r0.zxy;
  r2.xyz = r2.xyz * r3.xyz + r0.zxy;
  r0.xyz = r1.xyz * r0.zxy;
  r0.xyz = cb0[21].z > 0 ? r2.xyz : r0.xyz;
  r1.xy = v2.xy * cb0[24].xy + cb0[24].zw;
  r1.xyzw = t10.Sample(s12_s, r1.xy).xyzw;
  r0.w = saturate(cb0[25].x * r1.x);
  r1.xyz = cb0[25].yyy + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.xyz = cb0[15].www * r0.xyz;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[15].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[15].xy;
  r1.yz = r0.zw * cb0[15].xy + r1.xy;
  r1.x = r0.y * cb0[15].y + r1.y;
  r2.xyzw = t11.Sample(s8_s, r1.xz).xyzw;
  r3.x = cb0[15].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t11.Sample(s8_s, r0.zw).xyzw;
  r0.x = r0.x * cb0[15].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t11, r0.yzx, cb0[15].z + 1u);
  }
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
    r0.xyz = log2(r0.xyz);
    r0.xyz = cb0[7].yyy * r0.xyz;
    r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb0[7].y);
  }
  r1.xy = v1.xy * cb0[6].xy + cb0[6].zw;
  r1.xyzw = t12.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = sign(r0.w);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.w = (1.0 / 255.0) * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * cb0[7].x, 1);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}