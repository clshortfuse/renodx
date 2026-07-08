#version 450

#extension GL_GOOGLE_include_directive : require
#include "./include/common.glsl"
#include "./include/psychov_17.glsl"
#include "./shared.h"

#if defined(GL_AMD_gpu_shader_half_float)
#extension GL_AMD_gpu_shader_half_float : require
#elif defined(GL_EXT_shader_explicit_arithmetic_types_float16)
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : require
#else
#error No extension available for FP16.
#endif
#extension GL_EXT_shader_16bit_storage : require
#extension GL_EXT_buffer_reference2 : require
#extension GL_EXT_nonuniform_qualifier : require
#if defined(GL_EXT_control_flow_attributes)
#extension GL_EXT_control_flow_attributes : require
#define SPIRV_CROSS_FLATTEN [[flatten]]
#define SPIRV_CROSS_BRANCH  [[dont_flatten]]
#define SPIRV_CROSS_UNROLL  [[unroll]]
#define SPIRV_CROSS_LOOP    [[dont_unroll]]
#else
#define SPIRV_CROSS_FLATTEN
#define SPIRV_CROSS_BRANCH
#define SPIRV_CROSS_UNROLL
#define SPIRV_CROSS_LOOP
#endif
#extension GL_KHR_shader_subgroup_shuffle : require
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

struct _5249 {
  uint _m0;
  uint _m1;
};

struct _5364 {
  float _m0;
  float _m1;
};

struct _5365 {
  float _m0[6];
  float _m1[6];
  _5364 _m2;
  _5364 _m3;
  _5364 _m4;
  float _m5;
  float _m6;
};

layout(set = 0, binding = 0, std140) uniform _328_330 {
  uvec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
  vec4 _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
  vec4 _m11;
  vec4 _m12;
  vec4 _m13;
  vec4 _m14;
  vec4 _m15;
  vec4 _m16;
  vec4 _m17;
  vec4 _m18;
  vec4 _m19;
  vec4 _m20;
  vec4 _m21;
  vec4 _m22;
  vec4 _m23;
  vec4 _m24;
  vec4 _m25;
  vec4 _m26;
  vec4 _m27;
  vec4 _m28;
  vec4 _m29;
  vec4 _m30;
  vec4 _m31;
  vec4 _m32;
  vec4 _m33;
  vec4 _m34;
  float16_t _m35;
  float16_t _m36;
  float _m37;
  uint _m38;
  float _m39;
  float _m40;
  float _m41;
  float _m42;
  float _m43;
  float _m44;
  float _m45;
  float _m46;
  float _m47;
  float _m48;
  float _m49;
  float _m50;
  float _m51;
  float _m52;
  float _m53;
  float _m54;
  uint _m55;
  float _m56;
  float _m57;
  float _m58;
  float _m59;
  float _m60;
  float _m61;
  float _m62;
  float _m63;
  float _m64;
  uint _m65;
  uint _m66;
  float _m67;
  uint _m68;
  float _m69;
  float _m70;
  float _m71;
  float _m72;
  float _m73;
  float _m74;
  float _m75;
  float _m76;
  float _m77;
  float _m78;
  float _m79;
  float _m80;
  float _m81;
  float _m82;
  float _m83;
  float _m84;
  float _m85;
  float _m86;
  uint _m87;
  uint _m88;
  float _m89;
  float _m90;
  int _m91;
  float _m92;
  float _m93;
  float _m94;
  uint _m95;
  uint _m96;
  uint _m97;
  float _m98;
  uint _m99;
  int _m100;
  float _m101;
  float _m102;
  float _m103;
  float _m104;
  float _m105;
  float _m106;
  uint _m107;
  uint _m108;
  uint _m109;
  uint _m110;
}
_330;

layout(set = 1, binding = 0, std140) uniform _968_970 {
  uvec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
  vec4 _m7;
  uint _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  float _m16;
  int _m17;
  int _m18;
  float _m19;
  float _m20;
  float _m21;
  uint _m22;
}
_970;

layout(set = 1, binding = 2, std140) uniform _2995_2997 {
  vec4 _m0[4];
}
_2997;

layout(set = 1, binding = 10, std140) uniform _3391_3393 {
  vec4 _m0[4];
}
_3393;

layout(set = 1, binding = 11, std140) uniform _4389_4391 {
  vec4 _m0[3];
}
_4391;

layout(set = 0, binding = 18, std430) restrict readonly buffer _4533_4535 {
  float _m0[];
}
_4535;

layout(set = 0, binding = 12, std430) restrict buffer _4879_4881 {
  float _m0[];
}
_4881;

layout(set = 0, binding = 6, std430) restrict readonly buffer _5251_5253 {
  _5249 _m0[];
}
_5253;

layout(set = 0, binding = 7, std140) uniform _5256_5258 {
  vec4 _m0[1024];
}
_5258;

layout(set = 0, binding = 9, std140) uniform _5260_5262 {
  vec4 _m0[64];
}
_5262;

layout(set = 0, binding = 8) uniform texture2D _1038;
layout(set = 0, binding = 10) uniform sampler _1042;
layout(set = 0, binding = 16) uniform texture2D _1177;
layout(set = 0, binding = 19) uniform texture2D _1407;
layout(set = 1, binding = 9) uniform texture2D _1471;
layout(set = 1, binding = 12) uniform texture2D _1524;
layout(set = 0, binding = 3) uniform texture2D _1712;
layout(set = 0, binding = 15) uniform sampler _1714;
layout(set = 0, binding = 4) uniform texture2D _1764;
layout(set = 1, binding = 8) uniform texture2D _2008;
layout(set = 0, binding = 29) uniform texture2D _2036;
layout(set = 1, binding = 13) uniform texture2D _2061;
layout(set = 1, binding = 15) uniform texture2D _2103;
layout(set = 1, binding = 16) uniform texture2D _2124;
layout(set = 1, binding = 17) uniform texture2D _2161;
layout(set = 0, binding = 33) uniform texture2D _2177;
layout(set = 2, binding = 0) uniform texture2D _2210[];
layout(set = 0, binding = 11) uniform sampler _2220;
layout(set = 0, binding = 30) uniform texture2D _2495;
layout(set = 0, binding = 2) uniform texture2D _2510;
layout(set = 1, binding = 3) uniform texture2D _2527;
layout(set = 0, binding = 1) uniform texture2D _2544;
layout(set = 0, binding = 5) uniform texture2D _2623;
layout(set = 1, binding = 4) uniform texture3D _2764;
layout(set = 1, binding = 14, r8) uniform readonly image2D _2928;
layout(set = 1, binding = 1) uniform texture2D _2964;
layout(set = 0, binding = 32) uniform texture2D _3024;
layout(set = 0, binding = 14) uniform sampler _3026;
layout(set = 1, binding = 7) uniform texture2D _3259;
layout(set = 0, binding = 22) uniform texture2D _3671;
layout(set = 0, binding = 20) uniform texture2D _3718;
layout(set = 0, binding = 21) uniform sampler _3720;
layout(set = 0, binding = 25) uniform texture2D _3918;
layout(set = 0, binding = 23) uniform texture2D _3965;
layout(set = 0, binding = 24) uniform sampler _3967;
layout(set = 0, binding = 28) uniform texture2D _4165;
layout(set = 0, binding = 26) uniform texture2D _4212;
layout(set = 0, binding = 27) uniform sampler _4214;
layout(set = 1, binding = 6) uniform texture2D _4431;
layout(set = 0, binding = 17) uniform texture2D _4555;
layout(set = 0, binding = 31) uniform texture3D _4961;
layout(set = 1, binding = 5, r11f_g11f_b10f) uniform writeonly image2D _5234;
layout(set = 2, binding = 1) uniform textureCube _5245[1];
layout(set = 2, binding = 2) uniform texture3D _5248[1];
layout(set = 0, binding = 13) uniform texture2D _5263;

uint _169;
uint _171;
uint _173;
int _176;
int _178;
int _180;
uint _5270;

float _111(float _110) {
  return 0.16666667163372039794921875 * ((_110 * ((_110 * ((-_110) + 3.0)) - 3.0)) + 1.0);
}

float _114(float _113) {
  return 0.16666667163372039794921875 * (((_113 * _113) * ((3.0 * _113) - 6.0)) + 4.0);
}

float _123(float _122) {
  float _481 = _122;
  float _484 = _122;
  return _111(_481) + _114(_484);
}

float _117(float _116) {
  return 0.16666667163372039794921875 * ((_116 * ((_116 * (((-3.0) * _116) + 3.0)) + 3.0)) + 1.0);
}

float _120(float _119) {
  return 0.16666667163372039794921875 * ((_119 * _119) * _119);
}

float _126(float _125) {
  float _490 = _125;
  float _493 = _125;
  return _117(_490) + _120(_493);
}

