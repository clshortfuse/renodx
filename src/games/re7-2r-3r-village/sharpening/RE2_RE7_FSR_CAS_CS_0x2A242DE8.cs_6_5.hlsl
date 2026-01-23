#include "./sharpening.hlsli"

// cbuffer cbCAS {
//   struct cbCAS {
//     uint4 Const0;
//   } cbCAS;
// }
cbuffer cbCASUBO : register(b0, space0) {
  float4 cbCAS_m0[1] : packoffset(c0);
};

Texture2D<float4> SrcImage : register(t0, space0);
RWTexture2D<float4> OutputImage : register(u0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

uint spvPackHalf2x16(float2 value) {
  uint2 Packed = f32tof16(value);
  return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value) {
  return f16tof32(uint2(value & 0xffff, value >> 16));
}

void comp_main() {
  uint _45 = ((gl_LocalInvocationID.x >> 1u) & 7u) | (gl_WorkGroupID.x << 4u);
  uint _46 = (((gl_LocalInvocationID.x >> 3u) & 6u) | (gl_LocalInvocationID.x & 1u)) | (gl_WorkGroupID.y << 4u);

  if (CUSTOM_SHARPENING == 0.f) {
    int offset_x = int(_45 | 8u);
    int offset_y = int(_46 | 8u);

    OutputImage[int2(int(_45), int(_46))] = float4(SrcImage.Load(int3(int(_45), int(_46), 0)).rgb, 1.f);
    OutputImage[int2(offset_x, int(_46))] = float4(SrcImage.Load(int3(offset_x, int(_46), 0)).rgb, 1.f);
    OutputImage[int2(offset_x, offset_y)] = float4(SrcImage.Load(int3(offset_x, offset_y, 0)).rgb, 1.f);
    OutputImage[int2(int(_45), offset_y)] = float4(SrcImage.Load(int3(int(_45), offset_y, 0)).rgb, 1.f);
    return;
  } else if (CUSTOM_SHARPENING == 2.f) {
    float sharpness_strength = 0.75f;  // cbCAS_m0[0u].x

    uint tex_width, tex_height;
    SrcImage.GetDimensions(tex_width, tex_height);
    int2 tex_max = int2(int(tex_width) - 1, int(tex_height) - 1);

    int offset_x = int(_45 | 8u);
    int offset_y = int(_46 | 8u);

    OutputImage[int2(int(_45), int(_46))] =
        float4(ApplyLiliumRCAS(SrcImage, int2(int(_45), int(_46)), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(offset_x, int(_46))] =
        float4(ApplyLiliumRCAS(SrcImage, int2(offset_x, int(_46)), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(offset_x, offset_y)] =
        float4(ApplyLiliumRCAS(SrcImage, int2(offset_x, offset_y), sharpness_strength, tex_max), 1.f);
    OutputImage[int2(int(_45), offset_y)] =
        float4(ApplyLiliumRCAS(SrcImage, int2(int(_45), offset_y), sharpness_strength, tex_max), 1.f);
    return;
  }
  uint _55 = _45 << 16u;
  uint _57 = uint(int(_55) >> int(16u));
  uint _58 = _46 << 16u;
  uint _61 = uint(int(_58 + 4294901760u) >> int(16u));
  half4 _67 = half4(SrcImage.Load(int3(uint2(_57, _61), 0u)));
  half _68 = _67.x;
  half _69 = _67.y;
  half _70 = _67.z;
  uint _72 = uint(int(_55 + 4294901760u) >> int(16u));
  uint _73 = uint(int(_58) >> int(16u));
  half4 _76 = half4(SrcImage.Load(int3(uint2(_72, _73), 0u)));
  half _77 = _76.x;
  half _78 = _76.y;
  half _79 = _76.z;
  half4 _82 = half4(SrcImage.Load(int3(uint2(_57, _73), 0u)));
  half _83 = _82.x;
  half _84 = _82.y;
  half _85 = _82.z;
  uint _88 = uint(int(_55 + 65536u) >> int(16u));
  half4 _91 = half4(SrcImage.Load(int3(uint2(_88, _73), 0u)));
  half _92 = _91.x;
  half _93 = _91.y;
  half _94 = _91.z;
  uint _96 = uint(int(_58 + 65536u) >> int(16u));
  half4 _99 = half4(SrcImage.Load(int3(uint2(_57, _96), 0u)));
  half _100 = _99.x;
  half _101 = _99.y;
  half _102 = _99.z;
  uint16_t _103 = uint16_t(_45) | 8u;
  uint _105 = uint(_103);
  half4 _108 = half4(SrcImage.Load(int3(uint2(_105, _61), 0u)));
  half _109 = _108.x;
  half _110 = _108.y;
  half _111 = _108.z;
  uint _114 = uint((_103 + 65535u));
  half4 _117 = half4(SrcImage.Load(int3(uint2(_114, _73), 0u)));
  half _118 = _117.x;
  half _119 = _117.y;
  half _120 = _117.z;
  half4 _123 = half4(SrcImage.Load(int3(uint2(_105, _73), 0u)));
  half _124 = _123.x;
  half _125 = _123.y;
  half _126 = _123.z;
  uint _129 = uint((_103 + 1u));
  half4 _132 = half4(SrcImage.Load(int3(uint2(_129, _73), 0u)));
  half _133 = _132.x;
  half _134 = _132.y;
  half _135 = _132.z;
  half4 _138 = half4(SrcImage.Load(int3(uint2(_105, _96), 0u)));
  half _139 = _138.x;
  half _140 = _138.y;
  half _141 = _138.z;
  half _147 = min(min(_68, min(_77, _92)), _100);
  half _148 = min(min(_109, min(_118, _133)), _139);
  half _153 = min(min(_69, min(_78, _93)), _101);
  half _154 = min(min(_110, min(_119, _134)), _140);
  half _159 = min(min(_70, min(_79, _94)), _102);
  half _160 = min(min(_111, min(_120, _135)), _141);
  half _165 = max(max(_68, max(_77, _92)), _100);
  half _166 = max(max(_109, max(_118, _133)), _139);
  half _171 = max(max(_69, max(_78, _93)), _101);
  half _172 = max(max(_110, max(_119, _134)), _140);
  half _177 = max(max(_70, max(_79, _94)), _102);
  half _178 = max(max(_111, max(_120, _135)), _141);
  half _265 = half(spvUnpackHalf2x16(asuint(cbCAS_m0[0u]).y & 65535u).x);
  half _266 = _265 * max(half(-0.1875), min(max(max(half(-0.0) - (min(_147, _83) * (half(0.25) / _165)), (half(1.0) / ((_147 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_165, _83))), max(max(half(-0.0) - (min(_153, _84) * (half(0.25) / _171)), (half(1.0) / ((_153 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_171, _84))), max(half(-0.0) - (min(_159, _85) * (half(0.25) / _177)), (half(1.0) / ((_159 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_177, _85))))), half(0.0)));
  half _267 = _265 * max(half(-0.1875), min(max(max(half(-0.0) - (min(_148, _124) * (half(0.25) / _166)), (half(1.0) / ((_148 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_166, _124))), max(max(half(-0.0) - (min(_154, _125) * (half(0.25) / _172)), (half(1.0) / ((_154 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_172, _125))), max(half(-0.0) - (min(_160, _126) * (half(0.25) / _178)), (half(1.0) / ((_160 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_178, _126))))), half(0.0)));
  half _270 = (_266 * half(4.0)) + half(1.0);
  half _271 = (_267 * half(4.0)) + half(1.0);
  half _281 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_270), 0.0f))) & 65535u).x);
  half _289 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_271), 0.0f))) & 65535u).x);
  half _295 = (half(2.0) - (_270 * _281)) * _281;
  half _296 = (half(2.0) - (_289 * _271)) * _289;
  OutputImage[uint2(_45, _46)] = float4(float(_295 * ((_266 * (((_77 + _68) + _92) + _100)) + _83)), float(_295 * ((_266 * (((_78 + _69) + _93) + _101)) + _84)), float(_295 * ((_266 * (((_79 + _70) + _94) + _102)) + _85)), 0.0f);
  uint _341 = _45 | 8u;
  OutputImage[uint2(_341, _46)] = float4(float(_296 * ((_267 * (((_118 + _109) + _133) + _139)) + _124)), float(_296 * ((_267 * (((_119 + _110) + _134) + _140)) + _125)), float(_296 * ((_267 * (((_120 + _111) + _135) + _141)) + _126)), 0.0f);
  uint _345 = _46 | 8u;
  uint _350 = _345 << 16u;
  uint _352 = uint(int(_350 + 4294901760u) >> int(16u));
  half4 _355 = half4(SrcImage.Load(int3(uint2(_57, _352), 0u)));
  half _356 = _355.x;
  half _357 = _355.y;
  half _358 = _355.z;
  uint _359 = uint(int(_350) >> int(16u));
  half4 _362 = half4(SrcImage.Load(int3(uint2(_72, _359), 0u)));
  half _363 = _362.x;
  half _364 = _362.y;
  half _365 = _362.z;
  half4 _368 = half4(SrcImage.Load(int3(uint2(_57, _359), 0u)));
  half _369 = _368.x;
  half _370 = _368.y;
  half _371 = _368.z;
  half4 _374 = half4(SrcImage.Load(int3(uint2(_88, _359), 0u)));
  half _375 = _374.x;
  half _376 = _374.y;
  half _377 = _374.z;
  uint _379 = uint(int(_350 + 65536u) >> int(16u));
  half4 _382 = half4(SrcImage.Load(int3(uint2(_57, _379), 0u)));
  half _383 = _382.x;
  half _384 = _382.y;
  half _385 = _382.z;
  half4 _388 = half4(SrcImage.Load(int3(uint2(_105, _352), 0u)));
  half _389 = _388.x;
  half _390 = _388.y;
  half _391 = _388.z;
  half4 _394 = half4(SrcImage.Load(int3(uint2(_114, _359), 0u)));
  half _395 = _394.x;
  half _396 = _394.y;
  half _397 = _394.z;
  half4 _400 = half4(SrcImage.Load(int3(uint2(_105, _359), 0u)));
  half _401 = _400.x;
  half _402 = _400.y;
  half _403 = _400.z;
  half4 _406 = half4(SrcImage.Load(int3(uint2(_129, _359), 0u)));
  half _407 = _406.x;
  half _408 = _406.y;
  half _409 = _406.z;
  half4 _412 = half4(SrcImage.Load(int3(uint2(_105, _379), 0u)));
  half _413 = _412.x;
  half _414 = _412.y;
  half _415 = _412.z;
  half _420 = min(min(_356, min(_363, _375)), _383);
  half _421 = min(min(_389, min(_395, _407)), _413);
  half _426 = min(min(_357, min(_364, _376)), _384);
  half _427 = min(min(_390, min(_396, _408)), _414);
  half _432 = min(min(_358, min(_365, _377)), _385);
  half _433 = min(min(_391, min(_397, _409)), _415);
  half _438 = max(max(_356, max(_363, _375)), _383);
  half _439 = max(max(_389, max(_395, _407)), _413);
  half _444 = max(max(_357, max(_364, _376)), _384);
  half _445 = max(max(_390, max(_396, _408)), _414);
  half _450 = max(max(_358, max(_365, _377)), _385);
  half _451 = max(max(_391, max(_397, _409)), _415);
  half _529 = half(spvUnpackHalf2x16(asuint(cbCAS_m0[0u]).y & 65535u).x);
  half _530 = _529 * max(half(-0.1875), min(max(max(half(-0.0) - (min(_420, _369) * (half(0.25) / _438)), (half(1.0) / ((_420 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_438, _369))), max(max(half(-0.0) - (min(_426, _370) * (half(0.25) / _444)), (half(1.0) / ((_426 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_444, _370))), max(half(-0.0) - (min(_432, _371) * (half(0.25) / _450)), (half(1.0) / ((_432 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_450, _371))))), half(0.0)));
  half _531 = _529 * max(half(-0.1875), min(max(max(half(-0.0) - (min(_421, _401) * (half(0.25) / _439)), (half(1.0) / ((_421 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_439, _401))), max(max(half(-0.0) - (min(_427, _402) * (half(0.25) / _445)), (half(1.0) / ((_427 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_445, _402))), max(half(-0.0) - (min(_433, _403) * (half(0.25) / _451)), (half(1.0) / ((_433 * half(4.0)) + half(-4.0))) * (half(1.0) - max(_451, _403))))), half(0.0)));
  half _534 = (_530 * half(4.0)) + half(1.0);
  half _535 = (_531 * half(4.0)) + half(1.0);
  half _543 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_534), 0.0f))) & 65535u).x);
  half _551 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_535), 0.0f))) & 65535u).x);
  half _556 = (half(2.0) - (_534 * _543)) * _543;
  half _557 = (half(2.0) - (_551 * _535)) * _551;
  OutputImage[uint2(_45, _345)] = float4(float(_556 * ((_530 * (((_363 + _356) + _375) + _383)) + _369)), float(_556 * ((_530 * (((_364 + _357) + _376) + _384)) + _370)), float(_556 * ((_530 * (((_365 + _358) + _377) + _385)) + _371)), 0.0f);
  OutputImage[uint2(_341, _345)] = float4(float(_557 * ((_531 * (((_395 + _389) + _407) + _413)) + _401)), float(_557 * ((_531 * (((_396 + _390) + _408) + _414)) + _402)), float(_557 * ((_531 * (((_397 + _391) + _409) + _415)) + _403)), 0.0f);
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
