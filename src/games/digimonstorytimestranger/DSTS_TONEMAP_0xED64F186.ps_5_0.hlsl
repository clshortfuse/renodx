// Actual ToneMap Shader? Needs Investigation
SamplerState ColorSamplerSmp : register(s0);
Texture2D<float4> ColorSampler : register(t0); 
cbuffer Params : register(b0) {
  float ToneMapExposure; 
  float4 ToneMapParams1; 
  float4 ToneMapParams2; 
}

void main(
  float2 v0 : TEXCOORD0, // RENDER
  out float4 o0 : SV_Target0)
{
  float4 r0;
  float3 r1;
  float3 r2;
  r0 = ColorSampler.Sample(ColorSamplerSmp, v0.xy).xyzw; //0
  r1.xyz = (ToneMapParams1.xxx * r0.xyz) + ToneMapParams1.yyy;
  r1.xyz = r0.xyz * r1;
  r2.xyz = (ToneMapParams1.zzz * r0.xyz) + ToneMapParams1.www;
  r0.xyz = (r0.xyz * r2) + ToneMapParams2.xxx;
  o0.w = r0.w; 
  o0.xyz = r1.xyz / r0.xyz; 
  o0.w = 1;
}