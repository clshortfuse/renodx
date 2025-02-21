#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture3D<float4> t3 : register(t3);

Texture2D<float> current_exposure : register(t4);

Texture2D<float4> t5 : register(t5);

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

SamplerState s4 : register(s4);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _17 = t0.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)));
  float _24 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_17.x);
  float _25 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_17.y);
  float _26 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_17.z);
  float3 untonemapped_bt709 = float3(_24, _25, _26);  // After exposure

  float _287 = _24;
  float _288 = _25;
  float _289 = _26;
  float _613;
  float _646;
  float _660;
  float _717;
  float _872;
  float _873;
  float _874;
  float _948;
  float _949;
  float _950;
  float _977;
  float _978;
  float _979;
  if ((!((c0_007x) == 0.0f))) {
    int _33 = asint((((float4)(t5.Sample(s4, float2((TEXCOORD.x), (TEXCOORD.y))))).x));
    float _35 = asfloat((_33 & 2147483647));
    bool _39 = (((uint)(uint((float((uint)((int)((uint)(_33) >> 31))))))) == 0);
    float _51 = (_39 ? (TEXCOORD_1.w) : (TEXCOORD_1.w));
    float _78 = ((global_viewport_001x) + ((((_39 ? (TEXCOORD_1.x) : (TEXCOORD_1.x))) / _51) * _35)) - (((global_viewport_010y)*_35) * (c0_007z));
    float _79 = ((global_viewport_001y) + ((((_39 ? (TEXCOORD_1.y) : (TEXCOORD_1.y))) / _51) * _35)) - (((global_viewport_011y)*_35) * (c0_007z));
    float _80 = ((global_viewport_001z) + ((((_39 ? (TEXCOORD_1.z) : (TEXCOORD_1.z))) / _51) * _35)) - (((global_viewport_012y)*_35) * (c0_007z));
    float _134 = (mad(_80, ((_39 ? (global_viewport_077z) : (global_viewport_081z))), (mad(_79, ((_39 ? (global_viewport_077y) : (global_viewport_081y))), (((_39 ? (global_viewport_077x) : (global_viewport_081x))) * _78))))) + ((_39 ? (global_viewport_077w) : (global_viewport_081w)));
    float _137 = (((mad(_80, ((_39 ? (global_viewport_074z) : (global_viewport_078z))), (mad(_79, ((_39 ? (global_viewport_074y) : (global_viewport_078y))), (((_39 ? (global_viewport_074x) : (global_viewport_078x))) * _78))))) + ((_39 ? (global_viewport_074w) : (global_viewport_078w)))) / _134) * 0.5f;
    float _138 = (((mad(_80, ((_39 ? (global_viewport_075z) : (global_viewport_079z))), (mad(_79, ((_39 ? (global_viewport_075y) : (global_viewport_079y))), (((_39 ? (global_viewport_075x) : (global_viewport_079x))) * _78))))) + ((_39 ? (global_viewport_075w) : (global_viewport_079w)))) / _134) * -0.5f;
    float _144 = (c0_011x) * (_137 + 0.5f);
    float _145 = (_138 + 0.5f) * (c0_011y);
    float _146 = 1.0f / (c0_011x);
    float _147 = 1.0f / (c0_011y);
    float _150 = floor((_144 + -0.5f));
    float _151 = floor((_145 + -0.5f));
    float _154 = _144 - (_150 + 0.5f);
    float _155 = _145 - (_151 + 0.5f);
    float _156 = _154 * _154;
    float _157 = _155 * _155;
    float _158 = _156 * _154;
    float _159 = _157 * _155;
    float _166 = (mad(_156, -1.0f, (_158 * 0.5f))) + 0.6666666865348816f;
    float _170 = _158 * 0.1666666716337204f;
    float _177 = (mad(_157, -1.0f, (_159 * 0.5f))) + 0.6666666865348816f;
    float _181 = _159 * 0.1666666716337204f;
    float _182 = ((mad(_154, -0.5f, (mad(_156, 0.5f, (_158 * -0.1666666716337204f))))) + 0.1666666716337204f) + _166;
    float _183 = ((mad(_155, -0.5f, (mad(_157, 0.5f, (_159 * -0.1666666716337204f))))) + 0.1666666716337204f) + _177;
    float _196 = ((_150 + -0.5f) + (_166 / _182)) * _146;
    float _197 = ((_151 + -0.5f) + (_177 / _183)) * _147;
    float _202 = ((_150 + 1.5f) + (_170 / ((_170 + 0.1666666716337204f) + (mad(_154, 0.5f, (mad(_156, 0.5f, (_158 * -0.5f)))))))) * _146;
    float _203 = ((_151 + 1.5f) + (_181 / ((_181 + 0.1666666716337204f) + (mad(_155, 0.5f, (mad(_157, 0.5f, (_159 * -0.5f)))))))) * _147;
    float4 _204 = t1.Sample(s1, float2(_196, _197));
    float4 _208 = t1.Sample(s1, float2(_202, _197));
    float4 _212 = t1.Sample(s1, float2(_196, _203));
    float4 _216 = t1.Sample(s1, float2(_202, _203));
    float _235 = (((_208.x) - (_216.x)) * _183) + (_216.x);
    float _236 = (((_208.y) - (_216.y)) * _183) + (_216.y);
    float _237 = (((_208.z) - (_216.z)) * _183) + (_216.z);
    float _244 = ((((((_204.x) - (_212.x)) * _183) + (_212.x)) - _235) * _182) + _235;
    float _245 = ((((((_204.y) - (_212.y)) * _183) + (_212.y)) - _236) * _182) + _236;
    float _246 = ((((((_204.z) - (_212.z)) * _183) + (_212.z)) - _237) * _182) + _237;
    float _251 = max(((c0_004y) - (dot(float3(_244, _245, _246), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f)))), 6.0999998822808266e-05f);
    float _263 = saturate((((abs((-0.0f - _137))) + -0.5f) * -3.3333332538604736f));
    float _264 = saturate((((abs((-0.0f - _138))) + -0.5f) * -3.3333332538604736f));
    float _270 = (_263 * _263) * (3.0f - (_263 * 2.0f));
    float _272 = (_264 * _264) * (3.0f - (_264 * 2.0f));
    _287 = (((((c0_007y) * (_244 / _251)) * _270) * _272) + _24);
    _288 = (((((c0_007y) * (_245 / _251)) * _270) * _272) + _25);
    _289 = (((((c0_007y) * (_246 / _251)) * _270) * _272) + _26);
  }
  float _293 = (c0_011x) * (TEXCOORD.x);
  float _294 = (c0_011y) * (TEXCOORD.y);
  float _295 = 1.0f / (c0_011x);
  float _296 = 1.0f / (c0_011y);
  float _299 = floor((_293 + -0.5f));
  float _300 = floor((_294 + -0.5f));
  float _303 = _293 - (_299 + 0.5f);
  float _304 = _294 - (_300 + 0.5f);
  float _305 = _303 * _303;
  float _306 = _304 * _304;
  float _307 = _305 * _303;
  float _308 = _306 * _304;
  float _315 = (mad(_305, -1.0f, (_307 * 0.5f))) + 0.6666666865348816f;
  float _319 = _307 * 0.1666666716337204f;
  float _326 = (mad(_306, -1.0f, (_308 * 0.5f))) + 0.6666666865348816f;
  float _330 = _308 * 0.1666666716337204f;
  float _331 = ((mad(_303, -0.5f, (mad(_305, 0.5f, (_307 * -0.1666666716337204f))))) + 0.1666666716337204f) + _315;
  float _332 = ((mad(_304, -0.5f, (mad(_306, 0.5f, (_308 * -0.1666666716337204f))))) + 0.1666666716337204f) + _326;
  float _345 = ((_299 + -0.5f) + (_315 / _331)) * _295;
  float _346 = ((_300 + -0.5f) + (_326 / _332)) * _296;
  float _351 = ((_299 + 1.5f) + (_319 / ((_319 + 0.1666666716337204f) + (mad(_303, 0.5f, (mad(_305, 0.5f, (_307 * -0.5f)))))))) * _295;
  float _352 = ((_300 + 1.5f) + (_330 / ((_330 + 0.1666666716337204f) + (mad(_304, 0.5f, (mad(_306, 0.5f, (_308 * -0.5f)))))))) * _296;
  float4 _353 = t1.Sample(s1, float2(_345, _346));
  float4 _357 = t1.Sample(s1, float2(_351, _346));
  float4 _361 = t1.Sample(s1, float2(_345, _352));
  float4 _365 = t1.Sample(s1, float2(_351, _352));
  float _384 = (((_357.x) - (_365.x)) * _332) + (_365.x);
  float _385 = (((_357.y) - (_365.y)) * _332) + (_365.y);
  float _386 = (((_357.z) - (_365.z)) * _332) + (_365.z);
  float _393 = ((((((_353.x) - (_361.x)) * _332) + (_361.x)) - _384) * _331) + _384;
  float _394 = ((((((_353.y) - (_361.y)) * _332) + (_361.y)) - _385) * _331) + _385;
  float _395 = ((((((_353.z) - (_361.z)) * _332) + (_361.z)) - _386) * _331) + _386;
  float _400 = max(((c0_004y) - (dot(float3(_393, _394, _395), float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f)))), 6.0999998822808266e-05f);
  float4 _407 = t2.Sample(s2, float2((TEXCOORD.x), (TEXCOORD.y)));
  float _411 = ((_393 / _400) + _287) + (_407.x);
  float _412 = ((_394 / _400) + _288) + (_407.y);
  float _413 = ((_395 / _400) + _289) + (_407.z);
  _872 = _411;
  _873 = _412;
  _874 = _413;

  if ((!((c0_008y) == 0.0f))) {
    if ((!((c0_008z) == 0.0f))) {
      float _421 = max(0.0f, _411);
      float _422 = max(0.0f, _412);
      float _423 = max(0.0f, _413);
      float _443 = asfloat(((uint)(c0_014y)));
      float _444 = asfloat(((uint)(c0_014z)));
      float _445 = asfloat(((uint)(c0_014w)));
      float _455 = asfloat(((uint)(c0_013z)));
      float _456 = asfloat(((uint)(c0_013w)));
      float _457 = asfloat(((uint)(c0_014x)));
      float _460 = 1.0f / (max(_421, (max(_422, _423))));
      float _466 = exp2(((log2((_460 * _421))) * (asfloat(((uint)(c0_012x))))));
      float _469 = exp2(((log2((_460 * _422))) * (asfloat(((uint)(c0_012y))))));
      float _472 = exp2(((log2((_460 * _423))) * (asfloat(((uint)(c0_012z))))));
      float _480 = exp2(((log2((((_456 * _422) + (_455 * _421)) + (_457 * _423)))) * (asfloat(((uint)(c0_012w))))));
      float _484 = (1.0f / ((_480 * (asfloat(((uint)(c0_013x))))) + (asfloat(((uint)(c0_013y)))))) * _480;
      float _492 = saturate((_484 * (1.0f / (((_469 * _456) + (_466 * _455)) + (_472 * _457)))));
      float _494 = saturate((_492 * _466));
      float _496 = saturate((_492 * _469));
      float _498 = saturate((_492 * _472));
      float _500 = _443 - (_494 * _443);
      float _502 = _444 - (_496 * _444);
      float _504 = _445 - (_498 * _445);
      float _518 = (1.0f / (((_502 * _456) + (_500 * _455)) + (_504 * _457))) * (saturate((((_484 - (_494 * _455)) - (_496 * _456)) - (_498 * _457))));
      float _521 = saturate(((_518 * _500) + _494));
      float _524 = saturate(((_518 * _502) + _496));
      float _527 = saturate(((_518 * _504) + _498));
      float _534 = saturate((((_484 - (_521 * _455)) - (_524 * _456)) - (_527 * _457)));
      _872 = (saturate(((_534 * (asfloat(((uint)(c0_015x))))) + _521)));
      _873 = (saturate(((_534 * (asfloat(((uint)(c0_015y))))) + _524)));
      _874 = (saturate(((_534 * (asfloat(((uint)(c0_015z))))) + _527)));
    } else {
      if ((!((global_environment_settings_021w) == 0.0f))) {
        float _558 = mad(0.16386905312538147f, _413, (mad(0.14067868888378143f, _412, (_411 * 0.6954522132873535f))));
        float _561 = mad(0.0955343246459961f, _413, (mad(0.8596711158752441f, _412, (_411 * 0.044794581830501556f))));
        float _564 = mad(1.0015007257461548f, _413, (mad(0.004025210160762072f, _412, (_411 * -0.005525882821530104f))));
        float _568 = max((max(_558, _561)), _564);
        float _573 = ((max(_568, 1.000000013351432e-10f)) - (max((min((min(_558, _561)), _564)), 1.000000013351432e-10f))) / (max(_568, 0.009999999776482582f));
        float _586 = ((_561 + _558) + _564) + ((sqrt(((((_564 - _561) * _564) + ((_561 - _558) * _561)) + ((_558 - _564) * _558)))) * 1.75f);
        float _587 = _586 * 0.3333333432674408f;
        float _588 = _573 + -0.4000000059604645f;
        float _589 = _588 * 5.0f;
        float _593 = max((1.0f - (abs((_588 * 2.5f)))), 0.0f);
        float _604 = (((float(((int(((bool)((_589 > 0.0f))))) - (int(((bool)((_589 < 0.0f)))))))) * (1.0f - (_593 * _593))) + 1.0f) * 0.02500000037252903f;
        _613 = _604;
        do {
          if ((!(_587 <= 0.0533333346247673f))) {
            _613 = 0.0f;
            if ((!(_587 >= 0.1599999964237213f))) {
              _613 = (((0.23999999463558197f / _586) + -0.5f) * _604);
            }
          }
          float _614 = _613 + 1.0f;
          float _615 = _614 * _558;
          float _616 = _614 * _561;
          float _617 = _614 * _564;
          _646 = 0.0f;
          do {
            if (!(((bool)((_615 == _616))) && ((bool)((_616 == _617))))) {
              float _624 = ((_615 * 2.0f) - _616) - _617;
              float _627 = ((_561 - _564) * 1.7320507764816284f) * _614;
              float _629 = atan((_627 / _624));
              bool _632 = (_624 < 0.0f);
              bool _633 = (_624 == 0.0f);
              bool _634 = (_627 >= 0.0f);
              bool _635 = (_627 < 0.0f);
              _646 = ((((bool)(_634 && _633)) ? 90.0f : ((((bool)(_635 && _633)) ? -90.0f : (((((bool)(_635 && _632)) ? (_629 + -3.1415927410125732f) : ((((bool)(_634 && _632)) ? (_629 + 3.1415927410125732f) : _629)))) * 57.295780181884766f)))));
            }
            float _651 = min((max(((((bool)((_646 < 0.0f))) ? (_646 + 360.0f) : _646)), 0.0f)), 360.0f);
            do {
              if (((_651 < -180.0f))) {
                _660 = (_651 + 360.0f);
              } else {
                _660 = _651;
                if (((_651 > 180.0f))) {
                  _660 = (_651 + -360.0f);
                }
              }
              float _664 = saturate((1.0f - (abs((_660 * 0.014814814552664757f)))));
              float _668 = (_664 * _664) * (3.0f - (_664 * 2.0f));
              float _674 = ((_668 * _668) * ((_573 * 0.18000000715255737f) * (0.029999999329447746f - _615))) + _615;
              float _684 = max(0.0f, (mad(-0.21492856740951538f, _617, (mad(-0.2365107536315918f, _616, (_674 * 1.4514392614364624f))))));
              float _685 = max(0.0f, (mad(-0.09967592358589172f, _617, (mad(1.17622971534729f, _616, (_674 * -0.07655377686023712f))))));
              float _686 = max(0.0f, (mad(0.9977163076400757f, _617, (mad(-0.006032449658960104f, _616, (_674 * 0.008316148072481155f))))));
              float _687 = dot(float3(_684, _685, _686), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _697 = 1.0f - (global_environment_settings_022y);
              float _698 = _697 + (global_environment_settings_022w);
              float _700 = (1.0f - (global_environment_settings_022z)) + (global_environment_settings_023x);
              do {
                if ((((global_environment_settings_022y) > 0.800000011920929f))) {
                  _717 = (((0.8199999928474426f - (global_environment_settings_022y)) / (global_environment_settings_022x)) + -0.7447274923324585f);
                } else {
                  float _708 = ((global_environment_settings_022w) + 0.18000000715255737f) / _698;
                  _717 = (-0.7447274923324585f - (((log2((_708 / (2.0f - _708)))) * 0.3465735912322998f) * (_698 / (global_environment_settings_022x))));
                }
                float _719 = (_697 / (global_environment_settings_022x)) - _717;
                float _721 = ((global_environment_settings_022z) / (global_environment_settings_022x)) - _719;
                float _725 = (log2((((_684 - _687) * 0.9599999785423279f) + _687))) * 0.3010300099849701f;
                float _726 = (log2((((_685 - _687) * 0.9599999785423279f) + _687))) * 0.3010300099849701f;
                float _727 = (log2((((_686 - _687) * 0.9599999785423279f) + _687))) * 0.3010300099849701f;
                float _731 = (_725 + _719) * (global_environment_settings_022x);
                float _732 = (_726 + _719) * (global_environment_settings_022x);
                float _733 = (_727 + _719) * (global_environment_settings_022x);
                float _734 = _698 * 2.0f;
                float _736 = ((global_environment_settings_022x) * -2.0f) / _698;
                float _737 = _725 - _717;
                float _738 = _726 - _717;
                float _739 = _727 - _717;
                float _758 = (global_environment_settings_023x) + 1.0f;
                float _759 = _700 * 2.0f;
                float _761 = ((global_environment_settings_022x) * 2.0f) / _700;
                float _786 = (((bool)((_725 < _717))) ? ((_734 / ((exp2(((_737 * 1.4426950216293335f) * _736))) + 1.0f)) - (global_environment_settings_022w)) : _731);
                float _787 = (((bool)((_726 < _717))) ? ((_734 / ((exp2(((_738 * 1.4426950216293335f) * _736))) + 1.0f)) - (global_environment_settings_022w)) : _732);
                float _788 = (((bool)((_727 < _717))) ? ((_734 / ((exp2(((_736 * 1.4426950216293335f) * _739))) + 1.0f)) - (global_environment_settings_022w)) : _733);
                float _795 = _721 - _717;
                float _799 = saturate((_737 / _795));
                float _800 = saturate((_738 / _795));
                float _801 = saturate((_739 / _795));
                bool _802 = (_721 < _717);
                float _806 = (_802 ? (1.0f - _799) : _799);
                float _807 = (_802 ? (1.0f - _800) : _800);
                float _808 = (_802 ? (1.0f - _801) : _801);
                float _827 = (((_806 * _806) * (((((bool)((_725 > _721))) ? (_758 - (_759 / ((exp2((((_725 - _721) * 1.4426950216293335f) * _761))) + 1.0f))) : _731)) - _786)) * (3.0f - (_806 * 2.0f))) + _786;
                float _828 = (((_807 * _807) * (((((bool)((_726 > _721))) ? (_758 - (_759 / ((exp2((((_726 - _721) * 1.4426950216293335f) * _761))) + 1.0f))) : _732)) - _787)) * (3.0f - (_807 * 2.0f))) + _787;
                float _829 = (((_808 * _808) * (((((bool)((_727 > _721))) ? (_758 - (_759 / ((exp2((((_727 - _721) * 1.4426950216293335f) * _761))) + 1.0f))) : _733)) - _788)) * (3.0f - (_808 * 2.0f))) + _788;
                float _830 = dot(float3(_827, _828, _829), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                _872 = (max(0.0f, (((_827 - _830) * 0.9300000071525574f) + _830)));
                _873 = (max(0.0f, (((_828 - _830) * 0.9300000071525574f) + _830)));
                _874 = (max(0.0f, (((_829 - _830) * 0.9300000071525574f) + _830)));
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _872 = (saturate(((((_411 * 2.509999990463257f) + 0.029999999329447746f) * _411) / ((((_411 * 2.430000066757202f) + 0.5899999737739563f) * _411) + 0.14000000059604645f))));
        _873 = (saturate(((((_412 * 2.509999990463257f) + 0.029999999329447746f) * _412) / ((((_412 * 2.430000066757202f) + 0.5899999737739563f) * _412) + 0.14000000059604645f))));
        _874 = (saturate(((((_413 * 2.509999990463257f) + 0.029999999329447746f) * _413) / ((((_413 * 2.430000066757202f) + 0.5899999737739563f) * _413) + 0.14000000059604645f))));
      }
    }
  }
  float3 lut_input_color = float3(_872, _873, _874);
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s3,
      1.f,
      0.f,
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::LINEAR);

  float3 post_lut_color = renodx::lut::Sample(t3, lut_config, saturate(lut_input_color));

  float _881 = exp2(((log2(_872)) * 0.4545454680919647f));
  float _882 = exp2(((log2(_873)) * 0.4545454680919647f));
  float _883 = exp2(((log2(_874)) * 0.4545454680919647f));
  float _884 = (TEXCOORD.x) + -0.5f;
  float _885 = (TEXCOORD.y) + -0.5f;
  float _892 = ((c0_005y) * 1.4427000284194946f) + 1.4427000284194946f;
  float _905 = 1.0f - (saturate(((exp2(((_892 * (1.0f - (dot(float2(_884, _885), float2(_884, _885))))) - _892))) * (c0_005x))));
  float _914 = (c0_008w) * (c0_005z);
  float _924 = ((((1.0f - ((1.0f - (c0_006x)) * _905)) * _881) - _881) * _914) + _881;
  float _925 = ((((1.0f - ((1.0f - (c0_006y)) * _905)) * _882) - _882) * _914) + _882;
  float _926 = ((((1.0f - ((1.0f - (c0_006z)) * _905)) * _883) - _883) * _914) + _883;
  _948 = _924;
  _949 = _925;
  _950 = _926;
  if ((!((c0_009y) == 0.0f))) {
    float _937 = max((dot(float3(_924, _925, _926), float3((c0_010x), (c0_010y), (c0_010z)))), 0.0f);
    _948 = (((_937 - _924) * (c0_009z)) + _924);
    _949 = (((_937 - _925) * (c0_009z)) + _925);
    _950 = (((_937 - _926) * (c0_009z)) + _926);
  }
  _977 = _948;
  _978 = _949;
  _979 = _950;
  if ((!((c0_009x) == 0.0f))) {
    float4 _963 = t3.SampleLevel(s3, float3((((saturate(_948)) * 0.9375f) + 0.03125f), (((saturate(_949)) * 0.9375f) + 0.03125f), (((saturate(_950)) * 0.9375f) + 0.03125f)), 0.0f);
    _977 = ((((_963.x) - _948) * (c0_009x)) + _948);
    _978 = ((((_963.y) - _949) * (c0_009x)) + _949);
    _979 = ((((_963.z) - _950) * (c0_009x)) + _950);
  }
  SV_Target.x = _977;
  SV_Target.y = _978;
  SV_Target.z = _979;

  SV_Target = TonemapWithLUT(untonemapped_bt709, s3, t3, c0_009x);

  SV_Target.w = (_17.w);
  return SV_Target;
}
