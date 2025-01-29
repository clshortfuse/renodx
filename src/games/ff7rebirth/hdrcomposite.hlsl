#include "./common.hlsl"
#include "./include/CBuffer_Globals.hlsl"
#include "./include/CBuffer_View.hlsl"
#include "./include/Registers.hlsl"

// Texture3D<float4> View_SpatiotemporalBlueNoiseVolumeTexture : register(t0);  // Noise
// Texture2D<float4> ColorTexture : register(t1);                               // Scene
// Texture2D<float4> GlareTexture : register(t2);                               // Glare
// Texture2D<float4> CompositeSDRTexture : register(t3);                        // UI
// Texture3D<float4> BT709PQToBT2020PQLUT : register(t4);                       // LUT

// #ifdef USE_DISPLAY_MAP
// Texture3D<float4> BT2020PQ1000ToBT2020PQ250LUT : register(t5);  // display mapping
// #endif

SamplerState View_SharedBilinearClampedSampler : register(s0);

float getMidGray() {
  float3 lutInputColor = saturate(renodx::color::pq::Encode(0.18f, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT,
                                         View_SharedBilinearClampedSampler,
                                         lutInputColor,
                                         32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult, 250);

  return renodx::color::y::from::BT2020(lutOutputColor_bt2020);
}

float4 HDRComposite(noperspective float2 TEXCOORD: TEXCOORD,
                    noperspective float4 TEXCOORD_1: TEXCOORD1,
                    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  bool _18 = !((Globals_054z) == 0.0f);
  float _34 = (SV_Position.x) - (float((uint)(Globals_043x)));
  float _35 = (SV_Position.y) - (float((uint)(Globals_043y)));
  float _41 = saturate((_34 * (Globals_044z)));
  float _42 = saturate((_35 * (Globals_044w)));
  float _55 = (_18 ? (saturate(((Globals_044z) * (((floor((_34 * 0.5f))) * 2.0f) + 1.0f)))) : _41);
  float _56 = (_18 ? (saturate(((((floor((_35 * 0.5f))) * 2.0f) + 1.0f) * (Globals_044w)))) : _42);

  // // main color
  float4 _125 = ColorTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((min((max(((((Globals_030x)*_55) + (float((uint)(Globals_029x)))) * (Globals_027z)), (Globals_033x))), (Globals_033z))), (min((max(((((Globals_030y)*_56) + (float((uint)(Globals_029y)))) * (Globals_027w)), (Globals_033y))), (Globals_033w)))), 0.0f);

  float _137 = (1.0f / (max(0.0010000000474974513f, (Globals_048y)))) * (TEXCOORD_1.z);
  float _142 = (_137 * _137) * (1.0f / (max(9.999999747378752e-06f, (dot(float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137), float3((TEXCOORD_1.x), (TEXCOORD_1.y), _137))))));
  float _146 = (((_142 * _142) + -1.0f) * (Globals_048x)) + 1.0f;
  float _147 = _146 * (min((_125.x), 65504.0f));
  float _148 = _146 * (min((_125.y), 65504.0f));
  float _149 = _146 * (min((_125.z), 65504.0f));

  float3 main_color = float3(_147, _148, _149);

  // Glare
  float2 glareUV = float2(
      clamp(((Globals_037x * _55) + (float)((uint)Globals_036x)) * Globals_034z,
            Globals_040x,
            Globals_040z),
      clamp(((Globals_037y * _56) + (float)((uint)Globals_036y)) * Globals_034w,
            Globals_040y,
            Globals_040w));
  float4 glareSample = GlareTexture.SampleLevel(View_SharedBilinearClampedSampler, glareUV, 0.0f);
