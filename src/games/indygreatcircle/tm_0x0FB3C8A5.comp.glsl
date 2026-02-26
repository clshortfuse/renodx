#version 460
#extension GL_EXT_buffer_reference2 : require
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
layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

struct _848 {
  float _m0;
  float _m1;
};

struct _849 {
  float _m0[6];
  float _m1[6];
  _848 _m2;
  _848 _m3;
  _848 _m4;
  float _m5;
  float _m6;
};

layout(buffer_reference) buffer _403;
layout(buffer_reference, buffer_reference_align = 16, std430) buffer _403 {
  uvec4 _m0;
  vec4 _m1;
  uint _m2;
  float _m3;
};

layout(set = 0, binding = 0, std140) uniform _421_423 {
  uvec4 _m0;
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
  uint _m12;
  float _m13;
  float _m14;
  float _m15;
  float _m16;
  float _m17;
  float _m18;
  float _m19;
  float _m20;
  float _m21;
  float _m22;
  float _m23;
  float _m24;
  float _m25;
  float _m26;
  float _m27;
  float _m28;
  float _m29;
  float _m30;
  float _m31;
  float _m32;
  float _m33;
  float _m34;
  float _m35;
  float _m36;
  float _m37;
  float _m38;
  float _m39;
  float _m40;
  float _m41;
  uint _m42;
  uint _m43;
  uint _m44;
  float _m45;
  uint _m46;
  uint _m47;
  int _m48;
  float _m49;
  uint _m50;
}
_423;

layout(set = 0, binding = 1, std140) uniform _728_730 {
  vec4 _m0[1024];
}
_730;

layout(set = 0, binding = 2, std430) restrict readonly buffer _732_734 {
  uvec4 _m0[];
}
_734;

layout(set = 0, binding = 3, std430) restrict readonly buffer _736_738 {
  uvec4 _m0[];
}
_738;

layout(push_constant, std430) uniform _400_405 {
  _403 _m0;
}
_405;

layout(set = 0, binding = 4) uniform texture2D _446;
layout(set = 0, binding = 5) uniform sampler _450;
layout(set = 0, binding = 6) uniform texture2D _494;
layout(set = 0, binding = 7) uniform texture2D _535;
layout(set = 0, binding = 8) uniform texture3D _630;
layout(set = 1, binding = 1, r11f_g11f_b10f) uniform writeonly image2D _718;

uint _71;
uint _73;
uint _747;

vec2 _11(vec2 _10) {
  return clamp(_10, vec2(0.0), vec2(1.0));
}

vec3 _32(vec3 _30, mat3 _31) {
  return _30 * _31;
}

float _45(float _42, float _43, float _44) {
  return max(_42, max(_43, _44));
}

float _56(float _52, float _53, float _54, float _55) {
  float _164;
  if (_52 < _54) {
    _164 = _52;
  } else {
    float _167 = (_53 - _54) / pow(pow((1.0 - _54) / (_53 - _54), -_55) - 1.0, 1.0 / _55);
    float _185 = (_52 - _54) / _167;
    float _191 = pow(_185, _55);
    _164 = _54 + ((_167 * _185) / pow(1.0 + _191, 1.0 / _55));
  }
  return _164;
}

vec3 _59(vec3 _58) {
  vec3 _223 = _58;
  mat3 _225 = mat3(vec3(1.45143926143646240234375, -0.236510753631591796875, -0.214928567409515380859375),
                   vec3(-0.07655377686023712158203125, 1.1762297153472900390625, -0.0996759235858917236328125),
                   vec3(0.0083161480724811553955078125, -0.0060324496589601039886474609375, 0.99771630764007568359375));
  vec3 _209 = _32(_223, _225);
  float _228 = _209.x;
  float _231 = _209.y;
  float _234 = _209.z;
  float _227 = _45(_228, _231, _234);
  vec3 _242;
  if (_227 == 0.0) {
    _242 = vec3(0.0);
  } else {
    _242 = (vec3(_227) - _209) / vec3(abs(_227));
  }
  float _257 = _242.x;
  float _260 = 1.14699995517730712890625;
  float _261 = 0.814999997615814208984375;
  float _262 = 1.2000000476837158203125;
  vec3 _253;
  _253.x = _56(_257, _260, _261, _262);
  float _267 = _242.y;
  float _270 = 1.26400005817413330078125;
  float _271 = 0.802999973297119140625;
  float _272 = 1.2000000476837158203125;
  _253.y = _56(_267, _270, _271, _272);
  float _277 = _242.z;
  float _280 = 1.3120000362396240234375;
  float _281 = 0.87999999523162841796875;
  float _282 = 1.2000000476837158203125;
  _253.z = _56(_277, _280, _281, _282);
  vec3 _285 = vec3(_227) - (_253 * abs(_227));
  vec3 _307 = _285;
  mat3 _309 = mat3(vec3(0.695452213287353515625, 0.140678703784942626953125, 0.16386906802654266357421875),
                   vec3(0.0447945632040500640869140625, 0.859671115875244140625, 0.095534317195415496826171875),
                   vec3(-0.0055258828215301036834716796875, 0.0040252101607620716094970703125, 1.00150072574615478515625));
  vec3 _293 = _32(_307, _309);
  return _293;
}

vec3 _39(vec3 _35, mat3 _36, mat3 _37, mat3 _38) {
  vec3 _133 = _35;
  mat3 _134 = _36;
  vec3 _136 = _32(_133, _134);
  mat3 _137 = _37;
  vec3 _139 = _32(_136, _137);
  mat3 _140 = _38;
  return _32(_139, _140);
}

