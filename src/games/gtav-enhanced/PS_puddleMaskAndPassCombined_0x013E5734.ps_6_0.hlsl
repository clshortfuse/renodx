Texture2D<float4> t0 : register(t0);

Texture2D<float4> t7_space1 : register(t7, space1);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t12 : register(t12);

Texture2D<float> t14 : register(t14);

Texture2D<float4> t22_space1 : register(t22, space1);

Texture2D<float4> t23_space1 : register(t23, space1);

Texture2D<float4> t24_space1 : register(t24, space1);

cbuffer cb2 : register(b2) {
  float4 g_rage_matrices_000[4] : packoffset(c000.x);
  float4 g_rage_matrices_064[4] : packoffset(c004.x);
  float4 g_rage_matrices_128[4] : packoffset(c008.x);
  float4 g_rage_matrices_192[4] : packoffset(c012.x);
  float4 g_rage_matrices_256[4] : packoffset(c016.x);
  float4 g_rage_matrices_320[4] : packoffset(c020.x);
  float4 g_rage_matrices_384[4] : packoffset(c024.x);
  float4 g_rage_matrices_448[4] : packoffset(c028.x);
  float4 g_rage_matrices_512[4] : packoffset(c032.x);
  float4 g_rage_matrices_576[4] : packoffset(c036.x);
  float4 g_rage_matrices_640[4] : packoffset(c040.x);
  float4 g_rage_matrices_704[4] : packoffset(c044.x);
  float4 g_rage_matrices_768[4] : packoffset(c048.x);
  float4 g_rage_matrices_832[4] : packoffset(c052.x);
};

cbuffer cb4 : register(b4) {
  float4 misc_globals_000 : packoffset(c000.x);
  float misc_globals_016 : packoffset(c001.x);
  float misc_globals_020 : packoffset(c001.y);
  float misc_globals_024 : packoffset(c001.z);
  float misc_globals_028 : packoffset(c001.w);
  float4 misc_globals_032 : packoffset(c002.x);
  float4 misc_globals_048 : packoffset(c003.x);
  float4 misc_globals_064 : packoffset(c004.x);
  float4 misc_globals_080 : packoffset(c005.x);
  float4 misc_globals_096 : packoffset(c006.x);
  float4 misc_globals_112[4] : packoffset(c007.x);
  float4 misc_globals_176 : packoffset(c011.x);
  float4 misc_globals_192 : packoffset(c012.x);
  float4 misc_globals_208 : packoffset(c013.x);
  float4 misc_globals_224 : packoffset(c014.x);
  float4 misc_globals_240 : packoffset(c015.x);
  int4 misc_globals_256 : packoffset(c016.x);
  float4 misc_globals_272 : packoffset(c017.x);
  float4 misc_globals_288 : packoffset(c018.x);
  float misc_globals_304 : packoffset(c019.x);
  float misc_globals_308 : packoffset(c019.y);
  float4 misc_globals_320 : packoffset(c020.x);
  float4 misc_globals_336 : packoffset(c021.x);
  float misc_globals_352 : packoffset(c022.x);
  int misc_globals_356 : packoffset(c022.y);
  int misc_globals_360 : packoffset(c022.z);
  int2 misc_globals_368 : packoffset(c023.x);
  int2 misc_globals_376 : packoffset(c023.z);
  int misc_globals_384 : packoffset(c024.x);
  float misc_globals_388 : packoffset(c024.y);
  int misc_globals_392 : packoffset(c024.z);
  float misc_globals_396 : packoffset(c024.w);
  float2 misc_globals_400 : packoffset(c025.x);
  int misc_globals_408 : packoffset(c025.z);
};

cbuffer cb6 : register(b6) {
  float4 g_more_stuff_000[2] : packoffset(c000.x);
  float4 g_more_stuff_032 : packoffset(c002.x);
  float4 g_more_stuff_048 : packoffset(c003.x);
  float4 g_more_stuff_064 : packoffset(c004.x);
  float4 g_more_stuff_080 : packoffset(c005.x);
  float g_more_stuff_096 : packoffset(c006.x);
  int g_more_stuff_100 : packoffset(c006.y);
  float g_more_stuff_104 : packoffset(c006.z);
  float g_more_stuff_108 : packoffset(c006.w);
  int g_more_stuff_112 : packoffset(c007.x);
  float4 g_more_stuff_128 : packoffset(c008.x);
  int g_more_stuff_144 : packoffset(c009.x);
  float g_more_stuff_148 : packoffset(c009.y);
  float2 g_more_stuff_152 : packoffset(c009.z);
  int g_more_stuff_160 : packoffset(c010.x);
};

cbuffer cb8_space1 : register(b8, space1) {
  float4 lighting_locals_000[14] : packoffset(c000.x);
  float4 lighting_locals_224[2] : packoffset(c014.x);
  float4 lighting_locals_256 : packoffset(c016.x);
  float4 lighting_locals_272 : packoffset(c017.x);
  float3 lighting_locals_288 : packoffset(c018.x);
  float3 lighting_locals_304 : packoffset(c019.x);
  float3 lighting_locals_320 : packoffset(c020.x);
};

cbuffer cb10_space1 : register(b10, space1) {
  float4 puddle_locals_000 : packoffset(c000.x);
  float4 puddle_locals_016 : packoffset(c001.x);
  float4 puddle_locals_032 : packoffset(c002.x);
};

