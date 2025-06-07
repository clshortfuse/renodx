cbuffer Wheel : register(b0){
  float3 wipeMaskData : packoffset(c0);
  float wheelFadeIn : packoffset(c0.w);
  float animationTimer : packoffset(c1);
  float centerScale : packoffset(c1.y);
  int elementCount : packoffset(c1.z);
  float globalOpacity : packoffset(c1.w);
  float4 hoverFadeIns_[3] : packoffset(c2);
  float timeLeft : packoffset(c5);
  bool showIcon : packoffset(c5.y);
}
cbuffer WheelElement : register(b1){
  float4 adjustedColor : packoffset(c0);
  float elementHoverFadeIn : packoffset(c1);
  bool premultiplyAlpha : packoffset(c1.y);
}
SamplerState MainSampler_s : register(s0);
Texture2D<float4> IconTexture : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = IconTexture.Sample(MainSampler_s, v1.xy).xyzw;
  r1.xyz = r0.xyz * r0.www;
  r0.xyz = premultiplyAlpha ? r1.xyz : r0.xyz;
  r1.xyzw = adjustedColor.xyzw * r0.xyzw;
  r0.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r2.xyz = -r0.xyz * adjustedColor.xyz + r0.www;
  r2.xyz = r2.xyz * float3(0.4,0.4,0.4) + r1.xyz;
  r0.xyz = r0.xyz * adjustedColor.xyz + -r2.xyz;
  r1.xyz = elementHoverFadeIn * r0.xyz + r2.xyz;
  r0.xyzw = wheelFadeIn * r1.xyzw;
  o0.xyzw = globalOpacity * r0.xyzw;
	o0.a = saturate(o0.a);	
  return;
}