// ---- Created with 3Dmigoto v1.3.16 on Sat Apr 13 19:54:12 2024

cbuffer Buff2 : register(b2)
{
  float4 BloomFactors : packoffset(c45);
  float4 ColorControlSettings : packoffset(c41);
}

cbuffer HardCodedConstants : register(b12)
{
  float4 g_SampleCoverageULLRegister : packoffset(c0);
  float4 DiffuseTexture_ULLRegister : packoffset(c1);
}

cbuffer DX11Internal : register(b13)
{
  int ClipPlaneBits : packoffset(c0);
  float4 ClipPlanes[8] : packoffset(c1);
  int4 AlphaTest : packoffset(c9);
}

SamplerState DiffuseTexture_S_s : register(s0);
SamplerState _RotatedPoissonTexture_Sampler_s : register(s8);
Texture2D<float4> DiffuseTexture_T : register(t0);
Texture2D<float4> _RotatedPoissonTexture_Tex : register(t8);
Texture2D<uint> StencilTexture_T : register(t11);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : CLIP_SPACE_POSITION0,
  float4 v2 : SV_ClipDistance0,
  float4 v3 : SV_ClipDistance1,
  float4 v4 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(0.03125,0.03125) * v0.xy;
  r0.xyzw = _RotatedPoissonTexture_Tex.Sample(_RotatedPoissonTexture_Sampler_s, r0.xy).xyzw;
  r0.xy = r0.xx * float2(1,-1) + float2(0,1);
  r0.xy = -g_SampleCoverageULLRegister.xy + r0.xy;
  r0.xy = g_SampleCoverageULLRegister.zw * r0.xy;
  r0.x = r0.x + r0.y;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyzw = DiffuseTexture_T.Sample(DiffuseTexture_S_s, v4.xy).xyzw;
  r1.x = cmp((int)AlphaTest.x == 1);
  if (r1.x != 0) {
    r1.x = (int)AlphaTest.z;
    r1.x = 0.00392156886 * r1.x;
    r1.y = cmp((int)AlphaTest.y == 5);
    if (r1.y != 0) {
      r1.y = cmp(r1.x >= r0.w);
      if (r1.y != 0) discard;
    } else {
      r1.y = cmp((int)AlphaTest.y == 7);
      if (r1.y != 0) {
        r1.y = cmp(r0.w < r1.x);
        if (r1.y != 0) discard;
      } else {
        r1.y = cmp((int)AlphaTest.y == 4);
        if (r1.y != 0) {
          r1.y = cmp(r1.x < r0.w);
          if (r1.y != 0) discard;
        } else {
          r1.y = cmp((int)AlphaTest.y == 1);
          if (r1.y != 0) {
            if (-1 != 0) discard;
          } else {
            r1.yzw = cmp((int3)AlphaTest.yyy == int3(2,3,6));
            r2.x = cmp(r0.w >= r1.x);
            r2.x = r1.y ? r2.x : 0;
            if (r2.x != 0) discard;
            r2.xy = ~(int2)r1.yz;
            r1.y = r1.z ? r2.x : 0;
            r1.z = cmp(r0.w != r1.x);
            r1.y = r1.z ? r1.y : 0;
            if (r1.y != 0) discard;
            r1.y = r2.x ? r2.y : 0;
            r1.y = r1.w ? r1.y : 0;
            r1.x = cmp(r0.w == r1.x);
            r1.x = r1.x ? r1.y : 0;
            if (r1.x != 0) discard;
          }
        }
      }
    }
  }
  r1.xyz = float3(0.300000012,0.589999974,0.109999999) * r0.xyz;
  r1.y = max(r1.y, r1.z);
  r1.x = max(r1.x, r1.y);
  StencilTexture_T.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r2.xyzw = fDest.xyzw;
  r1.yz = v4.xy * r2.xy;
  r2.xy = (int2)r1.yz;
  r2.zw = float2(0,0);
  r2.x = StencilTexture_T.Load(r2.xyz).x;
  r1.y = (uint)r2.x;
  r1.y = 0.00392156886 * r1.y;
  r1.y = cmp(r1.y < ColorControlSettings.w);
  r1.x = saturate(-BloomFactors.w + r1.x);
  r1.x = r1.y ? 0 : r1.x;
  o0.xyz = r1.xxx * r0.xyz;
  o0.w = r0.w;
  return;
}