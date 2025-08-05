// color grading LUT

#version 450
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

struct _5224 {
  uint _m0;
  uint _m1;
};

struct _5331 {
  float _m0;
  float _m1;
};

struct _5332 {
  float _m0[6];
  float _m1[6];
  _5331 _m2;
  _5331 _m3;
  _5331 _m4;
  float _m5;
  float _m6;
};

layout(set = 0, binding = 0, std140) uniform _322_324 {
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
  float16_t _m31;
  float16_t _m32;
  float _m33;
  uint _m34;
  float _m35;
  float _m36;
  float _m37;
  float _m38;
  float _m39;
  float _m40;
  uint _m41;
  float _m42;
  float _m43;
  float _m44;
  float _m45;
  float _m46;
  float _m47;
  float _m48;
  float _m49;
  float _m50;
  uint _m51;
  uint _m52;
  float _m53;
  uint _m54;
  float _m55;
  float _m56;
  float _m57;
  float _m58;
  float _m59;
  float _m60;
  float _m61;
  float _m62;
  float _m63;
  float _m64;
  float _m65;
  float _m66;
  float _m67;
  float _m68;
  float _m69;
  float _m70;
  float _m71;
  float _m72;
  uint _m73;
  uint _m74;
  float _m75;
  float _m76;
  int _m77;
  float _m78;
  float _m79;
  float _m80;
  uint _m81;
  uint _m82;
  uint _m83;
  float _m84;
  uint _m85;
  int _m86;
  float _m87;
  float _m88;
  float _m89;
  float _m90;
  float _m91;
  float _m92;
  uint _m93;
  uint _m94;
  uint _m95;
  uint _m96;
}
_324;

layout(set = 1, binding = 0, std140) uniform _922_924 {
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
  int _m16;
  float _m17;
  float _m18;
  int _m19;
  int _m20;
  float _m21;
  float _m22;
  float _m23;
  uint _m24;
}
_924;

layout(set = 1, binding = 2, std140) uniform _2911_2913 {
  vec4 _m0[4];
}
_2913;

layout(set = 1, binding = 10, std140) uniform _3400_3402 {
  vec4 _m0[4];
}
_3402;

layout(set = 1, binding = 11, std140) uniform _4393_4395 {
  vec4 _m0[3];
}
_4395;

layout(set = 0, binding = 18, std430) restrict readonly buffer _4537_4539 {
  float _m0[];
}
_4539;

layout(set = 0, binding = 12, std430) restrict buffer _4884_4886 {
  float _m0[];
}
_4886;

layout(set = 0, binding = 6, std430) restrict readonly buffer _5226_5228 {
  _5224 _m0[];
}
_5228;

layout(set = 0, binding = 7, std140) uniform _5230_5232 {
  vec4 _m0[1024];
}
_5232;

layout(set = 0, binding = 9, std140) uniform _5234_5236 {
  vec4 _m0[64];
}
_5236;

layout(set = 0, binding = 8) uniform texture2D _987;
layout(set = 0, binding = 10) uniform sampler _991;
layout(set = 0, binding = 16) uniform texture2D _1126;
layout(set = 0, binding = 19) uniform texture2D _1357;
layout(set = 1, binding = 9) uniform texture2D _1421;
layout(set = 1, binding = 12) uniform texture2D _1474;
layout(set = 0, binding = 3) uniform texture2D _1662;
layout(set = 0, binding = 15) uniform sampler _1664;
layout(set = 0, binding = 4) uniform texture2D _1713;
layout(set = 1, binding = 8) uniform texture2D _1957;
layout(set = 0, binding = 29) uniform texture2D _1985;
layout(set = 1, binding = 13) uniform texture2D _2010;
layout(set = 1, binding = 15) uniform texture2D _2053;
layout(set = 1, binding = 16) uniform texture2D _2074;
layout(set = 1, binding = 17) uniform texture2D _2112;
layout(set = 0, binding = 33) uniform texture2D _2128;
layout(set = 2, binding = 0) uniform texture2D _2161[];
layout(set = 0, binding = 11) uniform sampler _2171;
layout(set = 0, binding = 30) uniform texture2D _2445;
layout(set = 0, binding = 2) uniform texture2D _2460;
layout(set = 1, binding = 3) uniform texture2D _2477;
layout(set = 0, binding = 1) uniform texture2D _2494;
layout(set = 0, binding = 5) uniform texture2D _2573;
layout(set = 1, binding = 4) uniform texture3D _2687;
layout(set = 1, binding = 14, r8) uniform readonly image2D _2844;
layout(set = 1, binding = 1) uniform texture2D _2880;
layout(set = 0, binding = 32) uniform texture2D _2941;
layout(set = 0, binding = 14) uniform sampler _2943;
layout(set = 1, binding = 7) uniform texture2D _3175;
layout(set = 0, binding = 22) uniform texture2D _3678;
layout(set = 0, binding = 20) uniform texture2D _3725;
layout(set = 0, binding = 21) uniform sampler _3727;
layout(set = 0, binding = 25) uniform texture2D _3923;
layout(set = 0, binding = 23) uniform texture2D _3970;
layout(set = 0, binding = 24) uniform sampler _3972;
layout(set = 0, binding = 28) uniform texture2D _4170;
layout(set = 0, binding = 26) uniform texture2D _4217;
layout(set = 0, binding = 27) uniform sampler _4219;
layout(set = 1, binding = 6) uniform texture2D _4435;
layout(set = 0, binding = 17) uniform texture2D _4559;
layout(set = 0, binding = 31) uniform texture3D _4965;
layout(set = 1, binding = 5, r11f_g11f_b10f) uniform writeonly image2D _5209;
layout(set = 2, binding = 1) uniform textureCube _5220[1];
layout(set = 2, binding = 2) uniform texture3D _5223[1];
layout(set = 0, binding = 13) uniform texture2D _5237;

uint _163;
uint _165;
uint _167;
int _170;
int _172;
int _174;
uint _5244;

float _111(float _110) {
  return 0.16666667163372039794921875 * ((_110 * ((_110 * ((-_110) + 3.0)) - 3.0)) + 1.0);
}

float _114(float _113) {
  return 0.16666667163372039794921875 * (((_113 * _113) * ((3.0 * _113) - 6.0)) + 4.0);
}

float _123(float _122) {
  float _475 = _122;
  float _478 = _122;
  return _111(_475) + _114(_478);
}

float _117(float _116) {
  return 0.16666667163372039794921875 * ((_116 * ((_116 * (((-3.0) * _116) + 3.0)) + 3.0)) + 1.0);
}

float _120(float _119) {
  return 0.16666667163372039794921875 * ((_119 * _119) * _119);
}

float _126(float _125) {
  float _484 = _125;
  float _487 = _125;
  return _117(_484) + _120(_487);
}

float _129(float _128) {
  float _494 = _128;
  float _497 = _128;
  float _500 = _128;
  return (-1.0) + (_114(_494) / (_111(_497) + _114(_500)));
}

