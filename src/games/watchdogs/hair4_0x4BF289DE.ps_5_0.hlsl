cbuffer Global : register(b0){
  float4 _DebugValues : packoffset(c0);
  float4 _GlobalLightsIntensity : packoffset(c1);
  float4 _GlobalScalars : packoffset(c2);
  float4 _GlobalScalars2 : packoffset(c3);
  float4 _GlobalWeatherControl_StaticReflectionIntensityDest : packoffset(c4);
  float4 _WorldLoadingRingSizes : packoffset(c5);
  float4 _ReflectionAmbientColor_WindNoiseDeltaVectorX : packoffset(c6);
  float4 _ReflectionLightDirection_WindNoiseDeltaVectorY : packoffset(c7);
  float4 _ReflectionLightColor_CrowdAnimationStartTime : packoffset(c8);
  float4 _WindVelocityTextureCoverage : packoffset(c9);
  float4 _WindGlobalNoiseTextureCoverage_VertexAOIntensity : packoffset(c10);
  float4 _WindGlobalNoiseTextureChannelSel_ReflectionTextureBlendRatio : packoffset(c11);
  float4 _WindGlobalTurbulence : packoffset(c12);
  float4 _DefaultAmbientProbesColour_TimeOfDay : packoffset(c13);
}
cbuffer MaterialDriverHair : register(b1){
  float4 _AlphaTexture1Size : packoffset(c0);
  float4 _AlphaUVTiling1 : packoffset(c1);
  float4 _AnimationParameters : packoffset(c2);
  float4 _DiffuseTexture1Size : packoffset(c3);
  float4 _DiffuseUVTiling1 : packoffset(c4);
  float4 _HairFilterDirection : packoffset(c5);
  float4 _MaterialPickingID : packoffset(c6);
  float4 _NormalTexture1Size : packoffset(c7);
  float4 _NormalUVTiling1 : packoffset(c8);
  float4 _SpecularNoiseTextureSize : packoffset(c9);
  float4 _SpecularNoiseUVSel : packoffset(c10);
  float4 _SpecularPower : packoffset(c11);
  float4 _SpecularShiftGlossiness : packoffset(c12);
  float4 _SpecularShiftTextureSize : packoffset(c13);
  float4 _SpecularShiftUVSel : packoffset(c14);
  float4 _SpecularTexture1Size : packoffset(c15);
  float4 _SpecularUVTiling1 : packoffset(c16);
  float4 _WetSpecularPower : packoffset(c17);
  float3 _DiffuseColor1 : packoffset(c18);
  float _AlphaTestValue : packoffset(c18.w);
  float3 _DiffuseColor2 : packoffset(c19);
  float _HairFilterStrength : packoffset(c19.w);
  float3 _Specular2Color : packoffset(c20);
  float _NormalIntensity : packoffset(c20.w);
  float3 _SpecularNoiseTilingStrength : packoffset(c21);
  float _Reflectance : packoffset(c21.w);
  float3 _SpecularShiftTilingStrength : packoffset(c22);
  float _Specular1Intensity : packoffset(c22.w);
  float2 _SpecularHairDirSel : packoffset(c23);
  float _WetDiffuseMultiplier : packoffset(c23.z);
  float _WetReflectance : packoffset(c23.w);
  float2 _UseAnisoSpecular : packoffset(c24);
  int _DiffuseColor1BlendingType : packoffset(c24.z);
  bool _HasAnimation : packoffset(c24.w);
  bool _UseAlternateFilterMethod : packoffset(c25);
  bool _UseColorMask : packoffset(c25.y);
  bool _UseHairFilter : packoffset(c25.z);
  bool _UseHairFilterMask : packoffset(c25.w);
}
cbuffer SceneGraphicObjectInstance : register(b2){
  float4 _InstanceMaterialValues : packoffset(c0);
  float4 _InstanceWetness : packoffset(c1);
  float4 _PickingID : packoffset(c2);
  float4 _PostFxMask : packoffset(c3);
}

