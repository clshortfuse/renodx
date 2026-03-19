struct PostProcessSkyStruct {
  uint _moonTexture;
  uint _milkyWayTexture;
  float _milkyWayRatio;
  float _starRatio;
};


Texture2D<float4> __0__7__0__0__g_bindlessTextures[] : register(t0, space7);

Texture2D<float> __3__36__0__0__g_depth : register(t16, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t20, space36);

RWTexture2D<float4> __3__38__0__1__g_postProcessUAV : register(u0, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b13, space35) {
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

cbuffer __3__35__0__0__AtmosphereConstantBuffer : register(b25, space35) {
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
  float4 _postProcessParams : packoffset(c000.x);
  float4 _postProcessParams1 : packoffset(c001.x);
  float4 _toneMapParams0 : packoffset(c002.x);
  float4 _toneMapParams1 : packoffset(c003.x);
  float4 _colorGradingParams : packoffset(c004.x);
  float4 _colorCorrectionParams : packoffset(c005.x);
  float4 _localToneMappingParams : packoffset(c006.x);
  float4 _etcParams : packoffset(c007.x);
  float4 _userImageAdjust : packoffset(c008.x);
  float4 _slopeParams : packoffset(c009.x);
  float4 _offsetParams : packoffset(c010.x);
  float4 _powerParams : packoffset(c011.x);
};

cbuffer __3__1__0__0__PostProcessMaterialIndex : register(b2, space1) {
  int _materialIndex : packoffset(c000.x);
  int _passIndex : packoffset(c000.y);
  int __3__1__0__0__PostProcessMaterialIndex_000z : packoffset(c000.z);
  int __3__1__0__0__PostProcessMaterialIndex_000w : packoffset(c000.w);
};

ConstantBuffer<PostProcessSkyStruct> BindlessParameters_PostProcessSky[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _14 = __3__36__0__0__g_depth.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  uint2 _17 = __3__36__0__0__g_stencil.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  if (!((((int)(!(_14.x < 1.0000000116860974e-07f)))) & ((int)((_17.x & 127) != 10)))) {
    float _43 = (((float4(_moonDirX, _moonDirY, _earthAxisTilt, _latitude).z) + 90.0f) - (float4(_moonDirX, _moonDirY, _earthAxisTilt, _latitude).w)) * 0.01745329238474369f;
    float _44 = sin(_43);
    float _45 = cos(_43);
    float _49 = (_time.w * 0.2617993950843811f) + -3.1415927410125732f;
    float _50 = sin(_49);
    float _51 = cos(_49);
    float _52 = 1.0f - _51;
    float _53 = _52 * _44;
    float _54 = _52 * _45;
    float _55 = _50 * _44;
    float _56 = _50 * _45;
    float _66 = (((float((uint)SV_DispatchThreadID.x) + 0.5f) * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f;
    float _69 = ((1.0f - ((float((uint)SV_DispatchThreadID.y) + 0.5f) * _bufferSizeAndInvSize.w)) * 2.0f) + -1.0f;
    float _105 = ((float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w)) + mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _66));
    float _106 = ((mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _66)) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x)) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _105;
    float _107 = (((float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y)) + mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _66))) / _105;
    float _108 = (((float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z)) + mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _69, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _66))) / _105;
    float _110 = rsqrt(dot(float3(_106, _107, _108), float3(_106, _107, _108)));
    float _111 = _110 * _106;
    float _112 = _110 * _107;
    float _113 = _110 * _108;
    float _116 = mad((-0.0f - _55), _113, mad(_56, _112, (_111 * _51)));
    float _123 = mad(((_54 * _45) + _51), _113, mad((_53 * _45), _112, (_111 * _55)));
    float _125 = atan(_123 / _116);
    bool _128 = (_116 < 0.0f);
    bool _129 = (_116 == 0.0f);
    bool _130 = (_123 >= 0.0f);
    bool _131 = (_123 < 0.0f);
    int _144 = WaveReadLaneFirst(int4(_materialIndex, _passIndex, __3__1__0__0__PostProcessMaterialIndex_000z, __3__1__0__0__PostProcessMaterialIndex_000w).x);
    int _152 = WaveReadLaneFirst(int4(BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_144 < (uint)170000), _144, 0)) + 0u))]._moonTexture, BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_144 < (uint)170000), _144, 0)) + 0u))]._milkyWayTexture, BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_144 < (uint)170000), _144, 0)) + 0u))]._milkyWayRatio, BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_144 < (uint)170000), _144, 0)) + 0u))]._starRatio).y);
    float4 _159 = __0__7__0__0__g_bindlessTextures[((int)((uint)(select(((uint)_152 < (uint)65000), _152, 0)) + 0u))].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(select(((_129) & (_130)), 0.75f, select(((_129) & (_131)), 0.25f, ((select(((_128) & (_131)), (_125 + -3.1415927410125732f), select(((_128) & (_130)), (_125 + 3.1415927410125732f), _125)) * 0.15915493667125702f) + 0.5f))), (acos(mad((_54 * _44), _113, mad(((_53 * _44) + _51), _112, (-0.0f - (_56 * _111))))) * 0.31830987334251404f)), 0.0f);
    int _163 = WaveReadLaneFirst(int4(_materialIndex, _passIndex, __3__1__0__0__PostProcessMaterialIndex_000z, __3__1__0__0__PostProcessMaterialIndex_000w).x);
    float _171 = WaveReadLaneFirst(float4(BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_163 < (uint)170000), _163, 0)) + 0u))]._moonTexture, BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_163 < (uint)170000), _163, 0)) + 0u))]._milkyWayTexture, BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_163 < (uint)170000), _163, 0)) + 0u))]._milkyWayRatio, BindlessParameters_PostProcessSky[((int)((uint)(select(((uint)_163 < (uint)170000), _163, 0)) + 0u))]._starRatio).z);
    float _172 = _171 * _159.x;
    float _173 = _171 * _159.y;
    float _174 = _171 * _159.z;
    __3__38__0__1__g_postProcessUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4((((_172 * 0.6131200194358826f) + (_173 * 0.3395099937915802f)) + (_174 * 0.047370001673698425f)), (((_172 * 0.07020000368356705f) + (_173 * 0.9163600206375122f)) + (_174 * 0.013450000435113907f)), (((_172 * 0.02061999961733818f) + (_173 * 0.10958000272512436f)) + (_174 * 0.8697999715805054f)), _postProcessParams.x);
  }
}
