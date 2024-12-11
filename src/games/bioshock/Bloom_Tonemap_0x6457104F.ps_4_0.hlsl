cbuffer _Globals : register(b0)
{
  float ImageSpace_hlsl_ToneMapPixelShader011_4bits : packoffset(c0) = {0};
  float4 fogColor : packoffset(c1);
  float3 fogTransform : packoffset(c2);
  float4x3 screenDataToCamera : packoffset(c3);
  float globalScale : packoffset(c6);
  float sceneDepthAlphaMask : packoffset(c6.y);
  float globalOpacity : packoffset(c6.z);
  float distortionBufferScale : packoffset(c6.w);
  float2 wToZScaleAndBias : packoffset(c7);
  float4 screenTransform[2] : packoffset(c8);
  float4 textureToPixel : packoffset(c10);
  float4 pixelToTexture : packoffset(c11);
  float maxScale : packoffset(c12) = {0};
  float bloomAlpha : packoffset(c12.y) = {0};
  float sceneBias : packoffset(c12.z) = {1};
  float exposure : packoffset(c12.w) = {0};
  float deltaExposure : packoffset(c13) = {0};
  float4 ColorFill : packoffset(c14);
}

SamplerState s_framebuffer_s : register(s0);
SamplerState s_bloom_s : register(s1);
Texture2D<float4> s_framebuffer : register(t0);
Texture2D<float4> s_bloom : register(t1);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 outColor : SV_Target0)
{
  float3 bloomColor = s_bloom.Sample(s_bloom_s, w1.xy).rgb;
  float4 sceneColor = s_framebuffer.Sample(s_framebuffer_s, v1.xy).rgba;
  bloomColor *= bloomAlpha; // Scale down (or up) the bloom intensity
  sceneColor.rgb += bloomColor; // Bloom is 100% additive here
  sceneColor.rgb *= sceneBias; // Exposure?
  //TODO: add dice tonemap here, the game had none (it's not particularly needed either given it was heavily clipped)
  outColor = float4(pow(abs(sceneColor.rgb), 1.0 / 2.2) * sign(sceneColor.rgb), sceneColor.a); // Gamma 2.2
}