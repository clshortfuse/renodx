half3 ApplyLut2D(Texture2D tex, SamplerState samplerTex, float3 uvw, float3 scaleOffset) {
  // Strip format where `height = sqrt(width)`
  uvw.z *= scaleOffset.z;
  float shift = floor(uvw.z);
  uvw.xy = uvw.xy * scaleOffset.z * scaleOffset.xy + scaleOffset.xy * 0.5;
  uvw.x += shift * scaleOffset.y;
  uvw.xyz = lerp(
    tex.SampleLevel(samplerTex, uvw.xy, 0).rgb,
    tex.SampleLevel(samplerTex, uvw.xy + float2(scaleOffset.y, 0.0), 0).rgb,
    uvw.z - shift
  );
  return uvw;
}
