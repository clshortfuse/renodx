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
  float4 cb0[52];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = float4(1,1,-1,0) * cb0[43].xyxy;
  r2.xyzw = saturate(-r1.xywy * cb0[45].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r3.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + r3.xyzw;
  r3.xy = saturate(-r1.zy * cb0[45].xx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r3.xyzw = saturate(r1.zwxw * cb0[45].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw * float4(2,2,2,2) + r2.xyzw;
  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw * float4(4,4,4,4) + r2.xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw * float4(2,2,2,2) + r2.xyzw;
  r3.xyzw = saturate(r1.zywy * cb0[45].xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r2.xyzw = r3.xyzw * float4(2,2,2,2) + r2.xyzw;
  r1.xy = saturate(r1.xy * cb0[45].xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[45].yyyy * r1.xyzw * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[44].xy + cb0[44].zw;
  r2.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r3.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r1.xyzw;
  r2.xyz = cb0[45].zzz * r2.xyz * injectedData.fxLens;
  r2.w = 0;
  r1.xyzw = float4(0.0625,0.0625,0.0625,1) * r1.xyzw;
  r4.xyz = cb0[46].xyz * r1.xyz;
  r4.w = 0.0625 * r1.w;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r0.xyzw = r2.xyzw * r3.xyzw + r0.xyzw;
  if (cb0[51].y < 0.5) {
    r1.xy = -cb0[49].xy + v1.xy;
    r1.yz = cb0[50].xx * abs(r1.yx) * min(1.f, injectedData.fxVignette);
    r1.w = cb0[22].x / cb0[22].y;
    r1.w = -1 + r1.w;
    r1.w = cb0[50].w * r1.w + 1;
    r1.x = r1.z * r1.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[50].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[50].y * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[48].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[48].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  } else {
    r1.xyzw = t5.Sample(s5_s, v1.xy).xyzw;
    r1.x = renodx::color::srgb::DecodeSafe(r1.w);
    r1.yzw = float3(1,1,1) + -cb0[48].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[48].xyz;
    r1.yzw = r0.xyz * r1.yzw + -r0.xyz;
    r0.xyz = cb0[51].xxx * r1.yzw + r0.xyz;
    r1.y = -1 + r0.w;
    r0.w = r1.x * r1.y + 1;
  }
  r0.xyzw = cb0[47].zzzz * r0.xyzw;
  r1.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r1.xyz = cb0[47].yyy * r1.xyz;
  r1.w = 0.5 * cb0[47].x;
  r1.xyz = r1.xyz * cb0[47].xxx + r1.www;
  r1.xyzw = t4.Sample(s4_s, r1.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t4, r1.xyz, 1 / cb0[47].x);
  }
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.yzw = asint(cb0[41].yyy) & int3(2,1,4);
  r1.w = cmp((int)r2.y != 0);
  r2.y = -9.99999975e-05 + r2.x;
  r2.y = cmp(r2.y < 0);
  r1.w = r1.w ? r2.y : 0;
  if (r1.w != 0) discard;
  r1.w = v1.x * 2 + -1;
  r2.y = -v1.y * 2 + 1;
  r3.xyzw = cb0[33].xyzw * r2.yyyy;
  r3.xyzw = cb0[32].xyzw * r1.wwww + r3.xyzw;
  r3.xyzw = cb0[34].xyzw * r2.xxxx + r3.xyzw;
  r3.xyzw = cb0[35].xyzw + r3.xyzw;
  r3.xyz = r3.xyz / r3.www;
  r3.xyz = -cb0[36].xyz + r3.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r1.w = sqrt(r1.w);
  r3.xyz = r3.xyz / r1.www;
  if (r2.z == 0) {
    r2.x = 3 + -cb0[36].y;
    r2.x = r2.x / r3.y;
    r2.x = min(100, abs(r2.x));
    r4.xyzw = r2.xxxx * r3.xzxz + cb0[36].xzxz;
    r2.x = min(r2.x, r1.w);
    r5.xyzw = float4(0.0400000028,0.0200000014,0.0400000028,0.0200000014) * cb0[23].yyyy;
    r4.xyzw = r4.xyzw * float4(0.0299999993,0.0599999987,0.0299999993,0.0599999987) + r5.xyzw;
    r2.yz = float2(0,0);
    while (true) {
      r3.w = cmp((int)r2.z >= 3);
      if (r3.w != 0) break;
      r3.w = (int)-r2.z;
      r3.w = exp2(r3.w);
      r5.x = (int)r2.z;
      r5.x = exp2(r5.x);
      r5.yz = r5.xx * r4.zw;
      r6.xy = floor(r5.yz);
      r5.yz = r5.xx * r4.zw + -r6.xy;
      r7.xyzw = float4(0,0,1,1) + r6.xyxy;
      r6.zw = float2(1,1) + r6.xy;
      r6.xyzw = r5.xxxx * r4.xyzw + -r6.xyzw;
      r5.xw = r5.yz * r5.yz;
      r5.yz = -r5.yz * float2(2,2) + float2(3,3);
      r8.xy = r5.xw * r5.yz;
      r9.xyz = float3(0.103100002,0.103,0.0973000005) * r7.xyx;
      r9.xyz = frac(r9.xyz);
      r10.xyz = float3(19.1900005,19.1900005,19.1900005) + r9.yzx;
      r9.w = dot(r9.xyz, r10.xyz);
      r9.xyz = r9.xyz + r9.www;
      r9.xw = r9.xx + r9.yz;
      r9.xy = r9.xw * r9.zy;
      r9.xy = frac(r9.xy);
      r10.xyz = float3(0.103100002,0.103,0.0973000005) * r7.xwx;
      r10.xyz = frac(r10.xyz);
      r11.xyz = float3(19.1900005,19.1900005,19.1900005) + r10.yzx;
      r7.x = dot(r10.xyz, r11.xyz);
      r10.xyz = r10.xyz + r7.xxx;
      r9.zw = r10.xx + r10.yz;
      r9.zw = r9.zw * r10.zy;
      r9.zw = frac(r9.zw);
      r9.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r9.xyzw;
      r10.xyz = float3(0.103100002,0.103,0.0973000005) * r7.zyz;
      r10.xyz = frac(r10.xyz);
      r11.xyz = float3(19.1900005,19.1900005,19.1900005) + r10.yzx;
      r7.x = dot(r10.xyz, r11.xyz);
      r10.xyz = r10.xyz + r7.xxx;
      r7.xy = r10.xx + r10.yz;
      r7.xy = r7.xy * r10.zy;
      r7.xy = frac(r7.xy);
      r10.xyz = float3(0.103100002,0.103,0.0973000005) * r7.zwz;
      r10.xyz = frac(r10.xyz);
      r11.xyz = float3(19.1900005,19.1900005,19.1900005) + r10.yzx;
      r7.z = dot(r10.xyz, r11.xyz);
      r10.xyz = r10.xyz + r7.zzz;
      r7.zw = r10.xx + r10.yz;
      r7.zw = r7.zw * r10.zy;
      r7.zw = frac(r7.zw);
      r7.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r7.xyzw;
      r10.x = dot(r9.xy, r6.xy);
      r10.y = dot(r9.zw, r6.xw);
      r10.z = dot(r7.yx, r6.yz);
      r10.w = dot(r7.zw, r6.zw);
      r8.zw = -r5.wx * r5.zy + float2(1,1);
      r5.xyzw = r8.zyzy * r8.wwxx;
      r5.x = dot(r10.xyzw, r5.xyzw);
      r3.w = r5.x * r3.w;
      r2.y = r3.w * 1.41421354 + r2.y;
      r2.z = (int)r2.z + 1;
    }
    r1.w = r2.y * 2 + r2.x;
  }
  r2.x = cb0[40].w * 7 + 1;
  r2.y = saturate(dot(r3.xyz, -cb0[37].xyz));
  r2.y = log2(r2.y);
  r2.x = r2.x * r2.y;
  r2.x = exp2(r2.x);
  r3.xzw = cb0[40].xyz + -cb0[39].xyz;
  r2.xyz = r2.xxx * r3.xzw + cb0[39].xyz;
  r3.x = 1 / cb0[41].x;
  r3.z = -3 + cb0[36].y;
  r3.w = r3.x * r3.y;
  r4.x = r3.w * r1.w;
  r4.x = 1.44269502 * r4.x;
  r4.x = exp2(r4.x);
  r4.x = -1 + r4.x;
  r1.w = r3.y * r1.w + r3.z;
  r1.w = -r3.x * r1.w;
  r1.w = 1.44269502 * r1.w;
  r1.w = exp2(r1.w);
  r1.w = r4.x * r1.w;
  r1.w = r1.w / r3.w;
  r3.x = cb0[38].y * -r1.w;
  r3.x = 1.44269502 * r3.x;
  r3.x = exp2(r3.x);
  r1.w = cb0[38].x * r1.w;
  r1.w = 0.5 * r1.w;
  r2.xyz = r1.www * r2.xyz;
  r2.xyz = r1.xyz * r3.xxx + r2.xyz;
  r1.w = log2(v1.y);
  r1.w = 4.5 * r1.w;
  r1.w = exp2(r1.w);
  r3.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r1.www * r3.xyz + r1.xyz;
  r1.xyz = r2.www ? r2.xyz : r1.xyz;
  r0.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  r1.xyzw = float4(0.0973,0.103,0.1099,0.1031) * v0.xyyx;
  r1.xyzw = frac(r1.xyzw);
  r2.xyzw = float4(19.19,19.19,19.19,19.19) + r1.zxwy;
  r2.x = dot(r1.wyxz, r2.xyzw);
  r1.xyzw = r2.xxxx + r1.xyzw;
  r2.xyzw = r1.wwyx + r1.yxxz;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyzw = frac(r1.xyzw);
  r0.xyzw = r1.xyzw * (1.0 / 255.0) * injectedData.fxNoise + r0.xyzw;
  r1.yzw = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = asint(cb0[41].w) == 1 ? PostToneMapScale(r1.yzw) : PostToneMapScale(r1.yzw, true);
  } else {
    r0.xyz = asint(cb0[41].w) == 1 ? r1.yzw : r0.xyz;
  }
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;
}