float _132(float _131) {
  float _508 = _131;
  float _511 = _131;
  float _514 = _131;
  return 1.0 + (_120(_508) / (_117(_511) + _120(_514)));
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

vec3 _156(vec3 _155) {
  float _873 = 1.0 * _324._m72;
  float _881 = _155.x;
  float _884 = _155.y;
  float _887 = _155.z;
  return _155 * (_873 / (1.0 - (0.9900000095367431640625 * _38(_881, _884, _887))));
}

uint _142(uint _140, uint _141) {
  return _140;
}

float _160(float _159) {
  float _897 = clamp(_159, 0.0, 1.0);
  return ((3.0 - (2.0 * _897)) * _897) * _897;
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
  float _548 = (_136.y * _136.y) - (_136.x * _136.x);
  float _560 = (_136.x * _135.x) / _548;
  float _568 = _560 * _560;
  float _572 = (_136.y * _135.y) / _548;
  float _580 = _572 * _572;
  float _584 = ((_568 + _580) - 1.0) / 3.0;
  float _590 = (_584 * _584) * _584;
  float _596 = _590 + ((_568 * _580) * 2.0);
  float _604 = _590 + (_568 * _580);
  float _610 = _560 + (_560 * _580);
  float _656;
  if (_604 < 0.0) {
    float _620 = acos(_596 / _590) / 3.0;
    float _626 = cos(_620);
    float _629 = sin(_620) * 1.73205077648162841796875;
    float _634 = sqrt(((-_584) * ((_626 + _629) + 2.0)) + _568);
    float _645 = sqrt(((-_584) * ((_626 - _629) + 2.0)) + _568);
    _656 = (((_645 + (sign(_548) * _634)) + (abs(_610) / (_634 * _645))) - _560) / 2.0;
  } else {
    float _674 = ((2.0 * _560) * _572) * sqrt(_604);
    float _682 = sign(_596 + _674) * pow(abs(_596 + _674), 0.3333333432674407958984375);
    float _694 = sign(_596 - _674) * pow(abs(_596 - _674), 0.3333333432674407958984375);
    float _705 = (((-_682) - _694) - (_584 * 4.0)) + (2.0 * _568);
    float _716 = (_682 - _694) * 1.73205077648162841796875;
    float _721 = sqrt((_705 * _705) + (_716 * _716));
    _656 = (((_716 / sqrt(_721 - _705)) + ((2.0 * _610) / _721)) - _560) / 2.0;
  }
  vec2 _744 = _136 * vec2(_656, sqrt(1.0 - (_656 * _656)));
  return length(_744 - _135) * sign(_135.y - _744.y);
}

float _92(float _90, bool _91) {
  float _313 = 1.0 - _90;
  if (_91) {
    _313 -= (float(_313 > _324._m38) * _324._m37);
  }
  float _345 = _313;
  return vec2(_324._m64, _324._m65).y / (_10(_345) + vec2(_324._m64, _324._m65).x);
}

vec3 _96(vec2 _95) {
  return (vec3(_324._m42, _324._m43, _324._m44) + (_324._m3.xyz * _95.x)) + (_324._m4.xyz * _95.y);
}

vec3 _101(vec2 _99, float _100) {
  vec3 _385 = _96(_99);
  return _385 * _100;
}

uint _32(float _31) {
  return floatBitsToUint(_31);
}

vec4 _81(uint _80) {
  return unpackUnorm4x8(_80).wzyx;
}

float _46(float _45) {
  float _217;
  if (_45 <= 0.040449999272823333740234375) {
    _217 = _45 / 12.9200000762939453125;
  } else {
    _217 = pow((_45 / 1.05499994754791259765625) + 0.0521326996386051177978515625, 2.400000095367431640625);
  }
  return _217;
}

vec3 _49(vec3 _48) {
  float _234 = _48.x;
  float _239 = _48.y;
  float _244 = _48.z;
  return vec3(_46(_234), _46(_239), _46(_244));
}

vec3 _62(mat3 _60, vec3 _61) {
  return _60 * _61;
}

vec3 _153(vec3 _151, float _152) {
  float _810;
  if (_151.x > 0.0) {
    float _819 = (log2(_151.x) + 8.0) / 16.0;
    _810 = _10(_819);
  } else {
    _810 = 0.0;
  }
  vec3 _806;
  _806.x = _810;
  float _827;
  if (_151.y > 0.0) {
    float _835 = (log2(_151.y) + 8.0) / 16.0;
    _827 = _10(_835);
  } else {
    _827 = 0.0;
  }
  _806.y = _827;
  float _843;
  if (_151.z > 0.0) {
    float _851 = (log2(_151.z) + 8.0) / 16.0;
    _843 = _10(_851);
  } else {
    _843 = 0.0;
  }
  _806.z = _843;
  _806 *= ((_152 - 1.0) / _152);
  _806 += vec3(0.5 / _152);
  vec3 _868 = _806;
  return _16(_868);
}

float _52(float _51) {
  float _255;
  if (_51 > 0.003130800090730190277099609375) {
    _255 = (pow(_51, 0.4166666567325592041015625) * 1.05499994754791259765625) - 0.054999999701976776123046875;
  } else {
    _255 = _51 * 12.9200000762939453125;
  }
  return _255;
}

vec3 _55(vec3 _54) {
  float _270 = _54.x;
  float _274 = _54.y;
  float _278 = _54.z;
  return vec3(_52(_270), _52(_274), _52(_278));
}

float _108(uvec2 _106, uint _107) {
  uvec2 _391 = _106 & uvec2(3u);
  uint _396 = ((_391.x + (_391.y << uint(2))) + _107) & 15u;
  return float((((3742624800u * (1u - (_396 & 1u))) + (1469801640u * (_396 & 1u))) >> ((_396 >> uint(1)) << uint(2))) & 15u) / 16.0;
}

float _22(uint _21) {
  return uintBitsToFloat(_21);
}

float _28(int _27) {
  return intBitsToFloat(_27);
}

void main() {
  _163 = 2147483648u;
  _165 = 1073741824u;
  _167 = 536870912u;
  _170 = 0;
  _172 = 1;
  _174 = 2;
  ivec2 _910 = ivec2(gl_GlobalInvocationID.xy);
  vec2 _917 = (vec2(_910) + vec2(0.5)) * _924._m4.zw;
  vec3 _929 = vec3(0.0);
  bool _937 = float(_910.x) >= _324._m18.x;
  bool _946;
  if (_937) {
    _946 = float(_910.y) >= _324._m18.y;
  } else {
    _946 = _937;
  }
  bool _955;
  if (_946) {
    _955 = float(_910.x) < _324._m18.z;
  } else {
    _955 = _946;
  }
  bool _964;
  if (_955) {
    _964 = float(_910.y) < _324._m18.w;
  } else {
    _964 = _955;
  }
  if (_964) {
    float _967 = _324._m87;
    float _971 = 1.0 / _967;
    vec2 _974 = _917 - vec2(0.5);
    float _978 = length(_974);
    vec3 _981 = vec3(0.0);
    vec2 _982 = _917;
    float _984 = 1.0;
    _982 += textureLod(sampler2D(_987, _991), vec4(_917.x, 1.0 - _917.y, 0.0, 0.0).xy, vec4(_917.x, 1.0 - _917.y, 0.0, 0.0).w).xy;
    uint _1013 = _324._m85;
    vec2 _1018 = (vec2(1.0) / _924._m4.zw) / vec2(4.0);
    vec2 _1026 = (_917 * _1018) + vec2(0.5);
    vec2 _1032 = floor(_1026);
    vec2 _1035 = fract(_1026);
    float _1039 = _1035.x;
    float _1038 = _123(_1039);
    float _1044 = _1035.x;
    float _1043 = _126(_1044);
    float _1049 = _1035.x;
    float _1048 = _129(_1049);
    float _1054 = _1035.x;
    float _1053 = _132(_1054);
    float _1059 = _1035.y;
    float _1058 = _129(_1059);
    float _1064 = _1035.y;
    float _1063 = _132(_1064);
    vec2 _1068 = (vec2(_1032.x + _1048, _1032.y + _1058) - vec2(0.5)) / _1018;
    vec2 _1082 = (vec2(_1032.x + _1053, _1032.y + _1058) - vec2(0.5)) / _1018;
    vec2 _1096 = (vec2(_1032.x + _1048, _1032.y + _1063) - vec2(0.5)) / _1018;
    vec2 _1110 = (vec2(_1032.x + _1053, _1032.y + _1063) - vec2(0.5)) / _1018;
    vec4 _1125 = textureLod(sampler2D(_1126, _991), vec4(_1068, 0.0, 0.0).xy, vec4(_1068, 0.0, 0.0).w);
    vec4 _1141 = textureLod(sampler2D(_1126, _991), vec4(_1082, 0.0, 0.0).xy, vec4(_1082, 0.0, 0.0).w);
    vec4 _1156 = textureLod(sampler2D(_1126, _991), vec4(_1096, 0.0, 0.0).xy, vec4(_1096, 0.0, 0.0).w);
    vec4 _1171 = textureLod(sampler2D(_1126, _991), vec4(_1110, 0.0, 0.0).xy, vec4(_1110, 0.0, 0.0).w);
    float _1187 = _1035.y;
    float _1199 = _1035.y;
    vec4 _1186 = (((_1125 * _1038) + (_1141 * _1043)) * _123(_1187)) + (((_1156 * _1038) + (_1171 * _1043)) * _126(_1199));
    vec2 _1212 = _1186.xy;
    _1212 = (_1212 * 2.007874011993408203125) - vec2(1.007874011993408203125);
    _1212.x /= _324._m87;
    _1212 *= 0.100000001490116119384765625;
    _982 += _1212;
    float _1233 = _924._m21;
    SPIRV_CROSS_BRANCH
    if (_1233 > 0.0) {
      float _1241 = float(_1233 < 1.0);
      vec2 _1245 = _917;
      _1245.x *= _967;
      _1245.x *= (1.0 + (0.4000000059604644775390625 * _1241));
      _1245.y -= ((_1241 * _324._m84) * 2.0);
      _1245 *= 6.0;
      _1245 += vec2(_324._m84 * 1.5);
      vec2 _1279 = vec2(sin(_1245.x - _1245.y) * sin(_1245.y), cos(_1245.x + _1245.y) * cos(_1245.y)) * 0.0040000001899898052215576171875;
      _1279.x *= _971;
      _1279 *= (1.0 + ((_1241 * 3000.0) * _1279.x));
      _982 += (_1279 * _1233);
    }
    float _1322 = _324._m39;
    float _1326 = _924._m10 * pow(_978, _924._m9 - 1.0);
    _982.x = 0.5 + ((_982.x - 0.5) * (1.0 - (0.100000001490116119384765625 * _1322)));
    float _1346 = 0.0;
    SPIRV_CROSS_BRANCH
    if (((_924._m24 & 1u) != 0u) == true) {
      vec4 _1356 = textureLod(sampler2D(_1357, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w);
      _1346 = _1356.w;
      SPIRV_CROSS_BRANCH
      if ((_1013 & 16u) != 0u) {
        float _1380 = 0.0;
        vec2 _1381 = ((_1356.xy * 255.0) - vec2(128.0)) / vec2(127.0);
        _1380 += length(_1381);
        float _1396 = _1356.z;
        _1380 += _1396;
        float _1405 = 1.0 - (1.5 * _1380);
        _984 = _10(_1405);
      }
    }
    vec3 _1407 = vec3(0.0);
    SPIRV_CROSS_BRANCH
    if (_1322 != 0.0) {
      float _1412 = 0.02500000037252902984619140625 * _1322;
      SPIRV_CROSS_BRANCH
      if (_1346 > 0.0) {
        vec3 _1420 = textureLod(sampler2D(_1421, _991), vec4(_982.x + _1412, _982.y, 0.0, 0.0).xy, vec4(_982.x + _1412, _982.y, 0.0, 0.0).w).xyz;
        vec3 _1443 = textureLod(sampler2D(_1421, _991), vec4(_982.x - _1412, _982.y, 0.0, 0.0).xy, vec4(_982.x - _1412, _982.y, 0.0, 0.0).w).xyz;
        _1407 = (_1420 + _1443) * 0.5;
      }
      SPIRV_CROSS_BRANCH
      if (_1346 < 1.0) {
        vec3 _1473 = textureLod(sampler2D(_1474, _991), vec4(_982.x + _1412, _982.y, 0.0, 0.0).xy, vec4(_982.x + _1412, _982.y, 0.0, 0.0).w).xyz;
        vec3 _1496 = textureLod(sampler2D(_1474, _991), vec4(_982.x - _1412, _982.y, 0.0, 0.0).xy, vec4(_982.x - _1412, _982.y, 0.0, 0.0).w).xyz;
        _981 = (_1473 + _1496) * 0.5;
      }
    } else {
      if (((_324._m96 & 1u) != 0u) == true) {
        vec2 _1531 = vec2(1.0) / _924._m4.zw;
        vec2 _1537 = _982 - vec2(0.5);
        float _1540 = length(_1537);
        float _1543 = (_1540 * _1540) * 4.0;
        vec2 _1548 = _1537 * 2.0;
        float _1551 = _324._m33 * 0.20000000298023223876953125;
        float _1557 = (0.5 * _1543) * _1551;
        float _1562 = (((-0.20000000298023223876953125) * _1543) * _1543) * _1551;
        float _1570 = ((0.1617999970912933349609375 * _1543) * _1551) * _324._m36;
        vec3 _1580 = vec3(0.0);
        vec3 _1581 = vec3(0.0);
        vec3 _1582 = vec3(0.0);
        vec2 _1583 = _1548;
        float _1585 = sin(_1570);
        float _1588 = cos(_1570);
        mat2 _1591 = mat2(vec2(_1588, -_1585), vec2(_1585, _1588));
        mat2 _1607 = _1591;
        vec2 _1609 = _1548 * (1.0 + (_1557 * _1562));
        vec2 _1600 = _76(_1607, _1609);
        float _1611 = distance(_1583 * _1531, _1600 * _1531);
        uint _1626;
        if (_1611 < float(_324._m34)) {
          _1626 = uint(floor(_1611 + 1.0));
        } else {
          _1626 = _324._m34;
        }
        uint _1619 = _1626;
        float _1637 = _324._m35;
        vec2 _1641 = vec2(0.0);
        if (_1611 > _1637) {
          float _1648 = _1637 / _1611;
          _1641 = _1548 + ((_1600 - _1548) * _1648);
        } else {
          _1641 = _1600;
        }
        float _1661 = texelFetch(sampler2D(_1662, _1664), ivec2(_324._m10.xy + ((_1583 * _1531) * 2.0)) & ivec2(511), 0).x;
        vec3 _1708;
        for (uint _1682 = 0u; _1682 < _1619; _1682++) {
          float _1691 = (float(_1682) + _1661) / float(_1619);
          vec2 _1699 = mix(_1548, _1641, vec2(_1691));
          if (_1619 == 1u) {
            _1708 = vec3(1.0);
          } else {
            _1708 = textureLod(sampler2D(_1713, _991), vec4(_1691, 0.0, 0.0, 0.0).xy, vec4(_1691, 0.0, 0.0, 0.0).w).xyz;
          }
          vec3 _1705 = _1708;
          _1580 += (textureLod(sampler2D(_1474, _991), vec4((_1699 * 0.5) + vec2(0.5), 0.0, 0.0).xy, vec4((_1699 * 0.5) + vec2(0.5), 0.0, 0.0).w).xyz * _1705);
          _1581 += (textureLod(sampler2D(_1421, _991), vec4((_1699 * 0.5) + vec2(0.5), 0.0, 0.0).xy, vec4((_1699 * 0.5) + vec2(0.5), 0.0, 0.0).w).xyz * _1705);
          _1582 += _1705;
        }
        _981 = _1580 / _1582;
        _1407 = _1581 / _1582;
      } else {
        if (_1326 != 0.0) {
          vec2 _1788 = _974 * _1326;
          SPIRV_CROSS_BRANCH
          if (_1346 > 0.0) {
            _1407.x = textureLod(sampler2D(_1421, _991), vec4(_982 - _1788, 0.0, 0.0).xy, vec4(_982 - _1788, 0.0, 0.0).w).x;
            _1407.y = textureLod(sampler2D(_1421, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).y;
            _1407.z = textureLod(sampler2D(_1421, _991), vec4(_982 + _1788, 0.0, 0.0).xy, vec4(_982 + _1788, 0.0, 0.0).w).z;
          }
          SPIRV_CROSS_BRANCH
          if (_1346 < 1.0) {
            _981.x = textureLod(sampler2D(_1474, _991), vec4(_982 - _1788, 0.0, 0.0).xy, vec4(_982 - _1788, 0.0, 0.0).w).x;
            _981.y = textureLod(sampler2D(_1474, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).y;
            _981.z = textureLod(sampler2D(_1474, _991), vec4(_982 + _1788, 0.0, 0.0).xy, vec4(_982 + _1788, 0.0, 0.0).w).z;
          }
        } else {
          SPIRV_CROSS_BRANCH
          if (_1346 > 0.0) {
            _1407 = textureLod(sampler2D(_1421, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).xyz;
          }
          SPIRV_CROSS_BRANCH
          if (_1346 < 1.0) {
            _981 = textureLod(sampler2D(_1474, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).xyz;
          }
        }
      }
    }
    _981 = mix(_981, _1407, vec3(_1346));
    vec3 _1956 = textureLod(sampler2D(_1957, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xyz;
    _981 += _1956;
    if (((_324._m96 & 128u) != 0u) == true) {
      vec3 _1984 = textureLod(sampler2D(_1985, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xyz;
      _981 += _1984;
    }
    SPIRV_CROSS_BRANCH
    if ((_1013 & 16u) != 0u) {
      vec4 _2009 = textureLod(sampler2D(_2010, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w);
      vec3 _2025 = _2009.xyz;
      vec3 _2028 = _156(_2025);
      _2009.x = _2028.x;
      _2009.y = _2028.y;
      _2009.z = _2028.z;
      _2009 *= _984;
      _981 = (_981 * (1.0 - _2009.w)) + _2009.xyz;
    }
    SPIRV_CROSS_BRANCH
    if (_924._m7.x > 0.0) {
      float _2052 = textureLod(sampler2D(_2053, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).x;
      SPIRV_CROSS_BRANCH
      if (_2052 > 0.0) {
        vec3 _2073 = textureLod(sampler2D(_2074, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xyz;
        _981 = mix(_981, _2073, vec3(_2052));
      }
    }
    bool _2100 = ((_324._m96 & 64u) != 0u) == true;
    bool _2108;
    if (_2100) {
      _2108 = _324._m77 > 0;
    } else {
      _2108 = _2100;
    }
    SPIRV_CROSS_BRANCH
    if (_2108) {
      vec4 _2111 = textureLod(sampler2D(_2112, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w);
      float _2127 = textureLod(sampler2D(_2128, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).w;
      _981 = mix(_981, _2111.xyz, vec3(_2127));
      if (_924._m23 > 0.0) {
        vec3 _2156 = vec3(0.0);
        float _2157 = 0.0;
        uint _2164 = _324._m95;
        uint _2167 = 4554u;
        float _2158 = textureLod(sampler2D(_2161[_142(_2164, _2167)], _2171), vec4(_917 * float(_324._m32), 0.0, 0.0).xy, vec4(_917 * float(_324._m32), 0.0, 0.0).w).x;
        float _2196 = _160(_924._m22 / _924._m23);
        if (_324._m94 == 1u) {
          float _2210 = _2196 * 1.0;
          if (false) {
            _2210 = trunc(_2210 / 0.0) * 0.0;
          }
          vec2 _2220 = vec2((_917.x - _2210) / 0.0199999995529651641845703125, 0.0);
          float _2228 = pow(_2127, 0.20000000298023223876953125) + 1.0;
          float _2239 = 1.0 - pow(dot(_2220, _2220), 0.00999999977648258209228515625);
          float _2232 = _10(_2239);
          _2156 = ((vec3(_2232) * _2158) * _324._m30.xyz) * _2228;
          vec2 _2252 = vec2(_917.x - _2210, 0.0);
          _2157 = float(_917.x < _2210);
        } else {
          if (_324._m94 == 2u) {
            uint _2272 = _324._m93;
            uint _2275 = 4573u;
            float _2269 = textureLod(sampler2D(_2161[_142(_2272, _2275)], _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).w;
            float _2293 = step(_2196, _2269);
            float _2297 = pow(_2127, 0.20000000298023223876953125) + 1.0;
            _2156 = ((vec3(_2293) * _2158) * _324._m30.xyz) * _2297;
            float _2311 = _2293;
            _2157 = 1.0 - _10(_2311);
          } else {
            if (_324._m94 == 3u) {
              uint _2323 = _324._m93;
              uint _2326 = 4579u;
              float _2321 = textureLod(sampler2D(_2161[_142(_2323, _2326)], _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).w;
              float _2344 = smoothstep(_2196, 1.0, _2321 + 0.100000001490116119384765625);
              float _2349 = pow(_2127, 0.20000000298023223876953125) + 1.0;
              _2156 = ((vec3(_2344) * _2158) * _324._m30.xyz) * _2349;
              float _2365 = _2344 * 2.0;
              _2157 = 1.0 - _10(_2365);
            } else {
              if (_324._m94 == 4u) {
                uint _2377 = _324._m93;
                uint _2380 = 4585u;
                float _2375 = textureLod(sampler2D(_2161[_142(_2377, _2380)], _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).w;
                float _2398 = smoothstep(_2196, _2375 + 1.0, 1.0);
                float _2403 = pow(_2127, 0.20000000298023223876953125) + 1.0;
                _2156 = ((vec3(_2398) * _2158) * _324._m30.xyz) * _2403;
                float _2417 = _2398;
                _2157 = 1.0 - _10(_2417);
              }
            }
          }
        }
        _981 += (((_2156 * 1000.0) * float(_324._m31)) * _2127);
      }
    }
    vec4 _2433 = _924._m5;
    float _2444;
    if (((_324._m96 & 16u) != 0u) == false) {
      _2444 = textureLod(sampler2D(_2445, _991), vec2(0.5), 0.0).x;
      float _2451 = _2433.w;
      _2444 = (_2451 != 0.0) ? _2451 : _2444;
    }
    vec3 _2459 = textureLod(sampler2D(_2460, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).xyz;
    vec3 _2476 = textureLod(sampler2D(_2477, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).xyz;
    vec3 _2493 = textureLod(sampler2D(_2494, _2171), vec4((_917 * 1.39999997615814208984375) * vec2(1.0, _971), 0.0, 0.0).xy, vec4((_917 * 1.39999997615814208984375) * vec2(1.0, _971), 0.0, 0.0).w).xyz;
    _981 += ((_2459 * _2493) * _2433.z);
    _981 += (_2476 * mix(vec3(1.0), _2493, vec3(_924._m11)));
    _981 = mix(_981, _2459, vec3(_2433.x));
    vec3 _2544 = _981;
    float _2543 = _85(_2544);
    if (((_324._m96 & 16u) != 0u) == false) {
      _981 *= _2444;
    } else {
      float _2558 = _324._m72;
      _981 *= (1.0 / _2558);
    }
    SPIRV_CROSS_BRANCH
    if (((_324._m96 & 256u) != 0u) == true) {
      _981 = textureLod(sampler2D(_2573, _991), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).xyz;
    }
    SPIRV_CROSS_BRANCH
    if (((_924._m24 & 4u) != 0u) == true) {
      vec3 _2610 = _981;
      mat3 _2612 = mat3(vec3(0.412390887737274169921875, 0.357584297657012939453125, 0.18048083782196044921875), vec3(0.2126390635967254638671875, 0.71516859531402587890625, 0.072192333638668060302734375), vec3(0.01933082006871700286865234375, 0.119194723665714263916015625, 0.95053231716156005859375));
      vec3 _2627 = _67(_2610, _2612);
      mat3 _2628 = mat3(vec3(1.01303005218505859375, 0.0061053098179399967193603515625, -0.014971000142395496368408203125), vec3(0.0076982299797236919403076171875, 0.99816501140594482421875, -0.005032029934227466583251953125), vec3(-0.0028413101099431514739990234375, 0.0046851597726345062255859375, 0.92450702190399169921875));
      vec3 _2643 = _67(_2627, _2628);
      mat3 _2644 = mat3(vec3(1.64102351665496826171875, -0.32480335235595703125, -0.2364247143268585205078125), vec3(-0.663663089275360107421875, 1.6153318881988525390625, 0.01675635017454624176025390625), vec3(0.011721909977495670318603515625, -0.00828444026410579681396484375, 0.988394916057586669921875));
      vec3 _2596 = _67(_2643, _2644);
      float _2647 = _2596.x;
      float _2651 = _2596.y;
      float _2655 = _2596.z;
      
      // ACEScc Encode 
      vec3 _2646 = vec3(_148(_2647), _148(_2651), _148(_2655));
      if (_924._m2.w < 0.0) {
        float _2669 = _2646.x;
        float _2672 = _2646.y;
        float _2675 = _2646.z;
        vec3 _2683 = _2646 + vec3((-_924._m2.w) * (1.0 - _43(_2669, _2672, _2675)));
        _2646 = _16(_2683);
      }
      _981 = textureLod(sampler3D(_2687, _991), vec4(_2646, 0.0).xyz, vec4(_2646, 0.0).w).xyz;
      float _2706 = _981.x;
      float _2710 = _981.y;
      float _2714 = _981.z;
      _981 = vec3(_145(_2706), _145(_2710), _145(_2714));
      vec3 _2732 = _981;
      mat3 _2734 = mat3(vec3(0.662454128265380859375, 0.1340042054653167724609375, 0.1561876833438873291015625), vec3(0.272228717803955078125, 0.67408168315887451171875, 0.0536895208060741424560546875), vec3(-0.0055746599100530147552490234375, 0.0040607298724353313446044921875, 1.0103390216827392578125));
      vec3 _2749 = _67(_2732, _2734);
      mat3 _2750 = mat3(vec3(0.987228810787200927734375, -0.00611330009996891021728515625, 0.0159534104168415069580078125), vec3(-0.007598400115966796875, 1.00185978412628173828125, 0.0053300000727176666259765625), vec3(0.00307258008979260921478271484375, -0.0050959200598299503326416015625, 1.0816795825958251953125));
      vec3 _2765 = _67(_2749, _2750);
      mat3 _2766 = mat3(vec3(3.2409694194793701171875, -1.53738296031951904296875, -0.4986107647418975830078125), vec3(-0.96924388408660888671875, 1.87596786022186279296875, 0.041555099189281463623046875), vec3(0.055630020797252655029296875, -0.2039768397808074951171875, 1.0569713115692138671875));
      _981 = _67(_2765, _2766);
    }
    if ((_324._m96 & 1024u) != 0u) {
      vec2 _2787 = _974;
      vec2 _2789 = vec2(_324._m91, _324._m92) * _324._m88;
      float _2790 = _137(_2787, _2789);
      float _2797 = smoothstep(-1.0, 1.0, _2790 * (1.0 / _324._m90));
      float _2775 = _10(_2797);
      vec3 _2799 = _981 * vec3(_324._m29.x * _324._m89, _324._m29.y * _324._m89, _324._m29.z * _324._m89);
      _981 = mix(_981, _2799, vec3(_2775));
    }
    uint _2825 = _924._m8;
    SPIRV_CROSS_BRANCH
    if ((_2825 & 3u) != 0u) {
      ivec2 _2834 = ivec2(_910.x >> 1, _910.y);
      uint _2841 = uint(imageLoad(_2844, _2834).x * 255.0);
      uint _2851 = (_2841 >> uint((_910.x & 1) * 4)) & 15u;
      uint _2859 = _2851 & 7u;
      bool _2863 = ((_2825 >> uint(0)) & 1u) != 0u;
      bool _2868 = ((_2825 >> uint(1)) & 1u) != 0u;
      SPIRV_CROSS_BRANCH
      if (_2868 && (_2859 == 0u)) {
        vec4 _2879 = textureLod(sampler2D(_2880, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w);
        _981 = (_981 * (1.0 - _2879.w)) + _2879.xyz;
      }
      if ((_2859 >= 1u) && (_2859 <= 4u)) {
        _981 = _2913._m0[_2859 - 1u].xyz;
      }
      bool _2919 = (_2851 & 8u) != 0u;
      _981 = mix(_981, _924._m1.xyz, vec3(float(_2919) * _924._m1.w));
    }
    SPIRV_CROSS_BRANCH
    if (_324._m5.w > 0.0) {
      float _2940 = 1.0 - textureLod(sampler2D(_2941, _2943), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).x;
      float _2961 = _2940;
      bool _2963 = false;
      vec3 _2959 = _101(_982, _92(_2961, _2963));
      vec3 _2966 = vec3(subgroupShuffleXor(_2959.x, 1u), subgroupShuffleXor(_2959.y, 1u), subgroupShuffleXor(_2959.z, 1u));
      vec3 _2977 = vec3(subgroupShuffleXor(_2959.x, 8u), subgroupShuffleXor(_2959.y, 8u), subgroupShuffleXor(_2959.z, 8u));
      vec3 _2988 = _2966 - _2959;
      vec3 _2992 = _2977 - _2959;
      vec3 _2996 = _2959 + vec3(_324._m48, _324._m49, _324._m50);
      vec3 _3009 = _2996;
      vec3 _3011 = sqrt((_2988 * _2988) + (_2992 * _2992));
      vec3 _3020 = max(vec3(0.0), ((vec3(1.0) / _3011) - vec3(8.0)) * 1.2000000476837158203125);
      vec3 _3029 = fract(_3009 / vec3(0.25));
      vec3 _3035 = (vec3(0.039999999105930328369140625) - abs(_3029 - vec3(0.5))) * 0.25;
      vec3 _3050 = vec3(0.5) + (_3020 * _3035);
      vec3 _3044 = _16(_3050);
      vec3 _3052 = normalize(cross(_2988, _2992));
      vec3 _3057 = sqrt(vec3(1.0) - (_3052 * _3052));
      _3057 = max(vec3(0.0), (_3057 - vec3(0.20000000298023223876953125)) / vec3(0.800000011920928955078125));
      _3044 *= _3057;
      float _3075 = _3044.x;
      float _3078 = _3044.y;
      float _3081 = _3044.z;
      float _3074 = _38(_3075, _3078, _3081);
      vec3 _3085 = _324._m5.xyz;
      float _3089 = length(_2996 - _3085);
      float _3094 = _324._m5.w;
      float _3097 = _3089 - _3094;
      float _3106 = (-_3097) / 5.0;
      float _3101 = _10(_3106);
      _3074 = 1.0 - (_3101 * (1.0 - _3074));
      float _3123 = 1.0 + min((_3097 + 5.0) / 20.0, (-_3097) / 0.100000001490116119384765625);
      float _3113 = _10(_3123);
      _3074 *= (_3113 * _3113);
      float _3130 = length(_2959);
      float _3136 = (_3130 - 1.0) / 4.0;
      _3074 *= _10(_3136);
      float _3145 = (5000.0 - _3089) / 4000.0;
      _3074 *= _10(_3145);
      _981 = mix(_981, vec3(1.0, 0.319999992847442626953125, 0.0), vec3(_3074));
    }
    SPIRV_CROSS_BRANCH
    if (_924._m3.w != 0.0) {
      float _3160 = fract(_324._m84);
      float _3164 = fract(_324._m84 + 0.5);
      float _3169 = abs(1.0 - (_3160 / 0.5));
      vec2 _3174 = textureLod(sampler2D(_3175, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xy;
      _3174 = (_3174 * 2.0) - vec2(1.0);
      float _3195 = textureLod(sampler2D(_3175, _991), vec4(_917 + (_3174 * _3160), 0.0, 0.0).xy, vec4(_917 + (_3174 * _3160), 0.0, 0.0).w).z;
      float _3219 = textureLod(sampler2D(_3175, _991), vec4(_917 + (_3174 * _3164), 0.0, 0.0).xy, vec4(_917 + (_3174 * _3164), 0.0, 0.0).w).z;
      float _3245 = _3169;
      _3169 = mix(_3195, _3219, _10(_3245));
      vec3 _3249 = vec3(_3169);
      _3249 *= _924._m3.xyz;
      float _3259 = _924._m3.w;
      _981 = mix(_981, _3249, vec3(_10(_3259)));
    }
    SPIRV_CROSS_BRANCH
    if (_924._m17 > 0.0) {
      vec4 _3271 = vec4(1.0);
      int _3273 = _924._m16;
      if (_3273 > 0) {
        uint _3284 = uint(_3273);
        uint _3285 = 4726u;
        uint _3287 = _142(_3284, _3285);
        _3271 *= textureLod(sampler2D(_2161[_3287], _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w);
      }
      vec2 _3309 = _974;
      vec2 _3311 = vec2(1.35000002384185791015625, 1.62000000476837158203125);
      float _3312 = _137(_3309, _3311);
      float _3315 = smoothstep(-1.0, 1.0, _3312 * 1.0);
      float _3305 = _10(_3315);
      _981.x += (((((_3271.y * 0.5) + 0.5) * _3305) * _3271.w) * _924._m17);
      vec2 _3336 = _974;
      vec2 _3338 = vec2(1.35000002384185791015625, 1.2825000286102294921875);
      float _3339 = _137(_3336, _3338);
      float _3342 = smoothstep(-1.0, 1.0, _3339 * 1.0);
      float _3333 = _10(_3342);
      _981.x += (((_3271.x * _3333) * _3271.w) * _924._m17);
    }
    vec4 _3358 = vec4(0.0);
    vec4 _3360 = vec4(0.0);
    SPIRV_CROSS_BRANCH
    if (_924._m19 > 0) {
      vec2 _3367 = abs((_917 * 2.0) - vec2(1.0));
      _3367.x = max(0.0, 1.0 - ((1.0 - _3367.x) / _971));
      vec2 _3381 = (floor(_3367 / vec2(0.0416666679084300994873046875)) + vec2(0.5)) * 0.0416666679084300994873046875;
      _3358 = vec4(0.0);
      _3360 = vec4(0.0);
      SPIRV_CROSS_UNROLL
      for (int _3390 = 0; _3390 < 4; _3390++) {
        vec4 _3398 = _3402._m0[_3390];
        float _3407 = _3398.x;
        uint _3406 = _32(_3407);
        SPIRV_CROSS_FLATTEN
        if (_3406 == 0u) {
          break;
        }
        float _3416 = _3398.y;
        float _3419 = _3398.z;
        float _3422 = _3398.w;
        float _3425 = pow(pow(_3367.x, _3416) + pow(_3367.y * _3422, _3416), 1.0 / _3416);
        uint _3441 = _3406;
        vec4 _3440 = _81(_3441);
        vec3 _3444 = _3440.xyz;
        vec3 _3447 = _49(_3444);
        _3440.x = _3447.x;
        _3440.y = _3447.y;
        _3440.z = _3447.z;
        float _3454 = min(1.0, _3425 * 5.0);
        _3440.w *= _3454;
        float _3466 = 2.0 - _3416;
        float _3463 = 1.0 + (_10(_3466) * 0.4142135679721832275390625);
        float _3471 = (_3425 - _3419) / _3463;
        float _3477 = max(0.0, 1.0 - max(_3471 / 0.300000011920928955078125, (-_3471) / 0.4000000059604644775390625));
        _3477 *= _3477;
        _3477 *= _3477;
        _3477 *= 0.5;
        float _3501 = 1.2000000476837158203125 - (abs(_3471) * 50.0);
        float _3495 = _10(_3501);
        float _3503 = (_3477 + _3495) * _3440.w;
        _3360.w = ((1.0 - _3503) * _3360.w) + _3503;
        vec4 _3520 = _3360;
        vec3 _3527 = (_3520.xyz * (1.0 - _3503)) + (_3440.xyz * _3503);
        _3360.x = _3527.x;
        _3360.y = _3527.y;
        _3360.z = _3527.z;
        float _3534 = pow(pow(_3381.x, _3416) + pow(_3381.y * _3422, _3416), 1.0 / _3416);
        float _3549 = (_3534 - _3419) / _3463;
        float _3555 = max(0.0, 1.0 - (abs(_3549) / 0.054999999701976776123046875)) * _3440.w;
        vec4 _3568 = _3360;
        vec3 _3570 = _3568.xyz + (_3440.xyz * _3555);
        _3360.x = _3570.x;
        _3360.y = _3570.y;
        _3360.z = _3570.z;
        float _3577 = 0.60000002384185791015625 + (max(0.0, _3416 - 8.0) * 0.25);
        float _3584 = max(0.0, 1.0 - max(_3471 / 0.0199999995529651641845703125, (-_3471) / _3577));
        _3584 *= _3584;
        _3584 *= _3584;
        float _3600 = _3584 * _3440.w;
        _3358.w = ((1.0 - _3600) * _3358.w) + _3600;
        vec4 _3615 = _3358;
        vec3 _3622 = (_3615.xyz * (1.0 - _3600)) + (_3440.xyz * _3600);
        _3358.x = _3622.x;
        _3358.y = _3622.y;
        _3358.z = _3622.z;
      }
    }
    vec4 _3631 = _324._m22;
    vec4 _3634 = _324._m20;
    vec4 _3638 = _324._m21;
    SPIRV_CROSS_BRANCH
    if (_3631.w != 0.0) {
      float _3646 = _3634.z;
      float _3649 = _3634.w;
      vec2 _3652 = _3638.xy;
      vec4 _3724;
      SPIRV_CROSS_BRANCH
      if (_3649 != 0.0) {
        float _3659 = fract(_324._m84 / _3646);
        float _3665 = fract(0.5 + (_324._m84 / _3646));
        float _3672 = abs(1.0 - (2.0 * _3659));
        vec3 _3677 = textureLod(sampler2D(_3678, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xyw;
        vec2 _3694 = ((_3677.xy * 2.0) - vec2(1.0)) * (_3649 * _3677.z);
        _3694.x *= _971;
        vec2 _3710 = _917 - (_3694 * (_3659 - 0.5));
        vec2 _3717 = _917 - (_3694 * (_3665 - 0.5));
        _3724 = mix(textureLod(sampler2D(_3725, _3727), vec4(_3710 * _3652, 0.0, 0.0).xy, vec4(_3710 * _3652, 0.0, 0.0).w), textureLod(sampler2D(_3725, _3727), vec4(_3717 * _3652, 0.0, 0.0).xy, vec4(_3717 * _3652, 0.0, 0.0).w), vec4(_3672));
      } else {
        _3724 = textureLod(sampler2D(_3725, _3727), vec4(_917 * _3652, 0.0, 0.0).xy, vec4(_917 * _3652, 0.0, 0.0).w);
      }
      float _3785 = float(_3638.w < 0.0);
      _3724 = mix(_3724, vec4(1.0, 1.0, 1.0, _3724.x), vec4(_3785));
      _3724.w *= min(1.0, _3634.x * pow(2.0 * _978, _3634.y));
      _3724.w *= abs(_3631.w);
      vec4 _3819 = _3724;
      vec3 _3821 = _3819.xyz * _3631.xyz;
      _3724.x = _3821.x;
      _3724.y = _3821.y;
      _3724.z = _3821.z;
      float _3828 = abs(_3638.w);
      vec4 _3833 = _3724;
      vec3 _3835 = _3833.xyz * _3828;
      _3724.x = _3835.x;
      _3724.y = _3835.y;
      _3724.z = _3835.z;
      vec3 _3842 = _3724.xyz * _3724.w;
      bool _3848 = _3638.z != 0.0;
      SPIRV_CROSS_BRANCH
      if (_3848) {
        _3724.w *= _3358.w;
        _3842 *= _3358.xyz;
      }
      float _3865 = 1.0 - (float(_3631.w > 0.0) * _3724.w);
      _981 = (_981 * _3865) + _3842;
    }
    _3631 = _324._m25;
    _3634 = _324._m23;
    _3638 = _324._m24;
    SPIRV_CROSS_BRANCH
    if (_3631.w != 0.0) {
      float _3891 = _3634.z;
      float _3894 = _3634.w;
      vec2 _3897 = _3638.xy;
      vec4 _3969;
      SPIRV_CROSS_BRANCH
      if (_3894 != 0.0) {
        float _3904 = fract(_324._m84 / _3891);
        float _3910 = fract(0.5 + (_324._m84 / _3891));
        float _3917 = abs(1.0 - (2.0 * _3904));
        vec3 _3922 = textureLod(sampler2D(_3923, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xyw;
        vec2 _3939 = ((_3922.xy * 2.0) - vec2(1.0)) * (_3894 * _3922.z);
        _3939.x *= _971;
        vec2 _3955 = _917 - (_3939 * (_3904 - 0.5));
        vec2 _3962 = _917 - (_3939 * (_3910 - 0.5));
        _3969 = mix(textureLod(sampler2D(_3970, _3972), vec4(_3955 * _3897, 0.0, 0.0).xy, vec4(_3955 * _3897, 0.0, 0.0).w), textureLod(sampler2D(_3970, _3972), vec4(_3962 * _3897, 0.0, 0.0).xy, vec4(_3962 * _3897, 0.0, 0.0).w), vec4(_3917));
      } else {
        _3969 = textureLod(sampler2D(_3970, _3972), vec4(_917 * _3897, 0.0, 0.0).xy, vec4(_917 * _3897, 0.0, 0.0).w);
      }
      float _4030 = float(_3638.w < 0.0);
      _3969 = mix(_3969, vec4(1.0, 1.0, 1.0, _3969.x), vec4(_4030));
      _3969.w *= min(1.0, _3634.x * pow(2.0 * _978, _3634.y));
      _3969.w *= abs(_3631.w);
      vec4 _4064 = _3969;
      vec3 _4066 = _4064.xyz * _3631.xyz;
      _3969.x = _4066.x;
      _3969.y = _4066.y;
      _3969.z = _4066.z;
      float _4073 = abs(_3638.w);
      vec4 _4078 = _3969;
      vec3 _4080 = _4078.xyz * _4073;
      _3969.x = _4080.x;
      _3969.y = _4080.y;
      _3969.z = _4080.z;
      vec3 _4087 = _3969.xyz * _3969.w;
      bool _4093 = _3638.z != 0.0;
      SPIRV_CROSS_BRANCH
      if (_4093) {
        _3969.w *= _3358.w;
        _4087 *= _3358.xyz;
      }
      float _4110 = 1.0 - (float(_3631.w > 0.0) * _3969.w);
      _981 = (_981 * _4110) + _4087;
    }
    _3631 = _324._m28;
    _3634 = _324._m26;
    _3638 = _324._m27;
    SPIRV_CROSS_BRANCH
    if (_3631.w != 0.0) {
      float _4138 = _3634.z;
      float _4141 = _3634.w;
      vec2 _4144 = _3638.xy;
      vec4 _4216;
      SPIRV_CROSS_BRANCH
      if (_4141 != 0.0) {
        float _4151 = fract(_324._m84 / _4138);
        float _4157 = fract(0.5 + (_324._m84 / _4138));
        float _4164 = abs(1.0 - (2.0 * _4151));
        vec3 _4169 = textureLod(sampler2D(_4170, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w).xyw;
        vec2 _4186 = ((_4169.xy * 2.0) - vec2(1.0)) * (_4141 * _4169.z);
        _4186.x *= _971;
        vec2 _4202 = _917 - (_4186 * (_4151 - 0.5));
        vec2 _4209 = _917 - (_4186 * (_4157 - 0.5));
        _4216 = mix(textureLod(sampler2D(_4217, _4219), vec4(_4202 * _4144, 0.0, 0.0).xy, vec4(_4202 * _4144, 0.0, 0.0).w), textureLod(sampler2D(_4217, _4219), vec4(_4209 * _4144, 0.0, 0.0).xy, vec4(_4209 * _4144, 0.0, 0.0).w), vec4(_4164));
      } else {
        _4216 = textureLod(sampler2D(_4217, _4219), vec4(_917 * _4144, 0.0, 0.0).xy, vec4(_917 * _4144, 0.0, 0.0).w);
      }
      float _4277 = float(_3638.w < 0.0);
      _4216 = mix(_4216, vec4(1.0, 1.0, 1.0, _4216.x), vec4(_4277));
      _4216.w *= min(1.0, _3634.x * pow(2.0 * _978, _3634.y));
      _4216.w *= abs(_3631.w);
      vec4 _4311 = _4216;
      vec3 _4313 = _4311.xyz * _3631.xyz;
      _4216.x = _4313.x;
      _4216.y = _4313.y;
      _4216.z = _4313.z;
      float _4320 = abs(_3638.w);
      vec4 _4325 = _4216;
      vec3 _4327 = _4325.xyz * _4320;
      _4216.x = _4327.x;
      _4216.y = _4327.y;
      _4216.z = _4327.z;
      vec3 _4334 = _4216.xyz * _4216.w;
      bool _4340 = _3638.z != 0.0;
      SPIRV_CROSS_BRANCH
      if (_4340) {
        _4216.w *= _3358.w;
        _4334 *= _3358.xyz;
      }
      float _4357 = 1.0 - (float(_3631.w > 0.0) * _4216.w);
      _981 = (_981 * _4357) + _4334;
    }
    _981 = (_981 * (1.0 - _3360.w)) + _3360.xyz;
    int _4379 = _924._m20;
    SPIRV_CROSS_LOOP
    for (int _4382 = 0; _4382 < _4379; _4382++) {
      vec4 _4391 = _4395._m0[_4382];
      float _4407 = pow(_978, _4391.z) * _4391.y;
      float _4399 = _10(_4407);
      float _4410 = _4391.x;
      uint _4414 = _32(_4410);
      vec3 _4409 = _81(_4414).xyz;
      vec3 _4418 = _4409;
      vec3 _4417 = _49(_4418);
      _981 = mix(_981, _4417, vec3(_4399));
    }
    SPIRV_CROSS_BRANCH
    if (_324._m40 > 0.0) {
      vec4 _4434 = textureLod(sampler2D(_4435, _991), vec4((_917 * vec2(1.2999999523162841796875)) + (floor(vec2(_324._m84 * 15.0, _324._m84 * 20.0)) * 0.300000011920928955078125), 0.0, 0.0).xy, vec4((_917 * vec2(1.2999999523162841796875)) + (floor(vec2(_324._m84 * 15.0, _324._m84 * 20.0)) * 0.300000011920928955078125), 0.0, 0.0).w);
      float _4478 = _324._m40;
      _981 = mix(_981, _4434.xyz, vec3(_10(_4478))) * vec3(1.0, 0.20000000298023223876953125, 0.100000001490116119384765625);
    }
    SPIRV_CROSS_BRANCH
    if (_924._m2.w > 0.0) {
      _981 = (_981 * (1.0 - _924._m2.w)) + _924._m2.xyz;
    }
    if (_324._m66 > 0.0) {
      float _4506 = 1.0 - textureLod(sampler2D(_2941, _2943), vec4(_982, 0.0, 0.0).xy, vec4(_982, 0.0, 0.0).w).x;
      float _4524 = _4506;
      bool _4526 = false;
      float _4523 = _92(_4524, _4526);
      if (_4523 > _324._m66) {
        _981 = vec3(0.0, 1.0, 0.0);
      }
    }
    int _4535 = 0;
    _4535 = int(_4539._m0[0]);
    SPIRV_CROSS_UNROLL
    for (int _4544 = 0; _4544 < 3; _4544++) {
      if (_4544 < _4535) {
        float _4557 = 0.0;
        vec4 _4558 = textureLod(sampler2D(_4559, _991), vec4(_917, 0.0, 0.0).xy, vec4(_917, 0.0, 0.0).w);
        switch (_4544) {
          case 0: {
            _4557 = _4558.x;
            break;
          }
          case 1: {
            _4557 = _4558.y;
            break;
          }
          case 2: {
            _4557 = _4558.z;
            break;
          }
          default: {
            _4557 = 0.0;
            break;
          }
        }
        uint _4591 = uint(1 + (_4544 * 18));
        mat3 _4596 = mat3(vec3(_4539._m0[_4591 + 9u], _4539._m0[_4591 + 10u], _4539._m0[_4591 + 11u]), vec3(_4539._m0[_4591 + 12u], _4539._m0[_4591 + 13u], _4539._m0[_4591 + 14u]), vec3(_4539._m0[_4591 + 15u], _4539._m0[_4591 + 16u], _4539._m0[_4591 + 17u]));
        mat3 _4645 = _4596;
        vec3 _4647 = _981;
        vec3 _4644 = _62(_4645, _4647);
        _981 = mix(_981, _4644, vec3(_4557));
      }
    }
    _981 = max(_981, vec3(0.0));
    vec3 _4659 = _981;
    SPIRV_CROSS_BRANCH
    if (_924._m6.x > 0.0) {
      float _4667 = _924._m15;
      float _4671 = _924._m14;
      float _4675 = mix(0.949999988079071044921875, 1.0499999523162841796875, _924._m13);
      float _4682 = mix(1.0, 3.0, _924._m12);
      _4659 = max(vec3(0.0), mix(vec3(0.5), _4659, vec3(_4675))) * _4682;
      vec3 _4695 = vec3(0.0);
      vec3 _4719;
      vec3 _4732;
      SPIRV_CROSS_BRANCH
      if (_924._m6.x == 1.0) {
        mat3 _4715 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875), vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625), vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
        vec3 _4716 = _4659;
        vec3 _4701 = _62(_4715, _4716);
        _4719.x = dot(_4701, vec3(0.0, 1.0511829853057861328125, -0.051160991191864013671875));
        _4719.y = _4701.y;
        _4719.z = _4701.z;
        mat3 _4746 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875), vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875), vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
        vec3 _4747 = _4719;
        _4732 = _62(_4746, _4747);
        vec3 _4750 = _4659 - _4732;
        _4695.x = 0.0;
        _4695.y = (_4750.x * _4667) + _4750.y;
        _4695.z = (_4750.x * _4667) + _4750.z;
      } else {
        SPIRV_CROSS_BRANCH
        if (_924._m6.x == 2.0) {
          mat3 _4778 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875), vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625), vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
          vec3 _4779 = _4659;
          vec3 _4777 = _62(_4778, _4779);
          _4719.x = _4777.x;
          _4719.y = dot(_4777, vec3(0.9513092041015625, 0.0, 0.04866991937160491943359375));
          _4719.z = _4777.z;
          mat3 _4794 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875), vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875), vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
          vec3 _4795 = _4719;
          _4732 = _62(_4794, _4795);
          vec3 _4798 = _4659 - _4732;
          _4695.x = (_4798.y * _4667) + _4798.x;
          _4695.y = 0.0;
          _4695.z = (_4798.y * _4667) + _4798.z;
        } else {
          SPIRV_CROSS_BRANCH
          if (_924._m6.x == 3.0) {
            mat3 _4826 = mat3(vec3(0.3139902055263519287109375, 0.1553724110126495361328125, 0.0177523903548717498779296875), vec3(0.639512956142425537109375, 0.757894456386566162109375, 0.109442092478275299072265625), vec3(0.0464975498616695404052734375, 0.0867014229297637939453125, 0.87256920337677001953125));
            vec3 _4827 = _4659;
            vec3 _4825 = _62(_4826, _4827);
            _4719.x = _4825.x;
            _4719.y = _4825.y;
            _4719.z = dot(_4825, vec3(-0.867447376251220703125, 1.867270946502685546875, 0.0));
            mat3 _4842 = mat3(vec3(5.4722118377685546875, -1.12524187564849853515625, 0.02980164997279644012451171875), vec3(-4.64196014404296875, 2.293170928955078125, -0.19318072497844696044921875), vec3(0.16963708400726318359375, -0.16789519786834716796875, 1.1636478900909423828125));
            vec3 _4843 = _4719;
            _4732 = _62(_4842, _4843);
            vec3 _4846 = _4659 - _4732;
            _4695.x = (_4846.z * _4667) + _4846.x;
            _4695.y = (_4846.z * _4667) + _4846.y;
            _4695.z = 0.0;
          }
        }
      }
      vec3 _4867 = max(vec3(0.0), _4659 + _4695);
      _981 = mix(_4659, _4867, vec3(_4671));
    }
    if ((_1013 & 1u) != 0u) {
      float _4882 = _4886._m0[_324._m41 % 3u];
      _4882 /= _324._m72;
      float _4897 = (((_924._m24 & 2u) != 0u) == true) ? _4882 : 0.5;
      _981 = max(vec3(0.0), mix(vec3(_4897), _981, vec3(mix(0.9700000286102294921875, 1.0299999713897705078125, _924._m18))));
      if (((_324._m96 & 8u) != 0u) == true) {
        _981 *= _324._m67;
      }
    }
    _981 *= _324._m1.xyz;
    float _4933 = _324._m1.w;
    if ((_1013 & 1u) != 0u) {
      _4933 *= _324._m71;
    }
    vec3 _4947 = _981;
    float _4946 = _85(_4947);
    _981 = mix(vec3(_4946), _981, vec3(_4933));
    vec3 _4961 = _981;
    float _4963 = float(_324._m86);
    vec3 _4956 = _153(_4961, _4963);
    _929 = textureLod(sampler3D(_4965, _991), vec4(_4956, 0.0).xyz, vec4(_4956, 0.0).w).xyz; // tonemapping LUT
    if ((_1013 & 1u) == 0u) {
      if (_324._m73 == 0u) {
        vec3 _4994 = _929;
        _929 = _55(_4994);
      } else {
        if (_324._m73 == 1u) {
          vec3 _5004 = _981;
          float _5003 = _85(_5004);
          float _5007 = _324._m1.w;
          _981 = max(vec3(0.0), mix(vec3(_5003), _981 * _324._m1.xyz, vec3(_5007)));
          float _5021 = 16.0;
          vec4 _5022;
          _5022.x = 0.87999999523162841796875;
          _5022.y = 0.300000011920928955078125;
          _5022.z = 0.00999999977648258209228515625;
          _5022.w = 0.0333333350718021392822265625;
          vec4 _5029 = vec4(0.02999999932944774627685546875, 0.00200000009499490261077880859375, 1.0 / ((((_5021 * ((_5022.x * _5021) + 0.02999999932944774627685546875)) + 0.00200000009499490261077880859375) / ((_5021 * ((_5022.x * _5021) + _5022.y)) + 0.0599999986588954925537109375)) - _5022.w), 0.0);
          float _5057 = _5022.x;
          float _5060 = _5022.y;
          float _5063 = _5022.z;
          _929 = (((_981 * ((_981 * _5057) + vec3(_5029.x))) + vec3(_5029.y)) / ((_981 * ((_981 * _5057) + vec3(_5060))) + vec3(0.0599999986588954925537109375))) - vec3(_5022.w);
          vec3 _5098 = _929 * _5029.z;
          _929 = _55(_5098);
        } else {
          vec3 _5101 = _981;
          _929 = _55(_5101);
        }
      }
    }
    float _5104 = 0.5;
    if (((_324._m96 & 2u) != 0u) == false) {
      uvec2 _5114 = uvec2(_910);
      uint _5115 = _324._m41;
      _5104 = _108(_5114, _5115) + 0.03125;
    }
    float _5122 = _929.x;
    uint _5128 = _32(_5122) & 4286578688u;
    float _5121 = _22(_5128);
    int _5131 = 1015021568;
    _5121 *= _28(_5131);
    _929.x += (_5104 * _5121);
    float _5142 = _929.x;
    uint _5148 = _32(_5142) & 4294836224u;
    _929.x = _22(_5148);
    float _5152 = _929.y;
    uint _5157 = _32(_5152) & 4286578688u;
    float _5151 = _22(_5157);
    int _5159 = 1015021568;
    _5151 *= _28(_5159);
    _929.y += (_5104 * _5151);
    float _5170 = _929.y;
    uint _5175 = _32(_5170) & 4294836224u;
    _929.y = _22(_5175);
    float _5179 = _929.z;
    uint _5184 = _32(_5179) & 4286578688u;
    float _5178 = _22(_5184);
    int _5187 = 1023410176;
    _5178 *= _28(_5187);
    _929.z += (_5104 * _5178);
    float _5198 = _929.z;
    uint _5204 = _32(_5198) & 4294705152u;
    _929.z = _22(_5204);
  }
  imageStore(_5209, _910, vec4(_929, 1.0));
}

