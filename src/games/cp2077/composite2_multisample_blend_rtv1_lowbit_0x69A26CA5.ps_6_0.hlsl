static float _855;
static float _856;
static float _857;
static float _859;
static float _860;
static float _861;

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
static float4 SV_Target_1;

struct SPIRV_Cross_Input {
  nointerpolation float2 SYS_TEXCOORD : TEXCOORD1;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float4 SV_Target_1 : SV_Target1;
};

void frag_main() {
  float _61 = float(int(uint(int(gl_FragCoord.x))));
  float _62 = float(int(uint(int(gl_FragCoord.y))));
  float _63 = _61 + 0.5f;
  float _65 = _62 + 0.5f;
  float _72 = _63 * _34_m0[10u].z;
  float _73 = _65 * _34_m0[10u].w;
  float _87 = (_34_m0[14u].x * _34_m0[10u].x) * ((_72 * 2.0f) + (-1.0f));
  float _89 = (_34_m0[14u].x * _34_m0[10u].y) * ((_73 * 2.0f) + (-1.0f));
  float _104 = exp2(log2(max(dot(float2(_87, _89), float2(_87, _89)) - _34_m0[7u].w, 0.0f)) * _34_m0[7u].z);
  float _109 = (_104 * _87) * _34_m0[7u].x;
  float _110 = (_104 * _89) * _34_m0[7u].y;
  float _122 = frac(_61 * 0.103100001811981201171875f);
  float _123 = frac(_62 * 0.103100001811981201171875f);
  float _124 = frac(float(asuint(_24_m0[28u]).y) * 0.103100001811981201171875f);
  float _128 = _122 + 33.3300018310546875f;
  float _129 = dot(float3(_122, _123, _124), float3(_123 + 33.3300018310546875f, _124 + 33.3300018310546875f, _128));
  float _138 = frac(((_123 + _122) + (_129 * 2.0f)) * (_129 + _124));
  float _142 = _73 - (_138 * _110);
  float _149 = (_72 - (_138 * _109)) - (_34_m0[8u].w * 2.5f);
  float4 _156 = _13.Sample(_37, float2(_72 - (_109 * 2.5f), _73 - (_110 * 2.5f)));
  float4 _162 = _12.Sample(_37, float2(_149, _142));
  float _168 = _142 - _110;
  float _172 = _34_m0[8u].w + (_149 - _109);
  float4 _173 = _12.Sample(_37, float2(_172, _168));
  float _186 = _168 - _110;
  float _187 = _34_m0[8u].w + (_172 - _109);
  float4 _188 = _12.Sample(_37, float2(_187, _186));
  float _200 = _186 - _110;
  float _201 = _34_m0[8u].w + (_187 - _109);
  float4 _202 = _12.Sample(_37, float2(_201, _200));
  float _251 = ((((_34_m0[0u].w * 0.625f) * ((((_188.x * 0.300000011920928955078125f) + (_173.x * 0.100000001490116119384765625f)) + (_202.x * 0.4000000059604644775390625f)) + (_12.Sample(_37, float2((_201 - _109) + _34_m0[8u].w, _200 - _110)).x * 0.800000011920928955078125f))) + (_34_m0[0u].x * _156.x)) * _34_m0[11u].w) + _34_m0[11u].x;
  float _252 = (((_34_m0[0u].y * _156.y) + (((((_188.y * 0.5f) + (_173.y * 0.4000000059604644775390625f)) + (_202.y * 0.20000000298023223876953125f)) * 0.90909087657928466796875f) * _34_m0[0u].w)) * _34_m0[11u].w) + _34_m0[11u].y;
  float _253 = (((_34_m0[0u].z * _156.z) + (((((_173.z * 0.300000011920928955078125f) + (_162.z * 0.89999997615814208984375f)) + (_188.z * 0.100000001490116119384765625f)) * 0.76923072338104248046875f) * _34_m0[0u].w)) * _34_m0[11u].w) + _34_m0[11u].z;
  float _270 = (_34_m0[14u].x * _34_m0[10u].x) * (((_63 * 2.0f) * _34_m0[10u].z) + (-1.0f));
  float _272 = (_34_m0[14u].x * _34_m0[10u].y) * (((_65 * 2.0f) * _34_m0[10u].w) + (-1.0f));
  float _304;
  float _305;
  float _306;
  if (_34_m0[9u].x > 0.0f) {
    float _291 = exp2((-0.0f) - (_34_m0[9u].y * log2(abs((dot(float2(_270, _272), float2(_270, _272)) * _34_m0[9u].x) + 1.0f))));
    _304 = ((_251 - _34_m0[8u].x) * _291) + _34_m0[8u].x;
    _305 = ((_252 - _34_m0[8u].y) * _291) + _34_m0[8u].y;
    _306 = ((_253 - _34_m0[8u].z) * _291) + _34_m0[8u].z;
  } else {
    _304 = _251;
    _305 = _252;
    _306 = _253;
  }
  float _530;
  float _531;
  float _532;
  uint _331;
  float _341;
  float _343;
  float _451;
  float _452;
  float _453;
  float _465;
  float _466;
  float _467;
  float _475;
  float _476;
  float _477;
  uint _484;
  bool _485;
  for (;;) {
    _331 = 1u << (_8.Load(int3(uint2(uint(_29_m0[79u].x * _61), uint(_29_m0[79u].y * _62)), 0u)).y & 31u);
    _341 = frac(_62 * 0.10300000011920928955078125f);
    float _342 = frac(float(asuint(_24_m0[28u]).y) * 0.097300000488758087158203125f);
    _343 = _341 + 33.3300018310546875f;
    float _345 = dot(float3(_122, _341, _342), float3(_343, _128, _342 + 33.3300018310546875f));
    float _348 = _345 + _122;
    float _349 = _345 + _341;
    float _351 = _348 + _349;
    float _359 = frac(_351 * (_345 + _342)) + (-0.5f);
    float _361 = frac((_348 * 2.0f) * _349) + (-0.5f);
    float _362 = frac(_351 * _348) + (-0.5f);
    uint4 _375 = asuint(_34_m0[13u]);
    float _379 = float(min((_375.x & _331), 1u));
    float _400 = float(min((_375.y & _331), 1u));
    float _422 = float(min((_375.z & _331), 1u));
    float _444 = float(min((_375.w & _331), 1u));
    _451 = (((((_304 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].x * _359) * _379) + 1.0f)) * (((_34_m0[3u].x * _359) * _400) + 1.0f)) * (((_34_m0[4u].x * _359) * _422) + 1.0f)) * (((_34_m0[5u].x * _359) * _444) + 1.0f);
    _452 = (((((_305 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].y * _361) * _379) + 1.0f)) * (((_34_m0[3u].y * _361) * _400) + 1.0f)) * (((_34_m0[4u].y * _361) * _422) + 1.0f)) * (((_34_m0[5u].y * _361) * _444) + 1.0f);
    _453 = (((((_306 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].z * _362) * _379) + 1.0f)) * (((_34_m0[3u].z * _362) * _400) + 1.0f)) * (((_34_m0[4u].z * _362) * _422) + 1.0f)) * (((_34_m0[5u].z * _362) * _444) + 1.0f);
    _465 = (_34_m0[6u].x * log2(_451)) + _34_m0[6u].y;
    _466 = (_34_m0[6u].x * log2(_452)) + _34_m0[6u].y;
    _467 = (_34_m0[6u].x * log2(_453)) + _34_m0[6u].y;
    float4 _473 = _18[4u].SampleLevel(_37, float3(_465, _466, _467), 0.0f);
    _475 = _473.x;
    _476 = _473.y;
    _477 = _473.z;
    _484 = min((asuint(_34_m0[12u]).x & _331), 1u);
    _485 = _484 == 0u;
    uint _501;
    float _503;
    float _505;
    float _507;
    if (_485) {
      float4 _489 = _18[5u].SampleLevel(_37, float3(_465, _466, _467), 0.0f);
      uint _499 = min((asuint(_34_m0[12u]).y & _331), 1u);
      uint frontier_phi_4_3_ladder;
      float frontier_phi_4_3_ladder_1;
      float frontier_phi_4_3_ladder_2;
      float frontier_phi_4_3_ladder_3;
      if (_499 == 0u) {
        float4 _522 = _18[6u].SampleLevel(_37, float3(_465, _466, _467), 0.0f);
        uint _502 = min((asuint(_34_m0[12u]).z & _331), 1u);
        if (_502 == 0u) {
          _530 = _451;
          _531 = _452;
          _532 = _453;
          break;
        }
        frontier_phi_4_3_ladder = _502;
        frontier_phi_4_3_ladder_1 = _522.z;
        frontier_phi_4_3_ladder_2 = _522.y;
        frontier_phi_4_3_ladder_3 = _522.x;
      } else {
        frontier_phi_4_3_ladder = _499;
        frontier_phi_4_3_ladder_1 = _489.z;
        frontier_phi_4_3_ladder_2 = _489.y;
        frontier_phi_4_3_ladder_3 = _489.x;
      }
      _501 = frontier_phi_4_3_ladder;
      _503 = frontier_phi_4_3_ladder_1;
      _505 = frontier_phi_4_3_ladder_2;
      _507 = frontier_phi_4_3_ladder_3;
    } else {
      _501 = _484;
      _503 = _477;
      _505 = _476;
      _507 = _475;
    }
    float _509 = float(_501);
    _530 = ((_507 - _451) * _509) + _451;
    _531 = ((_505 - _452) * _509) + _452;
    _532 = ((_503 - _453) * _509) + _453;
    break;
  }
  float _765;
  float _766;
  float _767;
  float _563;
  float _564;
  float _565;
  uint _582;
  float _692;
  float _693;
  float _694;
  float _705;
  float _706;
  float _707;
  float _711;
  float _712;
  float _713;
  uint _719;
  bool _720;
  for (;;) {
    float _533 = dot(float3(_530, _531, _532), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _545 = max(9.9999997473787516355514526367188e-05f, dot(float3(_451, _452, _453), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
    _563 = ((_34_m0[1u].w * (((_533 * _451) / _545) - _530)) + _530) * _34_m0[1u].z;
    _564 = ((_34_m0[1u].w * (((_533 * _452) / _545) - _531)) + _531) * _34_m0[1u].z;
    _565 = ((_34_m0[1u].w * (((_533 * _453) / _545) - _532)) + _532) * _34_m0[1u].z;
    _582 = 1u << (_8.Load(int3(uint2(uint(_29_m0[79u].x * _61), uint(_29_m0[79u].y * _62)), 0u)).y & 31u);
    float _589 = frac(float(asuint(_24_m0[28u]).y) * 0.097300000488758087158203125f);
    float _591 = dot(float3(_122, _341, _589), float3(_343, _128, _589 + 33.3300018310546875f));
    float _594 = _591 + _122;
    float _595 = _591 + _341;
    float _597 = _594 + _595;
    float _605 = frac(_597 * (_591 + _589)) + (-0.5f);
    float _606 = frac((_594 * 2.0f) * _595) + (-0.5f);
    float _607 = frac(_597 * _594) + (-0.5f);
    uint4 _618 = asuint(_34_m0[13u]);
    float _622 = float(min((_618.x & _582), 1u));
    float _643 = float(min((_618.y & _582), 1u));
    float _664 = float(min((_618.z & _582), 1u));
    float _685 = float(min((_618.w & _582), 1u));
    _692 = ((((_34_m0[1u].y * _251) * (((_34_m0[2u].x * _605) * _622) + 1.0f)) * (((_34_m0[3u].x * _605) * _643) + 1.0f)) * (((_34_m0[4u].x * _605) * _664) + 1.0f)) * (((_34_m0[5u].x * _605) * _685) + 1.0f);
    _693 = ((((_34_m0[1u].y * _252) * (((_34_m0[2u].y * _606) * _622) + 1.0f)) * (((_34_m0[3u].y * _606) * _643) + 1.0f)) * (((_34_m0[4u].y * _606) * _664) + 1.0f)) * (((_34_m0[5u].y * _606) * _685) + 1.0f);
    _694 = ((((_34_m0[1u].y * _253) * (((_34_m0[2u].z * _607) * _622) + 1.0f)) * (((_34_m0[3u].z * _607) * _643) + 1.0f)) * (((_34_m0[4u].z * _607) * _664) + 1.0f)) * (((_34_m0[5u].z * _607) * _685) + 1.0f);
    _705 = (_34_m0[6u].x * log2(_692)) + _34_m0[6u].y;
    _706 = (_34_m0[6u].x * log2(_693)) + _34_m0[6u].y;
    _707 = (_34_m0[6u].x * log2(_694)) + _34_m0[6u].y;
    float4 _709 = _18[4u].SampleLevel(_37, float3(_705, _706, _707), 0.0f);
    _711 = _709.x;
    _712 = _709.y;
    _713 = _709.z;
    _719 = min((asuint(_34_m0[12u]).x & _582), 1u);
    _720 = _719 == 0u;
    uint _736;
    float _738;
    float _740;
    float _742;
    if (_720) {
      float4 _724 = _18[5u].SampleLevel(_37, float3(_705, _706, _707), 0.0f);
      uint _734 = min((asuint(_34_m0[12u]).y & _582), 1u);
      uint frontier_phi_8_7_ladder;
      float frontier_phi_8_7_ladder_1;
      float frontier_phi_8_7_ladder_2;
      float frontier_phi_8_7_ladder_3;
      if (_734 == 0u) {
        float4 _757 = _18[6u].SampleLevel(_37, float3(_705, _706, _707), 0.0f);
        uint _737 = min((asuint(_34_m0[12u]).z & _582), 1u);
        if (_737 == 0u) {
          _765 = _692;
          _766 = _693;
          _767 = _694;
          break;
        }
        frontier_phi_8_7_ladder = _737;
        frontier_phi_8_7_ladder_1 = _757.z;
        frontier_phi_8_7_ladder_2 = _757.y;
        frontier_phi_8_7_ladder_3 = _757.x;
      } else {
        frontier_phi_8_7_ladder = _734;
        frontier_phi_8_7_ladder_1 = _724.z;
        frontier_phi_8_7_ladder_2 = _724.y;
        frontier_phi_8_7_ladder_3 = _724.x;
      }
      _736 = frontier_phi_8_7_ladder;
      _738 = frontier_phi_8_7_ladder_1;
      _740 = frontier_phi_8_7_ladder_2;
      _742 = frontier_phi_8_7_ladder_3;
    } else {
      _736 = _719;
      _738 = _713;
      _740 = _712;
      _742 = _711;
    }
    float _744 = float(_736);
    _765 = ((_742 - _692) * _744) + _692;
    _766 = ((_740 - _693) * _744) + _693;
    _767 = ((_738 - _694) * _744) + _694;
    break;
  }
  float _768 = dot(float3(_765, _766, _767), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _777 = max(9.9999997473787516355514526367188e-05f, dot(float3(_692, _693, _694), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
  float _794 = ((_34_m0[1u].w * (((_768 * _692) / _777) - _765)) + _765) * _34_m0[1u].z;
  float _795 = ((_34_m0[1u].w * (((_768 * _693) / _777) - _766)) + _766) * _34_m0[1u].z;
  float _796 = ((_34_m0[1u].w * (((_768 * _694) / _777) - _767)) + _767) * _34_m0[1u].z;
  SV_Target.x = asfloat(asuint(_794) + 65536u);
  SV_Target.y = asfloat(asuint(_795) + 65536u);
  SV_Target.z = asfloat(asuint(_796) + 131072u);
  SV_Target.w = 1.0f;
  SV_Target_1.x = asfloat(asuint(_794 - _563) + 65536u);
  SV_Target_1.y = asfloat(asuint(_795 - _564) + 65536u);
  SV_Target_1.z = asfloat(asuint(_796 - _565) + 131072u);
  SV_Target_1.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
