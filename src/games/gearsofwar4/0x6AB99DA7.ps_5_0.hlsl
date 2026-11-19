// ---- Created with 3Dmigoto v1.3.16 on Mon Nov 02 13:18:04 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[7];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[10];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[12];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[58];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD7,
  float4 v4 : SV_Position0,
  uint v5 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyz = cb3[2].xyz * r0.xyz;
  r1.xy = cb3[6].xx * v2.xy;
  r1.y = cb1[11].z * 0.200000003 + r1.y;
  r1.xyz = t1.Sample(s1_s, r1.xy).xyz;
  r1.xyz = cb3[6].yyy * r1.xyz;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r0.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r0.xyz = cb3[3].xyz + r0.xyz;
  r1.w = saturate(cb3[6].z * r0.w);
  r1.xyz = max(float3(0,0,0), r0.xyz);
  r0.x = cmp(0 < cb1[9].x);
  if (r0.x != 0) {
    r0.xyzw = cb0[37].xyzw * v4.yyyy;
    r0.xyzw = v4.xxxx * cb0[36].xyzw + r0.xyzw;
    r0.xyzw = v4.zzzz * cb0[38].xyzw + r0.xyzw;
    r0.xyzw = cb0[39].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = -cb0[57].xyz + r0.xyz;
    r2.xyz = -cb2[8].xyz + r0.xyz;
    r3.xyz = float3(1,1,1) + cb2[9].xyz;
    r2.xyz = cmp(r3.xyz < abs(r2.xyz));
    r0.w = (int)r2.y | (int)r2.x;
    r0.w = (int)r2.z | (int)r0.w;
    r0.x = dot(r0.xyz, float3(0.577000022,0.577000022,0.577000022));
    r0.x = 0.00200000009 * r0.x;
    r0.x = frac(r0.x);
    r0.x = cmp(0.5 < r0.x);
    r2.yzw = r0.xxx ? float3(0,1,1) : float3(1,1,0);
    r2.x = 1;
    r1.xyzw = r0.wwww ? r2.yzwx : r1.xyzw;
  }
  r1.xyz = r1.xyz * v3.www + v3.xyz;
  // The reload flare is drawn after scene mapping into the HDR proxy.
  // Restore its SDR UI bound before blending; retain the secondary-output scale.
  r1 = saturate(r1);
  o2.xyzw = float4(0.782608688,0.782608688,0.782608688,0.782608688) * r1.xyzw;
  o0.xyzw = r1.xyzw;
  return;
}