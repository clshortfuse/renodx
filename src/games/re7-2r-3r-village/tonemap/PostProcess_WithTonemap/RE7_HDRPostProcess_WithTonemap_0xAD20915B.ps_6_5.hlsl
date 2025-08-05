#include "../../common.hlsli"

cbuffer SceneInfoUBO : register(b0, space0) {
  float4 SceneInfo_m0[33] : packoffset(c0);
};

// cbuffer TonemapUBO : register(b1, space0)
// {
//     float4 Tonemap_m0[3] : packoffset(c0);
// };

cbuffer TonemapUBO : register(b1, space0) {
  // TonemapParam_m0[0u]
  float exposureAdjustment;  // TonemapParam_m0[0u].x
  float tonemapRange;        // TonemapParam_m0[0u].y
  float sharpness;           // TonemapParam_m0[0u].z
  float preTonemapRange;     // TonemapParam_m0[0u].w

  // TonemapParam_m0[1u]
  int useAutoExposure;  // TonemapParam_m0[1u].x
  float echoBlend;      // TonemapParam_m0[1u].y
  float AABlend;        // TonemapParam_m0[1u].z
  float AASubPixel;     // TonemapParam_m0[1u].w

  // TonemapParam_m0[2u]
  float ResponsiveAARate;  // TonemapParam_m0[2u].x
};

// cbuffer Tonemap
// {
//
//   struct Tonemap
//   {
//
//       float exposureAdjustment;                     ; Offset:    0
//       float tonemapRange;                           ; Offset:    4
//       float sharpness;                              ; Offset:    8
//       float preTonemapRange;                        ; Offset:   12
//       int useAutoExposure;                          ; Offset:   16
//       float echoBlend;                              ; Offset:   20
//       float AABlend;                                ; Offset:   24
//       float AASubPixel;                             ; Offset:   28
//       float ResponsiveAARate;                       ; Offset:   32
//
//   } Tonemap;                                        ; Offset:    0 Size:    36
//
// }

