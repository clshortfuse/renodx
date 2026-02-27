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

struct _85 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _86 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _84 {
  _85 _m0;
  _86 _m1[11];
};

float _252;

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

layout(set = 0, binding = 214, std430) readonly buffer _83_87 {
  _84 _m0[];
}
_87;

layout(set = 1, binding = 32) uniform sampler _8;
layout(set = 1, binding = 34) uniform sampler _9;
layout(set = 0, binding = 121) uniform texture2DArray _62;
layout(set = 0, binding = 140) uniform texture2D _63;
layout(set = 1, binding = 174) uniform texture2D _69;
layout(set = 1, binding = 177) uniform texture2D _70;
layout(set = 1, binding = 185) uniform texture1D _72;
layout(set = 1, binding = 40) uniform sampler _73;
layout(set = 1, binding = 186) uniform texture2D _74;
layout(set = 1, binding = 196) uniform texture2D _75;
layout(set = 1, binding = 197) uniform texture2D _76;
layout(set = 1, binding = 202) uniform texture2D _77;
layout(set = 1, binding = 203) uniform texture2D _78;
layout(set = 1, binding = 205) uniform texture2D _79;
layout(set = 1, binding = 206) uniform texture2D _80;
layout(set = 1, binding = 207) uniform texture2D _81;
layout(set = 1, binding = 212) uniform samplerBuffer _82;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _6;

