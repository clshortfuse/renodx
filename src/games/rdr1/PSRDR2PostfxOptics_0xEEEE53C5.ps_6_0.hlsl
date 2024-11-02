cbuffer _GlobalsUBO : register(b0, space0) {
  float4 _Globals_m0[86] : packoffset(c0);
};

Texture2D<float4> g_textures2D[] : register(t0, space2);
SamplerState g_samplers[] : register(s0, space1);

static float4 TEXCOORD;
static float4 TEXCOORD_1;
static float4 TEXCOORD_2;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 TEXCOORD : TEXCOORD1;
  float4 TEXCOORD_1 : TEXCOORD2;
  float4 TEXCOORD_2 : TEXCOORD3;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float _81 = ((-0.0f) - (_Globals_m0[14u].x * _Globals_m0[14u].z)) / (g_textures2D[asuint(_Globals_m0[27u]).w + 0u].Sample(g_samplers[asuint(_Globals_m0[28u]).x + 0u], float2(TEXCOORD.x, TEXCOORD.y)).x - _Globals_m0[14u].z);
  uint4 _85 = asuint(_Globals_m0[25u]);
  float4 _95 = g_textures2D[_85.y + 0u].Sample(g_samplers[_85.z + 0u], float2(TEXCOORD.x, TEXCOORD.y));
  float _97 = _95.x;
  float _98 = _95.y;
  float _99 = _95.z;
  uint4 _102 = asuint(_Globals_m0[27u]);
  float4 _112 = g_textures2D[_102.y + 0u].Sample(g_samplers[_102.z + 0u], float2(TEXCOORD.x, TEXCOORD.y));
  float _114 = _112.x;
  float _115 = _112.y;
  float _116 = _112.z;
  float4 _147 = g_textures2D[asuint(_Globals_m0[26u]).w + 0u].Sample(g_samplers[asuint(_Globals_m0[27u]).x + 0u], float2(TEXCOORD.x, TEXCOORD.y));
  float _165 = max(float(_81 < _Globals_m0[13u].z) * clamp((_81 - _Globals_m0[13u].y) * _Globals_m0[13u].x, 0.0f, 1.0f), clamp(_112.w, 0.0f, 1.0f));
  float _198 = (_165 * (_147.x - _97)) + _97;
  float _199 = (_165 * (_147.y - _98)) + _98;
  float _200 = (_165 * (_147.z - _99)) + _99;
  uint4 _204 = asuint(_Globals_m0[65u]);
  float4 _214 = g_textures2D[_204.x + 0u].Sample(g_samplers[_204.y + 0u], float2(TEXCOORD_2.x, TEXCOORD_2.y));
  float _219 = _214.w;
  uint4 _222 = asuint(_Globals_m0[65u]);
  float4 _232 = g_textures2D[_222.z + 0u].Sample(g_samplers[_222.w + 0u], float2(TEXCOORD_2.z, TEXCOORD_2.w));
  float _237 = _232.w;
  float _265 = log2(abs(1.0099999904632568359375f - dot(float3(_198, _199, _200), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f))));
  float _268 = exp2(_265 * _Globals_m0[66u].y);
  float _269 = exp2(_265 * _Globals_m0[66u].z);
  float _300 = _Globals_m0[6u].z / (min(max(g_textures2D[asuint(_Globals_m0[28u]).w + 0u].Sample(g_samplers[asuint(_Globals_m0[29u]).x + 0u], 0.0f.xx).x, _Globals_m0[20u].y), _Globals_m0[20u].z) + 0.001000000047497451305389404296875f);
  float _301 = (((((_219 * _214.x) * _Globals_m0[68u].x) * _268) + _198) + (((_237 * _232.x) * _Globals_m0[67u].x) * _269)) * _300;
  float _302 = _300 * (((((_219 * _214.y) * _Globals_m0[68u].y) * _268) + _199) + (((_237 * _232.y) * _Globals_m0[67u].y) * _269));
  float _303 = _300 * (((((_219 * _214.z) * _Globals_m0[68u].z) * _268) + _200) + (((_237 * _232.z) * _Globals_m0[67u].z) * _269));

  float _347 = clamp((_Globals_m0[11u].x * 2.0f) * ((((((_301 / _Globals_m0[7u].x) + 1.0f) * _301) / (_301 + 1.0f)) + ((_114 * _114) * _Globals_m0[7u].y)) + _Globals_m0[10u].x), 0.0f, 1.0f);
  float _348 = clamp((_Globals_m0[11u].y * 2.0f) * ((((((_302 / _Globals_m0[7u].x) + 1.0f) * _302) / (_302 + 1.0f)) + ((_115 * _115) * _Globals_m0[7u].y)) + _Globals_m0[10u].y), 0.0f, 1.0f);
  float _349 = clamp((_Globals_m0[11u].z * 2.0f) * ((((((_303 / _Globals_m0[7u].x) + 1.0f) * _303) / (_303 + 1.0f)) + ((_116 * _116) * _Globals_m0[7u].y)) + _Globals_m0[10u].z), 0.0f, 1.0f);

  float _356 = dot(float3(_347, _348, _349), float3(_Globals_m0[9u].xyz));
  float _366 = (_Globals_m0[9u].w * (_347 - _356)) + _356;
  float _367 = (_Globals_m0[9u].w * (_348 - _356)) + _356;
  float _368 = (_Globals_m0[9u].w * (_349 - _356)) + _356;

  SV_Target.x = exp2(log2(abs(clamp(_366 - (((_366 * _Globals_m0[12u].x) * (_366 + (-1.0f))) * (_366 + (-0.5f))), 0.0f, 1.0f))) * 0.454545438289642333984375f);
  SV_Target.y = exp2(log2(abs(clamp(_367 - (((_367 * _Globals_m0[12u].x) * (_367 + (-1.0f))) * (_367 + (-0.5f))), 0.0f, 1.0f))) * 0.454545438289642333984375f);
  SV_Target.z = exp2(log2(abs(clamp(_368 - (((_368 * _Globals_m0[12u].x) * (_368 + (-1.0f))) * (_368 + (-0.5f))), 0.0f, 1.0f))) * 0.454545438289642333984375f);

  // SV_Target.x = exp2(log2(abs(_366 - (((_366 * _Globals_m0[12u].x) * (_366 + (-1.0f))) * (_366 + (-0.5f))))) * 0.454545438289642333984375f);
  // SV_Target.y = exp2(log2(abs(_367 - (((_367 * _Globals_m0[12u].x) * (_367 + (-1.0f))) * (_367 + (-0.5f))))) * 0.454545438289642333984375f);
  // SV_Target.z = exp2(log2(abs(_368 - (((_368 * _Globals_m0[12u].x) * (_368 + (-1.0f))) * (_368 + (-0.5f))))) * 0.454545438289642333984375f);

  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD_1 = stage_input.TEXCOORD_1;
  TEXCOORD_2 = stage_input.TEXCOORD_2;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
