Texture2D<float4> __3__36__0__0__g_texSkyInscatter : register(t34, space36);

Texture2D<float4> __3__36__0__0__g_texSkyExtinction : register(t35, space36);

Texture2D<float> __3__36__0__0__g_depthHalf : register(t26, space36);

Texture2D<float> __3__36__0__0__g_depthHalfHistory : register(t27, space36);

Texture2D<float4> __3__36__0__0__g_texSkyInscatterHistory : register(t30, space36);

Texture2D<float4> __3__36__0__0__g_texSkyExtinctionHistory : register(t31, space36);

cbuffer __3__35__0__0__SceneConstantBuffer : register(b3, space35) {
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

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

static const int _global_0[4] = { 0, 1, 3, 2 };

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float3 TEXCOORD_1 : TEXCOORD1
) {
  float4 SV_Target;
  float4 SV_Target_1;
  int __loop_jump_target = -1;
  int _17 = int(SV_Position.x * 0.5f);
  int _18 = int(SV_Position.y * 0.5f);
  float4 _20 = __3__36__0__0__g_texSkyInscatter.Load(int3(_17, _18, 0));
  float4 _25 = __3__36__0__0__g_texSkyExtinction.Load(int3(_17, _18, 0));
  int _31 = (int)(uint)((int)(dot(float3(_25.x, _25.y, _25.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) < 0.009999999776482582f));
  int _37 = _global_0[(((int)(((uint)(int4(_frameNumber).x)) + _17)) & 3)];
  int _42 = int(fmod(SV_Position.x, 2.0f));
  int _43 = int(fmod(SV_Position.y, 2.0f));
  float _49 = __3__36__0__0__g_depthHalf.Load(int3(((int)(_42 + (_17 << 1))), ((int)(_43 + (_18 << 1))), 0));
  float _54 = _nearFarProj.x / max(1.0000000116860974e-07f, _49.x);
  bool _55 = (_49.x < 1.0000000116860974e-07f);
  int _56 = (int)(uint)(_55);
  int _57 = _56 ^ 1;
  float _59 = (TEXCOORD.x * 2.0f) + -1.0f;
  float _61 = 1.0f - (TEXCOORD.y * 2.0f);
  float _63 = max(1.0000000116860974e-07f, select(_55, 1.0f, _49.x));
  float _99 = mad((float4(_invViewProjRelativeNoJitter[0].z, _invViewProjRelativeNoJitter[1].z, _invViewProjRelativeNoJitter[2].z, _invViewProjRelativeNoJitter[3].z).w), _63, mad((float4(_invViewProjRelativeNoJitter[0].y, _invViewProjRelativeNoJitter[1].y, _invViewProjRelativeNoJitter[2].y, _invViewProjRelativeNoJitter[3].y).w), _61, ((float4(_invViewProjRelativeNoJitter[0].x, _invViewProjRelativeNoJitter[1].x, _invViewProjRelativeNoJitter[2].x, _invViewProjRelativeNoJitter[3].x).w) * _59))) + (float4(_invViewProjRelativeNoJitter[0].w, _invViewProjRelativeNoJitter[1].w, _invViewProjRelativeNoJitter[2].w, _invViewProjRelativeNoJitter[3].w).w);
  float _100 = (mad((float4(_invViewProjRelativeNoJitter[0].z, _invViewProjRelativeNoJitter[1].z, _invViewProjRelativeNoJitter[2].z, _invViewProjRelativeNoJitter[3].z).x), _63, mad((float4(_invViewProjRelativeNoJitter[0].y, _invViewProjRelativeNoJitter[1].y, _invViewProjRelativeNoJitter[2].y, _invViewProjRelativeNoJitter[3].y).x), _61, ((float4(_invViewProjRelativeNoJitter[0].x, _invViewProjRelativeNoJitter[1].x, _invViewProjRelativeNoJitter[2].x, _invViewProjRelativeNoJitter[3].x).x) * _59))) + (float4(_invViewProjRelativeNoJitter[0].w, _invViewProjRelativeNoJitter[1].w, _invViewProjRelativeNoJitter[2].w, _invViewProjRelativeNoJitter[3].w).x)) / _99;
  float _101 = (mad((float4(_invViewProjRelativeNoJitter[0].z, _invViewProjRelativeNoJitter[1].z, _invViewProjRelativeNoJitter[2].z, _invViewProjRelativeNoJitter[3].z).y), _63, mad((float4(_invViewProjRelativeNoJitter[0].y, _invViewProjRelativeNoJitter[1].y, _invViewProjRelativeNoJitter[2].y, _invViewProjRelativeNoJitter[3].y).y), _61, ((float4(_invViewProjRelativeNoJitter[0].x, _invViewProjRelativeNoJitter[1].x, _invViewProjRelativeNoJitter[2].x, _invViewProjRelativeNoJitter[3].x).y) * _59))) + (float4(_invViewProjRelativeNoJitter[0].w, _invViewProjRelativeNoJitter[1].w, _invViewProjRelativeNoJitter[2].w, _invViewProjRelativeNoJitter[3].w).y)) / _99;
  float _102 = (mad((float4(_invViewProjRelativeNoJitter[0].z, _invViewProjRelativeNoJitter[1].z, _invViewProjRelativeNoJitter[2].z, _invViewProjRelativeNoJitter[3].z).z), _63, mad((float4(_invViewProjRelativeNoJitter[0].y, _invViewProjRelativeNoJitter[1].y, _invViewProjRelativeNoJitter[2].y, _invViewProjRelativeNoJitter[3].y).z), _61, ((float4(_invViewProjRelativeNoJitter[0].x, _invViewProjRelativeNoJitter[1].x, _invViewProjRelativeNoJitter[2].x, _invViewProjRelativeNoJitter[3].x).z) * _59))) + (float4(_invViewProjRelativeNoJitter[0].w, _invViewProjRelativeNoJitter[1].w, _invViewProjRelativeNoJitter[2].w, _invViewProjRelativeNoJitter[3].w).z)) / _99;
  float _130 = mad((float4(_viewProjRelativeNoJitterPrev[0].z, _viewProjRelativeNoJitterPrev[1].z, _viewProjRelativeNoJitterPrev[2].z, _viewProjRelativeNoJitterPrev[3].z).w), _102, mad((float4(_viewProjRelativeNoJitterPrev[0].y, _viewProjRelativeNoJitterPrev[1].y, _viewProjRelativeNoJitterPrev[2].y, _viewProjRelativeNoJitterPrev[3].y).w), _101, ((float4(_viewProjRelativeNoJitterPrev[0].x, _viewProjRelativeNoJitterPrev[1].x, _viewProjRelativeNoJitterPrev[2].x, _viewProjRelativeNoJitterPrev[3].x).w) * _100))) + (float4(_viewProjRelativeNoJitterPrev[0].w, _viewProjRelativeNoJitterPrev[1].w, _viewProjRelativeNoJitterPrev[2].w, _viewProjRelativeNoJitterPrev[3].w).w);
  float _135 = (((mad((float4(_viewProjRelativeNoJitterPrev[0].z, _viewProjRelativeNoJitterPrev[1].z, _viewProjRelativeNoJitterPrev[2].z, _viewProjRelativeNoJitterPrev[3].z).x), _102, mad((float4(_viewProjRelativeNoJitterPrev[0].y, _viewProjRelativeNoJitterPrev[1].y, _viewProjRelativeNoJitterPrev[2].y, _viewProjRelativeNoJitterPrev[3].y).x), _101, ((float4(_viewProjRelativeNoJitterPrev[0].x, _viewProjRelativeNoJitterPrev[1].x, _viewProjRelativeNoJitterPrev[2].x, _viewProjRelativeNoJitterPrev[3].x).x) * _100))) + (float4(_viewProjRelativeNoJitterPrev[0].w, _viewProjRelativeNoJitterPrev[1].w, _viewProjRelativeNoJitterPrev[2].w, _viewProjRelativeNoJitterPrev[3].w).x)) / _130) * 0.5f) + 0.5f;
  float _136 = 0.5f - (((mad((float4(_viewProjRelativeNoJitterPrev[0].z, _viewProjRelativeNoJitterPrev[1].z, _viewProjRelativeNoJitterPrev[2].z, _viewProjRelativeNoJitterPrev[3].z).y), _102, mad((float4(_viewProjRelativeNoJitterPrev[0].y, _viewProjRelativeNoJitterPrev[1].y, _viewProjRelativeNoJitterPrev[2].y, _viewProjRelativeNoJitterPrev[3].y).y), _101, ((float4(_viewProjRelativeNoJitterPrev[0].x, _viewProjRelativeNoJitterPrev[1].x, _viewProjRelativeNoJitterPrev[2].x, _viewProjRelativeNoJitterPrev[3].x).y) * _100))) + (float4(_viewProjRelativeNoJitterPrev[0].w, _viewProjRelativeNoJitterPrev[1].w, _viewProjRelativeNoJitterPrev[2].w, _viewProjRelativeNoJitterPrev[3].w).y)) / _130) * 0.5f);
  int _147;
  int _148;
  int _149;
  float _150;
  float _151;
  float _152;
  float _153;
  float _154;
  float _155;
  float _156;
  float _157;
  float _158;
  float _159;
  float _160;
  float _161;
  float _162;
  int _163;
  int _164;
  int _165;
  int _166;
  int _171;
  int _172;
  int _173;
  float _174;
  float _175;
  float _176;
  float _177;
  float _178;
  float _179;
  float _180;
  float _181;
  float _182;
  float _183;
  float _184;
  float _185;
  float _186;
  int _187;
  int _188;
  int _189;
  int _190;
  float _278;
  float _279;
  float _280;
  float _281;
  float _282;
  float _283;
  float _284;
  float _285;
  float _286;
  float _287;
  float _288;
  float _289;
  float _290;
  int _291;
  int _292;
  int _293;
  int _298;
  int _299;
  int _300;
  float _301;
  float _302;
  float _303;
  float _304;
  float _305;
  float _306;
  float _307;
  float _308;
  float _309;
  float _310;
  float _311;
  float _312;
  int _313;
  int _314;
  int _315;
  float _325;
  float _385;
  float _386;
  float _387;
  float _388;
  float _389;
  float _390;
  float _406;
  float _407;
  float _408;
  float _409;
  float _410;
  float _411;
  float _435;
  float _436;
  float _437;
  float _438;
  float _439;
  float _440;
  bool __defer_0_145 = false;
  if ((_55) || (sqrt(((_101 * _101) + (_100 * _100)) + (_102 * _102)) > 128.0f)) {
    __defer_0_145 = true;
  } else {
    _298 = _31;
    _299 = _56;
    _300 = _57;
    _301 = _20.x;
    _302 = _20.y;
    _303 = _20.z;
    _304 = _20.x;
    _305 = _20.y;
    _306 = _20.z;
    _307 = _25.x;
    _308 = _25.y;
    _309 = _25.z;
    _310 = _25.x;
    _311 = _25.y;
    _312 = _25.z;
    _313 = _17;
    _314 = _18;
    _315 = 0;
  }
  if (__defer_0_145) {
    _147 = _31;
    _148 = _56;
    _149 = _57;
    _150 = _20.x;
    _151 = _20.y;
    _152 = _20.z;
    _153 = _20.x;
    _154 = _20.y;
    _155 = _20.z;
    _156 = _25.x;
    _157 = _25.y;
    _158 = _25.z;
    _159 = _25.x;
    _160 = _25.y;
    _161 = _25.z;
    _162 = _54;
    _163 = _17;
    _164 = _18;
    _165 = 0;
    _166 = -1;
    while(true) {
      _171 = _147;
      _172 = _148;
      _173 = _149;
      _174 = _150;
      _175 = _151;
      _176 = _152;
      _177 = _153;
      _178 = _154;
      _179 = _155;
      _180 = _156;
      _181 = _157;
      _182 = _158;
      _183 = _159;
      _184 = _160;
      _185 = _161;
      _186 = _162;
      _187 = _163;
      _188 = _164;
      _189 = _165;
      _190 = -1;
      while(true) {
        int _206 = min(max(((int)(_190 + _17)), 0), ((int(_bufferSizeAndInvSize.x + 0.5f) / 4) + -1));
        int _207 = min(max(((int)(_166 + _18)), 0), ((int(_bufferSizeAndInvSize.y + 0.5f) / 4) + -1));
        int _213 = _global_0[(((int)(((uint)(int4(_frameNumber).x)) + _206)) & 3)];
        float _221 = __3__36__0__0__g_depthHalf.Load(int3(((int)(((uint)(_213 % 2)) + (_206 << 1))), ((int)(((uint)(_213 / 2)) + (_207 << 1))), 0));
        float _226 = _nearFarProj.x / max(1.0000000116860974e-07f, _221.x);
        bool _227 = (_221.x < 1.0000000116860974e-07f);
        int _230 = (int)(uint)((int)(((int)(_172 != 0)) & (_227)));
        int _235 = (((int)(uint)(_227)) ^ 1) & ((int)(uint)((int)(_173 != 0)));
        float4 _237 = __3__36__0__0__g_texSkyExtinction.Load(int3(_206, _207, 0));
        bool _242 = (dot(float3(_237.x, _237.y, _237.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f)) < 0.009999999776482582f);
        bool _243 = (_171 != 0);
        int _245 = (int)(uint)((int)((_243) & (_242)));
        float _247 = max(_54, _226);
        float _250 = (_247 - min(_54, _226)) / max(9.999999974752427e-07f, _247);
        if (!(((int)(_250 > 0.10000000149011612f)) & (((int)(!((_243) & (_242))))))) {
          bool _256 = (_250 < _186);
          float4 _261 = __3__36__0__0__g_texSkyInscatter.Load(int3(_206, _207, 0));
          _278 = min(_174, _261.x);
          _279 = min(_175, _261.y);
          _280 = min(_176, _261.z);
          _281 = max(_177, _261.x);
          _282 = max(_178, _261.y);
          _283 = max(_179, _261.z);
          _284 = min(_180, _237.x);
          _285 = min(_181, _237.y);
          _286 = min(_182, _237.z);
          _287 = max(_183, _237.x);
          _288 = max(_184, _237.y);
          _289 = max(_185, _237.z);
          _290 = select(_256, _250, _186);
          _291 = select(_256, _206, _187);
          _292 = select(_256, _207, _188);
          _293 = 1;
        } else {
          _278 = _174;
          _279 = _175;
          _280 = _176;
          _281 = _177;
          _282 = _178;
          _283 = _179;
          _284 = _180;
          _285 = _181;
          _286 = _182;
          _287 = _183;
          _288 = _184;
          _289 = _185;
          _290 = _186;
          _291 = _187;
          _292 = _188;
          _293 = _189;
        }
        int _294 = _190 + 1;
        if (!(_294 == 2)) {
          _171 = _245;
          _172 = _230;
          _173 = _235;
          _174 = _278;
          _175 = _279;
          _176 = _280;
          _177 = _281;
          _178 = _282;
          _179 = _283;
          _180 = _284;
          _181 = _285;
          _182 = _286;
          _183 = _287;
          _184 = _288;
          _185 = _289;
          _186 = _290;
          _187 = _291;
          _188 = _292;
          _189 = _293;
          _190 = _294;
          continue;
        }
        int _168 = _166 + 1;
        if (!(_168 == 2)) {
          _147 = _245;
          _148 = _230;
          _149 = _235;
          _150 = _278;
          _151 = _279;
          _152 = _280;
          _153 = _281;
          _154 = _282;
          _155 = _283;
          _156 = _284;
          _157 = _285;
          _158 = _286;
          _159 = _287;
          _160 = _288;
          _161 = _289;
          _162 = _290;
          _163 = _291;
          _164 = _292;
          _165 = _293;
          _166 = _168;
          __loop_jump_target = 146;
          break;
        }
        _298 = _245;
        _299 = _230;
        _300 = _235;
        _301 = _278;
        _302 = _279;
        _303 = _280;
        _304 = _281;
        _305 = _282;
        _306 = _283;
        _307 = _284;
        _308 = _285;
        _309 = _286;
        _310 = _287;
        _311 = _288;
        _312 = _289;
        _313 = _291;
        _314 = _292;
        _315 = _293;
        break;
      }
      if (__loop_jump_target == 146) {
        __loop_jump_target = -1;
        continue;
      }
      if (__loop_jump_target != -1) {
        break;
      }
      break;
    }
  }
  bool _318 = (_temporalReprojectionParams.w > 0.5f);
  if (!_318) {
    float _322 = __3__36__0__0__g_depthHalfHistory.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_135, _136), 0.0f);
    _325 = _322.x;
  } else {
    _325 = _49.x;
  }
  float _329 = _nearFarProj.x / max(1.0000000116860974e-07f, _325);
  float _330 = min(_54, _329);
  float _331 = max(_54, _329);
  bool __defer_324_358 = false;
  if (!(_298 == 0) || ((_298 == 0) && (!(((int)(((_331 - _330) / _331) > ((max(0.0f, (_330 + -20000.0f)) * 9.999999747378752e-05f) + 0.10000000149011612f))) | (_318))))) {
    __defer_324_358 = true;
  } else {
    float4 _344 = __3__36__0__0__g_texSkyInscatter.Load(int3(_313, _314, 0));
    if (!(((int)(_315 == 0)) & (((int)(_55 ^ (_325 < 1.0000000116860974e-07f)))))) {
      float4 _354 = __3__36__0__0__g_texSkyExtinction.Load(int3(_313, _314, 0));
      _435 = _344.x;
      _436 = _344.y;
      _437 = _344.z;
      _438 = _354.x;
      _439 = _354.y;
      _440 = _354.z;
    } else {
      _435 = _344.x;
      _436 = _344.y;
      _437 = _344.z;
      _438 = 0.0f;
      _439 = 0.0f;
      _440 = 0.0f;
    }
  }
  if (__defer_324_358) {
    if (!(((_299 | _298) | _300) == 0)) {
      float4 _366 = __3__36__0__0__g_texSkyInscatterHistory.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_135, _136), 0.0f);
      float4 _370 = __3__36__0__0__g_texSkyExtinctionHistory.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_135, _136), 0.0f);
      _385 = _370.x;
      _386 = _370.y;
      _387 = _370.z;
      _388 = _366.x;
      _389 = _366.y;
      _390 = _366.z;
    } else {
      float4 _376 = __3__36__0__0__g_texSkyInscatterHistory.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_135, _136), 0.0f);
      float4 _380 = __3__36__0__0__g_texSkyExtinctionHistory.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_135, _136), 0.0f);
      _385 = _380.x;
      _386 = _380.y;
      _387 = _380.z;
      _388 = _376.x;
      _389 = _376.y;
      _390 = _376.z;
    }
    if (!(_315 == 0)) {
      _406 = min(max(_388, _301), _304);
      _407 = min(max(_389, _302), _305);
      _408 = min(max(_390, _303), _306);
      _409 = min(max(_385, _307), _310);
      _410 = min(max(_386, _308), _311);
      _411 = min(max(_387, _309), _312);
    } else {
      _406 = _388;
      _407 = _389;
      _408 = _390;
      _409 = _385;
      _410 = _386;
      _411 = _387;
    }
    float _415 = select((((int)((_37 % 2) != _42)) | ((int)((_37 / 2) != _43))), 1.0f, 0.800000011920929f);
    _435 = (lerp(_20.x, _406, _415));
    _436 = (lerp(_20.y, _407, _415));
    _437 = (lerp(_20.z, _408, _415));
    _438 = (lerp(_25.x, _409, _415));
    _439 = (lerp(_25.y, _410, _415));
    _440 = (lerp(_25.z, _411, _415));
  }
  SV_Target.x = _435;
  SV_Target.y = _436;
  SV_Target.z = _437;
  SV_Target.w = 1.0f;
  SV_Target_1.x = _438;
  SV_Target_1.y = _439;
  SV_Target_1.z = _440;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
