#include "./shared.h"

cbuffer ConstBuf_constantsUBO : register(b0, space0) {
  float4 ConstBuf_constants_m0[15] : packoffset(c0);
};

// Texture2D<float4> _9[] : register(t0, space0);
// SamplerState _13[] : register(s0, space0);
// Texture3D<float4> _17[] : register(t0, space0);
// RWTexture2D<float4> _21[] : register(u0, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _39 = float(gl_GlobalInvocationID.x);
  float _40 = float(gl_GlobalInvocationID.y);
  float _50 = ConstBuf_constants_m0[14u].y * (_39 + 0.5f);
  float _51 = (_40 + 0.5f) * ConstBuf_constants_m0[14u].z;
  uint4 _59 = asuint(ConstBuf_constants_m0[13u]);
  uint texIndex = _59.y;  // uint _60 = _59.y;
  float _64 = ConstBuf_constants_m0[14u].y * _39;
  float _67 = ConstBuf_constants_m0[14u].z * (_40 + 1.0f);
  uint samplerIndex = _59.x;  // uint _68 = _59.x;

  Texture2D<float4> tex = ResourceDescriptorHeap[texIndex];    // _9[_60]
  SamplerState samp = ResourceDescriptorHeap[samplerIndex];    // _13[_68]
  float4 _75 = tex.SampleLevel(samp, float2(_64, _67), 0.0f);  // float4 _75 = _9[_60].SampleLevel(_13[_68], float2(_64, _67), 0.0f);

  uint lutIndex = asuint(ConstBuf_constants_m0[14u].x);
  Texture3D<float4> lut = ResourceDescriptorHeap[lutIndex];  // _17[asuint(ConstBuf_constants_m0[14u]).x]

  uint outputIndex = _59.w;
  RWTexture2D<float4> outTex = ResourceDescriptorHeap[outputIndex];

  float _78 = _75.x;
  float _97 = 1.0f / max(9.9999997473787516355514526367188e-06f, 4.0f - dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_78, _75.yz)));
  float _98 = (_78 * 4.0f) * _97;
  float _99 = (_75.y * 4.0f) * _97;
  float _100 = (_75.z * 4.0f) * _97;
  bool _106 = ConstBuf_constants_m0[2u].x != 0.0f;
  float _163;
  float _164;
  float _165;
  if (_106) {
    float _115 = 1.0f / ConstBuf_constants_m0[2u].y;
    float _116 = _115 * _98;
    float _117 = _115 * _99;
    float _118 = _115 * _100;
    float4 _136 = lut.SampleLevel(samp, float3(_50, _51, (ConstBuf_constants_m0[12u].x * log2(max(9.9999999747524270787835121154785e-07f, dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_116, _117, _118))) * 8.0f)) + ConstBuf_constants_m0[12u].y), 0.0f);
    float _146 = ((_136.x / max(9.9999997473787516355514526367188e-05f, _136.y)) + 2.4739310741424560546875f) - ConstBuf_constants_m0[2u].z;
    float _159 = exp2((-0.0f) - (ConstBuf_constants_m0[2u].z + (((_146 < 0.0f) ? ConstBuf_constants_m0[2u].w : ConstBuf_constants_m0[3u].x) * _146))) * 8.0f;
    _163 = _159 * _116;
    _164 = _159 * _117;
    _165 = _159 * _118;
  } else {
    _163 = _98;
    _164 = _99;
    _165 = _100;
  }
  float _166 = dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_163, _164, _165));
  float _170 = max(0.0f, _166 - ConstBuf_constants_m0[1u].x);
  float _174 = max(_166, 9.9999997473787516355514526367188e-06f);
  float _182 = ConstBuf_constants_m0[14u].y * (_39 + 1.0f);
  float _183 = ConstBuf_constants_m0[14u].z * _40;
  float4 _185 = tex.SampleLevel(samp, float2(_182, _183), 0.0f);
  float _187 = _185.x;
  float _199 = 1.0f / max(9.9999997473787516355514526367188e-06f, 4.0f - dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_187, _185.yz)));
  float _200 = (_187 * 4.0f) * _199;
  float _201 = (_185.y * 4.0f) * _199;
  float _202 = (_185.z * 4.0f) * _199;
  float _250;
  float _251;
  float _252;
  if (_106) {
    float _210 = 1.0f / ConstBuf_constants_m0[2u].y;
    float _211 = _210 * _200;
    float _212 = _210 * _201;
    float _213 = _210 * _202;
    float4 _227 = lut.SampleLevel(samp, float3(_50, _51, (ConstBuf_constants_m0[12u].x * log2(max(9.9999999747524270787835121154785e-07f, dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_211, _212, _213))) * 8.0f)) + ConstBuf_constants_m0[12u].y), 0.0f);
    float _235 = ((_227.x / max(9.9999997473787516355514526367188e-05f, _227.y)) + 2.4739310741424560546875f) - ConstBuf_constants_m0[2u].z;
    float _246 = exp2((-0.0f) - (ConstBuf_constants_m0[2u].z + (((_235 < 0.0f) ? ConstBuf_constants_m0[2u].w : ConstBuf_constants_m0[3u].x) * _235))) * 8.0f;
    _250 = _246 * _211;
    _251 = _246 * _212;
    _252 = _246 * _213;
  } else {
    _250 = _200;
    _251 = _201;
    _252 = _202;
  }
  float _253 = dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_250, _251, _252));
  float _257 = max(0.0f, _253 - ConstBuf_constants_m0[1u].x);
  float _261 = max(_253, 9.9999997473787516355514526367188e-06f);
  float4 _273 = tex.SampleLevel(samp, float2(_182, _67), 0.0f);
  float _275 = _273.x;
  float _287 = 1.0f / max(9.9999997473787516355514526367188e-06f, 4.0f - dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_275, _273.yz)));
  float _288 = (_275 * 4.0f) * _287;
  float _289 = (_273.y * 4.0f) * _287;
  float _290 = (_273.z * 4.0f) * _287;
  float _338;
  float _339;
  float _340;
  if (_106) {
    float _298 = 1.0f / ConstBuf_constants_m0[2u].y;
    float _299 = _298 * _288;
    float _300 = _298 * _289;
    float _301 = _298 * _290;
    float4 _315 = lut.SampleLevel(samp, float3(_50, _51, (ConstBuf_constants_m0[12u].x * log2(max(9.9999999747524270787835121154785e-07f, dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_299, _300, _301))) * 8.0f)) + ConstBuf_constants_m0[12u].y), 0.0f);
    float _323 = ((_315.x / max(9.9999997473787516355514526367188e-05f, _315.y)) + 2.4739310741424560546875f) - ConstBuf_constants_m0[2u].z;
    float _334 = exp2((-0.0f) - (ConstBuf_constants_m0[2u].z + (((_323 < 0.0f) ? ConstBuf_constants_m0[2u].w : ConstBuf_constants_m0[3u].x) * _323))) * 8.0f;
    _338 = _334 * _299;
    _339 = _334 * _300;
    _340 = _334 * _301;
  } else {
    _338 = _288;
    _339 = _289;
    _340 = _290;
  }
  float _341 = dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_338, _339, _340));
  float _345 = max(0.0f, _341 - ConstBuf_constants_m0[1u].x);
  float _349 = max(_341, 9.9999997473787516355514526367188e-06f);
  float4 _361 = tex.SampleLevel(samp, float2(_64, _183), 0.0f);
  float _363 = _361.x;
  float _375 = 1.0f / max(9.9999997473787516355514526367188e-06f, 4.0f - dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_363, _361.yz)));
  float _376 = (_363 * 4.0f) * _375;
  float _377 = (_361.y * 4.0f) * _375;
  float _378 = (_361.z * 4.0f) * _375;
  float _426;
  float _427;
  float _428;
  if (_106) {
    float _386 = 1.0f / ConstBuf_constants_m0[2u].y;
    float _387 = _386 * _376;
    float _388 = _386 * _377;
    float _389 = _386 * _378;
    float4 _403 = lut.SampleLevel(samp, float3(_50, _51, (ConstBuf_constants_m0[12u].x * log2(max(9.9999999747524270787835121154785e-07f, dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_387, _388, _389))) * 8.0f)) + ConstBuf_constants_m0[12u].y), 0.0f);
    float _411 = ((_403.x / max(9.9999997473787516355514526367188e-05f, _403.y)) + 2.4739310741424560546875f) - ConstBuf_constants_m0[2u].z;
    float _422 = exp2((-0.0f) - (ConstBuf_constants_m0[2u].z + (((_411 < 0.0f) ? ConstBuf_constants_m0[2u].w : ConstBuf_constants_m0[3u].x) * _411))) * 8.0f;
    _426 = _422 * _387;
    _427 = _422 * _388;
    _428 = _422 * _389;
  } else {
    _426 = _376;
    _427 = _377;
    _428 = _378;
  }
  float _429 = dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_426, _427, _428));
  float _433 = max(0.0f, _429 - ConstBuf_constants_m0[1u].x);
  float _437 = max(_429, 9.9999997473787516355514526367188e-06f);

  float4 final_color = float4(
      (((max(0.0f, (_257 * _250) / _261) + max(0.0f, (_170 * _163) / _174)) + max(0.0f, (_345 * _338) / _349)) + max(0.0f, (_433 * _426) / _437)) * 0.25f,
      (((max(0.0f, (_257 * _251) / _261) + max(0.0f, (_170 * _164) / _174)) + max(0.0f, (_345 * _339) / _349)) + max(0.0f, (_433 * _427) / _437)) * 0.25f,
      (((max(0.0f, (_257 * _252) / _261) + max(0.0f, (_170 * _165) / _174)) + max(0.0f, (_345 * _340) / _349)) + max(0.0f, (_433 * _428) / _437)) * 0.25f,
      (((_185.w + _75.w) + _273.w) + _361.w) * 0.25f);

  final_color.rgb *= CUSTOM_BLOOM;

  outTex[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = final_color;
  //   outTex[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4((((max(0.0f, (_257 * _250) / _261) + max(0.0f, (_170 * _163) / _174)) + max(0.0f, (_345 * _338) / _349)) + max(0.0f, (_433 * _426) / _437)) * 0.25f, (((max(0.0f, (_257 * _251) / _261) + max(0.0f, (_170 * _164) / _174)) + max(0.0f, (_345 * _339) / _349)) + max(0.0f, (_433 * _427) / _437)) * 0.25f, (((max(0.0f, (_257 * _252) / _261) + max(0.0f, (_170 * _165) / _174)) + max(0.0f, (_345 * _340) / _349)) + max(0.0f, (_433 * _428) / _437)) * 0.25f, (((_185.w + _75.w) + _273.w) + _361.w) * 0.25f);
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
