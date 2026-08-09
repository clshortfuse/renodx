Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  r1.xyzw = r0.xyzw * float4(2,2,2,1) + float4(-0.5,-0.5,-0.5,-0.5);
  o0.xyzw = r0.wwww * r1.xyzw + float4(0.5,0.5,0.5,0.5);
  o0 = max(0, o0);
  return;
}