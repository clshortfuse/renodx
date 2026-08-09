
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

int cvt_f32_i32(precise float v)
{
    return isnan(v) ? 0 : ((v < (-2147483648.0f)) ? int(0x80000000) : ((v > 2147483520.0f) ? 2147483647 : int(v)));
}


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s2_s, v1.xy).xyzw;
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.x = 1 + -r1.x;
  //r1.y = cmp(r1.z == 0.000000);
  //r1.z = cmp(r1.z >= 0.150000006);
  //r1.y = (int)r1.z | (int)r1.y;
  if (r1.z == 0.0 || r1.z >= 0.150000006) {
    r1.y = r0.x + r0.y;
    r1.y = r1.y + r0.z;
    r1.y = -r1.y * 0.333333343 + 1;
    //r1.z = cmp(r1.y < cb0[5].y);
    bool thing = r1.y < cb0[5].y;
    r1.w = cb1[6].x * v2.x;
    r2.x = -v2.y * cb1[6].y + 1;
    /*r1.w = (int)r1.w;
    r2.x = (int)r2.x;
    r1.w = (int)r1.w + (int)-r2.x;
    r1.w = (uint)r1.w % 5;
    r2.x = (uint)r1.w;*/
    uint thing2 = uint(cvt_f32_i32(r1.w) - cvt_f32_i32(r2.x)) % 5u;
    r2.x = float(r1.w);
    r2.x = min(1, r2.x);
    r2.x = 1 + -r2.x;
    //r2.yz = cmp((int2)r1.ww == int2(1,4));
    //r1.w = (int)r2.z | (int)r2.y;
    //r1.w = (int)r1.w & 0x3f266666;
    r1.w = thing2 == 1u || thing2 == 4u ? 0.64999997615814208984375 : 0.0;
    r1.w = r2.x + r1.w;
    r1.y = saturate(-cb0[5].y + r1.y);
    r1.y = r1.w * r1.y;
    r1.y = -r1.y * cb0[5].x + 1;
    //r1.y = r1.z ? 1 : r1.y;
    r1.y = thing ? 1 : r1.y;
    r1.z = saturate(r1.x * cb0[3].x + cb0[3].y);
    r2.xz = cb0[3].zw;
    r2.yw = v1.yy;
    r3.xyzw = t2.Sample(s1_s, r2.xy).xyzw;
    r3.xyzw = r3.xyzw * r1.zzzz;
    r1.z = saturate(r1.x * cb0[4].x + cb0[4].y);
    r2.xyzw = t2.Sample(s1_s, r2.zw).xyzw;
    r2.xyzw = r1.zzzz * r2.xyzw + -r3.xyzw;
    r2.xyzw = cb0[5].wwww * r2.xyzw + r3.xyzw;
    r2.xyzw = r0.xyzw * r1.yyyy + r2.xyzw;
    r3.x = dot(r2.xyz, float3(0.222000003,0.707000017,0.0710000023));
    r3.y = 1;
    r2.xyzw = -r3.xxxy + r2.xyzw;
    r2.xyzw = cb0[4].zzzz * r2.xyzw + r3.xxxy;
    r1.y = 1 + cb0[4].w;
    r2.xyzw = log2(r2.xyzw);
    r2.xyzw = r2.xyzw * r1.yyyy;
    o0.xyzw = exp2(r2.xyzw);
  } else {
    //r1.y = cmp(cb0[5].z < 1);
    if (cb0[5].z < 1.0) {
      r1.y = saturate(r1.x * cb0[3].x + cb0[3].y);
      r2.xz = cb0[3].zw;
      r2.yw = v1.yy;
      r3.xyzw = t2.Sample(s1_s, r2.xy).xyzw;
      r3.xyzw = r3.xyzw * r1.yyyy;
      r1.x = saturate(r1.x * cb0[4].x + cb0[4].y);
      r2.xyzw = t2.Sample(s1_s, r2.zw).xyzw;
      r1.xyzw = r1.xxxx * r2.xyzw + -r3.xyzw;
      r1.xyzw = cb0[5].wwww * r1.xyzw + r3.xyzw;
      r1.xyzw = r1.xyzw + r0.xyzw;
      r2.x = dot(r1.xyz, float3(0.222000003,0.707000017,0.0710000023));
      r2.y = 1;
      r1.xyzw = -r2.xxxy + r1.xyzw;
      r1.xyzw = cb0[4].zzzz * r1.xyzw + r2.xxxy;
      r2.x = 1 + cb0[4].w;
      r1.xyzw = log2(r1.xyzw);
      r1.xyzw = r2.xxxx * r1.xyzw;
      o0.xyzw = exp2(r1.xyzw);
    } else {
      o0.xyzw = r0.xyzw;
    }
  }
  return;
}