cbuffer cb11_space1 : register(b11, space1) {
  float3 ripple_locals_000 : packoffset(c000.x);
  float4 ripple_locals_016 : packoffset(c001.x);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s1_space1 : register(s1, space1);

SamplerState s4_space1 : register(s4, space1);

SamplerState s5_space1 : register(s5, space1);

SamplerState s6_space1 : register(s6, space1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _33;
  float _39;
  float _40;
  float _41;
  float _42;
  float _44;
  float _56;
  int _202;
  float _203;
  float _204;
  float _205;
  float _206;
  float4 _66;
  float _73;
  float _85;
  float _87;
  float _88;
  float _96;
  float _97;
  float _98;
  float _100;
  float _101;
  float _102;
  float _103;
  float4 _111;
  float4 _123;
  float _128;
  float _129;
  float _133;
  float _136;
  float _137;
  float _142;
  float _143;
  float _144;
  float _145;
  float _149;
  float _156;
  float _158;
  float _160;
  float _161;
  float _168;
  float4 _177;
  _33 = lighting_locals_272.z / ((1.0f - ((t14.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f)).x)) + lighting_locals_272.w);
  _39 = (TEXCOORD_1.x / TEXCOORD_1.w) * _33;
  _40 = (TEXCOORD_1.y / TEXCOORD_1.w) * _33;
  _41 = (g_rage_matrices_192[3].x) + _39;
  _42 = (g_rage_matrices_192[3].y) + _40;
  _44 = (_33 + -140.0f) * 0.012500000186264515f;
  _56 = saturate((((float4)(t22_space1.SampleLevel(s4_space1, float2((puddle_locals_000.x * _41), (puddle_locals_000.x * _42)), 0.0f))).x) - puddle_locals_016.x);
  if ((_56 * saturate(1.0f - _44)) > 0.0f) {
    _66 = t12.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
    _73 = select((_66.w > 0.5f), ((((float4)(t7_space1.Sample(s1_space1, float2(TEXCOORD.x, TEXCOORD.y)))).x) * _66.x), _66.x);
    _85 = saturate((_66.x + -0.5f) * 8.0f);
    _87 = saturate(_66.x * 2.0f);
    _88 = _87 * _87;
    _96 = -0.0f - _39;
    _97 = -0.0f - _40;
    _98 = -0.0f - ((TEXCOORD_1.z / TEXCOORD_1.w) * _33);
    _100 = rsqrt(dot(float3(_96, _97, _98), float3(_96, _97, _98)));
    _101 = _100 * _96;
    _102 = _100 * _97;
    _103 = _100 * _98;
    _111 = t23_space1.Sample(s6_space1, float2((_41 * 0.5f), (_42 * 0.5f)));
    _123 = t24_space1.Sample(s5_space1, float2(((ripple_locals_016.x * _41) + ripple_locals_016.z), ((1.0f - ripple_locals_016.w) - (ripple_locals_016.y * _42))));
    _128 = (((_111.x * 2.0f) + -1.0f) + _123.x) * _85;
    _129 = (((_111.y * 2.0f) + -1.0f) + _123.y) * _85;
    _133 = sqrt(abs(1.0f - dot(float2(_128, _129), float2(_128, _129))));
    _136 = 1.0f - saturate(dot(float3(_101, _102, _103), float3(_128, _129, _133)));
    _137 = _136 * _136;
    _142 = saturate(((_137 * _137) * (_136 * 0.9796299934387207f)) + 0.0203699991106987f);
    _143 = -0.0f - _101;
    _144 = -0.0f - _102;
    _145 = -0.0f - _103;
    _149 = min(0.0f, dot(float3(_143, _144, _145), float3(_128, _129, _133)));
    _156 = _143 - ((_128 * 2.0f) * _149);
    _158 = _145 - ((_133 * 2.0f) * _149);
    _160 = select((_158 < 0.0f), _103, _158);
    _161 = g_more_stuff_104 + -5.0f;
    _168 = abs(_160) + 1.0f;
    _177 = t0.SampleLevel(s1_space1, float2(select((_160 > 0.0f), (0.75f - ((_156 * -0.25f) / _168)), (0.25f - ((_156 * 0.25f) / _168))), (0.5f - (((_144 - ((_129 * 2.0f) * _149)) * 0.5f) / _168))), select((_161 > 0.0f), -5.0f, _161));
    _202 = 1;
    _203 = ((_177.x * _142) * misc_globals_224.z);
    _204 = ((_177.y * _142) * misc_globals_224.z);
    _205 = ((_177.z * _142) * misc_globals_224.z);
    _206 = ((saturate(saturate(((((_88 * _88) * (saturate((puddle_locals_000.y + (((float4)(t10.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y)))).w)) * puddle_locals_000.z) * (1.0f - saturate(_44)))) * _56) + -0.078125f) * 1.185185194015503f) * 3.0f) * saturate((((_73 * _73) * 2.0f) - puddle_locals_016.w) * 1.5f)) * (lerp(puddle_locals_016.z, 1.0f, _142)));
  } else {
    _202 = 0;
    _203 = 0.0f;
    _204 = 0.0f;
    _205 = 0.0f;
    _206 = 0.0f;
  }
  if (_206 == 0.0f) {
    if (true) discard;
  }
  SV_Target.x = _203;
  SV_Target.y = _204;
  SV_Target.z = _205;
  SV_Target.w = _206;
  SV_Target_1.x = 0.0f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = (((float)((uint)((uint)((((int)(misc_globals_392 << 6)) & 192) | select((_202 != 0), 32, 0))))) * 0.003921568859368563f);
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
