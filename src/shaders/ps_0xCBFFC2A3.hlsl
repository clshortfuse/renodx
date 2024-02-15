// Final output shader

#include "../common/color.hlsl"
#include "../cp2077/cp2077.h"

// [476 x i8]
// 4 * 10 + 3 + 1 + 34 + 1 + 1 + (4*6) + 4 + 2 + 2 + 1 + 2
struct GlobalShaderConstsType {
  float4 const00;  //  _43_m0[0u].xyzw // EngineSeconds / 1.0 / Seconds / ??
  float4 const01;  //  _43_m0[1u].xyzw
  float4 const02;  //  _43_m0[2u].xyzw
  float4 const03;  //  _43_m0[3u].xyzw
  float4 const04;  //  _43_m0[4u].xyzw
  float4 const05;  //  _43_m0[5u].xyzw
  float4 const06;  //  _43_m0[6u].xyzw
  float4 const07;  //  _43_m0[7u].xyzw
  float4 const08;  //  _43_m0[8u].xyzw
  float4 const09;  //  _43_m0[9u].xyzw
  float4 const10;  // _43_m0[10u].xyzw
  float const11;   // _43_m0[11u].x
  float const12;   // _43_m0[11u].y
  float const13;   // _43_m0[11u].z
  int const14;     // _43_m0[11u].w
  float const15;   // _43_m0[12u].x
  float const16;   // _43_m0[12u].y
  float const17;   // _43_m0[12u].z
  float const18;   // _43_m0[12u].w
  float const19;   // _43_m0[13u].x
  float const20;   // _43_m0[13u].y
  float const21;   // _43_m0[13u].z
  float const22;   // _43_m0[13u].w
  float const23;   // _43_m0[14u].x
  float const24;   // _43_m0[14u].y
  float const25;   // _43_m0[14u].z
  float const26;   // _43_m0[14u].w
  float const27;   // _43_m0[15u].x
  float const28;   // _43_m0[15u].y
  float const29;   // _43_m0[15u].z
  float const30;   // _43_m0[15u].w
  float const31;   // _43_m0[16u].x
  float const32;   // _43_m0[16u].y
  float const33;   // _43_m0[16u].z
  float const34;   // _43_m0[16u].w
  float const35;   // _43_m0[17u].x
  float const36;   // _43_m0[17u].y
  float const37;   // _43_m0[17u].z
  float const38;   // _43_m0[17u].w
  float const39;   // _43_m0[18u].x
  float const40;   // _43_m0[18u].y
  float const41;   // _43_m0[18u].z
  float const42;   // _43_m0[18u].w
  float const43;   // _43_m0[19u].x
  float const44;   // _43_m0[19u].y
  float const45;   // _43_m0[19u].z
  float const46;   // _43_m0[19u].w
  float const47;   // _43_m0[20u].x
  float const48;   // _43_m0[20u].y
  int const49;     // _43_m0[20u].z
  float const50;   // _43_m0[20u].w
  float4 const51
    [6];           // _43_m0[21u].xyzw  _43_m0[22u].xyzw _43_m0[23u].xyzw _43_m0[24u].xyzw _43_m0[25u].xyzw _43_m0[26u].xyzw
  float4 const52;  // _43_m0[27u].xyzw
  int2 const53;    // _43_m0[28u].xy
  int const54;     // _43_m0[28u].z
  int const55;     // _43_m0[28u].w
  float const56;   // _43_m0[29u].x
  int const57;     // _43_m0[29u].y
  int const58;     // _43_m0[29u].z
};

struct PIXType {
  int outputTypeEnum;       // _20_m0[0u].x
  float paperWhiteScaling;  // _20_m0[0u].y
  float blackFloorAdjust;   // _20_m0[0u].z  // 1.25 always?
  float gammaCorrection;    // _20_m0[0u].w
  float pqSaturation;       // _20_m0[1u].x
  float3 const05;           // _20_m0[1u].yxw
  float3x4 pqMatrix;        // _20_m0[2u].xyzw _20_m0[3u].xyzw _20_m0[4u].xyzw
};

cbuffer injectedBuffer : register(b14, space0) {
  ShaderInjectData injectedData : packoffset(c0);
}

cbuffer GlobalShaderConsts : register(b0, space0) {
  GlobalShaderConstsType shaderConsts : packoffset(c0);
}

