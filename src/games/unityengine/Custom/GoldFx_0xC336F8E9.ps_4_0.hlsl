Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = -cb0[4].xyy + v0.xyy;
  r1.xyz = cb0[4].zww + -cb0[4].xyy;
  r0.xyz = r0.xyz / r1.xyz;
  r0.w = cb1[0].x * 45 + 1.1;
  r1.x = -r0.x * 5 + r0.w;
  r0.xyz = r0.xyz * float3(5,5,12.5) + r0.www;
  r0.xyz = sin(r0.xyz);
  r0.w = sin(r1.x);
  r0.x = r0.x + r0.w;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  r0.x = 5 + r0.x;
  r0.y = 0.2 * r0.x;
  r0.y = floor(r0.y);
  r0.x = r0.x * 0.2 + -r0.y;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.y = dot(r1.xzy, float3(0.2,0.2,0.4));
  r0.x = r0.x + r0.y;
  r0.y = floor(r0.x);
  r0.x = r0.x + -r0.y;
  r0.y = saturate(r0.x * 6 + -2);
  r0.x = saturate(-r0.x * 6 + 2);
  r0.x = r0.y + r0.x;
  r0.yz = min(cb0[4].zw, v0.xy);
  r0.yz = max(cb0[4].xy, r0.yz);
  r1.xyzw = t0.Sample(s0_s, r0.yz).xyzw;
  r2.xyzw = v2.xyzw * r1.xyzw;
  o0.w = r1.w * v2.w + -cb0[2].y;
  r0.x = r0.x * r2.w + -cb0[2].y;
  r0.y = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.z = -r0.y * 0.115896732 + 1;
  r0.w = r0.y * r0.y;
  r0.z = r0.w * 2.58329701 + r0.z;
  r1.xyz = r0.yyy * float3(0.616473019,3.36968088,0.169122502) + float3(0.860117733,1,0.317398727);
  r2.xyz = float3(2.4,1.6,1.6) * r0.yyy;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r1.xyz = r0.www * float3(2.05825949,11.3303223,0.672770679) + r1.xyz;
  r0.y = r1.z / r0.z;
  r0.z = r1.x / r1.y;
  r0.w = r0.z + r0.z;
  r0.z = 3 * r0.z;
  r0.w = -r0.y * 8 + r0.w;
  r0.y = r0.y + r0.y;
  r0.w = 4 + r0.w;
  r0.yz = r0.yz / r0.ww;
  r0.xw = float2(1,1) + -r0.xz;
  r0.w = r0.w + -r0.y;
  r0.y = 1 / r0.y;
  r1.z = r0.y * r0.w;
  r0.y = r0.y * r0.z;
  r1.x = 0.5 * r0.y;
  r1.y = 2;
  r0.yzw = r1.xyz / cb0[2].xxx;
  o0.xyz = r0.yzw * r2.xyz + r0.xxx;
  o0.w = saturate(o0.w);
  return;
}