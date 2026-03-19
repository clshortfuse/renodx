float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float3 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _8 = (TEXCOORD.x * 2.0f) + -1.0f;
  float _9 = (TEXCOORD.y * 2.0f) + -1.0f;
  float _19 = frac(saturate(abs(_8)) * 5.0f);
  float _23 = (_19 + -0.75f) * 4.0f;
  float _24 = (_19 + -0.5f) * 4.0f;
  float _25 = (_19 + -0.25f) * 4.0f;
  float _35 = dot(float3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _48 = (1.0f - saturate(sqrt((_9 * _9) + (_8 * _8)))) * 0.25f;
  SV_Target.x = (((((_35 * max((1.0f - (_23 * _23)), 0.0f)) - TEXCOORD_1.x) * 0.30000001192092896f) + TEXCOORD_1.x) * _48);
  SV_Target.y = (((((_35 * max((1.0f - (_24 * _24)), 0.0f)) - TEXCOORD_1.y) * 0.30000001192092896f) + TEXCOORD_1.y) * _48);
  SV_Target.z = (((((_35 * max((1.0f - (_25 * _25)), 0.0f)) - TEXCOORD_1.z) * 0.30000001192092896f) + TEXCOORD_1.z) * _48);
  SV_Target.w = 1.0f;
  return SV_Target;
}
