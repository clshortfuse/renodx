// ---- Created with 3Dmigoto v1.4.1 on Sun Jan 19 11:18:16 2025

cbuffer cb6 : register(b6) {
  int4 g_i2InputSize : packoffset(c0);
  int4 g_i2OutputSize : packoffset(c1);
  float4 DepthToW : packoffset(c2);
  float4 g_vCoCParams : packoffset(c3);
  float4 NearFocusParams : packoffset(c4);
  float4 FarFocusParams : packoffset(c5);
  float4 VignetteParams : packoffset(c6);
  float4 DepthToView : packoffset(c7);
  float4 Multipliers : packoffset(c8);
}

Texture2D<float4> mapInputTexture0 : register(t0);
RWTexture2D<float> g_uavOutputR : register(u1);

// 3Dmigoto declarations
#define cmp -

[numthreads(2, 128, 1)]
void main(uint2 vThreadGroupID: SV_GroupID, uint2 vThreadIDInGroup: SV_GroupThreadID) {
  // Needs manual fix for instruction:
  // unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u1
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Needs manual fix for instruction:
  // unknown dcl_: dcl_thread_group 2, 128, 1
  r0.xy = (uint2)vThreadGroupID.xy << int2(1, 7);
  r0.xy = (int2)r0.xy + (int2)vThreadIDInGroup.xy;
  r1.xy = cmp((int2)r0.xy < (int2)g_i2OutputSize.xy);
  r1.x = r1.y ? r1.x : 0;
  if (r1.x != 0) {
    r1.x = cmp(0 != Multipliers.w);
    r1.yz = float2(32, 20) * Multipliers.yy;
    r1.w = max(FarFocusParams.z, NearFocusParams.z);
    r1.w = g_vCoCParams.w * r1.w;
    r1.x = r1.x ? r1.z : r1.w;
    r1.x = max(r1.y, r1.x);
    r1.x = Multipliers.y * r1.x;
    r1.x = (int)r1.x;
    r1.y = -(int)r1.x;
    r0.w = 0;
    r1.z = 0;
    r1.w = r1.y;
    while (true) {
      r2.x = cmp((int)r1.x < (int)r1.w);
      if (r2.x != 0) break;
      r0.z = (int)r0.y + (int)r1.w;
      r2.x = mapInputTexture0.Load(r0.xzw).x;
      r0.z = max((int)r1.w, (int)-r1.w);
      r0.z = (int)r0.z;
      r0.z = cmp(r0.z >= abs(r2.x));
      r2.x = max(r2.x, r1.z);
      r1.z = r0.z ? r2.x : r1.z;
      r1.w = (int)r1.w + 1;
    }
    // No code for instruction (needs manual fix):
    // store_uav_typed u1.xyzw, r0.xyyy, r1.zzzz
    g_uavOutputR[r0.xy] = r1.z;
  }
  return;
}
