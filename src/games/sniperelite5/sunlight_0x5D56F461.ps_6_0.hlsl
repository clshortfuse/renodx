#include "./shared.h"
// Baseline: 2 fewer fmul fast (dxc reassociation: per-channel (spec*NdotL)*D shares NdotL*D once); commutative/phi order only otherwise.

Texture2D<float4> g_xLighting_NormalBuffer : register(t2);

Texture2D<float4> g_xLighting_AlbedoBuffer : register(t3);

Texture2D<float4> g_xLighting_PBRPropertiesBuffer : register(t4);

Texture2D<float4> g_xLighting_DepthStencil : register(t5);

Texture2D<float4> g_xLighting_Clouds : register(t52);

Texture2D<float4> g_xShadowMask : register(t6);

cbuffer FrameConstants : register(b0) {
  float4 g_xView[4] : packoffset(c000.x);
  float4 g_xProj[4] : packoffset(c004.x);
  float4 g_xViewProj[4] : packoffset(c008.x);
  float4 g_xInvView[4] : packoffset(c012.x);
  float4 g_xInvProj[4] : packoffset(c016.x);
  float4 g_xInvViewProj[4] : packoffset(c020.x);
  float3 g_xCamPos : packoffset(c024.x);
  float g_fScaledTime : packoffset(c024.w);
  float4 g_xTwoOverScreenDimensions : packoffset(c025.x);
  float2 g_xCameraTanHalfFOV : packoffset(c026.x);
  float2 g_xCameraFarClipValues : packoffset(c026.z);
  float2 g_xRcpScreenDims : packoffset(c027.x);
  float2 g_xDepthProjViewUnpack : packoffset(c027.z);
  float4 g_axViewFrustumPlanes[6] : packoffset(c028.x);
  int4 g_xScreenDimensions : packoffset(c034.x);
  float4 g_xTessCutoffAndFactors : packoffset(c035.x);
  float g_fTessMaxDist : packoffset(c036.x);
  float g_fTessRcpRange : packoffset(c036.y);
  float g_fDisplacementScale : packoffset(c036.z);
  float g_fBackFaceCutoff : packoffset(c036.w);
  float g_fFoliageFadeInvDistance : packoffset(c037.x);
  float g_fFoliageFadePower : packoffset(c037.y);
  int g_bFoliageFadeEnabled : packoffset(c037.z);
  float g_fEnvironmentDecalBias : packoffset(c037.w);
  float g_fInstanceDecalBias : packoffset(c038.x);
  float3 g_xWindDirection : packoffset(c038.y);
  float g_fWindStrength : packoffset(c039.x);
  float3 g_xSubsurfaceScatteringWeight : packoffset(c039.y);
  float g_fGlobalSamplerBias : packoffset(c040.x);
  float3 g_xDeformationWindowCentre : packoffset(c040.y);
  float g_fDeformationWindowSize : packoffset(c041.x);
  float g_fDeformationUVDensity : packoffset(c041.y);
  float g_fDeformationNormalIntensity : packoffset(c041.z);
  float g_fRainfallIntensity : packoffset(c041.w);
  float g_fRainBaseWetness : packoffset(c042.x);
  float3 g_xRainDirection : packoffset(c042.y);
};

cbuffer ProjectedCloudParams : register(b7) {
  int g_bSunlightCloudsEnabled : packoffset(c000.x);
  float g_fSunlightCloudsVelocityX : packoffset(c000.y);
  float g_fSunlightCloudsVelocityY : packoffset(c000.z);
  float g_fSunlightCloudsScale : packoffset(c000.w);
  float4 g_xSunlightCloudsProjectionDir : packoffset(c001.x);
};

cbuffer SunlightParams : register(b9) {
  float3 g_xSunLightDir : packoffset(c000.x);
  float g_fCSMStrength : packoffset(c000.w);
  float4 g_xLightColour : packoffset(c001.x);
};

