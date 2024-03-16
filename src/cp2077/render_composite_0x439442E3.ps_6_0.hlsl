#include "./injectedBuffer.hlsl"

cbuffer _41_43 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
}

cbuffer _46_48 : register(b1, space0) {
  float4 cb1[53] : packoffset(c0);
}

cbuffer _61_63 : register(b2, space0) {
  float4 cb2[455] : packoffset(c0);
}

cbuffer _56_58 : register(b6, space0) {
  float4 cb6[15] : packoffset(c0);
}

cbuffer _51_53 : register(b12, space0) {
  float4 cb12[99] : packoffset(c0);
}

Texture2D<float4> _8 : register(t36, space0);
Buffer<uint4> _12 : register(t37, space0);
TextureCube<float4> _15 : register(t43, space0);
Texture2DArray<float4> _18 : register(t44, space0);
Buffer<uint4> _19 : register(t45, space0);
Texture2DArray<float4> _20 : register(t61, space0);
Texture2D<float4> texture0 : register(t0, space0);
Texture2D<float4> texture1 : register(t1, space0);
Texture2D<float4> _23 : register(t2, space0);
Texture2D<float4> _24 : register(t3, space0);
Texture2D<float4> _25 : register(t4, space0);
Texture2D<float4> texture5 : register(t5, space0);
Texture2D<float4> texture6 : register(t6, space0);
Texture2D<float4> gameAreaMask : register(t7, space0);
Texture2D<float4> _29 : register(t8, space0);
Texture2D<float4> _30 : register(t9, space0);
Texture2D<float4> _31 : register(t11, space0);
Texture2D<float4> _32 : register(t12, space0);
Texture2D<uint4> _35 : register(t13, space0);
Texture2D<uint4> _36 : register(t14, space0);
Texture2D<float4> _37 : register(t15, space0);
SamplerState _66 : register(s11, space0);
SamplerState _67 : register(s12, space0);
SamplerState _68 : register(s0, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;
static float4 SV_Target_1;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  nointerpolation float2 SYS_TEXCOORD : SYS_TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float4 SV_Target_1 : SV_Target1;
};

