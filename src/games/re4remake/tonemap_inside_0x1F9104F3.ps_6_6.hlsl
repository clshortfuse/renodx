#include "./LUTBlackCorrection.hlsl"
#include "./shared.h"

cbuffer SceneInfoUBO : register(b0, space0)
{
    float4 SceneInfo_m0[33] : packoffset(c0);
};

// cbuffer TonemapParamUBO : register(b1, space0)
// {
//     float4 TonemapParam_m0[3] : packoffset(c0);
// };
cbuffer TonemapParamUBO : register(b1, space0)
{
  // TonemapParam_m0[0u]
  float contrast;                        // TonemapParam_m0[0u].x
  float linearBegin;                     // TonemapParam_m0[0u].y
  float linearLength;                    // TonemapParam_m0[0u].z
  float toe;                             // TonemapParam_m0[0u].w

  // TonemapParam_m0[1u]
  float maxNit;                          // TonemapParam_m0[1u].x
  float linearStart;                     // TonemapParam_m0[1u].y
  float displayMaxNitSubContrastFactor;  // TonemapParam_m0[1u].z
  float contrastFactor;                  // TonemapParam_m0[1u].w

  // TonemapParam_m0[2u]
  float mulLinearStartContrastFactor;    // TonemapParam_m0[2u].x
  float invLinearBegin;                  // TonemapParam_m0[2u].y
  float madLinearStartContrastFactor;    // TonemapParam_m0[2u].z
};

cbuffer CBHazeFilterParamsUBO : register(b2, space0)
{
    float4 CBHazeFilterParams_m0[4] : packoffset(c0);
};

cbuffer LensDistortionParamUBO : register(b3, space0)
{
    float4 LensDistortionParam_m0[2] : packoffset(c0);
};

cbuffer PaniniProjectionParamUBO : register(b4, space0)
{
    float4 PaniniProjectionParam_m0[1] : packoffset(c0);
};

cbuffer RadialBlurRenderParamUBO : register(b5, space0)
{
    float4 RadialBlurRenderParam_m0[4] : packoffset(c0);
};

cbuffer FilmGrainParamUBO : register(b6, space0)
{
    float4 FilmGrainParam_m0[2] : packoffset(c0);
};

cbuffer ColorCorrectTextureUBO : register(b7, space0)
{
    float4 ColorCorrectTexture_m0[5] : packoffset(c0);
};

cbuffer ColorDeficientTableUBO : register(b8, space0)
{
    float4 ColorDeficientTable_m0[3] : packoffset(c0);
};

cbuffer ImagePlaneParamUBO : register(b9, space0)
{
    float4 ImagePlaneParam_m0[2] : packoffset(c0);
};

