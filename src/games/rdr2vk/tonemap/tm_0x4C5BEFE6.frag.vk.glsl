#version 450
#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"
#extension GL_EXT_scalar_block_layout : require
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

struct _86 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _87 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _85 {
  _86 _m0;
  _87 _m1[11];
};

float _254;

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

layout(set = 0, binding = 214, std430) readonly buffer _84_88 {
  _85 _m0[];
}
_88;

layout(set = 1, binding = 32) uniform sampler _9;
layout(set = 1, binding = 34) uniform sampler _10;
layout(set = 0, binding = 121) uniform texture2DArray _63;
layout(set = 0, binding = 140) uniform texture2D _64;
layout(set = 1, binding = 174) uniform texture2D _70;
layout(set = 1, binding = 177) uniform texture2D _71;
layout(set = 1, binding = 185) uniform texture1D _73;
layout(set = 1, binding = 40) uniform sampler _74;
layout(set = 1, binding = 186) uniform texture2D _75;
layout(set = 1, binding = 196) uniform texture2D _76;
layout(set = 1, binding = 197) uniform texture2D _77;
layout(set = 1, binding = 202) uniform texture2D _78;
layout(set = 1, binding = 203) uniform texture2D _79;
layout(set = 1, binding = 205) uniform texture2D _80;
layout(set = 1, binding = 206) uniform texture2D _81;
layout(set = 1, binding = 207) uniform texture2D _82;
layout(set = 1, binding = 212) uniform samplerBuffer _83;

layout(location = 0) in vec4 _4;
layout(location = 1) in float _5;
layout(location = 0) out vec4 _7;

void main() {
  vec4 _264 = texture(sampler2D(_81, _9), _4.xy);
  vec2 _265 = _264.xy;
  float _276 = _69._m0.z / ((1.0 + _69._m0.w) - textureLod(sampler2D(_70, _9), _265, 0.0).x);
  vec4 _280 = texture(sampler2D(_75, _74), _265);
  vec3 _294 = vec4(vec4(_280.xyz, 0.0).xyz * _30._m0[0u]._m1.w, _254).xyz;
  vec4 _297 = texelFetch(_83, int(0u));
  vec4 _298 = texelFetch(_83, int(1u));
  bool _328;
  vec3 _329;
  if (floatBitsToInt(_69._m61) != 0) {
    vec4 _314 = texture(sampler2D(_80, _74), _4.xy);
    float _315 = _314.w;
    bool _317 = (_315 + 9.9999997473787516355514526367188e-05) >= 1.0;
    vec3 _326;
    if (_317) {
      _326 = _314.xyz;
    } else {
      _326 = _314.xyz + (_294 * (1.0 - _315));
    }
    _328 = _317 ? true : false;
    _329 = _326;
  } else {
    _328 = false;
    _329 = _294;
  }
  vec3 _333 = min(_329 * texelFetch(_64, ivec2(0), 0).x, vec3(65504.0));
  bool _334 = !_328;
  float _447;
  vec3 _448;
  if (_334) {
    float _393;
    if (floatBitsToInt(_69._m70.x) != 0) {
      float _356 = clamp(dot(texture(sampler2D(_71, _10), _265).xyz * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)), _69._m72.z, _69._m72.w);
      float _379 = clamp(((((_69._m70.y * log(_356 + _69._m72.x)) + _69._m70.z) - 10.0) + (_69._m72.y * _356)) + _69._m65.w, _69._m66.x, _69._m66.y);
      _393 = pow(2.0, mix(_5, clamp(_379 + ((abs(_379) * _69._m66.z) * float(int(sign(_379)))), _69._m66.x, _69._m66.y), clamp(_69._m70.x, 0.0, 1.0)));
    } else {
      _393 = _4.z;
    }
    vec3 _446;
    if (floatBitsToInt(_69._m51.w) != 0) {
      vec2 _422 = ((_4.xy - _69._m50.xy) * mat2(vec2(_69._m52.x, _69._m52.y), vec2(_69._m52.z, _69._m52.w))) * _69._m50.zw;
      float _426 = max((dot(_422, _422) - _69._m53.x) * _69._m53.w, 0.0);
      bool _427 = _426 < 1.0;
      _446 = mix(_333, (_333 * _69._m51.xyz) * _69._m51.w, vec3(_427 ? (_427 ? (1.0 - pow(2.0, (-10.0) * _426)) : 1.0) : (0.9980499744415283203125 + (((_426 - 1.0) > 0.0) ? pow(2.0, 10.0 * (_426 - 2.0)) : 0.0))));
    } else {
      _446 = _333;
    }
    _447 = _393;
    _448 = _446;
  } else {
    _447 = _4.z;
    _448 = _333;
  }
  vec3 _485 = _448 * mix(mix(_69._m54.xyz, _69._m56.xyz, vec3(clamp(clamp(_4.y * _69._m57.y, 0.0, 1.0) + _69._m54.w, 0.0, 1.0))), mix(_69._m56.xyz, _69._m55.xyz, vec3(clamp(clamp(clamp(_4.y - _69._m56.w, 0.0, 1.0) * _69._m57.x, 0.0, 1.0) - _69._m55.w, 0.0, 1.0))), vec3(_4.y));
  bool _488 = _67._m3 != 0u;
  vec3 _551;