#if defined(SHADER_HASH_0xA53093E1)
  int _22 = int(22);
  int _23 = int(23);
  float _179 = saturate(((Globals_030x) * 0.0002604166802484542f));
  float _180 = float(_22);
  float _182 = _180 * 0.6180340051651001f;
  float _183 = (float(_23)) * 0.6180340051651001f;
  float _191 = max(1.0000000116860974e-07f, (frac(((tan((sqrt(((_183 * _183) + (_182 * _182)))))) * _180))));
  float _194 = floor(((frac((Globals_050w))) * 59.940059661865234f));
  float _195 = _191 + 0.3333333432674408f;
  float _196 = _191 + 0.6666666865348816f;
  float _197 = _194 * 63.13124465942383f;
  float _207 = ((frac((_197 + _191))) * 2.0f) + -1.0f;
  float _208 = ((frac((_195 + _197))) * 2.0f) + -1.0f;
  float _209 = ((frac((_196 + _197))) * 2.0f) + -1.0f;
  float _211 = (_194 + 1.0f) * 63.13124465942383f;
  float _221 = ((frac((_211 + _191))) * 2.0f) + -1.0f;
  float _222 = ((frac((_195 + _211))) * 2.0f) + -1.0f;
  float _223 = ((frac((_196 + _211))) * 2.0f) + -1.0f;
  float _233 = (((bool)(((abs(_207)) > (abs(_221))))) ? _207 : _221);
  float _234 = (((bool)(((abs(_208)) > (abs(_222))))) ? _208 : _222);
  float _235 = (((bool)(((abs(_209)) > (abs(_223))))) ? _209 : _223);
  float _236 = _179 * _179;
  float _281 = (((View_164z) + -1.0f) * (Globals_050z)) + 1.0f;
  float _285 = ((((float(((int(((bool)((_233 > 0.0f))))) - (int(((bool)((_233 < 0.0f)))))))) * (Globals_050x)) * (1.0f - (exp2(((log2((max(0.0f, (1.0f - (abs(_233))))))) * _236))))) * (View_164y)) * _281;
  float _289 = ((((float(((int(((bool)((_234 > 0.0f))))) - (int(((bool)((_234 < 0.0f)))))))) * (Globals_050x)) * (1.0f - (exp2(((log2((max(0.0f, (1.0f - (abs(_234))))))) * _236))))) * (View_164y)) * _281;
  float _293 = ((((float(((int(((bool)((_235 > 0.0f))))) - (int(((bool)((_235 < 0.0f)))))))) * (Globals_050x)) * (1.0f - (exp2(((log2((max(0.0f, (1.0f - (abs(_235))))))) * _236))))) * (View_164y)) * _281;
  float _294 = dot(float3(_285, _289, _293), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));

  float _317 = exp2(((log2((saturate(((max(0.0f, (((((Globals_049x) * (((min((_151.x), 65504.0f))-_147) + (_147 * (_151.w)))) + _147) + _285) + ((_294 - _285) * (Globals_050y))))) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _333 = exp2(((log2((saturate(((max(0.0f, (((((Globals_049x) * (((min((_151.y), 65504.0f))-_148) + (_148 * (_151.w)))) + _148) + _289) + ((_294 - _289) * (Globals_050y))))) * 0.009999999776482582f))))) * 0.1593017578125f));
  float _349 = exp2(((log2((saturate(((max(0.0f, (((((Globals_049x) * (((_149 * (_151.w)) - _149) + (min((_151.z), 65504.0f)))) + _149) + _293) + ((_294 - _293) * (Globals_050y))))) * 0.009999999776482582f))))) * 0.1593017578125f));

#endif




  float3 glareColor = min(glareSample.xyz, 65504.0f);
  float3 ungraded_bt709 = (Globals_049x * ((glareColor - main_color) + main_color * glareSample.w) + main_color);

  // LUT
  float3 lutInputColor = saturate(renodx::color::pq::EncodeSafe(ungraded_bt709, 100.f));
  float3 lutResult = renodx::lut::Sample(BT709PQToBT2020PQLUT, View_SharedBilinearClampedSampler, lutInputColor, 32u);
  float3 lutOutputColor_bt2020 = renodx::color::pq::DecodeSafe(lutResult);
  float3 tonemapped = lutOutputColor_bt2020;

#if 1
  tonemapped = extractColorGradeAndApplyTonemap(ungraded_bt709, lutOutputColor_bt2020, getMidGray());
#endif

  float _247 = tonemapped.r, _261 = tonemapped.g, _275 = tonemapped.b;

  // UI + sRGB -> 2.2  gamma correction
#if defined(SHADER_HASH_0xD31CF869) || defined(SHADER_HASH_0x288CF983)
  // when in the menu the UI includes a foreground and background texture
  float _123 = ((min((((Globals_044x) * 0.5625f) * (Globals_044w)), 1.0f)) * (_41 + -0.5f)) + 0.5f;
  float _124 = ((min((((Globals_044y) * 1.7777777910232544f) * (Globals_044z)), 1.0f)) * (_42 + -0.5f)) + 0.5f;
  float4 _280 = CompositeSDRBackgroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float4 _286 = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float4 _299 = CompositeSDRForegroundTexture.SampleLevel(View_SharedBilinearClampedSampler, float2(_123, _124), 0.0f);
  float _307 = ((_299.w) * (((_286.w) * (_280.x)) + (_286.x))) + (_299.x);
  float _308 = ((_299.w) * (((_286.w) * (_280.y)) + (_286.y))) + (_299.y);
  float _309 = ((_299.w) * (((_286.w) * (_280.z)) + (_286.z))) + (_299.z);
  float _310 = ((_286.w) * (_280.w)) * (_299.w);
  float4 UI_Texture = float4(_307, _308, _309, _310);
#else
  float4 UI_Texture = CompositeSDRTexture.SampleLevel(View_SharedBilinearClampedSampler, float2((((min((((Globals_044x) * 0.5625f) * (Globals_044w)), 1.0f)) * (_41 + -0.5f)) + 0.5f), (((min((((Globals_044y) * 1.7777777910232544f) * (Globals_044z)), 1.0f)) * (_42 + -0.5f)) + 0.5f)), 0.0f);
#endif
  float3 gammaCorrectedUI = renodx::color::correct::Gamma(max(0, UI_Texture.xyz));
  float _347 = gammaCorrectedUI.r;
  float _348 = gammaCorrectedUI.g;
  float _349 = gammaCorrectedUI.b;

  // UI Blending
  float _316 = (UI_Texture.w) * (UI_Texture.w);
  float _323 = 1.0f / ((_247 * 40.0f) + 1.0f);
  float _324 = 1.0f / ((_261 * 40.0f) + 1.0f);
  float _325 = 1.0f / ((_275 * 40.0f) + 1.0f);

  float _363 = exp2(((log2((saturate(((((dot(float3(0.6274039149284363f, 0.3292829990386963f, 0.043313100934028625f), float3(_347, _348, _349)))*RENODX_GRAPHICS_WHITE_NITS) + (((_247 * 10000.0f) * (UI_Texture.w)) * (((1.0f - _323) * _316) + _323))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _374 = saturate((exp2(((log2((max(0.0f, (((_363 * 18.8515625f) + 0.8359375f) * (1.0f / ((_363 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _379 = exp2(((log2((saturate(((((dot(float3(0.06909730285406113f, 0.9195405840873718f, 0.011362300254404545f), float3(_347, _348, _349)))*RENODX_GRAPHICS_WHITE_NITS) + (((_261 * 10000.0f) * (UI_Texture.w)) * (((1.0f - _324) * _316) + _324))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _390 = saturate((exp2(((log2((max(0.0f, (((_379 * 18.8515625f) + 0.8359375f) * (1.0f / ((_379 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _395 = exp2(((log2((saturate(((((dot(float3(0.01639140024781227f, 0.08801329880952835f, 0.8955953121185303f), float3(_347, _348, _349)))*RENODX_GRAPHICS_WHITE_NITS) + (((_275 * 10000.0f) * (UI_Texture.w)) * (((1.0f - _325) * _316) + _325))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _406 = saturate((exp2(((log2((max(0.0f, (((_395 * 18.8515625f) + 0.8359375f) * (1.0f / ((_395 * 18.6875f) + 1.0f))))))) * 78.84375f))));
  float _408 = ((((float4)(View_SpatiotemporalBlueNoiseVolumeTexture.Load(int4(((int(22)) & 127), ((int(23)) & 127), (((uint)(View_175x)) & 63), 0)))).x) * 2.0f) + -1.0f;
  float _425 = ((1.0f - (sqrt((1.0f - (abs(_408)))))) * (float(((int(((bool)((_408 > 0.0f))))) - (int(((bool)((_408 < 0.0f))))))))) * 0.0009775171056389809f;
  SV_Target.x = (saturate(((((bool)((((abs(((_374 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + _374) : _374))));
  SV_Target.y = (saturate(((((bool)((((abs(((_390 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + _390) : _390))));
  SV_Target.z = (saturate(((((bool)((((abs(((_406 * 2.0f) + -1.0f))) + -0.9980449676513672f) < 0.0f))) ? (_425 + _406) : _406))));
  SV_Target.w = 0.0f;

  return SV_Target;
}
