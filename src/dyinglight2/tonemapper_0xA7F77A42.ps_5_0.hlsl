#include "../common/ACES.hlsl"
#include "../common/RenoDRT.hlsl"
#include "../common/color.hlsl"
#include "../common/colorgrade.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture3D<float4> lutTexture : register(t1);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[2];
}

cbuffer cb6 : register(b6) {
  ShaderInjectData injectedData : packoffset(c0);
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : TEXCOORD0, float4 v2 : TEXCOORD1, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3;

  r0.x = -1000 + cb0[1].y;
  r0.x = saturate(-0.00100000005 * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.y = cmp(6500 >= cb0[1].y);
  r1.xyz = r0.yyy ? float3(0, 1669.58032, 2575.28271) : float3(-2666.34741, -2173.10132, 2575.28271);
  r1.xyz = cb0[1].yyy + r1.xyz;
  r2.xyz = r0.yyy ? float3(0, -2902.19556, -8257.7998) : float3(1745.04248, 1216.61682, -8257.7998);
  r0.yzw = r0.yyy ? float3(1, 1.33026743, 1.89937544) : float3(0.509953916, 0.703812003, 1.89937544);
  r1.xyz = r2.xyz / r1.xyz;
  r0.yzw = saturate(r1.xyz + r0.yzw);
  r1.xyz = float3(1, 1, 1) + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  r1.xy = -abs(v2.zw) * abs(v2.zw) + float2(1, 1);
  r0.w = saturate(-r1.x * r1.y + 1);
  r0.w = r0.w * 1.5 + -0.5;
  r0.w = max(0, r0.w);
  r1.xyzw = -v2.xyxy + v1.xyzw;
  r1.xyzw = r0.wwww * r1.xyzw + v2.xyxy;
  r2.x = t0.SampleLevel(s0_s, r1.xy, 0).x;
  r2.z = t0.SampleLevel(s0_s, r1.zw, 0).z;
  r1.xy = (uint2)v0.xy;
  r1.zw = float2(0, 0);
  r2.y = t0.Load(r1.xyz).y;

  const float3 untonemapped = r2.xyz;

  r1.xyz = log2(abs(r2.xyz));
  r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
  r3.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r2.xyz;
  r2.xyz = cmp(float3(0.00313080009, 0.00313080009, 0.00313080009) >= r2.xyz);
  r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
  r1.xyz = r1.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
  r1.xyz = lutTexture.SampleLevel(s1_s, r1.xyz, 0).xyz;
  const float3 texture1Color = r1.xyz;

  r2.xyz = r1.xyz * float3(0.947867274, 0.947867274, 0.947867274) + float3(0.0521326996, 0.0521326996, 0.0521326996);
  r2.xyz = log2(abs(r2.xyz));
  r2.xyz = float3(2.4000001, 2.4000001, 2.4000001) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = float3(0.0773993805, 0.0773993805, 0.0773993805) * r1.xyz;
  r1.xyz = cmp(float3(0.0404499993, 0.0404499993, 0.0404499993) >= r1.xyz);
  r1.xyz = r1.xyz ? r3.xyz : r2.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.w = max(9.99999975e-05, r0.w);
  r1.w = dot(r1.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
  r0.w = r1.w / r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = cmp(cb0[1].y != 6500.000000);
  r0.xyz = r0.www ? r0.xyz : r1.xyz;
  r1.xyz = saturate(r0.xyz);
  r2.xyz = r1.xyz * float3(-2, -2, -2) + float3(3, 3, 3);
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r2.xyz * r1.xyz + -r0.xyz;
  r0.xyz = cb0[0].www * r1.xyz + r0.xyz;
  r0.w = saturate(dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[1].xxx * r0.xyz + r0.www;
  r1.xy = cmp(cb0[0].yx < abs(v2.wz));
  r0.w = (int)r1.y | (int)r1.x;
  r1.xyz = r0.www ? float3(0, 0, 0) : r0.xyz;
  r0.w = cmp(0 < cb0[0].z);

  o0.xyz = r0.www ? r1.xyz : r0.xyz;

  o0.w = 1;

  // LUTs seem to have baked SDR cap. Use untonemapped input for luminance
  float3 outputColor = o0.rgb;
  outputColor = max(0, outputColor);
  if (injectedData.toneMapType == 0.f) {
    // outputColor = pow(outputColor, 2.2f);
  } else {
    outputColor = untonemapped.rgb;
    if (injectedData.toneMapType != 1.f) {
      float inputY = yFromBT709(abs(untonemapped));
      float outputY = yFromBT709(outputColor);
      outputY = lerp(inputY, outputY, saturate(inputY));
      outputColor *= (outputY ? inputY / outputY : 1);

      if (injectedData.colorGradeShadows != 1.f) {
        // outputColor = apply_user_shadows(outputColor, injectedData.colorGradeShadows);
      }
      if (injectedData.colorGradeHighlights != 1.f) {
        // outputColor = apply_user_highlights(outputColor, injectedData.colorGradeHighlights);
      }
      if (injectedData.colorGradeContrast != 1.f) {
        float3 workingColor = pow(outputColor / 0.18f, injectedData.colorGradeContrast) * 0.18f;
        // Working in BT709 still
        float workingColorY = yFromBT709(workingColor);
        float outputColorY = yFromBT709(outputColor);
        outputColor *= outputColorY ? workingColorY / outputColorY : 1.f;
      }

      if (injectedData.colorGradeSaturation != 1.f) {
        float3 okLCh = okLChFromBT709(outputColor);
        okLCh[1] *= injectedData.colorGradeSaturation;
        outputColor = max(0, bt709FromOKLCh(okLCh));
      }

      const float vanillaMidGray = 0.18f;
      if (injectedData.toneMapType == 2.f) {
        float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / 0.10);  // ACES mid gray is 10%
        float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
        outputColor = aces_rgc_rrt_odt(
          outputColor,
          0.0001f / (paperWhite / 48.f),
          48.f * hdrScale,
          AP1_2_BT2020_MAT
        );
        outputColor /= 48.f;
        outputColor *= (vanillaMidGray / 0.10);
        outputColor = mul(BT2020_2_BT709_MAT, outputColor);
      } else if (injectedData.toneMapType == 3.f) {
        outputColor = renodrt(
          outputColor,
          injectedData.toneMapPeakNits / injectedData.toneMapGameNits * 100.f,
          0.18f,
          vanillaMidGray * 100.f
        );
        outputColor *= injectedData.toneMapGameNits;
      }
    }
  }

  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  outputColor = sign(outputColor) * pow(abs(outputColor), 1.f / 2.2f);

  o0.rgb = outputColor.rgb;

  return;
}
