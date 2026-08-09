Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[143];
}

// MOUSE: P.I. For Hire

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[2].xy + v1.xy;
  r0.zw = cb1[1].zw + r0.xy;
  r1.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r0.xy = cb1[1].xy * r0.zw;
  r0.xyzw = t1.SampleBias(s1_s, r0.xy, cb0[4].x).xyzw;
  r2.x = -r0.w * cb0[142].w + 1;
  r1.xyz = r2.xxx * r1.xyz;
  o0.w = r1.w;
  r0.w = cb0[142].w * r0.w;
  r0.w = r0.w * r0.w;
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(-0.0275523961,-0.0275523961,-0.0275523961);
  r0.xyz = r0.xyz * cb0[142].xxx + cb0[142].zzz;
  r0.xyz = float3(0.0275523961,0.0275523961,0.0275523961) + r0.xyz;
  r0.xyz = float3(13.6054821,13.6054821,13.6054821) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.0479959995,-0.0479959995,-0.0479959995) + r0.xyz;
  r0.xyz = float3(0.179999992,0.179999992,0.179999992) * r0.xyz;
  o0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), cb0[142].y);
  o0.w = saturate(o0.w);
  return;
}