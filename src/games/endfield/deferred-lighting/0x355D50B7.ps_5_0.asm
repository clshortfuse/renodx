ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[239], immediateIndexed
dcl_constantbuffer CB1[259], dynamicIndexed
dcl_constantbuffer CB2[5], immediateIndexed
dcl_constantbuffer CB3[4], immediateIndexed
dcl_constantbuffer CB13[15], immediateIndexed
dcl_sampler s0, mode_default
dcl_sampler s1, mode_default
dcl_sampler s2, mode_default
dcl_sampler s3, mode_default
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
dcl_resource_texture3d (float,float,float,float) t10
dcl_resource_texture2d (float,float,float,float) t11
dcl_resource_texture2d (float,float,float,float) t12
dcl_resource_texture3d (float,float,float,float) t13
dcl_resource_texture3d (float,float,float,float) t14
dcl_resource_texture3d (float,float,float,float) t15
dcl_resource_texture3d (float,float,float,float) t16
dcl_resource_texture3d (float,float,float,float) t17
dcl_resource_texture3d (float,float,float,float) t18
dcl_resource_texture2d (float,float,float,float) t19
dcl_resource_texture2d (float,float,float,float) t20
dcl_resource_texture2d (float,float,float,float) t21
dcl_resource_texture2d (float,float,float,float) t22
dcl_resource_texture3d (float,float,float,float) t23
dcl_input_ps_siv linear noperspective v0.xy, position
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 29
ftou r0.xy, v0.xyxx
mov r0.z, l(0)
ld_indexable(texture2d)(float,float,float,float) r1.xyz, r0.xyzz, t20.xyzw
ld_indexable(texture2d)(float,float,float,float) r2.xyz, r0.xyzz, t21.xyzw
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
  sample_b_indexable(texture2d)(float,float,float,float) r10.xy, v1.xyxx, t19.xyzw, s1, cb0[108].x
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
mad r11.z, r10.x, r2.z, r1.z
ld_indexable(texture2d)(float,float,float,float) r12.xyz, r0.xyzz, t22.xyzw
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
mul r14.y, r11.z, r11.z
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
ld_indexable(texture2d)(float,float,float,float) r14.x, r0.xyzz, t6.xyzw
lt r0.z, l(0.001000), r14.x
if_nz r0.z
  dp3 r0.z, -r9.xyzx, r3.xyzx
  add r0.z, r0.z, r0.z
  mad r15.xyz, r3.xyzx, -r0.zzzz, -r9.xyzx
  dp3 r0.z, -cb2[0].xyzx, r15.xyzx
  mad r16.xyz, cb2[0].xyzx, r0.zzzz, r15.xyzx
  lt r0.z, r0.z, cb2[4].z
  dp3 r2.z, r16.xyzx, r16.xyzx
  max r2.z, r2.z, l(0.000061)
  rsq r2.z, r2.z
  mul r16.xyz, r2.zzzz, r16.xyzx
  mul r16.xyz, r16.xyzx, cb2[4].yyyy
  mad r16.xyz, -cb2[0].xyzx, cb2[4].zzzz, r16.xyzx
  dp3 r2.z, r16.xyzx, r16.xyzx
  rsq r2.z, r2.z
  mul r16.xyz, r2.zzzz, r16.xyzx
  movc r15.xyz, r0.zzzz, r16.xyzx, r15.xyzx
  mad r8.xyz, r8.xyzx, r4.zzzz, r15.xyzx
  dp3 r0.z, r8.xyzx, r8.xyzx
  max r0.z, r0.z, l(0.000061)
  rsq r0.z, r0.z
  mul r8.xyz, r0.zzzz, r8.xyzx
  dp3_sat r11.x, r15.xyzx, r3.xyzx
  dp3_sat r0.z, r3.xyzx, r8.xyzx
  min r11.y, r13.x, l(1.000000)
  mad r2.z, r0.z, r1.x, -r0.z
  mad r0.z, r2.z, r0.z, l(1.000000)
  dp3_sat r2.z, r9.xyzx, r8.xyzx
  add r2.z, -r2.z, l(1.000000)
  mul r6.w, r2.z, r2.z
  mul r6.w, r6.w, r6.w
  mul r7.w, r2.z, r6.w
  add r8.x, -r11.z, l(1.000000)
  mad r8.y, -r8.x, l(0.383026), l(-0.076195)
  mad r8.y, r8.x, r8.y, l(1.049970)
  mad r8.x, r8.x, r8.y, l(0.409255)
  min r8.x, r8.x, l(0.999000)
  add r8.y, -r8.x, l(1.000000)
  add r15.xyz, -r10.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r15.xyz, r15.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r10.xyzx
  mad r2.z, -r6.w, r2.z, l(1.000000)
  mad r16.xyz, r10.xyzx, r2.zzzz, r7.wwww
  mul r0.z, r0.z, r0.z
  div r0.z, r1.x, r0.z
  mad r8.zw, -r11.yyyx, r1.xxxx, r11.yyyx
  mad r8.zw, r8.zzzw, r11.yyyx, r1.xxxx
  sqrt r8.zw, r8.zzzw
  mul r8.zw, r8.zzzw, r11.xxxy
  add r1.x, r8.w, r8.z
  add r1.x, r1.x, l(0.000100)
  div r1.x, l(0.500000), r1.x
  mul r0.z, r0.z, r1.x
  mul r16.xyz, r0.zzzz, r16.xyzx
  min r16.xyz, r16.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
  mad r17.xyzw, r11.yzxz, l(0.968750, 0.968750, 0.968750, 0.968750), l(0.015625, 0.015625, 0.015625, 0.015625)
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r17.xyxx, t8.yzxw, s1, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r1.x, r17.zwzz, t8.xyzw, s1, l(0.000000)
  mul r0.z, r0.z, r1.x
  mul r0.z, r8.x, r0.z
  div r0.z, r0.z, r8.y
  mul r8.xzw, r15.xxyz, r15.xxyz
  mul r8.xzw, r0.zzzz, r8.xxzw
  mad r15.xyz, -r15.xyzx, r8.yyyy, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r8.xyz, r8.xzwx, r15.xyzx
  add r8.xyz, r8.xyzx, r16.xyzx
  mul r8.xyz, r8.xyzx, cb2[4].xxxx
  max r8.xyz, r8.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  min r8.xyz, r8.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
  mul r15.xyz, r11.xxxx, r12.xyzx
  mad r8.xyz, r8.xyzx, r11.xxxx, r15.xyzx
  mul r8.xyz, r8.xyzx, cb2[1].xyzx
  mov r14.y, l(0.500000)
  sample_b_indexable(texture2d)(float,float,float,float) r11.xyw, r14.xyxx, t7.xywz, s1, cb0[108].x
  add r0.z, -r14.x, l(1.000000)
  mad r11.xyw, r8.xyxz, r11.xyxw, -r8.xyxz
  mad r8.xyz, r0.zzzz, r11.xywx, r8.xyzx
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r4.xyxx, t9.yzxw, s1, l(0.000000)
  min r0.z, r0.z, l(1.000000)
  mul r8.xyz, r0.zzzz, r8.xyzx