vec3 _67(vec3 _66) {
  return _39(_66,
             mat3(vec3(0.952552378177642822265625, 0.0, 9.3678601842839270830154418945312e-05),
                  vec3(0.3439664542675018310546875, 0.728166103363037109375, -0.07213254272937774658203125),
                  vec3(0.0, 0.0, 1.00882518291473388671875)),
             mat3(vec3(0.987228810787200927734375, -0.00611330009996891021728515625, 0.0159534104168415069580078125),
                  vec3(-0.007598400115966796875, 1.00185978412628173828125, 0.0053300000727176666259765625),
                  vec3(0.00307258008979260921478271484375, -0.0050959200598299503326416015625, 1.0816795825958251953125)),
             mat3(vec3(3.2409694194793701171875, -1.53738296031951904296875, -0.4986107647418975830078125),
                  vec3(-0.96924388408660888671875, 1.87596786022186279296875, 0.041555099189281463623046875),
                  vec3(0.055630020797252655029296875, -0.2039768397808074951171875, 1.0569713115692138671875)));
}

float _49(vec3 _48) {
  return dot(_48, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
}

vec3 _17(vec3 _16) {
  return clamp(_16, vec3(0.0), vec3(1.0));
}

// log lut encode
vec3 _64(vec3 _62, float _63) {
  vec3 _314 = (log(_62 + vec3(0.00999999977648258209228515625)) + vec3(4.60517024993896484375)) / vec3(9.21035003662109375);
  _314 *= ((_63 - 1.0) / _63);
  _314 += vec3(0.5 / _63);
  vec3 _338 = _314;
  return _17(_338);
}

float _22(float _21) {
  float _93;
  if (_21 > 0.003130800090730190277099609375) {
    _93 = (pow(_21, 0.4166666567325592041015625) * 1.05499994754791259765625) - 0.054999999701976776123046875;
  } else {
    _93 = _21 * 12.9200000762939453125;
  }
  return _93;
}

vec3 _25(vec3 _24) {
  float _110 = _24.x;
  float _115 = _24.y;
  float _120 = _24.z;
  return vec3(_22(_110), _22(_115), _22(_120));
}

void main() {
  _71 = 2147483648u;
  _73 = 1073741824u;
  ivec2 _386 = ivec2(gl_GlobalInvocationID.xy);
  vec2 _394 = (vec2(_386) + vec2(0.5)) * _405._m0._m1.zw;
  bool _417 = false;
  vec2 _419 = (_394 - _423._m8.xy) * _423._m8.zw;
  vec2 _435 = _419;
  vec3 _443;
  if (all(equal(_419, _11(_435)))) {
    _443 = textureLod(sampler2D(_446, _450), vec4(_419, 0.0, 0.0).xy, vec4(_419, 0.0, 0.0).w).xyz;
    _417 = true;
  }
  _419 = (_394 - _423._m9.xy) * _423._m9.zw;
  bool _482 = _423._m48 > 1;
  bool _491;
  if (_482) {
    vec2 _486 = _419;
    _491 = all(equal(_419, _11(_486)));
  } else {
    _491 = _482;
  }
  if (_491) {
    _443 = textureLod(sampler2D(_494, _450), vec4(_419, 0.0, 0.0).xy, vec4(_419, 0.0, 0.0).w).xyz;
    _417 = true;
  }
  _419 = (_394 - _423._m10.xy) * _423._m10.zw;
  bool _523 = _423._m48 > 2;
  bool _532;
  if (_523) {
    vec2 _527 = _419;
    _532 = all(equal(_419, _11(_527)));
  } else {
    _532 = _523;
  }
  if (_532) {
    _443 = textureLod(sampler2D(_535, _450), vec4(_419, 0.0, 0.0).xy, vec4(_419, 0.0, 0.0).w).xyz;
    _417 = true;
  }
  if (_417 == true) {
    vec3 _555 = _443;
    _443 = _59(_555);
    vec3 _558 = _443;
    _443 = _67(_558);
  }
  SPIRV_CROSS_BRANCH
  if (_417) {
    uint _565 = _405._m0._m2;
    vec3 _627;
    SPIRV_CROSS_BRANCH
    if ((_565 & 1u) == 0u) {
      vec3 _577 = _443;
      float _576 = _49(_577);
      float _580 = _423._m11.w;
      _443 = mix(vec3(_576), _443 * _423._m11.xyz, vec3(_580));
      uint _595 = _405._m0._m2;
      if ((_595 & 1u) != 0u) {
        vec3 _605 = _443;
        _443 = max(vec3(0.0), mix(vec3(_49(_605)), _443, vec3(_405._m0._m3)));
      }
      vec3 _621 = _443;
      float _623 = _423._m49;
      vec3 _619 = _64(_621, _623);
      _627 = textureLod(sampler3D(_630, _450), vec4(_619, 0.0).xyz, vec4(_619, 0.0).w).xyz;
      vec3 _649 = _627;
      _627 = _25(_649);
    } else {
      vec3 _654 = _443;
      float _653 = _49(_654);
      float _657 = _423._m11.w;
      _443 = mix(vec3(_653), _443 * _423._m11.xyz, vec3(_657));
      uint _670 = _405._m0._m2;
      if ((_670 & 1u) != 0u) {
        vec3 _680 = _443;
        _443 = max(vec3(0.0), mix(vec3(_49(_680)), _443, vec3(_405._m0._m3)));
      }
      vec3 _693 = _443;
      float _695 = _423._m49;
      vec3 _692 = _64(_693, _695);
      _627 = textureLod(sampler3D(_630, _450), vec4(_692, 0.0).xyz, vec4(_692, 0.0).w).xyz;
    }
    imageStore(_718, _386, vec4(_627, 1.0));
  }
}