SamplerState MaterialDriverHair__AlphaTexture1__SampObj___s : register(s0);
SamplerState MaterialDriverHair__DiffuseTexture1__SampObj___s : register(s1);
SamplerState MaterialDriverHair__NormalTexture1__SampObj___s : register(s2);
SamplerState MaterialDriverHair__SpecularTexture1__SampObj___s : register(s3);
Texture2D<float4> MaterialDriverHair__AlphaTexture1__TexObj__ : register(t0);
Texture2D<float4> MaterialDriverHair__DiffuseTexture1__TexObj__ : register(t1);
Texture2D<float4> MaterialDriverHair__NormalTexture1__TexObj__ : register(t2);
Texture2D<float4> MaterialDriverHair__SpecularTexture1__TexObj__ : register(t3);

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD6,
  float4 v7 : TEXCOORD7,
  float4 v8 : SV_Position0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2,
  out float2 o3 : SV_Target3)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = MaterialDriverHair__AlphaTexture1__TexObj__.Sample(MaterialDriverHair__AlphaTexture1__SampObj___s, v6.xy).y;
  r0.x = -_AlphaTestValue + r0.x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyz = _DiffuseColor2.xyz + -_DiffuseColor1.xyz;
  r0.xyz = v0.xxx * r0.xyz + _DiffuseColor1.xyz;
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r2.xyz = MaterialDriverHair__DiffuseTexture1__TexObj__.Sample(MaterialDriverHair__DiffuseTexture1__SampObj___s, v6.zw).xyz;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r1.xyz = -r3.xyz * r1.xyz + float3(1,1,1);
  r0.xyz = r2.xyz * r0.xyz;
  r2.xyz = cmp(float3(0.5,0.5,0.5) >= r2.xyz);
  r2.xyz = r2.xyz ? float3(1,1,1) : 0;
  r0.xyz = r0.xyz * float3(2,2,2) + -r1.xyz;
  r0.xyz = r2.xyz * r0.xyz + r1.xyz;
  r0.w = -1 + _WetDiffuseMultiplier;
  r1.x = _InstanceWetness.z * _GlobalWeatherControl_StaticReflectionIntensityDest.x;
  r1.x = max(_InstanceWetness.x, r1.x);
  r0.w = r1.x * r0.w + 1;
  o0.xyz = r0.xyz * r0.www;
  r0.x = -1 + v0.w;
  o0.w = _WindGlobalNoiseTextureCoverage_VertexAOIntensity.w * r0.x + 1;
  r0.x = dot(v3.xyz, v3.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v3.xyz * r0.xxx;
  r0.w = dot(v2.xyz, v2.xyz);
  r0.w = rsqrt(r0.w);
  r1.yzw = v2.xyz * r0.www;
  r2.xy = MaterialDriverHair__NormalTexture1__TexObj__.Sample(MaterialDriverHair__NormalTexture1__SampObj___s, v7.xy).yw;
  r2.xy = r2.yx * float2(2,2) + float2(-1,-1);
  r2.zw = _NormalIntensity * r2.xy;
  r0.w = dot(r2.xy, r2.xy);
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r0.w = sqrt(r0.w);
  r1.yzw = r2.www * r1.yzw;
  r0.xyz = r2.zzz * r0.xyz + r1.yzw;
  r1.y = dot(v1.xyz, v1.xyz);
  r1.y = rsqrt(r1.y);
  r1.yzw = v1.xyz * r1.yyy;
  r0.xyz = r0.www * r1.yzw + r0.xyz;
  o1.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
  o1.w = 18;
  r0.x = _WetReflectance + -_Reflectance;
  o2.x = r1.x * r0.x + _Reflectance;
  r0.x = _WetSpecularPower.x + -_SpecularPower.x;
  r0.x = r1.x * r0.x + _SpecularPower.x;
  r0.yz = MaterialDriverHair__SpecularTexture1__TexObj__.Sample(MaterialDriverHair__SpecularTexture1__SampObj___s, v7.zw).xy;
  o2.y = r0.x * r0.z;
  o2.z = _UseAnisoSpecular.y * r0.y;
  o2.w = 0;
  r0.xy = v4.xy / v4.zz;
  r0.zw = v5.xy / v5.zz;
  o3.xy = r0.xy + -r0.zw;
    o2 = saturate(o2);
  return;
}