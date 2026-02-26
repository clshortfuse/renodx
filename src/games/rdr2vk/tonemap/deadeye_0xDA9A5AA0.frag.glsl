#version 450

#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"

#extension GL_EXT_scalar_block_layout : require
#extension GL_EXT_samplerless_texture_functions : require

struct _12 {
  float _m0;
};

struct _14 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _13 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  _14 _m5;
};

struct _16 {
  vec4 _m0;
  vec4 _m1;
  mat4 _m2;
};

struct _17 {
  vec4 _m0;
  vec4 _m1;
};

struct _18 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
};

struct _19 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
};

struct _15 {
  _16 _m0[2];
  _17 _m1;
  _18 _m2;
  _19 _m3;
  vec4 _m4[3];
  vec2 _m5;
  vec2 _m6;
  vec2 _m7;
  float _m8;
  vec4 _m9[4];
  vec2 _m10;
  vec2 _m11;
  vec4 _m12;
  vec4 _m13;
  vec4 _m14;
  vec4 _m15[4];
  float _m16;
  int _m17;
  float _m18;
  float _m19;
};

struct _21 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
};

struct _22 {
  float _m0;
  float _m1;
  float _m2;
};

struct _23 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  vec3 _m4;
  int _m5;
};

struct _20 {
  _21 _m0;
  _22 _m1;
  _23 _m2;
  vec2 _m3;
  vec2 _m4;
  vec4 _m5;
  float _m6;
  float _m7;
  uint _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  float _m16;
  float _m17;
};

struct _24 {
  vec4 _m0[5];
};

struct _25 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _26 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _27 {
  int _m0;
  int _m1;
};

struct _28 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  vec2 _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
};

struct _11 {
  float _m0;
  vec4 _m1;
  float _m2;
  vec4 _m3;
  uvec4 _m4;
  uvec4 _m5;
  vec4 _m6;
  int _m7;
  int _m8;
  int _m9;
  vec4 _m10;
  vec4 _m11[8];
  uint _m12;
  vec3 _m13;
  vec3 _m14;
  vec2 _m15;
  vec2 _m16;
  mat3 _m17;
  vec3 _m18;
  vec3 _m19;
  float _m20;
  float _m21;
  vec3 _m22;
  vec3 _m23;
  vec3 _m24;
  vec3 _m25;
  vec4 _m26[13];
  int _m27;
  vec4 _m28;
  vec4 _m29;
  vec4 _m30;
  vec3 _m31;
  vec3 _m32;
  vec3 _m33;
  vec3 _m34;
  vec4 _m35;
  float _m36;
  float _m37;
  float _m38;
  float _m39;
  mat4 _m40;
  _12 _m41;
  _13 _m42;
  _15 _m43;
  _20 _m44;
  _24 _m45;
  _25 _m46;
  _26 _m47[5];
  vec4 _m48;
  _27 _m49;
  vec4 _m50;
  _28 _m51;
};

struct _32 {
  float _m0;
  vec3 _m1;
  vec3 _m2;
  vec3 _m3;
  float _m4;
  vec3 _m5;
  vec3 _m6;
  float _m7;
  vec3 _m8;
  vec3 _m9;
  vec2 _m10;
  vec3 _m11;
  vec4 _m12;
  vec4 _m13[4];
  vec4 _m14;
  float _m15;
  int _m16;
};

struct _33 {
  float _m0;
};

struct _35 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  uint _m6;
  uint _m7;
  uvec4 _m8;
};

struct _34 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  _35 _m3;
  vec2 _m4;
};

struct _37 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _38 {
  int _m0;
};

struct _39 {
  _38 _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _36 {
  vec3 _m0;
  vec3 _m1;
  float _m2;
  float _m3;
  _37 _m4;
  float _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  uint _m15;
  _38 _m16;
  _38 _m17;
  _39 _m18;
  vec4 _m19;
  float _m20;
  float _m21;
  float _m22;
  float _m23;
  float _m24;
  float _m25;
  float _m26;
  float _m27;
};

struct _41 {
  vec3 _m0;
  float _m1;
};

struct _42 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
};

struct _43 {
  vec2 _m0;
  vec2 _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
  float _m7;
  vec2 _m8;
  float _m9;
};

struct _44 {
  float _m0;
  _38 _m1;
};

struct _45 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _46 {
  _38 _m0;
  float _m1;
  float _m2;
};

struct _48 {
  int _m0;
};

struct _47 {
  _38 _m0;
  _48 _m1;
  _48 _m2;
};

