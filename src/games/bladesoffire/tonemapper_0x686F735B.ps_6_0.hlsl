#include "./shared.h"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t4 : register(t4);

cbuffer cb0 : register(b0) {
  float cb0_000z : packoffset(c000.z);
  float cb0_000w : packoffset(c000.w);
  float cb0_002x : packoffset(c002.x);
  float cb0_003x : packoffset(c003.x);
  float cb0_004x : packoffset(c004.x);
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_006x : packoffset(c006.x);
  float cb0_007x : packoffset(c007.x);
  float cb0_007y : packoffset(c007.y);
  float cb0_007z : packoffset(c007.z);
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_009x : packoffset(c009.x);
  float cb0_009y : packoffset(c009.y);
  float cb0_009z : packoffset(c009.z);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_012x : packoffset(c012.x);
  float cb0_012y : packoffset(c012.y);
  float cb0_013x : packoffset(c013.x);
  float cb0_013y : packoffset(c013.y);
  float cb0_013z : packoffset(c013.z);
  float cb0_014x : packoffset(c014.x);
  float cb0_014y : packoffset(c014.y);
  float cb0_014z : packoffset(c014.z);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_017x : packoffset(c017.x);
  float cb0_017y : packoffset(c017.y);
  float cb0_017z : packoffset(c017.z);
  float cb0_018x : packoffset(c018.x);
  float cb0_018y : packoffset(c018.y);
  float cb0_018z : packoffset(c018.z);
  float cb0_019x : packoffset(c019.x);
  float cb0_019y : packoffset(c019.y);
  float cb0_019z : packoffset(c019.z);
  float cb0_020x : packoffset(c020.x);
  float cb0_020y : packoffset(c020.y);
  float cb0_020z : packoffset(c020.z);
  float cb0_021x : packoffset(c021.x);
  float cb0_021y : packoffset(c021.y);
  float cb0_021z : packoffset(c021.z);
  float cb0_022x : packoffset(c022.x);
  float cb0_022y : packoffset(c022.y);
  float cb0_022z : packoffset(c022.z);
  float cb0_023x : packoffset(c023.x);
  float cb0_023y : packoffset(c023.y);
  float cb0_023z : packoffset(c023.z);
  float cb0_024x : packoffset(c024.x);
  float cb0_024y : packoffset(c024.y);
  float cb0_024z : packoffset(c024.z);
  float cb0_025x : packoffset(c025.x);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_026x : packoffset(c026.x);
  float cb0_026y : packoffset(c026.y);
  float cb0_026z : packoffset(c026.z);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_028z : packoffset(c028.z);
  float cb0_028w : packoffset(c028.w);
  float cb0_029x : packoffset(c029.x);
  float cb0_029y : packoffset(c029.y);
  float cb0_029z : packoffset(c029.z);
  float cb0_029w : packoffset(c029.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s8 : register(s8);

SamplerState s4 : register(s4);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _19 = cb0_000z * SV_Position.x;
  float _20 = cb0_000w * SV_Position.y;
  float4 _21 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));  // Game before exposure
  float4 _32 = t1.Sample(s1, float2(0.5f, 0.5f));              // Luminance? (Just orange)
  float4 _37 = t2.Sample(s2, float2(TEXCOORD.x, TEXCOORD.y));  // Bloom
  float4 _44 = t8.Sample(s8, float2(_19, _20));                // flare or whatever

  float exposure = cb0_002x;
  // Add bloom and stuff
  // cb0_002x is exposure
  float _56 = (_37.x + ((cb0_002x * _21.x) * _32.x)) + ((_44.x * _37.x) * cb0_004x);
  float _57 = (_37.y + ((cb0_002x * _21.y) * _32.x)) + ((_44.y * _37.y) * cb0_004x);
  float _58 = (_37.z + ((cb0_002x * _21.z) * _32.x)) + ((_44.z * _37.z) * cb0_004x);

  float3 ungradedAP1 = float3(_56, _57, _58);

  // NTSC1953 dot
  // float _79 = dot(float3(_56, _57, _58), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _79 = renodx::color::y::from::AP1(float3(_56, _57, _58));
  // Color correction stuff
  // lerp is grayscale -> color
  // cb0_007.rgb is saturation
  // cb0_008.rgb is contrast
  // cb0_009.rgb is shadows
  // cb0_010.rgb is midtones
  // cb0_011.rgb is black floor

  float _122 = max(
      0.0f,
      (
          (exp2(log2(
                    exp2(log2(max(0.0f, (lerp(_79, _56, cb0_007x))) * 5.55555534362793f) * cb0_008x)
                    * 0.18000000715255737f)
                * cb0_009x)
           * cb0_010x)
          + cb0_011x));
  float _123 = max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, (lerp(_79, _57, cb0_007y))) * 5.55555534362793f) * cb0_008y) * 0.18000000715255737f) * cb0_009y) * cb0_010y) + cb0_011y));
  float _124 = max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, (lerp(_79, _58, cb0_007z))) * 5.55555534362793f) * cb0_008z) * 0.18000000715255737f) * cb0_009z) * cb0_010z) + cb0_011z));

  // float _125 = dot(float3(_122, _123, _124), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  float _125 = renodx::color::y::from::AP1(float3(_122, _123, _124));

  float _146 = _122 - _125;
  float _147 = _123 - _125;
  float _148 = _124 - _125;
  float _194 = saturate(_125 / cb0_012x);
  float _198 = (_194 * _194) * (3.0f - (_194 * 2.0f));
  float _199 = 1.0f - _198;
  float _266 = saturate((_125 - cb0_012y) / (1.0f - cb0_012y));
  float _270 = (_266 * _266) * (3.0f - (_266 * 2.0f));
  float _333 = _198 - _270;

  // cb0_02x are highlights
  // cb0_01x are shadows

  float _344 = ((_270 * max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_146 * cb0_023x) + _125)) * 5.55555534362793f) * cb0_024x) * 0.18000000715255737f) * cb0_025x) * cb0_026x) + cb0_027x)))
                + (_199 * max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_146 * cb0_013x) + _125)) * 5.55555534362793f) * cb0_014x) * 0.18000000715255737f) * cb0_015x) * cb0_016x) + cb0_017x))))
               + (max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_146 * cb0_018x) + _125)) * 5.55555534362793f) * cb0_019x) * 0.18000000715255737f) * cb0_020x) * cb0_021x) + cb0_022x)) * _333);
  float _346 = ((_270 * max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_147 * cb0_023y) + _125)) * 5.55555534362793f) * cb0_024y) * 0.18000000715255737f) * cb0_025y) * cb0_026y) + cb0_027y)))
                + (_199 * max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_147 * cb0_013y) + _125)) * 5.55555534362793f) * cb0_014y) * 0.18000000715255737f) * cb0_015y) * cb0_016y) + cb0_017y))))
               + (max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_147 * cb0_018y) + _125)) * 5.55555534362793f) * cb0_019y) * 0.18000000715255737f) * cb0_020y) * cb0_021y) + cb0_022y)) * _333);
  float _348 = ((_270 * max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_148 * cb0_023z) + _125)) * 5.55555534362793f) * cb0_024z) * 0.18000000715255737f) * cb0_025z) * cb0_026z) + cb0_027z)))
                + (_199 * max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_148 * cb0_013z) + _125)) * 5.55555534362793f) * cb0_014z) * 0.18000000715255737f) * cb0_015z) * cb0_016z) + cb0_017z))))
               + (max(0.0f, ((exp2(log2(exp2(log2(max(0.0f, ((_148 * cb0_018z) + _125)) * 5.55555534362793f) * cb0_019z) * 0.18000000715255737f) * cb0_020z) * cb0_021z) + cb0_022z)) * _333);

  // Noise
  float _361 = ((cb0_005y + cb0_005y) * frac(sin((cb0_005x + TEXCOORD.x) + ((cb0_005x + TEXCOORD.y) * 543.3099975585938f)) * 493013.0f)) - cb0_005y;
  float _369 = (_361 + 1.0f) + (((_361 * cb0_005z) - _361) * saturate(dot(float3(_344, _346, _348), float3(0.30000001192092896f, 0.30000001192092896f, 0.30000001192092896f))));

  float4 _373 = t4.Sample(s4, float2(_19, _20));  // Pink stuff
  float _379 = 1.0f - saturate(cb0_006x * _373.y);
  float _380 = (_369 * _344) * _379;
  float _381 = (_369 * _346) * _379;
  float _382 = (_369 * _348) * _379;
  float3 untonemappedAP1 = float3(_380, _381, _382);

  float _450;
  float _483;
  float _497;
  float _554;
  float _695;
  float _696;
  float _697;

  // Tonemapping
  if (cb0_028w > 0.0f) {
    // Goes in here
    // Reference lutbuilder_0x4A0DBF57.ps_6_6
    // AP1_2_AP0_MAT
    float _394 = mad(0.16386905312538147f, _382, mad(0.14067868888378143f, _381, (_380 * 0.6954522132873535f)));
    float _397 = mad(0.0955343246459961f, _382, mad(0.8596711158752441f, _381, (_380 * 0.044794581830501556f)));
    float _400 = mad(1.0015007257461548f, _382, mad(0.004025210160762072f, _381, (_380 * -0.005525882821530104f)));
    float _404 = max(max(_394, _397), _400);
    float _409 = (max(_404, 1.000000013351432e-10f) - max(min(min(_394, _397), _400), 1.000000013351432e-10f)) / max(_404, 0.009999999776482582f);
    float _423 = ((_397 + _394) + _400) + (sqrt(max(((((_400 - _397) * _400) + ((_397 - _394) * _397)) + ((_394 - _400) * _394)), 0.0f)) * 1.75f);
    float _424 = _423 * 0.3333333432674408f;
    float _425 = _409 + -0.4000000059604645f;
    float _426 = _425 * 5.0f;
    float _430 = max((1.0f - abs(_425 * 2.5f)), 0.0f);
    float _441 = ((float(((int)(uint)((bool)(_426 > 0.0f))) - ((int)(uint)((bool)(_426 < 0.0f)))) * (1.0f - (_430 * _430))) + 1.0f) * 0.02500000037252903f;
    if (!(_424 <= 0.0533333346247673f)) {
      if (!(_424 >= 0.1599999964237213f)) {
        _450 = (((0.23999999463558197f / _423) + -0.5f) * _441);
      } else {
        _450 = 0.0f;
      }
    } else {
      _450 = _441;
    }
    float _451 = _450 + 1.0f;
    float _452 = _451 * _394;
    float _453 = _451 * _397;
    float _454 = _451 * _400;
    if (!((bool)(_452 == _453) && (bool)(_453 == _454))) {
      float _461 = ((_452 * 2.0f) - _453) - _454;
      float _464 = ((_397 - _400) * 1.7320507764816284f) * _451;
      float _466 = atan(_464 / _461);
      bool _469 = (_461 < 0.0f);
      bool _470 = (_461 == 0.0f);
      bool _471 = (_464 >= 0.0f);
      bool _472 = (_464 < 0.0f);
      _483 = select((_471 && _470), 90.0f, select((_472 && _470), -90.0f, (select((_472 && _469), (_466 + -3.1415927410125732f), select((_471 && _469), (_466 + 3.1415927410125732f), _466)) * 57.295780181884766f)));
    } else {
      _483 = 0.0f;
    }
    float _488 = min(max(select((_483 < 0.0f), (_483 + 360.0f), _483), 0.0f), 360.0f);
    if (_488 < -180.0f) {
      _497 = (_488 + 360.0f);
    } else {
      if (_488 > 180.0f) {
        _497 = (_488 + -360.0f);
      } else {
        _497 = _488;
      }
    }
    float _501 = saturate(1.0f - abs(_497 * 0.014814814552664757f));
    float _505 = (_501 * _501) * (3.0f - (_501 * 2.0f));
    float _511 = ((_505 * _505) * ((_409 * 0.18000000715255737f) * (0.029999999329447746f - _452))) + _452;
    // ACES_to_ACEScg
    float _521 = max(0.0f, mad(-0.21492856740951538f, _454, mad(-0.2365107536315918f, _453, (_511 * 1.4514392614364624f))));
    float _522 = max(0.0f, mad(-0.09967592358589172f, _454, mad(1.17622971534729f, _453, (_511 * -0.07655377686023712f))));
    float _523 = max(0.0f, mad(0.9977163076400757f, _454, mad(-0.006032449658960104f, _453, (_511 * 0.008316148072481155f))));
    // AP1 luminance
    float _524 = dot(float3(_521, _522, _523), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

    /*
      Begin Film adjustments (FilmBlackClip, Toe and such)
    */

    float _534 = 1.0f - cb0_029x;
    float _535 = _534 + cb0_029z;
    float _537 = (1.0f - cb0_029y) + cb0_029w;
    if (cb0_029x > 0.800000011920929f) {
      _554 = (((0.8199999928474426f - cb0_029x) / cb0_028w) + -0.7447274923324585f);
    } else {
      float _545 = (cb0_029z + 0.18000000715255737f) / _535;
      _554 = (-0.7447274923324585f - ((log2(_545 / (2.0f - _545)) * 0.3465735912322998f) * (_535 / cb0_028w)));
    }
    float _556 = (_534 / cb0_028w) - _554;
    float _558 = (cb0_029y / cb0_028w) - _556;
    // const float RRT_SAT_FACTOR = 0.96f;
    float _562 = log2(lerp(_524, _521, 0.9599999785423279f)) * 0.3010300099849701f;
    float _563 = log2(lerp(_524, _522, 0.9599999785423279f)) * 0.3010300099849701f;
    float _564 = log2(lerp(_524, _523, 0.9599999785423279f)) * 0.3010300099849701f;

    float _568 = (_562 + _556) * cb0_028w;
    float _569 = (_563 + _556) * cb0_028w;
    float _570 = (_564 + _556) * cb0_028w;
    float _571 = _535 * 2.0f;
    float _573 = (cb0_028w * -2.0f) / _535;
    float _574 = _562 - _554;
    float _575 = _563 - _554;
    float _576 = _564 - _554;
    float _595 = cb0_029w + 1.0f;
    float _596 = _537 * 2.0f;
    float _598 = (cb0_028w * 2.0f) / _537;
    float _621 = select((_562 < _554), ((_571 / (exp2((_574 * 1.4426950216293335f) * _573) + 1.0f)) - cb0_029z), _568);
    float _623 = select((_563 < _554), ((_571 / (exp2((_575 * 1.4426950216293335f) * _573) + 1.0f)) - cb0_029z), _569);
    float _625 = select((_564 < _554), ((_571 / (exp2((_573 * 1.4426950216293335f) * _576) + 1.0f)) - cb0_029z), _570);
    float _632 = _558 - _554;
    float _636 = saturate(_574 / _632);
    float _637 = saturate(_575 / _632);
    float _638 = saturate(_576 / _632);
    bool _639 = (_558 < _554);
    float _643 = select(_639, (1.0f - _636), _636);
    float _644 = select(_639, (1.0f - _637), _637);
    float _645 = select(_639, (1.0f - _638), _638);
    float _664 = (((_643 * _643) * (select((_562 > _558), (_595 - (_596 / (exp2(((_562 - _558) * 1.4426950216293335f) * _598) + 1.0f))), _568) - _621)) * (3.0f - (_643 * 2.0f))) + _621;
    float _665 = (((_644 * _644) * (select((_563 > _558), (_595 - (_596 / (exp2(((_563 - _558) * 1.4426950216293335f) * _598) + 1.0f))), _569) - _623)) * (3.0f - (_644 * 2.0f))) + _623;
    float _666 = (((_645 * _645) * (select((_564 > _558), (_595 - (_596 / (exp2(((_564 - _558) * 1.4426950216293335f) * _598) + 1.0f))), _570) - _625)) * (3.0f - (_645 * 2.0f))) + _625;
    float _667 = dot(float3(_664, _665, _666), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
    _695 = max(0.0f, (lerp(_667, _664, 0.9300000071525574f)));
    _696 = max(0.0f, (lerp(_667, _665, 0.9300000071525574f)));
    _697 = max(0.0f, (lerp(_667, _666, 0.9300000071525574f)));
    // End film stuff
    // They don't use bluecorrection
  } else {
    // Old tonemaper, Reinhard maybe idk
    _695 = (cb0_028z * (1.0f - exp2(-0.0f - _380)));
    _696 = (cb0_028z * (1.0f - exp2(-0.0f - _381)));
    _697 = (cb0_028z * (1.0f - exp2(-0.0f - _382)));
  }
  SV_Target.x = saturate(cb0_003x * sqrt(_695));
  SV_Target.y = saturate(cb0_003x * sqrt(_696));
  SV_Target.z = saturate(cb0_003x * sqrt(_697));

  if (RENODX_TONE_MAP_TYPE) {
    float3 output = float3(_695, _696, _697);

    untonemappedAP1 = renodx::color::bt709::from::AP1(untonemappedAP1);

    output = renodx::color::bt709::from::AP1(output);

    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.peak_white_nits = 10000.f;
    SV_Target.rgb = renodx::draw::ToneMapPass(untonemappedAP1.rgb, saturate(output.rgb), config);
    SV_Target.rgb = renodx::color::ap1::from::BT709(SV_Target.rgb);

    SV_Target.rgb = renodx::color::gamma::EncodeSafe(SV_Target.rgb, 2.0f);
    SV_Target.rgb *= cb0_003x;
  }
  SV_Target.w = (cb0_002x * _21.w);
  return SV_Target;
}