else
  mov r8.xyz, l(0,0,0,0)
endif
ne r11.xy, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[112].xyxx
if_nz r11.x
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t4.yzxw, s0, cb0[108].x
  min r0.z, r1.y, r0.z
  add r1.x, r0.z, r13.x
  mad r2.z, r11.z, l(-16.000000), l(-1.000000)
  exp r2.z, r2.z
  log r1.x, |r1.x|
  mul r1.x, r1.x, r2.z
  exp r1.x, r1.x
  add r1.x, r0.z, r1.x
  add r1.x, r1.x, l(-1.000000)
  mov_sat r14.xyz, r1.xxxx
  mad r15.xyz, r12.xyzx, l(2.040400, 2.040400, 2.040400, 0.000000), l(-0.332400, -0.332400, -0.332400, 0.000000)
  mul r15.xyz, r0.zzzz, r15.xyzx
  mad r15.xyz, r12.xyzx, l(-4.795100, -4.795100, -4.795100, 0.000000), r15.xyzx
  add r15.xyz, r15.xyzx, l(0.641700, 0.641700, 0.641700, 0.000000)
  mul r15.xyz, r0.zzzz, r15.xyzx
  mad r15.xyz, r12.xyzx, l(2.755200, 2.755200, 2.755200, 0.000000), r15.xyzx
  add r15.xyz, r15.xyzx, l(0.690300, 0.690300, 0.690300, 0.000000)
  mul r15.xyz, r0.zzzz, r15.xyzx
  max r15.xyz, r0.zzzz, r15.xyzx
