// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 11 16:49:27 2024
// Secondary UI shader (Gauge, purple trim, minimap)

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  int BlendTexture1BlendModeOfColor : packoffset(c0);
  int BlendTexture1BlendModeOfAlpha : packoffset(c0.y);
  float4 WhiteColorInterpolationRGBA : packoffset(c1);
  float4 BlackColorInterpolationRGBA : packoffset(c2);
  float2 ScaleForCalcOfIndirectTexture : packoffset(c3);
  float SaturationScale : packoffset(c3.z);
  float vATest : packoffset(c3.w);
}

SamplerState __smpsStage0_s : register(s0);
SamplerState __smpsStage1_s : register(s1);
Texture2D<float4> sStage0 : register(t0);
Texture2D<float4> sStage1 : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(BlendTexture1BlendModeOfColor >= 10);
  if (r0.x != 0) {
    r0.y = cmp(BlendTexture1BlendModeOfColor == 10);
    if (r0.y != 0) {
      r0.yzw = sStage1.Sample(__smpsStage1_s, v2.wz).xyw;
      r0.yz = float2(-0.5,-0.5) + r0.yz;
      r0.y = dot(r0.yy, ScaleForCalcOfIndirectTexture.xx);
      r0.z = dot(r0.zz, ScaleForCalcOfIndirectTexture.yy);
      r1.xy = v2.xy + r0.yz;
      r1.xyzw = sStage0.Sample(__smpsStage0_s, r1.xy).xyzw;
      r1.w = min(r1.w, r0.w);
    } else {
      r0.yzw = sStage1.Sample(__smpsStage1_s, v2.wz).xyw;
      r0.yz = float2(-0.5,-0.5) + r0.yz;
      r0.y = dot(r0.yy, ScaleForCalcOfIndirectTexture.xx);
      r0.z = dot(r0.zz, ScaleForCalcOfIndirectTexture.yy);
      r2.xy = v2.xy + r0.yz;
      r1.xyzw = sStage0.Sample(__smpsStage0_s, r2.xy).xyzw;
      r1.w = min(r1.w, r0.w);
    }
  } else {
    r1.xyzw = sStage0.Sample(__smpsStage0_s, v2.xy).xyzw;
  }
  if (r0.x == 0) {
    r0.xyzw = sStage1.Sample(__smpsStage1_s, v2.wz).xyzw;
    r2.x = cmp(BlendTexture1BlendModeOfColor == 2);
    if (r2.x != 0) {
      r2.xyz = r0.xyz + -r1.xyz;
      r1.xyz = r0.www * r2.xyz + r1.xyz;
    } else {
      r2.x = cmp(BlendTexture1BlendModeOfColor == 3);
      if (r2.x != 0) {
        r1.xyz = r1.xyz * r0.xyz;
      } else {
        r2.x = cmp(BlendTexture1BlendModeOfColor == 1);
        if (r2.x != 0) {
          r2.xyz = r0.www * r0.xyz;
          r1.xyz = saturate(r1.www * r1.xyz + r2.xyz);
        } else {
          r2.x = cmp(BlendTexture1BlendModeOfColor == 4);
          if (r2.x != 0) {
            r1.xyz = r0.xyz;
          } else {
            r2.x = cmp(BlendTexture1BlendModeOfColor == 5);
            if (r2.x != 0) {
              r2.xyz = r0.www * r0.xyz;
              r1.xyz = saturate(r1.www * r1.xyz + -r2.xyz);
            } else {
              r2.x = cmp(BlendTexture1BlendModeOfColor == 6);
              if (r2.x != 0) {
                r1.x = saturate(dot(r0.xx, r1.xx));
                r1.y = saturate(dot(r0.yy, r1.yy));
                r1.z = saturate(dot(r0.zz, r1.zz));
              } else {
                r2.xyz = float3(1,1,1) + -r0.xyz;
                r2.xyz = saturate(r1.xyz / r2.xyz);
                r3.xyz = float3(1,1,1) + -r1.xyz;
                r3.xyz = r3.xyz / r0.xyz;
                r3.xyz = saturate(float3(1,1,1) + -r3.xyz);
                r4.xyz = cmp(BlendTexture1BlendModeOfColor == int3(7,8,9));
                r5.xyz = r0.xyz + r1.xyz;
                r0.xyz = r1.xyz * r0.xyz;
                r0.xyz = saturate(-r0.xyz * float3(2,2,2) + r5.xyz);
                r0.xyz = r4.zzz ? r0.xyz : r1.xyz;
                r0.xyz = r4.yyy ? r3.xyz : r0.xyz;
                r1.xyz = r4.xxx ? r2.xyz : r0.xyz;
              }
            }
          }
        }
      }
    }
    r0.x = max(r1.w, r0.w);
    r0.y = min(r1.w, r0.w);
    r1.w = BlendTexture1BlendModeOfAlpha ? r0.y : r0.x;
  }
  r0.xyzw = v1.xyzw * r1.xyzw;
  r1.w = cmp(r0.w < vATest);
  if (r1.w != 0) discard;
  r2.xyz = WhiteColorInterpolationRGBA.xyz * WhiteColorInterpolationRGBA.xyz;
  r3.xyz = BlackColorInterpolationRGBA.xyz * BlackColorInterpolationRGBA.xyz;
  r1.xyz = -r1.xyz * v1.xyz + float3(1,1,1);
  r1.xyz = r3.xyz * r1.xyz;
  r0.xyz = r2.xyz * r0.xyz + r1.xyz;
  r1.x = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = -r1.xxx + r0.xyz;
  o0.xyz = SaturationScale * r0.xyz + r1.xxx;
  o0.w = r0.w;
  
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits; //Ratio of UI:Game brightness
    o0.rgb = renodx::math::SafePow(o0.rgb, 1/2.2); //Inverse 2.2 gamma  
  
  
  return;
}