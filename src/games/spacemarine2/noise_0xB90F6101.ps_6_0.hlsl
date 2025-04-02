Texture2D<float4> FILL_COLOR : register(t0, space2);

Texture2D<float4> FILL_COLOR1 : register(t1, space2);

Texture2D<float4> FILL_COLOR2 : register(t2, space2);

cbuffer CB_PS_PASS_FILL : register(b4) {
  float4 FILL_LOD_NMB : packoffset(c000.x);
  float4 FILL_CONST_COLOR : packoffset(c001.x);
  float4 FILL_TEX_SIZE : packoffset(c002.x);
  float4 FILL_PARAMS[6] : packoffset(c003.x);
  int4 FILL_OFFSET : packoffset(c009.x);
  int4 FILL_CAS[4] : packoffset(c010.x);
  float FILL_RCAS_EXPOSURE_SCALE : packoffset(c014.x);
  float FILL_TRANSPARENCY_MASK_SCALE : packoffset(c014.y);
  float2 FILL_PADDING_0 : packoffset(c014.z);
};

SamplerState PS_SAMPLERS[12] : register(s0, space1);

// We should work through the logic but I'm lazy so we bypass
float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;  
  float4 _10 = FILL_COLOR2.Sample(PS_SAMPLERS[1u], float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float _17 = (_10.x * 2.0f) + -1.0f;
  float _18 = (_10.y * 2.0f) + -1.0f;
  float _19 = (_10.z * 2.0f) + -1.0f;
  float _20 = dot(float3(_17, _18, _19), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float4 _33 = FILL_COLOR.Sample(PS_SAMPLERS[3u], float2(TEXCOORD.x, TEXCOORD.y));
  float _43 = (pow(_33.x, 2.200000047683716f));
  float _44 = (pow(_33.y, 2.200000047683716f));
  float _45 = (pow(_33.z, 2.200000047683716f));
  float4 _74 = FILL_COLOR1.Sample(PS_SAMPLERS[4u], float2(TEXCOORD.x, TEXCOORD.y));
  float _87 = dot(float3((pow(_74.x, 2.200000047683716f)), (pow(_74.y, 2.200000047683716f)), (pow(_74.z, 2.200000047683716f))), float3(0.21267099678516388f, 0.7151600122451782f, 0.0721689984202385f));
  float _91 = saturate(_87 / (FILL_PARAMS[4].x));
  float _95 = (_91 * _91) * (3.0f - (_91 * 2.0f));
  float _102 = saturate((_87 - (FILL_PARAMS[4].y)) / ((FILL_PARAMS[4].z) - (FILL_PARAMS[4].y)));
  float _106 = (_102 * _102) * (3.0f - (_102 * 2.0f));
  float _116 = (FILL_PARAMS[0].w) * saturate(dot(float3((FILL_PARAMS[1].x), (FILL_PARAMS[1].y), (FILL_PARAMS[1].z)), float3((1.0f - _95), (_95 - _106), _106)));
  SV_Target.x = exp2(log2((_116 * (max((FILL_PARAMS[3].x), (((((FILL_PARAMS[0].x) * _43) + (FILL_PARAMS[2].x)) * (((_20 - _17) * (FILL_PARAMS[1].w)) + _17)) + _43)) - _43)) + _43) * 0.4545454680919647f);
  SV_Target.y = exp2(log2((_116 * (max((FILL_PARAMS[3].y), (((((FILL_PARAMS[0].y) * _44) + (FILL_PARAMS[2].y)) * (((_20 - _18) * (FILL_PARAMS[1].w)) + _18)) + _44)) - _44)) + _44) * 0.4545454680919647f);
  SV_Target.z = exp2(log2((_116 * (max((FILL_PARAMS[3].z), (((((FILL_PARAMS[0].z) * _45) + (FILL_PARAMS[2].z)) * (((_20 - _19) * (FILL_PARAMS[1].w)) + _19)) + _45)) - _45)) + _45) * 0.4545454680919647f);
  SV_Target.w = 1.0f;
  return SV_Target;
}
