Texture2D<uint4> __3__36__0__0__g_baseColor : register(t1, space36);

Texture2D<float4> __3__36__0__0__g_normal : register(t17, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t3, space36);

Texture2D<float4> __3__36__0__0__g_normalRoughnessOpaque : register(t30, space36);

Texture2D<float4> __3__36__0__0__g_sceneColor : register(t31, space36);

Texture2D<float4> __3__36__0__0__g_sceneColorBeforeSSS : register(t32, space36);

RWTexture2D<float4> __3__38__0__1__g_diffuseAlbedoUAV : register(u24, space38);

RWTexture2D<float4> __3__38__0__1__g_specularAlbedoUAV : register(u25, space38);

RWTexture2D<float4> __3__38__0__1__g_normalRoughnessUAV : register(u26, space38);

RWTexture2D<float> __3__38__0__1__g_subsurfaceScatteringGuideUAV : register(u28, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b18, space35) {
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

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _postProcessParameters : packoffset(c000.x);
  float4 _additionalParameters : packoffset(c001.x);
  uint4 _crosshairInfo : packoffset(c002.x);
  column_major float4x4 _nearFiledShadowViewRelative : packoffset(c003.x);
};

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _26 = (((float((uint)SV_DispatchThreadID.x) + 0.5f) * 2.0f) * _bufferSizeAndInvSize.z) + -1.0f;
  float _29 = 1.0f - ((_bufferSizeAndInvSize.w * 2.0f) * (float((uint)SV_DispatchThreadID.y) + 0.5f));
  uint2 _31 = __3__36__0__0__g_stencil.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
  int _33 = _31.y & 127;
  float _209;
  float _242;
  float _243;
  float _244;
  float _245;
  float _326;
  if (!(((int)((uint)(_31.y & 24) > (uint)23)) & ((int)(_33 != 29)))) {
    uint4 _40 = __3__36__0__0__g_baseColor.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
    float4 _46 = __3__36__0__0__g_normal.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
    float _53 = float((uint)((uint)(((uint)((uint)(_40.x)) >> 8) & 255))) * 0.003921568859368563f;
    float _56 = float((uint)((uint)(_40.x & 255))) * 0.003921568859368563f;
    float _60 = float((uint)((uint)(((uint)((uint)(_40.y)) >> 8) & 255))) * 0.003921568859368563f;
    float _63 = float((uint)((uint)(_40.y & 255))) * 0.003921568859368563f;
    float _82 = (saturate(_46.x * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _83 = (saturate(_46.y * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _84 = (saturate(_46.z * 1.0009784698486328f) * 2.0f) + -1.0f;
    float _86 = rsqrt(dot(float3(_82, _83, _84), float3(_82, _83, _84)));
    float _87 = _86 * _82;
    float _88 = _86 * _83;
    float _89 = _84 * _86;
    float _92 = (float((uint)((uint)(((uint)((uint)(_40.w)) >> 8) & 255))) * 0.007843137718737125f) + -1.0f;
    float _93 = (float((uint)((uint)(_40.w & 255))) * 0.007843137718737125f) + -1.0f;
    float _96 = (_92 + _93) * 0.5f;
    float _97 = (_92 - _93) * 0.5f;
    float _101 = (1.0f - abs(_96)) - abs(_97);
    float _103 = rsqrt(dot(float3(_96, _97, _101), float3(_96, _97, _101)));
    float _104 = _103 * _96;
    float _105 = _103 * _97;
    float _106 = _103 * _101;
    float _108 = select((_89 >= 0.0f), 1.0f, -1.0f);
    float _111 = -0.0f - (1.0f / (_108 + _89));
    float _112 = _88 * _111;
    float _113 = _112 * _87;
    float _114 = _108 * _87;
    float _123 = mad(_106, _87, mad(_105, _113, ((((_114 * _87) * _111) + 1.0f) * _104)));
    float _127 = mad(_106, _88, mad(_105, (_108 + (_112 * _88)), ((_104 * _108) * _113)));
    float _131 = mad(_106, _89, mad(_105, (-0.0f - _88), (-0.0f - (_114 * _104))));
    float _133 = rsqrt(dot(float3(_123, _127, _131), float3(_123, _127, _131)));
    float _140 = saturate(_53 * _53);
    float _141 = saturate(_56 * _56);
    float _142 = saturate(_60 * _60);
    float _158 = saturate(((_141 * 0.3395099937915802f) + (_140 * 0.6131200194358826f)) + (_142 * 0.047370001673698425f));
    float _159 = saturate(((_141 * 0.9163600206375122f) + (_140 * 0.07020000368356705f)) + (_142 * 0.013450000435113907f));
    float _160 = saturate(((_141 * 0.10958000272512436f) + (_140 * 0.02061999961733818f)) + (_142 * 0.8697999715805054f));
    float _196 = ((float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).w) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).w)) + mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).w), _29, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).w) * _26));
    float _197 = ((mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).x), _29, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).x) * _26)) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).x)) + (float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).x)) / _196;
    float _198 = (((float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).y) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).y)) + mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).y), _29, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).y) * _26))) / _196;
    float _199 = (((float4(_invViewProjRelative[0].w, _invViewProjRelative[1].w, _invViewProjRelative[2].w, _invViewProjRelative[3].w).z) + (float4(_invViewProjRelative[0].z, _invViewProjRelative[1].z, _invViewProjRelative[2].z, _invViewProjRelative[3].z).z)) + mad((float4(_invViewProjRelative[0].y, _invViewProjRelative[1].y, _invViewProjRelative[2].y, _invViewProjRelative[3].y).z), _29, ((float4(_invViewProjRelative[0].x, _invViewProjRelative[1].x, _invViewProjRelative[2].x, _invViewProjRelative[3].x).z) * _26))) / _196;
    float _201 = rsqrt(dot(float3(_197, _198, _199), float3(_197, _198, _199)));
    if (_33 == 53) {
      _209 = saturate(((_159 + _158) + _160) * 1.2000000476837158f);
    } else {
      _209 = 1.0f;
    }
    float _215 = (0.699999988079071f / min(max(max(max(_158, _159), _160), 0.009999999776482582f), 0.699999988079071f)) * _209;
    float _226 = (((_215 * _159) + -0.03999999910593033f) * _63) + 0.03999999910593033f;
    if (!(_33 == 29)) {
      float4 _231 = __3__36__0__0__g_normalRoughnessOpaque.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
      float _237 = rsqrt(dot(float3(_231.x, _231.y, _231.z), float3(_231.x, _231.y, _231.z)));
      _242 = (_237 * _231.x);
      _243 = (_237 * _231.y);
      _244 = (_237 * _231.z);
      _245 = _231.w;
    } else {
      _242 = (_133 * _123);
      _243 = (_133 * _127);
      _244 = (_133 * _131);
      _245 = (float((uint)((uint)(((uint)((uint)(_40.z)) >> 8) & 255))) * 0.003921568859368563f);
    }
    __3__38__0__1__g_diffuseAlbedoUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_158, _159, _160, 1.0f);
    float _254 = _245 * _245;
    float _255 = abs(dot(float3(_242, _243, _244), float3((-0.0f - (_197 * _201)), (-0.0f - (_198 * _201)), (-0.0f - (_199 * _201)))));
    float _256 = _255 * _255;
    float _257 = _256 * _255;
    float _259 = (_254 * _254) * _254;
    float _287 = max(0.0f, (((1.0f / dot(float3(mad(59.418800354003906f, _257, mad(2.923379898071289f, _255, 1.0f)), mad(222.5919952392578f, _257, mad(-27.03019905090332f, _255, 20.322500228881836f)), mad(316.62701416015625f, _257, mad(626.1300048828125f, _255, 121.56300354003906f))), float3(1.0f, _254, _259))) * dot(float2(mad(-1.285140037536621f, _255, 0.9904400110244751f), mad(-0.7559069991111755f, _255, 1.296779990196228f)), float2(1.0f, _254))) * saturate(_226 * 50.0f)));
    float _288 = max(0.0f, ((1.0f / dot(float3(mad(-1.3677200078964233f, _257, mad(3.5968499183654785f, _256, 1.0f)), mad(9.229490280151367f, _257, mad(-16.317399978637695f, _256, 9.044010162353516f)), mad(-20.212299346923828f, _257, mad(19.78860092163086f, _256, 5.565889835357666f))), float3(1.0f, _254, _259))) * dot(float2(mad(3.3270699977874756f, _255, 0.03654630109667778f), mad(-9.04755973815918f, _255, 9.063199996948242f)), float2(1.0f, _254))));
    __3__38__0__1__g_specularAlbedoUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(mad(((((_215 * _158) + -0.03999999910593033f) * _63) + 0.03999999910593033f), _288, _287), mad(_226, _288, _287), mad(((((_215 * _160) + -0.03999999910593033f) * _63) + 0.03999999910593033f), _288, _287), 1.0f);
    __3__38__0__1__g_normalRoughnessUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_242, _243, _244, _245);
    if (_postProcessParameters.x > 0.0f) {
      float4 _299 = __3__36__0__0__g_sceneColor.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
      float4 _304 = __3__36__0__0__g_sceneColorBeforeSSS.Load(int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), 0));
      bool _311 = ((int)((_31.y & 126) == 66)) | ((int)(_33 == 54));
      _326 = (((((_299.z - _304.z) * select(_311, 1.0f, _160)) + ((_299.x - _304.x) * select(_311, 1.0f, _158))) + ((_299.y - _304.y) * select(_311, 2.0f, (_159 * 2.0f)))) * 0.25f);
    } else {
      _326 = 0.0f;
    }
    __3__38__0__1__g_subsurfaceScatteringGuideUAV[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = _326;
  }
}
