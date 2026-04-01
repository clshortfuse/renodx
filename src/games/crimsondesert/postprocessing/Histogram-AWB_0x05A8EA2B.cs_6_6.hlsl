#include "../shared.h"

struct GlareInstanceData {
  float4 _data0;
  float4 _data1;
  float4 _luminance;
  float4 _vertexNormal;
};


Texture2D<float4> __3__36__0__0__g_sceneColor : register(t29, space36);

Texture2D<float4> __3__36__0__0__g_sceneColorLightingOnlyForAwb : register(t74, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t30, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t26, space36);

Texture2D<float4> __3__36__0__0__g_vertexNormal : register(t75, space36);

RWStructuredBuffer<uint> __3__39__0__1__g_histogramUAV : register(u9, space39);

RWStructuredBuffer<uint> __3__39__0__1__g_histogram2UAV : register(u10, space39);

RWStructuredBuffer<uint> __3__39__0__1__g_histogramRUAV : register(u11, space39);

RWStructuredBuffer<uint> __3__39__0__1__g_histogramGUAV : register(u12, space39);

RWStructuredBuffer<uint> __3__39__0__1__g_histogramBUAV : register(u13, space39);

RWTexture2D<float3> __3__38__0__1__g_glareSourceUAV : register(u23, space38);

RWTexture2D<float3> __3__38__0__1__g_colorAdatationSourceUAV : register(u24, space38);

RWStructuredBuffer<GlareInstanceData> __3__39__0__1__g_glareInstanceUAV : register(u5, space39);

RWByteAddressBuffer __3__39__0__1__g_glareInstanceCounterUAV : register(u1, space39);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b16, space35) {
  float4 _time;
  float4 _timeNoScale;
  uint4 _frameNumber;
  float4 _screenSizeAndInvSize;
  float4 _bufferSizeAndInvSize;
  float4 _hiZUVScaleAndInvScale;
  float4 _resolutionScale;
  float4 _temporalReprojectionParams;
  float4 _viewPos;
  float4 _viewDir;
  column_major float4x4 _viewProj;
  column_major float4x4 _viewProjNoJitter;
  column_major float4x4 _viewProjRelative;
  column_major float4x4 _viewProjRelativeNoJitter;
  column_major float4x4 _invViewProj;
  column_major float4x4 _invViewProjRelative;
  column_major float4x4 _invViewProjRelativeNoJitter;
  column_major float4x4 _viewProjRelativeOrtho;
  float4 _sunDirection;
  float4 _moonDirection;
  float4 _moonRight;
  float4 _moonUp;
  float4 _ssaoRandomDirection[16];
  column_major float4x4 _view;
  column_major float4x4 _viewRelative;
  column_major float4x4 _viewRelativePrev;
  column_major float4x4 _proj;
  column_major float4x4 _projNoJitter;
  float4 _viewPosPrev;
  column_major float4x4 _viewProjNoJitterPrev;
  column_major float4x4 _viewProjRelativePrev;
  column_major float4x4 _viewProjRelativeNoJitterPrev;
  column_major float4x4 _invViewProjPrev;
  column_major float4x4 _invViewProjRelativePrev;
  column_major float4x4 _projToPrevProj;
  column_major float4x4 _projToPrevProjNoTranslation;
  column_major float4x4 _viewProjectionTexScale;
  float4 _temporalAAJitter;
  float4 _temporalAAJitterParams;
  float4 _frustumPlanes[6];
  float4 _frustumPlanesPrev[6];
  float4 _frustumCornerDirs[4];
  float4 _screenPercentage;
  float4 _nearFarProj;
  float4 _renderingOriginPos;
  float4 _renderingOriginPosPrev;
  float4 _lodMaskRenderRate;
  float4 _terrainNormalParams;
  int4 _hiZMapInfo;
  int4 _hiZMapInfoCurrent;
  float4 _treeParams;
  uint4 _clusterSize;
  uint4 _globalLightParams;
  float4 _bevelParams;
  float4 _variableRateShadingParams;
  float4 _cavityParams;
  float4 _customRenderPassSizeInvSize;
  uint4 _impostorParams;
  float4 _clusterDecalSizeAndInvSize;
  uint4 _globalWindParams;
  float4 _windFluidVolumeParams;
  float4 _windFluidTextureParams;
  float4 _raytracingAccelerationStructureOrigin;
  float4 _debugBaseColor;
  float4 _debugNormal;
  float4 _debugMaterial;
  float4 _debugMultiplier;
  half4 _debugBaseColor16;
  half4 _debugNormal16;
  half4 _debugMaterial16;
  half4 _debugMultiplier16;
  float4 _debugCursorWorldPos;
  uint4 _debugRenderToggle01;
  uint4 _debugTreeShapeVariation;
  float4 _positionBasedDynamicsParameter;
  float _effectiveMetallicForVelvet;
  float _debugCharacterSnowRate;
  uint _systemRandomSeed;
  uint _skinnedMeshDebugFlag;
  float4 _viewPosShifted;
  float4 _viewPosShiftedPrev;
  float4 _viewTileRelativePos;
  float4 _viewTileRelativePosPrev;
  int2 _viewTileIndex;
  int2 _viewTileIndexPrev;
  float4 _worldVolume;
  float3 _diffViewPosAccurate;
  uint _isAllowBlood;
};

