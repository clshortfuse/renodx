struct LightTreeNode {
  half3 _boundsMin;
  half _intensity;
  half3 _boundsMax;
  uint16_t _flags;
  uint16_t _child0;
  uint16_t _child1;
  half _radiusSqr;
  half _cosConeAngle;
  half4 _cone;
};

struct ManyLightsData {
  float4 _position;
  float4 _color;
  uint2 _up;
  uint2 _look;
};


Texture2D<float> __3__36__0__0__g_lightProfile : register(t13, space36);

Texture2D<uint4> __3__36__0__0__g_baseColor : register(t14, space36);

Texture2D<uint> __3__36__0__0__g_sceneNormal : register(t50, space36);

Texture2D<uint> __3__36__0__0__g_depthStencil : register(t31, space36);

Texture2D<float2> __3__36__0__0__g_iblBrdfLookup : register(t90, space36);

StructuredBuffer<LightTreeNode> __3__37__0__0__g_lightTreeNodesBuffer : register(t8, space37);

ByteAddressBuffer __3__37__0__0__g_structureCounterBuffer : register(t27, space37);

StructuredBuffer<ManyLightsData> __3__37__0__0__g_manyLightsDataBuffer : register(t9, space37);

RWTexture2D<uint2> __3__38__0__1__g_manyLightsHitDataUAV : register(u1, space38);

RWTexture2D<float4> __3__38__0__1__g_specularResultUAV : register(u8, space38);

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

cbuffer __3__1__0__0__RenderVoxelConstants : register(b0, space1) {
  float4 _lightingParams : packoffset(c000.x);
  float4 _tiledRadianceCacheParams : packoffset(c001.x);
};

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

