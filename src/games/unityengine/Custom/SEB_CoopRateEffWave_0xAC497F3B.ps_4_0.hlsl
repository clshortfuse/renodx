Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(3,3) * v2.xy;
  r0.zw = min(float2(0.5,0.5), v2.xy);
  r0.xy = r0.xy * r0.zw + cb0[0].yy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = 0.200000003 * r0.w;
  r0.x = dot(r0.xx, float2(0.366025418,0.366025418));
  r0.x = r0.w * 0.200000003 + r0.x;
  r0.x = floor(r0.x);
  r0.y = 0.00346020772 * r0.x;
  r0.y = floor(r0.y);
  r0.y = -r0.y * 289 + r0.x;
  r1.xyz = float3(0,1,1) + r0.yyy;
  r2.xyz = r1.xzz * float3(34,34,34) + float3(1,1,1);
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r1.xzz;
  r2.xyz = floor(r2.xyz);
  r1.xyz = -r2.xyz * float3(289,289,289) + r1.xyz;
  r1.xyz = r1.xyz + r0.yyy;
  r1.xyz = float3(0,0,1) + r1.xyz;
  r2.xyz = r1.xyz * float3(34,34,34) + float3(1,1,1);
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = float3(0.00346020772,0.00346020772,0.00346020772) * r1.xyz;
  r2.xyz = floor(r2.xyz);
  r1.xyz = -r2.xyz * float3(289,289,289) + r1.xyz;
  r1.xyz = float3(0.024390243,0.024390243,0.024390243) * r1.xyz;
  r1.xyz = frac(r1.xyz);
  r2.xyz = r1.xyz * float3(2,2,2) + float3(-0.5,-0.5,-0.5);
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyz = floor(r2.xyz);
  r2.xyz = -r2.xyz + r1.xyz;
  r1.xyz = float3(-0.5,-0.5,-0.5) + abs(r1.xyz);
  r0.y = r0.w * 0.200000003 + -r0.x;
  r0.x = dot(r0.xx, float2(0.211324871,0.211324871));
  r0.x = r0.y + r0.x;
  r0.y = r1.x * r0.x;
  r3.x = r2.x * r0.x + r0.y;
  r0.yzw = r1.xyz * r1.xyz;
  r0.yzw = r2.xyz * r2.xyz + r0.yzw;
  r0.yzw = -r0.yzw * float3(0.853734732,0.853734732,0.853734732) + float3(1.79284286,1.79284286,1.79284286);
  r4.x = dot(r0.xx, r0.xx);
  r5.xyz = float3(-0.577350259,0.211324871,-0.788675129) + r0.xxx;
  r4.y = dot(r5.yz, r5.yz);
  r4.z = dot(r5.xx, r5.xx);
  r4.xyz = float3(0.5,0.5,0.5) + -r4.xyz;
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r4.xyz = r4.xyz * r4.xyz;
  r4.xyz = r4.xyz * r4.xyz;
  r0.xyz = r4.xyz * r0.yzw;
  r1.xy = r5.zx * r1.yz;
  r3.yz = r2.yz * r5.yx + r1.xy;
  r0.x = dot(r0.xyz, r3.xyz);
  r0.x = r0.x * 65 + 0.5;
  r0.yz = float2(-1,-1) + v2.xy;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.y = r0.y * 2.83333325 + -2.73000002;
  r0.x = r0.y * r0.x;
  r1.xyzw = float4(-1,-1,-1,-1) + cb1[0].xyzw;
  r1.xyzw = r0.yyyy * r1.xyzw + float4(1,1,1,1);
  r2.xyzw = cb1[1].xyzw + -r1.xyzw;
  r1.xyzw = r0.yyyy * r2.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw * r0.xxxx;
  o0.xyzw = v1.wwww * r0.xyzw;
  o0.w = saturate(o0.w);
  return;
}