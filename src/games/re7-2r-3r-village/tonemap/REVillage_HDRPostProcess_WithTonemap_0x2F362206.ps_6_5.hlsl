#include "../common.hlsli"

cbuffer SceneInfoUBO : register(b0, space0) {
  float4 SceneInfo_m0[33] : packoffset(c0);
};

cbuffer CameraKerareUBO : register(b1, space0) {
  float4 CameraKerare_m0[1] : packoffset(c0);
};
// cbuffer TonemapParam
// {
//   struct TonemapParam
//   {
//       float contrast;                               ; Offset:    0
//       float linearBegin;                            ; Offset:    4
//       float linearLength;                           ; Offset:    8
//       float toe;                                    ; Offset:   12
//       float maxNit;                                 ; Offset:   16
//       float linearStart;                            ; Offset:   20
//       float displayMaxNitSubContrastFactor;         ; Offset:   24
//       float contrastFactor;                         ; Offset:   28
//       float mulLinearStartContrastFactor;           ; Offset:   32
//       float invLinearBegin;                         ; Offset:   36
//       float madLinearStartContrastFactor;           ; Offset:   40
//   } TonemapParam;                                   ; Offset:    0 Size:    44
// }
// cbuffer TonemapParamUBO : register(b2, space0)
// {
//     float4 TonemapParam_m0[3] : packoffset(c0);
// };
cbuffer TonemapParamUBO : register(b2, space0) {
  // First float4
  float contrast;      // TonemapParam_m0[0u].x
  float linearBegin;   // TonemapParam_m0[0u].y
  float linearLength;  // TonemapParam_m0[0u].z
  float toe;           // TonemapParam_m0[0u].w

  // Second float4
  float maxNit;                          // TonemapParam_m0[1u].x
  float linearStart;                     // TonemapParam_m0[1u].y
  float displayMaxNitSubContrastFactor;  // TonemapParam_m0[1u].z
  float contrastFactor;                  // TonemapParam_m0[1u].w

  // Third float4
  float mulLinearStartContrastFactor;  // TonemapParam_m0[2u].x
  float invLinearBegin;                // TonemapParam_m0[2u].y
  float madLinearStartContrastFactor;  // TonemapParam_m0[2u].z
};

cbuffer CBHazeFilterParamsUBO : register(b3, space0) {
  float4 CBHazeFilterParams_m0[7] : packoffset(c0);
};

cbuffer LensDistortionParamUBO : register(b4, space0) {
  float4 LensDistortionParam_m0[2] : packoffset(c0);
};

cbuffer PaniniProjectionParamUBO : register(b5, space0) {
  float4 PaniniProjectionParam_m0[1] : packoffset(c0);
};

cbuffer RadialBlurRenderParamUBO : register(b6, space0) {
  float4 RadialBlurRenderParam_m0[4] : packoffset(c0);
};

cbuffer FilmGrainParamUBO : register(b7, space0) {
  float4 FilmGrainParam_m0[2] : packoffset(c0);
};

cbuffer ColorCorrectTextureUBO : register(b8, space0) {
  float4 ColorCorrectTexture_m0[5] : packoffset(c0);
};

cbuffer ColorDeficientTableUBO : register(b9, space0) {
  float4 ColorDeficientTable_m0[3] : packoffset(c0);
};

cbuffer ImagePlaneParamUBO : register(b10, space0) {
  float4 ImagePlaneParam_m0[2] : packoffset(c0);
};

cbuffer CBControlUBO : register(b11, space0) {
  float4 CBControl_m0[1] : packoffset(c0);
};

Texture2D<float4> ReadonlyDepth : register(t0, space0);
Texture2D<float4> RE_POSTPROCESS_Color : register(t1, space0);
Texture2D<float4> tFilterTempMap1 : register(t2, space0);
Texture3D<float4> tVolumeMap : register(t3, space0);
Buffer<uint4> ComputeResultSRV : register(t4, space0);
Texture3D<float4> tTextureMap0 : register(t5, space0);
Texture3D<float4> tTextureMap1 : register(t6, space0);
Texture3D<float4> tTextureMap2 : register(t7, space0);
Texture2D<float4> ImagePlameBase : register(t8, space0);
Texture2D<float4> ImagePlameAlpha : register(t9, space0);
SamplerState PointClamp : register(s0, space0);
SamplerState BilinearWrap : register(s1, space0);
SamplerState BilinearClamp : register(s2, space0);
SamplerState BilinearBorder : register(s3, space0);
SamplerState TrilinearClamp : register(s4, space0);

static float4 gl_FragCoord;
static float4 Kerare;
static float Exposure;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float4 Kerare : Kerare;
  float Exposure : Exposure;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 TonemapParam_m0[3u];
  TonemapParam_m0[0u] = float4(contrast, linearBegin, linearLength, toe);
  TonemapParam_m0[1u] = float4(maxNit, linearStart, displayMaxNitSubContrastFactor, contrastFactor);
  TonemapParam_m0[2u] = float4(mulLinearStartContrastFactor, invLinearBegin, madLinearStartContrastFactor, 0.0);

#if 1
  TonemapParam_m0[0u].w = 1.f;  // toe
