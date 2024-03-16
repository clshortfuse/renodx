// HUD Shader

#include "../common/filmgrain.hlsl"
#include "../cp2077/colormath.hlsl"
#include "../cp2077/cp2077.h"
#include "../cp2077/injectedBuffer.hlsl"

static float _312;

cbuffer _32_34 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
}

cbuffer _41_43 : register(b6, space0) {
  float4 cb6[30] : packoffset(c0);
}

cbuffer _37_39 : register(b12, space0) {
  float4 _39_m0[99] : packoffset(c0);
}

Texture2D<float4> textureUI : register(t0, space0);
Texture2D<float4> textureNoise : register(t1, space0);
Texture2D<float4> _15 : register(t2, space0);
Texture2D<float4> _16 : register(t3, space0);
Texture2D<float4> texture5 : register(t5, space0);
Texture2D<float4> texture6 : register(t6, space0);
Buffer<uint4> _21 : register(t7, space0);
Texture2D<float4> _22 : register(t8, space0);
Buffer<uint4> bufferHudMask : register(t9, space0);  // UI Mask?
Texture2D<float4> _24 : register(t10, space0);
Texture2D<float4> textureRender : register(t32, space0);
Texture2D<uint4> _12 : register(t51, space0);

RWTexture2D<float4> _27 : register(u0, space0);
RWTexture2D<float4> _28 : register(u1, space0);

