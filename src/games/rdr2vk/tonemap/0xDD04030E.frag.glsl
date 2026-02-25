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

struct _97 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _98 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _96 {
  _97 _m0;
  _98 _m1[11];
};

float _295;

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

layout(set = 0, binding = 214, std430) readonly buffer _95_99 {
  _96 _m0[];
}
_99;

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
layout(set = 1, binding = 194) uniform texture2D _80;
layout(set = 1, binding = 196) uniform texture2D _81;
layout(set = 1, binding = 197) uniform texture2D _82;
layout(set = 1, binding = 198) uniform texture2D _83;
layout(set = 1, binding = 199) uniform texture2D _84;
layout(set = 1, binding = 200) uniform texture2D _85;
layout(set = 1, binding = 201) uniform texture2D _86;
layout(set = 1, binding = 202) uniform texture2D _87;
layout(set = 1, binding = 203) uniform texture2D _88;
layout(set = 1, binding = 204) uniform texture2D _89;
layout(set = 1, binding = 205) uniform texture2D _90;
layout(set = 1, binding = 207) uniform texture2D _91;
layout(set = 1, binding = 209) uniform texture2D _92;
layout(set = 1, binding = 210) uniform texture2D _93;
layout(set = 1, binding = 212) uniform samplerBuffer _94;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  float _310 = 1.0 + _69._m0.w;
  float _313 = _69._m0.z / (_310 - textureLod(sampler2D(_71, _8), _4.xy, 0.0).x);
  vec4 _317 = texture(sampler2D(_76, _75), _4.xy);
  vec4 _342 = textureLod(sampler2D(_93, _8), _4.xy * _69._m80.xy, 0.0) * 1.0;
  float _343 = _342.z;
  vec4 _500;
  SPIRV_CROSS_BRANCH
  if ((_343 >= 1.0) && (_342.w < 2.0)) {
    float _361 = min(length(textureLod(sampler2D(_92, _8), _4.xy, 0.0).xy * _69._m20.x), _69._m20.z);
    float _364 = min(_343, 2.0);
    vec2 _365 = (_342.xy / vec2(_343)) * _364;
    int _368 = int(min(2.0, 1.0 + _364));
    vec2 _372 = _365 * _69._m63.xy;
    float _374 = float(_368) - 0.5;
    float _375 = _374 / _364;
    vec2 _377 = (-_365) * _69._m63.xy;
    vec2 _380 = vec2(uvec2(gl_FragCoord.xy) & uvec2(1u));
    float _394 = ((((_380.x * 2.0) - 1.0) * ((_380.y * 2.0) - 1.0)) * _69._m20.w) * clamp((_364 - 2.0) * 0.5, 0.0, 1.0);
    float _395 = 0.5 + _394;
    float _396 = 0.5 - _394;
    vec4 _398;
    _398 = vec4(0.0);
    for (int _401 = 0; _401 < _368;) {
      float _405 = float(_401);
      float _406 = _405 + _395;
      vec2 _409 = _4.xy + (_372 * (_406 / _374));
      float _415 = min(length(textureLod(sampler2D(_92, _8), _409, 0.0).xy * _69._m20.x), _69._m20.z);
      float _421 = _69._m0.z / (_310 - textureLod(sampler2D(_70, _8), _409, 0.0).x);
      float _426 = _361 * _375;
      float _443 = _405 + _396;
      vec2 _446 = _4.xy + (_377 * (_443 / _374));
      float _452 = min(length(textureLod(sampler2D(_92, _8), _446, 0.0).xy * _69._m20.x), _69._m20.z);
      float _457 = _69._m0.z / (_310 - textureLod(sampler2D(_70, _8), _446, 0.0).x);
      float _474 = (1.0 - clamp((1.0 - _452) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_457 - _313)), vec2(0.0), vec2(1.0)), clamp(vec2(_426, _452 * _375) - vec2(max(_443 - 1.0, 0.0)), vec2(0.0), vec2(1.0)));
      bvec2 _480 = bvec2(_421 > _457, _452 > _415);
      float _482 = all(_480) ? _474 : ((1.0 - clamp((1.0 - _415) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_421 - _313)), vec2(0.0), vec2(1.0)), clamp(vec2(_426, _415 * _375) - vec2(max(_406 - 1.0, 0.0)), vec2(0.0), vec2(1.0))));
      float _484 = any(_480) ? _474 : _482;
      _398 = (_398 + vec4(textureLod(sampler2D(_78, _9), _446, 0.0).xyz * _484, _484)) + vec4(textureLod(sampler2D(_78, _9), _409, 0.0).xyz * _482, _482);
      _401++;
      continue;
    }
    _500 = _398 / vec4(float(2 * _368));
  } else {
    _500 = vec4(0.0);
  }
  vec4 _508 = textureLod(sampler2D(_79, _9), _4.xy, 0.0);
  vec3 _513 = _508.xyz + ((_500.xyz + (vec4(vec4(_317.xyz, 0.0).xyz * _30._m0[0u]._m1.w, _295).xyz * (1.0 - _500.w))) * (1.0 - _508.w));
  vec4 _516 = texelFetch(_94, int(0u));
  vec4 _517 = texelFetch(_94, int(1u));
  float _522 = dot(_513 * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
  bool _547;
  vec3 _548;
  if (floatBitsToInt(_69._m61) != 0) {
    vec4 _533 = texture(sampler2D(_90, _75), _4.xy);
    float _534 = _533.w;
    bool _536 = (_534 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _545;
    if (_536) {
      _545 = _533.xyz;
    } else {
      _545 = _533.xyz + (_513 * (1.0 - _534));
    }
    _547 = _536 ? true : false;
    _548 = _545;
  } else {
    _547 = false;
    _548 = _513;
  }
  vec3 _552 = min(_548 * texelFetch(_64, ivec2(0), 0).x, vec3(65504.0));
  bool _553 = !_547;
  float _689;
  vec3 _690;
  if (_553) {
    float _612;
    if (floatBitsToInt(_69._m70.x) != 0) {
      float _575 = clamp(dot(texture(sampler2D(_72, _10), _4.xy).xyz * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _69._m72.z, _69._m72.w);
      float _598 = clamp(((((_69._m70.y * log(_575 + _69._m72.x)) + _69._m70.z) - 10.0) + (_69._m72.y * _575)) + _69._m65.w, _69._m66.x, _69._m66.y);
      _612 = pow(2.0, mix(_5, clamp(_598 + ((abs(_598) * _69._m66.z) * float(int(sign(_598)))), _69._m66.x, _69._m66.y), clamp(_69._m70.x, 0.0, 1.0)));
    } else {
      _612 = _4.z;
    }
    vec4 _625 = texture(sampler2D(_77, _10), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _69._m16.w) + _69._m16.xy));
    vec3 _635 = max(_552 * vec3(0.5), _552 + vec3((_522 * (_625.w - 0.5)) * _69._m16.z));
    vec3 _688;
    if (floatBitsToInt(_69._m51.w) != 0) {
      vec2 _664 = ((_4.xy - _69._m50.xy) * mat2(vec2(_69._m52.x, _69._m52.y), vec2(_69._m52.z, _69._m52.w))) * _69._m50.zw;
      float _668 = max((dot(_664, _664) - _69._m53.x) * _69._m53.w, 0.0);
      bool _669 = _668 < 1.0;
      _688 = mix(_635, (_635 * _69._m51.xyz) * _69._m51.w, vec3(_669 ? (_669 ? (1.0 - pow(2.0, (-10.0) * _668)) : 1.0) : (0.9980499744415283203125 + (((_668 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_668 - 2.0)) : 0.0))));
    } else {
      _688 = _635;
    }
    _689 = _612;
    _690 = _688;
  } else {
    _689 = _4.z;
    _690 = _552;
  }
  vec3 _727 = _690 * mix(mix(_69._m54.xyz, _69._m56.xyz, vec3(clamp(clamp(_4.y * _69._m57.y, 0.0, 1.0) + _69._m54.w, 0.0, 1.0))), mix(_69._m56.xyz, _69._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _69._m56.w, 0.0, 1.0) * _69._m57.x, 0.0, 1.0) - _69._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _730 = _67._m3 != 0u;
  vec3 _793;
  if (_730) {
    vec3 _770 = max(vec3(0.0), _727 * (_689 / _67._m6));
    vec3 _773 = _770 * _516.x;
    _793 = (((((_770 * (_773 + vec3(_517.x))) + vec3(_517.y)) / ((_770 * (_773 + vec3(_516.y))) + vec3(_517.z))) - vec3(_517.w)) * ((_67._m4 != 0u) ? _67._m10 : _516.z)) * _67._m6;
  } else {
    vec3 _736 = max(vec3(0.0), _727 * _689);
    vec3 _739 = _736 * _516.x;
    _793 = clamp(((((_736 * (_739 + vec3(_517.x))) + vec3(_517.y)) / ((_736 * (_739 + vec3(_516.y))) + vec3(_517.z))) - vec3(_517.w)) * _516.z, vec3(0.0), vec3(1.0));
  }
  vec3 _841;
  if (_553) {
    vec3 _840;
    if (floatBitsToInt(_69._m47.w) != 0) {
      vec2 _826 = ((_4.xy - _69._m46.xy) * mat2(vec2(_69._m48.x, _69._m48.y), vec2(_69._m48.z, _69._m48.w))) * _69._m46.zw;
      _840 = mix(_793, _69._m47.xyz, vec3(_69._m47.w * texture(sampler1D(_74, _10), min(1.0, max((dot(_826, _826) - _69._m49.x) * _69._m49.w, 0.0))).w));
    } else {
      _840 = _793;
    }
    _841 = _840;
  } else {
    _841 = _793;
  }
  bool _862 = _730 && (!(_67._m2 != 0u));
#if 1
  vec3 _864 = EncodeLUTInput(_841, _67._m11, _67._m12, _67._m13, _67._m14, _862);
#else
  vec3 _864 = mix(mix((pow(_841, vec3(_67._m12)) * _67._m13) - vec3(_67._m14), _841 * _67._m11, lessThan(_841, vec3(0.003130800090730190277099609375))), _841, bvec3(_862));
#endif

  vec3 _1020;
  if (_553 && (floatBitsToInt(_69._m19.x) != 0)) {
    vec2 _876 = _4.xy * _69._m17.w;
    float _942 = (((((((fract(sin(dot(_876 + vec2(0.070000000298023223876953125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_876 + vec2(0.10999999940395355224609375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_876 + vec2(0.12999999523162841796875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_876 + vec2(0.17000000178813934326171875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_876 + vec2(0.189999997615814208984375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_876 + vec2(0.23000000417232513427734375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_876 + vec2(0.2899999916553497314453125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_876 + vec2(0.310000002384185791015625 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _944 = clamp(_942 + _69._m17.z, 0.0, 1.0);
    vec3 _1019;
    do {
      if (!(floatBitsToInt(_69._m18.w) != 0)) {
        _1019 = vec3(_944);
        break;
      }
      float _967;
      if (floatBitsToInt(_69._m18.y) != 0) {
        float _962 = dot(_864, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _967 = mix(_944, _944 * 0.5, (_962 * _962) * _962);
      } else {
        _967 = _944;
      }
      vec3 _1018;
      if (floatBitsToInt(_69._m19.z) != 0) {
        vec3 _1000 = vec3(_967);
        vec3 _1002 = _1000 * 2.0;
        _1018 = mix(_864, mix(((_864 * 2.0) * (vec3(1.0) - _1000)) + (sqrt(_864) * (_1002 - vec3(1.0))), (_1002 * _864) + ((_864 * _864) * (vec3(1.0) - _1002)), lessThan(_1000, vec3(0.5))), vec3(_69._m18.x));
      } else {
        vec3 _999;
        if (floatBitsToInt(_69._m19.w) != 0) {
          vec3 _987 = vec3(_967);
          _999 = mix(_864, mix(vec3(1.0) - (((vec3(1.0) - _987) * 2.0) * (vec3(1.0) - _864)), (_987 * 2.0) * _864, lessThan(_864, vec3(0.5))), vec3(_69._m18.x));
        } else {
          _999 = clamp(max(_864 * 0.02500000037252902984619140625, _864 + vec3((_967 - 0.5) * _69._m18.x)), vec3(0.0), vec3(1.0));
        }
        _1018 = _999;
      }
      _1019 = _1018;
      break;
    } while (false);
    _1020 = _1019;
  } else {
    _1020 = _864;
  }
  vec3 _1022 = max(_1020 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _1023 = _1022.y;
  vec3 _1048 = mix(_1020, clamp((_69._m81.xyz * (_1023 * ((1.33000004291534423828125 * (1.0 + ((_1023 + _1022.z) / _1022.x))) - 1.67999994754791259765625))) * _69._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _522)) * _69._m82.x) + _69._m82.y, 0.0, 1.0)));
  vec3 _1078;
  if (floatBitsToInt(_69._m84.w) != 0) {
    _1078 = mix(_1048, texture(sampler2D(_91, _10), ((((_4.xy - vec2(0.5)) * _69._m84.z) / mix(_69._m85.wx, _69._m85.zy, _4.yx)) - _69._m84.xy) + vec2(0.5)).xyz, vec3(_69._m84.w));
  } else {
    _1078 = _1048;
  }
  vec3 _1389;
  if (_553) {
    float _1097 = max(max(_1078.x, max(_1078.y, _1078.z)), 9.9999997473787516355514526367188e-05);
    float _1103 = (_862 && (!(_67._m5 != 0u))) ? 1.0 : (((_1097 > _67._m7) ? ((_1097 * _67._m8) + _67._m9) : _1097) / _1097);
    vec3 _1104 = _1078 * _1103;
    float _1107 = _1104.z;
    float _1109 = floor(_1107 * 14.99989986419677734375);
    float _1115 = (_1109 * 0.0625) + (_1104.x * 0.05859375);
    float _1117 = _1104.y * 0.9375;
    vec4 _1121 = texture(sampler2D(_87, _10), vec2(0.001953125, 0.03125) + vec2(_1115, _1117));
    vec4 _1127 = texture(sampler2D(_87, _10), vec2(0.001953125, 0.03125) + vec2(_1115 + 0.0625, _1117));
    vec3 _1130 = mix(_1121.xyz, _1127.xyz, vec3((_1107 * 15.0) - _1109));
    vec3 _1386;
    if (_99._m0[0u]._m0._m0 > 0) {
      vec4 _1138 = texture(sampler2D(_80, _8), _4.xy);
      vec4 _1141 = _1138 * _99._m0[0u]._m0._m1;
      vec4 _1144 = texture(sampler2D(_89, _10), _4.xy);
      float _1146 = dot(_1144.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
      float _1148 = clamp(_1141.x, 0.0, 1.0);
      float _1150 = _1146 * _1148;
      vec3 _1180;
      if (_1150 != 0.0) {
        float _1154 = _1130.z;
        float _1156 = floor(_1154 * 14.99989986419677734375);
        float _1162 = (_1156 * 0.0625) + (_1130.x * 0.05859375);
        float _1164 = _1130.y * 0.9375;
        _1180 = mix(_1130, mix(texture(sampler2D(_83, _10), vec2(0.001953125, 0.03125) + vec2(_1162, _1164)).xyz, texture(sampler2D(_83, _10), vec2(0.001953125, 0.03125) + vec2(_1162 + 0.0625, _1164)).xyz, vec3((_1154 * 15.0) - _1156)), vec3(_1150));
      } else {
        _1180 = _1130;
      }
      float _1182 = clamp(_1141.y, 0.0, 1.0);
      float _1184 = _1146 * _1182;
      vec3 _1214;
      if (_1184 != 0.0) {
        float _1190 = floor(_1180.z * 14.99989986419677734375);
        float _1196 = (_1190 * 0.0625) + (_1180.x * 0.05859375);
        float _1198 = _1180.y * 0.9375;
        _1214 = mix(_1180, mix(texture(sampler2D(_84, _10), vec2(0.001953125, 0.03125) + vec2(_1196, _1198)).xyz, texture(sampler2D(_84, _10), vec2(0.001953125, 0.03125) + vec2(_1196 + 0.0625, _1198)).xyz, vec3((_1180.z * 15.0) - _1190)), vec3(_1184));
      } else {
        _1214 = _1180;
      }
      float _1216 = clamp(_1141.z, 0.0, 1.0);
      float _1218 = _1146 * _1216;
      vec3 _1248;
      if (_1218 != 0.0) {
        float _1224 = floor(_1214.z * 14.99989986419677734375);
        float _1230 = (_1224 * 0.0625) + (_1214.x * 0.05859375);
        float _1232 = _1214.y * 0.9375;
        _1248 = mix(_1214, mix(texture(sampler2D(_85, _10), vec2(0.001953125, 0.03125) + vec2(_1230, _1232)).xyz, texture(sampler2D(_85, _10), vec2(0.001953125, 0.03125) + vec2(_1230 + 0.0625, _1232)).xyz, vec3((_1214.z * 15.0) - _1224)), vec3(_1218));
      } else {
        _1248 = _1214;
      }
      float _1250 = clamp(_1141.w, 0.0, 1.0);
      float _1252 = _1146 * _1250;
      vec3 _1282;
      if (_1252 != 0.0) {
        float _1258 = floor(_1248.z * 14.99989986419677734375);
        float _1264 = (_1258 * 0.0625) + (_1248.x * 0.05859375);
        float _1266 = _1248.y * 0.9375;
        _1282 = mix(_1248, mix(texture(sampler2D(_86, _10), vec2(0.001953125, 0.03125) + vec2(_1264, _1266)).xyz, texture(sampler2D(_86, _10), vec2(0.001953125, 0.03125) + vec2(_1264 + 0.0625, _1266)).xyz, vec3((_1248.z * 15.0) - _1258)), vec3(_1252));
      } else {
        _1282 = _1248;
      }
      float _1318 = floor(_1282.z * 14.99989986419677734375);
      float _1324 = (_1318 * 0.0625) + (_1282.x * 0.05859375);
      float _1326 = _1282.y * 0.9375;
      vec3 _1341 = mix(_1282, mix(texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1324, _1326)).xyz, texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1324 + 0.0625, _1326)).xyz, vec3((_1282.z * 15.0) - _1318)), vec3(clamp(((_313 < _99._m0[0u]._m1[0]._m2) ? clamp((_313 - _99._m0[0u]._m1[0]._m0) * _99._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_313 - _99._m0[0u]._m1[0]._m2) * _99._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _99._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _1353 = _1341.z;
      float _1355 = floor(_1353 * 14.99989986419677734375);
      float _1361 = (_1355 * 0.0625) + (_1341.x * 0.05859375);
      float _1363 = _1341.y * 0.9375;
      _1386 = mix(_1341, mix(_1341, mix(texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1361, _1363)).xyz, texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1361 + 0.0625, _1363)).xyz, vec3((_1353 * 15.0) - _1355)), vec3(clamp(((_313 < _99._m0[0u]._m1[1]._m2) ? clamp((_313 - _99._m0[0u]._m1[1]._m0) * _99._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_313 - _99._m0[0u]._m1[1]._m2) * _99._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _99._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_88, _10), _4.xy).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) * (1.0 - clamp(((_1148 + _1182) + _1216) + _1250, 0.0, 1.0))));
    } else {
      _1386 = _1130;
    }
    _1389 = _1386 / vec3(_1103);
  } else {
    _1389 = _1078;
  }

#if 1
  _1389 = DecodeLUTInput(_1389);
#endif

  vec4 _1394 = vec4(_1389, dot(_1389, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1395 = _1394.xyz;
  ivec4 _1437 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_60._m0[0u]._m22) & 31), 0u));
  vec3 _1445 = (vec3(texelFetch(_63, _1437.xyz, _1437.w).x) * 2.0) - vec3(1.0);
  vec3 _1456;
  if (_730) {
    _1456 = vec3(ivec3(sign(_1445))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1445)));
  } else {
    _1456 = _1445;
  }
  vec3 _1458 = _1395 + (_1456 * mix(_69._m39.xyz, _69._m40.xyz, pow(clamp((mix(vec3(max(_1389.x, max(_1389.y, _1389.z))), _1395, bvec3(floatBitsToInt(_69._m41.w) != 0)) - _69._m42.xyz) * _69._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_69._m42.w))));
  vec4 _1459 = vec4(_1458.x, _1458.y, _1458.z, _1394.w);
  vec4 _1464;
  if (!_730) {
    _1464 = clamp(_1459, vec4(0.0), vec4(1.0));
  } else {
    _1464 = _1459;
  }
  _6 = _1464;
}

