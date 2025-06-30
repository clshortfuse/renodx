// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 15:37:16 2025
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[236];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[77];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t3.Sample(s3_s, v5.xy).xyzw;
 //r0.xyzw = (int4)r0.xyzw & asint(cb3[50].xyzw);
 //r0.xyzw = (int4)r0.xyzw | asint(cb3[51].xyzw);
  r1.xy = cb4[22].xx * r0.yw;
  r1.xy = r0.xz * cb4[22].xx + -r1.xy;
  r1.xy = v5.xy + -r1.xy;
  r2.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
 //r2.xyzw = (int4)r2.xyzw & asint(cb3[46].xyzw);
 //r2.xyzw = (int4)r2.xyzw | asint(cb3[47].xyzw);
  r3.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
 //r3.xyzw = (int4)r3.xyzw & asint(cb3[48].xyzw);
 //r3.xyzw = (int4)r3.xyzw | asint(cb3[49].xyzw);
  r4.xyzw = v6.yyyy * cb4[9].xyzw;
  r4.xyzw = v6.xxxx * cb4[8].xyzw + r4.xyzw;
  r3.xyzw = r3.xxxx * cb4[10].xyzw + r4.xyzw;
  r3.xyzw = cb4[11].xyzw + r3.xyzw;
  r5.y = cmp(0 < abs(r3.w));
  r5.x = rcp(r3.w);
  r1.z = r5.y ? r5.x : 99999999;//33815812510711506376257961984;
  r3.xyz = r3.xyz * r1.zzz;
  r4.xyz = cb4[13].xyw * r3.yyy;
  r4.xyz = r3.xxx * cb4[12].xyw + r4.xyz;
  r4.xyz = r3.zzz * cb4[14].xyw + r4.xyz;
  r4.xyz = cb4[15].xyw + r4.xyz;
  r5.xyz = cb4[17].xyw * r3.yyy;
  r3.xyw = r3.xxx * cb4[16].xyw + r5.xyz;
  r3.xyz = r3.zzz * cb4[18].xyw + r3.xyw;
  r3.xyz = cb4[19].xyw + r3.xyz;
  r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
 //r5.xyzw = (int4)r5.xyzw & asint(cb3[44].xyzw);
 //r5.xyzw = (int4)r5.xyzw | asint(cb3[45].xyzw);
  r6.y = cmp(0 < abs(r4.z));
  r6.x = rcp(r4.z);
  r1.z = r6.y ? r6.x : 99999999;  // 33815812510711506376257961984;
  r6.y = cmp(0 < abs(r3.z));
  r6.x = rcp(r3.z);
  r1.w = r6.y ? r6.x : 99999999;  // 33815812510711506376257961984;
  r3.xy = r3.xy * r1.ww;
  r1.zw = r4.xy * r1.zz + -r3.xy;
  r1.zw = cb4[20].xx * r1.zw;
  r6.xy = cmp(-r1.zw >= float2(0,0));
  r3.xy = r6.xy ? float2(0,0) : float2(1,1);
  r6.zw = cmp(r1.zw >= float2(0,0));
  r3.zw = r6.zw ? float2(-0,-0) : float2(-1,-1);
  r3.xy = r3.xy + r3.zw;
  r4.xy = max(float2(0,0), r3.xy);
  r4.zw = max(float2(0,0), -r3.xy);
  r3.xyzw = r4.xzwy * abs(r1.zzww);
  r3.xyzw = float4(0.00392200006,0.00392200006,0.00392200006,0.00392200006) + r3.xyzw;
  r6.xyzw = cmp(-abs(r5.xxxx) >= float4(0,0,0,0));
  r3.xyzw = r6.xyzw ? r3.xyzw : r5.xywz;
  r0.xyzw = cb4[23].xxxx * r0.xyzw;
  r0.xyzw = r3.xyzw * cb4[21].xxxx + r0.xyzw;
  r0.xy = r0.xz + -r0.yw;
  r3.xyzw = r2.xyzw;
  r0.z = -5;
  r6.xyz = float3(5,0,0);
  r6.xyz = max(int3(0,0,-2147483648), (int3)r6.xyz);
  while (true) {
    if (r6.x == 0) break;
    r1.zw = r0.zz * r0.xy + r1.xy;
    r4.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
   //r4.xyzw = (int4)r4.xyzw & asint(cb3[46].xyzw);
   //r4.xyzw = (int4)r4.xyzw | asint(cb3[47].xyzw);
    r3.xyzw = r4.xyzw + r3.xyzw;
    r0.z = 1 + r0.z;
    r6.x = (int)r6.x + -1;
  }
  r2.xyzw = r3.xyzw;
  r0.z = 1;
  r6.xyz = float3(5,0,0);
  r6.xyz = max(int3(0,0,-2147483648), (int3)r6.xyz);
  while (true) {
    if (r6.x == 0) break;
    r1.zw = r0.zz * r0.xy + r1.xy;
    r4.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
   //r4.xyzw = (int4)r4.xyzw & asint(cb3[46].xyzw);
   //r4.xyzw = (int4)r4.xyzw | asint(cb3[47].xyzw);
    r2.xyzw = r4.xyzw + r2.xyzw;
    r0.z = 1 + r0.z;
    r6.x = (int)r6.x + -1;
  }
  o0.xyzw = float4(0.0909089968,0.0909089968,0.0909089968,0.0909089968) * r2.xyzw;
  return;
}