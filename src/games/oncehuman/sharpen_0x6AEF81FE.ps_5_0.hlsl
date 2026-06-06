// Once Human (sm5 / DX11) - post-tonemap sharpen / AA resolve (reads LDR buffer -> writes swapchain).
// RenoDX HDR injection: the ONLY change is removing the saturate() clamp on the main
// path so HDR values (>1.0) emitted by the upgraded tonemap survive into the swapchain.
// Original decompile by 3Dmigoto.

cbuffer _Globals : register(b0) {
  float4 RTSize : packoffset(c0);
}

cbuffer PerCamera : register(b2) {
  float4 CameraInfo : packoffset(c0);
  float4 PhysicalCameraInfo : packoffset(c1);
  float4 CameraPosition : packoffset(c2);
  float4 CameraPositionLast : packoffset(c3);
  float4 ZBufferParams : packoffset(c4);
  row_major float4x4 InverseView : packoffset(c5);
  row_major float4x4 InverseViewLastFrame : packoffset(c9);
  row_major float4x4 View : packoffset(c13);
  row_major float4x4 ViewLast : packoffset(c17);
  row_major float4x4 ViewProjection : packoffset(c21);
  row_major float4x4 InverseViewProjection : packoffset(c25);
  row_major float4x4 InverseProjection : packoffset(c29);
  row_major float4x4 Projection : packoffset(c33);
  row_major float4x4 ProjectionLast : packoffset(c37);
  row_major float4x4 ViewProjectionLastFrame : packoffset(c41);
  row_major float4x4 WorldViewProjection : packoffset(c45);
  float4 TaaInfo[2] : packoffset(c49);
  float4 TaaSampleWeights[3] : packoffset(c51);
  row_major float4x4 ClipToLast : packoffset(c54);
  row_major float4x4 ViewProjectionJitter : packoffset(c58);
  row_major float4x4 InverseViewProjectionJitter : packoffset(c62);
  row_major float4x4 InverseProjectionJitter : packoffset(c66);
  row_major float4x4 ProjectionJitter : packoffset(c70);
  row_major float4x4 ViewProjectionLastFrameJitter : packoffset(c74);
  row_major float4x4 ViewportTrans : packoffset(c78);
  row_major float4x4 FirstPersonTransform : packoffset(c82);
  row_major float4x4 PrevFirstPersonTransform : packoffset(c86);
}

SamplerState Sampler_Point_Clamp_s : register(s0);
Texture2D<float4> SrcTex : register(t0);

#define cmp -