SamplerState g_xBilinearWrap : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _13 = floor(SV_Position.x);
  float _14 = floor(SV_Position.y);
  int _15 = int(_13);
  int _16 = int(_14);
  float4 _17 = g_xLighting_DepthStencil.Load(int3(_15, _16, 0));
  float _22 = g_xDepthProjViewUnpack.y - _17.x;
  float _23 = g_xDepthProjViewUnpack.x / _22;
  float _27 = g_xCameraTanHalfFOV.x * _23;
  float _28 = g_xCameraTanHalfFOV.y * _23;
  float _32 = g_xTwoOverScreenDimensions.z + _13;
  float _33 = g_xTwoOverScreenDimensions.w + _14;
  float _36 = _32 * g_xTwoOverScreenDimensions.x;
  float _37 = _33 * g_xTwoOverScreenDimensions.y;
  float _38 = _36 + -1.0f;
  float _39 = _37 + -1.0f;
  float _40 = _27 * _38;
  float _41 = _28 * _39;
  float _58 = _40 * (g_xInvView[0].x);
  float _59 = mad((g_xInvView[1].x), _41, _58);
  float _60 = mad((g_xInvView[2].x), _23, _59);
  float _61 = _60 + (g_xInvView[3].x);
  float _62 = _40 * (g_xInvView[0].y);
  float _63 = mad((g_xInvView[1].y), _41, _62);
  float _64 = mad((g_xInvView[2].y), _23, _63);
  float _65 = _64 + (g_xInvView[3].y);
  float _66 = _40 * (g_xInvView[0].z);
  float _67 = mad((g_xInvView[1].z), _41, _66);
  float _68 = mad((g_xInvView[2].z), _23, _67);
  float _69 = _68 + (g_xInvView[3].z);
  float4 _70 = g_xLighting_NormalBuffer.Load(int3(_15, _16, 0));
  float4 _75 = g_xLighting_AlbedoBuffer.Load(int3(_15, _16, 0));
  float4 _80 = g_xLighting_PBRPropertiesBuffer.Load(int3(_15, _16, 0));
  float _85 = _70.x * 2.0f;
  float _86 = _70.y * 2.0f;
  float _87 = _70.z * 2.0f;
  float _88 = _85 + -1.0f;
  float _89 = _86 + -1.0f;
  float _90 = _87 + -1.0f;
  float _91 = dot(float3(_88, _89, _90), float3(_88, _89, _90));
  float _92 = rsqrt(_91);
  float _93 = _92 * _88;
  float _94 = _92 * _89;
  float _95 = _92 * _90;
  float _96 = _80.z * 2.0f;
  float _97 = _80.w * 2.0f;
  float _98 = _96 + -1.0f;
  float _99 = _97 + -1.0f;
  float _100 = dot(float2(_98, _99), float2(_98, _99));
  float _101 = 1.0f - _100;
  float _102 = saturate(_101);
  float _103 = sqrt(_102);
  bool _104 = (_70.w != 0.0f);
  float _105 = -0.0f - _103;
  float _106 = select(_104, _103, _105);
  float4 _107 = g_xShadowMask.Load(int3(_15, _16, 0));
  bool _109 = (_107.x > 0.0f);
  float _190;
  float _191;
  float _192;
  float _193;
  float _194;
  float _195;
  float _196;
  float _335;
  float _336;
  float _337;
  float _421;
  float _422;
  float _423;
  float _468;
  float _491;
  float _492;
  float _493;
  float _516;
  float _517;
  float _518;
  float _519;
  [branch]
  if (_109) {
    float _115 = g_xCamPos.x - _61;
    float _116 = g_xCamPos.y - _65;
    float _117 = g_xCamPos.z - _69;
    float _118 = dot(float3(_115, _116, _117), float3(_115, _116, _117));
    float _119 = rsqrt(_118);
    float _120 = _115 * _119;
    float _121 = _116 * _119;
    float _122 = _117 * _119;
    // RenoDX: tolerant material-ID compares (MaterialIdEquals, shared.h)
    bool _131 = (!MaterialIdEquals(_75.w, 0.019607843831181526f));
    float _132 = select(_131, _80.x, 0.0f);
    float _133 = g_xSunLightDir.x + _120;
    float _134 = g_xSunLightDir.y + _121;
    float _135 = g_xSunLightDir.z + _122;
    float _136 = dot(float3(_133, _134, _135), float3(_133, _134, _135));
    float _137 = rsqrt(_136);
    float _138 = _133 * _137;
    float _139 = _134 * _137;
    float _140 = _135 * _137;
    float _141 = dot(float3(_93, _94, _95), float3(g_xSunLightDir.x, g_xSunLightDir.y, g_xSunLightDir.z));
    float _142 = saturate(_141);
    float _143 = dot(float3(_93, _94, _95), float3(_120, _121, _122));
    float _144 = saturate(_143);
    float _145 = dot(float3(_93, _94, _95), float3(_138, _139, _140));
    float _146 = saturate(_145);
    float _147 = dot(float3(_120, _121, _122), float3(_138, _139, _140));
    float _148 = saturate(_147);
    bool _149 = (MaterialIdEquals(_75.w, 0.01568627543747425f));
    [branch]
    if (!_149) {
      bool _151 = (MaterialIdEquals(_75.w, 0.007843137718737125f));
      [branch]
      if (!_151) {
        bool _153 = (MaterialIdEquals(_75.w, 0.003921568859368563f));
        [branch]
        if (_153) {
          float _155 = -0.0f - _93;
          float _156 = -0.0f - _94;
          float _157 = -0.0f - _95;
          float _158 = dot(float3(g_xSunLightDir.x, g_xSunLightDir.y, g_xSunLightDir.z), float3(_155, _156, _157));
          float _159 = saturate(_158);
          float _160 = _159 * 0.4000000059604645f;
          float _161 = -0.0f - _120;
          float _162 = -0.0f - _121;
          float _163 = -0.0f - _122;
          float _164 = dot(float3(g_xSunLightDir.x, g_xSunLightDir.y, g_xSunLightDir.z), float3(_161, _162, _163));
          float _165 = saturate(_164);
          float _166 = log2(_165);
          float _167 = _166 * 7.0f;
          float _168 = exp2(_167);
          float _169 = _168 + _160;
          float _170 = saturate(_169);
          float _171 = _170 * _132;
          float _172 = _171 + _142;
          _190 = _75.x;
          _191 = _75.y;
          _192 = _75.z;
          _193 = 0.02800000086426735f;
          _194 = 0.02800000086426735f;
          _195 = 0.02800000086426735f;
          _196 = _172;
        } else {
          float _174 = _75.x + -0.03999999910593033f;
          float _175 = _75.y + -0.03999999910593033f;
          float _176 = _75.z + -0.03999999910593033f;
          float _177 = _132 * _174;
          float _178 = _132 * _175;
          float _179 = _132 * _176;
          float _180 = _177 + 0.03999999910593033f;
          float _181 = _178 + 0.03999999910593033f;
          float _182 = _179 + 0.03999999910593033f;
          float _183 = _132 * _75.x;
          float _184 = _132 * _75.y;
          float _185 = _132 * _75.z;
          float _186 = _75.x - _183;
          float _187 = _75.y - _184;
          float _188 = _75.z - _185;
          _190 = _186;
          _191 = _187;
          _192 = _188;
          _193 = _180;
          _194 = _181;
          _195 = _182;
          _196 = _142;
        }
      } else {
        _190 = _75.x;
        _191 = _75.y;
        _192 = _75.z;
        _193 = 0.02800000086426735f;
        _194 = 0.02800000086426735f;
        _195 = 0.02800000086426735f;
        _196 = _142;
      }
    } else {
      _190 = _75.x;
      _191 = _75.y;
      _192 = _75.z;
      _193 = 0.04699999839067459f;
      _194 = 0.04699999839067459f;
      _195 = 0.04699999839067459f;
      _196 = _142;
    }
    float _197 = _196 * _190;
    float _198 = _196 * _191;
    float _199 = _196 * _192;
    float _200 = max(_80.y, 0.05000000074505806f);
    float _201 = _200 * _200;
    [branch]
    if (_149) {
      float _203 = 1.0f - _80.y;
      float _204 = saturate(_203);
      float _205 = dot(float3(_75.x, _75.y, _75.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
      float _206 = _80.x * 0.6000000238418579f;
      float _207 = _206 + -0.3500000238418579f;
      float _208 = _206 + -0.25f;
      float _209 = _204 * 0.05000000074505806f;
      float _210 = _208 - _209;
      float _211 = log2(_204);
      float _212 = _211 * 8.0f;
      float _213 = exp2(_212);
      float _214 = _213 * 500.0f;
      float _215 = _214 + 20.0f;
      float _216 = _211 * 6.0f;
      float _217 = exp2(_216);
      float _218 = _217 * 2000.0f;
      float _219 = _218 + 50.0f;
      float _220 = _80.x * 0.13500000536441803f;
      float _221 = _220 + 0.015000000596046448f;
      float _222 = _204 + 0.10000000149011612f;
      float _223 = _80.x * 0.007499999832361937f;
      float _224 = _223 + 0.007499999832361937f;
      float _225 = _207 * _93;
      float _226 = _207 * _94;
      float _227 = _207 * _95;
      float _228 = _225 + _98;
      float _229 = _226 + _99;
      float _230 = _106 + _227;
      float _231 = dot(float3(_228, _229, _230), float3(_228, _229, _230));
      float _232 = rsqrt(_231);
      float _233 = _232 * _228;
      float _234 = _232 * _229;
      float _235 = _232 * _230;
      float _236 = dot(float3(_233, _234, _235), float3(_138, _139, _140));
      float _237 = _236 * _236;
      float _238 = 1.0f - _237;
      float _239 = saturate(_238);
      float _240 = sqrt(_239);
      float _241 = _236 + 1.0f;
      float _242 = saturate(_241);
      float _243 = _242 * 2.0f;
      float _244 = 3.0f - _243;
      float _245 = log2(_240);
      float _246 = _245 * _215;
      float _247 = exp2(_246);
      float _248 = _213 * 19.89436912536621f;
      float _249 = _248 + 1.1140847206115723f;
      float _250 = _222 * _221;
      float _251 = _250 * _249;
      float _252 = _242 * _242;
      float _253 = _252 * _251;
      float _254 = _253 * _244;
      float _255 = _254 * _247;
      float _256 = max(_205, 0.0010000000474974513f);
      float _257 = _75.x / _256;
      float _258 = _75.y / _256;
      float _259 = _75.z / _256;
      float _260 = _255 * _257;
      float _261 = _255 * _258;
      float _262 = _255 * _259;
      float _263 = _210 * _93;
      float _264 = _210 * _94;
      float _265 = _210 * _95;
      float _266 = _263 + _98;
      float _267 = _264 + _99;
      float _268 = _265 + _106;
      float _269 = dot(float3(_266, _267, _268), float3(_266, _267, _268));
      float _270 = rsqrt(_269);
      float _271 = _270 * _266;
      float _272 = _270 * _267;
      float _273 = _270 * _268;
      float _274 = dot(float3(_271, _272, _273), float3(_138, _139, _140));
      float _275 = _274 * _274;
      float _276 = 1.0f - _275;
      float _277 = saturate(_276);
      float _278 = sqrt(_277);
      float _279 = _274 + 1.0f;
      float _280 = saturate(_279);
      float _281 = _280 * 2.0f;
      float _282 = 3.0f - _281;
      float _283 = log2(_278);
      float _284 = _283 * _219;
      float _285 = exp2(_284);
      float _286 = _217 * 79.57747650146484f;
      float _287 = _286 + 2.3077468872070312f;
      float _288 = _204 * _224;
      float _289 = _288 * _287;
      float _290 = _280 * _280;
      float _291 = _290 * _289;
      float _292 = _291 * _282;
      float _293 = _292 * _285;
      float _294 = _293 + _260;
      float _295 = _293 + _261;
      float _296 = _293 + _262;
      float _297 = _294 * _142;
      float _298 = _295 * _142;
      float _299 = _296 * _142;
      _335 = _297;
      _336 = _298;
      _337 = _299;
    } else {
      float _301 = 1.0f - _193;
      float _302 = 1.0f - _194;
      float _303 = 1.0f - _195;
      float _304 = _148 * 5.55472993850708f;
      float _305 = -6.983160018920898f - _304;
      float _306 = _305 * _148;
      float _307 = exp2(_306);
      float _308 = _307 * _301;
      float _309 = _307 * _302;
      float _310 = _307 * _303;
      float _311 = _308 + _193;
      float _312 = _309 + _194;
      float _313 = _310 + _195;
      float _314 = 2.0f - _201;
      float _315 = _314 * _144;
      float _316 = _315 + _201;
      float _317 = _314 * _142;
      float _318 = _317 + _201;
      float _319 = _316 * _318;
      float _320 = 1.0f / _319;
      float _321 = _201 * _201;
      float _322 = _321 * _146;
      float _323 = _322 - _146;
      float _324 = _323 * _146;
      float _325 = _324 + 1.0f;
      float _326 = _325 * _325;
      float _327 = 1.0f / _326;
      float _328 = _321 * _142;
      float _329 = _328 * _320;
      float _330 = _329 * _327;
      float _331 = _330 * _311;
      float _332 = _330 * _312;
      float _333 = _330 * _313;
      _335 = _331;
      _336 = _332;
      _337 = _333;
    }
    float _338 = _335 + _197;
    float _339 = _336 + _198;
    float _340 = _337 + _199;
    bool _341 = (MaterialIdEquals(_75.w, 0.019607843831181526f));
    [branch]
    if (_341) {
      bool _343 = (_80.x > 0.49803921580314636f);
      float _344 = _80.x + -0.501960813999176f;
      float _345 = select(_343, _344, _80.x);
      float _346 = _345 * 2.007874011993408f;
      float _347 = select(_343, 0.5f, 0.0f);
      float _348 = -0.0f - _93;
      float _349 = -0.0f - _94;
      float _350 = -0.0f - _95;
      float _351 = dot(float3(g_xSunLightDir.x, g_xSunLightDir.y, g_xSunLightDir.z), float3(_348, _349, _350));
      float _352 = saturate(_351);
      float _353 = _352 * 0.4000000059604645f;
      float _354 = -0.0f - _120;
      float _355 = -0.0f - _121;
      float _356 = -0.0f - _122;
      float _357 = dot(float3(g_xSunLightDir.x, g_xSunLightDir.y, g_xSunLightDir.z), float3(_354, _355, _356));
      float _358 = saturate(_357);
      float _359 = log2(_358);
      float _360 = _359 * 7.0f;
      float _361 = exp2(_360);
      float _362 = _361 + _353;
      float _363 = saturate(_362);
      float _364 = _363 * _347;
      float _365 = _364 * _190;
      float _366 = _364 * _191;
      float _367 = _364 * _192;
      float _368 = abs(_190);
      float _369 = abs(_191);
      float _370 = abs(_192);
      float _371 = sqrt(_368);
      float _372 = sqrt(_369);
      float _373 = sqrt(_370);
      float _374 = 1.0f - _371;
      float _375 = 1.0f - _372;
      float _376 = 1.0f - _373;
      float _377 = _148 * 5.55472993850708f;
      float _378 = -6.983160018920898f - _377;
      float _379 = _378 * _148;
      float _380 = exp2(_379);
      float _381 = _380 * _374;
      float _382 = _380 * _375;
      float _383 = _376 * _380;
      float _384 = _381 + _371;
      float _385 = _382 + _372;
      float _386 = _383 + _373;
      float _387 = _144 + _142;
      float _388 = _144 * _142;
      float _389 = _387 - _388;
      float _390 = _389 * 4.0f;
      float _391 = _390 + 9.999999682655225e-21f;
      float _392 = 1.0f / _391;
      float _393 = 0.5f / _201;
      float _394 = _146 * _146;
      float _395 = 1.0f - _394;
      float _396 = _393 + 1.0f;
      float _397 = log2(_395);
      float _398 = _397 * _393;
      float _399 = exp2(_398);
      float _400 = _396 * _392;
      float _401 = _400 * _399;
      float _402 = _384 * _142;
      float _403 = _402 * _401;
      float _404 = _385 * _142;
      float _405 = _404 * _401;
      float _406 = _386 * _142;
      float _407 = _406 * _401;
      float _408 = _365 - _335;
      float _409 = _408 + _403;
      float _410 = _366 - _336;
      float _411 = _410 + _405;
      float _412 = _367 - _337;
      float _413 = _412 + _407;
      float _414 = _409 * _346;
      float _415 = _411 * _346;
      float _416 = _413 * _346;
      float _417 = _414 + _338;
      float _418 = _415 + _339;
      float _419 = _416 + _340;
      _421 = _417;
      _422 = _418;
      _423 = _419;
    } else {
      _421 = _338;
      _422 = _339;
      _423 = _340;
    }
    float _424 = _421 * g_xLightColour.x;
    float _425 = _422 * g_xLightColour.y;
    float _426 = _423 * g_xLightColour.z;
    float _427 = min(_424, 1000.0f);
    float _428 = min(_425, 1000.0f);
    float _429 = min(_426, 1000.0f);
    bool _432 = (g_bSunlightCloudsEnabled == 0);
    [branch]
    if (!_432) {
      float _438 = dot(float3(g_xSunlightCloudsProjectionDir.x, g_xSunlightCloudsProjectionDir.y, g_xSunlightCloudsProjectionDir.z), float3(0.0f, 1.0f, 0.0f));
      float _439 = abs(_438);
      bool _440 = (_439 > 9.999999974752427e-07f);
      [branch]
      if (_440) {
        float _442 = -0.0f - _61;
        float _443 = -10000.0f - _65;
        float _444 = -0.0f - _69;
        float _445 = dot(float3(_442, _443, _444), float3(0.0f, 1.0f, 0.0f));
        float _446 = _445 / _438;
        bool _447 = (_446 > 0.0f);
        [branch]
        if (_447) {
          float _449 = g_xSunlightCloudsProjectionDir.x * _446;
          float _450 = g_xSunlightCloudsProjectionDir.z * _446;
          float _451 = _449 + _61;
          float _452 = _450 + _69;
          float _456 = g_fSunlightCloudsVelocityX * g_fScaledTime;
          float _457 = _451 + _456;
          float _459 = g_fSunlightCloudsVelocityY * g_fScaledTime;
          float _460 = _452 + _459;
          float _462 = _457 / g_fSunlightCloudsScale;
          float _463 = _460 / g_fSunlightCloudsScale;
          float _464 = -0.0f - _462;
          float4 _465 = g_xLighting_Clouds.SampleLevel(g_xBilinearWrap, float2(_464, _463), 0.0f);
          _468 = _465.x;
        } else {
          _468 = 1.0f;
        }
      } else {
        _468 = 1.0f;
      }
    } else {
      _468 = 1.0f;
    }
    float _469 = _468 * _107.x;
    bool _470 = (MaterialIdEquals(_75.w, 0.007843137718737125f));
    [branch]
    if (_470) {
      float _472 = _75.x * 0.019444789737462997f;
      float _473 = _75.y * 1.680522836977616e-05f;
      float _474 = _75.z * 3.190706726607928e-11f;
      float _475 = -0.0f - _93;
      float _476 = -0.0f - _94;
      float _477 = -0.0f - _95;
      float _478 = dot(float3(g_xSunLightDir.x, g_xSunLightDir.y, g_xSunLightDir.z), float3(_475, _476, _477));
      float _479 = _478 + 0.30000001192092896f;
      float _480 = saturate(_479);
      float _481 = _472 * g_xLightColour.x;
      float _482 = _481 * _480;
      float _483 = _473 * g_xLightColour.y;
      float _484 = _483 * _480;
      float _485 = _474 * g_xLightColour.z;
      float _486 = _485 * _480;
      float _487 = _482 + _427;
      float _488 = _484 + _428;
      float _489 = _486 + _429;
      _491 = _487;
      _492 = _488;
      _493 = _489;
    } else {
      _491 = _427;
      _492 = _428;
      _493 = _429;
    }
    bool _494 = (_23 < 3.0f);
    bool _495 = _494 && _470;
    [branch]
    if (_495) {
      float _497 = _23 + -2.0f;
      float _498 = max(_497, 0.0f);
      float _503 = 1.0f - g_xSubsurfaceScatteringWeight.x;
      float _504 = 1.0f - g_xSubsurfaceScatteringWeight.y;
      float _505 = 1.0f - g_xSubsurfaceScatteringWeight.z;
      float _506 = _503 * _498;
      float _507 = _504 * _498;
      float _508 = _505 * _498;
      float _509 = _506 + g_xSubsurfaceScatteringWeight.x;
      float _510 = _507 + g_xSubsurfaceScatteringWeight.y;
      float _511 = _508 + g_xSubsurfaceScatteringWeight.z;
      float _512 = _509 * _491;
      float _513 = _510 * _492;
      float _514 = _511 * _493;
      _516 = _512;
      _517 = _513;
      _518 = _514;
      _519 = _469;
    } else {
      _516 = _491;
      _517 = _492;
      _518 = _493;
      _519 = _469;
    }
  } else {
    _516 = 0.0f;
    _517 = 0.0f;
    _518 = 0.0f;
    _519 = _107.x;
  }
  float _520 = _519 * _516;
  float _521 = _519 * _517;
  float _522 = _519 * _518;
  float _523 = _519 * _519;
  SV_Target.x = _520;
  SV_Target.y = _521;
  SV_Target.z = _522;
  SV_Target.w = _523;
  return SV_Target;
}
