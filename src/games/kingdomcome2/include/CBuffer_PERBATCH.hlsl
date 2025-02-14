/*
  // Example values from renderdoc capture
  HDRColorBalance   1.00, 0.93869, 0.87962, 0.98  0 float4
  SunShafts_SunCol  1.25037, 1.00135, 0.85085, 1.00 16 float4
  HDRUserModification 1.00, 1.00, 0.00, 0.00        32 float4
  HDREyeAdaptation  6.00, 12.50, 2.40, 1.00       48 float4
  HDRFilmCurve      0.80, 0.84286, 1.00, 10.00    64 float4
  HDRBloomColor     0.0375, 0.0375, 0.0375        80 float3
 */

cbuffer PER_BATCH : register(b0, space3) {
  float4 HDRColorBalance : packoffset(c000.x);
  float3 SunShafts_SunCol : packoffset(c001.x);
  float3 HDRUserModification : packoffset(c002.x);
  float3 HDREyeAdaptation : packoffset(c003.x);
  float4 HDRFilmCurve : packoffset(c004.x);
  float3 HDRBloomColor : packoffset(c005.x);
};
