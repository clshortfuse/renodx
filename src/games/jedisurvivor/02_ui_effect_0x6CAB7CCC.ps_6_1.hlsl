cbuffer _16_18 : register(b0, space0) { float4 _18_m0[19] : packoffset(c0); };

cbuffer _21_23 : register(b1, space0) { float4 _23_m0[235] : packoffset(c0); };

cbuffer _26_28 : register(b2, space0) { float4 _28_m0[9] : packoffset(c0); };

Texture2D<float4> _8 : register(t0, space0);   // 1D LUT
Texture2D<float4> _9 : register(t1, space0);   // Vignette mask
Texture2D<float4> _10 : register(t2, space0);  // Cloud
Texture2D<float4> _11 : register(t3, space0);  // BC3 Texture?
SamplerState _31 : register(s0, space0);
SamplerState _32 : register(s1, space0);
SamplerState _33 : register(s2, space0);

static float4 COLOR;
static float4 ORIGINAL_POSITION;
static float2 TEXCOORD;
static float4 TEXCOORD_1;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  float4 COLOR : COLOR;
  float4 ORIGINAL_POSITION : ORIGINAL_POSITION;
  float2 TEXCOORD : TEXCOORD0;
  float4 TEXCOORD_1 : TEXCOORD1;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float _72 = TEXCOORD_1.z * TEXCOORD_1.x;
  float _73 = TEXCOORD_1.w * TEXCOORD_1.y;
  float _74 = _72 + (-0.5f);
  float _76 = _73 + (-0.5f);
  float _86 = frac(_23_m0[143u].z * 0.00999999977648258209228515625f) * 6.283185482025146484375f;
  float _88 = cos(_86);
  float _89 = sin(_86);
  float _98 = dot(float2(_74, _76), float2(_88, (-0.0f) - _89)) + 0.5f;
  float _100 = dot(float2(_74, _76), float2(_89, _88)) + 0.5f;
  float4 _115 =
      _8.Sample(_33, float2(_28_m0[7u].x * 0.75f, _28_m0[7u].z / _28_m0[1u].x));
  float _117 = _115.x;
  float _118 = _115.y;
  float _122 = 1.5f - (_117 * 0.5f);
  float _128 = 0.5f / _122;
  float _137 = 0.5f - _128;
  float4 _140 =
      _9.Sample(_31, float2(_137 + (_72 / _122), _137 + (_73 / _122)));
  float _142 = _140.x;
  float _143 = _142 * _9.Sample(_31, float2(((_98 / _122) + 0.5f) - _128, ((_100 / _122) + 0.5f) - _128)).w;
  float _161 = 2.0f - _118;
  float _167 = 0.5f / _161;
  float _175 = 0.5f - _167;
  float4 _178 =
      _9.Sample(_31, float2(_175 + (_72 / _161), _175 + (_73 / _161)));
  float _180 = _178.y;
  float _181 = _180 * _9.Sample(_31, float2(((_98 / _161) + 0.5f) - _167, ((_100 / _161) + 0.5f) - _167)).w;
  float _208 = 1.5f - (_115.z * 0.5f);
  float _213 = 0.5f / _208;
  float _221 = 0.5f - _213;
  float _227 =
      _9.Sample(_31, float2(_221 + (_72 / _208), _221 + (_73 / _208))).z * _9.Sample(_31, float2((((dot(float2(_74, _76), float2(1.0f, -0.0f)) + 0.5f) / _208) + 0.5f) - _213, (((dot(float2(_74, _76), float2(0.0f, 1.0f)) + 0.5f) / _208) + 0.5f) - _213)).w;
  float _251 = (((((_28_m0[5u].x * _142) + (_143 * _28_m0[3u].x)) + (_181 * _28_m0[3u].x)) + (_28_m0[5u].x * _180)) + (_227 * _28_m0[5u].x)) * _28_m0[7u].w;
  float _252 = (((((_28_m0[5u].y * _142) + (_143 * _28_m0[3u].y)) + (_181 * _28_m0[3u].y)) + (_28_m0[5u].y * _180)) + (_227 * _28_m0[5u].y)) * _28_m0[7u].w;
  float _253 = (((((_28_m0[5u].z * _142) + (_143 * _28_m0[3u].z)) + (_181 * _28_m0[3u].z)) + (_28_m0[5u].z * _180)) + (_227 * _28_m0[5u].z)) * _28_m0[7u].w;
  float _254 =
      dot(float3(_251, _252, _253),
          float3(0.300000011920928955078125f, 0.589999973773956298828125f,
                 0.10999999940395355224609375f));
  float _271 = ((_254 - _251) * _28_m0[8u].x) + _251;
  float _272 = ((_254 - _252) * _28_m0[8u].x) + _252;
  float _273 = ((_254 - _253) * _28_m0[8u].x) + _253;
  float4 _295 = _10.Sample(_32, float2(_72 * 14.0f, _73 * 8.0f));
  float _297 = _295.z;
  float4 _311 = _11.Sample(_33, float2(_72, _73));
  float _322 =
      max(((_28_m0[6u].x - _271) * _28_m0[8u].y) + _271, 0.0f) * COLOR.x;
  float _323 =
      max(((_28_m0[6u].y - _272) * _28_m0[8u].y) + _272, 0.0f) * COLOR.y;
  float _324 =
      max(((_28_m0[6u].z - _273) * _28_m0[8u].y) + _273, 0.0f) * COLOR.z;
  float _367;
  float _368;
  float _369;
  if (_18_m0[14u].x != 0.0f) {
    float _332 =
        dot(float3(0.300000011920928955078125f, 0.589999973773956298828125f,
                   0.10999999940395355224609375f),
            float3(_322, _323, _324));
    float _342 = ((_332 - _322) * 0.800000011920928955078125f) + _322;
    float _343 = ((_332 - _323) * 0.800000011920928955078125f) + _323;
    float _344 = ((_332 - _324) * 0.800000011920928955078125f) + _324;
    float _345 = _342 + (-0.100000001490116119384765625f);
    float _347 = _343 + (-0.100000001490116119384765625f);
    float _348 = _344 + (-0.100000001490116119384765625f);
    float _356 =
        min(max(sqrt(((_345 * _345) + (_347 * _347)) + (_348 * _348)), 0.0f),
            0.800000011920928955078125f);
    _367 = ((0.100000001490116119384765625f - _342) * _356) + _342;
    _368 = ((0.100000001490116119384765625f - _343) * _356) + _343;
    _369 = ((0.100000001490116119384765625f - _344) * _356) + _344;
  } else {
    _367 = _322;
    _368 = _323;
    _369 = _324;
  }
  float _389;
  float _390;
  float _391;
  if (_18_m0[12u].w != 1.0f) {
    _389 = clamp((_18_m0[12u].w * (_367 + (-0.25f))) + 0.25f, 0.0f, 1.0f);
    _390 = clamp((_18_m0[12u].w * (_368 + (-0.25f))) + 0.25f, 0.0f, 1.0f);
    _391 = clamp((_18_m0[12u].w * (_369 + (-0.25f))) + 0.25f, 0.0f, 1.0f);
  } else {
    _389 = _367;
    _390 = _368;
    _391 = _369;
  }
  float _406;
  float _408;
  float _410;
  if (_18_m0[12u].y != 1.0f) {
    float _401 = exp2(log2(_389) * _18_m0[12u].x);
    float _402 = exp2(log2(_390) * _18_m0[12u].x);
    float _403 = exp2(log2(_391) * _18_m0[12u].x);
    float _407;
    if (_401 < 0.00313066993840038776397705078125f) {
      _407 = _401 * 12.9200000762939453125f;
    } else {
      _407 = (exp2(log2(_401) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _409;
    if (_402 < 0.00313066993840038776397705078125f) {
      _409 = _402 * 12.9200000762939453125f;
    } else {
      _409 = (exp2(log2(_402) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_6_12_ladder;
    float frontier_phi_6_12_ladder_1;
    float frontier_phi_6_12_ladder_2;
    if (_403 < 0.00313066993840038776397705078125f) {
      frontier_phi_6_12_ladder = _407;
      frontier_phi_6_12_ladder_1 = _409;
      frontier_phi_6_12_ladder_2 = _403 * 12.9200000762939453125f;
    } else {
      frontier_phi_6_12_ladder = _407;
      frontier_phi_6_12_ladder_1 = _409;
      frontier_phi_6_12_ladder_2 =
          (exp2(log2(_403) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    _406 = frontier_phi_6_12_ladder;
    _408 = frontier_phi_6_12_ladder_1;
    _410 = frontier_phi_6_12_ladder_2;
  } else {
    _406 = _389;
    _408 = _390;
    _410 = _391;
  }
  SV_Target.x = _406;
  SV_Target.y = _408;
  SV_Target.z = _410;
  SV_Target.w = clamp(clamp((_311.w * _117) + (-0.5f), 0.0f, 1.0f) + ((((ceil((_117 + (-1.0f)) + _297) * _142) + _227) + (ceil((_118 + (-1.0f)) + _297) * _180)) * _115.w),
                      0.0f, 1.0f)
                * COLOR.w;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  COLOR = stage_input.COLOR;
  ORIGINAL_POSITION = stage_input.ORIGINAL_POSITION;
  TEXCOORD = stage_input.TEXCOORD;
  TEXCOORD_1 = stage_input.TEXCOORD_1;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