else
  mov r14.xyz, r1.yyyy
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
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyw, r17.xyzx, t13.yzwx, s2, l(0.000000)
    add r1.y, -r1.x, l(1.000000)
    mul r2.z, l(0.500000), cb0[215].y
    mad r6.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r2.z, r2.z, r17.y
    min r2.z, r6.w, r2.z
    mul r17.w, r2.z, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyzw, r17.xwzx, t14.xyzw, s1, l(0.000000)
    mad r2.z, r19.w, r1.y, r0.z
    add r20.xyz, r17.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyz, r20.xyzx, t14.xyzw, s1, l(0.000000)
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r18.yyyy, r20.xyzx
    mov r20.w, r18.y
    mul r20.xyzw, r1.yyyy, r20.xyzw
    add r17.xyz, r17.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r17.xyz, r17.xyzx, t14.xyzw, s1, l(0.000000)
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
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyw, r19.xyzx, t15.yzwx, s2, l(0.000000)
    add r6.w, -r1.y, l(1.000000)
    mul r1.x, r1.x, r6.w
    mul r6.w, l(0.500000), cb0[215].y
    mad r7.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r6.w, r6.w, r19.y
    min r6.w, r7.w, r6.w
    mul r19.w, r6.w, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyzw, r19.xwzx, t16.xyzw, s1, l(0.000000)
    mad r2.z, r22.w, r1.x, r2.z
    add r23.xyz, r19.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r23.xyz, r23.xyzx, t16.xyzw, s1, l(0.000000)
    mad r23.xyz, r23.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r23.xyz, r21.yyyy, r23.xyzx
    mov r23.w, r21.y
    mad r20.xyzw, r23.xyzw, r1.xxxx, r20.xyzw
    add r19.xyz, r19.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyz, r19.xyzx, t16.xyzw, s1, l(0.000000)
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
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyw, r16.xyzx, t17.yzwx, s2, l(0.000000)
    add r1.x, -r0.z, l(1.000000)
    mul r1.x, r1.x, r1.y
    max r1.y, r21.y, r16.y
    min r1.y, r19.y, r1.y
    mul r16.w, r1.y, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyzw, r16.xwzx, t18.xyzw, s1, l(0.000000)
    add r21.xyz, r16.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyz, r21.xyzx, t18.xyzw, s1, l(0.000000)
    mad r21.xyz, r21.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r22.yyyy, r21.xyzx
    mov r21.w, r22.y
    mad r20.xyzw, r21.xyzw, r1.xxxx, r20.xyzw
    add r16.xyz, r16.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r16.xyz, r16.xyzx, t18.xyzw, s1, l(0.000000)
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
  sample_l_indexable(texture2d)(float,float,float,float) r19.xyzw, r4.xyxx, t12.xyzw, s1, l(0.000000)
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
      mul r11.xw, r1.xxxy, l(0.500000, 0.000000, 0.000000, 0.500000)
      mov r1.xy, r11.xwxx
      mov r2.z, r4.x
      continue
    endloop
    mul r19.xyzw, r1.xxxx, r19.xyzw
    dp3 r0.z, r19.yzwy, r19.yzwy
    sqrt r0.z, r0.z
    mad r0.z, r0.z, cb3[3].x, cb3[3].y
    mad r0.z, r0.z, l(255.000000), l(0.500000)
    mul r1.x, r0.z, l(0.003906)
    mov r1.y, l(0.500000)
    sample_l_indexable(texture2d)(float,float,float,float) r1.xy, r1.xyxx, t11.xyzw, s1, l(0.000000)
    mad r1.xy, r1.xyxx, cb3[2].xyxx, cb3[2].zwzz
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
    dp2 r10.w, r19.zxzz, r20.xzxx
    dp2 r11.x, r19.wxww, r20.xwxx
    mul r18.w, r0.z, l(0.886227)
    mul r18.x, r2.z, l(-1.023327)
    mul r18.yz, r1.xxyx, l(0.000000, -1.023327, 1.023327, 0.000000)
    mul r17.x, r7.w, l(-1.023327)
    mul r17.yw, r4.yyyx, l(0.000000, -1.023327, 0.000000, 0.886227)
    mul r17.z, r6.w, l(1.023327)
    mul r16.w, r8.w, l(0.886227)
    mul r16.x, r11.x, l(-1.023327)
    mul r16.y, r9.w, l(-1.023327)
    mul r16.z, r10.w, l(1.023327)
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
dp3 r0.z, -r9.xyzx, r3.xyzx
add r0.z, r0.z, r0.z
mad r16.xyz, r3.xyzx, -r0.zzzz, -r9.xyzx
add r0.z, l(-1.000000), cb0[113].x
max r1.x, r11.z, l(0.001000)
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
mul r11.xzw, r18.xxyz, cb0[111].xxxx
dp3 r1.y, r11.xzwx, l(0.212673, 0.715152, 0.072175, 0.000000)
mov r28.x, r1.y  // Store ambient luminance for cubemap modulation
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
    ge r19.xyz, cb1[r7.w + 5].xyzx, |r17.xyzx|
    and r8.w, r19.y, r19.x
    and r8.w, r19.z, r8.w
    if_nz r8.w
      mul r8.w, l(0.100000), cb1[r7.w + 5].x
      mul r19.xyz, |r17.xyzx|, l(0.100000, 0.100000, 0.100000, 0.000000)
      mul r19.xy, r19.xyxx, r19.xyxx
      add r20.xyz, -|r17.xyzx|, cb1[r7.w + 5].xyzx
      mul r20.xyz, r20.xyzx, cb1[r7.w + 9].xyzx
      eq r9.w, l(1.000000), cb1[r7.w + 10].x
      if_nz r9.w
        dp3 r21.x, cb1[r7.w + 6].xyzx, r16.xyzx
        dp3 r21.y, cb1[r7.w + 7].xyzx, r16.xyzx
        dp3 r21.z, cb1[r7.w + 8].xyzx, r16.xyzx
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
        mov r17.xyz, r16.xyzx
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
      add r12.w, r19.y, r19.x
      mad r12.w, r19.z, r19.z, r12.w
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
  dp3 r1.x, r16.xyzx, r16.xyzx
  rsq r1.x, r1.x
  mul r16.xyz, r1.xxxx, r16.xyzx
  lt r17.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r16.xyzx
  lt r19.xyz, r16.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  iadd r17.xyz, -r17.xyzx, r19.xyzx
  itof r17.xyz, r17.xyzx
  dp3 r1.x, r16.xyzx, r17.xyzx
  div r16.xyz, r16.xyzx, r1.xxxx
  lt r1.x, r16.z, l(0.000000)
  add r4.xy, -|r16.yxyy|, l(1.000000, 1.000000, 0.000000, 0.000000)
  mul r4.xy, r4.xyxx, r17.xyxx
  movc r4.xy, r1.xxxx, r4.xyxx, r16.xyxx
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
  max r28.x, r28.x, l(0.000000)
  min r28.x, r28.x, l(1.000000)
  mad r28.x, r28.x, l(0.750000), l(0.250000)
  mul r3.xyz, r3.xyzx, r28.xxxx
