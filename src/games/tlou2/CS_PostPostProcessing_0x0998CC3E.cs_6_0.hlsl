#include "./common.hlsli"

struct PostProcessingShaderConst {
  float4 PostProcessingShaderConst_000[4];
  float4 PostProcessingShaderConst_064[4];
  float4 PostProcessingShaderConst_128;
  float4 PostProcessingShaderConst_144;
  float4 PostProcessingShaderConst_160;
  float4 PostProcessingShaderConst_176;
  float4 PostProcessingShaderConst_192;
  float4 PostProcessingShaderConst_208;
  float4 PostProcessingShaderConst_224;
  float4 PostProcessingShaderConst_240;
  float4 PostProcessingShaderConst_256;
  float4 PostProcessingShaderConst_272;
  float4 PostProcessingShaderConst_288;
  float4 PostProcessingShaderConst_304;
  float4 PostProcessingShaderConst_320;
  float4 PostProcessingShaderConst_336;
  float4 PostProcessingShaderConst_352;
  float4 PostProcessingShaderConst_368;
  float4 PostProcessingShaderConst_384;
  float4 PostProcessingShaderConst_400;
  float4 PostProcessingShaderConst_416;
  float4 PostProcessingShaderConst_432;
  float4 PostProcessingShaderConst_448;
  float4 PostProcessingShaderConst_464;
  float4 PostProcessingShaderConst_480;
  float4 PostProcessingShaderConst_496;
  int PostProcessingShaderConst_512;
  int PostProcessingShaderConst_516;
  float2 PostProcessingShaderConst_520;
  float2 PostProcessingShaderConst_528;
  float2 PostProcessingShaderConst_536;
  float2 PostProcessingShaderConst_544;
  float2 PostProcessingShaderConst_552;
  float2 PostProcessingShaderConst_560;
  float2 PostProcessingShaderConst_568;
  float2 PostProcessingShaderConst_576;
  float PostProcessingShaderConst_584;
  float PostProcessingShaderConst_588;
  float PostProcessingShaderConst_592;
  float PostProcessingShaderConst_596;
  float PostProcessingShaderConst_600;
  float PostProcessingShaderConst_604;
  float PostProcessingShaderConst_608;
  float PostProcessingShaderConst_612;
  float PostProcessingShaderConst_616;
  int PostProcessingShaderConst_620;
  int PostProcessingShaderConst_624;
  int PostProcessingShaderConst_628;
  int PostProcessingShaderConst_632;
  int PostProcessingShaderConst_636;
  float PostProcessingShaderConst_640;
  float PostProcessingShaderConst_644;
  float PostProcessingShaderConst_648;
  float PostProcessingShaderConst_652;
  float PostProcessingShaderConst_656;
  float PostProcessingShaderConst_660;
  float PostProcessingShaderConst_664;
  float PostProcessingShaderConst_668;
  float PostProcessingShaderConst_672;
  float PostProcessingShaderConst_676;
  int PostProcessingShaderConst_680;
  float PostProcessingShaderConst_684;
  float PostProcessingShaderConst_688;
  int PostProcessingShaderConst_692;
  float PostProcessingShaderConst_696;
  float PostProcessingShaderConst_700;
  int PostProcessingShaderConst_704;
  float PostProcessingShaderConst_708;
  float PostProcessingShaderConst_712;
  int PostProcessingShaderConst_716;
  int PostProcessingShaderConst_720;
  float PostProcessingShaderConst_724;
  float PostProcessingShaderConst_728;
  float PostProcessingShaderConst_732;
  float PostProcessingShaderConst_736;
  float PostProcessingShaderConst_740;
  float PostProcessingShaderConst_744;
  float PostProcessingShaderConst_748;
  float PostProcessingShaderConst_752;
  float PostProcessingShaderConst_756;
  float PostProcessingShaderConst_760;
  int PostProcessingShaderConst_764;
  int PostProcessingShaderConst_768;
  int PostProcessingShaderConst_772;
  float PostProcessingShaderConst_776;
  float PostProcessingShaderConst_780;
  float PostProcessingShaderConst_784;
  float PostProcessingShaderConst_788;
  float PostProcessingShaderConst_792;
  float PostProcessingShaderConst_796;
  float PostProcessingShaderConst_800;
  float PostProcessingShaderConst_804;
  int PostProcessingShaderConst_808;
  float PostProcessingShaderConst_812;
  float PostProcessingShaderConst_816;
  float PostProcessingShaderConst_820;
  int PostProcessingShaderConst_824;
  int PostProcessingShaderConst_828;
  float PostProcessingShaderConst_832;
  float PostProcessingShaderConst_836;
  float PostProcessingShaderConst_840;
  float PostProcessingShaderConst_844;
  int PostProcessingShaderConst_848;
  int PostProcessingShaderConst_852;
  int PostProcessingShaderConst_856;
  float PostProcessingShaderConst_860;
  float PostProcessingShaderConst_864;
  float PostProcessingShaderConst_868;
  float PostProcessingShaderConst_872;
  float PostProcessingShaderConst_876;
};

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t2 : register(t2);

Texture2D<float3> t3 : register(t3);

Texture2D<float3> t7 : register(t7);

Texture2D<float3> t8 : register(t8);

Texture2D<float> t9 : register(t9);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t11 : register(t11);

Texture2D<float> t12 : register(t12);

Texture3D<float4> t17 : register(t17);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  PostProcessingShaderConst g_postPostProcessingShaderConst_000 : packoffset(c000.x);
};

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

// Reverse-engineering notes (inferred from data flow; original symbol names are unavailable):
//   t0       Main post-processed color input. It is sampled at the warped scene UV and by
//            the optional edge-blur modes.
//   t2       Screen-space offset/distortion field. Its XY channels perturb the scene UV.
//   t3       Film-grain/noise texture.
//   t7       Auxiliary full-screen image used by global blends, wipes, and an inset overlay.
//   t8/t9    Color plus scalar/depth-like mask for the first depth-aware overlay.
//   t10      Scalar contribution for the second optional overlay.
//   t11/t12  Color plus scalar/depth-like mask for the second depth-aware overlay.
//   t17      3D color-grading LUT applied to the auxiliary-image path.
//   u0       Final post-post-process output.
//
// High-level order of operations:
//   1. Build output UV and reject pixels outside the requested presentation aspect.
//   2. Read t2 and construct a distorted source UV.
//   3. Optionally apply a localized radial lens/scope warp.
//   4. Sample t0, including channel-separated samples for chromatic aberration.
//   5. Apply two optional per-channel contrast/color curves.
//   6. Add two optional depth-aware color/overlay contributions.
//   7. Apply a radial tint/vignette and localized lens attenuation.
//   8. Blend/wipe t7, optionally grade it through t17, and draw an optional inset.
//   9. Add signal-dependent film grain from t3.
//  10. Apply final RGB scale/bias and optional edge blur/fill/fade behavior.
//  11. Clamp negative RGB values and write u0 with alpha zero.
//
// The decompiler duplicated the same per-pixel pipeline for multiple aspect-ratio branches.
// The first copy below is annotated in detail; later copies perform the same stages.
static const float _global_0[8] = { -0.7071067690849304f, -0.7071067690849304f, 0.7071067690849304f, 0.7071067690849304f, 1.0f, -1.0f, 0.0f, 0.0f };
static const float _global_1[8] = { -0.7071067690849304f, 0.7071067690849304f, -0.7071067690849304f, 0.7071067690849304f, 0.0f, 0.0f, 1.0f, -1.0f };

