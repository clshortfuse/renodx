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

struct _92 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _93 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _91 {
  _92 _m0;
  _93 _m1[11];
};

float _280;

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

layout(set = 0, binding = 214, std430) readonly buffer _90_94 {
  _91 _m0[];
}
_94;

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
layout(set = 1, binding = 206) uniform texture2D _87;
layout(set = 1, binding = 207) uniform texture2D _88;
layout(set = 1, binding = 212) uniform samplerBuffer _89;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _290 = texture(sampler2D(_87, _8), _4.xy);
  vec2 _291 = _290.xy;
  float _302 = _68._m0.z / ((1.0 + _68._m0.w) - textureLod(sampler2D(_69, _8), _291, 0.0).x);
  vec4 _306 = texture(sampler2D(_74, _73), _291);
  vec3 _320 = vec4(vec4(_306.xyz, 0.0).xyz * _29._m0[0u]._m1.w, _280).xyz;
  vec4 _323 = texelFetch(_89, int(0u));
  vec4 _324 = texelFetch(_89, int(1u));
  float _329 = dot(_320 * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
  bool _354;
  vec3 _355;
  if (floatBitsToInt(_68._m61) != 0) {
    vec4 _340 = texture(sampler2D(_86, _73), _4.xy);
    float _341 = _340.w;
    bool _343 = (_341 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _352;
    if (_343) {
      _352 = _340.xyz;
    } else {
      _352 = _340.xyz + (_320 * (1.0 - _341));
    }
    _354 = _343 ? true : false;
    _355 = _352;
  } else {
    _354 = false;
    _355 = _320;
  }
  vec3 _359 = min(_355 * texelFetch(_63, ivec2(0), 0).x, vec3(GetTonemapClampMax()));
  bool _360 = !_354;
  float _496;
  vec3 _497;
  if (_360) {
    float _419;
    if (floatBitsToInt(_68._m70.x) != 0) {
      float _382 = clamp(dot(texture(sampler2D(_70, _9), _291).xyz * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _68._m72.z, _68._m72.w);
      float _405 = clamp(((((_68._m70.y * log(_382 + _68._m72.x)) + _68._m70.z) - 10.0) + (_68._m72.y * _382)) + _68._m65.w, _68._m66.x, _68._m66.y);
      _419 = pow(2.0, mix(_5, clamp(_405 + ((abs(_405) * _68._m66.z) * float(int(sign(_405)))), _68._m66.x, _68._m66.y), clamp(_68._m70.x, 0.0, 1.0)));
    } else {
      _419 = _4.z;
    }
    vec4 _432 = texture(sampler2D(_75, _9), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _68._m16.w) + _68._m16.xy));
    vec3 _442 = max(_359 * vec3(0.5), _359 + vec3((_329 * (_432.w - 0.5)) * _68._m16.z));
    vec3 _495;
    if (floatBitsToInt(_68._m51.w) != 0) {
      vec2 _471 = ((_4.xy - _68._m50.xy) * mat2(vec2(_68._m52.x, _68._m52.y), vec2(_68._m52.z, _68._m52.w))) * _68._m50.zw;
      float _475 = CUSTOM_VIGNETTE * max((dot(_471, _471) - _68._m53.x) * _68._m53.w, 0.0);
      bool _476 = _475 < 1.0;
      _495 = mix(_442, (_442 * _68._m51.xyz) * _68._m51.w, vec3(_476 ? (_476 ? (1.0 - pow(2.0, (-10.0) * _475)) : 1.0) : (0.9980499744415283203125 + (((_475 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_475 - 2.0)) : 0.0))));
    } else {
      _495 = _442;
    }
    _496 = _419;
    _497 = _495;
  } else {
    _496 = _4.z;
    _497 = _359;
  }
  vec3 _534 = _497 * mix(mix(_68._m54.xyz, _68._m56.xyz, vec3(clamp(clamp(_4.y * _68._m57.y, 0.0, 1.0) + _68._m54.w, 0.0, 1.0))), mix(_68._m56.xyz, _68._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _68._m56.w, 0.0, 1.0) * _68._m57.x, 0.0, 1.0) - _68._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _537 = _66._m3 != 0u;
#if 1
  vec3 _600 = ApplyToneMap(_534, _537, _496, _66._m6, _66._m4, _66._m10, _323.rgb, _324);
#else
  vec3 _600;
  if (_537) {
    vec3 _577 = max(vec3(0.0), _534 * (_496 / _66._m6));
    vec3 _580 = _577 * _323.x;
    _600 = (((((_577 * (_580 + vec3(_324.x))) + vec3(_324.y)) / ((_577 * (_580 + vec3(_323.y))) + vec3(_324.z))) - vec3(_324.w)) * ((_66._m4 != 0u) ? _66._m10 : _323.z)) * _66._m6;
  } else {
    vec3 _543 = max(vec3(0.0), _534 * _496);
    vec3 _546 = _543 * _323.x;
    _600 = clamp(((((_543 * (_546 + vec3(_324.x))) + vec3(_324.y)) / ((_543 * (_546 + vec3(_323.y))) + vec3(_324.z))) - vec3(_324.w)) * _323.z, vec3(0.0), vec3(1.0));
  }
#endif
  vec3 _648;
  if (_360) {
    vec3 _647;
    if (floatBitsToInt(_68._m47.w) != 0) {
      vec2 _633 = ((_4.xy - _68._m46.xy) * mat2(vec2(_68._m48.x, _68._m48.y), vec2(_68._m48.z, _68._m48.w))) * _68._m46.zw;
      _647 = mix(_600, _68._m47.xyz, vec3(_68._m47.w * texture(sampler1D(_72, _9), min(1.0, max((dot(_633, _633) - _68._m49.x) * _68._m49.w, 0.0))).w));
    } else {
      _647 = _600;
    }
    _648 = _647;
  } else {
    _648 = _600;
  }
  bool _669 = _537 && (!(_66._m2 != 0u));

#if 1
  vec3 _671 = EncodeLUTInput(_648, _66._m11, _66._m12, _66._m13, _66._m14, _669);
#else
  vec3 _671 = mix(mix((pow(_648, vec3(_66._m12)) * _66._m13) - vec3(_66._m14), _648 * _66._m11, lessThan(_648, vec3(0.003130800090730190277099609375))), _648, bvec3(_669));
#endif

  vec3 _827;
  if (_360 && (floatBitsToInt(_68._m19.x) != 0)) {
    vec2 _683 = _4.xy * _68._m17.w;
    float _749 = (((((((fract(sin(dot(_683 + vec2(0.070000000298023223876953125 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_683 + vec2(0.10999999940395355224609375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_683 + vec2(0.12999999523162841796875 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_683 + vec2(0.17000000178813934326171875 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_683 + vec2(0.189999997615814208984375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_683 + vec2(0.23000000417232513427734375 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_683 + vec2(0.2899999916553497314453125 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_683 + vec2(0.310000002384185791015625 * _68._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _751 = clamp(_749 + _68._m17.z, 0.0, 1.0);
    vec3 _826;
    do {
      if (!(floatBitsToInt(_68._m18.w) != 0)) {
        _826 = vec3(_751);
        break;
      }
      float _774;
      if (floatBitsToInt(_68._m18.y) != 0) {
        float _769 = dot(_671, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _774 = mix(_751, _751 * 0.5, (_769 * _769) * _769);
      } else {
        _774 = _751;
      }
      vec3 _825;
      if (floatBitsToInt(_68._m19.z) != 0) {
        vec3 _807 = vec3(_774);
        vec3 _809 = _807 * 2.0;
        _825 = mix(_671, mix(((_671 * 2.0) * (vec3(1.0) - _807)) + (sqrt(_671) * (_809 - vec3(1.0))), (_809 * _671) + ((_671 * _671) * (vec3(1.0) - _809)), lessThan(_807, vec3(0.5))), vec3(_68._m18.x));
      } else {
        vec3 _806;
        if (floatBitsToInt(_68._m19.w) != 0) {
          vec3 _794 = vec3(_774);
          _806 = mix(_671, mix(vec3(1.0) - (((vec3(1.0) - _794) * 2.0) * (vec3(1.0) - _671)), (_794 * 2.0) * _671, lessThan(_671, vec3(0.5))), vec3(_68._m18.x));
        } else {
          _806 = clamp(max(_671 * 0.02500000037252902984619140625, _671 + vec3((_774 - 0.5) * _68._m18.x)), vec3(0.0), vec3(1.0));
        }
        _825 = _806;
      }
      _826 = _825;
      break;
    } while (false);
    _827 = _826;
  } else {
    _827 = _671;
  }
  vec3 _829 = max(_827 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _830 = _829.y;
  vec3 _855 = mix(_827, clamp((_68._m81.xyz * (_830 * ((1.33000004291534423828125 * (1.0 + ((_830 + _829.z) / _829.x))) - 1.67999994754791259765625))) * _68._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _329)) * _68._m82.x) + _68._m82.y, 0.0, 1.0)));
  vec3 _885;
  if (floatBitsToInt(_68._m84.w) != 0) {
    _885 = mix(_855, texture(sampler2D(_88, _9), ((((_4.xy - vec2(0.5)) * _68._m84.z) / mix(_68._m85.wx, _68._m85.zy, _4.yx)) - _68._m84.xy) + vec2(0.5)).xyz, vec3(_68._m84.w));
  } else {
    _885 = _855;
  }
  vec3 _1196;
  if (_360) {
#if 1
    float _910 = CompressLUTInput(_885, _669, _66._m5, _66._m7, _66._m8, _66._m9);
#else
    float _904 = max(max(_885.x, max(_885.y, _885.z)), 9.9999997473787516355514526367188e-05);
    float _910 = (_669 && (!(_66._m5 != 0u))) ? 1.0 : (((_904 > _66._m7) ? ((_904 * _66._m8) + _66._m9) : _904) / _904);
#endif
    vec3 _911 = _885 * _910;
    float _914 = _911.z;
    float _916 = floor(_914 * 14.99989986419677734375);
    float _922 = (_916 * 0.0625) + (_911.x * 0.05859375);
    float _924 = _911.y * 0.9375;
    vec4 _928 = texture(sampler2D(_83, _9), vec2(0.001953125, 0.03125) + vec2(_922, _924));
    vec4 _934 = texture(sampler2D(_83, _9), vec2(0.001953125, 0.03125) + vec2(_922 + 0.0625, _924));
    vec3 _937 = mix(_928.xyz, _934.xyz, vec3((_914 * 15.0) - _916));
    vec3 _1193;
    if (_94._m0[0u]._m0._m0 > 0) {
      vec4 _945 = texture(sampler2D(_76, _8), _291);
      vec4 _948 = _945 * _94._m0[0u]._m0._m1;
      vec4 _951 = texture(sampler2D(_85, _9), _291);
      float _953 = dot(_951.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
      float _955 = clamp(_948.x, 0.0, 1.0);
      float _957 = _953 * _955;
      vec3 _987;
      if (_957 != 0.0) {
        float _961 = _937.z;
        float _963 = floor(_961 * 14.99989986419677734375);
        float _969 = (_963 * 0.0625) + (_937.x * 0.05859375);
        float _971 = _937.y * 0.9375;
        _987 = mix(_937, mix(texture(sampler2D(_79, _9), vec2(0.001953125, 0.03125) + vec2(_969, _971)).xyz, texture(sampler2D(_79, _9), vec2(0.001953125, 0.03125) + vec2(_969 + 0.0625, _971)).xyz, vec3((_961 * 15.0) - _963)), vec3(_957));
      } else {
        _987 = _937;
      }
      float _989 = clamp(_948.y, 0.0, 1.0);
      float _991 = _953 * _989;
      vec3 _1021;
      if (_991 != 0.0) {
        float _997 = floor(_987.z * 14.99989986419677734375);
        float _1003 = (_997 * 0.0625) + (_987.x * 0.05859375);
        float _1005 = _987.y * 0.9375;
        _1021 = mix(_987, mix(texture(sampler2D(_80, _9), vec2(0.001953125, 0.03125) + vec2(_1003, _1005)).xyz, texture(sampler2D(_80, _9), vec2(0.001953125, 0.03125) + vec2(_1003 + 0.0625, _1005)).xyz, vec3((_987.z * 15.0) - _997)), vec3(_991));
      } else {
        _1021 = _987;
      }
      float _1023 = clamp(_948.z, 0.0, 1.0);
      float _1025 = _953 * _1023;
      vec3 _1055;
      if (_1025 != 0.0) {
        float _1031 = floor(_1021.z * 14.99989986419677734375);
        float _1037 = (_1031 * 0.0625) + (_1021.x * 0.05859375);
        float _1039 = _1021.y * 0.9375;
        _1055 = mix(_1021, mix(texture(sampler2D(_81, _9), vec2(0.001953125, 0.03125) + vec2(_1037, _1039)).xyz, texture(sampler2D(_81, _9), vec2(0.001953125, 0.03125) + vec2(_1037 + 0.0625, _1039)).xyz, vec3((_1021.z * 15.0) - _1031)), vec3(_1025));
      } else {
        _1055 = _1021;
      }
      float _1057 = clamp(_948.w, 0.0, 1.0);
      float _1059 = _953 * _1057;
      vec3 _1089;
      if (_1059 != 0.0) {
        float _1065 = floor(_1055.z * 14.99989986419677734375);
        float _1071 = (_1065 * 0.0625) + (_1055.x * 0.05859375);
        float _1073 = _1055.y * 0.9375;
        _1089 = mix(_1055, mix(texture(sampler2D(_82, _9), vec2(0.001953125, 0.03125) + vec2(_1071, _1073)).xyz, texture(sampler2D(_82, _9), vec2(0.001953125, 0.03125) + vec2(_1071 + 0.0625, _1073)).xyz, vec3((_1055.z * 15.0) - _1065)), vec3(_1059));
      } else {
        _1089 = _1055;
      }
      float _1125 = floor(_1089.z * 14.99989986419677734375);
      float _1131 = (_1125 * 0.0625) + (_1089.x * 0.05859375);
      float _1133 = _1089.y * 0.9375;
      vec3 _1148 = mix(_1089, mix(texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_1131, _1133)).xyz, texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_1131 + 0.0625, _1133)).xyz, vec3((_1089.z * 15.0) - _1125)), vec3(clamp(((_302 < _94._m0[0u]._m1[0]._m2) ? clamp((_302 - _94._m0[0u]._m1[0]._m0) * _94._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_302 - _94._m0[0u]._m1[0]._m2) * _94._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _94._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _1160 = _1148.z;
      float _1162 = floor(_1160 * 14.99989986419677734375);
      float _1168 = (_1162 * 0.0625) + (_1148.x * 0.05859375);
      float _1170 = _1148.y * 0.9375;
      _1193 = mix(_1148, mix(_1148, mix(texture(sampler2D(_78, _9), vec2(0.001953125, 0.03125) + vec2(_1168, _1170)).xyz, texture(sampler2D(_78, _9), vec2(0.001953125, 0.03125) + vec2(_1168 + 0.0625, _1170)).xyz, vec3((_1160 * 15.0) - _1162)), vec3(clamp(((_302 < _94._m0[0u]._m1[1]._m2) ? clamp((_302 - _94._m0[0u]._m1[1]._m0) * _94._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_302 - _94._m0[0u]._m1[1]._m2) * _94._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _94._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_84, _9), _291).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) * (1.0 - clamp(((_955 + _989) + _1023) + _1057, 0.0, 1.0))));
    } else {
      _1193 = _937;
    }
    _1196 = _1193 / vec3(_910);
  } else {
    _1196 = _885;
  }

#if 1
  _1196 = DecodeLUTInput(_1196, _885);
#endif

  vec4 _1201 = vec4(_1196, dot(_1196, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1202 = _1201.xyz;
  ivec4 _1245 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_59._m0[0u]._m22) & 31), 0u));
  vec3 _1253 = (vec3(texelFetch(_62, _1245.xyz, _1245.w).x) * 2.0) - vec3(1.0);
  vec3 _1264;
  if (_537) {
    _1264 = vec3(ivec3(sign(_1253))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1253)));
  } else {
    _1264 = _1253;
  }
  vec3 _1266 = _1202 + CUSTOM_DITHERING * (_1264 * mix(_68._m39.xyz, _68._m40.xyz, pow(clamp((mix(vec3(max(_1196.x, max(_1196.y, _1196.z))), _1202, bvec3(floatBitsToInt(_68._m41.w) != 0)) - _68._m42.xyz) * _68._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_68._m42.w))));
  vec4 _1267 = vec4(_1266.x, _1266.y, _1266.z, _1201.w);
  vec4 _1272;
  if (!_537) {
    _1272 = clamp(_1267, vec4(0.0), vec4(1.0));
  } else {
    _1272 = _1267;
  }
  _6 = _1272;


  _6.rgb = ApplyGradingAndDisplayMap(_6.rgb, _4.xy);
}


