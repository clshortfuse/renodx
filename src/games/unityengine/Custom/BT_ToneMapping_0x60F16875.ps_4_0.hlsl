#include "../tonemap.hlsl"

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
  float4 cb0[52];
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

  r0.xw = float2(1,0);
  r0.z = cb0[14].x;
  r0.xyzw = cb0[2].xyxy * r0.xxzw;
  r1.x = cb0[14].x;
  r2.xyzw = -r0.xywy * r1.xxxx + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r1.z = -1;
  r1.yw = -r0.zy * r1.zx + v1.xy;
  r3.xyzw = t0.Sample(s0_s, r1.yw).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r0.zwxw * r1.zxxx + v1.xyxy;
  r4.xyzw = r0.zywy * r1.zxxx + v1.xyxy;
  r0.xy = r0.xy * r1.xx + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = r2.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r2.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[14].yyy * r0.xyz * injectedData.fxBloom;
  r1.xyzw = t8.Sample(s1_s, w1.xy).xyzw;
  r0.xyz = r0.xyz * float3(0.0625,0.0625,0.0625) + r1.xyz;
  o0.w = r1.w;
  r0.xyz = -cb0[47].xyz + r0.xyz;
  r1.xy = float2(-0.5,-0.5) + w1.xy;
  r1.xy = cb0[48].xx * abs(r1.xy) * min(1.f, injectedData.fxVignette);
  r1.xy = log2(r1.xy);
  r1.xy = cb0[48].zz * r1.xy;
  r1.xy = exp2(r1.xy);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = cb0[48].y * r0.w * max(1.f, injectedData.fxVignette);
  r0.w = exp2(r0.w);
  r0.w = min(1, r0.w);
  r0.xyz = r0.www * r0.xyz + cb0[47].xyz;
  r0.xyz = cb0[16].www * r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.w = -13 + cb0[9].x;
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz / r0.www;
  r1.x = dot(float3(0.390404999,0.549941003,0.00892631989), r0.xyz);
  r1.y = dot(float3(0.070841603,0.963172019,0.00135775004), r0.xyz);
  r1.z = dot(float3(0.0231081992,0.128021002,0.936245024), r0.xyz);
  r0.xyz = cb0[8].yzw * r1.xyz;
  r1.x = dot(float3(2.85846996,-1.62879002,-0.0248910002), r0.xyz);
  r1.y = dot(float3(-0.210181996,1.15820003,0.000324280991), r0.xyz);
  r1.z = dot(float3(-0.0418119989,-0.118169002,1.06867003), r0.xyz);
  r1.yzx = applyUserTonemapACES(r1.xyz, 4);
  r0.xyz = handleUserLUT(r1.yzx, t1, s2_s, cb0[4].xyz, 2, true);
  r1.xy = v1.xy * cb0[7].xy + cb0[7].zw;
  r1.xyzw = t2.Sample(s4_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = sign(r0.w);
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0), 1);
  if (injectedData.countOld == injectedData.countNew) {
  r0.xyz = PostToneMapScale(r0.xyz);
  }
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xy = cb1[6].xy * v1.xy;
  r1.xy = (int2)r1.xy;
  r1.zw = float2(0,0);
  r2.xyzw = t7.Load(r1.xyz).xyzw; // UI
  r1.xyzw = t6.Load(r1.xyw).xyzw; // UI
  r2.xyz = cb0[16].www * r2.xyz;
  r0.w = saturate(r2.w);
  r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.w = cb1[0].y * cb0[49].z;
  r0.w = 0.5 * r0.w;
  r2.xy = v1.xy * float2(20,20) + r0.ww;
  r2.xyzw = t3.Sample(s5_s, r2.xy).xyzw;
  r2.yz = float2(1,1) + -cb0[49].yx;
  r3.xy = float2(1,1) + -r2.yz;
  r0.w = r2.x * r3.x + r2.y;
  r1.xyz = r1.xyz * r0.www;
  r0.w = saturate(r1.w);
  r1.w = cb0[2].z / cb0[2].w;
  r2.x = v1.x * r1.w;
  r2.y = v1.y;
  r2.xy = float2(10,10) * r2.xy;
  r4.xyzw = t4.Sample(s6_s, r2.xy).xyzw;
  r1.w = r4.x * r3.y + r2.z;
  r1.xyz = r1.xyz * r1.www;
  r1.xyz = cb0[51].xyz * r1.xyz;
  r1.xyz = cb0[16].www * r1.xyz;
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r2.xyzw = t9.Sample(s1_s, w1.xy).xyzw;  // UI
  r2.xyz = cb0[16].www * r2.xyz;
  r2.xyz = cb0[49].www * r2.xyz;
  r0.xyz = r1.xyz + r2.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(r0.xyz);
  r0.w = 1 + cb0[8].x;
  r0.w = 1 / r0.w;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, 1 / (1 + cb0[8].x));
  }
  r1.xyzw = t5.Sample(s3_s, v1.xy).xyzw;
  r0.w = 1 + -r1.w;
  o0.xyz = r0.xyz * r0.www;
  if(injectedData.toneMapType == 0.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}