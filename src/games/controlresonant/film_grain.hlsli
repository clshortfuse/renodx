#ifndef SRC_GAMES_CONTROLRESONANT_FILM_GRAIN_HLSLI_
#define SRC_GAMES_CONTROLRESONANT_FILM_GRAIN_HLSLI_

#include "./shared.h"

float3 ApplyCustomFilmGrain(float3 color, Texture2D<float4> g_tFilmGrain, float4 SV_Position,
                            int2 g_vFilmGrainOffset, float intensity, float paper_white) {
  float random = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0)).x;
  return renodx::effects::ApplyFilmGrain(color, SV_Position.xy, random, intensity * 0.045f * CUSTOM_GRAIN_STRENGTH, paper_white);
}

float3 ApplyFilmGrainDirect(float3 color, Texture2D<float4> g_tFilmGrain, float4 SV_Position,
                            int2 g_vFilmGrainOffset, float intensity, float paper_white) {
  float3 grained_color;
  if (CUSTOM_GRAIN_TYPE != 0.f) {
    grained_color = ApplyCustomFilmGrain(color, g_tFilmGrain, SV_Position, g_vFilmGrainOffset, intensity, paper_white);
  } else {
    float4 _1299 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    float _1285 = color.x;
    float _1286 = color.y;
    float _1287 = color.z;
    float _277 = paper_white;
    float _1309 = _1285 / _277;
    float _1310 = _1286 / _277;
    float _1311 = _1287 / _277;
    float _1315 = 1.0f - sqrt(max(dot(float3(_1309, _1310, _1311), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)), 0.0f));
    float _1321 = intensity * (_277 * 5.0f);
    float _1335 = ((((_1321 * ((_1299.x * 2.0f) + -1.0f)) * saturate(_1309)) * _1315) + _1285);
    float _1336 = ((((_1321 * ((_1299.y * 2.0f) + -1.0f)) * _1315) * saturate(_1310)) + _1286);
    float _1337 = ((((_1321 * ((_1299.z * 2.0f) + -1.0f)) * _1315) * saturate(_1311)) + _1287);
    grained_color = float3(_1335, _1336, _1337);
  }

  return grained_color;
}

float3 ApplyFilmGrainReinhardDelta(float3 color, Texture2D<float4> g_tFilmGrain, float4 SV_Position,
                                   int2 g_vFilmGrainOffset, float intensity, float paper_white) {
  float3 grained_color;
  if (CUSTOM_GRAIN_TYPE != 0.f) {
    grained_color = ApplyCustomFilmGrain(color, g_tFilmGrain, SV_Position, g_vFilmGrainOffset, intensity, paper_white);
  } else {
    float4 _950 = g_tFilmGrain.Load(int3((((int)((uint)(g_vFilmGrainOffset.x) + (uint)(int(SV_Position.x)))) % 512), (((int)((uint)(g_vFilmGrainOffset.y) + (uint)(int(SV_Position.y)))) % 512), 0));
    float _936 = color.x;
    float _937 = color.y;
    float _938 = color.z;
    float _957 = (_950.x * 2.0f) + -1.0f;
    float _958 = (_950.y * 2.0f) + -1.0f;
    float _959 = (_950.z * 2.0f) + -1.0f;
    float _987 = saturate(_936);
    float _988 = saturate(_937);
    float _989 = saturate(_938);
    float _994 = 1.0f / max(1.1754943508222875e-38f, (1.0f - max(_987, max(_988, _989))));
    float _995 = _994 * _987;
    float _996 = _994 * _988;
    float _997 = _994 * _989;
    float _1005 = ((1.0f - sqrt(dot(float3(_995, _996, _997), float3(0.2126729041337967f, 0.7151520848274231f, 0.07217500358819962f)))) * 5.0f) * intensity;
    float _1012 = ((_1005 * _957) * min(1.0f, _995)) + _995;
    float _1013 = ((_1005 * _958) * min(1.0f, _996)) + _996;
    float _1014 = ((_1005 * _959) * min(1.0f, _997)) + _997;
    float _1018 = 1.0f / (max(_1012, max(_1013, _1014)) + 1.0f);
    float _1025 = 1.0f / (max(_995, max(_996, _997)) + 1.0f);
    float _1036 = (((_1012 * _1018) + _936) - (_1025 * _995));
    float _1037 = (((_1013 * _1018) + _937) - (_1025 * _996));
    float _1038 = (((_1014 * _1018) + _938) - (_1025 * _997));
    grained_color = float3(_1036, _1037, _1038);
  }
  return grained_color;
}

#endif  // SRC_GAMES_CONTROLRESONANT_FILM_GRAIN_HLSLI_