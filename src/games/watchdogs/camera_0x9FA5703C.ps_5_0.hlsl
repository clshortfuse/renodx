#include "./common.hlsl"

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
cbuffer PostFxGeneric : register(b1){
  float4 _Color : packoffset(c0);
  float4 _QuadParams : packoffset(c1);
  float4 _Random : packoffset(c2);
  float4 _UVScaleOffset : packoffset(c3);
  float2 _Tiling : packoffset(c4);
  float _Intensity : packoffset(c4.z);
  float _Parameter1 : packoffset(c4.w);
  float _Parameter2 : packoffset(c5);
  float _Parameter3 : packoffset(c5.y);
  float _Parameter4 : packoffset(c5.z);
}

SamplerState PostFxGeneric__TextureSamplerPoint__SampObj___s : register(s0);
SamplerState PostFxGeneric__PostFxMaskTexturePoint__SampObj___s : register(s1);
SamplerState PostFxGeneric__SrcSamplerLinear__SampObj___s : register(s2);
Texture2D<float4> PostFxGeneric__TextureSamplerPoint__TexObj__ : register(t0);
Texture2D<float4> PostFxGeneric__PostFxMaskTexturePoint__TexObj__ : register(t1);
Texture2D<float4> PostFxGeneric__SrcSamplerLinear__TexObj__ : register(t2);

