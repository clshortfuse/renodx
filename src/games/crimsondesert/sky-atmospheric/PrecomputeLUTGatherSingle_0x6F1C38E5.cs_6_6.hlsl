Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTSingleRayleigh : register(t59, space36);

Texture3D<float4> __3__36__0__0__g_texPrecomputedLUTSingleMie : register(t60, space36);

RWTexture3D<float4> __3__48__0__1__g_texPrecomputedLUTMultiGatherUAV : register(u4, space48);

RWTexture3D<float4> __3__48__0__1__g_texPrecomputedLUTMultiGatherAccumUAV : register(u5, space48);

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
  uint _22 = uint(((_volumeSize.w * _volumeSize.y) * _renderFlags.x) + float((uint)SV_DispatchThreadID.y));
  float _29 = float((uint)_22) / _volumeSize.y;
  float _35 = saturate(((float((uint)SV_DispatchThreadID.x) / _volumeSize.x) * 1.0322580337524414f) + -0.016129031777381897f);
  float _42 = ((_35 * _35) * (_atmosphereThickness + -32.0f)) + 16.0f;
  float _43 = max(_42, 0.0f);
  float _51 = (-0.0f - sqrt(((_earthRadius * 2.0f) + _43) * _43)) / (_earthRadius + _43);
  float _78;
  float _98;
  float _99;
  float _100;
  int _101;
  float _183;
  float _243;
  float _244;
  float _245;
  float _246;
  if (_29 > 0.5f) {
    _78 = max(((exp2(log2(saturate((_29 + -0.50390625f) * 2.0317461490631104f)) * 5.0f) * (1.0f - _51)) + _51), (_51 + 9.999999747378752e-05f));
  } else {
    _78 = min((_51 - (exp2(log2(saturate((_29 + -0.00390625f) * 2.0317461490631104f)) * 5.0f) * (_51 + 1.0f))), (_51 + -9.999999747378752e-05f));
  }
  float _85 = min(max(_78, -1.0f), 1.0f);
  int _92 = int(_volumeSize.y);
  if ((int)_92 > (int)0) {
    _98 = 0.0f;
    _99 = 0.0f;
    _100 = 0.0f;
    _101 = 0;
    while(true) {
      float _103 = float((int)(_92));
      float _129 = float((uint)((uint)((((int)(((uint)((((int)(((uint)((((int)(((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) << 2)) & -858993460) | (((uint)((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) >> 2) & 858993459))) << 4)) & -252645136) | (((uint)((uint)((((int)(((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) << 2)) & -858993460) | (((uint)((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) >> 2) & 858993459))) >> 4) & 252645135))) << 8)) & -16711936) | (((uint)((uint)((((int)(((uint)((((int)(((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) << 2)) & -858993460) | (((uint)((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) >> 2) & 858993459))) << 4)) & -252645136) | (((uint)((uint)((((int)(((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) << 2)) & -858993460) | (((uint)((uint)((((int)(((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) << 1)) & -1431655766) | (((uint)((uint)(((int)((uint)(_101) << 16)) | ((uint)((uint)(_101)) >> 16))) >> 1) & 1431655765))) >> 2) & 858993459))) >> 4) & 252645135))) >> 8) & 16711935)))) * 1.462918119976564e-09f;
      float _132 = ((1.0f - (float((int)(_101)) / _103)) * 2.0f) + -1.0f;
      float _135 = sqrt(1.0f - (_132 * _132));
      float _139 = sin(_129) * _135;
      float _144 = min(max(_42, 16.0f), (_atmosphereThickness + -16.0f));
      float _152 = max(_144, 0.0f);
      float _160 = (-0.0f - sqrt((_152 + (_earthRadius * 2.0f)) * _152)) / (_152 + _earthRadius);
      if (_139 > _160) {
        _183 = ((exp2(log2(saturate((_139 - _160) / (1.0f - _160))) * 0.20000000298023224f) * 0.4921875f) + 0.50390625f);
      } else {
        _183 = ((exp2(log2(saturate((_160 - _139) / (_160 + 1.0f))) * 0.20000000298023224f) * 0.4921875f) + 0.00390625f);
      }
      float _185 = (exp2(log2(saturate((_144 + -16.0f) / (_atmosphereThickness + -32.0f))) * 0.5f) * 0.96875f) + 0.015625f;
      float _190 = (1.0f - exp2(-1.1541560888290405f - (min(max((-0.2857142984867096f - (log2(1.0f - (saturate(((float((uint)SV_DispatchThreadID.z) / _volumeSize.z) * 1.0322580337524414f) + -0.016129031777381897f) * 0.9726762771606445f)) * 0.24755257368087769f)), -1.0f), 1.0f) * 4.039546012878418f))) * 1.028091311454773f;
      float4 _193 = __3__36__0__0__g_texPrecomputedLUTSingleRayleigh.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_185, _183, _190), 0.0f);
      float4 _198 = __3__36__0__0__g_texPrecomputedLUTSingleMie.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_185, _183, _190), 0.0f);
      float _204 = dot(float3(sqrt(saturate(1.0f - (_85 * _85))), _85, 0.0f), float3((cos(_129) * _135), _139, _132));
      float _206 = (_204 * _204) + 1.0f;
      float _207 = _206 * 0.05968310311436653f;
      float _211 = _miePhaseConst * _miePhaseConst;
      float _226 = ((((1.0f - _211) * 3.0f) / ((_211 + 2.0f) * 2.0f)) * 0.07957746833562851f) * (_206 / exp2(log2((_211 + 1.0f) - ((_miePhaseConst * 2.0f) * _204)) * 1.5f));
      float _232 = (((_226 * _198.x) + (_207 * _193.x)) * 0.07957746833562851f) + _98;
      float _235 = (((_226 * _198.y) + (_207 * _193.y)) * 0.07957746833562851f) + _99;
      float _238 = (((_226 * _198.z) + (_207 * _193.z)) * 0.07957746833562851f) + _100;
      if (!((_101 + 1) == _92)) {
        _98 = _232;
        _99 = _235;
        _100 = _238;
        _101 = (_101 + 1);
        continue;
      }
      _243 = _103;
      _244 = _232;
      _245 = _235;
      _246 = _238;
      break;
    }
  } else {
    _243 = float((int)(_92));
    _244 = 0.0f;
    _245 = 0.0f;
    _246 = 0.0f;
  }
  float _247 = 12.566370964050293f / _243;
  float _248 = _247 * _244;
  float _249 = _247 * _245;
  float _250 = _247 * _246;
  __3__48__0__1__g_texPrecomputedLUTMultiGatherUAV[int3((int)(SV_DispatchThreadID.x), (int)(_22), (int)(SV_DispatchThreadID.z))] = float4(_248, _249, _250, 0.0f);
  float4 _253 = __3__48__0__1__g_texPrecomputedLUTMultiGatherAccumUAV.Load(int3((int)(SV_DispatchThreadID.x), (int)(_22), (int)(SV_DispatchThreadID.z)));
  __3__48__0__1__g_texPrecomputedLUTMultiGatherAccumUAV[int3((int)(SV_DispatchThreadID.x), (int)(_22), (int)(SV_DispatchThreadID.z))] = float4((_253.x + _248), (_253.y + _249), (_253.z + _250), _253.w);
}