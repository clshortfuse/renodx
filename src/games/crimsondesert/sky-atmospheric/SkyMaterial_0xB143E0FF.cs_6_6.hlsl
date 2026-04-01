#include "../shared.h"

struct PostProcessSkyStruct {
  uint _moonTexture;
  uint _milkyWayTexture;
  float _milkyWayRatio;
  float _starRatio;
};


Texture2D<float4> __0__7__0__0__g_bindlessTextures[] : register(t0, space7);

Texture2D<float4> __3__36__0__0__g_texSkyInscatter : register(t4, space36);

Texture2D<float4> __3__36__0__0__g_texSkyExtinction : register(t5, space36);

Texture3D<float4> __3__36__0__0__g_texFroxel : register(t83, space36);

Texture2D<float> __3__36__0__0__g_depth : register(t16, space36);

Texture2D<float> __3__36__0__0__g_depthHalf : register(t19, space36);

Texture2D<uint2> __3__36__0__0__g_stencil : register(t20, space36);

Texture2D<uint> __3__36__0__0__g_tileData : register(t40, space36);

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

cbuffer __3__35__0__0__PrecomputedAmbientConstantBuffer : register(b26, space35) {
  float4 _precomputedAmbient0 : packoffset(c000.x);
  float4 _precomputedAmbient1 : packoffset(c001.x);
  float4 _precomputedAmbient2 : packoffset(c002.x);
  float4 _precomputedAmbient3 : packoffset(c003.x);
  float4 _precomputedAmbient4 : packoffset(c004.x);
  float4 _precomputedAmbient5 : packoffset(c005.x);
  float4 _precomputedAmbient6 : packoffset(c006.x);
  float4 _precomputedAmbient7 : packoffset(c007.x);
  float4 _precomputedAmbients[56] : packoffset(c008.x);
};

cbuffer __3__35__0__0__TileConstantBuffer : register(b27, space35) {
  uint4 g_tileIndex[4096] : packoffset(c000.x);
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
};

ConstantBuffer<PostProcessSkyStruct> BindlessParameters_PostProcessSky[] : register(b0, space100);

SamplerState __0__4__0__0__g_staticBilinearClamp : register(s3, space4);

