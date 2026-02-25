#version 450

#extension GL_GOOGLE_include_directive : require
#include "./output.glsl"

#extension GL_EXT_scalar_block_layout : require
#extension GL_EXT_samplerless_texture_functions : require

struct _12 {
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

struct _13 {
  float _m0;
};

struct _15 {
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

struct _14 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  _15 _m3;
  vec2 _m4;
};

struct _17 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _18 {
  int _m0;
};

struct _19 {
  _18 _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _16 {
  vec3 _m0;
  vec3 _m1;
  float _m2;
  float _m3;
  _17 _m4;
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
  _18 _m16;
  _18 _m17;
  _19 _m18;
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

struct _21 {
  vec3 _m0;
  float _m1;
};

struct _22 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
};

struct _23 {
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

struct _24 {
  float _m0;
  _18 _m1;
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
  _18 _m0;
  float _m1;
  float _m2;
};

struct _28 {
  int _m0;
};

struct _27 {
  _18 _m0;
  _28 _m1;
  _28 _m2;
};

struct _29 {
  _18 _m0;
};

struct _20 {
  _21 _m0;
  vec4 _m1;
  mat4 _m2;
  mat4 _m3;
  _22 _m4;
  _23 _m5;
  _24 _m6;
  _25 _m7;
  _26 _m8;
  _27 _m9;
  _29 _m10;
  float _m11;
  float _m12;
  float _m13;
};

struct _30 {
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

struct _31 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec3 _m3;
  vec3 _m4;
  vec3 _m5;
  vec3 _m6;
  vec3 _m7;
};

struct _32 {
  vec4 _m0;
  vec4 _m1;
  vec3 _m2;
};

struct _33 {
  vec4 _m0;
  vec4 _m1;
};

struct _35 {
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

struct _34 {
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
  _35 _m19[2];
};

struct _36 {
  vec2 _m0;
  vec2 _m1;
  vec2 _m2;
  float _m3;
  float _m4;
  float _m5;
  vec2 _m6;
};

struct _37 {
  vec4 _m0;
  vec4 _m1;
  vec2 _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _38 {
  vec3 _m0;
  float _m1;
  float _m2;
};

struct _11 {
  float _m0[32];
  float _m1[32];
  _12 _m2;
  _12 _m3;
  _13 _m4;
  _14 _m5;
  _16 _m6;
  _20 _m7;
  _30 _m8;
  _31 _m9;
  float _m10;
  vec2 _m11;
  _32 _m12;
  _33 _m13;
  float _m14;
  float _m15;
  vec4 _m16;
  _34 _m17;
  _36 _m18;
  _37 _m19;
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
  _38 _m30;
  int _m31;
};

vec3 _131;

layout(set = 0, binding = 99, scalar) readonly buffer _10_39 {
  _11 _m0[];
}
_39;

layout(set = 0, binding = 18, std140) uniform _44_45 {
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
_45;

layout(set = 1, binding = 17, std140) uniform _46_47 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  float _m5;
  float _m6;
  float _m7;
  vec4 _m8;
  vec4 _m9;
  vec4 _m10;
}
_47;

layout(set = 1, binding = 32) uniform sampler _8;
layout(set = 1, binding = 34) uniform sampler _9;
layout(set = 0, binding = 123) uniform texture2DArray _43;
layout(set = 1, binding = 187) uniform texture2D _48;
layout(set = 1, binding = 207) uniform texture3D _49;

layout(location = 0) in vec4 _4;
layout(location = 1) in vec2 _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _133 = gl_FragCoord;
  _133.w = 1.0 / _133.w;
  vec4 _141 = textureLod(sampler2D(_48, _8), _5, 0.0);
  vec3 _150 = _141.xyz;
  vec3 _173 = mix(mix(pow((_150 + vec3(_45._m14)) / vec3(_45._m13), vec3(1.0 / _45._m12)), _150 / vec3(_45._m11), lessThan(_150, vec3(0.003130800090730190277099609375 / _45._m11))), _150, bvec3((_45._m3 != 0u) && (!(_45._m2 != 0u))));
  vec3 _245;
  if (_45._m16 != 0u) {
    uint _185 = uint(_47._m10.x);
    vec3 _239;
    if (_185 == 1u) {
      _239 = (log2(_173 + vec3(1.0000000116860974230803549289703e-07)) * _47._m10.y) + vec3(_47._m10.z);
    } else {
      vec3 _238;
      if (_185 == 2u) {
        float _206 = pow(((_173.x * _47._m10.y) + _47._m10.z) * 9.9999997473787516355514526367188e-05, 0.1593017578125);
        vec3 _213 = _173;
        _213.x = pow((0.8359375 + (18.8515625 * _206)) / (1.0 + (18.6875 * _206)), 78.84375);
        float _218 = pow(((_173.y * _47._m10.y) + _47._m10.z) * 9.9999997473787516355514526367188e-05, 0.1593017578125);
        _213.y = pow((0.8359375 + (18.8515625 * _218)) / (1.0 + (18.6875 * _218)), 78.84375);
        float _230 = pow(((_173.z * _47._m10.y) + _47._m10.z) * 9.9999997473787516355514526367188e-05, 0.1593017578125);
        _213.z = pow((0.8359375 + (18.8515625 * _230)) / (1.0 + (18.6875 * _230)), 78.84375);
        _238 = _213;
      } else {
        _238 = _173;
      }
      _239 = _238;
    }
    _245 = textureLod(sampler3D(_49, _9), _239, 0.0).xyz;
  } else {
    _245 = _173;
  }

#if 1
  _245.rgb = GammaSafe(_245.rgb);
#endif

  vec3 _246 = _245 * mat3(vec3(0.6274039745330810546875, 0.329281985759735107421875, 0.043313600122928619384765625), vec3(0.06909699738025665283203125, 0.919539988040924072265625, 0.0113612003624439239501953125), vec3(0.01639159955084323883056640625, 0.0880132019519805908203125, 0.895595014095306396484375));
  float _257 = pow(abs((_246.x * _45._m0) / _45._m15), 0.1593017578125);
  vec3 _264;
  _264.x = pow((0.8359375 + (18.8515625 * _257)) / (1.0 + (18.6875 * _257)), 78.84375);
  float _266 = pow(abs((_246.y * _45._m0) / _45._m15), 0.1593017578125);
  _264.y = pow((0.8359375 + (18.8515625 * _266)) / (1.0 + (18.6875 * _266)), 78.84375);
  float _275 = pow(abs((_246.z * _45._m0) / _45._m15), 0.1593017578125);
  _264.z = pow((0.8359375 + (18.8515625 * _275)) / (1.0 + (18.6875 * _275)), 78.84375);
  vec3 _336;
  if (floatBitsToInt(_47._m2.x) != 0) {
    ivec4 _314 = ivec4(uvec4(uvec2(ivec2(uvec2(_133.xy))) & uvec2(63u), uint(int((floatBitsToInt(_47._m2.y) != 0) ? _39._m0[0u]._m22 : 63u) & 31), 0u));
    vec3 _322 = (vec3(texelFetch(_43, _314.xyz, _314.w).x) * 2.0) - vec3(1.0);
    vec3 _333;
    if (floatBitsToInt(_47._m2.z) != 0) {
      _333 = vec3(ivec3(sign(_322))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_322)));
    } else {
      _333 = _322;
    }
    _336 = _264 + (_333 * vec3(_47._m2.w));
  } else {
    _336 = _264;
  }
  _6 = vec4(_336, _141.w);
}