#endif
  TonemapParam_m0[1u].x = 125;  // maxNit
  TonemapParam_m0[1u].y = 125;  // linearStart

  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      CUSTOM_LUT_STRENGTH,
      CUSTOM_LUT_SCALING,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      ColorCorrectTexture_m0[0u].x);
  float3 sdrColor;
  float3 untonemapped;
  float3 hdrColor;

  uint4 _126 = asuint(CBControl_m0[0u]);
  uint _127 = _126.x;
  bool _130 = (_127 & 1u) != 0u;
  uint4 _133 = asuint(LensDistortionParam_m0[0u]);
  uint _134 = _133.w;
  bool _136 = _130 && (_134 == 0u);
  bool _138 = _130 && (_134 == 1u);
  bool _141 = (_127 & 64u) != 0u;
  float _145 = Kerare.x / Kerare.w;
  float _146 = Kerare.y / Kerare.w;
  float _147 = Kerare.z / Kerare.w;
  float _155 = abs(rsqrt(dot(float3(_145, _146, _147), float3(_145, _146, _147))) * _147);
  float _164 = _155 * _155;
  float _168 = clamp(((_164 * _164) * (1.0f - clamp((CameraKerare_m0[0u].x * _155) + CameraKerare_m0[0u].y, 0.0f, 1.0f))) + CameraKerare_m0[0u].z, 0.0f, 1.0f);
  float _169 = _168 * Exposure;
  float _497;
  float _500;
  float _503;
  float _506;
  float _507;
  float _508;
  float _509;
  float _510;
  float _511;
  if (_136) {
    float _185 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
    float _187 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
    float _188 = dot(float2(_185, _187), float2(_185, _187));
    float _194 = ((_188 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
    float _195 = _194 * _185;
    float _196 = _194 * _187;
    float _197 = _195 + 0.5f;
    float _199 = _196 + 0.5f;
    float frontier_phi_9_1_ladder;
    float frontier_phi_9_1_ladder_1;
    float frontier_phi_9_1_ladder_2;
    float frontier_phi_9_1_ladder_3;
    float frontier_phi_9_1_ladder_4;
    float frontier_phi_9_1_ladder_5;
    float frontier_phi_9_1_ladder_6;
    float frontier_phi_9_1_ladder_7;
    float frontier_phi_9_1_ladder_8;
    if (_133.z == 0u) {
      float _384;
      float _386;
      if (_141) {
        uint4 _374 = asuint(CBHazeFilterParams_m0[3u]);
        uint _375 = _374.x;
        bool _377 = (_375 & 2u) != 0u;
        float4 _381 = tFilterTempMap1.Sample(BilinearWrap, float2(_197, _199));
        float _383 = _381.x;
        float _1094;
        float _1095;
        if (_377) {
          float4 _668 = ReadonlyDepth.SampleLevel(PointClamp, float2(_197, _199), 0.0f);
          float _670 = _668.x;
          float _677 = (((_197 * 2.0f) * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].z) + (-1.0f);
          float _678 = 1.0f - (((_199 * 2.0f) * SceneInfo_m0[23u].y) * SceneInfo_m0[23u].w);
          float _723 = 1.0f / (mad(_670, SceneInfo_m0[16u].w, mad(_678, SceneInfo_m0[15u].w, _677 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
          float _725 = _723 * (mad(_670, SceneInfo_m0[16u].y, mad(_678, SceneInfo_m0[15u].y, _677 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
          float _738 = (_723 * (mad(_670, SceneInfo_m0[16u].x, mad(_678, SceneInfo_m0[15u].x, _677 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
          float _739 = _725 - SceneInfo_m0[8u].w;
          float _740 = (_723 * (mad(_670, SceneInfo_m0[16u].z, mad(_678, SceneInfo_m0[15u].z, _677 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
          _1094 = clamp(_383 * max((sqrt(((_739 * _739) + (_738 * _738)) + (_740 * _740)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_725 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
          _1095 = _670;
        } else {
          _1094 = ((_375 & 1u) != 0u) ? (1.0f - _383) : _383;
          _1095 = 0.0f;
        }
        float _1101 = (-0.0f) - _199;
        float _1128 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1101, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _197));
        float _1129 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1101, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _197));
        float _1130 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1101, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _197));
        float _1140 = _1128 * 2.0f;
        float _1141 = _1129 * 2.0f;
        float _1142 = _1130 * 2.0f;
        float _1152 = _1128 * 4.0f;
        float _1154 = _1129 * 4.0f;
        float _1155 = _1130 * 4.0f;
        float _1165 = _1128 * 8.0f;
        float _1167 = _1129 * 8.0f;
        float _1168 = _1130 * 8.0f;
        float _1178 = CBHazeFilterParams_m0[1u].x + 0.5f;
        float _1179 = CBHazeFilterParams_m0[1u].y + 0.5f;
        float _1180 = CBHazeFilterParams_m0[1u].z + 0.5f;
        float _1220 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1140 + CBHazeFilterParams_m0[1u].x, _1141 + CBHazeFilterParams_m0[1u].y, _1142 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1128 + CBHazeFilterParams_m0[1u].x, _1129 + CBHazeFilterParams_m0[1u].y, _1130 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1152 + CBHazeFilterParams_m0[1u].x, _1154 + CBHazeFilterParams_m0[1u].y, _1155 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1165 + CBHazeFilterParams_m0[1u].x, _1167 + CBHazeFilterParams_m0[1u].y, _1168 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1094) * CBHazeFilterParams_m0[2u].x;
        float _1222 = (CBHazeFilterParams_m0[2u].x * _1094) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1140 + _1178, _1141 + _1179, _1142 + _1180)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1128 + _1178, _1129 + _1179, _1130 + _1180)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1152 + _1178, _1154 + _1179, _1155 + _1180)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1165 + _1178, _1167 + _1179, _1168 + _1180)).x * 0.0625f)) * 2.0f) + (-1.0f));
        float _1697;
        float _1699;
        if ((_375 & 4u) == 0u) {
          _1697 = _1220;
          _1699 = _1222;
        } else {
          float _1710 = 0.5f / CBHazeFilterParams_m0[2u].y;
          float _1717 = clamp(max((_1710 * min(max(abs(_195) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1710 * min(max(abs(_196) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
          _1697 = _1220 - (_1717 * _1220);
          _1699 = _1222 - (_1717 * _1222);
        }
        float _2130;
        float _2131;
        if (_377) {
          float frontier_phi_42_41_ladder;
          float frontier_phi_42_41_ladder_1;
          if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1697 + _197, _1699 + _199)).x - _1095) < CBHazeFilterParams_m0[2u].w) {
            frontier_phi_42_41_ladder = _1699;
            frontier_phi_42_41_ladder_1 = _1697;
          } else {
            frontier_phi_42_41_ladder = 0.0f;
            frontier_phi_42_41_ladder_1 = 0.0f;
          }
          _2130 = frontier_phi_42_41_ladder_1;
          _2131 = frontier_phi_42_41_ladder;
        } else {
          _2130 = _1697;
          _2131 = _1699;
        }
        _384 = _2130 + _197;
        _386 = _2131 + _199;
      } else {
        _384 = _197;
        _386 = _199;
      }
      float4 _389 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_384, _386));
      float _394 = _389.x * _169;
      float _395 = _389.y * _169;
      float _396 = _389.z * _169;
      float _403 = TonemapParam_m0[2u].y * _394;
      float _409 = TonemapParam_m0[2u].y * _395;
      float _415 = TonemapParam_m0[2u].y * _396;
      float _422 = (_394 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_403 * _403) * (3.0f - (_403 * 2.0f))));
      float _424 = (_395 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_409 * _409) * (3.0f - (_409 * 2.0f))));
      float _426 = (_396 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_415 * _415) * (3.0f - (_415 * 2.0f))));
      float _433 = (_394 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _434 = (_395 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _435 = (_396 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_1_ladder = 0.0f;
      frontier_phi_9_1_ladder_1 = ((((TonemapParam_m0[0u].x * _394) + TonemapParam_m0[2u].z) * ((1.0f - _433) - _422)) + ((exp2(log2(_403) * TonemapParam_m0[0u].w) * _422) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _394) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _433);
      frontier_phi_9_1_ladder_2 = ((((TonemapParam_m0[0u].x * _395) + TonemapParam_m0[2u].z) * ((1.0f - _434) - _424)) + ((exp2(log2(_409) * TonemapParam_m0[0u].w) * _424) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _395) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _434);
      frontier_phi_9_1_ladder_3 = ((((TonemapParam_m0[0u].x * _396) + TonemapParam_m0[2u].z) * ((1.0f - _435) - _426)) + ((exp2(log2(_415) * TonemapParam_m0[0u].w) * _426) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _396) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _435);
      frontier_phi_9_1_ladder_4 = LensDistortionParam_m0[0u].x;
      frontier_phi_9_1_ladder_5 = 0.0f;
      frontier_phi_9_1_ladder_6 = 0.0f;
      frontier_phi_9_1_ladder_7 = 0.0f;
      frontier_phi_9_1_ladder_8 = LensDistortionParam_m0[1u].x;
    } else {
      float _203 = _188 + LensDistortionParam_m0[0u].y;
      float _205 = (_203 * LensDistortionParam_m0[0u].x) + 1.0f;
      float _206 = _185 * LensDistortionParam_m0[1u].x;
      float _208 = _187 * LensDistortionParam_m0[1u].x;
      float _214 = ((_203 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
      float _224 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_197, _199)).x * _169;
      float _231 = TonemapParam_m0[2u].y * _224;
      float _240 = (_224 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_231 * _231) * (3.0f - (_231 * 2.0f))));
      float _245 = (_224 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _274 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_206 * _205) + 0.5f, (_208 * _205) + 0.5f)).y * _169;
      float _275 = TonemapParam_m0[2u].y * _274;
      float _282 = (_274 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_275 * _275) * (3.0f - (_275 * 2.0f))));
      float _284 = (_274 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _306 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_206 * _214) + 0.5f, (_208 * _214) + 0.5f)).z * _169;
      float _307 = TonemapParam_m0[2u].y * _306;
      float _314 = (_306 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_307 * _307) * (3.0f - (_307 * 2.0f))));
      float _316 = (_306 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_1_ladder = 0.0f;
      frontier_phi_9_1_ladder_1 = ((((TonemapParam_m0[0u].x * _224) + TonemapParam_m0[2u].z) * ((1.0f - _245) - _240)) + ((TonemapParam_m0[0u].y * exp2(log2(_231) * TonemapParam_m0[0u].w)) * _240)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _224) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _245);
      frontier_phi_9_1_ladder_2 = ((((TonemapParam_m0[0u].x * _274) + TonemapParam_m0[2u].z) * ((1.0f - _284) - _282)) + ((TonemapParam_m0[0u].y * exp2(log2(_275) * TonemapParam_m0[0u].w)) * _282)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _274) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _284);
      frontier_phi_9_1_ladder_3 = ((((TonemapParam_m0[0u].x * _306) + TonemapParam_m0[2u].z) * ((1.0f - _316) - _314)) + ((TonemapParam_m0[0u].y * exp2(log2(_307) * TonemapParam_m0[0u].w)) * _314)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _306) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _316);
      frontier_phi_9_1_ladder_4 = LensDistortionParam_m0[0u].x;
      frontier_phi_9_1_ladder_5 = 0.0f;
      frontier_phi_9_1_ladder_6 = 0.0f;
      frontier_phi_9_1_ladder_7 = 0.0f;
      frontier_phi_9_1_ladder_8 = LensDistortionParam_m0[1u].x;
    }
    _497 = frontier_phi_9_1_ladder_1;
    _500 = frontier_phi_9_1_ladder_2;
    _503 = frontier_phi_9_1_ladder_3;
    _506 = frontier_phi_9_1_ladder_4;
    _507 = frontier_phi_9_1_ladder_5;
    _508 = frontier_phi_9_1_ladder_6;
    _509 = frontier_phi_9_1_ladder;
    _510 = frontier_phi_9_1_ladder_7;
    _511 = frontier_phi_9_1_ladder_8;
  } else {
    float frontier_phi_9_2_ladder;
    float frontier_phi_9_2_ladder_1;
    float frontier_phi_9_2_ladder_2;
    float frontier_phi_9_2_ladder_3;
    float frontier_phi_9_2_ladder_4;
    float frontier_phi_9_2_ladder_5;
    float frontier_phi_9_2_ladder_6;
    float frontier_phi_9_2_ladder_7;
    float frontier_phi_9_2_ladder_8;
    if (_138) {
      float _349 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
      float _354 = sqrt((_349 * _349) + 1.0f);
      float _355 = 1.0f / _354;
      float _358 = (_354 * PaniniProjectionParam_m0[0u].z) * (_355 + PaniniProjectionParam_m0[0u].x);
      float _362 = PaniniProjectionParam_m0[0u].w * 0.5f;
      float _364 = (_362 * _349) * _358;
      float _367 = ((_362 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_355 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _358;
      float _368 = _364 + 0.5f;
      float _369 = _367 + 0.5f;
      float _531;
      float _533;
      if (_141) {
        uint4 _521 = asuint(CBHazeFilterParams_m0[3u]);
        uint _522 = _521.x;
        bool _524 = (_522 & 2u) != 0u;
        float4 _528 = tFilterTempMap1.Sample(BilinearWrap, float2(_368, _369));
        float _530 = _528.x;
        float _1453;
        float _1454;
        if (_524) {
          float4 _809 = ReadonlyDepth.SampleLevel(PointClamp, float2(_368, _369), 0.0f);
          float _811 = _809.x;
          float _818 = (((SceneInfo_m0[23u].x * 2.0f) * _368) * SceneInfo_m0[23u].z) + (-1.0f);
          float _819 = 1.0f - (((SceneInfo_m0[23u].y * 2.0f) * _369) * SceneInfo_m0[23u].w);
          float _860 = 1.0f / (mad(_811, SceneInfo_m0[16u].w, mad(_819, SceneInfo_m0[15u].w, _818 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
          float _862 = _860 * (mad(_811, SceneInfo_m0[16u].y, mad(_819, SceneInfo_m0[15u].y, _818 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
          float _873 = (_860 * (mad(_811, SceneInfo_m0[16u].x, mad(_819, SceneInfo_m0[15u].x, _818 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
          float _874 = _862 - SceneInfo_m0[8u].w;
          float _875 = (_860 * (mad(_811, SceneInfo_m0[16u].z, mad(_819, SceneInfo_m0[15u].z, _818 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
          _1453 = clamp(_530 * max((sqrt(((_874 * _874) + (_873 * _873)) + (_875 * _875)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_862 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
          _1454 = _811;
        } else {
          _1453 = ((_522 & 1u) != 0u) ? (1.0f - _530) : _530;
          _1454 = 0.0f;
        }
        float _1460 = (-0.0f) - _369;
        float _1486 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1460, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _368));
        float _1487 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1460, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _368));
        float _1488 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1460, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _368));
        float _1497 = _1486 * 2.0f;
        float _1498 = _1487 * 2.0f;
        float _1499 = _1488 * 2.0f;
        float _1508 = _1486 * 4.0f;
        float _1509 = _1487 * 4.0f;
        float _1510 = _1488 * 4.0f;
        float _1519 = _1486 * 8.0f;
        float _1520 = _1487 * 8.0f;
        float _1521 = _1488 * 8.0f;
        float _1530 = CBHazeFilterParams_m0[1u].x + 0.5f;
        float _1531 = CBHazeFilterParams_m0[1u].y + 0.5f;
        float _1532 = CBHazeFilterParams_m0[1u].z + 0.5f;
        float _1572 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1497 + CBHazeFilterParams_m0[1u].x, _1498 + CBHazeFilterParams_m0[1u].y, _1499 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1486 + CBHazeFilterParams_m0[1u].x, _1487 + CBHazeFilterParams_m0[1u].y, _1488 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1508 + CBHazeFilterParams_m0[1u].x, _1509 + CBHazeFilterParams_m0[1u].y, _1510 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1519 + CBHazeFilterParams_m0[1u].x, _1520 + CBHazeFilterParams_m0[1u].y, _1521 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1453) * CBHazeFilterParams_m0[2u].x;
        float _1574 = (CBHazeFilterParams_m0[2u].x * _1453) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1497 + _1530, _1498 + _1531, _1499 + _1532)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1486 + _1530, _1487 + _1531, _1488 + _1532)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1508 + _1530, _1509 + _1531, _1510 + _1532)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1519 + _1530, _1520 + _1531, _1521 + _1532)).x * 0.0625f)) * 2.0f) + (-1.0f));
        float _2073;
        float _2075;
        if ((_522 & 4u) == 0u) {
          _2073 = _1572;
          _2075 = _1574;
        } else {
          float _2086 = 0.5f / CBHazeFilterParams_m0[2u].y;
          float _2093 = clamp(max((_2086 * min(max(abs(_364) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_2086 * min(max(abs(_367) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
          _2073 = _1572 - (_2093 * _1572);
          _2075 = _1574 - (_2093 * _1574);
        }
        float _2716;
        float _2717;
        if (_524) {
          float frontier_phi_53_52_ladder;
          float frontier_phi_53_52_ladder_1;
          if ((ReadonlyDepth.Sample(BilinearWrap, float2(_2073 + _368, _2075 + _369)).x - _1454) < CBHazeFilterParams_m0[2u].w) {
            frontier_phi_53_52_ladder = _2075;
            frontier_phi_53_52_ladder_1 = _2073;
          } else {
            frontier_phi_53_52_ladder = 0.0f;
            frontier_phi_53_52_ladder_1 = 0.0f;
          }
          _2716 = frontier_phi_53_52_ladder_1;
          _2717 = frontier_phi_53_52_ladder;
        } else {
          _2716 = _2073;
          _2717 = _2075;
        }
        _531 = _2716 + _368;
        _533 = _2717 + _369;
      } else {
        _531 = _368;
        _533 = _369;
      }
      float4 _536 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_531, _533));
      float _541 = _536.x * _169;
      float _542 = _536.y * _169;
      float _543 = _536.z * _169;
      float _550 = TonemapParam_m0[2u].y * _541;
      float _556 = TonemapParam_m0[2u].y * _542;
      float _562 = TonemapParam_m0[2u].y * _543;
      float _569 = (_541 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_550 * _550) * (3.0f - (_550 * 2.0f))));
      float _571 = (_542 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_556 * _556) * (3.0f - (_556 * 2.0f))));
      float _573 = (_543 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_562 * _562) * (3.0f - (_562 * 2.0f))));
      float _580 = (_541 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _581 = (_542 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _582 = (_543 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_2_ladder = PaniniProjectionParam_m0[0u].z;
      frontier_phi_9_2_ladder_1 = ((((TonemapParam_m0[0u].x * _541) + TonemapParam_m0[2u].z) * ((1.0f - _580) - _569)) + ((exp2(log2(_550) * TonemapParam_m0[0u].w) * _569) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _541) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _580);
      frontier_phi_9_2_ladder_2 = ((((TonemapParam_m0[0u].x * _542) + TonemapParam_m0[2u].z) * ((1.0f - _581) - _571)) + ((exp2(log2(_556) * TonemapParam_m0[0u].w) * _571) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _542) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _581);
      frontier_phi_9_2_ladder_3 = ((((TonemapParam_m0[0u].x * _543) + TonemapParam_m0[2u].z) * ((1.0f - _582) - _573)) + ((exp2(log2(_562) * TonemapParam_m0[0u].w) * _573) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _543) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _582);
      frontier_phi_9_2_ladder_4 = 0.0f;
      frontier_phi_9_2_ladder_5 = PaniniProjectionParam_m0[0u].x;
      frontier_phi_9_2_ladder_6 = PaniniProjectionParam_m0[0u].y;
      frontier_phi_9_2_ladder_7 = PaniniProjectionParam_m0[0u].w;
      frontier_phi_9_2_ladder_8 = 1.0f;
    } else {
      float _988;
      float _990;
      float _992;
      if (_141) {
        float _645 = SceneInfo_m0[23u].z * gl_FragCoord.x;
        float _646 = SceneInfo_m0[23u].w * gl_FragCoord.y;
        uint4 _649 = asuint(CBHazeFilterParams_m0[3u]);
        uint _650 = _649.x;
        bool _652 = (_650 & 2u) != 0u;
        float4 _656 = tFilterTempMap1.Sample(BilinearWrap, float2(_645, _646));
        float _658 = _656.x;
        float _1575;
        float _1576;
        if (_652) {
          float4 _900 = ReadonlyDepth.SampleLevel(PointClamp, float2(_645, _646), 0.0f);
          float _902 = _900.x;
          float _907 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
          float _908 = 1.0f - ((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w);
          float _949 = 1.0f / (mad(_902, SceneInfo_m0[16u].w, mad(_908, SceneInfo_m0[15u].w, _907 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
          float _951 = _949 * (mad(_902, SceneInfo_m0[16u].y, mad(_908, SceneInfo_m0[15u].y, _907 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
          float _962 = (_949 * (mad(_902, SceneInfo_m0[16u].x, mad(_908, SceneInfo_m0[15u].x, _907 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
          float _963 = _951 - SceneInfo_m0[8u].w;
          float _964 = (_949 * (mad(_902, SceneInfo_m0[16u].z, mad(_908, SceneInfo_m0[15u].z, _907 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
          _1575 = clamp(_658 * max((sqrt(((_963 * _963) + (_962 * _962)) + (_964 * _964)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_951 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
          _1576 = _902;
        } else {
          _1575 = ((_650 & 1u) != 0u) ? (1.0f - _658) : _658;
          _1576 = 0.0f;
        }
        float _1582 = (-0.0f) - _646;
        float _1608 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1582, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _645));
        float _1609 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1582, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _645));
        float _1610 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1582, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _645));
        float _1619 = _1608 * 2.0f;
        float _1620 = _1609 * 2.0f;
        float _1621 = _1610 * 2.0f;
        float _1630 = _1608 * 4.0f;
        float _1631 = _1609 * 4.0f;
        float _1632 = _1610 * 4.0f;
        float _1641 = _1608 * 8.0f;
        float _1642 = _1609 * 8.0f;
        float _1643 = _1610 * 8.0f;
        float _1652 = CBHazeFilterParams_m0[1u].x + 0.5f;
        float _1653 = CBHazeFilterParams_m0[1u].y + 0.5f;
        float _1654 = CBHazeFilterParams_m0[1u].z + 0.5f;
        float4 _1681 = tVolumeMap.Sample(BilinearWrap, float3(_1641 + _1652, _1642 + _1653, _1643 + _1654));
        float _1694 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1619 + CBHazeFilterParams_m0[1u].x, _1620 + CBHazeFilterParams_m0[1u].y, _1621 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1608 + CBHazeFilterParams_m0[1u].x, _1609 + CBHazeFilterParams_m0[1u].y, _1610 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1630 + CBHazeFilterParams_m0[1u].x, _1631 + CBHazeFilterParams_m0[1u].y, _1632 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1641 + CBHazeFilterParams_m0[1u].x, _1642 + CBHazeFilterParams_m0[1u].y, _1643 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1575) * CBHazeFilterParams_m0[2u].x;
        float _1696 = (CBHazeFilterParams_m0[2u].x * _1575) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1619 + _1652, _1620 + _1653, _1621 + _1654)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1608 + _1652, _1609 + _1653, _1610 + _1654)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1630 + _1652, _1631 + _1653, _1632 + _1654)).x * 0.125f)) + (_1681.x * 0.0625f)) * 2.0f) + (-1.0f));
        float _2096;
        float _2098;
        if ((_650 & 4u) == 0u) {
          _2096 = _1694;
          _2098 = _1696;
        } else {
          float _2111 = 0.5f / CBHazeFilterParams_m0[2u].y;
          float _2118 = clamp(max((_2111 * min(max(abs(_645 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_2111 * min(max(abs(_646 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
          _2096 = _1694 - (_2118 * _1694);
          _2098 = _1696 - (_2118 * _1696);
        }
        float _2727;
        float _2728;
        if (_652) {
          float frontier_phi_55_54_ladder;
          float frontier_phi_55_54_ladder_1;
          if ((ReadonlyDepth.Sample(BilinearWrap, float2(_2096 + _645, _2098 + _646)).x - _1576) < CBHazeFilterParams_m0[2u].w) {
            frontier_phi_55_54_ladder = _2098;
            frontier_phi_55_54_ladder_1 = _2096;
          } else {
            frontier_phi_55_54_ladder = 0.0f;
            frontier_phi_55_54_ladder_1 = 0.0f;
          }
          _2727 = frontier_phi_55_54_ladder_1;
          _2728 = frontier_phi_55_54_ladder;
        } else {
          _2727 = _2096;
          _2728 = _2098;
        }
        float4 _2732 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_2727 + _645, _2728 + _646));
        _988 = _2732.x;
        _990 = _2732.y;
        _992 = _2732.z;
      } else {
        float4 _661 = RE_POSTPROCESS_Color.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
        _988 = _661.x;
        _990 = _661.y;
        _992 = _661.z;
      }
      float _994 = _988 * _169;
      float _995 = _990 * _169;
      float _996 = _992 * _169;
      float _1003 = TonemapParam_m0[2u].y * _994;
      float _1009 = TonemapParam_m0[2u].y * _995;
      float _1015 = TonemapParam_m0[2u].y * _996;
      float _1022 = (_994 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1003 * _1003) * (3.0f - (_1003 * 2.0f))));
      float _1024 = (_995 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1009 * _1009) * (3.0f - (_1009 * 2.0f))));
      float _1026 = (_996 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1015 * _1015) * (3.0f - (_1015 * 2.0f))));
      float _1033 = (_994 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _1034 = (_995 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _1035 = (_996 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_2_ladder = 0.0f;
      frontier_phi_9_2_ladder_1 = ((((TonemapParam_m0[0u].x * _994) + TonemapParam_m0[2u].z) * ((1.0f - _1033) - _1022)) + ((exp2(log2(_1003) * TonemapParam_m0[0u].w) * _1022) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _994) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1033);
      frontier_phi_9_2_ladder_2 = ((((TonemapParam_m0[0u].x * _995) + TonemapParam_m0[2u].z) * ((1.0f - _1034) - _1024)) + ((exp2(log2(_1009) * TonemapParam_m0[0u].w) * _1024) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _995) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1034);
      frontier_phi_9_2_ladder_3 = ((((TonemapParam_m0[0u].x * _996) + TonemapParam_m0[2u].z) * ((1.0f - _1035) - _1026)) + ((exp2(log2(_1015) * TonemapParam_m0[0u].w) * _1026) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _996) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1035);
      frontier_phi_9_2_ladder_4 = 0.0f;
      frontier_phi_9_2_ladder_5 = 0.0f;
      frontier_phi_9_2_ladder_6 = 0.0f;
      frontier_phi_9_2_ladder_7 = 0.0f;
      frontier_phi_9_2_ladder_8 = 1.0f;
    }
    _497 = frontier_phi_9_2_ladder_1;
    _500 = frontier_phi_9_2_ladder_2;
    _503 = frontier_phi_9_2_ladder_3;
    _506 = frontier_phi_9_2_ladder_4;
    _507 = frontier_phi_9_2_ladder_5;
    _508 = frontier_phi_9_2_ladder_6;
    _509 = frontier_phi_9_2_ladder;
    _510 = frontier_phi_9_2_ladder_7;
    _511 = frontier_phi_9_2_ladder_8;
  }
  float _764;
  float _766;
  float _768;
  if ((asuint(CBControl_m0[0u]).x & 32u) == 0u) {
    _764 = _497;
    _766 = _500;
    _768 = _503;
  } else {
    uint4 _795 = asuint(RadialBlurRenderParam_m0[3u]);
    uint _796 = _795.x;
    float _799 = float((_796 & 2u) != 0u);
    float _806 = ((1.0f - _799) + (_799 * asfloat(ComputeResultSRV.Load(0u).x))) * RadialBlurRenderParam_m0[0u].w;
    float frontier_phi_16_17_ladder;
    float frontier_phi_16_17_ladder_1;
    float frontier_phi_16_17_ladder_2;
    if (_806 == 0.0f) {
      frontier_phi_16_17_ladder = _503;
      frontier_phi_16_17_ladder_1 = _500;
      frontier_phi_16_17_ladder_2 = _497;
    } else {
      float _1271 = SceneInfo_m0[23u].z * gl_FragCoord.x;
      float _1272 = SceneInfo_m0[23u].w * gl_FragCoord.y;
      float _1274 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _1271;
      float _1276 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _1272;
      float _1279 = (_1274 < 0.0f) ? (1.0f - _1271) : _1271;
      float _1282 = (_1276 < 0.0f) ? (1.0f - _1272) : _1272;
      float _1289 = rsqrt(dot(float2(_1274, _1276), float2(_1274, _1276))) * RadialBlurRenderParam_m0[2u].w;
      uint _1296 = uint(abs(_1289 * _1276)) + uint(abs(_1289 * _1274));
      uint _1301 = ((_1296 ^ 61u) ^ (_1296 >> 16u)) * 9u;
      uint _1304 = ((_1301 >> 4u) ^ _1301) * 668265261u;
      float _1311 = ((_796 & 1u) != 0u) ? (float((_1304 >> 15u) ^ _1304) * 2.3283064365386962890625e-10f) : 1.0f;
      float _1317 = 1.0f / max(1.0f, sqrt((_1274 * _1274) + (_1276 * _1276)));
      float _1318 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
      float _1328 = ((((_1318 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1329 = ((((_1318 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1330 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
      float _1340 = ((((_1330 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1341 = ((((_1330 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1342 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
      float _1352 = ((((_1342 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1353 = ((((_1342 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1354 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
      float _1364 = ((((_1354 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1365 = ((((_1354 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1366 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
      float _1376 = ((((_1366 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1377 = ((((_1366 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1378 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
      float _1388 = ((((_1378 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1389 = ((((_1378 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1390 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
      float _1400 = ((((_1390 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1401 = ((((_1390 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1402 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
      float _1412 = ((((_1402 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1413 = ((((_1402 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1414 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
      float _1424 = ((((_1414 * _1279) * _1311) * _1317) + 1.0f) * _1274;
      float _1425 = ((((_1414 * _1282) * _1311) * _1317) + 1.0f) * _1276;
      float _1426 = (_168 * Exposure) * 0.100000001490116119384765625f;
      float _1428 = _1426 * RadialBlurRenderParam_m0[0u].x;
      float _1429 = _1426 * RadialBlurRenderParam_m0[0u].y;
      float _1430 = _1426 * RadialBlurRenderParam_m0[0u].z;
      float _1448 = (_497 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x;
      float _1450 = (_500 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y;
      float _1452 = (_503 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z;
      float _2193;
      float _2196;
      float _2199;
      if (_136) {
        float _1778 = _1328 + RadialBlurRenderParam_m0[1u].x;
        float _1779 = _1329 + RadialBlurRenderParam_m0[1u].y;
        float _1785 = ((dot(float2(_1778, _1779), float2(_1778, _1779)) * _506) + 1.0f) * _511;
        float4 _1791 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_1785 * _1778) + 0.5f, (_1785 * _1779) + 0.5f), 0.0f);
        float _1796 = _1340 + RadialBlurRenderParam_m0[1u].x;
        float _1797 = _1341 + RadialBlurRenderParam_m0[1u].y;
        float _1803 = ((dot(float2(_1796, _1797), float2(_1796, _1797)) * _506) + 1.0f) * _511;
        float4 _1808 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_1803 * _1796) + 0.5f, (_1803 * _1797) + 0.5f), 0.0f);
        float _1816 = _1352 + RadialBlurRenderParam_m0[1u].x;
        float _1817 = _1353 + RadialBlurRenderParam_m0[1u].y;
        float _1822 = (dot(float2(_1816, _1817), float2(_1816, _1817)) * _506) + 1.0f;
        float4 _1829 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1816 * _511) * _1822) + 0.5f, ((_1817 * _511) * _1822) + 0.5f), 0.0f);
        float _1837 = _1364 + RadialBlurRenderParam_m0[1u].x;
        float _1838 = _1365 + RadialBlurRenderParam_m0[1u].y;
        float _1843 = (dot(float2(_1837, _1838), float2(_1837, _1838)) * _506) + 1.0f;
        float4 _1850 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1837 * _511) * _1843) + 0.5f, ((_1838 * _511) * _1843) + 0.5f), 0.0f);
        float _1858 = _1376 + RadialBlurRenderParam_m0[1u].x;
        float _1859 = _1377 + RadialBlurRenderParam_m0[1u].y;
        float _1864 = (dot(float2(_1858, _1859), float2(_1858, _1859)) * _506) + 1.0f;
        float4 _1871 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1858 * _511) * _1864) + 0.5f, ((_1859 * _511) * _1864) + 0.5f), 0.0f);
        float _1879 = _1388 + RadialBlurRenderParam_m0[1u].x;
        float _1880 = _1389 + RadialBlurRenderParam_m0[1u].y;
        float _1885 = (dot(float2(_1879, _1880), float2(_1879, _1880)) * _506) + 1.0f;
        float4 _1892 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1879 * _511) * _1885) + 0.5f, ((_1880 * _511) * _1885) + 0.5f), 0.0f);
        float _1900 = _1400 + RadialBlurRenderParam_m0[1u].x;
        float _1901 = _1401 + RadialBlurRenderParam_m0[1u].y;
        float _1906 = (dot(float2(_1900, _1901), float2(_1900, _1901)) * _506) + 1.0f;
        float4 _1913 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1900 * _511) * _1906) + 0.5f, ((_1901 * _511) * _1906) + 0.5f), 0.0f);
        float _1921 = _1412 + RadialBlurRenderParam_m0[1u].x;
        float _1922 = _1413 + RadialBlurRenderParam_m0[1u].y;
        float _1927 = (dot(float2(_1921, _1922), float2(_1921, _1922)) * _506) + 1.0f;
        float4 _1934 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1921 * _511) * _1927) + 0.5f, ((_1922 * _511) * _1927) + 0.5f), 0.0f);
        float _1942 = _1424 + RadialBlurRenderParam_m0[1u].x;
        float _1943 = _1425 + RadialBlurRenderParam_m0[1u].y;
        float _1948 = (dot(float2(_1942, _1943), float2(_1942, _1943)) * _506) + 1.0f;
        float4 _1955 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1942 * _511) * _1948) + 0.5f, ((_1943 * _511) * _1948) + 0.5f), 0.0f);
        float _1963 = _1428 * ((((((((_1808.x + _1791.x) + _1829.x) + _1850.x) + _1871.x) + _1892.x) + _1913.x) + _1934.x) + _1955.x);
        float _1964 = _1429 * ((((((((_1808.y + _1791.y) + _1829.y) + _1850.y) + _1871.y) + _1892.y) + _1913.y) + _1934.y) + _1955.y);
        float _1965 = _1430 * ((((((((_1808.z + _1791.z) + _1829.z) + _1850.z) + _1871.z) + _1892.z) + _1913.z) + _1934.z) + _1955.z);
        float _1966 = _1963 * TonemapParam_m0[2u].y;
        float _1972 = _1964 * TonemapParam_m0[2u].y;
        float _1978 = _1965 * TonemapParam_m0[2u].y;
        float _1985 = (_1963 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1966 * _1966) * (3.0f - (_1966 * 2.0f))));
        float _1987 = (_1964 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1972 * _1972) * (3.0f - (_1972 * 2.0f))));
        float _1989 = (_1965 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1978 * _1978) * (3.0f - (_1978 * 2.0f))));
        float _1993 = (_1963 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1994 = (_1964 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1995 = (_1965 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        _2193 = ((((_1985 * exp2(log2(_1966) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _1448) + (((TonemapParam_m0[0u].x * _1963) + TonemapParam_m0[2u].z) * ((1.0f - _1993) - _1985))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1963) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1993);
        _2196 = ((((exp2(log2(_1972) * TonemapParam_m0[0u].w) * _1987) * TonemapParam_m0[0u].y) + _1450) + (((TonemapParam_m0[0u].x * _1964) + TonemapParam_m0[2u].z) * ((1.0f - _1994) - _1987))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1964) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1994);
        _2199 = ((((exp2(log2(_1978) * TonemapParam_m0[0u].w) * _1989) * TonemapParam_m0[0u].y) + _1452) + (((TonemapParam_m0[0u].x * _1965) + TonemapParam_m0[2u].z) * ((1.0f - _1995) - _1989))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1965) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1995);
      } else {
        float _2053 = RadialBlurRenderParam_m0[1u].x + 0.5f;
        float _2054 = _2053 + _1328;
        float _2055 = RadialBlurRenderParam_m0[1u].y + 0.5f;
        float _2056 = _2055 + _1329;
        float _2057 = _2053 + _1340;
        float _2058 = _2055 + _1341;
        float _2059 = _2053 + _1352;
        float _2060 = _2055 + _1353;
        float _2061 = _2053 + _1364;
        float _2062 = _2055 + _1365;
        float _2063 = _2053 + _1376;
        float _2064 = _2055 + _1377;
        float _2065 = _2053 + _1388;
        float _2066 = _2055 + _1389;
        float _2067 = _2053 + _1400;
        float _2068 = _2055 + _1401;
        float _2069 = _2053 + _1412;
        float _2070 = _2055 + _1413;
        float _2071 = _2053 + _1424;
        float _2072 = _2055 + _1425;
        float frontier_phi_49_36_ladder;
        float frontier_phi_49_36_ladder_1;
        float frontier_phi_49_36_ladder_2;
        if (_138) {
          float _2205 = (_2054 * 2.0f) + (-1.0f);
          float _2209 = sqrt((_2205 * _2205) + 1.0f);
          float _2210 = 1.0f / _2209;
          float _2213 = (_2209 * _509) * (_2210 + _507);
          float _2217 = _510 * 0.5f;
          float4 _2226 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2213) * _2205) + 0.5f, (((_2217 * (((_2210 + (-1.0f)) * _508) + 1.0f)) * _2213) * ((_2056 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _2233 = (_2057 * 2.0f) + (-1.0f);
          float _2237 = sqrt((_2233 * _2233) + 1.0f);
          float _2238 = 1.0f / _2237;
          float _2241 = (_2237 * _509) * (_2238 + _507);
          float4 _2252 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2241) * _2233) + 0.5f, (((_2217 * (((_2238 + (-1.0f)) * _508) + 1.0f)) * _2241) * ((_2058 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _2262 = (_2059 * 2.0f) + (-1.0f);
          float _2266 = sqrt((_2262 * _2262) + 1.0f);
          float _2267 = 1.0f / _2266;
          float _2270 = (_2266 * _509) * (_2267 + _507);
          float4 _2281 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2262) * _2270) + 0.5f, (((_2217 * ((_2060 * 2.0f) + (-1.0f))) * (((_2267 + (-1.0f)) * _508) + 1.0f)) * _2270) + 0.5f), 0.0f);
          float _2291 = (_2061 * 2.0f) + (-1.0f);
          float _2295 = sqrt((_2291 * _2291) + 1.0f);
          float _2296 = 1.0f / _2295;
          float _2299 = (_2295 * _509) * (_2296 + _507);
          float4 _2310 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2291) * _2299) + 0.5f, (((_2217 * ((_2062 * 2.0f) + (-1.0f))) * (((_2296 + (-1.0f)) * _508) + 1.0f)) * _2299) + 0.5f), 0.0f);
          float _2320 = (_2063 * 2.0f) + (-1.0f);
          float _2324 = sqrt((_2320 * _2320) + 1.0f);
          float _2325 = 1.0f / _2324;
          float _2328 = (_2324 * _509) * (_2325 + _507);
          float4 _2339 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2320) * _2328) + 0.5f, (((_2217 * ((_2064 * 2.0f) + (-1.0f))) * (((_2325 + (-1.0f)) * _508) + 1.0f)) * _2328) + 0.5f), 0.0f);
          float _2349 = (_2065 * 2.0f) + (-1.0f);
          float _2353 = sqrt((_2349 * _2349) + 1.0f);
          float _2354 = 1.0f / _2353;
          float _2357 = (_2353 * _509) * (_2354 + _507);
          float4 _2368 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2349) * _2357) + 0.5f, (((_2217 * ((_2066 * 2.0f) + (-1.0f))) * (((_2354 + (-1.0f)) * _508) + 1.0f)) * _2357) + 0.5f), 0.0f);
          float _2378 = (_2067 * 2.0f) + (-1.0f);
          float _2382 = sqrt((_2378 * _2378) + 1.0f);
          float _2383 = 1.0f / _2382;
          float _2386 = (_2382 * _509) * (_2383 + _507);
          float4 _2397 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2378) * _2386) + 0.5f, (((_2217 * ((_2068 * 2.0f) + (-1.0f))) * (((_2383 + (-1.0f)) * _508) + 1.0f)) * _2386) + 0.5f), 0.0f);
          float _2407 = (_2069 * 2.0f) + (-1.0f);
          float _2411 = sqrt((_2407 * _2407) + 1.0f);
          float _2412 = 1.0f / _2411;
          float _2415 = (_2411 * _509) * (_2412 + _507);
          float4 _2426 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2407) * _2415) + 0.5f, (((_2217 * ((_2070 * 2.0f) + (-1.0f))) * (((_2412 + (-1.0f)) * _508) + 1.0f)) * _2415) + 0.5f), 0.0f);
          float _2436 = (_2071 * 2.0f) + (-1.0f);
          float _2440 = sqrt((_2436 * _2436) + 1.0f);
          float _2441 = 1.0f / _2440;
          float _2444 = (_2440 * _509) * (_2441 + _507);
          float4 _2455 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2217 * _2436) * _2444) + 0.5f, (((_2217 * ((_2072 * 2.0f) + (-1.0f))) * (((_2441 + (-1.0f)) * _508) + 1.0f)) * _2444) + 0.5f), 0.0f);
          float _2463 = _1428 * ((((((((_2252.x + _2226.x) + _2281.x) + _2310.x) + _2339.x) + _2368.x) + _2397.x) + _2426.x) + _2455.x);
          float _2464 = _1429 * ((((((((_2252.y + _2226.y) + _2281.y) + _2310.y) + _2339.y) + _2368.y) + _2397.y) + _2426.y) + _2455.y);
          float _2465 = _1430 * ((((((((_2252.z + _2226.z) + _2281.z) + _2310.z) + _2339.z) + _2368.z) + _2397.z) + _2426.z) + _2455.z);
          float _2466 = _2463 * TonemapParam_m0[2u].y;
          float _2472 = _2464 * TonemapParam_m0[2u].y;
          float _2478 = _2465 * TonemapParam_m0[2u].y;
          float _2485 = (_2463 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2466 * _2466) * (3.0f - (_2466 * 2.0f))));
          float _2487 = (_2464 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2472 * _2472) * (3.0f - (_2472 * 2.0f))));
          float _2489 = (_2465 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2478 * _2478) * (3.0f - (_2478 * 2.0f))));
          float _2493 = (_2463 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2494 = (_2464 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2495 = (_2465 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_49_36_ladder = ((((_2485 * exp2(log2(_2466) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _1448) + (((TonemapParam_m0[0u].x * _2463) + TonemapParam_m0[2u].z) * ((1.0f - _2493) - _2485))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2463) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2493);
          frontier_phi_49_36_ladder_1 = ((((exp2(log2(_2478) * TonemapParam_m0[0u].w) * _2489) * TonemapParam_m0[0u].y) + _1452) + (((TonemapParam_m0[0u].x * _2465) + TonemapParam_m0[2u].z) * ((1.0f - _2495) - _2489))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2465) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2495);
          frontier_phi_49_36_ladder_2 = ((((exp2(log2(_2472) * TonemapParam_m0[0u].w) * _2487) * TonemapParam_m0[0u].y) + _1450) + (((TonemapParam_m0[0u].x * _2464) + TonemapParam_m0[2u].z) * ((1.0f - _2494) - _2487))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2464) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2494);
        } else {
          float4 _2551 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2054, _2056), 0.0f);
          float4 _2556 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2057, _2058), 0.0f);
          float4 _2564 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2059, _2060), 0.0f);
          float4 _2572 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2061, _2062), 0.0f);
          float4 _2580 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2063, _2064), 0.0f);
          float4 _2588 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2065, _2066), 0.0f);
          float4 _2596 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2067, _2068), 0.0f);
          float4 _2604 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2069, _2070), 0.0f);
          float4 _2612 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2071, _2072), 0.0f);
          float _2620 = _1428 * ((((((((_2556.x + _2551.x) + _2564.x) + _2572.x) + _2580.x) + _2588.x) + _2596.x) + _2604.x) + _2612.x);
          float _2621 = _1429 * ((((((((_2556.y + _2551.y) + _2564.y) + _2572.y) + _2580.y) + _2588.y) + _2596.y) + _2604.y) + _2612.y);
          float _2622 = _1430 * ((((((((_2556.z + _2551.z) + _2564.z) + _2572.z) + _2580.z) + _2588.z) + _2596.z) + _2604.z) + _2612.z);
          float _2623 = _2620 * TonemapParam_m0[2u].y;
          float _2629 = _2621 * TonemapParam_m0[2u].y;
          float _2635 = _2622 * TonemapParam_m0[2u].y;
          float _2642 = (_2620 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2623 * _2623) * (3.0f - (_2623 * 2.0f))));
          float _2644 = (_2621 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2629 * _2629) * (3.0f - (_2629 * 2.0f))));
          float _2646 = (_2622 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2635 * _2635) * (3.0f - (_2635 * 2.0f))));
          float _2650 = (_2620 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2651 = (_2621 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2652 = (_2622 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_49_36_ladder = ((((_2642 * exp2(log2(_2623) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _1448) + (((TonemapParam_m0[0u].x * _2620) + TonemapParam_m0[2u].z) * ((1.0f - _2650) - _2642))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2620) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2650);
          frontier_phi_49_36_ladder_1 = ((((exp2(log2(_2635) * TonemapParam_m0[0u].w) * _2646) * TonemapParam_m0[0u].y) + _1452) + (((TonemapParam_m0[0u].x * _2622) + TonemapParam_m0[2u].z) * ((1.0f - _2652) - _2646))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2622) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2652);
          frontier_phi_49_36_ladder_2 = ((((exp2(log2(_2629) * TonemapParam_m0[0u].w) * _2644) * TonemapParam_m0[0u].y) + _1450) + (((TonemapParam_m0[0u].x * _2621) + TonemapParam_m0[2u].z) * ((1.0f - _2651) - _2644))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2621) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2651);
        }
        _2193 = frontier_phi_49_36_ladder;
        _2196 = frontier_phi_49_36_ladder_2;
        _2199 = frontier_phi_49_36_ladder_1;
      }
      float _2884;
      float _2885;
      float _2886;
      if (RadialBlurRenderParam_m0[2u].x > 0.0f) {
        float _2868 = clamp((sqrt((_1274 * _1274) + (_1276 * _1276)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
        float _2874 = (((_2868 * _2868) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_2868 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
        _2884 = (_2874 * (_2193 - _497)) + _497;
        _2885 = (_2874 * (_2196 - _500)) + _500;
        _2886 = (_2874 * (_2199 - _503)) + _503;
      } else {
        _2884 = _2193;
        _2885 = _2196;
        _2886 = _2199;
      }
      frontier_phi_16_17_ladder = ((_2886 - _503) * _806) + _503;
      frontier_phi_16_17_ladder_1 = ((_2885 - _500) * _806) + _500;
      frontier_phi_16_17_ladder_2 = ((_2884 - _497) * _806) + _497;
    }
    _764 = frontier_phi_16_17_ladder_2;
    _766 = frontier_phi_16_17_ladder_1;
    _768 = frontier_phi_16_17_ladder;
  }
  uint4 _772 = asuint(CBControl_m0[0u]);
  uint _773 = _772.x;
  float _1223;
  float _1225;
  float _1227;
  if ((_773 & 2u) == 0u) {
    _1223 = _764;
    _1225 = _766;
    _1227 = _768;
  } else {
    float _1252 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
    float _1254 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
    float _1263 = frac(frac(dot(float2(_1252, _1254), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
    float _1773;
    if (_1263 < FilmGrainParam_m0[1u].x) {
      uint _1761 = uint(_1254 * _1252) ^ 12345391u;
      uint _1763 = _1761 * 3635641u;
      _1773 = float(((_1763 >> 26u) | (_1761 * 232681024u)) ^ _1763) * 2.3283064365386962890625e-10f;
    } else {
      _1773 = 0.0f;
    }
    float _1776 = frac(_1263 * 757.48468017578125f);
    float _2189;
    if (_1776 < FilmGrainParam_m0[1u].x) {
      uint _2180 = asuint(_1776) ^ 12345391u;
      uint _2181 = _2180 * 3635641u;
      _2189 = (float(((_2181 >> 26u) | (_2180 * 232681024u)) ^ _2181) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _2189 = 0.0f;
    }
    float _2191 = frac(_1776 * 757.48468017578125f);
    float _2833;
    if (_2191 < FilmGrainParam_m0[1u].x) {
      uint _2824 = asuint(_2191) ^ 12345391u;
      uint _2825 = _2824 * 3635641u;
      _2833 = (float(((_2825 >> 26u) | (_2824 * 232681024u)) ^ _2825) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _2833 = 0.0f;
    }
    float _2834 = _1773 * FilmGrainParam_m0[0u].x;
    float _2835 = _2833 * FilmGrainParam_m0[0u].y;
    float _2836 = _2189 * FilmGrainParam_m0[0u].y;
    float _2855 = exp2(log2(1.0f - clamp(dot(float3(_764, _766, _768), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
    _1223 = (_2855 * (mad(_2836, 1.401999950408935546875f, _2834) - _764)) + _764;
    _1225 = (_2855 * (mad(_2836, -0.7139999866485595703125f, mad(_2835, -0.3440000116825103759765625f, _2834)) - _766)) + _766;
    _1227 = (_2855 * (mad(_2835, 1.77199995517730712890625f, _2834) - _768)) + _768;
  }
  float _1720;
  float _1723;
  float _1726;
  if ((_773 & 4u) == 0u) {
    _1720 = _1223;
    _1723 = _1225;
    _1726 = _1227;
  } else {
    float _1757 = max(max(_1223, _1225), _1227);
    bool _1758 = _1757 > 1.0f;
    float _2173;
    float _2174;
    float _2175;
#if 1  // use UpgradeToneMap() for LUT sampling
    untonemapped = float3(_1223, _1225, _1227);
    hdrColor = untonemapped;

    sdrColor = LUTToneMap(untonemapped);

#endif
#if 0  // max channel LUT sampling
        if (_1758)
        {
            _2173 = _1223 / _1757;
            _2174 = _1225 / _1757;
            _2175 = _1227 / _1757;
        }
        else
        {
            _2173 = _1223;
            _2174 = _1225;
            _2175 = _1227;
        }
#else
    _2173 = sdrColor.r;
    _2174 = sdrColor.g;
    _2175 = sdrColor.b;
#endif

#if 0
        float _2176 = ColorCorrectTexture_m0[0u].w * 0.5f;
        float _2893;
        if (_2173 > 0.003130800090730190277099609375f)
        {
            _2893 = (exp2(log2(_2173) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2893 = _2173 * 12.9200000762939453125f;
        }
        float _2901;
        if (_2174 > 0.003130800090730190277099609375f)
        {
            _2901 = (exp2(log2(_2174) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2901 = _2174 * 12.9200000762939453125f;
        }
        float _2909;
        if (_2175 > 0.003130800090730190277099609375f)
        {
            _2909 = (exp2(log2(_2175) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2909 = _2175 * 12.9200000762939453125f;
        }
        float _2910 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _2914 = (_2893 * _2910) + _2176;
        float _2915 = (_2901 * _2910) + _2176;
        float _2916 = (_2909 * _2910) + _2176;
        float4 _2918 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2914, _2915, _2916), 0.0f);
#else
    float3 _2918 = LUTBlackCorrection(float3(_2173, _2174, _2175), tTextureMap0, lut_config);
#endif

    float _2920 = _2918.x;
    float _2921 = _2918.y;
    float _2922 = _2918.z;
    float _2942;
    float _2945;
    float _2948;
    if (ColorCorrectTexture_m0[0u].y > 0.0f) {
#if 0
            float4 _2925 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2914, _2915, _2916), 0.0f);
#else
      float3 _2925 = LUTBlackCorrection(float3(_2173, _2174, _2175), tTextureMap1, lut_config);
#endif
      float _2936 = ((_2925.x - _2920) * ColorCorrectTexture_m0[0u].y) + _2920;
      float _2937 = ((_2925.y - _2921) * ColorCorrectTexture_m0[0u].y) + _2921;
      float _2938 = ((_2925.z - _2922) * ColorCorrectTexture_m0[0u].y) + _2922;
      float frontier_phi_77_74_ladder;
      float frontier_phi_77_74_ladder_1;
      float frontier_phi_77_74_ladder_2;
      if (ColorCorrectTexture_m0[0u].z > 0.0f) {
#if 0
                float _2974;
                if (_2936 > 0.003130800090730190277099609375f)
                {
                    _2974 = (exp2(log2(_2936) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2974 = _2936 * 12.9200000762939453125f;
                }
                float _2990;
                if (_2937 > 0.003130800090730190277099609375f)
                {
                    _2990 = (exp2(log2(_2937) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2990 = _2937 * 12.9200000762939453125f;
                }
                float _3017;
                if (_2938 > 0.003130800090730190277099609375f)
                {
                    _3017 = (exp2(log2(_2938) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3017 = _2938 * 12.9200000762939453125f;
                }
                float4 _3019 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2974, _2990, _3017), 0.0f);
#else
        float3 _3019 = LUTBlackCorrection(float3(_2936, _2937, _2938), tTextureMap2, lut_config);
#endif
        frontier_phi_77_74_ladder = ((_3019.x - _2936) * ColorCorrectTexture_m0[0u].z) + _2936;
        frontier_phi_77_74_ladder_1 = ((_3019.y - _2937) * ColorCorrectTexture_m0[0u].z) + _2937;
        frontier_phi_77_74_ladder_2 = ((_3019.z - _2938) * ColorCorrectTexture_m0[0u].z) + _2938;
      } else {
        frontier_phi_77_74_ladder = _2936;
        frontier_phi_77_74_ladder_1 = _2937;
        frontier_phi_77_74_ladder_2 = _2938;
      }
      _2942 = frontier_phi_77_74_ladder;
      _2945 = frontier_phi_77_74_ladder_1;
      _2948 = frontier_phi_77_74_ladder_2;
    } else {
#if 0
            float _2972;
            if (_2920 > 0.003130800090730190277099609375f)
            {
                _2972 = (exp2(log2(_2920) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2972 = _2920 * 12.9200000762939453125f;
            }
            float _2988;
            if (_2921 > 0.003130800090730190277099609375f)
            {
                _2988 = (exp2(log2(_2921) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2988 = _2921 * 12.9200000762939453125f;
            }
            float _3004;
            if (_2922 > 0.003130800090730190277099609375f)
            {
                _3004 = (exp2(log2(_2922) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _3004 = _2922 * 12.9200000762939453125f;
            }
            float4 _3006 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2972, _2988, _3004), 0.0f);
#else
      float3 _3006 = LUTBlackCorrection(float3(_2920, _2921, _2922), tTextureMap2, lut_config);
#endif
      _2942 = ((_3006.x - _2920) * ColorCorrectTexture_m0[0u].z) + _2920;
      _2945 = ((_3006.y - _2921) * ColorCorrectTexture_m0[0u].z) + _2921;
      _2948 = ((_3006.z - _2922) * ColorCorrectTexture_m0[0u].z) + _2922;
    }
    float _1722 = mad(_2948, ColorCorrectTexture_m0[3u].x, mad(_2945, ColorCorrectTexture_m0[2u].x, _2942 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
    float _1725 = mad(_2948, ColorCorrectTexture_m0[3u].y, mad(_2945, ColorCorrectTexture_m0[2u].y, _2942 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
    float _1728 = mad(_2948, ColorCorrectTexture_m0[3u].z, mad(_2945, ColorCorrectTexture_m0[2u].z, _2942 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
    float frontier_phi_31_77_ladder;
    float frontier_phi_31_77_ladder_1;
    float frontier_phi_31_77_ladder_2;
#if 0
        if (_1758)
        {
            frontier_phi_31_77_ladder = _1728 * _1757;
            frontier_phi_31_77_ladder_1 = _1725 * _1757;
            frontier_phi_31_77_ladder_2 = _1722 * _1757;
        }
        else
        {
            frontier_phi_31_77_ladder = _1728;
            frontier_phi_31_77_ladder_1 = _1725;
            frontier_phi_31_77_ladder_2 = _1722;
        }
        _1720 = frontier_phi_31_77_ladder_2;
        _1723 = frontier_phi_31_77_ladder_1;
        _1726 = frontier_phi_31_77_ladder;
#else
    float3 postprocessColor = float3(_1722, _1725, _1728);
    float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postprocessColor, 1.f);
    _1720 = upgradedColor.r;
    _1723 = upgradedColor.g;
    _1726 = upgradedColor.b;
#endif
  }
  float _2132;
  float _2134;
  float _2136;
  if ((_773 & 8u) == 0u) {
    _2132 = _1720;
    _2134 = _1723;
    _2136 = _1726;
  } else {
    _2132 = clamp(((ColorDeficientTable_m0[0u].x * _1720) + (ColorDeficientTable_m0[0u].y * _1723)) + (ColorDeficientTable_m0[0u].z * _1726), 0.0f, 1.0f);
    _2134 = clamp(((ColorDeficientTable_m0[1u].x * _1720) + (ColorDeficientTable_m0[1u].y * _1723)) + (ColorDeficientTable_m0[1u].z * _1726), 0.0f, 1.0f);
    _2136 = clamp(((ColorDeficientTable_m0[2u].x * _1720) + (ColorDeficientTable_m0[2u].y * _1723)) + (ColorDeficientTable_m0[2u].z * _1726), 0.0f, 1.0f);
  }
  float _2734;
  float _2736;
  float _2738;
  if ((_773 & 16u) == 0u) {
    _2734 = _2132;
    _2736 = _2134;
    _2738 = _2136;
  } else {
    float _2759 = SceneInfo_m0[23u].z * gl_FragCoord.x;
    float _2760 = SceneInfo_m0[23u].w * gl_FragCoord.y;
    float4 _2762 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2759, _2760), 0.0f);
    float _2768 = _2762.x * ImagePlaneParam_m0[0u].x;
    float _2769 = _2762.y * ImagePlaneParam_m0[0u].y;
    float _2770 = _2762.z * ImagePlaneParam_m0[0u].z;
    float _2779 = (_2762.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2759, _2760), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
    _2734 = ((((_2768 < 0.5f) ? ((_2132 * 2.0f) * _2768) : (1.0f - (((1.0f - _2132) * 2.0f) * (1.0f - _2768)))) - _2132) * _2779) + _2132;
    _2736 = ((((_2769 < 0.5f) ? ((_2134 * 2.0f) * _2769) : (1.0f - (((1.0f - _2134) * 2.0f) * (1.0f - _2769)))) - _2134) * _2779) + _2134;
    _2738 = ((((_2770 < 0.5f) ? ((_2136 * 2.0f) * _2770) : (1.0f - (((1.0f - _2136) * 2.0f) * (1.0f - _2770)))) - _2136) * _2779) + _2136;
  }
  SV_Target.x = _2734;
  SV_Target.y = _2736;
  SV_Target.z = _2738;
  SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  Kerare = stage_input.Kerare;
  Exposure = stage_input.Exposure;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
