Texture2D<float4> t0 : register(t0);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t7_space1 : register(t7, space1);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t12 : register(t12);

Texture2D<float> t14 : register(t14);

Texture2D<float4> t19_space1 : register(t19, space1);

Texture2D<float3> t20_space1 : register(t20, space1);

Texture2D<float> t21_space1 : register(t21, space1);

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
  float cb4_014z : packoffset(c014.z);
  float cb4_015z : packoffset(c015.z);
  float cb4_015w : packoffset(c015.w);
  uint cb4_024z : packoffset(c024.z);
};

cbuffer cb6 : register(b6) {
  float cb6_006z : packoffset(c006.z);
};

cbuffer cb8_space1 : register(b8, space1) {
  float cb8_space1_017z : packoffset(c017.z);
  float cb8_space1_017w : packoffset(c017.w);
};

cbuffer cb10_space1 : register(b10, space1) {
  float4 puddle_locals_000 : packoffset(c000.x);
  float4 puddle_locals_016 : packoffset(c001.x);
  float4 puddle_locals_032 : packoffset(c002.x);
};

cbuffer cb11_space1 : register(b11, space1) {
  float cb11_space1_001x : packoffset(c001.x);
  float cb11_space1_001y : packoffset(c001.y);
  float cb11_space1_001z : packoffset(c001.z);
  float cb11_space1_001w : packoffset(c001.w);
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
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _30 = t14.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _37 = cb8_space1_017z / ((1.0f - _30.x) + cb8_space1_017w);
  float _43 = (TEXCOORD_1.x / TEXCOORD_1.w) * _37;
  float _44 = (TEXCOORD_1.y / TEXCOORD_1.w) * _37;
  float _45 = (g_rage_matrices_192[3].x) + _43;
  float _46 = (g_rage_matrices_192[3].y) + _44;
  float _48 = (_37 + -140.0f) * 0.012500000186264515f;
  float4 _57 = t22_space1.SampleLevel(s4_space1, float2((puddle_locals_000.x * _45), (puddle_locals_000.x * _46)), 0.0f);
  float _60 = saturate(_57.x - puddle_locals_016.x);
  float _171;
  float _172;
  int _325;
  float _326;
  float _327;
  float _328;
  float _329;
  if ((_60 * saturate(1.0f - _48)) > 0.0f) {
    float4 _68 = t10.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));

    _68 = saturate(_68);

    float4 _70 = t12.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));

    _70 = saturate(_70);

    float4 _74 = t7_space1.Sample(s1_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _77 = select((_70.w > 0.5f), (_74.x * _70.x), _70.x);
    float _89 = saturate((_70.x + -0.5f) * 8.0f);
    float _91 = saturate(_70.x * 2.0f);
    float _92 = _91 * _91;
    float3 _96 = t20_space1.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _103 = (_96.x * 2.0f) + -1.0f;
    float _104 = (_96.y * 2.0f) + -1.0f;
    float _105 = (_96.z * 2.0f) + -1.0f;
    if ((_105 * rsqrt(dot(float3(_103, _104, _105), float3(_103, _104, _105)))) < 0.5f) {
      float3 _111 = t20_space1.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, 1);
      float _118 = (_111.x * 2.0f) + -1.0f;
      float _119 = (_111.y * 2.0f) + -1.0f;
      float _120 = (_111.z * 2.0f) + -1.0f;
      float3 _124 = t20_space1.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
      float _131 = (_124.x * 2.0f) + -1.0f;
      float _132 = (_124.y * 2.0f) + -1.0f;
      float _133 = (_124.z * 2.0f) + -1.0f;
      float3 _134 = t20_space1.SampleLevel(s0_space1, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
      float _141 = (_134.x * 2.0f) + -1.0f;
      float _142 = (_134.y * 2.0f) + -1.0f;
      float _143 = (_134.z * 2.0f) + -1.0f;
      if ((_120 * rsqrt(dot(float3(_118, _119, _120), float3(_118, _119, _120)))) > 0.5f) {
        _171 = ((cb4_015z * 2.0f) + TEXCOORD.x);
        _172 = TEXCOORD.y;
      } else {
        if ((rsqrt(dot(float3(_131, _132, _133), float3(_131, _132, _133))) * _133) > 0.5f) {
          _171 = TEXCOORD.x;
          _172 = ((cb4_015w * 2.0f) + TEXCOORD.y);
        } else {
          if ((_143 * rsqrt(dot(float3(_141, _142, _143), float3(_141, _142, _143)))) > 0.5f) {
            _171 = TEXCOORD.x;
            _172 = (TEXCOORD.y - (cb4_015w * 2.0f));
          } else {
            _171 = TEXCOORD.x;
            _172 = TEXCOORD.y;
          }
        }
      }
    } else {
      _171 = TEXCOORD.x;
      _172 = TEXCOORD.y;
    }
    float _173 = 1030.0f - _45;
    float _174 = 3134.0f - _46;
    float _175 = t21_space1.SampleLevel(s0_space1, float2(_171, _172), 0.0f);
    float _185 = -0.0f - _43;
    float _186 = -0.0f - _44;
    float _187 = -0.0f - ((TEXCOORD_1.z / TEXCOORD_1.w) * _37);
    float _189 = rsqrt(dot(float3(_185, _186, _187), float3(_185, _186, _187)));
    float _190 = _189 * _185;
    float _191 = _189 * _186;
    float _192 = _189 * _187;
    float4 _200 = t23_space1.Sample(s6_space1, float2((_45 * 0.5f), (_46 * 0.5f)));
    float4 _212 = t24_space1.Sample(s5_space1, float2(((cb11_space1_001x * _45) + cb11_space1_001z), ((1.0f - cb11_space1_001w) - (cb11_space1_001y * _46))));
    float _217 = (((_200.x * 2.0f) + -1.0f) + _212.x) * _89;
    float _218 = (((_200.y * 2.0f) + -1.0f) + _212.y) * _89;
    float _222 = sqrt(abs(1.0f - dot(float2(_217, _218), float2(_217, _218))));
    float _225 = 1.0f - saturate(dot(float3(_190, _191, _192), float3(_217, _218, _222)));
    float _226 = _225 * _225;
    float _231 = saturate(((_226 * _226) * (_225 * 0.9796299934387207f)) + 0.0203699991106987f);
    float _232 = -0.0f - _190;
    float _233 = -0.0f - _191;
    float _234 = -0.0f - _192;
    float _238 = min(0.0f, dot(float3(_232, _233, _234), float3(_217, _218, _222)));
    float _245 = _232 - ((_217 * 2.0f) * _238);
    float _247 = _234 - ((_222 * 2.0f) * _238);
    float _249 = select((_247 < 0.0f), _192, _247);
    float _250 = cb6_006z + -5.0f;
    float _252 = select((_250 > 0.0f), -5.0f, _250);
    float _257 = abs(_249) + 1.0f;
    float _264 = select((_249 > 0.0f), (0.75f - ((_245 * -0.25f) / _257)), (0.25f - ((_245 * 0.25f) / _257)));
    float _265 = 0.5f - (((_233 - ((_218 * 2.0f) * _238)) * 0.5f) / _257);
    float _277 = (saturate(saturate(((_60 * ((_92 * _92) * (saturate((puddle_locals_000.y + _68.w) * puddle_locals_000.z) * (1.0f - saturate(_48))))) + -0.078125f) * 1.185185194015503f) * 3.0f) * saturate((((_77 * _77) * 2.0f) - puddle_locals_016.w) * 1.5f)) * (lerp(puddle_locals_016.z, 1.0f, _231));
    if (abs(1.0f - (_175.x / _37)) < 0.10000000149011612f) {
      float4 _285 = t19_space1.Sample(s0_space1, float2(_171, _172));
      float _293 = 1.0f - (saturate(abs(_285.w)) * saturate((dot(float2(_173, _174), float2(_173, _174)) + -100.0f) * 0.009999999776482582f));
      float4 _294 = t4.SampleLevel(s1_space1, float2(_264, _265), _252);
      _325 = 1;
      _326 = (((lerp(_285.x, _294.x, _293)) * _231) * cb4_014z);
      _327 = (((lerp(_285.y, _294.y, _293)) * _231) * cb4_014z);
      _328 = (((lerp(_285.z, _294.z, _293)) * _231) * cb4_014z);
      _329 = _277;
    } else {
      float4 _314 = t0.SampleLevel(s1_space1, float2(_264, _265), _252);
      _325 = 1;
      _326 = ((_314.x * _231) * cb4_014z);
      _327 = ((_314.y * _231) * cb4_014z);
      _328 = ((_314.z * _231) * cb4_014z);
      _329 = _277;
    }
  } else {
    _325 = 0;
    _326 = 0.0f;
    _327 = 0.0f;
    _328 = 0.0f;
    _329 = 0.0f;
  }
  if (_329 == 0.0f) {
    if (true) discard;
  }
  SV_Target.x = _326;
  SV_Target.y = _327;
  SV_Target.z = _328;
  SV_Target.w = _329;
  SV_Target_1.x = 0.0f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = (float((uint)((int)((((uint)((uint)(cb4_024z) << 6)) & 192) | select((_325 != 0), 32, 0)))) * 0.003921568859368563f);

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