SamplerState __0__4__0__0__g_staticPointClamp : register(s10, space4);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  int __loop_jump_target = -1;
  int _17[4];
  int _27 = (int)(SV_GroupID.x) & 15;
  int _28 = (uint)(_27) >> 2;
  int _29 = _28 << 2;
  int _30 = _27 - _29;
  int _31 = _30 << 3;
  int _32 = _28 << 3;
  int _33 = (uint)(SV_GroupID.x) >> 4;
  int _34 = (uint)(SV_GroupID.x) >> 6;
  int _35 = _33 & 3;
  _17[0] = ((float)((g_tileIndex[_34]).x));
  _17[1] = ((float)((g_tileIndex[_34]).y));
  _17[2] = ((float)((g_tileIndex[_34]).z));
  _17[3] = ((float)((g_tileIndex[_34]).w));
  int _46 = _17[_35];
  int _47 = (uint)(_46) >> 16;
  uint _48 = _46 << 5;
  int _49 = _48 & 2097120;
  int _50 = _47 << 5;
  uint _51 = _49 + SV_GroupThreadID.x;
  uint _52 = _51 + _31;
  uint _53 = _32 + SV_GroupThreadID.y;
  uint _54 = _53 + _50;
  int _55 = (uint)(_52) >> 5;
  int _56 = (uint)(_54) >> 5;
  uint _58 = __3__36__0__0__g_tileData.Load(int3(_55, _56, 0));
  int _60 = _58.x & 3;
  bool _61 = (_60 == 0);
  float _62 = float((uint)_52);
  float _63 = float((uint)_54);
  float _64 = _62 + 0.5f;
  float _65 = _63 + 0.5f;
  float _69 = _64 * _bufferSizeAndInvSize.z;
  float _70 = _65 * _bufferSizeAndInvSize.w;
  bool _77;
  float _385;
  float _400;
  float _401;
  float _402;
  float _431;
  float _432;
  float _433;
  float _434;
  float _587;
  float _588;
  float _589;
  int _670;
  float _671;
  float _672;
  float _673;
  int _674;
  int _675;
  int _676;
  int _724;
  float _725;
  float _726;
  float _727;
  float _728;
  float _777;
  float _778;
  float _797;
  float _798;
  float _799;
  float _800;
  float _801;
  float _802;
  float _803;
  [branch]
  if (!_61) {
    float _73 = __3__36__0__0__g_depth.Load(int3(_52, _54, 0));
    bool _75 = !(_73.x < 1.0000000116860974e-07f);
    _77 = _75;
  } else {
    _77 = false;
  }
  uint2 _79 = __3__36__0__0__g_stencil.Load(int3(_52, _54, 0));
  int _81 = _79.x & 127;
  bool _82 = (_81 != 10);
  bool _83 = (_77) & (_82);
  if (!_83) {
    float _87 = _69 * 2.0f;
    float _88 = _87 + -1.0f;
    float _89 = 1.0f - _70;
    float _90 = _89 * 2.0f;
    float _91 = _90 + -1.0f;
    float _112 = (_invViewProjRelative[0].x) * _88;
    float _113 = mad((_invViewProjRelative[0].y), _91, _112);
    float _114 = _113 + (_invViewProjRelative[0].z);
    float _115 = _114 + (_invViewProjRelative[0].w);
    float _116 = (_invViewProjRelative[1].x) * _88;
    float _117 = mad((_invViewProjRelative[1].y), _91, _116);
    float _118 = (_invViewProjRelative[1].w) + (_invViewProjRelative[1].z);
    float _119 = _118 + _117;
    float _120 = (_invViewProjRelative[2].x) * _88;
    float _121 = mad((_invViewProjRelative[2].y), _91, _120);
    float _122 = (_invViewProjRelative[2].w) + (_invViewProjRelative[2].z);
    float _123 = _122 + _121;
    float _124 = (_invViewProjRelative[3].x) * _88;
    float _125 = mad((_invViewProjRelative[3].y), _91, _124);
    float _126 = (_invViewProjRelative[3].w) + (_invViewProjRelative[3].z);
    float _127 = _126 + _125;
    float _128 = _115 / _127;
    float _129 = _119 / _127;
    float _130 = _123 / _127;
    float _131 = dot(float3(_128, _129, _130), float3(_128, _129, _130));
    float _132 = rsqrt(_131);
    float _133 = _132 * _128;
    float _134 = _132 * _129;
    float _135 = _132 * _130;
    float _139 = _earthAxisTilt + 90.0f;
    float _140 = _139 - _latitude;
    float _141 = _140 * 0.01745329238474369f;
    float _142 = sin(_141);
    float _143 = cos(_141);
    float _146 = _time.w * 0.2617993950843811f;
    float _147 = _146 + -3.1415927410125732f;
    float _148 = sin(_147);
    float _149 = cos(_147);
    float _150 = 1.0f - _149;
    float _151 = _150 * _142;
    float _152 = _150 * _143;
    float _153 = _148 * _142;
    float _154 = _148 * _143;
    float _155 = -0.0f - _153;
    float _156 = _151 * _142;
    float _157 = _156 + _149;
    float _158 = _152 * _142;
    float _159 = _151 * _143;
    float _160 = _152 * _143;
    float _161 = _160 + _149;
    float _162 = _149 * _133;
    float _163 = mad(_154, _134, _162);
    float _164 = mad(_155, _135, _163);
    float _165 = _133 * _154;
    float _166 = -0.0f - _165;
    float _167 = mad(_157, _134, _166);
    float _168 = mad(_158, _135, _167);
    float _169 = _153 * _133;
    float _170 = mad(_159, _134, _169);
    float _171 = mad(_161, _135, _170);
    float _172 = _171 / _164;
    float _173 = atan(_172);
    float _174 = _173 + 3.1415927410125732f;
    float _175 = _173 + -3.1415927410125732f;
    bool _176 = (_164 < 0.0f);
    bool _177 = (_164 == 0.0f);
    bool _178 = (_171 >= 0.0f);
    bool _179 = (_171 < 0.0f);
    bool _180 = (_176) & (_178);
    float _181 = select(_180, _174, _173);
    bool _182 = (_176) & (_179);
    float _183 = select(_182, _175, _181);
    bool _184 = (_177) & (_179);
    bool _185 = (_177) & (_178);
    float _186 = _183 * 0.15915493667125702f;
    float _187 = _186 + 0.5f;
    float _188 = select(_184, 0.25f, _187);
    float _189 = select(_185, 0.75f, _188);
    float _190 = acos(_168);
    float _191 = _190 * 0.31830987334251404f;
    int _192 = WaveReadLaneFirst(_materialIndex);
    bool _193 = ((uint)_192 < (uint)170000);
    int _194 = select(_193, _192, 0);
    uint _195 = _194 + 0u;
    int _200 = WaveReadLaneFirst(BindlessParameters_PostProcessSky[_195]._milkyWayTexture);
    bool _201 = ((uint)_200 < (uint)65000);
    int _202 = select(_201, _200, 0);
    uint _203 = _202 + 0u;
    float4 _207 = __0__7__0__0__g_bindlessTextures[_203].SampleLevel(__0__4__0__0__g_staticBilinearClamp, float2(_189, _191), 0.0f);
    float _211 = _164 * 2000.0f;
    float _212 = _168 * 2000.0f;
    float _213 = _171 * 2000.0f;
    int _214 = int(_211);
    int _215 = int(_212);
    int _216 = int(_213);
    float _217 = float((int)(_214));
    float _218 = float((int)(_215));
    float _219 = float((int)(_216));
    float _220 = _217 * 0.0005000000237487257f;
    float _221 = _217 * 0.008500000461935997f;
    float _222 = _218 * 5.0000002374872565e-05f;
    float _223 = _222 + _221;
    float _224 = sin(_223);
    float _225 = _224 * 10000.0f;
    float _226 = _218 * 0.006500000134110451f;
    float _227 = _226 + _220;
    float _228 = sin(_227);
    float _229 = abs(_228);
    float _230 = _229 + 0.10000000149011612f;
    float _231 = _225 * _230;
    float _232 = frac(_231);
    float _233 = _232 * 17.0f;
    float _234 = _219 * 5.0000002374872565e-05f;
    float _235 = _233 + _234;
    float _236 = sin(_235);
    float _237 = _236 * 10000.0f;
    float _238 = _219 * 0.006500000134110451f;
    float _239 = _232 + _238;
    float _240 = sin(_239);
    float _241 = abs(_240);
    float _242 = _241 + 0.10000000149011612f;
    float _243 = _237 * _242;
    float _244 = frac(_243);
    float _245 = _164 * 1500.0f;
    float _246 = _168 * 1500.0f;
    float _247 = _171 * 1500.0f;
    int _248 = int(_245);
    int _249 = int(_246);
    int _250 = int(_247);
    float _251 = float((int)(_248));
    float _252 = float((int)(_249));
    float _253 = float((int)(_250));
    float _254 = _251 * 0.0006666666595265269f;
    float _255 = _251 * 0.01133333332836628f;
    float _256 = _252 * 6.666666740784422e-05f;
    float _257 = _256 + _255;
    float _258 = sin(_257);
    float _259 = _258 * 10000.0f;
    float _260 = _252 * 0.008666666224598885f;
    float _261 = _260 + _254;
    float _262 = sin(_261);
    float _263 = abs(_262);
    float _264 = _263 + 0.10000000149011612f;
    float _265 = _259 * _264;
    float _266 = frac(_265);
    float _267 = _266 * 17.0f;
    float _268 = _253 * 6.666666740784422e-05f;
    float _269 = _267 + _268;
    float _270 = sin(_269);
    float _271 = _270 * 10000.0f;
    float _272 = _253 * 0.008666666224598885f;
    float _273 = _266 + _272;
    float _274 = sin(_273);
    float _275 = abs(_274);
    float _276 = _275 + 0.10000000149011612f;
    float _277 = _271 * _276;
    float _278 = frac(_277);
    float _279 = _244 + -0.699999988079071f;
    float _280 = _279 * 3.3333332538604736f;
    float _281 = saturate(_280);
    float _282 = _281 * 1.5f;
    float _283 = _282 * _207.x;
    float _284 = _282 * _207.y;
    float _285 = _282 * _207.z;
    float _286 = _283 + _207.x;
    float _287 = _284 + _207.y;
    float _288 = _285 + _207.z;
    float _289 = _278 + -0.9800000190734863f;
    float _290 = _289 * 50.00004959106445f;
    float _291 = saturate(_290);
    float _292 = _291 * 9.0f;
    float _293 = _286 * _292;
    float _294 = _287 * _292;
    float _295 = _288 * _292;
    float _296 = _293 + _286;
    float _297 = _294 + _287;
    float _298 = _295 + _288;
    int _299 = WaveReadLaneFirst(_materialIndex);
    bool _300 = ((uint)_299 < (uint)170000);
    int _301 = select(_300, _299, 0);
    uint _302 = _301 + 0u;
    float _307 = WaveReadLaneFirst(BindlessParameters_PostProcessSky[_302]._milkyWayRatio);
    float _308 = _307 * _296;
    float _309 = _307 * _297;
    float _310 = _307 * _298;
    float _311 = _244 + -0.9990000128746033f;
    float _312 = _311 * 1000.0128784179688f;
    float _313 = saturate(_312);
    float _314 = _313 * 0.10000000149011612f;
    float _315 = _278 + -0.9994999766349792f;
    float _316 = _315 * 1999.906494140625f;
    float _317 = saturate(_316);
    float _318 = _317 * 3.0f;
    float _319 = _318 + _314;
    int _320 = WaveReadLaneFirst(_materialIndex);
    bool _321 = ((uint)_320 < (uint)170000);
    int _322 = select(_321, _320, 0);
    uint _323 = _322 + 0u;
    float _328 = WaveReadLaneFirst(BindlessParameters_PostProcessSky[_323]._starRatio);
    float _329 = _328 * _319;
    float _330 = _329 + _308;
    float _331 = _329 + _309;
    float _332 = _329 + _310;
    float _337 = dot(float3(_133, _134, _135), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
    float _340 = _sunSizeAngle * 0.01745329238474369f;
    float _341 = acos(clamp(_337, -1.0f, 1.0f));
    float _353, _354, _355;
    if (SUN_MOON_ADJUSTMENTS > 0.5f) {

      float _sunRadius = _340 * 2.5f;

      // --- DEBUG TOGGLES: set to 0 to disable each feature for isolation testing ---
      #define SUN_ENABLE_CHROMATIC_DISPERSION 1
      #define SUN_ENABLE_LIMB_DARKENING       1
      #define SUN_ENABLE_CORONA               1
      #define SUN_ENABLE_MIE_HALO             1
      #define SUN_ENABLE_LUM_REDUCTION        0

      // --- Chromatic edge dispersion -------------------------------------------
      // Blue channel is refracted ~2% wider than red at the limb for atmospheric dispersion.
      #if SUN_ENABLE_CHROMATIC_DISPERSION
      float _sunRadiusR = _sunRadius;
      float _sunRadiusG = _sunRadius * 1.01f;
      float _sunRadiusB = _sunRadius * 1.02f;
      #else
      float _sunRadiusR = _sunRadius;
      float _sunRadiusG = _sunRadius;
      float _sunRadiusB = _sunRadius;
      #endif
      float _pixelAngle = _sunRadius * 0.05f;
      float _sunEdgeR = 1.0f - smoothstep(_sunRadiusR - _pixelAngle, _sunRadiusR + _pixelAngle, _341);
      float _sunEdgeG = 1.0f - smoothstep(_sunRadiusG - _pixelAngle, _sunRadiusG + _pixelAngle, _341);
      float _sunEdgeB = 1.0f - smoothstep(_sunRadiusB - _pixelAngle, _sunRadiusB + _pixelAngle, _341);

      // --- Limb darkening via Hestroffer power law --------------------------------
      #if SUN_ENABLE_LIMB_DARKENING
      float _r = saturate(_341 / max(_sunRadius, 1e-6f));
      float _mu = sqrt(1.0f - _r * _r);
      float _limbDark = pow(max(0.001f, _mu), 0.6f);
      #else
      float _limbDark = 1.0f;
      #endif

      // Sun disk colour: warm center (5778K-ish) very slightly to the limb.
      float _sunMaskR = _sunEdgeR * _limbDark;
      float _sunMaskG = _sunEdgeG * _limbDark;
      float _sunMaskB = _sunEdgeB * (_limbDark * 0.92f + 0.08f);

      // Added 10x brightness reduction so that postprocess bloom doesnt blow out the sun
      #if SUN_ENABLE_LUM_REDUCTION
      float _sunLum = min(100000.0f, _precomputedAmbient7.x) * 0.1f;
      #else
      float _sunLum = min(1e+06f, _precomputedAmbient7.x);
      #endif

      // --- K corona: falloff past the disk rim ---------------
      // Mimics electron scattering corona: independent of bloom 
      #if SUN_ENABLE_CORONA
      float _coronaR = max(0.0f, _341 - _sunRadiusR) / max(_sunRadius, 1e-6f);
      float _corona  = _sunLum * 0.006f / (1.0f + _coronaR * _coronaR * 10.0f);
      // Gate corona by sun elevation so it vanishes below the horizon,
      // matching the Mie halo behaviour. Without this a bright ass
      // gradient is present in the night sky where the sun set.
      float _coronaElev = saturate(_sunDirection.y * 5.0f);
      _corona *= _coronaElev;
      // Corona is slightly warm and tints channels accordingly.
      float _coronaContribR = _corona * 1.10f;
      float _coronaContribG = _corona * 0.95f;
      float _coronaContribB = _corona * 0.75f;
      #else
      float _coronaContribR = 0.0f;
      float _coronaContribG = 0.0f;
      float _coronaContribB = 0.0f;
      #endif

      // ---- Circumsolar aureole --------------------
      //
      // The atmospheric inscatter LUT already ray marches full Mie scattering with
      // the HG phase function
      //
      // We just add the missing mie halo for the sun, since the base game doesnt apply one
      //
      #if SUN_ENABLE_MIE_HALO
      float _mieHalo;
      {
        float _g       = _miePhaseConst;
        float _g2      = _g * _g;
        float _denom   = max(1e-6f, 1.0f + _g2 - 2.0f * _g * _337);
        float _HG      = (1.0f - _g2) / (_denom * sqrt(_denom)); 
        float _HG_4pi  = _HG * 0.07957747f;                       
        float _HG_iso  = 0.07957747f;
        float _HG_residual = max(0.0f, _HG_4pi - _HG_iso);
        float _sigma   = 0.087f;
        float _gauss   = exp(-0.5f * (_341 * _341) / (_sigma * _sigma));
        float _diskMask = smoothstep(_sunRadius * 0.8f, _sunRadius * 1.5f, _341);
        float _sunElev = saturate(_sunDirection.y * 5.0f);
        float _beta_sca = _mieAerosolDensity * 2e-5f;
        _mieHalo = _sunLum * _beta_sca * _HG_residual * _gauss * _diskMask * _sunElev;
      }
      #else
      float _mieHalo = 0.0f;
      #endif

      _353 = _sunMaskR * (_sunLum - _330) + _330 + _coronaContribR + _mieHalo;
      _354 = _sunMaskG * (_sunLum - _331) + _331 + _coronaContribG + _mieHalo;
      _355 = _sunMaskB * (_sunLum - _332) + _332 + _coronaContribB + _mieHalo;
    } else {
      // Vanilla: Just a hard binary disk + original luminance cap
      bool _342 = (_341 < _340);
      float _343 = select(_342, 1.0f, 0.0f);
      float _346 = min(1e+06f, _precomputedAmbient7.x);
      _353 = _343 * (_346 - _330) + _330;
      _354 = _343 * (_346 - _331) + _331;
      _355 = _343 * (_346 - _332) + _332;
    }
    // Moon size: Is now scalable via slider
    float _moonSizeAngleAdj = _moonSizeAngle * max(1.0f, MOON_DISK_SIZE);
    float _362 = _moonSizeAngleAdj * 0.01745329238474369f;
    float _363 = sin(_362);
    float _364 = -0.0f - _moonDirection.x;
    float _365 = -0.0f - _moonDirection.y;
    float _366 = -0.0f - _moonDirection.z;
    float _367 = dot(float3(_133, _134, _135), float3(_133, _134, _135));
    float _368 = dot(float3(_364, _365, _366), float3(_133, _134, _135));
    float _369 = _368 * 2.0f;
    float _370 = dot(float3(_364, _365, _366), float3(_364, _365, _366));
    float _371 = _363 * _363;
    float _372 = _370 - _371;
    float _373 = _369 * _369;
    float _374 = _367 * 4.0f;
    float _375 = _374 * _372;
    float _376 = _373 - _375;
    bool _377 = (_376 < 0.0f);
    if (!_377) {
      float _379 = sqrt(_376);
      float _380 = -0.0f - _369;
      float _381 = _380 - _379;
      float _382 = _367 * 2.0f;
      float _383 = _381 / _382;
      _385 = _383;
    } else {
      _385 = -1.0f;
    }
    bool _386 = !(_385 >= 0.0f);
    if (!_386) {
      float _388 = _385 * _133;
      float _389 = _385 * _134;
      float _390 = _385 * _135;
      float _391 = _388 - _moonDirection.x;
      float _392 = _389 - _moonDirection.y;
      float _393 = _390 - _moonDirection.z;
      float _394 = dot(float3(_391, _392, _393), float3(_391, _392, _393));
      float _395 = rsqrt(_394);
      float _396 = _395 * _391;
      float _397 = _395 * _392;
      float _398 = _395 * _393;
      _400 = _396;
      _401 = _397;
      _402 = _398;
    } else {
      _400 = 0.0f;
      _401 = 0.0f;
      _402 = 0.0f;
    }
    float _403 = dot(float3(_moonDirection.x, _moonDirection.y, _moonDirection.z), float3(_moonDirection.x, _moonDirection.y, _moonDirection.z));
    float _404 = rsqrt(_403);
    float _405 = _404 * _moonDirection.x;
    float _406 = _404 * _moonDirection.y;
    float _407 = _404 * _moonDirection.z;
    float _408 = dot(float3(_133, _134, _135), float3(_405, _406, _407));
    float _409 = acos(_408);
    bool _410 = (_409 < _362);
    if (_410) {
      float _412 = dot(float3(_400, _401, _402), float3(_sunDirection.x, _sunDirection.y, _sunDirection.z));
      float _413 = saturate(_412);
      float _418 = dot(float3(_400, _401, _402), float3(_moonRight.x, _moonRight.y, _moonRight.z));
      float _423 = dot(float3(_400, _401, _402), float3(_moonUp.x, _moonUp.y, _moonUp.z));
      float _424 = _418 * 0.5f;
      float _425 = _423 * 0.5f;
      float _426 = _424 + 0.5f;
      float _427 = _425 + 0.5f;

      // Moon luminance: flat 100x brightness reduction to prevent brickwalling.
      // Seems Pearl Abyss just ctrl c + ctrl V'd the sun luminance code and forgot to adjust the moon's
      // Goofy ahh moment
      float _moonRaw = _precomputedAmbient7.z;
      float _moonLum = (SUN_MOON_ADJUSTMENTS > 0.5f)
          ? (_moonRaw * 0.01f)
          : _moonRaw;
      float _429 = _413 * _moonLum;
      _431 = _429;
      _432 = 1.0f;
      _433 = _426;
      _434 = _427;
    } else {
      _431 = 0.0f;
      _432 = 0.0f;
      _433 = 0.0f;
      _434 = 0.0f;
    }
    int _435 = WaveReadLaneFirst(_materialIndex);
    bool _436 = ((uint)_435 < (uint)170000);
    int _437 = select(_436, _435, 0);
    uint _438 = _437 + 0u;
    int _443 = WaveReadLaneFirst(BindlessParameters_PostProcessSky[_438]._moonTexture);
    bool _444 = ((uint)_443 < (uint)65000);
    int _445 = select(_444, _443, 0);
    uint _446 = _445 + 0u;
    float4 _450 = __0__7__0__0__g_bindlessTextures[_446].Sample(__0__4__0__0__g_staticBilinearClamp, float2(_433, _434));
    float _454 = _450.x * _431;
    float _455 = _450.y * _431;
    float _456 = _450.z * _431;
    float _457 = _454 - _353;
    float _458 = _455 - _354;
    float _459 = _456 - _355;
    float _460 = _457 * _432;
    float _461 = _458 * _432;
    float _462 = _459 * _432;
    float _463 = _460 + _353;
    float _464 = _461 + _354;
    float _465 = _462 + _355;
    float _468 = floor(_time.x);
    float _469 = _468 * 0.36841699481010437f;
    float _470 = abs(_469);
    float _471 = sqrt(_470);
    float _472 = _471 * 3734.421875f;
    float _473 = frac(_472);
    bool _474 = (_473 < 0.10000000149011612f);
    if (_474) {
      float _476 = _468 + 60.0f;
      float _477 = _476 * 22.037681579589844f;
      float _478 = _476 * 85.1673583984375f;
      float _479 = _476 * 124.43804168701172f;
      float _480 = sin(_477);
      float _481 = sin(_478);
      float _482 = sin(_479);
      float _483 = _480 * 435.5429992675781f;
      float _484 = _481 * 435.5429992675781f;
      float _485 = _482 * 435.5429992675781f;
      float _486 = frac(_483);
      float _487 = frac(_484);
      float _488 = frac(_485);
      float _489 = _486 * 2.0f;
      float _490 = _487 * 2.0f;
      float _491 = _488 * 2.0f;
      float _492 = _489 + -1.0f;
      float _493 = _490 + -1.0f;
      float _494 = _491 + -1.0f;
      float _495 = dot(float3(_492, _493, _494), float3(_492, _493, _494));
      float _496 = rsqrt(_495);
      float _497 = _496 * _492;
      float _498 = _496 * _493;
      float _499 = _494 * _496;
      float _500 = dot(float3(_164, _168, _171), float3(_497, _498, _499));
      bool _501 = (_500 > 0.9900000095367432f);
      if (_501) {
        float _503 = frac(_time.x);
        float _504 = _468 * 22.037681579589844f;
        float _505 = _468 * 85.1673583984375f;
        float _506 = _468 * 124.43804168701172f;
        float _507 = sin(_504);
        float _508 = sin(_505);
        float _509 = sin(_506);
        float _510 = _507 * 435.5429992675781f;
        float _511 = _508 * 435.5429992675781f;
        float _512 = _509 * 435.5429992675781f;
        float _513 = frac(_510);
        float _514 = frac(_511);
        float _515 = frac(_512);
        float _516 = _513 * 0.5f;
        float _517 = _516 + -0.25f;
        float _518 = _514 * 0.5f;
        float _519 = _518 + -0.25f;
        float _520 = _515 * 0.5f;
        float _521 = _520 + -0.25f;
        float _522 = _503 * 1.5f;
        float _523 = saturate(_522);
        float _524 = _523 * 100.0f;
        float _525 = _524 * _517;
        float _526 = _524 * _519;
        float _527 = _524 * _521;
        float _528 = _164 * 100.0f;
        float _529 = _168 * 100.0f;
        float _530 = _525 * _529;
        float _531 = _526 * _528;
        float _532 = _530 - _531;
        float _533 = abs(_532);
        bool _534 = (_533 < 0.05000000074505806f);
        if (!_534) {
          float _536 = _515 * 0.25f;
          float _537 = _499 + 0.125f;
          float _538 = _537 - _536;
          float _539 = _538 * 100.0f;
          float _540 = _514 * 0.25f;
          float _541 = _498 + 0.125f;
          float _542 = _541 - _540;
          float _543 = _513 * 0.25f;
          float _544 = _497 + 0.125f;
          float _545 = _544 - _543;
          float _546 = _171 * 100.0f;
          float _547 = _545 * -100.0f;
          float _548 = _542 * -100.0f;
          float _549 = _547 * _529;
          float _550 = _548 * _528;
          float _551 = _549 - _550;
          float _552 = _551 / _532;
          float _553 = _526 * _547;
          float _554 = _525 * _548;
          float _555 = _553 - _554;
          float _556 = _555 / _532;
          float _557 = _552 * _527;
          float _558 = _557 + _539;
          float _559 = _546 * _556;
          float _560 = _558 - _559;
          float _561 = abs(_560);
          bool _562 = (_561 > 0.05000000074505806f);
          if (!_562) {
            float _564 = _552 * _525;
            float _565 = _552 * _526;
            float _566 = dot(float3(_564, _565, _557), float3(_525, _526, _527));
            float _567 = dot(float3(_525, _526, _527), float3(_525, _526, _527));
            float _568 = _566 / _567;
            bool _569 = (_568 >= 0.0f);
            bool _570 = (_568 <= 1.0f);
            bool _571 = (_569) & (_570);
            if (_571) {
              float _573 = _568 * _568;
              float _574 = _573 * _573;
              float _575 = _574 * _574;
              float _576 = _503 + -0.5f;
              float _577 = _576 * 2.0f;
              float _578 = saturate(_577);
              float _579 = 1.0f - _578;
              float _580 = _579 * _579;
              float _581 = _575 * _580;
              float _582 = _581 * _581;
              float _583 = _582 + _463;
              float _584 = _582 + _464;
              float _585 = _582 + _465;
              _587 = _583;
              _588 = _584;
              _589 = _585;
            } else {
              _587 = _463;
              _588 = _464;
              _589 = _465;
            }
          } else {
            _587 = _463;
            _588 = _464;
            _589 = _465;
          }
        } else {
          _587 = _463;
          _588 = _464;
          _589 = _465;
        }
      } else {
        _587 = _463;
        _588 = _464;
        _589 = _465;
      }
    } else {
      _587 = _463;
      _588 = _464;
      _589 = _465;
    }
    float _590 = _587 * 0.6131200194358826f;
    float _591 = _587 * 0.07020000368356705f;
    float _592 = _587 * 0.02061999961733818f;
    float _593 = _588 * 0.3395099937915802f;
    float _594 = _588 * 0.9163600206375122f;
    float _595 = _588 * 0.10958000272512436f;
    float _596 = _593 + _590;
    float _597 = _594 + _591;
    float _598 = _595 + _592;
    float _599 = _589 * 0.047370001673698425f;
    float _600 = _589 * 0.013450000435113907f;
    float _601 = _589 * 0.8697999715805054f;
    float _602 = _596 + _599;
    float _603 = _597 + _600;
    float _604 = _598 + _601;
    float _605 = _70 * 2.0f;
    float _606 = 1.0f - _605;
    float _627 = (_invViewProjRelative[0].x) * _88;
    float _628 = mad((_invViewProjRelative[0].y), _606, _627);
    float _629 = mad((_invViewProjRelative[0].z), 1.0000000116860974e-07f, _628);
    float _630 = _629 + (_invViewProjRelative[0].w);
    float _631 = (_invViewProjRelative[1].x) * _88;
    float _632 = mad((_invViewProjRelative[1].y), _606, _631);
    float _633 = mad((_invViewProjRelative[1].z), 1.0000000116860974e-07f, _632);
    float _634 = _633 + (_invViewProjRelative[1].w);
    float _635 = (_invViewProjRelative[2].x) * _88;
    float _636 = mad((_invViewProjRelative[2].y), _606, _635);
    float _637 = mad((_invViewProjRelative[2].z), 1.0000000116860974e-07f, _636);
    float _638 = _637 + (_invViewProjRelative[2].w);
    float _639 = (_invViewProjRelative[3].x) * _88;
    float _640 = mad((_invViewProjRelative[3].y), _606, _639);
    float _641 = mad((_invViewProjRelative[3].z), 1.0000000116860974e-07f, _640);
    float _642 = _641 + (_invViewProjRelative[3].w);
    float _643 = _630 / _642;
    float _644 = _634 / _642;
    float _645 = _638 / _642;
    float _646 = _643 * _643;
    float _647 = _644 * _644;
    float _648 = _647 + _646;
    float _649 = _645 * _645;
    float _650 = _648 + _649;
    float _651 = sqrt(_650);
    bool _652 = (_651 > 128.0f);
    if (_652) {
      float _656 = _nearFarProj.x * 1e+07f;
      float _660 = 2.0f / _bufferSizeAndInvSize.x;
      float _661 = 2.0f / _bufferSizeAndInvSize.y;
      [branch]
      if (!_61) {
        int _663 = _52 % 2;
        int _664 = _54 % 2;
        int _665 = _663 << 1;
        int _666 = _664 << 1;
        int _667 = _665 + -1;
        int _668 = _666 + -1;
        _670 = 1;
        _671 = _656;
        _672 = _656;
        _673 = _656;
        _674 = 0;
        _675 = 0;
        _676 = 0;
        while(true) {
          int _677 = _676 * _668;
          float _678 = float((int)(_677));
          float _679 = _678 * _661;
          float _680 = _679 + _70;
          float _683 = __3__36__0__0__g_depthHalf.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_69, _680), 0.0f);
          float _687 = max(1.0000000116860974e-07f, _683.x);
          float _688 = _nearFarProj.x / _687;
          float _689 = min(_671, _688);
          float _690 = max(_672, _688);
          float _691 = _688 - _656;
          float _692 = abs(_691);
          bool _693 = (_692 < _673);
          bool _694 = (_683.x < 1.0000000116860974e-07f);
          int _695 = (int)(uint)(_694);
          int _696 = select(_693, _695, _670);
          float _697 = select(_693, _692, _673);
          int _698 = select(_693, 0, _674);
          float _699 = float((int)(_667));
          float _700 = _699 * _660;
          float _701 = _700 + _69;
          float _702 = __3__36__0__0__g_depthHalf.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_701, _680), 0.0f);
          float _704 = max(1.0000000116860974e-07f, _702.x);
          float _705 = _nearFarProj.x / _704;
          float _706 = min(_689, _705);
          float _707 = max(_690, _705);
          float _708 = _705 - _656;
          float _709 = abs(_708);
          bool _710 = (_709 < _697);
          bool _711 = (_702.x < 1.0000000116860974e-07f);
          int _712 = (int)(uint)(_711);
          int _713 = select(_710, _712, _696);
          float _714 = select(_710, _709, _697);
          int _715 = select(_710, _667, _698);
          bool _716 = (_710) | (_693);
          int _717 = select(_716, _677, _675);
          int _718 = _676 + 1;
          bool _719 = (_718 == 2);
          if (!_719) {
            _670 = _713;
            _671 = _706;
            _672 = _707;
            _673 = _714;
            _674 = _715;
            _675 = _717;
            _676 = _718;
            continue;
          }
          float _721 = float((int)(_715));
          float _722 = float((int)(_717));
          _724 = _713;
          _725 = _706;
          _726 = _707;
          _727 = _721;
          _728 = _722;
          break;
        }
      } else {
        _724 = 1;
        _725 = _656;
        _726 = _656;
        _727 = 0.0f;
        _728 = 0.0f;
      }
      float _729 = _726 - _725;
      float _730 = _729 / _726;
      float _731 = _725 + -20000.0f;
      float _732 = max(0.0f, _731);
      float _733 = _732 * 9.999999747378752e-05f;
      float _734 = _733 + 0.10000000149011612f;
      bool _735 = (_730 > _734);
      if (!_735) {
        float _737 = _bufferSizeAndInvSize.x * _63;
        float _738 = _737 + _62;
        uint _741 = _frameNumber.x * 11;
        int _742 = _741 & 1023;
        float _743 = float((uint)_742);
        float _744 = _738 + _743;
        uint _745 = uint(_744);
        int _746 = (uint)(_745) >> 1;
        uint _747 = _746 * -1029531031;
        int _748 = (uint)(_745) >> 3;
        int _749 = _747 ^ _748;
        float _750 = float((uint)_749);
        float _751 = _750 * 2.3283064365386963e-10f;
        uint _752 = _746 * 1103515245;
        int _753 = _752 ^ 1;
        uint _754 = _753 * 1103515245;
        int _755 = _754 ^ _748;
        float _756 = float((uint)_755);
        float _757 = _756 * 2.3283064365386963e-10f;
        float _758 = _751 + -0.5f;
        float _759 = _757 + -0.5f;
        float _760 = float((uint)_745);
        float _761 = _760 + -0.30000001192092896f;
        float _762 = sqrt(_761);
        float _763 = 0.33676624298095703f / _762;
        float _764 = _760 * 0.7548776268959045f;
        float _765 = _760 * 0.5698402523994446f;
        float _766 = _764 + _763;
        float _767 = _765 + _763;
        float _768 = _758 * _766;
        float _769 = _759 * _767;
        float _770 = floor(_768);
        float _771 = floor(_769);
        float _772 = -0.5f - _770;
        float _773 = _772 + _768;
        float _774 = -0.5f - _771;
        float _775 = _774 + _769;
        _777 = _773;
        _778 = _775;
      } else {
        _777 = _727;
        _778 = _728;
      }
      float _779 = _777 * _660;
      float _780 = _778 * _661;
      float _781 = _779 + _69;
      float _782 = _780 + _70;
      float4 _785 = __3__36__0__0__g_texSkyInscatter.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_781, _782), 0.0f);
      float4 _790 = __3__36__0__0__g_texSkyExtinction.SampleLevel(__0__4__0__0__g_staticPointClamp, float2(_781, _782), 0.0f);
      bool _794 = (_724 != 0);
      float _795 = select(_794, 1.0f, 0.0f);
      _797 = _785.x;
      _798 = _785.y;
      _799 = _785.z;
      _800 = _790.x;
      _801 = _790.y;
      _802 = _790.z;
      _803 = _795;
    } else {
      _797 = 0.0f;
      _798 = 0.0f;
      _799 = 0.0f;
      _800 = 1.0f;
      _801 = 1.0f;
      _802 = 1.0f;
      _803 = 1.0f;
    }
    float _810 = _bufferSizeAndInvSize.x * _63;
    float _811 = _810 + _62;
    uint _814 = _frameNumber.x * 101;
    int _815 = _814 & 1023;
    float _816 = float((uint)_815);
    float _817 = _811 + _816;
    uint _818 = uint(_817);
    int _819 = (uint)(_818) >> 1;
    uint _820 = _819 * -1029531031;
    int _821 = (uint)(_818) >> 3;
    int _822 = _820 ^ _821;
    float _823 = float((uint)_822);
    float _824 = _823 * 2.3283064365386963e-10f;
    uint _825 = _819 * 1103515245;
    int _826 = _825 ^ 1;
    uint _827 = _826 * 1103515245;
    int _828 = _827 ^ _821;
    float _829 = float((uint)_828);
    float _830 = _829 * 2.3283064365386963e-10f;
    float _831 = _824 + -0.5f;
    float _832 = _830 + -0.5f;
    float _833 = float((uint)_818);
    float _834 = _833 + -0.30000001192092896f;
    float _835 = sqrt(_834);
    float _836 = 0.33676624298095703f / _835;
    float _837 = _833 * 0.7548776268959045f;
    float _838 = _833 * 0.5698402523994446f;
    float _839 = _837 + _836;
    float _840 = _838 + _836;
    float _841 = _831 * _839;
    float _842 = _832 * _840;
    float _843 = floor(_841);
    float _844 = floor(_842);
    int _845 = _frameNumber.x & 1023;
    float _846 = float((uint)_845);
    float _847 = _846 * 32.665000915527344f;
    float _848 = _846 * 11.8149995803833f;
    float _849 = _847 + _62;
    float _850 = _848 + _63;
    float _851 = dot(float2(_849, _850), float2(0.0671105608344078f, 0.005837149918079376f));
    float _852 = frac(_851);
    float _853 = _852 * 52.98291778564453f;
    float _854 = frac(_853);
    float _855 = max(0.0f, _651);
    float _856 = _855 * 0.04351966083049774f;
    float _857 = _856 + 1.0f;
    float _858 = log2(_857);
    float _859 = _858 * 17.673004150390625f;
    float _860 = max(0.0f, _859);
    float _861 = _860 - _854;
    float _862 = -0.5f - _843;
    float _863 = _862 + _841;
    float _864 = -0.5f - _844;
    float _865 = _864 + _842;
    float _866 = _863 / _etcParams.y;
    float _867 = _865 / _etcParams.z;
    float _868 = _866 + _69;
    float _869 = _867 + _70;
    float _870 = _861 / _etcParams.w;
    float _872 = _etcParams.y * 4.0f;
    float _873 = _etcParams.z * 4.0f;
    float _874 = _bufferSizeAndInvSize.x - _872;
    float _875 = _bufferSizeAndInvSize.y - _873;
    bool _876 = (_874 > 0.0f);
    bool _877 = (_875 > 0.0f);
    float _878 = float((bool)_876);
    float _879 = float((bool)_877);
    float _880 = _878 + 0.5f;
    float _881 = _879 + 0.5f;
    float _882 = _880 / _etcParams.y;
    float _883 = _881 / _etcParams.z;
    float _884 = 1.0f - _882;
    float _885 = 1.0f - _883;
    float _886 = min(_884, _868);
    float _887 = min(_885, _869);
    float4 _889 = __3__36__0__0__g_texFroxel.SampleLevel(__0__4__0__0__g_staticBilinearClamp, float3(_886, _887, _870), 0.0f);
    float _910 = (_projToPrevProj[0].x) * _88;
    float _911 = mad((_projToPrevProj[0].y), _606, _910);
    float _912 = mad((_projToPrevProj[0].z), 0.009999999776482582f, _911);
    float _913 = _912 + (_projToPrevProj[0].w);
    float _914 = (_projToPrevProj[1].x) * _88;
    float _915 = mad((_projToPrevProj[1].y), _606, _914);
    float _916 = mad((_projToPrevProj[1].z), 0.009999999776482582f, _915);
    float _917 = _916 + (_projToPrevProj[1].w);
    float _918 = (_projToPrevProj[3].x) * _88;
    float _919 = mad((_projToPrevProj[3].y), _606, _918);
    float _920 = mad((_projToPrevProj[3].z), 0.009999999776482582f, _919);
    float _921 = _920 + (_projToPrevProj[3].w);
    float _922 = _913 / _921;
    float _923 = _917 / _921;
    float _924 = _922 - _88;
    float _925 = _923 - _606;
    float _926 = _924 * _924;
    float _927 = _925 * _925;
    float _928 = _927 + _926;
    float _929 = sqrt(_928);
    float _930 = dot(float3(_800, _801, _802), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
    float _931 = _930 * _889.w;
    float _932 = _929 * 20.0f;
    float _933 = 1.0f - _932;
    float _934 = saturate(_933);
    float _935 = _934 * _931;
    float _936 = _934 + _931;
    float _937 = _936 - _935;
    bool _938 = (_81 == 10);
    float _939 = select(_938, 0.0f, _889.x);
    float _940 = select(_938, 0.0f, _889.y);
    float _941 = select(_938, 0.0f, _889.z);
    float _942 = select(_938, 1.0f, _889.w);
    float _943 = _942 * _797;
    float _944 = _942 * _798;
    float _945 = _942 * _799;
    float _946 = _943 + _939;
    float _947 = _944 + _940;
    float _948 = _945 + _941;
    float _949 = _942 * _803;
    float _950 = _800 * _602;
    float _951 = _950 * _949;
    float _952 = _801 * _603;
    float _953 = _952 * _949;
    float _954 = _802 * _604;
    float _955 = _954 * _949;
    float _956 = _946 + _951;
    float _957 = _947 + _953;
    float _958 = _948 + _955;
    __3__38__0__1__g_postProcessUAV[int2(_52, _54)] = float4(_956, _957, _958, _937);
  }
}