struct _49 {
  _38 _m0;
};

struct _40 {
  _41 _m0;
  vec4 _m1;
  mat4 _m2;
  mat4 _m3;
  _42 _m4;
  _43 _m5;
  _44 _m6;
  _45 _m7;
  _46 _m8;
  _47 _m9;
  _49 _m10;
  float _m11;
  float _m12;
  float _m13;
};

struct _50 {
  float _m0;
  float _m1;
  vec2 _m2;
  vec2 _m3;
  vec2 _m4;
  float _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
};

struct _51 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec3 _m3;
  vec3 _m4;
  vec3 _m5;
  vec3 _m6;
  vec3 _m7;
};

struct _52 {
  vec4 _m0;
  vec4 _m1;
  vec3 _m2;
};

struct _53 {
  vec4 _m0;
  vec4 _m1;
};

struct _55 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
  float _m7;
  float _m8;
};

struct _54 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  float _m16;
  float _m17;
  float _m18;
  _55 _m19[2];
};

struct _56 {
  vec2 _m0;
  vec2 _m1;
  vec2 _m2;
  float _m3;
  float _m4;
  float _m5;
  vec2 _m6;
};

struct _57 {
  vec4 _m0;
  vec4 _m1;
  vec2 _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _58 {
  vec3 _m0;
  float _m1;
  float _m2;
};

struct _31 {
  float _m0[32];
  float _m1[32];
  _32 _m2;
  _32 _m3;
  _33 _m4;
  _34 _m5;
  _36 _m6;
  _40 _m7;
  _50 _m8;
  _51 _m9;
  float _m10;
  vec2 _m11;
  _52 _m12;
  _53 _m13;
  float _m14;
  float _m15;
  vec4 _m16;
  _54 _m17;
  _56 _m18;
  _57 _m19;
  vec4 _m20;
  float _m21;
  uint _m22;
  uvec2 _m23;
  uvec2 _m24;
  uint _m25;
  float _m26;
  float _m27;
  float _m28;
  float _m29;
  _58 _m30;
  int _m31;
};

struct _91 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _92 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _90 {
  _91 _m0;
  _92 _m1[11];
};

float _279;

layout(set = 0, binding = 98, scalar) readonly buffer _10_29 {
  _11 _m0[];
}
_29;

layout(set = 0, binding = 99, scalar) readonly buffer _30_59 {
  _31 _m0[];
}
_59;

layout(set = 0, binding = 20, std140) uniform _65_66 {
  float _m0;
  float _m1;
  uint _m2;
  uint _m3;
  uint _m4;
  uint _m5;
  float _m6;
  float _m7;
  float _m8;
  float _m9;
  float _m10;
  float _m11;
  float _m12;
  float _m13;
  float _m14;
  float _m15;
  uint _m16;
  uint _m17;
  uint _m18;
  uint _m19;
}
_66;

layout(set = 1, binding = 16, std140) uniform _67_68 {
  vec4 _m0;
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
  vec2 _m15;
  vec4 _m16;
  vec4 _m17;
  vec4 _m18;
  vec4 _m19;
  vec4 _m20;
  vec4 _m21;
  vec4 _m22;
  vec4 _m23;
  vec4 _m24;
  vec3 _m25;
  vec3 _m26;
  vec3 _m27;
  vec4 _m28;
  vec4 _m29;
  vec4 _m30;
  vec4 _m31;
  vec4 _m32;
  vec4 _m33;
  vec4 _m34;
  vec4 _m35;
  vec4 _m36;
  vec4 _m37;
  vec3 _m38;
  vec4 _m39;
  vec4 _m40;
  vec4 _m41;
  vec4 _m42;
  mat4 _m43;
  vec4 _m44;
  vec4 _m45;
  vec4 _m46;
  vec4 _m47;
  vec4 _m48;
  vec4 _m49;
  vec4 _m50;
  vec4 _m51;
  vec4 _m52;
  vec4 _m53;
  vec4 _m54;
  vec4 _m55;
  vec4 _m56;
  vec4 _m57;
  float _m58;
  vec4 _m59;
  vec4 _m60;
  float _m61;
  vec4 _m62;
  vec4 _m63;
  vec2 _m64;
  vec4 _m65;
  vec4 _m66;
  vec4 _m67;
  vec4 _m68;
  vec4 _m69;
  vec4 _m70;
  vec4 _m71;
  vec4 _m72;
  vec4 _m73;
  vec4 _m74;
  vec4 _m75;
  vec4 _m76;
  vec4 _m77;
  vec3 _m78;
  float _m79;
  vec4 _m80;
  vec4 _m81;
  vec4 _m82;
  vec4 _m83;
  vec4 _m84;
  vec4 _m85;
}
_68;

layout(set = 0, binding = 214, std430) readonly buffer _89_93 {
  _90 _m0[];
}
_93;

layout(set = 1, binding = 32) uniform sampler _8;
layout(set = 1, binding = 34) uniform sampler _9;
layout(set = 0, binding = 121) uniform texture2DArray _62;
layout(set = 0, binding = 140) uniform texture2D _63;
layout(set = 1, binding = 174) uniform texture2D _69;
layout(set = 1, binding = 177) uniform texture2D _70;
layout(set = 1, binding = 185) uniform texture1D _72;
layout(set = 1, binding = 40) uniform sampler _73;
layout(set = 1, binding = 186) uniform texture2D _74;
layout(set = 1, binding = 189) uniform texture2D _75;
layout(set = 1, binding = 194) uniform texture2D _76;
layout(set = 1, binding = 196) uniform texture2D _77;
layout(set = 1, binding = 197) uniform texture2D _78;
layout(set = 1, binding = 198) uniform texture2D _79;
layout(set = 1, binding = 199) uniform texture2D _80;
layout(set = 1, binding = 200) uniform texture2D _81;
layout(set = 1, binding = 201) uniform texture2D _82;
layout(set = 1, binding = 202) uniform texture2D _83;
layout(set = 1, binding = 203) uniform texture2D _84;
layout(set = 1, binding = 204) uniform texture2D _85;
layout(set = 1, binding = 205) uniform texture2D _86;
layout(set = 1, binding = 207) uniform texture2D _87;
layout(set = 1, binding = 212) uniform samplerBuffer _88;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  float _297 = _68._m0.z / ((1.0 + _68._m0.w) - textureLod(sampler2D(_69, _8), _4.xy, 0.0).x);
  vec4 _301 = texture(sampler2D(_74, _73), _4.xy);
  vec3 _315 = vec4(vec4(_301.xyz, 0.0).xyz * _29._m0[0u]._m1.w, _279).xyz;
  vec4 _318 = texelFetch(_88, int(0u));
  vec4 _319 = texelFetch(_88, int(1u));
  float _324 = dot(_315 * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
  bool _349;
  vec3 _350;
  if (floatBitsToInt(_68._m61) != 0) {
    vec4 _335 = texture(sampler2D(_86, _73), _4.xy);
    float _336 = _335.w;
    bool _338 = (_336 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _347;
    if (_338) {
      _347 = _335.xyz;
    } else {
      _347 = _335.xyz + (_315 * (1.0 - _336));
    }
    _349 = _338 ? true : false;
    _350 = _347;
  } else {
    _349 = false;
    _350 = _315;
  }
  vec3 _354 = min(_350 * texelFetch(_63, ivec2(0), 0).x, vec3(65504.0));
  bool _355 = !_349;
  float _491;
  vec3 _492;
  if (_355) {
    float _414;
    if (floatBitsToInt(_68._m70.x) != 0) {
      float _377 = clamp(dot(texture(sampler2D(_70, _9), _4.xy).xyz * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _68._m72.z, _68._m72.w);
      float _400 = clamp(((((_68._m70.y * log(_377 + _68._m72.x)) + _68._m70.z) - 10.0) + (_68._m72.y * _377)) + _68._m65.w, _68._m66.x, _68._m66.y);
      _414 = pow(2.0, mix(_5, clamp(_400 + ((abs(_400) * _68._m66.z) * float(int(sign(_400)))), _68._m66.x, _68._m66.y), clamp(_68._m70.x, 0.0, 1.0)));
    } else {
      _414 = _4.z;
    }
    vec4 _427 = texture(sampler2D(_75, _9), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _68._m16.w) + _68._m16.xy));
    vec3 _437 = max(_354 * vec3(0.5), _354 + vec3((_324 * (_427.w - 0.5)) * _68._m16.z));
    vec3 _490;
    if (floatBitsToInt(_68._m51.w) != 0) {
      vec2 _466 = ((_4.xy - _68._m50.xy) * mat2(vec2(_68._m52.x, _68._m52.y), vec2(_68._m52.z, _68._m52.w))) * _68._m50.zw;
      float _470 = max((dot(_466, _466) - _68._m53.x) * _68._m53.w, 0.0);
      bool _471 = _470 < 1.0;
      _490 = mix(_437, (_437 * _68._m51.xyz) * _68._m51.w, vec3(_471 ? (_471 ? (1.0 - pow(2.0, (-10.0) * _470)) : 1.0) : (0.9980499744415283203125 + (((_470 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_470 - 2.0)) : 0.0))));
    } else {
      _490 = _437;
    }
    _491 = _414;
    _492 = _490;
  } else {
    _491 = _4.z;
    _492 = _354;
  }
  vec3 _529 = _492 * mix(mix(_68._m54.xyz, _68._m56.xyz, vec3(clamp(clamp(_4.y * _68._m57.y, 0.0, 1.0) + _68._m54.w, 0.0, 1.0))), mix(_68._m56.xyz, _68._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _68._m56.w, 0.0, 1.0) * _68._m57.x, 0.0, 1.0) - _68._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _532 = _66._m3 != 0u;
  vec3 _595;
  if (_532) {
    vec3 _572 = max(vec3(0.0), _529 * (_491 / _66._m6));
    vec3 _575 = _572 * _318.x;
    _595 = (((((_572 * (_575 + vec3(_319.x))) + vec3(_319.y)) / ((_572 * (_575 + vec3(_318.y))) + vec3(_319.z))) - vec3(_319.w)) * ((_66._m4 != 0u) ? _66._m10 : _318.z)) * _66._m6;
  } else {
    vec3 _538 = max(vec3(0.0), _529 * _491);
    vec3 _541 = _538 * _318.x;
    _595 = clamp(((((_538 * (_541 + vec3(_319.x))) + vec3(_319.y)) / ((_538 * (_541 + vec3(_318.y))) + vec3(_319.z))) - vec3(_319.w)) * _318.z, vec3(0.0), vec3(1.0));
  }
  vec3 _643;
  if (_355) {
    vec3 _642;
    if (floatBitsToInt(_68._m47.w) != 0) {
      vec2 _628 = ((_4.xy - _68._m46.xy) * mat2(vec2(_68._m48.x, _68._m48.y), vec2(_68._m48.z, _68._m48.w))) * _68._m46.zw;
      _642 = mix(_595, _68._m47.xyz, vec3(_68._m47.w * texture(sampler1D(_72, _9), min(1.0, max((dot(_628, _628) - _68._m49.x) * _68._m49.w, 0.0))).w));
    } else {
      _642 = _595;
    }
    _643 = _642;
  } else {
    _643 = _595;
  }
  bool _664 = _532 && (!(_66._m2 != 0u));

#if 0
  vec3 _666 = EncodeLUTInput(_643, _66._m11, _66._m12, _66._m13, _66._m14, _664);
#else
  vec3 _666 = mix(mix((pow(_643, vec3(_66._m12)) * _66._m13) - vec3(_66._m14), _643 * _66._m11, lessThan(_643, vec3(0.003130800090730190277099609375))), _643, bvec3(_664));
#endif

  vec3 _822;
  if (_355 && (floatBitsToInt(_68._m19.x) != 0)) {
    vec2 _678 = _4.xy * _68._m17.w;
    float _744 = (((((((fract(sin(dot(_678 + vec2(0.070000000298023223876953125 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_678 + vec2(0.10999999940395355224609375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_678 + vec2(0.12999999523162841796875 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_678 + vec2(0.17000000178813934326171875 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_678 + vec2(0.189999997615814208984375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_678 + vec2(0.23000000417232513427734375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_678 + vec2(0.2899999916553497314453125 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_678 + vec2(0.310000002384185791015625 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _746 = clamp(_744 + _68._m17.z, 0.0, 1.0);
    vec3 _821;
    do {
      if (!(floatBitsToInt(_68._m18.w) != 0)) {
        _821 = vec3(_746);
        break;
      }
      float _769;
      if (floatBitsToInt(_68._m18.y) != 0) {
        float _764 = dot(_666, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _769 = mix(_746, _746 * 0.5, (_764 * _764) * _764);
      } else {
        _769 = _746;
      }
      vec3 _820;
      if (floatBitsToInt(_68._m19.z) != 0) {
        vec3 _802 = vec3(_769);
        vec3 _804 = _802 * 2.0;
        _820 = mix(_666, mix(((_666 * 2.0) * (vec3(1.0) - _802)) + (sqrt(_666) * (_804 - vec3(1.0))), (_804 * _666) + ((_666 * _666) * (vec3(1.0) - _804)), lessThan(_802, vec3(0.5))), vec3(_68._m18.x));
      } else {
        vec3 _801;
        if (floatBitsToInt(_68._m19.w) != 0) {
          vec3 _789 = vec3(_769);
          _801 = mix(_666, mix(vec3(1.0) - (((vec3(1.0) - _789) * 2.0) * (vec3(1.0) - _666)), (_789 * 2.0) * _666, lessThan(_666, vec3(0.5))), vec3(_68._m18.x));
        } else {
          _801 = clamp(max(_666 * 0.02500000037252902984619140625, _666 + vec3((_769 - 0.5) * _68._m18.x)), vec3(0.0), vec3(1.0));
        }
        _820 = _801;
      }
      _821 = _820;
      break;
    } while (false);
    _822 = _821;
  } else {
    _822 = _666;
  }
  vec3 _824 = max(_822 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _825 = _824.y;
  vec3 _850 = mix(_822, clamp((_68._m81.xyz * (_825 * ((1.33000004291534423828125 * (1.0 + ((_825 + _824.z) / _824.x))) - 1.67999994754791259765625))) * _68._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _324)) * _68._m82.x) + _68._m82.y, 0.0, 1.0)));
  vec3 _880;
  if (floatBitsToInt(_68._m84.w) != 0) {
    _880 = mix(_850, texture(sampler2D(_87, _9), ((((_4.xy - vec2(0.5)) * _68._m84.z) / mix(_68._m85.wx, _68._m85.zy, _4.yx)) - _68._m84.xy) + vec2(0.5)).xyz, vec3(_68._m84.w));
  } else {
    _880 = _850;
  }
  vec3 _1191;
  if (_355) {
    float _899 = max(max(_880.x, max(_880.y, _880.z)), 9.9999997473787516355514526367188e-05);
    float _905 = (_664 && (!(_66._m5 != 0u))) ? 1.0 : (((_899 > _66._m7) ? ((_899 * _66._m8) + _66._m9) : _899) / _899);
    vec3 _906 = _880 * _905;
    float _909 = _906.z;
    float _911 = floor(_909 * 14.99989986419677734375);
    float _917 = (_911 * 0.0625) + (_906.x * 0.05859375);
    float _919 = _906.y * 0.9375;
    vec4 _923 = texture(sampler2D(_83, _9), vec2(0.001953125, 0.03125) + vec2(_917, _919));
    vec4 _929 = texture(sampler2D(_83, _9), vec2(0.001953125, 0.03125) + vec2(_917 + 0.0625, _919));
    vec3 _932 = mix(_923.xyz, _929.xyz, vec3((_909 * 15.0) - _911));
    vec3 _1188;
    if (_93._m0[0u]._m0._m0 > 0) {
      vec4 _940 = texture(sampler2D(_76, _8), _4.xy);
      vec4 _943 = _940 * _93._m0[0u]._m0._m1;
      vec4 _946 = texture(sampler2D(_85, _9), _4.xy);
      float _948 = dot(_946.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
      float _950 = clamp(_943.x, 0.0, 1.0);
      float _952 = _948 * _950;
      vec3 _982;
      if (_952 != 0.0) {
        float _956 = _932.z;
        float _958 = floor(_956 * 14.99989986419677734375);
        float _964 = (_958 * 0.0625) + (_932.x * 0.05859375);
        float _966 = _932.y * 0.9375;
        _982 = mix(_932, mix(texture(sampler2D(_79, _9), vec2(0.001953125, 0.03125) + vec2(_964, _966)).xyz, texture(sampler2D(_79, _9), vec2(0.001953125, 0.03125) + vec2(_964 + 0.0625, _966)).xyz, vec3((_956 * 15.0) - _958)), vec3(_952));
      } else {
        _982 = _932;
      }
      float _984 = clamp(_943.y, 0.0, 1.0);
      float _986 = _948 * _984;
      vec3 _1016;
      if (_986 != 0.0) {
        float _992 = floor(_982.z * 14.99989986419677734375);
        float _998 = (_992 * 0.0625) + (_982.x * 0.05859375);
        float _1000 = _982.y * 0.9375;
        _1016 = mix(_982, mix(texture(sampler2D(_80, _9), vec2(0.001953125, 0.03125) + vec2(_998, _1000)).xyz, texture(sampler2D(_80, _9), vec2(0.001953125, 0.03125) + vec2(_998 + 0.0625, _1000)).xyz, vec3((_982.z * 15.0) - _992)), vec3(_986));
      } else {
        _1016 = _982;
      }
      float _1018 = clamp(_943.z, 0.0, 1.0);
      float _1020 = _948 * _1018;
      vec3 _1050;
      if (_1020 != 0.0) {
        float _1026 = floor(_1016.z * 14.99989986419677734375);
        float _1032 = (_1026 * 0.0625) + (_1016.x * 0.05859375);
        float _1034 = _1016.y * 0.9375;
        _1050 = mix(_1016, mix(texture(sampler2D(_81, _9), vec2(0.001953125, 0.03125) + vec2(_1032, _1034)).xyz, texture(sampler2D(_81, _9), vec2(0.001953125, 0.03125) + vec2(_1032 + 0.0625, _1034)).xyz, vec3((_1016.z * 15.0) - _1026)), vec3(_1020));
      } else {
        _1050 = _1016;
      }
      float _1052 = clamp(_943.w, 0.0, 1.0);
      float _1054 = _948 * _1052;
      vec3 _1084;
      if (_1054 != 0.0) {
        float _1060 = floor(_1050.z * 14.99989986419677734375);
        float _1066 = (_1060 * 0.0625) + (_1050.x * 0.05859375);
        float _1068 = _1050.y * 0.9375;
        _1084 = mix(_1050, mix(texture(sampler2D(_82, _9), vec2(0.001953125, 0.03125) + vec2(_1066, _1068)).xyz, texture(sampler2D(_82, _9), vec2(0.001953125, 0.03125) + vec2(_1066 + 0.0625, _1068)).xyz, vec3((_1050.z * 15.0) - _1060)), vec3(_1054));
      } else {
        _1084 = _1050;
      }
      float _1120 = floor(_1084.z * 14.99989986419677734375);
      float _1126 = (_1120 * 0.0625) + (_1084.x * 0.05859375);
      float _1128 = _1084.y * 0.9375;
      vec3 _1143 = mix(_1084, mix(texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_1126, _1128)).xyz, texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_1126 + 0.0625, _1128)).xyz, vec3((_1084.z * 15.0) - _1120)), vec3(clamp(((_297 < _93._m0[0u]._m1[0]._m2) ? clamp((_297 - _93._m0[0u]._m1[0]._m0) * _93._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_297 - _93._m0[0u]._m1[0]._m2) * _93._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _93._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _1155 = _1143.z;
      float _1157 = floor(_1155 * 14.99989986419677734375);
      float _1163 = (_1157 * 0.0625) + (_1143.x * 0.05859375);
      float _1165 = _1143.y * 0.9375;
      _1188 = mix(_1143, mix(_1143, mix(texture(sampler2D(_78, _9), vec2(0.001953125, 0.03125) + vec2(_1163, _1165)).xyz, texture(sampler2D(_78, _9), vec2(0.001953125, 0.03125) + vec2(_1163 + 0.0625, _1165)).xyz, vec3((_1155 * 15.0) - _1157)), vec3(clamp(((_297 < _93._m0[0u]._m1[1]._m2) ? clamp((_297 - _93._m0[0u]._m1[1]._m0) * _93._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_297 - _93._m0[0u]._m1[1]._m2) * _93._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _93._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_84, _9), _4.xy).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) * (1.0 - clamp(((_950 + _984) + _1018) + _1052, 0.0, 1.0))));
    } else {
      _1188 = _932;
    }
    _1191 = _1188 / vec3(_905);
  } else {
    _1191 = _880;
  }

#if 0
  _1191 = DecodeLUTInput(_1191);
#endif

  vec4 _1196 = vec4(_1191, dot(_1191, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1197 = _1196.xyz;
  ivec4 _1240 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_59._m0[0u]._m22) & 31), 0u));
  vec3 _1248 = (vec3(texelFetch(_62, _1240.xyz, _1240.w).x) * 2.0) - vec3(1.0);
  vec3 _1259;
  if (_532) {
    _1259 = vec3(ivec3(sign(_1248))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1248)));
  } else {
    _1259 = _1248;
  }
  vec3 _1261 = _1197 + (_1259 * mix(_68._m39.xyz, _68._m40.xyz, pow(clamp((mix(vec3(max(_1191.x, max(_1191.y, _1191.z))), _1197, bvec3(floatBitsToInt(_68._m41.w) != 0)) - _68._m42.xyz) * _68._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_68._m42.w))));
  vec4 _1262 = vec4(_1261.x, _1261.y, _1261.z, _1196.w);
  vec4 _1267;
  if (!_532) {
    _1267 = clamp(_1262, vec4(0.0), vec4(1.0));
  } else {
    _1267 = _1262;
  }
  _6 = _1267;
}

