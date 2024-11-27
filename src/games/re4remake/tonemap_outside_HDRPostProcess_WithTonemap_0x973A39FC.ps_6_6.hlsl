#include "./LUTBlackCorrection.hlsl"
#include "./shared.h"

cbuffer SceneInfoUBO : register(b0, space0)
{
    float4 SceneInfo_m0[33] : packoffset(c0);
};

cbuffer CameraKerareUBO : register(b1, space0)
{
    float4 CameraKerare_m0[1] : packoffset(c0);
};

//  struct TonemapParam
//  {
//
//      float contrast;                               ; Offset:    0
//      float linearBegin;                            ; Offset:    4
//      float linearLength;                           ; Offset:    8
//      float toe;                                    ; Offset:   12
//      float maxNit;                                 ; Offset:   16
//      float linearStart;                            ; Offset:   20
//      float displayMaxNitSubContrastFactor;         ; Offset:   24
//      float contrastFactor;                         ; Offset:   28
//      float mulLinearStartContrastFactor;           ; Offset:   32
//      float invLinearBegin;                         ; Offset:   36
//      float madLinearStartContrastFactor;           ; Offset:   40
//
//  } TonemapParam;                                   ; Offset:    0 Size:    44
//
//}
// cbuffer TonemapParamUBO : register(b2, space0)
// {
//     float4 TonemapParam_m0[3] : packoffset(c0);
// };
cbuffer TonemapParamUBO : register(b2, space0)
{
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

cbuffer CBHazeFilterParamsUBO : register(b3, space0)
{
    float4 CBHazeFilterParams_m0[4] : packoffset(c0);
};

cbuffer LensDistortionParamUBO : register(b4, space0)
{
    float4 LensDistortionParam_m0[2] : packoffset(c0);
};

cbuffer PaniniProjectionParamUBO : register(b5, space0)
{
    float4 PaniniProjectionParam_m0[1] : packoffset(c0);
};

cbuffer RadialBlurRenderParamUBO : register(b6, space0)
{
    float4 RadialBlurRenderParam_m0[4] : packoffset(c0);
};

cbuffer FilmGrainParamUBO : register(b7, space0)
{
    float4 FilmGrainParam_m0[2] : packoffset(c0);
};

cbuffer ColorCorrectTextureUBO : register(b8, space0)
{
    float4 ColorCorrectTexture_m0[5] : packoffset(c0);
};

cbuffer ColorDeficientTableUBO : register(b9, space0)
{
    float4 ColorDeficientTable_m0[3] : packoffset(c0);
};

cbuffer ImagePlaneParamUBO : register(b10, space0)
{
    float4 ImagePlaneParam_m0[2] : packoffset(c0);
};

cbuffer CBControlUBO : register(b11, space0)
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
  if (injectedData.toneMapType != 0) {
    if (injectedData.colorGradeToeAdjustmentType == 0) {
      TonemapParam_m0[0u].w *= injectedData.colorGradeShadowToe;  // toe
    } else {
      TonemapParam_m0[0u].w = injectedData.colorGradeShadowToe;  // toe
    }
    TonemapParam_m0[0u].x *= injectedData.colorGradeHighlightContrast;  // contrast
    TonemapParam_m0[1u].x = 125;                                        // maxNit
    TonemapParam_m0[1u].y = 125;                                        // linearStart
  }
  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      injectedData.colorGradeLUTStrength,
      injectedData.colorGradeLUTScaling,
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      ColorCorrectTexture_m0[0u].x);

  uint4 _110 = asuint(CBControl_m0[0u]);
    uint _111 = _110.x;
    bool _114 = (_111 & 1u) != 0u;
    uint4 _117 = asuint(LensDistortionParam_m0[0u]);
    uint _118 = _117.w;
    bool _120 = _114 && (_118 == 0u);
    bool _122 = _114 && (_118 == 1u);
    uint _125 = (_111 >> 6u) & 1u;
    float _129 = Kerare.x / Kerare.w;
    float _130 = Kerare.y / Kerare.w;
    float _131 = Kerare.z / Kerare.w;
    float _139 = abs(rsqrt(dot(float3(_129, _130, _131), float3(_129, _130, _131))) * _131);
    float _148 = _139 * _139;
    float _152 = clamp(((_148 * _148) * (1.0f - clamp((CameraKerare_m0[0u].x * _139) + CameraKerare_m0[0u].y, 0.0f, 1.0f))) + CameraKerare_m0[0u].z, 0.0f, 1.0f);
    float _153 = _152 * Exposure;
    float _509;
    float _512;
    float _516;
    float _520;
    float _521;
    float _522;
    float _523;
    float _524;
    float _525;
    if (_120)
    {
        float _169 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
        float _171 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
        float _172 = dot(float2(_169, _171), float2(_169, _171));
        float _178 = ((_172 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
        float _179 = _178 * _169;
        float _180 = _178 * _171;
        float _181 = _179 + 0.5f;
        float _183 = _180 + 0.5f;
        float frontier_phi_16_1_ladder;
        float frontier_phi_16_1_ladder_1;
        float frontier_phi_16_1_ladder_2;
        float frontier_phi_16_1_ladder_3;
        float frontier_phi_16_1_ladder_4;
        float frontier_phi_16_1_ladder_5;
        float frontier_phi_16_1_ladder_6;
        float frontier_phi_16_1_ladder_7;
        float frontier_phi_16_1_ladder_8;
        if (_117.z == 0u)
        {
            float _259;
            float _261;
            if (_125 == 0u)
            {
                _259 = _181;
                _261 = _183;
            }
            else
            {
                uint4 _282 = asuint(CBHazeFilterParams_m0[3u]);
                uint _283 = _282.x;
                bool _286 = (_283 & 2u) == 0u;
                float4 _290 = tFilterTempMap1.Sample(BilinearWrap, float2(_181, _183));
                float _292 = _290.x;
                float _1025;
                float _1026;
                if (_286)
                {
                    _1025 = ((_283 & 1u) == 0u) ? _292 : (1.0f - _292);
                    _1026 = 0.0f;
                }
                else
                {
                    float4 _536 = ReadonlyDepth.SampleLevel(PointClamp, float2(_181, _183), 0.0f);
                    float _538 = _536.x;
                    float _545 = (((_181 * 2.0f) * SceneInfo_m0[23u].x) * SceneInfo_m0[23u].z) + (-1.0f);
                    float _546 = 1.0f - (((_183 * 2.0f) * SceneInfo_m0[23u].y) * SceneInfo_m0[23u].w);
                    float _591 = 1.0f / (mad(_538, SceneInfo_m0[16u].w, mad(_546, SceneInfo_m0[15u].w, _545 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
                    float _593 = _591 * (mad(_538, SceneInfo_m0[16u].y, mad(_546, SceneInfo_m0[15u].y, _545 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
                    float _607 = (_591 * (mad(_538, SceneInfo_m0[16u].x, mad(_546, SceneInfo_m0[15u].x, _545 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
                    float _608 = _593 - SceneInfo_m0[8u].w;
                    float _609 = (_591 * (mad(_538, SceneInfo_m0[16u].z, mad(_546, SceneInfo_m0[15u].z, _545 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
                    _1025 = clamp(_292 * max((sqrt(((_608 * _608) + (_607 * _607)) + (_609 * _609)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_593 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
                    _1026 = _538;
                }
                float _1032 = (-0.0f) - _183;
                float _1059 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1032, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _181));
                float _1060 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1032, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _181));
                float _1061 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1032, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _181));
                float _1073 = _1059 * 2.0f;
                float _1074 = _1060 * 2.0f;
                float _1075 = _1061 * 2.0f;
                float _1085 = _1059 * 4.0f;
                float _1087 = _1060 * 4.0f;
                float _1088 = _1061 * 4.0f;
                float _1098 = _1059 * 8.0f;
                float _1100 = _1060 * 8.0f;
                float _1101 = _1061 * 8.0f;
                float _1111 = CBHazeFilterParams_m0[1u].x + 0.5f;
                float _1112 = CBHazeFilterParams_m0[1u].y + 0.5f;
                float _1113 = CBHazeFilterParams_m0[1u].z + 0.5f;
                float _1153 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1073 + CBHazeFilterParams_m0[1u].x, _1074 + CBHazeFilterParams_m0[1u].y, _1075 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1059 + CBHazeFilterParams_m0[1u].x, _1060 + CBHazeFilterParams_m0[1u].y, _1061 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1085 + CBHazeFilterParams_m0[1u].x, _1087 + CBHazeFilterParams_m0[1u].y, _1088 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1098 + CBHazeFilterParams_m0[1u].x, _1100 + CBHazeFilterParams_m0[1u].y, _1101 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1025) * CBHazeFilterParams_m0[2u].x;
                float _1155 = (CBHazeFilterParams_m0[2u].x * _1025) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1073 + _1111, _1074 + _1112, _1075 + _1113)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1059 + _1111, _1060 + _1112, _1061 + _1113)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1085 + _1111, _1087 + _1112, _1088 + _1113)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1098 + _1111, _1100 + _1112, _1101 + _1113)).x * 0.0625f)) * 2.0f) + (-1.0f));
                float _1756;
                float _1758;
                if ((_283 & 4u) == 0u)
                {
                    _1756 = _1153;
                    _1758 = _1155;
                }
                else
                {
                    float _1769 = 0.5f / CBHazeFilterParams_m0[2u].y;
                    float _1776 = clamp(max((_1769 * min(max(abs(_179) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1769 * min(max(abs(_180) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
                    _1756 = _1153 - (_1776 * _1153);
                    _1758 = _1155 - (_1776 * _1155);
                }
                float _2101;
                float _2102;
                if (_286)
                {
                    _2101 = _1756;
                    _2102 = _1758;
                }
                else
                {
                    float frontier_phi_49_50_ladder;
                    float frontier_phi_49_50_ladder_1;
                    if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1756 + _181, _1758 + _183)).x - _1026) < CBHazeFilterParams_m0[2u].w)
                    {
                        frontier_phi_49_50_ladder = _1758;
                        frontier_phi_49_50_ladder_1 = _1756;
                    }
                    else
                    {
                        frontier_phi_49_50_ladder = 0.0f;
                        frontier_phi_49_50_ladder_1 = 0.0f;
                    }
                    _2101 = frontier_phi_49_50_ladder_1;
                    _2102 = frontier_phi_49_50_ladder;
                }
                _259 = _2101 + _181;
                _261 = _2102 + _183;
            }
            float4 _266 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_259, _261));
            float _271 = _266.x * _153;
            float _272 = _266.y * _153;
            float _273 = _266.z * _153;
            float _275 = max(max(_271, _272), _273);
            float frontier_phi_16_1_ladder_7_ladder;
            float frontier_phi_16_1_ladder_7_ladder_1;
            float frontier_phi_16_1_ladder_7_ladder_2;
            float frontier_phi_16_1_ladder_7_ladder_3;
            float frontier_phi_16_1_ladder_7_ladder_4;
            float frontier_phi_16_1_ladder_7_ladder_5;
            float frontier_phi_16_1_ladder_7_ladder_6;
            float frontier_phi_16_1_ladder_7_ladder_7;
            float frontier_phi_16_1_ladder_7_ladder_8;
            if (!(isnan(_275) || isinf(_275)))
            {
                float _415 = TonemapParam_m0[2u].y * _271;
                float _421 = TonemapParam_m0[2u].y * _272;
                float _427 = TonemapParam_m0[2u].y * _273;
                float _434 = (_271 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_415 * _415) * (3.0f - (_415 * 2.0f))));
                float _436 = (_272 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_421 * _421) * (3.0f - (_421 * 2.0f))));
                float _438 = (_273 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_427 * _427) * (3.0f - (_427 * 2.0f))));
                float _445 = (_271 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _446 = (_272 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _447 = (_273 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_1_ladder_7_ladder = 0.0f;
                frontier_phi_16_1_ladder_7_ladder_1 = ((((TonemapParam_m0[0u].x * _271) + TonemapParam_m0[2u].z) * ((1.0f - _445) - _434)) + ((exp2(log2(_415) * TonemapParam_m0[0u].w) * _434) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _271) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _445);
                frontier_phi_16_1_ladder_7_ladder_2 = ((((TonemapParam_m0[0u].x * _272) + TonemapParam_m0[2u].z) * ((1.0f - _446) - _436)) + ((exp2(log2(_421) * TonemapParam_m0[0u].w) * _436) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _272) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _446);
                frontier_phi_16_1_ladder_7_ladder_3 = ((((TonemapParam_m0[0u].x * _273) + TonemapParam_m0[2u].z) * ((1.0f - _447) - _438)) + ((exp2(log2(_427) * TonemapParam_m0[0u].w) * _438) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _273) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _447);
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
            float _189 = _172 + LensDistortionParam_m0[0u].y;
            float _191 = (_189 * LensDistortionParam_m0[0u].x) + 1.0f;
            float _192 = _169 * LensDistortionParam_m0[1u].x;
            float _194 = _171 * LensDistortionParam_m0[1u].x;
            float _200 = ((_189 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
            float4 _209 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_181, _183));
            float _214 = _209.x * _153;
            float _218 = max(max(_214, _209.y * _153), _209.z * _153);
            float _338;
            if (!(isnan(_218) || isinf(_218)))
            {
                float _299 = TonemapParam_m0[2u].y * _214;
                float _307 = (_214 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_299 * _299) * (3.0f - (_299 * 2.0f))));
                float _312 = (_214 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                _338 = ((((TonemapParam_m0[0u].x * _214) + TonemapParam_m0[2u].z) * ((1.0f - _312) - _307)) + ((TonemapParam_m0[0u].y * exp2(log2(_299) * TonemapParam_m0[0u].w)) * _307)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _214) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _312);
            }
            else
            {
                _338 = 1.0f;
            }
            float4 _340 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_192 * _191) + 0.5f, (_194 * _191) + 0.5f));
            float _346 = _340.y * _153;
            float _349 = max(max(_340.x * _153, _346), _340.z * _153);
            float _513;
            if (!(isnan(_349) || isinf(_349)))
            {
                float _635 = TonemapParam_m0[2u].y * _346;
                float _642 = (_346 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_635 * _635) * (3.0f - (_635 * 2.0f))));
                float _647 = (_346 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                _513 = ((((TonemapParam_m0[0u].x * _346) + TonemapParam_m0[2u].z) * ((1.0f - _647) - _642)) + ((TonemapParam_m0[0u].y * exp2(log2(_635) * TonemapParam_m0[0u].w)) * _642)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _346) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _647);
            }
            else
            {
                _513 = 1.0f;
            }
            float4 _674 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_192 * _200) + 0.5f, (_194 * _200) + 0.5f));
            float _681 = _674.z * _153;
            float _683 = max(max(_674.x * _153, _674.y * _153), _681);
            float frontier_phi_16_1_ladder_20_ladder;
            float frontier_phi_16_1_ladder_20_ladder_1;
            float frontier_phi_16_1_ladder_20_ladder_2;
            float frontier_phi_16_1_ladder_20_ladder_3;
            float frontier_phi_16_1_ladder_20_ladder_4;
            float frontier_phi_16_1_ladder_20_ladder_5;
            float frontier_phi_16_1_ladder_20_ladder_6;
            float frontier_phi_16_1_ladder_20_ladder_7;
            float frontier_phi_16_1_ladder_20_ladder_8;
            if (!(isnan(_683) || isinf(_683)))
            {
                float _1163 = TonemapParam_m0[2u].y * _681;
                float _1170 = (_681 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1163 * _1163) * (3.0f - (_1163 * 2.0f))));
                float _1175 = (_681 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_1_ladder_20_ladder = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_1 = _338;
                frontier_phi_16_1_ladder_20_ladder_2 = _513;
                frontier_phi_16_1_ladder_20_ladder_3 = ((((TonemapParam_m0[0u].x * _681) + TonemapParam_m0[2u].z) * ((1.0f - _1175) - _1170)) + ((TonemapParam_m0[0u].y * exp2(log2(_1163) * TonemapParam_m0[0u].w)) * _1170)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _681) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1175);
                frontier_phi_16_1_ladder_20_ladder_4 = LensDistortionParam_m0[0u].x;
                frontier_phi_16_1_ladder_20_ladder_5 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_6 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_7 = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_8 = LensDistortionParam_m0[1u].x;
            }
            else
            {
                frontier_phi_16_1_ladder_20_ladder = 0.0f;
                frontier_phi_16_1_ladder_20_ladder_1 = _338;
                frontier_phi_16_1_ladder_20_ladder_2 = _513;
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
        _509 = frontier_phi_16_1_ladder_1;
        _512 = frontier_phi_16_1_ladder_2;
        _516 = frontier_phi_16_1_ladder_3;
        _520 = frontier_phi_16_1_ladder_4;
        _521 = frontier_phi_16_1_ladder_5;
        _522 = frontier_phi_16_1_ladder_6;
        _523 = frontier_phi_16_1_ladder;
        _524 = frontier_phi_16_1_ladder_7;
        _525 = frontier_phi_16_1_ladder_8;
    }
    else
    {
        bool _185 = _125 == 0u;
        float frontier_phi_16_2_ladder;
        float frontier_phi_16_2_ladder_1;
        float frontier_phi_16_2_ladder_2;
        float frontier_phi_16_2_ladder_3;
        float frontier_phi_16_2_ladder_4;
        float frontier_phi_16_2_ladder_5;
        float frontier_phi_16_2_ladder_6;
        float frontier_phi_16_2_ladder_7;
        float frontier_phi_16_2_ladder_8;
        if (_122)
        {
            float _234 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
            float _239 = sqrt((_234 * _234) + 1.0f);
            float _240 = 1.0f / _239;
            float _243 = (_239 * PaniniProjectionParam_m0[0u].z) * (_240 + PaniniProjectionParam_m0[0u].x);
            float _247 = PaniniProjectionParam_m0[0u].w * 0.5f;
            float _249 = (_247 * _234) * _243;
            float _252 = ((_247 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_240 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _243;
            float _253 = _249 + 0.5f;
            float _254 = _252 + 0.5f;
            float _354;
            float _356;
            if (_185)
            {
                _354 = _253;
                _356 = _254;
            }
            else
            {
                uint4 _377 = asuint(CBHazeFilterParams_m0[3u]);
                uint _378 = _377.x;
                bool _381 = (_378 & 2u) == 0u;
                float4 _385 = tFilterTempMap1.Sample(BilinearWrap, float2(_253, _254));
                float _387 = _385.x;
                float _1200;
                float _1201;
                if (_381)
                {
                    _1200 = ((_378 & 1u) == 0u) ? _387 : (1.0f - _387);
                    _1201 = 0.0f;
                }
                else
                {
                    float4 _792 = ReadonlyDepth.SampleLevel(PointClamp, float2(_253, _254), 0.0f);
                    float _794 = _792.x;
                    float _801 = (((SceneInfo_m0[23u].x * 2.0f) * _253) * SceneInfo_m0[23u].z) + (-1.0f);
                    float _802 = 1.0f - (((SceneInfo_m0[23u].y * 2.0f) * _254) * SceneInfo_m0[23u].w);
                    float _843 = 1.0f / (mad(_794, SceneInfo_m0[16u].w, mad(_802, SceneInfo_m0[15u].w, _801 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
                    float _845 = _843 * (mad(_794, SceneInfo_m0[16u].y, mad(_802, SceneInfo_m0[15u].y, _801 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
                    float _856 = (_843 * (mad(_794, SceneInfo_m0[16u].x, mad(_802, SceneInfo_m0[15u].x, _801 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
                    float _857 = _845 - SceneInfo_m0[8u].w;
                    float _858 = (_843 * (mad(_794, SceneInfo_m0[16u].z, mad(_802, SceneInfo_m0[15u].z, _801 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
                    _1200 = clamp(_387 * max((sqrt(((_857 * _857) + (_856 * _856)) + (_858 * _858)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_845 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
                    _1201 = _794;
                }
                float _1207 = (-0.0f) - _254;
                float _1233 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1207, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _253));
                float _1234 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1207, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _253));
                float _1235 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1207, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _253));
                float _1246 = _1233 * 2.0f;
                float _1247 = _1234 * 2.0f;
                float _1248 = _1235 * 2.0f;
                float _1257 = _1233 * 4.0f;
                float _1258 = _1234 * 4.0f;
                float _1259 = _1235 * 4.0f;
                float _1268 = _1233 * 8.0f;
                float _1269 = _1234 * 8.0f;
                float _1270 = _1235 * 8.0f;
                float _1279 = CBHazeFilterParams_m0[1u].x + 0.5f;
                float _1280 = CBHazeFilterParams_m0[1u].y + 0.5f;
                float _1281 = CBHazeFilterParams_m0[1u].z + 0.5f;
                float _1321 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1246 + CBHazeFilterParams_m0[1u].x, _1247 + CBHazeFilterParams_m0[1u].y, _1248 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1233 + CBHazeFilterParams_m0[1u].x, _1234 + CBHazeFilterParams_m0[1u].y, _1235 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1257 + CBHazeFilterParams_m0[1u].x, _1258 + CBHazeFilterParams_m0[1u].y, _1259 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1268 + CBHazeFilterParams_m0[1u].x, _1269 + CBHazeFilterParams_m0[1u].y, _1270 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1200) * CBHazeFilterParams_m0[2u].x;
                float _1323 = (CBHazeFilterParams_m0[2u].x * _1200) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1246 + _1279, _1247 + _1280, _1248 + _1281)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1233 + _1279, _1234 + _1280, _1235 + _1281)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1257 + _1279, _1258 + _1280, _1259 + _1281)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1268 + _1279, _1269 + _1280, _1270 + _1281)).x * 0.0625f)) * 2.0f) + (-1.0f));
                float _1779;
                float _1781;
                if ((_378 & 4u) == 0u)
                {
                    _1779 = _1321;
                    _1781 = _1323;
                }
                else
                {
                    float _1792 = 0.5f / CBHazeFilterParams_m0[2u].y;
                    float _1799 = clamp(max((_1792 * min(max(abs(_249) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1792 * min(max(abs(_252) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
                    _1779 = _1321 - (_1799 * _1321);
                    _1781 = _1323 - (_1799 * _1323);
                }
                float _2113;
                float _2114;
                if (_381)
                {
                    _2113 = _1779;
                    _2114 = _1781;
                }
                else
                {
                    float frontier_phi_51_52_ladder;
                    float frontier_phi_51_52_ladder_1;
                    if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1779 + _253, _1781 + _254)).x - _1201) < CBHazeFilterParams_m0[2u].w)
                    {
                        frontier_phi_51_52_ladder = _1781;
                        frontier_phi_51_52_ladder_1 = _1779;
                    }
                    else
                    {
                        frontier_phi_51_52_ladder = 0.0f;
                        frontier_phi_51_52_ladder_1 = 0.0f;
                    }
                    _2113 = frontier_phi_51_52_ladder_1;
                    _2114 = frontier_phi_51_52_ladder;
                }
                _354 = _2113 + _253;
                _356 = _2114 + _254;
            }
            float4 _361 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(_354, _356));
            float _366 = _361.x * _153;
            float _367 = _361.y * _153;
            float _368 = _361.z * _153;
            float _370 = max(max(_366, _367), _368);
            float frontier_phi_16_2_ladder_11_ladder;
            float frontier_phi_16_2_ladder_11_ladder_1;
            float frontier_phi_16_2_ladder_11_ladder_2;
            float frontier_phi_16_2_ladder_11_ladder_3;
            float frontier_phi_16_2_ladder_11_ladder_4;
            float frontier_phi_16_2_ladder_11_ladder_5;
            float frontier_phi_16_2_ladder_11_ladder_6;
            float frontier_phi_16_2_ladder_11_ladder_7;
            float frontier_phi_16_2_ladder_11_ladder_8;
            if (!(isnan(_370) || isinf(_370)))
            {
                float _694 = TonemapParam_m0[2u].y * _366;
                float _700 = TonemapParam_m0[2u].y * _367;
                float _706 = TonemapParam_m0[2u].y * _368;
                float _713 = (_366 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_694 * _694) * (3.0f - (_694 * 2.0f))));
                float _715 = (_367 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_700 * _700) * (3.0f - (_700 * 2.0f))));
                float _717 = (_368 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_706 * _706) * (3.0f - (_706 * 2.0f))));
                float _724 = (_366 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _725 = (_367 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _726 = (_368 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_2_ladder_11_ladder = PaniniProjectionParam_m0[0u].z;
                frontier_phi_16_2_ladder_11_ladder_1 = ((((TonemapParam_m0[0u].x * _366) + TonemapParam_m0[2u].z) * ((1.0f - _724) - _713)) + ((exp2(log2(_694) * TonemapParam_m0[0u].w) * _713) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _366) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _724);
                frontier_phi_16_2_ladder_11_ladder_2 = ((((TonemapParam_m0[0u].x * _367) + TonemapParam_m0[2u].z) * ((1.0f - _725) - _715)) + ((exp2(log2(_700) * TonemapParam_m0[0u].w) * _715) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _367) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _725);
                frontier_phi_16_2_ladder_11_ladder_3 = ((((TonemapParam_m0[0u].x * _368) + TonemapParam_m0[2u].z) * ((1.0f - _726) - _717)) + ((exp2(log2(_706) * TonemapParam_m0[0u].w) * _717) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _368) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _726);
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
            float _257 = SceneInfo_m0[23u].z * gl_FragCoord.x;
            float _258 = SceneInfo_m0[23u].w * gl_FragCoord.y;
            float _878;
            float _880;
            float _882;
            if (_185)
            {
                float4 _391 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_257, _258));
                _878 = _391.x;
                _880 = _391.y;
                _882 = _391.z;
            }
            else
            {
                uint4 _398 = asuint(CBHazeFilterParams_m0[3u]);
                uint _399 = _398.x;
                bool _402 = (_399 & 2u) == 0u;
                float4 _406 = tFilterTempMap1.Sample(BilinearWrap, float2(_257, _258));
                float _408 = _406.x;
                float _1422;
                float _1423;
                if (_402)
                {
                    _1422 = ((_399 & 1u) == 0u) ? _408 : (1.0f - _408);
                    _1423 = 0.0f;
                }
                else
                {
                    float4 _900 = ReadonlyDepth.SampleLevel(PointClamp, float2(_257, _258), 0.0f);
                    float _902 = _900.x;
                    float _907 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
                    float _908 = 1.0f - ((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w);
                    float _949 = 1.0f / (mad(_902, SceneInfo_m0[16u].w, mad(_908, SceneInfo_m0[15u].w, _907 * SceneInfo_m0[14u].w)) + SceneInfo_m0[17u].w);
                    float _951 = _949 * (mad(_902, SceneInfo_m0[16u].y, mad(_908, SceneInfo_m0[15u].y, _907 * SceneInfo_m0[14u].y)) + SceneInfo_m0[17u].y);
                    float _962 = (_949 * (mad(_902, SceneInfo_m0[16u].x, mad(_908, SceneInfo_m0[15u].x, _907 * SceneInfo_m0[14u].x)) + SceneInfo_m0[17u].x)) - SceneInfo_m0[7u].w;
                    float _963 = _951 - SceneInfo_m0[8u].w;
                    float _964 = (_949 * (mad(_902, SceneInfo_m0[16u].z, mad(_908, SceneInfo_m0[15u].z, _907 * SceneInfo_m0[14u].z)) + SceneInfo_m0[17u].z)) - SceneInfo_m0[9u].w;
                    _1422 = clamp(_408 * max((sqrt(((_963 * _963) + (_962 * _962)) + (_964 * _964)) - CBHazeFilterParams_m0[0u].x) * CBHazeFilterParams_m0[0u].y, (_951 - CBHazeFilterParams_m0[0u].z) * CBHazeFilterParams_m0[0u].w), 0.0f, 1.0f);
                    _1423 = _902;
                }
                float _1429 = (-0.0f) - _258;
                float _1455 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[7u].z, mad(_1429, SceneInfo_m0[7u].y, SceneInfo_m0[7u].x * _257));
                float _1456 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[8u].z, mad(_1429, SceneInfo_m0[8u].y, SceneInfo_m0[8u].x * _257));
                float _1457 = CBHazeFilterParams_m0[1u].w * mad(-1.0f, SceneInfo_m0[9u].z, mad(_1429, SceneInfo_m0[9u].y, SceneInfo_m0[9u].x * _257));
                float _1468 = _1455 * 2.0f;
                float _1469 = _1456 * 2.0f;
                float _1470 = _1457 * 2.0f;
                float _1479 = _1455 * 4.0f;
                float _1480 = _1456 * 4.0f;
                float _1481 = _1457 * 4.0f;
                float _1490 = _1455 * 8.0f;
                float _1491 = _1456 * 8.0f;
                float _1492 = _1457 * 8.0f;
                float _1501 = CBHazeFilterParams_m0[1u].x + 0.5f;
                float _1502 = CBHazeFilterParams_m0[1u].y + 0.5f;
                float _1503 = CBHazeFilterParams_m0[1u].z + 0.5f;
                float4 _1530 = tVolumeMap.Sample(BilinearWrap, float3(_1490 + _1501, _1491 + _1502, _1492 + _1503));
                float _1543 = (((((((tVolumeMap.Sample(BilinearWrap, float3(_1468 + CBHazeFilterParams_m0[1u].x, _1469 + CBHazeFilterParams_m0[1u].y, _1470 + CBHazeFilterParams_m0[1u].z)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1455 + CBHazeFilterParams_m0[1u].x, _1456 + CBHazeFilterParams_m0[1u].y, _1457 + CBHazeFilterParams_m0[1u].z)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1479 + CBHazeFilterParams_m0[1u].x, _1480 + CBHazeFilterParams_m0[1u].y, _1481 + CBHazeFilterParams_m0[1u].z)).x * 0.125f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1490 + CBHazeFilterParams_m0[1u].x, _1491 + CBHazeFilterParams_m0[1u].y, _1492 + CBHazeFilterParams_m0[1u].z)).x * 0.0625f)) * 2.0f) + (-1.0f)) * _1422) * CBHazeFilterParams_m0[2u].x;
                float _1545 = (CBHazeFilterParams_m0[2u].x * _1422) * ((((((tVolumeMap.Sample(BilinearWrap, float3(_1468 + _1501, _1469 + _1502, _1470 + _1503)).x * 0.25f) + (tVolumeMap.Sample(BilinearWrap, float3(_1455 + _1501, _1456 + _1502, _1457 + _1503)).x * 0.5f)) + (tVolumeMap.Sample(BilinearWrap, float3(_1479 + _1501, _1480 + _1502, _1481 + _1503)).x * 0.125f)) + (_1530.x * 0.0625f)) * 2.0f) + (-1.0f));
                float _1802;
                float _1804;
                if ((_399 & 4u) == 0u)
                {
                    _1802 = _1543;
                    _1804 = _1545;
                }
                else
                {
                    float _1817 = 0.5f / CBHazeFilterParams_m0[2u].y;
                    float _1824 = clamp(max((_1817 * min(max(abs(_257 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z, (_1817 * min(max(abs(_258 + (-0.5f)) - CBHazeFilterParams_m0[2u].y, 0.0f), 1.0f)) * CBHazeFilterParams_m0[2u].z), 0.0f, 1.0f);
                    _1802 = _1543 - (_1824 * _1543);
                    _1804 = _1545 - (_1824 * _1545);
                }
                float _2125;
                float _2126;
                if (_402)
                {
                    _2125 = _1802;
                    _2126 = _1804;
                }
                else
                {
                    float frontier_phi_53_54_ladder;
                    float frontier_phi_53_54_ladder_1;
                    if ((ReadonlyDepth.Sample(BilinearWrap, float2(_1802 + _257, _1804 + _258)).x - _1423) < CBHazeFilterParams_m0[2u].w)
                    {
                        frontier_phi_53_54_ladder = _1804;
                        frontier_phi_53_54_ladder_1 = _1802;
                    }
                    else
                    {
                        frontier_phi_53_54_ladder = 0.0f;
                        frontier_phi_53_54_ladder_1 = 0.0f;
                    }
                    _2125 = frontier_phi_53_54_ladder_1;
                    _2126 = frontier_phi_53_54_ladder;
                }
                float4 _2132 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2(_2125 + _257, _2126 + _258));
                _878 = _2132.x;
                _880 = _2132.y;
                _882 = _2132.z;
            }
            float _884 = _878 * _153;
            float _885 = _880 * _153;
            float _886 = _882 * _153;
            float _888 = max(max(_884, _885), _886);
            float frontier_phi_16_2_ladder_24_ladder;
            float frontier_phi_16_2_ladder_24_ladder_1;
            float frontier_phi_16_2_ladder_24_ladder_2;
            float frontier_phi_16_2_ladder_24_ladder_3;
            float frontier_phi_16_2_ladder_24_ladder_4;
            float frontier_phi_16_2_ladder_24_ladder_5;
            float frontier_phi_16_2_ladder_24_ladder_6;
            float frontier_phi_16_2_ladder_24_ladder_7;
            float frontier_phi_16_2_ladder_24_ladder_8;
            if (!(isnan(_888) || isinf(_888)))
            {
                float _1331 = TonemapParam_m0[2u].y * _884;
                float _1337 = TonemapParam_m0[2u].y * _885;
                float _1343 = TonemapParam_m0[2u].y * _886;
                float _1350 = (_884 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1331 * _1331) * (3.0f - (_1331 * 2.0f))));
                float _1352 = (_885 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1337 * _1337) * (3.0f - (_1337 * 2.0f))));
                float _1354 = (_886 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1343 * _1343) * (3.0f - (_1343 * 2.0f))));
                float _1361 = (_884 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _1362 = (_885 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                float _1363 = (_886 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                frontier_phi_16_2_ladder_24_ladder = 0.0f;
                frontier_phi_16_2_ladder_24_ladder_1 = ((((TonemapParam_m0[0u].x * _884) + TonemapParam_m0[2u].z) * ((1.0f - _1361) - _1350)) + ((exp2(log2(_1331) * TonemapParam_m0[0u].w) * _1350) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _884) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1361);
                frontier_phi_16_2_ladder_24_ladder_2 = ((((TonemapParam_m0[0u].x * _885) + TonemapParam_m0[2u].z) * ((1.0f - _1362) - _1352)) + ((exp2(log2(_1337) * TonemapParam_m0[0u].w) * _1352) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _885) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1362);
                frontier_phi_16_2_ladder_24_ladder_3 = ((((TonemapParam_m0[0u].x * _886) + TonemapParam_m0[2u].z) * ((1.0f - _1363) - _1354)) + ((exp2(log2(_1343) * TonemapParam_m0[0u].w) * _1354) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _886) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1363);
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
        _509 = frontier_phi_16_2_ladder_1;
        _512 = frontier_phi_16_2_ladder_2;
        _516 = frontier_phi_16_2_ladder_3;
        _520 = frontier_phi_16_2_ladder_4;
        _521 = frontier_phi_16_2_ladder_5;
        _522 = frontier_phi_16_2_ladder_6;
        _523 = frontier_phi_16_2_ladder;
        _524 = frontier_phi_16_2_ladder_7;
        _525 = frontier_phi_16_2_ladder_8;
    }
    float _984;
    float _986;
    float _988;
    if ((_111 & 32u) == 0u)
    {
        _984 = _509;
        _986 = _512;
        _988 = _516;
    }
    else
    {
        uint4 _1011 = asuint(RadialBlurRenderParam_m0[3u]);
        uint _1012 = _1011.x;
        float _1015 = float((_1012 & 2u) != 0u);
        float _1023 = ((1.0f - _1015) + (asfloat(ComputeResultSRV.Load(0u).x) * _1015)) * RadialBlurRenderParam_m0[0u].w;
        float frontier_phi_27_28_ladder;
        float frontier_phi_27_28_ladder_1;
        float frontier_phi_27_28_ladder_2;
        if (_1023 == 0.0f)
        {
            frontier_phi_27_28_ladder = _516;
            frontier_phi_27_28_ladder_1 = _509;
            frontier_phi_27_28_ladder_2 = _512;
        }
        else
        {
            float _1595 = SceneInfo_m0[23u].z * gl_FragCoord.x;
            float _1596 = SceneInfo_m0[23u].w * gl_FragCoord.y;
            float _1598 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _1595;
            float _1600 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _1596;
            float _1603 = (_1598 < 0.0f) ? (1.0f - _1595) : _1595;
            float _1606 = (_1600 < 0.0f) ? (1.0f - _1596) : _1596;
            float _1613 = rsqrt(dot(float2(_1598, _1600), float2(_1598, _1600))) * RadialBlurRenderParam_m0[2u].w;
            uint _1620 = uint(abs(_1613 * _1600)) + uint(abs(_1613 * _1598));
            uint _1625 = ((_1620 ^ 61u) ^ (_1620 >> 16u)) * 9u;
            uint _1628 = ((_1625 >> 4u) ^ _1625) * 668265261u;
            float _1635 = ((_1012 & 1u) != 0u) ? (float((_1628 >> 15u) ^ _1628) * 2.3283064365386962890625e-10f) : 1.0f;
            float _1641 = 1.0f / max(1.0f, sqrt((_1598 * _1598) + (_1600 * _1600)));
            float _1642 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
            float _1652 = ((((_1642 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1653 = ((((_1642 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1655 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
            float _1665 = ((((_1655 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1666 = ((((_1655 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1667 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
            float _1677 = ((((_1667 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1678 = ((((_1667 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1679 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
            float _1689 = ((((_1679 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1690 = ((((_1679 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1691 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
            float _1701 = ((((_1691 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1702 = ((((_1691 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1703 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
            float _1713 = ((((_1703 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1714 = ((((_1703 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1715 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
            float _1725 = ((((_1715 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1726 = ((((_1715 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1727 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
            float _1737 = ((((_1727 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1738 = ((((_1727 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1739 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
            float _1749 = ((((_1739 * _1603) * _1635) * _1641) + 1.0f) * _1598;
            float _1750 = ((((_1739 * _1606) * _1635) * _1641) + 1.0f) * _1600;
            float _1751 = (_152 * Exposure) * 0.100000001490116119384765625f;
            float _1753 = _1751 * RadialBlurRenderParam_m0[0u].x;
            float _1754 = _1751 * RadialBlurRenderParam_m0[0u].y;
            float _1755 = _1751 * RadialBlurRenderParam_m0[0u].z;
            float _2801;
            float _2804;
            float _2807;
            if (_120)
            {
                float _1885 = _1652 + RadialBlurRenderParam_m0[1u].x;
                float _1886 = _1653 + RadialBlurRenderParam_m0[1u].y;
                float _1892 = ((dot(float2(_1885, _1886), float2(_1885, _1886)) * _520) + 1.0f) * _525;
                float4 _1899 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_1892 * _1885) + 0.5f, (_1892 * _1886) + 0.5f), 0.0f);
                float _1904 = _1665 + RadialBlurRenderParam_m0[1u].x;
                float _1905 = _1666 + RadialBlurRenderParam_m0[1u].y;
                float _1910 = (dot(float2(_1904, _1905), float2(_1904, _1905)) * _520) + 1.0f;
                float4 _1917 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1904 * _525) * _1910) + 0.5f, ((_1905 * _525) * _1910) + 0.5f), 0.0f);
                float _1925 = _1677 + RadialBlurRenderParam_m0[1u].x;
                float _1926 = _1678 + RadialBlurRenderParam_m0[1u].y;
                float _1931 = (dot(float2(_1925, _1926), float2(_1925, _1926)) * _520) + 1.0f;
                float4 _1938 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1925 * _525) * _1931) + 0.5f, ((_1926 * _525) * _1931) + 0.5f), 0.0f);
                float _1946 = _1689 + RadialBlurRenderParam_m0[1u].x;
                float _1947 = _1690 + RadialBlurRenderParam_m0[1u].y;
                float _1952 = (dot(float2(_1946, _1947), float2(_1946, _1947)) * _520) + 1.0f;
                float4 _1959 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1946 * _525) * _1952) + 0.5f, ((_1947 * _525) * _1952) + 0.5f), 0.0f);
                float _1967 = _1701 + RadialBlurRenderParam_m0[1u].x;
                float _1968 = _1702 + RadialBlurRenderParam_m0[1u].y;
                float _1973 = (dot(float2(_1967, _1968), float2(_1967, _1968)) * _520) + 1.0f;
                float4 _1980 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1967 * _525) * _1973) + 0.5f, ((_1968 * _525) * _1973) + 0.5f), 0.0f);
                float _1988 = _1713 + RadialBlurRenderParam_m0[1u].x;
                float _1989 = _1714 + RadialBlurRenderParam_m0[1u].y;
                float _1994 = (dot(float2(_1988, _1989), float2(_1988, _1989)) * _520) + 1.0f;
                float4 _2001 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1988 * _525) * _1994) + 0.5f, ((_1989 * _525) * _1994) + 0.5f), 0.0f);
                float _2009 = _1725 + RadialBlurRenderParam_m0[1u].x;
                float _2010 = _1726 + RadialBlurRenderParam_m0[1u].y;
                float _2015 = (dot(float2(_2009, _2010), float2(_2009, _2010)) * _520) + 1.0f;
                float4 _2022 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_2009 * _525) * _2015) + 0.5f, ((_2010 * _525) * _2015) + 0.5f), 0.0f);
                float _2030 = _1737 + RadialBlurRenderParam_m0[1u].x;
                float _2031 = _1738 + RadialBlurRenderParam_m0[1u].y;
                float _2036 = (dot(float2(_2030, _2031), float2(_2030, _2031)) * _520) + 1.0f;
                float4 _2043 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_2030 * _525) * _2036) + 0.5f, ((_2031 * _525) * _2036) + 0.5f), 0.0f);
                float _2051 = _1749 + RadialBlurRenderParam_m0[1u].x;
                float _2052 = _1750 + RadialBlurRenderParam_m0[1u].y;
                float _2057 = (dot(float2(_2051, _2052), float2(_2051, _2052)) * _520) + 1.0f;
                float4 _2064 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_2051 * _525) * _2057) + 0.5f, ((_2052 * _525) * _2057) + 0.5f), 0.0f);
                float _2072 = _1753 * ((((((((_1917.x + _1899.x) + _1938.x) + _1959.x) + _1980.x) + _2001.x) + _2022.x) + _2043.x) + _2064.x);
                float _2073 = _1754 * ((((((((_1917.y + _1899.y) + _1938.y) + _1959.y) + _1980.y) + _2001.y) + _2022.y) + _2043.y) + _2064.y);
                float _2074 = _1755 * ((((((((_1917.z + _1899.z) + _1938.z) + _1959.z) + _1980.z) + _2001.z) + _2022.z) + _2043.z) + _2064.z);
                float _2076 = max(max(_2072, _2073), _2074);
                float _2305;
                float _2306;
                float _2307;
                if (!(isnan(_2076) || isinf(_2076)))
                {
                    float _2211 = TonemapParam_m0[2u].y * _2072;
                    float _2217 = TonemapParam_m0[2u].y * _2073;
                    float _2223 = TonemapParam_m0[2u].y * _2074;
                    float _2230 = (_2072 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2211 * _2211) * (3.0f - (_2211 * 2.0f))));
                    float _2232 = (_2073 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2217 * _2217) * (3.0f - (_2217 * 2.0f))));
                    float _2234 = (_2074 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2223 * _2223) * (3.0f - (_2223 * 2.0f))));
                    float _2241 = (_2072 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                    float _2242 = (_2073 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                    float _2243 = (_2074 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                    _2305 = ((((TonemapParam_m0[0u].x * _2072) + TonemapParam_m0[2u].z) * ((1.0f - _2241) - _2230)) + ((exp2(log2(_2211) * TonemapParam_m0[0u].w) * _2230) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2072) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2241);
                    _2306 = ((((TonemapParam_m0[0u].x * _2073) + TonemapParam_m0[2u].z) * ((1.0f - _2242) - _2232)) + ((exp2(log2(_2217) * TonemapParam_m0[0u].w) * _2232) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2073) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2242);
                    _2307 = ((((TonemapParam_m0[0u].x * _2074) + TonemapParam_m0[2u].z) * ((1.0f - _2243) - _2234)) + ((exp2(log2(_2223) * TonemapParam_m0[0u].w) * _2234) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2074) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2243);
                }
                else
                {
                    _2305 = 1.0f;
                    _2306 = 1.0f;
                    _2307 = 1.0f;
                }
                _2801 = _2305 + ((_509 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
                _2804 = _2306 + ((_512 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
                _2807 = _2307 + ((_516 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
            }
            else
            {
                float _2081 = RadialBlurRenderParam_m0[1u].x + 0.5f;
                float _2082 = _2081 + _1652;
                float _2083 = RadialBlurRenderParam_m0[1u].y + 0.5f;
                float _2084 = _2083 + _1653;
                float _2085 = _2081 + _1665;
                float _2086 = _2083 + _1666;
                float _2087 = _2081 + _1677;
                float _2088 = _2083 + _1678;
                float _2089 = _2081 + _1689;
                float _2090 = _2083 + _1690;
                float _2091 = _2081 + _1701;
                float _2092 = _2083 + _1702;
                float _2093 = _2081 + _1713;
                float _2094 = _2083 + _1714;
                float _2095 = _2081 + _1725;
                float _2096 = _2083 + _1726;
                float _2097 = _2081 + _1737;
                float _2098 = _2083 + _1738;
                float _2099 = _2081 + _1749;
                float _2100 = _2083 + _1750;
                float frontier_phi_74_48_ladder;
                float frontier_phi_74_48_ladder_1;
                float frontier_phi_74_48_ladder_2;
                if (_122)
                {
                    float _2319 = (_2082 * 2.0f) + (-1.0f);
                    float _2323 = sqrt((_2319 * _2319) + 1.0f);
                    float _2324 = 1.0f / _2323;
                    float _2327 = (_2323 * _523) * (_2324 + _521);
                    float _2331 = _524 * 0.5f;
                    float4 _2341 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2327) * _2319) + 0.5f, (((_2331 * (((_2324 + (-1.0f)) * _522) + 1.0f)) * _2327) * ((_2084 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
                    float _2348 = (_2085 * 2.0f) + (-1.0f);
                    float _2352 = sqrt((_2348 * _2348) + 1.0f);
                    float _2353 = 1.0f / _2352;
                    float _2356 = (_2352 * _523) * (_2353 + _521);
                    float4 _2367 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2348) * _2356) + 0.5f, (((_2331 * ((_2086 * 2.0f) + (-1.0f))) * (((_2353 + (-1.0f)) * _522) + 1.0f)) * _2356) + 0.5f), 0.0f);
                    float _2377 = (_2087 * 2.0f) + (-1.0f);
                    float _2381 = sqrt((_2377 * _2377) + 1.0f);
                    float _2382 = 1.0f / _2381;
                    float _2385 = (_2381 * _523) * (_2382 + _521);
                    float4 _2396 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2377) * _2385) + 0.5f, (((_2331 * ((_2088 * 2.0f) + (-1.0f))) * (((_2382 + (-1.0f)) * _522) + 1.0f)) * _2385) + 0.5f), 0.0f);
                    float _2406 = (_2089 * 2.0f) + (-1.0f);
                    float _2410 = sqrt((_2406 * _2406) + 1.0f);
                    float _2411 = 1.0f / _2410;
                    float _2414 = (_2410 * _523) * (_2411 + _521);
                    float4 _2425 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2406) * _2414) + 0.5f, (((_2331 * ((_2090 * 2.0f) + (-1.0f))) * (((_2411 + (-1.0f)) * _522) + 1.0f)) * _2414) + 0.5f), 0.0f);
                    float _2435 = (_2091 * 2.0f) + (-1.0f);
                    float _2439 = sqrt((_2435 * _2435) + 1.0f);
                    float _2440 = 1.0f / _2439;
                    float _2443 = (_2439 * _523) * (_2440 + _521);
                    float4 _2454 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2435) * _2443) + 0.5f, (((_2331 * ((_2092 * 2.0f) + (-1.0f))) * (((_2440 + (-1.0f)) * _522) + 1.0f)) * _2443) + 0.5f), 0.0f);
                    float _2464 = (_2093 * 2.0f) + (-1.0f);
                    float _2468 = sqrt((_2464 * _2464) + 1.0f);
                    float _2469 = 1.0f / _2468;
                    float _2472 = (_2468 * _523) * (_2469 + _521);
                    float4 _2483 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2464) * _2472) + 0.5f, (((_2331 * ((_2094 * 2.0f) + (-1.0f))) * (((_2469 + (-1.0f)) * _522) + 1.0f)) * _2472) + 0.5f), 0.0f);
                    float _2493 = (_2095 * 2.0f) + (-1.0f);
                    float _2497 = sqrt((_2493 * _2493) + 1.0f);
                    float _2498 = 1.0f / _2497;
                    float _2501 = (_2497 * _523) * (_2498 + _521);
                    float4 _2512 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2493) * _2501) + 0.5f, (((_2331 * ((_2096 * 2.0f) + (-1.0f))) * (((_2498 + (-1.0f)) * _522) + 1.0f)) * _2501) + 0.5f), 0.0f);
                    float _2522 = (_2097 * 2.0f) + (-1.0f);
                    float _2526 = sqrt((_2522 * _2522) + 1.0f);
                    float _2527 = 1.0f / _2526;
                    float _2530 = (_2526 * _523) * (_2527 + _521);
                    float4 _2541 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2522) * _2530) + 0.5f, (((_2331 * ((_2098 * 2.0f) + (-1.0f))) * (((_2527 + (-1.0f)) * _522) + 1.0f)) * _2530) + 0.5f), 0.0f);
                    float _2551 = (_2099 * 2.0f) + (-1.0f);
                    float _2555 = sqrt((_2551 * _2551) + 1.0f);
                    float _2556 = 1.0f / _2555;
                    float _2559 = (_2555 * _523) * (_2556 + _521);
                    float4 _2570 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_2331 * _2551) * _2559) + 0.5f, (((_2331 * ((_2100 * 2.0f) + (-1.0f))) * (((_2556 + (-1.0f)) * _522) + 1.0f)) * _2559) + 0.5f), 0.0f);
                    float _2578 = _1753 * ((((((((_2367.x + _2341.x) + _2396.x) + _2425.x) + _2454.x) + _2483.x) + _2512.x) + _2541.x) + _2570.x);
                    float _2579 = _1754 * ((((((((_2367.y + _2341.y) + _2396.y) + _2425.y) + _2454.y) + _2483.y) + _2512.y) + _2541.y) + _2570.y);
                    float _2580 = _1755 * ((((((((_2367.z + _2341.z) + _2396.z) + _2425.z) + _2454.z) + _2483.z) + _2512.z) + _2541.z) + _2570.z);
                    float _2582 = max(max(_2578, _2579), _2580);
                    float _2911;
                    float _2912;
                    float _2913;
                    if (!(isnan(_2582) || isinf(_2582)))
                    {
                        float _2817 = TonemapParam_m0[2u].y * _2578;
                        float _2823 = TonemapParam_m0[2u].y * _2579;
                        float _2829 = TonemapParam_m0[2u].y * _2580;
                        float _2836 = (_2578 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2817 * _2817) * (3.0f - (_2817 * 2.0f))));
                        float _2838 = (_2579 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2823 * _2823) * (3.0f - (_2823 * 2.0f))));
                        float _2840 = (_2580 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2829 * _2829) * (3.0f - (_2829 * 2.0f))));
                        float _2847 = (_2578 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2848 = (_2579 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2849 = (_2580 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        _2911 = ((((TonemapParam_m0[0u].x * _2578) + TonemapParam_m0[2u].z) * ((1.0f - _2847) - _2836)) + ((exp2(log2(_2817) * TonemapParam_m0[0u].w) * _2836) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2578) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2847);
                        _2912 = ((((TonemapParam_m0[0u].x * _2579) + TonemapParam_m0[2u].z) * ((1.0f - _2848) - _2838)) + ((exp2(log2(_2823) * TonemapParam_m0[0u].w) * _2838) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2579) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2848);
                        _2913 = ((((TonemapParam_m0[0u].x * _2580) + TonemapParam_m0[2u].z) * ((1.0f - _2849) - _2840)) + ((exp2(log2(_2829) * TonemapParam_m0[0u].w) * _2840) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2580) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2849);
                    }
                    else
                    {
                        _2911 = 1.0f;
                        _2912 = 1.0f;
                        _2913 = 1.0f;
                    }
                    frontier_phi_74_48_ladder = _2913 + ((_516 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
                    frontier_phi_74_48_ladder_1 = _2912 + ((_512 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
                    frontier_phi_74_48_ladder_2 = _2911 + ((_509 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
                }
                else
                {
                    float4 _2589 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2082, _2084), 0.0f);
                    float4 _2594 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2085, _2086), 0.0f);
                    float4 _2602 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2087, _2088), 0.0f);
                    float4 _2610 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2089, _2090), 0.0f);
                    float4 _2618 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2091, _2092), 0.0f);
                    float4 _2626 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2093, _2094), 0.0f);
                    float4 _2634 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2095, _2096), 0.0f);
                    float4 _2642 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2097, _2098), 0.0f);
                    float4 _2650 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_2099, _2100), 0.0f);
                    float _2658 = _1753 * ((((((((_2594.x + _2589.x) + _2602.x) + _2610.x) + _2618.x) + _2626.x) + _2634.x) + _2642.x) + _2650.x);
                    float _2659 = _1754 * ((((((((_2594.y + _2589.y) + _2602.y) + _2610.y) + _2618.y) + _2626.y) + _2634.y) + _2642.y) + _2650.y);
                    float _2660 = _1755 * ((((((((_2594.z + _2589.z) + _2602.z) + _2610.z) + _2618.z) + _2626.z) + _2634.z) + _2642.z) + _2650.z);
                    float _2662 = max(max(_2658, _2659), _2660);
                    float _3020;
                    float _3021;
                    float _3022;
                    if (!(isnan(_2662) || isinf(_2662)))
                    {
                        float _2926 = TonemapParam_m0[2u].y * _2658;
                        float _2932 = TonemapParam_m0[2u].y * _2659;
                        float _2938 = TonemapParam_m0[2u].y * _2660;
                        float _2945 = (_2658 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2926 * _2926) * (3.0f - (_2926 * 2.0f))));
                        float _2947 = (_2659 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2932 * _2932) * (3.0f - (_2932 * 2.0f))));
                        float _2949 = (_2660 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_2938 * _2938) * (3.0f - (_2938 * 2.0f))));
                        float _2956 = (_2658 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2957 = (_2659 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        float _2958 = (_2660 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
                        _3020 = ((((TonemapParam_m0[0u].x * _2658) + TonemapParam_m0[2u].z) * ((1.0f - _2956) - _2945)) + ((exp2(log2(_2926) * TonemapParam_m0[0u].w) * _2945) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2658) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2956);
                        _3021 = ((((TonemapParam_m0[0u].x * _2659) + TonemapParam_m0[2u].z) * ((1.0f - _2957) - _2947)) + ((exp2(log2(_2932) * TonemapParam_m0[0u].w) * _2947) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2659) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2957);
                        _3022 = ((((TonemapParam_m0[0u].x * _2660) + TonemapParam_m0[2u].z) * ((1.0f - _2958) - _2949)) + ((exp2(log2(_2938) * TonemapParam_m0[0u].w) * _2949) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _2660) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _2958);
                    }
                    else
                    {
                        _3020 = 1.0f;
                        _3021 = 1.0f;
                        _3022 = 1.0f;
                    }
                    frontier_phi_74_48_ladder = _3022 + ((_516 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
                    frontier_phi_74_48_ladder_1 = _3021 + ((_512 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
                    frontier_phi_74_48_ladder_2 = _3020 + ((_509 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
                }
                _2801 = frontier_phi_74_48_ladder_2;
                _2804 = frontier_phi_74_48_ladder_1;
                _2807 = frontier_phi_74_48_ladder;
            }
            float _3053;
            float _3054;
            float _3055;
            if (RadialBlurRenderParam_m0[2u].x > 0.0f)
            {
                float _3037 = clamp((sqrt((_1598 * _1598) + (_1600 * _1600)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
                float _3043 = (((_3037 * _3037) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_3037 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
                _3053 = (_3043 * (_2801 - _509)) + _509;
                _3054 = (_3043 * (_2804 - _512)) + _512;
                _3055 = (_3043 * (_2807 - _516)) + _516;
            }
            else
            {
                _3053 = _2801;
                _3054 = _2804;
                _3055 = _2807;
            }
            frontier_phi_27_28_ladder = ((_3055 - _516) * _1023) + _516;
            frontier_phi_27_28_ladder_1 = ((_3053 - _509) * _1023) + _509;
            frontier_phi_27_28_ladder_2 = ((_3054 - _512) * _1023) + _512;
        }
        _984 = frontier_phi_27_28_ladder_1;
        _986 = frontier_phi_27_28_ladder_2;
        _988 = frontier_phi_27_28_ladder;
    }
    float _1547;
    float _1549;
    float _1551;
    if ((_111 & 2u) == 0u)
    {
        _1547 = _984;
        _1549 = _986;
        _1551 = _988;
    }
    else
    {
        float _1576 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
        float _1578 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
        float _1587 = frac(frac(dot(float2(_1576, _1578), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
        float _1880;
        if (_1587 < FilmGrainParam_m0[1u].x)
        {
            uint _1868 = uint(_1578 * _1576) ^ 12345391u;
            uint _1870 = _1868 * 3635641u;
            _1880 = float(((_1870 >> 26u) | (_1868 * 232681024u)) ^ _1870) * 2.3283064365386962890625e-10f;
        }
        else
        {
            _1880 = 0.0f;
        }
        float _1883 = frac(_1587 * 757.48468017578125f);
        float _2201;
        if (_1883 < FilmGrainParam_m0[1u].x)
        {
            uint _2192 = asuint(_1883) ^ 12345391u;
            uint _2193 = _2192 * 3635641u;
            _2201 = (float(((_2193 >> 26u) | (_2192 * 232681024u)) ^ _2193) * 2.3283064365386962890625e-10f) + (-0.5f);
        }
        else
        {
            _2201 = 0.0f;
        }
        float _2203 = frac(_1883 * 757.48468017578125f);
        float _2769;
        if (_2203 < FilmGrainParam_m0[1u].x)
        {
            uint _2760 = asuint(_2203) ^ 12345391u;
            uint _2761 = _2760 * 3635641u;
            _2769 = (float(((_2761 >> 26u) | (_2760 * 232681024u)) ^ _2761) * 2.3283064365386962890625e-10f) + (-0.5f);
        }
        else
        {
            _2769 = 0.0f;
        }
        float _2770 = _1880 * FilmGrainParam_m0[0u].x;
        float _2771 = _2769 * FilmGrainParam_m0[0u].y;
        float _2772 = _2201 * FilmGrainParam_m0[0u].y;
        float _2794 = exp2(log2(1.0f - clamp(dot(float3(clamp(_984, 0.0f, 1.0f), clamp(_986, 0.0f, 1.0f), clamp(_988, 0.0f, 1.0f)), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
        _1547 = (_2794 * (mad(_2772, 1.401999950408935546875f, _2770) - _984)) + _984;
        _1549 = (_2794 * (mad(_2772, -0.7139999866485595703125f, mad(_2771, -0.3440000116825103759765625f, _2770)) - _986)) + _986;
        _1551 = (_2794 * (mad(_2771, 1.77199995517730712890625f, _2770) - _988)) + _988;
    }
    float _1827;
    float _1830;
    float _1833;
    if ((_111 & 4u) == 0u)
    {
        _1827 = _1547;
        _1830 = _1549;
        _1833 = _1551;
    }
    else
    {
        float _1864 = max(max(_1547, _1549), _1551);
        bool _1865 = _1864 > 1.0f;
        float _2185;
        float _2186;
        float _2187;
        if (_1865)
        {
            _2185 = _1547 / _1864;
            _2186 = _1549 / _1864;
            _2187 = _1551 / _1864;
        }
        else
        {
            _2185 = _1547;
            _2186 = _1549;
            _2187 = _1551;
        }
#if 0
        float _2188 = ColorCorrectTexture_m0[0u].w * 0.5f;
        float _3029;
        if (_2185 > 0.003130800090730190277099609375f)
        {
            _3029 = (exp2(log2(_2185) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _3029 = _2185 * 12.9200000762939453125f;
        }
        float _3068;
        if (_2186 > 0.003130800090730190277099609375f)
        {
            _3068 = (exp2(log2(_2186) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _3068 = _2186 * 12.9200000762939453125f;
        }
        float _3076;
        if (_2187 > 0.003130800090730190277099609375f)
        {
            _3076 = (exp2(log2(_2187) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _3076 = _2187 * 12.9200000762939453125f;
        }
        float _3077 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _3081 = (_3029 * _3077) + _2188;
        float _3082 = (_3068 * _3077) + _2188;
        float _3083 = (_3076 * _3077) + _2188;
        float4 _3087 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_3081, _3082, _3083), 0.0f);
#else
        float3 _3087 = LUTBlackCorrection(float3(_2185, _2186, _2187), tTextureMap0, lut_config);
#endif
        float _3089 = _3087.x;
        float _3090 = _3087.y;
        float _3091 = _3087.z;
        bool _3093 = ColorCorrectTexture_m0[0u].z > 0.0f;
        float _3111;
        float _3114;
        float _3117;
        if (ColorCorrectTexture_m0[0u].y > 0.0f)
        {
#if 0
            float4 _3096 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_3081, _3082, _3083), 0.0f);
#else
          float3 _3096 = LUTBlackCorrection(float3(_2185, _2186, _2187), tTextureMap1, lut_config);
#endif
            float _3107 = ((_3096.x - _3089) * ColorCorrectTexture_m0[0u].y) + _3089;
            float _3108 = ((_3096.y - _3090) * ColorCorrectTexture_m0[0u].y) + _3090;
            float _3109 = ((_3096.z - _3091) * ColorCorrectTexture_m0[0u].y) + _3091;
            float frontier_phi_91_88_ladder;
            float frontier_phi_91_88_ladder_1;
            float frontier_phi_91_88_ladder_2;
            if (_3093)
            {
#if 0
                float _3142;
                if (_3107 > 0.003130800090730190277099609375f)
                {
                    _3142 = (exp2(log2(_3107) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3142 = _3107 * 12.9200000762939453125f;
                }
                float _3158;
                if (_3108 > 0.003130800090730190277099609375f)
                {
                    _3158 = (exp2(log2(_3108) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3158 = _3108 * 12.9200000762939453125f;
                }
                float _3174;
                if (_3109 > 0.003130800090730190277099609375f)
                {
                    _3174 = (exp2(log2(_3109) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3174 = _3109 * 12.9200000762939453125f;
                }
                float4 _3177 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_3142, _3158, _3174), 0.0f);
#else
                float3 _3177 = LUTBlackCorrection(float3(_3107, _3108, _3109), tTextureMap2, lut_config);
#endif

                frontier_phi_91_88_ladder = ((_3177.z - _3109) * ColorCorrectTexture_m0[0u].z) + _3109;
                frontier_phi_91_88_ladder_1 = ((_3177.y - _3108) * ColorCorrectTexture_m0[0u].z) + _3108;
                frontier_phi_91_88_ladder_2 = ((_3177.x - _3107) * ColorCorrectTexture_m0[0u].z) + _3107;
            }
            else
            {
                frontier_phi_91_88_ladder = _3109;
                frontier_phi_91_88_ladder_1 = _3108;
                frontier_phi_91_88_ladder_2 = _3107;
            }
            _3111 = frontier_phi_91_88_ladder_2;
            _3114 = frontier_phi_91_88_ladder_1;
            _3117 = frontier_phi_91_88_ladder;
        }
        else
        {
            float frontier_phi_91_89_ladder;
            float frontier_phi_91_89_ladder_1;
            float frontier_phi_91_89_ladder_2;
            if (_3093)
            {
#if 0
                float _3144;
                if (_3089 > 0.003130800090730190277099609375f)
                {
                    _3144 = (exp2(log2(_3089) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3144 = _3089 * 12.9200000762939453125f;
                }
                float _3160;
                if (_3090 > 0.003130800090730190277099609375f)
                {
                    _3160 = (exp2(log2(_3090) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3160 = _3090 * 12.9200000762939453125f;
                }
                float _3188;
                if (_3091 > 0.003130800090730190277099609375f)
                {
                    _3188 = (exp2(log2(_3091) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _3188 = _3091 * 12.9200000762939453125f;
                }
                float4 _3191 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_3144, _3160, _3188), 0.0f);
#else
                float3 _3191 = LUTBlackCorrection(float3(_3089, _3090, _3091), tTextureMap2, lut_config);
#endif
                frontier_phi_91_89_ladder = ((_3191.z - _3091) * ColorCorrectTexture_m0[0u].z) + _3091;
                frontier_phi_91_89_ladder_1 = ((_3191.y - _3090) * ColorCorrectTexture_m0[0u].z) + _3090;
                frontier_phi_91_89_ladder_2 = ((_3191.x - _3089) * ColorCorrectTexture_m0[0u].z) + _3089;
            }
            else
            {
                frontier_phi_91_89_ladder = _3091;
                frontier_phi_91_89_ladder_1 = _3090;
                frontier_phi_91_89_ladder_2 = _3089;
            }
            _3111 = frontier_phi_91_89_ladder_2;
            _3114 = frontier_phi_91_89_ladder_1;
            _3117 = frontier_phi_91_89_ladder;
        }
        float _1829 = mad(_3117, ColorCorrectTexture_m0[3u].x, mad(_3114, ColorCorrectTexture_m0[2u].x, _3111 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
        float _1832 = mad(_3117, ColorCorrectTexture_m0[3u].y, mad(_3114, ColorCorrectTexture_m0[2u].y, _3111 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
        float _1835 = mad(_3117, ColorCorrectTexture_m0[3u].z, mad(_3114, ColorCorrectTexture_m0[2u].z, _3111 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
        float frontier_phi_43_91_ladder;
        float frontier_phi_43_91_ladder_1;
        float frontier_phi_43_91_ladder_2;
        if (_1865)
        {
            frontier_phi_43_91_ladder = _1835 * _1864;
            frontier_phi_43_91_ladder_1 = _1832 * _1864;
            frontier_phi_43_91_ladder_2 = _1829 * _1864;
        }
        else
        {
            frontier_phi_43_91_ladder = _1835;
            frontier_phi_43_91_ladder_1 = _1832;
            frontier_phi_43_91_ladder_2 = _1829;
        }
        _1827 = frontier_phi_43_91_ladder_2;
        _1830 = frontier_phi_43_91_ladder_1;
        _1833 = frontier_phi_43_91_ladder;
    }
    float _2144;
    float _2146;
    float _2148;
    if ((_111 & 8u) == 0u)
    {
        _2144 = _1827;
        _2146 = _1830;
        _2148 = _1833;
    }
    else
    {
        _2144 = clamp(((ColorDeficientTable_m0[0u].x * _1827) + (ColorDeficientTable_m0[0u].y * _1830)) + (ColorDeficientTable_m0[0u].z * _1833), 0.0f, 1.0f);
        _2146 = clamp(((ColorDeficientTable_m0[1u].x * _1827) + (ColorDeficientTable_m0[1u].y * _1830)) + (ColorDeficientTable_m0[1u].z * _1833), 0.0f, 1.0f);
        _2148 = clamp(((ColorDeficientTable_m0[2u].x * _1827) + (ColorDeficientTable_m0[2u].y * _1830)) + (ColorDeficientTable_m0[2u].z * _1833), 0.0f, 1.0f);
    }
    float _2667;
    float _2669;
    float _2671;
    if ((_111 & 16u) == 0u)
    {
        _2667 = _2144;
        _2669 = _2146;
        _2671 = _2148;
    }
    else
    {
        float _2692 = SceneInfo_m0[23u].z * gl_FragCoord.x;
        float _2693 = SceneInfo_m0[23u].w * gl_FragCoord.y;
        float4 _2697 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_2692, _2693), 0.0f);
        float _2703 = _2697.x * ImagePlaneParam_m0[0u].x;
        float _2704 = _2697.y * ImagePlaneParam_m0[0u].y;
        float _2705 = _2697.z * ImagePlaneParam_m0[0u].z;
        float _2715 = (_2697.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_2692, _2693), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
        _2667 = ((((_2703 < 0.5f) ? ((_2144 * 2.0f) * _2703) : (1.0f - (((1.0f - _2144) * 2.0f) * (1.0f - _2703)))) - _2144) * _2715) + _2144;
        _2669 = ((((_2704 < 0.5f) ? ((_2146 * 2.0f) * _2704) : (1.0f - (((1.0f - _2146) * 2.0f) * (1.0f - _2704)))) - _2146) * _2715) + _2146;
        _2671 = ((((_2705 < 0.5f) ? ((_2148 * 2.0f) * _2705) : (1.0f - (((1.0f - _2148) * 2.0f) * (1.0f - _2705)))) - _2148) * _2715) + _2148;
    }
    SV_Target.x = _2667;
    SV_Target.y = _2669;
    SV_Target.z = _2671;
    SV_Target.w = 0.0f;

#if 1  // HDR Gamma boost

    SV_Target.rgb = AdjustGammaOnLuminance(SV_Target.rgb, injectedData.colorGradeGammaAdjust);

#endif
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