[numthreads(16, 16, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _16[4];
  int _22 = (int)(SV_GroupID.x) & 3;
  int _23 = (uint)(_22) >> 1;
  int _24 = _23 << 1;
  int _25 = _22 - _24;
  int _26 = _25 << 4;
  int _27 = _23 << 4;
  int _28 = (uint)(SV_GroupID.x) >> 2;
  int _29 = (uint)(SV_GroupID.x) >> 4;
  int _30 = _28 & 3;
  _16[0] = ((float)((g_tileIndex[_29]).x));
  _16[1] = ((float)((g_tileIndex[_29]).y));
  _16[2] = ((float)((g_tileIndex[_29]).z));
  _16[3] = ((float)((g_tileIndex[_29]).w));
  int _41 = _16[_30];
  int _42 = (uint)(_41) >> 16;
  uint _43 = _41 << 5;
  int _44 = _43 & 2097120;
  int _45 = _42 << 5;
  uint _46 = _44 + SV_GroupThreadID.x;
  uint _47 = _46 + _26;
  uint _48 = _27 + SV_GroupThreadID.y;
  uint _49 = _48 + _45;
  uint _53 = __3__36__0__0__g_depthStencil.Load(int3(_47, _49, 0));
  int _55 = (uint)((uint)(_53.x)) >> 24;
  int _56 = _53.x & 16777215;
  float _57 = float((uint)_56);
  float _58 = _57 * 5.960465188081798e-08f;
  int _59 = _55 & 127;
  uint _61 = __3__36__0__0__g_sceneNormal.Load(int3(_47, _49, 0));
  int _63 = (uint)((uint)(_61.x)) >> 10;
  int _64 = (uint)((uint)(_61.x)) >> 20;
  int _65 = _61.x & 1023;
  int _66 = _63 & 1023;
  int _67 = _64 & 1023;
  float _68 = float((uint)_65);
  float _69 = float((uint)_66);
  float _70 = float((uint)_67);
  float _71 = _68 * 0.001956947147846222f;
  float _72 = _69 * 0.001956947147846222f;
  float _73 = _70 * 0.001956947147846222f;
  float _74 = _71 + -1.0f;
  float _75 = _72 + -1.0f;
  float _76 = _73 + -1.0f;
  float _77 = min(1.0f, _74);
  float _78 = min(1.0f, _75);
  float _79 = min(1.0f, _76);
  float _80 = dot(float3(_77, _78, _79), float3(_77, _78, _79));
  float _81 = rsqrt(_80);
  float _82 = _81 * _77;
  float _83 = _81 * _78;
  float _84 = _81 * _79;
  float _90 = max(1.0000000116860974e-07f, _58);
  float _91 = _nearFarProj.x / _90;
  int _92 = _55 & 24;
  bool _93 = ((uint)_92 < (uint)24);
  bool _94 = (_91 > 64.0f);
  bool _95 = (_93) | (_94);
  float _198;
  int _390;
  float _396;
  float _397;
  int _398;
  int _399;
  float _409;
  float _410;
  int _411;
  int _412;
  int _413;
  float _477;
  float _489;
  int _490;
  int _491;
  float _498;
  float _499;
  int _500;
  int _501;
  int _502;
  float _609;
  float _610;
  int _611;
  int _612;
  float _617;
  float _618;
  int _619;
  int _627;
  int _628;
  int _629;
  int _630;
  int _631;
  float _632;
  float _633;
  int _730;
  int _731;
  float _732;
  float _733;
  int _740;
  int _741;
  int _742;
  int _743;
  float _744;
  float _745;
  float _757;
  int _758;
  float _951;
  float _952;
  float _953;
  float _954;
  int _955;
  float _956;
  int _1005;
  float _1025;
  float _1026;
  float _1072;
  float _1073;
  float _1074;
  float _1075;
  float _1076;
  float _1080;
  float _1093;
  float _1094;
  float _1095;
  int _1147;
  int _1148;
  int _1149;
  int _1150;
  float _1151;
  float _1152;
  float _1153;
  float _1154;
  float _1155;
  float _1156;
  float _1157;
  float _1158;
  float _1159;
  float _1256;
  float _1257;
  float _1258;
  float _1312;
  float _1322;
  if (!_95) {
    float _99 = float((uint)_47);
    float _100 = float((uint)_49);
    float _101 = _99 + 0.5f;
    float _102 = _100 + 0.5f;
    float _105 = _101 * 2.0f;
    float _106 = _105 * _bufferSizeAndInvSize.z;
    float _107 = _106 + -1.0f;
    float _108 = _102 * 2.0f;
    float _109 = _108 * _bufferSizeAndInvSize.w;
    float _110 = 1.0f - _109;
    float _131 = (_invViewProjRelative[0].x) * _107;
    float _132 = mad((_invViewProjRelative[0].y), _110, _131);
    float _133 = mad((_invViewProjRelative[0].z), _90, _132);
    float _134 = _133 + (_invViewProjRelative[0].w);
    float _135 = (_invViewProjRelative[1].x) * _107;
    float _136 = mad((_invViewProjRelative[1].y), _110, _135);
    float _137 = mad((_invViewProjRelative[1].z), _90, _136);
    float _138 = _137 + (_invViewProjRelative[1].w);
    float _139 = (_invViewProjRelative[2].x) * _107;
    float _140 = mad((_invViewProjRelative[2].y), _110, _139);
    float _141 = mad((_invViewProjRelative[2].z), _90, _140);
    float _142 = _141 + (_invViewProjRelative[2].w);
    float _143 = (_invViewProjRelative[3].x) * _107;
    float _144 = mad((_invViewProjRelative[3].y), _110, _143);
    float _145 = mad((_invViewProjRelative[3].z), _90, _144);
    float _146 = _145 + (_invViewProjRelative[3].w);
    float _147 = _134 / _146;
    float _148 = _138 / _146;
    float _149 = _142 / _146;
    bool _152 = (_lightingParams.z > 0.0f);
    float _153 = _91 * 0.015625f;
    float _154 = saturate(_153);
    float _155 = _154 * 0.008999999612569809f;
    float _156 = _155 + 0.0010000000474974513f;
    float _157 = _154 * 0.09000000357627869f;
    float _158 = _157 + 0.009999999776482582f;
    float _159 = select(_152, _156, _158);
    float _162 = _exposure2.x * _159;
    float _163 = dot(float3(_147, _148, _149), float3(_147, _148, _149));
    float _164 = rsqrt(_163);
    float _165 = _164 * _147;
    float _166 = _164 * _148;
    float _167 = _164 * _149;
    uint4 _169 = __3__36__0__0__g_baseColor.Load(int3(_47, _49, 0));
    int _171 = _169.y & 255;
    float _172 = float((uint)_171);
    float _173 = _172 * 0.003921568859368563f;
    int4 _175 = asint(__3__37__0__0__g_structureCounterBuffer.Load4(4));
    int4 _177 = asint(__3__37__0__0__g_structureCounterBuffer.Load4(8));
    int _179 = WaveReadLaneFirst(_175.x);
    int _180 = _55 & 126;
    bool _181 = (_180 == 96);
    bool _182 = (_59 == 98);
    bool _183 = (_181) | (_182);
    bool __defer_96_196 = false;
    if (!_183) {
      bool _185 = ((uint)_59 > (uint)10);
      if (_185) {
        bool _187 = ((uint)_59 < (uint)20);
        bool _188 = (_59 == 107);
        bool _189 = (_187) | (_188);
        bool _190 = (_59 == 65);
        bool _191 = (_190) | (_189);
        bool _192 = (_59 == 24);
        bool _193 = (_192) | (_191);
        bool _194 = (_59 == 29);
        bool _195 = (_194) | (_193);
        if (_195) {
          __defer_96_196 = true;
        } else {
          _198 = _173;
        }
      } else {
        _198 = _173;
      }
    } else {
      __defer_96_196 = true;
    }
    if (__defer_96_196) {
      _198 = 0.0f;
    }
    float _199 = -0.0f - _165;
    float _200 = -0.0f - _166;
    float _201 = -0.0f - _167;
    float _202 = dot(float3(_82, _83, _84), float3(_199, _200, _201));
    float _203 = _198 * 0.03999999910593033f;
    float _204 = 0.03999999910593033f - _203;
    float _205 = max(0.0010000000474974513f, _204);
    float _206 = dot(float3(_205, _205, _205), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _207 = abs(_202);
    float _208 = _207 * _207;
    float _209 = _208 * _207;
    float _210 = mad(-1.285140037536621f, _207, 0.9904400110244751f);
    float _211 = mad(-0.7559069991111755f, _207, 1.296779990196228f);
    float _212 = dot(float2(_210, _211), float2(1.0f, 0.008100000210106373f));
    float _213 = mad(2.923379898071289f, _207, 1.0f);
    float _214 = mad(59.418800354003906f, _209, _213);
    float _215 = mad(-27.03019905090332f, _207, 20.322500228881836f);
    float _216 = mad(222.5919952392578f, _209, _215);
    float _217 = mad(626.1300048828125f, _207, 121.56300354003906f);
    float _218 = mad(316.62701416015625f, _209, _217);
    float _219 = dot(float3(_214, _216, _218), float3(1.0f, 0.008100000210106373f, 5.31441003204236e-07f));
    float _220 = 1.0f / _219;
    float _221 = _220 * _212;
    float _222 = mad(3.3270699977874756f, _207, 0.03654630109667778f);
    float _223 = mad(-9.04755973815918f, _207, 9.063199996948242f);
    float _224 = dot(float2(_222, _223), float2(1.0f, 0.008100000210106373f));
    float _225 = mad(3.5968499183654785f, _208, 1.0f);
    float _226 = mad(-1.3677200078964233f, _209, _225);
    float _227 = mad(-16.317399978637695f, _208, 9.044010162353516f);
    float _228 = mad(9.229490280151367f, _209, _227);
    float _229 = mad(19.78860092163086f, _208, 5.565889835357666f);
    float _230 = mad(-20.212299346923828f, _209, _229);
    float _231 = dot(float3(_226, _228, _230), float3(1.0f, 0.008100000210106373f, 5.31441003204236e-07f));
    float _232 = 1.0f / _231;
    float _233 = _232 * _224;
    float _234 = _205 * 50.0f;
    float _235 = saturate(_234);
    float _236 = _221 * _235;
    float _237 = max(0.0f, _236);
    float _238 = max(0.0f, _233);
    float _239 = mad(_205, _238, _237);
    float _240 = dot(float3(_239, _239, _239), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _243 = float((int)(_47));
    float _244 = float((int)(_49));
    float _247 = _bufferSizeAndInvSize.x * _244;
    float _248 = _247 + _243;
    uint _249 = uint(_248);
    uint _250 = (uint)(_frameNumber.x) + -1640531527u;
    uint _251 = (uint)(_frameNumber.x) << 4;
    uint _252 = _251 + -1556008596u;
    int _253 = _252 ^ _250;
    int _254 = (uint)((uint)(_frameNumber.x)) >> 5;
    int _255 = _254 + -939442524;
    int _256 = _253 ^ _255;
    uint _257 = _249 + _256;
    uint _258 = _257 + -1640531527u;
    uint _259 = _257 << 4;
    uint _260 = _259 + -1383041155u;
    int _261 = _260 ^ _258;
    int _262 = (uint)(_257) >> 5;
    uint _263 = _262 + 2123724318u;
    int _264 = _261 ^ _263;
    uint _265 = _264 + (uint)(_frameNumber.x);
    uint _266 = _265 + 1013904242u;
    uint _267 = _265 << 4;
    uint _268 = _267 + -1556008596u;
    int _269 = _268 ^ _266;
    int _270 = (uint)(_265) >> 5;
    int _271 = _270 + -939442524;
    int _272 = _269 ^ _271;
    uint _273 = _272 + _257;
    uint _274 = _273 + 1013904242u;
    uint _275 = _273 << 4;
    uint _276 = _275 + -1383041155u;
    int _277 = _276 ^ _274;
    int _278 = (uint)(_273) >> 5;
    uint _279 = _278 + 2123724318u;
    int _280 = _277 ^ _279;
    uint _281 = _280 + _265;
    uint _282 = _281 + -626627285u;
    uint _283 = _281 << 4;
    uint _284 = _283 + -1556008596u;
    int _285 = _284 ^ _282;
    int _286 = (uint)(_281) >> 5;
    int _287 = _286 + -939442524;
    int _288 = _285 ^ _287;
    uint _289 = _288 + _273;
    uint _290 = _289 + -626627285u;
    uint _291 = _289 << 4;
    uint _292 = _291 + -1383041155u;
    int _293 = _292 ^ _290;
    int _294 = (uint)(_289) >> 5;
    uint _295 = _294 + 2123724318u;
    int _296 = _293 ^ _295;
    uint _297 = _296 + _281;
    uint _298 = _297 + 2027808484u;
    uint _299 = _297 << 4;
    uint _300 = _299 + -1556008596u;
    int _301 = _300 ^ _298;
    int _302 = (uint)(_297) >> 5;
    int _303 = _302 + -939442524;
    int _304 = _301 ^ _303;
    uint _305 = _304 + _289;
    uint _306 = _305 + 2027808484u;
    uint _307 = _305 << 4;
    uint _308 = _307 + -1383041155u;
    int _309 = _308 ^ _306;
    int _310 = (uint)(_305) >> 5;
    uint _311 = _310 + 2123724318u;
    int _312 = _309 ^ _311;
    uint _313 = _312 + _297;
    uint _314 = _313 + 387276957u;
    uint _315 = _313 << 4;
    uint _316 = _315 + -1556008596u;
    int _317 = _316 ^ _314;
    int _318 = (uint)(_313) >> 5;
    int _319 = _318 + -939442524;
    int _320 = _317 ^ _319;
    uint _321 = _320 + _305;
    uint _322 = _321 + 387276957u;
    uint _323 = _321 << 4;
    uint _324 = _323 + -1383041155u;
    int _325 = _324 ^ _322;
    int _326 = (uint)(_321) >> 5;
    uint _327 = _326 + 2123724318u;
    int _328 = _325 ^ _327;
    uint _329 = _328 + _313;
    uint _330 = _329 + -1253254570u;
    uint _331 = _329 << 4;
    uint _332 = _331 + -1556008596u;
    int _333 = _332 ^ _330;
    int _334 = (uint)(_329) >> 5;
    int _335 = _334 + -939442524;
    int _336 = _333 ^ _335;
    uint _337 = _336 + _321;
    uint _338 = _337 + -1253254570u;
    uint _339 = _337 << 4;
    uint _340 = _339 + -1383041155u;
    int _341 = _340 ^ _338;
    int _342 = (uint)(_337) >> 5;
    uint _343 = _342 + 2123724318u;
    int _344 = _341 ^ _343;
    uint _345 = _344 + _329;
    uint _346 = _345 + 1401181199u;
    uint _347 = _345 << 4;
    uint _348 = _347 + -1556008596u;
    int _349 = _348 ^ _346;
    int _350 = (uint)(_345) >> 5;
    int _351 = _350 + -939442524;
    int _352 = _349 ^ _351;
    uint _353 = _352 + _337;
    uint _354 = _353 + 1401181199u;
    uint _355 = _353 << 4;
    uint _356 = _355 + -1383041155u;
    int _357 = _356 ^ _354;
    int _358 = (uint)(_353) >> 5;
    uint _359 = _358 + 2123724318u;
    int _360 = _357 ^ _359;
    uint _361 = _360 + _345;
    uint _362 = _361 + -239350328u;
    uint _363 = _361 << 4;
    uint _364 = _363 + -1556008596u;
    int _365 = _364 ^ _362;
    int _366 = (uint)(_361) >> 5;
    int _367 = _366 + -939442524;
    int _368 = _365 ^ _367;
    uint _369 = _368 + _353;
    uint _370 = _369 + -239350328u;
    uint _371 = _369 << 4;
    uint _372 = _371 + -1383041155u;
    int _373 = _372 ^ _370;
    int _374 = (uint)(_369) >> 5;
    uint _375 = _374 + 2123724318u;
    int _376 = _373 ^ _375;
    uint _377 = _376 + _361;
    int _378 = _369 & 16777215;
    bool _379 = (_378 == 0);
    if (_379) {
      uint _381 = _377 + -1879881855u;
      uint _382 = _377 << 4;
      uint _383 = _382 + -1556008596u;
      int _384 = _383 ^ _381;
      int _385 = (uint)(_377) >> 5;
      int _386 = _385 + -939442524;
      int _387 = _384 ^ _386;
      uint _388 = _387 + _369;
      _390 = _388;
    } else {
      _390 = _369;
    }
    bool _391 = (_177.x != 0);
    bool _392 = (_177.x == 0);
    if (!_392) {
      _409 = 0.0f;
      _410 = 0.0f;
      _411 = 32767;
      _412 = _390;
      _413 = 0;
      while(true) {
        float _416 = __3__37__0__0__g_manyLightsDataBuffer[_413]._position.x;
        float _417 = __3__37__0__0__g_manyLightsDataBuffer[_413]._position.y;
        float _418 = __3__37__0__0__g_manyLightsDataBuffer[_413]._position.z;
        float _420 = __3__37__0__0__g_manyLightsDataBuffer[_413]._color.x;
        float _421 = __3__37__0__0__g_manyLightsDataBuffer[_413]._color.y;
        float _422 = __3__37__0__0__g_manyLightsDataBuffer[_413]._color.z;
        float _423 = _416 - _147;
        float _424 = _417 - _148;
        float _425 = _418 - _149;
        float _426 = _423 * _423;
        float _427 = _424 * _424;
        float _428 = _426 + _427;
        float _429 = _425 * _425;
        float _430 = _428 + _429;
        float _431 = sqrt(_430);
        float _432 = _423 / _431;
        float _433 = _424 / _431;
        float _434 = _425 / _431;
        float _435 = _432 - _165;
        float _436 = _433 - _166;
        float _437 = _434 - _167;
        float _438 = dot(float3(_435, _436, _437), float3(_435, _436, _437));
        float _439 = rsqrt(_438);
        float _440 = _439 * _435;
        float _441 = _439 * _436;
        float _442 = _439 * _437;
        float _443 = dot(float3(_82, _83, _84), float3(_432, _433, _434));
        float _444 = dot(float3(_420, _421, _422), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
        float _445 = min(1000.0f, _444);
        bool _446 = (_445 < _162);
        if (!_446) {
          float _448 = saturate(_443);
          float _449 = dot(float3(_199, _200, _201), float3(_440, _441, _442));
          float _450 = dot(float3(_82, _83, _84), float3(_440, _441, _442));
          float _451 = 1.0f - _449;
          float _452 = saturate(_451);
          float _453 = _452 * _452;
          float _454 = _453 * _453;
          float _455 = _454 * _452;
          float _456 = _455 * _206;
          float _457 = _455 + _206;
          float _458 = _457 - _456;
          float _459 = _202 * 0.9099999666213989f;
          float _460 = _459 + 0.09000000357627869f;
          float _461 = _443 * _460;
          float _462 = _443 * 0.9099999666213989f;
          float _463 = _462 + 0.09000000357627869f;
          float _464 = _463 * _202;
          float _465 = _464 + _461;
          float _466 = 0.5f / _465;
          float _467 = _450 * _450;
          float _468 = _467 * 0.9099999666213989f;
          float _469 = 1.0f - _468;
          float _470 = _469 * _469;
          float _471 = 0.09000000357627869f / _470;
          float _472 = _448 * _445;
          float _473 = _472 * _466;
          float _474 = _473 * _471;
          float _475 = _474 * _458;
          _477 = _475;
        } else {
          _477 = 0.0f;
        }
        float _478 = _477 + _409;
        bool _479 = (_477 > 0.0f);
        if (_479) {
          uint _481 = _412 * 48271;
          int _482 = _481 & 16777215;
          float _483 = float((uint)_482);
          float _484 = _483 * 5.960464477539063e-08f;
          float _485 = _484 * _478;
          bool _486 = (_485 < _477);
          if (_486) {
            _489 = _477;
            _490 = _413;
            _491 = _481;
          } else {
            _489 = _410;
            _490 = _411;
            _491 = _481;
          }
        } else {
          _489 = _410;
          _490 = _411;
          _491 = _412;
        }
        uint _492 = _413 + 1u;
        bool _493 = (_492 == _177.x);
        if (!_493) {
          _409 = _478;
          _410 = _489;
          _411 = _490;
          _412 = _491;
          _413 = _492;
          continue;
        }
        _396 = _478;
        _397 = _489;
        _398 = _490;
        _399 = _491;
        break;
      }
    } else {
      _396 = 0.0f;
      _397 = 0.0f;
      _398 = 32767;
      _399 = _390;
    }
    bool _400 = ((uint)_179 < (uint)64);
    bool _401 = (_391) | (_400);
    uint _402 = firstbithigh((uint)_179);
    bool _403 = (_402 == -1);
    uint _404 = 0u - _402;
    int _405 = _404 & 31;
    uint _406 = 1u << _405;
    int _407 = select(_403, 1, _406);
    if (_401) {
      bool _495 = ((uint)_177.x < (uint)_179);
      if (_495) {
        _498 = _396;
        _499 = _397;
        _500 = _398;
        _501 = _399;
        _502 = _177.x;
        while(true) {
          uint _503 = _179 + -1u;
          uint _504 = _503 + _407;
          uint _505 = _504 - _502;
          half _508 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._boundsMin.x;
          half _509 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._boundsMin.y;
          half _510 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._boundsMin.z;
          half _512 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._intensity;
          half _514 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._boundsMax.x;
          int16_t _516 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._child0;
          half _518 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._cosConeAngle;
          half _520 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._cone.x;
          half _521 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._cone.y;
          half _522 = __3__37__0__0__g_lightTreeNodesBuffer[_505]._cone.z;
          float _523 = float(_508);
          float _524 = float(_509);
          float _525 = float(_510);
          float _526 = _523 - _147;
          float _527 = _524 - _148;
          float _528 = _525 - _149;
          float _529 = _526 * _526;
          float _530 = _527 * _527;
          float _531 = _529 + _530;
          float _532 = _528 * _528;
          float _533 = _531 + _532;
          float _534 = sqrt(_533);
          float _535 = _526 / _534;
          float _536 = _527 / _534;
          float _537 = _528 / _534;
          float _538 = _535 - _165;
          float _539 = _536 - _166;
          float _540 = _537 - _167;
          float _541 = dot(float3(_538, _539, _540), float3(_538, _539, _540));
          float _542 = rsqrt(_541);
          float _543 = _542 * _538;
          float _544 = _542 * _539;
          float _545 = _542 * _540;
          float _546 = dot(float3(_82, _83, _84), float3(_535, _536, _537));
          float _547 = float(_512);
          half _548 = _514 - _508;
          half _549 = _548 * 0.5h;
          float _550 = float(_549);
          float _551 = _534 * _534;
          float _552 = _550 * _550;
          float _553 = max(_552, _551);
          bool _554 = (_550 > 99999.0f);
          float _555 = 1.0f / _553;
          float _556 = select(_554, 1.0f, _555);
          float _557 = saturate(_556);
          float _558 = _557 * _547;
          float _559 = float(_520);
          float _560 = float(_521);
          float _561 = float(_522);
          float _562 = dot(float3(_559, _560, _561), float3(_535, _536, _537));
          half _563 = -0.0h - _518;
          float _564 = float(_563);
          bool _565 = (_562 <= _564);
          float _566 = select(_565, _558, 0.0f);
          bool _567 = (_566 < _162);
          if (!_567) {
            float _569 = saturate(_546);
            float _570 = dot(float3(_199, _200, _201), float3(_543, _544, _545));
            float _571 = dot(float3(_82, _83, _84), float3(_543, _544, _545));
            float _572 = 1.0f - _570;
            float _573 = saturate(_572);
            float _574 = _573 * _573;
            float _575 = _574 * _574;
            float _576 = _575 * _573;
            float _577 = _576 * _206;
            float _578 = _576 + _206;
            float _579 = _578 - _577;
            float _580 = _202 * 0.9099999666213989f;
            float _581 = _580 + 0.09000000357627869f;
            float _582 = _546 * _581;
            float _583 = _546 * 0.9099999666213989f;
            float _584 = _583 + 0.09000000357627869f;
            float _585 = _584 * _202;
            float _586 = _585 + _582;
            float _587 = 0.5f / _586;
            float _588 = _571 * _571;
            float _589 = _588 * 0.9099999666213989f;
            float _590 = 1.0f - _589;
            float _591 = _590 * _590;
            float _592 = 0.09000000357627869f / _591;
            float _593 = _569 * _566;
            float _594 = _593 * _587;
            float _595 = _594 * _592;
            float _596 = _595 * _579;
            float _597 = _596 + _498;
            bool _598 = (_596 > 0.0f);
            if (_598) {
              uint _600 = _501 * 48271;
              int _601 = _600 & 16777215;
              float _602 = float((uint)_601);
              float _603 = _602 * 5.960464477539063e-08f;
              float _604 = _603 * _597;
              bool _605 = (_604 < _596);
              if (_605) {
                int _607 = (int)(min16uint)(_516);
                _609 = _597;
                _610 = _596;
                _611 = _607;
                _612 = _600;
              } else {
                _609 = _597;
                _610 = _499;
                _611 = _500;
                _612 = _600;
              }
            } else {
              _609 = _597;
              _610 = _499;
              _611 = _500;
              _612 = _501;
            }
          } else {
            _609 = _498;
            _610 = _499;
            _611 = _500;
            _612 = _501;
          }
          uint _613 = _502 + 1u;
          bool _614 = (_613 == _179);
          if (!_614) {
            _498 = _609;
            _499 = _610;
            _500 = _611;
            _501 = _612;
            _502 = _613;
            continue;
          }
          _617 = _609;
          _618 = _610;
          _619 = _611;
          break;
        }
      } else {
        _617 = _396;
        _618 = _397;
        _619 = _398;
      }
      float _620 = max(9.999999974752427e-07f, _617);
      float _621 = _618 / _620;
      _757 = _621;
      _758 = _619;
    } else {
      half _623 = half(_147);
      half _624 = half(_148);
      half _625 = half(_149);
      _627 = 1;
      _628 = 0;
      _629 = 0;
      _630 = _399;
      _631 = 32767;
      _632 = 1.0f;
      _633 = 0.0f;
      while(true) {
        uint _634 = _628 + _627;
        half _637 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._boundsMin.x;
        half _638 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._boundsMin.y;
        half _639 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._boundsMin.z;
        half _641 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._intensity;
        int16_t _644 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._child0;
        half _646 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._radiusSqr;
        half _648 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._cosConeAngle;
        half _650 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._cone.x;
        half _651 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._cone.y;
        half _652 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._cone.z;
        bool _653 = ((uint)_634 >= (uint)_407);
        bool _654 = (_644 != -1);
        bool _655 = (_653) & (_654);
        bool __defer_626_729 = false;
        if (_655) {
          float _657 = float(_637);
          float _658 = float(_638);
          float _659 = float(_639);
          float _660 = _657 - _147;
          float _661 = _658 - _148;
          float _662 = _659 - _149;
          float _663 = dot(float3(_660, _661, _662), float3(_660, _661, _662));
          half _664 = _646 * 4.0h;
          float _665 = float(_664);
          bool _666 = !(_663 >= _665);
          if (_666) {
            float _668 = rsqrt(_663);
            float _669 = _668 * _660;
            float _670 = _668 * _661;
            float _671 = _668 * _662;
            float _672 = dot(float3(_82, _83, _84), float3(_669, _670, _671));
            float _673 = _669 - _165;
            float _674 = _670 - _166;
            float _675 = _671 - _167;
            float _676 = dot(float3(_673, _674, _675), float3(_673, _674, _675));
            float _677 = rsqrt(_676);
            float _678 = _677 * _673;
            float _679 = _677 * _674;
            float _680 = _677 * _675;
            float _681 = dot(float3(_82, _83, _84), float3(_678, _679, _680));
            float _682 = float(_641);
            float _683 = 1.0f / _663;
            float _684 = saturate(_683);
            float _685 = saturate(_672);
            float _686 = _681 * _681;
            float _687 = _686 * 0.9099999666213989f;
            float _688 = 1.0f - _687;
            float _689 = _688 * _688;
            float _690 = 0.09000000357627869f / _689;
            float _691 = _682 * _240;
            float _692 = _691 * _684;
            float _693 = _692 * _685;
            float _694 = _693 * _690;
            float _695 = float(_650);
            float _696 = float(_651);
            float _697 = float(_652);
            float _698 = dot(float3(_695, _696, _697), float3(_669, _670, _671));
            half _699 = -0.0h - _648;
            float _700 = float(_699);
            bool _701 = (_698 <= _700);
            float _702 = select(_701, _694, 0.0f);
            uint _703 = _630 * 48271;
            int _704 = _703 & 16777215;
            float _705 = float((uint)_704);
            float _706 = _705 * 5.960464477539063e-08f;
            float _707 = _702 + _633;
            float _708 = _706 * _707;
            bool _709 = (_708 < _702);
            if (_709) {
              _730 = _703;
              _731 = _634;
              _732 = _702;
              _733 = _707;
            } else {
              _730 = _703;
              _731 = _631;
              _732 = _632;
              _733 = _707;
            }
          } else {
            _730 = _630;
            _731 = _631;
            _732 = _632;
            _733 = _633;
          }
          __defer_626_729 = true;
        } else {
          half _712 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._boundsMax.z;
          half _713 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._boundsMax.y;
          half _714 = __3__37__0__0__g_lightTreeNodesBuffer[_634]._boundsMax.x;
          half _715 = max(_623, _637);
          half _716 = max(_624, _638);
          half _717 = max(_625, _639);
          half _718 = min(_715, _714);
          half _719 = min(_716, _713);
          half _720 = min(_717, _712);
          half _721 = _718 - _623;
          half _722 = _719 - _624;
          half _723 = _720 - _625;
          half _724 = dot(half3(_721, _722, _723), half3(_721, _722, _723));
          bool _725 = (_724 < _646);
          if (_725) {
            uint _727 = _627 << 1;
            uint _728 = _628 << 1;
            _740 = _727;
            _741 = _728;
            _742 = _630;
            _743 = _631;
            _744 = _632;
            _745 = _633;
          } else {
            _730 = _630;
            _731 = _631;
            _732 = _632;
            _733 = _633;
            __defer_626_729 = true;
          }
        }
        if (__defer_626_729) {
          uint _734 = _628 + 1u;
          int _735 = firstbitlow(_734);
          int _736 = _735 & 31;
          int _737 = (uint)(_627) >> _736;
          int _738 = (uint)(_734) >> _736;
          _740 = _737;
          _741 = _738;
          _742 = _730;
          _743 = _731;
          _744 = _732;
          _745 = _733;
        }
        bool _746 = ((uint)_740 > (uint)1);
        if (_746) {
          int _748 = _629 + 1;
          bool _749 = ((uint)_629 < (uint)65536);
          if (_749) {
            _627 = _740;
            _628 = _741;
            _629 = _748;
            _630 = _742;
            _631 = _743;
            _632 = _744;
            _633 = _745;
            continue;
          }
        }
        float _751 = max(9.999999974752427e-07f, _745);
        float _752 = _744 / _751;
        int16_t _754 = __3__37__0__0__g_lightTreeNodesBuffer[_743]._child0;
        int _755 = (int)(min16uint)(_754);
        _757 = _752;
        _758 = _755;
        break;
      }
    }
    int _759 = min(32767, _758);
    bool _760 = (_759 != 32767);
    bool _761 = ((uint)_759 < (uint)_175.x);
    bool _762 = (_760) & (_761);
    if (_762) {
      float _766 = __3__37__0__0__g_manyLightsDataBuffer[_759]._position.x;
      float _767 = __3__37__0__0__g_manyLightsDataBuffer[_759]._position.y;
      float _768 = __3__37__0__0__g_manyLightsDataBuffer[_759]._position.z;
      float _770 = __3__37__0__0__g_manyLightsDataBuffer[_759]._color.x;
      float _771 = __3__37__0__0__g_manyLightsDataBuffer[_759]._color.y;
      float _772 = __3__37__0__0__g_manyLightsDataBuffer[_759]._color.z;
      float _773 = __3__37__0__0__g_manyLightsDataBuffer[_759]._color.w;
      int _775 = __3__37__0__0__g_manyLightsDataBuffer[_759]._up.x;
      int _776 = __3__37__0__0__g_manyLightsDataBuffer[_759]._up.y;
      int _778 = __3__37__0__0__g_manyLightsDataBuffer[_759]._look.x;
      int _779 = __3__37__0__0__g_manyLightsDataBuffer[_759]._look.y;
      float _780 = _766 - _147;
      float _781 = _767 - _148;
      float _782 = _768 - _149;
      float _783 = _780 * _780;
      float _784 = _781 * _781;
      float _785 = _783 + _784;
      float _786 = _782 * _782;
      float _787 = _785 + _786;
      float _788 = sqrt(_787);
      float _789 = 1.0f / _788;
      float _790 = _789 * _780;
      float _791 = _789 * _781;
      float _792 = _789 * _782;
      float _793 = _91 * 0.0010000000474974513f;
      float _794 = saturate(_793);
      float _795 = _794 * 2.25f;
      float _796 = _795 + 0.25f;
      uint _797 = _frameNumber.x * 71;
      int _798 = _797 & 31;
      float _799 = float((uint)_798);
      float _800 = _799 * 32.665000915527344f;
      float _801 = _799 * 11.8149995803833f;
      float _802 = _800 + _99;
      float _803 = _801 + _100;
      float _804 = dot(float2(_802, _803), float2(0.0671105608344078f, 0.005837149918079376f));
      float _805 = frac(_804);
      float _806 = _805 * 52.98291778564453f;
      float _807 = frac(_806);
      float _808 = _91 * 0.009999999776482582f;
      float _809 = _808 + 4.0f;
      float _810 = min(8.0f, _809);
      float _811 = _810 + _807;
      float _820 = (_viewRelative[2].x) * _147;
      float _821 = mad((_viewRelative[2].y), _148, _820);
      float _822 = mad((_viewRelative[2].z), _149, _821);
      float _823 = _822 + (_viewRelative[2].w);
      float _824 = (_viewRelative[2].x) * _790;
      float _825 = mad((_viewRelative[2].y), _791, _824);
      float _826 = mad((_viewRelative[2].z), _792, _825);
      float _827 = _826 * _796;
      float _828 = _827 + _823;
      bool _831 = (_828 < _nearFarProj.x);
      float _832 = _nearFarProj.x - _823;
      float _833 = _832 / _826;
      float _834 = select(_831, _833, _796);
      float _855 = (_viewProjRelative[0].x) * _147;
      float _856 = mad((_viewProjRelative[0].y), _148, _855);
      float _857 = mad((_viewProjRelative[0].z), _149, _856);
      float _858 = _857 + (_viewProjRelative[0].w);
      float _859 = (_viewProjRelative[1].x) * _147;
      float _860 = mad((_viewProjRelative[1].y), _148, _859);
      float _861 = mad((_viewProjRelative[1].z), _149, _860);
      float _862 = _861 + (_viewProjRelative[1].w);
      float _863 = (_viewProjRelative[2].x) * _147;
      float _864 = mad((_viewProjRelative[2].y), _148, _863);
      float _865 = mad((_viewProjRelative[2].z), _149, _864);
      float _866 = _865 + (_viewProjRelative[2].w);
      float _867 = (_viewProjRelative[3].x) * _147;
      float _868 = mad((_viewProjRelative[3].y), _148, _867);
      float _869 = mad((_viewProjRelative[3].z), _149, _868);
      float _870 = _869 + (_viewProjRelative[3].w);
      float _871 = _834 * _790;
      float _872 = _834 * _791;
      float _873 = _834 * _792;
      float _874 = _871 + _147;
      float _875 = _872 + _148;
      float _876 = _873 + _149;
      float _877 = (_viewProjRelative[0].x) * _874;
      float _878 = mad((_viewProjRelative[0].y), _875, _877);
      float _879 = mad((_viewProjRelative[0].z), _876, _878);
      float _880 = _879 + (_viewProjRelative[0].w);
      float _881 = (_viewProjRelative[1].x) * _874;
      float _882 = mad((_viewProjRelative[1].y), _875, _881);
      float _883 = mad((_viewProjRelative[1].z), _876, _882);
      float _884 = _883 + (_viewProjRelative[1].w);
      float _885 = (_viewProjRelative[2].x) * _874;
      float _886 = mad((_viewProjRelative[2].y), _875, _885);
      float _887 = mad((_viewProjRelative[2].z), _876, _886);
      float _888 = _887 + (_viewProjRelative[2].w);
      float _889 = (_viewProjRelative[3].x) * _874;
      float _890 = mad((_viewProjRelative[3].y), _875, _889);
      float _891 = mad((_viewProjRelative[3].z), _876, _890);
      float _892 = _891 + (_viewProjRelative[3].w);
      float _893 = _858 / _870;
      float _894 = _862 / _870;
      float _895 = _866 / _870;
      float _896 = _880 / _892;
      float _897 = _884 / _892;
      float _898 = _888 / _892;
      float _899 = _896 - _893;
      float _900 = _897 - _894;
      float _901 = _898 - _895;
      float _902 = abs(_899);
      float _903 = abs(_900);
      float _904 = _bufferSizeAndInvSize.x * 0.5f;
      float _905 = _904 * _902;
      float _906 = _bufferSizeAndInvSize.y * 0.5f;
      float _907 = _906 * _903;
      float _908 = max(_905, _907);
      float _909 = _908 * 0.0625f;
      float _910 = min(1.0f, _909);
      float _911 = 1.0f / _910;
      float _912 = max(0.0625f, _911);
      float _913 = _912 * _901;
      float _914 = _893 * 0.5f;
      float _915 = _894 * 0.5f;
      float _916 = _914 + 0.5f;
      float _917 = 0.5f - _915;
      float _921 = mad((_proj[2].z), _91, 0.0f);
      float _922 = mad((_proj[3].z), _91, 0.0f);
      float _923 = _921 + _866;
      float _924 = _922 + _870;
      float _925 = _923 / _924;
      float _926 = _895 - _925;
      float _927 = abs(_913);
      float _928 = max(_927, _926);
      float _929 = _928 * 0.0625f;
      float _930 = _899 * 0.03125f;
      float _931 = _930 * _912;
      float _932 = _900 * -0.03125f;
      float _933 = _932 * _912;
      float _934 = _913 * 0.0625f;
      float _935 = abs(_931);
      float _936 = abs(_933);
      float _937 = _935 * _bufferSizeAndInvSize.x;
      float _938 = _936 * _bufferSizeAndInvSize.y;
      float _939 = max(_937, _938);
      float _940 = 1.0f / _939;
      float _941 = max(_811, _940);
      float _942 = _941 * _931;
      float _943 = _941 * _933;
      float _944 = _941 * _934;
      float _945 = _916 + _942;
      float _946 = _917 + _943;
      float _947 = _944 + _895;
      float _948 = _834 * 0.0625f;
      float _949 = 0.5f / _bufferSizeAndInvSize.x;
      _951 = _945;
      _952 = _946;
      _953 = _947;
      _954 = _811;
      _955 = 0;
      _956 = 0.0f;
      while(true) {
        float _957 = 1.0f - _949;
        float _958 = max(_951, _949);
        float _959 = min(_958, _957);
        float _960 = _959 * _bufferSizeAndInvSize.x;
        float _961 = _952 * _bufferSizeAndInvSize.y;
        int _962 = int(_960);
        int _963 = int(_961);
        uint _965 = __3__36__0__0__g_depthStencil.Load(int3(_962, _963, 0));
        int _967 = (uint)((uint)(_965.x)) >> 24;
        int _968 = _965.x & 16777215;
        float _969 = float((uint)_968);
        float _970 = _969 * 5.960465188081798e-08f;
        int _971 = _967 & 127;
        float _974 = max(1.0000000116860974e-07f, _970);
        float _975 = _nearFarProj.x / _974;
        float _976 = _953 - _970;
        float _977 = max(1.0000000116860974e-07f, _953);
        float _978 = _nearFarProj.x / _977;
        float _979 = _975 - _978;
        int _980 = _971 + -19;
        bool _981 = ((uint)_980 < (uint)2);
        bool _982 = (_971 == 12);
        bool _983 = (_982) | (_981);
        bool _984 = (_971 == 107);
        bool _985 = (_984) | (_983);
        if (_985) {
          bool _987 = (_979 < 0.0f);
          bool _988 = (_979 > -0.05000000074505806f);
          bool _989 = (_987) & (_988);
          int _990 = (int)(uint)(_989);
          _1005 = _990;
        } else {
          int _992 = _971 + -53;
          bool _993 = ((uint)_992 < (uint)14);
          if (_993) {
            bool _995 = (_979 < 0.0f);
            bool _996 = (_979 > -0.5f);
            bool _997 = (_995) & (_996);
            int _998 = (int)(uint)(_997);
            _1005 = _998;
          } else {
            float _1000 = _976 + _929;
            float _1001 = abs(_1000);
            bool _1002 = (_1001 < _929);
            int _1003 = (int)(uint)(_1002);
            _1005 = _1003;
          }
        }
        bool _1006 = (_1005 == 0);
        if (!_1006) {
          bool _1008 = ((uint)_971 > (uint)11);
          bool __defer_1007_1023 = false;
          if (_1008) {
            bool _1010 = ((uint)_971 < (uint)16);
            bool _1011 = (_971 == 17);
            bool _1012 = (_1010) | (_1011);
            if (!_1012) {
              bool _1014 = (_971 == 16);
              if (!_1014) {
                bool _1018 = (_984) | (_981);
                bool _1019 = (_971 == 18);
                bool _1020 = (_1019) | (_1018);
                if (!_1020) {
                  bool _1022 = (_971 == 66);
                  if (!_1022) {
                    __defer_1007_1023 = true;
                  } else {
                    _1025 = 0.10000000149011612f;
                    _1026 = 1000.0f;
                  }
                } else {
                  _1025 = 0.4000000059604645f;
                  _1026 = 10.0f;
                }
              } else {
                _1025 = 0.10000000149011612f;
                _1026 = 10.0f;
              }
            } else {
              _1025 = 0.30000001192092896f;
              _1026 = 10.0f;
            }
          } else {
            bool _1016 = (_971 == 11);
            if (!_1016) {
              __defer_1007_1023 = true;
            } else {
              _1025 = 0.10000000149011612f;
              _1026 = 10.0f;
            }
          }
          if (__defer_1007_1023) {
            _1025 = 0.0f;
            _1026 = 1.0f;
          }
          float _1027 = _948 * _1026;
          float _1028 = _975 * 0.20000000298023224f;
          float _1029 = _1028 + 1.0f;
          float _1030 = _1027 / _1029;
          float _1031 = max(1.0f, _1030);
          float _1032 = log2(_1025);
          float _1033 = _1032 * _1031;
          float _1034 = exp2(_1033);
          float _1035 = 1.0f - _1034;
          float _1036 = saturate(_1035);
          float _1040 = _bufferSizeAndInvSize.x * _951;
          float _1041 = _bufferSizeAndInvSize.y * _952;
          float _1044 = float((uint)(uint)(_frameNumber.x));
          float _1045 = _1044 * 32.665000915527344f;
          float _1046 = _1044 * 11.8149995803833f;
          float _1047 = _1045 + _1040;
          float _1048 = _1046 + _1041;
          float _1049 = dot(float2(_1047, _1048), float2(0.0671105608344078f, 0.005837149918079376f));
          float _1050 = frac(_1049);
          float _1051 = _1050 * 52.98291778564453f;
          float _1052 = frac(_1051);
          bool _1053 = !(_1036 >= _1052);
          [branch]
          if (!_1053) {
            bool _1055 = (_955 == 0);
            if (!_1055) {
              float _1057 = _956 - _976;
              float _1058 = _956 / _1057;
              float _1059 = saturate(_1058);
              float _1060 = min(_954, 1.0f);
              float _1061 = _1059 - _1060;
              _1080 = _1061;
            } else {
              _1080 = 0.0f;
            }
            float _1081 = _1080 * _931;
            float _1082 = _1080 * _933;
            float _1083 = _1080 * _934;
            float _1084 = _1081 + _951;
            float _1085 = _1082 + _952;
            float _1086 = _1083 + _953;
            float _1087 = _1084 * 2.0f;
            float _1088 = _1085 * 2.0f;
            float _1089 = _1087 + -1.0f;
            float _1090 = 1.0f - _1088;
            _1093 = _1089;
            _1094 = _1090;
            _1095 = _1086;
          } else {
            bool _1063 = ((uint)_955 < (uint)15);
            if (_1063) {
              float _1065 = abs(_934);
              float _1066 = min(_1065, _976);
              float _1067 = _951 + _931;
              float _1068 = _952 + _933;
              float _1069 = _953 + _934;
              float _1070 = _954 + 1.0f;
              _1072 = _1067;
              _1073 = _1068;
              _1074 = _1069;
              _1075 = _1070;
              _1076 = _1066;
            } else {
              _1072 = _951;
              _1073 = _952;
              _1074 = _953;
              _1075 = _954;
              _1076 = _956;
            }
            int _1077 = _955 + 1;
            bool _1078 = ((uint)_1077 < (uint)16);
            if (_1078) {
              _951 = _1072;
              _952 = _1073;
              _953 = _1074;
              _954 = _1075;
              _955 = _1077;
              _956 = _1076;
              continue;
            } else {
              _1093 = -1.0f;
              _1094 = 1.0f;
              _1095 = -1.0f;
            }
          }
        } else {
          bool _1063 = ((uint)_955 < (uint)15);
          if (_1063) {
            float _1065 = abs(_934);
            float _1066 = min(_1065, _976);
            float _1067 = _951 + _931;
            float _1068 = _952 + _933;
            float _1069 = _953 + _934;
            float _1070 = _954 + 1.0f;
            _1072 = _1067;
            _1073 = _1068;
            _1074 = _1069;
            _1075 = _1070;
            _1076 = _1066;
          } else {
            _1072 = _951;
            _1073 = _952;
            _1074 = _953;
            _1075 = _954;
            _1076 = _956;
          }
          int _1077 = _955 + 1;
          bool _1078 = ((uint)_1077 < (uint)16);
          if (_1078) {
            _951 = _1072;
            _952 = _1073;
            _953 = _1074;
            _954 = _1075;
            _955 = _1077;
            _956 = _1076;
            continue;
          } else {
            _1093 = -1.0f;
            _1094 = 1.0f;
            _1095 = -1.0f;
          }
        }
        bool _1096 = (_1095 > 0.0f);
        if (_1096) {
          float _1118 = (_invViewProjRelative[0].x) * _1093;
          float _1119 = mad((_invViewProjRelative[0].y), _1094, _1118);
          float _1120 = mad((_invViewProjRelative[0].z), _1095, _1119);
          float _1121 = _1120 + (_invViewProjRelative[0].w);
          float _1122 = (_invViewProjRelative[1].x) * _1093;
          float _1123 = mad((_invViewProjRelative[1].y), _1094, _1122);
          float _1124 = mad((_invViewProjRelative[1].z), _1095, _1123);
          float _1125 = _1124 + (_invViewProjRelative[1].w);
          float _1126 = (_invViewProjRelative[2].x) * _1093;
          float _1127 = mad((_invViewProjRelative[2].y), _1094, _1126);
          float _1128 = mad((_invViewProjRelative[2].z), _1095, _1127);
          float _1129 = _1128 + (_invViewProjRelative[2].w);
          float _1130 = (_invViewProjRelative[3].x) * _1093;
          float _1131 = mad((_invViewProjRelative[3].y), _1094, _1130);
          float _1132 = mad((_invViewProjRelative[3].z), _1095, _1131);
          float _1133 = _1132 + (_invViewProjRelative[3].w);
          float _1134 = _1121 / _1133;
          float _1135 = _1125 / _1133;
          float _1136 = _1129 / _1133;
          float _1137 = _1134 - _147;
          float _1138 = _1135 - _148;
          float _1139 = _1136 - _149;
          float _1140 = _1137 * _1137;
          float _1141 = _1138 * _1138;
          float _1142 = _1141 + _1140;
          float _1143 = _1139 * _1139;
          float _1144 = _1142 + _1143;
          float _1145 = sqrt(_1144);
          _1147 = _778;
          _1148 = _779;
          _1149 = _775;
          _1150 = _776;
          _1151 = _770;
          _1152 = _771;
          _1153 = _772;
          _1154 = _773;
          _1155 = _790;
          _1156 = _791;
          _1157 = _792;
          _1158 = _788;
          _1159 = _1145;
        } else {
          _1147 = _778;
          _1148 = _779;
          _1149 = _775;
          _1150 = _776;
          _1151 = _770;
          _1152 = _771;
          _1153 = _772;
          _1154 = _773;
          _1155 = _790;
          _1156 = _791;
          _1157 = _792;
          _1158 = _788;
          _1159 = 1023.0f;
        }
        break;
      }
    } else {
      _1147 = 0;
      _1148 = 0;
      _1149 = 0;
      _1150 = 0;
      _1151 = 0.0f;
      _1152 = 0.0f;
      _1153 = 0.0f;
      _1154 = 0.0f;
      _1155 = 0.0f;
      _1156 = 0.0f;
      _1157 = 0.0f;
      _1158 = 512.0f;
      _1159 = 1023.0f;
    }
    bool _1160 = (_59 == 29);
    [branch]
    if (_1160) {
      float _1162 = min(1023.0f, _1159);
      float _1163 = _1162 * 64.06158447265625f;
      float _1164 = _1163 + 0.5f;
      uint _1165 = uint(_1164);
      int _1166 = min(65535, _1165);
      int _1167 = min(32767, _759);
      uint _1168 = _1167 << 16;
      int _1169 = _1168 | _1166;
      int _1170 = asint(_757);
      __3__38__0__1__g_manyLightsHitDataUAV[int2(_47, _49)] = int2(_1169, _1170);
    } else {
      float _1173 = _1158 * _1158;
      float _1174 = _1154 * _1154;
      float _1175 = max(_1174, _1173);
      bool _1176 = (_1154 > 99999.0f);
      float _1177 = 1.0f / _1175;
      float _1178 = select(_1176, 1.0f, _1177);
      float _1179 = saturate(_1178);
      float _1180 = select(_1176, 1.0f, _1179);
      bool _1181 = (_1159 >= 1000.0f);
      float _1182 = float((bool)_1181);
      float _1183 = _1180 * _1182;
      float _1184 = _1183 * _1151;
      float _1185 = _1183 * _1152;
      float _1186 = _1183 * _1153;
      int _1187 = _1149 & 65535;
      int _1188 = (uint)(_1149) >> 16;
      int _1189 = _1150 & 65535;
      int _1190 = (uint)(_1150) >> 16;
      float _1191 = f16tof32(_1187);
      float _1192 = f16tof32(_1188);
      float _1193 = f16tof32(_1189);
      float _1194 = f16tof32(_1190);
      float _1195 = dot(float3(_1191, _1192, _1193), float3(_1191, _1192, _1193));
      float _1196 = rsqrt(_1195);
      int _1197 = _1147 & 65535;
      int _1198 = (uint)(_1147) >> 16;
      int _1199 = _1148 & 65535;
      float _1200 = f16tof32(_1197);
      float _1201 = f16tof32(_1198);
      float _1202 = f16tof32(_1199);
      float _1203 = dot(float3(_1200, _1201, _1202), float3(_1200, _1201, _1202));
      float _1204 = rsqrt(_1203);
      float _1205 = _1204 * _1200;
      float _1206 = _1204 * _1201;
      float _1207 = _1204 * _1202;
      bool _1208 = !(_1194 >= 0.0f);
      if (!_1208) {
        int _1210 = (uint)(_1148) >> 16;
        float _1211 = f16tof32(_1210);
        float _1212 = _1196 * _1193;
        float _1213 = _1196 * _1192;
        float _1214 = _1191 * _1155;
        float _1215 = _1214 * _1196;
        float _1216 = mad(_1156, _1213, _1215);
        float _1217 = mad(_1157, _1212, _1216);
        float _1218 = _1205 * _1155;
        float _1219 = mad(_1156, _1206, _1218);
        float _1220 = mad(_1157, _1207, _1219);
        float _1221 = dot(float3(_1155, _1156, _1157), float3(_1205, _1206, _1207));
        float _1222 = asin(_1221);
        float _1223 = _1222 * 0.31830987334251404f;
        float _1224 = _1223 + 0.5f;
        float _1225 = -0.0f - _1217;
        float _1226 = -0.0f - _1220;
        float _1227 = _1226 / _1225;
        float _1228 = atan(_1227);
        float _1229 = _1228 + 3.1415927410125732f;
        float _1230 = _1228 + -3.1415927410125732f;
        bool _1231 = (_1217 > -0.0f);
        bool _1232 = (_1217 == -0.0f);
        bool _1233 = (_1220 <= -0.0f);
        bool _1234 = (_1220 > -0.0f);
        bool _1235 = (_1231) & (_1233);
        float _1236 = select(_1235, _1229, _1228);
        bool _1237 = (_1231) & (_1234);
        float _1238 = select(_1237, _1230, _1236);
        bool _1239 = (_1232) & (_1234);
        bool _1240 = (_1232) & (_1233);
        float _1241 = _1238 * 0.31830987334251404f;
        float _1242 = select(_1239, -0.5f, _1241);
        float _1243 = select(_1240, 0.5f, _1242);
        float _1244 = abs(_1243);
        float _1245 = saturate(_1244);
        float _1246 = _1245 * _1211;
        float _1247 = _1246 + _1194;
        float _1250 = __3__36__0__0__g_lightProfile.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1224, _1247), 0.0f);
        float _1252 = _1250.x * _1184;
        float _1253 = _1250.x * _1185;
        float _1254 = _1250.x * _1186;
        _1256 = _1252;
        _1257 = _1253;
        _1258 = _1254;
      } else {
        _1256 = _1184;
        _1257 = _1185;
        _1258 = _1186;
      }
      float _1259 = _1155 - _165;
      float _1260 = _1156 - _166;
      float _1261 = _1157 - _167;
      float _1262 = dot(float3(_1259, _1260, _1261), float3(_1259, _1260, _1261));
      float _1263 = rsqrt(_1262);
      float _1264 = _1263 * _1259;
      float _1265 = _1263 * _1260;
      float _1266 = _1263 * _1261;
      float _1267 = dot(float3(_82, _83, _84), float3(_1155, _1156, _1157));
      float _1268 = dot(float3(_82, _83, _84), float3(_1264, _1265, _1266));
      float _1269 = dot(float3(_199, _200, _201), float3(_1264, _1265, _1266));
      float _1270 = dot(float3(_199, _200, _201), float3(_199, _200, _201));
      float _1271 = saturate(_1269);
      float _1272 = 1.0f - _1271;
      float _1273 = saturate(_1272);
      float _1274 = _1273 * _1273;
      float _1275 = _1274 * _1274;
      float _1276 = _1275 * _1273;
      float _1277 = 1.0f - _1276;
      float _1278 = _1277 * 0.03999999910593033f;
      float _1279 = _1278 + _1276;
      float _1280 = _1270 * 0.9995999932289124f;
      float _1281 = _1280 + 0.00039999998989515007f;
      float _1282 = _1281 * _1267;
      float _1283 = _1267 * 0.9995999932289124f;
      float _1284 = _1283 + 0.00039999998989515007f;
      float _1285 = _1270 * _1284;
      float _1286 = _1282 + _1285;
      float _1287 = 0.5f / _1286;
      float _1288 = _1268 * _1268;
      float _1289 = _1288 * 0.9999998211860657f;
      float _1290 = 1.0f - _1289;
      float _1291 = _1290 * _1290;
      float _1292 = 5.092957522379038e-08f / _1291;
      float _1293 = _1292 * _1287;
      float _1294 = _1293 * _1279;
      float _1295 = max(_1294, 0.0f);
      float _1296 = saturate(_1267);
      float _1297 = _1296 * _1295;
      float _1298 = _1297 * _1256;
      float _1299 = _1297 * _1257;
      float _1300 = _1297 * _1258;
      bool _1301 = (_180 == 64);
      if (_1301) {
        bool _1305 = (_cavityParams.z > 0.0f);
        float _1306 = select(_1305, 0.0f, 1.0f);
        _1312 = _1306;
      } else {
        float _1308 = _91 * -2.3083121050149202e-06f;
        float _1309 = exp2(_1308);
        float _1310 = saturate(_1309);
        _1312 = _1310;
      }
      float _1313 = dot(float3(_199, _200, _201), float3(_82, _83, _84));
      float _1314 = saturate(_1313);
      if (_1301) {
        bool _1318 = (_cavityParams.x == 0.0f);
        float _1319 = _1312 * 0.03999999910593033f;
        float _1320 = select(_1318, 0.03999999910593033f, _1319);
        _1322 = _1320;
      } else {
        _1322 = 0.03999999910593033f;
      }
      float _1323 = min(0.9900000095367432f, _1314);
      float2 _1326 = __3__36__0__0__g_iblBrdfLookup.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_1323, 0.9800000190734863f), 0.0f);
      float _1329 = _1326.x * _1322;
      float _1330 = _1326.x * _1322;
      float _1331 = _1326.x * _1322;
      float _1332 = _1329 + _1326.y;
      float _1333 = _1330 + _1326.y;
      float _1334 = _1331 + _1326.y;
      float _1335 = max(0.009999999776482582f, _1332);
      float _1336 = max(0.009999999776482582f, _1333);
      float _1337 = max(0.009999999776482582f, _1334);
      float _1338 = _1298 / _1335;
      float _1339 = _1299 / _1336;
      float _1340 = _1300 / _1337;
      float4 _1342 = __3__38__0__1__g_specularResultUAV.Load(int2(_47, _49));
      float _1347 = _1342.x + _1338;
      float _1348 = _1342.y + _1339;
      float _1349 = _1342.z + _1340;
      __3__38__0__1__g_specularResultUAV[int2(_47, _49)] = float4(_1347, _1348, _1349, _1342.w);
    }
  }
}
