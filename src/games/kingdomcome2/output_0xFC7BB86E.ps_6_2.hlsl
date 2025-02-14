#include "./hdrcomposite.hlsl"

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  return HDRComposite(TEXCOORD, TEXCOORD_1, SV_Position);
}

/* 
#include "./common.hlsl"

Texture2D<float4> luminanceTex : register(t1);

Texture2D<float4> sunShaftsTex : register(t5);

Texture2D<float4> vignettingTex : register(t3);

Texture2D<float4> colorChartTex : register(t4);

Texture2D<float3> hdrTex : register(t0);
cbuffer PER_BATCH : register(b0, space3) {
  float PER_BATCH_000x : packoffset(c000.x);
  float PER_BATCH_000y : packoffset(c000.y);
  float PER_BATCH_000z : packoffset(c000.z);
  float PER_BATCH_000w : packoffset(c000.w);
  float PER_BATCH_001x : packoffset(c001.x);
  float PER_BATCH_001y : packoffset(c001.y);
  float PER_BATCH_001z : packoffset(c001.z);
  float PER_BATCH_002x : packoffset(c002.x);
  float PER_BATCH_002y : packoffset(c002.y);
  float PER_BATCH_002z : packoffset(c002.z);
  float PER_BATCH_003x : packoffset(c003.x);
  float PER_BATCH_003y : packoffset(c003.y);
  float PER_BATCH_003z : packoffset(c003.z);
  float PER_BATCH_004x : packoffset(c004.x);
  float PER_BATCH_004y : packoffset(c004.y);
  float PER_BATCH_004z : packoffset(c004.z);
  float PER_BATCH_004w : packoffset(c004.w);
  float PER_BATCH_005x : packoffset(c005.x);
  float PER_BATCH_005y : packoffset(c005.y);
  float PER_BATCH_005z : packoffset(c005.z);
};

SamplerState linearClampSS : register(s6);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float3 untonemapped;
  float4 SV_Target;
  float3 _18 = hdrTex.Load(int3((int(SV_Position.x)), (int(SV_Position.y)), 0));

  KingdomOptions options;
  options.gamma = float3(PER_BATCH_002x, PER_BATCH_002y, PER_BATCH_002z);
  options.bloom = float3(PER_BATCH_005x, PER_BATCH_005y, PER_BATCH_005z);

  ModifyOptions(options);

  float _42 = (8333.3330078125f / (exp2((min((max(((log2(((((float4)(luminanceTex.Load(int3(0, 0, 0)))).y) * 3030.30322265625f))) - (((PER_BATCH_003z) * 0.5f) * ((min((max(((log2((((((float4)(luminanceTex.Load(int3(0, 0, 0)))).y) * 10000.0f) + 1.0f))) * 0.3010300099849701f), 0.10000000149011612f)), 5.199999809265137f)) + -3.0f))), (PER_BATCH_003x))), (PER_BATCH_003y)))))) * (((float4)(vignettingTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y))))).x * options.vignette);
  float _56 = ((_18.x) - ((saturate((PER_BATCH_005x))) * (_18.x))) * _42;
  float _57 = ((_18.y) - ((saturate((PER_BATCH_005y))) * (_18.y))) * _42;
  float _58 = ((_18.z) - ((saturate((PER_BATCH_005z))) * (_18.z))) * _42;
  float _59 = dot(float3(_56, _57, _58), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _77 = max(((((PER_BATCH_000w) * (_56 - _59)) + _59) * (PER_BATCH_000x)), 0.0f);
  float _78 = max(((((PER_BATCH_000w) * (_57 - _59)) + _59) * (PER_BATCH_000y)), 0.0f);
  float _79 = max(((((_58 - _59) * (PER_BATCH_000w)) + _59) * (PER_BATCH_000z)), 0.0f);

  untonemapped = float3(_77, _78, _79);

  float _83 = (PER_BATCH_004x) * 0.2199999988079071f;
  float _85 = (PER_BATCH_004y) * 0.30000001192092896f;
  float _87 = _83 * _77;
  float _88 = _83 * _78;
  float _89 = _83 * _79;
  float _90 = _83 * (PER_BATCH_004w);


  float _91 = (PER_BATCH_004y) * 0.030000001192092896f;
  float _100 = (PER_BATCH_004z) * 0.0020000000949949026f;
  float _121 = (PER_BATCH_004z) * 0.03333333134651184f;
  float _125 = ((((_90 + _91) * (PER_BATCH_004w)) + _100) / (((_90 + _85) * (PER_BATCH_004w)) + 0.06000000238418579f)) - _121;
  float _135 = saturate((saturate((saturate(((((((_87 + _91) * _77) + _100) / (((_87 + _85) * _77) + 0.06000000238418579f)) - _121) / _125))))));
  float _136 = saturate((saturate((saturate(((((((_88 + _91) * _78) + _100) / (((_88 + _85) * _78) + 0.06000000238418579f)) - _121) / _125))))));
  float _137 = saturate((saturate((saturate(((((((_89 + _91) * _79) + _100) / (((_89 + _85) * _79) + 0.06000000238418579f)) - _121) / _125))))));
  float _159 = (((bool)((_135 < 0.0031308000907301903f))) ? (_135 * 12.920000076293945f) : (((exp2(((log2(_135)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float _160 = (((bool)((_136 < 0.0031308000907301903f))) ? (_136 * 12.920000076293945f) : (((exp2(((log2(_136)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float _161 = (((bool)((_137 < 0.0031308000907301903f))) ? (_137 * 12.920000076293945f) : (((exp2(((log2(_137)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f));
  float4 _162 = sunShaftsTex.Sample(linearClampSS, float2((TEXCOORD_1.x), (TEXCOORD_1.y)));
  float _187 = ((saturate(((((_162.y) * (1.0f - _160)) * (PER_BATCH_001y)) + _160))) * 0.9375f) + 0.03125f;
  float _188 = (saturate(((((_162.z) * (1.0f - _161)) * (PER_BATCH_001z)) + _161))) * 15.0f;
  float _189 = frac(_188);
  float _193 = (((((saturate(((((_162.x) * (1.0f - _159)) * (PER_BATCH_001x)) + _159))) * 0.9375f) + 0.03125f) - _189) + _188) * 0.0625f;
  float4 _194 = colorChartTex.Sample(linearClampSS, float2(_193, _187));
  float4 _199 = colorChartTex.Sample(linearClampSS, float2((_193 + 0.0625f), _187));
  float _213 = sin((dot(float2((SV_Position.x), (SV_Position.y)), float2(34.483001708984375f, 89.63700103759766f))));
  float _223 = sin((dot(float2(((SV_Position.x) + 0.5788999795913696f), ((SV_Position.y) + 0.5788999795913696f)), float2(34.483001708984375f, 89.63700103759766f))));
  SV_Target.x = (saturate((((exp2(((log2((((((_199.x) - (_194.x)) * _189) + (_194.x)) + ((((frac((_213 * 29156.4765625f))) + -0.5f) + (frac((_223 * 29156.4765625f)))) * 0.0019607844296842813f)))) * (options.gamma.x)))) * (options.gamma.y)) + (options.gamma.z))));
  SV_Target.y = (saturate((((exp2(((log2((((((_199.y) - (_194.y)) * _189) + (_194.y)) + ((((frac((_213 * 38273.5625f))) + -0.5f) + (frac((_223 * 38273.5625f)))) * 0.0019607844296842813f)))) * (options.gamma.x)))) * (options.gamma.y)) + (options.gamma.z))));
  SV_Target.z = (saturate((((exp2(((log2((((((_199.z) - (_194.z)) * _189) + (_194.z)) + ((((frac((_213 * 47843.75390625f))) + -0.5f) + (frac((_223 * 47843.75390625f)))) * 0.0019607844296842813f)))) * (options.gamma.x)))) * (options.gamma.y)) + (options.gamma.z))));

  SV_Target.rgb = Tonemap(SV_Target.rgb, untonemapped);
  SV_Target.w = 1.0f;
  return SV_Target;
}
 */