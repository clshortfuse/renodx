#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Mon Sep 02 16:27:23 2024
RWTexture2D<float4> u9 : register(u9);  // decompiler missed this

Texture2D<float4> t18 : register(t18);

Texture2DArray<float4> t17 : register(t17);

Texture2D<float4> t14 : register(t14);

Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t0 : register(t0);

SamplerComparisonState s3_s : register(s3);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[31];
}




// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u9
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.zw = float2(0,0);
  r0.zw = t18.Load(r0.xyz).xy;
  r0.zw = cb0[2].zw * r0.zw;
  r1.xyz = t6.SampleLevel(s1_s, v1.xy, 0).xyz;
  r0.zw = r0.zw * float2(8,8) + v1.xy;
  r1.w = t6.SampleLevel(s1_s, r0.zw, 0).w;
  r2.x = cmp(r1.w < 1);
  if (r2.x != 0) {
    r2.xyz = t14.SampleLevel(s1_s, r0.zw, 0).xyw;
    r3.xy = float2(1,-1) * r2.xy;
    r2.x = dot(r2.xy, r2.xy);
    r2.x = cmp(r2.x != 0.000000);
    if (r2.x != 0) {
      r4.xyzw = t14.Gather(s0_s, v1.xy).xyzw;
      r2.x = min(r4.y, r4.z);
      r2.x = min(r4.x, r2.x);
      r2.x = min(r2.x, r4.w);
      r2.x = max(1, -r2.x);
      r2.x = r2.z / r2.x;
      r4.xy = (int2)r0.xy & int2(63,63);
      r4.z = 7 & asint(cb0[14].w);
      r4.w = 0;
      r2.y = t17.Load(r4.xyzw).x;
      r2.z = 0.25 * r2.y;
      r3.zw = r3.xy * r2.zz + v1.xy;
      r2.w = t2.SampleCmpLevelZero(s3_s, r3.zw, r2.x).x;
      r4.xyz = r2.yyy * float3(0.25,0.25,0.25) + float3(0.25,0.5,0.75);
      r5.xyzw = r3.xyxy * r4.xxyy + v1.xyxy;
      r2.y = t2.SampleCmpLevelZero(s3_s, r5.xy, r2.x).x;
      r3.z = t2.SampleCmpLevelZero(s3_s, r5.zw, r2.x).x;
      r5.xy = r3.xy * r4.zz + v1.xy;
      r2.x = t2.SampleCmpLevelZero(s3_s, r5.xy, r2.x).x;
      r2.xyw = cmp(float3(0,0,0) >= r2.xyw);
      r2.z = r2.w ? r2.z : 0;
      r2.y = r2.y ? r4.x : r2.z;
      r2.z = cmp(0 >= r3.z);
      r2.y = r2.z ? r4.y : r2.y;
      r2.x = r2.x ? r4.z : r2.y;
    } else {
      r2.x = 0;
    }
    r2.xy = r3.xy * r2.xx + v1.xy;
    r2.xyz = t3.SampleLevel(s1_s, r2.xy, 0).xyz;
    r3.xyzw = t12.SampleLevel(s1_s, v1.xy, 0).xyzw;
    r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
    r4.xyzw = t13.SampleLevel(s1_s, r0.zw, 0).xyzw;
    r4.xyzw = max(float4(0,0,0,0), r4.xyzw);
    r0.z = r4.w * r3.w;
    r3.xyz = r3.xyz * r4.www + r4.xyz;
    r0.w = r3.y + -r2.y;
    r0.w = saturate(cb0[29].z * r0.w);
    r0.z = min(1, r0.z);
    r2.xyz = r2.xyz * r0.zzz + r3.xyz;
    r1.w = saturate(r1.w);
    r0.z = max(r2.y, r2.z);
    r0.z = max(r2.x, r0.z);
    r0.z = 1 + r0.z;
    r0.z = rcp(r0.z);
    r3.xyz = r2.xyz * r0.zzz;
    r2.xyz = -r2.xyz * r0.zzz + r1.xyz;
    r1.xyz = r1.www * r2.xyz + r3.xyz;
  } else {
    r0.w = 0;
  }
  r0.z = max(r1.y, r1.z);
  r0.z = max(r1.x, r0.z);
  r0.z = 1 + -r0.z;
  r0.z = rcp(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r0.z = cmp(0 != cb0[21].w);
  if (r0.z != 0) {
    r0.z = t1.SampleLevel(s1_s, v1.xy, 0).x;
    r0.z = exp2(r0.z);
    r2.xyz = r1.xyz * r0.zzz;
  } else {
    r2.xyz = cb0[22].xxx * r1.xyz;
  }
  r1.xyz = t4.SampleLevel(s1_s, v1.xy, 0).xyz;
  r1.xyz = cb0[1].zzz * r1.xyz + r2.xyz;
  r2.xy = -cb0[14].yz + v0.xy;
  r0.z = dot(r2.xy, r2.xy);
  r0.z = cb0[14].x * r0.z;
  r0.z = r0.z * r0.z;
  r0.z = cb0[13].z * r0.z;
  r0.z = exp2(-r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r2.xyz = cb0[20].xyz * r1.yyy;
  r2.xyz = r1.xxx * cb0[19].xyz + r2.xyz;
  r1.xyz = r1.zzz * cb0[21].xyz + r2.xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r2.xyzw = -cb0[12].wxyz + float4(1,1,1,1);
  r0.z = cb0[13].y * v1.x;
  r0.z = v1.y * r0.z;
  r3.xy = float2(1,1) + -v1.xy;
  r0.z = r3.x * r0.z;
  r0.z = r0.z * r3.y;
  r0.z = log2(abs(r0.z));
  r0.z = cb0[13].x * r0.z;
  r0.z = exp2(r0.z);
  r0.z = saturate(r2.x * r0.z + cb0[12].w);
  r2.xyz = r0.zzz * r2.yzw + cb0[12].xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.z = cmp(0 != cb0[0].w);
  r1.xyz = r0.zzz ? float3(0,0,0) : r1.xyz;

  if (injectedData.toneMapType) {
    r1.xyz = renodx::color::grade::UserColorGrading(
        r1.xyz,
        injectedData.colorGradeExposure,              // exposure
        injectedData.colorGradeHighlights,            // highlights
        injectedData.colorGradeShadows,               // shadows
        injectedData.colorGradeContrast,              // contrast
        injectedData.colorGradeSaturation,            // saturation
        injectedData.colorGradeBlowout,               // dechroma
        injectedData.toneMapHueCorrection,            // hue correction
        renodx::tonemap::uncharted2::BT709(r1.xyz));  // Uncharted2
  }

  float3 lutInputColor = r1.xyz;

  r2.xyz = cmp(float3(0.0105910003,0.0105910003,0.0105910003) < r1.xyz);
  r3.xyzw = r1.xxyy * float4(5.55555582,5.3676548,5.55555582,5.3676548) + float4(0.0522719994,0.0928089991,0.0522719994,0.0928089991);
  r1.xy = log2(r3.xz);
  r1.xy = r1.xy * float2(0.0744116008,0.0744116008) + float2(0.385536999,0.385536999);
  r3.xy = r2.xy ? r1.xy : r3.yw;
  r1.xy = r1.zz * float2(5.55555582,5.3676548) + float2(0.0522719994,0.0928089991);
  r0.z = log2(r1.x);
  r0.z = r0.z * 0.0744116008 + 0.385536999;
  r3.z = r2.z ? r0.z : r1.y;
  // Sample 64x64x64 LUT
  r1.xyz = r3.xyz * float3(0.984375,0.984375,0.984375) + float3(0.0078125,0.0078125,0.0078125);
  r1.xyz = t0.SampleLevel(s1_s, r1.xyz, 0).xyz;
  r2.xyz = cmp(float3(0.149658203,0.149658203,0.149658203) < r1.xyz);
  r3.xyzw = float4(-0.385536999,-0.0928089991,-0.385536999,-0.0928089991) + r1.xxyy;
  r3.xyzw = float4(13.4387865,0.186301097,13.4387865,0.186301097) * r3.xyzw;
  r1.xy = exp2(r3.xz);
  r1.xy = float2(-0.0522719994,-0.0522719994) + r1.xy;
  r1.xy = float2(0.179999992,0.179999992) * r1.xy;
  r3.xy = r2.xy ? r1.xy : r3.yw;
  r1.xy = float2(-0.385536999,-0.0928089991) + r1.zz;
  r1.xy = float2(13.4387865,0.186301097) * r1.xy;
  r0.z = exp2(r1.x);
  r0.z = -0.0522719994 + r0.z;
  r0.z = 0.179999992 * r0.z;
  r3.z = r2.z ? r0.z : r1.y;

  r3.xyz = lerp(lutInputColor, r3.xyz, injectedData.colorGradeLUTStrength);  // LUT Strength

  r1.xyz = r3.xyz;  // r1.xyz = max(float3(0,0,0), r3.xyz);  
  r0.z = max(r1.y, r1.z);
  r0.z = max(r1.x, r0.z);
  r2.xyz = cmp(r1.xyz < float3(0.180000007,0.180000007,0.180000007));
  r3.xyz = min(cb0[24].xxx, r1.xyz);
  r4.xyz = sign(r3.xyz) * pow(abs(r3.xyz), cb0[23].www);  // r4.xyz = exp2(cb0[23].www * log2(r3.xyz));
  r3.xyz = sign(r3.xyz) * pow(abs(r3.xyz), cb0[24].zzz);  // r3.xyz = exp2(cb0[24].zzz * log2(r3.xyz));
  r3.xyz = r3.xyz * cb0[25].xxx + cb0[25].yyy;
  r3.xyz = r4.xyz / r3.xyz;
  r2.xyz = r2.xyz ? r3.xyz : r1.xyz;
  r2.w = max(r2.y, r2.z);
  r2.w = max(r2.x, r2.w);
  r1.xyz = r2.www * r1.xyz;
  r1.xyz = r1.xyz / r0.zzz;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = cb0[24].www * r2.xyz + r1.xyz;
  o0.xyz = r1.xyz;  // o0.xyz = max(float3(0,0,0), r1.xyz);
  if (injectedData.toneMapType == 0) {
    o0.xyz = max(0, o0.xyz);
  } else {
    o0.rgb = renodx::color::grade::UserColorGrading(  // apply saturation adjustment after LUT
        o0.rgb,
        1.f,                                // exposure
        1.f,                                // highlights
        1.f,                                // shadows
        1.f,                                // contrast
        injectedData.colorGradeSaturation,  // saturation
        injectedData.colorGradeBlowout);     // dechroma
  }
  r0.z = saturate(r1.w * 4 + -1);
  r0.z = -cb0[29].w * r0.z;
  r1.x = cmp(-0.100000001 < r0.z);
  r0.w = cb0[30].x * r0.w;
  r0.z = r1.x ? r0.w : r0.z;
  r0.z = cb0[29].w + r0.z;
  r0.z = cb0[30].z * r0.z;
  // Store the value r0.zzzz at the location r0.xy in the UAV u9
  u9[r0.xy] = float4(r0.zzzz);    // store_uav_typed u9.xyzw, r0.xyyy, r0.zzzz
  o0.w = 1;
  return;
}