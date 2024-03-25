#include "../common/color.hlsl"
#include "../common/lut.hlsl"
#include "../common/random.hlsl"
#include "../common/graph.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

static float _468;
static float _469;
static float _470;

cbuffer _22_24 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
}

cbuffer _32_34 : register(b6, space0) {
  float4 cb6[15] : packoffset(c0);
}

cbuffer _27_29 : register(b12, space0) {
  float4 cb12[99] : packoffset(c0);
}

Texture2D<float4> textureUntonemapped : register(t0, space0);
Texture2D<float4> textureBloom : register(t1, space0);
Texture3D<float4> textureLUT[3] : register(t4, space0);
Texture2D<uint4> textureMask : register(t51, space0);
Texture2DArray<float4> textureArray : register(t67, space0);
SamplerState sampler0 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  nointerpolation float2 SYS_TEXCOORD : SYS_TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};



float3 composite(bool useTexArray = false) {
  const float cb6_10z = cb6[10u].z;  // Bloom width
  const float cb6_10w = cb6[10u].w;  // Bloom height

  uint uFragx = uint(int(gl_FragCoord.x));
  uint uFragy = uint(int(gl_FragCoord.y));
  float fFragx = float(int(uFragx));
  float fFragy = float(int(uFragy));
  float bloomX = (fFragx + 0.5f) * cb6_10z;
  float bloomY = (fFragy + 0.5f) * cb6_10w;
  float bloomWidth = cb6[14u].x * cb6[10u].x * (2.0f * bloomX - 1.0f);
  float bloomHeight = cb6[14u].x * cb6[10u].y * (2.0f * bloomY - 1.0f);
  float bloomSize = dot(float2(bloomWidth, bloomHeight), float2(bloomWidth, bloomHeight));
  float3 bloomStrength = cb6[0u].rgb * injectedData.fxBloom;
  float inputGain = cb6[0u].w;
  float postBloomGain = cb6[11u].w;
  float3 postBloomLift = cb6[11u].rgb;
  float3 inputColor;
  float3 bloomColor;
  if (useTexArray) {
    float _107 = pow(max(bloomSize - cb6[7u].w, 0.0f), cb6[7u].z);
    float _112 = (_107 * bloomWidth) * cb6[7u].x;
    float _113 = (_107 * bloomHeight) * cb6[7u].y;
    float4 _124 = textureArray.Load(int4(uint3(uFragx & 63u, uFragy & 63u, asuint(cb0[28u]).y & 63u), 0u));
    float _127 = _124.x;
    float _131 = bloomY - (_127 * _113);
    float _138 = (bloomX - (_127 * _112)) - (cb6[8u].w * 2.5f);
    bloomColor = textureBloom.Sample(sampler0, float2(bloomX - (_112 * 2.5f), bloomY - (_113 * 2.5f))).rgb;
    float _161 = cb6[8u].w + (_138 - _112);
    float _176 = cb6[8u].w + (_161 - _112);
    float _190 = cb6[8u].w + (_176 - _112);
    float _bbb = cb6[8u].w + (_190 - _112);
    float _157 = _131 - _113;
    float _175 = _157 - _113;
    float _189 = _175 - _113;
    float _ccc = _189 - _113;
    float4 _162 = textureUntonemapped.Sample(sampler0, float2(_161, _157));
    float4 _177 = textureUntonemapped.Sample(sampler0, float2(_176, _175));
    float4 _191 = textureUntonemapped.Sample(sampler0, float2(_190, _189));
    float4 _aaa = textureUntonemapped.Sample(sampler0, float2(_bbb, _ccc));
    float4 _ddd = textureUntonemapped.Sample(sampler0, float2(_138, _131));

    // likely a matrix
    inputColor.r = 0.625f * ((_177.x * 0.3f) + (_162.x * 0.1f) + (_191.x * 0.4f) + (_aaa.x * 0.8f));
    inputColor.g = 0.90909087657928466796875f * ((_177.y * 0.5f) + (_162.y * 0.4f) + (_191.y * 0.2f));
    inputColor.b = 0.76923072338104248046875f * ((_162.z * 0.3f) + (_ddd.z * 0.9f) + (_177.z * 0.1f));
  } else {
    inputColor = textureUntonemapped.Load(int3(uint2(uFragx, uFragy), 0u)).rgb;
    bloomColor = textureBloom.Sample(sampler0, float2(bloomX, bloomY)).rgb;
  }

  float3 outputColor = inputColor * inputGain;
  outputColor += (bloomColor * bloomStrength);
  outputColor *= postBloomGain;
  outputColor += postBloomLift;

  float vignetteStrength = cb6[9u].x;

  if (vignetteStrength) {
    float3 vignetteColor = cb6[8u].rgb;
    float vignetteFactor = exp2((-0.0f) - (cb6[9u].y * log2(abs((bloomSize * vignetteStrength) + 1.0f))));
    float3 mixedColor = lerp(vignetteColor, outputColor, vignetteFactor);
    outputColor = lerp(outputColor, mixedColor, injectedData.fxVignette);
  }

#if DRAW_TONEMAPPER
  DrawToneMapperParams dtmParams = DrawToneMapperStart(gl_FragCoord.xy, outputColor, injectedData.peakNits);
  outputColor = dtmParams.outputColor;
#endif

  float3 fxColor = outputColor;
  float _168 = outputColor.r;
  float _169 = outputColor.g;
  float _170 = outputColor.b;

  float _322;
  float _323;
  float _324;
  float _336;
  float _337;
  float _338;
  float _346;
  float _347;
  float _348;

  uint4 textureMaskColor = textureMask.Load(int3(uint2(uint(cb12[79u].x * fFragx), uint(cb12[79u].y * fFragy)), 0u));
  uint _195 = 1u << (textureMaskColor.y & 31u);

  // Pick LUT based on mask?
  uint useLUT1 = min((asuint(cb6[12u]).x & _195), 1u);
  uint useLUT2 = min((asuint(cb6[12u]).y & _195), 1u);
  uint useLUT3 = min((asuint(cb6[12u]).z & _195), 1u);

  float3 firstLUTColor;
  float3 secondLUTColor;
  float3 thirdLUTColor;

  float3 random = hash33(float3(
    fFragx,
    fFragy,
    float(asuint(cb0[28u]).y)
  ));

  random -= 0.5f;
  float _230 = random.x;
  float _232 = random.y;
  float _233 = random.z;

  uint4 _246 = asuint(cb6[13u]);
  float _250 = float(min((_246.x & _195), 1u));
  float _271 = float(min((_246.y & _195), 1u));
  float _293 = float(min((_246.z & _195), 1u));
  float _315 = float(min((_246.w & _195), 1u));

  float3 fallbackColor = fxColor;
  fallbackColor *= SYS_TEXCOORD.x;
  fallbackColor *= cb6[1u].y;
  fallbackColor *= ((cb6[2u].rgb * random * _250) + 1.f);
  fallbackColor *= ((cb6[3u].rgb * random * _271) + 1.f);
  fallbackColor *= ((cb6[4u].rgb * random * _293) + 1.f);
  fallbackColor *= ((cb6[5u].rgb * random * _315) + 1.f);

  float3 lutColor = 1.f;
  bool useLUT = false;
  uint lutStrength = 0u;
  uint lutIndex = 0u;
  if (useLUT1) {
    useLUT = true;
    lutIndex = 0u;
    lutStrength = useLUT1;
  } else if (useLUT2) {
    useLUT = true;
    lutIndex = 1u;
    lutStrength = useLUT2;
  } else if (useLUT3) {
    useLUT = true;
    lutIndex = 2u;
    lutStrength = useLUT3;
  }
  if (useLUT) {
    if (injectedData.processingInternalSampling == 1.f) {
      float3 rec2020 = bt2020FromBT709(fallbackColor);
      float3 pqColor = pqFromLinear((rec2020 * 100.f) / 10000.f);  // reset scale to 0-1 for 0-10000 nits

      lutColor = sampleLUT(textureLUT[lutIndex], sampler0, pqColor).rgb;
    } else {
      // cb6[6u].x 0.05888671
      // cb6[6u].y 0.59765625
      float3 lutInputColor = (cb6[6u].x * log2(fallbackColor)) + cb6[6u].y;
      lutColor = textureLUT[lutIndex].SampleLevel(sampler0, lutInputColor, 0.0f).rgb;
    }
    outputColor = lerp(outputColor, lutColor, float(lutStrength));
  } else {
    outputColor = fallbackColor;
  }

  if (cb6[1u].w) {
    float3 luttedColor = outputColor;
    float outputColorY = yFromBT709(outputColor);
    float fallbackColorY = yFromBT709(fallbackColor);
    float3 rescaledFallbackColor = fallbackColor * (fallbackColorY ? (outputColorY / fallbackColorY) : 0);
    outputColor = lerp(outputColor, rescaledFallbackColor, cb6[1u].w);
  }
  outputColor *= cb6[1u].z;

#if DRAW_TONEMAPPER
  if (dtmParams.drawToneMapper) outputColor = DrawToneMapperEnd(outputColor, dtmParams);
#endif

  return outputColor;
}
