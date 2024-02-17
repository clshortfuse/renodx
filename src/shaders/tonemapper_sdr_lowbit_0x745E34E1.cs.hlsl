// LUT + TONEMAPPER

#include "../cp2077/tonemapper.hlsl"

[numthreads(8, 8, 8)] void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  uint3 outputCoords = uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z);
  float4 outputColor = tonemap(false);
  outputColor.r = asfloat(asuint(outputColor.r) + 65536u);
  outputColor.g = asfloat(asuint(outputColor.g) + 65536u);
  outputColor.b = asfloat(asuint(outputColor.b) + 131072u);
  OUTPUT_TEXTURE[outputCoords] = outputColor;
}
