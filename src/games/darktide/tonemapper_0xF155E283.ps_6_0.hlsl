#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture3D<float4> t2 : register(t2);

Texture2D<float> current_exposure : register(t3);

Texture2D<float4> t4 : register(t4);

cbuffer global_viewport : register(b0) {
  float global_viewport_001x : packoffset(c001.x);
  float global_viewport_001y : packoffset(c001.y);
  float global_viewport_001z : packoffset(c001.z);
  float global_viewport_010y : packoffset(c010.y);
  float global_viewport_011y : packoffset(c011.y);
  float global_viewport_012y : packoffset(c012.y);
  float global_viewport_074x : packoffset(c074.x);
  float global_viewport_074y : packoffset(c074.y);
  float global_viewport_074z : packoffset(c074.z);
  float global_viewport_074w : packoffset(c074.w);
  float global_viewport_075x : packoffset(c075.x);
  float global_viewport_075y : packoffset(c075.y);
  float global_viewport_075z : packoffset(c075.z);
  float global_viewport_075w : packoffset(c075.w);
  float global_viewport_077x : packoffset(c077.x);
  float global_viewport_077y : packoffset(c077.y);
  float global_viewport_077z : packoffset(c077.z);
  float global_viewport_077w : packoffset(c077.w);
  float global_viewport_078x : packoffset(c078.x);
  float global_viewport_078y : packoffset(c078.y);
  float global_viewport_078z : packoffset(c078.z);
  float global_viewport_078w : packoffset(c078.w);
  float global_viewport_079x : packoffset(c079.x);
  float global_viewport_079y : packoffset(c079.y);
  float global_viewport_079z : packoffset(c079.z);
  float global_viewport_079w : packoffset(c079.w);
  float global_viewport_081x : packoffset(c081.x);
  float global_viewport_081y : packoffset(c081.y);
  float global_viewport_081z : packoffset(c081.z);
  float global_viewport_081w : packoffset(c081.w);
};

cbuffer global_environment_settings : register(b1) {
  float global_environment_settings_021w : packoffset(c021.w);
  float global_environment_settings_022x : packoffset(c022.x);
  float global_environment_settings_022y : packoffset(c022.y);
  float global_environment_settings_022z : packoffset(c022.z);
  float global_environment_settings_022w : packoffset(c022.w);
  float global_environment_settings_023x : packoffset(c023.x);
};

