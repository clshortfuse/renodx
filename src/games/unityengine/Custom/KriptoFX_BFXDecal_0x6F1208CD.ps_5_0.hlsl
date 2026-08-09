Texture2DArray<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb5 : register(b5){
  float4 cb5[5];
}
cbuffer cb4 : register(b4){
  float4 cb4[10];
}
cbuffer cb3 : register(b3){
  float4 cb3[16];
}
cbuffer cb2 : register(b2){
  float4 cb2[1];
}
cbuffer cb1 : register(b1){
  float4 cb1[129];
}
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  nointerpolation uint v3 : CUSTOM_INSTANCE_ID0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)v3.x + asint(cb2[0].x);
  r1.xy = (uint2)v0.xy;
  r1.zw = float2(0,0);
  r0.y = t0.Load(r1.xyww).x;
  r0.zw = cb1[50].zw * v0.xy;
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r2.xyzw = cb1[29].xyzw * -r0.wwww;
  r2.xyzw = cb1[28].xyzw * r0.zzzz + r2.xyzw;
  r2.xyzw = cb1[30].xyzw * r0.yyyy + r2.xyzw;
  r2.xyzw = cb1[31].xyzw + r2.xyzw;
  r0.yzw = r2.xyz / r2.www;
  if (cb1[128].w != 0) {
    r2.x = (int)r0.x * 5;
    r1.xyzw = t3.Load(r1.xyzw).xyzw;
    r1.zw = r1.zw * float2(2,2) + float2(-1,-1);
    r2.yz = cmp(r1.zw < float2(0,0));
    r2.yz = r2.yz ? -r1.zw : r1.zw;
    r2.y = 1 + -r2.y;
    r3.z = r2.y + -r2.z;
    r2.y = max(0, -r3.z);
    r2.zw = cmp(r1.zw >= float2(0,0));
    r2.yz = r2.zw ? -r2.yy : r2.yy;
    r3.xy = r2.yz + r1.zw;
    r1.z = dot(r3.xyz, r3.xyz);
    r1.z = rsqrt(r1.z);
    r2.yzw = r3.xyz * r1.zzz;
    r1.xy = float2(255.5,255.5) * r1.xy;
    r1.xy = (uint2)r1.xy;
    r1.x = (uint)r1.x << 8;
    r1.x = (int)r1.y | (int)r1.x;
    r1.x = (int)r1.x & asint(cb4[r2.x+4].x);
    r1.x = r1.x ? 1 : -1;
  } else {
    r2.yzw = float3(0,0,0);
    r1.x = 1;
  }
  r1.y = (uint)r0.x << 3;
  r3.xyz = cb3[r1.y+5].xyz * cb1[48].yyy;
  r3.xyz = cb3[r1.y+4].xyz * cb1[48].xxx + r3.xyz;
  r3.xyz = cb3[r1.y+6].xyz * cb1[48].zzz + r3.xyz;
  r3.xyz = cb3[r1.y+7].xyz + r3.xyz;
  r4.xyz = cb3[r1.y+5].xyz * r0.zzz;
  r4.xyz = cb3[r1.y+4].xyz * r0.yyy + r4.xyz;
  r0.yzw = cb3[r1.y+6].xyz * r0.www + r4.xyz;
  r0.yzw = r0.yzw + r3.xyz;
  r0.yzw = r0.yzw * float3(1,-1,1) + float3(0.5,0.5,0.5);
  r1.yzw = cmp(float3(0,0,0) < r0.yzw);
  r1.y = r1.z ? r1.y : 0;
  r1.y = r1.w ? r1.y : 0;
  r3.xyz = float3(1,1,1) + -r0.yzw;
  r3.xyz = cmp(float3(0,0,0) < r3.xyz);
  r0.z = r3.y ? r3.x : 0;
  r0.z = r3.z ? r0.z : 0;
  r0.z = r1.y ? r0.z : 0;
  r1.y = -2 + r1.x;
  r0.z = r0.z ? r1.x : r1.y;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  if (cb1[128].w != 0) {
    r0.z = (int)r0.x * 5;
    r1.x = cmp(0 < cb4[r0.z+3].y);
    if (r1.x != 0) {
      r1.x = dot(r2.yzw, cb4[r0.z+2].xyz);
      r1.y = r1.x * r1.x + 1.25;
      r1.x = r1.y * r1.x;
      r0.z = saturate(r1.x * cb4[r0.z+3].y + cb4[r0.z+3].z);
    } else {
      r0.z = 1;
    }
  } else {
    r0.z = 1;
  }
  r0.x = (int)r0.x * 5;
  r1.x = saturate(cb4[r0.x+3].x);
  r0.z = r1.x * r0.z;
  r1.x = r0.y * cb4[r0.x+0].w + cb4[r0.x+2].w;
  r1.y = r0.w * cb4[r0.x+1].w + cb4[r0.x+3].w;
  r0.xyw = t1.SampleBias(s0_s, r1.xy, cb1[86].y).wxy;
  r2.xz = r0.yw * float2(2,2) + float2(-1,-1);
  r2.y = 1;
  r0.y = dot(r2.xyz, r2.xyz);
  r0.y = rsqrt(r0.y);
  r2.xyz = r2.xyz * r0.yyy;
  r0.y = dot(cb5[4].xyz, cb5[4].xyz);
  r0.y = rsqrt(r0.y);
  r3.xyz = cb5[4].xyz * r0.yyy;
  r0.y = saturate(dot(r2.xyz, r3.xyz));
  r0.y = log2(r0.y);
  r0.y = 150 * r0.y;
  r0.y = exp2(r0.y);
  r0.y = cb5[4].w * r0.y;
  r0.y = 3 * r0.y;
  r0.x = saturate(r0.x);
  r0.x = r0.x + r0.x;
  r1.xy = t2.SampleBias(s1_s, r1.xy, cb1[86].y).xz;
  r0.w = cb5[2].x * v2.w;
  r0.w = r0.w * 0.5 + 0.5;
  r0.w = r0.w * 2 + -1;
  r0.w = r1.x + -r0.w;
  r1.zw = saturate(float2(5,20) * r0.ww);
  r0.xw = r1.zw * r0.xx;
  r0.x = -r0.x * r1.y + 1;
  r1.yzw = r0.yyy * r0.xxx + cb5[0].xyz;
  r0.x = 1 + cb0[0].x;
  r0.y = dot(r1.yzw, float3(0.212672904,0.715152204,0.0721750036));
  r1.yzw = r1.yzw + -r0.yyy;
  o0.xyz = r0.xxx * r1.yzw + r0.yyy;
  r0.x = min(1, r0.w);
  r0.y = saturate(r1.x + r1.x);
  o2.z = r0.x * r0.y;
  r0.x = r0.x * r0.z;
  o0.w = r0.x;
  o1.xyzw = float4(0.5,0.5,0.5,0);
  o2.xy = float2(0,0);
  o2.w = r0.x;
  o0.xyz = max(0.f, o0.xyz);
  return;
}