#include "./common.hlsl"

cbuffer cbMaterial : register(b1){
  float4 g_gamma : packoffset(c0);
  float4 g_fadeScene : packoffset(c1);
  float4 g_fadeGUI : packoffset(c2);
  float4 g_ScaleAndOffset : packoffset(c3);
  float4 g_HdrCurve : packoffset(c4);
}
SamplerState g_Sampler_LinearClamp_s : register(s1);
Texture2D<float4> g_Texture : register(t0);
Texture2D<float4> g_TextureUI : register(t1);
Texture2D<float4> g_TextureWorldUI : register(t2);

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  g_TextureWorldUI.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = v1.xy * r0.xy + float2(-0.5,-0.5);
  r0.zw = floor(r0.zw);
  r1.xyzw = float4(0.5,0.5,-0.5,-0.5) + r0.zwzw;
  r0.zw = float2(2.5,2.5) + r0.zw;
  r2.xy = v1.yx * r0.yx + -r1.yx;
  r0.xy = float2(1,1) / r0.xy;
  r2.zw = r2.yx * r2.yx;
  r3.xy = r2.zw * r2.yx;
  r3.zw = float2(2.5,2.5) * r2.wz;
  r3.xy = r3.yx * float2(1.5,1.5) + -r3.zw;
  r3.xy = float2(1,1) + r3.xy;
  r3.zw = r2.wz * r2.xy + r2.xy;
  r2.xy = r2.zw * r2.yx + -r2.zw;
  r2.zw = -r3.zw * float2(0.5,0.5) + r2.wz;
  r3.zw = float2(1,1) + -r2.wz;
  r3.zw = r3.zw + -r3.yx;
  r3.zw = -r2.xy * float2(0.5,0.5) + r3.zw;
  r2.xy = float2(0.5,0.5) * r2.xy;
  r3.xy = r3.xy + r3.wz;
  r3.zw = r3.zw / r3.yx;
  r1.xy = r3.zw + r1.xy;
  r4.xyzw = r1.xyzw * r0.xyxy;
  r0.xy = r0.zw * r0.xy;
  r1.xyzw = g_TextureWorldUI.SampleLevel(g_Sampler_LinearClamp_s, r4.zy, 0).xyzw;
  r5.xyzw = g_TextureWorldUI.SampleLevel(g_Sampler_LinearClamp_s, r4.xw, 0).xyzw;
  r2.zw = r3.yx * r2.zw;
  r1.xyzw = r2.wwww * r1.xyzw;
  r1.xyzw = r5.xyzw * r2.zzzz + r1.xyzw;
  r2.z = r2.z + r2.w;
  r2.z = r3.y * r3.x + r2.z;
  r2.z = r2.x * r3.x + r2.z;
  r2.z = r2.y * r3.y + r2.z;
  r2.xy = r3.xy * r2.xy;
  r2.w = r3.y * r3.x;
  r3.xyzw = g_TextureWorldUI.SampleLevel(g_Sampler_LinearClamp_s, r4.xy, 0).xyzw;
  r0.zw = r4.yx;
  r1.xyzw = r3.xyzw * r2.wwww + r1.xyzw;
  r3.xyzw = g_TextureWorldUI.SampleLevel(g_Sampler_LinearClamp_s, r0.xz, 0).xyzw;
  r0.xyzw = g_TextureWorldUI.SampleLevel(g_Sampler_LinearClamp_s, r0.wy, 0).xyzw;
  r1.xyzw = r3.xyzw * r2.xxxx + r1.xyzw;
  r0.xyzw = r0.xyzw * r2.yyyy + r1.xyzw;
  r0.xyzw = r0.xyzw / r2.zzzz;
  r1.xyz = g_fadeScene.xyz + -r0.xyz;
  r0.xyz = g_fadeScene.www * r1.xyz + r0.xyz;
  r1.xyz = g_fadeGUI.xyz + -r0.xyz;
  r0.xyz = g_fadeGUI.www * r1.xyz + r0.xyz;
  g_Texture.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r1.xy = fDest.xy;
  r1.zw = v1.xy * r1.xy + float2(-0.5,-0.5);
  r1.zw = floor(r1.zw);
  r2.xyzw = float4(0.5,0.5,-0.5,-0.5) + r1.zwzw;
  r1.zw = float2(2.5,2.5) + r1.zw;
  r3.xy = v1.yx * r1.yx + -r2.yx;
  r1.xy = float2(1,1) / r1.xy;
  r3.zw = r3.yx * r3.yx;
  r4.xy = r3.zw * r3.yx;
  r4.zw = float2(2.5,2.5) * r3.wz;
  r4.xy = r4.yx * float2(1.5,1.5) + -r4.zw;
  r4.xy = float2(1,1) + r4.xy;
  r4.zw = r3.wz * r3.xy + r3.xy;
  r3.xy = r3.zw * r3.yx + -r3.zw;
  r3.zw = -r4.zw * float2(0.5,0.5) + r3.wz;
  r4.zw = float2(1,1) + -r3.wz;
  r4.zw = r4.zw + -r4.yx;
  r4.zw = -r3.xy * float2(0.5,0.5) + r4.zw;
  r3.xy = float2(0.5,0.5) * r3.xy;
  r4.xy = r4.xy + r4.wz;
  r4.zw = r4.zw / r4.yx;
  r2.xy = r4.zw + r2.xy;
  r5.xyzw = r2.xyzw * r1.xyxy;
  r1.xy = r1.zw * r1.xy;
  r2.xyz = g_Texture.SampleLevel(g_Sampler_LinearClamp_s, r5.zy, 0).xyz;
  r6.xyz = g_Texture.SampleLevel(g_Sampler_LinearClamp_s, r5.xw, 0).xyz;
  r3.zw = r4.yx * r3.zw;
  r2.xyz = r3.www * r2.xyz;
  r2.xyz = r6.xyz * r3.zzz + r2.xyz;
  r2.w = r3.z + r3.w;
  r2.w = r4.y * r4.x + r2.w;
  r2.w = r3.x * r4.x + r2.w;
  r2.w = r3.y * r4.y + r2.w;
  r3.xy = r4.xy * r3.xy;
  r3.z = r4.y * r4.x;
  r4.xyz = g_Texture.SampleLevel(g_Sampler_LinearClamp_s, r5.xy, 0).xyz;
  r1.zw = r5.yx;
  r2.xyz = r4.xyz * r3.zzz + r2.xyz;
  r4.xyz = g_Texture.SampleLevel(g_Sampler_LinearClamp_s, r1.xz, 0).xyz;
  r1.xyz = g_Texture.SampleLevel(g_Sampler_LinearClamp_s, r1.wy, 0).xyz;
  r2.xyz = r4.xyz * r3.xxx + r2.xyz;
  r1.xyz = r1.xyz * r3.yyy + r2.xyz;
  r1.xyz = r1.xyz / r2.www;
  r2.xyz = g_fadeScene.xyz + -r1.xyz;
  r1.xyz = g_fadeScene.www * r2.xyz + r1.xyz;
  r2.xyz = g_fadeGUI.xyz + -r1.xyz;
  r1.xyz = g_fadeGUI.www * r2.xyz + r1.xyz;
  r2.xyzw = g_TextureUI.SampleLevel(g_Sampler_LinearClamp_s, v1.xy, 0).xyzw;
  r0.w = r2.w * r0.w;
  r3.xyz = g_fadeGUI.xyz + -r2.xyz;
  r2.xyz = g_fadeGUI.www * r3.xyz + r2.xyz;
  r1.xyz = r1.xyz * r0.www + r2.xyz;
  r0.xyz = r0.xyz * r2.www + r1.xyz;
  o0.xyz = FinalizeOutput(r0.xyz);
  o0.w = 1;
  return;
}