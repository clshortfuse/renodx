// In Game Brightness Control
SamplerState ColorSamplerSmp : register(s0);
Texture2D<float4> ColorSampler : register(t0); // 
cbuffer Params : register(b0) {
  float Exposure; 
  float Gamma; 
  float Contrast; 
}

void main(
  float2 v0 : TEXCOORD0, // RENDER
  out float4 o0 : SV_Target0)
{
  float4 r0;
  r0 = ColorSampler.Sample(ColorSamplerSmp, v0.xy).xyzw; //0
  r0.xyz = r0.xyz * (5.5555555);
  r0.xyz = log(r0.xyz);
  r0.xyz = r0.xyz * Exposure;
  r0.xyz = exp(r0.xyz); 
  r0.xyz = r0.xyz * (0.18); //5
  r0.xyz = log(r0.xyz);
  r0.w = (1.0) / Gamma; 
  r0.xyz = r0.xyz * r0.w; 
  r0.xyz = exp(r0.xyz);  

  o0.xyz = r0.xyz * 1.0; //Set to to 1.0. Use reno-dx color grading for exposure instead
  o0.w = 1;
  
}