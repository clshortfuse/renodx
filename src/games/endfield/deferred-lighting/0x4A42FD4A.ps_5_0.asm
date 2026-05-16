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
dcl_resource_texture3d (float,float,float,float) t25
dcl_input_ps_siv linear noperspective v0.xy, position
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 41
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
movc r8.xyz, r2.wwww, r6.xyzx, r7.xyzx
dp3 r2.w, r8.xyzx, r8.xyzx
max r4.z, r2.w, l(0.000000)
rsq r4.z, r4.z
mul r9.xyz, r4.zzzz, r8.xyzx
mul r4.w, r2.w, r4.z
lt r6.w, l(0.000488), cb0[238].x
if_nz r6.w
  sample_b_indexable(texture2d)(float,float,float,float) r10.xy, v1.xyxx, t21.xyzw, s1, cb0[108].x
else
  mov r10.xy, l(1.000000,1.000000,0,0)
endif
min r7.w, r10.y, r10.x
add r1.z, r1.z, l(-0.050000)
mul_sat r1.z, r1.z, l(1.052600)
add r8.w, r10.y, l(-1.000000)
mad r11.x, r1.z, r8.w, l(1.000000)
add r11.y, -r1.z, l(1.000000)
movc r10.yz, r6.wwww, r11.xxyx, l(0,1.000000,1.000000,0)
min r1.z, r2.z, r10.y
add r6.w, -r1.z, r2.z
mad r1.z, r7.w, r6.w, r1.z
add r2.z, -r1.z, r2.z
mad r11.w, r10.x, r2.z, r1.z
ld_indexable(texture2d)(float,float,float,float) r12.xyz, r0.xyzz, t24.xyzw
add r1.z, -r10.z, l(1.000000)
mad r1.z, r7.w, r1.z, r10.z
add r2.z, -r1.z, l(1.000000)
mad r1.z, r10.x, r2.z, r1.z
mul r10.xyz, r1.zzzz, r12.xyzx
mul r13.xyz, r1.xxxx, r10.xyzx
mad r12.xyz, r12.xyzx, r1.zzzz, -r13.xyzx
mad r1.z, -r1.x, l(0.040000), l(0.040000)
mad r10.xyz, r10.xyzx, r1.xxxx, r1.zzzz
dp3 r1.x, r3.xyzx, r9.xyzx
max r13.x, r1.x, l(0.000000)
mul r14.y, r11.w, r11.w
mul r15.x, r13.x, r13.x
mul r15.z, r13.x, r15.x
mul r1.x, r14.y, r14.y
mul r14.z, r14.y, r1.x
mov r13.yzw, l(0,0.036546,9.063200,0.990440)
dp2 r16.x, l(3.327070, 1.000000, 0.000000, 0.000000), r13.xyxx
dp2 r16.y, l(-9.047560, 1.000000, 0.000000, 0.000000), r13.xzxx
mov r14.x, l(1.000000)
dp2 r1.z, r16.xyxx, r14.xyxx
mov r15.yw, l(0,9.044010,0,1.000000)
dp3 r16.x, l(3.596850, -1.367720, 1.000000, 0.000000), r15.xzwx
dp3 r16.y, l(-16.317400, 1.000000, 9.229490, 0.000000), r15.xyzx
mov r17.x, l(5.565890)
mov r17.yz, r15.xxzx
dp3 r16.z, l(1.000000, 19.788601, -20.212299, 0.000000), r17.xyzx
dp3 r2.z, r16.xyzx, r14.xyzx
div r1.z, r1.z, r2.z
dp2 r16.x, l(-1.285140, 1.000000, 0.000000, 0.000000), r13.xwxx
mov r15.x, l(1.296780)
mov r15.y, r13.x
dp2 r16.y, l(1.000000, -0.755907, 0.000000, 0.000000), r15.xyxx
dp2 r2.z, r16.xyxx, r14.xyxx
dp3 r16.x, l(2.923380, 59.418800, 1.000000, 0.000000), r15.yzwy
mov r15.xw, l(20.322500,0,0,121.563004)
dp3 r16.y, l(1.000000, -27.030199, 222.591995, 0.000000), r15.xyzx
dp3 r16.z, l(626.130005, 316.627014, 1.000000, 0.000000), r15.yzwy
dp3 r6.w, r16.xyzx, r14.xyzx
div r2.z, r2.z, r6.w
mad r13.yzw, r10.xxyz, r1.zzzz, r2.zzzz
add r1.z, r1.z, r2.z
ld_indexable(texture2d)(float,float,float,float) r14.x, r0.xyzz, t7.xzyw
lt r0.z, l(0.001000), r14.x
if_nz r0.z
  dp3 r0.z, -r9.xyzx, r3.xyzx
  add r0.z, r0.z, r0.z
  mad r15.xyz, r3.xyzx, -r0.zzzz, -r9.xyzx
  dp3 r0.z, -cb3[0].xyzx, r15.xyzx
  mad r16.xyz, cb3[0].xyzx, r0.zzzz, r15.xyzx
  lt r0.z, r0.z, cb3[4].z
  dp3 r2.z, r16.xyzx, r16.xyzx
  max r2.z, r2.z, l(0.000061)
  rsq r2.z, r2.z
  mul r16.xyz, r2.zzzz, r16.xyzx
  mul r16.xyz, r16.xyzx, cb3[4].yyyy
  mad r16.xyz, -cb3[0].xyzx, cb3[4].zzzz, r16.xyzx
  dp3 r2.z, r16.xyzx, r16.xyzx
  rsq r2.z, r2.z
  mul r16.xyz, r2.zzzz, r16.xyzx
  movc r15.xyz, r0.zzzz, r16.xyzx, r15.xyzx
  mad r16.xyz, r8.xyzx, r4.zzzz, r15.xyzx
  dp3 r0.z, r16.xyzx, r16.xyzx
  max r0.z, r0.z, l(0.000061)
  rsq r0.z, r0.z
  mul r16.xyz, r0.zzzz, r16.xyzx
  dp3_sat r11.y, r15.xyzx, r3.xyzx
  dp3_sat r0.z, r3.xyzx, r16.xyzx
  min r11.z, r13.x, l(1.000000)
  mad r2.z, r0.z, r1.x, -r0.z
  mad r0.z, r2.z, r0.z, l(1.000000)
  dp3_sat r2.z, r9.xyzx, r16.xyzx
  add r2.z, -r2.z, l(1.000000)
  mul r6.w, r2.z, r2.z
  mul r6.w, r6.w, r6.w
  mul r7.w, r2.z, r6.w
  add r8.w, -r11.w, l(1.000000)
  mad r9.w, -r8.w, l(0.383026), l(-0.076195)
  mad r9.w, r8.w, r9.w, l(1.049970)
  mad r8.w, r8.w, r9.w, l(0.409255)
  min r8.w, r8.w, l(0.999000)
  add r9.w, -r8.w, l(1.000000)
  add r15.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r15.xyz, r15.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r10.xyzx
  mad r2.z, -r6.w, r2.z, l(1.000000)
  mad r16.xyz, r10.xyzx, r2.zzzz, r7.wwww
  mul r0.z, r0.z, r0.z
  div r0.z, r1.x, r0.z
  mad r17.xy, -r11.zyzz, r1.xxxx, r11.zyzz
  mad r17.xy, r17.xyxx, r11.zyzz, r1.xxxx
  sqrt r17.xy, r17.xyxx
  mul r17.xy, r11.yzyy, r17.xyxx
  add r1.x, r17.y, r17.x
  add r1.x, r1.x, l(0.000100)
  div r1.x, l(0.500000), r1.x
  mul r0.z, r0.z, r1.x
  mul r16.xyz, r0.zzzz, r16.xyzx
  min r16.xyz, r16.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
  mad r17.xyzw, r11.zwyw, l(0.968750, 0.968750, 0.968750, 0.968750), l(0.015625, 0.015625, 0.015625, 0.015625)
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r17.xyxx, t9.yzxw, s1, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r1.x, r17.zwzz, t9.xyzw, s1, l(0.000000)
  mul r0.z, r0.z, r1.x
  mul r0.z, r8.w, r0.z
  div r0.z, r0.z, r9.w
  mul r17.xyz, r15.xyzx, r15.xyzx
  mul r17.xyz, r0.zzzz, r17.xyzx
  mad r15.xyz, -r15.xyzx, r9.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r15.xyz, r17.xyzx, r15.xyzx
  add r15.xyz, r15.xyzx, r16.xyzx
  mul r15.xyz, r15.xyzx, cb3[4].xxxx
  max r15.xyz, r15.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  min r15.xyz, r15.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
  mul r16.xyz, r11.yyyy, r12.xyzx
  mad r15.xyz, r15.xyzx, r11.yyyy, r16.xyzx
  mul r15.xyz, r15.xyzx, cb3[1].xyzx
  mov r14.z, l(0.500000)
  sample_b_indexable(texture2d)(float,float,float,float) r16.xyz, r14.xzxx, t8.xyzw, s1, cb0[108].x
  add r0.z, -r14.x, l(1.000000)
  mad r14.xzw, r15.xxyz, r16.xxyz, -r15.xxyz
  mad r14.xzw, r0.zzzz, r14.xxzw, r15.xxyz
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r4.xyxx, t10.yzxw, s1, l(0.000000)
  min r0.z, r0.z, l(1.000000)
  mul r14.xzw, r0.zzzz, r14.xxzw
else
  mov r14.xzw, l(0,0,0,0)