endif
if_nz r11.y
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t3.yzxw, s1, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r11.xyz, v1.xyxx, t2.xyzw, s1, cb0[108].x
  add r1.x, -r0.z, l(1.000000)
  mul r16.xyz, r1.xxxx, r3.xyzx
  mad r3.xyz, r11.xyzx, r0.zzzz, r16.xyzx
endif
mul r11.xyz, r12.xyzx, r18.xyzx
mul r11.xyz, r11.xyzx, cb0[111].xxxx
add r0.z, -r1.z, l(1.000000)
div r0.z, r0.z, r1.z
mul r1.xyz, r0.zzzz, r10.xyzx
mad r1.xyz, r1.xyzx, r13.yzwy, r13.yzwy
mul r1.xyz, r1.xyzx, r3.xyzx
mul r1.xyz, r14.xyzx, r1.xyzx
mad r1.xyz, r11.xyzx, r15.xyzx, r1.xyzx
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
  sample_l_indexable(texture3d)(float,float,float,float) r8.xyzw, r8.xyzx, t10.xyzw, s1, l(0.000000)
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
lt r27.x, l(0.500000), cb13[12].y
if_nz r27.x
  mul r25.xyz, r2.xywx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  add r25.xyz, r25.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r25.xyz, r25.xyzx, l(0.350000, 0.350000, 0.350000, 0.000000), r2.xywx
  mul r26.xyz, r0.xyzx, l(0.650000, 0.650000, 0.650000, 0.000000)
  mad r0.xyz, r1.xyzx, r25.xyzx, r26.xyzx
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
sample_l_indexable(texture3d)(float,float,float,float) r2.y, r2.yzwy, t23.xwyz, s2, l(0.000000)
dp2 r2.x, r2.yyyy, r2.xxxx
add r1.w, r1.w, r2.x
add r2.x, r0.w, l(1.000000)
min r1.w, r1.w, r2.x
add r0.xyz, -r1.xyzx, r0.xyzx
mad o0.xyz, r1.wwww, r0.xyzx, r1.xyzx
mov o0.w, r0.w
ret
// Approximately 0 instruction slots used
