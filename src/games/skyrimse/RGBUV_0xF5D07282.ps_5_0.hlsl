// ---- Created with 3Dmigoto v1.3.16 on Wed Mar 04 20:10:41 2026
// ---- Modified: UV clamping removed
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[12];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[45];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0.5 < cb2[0].x);
  r0.yzw = float3(0,9999999,-9999999);
  r1.x = 0;
  while (true) {
    r1.y = cmp((int)r1.x >= 4);
    if (r1.y != 0) break;
    r1.yz = cb2[r1.x+7].xy * cb2[6].xy + v1.xy;
    // -- Clamping removed: sample directly with unclamped UVs --
    r2.xyz = t0.Sample(s0_s, r1.yz).xyz;
    r1.y = dot(float3(0.212500006,0.715399981,0.0720999986), r2.xyz);
    r0.yzw = r1.yyy * cb2[r1.x+7].zzz + r0.yyy;
    r1.x = (int)r1.x + 1;
  }
  o0.xyz = r0.yzw;
  o0.w = cb2[6].z;
  return;
}
