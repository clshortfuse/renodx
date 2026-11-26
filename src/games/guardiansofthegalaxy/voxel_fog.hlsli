#ifndef SRC_GAMES_GUARDIANSOFTHEGALAXY_VOXEL_FOG_HLSLI_
#define SRC_GAMES_GUARDIANSOFTHEGALAXY_VOXEL_FOG_HLSLI_

#include "./per_view_data.hlsli"

// Fog of VoxelizedLightScatteringApply_PS (0x31720375): froxel in-scatter plus analytic distance/height fog
// beyond the volume. Returns float4(in-scatter rgb, transmittance); vanilla blend is scene * a + rgb.
float4 VoxelFog(Texture3D<float4> volume, SamplerState volumeSampler, float2 uv, float depth) {
  S_SharedPerViewData v = cbSharedPerViewData;
  float viewZ = 1.0f / ((v.vViewRemap.z * depth) - v.vViewRemap.y);
  float slice = saturate(sqrt(abs((viewZ - v.vScatteringParams.y) / (v.vScatteringParams.x - v.vScatteringParams.y))));
  float4 vol = volume.Sample(volumeSampler, float3(saturate(uv.x), saturate(uv.y), (slice * 0.984375f) + -0.01171875f));
  if (!(v.vScatteringParams.z > v.vScatteringParams.x)) return vol;
  float maxDist = min(viewZ, v.vScatteringParams.z);
  float dist;
  if (v.vScatteringParams2.w == 0.0f) {
    dist = max(maxDist - v.vScatteringParams.x, 0.0f);
  } else {
    float3 eye = float3(lerp(v.vEyeVectorUL.xy, v.vEyeVectorLR.xy, uv), v.vEyeVectorLR.z);
    float rcpLen = rsqrt(dot(eye, eye));
    float dirZ = mad(rcpLen * eye.z, v.mViewToWorld[2].z, mad(rcpLen * eye.y, v.mViewToWorld[1].z, (eye.x * v.mViewToWorld[0].z) * rcpLen));
    float t = (v.vScatteringParams2.w - v.mViewToWorld[3].z) / dirZ;
    t = ((dirZ == 0.0f) || (t < 0.0f)) ? 3.4028234663852886e+38f : t;
    bool below = v.mViewToWorld[3].z < v.vScatteringParams2.w;
    float tStart = below ? 0.0f : t;
    float tEnd = below ? t : 3.4028234663852886e+38f;
    dist = max(0.0f, min(tEnd, maxDist) - min(max(v.vScatteringParams.x, tStart), maxDist));
  }
  float transmittance = exp2((v.vScatteringParams.w * -0.014426949433982372f) * dist);
  float fogAmount = saturate(1.0f - transmittance);
  return float4(((v.vScatteringParams2.rgb * vol.w) * fogAmount) + vol.rgb, transmittance * vol.w);
}

// CUSTOM: vanilla scene * T + S adds the in-scatter S linearly, which lifts blacks. This rescales S by k
// (computed in a gamma-like pow space) so dark scene pixels are not lifted as much. Surfaces brighter than
// the fog radiance yC keep the vanilla composite. strength <= 0 returns vanilla. Dense fog (T -> 0) returns the fog colour.
float3 FogBlackPreservingComposite(float3 scene, float3 inscatter, float transmittance, float strength) {
  float T = saturate(transmittance);
  float3 linear_out = scene * T + inscatter;
  float yS = dot(inscatter, float3(0.2126f, 0.7152f, 0.0722f));
  if (strength <= 0.f || T >= 0.9999f || T <= 1e-4f || yS <= 0.f) return linear_out;
  float g = 1.f + 1.2f * strength;
  float yL = dot(max(scene, 0.f), float3(0.2126f, 0.7152f, 0.0722f));
  float yC = yS / (1.f - T);
  if (yL >= yC) return linear_out;
  float yP = pow(T * pow(yL, 1.f / g) + (1.f - T) * pow(yC, 1.f / g), g);
  float k = saturate((yP - yL * T) / yS);
  return scene * T + inscatter * k;
}

#endif  // SRC_GAMES_GUARDIANSOFTHEGALAXY_VOXEL_FOG_HLSLI_
