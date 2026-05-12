ps_5_0
dcl_globalFlags refactoringAllowed
dcl_immediateConstantBuffer { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { 2, 1, -1.000000, 1.000000},
                              { 2, 1, 1.000000, 1.000000},
                              { 0, 2, 1.000000, -1.000000},
                              { 0, 2, 1.000000, 1.000000},
                              { 0, 1, 1.000000, 1.000000},
                              { 0, 1, -1.000000, 1.000000} }
dcl_constantbuffer CB0[239], immediateIndexed
dcl_constantbuffer CB1[259], dynamicIndexed
dcl_constantbuffer CB2[3], immediateIndexed
dcl_constantbuffer CB3[2054], dynamicIndexed
dcl_constantbuffer CB4[401], dynamicIndexed
dcl_constantbuffer CB5[160], dynamicIndexed
dcl_constantbuffer CB6[4], immediateIndexed
dcl_constantbuffer CB13[15], immediateIndexed
dcl_sampler s0, mode_default
dcl_sampler s1, mode_default
dcl_sampler s2, mode_default
dcl_sampler s3, mode_default
dcl_sampler s4, mode_comparison
dcl_resource_structured t0, 4
dcl_resource_texture2d (float,float,float,float) t1
dcl_resource_texture2d (float,float,float,float) t2
dcl_resource_texture2d (float,float,float,float) t3
dcl_resource_texture2d (float,float,float,float) t4
dcl_resource_texture2darray (float,float,float,float) t5
dcl_resource_texture2d (float,float,float,float) t6
dcl_resource_texture2d (float,float,float,float) t7
dcl_resource_texture2d (float,float,float,float) t8
dcl_resource_texture2d (float,float,float,float) t9
dcl_resource_texture2d (float,float,float,float) t10
dcl_resource_texture2d (float,float,float,float) t11
dcl_resource_texture3d (float,float,float,float) t12
dcl_resource_texture2d (float,float,float,float) t13
dcl_resource_texture2d (float,float,float,float) t14
dcl_resource_texture3d (float,float,float,float) t15
dcl_resource_texture3d (float,float,float,float) t16
dcl_resource_texture3d (float,float,float,float) t17
dcl_resource_texture3d (float,float,float,float) t18
dcl_resource_texture3d (float,float,float,float) t19
dcl_resource_texture3d (float,float,float,float) t20
dcl_resource_texture2d (float,float,float,float) t21
dcl_resource_texture2d (float,float,float,float) t22
dcl_resource_texture2d (float,float,float,float) t23
dcl_resource_texture2d (float,float,float,float) t24
dcl_input_ps_siv linear noperspective v0.xy, position
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 42
ftou r0.xy, v0.xyxx
mov r0.z, l(0)
ld_indexable(texture2d)(float,float,float,float) r1.xyz, r0.xyzz, t22.xyzw
ld_indexable(texture2d)(float,float,float,float) r2.xyz, r0.xyzz, t23.xyzw
mad r2.xy, r2.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
dp2 r1.w, l(1.000000, 1.000000, 0.000000, 0.000000), |r2.xyxx|
add r3.y, -r1.w, l(1.000000)
lt r1.w, r3.y, l(0.000000)
ge r4.xy, r2.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
add r4.zw, -|r2.yyyx|, l(0.000000, 0.000000, 1.000000, 1.000000)
movc r4.xy, r4.xyxx, l(1.000000,1.000000,0,0), l(-1.000000,-1.000000,0,0)
mul r4.xy, r4.xyxx, r4.zwzz
movc r3.xz, r1.wwww, r4.xxyx, r2.xxyx
dp3 r1.w, r3.xyzx, r3.xyzx
rsq r1.w, r1.w
mul r3.xyz, r1.wwww, r3.xyzx
utof r2.xy, r0.xyxx
mul r4.xy, v0.xyxx, cb0[82].zwzz
mad r4.zw, r4.xxxy, l(0.000000, 0.000000, 2.000000, 2.000000), l(0.000000, 0.000000, -1.000000, -1.000000)
add r5.xy, r2.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
mul r5.xy, r5.xyxx, cb0[82].zwzz
sample_l_indexable(texture2d)(float,float,float,float) r1.w, r5.xyxx, t1.yzwx, s0, l(0.000000)
mul r5.xyzw, -r4.wwww, cb0[25].xyzw
mad r5.xyzw, cb0[24].xyzw, r4.zzzz, r5.xyzw
mad r5.xyzw, cb0[26].xyzw, r1.wwww, r5.xyzw
add r5.xyzw, r5.xyzw, cb0[27].xyzw
div r5.xyz, r5.xyzx, r5.wwww
mul r1.w, r5.y, cb0[1].z
mad r1.w, cb0[0].z, r5.x, r1.w
mad r1.w, cb0[2].z, r5.z, r1.w
add r1.w, r1.w, cb0[3].z
eq r2.w, l(0.000000), cb0[86].w
add r6.xyz, -r5.xyzx, cb0[44].xyzx
mov r7.x, cb0[0].z
mov r7.y, cb0[1].z
mov r7.z, cb0[2].z
movc r6.xyz, r2.wwww, r6.xyzx, r7.xyzx
dp3 r2.w, r6.xyzx, r6.xyzx
max r4.z, r2.w, l(0.000000)
rsq r4.z, r4.z
mul r8.xyz, r4.zzzz, r6.xyzx
mul r4.w, r2.w, r4.z
lt r6.w, l(0.000488), cb0[238].x
if_nz r6.w
  sample_b_indexable(texture2d)(float,float,float,float) r9.xy, v1.xyxx, t21.xyzw, s1, cb0[108].x
else
  mov r9.xy, l(1.000000,1.000000,0,0)
endif
min r7.w, r9.y, r9.x
add r1.z, r1.z, l(-0.050000)
mul_sat r1.z, r1.z, l(1.052600)
add r8.w, r9.y, l(-1.000000)
mad r10.x, r1.z, r8.w, l(1.000000)
add r10.y, -r1.z, l(1.000000)
movc r9.yz, r6.wwww, r10.xxyx, l(0,1.000000,1.000000,0)
min r1.z, r2.z, r9.y
add r6.w, -r1.z, r2.z
mad r1.z, r7.w, r6.w, r1.z
add r2.z, -r1.z, r2.z
mad r10.w, r9.x, r2.z, r1.z
ld_indexable(texture2d)(float,float,float,float) r11.xyz, r0.xyzz, t24.xyzw
add r1.z, -r9.z, l(1.000000)
mad r1.z, r7.w, r1.z, r9.z
add r2.z, -r1.z, l(1.000000)
mad r1.z, r9.x, r2.z, r1.z
mul r9.xyz, r1.zzzz, r11.xyzx
mul r12.xyz, r1.xxxx, r9.xyzx
mad r11.xyz, r11.xyzx, r1.zzzz, -r12.xyzx
mad r1.z, -r1.x, l(0.040000), l(0.040000)
mad r9.xyz, r9.xyzx, r1.xxxx, r1.zzzz
dp3 r1.x, r3.xyzx, r8.xyzx
max r12.x, r1.x, l(0.000000)
mul r13.y, r10.w, r10.w
mul r14.x, r12.x, r12.x
mul r14.z, r12.x, r14.x
mul r1.x, r13.y, r13.y
mul r13.z, r13.y, r1.x
mov r12.yzw, l(0,0.036546,9.063200,0.990440)
dp2 r15.x, l(3.327070, 1.000000, 0.000000, 0.000000), r12.xyxx
dp2 r15.y, l(-9.047560, 1.000000, 0.000000, 0.000000), r12.xzxx
mov r13.x, l(1.000000)
dp2 r1.z, r15.xyxx, r13.xyxx
mov r14.yw, l(0,9.044010,0,1.000000)
dp3 r15.x, l(3.596850, -1.367720, 1.000000, 0.000000), r14.xzwx
dp3 r15.y, l(-16.317400, 1.000000, 9.229490, 0.000000), r14.xyzx
mov r16.x, l(5.565890)
mov r16.yz, r14.xxzx
dp3 r15.z, l(1.000000, 19.788601, -20.212299, 0.000000), r16.xyzx
dp3 r2.z, r15.xyzx, r13.xyzx
div r1.z, r1.z, r2.z
dp2 r15.x, l(-1.285140, 1.000000, 0.000000, 0.000000), r12.xwxx
mov r14.x, l(1.296780)
mov r14.y, r12.x
dp2 r15.y, l(1.000000, -0.755907, 0.000000, 0.000000), r14.xyxx
dp2 r2.z, r15.xyxx, r13.xyxx
dp3 r15.x, l(2.923380, 59.418800, 1.000000, 0.000000), r14.yzwy
mov r14.xw, l(20.322500,0,0,121.563004)
dp3 r15.y, l(1.000000, -27.030199, 222.591995, 0.000000), r14.xyzx
dp3 r15.z, l(626.130005, 316.627014, 1.000000, 0.000000), r14.yzwy
dp3 r6.w, r15.xyzx, r13.xyzx
div r2.z, r2.z, r6.w
mad r12.yzw, r9.xxyz, r1.zzzz, r2.zzzz
add r1.z, r1.z, r2.z
ld_indexable(texture2d)(float,float,float,float) r13.x, r0.xyzz, t7.xzyw
lt r0.z, l(0.001000), r13.x
if_nz r0.z
  dp3 r0.z, -r8.xyzx, r3.xyzx
  add r0.z, r0.z, r0.z
  mad r14.xyz, r3.xyzx, -r0.zzzz, -r8.xyzx
  dp3 r0.z, -cb3[0].xyzx, r14.xyzx
  mad r15.xyz, cb3[0].xyzx, r0.zzzz, r14.xyzx
  lt r0.z, r0.z, cb3[4].z
  dp3 r2.z, r15.xyzx, r15.xyzx
  max r2.z, r2.z, l(0.000061)
  rsq r2.z, r2.z
  mul r15.xyz, r2.zzzz, r15.xyzx
  mul r15.xyz, r15.xyzx, cb3[4].yyyy
  mad r15.xyz, -cb3[0].xyzx, cb3[4].zzzz, r15.xyzx
  dp3 r2.z, r15.xyzx, r15.xyzx
  rsq r2.z, r2.z
  mul r15.xyz, r2.zzzz, r15.xyzx
  movc r14.xyz, r0.zzzz, r15.xyzx, r14.xyzx
  mad r15.xyz, r6.xyzx, r4.zzzz, r14.xyzx
  dp3 r0.z, r15.xyzx, r15.xyzx
  max r0.z, r0.z, l(0.000061)
  rsq r0.z, r0.z
  mul r15.xyz, r0.zzzz, r15.xyzx
  dp3_sat r10.y, r14.xyzx, r3.xyzx
  dp3_sat r0.z, r3.xyzx, r15.xyzx
  min r10.z, r12.x, l(1.000000)
  mad r2.z, r0.z, r1.x, -r0.z
  mad r0.z, r2.z, r0.z, l(1.000000)
  dp3_sat r2.z, r8.xyzx, r15.xyzx
  add r2.z, -r2.z, l(1.000000)
  mul r6.w, r2.z, r2.z
  mul r6.w, r6.w, r6.w
  mul r7.w, r2.z, r6.w
  add r8.w, -r10.w, l(1.000000)
  mad r9.w, -r8.w, l(0.383026), l(-0.076195)
  mad r9.w, r8.w, r9.w, l(1.049970)
  mad r8.w, r8.w, r9.w, l(0.409255)
  min r8.w, r8.w, l(0.999000)
  add r9.w, -r8.w, l(1.000000)
  add r14.xyz, -r9.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r14.xyz, r14.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r9.xyzx
  mad r2.z, -r6.w, r2.z, l(1.000000)
  mad r15.xyz, r9.xyzx, r2.zzzz, r7.wwww
  mul r0.z, r0.z, r0.z
  div r0.z, r1.x, r0.z
  mad r16.xy, -r10.zyzz, r1.xxxx, r10.zyzz
  mad r16.xy, r16.xyxx, r10.zyzz, r1.xxxx
  sqrt r16.xy, r16.xyxx
  mul r16.xy, r10.yzyy, r16.xyxx
  add r1.x, r16.y, r16.x
  add r1.x, r1.x, l(0.000100)
  div r1.x, l(0.500000), r1.x
  mul r0.z, r0.z, r1.x
  mul r15.xyz, r0.zzzz, r15.xyzx
  min r15.xyz, r15.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
  mad r16.xyzw, r10.zwyw, l(0.968750, 0.968750, 0.968750, 0.968750), l(0.015625, 0.015625, 0.015625, 0.015625)
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r16.xyxx, t9.yzxw, s1, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r1.x, r16.zwzz, t9.xyzw, s1, l(0.000000)
  mul r0.z, r0.z, r1.x
  mul r0.z, r8.w, r0.z
  div r0.z, r0.z, r9.w
  mul r16.xyz, r14.xyzx, r14.xyzx
  mul r16.xyz, r0.zzzz, r16.xyzx
  mad r14.xyz, -r14.xyzx, r9.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r14.xyz, r16.xyzx, r14.xyzx
  add r14.xyz, r14.xyzx, r15.xyzx
  mul r14.xyz, r14.xyzx, cb3[4].xxxx
  max r14.xyz, r14.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  min r14.xyz, r14.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
  mul r15.xyz, r10.yyyy, r11.xyzx
  mad r14.xyz, r14.xyzx, r10.yyyy, r15.xyzx
  mul r14.xyz, r14.xyzx, cb3[1].xyzx
  mov r13.z, l(0.500000)
  sample_b_indexable(texture2d)(float,float,float,float) r15.xyz, r13.xzxx, t8.xyzw, s1, cb0[108].x
  add r0.z, -r13.x, l(1.000000)
  mad r13.xzw, r14.xxyz, r15.xxyz, -r14.xxyz
  mad r13.xzw, r0.zzzz, r13.xxzw, r14.xxyz
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r4.xyxx, t10.yzxw, s1, l(0.000000)
  min r0.z, r0.z, l(1.000000)
  mul r13.xzw, r0.zzzz, r13.xxzw
