#include "../common.hlsli"

cbuffer _25_27 : register(b0, space8) {
  float4 _27_m0[4] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<float4> _12 : register(t0, space8);
Texture2D<float4> _13 : register(t1, space8);
Texture2D<float4> _14 : register(t2, space8);
Texture2D<float4> _15 : register(t3, space8);
RWTexture2D<float4> _18 : register(u0, space8);
RWTexture2D<float4> _19 : register(u1, space8);
RWTexture2D<float4> _20 : register(u2, space8);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

void comp_main() {
  float4 _60 = _12.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
  float _63 = _60.x;
  float _64 = _60.y;
  float _65 = _60.z;
  uint _66 = uint(int(_27_m0[3u].w));
  float _148;
  float _150;
  float _152;
  if (_66 == 1u) {
    float _222;
    if (_63 < 0.040449999272823333740234375f) {
      _222 = _63 * 0.077399380505084991455078125f;
    } else {
      _222 = exp2(log2(abs((_63 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _231;
    if (_64 < 0.040449999272823333740234375f) {
      _231 = _64 * 0.077399380505084991455078125f;
    } else {
      _231 = exp2(log2(abs((_64 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _240;
    if (_65 < 0.040449999272823333740234375f) {
      _240 = _65 * 0.077399380505084991455078125f;
    } else {
      _240 = exp2(log2(abs((_65 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _241 = 1.0f / _27_m0[3u].x;
    _148 = exp2(log2(abs(_222)) * _241);
    _150 = exp2(log2(abs(_231)) * _241);
    _152 = exp2(log2(abs(_240)) * _241);
  } else {
    float frontier_phi_6_2_ladder;
    float frontier_phi_6_2_ladder_1;
    float frontier_phi_6_2_ladder_2;
    if (_66 == 2u) {
#if 1
      BT709FromPQ(
          _63, _64, _65,
          _27_m0[3u].x, _27_m0[3u].y,
          frontier_phi_6_2_ladder, frontier_phi_6_2_ladder_1, frontier_phi_6_2_ladder_2);
#else
      float _94 = exp2(log2(abs(_63)) * 0.0126833133399486541748046875f);
      float _95 = exp2(log2(abs(_64)) * 0.0126833133399486541748046875f);
      float _96 = exp2(log2(abs(_65)) * 0.0126833133399486541748046875f);
      float _112 = 1.0f / _27_m0[3u].x;
      float _126 = 1.0f / _27_m0[3u].y;
      float _127 = _126 * exp2(log2(abs((_94 + (-0.8359375f)) / (18.8515625f - (_94 * 18.6875f)))) * _112);
      float _128 = _126 * exp2(log2(abs((_95 + (-0.8359375f)) / (18.8515625f - (_95 * 18.6875f)))) * _112);
      float _129 = _126 * exp2(log2(abs((_96 + (-0.8359375f)) / (18.8515625f - (_96 * 18.6875f)))) * _112);
      frontier_phi_6_2_ladder = mad(-0.0728498995304107666015625f, _129, mad(-0.5876410007476806640625f, _128, _127 * 1.6604900360107421875f));
      frontier_phi_6_2_ladder_1 = mad(-0.008349419571459293365478515625f, _129, mad(1.1328999996185302734375f, _128, _127 * (-0.12454999983310699462890625f)));
      frontier_phi_6_2_ladder_2 = mad(1.11872994899749755859375f, _129, mad(-0.100579001009464263916015625f, _128, _127 * (-0.01815080083906650543212890625f)));
#endif
    } else {
      frontier_phi_6_2_ladder = _63;
      frontier_phi_6_2_ladder_1 = _64;
      frontier_phi_6_2_ladder_2 = _65;
    }
    _148 = frontier_phi_6_2_ladder;
    _150 = frontier_phi_6_2_ladder_1;
    _152 = frontier_phi_6_2_ladder_2;
  }
  _18[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(_148, _150, _152, _148);
  float _167 = (_27_m0[0u].w == 0.0f) ? 0.0f : (exp2(log2(_13.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u)).x) * _27_m0[1u].x) * _27_m0[1u].y);
  uint _169_dummy_parameter;
  uint2 _169 = spvTextureSize(_14, 0u, _169_dummy_parameter);
  float4 _175 = _15.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
  float _191 = ((float(gl_GlobalInvocationID.x) + 0.5f) + _27_m0[2u].z) - ((_27_m0[2u].x * 0.5f) * _175.x);
  float _194 = ((float(gl_GlobalInvocationID.y) + 0.5f) + _27_m0[2u].w) + ((_27_m0[2u].y * 0.5f) * _175.y);
  // _19[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = max(_14.SampleLevel(_8[23u], float2(max(min(_191, 0.5f), min(max(_191, 0.5f), _27_m0[2u].x + (-0.5f))) / float(int(_169.x)), max(min(_194, 0.5f), min(max(_194, 0.5f), _27_m0[2u].y + (-0.5f))) / float(int(_169.y))), 0.0f).x, _167).xxxx;
  _19[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = max(_14.SampleLevel((SamplerState)ResourceDescriptorHeap[23], float2(max(min(_191, 0.5f), min(max(_191, 0.5f), _27_m0[2u].x + (-0.5f))) / float(int(_169.x)), max(min(_194, 0.5f), min(max(_194, 0.5f), _27_m0[2u].y + (-0.5f))) / float(int(_169.y))), 0.0f).x, _167).xxxx;
  _20[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = _167.xxxx;
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
