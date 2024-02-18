#include "../common/random.hlsl"
#include "./cp2077.h"

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

cbuffer injectedBuffer : register(b14, space0) {
  ShaderInjectData injectedData : packoffset(c0);
}

Texture2D<float4> textureUntonemapped : register(t0, space0);
Texture2D<float4> textureBloom : register(t1, space0);
Texture3D<float4> textureLUT[3] : register(t4, space0);
Texture2D<uint4> textureMask : register(t51, space0);
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

float3 composite() {
  const float cb6_10z = cb6[10u].z;  // Bloom width
  const float cb6_10w = cb6[10u].w;  // Bloom height

  uint _58 = uint(int(gl_FragCoord.x));
  uint _59 = uint(int(gl_FragCoord.y));
  float _60 = float(int(_58));
  float _61 = float(int(_59));
  float _71 = (_60 + 0.5f) * cb6_10z;
  float _72 = (_61 + 0.5f) * cb6_10w;

  float _89 = (cb6[10u].x * ((_71 * 2.0f) + (-1.0f))) * cb6[14u].x;
  float _90 = (((_72 * 2.0f) + (-1.0f)) * cb6[10u].y) * cb6[14u].x;
  float3 inputColor = textureUntonemapped.Load(int3(uint2(_58, _59), 0u)).rgb;
  float3 bloomColor = textureBloom.Sample(sampler0, float2(_71, _72)).rgb;

  float3 bloomStrength = cb6[0u].rgb;
  float inputGain = cb6[0u].w;
  float postBloomGain = cb6[11u].w;
  float3 postBloomLift = cb6[11u].rgb;

  float3 outputColor = inputColor * inputGain;
  outputColor += (bloomColor * bloomStrength * injectedData.effectBloom);
  outputColor += postBloomLift;

  float vignetteStrength = cb6[9u].x;

  if (injectedData.effectVignette && vignetteStrength > 0.0f) {
    float3 vignetteColor = cb6[8u].rgb;
    float vignetteFactor = exp2((-0.0f) - (cb6[9u].y * log2(abs((dot(float2(_89, _90), float2(_89, _90)) * vignetteStrength) + 1.0f))));
    float3 mixedColor = lerp(vignetteColor, outputColor, vignetteFactor);
    outputColor = lerp(outputColor, mixedColor, injectedData.effectVignette);
  }

  float _168 = outputColor.r;
  float _169 = outputColor.g;
  float _170 = outputColor.b;

  float _401;
  float _402;
  float _403;
  uint _195;
  float _322;
  float _323;
  float _324;
  float _336;
  float _337;
  float _338;
  float _346;
  float _347;
  float _348;
  uint _355;
  bool _356;
  for (;;) {
    _195 = 1u << (textureMask.Load(int3(uint2(uint(cb12[79u].x * _60), uint(cb12[79u].y * _61)), 0u)).y & 31u);

    float3 random = hash33(float3(
      _60,
      _61,
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

    _322 = (((((_168 * SYS_TEXCOORD.x) * cb6[1u].y) * (((cb6[2u].x * _230) * _250) + 1.0f)) * (((cb6[3u].x * _230) * _271) + 1.0f)) * (((cb6[4u].x * _230) * _293) + 1.0f)) * (((cb6[5u].x * _230) * _315) + 1.0f);
    _323 = (((((_169 * SYS_TEXCOORD.x) * cb6[1u].y) * (((cb6[2u].y * _232) * _250) + 1.0f)) * (((cb6[3u].y * _232) * _271) + 1.0f)) * (((cb6[4u].y * _232) * _293) + 1.0f)) * (((cb6[5u].y * _232) * _315) + 1.0f);
    _324 = (((((_170 * SYS_TEXCOORD.x) * cb6[1u].y) * (((cb6[2u].z * _233) * _250) + 1.0f)) * (((cb6[3u].z * _233) * _271) + 1.0f)) * (((cb6[4u].z * _233) * _293) + 1.0f)) * (((cb6[5u].z * _233) * _315) + 1.0f);
    _336 = (cb6[6u].x * log2(_322)) + cb6[6u].y;
    _337 = (cb6[6u].x * log2(_323)) + cb6[6u].y;
    _338 = (cb6[6u].x * log2(_324)) + cb6[6u].y;

    float4 _344 = textureLUT[4u].SampleLevel(sampler0, float3(_336, _337, _338), 0.0f);
    _346 = _344.x;
    _347 = _344.y;
    _348 = _344.z;
    _355 = min((asuint(cb6[12u]).x & _195), 1u);
    _356 = _355 == 0u;
    uint _372;
    float _374;
    float _376;
    float _378;
    if (_356) {
      float4 _360 = textureLUT[5u].SampleLevel(sampler0, float3(_336, _337, _338), 0.0f);
      uint _370 = min((asuint(cb6[12u]).y & _195), 1u);
      uint frontier_phi_4_3_ladder;
      float frontier_phi_4_3_ladder_1;
      float frontier_phi_4_3_ladder_2;
      float frontier_phi_4_3_ladder_3;
      if (_370 == 0u) {
        float4 _393 = textureLUT[6u].SampleLevel(sampler0, float3(_336, _337, _338), 0.0f);
        uint _373 = min((asuint(cb6[12u]).z & _195), 1u);
        if (_373 == 0u) {
          _401 = _322;
          _402 = _323;
          _403 = _324;
          break;
        }
        frontier_phi_4_3_ladder = _373;
        frontier_phi_4_3_ladder_1 = _393.z;
        frontier_phi_4_3_ladder_2 = _393.y;
        frontier_phi_4_3_ladder_3 = _393.x;
      } else {
        frontier_phi_4_3_ladder = _370;
        frontier_phi_4_3_ladder_1 = _360.z;
        frontier_phi_4_3_ladder_2 = _360.y;
        frontier_phi_4_3_ladder_3 = _360.x;
      }
      _372 = frontier_phi_4_3_ladder;
      _374 = frontier_phi_4_3_ladder_1;
      _376 = frontier_phi_4_3_ladder_2;
      _378 = frontier_phi_4_3_ladder_3;
    } else {
      _372 = _355;
      _374 = _348;
      _376 = _347;
      _378 = _346;
    }
    float _380 = float(_372);
    _401 = ((_378 - _322) * _380) + _322;
    _402 = ((_376 - _323) * _380) + _323;
    _403 = ((_374 - _324) * _380) + _324;
    break;
  }
  float _404 = dot(float3(_401, _402, _403), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _416 = max(9.9999997473787516355514526367188e-05f, dot(float3(_322, _323, _324), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
  outputColor = float3(
    ((cb6[1u].w * (((_404 * _322) / _416) - _401)) + _401) * cb6[1u].z,
    ((cb6[1u].w * (((_404 * _323) / _416) - _402)) + _402) * cb6[1u].z,
    ((cb6[1u].w * (((_404 * _324) / _416) - _403)) + _403) * cb6[1u].z
  );
  return outputColor;
}