cbuffer PIX : register(b6, space0) {
  PIXType pixConsts : packoffset(c0);
}

struct PSSceneIn {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

Texture2D<float4> _8 : register(t0, space0);

static const uint OUTPUT_TYPE_SRGB8 = 0u;
static const uint OUTPUT_TYPE_PQ = 1u;
static const uint OUTPUT_TYPE_SCRGB = 2u;
static const uint OUTPUT_TYPE_SRGB10 = 3u;

// Maybe dithering?
float3 srgbPostProcess(float3 srgb, float3 a, float3 b, float bits = 8.f) {
  float maxValue = pow(2.f, bits) - 1.f;
  float maxValueX2 = maxValue * 2.f;
  return srgb + (((a - 0.5f) + (min(min(1.0f, srgb * maxValueX2), maxValueX2 - (srgb * maxValueX2)) * (b - 0.5f))) / maxValue);
}

float4 main(PSSceneIn input) : SV_TARGET {
  float4 gl_FragCoord = input.gl_FragCoord;
  float2 TEXCOORD = input.TEXCOORD;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;

  const float4 inputColor = _8.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));

  // float3 clampedColor = max(0.f, inputColor.rgb);
  float3 clampedColor = inputColor.rgb;

  float3 correctedColor = (pixConsts.gammaCorrection != 1.0f)
                          ? pow(clampedColor, pixConsts.gammaCorrection)
                          : clampedColor;

  const float PAPERWHITE_NITS = pixConsts.paperWhiteScaling / 80.f;

  const float paperWhiteScaling = pixConsts.paperWhiteScaling * (injectedData.debugValue00 - injectedData.debugValue00);

  // Dithering for sRGB?
  // TODO: Don't sample when in HDR
  float _112 = frac(TEXCOORD.x * 211.1488037109375f);
  float _113 = frac(TEXCOORD.y * 210.944000244140625f);
  float _114 = frac(shaderConsts.const00.x * 6.227200031280517578125f);
  float _118 = _114 + 33.3300018310546875f;
  float _119 = dot(float3(_112, _113, _114), float3(_113 + 33.3300018310546875f, _112 + 33.3300018310546875f, _118));
  float _123 = _119 + _112;
  float _124 = _119 + _113;
  float _126 = _123 + _124;
  float _132 = frac(_126 * (_119 + _114));
  float _133 = frac((_123 * 2.0f) * _124);
  float _134 = frac(_126 * _123);

  float3 minSRGB = float3(_132, _133, _134);

  float _140 = frac((TEXCOORD.x + 64.0f) * 211.1488037109375f);
  float _141 = frac((TEXCOORD.y + 64.0f) * 210.944000244140625f);
  float _144 = dot(float3(_140, _141, _114), float3(_141 + 33.3300018310546875f, _140 + 33.3300018310546875f, _118));
  float _147 = _144 + _140;
  float _148 = _144 + _141;
  float _150 = _147 + _148;
  float _155 = frac(_150 * (_144 + _114));
  float _156 = frac((_147 * 2.0f) * _148);
  float _157 = frac(_150 * _147);

  float3 maxSRGB = float3(_155, _156, _157);

  // clang-format off
  const float3x3 rgbColorMatrix = float3x3(
    pixConsts.pqMatrix[0][0], pixConsts.pqMatrix[1][0], pixConsts.pqMatrix[2][0],
    pixConsts.pqMatrix[0][1], pixConsts.pqMatrix[1][1], pixConsts.pqMatrix[2][1],
    pixConsts.pqMatrix[0][2], pixConsts.pqMatrix[1][2], pixConsts.pqMatrix[2][2]);
  // clang-format on

  float3 outputColor;
  switch (pixConsts.outputTypeEnum) {
    case OUTPUT_TYPE_SRGB8:
      {
        float3 srgbColor = srgbFromLinear(correctedColor);

        float3 postProcessedSRGB = srgbPostProcess(srgbColor.rgb, minSRGB, maxSRGB, 8.f);
        outputColor.rgb = postProcessedSRGB.rgb;
      }
      break;
    case OUTPUT_TYPE_PQ:
      {
        float3 rec2020 = REC709toREC2020(inputColor.rgb);
        float3 matrixedColor = saturate(mul(rgbColorMatrix, rec2020));
        float3 newShiftedColor = ((matrixedColor - rec2020) * pixConsts.pqSaturation) + rec2020;
        float3 scaledShifted = newShiftedColor * paperWhiteScaling;

        float3 pqColor = Linear_to_PQ(rec2020);

        outputColor.rgb = pqColor.rgb;
      }
      break;
    case OUTPUT_TYPE_SCRGB:
      outputColor.rgb = correctedColor.rgb * paperWhiteScaling;
      break;
    case OUTPUT_TYPE_SRGB10:
      {
        float3 matrixedColor = mul(rgbColorMatrix, correctedColor);
        float3 scaledColor = matrixedColor * paperWhiteScaling;

        float3 srgbColor = srgbFromLinear(scaledColor);

        float3 postProcessedSRGB = srgbPostProcess(srgbColor.rgb, minSRGB, maxSRGB, 10.f);
        outputColor.rgb = postProcessedSRGB.rgb;
      }
      break;
    default:
      // Unknown default case
      outputColor.rgb = (correctedColor.rgb * paperWhiteScaling) + pixConsts.blackFloorAdjust;
  }