float _129(float _128) {
  float _500 = _128;
  float _503 = _128;
  float _506 = _128;
  return (-1.0) + (_114(_500) / (_111(_503) + _114(_506)));
}

float _132(float _131) {
  float _514 = _131;
  float _517 = _131;
  float _520 = _131;
  return 1.0 + (_120(_514) / (_117(_517) + _120(_520)));
}

float _10(float _9) {
  return clamp(_9, 0.0, 1.0);
}

vec2 _76(mat2 _74, vec2 _75) {
  return _74 * _75;
}

float _38(float _35, float _36, float _37) {
  return max(_35, max(_36, _37));
}

vec3 _162(vec3 _161) {
  float _919 = 1.0 * _330._m86;
  float _927 = _161.x;
  float _930 = _161.y;
  float _933 = _161.z;
  return _161 * (_919 / (1.0 - (0.9900000095367431640625 * _38(_927, _930, _933))));
}

uint _142(uint _140, uint _141) {
  return _140;
}

float _166(float _165) {
  float _943 = clamp(_165, 0.0, 1.0);
  return ((3.0 - (2.0 * _943)) * _943) * _943;
}

float _85(vec3 _84) {
  return dot(_84, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
}

vec3 _67(vec3 _65, mat3 _66) {
  return _65 * _66;
}

// ACEScc Encode
float _148(float _147) {
  if (_147 <= 0.0078125) {
    return (10.5402374267578125 * _147) + 0.072905533015727996826171875;
  } else {
    return (log2(_147) + 9.72000026702880859375) / 17.520000457763671875;
  }
}

float _43(float _40, float _41, float _42) {
  return min(_40, min(_41, _42));
}

vec3 _16(vec3 _15) {
  return clamp(_15, vec3(0.0), vec3(1.0));
}

// ACEScc Decode
float _145(float _144) {
  if (_144 > 0.15525114536285400390625) {
    return exp2((_144 * 17.520000457763671875) - 9.72000026702880859375);
  } else {
    return (_144 - 0.072905533015727996826171875) / 10.5402374267578125;
  }
}

float _137(inout vec2 _135, inout vec2 _136) {
  if (_136.x == _136.y) {
    return length(_135) - _136.x;
  }
  _135 = abs(_135);
  if (_135.x > _135.y) {
    _135 = _135.yx;
    _136 = _136.yx;
  }
  float _554 = (_136.y * _136.y) - (_136.x * _136.x);
  float _566 = (_136.x * _135.x) / _554;
  float _574 = _566 * _566;
  float _578 = (_136.y * _135.y) / _554;
  float _586 = _578 * _578;
  float _590 = ((_574 + _586) - 1.0) / 3.0;
  float _596 = (_590 * _590) * _590;
  float _602 = _596 + ((_574 * _586) * 2.0);
  float _610 = _596 + (_574 * _586);
  float _616 = _566 + (_566 * _586);
  float _662;
  if (_610 < 0.0) {
    float _626 = acos(_602 / _596) / 3.0;
    float _632 = cos(_626);
    float _635 = sin(_626) * 1.73205077648162841796875;
    float _640 = sqrt(((-_590) * ((_632 + _635) + 2.0)) + _574);
    float _651 = sqrt(((-_590) * ((_632 - _635) + 2.0)) + _574);
    _662 = (((_651 + (sign(_554) * _640)) + (abs(_616) / (_640 * _651))) - _566) / 2.0;
  } else {
    float _680 = ((2.0 * _566) * _578) * sqrt(_610);
    float _688 = sign(_602 + _680) * pow(abs(_602 + _680), 0.3333333432674407958984375);
    float _700 = sign(_602 - _680) * pow(abs(_602 - _680), 0.3333333432674407958984375);
    float _711 = (((-_688) - _700) - (_590 * 4.0)) + (2.0 * _574);
    float _722 = (_688 - _700) * 1.73205077648162841796875;
    float _727 = sqrt((_711 * _711) + (_722 * _722));
    _662 = (((_722 / sqrt(_727 - _711)) + ((2.0 * _616) / _727)) - _566) / 2.0;
  }
  vec2 _750 = _136 * vec2(_662, sqrt(1.0 - (_662 * _662)));
  return length(_750 - _135) * sign(_135.y - _750.y);
}

float _92(float _90, bool _91) {
  float _319 = 1.0 - _90;
  if (_91) {
    _319 -= (float(_319 > _330._m52) * _330._m51);
  }
  float _351 = _319;
  return vec2(_330._m78, _330._m79).y / (_10(_351) + vec2(_330._m78, _330._m79).x);
}

vec3 _96(vec2 _95) {
  return (vec3(_330._m56, _330._m57, _330._m58) + (_330._m7.xyz * _95.x)) + (_330._m8.xyz * _95.y);
}

vec3 _101(vec2 _99, float _100) {
  vec3 _391 = _96(_99);
  return _391 * _100;
}

uint _32(float _31) {
  return floatBitsToUint(_31);
}

vec4 _81(uint _80) {
  return unpackUnorm4x8(_80).wzyx;
}

float _46(float _45) {
  float _223;
  if (_45 <= 0.040449999272823333740234375) {
    _223 = _45 / 12.9200000762939453125;
  } else {
    _223 = pow((_45 / 1.05499994754791259765625) + 0.0521326996386051177978515625, 2.400000095367431640625);
  }
  return _223;
}

vec3 _49(vec3 _48) {
  float _240 = _48.x;
  float _245 = _48.y;
  float _250 = _48.z;
  return vec3(_46(_240), _46(_245), _46(_250));
}

vec3 _62(mat3 _60, vec3 _61) {
  return _60 * _61;
}

vec3 _159(vec3 _157, float _158) {
  float _856;
  if (_157.x > 0.0) {
    float _865 = (log2(_157.x) + 8.0) / 16.0;
    _856 = _10(_865);
  } else {
    _856 = 0.0;
  }
  vec3 _852;
  _852.x = _856;
  float _873;
  if (_157.y > 0.0) {
    float _881 = (log2(_157.y) + 8.0) / 16.0;
    _873 = _10(_881);
  } else {
    _873 = 0.0;
  }
  _852.y = _873;
  float _889;
  if (_157.z > 0.0) {
    float _897 = (log2(_157.z) + 8.0) / 16.0;
    _889 = _10(_897);
  } else {
    _889 = 0.0;
  }
  _852.z = _889;
  _852 *= ((_158 - 1.0) / _158);
  _852 += vec3(0.5 / _158);
  vec3 _914 = _852;
  return _16(_914);
}

float _52(float _51) {
  float _261;
  if (_51 > 0.003130800090730190277099609375) {
    _261 = (pow(_51, 0.4166666567325592041015625) * 1.05499994754791259765625) - 0.054999999701976776123046875;
  } else {
    _261 = _51 * 12.9200000762939453125;
  }
  return _261;
}

vec3 _55(vec3 _54) {
  float _276 = _54.x;
  float _280 = _54.y;
  float _284 = _54.z;
  return vec3(_52(_276), _52(_280), _52(_284));
}

float _151(float _150) {
  float _812 = _150 / 10000.0;
  float _816 = pow(_812, 0.1593017578125);
  float _820 = (0.8359375 + (18.8515625 * _816)) / (1.0 + (18.6875 * _816));
  _820 = pow(_820, 78.84375);
  return _820;
}

vec3 _154(vec3 _153) {
  float _837 = _153.x;
  float _841 = _153.y;
  float _845 = _153.z;
  return vec3(_151(_837), _151(_841), _151(_845));
}

float _108(uvec2 _106, uint _107) {
  uvec2 _397 = _106 & uvec2(3u);
  uint _402 = ((_397.x + (_397.y << uint(2))) + _107) & 15u;
  return float((((3742624800u * (1u - (_402 & 1u))) + (1469801640u * (_402 & 1u))) >> ((_402 >> uint(1)) << uint(2))) & 15u) / 16.0;
}

float _22(uint _21) {
  return uintBitsToFloat(_21);
}

float _28(int _27) {
  return intBitsToFloat(_27);
}

void main() {
  _169 = 2147483648u;
  _171 = 1073741824u;
  _173 = 536870912u;
  _176 = 0;
  _178 = 1;
  _180 = 2;
  ivec2 _956 = ivec2(gl_GlobalInvocationID.xy);
  vec2 _963 = (vec2(_956) + vec2(0.5)) * _970._m4.zw;
  vec3 _976 = vec3(0.0);
  bool _985 = float(_956.x) >= (_330._m22.x - 8.0);
  bool _995;
  if (_985) {
    _995 = float(_956.y) >= (_330._m22.y - 8.0);
  } else {
    _995 = _985;
  }
  bool _1005;
  if (_995) {
    _1005 = float(_956.x) < (_330._m22.z + 8.0);
  } else {
    _1005 = _995;
  }
  bool _1015;
  if (_1005) {
    _1015 = float(_956.y) < (_330._m22.w + 8.0);
  } else {
    _1015 = _1005;
  }
  if (_1015) {
    float _1018 = _330._m101;
    float _1022 = 1.0 / _1018;
    vec2 _1025 = _963 - vec2(0.5);
    float _1029 = length(_1025);
    vec3 _1032 = vec3(0.0);
    vec2 _1033 = _963;
    float _1035 = 1.0;
    // Screen-space distortion/aberration UV setup.
    _1033 += textureLod(sampler2D(_1038, _1042), vec4(_963.x, 1.0 - _963.y, 0.0, 0.0).xy, vec4(_963.x, 1.0 - _963.y, 0.0, 0.0).w).xy;
    uint _1064 = _330._m99;
    vec2 _1069 = (vec2(1.0) / _970._m4.zw) / vec2(4.0);
    vec2 _1077 = (_963 * _1069) + vec2(0.5);
    vec2 _1083 = floor(_1077);
    vec2 _1086 = fract(_1077);
    float _1090 = _1086.x;
    float _1089 = _123(_1090);
    float _1095 = _1086.x;
    float _1094 = _126(_1095);
    float _1100 = _1086.x;
    float _1099 = _129(_1100);
    float _1105 = _1086.x;
    float _1104 = _132(_1105);
    float _1110 = _1086.y;
    float _1109 = _129(_1110);
    float _1115 = _1086.y;
    float _1114 = _132(_1115);
    vec2 _1119 = (vec2(_1083.x + _1099, _1083.y + _1109) - vec2(0.5)) / _1069;
    vec2 _1133 = (vec2(_1083.x + _1104, _1083.y + _1109) - vec2(0.5)) / _1069;
    vec2 _1147 = (vec2(_1083.x + _1099, _1083.y + _1114) - vec2(0.5)) / _1069;
    vec2 _1161 = (vec2(_1083.x + _1104, _1083.y + _1114) - vec2(0.5)) / _1069;
    vec4 _1176 = textureLod(sampler2D(_1177, _1042), vec4(_1119, 0.0, 0.0).xy, vec4(_1119, 0.0, 0.0).w);
    vec4 _1192 = textureLod(sampler2D(_1177, _1042), vec4(_1133, 0.0, 0.0).xy, vec4(_1133, 0.0, 0.0).w);
    vec4 _1207 = textureLod(sampler2D(_1177, _1042), vec4(_1147, 0.0, 0.0).xy, vec4(_1147, 0.0, 0.0).w);
    vec4 _1222 = textureLod(sampler2D(_1177, _1042), vec4(_1161, 0.0, 0.0).xy, vec4(_1161, 0.0, 0.0).w);
    float _1238 = _1086.y;
    float _1250 = _1086.y;
    vec4 _1237 = (((_1176 * _1089) + (_1192 * _1094)) * _123(_1238)) + (((_1207 * _1089) + (_1222 * _1094)) * _126(_1250));
    vec2 _1263 = _1237.xy;
    _1263 = (_1263 * 2.007874011993408203125) - vec2(1.007874011993408203125);
    _1263.x /= _330._m101;
    _1263 *= 0.100000001490116119384765625;
    _1033 += _1263;
    float _1284 = _970._m19;
    // Optional animated screen wobble/distortion.
    SPIRV_CROSS_BRANCH
    if (_1284 > 0.0) {
      float _1292 = float(_1284 < 1.0);
      vec2 _1296 = _963;
      _1296.x *= _1018;
      _1296.x *= (1.0 + (0.4000000059604644775390625 * _1292));
      _1296.y -= ((_1292 * _330._m98) * 2.0);
      _1296 *= 6.0;
      _1296 += vec2(_330._m98 * 1.5);
      vec2 _1330 = vec2(sin(_1296.x - _1296.y) * sin(_1296.y), cos(_1296.x + _1296.y) * cos(_1296.y)) * 0.0040000001899898052215576171875;
      _1330.x *= _1022;
      _1330 *= (1.0 + ((_1292 * 3000.0) * _1330.x));
      _1033 += (_1330 * _1284);
    }
    float _1373 = _330._m53;
    float _1377 = _970._m10 * pow(_1029, _970._m9 - 1.0);
    _1033.x = 0.5 + ((_1033.x - 0.5) * (1.0 - (0.100000001490116119384765625 * _1373)));
    float _1397 = 0.0;
    // Mask lookup for blending between the two scene/color buffers.
    SPIRV_CROSS_BRANCH
    if (((_970._m22 & 1u) != 0u) == true) {
      vec4 _1406 = textureLod(sampler2D(_1407, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w);
      _1397 = _1406.w;
      SPIRV_CROSS_BRANCH
      if ((_1064 & 16u) != 0u) {
        float _1430 = 0.0;
        vec2 _1431 = ((_1406.xy * 255.0) - vec2(128.0)) / vec2(127.0);
        _1430 += length(_1431);
        float _1446 = _1406.z;
        _1430 += _1446;
        float _1455 = 1.0 - (1.5 * _1430);
        _1035 = _10(_1455);
      }
    }
    vec3 _1457 = vec3(0.0);
    // Chromatic aberration / radial blur sampling for the two scene buffers.
    SPIRV_CROSS_BRANCH
    if (_1373 != 0.0) {
      float _1462 = 0.02500000037252902984619140625 * _1373;
      SPIRV_CROSS_BRANCH
      if (_1397 > 0.0) {
        vec3 _1470 = textureLod(sampler2D(_1471, _1042), vec4(_1033.x + _1462, _1033.y, 0.0, 0.0).xy, vec4(_1033.x + _1462, _1033.y, 0.0, 0.0).w).xyz;
        vec3 _1493 = textureLod(sampler2D(_1471, _1042), vec4(_1033.x - _1462, _1033.y, 0.0, 0.0).xy, vec4(_1033.x - _1462, _1033.y, 0.0, 0.0).w).xyz;
        _1457 = (_1470 + _1493) * 0.5;
      }
      SPIRV_CROSS_BRANCH
      if (_1397 < 1.0) {
        vec3 _1523 = textureLod(sampler2D(_1524, _1042), vec4(_1033.x + _1462, _1033.y, 0.0, 0.0).xy, vec4(_1033.x + _1462, _1033.y, 0.0, 0.0).w).xyz;
        vec3 _1546 = textureLod(sampler2D(_1524, _1042), vec4(_1033.x - _1462, _1033.y, 0.0, 0.0).xy, vec4(_1033.x - _1462, _1033.y, 0.0, 0.0).w).xyz;
        _1032 = (_1523 + _1546) * 0.5;
      }
    } else {
      if (((_330._m110 & 1u) != 0u) == true) {
        vec2 _1581 = vec2(1.0) / _970._m4.zw;
        vec2 _1587 = _1033 - vec2(0.5);
        float _1590 = length(_1587);
        float _1593 = (_1590 * _1590) * 4.0;
        vec2 _1598 = _1587 * 2.0;
        float _1601 = _330._m37 * 0.20000000298023223876953125;
        float _1607 = (0.5 * _1593) * _1601;
        float _1612 = (((-0.20000000298023223876953125) * _1593) * _1593) * _1601;
        float _1620 = ((0.1617999970912933349609375 * _1593) * _1601) * _330._m40;
        vec3 _1630 = vec3(0.0);
        vec3 _1631 = vec3(0.0);
        vec3 _1632 = vec3(0.0);
        vec2 _1633 = _1598;
        float _1635 = sin(_1620);
        float _1638 = cos(_1620);
        mat2 _1641 = mat2(vec2(_1638, -_1635), vec2(_1635, _1638));
        mat2 _1657 = _1641;
        vec2 _1659 = _1598 * (1.0 + (_1607 * _1612));
        vec2 _1650 = _76(_1657, _1659);
        float _1661 = distance(_1633 * _1581, _1650 * _1581);
        uint _1676;
        if (_1661 < float(_330._m38)) {
          _1676 = uint(floor(_1661 + 1.0));
        } else {
          _1676 = _330._m38;
        }
        uint _1669 = _1676;
        float _1687 = _330._m39;
        vec2 _1691 = vec2(0.0);
        if (_1661 > _1687) {
          float _1698 = _1687 / _1661;
          _1691 = _1598 + ((_1650 - _1598) * _1698);
        } else {
          _1691 = _1650;
        }
        float _1711 = texelFetch(sampler2D(_1712, _1714), ivec2(_330._m14.xy + ((_1633 * _1581) * 2.0)) & ivec2(511), 0).x;
        vec3 _1759;
        for (uint _1733 = 0u; _1733 < _1669; _1733++) {
          float _1742 = (float(_1733) + _1711) / float(_1669);
          vec2 _1750 = mix(_1598, _1691, vec2(_1742));
          if (_1669 == 1u) {
            _1759 = vec3(1.0);
          } else {
            _1759 = textureLod(sampler2D(_1764, _1042), vec4(_1742, 0.0, 0.0, 0.0).xy, vec4(_1742, 0.0, 0.0, 0.0).w).xyz;
          }
          vec3 _1756 = _1759;
          _1630 += (textureLod(sampler2D(_1524, _1042), vec4((_1750 * 0.5) + vec2(0.5), 0.0, 0.0).xy, vec4((_1750 * 0.5) + vec2(0.5), 0.0, 0.0).w).xyz * _1756);
          _1631 += (textureLod(sampler2D(_1471, _1042), vec4((_1750 * 0.5) + vec2(0.5), 0.0, 0.0).xy, vec4((_1750 * 0.5) + vec2(0.5), 0.0, 0.0).w).xyz * _1756);
          _1632 += _1756;
        }
        _1032 = _1630 / _1632;
        _1457 = _1631 / _1632;
      } else {
        if (_1377 != 0.0) {
          vec2 _1839 = _1025 * _1377;
          SPIRV_CROSS_BRANCH
          if (_1397 > 0.0) {
            _1457.x = textureLod(sampler2D(_1471, _1042), vec4(_1033 - _1839, 0.0, 0.0).xy, vec4(_1033 - _1839, 0.0, 0.0).w).x;
            _1457.y = textureLod(sampler2D(_1471, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).y;
            _1457.z = textureLod(sampler2D(_1471, _1042), vec4(_1033 + _1839, 0.0, 0.0).xy, vec4(_1033 + _1839, 0.0, 0.0).w).z;
          }
          SPIRV_CROSS_BRANCH
          if (_1397 < 1.0) {
            _1032.x = textureLod(sampler2D(_1524, _1042), vec4(_1033 - _1839, 0.0, 0.0).xy, vec4(_1033 - _1839, 0.0, 0.0).w).x;
            _1032.y = textureLod(sampler2D(_1524, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).y;
            _1032.z = textureLod(sampler2D(_1524, _1042), vec4(_1033 + _1839, 0.0, 0.0).xy, vec4(_1033 + _1839, 0.0, 0.0).w).z;
          }
        } else {
          SPIRV_CROSS_BRANCH
          if (_1397 > 0.0) {
            _1457 = textureLod(sampler2D(_1471, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).xyz;
          }
          SPIRV_CROSS_BRANCH
          if (_1397 < 1.0) {
            _1032 = textureLod(sampler2D(_1524, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).xyz;
          }
        }
      }
    }
    _1032 = mix(_1032, _1457, vec3(_1397));
    // Additive post-process layers before color grading.
    vec3 _2007 = textureLod(sampler2D(_2008, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xyz;
    _1032 += _2007;
    if (((_330._m110 & 32u) != 0u) == true) {
      vec3 _2035 = textureLod(sampler2D(_2036, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xyz;
      _1032 += _2035;
    }
    SPIRV_CROSS_BRANCH
    if ((_1064 & 16u) != 0u) {
      // Overlay/reticle-style compositing controlled by _1064 bit 16.
      vec4 _2060 = textureLod(sampler2D(_2061, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w);
      vec3 _2076 = _2060.xyz;
      vec3 _2079 = _162(_2076);
      _2060.x = _2079.x;
      _2060.y = _2079.y;
      _2060.z = _2079.z;
      _2060 *= _1035;
      _1032 = (_1032 * (1.0 - _2060.w)) + _2060.xyz;
    }
    SPIRV_CROSS_BRANCH
    if (_970._m7.x > 0.0) {
      // Masked full-screen overlay replacement.
      float _2102 = textureLod(sampler2D(_2103, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).x;
      SPIRV_CROSS_BRANCH
      if (_2102 > 0.0) {
        vec3 _2123 = textureLod(sampler2D(_2124, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xyz;
        _1032 = mix(_1032, _2123, vec3(_2102));
      }
    }
    bool _2149 = ((_330._m110 & 16u) != 0u) == true;
    bool _2157;
    if (_2149) {
      _2157 = _330._m91 > 0;
    } else {
      _2157 = _2149;
    }
    SPIRV_CROSS_BRANCH
    if (_2157) {
      // Cinematic/transition overlay and optional highlight flare.
      vec4 _2160 = textureLod(sampler2D(_2161, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w);
      float _2176 = textureLod(sampler2D(_2177, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).w;
      _1032 = mix(_1032, _2160.xyz, vec3(_2176));
      if (_970._m21 > 0.0) {
        vec3 _2205 = vec3(0.0);
        float _2206 = 0.0;
        uint _2213 = _330._m109;
        uint _2216 = 4636u;
        float _2207 = textureLod(sampler2D(_2210[_142(_2213, _2216)], _2220), vec4(_963 * float(_330._m36), 0.0, 0.0).xy, vec4(_963 * float(_330._m36), 0.0, 0.0).w).x;
        float _2245 = _166(_970._m20 / _970._m21);
        if (_330._m108 == 1u) {
          float _2259 = _2245 * 1.0;
          if (false) {
            _2259 = trunc(_2259 / 0.0) * 0.0;
          }
          vec2 _2269 = vec2((_963.x - _2259) / 0.0199999995529651641845703125, 0.0);
          float _2277 = pow(_2176, 0.20000000298023223876953125) + 1.0;
          float _2288 = 1.0 - pow(dot(_2269, _2269), 0.00999999977648258209228515625);
          float _2281 = _10(_2288);
          _2205 = ((vec3(_2281) * _2207) * _330._m34.xyz) * _2277;
          vec2 _2301 = vec2(_963.x - _2259, 0.0);
          _2206 = float(_963.x < _2259);
        } else {
          if (_330._m108 == 2u) {
            uint _2321 = _330._m107;
            uint _2324 = 4655u;
            float _2318 = textureLod(sampler2D(_2210[_142(_2321, _2324)], _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).w;
            float _2342 = step(_2245, _2318);
            float _2346 = pow(_2176, 0.20000000298023223876953125) + 1.0;
            _2205 = ((vec3(_2342) * _2207) * _330._m34.xyz) * _2346;
            float _2360 = _2342;
            _2206 = 1.0 - _10(_2360);
          } else {
            if (_330._m108 == 3u) {
              uint _2372 = _330._m107;
              uint _2375 = 4661u;
              float _2370 = textureLod(sampler2D(_2210[_142(_2372, _2375)], _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).w;
              float _2393 = smoothstep(_2245, 1.0, _2370 + 0.100000001490116119384765625);
              float _2398 = pow(_2176, 0.20000000298023223876953125) + 1.0;
              _2205 = ((vec3(_2393) * _2207) * _330._m34.xyz) * _2398;
              float _2414 = _2393 * 2.0;
              _2206 = 1.0 - _10(_2414);
            } else {
              if (_330._m108 == 4u) {
                uint _2426 = _330._m107;
                uint _2429 = 4667u;
                float _2424 = textureLod(sampler2D(_2210[_142(_2426, _2429)], _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).w;
                float _2447 = smoothstep(_2245, _2424 + 1.0, 1.0);
                float _2452 = pow(_2176, 0.20000000298023223876953125) + 1.0;
                _2205 = ((vec3(_2447) * _2207) * _330._m34.xyz) * _2452;
                float _2466 = _2447;
                _2206 = 1.0 - _10(_2466);
              }
            }
          }
        }
        _1032 += (((_2205 * 1000.0) * float(_330._m35)) * _2176);
      }
    }
    vec4 _2482 = _970._m5;
    float _2494;
    if (((_330._m110 & 8u) != 0u) == false) {
      // Exposure/scene scale lookup, overridden by _970._m5.w when non-zero.
      _2494 = textureLod(sampler2D(_2495, _1042), vec2(0.5), 0.0).x;
      float _2501 = _2482.w;
      _2494 = (_2501 != 0.0) ? _2501 : _2494;
    }
    // Main scene/detail buffers and vignette/texture modulation before grading.
    vec3 _2509 = textureLod(sampler2D(_2510, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).xyz;
    vec3 _2526 = textureLod(sampler2D(_2527, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).xyz;
    vec3 _2543 = textureLod(sampler2D(_2544, _2220), vec4((_963 * 1.39999997615814208984375) * vec2(1.0, _1022), 0.0, 0.0).xy, vec4((_963 * 1.39999997615814208984375) * vec2(1.0, _1022), 0.0, 0.0).w).xyz;
    _1032 += ((_2509 * _2543) * _2482.z);
    _1032 += (_2526 * mix(vec3(1.0), _2543, vec3(_970._m11)));
    _1032 = mix(_1032, _2509, vec3(_2482.x));
    vec3 _2594 = _1032;
    float _2593 = _85(_2594);
    if (((_330._m110 & 8u) != 0u) == false) {
      _1032 *= _2494;
    } else {
      float _2608 = _330._m86;
      _1032 *= (1.0 / _2608);
    }
    SPIRV_CROSS_BRANCH
    if (((_330._m110 & 64u) != 0u) == true) {
      // Debug/alternate scene override.
      _1032 = textureLod(sampler2D(_2623, _1042), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).xyz;
    }
    SPIRV_CROSS_BRANCH
    if (((_970._m22 & 8u) != 0u) == true) {
      // Optional ACEScc 3D color-grade LUT path (_2764), not the main TM LUT.
      vec3 _2660 = _1032;
      mat3 _2662 = mat3(vec3(0.412390887737274169921875, 0.357584297657012939453125, 0.18048083782196044921875), vec3(0.2126390635967254638671875, 0.71516859531402587890625, 0.072192333638668060302734375), vec3(0.01933082006871700286865234375, 0.119194723665714263916015625, 0.95053231716156005859375));
      vec3 _2677 = _67(_2660, _2662);
      mat3 _2678 = mat3(vec3(1.01303005218505859375, 0.0061053098179399967193603515625, -0.014971000142395496368408203125), vec3(0.0076982299797236919403076171875, 0.99816501140594482421875, -0.005032029934227466583251953125), vec3(-0.0028413101099431514739990234375, 0.0046851597726345062255859375, 0.92450702190399169921875));
      vec3 _2693 = _67(_2677, _2678);
      mat3 _2694 = mat3(vec3(1.64102351665496826171875, -0.32480335235595703125, -0.2364247143268585205078125), vec3(-0.663663089275360107421875, 1.6153318881988525390625, 0.01675635017454624176025390625), vec3(0.011721909977495670318603515625, -0.00828444026410579681396484375, 0.988394916057586669921875));
      vec3 _2646 = _67(_2693, _2694);
      float _2697 = _2646.x;
      float _2701 = _2646.y;
      float _2705 = _2646.z;
      vec3 _2696 = vec3(_148(_2697), _148(_2701), _148(_2705));
      if (_970._m2.w < 0.0) {
        float _2719 = _2696.x;
        float _2722 = _2696.y;
        float _2725 = _2696.z;
        vec3 _2733 = _2696 + vec3((-_970._m2.w) * (1.0 - _43(_2719, _2722, _2725)));
        _2696 = _16(_2733);
      }
      f16vec3 _2737 = f16vec3(float16_t(0.0));
      SPIRV_CROSS_UNROLL
      for (int _2740 = 0; _2740 < 2; _2740++) {
        float _2748 = (-0.007575757801532745361328125) + (float(_2740) * 0.01515151560306549072265625);
        vec3 _2760 = _2696 + vec3(_2748);
        vec3 _2755 = _16(_2760);
        _2737 += f16vec3(textureLod(sampler3D(_2764, _1042), vec4(_2755, 0.0).xyz, vec4(_2755, 0.0).w).xyz);
      }
      _1032 = vec3(_2737) * 0.5;
      float _2791 = _1032.x;
      float _2795 = _1032.y;
      float _2799 = _1032.z;
      _1032 = vec3(_145(_2791), _145(_2795), _145(_2799));
      vec3 _2817 = _1032;
      mat3 _2819 = mat3(vec3(0.662454128265380859375, 0.1340042054653167724609375, 0.1561876833438873291015625), vec3(0.272228717803955078125, 0.67408168315887451171875, 0.0536895208060741424560546875), vec3(-0.0055746599100530147552490234375, 0.0040607298724353313446044921875, 1.0103390216827392578125));
      vec3 _2834 = _67(_2817, _2819);
      mat3 _2835 = mat3(vec3(0.987228810787200927734375, -0.00611330009996891021728515625, 0.0159534104168415069580078125), vec3(-0.007598400115966796875, 1.00185978412628173828125, 0.0053300000727176666259765625), vec3(0.00307258008979260921478271484375, -0.0050959200598299503326416015625, 1.0816795825958251953125));
      vec3 _2850 = _67(_2834, _2835);
      mat3 _2851 = mat3(vec3(3.2409694194793701171875, -1.53738296031951904296875, -0.4986107647418975830078125), vec3(-0.96924388408660888671875, 1.87596786022186279296875, 0.041555099189281463623046875), vec3(0.055630020797252655029296875, -0.2039768397808074951171875, 1.0569713115692138671875));
      _1032 = _67(_2850, _2851);
    }
    if ((_330._m110 & 512u) != 0u) {
      // Vignette/shape darkening or tint region.
      vec2 _2872 = _1025;
      vec2 _2874 = vec2(_330._m105, _330._m106) * _330._m102;
      float _2875 = _137(_2872, _2874);
      float _2882 = smoothstep(-1.0, 1.0, _2875 * (1.0 / _330._m104));
      float _2860 = _10(_2882);
      vec3 _2884 = _1032 * vec3(_330._m33.x * _330._m103, _330._m33.y * _330._m103, _330._m33.z * _330._m103);
      _1032 = mix(_1032, _2884, vec3(_2860));
    }
    uint _2910 = _970._m8;
    SPIRV_CROSS_BRANCH
    if ((_2910 & 3u) != 0u) {
      // Pixel marker/debug/compositing block.
      ivec2 _2918 = ivec2(_956.x >> 1, _956.y);
      uint _2925 = uint(imageLoad(_2928, _2918).x * 255.0);
      uint _2935 = (_2925 >> uint((_956.x & 1) * 4)) & 15u;
      uint _2943 = _2935 & 7u;
      bool _2947 = ((_2910 >> uint(0)) & 1u) != 0u;
      bool _2952 = ((_2910 >> uint(1)) & 1u) != 0u;
      SPIRV_CROSS_BRANCH
      if (_2952 && (_2943 == 0u)) {
        vec4 _2963 = textureLod(sampler2D(_2964, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w);
        _1032 = (_1032 * (1.0 - _2963.w)) + _2963.xyz;
      }
      if ((_2943 >= 1u) && (_2943 <= 4u)) {
        _1032 = _2997._m0[_2943 - 1u].xyz;
      }
      bool _3003 = (_2935 & 8u) != 0u;
      _1032 = mix(_1032, _970._m1.xyz, vec3(float(_3003) * _970._m1.w));
    }
    SPIRV_CROSS_BRANCH
    if (_330._m9.w > 0.0) {
      // World/screen-space orange highlight effect.
      float _3023 = 1.0 - textureLod(sampler2D(_3024, _3026), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).x;
      float _3044 = _3023;
      bool _3046 = false;
      vec3 _3042 = _101(_1033, _92(_3044, _3046));
      vec3 _3049 = vec3(subgroupShuffleXor(_3042.x, 1u), subgroupShuffleXor(_3042.y, 1u), subgroupShuffleXor(_3042.z, 1u));
      vec3 _3060 = vec3(subgroupShuffleXor(_3042.x, 8u), subgroupShuffleXor(_3042.y, 8u), subgroupShuffleXor(_3042.z, 8u));
      vec3 _3071 = _3049 - _3042;
      vec3 _3075 = _3060 - _3042;
      vec3 _3079 = _3042 + vec3(_330._m62, _330._m63, _330._m64);
      vec3 _3092 = _3079;
      vec3 _3094 = sqrt((_3071 * _3071) + (_3075 * _3075));
      vec3 _3103 = max(vec3(0.0), ((vec3(1.0) / _3094) - vec3(8.0)) * 1.2000000476837158203125);
      vec3 _3112 = fract(_3092 / vec3(0.25));
      vec3 _3118 = (vec3(0.039999999105930328369140625) - abs(_3112 - vec3(0.5))) * 0.25;
      vec3 _3133 = vec3(0.5) + (_3103 * _3118);
      vec3 _3127 = _16(_3133);
      vec3 _3135 = normalize(cross(_3071, _3075));
      vec3 _3140 = sqrt(vec3(1.0) - (_3135 * _3135));
      _3140 = max(vec3(0.0), (_3140 - vec3(0.20000000298023223876953125)) / vec3(0.800000011920928955078125));
      _3127 *= _3140;
      float _3158 = _3127.x;
      float _3161 = _3127.y;
      float _3164 = _3127.z;
      float _3157 = _38(_3158, _3161, _3164);
      vec3 _3168 = _330._m9.xyz;
      float _3172 = length(_3079 - _3168);
      float _3177 = _330._m9.w;
      float _3180 = _3172 - _3177;
      float _3189 = (-_3180) / 5.0;
      float _3184 = _10(_3189);
      _3157 = 1.0 - (_3184 * (1.0 - _3157));
      float _3206 = 1.0 + min((_3180 + 5.0) / 20.0, (-_3180) / 0.100000001490116119384765625);
      float _3196 = _10(_3206);
      _3157 *= (_3196 * _3196);
      float _3213 = length(_3042);
      float _3219 = (_3213 - 1.0) / 4.0;
      _3157 *= _10(_3219);
      float _3228 = (5000.0 - _3172) / 4000.0;
      _3157 *= _10(_3228);
      _1032 = mix(_1032, vec3(1.0, 0.319999992847442626953125, 0.0), vec3(_3157));
    }
    SPIRV_CROSS_BRANCH
    if (_970._m3.w != 0.0) {
      // Animated texture/noise blend.
      float _3244 = fract(_330._m98);
      float _3248 = fract(_330._m98 + 0.5);
      float _3253 = abs(1.0 - (_3244 / 0.5));
      vec2 _3258 = textureLod(sampler2D(_3259, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xy;
      _3258 = (_3258 * 2.0) - vec2(1.0);
      float _3279 = textureLod(sampler2D(_3259, _1042), vec4(_963 + (_3258 * _3244), 0.0, 0.0).xy, vec4(_963 + (_3258 * _3244), 0.0, 0.0).w).z;
      float _3303 = textureLod(sampler2D(_3259, _1042), vec4(_963 + (_3258 * _3248), 0.0, 0.0).xy, vec4(_963 + (_3258 * _3248), 0.0, 0.0).w).z;
      float _3329 = _3253;
      _3253 = mix(_3279, _3303, _10(_3329));
      vec3 _3333 = vec3(_3253);
      _3333 *= _970._m3.xyz;
      float _3343 = _970._m3.w;
      _1032 = mix(_1032, _3333, vec3(_10(_3343)));
    }
    vec4 _3349 = vec4(0.0);
    vec4 _3351 = vec4(0.0);
    SPIRV_CROSS_BRANCH
    if (_970._m17 > 0) {
      // Rounded frame/border overlays; fills _3349 and _3351 for later blending.
      vec2 _3358 = abs((_963 * 2.0) - vec2(1.0));
      _3358.x = max(0.0, 1.0 - ((1.0 - _3358.x) / _1022));
      vec2 _3372 = (floor(_3358 / vec2(0.0416666679084300994873046875)) + vec2(0.5)) * 0.0416666679084300994873046875;
      _3349 = vec4(0.0);
      _3351 = vec4(0.0);
      SPIRV_CROSS_UNROLL
      for (int _3381 = 0; _3381 < 4; _3381++) {
        vec4 _3389 = _3393._m0[_3381];
        float _3398 = _3389.x;
        uint _3397 = _32(_3398);
        SPIRV_CROSS_FLATTEN
        if (_3397 == 0u) {
          break;
        }
        float _3407 = _3389.y;
        float _3410 = _3389.z;
        float _3413 = _3389.w;
        float _3416 = pow(pow(_3358.x, _3407) + pow(_3358.y * _3413, _3407), 1.0 / _3407);
        uint _3432 = _3397;
        vec4 _3431 = _81(_3432);
        vec3 _3435 = _3431.xyz;
        vec3 _3438 = _49(_3435);
        _3431.x = _3438.x;
        _3431.y = _3438.y;
        _3431.z = _3438.z;
        float _3445 = min(1.0, _3416 * 5.0);
        _3431.w *= _3445;
        float _3457 = 2.0 - _3407;
        float _3454 = 1.0 + (_10(_3457) * 0.4142135679721832275390625);
        float _3462 = (_3416 - _3410) / _3454;
        float _3468 = max(0.0, 1.0 - max(_3462 / 0.300000011920928955078125, (-_3462) / 0.4000000059604644775390625));
        _3468 *= _3468;
        _3468 *= _3468;
        _3468 *= 0.5;
        float _3492 = 1.2000000476837158203125 - (abs(_3462) * 50.0);
        float _3486 = _10(_3492);
        float _3494 = (_3468 + _3486) * _3431.w;
        _3351.w = ((1.0 - _3494) * _3351.w) + _3494;
        vec4 _3511 = _3351;
        vec3 _3518 = (_3511.xyz * (1.0 - _3494)) + (_3431.xyz * _3494);
        _3351.x = _3518.x;
        _3351.y = _3518.y;
        _3351.z = _3518.z;
        float _3525 = pow(pow(_3372.x, _3407) + pow(_3372.y * _3413, _3407), 1.0 / _3407);
        float _3540 = (_3525 - _3410) / _3454;
        float _3546 = max(0.0, 1.0 - (abs(_3540) / 0.054999999701976776123046875)) * _3431.w;
        vec4 _3559 = _3351;
        vec3 _3561 = _3559.xyz + (_3431.xyz * _3546);
        _3351.x = _3561.x;
        _3351.y = _3561.y;
        _3351.z = _3561.z;
        float _3568 = 0.60000002384185791015625 + (max(0.0, _3407 - 8.0) * 0.25);
        float _3575 = max(0.0, 1.0 - max(_3462 / 0.0199999995529651641845703125, (-_3462) / _3568));
        _3575 *= _3575;
        _3575 *= _3575;
        float _3591 = _3575 * _3431.w;
        _3349.w = ((1.0 - _3591) * _3349.w) + _3591;
        vec4 _3606 = _3349;
        vec3 _3613 = (_3606.xyz * (1.0 - _3591)) + (_3431.xyz * _3591);
        _3349.x = _3613.x;
        _3349.y = _3613.y;
        _3349.z = _3613.z;
      }
    }
    vec4 _3622 = _330._m26;
    vec4 _3626 = _330._m24;
    vec4 _3630 = _330._m25;
    SPIRV_CROSS_BRANCH
    if (_3622.w != 0.0) {
      // User/post overlay layer 1.
      float _3639 = _3626.z;
      float _3642 = _3626.w;
      vec2 _3645 = _3630.xy;
      vec4 _3717;
      SPIRV_CROSS_BRANCH
      if (_3642 != 0.0) {
        float _3652 = fract(_330._m98 / _3639);
        float _3658 = fract(0.5 + (_330._m98 / _3639));
        float _3665 = abs(1.0 - (2.0 * _3652));
        vec3 _3670 = textureLod(sampler2D(_3671, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xyw;
        vec2 _3687 = ((_3670.xy * 2.0) - vec2(1.0)) * (_3642 * _3670.z);
        _3687.x *= _1022;
        vec2 _3703 = _963 - (_3687 * (_3652 - 0.5));
        vec2 _3710 = _963 - (_3687 * (_3658 - 0.5));
        _3717 = mix(textureLod(sampler2D(_3718, _3720), vec4(_3703 * _3645, 0.0, 0.0).xy, vec4(_3703 * _3645, 0.0, 0.0).w), textureLod(sampler2D(_3718, _3720), vec4(_3710 * _3645, 0.0, 0.0).xy, vec4(_3710 * _3645, 0.0, 0.0).w), vec4(_3665));
      } else {
        _3717 = textureLod(sampler2D(_3718, _3720), vec4(_963 * _3645, 0.0, 0.0).xy, vec4(_963 * _3645, 0.0, 0.0).w);
      }
      float _3778 = float(_3630.w < 0.0);
      _3717 = mix(_3717, vec4(1.0, 1.0, 1.0, _3717.x), vec4(_3778));
      _3717.w *= min(1.0, _3626.x * pow(2.0 * _1029, _3626.y));
      _3717.w *= abs(_3622.w);
      vec4 _3812 = _3717;
      vec3 _3814 = _3812.xyz * _3622.xyz;
      _3717.x = _3814.x;
      _3717.y = _3814.y;
      _3717.z = _3814.z;
      float _3821 = abs(_3630.w);
      vec4 _3826 = _3717;
      vec3 _3828 = _3826.xyz * _3821;
      _3717.x = _3828.x;
      _3717.y = _3828.y;
      _3717.z = _3828.z;
      vec3 _3835 = _3717.xyz * _3717.w;
      bool _3841 = _3630.z != 0.0;
      SPIRV_CROSS_BRANCH
      if (_3841) {
        _3717.w *= _3349.w;
        _3835 *= _3349.xyz;
      }
      float _3858 = 1.0 - (float(_3622.w > 0.0) * _3717.w);
      _1032 = (_1032 * _3858) + _3835;
    }
    _3622 = _330._m29;
    _3626 = _330._m27;
    _3630 = _330._m28;
    SPIRV_CROSS_BRANCH
    if (_3622.w != 0.0) {
      // User/post overlay layer 2.
      float _3886 = _3626.z;
      float _3889 = _3626.w;
      vec2 _3892 = _3630.xy;
      vec4 _3964;
      SPIRV_CROSS_BRANCH
      if (_3889 != 0.0) {
        float _3899 = fract(_330._m98 / _3886);
        float _3905 = fract(0.5 + (_330._m98 / _3886));
        float _3912 = abs(1.0 - (2.0 * _3899));
        vec3 _3917 = textureLod(sampler2D(_3918, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xyw;
        vec2 _3934 = ((_3917.xy * 2.0) - vec2(1.0)) * (_3889 * _3917.z);
        _3934.x *= _1022;
        vec2 _3950 = _963 - (_3934 * (_3899 - 0.5));
        vec2 _3957 = _963 - (_3934 * (_3905 - 0.5));
        _3964 = mix(textureLod(sampler2D(_3965, _3967), vec4(_3950 * _3892, 0.0, 0.0).xy, vec4(_3950 * _3892, 0.0, 0.0).w), textureLod(sampler2D(_3965, _3967), vec4(_3957 * _3892, 0.0, 0.0).xy, vec4(_3957 * _3892, 0.0, 0.0).w), vec4(_3912));
      } else {
        _3964 = textureLod(sampler2D(_3965, _3967), vec4(_963 * _3892, 0.0, 0.0).xy, vec4(_963 * _3892, 0.0, 0.0).w);
      }
      float _4025 = float(_3630.w < 0.0);
      _3964 = mix(_3964, vec4(1.0, 1.0, 1.0, _3964.x), vec4(_4025));
      _3964.w *= min(1.0, _3626.x * pow(2.0 * _1029, _3626.y));
      _3964.w *= abs(_3622.w);
      vec4 _4059 = _3964;
      vec3 _4061 = _4059.xyz * _3622.xyz;
      _3964.x = _4061.x;
      _3964.y = _4061.y;
      _3964.z = _4061.z;
      float _4068 = abs(_3630.w);
      vec4 _4073 = _3964;
      vec3 _4075 = _4073.xyz * _4068;
      _3964.x = _4075.x;
      _3964.y = _4075.y;
      _3964.z = _4075.z;
      vec3 _4082 = _3964.xyz * _3964.w;
      bool _4088 = _3630.z != 0.0;
      SPIRV_CROSS_BRANCH
      if (_4088) {
        _3964.w *= _3349.w;
        _4082 *= _3349.xyz;
      }
      float _4105 = 1.0 - (float(_3622.w > 0.0) * _3964.w);
      _1032 = (_1032 * _4105) + _4082;
    }
    _3622 = _330._m32;
    _3626 = _330._m30;
    _3630 = _330._m31;
    SPIRV_CROSS_BRANCH
    if (_3622.w != 0.0) {
      // User/post overlay layer 3.
      float _4133 = _3626.z;
      float _4136 = _3626.w;
      vec2 _4139 = _3630.xy;
      vec4 _4211;
      SPIRV_CROSS_BRANCH
      if (_4136 != 0.0) {
        float _4146 = fract(_330._m98 / _4133);
        float _4152 = fract(0.5 + (_330._m98 / _4133));
        float _4159 = abs(1.0 - (2.0 * _4146));
        vec3 _4164 = textureLod(sampler2D(_4165, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w).xyw;
        vec2 _4181 = ((_4164.xy * 2.0) - vec2(1.0)) * (_4136 * _4164.z);
        _4181.x *= _1022;
        vec2 _4197 = _963 - (_4181 * (_4146 - 0.5));
        vec2 _4204 = _963 - (_4181 * (_4152 - 0.5));
        _4211 = mix(textureLod(sampler2D(_4212, _4214), vec4(_4197 * _4139, 0.0, 0.0).xy, vec4(_4197 * _4139, 0.0, 0.0).w), textureLod(sampler2D(_4212, _4214), vec4(_4204 * _4139, 0.0, 0.0).xy, vec4(_4204 * _4139, 0.0, 0.0).w), vec4(_4159));
      } else {
        _4211 = textureLod(sampler2D(_4212, _4214), vec4(_963 * _4139, 0.0, 0.0).xy, vec4(_963 * _4139, 0.0, 0.0).w);
      }
      float _4272 = float(_3630.w < 0.0);
      _4211 = mix(_4211, vec4(1.0, 1.0, 1.0, _4211.x), vec4(_4272));
      _4211.w *= min(1.0, _3626.x * pow(2.0 * _1029, _3626.y));
      _4211.w *= abs(_3622.w);
      vec4 _4306 = _4211;
      vec3 _4308 = _4306.xyz * _3622.xyz;
      _4211.x = _4308.x;
      _4211.y = _4308.y;
      _4211.z = _4308.z;
      float _4315 = abs(_3630.w);
      vec4 _4320 = _4211;
      vec3 _4322 = _4320.xyz * _4315;
      _4211.x = _4322.x;
      _4211.y = _4322.y;
      _4211.z = _4322.z;
      vec3 _4329 = _4211.xyz * _4211.w;
      bool _4335 = _3630.z != 0.0;
      SPIRV_CROSS_BRANCH
      if (_4335) {
        _4211.w *= _3349.w;
        _4329 *= _3349.xyz;
      }
      float _4352 = 1.0 - (float(_3622.w > 0.0) * _4211.w);
      _1032 = (_1032 * _4352) + _4329;
    }
    _1032 = (_1032 * (1.0 - _3351.w)) + _3351.xyz;
    int _4374 = _970._m18;
    SPIRV_CROSS_LOOP
    for (int _4378 = 0; _4378 < _4374; _4378++) {
      // Extra radial tint overlays.
      vec4 _4387 = _4391._m0[_4378];
      float _4403 = pow(_1029, _4387.z) * _4387.y;
      float _4395 = _10(_4403);
      float _4406 = _4387.x;
      uint _4410 = _32(_4406);
      vec3 _4405 = _81(_4410).xyz;
      vec3 _4414 = _4405;
      vec3 _4413 = _49(_4414);
      _1032 = mix(_1032, _4413, vec3(_4395));
    }
    SPIRV_CROSS_BRANCH
    if (_330._m54 > 0.0) {
      // Blood/damage/noise tint overlay.
      vec4 _4430 = textureLod(sampler2D(_4431, _1042), vec4((_963 * vec2(1.2999999523162841796875)) + (floor(vec2(_330._m98 * 15.0, _330._m98 * 20.0)) * 0.300000011920928955078125), 0.0, 0.0).xy, vec4((_963 * vec2(1.2999999523162841796875)) + (floor(vec2(_330._m98 * 15.0, _330._m98 * 20.0)) * 0.300000011920928955078125), 0.0, 0.0).w);
      float _4474 = _330._m54;
      _1032 = mix(_1032, _4430.xyz, vec3(_10(_4474))) * vec3(1.0, 0.20000000298023223876953125, 0.100000001490116119384765625);
    }
    SPIRV_CROSS_BRANCH
    if (_970._m2.w > 0.0) {
      // Global color fade/tint.
      _1032 = (_1032 * (1.0 - _970._m2.w)) + _970._m2.xyz;
    }
    if (_330._m80 > 0.0) {
      // Green debug/threshold marker.
      float _4502 = 1.0 - textureLod(sampler2D(_3024, _3026), vec4(_1033, 0.0, 0.0).xy, vec4(_1033, 0.0, 0.0).w).x;
      float _4520 = _4502;
      bool _4522 = false;
      float _4519 = _92(_4520, _4522);
      if (_4519 > _330._m80) {
        _1032 = vec3(0.0, 1.0, 0.0);
      }
    }
    int _4531 = 0;
    _4531 = int(_4535._m0[0]);
    SPIRV_CROSS_UNROLL
    for (int _4540 = 0; _4540 < 3; _4540++) {
      // Optional per-channel matrix color corrections masked by _4555.
      if (_4540 < _4531) {
        float _4553 = 0.0;
        vec4 _4554 = textureLod(sampler2D(_4555, _1042), vec4(_963, 0.0, 0.0).xy, vec4(_963, 0.0, 0.0).w);
        switch (_4540) {
          case 0: {
            _4553 = _4554.x;
            break;
          }
          case 1: {
            _4553 = _4554.y;
            break;
          }
          case 2: {
            _4553 = _4554.z;
            break;
          }
          default: {
            _4553 = 0.0;
            break;
          }
        }
        uint _4587 = uint(1 + (_4540 * 18));
        mat3 _4592 = mat3(vec3(_4535._m0[_4587 + 9u], _4535._m0[_4587 + 10u], _4535._m0[_4587 + 11u]), vec3(_4535._m0[_4587 + 12u], _4535._m0[_4587 + 13u], _4535._m0[_4587 + 14u]), vec3(_4535._m0[_4587 + 15u], _4535._m0[_4587 + 16u], _4535._m0[_4587 + 17u]));
        mat3 _4641 = _4592;
        vec3 _4643 = _1032;
        vec3 _4640 = _62(_4641, _4643);
        _1032 = mix(_1032, _4640, vec3(_4553));
      }
    }
    _1032 = max(_1032, vec3(0.0));
    vec3 _4655 = _1032;
    SPIRV_CROSS_BRANCH
    if (_970._m6.x > 0.0) {
      float _4663 = _970._m15;
      float _4667 = _970._m14;

      // accessibility contrast slider, centered around 0.5
      float _4670 = mix(0.95, 1.05, _970._m13);
      float _4677 = mix(1.0, 3.0, _970._m12);
      _4655 = max(vec3(0.0), mix(vec3(0.5), _4655, vec3(_4670))) * _4677;

      vec3 _4690 = vec3(0.0);
      vec3 _4714;
      vec3 _4727;
      SPIRV_CROSS_BRANCH
      if (_970._m6.x == 1.0) {
        mat3 _4710 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875),
                          vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625),
                          vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
        vec3 _4711 = _4655;
        vec3 _4696 = _62(_4710, _4711);
        _4714.x = dot(_4696, vec3(0.0, 1.0511829853057861328125, -0.051160991191864013671875));
        _4714.y = _4696.y;
        _4714.z = _4696.z;
        mat3 _4741 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875),
                          vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875),
                          vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
        vec3 _4742 = _4714;
        _4727 = _62(_4741, _4742);
        vec3 _4745 = _4655 - _4727;
        _4690.x = 0.0;
        _4690.y = (_4745.x * _4663) + _4745.y;
        _4690.z = (_4745.x * _4663) + _4745.z;
      } else {
        SPIRV_CROSS_BRANCH
        if (_970._m6.x == 2.0) {
          mat3 _4773 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875),
                            vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625),
                            vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
          vec3 _4774 = _4655;
          vec3 _4772 = _62(_4773, _4774);
          _4714.x = _4772.x;
          _4714.y = dot(_4772, vec3(0.9513092041015625, 0.0, 0.04866991937160491943359375));
          _4714.z = _4772.z;
          mat3 _4789 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875),
                            vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875),
                            vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
          vec3 _4790 = _4714;
          _4727 = _62(_4789, _4790);
          vec3 _4793 = _4655 - _4727;
          _4690.x = (_4793.y * _4663) + _4793.x;
          _4690.y = 0.0;
          _4690.z = (_4793.y * _4663) + _4793.z;
        } else {
          SPIRV_CROSS_BRANCH
          if (_970._m6.x == 3.0) {
            mat3 _4821 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875),
                              vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625),
                              vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
            vec3 _4822 = _4655;
            vec3 _4820 = _62(_4821, _4822);
            _4714.x = _4820.x;
            _4714.y = _4820.y;
            _4714.z = dot(_4820, vec3(-0.867447376251220703125, 1.867270946502685546875, 0.0));
            mat3 _4837 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875),
                              vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875),
                              vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
            vec3 _4838 = _4714;
            _4727 = _62(_4837, _4838);
            vec3 _4841 = _4655 - _4727;
            _4690.x = (_4841.z * _4663) + _4841.x;
            _4690.y = (_4841.z * _4663) + _4841.y;
            _4690.z = 0.0;
          }
        }
      }
      vec3 _4862 = max(vec3(0.0), _4655 + _4690);
      _1032 = mix(_4655, _4862, vec3(_4667));
    }
    if ((_1064 & 1u) != 0u) {
      // Alternate grade path with a small contrast-like adjustment around grey.
      float _4877 = _4881._m0[_330._m55 % 3u];
      _4877 /= _330._m86;
      float _4892 = (((_970._m22 & 2u) != 0u) == true) ? _4877 : 0.5;
      _1032 = max(vec3(0.0), mix(vec3(_4892), _1032, vec3(mix(0.9700000286102294921875, 1.0299999713897705078125, _970._m16)))); // applies contrast slider
      if (((_330._m110 & 4u) != 0u) == true) {
        _1032 *= _330._m81;
      }
    }
    // Color gain/tint and saturation immediately before the main tonemap LUT.
    _1032 *= _330._m1.xyz;
    float _4929 = _330._m1.w;  // menu saturation slider
    if ((_1064 & 1u) != 0u) {
      _4929 *= _330._m85;
    }
    vec3 _4943 = _1032;
    float _4942 = _85(_4943);
    _1032 = mix(vec3(_4942), _1032, vec3(_4929));
    vec3 _4957 = _1032;
    float _4959 = float(_330._m100);
    vec3 _4952 = _159(_4957, _4959);
    // Main tonemap LUT sample (_4961). This path does not use the ACEScc encode/decode LUT above.
    _976 = textureLod(sampler3D(_4961, _1042), vec4(_4952, 0.0).xyz, vec4(_4952, 0.0).w).xyz;  // tonemap lut
    if ((_1064 & 1u) == 0u) {
      // SDR/output encoding branches after the main TM LUT.
      if (_330._m87 == 0u) {
        vec3 _4990 = _976;
        _976 = _55(_4990);
      } else {
        if (_330._m87 == 1u) {
          vec3 _5000 = _1032;
          float _4999 = _85(_5000);
          float _5003 = _330._m1.w;  // saturation
          _1032 = max(vec3(0.0), mix(vec3(_4999), _1032 * _330._m1.xyz, vec3(_5003)));
          float _5017 = 16.0;
          vec4 _5018;
          _5018.x = 0.87999999523162841796875;
          _5018.y = 0.300000011920928955078125;
          _5018.z = 0.00999999977648258209228515625;
          _5018.w = 0.0333333350718021392822265625;
          vec4 _5025 = vec4(0.02999999932944774627685546875, 0.00200000009499490261077880859375, 1.0 / ((((_5017 * ((_5018.x * _5017) + 0.02999999932944774627685546875)) + 0.00200000009499490261077880859375) / ((_5017 * ((_5018.x * _5017) + _5018.y)) + 0.0599999986588954925537109375)) - _5018.w), 0.0);
          float _5053 = _5018.x;
          float _5056 = _5018.y;
          float _5059 = _5018.z;
          _976 = (((_1032 * ((_1032 * _5053) + vec3(_5025.x))) + vec3(_5025.y)) / ((_1032 * ((_1032 * _5053) + vec3(_5056))) + vec3(0.0599999986588954925537109375))) - vec3(_5018.w);
          vec3 _5094 = _976 * _5025.z;
          _976 = _55(_5094);
        } else {
          vec3 _5097 = _1032;
          _976 = _55(_5097);
        }
      }
    } else {
      if (((_970._m22 & 4u) != 0u) == true) {
        // Optional BT.2020/PQ output transform.
        vec3 _5121 = _976;
        mat3 _5123 = mat3(vec3(1.66049087047576904296875, -0.5876410007476806640625, -0.072849936783313751220703125),
                          vec3(-0.124550573527812957763671875, 1.13290011882781982421875, -0.008349380455911159515380859375),
                          vec3(-0.018150769174098968505859375, -0.10057882964611053466796875, 1.11872923374176025390625));
        _976 = max(vec3(0.0), _67(_5121, _5123));
        vec3 _5126 = _976;
        _976 = _154(_5126);
      }
    }
    float _5129 = 0.5;
    if (((_330._m110 & 2u) != 0u) == false) {
      // Ordered/noise dithering before imageStore.
      uvec2 _5139 = uvec2(_956);
      uint _5140 = _330._m55;
      _5129 = _108(_5139, _5140) + 0.03125;
    }
    float _5147 = _976.x;
    uint _5153 = _32(_5147) & 4286578688u;
    float _5146 = _22(_5153);
    int _5156 = 1015021568;
    _5146 *= _28(_5156);
    _976.x += (_5129 * _5146);
    float _5167 = _976.x;
    uint _5173 = _32(_5167) & 4294836224u;
    _976.x = _22(_5173);
    float _5177 = _976.y;
    uint _5182 = _32(_5177) & 4286578688u;
    float _5176 = _22(_5182);
    int _5184 = 1015021568;
    _5176 *= _28(_5184);
    _976.y += (_5129 * _5176);
    float _5195 = _976.y;
    uint _5200 = _32(_5195) & 4294836224u;
    _976.y = _22(_5200);
    float _5204 = _976.z;
    uint _5209 = _32(_5204) & 4286578688u;
    float _5203 = _22(_5209);
    int _5212 = 1023410176;
    _5203 *= _28(_5212);
    _976.z += (_5129 * _5203);
    float _5223 = _976.z;
    uint _5229 = _32(_5223) & 4294705152u;
    _976.z = _22(_5229);
  }

  // float y_bt2020 = dot(_976, vec3(0.262700021266937255859375, 0.677999973297119140625, 0.0593000017106533050537109375));
  // _976 = mix(vec3(y_bt2020), _976, vec3(9.0));
  imageStore(_5234, _956, vec4(_976, 1.0));
}

