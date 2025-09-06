#include "../common.hlsli"

cbuffer CB0_buf : register(b0, space8) {
  float2 CB0_m0 : packoffset(c0);
  float2 CB0_m1 : packoffset(c0.z);
  float4 CB0_m2 : packoffset(c1);
  float4 CB0_m3 : packoffset(c2);
};

Texture2D<float4> T0 : register(t0, space8);
RWTexture2D<float4> U0 : register(u0, space8);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

uint spvBitfieldInsert(uint Base, uint Insert, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
  return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint2 spvBitfieldInsert(uint2 Base, uint2 Insert, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
  return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint3 spvBitfieldInsert(uint3 Base, uint3 Insert, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
  return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint4 spvBitfieldInsert(uint4 Base, uint4 Insert, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
  return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint spvBitfieldUExtract(uint Base, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
  return (Base >> Offset) & Mask;
}

uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
  return (Base >> Offset) & Mask;
}

uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
  return (Base >> Offset) & Mask;
}

uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count) {
  uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
  return (Base >> Offset) & Mask;
}

int spvBitfieldSExtract(int Base, int Offset, int Count) {
  int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
  int Masked = (Base >> Offset) & Mask;
  int ExtendShift = (32 - Count) & 31;
  return (Masked << ExtendShift) >> ExtendShift;
}

int2 spvBitfieldSExtract(int2 Base, int Offset, int Count) {
  int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
  int2 Masked = (Base >> Offset) & Mask;
  int ExtendShift = (32 - Count) & 31;
  return (Masked << ExtendShift) >> ExtendShift;
}

int3 spvBitfieldSExtract(int3 Base, int Offset, int Count) {
  int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
  int3 Masked = (Base >> Offset) & Mask;
  int ExtendShift = (32 - Count) & 31;
  return (Masked << ExtendShift) >> ExtendShift;
}

int4 spvBitfieldSExtract(int4 Base, int Offset, int Count) {
  int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
  int4 Masked = (Base >> Offset) & Mask;
  int ExtendShift = (32 - Count) & 31;
  return (Masked << ExtendShift) >> ExtendShift;
}

int cvt_f32_i32(float v) {
  return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}

float dp3_f32(float3 a, float3 b) {
  precise float _76 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _76));
}