void frag_main() {
  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
  SV_Target_1.x = 0.0f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  uint _124 = uint(gl_FragCoord.x);
  uint _125 = uint(gl_FragCoord.y);
  float _126 = float(_124);
  float _127 = float(_125);
  float4 _138 = texture0.Load(int3(uint2(_124, _125), 0u));
  float texture0x = _138.x;
  float4 _142 = texture5.Load(int3(uint2(_124, _125), 0u));
  float _147 = _142.x * SYS_TEXCOORD.y;
  float _148 = _142.y * SYS_TEXCOORD.y;
  float _149 = _142.z * SYS_TEXCOORD.y;
  float4 _150 = texture6.Load(int3(uint2(_124, _125), 0u));
  float _155 = _150.x * SYS_TEXCOORD.y;
  float _156 = _150.y * SYS_TEXCOORD.y;
  float _157 = _150.z * SYS_TEXCOORD.y;
  float4 _158 = texture1.Load(int3(uint2(_124, _125), 0u));
  float _160 = _158.x;
  float _161 = _158.y;
  float _162 = _158.z;
  float4 _164 = _23.Load(int3(uint2(_124, _125), 0u));
  float _166 = _164.x;
  float _167 = _164.y;
  float _168 = _164.z;
  float _169 = _164.w;
  float4 _170 = _24.Load(int3(uint2(_124, _125), 0u));
  float _172 = _170.x;
  float _174 = _170.z;
  float _175 = _170.w;
  uint4 _177 = _36.Load(int3(uint2(_124, _125), 0u));
  uint _179 = _177.y;
  uint _191 = _179 >> 5u;
  uint _193 = _179 & 31u;
  float _195 = _160 * _160;
  float _196 = _161 * _161;
  float _197 = _162 * _162;
  float _198 = _166 + (-0.5f);
  float _200 = _167 + (-0.5f);
  float _201 = _168 + (-0.5f);
  float _207 = rsqrt(dot(float3(_198, _200, _201), float3(_198, _200, _201)));
  float _208 = _207 * _198;
  float _209 = _207 * _200;
  float _210 = _207 * _201;
  float _213 = min(max(_170.y, 0.039999999105930328369140625f), 1.0f);
  float _219 = clamp((_174 + (-0.3333333432674407958984375f)) * 1.5f, 0.0f, 1.0f);
  float _222 = clamp(_174 * 3.0f, 0.0f, 1.0f);
  uint _225 = uint(_175 * 255.0f);
  bool _228 = (_225 & 128u) == 0u;
  float _229;
  if (_228) {
    _229 = 0.0f;
  } else {
    float _236 = float(_225 & 127u) * 0.0078740157186985015869140625f;
    _229 = _236 * _236;
  }
  bool _231 = _191 == 4u;
  float _244;
  if (_228) {
    _244 = clamp(float(_225 & 63u) * 0.01587301678955554962158203125f, 0.0f, 1.0f);
  } else {
    _244 = 0.0f;
  }
  float _246 = (_231 ? 0.0f : _244) * cb6[11u].z;
  float _247;
  float _248;
  float _251;
  float _254;
  float _257;
  float _258;
  float _260;
  float _262;
  float _264;
  float _266;
  float _268;
  float _269;
  float _271;
  float _273;
  switch (_191) {
    case 4u:
      {
        float _297 = (_166 * 2.0f) + (-1.0f);
        float _299 = (_167 * 2.0f) + (-1.0f);
        float _300 = (_168 * 2.0f) + (-1.0f);
        float _305 = sqrt(1.0f - dot(float3(_297, _299, _300), float3(_297, _299, _300)));
        uint _308 = uint(int((_169 * 3.0f) + 0.5f));
        float _497;
        float _498;
        float _499;
        float _501;
        if (_308 == 0u) {
          _497 = _305;
          _498 = _297;
          _499 = _299;
          _501 = _300;
        } else {
          float frontier_phi_11_12_ladder;
          float frontier_phi_11_12_ladder_1;
          float frontier_phi_11_12_ladder_2;
          float frontier_phi_11_12_ladder_3;
          if (_308 == 1u) {
            frontier_phi_11_12_ladder = _297;
            frontier_phi_11_12_ladder_1 = _300;
            frontier_phi_11_12_ladder_2 = _305;
            frontier_phi_11_12_ladder_3 = _299;
          } else {
            bool _566 = _308 == 2u;
            frontier_phi_11_12_ladder = _297;
            frontier_phi_11_12_ladder_1 = _566 ? _300 : _305;
            frontier_phi_11_12_ladder_2 = _299;
            frontier_phi_11_12_ladder_3 = _566 ? _305 : _300;
          }
          _497 = frontier_phi_11_12_ladder;
          _498 = frontier_phi_11_12_ladder_2;
          _499 = frontier_phi_11_12_ladder_3;
          _501 = frontier_phi_11_12_ladder_1;
        }
        float _503 = _499 * 2.0f;
        float _504 = _498 * (-2.0f);
        float _513 = ((_504 * _498) - (_503 * _499)) + 1.0f;
        float _514 = (_501 * _503) - (_504 * _497);
        float _515 = (_501 * _504) + (_503 * _497);
        float _519 = rsqrt(dot(float3(_513, _514, _515), float3(_513, _514, _515)));
        float _520 = _498 * 2.0f;
        float _521 = _497 * (-2.0f);
        float _529 = (_501 * _520) - (_499 * _521);
        float _530 = (_501 * _521) + (_499 * _520);
        float _531 = ((_521 * _497) - (_520 * _498)) + 1.0f;
        float _535 = rsqrt(dot(float3(_529, _530, _531), float3(_529, _530, _531)));
        _247 = _246;
        _248 = _513 * _519;
        _251 = _514 * _519;
        _254 = _515 * _519;
        _257 = _175;
        _258 = _535 * _529;
        _260 = _535 * _530;
        _262 = _535 * _531;
        _264 = 0.0f;
        _266 = _222;
        _268 = _219;
        _269 = _195;
        _271 = _196;
        _273 = _197;
        break;
      }
    case 1u:
      {
        float _265;
        if (_228) {
          _265 = 0.0f;
        } else {
          float _543 = float(_225 & 63u) * 0.01587301678955554962158203125f;
          _265 = _543 * _543;
        }
        bool _540 = (_172 < 0.100000001490116119384765625f) && (asuint(cb6[6u]).x != 0u);
        _247 = _246;
        _248 = 0.0f;
        _251 = 0.0f;
        _254 = 0.0f;
        _257 = 0.0f;
        _258 = _208;
        _260 = _209;
        _262 = _210;
        _264 = _265;
        _266 = _540 ? 0.0f : _222;
        _268 = _219;
        _269 = _540 ? 1.0f : _195;
        _271 = _540 ? 1.0f : _196;
        _273 = _540 ? 1.0f : _197;
        break;
      }
    case 3u:
      {
        float _325 = (float((uint(_174 * 255.0f) << 2u) | uint(_158.w * 3.0f)) * 0.00195503421127796173095703125f) + (-1.0f);
        float _326 = (float((_225 << 2u) | uint(_169 * 3.0f)) * 0.00195503421127796173095703125f) + (-1.0f);
        float _330 = (1.0f - abs(_325)) - abs(_326);
        float _333 = clamp((-0.0f) - _330, 0.0f, 1.0f);
        float _336 = (-0.0f) - _333;
        float _339 = ((_325 >= 0.0f) ? _336 : _333) + _325;
        float _340 = ((_326 >= 0.0f) ? _336 : _333) + _326;
        float _344 = rsqrt(dot(float3(_339, _340, _330), float3(_339, _340, _330)));
        _247 = 0.0f;
        _248 = _339 * _344;
        _251 = _340 * _344;
        _254 = _344 * _330;
        _257 = 0.0f;
        _258 = _208;
        _260 = _209;
        _262 = _210;
        _264 = 0.0f;
        _266 = 1.0f;
        _268 = 0.0f;
        _269 = _195;
        _271 = _196;
        _273 = _197;
        break;
      }
    default:
      {
        _247 = _246;
        _248 = 0.0f;
        _251 = 0.0f;
        _254 = 0.0f;
        _257 = 0.0f;
        _258 = _208;
        _260 = _209;
        _262 = _210;
        _264 = _229;
        _266 = _222;
        _268 = _219;
        _269 = _195;
        _271 = _196;
        _273 = _197;
        break;
      }
  }
  float _278 = _269 - (_269 * _172);
  float _279 = _271 - (_271 * _172);
  float _280 = _273 - (_273 * _172);
  float _288 = ((_269 + (-0.039999999105930328369140625f)) * _172) + 0.039999999105930328369140625f;
  float _289 = ((_271 + (-0.039999999105930328369140625f)) * _172) + 0.039999999105930328369140625f;
  float _290 = ((_273 + (-0.039999999105930328369140625f)) * _172) + 0.039999999105930328369140625f;
  if (!(_193 == 17u)) {
    float4 _345 = _25.Load(int3(uint2(_124, _125), 0u));
    float _351 = _345.x + (-0.5f);
    float _352 = _345.y + (-0.5f);
    float _353 = _345.z + (-0.5f);
    float _357 = rsqrt(dot(float3(_351, _352, _353), float3(_351, _352, _353)));
    float _358 = _351 * _357;
    float _359 = _352 * _357;
    float _360 = _353 * _357;
    float _361 = 1.0f - _345.w;
    float _405 = mad(cb12[71u].w, texture0x, mad(cb12[70u].w, _127, cb12[69u].w * _126)) + cb12[72u].w;
    float _406 = (mad(cb12[71u].x, texture0x, mad(cb12[70u].x, _127, cb12[69u].x * _126)) + cb12[72u].x) / _405;
    float _407 = (mad(cb12[71u].y, texture0x, mad(cb12[70u].y, _127, cb12[69u].y * _126)) + cb12[72u].y) / _405;
    float _408 = (mad(cb12[71u].z, texture0x, mad(cb12[70u].z, _127, cb12[69u].z * _126)) + cb12[72u].z) / _405;
    float _414 = cb12[0u].x - _406;
    float _415 = cb12[0u].y - _407;
    float _416 = cb12[0u].z - _408;
    float _420 = rsqrt(dot(float3(_414, _415, _416), float3(_414, _415, _416)));
    float _421 = _414 * _420;
    float _422 = _415 * _420;
    float _423 = _416 * _420;
    float _468 = _406 - cb1[36u].x;
    float _469 = _407 - cb1[36u].y;
    float _470 = _408 - cb1[36u].z;
    float4 _478 = gameAreaMask.Load(int3(uint2(_124, _125), 0u));
    _478 = 1.f;
    float _480 = _478.x;
    float _481 = _478.y;
    float _482 = _478.z;
    float _492 = ((_482 != 0.0f) || ((_480 != 0.0f) || (_481 != 0.0f))) ? (cb6[5u].w * min(max(clamp(min(min(clamp((0.5f - abs((cb6[1u].x + (-0.5f)) + (cb6[0u].x * _406))) * cb12[46u].y, 0.0f, 1.0f), clamp((0.5f - abs((cb6[1u].y + (-0.5f)) + (cb6[0u].y * _407))) * cb12[46u].y, 0.0f, 1.0f)), clamp((0.5f - abs((cb6[1u].z + (-0.5f)) + (cb6[0u].z * _408))) * cb12[46u].y, 0.0f, 1.0f)), 0.0f, 1.0f), 64.0f - dot(float3(_468, _469, _470), float3(_468, _469, _470))), 1.0f)) : 0.0f;
    float4 _493 = _30.Load(int3(uint2(_124, _125), 0u));
    float _495 = _493.x;
    float _549;
    float _550;
    float _551;
    if (true && _495 > 0.0f) {
      float4 _544 = _29.Load(int3(uint2(_124, _125), 0u));
      _549 = _544.x;
      _550 = _544.y;
      _551 = _544.z;
    } else {
      _549 = 0.0f;
      _550 = 0.0f;
      _551 = 0.0f;
    }
    uint4 _556 = asuint(cb2[0u]);
    uint _560 = _556.w;
    uint4 _561 = _35.Load(int3(uint2(_124, _125), 0u));
    uint _563 = _561.x;
    float _565 = 1.0f - _247;
    float _567;
    float _571;
    float _575;
    switch (_191) {
      case 1u:
        {
          float _588 = min(cb6[3u].w, cb6[4u].w);
          float _591 = max(cb6[3u].w, cb6[4u].w) - _588;
          _567 = cb6[2u].x;
          _571 = ((clamp((_213 - _588) / _591, 0.0f, 1.0f) * _591) + _588) * cb6[2u].y;
          _575 = cb6[2u].z;
          break;
        }
      case 5u:
        {
          _567 = cb6[3u].x;
          _571 = cb6[3u].y;
          _575 = cb6[3u].z;
          break;
        }
      case 0u:
        {
          _567 = cb6[4u].x;
          _571 = cb6[4u].y;
          _575 = cb6[4u].z;
          break;
        }
      default:
        {
          _567 = 1.0f;
          _571 = 1.0f;
          _575 = 0.0f;
          break;
        }
    }
    float _600;
    float _603;
    float _606;
    float _609;
    switch (_193) {
      case 12u:
      case 13u:
      case 14u:
      case 15u:
      case 21u:
      case 30u:
      case 31u:
        {
          bool _623 = _191 == 1u;
          _600 = _623 ? 1.0f : _567;
          _603 = _623 ? 1.0f : _571;
          _606 = _623 ? 0.0f : _575;
          _609 = cb6[2u].w;
          break;
        }
      case 25u:
        {
          _600 = cb6[5u].x;
          _603 = cb6[5u].y;
          _606 = cb6[5u].z;
          _609 = 1.0f;
          break;
        }
      default:
        {
          _600 = _567;
          _603 = _571;
          _606 = _575;
          _609 = 1.0f;
          break;
        }
    }
    uint4 _620 = asuint(cb6[13u]);
    float _626;
    float _628;
    float _630;
    float _632;
    float _634;
    float _636;
    if (_620.z == 0u) {
      _626 = _147;
      _628 = _148;
      _630 = _149;
      _632 = _155;
      _634 = _156;
      _636 = _157;
    } else {
      float _656 = float(_620.y != 0u);
      float _659 = ((cb1[51u].x * (-0.5f)) * _656) + (cb0[2u].z * (_126 + 0.5f));
      float _660 = ((cb1[51u].y * 0.5f) * _656) + (cb0[2u].w * (_127 + 0.5f));
      float4 _663 = _31.SampleLevel(_68, float2(_659, _660), 0.0f);
      float4 _669 = _32.SampleLevel(_68, float2(_659, _660), 0.0f);
      float _674 = _669.x * 64.0f;
      float _675 = _669.y * 64.0f;
      float _676 = _669.z * 64.0f;
      float _678 = (_278 * 64.0f) * _663.x;
      float _680 = (_279 * 64.0f) * _663.y;
      float _682 = (_280 * 64.0f) * _663.z;
      float _874;
      float _875;
      float _876;
      if ((_191 == 0u) || (_191 == 5u)) {
        float _789 = _213 * _213;
        float _790 = abs(clamp(dot(float3(_258, _260, _262), float3(_421, _422, _423)), 0.0f, 1.0f));
        float _791 = _790 * _790;
        float _792 = _791 * _790;
        float _794 = (_789 * _789) * _789;
        float _850 = (1.0f / dot(float3(mad(52.366001129150390625f, _792, mad(2.6813199520111083984375f, _790, 1.0f)), mad(59.301300048828125f, _792, mad(-3.98451995849609375f, _790, 16.09320068359375f)), mad(2544.070068359375f, _792, mad(255.259002685546875f, _790, -5.18731021881103515625f))), float3(1.0f, _789, _794))) * dot(float2(mad(-1.38838994503021240234375f, _790, 0.995366990566253662109375f), mad(1.97441995143890380859375f, _790, -0.24751000106334686279296875f)), float2(1.0f, _789));
        float _861 = max(0.0f, (1.0f / dot(float3(mad(-1.378859996795654296875f, _792, mad(4.111179828643798828125f, _791, 1.0f)), mad(16.9514007568359375f, _792, mad(-28.9946994781494140625f, _791, 19.3253993988037109375f)), mad(-79.4492034912109375f, _792, mad(96.09940338134765625f, _791, 0.545386016368865966796875f))), float3(1.0f, _789, _794))) * dot(float2(mad(3.829010009765625f, _790, -0.0564525984227657318115234375f), mad(-11.030300140380859375f, _790, 16.909999847412109375f)), float2(1.0f, _789)));
        _874 = ((_861 * _288) + max(0.0f, _850 * clamp(_288 * 1024.0f, 0.0f, 1.0f))) * _674;
        _875 = (max(0.0f, clamp(_289 * 1024.0f, 0.0f, 1.0f) * _850) + (_861 * _289)) * _675;
        _876 = (max(0.0f, clamp(_290 * 1024.0f, 0.0f, 1.0f) * _850) + (_861 * _290)) * _676;
      } else {
        _874 = _674;
        _875 = _675;
        _876 = _676;
      }
      float _932;
      float _933;
      float _934;
      float _935;
      float _936;
      float _937;
      if ((_191 & 134217726u) == 0u) {
        float4 _922 = _37.Load(int3(uint2(_124, _125), 0u));
        float _924 = _922.x;
        float _925 = _922.y;
        _932 = _924 * _678;
        _933 = _924 * _680;
        _934 = _924 * _682;
        _935 = _925 * _874;
        _936 = _925 * _875;
        _937 = _925 * _876;
      } else {
        _932 = _678;
        _933 = _680;
        _934 = _682;
        _935 = _874;
        _936 = _875;
        _937 = _876;
      }
      _626 = _932 + _147;
      _628 = _933 + _148;
      _630 = _934 + _149;
      _632 = _935 + _155;
      _634 = _936 + _156;
      _636 = _937 + _157;
    }
    bool _646 = asuint(cb6[9u]).z != 0u;
    float _702;
    float _703;
    float _704;
    if (_231) {
      float _686 = dot(float3(_421, _422, _423), float3(_248, _251, _254));
      float _692 = _421 - (_686 * _248);
      float _693 = _422 - (_686 * _251);
      float _694 = _423 - (_686 * _254);
      float _698 = rsqrt(dot(float3(_692, _693, _694), float3(_692, _693, _694)));
      _702 = _692 * _698;
      _703 = _693 * _698;
      _704 = _694 * _698;
    } else {
      _702 = _258;
      _703 = _260;
      _704 = _262;
    }
    float _705 = (-0.0f) - _421;
    float _706 = (-0.0f) - _422;
    float _707 = (-0.0f) - _423;
    float _711 = dot(float3(_705, _706, _707), float3(_258, _260, _262)) * 2.0f;
    float _715 = _705 - (_711 * _258);
    float _716 = _706 - (_711 * _260);
    float _717 = _707 - (_711 * _262);
    float _718 = _213 * _213;
    float _719 = _718 * 0.75f;
    float _727 = ((_702 - _715) * _719) + _715;
    float _728 = ((_703 - _716) * _719) + _716;
    float _729 = ((_704 - _717) * _719) + _717;
    float _733 = rsqrt(dot(float3(_727, _728, _729), float3(_727, _728, _729)));
    float _734 = _727 * _733;
    float _735 = _728 * _733;
    float _736 = _729 * _733;
    float4 _751 = _8.SampleLevel(_66, float2((clamp(dot(float3(_258, _260, _262), float3(_421, _422, _423)), 0.0f, 1.0f) * 0.9921875f) + 0.00390625f, (clamp(_213, 0.0f, 1.0f) * 0.984375f) + 0.0078125f), 0.0f);
    float _758 = rsqrt(dot(float3(_734, _735, _736), float3(_734, _735, _736)));
    float _759 = _758 * _734;
    float _760 = _758 * _735;
    float _761 = _758 * _736;
    float _765 = (_213 * 5.0f) * (2.0f - _213);
    float _775 = ((dot(float3(_480, _481, _482), float3(0.0046718749217689037322998046875f, 0.00917187519371509552001953125f, 0.001781250000931322574615478515625f)) + (-1000.0f)) * _492) + 1000.0f;
    uint4 _777 = _19.Load((_556.x * (_125 >> 5u)) + (_124 >> 5u));
    uint _778 = _777.x;
    uint _781 = (_563 != 0u) ? (_563 << 8u) : 65536u;
    uint _783 = WaveActiveBitOr(_778);
    float _880;
    float _882;
    float _884;
    float _886;
    float _888;
    float _890;
    float _892;
    float _894;
    float _896;
    float _898;
    float _900;
    if (_783 == 0u) {
      _880 = 0.0f;
      _882 = 0.0f;
      _884 = 0.0f;
      _886 = 0.0f;
      _888 = 0.0f;
      _890 = 0.0f;
      _892 = 0.0f;
      _894 = 0.0f;
      _896 = 0.0f;
      _898 = 0.0f;
      _900 = 0.0f;
    } else {
      float _881;
      float _883;
      float _885;
      float _887;
      float _889;
      float _891;
      float _893;
      float _895;
      float _897;
      float _899;
      float _901;
      float _976;
      float _964 = 0.0f;
      float _965 = 0.0f;
      float _966 = 0.0f;
      float _967 = 0.0f;
      float _968 = 0.0f;
      float _969 = 0.0f;
      float _970 = 0.0f;
      float _971 = 0.0f;
      float _972 = 0.0f;
      float _973 = 0.0f;
      float _974 = 0.0f;
      float _975 = -1.0f;
      uint _977 = _783;
      uint _978;
      uint _979;
      bool _985;
      for (;;) {
        _979 = firstbitlow(_977);
        _978 = (_977 + 4294967295u) & _977;
        _985 = ((1u << (_979 & 31u)) & _778) == 0u;
        float frontier_phi_40_pred;
        float frontier_phi_40_pred_1;
        float frontier_phi_40_pred_2;
        float frontier_phi_40_pred_3;
        float frontier_phi_40_pred_4;
        float frontier_phi_40_pred_5;
        float frontier_phi_40_pred_6;
        float frontier_phi_40_pred_7;
        float frontier_phi_40_pred_8;
        float frontier_phi_40_pred_9;
        float frontier_phi_40_pred_10;
        float frontier_phi_40_pred_11;
        if (_985) {
          frontier_phi_40_pred = _969;
          frontier_phi_40_pred_1 = _970;
          frontier_phi_40_pred_2 = _971;
          frontier_phi_40_pred_3 = _972;
          frontier_phi_40_pred_4 = _973;
          frontier_phi_40_pred_5 = _974;
          frontier_phi_40_pred_6 = _975;
          frontier_phi_40_pred_7 = _964;
          frontier_phi_40_pred_8 = _965;
          frontier_phi_40_pred_9 = _966;
          frontier_phi_40_pred_10 = _967;
          frontier_phi_40_pred_11 = _968;
        } else {
          uint _1251 = _979 << 3u;
          uint4 _1255 = asuint(cb2[_1251 | 5u]);
          uint _1256 = _1255.w;
          float frontier_phi_40_pred_41_ladder;
          float frontier_phi_40_pred_41_ladder_1;
          float frontier_phi_40_pred_41_ladder_2;
          float frontier_phi_40_pred_41_ladder_3;
          float frontier_phi_40_pred_41_ladder_4;
          float frontier_phi_40_pred_41_ladder_5;
          float frontier_phi_40_pred_41_ladder_6;
          float frontier_phi_40_pred_41_ladder_7;
          float frontier_phi_40_pred_41_ladder_8;
          float frontier_phi_40_pred_41_ladder_9;
          float frontier_phi_40_pred_41_ladder_10;
          float frontier_phi_40_pred_41_ladder_11;
          if ((_1256 & _781) == 0u) {
            frontier_phi_40_pred_41_ladder = _969;
            frontier_phi_40_pred_41_ladder_1 = _970;
            frontier_phi_40_pred_41_ladder_2 = _971;
            frontier_phi_40_pred_41_ladder_3 = _972;
            frontier_phi_40_pred_41_ladder_4 = _973;
            frontier_phi_40_pred_41_ladder_5 = _974;
            frontier_phi_40_pred_41_ladder_6 = _975;
            frontier_phi_40_pred_41_ladder_7 = _964;
            frontier_phi_40_pred_41_ladder_8 = _965;
            frontier_phi_40_pred_41_ladder_9 = _966;
            frontier_phi_40_pred_41_ladder_10 = _967;
            frontier_phi_40_pred_41_ladder_11 = _968;
          } else {
            uint _1829 = _1251 | 1u;
            uint _1835 = _1829 + 1u;
            uint _1841 = _1251 | 3u;
            uint _1847 = _1841 + 1u;
            float _1853 = dot(float4(cb2[_1829].x, cb2[_1835].x, cb2[_1841].x, cb2[_1847].x), float4(_406, _407, _408, 1.0f));
            float _1856 = dot(float4(cb2[_1829].y, cb2[_1835].y, cb2[_1841].y, cb2[_1847].y), float4(_406, _407, _408, 1.0f));
            float _1859 = dot(float4(cb2[_1829].z, cb2[_1835].z, cb2[_1841].z, cb2[_1847].z), float4(_406, _407, _408, 1.0f));
            uint _1866 = _1251 | 7u;
            float _1876 = (cb2[_1841].w == 1.0f) ? 1.0f : (cb2[_1847].w * (1.0f - _492));
            float _1889 = clamp(min((1.0f - abs(_1853)) * cb2[_1866].x, min((1.0f - abs(_1856)) * cb2[_1866].y, (1.0f - abs(_1859)) * cb2[_1866].z)), 0.0f, 1.0f) * cb2[_1835].w;
            float frontier_phi_40_pred_41_ladder_47_ladder;
            float frontier_phi_40_pred_41_ladder_47_ladder_1;
            float frontier_phi_40_pred_41_ladder_47_ladder_2;
            float frontier_phi_40_pred_41_ladder_47_ladder_3;
            float frontier_phi_40_pred_41_ladder_47_ladder_4;
            float frontier_phi_40_pred_41_ladder_47_ladder_5;
            float frontier_phi_40_pred_41_ladder_47_ladder_6;
            float frontier_phi_40_pred_41_ladder_47_ladder_7;
            float frontier_phi_40_pred_41_ladder_47_ladder_8;
            float frontier_phi_40_pred_41_ladder_47_ladder_9;
            float frontier_phi_40_pred_41_ladder_47_ladder_10;
            float frontier_phi_40_pred_41_ladder_47_ladder_11;
            if (_1889 > 9.9999997473787516355514526367188e-05f) {
              float _2237;
              float _2239;
              float _2241;
              float _2243;
              float _2245;
              float _2247;
              if ((asuint(cb2[_1866]).w & 1u) == 0u) {
                _2237 = _702;
                _2239 = _703;
                _2241 = _704;
                _2243 = _759;
                _2245 = _760;
                _2247 = _761;
              } else {
                float _2257 = dot(float3(cb2[_1829].x, cb2[_1835].x, cb2[_1841].x), float3(_759, _760, _761));
                float _2260 = dot(float3(cb2[_1829].y, cb2[_1835].y, cb2[_1841].y), float3(_759, _760, _761));
                float _2263 = dot(float3(cb2[_1829].z, cb2[_1835].z, cb2[_1841].z), float3(_759, _760, _761));
                float _2288 = min(min((((_2257 < 0.0f) ? (-1.0f) : 1.0f) - _1853) / _2257, (((_2260 < 0.0f) ? (-1.0f) : 1.0f) - _1856) / _2260), (((_2263 < 0.0f) ? (-1.0f) : 1.0f) - _1859) / _2263);
                uint _2295 = _1829 + 5u;
                float _2301 = ((_2288 * _2257) + _1853) * cb2[_2295].x;
                float _2302 = ((_2288 * _2260) + _1856) * cb2[_2295].y;
                float _2303 = ((_2288 * _2263) + _1859) * cb2[_2295].z;
                float _2307 = rsqrt(dot(float3(_2301, _2302, _2303), float3(_2301, _2302, _2303)));
                float _2308 = cb2[_2295].x * dot(float3(cb2[_1829].x, cb2[_1835].x, cb2[_1841].x), float3(_702, _703, _704));
                float _2309 = cb2[_2295].y * dot(float3(cb2[_1829].y, cb2[_1835].y, cb2[_1841].y), float3(_702, _703, _704));
                float _2310 = cb2[_2295].z * dot(float3(cb2[_1829].z, cb2[_1835].z, cb2[_1841].z), float3(_702, _703, _704));
                float _2314 = rsqrt(dot(float3(_2308, _2309, _2310), float3(_2308, _2309, _2310)));
                _2237 = _2308 * _2314;
                _2239 = _2309 * _2314;
                _2241 = _2310 * _2314;
                _2243 = _2301 * _2307;
                _2245 = _2302 * _2307;
                _2247 = _2303 * _2307;
              }
              uint _2249 = _1256 & 255u;
              float _2251 = float(_2249);
              float _2254 = clamp((_765 + (-4.0f)) * 1.5f, 0.0f, 1.0f);
              float _2597;
              float _2598;
              float _2599;
              if (WaveActiveAnyTrue(_2254 < 1.0f)) {
                float _2569 = exp2(_765 + (-9.0f));
                float _2575 = abs(_2247) + 1.0f;
                float4 _2588 = _18.SampleLevel(_67, float3((((((_2243 / _2575) * 0.5f) * (1.0f - (_2569 * 1.25f))) + 0.5f) * 0.5f) + ((_2247 > 0.0f) ? 0.0f : 0.5f), ((0.5f - (_2569 * 0.625f)) * (_2245 / _2575)) + 0.5f, _2251), _765);
                float _2593 = 1.0f - _2254;
                _2597 = _2588.x * _2593;
                _2598 = _2588.y * _2593;
                _2599 = _2588.z * _2593;
              } else {
                _2597 = 0.0f;
                _2598 = 0.0f;
                _2599 = 0.0f;
              }
              float _2779;
              float _2780;
              float _2781;
              if (WaveActiveAnyTrue(_2254 > 0.0f)) {
                float _2687 = max(_2243, 0.0f);
                float _2688 = max(_2245, 0.0f);
                float _2689 = max(_2247, 0.0f);
                float _2690 = _2687 * _2687;
                float _2691 = _2688 * _2688;
                float _2692 = _2689 * _2689;
                float _2696 = max((-0.0f) - _2243, 0.0f);
                float _2697 = max((-0.0f) - _2245, 0.0f);
                float _2698 = max((-0.0f) - _2247, 0.0f);
                float _2699 = _2696 * _2696;
                float _2700 = _2697 * _2697;
                float _2701 = _2698 * _2698;
                uint _2702 = uint(_2251) * 6u;
                uint _2703 = _2702 + 257u;
                uint _2713 = (_2702 | 1u) + 257u;
                uint _2725 = _2702 + 259u;
                uint _2737 = _2702 + 260u;
                uint _2749 = _2702 + 261u;
                uint _2761 = _2702 + 262u;
                _2779 = (((((((cb2[_2713].x * _2699) + (cb2[_2703].x * _2690)) + (cb2[_2725].x * _2691)) + (cb2[_2737].x * _2700)) + (cb2[_2749].x * _2692)) + (cb2[_2761].x * _2701)) * _2254) + _2597;
                _2780 = (((((((cb2[_2713].y * _2699) + (cb2[_2703].y * _2690)) + (cb2[_2725].y * _2691)) + (cb2[_2737].y * _2700)) + (cb2[_2749].y * _2692)) + (cb2[_2761].y * _2701)) * _2254) + _2598;
                _2781 = (((((((cb2[_2713].z * _2699) + (cb2[_2703].z * _2690)) + (cb2[_2725].z * _2691)) + (cb2[_2737].z * _2700)) + (cb2[_2749].z * _2692)) + (cb2[_2761].z * _2701)) * _2254) + _2599;
              } else {
                _2779 = _2597;
                _2780 = _2598;
                _2781 = _2599;
              }
              float _2782 = max(_2237, 0.0f);
              float _2783 = max(_2239, 0.0f);
              float _2784 = max(_2241, 0.0f);
              float _2785 = _2782 * _2782;
              float _2786 = _2783 * _2783;
              float _2787 = _2784 * _2784;
              float _2791 = max((-0.0f) - _2237, 0.0f);
              float _2792 = max((-0.0f) - _2239, 0.0f);
              float _2793 = max((-0.0f) - _2241, 0.0f);
              float _2794 = _2791 * _2791;
              float _2795 = _2792 * _2792;
              float _2796 = _2793 * _2793;
              uint _2797 = _2249 * 6u;
              uint _2798 = _2797 + 257u;
              uint _2808 = (_2797 | 1u) + 257u;
              uint _2820 = _2797 + 259u;
              uint _2832 = _2797 + 260u;
              uint _2844 = _2797 + 261u;
              uint _2856 = _2797 + 262u;
              float _2865 = (((((cb2[_2808].x * _2794) + (cb2[_2798].x * _2785)) + (cb2[_2820].x * _2786)) + (cb2[_2832].x * _2795)) + (cb2[_2844].x * _2787)) + (cb2[_2856].x * _2796);
              float _2866 = (((((cb2[_2808].y * _2794) + (cb2[_2798].y * _2785)) + (cb2[_2820].y * _2786)) + (cb2[_2832].y * _2795)) + (cb2[_2844].y * _2787)) + (cb2[_2856].y * _2796);
              float _2867 = (((((cb2[_2808].z * _2794) + (cb2[_2798].z * _2785)) + (cb2[_2820].z * _2786)) + (cb2[_2832].z * _2795)) + (cb2[_2844].z * _2787)) + (cb2[_2856].z * _2796);
              float _2875 = clamp((_775 / max(dot(float3(_2865, _2866, _2867), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 9.9999999392252902907785028219223e-09f)) + cb2[_1829].w, 0.0f, 1.0f);
              uint _2876 = _1829 + 5u;
              float _2882 = clamp(cb2[_2876].w - _975, 0.0f, 1.0f) * _1889;
              float _2884 = (_975 > 0.0f) ? _975 : cb2[_2876].w;
              float _2887 = 1.0f - _2882;
              float _2899 = 1.0f - (_2882 * _1876);
              float _2904 = _1889 * _1876;
              frontier_phi_40_pred_41_ladder_47_ladder = (_2899 * _969) + (_2866 * _2904);
              frontier_phi_40_pred_41_ladder_47_ladder_1 = (_2899 * _970) + (_2867 * _2904);
              frontier_phi_40_pred_41_ladder_47_ladder_2 = (_2899 * _971) + _2904;
              frontier_phi_40_pred_41_ladder_47_ladder_3 = (_2887 * _972) + (_2865 * _1889);
              frontier_phi_40_pred_41_ladder_47_ladder_4 = (_2887 * _973) + (_2866 * _1889);
              frontier_phi_40_pred_41_ladder_47_ladder_5 = (_2887 * _974) + (_2867 * _1889);
              frontier_phi_40_pred_41_ladder_47_ladder_6 = ((cb2[_2876].w - _2884) * _1889) + _2884;
              frontier_phi_40_pred_41_ladder_47_ladder_7 = (_2887 * _964) + ((_2779 * _1889) * _2875);
              frontier_phi_40_pred_41_ladder_47_ladder_8 = (_2887 * _965) + ((_2780 * _1889) * _2875);
              frontier_phi_40_pred_41_ladder_47_ladder_9 = (_2887 * _966) + ((_2781 * _1889) * _2875);
              frontier_phi_40_pred_41_ladder_47_ladder_10 = (_2887 * _967) + _1889;
              frontier_phi_40_pred_41_ladder_47_ladder_11 = (_2899 * _968) + (_2865 * _2904);
            } else {
              frontier_phi_40_pred_41_ladder_47_ladder = _969;
              frontier_phi_40_pred_41_ladder_47_ladder_1 = _970;
              frontier_phi_40_pred_41_ladder_47_ladder_2 = _971;
              frontier_phi_40_pred_41_ladder_47_ladder_3 = _972;
              frontier_phi_40_pred_41_ladder_47_ladder_4 = _973;
              frontier_phi_40_pred_41_ladder_47_ladder_5 = _974;
              frontier_phi_40_pred_41_ladder_47_ladder_6 = _975;
              frontier_phi_40_pred_41_ladder_47_ladder_7 = _964;
              frontier_phi_40_pred_41_ladder_47_ladder_8 = _965;
              frontier_phi_40_pred_41_ladder_47_ladder_9 = _966;
              frontier_phi_40_pred_41_ladder_47_ladder_10 = _967;
              frontier_phi_40_pred_41_ladder_47_ladder_11 = _968;
            }
            frontier_phi_40_pred_41_ladder = frontier_phi_40_pred_41_ladder_47_ladder;
            frontier_phi_40_pred_41_ladder_1 = frontier_phi_40_pred_41_ladder_47_ladder_1;
            frontier_phi_40_pred_41_ladder_2 = frontier_phi_40_pred_41_ladder_47_ladder_2;
            frontier_phi_40_pred_41_ladder_3 = frontier_phi_40_pred_41_ladder_47_ladder_3;
            frontier_phi_40_pred_41_ladder_4 = frontier_phi_40_pred_41_ladder_47_ladder_4;
            frontier_phi_40_pred_41_ladder_5 = frontier_phi_40_pred_41_ladder_47_ladder_5;
            frontier_phi_40_pred_41_ladder_6 = frontier_phi_40_pred_41_ladder_47_ladder_6;
            frontier_phi_40_pred_41_ladder_7 = frontier_phi_40_pred_41_ladder_47_ladder_7;
            frontier_phi_40_pred_41_ladder_8 = frontier_phi_40_pred_41_ladder_47_ladder_8;
            frontier_phi_40_pred_41_ladder_9 = frontier_phi_40_pred_41_ladder_47_ladder_9;
            frontier_phi_40_pred_41_ladder_10 = frontier_phi_40_pred_41_ladder_47_ladder_10;
            frontier_phi_40_pred_41_ladder_11 = frontier_phi_40_pred_41_ladder_47_ladder_11;
          }
          frontier_phi_40_pred = frontier_phi_40_pred_41_ladder;
          frontier_phi_40_pred_1 = frontier_phi_40_pred_41_ladder_1;
          frontier_phi_40_pred_2 = frontier_phi_40_pred_41_ladder_2;
          frontier_phi_40_pred_3 = frontier_phi_40_pred_41_ladder_3;
          frontier_phi_40_pred_4 = frontier_phi_40_pred_41_ladder_4;
          frontier_phi_40_pred_5 = frontier_phi_40_pred_41_ladder_5;
          frontier_phi_40_pred_6 = frontier_phi_40_pred_41_ladder_6;
          frontier_phi_40_pred_7 = frontier_phi_40_pred_41_ladder_7;
          frontier_phi_40_pred_8 = frontier_phi_40_pred_41_ladder_8;
          frontier_phi_40_pred_9 = frontier_phi_40_pred_41_ladder_9;
          frontier_phi_40_pred_10 = frontier_phi_40_pred_41_ladder_10;
          frontier_phi_40_pred_11 = frontier_phi_40_pred_41_ladder_11;
        }
        _891 = frontier_phi_40_pred;
        _893 = frontier_phi_40_pred_1;
        _895 = frontier_phi_40_pred_2;
        _897 = frontier_phi_40_pred_3;
        _899 = frontier_phi_40_pred_4;
        _901 = frontier_phi_40_pred_5;
        _976 = frontier_phi_40_pred_6;
        _881 = frontier_phi_40_pred_7;
        _883 = frontier_phi_40_pred_8;
        _885 = frontier_phi_40_pred_9;
        _887 = frontier_phi_40_pred_10;
        _889 = frontier_phi_40_pred_11;
        if (_978 == 0u) {
          break;
        } else {
          _964 = _881;
          _965 = _883;
          _966 = _885;
          _967 = _887;
          _968 = _889;
          _969 = _891;
          _970 = _893;
          _971 = _895;
          _972 = _897;
          _973 = _899;
          _974 = _901;
          _975 = _976;
          _977 = _978;
          continue;
        }
      }
      _880 = _881;
      _882 = _883;
      _884 = _885;
      _886 = _887;
      _888 = _889;
      _890 = _891;
      _892 = _893;
      _894 = _895;
      _896 = _897;
      _898 = _899;
      _900 = _901;
    }
    float _914 = max(cb6[12u].z - (cb6[12u].z * dot(float3(_896, _898, _900), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f))), 0.0f);
    float _960;
    float _961;
    float _962;
    if ((_191 == 1u) && (asuint(cb6[12u]).x != 0u)) {
      float _941 = 1.0f - _888;
      float _942 = 1.0f - _890;
      float _943 = 1.0f - _892;
      _960 = (cb6[12u].y * (_941 - ((1.0f - (_914 * _896)) * _941))) + _888;
      _961 = (cb6[12u].y * (_942 - ((1.0f - (_914 * _898)) * _942))) + _890;
      _962 = (cb6[12u].y * (_943 - ((1.0f - (_914 * _900)) * _943))) + _892;
    } else {
      _960 = _888;
      _961 = _890;
      _962 = _892;
    }
    float _1212;
    float _1214;
    float _1216;
    float _1218;
    float _1220;
    float _1222;
    float _1224;
    float _1226;
    if (_894 < 1.0f) {
      float _989 = (_406 * 6.103515625e-05f) + 0.5f;
      float _990 = (_407 * 6.103515625e-05f) + 0.5f;
      float4 _993 = _20.SampleLevel(_66, float3(_989, _990, 0.0f), 0.0f);
      float4 _998 = _20.SampleLevel(_66, float3(_989, _990, 1.0f), 0.0f);
      float _1000 = _998.x;
      float _1001 = _998.y;
      float _1002 = _998.z;
      float4 _1003 = _20.SampleLevel(_66, float3(_989, _990, 2.0f), 0.0f);
      float _1005 = _1003.x;
      float _1012 = _406 - cb1[36u].x;
      float _1013 = _407 - cb1[36u].y;
      float _1017 = sqrt((_1012 * _1012) + (_1013 * _1013));
      float _1027 = clamp((cb12[45u].x * _1017) + cb12[45u].y, 0.0f, 1.0f);
      float _1035 = (cb12[46u].x * _1017) + 1.0f;
      float _1042 = clamp((cb12[45u].w * _1035) + ((cb12[45u].z * ((_408 + 100.0f) - (_993.z * 900.0f))) / _1035), 0.0f, 1.0f);
      float _1044 = max((-0.0f) - _704, 0.0f);
      float _1055 = max(clamp((((-110.0f) - _408) + (_1003.y * 900.0f)) / ((cb12[46u].w * _1003.z) + 10.0f), 0.0f, 1.0f), _1044);
      float _1056 = _704 + 0.660000026226043701171875f;
      float _1061 = rsqrt(dot(float3(_702, _703, _1056), float3(_702, _703, _1056)));
      float _1062 = _1061 * _702;
      float _1063 = _1061 * _703;
      float _1064 = _1061 * _1056;
      float _1065 = max(_1062, 0.0f);
      float _1066 = max(_1063, 0.0f);
      float _1067 = max(_1064, 0.0f);
      float _1068 = _1065 * _1065;
      float _1069 = _1066 * _1066;
      float _1070 = _1067 * _1067;
      float _1074 = max((-0.0f) - _1062, 0.0f);
      float _1075 = max((-0.0f) - _1063, 0.0f);
      float _1076 = max((-0.0f) - _1064, 0.0f);
      float _1077 = _1074 * _1074;
      float _1078 = _1075 * _1075;
      float _1079 = _1076 * _1076;
      float _1100 = (_993.x * 2.0f) + (-1.0f);
      float _1101 = (_993.y * 2.0f) + (-1.0f);
      float _1106 = sqrt(1.0f - dot(float2(_1100, _1101), float2(_1100, _1101)));
      float _1107 = max(_1100, 0.0f);
      float _1108 = max(_1101, 0.0f);
      float _1109 = max(_1106, 0.0f);
      float _1110 = _1107 * _1107;
      float _1111 = _1108 * _1108;
      float _1112 = _1109 * _1109;
      float _1116 = max((-0.0f) - _1100, 0.0f);
      float _1117 = max((-0.0f) - _1101, 0.0f);
      float _1118 = max((-0.0f) - _1106, 0.0f);
      float _1119 = _1116 * _1116;
      float _1120 = _1117 * _1117;
      float _1121 = _1118 * _1118;
      float _1122 = max(_702, 0.0f);
      float _1123 = max(_703, 0.0f);
      float _1124 = max(_704, 0.0f);
      float _1125 = _1122 * _1122;
      float _1126 = _1123 * _1123;
      float _1127 = _1124 * _1124;
      float _1130 = max((-0.0f) - _702, 0.0f);
      float _1131 = max((-0.0f) - _703, 0.0f);
      float _1132 = _1130 * _1130;
      float _1133 = _1131 * _1131;
      float _1134 = _1044 * _1044;
      uint _1135 = _560 * 6u;
      uint _1136 = _1135 + 257u;
      uint _1147 = (_1135 | 1u) + 257u;
      uint _1159 = _1135 + 259u;
      uint _1172 = _1135 + 260u;
      uint _1185 = _1135 + 261u;
      uint _1198 = _1135 + 262u;
      float _1208 = (((((cb2[_1147].x * _1132) + (cb2[_1136].x * _1125)) + (cb2[_1159].x * _1126)) + (cb2[_1172].x * _1133)) + (cb2[_1185].x * _1127)) + (cb2[_1198].x * _1134);
      float _1209 = (((((cb2[_1147].y * _1132) + (cb2[_1136].y * _1125)) + (cb2[_1159].y * _1126)) + (cb2[_1172].y * _1133)) + (cb2[_1185].y * _1127)) + (cb2[_1198].y * _1134);
      float _1210 = (((((cb2[_1147].z * _1132) + (cb2[_1136].z * _1125)) + (cb2[_1159].z * _1126)) + (cb2[_1172].z * _1133)) + (cb2[_1185].z * _1127)) + (cb2[_1198].z * _1134);
      float _1259;
      float _1261;
      float _1263;
      if (cb12[46u].x < 0.0f) {
        _1259 = _1208;
        _1261 = _1209;
        _1263 = _1210;
      } else {
        float _1357 = (_704 * 0.5f) + 0.5f;
        float _1375 = ((_1055 * (0.4000000059604644775390625f - cb12[46u].z)) * abs(_704)) + (1.0f - (_1055 * 0.4000000059604644775390625f));
        float _1376 = _1375 * ((((((((((cb2[450u].x * _1119) + (cb2[449u].x * _1110)) + (cb2[451u].x * _1111)) + (cb2[452u].x * _1120)) + (cb2[453u].x * _1112)) + (cb2[454u].x * _1121)) * _1005) - _1000) * _1357) + _1000);
        float _1377 = _1375 * ((((((((((cb2[450u].y * _1119) + (cb2[449u].y * _1110)) + (cb2[451u].y * _1111)) + (cb2[452u].y * _1120)) + (cb2[453u].y * _1112)) + (cb2[454u].y * _1121)) * _1005) - _1001) * _1357) + _1001);
        float _1378 = _1375 * ((((((((((cb2[450u].z * _1119) + (cb2[449u].z * _1110)) + (cb2[451u].z * _1111)) + (cb2[452u].z * _1120)) + (cb2[453u].z * _1112)) + (cb2[454u].z * _1121)) * _1005) - _1002) * _1357) + _1002);
        float _1388 = dot(float3(_1376, _1377, _1378), 0.333000004291534423828125f.xxx) / max(dot(float3(_1208, _1209, _1210), 0.333000004291534423828125f.xxx), 9.9999997473787516355514526367188e-06f);
        float _1389 = _1388 * _1208;
        float _1390 = _1388 * _1209;
        float _1391 = _1388 * _1210;
        float _1398 = ((_1376 - _1389) * _1027) + _1389;
        float _1399 = ((_1377 - _1390) * _1027) + _1390;
        float _1400 = ((_1378 - _1391) * _1027) + _1391;
        float _1404 = clamp((_704 * 10.0f) + 2.0f, 0.0f, 1.0f) * _1042;
        _1259 = (((((((((cb2[450u].x * _1077) + (cb2[449u].x * _1068)) + (cb2[451u].x * _1069)) + (cb2[452u].x * _1078)) + (cb2[453u].x * _1070)) + (cb2[454u].x * _1079)) * _1005) - _1398) * _1404) + _1398;
        _1261 = (((((((((cb2[450u].y * _1077) + (cb2[449u].y * _1068)) + (cb2[451u].y * _1069)) + (cb2[452u].y * _1078)) + (cb2[453u].y * _1070)) + (cb2[454u].y * _1079)) * _1005) - _1399) * _1404) + _1399;
        _1263 = (((((((((cb2[450u].z * _1077) + (cb2[449u].z * _1068)) + (cb2[451u].z * _1069)) + (cb2[452u].z * _1078)) + (cb2[453u].z * _1070)) + (cb2[454u].z * _1079)) * _1005) - _1400) * _1404) + _1400;
      }
      float _1213;
      float _1215;
      float _1217;
      float _1219;
      if (_886 < 1.0f) {
        float _1891 = float(_560);
        float _1895 = clamp((_765 + (-4.0f)) * 1.5f, 0.0f, 1.0f);
        float _2140;
        float _2141;
        float _2142;
        if (WaveActiveAnyTrue(_1895 < 1.0f)) {
          float _2110 = exp2(_765 + (-9.0f));
          float _2117 = abs(_761) + 1.0f;
          float4 _2131 = _18.SampleLevel(_67, float3((((((_759 / _2117) * 0.5f) * (1.0f - (_2110 * 1.25f))) + 0.5f) * 0.5f) + ((_761 > 0.0f) ? 0.0f : 0.5f), ((0.5f - (_2110 * 0.625f)) * (_760 / _2117)) + 0.5f, _1891), _765);
          float _2136 = 1.0f - _1895;
          _2140 = _2131.x * _2136;
          _2141 = _2131.y * _2136;
          _2142 = _2131.z * _2136;
        } else {
          _2140 = 0.0f;
          _2141 = 0.0f;
          _2142 = 0.0f;
        }
        float _2408;
        float _2409;
        float _2410;
        if (WaveActiveAnyTrue(_1895 > 0.0f)) {
          float _2316 = max(_759, 0.0f);
          float _2317 = max(_760, 0.0f);
          float _2318 = max(_761, 0.0f);
          float _2319 = _2316 * _2316;
          float _2320 = _2317 * _2317;
          float _2321 = _2318 * _2318;
          float _2325 = max((-0.0f) - _759, 0.0f);
          float _2326 = max((-0.0f) - _760, 0.0f);
          float _2327 = max((-0.0f) - _761, 0.0f);
          float _2328 = _2325 * _2325;
          float _2329 = _2326 * _2326;
          float _2330 = _2327 * _2327;
          uint _2331 = uint(_1891) * 6u;
          uint _2332 = _2331 + 257u;
          uint _2342 = (_2331 | 1u) + 257u;
          uint _2354 = _2331 + 259u;
          uint _2366 = _2331 + 260u;
          uint _2378 = _2331 + 261u;
          uint _2390 = _2331 + 262u;
          _2408 = (((((((cb2[_2342].x * _2328) + (cb2[_2332].x * _2319)) + (cb2[_2354].x * _2320)) + (cb2[_2366].x * _2329)) + (cb2[_2378].x * _2321)) + (cb2[_2390].x * _2330)) * _1895) + _2140;
          _2409 = (((((((cb2[_2342].y * _2328) + (cb2[_2332].y * _2319)) + (cb2[_2354].y * _2320)) + (cb2[_2366].y * _2329)) + (cb2[_2378].y * _2321)) + (cb2[_2390].y * _2330)) * _1895) + _2141;
          _2410 = (((((((cb2[_2342].z * _2328) + (cb2[_2332].z * _2319)) + (cb2[_2354].z * _2320)) + (cb2[_2366].z * _2329)) + (cb2[_2378].z * _2321)) + (cb2[_2390].z * _2330)) * _1895) + _2142;
        } else {
          _2408 = _2140;
          _2409 = _2141;
          _2410 = _2142;
        }
        float _2602;
        float _2604;
        float _2606;
        if (cb12[46u].x < 0.0f) {
          _2602 = _2408;
          _2604 = _2409;
          _2606 = _2410;
        } else {
          float _2632 = (-0.0f) - _761;
          float4 _2635 = _15.SampleLevel(_67, float3((-0.0f) - _759, (-0.0f) - _760, _2632), _765);
          float _2640 = _2635.x * _1005;
          float _2641 = _2635.y * _1005;
          float _2642 = _2635.z * _1005;
          float _2643 = max(_2642, 9.9999997473787516355514526367188e-06f);
          float _2647 = _2640 * (_1000 / _2643);
          float _2648 = (_1001 / _2643) * _2641;
          float _2649 = (_1002 / _2643) * _2642;
          float _2656 = max(_2632, 0.0f);
          float _2669 = max(_1042, _1027);
          float _2685 = 1.0f - ((cb12[46u].z * _1055) * (((clamp(abs(_704) * 10.0f, 0.0f, 1.0f) + (-1.0f)) * _1042) + 1.0f));
          _2602 = _2685 * ((_2669 * (((_2647 - _2408) + ((_2640 - _2647) * _1042)) + (_2656 * _1000))) + _2408);
          _2604 = _2685 * ((_2669 * (((_2648 - _2409) + ((_2641 - _2648) * _1042)) + (_2656 * _1001))) + _2409);
          _2606 = (((((_2649 - _2410) + (_2656 * _1002)) + ((_2642 - _2649) * _1042)) * _2669) + _2410) * _2685;
        }
        float _2622 = min(max(cb0[11u].z + (_775 / max(dot(float3(_1259, _1261, _1263), float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f)), 0.00999999977648258209228515625f)), 0.00999999977648258209228515625f), 1.0f);
        float _2623 = 1.0f - _886;
        _1213 = ((_2602 * _2623) * _2622) + _880;
        _1215 = ((_2604 * _2623) * _2622) + _882;
        _1217 = ((_2606 * _2623) * _2622) + _884;
        _1219 = 1.0f;
      } else {
        _1213 = _880;
        _1215 = _882;
        _1217 = _884;
        _1219 = _886;
      }
      float _1916 = 1.0f - _894;
      _1212 = _1213;
      _1214 = _1215;
      _1216 = _1217;
      _1218 = _1219;
      _1220 = (((((cb0[11u].y * _480) - _1259) * _492) + _1259) * _1916) + _960;
      _1222 = (((((cb0[11u].y * _481) - _1261) * _492) + _1261) * _1916) + _961;
      _1224 = (((((cb0[11u].y * _482) - _1263) * _492) + _1263) * _1916) + _962;
      _1226 = 1.0f;
    } else {
      _1212 = _880;
      _1214 = _882;
      _1216 = _884;
      _1218 = _886;
      _1220 = _960;
      _1222 = _961;
      _1224 = _962;
      _1226 = _894;
    }
    float _1230 = cb0[11u].x / _1218;
    float _1231 = _1230 * _1212;
    float _1232 = _1230 * _1214;
    float _1233 = _1230 * _1216;
    float _1234 = cb0[11u].x / _1226;
    float _1235 = _1234 * _1220;
    float _1236 = _1234 * _1222;
    float _1237 = _1234 * _1224;
    float _1920;
    float _1922;
    float _1924;
    float _1926;
    float _1928;
    float _1930;
    float _1932;
    float _1934;
    float _1936;
    bool _1938;
    float _1940;
    float _1942;
    float _1944;
    float _1946;
    float _1948;
    float _1950;
    float _1952;
    float _1954;
    if (_231) {
      float _1421 = (-0.0f) - _248;
      float _1422 = (-0.0f) - _251;
      float _1423 = (-0.0f) - _254;
      float _1427 = rsqrt(dot(float3(_1421, _1422, _1423), float3(_1421, _1422, _1423)));
      float _1428 = _1427 * _1421;
      float _1429 = _1427 * _1422;
      float _1430 = _1427 * _1423;
      float _1440 = min(max(cb0[17u].y * _278, 9.9999997473787516355514526367188e-06f), 1.0f);
      float _1441 = min(max(cb0[17u].y * _279, 9.9999997473787516355514526367188e-06f), 1.0f);
      float _1442 = min(max(cb0[17u].y * _280, 9.9999997473787516355514526367188e-06f), 1.0f);
      float _1443 = dot(float3(_1428, _1429, _1430), float3(_702, _703, _704));
      float _1446 = dot(float3(_702, _703, _704), float3(_421, _422, _423));
      float _1449 = dot(float3(_1428, _1429, _1430), float3(_421, _422, _423));
      float _1457 = cos(abs(asin(_1449) - asin(_1443)) * 0.5f);
      float _1461 = _702 - (_1443 * _1428);
      float _1462 = _703 - (_1443 * _1429);
      float _1463 = _704 - (_1443 * _1430);
      float _1467 = rsqrt(dot(float3(_1461, _1462, _1463), float3(_1461, _1462, _1463)));
      float _1468 = _1467 * _1461;
      float _1469 = _1467 * _1462;
      float _1470 = _1467 * _1463;
      float _1474 = _421 - (_1449 * _1428);
      float _1475 = _422 - (_1449 * _1429);
      float _1476 = _423 - (_1449 * _1430);
      float _1480 = rsqrt(dot(float3(_1474, _1475, _1476), float3(_1474, _1475, _1476)));
      float _1481 = _1480 * _1474;
      float _1482 = _1480 * _1475;
      float _1483 = _1480 * _1476;
      float _1497 = rsqrt((dot(float3(_1481, _1482, _1483), float3(_1481, _1482, _1483)) * dot(float3(_1468, _1469, _1470), float3(_1468, _1469, _1470))) + 9.9999997473787516355514526367188e-05f) * dot(float3(_1468, _1469, _1470), float3(_1481, _1482, _1483));
      float _1501 = sqrt(clamp((_1497 * 0.5f) + 0.5f, 0.0f, 1.0f));
      float _1515 = (frac(frac(dot(_257.xx, float2(0.067110560834407806396484375f, 0.005837149918079376220703125f))) * 52.98291778564453125f) * (cb0[17u].w - cb0[17u].z)) + cb0[17u].z;
      float _1520 = cb0[16u].x + _1515;
      float _1523 = _213 / cb0[17u].x;
      float _1527 = cb0[19u].x + (_718 * 2.0f);
      float _1528 = sin(_1520);
      float _1539 = _1449 + _1443;
      float _1540 = _1539 - ((_1528 * 2.0f) * (((cos(_1520) * _1501) * sqrt(1.0f - (_1449 * _1449))) + (_1528 * _1449)));
      float _1543 = (_1501 * 1.41421353816986083984375f) * ((_1523 * _1523) + cb0[19u].x);
      float _1560 = 1.0f - sqrt(clamp((_1446 * 0.5f) + 0.5f, 0.0f, 1.0f));
      float _1561 = _1560 * _1560;
      float _1575 = dot(float3(_258, _260, _262), float3(_702, _703, _704));
      float _1579 = cb0[19u].y + 1.0f;
      float _1588 = (clamp((clamp((_1575 + cb0[19u].y) / (_1579 * _1579), 0.0f, 1.0f) + 1.0f) - cb0[19u].z, 0.0f, 1.0f) * cb0[14u].x) * ((((_1501 * 0.25f) * (exp2((((_1540 * _1540) * (-0.5f)) / (_1543 * _1543)) * 1.44269502162933349609375f) / (_1543 * 2.5066282749176025390625f))) * (1.0f - clamp((-0.0f) - _1446, 0.0f, 1.0f))) * (((_1561 * _1561) * (_1560 * 0.95347940921783447265625f)) + 0.046520568430423736572265625f));
      float _1590 = (_1539 - _1515) - cb0[16u].z;
      float _1600 = 1.0f - (_1457 * 0.5f);
      float _1601 = _1600 * _1600;
      float _1606 = (_1601 * _1601) * (0.95347940921783447265625f - (_1457 * 0.476739704608917236328125f));
      float _1608 = 0.95347940921783447265625f - _1606;
      float _1609 = 0.800000011920928955078125f / _1457;
      float _1635 = (((_1608 * _1608) * (_1606 + 0.046520568430423736572265625f)) * (exp2((((_1590 * _1590) * (-0.5f)) / (_1527 * _1527)) * 1.44269502162933349609375f) / (_1527 * 2.5066282749176025390625f))) * exp2(((cb0[20u].x * _1497) - cb0[20u].y) * 1.44269502162933349609375f);
      float _1652 = cb0[18u].x + 1.0f;
      float _1655 = clamp((_1575 + cb0[18u].x) / (_1652 * _1652), 0.0f, 1.0f);
      float _1659 = clamp((_1655 + 1.0f) - cb0[18u].w, 0.0f, 1.0f);
      float _1664 = ((cb0[18u].y * ((1.0f - abs(_1443)) - _1655)) + _1655) * 0.3183098733425140380859375f;
      float _1687 = _1235 * (-6.283185482025146484375f);
      float _1690 = _1236 * (-6.283185482025146484375f);
      float _1692 = _1237 * (-6.283185482025146484375f);
      _1920 = (_273 * 2.755199909210205078125f) + 0.69029998779296875f;
      _1922 = (_271 * 2.755199909210205078125f) + 0.69029998779296875f;
      _1924 = (_269 * 2.755199909210205078125f) + 0.69029998779296875f;
      _1926 = 0.6417000293731689453125f - (_273 * 4.79510021209716796875f);
      _1928 = 0.6417000293731689453125f - (_271 * 4.79510021209716796875f);
      _1930 = 0.6417000293731689453125f - (_269 * 4.79510021209716796875f);
      _1932 = (_273 * 2.040400028228759765625f) + (-0.3323999941349029541015625f);
      _1934 = (_271 * 2.040400028228759765625f) + (-0.3323999941349029541015625f);
      _1936 = (_269 * 2.040400028228759765625f) + (-0.3323999941349029541015625f);
      _1938 = !_646;
      // _1940 = _1687 * min((-0.0f) - (_1588 + ((exp2(log2(abs(_1440)) * _1609) * cb0[14u].z) * _1635)), 0.0f);
      // _1942 = _1690 * min((-0.0f) - (_1588 + ((exp2(log2(abs(_1441)) * _1609) * cb0[14u].z) * _1635)), 0.0f);
      // _1944 = _1692 * min((-0.0f) - (_1588 + ((exp2(log2(abs(_1442)) * _1609) * cb0[14u].z) * _1635)), 0.0f);
      _1946 = _1687 * min((-0.0f) - (((cb0[14u].w * _1440) * _1659) * _1664), 0.0f);
      _1948 = _1690 * min((-0.0f) - (((cb0[14u].w * _1441) * _1659) * _1664), 0.0f);
      _1950 = _1692 * min((-0.0f) - (((cb0[14u].w * _1442) * _1659) * _1664), 0.0f);
      _1952 = 1.0f;
      _1954 = 1.0f;
    } else {
      float _1725 = WaveReadLaneFirst(asfloat(_12.Load(3u).x));
      float _1740 = dot(float3(_358, _359, _360), float3(_258, _260, _262));
      float _1768 = exp2(log2(1.0f - clamp(dot(float3(_421, _422, _423), float3(_258, _260, _262)), 0.0f, 1.0f)) * 3.0f) * cb12[52u].x;
      float _1771 = exp2(_718 * (-3.321929931640625f));
      float _1772 = dot(float3(_734, _735, _736), float3(_358, _359, _360));
      float _1775 = abs(_361);
      float _1788 = (((((0.074093498289585113525390625f - (_1775 * 0.01861659996211528778076171875f)) * _1775) + (-0.212053000926971435546875f)) * _1775) + 1.5707299709320068359375f) * sqrt(1.0f - _1775);
      float _1792 = (_361 >= 0.0f) ? _1788 : (3.1415927410125732421875f - _1788);
      float _1793 = abs(_1771);
      float _1802 = (((((0.074093498289585113525390625f - (_1793 * 0.01861659996211528778076171875f)) * _1793) + (-0.212053000926971435546875f)) * _1793) + 1.5707299709320068359375f) * sqrt(1.0f - _1793);
      float _1805 = (_1771 >= 0.0f) ? _1802 : (3.1415927410125732421875f - _1802);
      float _1806 = abs(_1772);
      float _1815 = (((((0.074093498289585113525390625f - (_1806 * 0.01861659996211528778076171875f)) * _1806) + (-0.212053000926971435546875f)) * _1806) + 1.5707299709320068359375f) * sqrt(1.0f - _1806);
      float _1824 = min(max(((_1772 >= 0.0f) ? _1815 : (3.1415927410125732421875f - _1815)) + _1768, 0.0f), 3.1415927410125732421875f) / (1.0f - (_1768 * 0.3183098733425140380859375f));
      float _2201;
      if (_1824 > (max(_1792, _1805) - min(_1792, _1805))) {
        float _2098 = _1805 + _1792;
        float frontier_phi_58_51_ladder;
        if (_1824 > _2098) {
          frontier_phi_58_51_ladder = 0.0f;
        } else {
          float _2224 = abs(_1792 - _1805);
          float _2230 = clamp(1.0f - clamp((_1824 - _2224) / (_2098 - _2224), 0.0f, 1.0f), 0.0f, 1.0f);
          frontier_phi_58_51_ladder = ((_2230 * _2230) * (3.0f - (_2230 * 2.0f))) * (1.0f - max(_361, _1771));
        }
        _2201 = frontier_phi_58_51_ladder;
      } else {
        _2201 = 1.0f - max(_361, _1771);
      }
      bool _1939 = !_646;
      bool _2208 = (_361 < 9.9999999747524270787835121154785e-07f) || ((_191 == 3u) && _1939);
      float _2209 = _2208 ? 1.0f : clamp((0.5f - (_361 * 0.560000002384185791015625f)) + ((((_361 * 0.1829369962215423583984375f) * _1740) + (0.5f - ((_361 * _361) * 0.5f))) * _1740), 0.0f, 1.0f);
      float _2210 = _2208 ? 1.0f : clamp(_2201 / (1.0f - _1771), 0.0f, 1.0f);
      float _2215 = clamp(dot(float3(_269, _271, _273), 50.0f.xxx), 0.0f, 1.0f);
      float _2217 = ((_603 + (-1.0f)) * _565) * _2209;
      float _1953;
      float _1955;
      float _2512;
      if (_191 == 5u) {
        _1953 = (((1.0f - _2209) * _268) * cb12[52u].y) + _2209;
        _1955 = (((1.0f - _2210) * _268) * cb12[52u].z) + _2210;
        _2512 = clamp(1.0f - ((9.0f - _2217) * _268), 0.0f, 1.0f) * _2215;
      } else {
        _1953 = _2209;
        _1955 = _2210;
        _2512 = _2215;
      }
      float _2519 = max(0.0f, (cb12[51u].x * (_1953 + (-1.0f))) + 1.0f);
      float _1937 = (_269 * 2.040400028228759765625f) + (-0.3323999941349029541015625f);
      float _1935 = (_271 * 2.040400028228759765625f) + (-0.3323999941349029541015625f);
      float _1933 = (_273 * 2.040400028228759765625f) + (-0.3323999941349029541015625f);
      float _1931 = 0.6417000293731689453125f - (_269 * 4.79510021209716796875f);
      float _1929 = 0.6417000293731689453125f - (_271 * 4.79510021209716796875f);
      float _1927 = 0.6417000293731689453125f - (_273 * 4.79510021209716796875f);
      float _1925 = (_269 * 2.755199909210205078125f) + 0.69029998779296875f;
      float _1923 = (_271 * 2.755199909210205078125f) + 0.69029998779296875f;
      float _1921 = (_273 * 2.755199909210205078125f) + 0.69029998779296875f;
      float _2547 = ((((_600 + (-1.0f)) * _565) * _2209) + 1.0f) * _751.x;
      float _2551 = ((((_2217 + 1.0f) + ((_609 * _565) * _2209)) * _751.y) * _2512) + ((_606 * _565) * _2209);
      float _2567 = (cb12[51u].y * (_1955 + (-1.0f))) + 1.0f;
      _1920 = _1921;
      _1922 = _1923;
      _1924 = _1925;
      _1926 = _1927;
      _1928 = _1929;
      _1930 = _1931;
      _1932 = _1933;
      _1934 = _1935;
      _1936 = _1937;
      _1938 = _1939;
      _1940 = (clamp(_2551 + (_2547 * _288), 0.0f, 1.0f) * ((((_1725 * _549) - _1231) * _495) + _1231)) * _2567;
      _1942 = (clamp(_2551 + (_2547 * _289), 0.0f, 1.0f) * ((((_1725 * _550) - _1232) * _495) + _1232)) * _2567;
      _1944 = (clamp(_2551 + (_2547 * _290), 0.0f, 1.0f) * ((((_1725 * _551) - _1233) * _495) + _1233)) * _2567;
      _1946 = max(_2519, (_1925 + ((_1931 + (_2519 * _1937)) * _2519)) * _2519) * _1235;
      _1948 = max(_2519, (_1923 + ((_1929 + (_2519 * _1935)) * _2519)) * _2519) * _1236;
      _1950 = max(_2519, (_1921 + ((_1927 + (_2519 * _1933)) * _2519)) * _2519) * _1237;
      _1952 = _1953;
      _1954 = _1955;
    }
    bool _1966 = _191 == 3u;
    bool _1967 = _1966 && _1938;
    // _1967 = true;
    float _1968 = _1967 ? 1.0f : ((cb12[51u].z * (_1952 + (-1.0f))) + 1.0f);
    float _2003 = (_1967 ? 1.0f : ((cb12[51u].w * (_1954 + (-1.0f))) + 1.0f)) * _266;
    float _2041 = exp2(log2(_264) * 4.0f) * cb12[48u].x; // cb12[48u].x;
    float _2044 = ((((exp2(WaveReadLaneFirst(asfloat(_12.Load(5u).x)) * _264) * clamp(_264 * 32.0f, 0.0f, 1.0f)) * WaveReadLaneFirst(asfloat(_12.Load(3u).x))) - _2041) * cb12[48u].z) + _2041;
    float _2045 = dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_269, _271, _273));
    float _2068 = (cb6[9u].w * float(_1966)) + 1.0f;
    // _2068 = float(_1966) + 1.f;
    float _2084 = (-0.0f) - min((-0.0f) - _1940, 0.0f);
    float _2085 = (-0.0f) - min((-0.0f) - _1942, 0.0f);
    float _2086 = (-0.0f) - min((-0.0f) - _1944, 0.0f);
    float _2088 = (-0.0f) - (SYS_TEXCOORD.x * min((-0.0f) - (_2068 * (((((_1946 * _278) + (_1940 * _266)) + (max(_1968, (_1924 + ((_1930 + (_1968 * _1936)) * _1968)) * _1968) * _626)) + (_2003 * _632)) + (((((_269 - _2045) * cb12[47u].w) + _2045) * cb12[47u].x) * _2044))), 0.0f));
    float _2090 = (-0.0f) - (SYS_TEXCOORD.x * min((-0.0f) - (_2068 * (((((_1948 * _279) + (_1942 * _266)) + (max(_1968, (_1922 + ((_1928 + (_1968 * _1934)) * _1968)) * _1968) * _628)) + (_2003 * _634)) + (((((_271 - _2045) * cb12[47u].w) + _2045) * cb12[47u].y) * _2044))), 0.0f));
    float _2092 = (-0.0f) - (SYS_TEXCOORD.x * min((-0.0f) - (_2068 * (((((_1950 * _280) + (_1944 * _266)) + (max(_1968, (_1920 + ((_1926 + (_1968 * _1932)) * _1968)) * _1968) * _630)) + (_2003 * _636)) + (((((_273 - _2045) * cb12[47u].w) + _2045) * cb12[47u].z) * _2044))), 0.0f));
    /// float _2088 = (-0.0f) - (injectedData.debugValue03 * min((-0.0f) - (_2068 * (((((_1946 * _278) + (_1940 * _266)) + (max(_1968, (_1924 + ((_1930 + (_1968 * _1936)) * _1968)) * _1968) * _626)) + (_2003 * _632)) + (((((_269 - _2045) * cb12[47u].w) + _2045) * cb12[47u].x) * _2044))), 0.0f));
    /// float _2090 = (-0.0f) - (injectedData.debugValue03 * min((-0.0f) - (_2068 * (((((_1948 * _279) + (_1942 * _266)) + (max(_1968, (_1922 + ((_1928 + (_1968 * _1934)) * _1968)) * _1968) * _628)) + (_2003 * _634)) + (((((_271 - _2045) * cb12[47u].w) + _2045) * cb12[47u].y) * _2044))), 0.0f));
    /// float _2092 = (-0.0f) - (injectedData.debugValue03 * min((-0.0f) - (_2068 * (((((_1950 * _280) + (_1944 * _266)) + (max(_1968, (_1920 + ((_1926 + (_1968 * _1932)) * _1968)) * _1968) * _630)) + (_2003 * _636)) + (((((_273 - _2045) * cb12[47u].w) + _2045) * cb12[47u].z) * _2044))), 0.0f));
    float _2145;
    float _2147;
    float _2149;
    float _2151;
    float _2153;
    float _2155;
    if (asuint(cb6[11u]).x == 0u) {
      _2145 = _2084;
      _2147 = _2085;
      _2149 = _2086;
      _2151 = _2088;
      _2153 = _2090;
      _2155 = _2092;
    } else {
      // Random
      float _2170 = frac(gl_FragCoord.x * 0.103100001811981201171875f);
      float _2171 = frac(gl_FragCoord.y * 0.10300000011920928955078125f);
      float _2172 = frac(cb0[0u].x * 0.097300000488758087158203125f);
      float _2177 = dot(float3(_2170, _2171, _2172), float3(_2171 + 33.3300018310546875f, _2170 + 33.3300018310546875f, _2172 + 33.3300018310546875f));
      float _2180 = _2177 + _2170;
      float _2181 = _2177 + _2171;
      float _2183 = _2180 + _2181;
      float _2198 = ((frac(_2183 * (_2177 + _2172)) + (-0.5f)) * 0.0199999995529651641845703125f) + 1.0f;
      float _2199 = ((frac((_2180 * 2.0f) * _2181) + (-0.5f)) * 0.0199999995529651641845703125f) + 1.0f;
      float _2200 = ((frac(_2183 * _2180) + (-0.5f)) * 0.039999999105930328369140625f) + 1.0f;
      _2145 = _2198 * _2084;
      _2147 = _2199 * _2085;
      _2149 = _2200 * _2086;
      _2151 = _2198 * _2088;
      _2153 = _2199 * _2090;
      _2155 = _2200 * _2092;
    }
    float _2454;
    float _2455;
    float _2456;
    if (((_193 == 21u) || (_193 == 30u))) {
      float _2426 = cb1[36u].x - _406;
      float _2427 = cb1[36u].y - _407;
      float _2428 = cb1[36u].z - _408;
      float _2438 = clamp((sqrt(((_2426 * _2426) + (_2427 * _2427)) + (_2428 * _2428)) - cb6[14u].x) / (cb6[14u].y - cb6[14u].x), 0.0f, 1.0f);
      _2454 = (_2438 * (((cb6[14u].w * _2151) * cb6[14u].z) - _2151)) + _2151;
      _2455 = (_2438 * (((cb6[14u].w * _2153) * cb6[14u].z) - _2153)) + _2153;
      _2456 = (_2438 * (((cb6[14u].w * _2155) * cb6[14u].z) - _2155)) + _2155;
    } else {
      _2454 = _2151;
      _2455 = _2153;
      _2456 = _2155;
    }
    SV_Target.x = 1.f; //min(max((-0.0f) - min((-0.0f) - _2454, 0.0f), 0.0f), 65000.0f);
    SV_Target.y = 1.f; //min(max((-0.0f) - min((-0.0f) - _2455, 0.0f), 0.0f), 65000.0f);
    SV_Target.z = 1.f; //min(max((-0.0f) - min((-0.0f) - _2456, 0.0f), 0.0f), 65000.0f);
    SV_Target.w = 1.0f;
    // Hand?
    SV_Target_1.x = 1.f; // min(max((-0.0f) - min((-0.0f) - _2145, 0.0f), 0.0f), 65000.0f);
    SV_Target_1.y = 1.f; // min(max((-0.0f) - min((-0.0f) - _2147, 0.0f), 0.0f), 65000.0f);
    SV_Target_1.z = 1.f; // min(max((-0.0f) - min((-0.0f) - _2149, 0.0f), 0.0f), 65000.0f);
    SV_Target_1.w = 1.f; // 1.0f;
  }
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
