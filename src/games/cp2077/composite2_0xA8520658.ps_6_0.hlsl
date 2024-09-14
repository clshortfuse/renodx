#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

static float _581;
static float _582;
static float _583;

cbuffer _25_27 : register(b0, space0) {
  float4 _27_m0[30] : packoffset(c0);
};

cbuffer _30_32 : register(b12, space0) {
  float4 _32_m0[99] : packoffset(c0);
};

cbuffer _35_37 : register(b6, space0) {
  float4 _37_m0[15] : packoffset(c0);
};

Texture2D<float3> _15 : register(t0, space0);
Texture2D<float3> _16 : register(t1, space0);
Texture3D<float3> _21[3] : register(t4, space0);
Texture2D<uint2> _8 : register(t51, space0);
Texture2DArray<float4> _12 : register(t67, space0);
SamplerState _40 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  nointerpolation float2 SYS_TEXCOORD : SYS_TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  uint _62 = uint(int(gl_FragCoord.x));
  uint _63 = uint(int(gl_FragCoord.y));
  float _64 = float(int(_62));
  float _65 = float(int(_63));
  float _66 = _64 + 0.5f;
  float _68 = _65 + 0.5f;
  float _75 = _66 * _37_m0[10u].z;
  float _76 = _68 * _37_m0[10u].w;
  float _90 = (_37_m0[14u].x * _37_m0[10u].x) * ((_75 * 2.0f) + (-1.0f));
  float _92 = (_37_m0[14u].x * _37_m0[10u].y) * ((_76 * 2.0f) + (-1.0f));
  float _107 = exp2(log2(max(dot(float2(_90, _92), float2(_90, _92)) - _37_m0[7u].w, 0.0f)) * _37_m0[7u].z);
  float _112 = (_107 * _90) * _37_m0[7u].x;
  float _113 = (_107 * _92) * _37_m0[7u].y;
  float4 _124 = _12.Load(int4(uint3(_62 & 63u, _63 & 63u, asuint(_27_m0[28u]).y & 63u), 0u));
  float _127 = _124.x;
  float _131 = _76 - (_127 * _113);
  float _138 = (_75 - (_127 * _112)) - (_37_m0[8u].w * 2.5f);
  float3 _145 = _16.Sample(_40, float2(_75 - (_112 * 2.5f), _76 - (_113 * 2.5f)));
  float _157 = _131 - _113;
  float _161 = _37_m0[8u].w + (_138 - _112);
  float3 _162 = _15.Sample(_40, float2(_161, _157));
  float _175 = _157 - _113;
  float _176 = _37_m0[8u].w + (_161 - _112);
  float3 _177 = _15.Sample(_40, float2(_176, _175));
  float _189 = _175 - _113;
  float _190 = _37_m0[8u].w + (_176 - _112);
  float3 _191 = _15.Sample(_40, float2(_190, _189));
  // float _240 = ((((_37_m0[0u].w * 0.625f) * ((((_177.x * 0.300000011920928955078125f) + (_162.x * 0.100000001490116119384765625f)) + (_191.x * 0.4000000059604644775390625f)) + (_15.Sample(_40, float2((_190 - _112) + _37_m0[8u].w, _189 - _113)).x * 0.800000011920928955078125f))) + (_37_m0[0u].x * _145.x)) * _37_m0[11u].w) + _37_m0[11u].x;
  // float _241 = (((_37_m0[0u].y * _145.y) + (((((_177.y * 0.5f) + (_162.y * 0.4000000059604644775390625f)) + (_191.y * 0.20000000298023223876953125f)) * 0.90909087657928466796875f) * _37_m0[0u].w)) * _37_m0[11u].w) + _37_m0[11u].y;
  // float _242 = (((_37_m0[0u].z * _145.z) + (((((_162.z * 0.300000011920928955078125f) + (_15.Sample(_40, float2(_138, _131)).z * 0.89999997615814208984375f)) + (_177.z * 0.100000001490116119384765625f)) * 0.76923072338104248046875f) * _37_m0[0u].w)) * _37_m0[11u].w) + _37_m0[11u].z;

  // Custom: abstract bloom, global_gain and global_lift1 and global_lift2
  float inputGain = _37_m0[0u].w; // * injectedData.processingGlobalLift;
  float3 bloomStrength = _37_m0[0u].xyz * injectedData.fxBloom;
  float _240 = (((inputGain * 0.625f) * ((((_177.x * 0.300000011920928955078125f) + (_162.x * 0.100000001490116119384765625f)) + (_191.x * 0.4000000059604644775390625f)) + (_15.Sample(_40, float2((_190 - _112) + _37_m0[8u].w, _189 - _113)).x * 0.800000011920928955078125f))) + (bloomStrength.x * _145.x));
  float _241 = ((bloomStrength.y * _145.y) + (((((_177.y * 0.5f) + (_162.y * 0.4000000059604644775390625f)) + (_191.y * 0.20000000298023223876953125f)) * 0.90909087657928466796875f) * inputGain));
  float _242 = ((bloomStrength.z * _145.z) + (((((_162.z * 0.300000011920928955078125f) + (_15.Sample(_40, float2(_138, _131)).z * 0.89999997615814208984375f)) + (_177.z * 0.100000001490116119384765625f)) * 0.76923072338104248046875f) * inputGain));
  _240 *= lerp(1.f, _37_m0[11u].w, injectedData.processingGlobalGain);
  _241 *= lerp(1.f, _37_m0[11u].w, injectedData.processingGlobalGain);
  _242 *= lerp(1.f, _37_m0[11u].w, injectedData.processingGlobalGain);

  _240 += _37_m0[11u].r * injectedData.processingGlobalLift;
  _241 += _37_m0[11u].g * injectedData.processingGlobalLift;
  _242 += _37_m0[11u].b * injectedData.processingGlobalLift;


  float _259 = (_37_m0[14u].x * _37_m0[10u].x) * (((_66 * 2.0f) * _37_m0[10u].z) + (-1.0f));
  float _261 = (_37_m0[14u].x * _37_m0[10u].y) * (((_68 * 2.0f) * _37_m0[10u].w) + (-1.0f));
  float _293;
  float _294;
  float _295;
  if (_37_m0[9u].x > 0.0f) {
    float _280 = exp2((-0.0f) - (_37_m0[9u].y * log2(abs((dot(float2(_259, _261), float2(_259, _261)) * _37_m0[9u].x) + 1.0f))));
    _293 = ((_240 - _37_m0[8u].x) * _280) + _37_m0[8u].x;
    _294 = ((_241 - _37_m0[8u].y) * _280) + _37_m0[8u].y;
    _295 = ((_242 - _37_m0[8u].z) * _280) + _37_m0[8u].z;
  } else {
    _293 = _240;
    _294 = _241;
    _295 = _242;
  }

  // Custom: Lerp vignette
  _293 = lerp(_240, _293, injectedData.fxVignette);
  _294 = lerp(_241, _294, injectedData.fxVignette);
  _295 = lerp(_242, _295, injectedData.fxVignette);

  float _525;
  float _526;
  float _527;
  uint _320;
  float _446;
  float _447;
  float _448;
  float _460;
  float _461;
  float _462;
  float _470;
  float _471;
  float _472;
  uint _479;
  bool _480;
  for (;;) {
    _320 = 1u << (_8.Load(int3(uint2(uint(_32_m0[79u].x * _64), uint(_32_m0[79u].y * _65)), 0u)).y & 31u);
    float _332 = frac(_64 * 0.103100001811981201171875f);
    float _333 = frac(_65 * 0.10300000011920928955078125f);
    float _334 = frac(float(asuint(_27_m0[28u]).y) * 0.097300000488758087158203125f);
    float _339 = dot(float3(_332, _333, _334), float3(_333 + 33.3300018310546875f, _332 + 33.3300018310546875f, _334 + 33.3300018310546875f));
    float _343 = _339 + _332;
    float _344 = _339 + _333;
    float _346 = _343 + _344;
    float _354 = frac(_346 * (_339 + _334)) + (-0.5f);
    float _356 = frac((_343 * 2.0f) * _344) + (-0.5f);
    float _357 = frac(_346 * _343) + (-0.5f);
    uint4 _370 = asuint(_37_m0[13u]);
    float _374 = float(min((_370.x & _320), 1u));
    float _395 = float(min((_370.y & _320), 1u));
    float _417 = float(min((_370.z & _320), 1u));
    float _439 = float(min((_370.w & _320), 1u));
    _446 = (((((_293 * SYS_TEXCOORD.x) * _37_m0[1u].y) * (((_37_m0[2u].x * _354) * _374) + 1.0f)) * (((_37_m0[3u].x * _354) * _395) + 1.0f)) * (((_37_m0[4u].x * _354) * _417) + 1.0f)) * (((_37_m0[5u].x * _354) * _439) + 1.0f);
    _447 = (((((_294 * SYS_TEXCOORD.x) * _37_m0[1u].y) * (((_37_m0[2u].y * _356) * _374) + 1.0f)) * (((_37_m0[3u].y * _356) * _395) + 1.0f)) * (((_37_m0[4u].y * _356) * _417) + 1.0f)) * (((_37_m0[5u].y * _356) * _439) + 1.0f);
    _448 = (((((_295 * SYS_TEXCOORD.x) * _37_m0[1u].y) * (((_37_m0[2u].z * _357) * _374) + 1.0f)) * (((_37_m0[3u].z * _357) * _395) + 1.0f)) * (((_37_m0[4u].z * _357) * _417) + 1.0f)) * (((_37_m0[5u].z * _357) * _439) + 1.0f);
    // Custom: PQ Sampling
    if (injectedData.processingInternalSampling == 1.f) {
      float3 rec2020 = renodx::color::bt2020::from::BT709(float3(_446, _447, _448));
      float3 pqColor = renodx::color::pq::from::BT2020((rec2020 * 100.f) / 10000.f);  // reset scale to 0-1 for 0-10000 nits
      _460 = pqColor.r;
      _461 = pqColor.g;
      _462 = pqColor.b;
    } else {
      _460 = (_37_m0[6u].x * log2(_446)) + _37_m0[6u].y;
      _461 = (_37_m0[6u].x * log2(_447)) + _37_m0[6u].y;
      _462 = (_37_m0[6u].x * log2(_448)) + _37_m0[6u].y;
    }
    float3 _468 = _21[4u].SampleLevel(_40, float3(_460, _461, _462), 0.0f);
    _470 = _468.x;
    _471 = _468.y;
    _472 = _468.z;
    _479 = min((asuint(_37_m0[12u]).x & _320), 1u);
    _480 = _479 == 0u;
    uint _496;
    float _498;
    float _500;
    float _502;
    if (_480) {
      float3 _484 = _21[5u].SampleLevel(_40, float3(_460, _461, _462), 0.0f);
      uint _494 = min((asuint(_37_m0[12u]).y & _320), 1u);
      uint frontier_phi_4_3_ladder;
      float frontier_phi_4_3_ladder_1;
      float frontier_phi_4_3_ladder_2;
      float frontier_phi_4_3_ladder_3;
      if (_494 == 0u) {
        float3 _517 = _21[6u].SampleLevel(_40, float3(_460, _461, _462), 0.0f);
        uint _497 = min((asuint(_37_m0[12u]).z & _320), 1u);
        if (_497 == 0u) {
          _525 = _446;
          _526 = _447;
          _527 = _448;
          break;
        }
        frontier_phi_4_3_ladder = _497;
        frontier_phi_4_3_ladder_1 = _517.z;
        frontier_phi_4_3_ladder_2 = _517.y;
        frontier_phi_4_3_ladder_3 = _517.x;
      } else {
        frontier_phi_4_3_ladder = _494;
        frontier_phi_4_3_ladder_1 = _484.z;
        frontier_phi_4_3_ladder_2 = _484.y;
        frontier_phi_4_3_ladder_3 = _484.x;
      }
      _496 = frontier_phi_4_3_ladder;
      _498 = frontier_phi_4_3_ladder_1;
      _500 = frontier_phi_4_3_ladder_2;
      _502 = frontier_phi_4_3_ladder_3;
    } else {
      _496 = _479;
      _498 = _472;
      _500 = _471;
      _502 = _470;
    }
    float _504 = float(_496);
    _525 = ((_502 - _446) * _504) + _446;
    _526 = ((_500 - _447) * _504) + _447;
    _527 = ((_498 - _448) * _504) + _448;
    break;
  }
  float _528 = dot(float3(_525, _526, _527), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _540 = max(9.9999997473787516355514526367188e-05f, dot(float3(_446, _447, _448), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
  SV_Target.x = ((_37_m0[1u].w * (((_528 * _446) / _540) - _525)) + _525) * _37_m0[1u].z;
  SV_Target.y = ((_37_m0[1u].w * (((_528 * _447) / _540) - _526)) + _526) * _37_m0[1u].z;
  SV_Target.z = ((_37_m0[1u].w * (((_528 * _448) / _540) - _527)) + _527) * _37_m0[1u].z;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