#if 1
  float midgray_in, midgray_out, slope;
  _551 = ApplyToneMap(_485, _447, _488, _67._m6, _67._m4, _67._m10,
                      _297.x, _297.y, _298.x, _298.y, _298.z, _298.w, _297.z, midgray_in, midgray_out, slope);
#else
  if (_488) {
    vec3 _528 = max(vec3(0.0), _485 * (_447 / _67._m6));
    vec3 _531 = _528 * _297.x;
    _551 = (((((_528 * (_531 + vec3(_298.x))) + vec3(_298.y)) / ((_528 * (_531 + vec3(_297.y))) + vec3(_298.z))) - vec3(_298.w)) * ((_67._m4 != 0u) ? _67._m10 : _297.z)) * _67._m6;
  } else {
    vec3 _494 = max(vec3(0.0), _485 * _447);
    vec3 _497 = _494 * _297.x;
    _551 = clamp(((((_494 * (_497 + vec3(_298.x))) + vec3(_298.y)) / ((_494 * (_497 + vec3(_297.y))) + vec3(_298.z))) - vec3(_298.w)) * _297.z, vec3(0.0), vec3(1.0));
  }
#endif
  vec3 _599;
  if (_334) {
    vec3 _598;
    if (floatBitsToInt(_69._m47.w) != 0) {
      vec2 _584 = ((_4.xy - _69._m46.xy) * mat2(vec2(_69._m48.x, _69._m48.y), vec2(_69._m48.z, _69._m48.w))) * _69._m46.zw;
      _598 = mix(_551, _69._m47.xyz, vec3(_69._m47.w * texture(sampler1D(_73, _10), min(1.0, max((dot(_584, _584) - _69._m49.x) * _69._m49.w, 0.0))).w));
    } else {
      _598 = _551;
    }
    _599 = _598;
  } else {
    _599 = _551;
  }
  bool _620 = _488 && (!(_67._m2 != 0u));
  vec3 _622 = mix(mix((pow(_599, vec3(_67._m12)) * _67._m13) - vec3(_67._m14), _599 * _67._m11, lessThan(_599, vec3(0.003130800090730190277099609375))), _599, bvec3(_620));
  vec3 _624 = max(_622 * mat3(vec3(0.514900028705596923828125, 0.324400007724761962890625, 0.1606999933719635009765625), vec3(0.265399992465972900390625, 0.67040002346038818359375, 0.06419999897480010986328125), vec3(0.02480000071227550506591796875, 0.1247999966144561767578125, 0.85039997100830078125)), vec3(0.00999999977648258209228515625, 0.0, 0.0));
  float _625 = _624.y;
  vec3 _650 = mix(_622, clamp((_69._m81.xyz * (_625 * ((1.33000004291534423828125 * (1.0 + ((_625 + _624.z) / _624.x))) - 1.67999994754791259765625))) * _69._m81.w, vec3(0.0), vec3(1.0)), vec3(clamp(((0.039999999105930328369140625 / (0.039999999105930328369140625 + dot(_294 * texelFetch(_64, ivec2(0), 0).x, vec3(0.300000011920928955078125, 0.589999973773956298828125, 0.10999999940395355224609375)))) * _69._m82.x) + _69._m82.y, 0.0, 1.0)));
  vec3 _680;
  if (floatBitsToInt(_69._m84.w) != 0) {
    _680 = mix(_650, texture(sampler2D(_82, _10), ((((_4.xy - vec2(0.5)) * _69._m84.z) / mix(_69._m85.wx, _69._m85.zy, _4.yx)) - _69._m84.xy) + vec2(0.5)).xyz, vec3(_69._m84.w));
  } else {
    _680 = _650;
  }
  vec3 _838;
  if (_334) {
#if 1
    float _705;
    vec3 _706 = CompressLUTInput(_680, _620, _67._m5, _67._m7, _67._m8, _67._m9, _705);
#else
    float _699 = max(max(_680.x, max(_680.y, _680.z)), 9.9999997473787516355514526367188e-05);
    float _705 = (_620 && (!(_67._m5 != 0u))) ? 1.0 : (((_699 > _67._m7) ? ((_699 * _67._m8) + _67._m9) : _699) / _699);
    vec3 _706 = _680 * _705;
#endif
    float _709 = _706.z;
    float _711 = floor(_709 * 14.99989986419677734375);
    float _717 = (_711 * 0.0625) + (_706.x * 0.05859375);
    float _719 = _706.y * 0.9375;
    vec4 _723 = texture(sampler2D(_78, _10), vec2(0.001953125, 0.03125) + vec2(_717, _719));
    vec4 _729 = texture(sampler2D(_78, _10), vec2(0.001953125, 0.03125) + vec2(_717 + 0.0625, _719));
    vec3 _732 = mix(_723.xyz, _729.xyz, vec3((_709 * 15.0) - _711));
    vec3 _835;
    if (_88._m0[0u]._m0._m0 > 0) {
      float _766 = _732.z;
      float _768 = floor(_766 * 14.99989986419677734375);
      float _774 = (_768 * 0.0625) + (_732.x * 0.05859375);
      float _776 = _732.y * 0.9375;
      vec3 _791 = mix(_732, mix(texture(sampler2D(_76, _10), vec2(0.001953125, 0.03125) + vec2(_774, _776)).xyz, texture(sampler2D(_76, _10), vec2(0.001953125, 0.03125) + vec2(_774 + 0.0625, _776)).xyz, vec3((_766 * 15.0) - _768)), vec3(clamp(((_276 < _88._m0[0u]._m1[0]._m2) ? clamp((_276 - _88._m0[0u]._m1[0]._m0) * _88._m0[0u]._m1[0]._m1, 0.0, 1.0) : (1.0 - clamp((_276 - _88._m0[0u]._m1[0]._m2) * _88._m0[0u]._m1[0]._m3, 0.0, 1.0))) + _88._m0[0u]._m1[0]._m4, 0.0, 1.0)));
      float _803 = _791.z;
      float _805 = floor(_803 * 14.99989986419677734375);
      float _811 = (_805 * 0.0625) + (_791.x * 0.05859375);
      float _813 = _791.y * 0.9375;
      _835 = mix(_791, mix(_791, mix(texture(sampler2D(_77, _10), vec2(0.001953125, 0.03125) + vec2(_811, _813)).xyz, texture(sampler2D(_77, _10), vec2(0.001953125, 0.03125) + vec2(_811 + 0.0625, _813)).xyz, vec3((_803 * 15.0) - _805)), vec3(clamp(((_276 < _88._m0[0u]._m1[1]._m2) ? clamp((_276 - _88._m0[0u]._m1[1]._m0) * _88._m0[0u]._m1[1]._m1, 0.0, 1.0) : (1.0 - clamp((_276 - _88._m0[0u]._m1[1]._m2) * _88._m0[0u]._m1[1]._m3, 0.0, 1.0))) + _88._m0[0u]._m1[1]._m4, 0.0, 1.0))), vec3(dot(texture(sampler2D(_79, _10), _265).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
    } else {
      _835 = _732;
    }
#if 1
    _838 = RestoreLUTOutput(_835, _705, _680);
#else
    _838 = _835 / vec3(_705);
#endif
  } else {
    _838 = _680;
  }
  vec4 _843 = vec4(_838, dot(_838, vec3(0.2989999949932098388671875, 0.58700001239776611328125, 0.114000000059604644775390625)));
#if 1
  vec3 _908 = ApplyDither(_843.xyz, gl_FragCoord.xy, _60._m0[0u]._m22, _63,
                          _488, _69._m39.xyz, _69._m40.xyz, _69._m41, _69._m42);
#else
  vec3 _844 = _843.xyz;
  ivec4 _887 = ivec4(uvec4(uvec2(ivec2(uvec2(gl_FragCoord.xy))) & uvec2(63u), uint(int(_60._m0[0u]._m22) & 31), 0u));
  vec3 _895 = (vec3(texelFetch(_63, _887.xyz, _887.w).x) * 2.0) - vec3(1.0);
  vec3 _906;
  if (_488) {
    _906 = vec3(ivec3(sign(_895))) * (vec3(1.0) - sqrt(vec3(1.0) - abs(_895)));
  } else {
    _906 = _895;
  }
  vec3 _908 = _844 + (_906 * mix(_69._m39.xyz, _69._m40.xyz, pow(clamp((mix(vec3(max(_838.x, max(_838.y, _838.z))), _844, bvec3(floatBitsToInt(_69._m41.w) != 0)) - _69._m42.xyz) * _69._m41.xyz, vec3(0.0), vec3(1.0)), vec3(_69._m42.w))));
#endif
  vec4 _909 = vec4(_908.x, _908.y, _908.z, _843.w);
  vec4 _914;
#if 1
  _914 = ConditionalClampOutput(_909, _488);
#else
  if (!_488) {
    _914 = clamp(_909, vec4(0.0), vec4(1.0));
  } else {
    _914 = _909;
  }
#endif
#if 1
  _7 = vec4(ApplyFinalToneMap(_914.rgb, _4.xy, midgray_in, midgray_out, slope), _914.a);
#else
  _7 = _914;
#endif
}

