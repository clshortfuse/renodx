Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = cmp(cb0[6].x < 0.5);
  if (r0.w != 0) {
    r1.xyzw = float4(0.000400641031,0,-0.000400641031,0) + v1.xyxy;
    r2.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
    r3.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
    r1.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
    r4.x = r2.x;
    r4.y = r3.y;
    r4.z = r1.z;
    r4.xyz = max(r4.xyz, r0.xyz);
    r5.x = r2.x;
    r5.y = r3.y;
    r5.z = r1.z;
    r1.xzw = float3(0.5,0.5,0.5) * r5.xyz;
    r1.xzw = r4.xyz * float3(0.5,0.5,0.5) + r1.xzw;
    r4.xyzw = float4(0,0.000712250709,0.000400641031,0.000712250709) + v1.xyxy;
    r5.xyzw = t1.Sample(s1_s, r4.zw).xyzw;
    r4.xyzw = t1.Sample(s1_s, r4.xy).xyzw;
    r6.xyzw = float4(-0.000400641031,0.000712250709,0,-0.000712250709) + v1.xyxy;
    r7.xyzw = t1.Sample(s1_s, r6.xy).xyzw;
    r7.x = r5.x;
    r7.y = r4.y;
    r4.xyzw = float4(0.000400641031,-0.000712250709,-0.000400641031,-0.000712250709) + v1.xyxy;
    r5.xyzw = t1.Sample(s1_s, r4.xy).xyzw;
    r6.xyzw = t1.Sample(s1_s, r6.zw).xyzw;
    r4.xyzw = t1.Sample(s1_s, r4.zw).xyzw;
    r4.x = r5.x;
    r4.y = r6.y;
    r5.xyzw = float4(0.000801282062,0,-0.000801282062,0) + v1.xyxy;
    r6.xyzw = t1.Sample(s1_s, r5.xy).xyzw;
    r2.x = r6.x;
    r2.z = r3.z;
    r5.xyzw = t1.Sample(s1_s, r5.zw).xyzw;
    r5.x = r3.x;
    r5.y = r1.y;
    r3.xyz = max(r7.xyz, r4.xyz);
    r2.xyz = max(r5.xyz, r2.xyz);
    r2.xyz = max(r3.xyz, r2.xyz);
    r2.xyz = max(r2.xyz, r1.xzw);
    r1.xyz = float3(0.5,0.5,0.5) * r1.xzw;
    r0.xyz = r2.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  }
  r0.w = 0.0166666675 * cb1[0].y;
  r1.x = cmp(r0.w >= -r0.w);
  r0.w = frac(abs(r0.w));
  r0.w = r1.x ? r0.w : -r0.w;
  r0.w = 60 * r0.w;
  r1.xy = float2(702,1248) * v1.yx;
  r1.zw = sin(r1.yx);
  r1.xy = r1.zw * r1.xy + r0.ww;
  r1.xy = float2(89.4199982,89.4199982) * r1.xy;
  r1.xy = cos(r1.xy);
  r1.xy = float2(343.420013,343.420013) * r1.xy;
  r2.xy = frac(r1.xy);
  r0.w = r1.z * r1.w + r0.w;
  r0.w = 89.4199982 * r0.w;
  r0.w = cos(r0.w);
  r0.w = 343.420013 * r0.w;
  r2.z = frac(r0.w);
  r1.xyz = saturate(r2.xyz * r0.xyz);
  r0.xyz = float3(0.959999979,0.959999979,0.959999979) * r0.xyz;
  r0.xyz = r1.xyz * float3(0.0399999991,0.0399999991,0.0399999991) + r0.xyz;
  r1.xyz = saturate(r0.xyz * r2.xxx);
  r0.xyz = float3(0.959999979,0.959999979,0.959999979) * r0.xyz;
  r0.xyz = r1.xyz * float3(0.0399999991,0.0399999991,0.0399999991) + r0.xyz;
  r1.xyzw = cb0[3].xyzw * r0.yyyy;
  r1.xyzw = cb0[2].xyzw * r0.xxxx + r1.xyzw;
  r0.xyzw = cb0[4].xyzw * r0.zzzz + r1.xyzw;
  r0.xyzw = cb0[5].xyzw + r0.xyzw;
  r1.xy = float2(0.5,0.5) + -v1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = -r1.x * 1.41421294 + 1;
  r1.x = saturate(4 * r1.x);
  r1.xyz = r1.xxx * r0.xyz;
  r0.xyz = float3(0.75,0.75,0.75) * r0.xyz;
  o0.xyz = r1.xyz * float3(0.25,0.25,0.25) + r0.xyz;
  o0.xyz = max(0.f, o0.xyz);
  o0.w = r0.w;
  return;
}