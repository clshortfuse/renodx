Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);

Texture2D<float4> ColorTexture : register(t1);

Texture2D<float4> GlareTexture : register(t2);

Texture2D<float4> CompositeSDRTexture : register(t3);

Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);

Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t5);

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
  bool _19 = !((Globals_054z) == 0.0f);
  float _35 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _36 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _42 = saturate((_35 * (Globals_044z)));
  float _43 = saturate((_36 * (Globals_044w)));
  float _56 = (_19 ? (saturate(((Globals_044z) * (((floor((_35 * 0.5f))) * 2.0f) + 1.0f)))) : _42);
  float _57 = (_19 ? (saturate(((((floor((_36 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _43);
  float4 _126 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x) * _56) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y) * _57) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);
  float _138 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _143 = (_138 * _138) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _138), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _138))))));
  float _147 = (((_143 * _143) + -1.0f) * (Globals_048x)) + 1.0f;
  float _148 = _147 * (min((_126.x), 65504.0f));
  float _149 = _147 * (min((_126.y), 65504.0f));
  float _150 = _147 * (min((_126.z), 65504.0f));
  float4 _152 = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_037x) * _56) + (float((uint)(Globals_036x)))) * (Globals_034z)), (Globals_040x))), (Globals_040z))), (min((max(((((Globals_037y) * _57) + (float((uint)(Globals_036y)))) * (Globals_034w)), (Globals_040y))), (Globals_040w)))), 0.0f);
  float _178 = saturate((Globals_054x));
  float _180 = saturate((Globals_054y));
  float _185 = exp2(((log2((saturate(((((Globals_049x) * (((min((_152.x), 65504.0f)) - _148) + (_148 * (_152.w)))) + _148) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _201 = exp2(((log2((saturate(((((Globals_049x) * (((min((_152.y), 65504.0f)) - _149) + (_149 * (_152.w)))) + _149) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _217 = exp2(((log2((saturate(((((Globals_049x) * (((_150 * (_152.w)) - _150) + (min((_152.z), 65504.0f)))) + _150) * 0.009999999776482582f))))) * 0.1593017578125f));
  float4 _236 = BT709PQToBT2020PQLUT.SampleLevel(View_SharedBilinearClampedSampler, float3((((saturate((exp2(((log2((max(0.0f, (((_185 * 18.8515625f) + 0.8359375f) * (1.0f / ((_185 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_201 * 18.8515625f) + 0.8359375f) * (1.0f / ((_201 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f), (((saturate((exp2(((log2((max(0.0f, (((_217 * 18.8515625f) + 0.8359375f) * (1.0f / ((_217 * 18.6875f) + 1.0f))))))) * 78.84375f))))) * 0.96875f) + 0.015625f)), 0.0f);
  float _243 = exp2(((log2((saturate((_236.x))))) * 0.012683313339948654f));
  float _252 = exp2(((log2((max(0.0f, ((_243 + -0.8359375f) * (1.0f / (18.8515625f - (_243 * 18.6875f)))))))) * 6.277394771575928f));
  float _257 = exp2(((log2((saturate((_236.y))))) * 0.012683313339948654f));
  float _266 = exp2(((log2((max(0.0f, ((_257 + -0.8359375f) * (1.0f / (18.8515625f - (_257 * 18.6875f)))))))) * 6.277394771575928f));
  float _271 = exp2(((log2((saturate((_236.z))))) * 0.012683313339948654f));
  float _280 = exp2(((log2((max(0.0f, ((_271 + -0.8359375f) * (1.0f / (18.8515625f - (_271 * 18.6875f)))))))) * 6.277394771575928f));
  float _353 = (_252 * 10000.0f);
  float _354 = (_266 * 10000.0f);
  float _355 = (_280 * 10000.0f);
  float _356 = (_236.x);
  float _357 = (_236.y);
  float _358 = (_236.z);
  float _424;
  float _425;
  float _426;
  float _443;
  float _454;
  float _465;
  if (((_178 > 0.0f))) {
    float _285 = 1.0f - (_178 * 0.2928932309150696f);
    float _298 = exp2(((log2((saturate((_252 * 10.0f))))) * _285));
    float _299 = exp2(((log2((saturate((_266 * 10.0f))))) * _285));
    float _300 = exp2(((log2((saturate((_280 * 10.0f))))) * _285));
    float _308 = exp2(((log2((saturate((_298 * 0.09999999403953552f))))) * 0.1593017578125f));
    float _324 = exp2(((log2((saturate((_299 * 0.09999999403953552f))))) * 0.1593017578125f));
    float _340 = exp2(((log2((saturate((_300 * 0.09999999403953552f))))) * 0.1593017578125f));
    _353 = (_298 * 1000.0f);
    _354 = (_299 * 1000.0f);
    _355 = (_300 * 1000.0f);
    _356 = (saturate((exp2(((log2((max(0.0f, (((_308 * 18.8515625f) + 0.8359375f) * (1.0f / ((_308 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
    _357 = (saturate((exp2(((log2((max(0.0f, (((_324 * 18.8515625f) + 0.8359375f) * (1.0f / ((_324 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
    _358 = (saturate((exp2(((log2((max(0.0f, (((_340 * 18.8515625f) + 0.8359375f) * (1.0f / ((_340 * 18.6875f) + 1.0f))))))) * 78.84375f)))));
  }
  _424 = _353;
  _425 = _354;
  _426 = _355;
  if (((_180 < 1.0f))) {
    float4 _368 = BT2020PQ1000ToBT2020PQ250LUT.SampleLevel(View_SharedBilinearClampedSampler, float3(((_356 * 0.96875f) + 0.015625f), ((_357 * 0.96875f) + 0.015625f), ((_358 * 0.96875f) + 0.015625f)), 0.0f);
    float _375 = exp2(((log2((saturate((_368.x))))) * 0.012683313339948654f));
    float _385 = (exp2(((log2((max(0.0f, ((_375 + -0.8359375f) * (1.0f / (18.8515625f - (_375 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
    float _389 = exp2(((log2((saturate((_368.y))))) * 0.012683313339948654f));
    float _399 = (exp2(((log2((max(0.0f, ((_389 + -0.8359375f) * (1.0f / (18.8515625f - (_389 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
    float _403 = exp2(((log2((saturate((_368.z))))) * 0.012683313339948654f));
    float _413 = (exp2(((log2((max(0.0f, ((_403 + -0.8359375f) * (1.0f / (18.8515625f - (_403 * 18.6875f)))))))) * 6.277394771575928f))) * 10000.0f;
    _424 = (((_353 - _385) * _180) + _385);
    _425 = (((_354 - _399) * _180) + _399);
    _426 = (((_355 - _413) * _180) + _413);
  }
  float4 _428 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((((min((((Globals_044x) * 0.5625f) * (Globals_044w)), 1.0f)) * (_42 + -0.5f)) + 0.5f), (((min((((Globals_044y) * 1.7777777910232544f) * (Globals_044z)), 1.0f)) * (_43 + -0.5f)) + 0.5f)), 0.0f);
  if ((((_428.x) < 0.0031308000907301903f))) {
    _443 = ((_428.x) * 12.920000076293945f);
  } else {
    _443 = (((exp2(((log2((_428.x))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_428.y) < 0.0031308000907301903f))) {
    _454 = ((_428.y) * 12.920000076293945f);
  } else {
    _454 = (((exp2(((log2((_428.y))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if ((((_428.z) < 0.0031308000907301903f))) {
    _465 = ((_428.z) * 12.920000076293945f);
  } else {
    _465 = (((exp2(((log2((_428.z))) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _466 = (_428.w) * (_428.w);
  float _473 = 1.0f / ((_424 * 0.004000000189989805f) + 1.0f);
  float _474 = 1.0f / ((_425 * 0.004000000189989805f) + 1.0f);
  float _475 = 1.0f / ((_426 * 0.004000000189989805f) + 1.0f);
  float _497 = exp2(((log2(_443)) * 2.200000047683716f));
  float _498 = exp2(((log2(_454)) * 2.200000047683716f));
  float _499 = exp2(((log2(_465)) * 2.200000047683716f));
  float _513 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_497, _498, _499))) * 250.0f) + (((_428.w) * _424) * (((1.0f - _473) * _466) + _473))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _524 = saturate((exp2(((log2((max(0.0f, (((_513 * 18.8515625f) + 0.8359375f) * (1.0f / ((_513 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _529 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_497, _498, _499))) * 250.0f) + (((_428.w) * _425) * (((1.0f - _474) * _466) + _474))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _540 = saturate((exp2(((log2((max(0.0f, (((_529 * 18.8515625f) + 0.8359375f) * (1.0f / ((_529 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _545 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_497, _498, _499))) * 250.0f) + (((_428.w) * _426) * (((1.0f - _475) * _466) + _475))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _556 = saturate((exp2(((log2((max(0.0f, (((_545 * 18.8515625f) + 0.8359375f) * (1.0f / ((_545 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _558 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(23)) & 127), ((int(24)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _575 = ((1.0f - (sqrt((1.0f - (abs(_558)))))) * (float(((int(((bool)((_558 > 0.0f))))) - (int(((bool)((_558 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_524 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_575 + _524) : _524))));
  SV_Target.y = (saturate(((((bool)((((abs(((_540 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_575 + _540) : _540))));
  SV_Target.z = (saturate(((((bool)((((abs(((_556 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_575 + _556) : _556))));
  SV_Target.w = 0.0f;
  return SV_Target;
}
