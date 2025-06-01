// ---- Created with 3Dmigoto v1.4.1 on Fri May 30 01:02:37 2025

cbuffer GFD_PSCONST_SYSTEM : register(b0)
{
  float2 gfdResolution : packoffset(c0);
  float2 gfdResolutionRev : packoffset(c0.z);
  float4x4 gfdMtxInvView : packoffset(c1);
  float4 gfdInvProjParams : packoffset(c5);
}

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> srcBuffer : register(t0);


// 3Dmigoto declarations
#define cmp -

// FIND A WAY TO FIX FXAA AND SMAA!
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(0, -1)).xyz;
  r1.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(-1, 0)).xyz;
  r2.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(0, 0)).xyz;
  r3.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(1, 0)).xyz;
  r4.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(0, 1)).xyz;
  r0.w = r0.y * 1.9632107 + r0.x;
  r1.w = r1.y * 1.9632107 + r1.x;
  r2.w = r2.y * 1.9632107 + r2.x;
  r3.w = r3.y * 1.9632107 + r3.x;
  r4.w = r4.y * 1.9632107 + r4.x;
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
  r5.y = cmp(r5.x >= r5.y);
  if (r5.y != 0) {
    r0.xyz = r1.xyz + r0.xyz;
    r0.xyz = r0.xyz + r2.xyz;
    r0.xyz = r0.xyz + r3.xyz;
    r0.xyz = r0.xyz + r4.xyz;
    r1.x = r1.w + r0.w;
    r1.x = r1.x + r3.w;
    r1.x = r1.x + r4.w;
    r1.x = r1.x * 0.25 + -r2.w;
    r1.x = abs(r1.x) / r5.x;
    r1.x = -0.25 + r1.x;
    r1.x = max(0, r1.x);
    r1.x = 1.33333337 * r1.x;
    r1.x = min(0.75, r1.x);
    r3.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(-1, -1)).xyz;
    r4.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(1, -1)).xyz;
    r5.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(-1, 1)).xyz;
    r6.xyz = srcBuffer.SampleLevel(LinearSampler_s, v1.xy, 0, int2(1, 1)).xyz;
    r7.xyz = r4.xyz + r3.xyz;
    r7.xyz = r7.xyz + r5.xyz;
    r7.xyz = r7.xyz + r6.xyz;
    r0.xyz = r7.xyz + r0.xyz;
    r0.xyz = r0.xyz * r1.xxx;
    r1.y = r3.y * 1.9632107 + r3.x;
    r1.z = r4.y * 1.9632107 + r4.x;
    r3.x = r5.y * 1.9632107 + r5.x;
    r3.y = r6.y * 1.9632107 + r6.x;
    r3.z = -0.5 * r0.w;
    r3.z = r1.y * 0.25 + r3.z;
    r3.z = r1.z * 0.25 + r3.z;
    r4.x = -0.5 * r1.w;
    r4.y = r1.w * 0.5 + -r2.w;
    r4.z = -0.5 * r3.w;
    r4.y = r3.w * 0.5 + r4.y;
    r3.z = abs(r4.y) + abs(r3.z);
    r4.y = -0.5 * r4.w;
    r4.y = r3.x * 0.25 + r4.y;
    r4.y = r3.y * 0.25 + r4.y;
    r3.z = abs(r4.y) + r3.z;
    r1.y = r1.y * 0.25 + r4.x;
    r1.y = r3.x * 0.25 + r1.y;
    r3.x = r0.w * 0.5 + -r2.w;
    r3.x = r4.w * 0.5 + r3.x;
    r1.y = abs(r3.x) + abs(r1.y);
    r1.z = r1.z * 0.25 + r4.z;
    r1.z = r3.y * 0.25 + r1.z;
    r1.y = r1.y + abs(r1.z);
    r1.y = cmp(r1.y >= r3.z);
    r1.z = r1.y ? -gfdResolutionRev.y : -gfdResolutionRev.x;
    r0.w = r1.y ? r0.w : r1.w;
    r1.w = r1.y ? r4.w : r3.w;
    r3.x = r0.w + -r2.w;
    r3.y = r1.w + -r2.w;
    r0.w = r0.w + r2.w;
    r0.w = 0.5 * r0.w;
    r1.w = r1.w + r2.w;
    r1.w = 0.5 * r1.w;
    r3.z = cmp(abs(r3.x) >= abs(r3.y));
    r0.w = r3.z ? r0.w : r1.w;
    r1.w = r3.z ? abs(r3.x) : abs(r3.y);
    r1.z = r3.z ? r1.z : -r1.z;
    r3.x = 0.5 * r1.z;
    r3.y = r1.y ? 0 : r3.x;
    r3.x = r1.y ? r3.x : 0;
    r4.xy = v1.xy + r3.yx;
    r1.w = 0.25 * r1.w;
    r3.yz = float2(0,0);
    r3.xw = gfdResolutionRev.xy;
    r3.xy = r1.yy ? r3.xy : r3.zw;
    r3.zw = r4.xy + -r3.xy;
    r4.xy = r4.xy + r3.xy;
    r4.zw = r3.zw;
    r5.xy = r4.xy;
    r5.zw = r0.ww;
    r6.xyz = float3(0,0,0);
    while (true) {
      r6.w = cmp((int)r6.z >= 16);
      if (r6.w != 0) break;
      if (r6.x == 0) {
        r7.xy = srcBuffer.SampleLevel(LinearSampler_s, r4.zw, 0).xy;
        r6.w = r7.y * 1.9632107 + r7.x;
      } else {
        r6.w = r5.z;
      }
      if (r6.y == 0) {
        r7.xy = srcBuffer.SampleLevel(LinearSampler_s, r5.xy, 0).xy;
        r7.x = r7.y * 1.9632107 + r7.x;
      } else {
        r7.x = r5.w;
      }
      r7.y = r6.w + -r0.w;
      r7.y = cmp(abs(r7.y) >= r1.w);
      r6.x = (int)r6.x | (int)r7.y;
      r7.y = r7.x + -r0.w;
      r7.y = cmp(abs(r7.y) >= r1.w);
      r6.y = (int)r6.y | (int)r7.y;
      r7.y = (int)r6.y & (int)r6.x;
      if (r7.y != 0) {
        r5.z = r6.w;
        r5.w = r7.x;
        break;
      }
      r7.yz = r4.zw + -r3.xy;
      r4.zw = r6.xx ? r4.zw : r7.yz;
      r7.yz = r5.xy + r3.xy;
      r5.xy = r6.yy ? r5.xy : r7.yz;
      r6.z = (int)r6.z + 1;
      r5.z = r6.w;
      r5.w = r7.x;
    }
    r3.xy = v1.xy + -r4.zw;
    r1.w = r1.y ? r3.x : r3.y;
    r3.xy = -v1.xy + r5.xy;
    r3.x = r1.y ? r3.x : r3.y;
    r3.y = cmp(r1.w < r3.x);
    r3.z = r3.y ? r5.z : r5.w;
    r2.w = r2.w + -r0.w;
    r2.w = cmp(r2.w < 0);
    r0.w = r3.z + -r0.w;
    r0.w = cmp(r0.w < 0);
    r0.w = cmp((int)r0.w == (int)r2.w);
    r0.w = r0.w ? 0 : r1.z;
    r1.z = r3.x + r1.w;
    r1.w = r3.y ? r1.w : r3.x;
    r1.z = -1 / r1.z;
    r1.z = r1.w * r1.z + 0.5;
    r0.w = r1.z * r0.w;
    r1.z = r1.y ? 0 : r0.w;
    r3.x = v1.x + r1.z;
    r0.w = r1.y ? r0.w : 0;
    r3.y = v1.y + r0.w;
    r1.yzw = srcBuffer.SampleLevel(LinearSampler_s, r3.xy, 0).xyz;
    r0.xyz = r0.xyz * float3(0.111111112,0.111111112,0.111111112) + r1.yzw;
    r2.xyz = -r1.xxx * r1.yzw + r0.xyz;
  }
  o0.xyz = r2.xyz;
  o0.w = 1;
  return;
}