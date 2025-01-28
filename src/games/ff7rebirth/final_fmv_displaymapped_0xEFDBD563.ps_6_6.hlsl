Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture2D<float4> CompositeSurfaceTexture : register(t4);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t5);

Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t6);

cbuffer Globals : register(b0) {
  float Globals_027z : packoffset(c027.z);
  float Globals_027w : packoffset(c027.w);
  uint Globals_029x : packoffset(c029.x);
  uint Globals_029y : packoffset(c029.y);
  float Globals_030x : packoffset(c030.x);
  float Globals_030y : packoffset(c030.y);
  float Globals_033x : packoffset(c033.x);
  float Globals_033y : packoffset(c033.y);
  float Globals_033z : packoffset(c033.z);
  float Globals_033w : packoffset(c033.w);
  float Globals_034z : packoffset(c034.z);
  float Globals_034w : packoffset(c034.w);
  uint Globals_036x : packoffset(c036.x);
  uint Globals_036y : packoffset(c036.y);
  float Globals_037x : packoffset(c037.x);
  float Globals_037y : packoffset(c037.y);
  float Globals_040x : packoffset(c040.x);
  float Globals_040y : packoffset(c040.y);
  float Globals_040z : packoffset(c040.z);
  float Globals_040w : packoffset(c040.w);
  uint Globals_043x : packoffset(c043.x);
  uint Globals_043y : packoffset(c043.y);
  float Globals_044x : packoffset(c044.x);
  float Globals_044y : packoffset(c044.y);
  float Globals_044z : packoffset(c044.z);
  float Globals_044w : packoffset(c044.w);
  float Globals_048x : packoffset(c048.x);
  float Globals_048y : packoffset(c048.y);
  float Globals_049x : packoffset(c049.x);
  float Globals_053x : packoffset(c053.x);
  float Globals_053y : packoffset(c053.y);
  float Globals_054x : packoffset(c054.x);
  float Globals_054y : packoffset(c054.y);
  float Globals_054z : packoffset(c054.z);
};

cbuffer View : register(b1) {
  uint View_175x : packoffset(c175.x);
};