cbuffer __3__35__0__0__ExposureConstantBuffer : register(b31, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__35__0__0__AtmosphereConstantBuffer : register(b26, space35) {
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
  float4 _textureSizeAndInvSize : packoffset(c000.x);
  float4 _blurParam : packoffset(c001.x);
  float4 _glareParam : packoffset(c002.x);
  float4 _renderParam : packoffset(c003.x);
  float4 _exposureParam : packoffset(c004.x);
  float4 _histogramParam : packoffset(c005.x);
  float4 _whiteBalance : packoffset(c006.x);
  float4 _glareBlurParam : packoffset(c007.x);
  float4 _preFrameViewPosition : packoffset(c008.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

groupshared uint g_tempHistogram[256];
groupshared uint g_tempHistogram2[256];
groupshared uint g_tempHistogramR[256];
groupshared uint g_tempHistogramG[256];
groupshared uint g_tempHistogramB[256];
groupshared uint g_isSkyTile;
groupshared uint g_isEmissiveTile;
groupshared uint g_isParticleTile;

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  g_isSkyTile = 0;
  g_isEmissiveTile = 0;
  g_isParticleTile = 0;
  GroupMemoryBarrierWithGroupSync();
  float _27 = float((uint)SV_DispatchThreadID.x);
  float _28 = float((uint)SV_DispatchThreadID.y);
  float _29 = _27 + 0.5f;
  float _30 = _28 + 0.5f;
  float4 _31 = _textureSizeAndInvSize;
  float _32 = _31.z;
  float _33 = _31.w;
  float _34 = _32 * _29;
  float _35 = _33 * _30;
  float _36 = _34 * 2.0f;
  float _37 = _35 * 2.0f;
  float _38 = _36 + -1.0f;
  float _39 = _37 + -1.0f;
  float _40 = -0.0f - _39;
  float4 _43 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_34, _35), 0.0f);
  float4 _47 = _bufferSizeAndInvSize;
  float _48 = _47.x;
  float _49 = _47.y;
  float _50 = _48 * _34;
  float _51 = _49 * _35;
  int _52 = int(_50);
  int _53 = int(_51);
  uint2 _55 = __3__36__0__0__g_stencil.Load(int3(_52, _53, 0));
  int _57 = _55.x & 127;
  float4 _58 = mul(_invViewProjRelative, float4(_38, _40, 1.0000000116860974e-07f, 1.0f));
  float _94 = (_58.x) / (_58.w);
  float _95 = (_58.y) / (_58.w);
  float _96 = (_58.z) / (_58.w);
  float _97 = dot(float3(_94, _95, _96), float3(_94, _95, _96));
  float _98 = rsqrt(_97);
  bool _99 = (_57 == 0);
  bool _121;
  bool _122;
  bool _125;
  bool _126;
  bool _127;
  bool _128;
  float _247;
  float _260;
  float _363;
  float _364;
  float _365;
  bool _114 = false;
  if (_99) {
    float _104 = _sunSizeAngle * 0.01745329238474369f;
    float _105 = _98 * _96;
    float _106 = _98 * _95;
    float _107 = _98 * _94;
    float _112 = dot(float3(_107, _106, _105), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
    float _113 = acos(_112);
    _114 = (_113 < _104);
  }
  bool _116 = (!_99) && (_57 == 28);
  bool _117 = (!_99) && (_57 == 56);
  bool _118 = (!_99) && (_57 == 26);
  bool _123 = (!_99) && (_57 == 27);
  _125 = _117;
  _126 = _116;
  _127 = (_99) && (_114);
  _128 = (_118) || (_116) || (_123);
  uint _129 = uint(_50);
  uint _130 = uint(_51);
  float4 _132 = __3__36__0__0__g_vertexNormal.Load(int3(_129, _130, 0));
  float _137 = _132.w * 3.0f;
  float _138 = _137 + 0.5f;
  uint _139 = uint(_138);
  bool _140 = (_139 == 3);
  float _141 = _140 ? 1.0f : 0.0f;
  float _142 = _128 ? 0.5f : _141;
  float _143 = _132.x * 1.0009784698486328f;
  float _144 = _132.y * 1.0009784698486328f;
  float _145 = _132.z * 1.0009784698486328f;
  float _146 = saturate(_143);
  float _147 = saturate(_144);
  float _148 = saturate(_145);
  float _149 = _146 * 2.0f;
  float _150 = _147 * 2.0f;
  float _151 = _148 * 2.0f;
  float _152 = _149 + -1.0f;
  float _153 = _150 + -1.0f;
  float _154 = _151 + -1.0f;
  float _155 = dot(float3(_152, _153, _154), float3(_152, _153, _154));
  float _156 = rsqrt(_155);
  float _157 = _156 * _152;
  float _158 = _156 * _153;
  float _159 = _154 * _156;
  float _160 = _textureSizeAndInvSize.z * _27;
  float _161 = _textureSizeAndInvSize.w * _28;
  float4 _163 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_160, _161), 0.0f);
  float _167 = _27 + 1.0f;
  float _168 = _textureSizeAndInvSize.z * _167;
  float4 _169 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_168, _161), 0.0f);
  float _173 = _28 + 1.0f;
  float _174 = _textureSizeAndInvSize.w * _173;
  float4 _175 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_160, _174), 0.0f);
  float4 _179 = __3__36__0__0__g_sceneColor.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_168, _174), 0.0f);
  float _183 = dot(float3(_163.x, _163.y, _163.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _184 = dot(float3(_169.x, _169.y, _169.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _185 = dot(float3(_175.x, _175.y, _175.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _186 = dot(float3(_179.x, _179.y, _179.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _187 = _183 + 1.0f;
  float _188 = 1.0f / _187;
  float _189 = _184 + 1.0f;
  float _190 = 1.0f / _189;
  float _191 = _185 + 1.0f;
  float _192 = 1.0f / _191;
  float _193 = _186 + 1.0f;
  float _194 = 1.0f / _193;
  float _195 = _190 + _188;
  float _196 = _195 + _192;
  float _197 = _196 + _194;
  float _198 = _188 * _163.x;
  float _199 = _188 * _163.y;
  float _200 = _188 * _163.z;
  float _201 = _190 * _169.x;
  float _202 = _190 * _169.y;
  float _203 = _190 * _169.z;
  float _204 = _201 + _198;
  float _205 = _202 + _199;
  float _206 = _203 + _200;
  float _207 = _192 * _175.x;
  float _208 = _192 * _175.y;
  float _209 = _192 * _175.z;
  float _210 = _204 + _207;
  float _211 = _205 + _208;
  float _212 = _206 + _209;
  float _213 = _194 * _179.x;
  float _214 = _194 * _179.y;
  float _215 = _194 * _179.z;
  float _216 = _210 + _213;
  float _217 = _211 + _214;
  float _218 = _212 + _215;
  float _219 = _216 / _197;
  float _220 = _217 / _197;
  float _221 = _218 / _197;
  float _222 = -0.0f - _219;
  float _223 = -0.0f - _220;
  float _224 = -0.0f - _221;
  float _225 = min(0.0f, _222);
  float _226 = min(0.0f, _223);
  float _227 = min(0.0f, _224);
  float _228 = -0.0f - _225;
  float _229 = -0.0f - _226;
  float _230 = -0.0f - _227;
  float _248;
  bool _249;
  // RenoDX: When alt auto exposure is toggled, use the filtered exposure
  // from _exposure4.z (slot 18) instead of the fast _exposure0.y to decouple
  // glare intensity from jitter.
  float _glareExposure = (IMPROVED_AUTO_EXPOSURE >= 1) ? max(_exposure4.z, 0.001f) : _exposure0.y;
  float _glareExposure2 = (IMPROVED_AUTO_EXPOSURE >= 1) ? max(_exposure4.z, 0.001f) : _exposure2.x;
  if (_127) {
    float _236 = min(_glareExposure2, 2.0f);
    float _237 = max(_236, 0.5f);
    _247 = _237 * _glareParam.w;
  } else {
    if (_126) {
      float _243 = min(_glareExposure, 0.4000000059604645f);
      float _244 = max(0.20000000298023224f, _243);
      _247 = 120.0f / _244;
    } else {
      _247 = 1.0f;
    }
  }
  _248 = _125 ? 300.0f : _247;
  _249 = (_142 > 0.0f);
  if (_249) {
    float _253 = _142 * 0.004000000189989805f;
    _260 = _253 * min(_glareExposure, 20.0f);
  } else {
    _260 = min(_glareExposure, 25.0f) * 0.0010000000474974513f;
  }
  float _261 = _260 * _248;
  float _262 = _261 * _228;
  float _263 = _261 * _229;
  float _264 = _261 * _230;
  float _265 = _262 + 1.0f;
  float _266 = _263 + 1.0f;
  float _267 = _264 + 1.0f;
  float _268 = log2(_265);
  float _269 = log2(_266);
  float _270 = log2(_267);
  float _271 = _142 * 48.520301818847656f;
  float _272 = _268 * _271;
  float _273 = _269 * _271;
  float _274 = _270 * _271;
  float _275 = dot(float3(_262, _263, _264), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _276 = _275 * 50.0f;
  float _277 = saturate(_276);
  float _278 = _272 * _272;
  float _279 = _273 * _273;
  float _280 = _274 * _274;
  float _281 = select(_249, _278, _262);
  float _282 = select(_249, _279, _263);
  float _283 = select(_249, _280, _264);
  float _284 = _262 - _281;
  float _285 = _263 - _282;
  float _286 = _264 - _283;
  float _287 = _284 * _277;
  float _288 = _285 * _277;
  float _289 = _286 * _277;
  float _290 = _287 + _281;
  float _291 = _288 + _282;
  float _292 = _289 + _283;

  __3__38__0__1__g_glareSourceUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3(_290, _291, _292);
  bool _296 = (_whiteBalance.w > 0.0010000000474974513f);
  int _297 = _57 + -105;
  bool _298 = ((uint)_297 < (uint)2);
  bool _299 = (_298) || (_128);
  float _300 = _43.x + _43.y;
  float _301 = _300 + _43.z;
  float _302 = _301 * 0.3333333432674408f;
  float _303 = _301 * 0.00033333332976326346f;
  float _304 = saturate(_303);
  float _305 = _304 * 0.5f;
  float _306 = 1.5f - _305;
  float _307 = _43.x - _302;
  float _308 = _43.y - _302;
  float _309 = _43.z - _302;
  float _310 = _306 * _307;
  float _311 = _306 * _308;
  float _312 = _306 * _309;
  float _313 = _310 + _302;
  float _314 = _311 + _302;
  float _315 = _312 + _302;
  bool _316 = (_299) || (_140);
  if (_316) {
    float _318 = _313 + _314;
    float _319 = _318 + _315;
    float _320 = _319 * 0.3333333432674408f;
    float _321 = max(_320, 9.999999747378752e-05f);
    float _322 = _302 / _321;
    float _325 = min(_glareExposure, 20.0f);
    float _326 = _322 * 0.0020000000949949026f;
    float _327 = _326 * _325;
    float _328 = _327 * _313;
    float _329 = _327 * _314;
    float _330 = _327 * _315;
    float _331 = _328 + 1.0f;
    float _332 = _329 + 1.0f;
    float _333 = _330 + 1.0f;
    float _334 = log2(_331);
    float _335 = log2(_332);
    float _336 = log2(_333);
    float _337 = _334 * 24.260150909423828f;
    float _338 = _335 * 24.260150909423828f;
    float _339 = _336 * 24.260150909423828f;
    float _340 = dot(float3(_328, _329, _330), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _341 = _340 * 50.0f;
    float _342 = saturate(_341);
    float _343 = _337 * _337;
    float _344 = _338 * _338;
    float _345 = _339 * _339;
    float _346 = _328 - _343;
    float _347 = _329 - _344;
    float _348 = _330 - _345;
    float _349 = _342 * _346;
    float _350 = _342 * _347;
    float _351 = _348 * _342;
    float _352 = _349 + _343;
    float _353 = _350 + _344;
    float _354 = _351 + _345;
    float4 _355 = _renderParam;
    float _356 = _355.z;
    float _357 = _355.w;
    float _358 = select(_299, _356, _357);
    float _359 = _358 * _352;
    float _360 = _358 * _353;
    float _361 = _358 * _354;
    _363 = _359;
    _364 = _360;
    _365 = _361;
  } else {
    _363 = 0.0f;
    _364 = 0.0f;
    _365 = 0.0f;
  }
  __3__38__0__1__g_colorAdatationSourceUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3(_363, _364, _365);
  g_tempHistogram[(int)(SV_GroupIndex)] = 0;
  g_tempHistogram2[(int)(SV_GroupIndex)] = 0;
  if (_296) {
    g_tempHistogramR[(int)(SV_GroupIndex)] = 0;
    g_tempHistogramG[(int)(SV_GroupIndex)] = 0;
    g_tempHistogramB[(int)(SV_GroupIndex)] = 0;
  }
  int _374 = (int)(uint)(_99);
  uint _375; InterlockedMax(g_isSkyTile, (uint)(_374), _375);
  int _376 = (int)(uint)(_140);
  uint _377; InterlockedMax(g_isEmissiveTile, (uint)(_376), _377);
  int _378 = (int)(uint)(_299);
  uint _379; InterlockedMax(g_isParticleTile, (uint)(_378), _379);
  GroupMemoryBarrierWithGroupSync();
  int _380 = g_isSkyTile;
  int _381 = g_isEmissiveTile;
  int _382 = g_isParticleTile;
  float _385 = _bufferSizeAndInvSize.y * _35;
  uint _386 = uint(_385);
  float _389 = _viewPos.w + -16.0f;
  float _390 = max(0.0f, _389);
  float _391 = float((int)(_386));
  bool _392 = false;
  float _393 = _bufferSizeAndInvSize.y - _390;
  bool _394 = false;
  bool _395 = !((_391 <= _390) || (_391 >= _393));
  float3 _396_398 = _395 ? _43.xyz : 0.0f.xxx;
    float _396 = _396_398.x;
    float _397 = _396_398.y;
    float _398 = _396_398.z;
    float _399 = dot(_396_398, float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float4 _402 = __3__36__0__0__g_sceneColorLightingOnlyForAwb.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_34, _35), 0.0f);
  bool _404 = (_402.w > 0.0f);
  float _406 = __3__36__0__0__g_depth.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_34, _35), 0.0f);
  bool _408 = (_406.x < 1.0000000116860974e-07f);
  bool _409 = (_406.x == 1.0f);
  bool _410 = (_408) || (_409);
  int _411 = select(_410, 1, 4);
  float4 _412 = _histogramParam;
  float _413 = _412.x;
  float _414 = _412.y;
  float _415 = log2(_399);
  float _416 = _415 * _413;
  float _417 = _416 + _414;
  float _418 = saturate(_417);
  float _419 = _418 * 255.0f;
  uint _420 = uint(_419);
  float _421 = dot(float3(_228, _229, _230), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _422 = log2(_421);
  float _423 = _422 * _413;
  float _424 = _423 + _414;
  float _425 = saturate(_424);
  float _426 = _425 * 255.0f;
  uint _427 = uint(_426);
  int _429; InterlockedAdd(g_tempHistogram2[_427], _411, _429);
  int _431; InterlockedAdd(g_tempHistogram[_420], _411, _431);
  bool _432 = !(_406.x < 1.0000000116860974e-07f);
  bool _433 = (_296) && (_432);
  bool _434 = !(_406.x == 1.0f);
  bool _435 = (_434) && (_433);
  bool _436 = !_435;
  int _437 = _57 + -53;
  bool _438 = ((uint)_437 < (uint)15);
  bool _439 = (_438) || (_436);
  // RenoDX: AWB R/G/B histogram writes
  //
  // When AWB is disabled we MUST still write to the R/G/B histograms using the
  // neutral luminance bin (_420) for all three channels.  This makes sure that
  // CalculateManyLightsBounds reads a valid neutral (R=G=B=255) packed correction
  // from _exposure1.z instead of R=G=B=0, which would silently exclude hero lights
  // and character fill lights from rendering (they are encoded with negative raw
  // colours that only become positive after the AWB colour matrix is applied).
  if (!_439) {
    if (DISABLE_AWB > 0.0f) {
      // Neutral path: write the luminance bin to all three channels so they share
      // an equal distribution → packed AWB correction converges to (1,1,1) neutral.
      // Exception: if hero lights/fill lights are also disabled, skip the write
      // entirely so the histograms stay zero → packed correction = (0,0,0) →
      // negative-luminance lights are excluded from the bounds UAV and go dark.
      if (DISABLE_HERO_LIGHTS < 0.5f) {
        int _rn; InterlockedAdd(g_tempHistogramR[_420], _411, _rn);
        int _gn; InterlockedAdd(g_tempHistogramG[_420], _411, _gn);
        int _bn; InterlockedAdd(g_tempHistogramB[_420], _411, _bn);
      }
    } else {
      // Per channel AWB path: use actual per channel luminance values.
      float _441 = _402.z;
      float _442 = select(_404, _441, _399);
      float _443 = _402.y;
      float _444 = select(_404, _443, _399);
      float _445 = _402.x;
      float _446 = select(_404, _445, _399);
      float4 _447 = _histogramParam;
      float _448 = _447.x;
      float _449 = _447.y;
      float _450 = log2(_446);
      float _451 = _450 * _448;
      float _452 = _451 + _449;
      float _453 = saturate(_452);
      float _454 = log2(_444);
      float _455 = _454 * _448;
      float _456 = _455 + _449;
      float _457 = saturate(_456);
      float _458 = log2(_442);
      float _459 = _458 * _448;
      float _460 = _459 + _449;
      float _461 = saturate(_460);
      float _462 = _453 * 255.0f;
      float _463 = _457 * 255.0f;
      float _464 = _461 * 255.0f;
      uint _465 = uint(_462);
      uint _466 = uint(_463);
      uint _467 = uint(_464);
      int _469; InterlockedAdd(g_tempHistogramR[_465], _411, _469);
      int _471; InterlockedAdd(g_tempHistogramG[_466], _411, _471);
      int _473; InterlockedAdd(g_tempHistogramB[_467], _411, _473);
    }
  }
  GroupMemoryBarrierWithGroupSync();
  int _475 = g_tempHistogram2[(int)(SV_GroupIndex)];
  uint _477; InterlockedAdd(__3__39__0__1__g_histogram2UAV[(int)(SV_GroupIndex)], _475, _477);
  int _478 = g_tempHistogram[(int)(SV_GroupIndex)];
  uint _480; InterlockedAdd(__3__39__0__1__g_histogramUAV[(int)(SV_GroupIndex)], _478, _480);

  // === RenoDX: Flush R/G/B temp histograms to global UAVs (neutral or per channel) ===
  if (_296) {
    int _483 = g_tempHistogramR[(int)(SV_GroupIndex)];
    uint _485; InterlockedAdd(__3__39__0__1__g_histogramRUAV[(int)(SV_GroupIndex)], _483, _485);
    int _487 = g_tempHistogramG[(int)(SV_GroupIndex)];
    uint _489; InterlockedAdd(__3__39__0__1__g_histogramGUAV[(int)(SV_GroupIndex)], _487, _489);
    int _491 = g_tempHistogramB[(int)(SV_GroupIndex)];
    uint _493; InterlockedAdd(__3__39__0__1__g_histogramBUAV[(int)(SV_GroupIndex)], _491, _493);
  }
  float4 _495 = _nearFarProj;
  float _496 = _495.x;
  float _497 = max(1.0000000116860974e-07f, _406.x);
  float _498 = _496 / _497;
  float _499 = _397 + _396;
  float _500 = _499 + _398;
  // RenoDX: Use slow exposure for glare instance threshold to
  // stop shimmering due to jitter
  float _glareThresholdExp = (IMPROVED_AUTO_EXPOSURE >= 1) ? max(_exposure4.z, 0.001f) : _exposure2.x;
  float _503 = saturate(_glareThresholdExp);
  float _504 = _503 * 900.0f;
  float _505 = _504 + 100.0f;
  float _506 = _505 * _glareThresholdExp;
  float _507 = _498 * 0.004999999888241291f;
  float _508 = saturate(_507);
  float _509 = _508 * 4.0f;
  float _510 = _509 * _506;
  float _511 = _510 + _506;
  int _512 = _55.x & 125;
  bool _513 = (_512 == 17);
  bool _514 = (_57 == 18);
  bool _515 = (_513) || (_514);
  int _516 = _55.x & 126;
  bool _517 = (_516 == 12);
  bool _518 = (_517) || (_515);
  bool _519 = (_57 == 11);
  bool _520 = (_519) || (_518);
  float _521 = select(_520, 1.0f, 0.0f);
  float _522 = select(_520, 0.10000000149011612f, 1.0f);
  float _523 = _511 * _522;
  int _524 = _381 | _380;
  int _525 = _524 | _382;
  bool _526 = (_525 != 0);
  bool _527 = (_57 == 57);
  bool _528 = (_527) || (_438);
  float _529 = select(_528, 1.0f, 0.0f);
  float _530 = _500 - _523;
  bool _531 = !(_500 > _523);
  bool _532 = (_526) || (_531);
  bool _533 = (_408) || (_532);
  bool _534 = !_533;
  bool _535 = (_434) && (_534);
  if (_535) {
    uint _538; __3__39__0__1__g_glareInstanceCounterUAV.InterlockedAdd(0u, 1, _538);
    bool _539 = ((uint)_538 < (uint)999);
    if (_539) {
      float _541 = _396 / _523;
      float _542 = _397 / _523;
      float _543 = _398 / _523;
      float _544 = _530 / _523;
      float4 _565 = mul(_invViewProj, float4(_38, _40, _497, 1.0f));
      float _581 = (_565.x) / (_565.w);
      float _582 = (_565.y) / (_565.w);
      float _583 = (_565.z) / (_565.w);
      GlareInstanceData __struct_store_0;
      __struct_store_0._data0 = float4(_34, _35, 0.0f, _498);
      __struct_store_0._data1 = float4(_581, _582, _583, _529);
      __struct_store_0._luminance = float4(_541, _542, _543, _544);
      __struct_store_0._vertexNormal = float4(_157, _158, _159, _521);
      __3__39__0__1__g_glareInstanceUAV[_538] = __struct_store_0;
    }
  }
}
