#include "./common.hlsl"

Texture2D<float4> PAAComp_CurTarg : register(t0);
Texture3D<float4> PostAA_Grain : register(t2);
SamplerState PostAA_GrainSS : register(s7);

cbuffer PER_BATCHUBO : register(b0, space1)
{
  float4 PER_BATCH_m0[4] : packoffset(c0);
};

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  uint _41 = uint(int(SV_Position.x));
  uint _42 = uint(int(SV_Position.y));
  float4 _43 = PAAComp_CurTarg.Load(int3(uint2(_41, _42), 0u));
  float _46 = _43.x;
  float _47 = _43.y;
  float _48 = _43.z;
  float4 _52 = PAAComp_CurTarg.Load(int3(uint2(_41, _42), 0u), int2(-1, -1));
  float _56 = _52.x;
  float _57 = _52.y;
  float _58 = _52.z;
  float4 _60 = PAAComp_CurTarg.Load(int3(uint2(_41, _42), 0u), int2(1, -1));
  float _63 = _60.x;
  float _64 = _60.y;
  float _65 = _60.z;
  float4 _66 = PAAComp_CurTarg.Load(int3(uint2(_41, _42), 0u), int2(-1, 1));
  float _69 = _66.x;
  float _70 = _66.y;
  float _71 = _66.z;
  float4 _72 = PAAComp_CurTarg.Load(int3(uint2(_41, _42), 0u), int2(1, 1));
  float _75 = _72.x;
  float _76 = _72.y;
  float _77 = _72.z;
  float _99 = ((((_63 * _63) + (_56 * _56)) + (_69 * _69)) + (_75 * _75)) * 0.25f;
  float _101 = ((((_64 * _64) + (_57 * _57)) + (_70 * _70)) + (_76 * _76)) * 0.25f;
  float _102 = ((((_65 * _65) + (_58 * _58)) + (_71 * _71)) + (_77 * _77)) * 0.25f;
  /* float _125 = renodx::math::SqrtSafe(clamp((((_46 * _46) - _99) * PER_BATCH_m0[0u].x) + _99, 0.0f, 1.0f));
  float _126 = renodx::math::SqrtSafe(clamp((((_47 * _47) - _101) * PER_BATCH_m0[0u].x) + _101, 0.0f, 1.0f));
  float _127 = renodx::math::SqrtSafe(clamp((((_48 * _48) - _102) * PER_BATCH_m0[0u].x) + _102, 0.0f, 1.0f)); */
  float _125 = renodx::math::SqrtSafe(((((_46 * _46) - _99) * PER_BATCH_m0[0u].x) + _99));
  float _126 = renodx::math::SqrtSafe(((((_47 * _47) - _101) * PER_BATCH_m0[0u].x) + _101));
  float _127 = renodx::math::SqrtSafe(((((_48 * _48) - _102) * PER_BATCH_m0[0u].x) + _102));
  float _155 = PER_BATCH_m0[1u].w * (PostAA_Grain.Sample(PostAA_GrainSS, float3((TEXCOORD.x * 4.0f) * (PER_BATCH_m0[2u].x / PER_BATCH_m0[2u].y), TEXCOORD.y * 4.0f, PER_BATCH_m0[3u].x * 3.0f)).x + (-0.5f));
  float _156 = _155 + 0.5f;
  float _172 = 0.5f - _155;
  float _180 = (_125 * 2.0f) * _156;
  float _182 = (_126 * 2.0f) * _156;
  float _184 = (_127 * 2.0f) * _156;
  /* SV_Target.x = clamp((((1.0f - (((1.0f - _125) * 2.0f) * _172)) - _180) * ((_125 < 0.5f) ? 0.0f : 1.0f)) + _180, 0.0f, 1.0f);
  SV_Target.y = clamp((((1.0f - (((1.0f - _126) * 2.0f) * _172)) - _182) * ((_126 < 0.5f) ? 0.0f : 1.0f)) + _182, 0.0f, 1.0f);
  SV_Target.z = clamp((((1.0f - (((1.0f - _127) * 2.0f) * _172)) - _184) * ((_127 < 0.5f) ? 0.0f : 1.0f)) + _184, 0.0f, 1.0f); */
  SV_Target.x = (((1.0f - (((1.0f - _125) * 2.0f) * _172)) - _180) * ((_125 < 0.5f) ? 0.0f : 1.0f)) + _180;
  SV_Target.y = (((1.0f - (((1.0f - _126) * 2.0f) * _172)) - _182) * ((_126 < 0.5f) ? 0.0f : 1.0f)) + _182;
  SV_Target.z = (((1.0f - (((1.0f - _127) * 2.0f) * _172)) - _184) * ((_127 < 0.5f) ? 0.0f : 1.0f)) + _184;
  SV_Target.w = saturate(_43.w);

  return SV_Target;
}