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

float _289;

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

layout(set = 0, binding = 214, std430) readonly buffer _89_93 {
  _90 _m0[];
}
_93;

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
layout(set = 1, binding = 207) uniform texture2D _85;
layout(set = 1, binding = 209) uniform texture2D _86;
layout(set = 1, binding = 210) uniform texture2D _87;
layout(set = 1, binding = 212) uniform samplerBuffer _88;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  float _304 = 1.0 + _69._m0.w;
  float _307 = _69._m0.z / (_304 - textureLod(sampler2D(_71, _8), _4.xy, 0.0).x);
  vec4 _311 = texture(sampler2D(_76, _75), _4.xy);
  vec4 _336 = textureLod(sampler2D(_87, _8), _4.xy * _69._m80.xy, 0.0) * 1.0;
  float _337 = _336.z;
  vec4 _494;
  SPIRV_CROSS_BRANCH
  if ((_337 >= 1.0) && (_336.w < 2.0)) {
    float _355 = min(length(textureLod(sampler2D(_86, _8), _4.xy, 0.0).xy * _69._m20.x), _69._m20.z);
    float _358 = min(_337, 2.0);
    vec2 _359 = (_336.xy / vec2(_337)) * _358;
    int _362 = int(min(2.0, 1.0 + _358));
    vec2 _366 = _359 * _69._m63.xy;
    float _368 = float(_362) - 0.5;
    float _369 = _368 / _358;
    vec2 _371 = (-_359) * _69._m63.xy;
    vec2 _374 = vec2(uvec2(gl_FragCoord.xy) & uvec2(1u));
    float _388 = ((((_374.x * 2.0) - 1.0) * ((_374.y * 2.0) - 1.0)) * _69._m20.w) * clamp((_358 - 2.0) * 0.5, 0.0, 1.0);
    float _389 = 0.5 + _388;
    float _390 = 0.5 - _388;
    vec4 _392;
    _392 = vec4(0.0);
    for (int _395 = 0; _395 < _362;) {
      float _399 = float(_395);
      float _400 = _399 + _389;
      vec2 _403 = _4.xy + (_366 * (_400 / _368));
      float _409 = min(length(textureLod(sampler2D(_86, _8), _403, 0.0).xy * _69._m20.x), _69._m20.z);
      float _415 = _69._m0.z / (_304 - textureLod(sampler2D(_70, _8), _403, 0.0).x);
      float _420 = _355 * _369;
      float _437 = _399 + _390;
      vec2 _440 = _4.xy + (_371 * (_437 / _368));
      float _446 = min(length(textureLod(sampler2D(_86, _8), _440, 0.0).xy * _69._m20.x), _69._m20.z);
      float _451 = _69._m0.z / (_304 - textureLod(sampler2D(_70, _8), _440, 0.0).x);
      float _468 = (1.0 - clamp((1.0 - _446) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_451 - _307)), vec2(0.0), vec2(1.0)), clamp(vec2(_420, _446 * _369) - vec2(max(_437 - 1.0, 0.0)), vec2(0.0), vec2(1.0)));
      bvec2 _474 = bvec2(_415 > _451, _446 > _409);
      float _476 = all(_474) ? _468 : ((1.0 - clamp((1.0 - _409) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_415 - _307)), vec2(0.0), vec2(1.0)), clamp(vec2(_420, _409 * _369) - vec2(max(_400 - 1.0, 0.0)), vec2(0.0), vec2(1.0))));
      float _478 = any(_474) ? _468 : _476;
      _392 = (_392 + vec4(textureLod(sampler2D(_78, _9), _440, 0.0).xyz * _478, _478)) + vec4(textureLod(sampler2D(_78, _9), _403, 0.0).xyz * _476, _476);
      _395++;
      continue;
    }
    _494 = _392 / vec4(float(2 * _362));
  } else {
    _494 = vec4(0.0);
  }
  vec4 _502 = textureLod(sampler2D(_79, _9), _4.xy, 0.0);
  vec3 _507 = _502.xyz + ((_494.xyz + (vec4(vec4(_311.xyz, 0.0).xyz * _30._m0[0u]._m1.w, _289).xyz * (1.0 - _494.w))) * (1.0 - _502.w));
  vec4 _510 = texelFetch(_88, int(0u));
  vec4 _511 = texelFetch(_88, int(1u));
  float _516 = dot(_507 * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
  bool _541;
  vec3 _542;
  if (floatBitsToInt(_69._m61) != 0) {
    vec4 _527 = texture(sampler2D(_84, _75), _4.xy);
    float _528 = _527.w;
    bool _530 = (_528 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _539;
    if (_530) {
      _539 = _527.xyz;
    } else {
      _539 = _527.xyz + (_507 * (1.0 - _528));
    }
    _541 = _530 ? true : false;
    _542 = _539;
  } else {
    _541 = false;
    _542 = _507;
  }
  vec3 _546 = min(_542 * texelFetch(_64, ivec2(0), 0).x, vec3(65504.0));
  bool _547 = !_541;
  float _683;
  vec3 _684;
  if (_547) {
    float _606;
    if (floatBitsToInt(_69._m70.x) != 0) {
      float _569 = clamp(dot(texture(sampler2D(_72, _10), _4.xy).xyz * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _69._m72.z, _69._m72.w);
      float _592 = clamp(((((_69._m70.y * log(_569 + _69._m72.x)) + _69._m70.z) - 10.0) + (_69._m72.y * _569)) + _69._m65.w, _69._m66.x, _69._m66.y);
      _606 = pow(2.0, mix(_5, clamp(_592 + ((abs(_592) * _69._m66.z) * float(int(sign(_592)))), _69._m66.x, _69._m66.y), clamp(_69._m70.x, 0.0, 1.0)));
    } else {
      _606 = _4.z;
    }
    vec4 _619 = texture(sampler2D(_77, _10), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _69._m16.w) + _69._m16.xy));
    vec3 _629 = max(_546 * vec3(0.5), _546 + vec3((_516 * (_619.w - 0.5)) * _69._m16.z));
    vec3 _682;
    if (floatBitsToInt(_69._m51.w) != 0) {
      vec2 _658 = ((_4.xy - _69._m50.xy) * mat2(vec2(_69._m52.x, _69._m52.y), vec2(_69._m52.z, _69._m52.w))) * _69._m50.zw;
      float _662 = max((dot(_658, _658) - _69._m53.x) * _69._m53.w, 0.0);
      bool _663 = _662 < 1.0;
      _682 = mix(_629, (_629 * _69._m51.xyz) * _69._m51.w, vec3(_663 ? (_663 ? (1.0 - pow(2.0, (-10.0) * _662)) : 1.0) : (0.9980499744415283203125 + (((_662 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_662 - 2.0)) : 0.0))));
    } else {
      _682 = _629;
    }
    _683 = _606;
    _684 = _682;
  } else {
    _683 = _4.z;
    _684 = _546;
  }
  vec3 _721 = _684 * mix(mix(_69._m54.xyz, _69._m56.xyz, vec3(clamp(clamp(_4.y * _69._m57.y, 0.0, 1.0) + _69._m54.w, 0.0, 1.0))), mix(_69._m56.xyz, _69._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _69._m56.w, 0.0, 1.0) * _69._m57.x, 0.0, 1.0) - _69._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _724 = _67._m3 != 0u;
  vec3 _787;
  if (_724) {
    vec3 _764 = max(vec3(0.0), _721 * (_683 / _67._m6));
    vec3 _767 = _764 * _510.x;
    _787 = (((((_764 * (_767 + vec3(_511.x))) + vec3(_511.y)) / ((_764 * (_767 + vec3(_510.y))) + vec3(_511.z))) - vec3(_511.w)) * ((_67._m4 != 0u) ? _67._m10 : _510.z)) * _67._m6;
  } else {
    vec3 _730 = max(vec3(0.0), _721 * _683);
    vec3 _733 = _730 * _510.x;
    _787 = clamp(((((_730 * (_733 + vec3(_511.x))) + vec3(_511.y)) / ((_730 * (_733 + vec3(_510.y))) + vec3(_511.z))) - vec3(_511.w)) * _510.z, vec3(0.0), vec3(1.0));
  }
  vec3 _835;
  if (_547) {
    vec3 _834;
    if (floatBitsToInt(_69._m47.w) != 0) {
      vec2 _820 = ((_4.xy - _69._m46.xy) * mat2(vec2(_69._m48.x, _69._m48.y), vec2(_69._m48.z, _69._m48.w))) * _69._m46.zw;
      _834 = mix(_787, _69._m47.xyz, vec3(_69._m47.w * texture(sampler1D(_74, _10), min(1.0, max((dot(_820, _820) - _69._m49.x) * _69._m49.w, 0.0))).w));
    } else {
      _834 = _787;
    }
    _835 = _834;
  } else {
    _835 = _787;
  }
  bool _856 = _724 && (!(_67._m2 != 0u));

#if 1
  vec3 _858 = EncodeLUTInput(_835, _67._m11, _67._m12, _67._m13, _67._m14, _856);
#else
  vec3 _858 = mix(mix((pow(_835, vec3(_67._m12)) * _67._m13) - vec3(_67._m14), _835 * _67._m11, lessThan(_835, vec3(0.003130800090730190277099609375))), _835, bvec3(_856));
#endif

  vec3 _1014;
  if (_547 && (floatBitsToInt(_69._m19.x) != 0)) {
    vec2 _870 = _4.xy * _69._m17.w;
    float _936 = (((((((fract(sin(dot(_870 + vec2(0.070000000298023223876953125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_870 + vec2(0.10999999940395355224609375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_870 + vec2(0.12999999523162841796875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_870 + vec2(0.17000000178813934326171875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_870 + vec2(0.189999997615814208984375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_870 + vec2(0.23000000417232513427734375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_870 + vec2(0.2899999916553497314453125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_870 + vec2(0.310000002384185791015625 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _938 = clamp(_936 + _69._m17.z, 0.0, 1.0);
    vec3 _1013;
    do {
      if (!(floatBitsToInt(_69._m18.w) != 0)) {
        _1013 = vec3(_938);
        break;
      }
      float _961;
      if (floatBitsToInt(_69._m18.y) != 0) {
        float _956 = dot(_858, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _961 = mix(_938, _938 * 0.5, (_956 * _956) * _956);
      } else {
        _961 = _938;
      }
      vec3 _1012;
      if (floatBitsToInt(_69._m19.z) != 0) {
        vec3 _994 = vec3(_961);
        vec3 _996 = _994 * 2.0;
        _1012 = mix(_858, mix(((_858 * 2.0) * (vec3(1.0) - _994)) + (sqrt(_858) * (_996 - vec3(1.0))), (_996 * _858) + ((_858 * _858) * (vec3(1.0) - _996)), lessThan(_994, vec3(0.5))), vec3(_69._m18.x));
      } else {
        vec3 _993;
        if (floatBitsToInt(_69._m19.w) != 0) {
          vec3 _981 = vec3(_961);
          _993 = mix(_858, mix(vec3(1.0) - (((vec3(1.0) - _981) * 2.0) * (vec3(1.0) - _858)), (_981 * 2.0) * _858, lessThan(_858, vec3(0.5))), vec3(_69._m18.x));
        } else {
          _993 = clamp(max(_858 * 0.02500000037252902984619140625, _858 + vec3((_961 - 0.5) * _69._m18.x)), vec3(0.0), vec3(1.0));
        }
        _1012 = _993;
      }
      _1013 = _1012;
      break;
    } while (false);
    _1014 = _1013;
  } else {
    _1014 = _858;
  }
  vec3 _1016 = max(_1014 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _1017 = _1016.y;
  vec3 _1042 = mix(_1014, clamp((_69._m81.xyz * (_1017 * ((1.33000004291534423828125 * (1.0 + ((_1017 + _1016.z) / _1016.x))) - 1.67999994754791259765625))) * _69._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _516)) * _69._m82.x) + _69._m82.y, 0.0, 1.0)));
  vec3 _1072;
  if (floatBitsToInt(_69._m84.w) != 0) {
    _1072 = mix(_1042, texture(sampler2D(_85, _10), ((((_4.xy - vec2(0.5)) * _69._m84.z) / mix(_69._m85.wx, _69._m85.zy, _4.yx)) - _69._m84.xy) + vec2(0.5)).xyz, vec3(_69._m84.w));
  } else {
    _1072 = _1042;
  }
  vec3 _1230;
  if (_547) {
    float _1091 = max(max(_1072.x, max(_1072.y, _1072.z)), 9.9999997473787516355514526367188e-05);
    float _1097 = (_856 && (!(_67._m5 != 0u))) ? 1.0 : (((_1091 > _67._m7) ? ((_1091 * _67._m8) + _67._m9) : _1091) / _1091);
    vec3 _1098 = _1072 * _1097;
    float _1101 = _1098.z;
    float _1103 = floor(_1101 * 14.99989986419677734375);
    float _1109 = (_1103 * 0.0625) + (_1098.x * 0.05859375);
    float _1111 = _1098.y * 0.9375;
    vec4 _1115 = texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1109, _1111));
    vec4 _1121 = texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1109 + 0.0625, _1111));
    vec3 _1124 = mix(_1115.xyz, _1121.xyz, vec3((_1101 * 15.0) - _1103));
    vec3 _1227;
    if (_93._m0[0u]._m0._m0 > 0) {
      float _1158 = _1124.z;
      float _1160 = floor(_1158 * 14.99989986419677734375);
      float _1166 = (_1160 * 0.0625) + (_1124.x * 0.05859375);
      float _1168 = _1124.y * 0.9375;
      vec3 _1183 = mix(_1124, mix(texture(sampler2D(_80, _10), vec2(0.001953125, 0.03125) + vec2(_1166, _1168)).xyz, texture(sampler2D(_80, _10), vec2(0.001953125, 0.03125) + vec2(_1166 + 0.0625, _1168)).xyz, vec3((_1158 * 15.0) - _1160)), vec3(clamp(((_307 < _93._m0[0u]._m1[0]._m2) ? clamp((_307 - _93._m0[0u]._m1[0]._m0) * _93._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_307 - _93._m0[0u]._m1[0]._m2) * _93._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _93._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _1195 = _1183.z;
      float _1197 = floor(_1195 * 14.99989986419677734375);
      float _1203 = (_1197 * 0.0625) + (_1183.x * 0.05859375);
      float _1205 = _1183.y * 0.9375;
      _1227 = mix(_1183, mix(_1183, mix(texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1203, _1205)).xyz, texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1203 + 0.0625, _1205)).xyz, vec3((_1195 * 15.0) - _1197)), vec3(clamp(((_307 < _93._m0[0u]._m1[1]._m2) ? clamp((_307 - _93._m0[0u]._m1[1]._m0) * _93._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_307 - _93._m0[0u]._m1[1]._m2) * _93._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _93._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_83, _10), _4.xy).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
    } else {
      _1227 = _1124;
    }
    _1230 = _1227 / vec3(_1097);
  } else {
    _1230 = _1072;
  }

#if 1
  _1230 = DecodeLUTInput(_1230);
#endif

  vec4 _1235 = vec4(_1230, dot(_1230, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1236 = _1235.xyz;
  ivec4 _1278 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_60._m0[0u]._m22) & 31), 0u));
  vec3 _1286 = (vec3(texelFetch(_63, _1278.xyz, _1278.w).x) * 2.0) - vec3(1.0);
  vec3 _1297;
  if (_724) {
    _1297 = vec3(ivec3(sign(_1286))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1286)));
  } else {
    _1297 = _1286;
  }
  vec3 _1299 = _1236 + (_1297 * mix(_69._m39.xyz, _69._m40.xyz, pow(clamp((mix(vec3(max(_1230.x, max(_1230.y, _1230.z))), _1236, bvec3(floatBitsToInt(_69._m41.w) != 0)) - _69._m42.xyz) * _69._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_69._m42.w))));
  vec4 _1300 = vec4(_1299.x, _1299.y, _1299.z, _1235.w);
  vec4 _1305;
  if (!_724) {
    _1305 = clamp(_1300, vec4(0.0), vec4(1.0));
  } else {
    _1305 = _1300;
  }
  _6 = _1305;
}

