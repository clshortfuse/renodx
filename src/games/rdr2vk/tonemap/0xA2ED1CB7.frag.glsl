#version 450

#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"

#extension GL_EXT_scalar_block_layout : require
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
#extension GL_EXT_samplerless_texture_functions : require

struct _13 {
  float _m0;
};

struct _15 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _14 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  _15 _m5;
};

struct _17 {
  vec4 _m0;
  vec4 _m1;
  mat4 _m2;
};

struct _18 {
  vec4 _m0;
  vec4 _m1;
};

struct _19 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec4 _m3;
  vec4 _m4;
  vec4 _m5;
  vec4 _m6;
};

struct _20 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
  float _m6;
};

struct _16 {
  _17 _m0[2];
  _18 _m1;
  _19 _m2;
  _20 _m3;
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

struct _22 {
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

struct _23 {
  float _m0;
  float _m1;
  float _m2;
};

struct _24 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  vec3 _m4;
  int _m5;
};

struct _21 {
  _22 _m0;
  _23 _m1;
  _24 _m2;
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

struct _25 {
  vec4 _m0[5];
};

struct _26 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _27 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _28 {
  int _m0;
  int _m1;
};

struct _29 {
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

struct _12 {
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
  _13 _m41;
  _14 _m42;
  _16 _m43;
  _21 _m44;
  _25 _m45;
  _26 _m46;
  _27 _m47[5];
  vec4 _m48;
  _28 _m49;
  vec4 _m50;
  _29 _m51;
};

struct _33 {
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

struct _34 {
  float _m0;
};

struct _36 {
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

struct _35 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  _36 _m3;
  vec2 _m4;
};

struct _38 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _39 {
  int _m0;
};

struct _40 {
  _39 _m0;
  float _m1;
  float _m2;
  float _m3;
};

struct _37 {
  vec3 _m0;
  vec3 _m1;
  float _m2;
  float _m3;
  _38 _m4;
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
  _39 _m16;
  _39 _m17;
  _40 _m18;
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

struct _42 {
  vec3 _m0;
  float _m1;
};

struct _43 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
};

struct _44 {
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

struct _45 {
  float _m0;
  _39 _m1;
};

struct _46 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _47 {
  _39 _m0;
  float _m1;
  float _m2;
};

struct _49 {
  int _m0;
};

struct _48 {
  _39 _m0;
  _49 _m1;
  _49 _m2;
};

struct _50 {
  _39 _m0;
};

struct _41 {
  _42 _m0;
  vec4 _m1;
  mat4 _m2;
  mat4 _m3;
  _43 _m4;
  _44 _m5;
  _45 _m6;
  _46 _m7;
  _47 _m8;
  _48 _m9;
  _50 _m10;
  float _m11;
  float _m12;
  float _m13;
};

struct _51 {
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

struct _52 {
  vec4 _m0;
  vec4 _m1;
  vec4 _m2;
  vec3 _m3;
  vec3 _m4;
  vec3 _m5;
  vec3 _m6;
  vec3 _m7;
};

struct _53 {
  vec4 _m0;
  vec4 _m1;
  vec3 _m2;
};

struct _54 {
  vec4 _m0;
  vec4 _m1;
};

struct _56 {
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
  _56 _m19[2];
};

struct _57 {
  vec2 _m0;
  vec2 _m1;
  vec2 _m2;
  float _m3;
  float _m4;
  float _m5;
  vec2 _m6;
};

struct _58 {
  vec4 _m0;
  vec4 _m1;
  vec2 _m2;
  float _m3;
  float _m4;
  float _m5;
};

struct _59 {
  vec3 _m0;
  float _m1;
  float _m2;
};

struct _32 {
  float _m0[32];
  float _m1[32];
  _33 _m2;
  _33 _m3;
  _34 _m4;
  _35 _m5;
  _37 _m6;
  _41 _m7;
  _51 _m8;
  _52 _m9;
  float _m10;
  vec2 _m11;
  _53 _m12;
  _54 _m13;
  float _m14;
  float _m15;
  vec4 _m16;
  _55 _m17;
  _57 _m18;
  _58 _m19;
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
  _59 _m30;
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

float _290;

layout(set = 0, binding = 98, scalar) readonly buffer _11_30 {
  _12 _m0[];
}
_30;

layout(set = 0, binding = 99, scalar) readonly buffer _31_60 {
  _32 _m0[];
}
_60;

layout(set = 0, binding = 20, std140) uniform _66_67 {
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
_67;

layout(set = 1, binding = 16, std140) uniform _68_69 {
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
_69;

layout(set = 0, binding = 214, std430) readonly buffer _90_94 {
  _91 _m0[];
}
_94;

layout(set = 1, binding = 32) uniform sampler _8;
layout(set = 1, binding = 33) uniform sampler _9;
layout(set = 1, binding = 34) uniform sampler _10;
layout(set = 0, binding = 121) uniform texture2DArray _63;
layout(set = 0, binding = 140) uniform texture2D _64;
layout(set = 1, binding = 173) uniform texture2D _70;
layout(set = 1, binding = 174) uniform texture2D _71;
layout(set = 1, binding = 177) uniform texture2D _72;
layout(set = 1, binding = 185) uniform texture1D _74;
layout(set = 1, binding = 40) uniform sampler _75;
layout(set = 1, binding = 186) uniform texture2D _76;
layout(set = 1, binding = 189) uniform texture2D _77;
layout(set = 1, binding = 190) uniform texture2D _78;
layout(set = 1, binding = 191) uniform texture2D _79;
layout(set = 1, binding = 196) uniform texture2D _80;
layout(set = 1, binding = 197) uniform texture2D _81;
layout(set = 1, binding = 202) uniform texture2D _82;
layout(set = 1, binding = 203) uniform texture2D _83;
layout(set = 1, binding = 205) uniform texture2D _84;
layout(set = 1, binding = 206) uniform texture2D _85;
layout(set = 1, binding = 207) uniform texture2D _86;
layout(set = 1, binding = 209) uniform texture2D _87;
layout(set = 1, binding = 210) uniform texture2D _88;
layout(set = 1, binding = 212) uniform samplerBuffer _89;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _300 = texture(sampler2D(_85, _8), _4.xy);
  vec2 _301 = _300.xy;
  float _309 = 1.0 + _69._m0.w;
  float _312 = _69._m0.z / (_309 - textureLod(sampler2D(_71, _8), _301, 0.0).x);
  vec4 _316 = texture(sampler2D(_76, _75), _301);
  vec4 _341 = textureLod(sampler2D(_88, _8), _301 * _69._m80.xy, 0.0) * 1.0;
  float _342 = _341.z;
  vec4 _499;
  SPIRV_CROSS_BRANCH
  if ((_342 >= 1.0) && (_341.w < 2.0)) {
    float _360 = min(length(textureLod(sampler2D(_87, _8), _301, 0.0).xy * _69._m20.x), _69._m20.z);
    float _363 = min(_342, 2.0);
    vec2 _364 = (_341.xy / vec2(_342)) * _363;
    int _367 = int(min(2.0, 1.0 + _363));
    vec2 _371 = _364 * _69._m63.xy;
    float _373 = float(_367) - 0.5;
    float _374 = _373 / _363;
    vec2 _376 = (-_364) * _69._m63.xy;
    vec2 _379 = vec2(uvec2(gl_FragCoord.xy) & uvec2(1u));
    float _393 = ((((_379.x * 2.0) - 1.0) * ((_379.y * 2.0) - 1.0)) * _69._m20.w) * clamp((_363 - 2.0) * 0.5, 0.0, 1.0);
    float _394 = 0.5 + _393;
    float _395 = 0.5 - _393;
    vec4 _397;
    _397 = vec4(0.0);
    for (int _400 = 0; _400 < _367;) {
      float _404 = float(_400);
      float _405 = _404 + _394;
      vec2 _408 = _301 + (_371 * (_405 / _373));
      float _414 = min(length(textureLod(sampler2D(_87, _8), _408, 0.0).xy * _69._m20.x), _69._m20.z);
      float _420 = _69._m0.z / (_309 - textureLod(sampler2D(_70, _8), _408, 0.0).x);
      float _425 = _360 * _374;
      float _442 = _404 + _395;
      vec2 _445 = _301 + (_376 * (_442 / _373));
      float _451 = min(length(textureLod(sampler2D(_87, _8), _445, 0.0).xy * _69._m20.x), _69._m20.z);
      float _456 = _69._m0.z / (_309 - textureLod(sampler2D(_70, _8), _445, 0.0).x);
      float _473 = (1.0 - clamp((1.0 - _451) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_456 - _312)), vec2(0.0), vec2(1.0)), clamp(vec2(_425, _451 * _374) - vec2(max(_442 - 1.0, 0.0)), vec2(0.0), vec2(1.0)));
      bvec2 _479 = bvec2(_420 > _456, _451 > _414);
      float _481 = all(_479) ? _473 : ((1.0 - clamp((1.0 - _414) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_420 - _312)), vec2(0.0), vec2(1.0)), clamp(vec2(_425, _414 * _374) - vec2(max(_405 - 1.0, 0.0)), vec2(0.0), vec2(1.0))));
      float _483 = any(_479) ? _473 : _481;
      _397 = (_397 + vec4(textureLod(sampler2D(_78, _9), _445, 0.0).xyz * _483, _483)) + vec4(textureLod(sampler2D(_78, _9), _408, 0.0).xyz * _481, _481);
      _400++;
      continue;
    }
    _499 = _397 / vec4(float(2 * _367));
  } else {
    _499 = vec4(0.0);
  }
  vec4 _507 = textureLod(sampler2D(_79, _9), _301, 0.0);
  vec3 _512 = _507.xyz + ((_499.xyz + (vec4(vec4(_316.xyz, 0.0).xyz * _30._m0[0u]._m1.w, _290).xyz * (1.0 - _499.w))) * (1.0 - _507.w));
  vec4 _515 = texelFetch(_89, int(0u));
  vec4 _516 = texelFetch(_89, int(1u));
  float _521 = dot(_512 * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
  bool _546;
  vec3 _547;
  if (floatBitsToInt(_69._m61) != 0) {
    vec4 _532 = texture(sampler2D(_84, _75), _4.xy);
    float _533 = _532.w;
    bool _535 = (_533 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _544;
    if (_535) {
      _544 = _532.xyz;
    } else {
      _544 = _532.xyz + (_512 * (1.0 - _533));
    }
    _546 = _535 ? true : false;
    _547 = _544;
  } else {
    _546 = false;
    _547 = _512;
  }
  vec3 _551 = min(_547 * texelFetch(_64, ivec2(0), 0).x, vec3(65504.0));
  bool _552 = !_546;
  float _688;
  vec3 _689;
  if (_552) {
    float _611;
    if (floatBitsToInt(_69._m70.x) != 0) {
      float _574 = clamp(dot(texture(sampler2D(_72, _10), _301).xyz * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _69._m72.z, _69._m72.w);
      float _597 = clamp(((((_69._m70.y * log(_574 + _69._m72.x)) + _69._m70.z) - 10.0) + (_69._m72.y * _574)) + _69._m65.w, _69._m66.x, _69._m66.y);
      _611 = pow(2.0, mix(_5, clamp(_597 + ((abs(_597) * _69._m66.z) * float(int(sign(_597)))), _69._m66.x, _69._m66.y), clamp(_69._m70.x, 0.0, 1.0)));
    } else {
      _611 = _4.z;
    }
    vec4 _624 = texture(sampler2D(_77, _10), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _69._m16.w) + _69._m16.xy));
    vec3 _634 = max(_551 * vec3(0.5), _551 + vec3((_521 * (_624.w - 0.5)) * _69._m16.z));
    vec3 _687;
    if (floatBitsToInt(_69._m51.w) != 0) {
      vec2 _663 = ((_4.xy - _69._m50.xy) * mat2(vec2(_69._m52.x, _69._m52.y), vec2(_69._m52.z, _69._m52.w))) * _69._m50.zw;
      float _667 = max((dot(_663, _663) - _69._m53.x) * _69._m53.w, 0.0);
      bool _668 = _667 < 1.0;
      _687 = mix(_634, (_634 * _69._m51.xyz) * _69._m51.w, vec3(_668 ? (_668 ? (1.0 - pow(2.0, (-10.0) * _667)) : 1.0) : (0.9980499744415283203125 + (((_667 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_667 - 2.0)) : 0.0))));
    } else {
      _687 = _634;
    }
    _688 = _611;
    _689 = _687;
  } else {
    _688 = _4.z;
    _689 = _551;
  }
  vec3 _726 = _689 * mix(mix(_69._m54.xyz, _69._m56.xyz, vec3(clamp(clamp(_4.y * _69._m57.y, 0.0, 1.0) + _69._m54.w, 0.0, 1.0))), mix(_69._m56.xyz, _69._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _69._m56.w, 0.0, 1.0) * _69._m57.x, 0.0, 1.0) - _69._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _729 = _67._m3 != 0u;
  vec3 _792;
  if (_729) {
    vec3 _769 = max(vec3(0.0), _726 * (_688 / _67._m6));
    vec3 _772 = _769 * _515.x;
    _792 = (((((_769 * (_772 + vec3(_516.x))) + vec3(_516.y)) / ((_769 * (_772 + vec3(_515.y))) + vec3(_516.z))) - vec3(_516.w)) * ((_67._m4 != 0u) ? _67._m10 : _515.z)) * _67._m6;
  } else {
    vec3 _735 = max(vec3(0.0), _726 * _688);
    vec3 _738 = _735 * _515.x;
    _792 = clamp(((((_735 * (_738 + vec3(_516.x))) + vec3(_516.y)) / ((_735 * (_738 + vec3(_515.y))) + vec3(_516.z))) - vec3(_516.w)) * _515.z, vec3(0.0), vec3(1.0));
  }
  vec3 _840;
  if (_552) {
    vec3 _839;
    if (floatBitsToInt(_69._m47.w) != 0) {
      vec2 _825 = ((_4.xy - _69._m46.xy) * mat2(vec2(_69._m48.x, _69._m48.y), vec2(_69._m48.z, _69._m48.w))) * _69._m46.zw;
      _839 = mix(_792, _69._m47.xyz, vec3(_69._m47.w * texture(sampler1D(_74, _10), min(1.0, max((dot(_825, _825) - _69._m49.x) * _69._m49.w, 0.0))).w));
    } else {
      _839 = _792;
    }
    _840 = _839;
  } else {
    _840 = _792;
  }
  bool _861 = _729 && (!(_67._m2 != 0u));

#if 1
  vec3 _863 = EncodeLUTInput(_840, _67._m11, _67._m12, _67._m13, _67._m14, _861);
#else
  vec3 _863 = mix(mix((pow(_840, vec3(_67._m12)) * _67._m13) - vec3(_67._m14), _840 * _67._m11, lessThan(_840, vec3(0.003130800090730190277099609375))), _840, bvec3(_861));
#endif

  vec3 _1019;
  if (_552 && (floatBitsToInt(_69._m19.x) != 0)) {
    vec2 _875 = _4.xy * _69._m17.w;
    float _941 = (((((((fract(sin(dot(_875 + vec2(0.070000000298023223876953125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_875 + vec2(0.10999999940395355224609375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_875 + vec2(0.12999999523162841796875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_875 + vec2(0.17000000178813934326171875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_875 + vec2(0.189999997615814208984375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_875 + vec2(0.23000000417232513427734375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_875 + vec2(0.2899999916553497314453125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_875 + vec2(0.310000002384185791015625 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _943 = clamp(_941 + _69._m17.z, 0.0, 1.0);
    vec3 _1018;
    do {
      if (!(floatBitsToInt(_69._m18.w) != 0)) {
        _1018 = vec3(_943);
        break;
      }
      float _966;
      if (floatBitsToInt(_69._m18.y) != 0) {
        float _961 = dot(_863, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _966 = mix(_943, _943 * 0.5, (_961 * _961) * _961);
      } else {
        _966 = _943;
      }
      vec3 _1017;
      if (floatBitsToInt(_69._m19.z) != 0) {
        vec3 _999 = vec3(_966);
        vec3 _1001 = _999 * 2.0;
        _1017 = mix(_863, mix(((_863 * 2.0) * (vec3(1.0) - _999)) + (sqrt(_863) * (_1001 - vec3(1.0))), (_1001 * _863) + ((_863 * _863) * (vec3(1.0) - _1001)), lessThan(_999, vec3(0.5))), vec3(_69._m18.x));
      } else {
        vec3 _998;
        if (floatBitsToInt(_69._m19.w) != 0) {
          vec3 _986 = vec3(_966);
          _998 = mix(_863, mix(vec3(1.0) - (((vec3(1.0) - _986) * 2.0) * (vec3(1.0) - _863)), (_986 * 2.0) * _863, lessThan(_863, vec3(0.5))), vec3(_69._m18.x));
        } else {
          _998 = clamp(max(_863 * 0.02500000037252902984619140625, _863 + vec3((_966 - 0.5) * _69._m18.x)), vec3(0.0), vec3(1.0));
        }
        _1017 = _998;
      }
      _1018 = _1017;
      break;
    } while (false);
    _1019 = _1018;
  } else {
    _1019 = _863;
  }
  vec3 _1021 = max(_1019 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _1022 = _1021.y;
  vec3 _1047 = mix(_1019, clamp((_69._m81.xyz * (_1022 * ((1.33000004291534423828125 * (1.0 + ((_1022 + _1021.z) / _1021.x))) - 1.67999994754791259765625))) * _69._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _521)) * _69._m82.x) + _69._m82.y, 0.0, 1.0)));
  vec3 _1077;
  if (floatBitsToInt(_69._m84.w) != 0) {
    _1077 = mix(_1047, texture(sampler2D(_86, _10), ((((_4.xy - vec2(0.5)) * _69._m84.z) / mix(_69._m85.wx, _69._m85.zy, _4.yx)) - _69._m84.xy) + vec2(0.5)).xyz, vec3(_69._m84.w));
  } else {
    _1077 = _1047;
  }
  vec3 _1235;
  if (_552) {
    float _1096 = max(max(_1077.x, max(_1077.y, _1077.z)), 9.9999997473787516355514526367188e-05);
    float _1102 = (_861 && (!(_67._m5 != 0u))) ? 1.0 : (((_1096 > _67._m7) ? ((_1096 * _67._m8) + _67._m9) : _1096) / _1096);
    vec3 _1103 = _1077 * _1102;
    float _1106 = _1103.z;
    float _1108 = floor(_1106 * 14.99989986419677734375);
    float _1114 = (_1108 * 0.0625) + (_1103.x * 0.05859375);
    float _1116 = _1103.y * 0.9375;
    vec4 _1120 = texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1114, _1116));
    vec4 _1126 = texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1114 + 0.0625, _1116));
    vec3 _1129 = mix(_1120.xyz, _1126.xyz, vec3((_1106 * 15.0) - _1108));
    vec3 _1232;
    if (_94._m0[0u]._m0._m0 > 0) {
      float _1163 = _1129.z;
      float _1165 = floor(_1163 * 14.99989986419677734375);
      float _1171 = (_1165 * 0.0625) + (_1129.x * 0.05859375);
      float _1173 = _1129.y * 0.9375;
      vec3 _1188 = mix(_1129, mix(texture(sampler2D(_80, _10), vec2(0.001953125, 0.03125) + vec2(_1171, _1173)).xyz, texture(sampler2D(_80, _10), vec2(0.001953125, 0.03125) + vec2(_1171 + 0.0625, _1173)).xyz, vec3((_1163 * 15.0) - _1165)), vec3(clamp(((_312 < _94._m0[0u]._m1[0]._m2) ? clamp((_312 - _94._m0[0u]._m1[0]._m0) * _94._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_312 - _94._m0[0u]._m1[0]._m2) * _94._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _94._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _1200 = _1188.z;
      float _1202 = floor(_1200 * 14.99989986419677734375);
      float _1208 = (_1202 * 0.0625) + (_1188.x * 0.05859375);
      float _1210 = _1188.y * 0.9375;
      _1232 = mix(_1188, mix(_1188, mix(texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1208, _1210)).xyz, texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1208 + 0.0625, _1210)).xyz, vec3((_1200 * 15.0) - _1202)), vec3(clamp(((_312 < _94._m0[0u]._m1[1]._m2) ? clamp((_312 - _94._m0[0u]._m1[1]._m0) * _94._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_312 - _94._m0[0u]._m1[1]._m2) * _94._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _94._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_83, _10), _301).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
    } else {
      _1232 = _1129;
    }
    _1235 = _1232 / vec3(_1102);
  } else {
    _1235 = _1077;
  }

#if 1
  _1235 = DecodeLUTInput(_1235);
#endif

  vec4 _1240 = vec4(_1235, dot(_1235, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1241 = _1240.xyz;
  ivec4 _1283 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_60._m0[0u]._m22) & 31), 0u));
  vec3 _1291 = (vec3(texelFetch(_63, _1283.xyz, _1283.w).x) * 2.0) - vec3(1.0);
  vec3 _1302;
  if (_729) {
    _1302 = vec3(ivec3(sign(_1291))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1291)));
  } else {
    _1302 = _1291;
  }
  vec3 _1304 = _1241 + (_1302 * mix(_69._m39.xyz, _69._m40.xyz, pow(clamp((mix(vec3(max(_1235.x, max(_1235.y, _1235.z))), _1241, bvec3(floatBitsToInt(_69._m41.w) != 0)) - _69._m42.xyz) * _69._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_69._m42.w))));
  vec4 _1305 = vec4(_1304.x, _1304.y, _1304.z, _1240.w);
  vec4 _1310;
  if (!_729) {
    _1310 = clamp(_1305, vec4(0.0), vec4(1.0));
  } else {
    _1310 = _1305;
  }
  _6 = _1310;
}

