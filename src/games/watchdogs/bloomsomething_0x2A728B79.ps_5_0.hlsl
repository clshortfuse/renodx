cbuffer Viewport : register(b0){
  float4x4 _ViewRotProjectionMatrix : packoffset(c0);
  float4x4 _ViewProjectionMatrix : packoffset(c4);
  float4x4 _ProjectionMatrix : packoffset(c8);
  float4x4 _InvProjectionMatrix : packoffset(c12);
  float4x4 _InvProjectionMatrixDepth : packoffset(c16);
  float4x4 _DepthTextureTransform : packoffset(c20);
  float4x3 _ViewMatrix : packoffset(c24);
  float4x3 _InvViewMatrix : packoffset(c27);
  float4x4 _PreviousViewProjectionMatrix : packoffset(c30);
  float4 _CameraDistances : packoffset(c34);
  float4 _ViewportSize : packoffset(c35);
  float4 _CameraPosition_MaxStaticReflectionMipIndex : packoffset(c36);
  float4 _CameraDirection_MaxParaboloidReflectionMipIndex : packoffset(c37);
  float4 _ViewPoint_ExposureScale : packoffset(c38);
  float4 _FogColorVector_ExposedWhitePointOverExposureScale : packoffset(c39);
  float3 _SideFogColor : packoffset(c40);
  float3 _SunFogColorDelta : packoffset(c41);
  float3 _OppositeFogColorDelta : packoffset(c42);
  float4 _FogValues0 : packoffset(c43);
  float4 _FogValues1 : packoffset(c44);
  float4 _CameraNearPlaneSize : packoffset(c45);
  float4 _UncompressDepthWeights_ShadowProjDepthMinValue : packoffset(c46);
  float4 _UncompressDepthWeightsWS_ReflectionFadeTarget : packoffset(c47);
  float4 _WorldAmbientColorParams0 : packoffset(c48);
  float4 _WorldAmbientColorParams1 : packoffset(c49);
  float4 _WorldAmbientColorParams2 : packoffset(c50);
  float4 _GlobalWorldTextureParams : packoffset(c51);
  float4 _CullingCameraPosition_OneOverAutoExposureScale : packoffset(c52);
  float4 _AmbientSkyColor_ReflectionScaleStrength : packoffset(c53);
  float4 _AmbientGroundColor_ReflectionScaleDistanceMul : packoffset(c54);
  float4 _FacettedShadowCastParams : packoffset(c55);
  float4 _FSMClipPlanes : packoffset(c56);
  float2 _ReflectionGIControl : packoffset(c57);
}
cbuffer CelestialBody : register(b1){
  float4x3 _Model : packoffset(c0);
  float4x4 _ModelViewProj : packoffset(c3);
  float4 _Params : packoffset(c7);
  float3 _BodyPosition : packoffset(c8);
  float3 _XVector : packoffset(c9);
  float3 _YVector : packoffset(c10);
  float2 _SizeAndScale : packoffset(c11);
}

SamplerState CelestialBody__CelestialBodySampler__SampObj___s : register(s0);
SamplerState CelestialBody__TimeOfDayColorSampler__SampObj___s : register(s1);
Texture2D<float4> CelestialBody__CelestialBodySampler__TexObj__ : register(t0);
Texture2D<float4> CelestialBody__TimeOfDayColorSampler__TexObj__ : register(t1);

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _Params.x;
  r0.y = 0.5;
  r0.xyzw = CelestialBody__TimeOfDayColorSampler__TexObj__.Sample(CelestialBody__TimeOfDayColorSampler__SampObj___s, r0.xy).xyzw;
  r1.x = _Params.z * r0.w;
  r2.xyzw = CelestialBody__CelestialBodySampler__TexObj__.Sample(CelestialBody__CelestialBodySampler__SampObj___s, v0.xy).xyzw;
  r1.y = -1 + r2.w;
  r2.xyzw = _Params.yyyy * r2.xyzw;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r1.y = _Params.w * r1.y + 1;
  r1.x = r1.x * r1.y;
  r0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;
  o0.xyz = _ViewPoint_ExposureScale.www * r0.xyz;
    o0 = saturate(o0);
  return;
}