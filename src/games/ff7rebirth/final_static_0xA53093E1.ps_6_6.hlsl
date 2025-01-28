Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);

cbuffer $Globals : register(b0) {
  float $Globals_027z : packoffset(c027.z);
  float $Globals_027w : packoffset(c027.w);
  uint $Globals_029x : packoffset(c029.x);
  uint $Globals_029y : packoffset(c029.y);
  float $Globals_030x : packoffset(c030.x);
  float $Globals_030y : packoffset(c030.y);
  float $Globals_033x : packoffset(c033.x);
  float $Globals_033y : packoffset(c033.y);
  float $Globals_033z : packoffset(c033.z);
  float $Globals_033w : packoffset(c033.w);
  float $Globals_034z : packoffset(c034.z);
  float $Globals_034w : packoffset(c034.w);
  uint $Globals_036x : packoffset(c036.x);
  uint $Globals_036y : packoffset(c036.y);
  float $Globals_037x : packoffset(c037.x);
  float $Globals_037y : packoffset(c037.y);
  float $Globals_040x : packoffset(c040.x);
  float $Globals_040y : packoffset(c040.y);
  float $Globals_040z : packoffset(c040.z);
  float $Globals_040w : packoffset(c040.w);
  uint $Globals_043x : packoffset(c043.x);
  uint $Globals_043y : packoffset(c043.y);
  float $Globals_044x : packoffset(c044.x);
  float $Globals_044y : packoffset(c044.y);
  float $Globals_044z : packoffset(c044.z);
  float $Globals_044w : packoffset(c044.w);
  float $Globals_048x : packoffset(c048.x);
  float $Globals_048y : packoffset(c048.y);
  float $Globals_049x : packoffset(c049.x);
  float $Globals_050x : packoffset(c050.x);
  float $Globals_050y : packoffset(c050.y);
  float $Globals_050z : packoffset(c050.z);
  float $Globals_050w : packoffset(c050.w);
  float $Globals_054z : packoffset(c054.z);
};

cbuffer View : register(b1) {
  float View_164y : packoffset(c164.y);
  float View_164z : packoffset(c164.z);
  uint View_175x : packoffset(c175.x);
};

