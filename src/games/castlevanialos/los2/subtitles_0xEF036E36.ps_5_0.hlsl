Texture2D<float4> t1 : register(t1);
SamplerState s1_s : register(s1);
cbuffer cb4 : register(b4){
  float4 cb4[236];
}
cbuffer cb3 : register(b3){
  float4 cb3[77];
}

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
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb4[59].xy + v5.xy;
  r1.xy = cb4[9].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = cb4[34].x * r1.w;
  r1.xy = cb4[8].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[33].x + r0.w;
  r1.xy = cb4[10].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[35].x + r0.w;
  r1.xy = cb4[11].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[36].x + r0.w;
  r1.xy = cb4[12].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[37].x + r0.w;
  r1.xy = cb4[13].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[38].x + r0.w;
  r1.xy = cb4[14].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[39].x + r0.w;
  r1.xy = cb4[15].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[40].x + r0.w;
  r1.xy = cb4[16].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[41].x + r0.w;
  r1.xy = cb4[17].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[42].x + r0.w;
  r1.xy = cb4[18].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[43].x + r0.w;
  r1.xy = cb4[19].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[44].x + r0.w;
  r1.xy = cb4[20].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[45].x + r0.w;
  r1.xy = cb4[21].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[46].x + r0.w;
  r1.xy = cb4[22].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[47].x + r0.w;
  r1.xy = cb4[23].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[48].x + r0.w;
  r1.xy = cb4[24].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[49].x + r0.w;
  r1.xy = cb4[25].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[50].x + r0.w;
  r1.xy = cb4[26].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[51].x + r0.w;
  r1.xy = cb4[27].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[52].x + r0.w;
  r1.xy = cb4[28].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[53].x + r0.w;
  r1.xy = cb4[29].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[54].x + r0.w;
  r1.xy = cb4[30].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[55].x + r0.w;
  r1.xy = cb4[31].xy + r0.xy;
  r0.xy = cb4[32].xy + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * cb4[56].x + r0.w;
  r1.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.w = saturate(r1.w * cb4[57].x + r0.w);
  r1.xyzw = t1.Sample(s1_s, v5.xy).xyzw;
  r1.xyzw = cb4[58].xyzw * r1.xyzw;
  o0.w = r0.w * cb4[59].w + r1.w;
  o0.xyz = r1.xyz;
  o0 = saturate(o0);
  return;
}