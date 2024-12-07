#include ".\LUTBlackCorrection.hlsl"
#include ".\shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Dec 05 14:56:05 2024

struct RadialBlurComputeResult {
  float computeAlpha;  // Offset:    0
};

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c0);
  row_major float3x4 transposeViewMat : packoffset(c4);
  row_major float3x4 transposeViewInvMat : packoffset(c7);
  float4 projElement[2] : packoffset(c10);
  float4 projInvElements[2] : packoffset(c12);
  row_major float4x4 viewProjInvMat : packoffset(c14);
  row_major float4x4 prevViewProjMat : packoffset(c18);
  float3 ZToLinear : packoffset(c22);
  float subdivisionLevel : packoffset(c22.w);
  float2 screenSize : packoffset(c23);
  float2 screenInverseSize : packoffset(c23.z);
  float2 cullingHelper : packoffset(c24);
  float cameraNearPlane : packoffset(c24.z);
  float cameraFarPlane : packoffset(c24.w);
  float4 viewFrustum[6] : packoffset(c25);
  float4 clipplane : packoffset(c31);
}

cbuffer Tonemap : register(b1) {
  float exposureAdjustment : packoffset(c0);
  float tonemapRange : packoffset(c0.y);
  float sharpness : packoffset(c0.z);
  float preTonemapRange : packoffset(c0.w);
  int useAutoExposure : packoffset(c1);
  float echoBlend : packoffset(c1.y);
  float AABlend : packoffset(c1.z);
  float AASubPixel : packoffset(c1.w);
  float ResponsiveAARate : packoffset(c2);
}

cbuffer CameraKerare : register(b2) {
  float kerare_scale : packoffset(c0);
  float kerare_offset : packoffset(c0.y);
}

cbuffer LensDistortionParam : register(b3) {
  float fDistortionCoef : packoffset(c0);
  float fRefraction : packoffset(c0.y);
  uint aberrationEnable : packoffset(c0.z);
  uint reserved : packoffset(c0.w);
}

cbuffer RadialBlurRenderParam : register(b4) {
  float4 cbRadialColor : packoffset(c0);
  float2 cbRadialScreenPos : packoffset(c1);
  float2 cbRadialMaskSmoothstep : packoffset(c1.z);
  float2 cbRadialMaskRate : packoffset(c2);
  float cbRadialBlurPower : packoffset(c2.z);
  float cbRadialSharpRange : packoffset(c2.w);
  uint cbRadialBlurFlags : packoffset(c3);
  float cbRadialReserve0 : packoffset(c3.y);
  float cbRadialReserve1 : packoffset(c3.z);
  float cbRadialReserve2 : packoffset(c3.w);
}

cbuffer FilmGrainParam : register(b5) {
  float2 fNoisePower : packoffset(c0);
  float2 fNoiseUVOffset : packoffset(c0.z);
  float fNoiseDensity : packoffset(c1);
  float fNoiseContrast : packoffset(c1.y);
  float fBlendRate : packoffset(c1.z);
  float fReverseNoiseSize : packoffset(c1.w);
}

cbuffer ColorCorrectTexture : register(b6) {
  float fTextureSize : packoffset(c0);
  float fTextureBlendRate : packoffset(c0.y);
  float fTextureBlendRate2 : packoffset(c0.z);
  float fTextureInverseSize : packoffset(c0.w);
  row_major float4x4 fColorMatrix : packoffset(c1);
}

cbuffer ColorDeficientTable : register(b7) {
  float4 cvdR : packoffset(c0);
  float4 cvdG : packoffset(c1);
  float4 cvdB : packoffset(c2);
}

cbuffer ImagePlaneParam : register(b8) {
  float4 ColorParam : packoffset(c0);
  float Levels_Rate : packoffset(c1);
  float Levels_Range : packoffset(c1.y);
  uint Blend_Type : packoffset(c1.z);
}

