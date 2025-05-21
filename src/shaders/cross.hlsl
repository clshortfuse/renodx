#ifndef SRC_SHADERS_CROSS_HLSL_
#define SRC_SHADERS_CROSS_HLSL_

#if defined(VULKAN)
#define START_NAMESPACE(x)
#define END_NAMESPACE(x)
#define CROSS_COMPILE(dx, vulkan_glsl)      vulkan_glsl
#define CROSS_COMPILE_ALL(dx, vulkan, glsl) vulkan

#define static
#define asfloat       uintBitsToFloat
#define mad(a, b, c)  fma(a, b, c)
#define saturate(a)   clamp(a, 0.0, 1.0)
#define lerp(a, b, t) mix(a, b, t)
#define float2        vec2
#define float3        vec3
#define float4        vec4
#define float2f       vec2
#define float3f       vec3
#define float4f       vec4

#define CROSS_CAST(type, x) type(x)

#elif defined(GL_ES)

#define START_NAMESPACE(x)
#define END_NAMESPACE(x)
#define CROSS_COMPILE(dx, vulkan_glsl)      vulkan_glsl
#define CROSS_COMPILE_ALL(dx, vulkan, glsl) glsl
#define CROSS_CAST(type, x)                 ##type(x)

#else  // HLSL

#define START_NAMESPACE(x)                  namespace x {
#define END_NAMESPACE(x)                    }
#define CROSS_COMPILE(dx, vulkan_glsl)      dx
#define CROSS_COMPILE_ALL(dx, vulkan, glsl) dx

#define CROSS_CAST(type, x) cast_##type(x)

float cast_float(float x) {
  return x;
}

float2 cast_float2(float x) {
  return float2(x, x);
}
float3 cast_float3(float x) {
  return float3(x, x, x);
}
float4 cast_float4(float x) {
  return float4(x, x, x, x);
}

#endif  // HLSL

#endif  // SRC_SHADERS_CROSS_HLSL_