#define cmp -

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0.0078125,0.013888889,0.00390625,0.0069444445) * _Parameter3;
  r1.xy = float2(1,1) / r0.xy;
  r1.xy = v0.xy * r1.xy;
  r1.xy = floor(r1.xy);
  r1.zw = r1.xy * r0.xy;
  r0.xy = r1.xy * r0.xy + r0.zw;
  r0.z = PostFxGeneric__PostFxMaskTexturePoint__TexObj__.Sample(PostFxGeneric__PostFxMaskTexturePoint__SampObj___s, r1.zw).x;
  r1.xyzw = _Parameter3 * float4(0.00390625,-0.0069444445,-0.00390625,0.0069444445) + r0.xyxy;
  r0.w = PostFxGeneric__PostFxMaskTexturePoint__TexObj__.Sample(PostFxGeneric__PostFxMaskTexturePoint__SampObj___s, r1.xy).x;
  r1.x = PostFxGeneric__PostFxMaskTexturePoint__TexObj__.Sample(PostFxGeneric__PostFxMaskTexturePoint__SampObj___s, r1.zw).x;
  r0.z = r0.z + r0.w;
  r0.z = r0.z + r1.x;
  r1.xy = _Parameter3 * float2(0.00390625,0.0069444445) + r0.xy;
  r0.w = PostFxGeneric__PostFxMaskTexturePoint__TexObj__.Sample(PostFxGeneric__PostFxMaskTexturePoint__SampObj___s, r1.xy).x;
  r0.z = r0.z + r0.w;
  r0.w = PostFxGeneric__PostFxMaskTexturePoint__TexObj__.Sample(PostFxGeneric__PostFxMaskTexturePoint__SampObj___s, r0.xy).x;
  r0.xy = -v0.xy + r0.xy;
  r0.z = r0.z + r0.w;
  r0.z = cmp(r0.z >= 0.100000001);
  r1.z = r0.z ? 1.000000 : 0;
  r1.xy = r1.zz * r0.xy + v0.xy;
  r0.x = cmp(0 < _Parameter3);
  r2.xy = v0.xy;
  r2.z = 0;
  r0.xyz = r0.xxx ? r1.xyz : r2.xyz;
  r1.xy = r0.yx / _ViewportSize.wz;
  r1.xy = float2(0.25,0.5) * r1.xy;
  r1.xy = frac(r1.xy);
  r0.w = r1.y + r1.y;
  r1.x = 0.200000003 * r1.x;
  r0.w = floor(r0.w);
  r0.w = r0.w * 0.200000003 + 0.800000012;
  r0.w = r1.x * r0.w + 0.800000012;
  r0.z = 1 + -r0.z;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.x = saturate(_Intensity);
  r1.y = r0.x * r0.x + r1.x;
  r1.y = r0.y * r0.y + r1.y;
  r1.y = min(1.99000001, r1.y);
  r1.z = _ViewportSize.z * r1.y;
  r1.w = r1.z * r0.z;
  r2.xz = float2(2,4) * r1.zw;
  r1.zw = float2(2,1.95000005) + -r1.yy;
  r3.x = cmp(0.00999999978 < r1.z);
  r3.yz = float2(8.81664467,1.10000002) * r1.zw;
  r1.z = -r1.w * 1.10000002 + 1;
  r1.w = 1 / r3.y;
  r1.w = r3.x ? r1.w : 0;
  r1.w = -1 + r1.w;
  r1.y = r1.y * r1.w;
  r1.w = r1.x * r1.x;
  r1.x = 1 + -r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.x;
  r1.x = r1.x * r1.z + r3.z;
  r1.y = r1.y * r1.w + 1;
  r0.xy = r1.yy * r0.xy;
  r1.yz = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.xy = -abs(r0.xy) * abs(r0.xy) + float2(1,1);
  r0.x = saturate(r0.x * r0.y);
  r0.x = r0.x * 0.720000029 + 0.400000006;
  r2.yw = float2(0,0);
  r2.zw = r2.zw + r1.yz;
  r0.yz = -r2.xy * r0.zz + r1.yz;
  r1.z = PostFxGeneric__SrcSamplerLinear__TexObj__.Sample(PostFxGeneric__SrcSamplerLinear__SampObj___s, r1.yz).y;
  r1.y = PostFxGeneric__SrcSamplerLinear__TexObj__.Sample(PostFxGeneric__SrcSamplerLinear__SampObj___s, r0.yz).x;
  r1.w = PostFxGeneric__SrcSamplerLinear__TexObj__.Sample(PostFxGeneric__SrcSamplerLinear__SampObj___s, r2.zw).z;
      if(injectedData.toneMapGammaCorrection == 2.f){
    r1.gba = renodx::color::gamma::DecodeSafe(r1.gba, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    r1.gba = renodx::color::gamma::DecodeSafe(r1.gba, 2.2f);
    } else {
    r1.gba = renodx::color::srgb::DecodeSafe(r1.gba);
    }
    r1.gba /= injectedData.toneMapGameNits / injectedData.toneMapUINits;
      if(injectedData.toneMapType >= 3.f){
    r1.gba = renodx::color::correct::Hue(r1.gba, RenoDRTSmoothClamp(r1.gba), injectedData.toneMapHueCorrection, (uint)injectedData.toneMapHueProcessor);
    }
  r0.yz = v0.xy * float2(5,5) + _Random.xy;
  r0.y = PostFxGeneric__TextureSamplerPoint__TexObj__.Sample(PostFxGeneric__TextureSamplerPoint__SampObj___s, r0.yz).x;
  r0.y = r0.y * 0.100000001 + 0.949999988;
  r2.xyz = r1.yzw * r0.yyy;
  r0.z = dot(r2.xyz, float3(0.300000012,0.109999999,0.589999974));
  r1.yzw = -r1.yzw * r0.yyy + r0.zzz;
  r3.xyzw = saturate(_Color.wxyz);
  r1.yzw = r3.xxx * r1.yzw + r2.xyz;
  r1.yzw = r1.yzw * r3.yzw;
  r0.yzw = r1.yzw * r0.www;
  r0.xyz = r0.yzw * r0.xxx;
    o0.rgb = r0.xyz * r1.xxx;
      if(injectedData.toneMapType == 0.f){
        o0.rgb = saturate(o0.rgb);
      } else {
        o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
      }
      if(injectedData.toneMapGammaCorrection == 2.f){
    o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.4f);
    } else if(injectedData.toneMapGammaCorrection == 1.f){
    o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb, 2.2f);
    } else {
    o0.rgb = renodx::color::srgb::EncodeSafe(o0.rgb);
    }
  o0.w = 1;
  return;
}