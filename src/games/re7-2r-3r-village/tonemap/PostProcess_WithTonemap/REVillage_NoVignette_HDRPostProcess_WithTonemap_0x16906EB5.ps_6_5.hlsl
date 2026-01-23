#include "../../common.hlsli"

cbuffer SceneInfoUBO : register(b0, space0) {
  float4 SceneInfo_m0[33] : packoffset(c0);
};

// cbuffer TonemapParamUBO : register(b1, space0)
// {
//     float4 TonemapParam_m0[3] : packoffset(c0);
// };
cbuffer TonemapParamUBO : register(b1, space0) {
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

cbuffer CBHazeFilterParamsUBO : register(b2, space0) {
  float4 CBHazeFilterParams_m0[7] : packoffset(c0);
};

cbuffer LensDistortionParamUBO : register(b3, space0) {
  float4 LensDistortionParam_m0[2] : packoffset(c0);
};

cbuffer PaniniProjectionParamUBO : register(b4, space0) {
  float4 PaniniProjectionParam_m0[1] : packoffset(c0);
};

cbuffer RadialBlurRenderParamUBO : register(b5, space0) {
  float4 RadialBlurRenderParam_m0[4] : packoffset(c0);
};

cbuffer FilmGrainParamUBO : register(b6, space0) {
  float4 FilmGrainParam_m0[2] : packoffset(c0);
};

cbuffer ColorCorrectTextureUBO : register(b7, space0) {
  float4 ColorCorrectTexture_m0[5] : packoffset(c0);
};

cbuffer ColorDeficientTableUBO : register(b8, space0) {
  float4 ColorDeficientTable_m0[3] : packoffset(c0);
};

cbuffer ImagePlaneParamUBO : register(b9, space0) {
  float4 ImagePlaneParam_m0[2] : packoffset(c0);
};

cbuffer CBControlUBO : register(b10, space0) {
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
  TonemapParam_m0[0u].w = GetToneMapToe(toe);  // toe
#endif
  TonemapParam_m0[1u].x = GetToneMapMaxNitAndLinearStart();  // maxNit
  TonemapParam_m0[1u].y = GetToneMapMaxNitAndLinearStart();  // linearStart

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

  uint4 _114 = asuint(CBControl_m0[0u]);
  uint _115 = _114.x;
  bool _118 = (_115 & 1u) != 0u;
  uint4 _121 = asuint(LensDistortionParam_m0[0u]);
  uint _122 = _121.w;
  bool _124 = _118 && (_122 == 0u);
  bool _126 = _118 && (_122 == 1u);
  bool _129 = (_115 & 64u) != 0u;
  float _460;
  float _463;
  float _466;
  float _469;
  float _470;
  float _471;
  float _472;
  float _473;
  float _474;
  if (_124) {
    float _145 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
    float _147 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
    float _148 = dot(float2(_145, _147), float2(_145, _147));
    float _155 = ((_148 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
    float _156 = _155 * _145;
    float _157 = _155 * _147;
    float _158 = _156 + 0.5f;
    float _160 = _157 + 0.5f;
    float frontier_phi_9_1_ladder;
    float frontier_phi_9_1_ladder_1;
    float frontier_phi_9_1_ladder_2;
    float frontier_phi_9_1_ladder_3;
    float frontier_phi_9_1_ladder_4;
    float frontier_phi_9_1_ladder_5;
    float frontier_phi_9_1_ladder_6;
    float frontier_phi_9_1_ladder_7;
    float frontier_phi_9_1_ladder_8;
    if (_121.z == 0u) {
      float _347;
      float _349;
      if (_129) {
        uint4 _337 = asuint(CBHazeFilterParams_m0[3u]);
        uint _338 = _337.x;
        bool _340 = (_338 & 2u) != 0u;
        float4 _344 = tFilterTempMap1.Sample(BilinearWrap, float2(_158, _160));
        float _346 = _344.x;
        float _1057;
        float _1058;
        if (_340) {
          float4 _631 = ReadonlyDepth.SampleLevel(PointClamp, float2(_158, _160), 0.0f);
          float _633 = _631.x;
          float _640 = (((_158 * 2.0f) * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].z) + (-1.0f);
          float _641 = 1.0f - (((_160 * 2.0f) * SceneInfo_m0[23u].y) * SceneInfo_m0[23u].w);
          float _686 = 1.0f / (mad(_633, SceneInfo_m0[16u].w, mad(_641, SceneInfo_m0[15u].w, _640 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
          float _688 = _686 * (mad(_633, SceneInfo_m0[16u].y, mad(_641, SceneInfo_m0[15u].y, _640 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
          float _701 = (_686 * (mad(_633, SceneInfo_m0[16u].x, mad(_641, SceneInfo_m0[15u].x, _640 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
          float _702 = _688 - SceneInfo_m0[8u].w;
          float _703 = (_686 * (mad(_633, SceneInfo_m0[16u].z, mad(_641, SceneInfo_m0[15u].z, _640 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
          _1057 = clamp(_346 * max((sqrt(((_702 * _702) + (_701 * _701)) + (_703 * _703)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_688 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
          _1058 = _633;
        } else {
          _1057 = ((_338 & 1u) != 0u) ? (1.0f - _346) : _346;
          _1058 = 0.0f;
        }
        float _1064 = (-0.0f) - _160;
        float _1091 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1064, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _158));
        float _1092 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1064, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _158));
        float _1093 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1064, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _158));
        float _1104 = _1091 * 2.0f;
        float _1105 = _1092 * 2.0f;
        float _1106 = _1093 * 2.0f;
        float _1116 = _1091 * 4.0f;
        float _1118 = _1092 * 4.0f;
        float _1119 = _1093 * 4.0f;
        float _1129 = _1091 * 8.0f;
        float _1131 = _1092 * 8.0f;
        float _1132 = _1093 * 8.0f;
        float _1142 = CBHazeFilterParams_m0[1u].x + 0.5f;
        float _1143 = CBHazeFilterParams_m0[1u].y + 0.5f;
        float _1144 = CBHazeFilterParams_m0[1u].z + 0.5f;
        float _1184 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1104 + CBHazeFilterParams_m0[1u].x, _1105 + CBHazeFilterParams_m0[1u].y, _1106 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1091 + CBHazeFilterParams_m0[1u].x, _1092 + CBHazeFilterParams_m0[1u].y, _1093 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1116 + CBHazeFilterParams_m0[1u].x, _1118 + CBHazeFilterParams_m0[1u].y, _1119 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1129 + CBHazeFilterParams_m0[1u].x, _1131 + CBHazeFilterParams_m0[1u].y, _1132 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1057) * CBHazeFilterParams_m0[2u].x;
        float _1186 = (CBHazeFilterParams_m0[2u].x * _1057) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1104 + _1142, _1105 + _1143, _1106 + _1144)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1091 + _1142, _1092 + _1143, _1093 + _1144)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1116 + _1142, _1118 + _1143, _1119 + _1144)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1129 + _1142, _1131 + _1143, _1132 + _1144)).x * 0.0625f)) * 2.0f) + (-1.0f));
        float _1660;
        float _1662;
        if ((_338 & 4u) == 0u) {
          _1660 = _1184;
          _1662 = _1186;
        } else {
          float _1673 = 0.5f / CBHazeFilterParams_m0[2u].y;
          float _1680 = clamp(max((_1673 * min(max(abs(_156) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1673 * min(max(abs(_157) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
          _1660 = _1184 - (_1680 * _1184);
          _1662 = _1186 - (_1680 * _1186);
        }
        float _2093;
        float _2094;
        if (_340) {
          float frontier_phi_42_41_ladder;
          float frontier_phi_42_41_ladder_1;
          if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1660 + _158, _1662 + _160)).x - _1058) < CBHazeFilterParams_m0[2u].w) {
            frontier_phi_42_41_ladder = _1662;
            frontier_phi_42_41_ladder_1 = _1660;
          } else {
            frontier_phi_42_41_ladder = 0.0f;
            frontier_phi_42_41_ladder_1 = 0.0f;
          }
          _2093 = frontier_phi_42_41_ladder_1;
          _2094 = frontier_phi_42_41_ladder;
        } else {
          _2093 = _1660;
          _2094 = _1662;
        }
        _347 = _2093 + _158;
        _349 = _2094 + _160;
      } else {
        _347 = _158;
        _349 = _160;
      }
      float4 _352 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_347, _349));
      float _357 = _352.x * Exposure;
      float _358 = _352.y * Exposure;
      float _359 = _352.z * Exposure;
      float _366 = TonemapParam_m0[2u].y * _357;
      float _372 = TonemapParam_m0[2u].y * _358;
      float _378 = TonemapParam_m0[2u].y * _359;
      float _385 = (_357 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_366 * _366) * (3.0f - (_366 * 2.0f))));
      float _387 = (_358 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_372 * _372) * (3.0f - (_372 * 2.0f))));
      float _389 = (_359 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_378 * _378) * (3.0f - (_378 * 2.0f))));
      float _396 = (_357 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _397 = (_358 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _398 = (_359 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_1_ladder = 0.0f;
      frontier_phi_9_1_ladder_1 = ((((TonemapParam_m0[0u].x * _357) + TonemapParam_m0[2u].z) * ((1.0f - _396) - _385)) + ((exp2(log2(_366) * TonemapParam_m0[0u].w) * _385) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _357) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _396);
      frontier_phi_9_1_ladder_2 = ((((TonemapParam_m0[0u].x * _358) + TonemapParam_m0[2u].z) * ((1.0f - _397) - _387)) + ((exp2(log2(_372) * TonemapParam_m0[0u].w) * _387) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _358) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _397);
      frontier_phi_9_1_ladder_3 = ((((TonemapParam_m0[0u].x * _359) + TonemapParam_m0[2u].z) * ((1.0f - _398) - _389)) + ((exp2(log2(_378) * TonemapParam_m0[0u].w) * _389) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _359) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _398);
      frontier_phi_9_1_ladder_4 = LensDistortionParam_m0[0u].x;
      frontier_phi_9_1_ladder_5 = 0.0f;
      frontier_phi_9_1_ladder_6 = 0.0f;
      frontier_phi_9_1_ladder_7 = 0.0f;
      frontier_phi_9_1_ladder_8 = LensDistortionParam_m0[1u].x;
    } else {
      float _164 = _148 + LensDistortionParam_m0[0u].y;
      float _166 = (_164 * LensDistortionParam_m0[0u].x) + 1.0f;
      float _167 = _145 * LensDistortionParam_m0[1u].x;
      float _169 = _147 * LensDistortionParam_m0[1u].x;
      float _175 = ((_164 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
      float _186 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_158, _160)).x * Exposure;
      float _193 = TonemapParam_m0[2u].y * _186;
      float _202 = (_186 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_193 * _193) * (3.0f - (_193 * 2.0f))));
      float _207 = (_186 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _237 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_167 * _166) + 0.5f, (_169 * _166) + 0.5f)).y * Exposure;
      float _238 = TonemapParam_m0[2u].y * _237;
      float _245 = (_237 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_238 * _238) * (3.0f - (_238 * 2.0f))));
      float _247 = (_237 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _269 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_167 * _175) + 0.5f, (_169 * _175) + 0.5f)).z * Exposure;
      float _270 = TonemapParam_m0[2u].y * _269;
      float _277 = (_269 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_270 * _270) * (3.0f - (_270 * 2.0f))));
      float _279 = (_269 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_1_ladder = 0.0f;
      frontier_phi_9_1_ladder_1 = ((((TonemapParam_m0[0u].x * _186) + TonemapParam_m0[2u].z) * ((1.0f - _207) - _202)) + ((TonemapParam_m0[0u].y * exp2(log2(_193) * TonemapParam_m0[0u].w)) * _202)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _186) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _207);
      frontier_phi_9_1_ladder_2 = ((((TonemapParam_m0[0u].x * _237) + TonemapParam_m0[2u].z) * ((1.0f - _247) - _245)) + ((TonemapParam_m0[0u].y * exp2(log2(_238) * TonemapParam_m0[0u].w)) * _245)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _237) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _247);
      frontier_phi_9_1_ladder_3 = ((((TonemapParam_m0[0u].x * _269) + TonemapParam_m0[2u].z) * ((1.0f - _279) - _277)) + ((TonemapParam_m0[0u].y * exp2(log2(_270) * TonemapParam_m0[0u].w)) * _277)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _269) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _279);
      frontier_phi_9_1_ladder_4 = LensDistortionParam_m0[0u].x;
      frontier_phi_9_1_ladder_5 = 0.0f;
      frontier_phi_9_1_ladder_6 = 0.0f;
      frontier_phi_9_1_ladder_7 = 0.0f;
      frontier_phi_9_1_ladder_8 = LensDistortionParam_m0[1u].x;
    }
    _460 = frontier_phi_9_1_ladder_1;
    _463 = frontier_phi_9_1_ladder_2;
    _466 = frontier_phi_9_1_ladder_3;
    _469 = frontier_phi_9_1_ladder_4;
    _470 = frontier_phi_9_1_ladder_5;
    _471 = frontier_phi_9_1_ladder_6;
    _472 = frontier_phi_9_1_ladder;
    _473 = frontier_phi_9_1_ladder_7;
    _474 = frontier_phi_9_1_ladder_8;
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
    if (_126) {
      float _312 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
      float _317 = sqrt((_312 * _312) + 1.0f);
      float _318 = 1.0f / _317;
      float _321 = (_317 * PaniniProjectionParam_m0[0u].z) * (_318 + PaniniProjectionParam_m0[0u].x);
      float _325 = PaniniProjectionParam_m0[0u].w * 0.5f;
      float _327 = (_325 * _312) * _321;
      float _330 = ((_325 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_318 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _321;
      float _331 = _327 + 0.5f;
      float _332 = _330 + 0.5f;
      float _494;
      float _496;
      if (_129) {
        uint4 _484 = asuint(CBHazeFilterParams_m0[3u]);
        uint _485 = _484.x;
        bool _487 = (_485 & 2u) != 0u;
        float4 _491 = tFilterTempMap1.Sample(BilinearWrap, float2(_331, _332));
        float _493 = _491.x;
        float _1416;
        float _1417;
        if (_487) {
          float4 _772 = ReadonlyDepth.SampleLevel(PointClamp, float2(_331, _332), 0.0f);
          float _774 = _772.x;
          float _781 = (((SceneInfo_m0[23u].x * 2.0f) * _331) * SceneInfo_m0[23u].z) + (-1.0f);
          float _782 = 1.0f - (((SceneInfo_m0[23u].y * 2.0f) * _332) * SceneInfo_m0[23u].w);
          float _823 = 1.0f / (mad(_774, SceneInfo_m0[16u].w, mad(_782, SceneInfo_m0[15u].w, _781 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
          float _825 = _823 * (mad(_774, SceneInfo_m0[16u].y, mad(_782, SceneInfo_m0[15u].y, _781 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
          float _836 = (_823 * (mad(_774, SceneInfo_m0[16u].x, mad(_782, SceneInfo_m0[15u].x, _781 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
          float _837 = _825 - SceneInfo_m0[8u].w;
          float _838 = (_823 * (mad(_774, SceneInfo_m0[16u].z, mad(_782, SceneInfo_m0[15u].z, _781 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
          _1416 = clamp(_493 * max((sqrt(((_837 * _837) + (_836 * _836)) + (_838 * _838)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_825 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
          _1417 = _774;
        } else {
          _1416 = ((_485 & 1u) != 0u) ? (1.0f - _493) : _493;
          _1417 = 0.0f;
        }
        float _1423 = (-0.0f) - _332;
        float _1449 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1423, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _331));
        float _1450 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1423, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _331));
        float _1451 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1423, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _331));
        float _1460 = _1449 * 2.0f;
        float _1461 = _1450 * 2.0f;
        float _1462 = _1451 * 2.0f;
        float _1471 = _1449 * 4.0f;
        float _1472 = _1450 * 4.0f;
        float _1473 = _1451 * 4.0f;
        float _1482 = _1449 * 8.0f;
        float _1483 = _1450 * 8.0f;
        float _1484 = _1451 * 8.0f;
        float _1493 = CBHazeFilterParams_m0[1u].x + 0.5f;
        float _1494 = CBHazeFilterParams_m0[1u].y + 0.5f;
        float _1495 = CBHazeFilterParams_m0[1u].z + 0.5f;
        float _1535 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1460 + CBHazeFilterParams_m0[1u].x, _1461 + CBHazeFilterParams_m0[1u].y, _1462 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1449 + CBHazeFilterParams_m0[1u].x, _1450 + CBHazeFilterParams_m0[1u].y, _1451 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1471 + CBHazeFilterParams_m0[1u].x, _1472 + CBHazeFilterParams_m0[1u].y, _1473 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1482 + CBHazeFilterParams_m0[1u].x, _1483 + CBHazeFilterParams_m0[1u].y, _1484 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1416) * CBHazeFilterParams_m0[2u].x;
        float _1537 = (CBHazeFilterParams_m0[2u].x * _1416) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1460 + _1493, _1461 + _1494, _1462 + _1495)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1449 + _1493, _1450 + _1494, _1451 + _1495)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1471 + _1493, _1472 + _1494, _1473 + _1495)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1482 + _1493, _1483 + _1494, _1484 + _1495)).x * 0.0625f)) * 2.0f) + (-1.0f));
        float _2036;
        float _2038;
        if ((_485 & 4u) == 0u) {
          _2036 = _1535;
          _2038 = _1537;
        } else {
          float _2049 = 0.5f / CBHazeFilterParams_m0[2u].y;
          float _2056 = clamp(max((_2049 * min(max(abs(_327) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_2049 * min(max(abs(_330) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
          _2036 = _1535 - (_2056 * _1535);
          _2038 = _1537 - (_2056 * _1537);
        }
        float _2679;
        float _2680;
        if (_487) {
          float frontier_phi_53_52_ladder;
          float frontier_phi_53_52_ladder_1;
          if ((ReadonlyDepth.Sample(BilinearWrap, float2(_2036 + _331, _2038 + _332)).x - _1417) < CBHazeFilterParams_m0[2u].w) {
            frontier_phi_53_52_ladder = _2038;
            frontier_phi_53_52_ladder_1 = _2036;
          } else {
            frontier_phi_53_52_ladder = 0.0f;
            frontier_phi_53_52_ladder_1 = 0.0f;
          }
          _2679 = frontier_phi_53_52_ladder_1;
          _2680 = frontier_phi_53_52_ladder;
        } else {
          _2679 = _2036;
          _2680 = _2038;
        }
        _494 = _2679 + _331;
        _496 = _2680 + _332;
      } else {
        _494 = _331;
        _496 = _332;
      }
      float4 _499 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_494, _496));
      float _504 = _499.x * Exposure;
      float _505 = _499.y * Exposure;
      float _506 = _499.z * Exposure;
      float _513 = TonemapParam_m0[2u].y * _504;
      float _519 = TonemapParam_m0[2u].y * _505;
      float _525 = TonemapParam_m0[2u].y * _506;
      float _532 = (_504 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_513 * _513) * (3.0f - (_513 * 2.0f))));
      float _534 = (_505 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_519 * _519) * (3.0f - (_519 * 2.0f))));
      float _536 = (_506 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_525 * _525) * (3.0f - (_525 * 2.0f))));
      float _543 = (_504 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _544 = (_505 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _545 = (_506 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_2_ladder = PaniniProjectionParam_m0[0u].z;
      frontier_phi_9_2_ladder_1 = ((((TonemapParam_m0[0u].x * _504) + TonemapParam_m0[2u].z) * ((1.0f - _543) - _532)) + ((exp2(log2(_513) * TonemapParam_m0[0u].w) * _532) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _504) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _543);
      frontier_phi_9_2_ladder_2 = ((((TonemapParam_m0[0u].x * _505) + TonemapParam_m0[2u].z) * ((1.0f - _544) - _534)) + ((exp2(log2(_519) * TonemapParam_m0[0u].w) * _534) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _505) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _544);
      frontier_phi_9_2_ladder_3 = ((((TonemapParam_m0[0u].x * _506) + TonemapParam_m0[2u].z) * ((1.0f - _545) - _536)) + ((exp2(log2(_525) * TonemapParam_m0[0u].w) * _536) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _506) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _545);
      frontier_phi_9_2_ladder_4 = 0.0f;
      frontier_phi_9_2_ladder_5 = PaniniProjectionParam_m0[0u].x;
      frontier_phi_9_2_ladder_6 = PaniniProjectionParam_m0[0u].y;
      frontier_phi_9_2_ladder_7 = PaniniProjectionParam_m0[0u].w;
      frontier_phi_9_2_ladder_8 = 1.0f;
    } else {
      float _951;
      float _953;
      float _955;
      if (_129) {
        float _608 = SceneInfo_m0[23u].z * gl_FragCoord.x;
        float _609 = SceneInfo_m0[23u].w * gl_FragCoord.y;
        uint4 _612 = asuint(CBHazeFilterParams_m0[3u]);
        uint _613 = _612.x;
        bool _615 = (_613 & 2u) != 0u;
        float4 _619 = tFilterTempMap1.Sample(BilinearWrap, float2(_608, _609));
        float _621 = _619.x;
        float _1538;
        float _1539;
        if (_615) {
          float4 _863 = ReadonlyDepth.SampleLevel(PointClamp, float2(_608, _609), 0.0f);
          float _865 = _863.x;
          float _870 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
          float _871 = 1.0f - ((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w);
          float _912 = 1.0f / (mad(_865, SceneInfo_m0[16u].w, mad(_871, SceneInfo_m0[15u].w, _870 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
          float _914 = _912 * (mad(_865, SceneInfo_m0[16u].y, mad(_871, SceneInfo_m0[15u].y, _870 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
          float _925 = (_912 * (mad(_865, SceneInfo_m0[16u].x, mad(_871, SceneInfo_m0[15u].x, _870 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
          float _926 = _914 - SceneInfo_m0[8u].w;
          float _927 = (_912 * (mad(_865, SceneInfo_m0[16u].z, mad(_871, SceneInfo_m0[15u].z, _870 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
          _1538 = clamp(_621 * max((sqrt(((_926 * _926) + (_925 * _925)) + (_927 * _927)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_914 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
          _1539 = _865;
        } else {
          _1538 = ((_613 & 1u) != 0u) ? (1.0f - _621) : _621;
          _1539 = 0.0f;
        }
        float _1545 = (-0.0f) - _609;
        float _1571 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1545, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _608));
        float _1572 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1545, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _608));
        float _1573 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1545, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _608));
        float _1582 = _1571 * 2.0f;
        float _1583 = _1572 * 2.0f;
        float _1584 = _1573 * 2.0f;
        float _1593 = _1571 * 4.0f;
        float _1594 = _1572 * 4.0f;
        float _1595 = _1573 * 4.0f;
        float _1604 = _1571 * 8.0f;
        float _1605 = _1572 * 8.0f;
        float _1606 = _1573 * 8.0f;
        float _1615 = CBHazeFilterParams_m0[1u].x + 0.5f;
        float _1616 = CBHazeFilterParams_m0[1u].y + 0.5f;
        float _1617 = CBHazeFilterParams_m0[1u].z + 0.5f;
        float4 _1644 = tVolumeMap.Sample(BilinearWrap, float3(_1604 + _1615, _1605 + _1616, _1606 + _1617));
        float _1657 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1582 + CBHazeFilterParams_m0[1u].x, _1583 + CBHazeFilterParams_m0[1u].y, _1584 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1571 + CBHazeFilterParams_m0[1u].x, _1572 + CBHazeFilterParams_m0[1u].y, _1573 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1593 + CBHazeFilterParams_m0[1u].x, _1594 + CBHazeFilterParams_m0[1u].y, _1595 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1604 + CBHazeFilterParams_m0[1u].x, _1605 + CBHazeFilterParams_m0[1u].y, _1606 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1538) * CBHazeFilterParams_m0[2u].x;
        float _1659 = (CBHazeFilterParams_m0[2u].x * _1538) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1582 + _1615, _1583 + _1616, _1584 + _1617)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1571 + _1615, _1572 + _1616, _1573 + _1617)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1593 + _1615, _1594 + _1616, _1595 + _1617)).x * 0.125f)) + (_1644.x * 0.0625f)) * 2.0f) + (-1.0f));
        float _2059;
        float _2061;
        if ((_613 & 4u) == 0u) {
          _2059 = _1657;
          _2061 = _1659;
        } else {
          float _2074 = 0.5f / CBHazeFilterParams_m0[2u].y;
          float _2081 = clamp(max((_2074 * min(max(abs(_608 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_2074 * min(max(abs(_609 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
          _2059 = _1657 - (_2081 * _1657);
          _2061 = _1659 - (_2081 * _1659);
        }
        float _2690;
        float _2691;
        if (_615) {
          float frontier_phi_55_54_ladder;
          float frontier_phi_55_54_ladder_1;
          if ((ReadonlyDepth.Sample(BilinearWrap, float2(_2059 + _608, _2061 + _609)).x - _1539) < CBHazeFilterParams_m0[2u].w) {
            frontier_phi_55_54_ladder = _2061;
            frontier_phi_55_54_ladder_1 = _2059;
          } else {
            frontier_phi_55_54_ladder = 0.0f;
            frontier_phi_55_54_ladder_1 = 0.0f;
          }
          _2690 = frontier_phi_55_54_ladder_1;
          _2691 = frontier_phi_55_54_ladder;
        } else {
          _2690 = _2059;
          _2691 = _2061;
        }
        float4 _2695 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_2690 + _608, _2691 + _609));
        _951 = _2695.x;
        _953 = _2695.y;
        _955 = _2695.z;
      } else {
        float4 _624 = RE_POSTPROCESS_Color.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
        _951 = _624.x;
        _953 = _624.y;
        _955 = _624.z;
      }
      float _957 = _951 * Exposure;
      float _958 = _953 * Exposure;
      float _959 = _955 * Exposure;
      float _966 = TonemapParam_m0[2u].y * _957;
      float _972 = TonemapParam_m0[2u].y * _958;
      float _978 = TonemapParam_m0[2u].y * _959;
      float _985 = (_957 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_966 * _966) * (3.0f - (_966 * 2.0f))));
      float _987 = (_958 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_972 * _972) * (3.0f - (_972 * 2.0f))));
      float _989 = (_959 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_978 * _978) * (3.0f - (_978 * 2.0f))));
      float _996 = (_957 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _997 = (_958 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _998 = (_959 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_9_2_ladder = 0.0f;
      frontier_phi_9_2_ladder_1 = ((((TonemapParam_m0[0u].x * _957) + TonemapParam_m0[2u].z) * ((1.0f - _996) - _985)) + ((exp2(log2(_966) * TonemapParam_m0[0u].w) * _985) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _957) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _996);
      frontier_phi_9_2_ladder_2 = ((((TonemapParam_m0[0u].x * _958) + TonemapParam_m0[2u].z) * ((1.0f - _997) - _987)) + ((exp2(log2(_972) * TonemapParam_m0[0u].w) * _987) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _958) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _997);
      frontier_phi_9_2_ladder_3 = ((((TonemapParam_m0[0u].x * _959) + TonemapParam_m0[2u].z) * ((1.0f - _998) - _989)) + ((exp2(log2(_978) * TonemapParam_m0[0u].w) * _989) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _959) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _998);
      frontier_phi_9_2_ladder_4 = 0.0f;
      frontier_phi_9_2_ladder_5 = 0.0f;
      frontier_phi_9_2_ladder_6 = 0.0f;
      frontier_phi_9_2_ladder_7 = 0.0f;
      frontier_phi_9_2_ladder_8 = 1.0f;
    }
    _460 = frontier_phi_9_2_ladder_1;
    _463 = frontier_phi_9_2_ladder_2;
    _466 = frontier_phi_9_2_ladder_3;
    _469 = frontier_phi_9_2_ladder_4;
    _470 = frontier_phi_9_2_ladder_5;
    _471 = frontier_phi_9_2_ladder_6;
    _472 = frontier_phi_9_2_ladder;
    _473 = frontier_phi_9_2_ladder_7;
    _474 = frontier_phi_9_2_ladder_8;
  }
  float _727;
  float _729;
  float _731;
  if ((asuint(CBControl_m0[0u]).x & 32u) == 0u) {
    _727 = _460;
    _729 = _463;
    _731 = _466;
  } else {
    uint4 _758 = asuint(RadialBlurRenderParam_m0[3u]);
    uint _759 = _758.x;
    float _762 = float((_759 & 2u) != 0u);
    float _769 = ((1.0f - _762) + (_762 * asfloat(ComputeResultSRV.Load(0u).x))) * RadialBlurRenderParam_m0[0u].w;
    float frontier_phi_16_17_ladder;
    float frontier_phi_16_17_ladder_1;
    float frontier_phi_16_17_ladder_2;
    if (_769 == 0.0f) {
      frontier_phi_16_17_ladder = _466;
      frontier_phi_16_17_ladder_1 = _463;
      frontier_phi_16_17_ladder_2 = _460;
    } else {
      float _1234 = SceneInfo_m0[23u].z * gl_FragCoord.x;
      float _1235 = SceneInfo_m0[23u].w * gl_FragCoord.y;
      float _1237 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _1234;
      float _1239 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _1235;
      float _1242 = (_1237 < 0.0f) ? (1.0f - _1234) : _1234;
      float _1245 = (_1239 < 0.0f) ? (1.0f - _1235) : _1235;
      float _1252 = rsqrt(dot(float2(_1237, _1239), float2(_1237, _1239))) * RadialBlurRenderParam_m0[2u].w;
      uint _1259 = uint(abs(_1252 * _1239)) + uint(abs(_1252 * _1237));
      uint _1264 = ((_1259 ^ 61u) ^ (_1259 >> 16u)) * 9u;
      uint _1267 = ((_1264 >> 4u) ^ _1264) * 668265261u;
      float _1274 = ((_759 & 1u) != 0u) ? (float((_1267 >> 15u) ^ _1267) * 2.3283064365386962890625e-10f) : 1.0f;
      float _1280 = 1.0f / max(1.0f, sqrt((_1237 * _1237) + (_1239 * _1239)));
      float _1281 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
      float _1291 = ((((_1281 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1292 = ((((_1281 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1293 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
      float _1303 = ((((_1293 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1304 = ((((_1293 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1305 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
      float _1315 = ((((_1305 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1316 = ((((_1305 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1317 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
      float _1327 = ((((_1317 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1328 = ((((_1317 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1329 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
      float _1339 = ((((_1329 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1340 = ((((_1329 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1341 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
      float _1351 = ((((_1341 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1352 = ((((_1341 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1353 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
      float _1363 = ((((_1353 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1364 = ((((_1353 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1365 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
      float _1375 = ((((_1365 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1376 = ((((_1365 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1377 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
      float _1387 = ((((_1377 * _1242) * _1274) * _1280) + 1.0f) * _1237;
      float _1388 = ((((_1377 * _1245) * _1274) * _1280) + 1.0f) * _1239;
      float _1389 = Exposure * 0.100000001490116119384765625f;
      float _1391 = _1389 * RadialBlurRenderParam_m0[0u].x;
      float _1392 = _1389 * RadialBlurRenderParam_m0[0u].y;
      float _1393 = _1389 * RadialBlurRenderParam_m0[0u].z;
      float _1411 = (_460 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x;
      float _1413 = (_463 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y;
      float _1415 = (_466 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z;
      float _2156;
      float _2159;
      float _2162;
      if (_124) {
        float _1741 = _1291 + RadialBlurRenderParam_m0[1u].x;
        float _1742 = _1292 + RadialBlurRenderParam_m0[1u].y;
        float _1748 = ((dot(float2(_1741, _1742), float2(_1741, _1742)) * _469) + 1.0f) * _474;
        float4 _1754 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_1748 * _1741) + 0.5f, (_1748 * _1742) + 0.5f), 0.0f);
        float _1759 = _1303 + RadialBlurRenderParam_m0[1u].x;
        float _1760 = _1304 + RadialBlurRenderParam_m0[1u].y;
        float _1766 = ((dot(float2(_1759, _1760), float2(_1759, _1760)) * _469) + 1.0f) * _474;
        float4 _1771 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_1766 * _1759) + 0.5f, (_1766 * _1760) + 0.5f), 0.0f);
        float _1779 = _1315 + RadialBlurRenderParam_m0[1u].x;
        float _1780 = _1316 + RadialBlurRenderParam_m0[1u].y;
        float _1785 = (dot(float2(_1779, _1780), float2(_1779, _1780)) * _469) + 1.0f;
        float4 _1792 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1779 * _474) * _1785) + 0.5f, ((_1780 * _474) * _1785) + 0.5f), 0.0f);
        float _1800 = _1327 + RadialBlurRenderParam_m0[1u].x;
        float _1801 = _1328 + RadialBlurRenderParam_m0[1u].y;
        float _1806 = (dot(float2(_1800, _1801), float2(_1800, _1801)) * _469) + 1.0f;
        float4 _1813 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1800 * _474) * _1806) + 0.5f, ((_1801 * _474) * _1806) + 0.5f), 0.0f);
        float _1821 = _1339 + RadialBlurRenderParam_m0[1u].x;
        float _1822 = _1340 + RadialBlurRenderParam_m0[1u].y;
        float _1827 = (dot(float2(_1821, _1822), float2(_1821, _1822)) * _469) + 1.0f;
        float4 _1834 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1821 * _474) * _1827) + 0.5f, ((_1822 * _474) * _1827) + 0.5f), 0.0f);
        float _1842 = _1351 + RadialBlurRenderParam_m0[1u].x;
        float _1843 = _1352 + RadialBlurRenderParam_m0[1u].y;
        float _1848 = (dot(float2(_1842, _1843), float2(_1842, _1843)) * _469) + 1.0f;
        float4 _1855 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1842 * _474) * _1848) + 0.5f, ((_1843 * _474) * _1848) + 0.5f), 0.0f);
        float _1863 = _1363 + RadialBlurRenderParam_m0[1u].x;
        float _1864 = _1364 + RadialBlurRenderParam_m0[1u].y;
        float _1869 = (dot(float2(_1863, _1864), float2(_1863, _1864)) * _469) + 1.0f;
        float4 _1876 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1863 * _474) * _1869) + 0.5f, ((_1864 * _474) * _1869) + 0.5f), 0.0f);
        float _1884 = _1375 + RadialBlurRenderParam_m0[1u].x;
        float _1885 = _1376 + RadialBlurRenderParam_m0[1u].y;
        float _1890 = (dot(float2(_1884, _1885), float2(_1884, _1885)) * _469) + 1.0f;
        float4 _1897 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1884 * _474) * _1890) + 0.5f, ((_1885 * _474) * _1890) + 0.5f), 0.0f);
        float _1905 = _1387 + RadialBlurRenderParam_m0[1u].x;
        float _1906 = _1388 + RadialBlurRenderParam_m0[1u].y;
        float _1911 = (dot(float2(_1905, _1906), float2(_1905, _1906)) * _469) + 1.0f;
        float4 _1918 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1905 * _474) * _1911) + 0.5f, ((_1906 * _474) * _1911) + 0.5f), 0.0f);
        float _1926 = _1391 * ((((((((_1771.x + _1754.x) + _1792.x) + _1813.x) + _1834.x) + _1855.x) + _1876.x) + _1897.x) + _1918.x);
        float _1927 = _1392 * ((((((((_1771.y + _1754.y) + _1792.y) + _1813.y) + _1834.y) + _1855.y) + _1876.y) + _1897.y) + _1918.y);
        float _1928 = _1393 * ((((((((_1771.z + _1754.z) + _1792.z) + _1813.z) + _1834.z) + _1855.z) + _1876.z) + _1897.z) + _1918.z);
        float _1929 = _1926 * TonemapParam_m0[2u].y;
        float _1935 = _1927 * TonemapParam_m0[2u].y;
        float _1941 = _1928 * TonemapParam_m0[2u].y;
        float _1948 = (_1926 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1929 * _1929) * (3.0f - (_1929 * 2.0f))));
        float _1950 = (_1927 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1935 * _1935) * (3.0f - (_1935 * 2.0f))));
        float _1952 = (_1928 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1941 * _1941) * (3.0f - (_1941 * 2.0f))));
        float _1956 = (_1926 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1957 = (_1927 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1958 = (_1928 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        _2156 = ((((_1948 * exp2(log2(_1929) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _1411) + (((TonemapParam_m0[0u].x * _1926) + TonemapParam_m0[2u].z) * ((1.0f - _1956) - _1948))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1926) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1956);
        _2159 = ((((exp2(log2(_1935) * TonemapParam_m0[0u].w) * _1950) * TonemapParam_m0[0u].y) + _1413) + (((TonemapParam_m0[0u].x * _1927) + TonemapParam_m0[2u].z) * ((1.0f - _1957) - _1950))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1927) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1957);
        _2162 = ((((exp2(log2(_1941) * TonemapParam_m0[0u].w) * _1952) * TonemapParam_m0[0u].y) + _1415) + (((TonemapParam_m0[0u].x * _1928) + TonemapParam_m0[2u].z) * ((1.0f - _1958) - _1952))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1928) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1958);
      } else {
        float _2016 = RadialBlurRenderParam_m0[1u].x + 0.5f;
        float _2017 = _2016 + _1291;
        float _2018 = RadialBlurRenderParam_m0[1u].y + 0.5f;
        float _2019 = _2018 + _1292;
        float _2020 = _2016 + _1303;
        float _2021 = _2018 + _1304;
        float _2022 = _2016 + _1315;
        float _2023 = _2018 + _1316;
        float _2024 = _2016 + _1327;
        float _2025 = _2018 + _1328;
        float _2026 = _2016 + _1339;
        float _2027 = _2018 + _1340;
        float _2028 = _2016 + _1351;
        float _2029 = _2018 + _1352;
        float _2030 = _2016 + _1363;
        float _2031 = _2018 + _1364;
        float _2032 = _2016 + _1375;
        float _2033 = _2018 + _1376;
        float _2034 = _2016 + _1387;
        float _2035 = _2018 + _1388;
        float frontier_phi_49_36_ladder;
        float frontier_phi_49_36_ladder_1;
        float frontier_phi_49_36_ladder_2;
        if (_126) {
          float _2168 = (_2017 * 2.0f) + (-1.0f);
          float _2172 = sqrt((_2168 * _2168) + 1.0f);
          float _2173 = 1.0f / _2172;
          float _2176 = (_2172 * _472) * (_2173 + _470);
          float _2180 = _473 * 0.5f;
          float4 _2189 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2176) * _2168) + 0.5f, (((_2180 * (((_2173 + (-1.0f)) * _471) + 1.0f)) * _2176) * ((_2019 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _2196 = (_2020 * 2.0f) + (-1.0f);
          float _2200 = sqrt((_2196 * _2196) + 1.0f);
          float _2201 = 1.0f / _2200;
          float _2204 = (_2200 * _472) * (_2201 + _470);
          float4 _2215 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2204) * _2196) + 0.5f, (((_2180 * (((_2201 + (-1.0f)) * _471) + 1.0f)) * _2204) * ((_2021 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _2225 = (_2022 * 2.0f) + (-1.0f);
          float _2229 = sqrt((_2225 * _2225) + 1.0f);
          float _2230 = 1.0f / _2229;
          float _2233 = (_2229 * _472) * (_2230 + _470);
          float4 _2244 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2225) * _2233) + 0.5f, (((_2180 * ((_2023 * 2.0f) + (-1.0f))) * (((_2230 + (-1.0f)) * _471) + 1.0f)) * _2233) + 0.5f), 0.0f);
          float _2254 = (_2024 * 2.0f) + (-1.0f);
          float _2258 = sqrt((_2254 * _2254) + 1.0f);
          float _2259 = 1.0f / _2258;
          float _2262 = (_2258 * _472) * (_2259 + _470);
          float4 _2273 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2254) * _2262) + 0.5f, (((_2180 * ((_2025 * 2.0f) + (-1.0f))) * (((_2259 + (-1.0f)) * _471) + 1.0f)) * _2262) + 0.5f), 0.0f);
          float _2283 = (_2026 * 2.0f) + (-1.0f);
          float _2287 = sqrt((_2283 * _2283) + 1.0f);
          float _2288 = 1.0f / _2287;
          float _2291 = (_2287 * _472) * (_2288 + _470);
          float4 _2302 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2283) * _2291) + 0.5f, (((_2180 * ((_2027 * 2.0f) + (-1.0f))) * (((_2288 + (-1.0f)) * _471) + 1.0f)) * _2291) + 0.5f), 0.0f);
          float _2312 = (_2028 * 2.0f) + (-1.0f);
          float _2316 = sqrt((_2312 * _2312) + 1.0f);
          float _2317 = 1.0f / _2316;
          float _2320 = (_2316 * _472) * (_2317 + _470);
          float4 _2331 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2312) * _2320) + 0.5f, (((_2180 * ((_2029 * 2.0f) + (-1.0f))) * (((_2317 + (-1.0f)) * _471) + 1.0f)) * _2320) + 0.5f), 0.0f);
          float _2341 = (_2030 * 2.0f) + (-1.0f);
          float _2345 = sqrt((_2341 * _2341) + 1.0f);
          float _2346 = 1.0f / _2345;
          float _2349 = (_2345 * _472) * (_2346 + _470);
          float4 _2360 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2341) * _2349) + 0.5f, (((_2180 * ((_2031 * 2.0f) + (-1.0f))) * (((_2346 + (-1.0f)) * _471) + 1.0f)) * _2349) + 0.5f), 0.0f);
          float _2370 = (_2032 * 2.0f) + (-1.0f);
          float _2374 = sqrt((_2370 * _2370) + 1.0f);
          float _2375 = 1.0f / _2374;
          float _2378 = (_2374 * _472) * (_2375 + _470);
          float4 _2389 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2370) * _2378) + 0.5f, (((_2180 * ((_2033 * 2.0f) + (-1.0f))) * (((_2375 + (-1.0f)) * _471) + 1.0f)) * _2378) + 0.5f), 0.0f);
          float _2399 = (_2034 * 2.0f) + (-1.0f);
          float _2403 = sqrt((_2399 * _2399) + 1.0f);
          float _2404 = 1.0f / _2403;
          float _2407 = (_2403 * _472) * (_2404 + _470);
          float4 _2418 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2180 * _2399) * _2407) + 0.5f, (((_2180 * ((_2035 * 2.0f) + (-1.0f))) * (((_2404 + (-1.0f)) * _471) + 1.0f)) * _2407) + 0.5f), 0.0f);
          float _2426 = _1391 * ((((((((_2215.x + _2189.x) + _2244.x) + _2273.x) + _2302.x) + _2331.x) + _2360.x) + _2389.x) + _2418.x);
          float _2427 = _1392 * ((((((((_2215.y + _2189.y) + _2244.y) + _2273.y) + _2302.y) + _2331.y) + _2360.y) + _2389.y) + _2418.y);
          float _2428 = _1393 * ((((((((_2215.z + _2189.z) + _2244.z) + _2273.z) + _2302.z) + _2331.z) + _2360.z) + _2389.z) + _2418.z);
          float _2429 = _2426 * TonemapParam_m0[2u].y;
          float _2435 = _2427 * TonemapParam_m0[2u].y;
          float _2441 = _2428 * TonemapParam_m0[2u].y;
          float _2448 = (_2426 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2429 * _2429) * (3.0f - (_2429 * 2.0f))));
          float _2450 = (_2427 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2435 * _2435) * (3.0f - (_2435 * 2.0f))));
          float _2452 = (_2428 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2441 * _2441) * (3.0f - (_2441 * 2.0f))));
          float _2456 = (_2426 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2457 = (_2427 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2458 = (_2428 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_49_36_ladder = ((((_2448 * exp2(log2(_2429) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _1411) + (((TonemapParam_m0[0u].x * _2426) + TonemapParam_m0[2u].z) * ((1.0f - _2456) - _2448))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2426) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2456);
          frontier_phi_49_36_ladder_1 = ((((exp2(log2(_2441) * TonemapParam_m0[0u].w) * _2452) * TonemapParam_m0[0u].y) + _1415) + (((TonemapParam_m0[0u].x * _2428) + TonemapParam_m0[2u].z) * ((1.0f - _2458) - _2452))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2428) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2458);
          frontier_phi_49_36_ladder_2 = ((((exp2(log2(_2435) * TonemapParam_m0[0u].w) * _2450) * TonemapParam_m0[0u].y) + _1413) + (((TonemapParam_m0[0u].x * _2427) + TonemapParam_m0[2u].z) * ((1.0f - _2457) - _2450))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2427) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2457);
        } else {
          float4 _2514 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2017, _2019), 0.0f);
          float4 _2519 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2020, _2021), 0.0f);
          float4 _2527 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2022, _2023), 0.0f);
          float4 _2535 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2024, _2025), 0.0f);
          float4 _2543 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2026, _2027), 0.0f);
          float4 _2551 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2028, _2029), 0.0f);
          float4 _2559 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2030, _2031), 0.0f);
          float4 _2567 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2032, _2033), 0.0f);
          float4 _2575 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2034, _2035), 0.0f);
          float _2583 = _1391 * ((((((((_2519.x + _2514.x) + _2527.x) + _2535.x) + _2543.x) + _2551.x) + _2559.x) + _2567.x) + _2575.x);
          float _2584 = _1392 * ((((((((_2519.y + _2514.y) + _2527.y) + _2535.y) + _2543.y) + _2551.y) + _2559.y) + _2567.y) + _2575.y);
          float _2585 = _1393 * ((((((((_2519.z + _2514.z) + _2527.z) + _2535.z) + _2543.z) + _2551.z) + _2559.z) + _2567.z) + _2575.z);
          float _2586 = _2583 * TonemapParam_m0[2u].y;
          float _2592 = _2584 * TonemapParam_m0[2u].y;
          float _2598 = _2585 * TonemapParam_m0[2u].y;
          float _2605 = (_2583 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2586 * _2586) * (3.0f - (_2586 * 2.0f))));
          float _2607 = (_2584 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2592 * _2592) * (3.0f - (_2592 * 2.0f))));
          float _2609 = (_2585 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2598 * _2598) * (3.0f - (_2598 * 2.0f))));
          float _2613 = (_2583 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2614 = (_2584 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _2615 = (_2585 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_49_36_ladder = ((((_2605 * exp2(log2(_2586) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _1411) + (((TonemapParam_m0[0u].x * _2583) + TonemapParam_m0[2u].z) * ((1.0f - _2613) - _2605))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2583) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2613);
          frontier_phi_49_36_ladder_1 = ((((exp2(log2(_2598) * TonemapParam_m0[0u].w) * _2609) * TonemapParam_m0[0u].y) + _1415) + (((TonemapParam_m0[0u].x * _2585) + TonemapParam_m0[2u].z) * ((1.0f - _2615) - _2609))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2585) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2615);
          frontier_phi_49_36_ladder_2 = ((((exp2(log2(_2592) * TonemapParam_m0[0u].w) * _2607) * TonemapParam_m0[0u].y) + _1413) + (((TonemapParam_m0[0u].x * _2584) + TonemapParam_m0[2u].z) * ((1.0f - _2614) - _2607))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2584) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2614);
        }
        _2156 = frontier_phi_49_36_ladder;
        _2159 = frontier_phi_49_36_ladder_2;
        _2162 = frontier_phi_49_36_ladder_1;
      }
      float _2847;
      float _2848;
      float _2849;
      if (RadialBlurRenderParam_m0[2u].x > 0.0f) {
        float _2831 = clamp((sqrt((_1237 * _1237) + (_1239 * _1239)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
        float _2837 = (((_2831 * _2831) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_2831 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
        _2847 = (_2837 * (_2156 - _460)) + _460;
        _2848 = (_2837 * (_2159 - _463)) + _463;
        _2849 = (_2837 * (_2162 - _466)) + _466;
      } else {
        _2847 = _2156;
        _2848 = _2159;
        _2849 = _2162;
      }
      frontier_phi_16_17_ladder = ((_2849 - _466) * _769) + _466;
      frontier_phi_16_17_ladder_1 = ((_2848 - _463) * _769) + _463;
      frontier_phi_16_17_ladder_2 = ((_2847 - _460) * _769) + _460;
    }
    _727 = frontier_phi_16_17_ladder_2;
    _729 = frontier_phi_16_17_ladder_1;
    _731 = frontier_phi_16_17_ladder;
  }
  uint4 _735 = asuint(CBControl_m0[0u]);
  uint _736 = _735.x;
  float _1187;
  float _1189;
  float _1191;
  if ((_736 & 2u) == 0u) {
    _1187 = _727;
    _1189 = _729;
    _1191 = _731;
  } else {
    float _1216 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
    float _1218 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
    float _1227 = frac(frac(dot(float2(_1216, _1218), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
    float _1736;
    if (_1227 < FilmGrainParam_m0[1u].x) {
      uint _1724 = uint(_1218 * _1216) ^ 12345391u;
      uint _1726 = _1724 * 3635641u;
      _1736 = float(((_1726 >> 26u) | (_1724 * 232681024u)) ^ _1726) * 2.3283064365386962890625e-10f;
    } else {
      _1736 = 0.0f;
    }
    float _1739 = frac(_1227 * 757.48468017578125f);
    float _2152;
    if (_1739 < FilmGrainParam_m0[1u].x) {
      uint _2143 = asuint(_1739) ^ 12345391u;
      uint _2144 = _2143 * 3635641u;
      _2152 = (float(((_2144 >> 26u) | (_2143 * 232681024u)) ^ _2144) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _2152 = 0.0f;
    }
    float _2154 = frac(_1739 * 757.48468017578125f);
    float _2796;
    if (_2154 < FilmGrainParam_m0[1u].x) {
      uint _2787 = asuint(_2154) ^ 12345391u;
      uint _2788 = _2787 * 3635641u;
      _2796 = (float(((_2788 >> 26u) | (_2787 * 232681024u)) ^ _2788) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _2796 = 0.0f;
    }
    float _2797 = _1736 * FilmGrainParam_m0[0u].x;
    float _2798 = _2796 * FilmGrainParam_m0[0u].y;
    float _2799 = _2152 * FilmGrainParam_m0[0u].y;
    float _2818 = exp2(log2(1.0f - clamp(dot(float3(_727, _729, _731), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
    _1187 = (_2818 * (mad(_2799, 1.401999950408935546875f, _2797) - _727)) + _727;
    _1189 = (_2818 * (mad(_2799, -0.7139999866485595703125f, mad(_2798, -0.3440000116825103759765625f, _2797)) - _729)) + _729;
    _1191 = (_2818 * (mad(_2798, 1.77199995517730712890625f, _2797) - _731)) + _731;
  }
  float _1683;
  float _1686;
  float _1689;
  if ((_736 & 4u) == 0u) {
    _1683 = _1187;
    _1686 = _1189;
    _1689 = _1191;
  } else {
    float _1720 = max(max(_1187, _1189), _1191);
    bool _1721 = _1720 > 1.0f;
    float _2136;
    float _2137;
    float _2138;
#if 1  // use UpgradeToneMap() for LUT sampling
    untonemapped = float3(_1187, _1189, _1191);
    hdrColor = untonemapped;

    sdrColor = LUTToneMap(untonemapped);

#endif
#if 0  // max channel LUT sampling

        if (_1721)
        {
            _2136 = _1187 / _1720;
            _2137 = _1189 / _1720;
            _2138 = _1191 / _1720;
        }
        else
        {
            _2136 = _1187;
            _2137 = _1189;
            _2138 = _1191;
        }
#else
    _2136 = sdrColor.r;
    _2137 = sdrColor.g;
    _2138 = sdrColor.b;
#endif

#if 0
        float _2139 = ColorCorrectTexture_m0[0u].w * 0.5f;
        float _2856;
        if (_2136 > 0.003130800090730190277099609375f)
        {
            _2856 = (exp2(log2(_2136) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2856 = _2136 * 12.9200000762939453125f;
        }
        float _2864;
        if (_2137 > 0.003130800090730190277099609375f)
        {
            _2864 = (exp2(log2(_2137) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2864 = _2137 * 12.9200000762939453125f;
        }
        float _2872;
        if (_2138 > 0.003130800090730190277099609375f)
        {
            _2872 = (exp2(log2(_2138) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2872 = _2138 * 12.9200000762939453125f;
        }
        float _2873 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _2877 = (_2856 * _2873) + _2139;
        float _2878 = (_2864 * _2873) + _2139;
        float _2879 = (_2872 * _2873) + _2139;
        float4 _2881 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_2877, _2878, _2879), 0.0f);
#else
    float3 _2881 = LUTBlackCorrection(float3(_2136, _2137, _2138), tTextureMap0, lut_config);
#endif
    float _2883 = _2881.x;
    float _2884 = _2881.y;
    float _2885 = _2881.z;
    float _2905;
    float _2908;
    float _2911;
    if (ColorCorrectTexture_m0[0u].y > 0.0f) {
#if 0
            float4 _2888 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_2877, _2878, _2879), 0.0f);
#else
      float3 _2888 = LUTBlackCorrection(float3(_2136, _2137, _2138), tTextureMap1, lut_config);
#endif
      float _2899 = ((_2888.x - _2883) * ColorCorrectTexture_m0[0u].y) + _2883;
      float _2900 = ((_2888.y - _2884) * ColorCorrectTexture_m0[0u].y) + _2884;
      float _2901 = ((_2888.z - _2885) * ColorCorrectTexture_m0[0u].y) + _2885;
      float frontier_phi_77_74_ladder;
      float frontier_phi_77_74_ladder_1;
      float frontier_phi_77_74_ladder_2;
      if (ColorCorrectTexture_m0[0u].z > 0.0f) {
#if 0
                float _2937;
                if (_2899 > 0.003130800090730190277099609375f)
                {
                    _2937 = (exp2(log2(_2899) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2937 = _2899 * 12.9200000762939453125f;
                }
                float _2953;
                if (_2900 > 0.003130800090730190277099609375f)
                {
                    _2953 = (exp2(log2(_2900) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2953 = _2900 * 12.9200000762939453125f;
                }
                float _2980;
                if (_2901 > 0.003130800090730190277099609375f)
                {
                    _2980 = (exp2(log2(_2901) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2980 = _2901 * 12.9200000762939453125f;
                }
                float4 _2982 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2937, _2953, _2980), 0.0f);
#else
        float3 _2982 = LUTBlackCorrection(float3(_2899, _2900, _2901), tTextureMap2, lut_config);
#endif
        frontier_phi_77_74_ladder = ((_2982.x - _2899) * ColorCorrectTexture_m0[0u].z) + _2899;
        frontier_phi_77_74_ladder_1 = ((_2982.y - _2900) * ColorCorrectTexture_m0[0u].z) + _2900;
        frontier_phi_77_74_ladder_2 = ((_2982.z - _2901) * ColorCorrectTexture_m0[0u].z) + _2901;
      } else {
        frontier_phi_77_74_ladder = _2899;
        frontier_phi_77_74_ladder_1 = _2900;
        frontier_phi_77_74_ladder_2 = _2901;
      }
      _2905 = frontier_phi_77_74_ladder;
      _2908 = frontier_phi_77_74_ladder_1;
      _2911 = frontier_phi_77_74_ladder_2;
    } else {
#if 0
            float _2935;
            if (_2883 > 0.003130800090730190277099609375f)
            {
                _2935 = (exp2(log2(_2883) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2935 = _2883 * 12.9200000762939453125f;
            }
            float _2951;
            if (_2884 > 0.003130800090730190277099609375f)
            {
                _2951 = (exp2(log2(_2884) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2951 = _2884 * 12.9200000762939453125f;
            }
            float _2967;
            if (_2885 > 0.003130800090730190277099609375f)
            {
                _2967 = (exp2(log2(_2885) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2967 = _2885 * 12.9200000762939453125f;
            }
            float4 _2969 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2935, _2951, _2967), 0.0f);
#else
      float3 _2969 = LUTBlackCorrection(float3(_2883, _2884, _2885), tTextureMap2, lut_config);

#endif
      _2905 = ((_2969.x - _2883) * ColorCorrectTexture_m0[0u].z) + _2883;
      _2908 = ((_2969.y - _2884) * ColorCorrectTexture_m0[0u].z) + _2884;
      _2911 = ((_2969.z - _2885) * ColorCorrectTexture_m0[0u].z) + _2885;
    }
    float _1685 = mad(_2911, ColorCorrectTexture_m0[3u].x, mad(_2908, ColorCorrectTexture_m0[2u].x, _2905 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
    float _1688 = mad(_2911, ColorCorrectTexture_m0[3u].y, mad(_2908, ColorCorrectTexture_m0[2u].y, _2905 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
    float _1691 = mad(_2911, ColorCorrectTexture_m0[3u].z, mad(_2908, ColorCorrectTexture_m0[2u].z, _2905 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
    float frontier_phi_31_77_ladder;
    float frontier_phi_31_77_ladder_1;
    float frontier_phi_31_77_ladder_2;
#if 0
        if (_1721)
        {
            frontier_phi_31_77_ladder = _1691 * _1720;
            frontier_phi_31_77_ladder_1 = _1688 * _1720;
            frontier_phi_31_77_ladder_2 = _1685 * _1720;
        }
        else
        {
            frontier_phi_31_77_ladder = _1691;
            frontier_phi_31_77_ladder_1 = _1688;
            frontier_phi_31_77_ladder_2 = _1685;
        }
        _1683 = frontier_phi_31_77_ladder_2;
        _1686 = frontier_phi_31_77_ladder_1;
        _1689 = frontier_phi_31_77_ladder;

#else
    float3 postprocessColor = float3(_1685, _1688, _1691);
    float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postprocessColor, 1.f);
    _1683 = upgradedColor.r;
    _1686 = upgradedColor.g;
    _1689 = upgradedColor.b;
#endif
  }
  float _2095;
  float _2097;
  float _2099;
  if ((_736 & 8u) == 0u) {
    _2095 = _1683;
    _2097 = _1686;
    _2099 = _1689;
  } else {
    _2095 = clamp(((ColorDeficientTable_m0[0u].x * _1683) + (ColorDeficientTable_m0[0u].y * _1686)) + (ColorDeficientTable_m0[0u].z * _1689), 0.0f, 1.0f);
    _2097 = clamp(((ColorDeficientTable_m0[1u].x * _1683) + (ColorDeficientTable_m0[1u].y * _1686)) + (ColorDeficientTable_m0[1u].z * _1689), 0.0f, 1.0f);
    _2099 = clamp(((ColorDeficientTable_m0[2u].x * _1683) + (ColorDeficientTable_m0[2u].y * _1686)) + (ColorDeficientTable_m0[2u].z * _1689), 0.0f, 1.0f);
  }
  float _2697;
  float _2699;
  float _2701;
  if ((_736 & 16u) == 0u) {
    _2697 = _2095;
    _2699 = _2097;
    _2701 = _2099;
  } else {
    float _2722 = SceneInfo_m0[23u].z * gl_FragCoord.x;
    float _2723 = SceneInfo_m0[23u].w * gl_FragCoord.y;
    float4 _2725 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2722, _2723), 0.0f);
    float _2731 = _2725.x * ImagePlaneParam_m0[0u].x;
    float _2732 = _2725.y * ImagePlaneParam_m0[0u].y;
    float _2733 = _2725.z * ImagePlaneParam_m0[0u].z;
    float _2742 = (_2725.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2722, _2723), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
    _2697 = ((((_2731 < 0.5f) ? ((_2095 * 2.0f) * _2731) : (1.0f - (((1.0f - _2095) * 2.0f) * (1.0f - _2731)))) - _2095) * _2742) + _2095;
    _2699 = ((((_2732 < 0.5f) ? ((_2097 * 2.0f) * _2732) : (1.0f - (((1.0f - _2097) * 2.0f) * (1.0f - _2732)))) - _2097) * _2742) + _2097;
    _2701 = ((((_2733 < 0.5f) ? ((_2099 * 2.0f) * _2733) : (1.0f - (((1.0f - _2099) * 2.0f) * (1.0f - _2733)))) - _2099) * _2742) + _2099;
  }
  SV_Target.x = _2697;
  SV_Target.y = _2699;
  SV_Target.z = _2701;
  SV_Target.w = 0.0f;

#if 1
  SV_Target.rgb = ApplyPreDisplayMap(SV_Target.rgb);
#endif
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
