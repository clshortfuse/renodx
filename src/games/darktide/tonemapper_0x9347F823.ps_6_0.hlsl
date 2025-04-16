#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

Texture2D<float> current_exposure : register(t2);

cbuffer global_environment_settings : register(b0) {
  float global_environment_settings_021w : packoffset(c021.w);
  float global_environment_settings_022x : packoffset(c022.x);
  float global_environment_settings_022y : packoffset(c022.y);
  float global_environment_settings_022z : packoffset(c022.z);
  float global_environment_settings_022w : packoffset(c022.w);
  float global_environment_settings_023x : packoffset(c023.x);
};

cbuffer c0 : register(b1) {
  float c0_005x : packoffset(c005.x);
  float c0_005y : packoffset(c005.y);
  float c0_005z : packoffset(c005.z);
  float c0_006x : packoffset(c006.x);
  float c0_006y : packoffset(c006.y);
  float c0_006z : packoffset(c006.z);
  float c0_008y : packoffset(c008.y);
  float c0_008z : packoffset(c008.z);
  float c0_008w : packoffset(c008.w);
  float c0_009x : packoffset(c009.x);
  float c0_009y : packoffset(c009.y);
  float c0_009z : packoffset(c009.z);
  float c0_010x : packoffset(c010.x);
  float c0_010y : packoffset(c010.y);
  float c0_010z : packoffset(c010.z);
  uint c0_011x : packoffset(c011.x);
  uint c0_011y : packoffset(c011.y);
  uint c0_011z : packoffset(c011.z);
  uint c0_011w : packoffset(c011.w);
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
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _10 = t0.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)));
  float _17 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_10.x);
  float _18 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_10.y);
  float _19 = ((current_exposure.Load(int3(0, 0, 0))).x) * (_10.z);
  float3 untonemapped_bt709 = float3(_17, _18, _19);  // After exposure

  float _219;
  float _252;
  float _266;
  float _323;
  float _478 = _17;
  float _479 = _18;
  float _480 = _19;
  float _554;
  float _555;
  float _556;
  float _583;
  float _584;
  float _585;

  if ((!((c0_008y) == 0.0f))) {
    if ((!((c0_008z) == 0.0f))) {
      float _27 = max(0.0f, _17);
      float _28 = max(0.0f, _18);
      float _29 = max(0.0f, _19);
      float _49 = asfloat(((uint)(c0_013y)));
      float _50 = asfloat(((uint)(c0_013z)));
      float _51 = asfloat(((uint)(c0_013w)));
      float _61 = asfloat(((uint)(c0_012z)));
      float _62 = asfloat(((uint)(c0_012w)));
      float _63 = asfloat(((uint)(c0_013x)));
      float _66 = 1.0f / (max(_27, (max(_28, _29))));
      float _72 = exp2(((log2((_66 * _27))) * (asfloat(((uint)(c0_011x))))));
      float _75 = exp2(((log2((_66 * _28))) * (asfloat(((uint)(c0_011y))))));
      float _78 = exp2(((log2((_66 * _29))) * (asfloat(((uint)(c0_011z))))));
      float _86 = exp2(((log2((((_62 * _28) + (_61 * _27)) + (_63 * _29)))) * (asfloat(((uint)(c0_011w))))));
      float _90 = (1.0f / ((_86 * (asfloat(((uint)(c0_012x))))) + (asfloat(((uint)(c0_012y)))))) * _86;
      float _98 = saturate((_90 * (1.0f / (((_75 * _62) + (_72 * _61)) + (_78 * _63)))));
      float _100 = saturate((_98 * _72));
      float _102 = saturate((_98 * _75));
      float _104 = saturate((_98 * _78));
      float _106 = _49 - (_100 * _49);
      float _108 = _50 - (_102 * _50);
      float _110 = _51 - (_104 * _51);
      float _124 = (1.0f / (((_108 * _62) + (_106 * _61)) + (_110 * _63))) * (saturate((((_90 - (_100 * _61)) - (_102 * _62)) - (_104 * _63))));
      float _127 = saturate(((_124 * _106) + _100));
      float _130 = saturate(((_124 * _108) + _102));
      float _133 = saturate(((_124 * _110) + _104));
      float _140 = saturate((((_90 - (_127 * _61)) - (_130 * _62)) - (_133 * _63)));
      _478 = (saturate(((_140 * (asfloat(((uint)(c0_014x))))) + _127)));
      _479 = (saturate(((_140 * (asfloat(((uint)(c0_014y))))) + _130)));
      _480 = (saturate(((_140 * (asfloat(((uint)(c0_014z))))) + _133)));
    } else {
      if ((!((global_environment_settings_021w) == 0.0f))) {
        float _164 = mad(0.16386905312538147f, _19, (mad(0.14067868888378143f, _18, (_17 * 0.6954522132873535f))));
        float _167 = mad(0.0955343246459961f, _19, (mad(0.8596711158752441f, _18, (_17 * 0.044794581830501556f))));
        float _170 = mad(1.0015007257461548f, _19, (mad(0.004025210160762072f, _18, (_17 * -0.005525882821530104f))));
        float _174 = max((max(_164, _167)), _170);
        float _179 = ((max(_174, 1.000000013351432e-10f)) - (max((min((min(_164, _167)), _170)), 1.000000013351432e-10f))) / (max(_174, 0.009999999776482582f));
        float _192 = ((_167 + _164) + _170) + ((sqrt(((((_170 - _167) * _170) + ((_167 - _164) * _167)) + ((_164 - _170) * _164)))) * 1.75f);
        float _193 = _192 * 0.3333333432674408f;
        float _194 = _179 + -0.4000000059604645f;
        float _195 = _194 * 5.0f;
        float _199 = max((1.0f - (abs((_194 * 2.5f)))), 0.0f);
        float _210 = (((float(((int(((bool)((_195 > 0.0f))))) - (int(((bool)((_195 < 0.0f)))))))) * (1.0f - (_199 * _199))) + 1.0f) * 0.02500000037252903f;
        _219 = _210;
        do {
          if ((!(_193 <= 0.0533333346247673f))) {
            _219 = 0.0f;
            if ((!(_193 >= 0.1599999964237213f))) {
              _219 = (((0.23999999463558197f / _192) + -0.5f) * _210);
            }
          }
          float _220 = _219 + 1.0f;
          float _221 = _220 * _164;
          float _222 = _220 * _167;
          float _223 = _220 * _170;
          _252 = 0.0f;
          do {
            if (!(((bool)((_221 == _222))) && ((bool)((_222 == _223))))) {
              float _230 = ((_221 * 2.0f) - _222) - _223;
              float _233 = ((_167 - _170) * 1.7320507764816284f) * _220;
              float _235 = atan((_233 / _230));
              bool _238 = (_230 < 0.0f);
              bool _239 = (_230 == 0.0f);
              bool _240 = (_233 >= 0.0f);
              bool _241 = (_233 < 0.0f);
              _252 = ((((bool)(_240 && _239)) ? 90.0f : ((((bool)(_241 && _239)) ? -90.0f : (((((bool)(_241 && _238)) ? (_235 + -3.1415927410125732f) : ((((bool)(_240 && _238)) ? (_235 + 3.1415927410125732f) : _235)))) * 57.295780181884766f)))));
            }
            float _257 = min((max(((((bool)((_252 < 0.0f))) ? (_252 + 360.0f) : _252)), 0.0f)), 360.0f);
            do {
              if (((_257 < -180.0f))) {
                _266 = (_257 + 360.0f);
              } else {
                _266 = _257;
                if (((_257 > 180.0f))) {
                  _266 = (_257 + -360.0f);
                }
              }
              float _270 = saturate((1.0f - (abs((_266 * 0.014814814552664757f)))));
              float _274 = (_270 * _270) * (3.0f - (_270 * 2.0f));
              float _280 = ((_274 * _274) * ((_179 * 0.18000000715255737f) * (0.029999999329447746f - _221))) + _221;
              float _290 = max(0.0f, (mad(-0.21492856740951538f, _223, (mad(-0.2365107536315918f, _222, (_280 * 1.4514392614364624f))))));
              float _291 = max(0.0f, (mad(-0.09967592358589172f, _223, (mad(1.17622971534729f, _222, (_280 * -0.07655377686023712f))))));
              float _292 = max(0.0f, (mad(0.9977163076400757f, _223, (mad(-0.006032449658960104f, _222, (_280 * 0.008316148072481155f))))));
              float _293 = dot(float3(_290, _291, _292), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _303 = 1.0f - (global_environment_settings_022y);
              float _304 = _303 + (global_environment_settings_022w);
              float _306 = (1.0f - (global_environment_settings_022z)) + (global_environment_settings_023x);
              do {
                if ((((global_environment_settings_022y) > 0.800000011920929f))) {
                  _323 = (((0.8199999928474426f - (global_environment_settings_022y)) / (global_environment_settings_022x)) + -0.7447274923324585f);
                } else {
                  float _314 = ((global_environment_settings_022w) + 0.18000000715255737f) / _304;
                  _323 = (-0.7447274923324585f - (((log2((_314 / (2.0f - _314)))) * 0.3465735912322998f) * (_304 / (global_environment_settings_022x))));
                }
                float _325 = (_303 / (global_environment_settings_022x)) - _323;
                float _327 = ((global_environment_settings_022z) / (global_environment_settings_022x)) - _325;
                float _331 = (log2((((_290 - _293) * 0.9599999785423279f) + _293))) * 0.3010300099849701f;
                float _332 = (log2((((_291 - _293) * 0.9599999785423279f) + _293))) * 0.3010300099849701f;
                float _333 = (log2((((_292 - _293) * 0.9599999785423279f) + _293))) * 0.3010300099849701f;
                float _337 = (_331 + _325) * (global_environment_settings_022x);
                float _338 = (_332 + _325) * (global_environment_settings_022x);
                float _339 = (_333 + _325) * (global_environment_settings_022x);
                float _340 = _304 * 2.0f;
                float _342 = ((global_environment_settings_022x) * -2.0f) / _304;
                float _343 = _331 - _323;
                float _344 = _332 - _323;
                float _345 = _333 - _323;
                float _364 = (global_environment_settings_023x) + 1.0f;
                float _365 = _306 * 2.0f;
                float _367 = ((global_environment_settings_022x) * 2.0f) / _306;
                float _392 = (((bool)((_331 < _323))) ? ((_340 / ((exp2(((_343 * 1.4426950216293335f) * _342))) + 1.0f)) - (global_environment_settings_022w)) : _337);
                float _393 = (((bool)((_332 < _323))) ? ((_340 / ((exp2(((_344 * 1.4426950216293335f) * _342))) + 1.0f)) - (global_environment_settings_022w)) : _338);
                float _394 = (((bool)((_333 < _323))) ? ((_340 / ((exp2(((_342 * 1.4426950216293335f) * _345))) + 1.0f)) - (global_environment_settings_022w)) : _339);
                float _401 = _327 - _323;
                float _405 = saturate((_343 / _401));
                float _406 = saturate((_344 / _401));
                float _407 = saturate((_345 / _401));
                bool _408 = (_327 < _323);
                float _412 = (_408 ? (1.0f - _405) : _405);
                float _413 = (_408 ? (1.0f - _406) : _406);
                float _414 = (_408 ? (1.0f - _407) : _407);
                float _433 = (((_412 * _412) * (((((bool)((_331 > _327))) ? (_364 - (_365 / ((exp2((((_331 - _327) * 1.4426950216293335f) * _367))) + 1.0f))) : _337)) - _392)) * (3.0f - (_412 * 2.0f))) + _392;
                float _434 = (((_413 * _413) * (((((bool)((_332 > _327))) ? (_364 - (_365 / ((exp2((((_332 - _327) * 1.4426950216293335f) * _367))) + 1.0f))) : _338)) - _393)) * (3.0f - (_413 * 2.0f))) + _393;
                float _435 = (((_414 * _414) * (((((bool)((_333 > _327))) ? (_364 - (_365 / ((exp2((((_333 - _327) * 1.4426950216293335f) * _367))) + 1.0f))) : _339)) - _394)) * (3.0f - (_414 * 2.0f))) + _394;
                float _436 = dot(float3(_433, _434, _435), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                _478 = (max(0.0f, (((_433 - _436) * 0.9300000071525574f) + _436)));
                _479 = (max(0.0f, (((_434 - _436) * 0.9300000071525574f) + _436)));
                _480 = (max(0.0f, (((_435 - _436) * 0.9300000071525574f) + _436)));
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _478 = (saturate(((((_17 * 2.509999990463257f) + 0.029999999329447746f) * _17) / ((((_17 * 2.430000066757202f) + 0.5899999737739563f) * _17) + 0.14000000059604645f))));
        _479 = (saturate(((((_18 * 2.509999990463257f) + 0.029999999329447746f) * _18) / ((((_18 * 2.430000066757202f) + 0.5899999737739563f) * _18) + 0.14000000059604645f))));
        _480 = (saturate(((((_19 * 2.509999990463257f) + 0.029999999329447746f) * _19) / ((((_19 * 2.430000066757202f) + 0.5899999737739563f) * _19) + 0.14000000059604645f))));
      }
    }
  }
  float _487 = exp2(((log2(_478)) * 0.4545454680919647f));
  float _488 = exp2(((log2(_479)) * 0.4545454680919647f));
  float _489 = exp2(((log2(_480)) * 0.4545454680919647f));
  float _490 = (TEXCOORD.x) + -0.5f;
  float _491 = (TEXCOORD.y) + -0.5f;
  float _498 = ((c0_005y) * 1.4427000284194946f) + 1.4427000284194946f;
  float _511 = 1.0f - (saturate(((exp2(((_498 * (1.0f - (dot(float2(_490, _491), float2(_490, _491))))) - _498))) * (c0_005x))));
  float _520 = (c0_008w) * (c0_005z);
  float _530 = ((((1.0f - ((1.0f - (c0_006x)) * _511)) * _487) - _487) * _520) + _487;
  float _531 = ((((1.0f - ((1.0f - (c0_006y)) * _511)) * _488) - _488) * _520) + _488;
  float _532 = ((((1.0f - ((1.0f - (c0_006z)) * _511)) * _489) - _489) * _520) + _489;
  _554 = _530;
  _555 = _531;
  _556 = _532;
  if ((!((c0_009y) == 0.0f))) {
    float _543 = max((dot(float3(_530, _531, _532), float3((c0_010x), (c0_010y), (c0_010z)))), 0.0f);
    _554 = (((_543 - _530) * (c0_009z)) + _530);
    _555 = (((_543 - _531) * (c0_009z)) + _531);
    _556 = (((_543 - _532) * (c0_009z)) + _532);
  }
  _583 = _554;
  _584 = _555;
  _585 = _556;
  if ((!((c0_009x) == 0.0f))) {
    float4 _569 = t1.SampleLevel(s1, float3((((saturate(_554)) * 0.9375f) + 0.03125f), (((saturate(_555)) * 0.9375f) + 0.03125f), (((saturate(_556)) * 0.9375f) + 0.03125f)), 0.0f);
    _583 = ((((_569.x) - _554) * (c0_009x)) + _554);
    _584 = ((((_569.y) - _555) * (c0_009x)) + _555);
    _585 = ((((_569.z) - _556) * (c0_009x)) + _556);
  }
  SV_Target.x = _583;
  SV_Target.y = _584;
  SV_Target.z = _585;

  SV_Target.rgb = Tonemap(untonemapped_bt709, SV_Target.rgb);

  SV_Target.w = (_10.w);
  return SV_Target;
}