void main() {
  vec4 _262 = texture(sampler2D(_80, _8), _4.xy);
  vec2 _263 = _262.xy;
  float _274 = _68._m0.z / ((1.0 + _68._m0.w) - textureLod(sampler2D(_69, _8), _263, 0.0).x);
  vec4 _278 = texture(sampler2D(_74, _73), _263);
  vec3 _292 = vec4(vec4(_278.xyz, 0.0).xyz * _29._m0[0u]._m1.w, _252).xyz;
  vec4 _295 = texelFetch(_82, int(0u));
  vec4 _296 = texelFetch(_82, int(1u));
  bool _326;
  vec3 _327;
  if (floatBitsToInt(_68._m61) != 0) {
    vec4 _312 = texture(sampler2D(_79, _73), _4.xy);
    float _313 = _312.w;
    bool _315 = (_313 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _324;
    if (_315) {
      _324 = _312.xyz;
    } else {
      _324 = _312.xyz + (_292 * (1.0 - _313));
    }
    _326 = _315 ? true : false;
    _327 = _324;
  } else {
    _326 = false;
    _327 = _292;
  }
  vec3 _331 = min(_327 * texelFetch(_63, ivec2(0), 0).x, vec3(GetTonemapClampMax()));
  bool _332 = !_326;
  float _445;
  vec3 _446;
  if (_332) {
    float _391;
    if (floatBitsToInt(_68._m70.x) != 0) {
      float _354 = clamp(dot(texture(sampler2D(_70, _9), _263).xyz * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _68._m72.z, _68._m72.w);
      float _377 = clamp(((((_68._m70.y * log(_354 + _68._m72.x)) + _68._m70.z) - 10.0) + (_68._m72.y * _354)) + _68._m65.w, _68._m66.x, _68._m66.y);
      _391 = pow(2.0, mix(_5, clamp(_377 + ((abs(_377) * _68._m66.z) * float(int(sign(_377)))), _68._m66.x, _68._m66.y), clamp(_68._m70.x, 0.0, 1.0)));
    } else {
      _391 = _4.z;
    }
    vec3 _444;
    if (floatBitsToInt(_68._m51.w) != 0) {
      vec2 _420 = ((_4.xy - _68._m50.xy) * mat2(vec2(_68._m52.x, _68._m52.y), vec2(_68._m52.z, _68._m52.w))) * _68._m50.zw;
      float _424 = CUSTOM_VIGNETTE * max((dot(_420, _420) - _68._m53.x) * _68._m53.w, 0.0);
      bool _425 = _424 < 1.0;
      _444 = mix(_331, (_331 * _68._m51.xyz) * _68._m51.w, vec3(_425 ? (_425 ? (1.0 - pow(2.0, (-10.0) * _424)) : 1.0) : (0.9980499744415283203125 + (((_424 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_424 - 2.0)) : 0.0))));
    } else {
      _444 = _331;
    }
    _445 = _391;
    _446 = _444;
  } else {
    _445 = _4.z;
    _446 = _331;
  }
  vec3 _483 = _446 * mix(mix(_68._m54.xyz, _68._m56.xyz, vec3(clamp(clamp(_4.y * _68._m57.y, 0.0, 1.0) + _68._m54.w, 0.0, 1.0))), mix(_68._m56.xyz, _68._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _68._m56.w, 0.0, 1.0) * _68._m57.x, 0.0, 1.0) - _68._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _486 = _66._m3 != 0u;
#if 1
  vec3 _549 = ApplyToneMap(_483, _486, _445, _66._m6, _66._m4, _66._m10, _295.rgb, _296);
#else
  vec3 _549;
  if (_486) {
    vec3 _526 = max(vec3(0.0), _483 * (_445 / _66._m6));
    vec3 _529 = _526 * _295.x;
    _549 = (((((_526 * (_529 + vec3(_296.x))) + vec3(_296.y)) / ((_526 * (_529 + vec3(_295.y))) + vec3(_296.z))) - vec3(_296.w)) * ((_66._m4 != 0u) ? _66._m10 : _295.z)) * _66._m6;
  } else {
    vec3 _492 = max(vec3(0.0), _483 * _445);
    vec3 _495 = _492 * _295.x;
    _549 = clamp(((((_492 * (_495 + vec3(_296.x))) + vec3(_296.y)) / ((_492 * (_495 + vec3(_295.y))) + vec3(_296.z))) - vec3(_296.w)) * _295.z, vec3(0.0), vec3(1.0));
  }
#endif
  vec3 _597;
  if (_332) {
    vec3 _596;
    if (floatBitsToInt(_68._m47.w) != 0) {
      vec2 _582 = ((_4.xy - _68._m46.xy) * mat2(vec2(_68._m48.x, _68._m48.y), vec2(_68._m48.z, _68._m48.w))) * _68._m46.zw;
      _596 = mix(_549, _68._m47.xyz, vec3(_68._m47.w * texture(sampler1D(_72, _9), min(1.0, max((dot(_582, _582) - _68._m49.x) * _68._m49.w, 0.0))).w));
    } else {
      _596 = _549;
    }
    _597 = _596;
  } else {
    _597 = _549;
  }
  bool _618 = _486 && (!(_66._m2 != 0u));

#if 1
  vec3 _620 = EncodeLUTInput(_597, _66._m11, _66._m12, _66._m13, _66._m14, _618);
#else
  vec3 _620 = mix(mix((pow(_597, vec3(_66._m12)) * _66._m13) - vec3(_66._m14), _597 * _66._m11, lessThan(_597, vec3(0.003130800090730190277099609375))), _597, bvec3(_618));
#endif

  vec3 _622 = max(_620 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _623 = _622.y;
  vec3 _648 = mix(_620, clamp((_68._m81.xyz * (_623 * ((1.33000004291534423828125 * (1.0 + ((_623 + _622.z) / _622.x))) - 1.67999994754791259765625))) * _68._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + dot(_292 * texelFetch(_63, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)))) * _68._m82.x) + _68._m82.y, 0.0, 1.0)));
  vec3 _678;
  if (floatBitsToInt(_68._m84.w) != 0) {
    _678 = mix(_648, texture(sampler2D(_81, _9), ((((_4.xy - vec2(0.5)) * _68._m84.z) / mix(_68._m85.wx, _68._m85.zy, _4.yx)) - _68._m84.xy) + vec2(0.5)).xyz, vec3(_68._m84.w));
  } else {
    _678 = _648;
  }
  vec3 _836;
  if (_332) {
#if 1
    float _703 = CompressLUTInput(_678, _618, _66._m5, _66._m7, _66._m8, _66._m9);
#else
    float _697 = max(max(_678.x, max(_678.y, _678.z)), 9.9999997473787516355514526367188e-05);
    float _703 = (_618 && (!(_66._m5 != 0u))) ? 1.0 : (((_697 > _66._m7) ? ((_697 * _66._m8) + _66._m9) : _697) / _697);
#endif
    vec3 _704 = _678 * _703;
    float _707 = _704.z;
    float _709 = floor(_707 * 14.99989986419677734375);
    float _715 = (_709 * 0.0625) + (_704.x * 0.05859375);
    float _717 = _704.y * 0.9375;
    vec4 _721 = texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_715, _717));
    vec4 _727 = texture(sampler2D(_77, _9), vec2(0.001953125, 0.03125) + vec2(_715 + 0.0625, _717));
    vec3 _730 = mix(_721.xyz, _727.xyz, vec3((_707 * 15.0) - _709));
    vec3 _833;
    if (_87._m0[0u]._m0._m0 > 0) {
      float _764 = _730.z;
      float _766 = floor(_764 * 14.99989986419677734375);
      float _772 = (_766 * 0.0625) + (_730.x * 0.05859375);
      float _774 = _730.y * 0.9375;
      vec3 _789 = mix(_730, mix(texture(sampler2D(_75, _9), vec2(0.001953125, 0.03125) + vec2(_772, _774)).xyz, texture(sampler2D(_75, _9), vec2(0.001953125, 0.03125) + vec2(_772 + 0.0625, _774)).xyz, vec3((_764 * 15.0) - _766)), vec3(clamp(((_274 < _87._m0[0u]._m1[0]._m2) ? clamp((_274 - _87._m0[0u]._m1[0]._m0) * _87._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_274 - _87._m0[0u]._m1[0]._m2) * _87._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _87._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _801 = _789.z;
      float _803 = floor(_801 * 14.99989986419677734375);
      float _809 = (_803 * 0.0625) + (_789.x * 0.05859375);
      float _811 = _789.y * 0.9375;
      _833 = mix(_789, mix(_789, mix(texture(sampler2D(_76, _9), vec2(0.001953125, 0.03125) + vec2(_809, _811)).xyz, texture(sampler2D(_76, _9), vec2(0.001953125, 0.03125) + vec2(_809 + 0.0625, _811)).xyz, vec3((_801 * 15.0) - _803)), vec3(clamp(((_274 < _87._m0[0u]._m1[1]._m2) ? clamp((_274 - _87._m0[0u]._m1[1]._m0) * _87._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_274 - _87._m0[0u]._m1[1]._m2) * _87._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _87._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_78, _9), _263).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
    } else {
      _833 = _730;
    }
    _836 = _833 / vec3(_703);
  } else {
    _836 = _678;
  }

#if 1
  _836 = DecodeLUTInput(_836, _678);
#endif

  vec4 _841 = vec4(_836, dot(_836, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
  vec3 _842 = _841.xyz;
  ivec4 _885 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_59._m0[0u]._m22) & 31), 0u));
  vec3 _893 = (vec3(texelFetch(_62, _885.xyz, _885.w).x) * 2.0) - vec3(1.0);
  vec3 _904;
  if (_486) {
    _904 = vec3(ivec3(sign(_893))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_893)));
  } else {
    _904 = _893;
  }
  vec3 _906 = _842 + CUSTOM_DITHERING * (_904 * mix(_68._m39.xyz, _68._m40.xyz, pow(clamp((mix(vec3(max(_836.x, max(_836.y, _836.z))), _842, bvec3(floatBitsToInt(_68._m41.w) != 0)) - _68._m42.xyz) * _68._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_68._m42.w))));
  vec4 _907 = vec4(_906.x, _906.y, _906.z, _841.w);
  vec4 _912;
  if (!_486) {
    _912 = clamp(_907, vec4(0.0), vec4(1.0));
  } else {
    _912 = _907;
  }
  _6 = _912;


  _6.rgb = ApplyGradingAndDisplayMap(_6.rgb, _4.xy);
}