endif
mul r11.yz, r2.xxyx, l(0.000000, 0.031250, 0.031250, 0.000000)
round_ni r11.yz, r11.yyzy
mad r0.z, r11.z, cb2[1].y, r11.y
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
dp3 r6.w, -r9.xyzx, r3.xyzx
add r6.w, r6.w, r6.w
mad r15.xyz, r3.xyzx, -r6.wwww, -r9.xyzx
min r11.x, r13.x, l(1.000000)
add r6.w, -r11.w, l(1.000000)
mad r7.w, -r6.w, l(0.383026), l(-0.076195)
mad r7.w, r6.w, r7.w, l(1.049970)
mad r6.w, r6.w, r7.w, l(0.409255)
min r6.w, r6.w, l(0.999000)
add r7.w, -r6.w, l(1.000000)
add r16.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
mad r16.xyz, r16.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r10.xyzx
mad r11.yz, r11.xxwx, l(0.000000, 0.968750, 0.968750, 0.000000), l(0.000000, 0.015625, 0.015625, 0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r8.w, r11.yzyy, t9.yzwx, s1, l(0.000000)
mad r17.xyz, -r16.xyzx, r7.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r16.xyz, r16.xyzx, r16.xyzx
mov r18.w, l(1.000000)
mov r19.y, l(1.000000)
mov r20.z, r11.w
mov r21.xyz, l(0,0,0,0)
mov r9.w, l(1.000000)
mov r10.w, l(0)
loop
  ilt r11.y, l(7), r10.w
  breakc_nz r11.y
  iadd r11.y, r0.z, r10.w
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r11.y, r11.y, l(0), t0.xxxx
  iadd r11.z, r2.z, r10.w
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r11.z, r11.z, l(0), t0.xxxx
  and r11.y, r11.z, r11.y
  and r11.y, r1.x, r11.y
  ishl r11.z, r10.w, l(5)
  mov r22.xyz, l(0,0,0,0)
  mov r12.w, r9.w
  mov r15.w, r11.y
  loop
    breakc_z r15.w
    firstbit_lo r16.w, r15.w
    ishl r17.w, l(1), r16.w
    xor r17.w, r15.w, r17.w
    iadd r16.w, r11.z, r16.w
    bfi r23.xyzw, l(29, 29, 29, 29), l(3, 3, 3, 3), r16.wwww, l(1, 3, 5, 6)
    bfi r19.z, l(29), l(3), r16.w, l(7)
    ftou r19.w, cb3[r23.z + 6].w
    ieq r19.w, r19.w, l(1)
    if_nz r19.w
      add r18.xyz, r5.xyzx, -cb3[r23.x + 6].xyzx
      and r24.xyz, l(0x0000ffff, 0x0000ffff, 0x0000ffff, 0), cb3[r23.z + 6].xzyx
      and r25.xyz, l(0x0000ffff, 0x0000ffff, 0x0000ffff, 0), cb3[r23.w + 6].yxzy
      ushr r26.xyz, cb3[r23.z + 6].xzyx, l(16, 16, 16, 0)
      ushr r27.xyz, cb3[r23.w + 6].yxzy, l(16, 16, 16, 0)
      f16tof32 r24.xyz, r24.xyzx
      f16tof32 r25.xyz, r25.xyzx
      f16tof32 r26.xyz, r26.xyzx
      f16tof32 r27.xyw, r27.yxyz
      mov r28.xz, r24.xxzx
      mov r28.yw, r26.xxxz
      dp4 r19.w, r18.xyzw, r28.xyzw
      mov r26.x, r24.y
      mov r26.z, r25.y
      mov r26.w, r27.x
      dp4 r20.w, r18.xyzw, r26.xyzw
      mov r27.xz, r25.xxzx
      dp4 r18.x, r18.xyzw, r27.xyzw
      max r18.y, |r19.w|, |r20.w|
      max r18.x, |r18.x|, r18.y
      mad r18.y, cb3[r19.z + 6].x, l(0.500000), l(0.500000)
      add r18.x, -r18.y, r18.x
      mad r18.y, -cb3[r19.z + 6].x, l(0.500000), l(0.500000)
      div_sat r18.x, r18.x, r18.y
      add r18.x, -r18.x, l(1.000000)
      mul r18.x, r18.x, r18.x
    else
      mov r18.x, l(1.000000)
    endif
    lt r18.y, l(0.500000), cb3[r23.y + 6].z
    lt r18.z, r18.x, l(0.001000)
    or r18.z, r18.y, r18.z
    if_nz r18.z
      mov r15.w, r17.w
      continue
    endif
    ishl r18.z, r16.w, l(3)
    bfi r16.w, l(29), l(3), r16.w, l(2)
    lt r19.w, cb3[r18.z + 6].w, l(1.500000)
    if_nz r19.w
      mad r19.w, cb3[r16.w + 6].y, l(0.500000), l(0.500000)
      add r24.x, r19.w, -|cb3[r16.w + 6].x|
      add r24.y, -r24.x, cb3[r16.w + 6].y
      add r19.w, -|r24.x|, l(1.000000)
      add r19.w, -|r24.y|, r19.w
      max r19.w, r19.w, l(0.000488)
      ge r20.w, cb3[r16.w + 6].x, l(0.000000)
      movc r24.z, r20.w, r19.w, -r19.w
      dp3 r19.w, r24.xyzx, r24.xyzx
      rsq r19.w, r19.w
      mul r24.xyz, r19.wwww, r24.xyzx
      add r25.xyz, -r5.xyzx, cb3[r23.x + 6].xyzx
      dp3 r19.w, r25.xyzx, r25.xyzx
      rsq r20.w, r19.w
      mul r26.xyz, r20.wwww, r25.xyzx
      ftoi r21.w, cb3[r19.z + 6].w
      mul r27.xyz, r24.xyzx, cb3[r16.w + 6].zzzz
      mad r28.xyz, -r27.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
      mad r29.xyz, r27.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
      ftou r22.w, cb3[r18.z + 6].w
      and r22.w, r22.w, l(1)
      ieq r23.z, r22.w, l(0)
      not r23.z, r23.z
      lt r24.w, l(0.000000), cb3[r16.w + 6].z
      and r23.z, r23.z, r24.w
      dp3 r24.w, r28.xyzx, r28.xyzx
      sqrt r24.w, r24.w
      dp3 r25.w, r29.xyzx, r29.xyzx
      sqrt r25.w, r25.w
      dp3 r26.w, r3.xyzx, r28.xyzx
      div r26.w, r26.w, r24.w
      dp3 r27.w, r3.xyzx, r29.xyzx
      div r27.w, r27.w, r25.w
      add r26.w, r26.w, r27.w
      mul_sat r30.x, r26.w, l(0.500000)
      dp3 r26.w, r28.xyzx, r29.xyzx
      mad r24.w, r24.w, r25.w, r26.w
      mad r24.w, r24.w, l(0.500000), l(1.000000)
      div r30.y, l(1.000000, 1.000000, 1.000000, 1.000000), r24.w
      dp3_sat r19.x, r3.xyzx, r26.xyzx
      movc r20.xy, r23.zzzz, r30.xyxx, r19.xyxx
      lt r19.x, cb3[r23.w + 6].w, l(0.000000)
      if_nz r19.x
        mul r19.x, cb3[r23.x + 6].w, cb3[r23.x + 6].w
        mul r19.x, r19.x, r19.w
        mad r19.x, -r19.x, r19.x, l(1.000000)
        max r19.x, r19.x, l(0.000000)
        add r19.w, r19.w, l(1.000000)
        div r19.w, l(1.000000, 1.000000, 1.000000, 1.000000), r19.w
        and r24.w, r23.z, l(0x3f800000)
        add r25.w, -r19.w, r20.y
        mad r19.w, r24.w, r25.w, r19.w
        mul r19.x, r19.x, r19.x
        mul r19.x, r19.x, r19.w
      else
        mul r29.xyz, r25.xyzx, cb3[r23.x + 6].wwww
        dp3 r19.w, r29.xyzx, r29.xyzx
        min r19.w, r19.w, l(1.000000)
        add r19.w, -r19.w, l(1.000000)
        log r19.w, r19.w
        mul r19.w, r19.w, cb3[r23.w + 6].w
        exp r19.w, r19.w
        mul r19.x, r19.w, r20.y
      endif
      dp3 r19.w, r26.xyzx, -r24.xyzx
      add r19.w, r19.w, -cb3[r16.w + 6].z
      mul_sat r19.w, r19.w, cb3[r16.w + 6].w
      mul r19.w, r19.w, r19.w
      movc r19.w, r22.w, l(1.000000), r19.w
      mul r19.x, r19.w, r19.x
      not r19.w, r23.z
      ige r20.y, r21.w, l(0)
      and r19.w, r19.w, r20.y
      if_nz r19.w
        if_z r22.w
          ishl r19.w, r21.w, l(2)
          mul r24.xyz, r5.yyyy, cb5[r19.w + 33].xywx
          mad r24.xyz, cb5[r19.w + 32].xywx, r5.xxxx, r24.xyzx
          mad r24.xyz, cb5[r19.w + 34].xywx, r5.zzzz, r24.xyzx
          add r24.xyz, r24.xyzx, cb5[r19.w + 35].xywx
          div_sat r24.xy, r24.xyxx, r24.zzzz
          mad r24.xy, r24.xyxx, cb5[r21.w + 0].zwzz, cb5[r21.w + 0].xyxx
        else
          ishl r19.w, r21.w, l(2)
          dp3 r29.x, -r25.xyzx, cb5[r19.w + 32].xyzx
          dp3 r29.y, -r25.xyzx, cb5[r19.w + 33].xyzx
          dp3 r29.z, -r25.xyzx, cb5[r19.w + 34].xyzx
          lt r19.w, |r29.x|, |r29.y|
          and r19.w, r19.w, l(1)
          dp2 r20.y, |r29.xyxx|, icb[r19.w + 0].xyxx
          lt r20.y, r20.y, |r29.z|
          movc r19.w, r20.y, l(2), r19.w
          dp3 r20.y, r29.xyzx, icb[r19.w + 0].xyzx
          lt r20.y, r20.y, l(0.000000)
          bfi r19.w, l(31), l(1), r19.w, r20.y
          ushr r20.y, r19.w, l(1)
          dp3 r20.y, r29.xyzx, icb[r20.y + 0].xyzx
          div r24.z, l(0.000244), cb5[r21.w + 0].w
          add r24.z, -r24.z, l(0.500000)
          utof r24.w, r19.w
          ult r25.x, r19.w, l(2)
          and r25.x, r25.x, l(2)
          dp2 r25.x, r29.xzxx, icb[r25.x + 0].xzxx
          mul r25.x, r25.x, icb[r19.w + 4].z
          div r25.x, r25.x, |r20.y|
          mad r24.w, r25.x, r24.z, r24.w
          add r24.w, r24.w, l(0.500000)
          mul_sat r25.x, r24.w, l(0.166667)
          iadd r24.w, l(-1), icb[r19.w + 4].y
          dp2 r24.w, r29.yzyy, icb[r24.w + 0].xyxx
          mul r19.w, r24.w, icb[r19.w + 4].w
          div r19.w, r19.w, |r20.y|
          mad_sat r25.y, -r19.w, r24.z, l(0.500000)
          mad r24.xy, r25.xyxx, cb5[r21.w + 0].zwzz, cb5[r21.w + 0].xyxx
        endif
        sample_l_indexable(texture2d)(float,float,float,float) r19.w, r24.xyxx, t11.yzwx, s1, l(0.000000)
        mul r19.x, r19.w, r19.x
      endif
      lt r19.w, l(0.000000), r19.x
      if_nz r19.w
        if_z r22.w
          ftoi r20.y, cb3[r23.y + 6].x
        else
          add r24.xyz, r5.xyzx, -cb3[r23.x + 6].xyzx
          lt r25.xyz, |r24.yzzy|, |r24.xxyx|
          and r21.w, r25.y, r25.x
          lt r24.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r24.xyzx
          ushr r22.w, cb3[r16.w + 6].w, l(24)
          ubfe r25.xy, l(8, 8, 0, 0), l(16, 8, 0, 0), cb3[r16.w + 6].wwww
          movc r22.w, r24.x, r22.w, r25.x
          and r24.x, l(255), cb3[r16.w + 6].w
          movc r24.x, r24.y, r25.y, r24.x
          ubfe r24.y, l(8), l(8), cb3[r23.y + 6].x
          and r24.w, l(255), cb3[r23.y + 6].x
          movc r24.y, r24.z, r24.y, r24.w
          movc r24.x, r25.z, r24.x, r24.y
          movc r21.w, r21.w, r22.w, r24.x
          ilt r22.w, r21.w, l(80)
          movc r20.y, r22.w, r21.w, l(-1)
        endif
        ishl r21.w, r20.y, l(2)
        mad r24.xyz, r26.xyzx, cb4[r20.y + 288].xxxx, r5.xyzx
        mul r22.w, l(5.000000), cb4[r20.y + 288].y
        mad r24.xyz, r3.xyzx, r22.wwww, r24.xyzx
        mul r25.xyzw, r24.yyyy, cb4[r21.w + 65].xyzw
        mad r25.xyzw, cb4[r21.w + 64].xyzw, r24.xxxx, r25.xyzw
        mad r24.xyzw, cb4[r21.w + 66].xyzw, r24.zzzz, r25.xyzw
        add r24.xyzw, r24.xyzw, cb4[r21.w + 67].xyzw
        div r24.xyz, r24.xyzx, r24.wwww
        ge r25.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r24.xyzx
        ge r29.xyz, r24.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
        add r30.xy, -cb4[r20.y + 344].xyxx, cb4[r20.y + 344].zwzz
        mad r24.xy, r24.xyxx, r30.xyxx, cb4[r20.y + 344].xyxx
        mad r30.xy, r24.xyxx, cb4[400].zwzz, l(0.500000, 0.500000, 0.000000, 0.000000)
        round_ni r30.xy, r30.xyxx
        mad r24.xy, r24.xyxx, cb4[400].zwzz, -r30.xyxx
        add r31.xyzw, r24.xxyy, l(0.500000, 1.000000, 0.500000, 1.000000)
        mul r32.xyzw, r31.xxzz, r31.xxzz
        add r30.zw, -r24.xxxy, l(0.000000, 0.000000, 1.000000, 1.000000)
        min r31.xz, r24.xxyx, l(0.000000, 0.000000, 0.000000, 0.000000)
        max r33.xy, r24.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
        mul r34.xy, r30.zwzz, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r33.xy, -r33.xyxx, r33.xyxx, r31.ywyy
        add r33.xy, r33.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
        mul r33.xy, r33.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r32.xz, r32.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
        mad r24.xy, r32.ywyy, l(0.500000, 0.500000, 0.000000, 0.000000), -r24.xyxx
        mul r35.xy, r24.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r24.xy, -r31.xzxx, r31.xzxx, r30.zwzz
        add r24.xy, r24.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
        mul r36.xy, r24.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r24.xy, r31.ywyy, l(0.160000, 0.160000, 0.000000, 0.000000)
        mov r35.z, r36.x
        mov r35.w, r24.x
        mov r34.z, r33.x
        mov r34.w, r32.x
        add r31.xyzw, r34.zwxz, r35.zwxz
        mov r36.z, r35.y
        mov r36.w, r24.y
        mov r33.z, r34.y
        mov r33.w, r32.z
        add r24.xyw, r33.zyzw, r36.zyzw
        div r32.xyz, r34.xzwx, r31.zwyz
        add r32.xyz, r32.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r32.xyz, r32.yxzy, cb4[400].xxxx
        div r33.xyz, r33.zywz, r24.xywx
        add r33.xyz, r33.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r33.xyz, r33.xyzx, cb4[400].yyyy
        mov r32.w, r33.x
        mad r34.xyzw, r30.xyxy, cb4[400].xyxy, r32.ywxw
        mad r30.zw, r30.xxxy, cb4[400].xxxy, r32.zzzw
        mov r33.w, r32.y
        mov r32.yw, r33.yyyz
        mad r35.xyzw, r30.xyxy, cb4[400].xyxy, r32.xyzy
        mad r33.xyzw, r30.xyxy, cb4[400].xyxy, r33.wywz
        mad r32.xyzw, r30.xyxy, cb4[400].xyxy, r32.xwzw
        mul r36.xyzw, r24.xxxy, r31.zwyz
        sample_c_lz_indexable(texture2d)(float,float,float,float) r21.w, r34.xyxx, t6.xxxx, s4, r24.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r34.zwzz, t6.xxxx, s4, r24.z
        mul r22.w, r22.w, r36.y
        mad r21.w, r36.x, r21.w, r22.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r30.zwzz, t6.xxxx, s4, r24.z
        mad r21.w, r36.z, r22.w, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r33.xyxx, t6.xxxx, s4, r24.z
        mad r21.w, r36.w, r22.w, r21.w
        mul r30.xyzw, r24.yyww, r31.xyzw
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r35.xyxx, t6.xxxx, s4, r24.z
        mad r21.w, r30.x, r22.w, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r35.zwzz, t6.xxxx, s4, r24.z
        mad r21.w, r30.y, r22.w, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r33.zwzz, t6.xxxx, s4, r24.z
        mad r21.w, r30.z, r22.w, r21.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r22.w, r32.xyxx, t6.xxxx, s4, r24.z
        mad r21.w, r30.w, r22.w, r21.w
        ige r22.w, r20.y, l(0)
        or r25.xyz, r25.xyzx, r29.xyzx
        or r24.x, r25.y, r25.x
        or r24.x, r25.z, r24.x
        and r24.y, r24.z, l(0x7fffffff)
        ult r24.y, l(0x7f800000), r24.y
        or r24.x, r24.y, r24.x
        mul r24.y, r24.w, r31.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.z, r32.zwzz, t6.xxxx, s4, r24.z
        mad r21.w, r24.y, r24.z, r21.w
        add r21.w, r21.w, l(-1.000000)
        mad r20.y, cb4[r20.y + 288].w, r21.w, l(1.000000)
        movc r20.y, r24.x, l(1.000000), r20.y
        movc r20.y, r22.w, r20.y, l(1.000000)
      else
        mov r20.y, l(1.000000)
      endif
      if_nz r23.z
        dp3 r21.w, r15.xyzx, r27.xyzx
        mul_sat r22.w, r20.w, cb3[r16.w + 6].z
        mad r22.w, r22.w, l(0.500000), r14.y
        min r22.w, r22.w, l(1.000000)
        div r22.w, r14.y, r22.w
        mad r24.xyz, r15.xyzx, r21.wwww, -r27.xyzx
        dp3 r23.z, r28.xyzx, r24.xyzx
        mul r21.w, r21.w, r21.w
        mad r21.w, cb3[r16.w + 6].z, cb3[r16.w + 6].z, -r21.w
        div_sat r21.w, r23.z, r21.w
        mad r24.xyz, r27.xyzx, r21.wwww, r28.xyzx
        dp3 r21.w, r24.xyzx, r24.xyzx
        rsq r21.w, r21.w
        mul r26.xyz, r21.wwww, r24.xyzx
      else
        mov r22.w, l(1.000000)
      endif
      if_nz r19.w
        mul_sat r19.w, r20.w, cb3[r19.z + 6].y
        mad r24.xyz, r8.xyzx, r4.zzzz, r26.xyzx
        dp3 r20.w, r24.xyzx, r24.xyzx
        max r20.w, r20.w, l(0.000061)
        rsq r20.w, r20.w
        mul r24.xyz, r20.wwww, r24.xyzx
        dp3_sat r20.w, r3.xyzx, r24.xyzx
        dp3_sat r21.w, r9.xyzx, r24.xyzx
        lt r23.z, l(0.000000), r19.w
        mul r19.w, r19.w, r19.w
        mad r24.x, r21.w, l(3.600000), l(0.400000)
        div r19.w, r19.w, r24.x
        mad r19.w, r11.w, r11.w, r19.w
        min r19.w, r19.w, l(1.000000)
        movc r19.w, r23.z, r19.w, r14.y
        mul r19.w, r19.w, r19.w
        mad r23.z, r20.w, r19.w, -r20.w
        mad r20.w, r23.z, r20.w, l(1.000000)
        add r21.w, -r21.w, l(1.000000)
        mul r23.z, r21.w, r21.w
        mul r23.z, r23.z, r23.z
        mul r24.x, r21.w, r23.z
        mad r21.w, -r23.z, r21.w, l(1.000000)
        mad r24.xyz, r10.xyzx, r21.wwww, r24.xxxx
        mul r20.w, r20.w, r20.w
        div r20.w, r19.w, r20.w
        mul r20.w, r22.w, r20.w
        mad r21.w, -r11.x, r19.w, r11.x
        mad r21.w, r21.w, r11.x, r19.w
        sqrt r21.w, r21.w
        mad r22.w, -r20.x, r19.w, r20.x
        mad r19.w, r22.w, r20.x, r19.w
        sqrt r19.w, r19.w
        mul r19.w, r11.x, r19.w
        mad r19.w, r20.x, r21.w, r19.w
        add r19.w, r19.w, l(0.000100)
        div r19.w, l(0.500000), r19.w
        mul r19.w, r19.w, r20.w
        mul r24.xyz, r19.wwww, r24.xyzx
        min r24.xyz, r24.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
        mad r25.xy, r20.xzxx, l(0.968750, 0.968750, 0.000000, 0.000000), l(0.015625, 0.015625, 0.000000, 0.000000)
        sample_l_indexable(texture2d)(float,float,float,float) r19.w, r25.xyxx, t9.yzwx, s1, l(0.000000)
        mul r19.w, r8.w, r19.w
        mul r19.w, r6.w, r19.w
        div r19.w, r19.w, r7.w
        mul r25.xyz, r16.xyzx, r19.wwww
        div r25.xyz, r25.xyzx, r17.xyzx
        add r24.xyz, r24.xyzx, r25.xyzx
        mul r24.xyz, r24.xyzx, cb3[r19.z + 6].zzzz
        max r24.xyz, r24.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
        min r24.xyz, r24.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
        mul r25.xyz, r12.xyzx, r20.xxxx
        mad r24.xyz, r24.xyzx, r20.xxxx, r25.xyzx
        mul r25.xyz, r19.xxxx, cb3[r18.z + 6].xyzx
        mul r20.xyw, r20.yyyy, r25.xyxz
        mul r20.xyw, r18.xxxx, r20.xyxw
        mul r20.xyw, r20.xyxw, r24.xyxz
      else
        mov r20.xyw, l(0,0,0,0)
      endif
    else
      if_z r18.y
        mad r18.x, cb3[r16.w + 6].y, l(0.500000), l(0.500000)
        add r24.x, r18.x, -|cb3[r16.w + 6].x|
        add r24.y, -r24.x, cb3[r16.w + 6].y
        add r18.x, -|r24.x|, l(1.000000)
        add r18.x, -|r24.y|, r18.x
        max r18.x, r18.x, l(0.000488)
        ge r18.y, cb3[r16.w + 6].x, l(0.000000)
        movc r24.z, r18.y, r18.x, -r18.x
        dp3 r18.x, r24.xyzx, r24.xyzx
        rsq r18.x, r18.x
        mul r24.xyz, r18.xxxx, r24.xyzx
        add r25.xyz, -r5.xyzx, cb3[r23.x + 6].xyzx
        dp3 r18.x, r25.xyzx, r25.xyzx
        rsq r18.y, r18.x
        mul r26.xyz, r18.yyyy, r25.xyzx
        ftoi r18.y, cb3[r19.z + 6].w
        mul r19.xzw, r24.xxyz, cb3[r16.w + 6].zzzz
        mad r27.xyz, -r19.xzwx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
        mad r19.xzw, r19.xxzw, l(0.500000, 0.000000, 0.500000, 0.500000), r25.xxyz
        ftou r18.z, cb3[r18.z + 6].w
        and r18.z, r18.z, l(1)
        ieq r21.w, r18.z, l(0)
        not r21.w, r21.w
        lt r22.w, l(0.000000), cb3[r16.w + 6].z
        and r21.w, r21.w, r22.w
        dp3 r22.w, r27.xyzx, r27.xyzx
        sqrt r22.w, r22.w
        dp3 r23.z, r19.xzwx, r19.xzwx
        sqrt r23.z, r23.z
        dp3 r19.x, r27.xyzx, r19.xzwx
        mad r19.x, r22.w, r23.z, r19.x
        mad r19.x, r19.x, l(0.500000), l(1.000000)
        div r19.x, l(1.000000, 1.000000, 1.000000, 1.000000), r19.x
        movc r19.x, r21.w, r19.x, l(1.000000)
        lt r19.z, cb3[r23.w + 6].w, l(0.000000)
        if_nz r19.z
          mul r19.z, cb3[r23.x + 6].w, cb3[r23.x + 6].w
          mul r19.z, r18.x, r19.z
          mad r19.z, -r19.z, r19.z, l(1.000000)
          max r19.z, r19.z, l(0.000000)
          add r18.x, r18.x, l(1.000000)
          div r18.x, l(1.000000, 1.000000, 1.000000, 1.000000), r18.x
          and r19.w, r21.w, l(0x3f800000)
          add r22.w, -r18.x, r19.x
          mad r18.x, r19.w, r22.w, r18.x
          mul r19.z, r19.z, r19.z
          mul r18.x, r18.x, r19.z
        else
          mul r27.xyz, r25.xyzx, cb3[r23.x + 6].wwww
          dp3 r19.z, r27.xyzx, r27.xyzx
          min r19.z, r19.z, l(1.000000)
          add r19.z, -r19.z, l(1.000000)
          log r19.z, r19.z
          mul r19.z, r19.z, cb3[r23.w + 6].w
          exp r19.z, r19.z
          mul r18.x, r19.z, r19.x
        endif
        dp3 r19.x, r26.xyzx, -r24.xyzx
        add r19.x, r19.x, -cb3[r16.w + 6].z
        mul_sat r19.x, r19.x, cb3[r16.w + 6].w
        mul r19.x, r19.x, r19.x
        movc r19.x, r18.z, l(1.000000), r19.x
        mul r18.x, r18.x, r19.x
        not r19.x, r21.w
        ige r19.z, r18.y, l(0)
        and r19.x, r19.z, r19.x
        if_nz r19.x
          if_z r18.z
            ishl r19.x, r18.y, l(2)
            mul r24.xyz, r5.yyyy, cb5[r19.x + 33].xywx
            mad r24.xyz, cb5[r19.x + 32].xywx, r5.xxxx, r24.xyzx
            mad r24.xyz, cb5[r19.x + 34].xywx, r5.zzzz, r24.xyzx
            add r19.xzw, r24.xxyz, cb5[r19.x + 35].xxyw
            div_sat r19.xz, r19.xxzx, r19.wwww
            mad r19.xz, r19.xxzx, cb5[r18.y + 0].zzwz, cb5[r18.y + 0].xxyx
          else
            ishl r19.w, r18.y, l(2)
            dp3 r24.x, -r25.xyzx, cb5[r19.w + 32].xyzx
            dp3 r24.y, -r25.xyzx, cb5[r19.w + 33].xyzx
            dp3 r24.z, -r25.xyzx, cb5[r19.w + 34].xyzx
            lt r19.w, |r24.x|, |r24.y|
            and r19.w, r19.w, l(1)
            dp2 r21.w, |r24.xyxx|, icb[r19.w + 0].xyxx
            lt r21.w, r21.w, |r24.z|
            movc r19.w, r21.w, l(2), r19.w
            dp3 r21.w, r24.xyzx, icb[r19.w + 0].xyzx
            lt r21.w, r21.w, l(0.000000)
            bfi r19.w, l(31), l(1), r19.w, r21.w
            ushr r21.w, r19.w, l(1)
            dp3 r21.w, r24.xyzx, icb[r21.w + 0].xyzx
            div r22.w, l(0.000244), cb5[r18.y + 0].w
            add r22.w, -r22.w, l(0.500000)
            utof r23.z, r19.w
            ult r23.w, r19.w, l(2)
            and r23.w, r23.w, l(2)
            dp2 r23.w, r24.xzxx, icb[r23.w + 0].xzxx
            mul r23.w, r23.w, icb[r19.w + 4].z
            div r23.w, r23.w, |r21.w|
            mad r23.z, r23.w, r22.w, r23.z
            add r23.z, r23.z, l(0.500000)
            mul_sat r25.x, r23.z, l(0.166667)
            iadd r23.z, l(-1), icb[r19.w + 4].y
            dp2 r23.z, r24.yzyy, icb[r23.z + 0].xyxx
            mul r19.w, r23.z, icb[r19.w + 4].w
            div r19.w, r19.w, |r21.w|
            mad_sat r25.y, -r19.w, r22.w, l(0.500000)
            mad r19.xz, r25.xxyx, cb5[r18.y + 0].zzwz, cb5[r18.y + 0].xxyx
          endif
          sample_l_indexable(texture2d)(float,float,float,float) r18.y, r19.xzxx, t11.yxzw, s1, l(0.000000)
          mul r18.x, r18.y, r18.x
        endif
        lt r18.x, l(0.000000), r18.x
        if_nz r18.x
          if_z r18.z
            ftoi r18.x, cb3[r23.y + 6].x
          else
            add r19.xzw, r5.xxyz, -cb3[r23.x + 6].xxyz
            lt r23.xzw, |r19.zzww|, |r19.xxxz|
            and r18.y, r23.z, r23.x
            lt r19.xzw, l(0.000000, 0.000000, 0.000000, 0.000000), r19.xxzw
            ushr r18.z, cb3[r16.w + 6].w, l(24)
            ubfe r23.xz, l(8, 0, 8, 0), l(16, 0, 8, 0), cb3[r16.w + 6].wwww
            movc r18.z, r19.x, r18.z, r23.x
            and r16.w, l(255), cb3[r16.w + 6].w
            movc r16.w, r19.z, r23.z, r16.w
            ubfe r19.x, l(8), l(8), cb3[r23.y + 6].x
            and r19.z, l(255), cb3[r23.y + 6].x
            movc r19.x, r19.w, r19.x, r19.z
            movc r16.w, r23.w, r16.w, r19.x
            movc r16.w, r18.y, r18.z, r16.w
            ilt r18.y, r16.w, l(80)
            movc r18.x, r18.y, r16.w, l(-1)
          endif
          ishl r16.w, r18.x, l(2)
          mad r19.xzw, r26.xxyz, cb4[r18.x + 288].xxxx, r5.xxyz
          mul r18.y, l(5.000000), cb4[r18.x + 288].y
          mad r19.xzw, r3.xxyz, r18.yyyy, r19.xxzw
          mul r23.xyzw, r19.zzzz, cb4[r16.w + 65].xyzw
          mad r23.xyzw, cb4[r16.w + 64].xyzw, r19.xxxx, r23.xyzw
          mad r23.xyzw, cb4[r16.w + 66].xyzw, r19.wwww, r23.xyzw
          add r23.xyzw, r23.xyzw, cb4[r16.w + 67].xyzw
          div r19.xzw, r23.xxyz, r23.wwww
          ge r23.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r19.xzwx
          ge r24.xyz, r19.xzwx, l(1.000000, 1.000000, 1.000000, 0.000000)
          add r18.yz, -cb4[r18.x + 344].xxyx, cb4[r18.x + 344].zzwz
          mad r18.yz, r19.xxzx, r18.yyzy, cb4[r18.x + 344].xxyx
          mad r19.xz, r18.yyzy, cb4[400].zzwz, l(0.500000, 0.000000, 0.500000, 0.000000)
          round_ni r19.xz, r19.xxzx
          mad r18.yz, r18.yyzy, cb4[400].zzwz, -r19.xxzx
          add r25.xyzw, r18.yyzz, l(0.500000, 1.000000, 0.500000, 1.000000)
          mul r26.xyzw, r25.xxzz, r25.xxzz
          add r25.xz, -r18.yyzy, l(1.000000, 0.000000, 1.000000, 0.000000)
          min r27.xy, r18.yzyy, l(0.000000, 0.000000, 0.000000, 0.000000)
          max r27.zw, r18.yyyz, l(0.000000, 0.000000, 0.000000, 0.000000)
          mul r28.xy, r25.xzxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r27.zw, -r27.zzzw, r27.zzzw, r25.yyyw
          add r27.zw, r27.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
          mul r29.xy, r27.zwzz, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r26.xz, r26.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
          mad r18.yz, r26.yywy, l(0.000000, 0.500000, 0.500000, 0.000000), -r18.yyzy
          mul r30.xy, r18.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r18.yz, -r27.xxyx, r27.xxyx, r25.xxzx
          add r18.yz, r18.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
          mul r27.xy, r18.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r18.yz, r25.yywy, l(0.000000, 0.160000, 0.160000, 0.000000)
          mov r30.z, r27.x
          mov r30.w, r18.y
          mov r28.z, r29.x
          mov r28.w, r26.x
          add r25.xyzw, r28.zwxz, r30.zwxz
          mov r27.z, r30.y
          mov r27.w, r18.z
          mov r29.z, r28.y
          mov r29.w, r26.z
          add r26.xyz, r27.zywz, r29.zywz
          div r27.xyz, r28.xzwx, r25.zwyz
          add r27.xyz, r27.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r27.xyz, r27.yxzy, cb4[400].xxxx
          div r28.xyz, r29.zywz, r26.xyzx
          add r28.xyz, r28.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r28.xyz, r28.xyzx, cb4[400].yyyy
          mov r27.w, r28.x
          mad r29.xyzw, r19.xzxz, cb4[400].xyxy, r27.ywxw
          mad r18.yz, r19.xxzx, cb4[400].xxyx, r27.zzwz
          mov r28.w, r27.y
          mov r27.yw, r28.yyyz
          mad r30.xyzw, r19.xzxz, cb4[400].xyxy, r27.xyzy
          mad r28.xyzw, r19.xzxz, cb4[400].xyxy, r28.wywz
          mad r27.xyzw, r19.xzxz, cb4[400].xyxy, r27.xwzw
          mul r31.xyzw, r25.zwyz, r26.xxxy
          sample_c_lz_indexable(texture2d)(float,float,float,float) r16.w, r29.xyxx, t6.xxxx, s4, r19.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r19.x, r29.zwzz, t6.xxxx, s4, r19.w
          mul r19.x, r19.x, r31.y
          mad r16.w, r31.x, r16.w, r19.x
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r18.yzyy, t6.xxxx, s4, r19.w
          mad r16.w, r31.z, r18.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r28.xyxx, t6.xxxx, s4, r19.w
          mad r16.w, r31.w, r18.y, r16.w
          mul r29.xyzw, r25.xyzw, r26.yyzz
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r30.xyxx, t6.xxxx, s4, r19.w
          mad r16.w, r29.x, r18.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r30.zwzz, t6.xxxx, s4, r19.w
          mad r16.w, r29.y, r18.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r28.zwzz, t6.xxxx, s4, r19.w
          mad r16.w, r29.z, r18.y, r16.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r27.xyxx, t6.xxxx, s4, r19.w
          mad r16.w, r29.w, r18.y, r16.w
          ige r18.y, r18.x, l(0)
          or r23.xyz, r23.xyzx, r24.xyzx
          or r18.z, r23.y, r23.x
          or r18.z, r23.z, r18.z
          and r19.x, r19.w, l(0x7fffffff)
          ult r19.x, l(0x7f800000), r19.x
          or r18.z, r18.z, r19.x
          mul r19.x, r25.y, r26.z
          sample_c_lz_indexable(texture2d)(float,float,float,float) r19.z, r27.zwzz, t6.xxxx, s4, r19.w
          mad r16.w, r19.x, r19.z, r16.w
          add r16.w, r16.w, l(-1.000000)
          mad r16.w, cb4[r18.x + 288].w, r16.w, l(1.000000)
          movc r16.w, r18.z, l(1.000000), r16.w
          movc r16.w, r18.y, r16.w, l(1.000000)
        else
          mov r16.w, l(1.000000)
        endif
      else
        mov r16.w, l(1.000000)
      endif
      mul r12.w, r12.w, r16.w
      mov r20.xyw, l(0,0,0,0)
    endif
    add r22.xyz, r20.xywx, r22.xyzx
    mov r15.w, r17.w
  endloop
  mov r9.w, r12.w
  add r21.xyz, r21.xyzx, r22.xyzx
  iadd r10.w, r10.w, l(1)
endloop
mad r8.xyz, r21.xyzx, r9.wwww, r14.xzwx
ne r11.xy, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[112].xyxx
if_nz r11.x
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t4.yzxw, s0, cb0[108].x
  min r0.z, r1.y, r0.z
  add r1.x, r0.z, r13.x
  mad r2.z, r11.w, l(-16.000000), l(-1.000000)
  exp r2.z, r2.z
  log r1.x, |r1.x|
  mul r1.x, r1.x, r2.z
  exp r1.x, r1.x
  add r1.x, r0.z, r1.x
  add r1.x, r1.x, l(-1.000000)
  mov_sat r14.xyz, r1.xxxx
  mad r16.xyz, r12.xyzx, l(2.040400, 2.040400, 2.040400, 0.000000), l(-0.332400, -0.332400, -0.332400, 0.000000)
  mul r16.xyz, r0.zzzz, r16.xyzx
  mad r16.xyz, r12.xyzx, l(-4.795100, -4.795100, -4.795100, 0.000000), r16.xyzx
  add r16.xyz, r16.xyzx, l(0.641700, 0.641700, 0.641700, 0.000000)
  mul r16.xyz, r0.zzzz, r16.xyzx
  mad r16.xyz, r12.xyzx, l(2.755200, 2.755200, 2.755200, 0.000000), r16.xyzx
  add r16.xyz, r16.xyzx, l(0.690300, 0.690300, 0.690300, 0.000000)
  mul r16.xyz, r0.zzzz, r16.xyzx
  max r16.xyz, r0.zzzz, r16.xyzx
else
  mov r14.xyz, r1.yyyy
  mov r16.xyz, r1.yyyy
endif
mad r17.xyz, r3.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r5.xyzx
round_z r0.z, cb0[216].x
mad r1.xy, r0.zzzz, l(2.083000, 4.867000, 0.000000, 0.000000), r2.xyxx
dp2 r0.z, r1.xyxx, l(0.067111, 0.005837, 0.000000, 0.000000)
frc r0.z, r0.z
mul r0.z, r0.z, l(52.982918)
frc r0.z, r0.z
mad r0.z, r0.z, l(2.000000), l(-1.000000)
mad r17.xyz, r0.zzzz, l(0.200000, 0.200000, 0.200000, 0.000000), r17.xyzx
mad r18.xyz, cb0[6].xzyx, -cb0[216].wwww, cb0[214].xzyx
add r18.xyz, r17.xzyx, -r18.xyzx
max r0.z, |r18.y|, |r18.x|
add r0.z, r0.z, l(-464.000000)
mul_sat r0.z, r0.z, l(0.031250)
add r1.x, |r18.z|, l(-208.000000)
mul_sat r1.x, r1.x, l(0.031250)
max r0.z, r0.z, r1.x
ne r1.x, l(0.000000), cb0[214].w
lt r1.y, r0.z, l(1.000000)
and r1.x, r1.y, r1.x
if_nz r1.x
  mad r18.xyz, cb0[6].xzyx, -cb0[216].yyyy, cb0[214].xzyx
  add r18.xyz, r17.xzyx, -r18.xyzx
  max r1.x, |r18.y|, |r18.x|
  add r1.x, r1.x, l(-29.000000)
  add r1.y, |r18.z|, l(-13.000000)
  mul_sat r1.xy, r1.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  max r1.x, r1.y, r1.x
  lt r1.y, r1.x, l(1.000000)
  if_nz r1.y
    mad r18.xyz, r17.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r19.xyz, r18.xyzx, cb0[215].xyzx
    round_ni r19.xyz, r19.xyzx
    mad r18.xyz, r18.xyzx, cb0[215].xyzx, -r19.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyw, r18.xyzx, t15.yzwx, s2, l(0.000000)
    add r1.y, -r1.x, l(1.000000)
    mul r2.z, l(0.500000), cb0[215].y
    mad r6.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r2.z, r2.z, r18.y
    min r2.z, r6.w, r2.z
    mul r18.w, r2.z, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyzw, r18.xwzx, t16.xyzw, s1, l(0.000000)
    mad r2.z, r20.w, r1.y, r0.z
    add r21.xyz, r18.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyz, r21.xyzx, t16.xyzw, s1, l(0.000000)
    mad r21.xyz, r21.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r19.yyyy, r21.xyzx
    mov r21.w, r19.y
    mul r21.xyzw, r1.yyyy, r21.xyzw
    add r18.xyz, r18.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyz, r18.xyzx, t16.xyzw, s1, l(0.000000)
    mad r18.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r18.xyz, r19.xxxx, r18.xyzx
    mov r18.w, r19.x
    mul r18.xyzw, r1.yyyy, r18.xyzw
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r19.xyz, r19.wwww, r20.xyzx
    mul r19.xyzw, r1.yyyy, r19.xyzw
  else
    mov r21.xyzw, l(0,0,0,0)
    mov r18.xyzw, l(0,0,0,0)
    mov r19.xyzw, l(0,0,0,0)
    mov r2.z, r0.z
  endif
  mad r20.xyz, cb0[6].xzyx, -cb0[216].zzzz, cb0[214].xzyx
  add r20.xyz, r17.xzyx, -r20.xyzx
  max r1.y, |r20.y|, |r20.x|
  add r1.y, r1.y, l(-116.000000)
  mul_sat r1.y, r1.y, l(0.125000)
  add r6.w, |r20.z|, l(-52.000000)
  mul_sat r6.w, r6.w, l(0.125000)
  max r1.y, r1.y, r6.w
  lt r6.w, r1.y, l(1.000000)
  if_nz r6.w
    mad r20.xyz, r17.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r22.xyz, r20.xyzx, cb0[215].xyzx
    round_ni r22.xyz, r22.xyzx
    mad r20.xyz, r20.xyzx, cb0[215].xyzx, -r22.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyw, r20.xyzx, t17.yzwx, s2, l(0.000000)
    add r6.w, -r1.y, l(1.000000)
    mul r1.x, r1.x, r6.w
    mul r6.w, l(0.500000), cb0[215].y
    mad r7.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r6.w, r6.w, r20.y
    min r6.w, r7.w, r6.w
    mul r20.w, r6.w, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r23.xyzw, r20.xwzx, t18.xyzw, s1, l(0.000000)
    mad r2.z, r23.w, r1.x, r2.z
    add r24.xyz, r20.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r24.xyz, r24.xyzx, t18.xyzw, s1, l(0.000000)
    mad r24.xyz, r24.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r24.xyz, r22.yyyy, r24.xyzx
    mov r24.w, r22.y
    mad r21.xyzw, r24.xyzw, r1.xxxx, r21.xyzw
    add r20.xyz, r20.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyz, r20.xyzx, t18.xyzw, s1, l(0.000000)
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r22.xxxx, r20.xyzx
    mov r20.w, r22.x
    mad r18.xyzw, r20.xyzw, r1.xxxx, r18.xyzw
    mad r20.xyz, r23.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r22.xyz, r22.wwww, r20.xyzx
    mad r19.xyzw, r22.xyzw, r1.xxxx, r19.xyzw
  endif
  lt r1.x, l(0.000000), r1.y
  if_nz r1.x
    mad r17.xyz, r17.xyzx, l(0.125000, 0.125000, 0.125000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r20.xyz, r17.xyzx, cb0[215].xyzx
    mul r22.xyz, l(0.500000, 0.500000, 0.500000, 0.000000), cb0[215].xyzx
    round_ni r20.xyz, r20.xyzx
    mad r17.xyz, r17.xyzx, cb0[215].xyzx, -r20.xyzx
    mad r20.xyz, -cb0[215].xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
    max r17.xyz, r22.xyzx, r17.xyzx
    min r17.xyz, r20.xyzx, r17.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r23.xyw, r17.xyzx, t19.yzwx, s2, l(0.000000)
    add r1.x, -r0.z, l(1.000000)
    mul r1.x, r1.x, r1.y
    max r1.y, r22.y, r17.y
    min r1.y, r20.y, r1.y
    mul r17.w, r1.y, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyzw, r17.xwzx, t20.xyzw, s1, l(0.000000)
    add r22.xyz, r17.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyz, r22.xyzx, t20.xyzw, s1, l(0.000000)
    mad r22.xyz, r22.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r22.xyz, r23.yyyy, r22.xyzx
    mov r22.w, r23.y
    mad r21.xyzw, r22.xyzw, r1.xxxx, r21.xyzw
    add r17.xyz, r17.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r17.xyz, r17.xyzx, t20.xyzw, s1, l(0.000000)
    mad r17.xyz, r17.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r17.xyz, r23.xxxx, r17.xyzx
    mov r17.w, r23.x
    mad r18.xyzw, r17.xyzw, r1.xxxx, r18.xyzw
    mad r17.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r23.xyz, r23.wwww, r17.xyzx
    mad r19.xyzw, r23.xyzw, r1.xxxx, r19.xyzw
    mad r2.z, r20.w, r1.x, r2.z
  endif
  mad_sat r1.x, r2.z, l(2.000000), l(-1.000000)
  add r17.x, -r0.z, r1.x
  add r0.z, r0.z, r1.x
  mul r17.y, r0.z, l(0.500000)
else
  mov r21.xyzw, l(0,0,0,0)
  mov r18.xyzw, l(0,0,0,0)
  mov r19.xyzw, l(0,0,0,0)
  mov r17.xy, l(0,1.000000,0,0)
endif
mul r20.xyzw, r17.yxyy, cb0[217].ywzx
mad r20.y, r20.y, l(0.500000), r20.x
mul r1.xy, r17.yxyy, cb0[217].wyww
mad r20.x, r1.y, l(0.375000), r1.x
add r19.xyzw, r19.xyzw, r20.wyzx
mul r20.xyzw, r17.yxyy, cb0[218].ywzx
mad r20.y, r20.y, l(0.500000), r20.x
mul r1.xy, r17.yxyy, cb0[218].wyww
mad r20.x, r1.y, l(0.375000), r1.x
add r18.xyzw, r18.xyzw, r20.wyzx
mul r20.xyzw, r17.yxyy, cb0[219].ywzx
mad r20.y, r20.y, l(0.500000), r20.x
mul r1.xy, r17.yxyy, cb0[219].wyww
mad r20.x, r1.y, l(0.375000), r1.x
add r17.xyzw, r20.wyzx, r21.xyzw
ge r1.xy, r4.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
and r0.z, r1.y, r1.x
if_nz r0.z
  sample_l_indexable(texture2d)(float,float,float,float) r20.xyzw, r4.xyxx, t14.xyzw, s1, l(0.000000)
  lt r21.xyzw, l(0.000100, 0.000100, 0.000100, 0.000100), |r20.xyzw|
  or r1.xy, r21.zwzz, r21.xyxx
  or r0.z, r1.y, r1.x
  if_nz r0.z
    dp3 r0.z, r20.yzwy, r20.yzwy
    sqrt r0.z, r0.z
    mov r1.x, l(1.000000)
    mov r1.y, r0.z
    mov r2.z, l(0)
    loop
      ge r4.x, l(4.600000), r1.y
      breakc_nz r4.x
      iadd r4.x, r2.z, l(1)
      mul r11.xz, r1.xxyx, l(0.500000, 0.000000, 0.500000, 0.000000)
      mov r1.xy, r11.xzxx
      mov r2.z, r4.x
      continue
    endloop
    mul r20.xyzw, r1.xxxx, r20.xyzw
    dp3 r0.z, r20.yzwy, r20.yzwy
    sqrt r0.z, r0.z
    mad r0.z, r0.z, cb6[3].x, cb6[3].y
    mad r0.z, r0.z, l(255.000000), l(0.500000)
    mul r1.x, r0.z, l(0.003906)
    mov r1.y, l(0.500000)
    sample_l_indexable(texture2d)(float,float,float,float) r1.xy, r1.xyxx, t13.xyzw, s1, l(0.000000)
    mad r1.xy, r1.xyxx, cb6[2].xyxx, cb6[2].zwzz
    mul r21.x, r1.x, l(3.544908)
    mul r21.yzw, r1.yyyy, r20.yyzw
    mul r0.z, r20.x, l(0.406977)
    exp r0.z, r0.z
    mul r20.xyzw, r0.zzzz, r21.xyzw
    mov r21.xyzw, r20.xyzw
    mov r0.z, l(0)
    loop
      uge r1.x, r0.z, r2.z
      breakc_nz r1.x
      mul r22.xyzw, r21.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
      dp4 r1.x, r22.xyzw, r21.xyzw
      dp2 r1.y, r22.yxyy, r21.xyxx
      dp2 r4.x, r22.zxzz, r21.xzxx
      dp2 r4.y, r22.wxww, r21.xwxx
      iadd r6.w, r0.z, l(1)
      mov r21.xy, r1.xyxx
      mov r21.zw, r4.xxxy
      mov r0.z, r6.w
      continue
    endloop
    mul r20.xyzw, r21.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
    mul r21.xyzw, r19.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r0.z, r20.xyzw, r21.xyzw
    dp2 r1.x, r20.yxyy, r21.xyxx
    dp2 r1.y, r20.zxzz, r21.xzxx
    dp2 r2.z, r20.wxww, r21.xwxx
    mul r21.xyzw, r18.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r4.x, r20.xyzw, r21.xyzw
    dp2 r4.y, r20.yxyy, r21.xyxx
    dp2 r6.w, r20.zxzz, r21.xzxx
    dp2 r7.w, r20.wxww, r21.xwxx
    mul r21.xyzw, r17.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r8.w, r20.xyzw, r21.xyzw
    dp2 r9.w, r20.yxyy, r21.xyxx
    dp2 r10.w, r20.zxzz, r21.xzxx
    dp2 r11.x, r20.wxww, r21.xwxx
    mul r19.w, r0.z, l(0.886227)
    mul r19.x, r2.z, l(-1.023327)
    mul r19.yz, r1.xxyx, l(0.000000, -1.023327, 1.023327, 0.000000)
    mul r18.x, r7.w, l(-1.023327)
    mul r18.yw, r4.yyyx, l(0.000000, -1.023327, 0.000000, 0.886227)
    mul r18.z, r6.w, l(1.023327)
    mul r17.w, r8.w, l(0.886227)
    mul r17.x, r11.x, l(-1.023327)
    mul r17.y, r9.w, l(-1.023327)
    mul r17.z, r10.w, l(1.023327)
  endif
endif
dp3 r0.z, r19.xyzx, r3.xyzx
add r0.z, r19.w, r0.z
max r19.x, r0.z, l(0.000000)
dp3 r0.z, r18.xyzx, r3.xyzx
add r0.z, r18.w, r0.z
max r19.y, r0.z, l(0.000000)
dp3 r0.z, r17.xyzx, r3.xyzx
add r0.z, r17.w, r0.z
max r19.z, r0.z, l(0.000000)
add r0.z, l(-1.000000), cb0[113].x
max r1.x, r11.w, l(0.001000)
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
mul r11.xzw, r19.xxyz, cb0[111].xxxx
dp3 r1.y, r11.xzwx, l(0.212673, 0.715152, 0.072175, 0.000000)
mov r40.x, r1.y  // Store ambient luminance for cubemap modulation
mov r5.w, l(1.000000)
mov r3.w, l(1.000000)
mov r11.xzw, l(0,0,0,0)
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
    dp4 r17.x, cb1[r7.w + 6].xyzw, r5.xyzw
    dp4 r17.y, cb1[r7.w + 7].xyzw, r5.xyzw
    dp4 r17.z, cb1[r7.w + 8].xyzw, r5.xyzw
    ge r18.xyz, cb1[r7.w + 5].xyzx, |r17.xyzx|
    and r8.w, r18.y, r18.x
    and r8.w, r18.z, r8.w
    if_nz r8.w
      mul r8.w, l(0.100000), cb1[r7.w + 5].x
      mul r18.xyz, |r17.xyzx|, l(0.100000, 0.100000, 0.100000, 0.000000)
      mul r18.xy, r18.xyxx, r18.xyxx
      add r20.xyz, -|r17.xyzx|, cb1[r7.w + 5].xyzx
      mul r20.xyz, r20.xyzx, cb1[r7.w + 9].xyzx
      eq r9.w, l(1.000000), cb1[r7.w + 10].x
      if_nz r9.w
        dp3 r21.x, cb1[r7.w + 6].xyzx, r15.xyzx
        dp3 r21.y, cb1[r7.w + 7].xyzx, r15.xyzx
        dp3 r21.z, cb1[r7.w + 8].xyzx, r15.xyzx
        add r22.xyz, -r17.xyzx, cb1[r7.w + 5].xyzx
        div r22.xyz, r22.xyzx, r21.xyzx
        add r23.xyz, -r17.xyzx, -cb1[r7.w + 5].xyzx
        div r23.xyz, r23.xyzx, r21.xyzx
        lt r24.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r21.xyzx
        movc r22.xyz, r24.xyzx, r22.xyzx, r23.xyzx
        min r9.w, r22.y, r22.x
        min r9.w, r22.z, r9.w
        mad r17.xyz, r21.xyzx, r9.wwww, r17.xyzx
      else
        mov r17.xyz, r15.xyzx
      endif
      dp3 r9.w, r17.xyzx, r17.xyzx
      rsq r9.w, r9.w
      mul r17.xyz, r9.wwww, r17.xyzx
      lt r21.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r17.xyzx
      lt r22.xyz, r17.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
      iadd r21.xyz, -r21.xyzx, r22.xyzx
      itof r21.xyz, r21.xyzx
      dp3 r9.w, r17.xyzx, r21.xyzx
      div r17.xyz, r17.xyzx, r9.wwww
      lt r9.w, r17.z, l(0.000000)
      add r17.zw, -|r17.yyyx|, l(0.000000, 0.000000, 1.000000, 1.000000)
      mul r17.zw, r17.zzzw, r21.xxxy
      movc r17.xy, r9.wwww, r17.zwzz, r17.xyxx
      dp4 r9.w, cb1[r7.w + 4].xyzw, r3.xyzw
      max r9.w, r9.w, l(0.000000)
      max r9.w, r9.w, l(0.000100)
      min r10.w, r20.z, r20.y
      min r10.w, r10.w, r20.x
      add r12.w, r18.y, r18.x
      mad r12.w, r18.z, r18.z, r12.w
      mad r8.w, r8.w, r8.w, -r12.w
      mul r8.w, r8.w, cb1[r7.w + 9].x
      mul r8.w, r8.w, cb1[r7.w + 9].x
      add r12.w, l(1.000000), -cb1[r7.w + 10].y
      mul r8.w, r8.w, r12.w
      mul r8.w, r8.w, l(100.000000)
      mad_sat r8.w, r10.w, cb1[r7.w + 10].y, r8.w
      mul r10.w, r8.w, cb1[r7.w + 10].w
      mad r17.xy, r17.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
      mad r17.xy, r17.xyxx, cb1[1].wwww, cb1[2].wwww
      mov r17.z, cb1[r7.w + 5].w
      sample_l_indexable(texture2darray)(float,float,float,float) r17.xyz, r17.xyzx, t5.xyzw, s3, r0.z
      mul r17.xyz, r17.xyzx, cb1[r7.w + 9].wwww
      div r12.w, r1.y, r9.w
      min r12.w, |r12.w|, l(1.000000)
      mad r12.w, r12.w, l(2.000000), r1.y
      add r9.w, r9.w, l(2.000000)
      div r9.w, r12.w, r9.w
      add r9.w, r9.w, l(-1.000000)
      mad r9.w, r9.w, cb0[112].w, l(1.000000)
      mul r17.xyz, r9.wwww, r17.xyzx
      mul r17.xyz, r10.wwww, r17.xyzx
      mad r11.xzw, r17.xxyz, r2.zzzz, r11.xxzw
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
  dp3 r1.x, r15.xyzx, r15.xyzx
  rsq r1.x, r1.x
  mul r15.xyz, r1.xxxx, r15.xyzx
  lt r17.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r15.xyzx
  lt r18.xyz, r15.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  iadd r17.xyz, -r17.xyzx, r18.xyzx
  itof r17.xyz, r17.xyzx
  dp3 r1.x, r15.xyzx, r17.xyzx
  div r15.xyz, r15.xyzx, r1.xxxx
  lt r1.x, r15.z, l(0.000000)
  add r4.xy, -|r15.yxyy|, l(1.000000, 1.000000, 0.000000, 0.000000)
  mul r4.xy, r4.xyxx, r17.xyxx
  movc r4.xy, r1.xxxx, r4.xyxx, r15.xyxx
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
  mad r11.xzw, r3.xxyz, r2.zzzz, r11.xxzw
endif
mul r3.xyz, r11.xzwx, cb0[112].zzzz
mul r3.xyz, r3.xyzx, cb0[111].yyyy
// Cubemap ambient link modulation (cb13[13].y)
if_nz cb13[13].y
  max r40.x, r40.x, l(0.000000)
  min r40.x, r40.x, l(1.000000)
  mad r40.x, r40.x, l(0.750000), l(0.250000)
  mul r3.xyz, r3.xyzx, r40.xxxx
endif
if_nz r11.y
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t3.yzxw, s1, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r11.xyz, v1.xyxx, t2.xyzw, s1, cb0[108].x
  add r1.x, -r0.z, l(1.000000)
  mul r15.xyz, r1.xxxx, r3.xyzx
  mad r3.xyz, r11.xyzx, r0.zzzz, r15.xyzx
endif
mul r11.xyz, r12.xyzx, r19.xyzx
mul r11.xyz, r11.xyzx, cb0[111].xxxx
add r0.z, -r1.z, l(1.000000)
div r0.z, r0.z, r1.z
mul r1.xyz, r0.zzzz, r10.xyzx
mad r1.xyz, r1.xyzx, r13.yzwy, r13.yzwy
mul r1.xyz, r1.xyzx, r3.xyzx
mul r1.xyz, r14.xyzx, r1.xyzx
mad r1.xyz, r11.xyzx, r16.xyzx, r1.xyzx
add r1.xyz, r1.xyzx, r8.xyzx
max r1.xyz, r1.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
min r1.xyz, r1.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
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
dp3 r0.z, -r9.xyzx, cb0[154].xyzx
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
  dp3 r0.x, -r9.xyzx, -r7.xyzx
  add r3.w, r5.y, -cb0[44].y
  lt r5.w, l(0.000000), r0.x
  div r0.x, l(1.000000, 1.000000, 1.000000, 1.000000), r0.x
  and r0.x, r0.x, r5.w
  mul r0.x, r0.x, cb0[165].w
  div r5.w, l(1.000000, 1.000000, 1.000000, 1.000000), r4.w
  mul r6.w, r0.x, r5.w
  mad r7.x, r6.w, r3.w, cb0[44].y
  mad r3.w, -r6.w, r3.w, r3.w
  mad r0.x, -r0.x, r5.w, l(1.000000)
  mul r5.w, r4.w, r0.x
  mul r6.w, r3.w, cb0[159].z
  max r6.w, r6.w, l(-127.000000)
  mul r3.w, r3.w, cb0[162].x
  max r3.w, r3.w, l(-127.000000)
  add r7.y, r7.x, -cb0[159].x
  mul r7.y, r7.y, cb0[159].z
  max r7.y, r7.y, l(-127.000000)
  exp r7.y, -r7.y
  mul r7.y, r7.y, cb0[159].y
  lt r7.z, l(0.000000), |r6.w|
  exp r7.w, -r6.w
  add r7.w, -r7.w, l(1.000000)
  div r7.w, r7.w, r6.w
  mad r6.w, -r6.w, l(0.240227), l(0.693147)
  movc r6.w, r7.z, r7.w, r6.w
  add r7.x, r7.x, -cb0[162].z
  mul r7.x, r7.x, cb0[162].x
  max r7.x, r7.x, l(-127.000000)
  exp r7.x, -r7.x
  mul r7.x, r7.x, cb0[162].y
  lt r7.z, l(0.000000), |r3.w|
  exp r7.w, -r3.w
  add r7.w, -r7.w, l(1.000000)
  div r7.w, r7.w, r3.w
  mad r3.w, -r3.w, l(0.240227), l(0.693147)
  movc r3.w, r7.z, r7.w, r3.w
  mul r3.w, r3.w, r7.x
  mad r3.w, r7.y, r6.w, r3.w
  mad_sat r7.xy, r4.wwww, cb0[160].wyww, cb0[160].zxzz
  mul r5.w, r5.w, r3.w
  exp r5.w, -r5.w
  min r5.w, r5.w, l(1.000000)
  max r5.w, r5.w, cb0[161].w
  add r5.w, r7.y, r5.w
  add r5.w, r7.x, r5.w
  min r5.w, r5.w, l(1.000000)
  imad r4.y, r0.w, r4.x, r0.y
  ushr r0.yw, r4.xxxy, l(0, 16, 0, 16)
  utof r0.yw, r0.yyyw
  mad r0.yw, r0.yyyw, l(0.000000, 0.000031, 0.000000, 0.000031), l(0.000000, -1.000000, 0.000000, -1.000000)
  mad r0.yw, r0.yyyw, cb0[169].wwww, r2.xxxy
  mul r8.xy, r0.ywyy, cb0[167].xyxx
  mad r0.y, |r1.w|, cb0[166].x, cb0[166].y
  log r0.y, r0.y
  mul r0.y, r0.y, cb0[166].z
  div r8.z, r0.y, cb0[165].z
  sample_l_indexable(texture3d)(float,float,float,float) r8.xyzw, r8.xyzx, t12.xyzw, s1, l(0.000000)
  add r0.y, |r1.w|, -cb0[168].z
  mul_sat r0.y, r0.y, l(1000000.000000)
  add r8.xyzw, r8.xyzw, l(-0.000000, -0.000000, -0.000000, -1.000000)
  mad r8.xyzw, r0.yyyy, r8.xyzw, l(0.000000, 0.000000, 0.000000, 1.000000)
  add r0.y, -r5.w, l(1.000000)
  dp3_sat r0.w, r9.xyzx, cb0[163].xyzx
  log r0.w, r0.w
  mul r0.w, r0.w, cb0[164].w
  exp r0.w, r0.w
  mul r7.yzw, r0.wwww, cb0[164].xxyz
  mad r0.x, r0.x, r4.w, -cb0[163].w
  max r0.x, r0.x, l(0.000000)
  mul r0.x, r0.x, r3.w
  exp r0.x, -r0.x
  min r0.x, r0.x, l(1.000000)
  add r0.x, -r0.x, l(1.000000)
  mul r7.yzw, r0.xxxx, r7.yyzw
  add r0.x, -r7.x, l(1.000000)
  mul r7.xyz, r0.xxxx, r7.yzwy
  mad r0.xyw, cb0[161].xyxz, r0.yyyy, r7.xyxz
  mad r0.xyw, r0.xyxw, r8.wwww, r8.xyxz
  mul r1.w, r5.w, r8.w
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
  exp r5.w, -r2.x
  add r5.w, -r5.w, l(1.000000)
  div r5.w, r5.w, r2.x
  mad r2.x, -r2.x, l(0.240227), l(0.693147)
  movc r2.x, r4.y, r5.w, r2.x
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
  dp3_sat r3.w, r9.xyzx, cb0[163].xyzx
  log r3.w, r3.w
  mul r3.w, r3.w, cb0[164].w
  exp r3.w, r3.w
  mul r7.xyz, r3.wwww, cb0[164].xyzx
  mad r2.w, r2.w, r4.z, -cb0[163].w
  max r2.w, r2.w, l(0.000000)
  mul r2.x, r2.w, r2.x
  exp r2.x, -r2.x
  min r2.x, r2.x, l(1.000000)
  add r2.x, -r2.x, l(1.000000)
  mul r4.yzw, r2.xxxx, r7.xxyz
  add r2.x, -r4.x, l(1.000000)
  mul r4.xyz, r2.xxxx, r4.yzwy
  mad r0.xyw, cb0[161].xyxz, r2.yyyy, r4.xyxz
endif
mul r2.xyw, r1.wwww, r3.xyxz
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
lt r39.x, l(0.500000), cb13[12].y
if_nz r39.x
  mul r37.xyz, r2.xywx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  add r37.xyz, r37.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r37.xyz, r37.xyzx, l(0.350000, 0.350000, 0.350000, 0.000000), r2.xywx
  mul r38.xyz, r0.xyzx, l(0.650000, 0.650000, 0.650000, 0.000000)
  mad r0.xyz, r1.xyzx, r37.xyzx, r38.xyzx
else
  mad r0.xyz, r1.xyzx, r2.xywx, r0.xyzx
endif
dp3 r0.w, r2.xywx, l(0.333333, 0.333333, 0.333333, 0.000000)
dp3 r1.w, r6.xyzx, r6.xyzx
sqrt r1.w, r1.w
mad_sat r1.w, -r1.w, cb0[171].z, l(1.000000)
mul r2.x, r1.w, cb0[171].x
mad r1.w, -cb0[171].x, r1.w, l(1.000000)
mul r2.yzw, cb0[170].xxyz, cb0[185].wwww
mad r2.yzw, r5.xxyz, cb0[171].yyyy, r2.yyzw
sample_l_indexable(texture3d)(float,float,float,float) r2.y, r2.yzwy, t25.xwyz, s2, l(0.000000)
dp2 r2.x, r2.yyyy, r2.xxxx
add r1.w, r1.w, r2.x
add r2.x, r0.w, l(1.000000)
min r1.w, r1.w, r2.x
add r0.xyz, -r1.xyzx, r0.xyzx
mad o0.xyz, r1.wwww, r0.xyzx, r1.xyzx
mov o0.w, r0.w
ret
// Approximately 0 instruction slots used
