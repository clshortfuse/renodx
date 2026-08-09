Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[9];
}
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[5].zw * v2.xy;
  r0.xy = cb0[15].yy * cb1[6].xy + r0.xy;
  r0.xy = cb1[8].yy * r0.xy;
  r0.zw = floor(r0.xy);
  r0.xy = frac(r0.xy);
  r1.xy = float2(1,1) + r0.zw;
  r1.xy = r1.xy * float2(0.318309903,0.367879391) + float2(0.367879391,0.318309903);
  r1.z = r1.x * r1.y;
  r1.x = r1.x + r1.y;
  r1.x = r1.z * r1.x;
  r1.x = frac(r1.x);
  r1.xy = float2(5.09295845,5.88607025) * r1.xx;
  r1.xy = frac(r1.xy);
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r1.zw = float2(-1,-1) + r0.xy;
  r1.x = dot(r1.xy, r1.zw);
  r2.xyzw = float4(1,0,0,1) + r0.zwzw;
  r0.zw = r0.zw * float2(0.318309903,0.367879391) + float2(0.367879391,0.318309903);
  r2.xyzw = r2.xyzw * float4(0.318309903,0.367879391,0.318309903,0.367879391) + float4(0.367879391,0.318309903,0.367879391,0.318309903);
  r3.xyzw = r2.xxzz * r2.yyww;
  r2.xyzw = r2.xxzz + r2.yyww;
  r2.xyzw = r3.xyzw * r2.xyzw;
  r2.xyzw = frac(r2.xyzw);
  r2.xyzw = float4(5.09295845,5.88607025,5.09295845,5.88607025) * r2.xyzw;
  r2.xyzw = frac(r2.xyzw);
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r3.xyzw = float4(-1,-0,-0,-1) + r0.xyxy;
  r1.y = dot(r2.zw, r3.zw);
  r1.z = dot(r2.xy, r3.xy);
  r1.x = r1.x + -r1.y;
  r2.xy = r0.xy * r0.xy;
  r2.zw = -r0.xy * float2(2,2) + float2(3,3);
  r2.xy = r2.xy * r2.zw;
  r1.x = r2.x * r1.x + r1.y;
  r1.y = r0.z * r0.w;
  r0.z = r0.z + r0.w;
  r0.z = r1.y * r0.z;
  r0.z = frac(r0.z);
  r0.zw = float2(5.09295845,5.88607025) * r0.zz;
  r0.zw = frac(r0.zw);
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r0.x = dot(r0.zw, r0.xy);
  r0.y = r1.z + -r0.x;
  r0.x = r2.x * r0.y + r0.x;
  r0.y = r1.x + -r0.x;
  r0.x = r2.y * r0.y + r0.x;
  r0.x = r0.x * 0.5 + 0.5;
  r1.xy = v2.xy * cb1[4].xy + cb1[4].zw;
  r1.z = cb1[7].y * r0.x + r1.y;
  r0.yz = cb0[19].xx * cb1[3].zw + r1.xz;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r2.xy = v2.xy * cb1[5].xy + cb1[3].xy;
  r2.z = cb1[7].y * r0.x + r2.y;
  r0.xy = cb0[19].xx * cb1[6].zw + r2.xz;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.x = r1.x + r0.x;
  r0.x = -cb1[7].w + r0.x;
  r0.y = 1 + -cb1[7].w;
  r0.y = 1 / r0.y;
  r0.x = saturate(r0.x * r0.y);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = min(1, r0.x);
  r1.x = v2.x;
  r1.y = cb1[8].x + v2.y;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.x = r1.x * r0.x;
  r0.y = saturate(r1.x * cb1[8].z + r0.x);
  r0.y = cb1[7].z * r0.y;
  o0.w = v1.w * r0.y;
  r0.yz = v2.xy * cb1[2].xy + cb1[2].zw;
  r1.xyzw = t2.Sample(s2_s, r0.yz).xyzw;
  r0.x = r1.x * r0.x;
  r0.yzw = cb1[1].xyz + -cb1[0].xyz;
  r0.xyz = r0.xxx * r0.yzw + cb1[0].xyz;
  r0.xyz = v1.xyz * r0.xyz;
  o0.xyz = saturate(cb1[7].xxx * r0.xyz);
  o0.w = saturate(o0.w);
  return;
}