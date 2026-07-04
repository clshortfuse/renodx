#version 450
#include "./shared.h"
#include "./shared.slang"
#extension GL_EXT_nonuniform_qualifier : require

layout(set = 0, binding = 0, std140) uniform support_buffer {
  uint _m0;
  uint _m1[8];
  vec4 _m2;
  vec4 _m3;
  int _m4;
  float _m5[73];
  ivec4 _m6;
  int _m7;
}
support_buffer_1;

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 0, binding = 21, std140) uniform fp_c2 {
  vec4 _m0[4096];
}
fp_c2_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;
layout(set = 4, binding = 0) uniform sampler3D fp_t3d_cb2_0[64];

layout(location = 0) noperspective in vec4 inUV;
layout(location = 0) out vec4 outColor;

float ReadC3ByFloatIndex(int floatIndex) {
  uint fi = uint(floatIndex);
  return fp_c3_1._m0[int(fi >> 2u)][int(fi & 3u)];
}

float ReadC3ByByteOffset(int byteOffset) {
  return ReadC3ByFloatIndex(int(uint(byteOffset) >> 2u));
}

uint ComputeLutArrayIndex(int packedVecIndex, int packedComponent) {
  int lutArrayIndex = (packedVecIndex << 1) + int(uint(packedComponent) >> 1u);
  return min(uint(lutArrayIndex), 63u);
}

void DecodeC3PackedAddress(int byteOffset, out int packedVecIndex, out int packedComponent) {
  uint fi = uint(byteOffset) >> 2u;
  packedVecIndex = int(fi >> 2u);
  packedComponent = int(fi & 3u);
}

vec3 SampleLutArray(uint lutIndex, vec3 lutCoord) {
  return textureLod(fp_t3d_cb2_0[nonuniformEXT(int(lutIndex))], lutCoord, 0.0).xyz;
}

void main() {
  vec2 uv = inUV.xy;

  vec2 control = textureLod(fp_t_tcb_A, uv, 0.0).xw;
  float controlA = control.x;
  float controlB = control.y;

  vec3 scene = textureLod(fp_t_tcb_8, uv, 0.0).xyz;
  vec3 bloom = textureLod(fp_t_tcb_C, uv, 0.0).xyz;
  vec3 mixedColor = fma(bloom, vec3(0.25), scene);

  precise vec2 centeredUv = uv + vec2(-0.5);
  float radial = sqrt(fma(centeredUv.y, centeredUv.y, centeredUv.x * centeredUv.x));
  float vignetteT = clamp(fma(radial, fp_c1_1._m0[0].x, -0.5) * (-3.3333332538604736328125), 0.0, 1.0);
  float vignetteSmooth = vignetteT * vignetteT * fma(vignetteT, -2.0, 3.0);

  uint tableIndex = uint((floatBitsToInt(controlA) & 240) >> 4);
  int vignetteByteOffset = (int(tableIndex) << 2) + 512;
  float vignetteAmount = ReadC3ByByteOffset(vignetteByteOffset);
  float vignetteScale = fma(vignetteSmooth, vignetteAmount, -vignetteAmount) + 1.0;

  bool useDualLutPath = (floatBitsToInt(controlB) & 8) != 0;

  vec3 hdr = lut(mixedColor, useDualLutPath, true);
  vec3 outputRgb = lut(mixedColor, useDualLutPath);
  if (RENODX_TONE_MAP_TYPE != 0) outputRgb = ColourCorrect(hdr, outputRgb);
  outputRgb = ApplyColorGrade(outputRgb);
  outputRgb = DisplayMap(outputRgb);
  outColor = vec4(outputRgb * vignetteScale * CUSTOM_VIGNETTE, 1.0);
  outColor = renodx::draw::RenderIntermediatePass(outColor);
  
  //outColor = 0;
}