cbuffer CameraKerareUBO : register(b2, space0) {
  float4 CameraKerare_m0[1] : packoffset(c0);
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

Texture2D<float4> RE_POSTPROCESS_Color : register(t0, space0);
Buffer<uint4> ComputeResultSRV : register(t1, space0);
Texture3D<float4> tTextureMap0 : register(t2, space0);
Texture3D<float4> tTextureMap1 : register(t3, space0);
Texture3D<float4> tTextureMap2 : register(t4, space0);
Texture2D<float4> ImagePlameBase : register(t5, space0);
Texture2D<float4> ImagePlameAlpha : register(t6, space0);
SamplerState BilinearClamp : register(s5, space32);
SamplerState BilinearBorder : register(s6, space32);
SamplerState TrilinearClamp : register(s9, space32);

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
  float4 Tonemap_m0[3u];
  Tonemap_m0[0u] = float4(exposureAdjustment, tonemapRange, sharpness, preTonemapRange);
  Tonemap_m0[1u] = float4(useAutoExposure, echoBlend, AABlend, AASubPixel);
  Tonemap_m0[2u] = float4(ResponsiveAARate, 0.0, 0.0, 0.0);

#if 1
  Tonemap_m0[0u].y = 0.0;
#endif
  Tonemap_m0[1u].x = int(Tonemap_m0[1u].x);

  // declare lut config for use with lut black correction
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      TrilinearClamp,
      CUSTOM_LUT_STRENGTH,  // strength
      CUSTOM_LUT_SCALING,  // scaling
      renodx::lut::config::type::SRGB,
      renodx::lut::config::type::LINEAR,
      ColorCorrectTexture_m0[0u].x);
  lut_config.recolor = 0.f;
  float3 sdrColor;
  float3 untonemapped;
  float3 hdrColor;

  uint4 _111 = asuint(CBControl_m0[0u]);
  uint _112 = _111.x;
  bool _115 = (_112 & 1u) != 0u;
  uint4 _118 = asuint(LensDistortionParam_m0[0u]);
  uint _119 = _118.w;
  bool _121 = _115 && (_119 == 0u);
  bool _123 = _115 && (_119 == 1u);
  float _127 = Kerare.x / Kerare.w;
  float _128 = Kerare.y / Kerare.w;
  float _129 = Kerare.z / Kerare.w;
  float _137 = abs(rsqrt(dot(float3(_127, _128, _129), float3(_127, _128, _129))) * _129);
  float _146 = _137 * _137;
  float _150 = clamp(((_146 * _146) * (1.0f - clamp((CameraKerare_m0[0u].x * _137) + CameraKerare_m0[0u].y, 0.0f, 1.0f))) + CameraKerare_m0[0u].z, 0.0f, 1.0f);
  float _151 = _150 * Exposure;
  float _291;
  float _295;
  float _299;
  float _303;
  float _304;
  float _305;
  float _306;
  float _307;
  float _308;
  if (_121) {
    float _167 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
    float _169 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
    float _170 = dot(float2(_167, _169), float2(_167, _169));
    float _176 = ((_170 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
    float4 _185 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_176 * _167) + 0.5f, (_176 * _169) + 0.5f));
    float _190 = _185.x * _151;
    float _191 = _185.y * _151;
    float _192 = _185.z * _151;
    float _194 = max(max(_190, _191), _192);
    bool _198 = !(isnan(_194) || isinf(_194));
    float frontier_phi_8_1_ladder;
    float frontier_phi_8_1_ladder_1;
    float frontier_phi_8_1_ladder_2;
    float frontier_phi_8_1_ladder_3;
    float frontier_phi_8_1_ladder_4;
    float frontier_phi_8_1_ladder_5;
    float frontier_phi_8_1_ladder_6;
    float frontier_phi_8_1_ladder_7;
    float frontier_phi_8_1_ladder_8;
    if (_118.z == 0u) {
      float frontier_phi_8_1_ladder_3_ladder;
      float frontier_phi_8_1_ladder_3_ladder_1;
      float frontier_phi_8_1_ladder_3_ladder_2;
      float frontier_phi_8_1_ladder_3_ladder_3;
      float frontier_phi_8_1_ladder_3_ladder_4;
      float frontier_phi_8_1_ladder_3_ladder_5;
      float frontier_phi_8_1_ladder_3_ladder_6;
      float frontier_phi_8_1_ladder_3_ladder_7;
      float frontier_phi_8_1_ladder_3_ladder_8;
      if (_198) {
        float _287 = (Tonemap_m0[0u].y * _194) + 1.0f;
        frontier_phi_8_1_ladder_3_ladder = LensDistortionParam_m0[1u].x;
        frontier_phi_8_1_ladder_3_ladder_1 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_2 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_3 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_4 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_5 = LensDistortionParam_m0[0u].x;
        frontier_phi_8_1_ladder_3_ladder_6 = _192 / _287;
        frontier_phi_8_1_ladder_3_ladder_7 = _191 / _287;
        frontier_phi_8_1_ladder_3_ladder_8 = _190 / _287;
      } else {
        frontier_phi_8_1_ladder_3_ladder = LensDistortionParam_m0[1u].x;
        frontier_phi_8_1_ladder_3_ladder_1 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_2 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_3 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_4 = 0.0f;
        frontier_phi_8_1_ladder_3_ladder_5 = LensDistortionParam_m0[0u].x;
        frontier_phi_8_1_ladder_3_ladder_6 = 1.0f;
        frontier_phi_8_1_ladder_3_ladder_7 = 1.0f;
        frontier_phi_8_1_ladder_3_ladder_8 = 1.0f;
      }
      frontier_phi_8_1_ladder = frontier_phi_8_1_ladder_3_ladder;
      frontier_phi_8_1_ladder_1 = frontier_phi_8_1_ladder_3_ladder_1;
      frontier_phi_8_1_ladder_2 = frontier_phi_8_1_ladder_3_ladder_2;
      frontier_phi_8_1_ladder_3 = frontier_phi_8_1_ladder_3_ladder_3;
      frontier_phi_8_1_ladder_4 = frontier_phi_8_1_ladder_3_ladder_4;
      frontier_phi_8_1_ladder_5 = frontier_phi_8_1_ladder_3_ladder_5;
      frontier_phi_8_1_ladder_6 = frontier_phi_8_1_ladder_3_ladder_6;
      frontier_phi_8_1_ladder_7 = frontier_phi_8_1_ladder_3_ladder_7;
      frontier_phi_8_1_ladder_8 = frontier_phi_8_1_ladder_3_ladder_8;
    } else {
      float _199 = _170 + LensDistortionParam_m0[0u].y;
      float _201 = (_199 * LensDistortionParam_m0[0u].x) + 1.0f;
      float _202 = _167 * LensDistortionParam_m0[1u].x;
      float _204 = _169 * LensDistortionParam_m0[1u].x;
      float _210 = ((_199 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
      float _292;
      if (_198) {
        _292 = _190 / ((Tonemap_m0[0u].y * _194) + 1.0f);
      } else {
        _292 = 1.0f;
      }
      float4 _319 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_202 * _201) + 0.5f, (_204 * _201) + 0.5f));
      float _325 = _319.y * _151;
      float _328 = max(max(_319.x * _151, _325), _319.z * _151);
      float _296;
      if (!(isnan(_328) || isinf(_328))) {
        _296 = _325 / ((Tonemap_m0[0u].y * _328) + 1.0f);
      } else {
        _296 = 1.0f;
      }
      float4 _390 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_202 * _210) + 0.5f, (_204 * _210) + 0.5f));
      float _397 = _390.z * _151;
      float _399 = max(max(_390.x * _151, _390.y * _151), _397);
      float frontier_phi_8_1_ladder_16_ladder;
      float frontier_phi_8_1_ladder_16_ladder_1;
      float frontier_phi_8_1_ladder_16_ladder_2;
      float frontier_phi_8_1_ladder_16_ladder_3;
      float frontier_phi_8_1_ladder_16_ladder_4;
      float frontier_phi_8_1_ladder_16_ladder_5;
      float frontier_phi_8_1_ladder_16_ladder_6;
      float frontier_phi_8_1_ladder_16_ladder_7;
      float frontier_phi_8_1_ladder_16_ladder_8;
      if (!(isnan(_399) || isinf(_399))) {
        frontier_phi_8_1_ladder_16_ladder = LensDistortionParam_m0[1u].x;
        frontier_phi_8_1_ladder_16_ladder_1 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_2 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_3 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_4 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_5 = LensDistortionParam_m0[0u].x;
        frontier_phi_8_1_ladder_16_ladder_6 = _397 / ((Tonemap_m0[0u].y * _399) + 1.0f);
        frontier_phi_8_1_ladder_16_ladder_7 = _296;
        frontier_phi_8_1_ladder_16_ladder_8 = _292;
      } else {
        frontier_phi_8_1_ladder_16_ladder = LensDistortionParam_m0[1u].x;
        frontier_phi_8_1_ladder_16_ladder_1 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_2 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_3 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_4 = 0.0f;
        frontier_phi_8_1_ladder_16_ladder_5 = LensDistortionParam_m0[0u].x;
        frontier_phi_8_1_ladder_16_ladder_6 = 1.0f;
        frontier_phi_8_1_ladder_16_ladder_7 = _296;
        frontier_phi_8_1_ladder_16_ladder_8 = _292;
      }
      frontier_phi_8_1_ladder = frontier_phi_8_1_ladder_16_ladder;
      frontier_phi_8_1_ladder_1 = frontier_phi_8_1_ladder_16_ladder_1;
      frontier_phi_8_1_ladder_2 = frontier_phi_8_1_ladder_16_ladder_2;
      frontier_phi_8_1_ladder_3 = frontier_phi_8_1_ladder_16_ladder_3;
      frontier_phi_8_1_ladder_4 = frontier_phi_8_1_ladder_16_ladder_4;
      frontier_phi_8_1_ladder_5 = frontier_phi_8_1_ladder_16_ladder_5;
      frontier_phi_8_1_ladder_6 = frontier_phi_8_1_ladder_16_ladder_6;
      frontier_phi_8_1_ladder_7 = frontier_phi_8_1_ladder_16_ladder_7;
      frontier_phi_8_1_ladder_8 = frontier_phi_8_1_ladder_16_ladder_8;
    }
    _291 = frontier_phi_8_1_ladder_8;
    _295 = frontier_phi_8_1_ladder_7;
    _299 = frontier_phi_8_1_ladder_6;
    _303 = frontier_phi_8_1_ladder_5;
    _304 = frontier_phi_8_1_ladder_4;
    _305 = frontier_phi_8_1_ladder_3;
    _306 = frontier_phi_8_1_ladder_2;
    _307 = frontier_phi_8_1_ladder_1;
    _308 = frontier_phi_8_1_ladder;
  } else {
    float frontier_phi_8_2_ladder;
    float frontier_phi_8_2_ladder_1;
    float frontier_phi_8_2_ladder_2;
    float frontier_phi_8_2_ladder_3;
    float frontier_phi_8_2_ladder_4;
    float frontier_phi_8_2_ladder_5;
    float frontier_phi_8_2_ladder_6;
    float frontier_phi_8_2_ladder_7;
    float frontier_phi_8_2_ladder_8;
    if (_123) {
      float _230 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
      float _235 = sqrt((_230 * _230) + 1.0f);
      float _236 = 1.0f / _235;
      float _239 = (_235 * PaniniProjectionParam_m0[0u].z) * (_236 + PaniniProjectionParam_m0[0u].x);
      float _243 = PaniniProjectionParam_m0[0u].w * 0.5f;
      float4 _252 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_243 * _230) * _239) + 0.5f, (((_243 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_236 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _239) + 0.5f));
      float _257 = _252.x * _151;
      float _258 = _252.y * _151;
      float _259 = _252.z * _151;
      float _261 = max(max(_257, _258), _259);
      float frontier_phi_8_2_ladder_5_ladder;
      float frontier_phi_8_2_ladder_5_ladder_1;
      float frontier_phi_8_2_ladder_5_ladder_2;
      float frontier_phi_8_2_ladder_5_ladder_3;
      float frontier_phi_8_2_ladder_5_ladder_4;
      float frontier_phi_8_2_ladder_5_ladder_5;
      float frontier_phi_8_2_ladder_5_ladder_6;
      float frontier_phi_8_2_ladder_5_ladder_7;
      float frontier_phi_8_2_ladder_5_ladder_8;
      if (!(isnan(_261) || isinf(_261))) {
        float _337 = (Tonemap_m0[0u].y * _261) + 1.0f;
        frontier_phi_8_2_ladder_5_ladder = 1.0f;
        frontier_phi_8_2_ladder_5_ladder_1 = PaniniProjectionParam_m0[0u].w;
        frontier_phi_8_2_ladder_5_ladder_2 = PaniniProjectionParam_m0[0u].z;
        frontier_phi_8_2_ladder_5_ladder_3 = PaniniProjectionParam_m0[0u].y;
        frontier_phi_8_2_ladder_5_ladder_4 = PaniniProjectionParam_m0[0u].x;
        frontier_phi_8_2_ladder_5_ladder_5 = 0.0f;
        frontier_phi_8_2_ladder_5_ladder_6 = _259 / _337;
        frontier_phi_8_2_ladder_5_ladder_7 = _258 / _337;
        frontier_phi_8_2_ladder_5_ladder_8 = _257 / _337;
      } else {
        frontier_phi_8_2_ladder_5_ladder = 1.0f;
        frontier_phi_8_2_ladder_5_ladder_1 = PaniniProjectionParam_m0[0u].w;
        frontier_phi_8_2_ladder_5_ladder_2 = PaniniProjectionParam_m0[0u].z;
        frontier_phi_8_2_ladder_5_ladder_3 = PaniniProjectionParam_m0[0u].y;
        frontier_phi_8_2_ladder_5_ladder_4 = PaniniProjectionParam_m0[0u].x;
        frontier_phi_8_2_ladder_5_ladder_5 = 0.0f;
        frontier_phi_8_2_ladder_5_ladder_6 = 1.0f;
        frontier_phi_8_2_ladder_5_ladder_7 = 1.0f;
        frontier_phi_8_2_ladder_5_ladder_8 = 1.0f;
      }
      frontier_phi_8_2_ladder = frontier_phi_8_2_ladder_5_ladder;
      frontier_phi_8_2_ladder_1 = frontier_phi_8_2_ladder_5_ladder_1;
      frontier_phi_8_2_ladder_2 = frontier_phi_8_2_ladder_5_ladder_2;
      frontier_phi_8_2_ladder_3 = frontier_phi_8_2_ladder_5_ladder_3;
      frontier_phi_8_2_ladder_4 = frontier_phi_8_2_ladder_5_ladder_4;
      frontier_phi_8_2_ladder_5 = frontier_phi_8_2_ladder_5_ladder_5;
      frontier_phi_8_2_ladder_6 = frontier_phi_8_2_ladder_5_ladder_6;
      frontier_phi_8_2_ladder_7 = frontier_phi_8_2_ladder_5_ladder_7;
      frontier_phi_8_2_ladder_8 = frontier_phi_8_2_ladder_5_ladder_8;
    } else {
      float4 _268 = RE_POSTPROCESS_Color.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
      float _274 = _268.x * _151;
      float _275 = _268.y * _151;
      float _276 = _268.z * _151;
      float _278 = max(max(_274, _275), _276);
      float frontier_phi_8_2_ladder_6_ladder;
      float frontier_phi_8_2_ladder_6_ladder_1;
      float frontier_phi_8_2_ladder_6_ladder_2;
      float frontier_phi_8_2_ladder_6_ladder_3;
      float frontier_phi_8_2_ladder_6_ladder_4;
      float frontier_phi_8_2_ladder_6_ladder_5;
      float frontier_phi_8_2_ladder_6_ladder_6;
      float frontier_phi_8_2_ladder_6_ladder_7;
      float frontier_phi_8_2_ladder_6_ladder_8;
      if (!(isnan(_278) || isinf(_278))) {
        float _342 = (Tonemap_m0[0u].y * _278) + 1.0f;
        frontier_phi_8_2_ladder_6_ladder = 1.0f;
        frontier_phi_8_2_ladder_6_ladder_1 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_2 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_3 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_4 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_5 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_6 = _276 / _342;
        frontier_phi_8_2_ladder_6_ladder_7 = _275 / _342;
        frontier_phi_8_2_ladder_6_ladder_8 = _274 / _342;
      } else {
        frontier_phi_8_2_ladder_6_ladder = 1.0f;
        frontier_phi_8_2_ladder_6_ladder_1 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_2 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_3 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_4 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_5 = 0.0f;
        frontier_phi_8_2_ladder_6_ladder_6 = 1.0f;
        frontier_phi_8_2_ladder_6_ladder_7 = 1.0f;
        frontier_phi_8_2_ladder_6_ladder_8 = 1.0f;
      }
      frontier_phi_8_2_ladder = frontier_phi_8_2_ladder_6_ladder;
      frontier_phi_8_2_ladder_1 = frontier_phi_8_2_ladder_6_ladder_1;
      frontier_phi_8_2_ladder_2 = frontier_phi_8_2_ladder_6_ladder_2;
      frontier_phi_8_2_ladder_3 = frontier_phi_8_2_ladder_6_ladder_3;
      frontier_phi_8_2_ladder_4 = frontier_phi_8_2_ladder_6_ladder_4;
      frontier_phi_8_2_ladder_5 = frontier_phi_8_2_ladder_6_ladder_5;
      frontier_phi_8_2_ladder_6 = frontier_phi_8_2_ladder_6_ladder_6;
      frontier_phi_8_2_ladder_7 = frontier_phi_8_2_ladder_6_ladder_7;
      frontier_phi_8_2_ladder_8 = frontier_phi_8_2_ladder_6_ladder_8;
    }
    _291 = frontier_phi_8_2_ladder_8;
    _295 = frontier_phi_8_2_ladder_7;
    _299 = frontier_phi_8_2_ladder_6;
    _303 = frontier_phi_8_2_ladder_5;
    _304 = frontier_phi_8_2_ladder_4;
    _305 = frontier_phi_8_2_ladder_3;
    _306 = frontier_phi_8_2_ladder_2;
    _307 = frontier_phi_8_2_ladder_1;
    _308 = frontier_phi_8_2_ladder;
  }
  float _343;
  float _345;
  float _347;
  if ((_112 & 32u) == 0u) {
    _343 = _291;
    _345 = _295;
    _347 = _299;
  } else {
    uint4 _370 = asuint(RadialBlurRenderParam_m0[3u]);
    uint _371 = _370.x;
    float _374 = float((_371 & 2u) != 0u);
    float _381 = ((1.0f - _374) + (asfloat(ComputeResultSRV.Load(0u).x) * _374)) * RadialBlurRenderParam_m0[0u].w;
    float frontier_phi_13_14_ladder;
    float frontier_phi_13_14_ladder_1;
    float frontier_phi_13_14_ladder_2;
    if (_381 == 0.0f) {
      frontier_phi_13_14_ladder = _299;
      frontier_phi_13_14_ladder_1 = _295;
      frontier_phi_13_14_ladder_2 = _291;
    } else {
      float _452 = SceneInfo_m0[23u].z * gl_FragCoord.x;
      float _453 = SceneInfo_m0[23u].w * gl_FragCoord.y;
      float _455 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _452;
      float _457 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _453;
      float _460 = (_455 < 0.0f) ? (1.0f - _452) : _452;
      float _463 = (_457 < 0.0f) ? (1.0f - _453) : _453;
      float _470 = rsqrt(dot(float2(_455, _457), float2(_455, _457))) * RadialBlurRenderParam_m0[2u].w;
      uint _477 = uint(abs(_470 * _457)) + uint(abs(_470 * _455));
      uint _483 = ((_477 ^ 61u) ^ (_477 >> 16u)) * 9u;
      uint _487 = ((_483 >> 4u) ^ _483) * 668265261u;
      float _495 = ((_371 & 1u) != 0u) ? (float((_487 >> 15u) ^ _487) * 2.3283064365386962890625e-10f) : 1.0f;
      float _501 = 1.0f / max(1.0f, sqrt((_455 * _455) + (_457 * _457)));
      float _502 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
      float _512 = ((((_502 * _460) * _495) * _501) + 1.0f) * _455;
      float _513 = ((((_502 * _463) * _495) * _501) + 1.0f) * _457;
      float _514 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
      float _524 = ((((_514 * _460) * _495) * _501) + 1.0f) * _455;
      float _525 = ((((_514 * _463) * _495) * _501) + 1.0f) * _457;
      float _526 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
      float _536 = ((((_526 * _460) * _495) * _501) + 1.0f) * _455;
      float _537 = ((((_526 * _463) * _495) * _501) + 1.0f) * _457;
      float _538 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
      float _548 = ((((_538 * _460) * _495) * _501) + 1.0f) * _455;
      float _549 = ((((_538 * _463) * _495) * _501) + 1.0f) * _457;
      float _550 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
      float _560 = ((((_550 * _460) * _495) * _501) + 1.0f) * _455;
      float _561 = ((((_550 * _463) * _495) * _501) + 1.0f) * _457;
      float _562 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
      float _572 = ((((_562 * _460) * _495) * _501) + 1.0f) * _455;
      float _573 = ((((_562 * _463) * _495) * _501) + 1.0f) * _457;
      float _574 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
      float _584 = ((((_574 * _460) * _495) * _501) + 1.0f) * _455;
      float _585 = ((((_574 * _463) * _495) * _501) + 1.0f) * _457;
      float _586 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
      float _596 = ((((_586 * _460) * _495) * _501) + 1.0f) * _455;
      float _597 = ((((_586 * _463) * _495) * _501) + 1.0f) * _457;
      float _598 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
      float _608 = ((((_598 * _460) * _495) * _501) + 1.0f) * _455;
      float _609 = ((((_598 * _463) * _495) * _501) + 1.0f) * _457;
      float _610 = (_150 * Exposure) * 0.100000001490116119384765625f;
      float _612 = _610 * RadialBlurRenderParam_m0[0u].x;
      float _613 = _610 * RadialBlurRenderParam_m0[0u].y;
      float _614 = _610 * RadialBlurRenderParam_m0[0u].z;
      float _1451;
      float _1454;
      float _1457;
      if (_121) {
        float _679 = _512 + RadialBlurRenderParam_m0[1u].x;
        float _680 = _513 + RadialBlurRenderParam_m0[1u].y;
        float _686 = ((dot(float2(_679, _680), float2(_679, _680)) * _303) + 1.0f) * _308;
        float4 _692 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_686 * _679) + 0.5f, (_686 * _680) + 0.5f), 0.0f);
        float _697 = _524 + RadialBlurRenderParam_m0[1u].x;
        float _698 = _525 + RadialBlurRenderParam_m0[1u].y;
        float _703 = (dot(float2(_697, _698), float2(_697, _698)) * _303) + 1.0f;
        float4 _710 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_697 * _308) * _703) + 0.5f, ((_698 * _308) * _703) + 0.5f), 0.0f);
        float _718 = _536 + RadialBlurRenderParam_m0[1u].x;
        float _719 = _537 + RadialBlurRenderParam_m0[1u].y;
        float _724 = (dot(float2(_718, _719), float2(_718, _719)) * _303) + 1.0f;
        float4 _731 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_718 * _308) * _724) + 0.5f, ((_719 * _308) * _724) + 0.5f), 0.0f);
        float _739 = _548 + RadialBlurRenderParam_m0[1u].x;
        float _740 = _549 + RadialBlurRenderParam_m0[1u].y;
        float _745 = (dot(float2(_739, _740), float2(_739, _740)) * _303) + 1.0f;
        float4 _752 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_739 * _308) * _745) + 0.5f, ((_740 * _308) * _745) + 0.5f), 0.0f);
        float _760 = _560 + RadialBlurRenderParam_m0[1u].x;
        float _761 = _561 + RadialBlurRenderParam_m0[1u].y;
        float _766 = (dot(float2(_760, _761), float2(_760, _761)) * _303) + 1.0f;
        float4 _773 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_760 * _308) * _766) + 0.5f, ((_761 * _308) * _766) + 0.5f), 0.0f);
        float _781 = _572 + RadialBlurRenderParam_m0[1u].x;
        float _782 = _573 + RadialBlurRenderParam_m0[1u].y;
        float _787 = (dot(float2(_781, _782), float2(_781, _782)) * _303) + 1.0f;
        float4 _794 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_781 * _308) * _787) + 0.5f, ((_782 * _308) * _787) + 0.5f), 0.0f);
        float _802 = _584 + RadialBlurRenderParam_m0[1u].x;
        float _803 = _585 + RadialBlurRenderParam_m0[1u].y;
        float _808 = (dot(float2(_802, _803), float2(_802, _803)) * _303) + 1.0f;
        float4 _815 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_802 * _308) * _808) + 0.5f, ((_803 * _308) * _808) + 0.5f), 0.0f);
        float _823 = _596 + RadialBlurRenderParam_m0[1u].x;
        float _824 = _597 + RadialBlurRenderParam_m0[1u].y;
        float _829 = (dot(float2(_823, _824), float2(_823, _824)) * _303) + 1.0f;
        float4 _836 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_823 * _308) * _829) + 0.5f, ((_824 * _308) * _829) + 0.5f), 0.0f);
        float _844 = _608 + RadialBlurRenderParam_m0[1u].x;
        float _845 = _609 + RadialBlurRenderParam_m0[1u].y;
        float _850 = (dot(float2(_844, _845), float2(_844, _845)) * _303) + 1.0f;
        float4 _857 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_844 * _308) * _850) + 0.5f, ((_845 * _308) * _850) + 0.5f), 0.0f);
        float _865 = _612 * ((((((((_710.x + _692.x) + _731.x) + _752.x) + _773.x) + _794.x) + _815.x) + _836.x) + _857.x);
        float _866 = _613 * ((((((((_710.y + _692.y) + _731.y) + _752.y) + _773.y) + _794.y) + _815.y) + _836.y) + _857.y);
        float _867 = _614 * ((((((((_710.z + _692.z) + _731.z) + _752.z) + _773.z) + _794.z) + _815.z) + _836.z) + _857.z);
        float _869 = max(max(_865, _866), _867);
        float _963;
        float _964;
        float _965;
        if (!(isnan(_869) || isinf(_869))) {
          float _959 = (Tonemap_m0[0u].y * _869) + 1.0f;
          _963 = _865 / _959;
          _964 = _866 / _959;
          _965 = _867 / _959;
        } else {
          _963 = 1.0f;
          _964 = 1.0f;
          _965 = 1.0f;
        }
        _1451 = _963 + ((_291 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
        _1454 = _964 + ((_295 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
        _1457 = _965 + ((_299 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
      } else {
        float _874 = RadialBlurRenderParam_m0[1u].x + 0.5f;
        float _875 = _874 + _512;
        float _876 = RadialBlurRenderParam_m0[1u].y + 0.5f;
        float _877 = _876 + _513;
        float _878 = _874 + _524;
        float _879 = _876 + _525;
        float _880 = _874 + _536;
        float _881 = _876 + _537;
        float _882 = _874 + _548;
        float _883 = _876 + _549;
        float _884 = _874 + _560;
        float _885 = _876 + _561;
        float _886 = _874 + _572;
        float _887 = _876 + _573;
        float _888 = _874 + _584;
        float _889 = _876 + _585;
        float _890 = _874 + _596;
        float _891 = _876 + _597;
        float _892 = _874 + _608;
        float _893 = _876 + _609;
        float frontier_phi_43_26_ladder;
        float frontier_phi_43_26_ladder_1;
        float frontier_phi_43_26_ladder_2;
        if (_123) {
          float _977 = (_875 * 2.0f) + (-1.0f);
          float _981 = sqrt((_977 * _977) + 1.0f);
          float _982 = 1.0f / _981;
          float _985 = (_981 * _306) * (_982 + _304);
          float _989 = _307 * 0.5f;
          float4 _998 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _985) * _977) + 0.5f, (((_989 * (((_982 + (-1.0f)) * _305) + 1.0f)) * _985) * ((_877 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _1005 = (_878 * 2.0f) + (-1.0f);
          float _1009 = sqrt((_1005 * _1005) + 1.0f);
          float _1010 = 1.0f / _1009;
          float _1013 = (_1009 * _306) * (_1010 + _304);
          float4 _1024 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1005) * _1013) + 0.5f, (((_989 * ((_879 * 2.0f) + (-1.0f))) * (((_1010 + (-1.0f)) * _305) + 1.0f)) * _1013) + 0.5f), 0.0f);
          float _1034 = (_880 * 2.0f) + (-1.0f);
          float _1038 = sqrt((_1034 * _1034) + 1.0f);
          float _1039 = 1.0f / _1038;
          float _1042 = (_1038 * _306) * (_1039 + _304);
          float4 _1053 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1034) * _1042) + 0.5f, (((_989 * ((_881 * 2.0f) + (-1.0f))) * (((_1039 + (-1.0f)) * _305) + 1.0f)) * _1042) + 0.5f), 0.0f);
          float _1063 = (_882 * 2.0f) + (-1.0f);
          float _1067 = sqrt((_1063 * _1063) + 1.0f);
          float _1068 = 1.0f / _1067;
          float _1071 = (_1067 * _306) * (_1068 + _304);
          float4 _1082 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1063) * _1071) + 0.5f, (((_989 * ((_883 * 2.0f) + (-1.0f))) * (((_1068 + (-1.0f)) * _305) + 1.0f)) * _1071) + 0.5f), 0.0f);
          float _1092 = (_884 * 2.0f) + (-1.0f);
          float _1096 = sqrt((_1092 * _1092) + 1.0f);
          float _1097 = 1.0f / _1096;
          float _1100 = (_1096 * _306) * (_1097 + _304);
          float4 _1111 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1092) * _1100) + 0.5f, (((_989 * ((_885 * 2.0f) + (-1.0f))) * (((_1097 + (-1.0f)) * _305) + 1.0f)) * _1100) + 0.5f), 0.0f);
          float _1121 = (_886 * 2.0f) + (-1.0f);
          float _1125 = sqrt((_1121 * _1121) + 1.0f);
          float _1126 = 1.0f / _1125;
          float _1129 = (_1125 * _306) * (_1126 + _304);
          float4 _1140 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1121) * _1129) + 0.5f, (((_989 * ((_887 * 2.0f) + (-1.0f))) * (((_1126 + (-1.0f)) * _305) + 1.0f)) * _1129) + 0.5f), 0.0f);
          float _1150 = (_888 * 2.0f) + (-1.0f);
          float _1154 = sqrt((_1150 * _1150) + 1.0f);
          float _1155 = 1.0f / _1154;
          float _1158 = (_1154 * _306) * (_1155 + _304);
          float4 _1169 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1150) * _1158) + 0.5f, (((_989 * ((_889 * 2.0f) + (-1.0f))) * (((_1155 + (-1.0f)) * _305) + 1.0f)) * _1158) + 0.5f), 0.0f);
          float _1179 = (_890 * 2.0f) + (-1.0f);
          float _1183 = sqrt((_1179 * _1179) + 1.0f);
          float _1184 = 1.0f / _1183;
          float _1187 = (_1183 * _306) * (_1184 + _304);
          float4 _1198 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1179) * _1187) + 0.5f, (((_989 * ((_891 * 2.0f) + (-1.0f))) * (((_1184 + (-1.0f)) * _305) + 1.0f)) * _1187) + 0.5f), 0.0f);
          float _1208 = (_892 * 2.0f) + (-1.0f);
          float _1212 = sqrt((_1208 * _1208) + 1.0f);
          float _1213 = 1.0f / _1212;
          float _1216 = (_1212 * _306) * (_1213 + _304);
          float4 _1227 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_989 * _1208) * _1216) + 0.5f, (((_989 * ((_893 * 2.0f) + (-1.0f))) * (((_1213 + (-1.0f)) * _305) + 1.0f)) * _1216) + 0.5f), 0.0f);
          float _1235 = _612 * ((((((((_1024.x + _998.x) + _1053.x) + _1082.x) + _1111.x) + _1140.x) + _1169.x) + _1198.x) + _1227.x);
          float _1236 = _613 * ((((((((_1024.y + _998.y) + _1053.y) + _1082.y) + _1111.y) + _1140.y) + _1169.y) + _1198.y) + _1227.y);
          float _1237 = _614 * ((((((((_1024.z + _998.z) + _1053.z) + _1082.z) + _1111.z) + _1140.z) + _1169.z) + _1198.z) + _1227.z);
          float _1239 = max(max(_1235, _1236), _1237);
          float _1469;
          float _1470;
          float _1471;
          if (!(isnan(_1239) || isinf(_1239))) {
            float _1465 = (Tonemap_m0[0u].y * _1239) + 1.0f;
            _1469 = _1235 / _1465;
            _1470 = _1236 / _1465;
            _1471 = _1237 / _1465;
          } else {
            _1469 = 1.0f;
            _1470 = 1.0f;
            _1471 = 1.0f;
          }
          frontier_phi_43_26_ladder = _1471 + ((_299 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
          frontier_phi_43_26_ladder_1 = _1470 + ((_295 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
          frontier_phi_43_26_ladder_2 = _1469 + ((_291 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
        } else {
          float4 _1245 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_875, _877), 0.0f);
          float4 _1250 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_878, _879), 0.0f);
          float4 _1258 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_880, _881), 0.0f);
          float4 _1266 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_882, _883), 0.0f);
          float4 _1274 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_884, _885), 0.0f);
          float4 _1282 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_886, _887), 0.0f);
          float4 _1290 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_888, _889), 0.0f);
          float4 _1298 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_890, _891), 0.0f);
          float4 _1306 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_892, _893), 0.0f);
          float _1314 = _612 * ((((((((_1250.x + _1245.x) + _1258.x) + _1266.x) + _1274.x) + _1282.x) + _1290.x) + _1298.x) + _1306.x);
          float _1315 = _613 * ((((((((_1250.y + _1245.y) + _1258.y) + _1266.y) + _1274.y) + _1282.y) + _1290.y) + _1298.y) + _1306.y);
          float _1316 = _614 * ((((((((_1250.z + _1245.z) + _1258.z) + _1266.z) + _1274.z) + _1282.z) + _1290.z) + _1298.z) + _1306.z);
          float _1318 = max(max(_1314, _1315), _1316);
          float _1486;
          float _1487;
          float _1488;
          if (!(isnan(_1318) || isinf(_1318))) {
            float _1482 = (Tonemap_m0[0u].y * _1318) + 1.0f;
            _1486 = _1314 / _1482;
            _1487 = _1315 / _1482;
            _1488 = _1316 / _1482;
          } else {
            _1486 = 1.0f;
            _1487 = 1.0f;
            _1488 = 1.0f;
          }
          frontier_phi_43_26_ladder = _1488 + ((_299 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z);
          frontier_phi_43_26_ladder_1 = _1487 + ((_295 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y);
          frontier_phi_43_26_ladder_2 = _1486 + ((_291 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x);
        }
        _1451 = frontier_phi_43_26_ladder_2;
        _1454 = frontier_phi_43_26_ladder_1;
        _1457 = frontier_phi_43_26_ladder;
      }
      float _1520;
      float _1521;
      float _1522;
      if (RadialBlurRenderParam_m0[2u].x > 0.0f) {
        float _1503 = clamp((sqrt((_455 * _455) + (_457 * _457)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
        float _1510 = (((_1503 * _1503) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_1503 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
        _1520 = (_1510 * (_1451 - _291)) + _291;
        _1521 = (_1510 * (_1454 - _295)) + _295;
        _1522 = (_1510 * (_1457 - _299)) + _299;
      } else {
        _1520 = _1451;
        _1521 = _1454;
        _1522 = _1457;
      }
      frontier_phi_13_14_ladder = ((_1522 - _299) * _381) + _299;
      frontier_phi_13_14_ladder_1 = ((_1521 - _295) * _381) + _295;
      frontier_phi_13_14_ladder_2 = ((_1520 - _291) * _381) + _291;
    }
    _343 = frontier_phi_13_14_ladder_2;
    _345 = frontier_phi_13_14_ladder_1;
    _347 = frontier_phi_13_14_ladder;
  }
  float _404;
  float _406;
  float _408;
  if ((_112 & 2u) == 0u) {
    _404 = _343;
    _406 = _345;
    _408 = _347;
  } else {
    float _433 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
    float _435 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
    float _444 = frac(frac(dot(float2(_433, _435), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
    float _674;
    if (_444 < FilmGrainParam_m0[1u].x) {
      uint _662 = uint(_435 * _433) ^ 12345391u;
      uint _664 = _662 * 3635641u;
      _674 = float(((_664 >> 26u) | (_662 * 232681024u)) ^ _664) * 2.3283064365386962890625e-10f;
    } else {
      _674 = 0.0f;
    }
    float _677 = frac(_444 * 757.48468017578125f);
    float _951;
    if (_677 < FilmGrainParam_m0[1u].x) {
      uint _942 = asuint(_677) ^ 12345391u;
      uint _943 = _942 * 3635641u;
      _951 = (float(((_943 >> 26u) | (_942 * 232681024u)) ^ _943) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _951 = 0.0f;
    }
    float _953 = frac(_677 * 757.48468017578125f);
    float _1422;
    if (_953 < FilmGrainParam_m0[1u].x) {
      uint _1413 = asuint(_953) ^ 12345391u;
      uint _1414 = _1413 * 3635641u;
      _1422 = (float(((_1414 >> 26u) | (_1413 * 232681024u)) ^ _1414) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _1422 = 0.0f;
    }
    float _1423 = _674 * FilmGrainParam_m0[0u].x;
    float _1424 = _1422 * FilmGrainParam_m0[0u].y;
    float _1425 = _951 * FilmGrainParam_m0[0u].y;
    float _1444 = exp2(log2(1.0f - clamp(dot(float3(_343, _345, _347), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
    _404 = (_1444 * (mad(_1425, 1.401999950408935546875f, _1423) - _343)) + _343;
    _406 = (_1444 * (mad(_1425, -0.7139999866485595703125f, mad(_1424, -0.3440000116825103759765625f, _1423)) - _345)) + _345;
    _408 = (_1444 * (mad(_1424, 1.77199995517730712890625f, _1423) - _347)) + _347;
  }
  float _620;
  float _623;
  float _626;

#if 1  // use UpgradeToneMap() for LUT sampling
  untonemapped = float3(_404, _406, _408);
  hdrColor = untonemapped;

  sdrColor = LUTToneMap(untonemapped);
#endif
  if ((_112 & 4u) == 0u) {
    _620 = _404;
    _623 = _406;
    _626 = _408;
  } else {
    float _658 = max(max(_404, _406), _408);
    bool _659 = _658 > 1.0f;
    float _935;
    float _936;
    float _937;
#if 0
        if (_659)
        {
            _935 = _404 / _658;
            _936 = _406 / _658;
            _937 = _408 / _658;
        }
        else
        {
            _935 = _404;
            _936 = _406;
            _937 = _408;
        }
#else

    _935 = sdrColor.r;
    _936 = sdrColor.g;
    _937 = sdrColor.b;
#endif

#if 0
        float _938 = ColorCorrectTexture_m0[0u].w * 0.5f;
        float _1495;
        if (_935 > 0.003130800090730190277099609375f)
        {
            _1495 = (exp2(log2(_935) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1495 = _935 * 12.9200000762939453125f;
        }
        float _1535;
        if (_936 > 0.003130800090730190277099609375f)
        {
            _1535 = (exp2(log2(_936) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1535 = _936 * 12.9200000762939453125f;
        }
        float _1543;
        if (_937 > 0.003130800090730190277099609375f)
        {
            _1543 = (exp2(log2(_937) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1543 = _937 * 12.9200000762939453125f;
        }
        float _1544 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _1548 = (_1495 * _1544) + _938;
        float _1549 = (_1535 * _1544) + _938;
        float _1550 = (_1543 * _1544) + _938;
        float4 _1553 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1548, _1549, _1550), 0.0f);
#else
    float3 _1553 = LUTBlackCorrection(float3(_935, _936, _937), tTextureMap0, lut_config);

#endif
    float _1555 = _1553.x;
    float _1556 = _1553.y;
    float _1557 = _1553.z;
    float _1577;
    float _1580;
    float _1583;
    if (ColorCorrectTexture_m0[0u].y > 0.0f) {
#if 0
            float4 _1560 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1548, _1549, _1550), 0.0f);
#else
      float3 _1560 = LUTBlackCorrection(float3(_935, _936, _937), tTextureMap1, lut_config);

#endif
      float _1571 = ((_1560.x - _1555) * ColorCorrectTexture_m0[0u].y) + _1555;
      float _1572 = ((_1560.y - _1556) * ColorCorrectTexture_m0[0u].y) + _1556;
      float _1573 = ((_1560.z - _1557) * ColorCorrectTexture_m0[0u].y) + _1557;
      float frontier_phi_60_57_ladder;
      float frontier_phi_60_57_ladder_1;
      float frontier_phi_60_57_ladder_2;
      if (ColorCorrectTexture_m0[0u].z > 0.0f) {
#if 0
                float _1609;
                if (_1571 > 0.003130800090730190277099609375f)
                {
                    _1609 = (exp2(log2(_1571) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _1609 = _1571 * 12.9200000762939453125f;
                }
                float _1625;
                if (_1572 > 0.003130800090730190277099609375f)
                {
                    _1625 = (exp2(log2(_1572) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _1625 = _1572 * 12.9200000762939453125f;
                }
                float _1652;
                if (_1573 > 0.003130800090730190277099609375f)
                {
                    _1652 = (exp2(log2(_1573) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _1652 = _1573 * 12.9200000762939453125f;
                }
                float4 _1654 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1609, _1625, _1652), 0.0f);
#else
        float3 _1654 = LUTBlackCorrection(float3(_1571, _1572, _1573), tTextureMap2, lut_config);
#endif
        frontier_phi_60_57_ladder = ((_1654.z - _1573) * ColorCorrectTexture_m0[0u].z) + _1573;
        frontier_phi_60_57_ladder_1 = ((_1654.y - _1572) * ColorCorrectTexture_m0[0u].z) + _1572;
        frontier_phi_60_57_ladder_2 = ((_1654.x - _1571) * ColorCorrectTexture_m0[0u].z) + _1571;
      } else {
        frontier_phi_60_57_ladder = _1573;
        frontier_phi_60_57_ladder_1 = _1572;
        frontier_phi_60_57_ladder_2 = _1571;
      }
      _1577 = frontier_phi_60_57_ladder_2;
      _1580 = frontier_phi_60_57_ladder_1;
      _1583 = frontier_phi_60_57_ladder;
    } else {
#if 0
            float _1607;
            if (_1555 > 0.003130800090730190277099609375f)
            {
                _1607 = (exp2(log2(_1555) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _1607 = _1555 * 12.9200000762939453125f;
            }
            float _1623;
            if (_1556 > 0.003130800090730190277099609375f)
            {
                _1623 = (exp2(log2(_1556) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _1623 = _1556 * 12.9200000762939453125f;
            }
            float _1639;
            if (_1557 > 0.003130800090730190277099609375f)
            {
                _1639 = (exp2(log2(_1557) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _1639 = _1557 * 12.9200000762939453125f;
            }
            float4 _1641 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_1607, _1623, _1639), 0.0f);

#else
      float3 _1641 = LUTBlackCorrection(float3(_1555, _1556, _1557), tTextureMap2, lut_config);
#endif
      _1577 = ((_1641.x - _1555) * ColorCorrectTexture_m0[0u].z) + _1555;
      _1580 = ((_1641.y - _1556) * ColorCorrectTexture_m0[0u].z) + _1556;
      _1583 = ((_1641.z - _1557) * ColorCorrectTexture_m0[0u].z) + _1557;
    }
    float _622 = mad(_1583, ColorCorrectTexture_m0[3u].x, mad(_1580, ColorCorrectTexture_m0[2u].x, _1577 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
    float _625 = mad(_1583, ColorCorrectTexture_m0[3u].y, mad(_1580, ColorCorrectTexture_m0[2u].y, _1577 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
    float _628 = mad(_1583, ColorCorrectTexture_m0[3u].z, mad(_1580, ColorCorrectTexture_m0[2u].z, _1577 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
    float frontier_phi_21_60_ladder;
    float frontier_phi_21_60_ladder_1;
    float frontier_phi_21_60_ladder_2;
#if 0
        if (_659)
        {
                frontier_phi_21_60_ladder = _628 * _658;
                frontier_phi_21_60_ladder_1 = _625 * _658;
                frontier_phi_21_60_ladder_2 = _622 * _658;
        }
        else
        {
            frontier_phi_21_60_ladder = _628;
            frontier_phi_21_60_ladder_1 = _625;
            frontier_phi_21_60_ladder_2 = _622;
        }
        _620 = frontier_phi_21_60_ladder_2;
        _623 = frontier_phi_21_60_ladder_1;
        _626 = frontier_phi_21_60_ladder;

#else
    float3 postprocessColor = float3(_622, _625, _628);
    float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, (sdrColor), (postprocessColor), 1.f);
    // float3 upgradedColor = RestorePostProcess(hdrColor, (sdrColor), postprocessColor, 1.f);
    _620 = upgradedColor.r;
    _623 = upgradedColor.g;
    _626 = upgradedColor.b;
#endif
  }
  float _894;
  float _896;
  float _898;
  if ((_112 & 8u) == 0u) {
    _894 = _620;
    _896 = _623;
    _898 = _626;
  } else {
    _894 = clamp(((ColorDeficientTable_m0[0u].x * _620) + (ColorDeficientTable_m0[0u].y * _623)) + (ColorDeficientTable_m0[0u].z * _626), 0.0f, 1.0f);
    _896 = clamp(((ColorDeficientTable_m0[1u].x * _620) + (ColorDeficientTable_m0[1u].y * _623)) + (ColorDeficientTable_m0[1u].z * _626), 0.0f, 1.0f);
    _898 = clamp(((ColorDeficientTable_m0[2u].x * _620) + (ColorDeficientTable_m0[2u].y * _623)) + (ColorDeficientTable_m0[2u].z * _626), 0.0f, 1.0f);
  }
  float _1323;
  float _1325;
  float _1327;
  if ((_112 & 16u) == 0u) {
    _1323 = _894;
    _1325 = _896;
    _1327 = _898;
  } else {
    float _1348 = SceneInfo_m0[23u].z * gl_FragCoord.x;
    float _1349 = SceneInfo_m0[23u].w * gl_FragCoord.y;
    float4 _1351 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1348, _1349), 0.0f);

    float _1357 = _1351.x * ImagePlaneParam_m0[0u].x;
    float _1358 = _1351.y * ImagePlaneParam_m0[0u].y;
    float _1359 = _1351.z * ImagePlaneParam_m0[0u].z;
    float _1368 = (_1351.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1348, _1349), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
    _1323 = ((((_1357 < 0.5f) ? ((_894 * 2.0f) * _1357) : (1.0f - (((1.0f - _894) * 2.0f) * (1.0f - _1357)))) - _894) * _1368) + _894;
    _1325 = ((((_1358 < 0.5f) ? ((_896 * 2.0f) * _1358) : (1.0f - (((1.0f - _896) * 2.0f) * (1.0f - _1358)))) - _896) * _1368) + _896;
    _1327 = ((((_1359 < 0.5f) ? ((_898 * 2.0f) * _1359) : (1.0f - (((1.0f - _898) * 2.0f) * (1.0f - _1359)))) - _898) * _1368) + _898;
  }
  SV_Target.x = _1323;
  SV_Target.y = _1325;
  SV_Target.z = _1327;
  SV_Target.w = 0.0f;
#if 0
      SV_Target.rgb = AdjustGammaOnLuminance(SV_Target.rgb, 1.1f);
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