#if 0
  // if (TEXCOORD.x > 0.75f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const00.x;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const00.y;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const00.z;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const00.w;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const01.x;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const01.y;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const01.z;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const01.w;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const02.x;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const02.y;
  // }
  // if (TEXCOORD.x > 0.80f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const02.z;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const02.w;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const03.x;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const03.y;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const03.z;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const03.w;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const04.x;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const04.y;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const04.z;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const04.w;
  // }
  // if (TEXCOORD.x > 0.85f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const05.x;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const05.y;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const05.z;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const05.w;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const06.x;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const06.y;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const06.z;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const06.w;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const07.x;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const07.y;
  // }
  // if (TEXCOORD.x > 0.90f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const07.z;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const07.w;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const08.x;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const08.y;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const08.z;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const08.w;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const09.x;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const09.y;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const09.z;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const09.w;
  // }
  // if (TEXCOORD.x > 0.95f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const10.x;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const10.y;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const10.z;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const10.w;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const11;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const12;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const13;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const14;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const15;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const16;
  // }
  // if (TEXCOORD.x > 0.75f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const17;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const18;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const19;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const20;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const21;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const22;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const23;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const24;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const25;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const26;
  // }
  // if (TEXCOORD.x > 0.80f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const27;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const28;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const29;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const30;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const31;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const32;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const33;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const34;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const35;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const36;
  // }
  // if (TEXCOORD.x > 0.85f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const37;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const38;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const39;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const40;
  //     else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const41;
  //     else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const42;
  //     else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const43;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const44;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const45;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const46;
  // }
  // if (TEXCOORD.x > 0.90f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const47;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const48;
  //     else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const49;
  //     else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const50;
  //     // else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const51;
  //     // else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const52;
  //     // else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const53;
  //     else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const54;
  //     else if (TEXCOORD.y < 0.9f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const55;
  //     else                        outputColor.rgb = (100.f / 80.f) * shaderConsts.const56;
  // }
  // if (TEXCOORD.x > 0.95f) {
  //          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const57;
  //     else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const58;
  // }
  if (TEXCOORD.x > 0.95f) {
          if (TEXCOORD.y < 0.1f) outputColor.rgb = (100.f / 80.f) * shaderConsts.const00.x;
    else if (TEXCOORD.y < 0.2f) outputColor.rgb = (100.f / 80.f) * pixConsts.paperWhiteScaling;
    else if (TEXCOORD.y < 0.3f) outputColor.rgb = (100.f / 80.f) * pixConsts.blackFloorAdjust;
    else if (TEXCOORD.y < 0.4f) outputColor.rgb = (100.f / 80.f) * pixConsts.gammaCorrection;
    else if (TEXCOORD.y < 0.5f) outputColor.rgb = (100.f / 80.f) * pixConsts.pqSaturation;
    else if (TEXCOORD.y < 0.6f) outputColor.rgb = (100.f / 80.f) * pixConsts.const05.x;
    else if (TEXCOORD.y < 0.7f) outputColor.rgb = (100.f / 80.f) * pixConsts.const05.y;
    else if (TEXCOORD.y < 0.8f) outputColor.rgb = (100.f / 80.f) * pixConsts.const05.z;
  }
#endif
  return float4(outputColor.rgb, 1.f);
}
