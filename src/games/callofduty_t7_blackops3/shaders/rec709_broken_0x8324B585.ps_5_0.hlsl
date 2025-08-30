// ---- Created with 3Dmigoto v1.3.16 on Thu Jul 31 09:17:17 2025

//This is probably the "to rec709" shader. Whatever it is, it just outputs black now.

SamplerState bilinearClamp_s : register(s0);
Texture2D<float4> codeTexture0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float3 o0 : SV_TARGET0)
{
  discard;

  // float4 r0,r1,r2;
  // uint4 bitmask, uiDest;
  // float4 fDest;
  //
  // r0.xyz = codeTexture0.Sample(bilinearClamp_s, v0.xy).xyz;
  // r1.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
  // r1.xyz = float3(0.947867334,0.947867334,0.947867334) * r1.xyz;
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(2.4000001,2.4000001,2.4000001) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
  // r0.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
  // r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  // r1.xyz = log2(r0.xyz);
  // r1.xyz = float3(0.449999988,0.449999988,0.449999988) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.09899998,1.09899998,1.09899998) + float3(-0.0989999995,-0.0989999995,-0.0989999995);
  // r2.xyz = cmp(r0.xyz < float3(0.0179999992,0.0179999992,0.0179999992));
  // r0.xyz = float3(4.5,4.5,4.5) * r0.xyz;
  // o0.xyz = r2.xyz ? r0.xyz : r1.xyz;

  return;
}