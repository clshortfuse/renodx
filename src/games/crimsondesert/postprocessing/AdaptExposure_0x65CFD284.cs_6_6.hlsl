#include "../shared.h"
#include "../common.hlsl"

Texture3D<float> __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav : register(t140, space36);

StructuredBuffer<uint> __3__37__0__0__g_histogram : register(t4, space37);

StructuredBuffer<uint> __3__37__0__0__g_histogram2 : register(t5, space37);

StructuredBuffer<uint> __3__37__0__0__g_histogramR : register(t6, space37);

StructuredBuffer<uint> __3__37__0__0__g_histogramG : register(t7, space37);

StructuredBuffer<uint> __3__37__0__0__g_histogramB : register(t8, space37);

RWStructuredBuffer<float> __3__39__0__1__g_exposureUAV : register(u8, space39);

RWStructuredBuffer<float4> __3__39__0__1__g_autoWhiteBalanceColorUAV : register(u14, space39);

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

cbuffer __3__35__0__0__VoxelGlobalIlluminationConstantBuffer : register(b1, space35) {
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

cbuffer __3__1__0__0__GlobalPushConstants : register(b0, space1) {
  float4 _param0 : packoffset(c000.x);
  float4 _param1 : packoffset(c001.x);
  float4 _param2 : packoffset(c002.x);
  float4 _param3 : packoffset(c003.x);
};

SamplerState __0__4__0__0__g_staticVoxelSampler : register(s12, space4);

groupshared int _global_0[256];
groupshared int _global_1[256];
groupshared int _global_2[768];

[numthreads(256, 1, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  bool _34 = ((int)(SV_GroupID.x) == 0);
  bool _135;
  int _142;
  float _143;
  int _156;
  float _157;
  float _158;
  float _159;
  float _160;
  float _161;
  float _162;
  int _200;
  int _255;
  float _286;
  float _381;
  int _383;
  float _384;
  float _385;
  float _424;
  float _427;
  float _456;
  bool _635;
  int _643;
  float _644;
  int _657;
  float _658;
  float _659;
  float _660;
  float _661;
  int _690;
  float _691;
  int _705;
  float _706;
  float _707;
  float _708;
  float _709;
  int _738;
  float _739;
  int _753;
  float _754;
  float _755;
  float _756;
  float _757;
  float _884;
  float _885;
  float _897;
  float _923;
  float _924;
  float _925;
  float _926;
  float _950;
  float _951;
  int _952;
  float _972;
  float _973;
  int _974;
  float _994;
  float _995;
  int _996;
  if (_34) {
    uint _36 = SV_GroupIndex << 2;
    int _39 = __3__37__0__0__g_histogram[_36];
    int _42 = __3__37__0__0__g_histogram2[_36];
    int _43 = _36 | 1;
    int _45 = __3__37__0__0__g_histogram[_43];
    int _46 = max(_39, _45);
    int _48 = __3__37__0__0__g_histogram2[_43];
    int _49 = max(_42, _48);
    int _50 = _36 | 2;
    int _52 = __3__37__0__0__g_histogram[_50];
    int _53 = max(_46, _52);
    int _55 = __3__37__0__0__g_histogram2[_50];
    int _56 = max(_49, _55);
    int _57 = _36 | 3;
    int _59 = __3__37__0__0__g_histogram[_57];
    int _60 = max(_53, _59);
    int _62 = __3__37__0__0__g_histogram2[_57];
    int _63 = max(_56, _62);
    _global_0[(int)(SV_GroupIndex)] = _60;
    _global_1[(int)(SV_GroupIndex)] = _63;
    GroupMemoryBarrierWithGroupSync();
    bool _66 = ((uint)(int)(SV_GroupIndex) < (uint)32);
    if (_66) {
      uint _68 = SV_GroupIndex + 32u;
      int _70 = _global_0[_68];
      int _71 = _global_0[(int)(SV_GroupIndex)];
      int _72 = max(_71, _70);
      _global_0[(int)(SV_GroupIndex)] = _72;
      int _74 = _global_1[_68];
      int _75 = _global_1[(int)(SV_GroupIndex)];
      int _76 = max(_75, _74);
      _global_1[(int)(SV_GroupIndex)] = _76;
    }
    GroupMemoryBarrierWithGroupSync();
    bool _78 = ((uint)(int)(SV_GroupIndex) < (uint)16);
    if (_78) {
      uint _80 = SV_GroupIndex + 16u;
      int _82 = _global_0[_80];
      int _83 = _global_0[(int)(SV_GroupIndex)];
      int _84 = max(_83, _82);
      _global_0[(int)(SV_GroupIndex)] = _84;
      int _86 = _global_1[_80];
      int _87 = _global_1[(int)(SV_GroupIndex)];
      int _88 = max(_87, _86);
      _global_1[(int)(SV_GroupIndex)] = _88;
    }
    GroupMemoryBarrierWithGroupSync();
    bool _90 = ((uint)(int)(SV_GroupIndex) < (uint)8);
    if (_90) {
      uint _92 = SV_GroupIndex + 8u;
      int _94 = _global_0[_92];
      int _95 = _global_0[(int)(SV_GroupIndex)];
      int _96 = max(_95, _94);
      _global_0[(int)(SV_GroupIndex)] = _96;
      int _98 = _global_1[_92];
      int _99 = _global_1[(int)(SV_GroupIndex)];
      int _100 = max(_99, _98);
      _global_1[(int)(SV_GroupIndex)] = _100;
    }
    GroupMemoryBarrierWithGroupSync();
    bool _102 = ((uint)(int)(SV_GroupIndex) < (uint)4);
    if (_102) {
      uint _104 = SV_GroupIndex + 4u;
      int _106 = _global_0[_104];
      int _107 = _global_0[(int)(SV_GroupIndex)];
      int _108 = max(_107, _106);
      _global_0[(int)(SV_GroupIndex)] = _108;
      int _110 = _global_1[_104];
      int _111 = _global_1[(int)(SV_GroupIndex)];
      int _112 = max(_111, _110);
      _global_1[(int)(SV_GroupIndex)] = _112;
    }
    GroupMemoryBarrierWithGroupSync();
    bool _114 = ((uint)(int)(SV_GroupIndex) < (uint)2);
    if (_114) {
      uint _116 = SV_GroupIndex + 2u;
      int _118 = _global_0[_116];
      int _119 = _global_0[(int)(SV_GroupIndex)];
      int _120 = max(_119, _118);
      _global_0[(int)(SV_GroupIndex)] = _120;
      int _122 = _global_1[_116];
      int _123 = _global_1[(int)(SV_GroupIndex)];
      int _124 = max(_123, _122);
      _global_1[(int)(SV_GroupIndex)] = _124;
    }
    GroupMemoryBarrierWithGroupSync();
    bool _126 = ((int)(SV_GroupIndex) == 0);
    if (_126) {
      int _128 = _global_0[1];
      int _129 = _global_0[0];
      int _130 = max(_129, _128);
      _global_0[0] = _130;
      int _131 = _global_1[1];
      int _132 = _global_1[0];
      int _133 = max(_132, _131);
      _global_1[0] = _133;
      _135 = _126;
    } else {
      _135 = false;
    }
    GroupMemoryBarrierWithGroupSync();
    if (_135) {
      int _137 = _global_0[0];
      float _138 = float((uint)_137);
      float _139 = max(9.999999974752427e-07f, _138);
      float _140 = 1.0f / _139;
      _142 = 0;
      _143 = 0.0f;
      while(true) {
        int _146 = __3__37__0__0__g_histogram[_142];
        float _147 = float((uint)_146);
        float _148 = _147 * _140;
        float _149 = _148 + _143;
        int _150 = _142 + 1;
        bool _151 = (_150 == 256);
        if (!_151) {
          _142 = _150;
          _143 = _149;
          continue;
        }
        float _153 = _149 * _param1.x;
        float _154 = _149 * _param1.y;
        _156 = 0;
        _157 = 0.0f;
        _158 = 0.0f;
        _159 = _153;
        _160 = _154;
        _161 = 0.0f;
        _162 = 0.0f;
        while(true) {
          float _163 = float((uint)_156);
          float _164 = _163 * 0.00390625f;
          float _165 = _164 - _param0.y;
          float _166 = _165 / _param0.x;
          float _167 = exp2(_166);
          int _170 = __3__37__0__0__g_histogram[_156];
          float _171 = float((uint)_170);
          float _172 = _171 * _140;
          float _173 = min(_159, _172);
          float _174 = _172 - _173;
          float _175 = _159 - _173;
          float _176 = _160 - _173;
          float _177 = min(_176, _174);
          float _178 = _176 - _177;
          float _179 = _167 * _177;
          float _180 = _179 + _157;
          float _181 = _177 + _158;
          float _182 = _179 * _179;
          float _183 = _179 + _161;
          float _184 = _182 + _162;
          int _185 = _156 + 1;
          bool _186 = (_185 == 256);
          if (!_186) {
            _156 = _185;
            _157 = _180;
            _158 = _181;
            _159 = _175;
            _160 = _178;
            _161 = _183;
            _162 = _184;
            continue;
          }
          float _188 = _183 * 0.00390625f;
          float _189 = _184 * 0.00390625f;
          float _190 = _188 * _188;
          float _191 = _189 - _190;
          float _192 = max(9.999999717180685e-10f, _191);
          float _193 = max(_181, 9.999999747378752e-05f);
          float _194 = _180 / _193;
          // When IMPROVED is on, override the game's per region and ToD controls
          // min/max luminance clamps with fixed values, I hope this solves double darkening
          float _ae_min_lum = (IMPROVED_AUTO_EXPOSURE == 2) ? AE_MIN_LUM : _param1.z;
          float _ae_max_lum = (IMPROVED_AUTO_EXPOSURE == 2) ? AE_MAX_LUM : _param1.w;
          float _195 = max(_194, _ae_min_lum);
          float _196 = min(_195, _ae_max_lum);
          float _197 = sqrt(_192);
          float _198 = max(9.999999974752427e-07f, _196);

          // === RenoDX: filter target luminance in log space ===
          // The raw histogram mean (_198) jitters per frame temporally.
          // Low pass it before it feeds into the exposure curve to reduce
          // oscillation
          //
          // Doesnt fully remove bloom jitter but better than before especially 
          // with alt auto exposure
          float _198_filtered;
          if (IMPROVED_AUTO_EXPOSURE >= 1) {
            float _prevFilteredTarget = __3__39__0__1__g_exposureUAV[19];
            if (_prevFilteredTarget > 0.0001f && !isnan(_prevFilteredTarget)) {
              float _logPrev = log2(_prevFilteredTarget);
              float _logCur  = log2(_198);
              float _logSmooth = lerp(_logPrev, _logCur, 0.12f);
              _198_filtered = exp2(_logSmooth);
            } else {
              _198_filtered = _198;
            }
          } else {
            _198_filtered = _198;
          }

          _200 = 1;
          while(true) {
            int _201 = _200 + 20;
            float _207 = _voxelParams.x + -63.0f;
            float _208 = _voxelParams.y + -31.0f;
            float _209 = _voxelParams.z + -63.0f;
            int _210 = int(_207);
            int _211 = int(_208);
            int _212 = int(_209);
            float _213 = _voxelParams.x + 63.0f;
            float _214 = _voxelParams.y + 31.0f;
            float _215 = _voxelParams.z + 63.0f;
            int _216 = int(_213);
            int _217 = int(_214);
            int _218 = int(_215);
            float _223 = _wrappedViewPos.x * _voxelParams.w;
            float _224 = _wrappedViewPos.y * _voxelParams.w;
            float _225 = _wrappedViewPos.z * _voxelParams.w;
            int _226 = _200 + 36;
            float _231 = _223 + _voxelParams.x;
            float _232 = _224 + _voxelParams.y;
            float _233 = _225 + _voxelParams.z;
            float _234 = floor(_231);
            float _235 = floor(_232);
            float _236 = floor(_233);
            int _237 = int(_234);
            int _238 = int(_235);
            int _239 = int(_236);
            bool _240 = ((int)_237 < (int)_216);
            bool _241 = ((int)_238 < (int)_217);
            bool _242 = ((int)_239 < (int)_218);
            bool _243 = ((int)_237 >= (int)_210);
            bool _244 = ((int)_238 >= (int)_211);
            bool _245 = ((int)_239 >= (int)_212);
            bool _246 = (_243) & (_240);
            bool _247 = (_244) & (_241);
            bool _248 = (_245) & (_242);
            bool _249 = (_246) & (_247);
            bool _250 = (_249) & (_248);
            if (!_250) {
              int _252 = _200 + 1;
              bool _253 = ((uint)_252 < (uint)8);
              if (_253) {
                _200 = _252;
                continue;
              } else {
                _255 = -10000;
              }
            } else {
              _255 = _200;
            }
            bool _256 = ((uint)_255 > (uint)3);
            if (!_256) {
              int _262 = _255 & 31;
              uint _263 = 1u << _262;
              float _264 = float((uint)_263);
              float _265 = 1.0f / _264;
              float _266 = _clipmapUVRelativeOffset.x * _265;
              float _267 = _clipmapUVRelativeOffset.y * _265;
              float _268 = _clipmapUVRelativeOffset.z * _265;
              float _269 = frac(_268);
              bool _270 = (_269 < 0.0f);
              float _271 = select(_270, 1.0f, 0.0f);
              float _272 = _271 + _269;
              float _273 = _272 * 64.0f;
              uint _274 = _255 * 66;
              float _275 = float((uint)_274);
              float _276 = _275 + 1.0f;
              float _277 = _276 + _273;
              float _278 = _277 * 0.0037878789007663727f;
              float _281 = __3__36__0__1__g_skyVisibilityVoxelsTexturesLikeUav.SampleLevel(__0__4__0__0__g_staticVoxelSampler, float3(_266, _267, _278), 0.0f);
              float _283 = 1.0f - _281.x;
              float _284 = saturate(_283);
              _286 = _284;
            } else {
              _286 = 1.0f;
            }
            float _287 = sqrt(_286);
            float _288 = _198_filtered * -144.26950073242188f;
            float _289 = exp2(_288);
            float _290 = _289 + 1.0f;
            float _291 = 2.0f / _290;
            float _292 = _291 + -1.0f;
            float _293 = saturate(_292);
            float _294 = -1.5f - _287;
            float _295 = _287 + 2.0f;
            float _296 = _293 * _295;
            float _297 = _296 + _294;
            float _298 = saturate(_198_filtered);
            float _299 = log2(_298);
            float _300 = _299 * 0.25f;
            float _301 = exp2(_300);
            float _302 = _287 * 2.5f;
            float _303 = -2.0f - _302;
            float _304 = _302 + 2.5f;
            float _305 = _301 * _304;
            float _306 = _299 * 0.10000000149011612f;
            float _307 = exp2(_306);
            float _308 = _303 - _297;
            float _309 = _308 + _305;
            float _310 = _309 * _307;
            float _311 = _310 + _297;
            float _312 = _197 * 10.0f;
            float _313 = max(9.999999717180685e-10f, _196);
            float _314 = _312 / _313;
            float _315 = _314 * _314;
            float _316 = saturate(_315);
            float _317 = _316 * _311;
            float _320 = __3__39__0__1__g_autoWhiteBalanceColorUAV[1].w;
            float _321 = saturate(_320);
            float _322 = _321 * _param3.z;
            // Sky visibility exposure bias
            float _323 = (IMPROVED_AUTO_EXPOSURE == 2) ? 0.0f : (_322 + _param2.z);
            float _324 = max(_198_filtered, 9.999999747378752e-05f);
            float _325 = min(_324, 7.0f);
            float _326 = _325 + -0.009999999776482582f;
            float _327 = _326 * 0.14306151866912842f;
            float _328 = saturate(_327);
            float _329 = _325 + -9.999999747378752e-05f;
            float _330 = _329 * 101.01010131835938f;
            float _331 = saturate(_330);
            float _332 = _331 * 2.0f;
            float _333 = _331 * 3.0f;
            float _334 = _332 + -3.5f;
            float _335 = _333 + -3.0f;
            float _336 = 3.0f - _332;
            float _337 = _336 * _328;
            float _338 = _335 * _328;
            float _339 = _334 + _337;
            float _340 = _335 - _338;
            float _341 = saturate(_287);
            float _342 = sqrt(_341);
            float _343 = _339 - _340;
            // Vanilla path (IMPROVED_AUTO_EXPOSURE == 0): keep this sky/occlusion-dependent
            // bias term active. Mode 2 zeros it and replaces it with explicit HDR shaping.
            float _344 = (IMPROVED_AUTO_EXPOSURE == 2) ? 0.0f : (_343 * _342);
            float _345 = _198_filtered * 8.0f;
            float _346 = log2(_345);
            float _347 = _346 - _340;
            float _348 = _347 - _344;
            float _349 = exp2(_348);
            // Baseline game exposure target. In mode 0 this value is used directly.
            float _350_vanilla = 0.8333333134651184f / _349;

            float _350;
            if (IMPROVED_AUTO_EXPOSURE == 2) {
              // --- HDR asymmetric exposure adaptation ---
              // We reduce vanilla's adaptation strength via a power curve
              // in log space, modulated by sky visibility and scene brightness.
              //
              // _287 = sqrt(sky occlusion): 0 = outdoor, 1 = indoor
              // logVanilla > 0 → dark scene (vanilla brightens)
              // logVanilla < 0 → bright scene (vanilla dims)
              float logVanilla = log2(max(_350_vanilla, 0.0001f));
              float logTarget;
              if (logVanilla >= 0.0f) {
                // DARK SCENE: vanilla wants to brighten. For HDR, reduce the
                // boost so nights stay actually dark and interiors aren't nuclear.
                float power = lerp(AE_DARK_POWER_OUTDOOR, AE_DARK_POWER_INDOOR, _287);
                logTarget = logVanilla * power;
              } else {
                // BRIGHT SCENE: vanilla wants to dim. For HDR, preserve most of
                // the dimming for outdoor/day to prevent blowout.
                float power = lerp(AE_BRIGHT_POWER_OUTDOOR, AE_BRIGHT_POWER_INDOOR, _287);
                logTarget = logVanilla * power;
              }
              _350 = clamp(exp2(logTarget), 0.02f, 5.0f);
            } else {
              // Mode 0/1: use the original target curve (no mode-2 log-power remap).
              _350 = _350_vanilla;
            }

            bool _353 = !(_temporalReprojectionParams.w > 0.5f);
            if (_353) {
              float _357 = __3__39__0__1__g_exposureUAV[1];
              if (IMPROVED_AUTO_EXPOSURE == 2) {
                // Unified log space temporal adaptation becasue Vanilla uses two separate interpolation spaces (1/exp vs linear) 
                // Causes visible jitter when the target oscillates around the previous value due to histogram noise. 
                // Log space lerp is symmetric and smooth in both directions.
                float logPrev = log2(max(_357, 0.0001f));
                float logTgt  = log2(max(_350, 0.0001f));

                // Pick adaptation speed based on direction
                float speed;
                if (logTgt > logPrev) {
                  // Scene darkening → exposure rising (use brightening speed)
                  speed = _param2.x;
                } else {
                  // Scene brightening → exposure falling (use darkening speed)
                  // Apply speed boost proportional to gap for fast transitions
                  float logGap = logPrev - logTgt;
                  float speedBoost = 1.0f + saturate(logGap) * AE_ADAPT_SPEED_BOOST;
                  speed = _param2.y * speedBoost;
                }

                float tau = 1.0f - exp2(-speed * _timeNoScale.z);
                float logNew = lerp(logPrev, logTgt, tau);
                _381 = exp2(logNew);
              } else {
                // --- Vanilla asymmetric temporal adaptation ---
                // Mode 0 stays here: brighten in reciprocal space, darken in linear
                // space, matching the game's original adaptation behavior.

                float time_scale = _timeNoScale.z;
                if (IMPROVED_AUTO_EXPOSURE == 1.f) time_scale = lerp(time_scale, time_scale * 3.f, AE_SPEED);

                bool _358 = (_350 > _357);
                if (_358) {
                  float _362 = _349 * 1.2000000476837158f;
                  float _363 = 1.0f / _357;
                  float _364 = _362 - _363;
                  float _365 = _param2.x * time_scale;
                  float _366 = -0.0f - _365;
                  float _367 = exp2(_366);
                  float _368 = 1.0f - _367;
                  float _369 = _368 * _364;
                  float _370 = _369 + _363;
                  float _371 = 1.0f / _370;
                  _381 = _371;
                } else {
                  float _373 = _350 - _357;
                  float _374 = _param2.y * time_scale;
                  float _375 = -0.0f - _374;
                  float _376 = exp2(_375);
                  float _377 = 1.0f - _376;
                  float _378 = _377 * _373;
                  float _379 = _378 + _357;
                  _381 = _379;
                }
              }
            } else {
              // Temporal reset (loading screens, menus)
              if (IMPROVED_AUTO_EXPOSURE == 2) {
                // Preserve previous exposure to prevent spikes from garbage
                // histogram data during transitions. Temporal adaptation will
                // smoothly converge once gameplay resumes.
                float prevExposure = __3__39__0__1__g_exposureUAV[1];
                _381 = (prevExposure > 0.001f) ? prevExposure : _350;
              } else {
                _381 = _350;
              }
            }


            _383 = 0;
            _384 = 0.0f;
            _385 = 0.0f;
            while(true) {
              int _388 = __3__37__0__0__g_histogram[_383];
              float _389 = float((uint)_388);
              float _390 = _389 * _140;
              float _391 = float((uint)_383);
              float _392 = _391 * 0.00390625f;
              float _393 = _392 - _param0.y;
              float _394 = _393 / _param0.x;
              float _395 = exp2(_394);
              float _396 = _390 * _395;
              float _397 = _396 + _384;
              float _398 = _390 + _385;
              int _399 = _383 + 1;
              bool _400 = (_399 == 256);
              if (!_400) {
                _383 = _399;
                _384 = _397;
                _385 = _398;
                continue;
              }
              float _402 = max(_398, 9.999999747378752e-05f);
              float _403 = _397 / _402;
              float _404 = _403 * 1e+05f;
              float _405 = saturate(_404);
              float _406 = _317 * _405;
              float _407 = max(_403, _198_filtered);
              float _410 = __3__39__0__1__g_exposureUAV[11];
              float _411 = _407 - _410;
              float _412 = _411 * 0.125f;
              float _413 = _412 + _410;
              bool _414 = !(_param3.x == 1.0f);
              float _416 = __3__39__0__1__g_exposureUAV[0];
              if (!_414) {
                float _419 = __3__39__0__1__g_exposureUAV[4];
                bool _420 = (_419 > 0.0010000000474974513f);
                if (_420) {
                  float _422 = exp2(_323);
                  _424 = _422;
                } else {
                  _424 = 1.0f;
                }
                float _425 = _424 * _381;
                // Mode 0/1: no extra EV bias; output remains the vanilla-scaled exposure.
                // Apply EV bias for IMPROVED mode (compensates for zeroed _323 push constant correction)
                _427 = (IMPROVED_AUTO_EXPOSURE == 2) ? (_425 * exp2(AE_EV_BIAS)) : _425;
              } else {
                _427 = _param3.y;
              }

              // if (IMPROVED_AUTO_EXPOSURE == 1) _427 = min(_427, lerp(1.f, 11.f, AE_DARK_POWER_OUTDOOR));
              // if (IMPROVED_AUTO_EXPOSURE == 1) _427 = min(_427, 7.f);
              // if (IMPROVED_AUTO_EXPOSURE == 1) _427 = renodx::color::grade::Contrast(_427, 1.f * AE_DARK_POWER_OUTDOOR, 0.18f);
              if (IMPROVED_AUTO_EXPOSURE == 1) {
                const float pivot = 0.1f;
                if (_427 > pivot) {
                  _427 = NakaRushton(_427, 10000.f, pivot, pivot, AE_DYNAMISM_HIGH).x;
                } else {
                  _427 = NakaRushton(_427, 10000.f, pivot, pivot, 2.f - AE_DYNAMISM_LOW).x;
                }
                
              }

              __3__39__0__1__g_exposureUAV[0] = _427;
              float _428 = select(_414, _param3.y, _381);

              __3__39__0__1__g_exposureUAV[1] = _428;
              __3__39__0__1__g_exposureUAV[2] = _param0.x;
              __3__39__0__1__g_exposureUAV[3] = _param0.y;
              __3__39__0__1__g_exposureUAV[4] = _138;
              __3__39__0__1__g_exposureUAV[5] = _348;
              __3__39__0__1__g_exposureUAV[8] = _198;
              __3__39__0__1__g_exposureUAV[9] = _416;
              __3__39__0__1__g_exposureUAV[10] = _407;
              __3__39__0__1__g_exposureUAV[11] = _413;
              float _440 = __3__39__0__1__g_exposureUAV[12];
              float _441 = _406 - _440;
              float _442 = _441 * 0.10000000149011612f;
              float _443 = _442 + _440;
              __3__39__0__1__g_exposureUAV[12] = _443;
              __3__39__0__1__g_exposureUAV[13] = 1.0f;
              __3__39__0__1__g_exposureUAV[14] = _197;
              __3__39__0__1__g_exposureUAV[15] = _198;
              bool _449 = (_terrainNormalParams.w > 0.0f);
              float _452 = __3__39__0__1__g_exposureUAV[16];
              if (_449) {
                float _454 = max(9.999999717180685e-10f, _427);
                _456 = _454;
              } else {
                _456 = 1.0f;
              }
              __3__39__0__1__g_exposureUAV[16] = _456;
              float _457 = max(9.999999717180685e-10f, _452);
              float _458 = _456 / _457;
              __3__39__0__1__g_exposureUAV[17] = _458;

              // === RenoDX: Bloom/lens glare stabilisation ===
              // Write a low passed exposure into slot 18 (_exposure4.z).
              // Histogram-AWB and LensFlareComposite read this instead of the fast
              // _exposure0.y when alt auto exposure is toggled.
              // This stops vanilla exposure + glare feedback loop that causes bloom shimmer.
              //
              // Look into maybe doing a further filtering for distance objects?
              if (IMPROVED_AUTO_EXPOSURE >= 1) {
                float prevSlowExp = __3__39__0__1__g_exposureUAV[18];
                float slowSeed = (prevSlowExp > 0.0001f && !isnan(prevSlowExp)) ? prevSlowExp : _427;
                float slowTau = 0.05f;
                float slowExp = lerp(slowSeed, _427, slowTau);
                __3__39__0__1__g_exposureUAV[18] = slowExp;
                // Slot 19: filtered target luminance for potential future use
                float prevSlowTarget = __3__39__0__1__g_exposureUAV[19];
                float targetSeed = (prevSlowTarget > 0.0001f && !isnan(prevSlowTarget)) ? prevSlowTarget : _198_filtered;
                float slowTarget = lerp(targetSeed, _198_filtered, 0.08f);
                __3__39__0__1__g_exposureUAV[19] = slowTarget;
              }

              break;
            }
            if (__loop_jump_target == 199) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
          if (__loop_jump_target == 155) {
            __loop_jump_target = -1;
            continue;
          }
          if (__loop_jump_target != -1) {
            break;
          }
          break;
        }
        if (__loop_jump_target == 141) {
          __loop_jump_target = -1;
          continue;
        }
        if (__loop_jump_target != -1) {
          break;
        }
        break;
      }
    }
  } else {
    bool _462 = (_param2.w > 0.0010000000474974513f);
    if (_462) {
      uint _464 = SV_GroupIndex << 2;
      int _467 = __3__37__0__0__g_histogramR[_464];
      int _470 = __3__37__0__0__g_histogramG[_464];
      int _473 = __3__37__0__0__g_histogramB[_464];
      int _474 = _464 | 1;
      int _476 = __3__37__0__0__g_histogramR[_474];
      int _478 = __3__37__0__0__g_histogramG[_474];
      int _480 = __3__37__0__0__g_histogramB[_474];
      int _481 = max(_467, _476);
      int _482 = max(_470, _478);
      int _483 = max(_473, _480);
      int _484 = _464 | 2;
      int _486 = __3__37__0__0__g_histogramR[_484];
      int _488 = __3__37__0__0__g_histogramG[_484];
      int _490 = __3__37__0__0__g_histogramB[_484];
      int _491 = max(_481, _486);
      int _492 = max(_482, _488);
      int _493 = max(_483, _490);
      int _494 = _464 | 3;
      int _496 = __3__37__0__0__g_histogramR[_494];
      int _498 = __3__37__0__0__g_histogramG[_494];
      int _500 = __3__37__0__0__g_histogramB[_494];
      int _501 = max(_491, _496);
      int _502 = max(_492, _498);
      int _503 = max(_493, _500);
      uint _504 = (int)(SV_GroupIndex) * 3;
      uint _505 = 0u + _504;
      _global_2[_505] = _501;
      uint _507 = (int)(SV_GroupIndex) * 3;
      uint _508 = 1u + _507;
      _global_2[_508] = _502;
      uint _510 = (int)(SV_GroupIndex) * 3;
      uint _511 = 2u + _510;
      _global_2[_511] = _503;
      GroupMemoryBarrierWithGroupSync();
      bool _513 = ((uint)(int)(SV_GroupIndex) < (uint)32);
      if (_513) {
        uint _515 = SV_GroupIndex + 32u;
        uint _516 = _515 * 3;
        uint _517 = 0u + _516;
        int _519 = _global_2[_517];
        uint _520 = _515 * 3;
        uint _521 = 1u + _520;
        int _523 = _global_2[_521];
        uint _524 = _515 * 3;
        uint _525 = 2u + _524;
        int _527 = _global_2[_525];
        int _528 = _global_2[_505];
        int _529 = _global_2[_508];
        int _530 = _global_2[_511];
        int _531 = max(_528, _519);
        int _532 = max(_529, _523);
        int _533 = max(_530, _527);
        _global_2[_505] = _531;
        _global_2[_508] = _532;
        _global_2[_511] = _533;
      }
      GroupMemoryBarrierWithGroupSync();
      bool _535 = ((uint)(int)(SV_GroupIndex) < (uint)16);
      if (_535) {
        uint _537 = SV_GroupIndex + 16u;
        uint _538 = _537 * 3;
        uint _539 = 0u + _538;
        int _541 = _global_2[_539];
        uint _542 = _537 * 3;
        uint _543 = 1u + _542;
        int _545 = _global_2[_543];
        uint _546 = _537 * 3;
        uint _547 = 2u + _546;
        int _549 = _global_2[_547];
        int _550 = _global_2[_505];
        int _551 = _global_2[_508];
        int _552 = _global_2[_511];
        int _553 = max(_550, _541);
        int _554 = max(_551, _545);
        int _555 = max(_552, _549);
        _global_2[_505] = _553;
        _global_2[_508] = _554;
        _global_2[_511] = _555;
      }
      GroupMemoryBarrierWithGroupSync();
      bool _557 = ((uint)(int)(SV_GroupIndex) < (uint)8);
      if (_557) {
        uint _559 = SV_GroupIndex + 8u;
        uint _560 = _559 * 3;
        uint _561 = 0u + _560;
        int _563 = _global_2[_561];
        uint _564 = _559 * 3;
        uint _565 = 1u + _564;
        int _567 = _global_2[_565];
        uint _568 = _559 * 3;
        uint _569 = 2u + _568;
        int _571 = _global_2[_569];
        int _572 = _global_2[_505];
        int _573 = _global_2[_508];
        int _574 = _global_2[_511];
        int _575 = max(_572, _563);
        int _576 = max(_573, _567);
        int _577 = max(_574, _571);
        _global_2[_505] = _575;
        _global_2[_508] = _576;
        _global_2[_511] = _577;
      }
      GroupMemoryBarrierWithGroupSync();
      bool _579 = ((uint)(int)(SV_GroupIndex) < (uint)4);
      if (_579) {
        uint _581 = SV_GroupIndex + 4u;
        uint _582 = _581 * 3;
        uint _583 = 0u + _582;
        int _585 = _global_2[_583];
        uint _586 = _581 * 3;
        uint _587 = 1u + _586;
        int _589 = _global_2[_587];
        uint _590 = _581 * 3;
        uint _591 = 2u + _590;
        int _593 = _global_2[_591];
        int _594 = _global_2[_505];
        int _595 = _global_2[_508];
        int _596 = _global_2[_511];
        int _597 = max(_594, _585);
        int _598 = max(_595, _589);
        int _599 = max(_596, _593);
        _global_2[_505] = _597;
        _global_2[_508] = _598;
        _global_2[_511] = _599;
      }
      GroupMemoryBarrierWithGroupSync();
      bool _601 = ((uint)(int)(SV_GroupIndex) < (uint)2);
      if (_601) {
        uint _603 = SV_GroupIndex + 2u;
        uint _604 = _603 * 3;
        uint _605 = 0u + _604;
        int _607 = _global_2[_605];
        uint _608 = _603 * 3;
        uint _609 = 1u + _608;
        int _611 = _global_2[_609];
        uint _612 = _603 * 3;
        uint _613 = 2u + _612;
        int _615 = _global_2[_613];
        int _616 = _global_2[_505];
        int _617 = _global_2[_508];
        int _618 = _global_2[_511];
        int _619 = max(_616, _607);
        int _620 = max(_617, _611);
        int _621 = max(_618, _615);
        _global_2[_505] = _619;
        _global_2[_508] = _620;
        _global_2[_511] = _621;
      }
      GroupMemoryBarrierWithGroupSync();
      bool _623 = ((int)(SV_GroupIndex) == 0);
      if (_623) {
        int _625 = _global_2[3];
        int _626 = _global_2[4];
        int _627 = _global_2[5];
        int _628 = _global_2[0];
        int _629 = _global_2[1];
        int _630 = _global_2[2];
        int _631 = max(_628, _625);
        int _632 = max(_629, _626);
        int _633 = max(_630, _627);
        _global_2[0] = _631;
        _global_2[1] = _632;
        _global_2[2] = _633;
        _635 = _623;
      } else {
        _635 = false;
      }
      GroupMemoryBarrierWithGroupSync();
      if (_635) {
        int _637 = _global_2[0];
        int _638 = _global_2[1];
        int _639 = _global_2[2];
        float _640 = float((uint)_637);
        float _641 = 1.0f / _640;
        _643 = 0;
        _644 = 0.0f;
        while(true) {
          int _647 = __3__37__0__0__g_histogramR[_643];
          float _648 = float((uint)_647);
          float _649 = _648 * _641;
          float _650 = _649 + _644;
          int _651 = _643 + 1;
          bool _652 = (_651 == 256);
          if (!_652) {
            _643 = _651;
            _644 = _650;
            continue;
          }
          float _654 = _650 * _param1.x;
          float _655 = _650 * _param1.y;
          _657 = 0;
          _658 = 0.0f;
          _659 = 0.0f;
          _660 = _654;
          _661 = _655;
          while(true) {
            float _662 = float((uint)_657);
            float _663 = _662 * 0.00390625f;
            float _664 = _663 - _param0.y;
            float _665 = _664 / _param0.x;
            float _666 = exp2(_665);
            int _669 = __3__37__0__0__g_histogramR[_657];
            float _670 = float((uint)_669);
            float _671 = _670 * _641;
            float _672 = min(_660, _671);
            float _673 = _671 - _672;
            float _674 = _660 - _672;
            float _675 = _661 - _672;
            float _676 = min(_675, _673);
            float _677 = _675 - _676;
            float _678 = _676 * _666;
            float _679 = _678 + _658;
            float _680 = _676 + _659;
            int _681 = _657 + 1;
            bool _682 = (_681 == 256);
            if (!_682) {
              _657 = _681;
              _658 = _679;
              _659 = _680;
              _660 = _674;
              _661 = _677;
              continue;
            }
            float _684 = max(_680, 9.999999747378752e-05f);
            float _685 = _679 / _684;
            float _686 = max(_685, _param1.z);
            float _687 = float((uint)_638);
            float _688 = 1.0f / _687;
            _690 = 0;
            _691 = 0.0f;
            while(true) {
              int _694 = __3__37__0__0__g_histogramG[_690];
              float _695 = float((uint)_694);
              float _696 = _695 * _688;
              float _697 = _696 + _691;
              int _698 = _690 + 1;
              bool _699 = (_698 == 256);
              if (!_699) {
                _690 = _698;
                _691 = _697;
                continue;
              }
              float _701 = min(_686, _param1.w);
              float _702 = _697 * _param1.x;
              float _703 = _697 * _param1.y;
              _705 = 0;
              _706 = 0.0f;
              _707 = 0.0f;
              _708 = _702;
              _709 = _703;
              while(true) {
                float _710 = float((uint)_705);
                float _711 = _710 * 0.00390625f;
                float _712 = _711 - _param0.y;
                float _713 = _712 / _param0.x;
                float _714 = exp2(_713);
                int _717 = __3__37__0__0__g_histogramG[_705];
                float _718 = float((uint)_717);
                float _719 = _718 * _688;
                float _720 = min(_708, _719);
                float _721 = _719 - _720;
                float _722 = _708 - _720;
                float _723 = _709 - _720;
                float _724 = min(_723, _721);
                float _725 = _723 - _724;
                float _726 = _724 * _714;
                float _727 = _726 + _706;
                float _728 = _724 + _707;
                int _729 = _705 + 1;
                bool _730 = (_729 == 256);
                if (!_730) {
                  _705 = _729;
                  _706 = _727;
                  _707 = _728;
                  _708 = _722;
                  _709 = _725;
                  continue;
                }
                float _732 = max(_728, 9.999999747378752e-05f);
                float _733 = _727 / _732;
                float _734 = max(_733, _param1.z);
                float _735 = float((uint)_639);
                float _736 = 1.0f / _735;
                _738 = 0;
                _739 = 0.0f;
                while(true) {
                  int _742 = __3__37__0__0__g_histogramB[_738];
                  float _743 = float((uint)_742);
                  float _744 = _743 * _736;
                  float _745 = _744 + _739;
                  int _746 = _738 + 1;
                  bool _747 = (_746 == 256);
                  if (!_747) {
                    _738 = _746;
                    _739 = _745;
                    continue;
                  }
                  float _749 = min(_734, _param1.w);
                  float _750 = _745 * _param1.x;
                  float _751 = _745 * _param1.y;
                  _753 = 0;
                  _754 = 0.0f;
                  _755 = 0.0f;
                  _756 = _750;
                  _757 = _751;
                  while(true) {
                    float _758 = float((uint)_753);
                    float _759 = _758 * 0.00390625f;
                    float _760 = _759 - _param0.y;
                    float _761 = _760 / _param0.x;
                    float _762 = exp2(_761);
                    int _765 = __3__37__0__0__g_histogramB[_753];
                    float _766 = float((uint)_765);
                    float _767 = _766 * _736;
                    float _768 = min(_756, _767);
                    float _769 = _767 - _768;
                    float _770 = _756 - _768;
                    float _771 = _757 - _768;
                    float _772 = min(_771, _769);
                    float _773 = _771 - _772;
                    float _774 = _772 * _762;
                    float _775 = _774 + _754;
                    float _776 = _772 + _755;
                    int _777 = _753 + 1;
                    bool _778 = (_777 == 256);
                    if (!_778) {
                      _753 = _777;
                      _754 = _775;
                      _755 = _776;
                      _756 = _770;
                      _757 = _773;
                      continue;
                    }
                    float _780 = max(_776, 9.999999747378752e-05f);
                    float _781 = _775 / _780;
                    float _782 = max(_781, _param1.z);
                    float _783 = min(_782, _param1.w);
                    float _784 = abs(_783);
                    float _785 = abs(_749);
                    float _786 = abs(_701);
                    float _787 = max(_786, _785);
                    float _788 = max(_787, _784);
                    float _789 = max(0.0010000000474974513f, _788);
                    float _790 = _701 / _789;
                    float _791 = _749 / _789;
                    float _792 = _783 / _789;
                    float _793 = dot(float3(_790, _791, _792), float3(2.0f, 0.0f, -2.0f));
                    float _794 = dot(float3(_790, _791, _792), float3(-1.0f, 2.0f, -1.0f));
                    float _795 = _793 * 0.25f;
                    float _796 = _794 * 0.25f;
                    float _797 = _795 + 1.0f;
                    float _798 = _797 - _796;
                    float _799 = _796 + 1.0f;
                    float _800 = 1.0f - _795;
                    float _801 = _800 - _796;
                    float _802 = log2(_798);
                    float _803 = log2(_799);
                    float _804 = log2(_801);
                    float _805 = _802 * 0.4166666567325592f;
                    float _806 = _803 * 0.4166666567325592f;
                    float _807 = _804 * 0.4166666567325592f;
                    float _808 = exp2(_805);
                    float _809 = exp2(_806);
                    float _810 = exp2(_807);
                    float _811 = _808 * 1.0549999475479126f;
                    float _812 = _809 * 1.0549999475479126f;
                    float _813 = _810 * 1.0549999475479126f;
                    float _814 = _811 + -0.054999999701976776f;
                    float _815 = _812 + -0.054999999701976776f;
                    float _816 = _813 + -0.054999999701976776f;
                    float _817 = _798 * 12.920000076293945f;
                    float _818 = _794 * 3.2300000190734863f;
                    float _819 = _818 + 12.920000076293945f;
                    float _820 = _801 * 12.920000076293945f;
                    bool _821 = (_798 <= 0.0031308000907301903f);
                    bool _822 = (_799 <= 0.0031308000907301903f);
                    bool _823 = (_801 <= 0.0031308000907301903f);
                    float _824 = select(_821, _817, _814);
                    float _825 = select(_822, _819, _815);
                    float _826 = select(_823, _820, _816);
                    float _827 = _824 * 0.6499260067939758f;
                    float _828 = _825 * 0.10345499962568283f;
                    float _829 = _828 + _827;
                    float _830 = _826 * 0.19710899889469147f;
                    float _831 = _829 + _830;
                    float _832 = _824 * 0.23432700335979462f;
                    float _833 = _825 * 0.7430750131607056f;
                    float _834 = _833 + _832;
                    float _835 = _826 * 0.02259800024330616f;
                    float _836 = _834 + _835;
                    float _837 = _825 * 0.05307700112462044f;
                    float _838 = _826 * 1.0357630252838135f;
                    float _839 = _838 + _837;
                    float _840 = _839 + _836;
                    float _841 = _840 + _831;
                    float _842 = _831 / _841;
                    float _843 = _836 / _841;
                    float _844 = _842 + -0.33660000562667847f;
                    float _845 = _843 + -0.17350000143051147f;
                    float _846 = _844 / _845;
                    float _847 = _846 * -1.5654412508010864f;
                    float _848 = exp2(_847);
                    float _849 = _848 * 6253.80322265625f;
                    float _850 = _849 + -949.8631591796875f;
                    float _851 = _846 * -7.199436664581299f;
                    float _852 = exp2(_851);
                    float _853 = _852 * 28.705989837646484f;
                    float _854 = _850 + _853;
                    float _855 = _846 * -20.248350143432617f;
                    float _856 = exp2(_855);
                    float _857 = _856 * 3.9999998989515007e-05f;
                    float _858 = _854 + _857;
                    bool _859 = (_858 < 5000.0f);
                    bool _860 = (_858 > 6500.0f);
                    bool _861 = (_859) | (_860);
                    if (_861) {
                      float _863 = max(_858, 5000.0f);
                      float _864 = min(_863, 6500.0f);
                      float _865 = max(_864, 1000.0f);
                      float _866 = min(_865, 40000.0f);
                      float _867 = _866 * 0.009999999776482582f;
                      bool _868 = !(_867 <= 66.0f);
                      if (!_868) {
                        float _870 = log2(_867);
                        float _871 = _870 * 0.27038395404815674f;
                        float _872 = _871 + -0.6318414211273193f;
                        _884 = _872;
                        _885 = 1.0f;
                      } else {
                        float _874 = _867 + -60.0f;
                        float _875 = log2(_874);
                        float _876 = _875 * -0.13320475816726685f;
                        float _877 = exp2(_876);
                        float _878 = _877 * 1.2929362058639526f;
                        float _879 = saturate(_878);
                        float _880 = _875 * -0.07551484555006027f;
                        float _881 = exp2(_880);
                        float _882 = _881 * 1.1298909187316895f;
                        _884 = _882;
                        _885 = _879;
                      }
                      float _886 = saturate(_884);
                      bool _887 = !(_867 >= 66.0f);
                      if (_887) {
                        bool _889 = !(_867 <= 19.0f);
                        if (_889) {
                          float _891 = _867 + -10.0f;
                          float _892 = log2(_891);
                          float _893 = _892 * 0.3765222728252411f;
                          float _894 = _893 + -1.1962541341781616f;
                          float _895 = saturate(_894);
                          _897 = _895;
                        } else {
                          _897 = 0.0f;
                        }
                      } else {
                        _897 = 1.0f;
                      }
                      float _898 = _885 + 0.054999999701976776f;
                      float _899 = _886 + 0.054999999701976776f;
                      float _900 = _897 + 0.054999999701976776f;
                      float _901 = _898 * 0.9478673338890076f;
                      float _902 = _899 * 0.9478673338890076f;
                      float _903 = _900 * 0.9478673338890076f;
                      float _904 = log2(_901);
                      float _905 = log2(_902);
                      float _906 = log2(_903);
                      float _907 = _904 * 2.4000000953674316f;
                      float _908 = _905 * 2.4000000953674316f;
                      float _909 = _906 * 2.4000000953674316f;
                      float _910 = exp2(_907);
                      float _911 = exp2(_908);
                      float _912 = exp2(_909);
                      float _913 = _885 * 0.07739938050508499f;
                      float _914 = _886 * 0.07739938050508499f;
                      float _915 = _897 * 0.07739938050508499f;
                      bool _916 = (_885 < 0.040449999272823334f);
                      bool _917 = (_886 < 0.040449999272823334f);
                      bool _918 = (_897 < 0.040449999272823334f);
                      float _919 = select(_916, _913, _910);
                      float _920 = select(_917, _914, _911);
                      float _921 = select(_918, _915, _912);
                      _923 = _919;
                      _924 = _920;
                      _925 = _921;
                      _926 = _864;
                    } else {
                      _923 = _798;
                      _924 = _799;
                      _925 = _801;
                      _926 = _858;
                    }
                    float _929 = _temporalReprojectionParams.w + 0.10000000149011612f;
                    float _930 = saturate(_929);
                    float _933 = __3__39__0__1__g_autoWhiteBalanceColorUAV[0].x;
                    float _934 = __3__39__0__1__g_autoWhiteBalanceColorUAV[0].y;
                    float _935 = __3__39__0__1__g_autoWhiteBalanceColorUAV[0].z;
                    float _936 = __3__39__0__1__g_autoWhiteBalanceColorUAV[0].w;
                    float _937 = _923 - _933;
                    float _938 = _924 - _934;
                    float _939 = _925 - _935;
                    float _940 = 1.0f - _936;
                    float _941 = _937 * _930;
                    float _942 = _938 * _930;
                    float _943 = _939 * _930;
                    float _944 = _940 * _930;
                    float _945 = _941 + _933;
                    float _946 = _942 + _934;
                    float _947 = _943 + _935;
                    float _948 = _944 + _936;
                    __3__39__0__1__g_autoWhiteBalanceColorUAV[0].x = _945; __3__39__0__1__g_autoWhiteBalanceColorUAV[0].y = _946; __3__39__0__1__g_autoWhiteBalanceColorUAV[0].z = _947; __3__39__0__1__g_autoWhiteBalanceColorUAV[0].w = _948;
                    _950 = 0.0f;
                    _951 = 0.0f;
                    _952 = 0;
                    while(true) {
                      int _955 = __3__37__0__0__g_histogramR[_952];
                      float _956 = float((uint)_955);
                      float _957 = _956 * _641;
                      float _958 = float((uint)_952);
                      float _959 = _958 * 0.00390625f;
                      float _960 = _959 - _param0.y;
                      float _961 = _960 / _param0.x;
                      float _962 = exp2(_961);
                      float _963 = _957 * _962;
                      float _964 = _963 + _950;
                      float _965 = _957 + _951;
                      int _966 = _952 + 1;
                      bool _967 = (_966 == 256);
                      if (!_967) {
                        _950 = _964;
                        _951 = _965;
                        _952 = _966;
                        continue;
                      }
                      float _969 = max(_965, 9.999999747378752e-05f);
                      float _970 = _964 / _969;
                      _972 = 0.0f;
                      _973 = 0.0f;
                      _974 = 0;
                      while(true) {
                        int _977 = __3__37__0__0__g_histogramG[_974];
                        float _978 = float((uint)_977);
                        float _979 = _978 * _688;
                        float _980 = float((uint)_974);
                        float _981 = _980 * 0.00390625f;
                        float _982 = _981 - _param0.y;
                        float _983 = _982 / _param0.x;
                        float _984 = exp2(_983);
                        float _985 = _979 * _984;
                        float _986 = _985 + _972;
                        float _987 = _979 + _973;
                        int _988 = _974 + 1;
                        bool _989 = (_988 == 256);
                        if (!_989) {
                          _972 = _986;
                          _973 = _987;
                          _974 = _988;
                          continue;
                        }
                        float _991 = max(_987, 9.999999747378752e-05f);
                        float _992 = _986 / _991;
                        _994 = 0.0f;
                        _995 = 0.0f;
                        _996 = 0;
                        while(true) {
                          int _999 = __3__37__0__0__g_histogramB[_996];
                          float _1000 = float((uint)_999);
                          float _1001 = _1000 * _736;
                          float _1002 = float((uint)_996);
                          float _1003 = _1002 * 0.00390625f;
                          float _1004 = _1003 - _param0.y;
                          float _1005 = _1004 / _param0.x;
                          float _1006 = exp2(_1005);
                          float _1007 = _1001 * _1006;
                          float _1008 = _1007 + _994;
                          float _1009 = _1001 + _995;
                          int _1010 = _996 + 1;
                          bool _1011 = (_1010 == 256);
                          if (!_1011) {
                            _994 = _1008;
                            _995 = _1009;
                            _996 = _1010;
                            continue;
                          }
                          float _1013 = max(_1009, 9.999999747378752e-05f);
                          float _1014 = _1008 / _1013;
                          float _1015 = max(_970, _992);
                          float _1016 = max(_1015, _1014);
                          float _1017 = _970 / _1016;
                          float _1018 = _992 / _1016;
                          float _1019 = _1014 / _1016;
                          float _1020 = saturate(_1017);
                          float _1021 = saturate(_1018);
                          float _1022 = saturate(_1019);
                          float _1023 = log2(_1020);
                          float _1024 = log2(_1021);
                          float _1025 = log2(_1022);
                          float _1026 = _1023 * 0.4166666567325592f;
                          float _1027 = _1024 * 0.4166666567325592f;
                          float _1028 = _1025 * 0.4166666567325592f;
                          float _1029 = exp2(_1026);
                          float _1030 = exp2(_1027);
                          float _1031 = exp2(_1028);
                          float _1032 = _1029 * 1.0549999475479126f;
                          float _1033 = _1030 * 1.0549999475479126f;
                          float _1034 = _1031 * 1.0549999475479126f;
                          float _1035 = _1032 + -0.054999999701976776f;
                          float _1036 = _1033 + -0.054999999701976776f;
                          float _1037 = _1034 + -0.054999999701976776f;
                          float _1038 = _1020 * 12.920000076293945f;
                          float _1039 = _1021 * 12.920000076293945f;
                          float _1040 = _1022 * 12.920000076293945f;
                          bool _1041 = (_1020 <= 0.0031308000907301903f);
                          bool _1042 = (_1021 <= 0.0031308000907301903f);
                          bool _1043 = (_1022 <= 0.0031308000907301903f);
                          float _1044 = select(_1041, _1038, _1035);
                          float _1045 = select(_1042, _1039, _1036);
                          float _1046 = select(_1043, _1040, _1037);
                          float _1047 = saturate(_1044);
                          float _1048 = saturate(_1045);
                          float _1049 = saturate(_1046);
                          float _1050 = _1047 * 255.0f;
                          float _1051 = _1048 * 255.0f;
                          float _1052 = _1049 * 255.0f;
                          uint _1053 = uint(_1050);
                          uint _1054 = uint(_1051);
                          uint _1055 = uint(_1052);
                          uint _1056 = _1053 << 16;
                          uint _1057 = _1054 << 8;
                          int _1058 = _1057 & 65280;
                          int _1059 = _1055 & 255;
                          int _1060 = _1056 | _1058;
                          int _1061 = _1060 | _1059;
                          int _1062 = _1061 | -16777216;
                          float _1063 = asfloat(_1062);
                          __3__39__0__1__g_exposureUAV[6] = _1063;
                          __3__39__0__1__g_exposureUAV[7] = _926;
                          break;
                        }
                        if (__loop_jump_target == 971) {
                          __loop_jump_target = -1;
                          continue;
                        }
                        if (__loop_jump_target != -1) {
                          break;
                        }
                        break;
                      }
                      if (__loop_jump_target == 949) {
                        __loop_jump_target = -1;
                        continue;
                      }
                      if (__loop_jump_target != -1) {
                        break;
                      }
                      break;
                    }
                    if (__loop_jump_target == 752) {
                      __loop_jump_target = -1;
                      continue;
                    }
                    if (__loop_jump_target != -1) {
                      break;
                    }
                    break;
                  }
                  if (__loop_jump_target == 737) {
                    __loop_jump_target = -1;
                    continue;
                  }
                  if (__loop_jump_target != -1) {
                    break;
                  }
                  break;
                }
                if (__loop_jump_target == 704) {
                  __loop_jump_target = -1;
                  continue;
                }
                if (__loop_jump_target != -1) {
                  break;
                }
                break;
              }
              if (__loop_jump_target == 689) {
                __loop_jump_target = -1;
                continue;
              }
              if (__loop_jump_target != -1) {
                break;
              }
              break;
            }
            if (__loop_jump_target == 656) {
              __loop_jump_target = -1;
              continue;
            }
            if (__loop_jump_target != -1) {
              break;
            }
            break;
          }
          if (__loop_jump_target == 642) {
            __loop_jump_target = -1;
            continue;
          }
          if (__loop_jump_target != -1) {
            break;
          }
          break;
        }
      }
    }
  }
}
