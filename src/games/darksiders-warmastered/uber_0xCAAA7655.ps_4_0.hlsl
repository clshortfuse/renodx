// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 01:29:41 2025

cbuffer _Globals : register(b4)
{
  float4 gShowAO : packoffset(c0);
  float pDistortionScale : packoffset(c1) = {20};
  float4 ScreenDimensions : packoffset(c2);
  float pdistort_coords : packoffset(c3) = {6};
}

cbuffer g_globalbuffer : register(b0)
{

  struct
  {
    float3 cameraPos;
    float time;
    float4 depthBias;
    float4 rimColor;
    float4 ambientColor;
    float4 ambientColor2;
    float4 fogParams;
    float4 fogColor;
    row_major float4x4 invProj;
    float4 depthRange;
    float4 viewport;
    float4 spotOffsets[16];
  } g_global : packoffset(c0);

}

cbuffer g_instancebuffer : register(b1)
{

  struct
  {
    float4 objectColor;
    bool preMultiplyAlpha;
    float colorMapMult;
    float fadeAmount;
    float alphaRef;
    bool lightEnable0;
    bool lightEnable1;
    bool lightEnable2;
    float _pad1;
  } g_instance : packoffset(c0);

}

SamplerState pDistortionMap_sampler_s : register(s0);
SamplerState pOpacityMap_sampler_s : register(s1);
SamplerState FrameBuffer_sampler_s : register(s2);
SamplerState pOverlay_sampler_s : register(s3);
SamplerState pmask_sampler_s : register(s4);
SamplerState pcloud1_sampler_s : register(s5);
SamplerState pcloud2_sampler_s : register(s6);
Texture2D<float4> pDistortionMap_texture : register(t0);
Texture2D<float4> pOpacityMap_texture : register(t1);
Texture2D<float4> FrameBuffer_texture : register(t2);
Texture2D<float4> pOverlay_texture : register(t3);
Texture2D<float4> pmask_texture : register(t4);
Texture2D<float4> pcloud1_texture : register(t5);
Texture2D<float4> pcloud2_texture : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = v0.y * 11 + g_global.time;
  r1.xyz = float3(1.5,1.29999995,-1.60000002) * g_global.time;
  r0.yz = v0.xy * float2(11,18) + r1.yz;
  r2.xyzw = pcloud1_texture.Sample(pcloud1_sampler_s, r0.yw).xyzw;
  r0.x = v0.x * 18 + -g_global.time;
  r0.xyzw = pcloud2_texture.Sample(pcloud2_sampler_s, r0.xz).xyzw;
  r0.x = r2.x * r0.x;
  r0.xy = r0.xx * float2(0.109999999,0.109999999) + v0.xy;
  r0.xyzw = pmask_texture.Sample(pmask_sampler_s, r0.xy).xyzw;
  r0.x = 1 + -r0.y;
  r2.xyzw = pOverlay_texture.Sample(pOverlay_sampler_s, v0.xy).xyzw;
  r0.yzw = -r0.xxx * r2.xyz + float3(1,1,1);
  r1.yzw = r2.xyz * r0.xxx;
  r0.x = log2(r0.x);
  r0.x = 0.800000012 * r0.x;
  r0.x = exp2(r0.x);
  r2.xy = float2(-0.5,-0.5) + v0.xy;
  r2.x = dot(r2.xy, r2.xy);
  r1.x = r2.x * 2 + r1.x;
  r2.x = 66 * r2.x;
  r2.x = sin(r2.x);
  r1.x = 33 * r1.x;
  r1.x = sin(r1.x);
  r2.y = g_global.time + g_global.time;
  r2.yz = v0.xy * pdistort_coords + r2.yy;
  r3.xyzw = pDistortionMap_texture.Sample(pDistortionMap_sampler_s, r2.yz).xyzw;
  r1.x = r3.x * pDistortionScale + r1.x;
  r2.x = r3.y * pDistortionScale + r2.x;
  r2.x = r2.x / ScreenDimensions.y;
  r1.x = r1.x / ScreenDimensions.x;
  r3.xyzw = pOpacityMap_texture.Sample(pOpacityMap_sampler_s, v0.xy).xyzw;
  r2.y = 1.39999998 * r3.y;
  r3.x = r1.x * r2.y + v0.x;
  r3.y = r2.x * r2.y + v0.y;
  r2.xyzw = FrameBuffer_texture.Sample(FrameBuffer_sampler_s, r3.xy).xyzw;

  float3 ungraded = r2.rgb;

  r1.x = r2.x + r2.y;
  r1.x = r1.x + r2.z;
  r2.w = -r1.x * 0.25 + 1;
  r2.w = r2.w + r2.w;
  r0.yzw = -r2.www * r0.yzw + float3(1,1,1);
  r2.w = 0.5 * r1.x;
  r1.x = cmp(r1.x < 2);
  r1.yzw = r2.www * r1.yzw;
  r0.yzw = r1.xxx ? r1.yzw : r0.yzw;
  r1.xyz = float3(3.5,1.5,1) * r2.xxx;
  r3.xyz = float3(1,1,1) + -r2.xyz;
  r4.xyz = float3(0.5,0.5,0.5) * r3.xyz;
  r1.xyz = r4.xyz / r1.xyz;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r4.xyz = float3(1.75,0.75,0.5) * r2.xxx;
  r3.xyz = r4.xyz / r3.xyz;
  r4.xyz = r2.xxx * float3(3.5,1.5,1) + r2.xyz;
  r4.xyz = cmp(r4.xyz < float3(1,1,1));
  r1.xyz = r4.xyz ? r3.xyz : r1.xyz;
  r0.yzw = -r1.xyz * r0.xxx + r0.yzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyz = r0.yzw * float3(0.5,0.5,0.5) + r1.xyz;
  r1.xyz = r2.xyz + -r0.xyz;
  o0.xyz = r3.www * r1.xyz + r0.xyz;
  o0.w = g_instance.fadeAmount;

  //o0.rgb = ungraded;
  return;
}