cbuffer CBControlUBO : register(b10, space0)
{
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
SamplerState PointClamp : register(s1, space32);
SamplerState BilinearWrap : register(s4, space32);
SamplerState BilinearClamp : register(s5, space32);
SamplerState BilinearBorder : register(s6, space32);
SamplerState TrilinearClamp : register(s9, space32);

static float4 gl_FragCoord;
static float4 Kerare;
static float Exposure;
static float4 SV_Target;

struct SPIRV_Cross_Input
{
    float4 gl_FragCoord : SV_Position;
    float4 Kerare : Kerare;
    float Exposure : Exposure;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
};

void frag_main()
{
  // Map cbuffer variables to TonemapParam_m0 indices
  float4 TonemapParam_m0[3u];
  TonemapParam_m0[0u] = float4(contrast, linearBegin, linearLength, toe);
  TonemapParam_m0[1u] = float4(maxNit, linearStart, displayMaxNitSubContrastFactor, contrastFactor);
  TonemapParam_m0[2u] = float4(mulLinearStartContrastFactor, invLinearBegin, madLinearStartContrastFactor, 0.0);

  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      injectedData.colorGradeLUTStrength,
      injectedData.colorGradeLUTScaling,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      ColorCorrectTexture_m0[0u].x);

  if (injectedData.toneMapType != 0) {
    TonemapParam_m0[0u].x *= injectedData.colorGradeHighlightContrast;   // contrast
    TonemapParam_m0[0u].w *= injectedData.colorGradeShadowToe;           // toe
    TonemapParam_m0[1u].x = 125;                                         // maxNit
    TonemapParam_m0[1u].y = 125;                                         // linearStart
  }    
  uint4 _98 = asuint(CBControl_m0[0u]);
    uint _99 = _98.x;
    bool _102 = (_99 & 1u) != 0u;
    uint4 _105 = asuint(LensDistortionParam_m0[0u]);
    uint _106 = _105.w;
    bool _108 = _102 && (_106 == 0u);
    bool _110 = _102 && (_106 == 1u);
    uint _113 = (_99 >> 6u) & 1u;
    float _472;
    float _475;
    float _479;
    float _483;
    float _484;
    float _485;
    float _486;
    float _487;
    float _488;
    if (_108)
    {
        float _129 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
        float _131 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
        float _132 = dot(float2(_129, _131), float2(_129, _131));
        float _139 = ((_132 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
        float _140 = _139 * _129;
        float _141 = _139 * _131;
        float _142 = _140 + 0.5f;
        float _144 = _141 + 0.5f;
        float frontier_phi_16_1_ladder;
        float frontier_phi_16_1_ladder_1;
        float frontier_phi_16_1_ladder_2;
        float frontier_phi_16_1_ladder_3;
        float frontier_phi_16_1_ladder_4;
        float frontier_phi_16_1_ladder_5;
        float frontier_phi_16_1_ladder_6;
        float frontier_phi_16_1_ladder_7;
        float frontier_phi_16_1_ladder_8;
        if (_105.z == 0u)
        {
            float _222;
            float _224;
            if (_113 == 0u)
            {
                _222 = _142;
                _224 = _144;
            }
            else
            {
                uint4 _245 = asuint(CBHazeFilterParams_m0[3u]);
                uint _246 = _245.x;
                bool _249 = (_246 & 2u) == 0u;
                float4 _253 = tFilterTempMap1.Sample(BilinearWrap, float2(_142, _144));
                float _255 = _253.x;
                float _988;
                float _989;
                if (_249)
                {
                    _988 = ((_246 & 1u) == 0u) ? _255 : (1.0f - _255);
                    _989 = 0.0f;
                }
                else
                {
                    float4 _499 = ReadonlyDepth.SampleLevel(PointClamp, float2(_142, _144), 0.0f);
                    float _501 = _499.x;
                    float _508 = (((_142 * 2.0f) * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].z) + (-1.0f);
                    float _509 = 1.0f - (((_144 * 2.0f) * SceneInfo_m0[23u].y) * SceneInfo_m0[23u].w);
                    float _554 = 1.0f / (mad(_501, SceneInfo_m0[16u].w, mad(_509, SceneInfo_m0[15u].w, _508 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
                    float _556 = _554 * (mad(_501, SceneInfo_m0[16u].y, mad(_509, SceneInfo_m0[15u].y, _508 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
                    float _570 = (_554 * (mad(_501, SceneInfo_m0[16u].x, mad(_509, SceneInfo_m0[15u].x, _508 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
                    float _571 = _556 - SceneInfo_m0[8u].w;
                    float _572 = (_554 * (mad(_501, SceneInfo_m0[16u].z, mad(_509, SceneInfo_m0[15u].z, _508 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
                    _988 = clamp(_255 * max((sqrt(((_571 * _571) + (_570 * _570)) + (_572 * _572)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_556 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
                    _989 = _501;
                }
                float _995 = (-0.0f) - _144;
                float _1022 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_995, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _142));
                float _1023 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_995, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _142));
                float _1024 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_995, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _142));
                float _1037 = _1022 * 2.0f;
                float _1038 = _1023 * 2.0f;
                float _1039 = _1024 * 2.0f;
                float _1049 = _1022 * 4.0f;
                float _1051 = _1023 * 4.0f;
                float _1052 = _1024 * 4.0f;
                float _1062 = _1022 * 8.0f;
                float _1064 = _1023 * 8.0f;
                float _1065 = _1024 * 8.0f;
                float _1075 = CBHazeFilterParams_m0[1u].x + 0.5f;
                float _1076 = CBHazeFilterParams_m0[1u].y + 0.5f;
                float _1077 = CBHazeFilterParams_m0[1u].z + 0.5f;
                float _1117 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1037 + CBHazeFilterParams_m0[1u].x, _1038 + CBHazeFilterParams_m0[1u].y, _1039 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1022 + CBHazeFilterParams_m0[1u].x, _1023 + CBHazeFilterParams_m0[1u].y, _1024 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1049 + CBHazeFilterParams_m0[1u].x, _1051 + CBHazeFilterParams_m0[1u].y, _1052 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1062 + CBHazeFilterParams_m0[1u].x, _1064 + CBHazeFilterParams_m0[1u].y, _1065 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _988) * CBHazeFilterParams_m0[2u].x;
                float _1119 = (CBHazeFilterParams_m0[2u].x * _988) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1037 + _1075, _1038 + _1076, _1039 + _1077)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1022 + _1075, _1023 + _1076, _1024 + _1077)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1049 + _1075, _1051 + _1076, _1052 + _1077)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1062 + _1075, _1064 + _1076, _1065 + _1077)).x * 0.0625f)) * 2.0f) + (-1.0f));
                float _1719;
                float _1721;
                if ((_246 & 4u) == 0u)
                {
                    _1719 = _1117;
                    _1721 = _1119;
                }
                else
                {
                    float _1732 = 0.5f / CBHazeFilterParams_m0[2u].y;
                    float _1739 = clamp(max((_1732 * min(max(abs(_140) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1732 * min(max(abs(_141) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
                    _1719 = _1117 - (_1739 * _1117);
                    _1721 = _1119 - (_1739 * _1119);
                }
                float _2064;
                float _2065;
                if (_249)
                {
                    _2064 = _1719;
                    _2065 = _1721;
                }
                else
                {
                    float frontier_phi_49_50_ladder;
                    float frontier_phi_49_50_ladder_1;
                    if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1719 + _142, _1721 + _144)).x - _989) < CBHazeFilterParams_m0[2u].w)
                    {
                        frontier_phi_49_50_ladder = _1721;
                        frontier_phi_49_50_ladder_1 = _1719;
                    }
                    else
                    {
                        frontier_phi_49_50_ladder = 0.0f;
                        frontier_phi_49_50_ladder_1 = 0.0f;
                    }
                    _2064 = frontier_phi_49_50_ladder_1;
                    _2065 = frontier_phi_49_50_ladder;
                }
                _222 = _2064 + _142;
                _224 = _2065 + _144;
            }
            float4 _229 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_222, _224));
            float _234 = _229.x * Exposure;
            float _235 = _229.y * Exposure;
            float _236 = _229.z * Exposure;
            float _238 = max(max(_234, _235), _236);
            float frontier_phi_16_1_ladder_7_ladder;
            float frontier_phi_16_1_ladder_7_ladder_1;
            float frontier_phi_16_1_ladder_7_ladder_2;
            float frontier_phi_16_1_ladder_7_ladder_3;
            float frontier_phi_16_1_ladder_7_ladder_4;
            float frontier_phi_16_1_ladder_7_ladder_5;
            float frontier_phi_16_1_ladder_7_ladder_6;
            float frontier_phi_16_1_ladder_7_ladder_7;
            float frontier_phi_16_1_ladder_7_ladder_8;
            if (!(isnan(_238) || isinf(_238)))
            {
                float _378 = TonemapParam_m0[2u].y * _234;
                float _384 = TonemapParam_m0[2u].y * _235;
                float _390 = TonemapParam_m0[2u].y * _236;
                float _397 = (_234 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_378 * _378) * (3.0f - (_378 * 2.0f))));
                float _399 = (_235 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_384 * _384) * (3.0f - (_384 * 2.0f))));
                float _401 = (_236 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_390 * _390) * (3.0f - (_390 * 2.0f))));
                float _408 = (_234 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _409 = (_235 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _410 = (_236 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_1_ladder_7_ladder = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_1 = ((((TonemapParam_m0[0u].x * _234) + TonemapParam_m0[2u].z) * ((1.0f - _408) - _397)) + ((exp2(log2(_378) * TonemapParam_m0[0u].w) * _397) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _234) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _408);
                frontier_phi_16_1_ladder_7_ladder_2 = ((((TonemapParam_m0[0u].x * _235) + TonemapParam_m0[2u].z) * ((1.0f - _409) - _399)) + ((exp2(log2(_384) * TonemapParam_m0[0u].w) * _399) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _235) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _409);
                frontier_phi_16_1_ladder_7_ladder_3 = ((((TonemapParam_m0[0u].x * _236) + TonemapParam_m0[2u].z) * ((1.0f - _410) - _401)) + ((exp2(log2(_390) * TonemapParam_m0[0u].w) * _401) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _236) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _410);
                frontier_phi_16_1_ladder_7_ladder_4 = LensDistortionParam_m0[0u].x;
                frontier_phi_16_1_ladder_7_ladder_5 = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_6 = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_7 = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_8 = LensDistortionParam_m0[1u].x;
            }
            else
            {
                frontier_phi_16_1_ladder_7_ladder = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_1 = 1.0f;
                frontier_phi_16_1_ladder_7_ladder_2 = 1.0f;
                frontier_phi_16_1_ladder_7_ladder_3 = 1.0f;
                frontier_phi_16_1_ladder_7_ladder_4 = LensDistortionParam_m0[0u].x;
                frontier_phi_16_1_ladder_7_ladder_5 = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_6 = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_7 = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_8 = LensDistortionParam_m0[1u].x;
            }
            frontier_phi_16_1_ladder = frontier_phi_16_1_ladder_7_ladder;
            frontier_phi_16_1_ladder_1 = frontier_phi_16_1_ladder_7_ladder_1;
            frontier_phi_16_1_ladder_2 = frontier_phi_16_1_ladder_7_ladder_2;
            frontier_phi_16_1_ladder_3 = frontier_phi_16_1_ladder_7_ladder_3;
            frontier_phi_16_1_ladder_4 = frontier_phi_16_1_ladder_7_ladder_4;
            frontier_phi_16_1_ladder_5 = frontier_phi_16_1_ladder_7_ladder_5;
            frontier_phi_16_1_ladder_6 = frontier_phi_16_1_ladder_7_ladder_6;
            frontier_phi_16_1_ladder_7 = frontier_phi_16_1_ladder_7_ladder_7;
            frontier_phi_16_1_ladder_8 = frontier_phi_16_1_ladder_7_ladder_8;
        }
        else
        {
            float _150 = _132 + LensDistortionParam_m0[0u].y;
            float _152 = (_150 * LensDistortionParam_m0[0u].x) + 1.0f;
            float _153 = _129 * LensDistortionParam_m0[1u].x;
            float _155 = _131 * LensDistortionParam_m0[1u].x;
            float _161 = ((_150 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
            float4 _171 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_142, _144));
            float _176 = _171.x * Exposure;
            float _181 = max(max(_176, _171.y * Exposure), _171.z * Exposure);
            float _301;
            if (!(isnan(_181) || isinf(_181)))
            {
                float _262 = TonemapParam_m0[2u].y * _176;
                float _270 = (_176 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_262 * _262) * (3.0f - (_262 * 2.0f))));
                float _275 = (_176 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                _301 = ((((TonemapParam_m0[0u].x * _176) + TonemapParam_m0[2u].z) * ((1.0f - _275) - _270)) + ((TonemapParam_m0[0u].y * exp2(log2(_262) * TonemapParam_m0[0u].w)) * _270)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _176) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _275);
            }
            else
            {
                _301 = 1.0f;
            }
            float4 _303 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_153 * _152) + 0.5f, (_155 * _152) + 0.5f));
            float _309 = _303.y * Exposure;
            float _312 = max(max(_303.x * Exposure, _309), _303.z * Exposure);
            float _476;
            if (!(isnan(_312) || isinf(_312)))
            {
                float _598 = TonemapParam_m0[2u].y * _309;
                float _605 = (_309 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_598 * _598) * (3.0f - (_598 * 2.0f))));
                float _610 = (_309 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                _476 = ((((TonemapParam_m0[0u].x * _309) + TonemapParam_m0[2u].z) * ((1.0f - _610) - _605)) + ((TonemapParam_m0[0u].y * exp2(log2(_598) * TonemapParam_m0[0u].w)) * _605)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _309) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _610);
            }
            else
            {
                _476 = 1.0f;
            }
            float4 _637 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_153 * _161) + 0.5f, (_155 * _161) + 0.5f));
            float _644 = _637.z * Exposure;
            float _646 = max(max(_637.x * Exposure, _637.y * Exposure), _644);
            float frontier_phi_16_1_ladder_20_ladder;
            float frontier_phi_16_1_ladder_20_ladder_1;
            float frontier_phi_16_1_ladder_20_ladder_2;
            float frontier_phi_16_1_ladder_20_ladder_3;
            float frontier_phi_16_1_ladder_20_ladder_4;
            float frontier_phi_16_1_ladder_20_ladder_5;
            float frontier_phi_16_1_ladder_20_ladder_6;
            float frontier_phi_16_1_ladder_20_ladder_7;
            float frontier_phi_16_1_ladder_20_ladder_8;
            if (!(isnan(_646) || isinf(_646)))
            {
                float _1127 = TonemapParam_m0[2u].y * _644;
                float _1134 = (_644 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1127 * _1127) * (3.0f - (_1127 * 2.0f))));
                float _1139 = (_644 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_1_ladder_20_ladder = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_1 = _301;
                frontier_phi_16_1_ladder_20_ladder_2 = _476;
                frontier_phi_16_1_ladder_20_ladder_3 = ((((TonemapParam_m0[0u].x * _644) + TonemapParam_m0[2u].z) * ((1.0f - _1139) - _1134)) + ((TonemapParam_m0[0u].y * exp2(log2(_1127) * TonemapParam_m0[0u].w)) * _1134)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _644) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1139);
                frontier_phi_16_1_ladder_20_ladder_4 = LensDistortionParam_m0[0u].x;
                frontier_phi_16_1_ladder_20_ladder_5 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_6 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_7 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_8 = LensDistortionParam_m0[1u].x;
            }
            else
            {
                frontier_phi_16_1_ladder_20_ladder = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_1 = _301;
                frontier_phi_16_1_ladder_20_ladder_2 = _476;
                frontier_phi_16_1_ladder_20_ladder_3 = 1.0f;
                frontier_phi_16_1_ladder_20_ladder_4 = LensDistortionParam_m0[0u].x;
                frontier_phi_16_1_ladder_20_ladder_5 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_6 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_7 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_8 = LensDistortionParam_m0[1u].x;
            }
            frontier_phi_16_1_ladder = frontier_phi_16_1_ladder_20_ladder;
            frontier_phi_16_1_ladder_1 = frontier_phi_16_1_ladder_20_ladder_1;
            frontier_phi_16_1_ladder_2 = frontier_phi_16_1_ladder_20_ladder_2;
            frontier_phi_16_1_ladder_3 = frontier_phi_16_1_ladder_20_ladder_3;
            frontier_phi_16_1_ladder_4 = frontier_phi_16_1_ladder_20_ladder_4;
            frontier_phi_16_1_ladder_5 = frontier_phi_16_1_ladder_20_ladder_5;
            frontier_phi_16_1_ladder_6 = frontier_phi_16_1_ladder_20_ladder_6;
            frontier_phi_16_1_ladder_7 = frontier_phi_16_1_ladder_20_ladder_7;
            frontier_phi_16_1_ladder_8 = frontier_phi_16_1_ladder_20_ladder_8;
        }
        _472 = frontier_phi_16_1_ladder_1;
        _475 = frontier_phi_16_1_ladder_2;
        _479 = frontier_phi_16_1_ladder_3;
        _483 = frontier_phi_16_1_ladder_4;
        _484 = frontier_phi_16_1_ladder_5;
        _485 = frontier_phi_16_1_ladder_6;
        _486 = frontier_phi_16_1_ladder;
        _487 = frontier_phi_16_1_ladder_7;
        _488 = frontier_phi_16_1_ladder_8;
    }
    else
    {
        bool _146 = _113 == 0u;
        float frontier_phi_16_2_ladder;
        float frontier_phi_16_2_ladder_1;
        float frontier_phi_16_2_ladder_2;
        float frontier_phi_16_2_ladder_3;
        float frontier_phi_16_2_ladder_4;
        float frontier_phi_16_2_ladder_5;
        float frontier_phi_16_2_ladder_6;
        float frontier_phi_16_2_ladder_7;
        float frontier_phi_16_2_ladder_8;
        if (_110)
        {
            float _197 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
            float _202 = sqrt((_197 * _197) + 1.0f);
            float _203 = 1.0f / _202;
            float _206 = (_202 * PaniniProjectionParam_m0[0u].z) * (_203 + PaniniProjectionParam_m0[0u].x);
            float _210 = PaniniProjectionParam_m0[0u].w * 0.5f;
            float _212 = (_210 * _197) * _206;
            float _215 = ((_210 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_203 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _206;
            float _216 = _212 + 0.5f;
            float _217 = _215 + 0.5f;
            float _317;
            float _319;
            if (_146)
            {
                _317 = _216;
                _319 = _217;
            }
            else
            {
                uint4 _340 = asuint(CBHazeFilterParams_m0[3u]);
                uint _341 = _340.x;
                bool _344 = (_341 & 2u) == 0u;
                float4 _348 = tFilterTempMap1.Sample(BilinearWrap, float2(_216, _217));
                float _350 = _348.x;
                float _1164;
                float _1165;
                if (_344)
                {
                    _1164 = ((_341 & 1u) == 0u) ? _350 : (1.0f - _350);
                    _1165 = 0.0f;
                }
                else
                {
                    float4 _755 = ReadonlyDepth.SampleLevel(PointClamp, float2(_216, _217), 0.0f);
                    float _757 = _755.x;
                    float _764 = (((SceneInfo_m0[23u].x * 2.0f) * _216) * SceneInfo_m0[23u].z) + (-1.0f);
                    float _765 = 1.0f - (((SceneInfo_m0[23u].y * 2.0f) * _217) * SceneInfo_m0[23u].w);
                    float _806 = 1.0f / (mad(_757, SceneInfo_m0[16u].w, mad(_765, SceneInfo_m0[15u].w, _764 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
                    float _808 = _806 * (mad(_757, SceneInfo_m0[16u].y, mad(_765, SceneInfo_m0[15u].y, _764 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
                    float _819 = (_806 * (mad(_757, SceneInfo_m0[16u].x, mad(_765, SceneInfo_m0[15u].x, _764 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
                    float _820 = _808 - SceneInfo_m0[8u].w;
                    float _821 = (_806 * (mad(_757, SceneInfo_m0[16u].z, mad(_765, SceneInfo_m0[15u].z, _764 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
                    _1164 = clamp(_350 * max((sqrt(((_820 * _820) + (_819 * _819)) + (_821 * _821)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_808 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
                    _1165 = _757;
                }
                float _1171 = (-0.0f) - _217;
                float _1197 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1171, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _216));
                float _1198 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1171, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _216));
                float _1199 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1171, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _216));
                float _1210 = _1197 * 2.0f;
                float _1211 = _1198 * 2.0f;
                float _1212 = _1199 * 2.0f;
                float _1221 = _1197 * 4.0f;
                float _1222 = _1198 * 4.0f;
                float _1223 = _1199 * 4.0f;
                float _1232 = _1197 * 8.0f;
                float _1233 = _1198 * 8.0f;
                float _1234 = _1199 * 8.0f;
                float _1243 = CBHazeFilterParams_m0[1u].x + 0.5f;
                float _1244 = CBHazeFilterParams_m0[1u].y + 0.5f;
                float _1245 = CBHazeFilterParams_m0[1u].z + 0.5f;
                float _1285 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1210 + CBHazeFilterParams_m0[1u].x, _1211 + CBHazeFilterParams_m0[1u].y, _1212 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1197 + CBHazeFilterParams_m0[1u].x, _1198 + CBHazeFilterParams_m0[1u].y, _1199 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1221 + CBHazeFilterParams_m0[1u].x, _1222 + CBHazeFilterParams_m0[1u].y, _1223 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1232 + CBHazeFilterParams_m0[1u].x, _1233 + CBHazeFilterParams_m0[1u].y, _1234 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1164) * CBHazeFilterParams_m0[2u].x;
                float _1287 = (CBHazeFilterParams_m0[2u].x * _1164) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1210 + _1243, _1211 + _1244, _1212 + _1245)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1197 + _1243, _1198 + _1244, _1199 + _1245)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1221 + _1243, _1222 + _1244, _1223 + _1245)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1232 + _1243, _1233 + _1244, _1234 + _1245)).x * 0.0625f)) * 2.0f) + (-1.0f));
                float _1742;
                float _1744;
                if ((_341 & 4u) == 0u)
                {
                    _1742 = _1285;
                    _1744 = _1287;
                }
                else
                {
                    float _1755 = 0.5f / CBHazeFilterParams_m0[2u].y;
                    float _1762 = clamp(max((_1755 * min(max(abs(_212) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1755 * min(max(abs(_215) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
                    _1742 = _1285 - (_1762 * _1285);
                    _1744 = _1287 - (_1762 * _1287);
                }
                float _2076;
                float _2077;
                if (_344)
                {
                    _2076 = _1742;
                    _2077 = _1744;
                }
                else
                {
                    float frontier_phi_51_52_ladder;
                    float frontier_phi_51_52_ladder_1;
                    if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1742 + _216, _1744 + _217)).x - _1165) < CBHazeFilterParams_m0[2u].w)
                    {
                        frontier_phi_51_52_ladder = _1744;
                        frontier_phi_51_52_ladder_1 = _1742;
                    }
                    else
                    {
                        frontier_phi_51_52_ladder = 0.0f;
                        frontier_phi_51_52_ladder_1 = 0.0f;
                    }
                    _2076 = frontier_phi_51_52_ladder_1;
                    _2077 = frontier_phi_51_52_ladder;
                }
                _317 = _2076 + _216;
                _319 = _2077 + _217;
            }
            float4 _324 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_317, _319));
            float _329 = _324.x * Exposure;
            float _330 = _324.y * Exposure;
            float _331 = _324.z * Exposure;
            float _333 = max(max(_329, _330), _331);
            float frontier_phi_16_2_ladder_11_ladder;
            float frontier_phi_16_2_ladder_11_ladder_1;
            float frontier_phi_16_2_ladder_11_ladder_2;
            float frontier_phi_16_2_ladder_11_ladder_3;
            float frontier_phi_16_2_ladder_11_ladder_4;
            float frontier_phi_16_2_ladder_11_ladder_5;
            float frontier_phi_16_2_ladder_11_ladder_6;
            float frontier_phi_16_2_ladder_11_ladder_7;
            float frontier_phi_16_2_ladder_11_ladder_8;
            if (!(isnan(_333) || isinf(_333)))
            {
                float _657 = TonemapParam_m0[2u].y * _329;
                float _663 = TonemapParam_m0[2u].y * _330;
                float _669 = TonemapParam_m0[2u].y * _331;
                float _676 = (_329 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_657 * _657) * (3.0f - (_657 * 2.0f))));
                float _678 = (_330 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_663 * _663) * (3.0f - (_663 * 2.0f))));
                float _680 = (_331 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_669 * _669) * (3.0f - (_669 * 2.0f))));
                float _687 = (_329 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _688 = (_330 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _689 = (_331 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_2_ladder_11_ladder = PaniniProjectionParam_m0[0u].z;
                frontier_phi_16_2_ladder_11_ladder_1 = ((((TonemapParam_m0[0u].x * _329) + TonemapParam_m0[2u].z) * ((1.0f - _687) - _676)) + ((exp2(log2(_657) * TonemapParam_m0[0u].w) * _676) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _329) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _687);
                frontier_phi_16_2_ladder_11_ladder_2 = ((((TonemapParam_m0[0u].x * _330) + TonemapParam_m0[2u].z) * ((1.0f - _688) - _678)) + ((exp2(log2(_663) * TonemapParam_m0[0u].w) * _678) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _330) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _688);
                frontier_phi_16_2_ladder_11_ladder_3 = ((((TonemapParam_m0[0u].x * _331) + TonemapParam_m0[2u].z) * ((1.0f - _689) - _680)) + ((exp2(log2(_669) * TonemapParam_m0[0u].w) * _680) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _331) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _689);
                frontier_phi_16_2_ladder_11_ladder_4 = 0.0f;
                frontier_phi_16_2_ladder_11_ladder_5 = PaniniProjectionParam_m0[0u].x;
                frontier_phi_16_2_ladder_11_ladder_6 = PaniniProjectionParam_m0[0u].y;
                frontier_phi_16_2_ladder_11_ladder_7 = PaniniProjectionParam_m0[0u].w;
                frontier_phi_16_2_ladder_11_ladder_8 = 1.0f;
            }
            else
            {
                frontier_phi_16_2_ladder_11_ladder = PaniniProjectionParam_m0[0u].z;
                frontier_phi_16_2_ladder_11_ladder_1 = 1.0f;
                frontier_phi_16_2_ladder_11_ladder_2 = 1.0f;
                frontier_phi_16_2_ladder_11_ladder_3 = 1.0f;
                frontier_phi_16_2_ladder_11_ladder_4 = 0.0f;
                frontier_phi_16_2_ladder_11_ladder_5 = PaniniProjectionParam_m0[0u].x;
                frontier_phi_16_2_ladder_11_ladder_6 = PaniniProjectionParam_m0[0u].y;
                frontier_phi_16_2_ladder_11_ladder_7 = PaniniProjectionParam_m0[0u].w;
                frontier_phi_16_2_ladder_11_ladder_8 = 1.0f;
            }
            frontier_phi_16_2_ladder = frontier_phi_16_2_ladder_11_ladder;
            frontier_phi_16_2_ladder_1 = frontier_phi_16_2_ladder_11_ladder_1;
            frontier_phi_16_2_ladder_2 = frontier_phi_16_2_ladder_11_ladder_2;
            frontier_phi_16_2_ladder_3 = frontier_phi_16_2_ladder_11_ladder_3;
            frontier_phi_16_2_ladder_4 = frontier_phi_16_2_ladder_11_ladder_4;
            frontier_phi_16_2_ladder_5 = frontier_phi_16_2_ladder_11_ladder_5;
            frontier_phi_16_2_ladder_6 = frontier_phi_16_2_ladder_11_ladder_6;
            frontier_phi_16_2_ladder_7 = frontier_phi_16_2_ladder_11_ladder_7;
            frontier_phi_16_2_ladder_8 = frontier_phi_16_2_ladder_11_ladder_8;
        }
        else
        {
            float _220 = SceneInfo_m0[23u].z * gl_FragCoord.x;
            float _221 = SceneInfo_m0[23u].w * gl_FragCoord.y;
            float _841;
            float _843;
            float _845;
            if (_146)
            {
                float4 _354 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_220, _221));
                _841 = _354.x;
                _843 = _354.y;
                _845 = _354.z;
            }
            else
            {
                uint4 _361 = asuint(CBHazeFilterParams_m0[3u]);
                uint _362 = _361.x;
                bool _365 = (_362 & 2u) == 0u;
                float4 _369 = tFilterTempMap1.Sample(BilinearWrap, float2(_220, _221));
                float _371 = _369.x;
                float _1386;
                float _1387;
                if (_365)
                {
                    _1386 = ((_362 & 1u) == 0u) ? _371 : (1.0f - _371);
                    _1387 = 0.0f;
                }
                else
                {
                    float4 _863 = ReadonlyDepth.SampleLevel(PointClamp, float2(_220, _221), 0.0f);
                    float _865 = _863.x;
                    float _870 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
                    float _871 = 1.0f - ((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w);
                    float _912 = 1.0f / (mad(_865, SceneInfo_m0[16u].w, mad(_871, SceneInfo_m0[15u].w, _870 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
                    float _914 = _912 * (mad(_865, SceneInfo_m0[16u].y, mad(_871, SceneInfo_m0[15u].y, _870 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
                    float _925 = (_912 * (mad(_865, SceneInfo_m0[16u].x, mad(_871, SceneInfo_m0[15u].x, _870 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
                    float _926 = _914 - SceneInfo_m0[8u].w;
                    float _927 = (_912 * (mad(_865, SceneInfo_m0[16u].z, mad(_871, SceneInfo_m0[15u].z, _870 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
                    _1386 = clamp(_371 * max((sqrt(((_926 * _926) + (_925 * _925)) + (_927 * _927)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_914 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
                    _1387 = _865;
                }
                float _1393 = (-0.0f) - _221;
                float _1419 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1393, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _220));
                float _1420 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1393, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _220));
                float _1421 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1393, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _220));
                float _1432 = _1419 * 2.0f;
                float _1433 = _1420 * 2.0f;
                float _1434 = _1421 * 2.0f;
                float _1443 = _1419 * 4.0f;
                float _1444 = _1420 * 4.0f;
                float _1445 = _1421 * 4.0f;
                float _1454 = _1419 * 8.0f;
                float _1455 = _1420 * 8.0f;
                float _1456 = _1421 * 8.0f;
                float _1465 = CBHazeFilterParams_m0[1u].x + 0.5f;
                float _1466 = CBHazeFilterParams_m0[1u].y + 0.5f;
                float _1467 = CBHazeFilterParams_m0[1u].z + 0.5f;
                float4 _1494 = tVolumeMap.Sample(BilinearWrap, float3(_1454 + _1465, _1455 + _1466, _1456 + _1467));
                float _1507 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1432 + CBHazeFilterParams_m0[1u].x, _1433 + CBHazeFilterParams_m0[1u].y, _1434 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1419 + CBHazeFilterParams_m0[1u].x, _1420 + CBHazeFilterParams_m0[1u].y, _1421 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1443 + CBHazeFilterParams_m0[1u].x, _1444 + CBHazeFilterParams_m0[1u].y, _1445 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1454 + CBHazeFilterParams_m0[1u].x, _1455 + CBHazeFilterParams_m0[1u].y, _1456 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1386) * CBHazeFilterParams_m0[2u].x;
                float _1509 = (CBHazeFilterParams_m0[2u].x * _1386) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1432 + _1465, _1433 + _1466, _1434 + _1467)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1419 + _1465, _1420 + _1466, _1421 + _1467)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1443 + _1465, _1444 + _1466, _1445 + _1467)).x * 0.125f)) + (_1494.x * 0.0625f)) * 2.0f) + (-1.0f));
                float _1765;
                float _1767;
                if ((_362 & 4u) == 0u)
                {
                    _1765 = _1507;
                    _1767 = _1509;
                }
                else
                {
                    float _1780 = 0.5f / CBHazeFilterParams_m0[2u].y;
                    float _1787 = clamp(max((_1780 * min(max(abs(_220 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1780 * min(max(abs(_221 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
                    _1765 = _1507 - (_1787 * _1507);
                    _1767 = _1509 - (_1787 * _1509);
                }
                float _2088;
                float _2089;
                if (_365)
                {
                    _2088 = _1765;
                    _2089 = _1767;
                }
                else
                {
                    float frontier_phi_53_54_ladder;
                    float frontier_phi_53_54_ladder_1;
                    if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1765 + _220, _1767 + _221)).x - _1387) < CBHazeFilterParams_m0[2u].w)
                    {
                        frontier_phi_53_54_ladder = _1767;
                        frontier_phi_53_54_ladder_1 = _1765;
                    }
                    else
                    {
                        frontier_phi_53_54_ladder = 0.0f;
                        frontier_phi_53_54_ladder_1 = 0.0f;
                    }
                    _2088 = frontier_phi_53_54_ladder_1;
                    _2089 = frontier_phi_53_54_ladder;
                }
                float4 _2095 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_2088 + _220, _2089 + _221));
                _841 = _2095.x;
                _843 = _2095.y;
                _845 = _2095.z;
            }
            float _847 = _841 * Exposure;
            float _848 = _843 * Exposure;
            float _849 = _845 * Exposure;
            float _851 = max(max(_847, _848), _849);
            float frontier_phi_16_2_ladder_24_ladder;
            float frontier_phi_16_2_ladder_24_ladder_1;
            float frontier_phi_16_2_ladder_24_ladder_2;
            float frontier_phi_16_2_ladder_24_ladder_3;
            float frontier_phi_16_2_ladder_24_ladder_4;
            float frontier_phi_16_2_ladder_24_ladder_5;
            float frontier_phi_16_2_ladder_24_ladder_6;
            float frontier_phi_16_2_ladder_24_ladder_7;
            float frontier_phi_16_2_ladder_24_ladder_8;
            if (!(isnan(_851) || isinf(_851)))
            {
                float _1295 = TonemapParam_m0[2u].y * _847;
                float _1301 = TonemapParam_m0[2u].y * _848;
                float _1307 = TonemapParam_m0[2u].y * _849;
                float _1314 = (_847 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1295 * _1295) * (3.0f - (_1295 * 2.0f))));
                float _1316 = (_848 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1301 * _1301) * (3.0f - (_1301 * 2.0f))));
                float _1318 = (_849 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1307 * _1307) * (3.0f - (_1307 * 2.0f))));
                float _1325 = (_847 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _1326 = (_848 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _1327 = (_849 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_2_ladder_24_ladder = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_1 = ((((TonemapParam_m0[0u].x * _847) + TonemapParam_m0[2u].z) * ((1.0f - _1325) - _1314)) + ((exp2(log2(_1295) * TonemapParam_m0[0u].w) * _1314) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _847) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1325);
                frontier_phi_16_2_ladder_24_ladder_2 = ((((TonemapParam_m0[0u].x * _848) + TonemapParam_m0[2u].z) * ((1.0f - _1326) - _1316)) + ((exp2(log2(_1301) * TonemapParam_m0[0u].w) * _1316) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _848) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1326);
                frontier_phi_16_2_ladder_24_ladder_3 = ((((TonemapParam_m0[0u].x * _849) + TonemapParam_m0[2u].z) * ((1.0f - _1327) - _1318)) + ((exp2(log2(_1307) * TonemapParam_m0[0u].w) * _1318) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _849) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1327);
                frontier_phi_16_2_ladder_24_ladder_4 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_5 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_6 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_7 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_8 = 1.0f;
            }
            else
            {
                frontier_phi_16_2_ladder_24_ladder = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_1 = 1.0f;
                frontier_phi_16_2_ladder_24_ladder_2 = 1.0f;
                frontier_phi_16_2_ladder_24_ladder_3 = 1.0f;
                frontier_phi_16_2_ladder_24_ladder_4 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_5 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_6 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_7 = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_8 = 1.0f;
            }
            frontier_phi_16_2_ladder = frontier_phi_16_2_ladder_24_ladder;
            frontier_phi_16_2_ladder_1 = frontier_phi_16_2_ladder_24_ladder_1;
            frontier_phi_16_2_ladder_2 = frontier_phi_16_2_ladder_24_ladder_2;
            frontier_phi_16_2_ladder_3 = frontier_phi_16_2_ladder_24_ladder_3;
            frontier_phi_16_2_ladder_4 = frontier_phi_16_2_ladder_24_ladder_4;
            frontier_phi_16_2_ladder_5 = frontier_phi_16_2_ladder_24_ladder_5;
            frontier_phi_16_2_ladder_6 = frontier_phi_16_2_ladder_24_ladder_6;
            frontier_phi_16_2_ladder_7 = frontier_phi_16_2_ladder_24_ladder_7;
            frontier_phi_16_2_ladder_8 = frontier_phi_16_2_ladder_24_ladder_8;
        }
        _472 = frontier_phi_16_2_ladder_1;
        _475 = frontier_phi_16_2_ladder_2;
        _479 = frontier_phi_16_2_ladder_3;
        _483 = frontier_phi_16_2_ladder_4;
        _484 = frontier_phi_16_2_ladder_5;
        _485 = frontier_phi_16_2_ladder_6;
        _486 = frontier_phi_16_2_ladder;
        _487 = frontier_phi_16_2_ladder_7;
        _488 = frontier_phi_16_2_ladder_8;
    }
    float _947;
    float _949;
    float _951;
    if ((_99 & 32u) == 0u)
    {
        _947 = _472;
        _949 = _475;
        _951 = _479;
    }
    else
    {
        uint4 _974 = asuint(RadialBlurRenderParam_m0[3u]);
        uint _975 = _974.x;
        float _978 = float((_975 & 2u) != 0u);
        float _986 = ((1.0f - _978) + (asfloat(ComputeResultSRV.Load(0u).x) * _978)) * RadialBlurRenderParam_m0[0u].w;
        float frontier_phi_27_28_ladder;
        float frontier_phi_27_28_ladder_1;
        float frontier_phi_27_28_ladder_2;
        if (_986 == 0.0f)
        {
            frontier_phi_27_28_ladder = _479;
            frontier_phi_27_28_ladder_1 = _472;
            frontier_phi_27_28_ladder_2 = _475;
        }
        else
        {
            float _1558 = SceneInfo_m0[23u].z * gl_FragCoord.x;
            float _1559 = SceneInfo_m0[23u].w * gl_FragCoord.y;
            float _1561 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _1558;
            float _1563 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _1559;
            float _1566 = (_1561 < 0.0f) ? (1.0f - _1558) : _1558;
            float _1569 = (_1563 < 0.0f) ? (1.0f - _1559) : _1559;
            float _1576 = rsqrt(dot(float2(_1561, _1563), float2(_1561, _1563))) * RadialBlurRenderParam_m0[2u].w;
            uint _1583 = uint(abs(_1576 * _1563)) + uint(abs(_1576 * _1561));
            uint _1588 = ((_1583 ^ 61u) ^ (_1583 >> 16u)) * 9u;
            uint _1591 = ((_1588 >> 4u) ^ _1588) * 668265261u;
            float _1598 = ((_975 & 1u) != 0u) ? (float((_1591 >> 15u) ^ _1591) * 2.3283064365386962890625e-10f) : 1.0f;
            float _1604 = 1.0f / max(1.0f, sqrt((_1561 * _1561) + (_1563 * _1563)));
            float _1605 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
            float _1615 = ((((_1605 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1616 = ((((_1605 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1618 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
            float _1628 = ((((_1618 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1629 = ((((_1618 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1630 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
            float _1640 = ((((_1630 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1641 = ((((_1630 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1642 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
            float _1652 = ((((_1642 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1653 = ((((_1642 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1654 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
            float _1664 = ((((_1654 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1665 = ((((_1654 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1666 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
            float _1676 = ((((_1666 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1677 = ((((_1666 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1678 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
            float _1688 = ((((_1678 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1689 = ((((_1678 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1690 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
            float _1700 = ((((_1690 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1701 = ((((_1690 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1702 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
            float _1712 = ((((_1702 * _1566) * _1598) * _1604) + 1.0f) * _1561;
            float _1713 = ((((_1702 * _1569) * _1598) * _1604) + 1.0f) * _1563;
            float _1714 = Exposure * 0.100000001490116119384765625f;
            float _1716 = _1714 * RadialBlurRenderParam_m0[0u].x;
            float _1717 = _1714 * RadialBlurRenderParam_m0[0u].y;
            float _1718 = _1714 * RadialBlurRenderParam_m0[0u].z;
            float _2764;
            float _2767;
            float _2770;
            if (_108)
            {
                float _1848 = _1615 + RadialBlurRenderParam_m0[1u].x;
                float _1849 = _1616 + RadialBlurRenderParam_m0[1u].y;
                float _1855 = ((dot(float2(_1848, _1849), float2(_1848, _1849)) * _483) + 1.0f) * _488;
                float4 _1862 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_1855 * _1848) + 0.5f, (_1855 * _1849) + 0.5f), 0.0f);
                float _1867 = _1628 + RadialBlurRenderParam_m0[1u].x;
                float _1868 = _1629 + RadialBlurRenderParam_m0[1u].y;
                float _1873 = (dot(float2(_1867, _1868), float2(_1867, _1868)) * _483) + 1.0f;
                float4 _1880 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1867 * _488) * _1873) + 0.5f, ((_1868 * _488) * _1873) + 0.5f), 0.0f);
                float _1888 = _1640 + RadialBlurRenderParam_m0[1u].x;
                float _1889 = _1641 + RadialBlurRenderParam_m0[1u].y;
                float _1894 = (dot(float2(_1888, _1889), float2(_1888, _1889)) * _483) + 1.0f;
                float4 _1901 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1888 * _488) * _1894) + 0.5f, ((_1889 * _488) * _1894) + 0.5f), 0.0f);
                float _1909 = _1652 + RadialBlurRenderParam_m0[1u].x;
                float _1910 = _1653 + RadialBlurRenderParam_m0[1u].y;
                float _1915 = (dot(float2(_1909, _1910), float2(_1909, _1910)) * _483) + 1.0f;
                float4 _1922 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1909 * _488) * _1915) + 0.5f, ((_1910 * _488) * _1915) + 0.5f), 0.0f);
                float _1930 = _1664 + RadialBlurRenderParam_m0[1u].x;
                float _1931 = _1665 + RadialBlurRenderParam_m0[1u].y;
                float _1936 = (dot(float2(_1930, _1931), float2(_1930, _1931)) * _483) + 1.0f;
                float4 _1943 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1930 * _488) * _1936) + 0.5f, ((_1931 * _488) * _1936) + 0.5f), 0.0f);
                float _1951 = _1676 + RadialBlurRenderParam_m0[1u].x;
                float _1952 = _1677 + RadialBlurRenderParam_m0[1u].y;
                float _1957 = (dot(float2(_1951, _1952), float2(_1951, _1952)) * _483) + 1.0f;
                float4 _1964 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1951 * _488) * _1957) + 0.5f, ((_1952 * _488) * _1957) + 0.5f), 0.0f);
                float _1972 = _1688 + RadialBlurRenderParam_m0[1u].x;
                float _1973 = _1689 + RadialBlurRenderParam_m0[1u].y;
                float _1978 = (dot(float2(_1972, _1973), float2(_1972, _1973)) * _483) + 1.0f;
                float4 _1985 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1972 * _488) * _1978) + 0.5f, ((_1973 * _488) * _1978) + 0.5f), 0.0f);
                float _1993 = _1700 + RadialBlurRenderParam_m0[1u].x;
                float _1994 = _1701 + RadialBlurRenderParam_m0[1u].y;
                float _1999 = (dot(float2(_1993, _1994), float2(_1993, _1994)) * _483) + 1.0f;
                float4 _2006 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1993 * _488) * _1999) + 0.5f, ((_1994 * _488) * _1999) + 0.5f), 0.0f);
                float _2014 = _1712 + RadialBlurRenderParam_m0[1u].x;
                float _2015 = _1713 + RadialBlurRenderParam_m0[1u].y;
                float _2020 = (dot(float2(_2014, _2015), float2(_2014, _2015)) * _483) + 1.0f;
                float4 _2027 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_2014 * _488) * _2020) + 0.5f, ((_2015 * _488) * _2020) + 0.5f), 0.0f);
                float _2035 = _1716 * ((((((((_1880.x + _1862.x) + _1901.x) + _1922.x) + _1943.x) + _1964.x) + _1985.x) + _2006.x) + _2027.x);
                float _2036 = _1717 * ((((((((_1880.y + _1862.y) + _1901.y) + _1922.y) + _1943.y) + _1964.y) + _1985.y) + _2006.y) + _2027.y);
                float _2037 = _1718 * ((((((((_1880.z + _1862.z) + _1901.z) + _1922.z) + _1943.z) + _1964.z) + _1985.z) + _2006.z) + _2027.z);
                float _2039 = max(max(_2035, _2036), _2037);
                float _2268;
                float _2269;
                float _2270;
                if (!(isnan(_2039) || isinf(_2039)))
                {
                    float _2174 = TonemapParam_m0[2u].y * _2035;
                    float _2180 = TonemapParam_m0[2u].y * _2036;
                    float _2186 = TonemapParam_m0[2u].y * _2037;
                    float _2193 = (_2035 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2174 * _2174) * (3.0f - (_2174 * 2.0f))));
                    float _2195 = (_2036 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2180 * _2180) * (3.0f - (_2180 * 2.0f))));
                    float _2197 = (_2037 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2186 * _2186) * (3.0f - (_2186 * 2.0f))));
                    float _2204 = (_2035 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                    float _2205 = (_2036 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                    float _2206 = (_2037 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                    _2268 = ((((TonemapParam_m0[0u].x * _2035) + TonemapParam_m0[2u].z) * ((1.0f - _2204) - _2193)) + ((exp2(log2(_2174) * TonemapParam_m0[0u].w) * _2193) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2035) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2204);
                    _2269 = ((((TonemapParam_m0[0u].x * _2036) + TonemapParam_m0[2u].z) * ((1.0f - _2205) - _2195)) + ((exp2(log2(_2180) * TonemapParam_m0[0u].w) * _2195) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2036) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2205);
                    _2270 = ((((TonemapParam_m0[0u].x * _2037) + TonemapParam_m0[2u].z) * ((1.0f - _2206) - _2197)) + ((exp2(log2(_2186) * TonemapParam_m0[0u].w) * _2197) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2037) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2206);
                }
                else
                {
                    _2268 = 1.0f;
                    _2269 = 1.0f;
                    _2270 = 1.0f;
                }
                _2764 = _2268 + ((_472 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
                _2767 = _2269 + ((_475 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
                _2770 = _2270 + ((_479 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
            }
            else
            {
                float _2044 = RadialBlurRenderParam_m0[1u].x + 0.5f;
                float _2045 = _2044 + _1615;
                float _2046 = RadialBlurRenderParam_m0[1u].y + 0.5f;
                float _2047 = _2046 + _1616;
                float _2048 = _2044 + _1628;
                float _2049 = _2046 + _1629;
                float _2050 = _2044 + _1640;
                float _2051 = _2046 + _1641;
                float _2052 = _2044 + _1652;
                float _2053 = _2046 + _1653;
                float _2054 = _2044 + _1664;
                float _2055 = _2046 + _1665;
                float _2056 = _2044 + _1676;
                float _2057 = _2046 + _1677;
                float _2058 = _2044 + _1688;
                float _2059 = _2046 + _1689;
                float _2060 = _2044 + _1700;
                float _2061 = _2046 + _1701;
                float _2062 = _2044 + _1712;
                float _2063 = _2046 + _1713;
                float frontier_phi_74_48_ladder;
                float frontier_phi_74_48_ladder_1;
                float frontier_phi_74_48_ladder_2;
                if (_110)
                {
                    float _2282 = (_2045 * 2.0f) + (-1.0f);
                    float _2286 = sqrt((_2282 * _2282) + 1.0f);
                    float _2287 = 1.0f / _2286;
                    float _2290 = (_2286 * _486) * (_2287 + _484);
                    float _2294 = _487 * 0.5f;
                    float4 _2304 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2290) * _2282) + 0.5f, (((_2294 * (((_2287 + (-1.0f)) * _485) + 1.0f)) * _2290) * ((_2047 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
                    float _2311 = (_2048 * 2.0f) + (-1.0f);
                    float _2315 = sqrt((_2311 * _2311) + 1.0f);
                    float _2316 = 1.0f / _2315;
                    float _2319 = (_2315 * _486) * (_2316 + _484);
                    float4 _2330 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2311) * _2319) + 0.5f, (((_2294 * ((_2049 * 2.0f) + (-1.0f))) * (((_2316 + (-1.0f)) * _485) + 1.0f)) * _2319) + 0.5f), 0.0f);
                    float _2340 = (_2050 * 2.0f) + (-1.0f);
                    float _2344 = sqrt((_2340 * _2340) + 1.0f);
                    float _2345 = 1.0f / _2344;
                    float _2348 = (_2344 * _486) * (_2345 + _484);
                    float4 _2359 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2340) * _2348) + 0.5f, (((_2294 * ((_2051 * 2.0f) + (-1.0f))) * (((_2345 + (-1.0f)) * _485) + 1.0f)) * _2348) + 0.5f), 0.0f);
                    float _2369 = (_2052 * 2.0f) + (-1.0f);
                    float _2373 = sqrt((_2369 * _2369) + 1.0f);
                    float _2374 = 1.0f / _2373;
                    float _2377 = (_2373 * _486) * (_2374 + _484);
                    float4 _2388 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2369) * _2377) + 0.5f, (((_2294 * ((_2053 * 2.0f) + (-1.0f))) * (((_2374 + (-1.0f)) * _485) + 1.0f)) * _2377) + 0.5f), 0.0f);
                    float _2398 = (_2054 * 2.0f) + (-1.0f);
                    float _2402 = sqrt((_2398 * _2398) + 1.0f);
                    float _2403 = 1.0f / _2402;
                    float _2406 = (_2402 * _486) * (_2403 + _484);
                    float4 _2417 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2398) * _2406) + 0.5f, (((_2294 * ((_2055 * 2.0f) + (-1.0f))) * (((_2403 + (-1.0f)) * _485) + 1.0f)) * _2406) + 0.5f), 0.0f);
                    float _2427 = (_2056 * 2.0f) + (-1.0f);
                    float _2431 = sqrt((_2427 * _2427) + 1.0f);
                    float _2432 = 1.0f / _2431;
                    float _2435 = (_2431 * _486) * (_2432 + _484);
                    float4 _2446 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2427) * _2435) + 0.5f, (((_2294 * ((_2057 * 2.0f) + (-1.0f))) * (((_2432 + (-1.0f)) * _485) + 1.0f)) * _2435) + 0.5f), 0.0f);
                    float _2456 = (_2058 * 2.0f) + (-1.0f);
                    float _2460 = sqrt((_2456 * _2456) + 1.0f);
                    float _2461 = 1.0f / _2460;
                    float _2464 = (_2460 * _486) * (_2461 + _484);
                    float4 _2475 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2456) * _2464) + 0.5f, (((_2294 * ((_2059 * 2.0f) + (-1.0f))) * (((_2461 + (-1.0f)) * _485) + 1.0f)) * _2464) + 0.5f), 0.0f);
                    float _2485 = (_2060 * 2.0f) + (-1.0f);
                    float _2489 = sqrt((_2485 * _2485) + 1.0f);
                    float _2490 = 1.0f / _2489;
                    float _2493 = (_2489 * _486) * (_2490 + _484);
                    float4 _2504 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2485) * _2493) + 0.5f, (((_2294 * ((_2061 * 2.0f) + (-1.0f))) * (((_2490 + (-1.0f)) * _485) + 1.0f)) * _2493) + 0.5f), 0.0f);
                    float _2514 = (_2062 * 2.0f) + (-1.0f);
                    float _2518 = sqrt((_2514 * _2514) + 1.0f);
                    float _2519 = 1.0f / _2518;
                    float _2522 = (_2518 * _486) * (_2519 + _484);
                    float4 _2533 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2294 * _2514) * _2522) + 0.5f, (((_2294 * ((_2063 * 2.0f) + (-1.0f))) * (((_2519 + (-1.0f)) * _485) + 1.0f)) * _2522) + 0.5f), 0.0f);
                    float _2541 = _1716 * ((((((((_2330.x + _2304.x) + _2359.x) + _2388.x) + _2417.x) + _2446.x) + _2475.x) + _2504.x) + _2533.x);
                    float _2542 = _1717 * ((((((((_2330.y + _2304.y) + _2359.y) + _2388.y) + _2417.y) + _2446.y) + _2475.y) + _2504.y) + _2533.y);
                    float _2543 = _1718 * ((((((((_2330.z + _2304.z) + _2359.z) + _2388.z) + _2417.z) + _2446.z) + _2475.z) + _2504.z) + _2533.z);
                    float _2545 = max(max(_2541, _2542), _2543);
                    float _2874;
                    float _2875;
                    float _2876;
                    if (!(isnan(_2545) || isinf(_2545)))
                    {
                        float _2780 = TonemapParam_m0[2u].y * _2541;
                        float _2786 = TonemapParam_m0[2u].y * _2542;
                        float _2792 = TonemapParam_m0[2u].y * _2543;
                        float _2799 = (_2541 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2780 * _2780) * (3.0f - (_2780 * 2.0f))));
                        float _2801 = (_2542 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2786 * _2786) * (3.0f - (_2786 * 2.0f))));
                        float _2803 = (_2543 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2792 * _2792) * (3.0f - (_2792 * 2.0f))));
                        float _2810 = (_2541 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2811 = (_2542 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2812 = (_2543 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        _2874 = ((((TonemapParam_m0[0u].x * _2541) + TonemapParam_m0[2u].z) * ((1.0f - _2810) - _2799)) + ((exp2(log2(_2780) * TonemapParam_m0[0u].w) * _2799) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2541) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2810);
                        _2875 = ((((TonemapParam_m0[0u].x * _2542) + TonemapParam_m0[2u].z) * ((1.0f - _2811) - _2801)) + ((exp2(log2(_2786) * TonemapParam_m0[0u].w) * _2801) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2542) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2811);
                        _2876 = ((((TonemapParam_m0[0u].x * _2543) + TonemapParam_m0[2u].z) * ((1.0f - _2812) - _2803)) + ((exp2(log2(_2792) * TonemapParam_m0[0u].w) * _2803) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2543) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2812);
                    }
                    else
                    {
                        _2874 = 1.0f;
                        _2875 = 1.0f;
                        _2876 = 1.0f;
                    }
                    frontier_phi_74_48_ladder = _2876 + ((_479 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
                    frontier_phi_74_48_ladder_1 = _2875 + ((_475 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
                    frontier_phi_74_48_ladder_2 = _2874 + ((_472 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
                }
                else
                {
                    float4 _2552 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2045, _2047), 0.0f);
                    float4 _2557 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2048, _2049), 0.0f);
                    float4 _2565 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2050, _2051), 0.0f);
                    float4 _2573 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2052, _2053), 0.0f);
                    float4 _2581 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2054, _2055), 0.0f);
                    float4 _2589 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2056, _2057), 0.0f);
                    float4 _2597 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2058, _2059), 0.0f);
                    float4 _2605 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2060, _2061), 0.0f);
                    float4 _2613 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2062, _2063), 0.0f);
                    float _2621 = _1716 * ((((((((_2557.x + _2552.x) + _2565.x) + _2573.x) + _2581.x) + _2589.x) + _2597.x) + _2605.x) + _2613.x);
                    float _2622 = _1717 * ((((((((_2557.y + _2552.y) + _2565.y) + _2573.y) + _2581.y) + _2589.y) + _2597.y) + _2605.y) + _2613.y);
                    float _2623 = _1718 * ((((((((_2557.z + _2552.z) + _2565.z) + _2573.z) + _2581.z) + _2589.z) + _2597.z) + _2605.z) + _2613.z);
                    float _2625 = max(max(_2621, _2622), _2623);
                    float _2983;
                    float _2984;
                    float _2985;
                    if (!(isnan(_2625) || isinf(_2625)))
                    {
                        float _2889 = TonemapParam_m0[2u].y * _2621;
                        float _2895 = TonemapParam_m0[2u].y * _2622;
                        float _2901 = TonemapParam_m0[2u].y * _2623;
                        float _2908 = (_2621 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2889 * _2889) * (3.0f - (_2889 * 2.0f))));
                        float _2910 = (_2622 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2895 * _2895) * (3.0f - (_2895 * 2.0f))));
                        float _2912 = (_2623 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2901 * _2901) * (3.0f - (_2901 * 2.0f))));
                        float _2919 = (_2621 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2920 = (_2622 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2921 = (_2623 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        _2983 = ((((TonemapParam_m0[0u].x * _2621) + TonemapParam_m0[2u].z) * ((1.0f - _2919) - _2908)) + ((exp2(log2(_2889) * TonemapParam_m0[0u].w) * _2908) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2621) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2919);
                        _2984 = ((((TonemapParam_m0[0u].x * _2622) + TonemapParam_m0[2u].z) * ((1.0f - _2920) - _2910)) + ((exp2(log2(_2895) * TonemapParam_m0[0u].w) * _2910) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2622) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2920);
                        _2985 = ((((TonemapParam_m0[0u].x * _2623) + TonemapParam_m0[2u].z) * ((1.0f - _2921) - _2912)) + ((exp2(log2(_2901) * TonemapParam_m0[0u].w) * _2912) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2623) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2921);
                    }
                    else
                    {
                        _2983 = 1.0f;
                        _2984 = 1.0f;
                        _2985 = 1.0f;
                    }
                    frontier_phi_74_48_ladder = _2985 + ((_479 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
                    frontier_phi_74_48_ladder_1 = _2984 + ((_475 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
                    frontier_phi_74_48_ladder_2 = _2983 + ((_472 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
                }
                _2764 = frontier_phi_74_48_ladder_2;
                _2767 = frontier_phi_74_48_ladder_1;
                _2770 = frontier_phi_74_48_ladder;
            }
            float _3016;
            float _3017;
            float _3018;
            if (RadialBlurRenderParam_m0[2u].x > 0.0f)
            {
                float _3000 = clamp((sqrt((_1561 * _1561) + (_1563 * _1563)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
                float _3006 = (((_3000 * _3000) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_3000 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
                _3016 = (_3006 * (_2764 - _472)) + _472;
                _3017 = (_3006 * (_2767 - _475)) + _475;
                _3018 = (_3006 * (_2770 - _479)) + _479;
            }
            else
            {
                _3016 = _2764;
                _3017 = _2767;
                _3018 = _2770;
            }
            frontier_phi_27_28_ladder = ((_3018 - _479) * _986) + _479;
            frontier_phi_27_28_ladder_1 = ((_3016 - _472) * _986) + _472;
            frontier_phi_27_28_ladder_2 = ((_3017 - _475) * _986) + _475;
        }
        _947 = frontier_phi_27_28_ladder_1;
        _949 = frontier_phi_27_28_ladder_2;
        _951 = frontier_phi_27_28_ladder;
    }
    float _1511;
    float _1513;
    float _1515;
    if ((_99 & 2u) == 0u)
    {
        _1511 = _947;
        _1513 = _949;
        _1515 = _951;
    }
    else
    {
        float _1540 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
        float _1542 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
        float _1551 = frac(frac(dot(float2(_1540, _1542), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
        float _1843;
        if (_1551 < FilmGrainParam_m0[1u].x)
        {
            uint _1831 = uint(_1542 * _1540) ^ 12345391u;
            uint _1833 = _1831 * 3635641u;
            _1843 = float(((_1833 >> 26u) | (_1831 * 232681024u)) ^ _1833) * 2.3283064365386962890625e-10f;
        }
        else
        {
            _1843 = 0.0f;
        }
        float _1846 = frac(_1551 * 757.48468017578125f);
        float _2164;
        if (_1846 < FilmGrainParam_m0[1u].x)
        {
            uint _2155 = asuint(_1846) ^ 12345391u;
            uint _2156 = _2155 * 3635641u;
            _2164 = (float(((_2156 >> 26u) | (_2155 * 232681024u)) ^ _2156) * 2.3283064365386962890625e-10f) + (-0.5f);
        }
        else
        {
            _2164 = 0.0f;
        }
        float _2166 = frac(_1846 * 757.48468017578125f);
        float _2732;
        if (_2166 < FilmGrainParam_m0[1u].x)
        {
            uint _2723 = asuint(_2166) ^ 12345391u;
            uint _2724 = _2723 * 3635641u;
            _2732 = (float(((_2724 >> 26u) | (_2723 * 232681024u)) ^ _2724) * 2.3283064365386962890625e-10f) + (-0.5f);
        }
        else
        {
            _2732 = 0.0f;
        }
        float _2733 = _1843 * FilmGrainParam_m0[0u].x;
        float _2734 = _2732 * FilmGrainParam_m0[0u].y;
        float _2735 = _2164 * FilmGrainParam_m0[0u].y;
        float _2757 = exp2(log2(1.0f - clamp(dot(float3(clamp(_947, 0.0f, 1.0f), clamp(_949, 0.0f, 1.0f), clamp(_951, 0.0f, 1.0f)), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
        _1511 = (_2757 * (mad(_2735, 1.401999950408935546875f, _2733) - _947)) + _947;
        _1513 = (_2757 * (mad(_2735, -0.7139999866485595703125f, mad(_2734, -0.3440000116825103759765625f, _2733)) - _949)) + _949;
        _1515 = (_2757 * (mad(_2734, 1.77199995517730712890625f, _2733) - _951)) + _951;
    }
    float _1790;
    float _1793;
    float _1796;
    if ((_99 & 4u) == 0u)
    {
        _1790 = _1511;
        _1793 = _1513;
        _1796 = _1515;
    }
    else
    {
        float _1827 = max(max(_1511, _1513), _1515);
        bool _1828 = _1827 > 1.0f;
        float _2148;
        float _2149;
        float _2150;
        if (_1828)
        {
            _2148 = _1511 / _1827;
            _2149 = _1513 / _1827;
            _2150 = _1515 / _1827;
        }
        else
        {
            _2148 = _1511;
            _2149 = _1513;
            _2150 = _1515;
            }
            float _2151 = ColorCorrectTexture_m0[0u].w * 0.5f;
            float _2992;
#if 0
        if (_2148 > 0.003130800090730190277099609375f)
        {
            _2992 = (exp2(log2(_2148) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _2992 = _2148 * 12.9200000762939453125f;
        }
        float _3031;
        if (_2149 > 0.003130800090730190277099609375f)
        {
            _3031 = (exp2(log2(_2149) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _3031 = _2149 * 12.9200000762939453125f;
        }
        float _3039;
        if (_2150 > 0.003130800090730190277099609375f)
        {
            _3039 = (exp2(log2(_2150) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _3039 = _2150 * 12.9200000762939453125f;
        }
        float _3040 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _3044 = (_2992 * _3040) + _2151;
        float _3045 = (_3031 * _3040) + _2151;
        float _3046 = (_3039 * _3040) + _2151;
        float4 _3050 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_3044, _3045, _3046), 0.0f);
#else
        float3 _3050 = LUTBlackCorrection(float3(_2148, _2149, _2150), tTextureMap0, lut_config);
#endif
        float _3052 = _3050.x;
        float _3053 = _3050.y;
        float _3054 = _3050.z;
        bool _3056 = ColorCorrectTexture_m0[0u].z > 0.0f;
        float _3074;
        float _3077;
        float _3080;
        if (ColorCorrectTexture_m0[0u].y > 0.0f)
        {
#if 0
          float4 _3059 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_3044, _3045, _3046), 0.0f);
#else
          float3 _3059 = LUTBlackCorrection(float3(_2148, _2149, _2150), tTextureMap1, lut_config);
#endif

          float _3070 = ((_3059.x - _3052) * ColorCorrectTexture_m0[0u].y) + _3052;
            float _3071 = ((_3059.y - _3053) * ColorCorrectTexture_m0[0u].y) + _3053;
            float _3072 = ((_3059.z - _3054) * ColorCorrectTexture_m0[0u].y) + _3054;
            float frontier_phi_91_88_ladder;
            float frontier_phi_91_88_ladder_1;
            float frontier_phi_91_88_ladder_2;
            if (_3056)
            {
#if 0
                float _3105;
                if (_3070 > 0.003130800090730190277099609375f)
                {
                    _3105 = (exp2(log2(_3070) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3105 = _3070 * 12.9200000762939453125f;
                }
                float _3121;
                if (_3071 > 0.003130800090730190277099609375f)
                {
                    _3121 = (exp2(log2(_3071) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3121 = _3071 * 12.9200000762939453125f;
                }
                float _3137;
                if (_3072 > 0.003130800090730190277099609375f)
                {
                    _3137 = (exp2(log2(_3072) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3137 = _3072 * 12.9200000762939453125f;
                }
                float4 _3140 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_3105, _3121, _3137), 0.0f);
#else
                float3 _3140 = LUTBlackCorrection(float3(_3070, _3071, _3072), tTextureMap2, lut_config);
#endif
                frontier_phi_91_88_ladder = ((_3140.z - _3072) * ColorCorrectTexture_m0[0u].z) + _3072;
                frontier_phi_91_88_ladder_1 = ((_3140.y - _3071) * ColorCorrectTexture_m0[0u].z) + _3071;
                frontier_phi_91_88_ladder_2 = ((_3140.x - _3070) * ColorCorrectTexture_m0[0u].z) + _3070;
            }
            else
            {
                frontier_phi_91_88_ladder = _3072;
                frontier_phi_91_88_ladder_1 = _3071;
                frontier_phi_91_88_ladder_2 = _3070;
            }
            _3074 = frontier_phi_91_88_ladder_2;
            _3077 = frontier_phi_91_88_ladder_1;
            _3080 = frontier_phi_91_88_ladder;
        }
        else
        {
            float frontier_phi_91_89_ladder;
            float frontier_phi_91_89_ladder_1;
            float frontier_phi_91_89_ladder_2;
            if (_3056)
            {
#if 0
                float _3107;
                if (_3052 > 0.003130800090730190277099609375f)
                {
                    _3107 = (exp2(log2(_3052) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3107 = _3052 * 12.9200000762939453125f;
                }
                float _3123;
                if (_3053 > 0.003130800090730190277099609375f)
                {
                    _3123 = (exp2(log2(_3053) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3123 = _3053 * 12.9200000762939453125f;
                }
                float _3151;
                if (_3054 > 0.003130800090730190277099609375f)
                {
                    _3151 = (exp2(log2(_3054) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3151 = _3054 * 12.9200000762939453125f;
                }
                float4 _3154 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_3107, _3123, _3151), 0.0f);
#else
                float3 _3154 = LUTBlackCorrection(float3(_3052, _3053, _3054), tTextureMap2, lut_config);
#endif
                frontier_phi_91_89_ladder = ((_3154.z - _3054) * ColorCorrectTexture_m0[0u].z) + _3054;
                frontier_phi_91_89_ladder_1 = ((_3154.y - _3053) * ColorCorrectTexture_m0[0u].z) + _3053;
                frontier_phi_91_89_ladder_2 = ((_3154.x - _3052) * ColorCorrectTexture_m0[0u].z) + _3052;
            }
            else
            {
                frontier_phi_91_89_ladder = _3054;
                frontier_phi_91_89_ladder_1 = _3053;
                frontier_phi_91_89_ladder_2 = _3052;
            }
            _3074 = frontier_phi_91_89_ladder_2;
            _3077 = frontier_phi_91_89_ladder_1;
            _3080 = frontier_phi_91_89_ladder;
        }
        float _1792 = mad(_3080, ColorCorrectTexture_m0[3u].x, mad(_3077, ColorCorrectTexture_m0[2u].x, _3074 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
        float _1795 = mad(_3080, ColorCorrectTexture_m0[3u].y, mad(_3077, ColorCorrectTexture_m0[2u].y, _3074 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
        float _1798 = mad(_3080, ColorCorrectTexture_m0[3u].z, mad(_3077, ColorCorrectTexture_m0[2u].z, _3074 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
        float frontier_phi_43_91_ladder;
        float frontier_phi_43_91_ladder_1;
        float frontier_phi_43_91_ladder_2;
        if (_1828)
        {
            frontier_phi_43_91_ladder = _1798 * _1827;
            frontier_phi_43_91_ladder_1 = _1795 * _1827;
            frontier_phi_43_91_ladder_2 = _1792 * _1827;
        }
        else
        {
            frontier_phi_43_91_ladder = _1798;
            frontier_phi_43_91_ladder_1 = _1795;
            frontier_phi_43_91_ladder_2 = _1792;
        }
        _1790 = frontier_phi_43_91_ladder_2;
        _1793 = frontier_phi_43_91_ladder_1;
        _1796 = frontier_phi_43_91_ladder;
    }
    float _2107;
    float _2109;
    float _2111;
    if ((_99 & 8u) == 0u)
    {
        _2107 = _1790;
        _2109 = _1793;
        _2111 = _1796;
    }
    else
    {
        _2107 = clamp(((ColorDeficientTable_m0[0u].x * _1790) + (ColorDeficientTable_m0[0u].y * _1793)) + (ColorDeficientTable_m0[0u].z * _1796), 0.0f, 1.0f);
        _2109 = clamp(((ColorDeficientTable_m0[1u].x * _1790) + (ColorDeficientTable_m0[1u].y * _1793)) + (ColorDeficientTable_m0[1u].z * _1796), 0.0f, 1.0f);
        _2111 = clamp(((ColorDeficientTable_m0[2u].x * _1790) + (ColorDeficientTable_m0[2u].y * _1793)) + (ColorDeficientTable_m0[2u].z * _1796), 0.0f, 1.0f);
    }
    float _2630;
    float _2632;
    float _2634;
    if ((_99 & 16u) == 0u)
    {
        _2630 = _2107;
        _2632 = _2109;
        _2634 = _2111;
    }
    else
    {
        float _2655 = SceneInfo_m0[23u].z * gl_FragCoord.x;
        float _2656 = SceneInfo_m0[23u].w * gl_FragCoord.y;
        float4 _2660 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2655, _2656), 0.0f);
        float _2666 = _2660.x * ImagePlaneParam_m0[0u].x;
        float _2667 = _2660.y * ImagePlaneParam_m0[0u].y;
        float _2668 = _2660.z * ImagePlaneParam_m0[0u].z;
        float _2678 = (_2660.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2655, _2656), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
        _2630 = ((((_2666 < 0.5f) ? ((_2107 * 2.0f) * _2666) : (1.0f - (((1.0f - _2107) * 2.0f) * (1.0f - _2666)))) - _2107) * _2678) + _2107;
        _2632 = ((((_2667 < 0.5f) ? ((_2109 * 2.0f) * _2667) : (1.0f - (((1.0f - _2109) * 2.0f) * (1.0f - _2667)))) - _2109) * _2678) + _2109;
        _2634 = ((((_2668 < 0.5f) ? ((_2111 * 2.0f) * _2668) : (1.0f - (((1.0f - _2111) * 2.0f) * (1.0f - _2668)))) - _2111) * _2678) + _2111;
    }
    SV_Target.x = _2630;
    SV_Target.y = _2632;
    SV_Target.z = _2634;
    SV_Target.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    Kerare = stage_input.Kerare;
    Exposure = stage_input.Exposure;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    return stage_output;
}
