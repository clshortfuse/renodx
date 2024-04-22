// ---- Created with 3Dmigoto v1.3.16 on Sat Apr 20 18:02:57 2024
struct u0_t {
  float val[28];
};
RWStructuredBuffer<u0_t> u0 : register(u0);

ByteAddressBuffer t0 :register(t0);
ByteAddressBuffer t1 :register(t1);

cbuffer cb0 : register(b0)
{
  float4 cb0[21];
}

RWByteAddressBuffer u1 :register(u1);
RWByteAddressBuffer u2 :register(u2);
RWByteAddressBuffer u3 :register(u3);
RWByteAddressBuffer u4 :register(u4);
RWByteAddressBuffer u5 :register(u5);
RWByteAddressBuffer u6 :register(u6);
RWByteAddressBuffer u7 :register(u7);




// 3Dmigoto declarations
#define cmp -

[numthreads(1, 1, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID) 
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_resource_raw t0
// Needs manual fix for instruction:
// unknown dcl_: dcl_resource_raw t1
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u1
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u2
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u3
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u4
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u5
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u6
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_raw u7
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31,r32,r33,r34,r35,r36,r37,r38,r39,r40,r41,r42,r43,r44,r45,r46,r47,r48,r49,r50,r51,r52,r53,r54,r55,r56,r57,r58,r59,r60,r61,r62,r63,r64,r65,r66,r67,r68,r69,r70,r71,r72;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 1, 1, 1
  r0.x = cmp((uint)vThreadID.x < asuint(cb0[8].x));
  if (r0.x != 0) {
    r0.x = u0[vThreadID.x].val[0/4];
    r0.y = u0[vThreadID.x].val[0/4+1];
    r0.z = u0[vThreadID.x].val[0/4+2];
    r1.x = u0[vThreadID.x].val[16/4];
    r1.y = u0[vThreadID.x].val[16/4+1];
    r1.z = u0[vThreadID.x].val[16/4+2];
    r2.x = u0[vThreadID.x].val[32/4];
    r2.y = u0[vThreadID.x].val[32/4+1];
    r2.z = u0[vThreadID.x].val[32/4+2];
    r2.w = u0[vThreadID.x].val[32/4+3];
    r3.x = u0[vThreadID.x].val[48/4];
    r3.y = u0[vThreadID.x].val[48/4+1];
    r3.z = u0[vThreadID.x].val[48/4+2];
    r3.w = u0[vThreadID.x].val[48/4+3];
    r4.x = u0[vThreadID.x].val[64/4];
    r4.y = u0[vThreadID.x].val[64/4+1];
    r4.z = u0[vThreadID.x].val[64/4+2];
    r4.w = u0[vThreadID.x].val[64/4+3];
    r5.x = u0[vThreadID.x].val[80/4];
    r5.y = u0[vThreadID.x].val[80/4+1];
    r5.z = u0[vThreadID.x].val[80/4+2];
    r5.w = u0[vThreadID.x].val[80/4+3];
    r0.w = u0[vThreadID.x].val[96/4];
    r1.w = asint(cb0[8].z) + 7;
    r1.w = (uint)r1.w >> 3;
    r6.x = 0;
    while (true) {
      r6.y = cmp((uint)r6.x >= (uint)r1.w);
      if (r6.y != 0) break;
      r6.y = (uint)r6.x << 4;
    // No code for instruction (needs manual fix):
    // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r7.xyzw, r6.y, t0.xyzw
        r7.xyzw = t0.Load4(r6.y);
    // No code for instruction (needs manual fix):
        u2.Store4(r6.y, r7.xyzw);
        // store_raw u2.xyzw, r6.y, r7.xyzw
      r6.x = (int)r6.x + 1;
    }
    r1.w = dot(cb0[4].xyz, cb0[3].xyz);
    r7.xyz = r1.xyz;
    r8.xyzw = r2.xyzw;
    r9.xyzw = r3.xyzw;
    r10.xyzw = r4.xyzw;
    r11.xyzw = r5.xyzw;
    r6.xyzw = r0.xyzw;
    r7.w = cb0[6].y;
    r12.x = cb0[9].y;
    r12.y = cb0[10].y;
    r12.z = cb0[11].y;
    r12.w = 0;
    while (true) {
      r13.x = cmp((uint)r12.w >= asuint(cb0[8].y));
      if (r13.x != 0) break;
      r13.xyzw = cmp((int4)r12.wwww == int4(0,1,2,3));
      r14.xyzw = cmp((int4)r12.wwww == int4(4,5,6,7));
      r15.xyzw = cmp((int4)r12.wwww == int4(8,9,10,11));
      r16.xyz = r13.xxx ? cb0[9].xzw : 0;
      r17.xyz = r13.yyy ? cb0[10].xzw : 0;
      r16.xyz = (int3)r16.xyz | (int3)r17.xyz;
      r17.xyz = r13.zzz ? cb0[11].xzw : 0;
      r16.xyz = (int3)r16.xyz | (int3)r17.xyz;
      r17.xyzw = r13.wwww ? cb0[12].xzwy : 0;
      r16.xyz = (int3)r16.xyz | (int3)r17.xyz;
      r18.xyzw = r14.xxxx ? cb0[13].xzwy : 0;
      r16.xyz = (int3)r16.xyz | (int3)r18.xyz;
      r19.xyzw = r14.yyyy ? cb0[14].xzwy : 0;
      r16.xyz = (int3)r16.xyz | (int3)r19.xyz;
      r20.xyzw = r14.zzzz ? cb0[15].xzwy : 0;
      r14.xyz = (int3)r16.xyz | (int3)r20.xyz;
      r16.xyzw = r14.wwww ? cb0[16].xzwy : 0;
      r14.xyz = (int3)r14.xyz | (int3)r16.xyz;
      r21.xyzw = r15.xxxx ? cb0[17].xzwy : 0;
      r14.xyz = (int3)r14.xyz | (int3)r21.xyz;
      r22.xyzw = r15.yyyy ? cb0[18].xzwy : 0;
      r14.xyz = (int3)r14.xyz | (int3)r22.xyz;
      r23.xyzw = r15.zzzz ? cb0[19].xzwy : 0;
      r14.xyz = (int3)r14.xyz | (int3)r23.xyz;
      r15.xyzw = r15.wwww ? cb0[20].xzwy : 0;
      r14.xyz = (int3)r14.xyz | (int3)r15.xyz;
      r13.w = (uint)r14.x >> 16;
      r14.x = r14.x ? 0.000000 : 0;
      r14.x = mad((int)r14.x, 3, (int)r13.w);
      r15.xy = cmp((int2)r14.yz == int2(1,1));
      r14.yz = cmp((int2)r14.zy != int2(1,1));
      r14.yz = r14.yz ? r15.xy : 0;
      r15.xy = ~(int2)r14.yz;
      r14.w = r15.y ? r15.x : 0;
      r13.xy = r13.xy ? r12.xy : 0;
      r13.x = (int)r13.x | (int)r13.y;
      r13.y = r13.z ? r12.z : 0;
      r13.x = (int)r13.x | (int)r13.y;
      r13.x = (int)r13.x | (int)r17.w;
      r13.x = (int)r13.x | (int)r18.w;
      r13.x = (int)r13.x | (int)r19.w;
      r13.x = (int)r13.x | (int)r20.w;
      r13.x = (int)r13.x | (int)r16.w;
      r13.x = (int)r13.x | (int)r21.w;
      r13.x = (int)r13.x | (int)r22.w;
      r13.x = (int)r13.x | (int)r23.w;
      r13.x = (int)r13.x | (int)r15.w;
      r15.xyzw = r10.xyzw;
      r16.xyzw = r11.xyzw;
      r17.xyz = r6.xyz;
      r18.xyz = r7.xyz;
      r19.xy = r8.yw;
      r20.xy = r9.xy;
      r13.y = r7.w;
      r13.z = r8.x;
      r21.x = r8.z;
      r17.w = r9.w;
      r18.w = r6.w;
      r21.w = 0;
      r22.x = r13.w;
      while (true) {
        r22.w = cmp((uint)r22.x >= (uint)r14.x);
        if (r22.w != 0) break;
        r22.w = (int)r22.x & 1;
        r23.x = (uint)r22.x >> 1;
        r23.x = (uint)r23.x << 2;
      // No code for instruction (needs manual fix):
            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r23.y, r23.x, t0.xxxx 
r23.y = t0.Load(r23.x);
        r23.z = (uint)r23.y >> 16;
        r23.y = (int)r23.y & 0x0000ffff;
        r23.w = (int)-r22.w + 1;
        r23.y = (int)r23.w * (int)r23.y;
        r23.y = mad((int)r23.z, (int)r22.w, (int)r23.y);
        r22.xyz = (int3)r22.xxx + int3(3,1,2);
        r24.xy = (int2)r22.yz & int2(1,1);
        r22.yz = (uint2)r22.yz >> int2(1,1);
        r22.yz = (uint2)r22.yz << int2(2,2);
      // No code for instruction (needs manual fix):
            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r23.z, r22.y, t0.xxxx 
r23.z = t0.Load(r22.y);
        r24.z = (uint)r23.z >> 16;
        r23.z = (int)r23.z & 0x0000ffff;
        r25.xy = (int2)-r24.xy + int2(1,1);
        r23.z = (int)r23.z * (int)r25.x;
        r23.z = mad((int)r24.z, (int)r24.x, (int)r23.z);
      // No code for instruction (needs manual fix):
            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r24.z, r22.z, t0.xxxx 
r24.z = t0.Load(r22.z);
        r24.w = (uint)r24.z >> 16;
        r24.z = (int)r24.z & 0x0000ffff;
        r24.z = (int)r25.y * (int)r24.z;
        r24.z = mad((int)r24.w, (int)r24.y, (int)r24.z);
        if (r14.w != 0) {
          r24.w = (int)r23.y * asint(cb0[5].x);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r24.w, r24.w, t1.xxxx 
r24.w = t1.Load(r24.w);
          r26.x = f16tof32(r24.w);
          r24.w = (uint)r24.w >> 16;
          r26.y = f16tof32(r24.w);
          r24.w = mad((int)r23.y, asint(cb0[5].x), 4);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r24.w, r24.w, t1.xxxx 
r24.w = t1.Load(r24.w);
          r26.z = f16tof32(r24.w);
          r25.z = (int)r23.z * asint(cb0[5].x);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r25.z, r25.z, t1.xxxx 
r25.z = t1.Load(r25.z);
          r27.x = f16tof32(r25.z);
          r25.z = (uint)r25.z >> 16;
          r27.y = f16tof32(r25.z);
          r25.z = mad((int)r23.z, asint(cb0[5].x), 4);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r25.z, r25.z, t1.xxxx 
r25.z = t1.Load(r25.z);
          r27.z = f16tof32(r25.z);
          r25.w = (int)r24.z * asint(cb0[5].x);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r25.w, r25.w, t1.xxxx 
r25.w = t1.Load(r25.w);
          r28.x = f16tof32(r25.w);
          r25.w = (uint)r25.w >> 16;
          r28.y = f16tof32(r25.w);
          r25.w = mad((int)r24.z, asint(cb0[5].x), 4);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r25.w, r25.w, t1.xxxx 
r25.w = t1.Load(r25.w);
          r28.z = f16tof32(r25.w);
          r29.xyz = -cb0[3].xyz + r26.xyz;
          r29.x = dot(r29.xyz, cb0[4].xyz);
          r30.xyz = -cb0[3].xyz + r27.xyz;
          r29.y = dot(r30.xyz, cb0[4].xyz);
          r30.xyz = -cb0[3].xyz + r28.xyz;
          r29.z = dot(r30.xyz, cb0[4].xyz);
          r30.xyz = cmp(float3(0,0,0) < r29.xyz);
          r26.w = (int)r30.y | (int)r30.x;
          r26.w = (int)r30.z | (int)r26.w;
          r30.xyz = cmp(r29.xyz < float3(0,0,0));
          r27.w = (int)r30.y | (int)r30.x;
          r27.w = (int)r30.z | (int)r27.w;
          if (r13.x == 0) {
            r30.xyz = cmp(abs(r29.xyz) < float3(9.99999975e-05,9.99999975e-05,9.99999975e-05));
            r28.w = r30.y ? r30.x : 0;
            r28.w = r30.z ? r28.w : 0;
            r29.w = (int)r26.w & (int)r27.w;
            r28.w = (int)r28.w | (int)r29.w;
            if (r28.w != 0) {
              r30.x = dot(cb0[0].xyz, r26.xyz);
              r30.y = dot(cb0[1].xyz, r26.xyz);
              r30.z = dot(cb0[2].xyz, r26.xyz);
              r31.x = dot(cb0[0].xyz, r27.xyz);
              r31.y = dot(cb0[1].xyz, r27.xyz);
              r31.z = dot(cb0[2].xyz, r27.xyz);
              r32.x = dot(cb0[0].xyz, r28.xyz);
              r32.y = dot(cb0[1].xyz, r28.xyz);
              r32.z = dot(cb0[2].xyz, r28.xyz);
              r33.xyz = min(r32.xyz, r31.xyz);
              r33.xyz = min(r33.xyz, r30.xyz);
              r17.xyz = min(r33.xyz, r17.xyz);
              r31.xyz = max(r32.xyz, r31.xyz);
              r30.xyz = max(r31.xyz, r30.xyz);
              r18.xyz = max(r30.xyz, r18.xyz);
              r28.w = (uint)r24.w >> 16;
              r30.x = f16tof32(r28.w);
              r31.xyz = mad((int3)r23.yyy, asint(cb0[5].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r31.x, t1.xxxx 
r28.w = t1.Load(r31.x);
              r29.w = (int)r28.w & 255;
              r29.w = (uint)r29.w;
              r32.x = r29.w * 0.00784313772 + -1;
              if (8 == 0) r31.x = 0; else if (8+8 < 32) {               r31.x = (uint)r28.w << (32-(8 + 8)); r31.x = (uint)r31.x >> (32-8);              } else r31.x = (uint)r28.w >> 8;
              if (8 == 0) r31.w = 0; else if (8+16 < 32) {               r31.w = (uint)r28.w << (32-(8 + 16)); r31.w = (uint)r31.w >> (32-8);              } else r31.w = (uint)r28.w >> 16;
              r31.xw = (uint2)r31.xw;
              r32.yz = r31.xw * float2(0.00784313772,0.00784313772) + float2(-1,-1);
              r28.w = (uint)r28.w >> 24;
              r28.w = (uint)r28.w;
              r30.y = r28.w * 0.00784313772 + -1;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r31.y, t1.xxxx 
r28.w = t1.Load(r31.y);
              r29.w = (int)r28.w & 255;
              r29.w = (uint)r29.w;
              r33.x = r29.w * 0.00784313772 + -1;
              if (8 == 0) r31.x = 0; else if (8+8 < 32) {               r31.x = (uint)r28.w << (32-(8 + 8)); r31.x = (uint)r31.x >> (32-8);              } else r31.x = (uint)r28.w >> 8;
              if (8 == 0) r31.y = 0; else if (8+16 < 32) {               r31.y = (uint)r28.w << (32-(8 + 16)); r31.y = (uint)r31.y >> (32-8);              } else r31.y = (uint)r28.w >> 16;
              r31.xy = (uint2)r31.xy;
              r33.yz = r31.xy * float2(0.00784313772,0.00784313772) + float2(-1,-1);
              r28.w = (uint)r28.w >> 24;
              r28.w = (uint)r28.w;
              r30.z = r28.w * 0.00784313772 + -1;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r31.z, t1.xxxx 
r28.w = t1.Load(r31.z);
              r31.x = f16tof32(r28.w);
              r28.w = (uint)r28.w >> 16;
              r31.y = f16tof32(r28.w);
              r28.w = mad((int)r23.y, asint(cb0[5].x), (int)r13.y);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r28.w, t1.xxxx 
r28.w = t1.Load(r28.w);
              r29.w = (int)r28.w & 255;
              r29.w = (uint)r29.w;
              r34.x = 0.00392156886 * r29.w;
              if (8 == 0) r31.z = 0; else if (8+8 < 32) {               r31.z = (uint)r28.w << (32-(8 + 8)); r31.z = (uint)r31.z >> (32-8);              } else r31.z = (uint)r28.w >> 8;
              if (8 == 0) r31.w = 0; else if (8+16 < 32) {               r31.w = (uint)r28.w << (32-(8 + 16)); r31.w = (uint)r31.w >> (32-8);              } else r31.w = (uint)r28.w >> 16;
              r35.xy = (uint2)r31.zw;
              r34.yz = float2(0.00392156886,0.00392156886) * r35.xy;
              r29.w = (uint)r28.w >> 24;
              r30.w = (uint)r29.w;
              r34.w = 0.00392156886 * r30.w;
              r30.w = mad((int)r23.y, asint(cb0[5].x), asint(cb0[6].z));
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r32.w, r30.w, t1.xxxx 
r32.w = t1.Load(r30.w);
              r35.x = f16tof32(r32.w);
              r32.w = (uint)r32.w >> 16;
              r35.y = f16tof32(r32.w);
              r30.w = (int)r30.w + 4;
            // No code for instruction (needs manual fix):
                      // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.xy, r30.w, t1.xyxx 
r36.xy = t1.Load2(r30.w);
              r35.z = f16tof32(r36.x);
              r37.xw = (uint2)r36.xy >> int2(16,24);
              r35.w = f16tof32(r37.x);
              r37.x = (int)r36.y & 255;
              if (8 == 0) r37.y = 0; else if (8+8 < 32) {               r37.y = (uint)r36.y << (32-(8 + 8)); r37.y = (uint)r37.y >> (32-8);              } else r37.y = (uint)r36.y >> 8;
              if (8 == 0) r37.z = 0; else if (8+16 < 32) {               r37.z = (uint)r36.y << (32-(8 + 16)); r37.z = (uint)r37.z >> (32-8);              } else r37.z = (uint)r36.y >> 16;
              r30.w = (uint)r25.z >> 16;
              r38.x = f16tof32(r30.w);
              r36.xzw = mad((int3)r23.zzz, asint(cb0[5].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r36.x, t1.xxxx 
r30.w = t1.Load(r36.x);
              r32.w = (int)r30.w & 255;
              r32.w = (uint)r32.w;
              r39.x = r32.w * 0.00784313772 + -1;
              if (8 == 0) r40.x = 0; else if (8+8 < 32) {               r40.x = (uint)r30.w << (32-(8 + 8)); r40.x = (uint)r40.x >> (32-8);              } else r40.x = (uint)r30.w >> 8;
              if (8 == 0) r40.y = 0; else if (8+16 < 32) {               r40.y = (uint)r30.w << (32-(8 + 16)); r40.y = (uint)r40.y >> (32-8);              } else r40.y = (uint)r30.w >> 16;
              r40.xy = (uint2)r40.xy;
              r39.yz = r40.xy * float2(0.00784313772,0.00784313772) + float2(-1,-1);
              r30.w = (uint)r30.w >> 24;
              r30.w = (uint)r30.w;
              r38.y = r30.w * 0.00784313772 + -1;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r36.z, t1.xxxx 
r30.w = t1.Load(r36.z);
              r32.w = (int)r30.w & 255;
              r32.w = (uint)r32.w;
              r40.x = r32.w * 0.00784313772 + -1;
              if (8 == 0) r36.x = 0; else if (8+8 < 32) {               r36.x = (uint)r30.w << (32-(8 + 8)); r36.x = (uint)r36.x >> (32-8);              } else r36.x = (uint)r30.w >> 8;
              if (8 == 0) r36.z = 0; else if (8+16 < 32) {               r36.z = (uint)r30.w << (32-(8 + 16)); r36.z = (uint)r36.z >> (32-8);              } else r36.z = (uint)r30.w >> 16;
              r36.xz = (uint2)r36.xz;
              r40.yz = r36.xz * float2(0.00784313772,0.00784313772) + float2(-1,-1);
              r30.w = (uint)r30.w >> 24;
              r30.w = (uint)r30.w;
              r38.z = r30.w * 0.00784313772 + -1;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r36.w, t1.xxxx 
r30.w = t1.Load(r36.w);
              r41.x = f16tof32(r30.w);
              r30.w = (uint)r30.w >> 16;
              r41.y = f16tof32(r30.w);
              r30.w = mad((int)r23.z, asint(cb0[5].x), (int)r13.y);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r30.w, t1.xxxx 
r30.w = t1.Load(r30.w);
              r32.w = (int)r30.w & 255;
              r32.w = (uint)r32.w;
              r42.x = 0.00392156886 * r32.w;
              if (8 == 0) r36.x = 0; else if (8+8 < 32) {               r36.x = (uint)r30.w << (32-(8 + 8)); r36.x = (uint)r36.x >> (32-8);              } else r36.x = (uint)r30.w >> 8;
              if (8 == 0) r36.z = 0; else if (8+16 < 32) {               r36.z = (uint)r30.w << (32-(8 + 16)); r36.z = (uint)r36.z >> (32-8);              } else r36.z = (uint)r30.w >> 16;
              r41.zw = (uint2)r36.xz;
              r42.yz = float2(0.00392156886,0.00392156886) * r41.zw;
              r32.w = (uint)r30.w >> 24;
              r33.w = (uint)r32.w;
              r42.w = 0.00392156886 * r33.w;
              r33.w = mad((int)r23.z, asint(cb0[5].x), asint(cb0[6].z));
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.w, r33.w, t1.xxxx 
r36.w = t1.Load(r33.w);
              r43.x = f16tof32(r36.w);
              r36.w = (uint)r36.w >> 16;
              r43.y = f16tof32(r36.w);
              r33.w = (int)r33.w + 4;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r41.zw, r33.w, t1.xxxy
                        r41.zw = t1.Load2(r33.w);
              r43.z = f16tof32(r41.z);
              r44.xw = (uint2)r41.zw >> int2(16,24);
              r43.w = f16tof32(r44.x);
              r44.x = (int)r41.w & 255;
              if (8 == 0) r44.y = 0; else if (8+8 < 32) {               r44.y = (uint)r41.w << (32-(8 + 8)); r44.y = (uint)r44.y >> (32-8);              } else r44.y = (uint)r41.w >> 8;
              if (8 == 0) r44.z = 0; else if (8+16 < 32) {               r44.z = (uint)r41.w << (32-(8 + 16)); r44.z = (uint)r44.z >> (32-8);              } else r44.z = (uint)r41.w >> 16;
              r33.w = (uint)r25.w >> 16;
              r45.x = f16tof32(r33.w);
              r46.xyz = mad((int3)r24.zzz, asint(cb0[5].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r46.x, t1.xxxx 
r33.w = t1.Load(r46.x);
              r36.w = (int)r33.w & 255;
              r36.w = (uint)r36.w;
              r47.x = r36.w * 0.00784313772 + -1;
              if (8 == 0) r46.x = 0; else if (8+8 < 32) {               r46.x = (uint)r33.w << (32-(8 + 8)); r46.x = (uint)r46.x >> (32-8);              } else r46.x = (uint)r33.w >> 8;
              if (8 == 0) r46.w = 0; else if (8+16 < 32) {               r46.w = (uint)r33.w << (32-(8 + 16)); r46.w = (uint)r46.w >> (32-8);              } else r46.w = (uint)r33.w >> 16;
              r46.xw = (uint2)r46.xw;
              r47.yz = r46.xw * float2(0.00784313772,0.00784313772) + float2(-1,-1);
              r33.w = (uint)r33.w >> 24;
              r33.w = (uint)r33.w;
              r45.y = r33.w * 0.00784313772 + -1;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r46.y, t1.xxxx 
r33.w = t1.Load(r46.y);
              r36.w = (int)r33.w & 255;
              r36.w = (uint)r36.w;
              r48.x = r36.w * 0.00784313772 + -1;
              if (8 == 0) r46.x = 0; else if (8+8 < 32) {               r46.x = (uint)r33.w << (32-(8 + 8)); r46.x = (uint)r46.x >> (32-8);              } else r46.x = (uint)r33.w >> 8;
              if (8 == 0) r46.y = 0; else if (8+16 < 32) {               r46.y = (uint)r33.w << (32-(8 + 16)); r46.y = (uint)r46.y >> (32-8);              } else r46.y = (uint)r33.w >> 16;
              r46.xy = (uint2)r46.xy;
              r48.yz = r46.xy * float2(0.00784313772,0.00784313772) + float2(-1,-1);
              r33.w = (uint)r33.w >> 24;
              r33.w = (uint)r33.w;
              r45.z = r33.w * 0.00784313772 + -1;
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r46.z, t1.xxxx 
r33.w = t1.Load(r46.z);
              r46.x = f16tof32(r33.w);
              r33.w = (uint)r33.w >> 16;
              r46.y = f16tof32(r33.w);
              r33.w = mad((int)r24.z, asint(cb0[5].x), (int)r13.y);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r33.w, t1.xxxx 
r33.w = t1.Load(r33.w);
              r36.w = (int)r33.w & 255;
              r36.w = (uint)r36.w;
              r49.x = 0.00392156886 * r36.w;
              if (8 == 0) r46.z = 0; else if (8+8 < 32) {               r46.z = (uint)r33.w << (32-(8 + 8)); r46.z = (uint)r46.z >> (32-8);              } else r46.z = (uint)r33.w >> 8;
              if (8 == 0) r46.w = 0; else if (8+16 < 32) {               r46.w = (uint)r33.w << (32-(8 + 16)); r46.w = (uint)r46.w >> (32-8);              } else r46.w = (uint)r33.w >> 16;
              r50.xy = (uint2)r46.zw;
              r49.yz = float2(0.00392156886,0.00392156886) * r50.xy;
              r36.w = (uint)r33.w >> 24;
              r38.w = (uint)r36.w;
              r49.w = 0.00392156886 * r38.w;
              r38.w = mad((int)r24.z, asint(cb0[5].x), asint(cb0[6].z));
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r39.w, r38.w, t1.xxxx 
r39.w = t1.Load(r38.w);
              r50.x = f16tof32(r39.w);
              r39.w = (uint)r39.w >> 16;
              r50.y = f16tof32(r39.w);
              r38.w = (int)r38.w + 4;
            // No code for instruction (needs manual fix):
                      // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r51.xy, r38.w, t1.xyxx 
r51.xy = t1.Load2(r38.w);
              r50.z = f16tof32(r51.x);
              r52.xw = (uint2)r51.xy >> int2(16,24);
              r50.w = f16tof32(r52.x);
              r52.x = (int)r51.y & 255;
              if (8 == 0) r52.y = 0; else if (8+8 < 32) {               r52.y = (uint)r51.y << (32-(8 + 8)); r52.y = (uint)r52.y >> (32-8);              } else r52.y = (uint)r51.y >> 8;
              if (8 == 0) r52.z = 0; else if (8+16 < 32) {               r52.z = (uint)r51.y << (32-(8 + 16)); r52.z = (uint)r52.z >> (32-8);              } else r52.z = (uint)r51.y >> 16;
              r51.xzw = r27.xyz + -r26.xyz;
              r38.w = dot(cb0[4].xyz, r51.xzw);
              r39.w = cmp(abs(r38.w) < 1.1920929e-07);
              r53.xyz = cb0[4].xyz * r1.www + -r26.xyz;
              r40.w = dot(cb0[4].xyz, r53.xyz);
              r38.w = rcp(r38.w);
              r38.w = r40.w * r38.w;
              r38.w = max(-5, r38.w);
              r38.w = min(5, r38.w);
              r40.w = r39.w ? 0.5 : r38.w;
              r53.xyz = r28.xyz + -r27.xyz;
              r41.z = dot(cb0[4].xyz, r53.xyz);
              r45.w = cmp(abs(r41.z) < 1.1920929e-07);
              r54.xyz = cb0[4].xyz * r1.www + -r27.xyz;
              r47.w = dot(cb0[4].xyz, r54.xyz);
              r41.z = rcp(r41.z);
              r41.z = r47.w * r41.z;
              r41.z = max(-5, r41.z);
              r41.z = min(5, r41.z);
              r47.w = r45.w ? 0.5 : r41.z;
              r54.xyz = -r28.xyz + r26.xyz;
              r48.w = dot(cb0[4].xyz, r54.xyz);
              r53.w = cmp(abs(r48.w) < 1.1920929e-07);
              r55.xyz = cb0[4].xyz * r1.www + -r28.xyz;
              r54.w = dot(cb0[4].xyz, r55.xyz);
              r48.w = rcp(r48.w);
              r48.w = r54.w * r48.w;
              r48.w = max(-5, r48.w);
              r48.w = min(5, r48.w);
              r54.w = r53.w ? 0.5 : r48.w;
              r55.xy = cmp(r40.ww < float2(0,0.5));
              r40.w = cmp(1 < r40.w);
              r40.w = (int)r40.w | (int)r55.x;
              r39.w = (int)r39.w | (int)r40.w;
              r38.w = r39.w ? 0.5 : r38.w;
              r51.xzw = r38.www * r51.xzw + r26.xyz;
              r55.xzw = r39.xyz + -r32.xyz;
              r55.xzw = r38.www * r55.xzw + r32.xyz;
              r39.w = dot(r55.xzw, r55.xzw);
              r39.w = rsqrt(r39.w);
              r55.xzw = r55.xzw * r39.www;
              r56.xyz = r40.xyz + -r33.xyz;
              r56.xyz = r38.www * r56.xyz + r33.xyz;
              r39.w = dot(r56.xyz, r56.xyz);
              r39.w = rsqrt(r39.w);
              r56.xyz = r56.xyz * r39.www;
              r57.xyz = r38.xyz + -r30.xyz;
              r57.xyz = r38.www * r57.xyz + r30.xyz;
              r39.w = dot(r57.xyz, r57.xyz);
              r39.w = rsqrt(r39.w);
              r57.xyz = r57.xyz * r39.www;
              r58.xy = r41.xy + -r31.xy;
              r58.xy = r38.ww * r58.xy + r31.xy;
              r59.xyzw = r42.xyzw + -r34.xyzw;
              r59.xyzw = r38.wwww * r59.xyzw + r34.xyzw;
              r60.xyzw = r55.yyyy ? r35.xyzw : r43.xyzw;
              r61.xyzw = r55.yyyy ? r37.xyzw : r44.xyzw;
              r58.zw = cmp(r47.ww < float2(0,0.5));
              r38.w = cmp(1 < r47.w);
              r38.w = (int)r38.w | (int)r58.z;
              r38.w = (int)r38.w | (int)r45.w;
              r38.w = r38.w ? 0.5 : r41.z;
              r53.xyz = r38.www * r53.xyz + r27.xyz;
              r62.xyz = r47.xyz + -r39.xyz;
              r62.xyz = r38.www * r62.xyz + r39.xyz;
              r39.w = dot(r62.xyz, r62.xyz);
              r39.w = rsqrt(r39.w);
              r62.xyz = r62.xyz * r39.www;
              r63.xyz = r48.xyz + -r40.xyz;
              r63.xyz = r38.www * r63.xyz + r40.xyz;
              r39.w = dot(r63.xyz, r63.xyz);
              r39.w = rsqrt(r39.w);
              r63.xyz = r63.xyz * r39.www;
              r64.xyz = r45.xyz + -r38.xyz;
              r64.xyz = r38.www * r64.xyz + r38.xyz;
              r39.w = dot(r64.xyz, r64.xyz);
              r39.w = rsqrt(r39.w);
              r64.xyz = r64.xyz * r39.www;
              r65.xy = r46.xy + -r41.xy;
              r65.xy = r38.ww * r65.xy + r41.xy;
              r66.xyzw = r49.xyzw + -r42.xyzw;
              r42.xyzw = r38.wwww * r66.xyzw + r42.xyzw;
              r66.xyzw = r58.wwww ? r43.xyzw : r50.xyzw;
              r67.xyzw = r58.wwww ? r44.xyzw : r52.xyzw;
              r58.zw = cmp(r54.ww < float2(0,0.5));
              r38.w = cmp(1 < r54.w);
              r38.w = (int)r38.w | (int)r58.z;
              r38.w = (int)r38.w | (int)r53.w;
              r38.w = r38.w ? 0.5 : r48.w;
              r54.xyz = r38.www * r54.xyz + r28.xyz;
              r68.xyz = -r47.xyz + r32.xyz;
              r68.xyz = r38.www * r68.xyz + r47.xyz;
              r39.w = dot(r68.xyz, r68.xyz);
              r39.w = rsqrt(r39.w);
              r68.xyz = r68.xyz * r39.www;
              r69.xyz = -r48.xyz + r33.xyz;
              r69.xyz = r38.www * r69.xyz + r48.xyz;
              r39.w = dot(r69.xyz, r69.xyz);
              r39.w = rsqrt(r39.w);
              r69.xyz = r69.xyz * r39.www;
              r70.xyz = -r45.xyz + r30.xyz;
              r70.xyz = r38.www * r70.xyz + r45.xyz;
              r39.w = dot(r70.xyz, r70.xyz);
              r39.w = rsqrt(r39.w);
              r70.xyz = r70.xyz * r39.www;
              r65.zw = -r46.xy + r31.xy;
              r65.zw = r38.ww * r65.zw + r46.xy;
              r34.xyzw = -r49.xyzw + r34.xyzw;
              r34.xyzw = r38.wwww * r34.xyzw + r49.xyzw;
              r49.xyzw = r58.wwww ? r50.xyzw : r35.xyzw;
              r71.xyzw = r58.wwww ? r52.xyzw : r37.xyzw;
              r72.xyz = -cb0[3].xyz + r51.xzw;
              r37.x = dot(r72.xyz, cb0[4].xyz);
              r72.xyz = -cb0[3].xyz + r53.xyz;
              r38.w = dot(r72.xyz, cb0[4].xyz);
              r72.xyz = -cb0[3].xyz + r54.xyz;
              r39.w = dot(r72.xyz, cb0[4].xyz);
              r40.w = cmp(abs(r37.x) < 9.99999975e-05);
              r37.x = r40.w ? abs(r37.x) : r37.x;
              r40.w = cmp(abs(r38.w) < 9.99999975e-05);
              r38.w = r40.w ? abs(r38.w) : r38.w;
              r40.w = cmp(abs(r39.w) < 9.99999975e-05);
              r39.w = r40.w ? abs(r39.w) : r39.w;
              r40.w = (int)r18.w + 1;
              r72.xyz = min(float3(2000,2000,2000), r26.xyz);
              r72.xyz = f32tof16(r72.xyz);
              r72.x = mad((int)r72.y, 0x00010000, (int)r72.x);
              r41.z = (int)r18.w * asint(cb0[7].x);
              r30.x = min(2000, r30.x);
              r30.x = f32tof16(r30.x);
              r72.y = mad((int)r30.x, 0x00010000, (int)r72.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xy, r41.z, r72.xyxx 
u1.Store2(r41.z, r72.xy);
              r32.xyz = r32.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r32.xyz = (uint3)r32.xyz;
              r30.x = mad((int)r32.y, 256, (int)r32.x);
              r30.x = mad((int)r32.z, 0x00010000, (int)r30.x);
              r30.yz = r30.yz * float2(127.5,127.5) + float2(127.5,127.5);
              r30.yz = (uint2)r30.yz;
              r30.x = mad((int)r30.y, 0x01000000, (int)r30.x);
              r32.xyz = mad((int3)r18.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r32.x, r30.x 
u1.Store(r32.x, r30.x);
              r33.xyz = r33.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r33.xyz = (uint3)r33.xyz;
              r30.x = mad((int)r33.y, 256, (int)r33.x);
              r30.x = mad((int)r33.z, 0x00010000, (int)r30.x);
              r30.x = mad((int)r30.z, 0x01000000, (int)r30.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r32.y, r30.x 
u1.Store(r32.y, r30.x);
              r30.xy = min(float2(2000,2000), r31.xy);
              r30.xy = f32tof16(r30.xy);
              r30.x = mad((int)r30.y, 0x00010000, (int)r30.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r32.z, r30.x 
u1.Store(r32.z, r30.x);
              if (r13.y != 0) {
                r30.x = mad((int)r18.w, asint(cb0[7].x), (int)r13.y);
                bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r28.w = (((uint)r31.z << 8) & bitmask.w) | ((uint)r28.w & ~bitmask.w);
                r28.w = mad((int)r31.w, 0x00010000, (int)r28.w);
                r28.w = mad((int)r29.w, 0x01000000, (int)r28.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.x, r28.w 
u1.Store(r30.x, r28.w);
              }
              r30.xy = mad((int2)r18.ww, asint(cb0[7].xx), asint(cb0[6].wz));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r30.x, r29.x 
u1.Store(r30.x, r29.x);
              r31.xyzw = min(float4(2000,2000,2000,2000), r35.xyzw);
              r31.xyzw = f32tof16(r31.xyzw);
              r31.xy = mad((int2)r31.yw, int2(0x10000,0x10000), (int2)r31.xz);
              bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r28.w = (((uint)r37.y << 8) & bitmask.w) | ((uint)r36.y & ~bitmask.w);
              r28.w = mad((int)r37.z, 0x00010000, (int)r28.w);
              bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r31.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r36.y & ~bitmask.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xyz, r30.y, r31.xyzx 
u1.Store3(r30.y, r31.xyz);
              r30.xy = (uint2)r19.xy >> int2(1,1);
              r30.xy = (uint2)r30.xy << int2(2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r30.x, u3.xxxx 
r28.w = u3.Load(r30.x);
              r31.xy = (int2)r19.xy & int2(1,1);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r18.w << 16) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r18.w << 0) & bitmask.w) | ((uint)r28.w & ~bitmask.w);
              r32.xy = (int2)-r31.xy + int2(1,1);
              r28.w = (int)r31.w * (int)r32.x;
              r28.w = mad((int)r31.z, (int)r31.x, (int)r28.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r30.x, r28.w 
u3.Store(r30.x, r28.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r30.y, u5.xxxx 
r28.w = u5.Load(r30.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r18.w << 16) & bitmask.x) | ((uint)r28.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.z = (((uint)r18.w << 0) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
              r28.w = (int)r32.y * (int)r30.z;
              r28.w = mad((int)r30.x, (int)r31.y, (int)r28.w);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r30.y, r28.w 
u5.Store(r30.y, r28.w);
              r31.xyzw = (int4)r19.xyxy + int4(1,1,2,2);
              r30.xy = (uint2)r20.xy >> int2(1,1);
              r30.xy = (uint2)r30.xy << int2(2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r30.x, u6.xxxx 
r28.w = u6.Load(r30.x);
              r32.xy = (int2)r20.xy & int2(1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r33.x = (((uint)r18.w << 16) & bitmask.x) | ((uint)r28.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r33.y = (((uint)r18.w << 0) & bitmask.y) | ((uint)r28.w & ~bitmask.y);
              r37.yz = (int2)-r32.xy + int2(1,1);
              r28.w = (int)r33.y * (int)r37.y;
              r28.w = mad((int)r33.x, (int)r32.x, (int)r28.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r30.x, r28.w 
u6.Store(r30.x, r28.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r30.y, u7.xxxx 
r28.w = u7.Load(r30.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r18.w << 16) & bitmask.x) | ((uint)r28.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.z = (((uint)r18.w << 0) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
              r28.w = (int)r37.z * (int)r30.z;
              r28.w = mad((int)r30.x, (int)r32.y, (int)r28.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r30.y, r28.w 
u7.Store(r30.y, r28.w);
              r72.xyzw = (int4)r20.xyxy + int4(1,1,2,2);
              r28.w = (int)r40.w + 1;
              r30.xyz = min(float3(2000,2000,2000), r51.xzw);
              r30.xyz = f32tof16(r30.xyz);
              r30.x = mad((int)r30.y, 0x00010000, (int)r30.x);
              r29.w = (int)r40.w * asint(cb0[7].x);
              r32.x = min(2000, r57.x);
              r32.x = f32tof16(r32.x);
              r30.y = mad((int)r32.x, 0x00010000, (int)r30.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xy, r29.w, r30.xyxx 
u1.Store2(r29.w, r30.xy);
              r32.xyz = r55.xzw * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r32.xyz = (uint3)r32.xyz;
              r32.yz = (uint2)r32.yz << int2(8,16);
              r29.w = (int)r32.y | (int)r32.x;
              r29.w = (int)r32.z | (int)r29.w;
              r32.xy = r57.yz * float2(127.5,127.5) + float2(127.5,127.5);
              r32.xy = (uint2)r32.xy;
              r32.xy = (uint2)r32.xy << int2(24,24);
              r29.w = (int)r29.w | (int)r32.x;
              r33.xyz = mad((int3)r40.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r33.x, r29.w 
u1.Store(r33.x, r29.w);
              r51.xzw = r56.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r51.xzw = (uint3)r51.xzw;
              r32.xz = (uint2)r51.zw << int2(8,16);
              r30.z = (int)r32.x | (int)r51.x;
              r30.z = (int)r32.z | (int)r30.z;
              r30.z = (int)r32.y | (int)r30.z;
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r33.y, r30.z 
u1.Store(r33.y, r30.z);
              r32.xy = min(float2(2000,2000), r58.xy);
              r32.xy = f32tof16(r32.xy);
              r32.x = mad((int)r32.y, 0x00010000, (int)r32.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r33.z, r32.x 
u1.Store(r33.z, r32.x);
              if (r13.y != 0) {
                r32.y = mad((int)r40.w, asint(cb0[7].x), (int)r13.y);
                r55.xyzw = float4(255,255,255,255) * r59.xyzw;
                r55.xyzw = (uint4)r55.xyzw;
                r33.xyz = (uint3)r55.yzw << int3(8,16,24);
                r32.z = (int)r33.x | (int)r55.x;
                r32.z = (int)r33.y | (int)r32.z;
                r32.z = (int)r33.z | (int)r32.z;
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r32.y, r32.z 
u1.Store(r32.y, r32.z);
              }
              r32.yz = mad((int2)r40.ww, asint(cb0[7].xx), asint(cb0[6].wz));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r32.y, r37.x 
u1.Store(r32.y, r37.x);
              r55.xyzw = min(float4(2000,2000,2000,2000), r60.xyzw);
              r55.xyzw = f32tof16(r55.xyzw);
              r33.xy = mad((int2)r55.yw, int2(0x10000,0x10000), (int2)r55.xz);
              r32.y = mad((int)r61.y, 256, (int)r61.x);
              r32.y = mad((int)r61.z, 0x00010000, (int)r32.y);
              r33.z = mad((int)r61.w, 0x01000000, (int)r32.y);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xyz, r32.z, r33.xyzx 
u1.Store3(r32.z, r33.xyz);
              r55.xyzw = (uint4)r31.xyzw >> int4(1,1,1,1);
              r55.xyzw = (uint4)r55.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r32.y, r55.x, u3.xxxx 
r32.y = u3.Load(r55.x);
              r31.xyzw = (int4)r31.xyzw & int4(1,1,1,1);
              bitmask.y = ((~(-1 << 16)) << 16) & 0xffffffff;  r32.y = (((uint)r40.w << 16) & bitmask.y) | ((uint)r32.y & ~bitmask.y);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r32.z = (((uint)r40.w << 0) & bitmask.z) | ((uint)r32.y & ~bitmask.z);
              r56.xyzw = (int4)-r31.xyzw + int4(1,1,1,1);
              r32.z = (int)r32.z * (int)r56.x;
              r31.x = mad((int)r32.y, (int)r31.x, (int)r32.z);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r55.x, r31.x 
u3.Store(r55.x, r31.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.x, r55.y, u5.xxxx 
r31.x = u5.Load(r55.y);
              bitmask.y = ((~(-1 << 16)) << 16) & 0xffffffff;  r32.y = (((uint)r40.w << 16) & bitmask.y) | ((uint)r31.x & ~bitmask.y);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r32.z = (((uint)r40.w << 0) & bitmask.z) | ((uint)r31.x & ~bitmask.z);
              r31.x = (int)r56.y * (int)r32.z;
              r31.x = mad((int)r32.y, (int)r31.y, (int)r31.x);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r55.y, r31.x 
u5.Store(r55.y, r31.x);
              r57.xyzw = (uint4)r72.xyzw >> int4(1,1,1,1);
              r57.xyzw = (uint4)r57.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.x, r57.x, u6.xxxx 
r31.x = u6.Load(r57.x);
              r58.xyzw = (int4)r72.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.x = (((uint)r40.w << 16) & bitmask.x) | ((uint)r31.x & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.y = (((uint)r40.w << 0) & bitmask.y) | ((uint)r31.x & ~bitmask.y);
              r60.xyzw = (int4)-r58.xyzw + int4(1,1,1,1);
              r31.y = (int)r31.y * (int)r60.x;
              r31.x = mad((int)r31.x, (int)r58.x, (int)r31.y);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r57.x, r31.x 
u6.Store(r57.x, r31.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.x, r57.y, u7.xxxx 
r31.x = u7.Load(r57.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.x = (((uint)r40.w << 16) & bitmask.x) | ((uint)r31.x & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.y = (((uint)r40.w << 0) & bitmask.y) | ((uint)r31.x & ~bitmask.y);
              r31.y = (int)r60.y * (int)r31.y;
              r31.x = mad((int)r31.x, (int)r58.y, (int)r31.y);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r57.y, r31.x 
u7.Store(r57.y, r31.x);
              r31.x = (int)r28.w + 1;
              r51.xzw = min(float3(2000,2000,2000), r54.xyz);
              r51.xzw = f32tof16(r51.xzw);
              r54.x = mad((int)r51.z, 0x00010000, (int)r51.x);
              r31.y = (int)r28.w * asint(cb0[7].x);
              r32.y = min(2000, r70.x);
              r32.y = f32tof16(r32.y);
              r54.y = mad((int)r32.y, 0x00010000, (int)r51.w);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xy, r31.y, r54.xyxx 
u1.Store2(r31.y, r54.xy);
              r51.xzw = r68.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r51.xzw = (uint3)r51.xzw;
              r32.yz = (uint2)r51.zw << int2(8,16);
              r31.y = (int)r32.y | (int)r51.x;
              r31.y = (int)r32.z | (int)r31.y;
              r32.yz = r70.yz * float2(127.5,127.5) + float2(127.5,127.5);
              r32.yz = (uint2)r32.yz;
              r32.yz = (uint2)r32.yz << int2(24,24);
              r31.y = (int)r31.y | (int)r32.y;
              r51.xzw = mad((int3)r28.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r51.x, r31.y 
u1.Store(r51.x, r31.y);
              r61.xyz = r69.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r61.xyz = (uint3)r61.xyz;
              r37.yz = (uint2)r61.yz << int2(8,16);
              r32.y = (int)r37.y | (int)r61.x;
              r32.y = (int)r37.z | (int)r32.y;
              r32.y = (int)r32.z | (int)r32.y;
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r51.z, r32.y 
u1.Store(r51.z, r32.y);
              r37.yz = min(float2(2000,2000), r65.zw);
              r37.yz = f32tof16(r37.yz);
              r32.z = mad((int)r37.z, 0x00010000, (int)r37.y);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r51.w, r32.z 
u1.Store(r51.w, r32.z);
              if (r13.y != 0) {
                r37.y = mad((int)r28.w, asint(cb0[7].x), (int)r13.y);
                r61.xyzw = float4(255,255,255,255) * r34.xyzw;
                r61.xyzw = (uint4)r61.xyzw;
                r51.xzw = (uint3)r61.yzw << int3(8,16,24);
                r37.z = (int)r51.x | (int)r61.x;
                r37.z = (int)r51.z | (int)r37.z;
                r37.z = (int)r51.w | (int)r37.z;
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r37.y, r37.z 
u1.Store(r37.y, r37.z);
              }
              r37.yz = mad((int2)r28.ww, asint(cb0[7].xx), asint(cb0[6].wz));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r37.y, r39.w 
u1.Store(r37.y, r39.w);
              r49.xyzw = min(float4(2000,2000,2000,2000), r49.xyzw);
              r49.xyzw = f32tof16(r49.xyzw);
              r49.xy = mad((int2)r49.yw, int2(0x10000,0x10000), (int2)r49.xz);
              r37.y = mad((int)r71.y, 256, (int)r71.x);
              r37.y = mad((int)r71.z, 0x00010000, (int)r37.y);
              r49.z = mad((int)r71.w, 0x01000000, (int)r37.y);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xyz, r37.z, r49.xyzx 
u1.Store3(r37.z, r49.xyz);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r37.y, r55.z, u3.xxxx 
r37.y = u3.Load(r55.z);
              bitmask.y = ((~(-1 << 16)) << 16) & 0xffffffff;  r37.y = (((uint)r28.w << 16) & bitmask.y) | ((uint)r37.y & ~bitmask.y);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r37.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r37.y & ~bitmask.z);
              r37.z = (int)r56.z * (int)r37.z;
              r31.z = mad((int)r37.y, (int)r31.z, (int)r37.z);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r55.z, r31.z 
u3.Store(r55.z, r31.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r55.w, u5.xxxx 
r31.z = u5.Load(r55.w);
              bitmask.y = ((~(-1 << 16)) << 16) & 0xffffffff;  r37.y = (((uint)r28.w << 16) & bitmask.y) | ((uint)r31.z & ~bitmask.y);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r37.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              r31.z = (int)r56.w * (int)r37.z;
              r31.z = mad((int)r37.y, (int)r31.w, (int)r31.z);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r55.w, r31.z 
u5.Store(r55.w, r31.z);
              r55.xyzw = (int4)r19.xyxy + int4(3,3,4,4);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r57.z, u6.xxxx 
r31.z = u6.Load(r57.z);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r28.w << 16) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r28.w << 0) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
              r31.w = (int)r60.z * (int)r31.w;
              r31.z = mad((int)r31.z, (int)r58.z, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r57.z, r31.z 
u6.Store(r57.z, r31.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r57.w, u7.xxxx 
r31.z = u7.Load(r57.w);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r28.w << 16) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r28.w << 0) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
              r31.w = (int)r60.w * (int)r31.w;
              r31.z = mad((int)r31.z, (int)r58.w, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r57.w, r31.z 
u7.Store(r57.w, r31.z);
              r56.xyzw = (int4)r20.xyxy + int4(3,3,4,4);
              r31.z = cmp((int)r40.w == 0x0000ffff);
              if (r31.z != 0) {
                r31.z = (int)r31.x + 1;
                r31.w = (int)r31.x * asint(cb0[7].x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xy, r31.w, r30.xyxx 
u1.Store2(r31.w, r30.xy);
                r51.xzw = mad((int3)r31.xxx, asint(cb0[7].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r51.x, r29.w 
u1.Store(r51.x, r29.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r51.z, r30.z 
u1.Store(r51.z, r30.z);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r51.w, r32.x 
u1.Store(r51.w, r32.x);
                if (r13.y != 0) {
                  r31.w = mad((int)r31.x, asint(cb0[7].x), (int)r13.y);
                  r57.xyzw = float4(255,255,255,255) * r59.xyzw;
                  r57.xyzw = (uint4)r57.xyzw;
                  r51.xzw = (uint3)r57.yzw << int3(8,16,24);
                  r37.y = (int)r51.x | (int)r57.x;
                  r37.y = (int)r51.z | (int)r37.y;
                  r37.y = (int)r51.w | (int)r37.y;
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r31.w, r37.y 
u1.Store(r31.w, r37.y);
                }
                r37.yz = mad((int2)r31.xx, asint(cb0[7].xx), asint(cb0[6].wz));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r37.y, r37.x 
u1.Store(r37.y, r37.x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xyz, r37.z, r33.xyzx 
u1.Store3(r37.z, r33.xyz);
                r40.w = r31.x;
                r31.x = r31.z;
              }
              r57.xyzw = (uint4)r55.xyzw >> int4(1,1,1,1);
              r57.xyzw = (uint4)r57.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r57.x, u3.xxxx 
r31.z = u3.Load(r57.x);
              r55.xyzw = (int4)r55.xyzw & int4(1,1,1,1);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r40.w << 16) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r40.w << 0) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
              r58.xyzw = (int4)-r55.xyzw + int4(1,1,1,1);
              r31.w = (int)r31.w * (int)r58.x;
              r31.z = mad((int)r31.z, (int)r55.x, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r57.x, r31.z 
u3.Store(r57.x, r31.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r57.y, u5.xxxx 
r31.z = u5.Load(r57.y);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r40.w << 16) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r40.w << 0) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
              r31.w = (int)r58.y * (int)r31.w;
              r31.z = mad((int)r31.z, (int)r55.y, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r57.y, r31.z 
u5.Store(r57.y, r31.z);
              r60.xyzw = (uint4)r56.xyzw >> int4(1,1,1,1);
              r60.xyzw = (uint4)r60.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r60.x, u6.xxxx 
r31.z = u6.Load(r60.x);
              r56.xyzw = (int4)r56.xyzw & int4(1,1,1,1);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r40.w << 16) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r40.w << 0) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
              r61.xyzw = (int4)-r56.xyzw + int4(1,1,1,1);
              r31.w = (int)r31.w * (int)r61.x;
              r31.z = mad((int)r31.z, (int)r56.x, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r60.x, r31.z 
u6.Store(r60.x, r31.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r60.y, u7.xxxx 
r31.z = u7.Load(r60.y);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.z = (((uint)r40.w << 16) & bitmask.z) | ((uint)r31.z & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r40.w << 0) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
              r31.w = (int)r61.y * (int)r31.w;
              r31.z = mad((int)r31.z, (int)r56.y, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r60.y, r31.z 
u7.Store(r60.y, r31.z);
              r31.z = (int)r31.x + 1;
              r51.xzw = min(float3(2000,2000,2000), r27.xyz);
              r51.xzw = f32tof16(r51.xzw);
              r55.x = mad((int)r51.z, 0x00010000, (int)r51.x);
              r31.w = (int)r31.x * asint(cb0[7].x);
              r37.y = min(2000, r38.x);
              r37.y = f32tof16(r37.y);
              r55.y = mad((int)r37.y, 0x00010000, (int)r51.w);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xy, r31.w, r55.xyxx 
u1.Store2(r31.w, r55.xy);
              r39.xyz = r39.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r39.xyz = (uint3)r39.xyz;
              r31.w = mad((int)r39.y, 256, (int)r39.x);
              r31.w = mad((int)r39.z, 0x00010000, (int)r31.w);
              r37.yz = r38.yz * float2(127.5,127.5) + float2(127.5,127.5);
              r37.yz = (uint2)r37.yz;
              r31.w = mad((int)r37.y, 0x01000000, (int)r31.w);
              r38.xyz = mad((int3)r31.xxx, asint(cb0[7].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r38.x, r31.w 
u1.Store(r38.x, r31.w);
              r39.xyz = r40.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r39.xyz = (uint3)r39.xyz;
              r31.w = mad((int)r39.y, 256, (int)r39.x);
              r31.w = mad((int)r39.z, 0x00010000, (int)r31.w);
              r31.w = mad((int)r37.z, 0x01000000, (int)r31.w);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r38.y, r31.w 
u1.Store(r38.y, r31.w);
              r37.yz = min(float2(2000,2000), r41.xy);
              r37.yz = f32tof16(r37.yz);
              r31.w = mad((int)r37.z, 0x00010000, (int)r37.y);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r38.z, r31.w 
u1.Store(r38.z, r31.w);
              if (r13.y != 0) {
                r31.w = mad((int)r31.x, asint(cb0[7].x), (int)r13.y);
                bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r30.w = (((uint)r36.x << 8) & bitmask.w) | ((uint)r30.w & ~bitmask.w);
                r30.w = mad((int)r36.z, 0x00010000, (int)r30.w);
                r30.w = mad((int)r32.w, 0x01000000, (int)r30.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r31.w, r30.w 
u1.Store(r31.w, r30.w);
              }
              r36.xz = mad((int2)r31.xx, asint(cb0[7].xx), asint(cb0[6].wz));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r36.x, r29.y 
u1.Store(r36.x, r29.y);
              r68.xyzw = min(float4(2000,2000,2000,2000), r43.xyzw);
              r68.xyzw = f32tof16(r68.xyzw);
              r38.xy = mad((int2)r68.yw, int2(0x10000,0x10000), (int2)r68.xz);
              bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r30.w = (((uint)r44.y << 8) & bitmask.w) | ((uint)r41.w & ~bitmask.w);
              r30.w = mad((int)r44.z, 0x00010000, (int)r30.w);
              bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r38.z = (((uint)r30.w << 0) & bitmask.z) | ((uint)r41.w & ~bitmask.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xyz, r36.z, r38.xyzx 
u1.Store3(r36.z, r38.xyz);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r57.z, u3.xxxx 
r30.w = u3.Load(r57.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.x << 16) & bitmask.x) | ((uint)r30.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.x << 0) & bitmask.z) | ((uint)r30.w & ~bitmask.z);
              r30.w = (int)r58.z * (int)r36.z;
              r30.w = mad((int)r36.x, (int)r55.z, (int)r30.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r57.z, r30.w 
u3.Store(r57.z, r30.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r57.w, u5.xxxx 
r30.w = u5.Load(r57.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.x << 16) & bitmask.x) | ((uint)r30.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.x << 0) & bitmask.z) | ((uint)r30.w & ~bitmask.z);
              r30.w = (int)r58.w * (int)r36.z;
              r30.w = mad((int)r36.x, (int)r55.w, (int)r30.w);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r57.w, r30.w 
u5.Store(r57.w, r30.w);
              r55.xyzw = (int4)r19.xyxy + int4(5,5,6,6);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r60.z, u6.xxxx 
r30.w = u6.Load(r60.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.x << 16) & bitmask.x) | ((uint)r30.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.x << 0) & bitmask.z) | ((uint)r30.w & ~bitmask.z);
              r30.w = (int)r61.z * (int)r36.z;
              r30.w = mad((int)r36.x, (int)r56.z, (int)r30.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r60.z, r30.w 
u6.Store(r60.z, r30.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.w, r60.w, u7.xxxx 
r30.w = u7.Load(r60.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r31.x = (((uint)r31.x << 16) & bitmask.x) | ((uint)r30.w & ~bitmask.x);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r31.w = (((uint)r31.x << 0) & bitmask.w) | ((uint)r30.w & ~bitmask.w);
              r30.w = (int)r61.w * (int)r31.w;
              r30.w = mad((int)r31.x, (int)r56.w, (int)r30.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r60.w, r30.w 
u7.Store(r60.w, r30.w);
              r56.xyzw = (int4)r20.xyxy + int4(5,5,6,6);
              r30.w = (int)r31.z + 1;
              r38.xyz = min(float3(2000,2000,2000), r53.xyz);
              r38.xyz = f32tof16(r38.xyz);
              r38.x = mad((int)r38.y, 0x00010000, (int)r38.x);
              r31.x = (int)r31.z * asint(cb0[7].x);
              r31.w = min(2000, r64.x);
              r31.w = f32tof16(r31.w);
              r38.y = mad((int)r31.w, 0x00010000, (int)r38.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xy, r31.x, r38.xyxx 
u1.Store2(r31.x, r38.xy);
              r39.xyz = r62.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r39.xyz = (uint3)r39.xyz;
              r31.xw = (uint2)r39.yz << int2(8,16);
              r31.x = (int)r31.x | (int)r39.x;
              r31.x = (int)r31.w | (int)r31.x;
              r36.xz = r64.yz * float2(127.5,127.5) + float2(127.5,127.5);
              r36.xz = (uint2)r36.xz;
              r36.xz = (uint2)r36.xz << int2(24,24);
              r31.x = (int)r31.x | (int)r36.x;
              r39.xyz = mad((int3)r31.zzz, asint(cb0[7].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r39.x, r31.x 
u1.Store(r39.x, r31.x);
              r40.xyz = r63.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r40.xyz = (uint3)r40.xyz;
              r37.yz = (uint2)r40.yz << int2(8,16);
              r31.w = (int)r37.y | (int)r40.x;
              r31.w = (int)r37.z | (int)r31.w;
              r31.w = (int)r36.z | (int)r31.w;
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r39.y, r31.w 
u1.Store(r39.y, r31.w);
              r36.xz = min(float2(2000,2000), r65.xy);
              r36.xz = f32tof16(r36.xz);
              r32.w = mad((int)r36.z, 0x00010000, (int)r36.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r39.z, r32.w 
u1.Store(r39.z, r32.w);
              if (r13.y != 0) {
                r36.x = mad((int)r31.z, asint(cb0[7].x), (int)r13.y);
                r53.xyzw = float4(255,255,255,255) * r42.xyzw;
                r53.xyzw = (uint4)r53.xyzw;
                r39.xyz = (uint3)r53.yzw << int3(8,16,24);
                r36.z = (int)r39.x | (int)r53.x;
                r36.z = (int)r39.y | (int)r36.z;
                r36.z = (int)r39.z | (int)r36.z;
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.x, r36.z 
u1.Store(r36.x, r36.z);
              }
              r36.xz = mad((int2)r31.zz, asint(cb0[7].xx), asint(cb0[6].wz));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r36.x, r38.w 
u1.Store(r36.x, r38.w);
              r53.xyzw = min(float4(2000,2000,2000,2000), r66.xyzw);
              r53.xyzw = f32tof16(r53.xyzw);
              r39.xy = mad((int2)r53.yw, int2(0x10000,0x10000), (int2)r53.xz);
              r36.x = mad((int)r67.y, 256, (int)r67.x);
              r36.x = mad((int)r67.z, 0x00010000, (int)r36.x);
              r39.z = mad((int)r67.w, 0x01000000, (int)r36.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xyz, r36.z, r39.xyzx 
u1.Store3(r36.z, r39.xyz);
              r53.xyzw = (uint4)r55.xyzw >> int4(1,1,1,1);
              r53.xyzw = (uint4)r53.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r53.x, u3.xxxx 
r36.x = u3.Load(r53.x);
              r55.xyzw = (int4)r55.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r57.xyzw = (int4)-r55.xyzw + int4(1,1,1,1);
              r36.z = (int)r36.z * (int)r57.x;
              r36.x = mad((int)r36.x, (int)r55.x, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r53.x, r36.x 
u3.Store(r53.x, r36.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r53.y, u5.xxxx 
r36.x = u5.Load(r53.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r57.y * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r55.y, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r53.y, r36.x 
u5.Store(r53.y, r36.x);
              r58.xyzw = (uint4)r56.xyzw >> int4(1,1,1,1);
              r58.xyzw = (uint4)r58.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r58.x, u6.xxxx 
r36.x = u6.Load(r58.x);
              r56.xyzw = (int4)r56.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r60.xyzw = (int4)-r56.xyzw + int4(1,1,1,1);
              r36.z = (int)r36.z * (int)r60.x;
              r36.x = mad((int)r36.x, (int)r56.x, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r58.x, r36.x 
u6.Store(r58.x, r36.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r58.y, u7.xxxx 
r36.x = u7.Load(r58.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r60.y * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r56.y, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r58.y, r36.x 
u7.Store(r58.y, r36.x);
              r36.x = cmp((int)r28.w == 0x0000ffff);
              if (r36.x != 0) {
                r36.x = (int)r30.w + 1;
                r36.z = (int)r30.w * asint(cb0[7].x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xy, r36.z, r54.xyxx 
u1.Store2(r36.z, r54.xy);
                r40.xyz = mad((int3)r30.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r40.x, r31.y 
u1.Store(r40.x, r31.y);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r40.y, r32.y 
u1.Store(r40.y, r32.y);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r40.z, r32.z 
u1.Store(r40.z, r32.z);
                if (r13.y != 0) {
                  r36.z = mad((int)r30.w, asint(cb0[7].x), (int)r13.y);
                  r61.xyzw = float4(255,255,255,255) * r34.xyzw;
                  r61.xyzw = (uint4)r61.xyzw;
                  r40.xyz = (uint3)r61.yzw << int3(8,16,24);
                  r37.y = (int)r40.x | (int)r61.x;
                  r37.y = (int)r40.y | (int)r37.y;
                  r37.y = (int)r40.z | (int)r37.y;
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r36.z, r37.y 
u1.Store(r36.z, r37.y);
                }
                r37.yz = mad((int2)r30.ww, asint(cb0[7].xx), asint(cb0[6].wz));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r37.y, r39.w 
u1.Store(r37.y, r39.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xyz, r37.z, r49.xyzx 
u1.Store3(r37.z, r49.xyz);
                r28.w = r30.w;
                r30.w = r36.x;
              }
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r53.z, u3.xxxx 
r36.x = u3.Load(r53.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r28.w << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r57.z * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r55.z, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r53.z, r36.x 
u3.Store(r53.z, r36.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r53.w, u5.xxxx 
r36.x = u5.Load(r53.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r28.w << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r57.w * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r55.w, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r53.w, r36.x 
u5.Store(r53.w, r36.x);
              r53.xyzw = (int4)r19.xyxy + int4(7,7,8,8);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r58.z, u6.xxxx 
r36.x = u6.Load(r58.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r28.w << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r60.z * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r56.z, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r58.z, r36.x 
u6.Store(r58.z, r36.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r58.w, u7.xxxx 
r36.x = u7.Load(r58.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r28.w << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r60.w * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r56.w, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r58.w, r36.x 
u7.Store(r58.w, r36.x);
              r55.xyzw = (int4)r20.xyxy + int4(7,7,8,8);
              r36.x = cmp((int)r31.z == 0x0000ffff);
              if (r36.x != 0) {
                r36.x = (int)r30.w + 1;
                r36.z = (int)r30.w * asint(cb0[7].x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xy, r36.z, r38.xyxx 
u1.Store2(r36.z, r38.xy);
                r40.xyz = mad((int3)r30.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r40.x, r31.x 
u1.Store(r40.x, r31.x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r40.y, r31.w 
u1.Store(r40.y, r31.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r40.z, r32.w 
u1.Store(r40.z, r32.w);
                if (r13.y != 0) {
                  r36.z = mad((int)r30.w, asint(cb0[7].x), (int)r13.y);
                  r56.xyzw = float4(255,255,255,255) * r42.xyzw;
                  r56.xyzw = (uint4)r56.xyzw;
                  r40.xyz = (uint3)r56.yzw << int3(8,16,24);
                  r37.y = (int)r40.x | (int)r56.x;
                  r37.y = (int)r40.y | (int)r37.y;
                  r37.y = (int)r40.z | (int)r37.y;
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r36.z, r37.y 
u1.Store(r36.z, r37.y);
                }
                r37.yz = mad((int2)r30.ww, asint(cb0[7].xx), asint(cb0[6].wz));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r37.y, r38.w 
u1.Store(r37.y, r38.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xyz, r37.z, r39.xyzx 
u1.Store3(r37.z, r39.xyz);
                r31.z = r30.w;
                r30.w = r36.x;
              }
              r56.xyzw = (uint4)r53.xyzw >> int4(1,1,1,1);
              r56.xyzw = (uint4)r56.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r56.x, u3.xxxx 
r36.x = u3.Load(r56.x);
              r53.xyzw = (int4)r53.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r57.xyzw = (int4)-r53.xyzw + int4(1,1,1,1);
              r36.z = (int)r36.z * (int)r57.x;
              r36.x = mad((int)r36.x, (int)r53.x, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r56.x, r36.x 
u3.Store(r56.x, r36.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r56.y, u5.xxxx 
r36.x = u5.Load(r56.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r57.y * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r53.y, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r56.y, r36.x 
u5.Store(r56.y, r36.x);
              r58.xyzw = (uint4)r55.xyzw >> int4(1,1,1,1);
              r58.xyzw = (uint4)r58.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r58.x, u6.xxxx 
r36.x = u6.Load(r58.x);
              r55.xyzw = (int4)r55.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r60.xyzw = (int4)-r55.xyzw + int4(1,1,1,1);
              r36.z = (int)r36.z * (int)r60.x;
              r36.x = mad((int)r36.x, (int)r55.x, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r58.x, r36.x 
u6.Store(r58.x, r36.x);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.x, r58.y, u7.xxxx 
r36.x = u7.Load(r58.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r36.x & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r31.z << 0) & bitmask.z) | ((uint)r36.x & ~bitmask.z);
              r36.z = (int)r60.y * (int)r36.z;
              r36.x = mad((int)r36.x, (int)r55.y, (int)r36.z);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r58.y, r36.x 
u7.Store(r58.y, r36.x);
              r18.w = (int)r30.w + 1;
              r40.xyz = min(float3(2000,2000,2000), r28.xyz);
              r40.xyz = f32tof16(r40.xyz);
              r40.x = mad((int)r40.y, 0x00010000, (int)r40.x);
              r36.x = (int)r30.w * asint(cb0[7].x);
              r36.z = min(2000, r45.x);
              r36.z = f32tof16(r36.z);
              r40.y = mad((int)r36.z, 0x00010000, (int)r40.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xy, r36.x, r40.xyxx 
u1.Store2(r36.x, r40.xy);
              r40.xyz = r47.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r40.xyz = (uint3)r40.xyz;
              r36.x = mad((int)r40.y, 256, (int)r40.x);
              r36.x = mad((int)r40.z, 0x00010000, (int)r36.x);
              r37.yz = r45.yz * float2(127.5,127.5) + float2(127.5,127.5);
              r37.yz = (uint2)r37.yz;
              r36.x = mad((int)r37.y, 0x01000000, (int)r36.x);
              r40.xyz = mad((int3)r30.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r40.x, r36.x 
u1.Store(r40.x, r36.x);
              r41.xyz = r48.xyz * float3(127.5,127.5,127.5) + float3(127.5,127.5,127.5);
              r41.xyz = (uint3)r41.xyz;
              r36.x = mad((int)r41.y, 256, (int)r41.x);
              r36.x = mad((int)r41.z, 0x00010000, (int)r36.x);
              r36.x = mad((int)r37.z, 0x01000000, (int)r36.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r40.y, r36.x 
u1.Store(r40.y, r36.x);
              r36.xz = min(float2(2000,2000), r46.xy);
              r36.xz = f32tof16(r36.xz);
              r36.x = mad((int)r36.z, 0x00010000, (int)r36.x);
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r40.z, r36.x 
u1.Store(r40.z, r36.x);
              if (r13.y != 0) {
                r36.x = mad((int)r30.w, asint(cb0[7].x), (int)r13.y);
                bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r33.w = (((uint)r46.z << 8) & bitmask.w) | ((uint)r33.w & ~bitmask.w);
                r33.w = mad((int)r46.w, 0x00010000, (int)r33.w);
                r33.w = mad((int)r36.w, 0x01000000, (int)r33.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.x, r33.w 
u1.Store(r36.x, r33.w);
              }
              r36.xz = mad((int2)r30.ww, asint(cb0[7].xx), asint(cb0[6].wz));
            // No code for instruction (needs manual fix):
                      // store_raw u1.x, r36.x, r29.z 
u1.Store(r36.x, r29.z);
              r45.xyzw = min(float4(2000,2000,2000,2000), r50.xyzw);
              r45.xyzw = f32tof16(r45.xyzw);
              r40.xy = mad((int2)r45.yw, int2(0x10000,0x10000), (int2)r45.xz);
              bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r33.w = (((uint)r52.y << 8) & bitmask.w) | ((uint)r51.y & ~bitmask.w);
              r33.w = mad((int)r52.z, 0x00010000, (int)r33.w);
              bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r40.z = (((uint)r33.w << 0) & bitmask.z) | ((uint)r51.y & ~bitmask.z);
            // No code for instruction (needs manual fix):
                      // store_raw u1.xyz, r36.z, r40.xyzx 
u1.Store3(r36.z, r40.xyz);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r56.z, u3.xxxx 
r33.w = u3.Load(r56.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r30.w << 16) & bitmask.x) | ((uint)r33.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r30.w << 0) & bitmask.z) | ((uint)r33.w & ~bitmask.z);
              r33.w = (int)r57.z * (int)r36.z;
              r33.w = mad((int)r36.x, (int)r53.z, (int)r33.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r56.z, r33.w 
u3.Store(r56.z, r33.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r56.w, u5.xxxx 
r33.w = u5.Load(r56.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r30.w << 16) & bitmask.x) | ((uint)r33.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r30.w << 0) & bitmask.z) | ((uint)r33.w & ~bitmask.z);
              r33.w = (int)r57.w * (int)r36.z;
              r33.w = mad((int)r36.x, (int)r53.w, (int)r33.w);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r56.w, r33.w 
u5.Store(r56.w, r33.w);
              r45.xyzw = (int4)r19.xyxy + int4(9,9,10,10);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r58.z, u6.xxxx 
r33.w = u6.Load(r58.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r30.w << 16) & bitmask.x) | ((uint)r33.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r30.w << 0) & bitmask.z) | ((uint)r33.w & ~bitmask.z);
              r33.w = (int)r60.z * (int)r36.z;
              r33.w = mad((int)r36.x, (int)r55.z, (int)r33.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r58.z, r33.w 
u6.Store(r58.z, r33.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r58.w, u7.xxxx 
r33.w = u7.Load(r58.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r30.w << 16) & bitmask.x) | ((uint)r33.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r30.w << 0) & bitmask.z) | ((uint)r33.w & ~bitmask.z);
              r30.w = (int)r60.w * (int)r36.z;
              r30.w = mad((int)r36.x, (int)r55.w, (int)r30.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r58.w, r30.w 
u7.Store(r58.w, r30.w);
              r46.xyzw = (int4)r20.xyxy + int4(9,9,10,10);
              r30.w = cmp((int)r40.w == 0x0000ffff);
              if (r30.w != 0) {
                r30.w = (int)r18.w + 1;
                r33.w = (int)r18.w * asint(cb0[7].x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xy, r33.w, r30.xyxx 
u1.Store2(r33.w, r30.xy);
                r36.xzw = mad((int3)r18.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.x, r29.w 
u1.Store(r36.x, r29.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.z, r30.z 
u1.Store(r36.z, r30.z);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.w, r32.x 
u1.Store(r36.w, r32.x);
                if (r13.y != 0) {
                  r29.w = mad((int)r18.w, asint(cb0[7].x), (int)r13.y);
                  r47.xyzw = float4(255,255,255,255) * r59.xyzw;
                  r47.xyzw = (uint4)r47.xyzw;
                  r30.xyz = (uint3)r47.yzw << int3(8,16,24);
                  r30.x = (int)r30.x | (int)r47.x;
                  r30.x = (int)r30.y | (int)r30.x;
                  r30.x = (int)r30.z | (int)r30.x;
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r29.w, r30.x 
u1.Store(r29.w, r30.x);
                }
                r30.xy = mad((int2)r18.ww, asint(cb0[7].xx), asint(cb0[6].wz));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.x, r37.x 
u1.Store(r30.x, r37.x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xyz, r30.y, r33.xyzx 
u1.Store3(r30.y, r33.xyz);
                r40.w = r18.w;
                r18.w = r30.w;
              }
              r30.xyzw = (uint4)r45.xyzw >> int4(1,1,1,1);
              r30.xyzw = (uint4)r30.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r30.x, u3.xxxx 
r29.w = u3.Load(r30.x);
              r33.xyzw = (int4)r45.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r40.w << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r40.w << 0) & bitmask.z) | ((uint)r29.w & ~bitmask.z);
              r45.xyzw = (int4)-r33.xyzw + int4(1,1,1,1);
              r29.w = (int)r36.z * (int)r45.x;
              r29.w = mad((int)r36.x, (int)r33.x, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r30.x, r29.w 
u3.Store(r30.x, r29.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r30.y, u5.xxxx 
r29.w = u5.Load(r30.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r36.x = (((uint)r40.w << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r36.z = (((uint)r40.w << 0) & bitmask.z) | ((uint)r29.w & ~bitmask.z);
              r29.w = (int)r45.y * (int)r36.z;
              r29.w = mad((int)r36.x, (int)r33.y, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r30.y, r29.w 
u5.Store(r30.y, r29.w);
              r47.xyzw = (uint4)r46.xyzw >> int4(1,1,1,1);
              r47.xyzw = (uint4)r47.xyzw << int4(2,2,2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r47.x, u6.xxxx 
r29.w = u6.Load(r47.x);
              r46.xyzw = (int4)r46.xyzw & int4(1,1,1,1);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r40.w << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.y = (((uint)r40.w << 0) & bitmask.y) | ((uint)r29.w & ~bitmask.y);
              r48.xyzw = (int4)-r46.xyzw + int4(1,1,1,1);
              r29.w = (int)r30.y * (int)r48.x;
              r29.w = mad((int)r30.x, (int)r46.x, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r47.x, r29.w 
u6.Store(r47.x, r29.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r47.y, u7.xxxx 
r29.w = u7.Load(r47.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r40.w << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.y = (((uint)r40.w << 0) & bitmask.y) | ((uint)r29.w & ~bitmask.y);
              r29.w = (int)r48.y * (int)r30.y;
              r29.w = mad((int)r30.x, (int)r46.y, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r47.y, r29.w 
u7.Store(r47.y, r29.w);
              r29.w = cmp((int)r31.z == 0x0000ffff);
              if (r29.w != 0) {
                r29.w = (int)r18.w + 1;
                r30.x = (int)r18.w * asint(cb0[7].x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xy, r30.x, r38.xyxx 
u1.Store2(r30.x, r38.xy);
                r36.xzw = mad((int3)r18.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.x, r31.x 
u1.Store(r36.x, r31.x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.z, r31.w 
u1.Store(r36.z, r31.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r36.w, r32.w 
u1.Store(r36.w, r32.w);
                if (r13.y != 0) {
                  r30.x = mad((int)r18.w, asint(cb0[7].x), (int)r13.y);
                  r40.xyzw = float4(255,255,255,255) * r42.xyzw;
                  r40.xyzw = (uint4)r40.xyzw;
                  r36.xzw = (uint3)r40.yzw << int3(8,16,24);
                  r30.y = (int)r36.x | (int)r40.x;
                  r30.y = (int)r36.z | (int)r30.y;
                  r30.y = (int)r36.w | (int)r30.y;
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r30.x, r30.y 
u1.Store(r30.x, r30.y);
                }
                r30.xy = mad((int2)r18.ww, asint(cb0[7].xx), asint(cb0[6].wz));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.x, r38.w 
u1.Store(r30.x, r38.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xyz, r30.y, r39.xyzx 
u1.Store3(r30.y, r39.xyz);
                r31.z = r18.w;
                r18.w = r29.w;
              }
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r30.z, u3.xxxx 
r29.w = u3.Load(r30.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.y = (((uint)r31.z << 0) & bitmask.y) | ((uint)r29.w & ~bitmask.y);
              r29.w = (int)r45.z * (int)r30.y;
              r29.w = mad((int)r30.x, (int)r33.z, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r30.z, r29.w 
u3.Store(r30.z, r29.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r30.w, u5.xxxx 
r29.w = u5.Load(r30.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.y = (((uint)r31.z << 0) & bitmask.y) | ((uint)r29.w & ~bitmask.y);
              r29.w = (int)r45.w * (int)r30.y;
              r29.w = mad((int)r30.x, (int)r33.w, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r30.w, r29.w 
u5.Store(r30.w, r29.w);
              r19.xyzw = (int4)r19.xyxy + int4(12,12,11,11);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r47.z, u6.xxxx 
r29.w = u6.Load(r47.z);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.y = (((uint)r31.z << 0) & bitmask.y) | ((uint)r29.w & ~bitmask.y);
              r29.w = (int)r48.z * (int)r30.y;
              r29.w = mad((int)r30.x, (int)r46.z, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r47.z, r29.w 
u6.Store(r47.z, r29.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r47.w, u7.xxxx 
r29.w = u7.Load(r47.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r31.z << 16) & bitmask.x) | ((uint)r29.w & ~bitmask.x);
              bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.y = (((uint)r31.z << 0) & bitmask.y) | ((uint)r29.w & ~bitmask.y);
              r29.w = (int)r48.w * (int)r30.y;
              r29.w = mad((int)r30.x, (int)r46.w, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r47.w, r29.w 
u7.Store(r47.w, r29.w);
              r20.xyzw = (int4)r20.xyxy + int4(12,12,11,11);
              r29.w = cmp((int)r28.w == 0x0000ffff);
              if (r29.w != 0) {
                r29.w = (int)r18.w + 1;
                r30.x = (int)r18.w * asint(cb0[7].x);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xy, r30.x, r54.xyxx 
u1.Store2(r30.x, r54.xy);
                r30.xyz = mad((int3)r18.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.x, r31.y 
u1.Store(r30.x, r31.y);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.y, r32.y 
u1.Store(r30.y, r32.y);
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.z, r32.z 
u1.Store(r30.z, r32.z);
                if (r13.y != 0) {
                  r30.x = mad((int)r18.w, asint(cb0[7].x), (int)r13.y);
                  r31.xyzw = float4(255,255,255,255) * r34.xyzw;
                  r31.xyzw = (uint4)r31.xyzw;
                  r30.yzw = (uint3)r31.yzw << int3(8,16,24);
                  r30.y = (int)r30.y | (int)r31.x;
                  r30.y = (int)r30.z | (int)r30.y;
                  r30.y = (int)r30.w | (int)r30.y;
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r30.x, r30.y 
u1.Store(r30.x, r30.y);
                }
                r30.xy = mad((int2)r18.ww, asint(cb0[7].xx), asint(cb0[6].wz));
              // No code for instruction (needs manual fix):
                          // store_raw u1.x, r30.x, r39.w 
u1.Store(r30.x, r39.w);
              // No code for instruction (needs manual fix):
                          // store_raw u1.xyz, r30.y, r49.xyzx 
u1.Store3(r30.y, r49.xyz);
                r28.w = r18.w;
                r18.w = r29.w;
              }
              r30.xy = (uint2)r19.zw >> int2(1,1);
              r30.xy = (uint2)r30.xy << int2(2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r30.x, u3.xxxx 
r29.w = u3.Load(r30.x);
              r19.zw = (int2)r19.zw & int2(1,1);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.z = (((uint)r28.w << 16) & bitmask.z) | ((uint)r29.w & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.w = (((uint)r28.w << 0) & bitmask.w) | ((uint)r29.w & ~bitmask.w);
              r31.xy = (int2)-r19.zw + int2(1,1);
              r29.w = (int)r30.w * (int)r31.x;
              r19.z = mad((int)r30.z, (int)r19.z, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u3.x, r30.x, r19.z 
u3.Store(r30.x, r19.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r30.y, u5.xxxx 
r19.z = u5.Load(r30.y);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r28.w << 16) & bitmask.x) | ((uint)r19.z & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r19.z & ~bitmask.z);
              r19.z = (int)r31.y * (int)r30.z;
              r19.z = mad((int)r30.x, (int)r19.w, (int)r19.z);
            // No code for instruction (needs manual fix):
                      // store_raw u5.x, r30.y, r19.z 
u5.Store(r30.y, r19.z);
              r19.zw = (uint2)r20.zw >> int2(1,1);
              r19.zw = (uint2)r19.zw << int2(2,2);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r29.w, r19.z, u6.xxxx 
r29.w = u6.Load(r19.z);
              r30.xy = (int2)r20.zw & int2(1,1);
              bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.z = (((uint)r28.w << 16) & bitmask.z) | ((uint)r29.w & ~bitmask.z);
              bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.w = (((uint)r28.w << 0) & bitmask.w) | ((uint)r29.w & ~bitmask.w);
              r31.xy = (int2)-r30.xy + int2(1,1);
              r29.w = (int)r30.w * (int)r31.x;
              r29.w = mad((int)r30.z, (int)r30.x, (int)r29.w);
            // No code for instruction (needs manual fix):
                      // store_raw u6.x, r19.z, r29.w 
u6.Store(r19.z, r29.w);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r19.w, u7.xxxx 
r19.z = u7.Load(r19.w);
              bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r30.x = (((uint)r28.w << 16) & bitmask.x) | ((uint)r19.z & ~bitmask.x);
              bitmask.z = ((~(-1 << 16)) << 0) & 0xffffffff;  r30.z = (((uint)r28.w << 0) & bitmask.z) | ((uint)r19.z & ~bitmask.z);
              r19.z = (int)r31.y * (int)r30.z;
              r19.z = mad((int)r30.x, (int)r30.y, (int)r19.z);
            // No code for instruction (needs manual fix):
                      // store_raw u7.x, r19.w, r19.z 
u7.Store(r19.w, r19.z);
              r30.xyzw = cmp(float4(0,0,0,0) < r35.xyzw);
              if (r30.x != 0) {
                if (3 == 0) r19.z = 0; else if (3+5 < 32) {                 r19.z = (uint)r36.y << (32-(3 + 5)); r19.z = (uint)r19.z >> (32-3);                } else r19.z = (uint)r36.y >> 5;
                r31.xyzw = cmp((int4)r19.zzzz == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.zzzz == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r19.w = (int)r31.x | (int)r31.y;
                r19.w = (int)r19.w | (int)r31.z;
                r19.w = (int)r19.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r19.w = (int)r19.w | (int)r31.x;
                r19.w = (int)r19.w | (int)r31.y;
                r19.w = (int)r19.w | (int)r31.z;
                r19.w = (int)r19.w | (int)r31.w;
                bitmask.w = ((~(-1 << 1)) << (uint)r36.y) & 0xffffffff;
                r19.w = ((uint)(1u << (uint)r36.y) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                r19.z = 1 << (int)r19.z;
                r31.xyzw = (int4)r19.zzzz & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.wwww * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.zzzz & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.wwww * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.y != 0) {
                r19.z = (uint)r36.y >> 8;
                if (3 == 0) r19.w = 0; else if (3+13 < 32) {                 r19.w = (uint)r36.y << (32-(3 + 13)); r19.w = (uint)r19.w >> (32-3);                } else r19.w = (uint)r36.y >> 13;
                r31.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r28.w = (int)r31.x | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r28.w = (int)r28.w | (int)r31.x;
                r28.w = (int)r28.w | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
                r19.w = 1 << (int)r19.w;
                r31.xyzw = (int4)r19.wwww & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.wwww & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.z != 0) {
                r19.z = (uint)r36.y >> 16;
                if (3 == 0) r19.w = 0; else if (3+21 < 32) {                 r19.w = (uint)r36.y << (32-(3 + 21)); r19.w = (uint)r19.w >> (32-3);                } else r19.w = (uint)r36.y >> 21;
                r31.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r28.w = (int)r31.x | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r28.w = (int)r28.w | (int)r31.x;
                r28.w = (int)r28.w | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
                r19.w = 1 << (int)r19.w;
                r31.xyzw = (int4)r19.wwww & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.wwww & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.w != 0) {
                r19.z = (uint)r37.w >> 5;
                r30.xyzw = cmp((int4)r19.zzzz == int4(0,1,2,3));
                r31.xyzw = cmp((int4)r19.zzzz == int4(4,5,6,7));
                r30.xyzw = r30.xyzw ? r15.xyzw : 0;
                r19.w = (int)r30.x | (int)r30.y;
                r19.w = (int)r19.w | (int)r30.z;
                r19.w = (int)r19.w | (int)r30.w;
                r30.xyzw = r31.xyzw ? r16.xyzw : 0;
                r19.w = (int)r19.w | (int)r30.x;
                r19.w = (int)r19.w | (int)r30.y;
                r19.w = (int)r19.w | (int)r30.z;
                r19.w = (int)r19.w | (int)r30.w;
                bitmask.w = ((~(-1 << 1)) << (uint)r37.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r37.w) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                r19.z = 1 << (int)r19.z;
                r30.xyzw = (int4)r19.zzzz & int4(1,2,4,8);
                r30.xyzw = r30.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r30.xyzw = (int4)r19.wwww * (int4)r30.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r30.xyzw;
                r30.xyzw = (int4)r19.zzzz & int4(16,32,64,128);
                r30.xyzw = r30.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r30.xyzw = (int4)r19.wwww * (int4)r30.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r30.xyzw;
              }
              r30.xyzw = cmp(float4(0,0,0,0) < r43.xyzw);
              if (r30.x != 0) {
                if (3 == 0) r19.z = 0; else if (3+5 < 32) {                 r19.z = (uint)r41.w << (32-(3 + 5)); r19.z = (uint)r19.z >> (32-3);                } else r19.z = (uint)r41.w >> 5;
                r31.xyzw = cmp((int4)r19.zzzz == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.zzzz == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r19.w = (int)r31.x | (int)r31.y;
                r19.w = (int)r19.w | (int)r31.z;
                r19.w = (int)r19.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r19.w = (int)r19.w | (int)r31.x;
                r19.w = (int)r19.w | (int)r31.y;
                r19.w = (int)r19.w | (int)r31.z;
                r19.w = (int)r19.w | (int)r31.w;
                bitmask.w = ((~(-1 << 1)) << (uint)r41.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r41.w) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                r19.z = 1 << (int)r19.z;
                r31.xyzw = (int4)r19.zzzz & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.wwww * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.zzzz & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.wwww * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.y != 0) {
                r19.z = (uint)r41.w >> 8;
                if (3 == 0) r19.w = 0; else if (3+13 < 32) {                 r19.w = (uint)r41.w << (32-(3 + 13)); r19.w = (uint)r19.w >> (32-3);                } else r19.w = (uint)r41.w >> 13;
                r31.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r28.w = (int)r31.x | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r28.w = (int)r28.w | (int)r31.x;
                r28.w = (int)r28.w | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
                r19.w = 1 << (int)r19.w;
                r31.xyzw = (int4)r19.wwww & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.wwww & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.z != 0) {
                r19.z = (uint)r41.w >> 16;
                if (3 == 0) r19.w = 0; else if (3+21 < 32) {                 r19.w = (uint)r41.w << (32-(3 + 21)); r19.w = (uint)r19.w >> (32-3);                } else r19.w = (uint)r41.w >> 21;
                r31.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r28.w = (int)r31.x | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r28.w = (int)r28.w | (int)r31.x;
                r28.w = (int)r28.w | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
                r19.w = 1 << (int)r19.w;
                r31.xyzw = (int4)r19.wwww & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.wwww & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.w != 0) {
                r19.z = (uint)r44.w >> 5;
                r30.xyzw = cmp((int4)r19.zzzz == int4(0,1,2,3));
                r31.xyzw = cmp((int4)r19.zzzz == int4(4,5,6,7));
                r30.xyzw = r30.xyzw ? r15.xyzw : 0;
                r19.w = (int)r30.x | (int)r30.y;
                r19.w = (int)r19.w | (int)r30.z;
                r19.w = (int)r19.w | (int)r30.w;
                r30.xyzw = r31.xyzw ? r16.xyzw : 0;
                r19.w = (int)r19.w | (int)r30.x;
                r19.w = (int)r19.w | (int)r30.y;
                r19.w = (int)r19.w | (int)r30.z;
                r19.w = (int)r19.w | (int)r30.w;
                bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                r19.z = 1 << (int)r19.z;
                r30.xyzw = (int4)r19.zzzz & int4(1,2,4,8);
                r30.xyzw = r30.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r30.xyzw = (int4)r19.wwww * (int4)r30.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r30.xyzw;
                r30.xyzw = (int4)r19.zzzz & int4(16,32,64,128);
                r30.xyzw = r30.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r30.xyzw = (int4)r19.wwww * (int4)r30.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r30.xyzw;
              }
              r30.xyzw = cmp(float4(0,0,0,0) < r50.xyzw);
              if (r30.x != 0) {
                if (3 == 0) r19.z = 0; else if (3+5 < 32) {                 r19.z = (uint)r51.y << (32-(3 + 5)); r19.z = (uint)r19.z >> (32-3);                } else r19.z = (uint)r51.y >> 5;
                r31.xyzw = cmp((int4)r19.zzzz == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.zzzz == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r19.w = (int)r31.x | (int)r31.y;
                r19.w = (int)r19.w | (int)r31.z;
                r19.w = (int)r19.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r19.w = (int)r19.w | (int)r31.x;
                r19.w = (int)r19.w | (int)r31.y;
                r19.w = (int)r19.w | (int)r31.z;
                r19.w = (int)r19.w | (int)r31.w;
                bitmask.w = ((~(-1 << 1)) << (uint)r51.y) & 0xffffffff;  r19.w = (((uint)1 << (uint)r51.y) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                r19.z = 1 << (int)r19.z;
                r31.xyzw = (int4)r19.zzzz & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.wwww * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.zzzz & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.wwww * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.y != 0) {
                r19.z = (uint)r51.y >> 8;
                if (3 == 0) r19.w = 0; else if (3+13 < 32) {                 r19.w = (uint)r51.y << (32-(3 + 13)); r19.w = (uint)r19.w >> (32-3);                } else r19.w = (uint)r51.y >> 13;
                r31.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r28.w = (int)r31.x | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r28.w = (int)r28.w | (int)r31.x;
                r28.w = (int)r28.w | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
                r19.w = 1 << (int)r19.w;
                r31.xyzw = (int4)r19.wwww & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.wwww & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.z != 0) {
                r19.z = (uint)r51.y >> 16;
                if (3 == 0) r19.w = 0; else if (3+21 < 32) {                 r19.w = (uint)r51.y << (32-(3 + 21)); r19.w = (uint)r19.w >> (32-3);                } else r19.w = (uint)r51.y >> 21;
                r31.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
                r32.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
                r31.xyzw = r31.xyzw ? r15.xyzw : 0;
                r28.w = (int)r31.x | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                r31.xyzw = r32.xyzw ? r16.xyzw : 0;
                r28.w = (int)r28.w | (int)r31.x;
                r28.w = (int)r28.w | (int)r31.y;
                r28.w = (int)r28.w | (int)r31.z;
                r28.w = (int)r28.w | (int)r31.w;
                bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r28.w & ~bitmask.z);
                r19.w = 1 << (int)r19.w;
                r31.xyzw = (int4)r19.wwww & int4(1,2,4,8);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r31.xyzw;
                r31.xyzw = (int4)r19.wwww & int4(16,32,64,128);
                r31.xyzw = r31.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r31.xyzw = (int4)r19.zzzz * (int4)r31.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r31.xyzw;
              }
              if (r30.w != 0) {
                r19.z = (uint)r52.w >> 5;
                r30.xyzw = cmp((int4)r19.zzzz == int4(0,1,2,3));
                r31.xyzw = cmp((int4)r19.zzzz == int4(4,5,6,7));
                r30.xyzw = r30.xyzw ? r15.xyzw : 0;
                r19.w = (int)r30.x | (int)r30.y;
                r19.w = (int)r19.w | (int)r30.z;
                r19.w = (int)r19.w | (int)r30.w;
                r30.xyzw = r31.xyzw ? r16.xyzw : 0;
                r19.w = (int)r19.w | (int)r30.x;
                r19.w = (int)r19.w | (int)r30.y;
                r19.w = (int)r19.w | (int)r30.z;
                r19.w = (int)r19.w | (int)r30.w;
                bitmask.w = ((~(-1 << 1)) << (uint)r52.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r52.w) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                r19.z = 1 << (int)r19.z;
                r30.xyzw = (int4)r19.zzzz & int4(1,2,4,8);
                r30.xyzw = r30.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r30.xyzw = (int4)r19.wwww * (int4)r30.xyzw;
                r15.xyzw = (int4)r15.xyzw | (int4)r30.xyzw;
                r30.xyzw = (int4)r19.zzzz & int4(16,32,64,128);
                r30.xyzw = r30.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                r30.xyzw = (int4)r19.wwww * (int4)r30.xyzw;
                r16.xyzw = (int4)r16.xyzw | (int4)r30.xyzw;
              }
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r23.x, u2.xxxx 
r19.z = u2.Load(r23.x);
              r19.zw = (int2)r19.zz & int2(0xffff,0xffff0000);
              r19.w = (int)r23.w * (int)r19.w;
              r19.z = mad((int)r19.z, (int)r22.w, (int)r19.w);
            // No code for instruction (needs manual fix):
                      // store_raw u2.x, r23.x, r19.z 
u2.Store(r23.x, r19.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r22.y, u2.xxxx 
r19.z = u2.Load(r22.y);
              r19.zw = (int2)r19.zz & int2(0xffff,0xffff0000);
              r19.w = (int)r25.x * (int)r19.w;
              r19.z = mad((int)r19.z, (int)r24.x, (int)r19.w);
            // No code for instruction (needs manual fix):
                      // store_raw u2.x, r22.y, r19.z 
u2.Store(r22.y, r19.z);
            // No code for instruction (needs manual fix):
                        // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r22.z, u2.xxxx 
r19.z = u2.Load(r22.z);
              r19.zw = (int2)r19.zz & int2(0xffff,0xffff0000);
              r19.w = (int)r25.y * (int)r19.w;
              r19.z = mad((int)r19.z, (int)r24.y, (int)r19.w);
            // No code for instruction (needs manual fix):
                      // store_raw u2.x, r22.z, r19.z 
u2.Store(r22.z, r19.z);
              r17.w = r12.w;
            } else {
              r30.xyz = cmp(r29.xyz < float3(5,5,5));
              r19.z = (int)r30.y | (int)r30.x;
              r19.z = (int)r30.z | (int)r19.z;
              r30.xyz = cmp(float3(-5,-5,-5) < r29.xyz);
              r19.w = (int)r30.y | (int)r30.x;
              r19.w = (int)r30.z | (int)r19.w;
              r19.z = (int)r19.z & (int)r26.w;
              r19.w = (int)r19.w & (int)r27.w;
              r19.z = (int)r19.w | (int)r19.z;
              if (r19.z != 0) {
                r19.z = (uint)r24.w >> 16;
                r19.z = f16tof32(r19.z);
                r30.xyz = mad((int3)r23.yyy, asint(cb0[5].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r30.x, t1.xxxx 
r19.w = t1.Load(r30.x);
                r24.w = (int)r19.w & 255;
                r24.w = (uint)r24.w;
                r24.w = r24.w * 0.00784313772 + -1;
                if (8 == 0) r30.x = 0; else if (8+8 < 32) {                 r30.x = (uint)r19.w << (32-(8 + 8)); r30.x = (uint)r30.x >> (32-8);                } else r30.x = (uint)r19.w >> 8;
                if (8 == 0) r30.w = 0; else if (8+16 < 32) {                 r30.w = (uint)r19.w << (32-(8 + 16)); r30.w = (uint)r30.w >> (32-8);                } else r30.w = (uint)r19.w >> 16;
                r30.xw = (uint2)r30.xw;
                r30.xw = r30.xw * float2(0.00784313772,0.00784313772) + float2(-1,-1);
                r19.w = (uint)r19.w >> 24;
                r19.w = (uint)r19.w;
                r19.w = r19.w * 0.00784313772 + -1;
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r28.w, r30.y, t1.xxxx 
r28.w = t1.Load(r30.y);
                r29.w = (int)r28.w & 255;
                r29.w = (uint)r29.w;
                r29.w = r29.w * 0.00784313772 + -1;
                if (8 == 0) r31.x = 0; else if (8+8 < 32) {                 r31.x = (uint)r28.w << (32-(8 + 8)); r31.x = (uint)r31.x >> (32-8);                } else r31.x = (uint)r28.w >> 8;
                if (8 == 0) r31.y = 0; else if (8+16 < 32) {                 r31.y = (uint)r28.w << (32-(8 + 16)); r31.y = (uint)r31.y >> (32-8);                } else r31.y = (uint)r28.w >> 16;
                r31.xy = (uint2)r31.xy;
                r31.xy = r31.xy * float2(0.00784313772,0.00784313772) + float2(-1,-1);
                r28.w = (uint)r28.w >> 24;
                r28.w = (uint)r28.w;
                r28.w = r28.w * 0.00784313772 + -1;
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r30.y, r30.z, t1.xxxx 
r30.y = t1.Load(r30.z);
                r30.z = f16tof32(r30.y);
                r30.y = (uint)r30.y >> 16;
                r30.y = f16tof32(r30.y);
                r31.z = mad((int)r23.y, asint(cb0[5].x), (int)r13.y);
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r31.z, r31.z, t1.xxxx 
r31.z = t1.Load(r31.z);
                if (8 == 0) r32.x = 0; else if (8+8 < 32) {                 r32.x = (uint)r31.z << (32-(8 + 8)); r32.x = (uint)r32.x >> (32-8);                } else r32.x = (uint)r31.z >> 8;
                if (8 == 0) r32.y = 0; else if (8+16 < 32) {                 r32.y = (uint)r31.z << (32-(8 + 16)); r32.y = (uint)r32.y >> (32-8);                } else r32.y = (uint)r31.z >> 16;
                r31.w = (uint)r31.z >> 24;
                r32.z = mad((int)r23.y, asint(cb0[5].x), asint(cb0[6].z));
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r32.w, r32.z, t1.xxxx 
r32.w = t1.Load(r32.z);
                r33.x = f16tof32(r32.w);
                r32.w = (uint)r32.w >> 16;
                r32.w = f16tof32(r32.w);
                r32.z = (int)r32.z + 4;
              // No code for instruction (needs manual fix):
                          // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.yz, r32.z, t1.xxyx
                          r33.yz = t1.Load2(r32.z);
                r32.z = f16tof32(r33.y);
                r33.y = (uint)r33.y >> 16;
                r33.y = f16tof32(r33.y);
                if (8 == 0) r34.x = 0; else if (8+8 < 32) {                 r34.x = (uint)r33.z << (32-(8 + 8)); r34.x = (uint)r34.x >> (32-8);                } else r34.x = (uint)r33.z >> 8;
                if (8 == 0) r34.y = 0; else if (8+16 < 32) {                 r34.y = (uint)r33.z << (32-(8 + 16)); r34.y = (uint)r34.y >> (32-8);                } else r34.y = (uint)r33.z >> 16;
                r25.zw = (uint2)r25.zw >> int2(16,16);
                r35.xyz = mad((int3)r23.zzz, asint(cb0[5].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r33.w, r35.x, t1.xxxx 
r33.w = t1.Load(r35.x);
                r34.z = (int)r33.w & 255;
                r34.z = (uint)r34.z;
                r34.z = r34.z * 0.00784313772 + -1;
                if (8 == 0) r35.x = 0; else if (8+8 < 32) {                 r35.x = (uint)r33.w << (32-(8 + 8)); r35.x = (uint)r35.x >> (32-8);                } else r35.x = (uint)r33.w >> 8;
                if (8 == 0) r35.w = 0; else if (8+16 < 32) {                 r35.w = (uint)r33.w << (32-(8 + 16)); r35.w = (uint)r35.w >> (32-8);                } else r35.w = (uint)r33.w >> 16;
                r35.xw = (uint2)r35.xw;
                r35.xw = r35.xw * float2(0.00784313772,0.00784313772) + float2(-1,-1);
                r33.w = (uint)r33.w >> 24;
                r33.w = (uint)r33.w;
                r33.w = r33.w * 0.00784313772 + -1;
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r34.w, r35.y, t1.xxxx 
r34.w = t1.Load(r35.y);
                r35.y = (int)r34.w & 255;
                r35.y = (uint)r35.y;
                r35.y = r35.y * 0.00784313772 + -1;
                if (8 == 0) r36.x = 0; else if (8+8 < 32) {                 r36.x = (uint)r34.w << (32-(8 + 8)); r36.x = (uint)r36.x >> (32-8);                } else r36.x = (uint)r34.w >> 8;
                if (8 == 0) r36.y = 0; else if (8+16 < 32) {                 r36.y = (uint)r34.w << (32-(8 + 16)); r36.y = (uint)r36.y >> (32-8);                } else r36.y = (uint)r34.w >> 16;
                r36.xy = (uint2)r36.xy;
                r36.xy = r36.xy * float2(0.00784313772,0.00784313772) + float2(-1,-1);
                r34.w = (uint)r34.w >> 24;
                r34.w = (uint)r34.w;
                r34.w = r34.w * 0.00784313772 + -1;
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r35.z, r35.z, t1.xxxx 
r35.z = t1.Load(r35.z);
                r36.z = f16tof32(r35.z);
                r35.z = (uint)r35.z >> 16;
                r35.z = f16tof32(r35.z);
                r36.w = mad((int)r23.z, asint(cb0[5].x), (int)r13.y);
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r36.w, r36.w, t1.xxxx 
r36.w = t1.Load(r36.w);
                if (8 == 0) r37.x = 0; else if (8+8 < 32) {                 r37.x = (uint)r36.w << (32-(8 + 8)); r37.x = (uint)r37.x >> (32-8);                } else r37.x = (uint)r36.w >> 8;
                if (8 == 0) r37.y = 0; else if (8+16 < 32) {                 r37.y = (uint)r36.w << (32-(8 + 16)); r37.y = (uint)r37.y >> (32-8);                } else r37.y = (uint)r36.w >> 16;
                r37.z = (uint)r36.w >> 24;
                r37.w = mad((int)r23.z, asint(cb0[5].x), asint(cb0[6].z));
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r38.x, r37.w, t1.xxxx 
r38.x = t1.Load(r37.w);
                r38.y = f16tof32(r38.x);
                r37.w = (int)r37.w + 4;
              // No code for instruction (needs manual fix):
                          // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r38.zw, r37.w, t1.xxxy
                            r38.zw = t1.Load2(r37.w);
                r37.w = f16tof32(r38.z);
                r38.xz = (uint2)r38.xz >> int2(16,16);
                r38.xz = f16tof32(r38.xz);
                if (8 == 0) r39.x = 0; else if (8+8 < 32) {                 r39.x = (uint)r38.w << (32-(8 + 8)); r39.x = (uint)r39.x >> (32-8);                } else r39.x = (uint)r38.w >> 8;
                if (8 == 0) r39.y = 0; else if (8+16 < 32) {                 r39.y = (uint)r38.w << (32-(8 + 16)); r39.y = (uint)r39.y >> (32-8);                } else r39.y = (uint)r38.w >> 16;
                r25.zw = f16tof32(r25.zw);
                r40.xyz = mad((int3)r24.zzz, asint(cb0[5].xxx), asint(cb0[5].yzw));
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r39.z, r40.x, t1.xxxx 
r39.z = t1.Load(r40.x);
                r39.w = (int)r39.z & 255;
                r39.w = (uint)r39.w;
                r39.w = r39.w * 0.00784313772 + -1;
                if (8 == 0) r40.x = 0; else if (8+8 < 32) {                 r40.x = (uint)r39.z << (32-(8 + 8)); r40.x = (uint)r40.x >> (32-8);                } else r40.x = (uint)r39.z >> 8;
                if (8 == 0) r40.w = 0; else if (8+16 < 32) {                 r40.w = (uint)r39.z << (32-(8 + 16)); r40.w = (uint)r40.w >> (32-8);                } else r40.w = (uint)r39.z >> 16;
                r40.xw = (uint2)r40.xw;
                r40.xw = r40.xw * float2(0.00784313772,0.00784313772) + float2(-1,-1);
                r39.z = (uint)r39.z >> 24;
                r39.z = (uint)r39.z;
                r39.z = r39.z * 0.00784313772 + -1;
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r40.y, r40.y, t1.xxxx 
r40.y = t1.Load(r40.y);
                r41.x = (int)r40.y & 255;
                r41.x = (uint)r41.x;
                r41.x = r41.x * 0.00784313772 + -1;
                if (8 == 0) r41.y = 0; else if (8+8 < 32) {                 r41.y = (uint)r40.y << (32-(8 + 8)); r41.y = (uint)r41.y >> (32-8);                } else r41.y = (uint)r40.y >> 8;
                if (8 == 0) r41.z = 0; else if (8+16 < 32) {                 r41.z = (uint)r40.y << (32-(8 + 16)); r41.z = (uint)r41.z >> (32-8);                } else r41.z = (uint)r40.y >> 16;
                r41.yz = (uint2)r41.yz;
                r41.yz = r41.yz * float2(0.00784313772,0.00784313772) + float2(-1,-1);
                r40.y = (uint)r40.y >> 24;
                r40.y = (uint)r40.y;
                r40.y = r40.y * 0.00784313772 + -1;
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r40.z, r40.z, t1.xxxx 
r40.z = t1.Load(r40.z);
                r41.w = f16tof32(r40.z);
                r40.z = (uint)r40.z >> 16;
                r40.z = f16tof32(r40.z);
                r42.x = mad((int)r24.z, asint(cb0[5].x), (int)r13.y);
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r42.x, r42.x, t1.xxxx 
r42.x = t1.Load(r42.x);
                if (8 == 0) r42.y = 0; else if (8+8 < 32) {                 r42.y = (uint)r42.x << (32-(8 + 8)); r42.y = (uint)r42.y >> (32-8);                } else r42.y = (uint)r42.x >> 8;
                if (8 == 0) r42.z = 0; else if (8+16 < 32) {                 r42.z = (uint)r42.x << (32-(8 + 16)); r42.z = (uint)r42.z >> (32-8);                } else r42.z = (uint)r42.x >> 16;
                r42.w = (uint)r42.x >> 24;
                r43.x = mad((int)r24.z, asint(cb0[5].x), asint(cb0[6].z));
              // No code for instruction (needs manual fix):
                            // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r43.y, r43.x, t1.xxxx 
r43.y = t1.Load(r43.x);
                r43.z = f16tof32(r43.y);
                r43.y = (uint)r43.y >> 16;
                r43.x = (int)r43.x + 4;
              // No code for instruction (needs manual fix):
                          // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r43.xw, r43.x, t1.xxxy
                            r43.xw = t1.Load2(r43.x);
                r44.x = f16tof32(r43.x);
                r43.x = (uint)r43.x >> 16;
                r43.xy = f16tof32(r43.xy);
                if (8 == 0) r44.y = 0; else if (8+8 < 32) {                 r44.y = (uint)r43.w << (32-(8 + 8)); r44.y = (uint)r44.y >> (32-8);                } else r44.y = (uint)r43.w >> 8;
                if (8 == 0) r44.z = 0; else if (8+16 < 32) {                 r44.z = (uint)r43.w << (32-(8 + 16)); r44.z = (uint)r44.z >> (32-8);                } else r44.z = (uint)r43.w >> 16;
                if (r26.w != 0) {
                  r44.w = (int)r18.w + 1;
                  r45.xyz = min(float3(2000,2000,2000), r26.xyz);
                  r45.xyz = f32tof16(r45.xyz);
                  r45.x = mad((int)r45.y, 0x00010000, (int)r45.x);
                  r45.w = (int)r18.w * asint(cb0[7].x);
                  r46.x = min(2000, r19.z);
                  r46.x = f32tof16(r46.x);
                  r45.y = mad((int)r46.x, 0x00010000, (int)r45.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xy, r45.w, r45.xyxx 
u1.Store2(r45.w, r45.xy);
                  r45.x = r24.w * 127.5 + 127.5;
                  r45.yz = r30.xw * float2(127.5,127.5) + float2(127.5,127.5);
                  r45.xyz = (uint3)r45.xyz;
                  r45.x = mad((int)r45.y, 256, (int)r45.x);
                  r45.x = mad((int)r45.z, 0x00010000, (int)r45.x);
                  r45.y = r19.w * 127.5 + 127.5;
                  r45.y = (uint)r45.y;
                  r45.x = mad((int)r45.y, 0x01000000, (int)r45.x);
                  r45.yzw = mad((int3)r18.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r45.y, r45.x 
u1.Store(r45.y, r45.x);
                  r45.x = r29.w * 127.5 + 127.5;
                  r45.x = (uint)r45.x;
                  r46.xy = r31.xy * float2(127.5,127.5) + float2(127.5,127.5);
                  r46.xy = (uint2)r46.xy;
                  r45.x = mad((int)r46.x, 256, (int)r45.x);
                  r45.x = mad((int)r46.y, 0x00010000, (int)r45.x);
                  r45.y = r28.w * 127.5 + 127.5;
                  r45.y = (uint)r45.y;
                  r45.x = mad((int)r45.y, 0x01000000, (int)r45.x);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r45.z, r45.x 
u1.Store(r45.z, r45.x);
                  r45.xy = min(float2(2000,2000), r30.zy);
                  r45.xy = f32tof16(r45.xy);
                  r45.x = mad((int)r45.y, 0x00010000, (int)r45.x);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r45.w, r45.x 
u1.Store(r45.w, r45.x);
                  if (r13.y != 0) {
                    r45.x = mad((int)r18.w, asint(cb0[7].x), (int)r13.y);
                    bitmask.y = ((~(-1 << 24)) << 8) & 0xffffffff;  r45.y = (((uint)r32.x << 8) & bitmask.y) | ((uint)r31.z & ~bitmask.y);
                    r45.y = mad((int)r32.y, 0x00010000, (int)r45.y);
                    r45.y = mad((int)r31.w, 0x01000000, (int)r45.y);
                  // No code for instruction (needs manual fix):
                                  // store_raw u1.x, r45.x, r45.y 
u1.Store(r45.x, r45.y);
                  }
                  r45.xy = mad((int2)r18.ww, asint(cb0[7].xx), asint(cb0[6].wz));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r45.x, r29.x 
u1.Store(r45.x, r29.x);
                  r45.x = min(2000, r33.x);
                  r45.z = min(2000, r32.w);
                  r45.xz = f32tof16(r45.xz);
                  r46.x = mad((int)r45.z, 0x00010000, (int)r45.x);
                  r45.x = min(2000, r32.z);
                  r45.z = min(2000, r33.y);
                  r45.xz = f32tof16(r45.xz);
                  r46.y = mad((int)r45.z, 0x00010000, (int)r45.x);
                  bitmask.x = ((~(-1 << 24)) << 8) & 0xffffffff;  r45.x = (((uint)r34.x << 8) & bitmask.x) | ((uint)r33.z & ~bitmask.x);
                  r45.x = mad((int)r34.y, 0x00010000, (int)r45.x);
                  bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r46.z = (((uint)r45.x << 0) & bitmask.z) | ((uint)r33.z & ~bitmask.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xyz, r45.y, r46.xyzx 
u1.Store3(r45.y, r46.xyz);
                  r45.x = (uint)r20.x >> 1;
                  r45.x = (uint)r45.x << 2;
                // No code for instruction (needs manual fix):
                                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r45.y, r45.x, u6.xxxx 
r45.y = u6.Load(r45.x);
                  r45.z = (int)r20.x & 1;
                  bitmask.y = ((~(-1 << 16)) << 16) & 0xffffffff;  r45.y = (((uint)r18.w << 16) & bitmask.y) | ((uint)r45.y & ~bitmask.y);
                  bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r45.w = (((uint)r18.w << 0) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                  r46.x = (int)-r45.z + 1;
                  r45.w = (int)r45.w * (int)r46.x;
                  r45.y = mad((int)r45.y, (int)r45.z, (int)r45.w);
                // No code for instruction (needs manual fix):
                              // store_raw u6.x, r45.x, r45.y 
u6.Store(r45.x, r45.y);
                  r20.xzw = (int3)r20.xxx + int3(3,1,2);
                  r45.x = (int)r44.w + 1;
                  r45.yzw = min(float3(2000,2000,2000), r27.xyz);
                  r45.yzw = f32tof16(r45.yzw);
                  r46.x = mad((int)r45.z, 0x00010000, (int)r45.y);
                  r45.y = (int)r44.w * asint(cb0[7].x);
                  r45.z = min(2000, r25.z);
                  r45.z = f32tof16(r45.z);
                  r46.y = mad((int)r45.z, 0x00010000, (int)r45.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xy, r45.y, r46.xyxx 
u1.Store2(r45.y, r46.xy);
                  r45.y = r34.z * 127.5 + 127.5;
                  r45.zw = r35.xw * float2(127.5,127.5) + float2(127.5,127.5);
                  r45.yzw = (uint3)r45.yzw;
                  r45.y = mad((int)r45.z, 256, (int)r45.y);
                  r45.y = mad((int)r45.w, 0x00010000, (int)r45.y);
                  r45.z = r33.w * 127.5 + 127.5;
                  r45.z = (uint)r45.z;
                  r45.y = mad((int)r45.z, 0x01000000, (int)r45.y);
                  r46.xyz = mad((int3)r44.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r46.x, r45.y 
u1.Store(r46.x, r45.y);
                  r45.y = r35.y * 127.5 + 127.5;
                  r45.zw = r36.xy * float2(127.5,127.5) + float2(127.5,127.5);
                  r45.yzw = (uint3)r45.yzw;
                  r45.y = mad((int)r45.z, 256, (int)r45.y);
                  r45.y = mad((int)r45.w, 0x00010000, (int)r45.y);
                  r45.z = r34.w * 127.5 + 127.5;
                  r45.z = (uint)r45.z;
                  r45.y = mad((int)r45.z, 0x01000000, (int)r45.y);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r46.y, r45.y 
u1.Store(r46.y, r45.y);
                  r45.y = min(2000, r36.z);
                  r45.z = min(2000, r35.z);
                  r45.yz = f32tof16(r45.yz);
                  r45.y = mad((int)r45.z, 0x00010000, (int)r45.y);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r46.z, r45.y 
u1.Store(r46.z, r45.y);
                  if (r13.y != 0) {
                    r45.y = mad((int)r44.w, asint(cb0[7].x), (int)r13.y);
                    bitmask.z = ((~(-1 << 24)) << 8) & 0xffffffff;  r45.z = (((uint)r37.x << 8) & bitmask.z) | ((uint)r36.w & ~bitmask.z);
                    r45.z = mad((int)r37.y, 0x00010000, (int)r45.z);
                    r45.z = mad((int)r37.z, 0x01000000, (int)r45.z);
                  // No code for instruction (needs manual fix):
                                  // store_raw u1.x, r45.y, r45.z 
u1.Store(r45.y, r45.z);
                  }
                  r45.yz = mad((int2)r44.ww, asint(cb0[7].xx), asint(cb0[6].wz));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r45.y, r29.y 
u1.Store(r45.y, r29.y);
                  r45.yw = min(float2(2000,2000), r38.yx);
                  r45.yw = f32tof16(r45.yw);
                  r46.x = mad((int)r45.w, 0x00010000, (int)r45.y);
                  r45.y = min(2000, r37.w);
                  r45.w = min(2000, r38.z);
                  r45.yw = f32tof16(r45.yw);
                  r46.y = mad((int)r45.w, 0x00010000, (int)r45.y);
                  bitmask.y = ((~(-1 << 24)) << 8) & 0xffffffff;  r45.y = (((uint)r39.x << 8) & bitmask.y) | ((uint)r38.w & ~bitmask.y);
                  r45.y = mad((int)r39.y, 0x00010000, (int)r45.y);
                  bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r46.z = (((uint)r45.y << 0) & bitmask.z) | ((uint)r38.w & ~bitmask.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xyz, r45.z, r46.xyzx 
u1.Store3(r45.z, r46.xyz);
                  r45.yz = (uint2)r20.zw >> int2(1,1);
                  r45.yz = (uint2)r45.yz << int2(2,2);
                // No code for instruction (needs manual fix):
                                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r45.w, r45.y, u6.xxxx 
r45.w = u6.Load(r45.y);
                  r46.xy = (int2)r20.zw & int2(1,1);
                  bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r46.z = (((uint)r44.w << 16) & bitmask.z) | ((uint)r45.w & ~bitmask.z);
                  bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r46.w = (((uint)r44.w << 0) & bitmask.w) | ((uint)r45.w & ~bitmask.w);
                  r47.xy = (int2)-r46.xy + int2(1,1);
                  r44.w = (int)r46.w * (int)r47.x;
                  r44.w = mad((int)r46.z, (int)r46.x, (int)r44.w);
                // No code for instruction (needs manual fix):
                              // store_raw u6.x, r45.y, r44.w 
u6.Store(r45.y, r44.w);
                  r18.w = (int)r45.x + 1;
                  r46.xzw = min(float3(2000,2000,2000), r28.xyz);
                  r46.xzw = f32tof16(r46.xzw);
                  r48.x = mad((int)r46.z, 0x00010000, (int)r46.x);
                  r44.w = (int)r45.x * asint(cb0[7].x);
                  r45.y = min(2000, r25.w);
                  r45.y = f32tof16(r45.y);
                  r48.y = mad((int)r45.y, 0x00010000, (int)r46.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xy, r44.w, r48.xyxx 
u1.Store2(r44.w, r48.xy);
                  r44.w = r39.w * 127.5 + 127.5;
                  r44.w = (uint)r44.w;
                  r45.yw = r40.xw * float2(127.5,127.5) + float2(127.5,127.5);
                  r45.yw = (uint2)r45.yw;
                  r44.w = mad((int)r45.y, 256, (int)r44.w);
                  r44.w = mad((int)r45.w, 0x00010000, (int)r44.w);
                  r45.y = r39.z * 127.5 + 127.5;
                  r45.y = (uint)r45.y;
                  r44.w = mad((int)r45.y, 0x01000000, (int)r44.w);
                  r46.xzw = mad((int3)r45.xxx, asint(cb0[7].xxx), asint(cb0[5].yzw));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r46.x, r44.w 
u1.Store(r46.x, r44.w);
                  r44.w = r41.x * 127.5 + 127.5;
                  r44.w = (uint)r44.w;
                  r45.yw = r41.yz * float2(127.5,127.5) + float2(127.5,127.5);
                  r45.yw = (uint2)r45.yw;
                  r44.w = mad((int)r45.y, 256, (int)r44.w);
                  r44.w = mad((int)r45.w, 0x00010000, (int)r44.w);
                  r45.y = r40.y * 127.5 + 127.5;
                  r45.y = (uint)r45.y;
                  r44.w = mad((int)r45.y, 0x01000000, (int)r44.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r46.z, r44.w 
u1.Store(r46.z, r44.w);
                  r44.w = min(2000, r41.w);
                  r44.w = f32tof16(r44.w);
                  r45.y = min(2000, r40.z);
                  r45.y = f32tof16(r45.y);
                  r44.w = mad((int)r45.y, 0x00010000, (int)r44.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r46.w, r44.w 
u1.Store(r46.w, r44.w);
                  if (r13.y != 0) {
                    r44.w = mad((int)r45.x, asint(cb0[7].x), (int)r13.y);
                    bitmask.y = ((~(-1 << 24)) << 8) & 0xffffffff;  r45.y = (((uint)r42.y << 8) & bitmask.y) | ((uint)r42.x & ~bitmask.y);
                    r45.y = mad((int)r42.z, 0x00010000, (int)r45.y);
                    r45.y = mad((int)r42.w, 0x01000000, (int)r45.y);
                  // No code for instruction (needs manual fix):
                                  // store_raw u1.x, r44.w, r45.y 
u1.Store(r44.w, r45.y);
                  }
                  r45.yw = mad((int2)r45.xx, asint(cb0[7].xx), asint(cb0[6].wz));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r45.y, r29.z 
u1.Store(r45.y, r29.z);
                  r44.w = min(2000, r43.z);
                  r44.w = f32tof16(r44.w);
                  r45.y = min(2000, r43.y);
                  r45.y = f32tof16(r45.y);
                  r48.x = mad((int)r45.y, 0x00010000, (int)r44.w);
                  r44.w = min(2000, r44.x);
                  r44.w = f32tof16(r44.w);
                  r45.y = min(2000, r43.x);
                  r45.y = f32tof16(r45.y);
                  r48.y = mad((int)r45.y, 0x00010000, (int)r44.w);
                  bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r44.w = (((uint)r44.y << 8) & bitmask.w) | ((uint)r43.w & ~bitmask.w);
                  r44.w = mad((int)r44.z, 0x00010000, (int)r44.w);
                  bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r48.z = (((uint)r44.w << 0) & bitmask.z) | ((uint)r43.w & ~bitmask.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xyz, r45.w, r48.xyzx 
u1.Store3(r45.w, r48.xyz);
                // No code for instruction (needs manual fix):
                                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r44.w, r45.z, u6.xxxx 
r44.w = u6.Load(r45.z);
                  bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r45.x = (((uint)r45.x << 16) & bitmask.x) | ((uint)r44.w & ~bitmask.x);
                  bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r45.y = (((uint)r45.x << 0) & bitmask.y) | ((uint)r44.w & ~bitmask.y);
                  r44.w = (int)r47.y * (int)r45.y;
                  r44.w = mad((int)r45.x, (int)r46.y, (int)r44.w);
                // No code for instruction (needs manual fix):
                              // store_raw u6.x, r45.z, r44.w 
u6.Store(r45.z, r44.w);
                  r44.w = cmp(0 < r33.x);
                  if (r44.w != 0) {
                    if (3 == 0) r44.w = 0; else if (3+5 < 32) {                     r44.w = (uint)r33.z << (32-(3 + 5)); r44.w = (uint)r44.w >> (32-3);                    } else r44.w = (uint)r33.z >> 5;
                    r45.xyzw = cmp((int4)r44.wwww == int4(0,1,2,3));
                    r46.xyzw = cmp((int4)r44.wwww == int4(4,5,6,7));
                    r45.xyzw = r45.xyzw ? r15.xyzw : 0;
                    r45.x = (int)r45.x | (int)r45.y;
                    r45.x = (int)r45.x | (int)r45.z;
                    r45.x = (int)r45.x | (int)r45.w;
                    r46.xyzw = r46.xyzw ? r16.xyzw : 0;
                    r45.x = (int)r45.x | (int)r46.x;
                    r45.x = (int)r45.x | (int)r46.y;
                    r45.x = (int)r45.x | (int)r46.z;
                    r45.x = (int)r45.x | (int)r46.w;
                    bitmask.x = ((~(-1 << 1)) << (uint)r33.z) & 0xffffffff;  r45.x = (((uint)1 << (uint)r33.z) & bitmask.x) | ((uint)r45.x & ~bitmask.x);
                    r44.w = 1 << (int)r44.w;
                    r46.xyzw = (int4)r44.wwww & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r45.xxxx * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r46.xyzw = (int4)r44.wwww & int4(16,32,64,128);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r45.xxxx * (int4)r46.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r32.w);
                  if (r44.w != 0) {
                    r44.w = (uint)r33.z >> 8;
                    if (3 == 0) r45.x = 0; else if (3+13 < 32) {                     r45.x = (uint)r33.z << (32-(3 + 13)); r45.x = (uint)r45.x >> (32-3);                    } else r45.x = (uint)r33.z >> 13;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r32.z);
                  if (r44.w != 0) {
                    r44.w = (uint)r33.z >> 16;
                    if (3 == 0) r45.x = 0; else if (3+21 < 32) {                     r45.x = (uint)r33.z << (32-(3 + 21)); r45.x = (uint)r45.x >> (32-3);                    } else r45.x = (uint)r33.z >> 21;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r33.y);
                  if (r44.w != 0) {
                    r44.w = (uint)r33.z >> 24;
                    r45.x = (uint)r44.w >> 5;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r38.y);
                  if (r44.w != 0) {
                    if (3 == 0) r44.w = 0; else if (3+5 < 32) {                     r44.w = (uint)r38.w << (32-(3 + 5)); r44.w = (uint)r44.w >> (32-3);                    } else r44.w = (uint)r38.w >> 5;
                    r45.xyzw = cmp((int4)r44.wwww == int4(0,1,2,3));
                    r46.xyzw = cmp((int4)r44.wwww == int4(4,5,6,7));
                    r45.xyzw = r45.xyzw ? r15.xyzw : 0;
                    r45.x = (int)r45.x | (int)r45.y;
                    r45.x = (int)r45.x | (int)r45.z;
                    r45.x = (int)r45.x | (int)r45.w;
                    r46.xyzw = r46.xyzw ? r16.xyzw : 0;
                    r45.x = (int)r45.x | (int)r46.x;
                    r45.x = (int)r45.x | (int)r46.y;
                    r45.x = (int)r45.x | (int)r46.z;
                    r45.x = (int)r45.x | (int)r46.w;
                    bitmask.x = ((~(-1 << 1)) << (uint)r38.w) & 0xffffffff;  r45.x = (((uint)1 << (uint)r38.w) & bitmask.x) | ((uint)r45.x & ~bitmask.x);
                    r44.w = 1 << (int)r44.w;
                    r46.xyzw = (int4)r44.wwww & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r45.xxxx * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r46.xyzw = (int4)r44.wwww & int4(16,32,64,128);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r45.xxxx * (int4)r46.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r38.x);
                  if (r44.w != 0) {
                    r44.w = (uint)r38.w >> 8;
                    if (3 == 0) r45.x = 0; else if (3+13 < 32) {                     r45.x = (uint)r38.w << (32-(3 + 13)); r45.x = (uint)r45.x >> (32-3);                    } else r45.x = (uint)r38.w >> 13;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r37.w);
                  if (r44.w != 0) {
                    r44.w = (uint)r38.w >> 16;
                    if (3 == 0) r45.x = 0; else if (3+21 < 32) {                     r45.x = (uint)r38.w << (32-(3 + 21)); r45.x = (uint)r45.x >> (32-3);                    } else r45.x = (uint)r38.w >> 21;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r38.z);
                  if (r44.w != 0) {
                    r44.w = (uint)r38.w >> 24;
                    r45.x = (uint)r44.w >> 5;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r43.z);
                  if (r44.w != 0) {
                    if (3 == 0) r44.w = 0; else if (3+5 < 32) {                     r44.w = (uint)r43.w << (32-(3 + 5)); r44.w = (uint)r44.w >> (32-3);                    } else r44.w = (uint)r43.w >> 5;
                    r45.xyzw = cmp((int4)r44.wwww == int4(0,1,2,3));
                    r46.xyzw = cmp((int4)r44.wwww == int4(4,5,6,7));
                    r45.xyzw = r45.xyzw ? r15.xyzw : 0;
                    r45.x = (int)r45.x | (int)r45.y;
                    r45.x = (int)r45.x | (int)r45.z;
                    r45.x = (int)r45.x | (int)r45.w;
                    r46.xyzw = r46.xyzw ? r16.xyzw : 0;
                    r45.x = (int)r45.x | (int)r46.x;
                    r45.x = (int)r45.x | (int)r46.y;
                    r45.x = (int)r45.x | (int)r46.z;
                    r45.x = (int)r45.x | (int)r46.w;
                    bitmask.x = ((~(-1 << 1)) << (uint)r43.w) & 0xffffffff;  r45.x = (((uint)1 << (uint)r43.w) & bitmask.x) | ((uint)r45.x & ~bitmask.x);
                    r44.w = 1 << (int)r44.w;
                    r46.xyzw = (int4)r44.wwww & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r45.xxxx * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r46.xyzw = (int4)r44.wwww & int4(16,32,64,128);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r45.xxxx * (int4)r46.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r43.y);
                  if (r44.w != 0) {
                    r44.w = (uint)r43.w >> 8;
                    if (3 == 0) r45.x = 0; else if (3+13 < 32) {                     r45.x = (uint)r43.w << (32-(3 + 13)); r45.x = (uint)r45.x >> (32-3);                    } else r45.x = (uint)r43.w >> 13;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r44.x);
                  if (r44.w != 0) {
                    r44.w = (uint)r43.w >> 16;
                    if (3 == 0) r45.x = 0; else if (3+21 < 32) {                     r45.x = (uint)r43.w << (32-(3 + 21)); r45.x = (uint)r45.x >> (32-3);                    } else r45.x = (uint)r43.w >> 21;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                  r44.w = cmp(0 < r43.x);
                  if (r44.w != 0) {
                    r44.w = (uint)r43.w >> 24;
                    r45.x = (uint)r44.w >> 5;
                    r46.xyzw = cmp((int4)r45.xxxx == int4(0,1,2,3));
                    r47.xyzw = cmp((int4)r45.xxxx == int4(4,5,6,7));
                    r46.xyzw = r46.xyzw ? r15.xyzw : 0;
                    r45.y = (int)r46.x | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    r46.xyzw = r47.xyzw ? r16.xyzw : 0;
                    r45.y = (int)r45.y | (int)r46.x;
                    r45.y = (int)r45.y | (int)r46.y;
                    r45.y = (int)r45.y | (int)r46.z;
                    r45.y = (int)r45.y | (int)r46.w;
                    bitmask.w = ((~(-1 << 1)) << (uint)r44.w) & 0xffffffff;  r44.w = (((uint)1 << (uint)r44.w) & bitmask.w) | ((uint)r45.y & ~bitmask.w);
                    r45.x = 1 << (int)r45.x;
                    r46.xyzw = (int4)r45.xxxx & int4(1,2,4,8);
                    r46.xyzw = r46.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r46.xyzw = (int4)r44.wwww * (int4)r46.xyzw;
                    r15.xyzw = (int4)r15.xyzw | (int4)r46.xyzw;
                    r45.xyzw = (int4)r45.xxxx & int4(16,32,64,128);
                    r45.xyzw = r45.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
                    r45.xyzw = (int4)r44.wwww * (int4)r45.xyzw;
                    r16.xyzw = (int4)r16.xyzw | (int4)r45.xyzw;
                  }
                } else {
                  r44.w = (int)r18.w + 1;
                  r26.xyz = min(float3(2000,2000,2000), r26.xyz);
                  r26.xyz = f32tof16(r26.xyz);
                  r26.x = mad((int)r26.y, 0x00010000, (int)r26.x);
                  r45.x = (int)r18.w * asint(cb0[7].x);
                  r19.z = min(2000, r19.z);
                  r19.z = f32tof16(r19.z);
                  r26.y = mad((int)r19.z, 0x00010000, (int)r26.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xy, r45.x, r26.xyxx 
u1.Store2(r45.x, r26.xy);
                  r19.z = r24.w * 127.5 + 127.5;
                  r19.z = (uint)r19.z;
                  r26.xy = r30.xw * float2(127.5,127.5) + float2(127.5,127.5);
                  r26.xy = (uint2)r26.xy;
                  r19.z = mad((int)r26.x, 256, (int)r19.z);
                  r19.z = mad((int)r26.y, 0x00010000, (int)r19.z);
                  r19.w = r19.w * 127.5 + 127.5;
                  r19.w = (uint)r19.w;
                  r19.z = mad((int)r19.w, 0x01000000, (int)r19.z);
                  r26.xyz = mad((int3)r18.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.x, r19.z 
u1.Store(r26.x, r19.z);
                  r19.z = r29.w * 127.5 + 127.5;
                  r19.z = (uint)r19.z;
                  r30.xw = r31.xy * float2(127.5,127.5) + float2(127.5,127.5);
                  r30.xw = (uint2)r30.xw;
                  r19.z = mad((int)r30.x, 256, (int)r19.z);
                  r19.z = mad((int)r30.w, 0x00010000, (int)r19.z);
                  r19.w = r28.w * 127.5 + 127.5;
                  r19.w = (uint)r19.w;
                  r19.z = mad((int)r19.w, 0x01000000, (int)r19.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.y, r19.z 
u1.Store(r26.y, r19.z);
                  r19.zw = min(float2(2000,2000), r30.zy);
                  r19.zw = f32tof16(r19.zw);
                  r19.z = mad((int)r19.w, 0x00010000, (int)r19.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.z, r19.z 
u1.Store(r26.z, r19.z);
                  if (r13.y != 0) {
                    r19.z = mad((int)r18.w, asint(cb0[7].x), (int)r13.y);
                    bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r19.w = (((uint)r32.x << 8) & bitmask.w) | ((uint)r31.z & ~bitmask.w);
                    r19.w = mad((int)r32.y, 0x00010000, (int)r19.w);
                    r19.w = mad((int)r31.w, 0x01000000, (int)r19.w);
                  // No code for instruction (needs manual fix):
                                  // store_raw u1.x, r19.z, r19.w 
u1.Store(r19.z, r19.w);
                  }
                  r19.zw = mad((int2)r18.ww, asint(cb0[7].xx), asint(cb0[6].wz));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r19.z, r29.x 
u1.Store(r19.z, r29.x);
                  r19.z = min(2000, r33.x);
                  r19.z = f32tof16(r19.z);
                  r24.w = min(2000, r32.w);
                  r24.w = f32tof16(r24.w);
                  r26.x = mad((int)r24.w, 0x00010000, (int)r19.z);
                  r19.z = min(2000, r32.z);
                  r19.z = f32tof16(r19.z);
                  r24.w = min(2000, r33.y);
                  r24.w = f32tof16(r24.w);
                  r26.y = mad((int)r24.w, 0x00010000, (int)r19.z);
                  bitmask.z = ((~(-1 << 24)) << 8) & 0xffffffff;  r19.z = (((uint)r34.x << 8) & bitmask.z) | ((uint)r33.z & ~bitmask.z);
                  r19.z = mad((int)r34.y, 0x00010000, (int)r19.z);
                  bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r26.z = (((uint)r19.z << 0) & bitmask.z) | ((uint)r33.z & ~bitmask.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xyz, r19.w, r26.xyzx 
u1.Store3(r19.w, r26.xyz);
                  r19.z = (uint)r20.y >> 1;
                  r19.z = (uint)r19.z << 2;
                // No code for instruction (needs manual fix):
                                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r19.z, u7.xxxx 
r19.w = u7.Load(r19.z);
                  r24.w = (int)r20.y & 1;
                  bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r26.x = (((uint)r18.w << 16) & bitmask.x) | ((uint)r19.w & ~bitmask.x);
                  bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r26.y = (((uint)r18.w << 0) & bitmask.y) | ((uint)r19.w & ~bitmask.y);
                  r19.w = (int)-r24.w + 1;
                  r19.w = (int)r19.w * (int)r26.y;
                  r19.w = mad((int)r26.x, (int)r24.w, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u7.x, r19.z, r19.w 
u7.Store(r19.z, r19.w);
                  r20.yzw = (int3)r20.yyy + int3(3,1,2);
                  r19.z = (int)r44.w + 1;
                  r26.xyz = min(float3(2000,2000,2000), r27.xyz);
                  r26.xyz = f32tof16(r26.xyz);
                  r26.x = mad((int)r26.y, 0x00010000, (int)r26.x);
                  r19.w = (int)r44.w * asint(cb0[7].x);
                  r24.w = min(2000, r25.z);
                  r24.w = f32tof16(r24.w);
                  r26.y = mad((int)r24.w, 0x00010000, (int)r26.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xy, r19.w, r26.xyxx 
u1.Store2(r19.w, r26.xy);
                  r19.w = r34.z * 127.5 + 127.5;
                  r19.w = (uint)r19.w;
                  r26.xy = r35.xw * float2(127.5,127.5) + float2(127.5,127.5);
                  r26.xy = (uint2)r26.xy;
                  r19.w = mad((int)r26.x, 256, (int)r19.w);
                  r19.w = mad((int)r26.y, 0x00010000, (int)r19.w);
                  r24.w = r33.w * 127.5 + 127.5;
                  r24.w = (uint)r24.w;
                  r19.w = mad((int)r24.w, 0x01000000, (int)r19.w);
                  r26.xyz = mad((int3)r44.www, asint(cb0[7].xxx), asint(cb0[5].yzw));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.x, r19.w 
u1.Store(r26.x, r19.w);
                  r19.w = r35.y * 127.5 + 127.5;
                  r19.w = (uint)r19.w;
                  r27.xy = r36.xy * float2(127.5,127.5) + float2(127.5,127.5);
                  r27.xy = (uint2)r27.xy;
                  r19.w = mad((int)r27.x, 256, (int)r19.w);
                  r19.w = mad((int)r27.y, 0x00010000, (int)r19.w);
                  r24.w = r34.w * 127.5 + 127.5;
                  r24.w = (uint)r24.w;
                  r19.w = mad((int)r24.w, 0x01000000, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.y, r19.w 
u1.Store(r26.y, r19.w);
                  r19.w = min(2000, r36.z);
                  r19.w = f32tof16(r19.w);
                  r24.w = min(2000, r35.z);
                  r24.w = f32tof16(r24.w);
                  r19.w = mad((int)r24.w, 0x00010000, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.z, r19.w 
u1.Store(r26.z, r19.w);
                  if (r13.y != 0) {
                    r19.w = mad((int)r44.w, asint(cb0[7].x), (int)r13.y);
                    bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r24.w = (((uint)r37.x << 8) & bitmask.w) | ((uint)r36.w & ~bitmask.w);
                    r24.w = mad((int)r37.y, 0x00010000, (int)r24.w);
                    r24.w = mad((int)r37.z, 0x01000000, (int)r24.w);
                  // No code for instruction (needs manual fix):
                                  // store_raw u1.x, r19.w, r24.w 
u1.Store(r19.w, r24.w);
                  }
                  r26.xy = mad((int2)r44.ww, asint(cb0[7].xx), asint(cb0[6].wz));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r26.x, r29.y 
u1.Store(r26.x, r29.y);
                  r19.w = min(2000, r38.y);
                  r19.w = f32tof16(r19.w);
                  r24.w = min(2000, r38.x);
                  r24.w = f32tof16(r24.w);
                  r27.x = mad((int)r24.w, 0x00010000, (int)r19.w);
                  r19.w = min(2000, r37.w);
                  r19.w = f32tof16(r19.w);
                  r24.w = min(2000, r38.z);
                  r24.w = f32tof16(r24.w);
                  r27.y = mad((int)r24.w, 0x00010000, (int)r19.w);
                  bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r19.w = (((uint)r39.x << 8) & bitmask.w) | ((uint)r38.w & ~bitmask.w);
                  r19.w = mad((int)r39.y, 0x00010000, (int)r19.w);
                  bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r27.z = (((uint)r19.w << 0) & bitmask.z) | ((uint)r38.w & ~bitmask.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xyz, r26.y, r27.xyzx 
u1.Store3(r26.y, r27.xyz);
                  r26.xy = (uint2)r20.zw >> int2(1,1);
                  r26.xy = (uint2)r26.xy << int2(2,2);
                // No code for instruction (needs manual fix):
                                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r26.x, u7.xxxx 
r19.w = u7.Load(r26.x);
                  r20.zw = (int2)r20.zw & int2(1,1);
                  bitmask.x = ((~(-1 << 16)) << 16) & 0xffffffff;  r27.x = (((uint)r44.w << 16) & bitmask.x) | ((uint)r19.w & ~bitmask.x);
                  bitmask.y = ((~(-1 << 16)) << 0) & 0xffffffff;  r27.y = (((uint)r44.w << 0) & bitmask.y) | ((uint)r19.w & ~bitmask.y);
                  r29.xy = (int2)-r20.zw + int2(1,1);
                  r19.w = (int)r27.y * (int)r29.x;
                  r19.w = mad((int)r27.x, (int)r20.z, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u7.x, r26.x, r19.w 
u7.Store(r26.x, r19.w);
                  r18.w = (int)r19.z + 1;
                  r27.xyz = min(float3(2000,2000,2000), r28.xyz);
                  r27.xyz = f32tof16(r27.xyz);
                  r27.x = mad((int)r27.y, 0x00010000, (int)r27.x);
                  r19.w = (int)r19.z * asint(cb0[7].x);
                  r20.z = min(2000, r25.w);
                  r20.z = f32tof16(r20.z);
                  r27.y = mad((int)r20.z, 0x00010000, (int)r27.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xy, r19.w, r27.xyxx 
u1.Store2(r19.w, r27.xy);
                  r19.w = r39.w * 127.5 + 127.5;
                  r19.w = (uint)r19.w;
                  r25.zw = r40.xw * float2(127.5,127.5) + float2(127.5,127.5);
                  r25.zw = (uint2)r25.zw;
                  r19.w = mad((int)r25.z, 256, (int)r19.w);
                  r19.w = mad((int)r25.w, 0x00010000, (int)r19.w);
                  r20.z = r39.z * 127.5 + 127.5;
                  r20.z = (uint)r20.z;
                  r19.w = mad((int)r20.z, 0x01000000, (int)r19.w);
                  r27.xyz = mad((int3)r19.zzz, asint(cb0[7].xxx), asint(cb0[5].yzw));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r27.x, r19.w 
u1.Store(r27.x, r19.w);
                  r19.w = r41.x * 127.5 + 127.5;
                  r19.w = (uint)r19.w;
                  r25.zw = r41.yz * float2(127.5,127.5) + float2(127.5,127.5);
                  r25.zw = (uint2)r25.zw;
                  r19.w = mad((int)r25.z, 256, (int)r19.w);
                  r19.w = mad((int)r25.w, 0x00010000, (int)r19.w);
                  r20.z = r40.y * 127.5 + 127.5;
                  r20.z = (uint)r20.z;
                  r19.w = mad((int)r20.z, 0x01000000, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r27.y, r19.w 
u1.Store(r27.y, r19.w);
                  r19.w = min(2000, r41.w);
                  r19.w = f32tof16(r19.w);
                  r20.z = min(2000, r40.z);
                  r20.z = f32tof16(r20.z);
                  r19.w = mad((int)r20.z, 0x00010000, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r27.z, r19.w 
u1.Store(r27.z, r19.w);
                  if (r13.y != 0) {
                    r19.w = mad((int)r19.z, asint(cb0[7].x), (int)r13.y);
                    bitmask.z = ((~(-1 << 24)) << 8) & 0xffffffff;  r20.z = (((uint)r42.y << 8) & bitmask.z) | ((uint)r42.x & ~bitmask.z);
                    r20.z = mad((int)r42.z, 0x00010000, (int)r20.z);
                    r20.z = mad((int)r42.w, 0x01000000, (int)r20.z);
                  // No code for instruction (needs manual fix):
                                  // store_raw u1.x, r19.w, r20.z 
u1.Store(r19.w, r20.z);
                  }
                  r25.zw = mad((int2)r19.zz, asint(cb0[7].xx), asint(cb0[6].wz));
                // No code for instruction (needs manual fix):
                              // store_raw u1.x, r25.z, r29.z 
u1.Store(r25.z, r29.z);
                  r19.w = min(2000, r43.z);
                  r19.w = f32tof16(r19.w);
                  r20.z = min(2000, r43.y);
                  r20.z = f32tof16(r20.z);
                  r27.x = mad((int)r20.z, 0x00010000, (int)r19.w);
                  r19.w = min(2000, r44.x);
                  r19.w = f32tof16(r19.w);
                  r20.z = min(2000, r43.x);
                  r20.z = f32tof16(r20.z);
                  r27.y = mad((int)r20.z, 0x00010000, (int)r19.w);
                  bitmask.w = ((~(-1 << 24)) << 8) & 0xffffffff;  r19.w = (((uint)r44.y << 8) & bitmask.w) | ((uint)r43.w & ~bitmask.w);
                  r19.w = mad((int)r44.z, 0x00010000, (int)r19.w);
                  bitmask.z = ((~(-1 << 24)) << 0) & 0xffffffff;  r27.z = (((uint)r19.w << 0) & bitmask.z) | ((uint)r43.w & ~bitmask.z);
                // No code for instruction (needs manual fix):
                              // store_raw u1.xyz, r25.w, r27.xyzx 
u1.Store3(r25.w, r27.xyz);
                // No code for instruction (needs manual fix):
                                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r26.y, u7.xxxx 
r19.w = u7.Load(r26.y);
                  bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r19.z = (((uint)r19.z << 16) & bitmask.z) | ((uint)r19.w & ~bitmask.z);
                  bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r19.w = (((uint)r19.z << 0) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
                  r19.w = (int)r29.y * (int)r19.w;
                  r19.z = mad((int)r19.z, (int)r20.w, (int)r19.w);
                // No code for instruction (needs manual fix):
                              // store_raw u7.x, r26.y, r19.z 
u7.Store(r26.y, r19.z);
                }
              }
            }
          }
        } else {
          r26.w = r14.y;
          r27.w = r14.z;
        }
        r19.z = ~(int)r27.w;
        r19.z = (int)r19.z & (int)r26.w;
        r19.w = (int)r13.z + 3;
        r13.z = r19.z ? r19.w : r13.z;
        r19.z = ~(int)r26.w;
        r19.z = (int)r27.w & (int)r19.z;
        if (r19.z != 0) {
          r19.z = (uint)r21.x >> 1;
          r19.z = (uint)r19.z << 2;
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r19.z, u4.xxxx 
r19.w = u4.Load(r19.z);
          r20.z = (int)r21.x & 1;
          bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r25.z = (((uint)r23.y << 16) & bitmask.z) | ((uint)r19.w & ~bitmask.z);
          bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r25.w = (((uint)r23.y << 0) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
          r19.w = (int)-r20.z + 1;
          r19.w = (int)r19.w * (int)r25.w;
          r19.w = mad((int)r25.z, (int)r20.z, (int)r19.w);
        // No code for instruction (needs manual fix):
              // store_raw u4.x, r19.z, r19.w 
u4.Store(r19.z, r19.w);
          r21.xyz = (int3)r21.xxx + int3(3,1,2);
          r19.zw = (uint2)r21.yz >> int2(1,1);
          r19.zw = (uint2)r19.zw << int2(2,2);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r20.z, r19.z, u4.xxxx 
r20.z = u4.Load(r19.z);
          r21.yz = (int2)r21.yz & int2(1,1);
          bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r20.z = (((uint)r23.z << 16) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
          bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r20.w = (((uint)r23.z << 0) & bitmask.w) | ((uint)r20.z & ~bitmask.w);
          r25.zw = (int2)-r21.yz + int2(1,1);
          r20.w = (int)r20.w * (int)r25.z;
          r20.z = mad((int)r20.z, (int)r21.y, (int)r20.w);
        // No code for instruction (needs manual fix):
              // store_raw u4.x, r19.z, r20.z 
u4.Store(r19.z, r20.z);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r19.w, u4.xxxx 
r19.z = u4.Load(r19.w);
          bitmask.z = ((~(-1 << 16)) << 16) & 0xffffffff;  r20.z = (((uint)r24.z << 16) & bitmask.z) | ((uint)r19.z & ~bitmask.z);
          bitmask.w = ((~(-1 << 16)) << 0) & 0xffffffff;  r20.w = (((uint)r24.z << 0) & bitmask.w) | ((uint)r19.z & ~bitmask.w);
          r19.z = (int)r25.w * (int)r20.w;
          r19.z = mad((int)r20.z, (int)r21.z, (int)r19.z);
        // No code for instruction (needs manual fix):
              // store_raw u4.x, r19.w, r19.z 
u4.Store(r19.w, r19.z);
          r19.z = mad((int)r23.y, asint(cb0[5].x), asint(cb0[6].z));
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r19.z, t1.xxxx 
r19.w = t1.Load(r19.z);
          r20.z = f16tof32(r19.w);
          r19.w = (uint)r19.w >> 16;
          r19.w = f16tof32(r19.w);
          r19.z = (int)r19.z + 4;
        // No code for instruction (needs manual fix):
              // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r21.yz, r19.z, t1.xxyx
              r21.yz = t1.Load2(r19.z);
          r19.z = f16tof32(r21.y);
          r20.w = (uint)r21.y >> 16;
          r20.w = f16tof32(r20.w);
          r20.z = cmp(0 < r20.z);
          if (r20.z != 0) {
            if (3 == 0) r20.z = 0; else if (3+5 < 32) {             r20.z = (uint)r21.z << (32-(3 + 5)); r20.z = (uint)r20.z >> (32-3);            } else r20.z = (uint)r21.z >> 5;
            r27.xyzw = cmp((int4)r20.zzzz == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r20.zzzz == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r21.y = (int)r27.x | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r21.y = (int)r21.y | (int)r27.x;
            r21.y = (int)r21.y | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            bitmask.y = ((~(-1 << 1)) << (uint)r21.z) & 0xffffffff;  r21.y = (((uint)1 << (uint)r21.z) & bitmask.y) | ((uint)r21.y & ~bitmask.y);
            r20.z = 1 << (int)r20.z;
            r27.xyzw = (int4)r20.zzzz & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r21.yyyy * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r20.zzzz & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r21.yyyy * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.zw = cmp(float2(0,0) < r19.zw);
          if (r19.w != 0) {
            r19.w = (uint)r21.z >> 8;
            if (3 == 0) r20.z = 0; else if (3+13 < 32) {             r20.z = (uint)r21.z << (32-(3 + 13)); r20.z = (uint)r20.z >> (32-3);            } else r20.z = (uint)r21.z >> 13;
            r27.xyzw = cmp((int4)r20.zzzz == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r20.zzzz == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r21.y = (int)r27.x | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r21.y = (int)r21.y | (int)r27.x;
            r21.y = (int)r21.y | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            bitmask.w = ((~(-1 << 1)) << (uint)r19.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r19.w) & bitmask.w) | ((uint)r21.y & ~bitmask.w);
            r20.z = 1 << (int)r20.z;
            r27.xyzw = (int4)r20.zzzz & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.wwww * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r20.zzzz & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.wwww * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          if (r19.z != 0) {
            r19.z = (uint)r21.z >> 16;
            if (3 == 0) r19.w = 0; else if (3+21 < 32) {             r19.w = (uint)r21.z << (32-(3 + 21)); r19.w = (uint)r19.w >> (32-3);            } else r19.w = (uint)r21.z >> 21;
            r27.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r20.z = (int)r27.x | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r20.z = (int)r20.z | (int)r27.x;
            r20.z = (int)r20.z | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
            r19.w = 1 << (int)r19.w;
            r27.xyzw = (int4)r19.wwww & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r19.wwww & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.z = cmp(0 < r20.w);
          if (r19.z != 0) {
            r19.z = (uint)r21.z >> 24;
            r19.w = (uint)r19.z >> 5;
            r27.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r20.z = (int)r27.x | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r20.z = (int)r20.z | (int)r27.x;
            r20.z = (int)r20.z | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
            r19.w = 1 << (int)r19.w;
            r27.xyzw = (int4)r19.wwww & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r19.wwww & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.z = mad((int)r23.z, asint(cb0[5].x), asint(cb0[6].z));
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r19.z, t1.xxxx 
r19.w = t1.Load(r19.z);
          r20.z = f16tof32(r19.w);
          r19.w = (uint)r19.w >> 16;
          r19.w = f16tof32(r19.w);
          r19.z = (int)r19.z + 4;
        // No code for instruction (needs manual fix):
              // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r21.yz, r19.z, t1.xxyx
              r21.yz = t1.Load2(r19.z);
          r19.z = f16tof32(r21.y);
          r20.w = (uint)r21.y >> 16;
          r20.w = f16tof32(r20.w);
          r20.z = cmp(0 < r20.z);
          if (r20.z != 0) {
            if (3 == 0) r20.z = 0; else if (3+5 < 32) {             r20.z = (uint)r21.z << (32-(3 + 5)); r20.z = (uint)r20.z >> (32-3);            } else r20.z = (uint)r21.z >> 5;
            r27.xyzw = cmp((int4)r20.zzzz == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r20.zzzz == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r21.y = (int)r27.x | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r21.y = (int)r21.y | (int)r27.x;
            r21.y = (int)r21.y | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            bitmask.y = ((~(-1 << 1)) << (uint)r21.z) & 0xffffffff;  r21.y = (((uint)1 << (uint)r21.z) & bitmask.y) | ((uint)r21.y & ~bitmask.y);
            r20.z = 1 << (int)r20.z;
            r27.xyzw = (int4)r20.zzzz & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r21.yyyy * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r20.zzzz & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r21.yyyy * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.zw = cmp(float2(0,0) < r19.zw);
          if (r19.w != 0) {
            r19.w = (uint)r21.z >> 8;
            if (3 == 0) r20.z = 0; else if (3+13 < 32) {             r20.z = (uint)r21.z << (32-(3 + 13)); r20.z = (uint)r20.z >> (32-3);            } else r20.z = (uint)r21.z >> 13;
            r27.xyzw = cmp((int4)r20.zzzz == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r20.zzzz == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r21.y = (int)r27.x | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r21.y = (int)r21.y | (int)r27.x;
            r21.y = (int)r21.y | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            bitmask.w = ((~(-1 << 1)) << (uint)r19.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r19.w) & bitmask.w) | ((uint)r21.y & ~bitmask.w);
            r20.z = 1 << (int)r20.z;
            r27.xyzw = (int4)r20.zzzz & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.wwww * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r20.zzzz & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.wwww * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          if (r19.z != 0) {
            r19.z = (uint)r21.z >> 16;
            if (3 == 0) r19.w = 0; else if (3+21 < 32) {             r19.w = (uint)r21.z << (32-(3 + 21)); r19.w = (uint)r19.w >> (32-3);            } else r19.w = (uint)r21.z >> 21;
            r27.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r20.z = (int)r27.x | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r20.z = (int)r20.z | (int)r27.x;
            r20.z = (int)r20.z | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
            r19.w = 1 << (int)r19.w;
            r27.xyzw = (int4)r19.wwww & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r19.wwww & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.z = cmp(0 < r20.w);
          if (r19.z != 0) {
            r19.z = (uint)r21.z >> 24;
            r19.w = (uint)r19.z >> 5;
            r27.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r20.z = (int)r27.x | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r20.z = (int)r20.z | (int)r27.x;
            r20.z = (int)r20.z | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
            r19.w = 1 << (int)r19.w;
            r27.xyzw = (int4)r19.wwww & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r19.wwww & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.z = mad((int)r24.z, asint(cb0[5].x), asint(cb0[6].z));
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.w, r19.z, t1.xxxx 
r19.w = t1.Load(r19.z);
          r20.z = f16tof32(r19.w);
          r19.w = (uint)r19.w >> 16;
          r19.w = f16tof32(r19.w);
          r19.z = (int)r19.z + 4;
        // No code for instruction (needs manual fix):
              // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r21.yz, r19.z, t1.xxyx
              r21.yz = t1.Load2(r19.z);
          r19.z = f16tof32(r21.y);
          r20.w = (uint)r21.y >> 16;
          r20.w = f16tof32(r20.w);
          r20.z = cmp(0 < r20.z);
          if (r20.z != 0) {
            if (3 == 0) r20.z = 0; else if (3+5 < 32) {             r20.z = (uint)r21.z << (32-(3 + 5)); r20.z = (uint)r20.z >> (32-3);            } else r20.z = (uint)r21.z >> 5;
            r27.xyzw = cmp((int4)r20.zzzz == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r20.zzzz == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r21.y = (int)r27.x | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r21.y = (int)r21.y | (int)r27.x;
            r21.y = (int)r21.y | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            bitmask.y = ((~(-1 << 1)) << (uint)r21.z) & 0xffffffff;  r21.y = (((uint)1 << (uint)r21.z) & bitmask.y) | ((uint)r21.y & ~bitmask.y);
            r20.z = 1 << (int)r20.z;
            r27.xyzw = (int4)r20.zzzz & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r21.yyyy * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r20.zzzz & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r21.yyyy * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.zw = cmp(float2(0,0) < r19.zw);
          if (r19.w != 0) {
            r19.w = (uint)r21.z >> 8;
            if (3 == 0) r20.z = 0; else if (3+13 < 32) {             r20.z = (uint)r21.z << (32-(3 + 13)); r20.z = (uint)r20.z >> (32-3);            } else r20.z = (uint)r21.z >> 13;
            r27.xyzw = cmp((int4)r20.zzzz == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r20.zzzz == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r21.y = (int)r27.x | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r21.y = (int)r21.y | (int)r27.x;
            r21.y = (int)r21.y | (int)r27.y;
            r21.y = (int)r21.y | (int)r27.z;
            r21.y = (int)r21.y | (int)r27.w;
            bitmask.w = ((~(-1 << 1)) << (uint)r19.w) & 0xffffffff;  r19.w = (((uint)1 << (uint)r19.w) & bitmask.w) | ((uint)r21.y & ~bitmask.w);
            r20.z = 1 << (int)r20.z;
            r27.xyzw = (int4)r20.zzzz & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.wwww * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r20.zzzz & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.wwww * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          if (r19.z != 0) {
            r19.z = (uint)r21.z >> 16;
            if (3 == 0) r19.w = 0; else if (3+21 < 32) {             r19.w = (uint)r21.z << (32-(3 + 21)); r19.w = (uint)r19.w >> (32-3);            } else r19.w = (uint)r21.z >> 21;
            r27.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r20.z = (int)r27.x | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r20.z = (int)r20.z | (int)r27.x;
            r20.z = (int)r20.z | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
            r19.w = 1 << (int)r19.w;
            r27.xyzw = (int4)r19.wwww & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r19.wwww & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
          r19.z = cmp(0 < r20.w);
          if (r19.z != 0) {
            r19.z = (uint)r21.z >> 24;
            r19.w = (uint)r19.z >> 5;
            r27.xyzw = cmp((int4)r19.wwww == int4(0,1,2,3));
            r28.xyzw = cmp((int4)r19.wwww == int4(4,5,6,7));
            r27.xyzw = r27.xyzw ? r15.xyzw : 0;
            r20.z = (int)r27.x | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            r27.xyzw = r28.xyzw ? r16.xyzw : 0;
            r20.z = (int)r20.z | (int)r27.x;
            r20.z = (int)r20.z | (int)r27.y;
            r20.z = (int)r20.z | (int)r27.z;
            r20.z = (int)r20.z | (int)r27.w;
            bitmask.z = ((~(-1 << 1)) << (uint)r19.z) & 0xffffffff;  r19.z = (((uint)1 << (uint)r19.z) & bitmask.z) | ((uint)r20.z & ~bitmask.z);
            r19.w = 1 << (int)r19.w;
            r27.xyzw = (int4)r19.wwww & int4(1,2,4,8);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r15.xyzw = (int4)r15.xyzw | (int4)r27.xyzw;
            r27.xyzw = (int4)r19.wwww & int4(16,32,64,128);
            r27.xyzw = r27.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
            r27.xyzw = (int4)r19.zzzz * (int4)r27.xyzw;
            r16.xyzw = (int4)r16.xyzw | (int4)r27.xyzw;
          }
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r23.x, u2.xxxx 
r19.z = u2.Load(r23.x);
          r19.zw = (int2)r19.zz & int2(0xffff,0xffff0000);
          r19.w = (int)r23.w * (int)r19.w;
          r19.z = mad((int)r19.z, (int)r22.w, (int)r19.w);
        // No code for instruction (needs manual fix):
              // store_raw u2.x, r23.x, r19.z 
u2.Store(r23.x, r19.z);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r22.y, u2.xxxx 
r19.z = u2.Load(r22.y);
          r19.zw = (int2)r19.zz & int2(0xffff,0xffff0000);
          r19.w = (int)r25.x * (int)r19.w;
          r19.z = mad((int)r19.z, (int)r24.x, (int)r19.w);
        // No code for instruction (needs manual fix):
              // store_raw u2.x, r22.y, r19.z 
u2.Store(r22.y, r19.z);
        // No code for instruction (needs manual fix):
                // ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r19.z, r22.z, u2.xxxx 
r19.z = u2.Load(r22.z);
          r19.zw = (int2)r19.zz & int2(0xffff,0xffff0000);
          r19.w = (int)r25.y * (int)r19.w;
          r19.z = mad((int)r19.z, (int)r24.y, (int)r19.w);
        // No code for instruction (needs manual fix):
              // store_raw u2.x, r22.z, r19.z 
u2.Store(r22.z, r19.z);
        }
        r21.w = (int)r21.w | (int)r26.w;
      }
      r10.xyzw = r15.xyzw;
      r11.xyzw = r16.xyzw;
      r6.xyz = r17.xyz;
      r7.xyz = r18.xyz;
      r8.yw = r19.xy;
      r9.xy = r20.xy;
      r8.x = r13.z;
      r8.z = r21.x;
      r9.w = r17.w;
      r6.w = r18.w;
      r13.x = r21.w ? 0 : 1;
      r13.x = (uint)r13.x << (int)r12.w;
      r9.z = (int)r9.z | (int)r13.x;
      r12.w = (int)r12.w + 1;
    }
    u0[vThreadID.x].val[0/4] = r6.x;
    u0[vThreadID.x].val[0/4+1] = r6.y;
    u0[vThreadID.x].val[0/4+2] = r6.z;
    u0[vThreadID.x].val[16/4] = r7.x;
    u0[vThreadID.x].val[16/4+1] = r7.y;
    u0[vThreadID.x].val[16/4+2] = r7.z;
    u0[vThreadID.x].val[32/4] = r8.x;
    u0[vThreadID.x].val[32/4+1] = r8.y;
    u0[vThreadID.x].val[32/4+2] = r8.z;
    u0[vThreadID.x].val[32/4+3] = r8.w;
    u0[vThreadID.x].val[48/4] = r9.x;
    u0[vThreadID.x].val[48/4+1] = r9.y;
    u0[vThreadID.x].val[48/4+2] = r9.z;
    u0[vThreadID.x].val[48/4+3] = r9.w;
    u0[vThreadID.x].val[64/4] = r10.x;
    u0[vThreadID.x].val[64/4+1] = r10.y;
    u0[vThreadID.x].val[64/4+2] = r10.z;
    u0[vThreadID.x].val[64/4+3] = r10.w;
    u0[vThreadID.x].val[80/4] = r11.x;
    u0[vThreadID.x].val[80/4+1] = r11.y;
    u0[vThreadID.x].val[80/4+2] = r11.z;
    u0[vThreadID.x].val[80/4+3] = r11.w;
    u0[vThreadID.x].val[96/4] = r6.w;
  }
  return;
}