vec3 lut(vec3 mixedColor, bool useDualLutPath, bool scaled = false) {
  uint tableIndex = uint((floatBitsToInt(textureLod(fp_t_tcb_A, inUV.xy, 0.0).x) & 240) >> 4);
  float scale = (scaled) ? renodx::tonemap::neutwo::ComputeMaxChannelScale(mixedColor) : 1;
  if (useDualLutPath) {
    mixedColor *= scale;
    int lutAByteBase = floatBitsToInt(fp_c3_1._m0[36].x) << 4;
    // float lutA0x = ReadC3ByByteOffset(lutAByteBase + 0);
    // float lutA0y = ReadC3ByByteOffset(lutAByteBase + 4);
    // float lutA1x = ReadC3ByByteOffset(lutAByteBase + 8);
    float lutAScale = ReadC3ByByteOffset(lutAByteBase + 12);
    // float lutA2x = ReadC3ByByteOffset(lutAByteBase + 256);
    // float lutA2y = ReadC3ByByteOffset(lutAByteBase + 260);
    // float lutA2z = ReadC3ByByteOffset(lutAByteBase + 264);

    vec3 lutA0 = vec3(ReadC3ByByteOffset(lutAByteBase + 0), ReadC3ByByteOffset(lutAByteBase + 4), ReadC3ByByteOffset(lutAByteBase + 8));
    vec3 lutA1 = vec3(ReadC3ByByteOffset(lutAByteBase + 256), ReadC3ByByteOffset(lutAByteBase + 260), ReadC3ByByteOffset(lutAByteBase + 264));
    precise float lutAInR = mixedColor.x * lutAScale;
    precise float lutAInG = mixedColor.y * lutAScale;
    precise float lutAInB = mixedColor.z * lutAScale;

    vec3 lutAIn = mixedColor * lutAScale;
    // float lutACoordX = clamp(fma(lutA0x, sqrt(lutAInR), lutA2x), 0.0, 1.0);
    // float lutACoordY = clamp(fma(lutA0y, sqrt(lutAInG), lutA2y), 0.0, 1.0);
    // float lutACoordZ = clamp(fma(lutA1x, sqrt(lutAInB), lutA2z), 0.0, 1.0);
    vec3 lutACoord = saturate(fma(lutA0, sqrt(lutAIn), lutA1));

    int lutBByteBase = floatBitsToInt(fp_c3_1._m0[36].y) << 4;
    // float lutB0x = ReadC3ByByteOffset(lutBByteBase + 0);
    // float lutB0y = ReadC3ByByteOffset(lutBByteBase + 4);
    // float lutB1x = ReadC3ByByteOffset(lutBByteBase + 8);
    float lutBScale = ReadC3ByByteOffset(lutBByteBase + 12);
    // float lutB2x = ReadC3ByByteOffset(lutBByteBase + 256);
    // float lutB2y = ReadC3ByByteOffset(lutBByteBase + 260);
    // float lutB2z = ReadC3ByByteOffset(lutBByteBase + 264);
    vec3 lutB0 = vec3(ReadC3ByByteOffset(lutBByteBase + 0), ReadC3ByByteOffset(lutBByteBase + 4), ReadC3ByByteOffset(lutBByteBase + 8));
    vec3 lutB1 = vec3(ReadC3ByByteOffset(lutBByteBase + 256), ReadC3ByByteOffset(lutBByteBase + 260), ReadC3ByByteOffset(lutBByteBase + 264));

    // precise float lutBInR = mixedColor.x * lutBScale;
    // precise float lutBInG = mixedColor.y * lutBScale;
    // precise float lutBInB = mixedColor.z * lutBScale;
    vec3 lutBIn = mixedColor * lutBScale;

    // float lutBCoordX = clamp(fma(lutB0x, sqrt(lutBInR), lutB2x), 0.0, 1.0);
    // float lutBCoordY = clamp(fma(lutB0y, sqrt(lutBInG), lutB2y), 0.0, 1.0);
    // float lutBCoordZ = clamp(fma(lutB1x, sqrt(lutBInB), lutB2z), 0.0, 1.0);
    vec3 lutBCoord = saturate(fma(lutB0, sqrt(lutBIn), lutB1));

    int lutAPackedVecIndex;
    int lutAPackedComponent;
    DecodeC3PackedAddress((floatBitsToInt(fp_c3_1._m0[36].x) << 3) + 56, lutAPackedVecIndex, lutAPackedComponent);
    uint lutAIndex = ComputeLutArrayIndex(lutAPackedVecIndex, lutAPackedComponent);

    int lutBPackedVecIndex;
    int lutBPackedComponent;
    DecodeC3PackedAddress((floatBitsToInt(fp_c3_1._m0[36].y) << 3) + 56, lutBPackedVecIndex, lutBPackedComponent);
    uint lutBIndex = ComputeLutArrayIndex(lutBPackedVecIndex, lutBPackedComponent);

    vec3 lutAColor = SampleLutArray(lutAIndex, lutACoord);
    vec3 lutBColor = SampleLutArray(lutBIndex, lutBCoord);

    float lutBlend = fp_c3_1._m0[36].z;
    float outG = fma(lutBColor.y - lutAColor.y, lutBlend, lutAColor.y);
    float outB = fma(lutBColor.z - lutAColor.z, lutBlend, lutAColor.z);
    float outR = fma(lutBColor.x - lutAColor.x, lutBlend, lutAColor.x);
    vec3 out = fma(lutBColor - lutAColor, lutBlend, lutAColor) / scale;
    mixedColor /= scale;
    mixedColor *= lerp(lutAScale, lutBScale, lutBlend);
    if (!scaled) mixedColor = saturate(mixedColor);
    return lerp(mixedColor, out, LUT_STRENGTH);
  } 
  else {
    int lutByteBase = int(tableIndex) << 4;
    float lutScale = ReadC3ByByteOffset(lutByteBase + 12);
    vec3 lut0 = vec3(ReadC3ByByteOffset(lutByteBase + 0), ReadC3ByByteOffset(lutByteBase + 4), ReadC3ByByteOffset(lutByteBase + 8));
    vec3 lut1 = vec3(ReadC3ByByteOffset(lutByteBase + 256), ReadC3ByByteOffset(lutByteBase + 260), ReadC3ByByteOffset(lutByteBase + 264));
    mixedColor *= scale;
    vec3 lutIn = mixedColor * lutScale;
    vec3 lutCoord = saturate(fma(lut0, sqrt(lutIn), lut1));

    int packedVecIndex;
    int packedComponent;
    DecodeC3PackedAddress((int(tableIndex) << 3) + 56, packedVecIndex, packedComponent);
    uint lutIndex = ComputeLutArrayIndex(packedVecIndex, packedComponent);

    vec3 lut = SampleLutArray(lutIndex, lutCoord) / scale;
    lutIn /= scale;
    if (!scaled) lutIn = saturate(lutIn);
    return lerp(lutIn, lut, LUT_STRENGTH);
  }
}
