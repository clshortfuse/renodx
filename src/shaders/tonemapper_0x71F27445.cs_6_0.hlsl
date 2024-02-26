// LUT + TONEMAPPER

#include "../cp2077/tonemapper.hlsl"

[numthreads(8, 8, 8)] void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  uint3 outputCoords = uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z);
  OUTPUT_TEXTURE[outputCoords] = tonemap(true);
}
