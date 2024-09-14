static float _585;
static float _586;
static float _587;

cbuffer _22_24 : register(b0, space0) {
  float4 _24_m0[30] : packoffset(c0);
};

cbuffer _27_29 : register(b12, space0) {
  float4 _29_m0[99] : packoffset(c0);
};

cbuffer _32_34 : register(b6, space0) {
  float4 _34_m0[15] : packoffset(c0);
};

Texture2D<uint4> _8 : register(t51, space0);
Texture2D<float4> _12 : register(t0, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture3D<float4> _18[3] : register(t4, space0);
SamplerState _37 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  nointerpolation float2 SYS_TEXCOORD : TEXCOORD1;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float _60 = float(int(uint(int(gl_FragCoord.x))));
  float _61 = float(int(uint(int(gl_FragCoord.y))));
  float _62 = _60 + 0.5f;
  float _64 = _61 + 0.5f;
  float _71 = _62 * _34_m0[10u].z;
  float _72 = _64 * _34_m0[10u].w;
  float _86 = (_34_m0[14u].x * _34_m0[10u].x) * ((_71 * 2.0f) + (-1.0f));
  float _88 = (_34_m0[14u].x * _34_m0[10u].y) * ((_72 * 2.0f) + (-1.0f));
  float _103 = exp2(log2(max(dot(float2(_86, _88), float2(_86, _88)) - _34_m0[7u].w, 0.0f)) * _34_m0[7u].z);
  float _108 = (_103 * _86) * _34_m0[7u].x;
  float _109 = (_103 * _88) * _34_m0[7u].y;
  float _121 = frac(_60 * 0.103100001811981201171875f);
  float _122 = frac(_61 * 0.103100001811981201171875f);
  float _123 = frac(float(asuint(_24_m0[28u]).y) * 0.103100001811981201171875f);
  float _127 = _121 + 33.3300018310546875f;
  float _128 = dot(float3(_121, _122, _123), float3(_122 + 33.3300018310546875f, _123 + 33.3300018310546875f, _127));
  float _137 = frac(((_122 + _121) + (_128 * 2.0f)) * (_128 + _123));
  float _141 = _72 - (_137 * _109);
  float _148 = (_71 - (_137 * _108)) - (_34_m0[8u].w * 2.5f);
  float4 _155 = _13.Sample(_37, float2(_71 - (_108 * 2.5f), _72 - (_109 * 2.5f)));
  float4 _161 = _12.Sample(_37, float2(_148, _141));
  float _167 = _141 - _109;
  float _171 = _34_m0[8u].w + (_148 - _108);
  float4 _172 = _12.Sample(_37, float2(_171, _167));
  float _185 = _167 - _109;
  float _186 = _34_m0[8u].w + (_171 - _108);
  float4 _187 = _12.Sample(_37, float2(_186, _185));
  float _199 = _185 - _109;
  float _200 = _34_m0[8u].w + (_186 - _108);
  float4 _201 = _12.Sample(_37, float2(_200, _199));
  float _250 = ((((_34_m0[0u].w * 0.625f) * ((((_187.x * 0.300000011920928955078125f) + (_172.x * 0.100000001490116119384765625f)) + (_201.x * 0.4000000059604644775390625f)) + (_12.Sample(_37, float2((_200 - _108) + _34_m0[8u].w, _199 - _109)).x * 0.800000011920928955078125f))) + (_34_m0[0u].x * _155.x)) * _34_m0[11u].w) + _34_m0[11u].x;
  float _251 = (((_34_m0[0u].y * _155.y) + (((((_187.y * 0.5f) + (_172.y * 0.4000000059604644775390625f)) + (_201.y * 0.20000000298023223876953125f)) * 0.90909087657928466796875f) * _34_m0[0u].w)) * _34_m0[11u].w) + _34_m0[11u].y;
  float _252 = (((_34_m0[0u].z * _155.z) + (((((_172.z * 0.300000011920928955078125f) + (_161.z * 0.89999997615814208984375f)) + (_187.z * 0.100000001490116119384765625f)) * 0.76923072338104248046875f) * _34_m0[0u].w)) * _34_m0[11u].w) + _34_m0[11u].z;
  float _269 = (_34_m0[14u].x * _34_m0[10u].x) * (((_62 * 2.0f) * _34_m0[10u].z) + (-1.0f));
  float _271 = (_34_m0[14u].x * _34_m0[10u].y) * (((_64 * 2.0f) * _34_m0[10u].w) + (-1.0f));
  float _303;
  float _304;
  float _305;
  if (_34_m0[9u].x > 0.0f) {
    float _290 = exp2((-0.0f) - (_34_m0[9u].y * log2(abs((dot(float2(_269, _271), float2(_269, _271)) * _34_m0[9u].x) + 1.0f))));
    _303 = ((_250 - _34_m0[8u].x) * _290) + _34_m0[8u].x;
    _304 = ((_251 - _34_m0[8u].y) * _290) + _34_m0[8u].y;
    _305 = ((_252 - _34_m0[8u].z) * _290) + _34_m0[8u].z;
  } else {
    _303 = _250;
    _304 = _251;
    _305 = _252;
  }
  float _529;
  float _530;
  float _531;
  uint _330;
  float _450;
  float _451;
  float _452;
  float _464;
  float _465;
  float _466;
  float _474;
  float _475;
  float _476;
  uint _483;
  bool _484;
  for (;;) {
    _330 = 1u << (_8.Load(int3(uint2(uint(_29_m0[79u].x * _60), uint(_29_m0[79u].y * _61)), 0u)).y & 31u);
    float _340 = frac(_61 * 0.10300000011920928955078125f);
    float _341 = frac(float(asuint(_24_m0[28u]).y) * 0.097300000488758087158203125f);
    float _344 = dot(float3(_121, _340, _341), float3(_340 + 33.3300018310546875f, _127, _341 + 33.3300018310546875f));
    float _347 = _344 + _121;
    float _348 = _344 + _340;
    float _350 = _347 + _348;
    float _358 = frac(_350 * (_344 + _341)) + (-0.5f);
    float _360 = frac((_347 * 2.0f) * _348) + (-0.5f);
    float _361 = frac(_350 * _347) + (-0.5f);
    uint4 _374 = asuint(_34_m0[13u]);
    float _378 = float(min((_374.x & _330), 1u));
    float _399 = float(min((_374.y & _330), 1u));
    float _421 = float(min((_374.z & _330), 1u));
    float _443 = float(min((_374.w & _330), 1u));
    _450 = (((((_303 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].x * _358) * _378) + 1.0f)) * (((_34_m0[3u].x * _358) * _399) + 1.0f)) * (((_34_m0[4u].x * _358) * _421) + 1.0f)) * (((_34_m0[5u].x * _358) * _443) + 1.0f);
    _451 = (((((_304 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].y * _360) * _378) + 1.0f)) * (((_34_m0[3u].y * _360) * _399) + 1.0f)) * (((_34_m0[4u].y * _360) * _421) + 1.0f)) * (((_34_m0[5u].y * _360) * _443) + 1.0f);
    _452 = (((((_305 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].z * _361) * _378) + 1.0f)) * (((_34_m0[3u].z * _361) * _399) + 1.0f)) * (((_34_m0[4u].z * _361) * _421) + 1.0f)) * (((_34_m0[5u].z * _361) * _443) + 1.0f);
    _464 = (_34_m0[6u].x * log2(_450)) + _34_m0[6u].y;
    _465 = (_34_m0[6u].x * log2(_451)) + _34_m0[6u].y;
    _466 = (_34_m0[6u].x * log2(_452)) + _34_m0[6u].y;
    float4 _472 = _18[4u].SampleLevel(_37, float3(_464, _465, _466), 0.0f);
    _474 = _472.x;
    _475 = _472.y;
    _476 = _472.z;
    _483 = min((asuint(_34_m0[12u]).x & _330), 1u);
    _484 = _483 == 0u;
    uint _500;
    float _502;
    float _504;
    float _506;
    if (_484) {
      float4 _488 = _18[5u].SampleLevel(_37, float3(_464, _465, _466), 0.0f);
      uint _498 = min((asuint(_34_m0[12u]).y & _330), 1u);
      uint frontier_phi_4_3_ladder;
      float frontier_phi_4_3_ladder_1;
      float frontier_phi_4_3_ladder_2;
      float frontier_phi_4_3_ladder_3;
      if (_498 == 0u) {
        float4 _521 = _18[6u].SampleLevel(_37, float3(_464, _465, _466), 0.0f);
        uint _501 = min((asuint(_34_m0[12u]).z & _330), 1u);
        if (_501 == 0u) {
          _529 = _450;
          _530 = _451;
          _531 = _452;
          break;
        }
        frontier_phi_4_3_ladder = _501;
        frontier_phi_4_3_ladder_1 = _521.z;
        frontier_phi_4_3_ladder_2 = _521.y;
        frontier_phi_4_3_ladder_3 = _521.x;
      } else {
        frontier_phi_4_3_ladder = _498;
        frontier_phi_4_3_ladder_1 = _488.z;
        frontier_phi_4_3_ladder_2 = _488.y;
        frontier_phi_4_3_ladder_3 = _488.x;
      }
      _500 = frontier_phi_4_3_ladder;
      _502 = frontier_phi_4_3_ladder_1;
      _504 = frontier_phi_4_3_ladder_2;
      _506 = frontier_phi_4_3_ladder_3;
    } else {
      _500 = _483;
      _502 = _476;
      _504 = _475;
      _506 = _474;
    }
    float _508 = float(_500);
    _529 = ((_506 - _450) * _508) + _450;
    _530 = ((_504 - _451) * _508) + _451;
    _531 = ((_502 - _452) * _508) + _452;
    break;
  }
  float _532 = dot(float3(_529, _530, _531), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _544 = max(9.9999997473787516355514526367188e-05f, dot(float3(_450, _451, _452), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
  SV_Target.x = ((_34_m0[1u].w * (((_532 * _450) / _544) - _529)) + _529) * _34_m0[1u].z;
  SV_Target.y = ((_34_m0[1u].w * (((_532 * _451) / _544) - _530)) + _530) * _34_m0[1u].z;
  SV_Target.z = ((_34_m0[1u].w * (((_532 * _452) / _544) - _531)) + _531) * _34_m0[1u].z;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