else
  mov r13.xzw, l(0,0,0,0)
endif
mul r10.yz, r2.xxyx, l(0.000000, 0.031250, 0.031250, 0.000000)
round_ni r10.yz, r10.yyzy
mad r0.z, r10.z, cb2[1].y, r10.y
mul r0.z, r0.z, l(8.000000)
ftoi r0.z, r0.z
mad r1.x, -cb0[85].y, cb2[2].w, |r1.w|
round_ni r1.x, r1.x
add r2.z, l(-1.000000), cb2[1].w
max r6.w, r1.x, l(0.000000)
min r2.z, r2.z, r6.w
mul r6.w, r2.z, l(8.000000)
ftoi r6.w, r6.w
ge r1.x, r2.z, r1.x
iadd r2.z, r6.w, cb0[110].y
dp3 r6.w, -r8.xyzx, r3.xyzx
add r6.w, r6.w, r6.w
mad r14.xyz, r3.xyzx, -r6.wwww, -r8.xyzx
min r10.x, r12.x, l(1.000000)
add r6.w, -r10.w, l(1.000000)
mad r7.w, -r6.w, l(0.383026), l(-0.076195)
mad r7.w, r6.w, r7.w, l(1.049970)
mad r6.w, r6.w, r7.w, l(0.409255)
min r6.w, r6.w, l(0.999000)
add r7.w, -r6.w, l(1.000000)
add r15.xyz, -r9.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
mad r15.xyz, r15.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r9.xyzx
mad r10.yz, r10.xxwx, l(0.000000, 0.968750, 0.968750, 0.000000), l(0.000000, 0.015625, 0.015625, 0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r8.w, r10.yzyy, t9.yzwx, s1, l(0.000000)
mad r16.xyz, -r15.xyzx, r7.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r15.xyz, r15.xyzx, r15.xyzx
mov r17.w, l(1.000000)
mov r18.y, l(1.000000)
mov r19.z, r10.w
mov r20.xyz, l(0,0,0,0)
mov r9.w, l(1.000000)
mov r10.y, l(0)
loop
  ilt r10.z, l(7), r10.y
  breakc_nz r10.z
  iadd r10.z, r0.z, r10.y
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r10.z, r10.z, l(0), t0.xxxx
  iadd r11.w, r2.z, r10.y
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r11.w, r11.w, l(0), t0.xxxx
  and r10.z, r10.z, r11.w
  and r10.z, r1.x, r10.z
  ishl r11.w, r10.y, l(5)
  mov r21.xyz, l(0,0,0,0)
  mov r14.w, r9.w
  mov r15.w, r10.z
  loop
    breakc_z r15.w
    firstbit_lo r16.w, r15.w
    ishl r18.z, l(1), r16.w
    xor r18.z, r15.w, r18.z
    iadd r16.w, r11.w, r16.w
    bfi r22.xyzw, l(29, 29, 29, 29), l(3, 3, 3, 3), r16.wwww, l(1, 3, 5, 6)
    bfi r18.w, l(29), l(3), r16.w, l(7)
    ftou r19.w, cb3[r22.z + 6].w
    ieq r19.w, r19.w, l(1)
    if_nz r19.w
      add r17.xyz, r5.xyzx, -cb3[r22.x + 6].xyzx
      and r23.xyz, l(0x0000ffff, 0x0000ffff, 0x0000ffff, 0), cb3[r22.z + 6].xzyx
      and r24.xyz, l(0x0000ffff, 0x0000ffff, 0x0000ffff, 0), cb3[r22.w + 6].yxzy
      ushr r25.xyz, cb3[r22.z + 6].xzyx, l(16, 16, 16, 0)
      ushr r26.xyz, cb3[r22.w + 6].yxzy, l(16, 16, 16, 0)
      f16tof32 r23.xyz, r23.xyzx
      f16tof32 r24.xyz, r24.xyzx
      f16tof32 r25.xyz, r25.xyzx
      f16tof32 r26.xyw, r26.yxyz
      mov r27.xz, r23.xxzx
      mov r27.yw, r25.xxxz
      dp4 r19.w, r17.xyzw, r27.xyzw
      mov r25.x, r23.y
      mov r25.z, r24.y
      mov r25.w, r26.x
      dp4 r20.w, r17.xyzw, r25.xyzw
      mov r26.xz, r24.xxzx
      dp4 r17.x, r17.xyzw, r26.xyzw
      max r17.y, |r19.w|, |r20.w|
      max r17.x, |r17.x|, r17.y
      mad r17.y, cb3[r18.w + 6].x, l(0.500000), l(0.500000)
      add r17.x, -r17.y, r17.x
      mad r17.y, -cb3[r18.w + 6].x, l(0.500000), l(0.500000)
      div_sat r17.x, r17.x, r17.y
      add r17.x, -r17.x, l(1.000000)
      mul r17.x, r17.x, r17.x
    else
      mov r17.x, l(1.000000)
    endif
    lt r17.y, l(0.500000), cb3[r22.y + 6].z
    lt r17.z, r17.x, l(0.001000)
    or r17.z, r17.y, r17.z
    if_nz r17.z
      mov r15.w, r18.z
      continue
    endif
    ishl r17.z, r16.w, l(3)
    bfi r16.w, l(29), l(3), r16.w, l(2)
    lt r19.w, cb3[r17.z + 6].w, l(1.500000)
    if_nz r19.w
      mad r19.w, cb3[r16.w + 6].y, l(0.500000), l(0.500000)
      add r23.x, r19.w, -|cb3[r16.w + 6].x|
      add r23.y, -r23.x, cb3[r16.w + 6].y
      add r19.w, -|r23.x|, l(1.000000)
      add r19.w, -|r23.y|, r19.w
      max r19.w, r19.w, l(0.000488)
      ge r20.w, cb3[r16.w + 6].x, l(0.000000)
      movc r23.z, r20.w, r19.w, -r19.w
      dp3 r19.w, r23.xyzx, r23.xyzx
      rsq r19.w, r19.w
      mul r23.xyz, r19.wwww, r23.xyzx
      add r24.xyz, -r5.xyzx, cb3[r22.x + 6].xyzx
      dp3 r19.w, r24.xyzx, r24.xyzx
      rsq r20.w, r19.w
      mul r25.xyz, r20.wwww, r24.xyzx
      ftoi r21.w, cb3[r18.w + 6].w
      mul r26.xyz, r23.xyzx, cb3[r16.w + 6].zzzz
      mad r27.xyz, -r26.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r24.xyzx
      mad r28.xyz, r26.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r24.xyzx
      ftou r22.z, cb3[r17.z + 6].w
      and r22.z, r22.z, l(1)
      ieq r23.w, r22.z, l(0)
      not r23.w, r23.w
      lt r24.w, l(0.000000), cb3[r16.w + 6].z
      and r23.w, r23.w, r24.w
      dp3 r24.w, r27.xyzx, r27.xyzx
      sqrt r24.w, r24.w
      dp3 r25.w, r28.xyzx, r28.xyzx
      sqrt r25.w, r25.w
      dp3 r26.w, r3.xyzx, r27.xyzx
      div r26.w, r26.w, r24.w
      dp3 r27.w, r3.xyzx, r28.xyzx
      div r27.w, r27.w, r25.w
      add r26.w, r26.w, r27.w
      mul_sat r29.x, r26.w, l(0.500000)
      dp3 r26.w, r27.xyzx, r28.xyzx
      mad r24.w, r24.w, r25.w, r26.w
      mad r24.w, r24.w, l(0.500000), l(1.000000)
      div r29.y, l(1.000000, 1.000000, 1.000000, 1.000000), r24.w
      dp3_sat r18.x, r3.xyzx, r25.xyzx
      movc r19.xy, r23.wwww, r29.xyxx, r18.xyxx
      lt r18.x, cb3[r22.w + 6].w, l(0.000000)
      if_nz r18.x
        mul r18.x, cb3[r22.x + 6].w, cb3[r22.x + 6].w
        mul r18.x, r18.x, r19.w
        mad r18.x, -r18.x, r18.x, l(1.000000)
        max r18.x, r18.x, l(0.000000)
        add r19.w, r19.w, l(1.000000)
        div r19.w, l(1.000000, 1.000000, 1.000000, 1.000000), r19.w
        and r24.w, r23.w, l(0x3f800000)
        add r25.w, -r19.w, r19.y
        mad r19.w, r24.w, r25.w, r19.w
        mul r18.x, r18.x, r18.x
        mul r18.x, r18.x, r19.w
      else
        mul r28.xyz, r24.xyzx, cb3[r22.x + 6].wwww
        dp3 r19.w, r28.xyzx, r28.xyzx
        min r19.w, r19.w, l(1.000000)
        add r19.w, -r19.w, l(1.000000)
        log r19.w, r19.w
        mul r19.w, r19.w, cb3[r22.w + 6].w
        exp r19.w, r19.w
        mul r18.x, r19.w, r19.y
      endif
      dp3 r19.y, r25.xyzx, -r23.xyzx
      add r19.y, r19.y, -cb3[r16.w + 6].z
      mul_sat r19.y, r19.y, cb3[r16.w + 6].w
      mul r19.y, r19.y, r19.y
      movc r19.y, r22.z, l(1.000000), r19.y
      mul r18.x, r18.x, r19.y
      not r19.y, r23.w
      ige r19.w, r21.w, l(0)
      and r19.y, r19.w, r19.y
      if_nz r19.y
        if_z r22.z
          ishl r19.y, r21.w, l(2)
          mul r23.xyz, r5.yyyy, cb5[r19.y + 33].xywx
          mad r23.xyz, cb5[r19.y + 32].xywx, r5.xxxx, r23.xyzx
          mad r23.xyz, cb5[r19.y + 34].xywx, r5.zzzz, r23.xyzx
          add r23.xyz, r23.xyzx, cb5[r19.y + 35].xywx
          div_sat r19.yw, r23.xxxy, r23.zzzz
          mad r19.yw, r19.yyyw, cb5[r21.w + 0].zzzw, cb5[r21.w + 0].xxxy
        else
          ishl r23.x, r21.w, l(2)
          dp3 r28.x, -r24.xyzx, cb5[r23.x + 32].xyzx
          dp3 r28.y, -r24.xyzx, cb5[r23.x + 33].xyzx
          dp3 r28.z, -r24.xyzx, cb5[r23.x + 34].xyzx
          lt r23.x, |r28.x|, |r28.y|
          and r23.x, r23.x, l(1)
          dp2 r23.y, |r28.xyxx|, icb[r23.x + 0].xyxx
          lt r23.y, r23.y, |r28.z|
          movc r23.x, r23.y, l(2), r23.x
          dp3 r23.y, r28.xyzx, icb[r23.x + 0].xyzx
          lt r23.y, r23.y, l(0.000000)
          bfi r23.x, l(31), l(1), r23.x, r23.y
          ushr r23.y, r23.x, l(1)
          dp3 r23.y, r28.xyzx, icb[r23.y + 0].xyzx
          div r23.z, l(0.000244), cb5[r21.w + 0].w
          add r23.z, -r23.z, l(0.500000)
          utof r24.x, r23.x
          ult r24.y, r23.x, l(2)
          and r24.y, r24.y, l(2)
          dp2 r24.y, r28.xzxx, icb[r24.y + 0].xzxx
          mul r24.y, r24.y, icb[r23.x + 4].z
          div r24.y, r24.y, |r23.y|
          mad r24.x, r24.y, r23.z, r24.x
          add r24.x, r24.x, l(0.500000)
          mul_sat r24.x, r24.x, l(0.166667)
          iadd r24.z, l(-1), icb[r23.x + 4].y
          dp2 r24.z, r28.yzyy, icb[r24.z + 0].xyxx
          mul r23.x, r24.z, icb[r23.x + 4].w
          div r23.x, r23.x, |r23.y|
          mad_sat r24.y, -r23.x, r23.z, l(0.500000)
          mad r19.yw, r24.xxxy, cb5[r21.w + 0].zzzw, cb5[r21.w + 0].xxxy
        endif
        sample_l_indexable(texture2d)(float,float,float,float) r19.y, r19.ywyy, t11.yxzw, s1, l(0.000000)
        mul r18.x, r18.x, r19.y
      endif
      lt r19.y, l(0.000000), r18.x
      if_nz r19.y
        if_z r22.z
          ftoi r19.w, cb3[r22.y + 6].x
        else
          add r23.xyz, r5.xyzx, -cb3[r22.x + 6].xyzx
          lt r24.xyz, |r23.yzzy|, |r23.xxyx|
          and r21.w, r24.y, r24.x
          lt r23.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r23.xyzx
          ushr r22.z, cb3[r16.w + 6].w, l(24)
          ubfe r24.xy, l(8, 8, 0, 0), l(16, 8, 0, 0), cb3[r16.w + 6].wwww
          movc r22.z, r23.x, r22.z, r24.x
          and r23.x, l(255), cb3[r16.w + 6].w
          movc r23.x, r23.y, r24.y, r23.x
          ubfe r23.y, l(8), l(8), cb3[r22.y + 6].x
          and r24.x, l(255), cb3[r22.y + 6].x
          movc r23.y, r23.z, r23.y, r24.x
          movc r23.x, r24.z, r23.x, r23.y
          movc r21.w, r21.w, r22.z, r23.x
          ilt r22.z, r21.w, l(80)
          movc r19.w, r22.z, r21.w, l(-1)
        endif
        ishl r21.w, r19.w, l(2)
        mad r23.xyz, r25.xyzx, cb4[r19.w + 288].xxxx, r5.xyzx
        mul r22.z, l(5.000000), cb4[r19.w + 288].y
        mad r23.xyz, r3.xyzx, r22.zzzz, r23.xyzx
        mul r24.xyzw, r23.yyyy, cb4[r21.w + 65].xyzw
        mad r24.xyzw, cb4[r21.w + 64].xyzw, r23.xxxx, r24.xyzw
        mad r24.xyzw, cb4[r21.w + 66].xyzw, r23.zzzz, r24.xyzw
        add r24.xyzw, r24.xyzw, cb4[r21.w + 67].xyzw
        div r23.xyz, r24.xyzx, r24.wwww
        ge r24.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r23.xyzx
        ge r28.xyz, r23.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
        add r29.xy, -cb4[r19.w + 344].xyxx, cb4[r19.w + 344].zwzz
        mad r23.xy, r23.xyxx, r29.xyxx, cb4[r19.w + 344].xyxx
        mad r29.xy, r23.xyxx, cb4[400].zwzz, l(0.500000, 0.500000, 0.000000, 0.000000)
        round_ni r29.xy, r29.xyxx
        mad r23.xy, r23.xyxx, cb4[400].zwzz, -r29.xyxx
        add r30.xyzw, r23.xxyy, l(0.500000, 1.000000, 0.500000, 1.000000)
        mul r31.xyzw, r30.xxzz, r30.xxzz
        add r29.zw, -r23.xxxy, l(0.000000, 0.000000, 1.000000, 1.000000)
        min r30.xz, r23.xxyx, l(0.000000, 0.000000, 0.000000, 0.000000)
        max r32.xy, r23.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
        mul r33.xy, r29.zwzz, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r32.xy, -r32.xyxx, r32.xyxx, r30.ywyy
        add r32.xy, r32.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
        mul r32.xy, r32.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r31.xz, r31.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
        mad r23.xy, r31.ywyy, l(0.500000, 0.500000, 0.000000, 0.000000), -r23.xyxx
        mul r34.xy, r23.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r23.xy, -r30.xzxx, r30.xzxx, r29.zwzz
        add r23.xy, r23.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
        mul r35.xy, r23.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r23.xy, r30.ywyy, l(0.160000, 0.160000, 0.000000, 0.000000)
        mov r34.z, r35.x
        mov r34.w, r23.x
        mov r33.z, r32.x
        mov r33.w, r31.x
        add r30.xyzw, r33.zwxz, r34.zwxz
        mov r35.z, r34.y
        mov r35.w, r23.y
        mov r32.z, r33.y
        mov r32.w, r31.z
        add r31.xyz, r32.zywz, r35.zywz
        div r33.xyz, r33.xzwx, r30.zwyz
        add r33.xyz, r33.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r33.xyz, r33.yxzy, cb4[400].xxxx
        div r32.xyz, r32.zywz, r31.xyzx
        add r32.xyz, r32.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r32.xyz, r32.xyzx, cb4[400].yyyy
        mov r33.w, r32.x
        mad r34.xyzw, r29.xyxy, cb4[400].xyxy, r33.ywxw
        mad r23.xy, r29.xyxx, cb4[400].xyxx, r33.zwzz
        mov r32.w, r33.y
        mov r33.yw, r32.yyyz
        mad r35.xyzw, r29.xyxy, cb4[400].xyxy, r33.xyzy
        mad r32.xyzw, r29.xyxy, cb4[400].xyxy, r32.wywz
        mad r29.xyzw, r29.xyxy, cb4[400].xyxy, r33.xwzw
        mul r33.xyzw, r30.zwyz, r31.xxxy
        sample_c_lz_indexable(texture2d)(float,float,float,float) r21.w, r34.xyxx, t6.xxxx, s4, r23.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r34.zwzz, t6.xxxx, s4, r23.z
        mul r22.z, r22.z, r33.y
        mad r21.w, r33.x, r21.w, r22.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r23.xyxx, t6.xxxx, s4, r23.z
        mad r21.w, r33.z, r22.z, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r32.xyxx, t6.xxxx, s4, r23.z
        mad r21.w, r33.w, r22.z, r21.w
        mul r33.xyzw, r30.xyzw, r31.yyzz
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r35.xyxx, t6.xxxx, s4, r23.z
        mad r21.w, r33.x, r22.z, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r35.zwzz, t6.xxxx, s4, r23.z
        mad r21.w, r33.y, r22.z, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r32.zwzz, t6.xxxx, s4, r23.z
        mad r21.w, r33.z, r22.z, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.z, r29.xyxx, t6.xxxx, s4, r23.z
        mad r21.w, r33.w, r22.z, r21.w
        ige r22.z, r19.w, l(0)
        or r24.xyz, r24.xyzx, r28.xyzx
        or r23.x, r24.y, r24.x
        or r23.x, r24.z, r23.x
        and r23.y, r23.z, l(0x7fffffff)
        ult r23.y, l(0x7f800000), r23.y
        or r23.x, r23.y, r23.x
        mul r23.y, r30.y, r31.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r23.z, r29.zwzz, t6.xxxx, s4, r23.z
        mad r21.w, r23.y, r23.z, r21.w
        add r21.w, r21.w, l(-1.000000)
        mad r19.w, cb4[r19.w + 288].w, r21.w, l(1.000000)
        movc r19.w, r23.x, l(1.000000), r19.w
        movc r19.w, r22.z, r19.w, l(1.000000)
      else
        mov r19.w, l(1.000000)
      endif
      if_nz r23.w
        dp3 r21.w, r14.xyzx, r26.xyzx
        mul_sat r22.z, r20.w, cb3[r16.w + 6].z
        mad r22.z, r22.z, l(0.500000), r13.y
        min r22.z, r22.z, l(1.000000)
        div r22.z, r13.y, r22.z
        mad r23.xyz, r14.xyzx, r21.wwww, -r26.xyzx
        dp3 r23.x, r27.xyzx, r23.xyzx
        mul r21.w, r21.w, r21.w
        mad r21.w, cb3[r16.w + 6].z, cb3[r16.w + 6].z, -r21.w
        div_sat r21.w, r23.x, r21.w
        mad r23.xyz, r26.xyzx, r21.wwww, r27.xyzx
        dp3 r21.w, r23.xyzx, r23.xyzx
        rsq r21.w, r21.w
        mul r25.xyz, r21.wwww, r23.xyzx
      else
        mov r22.z, l(1.000000)
      endif
      if_nz r19.y
        mul_sat r19.y, r20.w, cb3[r18.w + 6].y
        mad r23.xyz, r6.xyzx, r4.zzzz, r25.xyzx
        dp3 r20.w, r23.xyzx, r23.xyzx
        max r20.w, r20.w, l(0.000061)
        rsq r20.w, r20.w
        mul r23.xyz, r20.wwww, r23.xyzx
        dp3_sat r20.w, r3.xyzx, r23.xyzx
        dp3_sat r21.w, r8.xyzx, r23.xyzx
        lt r23.x, l(0.000000), r19.y
        mul r19.y, r19.y, r19.y
        mad r23.y, r21.w, l(3.600000), l(0.400000)
        div r19.y, r19.y, r23.y
        mad r19.y, r10.w, r10.w, r19.y
        min r19.y, r19.y, l(1.000000)
        movc r19.y, r23.x, r19.y, r13.y
        mul r19.y, r19.y, r19.y
        mad r23.x, r20.w, r19.y, -r20.w
        mad r20.w, r23.x, r20.w, l(1.000000)
        add r21.w, -r21.w, l(1.000000)
        mul r23.x, r21.w, r21.w
        mul r23.x, r23.x, r23.x
        mul r23.y, r21.w, r23.x
        mad r21.w, -r23.x, r21.w, l(1.000000)
        mad r23.xyz, r9.xyzx, r21.wwww, r23.yyyy
        mul r20.w, r20.w, r20.w
        div r20.w, r19.y, r20.w
        mul r20.w, r22.z, r20.w
        mad r21.w, -r10.x, r19.y, r10.x
        mad r21.w, r21.w, r10.x, r19.y
        sqrt r21.w, r21.w
        mad r22.z, -r19.x, r19.y, r19.x
        mad r19.y, r22.z, r19.x, r19.y
        sqrt r19.y, r19.y
        mul r19.y, r10.x, r19.y
        mad r19.y, r19.x, r21.w, r19.y
        add r19.y, r19.y, l(0.000100)
        div r19.y, l(0.500000), r19.y
        mul r19.y, r19.y, r20.w
        mul r23.xyz, r19.yyyy, r23.xyzx
        min r23.xyz, r23.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
        mad r24.xy, r19.xzxx, l(0.968750, 0.968750, 0.000000, 0.000000), l(0.015625, 0.015625, 0.000000, 0.000000)
        sample_l_indexable(texture2d)(float,float,float,float) r19.y, r24.xyxx, t9.yxzw, s1, l(0.000000)
        mul r19.y, r8.w, r19.y
        mul r19.y, r6.w, r19.y
        div r19.y, r19.y, r7.w
        mul r24.xyz, r15.xyzx, r19.yyyy
        div r24.xyz, r24.xyzx, r16.xyzx
        add r23.xyz, r23.xyzx, r24.xyzx
        mul r23.xyz, r23.xyzx, cb3[r18.w + 6].zzzz
        max r23.xyz, r23.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
        min r23.xyz, r23.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
        mul r24.xyz, r11.xyzx, r19.xxxx
        mad r23.xyz, r23.xyzx, r19.xxxx, r24.xyzx
        mul r24.xyz, r18.xxxx, cb3[r17.z + 6].xyzx
        mul r19.xyw, r19.wwww, r24.xyxz
        mul r19.xyw, r17.xxxx, r19.xyxw
        mul r19.xyw, r19.xyxw, r23.xyxz
      else
        mov r19.xyw, l(0,0,0,0)
      endif
    else
      if_z r17.y
        mad r17.x, cb3[r16.w + 6].y, l(0.500000), l(0.500000)
        add r23.x, r17.x, -|cb3[r16.w + 6].x|
        add r23.y, -r23.x, cb3[r16.w + 6].y
        add r17.x, -|r23.x|, l(1.000000)
        add r17.x, -|r23.y|, r17.x
        max r17.x, r17.x, l(0.000488)
        ge r17.y, cb3[r16.w + 6].x, l(0.000000)
        movc r23.z, r17.y, r17.x, -r17.x
        dp3 r17.x, r23.xyzx, r23.xyzx
        rsq r17.x, r17.x
        mul r23.xyz, r17.xxxx, r23.xyzx
        add r24.xyz, -r5.xyzx, cb3[r22.x + 6].xyzx
        dp3 r17.x, r24.xyzx, r24.xyzx
        rsq r17.y, r17.x
        mul r25.xyz, r17.yyyy, r24.xyzx
        ftoi r17.y, cb3[r18.w + 6].w
        mul r26.xyz, r23.xyzx, cb3[r16.w + 6].zzzz
        mad r27.xyz, -r26.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r24.xyzx
        mad r26.xyz, r26.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r24.xyzx
        ftou r17.z, cb3[r17.z + 6].w
        and r17.z, r17.z, l(1)
        ieq r18.x, r17.z, l(0)
        not r18.x, r18.x
        lt r18.w, l(0.000000), cb3[r16.w + 6].z
        and r18.x, r18.w, r18.x
        dp3 r18.w, r27.xyzx, r27.xyzx
        sqrt r18.w, r18.w
        dp3 r20.w, r26.xyzx, r26.xyzx
        sqrt r20.w, r20.w
        dp3 r21.w, r27.xyzx, r26.xyzx
        mad r18.w, r18.w, r20.w, r21.w
        mad r18.w, r18.w, l(0.500000), l(1.000000)
        div r18.w, l(1.000000, 1.000000, 1.000000, 1.000000), r18.w
        movc r18.w, r18.x, r18.w, l(1.000000)
        lt r20.w, cb3[r22.w + 6].w, l(0.000000)
        if_nz r20.w
          mul r20.w, cb3[r22.x + 6].w, cb3[r22.x + 6].w
          mul r20.w, r17.x, r20.w
          mad r20.w, -r20.w, r20.w, l(1.000000)
          max r20.w, r20.w, l(0.000000)
          add r17.x, r17.x, l(1.000000)
          div r17.x, l(1.000000, 1.000000, 1.000000, 1.000000), r17.x
          and r21.w, r18.x, l(0x3f800000)
          add r22.z, -r17.x, r18.w
          mad r17.x, r21.w, r22.z, r17.x
          mul r20.w, r20.w, r20.w
          mul r17.x, r17.x, r20.w
        else
          mul r26.xyz, r24.xyzx, cb3[r22.x + 6].wwww
          dp3 r20.w, r26.xyzx, r26.xyzx
          min r20.w, r20.w, l(1.000000)
          add r20.w, -r20.w, l(1.000000)
          log r20.w, r20.w
          mul r20.w, r20.w, cb3[r22.w + 6].w
          exp r20.w, r20.w
          mul r17.x, r18.w, r20.w
        endif
        dp3 r18.w, r25.xyzx, -r23.xyzx
        add r18.w, r18.w, -cb3[r16.w + 6].z
        mul_sat r18.w, r18.w, cb3[r16.w + 6].w
        mul r18.w, r18.w, r18.w
        movc r18.w, r17.z, l(1.000000), r18.w
        mul r17.x, r17.x, r18.w
        not r18.x, r18.x
        ige r18.w, r17.y, l(0)
        and r18.x, r18.w, r18.x
        if_nz r18.x
          if_z r17.z
            ishl r18.x, r17.y, l(2)
            mul r23.xyz, r5.yyyy, cb5[r18.x + 33].xywx
            mad r23.xyz, cb5[r18.x + 32].xywx, r5.xxxx, r23.xyzx
            mad r23.xyz, cb5[r18.x + 34].xywx, r5.zzzz, r23.xyzx
            add r23.xyz, r23.xyzx, cb5[r18.x + 35].xywx
            div_sat r18.xw, r23.xxxy, r23.zzzz
            mad r18.xw, r18.xxxw, cb5[r17.y + 0].zzzw, cb5[r17.y + 0].xxxy
          else
            ishl r20.w, r17.y, l(2)
            dp3 r23.x, -r24.xyzx, cb5[r20.w + 32].xyzx
            dp3 r23.y, -r24.xyzx, cb5[r20.w + 33].xyzx
            dp3 r23.z, -r24.xyzx, cb5[r20.w + 34].xyzx
            lt r20.w, |r23.x|, |r23.y|
            and r20.w, r20.w, l(1)
            dp2 r21.w, |r23.xyxx|, icb[r20.w + 0].xyxx
            lt r21.w, r21.w, |r23.z|
            movc r20.w, r21.w, l(2), r20.w
            dp3 r21.w, r23.xyzx, icb[r20.w + 0].xyzx
            lt r21.w, r21.w, l(0.000000)
            bfi r20.w, l(31), l(1), r20.w, r21.w
            ushr r21.w, r20.w, l(1)
            dp3 r21.w, r23.xyzx, icb[r21.w + 0].xyzx
            div r22.z, l(0.000244), cb5[r17.y + 0].w
            add r22.z, -r22.z, l(0.500000)
            utof r22.w, r20.w
            ult r23.w, r20.w, l(2)
            and r23.w, r23.w, l(2)
            dp2 r23.x, r23.xzxx, icb[r23.w + 0].xzxx
            mul r23.x, r23.x, icb[r20.w + 4].z
            div r23.x, r23.x, |r21.w|
            mad r22.w, r23.x, r22.z, r22.w
            add r22.w, r22.w, l(0.500000)
            mul_sat r24.x, r22.w, l(0.166667)
            iadd r22.w, l(-1), icb[r20.w + 4].y
            dp2 r22.w, r23.yzyy, icb[r22.w + 0].xyxx
            mul r20.w, r22.w, icb[r20.w + 4].w
            div r20.w, r20.w, |r21.w|
            mad_sat r24.y, -r20.w, r22.z, l(0.500000)
            mad r18.xw, r24.xxxy, cb5[r17.y + 0].zzzw, cb5[r17.y + 0].xxxy
          endif
          sample_l_indexable(texture2d)(float,float,float,float) r17.y, r18.xwxx, t11.yxzw, s1, l(0.000000)
          mul r17.x, r17.y, r17.x
        endif
        lt r17.x, l(0.000000), r17.x
        if_nz r17.x
          if_z r17.z
            ftoi r17.x, cb3[r22.y + 6].x
          else
            add r22.xzw, r5.xxyz, -cb3[r22.x + 6].xxyz
            lt r23.xyz, |r22.zwwz|, |r22.xxzx|
            and r17.y, r23.y, r23.x
            lt r22.xzw, l(0.000000, 0.000000, 0.000000, 0.000000), r22.xxzw
            ushr r17.z, cb3[r16.w + 6].w, l(24)
            ubfe r18.xw, l(8, 0, 0, 8), l(16, 0, 0, 8), cb3[r16.w + 6].wwww
            movc r17.z, r22.x, r17.z, r18.x
            and r16.w, l(255), cb3[r16.w + 6].w
            movc r16.w, r22.z, r18.w, r16.w
            ubfe r18.x, l(8), l(8), cb3[r22.y + 6].x
            and r18.w, l(255), cb3[r22.y + 6].x
            movc r18.x, r22.w, r18.x, r18.w
            movc r16.w, r23.z, r16.w, r18.x
            movc r16.w, r17.y, r17.z, r16.w
            ilt r17.y, r16.w, l(80)
            movc r17.x, r17.y, r16.w, l(-1)
          endif
          ishl r16.w, r17.x, l(2)
          mad r22.xyz, r25.xyzx, cb4[r17.x + 288].xxxx, r5.xyzx
          mul r17.y, l(5.000000), cb4[r17.x + 288].y
          mad r22.xyz, r3.xyzx, r17.yyyy, r22.xyzx
          mul r23.xyzw, r22.yyyy, cb4[r16.w + 65].xyzw
          mad r23.xyzw, cb4[r16.w + 64].xyzw, r22.xxxx, r23.xyzw
          mad r22.xyzw, cb4[r16.w + 66].xyzw, r22.zzzz, r23.xyzw
          add r22.xyzw, r22.xyzw, cb4[r16.w + 67].xyzw
          div r22.xyz, r22.xyzx, r22.wwww
          ge r23.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r22.xyzx
          ge r24.xyz, r22.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
          add r17.yz, -cb4[r17.x + 344].xxyx, cb4[r17.x + 344].zzwz
          mad r17.yz, r22.xxyx, r17.yyzy, cb4[r17.x + 344].xxyx
          mad r18.xw, r17.yyyz, cb4[400].zzzw, l(0.500000, 0.000000, 0.000000, 0.500000)
          round_ni r18.xw, r18.xxxw
          mad r17.yz, r17.yyzy, cb4[400].zzwz, -r18.xxwx
          add r25.xyzw, r17.yyzz, l(0.500000, 1.000000, 0.500000, 1.000000)
          mul r26.xyzw, r25.xxzz, r25.xxzz
          add r22.xy, -r17.yzyy, l(1.000000, 1.000000, 0.000000, 0.000000)
          min r25.xz, r17.yyzy, l(0.000000, 0.000000, 0.000000, 0.000000)
          max r27.xy, r17.yzyy, l(0.000000, 0.000000, 0.000000, 0.000000)
          mul r28.xy, r22.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r27.xy, -r27.xyxx, r27.xyxx, r25.ywyy
          add r27.xy, r27.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
          mul r27.xy, r27.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r26.xz, r26.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
          mad r17.yz, r26.yywy, l(0.000000, 0.500000, 0.500000, 0.000000), -r17.yyzy
          mul r29.xy, r17.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r17.yz, -r25.xxzx, r25.xxzx, r22.xxyx
          add r17.yz, r17.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
          mul r30.xy, r17.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r17.yz, r25.yywy, l(0.000000, 0.160000, 0.160000, 0.000000)
          mov r29.z, r30.x
          mov r29.w, r17.y
          mov r28.z, r27.x
          mov r28.w, r26.x
          add r25.xyzw, r28.zwxz, r29.zwxz
          mov r30.z, r29.y
          mov r30.w, r17.z
          mov r27.z, r28.y
          mov r27.w, r26.z
          add r22.xyw, r27.zyzw, r30.zyzw
          div r26.xyz, r28.xzwx, r25.zwyz
          add r26.xyz, r26.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r26.xyz, r26.yxzy, cb4[400].xxxx
          div r27.xyz, r27.zywz, r22.xywx
          add r27.xyz, r27.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r27.xyz, r27.xyzx, cb4[400].yyyy
          mov r26.w, r27.x
          mad r28.xyzw, r18.xwxw, cb4[400].xyxy, r26.ywxw
          mad r17.yz, r18.xxwx, cb4[400].xxyx, r26.zzwz
          mov r27.w, r26.y
          mov r26.yw, r27.yyyz
          mad r29.xyzw, r18.xwxw, cb4[400].xyxy, r26.xyzy
          mad r27.xyzw, r18.xwxw, cb4[400].xyxy, r27.wywz
          mad r26.xyzw, r18.xwxw, cb4[400].xyxy, r26.xwzw
          mul r30.xyzw, r22.xxxy, r25.zwyz
          sample_c_lz_indexable(texture2d)(float,float,float,float) r16.w, r28.xyxx, t6.xxxx, s4, r22.z
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.x, r28.zwzz, t6.xxxx, s4, r22.z
          mul r18.x, r18.x, r30.y
          mad r16.w, r30.x, r16.w, r18.x
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r17.yzyy, t6.xxxx, s4, r22.z
          mad r16.w, r30.z, r17.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r27.xyxx, t6.xxxx, s4, r22.z
          mad r16.w, r30.w, r17.y, r16.w
          mul r28.xyzw, r22.yyww, r25.xyzw
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r29.xyxx, t6.xxxx, s4, r22.z
          mad r16.w, r28.x, r17.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r29.zwzz, t6.xxxx, s4, r22.z
          mad r16.w, r28.y, r17.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r27.zwzz, t6.xxxx, s4, r22.z
          mad r16.w, r28.z, r17.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r26.xyxx, t6.xxxx, s4, r22.z
          mad r16.w, r28.w, r17.y, r16.w
          ige r17.y, r17.x, l(0)
          or r23.xyz, r23.xyzx, r24.xyzx
          or r17.z, r23.y, r23.x
          or r17.z, r23.z, r17.z
          and r18.x, r22.z, l(0x7fffffff)
          ult r18.x, l(0x7f800000), r18.x
          or r17.z, r17.z, r18.x
          mul r18.x, r22.w, r25.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.w, r26.zwzz, t6.xxxx, s4, r22.z
          mad r16.w, r18.x, r18.w, r16.w
          add r16.w, r16.w, l(-1.000000)
          mad r16.w, cb4[r17.x + 288].w, r16.w, l(1.000000)
          movc r16.w, r17.z, l(1.000000), r16.w
          movc r16.w, r17.y, r16.w, l(1.000000)
        else
          mov r16.w, l(1.000000)
        endif
      else
        mov r16.w, l(1.000000)
      endif
      mul r14.w, r14.w, r16.w
      mov r19.xyw, l(0,0,0,0)
    endif
    add r21.xyz, r19.xywx, r21.xyzx
    mov r15.w, r18.z
  endloop
  mov r9.w, r14.w
  add r20.xyz, r20.xyzx, r21.xyzx
  iadd r10.y, r10.y, l(1)
endloop
mad r6.xyz, r20.xyzx, r9.wwww, r13.xzwx
ne r10.xy, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[112].xyxx
if_nz r10.x
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t4.yzxw, s0, cb0[108].x
  min r0.z, r1.y, r0.z
  add r1.x, r0.z, r12.x
  mad r2.z, r10.w, l(-16.000000), l(-1.000000)
  exp r2.z, r2.z
  log r1.x, |r1.x|
  mul r1.x, r1.x, r2.z
  exp r1.x, r1.x
  add r1.x, r0.z, r1.x
  add r1.x, r1.x, l(-1.000000)
  mov_sat r13.xyz, r1.xxxx
  mad r15.xyz, r11.xyzx, l(2.040400, 2.040400, 2.040400, 0.000000), l(-0.332400, -0.332400, -0.332400, 0.000000)
  mul r15.xyz, r0.zzzz, r15.xyzx
  mad r15.xyz, r11.xyzx, l(-4.795100, -4.795100, -4.795100, 0.000000), r15.xyzx
  add r15.xyz, r15.xyzx, l(0.641700, 0.641700, 0.641700, 0.000000)
  mul r15.xyz, r0.zzzz, r15.xyzx
  mad r15.xyz, r11.xyzx, l(2.755200, 2.755200, 2.755200, 0.000000), r15.xyzx
  add r15.xyz, r15.xyzx, l(0.690300, 0.690300, 0.690300, 0.000000)
  mul r15.xyz, r0.zzzz, r15.xyzx
  max r15.xyz, r0.zzzz, r15.xyzx
else
  mov r13.xyz, r1.yyyy
  mov r15.xyz, r1.yyyy
endif
mad r16.xyz, r3.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r5.xyzx
round_z r0.z, cb0[216].x
mad r1.xy, r0.zzzz, l(2.083000, 4.867000, 0.000000, 0.000000), r2.xyxx
dp2 r0.z, r1.xyxx, l(0.067111, 0.005837, 0.000000, 0.000000)
frc r0.z, r0.z
mul r0.z, r0.z, l(52.982918)
frc r0.z, r0.z
mad r0.z, r0.z, l(2.000000), l(-1.000000)
mad r16.xyz, r0.zzzz, l(0.200000, 0.200000, 0.200000, 0.000000), r16.xyzx
mad r17.xyz, cb0[6].xzyx, -cb0[216].wwww, cb0[214].xzyx
add r17.xyz, r16.xzyx, -r17.xyzx
max r0.z, |r17.y|, |r17.x|
add r0.z, r0.z, l(-464.000000)
mul_sat r0.z, r0.z, l(0.031250)
add r1.x, |r17.z|, l(-208.000000)
mul_sat r1.x, r1.x, l(0.031250)
max r0.z, r0.z, r1.x
ne r1.x, l(0.000000), cb0[214].w
lt r1.y, r0.z, l(1.000000)
and r1.x, r1.y, r1.x
if_nz r1.x
  mad r17.xyz, cb0[6].xzyx, -cb0[216].yyyy, cb0[214].xzyx
  add r17.xyz, r16.xzyx, -r17.xyzx
  max r1.x, |r17.y|, |r17.x|
  add r1.x, r1.x, l(-29.000000)
  add r1.y, |r17.z|, l(-13.000000)
  mul_sat r1.xy, r1.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  max r1.x, r1.y, r1.x
  lt r1.y, r1.x, l(1.000000)
  if_nz r1.y
    mad r17.xyz, r16.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r18.xyz, r17.xyzx, cb0[215].xyzx
    round_ni r18.xyz, r18.xyzx
    mad r17.xyz, r17.xyzx, cb0[215].xyzx, -r18.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyw, r17.xyzx, t15.yzwx, s2, l(0.000000)
    add r1.y, -r1.x, l(1.000000)
    mul r2.z, l(0.500000), cb0[215].y
    mad r6.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r2.z, r2.z, r17.y
    min r2.z, r6.w, r2.z
    mul r17.w, r2.z, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyzw, r17.xwzx, t16.xyzw, s1, l(0.000000)
    mad r2.z, r19.w, r1.y, r0.z
    add r20.xyz, r17.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyz, r20.xyzx, t16.xyzw, s1, l(0.000000)
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r18.yyyy, r20.xyzx
    mov r20.w, r18.y
    mul r20.xyzw, r1.yyyy, r20.xyzw
    add r17.xyz, r17.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r17.xyz, r17.xyzx, t16.xyzw, s1, l(0.000000)
    mad r17.xyz, r17.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r17.xyz, r18.xxxx, r17.xyzx
    mov r17.w, r18.x
    mul r17.xyzw, r1.yyyy, r17.xyzw
    mad r19.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r18.xyz, r18.wwww, r19.xyzx
    mul r18.xyzw, r1.yyyy, r18.xyzw
  else
    mov r20.xyzw, l(0,0,0,0)
    mov r17.xyzw, l(0,0,0,0)
    mov r18.xyzw, l(0,0,0,0)
    mov r2.z, r0.z
  endif
  mad r19.xyz, cb0[6].xzyx, -cb0[216].zzzz, cb0[214].xzyx
  add r19.xyz, r16.xzyx, -r19.xyzx
  max r1.y, |r19.y|, |r19.x|
  add r1.y, r1.y, l(-116.000000)
  mul_sat r1.y, r1.y, l(0.125000)
  add r6.w, |r19.z|, l(-52.000000)
  mul_sat r6.w, r6.w, l(0.125000)
  max r1.y, r1.y, r6.w
  lt r6.w, r1.y, l(1.000000)
  if_nz r6.w
    mad r19.xyz, r16.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r21.xyz, r19.xyzx, cb0[215].xyzx
    round_ni r21.xyz, r21.xyzx
    mad r19.xyz, r19.xyzx, cb0[215].xyzx, -r21.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyw, r19.xyzx, t17.yzwx, s2, l(0.000000)
    add r6.w, -r1.y, l(1.000000)
    mul r1.x, r1.x, r6.w
    mul r6.w, l(0.500000), cb0[215].y
    mad r7.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r6.w, r6.w, r19.y
    min r6.w, r7.w, r6.w
    mul r19.w, r6.w, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyzw, r19.xwzx, t18.xyzw, s1, l(0.000000)
    mad r2.z, r22.w, r1.x, r2.z
    add r23.xyz, r19.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r23.xyz, r23.xyzx, t18.xyzw, s1, l(0.000000)
    mad r23.xyz, r23.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r23.xyz, r21.yyyy, r23.xyzx
    mov r23.w, r21.y
    mad r20.xyzw, r23.xyzw, r1.xxxx, r20.xyzw
    add r19.xyz, r19.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyz, r19.xyzx, t18.xyzw, s1, l(0.000000)
    mad r19.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r19.xyz, r21.xxxx, r19.xyzx
    mov r19.w, r21.x
    mad r17.xyzw, r19.xyzw, r1.xxxx, r17.xyzw
    mad r19.xyz, r22.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r21.wwww, r19.xyzx
    mad r18.xyzw, r21.xyzw, r1.xxxx, r18.xyzw
  endif
  lt r1.x, l(0.000000), r1.y
  if_nz r1.x
    mad r16.xyz, r16.xyzx, l(0.125000, 0.125000, 0.125000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r19.xyz, r16.xyzx, cb0[215].xyzx
    mul r21.xyz, l(0.500000, 0.500000, 0.500000, 0.000000), cb0[215].xyzx
    round_ni r19.xyz, r19.xyzx
    mad r16.xyz, r16.xyzx, cb0[215].xyzx, -r19.xyzx
    mad r19.xyz, -cb0[215].xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
    max r16.xyz, r21.xyzx, r16.xyzx
    min r16.xyz, r19.xyzx, r16.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyw, r16.xyzx, t19.yzwx, s2, l(0.000000)
    add r1.x, -r0.z, l(1.000000)
    mul r1.x, r1.x, r1.y
    max r1.y, r21.y, r16.y
    min r1.y, r19.y, r1.y
    mul r16.w, r1.y, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyzw, r16.xwzx, t20.xyzw, s1, l(0.000000)
    add r21.xyz, r16.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyz, r21.xyzx, t20.xyzw, s1, l(0.000000)
    mad r21.xyz, r21.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r22.yyyy, r21.xyzx
    mov r21.w, r22.y
    mad r20.xyzw, r21.xyzw, r1.xxxx, r20.xyzw
    add r16.xyz, r16.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r16.xyz, r16.xyzx, t20.xyzw, s1, l(0.000000)
    mad r16.xyz, r16.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r16.xyz, r22.xxxx, r16.xyzx
    mov r16.w, r22.x
    mad r17.xyzw, r16.xyzw, r1.xxxx, r17.xyzw
    mad r16.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r22.xyz, r22.wwww, r16.xyzx
    mad r18.xyzw, r22.xyzw, r1.xxxx, r18.xyzw
    mad r2.z, r19.w, r1.x, r2.z
  endif
  mad_sat r1.x, r2.z, l(2.000000), l(-1.000000)
  add r16.x, -r0.z, r1.x
  add r0.z, r0.z, r1.x
  mul r16.y, r0.z, l(0.500000)
else
  mov r20.xyzw, l(0,0,0,0)
  mov r17.xyzw, l(0,0,0,0)
  mov r18.xyzw, l(0,0,0,0)
  mov r16.xy, l(0,1.000000,0,0)
endif
mul r19.xyzw, r16.yxyy, cb0[217].ywzx
mad r19.y, r19.y, l(0.500000), r19.x
mul r1.xy, r16.yxyy, cb0[217].wyww
mad r19.x, r1.y, l(0.375000), r1.x
add r18.xyzw, r18.xyzw, r19.wyzx
mul r19.xyzw, r16.yxyy, cb0[218].ywzx
mad r19.y, r19.y, l(0.500000), r19.x
mul r1.xy, r16.yxyy, cb0[218].wyww
mad r19.x, r1.y, l(0.375000), r1.x
add r17.xyzw, r17.xyzw, r19.wyzx
mul r19.xyzw, r16.yxyy, cb0[219].ywzx
mad r19.y, r19.y, l(0.500000), r19.x
mul r1.xy, r16.yxyy, cb0[219].wyww
mad r19.x, r1.y, l(0.375000), r1.x
add r16.xyzw, r19.wyzx, r20.xyzw
ge r1.xy, r4.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
and r0.z, r1.y, r1.x
if_nz r0.z
  sample_l_indexable(texture2d)(float,float,float,float) r19.xyzw, r4.xyxx, t14.xyzw, s1, l(0.000000)
  lt r20.xyzw, l(0.000100, 0.000100, 0.000100, 0.000100), |r19.xyzw|
  or r1.xy, r20.zwzz, r20.xyxx
  or r0.z, r1.y, r1.x
  if_nz r0.z
    dp3 r0.z, r19.yzwy, r19.yzwy
    sqrt r0.z, r0.z
    mov r1.x, l(1.000000)
    mov r1.y, r0.z
    mov r2.z, l(0)
    loop
      ge r4.x, l(4.600000), r1.y
      breakc_nz r4.x
      iadd r4.x, r2.z, l(1)
      mul r10.xz, r1.xxyx, l(0.500000, 0.000000, 0.500000, 0.000000)
      mov r1.xy, r10.xzxx
      mov r2.z, r4.x
      continue
    endloop
    mul r19.xyzw, r1.xxxx, r19.xyzw
    dp3 r0.z, r19.yzwy, r19.yzwy
    sqrt r0.z, r0.z
    mad r0.z, r0.z, cb6[3].x, cb6[3].y
    mad r0.z, r0.z, l(255.000000), l(0.500000)
    mul r1.x, r0.z, l(0.003906)
    mov r1.y, l(0.500000)
    sample_l_indexable(texture2d)(float,float,float,float) r1.xy, r1.xyxx, t13.xyzw, s1, l(0.000000)
    mad r1.xy, r1.xyxx, cb6[2].xyxx, cb6[2].zwzz
    mul r20.x, r1.x, l(3.544908)
    mul r20.yzw, r1.yyyy, r19.yyzw
    mul r0.z, r19.x, l(0.406977)
    exp r0.z, r0.z
    mul r19.xyzw, r0.zzzz, r20.xyzw
    mov r20.xyzw, r19.xyzw
    mov r0.z, l(0)
    loop
      uge r1.x, r0.z, r2.z
      breakc_nz r1.x
      mul r21.xyzw, r20.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
      dp4 r1.x, r21.xyzw, r20.xyzw
      dp2 r1.y, r21.yxyy, r20.xyxx
      dp2 r4.x, r21.zxzz, r20.xzxx
      dp2 r4.y, r21.wxww, r20.xwxx
      iadd r6.w, r0.z, l(1)
      mov r20.xy, r1.xyxx
      mov r20.zw, r4.xxxy
      mov r0.z, r6.w
      continue
    endloop
    mul r19.xyzw, r20.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
    mul r20.xyzw, r18.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r0.z, r19.xyzw, r20.xyzw
    dp2 r1.x, r19.yxyy, r20.xyxx
    dp2 r1.y, r19.zxzz, r20.xzxx
    dp2 r2.z, r19.wxww, r20.xwxx
    mul r20.xyzw, r17.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r4.x, r19.xyzw, r20.xyzw
    dp2 r4.y, r19.yxyy, r20.xyxx
    dp2 r6.w, r19.zxzz, r20.xzxx
    dp2 r7.w, r19.wxww, r20.xwxx
    mul r20.xyzw, r16.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r8.w, r19.xyzw, r20.xyzw
    dp2 r9.w, r19.yxyy, r20.xyxx
    dp2 r10.x, r19.zxzz, r20.xzxx
    dp2 r10.z, r19.wxww, r20.xwxx
    mul r18.w, r0.z, l(0.886227)
    mul r18.x, r2.z, l(-1.023327)
    mul r18.yz, r1.xxyx, l(0.000000, -1.023327, 1.023327, 0.000000)
    mul r17.x, r7.w, l(-1.023327)
    mul r17.yw, r4.yyyx, l(0.000000, -1.023327, 0.000000, 0.886227)
    mul r17.z, r6.w, l(1.023327)
    mul r16.w, r8.w, l(0.886227)
    mul r16.y, r9.w, l(-1.023327)
    mul r16.xz, r10.zzxz, l(-1.023327, 0.000000, 1.023327, 0.000000)
  endif
endif
dp3 r0.z, r18.xyzx, r3.xyzx
add r0.z, r18.w, r0.z
max r18.x, r0.z, l(0.000000)
dp3 r0.z, r17.xyzx, r3.xyzx
add r0.z, r17.w, r0.z
max r18.y, r0.z, l(0.000000)
dp3 r0.z, r16.xyzx, r3.xyzx
add r0.z, r16.w, r0.z
max r18.z, r0.z, l(0.000000)
add r0.z, l(-1.000000), cb0[113].x
max r1.x, r10.w, l(0.001000)
log r1.x, r1.x
mad r1.x, -r1.x, l(1.200000), l(1.000000)
add r0.z, r0.z, -r1.x
mul r1.xy, r2.xyxx, cb1[0].wwww
round_ni r1.xy, r1.xyxx
add r2.z, |r1.w|, -cb1[2].y
round_ni r2.z, r2.z
add r4.x, l(-1.000000), cb1[1].x
max r4.y, r2.z, l(0.000000)
min r4.x, r4.x, r4.y
ge r2.z, r4.x, r2.z
mad r1.x, r1.y, cb1[0].x, r1.x
ftoi r1.x, r1.x
iadd r1.x, r1.x, cb0[110].z
ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.x, r1.x, l(0), t0.xxxx
ftoi r1.y, r4.x
iadd r1.y, r1.y, cb0[110].w
ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r1.y, r1.y, l(0), t0.xxxx
and r1.x, r1.y, r1.x
and r1.x, r1.x, r2.z
mul r10.xzw, r18.xxyz, cb0[111].xxxx
dp3 r1.y, r10.xzwx, l(0.212673, 0.715152, 0.072175, 0.000000)
mov r41.x, r1.y  // Store ambient luminance for cubemap modulation
mov r5.w, l(1.000000)
mov r3.w, l(1.000000)
mov r10.xzw, l(0,0,0,0)
mov r2.z, l(1.000000)
mov r4.x, r1.x
mov r4.y, l(0)
loop
  lt r6.w, l(0.010000), r2.z
  ine r7.w, r4.x, l(0)
  and r7.w, r6.w, r7.w
  if_nz r7.w
    firstbit_lo r7.w, r4.x
    ishl r8.w, l(1), r7.w
    xor r4.x, r4.x, r8.w
    ishl r7.w, r7.w, l(3)
    dp4 r16.x, cb1[r7.w + 6].xyzw, r5.xyzw
    dp4 r16.y, cb1[r7.w + 7].xyzw, r5.xyzw
    dp4 r16.z, cb1[r7.w + 8].xyzw, r5.xyzw
    ge r17.xyz, cb1[r7.w + 5].xyzx, |r16.xyzx|
    and r8.w, r17.y, r17.x
    and r8.w, r17.z, r8.w
    if_nz r8.w
      mul r8.w, l(0.100000), cb1[r7.w + 5].x
      mul r17.xyz, |r16.xyzx|, l(0.100000, 0.100000, 0.100000, 0.000000)
      mul r17.xy, r17.xyxx, r17.xyxx
      add r19.xyz, -|r16.xyzx|, cb1[r7.w + 5].xyzx
      mul r19.xyz, r19.xyzx, cb1[r7.w + 9].xyzx
      eq r9.w, l(1.000000), cb1[r7.w + 10].x
      if_nz r9.w
        dp3 r20.x, cb1[r7.w + 6].xyzx, r14.xyzx
        dp3 r20.y, cb1[r7.w + 7].xyzx, r14.xyzx
        dp3 r20.z, cb1[r7.w + 8].xyzx, r14.xyzx
        add r21.xyz, -r16.xyzx, cb1[r7.w + 5].xyzx
        div r21.xyz, r21.xyzx, r20.xyzx
        add r22.xyz, -r16.xyzx, -cb1[r7.w + 5].xyzx
        div r22.xyz, r22.xyzx, r20.xyzx
        lt r23.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r20.xyzx
        movc r21.xyz, r23.xyzx, r21.xyzx, r22.xyzx
        min r9.w, r21.y, r21.x
        min r9.w, r21.z, r9.w
        mad r16.xyz, r20.xyzx, r9.wwww, r16.xyzx
      else
        mov r16.xyz, r14.xyzx
      endif
      dp3 r9.w, r16.xyzx, r16.xyzx
      rsq r9.w, r9.w
      mul r16.xyz, r9.wwww, r16.xyzx
      lt r20.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r16.xyzx
      lt r21.xyz, r16.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
      iadd r20.xyz, -r20.xyzx, r21.xyzx
      itof r20.xyz, r20.xyzx
      dp3 r9.w, r16.xyzx, r20.xyzx
      div r16.xyz, r16.xyzx, r9.wwww
      lt r9.w, r16.z, l(0.000000)
      add r16.zw, -|r16.yyyx|, l(0.000000, 0.000000, 1.000000, 1.000000)
      mul r16.zw, r16.zzzw, r20.xxxy
      movc r16.xy, r9.wwww, r16.zwzz, r16.xyxx
      dp4 r9.w, cb1[r7.w + 4].xyzw, r3.xyzw
      max r9.w, r9.w, l(0.000000)
      max r9.w, r9.w, l(0.000100)
      min r11.w, r19.z, r19.y
      min r11.w, r11.w, r19.x
      add r12.x, r17.y, r17.x
      mad r12.x, r17.z, r17.z, r12.x
      mad r8.w, r8.w, r8.w, -r12.x
      mul r8.w, r8.w, cb1[r7.w + 9].x
      mul r8.w, r8.w, cb1[r7.w + 9].x
      add r12.x, l(1.000000), -cb1[r7.w + 10].y
      mul r8.w, r8.w, r12.x
      mul r8.w, r8.w, l(100.000000)
      mad_sat r8.w, r11.w, cb1[r7.w + 10].y, r8.w
      mul r11.w, r8.w, cb1[r7.w + 10].w
      mad r16.xy, r16.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
      mad r16.xy, r16.xyxx, cb1[1].wwww, cb1[2].wwww
      mov r16.z, cb1[r7.w + 5].w
      sample_l_indexable(texture2darray)(float,float,float,float) r16.xyz, r16.xyzx, t5.xyzw, s3, r0.z
      mul r16.xyz, r16.xyzx, cb1[r7.w + 9].wwww
      div r12.x, r1.y, r9.w
      min r12.x, |r12.x|, l(1.000000)
      mad r12.x, r12.x, l(2.000000), r1.y
      add r9.w, r9.w, l(2.000000)
      div r9.w, r12.x, r9.w
      add r9.w, r9.w, l(-1.000000)
      mad r9.w, r9.w, cb0[112].w, l(1.000000)
      mul r16.xyz, r9.wwww, r16.xyzx
      mul r16.xyz, r11.wwww, r16.xyzx
      mad r10.xzw, r16.xxyz, r2.zzzz, r10.xxzw
      mad r7.w, -r8.w, cb1[r7.w + 10].w, l(1.000000)
      mul r2.z, r2.z, r7.w
    endif
    mov r4.y, l(-1)
    continue
  else
    mov r4.y, r6.w
    break
  endif
  mov r4.y, r6.w
endloop
if_nz r4.y
  dp3 r1.x, r14.xyzx, r14.xyzx
  rsq r1.x, r1.x
  mul r5.xzw, r1.xxxx, r14.xxyz
  lt r14.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r5.xzwx
  lt r16.xyz, r5.xzwx, l(0.000000, 0.000000, 0.000000, 0.000000)
  iadd r14.xyz, -r14.xyzx, r16.xyzx
  itof r14.xyz, r14.xyzx
  dp3 r1.x, r5.xzwx, r14.xyzx
  div r5.xzw, r5.xxzw, r1.xxxx
  lt r1.x, r5.w, l(0.000000)
  add r4.xy, -|r5.zxzz|, l(1.000000, 1.000000, 0.000000, 0.000000)
  mul r4.xy, r4.xyxx, r14.xyxx
  movc r4.xy, r1.xxxx, r4.xyxx, r5.xzxx
  mov r3.w, l(1.000000)
  dp4 r1.x, cb1[3].xyzw, r3.xyzw
  max r1.x, r1.x, l(0.000000)
  max r1.x, r1.x, l(0.000100)
  mad r3.xy, r4.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
  mad r3.xy, r3.xyxx, cb1[1].wwww, cb1[2].wwww
  mov r3.z, l(0)
  sample_l_indexable(texture2darray)(float,float,float,float) r3.xyz, r3.xyzx, t5.xyzw, s3, r0.z
  div r0.z, r1.y, r1.x
  min r0.z, |r0.z|, l(1.000000)
  mad r0.z, r0.z, l(2.000000), r1.y
  add r1.x, r1.x, l(2.000000)
  div r0.z, r0.z, r1.x
  add r0.z, r0.z, l(-1.000000)
  mad r0.z, r0.z, cb0[112].w, l(1.000000)
  mul r3.xyz, r0.zzzz, r3.xyzx
  mad r10.xzw, r3.xxyz, r2.zzzz, r10.xxzw
endif
mul r3.xyz, r10.xzwx, cb0[112].zzzz
mul r3.xyz, r3.xyzx, cb0[111].yyyy
// Cubemap ambient link modulation (cb13[13].y)
if_nz cb13[13].y
  max r41.x, r41.x, l(0.000000)
  min r41.x, r41.x, l(1.000000)
  mad r41.x, r41.x, l(0.750000), l(0.250000)
  mul r3.xyz, r3.xyzx, r41.xxxx
endif
if_nz r10.y
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t3.yzxw, s1, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r5.xzw, v1.xyxx, t2.xwyz, s1, cb0[108].x
  add r1.x, -r0.z, l(1.000000)
  mul r10.xyz, r1.xxxx, r3.xyzx
  mad r3.xyz, r5.xzwx, r0.zzzz, r10.xyzx
endif
mul r5.xzw, r11.xxyz, r18.xxyz
mul r5.xzw, r5.xxzw, cb0[111].xxxx
add r0.z, -r1.z, l(1.000000)
div r0.z, r0.z, r1.z
mul r1.xyz, r0.zzzz, r9.xyzx
mad r1.xyz, r1.xyzx, r12.yzwy, r12.yzwy
mul r1.xyz, r1.xyzx, r3.xyzx
mul r1.xyz, r13.xyzx, r1.xyzx
mad r1.xyz, r5.xzwx, r15.xyzx, r1.xyzx
add r1.xyz, r1.xyzx, r6.xyzx
mad r0.z, r5.y, cb0[156].w, cb0[157].w
max r0.z, r0.z, l(0.010000)
mad r2.z, r4.w, cb0[154].w, -cb0[153].w
max r2.z, r2.z, l(0.000000)
mul r3.x, r0.z, l(-1.442695)
exp r3.x, r3.x
add r3.x, -r3.x, l(1.000000)
div r0.z, r3.x, r0.z
mad r3.x, r5.y, cb0[156].w, cb0[158].w
mul r3.x, r3.x, l(1.442695)
exp r3.x, r3.x
mul r0.z, r0.z, r3.x
mul r0.z, r0.z, -r2.z
mul r3.xyz, r0.zzzz, cb0[155].xyzx
mul r3.xyz, r3.xyzx, l(1.442695, 1.442695, 1.442695, 0.000000)
exp r3.xyz, r3.xyzx
dp3 r0.z, -r8.xyzx, cb0[154].xyzx
mad r2.z, cb0[155].w, cb0[155].w, l(1.000000)
dp2 r3.w, r0.zzzz, cb0[155].wwww
add r2.z, r2.z, -r3.w
lt r3.w, l(0.000000), cb0[165].z
if_nz r3.w
  and r0.w, l(7), cb0[108].w
  imad r0.xyw, r0.xyxw, l(0x0019660d, 0x0019660d, 0, 0x0019660d), l(0x3c6ef35f, 0x3c6ef35f, 0, 0x3c6ef35f)
  imad r0.x, r0.y, r0.w, r0.x
  imad r0.y, r0.w, r0.x, r0.y
  imad r0.w, r0.x, r0.y, r0.w
  imad r4.x, r0.y, r0.w, r0.x
  dp3 r0.x, -r8.xyzx, -r7.xyzx
  add r3.w, r5.y, -cb0[44].y
  lt r5.x, l(0.000000), r0.x
  div r0.x, l(1.000000, 1.000000, 1.000000, 1.000000), r0.x
  and r0.x, r0.x, r5.x
  mul r0.x, r0.x, cb0[165].w
  div r5.x, l(1.000000, 1.000000, 1.000000, 1.000000), r4.w
  mul r5.z, r0.x, r5.x
  mad r5.w, r5.z, r3.w, cb0[44].y
  mad r3.w, -r5.z, r3.w, r3.w
  mad r0.x, -r0.x, r5.x, l(1.000000)
  mul r5.x, r4.w, r0.x
  mul r5.z, r3.w, cb0[159].z
  max r5.z, r5.z, l(-127.000000)
  mul r3.w, r3.w, cb0[162].x
  max r3.w, r3.w, l(-127.000000)
  add r6.x, r5.w, -cb0[159].x
  mul r6.x, r6.x, cb0[159].z
  max r6.x, r6.x, l(-127.000000)
  exp r6.x, -r6.x
  mul r6.x, r6.x, cb0[159].y
  lt r6.y, l(0.000000), |r5.z|
  exp r6.z, -r5.z
  add r6.z, -r6.z, l(1.000000)
  div r6.z, r6.z, r5.z
  mad r5.z, -r5.z, l(0.240227), l(0.693147)
  movc r5.z, r6.y, r6.z, r5.z
  add r5.w, r5.w, -cb0[162].z
  mul r5.w, r5.w, cb0[162].x
  max r5.w, r5.w, l(-127.000000)
  exp r5.w, -r5.w
  mul r5.w, r5.w, cb0[162].y
  lt r6.y, l(0.000000), |r3.w|
  exp r6.z, -r3.w
  add r6.z, -r6.z, l(1.000000)
  div r6.z, r6.z, r3.w
  mad r3.w, -r3.w, l(0.240227), l(0.693147)
  movc r3.w, r6.y, r6.z, r3.w
  mul r3.w, r3.w, r5.w
  mad r3.w, r6.x, r5.z, r3.w
  mad_sat r5.zw, r4.wwww, cb0[160].wwwy, cb0[160].zzzx
  mul r5.x, r5.x, r3.w
  exp r5.x, -r5.x
  min r5.x, r5.x, l(1.000000)
  max r5.x, r5.x, cb0[161].w
  add r5.x, r5.w, r5.x
  add r5.x, r5.z, r5.x
  min r5.x, r5.x, l(1.000000)
  imad r4.y, r0.w, r4.x, r0.y
  ushr r0.yw, r4.xxxy, l(0, 16, 0, 16)
  utof r0.yw, r0.yyyw
  mad r0.yw, r0.yyyw, l(0.000000, 0.000031, 0.000000, 0.000031), l(0.000000, -1.000000, 0.000000, -1.000000)
  mad r0.yw, r0.yyyw, cb0[169].wwww, r2.xxxy
  mul r6.xy, r0.ywyy, cb0[167].xyxx
  mad r0.y, |r1.w|, cb0[166].x, cb0[166].y
  log r0.y, r0.y
  mul r0.y, r0.y, cb0[166].z
  div r6.z, r0.y, cb0[165].z
  sample_l_indexable(texture3d)(float,float,float,float) r6.xyzw, r6.xyzx, t12.xyzw, s1, l(0.000000)
  add r0.y, |r1.w|, -cb0[168].z
  mul_sat r0.y, r0.y, l(1000000.000000)
  add r6.xyzw, r6.xyzw, l(-0.000000, -0.000000, -0.000000, -1.000000)
  mad r6.xyzw, r0.yyyy, r6.xyzw, l(0.000000, 0.000000, 0.000000, 1.000000)
  add r0.y, -r5.x, l(1.000000)
  dp3_sat r0.w, r8.xyzx, cb0[163].xyzx
  log r0.w, r0.w
  mul r0.w, r0.w, cb0[164].w
  exp r0.w, r0.w
  mul r7.xyz, r0.wwww, cb0[164].xyzx
  mad r0.x, r0.x, r4.w, -cb0[163].w
  max r0.x, r0.x, l(0.000000)
  mul r0.x, r0.x, r3.w
  exp r0.x, -r0.x
  min r0.x, r0.x, l(1.000000)
  add r0.x, -r0.x, l(1.000000)
  mul r7.xyz, r0.xxxx, r7.xyzx
  add r0.x, -r5.z, l(1.000000)
  mul r7.xyz, r0.xxxx, r7.xyzx
  mad r0.xyw, cb0[161].xyxz, r0.yyyy, r7.xyxz
  mad r0.xyw, r0.xyxw, r6.wwww, r6.xyxz
  mul r1.w, r5.x, r6.w
else
  add r2.x, r5.y, -cb0[44].y
  mul r2.y, r2.x, cb0[159].z
  mul r2.x, r2.x, cb0[162].x
  max r2.xy, r2.xyxx, l(-127.000000, -127.000000, 0.000000, 0.000000)
  add r3.w, cb0[44].y, -cb0[159].x
  mul r3.w, r3.w, cb0[159].z
  max r3.w, r3.w, l(-127.000000)
  exp r3.w, -r3.w
  mul r3.w, r3.w, cb0[159].y
  lt r4.x, l(0.000000), |r2.y|
  exp r4.y, -r2.y
  add r4.y, -r4.y, l(1.000000)
  div r4.y, r4.y, r2.y
  mad r2.y, -r2.y, l(0.240227), l(0.693147)
  movc r2.y, r4.x, r4.y, r2.y
  add r4.x, cb0[44].y, -cb0[162].z
  mul r4.x, r4.x, cb0[162].x
  max r4.x, r4.x, l(-127.000000)
  exp r4.x, -r4.x
  mul r4.x, r4.x, cb0[162].y
  lt r4.y, l(0.000000), |r2.x|
  exp r5.x, -r2.x
  add r5.x, -r5.x, l(1.000000)
  div r5.x, r5.x, r2.x
  mad r2.x, -r2.x, l(0.240227), l(0.693147)
  movc r2.x, r4.y, r5.x, r2.x
  mul r2.x, r2.x, r4.x
  mad r2.x, r3.w, r2.y, r2.x
  mad_sat r4.xy, r4.wwww, cb0[160].wyww, cb0[160].zxzz
  mul r2.y, r4.w, r2.x
  exp r2.y, -r2.y
  min r2.y, r2.y, l(1.000000)
  max r2.y, r2.y, cb0[161].w
  add r2.y, r4.y, r2.y
  add r2.y, r4.x, r2.y
  min r1.w, r2.y, l(1.000000)
  add r2.y, -r1.w, l(1.000000)
  dp3_sat r3.w, r8.xyzx, cb0[163].xyzx
  log r3.w, r3.w
  mul r3.w, r3.w, cb0[164].w
  exp r3.w, r3.w
  mul r5.xyz, r3.wwww, cb0[164].xyzx
  mad r2.w, r2.w, r4.z, -cb0[163].w
  max r2.w, r2.w, l(0.000000)
  mul r2.x, r2.w, r2.x
  exp r2.x, -r2.x
  min r2.x, r2.x, l(1.000000)
  add r2.x, -r2.x, l(1.000000)
  mul r4.yzw, r2.xxxx, r5.xxyz
  add r2.x, -r4.x, l(1.000000)
  mul r4.xyz, r2.xxxx, r4.yzwy
  mad r0.xyw, cb0[161].xyxz, r2.yyyy, r4.xyxz
endif
mul r2.xyw, r1.wwww, r3.xyxz
max r1.xyz, r1.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
min r1.xyz, r1.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
mad r0.z, r0.z, r0.z, l(1.000000)
mul r0.z, r0.z, l(0.059683)
mad r4.xyz, cb0[156].xyzx, r0.zzzz, cb0[158].xyzx
mad r0.z, -cb0[155].w, cb0[155].w, l(1.000000)
mul r3.w, r2.z, l(12.566371)
sqrt r2.z, r2.z
mul r2.z, r2.z, r3.w
max r2.z, r2.z, l(0.001000)
div r0.z, r0.z, r2.z
mad_sat r4.xyz, cb0[157].xyzx, r0.zzzz, r4.xyzx
mul r4.xyz, r4.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
add r3.xyz, -r3.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r3.xyz, r3.xyzx, r4.xyzx
mad r0.xyz, r3.xyzx, r1.wwww, r0.xywx
lt r40.x, l(0.500000), cb13[12].y
if_nz r40.x
  mul r36.xyz, r1.xyzx, l(0.003922, 0.003922, 0.003922, 0.000000)
  mul r37.xyz, r0.xyzx, l(0.003922, 0.003922, 0.003922, 0.000000)
  mul r38.xyz, r2.xywx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  add r38.xyz, r38.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r38.xyz, r38.xyzx, l(0.350000, 0.350000, 0.350000, 0.000000), r2.xywx
  mul r37.xyz, r37.xyzx, l(0.650000, 0.650000, 0.650000, 0.000000)
  mad r39.xyz, r36.xyzx, r38.xyzx, r37.xyzx
  mul o0.xyz, r39.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
else
  mad o0.xyz, r1.xyzx, r2.xywx, r0.xyzx
endif
dp3 o0.w, r2.xywx, l(0.333333, 0.333333, 0.333333, 0.000000)
ret
// Approximately 0 instruction slots used
