// Stolen from Luma!

Texture2D<float4> t1 : register(t1);
Texture2D<uint4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3) { float4 cb3[3]; }

cbuffer cb2 : register(b2) { float4 cb2[7]; }

cbuffer cb1 : register(b1) { float4 cb1[133]; }

cbuffer cb0 : register(b0) { float4 cb0[39]; }

void main(float4 v0: SV_POSITION0, out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  r0.xy = asuint(cb0[37].xy);
  r0.xy = v0.xy + -r0.xy;
  r0.xy = cb0[38].zw * r0.xy;
  r0.zw = r0.xy * cb1[130].xy + cb1[129].xy;
  r0.xy = r0.xy * cb0[5].xy + cb0[4].xy;
  r1.xyz = t1.Sample(s0_s, r0.xy).xyz;
  r0.xy = cb1[132].zw * r0.zw;
  r0.xy = cb1[132].xy * r0.xy;
  r0.xy = trunc(r0.xy);
  int4 r0i;
  r0i.xy = r0.xy;
  r0i.zw = 0;
  r0i.x = t0.Load(r0i.xyz).y;
  r0.x = r0i.x;
  r0.y = min(1, r0.x);
  r2.xyzw = saturate(float4(-1, -2, -3, -4) + r0.xxxx);
  r3.xyzw = float4(1, 1, 1, 1) + -r2.xyzw;
  r0.xzw = r3.yzw * r2.xyz;
  r0.y = r3.x * r0.y;
  r2.xyz = cb3[2].xxx * cb2[0].xyz + -r1.xyz;
  r2.xyz = r0.yyy * r2.xyz + r1.xyz;
  r3.xyz = cb3[2].xxx * cb2[2].xyz + -r2.xyz;
  r2.xyz = r0.xxx * r3.xyz + r2.xyz;
  r3.xyz = cb3[2].xxx * cb2[4].xyz + -r2.xyz;
  r0.xyz = r0.zzz * r3.xyz + r2.xyz;
  r2.xyz = cb3[2].xxx * cb2[6].xyz + -r0.xyz;
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = cb3[2].yyy * r0.xyz + r1.xyz;
  r1.xyz = cb3[1].xyz + -r0.xyz;
  r0.xyz = cb3[2].zzz * r1.xyz + r0.xyz;
#if 1 // Luma
  o0.xyz = r0.xyz;
#else
  o0.xyz = max(0.0, r0.xyz);
#endif
  o0.w = 1;
}
