
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[14];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[12].xy + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.xy = cb0[12].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r2.xyzw = cb0[12].xyxy * float4(-1,1,1,-1) + v1.xyxy;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r1.xyz = r3.xyz + r1.xyz;
  r3.xyzw = t0.Sample(s0_s, v1.xy).xyzw;  // center
  r1.xyz = r3.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  r0.xyz = -r0.xyz * float3(0.200000003,0.200000003,0.200000003) + r3.xyz;
  r0.xyz = max(float3(-0.0250000004,-0.0250000004,-0.0250000004), r0.xyz);
  r0.xyz = min(float3(0.0250000004,0.0250000004,0.0250000004), r0.xyz);
  r0.xyz = r0.xyz * cb0[13].xxx + r3.xyz; // sharpen
  o0.w = r3.w;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  // desat
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[13].yyy * r0.xyz + r0.www;

  r0.xyz = log2(r0.xyz);
  r1.xyz = r0.xyz * float3(0.30102998,0.30102998,0.30102998) + -cb0[8].xxx;
  r1.xyz = cb0[8].zzz * r1.xyz;
  r1.xyz = float3(1.44269502,1.44269502,1.44269502) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(1,1,1) + r1.xyz;
  r1.xyz = cb0[8].yyy / r1.xyz;
  r1.xyz = float3(1,1,1) + -r1.xyz;

  r2.xyz = r0.xyz * float3(0.30102998,0.30102998,0.30102998) + cb0[7].www;
  r2.xyz = cb0[8].www * r2.xyz;
  r3.xyz = float3(0.30102998,0.30102998,0.30102998) * r0.xyz;
  r0.xyz = r0.xyz * float3(0.30102998,0.30102998,0.30102998) + -cb0[7].xxx;
  //r4.xyz = cmp(cb0[8].xxx < r3.xyz);
  //r3.xyz = cmp(r3.xyz < cb0[7].xxx);
  r1.xyz = r3.xyz > cb0[8].xxx ? r1.xyz : r2.xyz;
  r4.xyz = cb0[7].zzz * r0.xyz;
  r4.xyz = float3(1.44269502,1.44269502,1.44269502) * r4.xyz;
  r4.xyz = exp2(r4.xyz);
  r4.xyz = float3(1,1,1) + r4.xyz;
  r4.xyz = cb0[7].yyy / r4.xyz;
  r2.xyz = r3.xyz < cb0[7].xxx ? r4.xyz : r2.xyz;
  r3.xyz = r2.xyz + -r1.xyz;
  r0.w = cb0[8].x + -cb0[7].x;
  r0.xyz = saturate(r0.xyz / r0.www);
  r3.xyz = r0.xyz * r3.xyz + r1.xyz;
  r1.xyz = -r2.xyz + r1.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  //r0.w = cmp(cb0[8].x < cb0[7].x);
  r0.xyz = saturate(cb0[8].x < cb0[7].x ? r3.xyz : r0.xyz);
  o0.xyz = cb0[10].xyz * r0.xyz;
  return;
}