Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = cb0[3].xyzw + r0.xyzw;
  r0.xyzw = v1.wxyz * r0.wxyz;
  r1.xy = v0.xy / v0.ww;
  r1.z = cb1[6].y + -r1.y;
  r1.yw = -cb0[8].zw * float2(0.5,0.5) + cb0[8].xy;
  r2.xy = cb0[8].zw * float2(0.5,0.5) + cb0[8].xy;
  r2.z = (r1.y < r1.x) ? (r1.x < r2.x) : 0;
  r2.z = (r1.w < r1.z) ? r2.z : 0;
  r2.z = (r1.z < r2.y) ? r2.z : 0;
  if (r2.z != 0) {
    r0.x = cb0[9].x * r0.x;
  } else {
    r2.z = cb0[9].y * cb0[8].z;
    r1.yw = r1.yw + -r1.xz;
    r2.xy = -r2.xy + r1.xz;
    r1.yw = max(r2.xy, r1.yw);
    r1.y = max(r1.y, r1.w);
    r1.w = 1 / r2.z;
    r1.y = saturate(r1.y * r1.w);
    r1.w = r1.y * -2 + 3;
    r1.y = r1.y * r1.y;
    r1.y = -r1.w * r1.y + 1;
    r1.w = cb1[6].x / cb1[6].y;
    r2.yw = r1.xz / cb1[6].xy;
    r2.z = r2.w * r1.w;
    r2.yz = r2.yz * cb0[7].xy + cb0[7].zw;
    r2.x = cb1[0].x * cb0[6].w + r2.y;
    r2.xyzw = t1.Sample(s1_s, r2.xz).xyzw;
    r1.x = r2.x * cb0[6].z + 1;
    r1.z = cb0[9].x + -r1.x;
    r1.x = r1.y * r1.z + r1.x;
    r0.x = r1.x * r0.x;
  }
  o0.xyzw = r0.yzwx;
  o0.w = saturate(o0.w);
  return;
}