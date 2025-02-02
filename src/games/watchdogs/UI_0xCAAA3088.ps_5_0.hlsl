cbuffer FireUiPrimitive : register(b0)
{
  float4 _ColorAdd : packoffset(c0);
  float4 _ColorMultiplier : packoffset(c1);
  float4 _DiffuseSampler0Size : packoffset(c2);
  float4 _PostFxMaskViewportSize : packoffset(c3);
  float4x4 _Transform : packoffset(c4);
  float4x4 _UVTransform : packoffset(c8);
  float4 _VideoTextureUnpack[8] : packoffset(c12);
  float2 _SystemTime_GlitchFactor : packoffset(c20);
  float _DesaturationFactor : packoffset(c20.z);
  float _DistanceFieldFloatArray[18] : packoffset(c21);
}

#define cmp -

void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v0.xyz, float3(0.298999995,0.587000012,0.114));
  r0.yzw = v0.xyz + -r0.xxx;
  o0.xyz = _DesaturationFactor * r0.yzw + r0.xxx;
  o0.w = v0.w;
  return;
}