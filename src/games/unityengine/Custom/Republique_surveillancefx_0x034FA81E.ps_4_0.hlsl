cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[7].xxx * cb0[6].xyx;
  r0.xyz = frac(r0.xyz);
  r0.xyz = v1.yyy + r0.xyz;
  r0.xyz = cb0[5].xyz * r0.xyz;
  r0.xyz = frac(r0.xyz);
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.x = -r0.x * r0.x + 1;
  r0.w = 1 + -cb0[6].z;
  r0.x = cb0[6].z * r0.x + r0.w;
  r0.x = log2(r0.x);
  r0.x = 2.10970473 * r0.x;
  r0.x = exp2(r0.x);
  o0.x = 0.962813556 * r0.x;
  r0.x = r0.y * r0.y;
  r0.y = log2(r0.z);
  r0.y = 2.10970473 * r0.y;
  r0.y = exp2(r0.y);
  r0.x = cb0[6].w * r0.x;
  r0.x = log2(r0.x);
  r0.x = 2.10970473 * r0.x;
  r0.x = exp2(r0.x);
  o0.yz = float2(0.962813556,0.962813556) * r0.xy;
  o0.w = 0;
  o0.xyz = saturate(o0.xyz);
  return;
}