SamplerState View_SharedBilinearClampedSampler : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _20 = !((Globals_054z) == 0.0f);
  float _36 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _37 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _43 = saturate((_36 * (Globals_044z)));
  float _44 = saturate((_37 * (Globals_044w)));
  float _57 = (_20 ? (saturate(((Globals_044z) * (((floor((_36 * 0.5f))) * 2.0f) + 1.0f)))) : _43);
  float _58 = (_20 ? (saturate(((((floor((_37 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _44);
  float _119 = min((((Globals_044w) * (Globals_044x)) * 0.5625f), 1.0f);
  float _120 = min((((Globals_044z) * (Globals_044y)) * 1.7777777910232544f), 1.0f);
  float4 _133 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x) * _57) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y) * _58) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);
  float _145 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _150 = (_145 * _145) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _145), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _145))))));
  float _154 = (((_150 * _150) + -1.0f) * (Globals_048x)) + 1.0f;
  float _155 = _154 * (min((_133.x), 65504.0f));
  float _156 = _154 * (min((_133.y), 65504.0f));
  float _157 = _154 * (min((_133.z), 65504.0f));
  float4 _159 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_037x) * _57) + (float((uint)(Globals_036x)))) * (Globals_034z)), (Globals_040x))), (Globals_040z))), (min((max(((((Globals_037y) * _58) + (float((uint)(Globals_036y)))) * (Globals_034w)), (Globals_040y))), (Globals_040w)))), 0.0f);
  float _185 = saturate((Globals_054x));
  float _187 = saturate((Globals_054y));
  float _192 = exp2(((log2((saturate(((((Globals_049x) * (((min((_159.x), 65504.0f)) - _155) + (_155 * (_159.w)))) + _155) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _208 = exp2(((log2((saturate(((((Globals_049x) * (((min((_159.y), 65504.0f)) - _156) + (_156 * (_159.w)))) + _156) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _224 = exp2(((log2((saturate(((((Globals_049x) * (((_157 * (_159.w)) - _157) + (min((_159.z), 65504.0f)))) + _157) * 0.009999999776482582f))))) * 0.1593017578125f));
  float4 _243 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((((saturate((exp2(((log2((max(0.0f, (((_192 * 18.8515625f) + 0.8359375f) * (1.0f / ((_192 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_208 * 18.8515625f) + 0.8359375f) * (1.0f / ((_208 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_224 * 18.8515625f) + 0.8359375f) * (1.0f / ((_224 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f)), 0.0f);
  float _250 = exp2(((log2((saturate((_243.x))))) * 0.012683313339948654f));
  float _259 = exp2(((log2((max(0.0f, ((_250 + -0.8359375f) * (1.0f / (18.8515625f - (_250 * 18.6875f)))))))) * 6.277394771575928f));
  float _264 = exp2(((log2((saturate((_243.y))))) * 0.012683313339948654f));
  float _273 = exp2(((log2((max(0.0f, ((_264 + -0.8359375f) * (1.0f / (18.8515625f - (_264 * 18.6875f)))))))) * 6.277394771575928f));
  float _278 = exp2(((log2((saturate((_243.z))))) * 0.012683313339948654f));
  float _287 = exp2(((log2((max(0.0f, ((_278 + -0.8359375f) * (1.0f / (18.8515625f - (_278 * 18.6875f)))))))) * 6.277394771575928f));
  bool _289 = (_185 > 0.0f);
  float _360 = (_259 * 10000.0f);
  float _361 = (_273 * 10000.0f);
  float _362 = (_287 * 10000.0f);
  float _363 = (_243.x);
  float _364 = (_243.y);
  float _365 = (_243.z);
  float _431;
  float _432;
  float _433;
  float _564;
  float _565;
  float _566;
  float _567;
  float _568;
  float _569;
  float _644;
  float _655;
  float _666;
  float _683;
  float _684;
  float _685;
  float _702;
  float _713;
  float _724;
  if (_289) {
    float _292 = 1.0f - (_185 * 0.2928932309150696f);
    float _305 = exp2(((log2((saturate((_259 * 10.0f))))) * _292));
    float _306 = exp2(((log2((saturate((_273 * 10.0f))))) * _292));
    float _307 = exp2(((log2((saturate((_287 * 10.0f))))) * _292));
    float _315 = exp2(((log2((saturate((_305 * 0.09999999403953552f))))) * 0.1593017578125f));
    float _331 = exp2(((log2((saturate((_306 * 0.09999999403953552f))))) * 0.1593017578125f));
    float _347 = exp2(((log2((saturate((_307 * 0.09999999403953552f))))) * 0.1593017578125f));
    _360 = (_305 * 1000.0f);
    _361 = (_306 * 1000.0f);
    _362 = (_307 * 1000.0f);
    _363 = (saturate((exp2(((log2((max(0.0f, (((_315 * 18.8515625f) + 0.8359375f) * (1.0f / ((_315 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
    _364 = (saturate((exp2(((log2((max(0.0f, (((_331 * 18.8515625f) + 0.8359375f) * (1.0f / ((_331 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
    _365 = (saturate((exp2(((log2((max(0.0f, (((_347 * 18.8515625f) + 0.8359375f) * (1.0f / ((_347 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
  }
  bool _366 = (_187 < 1.0f);
  _431 = _360;
  _432 = _361;
  _433 = _362;
  if (_366) {
    float4 _375 = BT2020PQ1000ToBT2020PQ250LUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((_363 * 0.96875f) + 0.015625f), ((_364 * 0.96875f) + 0.015625f), ((_365 * 0.96875f) + 0.015625f)), 0.0f);
    float _382 = exp2(((log2((saturate((_375.x))))) * 0.012683313339948654f));
    float _392 = (exp2(((log2((max(0.0f, ((_382 + -0.8359375f) * (1.0f / (18.8515625f - (_382 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
    float _396 = exp2(((log2((saturate((_375.y))))) * 0.012683313339948654f));
    float _406 = (exp2(((log2((max(0.0f, ((_396 + -0.8359375f) * (1.0f / (18.8515625f - (_396 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
    float _410 = exp2(((log2((saturate((_375.z))))) * 0.012683313339948654f));
    float _420 = (exp2(((log2((max(0.0f, ((_410 + -0.8359375f) * (1.0f / (18.8515625f - (_410 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
    _431 = (((_360 - _392) * _187) + _392);
    _432 = (((_361 - _406) * _187) + _406);
    _433 = (((_362 - _420) * _187) + _420);
  }
  _683 = _431;
  _684 = _432;
  _685 = _433;
  if ((!((Globals_053x) == 0.0f))) {
    float4 _441 = CompositeSurfaceTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(((_119 * (_57 + -0.5f)) + 0.5f), ((_120 * (_58 + -0.5f)) + 0.5f)), 0.0f);
    if ((!((Globals_053y) == 0.0f))) {
      float _450 = exp2(((log2((saturate(((_441.x) * 9.999999747378752e-05f))))) * 0.1593017578125f));
      float _466 = exp2(((log2((saturate(((_441.y) * 9.999999747378752e-05f))))) * 0.1593017578125f));
      float _482 = exp2(((log2((saturate(((_441.z) * 9.999999747378752e-05f))))) * 0.1593017578125f));
      _564 = (_441.x);
      _565 = (_441.y);
      _566 = (_441.z);
      _567 = (saturate((exp2(((log2((max(0.0f, (((_450 * 18.8515625f) + 0.8359375f) * (1.0f / ((_450 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
      _568 = (saturate((exp2(((log2((max(0.0f, (((_466 * 18.8515625f) + 0.8359375f) * (1.0f / ((_466 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
      _569 = (saturate((exp2(((log2((max(0.0f, (((_482 * 18.8515625f) + 0.8359375f) * (1.0f / ((_482 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
      do {
        if (_289) {
          float _496 = 1.0f - (_185 * 0.2928932309150696f);
          float _509 = exp2(((log2((saturate(((_441.x) * 0.0010000000474974513f))))) * _496));
          float _510 = exp2(((log2((saturate(((_441.y) * 0.0010000000474974513f))))) * _496));
          float _511 = exp2(((log2((saturate(((_441.z) * 0.0010000000474974513f))))) * _496));
          float _519 = exp2(((log2((saturate((_509 * 0.09999999403953552f))))) * 0.1593017578125f));
          float _535 = exp2(((log2((saturate((_510 * 0.09999999403953552f))))) * 0.1593017578125f));
          float _551 = exp2(((log2((saturate((_511 * 0.09999999403953552f))))) * 0.1593017578125f));
          _564 = (_509 * 1000.0f);
          _565 = (_510 * 1000.0f);
          _566 = (_511 * 1000.0f);
          _567 = (saturate((exp2(((log2((max(0.0f, (((_519 * 18.8515625f) + 0.8359375f) * (1.0f / ((_519 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
          _568 = (saturate((exp2(((log2((max(0.0f, (((_535 * 18.8515625f) + 0.8359375f) * (1.0f / ((_535 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
          _569 = (saturate((exp2(((log2((max(0.0f, (((_551 * 18.8515625f) + 0.8359375f) * (1.0f / ((_551 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
        }
        _683 = _564;
        _684 = _565;
        _685 = _566;
        if (_366) {
          float4 _578 = BT2020PQ1000ToBT2020PQ250LUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((_567 * 0.96875f) + 0.015625f), ((_568 * 0.96875f) + 0.015625f), ((_569 * 0.96875f) + 0.015625f)), 0.0f);
          float _585 = exp2(((log2((saturate((_578.x))))) * 0.012683313339948654f));
          float _595 = (exp2(((log2((max(0.0f, ((_585 + -0.8359375f) * (1.0f / (18.8515625f - (_585 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
          float _599 = exp2(((log2((saturate((_578.y))))) * 0.012683313339948654f));
          float _609 = (exp2(((log2((max(0.0f, ((_599 + -0.8359375f) * (1.0f / (18.8515625f - (_599 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
          float _613 = exp2(((log2((saturate((_578.z))))) * 0.012683313339948654f));
          float _623 = (exp2(((log2((max(0.0f, ((_613 + -0.8359375f) * (1.0f / (18.8515625f - (_613 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
          _683 = (((_564 - _595) * _187) + _595);
          _684 = (((_565 - _609) * _187) + _609);
          _685 = (((_566 - _623) * _187) + _623);
        }
      } while (false);
    } else {
      do {
        if ((((_441.x) < 0.0031308000907301903f))) {
          _644 = ((_441.x) * 12.920000076293945f);
        } else {
          _644 = (((exp2(((log2((_441.x))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if ((((_441.y) < 0.0031308000907301903f))) {
            _655 = ((_441.y) * 12.920000076293945f);
          } else {
            _655 = (((exp2(((log2((_441.y))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          do {
            if ((((_441.z) < 0.0031308000907301903f))) {
              _666 = ((_441.z) * 12.920000076293945f);
            } else {
              _666 = (((exp2(((log2((_441.z))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
            }
            float _673 = exp2(((log2(_644)) * 2.200000047683716f));
            float _674 = exp2(((log2(_655)) * 2.200000047683716f));
            float _675 = exp2(((log2(_666)) * 2.200000047683716f));
            _683 = ((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_673, _674, _675))) * 250.0f);
            _684 = ((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_673, _674, _675))) * 250.0f);
            _685 = ((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_673, _674, _675))) * 250.0f);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  float4 _687 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(((_119 * (_43 + -0.5f)) + 0.5f), ((_120 * (_44 + -0.5f)) + 0.5f)), 0.0f);
  if ((((_687.x) < 0.0031308000907301903f))) {
    _702 = ((_687.x) * 12.920000076293945f);
  } else {
    _702 = (((exp2(((log2((_687.x))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_687.y) < 0.0031308000907301903f))) {
    _713 = ((_687.y) * 12.920000076293945f);
  } else {
    _713 = (((exp2(((log2((_687.y))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_687.z) < 0.0031308000907301903f))) {
    _724 = ((_687.z) * 12.920000076293945f);
  } else {
    _724 = (((exp2(((log2((_687.z))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _725 = (_687.w) * (_687.w);
  float _732 = 1.0f / ((_683 * 0.004000000189989805f) + 1.0f);
  float _733 = 1.0f / ((_684 * 0.004000000189989805f) + 1.0f);
  float _734 = 1.0f / ((_685 * 0.004000000189989805f) + 1.0f);
  float _756 = exp2(((log2(_702)) * 2.200000047683716f));
  float _757 = exp2(((log2(_713)) * 2.200000047683716f));
  float _758 = exp2(((log2(_724)) * 2.200000047683716f));
  float _772 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_756, _757, _758))) * 250.0f) + (((_687.w) * _683) * (((1.0f - _732) * _725) + _732))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _783 = saturate((exp2(((log2((max(0.0f, (((_772 * 18.8515625f) + 0.8359375f) * (1.0f / ((_772 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _788 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_756, _757, _758))) * 250.0f) + (((_687.w) * _684) * (((1.0f - _733) * _725) + _733))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _799 = saturate((exp2(((log2((max(0.0f, (((_788 * 18.8515625f) + 0.8359375f) * (1.0f / ((_788 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _804 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_756, _757, _758))) * 250.0f) + (((_687.w) * _685) * (((1.0f - _734) * _725) + _734))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _815 = saturate((exp2(((log2((max(0.0f, (((_804 * 18.8515625f) + 0.8359375f) * (1.0f / ((_804 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _817 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(24)) & 127), ((int(25)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _834 = ((1.0f - (sqrt((1.0f - (abs(_817)))))) * (float(((int(((bool)((_817 > 0.0f))))) - (int(((bool)((_817 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_783 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_834 + _783) : _783))));
  SV_Target.y = (saturate(((((bool)((((abs(((_799 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_834 + _799) : _799))));
  SV_Target.z = (saturate(((((bool)((((abs(((_815 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_834 + _815) : _815))));
  SV_Target.w = 0.0f;
  return SV_Target;
}
