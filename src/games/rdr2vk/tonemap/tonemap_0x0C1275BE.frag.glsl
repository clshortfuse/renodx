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

struct _90 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _91 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _89 {
  _90 _m0;
  _91 _m1[11];
};

float _267;

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

layout(set = 0, binding = 214, std430) readonly buffer _88_92 {
  _89 _m0[];
}
_92;

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
layout(set = 1, binding = 190) uniform texture2D _77;
layout(set = 1, binding = 191) uniform texture2D _78;
layout(set = 1, binding = 196) uniform texture2D _79;
layout(set = 1, binding = 197) uniform texture2D _80;
layout(set = 1, binding = 202) uniform texture2D _81;
layout(set = 1, binding = 203) uniform texture2D _82;
layout(set = 1, binding = 205) uniform texture2D _83;
layout(set = 1, binding = 207) uniform texture2D _84;
layout(set = 1, binding = 209) uniform texture2D _85;
layout(set = 1, binding = 210) uniform texture2D _86;
layout(set = 1, binding = 212) uniform samplerBuffer _87;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  float _282 = 1.0 + _69._m0.w;
  float _285 = _69._m0.z / (_282 - textureLod(sampler2D(_71, _8), _4.xy, 0.0).x);
  vec4 _289 = texture(sampler2D(_76, _75), _4.xy);
  vec4 _314 = textureLod(sampler2D(_86, _8), _4.xy * _69._m80.xy, 0.0) * 1.0;
  float _315 = _314.z;
  vec4 _472;
  SPIRV_CROSS_BRANCH
  if ((_315 >= 1.0) && (_314.w < 2.0)) {
    float _333 = min(length(textureLod(sampler2D(_85, _8), _4.xy, 0.0).xy * _69._m20.x), _69._m20.z);
    float _336 = min(_315, 2.0);
    vec2 _337 = (_314.xy / vec2(_315)) * _336;
    int _340 = int(min(2.0, 1.0 + _336));
    vec2 _344 = _337 * _69._m63.xy;
    float _346 = float(_340) - 0.5;
    float _347 = _346 / _336;
    vec2 _349 = (-_337) * _69._m63.xy;
    vec2 _352 = vec2(uvec2(gl_FragCoord.xy) & uvec2(1u));
    float _366 = ((((_352.x * 2.0) - 1.0) * ((_352.y * 2.0) - 1.0)) * _69._m20.w) * clamp((_336 - 2.0) * 0.5, 0.0, 1.0);
    float _367 = 0.5 + _366;
    float _368 = 0.5 - _366;
    vec4 _370;
    _370 = vec4(0.0);
    for (int _373 = 0; _373 < _340;) {
      float _377 = float(_373);
      float _378 = _377 + _367;
      vec2 _381 = _4.xy + (_344 * (_378 / _346));
      float _387 = min(length(textureLod(sampler2D(_85, _8), _381, 0.0).xy * _69._m20.x), _69._m20.z);
      float _393 = _69._m0.z / (_282 - textureLod(sampler2D(_70, _8), _381, 0.0).x);
      float _398 = _333 * _347;
      float _415 = _377 + _368;
      vec2 _418 = _4.xy + (_349 * (_415 / _346));
      float _424 = min(length(textureLod(sampler2D(_85, _8), _418, 0.0).xy * _69._m20.x), _69._m20.z);
      float _429 = _69._m0.z / (_282 - textureLod(sampler2D(_70, _8), _418, 0.0).x);
      float _446 = (1.0 - clamp((1.0 - _424) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_429 - _285)), vec2(0.0), vec2(1.0)), clamp(vec2(_398, _424 * _347) - vec2(max(_415 - 1.0, 0.0)), vec2(0.0), vec2(1.0)));
      bvec2 _452 = bvec2(_393 > _429, _424 > _387);
      float _454 = all(_452) ? _446 : ((1.0 - clamp((1.0 - _387) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_393 - _285)), vec2(0.0), vec2(1.0)), clamp(vec2(_398, _387 * _347) - vec2(max(_378 - 1.0, 0.0)), vec2(0.0), vec2(1.0))));
      float _456 = any(_452) ? _446 : _454;
      _370 = (_370 + vec4(textureLod(sampler2D(_77, _9), _418, 0.0).xyz * _456, _456)) + vec4(textureLod(sampler2D(_77, _9), _381, 0.0).xyz * _454, _454);
      _373++;
      continue;
    }
    _472 = _370 / vec4(float(2 * _340));
  } else {
    _472 = vec4(0.0);
  }
  vec4 _480 = textureLod(sampler2D(_78, _9), _4.xy, 0.0);
  vec3 _485 = _480.xyz + ((_472.xyz + (vec4(vec4(_289.xyz, 0.0).xyz * _30._m0[0u]._m1.w, _267).xyz * (1.0 - _472.w))) * (1.0 - _480.w));
  vec4 _488 = texelFetch(_87, int(0u));
  vec4 _489 = texelFetch(_87, int(1u));
  bool _519;
  vec3 _520;
  if (floatBitsToInt(_69._m61) != 0) {
    vec4 _505 = texture(sampler2D(_83, _75), _4.xy);
    float _506 = _505.w;
    bool _508 = (_506 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _517;
    if (_508) {
      _517 = _505.xyz;
    } else {
      _517 = _505.xyz + (_485 * (1.0 - _506));
    }
    _519 = _508 ? true : false;
    _520 = _517;
  } else {
    _519 = false;
    _520 = _485;
  }
  vec3 _524 = min(_520 * texelFetch(_64, ivec2(0), 0).x, vec3(65504.0));
  bool _525 = !_519;
  float _638;
  vec3 _639;
  if (_525) {
    float _584;
    if (floatBitsToInt(_69._m70.x) != 0) {
      float _547 = clamp(dot(texture(sampler2D(_72, _10), _4.xy).xyz * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _69._m72.z, _69._m72.w);
      float _570 = clamp(((((_69._m70.y * log(_547 + _69._m72.x)) + _69._m70.z) - 10.0) + (_69._m72.y * _547)) + _69._m65.w, _69._m66.x, _69._m66.y);
      _584 = pow(2.0, mix(_5, clamp(_570 + ((abs(_570) * _69._m66.z) * float(int(sign(_570)))), _69._m66.x, _69._m66.y), clamp(_69._m70.x, 0.0, 1.0)));
    } else {
      _584 = _4.z;
    }
    vec3 _637;
    if (floatBitsToInt(_69._m51.w) != 0) {
      vec2 _613 = ((_4.xy - _69._m50.xy) * mat2(vec2(_69._m52.x, _69._m52.y), vec2(_69._m52.z, _69._m52.w))) * _69._m50.zw;
      float _617 = max((dot(_613, _613) - _69._m53.x) * _69._m53.w, 0.0);
      bool _618 = _617 < 1.0;
      _637 = mix(_524, (_524 * _69._m51.xyz) * _69._m51.w, vec3(_618 ? (_618 ? (1.0 - pow(2.0, (-10.0) * _617)) : 1.0) : (0.9980499744415283203125 + (((_617 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_617 - 2.0)) : 0.0))));
    } else {
      _637 = _524;
    }
    _638 = _584;
    _639 = _637;
  } else {
    _638 = _4.z;
    _639 = _524;
  }
  vec3 _676 = _639 * mix(mix(_69._m54.xyz, _69._m56.xyz, vec3(clamp(clamp(_4.y * _69._m57.y, 0.0, 1.0) + _69._m54.w, 0.0, 1.0))), mix(_69._m56.xyz, _69._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _69._m56.w, 0.0, 1.0) * _69._m57.x, 0.0, 1.0) - _69._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _679 = _67._m3 != 0u;
  vec3 _742;
  if (_679) {
    vec3 _719 = max(vec3(0.0), _676 * (_638 / _67._m6));
    vec3 _722 = _719 * _488.x;
    _742 = (((((_719 * (_722 + vec3(_489.x))) + vec3(_489.y)) / ((_719 * (_722 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * ((_67._m4 != 0u) ? _67._m10 : _488.z)) * _67._m6;
  } else {
    vec3 _685 = max(vec3(0.0), _676 * _638);
    vec3 _688 = _685 * _488.x;
    _742 = clamp(((((_685 * (_688 + vec3(_489.x))) + vec3(_489.y)) / ((_685 * (_688 + vec3(_488.y))) + vec3(_489.z))) - vec3(_489.w)) * _488.z, vec3(0.0), vec3(1.0));
  }
  vec3 _790;
  if (_525) {
    vec3 _789;
    if (floatBitsToInt(_69._m47.w) != 0) {
      vec2 _775 = ((_4.xy - _69._m46.xy) * mat2(vec2(_69._m48.x, _69._m48.y), vec2(_69._m48.z, _69._m48.w))) * _69._m46.zw;
      _789 = mix(_742, _69._m47.xyz, vec3(_69._m47.w * texture(sampler1D(_74, _10), min(1.0, max((dot(_775, _775) - _69._m49.x) * _69._m49.w, 0.0))).w));
    } else {
      _789 = _742;
    }
    _790 = _789;
  } else {
    _790 = _742;
  }
  bool _811 = _679 && (!(_67._m2 != 0u));

#if 1
  vec3 _813 = EncodeLUTInput(_790, _67._m11, _67._m12, _67._m13, _67._m14, _811);
#else
  vec3 _813 = mix(mix((pow(_790, vec3(_67._m12)) * _67._m13) - vec3(_67._m14), _790 * _67._m11, lessThan(_790, vec3(0.003130800090730190277099609375))), _790, bvec3(_811));
#endif

  vec3 _815 = max(_813 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _816 = _815.y;
  vec3 _841 = mix(_813, clamp((_69._m81.xyz * (_816 * ((1.33000004291534423828125 * (1.0 + ((_816 + _815.z) / _815.x))) - 1.67999994754791259765625))) * _69._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + dot(_485 * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)))) * _69._m82.x) + _69._m82.y, 0.0, 1.0)));
  vec3 _871;
  if (floatBitsToInt(_69._m84.w) != 0) {
    _871 = mix(_841, texture(sampler2D(_84, _10), ((((_4.xy - vec2(0.5)) * _69._m84.z) / mix(_69._m85.wx, _69._m85.zy, _4.yx)) - _69._m84.xy) + vec2(0.5)).xyz, vec3(_69._m84.w));
  } else {
    _871 = _841;
  }
  vec3 _1029;
  if (_525) {
    float _890 = max(max(_871.x, max(_871.y, _871.z)), 9.9999997473787516355514526367188e-05);
    float _896 = (_811 && (!(_67._m5 != 0u))) ? 1.0 : (((_890 > _67._m7) ? ((_890 * _67._m8) + _67._m9) : _890) / _890);
    vec3 _897 = _871 * _896;
    float _900 = _897.z;
    float _902 = floor(_900 * 14.99989986419677734375);
    float _908 = (_902 * 0.0625) + (_897.x * 0.05859375);
    float _910 = _897.y * 0.9375;
    vec4 _914 = texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_908, _910));
    vec4 _920 = texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_908 + 0.0625, _910));
    vec3 _923 = mix(_914.xyz, _920.xyz, vec3((_900 * 15.0) - _902));
    vec3 _1026;
    if (_92._m0[0u]._m0._m0 > 0) {
      float _957 = _923.z;
      float _959 = floor(_957 * 14.99989986419677734375);
      float _965 = (_959 * 0.0625) + (_923.x * 0.05859375);
      float _967 = _923.y * 0.9375;
      vec3 _982 = mix(_923, mix(texture(sampler2D(_79, _10), vec2(0.001953125, 0.03125) + vec2(_965, _967)).xyz, texture(sampler2D(_79, _10), vec2(0.001953125, 0.03125) + vec2(_965 + 0.0625, _967)).xyz, vec3((_957 * 15.0) - _959)), vec3(clamp(((_285 < _92._m0[0u]._m1[0]._m2) ? clamp((_285 - _92._m0[0u]._m1[0]._m0) * _92._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_285 - _92._m0[0u]._m1[0]._m2) * _92._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _92._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _994 = _982.z;
      float _996 = floor(_994 * 14.99989986419677734375);
      float _1002 = (_996 * 0.0625) + (_982.x * 0.05859375);
      float _1004 = _982.y * 0.9375;
      _1026 = mix(_982, mix(_982, mix(texture(sampler2D(_80, _10), vec2(0.001953125, 0.03125) + vec2(_1002, _1004)).xyz, texture(sampler2D(_80, _10), vec2(0.001953125, 0.03125) + vec2(_1002 + 0.0625, _1004)).xyz, vec3((_994 * 15.0) - _996)), vec3(clamp(((_285 < _92._m0[0u]._m1[1]._m2) ? clamp((_285 - _92._m0[0u]._m1[1]._m0) * _92._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_285 - _92._m0[0u]._m1[1]._m2) * _92._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _92._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_82, _10), _4.xy).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
    } else {
      _1026 = _923;
    }
    _1029 = _1026 / vec3(_896);
  } else {
    _1029 = _871;
  }

#if 1
  _1029 = DecodeLUTInput(_1029);
#endif
  vec4 _1034 = vec4(_1029, dot(_1029, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1035 = _1034.xyz;
  ivec4 _1077 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_60._m0[0u]._m22) & 31), 0u));
  vec3 _1085 = (vec3(texelFetch(_63, _1077.xyz, _1077.w).x) * 2.0) - vec3(1.0);
  vec3 _1096;
  if (_679) {
    _1096 = vec3(ivec3(sign(_1085))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1085)));
  } else {
    _1096 = _1085;
  }
  vec3 _1098 = _1035 + (_1096 * mix(_69._m39.xyz, _69._m40.xyz, pow(clamp((mix(vec3(max(_1029.x, max(_1029.y, _1029.z))), _1035, bvec3(floatBitsToInt(_69._m41.w) != 0)) - _69._m42.xyz) * _69._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_69._m42.w))));
  vec4 _1099 = vec4(_1098.x, _1098.y, _1098.z, _1034.w);
  vec4 _1104;
  if (!_679) {
    _1104 = clamp(_1099, vec4(0.0), vec4(1.0));
  } else {
    _1104 = _1099;
  }
  _6 = _1104;
}

