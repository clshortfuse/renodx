#include "sky_spectral_common.hlsl"

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTMultiGather : register(t63, space36);

RWTexture3D<float4> __3__48__0__1__g_texPrecomputedLUTMultiUAV : register(u2, space48);

RWTexture3D<float4> __3__48__0__1__g_texPrecomputedLUTMultiTempUAV : register(u3, space48);

RWTexture3D<float4> __3__48__0__1__g_texPrecomputedLUTMultiMieUAV : register(u6, space48);

RWTexture3D<float4> __3__48__0__1__g_texPrecomputedLUTMultiTempMieUAV : register(u7, space48);

cbuffer __3__35__0__0__AtmosphereConstantBuffer : register(b13, space35) {
  float _sunLightIntensity : packoffset(c000.x);
  float _sunLightPreset : packoffset(c000.y);
  float _sunSizeAngle : packoffset(c000.z);
  float _sunDirX : packoffset(c000.w);
  float _sunDirY : packoffset(c001.x);
  float _moonLightIntensity : packoffset(c001.y);
  float _moonLightPreset : packoffset(c001.z);
  float _moonSizeAngle : packoffset(c001.w);
  float _moonDirX : packoffset(c002.x);
  float _moonDirY : packoffset(c002.y);
  float _earthAxisTilt : packoffset(c002.z);
  float _latitude : packoffset(c002.w);
  float _earthRadius : packoffset(c003.x);
  float _atmosphereThickness : packoffset(c003.y);
  float _rayleighScaledHeight : packoffset(c003.z);
  uint _rayleighScatteringColor : packoffset(c003.w);
  float _mieScaledHeight : packoffset(c004.x);
  float _mieAerosolDensity : packoffset(c004.y);
  float _mieAerosolAbsorption : packoffset(c004.z);
  float _miePhaseConst : packoffset(c004.w);
  float _ozoneRatio : packoffset(c005.x);
  float _directionalLightLuminanceScale : packoffset(c005.y);
  float _distanceScale : packoffset(c005.z);
  float _heightFogDensity : packoffset(c005.w);
  float _heightFogBaseline : packoffset(c006.x);
  float _heightFogFalloff : packoffset(c006.y);
  float _heightFogScale : packoffset(c006.z);
  float _cloudBaseDensity : packoffset(c006.w);
  float _cloudBaseContrast : packoffset(c007.x);
  float _cloudBaseScale : packoffset(c007.y);
  float _cloudAlpha : packoffset(c007.z);
  float _cloudScrollMultiplier : packoffset(c007.w);
  float _cloudScatteringCoefficient : packoffset(c008.x);
  float _cloudPhaseConstFront : packoffset(c008.y);
  float _cloudPhaseConstBack : packoffset(c008.z);
  float _cloudAltitude : packoffset(c008.w);
  float _cloudThickness : packoffset(c009.x);
  float _cloudVisibleRange : packoffset(c009.y);
  float _cloudNear : packoffset(c009.z);
  float _cloudFadeRange : packoffset(c009.w);
  float _cloudDetailRatio : packoffset(c010.x);
  float _cloudDetailScale : packoffset(c010.y);
  float _cloudMultiRatio : packoffset(c010.z);
  float _cloudBeerPowderRatio : packoffset(c010.w);
  float _cloudCirrusAltitude : packoffset(c011.x);
  float _cloudCirrusDensity : packoffset(c011.y);
  float _cloudCirrusScale : packoffset(c011.z);
  float _cloudCirrusWeightR : packoffset(c011.w);
  float _cloudCirrusWeightG : packoffset(c012.x);
  float _cloudCirrusWeightB : packoffset(c012.y);
  float _cloudFlow : packoffset(c012.z);
  float _cloudSeed : packoffset(c012.w);
  float4 _volumeFogScatterColor : packoffset(c013.x);
  float4 _mieScatterColor : packoffset(c014.x);
};

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _renderFlags : packoffset(c000.x);
  float4 _skyColor : packoffset(c001.x);
  float4 _volumeSize : packoffset(c002.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(4, 4, 4)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  uint _23 = uint(((_volumeSize.w * _volumeSize.y) * _renderFlags.x) + float((uint)SV_DispatchThreadID.y));
  float _30 = float((uint)_23) / _volumeSize.y;
  float _36 = saturate(((float((uint)SV_DispatchThreadID.x) / _volumeSize.x) * 1.0322580337524414f) + -0.016129031777381897f);
  float _41 = _atmosphereThickness + -32.0f;
  float _43 = ((_36 * _36) * _41) + 16.0f;
  float _44 = max(_43, 0.0f);
  float _46 = _earthRadius * 2.0f;
  float _52 = (-0.0f - sqrt((_46 + _44) * _44)) / (_earthRadius + _44);
  float _79;
  float _116;
  float _131;
  float _136;
  float _202;
  float _223;
  float _224;
  float _225;
  float _226;
  float _227;
  float _228;
  float _229;
  float _230;
  int _231;
  float _232;
  float _233;
  float _234;
  float _235;
  float _236;
  float _237;
  float _238;
  float _239;
  float _354;
  float _405;
  float _406;
  float _407;
  float _408;
  float _409;
  float _410;
  if (_30 > 0.5f) {
    _79 = max(((exp2(log2(saturate((_30 + -0.50390625f) * 2.0317461490631104f)) * 5.0f) * (1.0f - _52)) + _52), (_52 + 9.999999747378752e-05f));
  } else {
    _79 = min((_52 - (exp2(log2(saturate((_30 + -0.00390625f) * 2.0317461490631104f)) * 5.0f) * (_52 + 1.0f))), (_52 + -9.999999747378752e-05f));
  }
  float _86 = min(max(_79, -1.0f), 1.0f);
  float _88 = min(max((-0.2857142984867096f - (log2(1.0f - (saturate(((float((uint)SV_DispatchThreadID.z) / _volumeSize.z) * 1.0322580337524414f) + -0.016129031777381897f) * 0.9726762771606445f)) * 0.24755257368087769f)), -1.0f), 1.0f);
  float _92 = sqrt(saturate(1.0f - (_86 * _86)));
  float _96 = sqrt(saturate(1.0f - (_88 * _88)));
  float _97 = _atmosphereThickness + _earthRadius;
  float _98 = _43 + _earthRadius;
  float _99 = dot(float3(_92, _86, 0.0f), float3(_92, _86, 0.0f));
  float _101 = dot(float3(0.0f, _98, 0.0f), float3(_92, _86, 0.0f)) * 2.0f;
  float _102 = dot(float3(0.0f, _98, 0.0f), float3(0.0f, _98, 0.0f));
  float _105 = _101 * _101;
  float _106 = _99 * 4.0f;
  float _108 = _105 - ((_102 - (_97 * _97)) * _106);
  if (!(_108 < 0.0f)) {
    _116 = ((sqrt(_108) - _101) / (_99 * 2.0f));
  } else {
    _116 = -1.0f;
  }
  if (!(_116 < 0.0f)) {
    float _122 = _105 - ((_102 - (_earthRadius * _earthRadius)) * _106);
    if (!(_122 < 0.0f)) {
      _131 = (((-0.0f - _101) - sqrt(_122)) / (_99 * 2.0f));
    } else {
      _131 = -1.0f;
    }
    if (_131 > 0.0f) {
      _136 = min(_116, _131);
    } else {
      _136 = _116;
    }
    float _137 = _136 * _92;
    float _138 = _136 * _86;
    float _139 = _137 * 0.0078125f;
    float _140 = _138 * 0.0078125f;
    float _144 = sqrt((_139 * _139) + (_140 * _140));
    float _145 = _139 / _144;
    float _146 = _140 / _144;
    float _148 = sqrt(_98 * _98);
    float _149 = _98 / _148;
    float _151 = max((_148 - _earthRadius), 0.009999999776482582f);
    float _152 = -0.0f - _151;
    float _160 = exp2((_152 / _rayleighScaledHeight) * 1.4426950216293335f);
    float _161 = exp2((_152 / _mieScaledHeight) * 1.4426950216293335f);
    float _163 = dot(float3(0.0f, _149, 0.0f), float3(_145, _146, 0.0f));
    float _166 = min(max(_151, 16.0f), (_atmosphereThickness + -16.0f));
    float _173 = max(_166, 0.0f);
    float _179 = (-0.0f - sqrt((_173 + _46) * _173)) / (_173 + _earthRadius);
    if (_163 > _179) {
      _202 = ((exp2(log2(saturate((_163 - _179) / (1.0f - _179))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
    } else {
      _202 = ((exp2(log2(saturate((_179 - _163) / (_179 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
    }
    float4 _212 = __3__36__0__0__g_texPrecomputedLUTMultiGather.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(((exp2(log2(saturate((_166 + -16.0f) / _41)) * 0.5f) * 0.96875f) + 0.015625f), _202, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(0.0f, _149, 0.0f), float3(_96, _88, 0.0f)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
    _223 = _160;
    _224 = _161;
    _225 = (_212.x * _160);
    _226 = (_212.y * _160);
    _227 = (_212.z * _160);
    _228 = (_212.x * _161);
    _229 = (_212.y * _161);
    _230 = (_212.z * _161);
    _231 = 1;
    _232 = 0.0f;
    _233 = 0.0f;
    _234 = 0.0f;
    _235 = 0.0f;
    _236 = 0.0f;
    _237 = 0.0f;
    _238 = 0.0f;
    _239 = 0.0f;
    while(true) {
      float _241 = float((int)(_231)) * 0.0078125f;
      float _242 = _241 * _137;
      float _244 = (_241 * _138) + _98;
      float _248 = sqrt((_244 * _244) + (_242 * _242));
      float _249 = _242 / _248;
      float _250 = _244 / _248;
      float _254 = max((_248 - _earthRadius), 0.009999999776482582f);
      float _255 = -0.0f - _254;
      float _263 = exp2((_255 / _rayleighScaledHeight) * 1.4426950216293335f);
      float _264 = exp2((_255 / _mieScaledHeight) * 1.4426950216293335f);
      float _267 = _144 * 0.5f;
      float _270 = ((_263 + _223) * _267) + _238;
      float _271 = ((_264 + _224) * _267) + _239;
      float _282 = float((uint)((int)(((uint)((int)(_rayleighScatteringColor)) >> 16) & 255))) * 1.960784317134312e-07f;
      float _283 = float((uint)((int)(((uint)((int)(_rayleighScatteringColor)) >> 8) & 255))) * 1.960784317134312e-07f;
      float _284 = float((uint)((int)(_rayleighScatteringColor & 255))) * 1.960784317134312e-07f;
      // SKY_SCATTERING: override Rayleigh β with Stockman Sharp LMS ratios
      if (SKY_SCATTERING) {
        float _skyBetaRef = _284;  // B channel (S cone, 440nm) as reference
        _282 = _skyBetaRef * SKY_RAYLEIGH_CH1;  // L cone (565nm)
        _283 = _skyBetaRef * SKY_RAYLEIGH_CH2;  // M cone (540nm)
        // _284 unchanged: S cone = B channel (same wavelength)
      }
      float _288 = _mieAerosolDensity * 1.9999999494757503e-05f;
      float _290 = (_288 * (_mieAerosolAbsorption + 1.0f)) * _271;
      float _312 = dot(float3(_249, _250, 0.0f), float3(_145, _146, 0.0f));
      float _316 = min(max(_254, 16.0f), (_atmosphereThickness + -16.0f));
      float _324 = max(_316, 0.0f);
      float _331 = (-0.0f - sqrt((_324 + (_earthRadius * 2.0f)) * _324)) / (_324 + _earthRadius);
      if (_312 > _331) {
        _354 = ((exp2(log2(saturate((_312 - _331) / (1.0f - _331))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _354 = ((exp2(log2(saturate((_331 - _312) / (_331 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float4 _364 = __3__36__0__0__g_texPrecomputedLUTMultiGather.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(((exp2(log2(saturate((_316 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f), _354, ((1.0f - exp2(-1.1541560888290405f - (dot(float3(_249, _250, 0.0f), float3(_96, _88, 0.0f)) * 4.039546012878418f))) * 1.028091311454773f)), 0.0f);
      float _368 = _364.x * exp2((((_282 + (_ozoneRatio * SKY_OZONE_1)) * _270) + _290) * -1.4426950216293335f);
      float _369 = _368 * _263;
      float _370 = _364.y * exp2((((_283 + (_ozoneRatio * SKY_OZONE_2)) * _270) + _290) * -1.4426950216293335f);
      float _371 = _370 * _263;
      float _372 = _364.z * exp2((((_284 + (_ozoneRatio * SKY_OZONE_3)) * _270) + _290) * -1.4426950216293335f);
      float _373 = _372 * _263;
      float _374 = _368 * _264;
      float _375 = _370 * _264;
      float _376 = _372 * _264;
      float _383 = ((_369 + _225) * _267) + _235;
      float _384 = ((_371 + _226) * _267) + _236;
      float _385 = ((_373 + _227) * _267) + _237;
      float _392 = ((_374 + _228) * _267) + _232;
      float _393 = ((_375 + _229) * _267) + _233;
      float _394 = ((_376 + _230) * _267) + _234;
      int _395 = _231 + 1;
      if (!(_395 == 129)) {
        _223 = _263;
        _224 = _264;
        _225 = _369;
        _226 = _371;
        _227 = _373;
        _228 = _374;
        _229 = _375;
        _230 = _376;
        _231 = _395;
        _232 = _392;
        _233 = _393;
        _234 = _394;
        _235 = _383;
        _236 = _384;
        _237 = _385;
        _238 = _270;
        _239 = _271;
        continue;
      }
      _405 = (_392 * _288);
      _406 = (_393 * _288);
      _407 = (_394 * _288);
      _408 = (_282 * _383);
      _409 = (_283 * _384);
      _410 = (_284 * _385);
      break;
    }
  } else {
    _405 = 0.0f;
    _406 = 0.0f;
    _407 = 0.0f;
    _408 = 0.0f;
    _409 = 0.0f;
    _410 = 0.0f;
  }
  float4 _412 = __3__48__0__1__g_texPrecomputedLUTMultiUAV.Load(int3((uint)(SV_DispatchThreadID.x), _23, (uint)(SV_DispatchThreadID.z)));
  __3__48__0__1__g_texPrecomputedLUTMultiUAV[int3((uint)(SV_DispatchThreadID.x), _23, (uint)(SV_DispatchThreadID.z))] = float4((_412.x + _408), (_412.y + _409), (_412.z + _410), (_412.w + _405));
  float4 _422 = __3__48__0__1__g_texPrecomputedLUTMultiMieUAV.Load(int3((uint)(SV_DispatchThreadID.x), _23, (uint)(SV_DispatchThreadID.z)));
  __3__48__0__1__g_texPrecomputedLUTMultiMieUAV[int3((uint)(SV_DispatchThreadID.x), _23, (uint)(SV_DispatchThreadID.z))] = float4((_422.x + _405), (_422.y + _406), (_422.z + _407), _422.w);
  __3__48__0__1__g_texPrecomputedLUTMultiTempUAV[int3((uint)(SV_DispatchThreadID.x), _23, (uint)(SV_DispatchThreadID.z))] = float4(_408, _409, _410, _405);
  __3__48__0__1__g_texPrecomputedLUTMultiTempMieUAV[int3((uint)(SV_DispatchThreadID.x), _23, (uint)(SV_DispatchThreadID.z))] = float4(_405, _406, _407, 0.0f);
}