SamplerState View_SharedBilinearClampedSampler : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 TEXCOORD_1 : TEXCOORD1,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  bool _18 = !(($Globals_054z) == 0.0f);
  int _22 = int(22);
  int _23 = int(23);
  float _34 = (SV_Position.x) - (float((uint)($Globals_043x)));
  float _35 = (SV_Position.y) - (float((uint)($Globals_043y)));
  float _41 = saturate((_34 * ($Globals_044z)));
  float _42 = saturate((_35 * ($Globals_044w)));
  float _55 = (_18 ? (saturate((($Globals_044z) * (((floor((_34 * 0.5f))) * 2.0f) + 1.0f)))) : _41);
  float _56 = (_18 ? (saturate(((((floor((_35 * 0.5f))) * 2.0f) + 1.0f) * ($Globals_044w)))) : _42);
  float4 _125 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max((((($Globals_030x) * _55) + (float((uint)($Globals_029x)))) * ($Globals_027z)), ($Globals_033x))), ($Globals_033z))), (min((max((((($Globals_030y) * _56) + (float((uint)($Globals_029y)))) * ($Globals_027w)), ($Globals_033y))), ($Globals_033w)))), 0.0f);
  float _137 = (1.0f / (max(0.0010000000474974513f, ($Globals_048y)))) * (TEXCOORD_1.z);
  float _142 = (_137 * _137) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137))))));
  float _146 = (((_142 * _142) + -1.0f) * ($Globals_048x)) + 1.0f;
  float _147 = _146 * (min((_125.x), 65504.0f));
  float _148 = _146 * (min((_125.y), 65504.0f));
  float _149 = _146 * (min((_125.z), 65504.0f));
  float4 _151 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max((((($Globals_037x) * _55) + (float((uint)($Globals_036x)))) * ($Globals_034z)), ($Globals_040x))), ($Globals_040z))), (min((max((((($Globals_037y) * _56) + (float((uint)($Globals_036y)))) * ($Globals_034w)), ($Globals_040y))), ($Globals_040w)))), 0.0f);
  float _179 = saturate((($Globals_030x) * 0.0002604166802484542f));
  float _180 = float(_22);
  float _182 = _180 * 0.6180340051651001f;
  float _183 = (float(_23)) * 0.6180340051651001f;
  float _191 = max(1.0000000116860974e-07f, (frac(((tan((sqrt(((_183 * _183) + (_182 * _182)))))) * _180))));
  float _194 = floor(((frac(($Globals_050w))) * 59.940059661865234f));
  float _195 = _191 + 0.3333333432674408f;
  float _196 = _191 + 0.6666666865348816f;
  float _197 = _194 * 63.13124465942383f;
  float _207 = ((frac((_197 + _191))) * 2.0f) + -1.0f;
  float _208 = ((frac((_195 + _197))) * 2.0f) + -1.0f;
  float _209 = ((frac((_196 + _197))) * 2.0f) + -1.0f;
  float _211 = (_194 + 1.0f) * 63.13124465942383f;
  float _221 = ((frac((_211 + _191))) * 2.0f) + -1.0f;
  float _222 = ((frac((_195 + _211))) * 2.0f) + -1.0f;
  float _223 = ((frac((_196 + _211))) * 2.0f) + -1.0f;
  float _233 = (((bool)(((abs(_207)) > (abs(_221))))) ? _207 : _221);
  float _234 = (((bool)(((abs(_208)) > (abs(_222))))) ? _208 : _222);
  float _235 = (((bool)(((abs(_209)) > (abs(_223))))) ? _209 : _223);
  float _236 = _179 * _179;
  float _281 = (((View_164z) + -1.0f) * ($Globals_050z)) + 1.0f;
  float _285 = ((((float(((int(((bool)((_233 > 0.0f))))) - (int(((bool)((_233 < 0.0f)))))))) * ($Globals_050x)) * (1.0f - (exp2(((log2((max(0.0f, (1.0f - (abs(_233))))))) * _236))))) * (View_164y)) * _281;
  float _289 = ((((float(((int(((bool)((_234 > 0.0f))))) - (int(((bool)((_234 < 0.0f)))))))) * ($Globals_050x)) * (1.0f - (exp2(((log2((max(0.0f, (1.0f - (abs(_234))))))) * _236))))) * (View_164y)) * _281;
  float _293 = ((((float(((int(((bool)((_235 > 0.0f))))) - (int(((bool)((_235 < 0.0f)))))))) * ($Globals_050x)) * (1.0f - (exp2(((log2((max(0.0f, (1.0f - (abs(_235))))))) * _236))))) * (View_164y)) * _281;
  float _294 = dot(float3(_285, _289, _293), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _317 = exp2(((log2((saturate(((max(0.0f, ((((($Globals_049x) * (((min((_151.x), 65504.0f)) - _147) + (_147 * (_151.w)))) + _147) + _285) + ((_294 - _285) * ($Globals_050y))))) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _333 = exp2(((log2((saturate(((max(0.0f, ((((($Globals_049x) * (((min((_151.y), 65504.0f)) - _148) + (_148 * (_151.w)))) + _148) + _289) + ((_294 - _289) * ($Globals_050y))))) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _349 = exp2(((log2((saturate(((max(0.0f, ((((($Globals_049x) * (((_149 * (_151.w)) - _149) + (min((_151.z), 65504.0f)))) + _149) + _293) + ((_294 - _293) * ($Globals_050y))))) * 0.009999999776482582f))))) * 0.1593017578125f));
  float4 _368 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((((saturate((exp2(((log2((max(0.0f, (((_317 * 18.8515625f) + 0.8359375f) * (1.0f / ((_317 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_333 * 18.8515625f) + 0.8359375f) * (1.0f / ((_333 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_349 * 18.8515625f) + 0.8359375f) * (1.0f / ((_349 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f)), 0.0f);
  float _375 = exp2(((log2((saturate((_368.x))))) * 0.012683313339948654f));
  float _384 = exp2(((log2((max(0.0f, ((_375 + -0.8359375f) * (1.0f / (18.8515625f - (_375 * 18.6875f)))))))) * 6.277394771575928f));
  float _389 = exp2(((log2((saturate((_368.y))))) * 0.012683313339948654f));
  float _398 = exp2(((log2((max(0.0f, ((_389 + -0.8359375f) * (1.0f / (18.8515625f - (_389 * 18.6875f)))))))) * 6.277394771575928f));
  float _403 = exp2(((log2((saturate((_368.z))))) * 0.012683313339948654f));
  float _412 = exp2(((log2((max(0.0f, ((_403 + -0.8359375f) * (1.0f / (18.8515625f - (_403 * 18.6875f)))))))) * 6.277394771575928f));
  float4 _415 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((((min(((($Globals_044x) * 0.5625f) * ($Globals_044w)), 1.0f)) * (_41 + -0.5f)) + 0.5f), (((min(((($Globals_044y) * 1.7777777910232544f) * ($Globals_044z)), 1.0f)) * (_42 + -0.5f)) + 0.5f)), 0.0f);
  float _430;
  float _441;
  float _452;
  if ((((_415.x) < 0.0031308000907301903f))) {
    _430 = ((_415.x) * 12.920000076293945f);
  } else {
    _430 = (((exp2(((log2((_415.x))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_415.y) < 0.0031308000907301903f))) {
    _441 = ((_415.y) * 12.920000076293945f);
  } else {
    _441 = (((exp2(((log2((_415.y))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_415.z) < 0.0031308000907301903f))) {
    _452 = ((_415.z) * 12.920000076293945f);
  } else {
    _452 = (((exp2(((log2((_415.z))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _453 = (_415.w) * (_415.w);
  float _460 = 1.0f / ((_384 * 40.0f) + 1.0f);
  float _461 = 1.0f / ((_398 * 40.0f) + 1.0f);
  float _462 = 1.0f / ((_412 * 40.0f) + 1.0f);
  float _484 = exp2(((log2(_430)) * 2.200000047683716f));
  float _485 = exp2(((log2(_441)) * 2.200000047683716f));
  float _486 = exp2(((log2(_452)) * 2.200000047683716f));
  float _500 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_484, _485, _486))) * 250.0f) + (((_384 * 10000.0f) * (_415.w)) * (((1.0f - _460) * _453) + _460))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _511 = saturate((exp2(((log2((max(0.0f, (((_500 * 18.8515625f) + 0.8359375f) * (1.0f / ((_500 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _516 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_484, _485, _486))) * 250.0f) + (((_398 * 10000.0f) * (_415.w)) * (((1.0f - _461) * _453) + _461))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _527 = saturate((exp2(((log2((max(0.0f, (((_516 * 18.8515625f) + 0.8359375f) * (1.0f / ((_516 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _532 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_484, _485, _486))) * 250.0f) + (((_412 * 10000.0f) * (_415.w)) * (((1.0f - _462) * _453) + _462))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _543 = saturate((exp2(((log2((max(0.0f, (((_532 * 18.8515625f) + 0.8359375f) * (1.0f / ((_532 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _545 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4((_22 & 127), (_23 & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _562 = ((1.0f - (sqrt((1.0f - (abs(_545)))))) * (float(((int(((bool)((_545 > 0.0f))))) - (int(((bool)((_545 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_511 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_562 + _511) : _511))));
  SV_Target.y = (saturate(((((bool)((((abs(((_527 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_562 + _527) : _527))));
  SV_Target.z = (saturate(((((bool)((((abs(((_543 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_562 + _543) : _543))));
  SV_Target.w = 0.0f;
  return SV_Target;
}