float3 ApplyVanillaFilmGrain(float3 color, float2 output_uv) {
  if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_464.x == 0.0f) {
    return color;
  }

  if (CUSTOM_GRAIN_TYPE != 0.f && RENODX_TONE_MAP_TYPE != 0.f) {
    return color;
  }

  bool use_horizontal_position = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_480.y > 0.0f;
  float3 grain_signal = float3(
      select(use_horizontal_position, output_uv.x, color.x),
      select(use_horizontal_position, output_uv.x, color.y),
      select(use_horizontal_position, output_uv.x, color.z));
  float3 grain = t3.SampleLevel(
                     s1,
                     float2(
                         (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_448.x * output_uv.x) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_448.z,
                         (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_448.y * output_uv.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_448.w),
                     0.0f)
                 - 0.5f;
  float3 saturated_signal = saturate(grain_signal);

  grain *= g_postPostProcessingShaderConst_000.PostProcessingShaderConst_464.x * 0.30000001192092896f;
  grain *= (saturated_signal * (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_464.z - 1.0f)) + 1.0f;
  grain *= (saturated_signal * (1.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_464.y)) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_464.y;
  grain *= ((1.0f - ((saturated_signal * 4.0f) * (1.0f - saturated_signal))) * (1.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_480.x)) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_480.x;
  grain *= sqrt(saturate((grain_signal * 4.0f) * (1.0f - grain_signal)));
  return grain + grain_signal;
}

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _20;
  float _21;
  float _25;
  float _33;
  bool _45;
  bool _57;
  float _89;
  bool _115;
  float _166;
  float _167;
  float _168;
  float _169;
  float _170;
  float _171;
  int _172;
  float _204;
  float _244;
  float _245;
  float _297;
  float _298;
  float _299;
  float _323;
  float _324;
  float _325;
  float _384;
  float _385;
  float _386;
  int _387;
  float _421;
  float _429;
  float _430;
  float _431;
  float _436;
  float _437;
  float _438;
  float _457;
  float _458;
  float _459;
  int _460;
  float _494;
  float _495;
  float _496;
  float _541;
  float _542;
  float _543;
  float _556;
  float _557;
  float _558;
  float _578;
  float _579;
  float _580;
  float _614;
  float _615;
  float _616;
  float _653;
  float _654;
  float _655;
  float _720;
  float _721;
  float _722;
  float _823;
  float _824;
  float _825;
  int _901;
  float _902;
  float _903;
  float _904;
  float _905;
  float _906;
  float _907;
  float _988;
  float _989;
  float _990;
  float _991;
  float _992;
  float _993;
  int _994;
  float _1057;
  float _1058;
  float _1059;
  bool _64;
  bool _66;
  float _81;
  float _83;
  float _90;
  float _97;
  float _108;
  float4 _118;
  float _125;
  float _126;
  float _133;
  float _135;
  float _139;
  float _143;
  float _144;
  float _145;
  float _173;
  float _175;
  float _177;
  float _181;
  float _183;
  float _186;
  float _188;
  float _192;
  float _193;
  float4 _194;
  float _207;
  float _214;
  float _215;
  float _217;
  float _224;
  float _225;
  float _232;
  float4 _233;
  float4 _238;
  float _248;
  float _249;
  float _250;
  float _252;
  float _255;
  float _268;
  float _337;
  float _347;
  float _348;
  float4 _362;
  float _370;
  float _371;
  float _379;
  float _380;
  float _399;
  int _400;
  float _404;
  float _406;
  float _408;
  float _445;
  float3 _449;
  float _452;
  float _453;
  float _472;
  int _473;
  float _477;
  float _479;
  float _484;
  float _486;
  float _520;
  float _521;
  float _528;
  float _533;
  float _551;
  float3 _564;
  float3 _588;
  float _593;
  float _596;
  float _597;
  float _603;
  float4 _639;
  int _665;
  int _666;
  uint2 _667;
  float _673;
  float _692;
  float _694;
  float _695;
  float3 _697;
  float3 _703;
  float _709;
  float3 _745;
  float _837;
  float _838;
  float _839;
  float _852;
  float _859;
  float _866;
  uint _870;
  int _875;
  int _876;
  float _894;
  float _898;
  float _909;
  float4 _916;
  float _920;
  float _921;
  float _922;
  uint _930;
  float _936;
  float _950;
  uint _954;
  int _959;
  int _960;
  float _978;
  float _985;
  float _996;
  float _1007;
  float4 _1016;
  float _1020;
  float _1021;
  float _1022;
  uint _1030;
  float _1036;
  float _1049;
  // Step 1: convert the dispatch pixel to output-space coordinates and normalized UV.
  // Const_536 is the output texel size. Const_764/768 select and offset a horizontal view.
  _20 = float((int)((int)(SV_DispatchThreadID.x)));
  _21 = float((int)((int)(SV_DispatchThreadID.y)));
  _25 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y * (_21 + 0.5f);
  _33 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x * (_20 + 0.5f)) * float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_764))) + float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_768));
  // Feature gates: localized lens effect, radial tint, and two t7 compositing modes.
  _45 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 > 0.0f);
  if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.x > 0.5f) {
    _57 = (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.w == 0.0f));
  } else {
    _57 = false;
  }
  _64 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612 > 0.0f);
  _66 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_616 > 0.0f);
  // Step 2: presentation/aspect handling. For targets wider than 16:9, compute a
  // centered 16:9-height region and clear pixels in its top/bottom bars.
  if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_816 > 1.7777777910232544f) {
    _81 = (1.7777777910232544f / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_816) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.y;
    _83 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.y - _81) * 0.5f;
    if ((_21 < _83) || (_21 > (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.y - _83))) {
      _115 = true;
      do {
        if (_115) {
          u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(0.0f, 0.0f, 0.0f, 0.0f);
        } else {
          // Step 3: t2.xy is a sub-pixel distortion/offset field. Convert it through
          // the output texel size and offset the base UV before sampling the scene.
          _118 = t2.SampleLevel(s2, float2(_33, _25), 0.0f);
          _125 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x * 1.5f) * _118.x) + _33;
          _126 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y * 1.5f) * _118.y) + _25;
          do {
            _166 = 0.5f;
            _167 = 0.5f;
            _168 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592;
            _169 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596;
            _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
            _171 = 1.0f;
            _172 = 0;
            // Step 4: localized radial lens/scope deformation. Inside Const_796's
            // radius, blend center, barrel coefficient, zoom, and chromatic offset.
            if (_45) {
              _133 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y - _126;
              _135 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x - _125) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_800;
              _139 = sqrt((_135 * _135) + (_133 * _133));
              if (_139 < g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796) {
                _143 = _139 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796;
                _144 = saturate(_143);
                _145 = _144 * _144;
                _166 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x;
                _167 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y;
                _168 = (((((_145 * _145) * (_144 * 1.5f)) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592);
                _169 = (lerp(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596, 0.9200000166893005f, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792));
                _170 = ((((_143 * 0.02250000089406967f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600);
                _171 = (((_143 * (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_608 + -1.0f)) + 1.0f) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_604);
                _172 = 1;
              } else {
                _166 = 0.5f;
                _167 = 0.5f;
                _168 = -0.03500000014901161f;
                _169 = 1.0f;
                _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
                _171 = 1.0f;
                _172 = 0;
              }
            }
            _173 = _125 - _166;
            _175 = (_126 - _167) * 0.5625f;
            _177 = dot(float2(_173, _175), float2(_173, _175)) * _168;
            _181 = (_125 + -0.5f) + (_177 * _173);
            _183 = (_126 + -0.5f) + (_177 * _175);
            _186 = 0.5f - _166;
            _188 = 0.5f - _167;
            _192 = (((_181 * _169) + _186) / _171) + _166;
            _193 = (((_183 * _169) + _188) / _171) + _167;
            // Step 5: center sample of the main color buffer at the warped UV.
            _194 = t0.SampleLevel(s2, float2(_192, _193), 0.0f);
            do {
              _204 = _170;
              if (_45) {
                _204 = (saturate(dot(float3(_194.x, _194.y, _194.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)) * 100.0f) * _170);
              }
              do {
                _244 = _194.y;
                _245 = _194.z;
                // Step 6: chromatic aberration. Keep red from the center sample,
                // sample green at a moderate radial offset, and blue farther out.
                if (_45 || (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600 == 0.0f))) {
                  _207 = _169 - (_204 * 0.6000000238418579f);
                  _214 = (((_207 * _181) + _186) / _171) + _166;
                  _215 = (((_207 * _183) + _188) / _171) + _167;
                  _217 = _169 - (_204 * 2.0f);
                  _224 = (((_217 * _181) + _186) / _171) + _166;
                  _225 = (((_217 * _183) + _188) / _171) + _167;
                  if (!(_45)) {
                    _244 = (((float4)(t0.SampleLevel(s2, float2(_214, _215), 0.0f))).y);
                    _245 = (((float4)(t0.SampleLevel(s2, float2(_224, _225), 0.0f))).z);
                  } else {
                    _232 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.25f;
                    _233 = t0.SampleLevel(s2, float2(_214, _215), 0.0f);
                    _238 = t0.SampleLevel(s2, float2(_224, _225), 0.0f);
                    _244 = (lerp(_233.y, _194.y, _232));
                    _245 = (lerp(_238.z, _194.z, _232));
                  }
                }
                do {
                  _556 = _194.x;
                  _557 = _244;
                  _558 = _245;
                  // Step 7: the low three bits of Const_512 gate the main color-adjustment chain.
                  if ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_512 & 7) == 7) {
                    do {
                      _297 = _194.x;
                      _298 = _244;
                      _299 = _245;
                      // Step 7a: luminance-guided soft-light/contrast operation. Work in
                      // squared color, blend toward an overlay-style curve, then sqrt back.
                      if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584 > 0.0f) {
                        _248 = _194.x * _194.x;
                        _249 = _244 * _244;
                        _250 = _245 * _245;
                        _252 = saturate(dot(float3(_248, _249, _250), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
                        _255 = _252 + 0.5f;
                        _268 = 0.5f - ((_252 + -0.5f) * 0.5f);
                        _297 = sqrt(((saturate(select((_248 > 0.5f), (1.0f - (_268 * (1.0f - ((_248 + -0.5f) * 2.0f)))), (_255 * _248))) - _248) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _248);
                        _298 = sqrt(((saturate(select((_249 > 0.5f), (1.0f - (_268 * (1.0f - ((_249 + -0.5f) * 2.0f)))), (_255 * _249))) - _249) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _249);
                        _299 = sqrt(((saturate(select((_250 > 0.5f), (1.0f - (_268 * (1.0f - ((_250 + -0.5f) * 2.0f)))), (_255 * _250))) - _250) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _250);
                      }
                      do {
                        _323 = _297;
                        _324 = _298;
                        _325 = _299;
                        // Step 7b: optional per-channel cubic contrast curve, clamped to SDR range.
                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812 > 0.0f) {
                          _323 = saturate((((((_297 * _297) * 6.0f) * _297) - _297) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _297);
                          _324 = saturate((((((_298 * _298) * 6.0f) * _298) - _298) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _298);
                          _325 = saturate((((((_299 * _299) * 6.0f) * _299) - _299) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _299);
                        }
                        do {
                          _436 = _323;
                          _437 = _324;
                          _438 = _325;
                          // Step 8a: optional depth-aware overlay B. t10 supplies a scalar
                          // base; t11 supplies RGB/mask data; t12 drives an 8-neighbor
                          // discontinuity search before the contribution is added.
                          if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 2) == 0)) {
                            if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_852 == 9)) {
                              _337 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648 * (((float4)(t10.SampleLevel(s2, float2(_192, _193), 0.0f))).x)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_652;
                              do {
                                _429 = _337;
                                _430 = _337;
                                _431 = _337;
                                if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_680 == 0)) {
                                  _347 = _20 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.x * 0.5f);
                                  _348 = _21 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.y * 0.5f);
                                  _362 = t11.SampleLevel(s2, float2(_192, _193), 0.0f);
                                  _370 = max(((1.0f - saturate(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_660 * sqrt((_347 * _347) + (_348 * _348))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_664) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_668)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648), _362.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_656;
                                  _371 = t12.SampleLevel(s2, float2(_192, _193), 0.0f);
                                  do {
                                    _421 = _370;
                                    if (!(_371.x == 1.0f)) {
                                      _379 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_371.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                      _380 = sqrt(_379);
                                      _384 = -0.7071067690849304f;
                                      _385 = -0.7071067690849304f;
                                      _386 = 0.0f;
                                      _387 = 0;
                                      bool _loop_break_0 = false;
                                      while (true) {
                                        _399 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t12.SampleLevel(s2, float2(saturate((_385 * (0.004166666883975267f / _380)) + _192), saturate((_384 * (0.007407407276332378f / _380)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _379), _386);
                                        _400 = _387 + 1;
                                        if (!(_400 == 8)) {
                                          _404 = _global_0[min((uint)(_400), 7u)];
                                          _406 = _global_1[min((uint)(_400), 7u)];
                                          _384 = _406;
                                          _385 = _404;
                                          _386 = _399;
                                          _387 = _400;
                                          _loop_break_0 = true;
                                          break;
                                        } else {
                                          _408 = min(_399, 0.10000000149011612f);
                                          _421 = (((_408 * _408) * _370) * max((1.0f - saturate((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_672 * _379) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_676)), _362.w));
                                        }
                                        break;
                                      }
                                    }
                                    _429 = ((_421 * _362.x) + _337);
                                    _430 = ((_421 * _362.y) + _337);
                                    _431 = ((_421 * _362.z) + _337);
                                  } while (false);
                                }
                                _436 = (_429 + _323);
                                _437 = (_430 + _324);
                                _438 = (_431 + _325);
                              } while (false);
                            } else {
                              _436 = _323;
                              _437 = _324;
                              _438 = _325;
                            }
                          }
                          do {
                            _494 = _436;
                            _495 = _437;
                            _496 = _438;
                            // Step 8b: optional depth-aware overlay A. t8 supplies RGB and
                            // t9 supplies the scalar/depth-like field used by the same
                            // 8-neighbor discontinuity search.
                            if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 1) == 0)) {
                              _445 = t9.SampleLevel(s2, float2(_192, _193), 0.0f);
                              if (!(_445.x == 1.0f)) {
                                _449 = t8.SampleLevel(s2, float2(_192, _193), 0.0f);
                                _452 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_445.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                _453 = sqrt(_452);
                                _457 = -0.7071067690849304f;
                                _458 = -0.7071067690849304f;
                                _459 = 0.0f;
                                _460 = 0;
                                bool _loop_break_1 = false;
                                while (true) {
                                  _472 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t9.SampleLevel(s2, float2(saturate((_458 * (0.004166666883975267f / _453)) + _192), saturate((_457 * (0.007407407276332378f / _453)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _452), _459);
                                  _473 = _460 + 1;
                                  if (!(_473 == 8)) {
                                    _477 = _global_0[min((uint)(_473), 7u)];
                                    _479 = _global_1[min((uint)(_473), 7u)];
                                    _457 = _479;
                                    _458 = _477;
                                    _459 = _472;
                                    _460 = _473;
                                    _loop_break_1 = true;
                                    break;
                                  } else {
                                    _484 = min(max(_472, 0.0f), 0.10000000149011612f);
                                    _486 = (_484 * _484) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_640;
                                    _494 = ((_486 * _449.x) + _436);
                                    _495 = ((_486 * _449.y) + _437);
                                    _496 = ((_486 * _449.z) + _438);
                                  }
                                  break;
                                }
                              } else {
                                _494 = _436;
                                _495 = _437;
                                _496 = _438;
                              }
                            }
                            do {
                              _541 = _494;
                              _542 = _495;
                              _543 = _496;
                              // Step 9: radial tint/vignette. Build an elliptical distance
                              // mask and smoothly blend Const_416.rgb toward the current color.
                              if (_57) {
                                _520 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.x * _192) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.z) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.z;
                                _521 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.y * _193) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.w;
                                _528 = saturate(saturate((1.0f - (sqrt(dot(float2(_520, _521), float2(_520, _521))) * 2.0f)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.y));
                                _533 = 1.0f - ((_528 * _528) * (3.0f - (_528 * 2.0f)));
                                _541 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.x * (1.0f - _494)) * _533) + _494);
                                _542 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.y * (1.0f - _495)) * _533) + _495);
                                _543 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.z * (1.0f - _496)) * _533) + _496);
                              }
                              // Additional attenuation outside the active localized lens region.
                              if (!((_172 != 0) || (!_45))) {
                                _551 = 1.0f - ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.1499999761581421f) * saturate(_125));
                                _556 = (_551 * _541);
                                _557 = (_551 * _542);
                                _558 = (_551 * _543);
                              } else {
                                _556 = _541;
                                _557 = _542;
                                _558 = _543;
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  }
                  do {
                    _578 = _556;
                    _579 = _557;
                    _580 = _558;
                    // Step 10a: globally blend the auxiliary image t7 into the current color.
                    if (_64) {
                      _564 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                      _578 = (lerp(_556, _564.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                      _579 = (lerp(_557, _564.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                      _580 = (lerp(_558, _564.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                    }
                    do {
                      _614 = _578;
                      _615 = _579;
                      _616 = _580;
                      // Step 10b: directional horizontal wipe to t7. Const_620 selects
                      // left-to-right versus right-to-left and a narrow band softens the edge.
                      if (_66) {
                        _588 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                        _593 = (1.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_616) * 1.0999999046325684f;
                        _596 = select((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_620 == 0), _33, (1.0f - _33));
                        _597 = _593 + -0.10000000149011612f;
                        if (!(_596 < _597)) {
                          if (!(_596 > _593)) {
                            _603 = (_596 - _597) * 10.0f;
                            _614 = (lerp(_578, _588.x, _603));
                            _615 = (lerp(_579, _588.y, _603));
                            _616 = (lerp(_580, _588.z, _603));
                          } else {
                            _614 = _588.x;
                            _615 = _588.y;
                            _616 = _588.z;
                          }
                        } else {
                          _614 = _578;
                          _615 = _579;
                          _616 = _580;
                        }
                      }
                      do {
                        _653 = _614;
                        _654 = _615;
                        _655 = _616;
                        // Step 10c: when requested, map the bounded t7-blended color into
                        // the t17 3D LUT domain and blend the graded result by Const_684.
                        if ((_64 || _66) && (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_856 != 0)) {
                          if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684 > 0.0f) {
                            _639 = t17.SampleLevel(s2, float3(((saturate(_614) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_615) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_616) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z)), 0.0f);
                            _653 = (lerp(_614, _639.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                            _654 = (lerp(_615, _639.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                            _655 = (lerp(_616, _639.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                          } else {
                            _653 = _614;
                            _654 = _615;
                            _655 = _616;
                          }
                        }
                        do {
                          _720 = _653;
                          _721 = _654;
                          _722 = _655;
                          // Step 10d: optional diagnostic/comparison inset. Two vertically
                          // stacked regions of t7 provide inset RGB and a grayscale blend mask.
                          if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624 == 0)) {
                            _665 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_632)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x);
                            _666 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_636)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y);
                            uint2 _667;
                            t7.GetDimensions(_667.x, _667.y);
                            if (!((int)(int)(SV_DispatchThreadID.x) < (int)_665)) {
                              _673 = float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_628));
                              if (((int)(int)(SV_DispatchThreadID.y) < (int)(int(_673 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y) + _666)) && (((int)(int)(SV_DispatchThreadID.y) >= (int)_666) && ((int)(int)(SV_DispatchThreadID.x) < (int)(int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) + _665)))) {
                                _692 = float((int)((int)(SV_DispatchThreadID.y - _666))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y;
                                _694 = (float)((uint)_667.y);
                                _695 = (float((int)((int)(SV_DispatchThreadID.x - _665))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) / ((float)((uint)_667.x));
                                _697 = t7.SampleLevel(s2, float2(_695, (_692 / _694)), 0.0f);
                                _703 = t7.SampleLevel(s2, float2(_695, ((_692 + _673) / _694)), 0.0f);
                                _709 = ((_703.x + _703.y) + _703.z) * 0.3333333432674408f;
                                _720 = ((_709 * (_697.x - _653)) + _653);
                                _721 = ((_709 * (_697.y - _654)) + _654);
                                _722 = ((_709 * (_697.z - _655)) + _655);
                              } else {
                                _720 = _653;
                                _721 = _654;
                                _722 = _655;
                              }
                            } else {
                              _720 = _653;
                              _721 = _654;
                              _722 = _655;
                            }
                          }
                          do {
                            // Step 11: signal-dependent film grain. t3 is remapped around
                            // 0.5, then shaped by channel value, toe/highlight response,
                            // and the configured grain intensity before being added.
                            _745 = ApplyVanillaFilmGrain(float3(_720, _721, _722), float2(_33, _25));
                            _823 = _745.x;
                            _824 = _745.y;
                            _825 = _745.z;
                            // Step 12: final channel-wise output scale and bias.
                            _837 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.x * _823) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.x;
                            _838 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.y * _824) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.y;
                            _839 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.z * _825) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.z;
                            do {
                              _1057 = _837;
                              _1058 = _838;
                              _1059 = _839;
                              // Step 13: optional horizontal edge treatment. Const_832/836
                              // define the inner/outer transition and Const_848 selects mode:
                              //   1 = stochastic radial blur around the current source UV,
                              //   2 = stochastic blur of a clamped/reprojected central region,
                              //   3 = fade the affected edge region to black.
                              if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 < 1.0f) {
                                if (sqrt(((_837 * _837) + (_838 * _838)) + (_839 * _839)) > 0.0f) {
                                  _852 = _192 + -0.5f;
                                  _859 = saturate(((abs(_852) * 2.0f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) / (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_836 - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832));
                                  if (_859 > 0.0f) {
                                    if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 1) {
                                      _866 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                      _870 = uint(ceil(_866 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                      if (!(_870 == 0)) {
                                        _875 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                        _876 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                        _894 = ((float((int)(((_876 + _875) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_876)) * 2.0f) + float((int)(_875))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                        _898 = 1.0f / ((float)((uint)_870));
                                        _901 = 0;
                                        _902 = 0.0f;
                                        _903 = 0.0f;
                                        _904 = 0.0f;
                                        _905 = (_898 * 0.5f);
                                        _906 = cos(_894);
                                        _907 = sin(_894);
                                        bool _loop_break_2 = false;
                                        while (true) {
                                          _909 = sqrt(_905) * _866;
                                          _916 = t0.SampleLevel(s2, float2((((_906 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _909) + _192), (((_907 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _909) + _193)), 0.0f);
                                          _920 = _916.x + _902;
                                          _921 = _916.y + _903;
                                          _922 = _916.z + _904;
                                          _930 = _901 + 1u;
                                          do {
                                            if (!(_930 == _870)) {
                                              _901 = _930;
                                              _902 = _920;
                                              _903 = _921;
                                              _904 = _922;
                                              _905 = (_905 + _898);
                                              _906 = ((_906 * -0.7373688220977783f) - (_907 * 0.6754903793334961f));
                                              _907 = ((_906 * 0.6754903793334961f) - (_907 * 0.7373688220977783f));
                                              _loop_break_2 = true;
                                              break;
                                            }
                                            _936 = saturate(_866);
                                            _1057 = ((_936 * ((_920 * _898) - _837)) + _837);
                                            _1058 = ((_936 * ((_921 * _898) - _838)) + _838);
                                            _1059 = ((_936 * ((_922 * _898) - _839)) + _839);
                                          } while (false);
                                          if (_loop_break_2) {
                                            _loop_break_2 = false;
                                            continue;
                                          }
                                          break;
                                        }
                                      } else {
                                        _1057 = _837;
                                        _1058 = _838;
                                        _1059 = _839;
                                      }
                                    } else {
                                      if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 2) {
                                        _950 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                        _954 = uint(ceil(_950 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                        if (!(_954 == 0)) {
                                          _959 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                          _960 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                          _978 = ((float((int)(((_960 + _959) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_960)) * 2.0f) + float((int)(_959))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                          _985 = 1.0f / ((float)((uint)_954));
                                          _988 = cos(_978);
                                          _989 = sin(_978);
                                          _990 = (_985 * 0.5f);
                                          _991 = 0.0f;
                                          _992 = 0.0f;
                                          _993 = 0.0f;
                                          _994 = 0;
                                          bool _loop_break_3 = false;
                                          while (true) {
                                            _996 = sqrt(_990) * _950;
                                            _1007 = -0.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832;
                                            _1016 = t0.SampleLevel(s2, float2(((min(max(((((_988 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * _852)) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f), ((min(max(((((_989 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * (_193 + -0.5f))) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f)), 0.0f);
                                            _1020 = _1016.x + _991;
                                            _1021 = _1016.y + _992;
                                            _1022 = _1016.z + _993;
                                            _1030 = _994 + 1u;
                                            do {
                                              if (!(_1030 == _954)) {
                                                _988 = ((_988 * -0.7373688220977783f) - (_989 * 0.6754903793334961f));
                                                _989 = ((_988 * 0.6754903793334961f) - (_989 * 0.7373688220977783f));
                                                _990 = (_990 + _985);
                                                _991 = _1020;
                                                _992 = _1021;
                                                _993 = _1022;
                                                _994 = _1030;
                                                _loop_break_3 = true;
                                                break;
                                              }
                                              _1036 = saturate(_859);
                                              _1057 = ((_1036 * ((_1020 * _985) - _837)) + _837);
                                              _1058 = ((_1036 * ((_1021 * _985) - _838)) + _838);
                                              _1059 = ((_1036 * ((_1022 * _985) - _839)) + _839);
                                            } while (false);
                                            if (_loop_break_3) {
                                              _loop_break_3 = false;
                                              continue;
                                            }
                                            break;
                                          }
                                        } else {
                                          _1057 = _837;
                                          _1058 = _838;
                                          _1059 = _839;
                                        }
                                      } else {
                                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 3) {
                                          _1049 = saturate(_859);
                                          _1057 = (_837 - (_1049 * _837));
                                          _1058 = (_838 - (_1049 * _838));
                                          _1059 = (_839 - (_1049 * _839));
                                        } else {
                                          _1057 = _837;
                                          _1058 = _838;
                                          _1059 = _839;
                                        }
                                      }
                                    }
                                  } else {
                                    _1057 = _837;
                                    _1058 = _838;
                                    _1059 = _839;
                                  }
                                } else {
                                  _1057 = _837;
                                  _1058 = _838;
                                  _1059 = _839;
                                }
                              }
                              // Step 14: preserve positive HDR values, reject negative RGB,
                              // and write alpha zero as expected by this intermediate.
                              u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(max(_1057, 0.0f), max(_1058, 0.0f), max(_1059, 0.0f), 0.0f);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        }
      } while (false);
    } else {
      _89 = _81;
    }
  } else {
    _89 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.y;
  }
  _90 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.x / _89;
  if (_90 > g_postPostProcessingShaderConst_000.PostProcessingShaderConst_820) {
    _97 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.x - ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_820 / _90) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.x)) * 0.5f;
    if ((_20 < _97) || (_20 > (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.x - _97))) {
      _115 = true;
      do {
        if (_115) {
          u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(0.0f, 0.0f, 0.0f, 0.0f);
        } else {
          _118 = t2.SampleLevel(s2, float2(_33, _25), 0.0f);
          _125 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x * 1.5f) * _118.x) + _33;
          _126 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y * 1.5f) * _118.y) + _25;
          do {
            _166 = 0.5f;
            _167 = 0.5f;
            _168 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592;
            _169 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596;
            _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
            _171 = 1.0f;
            _172 = 0;
            if (_45) {
              _133 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y - _126;
              _135 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x - _125) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_800;
              _139 = sqrt((_135 * _135) + (_133 * _133));
              if (_139 < g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796) {
                _143 = _139 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796;
                _144 = saturate(_143);
                _145 = _144 * _144;
                _166 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x;
                _167 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y;
                _168 = (((((_145 * _145) * (_144 * 1.5f)) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592);
                _169 = (lerp(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596, 0.9200000166893005f, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792));
                _170 = ((((_143 * 0.02250000089406967f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600);
                _171 = (((_143 * (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_608 + -1.0f)) + 1.0f) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_604);
                _172 = 1;
              } else {
                _166 = 0.5f;
                _167 = 0.5f;
                _168 = -0.03500000014901161f;
                _169 = 1.0f;
                _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
                _171 = 1.0f;
                _172 = 0;
              }
            }
            _173 = _125 - _166;
            _175 = (_126 - _167) * 0.5625f;
            _177 = dot(float2(_173, _175), float2(_173, _175)) * _168;
            _181 = (_125 + -0.5f) + (_177 * _173);
            _183 = (_126 + -0.5f) + (_177 * _175);
            _186 = 0.5f - _166;
            _188 = 0.5f - _167;
            _192 = (((_181 * _169) + _186) / _171) + _166;
            _193 = (((_183 * _169) + _188) / _171) + _167;
            _194 = t0.SampleLevel(s2, float2(_192, _193), 0.0f);
            do {
              _204 = _170;
              if (_45) {
                _204 = (saturate(dot(float3(_194.x, _194.y, _194.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)) * 100.0f) * _170);
              }
              do {
                _244 = _194.y;
                _245 = _194.z;
                if (_45 || (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600 == 0.0f))) {
                  _207 = _169 - (_204 * 0.6000000238418579f);
                  _214 = (((_207 * _181) + _186) / _171) + _166;
                  _215 = (((_207 * _183) + _188) / _171) + _167;
                  _217 = _169 - (_204 * 2.0f);
                  _224 = (((_217 * _181) + _186) / _171) + _166;
                  _225 = (((_217 * _183) + _188) / _171) + _167;
                  if (!(_45)) {
                    _244 = (((float4)(t0.SampleLevel(s2, float2(_214, _215), 0.0f))).y);
                    _245 = (((float4)(t0.SampleLevel(s2, float2(_224, _225), 0.0f))).z);
                  } else {
                    _232 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.25f;
                    _233 = t0.SampleLevel(s2, float2(_214, _215), 0.0f);
                    _238 = t0.SampleLevel(s2, float2(_224, _225), 0.0f);
                    _244 = (lerp(_233.y, _194.y, _232));
                    _245 = (lerp(_238.z, _194.z, _232));
                  }
                }
                do {
                  _556 = _194.x;
                  _557 = _244;
                  _558 = _245;
                  if ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_512 & 7) == 7) {
                    do {
                      _297 = _194.x;
                      _298 = _244;
                      _299 = _245;
                      if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584 > 0.0f) {
                        _248 = _194.x * _194.x;
                        _249 = _244 * _244;
                        _250 = _245 * _245;
                        _252 = saturate(dot(float3(_248, _249, _250), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
                        _255 = _252 + 0.5f;
                        _268 = 0.5f - ((_252 + -0.5f) * 0.5f);
                        _297 = sqrt(((saturate(select((_248 > 0.5f), (1.0f - (_268 * (1.0f - ((_248 + -0.5f) * 2.0f)))), (_255 * _248))) - _248) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _248);
                        _298 = sqrt(((saturate(select((_249 > 0.5f), (1.0f - (_268 * (1.0f - ((_249 + -0.5f) * 2.0f)))), (_255 * _249))) - _249) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _249);
                        _299 = sqrt(((saturate(select((_250 > 0.5f), (1.0f - (_268 * (1.0f - ((_250 + -0.5f) * 2.0f)))), (_255 * _250))) - _250) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _250);
                      }
                      do {
                        _323 = _297;
                        _324 = _298;
                        _325 = _299;
                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812 > 0.0f) {
                          _323 = saturate((((((_297 * _297) * 6.0f) * _297) - _297) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _297);
                          _324 = saturate((((((_298 * _298) * 6.0f) * _298) - _298) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _298);
                          _325 = saturate((((((_299 * _299) * 6.0f) * _299) - _299) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _299);
                        }
                        do {
                          _436 = _323;
                          _437 = _324;
                          _438 = _325;
                          if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 2) == 0)) {
                            if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_852 == 9)) {
                              _337 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648 * (((float4)(t10.SampleLevel(s2, float2(_192, _193), 0.0f))).x)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_652;
                              do {
                                _429 = _337;
                                _430 = _337;
                                _431 = _337;
                                if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_680 == 0)) {
                                  _347 = _20 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.x * 0.5f);
                                  _348 = _21 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.y * 0.5f);
                                  _362 = t11.SampleLevel(s2, float2(_192, _193), 0.0f);
                                  _370 = max(((1.0f - saturate(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_660 * sqrt((_347 * _347) + (_348 * _348))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_664) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_668)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648), _362.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_656;
                                  _371 = t12.SampleLevel(s2, float2(_192, _193), 0.0f);
                                  do {
                                    _421 = _370;
                                    if (!(_371.x == 1.0f)) {
                                      _379 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_371.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                      _380 = sqrt(_379);
                                      _384 = -0.7071067690849304f;
                                      _385 = -0.7071067690849304f;
                                      _386 = 0.0f;
                                      _387 = 0;
                                      bool _loop_break_4 = false;
                                      while (true) {
                                        _399 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t12.SampleLevel(s2, float2(saturate((_385 * (0.004166666883975267f / _380)) + _192), saturate((_384 * (0.007407407276332378f / _380)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _379), _386);
                                        _400 = _387 + 1;
                                        if (!(_400 == 8)) {
                                          _404 = _global_0[min((uint)(_400), 7u)];
                                          _406 = _global_1[min((uint)(_400), 7u)];
                                          _384 = _406;
                                          _385 = _404;
                                          _386 = _399;
                                          _387 = _400;
                                          _loop_break_4 = true;
                                          break;
                                        } else {
                                          _408 = min(_399, 0.10000000149011612f);
                                          _421 = (((_408 * _408) * _370) * max((1.0f - saturate((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_672 * _379) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_676)), _362.w));
                                        }
                                        break;
                                      }
                                    }
                                    _429 = ((_421 * _362.x) + _337);
                                    _430 = ((_421 * _362.y) + _337);
                                    _431 = ((_421 * _362.z) + _337);
                                  } while (false);
                                }
                                _436 = (_429 + _323);
                                _437 = (_430 + _324);
                                _438 = (_431 + _325);
                              } while (false);
                            } else {
                              _436 = _323;
                              _437 = _324;
                              _438 = _325;
                            }
                          }
                          do {
                            _494 = _436;
                            _495 = _437;
                            _496 = _438;
                            if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 1) == 0)) {
                              _445 = t9.SampleLevel(s2, float2(_192, _193), 0.0f);
                              if (!(_445.x == 1.0f)) {
                                _449 = t8.SampleLevel(s2, float2(_192, _193), 0.0f);
                                _452 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_445.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                _453 = sqrt(_452);
                                _457 = -0.7071067690849304f;
                                _458 = -0.7071067690849304f;
                                _459 = 0.0f;
                                _460 = 0;
                                bool _loop_break_5 = false;
                                while (true) {
                                  _472 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t9.SampleLevel(s2, float2(saturate((_458 * (0.004166666883975267f / _453)) + _192), saturate((_457 * (0.007407407276332378f / _453)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _452), _459);
                                  _473 = _460 + 1;
                                  if (!(_473 == 8)) {
                                    _477 = _global_0[min((uint)(_473), 7u)];
                                    _479 = _global_1[min((uint)(_473), 7u)];
                                    _457 = _479;
                                    _458 = _477;
                                    _459 = _472;
                                    _460 = _473;
                                    _loop_break_5 = true;
                                    break;
                                  } else {
                                    _484 = min(max(_472, 0.0f), 0.10000000149011612f);
                                    _486 = (_484 * _484) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_640;
                                    _494 = ((_486 * _449.x) + _436);
                                    _495 = ((_486 * _449.y) + _437);
                                    _496 = ((_486 * _449.z) + _438);
                                  }
                                  break;
                                }
                              } else {
                                _494 = _436;
                                _495 = _437;
                                _496 = _438;
                              }
                            }
                            do {
                              _541 = _494;
                              _542 = _495;
                              _543 = _496;
                              if (_57) {
                                _520 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.x * _192) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.z) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.z;
                                _521 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.y * _193) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.w;
                                _528 = saturate(saturate((1.0f - (sqrt(dot(float2(_520, _521), float2(_520, _521))) * 2.0f)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.y));
                                _533 = 1.0f - ((_528 * _528) * (3.0f - (_528 * 2.0f)));
                                _541 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.x * (1.0f - _494)) * _533) + _494);
                                _542 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.y * (1.0f - _495)) * _533) + _495);
                                _543 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.z * (1.0f - _496)) * _533) + _496);
                              }
                              if (!((_172 != 0) || (!_45))) {
                                _551 = 1.0f - ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.1499999761581421f) * saturate(_125));
                                _556 = (_551 * _541);
                                _557 = (_551 * _542);
                                _558 = (_551 * _543);
                              } else {
                                _556 = _541;
                                _557 = _542;
                                _558 = _543;
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  }
                  do {
                    _578 = _556;
                    _579 = _557;
                    _580 = _558;
                    if (_64) {
                      _564 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                      _578 = (lerp(_556, _564.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                      _579 = (lerp(_557, _564.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                      _580 = (lerp(_558, _564.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                    }
                    do {
                      _614 = _578;
                      _615 = _579;
                      _616 = _580;
                      if (_66) {
                        _588 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                        _593 = (1.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_616) * 1.0999999046325684f;
                        _596 = select((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_620 == 0), _33, (1.0f - _33));
                        _597 = _593 + -0.10000000149011612f;
                        if (!(_596 < _597)) {
                          if (!(_596 > _593)) {
                            _603 = (_596 - _597) * 10.0f;
                            _614 = (lerp(_578, _588.x, _603));
                            _615 = (lerp(_579, _588.y, _603));
                            _616 = (lerp(_580, _588.z, _603));
                          } else {
                            _614 = _588.x;
                            _615 = _588.y;
                            _616 = _588.z;
                          }
                        } else {
                          _614 = _578;
                          _615 = _579;
                          _616 = _580;
                        }
                      }
                      do {
                        _653 = _614;
                        _654 = _615;
                        _655 = _616;
                        if ((_64 || _66) && (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_856 != 0)) {
                          if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684 > 0.0f) {
                            _639 = t17.SampleLevel(s2, float3(((saturate(_614) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_615) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_616) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z)), 0.0f);
                            _653 = (lerp(_614, _639.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                            _654 = (lerp(_615, _639.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                            _655 = (lerp(_616, _639.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                          } else {
                            _653 = _614;
                            _654 = _615;
                            _655 = _616;
                          }
                        }
                        do {
                          _720 = _653;
                          _721 = _654;
                          _722 = _655;
                          if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624 == 0)) {
                            _665 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_632)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x);
                            _666 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_636)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y);
                            uint2 _667;
                            t7.GetDimensions(_667.x, _667.y);
                            if (!((int)(int)(SV_DispatchThreadID.x) < (int)_665)) {
                              _673 = float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_628));
                              if (((int)(int)(SV_DispatchThreadID.y) < (int)(int(_673 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y) + _666)) && (((int)(int)(SV_DispatchThreadID.y) >= (int)_666) && ((int)(int)(SV_DispatchThreadID.x) < (int)(int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) + _665)))) {
                                _692 = float((int)((int)(SV_DispatchThreadID.y - _666))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y;
                                _694 = (float)((uint)_667.y);
                                _695 = (float((int)((int)(SV_DispatchThreadID.x - _665))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) / ((float)((uint)_667.x));
                                _697 = t7.SampleLevel(s2, float2(_695, (_692 / _694)), 0.0f);
                                _703 = t7.SampleLevel(s2, float2(_695, ((_692 + _673) / _694)), 0.0f);
                                _709 = ((_703.x + _703.y) + _703.z) * 0.3333333432674408f;
                                _720 = ((_709 * (_697.x - _653)) + _653);
                                _721 = ((_709 * (_697.y - _654)) + _654);
                                _722 = ((_709 * (_697.z - _655)) + _655);
                              } else {
                                _720 = _653;
                                _721 = _654;
                                _722 = _655;
                              }
                            } else {
                              _720 = _653;
                              _721 = _654;
                              _722 = _655;
                            }
                          }
                          do {
                            _745 = ApplyVanillaFilmGrain(float3(_720, _721, _722), float2(_33, _25));
                            _823 = _745.x;
                            _824 = _745.y;
                            _825 = _745.z;
                            _837 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.x * _823) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.x;
                            _838 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.y * _824) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.y;
                            _839 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.z * _825) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.z;
                            do {
                              _1057 = _837;
                              _1058 = _838;
                              _1059 = _839;
                              if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 < 1.0f) {
                                if (sqrt(((_837 * _837) + (_838 * _838)) + (_839 * _839)) > 0.0f) {
                                  _852 = _192 + -0.5f;
                                  _859 = saturate(((abs(_852) * 2.0f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) / (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_836 - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832));
                                  if (_859 > 0.0f) {
                                    if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 1) {
                                      _866 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                      _870 = uint(ceil(_866 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                      if (!(_870 == 0)) {
                                        _875 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                        _876 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                        _894 = ((float((int)(((_876 + _875) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_876)) * 2.0f) + float((int)(_875))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                        _898 = 1.0f / ((float)((uint)_870));
                                        _901 = 0;
                                        _902 = 0.0f;
                                        _903 = 0.0f;
                                        _904 = 0.0f;
                                        _905 = (_898 * 0.5f);
                                        _906 = cos(_894);
                                        _907 = sin(_894);
                                        bool _loop_break_6 = false;
                                        while (true) {
                                          _909 = sqrt(_905) * _866;
                                          _916 = t0.SampleLevel(s2, float2((((_906 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _909) + _192), (((_907 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _909) + _193)), 0.0f);
                                          _920 = _916.x + _902;
                                          _921 = _916.y + _903;
                                          _922 = _916.z + _904;
                                          _930 = _901 + 1u;
                                          do {
                                            if (!(_930 == _870)) {
                                              _901 = _930;
                                              _902 = _920;
                                              _903 = _921;
                                              _904 = _922;
                                              _905 = (_905 + _898);
                                              _906 = ((_906 * -0.7373688220977783f) - (_907 * 0.6754903793334961f));
                                              _907 = ((_906 * 0.6754903793334961f) - (_907 * 0.7373688220977783f));
                                              _loop_break_6 = true;
                                              break;
                                            }
                                            _936 = saturate(_866);
                                            _1057 = ((_936 * ((_920 * _898) - _837)) + _837);
                                            _1058 = ((_936 * ((_921 * _898) - _838)) + _838);
                                            _1059 = ((_936 * ((_922 * _898) - _839)) + _839);
                                          } while (false);
                                          if (_loop_break_6) {
                                            _loop_break_6 = false;
                                            continue;
                                          }
                                          break;
                                        }
                                      } else {
                                        _1057 = _837;
                                        _1058 = _838;
                                        _1059 = _839;
                                      }
                                    } else {
                                      if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 2) {
                                        _950 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                        _954 = uint(ceil(_950 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                        if (!(_954 == 0)) {
                                          _959 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                          _960 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                          _978 = ((float((int)(((_960 + _959) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_960)) * 2.0f) + float((int)(_959))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                          _985 = 1.0f / ((float)((uint)_954));
                                          _988 = cos(_978);
                                          _989 = sin(_978);
                                          _990 = (_985 * 0.5f);
                                          _991 = 0.0f;
                                          _992 = 0.0f;
                                          _993 = 0.0f;
                                          _994 = 0;
                                          bool _loop_break_7 = false;
                                          while (true) {
                                            _996 = sqrt(_990) * _950;
                                            _1007 = -0.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832;
                                            _1016 = t0.SampleLevel(s2, float2(((min(max(((((_988 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * _852)) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f), ((min(max(((((_989 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * (_193 + -0.5f))) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f)), 0.0f);
                                            _1020 = _1016.x + _991;
                                            _1021 = _1016.y + _992;
                                            _1022 = _1016.z + _993;
                                            _1030 = _994 + 1u;
                                            do {
                                              if (!(_1030 == _954)) {
                                                _988 = ((_988 * -0.7373688220977783f) - (_989 * 0.6754903793334961f));
                                                _989 = ((_988 * 0.6754903793334961f) - (_989 * 0.7373688220977783f));
                                                _990 = (_990 + _985);
                                                _991 = _1020;
                                                _992 = _1021;
                                                _993 = _1022;
                                                _994 = _1030;
                                                _loop_break_7 = true;
                                                break;
                                              }
                                              _1036 = saturate(_859);
                                              _1057 = ((_1036 * ((_1020 * _985) - _837)) + _837);
                                              _1058 = ((_1036 * ((_1021 * _985) - _838)) + _838);
                                              _1059 = ((_1036 * ((_1022 * _985) - _839)) + _839);
                                            } while (false);
                                            if (_loop_break_7) {
                                              _loop_break_7 = false;
                                              continue;
                                            }
                                            break;
                                          }
                                        } else {
                                          _1057 = _837;
                                          _1058 = _838;
                                          _1059 = _839;
                                        }
                                      } else {
                                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 3) {
                                          _1049 = saturate(_859);
                                          _1057 = (_837 - (_1049 * _837));
                                          _1058 = (_838 - (_1049 * _838));
                                          _1059 = (_839 - (_1049 * _839));
                                        } else {
                                          _1057 = _837;
                                          _1058 = _838;
                                          _1059 = _839;
                                        }
                                      }
                                    }
                                  } else {
                                    _1057 = _837;
                                    _1058 = _838;
                                    _1059 = _839;
                                  }
                                } else {
                                  _1057 = _837;
                                  _1058 = _838;
                                  _1059 = _839;
                                }
                              }
                              u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(max(_1057, 0.0f), max(_1058, 0.0f), max(_1059, 0.0f), 0.0f);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        }
      } while (false);
    }
  } else {
    if (_90 < g_postPostProcessingShaderConst_000.PostProcessingShaderConst_820) {
      _108 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.y - ((_90 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_820) * _89)) * 0.5f;
      if ((_21 < _108) || (_21 > (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_560.y - _108))) {
        _115 = true;
        do {
          if (_115) {
            u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(0.0f, 0.0f, 0.0f, 0.0f);
          } else {
            _118 = t2.SampleLevel(s2, float2(_33, _25), 0.0f);
            _125 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x * 1.5f) * _118.x) + _33;
            _126 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y * 1.5f) * _118.y) + _25;
            do {
              _166 = 0.5f;
              _167 = 0.5f;
              _168 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592;
              _169 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596;
              _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
              _171 = 1.0f;
              _172 = 0;
              if (_45) {
                _133 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y - _126;
                _135 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x - _125) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_800;
                _139 = sqrt((_135 * _135) + (_133 * _133));
                if (_139 < g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796) {
                  _143 = _139 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796;
                  _144 = saturate(_143);
                  _145 = _144 * _144;
                  _166 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x;
                  _167 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y;
                  _168 = (((((_145 * _145) * (_144 * 1.5f)) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592);
                  _169 = (lerp(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596, 0.9200000166893005f, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792));
                  _170 = ((((_143 * 0.02250000089406967f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600);
                  _171 = (((_143 * (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_608 + -1.0f)) + 1.0f) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_604);
                  _172 = 1;
                } else {
                  _166 = 0.5f;
                  _167 = 0.5f;
                  _168 = -0.03500000014901161f;
                  _169 = 1.0f;
                  _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
                  _171 = 1.0f;
                  _172 = 0;
                }
              }
              _173 = _125 - _166;
              _175 = (_126 - _167) * 0.5625f;
              _177 = dot(float2(_173, _175), float2(_173, _175)) * _168;
              _181 = (_125 + -0.5f) + (_177 * _173);
              _183 = (_126 + -0.5f) + (_177 * _175);
              _186 = 0.5f - _166;
              _188 = 0.5f - _167;
              _192 = (((_181 * _169) + _186) / _171) + _166;
              _193 = (((_183 * _169) + _188) / _171) + _167;
              _194 = t0.SampleLevel(s2, float2(_192, _193), 0.0f);
              do {
                _204 = _170;
                if (_45) {
                  _204 = (saturate(dot(float3(_194.x, _194.y, _194.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)) * 100.0f) * _170);
                }
                do {
                  _244 = _194.y;
                  _245 = _194.z;
                  if (_45 || (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600 == 0.0f))) {
                    _207 = _169 - (_204 * 0.6000000238418579f);
                    _214 = (((_207 * _181) + _186) / _171) + _166;
                    _215 = (((_207 * _183) + _188) / _171) + _167;
                    _217 = _169 - (_204 * 2.0f);
                    _224 = (((_217 * _181) + _186) / _171) + _166;
                    _225 = (((_217 * _183) + _188) / _171) + _167;
                    if (!(_45)) {
                      _244 = (((float4)(t0.SampleLevel(s2, float2(_214, _215), 0.0f))).y);
                      _245 = (((float4)(t0.SampleLevel(s2, float2(_224, _225), 0.0f))).z);
                    } else {
                      _232 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.25f;
                      _233 = t0.SampleLevel(s2, float2(_214, _215), 0.0f);
                      _238 = t0.SampleLevel(s2, float2(_224, _225), 0.0f);
                      _244 = (lerp(_233.y, _194.y, _232));
                      _245 = (lerp(_238.z, _194.z, _232));
                    }
                  }
                  do {
                    _556 = _194.x;
                    _557 = _244;
                    _558 = _245;
                    if ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_512 & 7) == 7) {
                      do {
                        _297 = _194.x;
                        _298 = _244;
                        _299 = _245;
                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584 > 0.0f) {
                          _248 = _194.x * _194.x;
                          _249 = _244 * _244;
                          _250 = _245 * _245;
                          _252 = saturate(dot(float3(_248, _249, _250), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
                          _255 = _252 + 0.5f;
                          _268 = 0.5f - ((_252 + -0.5f) * 0.5f);
                          _297 = sqrt(((saturate(select((_248 > 0.5f), (1.0f - (_268 * (1.0f - ((_248 + -0.5f) * 2.0f)))), (_255 * _248))) - _248) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _248);
                          _298 = sqrt(((saturate(select((_249 > 0.5f), (1.0f - (_268 * (1.0f - ((_249 + -0.5f) * 2.0f)))), (_255 * _249))) - _249) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _249);
                          _299 = sqrt(((saturate(select((_250 > 0.5f), (1.0f - (_268 * (1.0f - ((_250 + -0.5f) * 2.0f)))), (_255 * _250))) - _250) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _250);
                        }
                        do {
                          _323 = _297;
                          _324 = _298;
                          _325 = _299;
                          if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812 > 0.0f) {
                            _323 = saturate((((((_297 * _297) * 6.0f) * _297) - _297) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _297);
                            _324 = saturate((((((_298 * _298) * 6.0f) * _298) - _298) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _298);
                            _325 = saturate((((((_299 * _299) * 6.0f) * _299) - _299) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _299);
                          }
                          do {
                            _436 = _323;
                            _437 = _324;
                            _438 = _325;
                            if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 2) == 0)) {
                              if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_852 == 9)) {
                                _337 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648 * (((float4)(t10.SampleLevel(s2, float2(_192, _193), 0.0f))).x)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_652;
                                do {
                                  _429 = _337;
                                  _430 = _337;
                                  _431 = _337;
                                  if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_680 == 0)) {
                                    _347 = _20 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.x * 0.5f);
                                    _348 = _21 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.y * 0.5f);
                                    _362 = t11.SampleLevel(s2, float2(_192, _193), 0.0f);
                                    _370 = max(((1.0f - saturate(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_660 * sqrt((_347 * _347) + (_348 * _348))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_664) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_668)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648), _362.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_656;
                                    _371 = t12.SampleLevel(s2, float2(_192, _193), 0.0f);
                                    do {
                                      _421 = _370;
                                      if (!(_371.x == 1.0f)) {
                                        _379 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_371.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                        _380 = sqrt(_379);
                                        _384 = -0.7071067690849304f;
                                        _385 = -0.7071067690849304f;
                                        _386 = 0.0f;
                                        _387 = 0;
                                        bool _loop_break_8 = false;
                                        while (true) {
                                          _399 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t12.SampleLevel(s2, float2(saturate((_385 * (0.004166666883975267f / _380)) + _192), saturate((_384 * (0.007407407276332378f / _380)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _379), _386);
                                          _400 = _387 + 1;
                                          if (!(_400 == 8)) {
                                            _404 = _global_0[min((uint)(_400), 7u)];
                                            _406 = _global_1[min((uint)(_400), 7u)];
                                            _384 = _406;
                                            _385 = _404;
                                            _386 = _399;
                                            _387 = _400;
                                            _loop_break_8 = true;
                                            break;
                                          } else {
                                            _408 = min(_399, 0.10000000149011612f);
                                            _421 = (((_408 * _408) * _370) * max((1.0f - saturate((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_672 * _379) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_676)), _362.w));
                                          }
                                          break;
                                        }
                                      }
                                      _429 = ((_421 * _362.x) + _337);
                                      _430 = ((_421 * _362.y) + _337);
                                      _431 = ((_421 * _362.z) + _337);
                                    } while (false);
                                  }
                                  _436 = (_429 + _323);
                                  _437 = (_430 + _324);
                                  _438 = (_431 + _325);
                                } while (false);
                              } else {
                                _436 = _323;
                                _437 = _324;
                                _438 = _325;
                              }
                            }
                            do {
                              _494 = _436;
                              _495 = _437;
                              _496 = _438;
                              if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 1) == 0)) {
                                _445 = t9.SampleLevel(s2, float2(_192, _193), 0.0f);
                                if (!(_445.x == 1.0f)) {
                                  _449 = t8.SampleLevel(s2, float2(_192, _193), 0.0f);
                                  _452 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_445.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                  _453 = sqrt(_452);
                                  _457 = -0.7071067690849304f;
                                  _458 = -0.7071067690849304f;
                                  _459 = 0.0f;
                                  _460 = 0;
                                  bool _loop_break_9 = false;
                                  while (true) {
                                    _472 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t9.SampleLevel(s2, float2(saturate((_458 * (0.004166666883975267f / _453)) + _192), saturate((_457 * (0.007407407276332378f / _453)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _452), _459);
                                    _473 = _460 + 1;
                                    if (!(_473 == 8)) {
                                      _477 = _global_0[min((uint)(_473), 7u)];
                                      _479 = _global_1[min((uint)(_473), 7u)];
                                      _457 = _479;
                                      _458 = _477;
                                      _459 = _472;
                                      _460 = _473;
                                      _loop_break_9 = true;
                                      break;
                                    } else {
                                      _484 = min(max(_472, 0.0f), 0.10000000149011612f);
                                      _486 = (_484 * _484) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_640;
                                      _494 = ((_486 * _449.x) + _436);
                                      _495 = ((_486 * _449.y) + _437);
                                      _496 = ((_486 * _449.z) + _438);
                                    }
                                    break;
                                  }
                                } else {
                                  _494 = _436;
                                  _495 = _437;
                                  _496 = _438;
                                }
                              }
                              do {
                                _541 = _494;
                                _542 = _495;
                                _543 = _496;
                                if (_57) {
                                  _520 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.x * _192) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.z) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.z;
                                  _521 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.y * _193) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.w;
                                  _528 = saturate(saturate((1.0f - (sqrt(dot(float2(_520, _521), float2(_520, _521))) * 2.0f)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.y));
                                  _533 = 1.0f - ((_528 * _528) * (3.0f - (_528 * 2.0f)));
                                  _541 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.x * (1.0f - _494)) * _533) + _494);
                                  _542 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.y * (1.0f - _495)) * _533) + _495);
                                  _543 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.z * (1.0f - _496)) * _533) + _496);
                                }
                                if (!((_172 != 0) || (!_45))) {
                                  _551 = 1.0f - ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.1499999761581421f) * saturate(_125));
                                  _556 = (_551 * _541);
                                  _557 = (_551 * _542);
                                  _558 = (_551 * _543);
                                } else {
                                  _556 = _541;
                                  _557 = _542;
                                  _558 = _543;
                                }
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    }
                    do {
                      _578 = _556;
                      _579 = _557;
                      _580 = _558;
                      if (_64) {
                        _564 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                        _578 = (lerp(_556, _564.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                        _579 = (lerp(_557, _564.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                        _580 = (lerp(_558, _564.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                      }
                      do {
                        _614 = _578;
                        _615 = _579;
                        _616 = _580;
                        if (_66) {
                          _588 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                          _593 = (1.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_616) * 1.0999999046325684f;
                          _596 = select((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_620 == 0), _33, (1.0f - _33));
                          _597 = _593 + -0.10000000149011612f;
                          if (!(_596 < _597)) {
                            if (!(_596 > _593)) {
                              _603 = (_596 - _597) * 10.0f;
                              _614 = (lerp(_578, _588.x, _603));
                              _615 = (lerp(_579, _588.y, _603));
                              _616 = (lerp(_580, _588.z, _603));
                            } else {
                              _614 = _588.x;
                              _615 = _588.y;
                              _616 = _588.z;
                            }
                          } else {
                            _614 = _578;
                            _615 = _579;
                            _616 = _580;
                          }
                        }
                        do {
                          _653 = _614;
                          _654 = _615;
                          _655 = _616;
                          if ((_64 || _66) && (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_856 != 0)) {
                            if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684 > 0.0f) {
                              _639 = t17.SampleLevel(s2, float3(((saturate(_614) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_615) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_616) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z)), 0.0f);
                              _653 = (lerp(_614, _639.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                              _654 = (lerp(_615, _639.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                              _655 = (lerp(_616, _639.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                            } else {
                              _653 = _614;
                              _654 = _615;
                              _655 = _616;
                            }
                          }
                          do {
                            _720 = _653;
                            _721 = _654;
                            _722 = _655;
                            if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624 == 0)) {
                              _665 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_632)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x);
                              _666 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_636)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y);
                              uint2 _667;
                              t7.GetDimensions(_667.x, _667.y);
                              if (!((int)(int)(SV_DispatchThreadID.x) < (int)_665)) {
                                _673 = float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_628));
                                if (((int)(int)(SV_DispatchThreadID.y) < (int)(int(_673 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y) + _666)) && (((int)(int)(SV_DispatchThreadID.y) >= (int)_666) && ((int)(int)(SV_DispatchThreadID.x) < (int)(int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) + _665)))) {
                                  _692 = float((int)((int)(SV_DispatchThreadID.y - _666))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y;
                                  _694 = (float)((uint)_667.y);
                                  _695 = (float((int)((int)(SV_DispatchThreadID.x - _665))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) / ((float)((uint)_667.x));
                                  _697 = t7.SampleLevel(s2, float2(_695, (_692 / _694)), 0.0f);
                                  _703 = t7.SampleLevel(s2, float2(_695, ((_692 + _673) / _694)), 0.0f);
                                  _709 = ((_703.x + _703.y) + _703.z) * 0.3333333432674408f;
                                  _720 = ((_709 * (_697.x - _653)) + _653);
                                  _721 = ((_709 * (_697.y - _654)) + _654);
                                  _722 = ((_709 * (_697.z - _655)) + _655);
                                } else {
                                  _720 = _653;
                                  _721 = _654;
                                  _722 = _655;
                                }
                              } else {
                                _720 = _653;
                                _721 = _654;
                                _722 = _655;
                              }
                            }
                            do {
                              _745 = ApplyVanillaFilmGrain(float3(_720, _721, _722), float2(_33, _25));
                              _823 = _745.x;
                              _824 = _745.y;
                              _825 = _745.z;
                              _837 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.x * _823) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.x;
                              _838 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.y * _824) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.y;
                              _839 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.z * _825) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.z;
                              do {
                                _1057 = _837;
                                _1058 = _838;
                                _1059 = _839;
                                if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 < 1.0f) {
                                  if (sqrt(((_837 * _837) + (_838 * _838)) + (_839 * _839)) > 0.0f) {
                                    _852 = _192 + -0.5f;
                                    _859 = saturate(((abs(_852) * 2.0f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) / (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_836 - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832));
                                    if (_859 > 0.0f) {
                                      if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 1) {
                                        _866 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                        _870 = uint(ceil(_866 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                        if (!(_870 == 0)) {
                                          _875 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                          _876 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                          _894 = ((float((int)(((_876 + _875) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_876)) * 2.0f) + float((int)(_875))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                          _898 = 1.0f / ((float)((uint)_870));
                                          _901 = 0;
                                          _902 = 0.0f;
                                          _903 = 0.0f;
                                          _904 = 0.0f;
                                          _905 = (_898 * 0.5f);
                                          _906 = cos(_894);
                                          _907 = sin(_894);
                                          bool _loop_break_10 = false;
                                          while (true) {
                                            _909 = sqrt(_905) * _866;
                                            _916 = t0.SampleLevel(s2, float2((((_906 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _909) + _192), (((_907 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _909) + _193)), 0.0f);
                                            _920 = _916.x + _902;
                                            _921 = _916.y + _903;
                                            _922 = _916.z + _904;
                                            _930 = _901 + 1u;
                                            do {
                                              if (!(_930 == _870)) {
                                                _901 = _930;
                                                _902 = _920;
                                                _903 = _921;
                                                _904 = _922;
                                                _905 = (_905 + _898);
                                                _906 = ((_906 * -0.7373688220977783f) - (_907 * 0.6754903793334961f));
                                                _907 = ((_906 * 0.6754903793334961f) - (_907 * 0.7373688220977783f));
                                                _loop_break_10 = true;
                                                break;
                                              }
                                              _936 = saturate(_866);
                                              _1057 = ((_936 * ((_920 * _898) - _837)) + _837);
                                              _1058 = ((_936 * ((_921 * _898) - _838)) + _838);
                                              _1059 = ((_936 * ((_922 * _898) - _839)) + _839);
                                            } while (false);
                                            if (_loop_break_10) {
                                              _loop_break_10 = false;
                                              continue;
                                            }
                                            break;
                                          }
                                        } else {
                                          _1057 = _837;
                                          _1058 = _838;
                                          _1059 = _839;
                                        }
                                      } else {
                                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 2) {
                                          _950 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                          _954 = uint(ceil(_950 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                          if (!(_954 == 0)) {
                                            _959 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                            _960 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                            _978 = ((float((int)(((_960 + _959) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_960)) * 2.0f) + float((int)(_959))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                            _985 = 1.0f / ((float)((uint)_954));
                                            _988 = cos(_978);
                                            _989 = sin(_978);
                                            _990 = (_985 * 0.5f);
                                            _991 = 0.0f;
                                            _992 = 0.0f;
                                            _993 = 0.0f;
                                            _994 = 0;
                                            bool _loop_break_11 = false;
                                            while (true) {
                                              _996 = sqrt(_990) * _950;
                                              _1007 = -0.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832;
                                              _1016 = t0.SampleLevel(s2, float2(((min(max(((((_988 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * _852)) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f), ((min(max(((((_989 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * (_193 + -0.5f))) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f)), 0.0f);
                                              _1020 = _1016.x + _991;
                                              _1021 = _1016.y + _992;
                                              _1022 = _1016.z + _993;
                                              _1030 = _994 + 1u;
                                              do {
                                                if (!(_1030 == _954)) {
                                                  _988 = ((_988 * -0.7373688220977783f) - (_989 * 0.6754903793334961f));
                                                  _989 = ((_988 * 0.6754903793334961f) - (_989 * 0.7373688220977783f));
                                                  _990 = (_990 + _985);
                                                  _991 = _1020;
                                                  _992 = _1021;
                                                  _993 = _1022;
                                                  _994 = _1030;
                                                  _loop_break_11 = true;
                                                  break;
                                                }
                                                _1036 = saturate(_859);
                                                _1057 = ((_1036 * ((_1020 * _985) - _837)) + _837);
                                                _1058 = ((_1036 * ((_1021 * _985) - _838)) + _838);
                                                _1059 = ((_1036 * ((_1022 * _985) - _839)) + _839);
                                              } while (false);
                                              if (_loop_break_11) {
                                                _loop_break_11 = false;
                                                continue;
                                              }
                                              break;
                                            }
                                          } else {
                                            _1057 = _837;
                                            _1058 = _838;
                                            _1059 = _839;
                                          }
                                        } else {
                                          if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 3) {
                                            _1049 = saturate(_859);
                                            _1057 = (_837 - (_1049 * _837));
                                            _1058 = (_838 - (_1049 * _838));
                                            _1059 = (_839 - (_1049 * _839));
                                          } else {
                                            _1057 = _837;
                                            _1058 = _838;
                                            _1059 = _839;
                                          }
                                        }
                                      }
                                    } else {
                                      _1057 = _837;
                                      _1058 = _838;
                                      _1059 = _839;
                                    }
                                  } else {
                                    _1057 = _837;
                                    _1058 = _838;
                                    _1059 = _839;
                                  }
                                }
                                u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(max(_1057, 0.0f), max(_1058, 0.0f), max(_1059, 0.0f), 0.0f);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          }
        } while (false);
      }
    }
  }
  _115 = false;
  if (_115) {
    u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(0.0f, 0.0f, 0.0f, 0.0f);
  } else {
    _118 = t2.SampleLevel(s2, float2(_33, _25), 0.0f);
    _125 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x * 1.5f) * _118.x) + _33;
    _126 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y * 1.5f) * _118.y) + _25;
    do {
      _166 = 0.5f;
      _167 = 0.5f;
      _168 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592;
      _169 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596;
      _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
      _171 = 1.0f;
      _172 = 0;
      if (_45) {
        _133 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y - _126;
        _135 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x - _125) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_800;
        _139 = sqrt((_135 * _135) + (_133 * _133));
        if (_139 < g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796) {
          _143 = _139 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_796;
          _144 = saturate(_143);
          _145 = _144 * _144;
          _166 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.x;
          _167 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_568.y;
          _168 = (((((_145 * _145) * (_144 * 1.5f)) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_592);
          _169 = (lerp(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_596, 0.9200000166893005f, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792));
          _170 = ((((_143 * 0.02250000089406967f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600);
          _171 = (((_143 * (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_608 + -1.0f)) + 1.0f) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_604);
          _172 = 1;
        } else {
          _166 = 0.5f;
          _167 = 0.5f;
          _168 = -0.03500000014901161f;
          _169 = 1.0f;
          _170 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600;
          _171 = 1.0f;
          _172 = 0;
        }
      }
      _173 = _125 - _166;
      _175 = (_126 - _167) * 0.5625f;
      _177 = dot(float2(_173, _175), float2(_173, _175)) * _168;
      _181 = (_125 + -0.5f) + (_177 * _173);
      _183 = (_126 + -0.5f) + (_177 * _175);
      _186 = 0.5f - _166;
      _188 = 0.5f - _167;
      _192 = (((_181 * _169) + _186) / _171) + _166;
      _193 = (((_183 * _169) + _188) / _171) + _167;
      _194 = t0.SampleLevel(s2, float2(_192, _193), 0.0f);
      do {
        _204 = _170;
        if (_45) {
          _204 = (saturate(dot(float3(_194.x, _194.y, _194.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)) * 100.0f) * _170);
        }
        do {
          _244 = _194.y;
          _245 = _194.z;
          if (_45 || (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_600 == 0.0f))) {
            _207 = _169 - (_204 * 0.6000000238418579f);
            _214 = (((_207 * _181) + _186) / _171) + _166;
            _215 = (((_207 * _183) + _188) / _171) + _167;
            _217 = _169 - (_204 * 2.0f);
            _224 = (((_217 * _181) + _186) / _171) + _166;
            _225 = (((_217 * _183) + _188) / _171) + _167;
            if (!(_45)) {
              _244 = (((float4)(t0.SampleLevel(s2, float2(_214, _215), 0.0f))).y);
              _245 = (((float4)(t0.SampleLevel(s2, float2(_224, _225), 0.0f))).z);
            } else {
              _232 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.25f;
              _233 = t0.SampleLevel(s2, float2(_214, _215), 0.0f);
              _238 = t0.SampleLevel(s2, float2(_224, _225), 0.0f);
              _244 = (lerp(_233.y, _194.y, _232));
              _245 = (lerp(_238.z, _194.z, _232));
            }
          }
          do {
            _556 = _194.x;
            _557 = _244;
            _558 = _245;
            if ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_512 & 7) == 7) {
              do {
                _297 = _194.x;
                _298 = _244;
                _299 = _245;
                if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584 > 0.0f) {
                  _248 = _194.x * _194.x;
                  _249 = _244 * _244;
                  _250 = _245 * _245;
                  _252 = saturate(dot(float3(_248, _249, _250), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f)));
                  _255 = _252 + 0.5f;
                  _268 = 0.5f - ((_252 + -0.5f) * 0.5f);
                  _297 = sqrt(((saturate(select((_248 > 0.5f), (1.0f - (_268 * (1.0f - ((_248 + -0.5f) * 2.0f)))), (_255 * _248))) - _248) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _248);
                  _298 = sqrt(((saturate(select((_249 > 0.5f), (1.0f - (_268 * (1.0f - ((_249 + -0.5f) * 2.0f)))), (_255 * _249))) - _249) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _249);
                  _299 = sqrt(((saturate(select((_250 > 0.5f), (1.0f - (_268 * (1.0f - ((_250 + -0.5f) * 2.0f)))), (_255 * _250))) - _250) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_584) + _250);
                }
                do {
                  _323 = _297;
                  _324 = _298;
                  _325 = _299;
                  if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812 > 0.0f) {
                    _323 = saturate((((((_297 * _297) * 6.0f) * _297) - _297) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _297);
                    _324 = saturate((((((_298 * _298) * 6.0f) * _298) - _298) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _298);
                    _325 = saturate((((((_299 * _299) * 6.0f) * _299) - _299) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_812) + _299);
                  }
                  do {
                    _436 = _323;
                    _437 = _324;
                    _438 = _325;
                    if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 2) == 0)) {
                      if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_852 == 9)) {
                        _337 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648 * (((float4)(t10.SampleLevel(s2, float2(_192, _193), 0.0f))).x)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_652;
                        do {
                          _429 = _337;
                          _430 = _337;
                          _431 = _337;
                          if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_680 == 0)) {
                            _347 = _20 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.x * 0.5f);
                            _348 = _21 - (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_544.y * 0.5f);
                            _362 = t11.SampleLevel(s2, float2(_192, _193), 0.0f);
                            _370 = max(((1.0f - saturate(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_660 * sqrt((_347 * _347) + (_348 * _348))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_664) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_668)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_648), _362.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_656;
                            _371 = t12.SampleLevel(s2, float2(_192, _193), 0.0f);
                            do {
                              _421 = _370;
                              if (!(_371.x == 1.0f)) {
                                _379 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_371.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                                _380 = sqrt(_379);
                                _384 = -0.7071067690849304f;
                                _385 = -0.7071067690849304f;
                                _386 = 0.0f;
                                _387 = 0;
                                bool _loop_break_12 = false;
                                while (true) {
                                  _399 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t12.SampleLevel(s2, float2(saturate((_385 * (0.004166666883975267f / _380)) + _192), saturate((_384 * (0.007407407276332378f / _380)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _379), _386);
                                  _400 = _387 + 1;
                                  if (!(_400 == 8)) {
                                    _404 = _global_0[min((uint)(_400), 7u)];
                                    _406 = _global_1[min((uint)(_400), 7u)];
                                    _384 = _406;
                                    _385 = _404;
                                    _386 = _399;
                                    _387 = _400;
                                    _loop_break_12 = true;
                                    break;
                                  } else {
                                    _408 = min(_399, 0.10000000149011612f);
                                    _421 = (((_408 * _408) * _370) * max((1.0f - saturate((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_672 * _379) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_676)), _362.w));
                                  }
                                  break;
                                }
                              }
                              _429 = ((_421 * _362.x) + _337);
                              _430 = ((_421 * _362.y) + _337);
                              _431 = ((_421 * _362.z) + _337);
                            } while (false);
                          }
                          _436 = (_429 + _323);
                          _437 = (_430 + _324);
                          _438 = (_431 + _325);
                        } while (false);
                      } else {
                        _436 = _323;
                        _437 = _324;
                        _438 = _325;
                      }
                    }
                    do {
                      _494 = _436;
                      _495 = _437;
                      _496 = _438;
                      if (!((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_516 & 1) == 0)) {
                        _445 = t9.SampleLevel(s2, float2(_192, _193), 0.0f);
                        if (!(_445.x == 1.0f)) {
                          _449 = t8.SampleLevel(s2, float2(_192, _193), 0.0f);
                          _452 = g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_445.x - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x);
                          _453 = sqrt(_452);
                          _457 = -0.7071067690849304f;
                          _458 = -0.7071067690849304f;
                          _459 = 0.0f;
                          _460 = 0;
                          bool _loop_break_13 = false;
                          while (true) {
                            _472 = max(((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (((t9.SampleLevel(s2, float2(saturate((_458 * (0.004166666883975267f / _453)) + _192), saturate((_457 * (0.007407407276332378f / _453)) + _193)), 0.0f)).x) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_520.x)) - _452), _459);
                            _473 = _460 + 1;
                            if (!(_473 == 8)) {
                              _477 = _global_0[min((uint)(_473), 7u)];
                              _479 = _global_1[min((uint)(_473), 7u)];
                              _457 = _479;
                              _458 = _477;
                              _459 = _472;
                              _460 = _473;
                              _loop_break_13 = true;
                              break;
                            } else {
                              _484 = min(max(_472, 0.0f), 0.10000000149011612f);
                              _486 = (_484 * _484) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_640;
                              _494 = ((_486 * _449.x) + _436);
                              _495 = ((_486 * _449.y) + _437);
                              _496 = ((_486 * _449.z) + _438);
                            }
                            break;
                          }
                        } else {
                          _494 = _436;
                          _495 = _437;
                          _496 = _438;
                        }
                      }
                      do {
                        _541 = _494;
                        _542 = _495;
                        _543 = _496;
                        if (_57) {
                          _520 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.x * _192) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.z) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.z;
                          _521 = ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.y * _193) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_384.w) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.w;
                          _528 = saturate(saturate((1.0f - (sqrt(dot(float2(_520, _521), float2(_520, _521))) * 2.0f)) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_368.y));
                          _533 = 1.0f - ((_528 * _528) * (3.0f - (_528 * 2.0f)));
                          _541 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.x * (1.0f - _494)) * _533) + _494);
                          _542 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.y * (1.0f - _495)) * _533) + _495);
                          _543 = (((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_416.z * (1.0f - _496)) * _533) + _496);
                        }
                        if (!((_172 != 0) || (!_45))) {
                          _551 = 1.0f - ((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_792 * 0.1499999761581421f) * saturate(_125));
                          _556 = (_551 * _541);
                          _557 = (_551 * _542);
                          _558 = (_551 * _543);
                        } else {
                          _556 = _541;
                          _557 = _542;
                          _558 = _543;
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            }
            do {
              _578 = _556;
              _579 = _557;
              _580 = _558;
              if (_64) {
                _564 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                _578 = (lerp(_556, _564.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                _579 = (lerp(_557, _564.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
                _580 = (lerp(_558, _564.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_612));
              }
              do {
                _614 = _578;
                _615 = _579;
                _616 = _580;
                if (_66) {
                  _588 = t7.SampleLevel(s2, float2((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x * _33), (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y * _25)), 0.0f);
                  _593 = (1.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_616) * 1.0999999046325684f;
                  _596 = select((g_postPostProcessingShaderConst_000.PostProcessingShaderConst_620 == 0), _33, (1.0f - _33));
                  _597 = _593 + -0.10000000149011612f;
                  if (!(_596 < _597)) {
                    if (!(_596 > _593)) {
                      _603 = (_596 - _597) * 10.0f;
                      _614 = (lerp(_578, _588.x, _603));
                      _615 = (lerp(_579, _588.y, _603));
                      _616 = (lerp(_580, _588.z, _603));
                    } else {
                      _614 = _588.x;
                      _615 = _588.y;
                      _616 = _588.z;
                    }
                  } else {
                    _614 = _578;
                    _615 = _579;
                    _616 = _580;
                  }
                }
                do {
                  _653 = _614;
                  _654 = _615;
                  _655 = _616;
                  if ((_64 || _66) && (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_856 != 0)) {
                    if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684 > 0.0f) {
                      _639 = t17.SampleLevel(s2, float3(((saturate(_614) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_615) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_616) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_432.z)), 0.0f);
                      _653 = (lerp(_614, _639.x, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                      _654 = (lerp(_615, _639.y, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                      _655 = (lerp(_616, _639.z, g_postPostProcessingShaderConst_000.PostProcessingShaderConst_684));
                    } else {
                      _653 = _614;
                      _654 = _615;
                      _655 = _616;
                    }
                  }
                  do {
                    _720 = _653;
                    _721 = _654;
                    _722 = _655;
                    if (!(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624 == 0)) {
                      _665 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_632)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x);
                      _666 = int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_636)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y);
                      uint2 _667;
                      t7.GetDimensions(_667.x, _667.y);
                      if (!((int)(int)(SV_DispatchThreadID.x) < (int)_665)) {
                        _673 = float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_628));
                        if (((int)(int)(SV_DispatchThreadID.y) < (int)(int(_673 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y) + _666)) && (((int)(int)(SV_DispatchThreadID.y) >= (int)_666) && ((int)(int)(SV_DispatchThreadID.x) < (int)(int(float((int)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_624)) / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) + _665)))) {
                          _692 = float((int)((int)(SV_DispatchThreadID.y - _666))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.y;
                          _694 = (float)((uint)_667.y);
                          _695 = (float((int)((int)(SV_DispatchThreadID.x - _665))) * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_576.x) / ((float)((uint)_667.x));
                          _697 = t7.SampleLevel(s2, float2(_695, (_692 / _694)), 0.0f);
                          _703 = t7.SampleLevel(s2, float2(_695, ((_692 + _673) / _694)), 0.0f);
                          _709 = ((_703.x + _703.y) + _703.z) * 0.3333333432674408f;
                          _720 = ((_709 * (_697.x - _653)) + _653);
                          _721 = ((_709 * (_697.y - _654)) + _654);
                          _722 = ((_709 * (_697.z - _655)) + _655);
                        } else {
                          _720 = _653;
                          _721 = _654;
                          _722 = _655;
                        }
                      } else {
                        _720 = _653;
                        _721 = _654;
                        _722 = _655;
                      }
                    }
                    do {
                      _745 = ApplyVanillaFilmGrain(float3(_720, _721, _722), float2(_33, _25));
                      _823 = _745.x;
                      _824 = _745.y;
                      _825 = _745.z;
                      _837 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.x * _823) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.x;
                      _838 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.y * _824) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.y;
                      _839 = (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_336.z * _825) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_352.z;
                      do {
                        _1057 = _837;
                        _1058 = _838;
                        _1059 = _839;
                        if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 < 1.0f) {
                          if (sqrt(((_837 * _837) + (_838 * _838)) + (_839 * _839)) > 0.0f) {
                            _852 = _192 + -0.5f;
                            _859 = saturate(((abs(_852) * 2.0f) - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) / (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_836 - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832));
                            if (_859 > 0.0f) {
                              if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 1) {
                                _866 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                _870 = uint(ceil(_866 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                if (!(_870 == 0)) {
                                  _875 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                  _876 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                  _894 = ((float((int)(((_876 + _875) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_876)) * 2.0f) + float((int)(_875))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                  _898 = 1.0f / ((float)((uint)_870));
                                  _901 = 0;
                                  _902 = 0.0f;
                                  _903 = 0.0f;
                                  _904 = 0.0f;
                                  _905 = (_898 * 0.5f);
                                  _906 = cos(_894);
                                  _907 = sin(_894);
                                  bool _loop_break_14 = false;
                                  while (true) {
                                    _909 = sqrt(_905) * _866;
                                    _916 = t0.SampleLevel(s2, float2((((_906 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _909) + _192), (((_907 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _909) + _193)), 0.0f);
                                    _920 = _916.x + _902;
                                    _921 = _916.y + _903;
                                    _922 = _916.z + _904;
                                    _930 = _901 + 1u;
                                    do {
                                      if (!(_930 == _870)) {
                                        _901 = _930;
                                        _902 = _920;
                                        _903 = _921;
                                        _904 = _922;
                                        _905 = (_905 + _898);
                                        _906 = ((_906 * -0.7373688220977783f) - (_907 * 0.6754903793334961f));
                                        _907 = ((_906 * 0.6754903793334961f) - (_907 * 0.7373688220977783f));
                                        _loop_break_14 = true;
                                        break;
                                      }
                                      _936 = saturate(_866);
                                      _1057 = ((_936 * ((_920 * _898) - _837)) + _837);
                                      _1058 = ((_936 * ((_921 * _898) - _838)) + _838);
                                      _1059 = ((_936 * ((_922 * _898) - _839)) + _839);
                                    } while (false);
                                    if (_loop_break_14) {
                                      _loop_break_14 = false;
                                      continue;
                                    }
                                    break;
                                  }
                                } else {
                                  _1057 = _837;
                                  _1058 = _838;
                                  _1059 = _839;
                                }
                              } else {
                                if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 2) {
                                  _950 = _859 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_840;
                                  _954 = uint(ceil(_950 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_844));
                                  if (!(_954 == 0)) {
                                    _959 = int(_192 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x);
                                    _960 = int(_193 / g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y);
                                    _978 = ((float((int)(((_960 + _959) + g_postPostProcessingShaderConst_000.PostProcessingShaderConst_828) & 1)) * 0.10000000149011612f) + frac((((float((int)(_960)) * 2.0f) + float((int)(_959))) + ((float)((uint)(uint)(g_postPostProcessingShaderConst_000.PostProcessingShaderConst_824)))) * 0.20000000298023224f)) * 6.2831854820251465f;
                                    _985 = 1.0f / ((float)((uint)_954));
                                    _988 = cos(_978);
                                    _989 = sin(_978);
                                    _990 = (_985 * 0.5f);
                                    _991 = 0.0f;
                                    _992 = 0.0f;
                                    _993 = 0.0f;
                                    _994 = 0;
                                    bool _loop_break_15 = false;
                                    while (true) {
                                      _996 = sqrt(_990) * _950;
                                      _1007 = -0.0f - g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832;
                                      _1016 = t0.SampleLevel(s2, float2(((min(max(((((_988 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.x) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * _852)) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f), ((min(max(((((_989 * g_postPostProcessingShaderConst_000.PostProcessingShaderConst_536.y) * _996) + (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832 * (_193 + -0.5f))) * 2.0f), _1007), g_postPostProcessingShaderConst_000.PostProcessingShaderConst_832) * 0.5f) + 0.5f)), 0.0f);
                                      _1020 = _1016.x + _991;
                                      _1021 = _1016.y + _992;
                                      _1022 = _1016.z + _993;
                                      _1030 = _994 + 1u;
                                      do {
                                        if (!(_1030 == _954)) {
                                          _988 = ((_988 * -0.7373688220977783f) - (_989 * 0.6754903793334961f));
                                          _989 = ((_988 * 0.6754903793334961f) - (_989 * 0.7373688220977783f));
                                          _990 = (_990 + _985);
                                          _991 = _1020;
                                          _992 = _1021;
                                          _993 = _1022;
                                          _994 = _1030;
                                          _loop_break_15 = true;
                                          break;
                                        }
                                        _1036 = saturate(_859);
                                        _1057 = ((_1036 * ((_1020 * _985) - _837)) + _837);
                                        _1058 = ((_1036 * ((_1021 * _985) - _838)) + _838);
                                        _1059 = ((_1036 * ((_1022 * _985) - _839)) + _839);
                                      } while (false);
                                      if (_loop_break_15) {
                                        _loop_break_15 = false;
                                        continue;
                                      }
                                      break;
                                    }
                                  } else {
                                    _1057 = _837;
                                    _1058 = _838;
                                    _1059 = _839;
                                  }
                                } else {
                                  if (g_postPostProcessingShaderConst_000.PostProcessingShaderConst_848 == 3) {
                                    _1049 = saturate(_859);
                                    _1057 = (_837 - (_1049 * _837));
                                    _1058 = (_838 - (_1049 * _838));
                                    _1059 = (_839 - (_1049 * _839));
                                  } else {
                                    _1057 = _837;
                                    _1058 = _838;
                                    _1059 = _839;
                                  }
                                }
                              }
                            } else {
                              _1057 = _837;
                              _1058 = _838;
                              _1059 = _839;
                            }
                          } else {
                            _1057 = _837;
                            _1058 = _838;
                            _1059 = _839;
                          }
                        }
                        float3 final_output = tlou2::post_post_processing::ApplyFinalOutput(float3(_1057, _1058, _1059), float2(_33, _25));
                        u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(max(final_output, 0.0f), 0.0f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  }
}
