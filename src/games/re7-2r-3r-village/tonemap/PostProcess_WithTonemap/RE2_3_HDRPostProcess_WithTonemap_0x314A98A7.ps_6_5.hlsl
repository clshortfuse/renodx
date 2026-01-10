#include "../../common.hlsli"

cbuffer SceneInfoUBO : register(b0, space0) {
  float4 SceneInfo_m0[33] : packoffset(c0);
};

cbuffer CameraKerareUBO : register(b1, space0) {
  float4 CameraKerare_m0[1] : packoffset(c0);
};

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
  // Map cbuffer variables to TonemapParam_m0 indices
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
  float _603;
  float _604;
  float _605;
  float _606;
  float _607;
  float _608;
  float _609;
  float _610;
  float _611;
  if (_121) {
    float _183 = (SceneInfo_m0[23u].z * gl_FragCoord.x) + (-0.5f);
    float _185 = (SceneInfo_m0[23u].w * gl_FragCoord.y) + (-0.5f);
    float _186 = dot(float2(_183, _185), float2(_183, _185));
    float _192 = ((_186 * LensDistortionParam_m0[0u].x) + 1.0f) * LensDistortionParam_m0[1u].x;
    float4 _201 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_192 * _183) + 0.5f, (_192 * _185) + 0.5f));
    float _204 = _201.x * _151;
    float _205 = TonemapParam_m0[2u].y * _204;
    float _214 = (_204 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_205 * _205) * (3.0f - (_205 * 2.0f))));
    float _216 = (_204 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
    float _221 = exp2(log2(_205) * TonemapParam_m0[0u].w);
    float _224 = ((TonemapParam_m0[0u].x * _204) + TonemapParam_m0[2u].z) * ((1.0f - _216) - _214);
    float _230 = (TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _204) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _216;
    float frontier_phi_7_1_ladder;
    float frontier_phi_7_1_ladder_1;
    float frontier_phi_7_1_ladder_2;
    float frontier_phi_7_1_ladder_3;
    float frontier_phi_7_1_ladder_4;
    float frontier_phi_7_1_ladder_5;
    float frontier_phi_7_1_ladder_6;
    float frontier_phi_7_1_ladder_7;
    float frontier_phi_7_1_ladder_8;
    if (_118.z == 0u) {
      float _233 = _201.y * _151;
      float _234 = _201.z * _151;
      float _235 = TonemapParam_m0[2u].y * _233;
      float _241 = TonemapParam_m0[2u].y * _234;
      float _248 = (_233 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_235 * _235) * (3.0f - (_235 * 2.0f))));
      float _250 = (_234 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_241 * _241) * (3.0f - (_241 * 2.0f))));
      float _253 = (_233 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _254 = (_234 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_1_ladder = LensDistortionParam_m0[1u].x;
      frontier_phi_7_1_ladder_1 = 0.0f;
      frontier_phi_7_1_ladder_2 = 0.0f;
      frontier_phi_7_1_ladder_3 = 0.0f;
      frontier_phi_7_1_ladder_4 = 0.0f;
      frontier_phi_7_1_ladder_5 = LensDistortionParam_m0[0u].x;
      frontier_phi_7_1_ladder_6 = ((((TonemapParam_m0[0u].x * _234) + TonemapParam_m0[2u].z) * ((1.0f - _254) - _250)) + ((exp2(log2(_241) * TonemapParam_m0[0u].w) * _250) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _234) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _254);
      frontier_phi_7_1_ladder_7 = ((((TonemapParam_m0[0u].x * _233) + TonemapParam_m0[2u].z) * ((1.0f - _253) - _248)) + ((exp2(log2(_235) * TonemapParam_m0[0u].w) * _248) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _233) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _253);
      frontier_phi_7_1_ladder_8 = (_224 + ((_221 * _214) * TonemapParam_m0[0u].y)) + _230;
    } else {
      float _295 = _186 + LensDistortionParam_m0[0u].y;
      float _297 = (_295 * LensDistortionParam_m0[0u].x) + 1.0f;
      float _298 = _183 * LensDistortionParam_m0[1u].x;
      float _300 = _185 * LensDistortionParam_m0[1u].x;
      float _306 = ((_295 + LensDistortionParam_m0[0u].y) * LensDistortionParam_m0[0u].x) + 1.0f;
      float _319 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_298 * _297) + 0.5f, (_300 * _297) + 0.5f)).y * _151;
      float _320 = TonemapParam_m0[2u].y * _319;
      float _327 = (_319 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_320 * _320) * (3.0f - (_320 * 2.0f))));
      float _329 = (_319 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _351 = RE_POSTPROCESS_Color.Sample(BilinearClamp, float2((_298 * _306) + 0.5f, (_300 * _306) + 0.5f)).z * _151;
      float _352 = TonemapParam_m0[2u].y * _351;
      float _359 = (_351 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_352 * _352) * (3.0f - (_352 * 2.0f))));
      float _361 = (_351 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_1_ladder = LensDistortionParam_m0[1u].x;
      frontier_phi_7_1_ladder_1 = 0.0f;
      frontier_phi_7_1_ladder_2 = 0.0f;
      frontier_phi_7_1_ladder_3 = 0.0f;
      frontier_phi_7_1_ladder_4 = 0.0f;
      frontier_phi_7_1_ladder_5 = LensDistortionParam_m0[0u].x;
      frontier_phi_7_1_ladder_6 = ((((TonemapParam_m0[0u].x * _351) + TonemapParam_m0[2u].z) * ((1.0f - _361) - _359)) + ((TonemapParam_m0[0u].y * exp2(log2(_352) * TonemapParam_m0[0u].w)) * _359)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _351) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _361);
      frontier_phi_7_1_ladder_7 = ((((TonemapParam_m0[0u].x * _319) + TonemapParam_m0[2u].z) * ((1.0f - _329) - _327)) + ((TonemapParam_m0[0u].y * exp2(log2(_320) * TonemapParam_m0[0u].w)) * _327)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _319) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _329);
      frontier_phi_7_1_ladder_8 = (_224 + ((TonemapParam_m0[0u].y * _221) * _214)) + _230;
    }
    _603 = frontier_phi_7_1_ladder_8;
    _604 = frontier_phi_7_1_ladder_7;
    _605 = frontier_phi_7_1_ladder_6;
    _606 = frontier_phi_7_1_ladder_5;
    _607 = frontier_phi_7_1_ladder_4;
    _608 = frontier_phi_7_1_ladder_3;
    _609 = frontier_phi_7_1_ladder_2;
    _610 = frontier_phi_7_1_ladder_1;
    _611 = frontier_phi_7_1_ladder;
  } else {
    float frontier_phi_7_2_ladder;
    float frontier_phi_7_2_ladder_1;
    float frontier_phi_7_2_ladder_2;
    float frontier_phi_7_2_ladder_3;
    float frontier_phi_7_2_ladder_4;
    float frontier_phi_7_2_ladder_5;
    float frontier_phi_7_2_ladder_6;
    float frontier_phi_7_2_ladder_7;
    float frontier_phi_7_2_ladder_8;
    if (_123) {
      float _394 = ((gl_FragCoord.x * 2.0f) * SceneInfo_m0[23u].z) + (-1.0f);
      float _399 = sqrt((_394 * _394) + 1.0f);
      float _400 = 1.0f / _399;
      float _403 = (_399 * PaniniProjectionParam_m0[0u].z) * (_400 + PaniniProjectionParam_m0[0u].x);
      float _407 = PaniniProjectionParam_m0[0u].w * 0.5f;
      float4 _416 = RE_POSTPROCESS_Color.Sample(BilinearBorder, float2(((_407 * _394) * _403) + 0.5f, (((_407 * (((gl_FragCoord.y * 2.0f) * SceneInfo_m0[23u].w) + (-1.0f))) * (((_400 + (-1.0f)) * PaniniProjectionParam_m0[0u].y) + 1.0f)) * _403) + 0.5f));
      float _421 = _416.x * _151;
      float _422 = _416.y * _151;
      float _423 = _416.z * _151;
      float _424 = TonemapParam_m0[2u].y * _421;
      float _430 = TonemapParam_m0[2u].y * _422;
      float _436 = TonemapParam_m0[2u].y * _423;
      float _443 = (_421 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_424 * _424) * (3.0f - (_424 * 2.0f))));
      float _445 = (_422 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_430 * _430) * (3.0f - (_430 * 2.0f))));
      float _447 = (_423 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_436 * _436) * (3.0f - (_436 * 2.0f))));
      float _451 = (_421 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _452 = (_422 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _453 = (_423 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_2_ladder = 1.0f;
      frontier_phi_7_2_ladder_1 = PaniniProjectionParam_m0[0u].w;
      frontier_phi_7_2_ladder_2 = PaniniProjectionParam_m0[0u].z;
      frontier_phi_7_2_ladder_3 = PaniniProjectionParam_m0[0u].y;
      frontier_phi_7_2_ladder_4 = PaniniProjectionParam_m0[0u].x;
      frontier_phi_7_2_ladder_5 = 0.0f;
      frontier_phi_7_2_ladder_6 = ((((TonemapParam_m0[0u].x * _423) + TonemapParam_m0[2u].z) * ((1.0f - _453) - _447)) + ((exp2(log2(_436) * TonemapParam_m0[0u].w) * _447) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _423) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _453);
      frontier_phi_7_2_ladder_7 = ((((TonemapParam_m0[0u].x * _422) + TonemapParam_m0[2u].z) * ((1.0f - _452) - _445)) + ((exp2(log2(_430) * TonemapParam_m0[0u].w) * _445) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _422) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _452);
      frontier_phi_7_2_ladder_8 = ((((TonemapParam_m0[0u].x * _421) + TonemapParam_m0[2u].z) * ((1.0f - _451) - _443)) + ((exp2(log2(_424) * TonemapParam_m0[0u].w) * _443) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _421) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _451);
    } else {
      float4 _510 = RE_POSTPROCESS_Color.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
      float _516 = _510.x * _151;
      float _517 = _510.y * _151;
      float _518 = _510.z * _151;
      float _519 = TonemapParam_m0[2u].y * _516;
      float _525 = TonemapParam_m0[2u].y * _517;
      float _531 = TonemapParam_m0[2u].y * _518;
      float _538 = (_516 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_519 * _519) * (3.0f - (_519 * 2.0f))));
      float _540 = (_517 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_525 * _525) * (3.0f - (_525 * 2.0f))));
      float _542 = (_518 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_531 * _531) * (3.0f - (_531 * 2.0f))));
      float _546 = (_516 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _547 = (_517 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      float _548 = (_518 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
      frontier_phi_7_2_ladder = 1.0f;
      frontier_phi_7_2_ladder_1 = 0.0f;
      frontier_phi_7_2_ladder_2 = 0.0f;
      frontier_phi_7_2_ladder_3 = 0.0f;
      frontier_phi_7_2_ladder_4 = 0.0f;
      frontier_phi_7_2_ladder_5 = 0.0f;
      frontier_phi_7_2_ladder_6 = ((((TonemapParam_m0[0u].x * _518) + TonemapParam_m0[2u].z) * ((1.0f - _548) - _542)) + ((exp2(log2(_531) * TonemapParam_m0[0u].w) * _542) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _518) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _548);
      frontier_phi_7_2_ladder_7 = ((((TonemapParam_m0[0u].x * _517) + TonemapParam_m0[2u].z) * ((1.0f - _547) - _540)) + ((exp2(log2(_525) * TonemapParam_m0[0u].w) * _540) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _517) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _547);
      frontier_phi_7_2_ladder_8 = ((((TonemapParam_m0[0u].x * _516) + TonemapParam_m0[2u].z) * ((1.0f - _546) - _538)) + ((exp2(log2(_519) * TonemapParam_m0[0u].w) * _538) * TonemapParam_m0[0u].y)) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _516) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _546);
    }
    _603 = frontier_phi_7_2_ladder_8;
    _604 = frontier_phi_7_2_ladder_7;
    _605 = frontier_phi_7_2_ladder_6;
    _606 = frontier_phi_7_2_ladder_5;
    _607 = frontier_phi_7_2_ladder_4;
    _608 = frontier_phi_7_2_ladder_3;
    _609 = frontier_phi_7_2_ladder_2;
    _610 = frontier_phi_7_2_ladder_1;
    _611 = frontier_phi_7_2_ladder;
  }
  float _615;
  float _617;
  float _619;
  if ((_112 & 32u) == 0u) {
    _615 = _603;
    _617 = _604;
    _619 = _605;
  } else {
    uint4 _642 = asuint(RadialBlurRenderParam_m0[3u]);
    uint _643 = _642.x;
    float _646 = float((_643 & 2u) != 0u);
    float _653 = ((1.0f - _646) + (asfloat(ComputeResultSRV.Load(0u).x) * _646)) * RadialBlurRenderParam_m0[0u].w;
    float frontier_phi_8_9_ladder;
    float frontier_phi_8_9_ladder_1;
    float frontier_phi_8_9_ladder_2;
    if (_653 == 0.0f) {
      frontier_phi_8_9_ladder = _605;
      frontier_phi_8_9_ladder_1 = _604;
      frontier_phi_8_9_ladder_2 = _603;
    } else {
      float _703 = SceneInfo_m0[23u].z * gl_FragCoord.x;
      float _704 = SceneInfo_m0[23u].w * gl_FragCoord.y;
      float _706 = ((-0.5f) - RadialBlurRenderParam_m0[1u].x) + _703;
      float _708 = ((-0.5f) - RadialBlurRenderParam_m0[1u].y) + _704;
      float _711 = (_706 < 0.0f) ? (1.0f - _703) : _703;
      float _714 = (_708 < 0.0f) ? (1.0f - _704) : _704;
      float _721 = rsqrt(dot(float2(_706, _708), float2(_706, _708))) * RadialBlurRenderParam_m0[2u].w;
      uint _728 = uint(abs(_721 * _708)) + uint(abs(_721 * _706));
      uint _734 = ((_728 ^ 61u) ^ (_728 >> 16u)) * 9u;
      uint _738 = ((_734 >> 4u) ^ _734) * 668265261u;
      float _746 = ((_643 & 1u) != 0u) ? (float((_738 >> 15u) ^ _738) * 2.3283064365386962890625e-10f) : 1.0f;
      float _752 = 1.0f / max(1.0f, sqrt((_706 * _706) + (_708 * _708)));
      float _753 = RadialBlurRenderParam_m0[2u].z * (-0.0011111111380159854888916015625f);
      float _763 = ((((_753 * _711) * _746) * _752) + 1.0f) * _706;
      float _764 = ((((_753 * _714) * _746) * _752) + 1.0f) * _708;
      float _765 = RadialBlurRenderParam_m0[2u].z * (-0.002222222276031970977783203125f);
      float _775 = ((((_765 * _711) * _746) * _752) + 1.0f) * _706;
      float _776 = ((((_765 * _714) * _746) * _752) + 1.0f) * _708;
      float _777 = RadialBlurRenderParam_m0[2u].z * (-0.0033333334140479564666748046875f);
      float _787 = ((((_777 * _711) * _746) * _752) + 1.0f) * _706;
      float _788 = ((((_777 * _714) * _746) * _752) + 1.0f) * _708;
      float _789 = RadialBlurRenderParam_m0[2u].z * (-0.00444444455206394195556640625f);
      float _799 = ((((_789 * _711) * _746) * _752) + 1.0f) * _706;
      float _800 = ((((_789 * _714) * _746) * _752) + 1.0f) * _708;
      float _801 = RadialBlurRenderParam_m0[2u].z * (-0.0055555556900799274444580078125f);
      float _811 = ((((_801 * _711) * _746) * _752) + 1.0f) * _706;
      float _812 = ((((_801 * _714) * _746) * _752) + 1.0f) * _708;
      float _813 = RadialBlurRenderParam_m0[2u].z * (-0.006666666828095912933349609375f);
      float _823 = ((((_813 * _711) * _746) * _752) + 1.0f) * _706;
      float _824 = ((((_813 * _714) * _746) * _752) + 1.0f) * _708;
      float _825 = RadialBlurRenderParam_m0[2u].z * (-0.0077777779661118984222412109375f);
      float _835 = ((((_825 * _711) * _746) * _752) + 1.0f) * _706;
      float _836 = ((((_825 * _714) * _746) * _752) + 1.0f) * _708;
      float _837 = RadialBlurRenderParam_m0[2u].z * (-0.0088888891041278839111328125f);
      float _847 = ((((_837 * _711) * _746) * _752) + 1.0f) * _706;
      float _848 = ((((_837 * _714) * _746) * _752) + 1.0f) * _708;
      float _849 = RadialBlurRenderParam_m0[2u].z * (-0.00999999977648258209228515625f);
      float _859 = ((((_849 * _711) * _746) * _752) + 1.0f) * _706;
      float _860 = ((((_849 * _714) * _746) * _752) + 1.0f) * _708;
      float _861 = (_150 * Exposure) * 0.100000001490116119384765625f;
      float _863 = _861 * RadialBlurRenderParam_m0[0u].x;
      float _864 = _861 * RadialBlurRenderParam_m0[0u].y;
      float _865 = _861 * RadialBlurRenderParam_m0[0u].z;
      float _883 = (_603 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].x;
      float _885 = (_604 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].y;
      float _887 = (_605 * 0.100000001490116119384765625f) * RadialBlurRenderParam_m0[0u].z;
      float _1304;
      float _1307;
      float _1310;
      if (_121) {
        float _947 = _763 + RadialBlurRenderParam_m0[1u].x;
        float _948 = _764 + RadialBlurRenderParam_m0[1u].y;
        float _954 = ((dot(float2(_947, _948), float2(_947, _948)) * _606) + 1.0f) * _611;
        float4 _960 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2((_954 * _947) + 0.5f, (_954 * _948) + 0.5f), 0.0f);
        float _965 = _775 + RadialBlurRenderParam_m0[1u].x;
        float _966 = _776 + RadialBlurRenderParam_m0[1u].y;
        float _971 = (dot(float2(_965, _966), float2(_965, _966)) * _606) + 1.0f;
        float4 _978 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_965 * _611) * _971) + 0.5f, ((_966 * _611) * _971) + 0.5f), 0.0f);
        float _986 = _787 + RadialBlurRenderParam_m0[1u].x;
        float _987 = _788 + RadialBlurRenderParam_m0[1u].y;
        float _992 = (dot(float2(_986, _987), float2(_986, _987)) * _606) + 1.0f;
        float4 _999 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_986 * _611) * _992) + 0.5f, ((_987 * _611) * _992) + 0.5f), 0.0f);
        float _1007 = _799 + RadialBlurRenderParam_m0[1u].x;
        float _1008 = _800 + RadialBlurRenderParam_m0[1u].y;
        float _1013 = (dot(float2(_1007, _1008), float2(_1007, _1008)) * _606) + 1.0f;
        float4 _1020 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1007 * _611) * _1013) + 0.5f, ((_1008 * _611) * _1013) + 0.5f), 0.0f);
        float _1028 = _811 + RadialBlurRenderParam_m0[1u].x;
        float _1029 = _812 + RadialBlurRenderParam_m0[1u].y;
        float _1034 = (dot(float2(_1028, _1029), float2(_1028, _1029)) * _606) + 1.0f;
        float4 _1041 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1028 * _611) * _1034) + 0.5f, ((_1029 * _611) * _1034) + 0.5f), 0.0f);
        float _1049 = _823 + RadialBlurRenderParam_m0[1u].x;
        float _1050 = _824 + RadialBlurRenderParam_m0[1u].y;
        float _1055 = (dot(float2(_1049, _1050), float2(_1049, _1050)) * _606) + 1.0f;
        float4 _1062 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1049 * _611) * _1055) + 0.5f, ((_1050 * _611) * _1055) + 0.5f), 0.0f);
        float _1070 = _835 + RadialBlurRenderParam_m0[1u].x;
        float _1071 = _836 + RadialBlurRenderParam_m0[1u].y;
        float _1076 = (dot(float2(_1070, _1071), float2(_1070, _1071)) * _606) + 1.0f;
        float4 _1083 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1070 * _611) * _1076) + 0.5f, ((_1071 * _611) * _1076) + 0.5f), 0.0f);
        float _1091 = _847 + RadialBlurRenderParam_m0[1u].x;
        float _1092 = _848 + RadialBlurRenderParam_m0[1u].y;
        float _1097 = (dot(float2(_1091, _1092), float2(_1091, _1092)) * _606) + 1.0f;
        float4 _1104 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1091 * _611) * _1097) + 0.5f, ((_1092 * _611) * _1097) + 0.5f), 0.0f);
        float _1112 = _859 + RadialBlurRenderParam_m0[1u].x;
        float _1113 = _860 + RadialBlurRenderParam_m0[1u].y;
        float _1118 = (dot(float2(_1112, _1113), float2(_1112, _1113)) * _606) + 1.0f;
        float4 _1125 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(((_1112 * _611) * _1118) + 0.5f, ((_1113 * _611) * _1118) + 0.5f), 0.0f);
        float _1133 = _863 * ((((((((_978.x + _960.x) + _999.x) + _1020.x) + _1041.x) + _1062.x) + _1083.x) + _1104.x) + _1125.x);
        float _1134 = _864 * ((((((((_978.y + _960.y) + _999.y) + _1020.y) + _1041.y) + _1062.y) + _1083.y) + _1104.y) + _1125.y);
        float _1135 = _865 * ((((((((_978.z + _960.z) + _999.z) + _1020.z) + _1041.z) + _1062.z) + _1083.z) + _1104.z) + _1125.z);
        float _1136 = _1133 * TonemapParam_m0[2u].y;
        float _1142 = _1134 * TonemapParam_m0[2u].y;
        float _1148 = _1135 * TonemapParam_m0[2u].y;
        float _1155 = (_1133 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1136 * _1136) * (3.0f - (_1136 * 2.0f))));
        float _1157 = (_1134 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1142 * _1142) * (3.0f - (_1142 * 2.0f))));
        float _1159 = (_1135 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1148 * _1148) * (3.0f - (_1148 * 2.0f))));
        float _1163 = (_1133 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1164 = (_1134 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        float _1165 = (_1135 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
        _1304 = ((((_1155 * exp2(log2(_1136) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _883) + (((TonemapParam_m0[0u].x * _1133) + TonemapParam_m0[2u].z) * ((1.0f - _1163) - _1155))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1133) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1163);
        _1307 = ((((exp2(log2(_1142) * TonemapParam_m0[0u].w) * _1157) * TonemapParam_m0[0u].y) + _885) + (((TonemapParam_m0[0u].x * _1134) + TonemapParam_m0[2u].z) * ((1.0f - _1164) - _1157))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1134) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1164);
        _1310 = ((((exp2(log2(_1148) * TonemapParam_m0[0u].w) * _1159) * TonemapParam_m0[0u].y) + _887) + (((TonemapParam_m0[0u].x * _1135) + TonemapParam_m0[2u].z) * ((1.0f - _1165) - _1159))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1135) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1165);
      } else {
        float _1223 = RadialBlurRenderParam_m0[1u].x + 0.5f;
        float _1224 = _1223 + _763;
        float _1225 = RadialBlurRenderParam_m0[1u].y + 0.5f;
        float _1226 = _1225 + _764;
        float _1227 = _1223 + _775;
        float _1228 = _1225 + _776;
        float _1229 = _1223 + _787;
        float _1230 = _1225 + _788;
        float _1231 = _1223 + _799;
        float _1232 = _1225 + _800;
        float _1233 = _1223 + _811;
        float _1234 = _1225 + _812;
        float _1235 = _1223 + _823;
        float _1236 = _1225 + _824;
        float _1237 = _1223 + _835;
        float _1238 = _1225 + _836;
        float _1239 = _1223 + _847;
        float _1240 = _1225 + _848;
        float _1241 = _1223 + _859;
        float _1242 = _1225 + _860;
        float frontier_phi_25_18_ladder;
        float frontier_phi_25_18_ladder_1;
        float frontier_phi_25_18_ladder_2;
        if (_123) {
          float _1316 = (_1224 * 2.0f) + (-1.0f);
          float _1320 = sqrt((_1316 * _1316) + 1.0f);
          float _1321 = 1.0f / _1320;
          float _1324 = (_1320 * _609) * (_1321 + _607);
          float _1328 = _610 * 0.5f;
          float4 _1337 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1324) * _1316) + 0.5f, (((_1328 * (((_1321 + (-1.0f)) * _608) + 1.0f)) * _1324) * ((_1226 * 2.0f) + (-1.0f))) + 0.5f), 0.0f);
          float _1344 = (_1227 * 2.0f) + (-1.0f);
          float _1348 = sqrt((_1344 * _1344) + 1.0f);
          float _1349 = 1.0f / _1348;
          float _1352 = (_1348 * _609) * (_1349 + _607);
          float4 _1363 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1344) * _1352) + 0.5f, (((_1328 * ((_1228 * 2.0f) + (-1.0f))) * (((_1349 + (-1.0f)) * _608) + 1.0f)) * _1352) + 0.5f), 0.0f);
          float _1373 = (_1229 * 2.0f) + (-1.0f);
          float _1377 = sqrt((_1373 * _1373) + 1.0f);
          float _1378 = 1.0f / _1377;
          float _1381 = (_1377 * _609) * (_1378 + _607);
          float4 _1392 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1373) * _1381) + 0.5f, (((_1328 * ((_1230 * 2.0f) + (-1.0f))) * (((_1378 + (-1.0f)) * _608) + 1.0f)) * _1381) + 0.5f), 0.0f);
          float _1402 = (_1231 * 2.0f) + (-1.0f);
          float _1406 = sqrt((_1402 * _1402) + 1.0f);
          float _1407 = 1.0f / _1406;
          float _1410 = (_1406 * _609) * (_1407 + _607);
          float4 _1421 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1402) * _1410) + 0.5f, (((_1328 * ((_1232 * 2.0f) + (-1.0f))) * (((_1407 + (-1.0f)) * _608) + 1.0f)) * _1410) + 0.5f), 0.0f);
          float _1431 = (_1233 * 2.0f) + (-1.0f);
          float _1435 = sqrt((_1431 * _1431) + 1.0f);
          float _1436 = 1.0f / _1435;
          float _1439 = (_1435 * _609) * (_1436 + _607);
          float4 _1450 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1431) * _1439) + 0.5f, (((_1328 * ((_1234 * 2.0f) + (-1.0f))) * (((_1436 + (-1.0f)) * _608) + 1.0f)) * _1439) + 0.5f), 0.0f);
          float _1460 = (_1235 * 2.0f) + (-1.0f);
          float _1464 = sqrt((_1460 * _1460) + 1.0f);
          float _1465 = 1.0f / _1464;
          float _1468 = (_1464 * _609) * (_1465 + _607);
          float4 _1479 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1460) * _1468) + 0.5f, (((_1328 * ((_1236 * 2.0f) + (-1.0f))) * (((_1465 + (-1.0f)) * _608) + 1.0f)) * _1468) + 0.5f), 0.0f);
          float _1489 = (_1237 * 2.0f) + (-1.0f);
          float _1493 = sqrt((_1489 * _1489) + 1.0f);
          float _1494 = 1.0f / _1493;
          float _1497 = (_1493 * _609) * (_1494 + _607);
          float4 _1508 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1489) * _1497) + 0.5f, (((_1328 * ((_1238 * 2.0f) + (-1.0f))) * (((_1494 + (-1.0f)) * _608) + 1.0f)) * _1497) + 0.5f), 0.0f);
          float _1518 = (_1239 * 2.0f) + (-1.0f);
          float _1522 = sqrt((_1518 * _1518) + 1.0f);
          float _1523 = 1.0f / _1522;
          float _1526 = (_1522 * _609) * (_1523 + _607);
          float4 _1537 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1518) * _1526) + 0.5f, (((_1328 * ((_1240 * 2.0f) + (-1.0f))) * (((_1523 + (-1.0f)) * _608) + 1.0f)) * _1526) + 0.5f), 0.0f);
          float _1547 = (_1241 * 2.0f) + (-1.0f);
          float _1551 = sqrt((_1547 * _1547) + 1.0f);
          float _1552 = 1.0f / _1551;
          float _1555 = (_1551 * _609) * (_1552 + _607);
          float4 _1566 = RE_POSTPROCESS_Color.SampleLevel(BilinearBorder, float2(((_1328 * _1547) * _1555) + 0.5f, (((_1328 * ((_1242 * 2.0f) + (-1.0f))) * (((_1552 + (-1.0f)) * _608) + 1.0f)) * _1555) + 0.5f), 0.0f);
          float _1574 = _863 * ((((((((_1363.x + _1337.x) + _1392.x) + _1421.x) + _1450.x) + _1479.x) + _1508.x) + _1537.x) + _1566.x);
          float _1575 = _864 * ((((((((_1363.y + _1337.y) + _1392.y) + _1421.y) + _1450.y) + _1479.y) + _1508.y) + _1537.y) + _1566.y);
          float _1576 = _865 * ((((((((_1363.z + _1337.z) + _1392.z) + _1421.z) + _1450.z) + _1479.z) + _1508.z) + _1537.z) + _1566.z);
          float _1577 = _1574 * TonemapParam_m0[2u].y;
          float _1583 = _1575 * TonemapParam_m0[2u].y;
          float _1589 = _1576 * TonemapParam_m0[2u].y;
          float _1596 = (_1574 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1577 * _1577) * (3.0f - (_1577 * 2.0f))));
          float _1598 = (_1575 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1583 * _1583) * (3.0f - (_1583 * 2.0f))));
          float _1600 = (_1576 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1589 * _1589) * (3.0f - (_1589 * 2.0f))));
          float _1604 = (_1574 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1605 = (_1575 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1606 = (_1576 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_25_18_ladder = ((((_1596 * exp2(log2(_1577) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _883) + (((TonemapParam_m0[0u].x * _1574) + TonemapParam_m0[2u].z) * ((1.0f - _1604) - _1596))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1574) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1604);
          frontier_phi_25_18_ladder_1 = ((((exp2(log2(_1583) * TonemapParam_m0[0u].w) * _1598) * TonemapParam_m0[0u].y) + _885) + (((TonemapParam_m0[0u].x * _1575) + TonemapParam_m0[2u].z) * ((1.0f - _1605) - _1598))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1575) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1605);
          frontier_phi_25_18_ladder_2 = ((((exp2(log2(_1589) * TonemapParam_m0[0u].w) * _1600) * TonemapParam_m0[0u].y) + _887) + (((TonemapParam_m0[0u].x * _1576) + TonemapParam_m0[2u].z) * ((1.0f - _1606) - _1600))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1576) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1606);
        } else {
          float4 _1662 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1224, _1226), 0.0f);
          float4 _1667 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1227, _1228), 0.0f);
          float4 _1675 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1229, _1230), 0.0f);
          float4 _1683 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1231, _1232), 0.0f);
          float4 _1691 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1233, _1234), 0.0f);
          float4 _1699 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1235, _1236), 0.0f);
          float4 _1707 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1237, _1238), 0.0f);
          float4 _1715 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1239, _1240), 0.0f);
          float4 _1723 = RE_POSTPROCESS_Color.SampleLevel(BilinearClamp, float2(_1241, _1242), 0.0f);
          float _1731 = _863 * ((((((((_1667.x + _1662.x) + _1675.x) + _1683.x) + _1691.x) + _1699.x) + _1707.x) + _1715.x) + _1723.x);
          float _1732 = _864 * ((((((((_1667.y + _1662.y) + _1675.y) + _1683.y) + _1691.y) + _1699.y) + _1707.y) + _1715.y) + _1723.y);
          float _1733 = _865 * ((((((((_1667.z + _1662.z) + _1675.z) + _1683.z) + _1691.z) + _1699.z) + _1707.z) + _1715.z) + _1723.z);
          float _1734 = _1731 * TonemapParam_m0[2u].y;
          float _1740 = _1732 * TonemapParam_m0[2u].y;
          float _1746 = _1733 * TonemapParam_m0[2u].y;
          float _1753 = (_1731 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1734 * _1734) * (3.0f - (_1734 * 2.0f))));
          float _1755 = (_1732 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1740 * _1740) * (3.0f - (_1740 * 2.0f))));
          float _1757 = (_1733 >= TonemapParam_m0[0u].y) ? 0.0f : (1.0f - ((_1746 * _1746) * (3.0f - (_1746 * 2.0f))));
          float _1761 = (_1731 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1762 = (_1732 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          float _1763 = (_1733 < TonemapParam_m0[1u].y) ? 0.0f : 1.0f;
          frontier_phi_25_18_ladder = ((((_1753 * exp2(log2(_1734) * TonemapParam_m0[0u].w)) * TonemapParam_m0[0u].y) + _883) + (((TonemapParam_m0[0u].x * _1731) + TonemapParam_m0[2u].z) * ((1.0f - _1761) - _1753))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1731) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1761);
          frontier_phi_25_18_ladder_1 = ((((exp2(log2(_1740) * TonemapParam_m0[0u].w) * _1755) * TonemapParam_m0[0u].y) + _885) + (((TonemapParam_m0[0u].x * _1732) + TonemapParam_m0[2u].z) * ((1.0f - _1762) - _1755))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1732) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1762);
          frontier_phi_25_18_ladder_2 = ((((exp2(log2(_1746) * TonemapParam_m0[0u].w) * _1757) * TonemapParam_m0[0u].y) + _887) + (((TonemapParam_m0[0u].x * _1733) + TonemapParam_m0[2u].z) * ((1.0f - _1763) - _1757))) + ((TonemapParam_m0[1u].x - (exp2((TonemapParam_m0[1u].w * _1733) + TonemapParam_m0[2u].x) * TonemapParam_m0[1u].z)) * _1763);
        }
        _1304 = frontier_phi_25_18_ladder;
        _1307 = frontier_phi_25_18_ladder_1;
        _1310 = frontier_phi_25_18_ladder_2;
      }
      float _1968;
      float _1969;
      float _1970;
      if (RadialBlurRenderParam_m0[2u].x > 0.0f) {
        float _1952 = clamp((sqrt((_706 * _706) + (_708 * _708)) * RadialBlurRenderParam_m0[1u].z) + RadialBlurRenderParam_m0[1u].w, 0.0f, 1.0f);
        float _1958 = (((_1952 * _1952) * RadialBlurRenderParam_m0[2u].x) * (3.0f - (_1952 * 2.0f))) + RadialBlurRenderParam_m0[2u].y;
        _1968 = (_1958 * (_1304 - _603)) + _603;
        _1969 = (_1958 * (_1307 - _604)) + _604;
        _1970 = (_1958 * (_1310 - _605)) + _605;
      } else {
        _1968 = _1304;
        _1969 = _1307;
        _1970 = _1310;
      }
      frontier_phi_8_9_ladder = ((_1970 - _605) * _653) + _605;
      frontier_phi_8_9_ladder_1 = ((_1969 - _604) * _653) + _604;
      frontier_phi_8_9_ladder_2 = ((_1968 - _603) * _653) + _603;
    }
    _615 = frontier_phi_8_9_ladder_2;
    _617 = frontier_phi_8_9_ladder_1;
    _619 = frontier_phi_8_9_ladder;
  }
  float _655;
  float _657;
  float _659;
  if ((_112 & 2u) == 0u) {
    _655 = _615;
    _657 = _617;
    _659 = _619;
  } else {
    float _684 = floor(((SceneInfo_m0[23u].x * FilmGrainParam_m0[0u].z) + gl_FragCoord.x) * FilmGrainParam_m0[1u].w);
    float _686 = floor(((SceneInfo_m0[23u].y * FilmGrainParam_m0[0u].w) + gl_FragCoord.y) * FilmGrainParam_m0[1u].w);
    float _695 = frac(frac(dot(float2(_684, _686), float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f);
    float _942;
    if (_695 < FilmGrainParam_m0[1u].x) {
      uint _930 = uint(_686 * _684) ^ 12345391u;
      uint _932 = _930 * 3635641u;
      _942 = float(((_932 >> 26u) | (_930 * 232681024u)) ^ _932) * 2.3283064365386962890625e-10f;
    } else {
      _942 = 0.0f;
    }
    float _945 = frac(_695 * 757.48468017578125f);
    float _1300;
    if (_945 < FilmGrainParam_m0[1u].x) {
      uint _1291 = asuint(_945) ^ 12345391u;
      uint _1292 = _1291 * 3635641u;
      _1300 = (float(((_1292 >> 26u) | (_1291 * 232681024u)) ^ _1292) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _1300 = 0.0f;
    }
    float _1302 = frac(_945 * 757.48468017578125f);
    float _1917;
    if (_1302 < FilmGrainParam_m0[1u].x) {
      uint _1908 = asuint(_1302) ^ 12345391u;
      uint _1909 = _1908 * 3635641u;
      _1917 = (float(((_1909 >> 26u) | (_1908 * 232681024u)) ^ _1909) * 2.3283064365386962890625e-10f) + (-0.5f);
    } else {
      _1917 = 0.0f;
    }
    float _1918 = _942 * FilmGrainParam_m0[0u].x;
    float _1919 = _1917 * FilmGrainParam_m0[0u].y;
    float _1920 = _1300 * FilmGrainParam_m0[0u].y;
    float _1939 = exp2(log2(1.0f - clamp(dot(float3(_615, _617, _619), float3(0.2989999949932098388671875f, -0.1689999997615814208984375f, 0.5f)), 0.0f, 1.0f)) * FilmGrainParam_m0[1u].y) * FilmGrainParam_m0[1u].z;
    _655 = (_1939 * (mad(_1920, 1.401999950408935546875f, _1918) - _615)) + _615;
    _657 = (_1939 * (mad(_1920, -0.7139999866485595703125f, mad(_1919, -0.3440000116825103759765625f, _1918)) - _617)) + _617;
    _659 = (_1939 * (mad(_1919, 1.77199995517730712890625f, _1918) - _619)) + _619;
  }
  float _888;
  float _891;
  float _894;
  if ((_112 & 4u) == 0u) {
    _888 = _655;
    _891 = _657;
    _894 = _659;
  } else {
    float _926 = max(max(_655, _657), _659);
    bool _927 = _926 > 1.0f;
    float _1284;
    float _1285;
    float _1286;
#if 1  // use UpgradeToneMap() for LUT sampling
    untonemapped = float3(_655, _657, _659);
    hdrColor = untonemapped;

    sdrColor = LUTToneMap(untonemapped);

#endif

#if 0  // max channel LUT sampling
        if (_927)
        {
            _1284 = _655 / _926;
            _1285 = _657 / _926;
            _1286 = _659 / _926;
        }
        else
        {
            _1284 = _655;
            _1285 = _657;
            _1286 = _659;
        }
#else
    _1284 = sdrColor.r;
    _1285 = sdrColor.g;
    _1286 = sdrColor.b;
#endif

#if 0
        float _1287 = ColorCorrectTexture_m0[0u].w * 0.5f;
        float _1977;
        if (_1284 > 0.003130800090730190277099609375f)
        {
            _1977 = (exp2(log2(_1284) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1977 = _1284 * 12.9200000762939453125f;
        }
        float _1985;
        if (_1285 > 0.003130800090730190277099609375f)
        {
            _1985 = (exp2(log2(_1285) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1985 = _1285 * 12.9200000762939453125f;
        }
        float _1993;
        if (_1286 > 0.003130800090730190277099609375f)
        {
            _1993 = (exp2(log2(_1286) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        else
        {
            _1993 = _1286 * 12.9200000762939453125f;
        }
        float _1994 = 1.0f - ColorCorrectTexture_m0[0u].w;
        float _1998 = (_1977 * _1994) + _1287;
        float _1999 = (_1985 * _1994) + _1287;
        float _2000 = (_1993 * _1994) + _1287;
        float4 _2003 = tTextureMap0.SampleLevel(TrilinearClamp, float3(_1998, _1999, _2000), 0.0f);
#else
    float3 _2003 = LUTBlackCorrection(float3(_1284, _1285, _1286), tTextureMap0, lut_config);
#endif
    float _2005 = _2003.x;
    float _2006 = _2003.y;
    float _2007 = _2003.z;
    float _2027;
    float _2030;
    float _2033;
    if (ColorCorrectTexture_m0[0u].y > 0.0f) {
#if 0
            float4 _2010 = tTextureMap1.SampleLevel(TrilinearClamp, float3(_1998, _1999, _2000), 0.0f);
#else
      float3 _2010 = LUTBlackCorrection(float3(_1284, _1285, _1286), tTextureMap1, lut_config);
#endif
      float _2021 = ((_2010.x - _2005) * ColorCorrectTexture_m0[0u].y) + _2005;
      float _2022 = ((_2010.y - _2006) * ColorCorrectTexture_m0[0u].y) + _2006;
      float _2023 = ((_2010.z - _2007) * ColorCorrectTexture_m0[0u].y) + _2007;
      float frontier_phi_46_43_ladder;
      float frontier_phi_46_43_ladder_1;
      float frontier_phi_46_43_ladder_2;
      if (ColorCorrectTexture_m0[0u].z > 0.0f) {
#if 0
                float _2059;
                if (_2021 > 0.003130800090730190277099609375f)
                {
                    _2059 = (exp2(log2(_2021) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2059 = _2021 * 12.9200000762939453125f;
                }
                float _2075;
                if (_2022 > 0.003130800090730190277099609375f)
                {
                    _2075 = (exp2(log2(_2022) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2075 = _2022 * 12.9200000762939453125f;
                }
                float _2102;
                if (_2023 > 0.003130800090730190277099609375f)
                {
                    _2102 = (exp2(log2(_2023) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
                }
                else
                {
                    _2102 = _2023 * 12.9200000762939453125f;
                }
                
                float4 _2104 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2059, _2075, _2102), 0.0f);
#else
        float3 _2104 = LUTBlackCorrection(float3(_2021, _2022, _2023), tTextureMap2, lut_config);

#endif
        frontier_phi_46_43_ladder = ((_2104.z - _2023) * ColorCorrectTexture_m0[0u].z) + _2023;
        frontier_phi_46_43_ladder_1 = ((_2104.y - _2022) * ColorCorrectTexture_m0[0u].z) + _2022;
        frontier_phi_46_43_ladder_2 = ((_2104.x - _2021) * ColorCorrectTexture_m0[0u].z) + _2021;
      } else {
        frontier_phi_46_43_ladder = _2023;
        frontier_phi_46_43_ladder_1 = _2022;
        frontier_phi_46_43_ladder_2 = _2021;
      }
      _2027 = frontier_phi_46_43_ladder_2;
      _2030 = frontier_phi_46_43_ladder_1;
      _2033 = frontier_phi_46_43_ladder;
    } else {
#if 0
            float _2057;
            if (_2005 > 0.003130800090730190277099609375f)
            {
                _2057 = (exp2(log2(_2005) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2057 = _2005 * 12.9200000762939453125f;
            }
            float _2073;
            if (_2006 > 0.003130800090730190277099609375f)
            {
                _2073 = (exp2(log2(_2006) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2073 = _2006 * 12.9200000762939453125f;
            }
            float _2089;
            if (_2007 > 0.003130800090730190277099609375f)
            {
                _2089 = (exp2(log2(_2007) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
            }
            else
            {
                _2089 = _2007 * 12.9200000762939453125f;
            }
            float4 _2091 = tTextureMap2.SampleLevel(TrilinearClamp, float3(_2057, _2073, _2089), 0.0f);
#else
      float3 _2091 = LUTBlackCorrection(float3(_2005, _2006, _2007), tTextureMap2, lut_config);
#endif
      _2027 = ((_2091.x - _2005) * ColorCorrectTexture_m0[0u].z) + _2005;
      _2030 = ((_2091.y - _2006) * ColorCorrectTexture_m0[0u].z) + _2006;
      _2033 = ((_2091.z - _2007) * ColorCorrectTexture_m0[0u].z) + _2007;
    }
    float _890 = mad(_2033, ColorCorrectTexture_m0[3u].x, mad(_2030, ColorCorrectTexture_m0[2u].x, _2027 * ColorCorrectTexture_m0[1u].x)) + ColorCorrectTexture_m0[4u].x;
    float _893 = mad(_2033, ColorCorrectTexture_m0[3u].y, mad(_2030, ColorCorrectTexture_m0[2u].y, _2027 * ColorCorrectTexture_m0[1u].y)) + ColorCorrectTexture_m0[4u].y;
    float _896 = mad(_2033, ColorCorrectTexture_m0[3u].z, mad(_2030, ColorCorrectTexture_m0[2u].z, _2027 * ColorCorrectTexture_m0[1u].z)) + ColorCorrectTexture_m0[4u].z;
    float frontier_phi_13_46_ladder;
    float frontier_phi_13_46_ladder_1;
    float frontier_phi_13_46_ladder_2;
#if 0
        if (_927)
        {
            frontier_phi_13_46_ladder = _896 * _926;
            frontier_phi_13_46_ladder_1 = _893 * _926;
            frontier_phi_13_46_ladder_2 = _890 * _926;
        }
        else
        {
            frontier_phi_13_46_ladder = _896;
            frontier_phi_13_46_ladder_1 = _893;
            frontier_phi_13_46_ladder_2 = _890;
        }
        _888 = frontier_phi_13_46_ladder_2;
        _891 = frontier_phi_13_46_ladder_1;
        _894 = frontier_phi_13_46_ladder;
#else
    float3 postprocessColor = float3(_890, _893, _896);
    float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, postprocessColor, 1.f);
    _888 = upgradedColor.r;
    _891 = upgradedColor.g;
    _894 = upgradedColor.b;
#endif
  }
  float _1243;
  float _1245;
  float _1247;
  if ((_112 & 8u) == 0u) {
    _1243 = _888;
    _1245 = _891;
    _1247 = _894;
  } else {
    _1243 = clamp(((ColorDeficientTable_m0[0u].x * _888) + (ColorDeficientTable_m0[0u].y * _891)) + (ColorDeficientTable_m0[0u].z * _894), 0.0f, 1.0f);
    _1245 = clamp(((ColorDeficientTable_m0[1u].x * _888) + (ColorDeficientTable_m0[1u].y * _891)) + (ColorDeficientTable_m0[1u].z * _894), 0.0f, 1.0f);
    _1247 = clamp(((ColorDeficientTable_m0[2u].x * _888) + (ColorDeficientTable_m0[2u].y * _891)) + (ColorDeficientTable_m0[2u].z * _894), 0.0f, 1.0f);
  }
  float _1818;
  float _1820;
  float _1822;
  if ((_112 & 16u) == 0u) {
    _1818 = _1243;
    _1820 = _1245;
    _1822 = _1247;
  } else {
    float _1843 = SceneInfo_m0[23u].z * gl_FragCoord.x;
    float _1844 = SceneInfo_m0[23u].w * gl_FragCoord.y;
    float4 _1846 = ImagePlameBase.SampleLevel(BilinearClamp, float2(_1843, _1844), 0.0f);
    float _1852 = _1846.x * ImagePlaneParam_m0[0u].x;
    float _1853 = _1846.y * ImagePlaneParam_m0[0u].y;
    float _1854 = _1846.z * ImagePlaneParam_m0[0u].z;
    float _1863 = (_1846.w * ImagePlaneParam_m0[0u].w) * clamp((ImagePlameAlpha.SampleLevel(BilinearClamp, float2(_1843, _1844), 0.0f).x * ImagePlaneParam_m0[1u].x) + ImagePlaneParam_m0[1u].y, 0.0f, 1.0f);
    _1818 = ((((_1852 < 0.5f) ? ((_1243 * 2.0f) * _1852) : (1.0f - (((1.0f - _1243) * 2.0f) * (1.0f - _1852)))) - _1243) * _1863) + _1243;
    _1820 = ((((_1853 < 0.5f) ? ((_1245 * 2.0f) * _1853) : (1.0f - (((1.0f - _1245) * 2.0f) * (1.0f - _1853)))) - _1245) * _1863) + _1245;
    _1822 = ((((_1854 < 0.5f) ? ((_1247 * 2.0f) * _1854) : (1.0f - (((1.0f - _1247) * 2.0f) * (1.0f - _1854)))) - _1247) * _1863) + _1247;
  }
  SV_Target.x = _1818;
  SV_Target.y = _1820;
  SV_Target.z = _1822;
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