cbuffer CBControl : register(b9) {
  uint cPassEnabled : packoffset(c0);
}

SamplerState BilinearClamp_s : register(s0);
SamplerState TrilinearClamp_s : register(s1);
Texture2D<float4> SourceImage : register(t0);
StructuredBuffer<RadialBlurComputeResult> ComputeResultSRV : register(t1);
Texture3D<float4> tTextureMap0 : register(t2);
Texture3D<float4> tTextureMap1 : register(t3);
Texture3D<float4> tTextureMap2 : register(t4);
Texture2D<float4> ImagePlameBase : register(t5);
Texture2D<float> ImagePlameAlpha : register(t6);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: Kerare0,
    float v2: Exposure0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;

  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp_s,
      1.f,  // strength
      1.f,  // scaling
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      fTextureSize);
  float3 sdrColor;
  float3 untonemapped;
  float3 hdrColor;

  r0.xyzw = cPassEnabled & int4(1, 32, 2, 4);
  if (r0.x != 0) {
    r1.xy = v0.xy * screenInverseSize.xy + float2(-0.5, -0.5);
    r1.z = fDistortionCoef * 0.5 + 1;
    r1.z = max(1, r1.z);
    r1.z = rcp(r1.z);
    r1.w = dot(r1.xy, r1.xy);
    r2.x = fDistortionCoef * r1.w + 1;
    r2.xy = r2.xx * r1.xy;
    r2.xy = r2.xy * r1.zz + float2(0.5, 0.5);
    if (aberrationEnable == 0) {
      r3.xyz = SourceImage.Sample(BilinearClamp_s, r2.xy).xyz;
      r3.xyz = v2.xxx * r3.xyz;
      r2.z = max(r3.x, r3.y);
      r2.z = max(r2.z, r3.z);
      r2.w = (int)r2.z & 0x7f800000;
      // r2.w = cmp((int)r2.w == 0x7f800000);
      r2.w = cmp((uint)r2.w == 0x7f800000);
      if (r2.w != 0) {
        r4.xyz = float3(1, 1, 1);
      }
      if (r2.w == 0) {
        r2.z = r2.z * tonemapRange + 1;
        r4.xyz = r3.xyz / r2.zzz;
      }
    } else {
      r1.w = fRefraction + r1.w;
      r2.z = fDistortionCoef * r1.w + 1;
      r2.zw = r2.zz * r1.xy;
      r2.zw = r2.zw * r1.zz + float2(0.5, 0.5);
      r1.w = fRefraction + r1.w;
      r1.w = fDistortionCoef * r1.w + 1;
      r1.xy = r1.xy * r1.ww;
      r1.xy = r1.xy * r1.zz + float2(0.5, 0.5);
      r3.xyz = SourceImage.Sample(BilinearClamp_s, r2.xy).xyz;
      r3.xyz = v2.xxx * r3.xyz;
      r1.w = max(r3.x, r3.y);
      r1.w = max(r1.w, r3.z);
      r2.x = (int)r1.w & 0x7f800000;
      // r2.x = cmp((int)r2.x == 0x7f800000);
      r2.x = cmp((uint)r2.x == 0x7f800000);
      if (r2.x != 0) {
        r4.x = 1;
      }
      if (r2.x == 0) {
        r1.w = r1.w * tonemapRange + 1;
        r4.x = r3.x / r1.w;
      }
      r2.xyz = SourceImage.Sample(BilinearClamp_s, r2.zw).xyz;
      r2.xyz = v2.xxx * r2.xyz;
      r1.w = max(r2.x, r2.y);
      r1.w = max(r1.w, r2.z);
      r2.x = (int)r1.w & 0x7f800000;
      // r2.x = cmp((int)r2.x == 0x7f800000);
      r2.x = cmp((uint)r2.x == 0x7f800000);
      if (r2.x != 0) {
        r4.y = 1;
      }
      if (r2.x == 0) {
        r1.w = r1.w * tonemapRange + 1;
        r4.y = r2.y / r1.w;
      }
      r1.xyw = SourceImage.Sample(BilinearClamp_s, r1.xy).xyz;
      r1.xyw = v2.xxx * r1.xyw;
      r1.x = max(r1.x, r1.y);
      r1.x = max(r1.x, r1.w);
      r1.y = (int)r1.x & 0x7f800000;
      // r1.y = cmp((int)r1.y == 0x7f800000);
      r1.y = cmp((uint)r1.y == 0x7f800000);
      if (r1.y != 0) {
        r4.z = 1;
      }
      if (r1.y == 0) {
        r1.x = r1.x * tonemapRange + 1;
        r4.z = r1.w / r1.x;
      }
    }
    r1.x = fDistortionCoef;
  } else {
    r2.xy = (uint2)v0.xy;
    r2.zw = float2(0, 0);
    r2.xyz = SourceImage.Load(r2.xyz).xyz;
    r2.xyz = v2.xxx * r2.xyz;
    r1.y = max(r2.x, r2.y);
    r1.y = max(r1.y, r2.z);
    r1.w = (int)r1.y & 0x7f800000;
    // r1.w = cmp((int)r1.w == 0x7f800000);
    r1.w = cmp((uint)r1.w == 0x7f800000);
    if (r1.w != 0) {
      r4.xyz = float3(1, 1, 1);
    }
    if (r1.w == 0) {
      r1.y = r1.y * tonemapRange + 1;
      r4.xyz = r2.xyz / r1.yyy;
    }
    r1.xz = float2(0, 1);
  }
  if (r0.y != 0) {
    r0.y = asint(cbRadialBlurFlags) & 2;
    r1.yw = r0.yy ? float2(1, 0) : float2(0, 1);
    r0.y = ComputeResultSRV[0].computeAlpha;
    r0.y = r0.y * r1.y + r1.w;
    r0.y = cbRadialColor.w * r0.y;
    r1.y = cmp(r0.y == 0.000000);
    if (r1.y != 0) {
      r2.xyz = r4.xyz;
    }
    if (r1.y == 0) {
      r0.x = r0.x ? 1 : 0;
      r1.yw = screenInverseSize.xy * v0.xy;
      r3.xy = v0.xy * screenInverseSize.xy + float2(-0.5, -0.5);
      r3.xy = -cbRadialScreenPos.xy + r3.xy;
      r3.zw = cmp(r3.xy < float2(0, 0));
      r5.xy = -v0.xy * screenInverseSize.xy + float2(1, 1);
      r1.yw = r3.zw ? r5.xy : r1.yw;
      r2.w = asint(cbRadialBlurFlags) & 1;
      r3.z = dot(r3.xy, r3.xy);
      r3.w = rsqrt(r3.z);
      r5.xy = r3.xy * r3.ww;
      r5.xy = cbRadialSharpRange * r5.xy;
      // r5.xy = (uint3)abs(r5.xy);
      r5.xy = abs(r5.xy);
      r3.w = (int)r5.y + (int)r5.x;
      r4.w = (int)r3.w ^ 61;
      r3.w = (uint)r3.w >> 16;
      r3.w = (int)r3.w ^ (int)r4.w;
      r3.w = (int)r3.w * 9;
      r4.w = (uint)r3.w >> 4;
      r3.w = (int)r3.w ^ (int)r4.w;
      r3.w = (int)r3.w * 0x27d4eb2d;
      r4.w = (uint)r3.w >> 15;
      r3.w = (int)r3.w ^ (int)r4.w;
      r3.w = (uint)r3.w;
      r3.w = 2.32830644e-010 * r3.w;
      r2.w = r2.w ? r3.w : 1;
      if (r0.x != 0) {
        r0.x = sqrt(r3.z);
        r0.x = max(1, r0.x);
        r0.x = 1 / r0.x;
        r5.xy = -cbRadialBlurPower * r1.yw;
        r5.xy = r5.xy * r0.xx;
        r5.xy = r5.xy * r2.ww;
        r6.xyzw = r5.xyxy * float4(0.00111111114, 0.00111111114, 0.00999999978, 0.00999999978) + float4(1, 1, 1, 1);
        r6.xyzw = r3.xyxy * r6.xyzw + cbRadialScreenPos.xyxy;
        r0.x = dot(r6.xy, r6.xy);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r6.xy * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r7.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r8.xyzw = r5.xyxy * float4(0.00222222228, 0.00222222228, 0.00333333341, 0.00333333341) + float4(1, 1, 1, 1);
        r8.xyzw = r3.xyxy * r8.xyzw + cbRadialScreenPos.xyxy;
        r0.x = dot(r8.xy, r8.xy);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r8.xy * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r9.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r9.xyz = float3(0.100000001, 0.100000001, 0.100000001) * r9.xyz;
        r7.xyz = r7.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r9.xyz;
        r0.x = dot(r8.zw, r8.zw);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r8.zw * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r8.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r7.xyz = r8.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r8.xyzw = r5.xyxy * float4(0.00444444455, 0.00444444455, 0.00555555569, 0.00555555569) + float4(1, 1, 1, 1);
        r8.xyzw = r3.xyxy * r8.xyzw + cbRadialScreenPos.xyxy;
        r0.x = dot(r8.xy, r8.xy);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r8.xy * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r9.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r7.xyz = r9.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r0.x = dot(r8.zw, r8.zw);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r8.zw * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r8.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r7.xyz = r8.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r8.xyzw = r5.xyxy * float4(0.00666666683, 0.00666666683, 0.00777777797, 0.00777777797) + float4(1, 1, 1, 1);
        r8.xyzw = r3.xyxy * r8.xyzw + cbRadialScreenPos.xyxy;
        r0.x = dot(r8.xy, r8.xy);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r8.xy * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r9.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r7.xyz = r9.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r0.x = dot(r8.zw, r8.zw);
        r0.x = r1.x * r0.x + 1;
        r5.zw = r8.zw * r0.xx;
        r5.zw = r5.zw * r1.zz + float2(0.5, 0.5);
        r8.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.zw, 0).xyz;
        r7.xyz = r8.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r5.xy = r5.xy * float2(0.0088888891, 0.0088888891) + float2(1, 1);
        r5.xy = r3.xy * r5.xy + cbRadialScreenPos.xy;
        r0.x = dot(r5.xy, r5.xy);
        r0.x = r1.x * r0.x + 1;
        r5.xy = r5.xy * r0.xx;
        r5.xy = r5.xy * r1.zz + float2(0.5, 0.5);
        r5.xyz = SourceImage.SampleLevel(BilinearClamp_s, r5.xy, 0).xyz;
        r5.xyz = r5.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r0.x = dot(r6.zw, r6.zw);
        r0.x = r1.x * r0.x + 1;
        r6.xy = r6.zw * r0.xx;
        r1.xz = r6.xy * r1.zz + float2(0.5, 0.5);
        r6.xyz = SourceImage.SampleLevel(BilinearClamp_s, r1.xz, 0).xyz;
        r5.xyz = r6.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r5.xyz;
        r5.xyz = cbRadialColor.xyz * r5.xyz;
        r5.xyz = v2.xxx * r5.xyz;
        r0.x = max(r5.x, r5.y);
        r0.x = max(r0.x, r5.z);
        r1.x = (int)r0.x & 0x7f800000;
        r1.x = cmp((int)r1.x == 0x7f800000);
        if (r1.x != 0) {
          r6.xyz = float3(1, 1, 1);
        }
        if (r1.x == 0) {
          r0.x = r0.x * tonemapRange + 1;
          r6.xyz = r5.xyz / r0.xxx;
        }
        r5.xyz = cbRadialColor.xyz * r4.xyz;
        r5.xyz = r5.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r6.xyz;
      } else {
        r0.x = sqrt(r3.z);
        r0.x = max(1, r0.x);
        r0.x = 1 / r0.x;
        r1.xy = -cbRadialBlurPower * r1.yw;
        r1.xy = r1.xy * r0.xx;
        r1.xy = r1.xy * r2.ww;
        r6.xyzw = r1.xyxy * float4(0.00111111114, 0.00111111114, 0.00999999978, 0.00999999978) + float4(1, 1, 1, 1);
        r6.xyzw = r3.xyxy * r6.xyzw + cbRadialScreenPos.xyxy;
        r6.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r6.xyzw;
        r7.xyz = SourceImage.SampleLevel(BilinearClamp_s, r6.xy, 0).xyz;
        r8.xyzw = r1.xyxy * float4(0.00222222228, 0.00222222228, 0.00333333341, 0.00333333341) + float4(1, 1, 1, 1);
        r8.xyzw = r3.xyxy * r8.xyzw + cbRadialScreenPos.xyxy;
        r8.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r8.xyzw;
        r9.xyz = SourceImage.SampleLevel(BilinearClamp_s, r8.xy, 0).xyz;
        r9.xyz = float3(0.100000001, 0.100000001, 0.100000001) * r9.xyz;
        r7.xyz = r7.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r9.xyz;
        r8.xyz = SourceImage.SampleLevel(BilinearClamp_s, r8.zw, 0).xyz;
        r7.xyz = r8.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r8.xyzw = r1.xyxy * float4(0.00444444455, 0.00444444455, 0.00555555569, 0.00555555569) + float4(1, 1, 1, 1);
        r8.xyzw = r3.xyxy * r8.xyzw + cbRadialScreenPos.xyxy;
        r8.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r8.xyzw;
        r9.xyz = SourceImage.SampleLevel(BilinearClamp_s, r8.xy, 0).xyz;
        r7.xyz = r9.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r8.xyz = SourceImage.SampleLevel(BilinearClamp_s, r8.zw, 0).xyz;
        r7.xyz = r8.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r8.xyzw = r1.xyxy * float4(0.00666666683, 0.00666666683, 0.00777777797, 0.00777777797) + float4(1, 1, 1, 1);
        r8.xyzw = r3.xyxy * r8.xyzw + cbRadialScreenPos.xyxy;
        r8.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r8.xyzw;
        r9.xyz = SourceImage.SampleLevel(BilinearClamp_s, r8.xy, 0).xyz;
        r7.xyz = r9.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r8.xyz = SourceImage.SampleLevel(BilinearClamp_s, r8.zw, 0).xyz;
        r7.xyz = r8.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r1.xy = r1.xy * float2(0.0088888891, 0.0088888891) + float2(1, 1);
        r1.xy = r3.xy * r1.xy + cbRadialScreenPos.xy;
        r1.xy = float2(0.5, 0.5) + r1.xy;
        r1.xyz = SourceImage.SampleLevel(BilinearClamp_s, r1.xy, 0).xyz;
        r1.xyz = r1.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r7.xyz;
        r3.xyw = SourceImage.SampleLevel(BilinearClamp_s, r6.zw, 0).xyz;
        r1.xyz = r3.xyw * float3(0.100000001, 0.100000001, 0.100000001) + r1.xyz;
        r1.xyz = cbRadialColor.xyz * r1.xyz;
        r1.xyz = v2.xxx * r1.xyz;
        r0.x = max(r1.x, r1.y);
        r0.x = max(r0.x, r1.z);
        r1.w = (int)r0.x & 0x7f800000;
        r1.w = cmp((int)r1.w == 0x7f800000);
        if (r1.w != 0) {
          r3.xyw = float3(1, 1, 1);
        }
        if (r1.w == 0) {
          r0.x = r0.x * tonemapRange + 1;
          r3.xyw = r1.xyz / r0.xxx;
        }
        r1.xyz = cbRadialColor.xyz * r4.xyz;
        r5.xyz = r1.xyz * float3(0.100000001, 0.100000001, 0.100000001) + r3.xyw;
      }
      r0.x = cmp(0 < cbRadialMaskRate.x);
      if (r0.x != 0) {
        r0.x = sqrt(r3.z);
        r0.x = saturate(r0.x * cbRadialMaskSmoothstep.x + cbRadialMaskSmoothstep.y);
        r1.x = r0.x * r0.x;
        r0.x = -r0.x * 2 + 3;
        r0.x = r1.x * r0.x;
        r0.x = cbRadialMaskRate.x * r0.x + cbRadialMaskRate.y;
        r1.xyz = r5.xyz + -r4.xyz;
        r5.xyz = r0.xxx * r1.xyz + r4.xyz;
      }
      r1.xyz = r5.xyz + -r4.xyz;
      r4.xyz = r0.yyy * r1.xyz + r4.xyz;
    } else {
      r4.xyz = r2.xyz;
    }
  }
  r1.xyz = v1.xyz / v1.www;
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = rsqrt(r0.x);
  r0.x = r1.z * r0.x;
  r0.y = saturate(abs(r0.x) * kerare_scale + kerare_offset);
  r0.y = 1 + -r0.y;
  r0.x = abs(r0.x) * abs(r0.x);
  r0.x = r0.x * r0.x;
  r0.x = r0.x * r0.y;
  r0.x = min(1, r0.x);
  r1.xyz = r4.xyz * r0.xxx;
  if (r0.z != 0) {
    r0.yz = fNoiseUVOffset.xy * screenSize.xy + v0.xy;
    r0.yz = fReverseNoiseSize * r0.yz;
    r0.yz = floor(r0.yz);
    r1.w = dot(r0.yz, float2(0.0671105608, 0.00583714992));
    r1.w = frac(r1.w);
    r1.w = 52.9829178 * r1.w;
    r1.w = frac(r1.w);
    r2.x = cmp(r1.w < fNoiseDensity);
    if (r2.x != 0) {
      r0.y = r0.y * r0.z;
      r0.y = (uint)r0.y;
      r0.y = (int)r0.y ^ 0x00bc602f;
      r0.y = (int)r0.y * 0x003779b9;
      r0.z = (uint)r0.y << 6;
      r2.x = (uint)r0.y >> 26;
      r0.y = (int)r0.y ^ (int)r0.z;
      r0.y = (int)r0.y ^ (int)r2.x;
      r0.y = (uint)r0.y;
      r0.y = 2.32830644e-010 * r0.y;
    } else {
      r0.y = 0;
    }
    r0.z = 757.48468 * r1.w;
    r0.z = frac(r0.z);
    r1.w = cmp(r0.z < fNoiseDensity);
    if (r1.w != 0) {
      r1.w = (int)r0.z ^ 0x00bc602f;
      r1.w = (int)r1.w * 0x003779b9;
      r2.x = (uint)r1.w << 6;
      r2.y = (uint)r1.w >> 26;
      r1.w = (int)r1.w ^ (int)r2.x;
      r1.w = (int)r1.w ^ (int)r2.y;
      r1.w = (uint)r1.w;
      r1.w = r1.w * 2.32830644e-010 + -0.5;
    } else {
      r1.w = 0;
    }
    r0.z = 757.48468 * r0.z;
    r0.z = frac(r0.z);
    r2.x = cmp(r0.z < fNoiseDensity);
    if (r2.x != 0) {
      r0.z = (int)r0.z ^ 0x00bc602f;
      r0.z = (int)r0.z * 0x003779b9;
      r2.x = (uint)r0.z << 6;
      r2.y = (uint)r0.z >> 26;
      r0.z = (int)r0.z ^ (int)r2.x;
      r0.z = (int)r0.z ^ (int)r2.y;
      r0.z = (uint)r0.z;
      r0.z = r0.z * 2.32830644e-010 + -0.5;
    } else {
      r0.z = 0;
    }
    r2.xy = fNoisePower.xy * r0.yz;
    r2.z = fNoisePower.y * r1.w;
    r3.x = dot(r2.xz, float2(1, 1.40199995));
    r3.y = dot(r2.xyz, float3(1, -0.344000012, -0.713999987));
    r3.z = dot(r2.xy, float2(1, 1.77199996));
    r0.y = saturate(dot(r1.xyz, float3(0.298999995, -0.169, 0.5)));
    r0.y = 1 + -r0.y;
    r0.y = log2(r0.y);
    r0.y = fNoiseContrast * r0.y;
    r0.y = exp2(r0.y);
    r0.y = fBlendRate * r0.y;
    r2.xyz = -r4.xyz * r0.xxx + r3.xyz;
    r1.xyz = r0.yyy * r2.xyz + r1.xyz;
  }
  if (r0.w != 0) {
    r0.x = max(r1.x, r1.y);
    r0.x = max(r0.x, r1.z);
    r0.y = cmp(1 < r0.x);
#if 0
    if (r0.y != 0) {
      r1.xyz = r1.xyz / r0.xxx;
    }
#else
    untonemapped = r1.xyz;
    hdrColor = untonemapped;

    sdrColor = renoDRTSmoothClamp(untonemapped);  // use neutral RenoDRT as a smoothclamp
    r1.xyz = sdrColor;
#endif
#if 0
    r0.z = 0.5 * fTextureInverseSize;
    r0.w = cmp(0.00313080009 >= r1.x);
    r1.w = 12.9200001 * r1.x;
    r2.x = log2(r1.x);
    r2.x = 0.416666657 * r2.x;
    r2.x = exp2(r2.x);
    r2.x = r2.x * 1.05499995 + -0.0549999997;
    r2.x = r0.w ? r1.w : r2.x;
    r0.w = cmp(0.00313080009 >= r1.y);
    r1.w = 12.9200001 * r1.y;
    r2.w = log2(r1.y);
    r2.w = 0.416666657 * r2.w;
    r2.w = exp2(r2.w);
    r2.w = r2.w * 1.05499995 + -0.0549999997;
    r2.y = r0.w ? r1.w : r2.w;
    r0.w = cmp(0.00313080009 >= r1.z);
    r1.w = 12.9200001 * r1.z;
    r2.w = log2(r1.z);
    r2.w = 0.416666657 * r2.w;
    r2.w = exp2(r2.w);
    r2.w = r2.w * 1.05499995 + -0.0549999997;
    r2.z = r0.w ? r1.w : r2.w;
    r0.w = 1 + -fTextureInverseSize;
    r2.xyz = r2.xyz * r0.www + r0.zzz;
    r3.xyz = tTextureMap0.SampleLevel(TrilinearClamp_s, r2.xyz, 0).xyz;
#else
    r3.xyz = LUTBlackCorrection(r1.xyz, tTextureMap0, lut_config);
#endif
    r0.z = cmp(0 < fTextureBlendRate);
    if (r0.z != 0) {
#if 0
      r4.xyz = tTextureMap1.SampleLevel(TrilinearClamp_s, r2.xyz, 0).xyz;
#else
      r4.xyz = LUTBlackCorrection(r1.xyz, tTextureMap1, lut_config);
#endif
      r4.xyz = r4.xyz + -r3.xyz;
      r4.xyz = fTextureBlendRate * r4.xyz + r3.xyz;
      r0.z = cmp(0 < fTextureBlendRate2);
      if (r0.z != 0) {
#if 0
        r5.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r4.xyz);
        r6.xyz = float3(12.9200001,12.9200001,12.9200001) * r4.xyz;
        r7.xyz = log2(r4.xyz);
        r7.xyz = float3(0.416666657,0.416666657,0.416666657) * r7.xyz;
        r7.xyz = exp2(r7.xyz);
        r7.xyz = r7.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
        r5.xyz = r5.xyz ? r6.xyz : r7.xyz;
        r5.xyz = tTextureMap2.SampleLevel(TrilinearClamp_s, r5.xyz, 0).xyz;
#else
        r5.xyz = LUTBlackCorrection(r4.xyz, tTextureMap2, lut_config);
#endif
        r5.xyz = r5.xyz + -r4.xyz;
        r4.xyz = fTextureBlendRate2 * r5.xyz + r4.xyz;
      }
    } else {
#if 0
      r5.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r3.xyz);
      r6.xyz = float3(12.9200001,12.9200001,12.9200001) * r3.xyz;
      r7.xyz = log2(r3.xyz);
      r7.xyz = float3(0.416666657,0.416666657,0.416666657) * r7.xyz;
      r7.xyz = exp2(r7.xyz);
      r7.xyz = r7.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
      r5.xyz = r5.xyz ? r6.xyz : r7.xyz;
      r5.xyz = tTextureMap2.SampleLevel(TrilinearClamp_s, r5.xyz, 0).xyz;
