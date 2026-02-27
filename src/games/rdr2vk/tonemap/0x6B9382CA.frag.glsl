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

struct _98 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _99 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _97 {
  _98 _m0;
  _99 _m1[11];
};

float _296;

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

layout(set = 0, binding = 214, std430) readonly buffer _96_100 {
  _97 _m0[];
}
_100;

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
layout(set = 1, binding = 206) uniform texture2D _91;
layout(set = 1, binding = 207) uniform texture2D _92;
layout(set = 1, binding = 209) uniform texture2D _93;
layout(set = 1, binding = 210) uniform texture2D _94;
layout(set = 1, binding = 212) uniform samplerBuffer _95;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _306 = texture(sampler2D(_91, _8), _4.xy);
  vec2 _307 = _306.xy;
  float _315 = 1.0 + _69._m0.w;
  float _318 = _69._m0.z / (_315 - textureLod(sampler2D(_71, _8), _307, 0.0).x);
  vec4 _322 = texture(sampler2D(_76, _75), _307);
  vec4 _347 = textureLod(sampler2D(_94, _8), _307 * _69._m80.xy, 0.0) * 1.0;
  float _348 = _347.z;
  vec4 _505;
  SPIRV_CROSS_BRANCH
  if ((_348 >= 1.0) && (_347.w < 2.0)) {
    float _366 = min(length(textureLod(sampler2D(_93, _8), _307, 0.0).xy * _69._m20.x), _69._m20.z);
    float _369 = min(_348, 2.0);
    vec2 _370 = (_347.xy / vec2(_348)) * _369;
    int _373 = int(min(2.0, 1.0 + _369));
    vec2 _377 = _370 * _69._m63.xy;
    float _379 = float(_373) - 0.5;
    float _380 = _379 / _369;
    vec2 _382 = (-_370) * _69._m63.xy;
    vec2 _385 = vec2(uvec2(gl_FragCoord.xy) & uvec2(1u));
    float _399 = ((((_385.x * 2.0) - 1.0) * ((_385.y * 2.0) - 1.0)) * _69._m20.w) * clamp((_369 - 2.0) * 0.5, 0.0, 1.0);
    float _400 = 0.5 + _399;
    float _401 = 0.5 - _399;
    vec4 _403;
    _403 = vec4(0.0);
    for (int _406 = 0; _406 < _373;) {
      float _410 = float(_406);
      float _411 = _410 + _400;
      vec2 _414 = _307 + (_377 * (_411 / _379));
      float _420 = min(length(textureLod(sampler2D(_93, _8), _414, 0.0).xy * _69._m20.x), _69._m20.z);
      float _426 = _69._m0.z / (_315 - textureLod(sampler2D(_70, _8), _414, 0.0).x);
      float _431 = _366 * _380;
      float _448 = _410 + _401;
      vec2 _451 = _307 + (_382 * (_448 / _379));
      float _457 = min(length(textureLod(sampler2D(_93, _8), _451, 0.0).xy * _69._m20.x), _69._m20.z);
      float _462 = _69._m0.z / (_315 - textureLod(sampler2D(_70, _8), _451, 0.0).x);
      float _479 = (1.0 - clamp((1.0 - _457) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_462 - _318)), vec2(0.0), vec2(1.0)), clamp(vec2(_431, _457 * _380) - vec2(max(_448 - 1.0, 0.0)), vec2(0.0), vec2(1.0)));
      bvec2 _485 = bvec2(_426 > _462, _457 > _420);
      float _487 = all(_485) ? _479 : ((1.0 - clamp((1.0 - _420) * 8.0, 0.0, 1.0)) * dot(clamp(vec2(0.5) + (vec2(1.0, -1.0) * (_426 - _318)), vec2(0.0), vec2(1.0)), clamp(vec2(_431, _420 * _380) - vec2(max(_411 - 1.0, 0.0)), vec2(0.0), vec2(1.0))));
      float _489 = any(_485) ? _479 : _487;
      _403 = (_403 + vec4(textureLod(sampler2D(_78, _9), _451, 0.0).xyz * _489, _489)) + vec4(textureLod(sampler2D(_78, _9), _414, 0.0).xyz * _487, _487);
      _406++;
      continue;
    }
    _505 = _403 / vec4(float(2 * _373));
  } else {
    _505 = vec4(0.0);
  }
  vec4 _513 = textureLod(sampler2D(_79, _9), _307, 0.0);
  vec3 _518 = _513.xyz + ((_505.xyz + (vec4(vec4(_322.xyz, 0.0).xyz * _30._m0[0u]._m1.w, _296).xyz * (1.0 - _505.w))) * (1.0 - _513.w));
  vec4 _521 = texelFetch(_95, int(0u));
  vec4 _522 = texelFetch(_95, int(1u));
  float _527 = dot(_518 * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375));
  bool _552;
  vec3 _553;
  if (floatBitsToInt(_69._m61) != 0) {
    vec4 _538 = texture(sampler2D(_90, _75), _4.xy);
    float _539 = _538.w;
    bool _541 = (_539 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _550;
    if (_541) {
      _550 = _538.xyz;
    } else {
      _550 = _538.xyz + (_518 * (1.0 - _539));
    }
    _552 = _541 ? true : false;
    _553 = _550;
  } else {
    _552 = false;
    _553 = _518;
  }
  vec3 _557 = min(_553 * texelFetch(_64, ivec2(0), 0).x, vec3(GetTonemapClampMax()));
  bool _558 = !_552;
  float _694;
  vec3 _695;
  if (_558) {
    float _617;
    if (floatBitsToInt(_69._m70.x) != 0) {
      float _580 = clamp(dot(texture(sampler2D(_72, _10), _307).xyz * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _69._m72.z, _69._m72.w);
      float _603 = clamp(((((_69._m70.y * log(_580 + _69._m72.x)) + _69._m70.z) - 10.0) + (_69._m72.y * _580)) + _69._m65.w, _69._m66.x, _69._m66.y);
      _617 = pow(2.0, mix(_5, clamp(_603 + ((abs(_603) * _69._m66.z) * float(int(sign(_603)))), _69._m66.x, _69._m66.y), clamp(_69._m70.x, 0.0, 1.0)));
    } else {
      _617 = _4.z;
    }
    vec4 _630 = texture(sampler2D(_77, _10), fract(((_4.xy * vec2(1.60000002384185791015625, 0.89999997615814208984375)) * _69._m16.w) + _69._m16.xy));
    vec3 _640 = max(_557 * vec3(0.5), _557 + vec3((_527 * (_630.w - 0.5)) * _69._m16.z));
    vec3 _693;
    if (floatBitsToInt(_69._m51.w) != 0) {
      vec2 _669 = ((_4.xy - _69._m50.xy) * mat2(vec2(_69._m52.x, _69._m52.y), vec2(_69._m52.z, _69._m52.w))) * _69._m50.zw;
      float _673 = CUSTOM_VIGNETTE * max((dot(_669, _669) - _69._m53.x) * _69._m53.w, 0.0);
      bool _674 = _673 < 1.0;
      _693 = mix(_640, (_640 * _69._m51.xyz) * _69._m51.w, vec3(_674 ? (_674 ? (1.0 - pow(2.0, (-10.0) * _673)) : 1.0) : (0.9980499744415283203125 + (((_673 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_673 - 2.0)) : 0.0))));
    } else {
      _693 = _640;
    }
    _694 = _617;
    _695 = _693;
  } else {
    _694 = _4.z;
    _695 = _557;
  }
  vec3 _732 = _695 * mix(mix(_69._m54.xyz, _69._m56.xyz, vec3(clamp(clamp(_4.y * _69._m57.y, 0.0, 1.0) + _69._m54.w, 0.0, 1.0))), mix(_69._m56.xyz, _69._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _69._m56.w, 0.0, 1.0) * _69._m57.x, 0.0, 1.0) - _69._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _735 = _67._m3 != 0u;
#if 1
  vec3 _798 = ApplyToneMap(_732, _735, _694, _67._m6, _67._m4, _67._m10, _521.rgb, _522);
#else
  vec3 _798;
  if (_735) {
    vec3 _775 = max(vec3(0.0), _732 * (_694 / _67._m6));
    vec3 _778 = _775 * _521.x;
    _798 = (((((_775 * (_778 + vec3(_522.x))) + vec3(_522.y)) / ((_775 * (_778 + vec3(_521.y))) + vec3(_522.z))) - vec3(_522.w)) * ((_67._m4 != 0u) ? _67._m10 : _521.z)) * _67._m6;
  } else {
    vec3 _741 = max(vec3(0.0), _732 * _694);
    vec3 _744 = _741 * _521.x;
    _798 = clamp(((((_741 * (_744 + vec3(_522.x))) + vec3(_522.y)) / ((_741 * (_744 + vec3(_521.y))) + vec3(_522.z))) - vec3(_522.w)) * _521.z, vec3(0.0), vec3(1.0));
  }
#endif
  vec3 _846;
  if (_558) {
    vec3 _845;
    if (floatBitsToInt(_69._m47.w) != 0) {
      vec2 _831 = ((_4.xy - _69._m46.xy) * mat2(vec2(_69._m48.x, _69._m48.y), vec2(_69._m48.z, _69._m48.w))) * _69._m46.zw;
      _845 = mix(_798, _69._m47.xyz, vec3(_69._m47.w * texture(sampler1D(_74, _10), min(1.0, max((dot(_831, _831) - _69._m49.x) * _69._m49.w, 0.0))).w));
    } else {
      _845 = _798;
    }
    _846 = _845;
  } else {
    _846 = _798;
  }
  bool _867 = _735 && (!(_67._m2 != 0u));
#if 1
  vec3 _869 = EncodeLUTInput(_846, _67._m11, _67._m12, _67._m13, _67._m14, _867);
#else
  vec3 _869 = mix(mix((pow(_846, vec3(_67._m12)) * _67._m13) - vec3(_67._m14), _846 * _67._m11, lessThan(_846, vec3(0.003130800090730190277099609375))), _846, bvec3(_867));
#endif
 
 
  vec3 _1025;
  if (_558 && (floatBitsToInt(_69._m19.x) != 0)) {
    vec2 _881 = _4.xy * _69._m17.w;
    float _947 = (((((((fract(sin(dot(_881 + vec2(0.070000000298023223876953125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_881 + vec2(0.10999999940395355224609375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_881 + vec2(0.12999999523162841796875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_881 + vec2(0.17000000178813934326171875 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_881 + vec2(0.189999997615814208984375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_881 + vec2(0.23000000417232513427734375 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_881 + vec2(0.2899999916553497314453125 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_881 + vec2(0.310000002384185791015625 * _69._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _949 = clamp(_947 + _69._m17.z, 0.0, 1.0);
    vec3 _1024;
    do {
      if (!(floatBitsToInt(_69._m18.w) != 0)) {
        _1024 = vec3(_949);
        break;
      }
      float _972;
      if (floatBitsToInt(_69._m18.y) != 0) {
        float _967 = dot(_869, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _972 = mix(_949, _949 * 0.5, (_967 * _967) * _967);
      } else {
        _972 = _949;
      }
      vec3 _1023;
      if (floatBitsToInt(_69._m19.z) != 0) {
        vec3 _1005 = vec3(_972);
        vec3 _1007 = _1005 * 2.0;
        _1023 = mix(_869, mix(((_869 * 2.0) * (vec3(1.0) - _1005)) + (sqrt(_869) * (_1007 - vec3(1.0))), (_1007 * _869) + ((_869 * _869) * (vec3(1.0) - _1007)), lessThan(_1005, vec3(0.5))), vec3(_69._m18.x));
      } else {
        vec3 _1004;
        if (floatBitsToInt(_69._m19.w) != 0) {
          vec3 _992 = vec3(_972);
          _1004 = mix(_869, mix(vec3(1.0) - (((vec3(1.0) - _992) * 2.0) * (vec3(1.0) - _869)), (_992 * 2.0) * _869, lessThan(_869, vec3(0.5))), vec3(_69._m18.x));
        } else {
          _1004 = clamp(max(_869 * 0.02500000037252902984619140625, _869 + vec3((_972 - 0.5) * _69._m18.x)), vec3(0.0), vec3(1.0));
        }
        _1023 = _1004;
      }
      _1024 = _1023;
      break;
    } while (false);
    _1025 = _1024;
  } else {
    _1025 = _869;
  }
  vec3 _1027 = max(_1025 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _1028 = _1027.y;
  vec3 _1053 = mix(_1025, clamp((_69._m81.xyz * (_1028 * ((1.33000004291534423828125 * (1.0 + ((_1028 + _1027.z) / _1027.x))) - 1.67999994754791259765625))) * _69._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + _527)) * _69._m82.x) + _69._m82.y, 0.0, 1.0)));
  vec3 _1083;
  if (floatBitsToInt(_69._m84.w) != 0) {
    _1083 = mix(_1053, texture(sampler2D(_92, _10), ((((_4.xy - vec2(0.5)) * _69._m84.z) / mix(_69._m85.wx, _69._m85.zy, _4.yx)) - _69._m84.xy) + vec2(0.5)).xyz, vec3(_69._m84.w));
  } else {
    _1083 = _1053;
  }
  vec3 _1394;
  if (_558) {
#if 1
    float _1108 = CompressLUTInput(_1083, _867, _67._m5, _67._m7, _67._m8, _67._m9);
#else
    float _1102 = max(max(_1083.x, max(_1083.y, _1083.z)), 9.9999997473787516355514526367188e-05);
    float _1108 = (_867 && (!(_67._m5 != 0u))) ? 1.0 : (((_1102 > _67._m7) ? ((_1102 * _67._m8) + _67._m9) : _1102) / _1102);
#endif
    vec3 _1109 = _1083 * _1108;
    float _1112 = _1109.z;
    float _1114 = floor(_1112 * 14.99989986419677734375);
    float _1120 = (_1114 * 0.0625) + (_1109.x * 0.05859375);
    float _1122 = _1109.y * 0.9375;
    vec4 _1126 = texture(sampler2D(_87, _10), vec2(0.001953125, 0.03125) + vec2(_1120, _1122));
    vec4 _1132 = texture(sampler2D(_87, _10), vec2(0.001953125, 0.03125) + vec2(_1120 + 0.0625, _1122));
    vec3 _1135 = mix(_1126.xyz, _1132.xyz, vec3((_1112 * 15.0) - _1114));
    vec3 _1391;
    if (_100._m0[0u]._m0._m0 > 0) {
      vec4 _1143 = texture(sampler2D(_80, _8), _307);
      vec4 _1146 = _1143 * _100._m0[0u]._m0._m1;
      vec4 _1149 = texture(sampler2D(_89, _10), _307);
      float _1151 = dot(_1149.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
      float _1153 = clamp(_1146.x, 0.0, 1.0);
      float _1155 = _1151 * _1153;
      vec3 _1185;
      if (_1155 != 0.0) {
        float _1159 = _1135.z;
        float _1161 = floor(_1159 * 14.99989986419677734375);
        float _1167 = (_1161 * 0.0625) + (_1135.x * 0.05859375);
        float _1169 = _1135.y * 0.9375;
        _1185 = mix(_1135, mix(texture(sampler2D(_83, _10), vec2(0.001953125, 0.03125) + vec2(_1167, _1169)).xyz, texture(sampler2D(_83, _10), vec2(0.001953125, 0.03125) + vec2(_1167 + 0.0625, _1169)).xyz, vec3((_1159 * 15.0) - _1161)), vec3(_1155));
      } else {
        _1185 = _1135;
      }
      float _1187 = clamp(_1146.y, 0.0, 1.0);
      float _1189 = _1151 * _1187;
      vec3 _1219;
      if (_1189 != 0.0) {
        float _1195 = floor(_1185.z * 14.99989986419677734375);
        float _1201 = (_1195 * 0.0625) + (_1185.x * 0.05859375);
        float _1203 = _1185.y * 0.9375;
        _1219 = mix(_1185, mix(texture(sampler2D(_84, _10), vec2(0.001953125, 0.03125) + vec2(_1201, _1203)).xyz, texture(sampler2D(_84, _10), vec2(0.001953125, 0.03125) + vec2(_1201 + 0.0625, _1203)).xyz, vec3((_1185.z * 15.0) - _1195)), vec3(_1189));
      } else {
        _1219 = _1185;
      }
      float _1221 = clamp(_1146.z, 0.0, 1.0);
      float _1223 = _1151 * _1221;
      vec3 _1253;
      if (_1223 != 0.0) {
        float _1229 = floor(_1219.z * 14.99989986419677734375);
        float _1235 = (_1229 * 0.0625) + (_1219.x * 0.05859375);
        float _1237 = _1219.y * 0.9375;
        _1253 = mix(_1219, mix(texture(sampler2D(_85, _10), vec2(0.001953125, 0.03125) + vec2(_1235, _1237)).xyz, texture(sampler2D(_85, _10), vec2(0.001953125, 0.03125) + vec2(_1235 + 0.0625, _1237)).xyz, vec3((_1219.z * 15.0) - _1229)), vec3(_1223));
      } else {
        _1253 = _1219;
      }
      float _1255 = clamp(_1146.w, 0.0, 1.0);
      float _1257 = _1151 * _1255;
      vec3 _1287;
      if (_1257 != 0.0) {
        float _1263 = floor(_1253.z * 14.99989986419677734375);
        float _1269 = (_1263 * 0.0625) + (_1253.x * 0.05859375);
        float _1271 = _1253.y * 0.9375;
        _1287 = mix(_1253, mix(texture(sampler2D(_86, _10), vec2(0.001953125, 0.03125) + vec2(_1269, _1271)).xyz, texture(sampler2D(_86, _10), vec2(0.001953125, 0.03125) + vec2(_1269 + 0.0625, _1271)).xyz, vec3((_1253.z * 15.0) - _1263)), vec3(_1257));
      } else {
        _1287 = _1253;
      }
      float _1323 = floor(_1287.z * 14.99989986419677734375);
      float _1329 = (_1323 * 0.0625) + (_1287.x * 0.05859375);
      float _1331 = _1287.y * 0.9375;
      vec3 _1346 = mix(_1287, mix(texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1329, _1331)).xyz, texture(sampler2D(_81, _10), vec2(0.001953125, 0.03125) + vec2(_1329 + 0.0625, _1331)).xyz, vec3((_1287.z * 15.0) - _1323)), vec3(clamp(((_318 < _100._m0[0u]._m1[0]._m2) ? clamp((_318 - _100._m0[0u]._m1[0]._m0) * _100._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_318 - _100._m0[0u]._m1[0]._m2) * _100._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _100._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _1358 = _1346.z;
      float _1360 = floor(_1358 * 14.99989986419677734375);
      float _1366 = (_1360 * 0.0625) + (_1346.x * 0.05859375);
      float _1368 = _1346.y * 0.9375;
      _1391 = mix(_1346, mix(_1346, mix(texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1366, _1368)).xyz, texture(sampler2D(_82, _10), vec2(0.001953125, 0.03125) + vec2(_1366 + 0.0625, _1368)).xyz, vec3((_1358 * 15.0) - _1360)), vec3(clamp(((_318 < _100._m0[0u]._m1[1]._m2) ? clamp((_318 - _100._m0[0u]._m1[1]._m0) * _100._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_318 - _100._m0[0u]._m1[1]._m2) * _100._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _100._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_88, _10), _307).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)) * (1.0 - clamp(((_1153 + _1187) + _1221) + _1255, 0.0, 1.0))));
    } else {
      _1391 = _1135;
    }
    _1394 = _1391 / vec3(_1108);
  } else {
    _1394 = _1083;
  }

#if 1
  _1394 = DecodeLUTInput(_1394, _1083);
#endif

  vec4 _1399 = vec4(_1394, dot(_1394, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _1400 = _1399.xyz;
  ivec4 _1442 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_60._m0[0u]._m22) & 31), 0u));
  vec3 _1450 = (vec3(texelFetch(_63, _1442.xyz, _1442.w).x) * 2.0) - vec3(1.0);
  vec3 _1461;
  if (_735) {
    _1461 = vec3(ivec3(sign(_1450))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_1450)));
  } else {
    _1461 = _1450;
  }
  vec3 _1463 = _1400 + CUSTOM_DITHERING * (_1461 * mix(_69._m39.xyz, _69._m40.xyz, pow(clamp((mix(vec3(max(_1394.x, max(_1394.y, _1394.z))), _1400, bvec3(floatBitsToInt(_69._m41.w) != 0)) - _69._m42.xyz) * _69._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_69._m42.w))));
  vec4 _1464 = vec4(_1463.x, _1463.y, _1463.z, _1399.w);
  vec4 _1469;
  if (!_735) {
    _1469 = clamp(_1464, vec4(0.0), vec4(1.0));
  } else {
    _1469 = _1464;
  }
  _6 = _1469;


  _6.rgb = ApplyGradingAndDisplayMap(_6.rgb, _4.xy);
}


