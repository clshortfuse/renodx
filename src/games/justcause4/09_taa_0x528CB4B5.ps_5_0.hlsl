#include "./shared.h"


Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

SamplerState s1_s : register(s1);

cbuffer cb1 : register(b1)
{
  float4 cb1[2];
}


static const float3x3 BT709_2_XYZ_MAT = float3x3(
  0.4123907993f, 0.3575843394f, 0.1804807884f,
  0.2126390059f, 0.7151686788f, 0.0721923154f,
  0.0193308187f, 0.1191947798f, 0.9505321522f
);

float yFromBT709(float3 bt709) {
  return dot(bt709, BT709_2_XYZ_MAT[1].rgb);
}

float3 sampleMotionBlurWithLuminance(float2 coords) {
  float3 blurred = t0.SampleLevel(s1_s, coords, 0).xyz;
  float3 original = t1.SampleLevel(s1_s, coords, 0).xyz;
  blurred = lerp(original, blurred, injectedData.fxMotionBlur);
  float3 blurredY = yFromBT709(abs(blurred));
  float3 originalY = yFromBT709(abs(original));
  return blurred * (blurredY ? (originalY / blurredY) : 0);
}

// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[1].xy * v1.xy;
  r1.xyzw = cb1[0].zwzw * float4(0,-2,-2,0) + r0.xyxy;
  r1.xyzw = min(cb1[1].zwzw, r1.xyzw);
  // r2.xyz = t0.SampleLevel(s1_s, r1.xy, 0).xyz;
  r2.xyz = sampleMotionBlurWithLuminance(r1.xy);
  
  // r1.xyz = t0.SampleLevel(s1_s, r1.zw, 0).xyz;
  r1.xyz = sampleMotionBlurWithLuminance(r1.zw);

  r0.zw = min(cb1[1].zw, r0.xy);
  // r3.xyz = t0.SampleLevel(s1_s, r0.zw, 0).xyz;
  r3.xyz = sampleMotionBlurWithLuminance(r0.zw);
  

  r4.xyzw = cb1[0].zwzw * float4(2,0,0,2) + r0.xyxy;
  r4.xyzw = min(cb1[1].zwzw, r4.xyzw);
  // r5.xyz = t0.SampleLevel(s1_s, r4.xy, 0).xyz;
  r5.xyz = sampleMotionBlurWithLuminance(r4.xy);

  // r4.xyz = t0.SampleLevel(s1_s, r4.zw, 0).xyz;
  r4.xyz = sampleMotionBlurWithLuminance(r4.zw);
  
  r0.z = r2.y * 1.9632107 + r2.x;
  r0.w = r1.y * 1.9632107 + r1.x;
  r1.w = r3.y * 1.9632107 + r3.x;
  r2.w = r5.y * 1.9632107 + r5.x;
  r3.w = r4.y * 1.9632107 + r4.x;
  r4.w = min(r0.z, r0.w);
  r5.w = min(r3.w, r2.w);
  r4.w = min(r5.w, r4.w);
  r4.w = min(r4.w, r1.w);
  r5.w = max(r0.z, r0.w);
  r6.x = max(r3.w, r2.w);
  r5.w = max(r6.x, r5.w);
  r5.w = max(r5.w, r1.w);
  r4.w = r5.w + -r4.w;
  r5.w = 0.125 * r5.w;
  r5.w = max(0.0416666679, r5.w);
  r5.w = cmp(r4.w >= r5.w);
  if (r5.w != 0) {
    r6.xyzw = float4(4,4,-2,-2) * cb1[0].xyzw;
    r6.xy = saturate(r6.xy);
    r1.xyz = r2.xyz + r1.xyz;
    r1.xyz = r1.xyz + r3.xyz;
    r1.xyz = r1.xyz + r5.xyz;
    r1.xyz = r1.xyz + r4.xyz;
    r2.x = r0.z + r0.w;
    r2.x = r2.x + r2.w;
    r2.x = r2.x + r3.w;
    r2.x = r2.x * 0.25 + -r1.w;
    r2.x = abs(r2.x) / r4.w;
    r2.x = -0.25 + r2.x;
    r2.x = max(0, r2.x);
    r2.x = 1.33333337 * r2.x;
    r2.x = min(0.75, r2.x);
    r2.yz = v1.xy * cb1[1].xy + r6.zw;
    r2.yz = min(cb1[1].zw, r2.yz);
    
    // r4.xyz = t0.SampleLevel(s1_s, r2.yz, 0).xyz;
    r4.xyz = sampleMotionBlurWithLuminance(r2.yz);

    r5.xyzw = cb1[0].zwzw * float4(2,-2,-2,2) + r0.xyxy;
    r5.xyzw = min(cb1[1].zwzw, r5.xyzw);
    
    // r7.xyz = t0.SampleLevel(s1_s, r5.xy, 0).xyz;
    r7.xyz = sampleMotionBlurWithLuminance(r5.xy);

    // r5.xyz = t0.SampleLevel(s1_s, r5.zw, 0).xyz;
    r5.xyz = sampleMotionBlurWithLuminance(r5.zw);

    r0.xy = cb1[0].zw * float2(2,2) + r0.xy;
    r0.xy = min(cb1[1].zw, r0.xy);
    
    //r8.xyz = t0.SampleLevel(s1_s, r0.xy, 0).xyz;
    r8.xyz = sampleMotionBlurWithLuminance(r0.xy);
    
    r9.xyz = r7.xyz + r4.xyz;
    r9.xyz = r9.xyz + r5.xyz;
    r9.xyz = r9.xyz + r8.xyz;
    r1.xyz = r9.xyz + r1.xyz;
    r1.xyz = r1.xyz * r2.xxx;
    r0.x = r4.y * 1.9632107 + r4.x;
    r0.y = r7.y * 1.9632107 + r7.x;
    r2.y = r5.y * 1.9632107 + r5.x;
    r2.z = r8.y * 1.9632107 + r8.x;
    r4.xy = float2(-0.5,-0.5) * r0.zw;
    r4.x = r0.x * 0.25 + r4.x;
    r4.x = r0.y * 0.25 + r4.x;
    r4.z = r0.w * 0.5 + -r1.w;
    r4.w = -0.5 * r2.w;
    r4.z = r2.w * 0.5 + r4.z;
    r4.x = abs(r4.x) + abs(r4.z);
    r4.z = -0.5 * r3.w;
    r4.z = r2.y * 0.25 + r4.z;
    r4.z = r2.z * 0.25 + r4.z;
    r4.x = r4.x + abs(r4.z);
    r0.x = r0.x * 0.25 + r4.y;
    r0.x = r2.y * 0.25 + r0.x;
    r2.y = r0.z * 0.5 + -r1.w;
    r2.y = r3.w * 0.5 + r2.y;
    r0.x = abs(r2.y) + abs(r0.x);
    r0.y = r0.y * 0.25 + r4.w;
    r0.y = r2.z * 0.25 + r0.y;
    r0.x = r0.x + abs(r0.y);
    r0.x = cmp(r0.x >= r4.x);
    r0.y = r0.x ? -r6.y : -r6.x;
    r0.z = r0.x ? r0.z : r0.w;
    r0.w = r0.x ? r3.w : r2.w;
    r2.yz = r0.zw + -r1.ww;
    r0.zw = r0.zw + r1.ww;
    r0.zw = float2(0.5,0.5) * r0.zw;
    r2.w = cmp(abs(r2.y) >= abs(r2.z));
    r0.z = r2.w ? r0.z : r0.w;
    r0.w = r2.w ? abs(r2.y) : abs(r2.z);
    r0.y = r2.w ? r0.y : -r0.y;
    r2.y = 0.5 * r0.y;
    r2.z = r0.x ? 0 : r2.y;
    r4.x = v1.x * cb1[1].x + r2.z;
    r2.y = r0.x ? r2.y : 0;
    r4.y = v1.y * cb1[1].y + r2.y;
    r0.w = 0.25 * r0.w;
    r6.z = 0;
    r2.yz = r0.xx ? r6.xz : r6.zy;
    r4.zw = r4.xy + -r2.yz;
    r4.xy = r4.xy + r2.yz;
    r5.xyzw = r4.zwxy;
    r2.w = r0.z;
    r3.w = r0.z;
    r6.xyz = float3(0,0,0);
    while (true) {
      r6.w = cmp((int)r6.z >= 16);
      if (r6.w != 0) break;
      if (r6.x == 0) {
        r7.xy = min(cb1[1].zw, r5.xy);
        // r7.xy = t0.SampleLevel(s1_s, r7.xy, 0).xy;
        r7.xy = sampleMotionBlurWithLuminance(r7.xy);

        r6.w = r7.y * 1.9632107 + r7.x;
      } else {
        r6.w = r2.w;
      }
      if (r6.y == 0) {
        r7.xy = min(cb1[1].zw, r5.zw);
        // r7.xy = t0.SampleLevel(s1_s, r7.xy, 0).xy;
        r7.xy = sampleMotionBlurWithLuminance(r7.xy);

        r7.x = r7.y * 1.9632107 + r7.x;
      } else {
        r7.x = r3.w;
      }
      r7.y = r6.w + -r0.z;
      r7.y = cmp(abs(r7.y) >= r0.w);
      r6.x = (int)r6.x | (int)r7.y;
      r7.y = r7.x + -r0.z;
      r7.y = cmp(abs(r7.y) >= r0.w);
      r6.y = (int)r6.y | (int)r7.y;
      r7.y = (int)r6.y & (int)r6.x;
      if (r7.y != 0) {
        r2.w = r6.w;
        r3.w = r7.x;
        break;
      }
      r7.yz = r5.xy + -r2.yz;
      r5.xy = r6.xx ? r5.xy : r7.yz;
      r7.yz = r5.zw + r2.yz;
      r5.zw = r6.yy ? r5.zw : r7.yz;
      r6.z = (int)r6.z + 1;
      r2.w = r6.w;
      r3.w = r7.x;
    }
    r2.yz = v1.xy * cb1[1].xy + -r5.xy;
    r0.w = r0.x ? r2.y : r2.z;
    r2.yz = -v1.xy * cb1[1].xy + r5.zw;
    r2.y = r0.x ? r2.y : r2.z;
    r2.z = cmp(r0.w < r2.y);
    r2.w = r2.z ? r2.w : r3.w;
    r1.w = r1.w + -r0.z;
    r1.w = cmp(r1.w < 0);
    r0.z = r2.w + -r0.z;
    r0.z = cmp(r0.z < 0);
    r0.z = cmp((int)r0.z == (int)r1.w);
    r0.y = r0.z ? 0 : r0.y;
    r0.z = r2.y + r0.w;
    r0.w = r2.z ? r0.w : r2.y;
    r0.z = -1 / r0.z;
    r0.z = r0.w * r0.z + 0.5;
    r0.y = r0.z * r0.y;
    r0.z = r0.x ? 0 : r0.y;
    r4.x = v1.x * cb1[1].x + r0.z;
    r0.x = r0.x ? r0.y : 0;
    r4.y = v1.y * cb1[1].y + r0.x;
    r0.xy = min(cb1[1].zw, r4.xy);
    // r0.xyz = t0.SampleLevel(s1_s, r0.xy, 0).xyz;
    r0.xyz = sampleMotionBlurWithLuminance(r0.xy);
    r1.xyz = r1.xyz * float3(0.111111112,0.111111112,0.111111112) + r0.xyz;
    r3.xyz = -r2.xxx * r0.xyz + r1.xyz;
  }
  o0.xyz = r3.xyz;
  o0.w = 0;
  return;
}