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
dcl_input_ps_siv linear noperspective v0.xy, position
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 30
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
movc r6.xyz, r2.wwww, r6.xyzx, r7.xyzx
dp3 r2.w, r6.xyzx, r6.xyzx
max r4.z, r2.w, l(0.000000)
rsq r4.z, r4.z
mul r8.xyz, r4.zzzz, r6.xyzx
mul r4.w, r2.w, r4.z
lt r6.w, l(0.000488), cb0[238].x
if_nz r6.w
  sample_b_indexable(texture2d)(float,float,float,float) r9.xy, v1.xyxx, t19.xyzw, s1, cb0[108].x
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
mad r10.z, r9.x, r2.z, r1.z
ld_indexable(texture2d)(float,float,float,float) r11.xyz, r0.xyzz, t22.xyzw
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
mul r13.y, r10.z, r10.z
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
ld_indexable(texture2d)(float,float,float,float) r13.x, r0.xyzz, t6.xyzw
lt r0.z, l(0.001000), r13.x
if_nz r0.z
  dp3 r0.z, -r8.xyzx, r3.xyzx
  add r0.z, r0.z, r0.z
  mad r14.xyz, r3.xyzx, -r0.zzzz, -r8.xyzx
  dp3 r0.z, -cb2[0].xyzx, r14.xyzx
  mad r15.xyz, cb2[0].xyzx, r0.zzzz, r14.xyzx
  lt r0.z, r0.z, cb2[4].z
  dp3 r2.z, r15.xyzx, r15.xyzx
  max r2.z, r2.z, l(0.000061)
  rsq r2.z, r2.z
  mul r15.xyz, r2.zzzz, r15.xyzx
  mul r15.xyz, r15.xyzx, cb2[4].yyyy
  mad r15.xyz, -cb2[0].xyzx, cb2[4].zzzz, r15.xyzx
  dp3 r2.z, r15.xyzx, r15.xyzx
  rsq r2.z, r2.z
  mul r15.xyz, r2.zzzz, r15.xyzx
  movc r14.xyz, r0.zzzz, r15.xyzx, r14.xyzx
  mad r6.xyz, r6.xyzx, r4.zzzz, r14.xyzx
  dp3 r0.z, r6.xyzx, r6.xyzx
  max r0.z, r0.z, l(0.000061)
  rsq r0.z, r0.z
  mul r6.xyz, r0.zzzz, r6.xyzx
  dp3_sat r10.x, r14.xyzx, r3.xyzx
  dp3_sat r0.z, r3.xyzx, r6.xyzx
  min r10.y, r12.x, l(1.000000)
  mad r2.z, r0.z, r1.x, -r0.z
  mad r0.z, r2.z, r0.z, l(1.000000)
  dp3_sat r2.z, r8.xyzx, r6.xyzx
  add r2.z, -r2.z, l(1.000000)
  mul r6.x, r2.z, r2.z
  mul r6.x, r6.x, r6.x
  mul r6.y, r2.z, r6.x
  add r6.z, -r10.z, l(1.000000)
  mad r6.w, -r6.z, l(0.383026), l(-0.076195)
  mad r6.w, r6.z, r6.w, l(1.049970)
  mad r6.z, r6.z, r6.w, l(0.409255)
  min r6.z, r6.z, l(0.999000)
  add r6.w, -r6.z, l(1.000000)
  add r14.xyz, -r9.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r14.xyz, r14.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r9.xyzx
  mad r2.z, -r6.x, r2.z, l(1.000000)
  mad r15.xyz, r9.xyzx, r2.zzzz, r6.yyyy
  mul r0.z, r0.z, r0.z
  div r0.z, r1.x, r0.z
  mad r6.xy, -r10.yxyy, r1.xxxx, r10.yxyy
  mad r6.xy, r6.xyxx, r10.yxyy, r1.xxxx
  sqrt r6.xy, r6.xyxx
  mul r6.xy, r6.xyxx, r10.xyxx
  add r1.x, r6.y, r6.x
  add r1.x, r1.x, l(0.000100)
  div r1.x, l(0.500000), r1.x
  mul r0.z, r0.z, r1.x
  mul r15.xyz, r0.zzzz, r15.xyzx
  min r15.xyz, r15.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
  mad r16.xyzw, r10.yzxz, l(0.968750, 0.968750, 0.968750, 0.968750), l(0.015625, 0.015625, 0.015625, 0.015625)
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r16.xyxx, t8.yzxw, s1, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r1.x, r16.zwzz, t8.xyzw, s1, l(0.000000)
  mul r0.z, r0.z, r1.x
  mul r0.z, r6.z, r0.z
  div r0.z, r0.z, r6.w
  mul r6.xyz, r14.xyzx, r14.xyzx
  mul r6.xyz, r0.zzzz, r6.xyzx
  mad r14.xyz, -r14.xyzx, r6.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r6.xyz, r6.xyzx, r14.xyzx
  add r6.xyz, r6.xyzx, r15.xyzx
  mul r6.xyz, r6.xyzx, cb2[4].xxxx
  max r6.xyz, r6.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  min r6.xyz, r6.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
  mul r14.xyz, r10.xxxx, r11.xyzx
  mad r6.xyz, r6.xyzx, r10.xxxx, r14.xyzx
  mul r6.xyz, r6.xyzx, cb2[1].xyzx
  mov r13.y, l(0.500000)
  sample_b_indexable(texture2d)(float,float,float,float) r10.xyw, r13.xyxx, t7.xywz, s1, cb0[108].x
  add r0.z, -r13.x, l(1.000000)
  mad r10.xyw, r6.xyxz, r10.xyxw, -r6.xyxz
  mad r6.xyz, r0.zzzz, r10.xywx, r6.xyzx
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r4.xyxx, t9.yzxw, s1, l(0.000000)
  min r0.z, r0.z, l(1.000000)
  mul r6.xyz, r0.zzzz, r6.xyzx