cbuffer c0 : register(b2) {
  float c0_004y : packoffset(c004.y);
  float c0_005x : packoffset(c005.x);
  float c0_005y : packoffset(c005.y);
  float c0_005z : packoffset(c005.z);
  float c0_006x : packoffset(c006.x);
  float c0_006y : packoffset(c006.y);
  float c0_006z : packoffset(c006.z);
  float c0_007x : packoffset(c007.x);
  float c0_007y : packoffset(c007.y);
  float c0_007z : packoffset(c007.z);
  float c0_008y : packoffset(c008.y);
  float c0_008z : packoffset(c008.z);
  float c0_008w : packoffset(c008.w);
  float c0_009x : packoffset(c009.x);
  float c0_009y : packoffset(c009.y);
  float c0_009z : packoffset(c009.z);
  float c0_010x : packoffset(c010.x);
  float c0_010y : packoffset(c010.y);
  float c0_010z : packoffset(c010.z);
  float c0_011x : packoffset(c011.x);
  float c0_011y : packoffset(c011.y);
  uint c0_012x : packoffset(c012.x);
  uint c0_012y : packoffset(c012.y);
  uint c0_012z : packoffset(c012.z);
  uint c0_012w : packoffset(c012.w);
  uint c0_013x : packoffset(c013.x);
  uint c0_013y : packoffset(c013.y);
  uint c0_013z : packoffset(c013.z);
  uint c0_013w : packoffset(c013.w);
  uint c0_014x : packoffset(c014.x);
  uint c0_014y : packoffset(c014.y);
  uint c0_014z : packoffset(c014.z);
  uint c0_014w : packoffset(c014.w);
  uint c0_015x : packoffset(c015.x);
  uint c0_015y : packoffset(c015.y);
  uint c0_015z : packoffset(c015.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float3 final_image;
  float4 _15 = t0.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)));  // BT709 before exposure, I think

  float _22 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_15.x);
  float _23 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_15.y);
  float _24 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_15.z);
  float3 untonemapped_bt709 = float3(_22, _23, _24);  // After exposure
  float _285 = _22;
  float _286 = _23;
  float _287 = _24;
  float _604;
  float _637;
  float _651;
  float _708;
  float _863;
  float _864;
  float _865;
  float _939;
  float _940;
  float _941;
  float _968;
  float _969;
  float _970;
  if ((!((c0_007x) == 0.0f))) {
    // Not here
    int _31 = asint((((float4)(t4.Sample(s3, float2((TEXCOORD.x), (TEXCOORD.y))))).x));
    float _33 = asfloat((_31 & 2147483647));
    bool _37 = (((uint)(uint((float((uint)((int)((uint)(_31) >> 31))))))) == 0);
    float _49 = (_37 ? (TEXCOORD_1.w) : (TEXCOORD_1.w));
    float _76 = ((global_viewport_001x) + ((((_37 ? (TEXCOORD_1.x) : (TEXCOORD_1.x))) / _49) * _33)) - (((global_viewport_010y)*_33) * (c0_007z));
    float _77 = ((global_viewport_001y) + ((((_37 ? (TEXCOORD_1.y) : (TEXCOORD_1.y))) / _49) * _33)) - (((global_viewport_011y)*_33) * (c0_007z));
    float _78 = ((global_viewport_001z) + ((((_37 ? (TEXCOORD_1.z) : (TEXCOORD_1.z))) / _49) * _33)) - (((global_viewport_012y)*_33) * (c0_007z));
    float _132 = (mad(_78, ((_37 ? (global_viewport_077z) : (global_viewport_081z))), (mad(_77, ((_37 ? (global_viewport_077y) : (global_viewport_081y))), (((_37 ? (global_viewport_077x) : (global_viewport_081x))) * _76))))) + ((_37 ? (global_viewport_077w) : (global_viewport_081w)));
    float _135 = (((mad(_78, ((_37 ? (global_viewport_074z) : (global_viewport_078z))), (mad(_77, ((_37 ? (global_viewport_074y) : (global_viewport_078y))), (((_37 ? (global_viewport_074x) : (global_viewport_078x))) * _76))))) + ((_37 ? (global_viewport_074w) : (global_viewport_078w)))) / _132) * 0.5f;
    float _136 = (((mad(_78, ((_37 ? (global_viewport_075z) : (global_viewport_079z))), (mad(_77, ((_37 ? (global_viewport_075y) : (global_viewport_079y))), (((_37 ? (global_viewport_075x) : (global_viewport_079x))) * _76))))) + ((_37 ? (global_viewport_075w) : (global_viewport_079w)))) / _132) * -0.5f;
    float _142 = (c0_011x) * (_135 + 0.5f);
    float _143 = (_136 + 0.5f) * (c0_011y);
    float _144 = 1.0f / (c0_011x);
    float _145 = 1.0f / (c0_011y);
    float _148 = floor((_142 + -0.5f));
    float _149 = floor((_143 + -0.5f));
    float _152 = _142 - (_148 + 0.5f);
    float _153 = _143 - (_149 + 0.5f);
    float _154 = _152 * _152;
    float _155 = _153 * _153;
    float _156 = _154 * _152;
    float _157 = _155 * _153;
    float _164 = (mad(_154, -1.0f, (_156 * 0.5f))) + 0.6666666865348816f;
    float _168 = _156 * 0.1666666716337204f;
    float _175 = (mad(_155, -1.0f, (_157 * 0.5f))) + 0.6666666865348816f;
    float _179 = _157 * 0.1666666716337204f;
    float _180 = ((mad(_152, -0.5f, (mad(_154, 0.5f, (_156 * -0.1666666716337204f))))) + 0.1666666716337204f) + _164;
    float _181 = ((mad(_153, -0.5f, (mad(_155, 0.5f, (_157 * -0.1666666716337204f))))) + 0.1666666716337204f) + _175;
    float _194 = ((_148 + -0.5f) + (_164 / _180)) * _144;
    float _195 = ((_149 + -0.5f) + (_175 / _181)) * _145;
    float _200 = ((_148 + 1.5f) + (_168 / ((_168 + 0.1666666716337204f) + (mad(_152, 0.5f, (mad(_154, 0.5f, (_156 * -0.5f)))))))) * _144;
    float _201 = ((_149 + 1.5f) + (_179 / ((_179 + 0.1666666716337204f) + (mad(_153, 0.5f, (mad(_155, 0.5f, (_157 * -0.5f)))))))) * _145;
    float4 _202 = t1.Sample(s1, float2(_194, _195));
    float4 _206 = t1.Sample(s1, float2(_200, _195));
    float4 _210 = t1.Sample(s1, float2(_194, _201));
    float4 _214 = t1.Sample(s1, float2(_200, _201));
    float _233 = (((_206.x) - (_214.x)) * _181) + (_214.x);
    float _234 = (((_206.y) - (_214.y)) * _181) + (_214.y);
    float _235 = (((_206.z) - (_214.z)) * _181) + (_214.z);
    float _242 = ((((((_202.x) - (_210.x)) * _181) + (_210.x)) - _233) * _180) + _233;
    float _243 = ((((((_202.y) - (_210.y)) * _181) + (_210.y)) - _234) * _180) + _234;
    float _244 = ((((((_202.z) - (_210.z)) * _181) + (_210.z)) - _235) * _180) + _235;
    // BT709 Y
    float _249 = max(((c0_004y) - (dot(float3(_242, _243, _244), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f)))), 6.0999998822808266e-05f);
    float _261 = saturate((((abs((-0.0f - _135))) + -0.5f) * -3.3333332538604736f));
    float _262 = saturate((((abs((-0.0f - _136))) + -0.5f) * -3.3333332538604736f));
    float _268 = (_261 * _261) * (3.0f - (_261 * 2.0f));
    float _270 = (_262 * _262) * (3.0f - (_262 * 2.0f));
    _285 = (((((c0_007y) * (_242 / _249)) * _268) * _270) + _22);
    _286 = (((((c0_007y) * (_243 / _249)) * _268) * _270) + _23);
    _287 = (((((c0_007y) * (_244 / _249)) * _268) * _270) + _24);
  }
  float _291 = (c0_011x) * (TEXCOORD.x);
  float _292 = (c0_011y) * (TEXCOORD.y);
  float _293 = 1.0f / (c0_011x);
  float _294 = 1.0f / (c0_011y);
  float _297 = floor((_291 + -0.5f));
  float _298 = floor((_292 + -0.5f));
  float _301 = _291 - (_297 + 0.5f);
  float _302 = _292 - (_298 + 0.5f);
  float _303 = _301 * _301;
  float _304 = _302 * _302;
  float _305 = _303 * _301;
  float _306 = _304 * _302;
  float _313 = (mad(_303, -1.0f, (_305 * 0.5f))) + 0.6666666865348816f;
  float _317 = _305 * 0.1666666716337204f;
  float _324 = (mad(_304, -1.0f, (_306 * 0.5f))) + 0.6666666865348816f;
  float _328 = _306 * 0.1666666716337204f;
  float _329 = ((mad(_301, -0.5f, (mad(_303, 0.5f, (_305 * -0.1666666716337204f))))) + 0.1666666716337204f) + _313;
  float _330 = ((mad(_302, -0.5f, (mad(_304, 0.5f, (_306 * -0.1666666716337204f))))) + 0.1666666716337204f) + _324;
  float _343 = ((_297 + -0.5f) + (_313 / _329)) * _293;
  float _344 = ((_298 + -0.5f) + (_324 / _330)) * _294;
  float _349 = ((_297 + 1.5f) + (_317 / ((_317 + 0.1666666716337204f) + (mad(_301, 0.5f, (mad(_303, 0.5f, (_305 * -0.5f)))))))) * _293;
  float _350 = ((_298 + 1.5f) + (_328 / ((_328 + 0.1666666716337204f) + (mad(_302, 0.5f, (mad(_304, 0.5f, (_306 * -0.5f)))))))) * _294;
  float4 _351 = t1.Sample(s1, float2(_343, _344));
  float4 _355 = t1.Sample(s1, float2(_349, _344));
  float4 _359 = t1.Sample(s1, float2(_343, _350));
  float4 _363 = t1.Sample(s1, float2(_349, _350));
  float _382 = (((_355.x) - (_363.x)) * _330) + (_363.x);
  float _383 = (((_355.y) - (_363.y)) * _330) + (_363.y);
  float _384 = (((_355.z) - (_363.z)) * _330) + (_363.z);
  float _391 = ((((((_351.x) - (_359.x)) * _330) + (_359.x)) - _382) * _329) + _382;
  float _392 = ((((((_351.y) - (_359.y)) * _330) + (_359.y)) - _383) * _329) + _383;
  float _393 = ((((((_351.z) - (_359.z)) * _330) + (_359.z)) - _384) * _329) + _384;
  // BT709 Y
  float _398 = max(((c0_004y) - (dot(float3(_391, _392, _393), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f)))), 6.0999998822808266e-05f);
  float _402 = (_391 / _398) + _285;
  float _403 = (_392 / _398) + _286;
  float _404 = (_393 / _398) + _287;
  _863 = _402;
  _864 = _403;
  _865 = _404;

  if ((!((c0_008y) == 0.0f))) {
    // Here
    if ((!((c0_008z) == 0.0f))) {
      // Not here
      float _412 = max(0.0f, _402);
      float _413 = max(0.0f, _403);
      float _414 = max(0.0f, _404);
      float _434 = asfloat(((uint)(c0_014y)));
      float _435 = asfloat(((uint)(c0_014z)));
      float _436 = asfloat(((uint)(c0_014w)));
      float _446 = asfloat(((uint)(c0_013z)));
      float _447 = asfloat(((uint)(c0_013w)));
      float _448 = asfloat(((uint)(c0_014x)));
      float _451 = 1.0f / (max(_412, (max(_413, _414))));
      float _457 = exp2(((log2((_451 * _412))) * (asfloat(((uint)(c0_012x))))));
      float _460 = exp2(((log2((_451 * _413))) * (asfloat(((uint)(c0_012y))))));
      float _463 = exp2(((log2((_451 * _414))) * (asfloat(((uint)(c0_012z))))));
      float _471 = exp2(((log2((((_447 * _413) + (_446 * _412)) + (_448 * _414)))) * (asfloat(((uint)(c0_012w))))));
      float _475 = (1.0f / ((_471 * (asfloat(((uint)(c0_013x))))) + (asfloat(((uint)(c0_013y)))))) * _471;
      float _483 = saturate((_475 * (1.0f / (((_460 * _447) + (_457 * _446)) + (_463 * _448)))));
      float _485 = saturate((_483 * _457));
      float _487 = saturate((_483 * _460));
      float _489 = saturate((_483 * _463));
      float _491 = _434 - (_485 * _434);
      float _493 = _435 - (_487 * _435);
      float _495 = _436 - (_489 * _436);
      float _509 = (1.0f / (((_493 * _447) + (_491 * _446)) + (_495 * _448))) * (saturate((((_475 - (_485 * _446)) - (_487 * _447)) - (_489 * _448))));
      float _512 = saturate(((_509 * _491) + _485));
      float _515 = saturate(((_509 * _493) + _487));
      float _518 = saturate(((_509 * _495) + _489));
      float _525 = saturate((((_475 - (_512 * _446)) - (_515 * _447)) - (_518 * _448)));
      _863 = (saturate(((_525 * (asfloat(((uint)(c0_015x))))) + _512)));
      _864 = (saturate(((_525 * (asfloat(((uint)(c0_015y))))) + _515)));
      _865 = (saturate(((_525 * (asfloat(((uint)(c0_015z))))) + _518)));
    } else {
      // Here
      if ((!((global_environment_settings_021w) == 0.0f))) {
        // Here
        // AP1 => AP0
        float _549 = mad(0.16386905312538147f, _404, (mad(0.14067868888378143f, _403, (_402 * 0.6954522132873535f))));
        float _552 = mad(0.0955343246459961f, _404, (mad(0.8596711158752441f, _403, (_402 * 0.044794581830501556f))));
        float _555 = mad(1.0015007257461548f, _404, (mad(0.004025210160762072f, _403, (_402 * -0.005525882821530104f))));
        float _559 = max((max(_549, _552)), _555);
        // aces::rgb_2_saturation
        float _564 = ((max(_559, 1.000000013351432e-10f)) - (max((min((min(_549, _552)), _555)), 1.000000013351432e-10f))) / (max(_559, 0.009999999776482582f));
        float _577 = ((_552 + _549) + _555) + ((sqrt(((((_555 - _552) * _555) + ((_552 - _549) * _552)) + ((_549 - _555) * _549)))) * 1.75f);
        float _578 = _577 * 0.3333333432674408f;
        float _579 = _564 + -0.4000000059604645f;
        float _580 = _579 * 5.0f;
        float _584 = max((1.0f - (abs((_579 * 2.5f)))), 0.0f);
        float _595 = (((float(((int(((bool)((_580 > 0.0f))))) - (int(((bool)((_580 < 0.0f)))))))) * (1.0f - (_584 * _584))) + 1.0f) * 0.02500000037252903f;
        _604 = _595;
        do {
          if ((!(_578 <= 0.0533333346247673f))) {
            _604 = 0.0f;
            if ((!(_578 >= 0.1599999964237213f))) {
              _604 = (((0.23999999463558197f / _577) + -0.5f) * _595);
            }
          }
          float _605 = _604 + 1.0f;
          float _606 = _605 * _549;
          float _607 = _605 * _552;
          float _608 = _605 * _555;
          _637 = 0.0f;
          do {
            if (!(((bool)((_606 == _607))) && ((bool)((_607 == _608))))) {
              float _615 = ((_606 * 2.0f) - _607) - _608;
              float _618 = ((_552 - _555) * 1.7320507764816284f) * _605;
              float _620 = atan((_618 / _615));
              bool _623 = (_615 < 0.0f);
              bool _624 = (_615 == 0.0f);
              bool _625 = (_618 >= 0.0f);
              bool _626 = (_618 < 0.0f);
              _637 = ((((bool)(_625 && _624)) ? 90.0f : ((((bool)(_626 && _624)) ? -90.0f : (((((bool)(_626 && _623)) ? (_620 + -3.1415927410125732f) : ((((bool)(_625 && _623)) ? (_620 + 3.1415927410125732f) : _620)))) * 57.295780181884766f)))));
            }
            float _642 = min((max(((((bool)((_637 < 0.0f))) ? (_637 + 360.0f) : _637)), 0.0f)), 360.0f);
            do {
              if (((_642 < -180.0f))) {
                _651 = (_642 + 360.0f);
              } else {
                _651 = _642;
                if (((_642 > 180.0f))) {
                  _651 = (_642 + -360.0f);
                }
              }
              float _655 = saturate((1.0f - (abs((_651 * 0.014814814552664757f)))));
              float _659 = (_655 * _655) * (3.0f - (_655 * 2.0f));
              float _665 = ((_659 * _659) * ((_564 * 0.18000000715255737f) * (0.029999999329447746f - _606))) + _606;
              // AP0 -> AP1
              float _675 = max(0.0f, (mad(-0.21492856740951538f, _608, (mad(-0.2365107536315918f, _607, (_665 * 1.4514392614364624f))))));
              float _676 = max(0.0f, (mad(-0.09967592358589172f, _608, (mad(1.17622971534729f, _607, (_665 * -0.07655377686023712f))))));
              float _677 = max(0.0f, (mad(0.9977163076400757f, _608, (mad(-0.006032449658960104f, _607, (_665 * 0.008316148072481155f))))));

              // Luma from AP1
              float _678 = dot(float3(_675, _676, _677), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _688 = 1.0f - (global_environment_settings_022y);
              float _689 = _688 + (global_environment_settings_022w);
              float _691 = (1.0f - (global_environment_settings_022z)) + (global_environment_settings_023x);
              do {
                // Here
                // Some ACES tonemapper
                if ((((global_environment_settings_022y) > 0.800000011920929f))) {
                  _708 = (((0.8199999928474426f - (global_environment_settings_022y)) / (global_environment_settings_022x)) + -0.7447274923324585f);
                } else {
                  float _699 = ((global_environment_settings_022w) + 0.18000000715255737f) / _689;
                  _708 = (-0.7447274923324585f - (((log2((_699 / (2.0f - _699)))) * 0.3465735912322998f) * (_689 / (global_environment_settings_022x))));
                }
                float _710 = (_688 / (global_environment_settings_022x)) - _708;
                float _712 = ((global_environment_settings_022z) / (global_environment_settings_022x)) - _710;
                float _716 = (log2((((_675 - _678) * 0.9599999785423279f) + _678))) * 0.3010300099849701f;
                float _717 = (log2((((_676 - _678) * 0.9599999785423279f) + _678))) * 0.3010300099849701f;
                float _718 = (log2((((_677 - _678) * 0.9599999785423279f) + _678))) * 0.3010300099849701f;
                float _722 = (_716 + _710) * (global_environment_settings_022x);
                float _723 = (_717 + _710) * (global_environment_settings_022x);
                float _724 = (_718 + _710) * (global_environment_settings_022x);
                float _725 = _689 * 2.0f;
                float _727 = ((global_environment_settings_022x) * -2.0f) / _689;
                float _728 = _716 - _708;
                float _729 = _717 - _708;
                float _730 = _718 - _708;
                float _749 = (global_environment_settings_023x) + 1.0f;
                float _750 = _691 * 2.0f;
                float _752 = ((global_environment_settings_022x) * 2.0f) / _691;
                float _777 = (((bool)((_716 < _708))) ? ((_725 / ((exp2(((_728 * 1.4426950216293335f) * _727))) + 1.0f)) - (global_environment_settings_022w)) : _722);
                float _778 = (((bool)((_717 < _708))) ? ((_725 / ((exp2(((_729 * 1.4426950216293335f) * _727))) + 1.0f)) - (global_environment_settings_022w)) : _723);
                float _779 = (((bool)((_718 < _708))) ? ((_725 / ((exp2(((_727 * 1.4426950216293335f) * _730))) + 1.0f)) - (global_environment_settings_022w)) : _724);
                float _786 = _712 - _708;
                float _790 = saturate((_728 / _786));
                float _791 = saturate((_729 / _786));
                float _792 = saturate((_730 / _786));
                bool _793 = (_712 < _708);
                float _797 = (_793 ? (1.0f - _790) : _790);
                float _798 = (_793 ? (1.0f - _791) : _791);
                float _799 = (_793 ? (1.0f - _792) : _792);
                float _818 = (((_797 * _797) * (((((bool)((_716 > _712))) ? (_749 - (_750 / ((exp2((((_716 - _712) * 1.4426950216293335f) * _752))) + 1.0f))) : _722)) - _777)) * (3.0f - (_797 * 2.0f))) + _777;
                float _819 = (((_798 * _798) * (((((bool)((_717 > _712))) ? (_749 - (_750 / ((exp2((((_717 - _712) * 1.4426950216293335f) * _752))) + 1.0f))) : _723)) - _778)) * (3.0f - (_798 * 2.0f))) + _778;
                float _820 = (((_799 * _799) * (((((bool)((_718 > _712))) ? (_749 - (_750 / ((exp2((((_718 - _712) * 1.4426950216293335f) * _752))) + 1.0f))) : _724)) - _779)) * (3.0f - (_799 * 2.0f))) + _779;
                float _821 = dot(float3(_818, _819, _820), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                _863 = (max(0.0f, (((_818 - _821) * 0.9300000071525574f) + _821)));  // SDR AP1 color
                _864 = (max(0.0f, (((_819 - _821) * 0.9300000071525574f) + _821)));
                _865 = (max(0.0f, (((_820 - _821) * 0.9300000071525574f) + _821)));
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        // Uncharted 2?
        _863 = (saturate(((((_402 * 2.509999990463257f) + 0.029999999329447746f) * _402) / ((((_402 * 2.430000066757202f) + 0.5899999737739563f) * _402) + 0.14000000059604645f))));
        _864 = (saturate(((((_403 * 2.509999990463257f) + 0.029999999329447746f) * _403) / ((((_403 * 2.430000066757202f) + 0.5899999737739563f) * _403) + 0.14000000059604645f))));
        _865 = (saturate(((((_404 * 2.509999990463257f) + 0.029999999329447746f) * _404) / ((((_404 * 2.430000066757202f) + 0.5899999737739563f) * _404) + 0.14000000059604645f))));
      }
    }
  }
  float3 lut_input_color = float3(_863, _864, _865);

  // LUT preperations
  // Gamma 2.2
  float _872 = exp2(((log2(_863)) * 0.4545454680919647f));
  float _873 = exp2(((log2(_864)) * 0.4545454680919647f));
  float _874 = exp2(((log2(_865)) * 0.4545454680919647f));
  float _875 = (TEXCOORD.x) + -0.5f;
  float _876 = (TEXCOORD.y) + -0.5f;
  float _883 = ((c0_005y) * 1.4427000284194946f) + 1.4427000284194946f;
  float _896 = 1.0f - (saturate(((exp2(((_883 * (1.0f - (dot(float2(_875, _876), float2(_875, _876))))) - _883))) * (c0_005x))));
  float _905 = (c0_008w) * (c0_005z);
  float _915 = ((((1.0f - ((1.0f - (c0_006x)) * _896)) * _872) - _872) * _905) + _872;
  float _916 = ((((1.0f - ((1.0f - (c0_006y)) * _896)) * _873) - _873) * _905) + _873;
  float _917 = ((((1.0f - ((1.0f - (c0_006z)) * _896)) * _874) - _874) * _905) + _874;
  _939 = _915;
  _940 = _916;
  _941 = _917;
  if ((!((c0_009y) == 0.0f))) {
    // Not here
    float _928 = max((dot(float3(_915, _916, _917), float3((c0_010x), (c0_010y), (c0_010z)))), 0.0f);
    _939 = (((_928 - _915) * (c0_009z)) + _915);
    _940 = (((_928 - _916) * (c0_009z)) + _916);
    _941 = (((_928 - _917) * (c0_009z)) + _917);
  }
  _968 = _939;
  _969 = _940;
  _970 = _941;
  // c0_009x lerp value
  if ((!((c0_009x) == 0.0f))) {
    // Applies LUT, I think outputs BT709
    float4 _954 = t2.SampleLevel(s2, float3((((saturate(_939)) * 0.9375f) + 0.03125f), (((saturate(_940)) * 0.9375f) + 0.03125f), (((saturate(_941)) * 0.9375f) + 0.03125f)), 0.0f);
    _968 = ((((_954.x) - _939) * (c0_009x)) + _939);
    _969 = ((((_954.y) - _940) * (c0_009x)) + _940);
    _970 = ((((_954.z) - _941) * (c0_009x)) + _941);
  }
  
  SV_Target.x = _968;
  SV_Target.y = _969;
  SV_Target.z = _970;

  SV_Target = TonemapWithLUT(untonemapped_bt709, s2, t2, c0_009x);

  SV_Target.w = (_15.w);

  return SV_Target;
}
