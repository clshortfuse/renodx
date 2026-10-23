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

Texture2D<float3> t1 : register(t1);

Texture2D<float> t2 : register(t2);

Texture2D<float> t3 : register(t3);

Texture2D<float> t4 : register(t4);

Texture2D<float> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

Texture3D<float4> t8 : register(t8);

Texture2D<float3> t9 : register(t9);

ByteAddressBuffer t10 : register(t10);

RWTexture2D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  PostProcessingShaderConst g_prePostProcessingShaderConst_000 : packoffset(c000.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

// Reverse-engineering notes (names are inferred from data flow, not recovered symbols):
//   t0       Main scene/post-process color.
//   t1/t2    Low-resolution effect color plus scalar blend/transmittance data. These are
//            composited directly or depth-aware upsampled before being merged with t0.
//   t3       Full-resolution depth used by bilateral upsampling and world-position reconstruction.
//   t4       Depth used to derive the circle-of-confusion/defocus amount.
//   t5       Low-resolution depth paired with t1/t2 for bilateral upsampling.
//   t6       Additive/screen-like bloom or light-effect contribution.
//   t7       Optional first 3D color LUT, sampled through a custom extended-range shaper.
//   t8       Second 3D color LUT/color grade, blended by Const_684.
//   t9       Auxiliary per-pixel gate used to restrict the sharpening path.
//   t10      Byte-address buffer containing the current exposure/pre-exposure scalar.
//   u0       Pre-post-processing output consumed by later post-processing passes.
//
// Approximate pipeline:
//   1. Sample scene color, depth, exposure, and derive a depth-of-field amount.
//   2. Run a combined 3x3 sharpening and depth-of-field neighborhood filter.
//   3. Composite a low-resolution effect using optional depth-aware bilateral upsampling.
//   4. Add bloom/light effects, vignette, luminance-dependent desaturation, and directional masks.
//   5. Apply exposure and the optional rational/filmic tonemap.
//   6. Encode to sRGB where required and sample up to two 3D color LUTs.
//   7. Select or blend the configured output-mode/reference-color paths.
//   8. Add an optional depth-reconstructed localized glow, shape dark values, and clamp output.
//
// This is a decompilation, so effect labels such as "bloom" and "localized glow" describe
// the observed math; the engine's original feature names remain unproven.
float3 ApplyLUTShaper(float3 encoded_color, float input_scale) {
  float3 scaled_color = encoded_color * input_scale;
  return saturate((max(pow(scaled_color, 0.75f) - 1.f, 0.f) + saturate(scaled_color)) / input_scale * 0.5f);
}

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  bool _29;
  bool _32;
  bool _35;
  float _36;
  float _37;
  float _43;
  float _44;
  float4 _45;
  float _49;
  int _52;
  float _53;
  // uint2 _68;
  float _70;
  float _73;
  float _76;
  float _78;
  float _79;
  float _83;
  float _84;
  float _92;
  float _103;
  float _111;
  int _121;
  float _131;
  float _136;
  float _137;
  float _138;
  float _139;
  float _140;
  float _141;
  int _142;
  float _144;
  float _145;
  float _146;
  float _147;
  float _148;
  float _149;
  int _150;
  bool _161;
  float _198;
  float _199;
  float _200;
  float _201;
  float _202;
  float _203;
  float _259;
  float _260;
  float _261;
  float _283;
  float _284;
  float _285;
  float _459;
  float _460;
  float _461;
  bool _475;
  float _500;
  float _501;
  float _502;
  float _548;
  float _549;
  float _550;
  float _567;
  float _578;
  float _579;
  float _580;
  float _616;
  float _617;
  float _641;
  float _642;
  float _643;
  float _667;
  float _668;
  float _669;
  float _729;
  float _730;
  float _731;
  float _732;
  float _733;
  float _734;
  float _824;
  float _825;
  float _826;
  float _852;
  float _853;
  float _854;
  float _897;
  float _898;
  float _899;
  float _924;
  float _936;
  float _937;
  float _938;
  float _1053;
  float _1054;
  float _1055;
  float _1075;
  float _1076;
  float _1077;
  float _134;
  int _156;
  float _162;
  float _163;
  float _165;
  float _166;
  float _167;
  float _170;
  float4 _181;
  int _204;
  int _207;
  float _210;
  bool _247;
  float _248;
  float _249;
  float _250;
  float _274;
  float3 _278;
  float _289;
  float _300;
  float _301;
  float _304;
  float _305;
  int _306;
  int _307;
  float _308;
  float _309;
  float _310;
  float _316;
  uint _319;
  uint _322;
  float _331;
  float _332;
  float _333;
  float _334;
  float _347;
  float _348;
  float _353;
  float _354;
  float _355;
  float _356;
  float3 _363;
  float _367;
  float _380;
  float _381;
  float3 _382;
  float3 _388;
  float3 _394;
  float3 _400;
  float _434;
  float _438;
  float3 _446;
  float _450;
  float _479;
  float4 _489;
  float _522;
  float _523;
  float _530;
  float _534;
  float _554;
  float _561;
  float _590;
  float _591;
  float _600;
  float _605;
  float _610;
  float _612;
  float _636;
  float _662;
  int _673;
  float _674;
  bool _681;
  float _689;
  float _690;
  float _691;
  bool _753;
  float _776;
  float _777;
  float _778;
  float4 _819;
  float4 _838;
  bool _856;
  float _880;
  float _881;
  float _882;
  float _883;
  float _914;
  float _925;
  float _945;
  float _981;
  float _984;
  float _1000;
  float _1008;
  float _1010;
  float _1012;
  float _1018;
  float _1019;
  float _1021;
  float _1048;
  float _1059;
  float _1067;
  // Feature gates for two directional masks and the neighborhood defocus filter.
  _29 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_724 > 0.0f);
  _32 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_744 > 0.0f);
  _35 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_776 > 0.0f);
  // Step 1: build pixel-center UV and fetch the main color and depth inputs.
  _36 = float((int)((int)(SV_DispatchThreadID.x)));
  _37 = float((int)((int)(SV_DispatchThreadID.y)));
  _43 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_536.x * (_36 + 0.5f);
  _44 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_536.y * (_37 + 0.5f);
  _45 = t0.SampleLevel(s1, float2(_43, _44), 0.0f);
  _49 = t4.SampleLevel(s0, float2(_43, _44), 0.0f);
  // t10[0] is interpreted as a float exposure/pre-exposure value.
  _52 = t10.Load4(0).x;
  _53 = asfloat(_52);
  uint2 _68;
  t0.GetDimensions(_68.x, _68.y);
  _70 = float((int)((int)(_68.x)));
  // Step 2: reconstruct depth and derive a resolution-normalized circle-of-confusion.
  // Positive values become _111, the blend weight for the 3x3 defocus neighborhood.
  _73 = 2560.0f / _70;
  _76 = 1.0f / ((_49.x * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_528.x) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_528.y);
  _78 = 1.0f / (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_528.x + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_528.y);
  _79 = _76 - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_780;
  _83 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_784 * (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_780 + -0.07000000029802322f);
  _84 = ((_79 / _76) * 0.004900000058114529f) / _83;
  _92 = ((_73 * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_788) * _84) * ((_84 * _83) / (((_78 - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_780) / _78) * 0.004900000058114529f));
  _103 = 1.0f - _49.x;
  _111 = (max(float((int)(((int)(uint)((int)(_79 > 0.0f))) - ((int)(uint)((int)(_79 < 0.0f))))), 0.0f) * saturate(_92 * _92)) * max(float((int)(((int)(uint)((int)(_103 > 0.0f))) - ((int)(uint)((int)(_103 < 0.0f))))), 0.0f);
  // Decide whether sharpening is active. One mode gates it with t9.x; the fallback
  // enables it whenever the configured sharpening coefficient is nontrivial.
  if (!(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_720 == 0)) {
    _121 = ((int)(uint)((int)((((float3)(t9.SampleLevel(s0, float2(_43, _44), 0.0f))).x) < 0.800000011920929f)));
  } else {
    _121 = ((int)(uint)((int)(abs(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_708) > 0.0010000000474974513f)));
  }
  if (_53 > 0.0f) {
    _131 = max(((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_712 - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.z) / _53), 0.0f);
  } else {
    _131 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_712;
  }
  // Step 3: traverse a 3x3 neighborhood. Cardinal samples form a Laplacian-like
  // sharpen term; all eight neighbors form the depth-of-field box-filter term.
  _134 = _111 * 0.125f;
  _136 = (_45.x * 4.0f);
  _137 = (_45.y * 4.0f);
  _138 = (_45.z * 4.0f);
  _139 = 0.0f;
  _140 = 0.0f;
  _141 = 0.0f;
  _142 = -1;
  bool _loop_break_0 = false;
  while (true) {
    _144 = _136;
    _145 = _137;
    _146 = _138;
    _147 = _139;
    _148 = _140;
    _149 = _141;
    _150 = -1;
    bool _loop_break_1 = false;
    while (true) {
      if (!((_150 | _142) == 0)) {
        do {
          _161 = false;
          if (!(_121 == 0)) {
            _156 = _150 + _142;
            _161 = (max((int)(_156), (int)((0 - _156))) == 1);
          }
          _162 = float((int)(_142));
          _163 = float((int)(_150));
          _165 = rsqrt(dot(float2(_162, _163), float2(_162, _163)));
          _166 = _165 * _162;
          _167 = _165 * _163;
          if (_35 || _161) {
            _170 = _111 * 0.75f;
            _181 = t0.SampleLevel(s1, float2((((((_166 * _170) + _166) * (1.0f / _70)) / _73) + _43), (((((_167 * _170) + _167) * (1.0f / float((int)((int)(_68.y))))) / _73) + _44)), 0.0f);
            _198 = select(_161, (_144 - _181.x), _144);
            _199 = select(_161, (_145 - _181.y), _145);
            _200 = select(_161, (_146 - _181.z), _146);
            _201 = ((_181.x * _134) + _147);
            _202 = ((_181.y * _134) + _148);
            _203 = ((_181.z * _134) + _149);
          } else {
            _198 = _144;
            _199 = _145;
            _200 = _146;
            _201 = _147;
            _202 = _148;
            _203 = _149;
          }
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _198 = _144;
        _199 = _145;
        _200 = _146;
        _201 = _147;
        _202 = _148;
        _203 = _149;
      }
      _204 = _150 + 1;
      if (!(_204 == 2)) {
        _144 = _198;
        _145 = _199;
        _146 = _200;
        _147 = _201;
        _148 = _202;
        _149 = _203;
        _150 = _204;
        continue;
      }
      _207 = _142 + 1;
      if (!(_207 == 2)) {
        _136 = _198;
        _137 = _199;
        _138 = _200;
        _139 = _201;
        _140 = _202;
        _141 = _203;
        _142 = _207;
        _loop_break_0 = true;
        break;
      }
      _210 = 1.0f - _111;
      _247 = (_121 != 0);
      // Apply the bounded signed sharpening correction to the center sample.
      _248 = select(_247, max((((float((int)(((int)(uint)((int)(_198 > 0.0f))) - ((int)(uint)((int)(_198 < 0.0f))))) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_708) * min(abs(_198), _131)) + _45.x), 0.0f), _45.x);
      _249 = select(_247, max((((float((int)(((int)(uint)((int)(_199 > 0.0f))) - ((int)(uint)((int)(_199 < 0.0f))))) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_708) * min(abs(_199), _131)) + _45.y), 0.0f), _45.y);
      _250 = select(_247, max((((float((int)(((int)(uint)((int)(_200 > 0.0f))) - ((int)(uint)((int)(_200 < 0.0f))))) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_708) * min(abs(_200), _131)) + _45.z), 0.0f), _45.z);
      if (_35) {
        // Blend the sharpened center toward the accumulated 3x3 neighborhood by CoC.
        _259 = ((_248 * _210) + _201);
        _260 = ((_249 * _210) + _202);
        _261 = ((_250 * _210) + _203);
      } else {
        _259 = _248;
        _260 = _249;
        _261 = _250;
      }
      // Step 4: composite the low-resolution effect carried by t1/t2.
      // Depending on flags this is a direct alpha blend, an additive/transmittance
      // composite, or a depth-aware bilateral upsample using full-res t3 and low-res t5.
      if (!((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_512 & 8) == 0)) {
        if (!((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_516 & 16384) == 0)) {
          _274 = t2.SampleLevel(s1, float2(_43, _44), 0.0f);
          do {
            _283 = 0.0f;
            _284 = 0.0f;
            _285 = 0.0f;
            if (_274.x > 0.0f) {
              _278 = t1.SampleLevel(s1, float2(_43, _44), 0.0f);
              _283 = _278.x;
              _284 = _278.y;
              _285 = _278.z;
            }
            _289 = 1.0f - _274.x;
            _459 = ((_283 * _274.x) + (_289 * _259));
            _460 = ((_284 * _274.x) + (_289 * _260));
            _461 = ((_285 * _274.x) + (_289 * _261));
          } while (false);
          if (_loop_break_1 && !_loop_break_0) {
            _loop_break_1 = false;
            continue;
          }
        } else {
          if (!((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_516 & 4) == 0)) {
            _300 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_544.x * 0.5f;
            _301 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_544.y * 0.5f;
            _304 = (_300 * _43) + -0.5f;
            _305 = (_301 * _44) + -0.5f;
            _306 = int(_304);
            _307 = int(_305);
            _308 = frac(_304);
            _309 = frac(_305);
            _310 = t3.SampleLevel(s0, float2(_43, _44), 0.0f);
            _316 = min(select((_310.x == 1.0f), 65535.0f, (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_520.y / (_310.x - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_520.x))), 50.0f);
            // Compare reconstructed full-resolution depth against the four neighboring
            // low-resolution depths and use exponential depth similarity as sample weights.
            _319 = _306 + 1u;
            _322 = _307 + 1u;
            _331 = abs(((t5.Load(int3(_306, _307, 0))).x) - _316);
            _332 = abs(((t5.Load(int3(_319, _307, 0))).x) - _316);
            _333 = abs(((t5.Load(int3(_306, _322, 0))).x) - _316);
            _334 = abs(((t5.Load(int3(_319, _322, 0))).x) - _316);
            _347 = 1.0f - _308;
            _348 = 1.0f - _309;
            _353 = (_348 * _347) * max(exp2(_331 * -10.0f), 9.999999747378752e-06f);
            _354 = (_348 * _308) * max(exp2(_332 * -10.0f), 9.999999747378752e-06f);
            _355 = (_347 * _309) * max(exp2(_333 * -10.0f), 9.999999747378752e-06f);
            _356 = (_309 * _308) * max(exp2(_334 * -10.0f), 9.999999747378752e-06f);
            if ((max(max(_331, max(_332, _333)), _334) / _316) < 0.00800000037997961f) {
              _363 = t1.SampleLevel(s1, float2(_43, _44), 0.0f);
              _367 = t2.SampleLevel(s1, float2(_43, _44), 0.0f);
              _459 = ((_367.x * _259) + _363.x);
              _460 = ((_367.x * _260) + _363.y);
              _461 = ((_367.x * _261) + _363.z);
            } else {
              _380 = (float((int)(_306)) + 0.5f) / _300;
              _381 = (float((int)(_307)) + 0.5f) / _301;
              _382 = t1.SampleLevel(s0, float2(_380, _381), 0.0f);
              _388 = t1.SampleLevel(s0, float2(_380, _381), 0.0f, int2(1, 0));
              _394 = t1.SampleLevel(s0, float2(_380, _381), 0.0f, int2(0, 1));
              _400 = t1.SampleLevel(s0, float2(_380, _381), 0.0f, int2(1, 1));
              _434 = dot(float4(_353, _354, _355, _356), float4(1.0f, 1.0f, 1.0f, 1.0f));
              _438 = ((((((t2.SampleLevel(s0, float2(_380, _381), 0.0f, int2(1, 0))).x) * _354) + (((t2.SampleLevel(s0, float2(_380, _381), 0.0f)).x) * _353)) + (((t2.SampleLevel(s0, float2(_380, _381), 0.0f, int2(0, 1))).x) * _355)) + (((t2.SampleLevel(s0, float2(_380, _381), 0.0f, int2(1, 1))).x) * _356)) / _434;
              _459 = ((_438 * _259) + (((((_388.x * _354) + (_382.x * _353)) + (_394.x * _355)) + (_400.x * _356)) / _434));
              _460 = ((_438 * _260) + (((((_388.y * _354) + (_382.y * _353)) + (_394.y * _355)) + (_400.y * _356)) / _434));
              _461 = ((_438 * _261) + (((((_388.z * _354) + (_382.z * _353)) + (_394.z * _355)) + (_400.z * _356)) / _434));
            }
          } else {
            _446 = t1.SampleLevel(s1, float2(_43, _44), 0.0f);
            _450 = t2.SampleLevel(s1, float2(_43, _44), 0.0f);
            _459 = ((_450.x * _259) + _446.x);
            _460 = ((_450.x * _260) + _446.y);
            _461 = ((_450.x * _261) + _446.z);
          }
        }
      } else {
        _459 = _259;
        _460 = _260;
        _461 = _261;
      }
      // Step 5: optional screen-like bloom/light-effect composite from t6. The effect
      // is strongest where the existing channel is below the configured normalization level.
      if (!((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_512 & 1) == 0)) {
        if (!(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_288.x > 0.0f)) {
          _475 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_272.x > 0.0f);
        } else {
          _475 = true;
        }
      } else {
        _475 = false;
      }
      if (_475) {
        _479 = max(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_256.x, 1.0f);
        _489 = t6.SampleLevel(s1, float2(_43, _44), 0.0f);
        _500 = ((_489.x * (1.0f - saturate(_459 / _479))) + _459);
        _501 = ((_489.y * (1.0f - saturate(_460 / _479))) + _460);
        _502 = ((_489.z * (1.0f - saturate(_461 / _479))) + _461);
      } else {
        _500 = _459;
        _501 = _460;
        _502 = _461;
      }
      // Step 6: presentation grading before exposure/tonemapping.
      if ((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_512 & 7) == 7) {
        do {
          _548 = _500;
          _549 = _501;
          _550 = _502;
          // Elliptical vignette/color multiplier using Const_384 for UV transform,
          // Const_368 for shape, and Const_400.rgb for edge color multipliers.
          if (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_368.x > 0.5f) {
            _522 = ((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_384.x * _43) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_384.z) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_368.z;
            _523 = ((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_384.y * _44) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_384.w) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_368.w;
            _530 = saturate(saturate((1.0f - (sqrt(dot(float2(_522, _523), float2(_522, _523))) * 2.0f)) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_368.y));
            _534 = (_530 * _530) * (3.0f - (_530 * 2.0f));
            _548 = (((_534 * (1.0f - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_400.x)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_400.x) * _500);
            _549 = (((_534 * (1.0f - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_400.y)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_400.y) * _501);
            _550 = (((_534 * (1.0f - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_400.z)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_400.z) * _502);
          }
          _554 = dot(float3(_548, _549, _550), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
          do {
            // Luminance-dependent desaturation: compute a gray reference and move each
            // channel toward it by a strength that changes between shadows and highlights.
            _567 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.w;
            if (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.y > 0.0f) {
              _561 = saturate(1.0f - (_554 * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.y));
              _567 = (((_561 * _561) * (max(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.x, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.w) - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.w)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.w);
            }
            _578 = ((_567 * (_554 - _548)) + _548);
            _579 = ((_567 * (_554 - _549)) + _549);
            _580 = ((_567 * (_554 - _550)) + _550);
          } while (false);
          if (_loop_break_1 && !_loop_break_0) break;
        } while (false);
        if (_loop_break_1 && !_loop_break_0) {
          _loop_break_1 = false;
          continue;
        }
      } else {
        _578 = _500;
        _579 = _501;
        _580 = _502;
      }
      // Step 7: reconstruct and normalize a view/world direction from the supplied matrix.
      // Its X/Y components drive two independent directional screen-space attenuation masks.
      if (_29 || _32) {
        _590 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_160.x * _36) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_160.z;
        _591 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_160.y * _37) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_160.w;
        _600 = dot(float4((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[0].x), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[1].x), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[2].x), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[3].x)), float4(_590, _591, 1.0f, 0.0f));
        _605 = dot(float4((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[0].y), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[1].y), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[2].y), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[3].y)), float4(_590, _591, 1.0f, 0.0f));
        _610 = dot(float4((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[0].z), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[1].z), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[2].z), (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_000[3].z)), float4(_590, _591, 1.0f, 0.0f));
        _612 = rsqrt(dot(float3(_600, _605, _610), float3(_600, _605, _610)));
        _616 = (_612 * _600);
        _617 = (_612 * _605);
      }
      if (_29) {
        _636 = ((exp2(log2(saturate(1.0f - (((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_736 * _617) - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_732) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_740))) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_728) + -1.0f) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_724) + 1.0f;
        _641 = (_636 * _578);
        _642 = (_636 * _579);
        _643 = (_636 * _580);
      } else {
        _641 = _578;
        _642 = _579;
        _643 = _580;
      }
      if (_32) {
        _662 = ((exp2(log2(saturate(1.0f - (((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_756 * _616) - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_752) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_760))) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_748) + -1.0f) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_744) + 1.0f;
        _667 = (_662 * _641);
        _668 = (_662 * _642);
        _669 = (_662 * _643);
      } else {
        _667 = _641;
        _668 = _642;
        _669 = _643;
      }
      // Step 8: apply the exposure/pre-exposure scalar from t10 and a black offset.
      _673 = t10.Load4(0).x;
      _674 = asfloat(_673);
      _681 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.x > 0.5f);
      if (RENODX_TONE_MAP_TYPE == 0.f) {
        // Preserve the complete original SDR, HDR, and comparison-mode behavior.
        if (!((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_512 & 4) == 0)) {
          _689 = max(((_674 * _667) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.z), 0.0f);
          _690 = max(((_674 * _668) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.z), 0.0f);
          _691 = max(((_674 * _669) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.z), 0.0f);
          // Optional rational/filmic tonemap. Keep _732.._734 as the exposed linear
          // pre-tonemap reference for later output-mode and reconstruction branches.
          if ((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_692 != 2) && (!_681)) {
            if (!(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_208.x == 0.0f)) {
              _729 = ((((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.y * _689) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.z) / (((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.x + _689) * _689) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.y)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.x);
              _730 = ((((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.y * _690) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.z) / (((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.x + _690) * _690) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.y)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.x);
              _731 = ((((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.y * _691) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.z) / (((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.x + _691) * _691) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.y)) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.x);
              _732 = _689;
              _733 = _690;
              _734 = _691;
            } else {
              _729 = _689;
              _730 = _690;
              _731 = _691;
              _732 = _689;
              _733 = _690;
              _734 = _691;
            }
          } else {
            _729 = _689;
            _730 = _690;
            _731 = _691;
            _732 = _689;
            _733 = _690;
            _734 = _691;
          }
        } else {
          _729 = _667;
          _730 = _668;
          _731 = _669;
          _732 = _667;
          _733 = _668;
          _734 = _669;
        }
        _753 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_692 == 2);
        if (!(_753)) {
          // Step 9: encode the tonemapped color with the exact piecewise sRGB OETF.
          _776 = renodx::color::srgb::Encode(_729);
          _777 = renodx::color::srgb::Encode(_730);
          _778 = renodx::color::srgb::Encode(_731);
          if (_681) {
            // Optional LUT A (t7). An extended-range shaper folds values above one
            // into a bounded coordinate before applying the LUT scale and half-texel bias.
            _819 = t7.SampleLevel(s1, ApplyLUTShaper(float3(_776, _777, _778), g_prePostProcessingShaderConst_000.PostProcessingShaderConst_688) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.y + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.z,
                                  0.0f);
            _824 = _819.x;
            _825 = _819.y;
            _826 = _819.z;
          } else {
            _824 = _776;
            _825 = _777;
            _826 = _778;
          }
        } else {
          _824 = _729;
          _825 = _730;
          _826 = _731;
        }
        // Optional LUT B (t8), blended with its input by Const_684.
        if (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_684 > 0.0f) {
          _838 = t8.SampleLevel(s1, float3(((saturate(_824) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_825) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.z), ((saturate(_826) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.y) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_432.z)), 0.0f);
          _852 = (lerp(_824, _838.x, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_684));
          _853 = (lerp(_825, _838.y, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_684));
          _854 = (lerp(_826, _838.z, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_684));
        } else {
          _852 = _824;
          _853 = _825;
          _854 = _826;
        }
        // Step 10: build an alternate sRGB reference from the exposed pre-tonemap color.
        // Const_496 controls reference desaturation and per-channel scaling. Modes 2-4
        // select or spatially blend this reference against the LUT-processed result.
        _856 = ((uint)((int)((uint)(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_692) + (uint)(-3))) < (uint)2);
        if (_753 || _856) {
          _880 = renodx::color::srgb::Encode(_729);
          _881 = renodx::color::srgb::Encode(_730);
          _882 = renodx::color::srgb::Encode(_731);
          _883 = dot(float3(_880, _881, _882), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
          _897 = ((lerp(_880, _883, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_496.w))*g_prePostProcessingShaderConst_000.PostProcessingShaderConst_496.x);
          _898 = ((lerp(_881, _883, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_496.w))*g_prePostProcessingShaderConst_000.PostProcessingShaderConst_496.y);
          _899 = ((lerp(_882, _883, g_prePostProcessingShaderConst_000.PostProcessingShaderConst_496.w))*g_prePostProcessingShaderConst_000.PostProcessingShaderConst_496.z);
        } else {
          _897 = _732;
          _898 = _733;
          _899 = _734;
        }
        if (!(_753 || (!_856))) {
          _914 = ((1.0f - (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_644 * 2.5f)) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_700) * exp2(log2(max(_852, max(_853, _854))) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_696);
          do {
            _924 = _914;
            if (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_692 == 4) {
              _924 = (saturate((((_37 * 0.25f) + _36) - float((int)(g_prePostProcessingShaderConst_000.PostProcessingShaderConst_704))) * 0.03999999910593033f) * _914);
            }
            _925 = saturate(_924);
            _936 = ((_925 * (_897 - _852)) + _852);
            _937 = ((_925 * (_898 - _853)) + _853);
            _938 = ((_925 * (_899 - _854)) + _854);
          } while (false);
          if (_loop_break_1 && !_loop_break_0) {
            _loop_break_1 = false;
            continue;
          }
        } else {
          _936 = select(_753, _897, _852);
          _937 = select(_753, _898, _853);
          _938 = select(_753, _899, _854);
        }
      } else {
        const float3 processed_scene = float3(_667, _668, _669);
        float3 exposed_scene = processed_scene;
        float3 graded = processed_scene;

        float anchor = 0.18f;
        float tm_peak = 1.f;
        if ((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_512 & 4) != 0) {
          exposed_scene = max((_674 * processed_scene) + g_prePostProcessingShaderConst_000.PostProcessingShaderConst_320.z, 0.f);
          graded = exposed_scene;

          if (!_681 && g_prePostProcessingShaderConst_000.PostProcessingShaderConst_208.x != 0.f) {
            const float A = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.y;
            const float B = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.z;
            const float C = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.x;
            const float D = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_176.y;
            const float E = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_192.x;
            tm_peak = E;

            if (RENODX_TONE_MAP_TYPE == 1.f) {
              graded = tlou2::tonemap::ApplyExtended(exposed_scene, A, B, C, D, E, anchor);
            } else {
              graded = tlou2::tonemap::Apply(exposed_scene, A, B, C, D, E);
            }
          }
        }

        const float shaper_input_scale = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_688;
        float scale = 1.f;
        if (RENODX_TONE_MAP_TYPE == 1.f) {
          scale = ApplyAnchoredCInfinityShoulderLuminanceScale(graded, tm_peak, 0.5f);
        }
        graded *= scale;

        const float3 encoded = renodx::color::srgb::Encode(graded);
        float3 primary_lut_output = encoded;

        if (_681) {
          primary_lut_output = renodx::lut::SampleTetrahedral(t7, ApplyLUTShaper(encoded, shaper_input_scale));
        }

        const float secondary_lut_strength = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_684;
        float3 final_sdr = primary_lut_output;
        if (secondary_lut_strength > 0.f) {
          const float3 secondary_lut_output = renodx::lut::SampleTetrahedral(t8, primary_lut_output);
          final_sdr = lerp(primary_lut_output, secondary_lut_output, secondary_lut_strength);
        }

        final_sdr = renodx::color::srgb::DecodeSafe(final_sdr);
        final_sdr /= scale;
        final_sdr = renodx::color::srgb::EncodeSafe(final_sdr);

        _936 = final_sdr.x;
        _937 = final_sdr.y;
        _938 = final_sdr.z;
      }
      // Step 11: optional localized world-space glow/highlight. Reconstruct a position
      // from t3 depth and the Const_064 matrix, measure distance to Const_144/128,
      // then add the resulting scalar equally to RGB. Exact engine effect name is unknown.
      if (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.w > 0.0f) {
        _945 = t3.SampleLevel(s0, float2(_43, _44), 0.0f);
        _981 = (((((float)((uint)SV_DispatchThreadID.x)) + 0.5f) * 2.0f) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_536.x) + -1.0f;
        _984 = ((1.0f - (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_536.y * (((float)((uint)SV_DispatchThreadID.y)) + 0.5f))) * 2.0f) + -1.0f;
        _1000 = mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[2].w), _945.x, mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[1].w), _984, (_981 * (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[0].w)))) + (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[3].w);
        _1008 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.x - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_128.x) - ((mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[2].x), _945.x, mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[1].x), _984, (_981 * (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[0].x)))) + (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[3].x)) / _1000);
        _1010 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.y - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_128.y) - ((mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[2].y), _945.x, mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[1].y), _984, (_981 * (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[0].y)))) + (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[3].y)) / _1000);
        _1012 = (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.z - g_prePostProcessingShaderConst_000.PostProcessingShaderConst_128.z) - ((mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[2].z), _945.x, mad((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[1].z), _984, (_981 * (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[0].z)))) + (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_064[3].z)) / _1000);
        _1018 = sqrt(((_1010 * _1010) + (_1008 * _1008)) + (_1012 * _1012));
        _1019 = g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.w - _1018;
        _1021 = saturate(_1019 * 2.0f);
        _1048 = (saturate(exp2(log2(1.0f - (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.w / g_prePostProcessingShaderConst_000.PostProcessingShaderConst_804)) * 6.0f) * 2.0f) * saturate(max(0.0f, ((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.w * 2.0f) + -2.0f)) / g_prePostProcessingShaderConst_000.PostProcessingShaderConst_804)) * max((saturate(saturate(_1019 * 10.0f) - _1021) * 10.0f), (saturate(_1021 - saturate(((g_prePostProcessingShaderConst_000.PostProcessingShaderConst_144.w + -20.0f) - _1018) * 20.0f)) * 1.5f));
        _1053 = (_1048 + _936);
        _1054 = (_1048 + _937);
        _1055 = (_1048 + _938);
      } else {
        _1053 = _936;
        _1054 = _937;
        _1055 = _938;
      }
      // Step 12: optional luminance-derived dark-value suppression/contrast shaping.
      if (g_prePostProcessingShaderConst_000.PostProcessingShaderConst_644 > 0.0f) {
        _1059 = saturate(dot(float3(_1053, _1054, _1055), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f)));
        _1067 = 1.0f - (saturate(exp2(log2(_1059) * (1.0f / g_prePostProcessingShaderConst_000.PostProcessingShaderConst_644)) * g_prePostProcessingShaderConst_000.PostProcessingShaderConst_644) / _1059);
        _1075 = max(0.0f, (_1067 * _1053));
        _1076 = max(0.0f, (_1067 * _1054));
        _1077 = max(0.0f, (_1067 * _1055));
      } else {
        _1075 = _1053;
        _1076 = _1054;
        _1077 = _1055;
      }
      // Step 13: preserve the shader's extended positive range up to 100 and write alpha zero.
      if (RENODX_TONE_MAP_TYPE == 0.f) {
        _1075 = min(_1075, 100.f);
        _1076 = min(_1076, 100.f);
        _1077 = min(_1077, 100.f);
      }
      u0[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float4(_1075, _1076, _1077, 0.0f);
      break;
    }
    if (_loop_break_0) {
      _loop_break_0 = false;
      continue;
    }
    break;
  }
}
