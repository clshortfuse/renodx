// ---- Created with 3Dmigoto v1.3.16 on Sat Apr 13 19:54:33 2024

cbuffer Buff2 : register(b2)
{
  float4 WindowSize : packoffset(c29);
}

cbuffer HardCodedConstants : register(b12)
{
  float4 g_SampleCoverageULLRegister : packoffset(c0);
  float4 tex_ULLRegister : packoffset(c1);
}

SamplerState tex_S_s : register(s0);
SamplerState _RotatedPoissonTexture_Sampler_s : register(s8);
Texture2D<float4> tex_T : register(t0);
Texture2D<float4> _RotatedPoissonTexture_Tex : register(t8);


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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
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
  r0.xyzw = WindowSize.zwzw * float4(0,-1,-1,0) + v4.xyxy;
  r1.xyzw = tex_T.SampleLevel(tex_S_s, r0.xy, 0).xyzw;
  r0.xyzw = tex_T.SampleLevel(tex_S_s, r0.zw, 0).xyzw;
  r2.xyzw = tex_T.SampleLevel(tex_S_s, v4.xy, 0).xyzw;
  r3.xyzw = WindowSize.zwzw * float4(1,0,0,1) + v4.xyxy;
  r4.xyzw = tex_T.SampleLevel(tex_S_s, r3.xy, 0).xyzw;
  r3.xyzw = tex_T.SampleLevel(tex_S_s, r3.zw, 0).xyzw;
  r0.w = r1.y * 1.9632107 + r1.x;
  r1.w = r0.y * 1.9632107 + r0.x;
  r2.w = r2.y * 1.9632107 + r2.x;
  r3.w = r4.y * 1.9632107 + r4.x;
  r4.w = r3.y * 1.9632107 + r3.x;
  r5.x = min(r1.w, r0.w);
  r5.y = min(r4.w, r3.w);
  r5.x = min(r5.x, r5.y);
  r5.x = min(r5.x, r2.w);
  r5.y = max(r1.w, r0.w);
  r5.z = max(r4.w, r3.w);
  r5.y = max(r5.y, r5.z);
  r5.y = max(r5.y, r2.w);
  r5.x = r5.y + -r5.x;
  r5.y = 0.125 * r5.y;
  r5.y = max(0.0416666679, r5.y);
  r5.y = cmp(r5.x < r5.y);
  if (r5.y != 0) {
    o0.xyz = r2.xyz;
    o0.w = 1;
    return;
  }
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  r0.xyz = r0.xyz + r4.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r1.x = r1.w + r0.w;
  r1.x = r1.x + r3.w;
  r1.x = r1.x + r4.w;
  r1.x = r1.x * 0.25 + -r2.w;
  r1.x = abs(r1.x) / r5.x;
  r1.x = -0.25 + r1.x;
  r1.x = max(0, r1.x);
  r1.x = 1.33333337 * r1.x;
  r1.x = min(0.75, r1.x);
  r1.yz = -WindowSize.zw + v4.xy;
  r5.xyzw = tex_T.SampleLevel(tex_S_s, r1.yz, 0).xyzw;
  r6.xyzw = WindowSize.zwzw * float4(1,-1,-1,1) + v4.xyxy;
  r7.xyzw = tex_T.SampleLevel(tex_S_s, r6.xy, 0).xyzw;
  r6.xyzw = tex_T.SampleLevel(tex_S_s, r6.zw, 0).xyzw;
  r1.yz = WindowSize.zw + v4.xy;
  r8.xyzw = tex_T.SampleLevel(tex_S_s, r1.yz, 0).xyzw;
  r2.xyz = r7.xyz + r5.xyz;
  r2.xyz = r2.xyz + r6.xyz;
  r2.xyz = r2.xyz + r8.xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz * r1.xxx;
  r1.y = r5.y * 1.9632107 + r5.x;
  r1.z = r7.y * 1.9632107 + r7.x;
  r2.x = r6.y * 1.9632107 + r6.x;
  r2.y = r8.y * 1.9632107 + r8.x;
  r2.z = -0.5 * r0.w;
  r2.z = r1.y * 0.25 + r2.z;
  r2.z = r1.z * 0.25 + r2.z;
  r3.x = -0.5 * r1.w;
  r3.y = r1.w * 0.5 + -r2.w;
  r3.z = -0.5 * r3.w;
  r3.y = r3.w * 0.5 + r3.y;
  r2.z = abs(r3.y) + abs(r2.z);
  r3.y = -0.5 * r4.w;
  r3.y = r2.x * 0.25 + r3.y;
  r3.y = r2.y * 0.25 + r3.y;
  r2.z = abs(r3.y) + r2.z;
  r1.y = r1.y * 0.25 + r3.x;
  r1.y = r2.x * 0.25 + r1.y;
  r2.x = r0.w * 0.5 + -r2.w;
  r2.x = r4.w * 0.5 + r2.x;
  r1.y = abs(r2.x) + abs(r1.y);
  r1.z = r1.z * 0.25 + r3.z;
  r1.z = r2.y * 0.25 + r1.z;
  r1.y = r1.y + abs(r1.z);
  r1.y = cmp(r1.y >= r2.z);
  r1.z = r1.y ? -WindowSize.w : -WindowSize.z;
  r0.w = r1.y ? r0.w : r1.w;
  r1.w = r1.y ? r4.w : r3.w;
  r2.x = r0.w + -r2.w;
  r2.y = r1.w + -r2.w;
  r0.w = r0.w + r2.w;
  r0.w = 0.5 * r0.w;
  r1.w = r1.w + r2.w;
  r1.w = 0.5 * r1.w;
  r2.z = cmp(abs(r2.x) >= abs(r2.y));
  r0.w = r2.z ? r0.w : r1.w;
  r1.w = max(abs(r2.x), abs(r2.y));
  r1.z = r2.z ? r1.z : -r1.z;
  r2.x = 0.5 * r1.z;
  r2.y = r1.y ? 0 : r2.x;
  r2.x = r1.y ? r2.x : 0;
  r3.xy = v4.xy + r2.yx;
  r1.w = 0.25 * r1.w;
  r4.yz = float2(0,0);
  r4.xw = WindowSize.zw;
  r2.xy = r1.yy ? r4.xy : r4.zw;
  r3.zw = r3.xy + -r2.xy;
  r3.xy = r3.xy + r2.xy;
  r4.xyzw = r3.zwxy;
  r2.z = r0.w;
  r5.x = r0.w;
  r5.yzw = float3(0,0,0);
  while (true) {
    r6.x = cmp((int)r5.w >= 8);
    if (r6.x != 0) break;
    if (r5.y == 0) {
      r6.xyzw = tex_T.SampleLevel(tex_S_s, r4.xy, 0).xyzw;
      r6.x = r6.y * 1.9632107 + r6.x;
    } else {
      r6.x = r2.z;
    }
    if (r5.z == 0) {
      r7.xyzw = tex_T.SampleLevel(tex_S_s, r4.zw, 0).xyzw;
      r6.y = r7.y * 1.9632107 + r7.x;
    } else {
      r6.y = r5.x;
    }
    r6.z = r6.x + -r0.w;
    r6.z = cmp(abs(r6.z) >= r1.w);
    r5.y = (int)r5.y | (int)r6.z;
    r6.z = r6.y + -r0.w;
    r6.z = cmp(abs(r6.z) >= r1.w);
    r5.z = (int)r5.z | (int)r6.z;
    r6.z = (int)r5.z & (int)r5.y;
    if (r6.z != 0) {
      r2.z = r6.x;
      r5.x = r6.y;
      break;
    }
    r6.zw = r4.xy + -r2.xy;
    r4.xy = r5.yy ? r4.xy : r6.zw;
    r6.zw = r4.zw + r2.xy;
    r4.zw = r5.zz ? r4.zw : r6.zw;
    r5.w = (int)r5.w + 1;
    r2.z = r6.x;
    r5.x = r6.y;
  }
  r2.xy = v4.xy + -r4.xy;
  r1.w = r1.y ? r2.x : r2.y;
  r2.xy = -v4.xy + r4.zw;
  r2.x = r1.y ? r2.x : r2.y;
  r2.y = cmp(r1.w < r2.x);
  r2.y = r2.y ? r2.z : r5.x;
  r2.z = r2.w + -r0.w;
  r2.z = cmp(r2.z < 0);
  r0.w = r2.y + -r0.w;
  r0.w = cmp(r0.w < 0);
  r0.w = cmp((int)r2.z == (int)r0.w);
  r0.w = r0.w ? 0 : r1.z;
  r1.z = r2.x + r1.w;
  r1.w = min(r2.x, r1.w);
  r1.z = -1 / r1.z;
  r1.z = r1.w * r1.z + 0.5;
  r0.w = r1.z * r0.w;
  r1.z = r1.y ? 0 : r0.w;
  r2.x = v4.x + r1.z;
  r0.w = r1.y ? r0.w : 0;
  r2.y = v4.y + r0.w;
  r2.xyzw = tex_T.SampleLevel(tex_S_s, r2.xy, 0).xyzw;
  r0.xyz = r0.xyz * float3(0.111111112,0.111111112,0.111111112) + r2.xyz;
  o0.xyz = -r1.xxx * r2.xyz + r0.xyz;
  o0.w = 1;
  return;
}