void main(
    float4 v0 : TEXCOORD0,
    float4 v1 : TEXCOORD1,
    out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = RTSize.zwzw * float4(0, -1, -1, 0) + v0.xyxy;
  r1.xyzw = SrcTex.Sample(Sampler_Point_Clamp_s, r0.xy).xyzw;
  r0.xyzw = SrcTex.Sample(Sampler_Point_Clamp_s, r0.zw).xyzw;
  r2.xyzw = SrcTex.Sample(Sampler_Point_Clamp_s, v0.xy).xyzw;
  r3.xyzw = RTSize.zwzw * float4(1, 0, 0, 1) + v0.xyxy;
  r4.xyzw = SrcTex.Sample(Sampler_Point_Clamp_s, r3.xy).xyzw;
  r3.xyzw = SrcTex.Sample(Sampler_Point_Clamp_s, r3.zw).xyzw;
  r1.xyz = r1.xyz * r1.xyz;
  r0.xyz = r0.xyz * r0.xyz;
  r5.xyz = r2.xyz * r2.xyz;
  r4.xyz = r4.xyz * r4.xyz;
  r3.xyz = r3.xyz * r3.xyz;
  r6.xyz = min(r4.xyz, r0.xyz);
  r6.xyz = min(r6.xyz, r1.xyz);
  r6.xyz = min(r6.xyz, r3.xyz);
  r7.xyz = max(r4.xyz, r0.xyz);
  r7.xyz = max(r7.xyz, r1.xyz);
  r7.xyz = max(r7.xyz, r3.xyz);
  r8.xyz = r2.xyz * r2.xyz + -r6.xyz;
  r9.xyz = r2.xyz * r2.xyz + -r7.xyz;
  r8.xyz = cmp(r8.xyz < float3(0, 0, 0));
  r6.w = r8.y ? r8.x : 0;
  r6.w = r8.z ? r6.w : 0;
  r8.xyz = cmp(float3(0, 0, 0) < r9.xyz);
  r7.w = r8.y ? r8.x : 0;
  r7.w = r8.z ? r7.w : 0;
  r6.w = (int)r6.w | (int)r7.w;
  if (r6.w != 0) {
    o0.xyz = abs(r2.xyz);
    o0.w = 1;
  }
  if (r6.w == 0) {
    r2.xyz = r7.xyz * float3(4, 4, 4) + float3(9.99999975e-006, 9.99999975e-006, 9.99999975e-006);
    r2.xyz = r6.xyz / r2.xyz;
    r7.xyz = float3(1, 1, 1) + -r7.xyz;
    r6.xyz = r6.xyz * float3(4, 4, 4) + float3(-4, -4, -4);
    r6.xyz = r7.xyz / r6.xyz;
    r2.xyz = max(r6.xyz, -r2.xyz);
    r2.y = max(r2.y, r2.z);
    r2.x = max(r2.x, r2.y);
    r2.x = min(0, r2.x);
    r2.x = max(-0.1875, r2.x);
    r2.x = 0.84089601 * r2.x;
    r2.yz = cmp(float2(0.5, 0.5) < TaaInfo[0].xy);
    r2.y = (int)r2.z | (int)r2.y;
    if (r2.y == 0) {
      r2.y = r1.z + r1.x;
      r2.y = r2.y * 0.5 + r1.y;
      r2.z = r0.z + r0.x;
      r2.z = r2.z * 0.5 + r0.y;
      r6.x = r5.z + r5.x;
      r6.x = r6.x * 0.5 + r5.y;
      r6.y = r4.z + r4.x;
      r6.y = r6.y * 0.5 + r4.y;
      r6.z = r3.z + r3.x;
      r6.z = r6.z * 0.5 + r3.y;
      r6.w = r2.y + r2.z;
      r6.w = r6.w + r6.y;
      r6.w = r6.w + r6.z;
      r6.w = r6.w * 0.25 + -r6.x;
      r7.x = max(r6.x, r2.z);
      r7.x = max(r7.x, r2.y);
      r7.y = max(r6.y, r6.z);
      r7.x = max(r7.x, r7.y);
      r2.z = min(r6.x, r2.z);
      r2.y = min(r2.y, r2.z);
      r2.z = min(r6.y, r6.z);
      r2.y = min(r2.y, r2.z);
      r2.y = r7.x + -r2.y;
      r2.y = 9.99999975e-006 + r2.y;
      r2.y = saturate(abs(r6.w) / r2.y);
      r2.y = r2.y * -0.5 + 1;
      r2.x = r2.x * r2.y;
    }
    r0.xyzw = r1.xyzw + r0.xyzw;
    r0.xyzw = r3.xyzw + r0.xyzw;
    r0.xyzw = r4.xyzw + r0.xyzw;
    r5.w = r2.w;
    r0.xyzw = r0.xyzw * r2.xxxx + r5.xyzw;
    r1.x = r2.x * 4 + 1;
    r1.x = 1 / r1.x;
    r0.xyzw = r1.xxxx * r0.xyzw;
    // RENODX: was saturate(r0.xyz) -- clamp removed so HDR highlights (>1.0) pass through.
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    o0.xyz = sqrt(r0.xyz);
    o0.w = r0.w;
  }
  return;
}
