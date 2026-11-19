#ifndef MW3_BLOOM_HDR_HLSL
#define MW3_BLOOM_HDR_HLSL
float MW3Positive(float value) {
  return (value == value) ? clamp(value, 0.0f, 65504.0f) : 0.0f;
}
float3 MW3Positive(float3 value) {
  return float3(MW3Positive(value.r), MW3Positive(value.g), MW3Positive(value.b));
}
float MW3Coverage(float value) {
  return (value == value) ? saturate(value) : 0.0f;
}
#endif