#else
      r5.xyz = LUTBlackCorrection(r3.xyz, tTextureMap2, lut_config);
#endif
      r5.xyz = r5.xyz + -r3.xyz;
      r4.xyz = fTextureBlendRate2 * r5.xyz + r3.xyz;
    }
    r3.xyz = fColorMatrix._m10_m11_m12 * r4.yyy;
    r3.xyz = r4.xxx * fColorMatrix._m00_m01_m02 + r3.xyz;
    r3.xyz = r4.zzz * fColorMatrix._m20_m21_m22 + r3.xyz;
    r1.xyz = fColorMatrix._m30_m31_m32 + r3.xyz;
#if 0
    if (r0.y != 0) {
      r0.y = 0.100000001 * r0.x;
      r0.y = min(1, r0.y);
      r2.xyz = r2.xyz + -r1.xyz;
      r0.yzw = r0.yyy * r2.xyz + r1.xyz;
      r1.xyz = r0.yzw * r0.xxx;
    }
#else
    float3 postProcessColor = r1.xyz;
    r1.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postProcessColor, 1.f);
#endif
  }
  r0.xy = cPassEnabled & int2(8, 16);
  if (r0.x != 0) {
    r2.x = saturate(dot(r1.xyz, cvdR.xyz));
    r2.y = saturate(dot(r1.xyz, cvdG.xyz));
    r2.z = saturate(dot(r1.xyz, cvdB.xyz));
    r1.xyz = r2.xyz;
  }
  if (r0.y != 0) {
    r0.xy = screenInverseSize.xy * v0.xy;
    r2.xyzw = ImagePlameBase.SampleLevel(BilinearClamp_s, r0.xy, 0).xyzw;
    r3.xyzw = ColorParam.xyzw * r2.xyzw;
    r0.x = ImagePlameAlpha.SampleLevel(BilinearClamp_s, r0.xy, 0).x;
    r0.x = saturate(r0.x * Levels_Rate + Levels_Range);
    r0.x = r0.x * r3.w;
    r0.yzw = cmp(r3.xyz < float3(0.5, 0.5, 0.5));
    r3.xyz = r3.xyz * r1.xyz;
    r3.xyz = r3.xyz + r3.xyz;
    r2.xyz = -r2.xyz * ColorParam.xyz + float3(1, 1, 1);
    r2.xyz = r2.xyz + r2.xyz;
    r4.xyz = float3(1, 1, 1) + -r1.xyz;
    r2.xyz = -r2.xyz * r4.xyz + float3(1, 1, 1);
    r0.yzw = r0.yzw ? r3.xyz : r2.xyz;
    r0.yzw = r0.yzw + -r1.xyz;
    r1.xyz = r0.xxx * r0.yzw + r1.xyz;
  }
  o0.xyz = r1.xyz;
  o0.w = 0;
  return;
}