else
  mov r6.xyz, l(0,0,0,0)
endif
ne r10.xy, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[112].xyxx
if_nz r10.x
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t4.yzxw, s0, cb0[108].x
  min r0.z, r1.y, r0.z
  add r1.x, r0.z, r12.x
  mad r2.z, r10.z, l(-16.000000), l(-1.000000)
  exp r2.z, r2.z
  log r1.x, |r1.x|
  mul r1.x, r1.x, r2.z
  exp r1.x, r1.x
  add r1.x, r0.z, r1.x
  add r1.x, r1.x, l(-1.000000)
  mov_sat r13.xyz, r1.xxxx
  mad r14.xyz, r11.xyzx, l(2.040400, 2.040400, 2.040400, 0.000000), l(-0.332400, -0.332400, -0.332400, 0.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
  mad r14.xyz, r11.xyzx, l(-4.795100, -4.795100, -4.795100, 0.000000), r14.xyzx
  add r14.xyz, r14.xyzx, l(0.641700, 0.641700, 0.641700, 0.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
  mad r14.xyz, r11.xyzx, l(2.755200, 2.755200, 2.755200, 0.000000), r14.xyzx
  add r14.xyz, r14.xyzx, l(0.690300, 0.690300, 0.690300, 0.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
  max r14.xyz, r0.zzzz, r14.xyzx
else
  mov r13.xyz, r1.yyyy
  mov r14.xyz, r1.yyyy
endif
mad r15.xyz, r3.xyzx, l(0.250000, 0.250000, 0.250000, 0.000000), r5.xyzx
round_z r0.z, cb0[216].x
mad r1.xy, r0.zzzz, l(2.083000, 4.867000, 0.000000, 0.000000), r2.xyxx
dp2 r0.z, r1.xyxx, l(0.067111, 0.005837, 0.000000, 0.000000)
frc r0.z, r0.z
mul r0.z, r0.z, l(52.982918)
frc r0.z, r0.z
mad r0.z, r0.z, l(2.000000), l(-1.000000)
mad r15.xyz, r0.zzzz, l(0.200000, 0.200000, 0.200000, 0.000000), r15.xyzx
mad r16.xyz, cb0[6].xzyx, -cb0[216].wwww, cb0[214].xzyx
add r16.xyz, r15.xzyx, -r16.xyzx
max r0.z, |r16.y|, |r16.x|
add r0.z, r0.z, l(-464.000000)
mul_sat r0.z, r0.z, l(0.031250)
add r1.x, |r16.z|, l(-208.000000)
mul_sat r1.x, r1.x, l(0.031250)
max r0.z, r0.z, r1.x
ne r1.x, l(0.000000), cb0[214].w
lt r1.y, r0.z, l(1.000000)
and r1.x, r1.y, r1.x
if_nz r1.x
  mad r16.xyz, cb0[6].xzyx, -cb0[216].yyyy, cb0[214].xzyx
  add r16.xyz, r15.xzyx, -r16.xyzx
  max r1.x, |r16.y|, |r16.x|
  add r1.x, r1.x, l(-29.000000)
  add r1.y, |r16.z|, l(-13.000000)
  mul_sat r1.xy, r1.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000)
  max r1.x, r1.y, r1.x
  lt r1.y, r1.x, l(1.000000)
  if_nz r1.y
    mad r16.xyz, r15.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r17.xyz, r16.xyzx, cb0[215].xyzx
    round_ni r17.xyz, r17.xyzx
    mad r16.xyz, r16.xyzx, cb0[215].xyzx, -r17.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r17.xyw, r16.xyzx, t13.yzwx, s2, l(0.000000)
    add r1.y, -r1.x, l(1.000000)
    mul r2.z, l(0.500000), cb0[215].y
    mad r6.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r2.z, r2.z, r16.y
    min r2.z, r6.w, r2.z
    mul r16.w, r2.z, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyzw, r16.xwzx, t14.xyzw, s1, l(0.000000)
    mad r2.z, r18.w, r1.y, r0.z
    add r19.xyz, r16.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyz, r19.xyzx, t14.xyzw, s1, l(0.000000)
    mad r19.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r19.xyz, r17.yyyy, r19.xyzx
    mov r19.w, r17.y
    mul r19.xyzw, r1.yyyy, r19.xyzw
    add r16.xyz, r16.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r16.xyz, r16.xyzx, t14.xyzw, s1, l(0.000000)
    mad r16.xyz, r16.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r16.xyz, r17.xxxx, r16.xyzx
    mov r16.w, r17.x
    mul r16.xyzw, r1.yyyy, r16.xyzw
    mad r18.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r17.xyz, r17.wwww, r18.xyzx
    mul r17.xyzw, r1.yyyy, r17.xyzw
  else
    mov r19.xyzw, l(0,0,0,0)
    mov r16.xyzw, l(0,0,0,0)
    mov r17.xyzw, l(0,0,0,0)
    mov r2.z, r0.z
  endif
  mad r18.xyz, cb0[6].xzyx, -cb0[216].zzzz, cb0[214].xzyx
  add r18.xyz, r15.xzyx, -r18.xyzx
  max r1.y, |r18.y|, |r18.x|
  add r1.y, r1.y, l(-116.000000)
  mul_sat r1.y, r1.y, l(0.125000)
  add r6.w, |r18.z|, l(-52.000000)
  mul_sat r6.w, r6.w, l(0.125000)
  max r1.y, r1.y, r6.w
  lt r6.w, r1.y, l(1.000000)
  if_nz r6.w
    mad r18.xyz, r15.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r20.xyz, r18.xyzx, cb0[215].xyzx
    round_ni r20.xyz, r20.xyzx
    mad r18.xyz, r18.xyzx, cb0[215].xyzx, -r20.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyw, r18.xyzx, t15.yzwx, s2, l(0.000000)
    add r6.w, -r1.y, l(1.000000)
    mul r1.x, r1.x, r6.w
    mul r6.w, l(0.500000), cb0[215].y
    mad r7.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r6.w, r6.w, r18.y
    min r6.w, r7.w, r6.w
    mul r18.w, r6.w, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyzw, r18.xwzx, t16.xyzw, s1, l(0.000000)
    mad r2.z, r21.w, r1.x, r2.z
    add r22.xyz, r18.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyz, r22.xyzx, t16.xyzw, s1, l(0.000000)
    mad r22.xyz, r22.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r22.xyz, r20.yyyy, r22.xyzx
    mov r22.w, r20.y
    mad r19.xyzw, r22.xyzw, r1.xxxx, r19.xyzw
    add r18.xyz, r18.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyz, r18.xyzx, t16.xyzw, s1, l(0.000000)
    mad r18.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r18.xyz, r20.xxxx, r18.xyzx
    mov r18.w, r20.x
    mad r16.xyzw, r18.xyzw, r1.xxxx, r16.xyzw
    mad r18.xyz, r21.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r20.wwww, r18.xyzx
    mad r17.xyzw, r20.xyzw, r1.xxxx, r17.xyzw
  endif
  lt r1.x, l(0.000000), r1.y
  if_nz r1.x
    mad r15.xyz, r15.xyzx, l(0.125000, 0.125000, 0.125000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r18.xyz, r15.xyzx, cb0[215].xyzx
    mul r20.xyz, l(0.500000, 0.500000, 0.500000, 0.000000), cb0[215].xyzx
    round_ni r18.xyz, r18.xyzx
    mad r15.xyz, r15.xyzx, cb0[215].xyzx, -r18.xyzx
    mad r18.xyz, -cb0[215].xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
    max r15.xyz, r20.xyzx, r15.xyzx
    min r15.xyz, r18.xyzx, r15.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyw, r15.xyzx, t17.yzwx, s2, l(0.000000)
    add r1.x, -r0.z, l(1.000000)
    mul r1.x, r1.x, r1.y
    max r1.y, r20.y, r15.y
    min r1.y, r18.y, r1.y
    mul r15.w, r1.y, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyzw, r15.xwzx, t18.xyzw, s1, l(0.000000)
    add r20.xyz, r15.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyz, r20.xyzx, t18.xyzw, s1, l(0.000000)
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r21.yyyy, r20.xyzx
    mov r20.w, r21.y
    mad r19.xyzw, r20.xyzw, r1.xxxx, r19.xyzw
    add r15.xyz, r15.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r15.xyz, r15.xyzx, t18.xyzw, s1, l(0.000000)
    mad r15.xyz, r15.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r15.xyz, r21.xxxx, r15.xyzx
    mov r15.w, r21.x
    mad r16.xyzw, r15.xyzw, r1.xxxx, r16.xyzw
    mad r15.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r21.wwww, r15.xyzx
    mad r17.xyzw, r21.xyzw, r1.xxxx, r17.xyzw
    mad r2.z, r18.w, r1.x, r2.z
  endif
  mad_sat r1.x, r2.z, l(2.000000), l(-1.000000)
  add r15.x, -r0.z, r1.x
  add r0.z, r0.z, r1.x
  mul r15.y, r0.z, l(0.500000)
else
  mov r19.xyzw, l(0,0,0,0)
  mov r16.xyzw, l(0,0,0,0)
  mov r17.xyzw, l(0,0,0,0)
  mov r15.xy, l(0,1.000000,0,0)
endif
mul r18.xyzw, r15.yxyy, cb0[217].ywzx
mad r18.y, r18.y, l(0.500000), r18.x
mul r1.xy, r15.yxyy, cb0[217].wyww
mad r18.x, r1.y, l(0.375000), r1.x
add r17.xyzw, r17.xyzw, r18.wyzx
mul r18.xyzw, r15.yxyy, cb0[218].ywzx
mad r18.y, r18.y, l(0.500000), r18.x
mul r1.xy, r15.yxyy, cb0[218].wyww
mad r18.x, r1.y, l(0.375000), r1.x
add r16.xyzw, r16.xyzw, r18.wyzx
mul r18.xyzw, r15.yxyy, cb0[219].ywzx
mad r18.y, r18.y, l(0.500000), r18.x
mul r1.xy, r15.yxyy, cb0[219].wyww
mad r18.x, r1.y, l(0.375000), r1.x
add r15.xyzw, r18.wyzx, r19.xyzw
ge r1.xy, r4.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
and r0.z, r1.y, r1.x
if_nz r0.z
  sample_l_indexable(texture2d)(float,float,float,float) r18.xyzw, r4.xyxx, t12.xyzw, s1, l(0.000000)
  lt r19.xyzw, l(0.000100, 0.000100, 0.000100, 0.000100), |r18.xyzw|
  or r1.xy, r19.zwzz, r19.xyxx
  or r0.z, r1.y, r1.x
  if_nz r0.z
    dp3 r0.z, r18.yzwy, r18.yzwy
    sqrt r0.z, r0.z
    mov r1.x, l(1.000000)
    mov r1.y, r0.z
    mov r2.z, l(0)
    loop
      ge r4.x, l(4.600000), r1.y
      breakc_nz r4.x
      iadd r4.x, r2.z, l(1)
      mul r10.xw, r1.xxxy, l(0.500000, 0.000000, 0.000000, 0.500000)
      mov r1.xy, r10.xwxx
      mov r2.z, r4.x
      continue
    endloop
    mul r18.xyzw, r1.xxxx, r18.xyzw
    dp3 r0.z, r18.yzwy, r18.yzwy
    sqrt r0.z, r0.z
    mad r0.z, r0.z, cb3[3].x, cb3[3].y
    mad r0.z, r0.z, l(255.000000), l(0.500000)
    mul r1.x, r0.z, l(0.003906)
    mov r1.y, l(0.500000)
    sample_l_indexable(texture2d)(float,float,float,float) r1.xy, r1.xyxx, t11.xyzw, s1, l(0.000000)
    mad r1.xy, r1.xyxx, cb3[2].xyxx, cb3[2].zwzz
    mul r19.x, r1.x, l(3.544908)
    mul r19.yzw, r1.yyyy, r18.yyzw
    mul r0.z, r18.x, l(0.406977)
    exp r0.z, r0.z
    mul r18.xyzw, r0.zzzz, r19.xyzw
    mov r19.xyzw, r18.xyzw
    mov r0.z, l(0)
    loop
      uge r1.x, r0.z, r2.z
      breakc_nz r1.x
      mul r20.xyzw, r19.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
      dp4 r1.x, r20.xyzw, r19.xyzw
      dp2 r1.y, r20.yxyy, r19.xyxx
      dp2 r4.x, r20.zxzz, r19.xzxx
      dp2 r4.y, r20.wxww, r19.xwxx
      iadd r6.w, r0.z, l(1)
      mov r19.xy, r1.xyxx
      mov r19.zw, r4.xxxy
      mov r0.z, r6.w
      continue
    endloop
    mul r18.xyzw, r19.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
    mul r19.xyzw, r17.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r0.z, r18.xyzw, r19.xyzw
    dp2 r1.x, r18.yxyy, r19.xyxx
    dp2 r1.y, r18.zxzz, r19.xzxx
    dp2 r2.z, r18.wxww, r19.xwxx
    mul r19.xyzw, r16.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r4.x, r18.xyzw, r19.xyzw
    dp2 r4.y, r18.yxyy, r19.xyxx
    dp2 r6.w, r18.zxzz, r19.xzxx
    dp2 r7.w, r18.wxww, r19.xwxx
    mul r19.xyzw, r15.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r8.w, r18.xyzw, r19.xyzw
    dp2 r9.w, r18.yxyy, r19.xyxx
    dp2 r10.x, r18.zxzz, r19.xzxx
    dp2 r10.w, r18.wxww, r19.xwxx
    mul r17.w, r0.z, l(0.886227)
    mul r17.x, r2.z, l(-1.023327)
    mul r17.yz, r1.xxyx, l(0.000000, -1.023327, 1.023327, 0.000000)
    mul r16.x, r7.w, l(-1.023327)
    mul r16.yw, r4.yyyx, l(0.000000, -1.023327, 0.000000, 0.886227)
    mul r16.z, r6.w, l(1.023327)
    mul r15.w, r8.w, l(0.886227)
    mul r15.y, r9.w, l(-1.023327)
    mul r15.xz, r10.wwxw, l(-1.023327, 0.000000, 1.023327, 0.000000)
  endif
endif
dp3 r0.z, r17.xyzx, r3.xyzx
add r0.z, r17.w, r0.z
max r17.x, r0.z, l(0.000000)
dp3 r0.z, r16.xyzx, r3.xyzx
add r0.z, r16.w, r0.z
max r17.y, r0.z, l(0.000000)
dp3 r0.z, r15.xyzx, r3.xyzx
add r0.z, r15.w, r0.z
max r17.z, r0.z, l(0.000000)
dp3 r0.z, -r8.xyzx, r3.xyzx
add r0.z, r0.z, r0.z
mad r15.xyz, r3.xyzx, -r0.zzzz, -r8.xyzx
add r0.z, l(-1.000000), cb0[113].x
max r1.x, r10.z, l(0.001000)
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
mul r10.xzw, r17.xxyz, cb0[111].xxxx
dp3 r1.y, r10.xzwx, l(0.212673, 0.715152, 0.072175, 0.000000)
mov r29.x, r1.y  // Store ambient luminance for cubemap modulation
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
    ge r18.xyz, cb1[r7.w + 5].xyzx, |r16.xyzx|
    and r8.w, r18.y, r18.x
    and r8.w, r18.z, r8.w
    if_nz r8.w
      mul r8.w, l(0.100000), cb1[r7.w + 5].x
      mul r18.xyz, |r16.xyzx|, l(0.100000, 0.100000, 0.100000, 0.000000)
      mul r18.xy, r18.xyxx, r18.xyxx
      add r19.xyz, -|r16.xyzx|, cb1[r7.w + 5].xyzx
      mul r19.xyz, r19.xyzx, cb1[r7.w + 9].xyzx
      eq r9.w, l(1.000000), cb1[r7.w + 10].x
      if_nz r9.w
        dp3 r20.x, cb1[r7.w + 6].xyzx, r15.xyzx
        dp3 r20.y, cb1[r7.w + 7].xyzx, r15.xyzx
        dp3 r20.z, cb1[r7.w + 8].xyzx, r15.xyzx
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
        mov r16.xyz, r15.xyzx
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
      add r12.x, r18.y, r18.x
      mad r12.x, r18.z, r18.z, r12.x
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
  dp3 r1.x, r15.xyzx, r15.xyzx
  rsq r1.x, r1.x
  mul r5.xzw, r1.xxxx, r15.xxyz
  lt r15.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r5.xzwx
  lt r16.xyz, r5.xzwx, l(0.000000, 0.000000, 0.000000, 0.000000)
  iadd r15.xyz, -r15.xyzx, r16.xyzx
  itof r15.xyz, r15.xyzx
  dp3 r1.x, r5.xzwx, r15.xyzx
  div r5.xzw, r5.xxzw, r1.xxxx
  lt r1.x, r5.w, l(0.000000)
  add r4.xy, -|r5.zxzz|, l(1.000000, 1.000000, 0.000000, 0.000000)
  mul r4.xy, r4.xyxx, r15.xyxx
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
  max r29.x, r29.x, l(0.000000)
  min r29.x, r29.x, l(1.000000)
  mad r29.x, r29.x, l(0.750000), l(0.250000)
  mul r3.xyz, r3.xyzx, r29.xxxx
endif
if_nz r10.y
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t3.yzxw, s1, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r5.xzw, v1.xyxx, t2.xwyz, s1, cb0[108].x
  add r1.x, -r0.z, l(1.000000)
  mul r10.xyz, r1.xxxx, r3.xyzx
  mad r3.xyz, r5.xzwx, r0.zzzz, r10.xyzx
endif
mul r5.xzw, r11.xxyz, r17.xxyz
mul r5.xzw, r5.xxzw, cb0[111].xxxx
add r0.z, -r1.z, l(1.000000)
div r0.z, r0.z, r1.z
mul r1.xyz, r0.zzzz, r9.xyzx
mad r1.xyz, r1.xyzx, r12.yzwy, r12.yzwy
mul r1.xyz, r1.xyzx, r3.xyzx
mul r1.xyz, r13.xyzx, r1.xyzx
mad r1.xyz, r5.xzwx, r14.xyzx, r1.xyzx
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
  sample_l_indexable(texture3d)(float,float,float,float) r6.xyzw, r6.xyzx, t10.xyzw, s1, l(0.000000)
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
lt r28.x, l(0.500000), cb13[12].y
if_nz r28.x
  mul r24.xyz, r1.xyzx, l(0.003922, 0.003922, 0.003922, 0.000000)
  mul r25.xyz, r0.xyzx, l(0.003922, 0.003922, 0.003922, 0.000000)
  mul r26.xyz, r2.xywx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  add r26.xyz, r26.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r26.xyz, r26.xyzx, l(0.350000, 0.350000, 0.350000, 0.000000), r2.xywx
  mul r25.xyz, r25.xyzx, l(0.650000, 0.650000, 0.650000, 0.000000)
  mad r27.xyz, r24.xyzx, r26.xyzx, r25.xyzx
  mul o0.xyz, r27.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
else
  mad o0.xyz, r1.xyzx, r2.xywx, r0.xyzx
endif
dp3 o0.w, r2.xywx, l(0.333333, 0.333333, 0.333333, 0.000000)
ret
// Approximately 0 instruction slots used
