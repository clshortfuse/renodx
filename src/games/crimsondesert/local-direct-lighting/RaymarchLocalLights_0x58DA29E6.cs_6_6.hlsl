struct CharacterOcclusionData {
  float4 _positionRadius;
  float4 _offsetOcclusionIndices;
};

struct ManyLightsData {
  float4 _position;
  float4 _color;
  uint2 _up;
  uint2 _look;
};


Texture3D<float> __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav : register(t224, space36);

Texture3D<uint4> __3__36__0__0__g_axisAlignedDistanceTextures : register(t218, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<uint2> __3__36__0__0__g_normalDepth : register(t71, space36);

StructuredBuffer<CharacterOcclusionData> __3__37__0__0__g_characterOcclusionDataBuffer : register(t0, space37);

ByteAddressBuffer __3__37__0__0__g_structureCounterBuffer : register(t27, space37);

StructuredBuffer<ManyLightsData> __3__37__0__0__g_manyLightsDataBuffer : register(t9, space37);

Texture2D<float4> __3__36__0__0__g_manyLightsMomentsPrev : register(t7, space36);

RWTexture2D<uint2> __3__38__0__1__g_manyLightsHitDataUAV : register(u1, space38);

RWTexture2D<uint> __3__38__0__1__g_tiledManyLightsMasksUAV : register(u4, space38);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b20, space35) {
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

cbuffer __3__35__0__0__VoxelGlobalIlluminationConstantBuffer : register(b2, space35) {
  float4 _voxelParams : packoffset(c000.x);
  float4 _invClipmapExtent : packoffset(c001.x);
  float4 _wrappedViewPosForInject : packoffset(c002.x);
  float4 _clipmapOffsetsForInject[8] : packoffset(c003.x);
  float4 _clipmapRelativeIndexOffsetsForInject[8] : packoffset(c011.x);
  float4 _wrappedViewPos : packoffset(c019.x);
  float4 _clipmapOffsets[8] : packoffset(c020.x);
  float4 _clipmapOffsetsPrev[8] : packoffset(c028.x);
  float4 _clipmapRelativeIndexOffsets[8] : packoffset(c036.x);
  float4 _clipmapUVParams[2] : packoffset(c044.x);
  float4 _clipmapUVRelativeOffset : packoffset(c046.x);
  uint4 _surfelTimestamps : packoffset(c047.x);
};

cbuffer __3__35__0__0__ExposureConstantBuffer : register(b34, space35) {
  float4 _exposure0 : packoffset(c000.x);
  float4 _exposure1 : packoffset(c001.x);
  float4 _exposure2 : packoffset(c002.x);
  float4 _exposure3 : packoffset(c003.x);
  float4 _exposure4 : packoffset(c004.x);
};

cbuffer __3__35__0__0__TileConstantBuffer : register(b33, space35) {
  uint4 g_tileIndex[4096] : packoffset(c000.x);
};

cbuffer __3__35__0__0__CharacterOcclusionConstantBuffer : register(b1, space35) {
  float4 _characterOcclusionBounds[64] : packoffset(c000.x);
};

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _lightingParams : packoffset(c000.x);
  float4 _tiledRadianceCacheParams : packoffset(c001.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticVoxelSampler : register(s12, space4);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _19[4];
  int _28[2];
  int _29 = (int)(SV_GroupID.x) & 3;
  int _30 = (uint)(_29) >> 1;
  int _31 = _30 << 1;
  int _32 = _29 - _31;
  int _33 = _32 << 3;
  int _34 = _30 << 3;
  int _35 = (uint)(SV_GroupID.x) >> 2;
  int _36 = (uint)(SV_GroupID.x) >> 4;
  int _37 = _35 & 3;
  _19[0] = (int)((g_tileIndex[_36]).x);  // Fixed: was ((float)(...)) — decompiler bug, SampleManyLights uses (int)
  _19[1] = (int)((g_tileIndex[_36]).y);
  _19[2] = (int)((g_tileIndex[_36]).z);
  _19[3] = (int)((g_tileIndex[_36]).w);
  int _48 = _19[_37];
  int _49 = (uint)(_48) >> 16;
  uint _50 = _48 << 4;
  int _51 = _50 & 1048560;
  int _52 = _49 << 4;
  uint _53 = _51 + SV_GroupThreadID.x;
  uint _54 = _53 + _33;
  uint _55 = _34 + SV_GroupThreadID.y;
  uint _56 = _55 + _52;

  // Bypass tiled dispatch indirection to fix coordinate mismatch under Ray Reconstruction.
  // The tile culling pass populates g_tileIndex at a resolution that doesn't match the
  // raymarching buffers when RR is active, causing black mesh artifacts.
  // Using SV_DispatchThreadID directly ensures coordinates always match the target buffers.

  _54 = SV_DispatchThreadID.x;
  _56 = SV_DispatchThreadID.y;
  int _59 = _frameNumber.x & 1;
  int _60 = (uint)((uint)(_frameNumber.x)) >> 1;
  int _61 = _60 & 1;
  uint _62 = _54 << 1;
  uint _63 = _56 << 1;
  int _64 = _62 | _59;
  int _65 = _63 | _61;
  float _66 = float((uint)_64);
  float _67 = float((uint)_65);
  float _68 = _66 + 0.5f;
  float _69 = _67 + 0.5f;
  float _73 = _68 * _bufferSizeAndInvSize.z;
  float _74 = _69 * _bufferSizeAndInvSize.w;
  uint2 _76 = __3__36__0__0__g_normalDepth.Load(int3(_54, _56, 0));
  int _79 = (uint)((uint)(_76.y)) >> 24;
  int _80 = _76.y & 16777215;
  float _81 = float((uint)_80);
  float _82 = _81 * 5.960465188081798e-08f;
  int _83 = _79 & 127;
  int _84 = (uint)((uint)(_76.x)) >> 10;
  int _85 = (uint)((uint)(_76.x)) >> 20;
  int _86 = _76.x & 1023;
  int _87 = _84 & 1023;
  int _88 = _85 & 1023;
  float _89 = float((uint)_86);
  float _90 = float((uint)_87);
  float _91 = float((uint)_88);
  float _92 = _89 * 0.001956947147846222f;
  float _93 = _90 * 0.001956947147846222f;
  float _94 = _91 * 0.001956947147846222f;
  float _95 = _92 + -1.0f;
  float _96 = _93 + -1.0f;
  float _97 = _94 + -1.0f;
  float _98 = min(1.0f, _95);
  float _99 = min(1.0f, _96);
  float _100 = min(1.0f, _97);
  float _101 = dot(float3(_98, _99, _100), float3(_98, _99, _100));
  float _102 = rsqrt(_101);
  float _103 = _102 * _98;
  float _104 = _102 * _99;
  float _105 = _102 * _100;
  bool _106 = (_82 < 1.0000000116860974e-07f);
  bool _107 = (_82 == 1.0f);
  bool _108 = (_106) | (_107);
  int _227;
  int _285;
  float _412;
  float _413;
  float _414;
  float _435;
  float _436;
  float _437;
  float _438;
  float _439;
  float _440;
  float _441;
  float _442;
  float _462;
  float _491;
  float _579;
  float _580;
  float _581;
  float _582;
  float _625;
  int _703;
  int _704;
  int _705;
  float _706;
  float _707;
  float _708;
  float _709;
  float _710;
  int _712;
  int _824;
  int _825;
  int _826;
  int _827;
  int _828;
  int _829;
  int _830;
  float _941;
  int _962;
  int _963;
  int _973;
  int _974;
  float _994;
  int _995;
  float _997;
  int _998;
  int _999;
  int _1003;
  int _1065;
  float _1191;
  float _1193;
  int _1203;
  float _1204;
  int _1280;
  int _1281;
  int _1295;
  int _1296;
  if (!_108) {
    float _113 = max(1.0000000116860974e-07f, _82);
    float _114 = _nearFarProj.x / _113;
    float _115 = _73 * 2.0f;
    float _116 = _115 + -1.0f;
    float _117 = _74 * 2.0f;
    float _118 = 1.0f - _117;
    float _139 = (_invViewProjRelative[0].x) * _116;
    float _140 = mad((_invViewProjRelative[0].y), _118, _139);
    float _141 = mad((_invViewProjRelative[0].z), _113, _140);
    float _142 = _141 + (_invViewProjRelative[0].w);
    float _143 = (_invViewProjRelative[1].x) * _116;
    float _144 = mad((_invViewProjRelative[1].y), _118, _143);
    float _145 = mad((_invViewProjRelative[1].z), _113, _144);
    float _146 = _145 + (_invViewProjRelative[1].w);
    float _147 = (_invViewProjRelative[2].x) * _116;
    float _148 = mad((_invViewProjRelative[2].y), _118, _147);
    float _149 = mad((_invViewProjRelative[2].z), _113, _148);
    float _150 = _149 + (_invViewProjRelative[2].w);
    float _151 = (_invViewProjRelative[3].x) * _116;
    float _152 = mad((_invViewProjRelative[3].y), _118, _151);
    float _153 = mad((_invViewProjRelative[3].z), _113, _152);
    float _154 = _153 + (_invViewProjRelative[3].w);
    float _155 = _142 / _154;
    float _156 = _146 / _154;
    float _157 = _150 / _154;
    float _158 = dot(float3(_155, _156, _157), float3(_155, _156, _157));
    float _159 = rsqrt(_158);
    float _160 = _159 * _155;
    float _161 = _159 * _156;
    float _162 = _159 * _157;
    uint _163 = _frameNumber.x * 71;
    int _164 = _163 & 31;
    float _165 = float((uint)_164);
    float _166 = float((uint)_54);
    float _167 = float((uint)_56);
    float _168 = _165 * 32.665000915527344f;
    float _169 = _165 * 11.8149995803833f;
    float _170 = _168 + _166;
    float _171 = _169 + _167;
    float _172 = dot(float2(_170, _171), float2(0.0671105608344078f, 0.005837149918079376f));
    float _173 = frac(_172);
    float _174 = _173 * 52.98291778564453f;
    float _175 = frac(_174);
    float _176 = float((uint)(uint)(_frameNumber.x));
    float _177 = _176 * 92.0f;
    float _178 = _176 * 71.0f;
    float _179 = _166 + _177;
    float _180 = _178 + _167;
    float _181 = _179 * 0.0078125f;
    float _182 = _180 * 0.0078125f;
    float _183 = frac(_181);
    float _184 = frac(_182);
    float _185 = _183 * 128.0f;
    float _186 = _184 * 128.0f;
    float _187 = _185 + -64.34062194824219f;
    float _188 = _186 + -72.46562194824219f;
    float _189 = _187 * _187;
    float _190 = _188 * _188;
    float _191 = _188 * _187;
    float _192 = dot(float3(_189, _190, _191), float3(20.390625f, 60.703125f, 2.4281208515167236f));
    float _193 = frac(_192);
    float _194 = _193 * 51540816.0f;
    float _195 = _193 * 287478368.0f;
    uint _196 = uint(_194);
    uint _197 = uint(_195);
    float _200 = _lightingParams.y * 1.3258124589920044f;
    float _201 = -0.0f - _200;
    bool _202 = (_155 <= _200);
    bool _203 = (_156 <= _200);
    bool _204 = (_157 <= _200);
    bool _205 = (_155 >= _201);
    bool _206 = (_156 >= _201);
    bool _207 = (_157 >= _201);
    bool _208 = (_205) & (_202);
    bool _209 = (_206) & (_203);
    bool _210 = (_207) & (_204);
    bool _211 = (_208) & (_209);
    bool _212 = (_210) & (_211);
    uint2 _214 = __3__38__0__1__g_manyLightsHitDataUAV.Load(int2(_54, _56));
    int _217 = (uint)((uint)(_214.x)) >> 16;
    int _218 = _214.x & 65535;
    float _219 = float((uint)_218);
    float _220 = _219 * 0.015609979629516602f;
    bool _221 = (_217 == 32767);
    bool _222 = (_220 < 1000.0f);
    bool _223 = (_212) | (_222);
    bool _224 = (_221) | (_223);
    if (!_224) {
      _227 = 0;
      while(true) {
        int _228 = _227 + 20;
        float _234 = _voxelParams.x + -63.0f;
        float _235 = _voxelParams.y + -31.0f;
        float _236 = _voxelParams.z + -63.0f;
        int _237 = int(_234);
        int _238 = int(_235);
        int _239 = int(_236);
        float _240 = _voxelParams.x + 63.0f;
        float _241 = _voxelParams.y + 31.0f;
        float _242 = _voxelParams.z + 63.0f;
        int _243 = int(_240);
        int _244 = int(_241);
        int _245 = int(_242);
        float _250 = _wrappedViewPos.x + _155;
        float _251 = _wrappedViewPos.y + _156;
        float _252 = _wrappedViewPos.z + _157;
        float _253 = _250 * _voxelParams.w;
        float _254 = _251 * _voxelParams.w;
        float _255 = _252 * _voxelParams.w;
        int _256 = _227 + 36;
        float _261 = _253 + _voxelParams.x;
        float _262 = _254 + _voxelParams.y;
        float _263 = _255 + _voxelParams.z;
        float _264 = floor(_261);
        float _265 = floor(_262);
        float _266 = floor(_263);
        int _267 = int(_264);
        int _268 = int(_265);
        int _269 = int(_266);
        bool _270 = ((int)_267 < (int)_243);
        bool _271 = ((int)_268 < (int)_244);
        bool _272 = ((int)_269 < (int)_245);
        bool _273 = ((int)_267 >= (int)_237);
        bool _274 = ((int)_268 >= (int)_238);
        bool _275 = ((int)_269 >= (int)_239);
        bool _276 = (_273) & (_270);
        bool _277 = (_274) & (_271);
        bool _278 = (_275) & (_272);
        bool _279 = (_276) & (_277);
        bool _280 = (_279) & (_278);
        if (!_280) {
          int _282 = _227 + 1;
          bool _283 = ((uint)_282 < (uint)8);
          if (_283) {
            _227 = _282;
            continue;
          } else {
            _285 = -10000;
          }
        } else {
          _285 = _227;
        }
        int _288 = _285 & 31;
        uint _289 = 1u << _288;
        float _290 = float((int)(_289));
        float _291 = _290 * _voxelParams.x;
        float _292 = _291 * 0.5f;
        float _293 = _175 * 0.5f;
        float _294 = _293 + 0.20000000298023224f;
        float _295 = _291 * _294;
        int _296 = _54 & 3;
        int _297 = _296 << 1;
        int _298 = _297 | _296;
        int _299 = _298 & 5;
        int _300 = _56 & 3;
        int _301 = _300 << 1;
        int _302 = _301 | _300;
        int _303 = _302 << 1;
        int _304 = _303 & 10;
        int _305 = _304 | _299;
        uint _306 = _frameNumber.x * 117;
        uint _307 = _305 + _306;
        uint _308 = _307 << 2;
        int _309 = _308 & -858993460;
        int _310 = (uint)(_307) >> 2;
        int _311 = _310 & 858993459;
        int _312 = _309 | _311;
        uint _313 = _312 << 1;
        int _314 = _313 & 10;
        int _315 = (uint)(_312) >> 1;
        int _316 = _315 & 21;
        int _317 = _314 | _316;
        float _318 = float((uint)_317);
        float _319 = _318 * 0.03125f;
        int _320 = _196 & 65535;
        float _321 = float((uint)_320);
        float _322 = _321 * 1.52587890625e-05f;
        float _323 = _322 + _319;
        float _324 = frac(_323);
        int _325 = reversebits(_317);
        int _326 = _325 ^ _197;
        float _327 = float((uint)_326);
        float _328 = _327 * 2.3283064365386963e-10f;
        float _329 = _114 * 0.015625f;
        float _330 = saturate(_329);
        uint4 _334 = __3__36__0__0__g_baseColor.Load(int3(_64, _65, 0));
        int _338 = (uint)((uint)(_334.x)) >> 8;
        int _339 = _338 & 255;
        float _340 = float((uint)_339);
        float _341 = _340 * 0.003921568859368563f;
        int _342 = _334.x & 255;
        float _343 = float((uint)_342);
        float _344 = _343 * 0.003921568859368563f;
        int _345 = (uint)((uint)(_334.y)) >> 8;
        int _346 = _345 & 255;
        float _347 = float((uint)_346);
        float _348 = _347 * 0.003921568859368563f;
        int _349 = _334.y & 255;
        float _350 = float((uint)_349);
        float _351 = _350 * 0.003921568859368563f;
        int _352 = (uint)((uint)(_334.z)) >> 8;
        int _353 = _352 & 255;
        float _354 = float((uint)_353);
        float _355 = _354 * 0.003921568859368563f;
        float _356 = _341 * _341;
        float _357 = _344 * _344;
        float _358 = _348 * _348;
        float _359 = saturate(_356);
        float _360 = saturate(_357);
        float _361 = saturate(_358);
        float _362 = _359 * 0.6131200194358826f;
        float _363 = _359 * 0.07020000368356705f;
        float _364 = _359 * 0.02061999961733818f;
        float _365 = _360 * 0.3395099937915802f;
        float _366 = _360 * 0.9163600206375122f;
        float _367 = _360 * 0.10958000272512436f;
        float _368 = _365 + _362;
        float _369 = _366 + _363;
        float _370 = _367 + _364;
        float _371 = _361 * 0.047370001673698425f;
        float _372 = _361 * 0.013450000435113907f;
        float _373 = _361 * 0.8697999715805054f;
        float _374 = _368 + _371;
        float _375 = _369 + _372;
        float _376 = _370 + _373;
        float _377 = saturate(_374);
        float _378 = saturate(_375);
        float _379 = saturate(_376);
        int4 _381 = asint(__3__37__0__0__g_structureCounterBuffer.Load4(4));
        bool _383 = ((uint)_217 < (uint)_381.x);
        if (_383) {
          float _387 = __3__37__0__0__g_manyLightsDataBuffer[_217]._position.x;
          float _388 = __3__37__0__0__g_manyLightsDataBuffer[_217]._position.y;
          float _389 = __3__37__0__0__g_manyLightsDataBuffer[_217]._position.z;
          float _390 = __3__37__0__0__g_manyLightsDataBuffer[_217]._position.w;
          float _392 = __3__37__0__0__g_manyLightsDataBuffer[_217]._color.x;
          float _393 = __3__37__0__0__g_manyLightsDataBuffer[_217]._color.y;
          float _394 = __3__37__0__0__g_manyLightsDataBuffer[_217]._color.z;
          float _395 = __3__37__0__0__g_manyLightsDataBuffer[_217]._color.w;
          int _397 = __3__37__0__0__g_manyLightsDataBuffer[_217]._up.x;
          bool _398 = (_390 < 0.0f);
          if (_398) {
            int _400 = __3__37__0__0__g_manyLightsDataBuffer[_217]._up.y;
            int _401 = _397 & 65535;
            int _402 = (uint)(_397) >> 16;
            int _403 = _400 & 65535;
            float _404 = f16tof32(_401);
            float _405 = f16tof32(_402);
            float _406 = f16tof32(_403);
            float _407 = abs(_390);
            float _408 = _407 * _404;
            float _409 = _407 * _405;
            float _410 = _407 * _406;
            _412 = _408;
            _413 = _409;
            _414 = _410;
          } else {
            _412 = 0.0f;
            _413 = 0.0f;
            _414 = 0.0f;
          }
          float _415 = _412 * _175;
          float _416 = _413 * _175;
          float _417 = _414 * _175;
          float _418 = _387 - _155;
          float _419 = _415 + _418;
          float _420 = _388 - _156;
          float _421 = _416 + _420;
          float _422 = _389 - _157;
          float _423 = _417 + _422;
          float _424 = _419 * _419;
          float _425 = _421 * _421;
          float _426 = _425 + _424;
          float _427 = _423 * _423;
          float _428 = _426 + _427;
          float _429 = sqrt(_428);
          float _430 = 1.0f / _429;
          float _431 = _430 * _419;
          float _432 = _430 * _421;
          float _433 = _423 * _430;
          _435 = _431;
          _436 = _432;
          _437 = _433;
          _438 = _429;
          _439 = _392;
          _440 = _393;
          _441 = _394;
          _442 = _395;
        } else {
          _435 = 0.0f;
          _436 = 0.0f;
          _437 = 0.0f;
          _438 = 512.0f;
          _439 = 0.0f;
          _440 = 0.0f;
          _441 = 0.0f;
          _442 = 0.0f;
        }
        bool _443 = (_442 > 99999.0f);
        if (!_443) {
          float _445 = dot(float3(_439, _440, _441), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
          float _448 = _cavityParams.w * 192.0f;
          float _449 = _448 + 128.0f;
          float _450 = min(512.0f, _449);
          float _451 = _cavityParams.w * 0.20000000298023224f;
          float _452 = _451 + 0.20000000298023224f;
          float _453 = min(0.6000000238418579f, _452);
          float _454 = _453 * 0.25f;
          float _455 = _exposure2.x * 8.0f;
          float _456 = max(9.999999974752427e-07f, _455);
          float _457 = _454 / _456;
          float _458 = _457 * _445;
          float _459 = _458 + 8.0f;
          float _460 = min(_450, _459);
          _462 = _460;
        } else {
          _462 = _442;
        }
        float _463 = abs(_442);
        float _464 = _438 * _438;
        float _465 = _463 * _463;
        float _466 = max(_465, _464);
        bool _467 = (_463 > 99999.0f);
        float _468 = 1.0f / _466;
        float _469 = select(_467, 1.0f, _468);
        float _470 = _469 * _439;
        float _471 = _469 * _440;
        float _472 = _469 * _441;
        int _473 = _79 & 126;
        bool _474 = (_473 == 96);
        bool _475 = (_83 == 98);
        bool _476 = (_474) | (_475);
        bool __defer_461_489 = false;
        if (!_476) {
          bool _478 = ((uint)_83 > (uint)10);
          if (_478) {
            bool _480 = ((uint)_83 < (uint)20);
            bool _481 = (_83 == 107);
            bool _482 = (_480) | (_481);
            bool _483 = (_83 == 65);
            bool _484 = (_483) | (_482);
            bool _485 = (_83 == 24);
            bool _486 = (_485) | (_484);
            bool _487 = (_83 == 29);
            bool _488 = (_487) | (_486);
            if (_488) {
              __defer_461_489 = true;
            } else {
              _491 = _351;
            }
          } else {
            _491 = _351;
          }
        } else {
          __defer_461_489 = true;
        }
        if (__defer_461_489) {
          _491 = 0.0f;
        }
        float _492 = max(_377, _378);
        float _493 = max(_492, _379);
        float _494 = max(_493, 0.009999999776482582f);
        float _495 = min(_494, 0.699999988079071f);
        float _496 = 0.699999988079071f / _495;
        float _497 = _496 * _378;
        float _498 = _497 + -0.03999999910593033f;
        float _499 = _498 * _491;
        float _500 = _499 + 0.03999999910593033f;
        float _501 = max(0.0010000000474974513f, _500);
        float _502 = max(0.10000000149011612f, _355);
        float _503 = _502 * _502;
        float _504 = _435 - _160;
        float _505 = _436 - _161;
        float _506 = _437 - _162;
        float _507 = dot(float3(_504, _505, _506), float3(_504, _505, _506));
        float _508 = rsqrt(_507);
        float _509 = _508 * _504;
        float _510 = _508 * _505;
        float _511 = _508 * _506;
        float _512 = dot(float3(_103, _104, _105), float3(_435, _436, _437));
        float _513 = -0.0f - _160;
        float _514 = -0.0f - _161;
        float _515 = -0.0f - _162;
        float _516 = dot(float3(_103, _104, _105), float3(_513, _514, _515));
        float _517 = saturate(_516);
        float _518 = dot(float3(_103, _104, _105), float3(_509, _510, _511));
        float _519 = saturate(_518);
        bool _520 = !(_512 <= 0.0f);
        if (_520) {
          float _522 = dot(float3(_513, _514, _515), float3(_509, _510, _511));
          float _523 = _496 * _379;
          float _524 = _523 + -0.03999999910593033f;
          float _525 = _524 * _491;
          float _526 = _525 + 0.03999999910593033f;
          float _527 = max(0.0010000000474974513f, _526);
          float _528 = _496 * _377;
          float _529 = _528 + -0.03999999910593033f;
          float _530 = _529 * _491;
          float _531 = _530 + 0.03999999910593033f;
          float _532 = max(0.0010000000474974513f, _531);
          float _533 = 1.0f - _522;
          float _534 = saturate(_533);
          float _535 = _534 * _534;
          float _536 = _535 * _535;
          float _537 = _536 * _534;
          float _538 = _501 * 50.0f;
          float _539 = saturate(_538);
          float _540 = _537 * _539;
          float _541 = 1.0f - _537;
          float _542 = _541 * _532;
          float _543 = _541 * _501;
          float _544 = _541 * _527;
          float _545 = _542 + _540;
          float _546 = _543 + _540;
          float _547 = _544 + _540;
          float _548 = _512 * 0.31830987334251404f;
          float _549 = saturate(_512);
          float _550 = 1.0f - _503;
          float _551 = _517 * _550;
          float _552 = _551 + _503;
          float _553 = _552 * _512;
          float _554 = _512 * _550;
          float _555 = _554 + _503;
          float _556 = _517 * _555;
          float _557 = _553 + _556;
          float _558 = 0.5f / _557;
          float _559 = _519 * _503;
          float _560 = _559 - _519;
          float _561 = _560 * _519;
          float _562 = _561 + 1.0f;
          float _563 = _562 * _562;
          float _564 = _563 * 3.1415927410125732f;
          float _565 = _503 / _564;
          float _566 = _565 * _558;
          float _567 = _545 * _566;
          float _568 = _546 * _566;
          float _569 = _547 * _566;
          float _570 = max(_567, 0.0f);
          float _571 = max(_568, 0.0f);
          float _572 = max(_569, 0.0f);
          float _573 = _570 * _549;
          float _574 = _571 * _549;
          float _575 = _572 * _549;
          float _576 = _548 * 0.75f;
          float _577 = _576 + 0.25f;
          _579 = _573;
          _580 = _574;
          _581 = _575;
          _582 = _577;
        } else {
          _579 = 0.0f;
          _580 = 0.0f;
          _581 = 0.0f;
          _582 = 0.25f;
        }
        bool __defer_578_601 = false;
        if ((_443) || ((((_438 < _462))) & ((((dot(float3((_470 * (((saturate(_582)) * _377) + _579)), (_471 * (((saturate(_582)) * _378) + _580)), (_472 * (((saturate(_582)) * _379) + _581))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f))) > (((_330 * 0.36000001430511475f) + 0.03999999910593033f) * _exposure2.x)))))) {
          __defer_578_601 = true;
        } else {
          _1203 = 32767;
          _1204 = 1023.0f;
        }
        if (__defer_578_601) {
          float _602 = _463 * 0.5f;
          float _603 = _602 / _438;
          float _604 = max(0.03999999910593033f, _603);
          float _605 = _438 * 0.20000000298023224f;
          float _606 = _605 + 1.0f;
          float _607 = 1.0f / _606;
          float _608 = _607 * _463;
          float _609 = select(_443, 0.0f, _608);
          float _610 = _609 * _609;
          float _611 = _610 * 0.25f;
          float _612 = _611 / _464;
          float _613 = saturate(_612);
          float _614 = _324 * 6.2831854820251465f;
          bool _615 = (_613 < 0.009999999776482582f);
          if (_615) {
            float _617 = _613 * 0.125f;
            float _618 = _617 + 0.5f;
            float _619 = _618 * _613;
            _625 = _619;
          } else {
            float _621 = 1.0f - _613;
            float _622 = sqrt(_621);
            float _623 = 1.0f - _622;
            _625 = _623;
          }
          float _626 = _328 * _625;
          float _627 = 1.0f - _626;
          float _628 = _627 * _627;
          float _629 = 1.0f - _628;
          float _630 = sqrt(_629);
          float _631 = sin(_614);
          float _632 = cos(_614);
          float _633 = _632 * _630;
          float _634 = _631 * _630;
          bool _635 = (_437 >= 0.0f);
          float _636 = select(_635, 1.0f, -1.0f);
          float _637 = _636 + _437;
          float _638 = 1.0f / _637;
          float _639 = -0.0f - _638;
          float _640 = _436 * _639;
          float _641 = _640 * _435;
          float _642 = _636 * _435;
          float _643 = _642 * _435;
          float _644 = _643 * _639;
          float _645 = _644 + 1.0f;
          float _646 = _640 * _436;
          float _647 = _636 + _646;
          float _648 = -0.0f - _436;
          float _649 = _645 * _633;
          float _650 = mad(_634, _641, _649);
          float _651 = mad(_627, _435, _650);
          float _652 = _633 * _636;
          float _653 = _652 * _641;
          float _654 = mad(_634, _647, _653);
          float _655 = mad(_627, _436, _654);
          float _656 = _642 * _633;
          float _657 = -0.0f - _656;
          float _658 = mad(_634, _648, _657);
          float _659 = mad(_627, _437, _658);
          float _660 = _609 * 2.0f;
          float _661 = _438 - _660;
          float _662 = max(0.009999999776482582f, _661);
          float _663 = _662 - _292;
          float _664 = max(0.009999999776482582f, _663);
          bool _665 = (_285 == -10000);
          if (!_665) {
            float _667 = dot(float3(_103, _104, _105), float3(_651, _655, _659));
            bool _668 = ((int)_285 < (int)-9999);
            if (!_668) {
              float _670 = _voxelParams.x * 0.05000000074505806f;
              float _671 = max(0.0f, _670);
              float _672 = 1.0f / _651;
              float _673 = 1.0f / _655;
              float _674 = 1.0f / _659;
              bool _675 = (_651 == 0.0f);
              bool _676 = (_655 == 0.0f);
              bool _677 = (_659 == 0.0f);
              float _678 = select(_675, 0.0f, _672);
              float _679 = select(_676, 0.0f, _673);
              float _680 = select(_677, 0.0f, _674);
              bool _681 = (_651 > 0.0f);
              bool _682 = (_655 > 0.0f);
              bool _683 = (_659 > 0.0f);
              float _684 = select(_681, 1.0f, 0.0f);
              float _685 = select(_682, 1.0f, 0.0f);
              float _686 = select(_683, 1.0f, 0.0f);
              int _687 = _83 + -53;
              bool _688 = ((uint)_687 < (uint)15);
              bool _689 = (_83 == 57);
              bool _690 = (_689) | (_688);
              float _692 = _114 * _114;
              float _693 = _692 * 9.999999747378752e-05f;
              bool _694 = (_295 < _664);
              if (_694) {
                float _696 = _659 * _295;
                float _697 = _696 + _157;
                float _698 = _655 * _295;
                float _699 = _698 + _156;
                float _700 = _651 * _295;
                float _701 = _700 + _155;
                _703 = 0;
                _704 = 0;
                _705 = 0;
                _706 = 0.0f;
                _707 = _295;
                _708 = _697;
                _709 = _699;
                _710 = _701;
                while(true) {
                  _712 = 0;
                  while(true) {
                    int _713 = _712 + 20;
                    float _719 = _voxelParams.x + -63.0f;
                    float _720 = _voxelParams.y + -31.0f;
                    float _721 = _voxelParams.z + -63.0f;
                    float _726 = _wrappedViewPos.x + _710;
                    float _727 = _wrappedViewPos.y + _709;
                    float _728 = _wrappedViewPos.z + _708;
                    float _729 = _726 * _voxelParams.w;
                    float _730 = _727 * _voxelParams.w;
                    float _731 = _728 * _voxelParams.w;
                    int _732 = _712 + 36;
                    float _737 = _729 + _voxelParams.x;
                    float _738 = _730 + _voxelParams.y;
                    float _739 = _731 + _voxelParams.z;
                    bool _740 = (_737 >= _719);
                    bool _741 = (_738 >= _720);
                    bool _742 = (_739 >= _721);
                    bool _743 = (_740) & (_741);
                    bool _744 = (_742) & (_743);
                    if (_744) {
                      float _746 = _voxelParams.z + 63.0f;
                      float _747 = _voxelParams.y + 31.0f;
                      float _748 = _voxelParams.x + 63.0f;
                      bool _749 = (_737 < _748);
                      bool _750 = (_738 < _747);
                      bool _751 = (_739 < _746);
                      bool _752 = (_749) & (_750);
                      bool _753 = (_751) & (_752);
                      if (!_753) {
                        int _755 = _712 + 1;
                        bool _756 = ((int)_755 < (int)8);
                        if (_756) {
                          _712 = _755;
                          continue;
                        } else {
                          _997 = _707;
                          _998 = -10000;
                          _999 = _704;
                        }
                      } else {
                        bool _758 = (_712 == -10000);
                        bool __defer_757_993 = false;
                        if (!_758) {
                          int _760 = _712 & 31;
                          uint _761 = 1u << _760;
                          float _762 = float((int)(_761));
                          float _763 = 1.0f / _762;
                          float _764 = _762 * _voxelParams.x;
                          float _769 = _invClipmapExtent.x * _710;
                          float _770 = _invClipmapExtent.y * _709;
                          float _771 = _invClipmapExtent.z * _708;
                          float _776 = _769 + _clipmapUVRelativeOffset.x;
                          float _777 = _770 + _clipmapUVRelativeOffset.y;
                          float _778 = _771 + _clipmapUVRelativeOffset.z;
                          float _779 = _764 * 2.0f;
                          float _780 = _776 * _763;
                          float _781 = _777 * _763;
                          float _782 = _778 * _763;
                          float _783 = _780 * 64.0f;
                          float _784 = _781 * 32.0f;
                          float _785 = _782 * 64.0f;
                          float _786 = floor(_783);
                          float _787 = floor(_784);
                          float _788 = floor(_785);
                          int _789 = int(_786);
                          int _790 = int(_787);
                          int _791 = int(_788);
                          int _792 = _789 & 63;
                          int _793 = _790 & 31;
                          int _794 = _791 & 63;
                          int _795 = _712 << 6;
                          int _796 = _794 | _795;
                          uint4 _798 = __3__36__0__0__g_axisAlignedDistanceTextures.Load(int4(_792, _793, _796, 0));
                          int _803 = _798.x & 15;
                          int _804 = _798.y & 15;
                          int _805 = _798.z & 15;
                          int _806 = (uint)((uint)(_798.x)) >> 4;
                          int _807 = _806 & 15;
                          int _808 = (uint)((uint)(_798.y)) >> 4;
                          int _809 = _808 & 15;
                          int _810 = (uint)((uint)(_798.z)) >> 4;
                          int _811 = _810 & 15;
                          int _812 = _798.w & 2;
                          bool _813 = (_812 != 0);
                          int _814 = (uint)((uint)(_798.w)) >> 2;
                          float _815 = float((uint)_814);
                          float _816 = _815 * 0.01587301678955555f;
                          float _817 = saturate(_816);
                          if (_813) {
                            uint _819 = (uint)(_798.x) << 16;
                            uint _820 = (uint)(_798.y) << 8;
                            int _821 = _820 | _798.z;
                            int _822 = _821 | _819;
                            _824 = _822;
                            _825 = 0;
                            _826 = 0;
                            _827 = 0;
                            _828 = 0;
                            _829 = 0;
                            _830 = 0;
                          } else {
                            _824 = 0;
                            _825 = _807;
                            _826 = _809;
                            _827 = _811;
                            _828 = _803;
                            _829 = _804;
                            _830 = _805;
                          }
                          float _831 = _780 * 256.0f;
                          float _832 = _781 * 128.0f;
                          float _833 = _782 * 256.0f;
                          float _834 = frac(_831);
                          float _835 = frac(_832);
                          float _836 = frac(_833);
                          float _837 = _684 - _834;
                          float _838 = _685 - _835;
                          float _839 = _686 - _836;
                          float _840 = _837 * _678;
                          float _841 = _838 * _679;
                          float _842 = _839 * _680;
                          float _843 = select(_675, 999999.0f, _840);
                          float _844 = select(_676, 999999.0f, _841);
                          float _845 = select(_677, 999999.0f, _842);
                          float _846 = min(_843, _844);
                          float _847 = min(_846, _845);
                          float _848 = _764 * 0.5f;
                          float _849 = _848 * _847;
                          float _850 = float((int)(_789));
                          float _851 = float((int)(_790));
                          float _852 = float((int)(_791));
                          float _853 = _783 - _850;
                          float _854 = _784 - _851;
                          float _855 = _785 - _852;
                          float _856 = float((uint)_828);
                          float _857 = float((uint)_829);
                          float _858 = float((uint)_830);
                          float _859 = 0.9900000095367432f - _853;
                          float _860 = _859 - _856;
                          float _861 = 0.9900000095367432f - _854;
                          float _862 = _861 - _857;
                          float _863 = 0.9900000095367432f - _855;
                          float _864 = _863 - _858;
                          float _865 = float((uint)_825);
                          float _866 = float((uint)_826);
                          float _867 = float((uint)_827);
                          float _868 = 0.009999999776482582f - _853;
                          float _869 = _868 + _865;
                          float _870 = 0.009999999776482582f - _854;
                          float _871 = _870 + _866;
                          float _872 = 0.009999999776482582f - _855;
                          float _873 = _872 + _867;
                          float _874 = select(_681, _869, _860);
                          float _875 = select(_682, _871, _862);
                          float _876 = select(_683, _873, _864);
                          float _877 = _874 * _678;
                          float _878 = _875 * _679;
                          float _879 = _876 * _680;
                          float _880 = select(_675, 999999.0f, _877);
                          float _881 = select(_676, 999999.0f, _878);
                          float _882 = select(_677, 999999.0f, _879);
                          float _883 = min(_880, _881);
                          float _884 = min(_883, _882);
                          float _885 = _779 * _884;
                          float _886 = max(_849, _885);
                          bool _887 = (_817 > 0.0f);
                          float _888 = float((bool)_887);
                          float _889 = frac(_782);
                          bool _890 = (_889 < 0.0f);
                          float _891 = select(_890, 1.0f, 0.0f);
                          float _892 = _891 + _889;
                          float _893 = _892 * 128.0f;
                          uint _894 = _712 * 130;
                          float _895 = float((uint)_894);
                          float _896 = _895 + 1.0f;
                          float _897 = _896 + _893;
                          float _898 = _897 * 0.000961538462433964f;
                          float _901 = __3__36__0__1__g_signedDistanceVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_780, _781, _898), 0.0f);
                          float _903 = _707 * 0.5f;
                          float _904 = _903 + 0.5f;
                          float _905 = saturate(_904);
                          float _906 = _901.x + _693;
                          float _907 = _707 * _604;
                          float _908 = _667 * 0.875f;
                          float _909 = _908 + 0.125f;
                          float _910 = _909 / _764;
                          float _911 = _910 * 0.5f;
                          float _912 = max(1.0f, _911);
                          float _913 = _912 * _910;
                          float _914 = _664 - _707;
                          float _915 = max(0.0f, _914);
                          float _916 = min(_707, _915);
                          float _917 = _913 * _916;
                          float _918 = _917 + -1.0f;
                          float _919 = saturate(_918);
                          float _920 = _764 * 1.0606600046157837f;
                          float _921 = _920 * _905;
                          float _922 = max(_921, _907);
                          float _923 = _922 - _907;
                          float _924 = _923 * _919;
                          float _925 = _924 + _907;
                          float _926 = _906 / _925;
                          float _927 = _926 * _926;
                          float _928 = 1.0f - _927;
                          float _929 = saturate(_928);
                          float _930 = 1.0f - _706;
                          float _931 = _888 * _930;
                          float _932 = _931 * _929;
                          float _933 = _932 + _706;
                          float _934 = saturate(_933);
                          bool _935 = (_901.x > _764);
                          bool _936 = (_114 > 64.0f);
                          bool _937 = (_936) | (_935);
                          if (!_937) {
                            float _939 = min(_886, _901.x);
                            _941 = _939;
                          } else {
                            _941 = _886;
                          }
                          float _942 = max(_941, _671);
                          bool _943 = !_690;
                          bool _944 = (_707 > 0.5f);
                          bool _945 = (_944) | (_943);
                          bool _946 = ((uint)_704 < (uint)2);
                          bool _947 = (_946) & (_813);
                          bool _948 = (_945) & (_947);
                          if (_948) {
                            int _950 = _824 & 63;
                            int _951 = _824 & 31;
                            uint _952 = 1u << _951;
                            bool _953 = (_950 != 63);
                            int _954 = _952 & _705;
                            bool _955 = (_954 == 0);
                            bool _956 = (_953) & (_955);
                            if (_956) {
                              uint _958 = _704 + 1u;
                              _28[_704] = _950;
                              int _960 = _952 | _705;
                              _962 = _960;
                              _963 = _958;
                            } else {
                              _962 = _705;
                              _963 = _704;
                            }
                            int _964 = (uint)(_824) >> 6;
                            int _965 = _964 & 63;
                            int _966 = _964 & 31;
                            uint _967 = 1u << _966;
                            bool _968 = (_965 != 63);
                            int _969 = _962 & _967;
                            bool _970 = (_969 == 0);
                            bool _971 = (_968) & (_970);
                            if (_971) {
                              uint _1276 = _963 + 1u;
                              _28[_963] = _965;
                              int _1278 = _962 | _967;
                              _1280 = _1278;
                              _1281 = _1276;
                            } else {
                              _1280 = _962;
                              _1281 = _963;
                            }
                            int _1282 = (uint)(_824) >> 12;
                            int _1283 = _1282 & 63;
                            int _1284 = _1282 & 31;
                            uint _1285 = 1u << _1284;
                            bool _1286 = (_1283 != 63);
                            int _1287 = _1280 & _1285;
                            bool _1288 = (_1287 == 0);
                            bool _1289 = (_1286) & (_1288);
                            if (_1289) {
                              uint _1291 = _1281 + 1u;
                              _28[_1281] = _1283;
                              int _1293 = _1280 | _1285;
                              _1295 = _1293;
                              _1296 = _1291;
                            } else {
                              _1295 = _1280;
                              _1296 = _1281;
                            }
                            int _1297 = (uint)(_824) >> 18;
                            int _1298 = _1297 & 63;
                            int _1299 = _1297 & 31;
                            uint _1300 = 1u << _1299;
                            bool _1301 = (_1298 != 63);
                            int _1302 = _1295 & _1300;
                            bool _1303 = (_1302 == 0);
                            bool _1304 = (_1301) & (_1303);
                            if (_1304) {
                              uint _1306 = _1296 + 1u;
                              _28[_1296] = _1298;
                              int _1308 = _1295 | _1300;
                              _973 = _1308;
                              _974 = _1306;
                            } else {
                              _973 = _1295;
                              _974 = _1296;
                            }
                          } else {
                            _973 = _705;
                            _974 = _704;
                          }
                          bool _975 = !(_934 >= 0.5f);
                          if (!_975) {
                            float _977 = _901.x + _707;
                            float _978 = float((int)(_712));
                            int _979 = int(_978);
                            _997 = _977;
                            _998 = _979;
                            _999 = _974;
                          } else {
                            float _981 = _942 + _707;
                            float _982 = _942 * _651;
                            float _983 = _942 * _655;
                            float _984 = _942 * _659;
                            float _985 = _982 + _710;
                            float _986 = _983 + _709;
                            float _987 = _984 + _708;
                            int _988 = _703 + 1;
                            bool _989 = ((uint)_988 < (uint)256);
                            bool _990 = (_981 < _664);
                            bool _991 = (_989) & (_990);
                            if (_991) {
                              _703 = _988;
                              _704 = _974;
                              _705 = _973;
                              _706 = _934;
                              _707 = _981;
                              _708 = _987;
                              _709 = _986;
                              _710 = _985;
                              __loop_jump_target = 702;
                              break;
                            } else {
                              _994 = _981;
                              _995 = _974;
                              __defer_757_993 = true;
                            }
                          }
                        } else {
                          _994 = _707;
                          _995 = _704;
                          __defer_757_993 = true;
                        }
                        if (__defer_757_993) {
                          _997 = _994;
                          _998 = -10000;
                          _999 = _995;
                        }
                      }
                    } else {
                      int _755 = _712 + 1;
                      bool _756 = ((int)_755 < (int)8);
                      if (_756) {
                        _712 = _755;
                        continue;
                      } else {
                        _997 = _707;
                        _998 = -10000;
                        _999 = _704;
                      }
                    }
                    break;
                  }
                  if (__loop_jump_target == 702) {
                    __loop_jump_target = -1;
                    continue;
                  }
                  if (__loop_jump_target != -1) {
                    break;
                  }
                  break;
                }
                if (__loop_jump_target == 226) {
                  __loop_jump_target = -1;
                  continue;
                }
                if (__loop_jump_target != -1) {
                  break;
                }
              } else {
                _997 = _295;
                _998 = -10000;
                _999 = 0;
              }
              bool _1000 = (_999 == 0);
              bool __defer_996_1186 = false;
              [branch]
              if (!_1000) {
                _1003 = 0;
                while(true) {
                  int _1005 = _28[_1003];
                  int _1006 = min(63, _1005);
                  uint _1007 = _1006 * 17;
                  uint _1008 = _1006 << 1;
                  int _1013 = _1008 | 1;
                  float _1018 = ((_characterOcclusionBounds[_1008]).x) - _155;
                  float _1019 = ((_characterOcclusionBounds[_1008]).y) - _156;
                  float _1020 = ((_characterOcclusionBounds[_1008]).z) - _157;
                  float _1021 = ((_characterOcclusionBounds[_1013]).x) - _155;
                  float _1022 = ((_characterOcclusionBounds[_1013]).y) - _156;
                  float _1023 = ((_characterOcclusionBounds[_1013]).z) - _157;
                  float _1024 = _1021 * _1021;
                  float _1025 = _1022 * _1022;
                  float _1026 = _1024 + _1025;
                  float _1027 = _1023 * _1023;
                  float _1028 = _1026 + _1027;
                  float _1029 = sqrt(_1028);
                  float _1030 = _1018 * _1018;
                  float _1031 = _1019 * _1019;
                  float _1032 = _1030 + _1031;
                  float _1033 = _1020 * _1020;
                  float _1034 = _1032 + _1033;
                  float _1035 = sqrt(_1034);
                  float _1036 = max(_1035, _1029);
                  float _1037 = _1036 * 0.009999999776482582f;
                  float _1038 = _1018 - _1037;
                  float _1039 = _1019 - _1037;
                  float _1040 = _1020 - _1037;
                  float _1041 = _1038 * _678;
                  float _1042 = _1039 * _679;
                  float _1043 = _1040 * _680;
                  float _1044 = _1037 + _1021;
                  float _1045 = _1037 + _1022;
                  float _1046 = _1037 + _1023;
                  float _1047 = _1044 * _678;
                  float _1048 = _1045 * _679;
                  float _1049 = _1046 * _680;
                  float _1050 = min(_1043, _1049);
                  float _1051 = min(_1042, _1048);
                  float _1052 = min(_1041, _1047);
                  float _1053 = max(_1052, _1051);
                  float _1054 = max(_1053, _1050);
                  float _1055 = max(_1043, _1049);
                  float _1056 = max(_1042, _1048);
                  float _1057 = max(_1041, _1047);
                  float _1058 = min(_1057, _1056);
                  float _1059 = min(_1058, _1055);
                  bool _1060 = !(_1059 >= 0.0f);
                  bool _1061 = !(_1054 <= _1059);
                  bool _1062 = (_1060) | (_1061);
                  if (!_1062) {
                    _1065 = 0;
                    while(true) {
                      uint _1066 = _1065 + _1007;
                      float _1069 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._positionRadius.x;
                      float _1070 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._positionRadius.y;
                      float _1071 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._positionRadius.z;
                      float _1072 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._positionRadius.w;
                      float _1074 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._offsetOcclusionIndices.x;
                      float _1075 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._offsetOcclusionIndices.y;
                      float _1076 = __3__37__0__0__g_characterOcclusionDataBuffer[_1066]._offsetOcclusionIndices.z;
                      float _1077 = _1069 - _155;
                      float _1078 = _1070 - _156;
                      float _1079 = _1071 - _157;
                      float _1080 = _1074 * _1074;
                      float _1081 = _1075 * _1075;
                      float _1082 = _1080 + _1081;
                      float _1083 = _1076 * _1076;
                      float _1084 = _1082 + _1083;
                      float _1085 = sqrt(_1084);
                      float _1086 = _1074 / _1085;
                      float _1087 = _1075 / _1085;
                      float _1088 = _1076 / _1085;
                      float _1089 = _1088 * _655;
                      float _1090 = _1087 * _659;
                      float _1091 = _1089 - _1090;
                      float _1092 = _1086 * _659;
                      float _1093 = _1088 * _651;
                      float _1094 = _1092 - _1093;
                      float _1095 = _1087 * _651;
                      float _1096 = _1086 * _655;
                      float _1097 = _1095 - _1096;
                      float _1098 = _1091 * _1091;
                      float _1099 = _1094 * _1094;
                      float _1100 = _1097 * _1097;
                      float _1101 = _1099 + _1100;
                      float _1102 = _1101 + _1098;
                      float _1103 = sqrt(_1102);
                      float _1104 = _1091 / _1103;
                      float _1105 = _1094 / _1103;
                      float _1106 = _1097 / _1103;
                      float _1107 = dot(float3(_1077, _1078, _1079), float3(_1104, _1105, _1106));
                      float _1108 = _1107 * _1104;
                      float _1109 = _1107 * _1105;
                      float _1110 = _1107 * _1106;
                      float _1111 = _1077 - _1108;
                      float _1112 = _1078 - _1109;
                      float _1113 = _1079 - _1110;
                      float _1114 = _1112 * _1088;
                      float _1115 = _1113 * _1087;
                      float _1116 = _1114 - _1115;
                      float _1117 = _1113 * _1086;
                      float _1118 = _1111 * _1088;
                      float _1119 = _1117 - _1118;
                      float _1120 = _1111 * _1087;
                      float _1121 = _1112 * _1086;
                      float _1122 = _1120 - _1121;
                      float _1123 = _1116 * _1116;
                      float _1124 = _1119 * _1119;
                      float _1125 = _1123 + _1124;
                      float _1126 = _1122 * _1122;
                      float _1127 = _1125 + _1126;
                      float _1128 = sqrt(_1127);
                      float _1129 = _1128 / _1103;
                      float _1130 = dot(float3(_1104, _1105, _1106), float3(_1116, _1119, _1122));
                      bool _1131 = (_1130 < 0.0f);
                      float _1132 = -0.0f - _1129;
                      float _1133 = select(_1131, _1132, _1129);
                      float _1134 = max(0.0f, _1133);
                      float _1135 = _1134 * _651;
                      float _1136 = _1134 * _655;
                      float _1137 = _1134 * _659;
                      float _1138 = _1133 * _651;
                      float _1139 = _1133 * _655;
                      float _1140 = _1133 * _659;
                      float _1141 = _155 - _1069;
                      float _1142 = _1141 + _1108;
                      float _1143 = _1142 + _1138;
                      float _1144 = _156 - _1070;
                      float _1145 = _1144 + _1109;
                      float _1146 = _1145 + _1139;
                      float _1147 = _157 - _1071;
                      float _1148 = _1147 + _1110;
                      float _1149 = _1148 + _1140;
                      float _1150 = dot(float3(_1143, _1146, _1149), float3(_1086, _1087, _1088));
                      float _1151 = max(_1150, 0.0f);
                      float _1152 = min(_1151, _1085);
                      float _1153 = _1152 * _1086;
                      float _1154 = _1152 * _1087;
                      float _1155 = _1152 * _1088;
                      float _1156 = _1077 - _1135;
                      float _1157 = _1153 + _1156;
                      float _1158 = _1078 - _1136;
                      float _1159 = _1154 + _1158;
                      float _1160 = _1079 - _1137;
                      float _1161 = _1155 + _1160;
                      float _1162 = _1134 * 0.009999999776482582f;
                      float _1163 = _1162 + _1072;
                      float _1164 = dot(float3(_1157, _1159, _1161), float3(_1157, _1159, _1161));
                      float _1165 = _1163 * _1163;
                      bool _1166 = (_1164 < _1165);
                      if (_1166) {
                        bool _1168 = (_689) | (_688);
                        bool _1169 = !_1168;
                        bool _1170 = (_1134 > 0.5f);
                        bool _1171 = (_1170) | (_1169);
                        bool _1172 = (_1134 >= 0.0f);
                        bool _1173 = (_1172) & (_1171);
                        if (!_1173) {
                          int _1175 = _1065 + 1;
                          bool _1176 = ((uint)_1175 < (uint)16);
                          if (_1176) {
                            _1065 = _1175;
                            continue;
                          } else {
                            uint _1179 = _1003 + 1u;
                            bool _1180 = ((uint)_1179 < (uint)_999);
                            if (_1180) {
                              _1003 = _1179;
                              __loop_jump_target = 1002;
                              break;
                            } else {
                              __defer_996_1186 = true;
                            }
                          }
                        } else {
                          bool _1182 = !(_1134 <= _664);
                          if (!_1182) {
                            float _1184 = max(9.999999717180685e-10f, _1134);
                            _1191 = _1184;
                          } else {
                            __defer_996_1186 = true;
                          }
                        }
                      } else {
                        int _1175 = _1065 + 1;
                        bool _1176 = ((uint)_1175 < (uint)16);
                        if (_1176) {
                          _1065 = _1175;
                          continue;
                        } else {
                          uint _1179 = _1003 + 1u;
                          bool _1180 = ((uint)_1179 < (uint)_999);
                          if (_1180) {
                            _1003 = _1179;
                            __loop_jump_target = 1002;
                            break;
                          } else {
                            __defer_996_1186 = true;
                          }
                        }
                      }
                      break;
                    }
                    if (__loop_jump_target == 1002) {
                      __loop_jump_target = -1;
                      continue;
                    }
                    if (__loop_jump_target != -1) {
                      break;
                    }
                  } else {
                    uint _1179 = _1003 + 1u;
                    bool _1180 = ((uint)_1179 < (uint)_999);
                    if (_1180) {
                      _1003 = _1179;
                      continue;
                    } else {
                      __defer_996_1186 = true;
                    }
                  }
                  break;
                }
                if (__loop_jump_target == 226) {
                  __loop_jump_target = -1;
                  continue;
                }
                if (__loop_jump_target != -1) {
                  break;
                }
              } else {
                __defer_996_1186 = true;
              }
              if (__defer_996_1186) {
                bool _1187 = ((uint)_998 < (uint)8);
                if (_1187) {
                  float _1189 = max(9.999999717180685e-10f, _997);
                  _1191 = _1189;
                } else {
                  _1191 = 0.0f;
                }
              }
              _1193 = _1191;
            } else {
              _1193 = 0.0f;
            }
            bool _1194 = (_1193 > 0.0f);
            if (_1194) {
              float _1196 = _662 - _291;
              bool _1197 = !(_1193 < _1196);
              bool _1198 = (_1193 <= 0.0f);
              bool _1199 = (_1197) | (_1198);
              if (!_1199) {
                float _1201 = min(999.0f, _1193);
                _1203 = _217;
                _1204 = _1201;
              } else {
                _1203 = _217;
                _1204 = 1023.0f;
              }
            } else {
              _1203 = _217;
              _1204 = 1023.0f;
            }
          } else {
            _1203 = _217;
            _1204 = 1023.0f;
          }
        }
        int _1205 = min(32767, _1203);
        float _1206 = min(1023.0f, _1204);
        float _1207 = _1206 * 64.06158447265625f;
        float _1208 = _1207 + 0.5f;
        uint _1209 = uint(_1208);
        int _1210 = min(65535, _1209);
        uint _1211 = _1205 << 16;
        int _1212 = _1210 | _1211;
        __3__38__0__1__g_manyLightsHitDataUAV[int2(_54, _56)] = int2(_1212, _214.y);
        float _1229 = (_projToPrevProj[0].x) * _116;
        float _1230 = mad((_projToPrevProj[0].y), _118, _1229);
        float _1231 = mad((_projToPrevProj[0].z), _82, _1230);
        float _1232 = _1231 + (_projToPrevProj[0].w);
        float _1233 = (_projToPrevProj[1].x) * _116;
        float _1234 = mad((_projToPrevProj[1].y), _118, _1233);
        float _1235 = mad((_projToPrevProj[1].z), _82, _1234);
        float _1236 = _1235 + (_projToPrevProj[1].w);
        float _1237 = (_projToPrevProj[3].x) * _116;
        float _1238 = mad((_projToPrevProj[3].y), _118, _1237);
        float _1239 = mad((_projToPrevProj[3].z), _82, _1238);
        float _1240 = _1239 + (_projToPrevProj[3].w);
        float _1241 = _1232 / _1240;
        float _1242 = _1236 / _1240;
        float _1243 = _1241 - _116;
        float _1244 = _1242 - _118;
        float _1245 = _1243 * 0.5f;
        float _1246 = _1244 * 0.5f;
        float _1247 = _1245 + _73;
        float _1248 = _74 - _1246;
        float4 _1251 = __3__36__0__0__g_manyLightsMomentsPrev.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1247, _1248), 0.0f);
        bool _1253 = (_1205 != 32767);
        bool _1254 = (_442 < 0.0f);
        bool _1255 = (_1254) & (_1253);
        int _1256 = (int)(uint)(_1253);
        bool _1257 = !(_1251.w == 0.0f);
        int _1258 = select(_1257, 2, 0);
        bool _1259 = (_1204 > 1000.0f);
        bool _1260 = (_443) & (_1259);
        int _1261 = select(_1260, 4, 0);
        int _1262 = select(_1255, 8, 0);
        int _1263 = _1261 | _1256;
        int _1264 = _1263 | _1262;
        int _1265 = _1264 | _1258;
        bool _1266 = (_1265 == 0);
        [branch]
        if (!_1266) {
          int _1268 = (uint)(_54) >> 4;
          int _1269 = _1268 & 134217727;
          int _1270 = (uint)(_56) >> 4;
          int _1271 = _1270 & 134217727;
          uint _1273; InterlockedOr(__3__38__0__1__g_tiledManyLightsMasksUAV[int2(_1269, _1271)], _1265, _1273);
        }
        break;
      }
    }
  }
}
