Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[134];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s1_s, v1.xy, cb0[129].x).xyzw;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  /*// REC709toREC2020
  r2.x = dot(float3(0.627402008,0.329291999,0.0433060005), r0.xyz);
  r2.y = dot(float3(0.0690950006,0.919543982,0.0113599999), r0.xyz);
  r2.z = dot(float3(0.0163940005,0.0880279988,0.895578027), r0.xyz);
  r3.xyz = cmp(asint(cb0[132].xxy) == int3(1,2,3));
  // REC709toDCIP3
  r4.x = dot(float2(0.822462022,0.177537993), r0.xy);
  r4.y = dot(float2(0.0331940018,0.966805995), r0.xy);
  r4.z = dot(float3(0.0170830004,0.0723970011,0.910520017), r0.xyz);
  r4.xyz = r3.yyy ? r4.xyz : r0.xyz;
  r2.xyz = r3.xxx ? r2.xyz : r4.xyz;*/
  //r2.xyz = cb0[133].zzz * r2.xyz;   // 300
    r2.xyz = r0.xyz;
  //r2.w = cmp(r1.w == 0.000000);
  r2.w = r1.w == 0.0 ? 1 : r1.w;
  r1.xyz = r1.xyz / r2.www;
  /*// REC709toREC2020
  r4.x = dot(float3(0.627402008,0.329291999,0.0433060005), r1.xyz);
  r4.y = dot(float3(0.0690950006,0.919543982,0.0113599999), r1.xyz);
  r4.z = dot(float3(0.0163940005,0.0880279988,0.895578027), r1.xyz);
  // REC709toDCIP3
  r5.x = dot(float2(0.822462022,0.177537993), r1.xy);
  r5.y = dot(float2(0.0331940018,0.966805995), r1.xy);
  r5.z = dot(float3(0.0170830004,0.0723970011,0.910520017), r1.xyz);
  r1.xyz = r3.yyy ? r5.xyz : r1.xyz;
  r1.xyz = r3.xxx ? r4.xyz : r1.xyz;*/
  //r1.xyz = cb0[133].zzz * r1.xyz;
  r2.w = 1 + -r1.w;
  r2.xyz = r2.xyz * r2.www;
  r1.xyz = r1.xyz * r1.www + r2.xyz;
  /*if (asint(cb0[132].y) == 3) {
    // scRGB
    r0.xyz = float3(0.0125000002,0.0125000002,0.0125000002) * r1.xyz;
  } else {
    // HDR10
    // PQ encode
    r2.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r1.xyz;
    r2.xyz = log2(abs(r2.xyz));
    r2.xyz = float3(0.159301758,0.159301758,0.159301758) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r3.xyz = r2.xyz * float3(2.05784011,2.05784011,2.05784011) + float3(-0.101283997,-0.101283997,-0.101283997);
    r3.xyz = r2.xyz * r3.xyz + float3(0.00102859002,0.00102859002,0.00102859002);
    r3.xyz = r2.xyz * r3.xyz + float3(3.61971999e-08,3.61971999e-08,3.61971999e-08);
    r4.xyz = float3(0.772669017,0.772669017,0.772669017) + r2.xyz;
    r4.xyz = r2.xyz * r4.xyz + float3(0.135214001,0.135214001,0.135214001);
    r2.xyz = r2.xyz * r4.xyz + float3(0.049524501,0.049524501,0.049524501);
    r2.xyz = r3.xyz / r2.xyz;
    r3.xy = cmp(asint(cb0[132].yy) == int2(2,4));
    r4.xyz = r1.xyz / cb0[133].yyy;   // 500
    r5.xyz = log2(abs(r4.xyz));
    r5.xyz = float3(0.454545468,0.454545468,0.454545468) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r1.xyz = cb0[132].yyy ? r1.xyz : r4.xyz;
    r1.xyz = asint(cb0[132].y) == 4 ? r5.xyz : r1.xyz;
    r0.xyz = asint(cb0[132].y) == 2 ? r2.xyz : r1.xyz;
  }*/
  r0.xyz = r1.xyz;
  o0.xyzw = r0.xyzw;
  return;
}