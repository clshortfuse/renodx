// Shader for CRT/scanline TV effect in the opening menu.
// Draws fullscreen, clamping the game output.

#include "../../common.hlsl"

cbuffer cb0_buf : register(b0) {
  uint4 cb0_m[37] : packoffset(c0);
};

Texture2D<float4> t0 : register(t0);
RWTexture2D<float4> u0 : register(u0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
  uint3 gl_WorkGroupID : SV_GroupID;
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

void comp_main() {
  uint _74 = spvBitfieldUExtract(gl_LocalInvocationID.x, 1u, 3u) + (gl_WorkGroupID.x * 16u);
  uint _75 = spvBitfieldInsert(gl_LocalInvocationID.x >> 3u, gl_LocalInvocationID.x, 0u, 1u) + (gl_WorkGroupID.y * 16u);
  int _86 = cvt_f32_i32(asfloat(cb0_m[36u].x));
  int _87 = cvt_f32_i32(asfloat(cb0_m[36u].y));
  int _98 = cvt_f32_i32(asfloat(cb0_m[36u].z) - 1.0f);
  int _99 = cvt_f32_i32(asfloat(cb0_m[36u].w) - 1.0f);
  uint _107 = uint(clamp(int(_75), _87, _99));
  float4 _109 = t0.Load(int3(uint2(uint(clamp(_86, int(_74 + 1u), _98)), _107), 0u));
  float _112 = _109.y;
  uint _114 = uint(clamp(_86, int(_74), _98));
  float4 _116 = t0.Load(int3(uint2(_114, _107), 0u));
  float _118 = _116.y;
  float4 _129 = t0.Load(int3(uint2(uint(clamp(_86, int(_74 - 1u), _98)), _107), 0u));
  float _131 = _129.y;
  uint _134 = uint(clamp(_87, int(_75 - 1u), _99));
  float4 _136 = t0.Load(int3(uint2(_114, _134), 0u));
  float _138 = _136.y;
  uint _140 = uint(clamp(int(_75 + 1u), _87, _99));
  float4 _142 = t0.Load(int3(uint2(_114, _140), 0u));
  float _144 = _142.y;
  float _147 = max(max(max(_112, _118), _131), max(_138, _144));
  float _166 = asfloat(cb0_m[35u].x);
  float _167 = asfloat((asuint(clamp(min(1.0f - _147, min(min(_131, min(_112, _118)), min(_138, _144))) * asfloat(2129690299u - asuint(_147)), 0.0f, 1.0f)) >> 1u) + 532432441u) * _166;
  float _183 = mad(_167, 4.0f, 1.0f);
  float _189 = asfloat(2129764351u - asuint(_183));
  float _192 = _189 * mad(-_183, _189, 2.0f);

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    u0[uint2(_74, _75)] = float4(clamp((_116.x + mad(_142.x, _167, mad(_109.x, _167, (_129.x * _167) + (_136.x * _167)))) * _192, 0.0f, 1.0f), clamp(_192 * (_118 + mad(_144, _167, mad(_112, _167, (_138 * _167) + (_131 * _167)))), 0.0f, 1.0f), clamp(_192 * (_116.z + mad(_142.z, _167, mad(_109.z, _167, (_136.z * _167) + (_129.z * _167)))), 0.0f, 1.0f), 1.0f);
  } else {
    u0[uint2(_74, _75)] = float4(((_116.x + mad(_142.x, _167, mad(_109.x, _167, (_129.x * _167) + (_136.x * _167)))) * _192), (_192 * (_118 + mad(_144, _167, mad(_112, _167, (_138 * _167) + (_131 * _167))))), (_192 * (_116.z + mad(_142.z, _167, mad(_109.z, _167, (_136.z * _167) + (_129.z * _167))))), 1.0f);
  }

  uint _202 = _74 + 8u;
  uint _203 = _75 + 8u;
  uint _209 = uint(clamp(_86, int(_202 + 1u), _98));
  float4 _211 = t0.Load(int3(uint2(_209, _107), 0u));
  float _213 = _211.y;
  uint _217 = uint(clamp(_86, int(_202), _98));
  float4 _219 = t0.Load(int3(uint2(_217, _107), 0u));
  float _221 = _219.y;
  uint _227 = uint(clamp(_86, int(_202 - 1u), _98));
  float4 _229 = t0.Load(int3(uint2(_227, _107), 0u));
  float _231 = _229.y;
  float4 _235 = t0.Load(int3(uint2(_217, _134), 0u));
  float _237 = _235.y;
  float4 _240 = t0.Load(int3(uint2(_217, _140), 0u));
  float _242 = _240.y;
  float _249 = max(max(_231, max(_213, _221)), max(_237, _242));
  float _261 = _166 * asfloat((asuint(clamp(min(min(min(min(_213, _221), _231), min(_237, _242)), 1.0f - _249) * asfloat(2129690299u - asuint(_249)), 0.0f, 1.0f)) >> 1u) + 532432441u);
  float _277 = mad(_261, 4.0f, 1.0f);
  float _283 = asfloat(2129764351u - asuint(_277));
  float _286 = _283 * mad(-_277, _283, 2.0f);

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    u0[uint2(_202, _75)] = float4(clamp((_219.x + mad(_240.x, _261, mad(_211.x, _261, (_229.x * _261) + (_235.x * _261)))) * _286, 0.0f, 1.0f), clamp(_286 * (_221 + mad(_242, _261, mad(_213, _261, (_237 * _261) + (_231 * _261)))), 0.0f, 1.0f), clamp(_286 * (_219.z + mad(_240.z, _261, mad(_211.z, _261, (_235.z * _261) + (_229.z * _261)))), 0.0f, 1.0f), 1.0f);
  } else {
    u0[uint2(_202, _75)] = float4(((_219.x + mad(_240.x, _261, mad(_211.x, _261, (_229.x * _261) + (_235.x * _261)))) * _286), (_286 * (_221 + mad(_242, _261, mad(_213, _261, (_237 * _261) + (_231 * _261))))), (_286 * (_219.z + mad(_240.z, _261, mad(_211.z, _261, (_235.z * _261) + (_229.z * _261))))), 1.0f);
  }

  uint _298 = uint(clamp(_87, int(_203), _99));
  float4 _300 = t0.Load(int3(uint2(_209, _298), 0u));
  float _302 = _300.y;
  float4 _305 = t0.Load(int3(uint2(_217, _298), 0u));
  float _307 = _305.y;
  float4 _314 = t0.Load(int3(uint2(_227, _298), 0u));
  float _316 = _314.y;
  uint _319 = uint(clamp(_87, int(_203 - 1u), _99));
  float4 _321 = t0.Load(int3(uint2(_217, _319), 0u));
  float _323 = _321.y;
  uint _325 = uint(clamp(_87, int(_203 + 1u), _99));
  float4 _327 = t0.Load(int3(uint2(_217, _325), 0u));
  float _329 = _327.y;
  float _336 = max(max(_316, max(_302, _307)), max(_323, _329));
  float _348 = _166 * asfloat((asuint(clamp(min(min(min(min(_302, _307), _316), min(_323, _329)), 1.0f - _336) * asfloat(2129690299u - asuint(_336)), 0.0f, 1.0f)) >> 1u) + 532432441u);
  float _364 = mad(_348, 4.0f, 1.0f);
  float _370 = asfloat(2129764351u - asuint(_364));
  float _373 = _370 * mad(-_364, _370, 2.0f);

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    u0[uint2(_202, _203)] = float4(clamp((_305.x + mad(_327.x, _348, mad(_300.x, _348, (_314.x * _348) + (_321.x * _348)))) * _373, 0.0f, 1.0f), clamp(_373 * (_307 + mad(_329, _348, mad(_302, _348, (_323 * _348) + (_316 * _348)))), 0.0f, 1.0f), clamp(_373 * (_305.z + mad(_327.z, _348, mad(_300.z, _348, (_321.z * _348) + (_314.z * _348)))), 0.0f, 1.0f), 1.0f);
  } else {
    u0[uint2(_202, _203)] = float4(((_305.x + mad(_327.x, _348, mad(_300.x, _348, (_314.x * _348) + (_321.x * _348)))) * _373), (_373 * (_307 + mad(_329, _348, mad(_302, _348, (_323 * _348) + (_316 * _348))))), (_373 * (_305.z + mad(_327.z, _348, mad(_300.z, _348, (_321.z * _348) + (_314.z * _348))))), 1.0f);
  }

  uint _382 = _202 - 8u;
  uint _385 = uint(clamp(_86, int(_382), _98));
  float4 _387 = t0.Load(int3(uint2(_385, _298), 0u));
  float _389 = _387.y;
  float4 _399 = t0.Load(int3(uint2(uint(clamp(_86, int(_202 - 7u), _98)), _298), 0u));
  float _401 = _399.y;
  float4 _406 = t0.Load(int3(uint2(uint(clamp(_86, int(_202 - 9u), _98)), _298), 0u));
  float _408 = _406.y;
  float4 _412 = t0.Load(int3(uint2(_385, _325), 0u));
  float _414 = _412.y;
  float4 _417 = t0.Load(int3(uint2(_385, _319), 0u));
  float _419 = _417.y;
  float _426 = max(max(_414, _419), max(_408, max(_389, _401)));
  float _438 = _166 * asfloat((asuint(clamp(min(min(min(min(_389, _401), _408), min(_414, _419)), 1.0f - _426) * asfloat(2129690299u - asuint(_426)), 0.0f, 1.0f)) >> 1u) + 532432441u);
  float _454 = mad(_438, 4.0f, 1.0f);
  float _460 = asfloat(2129764351u - asuint(_454));
  float _463 = _460 * mad(-_454, _460, 2.0f);

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    u0[uint2(_382, _203)] = float4(clamp((_387.x + mad(_412.x, _438, mad(_399.x, _438, (_406.x * _438) + (_417.x * _438)))) * _463, 0.0f, 1.0f), clamp((mad(_414, _438, mad(_401, _438, (_419 * _438) + (_408 * _438))) + _389) * _463, 0.0f, 1.0f), clamp((mad(_412.z, _438, mad(_399.z, _438, (_417.z * _438) + (_406.z * _438))) + _387.z) * _463, 0.0f, 1.0f), 1.0f);
  } else {
    u0[uint2(_382, _203)] = float4(((_387.x + mad(_412.x, _438, mad(_399.x, _438, (_406.x * _438) + (_417.x * _438)))) * _463), ((mad(_414, _438, mad(_401, _438, (_419 * _438) + (_408 * _438))) + _389) * _463), ((mad(_412.z, _438, mad(_399.z, _438, (_417.z * _438) + (_406.z * _438))) + _387.z) * _463), 1.0f);
  }
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
