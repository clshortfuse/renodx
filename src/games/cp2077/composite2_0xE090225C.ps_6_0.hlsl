#include "./composite2.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

static float _851;
static float _852;
static float _853;
static float _855;
static float _856;
static float _857;

cbuffer _25_27 : register(b0, space0) {
  float4 _27_m0[30] : packoffset(c0);
};

cbuffer _30_32 : register(b12, space0) {
  float4 _32_m0[99] : packoffset(c0);
};

cbuffer _35_37 : register(b6, space0) {
  float4 _37_m0[15] : packoffset(c0);
};

Texture2D<uint2> _8 : register(t51, space0);
Texture2DArray<float3> _12 : register(t67, space0);
Texture2D<float3> _15 : register(t0, space0);
Texture2D<float3> _16 : register(t1, space0);
Texture3D<float3> _21[3] : register(t4, space0);
SamplerState _40 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;
static float4 SV_Target_1;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  nointerpolation float2 SYS_TEXCOORD : SYS_TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float4 SV_Target_1 : SV_Target1;
};

void frag_main() {
  uint _63 = uint(int(gl_FragCoord.x));
  uint _64 = uint(int(gl_FragCoord.y));
  float _65 = float(int(_63));
  float _66 = float(int(_64));
  float _67 = _65 + 0.5f;
  float _69 = _66 + 0.5f;
  float _76 = _67 * _37_m0[10u].z;
  float _77 = _69 * _37_m0[10u].w;
  float _91 = (_37_m0[14u].x * _37_m0[10u].x) * ((_76 * 2.0f) + (-1.0f));
  float _93 = (_37_m0[14u].x * _37_m0[10u].y) * ((_77 * 2.0f) + (-1.0f));
  float _108 = exp2(log2(max(dot(float2(_91, _93), float2(_91, _93)) - _37_m0[7u].w, 0.0f)) * _37_m0[7u].z);
  float _113 = (_108 * _91) * _37_m0[7u].x;
  float _114 = (_108 * _93) * _37_m0[7u].y;
  float3 _125 = _12.Load(int4(uint3(_63 & 63u, _64 & 63u, asuint(_27_m0[28u]).y & 63u), 0u));
  float _128 = _125.x;
  float _132 = _77 - (_128 * _114);
  float _139 = (_76 - (_128 * _113)) - (_37_m0[8u].w * 2.5f);
  float3 _146 = _16.Sample(_40, float2(_76 - (_113 * 2.5f), _77 - (_114 * 2.5f)));
  float _158 = _132 - _114;
  float _162 = _37_m0[8u].w + (_139 - _113);
  float3 _163 = _15.Sample(_40, float2(_162, _158));
  float _176 = _158 - _114;
  float _177 = _37_m0[8u].w + (_162 - _113);
  float3 _178 = _15.Sample(_40, float2(_177, _176));
  float _190 = _176 - _114;
  float _191 = _37_m0[8u].w + (_177 - _113);
  float3 _192 = _15.Sample(_40, float2(_191, _190));
  // float _241 = ((((_37_m0[0u].w * 0.625f) * ((((_178.x * 0.300000011920928955078125f) + (_163.x * 0.100000001490116119384765625f)) + (_192.x * 0.4000000059604644775390625f)) + (_15.Sample(_40, float2((_191 - _113) + _37_m0[8u].w, _190 - _114)).x * 0.800000011920928955078125f))) + (_37_m0[0u].x * _146.x)) * _37_m0[11u].w) + _37_m0[11u].x;
  // float _242 = (((_37_m0[0u].y * _146.y) + (((((_178.y * 0.5f) + (_163.y * 0.4000000059604644775390625f)) + (_192.y * 0.20000000298023223876953125f)) * 0.90909087657928466796875f) * _37_m0[0u].w)) * _37_m0[11u].w) + _37_m0[11u].y;
  // float _243 = (((_37_m0[0u].z * _146.z) + (((((_163.z * 0.300000011920928955078125f) + (_15.Sample(_40, float2(_139, _132)).z * 0.89999997615814208984375f)) + (_178.z * 0.100000001490116119384765625f)) * 0.76923072338104248046875f) * _37_m0[0u].w)) * _37_m0[11u].w) + _37_m0[11u].z;

  float _241 = ((((_37_m0[0u].w * 0.625f) * ((((_178.x * 0.300000011920928955078125f) + (_163.x * 0.100000001490116119384765625f)) + (_192.x * 0.4000000059604644775390625f)) + (_15.Sample(_40, float2((_191 - _113) + _37_m0[8u].w, _190 - _114)).x * 0.800000011920928955078125f))) + (_37_m0[0u].x * injectedData.fxBloom * _146.x)));
  float _242 = (((_37_m0[0u].y * injectedData.fxBloom * _146.y) + (((((_178.y * 0.5f) + (_163.y * 0.4000000059604644775390625f)) + (_192.y * 0.20000000298023223876953125f)) * 0.90909087657928466796875f) * _37_m0[0u].w)));
  float _243 = (((_37_m0[0u].z * injectedData.fxBloom * _146.z) + (((((_163.z * 0.300000011920928955078125f) + (_15.Sample(_40, float2(_139, _132)).z * 0.89999997615814208984375f)) + (_178.z * 0.100000001490116119384765625f)) * 0.76923072338104248046875f) * _37_m0[0u].w)));

  // Custom: global_gain and global_lift
  composite2_global(_37_m0[11u], _241, _242, _243);

  float _260 = (_37_m0[14u].x * _37_m0[10u].x) * (((_67 * 2.0f) * _37_m0[10u].z) + (-1.0f));
  float _262 = (_37_m0[14u].x * _37_m0[10u].y) * (((_69 * 2.0f) * _37_m0[10u].w) + (-1.0f));
  float _294;
  float _295;
  float _296;
  if (_37_m0[9u].x > 0.0f) {
    float _281 = exp2((-0.0f) - (_37_m0[9u].y * log2(abs((dot(float2(_260, _262), float2(_260, _262)) * _37_m0[9u].x) + 1.0f))));
    _294 = ((_241 - _37_m0[8u].x) * _281) + _37_m0[8u].x;
    _295 = ((_242 - _37_m0[8u].y) * _281) + _37_m0[8u].y;
    _296 = ((_243 - _37_m0[8u].z) * _281) + _37_m0[8u].z;
  } else {
    _294 = _241;
    _295 = _242;
    _296 = _243;
  }

  // Custom: Lerp vignette
  composite2_vignette(_241, _242, _243, _294, _295, _296);

  float _526;
  float _527;
  float _528;
  uint _321;
  float _333;
  float _334;
  float _336;
  float _338;
  float _447;
  float _448;
  float _449;
  float _461;
  float _462;
  float _463;
  float _471;
  float _472;
  float _473;
  uint _480;
  bool _481;
  for (;;) {
    _321 = 1u << (_8.Load(int3(uint2(uint(_32_m0[79u].x * _65), uint(_32_m0[79u].y * _66)), 0u)).y & 31u);
    _333 = frac(_65 * 0.103100001811981201171875f);
    _334 = frac(_66 * 0.10300000011920928955078125f);
    float _335 = frac(float(asuint(_27_m0[28u]).y) * 0.097300000488758087158203125f);
    _336 = _334 + 33.3300018310546875f;
    _338 = _333 + 33.3300018310546875f;
    float _340 = dot(float3(_333, _334, _335), float3(_336, _338, _335 + 33.3300018310546875f));
    float _344 = _340 + _333;
    float _345 = _340 + _334;
    float _347 = _344 + _345;
    float _355 = frac(_347 * (_340 + _335)) + (-0.5f);
    float _357 = frac((_344 * 2.0f) * _345) + (-0.5f);
    float _358 = frac(_347 * _344) + (-0.5f);
    uint4 _371 = asuint(_37_m0[13u]);
    float _375 = float(min((_371.x & _321), 1u));
    float _396 = float(min((_371.y & _321), 1u));
    float _418 = float(min((_371.z & _321), 1u));
    float _440 = float(min((_371.w & _321), 1u));
    _447 = (((((_294 * SYS_TEXCOORD.x) * _37_m0[1u].y) * (((_37_m0[2u].x * _355) * _375) + 1.0f)) * (((_37_m0[3u].x * _355) * _396) + 1.0f)) * (((_37_m0[4u].x * _355) * _418) + 1.0f)) * (((_37_m0[5u].x * _355) * _440) + 1.0f);
    _448 = (((((_295 * SYS_TEXCOORD.x) * _37_m0[1u].y) * (((_37_m0[2u].y * _357) * _375) + 1.0f)) * (((_37_m0[3u].y * _357) * _396) + 1.0f)) * (((_37_m0[4u].y * _357) * _418) + 1.0f)) * (((_37_m0[5u].y * _357) * _440) + 1.0f);
    _449 = (((((_296 * SYS_TEXCOORD.x) * _37_m0[1u].y) * (((_37_m0[2u].z * _358) * _375) + 1.0f)) * (((_37_m0[3u].z * _358) * _396) + 1.0f)) * (((_37_m0[4u].z * _358) * _418) + 1.0f)) * (((_37_m0[5u].z * _358) * _440) + 1.0f);

    composite2_sample(_21, _40,
                      _37_m0[6u], _37_m0[12u], _321,
                      _447, _448, _449,
                      _526, _527, _528);
    // Custom: PQ Sampling
    /*
    _461 = (_37_m0[6u].x * log2(_447)) + _37_m0[6u].y;
    _462 = (_37_m0[6u].x * log2(_448)) + _37_m0[6u].y;
    _463 = (_37_m0[6u].x * log2(_449)) + _37_m0[6u].y;
    float3 _469 = _21[4u].SampleLevel(_40, float3(_461, _462, _463), 0.0f);
    _471 = _469.x;
    _472 = _469.y;
    _473 = _469.z;
    _480 = min((asuint(_37_m0[12u]).x & _321), 1u);
    _481 = _480 == 0u;
    uint _497;
    float _499;
    float _501;
    float _503;
    if (_481) {
      float3 _485 = _21[5u].SampleLevel(_40, float3(_461, _462, _463), 0.0f);
      uint _495 = min((asuint(_37_m0[12u]).y & _321), 1u);
      uint frontier_phi_4_3_ladder;
      float frontier_phi_4_3_ladder_1;
      float frontier_phi_4_3_ladder_2;
      float frontier_phi_4_3_ladder_3;
      if (_495 == 0u) {
        float3 _518 = _21[6u].SampleLevel(_40, float3(_461, _462, _463), 0.0f);
        uint _498 = min((asuint(_37_m0[12u]).z & _321), 1u);
        if (_498 == 0u) {
          _526 = _447;
          _527 = _448;
          _528 = _449;
          break;
        }
        frontier_phi_4_3_ladder = _498;
        frontier_phi_4_3_ladder_1 = _518.z;
        frontier_phi_4_3_ladder_2 = _518.y;
        frontier_phi_4_3_ladder_3 = _518.x;
      } else {
        frontier_phi_4_3_ladder = _495;
        frontier_phi_4_3_ladder_1 = _485.z;
        frontier_phi_4_3_ladder_2 = _485.y;
        frontier_phi_4_3_ladder_3 = _485.x;
      }
      _497 = frontier_phi_4_3_ladder;
      _499 = frontier_phi_4_3_ladder_1;
      _501 = frontier_phi_4_3_ladder_2;
      _503 = frontier_phi_4_3_ladder_3;
    } else {
      _497 = _480;
      _499 = _473;
      _501 = _472;
      _503 = _471;
    }
    float _505 = float(_497);
    _526 = ((_503 - _447) * _505) + _447;
    _527 = ((_501 - _448) * _505) + _448;
    _528 = ((_499 - _449) * _505) + _449;
    */
    break;
  }
  float _761;
  float _762;
  float _763;
  float _559;
  float _560;
  float _561;
  uint _578;
  float _688;
  float _689;
  float _690;
  float _701;
  float _702;
  float _703;
  float _707;
  float _708;
  float _709;
  uint _715;
  bool _716;
  for (;;) {
    float _529 = dot(float3(_526, _527, _528), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _541 = max(9.9999997473787516355514526367188e-05f, dot(float3(_447, _448, _449), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
    _559 = ((_37_m0[1u].w * (((_529 * _447) / _541) - _526)) + _526) * _37_m0[1u].z;
    _560 = ((_37_m0[1u].w * (((_529 * _448) / _541) - _527)) + _527) * _37_m0[1u].z;
    _561 = ((_37_m0[1u].w * (((_529 * _449) / _541) - _528)) + _528) * _37_m0[1u].z;
    _578 = 1u << (_8.Load(int3(uint2(uint(_32_m0[79u].x * _65), uint(_32_m0[79u].y * _66)), 0u)).y & 31u);
    float _585 = frac(float(asuint(_27_m0[28u]).y) * 0.097300000488758087158203125f);
    float _587 = dot(float3(_333, _334, _585), float3(_336, _338, _585 + 33.3300018310546875f));
    float _590 = _587 + _333;
    float _591 = _587 + _334;
    float _593 = _590 + _591;
    float _601 = frac(_593 * (_587 + _585)) + (-0.5f);
    float _602 = frac((_590 * 2.0f) * _591) + (-0.5f);
    float _603 = frac(_593 * _590) + (-0.5f);
    uint4 _614 = asuint(_37_m0[13u]);
    float _618 = float(min((_614.x & _578), 1u));
    float _639 = float(min((_614.y & _578), 1u));
    float _660 = float(min((_614.z & _578), 1u));
    float _681 = float(min((_614.w & _578), 1u));
    _688 = ((((_37_m0[1u].y * _241) * (((_37_m0[2u].x * _601) * _618) + 1.0f)) * (((_37_m0[3u].x * _601) * _639) + 1.0f)) * (((_37_m0[4u].x * _601) * _660) + 1.0f)) * (((_37_m0[5u].x * _601) * _681) + 1.0f);
    _689 = ((((_37_m0[1u].y * _242) * (((_37_m0[2u].y * _602) * _618) + 1.0f)) * (((_37_m0[3u].y * _602) * _639) + 1.0f)) * (((_37_m0[4u].y * _602) * _660) + 1.0f)) * (((_37_m0[5u].y * _602) * _681) + 1.0f);
    _690 = ((((_37_m0[1u].y * _243) * (((_37_m0[2u].z * _603) * _618) + 1.0f)) * (((_37_m0[3u].z * _603) * _639) + 1.0f)) * (((_37_m0[4u].z * _603) * _660) + 1.0f)) * (((_37_m0[5u].z * _603) * _681) + 1.0f);

    composite2_sample(_21, _40,
                      _37_m0[6u], _37_m0[12u], _578,
                      _688, _689, _690,
                      _761, _762, _763);
    // Custom
    /*
    _701 = (_37_m0[6u].x * log2(_688)) + _37_m0[6u].y;
    _702 = (_37_m0[6u].x * log2(_689)) + _37_m0[6u].y;
    _703 = (_37_m0[6u].x * log2(_690)) + _37_m0[6u].y;

    float3 _705 = _21[4u].SampleLevel(_40, float3(_701, _702, _703), 0.0f);
    _707 = _705.x;
    _708 = _705.y;
    _709 = _705.z;
    _715 = min((asuint(_37_m0[12u]).x & _578), 1u);
    _716 = _715 == 0u;
    uint _732;
    float _734;
    float _736;
    float _738;
    if (_716) {
      float3 _720 = _21[5u].SampleLevel(_40, float3(_701, _702, _703), 0.0f);
      uint _730 = min((asuint(_37_m0[12u]).y & _578), 1u);
      uint frontier_phi_8_7_ladder;
      float frontier_phi_8_7_ladder_1;
      float frontier_phi_8_7_ladder_2;
      float frontier_phi_8_7_ladder_3;
      if (_730 == 0u) {
        float3 _753 = _21[6u].SampleLevel(_40, float3(_701, _702, _703), 0.0f);
        uint _733 = min((asuint(_37_m0[12u]).z & _578), 1u);
        if (_733 == 0u) {
          _761 = _688;
          _762 = _689;
          _763 = _690;
          break;
        }
        frontier_phi_8_7_ladder = _733;
        frontier_phi_8_7_ladder_1 = _753.z;
        frontier_phi_8_7_ladder_2 = _753.y;
        frontier_phi_8_7_ladder_3 = _753.x;
      } else {
        frontier_phi_8_7_ladder = _730;
        frontier_phi_8_7_ladder_1 = _720.z;
        frontier_phi_8_7_ladder_2 = _720.y;
        frontier_phi_8_7_ladder_3 = _720.x;
      }
      _732 = frontier_phi_8_7_ladder;
      _734 = frontier_phi_8_7_ladder_1;
      _736 = frontier_phi_8_7_ladder_2;
      _738 = frontier_phi_8_7_ladder_3;
    } else {
      _732 = _715;
      _734 = _709;
      _736 = _708;
      _738 = _707;
    }
    float _740 = float(_732);
    _761 = ((_738 - _688) * _740) + _688;
    _762 = ((_736 - _689) * _740) + _689;
    _763 = ((_734 - _690) * _740) + _690;
    */
    break;
  }
  float _764 = dot(float3(_761, _762, _763), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _773 = max(9.9999997473787516355514526367188e-05f, dot(float3(_688, _689, _690), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
  float _790 = ((_37_m0[1u].w * (((_764 * _688) / _773) - _761)) + _761) * _37_m0[1u].z;
  float _791 = ((_37_m0[1u].w * (((_764 * _689) / _773) - _762)) + _762) * _37_m0[1u].z;
  float _792 = ((_37_m0[1u].w * (((_764 * _690) / _773) - _763)) + _763) * _37_m0[1u].z;
  SV_Target.x = asfloat(asuint(_790) + 65536u);
  SV_Target.y = asfloat(asuint(_791) + 65536u);
  SV_Target.z = asfloat(asuint(_792) + 131072u);
  SV_Target.w = 1.0f;
  SV_Target_1.x = asfloat(asuint(_790 - _559) + 65536u);
  SV_Target_1.y = asfloat(asuint(_791 - _560) + 65536u);
  SV_Target_1.z = asfloat(asuint(_792 - _561) + 131072u);
  SV_Target_1.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
