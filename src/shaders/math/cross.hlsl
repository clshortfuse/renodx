#ifndef SRC_SHADERS_MATH_CROSS_HLSL_
#define SRC_SHADERS_MATH_CROSS_HLSL_

#if !defined(__SLANG__) && (defined(VULKAN) || defined(GL_ES))

#define START_NAMESPACE(x)
#define END_NAMESPACE(x)
#define CROSS_COMPILE(dx, vulkan_glsl) vulkan_glsl

#define static
#define asfloat       uintBitsToFloat
#define mad(a, b, c)  fma(a, b, c)
#define saturate(a)   clamp(a, 0.0, 1.0)
#define lerp(a, b, t) mix(a, b, t)

#define float3x3  mat3
#define float2    vec2
#define float3    vec3
#define float4    vec4
#define mul(a, b) (b * a)

vec2 pow(vec2 x, float y) {
  return pow(x, vec2(y));
}

vec3 pow(vec3 x, float y) {
  return pow(x, vec3(y));
}

vec4 pow(vec4 x, float y) {
  return pow(x, vec4(y));
}

vec2 fma(vec2 a, float b, float c) {
  return fma(a, vec2(b), vec2(c));
}

vec3 fma(vec3 a, float b, float c) {
  return fma(a, vec3(b), vec3(c));
}

vec4 fma(vec4 a, float b, float c) {
  return fma(a, vec4(b), vec4(c));
}

#define CROSS_MATRIX(matrix, row, column) matrix[column][row]

#if defined(VULKAN)
#define CROSS_COMPILE_ALL(dx, vulkan, glsl) vulkan
#else
#define CROSS_COMPILE_ALL(dx, vulkan, glsl) glsl
#endif

#else  // HLSL

#define START_NAMESPACE(x)                  namespace x {
#define END_NAMESPACE(x)                    }
#define CROSS_COMPILE(dx, vulkan_glsl)      dx
#define CROSS_COMPILE_ALL(dx, vulkan, glsl) dx
#define CROSS_MATRIX(matrix, row, column)   matrix[row][column]

#endif  // HLSL

#endif  // SRC_SHADERS_MATH_CROSS_HLSL_