void comp_main() {
  uint _111 = spvBitfieldUExtract(gl_LocalInvocationID.x, 1u, 3u) + (gl_WorkGroupID.x * 16u);
  uint _112 = spvBitfieldInsert(gl_LocalInvocationID.x >> 3u, gl_LocalInvocationID.x, 0u, 1u) + (gl_WorkGroupID.y * 16u);
  float _125 = mad(float(_111), CB0_m0.x, CB0_m1.x);
  float _126 = mad(float(_112), CB0_m0.y, CB0_m1.y);
  float _127 = floor(_125);
  float _128 = floor(_126);
  float _129 = _125 - _127;
  float _130 = _126 - _128;
  int _131 = cvt_f32_i32(_127);
  int _132 = cvt_f32_i32(_128);
  uint _133 = uint(_131);
  uint _134 = uint(_132);
  uint _136 = uint(_131 - 1);
  uint _138 = uint(_132 - 1);
  float4 _141 = T0.Load(int3(uint2(_133, _138), 0u));
  float _143 = _141.y;
  float4 _146 = T0.Load(int3(uint2(_136, _134), 0u));
  float _148 = _146.y;
  float4 _151 = T0.Load(int3(uint2(_133, _134), 0u));
  float _153 = _151.y;
  uint _156 = uint(_131 + 1);
  float4 _158 = T0.Load(int3(uint2(_156, _138), 0u));
  float _160 = _158.y;
  float4 _163 = T0.Load(int3(uint2(_156, _134), 0u));
  float _165 = _163.y;
  uint _168 = uint(_132 + 1);
  uint _170 = uint(_131 + 2);
  float4 _172 = T0.Load(int3(uint2(_170, _134), 0u));
  float _174 = _172.y;
  float4 _177 = T0.Load(int3(uint2(_136, _168), 0u));
  float _179 = _177.y;
  uint _182 = uint(_132 + 2);
  float4 _184 = T0.Load(int3(uint2(_133, _168), 0u));
  float _186 = _184.y;
  float4 _189 = T0.Load(int3(uint2(_133, _182), 0u));
  float _191 = _189.y;
  float4 _194 = T0.Load(int3(uint2(_156, _168), 0u));
  float _196 = _194.y;
  float4 _199 = T0.Load(int3(uint2(_170, _168), 0u));
  float _201 = _199.y;
  float4 _204 = T0.Load(int3(uint2(_156, _182), 0u));
  float _206 = _204.y;
  float _211 = min(min(_143, min(_148, _153)), min(_165, _186));
  float _215 = max(max(_143, max(_148, _153)), max(_165, _186));
  float _219 = min(min(_160, min(_153, _165)), min(_174, _196));
  float _223 = max(max(_160, max(_153, _165)), max(_174, _196));
  float _227 = min(min(_153, min(_179, _186)), min(_191, _196));
  float _231 = max(max(_153, max(_179, _186)), max(_191, _196));
  float _235 = min(min(_165, min(_186, _196)), min(_201, _206));
  float _239 = max(max(_165, max(_186, _196)), max(_201, _206));
  float _293 = (_128 - _126) + 1.0f;
  float _294 = (_127 - _125) + 1.0f;
  float _295 = _293 * _294;
  float _296 = _129 * _293;
  float _297 = _294 * _130;
  float _298 = _129 * _130;
  float _303 = asfloat(2129690299u - asuint((_215 - _211) + 0.03125f));
  float _309 = asfloat(2129690299u - asuint((_223 - _219) + 0.03125f));
  float _315 = asfloat(2129690299u - asuint((_231 - _227) + 0.03125f));
  float _321 = asfloat(2129690299u - asuint((_239 - _235) + 0.03125f));
  float _323 = (asfloat((asuint(clamp(min(_211, 1.0f - _215) * asfloat(2129690299u - asuint(_215)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_295 * _303);
  float _324 = (asfloat((asuint(clamp(min(_219, 1.0f - _223) * asfloat(2129690299u - asuint(_223)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_296 * _309);
  float _325 = (asfloat((asuint(clamp(min(_227, 1.0f - _231) * asfloat(2129690299u - asuint(_231)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_315 * _297);
  float _326 = _324 + _325;
  float _327 = mad(_295, _303, _326);
  float _328 = (asfloat((asuint(clamp(min(_235, 1.0f - _239) * asfloat(2129690299u - asuint(_239)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_298 * _321);
  float _329 = _323 + _328;
  float _330 = mad(_296, _309, _329);
  float _331 = mad(_315, _297, _329);
  float _332 = mad(_298, _321, _326);
  float _340 = _332 + (_331 + (_330 + (_327 + mad(_328, 2.0f, mad(_325, 2.0f, mad(_323, 2.0f, _324 + _324))))));
  float _343 = asfloat(2129764351u - asuint(_340));
  float _346 = _343 * mad(-_340, _343, 2.0f);
  float _389 = clamp(_346 * mad(_194.x, _332, mad(_184.x, _331, mad(_163.x, _330, mad(_151.x, _327, mad(_204.x, _328, mad(_199.x, _328, mad(_189.x, _325, mad(_177.x, _325, mad(_172.x, _324, mad(_158.x, _324, (_146.x * _323) + (_141.x * _323))))))))))), 0.0f, 1.0f);
  float _390 = clamp(_346 * mad(_196, _332, mad(_186, _331, mad(_165, _330, mad(_153, _327, mad(_206, _328, mad(_201, _328, mad(_191, _325, mad(_179, _325, mad(_174, _324, mad(_160, _324, (_143 * _323) + (_148 * _323))))))))))), 0.0f, 1.0f);
  float _391 = clamp(_346 * mad(_194.z, _332, mad(_184.z, _331, mad(_163.z, _330, mad(_151.z, _327, mad(_204.z, _328, mad(_199.z, _328, mad(_189.z, _325, mad(_177.z, _325, mad(_172.z, _324, mad(_158.z, _324, (_141.z * _323) + (_146.z * _323))))))))))), 0.0f, 1.0f);
  uint _395 = uint(cvt_f32_i32(CB0_m3.w));
  bool _396 = _395 == 1u;
  float _473;
  float _474;
  float _475;
  if (_396) {
    float _405 = log2(_389) * CB0_m3.x;
    float _406 = CB0_m3.x * log2(_390);
    float _407 = CB0_m3.x * log2(_391);
    float _408 = exp2(_405);
    float _409 = exp2(_406);
    float _410 = exp2(_407);
    _473 = (_410 < 0.00310000008903443813323974609375f) ? (_410 * 12.9200000762939453125f) : mad(exp2(_407 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _474 = (_409 < 0.00310000008903443813323974609375f) ? (_409 * 12.9200000762939453125f) : mad(exp2(_406 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _475 = (_408 < 0.00310000008903443813323974609375f) ? (_408 * 12.9200000762939453125f) : mad(exp2(_405 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _470;
    float _471;
    float _472;
    if (_395 == 2u) {
      float3 _432 = float3(_389, _390, _391);
      float _449 = exp2(log2(dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _432) * CB0_m3.y) * CB0_m3.x);
      float _450 = exp2(CB0_m3.x * log2(dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _432) * CB0_m3.y));
      float _451 = exp2(CB0_m3.x * log2(dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _432) * CB0_m3.y));
      _470 = exp2(log2(mad(_451, 18.8515625f, 0.8359375f) / mad(_451, 18.6875f, 1.0f)) * 78.84375f);
      _471 = exp2(log2(mad(_450, 18.8515625f, 0.8359375f) / mad(_450, 18.6875f, 1.0f)) * 78.84375f);
      _472 = exp2(log2(mad(_449, 18.8515625f, 0.8359375f) / mad(_449, 18.6875f, 1.0f)) * 78.84375f);
    } else {
      _470 = _391;
      _471 = _390;
      _472 = _389;
    }
    _473 = _470;
    _474 = _471;
    _475 = _472;
  }
  U0[uint2(_111, _112)] = float4(_475, _474, _473, 1.0f);
  uint _479 = _111 + 8u;
  uint _480 = _112 + 8u;
  float _483 = mad(float(_479), CB0_m0.x, CB0_m1.x);
  float _484 = mad(float(_480), CB0_m0.y, CB0_m1.y);
  float _485 = floor(_483);
  float _486 = floor(_484);
  float _487 = _483 - _485;
  float _488 = _484 - _486;
  int _489 = cvt_f32_i32(_485);
  uint _490 = uint(_489);
  uint _492 = uint(_489 - 1);
  float4 _494 = T0.Load(int3(uint2(_490, _138), 0u));
  float _496 = _494.y;
  float4 _499 = T0.Load(int3(uint2(_492, _134), 0u));
  float _501 = _499.y;
  float4 _504 = T0.Load(int3(uint2(_490, _134), 0u));
  float _506 = _504.y;
  uint _509 = uint(_489 + 1);
  float4 _511 = T0.Load(int3(uint2(_509, _138), 0u));
  float _513 = _511.y;
  float4 _516 = T0.Load(int3(uint2(_509, _134), 0u));
  float _518 = _516.y;
  uint _521 = uint(_489 + 2);
  float4 _523 = T0.Load(int3(uint2(_521, _134), 0u));
  float _525 = _523.y;
  float4 _528 = T0.Load(int3(uint2(_492, _168), 0u));
  float _530 = _528.y;
  float4 _533 = T0.Load(int3(uint2(_490, _168), 0u));
  float _535 = _533.y;
  float4 _538 = T0.Load(int3(uint2(_490, _182), 0u));
  float _540 = _538.y;
  float4 _543 = T0.Load(int3(uint2(_509, _168), 0u));
  float _545 = _543.y;
  float4 _548 = T0.Load(int3(uint2(_521, _168), 0u));
  float _550 = _548.y;
  float4 _553 = T0.Load(int3(uint2(_509, _182), 0u));
  float _555 = _553.y;
  float _560 = min(min(_496, min(_501, _506)), min(_518, _535));
  float _564 = max(max(_496, max(_501, _506)), max(_518, _535));
  float _568 = min(min(_513, min(_506, _518)), min(_525, _545));
  float _572 = max(max(_513, max(_506, _518)), max(_525, _545));
  float _576 = min(min(_506, min(_530, _535)), min(_540, _545));
  float _580 = max(max(_506, max(_530, _535)), max(_540, _545));
  float _584 = min(min(_518, min(_535, _545)), min(_550, _555));
  float _588 = max(max(_518, max(_535, _545)), max(_550, _555));
  float _639 = (_485 - _483) + 1.0f;
  float _640 = (_486 - _484) + 1.0f;
  float _641 = _293 * _639;
  float _642 = _640 * _639;
  float _643 = _293 * _487;
  float _644 = _130 * _639;
  float _645 = _487 * _640;
  float _646 = _639 * _488;
  float _647 = _487 * _130;
  float _648 = _487 * _488;
  float _653 = asfloat(2129690299u - asuint((_564 - _560) + 0.03125f));
  float _659 = asfloat(2129690299u - asuint((_572 - _568) + 0.03125f));
  float _665 = asfloat(2129690299u - asuint((_580 - _576) + 0.03125f));
  float _671 = asfloat(2129690299u - asuint((_588 - _584) + 0.03125f));
  float _673 = (asfloat((asuint(clamp(min(_560, 1.0f - _564) * asfloat(2129690299u - asuint(_564)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_641 * _653);
  float _674 = (asfloat((asuint(clamp(min(_568, 1.0f - _572) * asfloat(2129690299u - asuint(_572)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_643 * _659);
  float _675 = (asfloat((asuint(clamp(min(_576, 1.0f - _580) * asfloat(2129690299u - asuint(_580)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_665 * _644);
  float _676 = _674 + _675;
  float _677 = mad(_641, _653, _676);
  float _678 = (asfloat((asuint(clamp(min(_584, 1.0f - _588) * asfloat(2129690299u - asuint(_588)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_647 * _671);
  float _679 = _673 + _678;
  float _680 = mad(_643, _659, _679);
  float _681 = mad(_665, _644, _679);
  float _682 = mad(_647, _671, _676);
  float _690 = _682 + (_681 + (_680 + (_677 + mad(_678, 2.0f, mad(_675, 2.0f, mad(_673, 2.0f, _674 + _674))))));
  float _693 = asfloat(2129764351u - asuint(_690));
  float _696 = _693 * mad(-_690, _693, 2.0f);
  float _739 = clamp(_696 * mad(_543.x, _682, mad(_533.x, _681, mad(_516.x, _680, mad(_504.x, _677, mad(_553.x, _678, mad(_548.x, _678, mad(_538.x, _675, mad(_528.x, _675, mad(_523.x, _674, mad(_511.x, _674, (_499.x * _673) + (_494.x * _673))))))))))), 0.0f, 1.0f);
  float _740 = clamp(_696 * mad(_545, _682, mad(_535, _681, mad(_518, _680, mad(_506, _677, mad(_555, _678, mad(_550, _678, mad(_540, _675, mad(_530, _675, mad(_525, _674, mad(_513, _674, (_496 * _673) + (_501 * _673))))))))))), 0.0f, 1.0f);
  float _741 = clamp(_696 * mad(_543.z, _682, mad(_533.z, _681, mad(_516.z, _680, mad(_504.z, _677, mad(_553.z, _678, mad(_548.z, _678, mad(_538.z, _675, mad(_528.z, _675, mad(_523.z, _674, mad(_511.z, _674, (_494.z * _673) + (_499.z * _673))))))))))), 0.0f, 1.0f);
  float _818;
  float _819;
  float _820;
  if (_396) {
    float _750 = log2(_739) * CB0_m3.x;
    float _751 = log2(_740) * CB0_m3.x;
    float _752 = log2(_741) * CB0_m3.x;
    float _753 = exp2(_750);
    float _754 = exp2(_751);
    float _755 = exp2(_752);
    _818 = (_755 < 0.00310000008903443813323974609375f) ? (_755 * 12.9200000762939453125f) : mad(exp2(_752 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _819 = (_754 < 0.00310000008903443813323974609375f) ? (_754 * 12.9200000762939453125f) : mad(exp2(_751 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _820 = (_753 < 0.00310000008903443813323974609375f) ? (_753 * 12.9200000762939453125f) : mad(exp2(_750 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _815;
    float _816;
    float _817;
    if (_395 == 2u) {
      float3 _777 = float3(_739, _740, _741);
#if 1
      FinalizeOutput(_777, CB0_m3.x, CB0_m3.y, _815, _816, _817, true);
#else
      float _794 = exp2(log2(dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _777) * CB0_m3.y) * CB0_m3.x);
      float _795 = exp2(log2(dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _777) * CB0_m3.y) * CB0_m3.x);
      float _796 = exp2(log2(dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _777) * CB0_m3.y) * CB0_m3.x);
      _815 = exp2(log2(mad(_796, 18.8515625f, 0.8359375f) / mad(_796, 18.6875f, 1.0f)) * 78.84375f);
      _816 = exp2(log2(mad(_795, 18.8515625f, 0.8359375f) / mad(_795, 18.6875f, 1.0f)) * 78.84375f);
      _817 = exp2(log2(mad(_794, 18.8515625f, 0.8359375f) / mad(_794, 18.6875f, 1.0f)) * 78.84375f);
#endif
    } else {
      _815 = _741;
      _816 = _740;
      _817 = _739;
    }
    _818 = _815;
    _819 = _816;
    _820 = _817;
  }
  U0[uint2(_479, _112)] = float4(_820, _819, _818, 1.0f);
  int _823 = cvt_f32_i32(_486);
  uint _824 = uint(_823);
  uint _826 = uint(_823 - 1);
  float4 _828 = T0.Load(int3(uint2(_490, _826), 0u));
  float _830 = _828.y;
  float4 _833 = T0.Load(int3(uint2(_492, _824), 0u));
  float _835 = _833.y;
  float4 _838 = T0.Load(int3(uint2(_490, _824), 0u));
  float _840 = _838.y;
  float4 _843 = T0.Load(int3(uint2(_509, _826), 0u));
  float _845 = _843.y;
  float4 _848 = T0.Load(int3(uint2(_509, _824), 0u));
  float _850 = _848.y;
  uint _853 = uint(_823 + 1);
  float4 _855 = T0.Load(int3(uint2(_521, _824), 0u));
  float _857 = _855.y;
  float4 _860 = T0.Load(int3(uint2(_492, _853), 0u));
  float _862 = _860.y;
  uint _865 = uint(_823 + 2);
  float4 _867 = T0.Load(int3(uint2(_490, _853), 0u));
  float _869 = _867.y;
  float4 _872 = T0.Load(int3(uint2(_490, _865), 0u));
  float _874 = _872.y;
  float4 _877 = T0.Load(int3(uint2(_509, _853), 0u));
  float _879 = _877.y;
  float4 _882 = T0.Load(int3(uint2(_521, _853), 0u));
  float _884 = _882.y;
  float4 _887 = T0.Load(int3(uint2(_509, _865), 0u));
  float _889 = _887.y;
  float _894 = min(min(_830, min(_835, _840)), min(_850, _869));
  float _898 = max(max(_830, max(_835, _840)), max(_850, _869));
  float _902 = min(min(_845, min(_840, _850)), min(_857, _879));
  float _906 = max(max(_845, max(_840, _850)), max(_857, _879));
  float _910 = min(min(_840, min(_862, _869)), min(_874, _879));
  float _914 = max(max(_840, max(_862, _869)), max(_874, _879));
  float _918 = min(min(_850, min(_869, _879)), min(_884, _889));
  float _922 = max(max(_850, max(_869, _879)), max(_884, _889));
  float _975 = asfloat(2129690299u - asuint((_898 - _894) + 0.03125f));
  float _981 = asfloat(2129690299u - asuint((_906 - _902) + 0.03125f));
  float _987 = asfloat(2129690299u - asuint((_914 - _910) + 0.03125f));
  float _993 = asfloat(2129690299u - asuint((_922 - _918) + 0.03125f));
  float _995 = (asfloat((asuint(clamp(min(_894, 1.0f - _898) * asfloat(2129690299u - asuint(_898)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_975 * _642);
  float _996 = (asfloat((asuint(clamp(min(_902, 1.0f - _906) * asfloat(2129690299u - asuint(_906)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_981 * _645);
  float _997 = (asfloat((asuint(clamp(min(_910, 1.0f - _914) * asfloat(2129690299u - asuint(_914)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_987 * _646);
  float _998 = _996 + _997;
  float _999 = mad(_975, _642, _998);
  float _1000 = (asfloat((asuint(clamp(min(_918, 1.0f - _922) * asfloat(2129690299u - asuint(_922)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_993 * _648);
  float _1001 = _995 + _1000;
  float _1002 = mad(_981, _645, _1001);
  float _1003 = mad(_987, _646, _1001);
  float _1004 = mad(_993, _648, _998);
  float _1012 = _1004 + (_1003 + (_1002 + (_999 + mad(_1000, 2.0f, mad(_997, 2.0f, mad(_995, 2.0f, _996 + _996))))));
  float _1015 = asfloat(2129764351u - asuint(_1012));
  float _1018 = _1015 * mad(-_1012, _1015, 2.0f);
  float _1061 = clamp(_1018 * mad(_877.x, _1004, mad(_867.x, _1003, mad(_848.x, _1002, mad(_838.x, _999, mad(_887.x, _1000, mad(_882.x, _1000, mad(_872.x, _997, mad(_860.x, _997, mad(_855.x, _996, mad(_843.x, _996, (_833.x * _995) + (_828.x * _995))))))))))), 0.0f, 1.0f);
  float _1062 = clamp(_1018 * mad(_879, _1004, mad(_869, _1003, mad(_850, _1002, mad(_840, _999, mad(_889, _1000, mad(_884, _1000, mad(_874, _997, mad(_862, _997, mad(_857, _996, mad(_845, _996, (_830 * _995) + (_835 * _995))))))))))), 0.0f, 1.0f);
  float _1063 = clamp(_1018 * mad(_877.z, _1004, mad(_867.z, _1003, mad(_848.z, _1002, mad(_838.z, _999, mad(_887.z, _1000, mad(_882.z, _1000, mad(_872.z, _997, mad(_860.z, _997, mad(_855.z, _996, mad(_843.z, _996, (_828.z * _995) + (_833.z * _995))))))))))), 0.0f, 1.0f);
  float _1140;
  float _1141;
  float _1142;
  if (_396) {
    float _1072 = log2(_1061) * CB0_m3.x;
    float _1073 = CB0_m3.x * log2(_1062);
    float _1074 = CB0_m3.x * log2(_1063);
    float _1075 = exp2(_1072);
    float _1076 = exp2(_1073);
    float _1077 = exp2(_1074);
    _1140 = (_1077 < 0.00310000008903443813323974609375f) ? (_1077 * 12.9200000762939453125f) : mad(exp2(_1074 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1141 = (_1076 < 0.00310000008903443813323974609375f) ? (_1076 * 12.9200000762939453125f) : mad(exp2(_1073 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1142 = (_1075 < 0.00310000008903443813323974609375f) ? (_1075 * 12.9200000762939453125f) : mad(exp2(_1072 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _1137;
    float _1138;
    float _1139;
    if (_395 == 2u) {
      float3 _1099 = float3(_1061, _1062, _1063);
#if 1
      FinalizeOutput(_1099, CB0_m3.x, CB0_m3.y, _1137, _1138, _1139, true);
#else
      float _1116 = exp2(log2(dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _1099) * CB0_m3.y) * CB0_m3.x);
      float _1117 = exp2(log2(dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _1099) * CB0_m3.y) * CB0_m3.x);
      float _1118 = exp2(log2(dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _1099) * CB0_m3.y) * CB0_m3.x);
      _1137 = exp2(log2(mad(_1118, 18.8515625f, 0.8359375f) / mad(_1118, 18.6875f, 1.0f)) * 78.84375f);
      _1138 = exp2(log2(mad(_1117, 18.8515625f, 0.8359375f) / mad(_1117, 18.6875f, 1.0f)) * 78.84375f);
      _1139 = exp2(log2(mad(_1116, 18.8515625f, 0.8359375f) / mad(_1116, 18.6875f, 1.0f)) * 78.84375f);
#endif
    } else {
      _1137 = _1063;
      _1138 = _1062;
      _1139 = _1061;
    }
    _1140 = _1137;
    _1141 = _1138;
    _1142 = _1139;
  }
  U0[uint2(_479, _480)] = float4(_1142, _1141, _1140, 1.0f);
  uint _1145 = _479 - 8u;
  float _1147 = mad(float(_1145), CB0_m0.x, CB0_m1.x);
  float _1148 = floor(_1147);
  float _1149 = _1147 - _1148;
  int _1150 = cvt_f32_i32(_1148);
  uint _1151 = uint(_1150);
  uint _1153 = uint(_1150 - 1);
  float4 _1155 = T0.Load(int3(uint2(_1151, _826), 0u));
  float _1157 = _1155.y;
  float4 _1160 = T0.Load(int3(uint2(_1153, _824), 0u));
  float _1162 = _1160.y;
  float4 _1165 = T0.Load(int3(uint2(_1151, _824), 0u));
  float _1167 = _1165.y;
  uint _1170 = uint(_1150 + 1);
  float4 _1172 = T0.Load(int3(uint2(_1170, _826), 0u));
  float _1174 = _1172.y;
  float4 _1177 = T0.Load(int3(uint2(_1170, _824), 0u));
  float _1179 = _1177.y;
  uint _1182 = uint(_1150 + 2);
  float4 _1184 = T0.Load(int3(uint2(_1182, _824), 0u));
  float _1186 = _1184.y;
  float4 _1189 = T0.Load(int3(uint2(_1153, _853), 0u));
  float _1191 = _1189.y;
  float4 _1194 = T0.Load(int3(uint2(_1151, _853), 0u));
  float _1196 = _1194.y;
  float4 _1199 = T0.Load(int3(uint2(_1151, _865), 0u));
  float _1201 = _1199.y;
  float4 _1204 = T0.Load(int3(uint2(_1170, _853), 0u));
  float _1206 = _1204.y;
  float4 _1209 = T0.Load(int3(uint2(_1182, _853), 0u));
  float _1211 = _1209.y;
  float4 _1214 = T0.Load(int3(uint2(_1170, _865), 0u));
  float _1216 = _1214.y;
  float _1221 = min(min(_1157, min(_1162, _1167)), min(_1179, _1196));
  float _1225 = max(max(_1157, max(_1162, _1167)), max(_1179, _1196));
  float _1229 = min(min(_1174, min(_1167, _1179)), min(_1186, _1206));
  float _1233 = max(max(_1174, max(_1167, _1179)), max(_1186, _1206));
  float _1237 = min(min(_1167, min(_1191, _1196)), min(_1201, _1206));
  float _1241 = max(max(_1167, max(_1191, _1196)), max(_1201, _1206));
  float _1245 = min(min(_1179, min(_1196, _1206)), min(_1211, _1216));
  float _1249 = max(max(_1179, max(_1196, _1206)), max(_1211, _1216));
  float _1299 = (_1148 - _1147) + 1.0f;
  float _1300 = _1299 * _640;
  float _1301 = _1149 * _640;
  float _1302 = _1299 * _488;
  float _1303 = _1149 * _488;
  float _1308 = asfloat(2129690299u - asuint((_1225 - _1221) + 0.03125f));
  float _1314 = asfloat(2129690299u - asuint((_1233 - _1229) + 0.03125f));
  float _1320 = asfloat(2129690299u - asuint((_1241 - _1237) + 0.03125f));
  float _1326 = asfloat(2129690299u - asuint((_1249 - _1245) + 0.03125f));
  float _1328 = (asfloat((asuint(clamp(min(_1221, 1.0f - _1225) * asfloat(2129690299u - asuint(_1225)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_1300 * _1308);
  float _1329 = (asfloat((asuint(clamp(min(_1229, 1.0f - _1233) * asfloat(2129690299u - asuint(_1233)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_1301 * _1314);
  float _1330 = (asfloat((asuint(clamp(min(_1237, 1.0f - _1241) * asfloat(2129690299u - asuint(_1241)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_1302 * _1320);
  float _1331 = _1329 + _1330;
  float _1332 = mad(_1300, _1308, _1331);
  float _1333 = (asfloat((asuint(clamp(min(_1245, 1.0f - _1249) * asfloat(2129690299u - asuint(_1249)), 0.0f, 1.0f)) >> 1u) + 532432441u) * CB0_m2.x) * (_1303 * _1326);
  float _1334 = _1328 + _1333;
  float _1335 = mad(_1301, _1314, _1334);
  float _1336 = mad(_1302, _1320, _1334);
  float _1337 = mad(_1303, _1326, _1331);
  float _1345 = _1337 + (_1336 + (_1335 + (_1332 + mad(_1333, 2.0f, mad(_1330, 2.0f, mad(_1328, 2.0f, _1329 + _1329))))));
  float _1348 = asfloat(2129764351u - asuint(_1345));
  float _1351 = _1348 * mad(-_1345, _1348, 2.0f);
  float _1394 = clamp(_1351 * mad(_1204.x, _1337, mad(_1194.x, _1336, mad(_1177.x, _1335, mad(_1165.x, _1332, mad(_1214.x, _1333, mad(_1209.x, _1333, mad(_1199.x, _1330, mad(_1189.x, _1330, mad(_1184.x, _1329, mad(_1172.x, _1329, (_1160.x * _1328) + (_1155.x * _1328))))))))))), 0.0f, 1.0f);
  float _1395 = clamp(mad(_1206, _1337, mad(_1196, _1336, mad(_1179, _1335, mad(_1167, _1332, mad(_1216, _1333, mad(_1211, _1333, mad(_1201, _1330, mad(_1191, _1330, mad(_1186, _1329, mad(_1174, _1329, (_1157 * _1328) + (_1162 * _1328))))))))))) * _1351, 0.0f, 1.0f);
  float _1396 = clamp(mad(_1204.z, _1337, mad(_1194.z, _1336, mad(_1177.z, _1335, mad(_1165.z, _1332, mad(_1214.z, _1333, mad(_1209.z, _1333, mad(_1199.z, _1330, mad(_1189.z, _1330, mad(_1184.z, _1329, mad(_1172.z, _1329, (_1155.z * _1328) + (_1160.z * _1328))))))))))) * _1351, 0.0f, 1.0f);
  float _1473;
  float _1474;
  float _1475;
  if (_396) {
    float _1405 = CB0_m3.x * log2(_1394);
    float _1406 = CB0_m3.x * log2(_1395);
    float _1407 = CB0_m3.x * log2(_1396);
    float _1408 = exp2(_1405);
    float _1409 = exp2(_1406);
    float _1410 = exp2(_1407);
    _1473 = (_1410 < 0.00310000008903443813323974609375f) ? (_1410 * 12.9200000762939453125f) : mad(exp2(_1407 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1474 = (_1409 < 0.00310000008903443813323974609375f) ? (_1409 * 12.9200000762939453125f) : mad(exp2(_1406 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _1475 = (_1408 < 0.00310000008903443813323974609375f) ? (_1408 * 12.9200000762939453125f) : mad(exp2(_1405 * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  } else {
    float _1470;
    float _1471;
    float _1472;
    if (_395 == 2u) {
      float3 _1432 = float3(_1394, _1395, _1396);
#if 1
      FinalizeOutput(_1432, CB0_m3.x, CB0_m3.y, _1470, _1471, _1472, true);
#else
      float _1449 = exp2(CB0_m3.x * log2(dp3_f32(float3(0.627403914928436279296875f, 0.3292830288410186767578125f, 0.0433130674064159393310546875f), _1432) * CB0_m3.y));
      float _1450 = exp2(log2(dp3_f32(float3(0.069097287952899932861328125f, 0.9195404052734375f, 0.01136231608688831329345703125f), _1432) * CB0_m3.y) * CB0_m3.x);
      float _1451 = exp2(log2(CB0_m3.y * dp3_f32(float3(0.01639143936336040496826171875f, 0.08801330626010894775390625f, 0.895595252513885498046875f), _1432)) * CB0_m3.x);
      _1470 = exp2(log2(mad(_1451, 18.8515625f, 0.8359375f) / mad(_1451, 18.6875f, 1.0f)) * 78.84375f);
      _1471 = exp2(log2(mad(_1450, 18.8515625f, 0.8359375f) / mad(_1450, 18.6875f, 1.0f)) * 78.84375f);
      _1472 = exp2(log2(mad(_1449, 18.8515625f, 0.8359375f) / mad(_1449, 18.6875f, 1.0f)) * 78.84375f);
#endif
    } else {
      _1470 = _1396;
      _1471 = _1395;
      _1472 = _1394;
    }
    _1473 = _1470;
    _1474 = _1471;
    _1475 = _1472;
  }
  U0[uint2(_1145, _480)] = float4(_1475, _1474, _1473, 1.0f);
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