SamplerState _46 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _76 = _21.Load(gl_WorkGroupID.x);
  uint _77 = _76.x;
  uint _85 = ((_77 << 4u) & 1048560u) + gl_LocalInvocationID.x;
  uint _86 = ((_77 >> 16u) << 4u) + gl_LocalInvocationID.y;
  float _87 = float(_85);
  float _88 = float(_86);
  uint4 _96 = asuint(cb6[12u]);
  float _99 = float(_96.z);
  float _100 = float(_96.w);
  float _101 = (_87 + 0.5f) / _99;
  float _102 = (_88 + 0.5f) / _100;
  bool _118 = ((_101 < cb6[9u].y) || (_102 < cb6[9u].z)) || (((1.0f - cb6[9u].y) < _101) || ((1.0f - cb6[9u].z) < _102));
  float _119;
  float _123;
  float _126;

  float uiOverlayShake = cb6[0u].x;
  float uiDeathOverlay = cb6[0u].y;
  // cb6[0u].z;
  // cb6[0u].w;

  float hudVisualEffects = cb6[1u].x;  // Hud Ghosting
  float uiStaticStrength = cb6[1u].y;  // If Lens Distortion is off
  float hudMaskStrength = cb6[1u].z;   // Hud Mask?
  float texture6Strength = cb6[1u].w;  // Blur texture?
  float texture5Strength = cb6[2u].x;
  // cb6[2u].yz
  float hudSkewX = cb6[3u].x;
  float hudSkewY = cb6[3u].y;
  float dropShadowX = cb6[3u].z;
  float dropShadowY = cb6[3u].w;
  float dropShadowOpacity = cb6[4u].x;
  float dropShadowSpread = cb6[4u].y;

  float hudVisual00 = cb6[6u].w;

  float uiOutline = cb6[12u].x;
  float uiPaperWhiteScaler = cb6[12u].y;

  if (_118) {
    _119 = 0.0f;
    _123 = 0.0f;
    _126 = 0.0f;
  } else {
    bool _138 = uiOverlayShake > 0.0f;
    float _140 = _101 + (-0.5f);
    float _142 = _102 + (-0.5f);
    float _146 = uiDeathOverlay + 0.119999997317790985107421875f;
    float _150 = max(_146 + abs(_140), 0.0f);
    float _151 = max(_146 + abs(_142), 0.0f);
    float _158 = clamp(sqrt((_151 * _151) + (_150 * _150)) * 20.0f, 0.0f, 1.0f);
    float _165 = ((_158 * _158) * uiOverlayShake) * (3.0f - (_158 * 2.0f));
    float _166 = _165 * 0.699999988079071044921875f;
    float _169 = ceil(_166) - _166;
    float _172 = (_169 * 50.0f) + 1.0f;
    float _181 = (((cos(cb0[0u].x) * 2.0f) + 200.0f) * _169) + 1.0f;
    float _193 = frac(floor(_172 * _101) * 0.103100001811981201171875f);
    float _194 = frac(floor(_181 * _102) * 0.103100001811981201171875f);
    float _195 = _194 + 33.3300018310546875f;
    float _197 = _193 + 33.3300018310546875f;
    float _198 = dot(float3(_193, _194, _193), float3(_195, _197, _197));
    float _204 = _194 + _193;
    float _207 = frac((_204 + (_198 * 2.0f)) * (_198 + _193));
    float _232 = abs(sin((_165 * 0.1680000126361846923828125f) * cb0[0u].x));
    float _237 = (_165 * 0.14000000059604644775390625f) + 1.0f;
    float _243 = dot(float3(_194, _193, _194), float3(_197, _195, _195));
    float _256 = (floor(frac(frac((_204 + (_243 * 2.0f)) * (_243 + _194)) + _232) * _237) * (1.0f / (((cos(frac(_207 + abs(sin(cb0[0u].x * 5000.0f))) * cb0[0u].x) * 0.0199999995529651641845703125f) + 1.0f) * _181))) + _102;
    float _258 = _100 * _256;
    float _267 = frac(round((_165 * 0.125f) * _258) * 0.103100001811981201171875f);
    float _268 = frac((_165 * 2.0620000362396240234375f) * cb0[0u].x);
    float _269 = _268 + 33.3300018310546875f;
    float _270 = _267 + 33.3300018310546875f;
    float _271 = dot(float3(_267, _268, _267), float3(_269, _270, _270));
    float _285 = frac(round((_165 * 0.012500000186264514923095703125f) * _258) * 0.103100001811981201171875f);
    float _286 = _285 + 33.3300018310546875f;
    float _287 = dot(float3(_285, _268, _285), float3(_269, _286, _286));
    float _304 = _138 ? ((((_99 * ((floor(frac(_207 + _232) * _237) * (1.0f / (((sin(frac(_207 + abs(sin(cb0[0u].x * 100.0f))) * cb0[0u].x) * 0.0199999995529651641845703125f) + 1.0f) * _172))) + _101)) + 2.0f) + ((((_165 * _165) * 960.0f) * frac(((_268 + _267) + (_271 * 2.0f)) * (_271 + _267))) * frac(((_268 + _285) + (_287 * 2.0f)) * (_287 + _285)))) / _99) : _101;
    float _305 = _138 ? _256 : _102;
    bool _306 = uiDeathOverlay > 0.0f;

    bool hasUiOutline = uiOutline > 0.0f;
    float _1111;
    float _1112;
    float _1113;
    float _1115;
    float _1117;
    if (_306) {
      float _340 = floor(_304 * 2.5f) * 0.4000000059604644775390625f;
      float _342 = floor(_305 * 10.0f) * 0.100000001490116119384765625f;
      float _344 = _340 + 0.20000000298023223876953125f;
      float _346 = _342 + 0.0500000007450580596923828125f;
      float _350 = floor((cb0[0u].x * 2.0f) + (uiDeathOverlay * 20.0f));
      float _351 = _350 * 0.00999999977648258209228515625f;
      float _365 = _344 + (((_351 + 1.0f) - (floor(_350 * 9.9999997473787516355514526367188e-05f) * 100.0f)) * 0.00999999977648258209228515625f);
      float _366 = _346 + (((_350 + 1.0f) - (floor(_351) * 100.0f)) * 0.00999999977648258209228515625f);
      float _376 = frac(_365 * 0.103100001811981201171875f);
      float _377 = frac(_366 * 0.103100001811981201171875f);
      float _379 = _376 + 33.3300018310546875f;
      float _380 = dot(float3(_376, _377, _376), float3(_377 + 33.3300018310546875f, _379, _379));
      float _388 = frac(((_377 + _376) + (_380 * 2.0f)) * (_380 + _376));
      float _391 = ((1.0f - _388) * ((uiDeathOverlay * 0.75f) + (-0.100000001490116119384765625f))) + _388;
      float _394 = round(_391 - (_391 * (0.5f - (uiDeathOverlay * 0.375f))));
      float _395 = _394 * _394;
      float _396 = _304 - _344;
      float _397 = _305 - _346;
      float _398 = _344 * _365;
      float _399 = _346 * _366;
      float _404 = (_340 + 0.300000011920928955078125f) * _365;
      float _405 = (_342 + 0.1500000059604644775390625f) * _366;
      float _408 = frac(_398 * 0.103100001811981201171875f);
      float _409 = frac(_399 * 0.103100001811981201171875f);
      float _411 = _408 + 33.3300018310546875f;
      float _412 = dot(float3(_408, _409, _408), float3(_409 + 33.3300018310546875f, _411, _411));
      float _425 = frac((_398 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _426 = frac((_399 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _428 = _425 + 33.3300018310546875f;
      float _429 = dot(float3(_425, _426, _425), float3(_426 + 33.3300018310546875f, _428, _428));
      float _443 = floor(frac(((_409 + _408) + (_412 * 2.0f)) * (_412 + _408)) * 3.25f) * 0.100000001490116119384765625f;
      float _444 = floor(frac(((_426 + _425) + (_429 * 2.0f)) * (_429 + _425)) * 3.25f) * 0.02500000037252902984619140625f;
      float _446 = _443 + (-0.20000000298023223876953125f);
      float _448 = _444 + (-0.0500000007450580596923828125f);
      float _452 = frac(_404 * 0.103100001811981201171875f);
      float _453 = frac(_405 * 0.103100001811981201171875f);
      float _455 = _452 + 33.3300018310546875f;
      float _456 = dot(float3(_452, _453, _452), float3(_453 + 33.3300018310546875f, _455, _455));
      float _469 = frac((_404 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _470 = frac((_405 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _472 = _469 + 33.3300018310546875f;
      float _473 = dot(float3(_469, _470, _469), float3(_470 + 33.3300018310546875f, _472, _472));
      float _486 = floor(frac(((_453 + _452) + (_456 * 2.0f)) * (_456 + _452)) * 3.25f) * 0.100000001490116119384765625f;
      float _487 = floor(frac(((_470 + _469) + (_473 * 2.0f)) * (_473 + _469)) * 3.25f) * 0.02500000037252902984619140625f;
      float _488 = _486 + (-0.20000000298023223876953125f);
      float _489 = _487 + (-0.0500000007450580596923828125f);
      float _492 = _396 - _446;
      float _493 = _397 - _448;
      float _503 = (-0.0250000059604644775390625f) - _396;
      float _505 = _503 + _443;
      float _506 = (-0.006250001490116119384765625f) - _397;
      float _508 = _506 + _444;
      uint _523 = (((((uint(_505 > 0.0f) + ((_505 < 0.0f) ? 4294967295u : 0u)) + ((_492 < 0.0f) ? 4294967295u : 0u)) + uint(_492 > 0.0f)) + ((_493 < 0.0f) ? 4294967295u : 0u)) + uint(_493 > 0.0f)) + (uint(_508 > 0.0f) - uint(_508 < 0.0f));
      float _531 = min(float(int(uint(int(_523) > int(3u)) - uint(int(_523) < int(3u)))), 0.0f);
      float _536 = _396 - _488;
      float _537 = _397 - _489;
      float _546 = _503 + _486;
      float _547 = _506 + _487;
      uint _562 = (((((uint(_546 > 0.0f) + ((_546 < 0.0f) ? 4294967295u : 0u)) + ((_536 < 0.0f) ? 4294967295u : 0u)) + uint(_536 > 0.0f)) + ((_537 < 0.0f) ? 4294967295u : 0u)) + uint(_537 > 0.0f)) + (uint(_547 > 0.0f) - uint(_547 < 0.0f));
      float _569 = min(float(int(uint(int(_562) > int(3u)) - uint(int(_562) < int(3u)))), 0.0f);
      float _576 = _304 + ((_395 * (((_446 - _488) * _569) + ((_488 - _446) * _531))) * 1.2000000476837158203125f);
      float _580 = _305 + ((_395 * (((_448 - _489) * _569) + ((_489 - _448) * _531))) * 1.2000000476837158203125f);
      uint _581 = uint(_101);
      uint _582 = uint(_102);
      float4 _583 = textureRender.Load(int3(uint2(_581, _582), 0u));
      float _585 = _583.y;
      float _893;
      if (hasUiOutline) {
        uint _812 = 1u << (_12.Load(int3(uint2(uint(_39_m0[79u].x * float(_581)), uint(_39_m0[79u].y * float(_582))), 0u)).y & 31u);
        float4 noisePixel = textureNoise.Load(int3(uint2(_581 & 255u, _582 & 255u), 0u));
        float avg = (noisePixel.x + noisePixel.y + noisePixel.z) / 3.f;
        float _823 = uiOutline * _585;
        float _830 = noisePixel.x - avg;
        float _832 = avg + (-0.5f);
        uint4 _838 = asuint(cb6[17u]);
        float _887 = (((((((_832 + (cb6[18u].w * _830)) * cb6[18u].y)
                          * float(min((_838.x & _812), 1u)))
                         + 1.0f)
                        * (_823 / max(1.0f - _823, 9.9999999747524270787835121154785e-07f)))
                       * ((((_832 + (cb6[19u].w * _830)) * cb6[19u].y) * float(min((_838.y & _812), 1u))) + 1.0f))
                      * ((((_832 + (cb6[20u].w * _830)) * cb6[20u].y) * float(min((_838.z & _812), 1u))) + 1.0f))
                   * ((((_832 + (cb6[21u].w * _830)) * cb6[21u].y) * float(min((_838.w & _812), 1u))) + 1.0f);
        _893 = uiPaperWhiteScaler * (_887 / max(_887 + 1.0f, 1.0f));
      } else {
        _893 = _585;
      }
      float _895 = _893 * uiDeathOverlay;
      float _897 = (_576 + (-0.5f)) + _895;
      float _899 = (0.5f - _580) + _895;
      float _901 = atan(_899 / _897);
      bool _906 = _897 < 0.0f;
      bool _907 = _897 == 0.0f;
      bool _908 = _899 >= 0.0f;
      bool _909 = _899 < 0.0f;
      float _923 = sqrt((_897 * _897) + (_899 * _899));
      float _926 = ((_907 && _908) ? 1.57079637050628662109375f : ((_907 && _909) ? (-1.57079637050628662109375f) : ((_906 && _909) ? (_901 + (-3.1415927410125732421875f)) : ((_906 && _908) ? (_901 + 3.1415927410125732421875f) : _901)))) + clamp(uiDeathOverlay * (_893 * 0.5f), 0.0f, 1.0f);
      uint _937 = uint(_99 * frac((cos(_926) * _923) + 0.5f));
      uint _938 = uint(_100 * frac(0.5f - (sin(_926) * _923)));
      float4 _939 = textureRender.Load(int3(uint2(_937, _938), 0u));
      float _941 = _939.x;
      float _942 = _939.y;
      float _943 = _939.z;
      float frontier_phi_14_12_ladder;
      float frontier_phi_14_12_ladder_1;
      float frontier_phi_14_12_ladder_2;
      float frontier_phi_14_12_ladder_3;
      float frontier_phi_14_12_ladder_4;
      if (hasUiOutline) {
        float4 _1254 = textureNoise.Load(int3(uint2(_937 & 255u, _938 & 255u), 0u));
        if (injectedData.fxFilmGrain) {
          float3 grainedColor = computeFilmGrain(
            float3(_941, _942, _943),
            _1254.xy,
            frac(cb0[0u].x / 1000.f),
            injectedData.fxFilmGrain * 0.03f,
            (uiPaperWhiteScaler == 1.f) ? 1.f : (203.f / 100.f)
          );
          frontier_phi_14_12_ladder = _580;
          frontier_phi_14_12_ladder_1 = _576;
          frontier_phi_14_12_ladder_2 = grainedColor.r;
          frontier_phi_14_12_ladder_3 = grainedColor.g;
          frontier_phi_14_12_ladder_4 = grainedColor.b;
        } else {
          uint _1251 = 1u << (_12.Load(int3(uint2(uint(_39_m0[79u].x * float(_937)), uint(_39_m0[79u].y * float(_938))), 0u)).y & 31u);
          float _1256 = _1254.x;
          float _1257 = _1254.y;
          float _1258 = _1254.z;
          float _1261 = ((_1256 + _1257) + _1258) * 0.3333333432674407958984375f;
          float _1262 = uiOutline * _941;
          float _1263 = uiOutline * _942;
          float _1264 = uiOutline * _943;
          float _1277 = _1256 - _1261;
          float _1278 = _1257 - _1261;
          float _1279 = _1258 - _1261;
          float _1283 = _1261 + (-0.5f);
          uint4 _1295 = asuint(cb6[17u]);
          float _1299 = float(min((_1295.x & _1251), 1u));
          float _1327 = float(min((_1295.y & _1251), 1u));
          float _1355 = float(min((_1295.z & _1251), 1u));
          float _1383 = float(min((_1295.w & _1251), 1u));
          float _1390 = (((((((_1283 + (cb6[18u].w * _1277)) * cb6[18u].x) * _1299) + 1.0f) * (_1262 / max(1.0f - _1262, 9.9999999747524270787835121154785e-07f))) * ((((_1283 + (cb6[19u].w * _1277)) * cb6[19u].x) * _1327) + 1.0f)) * ((((_1283 + (cb6[20u].w * _1277)) * cb6[20u].x) * _1355) + 1.0f)) * ((((_1283 + (cb6[21u].w * _1277)) * cb6[21u].x) * _1383) + 1.0f);
          float _1391 = (((((((_1283 + (cb6[18u].w * _1278)) * cb6[18u].y) * _1299) + 1.0f) * (_1263 / max(1.0f - _1263, 9.9999999747524270787835121154785e-07f))) * ((((_1283 + (cb6[19u].w * _1278)) * cb6[19u].y) * _1327) + 1.0f)) * ((((_1283 + (cb6[20u].w * _1278)) * cb6[20u].y) * _1355) + 1.0f)) * ((((_1283 + (cb6[21u].w * _1278)) * cb6[21u].y) * _1383) + 1.0f);
          float _1392 = (((((((_1283 + (cb6[18u].w * _1279)) * cb6[18u].z) * _1299) + 1.0f) * (_1264 / max(1.0f - _1264, 9.9999999747524270787835121154785e-07f))) * ((((_1283 + (cb6[19u].w * _1279)) * cb6[19u].z) * _1327) + 1.0f)) * ((((_1283 + (cb6[20u].w * _1279)) * cb6[20u].z) * _1355) + 1.0f)) * ((((_1283 + (cb6[21u].w * _1279)) * cb6[21u].z) * _1383) + 1.0f);
          frontier_phi_14_12_ladder = _580;
          frontier_phi_14_12_ladder_1 = _576;
          frontier_phi_14_12_ladder_2 = uiPaperWhiteScaler * (_1390 / max(_1390 + 1.0f, 1.0f));
          frontier_phi_14_12_ladder_3 = uiPaperWhiteScaler * (_1391 / max(_1391 + 1.0f, 1.0f));
          frontier_phi_14_12_ladder_4 = uiPaperWhiteScaler * (_1392 / max(_1392 + 1.0f, 1.0f));
        }
      } else {
        frontier_phi_14_12_ladder = _580;
        frontier_phi_14_12_ladder_1 = _576;
        frontier_phi_14_12_ladder_2 = _941;
        frontier_phi_14_12_ladder_3 = _942;
        frontier_phi_14_12_ladder_4 = _943;
      }
      _1111 = frontier_phi_14_12_ladder_1;
      _1112 = frontier_phi_14_12_ladder;
      _1113 = frontier_phi_14_12_ladder_2;
      _1115 = frontier_phi_14_12_ladder_3;
      _1117 = frontier_phi_14_12_ladder_4;
    } else {
      float4 _586 = textureRender.Load(int3(uint2(_85, _86), 0u));
      float _588 = _586.x;
      float _589 = _586.y;
      float _590 = _586.z;
      float frontier_phi_14_6_ladder;
      float frontier_phi_14_6_ladder_1;
      float frontier_phi_14_6_ladder_2;
      float frontier_phi_14_6_ladder_3;
      float frontier_phi_14_6_ladder_4;
      if (hasUiOutline) {
        float4 _959 = textureNoise.Load(int3(uint2(_85 & 255u, _86 & 255u), 0u));
        if (injectedData.fxFilmGrain) {
          float3 grainedColor = computeFilmGrain(
            float3(_588, _589, _590),
            _959.xy,
            frac(cb0[0u].x / 1000.f),
            injectedData.fxFilmGrain * 0.03f,
            (uiPaperWhiteScaler == 1.f) ? 1.f : (203.f / 100.f)
          );
          frontier_phi_14_6_ladder_1 = _304;
          frontier_phi_14_6_ladder_2 = grainedColor.r;
          frontier_phi_14_6_ladder_3 = grainedColor.g;
          frontier_phi_14_6_ladder_4 = grainedColor.b;
        } else {
          uint _956 = 1u << (_12.Load(int3(uint2(uint(_39_m0[79u].x * _87), uint(_39_m0[79u].y * _88)), 0u)).y & 31u);
          float _961 = _959.x;
          float _962 = _959.y;
          float _963 = _959.z;
          float _966 = ((_961 + _962) + _963) * 0.3333333432674407958984375f;
          float _967 = uiOutline * _588;
          float _968 = uiOutline * _589;
          float _969 = uiOutline * _590;
          float _982 = _961 - _966;
          float _983 = _962 - _966;
          float _984 = _963 - _966;
          float _988 = _966 + (-0.5f);
          uint4 _1000 = asuint(cb6[17u]);
          float _1004 = float(min((_1000.x & _956), 1u));
          float _1032 = float(min((_1000.y & _956), 1u));
          float _1060 = float(min((_1000.z & _956), 1u));
          float _1088 = float(min((_1000.w & _956), 1u));
          float _1095 = (((((((_988 + (cb6[18u].w * _982)) * cb6[18u].x) * _1004) + 1.0f) * (_967 / max(1.0f - _967, 9.9999999747524270787835121154785e-07f))) * ((((_988 + (cb6[19u].w * _982)) * cb6[19u].x) * _1032) + 1.0f)) * ((((_988 + (cb6[20u].w * _982)) * cb6[20u].x) * _1060) + 1.0f)) * ((((_988 + (cb6[21u].w * _982)) * cb6[21u].x) * _1088) + 1.0f);
          float _1096 = (((((((_988 + (cb6[18u].w * _983)) * cb6[18u].y) * _1004) + 1.0f) * (_968 / max(1.0f - _968, 9.9999999747524270787835121154785e-07f))) * ((((_988 + (cb6[19u].w * _983)) * cb6[19u].y) * _1032) + 1.0f)) * ((((_988 + (cb6[20u].w * _983)) * cb6[20u].y) * _1060) + 1.0f)) * ((((_988 + (cb6[21u].w * _983)) * cb6[21u].y) * _1088) + 1.0f);
          float _1097 = (((((((_988 + (cb6[18u].w * _984)) * cb6[18u].z) * _1004) + 1.0f) * (_969 / max(1.0f - _969, 9.9999999747524270787835121154785e-07f))) * ((((_988 + (cb6[19u].w * _984)) * cb6[19u].z) * _1032) + 1.0f)) * ((((_988 + (cb6[20u].w * _984)) * cb6[20u].z) * _1060) + 1.0f)) * ((((_988 + (cb6[21u].w * _984)) * cb6[21u].z) * _1088) + 1.0f);
          frontier_phi_14_6_ladder = _305;
          frontier_phi_14_6_ladder_1 = _304;
          frontier_phi_14_6_ladder_2 = uiPaperWhiteScaler * (_1095 / max(_1095 + 1.0f, 1.0f));
          frontier_phi_14_6_ladder_3 = uiPaperWhiteScaler * (_1096 / max(_1096 + 1.0f, 1.0f));
          frontier_phi_14_6_ladder_4 = uiPaperWhiteScaler * (_1097 / max(_1097 + 1.0f, 1.0f));
        }
      } else {
        frontier_phi_14_6_ladder = _305;
        frontier_phi_14_6_ladder_1 = _304;
        frontier_phi_14_6_ladder_2 = _588;
        frontier_phi_14_6_ladder_3 = _589;
        frontier_phi_14_6_ladder_4 = _590;
      }
      _1111 = frontier_phi_14_6_ladder_1;
      _1112 = frontier_phi_14_6_ladder;
      _1113 = frontier_phi_14_6_ladder_2;
      _1115 = frontier_phi_14_6_ladder_3;
      _1117 = frontier_phi_14_6_ladder_4;
    }
    bool _1127 = hudMaskStrength > 0.0f;
    float _1411;
    if ((asuint(cb6[13u]).z != 0u) && _1127) {
      _1411 = (hudMaskStrength * (asfloat(bufferHudMask.Load(6u).x) + (-1.0f))) + 1.0f;
    } else {
      _1411 = 1.0f;
    }
    float _1416 = _1111 + (-0.5f);
    float _1418 = (_1112 + (-0.5f)) * 2.0f;
    float _1426 = _1111 - (((_1418 * _1418) * _1416) * hudSkewX);
    float _1427 = _1112 - ((((_1416 * _1416) * 2.0f) * _1418) * hudSkewY);
    float _1430 = (_1426 + (-0.5f)) * 2.0f;
    float _1431 = (_1427 + (-0.5f)) * 2.0f;
    float _1433 = cb0[0u].x * 0.004999999888241291046142578125f;
    float _1436 = (clamp(_1427, 0.0f, 1.0f) + 1.0f) - _1433;
    float _1441 = clamp(abs(cos(_1436 * 650.0f)), 0.0f, 1.0f);
    float _1447 = clamp(_1426, 0.0f, 1.0f) + 1.0f;
    float _1448 = _1447 - _1433;
    float _1454 = sin(cb0[0u].x);
    float _1455 = _1447 + _1433;
    float _1470 = clamp(((((_1454 + _1454) * 0.100000001490116119384765625f) + 0.540000021457672119140625f) + ((clamp(abs(cos(_1455 * 550.0f)), 0.0f, 1.0f) + clamp(abs(cos(_1448 * 250.0f)), 0.0f, 1.0f)) * 0.1799999773502349853515625f)) * ((_1441 * 0.39999997615814208984375f) + 0.60000002384185791015625f), 0.0f, 1.0f);
    float _1622;
    float _1624;
    float _1626;
    if (texture6Strength > 0.0f) {
      float4 _1595 = texture6.SampleLevel(_46, float2(_101, _102), 0.0f);
      float _1606 = (clamp(abs(cos(_1436 * 250.0f)), 0.0f, 1.0f) * 0.0007999999797903001308441162109375f) + 0.00120000005699694156646728515625f;
      float _1613 = (_1441 * 0.001199999940581619739532470703125f) + 0.001800000085495412349700927734375f;
      float _1615 = (_1606 + _1595.x) - _1613;
      float _1616 = (_1606 + _1595.y) - _1613;
      float _1617 = (_1606 + _1595.z) - _1613;
      float _1783;
      float _1784;
      float _1785;
      if (cb6[6u].x > 0.0f) {
        float _1773 = clamp((sqrt((_142 * _142) + (_140 * _140)) - cb6[5u].z) / (cb6[5u].w - cb6[5u].z), 0.0f, 1.0f);
        float _1779 = 1.0f - (((_1773 * _1773) * (3.0f - (_1773 * 2.0f))) * cb6[6u].x);
        _1783 = _1779 * _1615;
        _1784 = _1779 * _1616;
        _1785 = _1779 * _1617;
      } else {
        _1783 = _1615;
        _1784 = _1616;
        _1785 = _1617;
      }
      float _1787 = dot(float3(_1783, _1784, _1785), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1622 = (((_1783 - _1787) * cb6[6u].y) + _1787) * texture6Strength;
      _1624 = (((_1784 - _1787) * cb6[6u].y) + _1787) * texture6Strength;
      _1626 = (((_1785 - _1787) * cb6[6u].y) + _1787) * texture6Strength;
    } else {
      _1622 = 0.0f;
      _1624 = 0.0f;
      _1626 = 0.0f;
    }
    float _1815;
    float _1816;
    float _1817;
    if (texture5Strength > 0.0f) {
      float4 _1804 = texture5.SampleLevel(_46, float2(_1426, 1.0f - _1427), 0.0f);
      _1815 = (texture5Strength * _1804.x) + _1622;
      _1816 = (texture5Strength * _1804.y) + _1624;
      _1817 = (texture5Strength * _1804.z) + _1626;
    } else {
      _1815 = _1622;
      _1816 = _1624;
      _1817 = _1626;
    }
    float _1995;
    float _1996;
    float _1997;
    if (_1127) {
      float4 _1958 = _16.SampleLevel(_46, float2(_1111, _1112), 0.0f);
      float4 _1965 = _15.SampleLevel(_46, float2(_1111, _1112), 0.0f);
      float _1970 = _1965.w;
      float _1971 = 1.0f - _1970;
      float _1976 = (_1971 * _1958.w) + _1970;
      _1995 = (((_1976 * ((_1965.x - _1113) + (_1971 * _1958.x))) + _1113) * hudMaskStrength) + _1815;
      _1996 = (((_1976 * ((_1965.y - _1115) + (_1971 * _1958.y))) + _1115) * hudMaskStrength) + _1816;
      _1997 = (((_1976 * ((_1965.z - _1117) + (_1971 * _1958.z))) + _1117) * hudMaskStrength) + _1817;
    } else {
      _1995 = _1815;
      _1996 = _1816;
      _1997 = _1817;
    }
    float _2167;
    float _2169;
    float _2171;
    if (hudVisualEffects > 0.0f) {
      float _2074 = hudVisual00 * _1430;
      float _2075 = hudVisual00 * _1431;
      float4 _2079 = textureUI.SampleLevel(_46, float2(_2074 + _1426, _2075 + _1427), 0.0f);
      float4 _2083 = textureUI.SampleLevel(_46, float2(_1426, _1427), 0.0f);
      float4 _2090 = textureUI.SampleLevel(_46, float2(_1426 - _2074, _1427 - _2075), 0.0f);
      float4 _2105 = textureUI.SampleLevel(_46, float2((cb6[7u].x * _1430) + _1426, (cb6[7u].y * _1431) + _1427), 1.0f);
      float4 _2116 = textureUI.SampleLevel(_46, float2((cb6[7u].z * _1430) + _1426, (cb6[7u].w * _1431) + _1427), 2.0f);
      float4 _2131 = textureUI.SampleLevel(_46, float2((cb6[8u].x * _1430) + _1426, (cb6[8u].y * _1431) + _1427), 4.0f);
      float _2163 = 1.0f - (((_2083.w + _2079.w) + _2090.w) * 0.3333333432674407958984375f);
      float _2164 = clamp(_1470 * (((cb6[8u].w * _2116.x) + (cb6[8u].z * _2105.x)) + (cb6[9u].x * _2131.x)), 0.0f, 1.0f) * _2163;
      float _2165 = clamp(_1470 * (((cb6[8u].w * _2116.y) + (cb6[8u].z * _2105.y)) + (cb6[9u].x * _2131.y)), 0.0f, 1.0f) * _2163;
      float _2166 = clamp(_1470 * (((cb6[8u].w * _2116.z) + (cb6[8u].z * _2105.z)) + (cb6[9u].x * _2131.z)), 0.0f, 1.0f) * _2163;
      float _2258;
      float _2259;
      float _2260;
      if (_1127) {
        float _2254 = 1.0f - (dot(float3(hudMaskStrength * _1113, hudMaskStrength * _1115, hudMaskStrength * _1117), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * 0.699999988079071044921875f);
        _2258 = _2254 * _2164;
        _2259 = _2254 * _2165;
        _2260 = _2254 * _2166;
      } else {
        _2258 = _2164;
        _2259 = _2165;
        _2260 = _2166;
      }
      float _2262 = dot(float3(_2258, _2259, _2260), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _2274 = hudVisualEffects * _1411;
      float _2287 = _1426 - dropShadowX;
      float _2288 = _1427 - dropShadowY;
      float4 _2294 = textureUI.SampleLevel(_46, float2(_2287, _2288), 0.0f);
      float _2296 = _2294.w;
      float _2309 = 1.0f - (dropShadowOpacity * clamp(exp2(log2(abs((clamp(dropShadowSpread, 0.0f, 1.0f) * (_22.SampleLevel(_46, float2(_2287, _2288), dropShadowSpread + (-1.0f)).w - _2296)) + _2296)) * 0.819999992847442626953125f), 0.0f, 1.0f));
      float _2310 = _1454 * 0.00999999977648258209228515625f;
      float _2338 = (((clamp((cos((_2310 + _1427) * 1700.0f) + 1.0f) * 0.75f, 0.0f, 1.0f) * 0.00850000046193599700927734375f) + 0.00150000001303851604461669921875f) * (((_2310 + 0.540000021457672119140625f) + (_1454 * 0.100000001490116119384765625f)) + ((clamp(abs(cos(_1455 * 350.0f)), 0.0f, 1.0f) + clamp(abs(cos(_1448 * 350.0f)), 0.0f, 1.0f)) * 0.1799999773502349853515625f))) + 0.9900000095367431640625f;
      float _2340 = (_2079.x * 2.0f) * _2338;
      float _2341 = (_2083.y * 2.0f) * _2338;
      float _2342 = (_2090.z * 2.0f) * _2338;
      float _2343 = dot(float3(_2340, _2341, _2342), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _2370 = cb6[5u].x * _1411;
      float4 _2372 = _22.SampleLevel(_46, float2(_1426, _1427), cb6[5u].y);
      _2167 = (((((_2340 - _2343) * cb6[6u].z) + _2343) * _1411) + ((((_2274 * (((_2258 - _2262) * cb6[6u].z) + _2262)) + _1995) * _2163) * _2309)) + (_2372.x * _2370);
      _2169 = (((((_2341 - _2343) * cb6[6u].z) + _2343) * _1411) + ((((_2274 * (((_2259 - _2262) * cb6[6u].z) + _2262)) + _1996) * _2163) * _2309)) + (_2372.y * _2370);
      _2171 = (((((_2342 - _2343) * cb6[6u].z) + _2343) * _1411) + ((((_2274 * (((_2260 - _2262) * cb6[6u].z) + _2262)) + _1997) * _2163) * _2309)) + (_2372.z * _2370);
    } else {
      _2167 = _1995;
      _2169 = _1996;
      _2171 = _1997;
    }
    float _122;
    float _125;
    float _128;
    if (uiStaticStrength > 0.0f) {
      float4 _2380 = textureUI.Load(int3(uint2(_85, _86), 0u));
      float _2386 = (_1411 * 2.0f) * uiStaticStrength;
      _122 = (_2386 * _2380.x) + _2167;
      _125 = (_2386 * _2380.y) + _2169;
      _128 = (_2386 * _2380.z) + _2171;
    } else {
      _122 = _2167;
      _125 = _2169;
      _128 = _2171;
    }
    float frontier_phi_1_57_ladder;
    float frontier_phi_1_57_ladder_1;
    float frontier_phi_1_57_ladder_2;
    if (_306) {
      float _2470;
      float _2472;
      float _2474;
      float _2476;
      float _2478;
      float _2480;
      uint _2482;
      _2470 = 1.0f;
      _2472 = 1.0f;
      _2474 = 1.0f;
      _2476 = ((_87 / _99) * 0.800000011920928955078125f) * (_99 / _100);
      _2478 = (_88 / _100) * 5.0f;
      _2480 = 1.0f;
      _2482 = 1u;
      float _2471;
      float _2473;
      float _2475;
      for (;;) {
        // Looks like hash44
        float _2484 = float(int(_2482));
        float _2485 = _2484 + _2476;
        float _2486 = _2484 + _2478;
        float _2487 = floor(_2485);
        float _2488 = floor(_2486);
        float _2496 = frac(_2487 * 0.103100001811981201171875f);
        float _2497 = frac(_2488 * 0.10300000011920928955078125f);
        float _2498 = frac(_2487 * 0.097300000488758087158203125f);
        float _2499 = frac(_2488 * 0.109899997711181640625f);
        float _2504 = dot(float4(_2496, _2497, _2498, _2499), float4(_2499 + 33.3300018310546875f, _2498 + 33.3300018310546875f, _2496 + 33.3300018310546875f, _2497 + 33.3300018310546875f));
        float _2507 = _2504 + _2496;
        float _2508 = _2504 + _2497;
        float _2509 = _2504 + _2498;
        float _2510 = _2504 + _2499;
        float _2519 = frac((_2507 + _2508) * _2509);
        float _2520 = frac((_2507 + _2509) * _2508);
        float _2521 = frac((_2508 + _2509) * _2510);
        bool _2540 = frac((_2509 + _2510) * _2507) > 0.5f;
        _2471 = (_2540 ? _2519 : 1.0f) * _2470;
        _2473 = (_2540 ? _2520 : 1.0f) * _2472;
        _2475 = (_2540 ? _2521 : 1.0f) * _2474;
        uint _2483 = _2482 + 1u;
        if (_2483 == 15u) {
          break;
        } else {
          _2470 = _2471;
          _2472 = _2473;
          _2474 = _2475;
          _2476 = (((_2521 * 0.20000000298023223876953125f) * (frac(_2485) - _2480)) * frac(floor(((cb0[0u].x * 0.1500000059604644775390625f) + 300.0f) / _2519) * _2519)) + _2476;
          _2478 = ((_2521 * _2520) * (frac(_2486) - _2480)) + _2478;
          _2480 *= (-2.0f);
          _2482 = _2483;
        }
      }
      float _2558 = floor((cb0[0u].x * 2.0f) + uiDeathOverlay);
      float _2559 = _2558 * 0.00999999977648258209228515625f;
      float _2569 = ((_2559 + 1.0f) - (floor(_2558 * 9.9999997473787516355514526367188e-05f) * 100.0f)) * 0.00999999977648258209228515625f;
      float _2570 = ((_2558 + 1.0f) - (floor(_2559) * 100.0f)) * 0.00999999977648258209228515625f;
      float _2575 = 0.5f - (uiDeathOverlay * 0.375f);
      float _2576 = (uiDeathOverlay * 0.75f) + (-0.100000001490116119384765625f);
      float _2579 = frac((((floor(_1111 * 10.0f) * 0.100000001490116119384765625f) + 0.0500000007450580596923828125f) + _2569) * 0.103100001811981201171875f);
      float _2580 = frac((((floor(_1112 * 33.33333587646484375f) * 0.02999999932944774627685546875f) + 0.014999999664723873138427734375f) + _2570) * 0.103100001811981201171875f);
      float _2582 = _2579 + 33.3300018310546875f;
      float _2583 = dot(float3(_2579, _2580, _2579), float3(_2580 + 33.3300018310546875f, _2582, _2582));
      float _2591 = frac(((_2580 + _2579) + (_2583 * 2.0f)) * (_2583 + _2579));
      float _2594 = ((1.0f - _2591) * _2576) + _2591;
      float _2615 = frac((((floor(_1111 * 11.111110687255859375f) * 0.0900000035762786865234375f) + 0.04500000178813934326171875f) + _2569) * 0.103100001811981201171875f);
      float _2616 = frac((((floor(_1112 * 25.0f) * 0.039999999105930328369140625f) + 0.0199999995529651641845703125f) + _2570) * 0.103100001811981201171875f);
      float _2618 = _2615 + 33.3300018310546875f;
      float _2619 = dot(float3(_2615, _2616, _2615), float3(_2616 + 33.3300018310546875f, _2618, _2618));
      float _2627 = frac(((_2616 + _2615) + (_2619 * 2.0f)) * (_2619 + _2615));
      float _2630 = ((1.0f - _2627) * _2576) + _2627;
      float _2634 = max(0.0f, _2471);
      float _2635 = max(0.0f, _2473);
      float _2636 = max(0.0f, _2475);
      float _2638 = max(_2634, max(_2635, _2636));
      float _2639 = _2638 * _2638;
      float _2640 = _2634 * 2.0f;
      float _2641 = _2635 * 0.100000001490116119384765625f;
      float _2642 = _2636 * 0.25f;
      float _2650 = clamp((round(_2594 - (_2594 * _2575)) * 5.0f) * round(_2630 - (_2630 * _2575)), 0.0f, 1.0f) * 3.0f;
      frontier_phi_1_57_ladder = (((_2641 - _125) + (_2639 * _2641)) * _2650) + _125;
      frontier_phi_1_57_ladder_1 = (((_2642 - _128) + (_2639 * _2642)) * _2650) + _128;
      frontier_phi_1_57_ladder_2 = (((_2640 - _122) + (_2639 * _2640)) * _2650) + _122;
    } else {
      frontier_phi_1_57_ladder = _125;
      frontier_phi_1_57_ladder_1 = _128;
      frontier_phi_1_57_ladder_2 = _122;
    }
    _119 = frontier_phi_1_57_ladder_2;
    _123 = frontier_phi_1_57_ladder;
    _126 = frontier_phi_1_57_ladder_1;
  }
  bool _134 = asuint(cb6[15u]).x == 0u;
  float _311;
  float _314;
  float _316;
  if (_134) {
    _311 = _312;
    _314 = _312;
    _316 = _312;
  } else {
    float4 _323 = textureRender.Load(int3(uint2(_85, _86), 0u));
    float _326 = _323.x;
    float _327 = _323.y;
    float _328 = _323.z;
    float _795;
    float _796;
    float _797;
    if (uiOutline > 0.0f) {
      float4 _636 = textureNoise.Load(int3(uint2(_85 & 255u, _86 & 255u), 0u));
      if (injectedData.fxFilmGrain) {
        float3 grainedColor = computeFilmGrain(
          float3(_326, _327, _328),
          _636.xy,
          frac(cb0[0u].x / 1000.f),
          injectedData.fxFilmGrain * 0.03f,
          (uiPaperWhiteScaler == 1.f) ? 1.f : (203.f / 100.f)
        );
        _795 = grainedColor.r;
        _796 = grainedColor.g;
        _797 = grainedColor.b;
      } else {
        uint _632 = 1u << (_12.Load(int3(uint2(uint(_39_m0[79u].x * _87), uint(_39_m0[79u].y * _88)), 0u)).y & 31u);
        float _638 = _636.x;
        float _639 = _636.y;
        float _640 = _636.z;
        float _643 = ((_638 + _639) + _640) * 0.3333333432674407958984375f;
        float _645 = uiOutline * _326;
        float _646 = uiOutline * _327;
        float _647 = uiOutline * _328;
        float _662 = _638 - _643;
        float _663 = _639 - _643;
        float _664 = _640 - _643;
        float _668 = _643 + (-0.5f);
        uint4 _681 = asuint(cb6[17u]);
        float _685 = float(min((_681.x & _632), 1u));
        float _714 = float(min((_681.y & _632), 1u));
        float _743 = float(min((_681.z & _632), 1u));
        float _772 = float(min((_681.w & _632), 1u));
        float _779 = (((((((_668 + (cb6[18u].w * _662)) * cb6[18u].x) * _685) + 1.0f) * (_645 / max(1.0f - _645, 9.9999999747524270787835121154785e-07f))) * ((((_668 + (cb6[19u].w * _662)) * cb6[19u].x) * _714) + 1.0f)) * ((((_668 + (cb6[20u].w * _662)) * cb6[20u].x) * _743) + 1.0f)) * ((((_668 + (cb6[21u].w * _662)) * cb6[21u].x) * _772) + 1.0f);
        float _780 = (((((((_668 + (cb6[18u].w * _663)) * cb6[18u].y) * _685) + 1.0f) * (_646 / max(1.0f - _646, 9.9999999747524270787835121154785e-07f))) * ((((_668 + (cb6[19u].w * _663)) * cb6[19u].y) * _714) + 1.0f)) * ((((_668 + (cb6[20u].w * _663)) * cb6[20u].y) * _743) + 1.0f)) * ((((_668 + (cb6[21u].w * _663)) * cb6[21u].y) * _772) + 1.0f);
        float _781 = (((((((_668 + (cb6[18u].w * _664)) * cb6[18u].z) * _685) + 1.0f) * (_647 / max(1.0f - _647, 9.9999999747524270787835121154785e-07f))) * ((((_668 + (cb6[19u].w * _664)) * cb6[19u].z) * _714) + 1.0f)) * ((((_668 + (cb6[20u].w * _664)) * cb6[20u].z) * _743) + 1.0f)) * ((((_668 + (cb6[21u].w * _664)) * cb6[21u].z) * _772) + 1.0f);
        _795 = uiPaperWhiteScaler * (_779 / max(_779 + 1.0f, 1.0f));
        _796 = uiPaperWhiteScaler * (_780 / max(_780 + 1.0f, 1.0f));
        _797 = uiPaperWhiteScaler * (_781 / max(_781 + 1.0f, 1.0f));
      }
    } else {
      _795 = _326;
      _796 = _327;
      _797 = _328;
    }
    float frontier_phi_3_10_ladder;
    float frontier_phi_3_10_ladder_1;
    float frontier_phi_3_10_ladder_2;
    if (_118) {
      frontier_phi_3_10_ladder = 0.0f;
      frontier_phi_3_10_ladder_1 = 0.0f;
      frontier_phi_3_10_ladder_2 = 0.0f;
    } else {
      float4 _1203 = _16.SampleLevel(_46, float2(_101, _102), 0.0f);
      float4 _1210 = _15.SampleLevel(_46, float2(_101, _102), 0.0f);
      float _1215 = _1210.w;
      float _1216 = 1.0f - _1215;
      float _1221 = (_1216 * _1203.w) + _1215;
      frontier_phi_3_10_ladder = ((_1221 * ((_1210.z - _797) + (_1216 * _1203.z))) + _797) * hudMaskStrength;
      frontier_phi_3_10_ladder_1 = ((_1221 * ((_1210.y - _796) + (_1216 * _1203.y))) + _796) * hudMaskStrength;
      frontier_phi_3_10_ladder_2 = ((_1221 * ((_1210.x - _795) + (_1216 * _1203.x))) + _795) * hudMaskStrength;
    }
    _311 = frontier_phi_3_10_ladder_2;
    _314 = frontier_phi_3_10_ladder_1;
    _316 = frontier_phi_3_10_ladder;
  }
  float _606;
  float _608;
  float _610;
  if (cb6[14u].w > 0.0f) {
    uint4 _594 = asuint(cb6[10u]);
    uint _595 = _594.x;
    uint _597 = _594.z;
    uint _600 = _594.y;
    uint _603 = _594.w;
    float frontier_phi_8_7_ladder;
    float frontier_phi_8_7_ladder_1;
    float frontier_phi_8_7_ladder_2;
    if ((((_85 >= _595) && (_85 < _597)) && (_86 >= _600)) && (_86 < _603)) {
      float4 _1152 = _24.SampleLevel(_46, float2((cb6[11u].z * ((_87 - float(int(_595))) / float(int(_597 - _595)))) + cb6[11u].x, (cb6[11u].w * ((_88 - float(int(_600))) / float(int(_603 - _600)))) + cb6[11u].y), 0.0f);
      frontier_phi_8_7_ladder = _1152.y * cb6[14u].w;
      frontier_phi_8_7_ladder_1 = _1152.x * cb6[14u].w;
      frontier_phi_8_7_ladder_2 = _1152.z * cb6[14u].w;
    } else {
      frontier_phi_8_7_ladder = _123;
      frontier_phi_8_7_ladder_1 = _119;
      frontier_phi_8_7_ladder_2 = _126;
    }
    _606 = frontier_phi_8_7_ladder_1;
    _608 = frontier_phi_8_7_ladder;
    _610 = frontier_phi_8_7_ladder_2;
  } else {
    _606 = _119;
    _608 = _123;
    _610 = _126;
  }
  uint4 _615 = asuint(cb6[13u]);
  float _1158;
  float _1164;
  float _1170;
  // color conversion
  if (_615.y == 0u) {
    _1158 = _606;
    _1164 = _608;
    _1170 = _610;
  } else {
    uint _1200 = _615.w;
    float _1538;
    float _1539;
    float _1540;
    if (cb6[14u].z != 1.0f) {
      _1538 = pow(_606, cb6[14u].z);
      _1539 = pow(_608, cb6[14u].z);
      _1540 = pow(_610, cb6[14u].z);
    } else {
      _1538 = _606;
      _1539 = _608;
      _1540 = _610;
    }
    float _1550 = frac(_87 * 211.1488037109375f);
    float _1551 = frac(_88 * 210.944000244140625f);
    float _1552 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _1555 = _1552 + 33.3300018310546875f;
    float _1556 = dot(float3(_1550, _1551, _1552), float3(_1551 + 33.3300018310546875f, _1550 + 33.3300018310546875f, _1555));
    float _1559 = _1556 + _1550;
    float _1560 = _1556 + _1551;
    float _1562 = _1559 + _1560;
    float _1567 = frac(_1562 * (_1556 + _1552));
    float _1568 = frac((_1559 * 2.0f) * _1560);
    float _1569 = frac(_1562 * _1559);
    float _1575 = frac((_87 + 64.0f) * 211.1488037109375f);
    float _1576 = frac((_88 + 64.0f) * 210.944000244140625f);
    float _1579 = dot(float3(_1575, _1576, _1552), float3(_1576 + 33.3300018310546875f, _1575 + 33.3300018310546875f, _1555));
    float _1582 = _1579 + _1575;
    float _1583 = _1579 + _1576;
    float _1585 = _1582 + _1583;
    float _1590 = frac(_1585 * (_1579 + _1552));
    float _1591 = frac((_1582 * 2.0f) * _1583);
    float _1592 = frac(_1585 * _1582);
    float frontier_phi_16_25_ladder;
    float frontier_phi_16_25_ladder_1;
    float frontier_phi_16_25_ladder_2;
    if (_1200 == 0u) {
      float _1728 = (_1538 <= 0.003130800090730190277099609375f) ? (_1538 * 12.9200000762939453125f) : ((exp2(log2(abs(_1538)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _1729 = (_1539 <= 0.003130800090730190277099609375f) ? (_1539 * 12.9200000762939453125f) : ((exp2(log2(abs(_1539)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _1730 = (_1540 <= 0.003130800090730190277099609375f) ? (_1540 * 12.9200000762939453125f) : ((exp2(log2(abs(_1540)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _1731 = _1728 * 510.0f;
      float _1733 = _1729 * 510.0f;
      float _1734 = _1730 * 510.0f;
      frontier_phi_16_25_ladder = (((_1569 + (-0.5f)) + (min(min(1.0f, _1734), 510.0f - _1734) * (_1592 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _1730;
      frontier_phi_16_25_ladder_1 = (((_1567 + (-0.5f)) + (min(min(1.0f, _1731), 510.0f - _1731) * (_1590 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _1728;
      frontier_phi_16_25_ladder_2 = (((_1568 + (-0.5f)) + (min(min(1.0f, _1733), 510.0f - _1733) * (_1591 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _1729;
    } else {
      float frontier_phi_16_25_ladder_33_ladder;
      float frontier_phi_16_25_ladder_33_ladder_1;
      float frontier_phi_16_25_ladder_33_ladder_2;
      if (_1200 == 1u) {
        float _1877 = mad(0.043306000530719757080078125f, _1540, mad(0.329291999340057373046875f, _1539, _1538 * 0.627402007579803466796875f));
        float _1883 = mad(0.011359999887645244598388671875f, _1540, mad(0.9195439815521240234375f, _1539, _1538 * 0.06909500062465667724609375f));
        float _1889 = mad(0.89557802677154541015625f, _1540, mad(0.08802799880504608154296875f, _1539, _1538 * 0.0163940005004405975341796875f));
        float _1925 = exp2(log2(abs((((clamp(mad(_1889, cb6[22u].z, mad(_1883, cb6[22u].y, _1877 * cb6[22u].x)), 0.0f, 1.0f) - _1877) * cb6[16u].x) + _1877) * cb6[14u].x)) * 0.1593017578125f);
        float _1926 = exp2(log2(abs((((clamp(mad(_1889, cb6[23u].z, mad(_1883, cb6[23u].y, _1877 * cb6[23u].x)), 0.0f, 1.0f) - _1883) * cb6[16u].x) + _1883) * cb6[14u].x)) * 0.1593017578125f);
        float _1927 = exp2(log2(abs((((clamp(mad(_1889, cb6[24u].z, mad(_1883, cb6[24u].y, _1877 * cb6[24u].x)), 0.0f, 1.0f) - _1889) * cb6[16u].x) + _1889) * cb6[14u].x)) * 0.1593017578125f);
        frontier_phi_16_25_ladder_33_ladder = exp2(log2(abs(((_1927 * 18.8515625f) + 0.8359375f) / ((_1927 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_16_25_ladder_33_ladder_1 = exp2(log2(abs(((_1925 * 18.8515625f) + 0.8359375f) / ((_1925 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_16_25_ladder_33_ladder_2 = exp2(log2(abs(((_1926 * 18.8515625f) + 0.8359375f) / ((_1926 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_16_25_ladder_33_ladder_41_ladder;
        float frontier_phi_16_25_ladder_33_ladder_41_ladder_1;
        float frontier_phi_16_25_ladder_33_ladder_41_ladder_2;
        if (_1200 == 2u) {
          frontier_phi_16_25_ladder_33_ladder_41_ladder = _1540 * cb6[14u].x;
          frontier_phi_16_25_ladder_33_ladder_41_ladder_1 = _1538 * cb6[14u].x;
          frontier_phi_16_25_ladder_33_ladder_41_ladder_2 = _1539 * cb6[14u].x;
        } else {
          float frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder;
          float frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_1;
          float frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_2;
          if (_1200 == 3u) {
            float _2185 = mad(_1540, cb6[22u].z, mad(_1539, cb6[22u].y, _1538 * cb6[22u].x)) * cb6[14u].x;
            float _2186 = mad(_1540, cb6[23u].z, mad(_1539, cb6[23u].y, _1538 * cb6[23u].x)) * cb6[14u].x;
            float _2187 = mad(_1540, cb6[24u].z, mad(_1539, cb6[24u].y, _1538 * cb6[24u].x)) * cb6[14u].x;
            float _2212 = (_2185 <= 0.003130800090730190277099609375f) ? (_2185 * 12.9200000762939453125f) : ((exp2(log2(abs(_2185)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _2213 = (_2186 <= 0.003130800090730190277099609375f) ? (_2186 * 12.9200000762939453125f) : ((exp2(log2(abs(_2186)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _2214 = (_2187 <= 0.003130800090730190277099609375f) ? (_2187 * 12.9200000762939453125f) : ((exp2(log2(abs(_2187)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _2215 = _2212 * 2046.0f;
            float _2217 = _2213 * 2046.0f;
            float _2218 = _2214 * 2046.0f;
            frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder = (((_1569 + (-0.5f)) + (min(min(1.0f, _2218), 2046.0f - _2218) * (_1592 + (-0.5f)))) * 0.000977517105638980865478515625f) + _2214;
            frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_1 = (((_1567 + (-0.5f)) + (min(min(1.0f, _2215), 2046.0f - _2215) * (_1590 + (-0.5f)))) * 0.000977517105638980865478515625f) + _2212;
            frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_2 = (((_1568 + (-0.5f)) + (min(min(1.0f, _2217), 2046.0f - _2217) * (_1591 + (-0.5f)))) * 0.000977517105638980865478515625f) + _2213;
          } else {
            frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder = (_1540 * cb6[14u].x) + cb6[14u].y;
            frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_1 = (_1538 * cb6[14u].x) + cb6[14u].y;
            frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_2 = (_1539 * cb6[14u].x) + cb6[14u].y;
          }
          frontier_phi_16_25_ladder_33_ladder_41_ladder = frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder;
          frontier_phi_16_25_ladder_33_ladder_41_ladder_1 = frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_1;
          frontier_phi_16_25_ladder_33_ladder_41_ladder_2 = frontier_phi_16_25_ladder_33_ladder_41_ladder_47_ladder_2;
        }
        frontier_phi_16_25_ladder_33_ladder = frontier_phi_16_25_ladder_33_ladder_41_ladder;
        frontier_phi_16_25_ladder_33_ladder_1 = frontier_phi_16_25_ladder_33_ladder_41_ladder_1;
        frontier_phi_16_25_ladder_33_ladder_2 = frontier_phi_16_25_ladder_33_ladder_41_ladder_2;
      }
      frontier_phi_16_25_ladder = frontier_phi_16_25_ladder_33_ladder;
      frontier_phi_16_25_ladder_1 = frontier_phi_16_25_ladder_33_ladder_1;
      frontier_phi_16_25_ladder_2 = frontier_phi_16_25_ladder_33_ladder_2;
    }
    _1158 = frontier_phi_16_25_ladder_1;
    _1164 = frontier_phi_16_25_ladder_2;
    _1170 = frontier_phi_16_25_ladder;
  }
  float _1473;
  float _1479;
  float _1485;
  if (_134) {
    _1473 = _311;
    _1479 = _314;
    _1485 = _316;
  } else {
    uint _1524 = _615.w;
    float _1647;
    float _1648;
    float _1649;
    if (cb6[15u].w != 1.0f) {
      _1647 = exp2(log2(abs(_311)) * cb6[15u].w);
      _1648 = exp2(log2(abs(_314)) * cb6[15u].w);
      _1649 = exp2(log2(abs(_316)) * cb6[15u].w);
    } else {
      _1647 = _311;
      _1648 = _314;
      _1649 = _316;
    }
    float _1656 = frac(_87 * 211.1488037109375f);
    float _1657 = frac(_88 * 210.944000244140625f);
    float _1658 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _1661 = _1658 + 33.3300018310546875f;
    float _1662 = dot(float3(_1656, _1657, _1658), float3(_1657 + 33.3300018310546875f, _1656 + 33.3300018310546875f, _1661));
    float _1665 = _1662 + _1656;
    float _1666 = _1662 + _1657;
    float _1668 = _1665 + _1666;
    float _1673 = frac(_1668 * (_1662 + _1658));
    float _1674 = frac((_1665 * 2.0f) * _1666);
    float _1675 = frac(_1668 * _1665);
    float _1680 = frac((_87 + 64.0f) * 211.1488037109375f);
    float _1681 = frac((_88 + 64.0f) * 210.944000244140625f);
    float _1684 = dot(float3(_1680, _1681, _1658), float3(_1681 + 33.3300018310546875f, _1680 + 33.3300018310546875f, _1661));
    float _1687 = _1684 + _1680;
    float _1688 = _1684 + _1681;
    float _1690 = _1687 + _1688;
    float _1695 = frac(_1690 * (_1684 + _1658));
    float _1696 = frac((_1687 * 2.0f) * _1688);
    float _1697 = frac(_1690 * _1687);
    float frontier_phi_22_31_ladder;
    float frontier_phi_22_31_ladder_1;
    float frontier_phi_22_31_ladder_2;
    if (_1524 == 0u) {
      float _1842 = (_1647 <= 0.003130800090730190277099609375f) ? (_1647 * 12.9200000762939453125f) : ((exp2(log2(abs(_1647)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _1843 = (_1648 <= 0.003130800090730190277099609375f) ? (_1648 * 12.9200000762939453125f) : ((exp2(log2(abs(_1648)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _1844 = (_1649 <= 0.003130800090730190277099609375f) ? (_1649 * 12.9200000762939453125f) : ((exp2(log2(abs(_1649)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _1845 = _1842 * 510.0f;
      float _1846 = _1843 * 510.0f;
      float _1847 = _1844 * 510.0f;
      frontier_phi_22_31_ladder = (((_1673 + (-0.5f)) + (min(min(1.0f, _1845), 510.0f - _1845) * (_1695 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _1842;
      frontier_phi_22_31_ladder_1 = (((_1675 + (-0.5f)) + (min(min(1.0f, _1847), 510.0f - _1847) * (_1697 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _1844;
      frontier_phi_22_31_ladder_2 = (((_1674 + (-0.5f)) + (min(min(1.0f, _1846), 510.0f - _1846) * (_1696 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _1843;
    } else {
      float frontier_phi_22_31_ladder_39_ladder;
      float frontier_phi_22_31_ladder_39_ladder_1;
      float frontier_phi_22_31_ladder_39_ladder_2;
      if (_1524 == 1u) {
        float _2002 = mad(0.043306000530719757080078125f, _1649, mad(0.329291999340057373046875f, _1648, _1647 * 0.627402007579803466796875f));
        float _2005 = mad(0.011359999887645244598388671875f, _1649, mad(0.9195439815521240234375f, _1648, _1647 * 0.06909500062465667724609375f));
        float _2008 = mad(0.89557802677154541015625f, _1649, mad(0.08802799880504608154296875f, _1648, _1647 * 0.0163940005004405975341796875f));
        float _2042 = exp2(log2(abs((((clamp(mad(_2008, cb6[26u].z, mad(_2005, cb6[26u].y, _2002 * cb6[26u].x)), 0.0f, 1.0f) - _2002) * cb6[16u].x) + _2002) * cb6[15u].y)) * 0.1593017578125f);
        float _2043 = exp2(log2(abs((((clamp(mad(_2008, cb6[27u].z, mad(_2005, cb6[27u].y, _2002 * cb6[27u].x)), 0.0f, 1.0f) - _2005) * cb6[16u].x) + _2005) * cb6[15u].y)) * 0.1593017578125f);
        float _2044 = exp2(log2(abs((((clamp(mad(_2008, cb6[28u].z, mad(_2005, cb6[28u].y, _2002 * cb6[28u].x)), 0.0f, 1.0f) - _2008) * cb6[16u].x) + _2008) * cb6[15u].y)) * 0.1593017578125f);
        frontier_phi_22_31_ladder_39_ladder = exp2(log2(abs(((_2042 * 18.8515625f) + 0.8359375f) / ((_2042 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_22_31_ladder_39_ladder_1 = exp2(log2(abs(((_2044 * 18.8515625f) + 0.8359375f) / ((_2044 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_22_31_ladder_39_ladder_2 = exp2(log2(abs(((_2043 * 18.8515625f) + 0.8359375f) / ((_2043 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_22_31_ladder_39_ladder_45_ladder;
        float frontier_phi_22_31_ladder_39_ladder_45_ladder_1;
        float frontier_phi_22_31_ladder_39_ladder_45_ladder_2;
        if (_1524 == 2u) {
          frontier_phi_22_31_ladder_39_ladder_45_ladder = _1647 * cb6[15u].y;
          frontier_phi_22_31_ladder_39_ladder_45_ladder_1 = _1649 * cb6[15u].y;
          frontier_phi_22_31_ladder_39_ladder_45_ladder_2 = _1648 * cb6[15u].y;
        } else {
          float frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder;
          float frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_1;
          float frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_2;
          if (_1524 == 3u) {
            float _2402 = mad(_1649, cb6[26u].z, mad(_1648, cb6[26u].y, _1647 * cb6[26u].x)) * cb6[15u].y;
            float _2403 = mad(_1649, cb6[27u].z, mad(_1648, cb6[27u].y, _1647 * cb6[27u].x)) * cb6[15u].y;
            float _2404 = mad(_1649, cb6[28u].z, mad(_1648, cb6[28u].y, _1647 * cb6[28u].x)) * cb6[15u].y;
            float _2429 = (_2402 <= 0.003130800090730190277099609375f) ? (_2402 * 12.9200000762939453125f) : ((exp2(log2(abs(_2402)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _2430 = (_2403 <= 0.003130800090730190277099609375f) ? (_2403 * 12.9200000762939453125f) : ((exp2(log2(abs(_2403)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _2431 = (_2404 <= 0.003130800090730190277099609375f) ? (_2404 * 12.9200000762939453125f) : ((exp2(log2(abs(_2404)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _2432 = _2429 * 2046.0f;
            float _2433 = _2430 * 2046.0f;
            float _2434 = _2431 * 2046.0f;
            frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder = (((_1673 + (-0.5f)) + (min(min(1.0f, _2432), 2046.0f - _2432) * (_1695 + (-0.5f)))) * 0.000977517105638980865478515625f) + _2429;
            frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_1 = (((_1675 + (-0.5f)) + (min(min(1.0f, _2434), 2046.0f - _2434) * (_1697 + (-0.5f)))) * 0.000977517105638980865478515625f) + _2431;
            frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_2 = (((_1674 + (-0.5f)) + (min(min(1.0f, _2433), 2046.0f - _2433) * (_1696 + (-0.5f)))) * 0.000977517105638980865478515625f) + _2430;
          } else {
            frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder = (_1647 * cb6[15u].y) + cb6[15u].z;
            frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_1 = (_1649 * cb6[15u].y) + cb6[15u].z;
            frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_2 = (_1648 * cb6[15u].y) + cb6[15u].z;
          }
          frontier_phi_22_31_ladder_39_ladder_45_ladder = frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder;
          frontier_phi_22_31_ladder_39_ladder_45_ladder_1 = frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_1;
          frontier_phi_22_31_ladder_39_ladder_45_ladder_2 = frontier_phi_22_31_ladder_39_ladder_45_ladder_51_ladder_2;
        }
        frontier_phi_22_31_ladder_39_ladder = frontier_phi_22_31_ladder_39_ladder_45_ladder;
        frontier_phi_22_31_ladder_39_ladder_1 = frontier_phi_22_31_ladder_39_ladder_45_ladder_1;
        frontier_phi_22_31_ladder_39_ladder_2 = frontier_phi_22_31_ladder_39_ladder_45_ladder_2;
      }
      frontier_phi_22_31_ladder = frontier_phi_22_31_ladder_39_ladder;
      frontier_phi_22_31_ladder_1 = frontier_phi_22_31_ladder_39_ladder_1;
      frontier_phi_22_31_ladder_2 = frontier_phi_22_31_ladder_39_ladder_2;
    }
    _1473 = frontier_phi_22_31_ladder;
    _1479 = frontier_phi_22_31_ladder_2;
    _1485 = frontier_phi_22_31_ladder_1;
  }
  _27[uint2(_85, _86)] = float4(_1158, _1164, _1170, 1.0f);
  if (!(asuint(cb6[15u]).x == 0u)) {
    _28[uint2(_85, _86)] = float4(_1473, _1479, _1485, 1.0f);
  }
}

[numthreads(16, 16, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
