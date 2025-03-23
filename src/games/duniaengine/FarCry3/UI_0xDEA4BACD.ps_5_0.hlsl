Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[38];
}

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[22].x + -cb0[21].x;
  r0.x = 1 / r0.x;
  r1.x = cb0[23].x;
  r1.y = cb0[24].x;
  r0.yz = v2.xy + r1.xy;
  r0.y = t0.Sample(s0_s, r0.yz).w;
  r0.y = 1 + -r0.y;
  r0.z = cmp(cb0[23].x != 0.000000);
  r0.w = cmp(cb0[24].x != 0.000000);
  r0.z = (int)r0.w | (int)r0.z;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.w = 1 + -r1.w;
  r0.y = r0.z ? r0.y : r0.w;
  r0.z = -cb0[21].x + r0.y;
  r0.x = saturate(r0.z * r0.x);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.z = cmp(r0.y < cb0[22].x);
  r0.y = cmp(r0.y >= cb0[21].x);
  r0.x = r0.z ? r0.x : 1;
  r2.x = -v1.x * r1.x + cb0[29].x;
  r2.y = -v1.y * r1.y + cb0[30].x;
  r2.z = -v1.z * r1.z + cb0[31].x;
  r3.xyz = v1.xyz * r1.xyz;
  r2.xyz = r0.xxx * r2.xyz + r3.xyz;
  r0.xyz = r0.yyy ? r2.xyz : r3.xyz;
  r2.x = cmp(cb0[21].x != -1.000000);
  r2.xyz = r2.xxx ? r0.xyz : r3.xyz;
  r0.x = -cb0[26].x + cb0[25].x;
  r0.x = 1 / r0.x;
  r4.x = cb0[27].x;
  r4.y = cb0[28].x;
  r0.yz = v2.xy + r4.xy;
  r0.y = t0.Sample(s0_s, r0.yz).w;
  r0.y = 1 + -r0.y;
  r0.z = cmp(cb0[27].x != 0.000000);
  r4.x = cmp(cb0[28].x != 0.000000);
  r0.z = (int)r0.z | (int)r4.x;
  r0.y = r0.z ? r0.y : r0.w;
  r0.z = -cb0[26].x + r0.y;
  r0.x = saturate(r0.z * r0.x);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.z = cmp(cb0[25].x < r0.y);
  r0.y = cmp(cb0[26].x >= r0.y);
  r4.w = r0.z ? r0.x : 1;
  r0.x = -cb0[20].x + cb0[19].x;
  r0.x = 1 / r0.x;
  r0.z = -cb0[20].x + r0.w;
  r0.w = cmp(cb0[20].x >= r0.w);
  r0.w = r0.w ? 1.000000 : 0;
  r0.x = saturate(r0.z * r0.x);
  r0.z = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.z * r0.x;
  r0.z = cmp(cb0[19].x != cb0[20].x);
  r2.w = r0.z ? r0.x : r0.w;
  r4.x = cb0[33].x;
  r4.y = cb0[34].x;
  r4.z = cb0[35].x;
  r5.xyzw = -r4.xyzw + r2.xyzw;
  r4.xyzw = r2.wwww * r5.xyzw + r4.xyzw;
  r0.xyzw = r0.yyyy ? r4.xyzw : r2.xyzw;
  r4.x = cmp(cb0[25].x != -1.000000);
  r0.xyzw = r4.xxxx ? r0.xyzw : r2.xyzw;
  r0.xyzw = r0.xyzw * cb0[17].xyzw + cb0[18].xyzw;
  r2.x = cmp(cb0[19].x != -1.000000);
  r3.w = 1;
  r1.xyzw = r3.xyzw * r1.xyzw;
  r0.xyzw = r2.xxxx ? r0.xyzw : r1.xyzw;
  r0.xyz = log2(r0.xyz);
  o0.w = r0.w;
  r0.xyz = cb0[37].zzz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = saturate(cb0[37].xxx + r0.xyz);
  r0.xyz = cb0[37].yyy * r0.xyz;
  o0.xyz = sqrt(r0.xyz);
  return;
}