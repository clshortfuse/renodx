#version 450

#extension GL_GOOGLE_include_directive : require
#include "./tonemap.glsl"

struct _22 {
  int _m0;
  float _m1;
  int _m2[2];
};

struct _23 {
  float _m0;
  float _m1;
  float _m2;
  float _m3;
  float _m4;
};

struct _21 {
  _22 _m0;
  _23 _m1[11];
};

layout(set = 0, binding = 20, std140) uniform _9_10 {
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
_10;

layout(set = 1, binding = 16, std140) uniform _11_12 {
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
_12;

layout(set = 0, binding = 214, std430) readonly buffer _20_24 {
  _21 _m0[];
}
_24;

layout(set = 1, binding = 34) uniform sampler _7;
layout(set = 1, binding = 185) uniform texture1D _14;
layout(set = 1, binding = 40) uniform sampler _15;
layout(set = 1, binding = 186) uniform texture2D _16;
layout(set = 1, binding = 196) uniform texture2D _17;
layout(set = 1, binding = 202) uniform texture2D _18;
layout(set = 1, binding = 203) uniform texture2D _19;

layout(location = 0) in vec4 _4;
layout(location = 0) out vec4 _5;

void main() {
  vec4 _112 = texture(sampler2D(_16, _15), _4.xy);
  vec3 _113 = _112.xyz;
  vec3 _158;
  if (floatBitsToInt(_12._m47.w) != 0) {
    vec2 _144 = ((_4.xy - _12._m46.xy) * mat2(vec2(_12._m48.x, _12._m48.y), vec2(_12._m48.z, _12._m48.w))) * _12._m46.zw;
    _158 = mix(_113, _12._m47.xyz, vec3(_12._m47.w * texture(sampler1D(_14, _7), min(1.0, max((dot(_144, _144) - _12._m49.x) * _12._m49.w, 0.0))).w));
  } else {
    _158 = _113;
  }
  vec4 _316;
  if (floatBitsToInt(_12._m19.x) != 0) {
    vec2 _171 = _4.xy * _12._m17.w;
    float _237 = (((((((fract(sin(dot(_171 + vec2(0.070000000298023223876953125 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875) + fract(sin(dot(_171 + vec2(0.10999999940395355224609375 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_171 + vec2(0.12999999523162841796875 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_171 + vec2(0.17000000178813934326171875 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_171 + vec2(0.189999997615814208984375 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_171 + vec2(0.23000000417232513427734375 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_171 + vec2(0.2899999916553497314453125 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) + fract(sin(dot(_171 + vec2(0.310000002384185791015625 * _12._m17.x), vec2(12.98980045318603515625, 78.233001708984375))) * 43758.546875)) * 0.125;
    float _239 = clamp(_237 + _12._m17.z, 0.0, 1.0);
    vec3 _314;
    do {
      if (!(floatBitsToInt(_12._m18.w) != 0)) {
        _314 = vec3(_239);
        break;
      }
      float _262;
      if (floatBitsToInt(_12._m18.y) != 0) {
        float _257 = dot(_158.xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        _262 = mix(_239, _239 * 0.5, (_257 * _257) * _257);
      } else {
        _262 = _239;
      }
      vec3 _313;
      if (floatBitsToInt(_12._m19.z) != 0) {
        vec3 _277 = vec3(_262);
        vec3 _279 = _277 * 2.0;
        _313 = mix(_158.xyz, mix(((_158.xyz * 2.0) * (vec3(1.0) - _277)) + (sqrt(_158.xyz) * (_279 - vec3(1.0))), (_279 * _158.xyz) + ((_158.xyz * _158.xyz) * (vec3(1.0) - _279)), lessThan(_277, vec3(0.5))), vec3(_12._m18.x));
      } else {
        vec3 _312;
        if (floatBitsToInt(_12._m19.w) != 0) {
          vec3 _300 = vec3(_262);
          _312 = mix(_158.xyz, mix(vec3(1.0) - (((vec3(1.0) - _300) * 2.0) * (vec3(1.0) - _158.xyz)), (_300 * 2.0) * _158.xyz, lessThan(_158.xyz, vec3(0.5))), vec3(_12._m18.x));
        } else {
          _312 = clamp(max(_158.xyz * 0.02500000037252902984619140625, _158.xyz + vec3((_262 - 0.5) * _12._m18.x)), vec3(0.0), vec3(1.0));
        }
        _313 = _312;
      }
      _314 = _313;
      break;
    } while (false);
    _316 = vec4(_314.x, _314.y, _314.z, _112.w);
  } else {
    _316 = vec4(_158.x, _158.y, _158.z, _112.w);
  }
#if 1
  float _338 = CompressLUTInputAlt(_316.xyz, _10._m3, _10._m7, _10._m8, _10._m9);
#else
  float _332 = max(max(_316.x, max(_316.y, _316.z)), 9.9999997473787516355514526367188e-05);
  float _338 = (_10._m3 != 0u) ? (((_332 > _10._m7) ? ((_332 * _10._m8) + _10._m9) : _332) / _332) : 1.0;
#endif
  vec3 _339 = _316.xyz * _338;
  float _342 = _339.z;
  float _344 = floor(_342 * 14.99989986419677734375);
  float _350 = (_344 * 0.0625) + (_339.x * 0.05859375);
  float _352 = _339.y * 0.9375;
  vec4 _356 = texture(sampler2D(_18, _7), vec2(0.001953125, 0.03125) + vec2(_350, _352));
  vec4 _362 = texture(sampler2D(_18, _7), vec2(0.001953125, 0.03125) + vec2(_350 + 0.0625, _352));
  vec3 _365 = mix(_356.xyz, _362.xyz, vec3((_342 * 15.0) - _344));
  vec4 _406;
  if (_24._m0[0u]._m0._m0 > 0) {
    float _379 = _365.z;
    float _381 = floor(_379 * 14.99989986419677734375);
    float _387 = (_381 * 0.0625) + (_365.x * 0.05859375);
    float _389 = _365.y * 0.9375;
    vec3 _404 = mix(_365.xyz, mix(texture(sampler2D(_17, _7), vec2(0.001953125, 0.03125) + vec2(_387, _389)).xyz, texture(sampler2D(_17, _7), vec2(0.001953125, 0.03125) + vec2(_387 + 0.0625, _389)).xyz, vec3((_379 * 15.0) - _381)), vec3(dot(texture(sampler2D(_19, _7), _4.xy).xyz, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))));
    _406 = vec4(_404.x, _404.y, _404.z, _316.w);
  } else {
    _406 = vec4(_365.x, _365.y, _365.z, _316.w);
  }
  vec3 _409 = _406.xyz / vec3(_338);
  _5 = vec4(_409.x, _409.y, _409.z, _406.w);

  _5.rgb = ApplyGradingAndDisplayMap(_5.rgb, _4.xy);
}

