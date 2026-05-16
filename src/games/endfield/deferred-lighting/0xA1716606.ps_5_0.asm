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
dcl_constantbuffer CB5[5], immediateIndexed
dcl_constantbuffer CB6[160], dynamicIndexed
dcl_constantbuffer CB7[4], immediateIndexed
dcl_constantbuffer CB13[15], immediateIndexed
dcl_sampler s0, mode_default
dcl_sampler s1, mode_default
dcl_sampler s2, mode_default
dcl_sampler s3, mode_default
dcl_sampler s4, mode_comparison
dcl_sampler s5, mode_comparison
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
dcl_resource_texture2d (float,float,float,float) t13
dcl_resource_texture2d (float,float,float,float) t14
dcl_resource_texture2d (float,float,float,float) t15
dcl_resource_texture3d (float,float,float,float) t16
dcl_resource_texture2d (float,float,float,float) t17
dcl_resource_texture2d (float,float,float,float) t18
dcl_resource_texture3d (float,float,float,float) t19
dcl_resource_texture3d (float,float,float,float) t20
dcl_resource_texture3d (float,float,float,float) t21
dcl_resource_texture3d (float,float,float,float) t22
dcl_resource_texture3d (float,float,float,float) t23
dcl_resource_texture3d (float,float,float,float) t24
dcl_resource_texture2d (float,float,float,float) t25
dcl_resource_texture2d (float,float,float,float) t26
dcl_resource_texture2d (float,float,float,float) t27
dcl_resource_texture2d (float,float,float,float) t28
dcl_input_ps_siv linear noperspective v0.xy, position
dcl_input_ps linear v1.xy
dcl_output o0.xyzw
dcl_temps 43
ftou r0.xy, v0.xyxx
mov r0.z, l(0)
ld_indexable(texture2d)(float,float,float,float) r1.xyz, r0.xyzz, t26.xyzw
ld_indexable(texture2d)(float,float,float,float) r2.xyz, r0.xyzz, t27.xyzw
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
mul r2.xyw, r1.wwww, r3.xyxz
utof r4.xy, r0.xyxx
mul r4.zw, v0.xxxy, cb0[82].zzzw
mad r5.xy, r4.zwzz, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
add r5.zw, r4.xxxy, l(0.000000, 0.000000, 0.500000, 0.500000)
mul r5.zw, r5.zzzw, cb0[82].zzzw
sample_l_indexable(texture2d)(float,float,float,float) r3.w, r5.zwzz, t1.yzwx, s0, l(0.000000)
mul r6.xyzw, -r5.yyyy, cb0[25].xyzw
mad r5.xyzw, cb0[24].xyzw, r5.xxxx, r6.xyzw
mad r5.xyzw, cb0[26].xyzw, r3.wwww, r5.xyzw
add r5.xyzw, r5.xyzw, cb0[27].xyzw
div r5.xyz, r5.xyzx, r5.wwww
mul r3.w, r5.y, cb0[1].z
mad r3.w, cb0[0].z, r5.x, r3.w
mad r3.w, cb0[2].z, r5.z, r3.w
add r3.w, r3.w, cb0[3].z
eq r6.x, l(0.000000), cb0[86].w
add r6.yzw, -r5.xxyz, cb0[44].xxyz
mov r7.x, cb0[0].z
mov r7.y, cb0[1].z
mov r7.z, cb0[2].z
movc r6.xyz, r6.xxxx, r6.yzwy, r7.xyzx
dp3 r6.w, r6.xyzx, r6.xyzx
max r7.w, r6.w, l(0.000000)
rsq r7.w, r7.w
mul r8.xyzw, r6.xyzw, r7.wwww
lt r9.x, l(0.000488), cb0[238].x
if_nz r9.x
  sample_b_indexable(texture2d)(float,float,float,float) r9.yz, v1.xyxx, t25.zxyw, s1, cb0[108].x
else
  mov r9.yz, l(0,1.000000,1.000000,0)
endif
lt r10.xy, l(0.500000, 0.500000, 0.000000, 0.000000), cb0[230].xyxx
if_nz r10.x
  add r9.w, |r2.y|, |r2.x|
  add r9.w, |r2.w|, r9.w
  div r9.w, l(1.000000, 1.000000, 1.000000, 1.000000), r9.w
  mul r10.xzw, |r2.xxyw|, r9.wwww
  mul r11.xyz, r5.xyzx, cb0[233].xxxx
  sample_l_indexable(texture3d)(float,float,float,float) r9.w, r11.xyzx, t10.yzwx, s2, l(0.000000)
  mul r11.xyzw, r10.xxzz, l(0.000000, 1.000000, 0.707106, 0.000000)
  add r11.xyz, r11.zwzz, r11.xxyx
  mad r10.xzw, r10.wwww, l(1.000000, 0.000000, 0.000000, 0.000000), r11.xxyz
  mad r11.x, r9.w, l(2.000000), l(-1.000000)
  mul r10.xzw, r10.xxzw, r11.xxxx
  mov r11.x, |r2.y|
  add r11.x, r11.x, l(-0.700000)
  mul_sat r11.x, r11.x, l(4.000000)
  mad r11.y, r11.x, l(-2.000000), l(3.000000)
  mul r11.x, r11.x, r11.x
  mul r11.x, r11.x, r11.y
  add r11.y, -cb0[233].z, cb0[233].y
  mad r11.x, r11.x, r11.y, cb0[233].z
  mul r10.xzw, r10.xxzw, r11.xxxx
else
  mov r10.xzw, l(0,0,0,0)
  mov r9.w, l(0)
endif
mad r11.x, -r3.y, r1.w, l(-0.200000)
if_nz r10.y
  mul r11.yzw, r2.xxyw, cb0[237].zzzz
  mul r12.xyz, l(0.000000, 1.000000, 0.000000, 0.000000), cb0[229].yyyy
  mad r11.yzw, r11.yyzw, cb0[229].xxxx, r12.xxyz
  max r10.y, -r2.y, l(0.000000)
  min r10.y, r10.y, l(0.900000)
  add r10.y, -r10.y, l(1.000000)
  mul_sat r12.x, r11.x, l(-10.000000)
  mad r12.y, r12.x, l(-2.000000), l(3.000000)
  mul r12.x, r12.x, r12.x
  mul r12.x, r12.x, r12.y
  max r12.x, r12.x, l(0.100000)
  min r12.x, r12.x, l(1.000000)
  mul r10.y, r10.y, r12.x
  mad r11.yzw, r11.yyzw, r10.yyyy, r5.xxyz
  add r10.xyz, r10.xzwx, r11.yzwy
  mul r11.yzw, r10.yyyy, cb5[1].xxyz
  mad r10.xyw, cb5[0].xyxz, r10.xxxx, r11.yzyw
  mad r10.xyz, cb5[2].xyzx, r10.zzzz, r10.xywx
  add r10.xyz, r10.xyzx, cb5[3].xyzx
  mad r12.x, r10.x, l(0.500000), cb5[4].x
  mad r10.x, r10.y, l(0.500000), l(0.500000)
  add r12.z, -r10.x, cb5[4].y
  add r10.xy, r12.xzxx, l(0.500000, 1.000000, 0.000000, 0.000000)
  max r10.z, r10.z, l(0.000488)
  sample_c_lz_indexable(texture2d)(float,float,float,float) r10.x, r10.xyxx, t9.xxxx, s5, r10.z
else
  mov r10.x, l(1.000000)
endif
mov_sat r10.y, r2.y
add r10.z, l(1.000000), -cb0[234].w
mad r10.z, r10.y, r10.z, cb0[234].w
add r11.yz, r5.xxzx, -cb0[44].xxzx
max r10.w, |r11.z|, |r11.y|
mul r11.y, r10.x, r10.z
mul r11.z, l(0.050000), cb0[226].w
mad r11.w, -cb0[226].w, l(0.700000), r10.w
div r11.z, l(1.000000, 1.000000, 1.000000, 1.000000), r11.z
mul_sat r11.z, r11.z, r11.w
mad r11.w, r11.z, l(-2.000000), l(3.000000)
mul r11.z, r11.z, r11.z
mul r11.z, r11.z, r11.w
mad r10.x, -r10.z, r10.x, l(1.000000)
mad r10.x, r11.z, r10.x, r11.y
deriv_rty_fine r11.yzw, r5.zzxy
deriv_rtx_fine r12.xyz, r5.yzxy
mul r13.xyz, r11.yzwy, r12.xyzx
mad r11.yzw, r11.wwyz, r12.yyzx, -r13.xxyz
dp3 r11.y, r11.yzwy, r11.yzwy
max r11.y, r11.y, l(0.000000)
rsq r11.y, r11.y
mul_sat r11.y, r11.y, r11.z
mad r11.zw, cb0[227].zzzz, l(0.000000, 0.000000, 0.300000, 0.300000), l(0.000000, 0.000000, 0.686000, 0.687000)
add r12.x, |r3.w|, l(-15.000000)
mul_sat r12.x, r12.x, l(0.015000)
add r12.x, -r12.x, l(1.000000)
min r12.y, l(0.990000), cb0[232].w
max r11.z, r11.z, l(0.970000)
add r12.z, -r11.z, l(0.990000)
add r10.y, r10.y, -r11.z
div r11.z, l(1.000000, 1.000000, 1.000000, 1.000000), r12.z
mul_sat r10.y, r10.y, r11.z
mad r11.z, r10.y, l(-2.000000), l(3.000000)
mul r10.y, r10.y, r10.y
add r12.z, r11.y, l(-0.991000)
mul r12.z, r12.z, l(111.111069)
max r12.z, r12.z, l(0.000000)
mad r12.w, r12.z, l(-2.000000), l(3.000000)
mul r12.z, r12.z, r12.z
mul r12.z, r12.z, r12.w
mad r12.w, r9.w, l(0.200000), l(0.800000)
ge r12.w, r12.w, r1.y
and r12.w, r12.w, l(0x3f800000)
mul r12.z, r12.w, r12.z
mad r10.y, r11.z, r10.y, r12.z
min r10.y, r10.y, l(1.000000)
add r11.z, -r12.y, cb0[232].w
add r10.y, -r12.y, r10.y
div r11.z, l(1.000000, 1.000000, 1.000000, 1.000000), r11.z
mul_sat r10.y, r10.y, r11.z
mad r11.z, r10.y, l(-2.000000), l(3.000000)
mul r10.y, r10.y, r10.y
mul r10.y, r10.y, r11.z
lt r11.z, l(0.000488), cb0[227].y
add r11.y, -r11.w, r11.y
mul_sat r11.y, r11.y, l(-1000.012878)
mad r11.w, r11.y, l(-2.000000), l(3.000000)
mul r11.y, r11.y, r11.y
mul r11.y, r11.y, r11.w
mad r11.w, r3.y, r1.w, l(0.500000)
mul_sat r11.w, r11.w, l(2.500000)
mad r12.y, r11.w, l(-2.000000), l(3.000000)
mul r11.w, r11.w, r11.w
mul r11.w, r11.w, r12.y
mul r11.y, r11.w, r11.y
lt r11.y, l(0.000488), r11.y
and r11.y, r11.y, r11.z
if_nz r11.y
  mul r11.yz, |r2.xxwx|, |r2.xxwx|
  add r11.w, r11.z, r11.y
  div r11.w, l(1.000000, 1.000000, 1.000000, 1.000000), r11.w
  mul r11.yz, r11.wwww, r11.yyzy
  mul r12.yzw, r2.yywx, l(0.000000, 0.000000, 1.000000, 0.000000)
  mad r12.yzw, r2.xxyw, l(0.000000, 1.000000, 0.000000, 0.000000), -r12.yyzw
  dp2 r11.w, r12.yzyy, r12.yzyy
  rsq r11.w, r11.w
  mul r12.yzw, r11.wwww, r12.yyzw
  mul r13.xyz, r2.ywxy, r12.yzwy
  mad r13.xyz, r12.wyzw, r2.wxyw, -r13.xyzx
  dp3 r11.w, r13.xyzx, r13.xyzx
  rsq r11.w, r11.w
  mul r13.xyz, r11.wwww, r13.xzyx
  mad r14.xyz, r5.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.314159, 0.314159, 0.314159, 0.000000)
  round_ni r14.xyz, r14.xyzx
  add r14.xyz, r14.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  add r14.xy, r14.yyyy, r14.xzxx
  mul r14.xy, r14.xyxx, l(0.000977, 0.000977, 0.000000, 0.000000)
  ge r14.zw, r14.xxxy, -r14.xxxy
  frc r14.xy, |r14.xyxx|
  movc r14.xy, r14.zwzz, r14.xyxx, -r14.xyxx
  mul r14.xy, r14.xyxx, l(1024.000000, 1024.000000, 0.000000, 0.000000)
  dp2 r11.w, r14.xyxx, l(12.989800, 78.233002, 0.000000, 0.000000)
  sincos r11.w, null, r11.w
  mul r11.w, r11.w, l(43758.546875)
  frc r11.w, r11.w
  ge r14.xy, r2.wxww, l(0.000000, 0.000000, 0.000000, 0.000000)
  movc r14.xy, r14.xyxx, l(1.000000,-1.000000,0,0), l(-1.000000,1.000000,0,0)
  mul r14.xy, r5.xzxx, r14.xyxx
  mul r12.w, r9.w, r11.w
  add r14.w, -r11.w, l(1.000000)
  mad r14.w, r14.w, l(0.700000), l(0.300000)
  mul r15.xy, r12.wwww, l(3.000000, 6.000000, 0.000000, 0.000000)
  mad r12.w, -cb0[227].x, r14.w, r15.x
  frc r16.x, r12.w
  mad r12.w, cb0[227].x, l(-0.300000), r15.y
  frc r16.y, r12.w
  mul r11.w, r11.w, l(5.000000)
  round_ni r11.w, r11.w
  add r15.x, r11.w, l(1.000000)
  mul r15.y, r5.y, r15.x
  mov r5.w, l(0.100000)
  mul r15.xy, r5.ywyy, r15.xyxx
  frc r15.xy, r15.xyxx
  add r15.zw, r16.xxxy, l(0.000000, 0.000000, -1.000000, -1.000000)
  add r15.zw, -r15.zzzw, r15.xxxy
  add r15.zw, r15.zzzw, l(0.000000, 0.000000, -0.800000, -0.800000)
  mul_sat r15.zw, r15.zzzw, l(0.000000, 0.000000, 5.000000, 5.000000)
  mad r16.zw, r15.zzzw, l(0.000000, 0.000000, -2.000000, -2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
  mul r15.zw, r15.zzzw, r15.zzzw
  mul r15.zw, r15.zzzw, r16.zzzw
  add r16.zw, -r15.xxxy, r16.xxxy
  max r15.zw, r15.zzzw, r16.zzzw
  add r17.xy, -r16.xyxx, r15.xyxx
  add r17.xy, r17.xyxx, l(-0.800000, -0.800000, 0.000000, 0.000000)
  mul r17.xy, r17.xyxx, l(5.000000, 5.000000, 0.000000, 0.000000)
  max r17.xy, r17.xyxx, l(0.000000, 0.000000, 0.000000, 0.000000)
  mad r17.zw, r17.xxxy, l(0.000000, 0.000000, -2.000000, -2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
  mul r17.xy, r17.xyxx, r17.xyxx
  mul r17.xy, r17.xyxx, r17.zwzz
  add r16.zw, r16.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
  max r16.zw, r16.zzzw, r17.xxxy
  ge r15.xy, r15.xyxx, r16.xyxx
  and r15.xy, r15.xyxx, l(0x3f800000, 0x3f800000, 0, 0)
  add r16.xy, -r15.zwzz, r16.zwzz
  mad r15.xy, r15.xyxx, r16.xyxx, r15.zwzz
  mad r11.w, r15.x, r15.x, l(-0.400000)
  mul_sat r11.w, r11.w, l(1.666667)
  mad r12.w, r11.w, l(-2.000000), l(3.000000)
  mul r11.w, r11.w, r11.w
  mul r11.w, r11.w, r12.w
  mad r12.w, r15.y, l(2.000000), l(-1.000000)
  mul r14.w, r11.w, l(0.010000)
  mul r15.x, r12.w, r14.w
  mad r16.x, r9.w, l(0.100000), r15.x
  mul r14.w, r11.w, r14.w
  mad r14.w, r14.w, r12.w, r9.w
  mul r16.y, r9.w, r14.w
  mov r14.z, r5.y
  mad r14.xyzw, r14.yzxz, cb0[228].xyxy, r16.xyxy
  sample_b_indexable(texture2d)(float,float,float,float) r16.xyzw, r14.xyxx, t11.xyzw, s2, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r14.xyzw, r14.zwzz, t11.xyzw, s2, cb0[108].x
  mul r14.xyzw, r11.zzzz, r14.xyzw
  mad r14.xyzw, r16.xyzw, r11.yyyy, r14.xyzw
  mad r11.yz, r14.xxyx, l(0.000000, 2.000000, 2.000000, 0.000000), l(0.000000, -1.000000, -1.000000, 0.000000)
  mad r14.x, r11.w, l(2.000000), l(-1.000000)
  mad_sat r14.x, r14.x, l(0.800000), r15.y
  mad r14.y, -r14.w, l(0.500000), l(1.000000)
  mad r14.x, r14.x, r14.y, l(-0.700000)
  mul_sat r14.x, r14.x, l(3.333333)
  mad r14.y, r14.x, l(-2.000000), l(3.000000)
  mul r14.x, r14.x, r14.x
  mul r14.x, r14.x, r14.y
  mul r12.w, r12.w, r14.w
  mad_sat r11.w, r12.w, l(0.500000), r11.w
  mad r11.w, r11.w, l(0.500000), l(0.100000)
  max r11.w, r11.w, r14.x
  add r12.w, -r11.w, l(1.000000)
  max r12.w, r12.w, l(0.000000)
  mul r14.x, r12.w, r12.w
  mul r14.x, r14.x, r14.x
  mul r12.w, r12.w, r14.x
  ge r12.w, r14.z, r12.w
  and r12.w, r12.w, l(0x3f800000)
  mad r11.w, r11.w, l(0.700000), l(0.200000)
  mad r11.w, r12.w, r11.w, l(0.100000)
  mul r11.w, r14.z, r11.w
  mul r11.w, r11.w, cb0[227].y
  mul r11.w, r11.w, l(0.330000)
  ge r12.w, r1.z, l(0.045000)
  and r12.w, r12.w, l(0x3f800000)
  mul r12.w, r10.x, r12.w
  mul r12.w, r12.w, cb0[226].x
  mul r12.w, r12.x, r12.w
  mul r11.w, r11.w, r12.w
  dp2 r12.w, r11.yzyy, r11.yzyy
  min r12.w, r12.w, l(1.000000)
  add r12.w, -r12.w, l(1.000000)
  sqrt r12.w, r12.w
  max r12.w, r12.w, l(0.000488)
  mul_sat r14.x, r11.w, l(10.000000)
  mad r14.y, r14.x, l(-2.000000), l(3.000000)
  mul r14.x, r14.x, r14.x
  mul r14.x, r14.x, r14.y
  mul r14.x, r14.x, cb0[227].y
  mul r14.xy, r11.yzyy, r14.xxxx
  add r11.y, l(-1.500000), cb0[227].y
  mul_sat r11.y, r11.y, l(0.666667)
  mad r11.z, r11.y, l(-2.000000), l(3.000000)
  mul r11.y, r11.y, r11.y
  mul r11.y, r11.y, r11.z
  mul r11.z, r11.y, l(-0.200000)
  mad r11.y, -r11.y, l(-0.200000), r12.w
  mad r14.z, r11.w, r11.y, r11.z
  dp3 r11.y, r14.xyzx, r14.xyzx
  max r11.y, r11.y, l(0.000000)
  rsq r11.y, r11.y
  mul r14.xyz, r11.yyyy, r14.xyzx
  mov r15.x, r12.z
  mov r15.y, r13.x
  mov r15.z, r2.x
  dp3 r15.x, r15.xyzx, r14.xyzx
  mov r13.w, r2.y
  dp2 r15.y, r13.zwzz, r14.yzyy
  mov r13.x, r12.y
  mov r13.z, r2.w
  dp3 r15.z, r13.xyzx, r14.xyzx
  mad r3.xyz, -r3.xyzx, r1.wwww, r15.xyzx
  mad r13.xyz, r11.wwww, r3.xyzx, r2.xywx
  mul r1.w, r11.w, cb0[227].y
  mul r1.w, r1.w, l(0.330000)
else
  mov r13.xyz, r2.xywx
  mov r1.w, l(0)
endif
lt r3.x, l(0.000488), r10.y
if_nz r3.x
  mul r3.xy, -r5.xzxx, cb0[232].xyxx
  frc r11.yz, r3.xxyx
  lt r12.yz, l(0.000000, 0.000488, 0.000488, 0.000000), cb0[231].yywy
  if_nz r12.y
    round_ni r3.xy, r3.xyxx
    mul r3.xy, r3.xyxx, l(0.000977, 0.000977, 0.000000, 0.000000)
    ge r12.yw, r3.xxxy, -r3.xxxy
    frc r3.xy, |r3.xyxx|
    movc r3.xy, r12.ywyy, r3.xyxx, -r3.xyxx
    mul r3.xy, r3.xyxx, l(1024.000000, 1024.000000, 0.000000, 0.000000)
    dp2 r3.x, r3.xyxx, l(12.989800, 78.233002, 0.000000, 0.000000)
    sincos r3.x, null, r3.x
    mul r3.x, r3.x, l(43758.546875)
    frc r3.x, r3.x
    add r3.y, r3.x, cb0[231].x
    frc r3.y, r3.y
    mul r3.z, cb0[232].z, cb0[232].z
    mul r3.y, r3.z, r3.y
    round_ni r3.y, r3.y
    div r3.z, l(1.000000, 1.000000, 1.000000, 1.000000), cb0[232].z
    ge r3.x, l(0.500000), r3.x
    and r3.x, r3.x, l(0x3f800000)
    add r12.yw, -r11.yyyz, r11.zzzy
    mad r11.yz, r3.xxxx, r12.yywy, r11.yyzy
    div r3.x, r3.y, cb0[232].z
    ge r11.w, r3.x, -r3.x
    frc r3.x, |r3.x|
    movc r3.x, r11.w, r3.x, -r3.x
    mul r3.x, r3.x, cb0[232].z
    mul r14.x, r3.x, r3.z
    add r3.x, l(-1.000000), cb0[232].z
    mul r3.y, r3.z, r3.y
    round_ni r3.y, r3.y
    add r3.x, -r3.y, r3.x
    mul r14.y, r3.x, r3.z
    mad r3.xy, r11.yzyy, r3.zzzz, r14.xyxx
    frc r3.xy, r3.xyxx
    sample_b_indexable(texture2d)(float,float,float,float) r3.xy, r3.xyxx, t12.xyzw, s1, cb0[108].x
    mul r3.xy, r3.xyxx, cb0[231].yyyy
    mad r3.xy, r3.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), -cb0[231].yyyy
  else
    mov r3.xy, l(0,0,0,0)
  endif
  if_nz r12.z
    mov r14.xw, l(0,0,0,0.500000)
    mov r14.y, cb0[231].z
    mad r11.yz, -r5.xxzx, cb0[232].xxyx, r14.xxyx
    mul r14.z, r9.w, l(0.500000)
    add r11.yz, r11.yyzy, r14.zzwz
    add r11.yz, r11.yyzy, l(0.000000, -0.500000, -0.500000, 0.000000)
    sample_b_indexable(texture2d)(float,float,float,float) r14.xy, r11.yzyy, t12.zwxy, s2, cb0[108].x
    mov r15.xz, cb0[231].zzwz
    mov r15.y, l(0)
    mad r11.yz, -r5.xxzx, cb0[232].xxyx, -r15.xxyx
    add r15.y, -r9.w, l(1.000000)
    mov r15.x, l(0.500000)
    mad r12.yz, l(0.000000, 1.000000, 0.500000, 0.000000), r15.xxyx, l(0.000000, -0.500000, -0.500000, 0.000000)
    add r11.yz, r11.yyzy, -r12.yyzy
    sample_b_indexable(texture2d)(float,float,float,float) r14.zw, r11.yzyy, t12.xyzw, s2, cb0[108].x
    mul r14.xyzw, r14.xyzw, cb0[231].wwww
    mad r14.xyzw, r14.xyzw, l(2.000000, 2.000000, 2.000000, 2.000000), -r15.zzzz
    mul r14.xyzw, r9.wwww, r14.xyzw
    add r11.yz, r14.zzwz, r14.xxyx
    add r3.xy, r3.xyxx, r11.yzyy
  endif
  mul r11.y, r2.z, l(0.300000)
  mad r11.y, r9.w, l(0.700000), r11.y
  add r11.z, r2.z, l(-0.100000)
  mul_sat r11.z, r11.z, l(100.000000)
  mul r11.y, r11.z, r11.y
  mul r11.z, r1.y, r11.y
  min r11.z, r11.z, l(0.990000)
  mad_sat r11.y, r11.y, r1.y, l(0.600000)
  add r11.y, -r11.z, r11.y
  add r11.z, -r11.z, cb0[232].w
  div r11.y, l(1.000000, 1.000000, 1.000000, 1.000000), r11.y
  mul_sat r11.y, r11.y, r11.z
  mad r11.z, r11.y, l(-2.000000), l(3.000000)
  mul r11.y, r11.y, r11.y
  mul r11.y, r11.y, r11.z
  mul r10.y, r10.y, cb0[226].x
  dp2 r11.z, r3.xyxx, r3.xyxx
  min r11.z, r11.z, l(1.000000)
  add r11.z, -r11.z, l(1.000000)
  sqrt r11.z, r11.z
  max r3.z, r11.z, l(0.000488)
  dp3 r11.z, r3.xyzx, r3.xyzx
  rsq r11.z, r11.z
  mul r3.xyz, r3.yzxy, r11.zzzz
  mul r11.z, r3.y, l(1.000000)
  mul r11.w, r11.y, r10.y
  mul r11.w, r10.x, r11.w
  mul r11.w, r12.x, r11.w
  mad r3.xyz, r3.xyzx, l(1.000000, 1.000000, -1.000000, 0.000000), -r2.xywx
  mad r13.xyz, r11.wwww, r3.xyzx, r2.xywx
  mul r3.x, r1.y, l(0.200000)
  add r3.y, -r9.w, l(1.000000)
  mul r3.y, r3.y, cb0[232].w
  mul r3.z, r3.y, l(0.500000)
  mad r3.y, -r3.y, l(0.500000), l(1.000000)
  mad r3.y, r11.y, r3.y, r3.z
  add r3.z, l(-0.600000), cb0[232].w
  mul_sat r3.z, r3.z, l(2.500000)
  mad r9.w, r3.z, l(-2.000000), l(3.000000)
  mul r3.z, r3.z, r3.z
  mul r3.z, r3.z, r9.w
  mad_sat r3.y, r3.z, l(0.600000), r3.y
  mul r3.y, r3.y, r10.y
  mul r3.y, r11.z, r3.y
  div r3.x, l(1.000000, 1.000000, 1.000000, 1.000000), r3.x
  mul_sat r3.x, r3.x, r3.y
  mad r3.y, r3.x, l(-2.000000), l(3.000000)
  mul r3.x, r3.x, r3.x
  mul r3.x, r3.x, r3.y
  mul r3.x, r10.x, r3.x
  mul r3.x, r12.x, r3.x
  max r3.x, r3.x, l(0.000000)
else
  mov r3.x, l(0)
endif
min r3.y, r9.z, r9.y
mul r3.z, r10.z, cb0[234].z
mad r9.w, -cb0[234].z, r10.z, l(1.000000)
mad r3.z, r10.x, r9.w, r3.z
mad r9.w, cb0[234].x, cb0[226].w, -cb0[226].w
add r10.x, r10.w, -cb0[226].w
div r9.w, l(1.000000, 1.000000, 1.000000, 1.000000), r9.w
mul_sat r9.w, r9.w, r10.x
mad r10.x, r9.w, l(-2.000000), l(3.000000)
mul r9.w, r9.w, r9.w
mul r9.w, r9.w, r10.x
add r10.x, -r3.z, cb0[234].y
mad r3.z, r9.w, r10.x, r3.z
add r3.z, -r3.z, l(1.000000)
mul r9.w, r3.z, r9.y
add r1.z, r1.z, l(-0.050000)
add r10.x, -r2.z, l(1.000000)
mad_sat r10.y, r10.x, cb0[226].z, cb0[226].y
mad r10.y, r1.w, cb0[228].z, r10.y
mul r10.z, r2.z, r3.x
mad_sat r10.y, r10.z, l(0.100000), r10.y
add r10.z, -r10.y, l(1.000000)
mad r10.y, r1.x, r10.z, r10.y
mul_sat r10.z, r11.x, l(3.333333)
mad r10.w, r10.z, l(-2.000000), l(3.000000)
mul r10.z, r10.z, r10.z
mad r10.z, -r10.w, r10.z, l(1.000000)
mul r10.w, r10.y, cb0[226].x
add r11.x, -r1.x, l(1.000000)
mul r10.w, r10.w, r11.x
mul r10.w, r10.z, r10.w
mad r10.w, r10.w, l(-0.750000), l(1.000000)
mad r10.y, r10.y, l(-0.300000), l(0.900000)
sqrt r11.x, r10.x
add r10.y, r10.y, r11.x
add_sat r10.y, r10.y, l(-0.600000)
max r10.y, r10.x, r10.y
min r10.y, r10.y, l(0.990000)
add_sat r11.x, l(2.000000), -cb0[226].x
mul r11.x, r11.x, cb0[226].x
mul r10.z, r10.z, r11.x
mad r3.z, -r9.y, r3.z, l(1.000000)
mul r3.z, r3.z, r10.z
add r9.y, -r10.x, r10.y
mad r3.z, r3.z, r9.y, r10.x
add r3.z, -r3.z, l(1.000000)
mul_sat r1.zw, r1.zzzw, l(0.000000, 0.000000, 1.052600, 20.000000)
mad r9.y, r1.w, l(-2.000000), l(3.000000)
mul r1.w, r1.w, r1.w
mul r1.w, r1.w, r9.y
max r1.w, r1.w, r3.x
mad r1.w, r1.w, l(-0.900000), l(1.000000)
mul r3.x, r1.w, r3.z
add r9.y, r9.z, l(-1.000000)
mad r10.x, r1.z, r9.y, l(1.000000)
add r10.y, -r1.z, l(1.000000)
movc r9.xy, r9.xxxx, r10.xyxx, l(1.000000,1.000000,0,0)
min r1.z, r3.x, r9.x
mad r1.w, r3.z, r1.w, -r1.z
mad r1.z, r3.y, r1.w, r1.z
add r1.w, -r1.z, r2.z
mad r11.w, r9.w, r1.w, r1.z
ld_indexable(texture2d)(float,float,float,float) r10.xyz, r0.xyzz, t28.xyzw
min r1.z, r10.w, r9.y
add r1.w, -r1.z, r10.w
mad r1.z, r3.y, r1.w, r1.z
add r1.w, -r1.z, l(1.000000)
mad r1.z, r9.w, r1.w, r1.z
mul r3.xyz, r1.zzzz, r10.xyzx
mul r9.xyz, r1.xxxx, r3.xyzx
mad r9.xyz, r10.xyzx, r1.zzzz, -r9.xyzx
mad r1.z, -r1.x, l(0.040000), l(0.040000)
mad r1.xzw, r3.xxyz, r1.xxxx, r1.zzzz
dp3 r2.z, r13.xyzx, r8.xyzx
max r10.x, r2.z, l(0.000000)
mul r3.y, r11.w, r11.w
mul r12.x, r10.x, r10.x
mul r12.z, r10.x, r12.x
mul r2.z, r3.y, r3.y
mul r3.z, r3.y, r2.z
mov r10.yzw, l(0,0.036546,9.063200,0.990440)
dp2 r14.x, l(3.327070, 1.000000, 0.000000, 0.000000), r10.xyxx
dp2 r14.y, l(-9.047560, 1.000000, 0.000000, 0.000000), r10.xzxx
mov r3.x, l(1.000000)
dp2 r9.w, r14.xyxx, r3.xyxx
mov r12.yw, l(0,9.044010,0,1.000000)
dp3 r14.x, l(3.596850, -1.367720, 1.000000, 0.000000), r12.xzwx
dp3 r14.y, l(-16.317400, 1.000000, 9.229490, 0.000000), r12.xyzx
mov r15.x, l(5.565890)
mov r15.yz, r12.xxzx
dp3 r14.z, l(1.000000, 19.788601, -20.212299, 0.000000), r15.xyzx
dp3 r10.y, r14.xyzx, r3.xyzx
div r9.w, r9.w, r10.y
dp2 r14.x, l(-1.285140, 1.000000, 0.000000, 0.000000), r10.xwxx
mov r12.x, l(1.296780)
mov r12.y, r10.x
dp2 r14.y, l(1.000000, -0.755907, 0.000000, 0.000000), r12.xyxx
dp2 r10.y, r14.xyxx, r3.xyxx
dp3 r14.x, l(2.923380, 59.418800, 1.000000, 0.000000), r12.yzwy
mov r12.xw, l(20.322500,0,0,121.563004)
dp3 r14.y, l(1.000000, -27.030199, 222.591995, 0.000000), r12.xyzx
dp3 r14.z, l(626.130005, 316.627014, 1.000000, 0.000000), r12.yzwy
dp3 r3.x, r14.xyzx, r3.xyzx
div r3.x, r10.y, r3.x
mad r10.yzw, r1.xxzw, r9.wwww, r3.xxxx
add r3.x, r3.x, r9.w
ld_indexable(texture2d)(float,float,float,float) r12.x, r0.xyzz, t7.xyzw
lt r0.z, l(0.001000), r12.x
if_nz r0.z
  dp3 r0.z, -r8.xyzx, r13.xyzx
  add r0.z, r0.z, r0.z
  mad r14.xyz, r13.xyzx, -r0.zzzz, -r8.xyzx
  dp3 r0.z, -cb3[0].xyzx, r14.xyzx
  mad r15.xyz, cb3[0].xyzx, r0.zzzz, r14.xyzx
  lt r0.z, r0.z, cb3[4].z
  dp3 r3.z, r15.xyzx, r15.xyzx
  max r3.z, r3.z, l(0.000061)
  rsq r3.z, r3.z
  mul r15.xyz, r3.zzzz, r15.xyzx
  mul r15.xyz, r15.xyzx, cb3[4].yyyy
  mad r15.xyz, -cb3[0].xyzx, cb3[4].zzzz, r15.xyzx
  dp3 r3.z, r15.xyzx, r15.xyzx
  rsq r3.z, r3.z
  mul r15.xyz, r3.zzzz, r15.xyzx
  movc r14.xyz, r0.zzzz, r15.xyzx, r14.xyzx
  mad r15.xyz, r6.xyzx, r7.wwww, r14.xyzx
  dp3 r0.z, r15.xyzx, r15.xyzx
  max r0.z, r0.z, l(0.000061)
  rsq r0.z, r0.z
  mul r15.xyz, r0.zzzz, r15.xyzx
  dp3_sat r11.y, r14.xyzx, r13.xyzx
  dp3_sat r0.z, r13.xyzx, r15.xyzx
  min r11.z, r10.x, l(1.000000)
  mad r3.z, r0.z, r2.z, -r0.z
  mad r0.z, r3.z, r0.z, l(1.000000)
  dp3_sat r3.z, r8.xyzx, r15.xyzx
  add r3.z, -r3.z, l(1.000000)
  mul r9.w, r3.z, r3.z
  mul r9.w, r9.w, r9.w
  mul r12.z, r3.z, r9.w
  add r12.w, -r11.w, l(1.000000)
  mad r14.w, -r12.w, l(0.383026), l(-0.076195)
  mad r14.w, r12.w, r14.w, l(1.049970)
  mad r12.w, r12.w, r14.w, l(0.409255)
  min r12.w, r12.w, l(0.999000)
  add r14.w, -r12.w, l(1.000000)
  add r15.xyz, -r1.xzwx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r15.xyz, r15.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r1.xzwx
  mad r3.z, -r9.w, r3.z, l(1.000000)
  mad r16.xyz, r1.xzwx, r3.zzzz, r12.zzzz
  mul r0.z, r0.z, r0.z
  div r0.z, r2.z, r0.z
  mad r17.xy, -r11.zyzz, r2.zzzz, r11.zyzz
  mad r17.xy, r17.xyxx, r11.zyzz, r2.zzzz
  sqrt r17.xy, r17.xyxx
  mul r17.xy, r11.yzyy, r17.xyxx
  add r2.z, r17.y, r17.x
  add r2.z, r2.z, l(0.000100)
  div r2.z, l(0.500000), r2.z
  mul r0.z, r0.z, r2.z
  mul r16.xyz, r0.zzzz, r16.xyzx
  min r16.xyz, r16.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
  mad r17.xyzw, r11.zwyw, l(0.968750, 0.968750, 0.968750, 0.968750), l(0.015625, 0.015625, 0.015625, 0.015625)
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r17.xyxx, t13.yzxw, s1, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r2.z, r17.zwzz, t13.yzxw, s1, l(0.000000)
  mul r0.z, r0.z, r2.z
  mul r0.z, r12.w, r0.z
  div r0.z, r0.z, r14.w
  mul r17.xyz, r15.xyzx, r15.xyzx
  mul r17.xyz, r0.zzzz, r17.xyzx
  mad r15.xyz, -r15.xyzx, r14.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r15.xyz, r17.xyzx, r15.xyzx
  add r15.xyz, r15.xyzx, r16.xyzx
  mul r15.xyz, r15.xyzx, cb3[4].xxxx
  max r15.xyz, r15.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  min r15.xyz, r15.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
  dp3_sat r0.z, r14.xyzx, r2.xywx
  mul r14.xyz, r0.zzzz, r9.xyzx
  mad r14.xyz, r15.xyzx, r11.yyyy, r14.xyzx
  mul r14.xyz, r14.xyzx, cb3[1].xyzx
  mov r12.y, l(0.500000)
  sample_b_indexable(texture2d)(float,float,float,float) r12.yzw, r12.xyxx, t8.wxyz, s1, cb0[108].x
  add r0.z, -r12.x, l(1.000000)
  mad r12.xyz, r14.xyzx, r12.yzwy, -r14.xyzx
  mad r12.xyz, r0.zzzz, r12.xyzx, r14.xyzx
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r4.zwzz, t14.yzxw, s1, l(0.000000)
  min r0.z, r0.z, l(1.000000)
  mul r12.xyz, r0.zzzz, r12.xyzx
else
  mov r12.xyz, l(0,0,0,0)
endif
mul r11.yz, r4.xxyx, l(0.000000, 0.031250, 0.031250, 0.000000)
round_ni r11.yz, r11.yyzy
mad r0.z, r11.z, cb2[1].y, r11.y
mul r0.z, r0.z, l(8.000000)
ftoi r0.z, r0.z
mad r2.z, -cb0[85].y, cb2[2].w, |r3.w|
round_ni r2.z, r2.z
add r3.z, l(-1.000000), cb2[1].w
max r9.w, r2.z, l(0.000000)
min r3.z, r3.z, r9.w
mul r9.w, r3.z, l(8.000000)
ftoi r9.w, r9.w
ge r2.z, r3.z, r2.z
iadd r3.z, r9.w, cb0[110].y
dp3 r9.w, -r8.xyzx, r13.xyzx
add r9.w, r9.w, r9.w
mad r14.xyz, r13.xyzx, -r9.wwww, -r8.xyzx
min r11.x, r10.x, l(1.000000)
add r9.w, -r11.w, l(1.000000)
mad r10.x, -r9.w, l(0.383026), l(-0.076195)
mad r10.x, r9.w, r10.x, l(1.049970)
mad r9.w, r9.w, r10.x, l(0.409255)
min r9.w, r9.w, l(0.999000)
add r10.x, -r9.w, l(1.000000)
add r15.xyz, -r1.xzwx, l(1.000000, 1.000000, 1.000000, 0.000000)
mad r15.xyz, r15.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r1.xzwx
mad r11.yz, r11.xxwx, l(0.000000, 0.968750, 0.968750, 0.000000), l(0.000000, 0.015625, 0.015625, 0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r11.y, r11.yzyy, t13.yxzw, s1, l(0.000000)
mad r16.xyz, -r15.xyzx, r10.xxxx, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r15.xyz, r15.xyzx, r15.xyzx
mov r17.w, l(1.000000)
mov r18.y, l(1.000000)
mov r19.z, r11.w
mov r20.xyz, l(0,0,0,0)
mov r11.z, l(1.000000)
mov r12.w, l(0)
loop
  ilt r14.w, l(7), r12.w
  breakc_nz r14.w
  iadd r14.w, r0.z, r12.w
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r14.w, r14.w, l(0), t0.xxxx
  iadd r15.w, r3.z, r12.w
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r15.w, r15.w, l(0), t0.xxxx
  and r14.w, r14.w, r15.w
  and r14.w, r2.z, r14.w
  ishl r15.w, r12.w, l(5)
  mov r21.xyz, l(0,0,0,0)
  mov r16.w, r11.z
  mov r18.z, r14.w
  loop
    breakc_z r18.z
    firstbit_lo r18.w, r18.z
    ishl r19.w, l(1), r18.w
    xor r19.w, r18.z, r19.w
    iadd r18.w, r15.w, r18.w
    bfi r22.xyzw, l(29, 29, 29, 29), l(3, 3, 3, 3), r18.wwww, l(1, 3, 5, 6)
    bfi r20.w, l(29), l(3), r18.w, l(7)
    ftou r21.w, cb3[r22.z + 6].w
    ieq r21.w, r21.w, l(1)
    if_nz r21.w
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
      dp4 r21.w, r17.xyzw, r27.xyzw
      mov r25.x, r23.y
      mov r25.z, r24.y
      mov r25.w, r26.x
      dp4 r22.z, r17.xyzw, r25.xyzw
      mov r26.xz, r24.xxzx
      dp4 r17.x, r17.xyzw, r26.xyzw
      max r17.y, |r21.w|, |r22.z|
      max r17.x, |r17.x|, r17.y
      mad r17.y, cb3[r20.w + 6].x, l(0.500000), l(0.500000)
      add r17.x, -r17.y, r17.x
      mad r17.y, -cb3[r20.w + 6].x, l(0.500000), l(0.500000)
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
      mov r18.z, r19.w
      continue
    endif
    ishl r17.z, r18.w, l(3)
    bfi r18.w, l(29), l(3), r18.w, l(2)
    lt r21.w, cb3[r17.z + 6].w, l(1.500000)
    if_nz r21.w
      mad r21.w, cb3[r18.w + 6].y, l(0.500000), l(0.500000)
      add r23.x, r21.w, -|cb3[r18.w + 6].x|
      add r23.y, -r23.x, cb3[r18.w + 6].y
      add r21.w, -|r23.x|, l(1.000000)
      add r21.w, -|r23.y|, r21.w
      ge r22.z, cb3[r18.w + 6].x, l(0.000000)
      max r24.x, r21.w, l(0.000488)
      movc r23.z, r22.z, r24.x, -r24.x
      dp3 r24.x, r23.xyzx, r23.xyzx
      rsq r24.x, r24.x
      mul r24.xyz, r23.xyzx, r24.xxxx
      add r25.xyz, -r5.xyzx, cb3[r22.x + 6].xyzx
      dp3 r23.z, r25.xyzx, r25.xyzx
      rsq r24.w, r23.z
      mul r26.xyz, r24.wwww, r25.xyzx
      dp3_sat r18.x, r13.xyzx, r26.xyzx
      ftoi r25.w, cb3[r20.w + 6].w
      mul r27.xyz, r24.xyzx, cb3[r18.w + 6].zzzz
      mad r28.xyz, -r27.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
      mad r29.xyz, r27.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
      ftou r26.w, cb3[r17.z + 6].w
      and r26.w, r26.w, l(1)
      ieq r27.w, r26.w, l(0)
      not r27.w, r27.w
      lt r28.w, l(0.000000), cb3[r18.w + 6].z
      and r27.w, r27.w, r28.w
      dp3 r28.w, r28.xyzx, r28.xyzx
      sqrt r28.w, r28.w
      dp3 r29.w, r29.xyzx, r29.xyzx
      sqrt r29.w, r29.w
      dp3 r30.x, r13.xyzx, r28.xyzx
      div r30.x, r30.x, r28.w
      dp3 r30.y, r13.xyzx, r29.xyzx
      div r30.y, r30.y, r29.w
      add r30.x, r30.y, r30.x
      mul_sat r30.x, r30.x, l(0.500000)
      dp3 r29.x, r28.xyzx, r29.xyzx
      mad r28.w, r28.w, r29.w, r29.x
      mad r28.w, r28.w, l(0.500000), l(1.000000)
      div r30.y, l(1.000000, 1.000000, 1.000000, 1.000000), r28.w
      movc r19.xy, r27.wwww, r30.xyxx, r18.xyxx
      lt r28.w, cb3[r22.w + 6].w, l(0.000000)
      if_nz r28.w
        mul r28.w, cb3[r22.x + 6].w, cb3[r22.x + 6].w
        mul r28.w, r23.z, r28.w
        mad r28.w, -r28.w, r28.w, l(1.000000)
        max r28.w, r28.w, l(0.000000)
        add r23.z, r23.z, l(1.000000)
        div r23.z, l(1.000000, 1.000000, 1.000000, 1.000000), r23.z
        and r29.x, r27.w, l(0x3f800000)
        add r29.y, r19.y, -r23.z
        mad r23.z, r29.x, r29.y, r23.z
        mul r28.w, r28.w, r28.w
        mul r23.z, r23.z, r28.w
      else
        mul r29.xyz, r25.xyzx, cb3[r22.x + 6].wwww
        dp3 r28.w, r29.xyzx, r29.xyzx
        min r28.w, r28.w, l(1.000000)
        add r28.w, -r28.w, l(1.000000)
        log r28.w, r28.w
        mul r28.w, r28.w, cb3[r22.w + 6].w
        exp r28.w, r28.w
        mul r23.z, r19.y, r28.w
      endif
      dp3 r19.y, r26.xyzx, -r24.xyzx
      add r19.y, r19.y, -cb3[r18.w + 6].z
      mul_sat r19.y, r19.y, cb3[r18.w + 6].w
      mul r19.y, r19.y, r19.y
      movc r19.y, r26.w, l(1.000000), r19.y
      mul r19.y, r19.y, r23.z
      not r23.z, r27.w
      ige r24.x, r25.w, l(0)
      and r23.z, r23.z, r24.x
      if_nz r23.z
        if_z r26.w
          ishl r23.z, r25.w, l(2)
          mul r24.xyz, r5.yyyy, cb6[r23.z + 33].xywx
          mad r24.xyz, cb6[r23.z + 32].xywx, r5.xxxx, r24.xyzx
          mad r24.xyz, cb6[r23.z + 34].xywx, r5.zzzz, r24.xyzx
          add r24.xyz, r24.xyzx, cb6[r23.z + 35].xywx
          div_sat r24.xy, r24.xyxx, r24.zzzz
          mad r24.xy, r24.xyxx, cb6[r25.w + 0].zwzz, cb6[r25.w + 0].xyxx
        else
          ishl r23.z, r25.w, l(2)
          dp3 r29.x, -r25.xyzx, cb6[r23.z + 32].xyzx
          dp3 r29.y, -r25.xyzx, cb6[r23.z + 33].xyzx
          dp3 r29.z, -r25.xyzx, cb6[r23.z + 34].xyzx
          lt r23.z, |r29.x|, |r29.y|
          and r23.z, r23.z, l(1)
          dp2 r24.z, |r29.xyxx|, icb[r23.z + 0].xyxx
          lt r24.z, r24.z, |r29.z|
          movc r23.z, r24.z, l(2), r23.z
          dp3 r24.z, r29.xyzx, icb[r23.z + 0].xyzx
          lt r24.z, r24.z, l(0.000000)
          bfi r23.z, l(31), l(1), r23.z, r24.z
          ushr r24.z, r23.z, l(1)
          dp3 r24.z, r29.xyzx, icb[r24.z + 0].xyzx
          div r28.w, l(0.000244), cb6[r25.w + 0].w
          add r28.w, -r28.w, l(0.500000)
          utof r29.w, r23.z
          ult r30.x, r23.z, l(2)
          and r30.x, r30.x, l(2)
          dp2 r29.x, r29.xzxx, icb[r30.x + 0].xzxx
          mul r29.x, r29.x, icb[r23.z + 4].z
          div r29.x, r29.x, |r24.z|
          mad r29.x, r29.x, r28.w, r29.w
          add r29.x, r29.x, l(0.500000)
          mul_sat r30.x, r29.x, l(0.166667)
          iadd r29.x, l(-1), icb[r23.z + 4].y
          dp2 r29.x, r29.yzyy, icb[r29.x + 0].xyxx
          mul r23.z, r29.x, icb[r23.z + 4].w
          div r23.z, r23.z, |r24.z|
          mad_sat r30.y, -r23.z, r28.w, l(0.500000)
          mad r24.xy, r30.xyxx, cb6[r25.w + 0].zwzz, cb6[r25.w + 0].xyxx
        endif
        sample_l_indexable(texture2d)(float,float,float,float) r23.z, r24.xyxx, t15.yzxw, s1, l(0.000000)
        mul r19.y, r19.y, r23.z
      endif
      lt r23.z, l(0.000000), r19.y
      if_nz r23.z
        if_z r26.w
          ftoi r24.x, cb3[r22.y + 6].x
        else
          add r29.xyz, r5.xyzx, -cb3[r22.x + 6].xyzx
          lt r30.xyz, |r29.yzzy|, |r29.xxyx|
          and r24.y, r30.y, r30.x
          lt r29.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r29.xyzx
          ushr r24.z, cb3[r18.w + 6].w, l(24)
          ubfe r30.xy, l(8, 8, 0, 0), l(16, 8, 0, 0), cb3[r18.w + 6].wwww
          movc r24.z, r29.x, r24.z, r30.x
          and r25.w, l(255), cb3[r18.w + 6].w
          movc r25.w, r29.y, r30.y, r25.w
          ubfe r26.w, l(8), l(8), cb3[r22.y + 6].x
          and r28.w, l(255), cb3[r22.y + 6].x
          movc r26.w, r29.z, r26.w, r28.w
          movc r25.w, r30.z, r25.w, r26.w
          movc r24.y, r24.y, r24.z, r25.w
          ilt r24.z, r24.y, l(80)
          movc r24.x, r24.z, r24.y, l(-1)
        endif
        ishl r24.y, r24.x, l(2)
        mad r29.xyz, r26.xyzx, cb4[r24.x + 288].xxxx, r5.xyzx
        mul r24.z, l(5.000000), cb4[r24.x + 288].y
        mad r29.xyz, r13.xyzx, r24.zzzz, r29.xyzx
        mul r30.xyzw, r29.yyyy, cb4[r24.y + 65].xyzw
        mad r30.xyzw, cb4[r24.y + 64].xyzw, r29.xxxx, r30.xyzw
        mad r29.xyzw, cb4[r24.y + 66].xyzw, r29.zzzz, r30.xyzw
        add r29.xyzw, r29.xyzw, cb4[r24.y + 67].xyzw
        div r29.xyz, r29.xyzx, r29.wwww
        ge r30.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r29.xyzx
        ge r31.xyz, r29.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
        add r24.yz, -cb4[r24.x + 344].xxyx, cb4[r24.x + 344].zzwz
        mad r24.yz, r29.xxyx, r24.yyzy, cb4[r24.x + 344].xxyx
        mad r29.xy, r24.yzyy, cb4[400].zwzz, l(0.500000, 0.500000, 0.000000, 0.000000)
        round_ni r29.xy, r29.xyxx
        mad r24.yz, r24.yyzy, cb4[400].zzwz, -r29.xxyx
        add r32.xyzw, r24.yyzz, l(0.500000, 1.000000, 0.500000, 1.000000)
        mul r33.xyzw, r32.xxzz, r32.xxzz
        add r32.xz, -r24.yyzy, l(1.000000, 0.000000, 1.000000, 0.000000)
        min r34.xy, r24.yzyy, l(0.000000, 0.000000, 0.000000, 0.000000)
        max r34.zw, r24.yyyz, l(0.000000, 0.000000, 0.000000, 0.000000)
        mul r35.xy, r32.xzxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r34.zw, -r34.zzzw, r34.zzzw, r32.yyyw
        add r34.zw, r34.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
        mul r36.xy, r34.zwzz, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r33.xz, r33.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
        mad r24.yz, r33.yywy, l(0.000000, 0.500000, 0.500000, 0.000000), -r24.yyzy
        mul r37.xy, r24.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r24.yz, -r34.xxyx, r34.xxyx, r32.xxzx
        add r24.yz, r24.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
        mul r34.xy, r24.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r24.yz, r32.yywy, l(0.000000, 0.160000, 0.160000, 0.000000)
        mov r37.z, r34.x
        mov r37.w, r24.y
        mov r35.z, r36.x
        mov r35.w, r33.x
        add r32.xyzw, r35.zwxz, r37.zwxz
        mov r34.z, r37.y
        mov r34.w, r24.z
        mov r36.z, r35.y
        mov r36.w, r33.z
        add r33.xyz, r34.zywz, r36.zywz
        div r34.xyz, r35.xzwx, r32.zwyz
        add r34.xyz, r34.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r34.xyz, r34.yxzy, cb4[400].xxxx
        div r35.xyz, r36.zywz, r33.xyzx
        add r35.xyz, r35.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r35.xyz, r35.xyzx, cb4[400].yyyy
        mov r34.w, r35.x
        mad r36.xyzw, r29.xyxy, cb4[400].xyxy, r34.ywxw
        mad r24.yz, r29.xxyx, cb4[400].xxyx, r34.zzwz
        mov r35.w, r34.y
        mov r34.yw, r35.yyyz
        mad r37.xyzw, r29.xyxy, cb4[400].xyxy, r34.xyzy
        mad r35.xyzw, r29.xyxy, cb4[400].xyxy, r35.wywz
        mad r34.xyzw, r29.xyxy, cb4[400].xyxy, r34.xwzw
        mul r38.xyzw, r32.zwyz, r33.xxxy
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.w, r36.xyxx, t6.xxxx, s4, r29.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r26.w, r36.zwzz, t6.xxxx, s4, r29.z
        mul r26.w, r26.w, r38.y
        mad r25.w, r38.x, r25.w, r26.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.y, r24.yzyy, t6.xxxx, s4, r29.z
        mad r24.y, r38.z, r24.y, r25.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.z, r35.xyxx, t6.xxxx, s4, r29.z
        mad r24.y, r38.w, r24.z, r24.y
        mul r36.xyzw, r32.xyzw, r33.yyzz
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.z, r37.xyxx, t6.xxxx, s4, r29.z
        mad r24.y, r36.x, r24.z, r24.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.z, r37.zwzz, t6.xxxx, s4, r29.z
        mad r24.y, r36.y, r24.z, r24.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.z, r35.zwzz, t6.xxxx, s4, r29.z
        mad r24.y, r36.z, r24.z, r24.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r24.z, r34.xyxx, t6.xxxx, s4, r29.z
        mad r24.y, r36.w, r24.z, r24.y
        ige r24.z, r24.x, l(0)
        or r29.xyw, r30.xyxz, r31.xyxz
        or r25.w, r29.y, r29.x
        or r25.w, r29.w, r25.w
        and r26.w, r29.z, l(0x7fffffff)
        ult r26.w, l(0x7f800000), r26.w
        or r25.w, r25.w, r26.w
        mul r26.w, r32.y, r33.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r28.w, r34.zwzz, t6.xxxx, s4, r29.z
        mad r24.y, r26.w, r28.w, r24.y
        add r24.y, r24.y, l(-1.000000)
        mad r24.x, cb4[r24.x + 288].w, r24.y, l(1.000000)
        movc r24.x, r25.w, l(1.000000), r24.x
        movc r24.x, r24.z, r24.x, l(1.000000)
      else
        mov r24.x, l(1.000000)
      endif
      if_nz r27.w
        dp3 r24.y, r14.xyzx, r27.xyzx
        mul_sat r24.z, r24.w, cb3[r18.w + 6].z
        mad r24.z, r24.z, l(0.500000), r3.y
        min r24.z, r24.z, l(1.000000)
        div r24.z, r3.y, r24.z
        mad r29.xyz, r14.xyzx, r24.yyyy, -r27.xyzx
        dp3 r25.w, r28.xyzx, r29.xyzx
        mul r24.y, r24.y, r24.y
        mad r24.y, cb3[r18.w + 6].z, cb3[r18.w + 6].z, -r24.y
        div_sat r24.y, r25.w, r24.y
        mad r27.xyz, r27.xyzx, r24.yyyy, r28.xyzx
        dp3 r24.y, r27.xyzx, r27.xyzx
        rsq r24.y, r24.y
        mul r26.xyz, r24.yyyy, r27.xyzx
      else
        mov r24.z, l(1.000000)
      endif
      if_nz r23.z
        mul_sat r23.z, r24.w, cb3[r20.w + 6].y
        mad r26.xyz, r6.xyzx, r7.wwww, r26.xyzx
        dp3 r24.y, r26.xyzx, r26.xyzx
        max r24.y, r24.y, l(0.000061)
        rsq r24.y, r24.y
        mul r26.xyz, r24.yyyy, r26.xyzx
        max r21.w, r21.w, l(0.000000)
        movc r23.w, r22.z, r21.w, -r21.w
        dp3 r21.w, r23.xywx, r23.xywx
        rsq r21.w, r21.w
        mul r23.xyw, r21.wwww, r23.xyxw
        mul r23.xyw, r23.xyxw, cb3[r18.w + 6].zzzz
        mad r27.xyz, -r23.xywx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
        mad r23.xyw, r23.xyxw, l(0.500000, 0.500000, 0.000000, 0.500000), r25.xyxz
        dp3 r21.w, r13.xyzx, r27.xyzx
        dp3 r22.z, r27.xyzx, r27.xyzx
        sqrt r22.z, r22.z
        div r21.w, r21.w, r22.z
        dp3 r22.z, r13.xyzx, r23.xywx
        dp3 r23.x, r23.xywx, r23.xywx
        sqrt r23.x, r23.x
        div r22.z, r22.z, r23.x
        add r21.w, r21.w, r22.z
        mul_sat r21.w, r21.w, l(0.500000)
        movc r18.x, r27.w, r21.w, r18.x
        dp3_sat r21.w, r13.xyzx, r26.xyzx
        dp3_sat r22.z, r8.xyzx, r26.xyzx
        lt r23.x, l(0.000000), r23.z
        mul r23.y, r23.z, r23.z
        mad r23.z, r22.z, l(3.600000), l(0.400000)
        div r23.y, r23.y, r23.z
        mad r23.y, r11.w, r11.w, r23.y
        min r23.y, r23.y, l(1.000000)
        movc r23.x, r23.x, r23.y, r3.y
        mul r23.x, r23.x, r23.x
        mad r23.y, r21.w, r23.x, -r21.w
        mad r21.w, r23.y, r21.w, l(1.000000)
        add r22.z, -r22.z, l(1.000000)
        mul r23.y, r22.z, r22.z
        mul r23.y, r23.y, r23.y
        mul r23.z, r22.z, r23.y
        mad r22.z, -r23.y, r22.z, l(1.000000)
        mad r23.yzw, r1.xxzw, r22.zzzz, r23.zzzz
        mul r21.w, r21.w, r21.w
        div r21.w, r23.x, r21.w
        mul r21.w, r24.z, r21.w
        mad r22.z, -r11.x, r23.x, r11.x
        mad r22.z, r22.z, r11.x, r23.x
        sqrt r22.z, r22.z
        mad r24.y, -r19.x, r23.x, r19.x
        mad r23.x, r24.y, r19.x, r23.x
        sqrt r23.x, r23.x
        mul r23.x, r11.x, r23.x
        mad r22.z, r19.x, r22.z, r23.x
        add r22.z, r22.z, l(0.000100)
        div r22.z, l(0.500000), r22.z
        mul r21.w, r21.w, r22.z
        mul r23.xyz, r21.wwww, r23.yzwy
        min r23.xyz, r23.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
        mad r24.yz, r19.xxzx, l(0.000000, 0.968750, 0.968750, 0.000000), l(0.000000, 0.015625, 0.015625, 0.000000)
        sample_l_indexable(texture2d)(float,float,float,float) r21.w, r24.yzyy, t13.yzwx, s1, l(0.000000)
        mul r21.w, r11.y, r21.w
        mul r21.w, r9.w, r21.w
        div r21.w, r21.w, r10.x
        mul r24.yzw, r15.xxyz, r21.wwww
        div r24.yzw, r24.yyzw, r16.xxyz
        add r23.xyz, r23.xyzx, r24.yzwy
        mul r23.xyz, r23.xyzx, cb3[r20.w + 6].zzzz
        max r23.xyz, r23.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
        min r23.xyz, r23.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
        mul r24.yzw, r9.xxyz, r18.xxxx
        mad r23.xyz, r23.xyzx, r19.xxxx, r24.yzwy
        mul r24.yzw, r19.yyyy, cb3[r17.z + 6].xxyz
        mul r24.xyz, r24.xxxx, r24.yzwy
        mul r24.xyz, r17.xxxx, r24.xyzx
        mul r23.xyz, r23.xyzx, r24.xyzx
      else
        mov r23.xyz, l(0,0,0,0)
      endif
    else
      if_z r17.y
        mad r17.x, cb3[r18.w + 6].y, l(0.500000), l(0.500000)
        add r24.x, r17.x, -|cb3[r18.w + 6].x|
        add r24.y, -r24.x, cb3[r18.w + 6].y
        add r17.x, -|r24.x|, l(1.000000)
        add r17.x, -|r24.y|, r17.x
        max r17.x, r17.x, l(0.000488)
        ge r17.y, cb3[r18.w + 6].x, l(0.000000)
        movc r24.z, r17.y, r17.x, -r17.x
        dp3 r17.x, r24.xyzx, r24.xyzx
        rsq r17.x, r17.x
        mul r24.xyz, r17.xxxx, r24.xyzx
        add r25.xyz, -r5.xyzx, cb3[r22.x + 6].xyzx
        dp3 r17.x, r25.xyzx, r25.xyzx
        rsq r17.y, r17.x
        mul r26.xyz, r17.yyyy, r25.xyzx
        ftoi r17.y, cb3[r20.w + 6].w
        mul r27.xyz, r24.xyzx, cb3[r18.w + 6].zzzz
        mad r28.xyz, -r27.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
        mad r27.xyz, r27.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r25.xyzx
        ftou r17.z, cb3[r17.z + 6].w
        and r17.z, r17.z, l(1)
        ieq r18.x, r17.z, l(0)
        not r18.x, r18.x
        lt r19.x, l(0.000000), cb3[r18.w + 6].z
        and r18.x, r18.x, r19.x
        dp3 r19.x, r28.xyzx, r28.xyzx
        dp3 r19.y, r27.xyzx, r27.xyzx
        sqrt r19.xy, r19.xyxx
        dp3 r20.w, r28.xyzx, r27.xyzx
        mad r19.x, r19.x, r19.y, r20.w
        mad r19.x, r19.x, l(0.500000), l(1.000000)
        div r19.x, l(1.000000, 1.000000, 1.000000, 1.000000), r19.x
        movc r19.x, r18.x, r19.x, l(1.000000)
        lt r19.y, cb3[r22.w + 6].w, l(0.000000)
        if_nz r19.y
          mul r19.y, cb3[r22.x + 6].w, cb3[r22.x + 6].w
          mul r19.y, r17.x, r19.y
          mad r19.y, -r19.y, r19.y, l(1.000000)
          max r19.y, r19.y, l(0.000000)
          add r17.x, r17.x, l(1.000000)
          div r17.x, l(1.000000, 1.000000, 1.000000, 1.000000), r17.x
          and r20.w, r18.x, l(0x3f800000)
          add r21.w, -r17.x, r19.x
          mad r17.x, r20.w, r21.w, r17.x
          mul r19.y, r19.y, r19.y
          mul r17.x, r17.x, r19.y
        else
          mul r27.xyz, r25.xyzx, cb3[r22.x + 6].wwww
          dp3 r19.y, r27.xyzx, r27.xyzx
          min r19.y, r19.y, l(1.000000)
          add r19.y, -r19.y, l(1.000000)
          log r19.y, r19.y
          mul r19.y, r19.y, cb3[r22.w + 6].w
          exp r19.y, r19.y
          mul r17.x, r19.y, r19.x
        endif
        dp3 r19.x, r26.xyzx, -r24.xyzx
        add r19.x, r19.x, -cb3[r18.w + 6].z
        mul_sat r19.x, r19.x, cb3[r18.w + 6].w
        mul r19.x, r19.x, r19.x
        movc r19.x, r17.z, l(1.000000), r19.x
        mul r17.x, r17.x, r19.x
        not r18.x, r18.x
        ige r19.x, r17.y, l(0)
        and r18.x, r18.x, r19.x
        if_nz r18.x
          if_z r17.z
            ishl r18.x, r17.y, l(2)
            mul r24.xyz, r5.yyyy, cb6[r18.x + 33].xywx
            mad r24.xyz, cb6[r18.x + 32].xywx, r5.xxxx, r24.xyzx
            mad r24.xyz, cb6[r18.x + 34].xywx, r5.zzzz, r24.xyzx
            add r24.xyz, r24.xyzx, cb6[r18.x + 35].xywx
            div_sat r19.xy, r24.xyxx, r24.zzzz
            mad r19.xy, r19.xyxx, cb6[r17.y + 0].zwzz, cb6[r17.y + 0].xyxx
          else
            ishl r18.x, r17.y, l(2)
            dp3 r24.x, -r25.xyzx, cb6[r18.x + 32].xyzx
            dp3 r24.y, -r25.xyzx, cb6[r18.x + 33].xyzx
            dp3 r24.z, -r25.xyzx, cb6[r18.x + 34].xyzx
            lt r18.x, |r24.x|, |r24.y|
            and r18.x, r18.x, l(1)
            dp2 r20.w, |r24.xyxx|, icb[r18.x + 0].xyxx
            lt r20.w, r20.w, |r24.z|
            movc r18.x, r20.w, l(2), r18.x
            dp3 r20.w, r24.xyzx, icb[r18.x + 0].xyzx
            lt r20.w, r20.w, l(0.000000)
            bfi r18.x, l(31), l(1), r18.x, r20.w
            ushr r20.w, r18.x, l(1)
            dp3 r20.w, r24.xyzx, icb[r20.w + 0].xyzx
            div r21.w, l(0.000244), cb6[r17.y + 0].w
            add r21.w, -r21.w, l(0.500000)
            utof r22.z, r18.x
            ult r22.w, r18.x, l(2)
            and r22.w, r22.w, l(2)
            dp2 r22.w, r24.xzxx, icb[r22.w + 0].xzxx
            mul r22.w, r22.w, icb[r18.x + 4].z
            div r22.w, r22.w, |r20.w|
            mad r22.z, r22.w, r21.w, r22.z
            add r22.z, r22.z, l(0.500000)
            mul_sat r25.x, r22.z, l(0.166667)
            iadd r22.z, l(-1), icb[r18.x + 4].y
            dp2 r22.z, r24.yzyy, icb[r22.z + 0].xyxx
            mul r18.x, r22.z, icb[r18.x + 4].w
            div r18.x, r18.x, |r20.w|
            mad_sat r25.y, -r18.x, r21.w, l(0.500000)
            mad r19.xy, r25.xyxx, cb6[r17.y + 0].zwzz, cb6[r17.y + 0].xyxx
          endif
          sample_l_indexable(texture2d)(float,float,float,float) r17.y, r19.xyxx, t15.yxzw, s1, l(0.000000)
          mul r17.x, r17.y, r17.x
        endif
        lt r17.x, l(0.000000), r17.x
        if_nz r17.x
          if_z r17.z
            ftoi r17.x, cb3[r22.y + 6].x
          else
            add r22.xzw, r5.xxyz, -cb3[r22.x + 6].xxyz
            lt r24.xyz, |r22.zwwz|, |r22.xxzx|
            and r17.y, r24.y, r24.x
            lt r22.xzw, l(0.000000, 0.000000, 0.000000, 0.000000), r22.xxzw
            ushr r17.z, cb3[r18.w + 6].w, l(24)
            ubfe r19.xy, l(8, 8, 0, 0), l(16, 8, 0, 0), cb3[r18.w + 6].wwww
            movc r17.z, r22.x, r17.z, r19.x
            and r18.x, l(255), cb3[r18.w + 6].w
            movc r18.x, r22.z, r19.y, r18.x
            ubfe r18.w, l(8), l(8), cb3[r22.y + 6].x
            and r19.x, l(255), cb3[r22.y + 6].x
            movc r18.w, r22.w, r18.w, r19.x
            movc r18.x, r24.z, r18.x, r18.w
            movc r17.y, r17.y, r17.z, r18.x
            ilt r17.z, r17.y, l(80)
            movc r17.x, r17.z, r17.y, l(-1)
          endif
          ishl r17.y, r17.x, l(2)
          mad r22.xyz, r26.xyzx, cb4[r17.x + 288].xxxx, r5.xyzx
          mul r17.z, l(5.000000), cb4[r17.x + 288].y
          mad r22.xyz, r2.xywx, r17.zzzz, r22.xyzx
          mul r24.xyzw, r22.yyyy, cb4[r17.y + 65].xyzw
          mad r24.xyzw, cb4[r17.y + 64].xyzw, r22.xxxx, r24.xyzw
          mad r22.xyzw, cb4[r17.y + 66].xyzw, r22.zzzz, r24.xyzw
          add r22.xyzw, r22.xyzw, cb4[r17.y + 67].xyzw
          div r22.xyz, r22.xyzx, r22.wwww
          ge r24.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r22.xyzx
          ge r25.xyz, r22.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
          add r17.yz, -cb4[r17.x + 344].xxyx, cb4[r17.x + 344].zzwz
          mad r17.yz, r22.xxyx, r17.yyzy, cb4[r17.x + 344].xxyx
          mad r18.xw, r17.yyyz, cb4[400].zzzw, l(0.500000, 0.000000, 0.000000, 0.500000)
          round_ni r18.xw, r18.xxxw
          mad r17.yz, r17.yyzy, cb4[400].zzwz, -r18.xxwx
          add r26.xyzw, r17.yyzz, l(0.500000, 1.000000, 0.500000, 1.000000)
          mul r27.xyzw, r26.xxzz, r26.xxzz
          add r19.xy, -r17.yzyy, l(1.000000, 1.000000, 0.000000, 0.000000)
          min r22.xy, r17.yzyy, l(0.000000, 0.000000, 0.000000, 0.000000)
          max r26.xz, r17.yyzy, l(0.000000, 0.000000, 0.000000, 0.000000)
          mul r28.xy, r19.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r26.xz, -r26.xxzx, r26.xxzx, r26.yywy
          add r26.xz, r26.xxzx, l(1.000000, 0.000000, 1.000000, 0.000000)
          mul r29.xy, r26.xzxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r26.xz, r27.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
          mad r17.yz, r27.yywy, l(0.000000, 0.500000, 0.500000, 0.000000), -r17.yyzy
          mul r27.xy, r17.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r17.yz, -r22.xxyx, r22.xxyx, r19.xxyx
          add r17.yz, r17.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
          mul r30.xy, r17.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r17.yz, r26.yywy, l(0.000000, 0.160000, 0.160000, 0.000000)
          mov r27.z, r30.x
          mov r27.w, r17.y
          mov r28.z, r29.x
          mov r28.w, r26.x
          add r31.xyzw, r27.zwxz, r28.zwxz
          mov r30.z, r27.y
          mov r30.w, r17.z
          mov r29.z, r28.y
          mov r29.w, r26.z
          add r22.xyw, r29.zyzw, r30.zyzw
          div r26.xyz, r28.xzwx, r31.zwyz
          add r26.xyz, r26.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r26.xyz, r26.yxzy, cb4[400].xxxx
          div r27.xyz, r29.zywz, r22.xywx
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
          mul r30.xyzw, r22.xxxy, r31.zwyz
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.x, r28.xyxx, t6.xxxx, s4, r22.z
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.w, r28.zwzz, t6.xxxx, s4, r22.z
          mul r18.w, r18.w, r30.y
          mad r18.x, r30.x, r18.x, r18.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.y, r17.yzyy, t6.xxxx, s4, r22.z
          mad r17.y, r30.z, r17.y, r18.x
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.z, r27.xyxx, t6.xxxx, s4, r22.z
          mad r17.y, r30.w, r17.z, r17.y
          mul r28.xyzw, r22.yyww, r31.xyzw
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.z, r29.xyxx, t6.xxxx, s4, r22.z
          mad r17.y, r28.x, r17.z, r17.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.z, r29.zwzz, t6.xxxx, s4, r22.z
          mad r17.y, r28.y, r17.z, r17.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.z, r27.zwzz, t6.xxxx, s4, r22.z
          mad r17.y, r28.z, r17.z, r17.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r17.z, r26.xyxx, t6.xxxx, s4, r22.z
          mad r17.y, r28.w, r17.z, r17.y
          ige r17.z, r17.x, l(0)
          or r24.xyz, r24.xyzx, r25.xyzx
          or r18.x, r24.y, r24.x
          or r18.x, r24.z, r18.x
          and r18.w, r22.z, l(0x7fffffff)
          ult r18.w, l(0x7f800000), r18.w
          or r18.x, r18.w, r18.x
          mul r18.w, r22.w, r31.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r19.x, r26.zwzz, t6.xxxx, s4, r22.z
          mad r17.y, r18.w, r19.x, r17.y
          add r17.y, r17.y, l(-1.000000)
          mad r17.x, cb4[r17.x + 288].w, r17.y, l(1.000000)
          movc r17.x, r18.x, l(1.000000), r17.x
          movc r17.x, r17.z, r17.x, l(1.000000)
        else
          mov r17.x, l(1.000000)
        endif
      else
        mov r17.x, l(1.000000)
      endif
      mul r16.w, r16.w, r17.x
      mov r23.xyz, l(0,0,0,0)
    endif
    add r21.xyz, r21.xyzx, r23.xyzx
    mov r18.z, r19.w
  endloop
  mov r11.z, r16.w
  add r20.xyz, r20.xyzx, r21.xyzx
  iadd r12.w, r12.w, l(1)
endloop
mad r6.xyz, r20.xyzx, r11.zzzz, r12.xyzx
ne r3.yz, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[112].xxyx
if_nz r3.y
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t4.yzxw, s0, cb0[108].x
  min r0.z, r1.y, r0.z
  dp3 r2.z, r2.xywx, r8.xyzx
  max r2.z, r2.z, l(0.000000)
  add r2.z, r0.z, r2.z
  mad r3.y, r11.w, l(-16.000000), l(-1.000000)
  exp r3.y, r3.y
  log r2.z, |r2.z|
  mul r2.z, r2.z, r3.y
  exp r2.z, r2.z
  add r2.z, r0.z, r2.z
  add r2.z, r2.z, l(-1.000000)
  mov_sat r11.xyz, r2.zzzz
  mad r12.xyz, r9.xyzx, l(2.040400, 2.040400, 2.040400, 0.000000), l(-0.332400, -0.332400, -0.332400, 0.000000)
  mul r12.xyz, r0.zzzz, r12.xyzx
  mad r12.xyz, r9.xyzx, l(-4.795100, -4.795100, -4.795100, 0.000000), r12.xyzx
  add r12.xyz, r12.xyzx, l(0.641700, 0.641700, 0.641700, 0.000000)
  mul r12.xyz, r0.zzzz, r12.xyzx
  mad r12.xyz, r9.xyzx, l(2.755200, 2.755200, 2.755200, 0.000000), r12.xyzx
  add r12.xyz, r12.xyzx, l(0.690300, 0.690300, 0.690300, 0.000000)
  mul r12.xyz, r0.zzzz, r12.xyzx
  max r12.xyz, r0.zzzz, r12.xyzx
else
  mov r11.xyz, r1.yyyy
  mov r12.xyz, r1.yyyy
endif
mad r15.xyz, r2.xywx, l(0.250000, 0.250000, 0.250000, 0.000000), r5.xyzx
round_z r0.z, cb0[216].x
mad r16.xy, r0.zzzz, l(2.083000, 4.867000, 0.000000, 0.000000), r4.xyxx
dp2 r0.z, r16.xyxx, l(0.067111, 0.005837, 0.000000, 0.000000)
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
add r1.y, |r16.z|, l(-208.000000)
mul_sat r1.y, r1.y, l(0.031250)
max r0.z, r0.z, r1.y
ne r1.y, l(0.000000), cb0[214].w
lt r2.z, r0.z, l(1.000000)
and r1.y, r1.y, r2.z
if_nz r1.y
  mad r16.xyz, cb0[6].xzyx, -cb0[216].yyyy, cb0[214].xzyx
  add r16.xyz, r15.xzyx, -r16.xyzx
  max r1.y, |r16.y|, |r16.x|
  add r1.y, r1.y, l(-29.000000)
  mul_sat r1.y, r1.y, l(0.500000)
  add r2.z, |r16.z|, l(-13.000000)
  mul_sat r2.z, r2.z, l(0.500000)
  max r1.y, r1.y, r2.z
  lt r2.z, r1.y, l(1.000000)
  if_nz r2.z
    mad r16.xyz, r15.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r17.xyz, r16.xyzx, cb0[215].xyzx
    round_ni r17.xyz, r17.xyzx
    mad r16.xyz, r16.xyzx, cb0[215].xyzx, -r17.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r17.xyw, r16.xyzx, t19.yzwx, s2, l(0.000000)
    add r2.z, -r1.y, l(1.000000)
    mul r3.y, l(0.500000), cb0[215].y
    mad r9.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r3.y, r3.y, r16.y
    min r3.y, r9.w, r3.y
    mul r16.w, r3.y, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyzw, r16.xwzx, t20.xyzw, s1, l(0.000000)
    mad r3.y, r18.w, r2.z, r0.z
    add r19.xyz, r16.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyz, r19.xyzx, t20.xyzw, s1, l(0.000000)
    mad r19.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r19.xyz, r17.yyyy, r19.xyzx
    mov r19.w, r17.y
    mul r19.xyzw, r2.zzzz, r19.xyzw
    add r16.xyz, r16.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r16.xyz, r16.xyzx, t20.xyzw, s1, l(0.000000)
    mad r16.xyz, r16.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r16.xyz, r17.xxxx, r16.xyzx
    mov r16.w, r17.x
    mul r16.xyzw, r2.zzzz, r16.xyzw
    mad r18.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r17.xyz, r17.wwww, r18.xyzx
    mul r17.xyzw, r2.zzzz, r17.xyzw
  else
    mov r19.xyzw, l(0,0,0,0)
    mov r16.xyzw, l(0,0,0,0)
    mov r17.xyzw, l(0,0,0,0)
    mov r3.y, r0.z
  endif
  mad r18.xyz, cb0[6].xzyx, -cb0[216].zzzz, cb0[214].xzyx
  add r18.xyz, r15.xzyx, -r18.xyzx
  max r2.z, |r18.y|, |r18.x|
  add r2.z, r2.z, l(-116.000000)
  mul_sat r2.z, r2.z, l(0.125000)
  add r9.w, |r18.z|, l(-52.000000)
  mul_sat r9.w, r9.w, l(0.125000)
  max r2.z, r2.z, r9.w
  lt r9.w, r2.z, l(1.000000)
  if_nz r9.w
    mad r18.xyz, r15.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r20.xyz, r18.xyzx, cb0[215].xyzx
    round_ni r20.xyz, r20.xyzx
    mad r18.xyz, r18.xyzx, cb0[215].xyzx, -r20.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyw, r18.xyzx, t21.yzwx, s2, l(0.000000)
    add r9.w, -r2.z, l(1.000000)
    mul r1.y, r1.y, r9.w
    mul r9.w, l(0.500000), cb0[215].y
    mad r10.x, -cb0[215].y, l(0.500000), l(1.000000)
    max r9.w, r9.w, r18.y
    min r9.w, r10.x, r9.w
    mul r18.w, r9.w, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyzw, r18.xwzx, t22.xyzw, s1, l(0.000000)
    mad r3.y, r21.w, r1.y, r3.y
    add r22.xyz, r18.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyz, r22.xyzx, t22.xyzw, s1, l(0.000000)
    mad r22.xyz, r22.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r22.xyz, r20.yyyy, r22.xyzx
    mov r22.w, r20.y
    mad r19.xyzw, r22.xyzw, r1.yyyy, r19.xyzw
    add r18.xyz, r18.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyz, r18.xyzx, t22.xyzw, s1, l(0.000000)
    mad r18.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r18.xyz, r20.xxxx, r18.xyzx
    mov r18.w, r20.x
    mad r16.xyzw, r18.xyzw, r1.yyyy, r16.xyzw
    mad r18.xyz, r21.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r20.wwww, r18.xyzx
    mad r17.xyzw, r20.xyzw, r1.yyyy, r17.xyzw
  endif
  lt r1.y, l(0.000000), r2.z
  if_nz r1.y
    mad r15.xyz, r15.xyzx, l(0.125000, 0.125000, 0.125000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r18.xyz, r15.xyzx, cb0[215].xyzx
    mul r20.xyz, l(0.500000, 0.500000, 0.500000, 0.000000), cb0[215].xyzx
    round_ni r18.xyz, r18.xyzx
    mad r15.xyz, r15.xyzx, cb0[215].xyzx, -r18.xyzx
    mad r18.xyz, -cb0[215].xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
    max r15.xyz, r20.xyzx, r15.xyzx
    min r15.xyz, r18.xyzx, r15.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyw, r15.xyzx, t23.yzwx, s2, l(0.000000)
    add r1.y, -r0.z, l(1.000000)
    mul r1.y, r1.y, r2.z
    max r2.z, r20.y, r15.y
    min r2.z, r18.y, r2.z
    mul r15.w, r2.z, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyzw, r15.xwzx, t24.xyzw, s1, l(0.000000)
    add r20.xyz, r15.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyz, r20.xyzx, t24.xyzw, s1, l(0.000000)
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r21.yyyy, r20.xyzx
    mov r20.w, r21.y
    mad r19.xyzw, r20.xyzw, r1.yyyy, r19.xyzw
    add r15.xyz, r15.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r15.xyz, r15.xyzx, t24.xyzw, s1, l(0.000000)
    mad r15.xyz, r15.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r15.xyz, r21.xxxx, r15.xyzx
    mov r15.w, r21.x
    mad r16.xyzw, r15.xyzw, r1.yyyy, r16.xyzw
    mad r15.xyz, r18.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r21.wwww, r15.xyzx
    mad r17.xyzw, r21.xyzw, r1.yyyy, r17.xyzw
    mad r3.y, r18.w, r1.y, r3.y
  endif
  mad_sat r1.y, r3.y, l(2.000000), l(-1.000000)
  add r15.x, -r0.z, r1.y
  add r0.z, r0.z, r1.y
  mul r15.y, r0.z, l(0.500000)
else
  mov r19.xyzw, l(0,0,0,0)
  mov r16.xyzw, l(0,0,0,0)
  mov r17.xyzw, l(0,0,0,0)
  mov r15.xy, l(0,1.000000,0,0)
endif
mul r18.xyzw, r15.yxyy, cb0[217].ywzx
mad r18.y, r18.y, l(0.500000), r18.x
mul r15.zw, r15.yyyx, cb0[217].wwwy
mad r18.x, r15.w, l(0.375000), r15.z
add r17.xyzw, r17.xyzw, r18.wyzx
mul r18.xyzw, r15.yxyy, cb0[218].ywzx
mad r18.y, r18.y, l(0.500000), r18.x
mul r15.zw, r15.yyyx, cb0[218].wwwy
mad r18.x, r15.w, l(0.375000), r15.z
add r16.xyzw, r16.xyzw, r18.wyzx
mul r18.xyzw, r15.yxyy, cb0[219].ywzx
mad r18.y, r18.y, l(0.500000), r18.x
mul r15.xy, r15.yxyy, cb0[219].wyww
mad r18.x, r15.y, l(0.375000), r15.x
add r15.xyzw, r18.wyzx, r19.xyzw
ge r18.xy, r4.zwzz, l(0.000000, 0.000000, 0.000000, 0.000000)
and r0.z, r18.y, r18.x
if_nz r0.z
  sample_l_indexable(texture2d)(float,float,float,float) r18.xyzw, r4.zwzz, t18.xyzw, s1, l(0.000000)
  lt r19.xyzw, l(0.000100, 0.000100, 0.000100, 0.000100), |r18.xyzw|
  or r4.zw, r19.zzzw, r19.xxxy
  or r0.z, r4.w, r4.z
  if_nz r0.z
    dp3 r0.z, r18.yzwy, r18.yzwy
    sqrt r0.z, r0.z
    mov r4.z, l(1.000000)
    mov r4.w, r0.z
    mov r1.y, l(0)
    loop
      ge r2.z, l(4.600000), r4.w
      breakc_nz r2.z
      iadd r2.z, r1.y, l(1)
      mul r19.xy, r4.zwzz, l(0.500000, 0.500000, 0.000000, 0.000000)
      mov r4.zw, r19.xxxy
      mov r1.y, r2.z
      continue
    endloop
    mul r18.xyzw, r4.zzzz, r18.xyzw
    dp3 r0.z, r18.yzwy, r18.yzwy
    sqrt r0.z, r0.z
    mad r0.z, r0.z, cb7[3].x, cb7[3].y
    mad r0.z, r0.z, l(255.000000), l(0.500000)
    mul r19.x, r0.z, l(0.003906)
    mov r19.y, l(0.500000)
    sample_l_indexable(texture2d)(float,float,float,float) r4.zw, r19.xyxx, t17.zwxy, s1, l(0.000000)
    mad r4.zw, r4.zzzw, cb7[2].xxxy, cb7[2].zzzw
    mul r19.x, r4.z, l(3.544908)
    mul r19.yzw, r4.wwww, r18.yyzw
    mul r0.z, r18.x, l(0.406977)
    exp r0.z, r0.z
    mul r18.xyzw, r0.zzzz, r19.xyzw
    mov r19.xyzw, r18.xyzw
    mov r0.z, l(0)
    loop
      uge r2.z, r0.z, r1.y
      breakc_nz r2.z
      mul r20.xyzw, r19.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
      dp4 r2.z, r20.xyzw, r19.xyzw
      dp2 r3.y, r20.yxyy, r19.xyxx
      dp2 r4.z, r20.zxzz, r19.xzxx
      dp2 r4.w, r20.wxww, r19.xwxx
      iadd r9.w, r0.z, l(1)
      mov r19.x, r2.z
      mov r19.y, r3.y
      mov r19.zw, r4.zzzw
      mov r0.z, r9.w
      continue
    endloop
    mul r18.xyzw, r19.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
    mul r19.xyzw, r17.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r0.z, r18.xyzw, r19.xyzw
    dp2 r1.y, r18.yxyy, r19.xyxx
    dp2 r2.z, r18.zxzz, r19.xzxx
    dp2 r3.y, r18.wxww, r19.xwxx
    mul r19.xyzw, r16.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r4.z, r18.xyzw, r19.xyzw
    dp2 r4.w, r18.yxyy, r19.xyxx
    dp2 r9.w, r18.zxzz, r19.xzxx
    dp2 r10.x, r18.wxww, r19.xwxx
    mul r19.xyzw, r15.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r12.w, r18.xyzw, r19.xyzw
    dp2 r14.w, r18.yxyy, r19.xyxx
    dp2 r18.y, r18.zxzz, r19.xzxx
    dp2 r18.x, r18.wxww, r19.xwxx
    mul r17.w, r0.z, l(0.886227)
    mul r17.x, r3.y, l(-1.023327)
    mul r17.y, r1.y, l(-1.023327)
    mul r17.z, r2.z, l(1.023327)
    mul r16.x, r10.x, l(-1.023327)
    mul r16.yw, r4.wwwz, l(0.000000, -1.023327, 0.000000, 0.886227)
    mul r16.z, r9.w, l(1.023327)
    mul r15.w, r12.w, l(0.886227)
    mul r15.y, r14.w, l(-1.023327)
    mul r15.xz, r18.xxyx, l(-1.023327, 0.000000, 1.023327, 0.000000)
  endif
endif
dp3 r0.z, r17.xyzx, r2.xywx
add r0.z, r17.w, r0.z
max r17.x, r0.z, l(0.000000)
dp3 r0.z, r16.xyzx, r2.xywx
add r0.z, r16.w, r0.z
max r17.y, r0.z, l(0.000000)
dp3 r0.z, r15.xyzx, r2.xywx
add r0.z, r15.w, r0.z
max r17.z, r0.z, l(0.000000)
add r0.z, l(-1.000000), cb0[113].x
max r1.y, r11.w, l(0.001000)
log r1.y, r1.y
mad r1.y, -r1.y, l(1.200000), l(1.000000)
add r0.z, r0.z, -r1.y
mul r2.xy, r4.xyxx, cb1[0].wwww
round_ni r2.xy, r2.xyxx
add r1.y, |r3.w|, -cb1[2].y
round_ni r1.y, r1.y
add r2.z, l(-1.000000), cb1[1].x
max r2.w, r1.y, l(0.000000)
min r2.z, r2.z, r2.w
ge r1.y, r2.z, r1.y
mad r2.x, r2.y, cb1[0].x, r2.x
ftoi r2.xy, r2.xzxx
iadd r2.xy, r2.xyxx, cb0[110].zwzz
ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.x, r2.x, l(0), t0.xxxx
ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r2.y, r2.y, l(0), t0.xxxx
and r2.x, r2.y, r2.x
and r1.y, r1.y, r2.x
mul r2.xyz, r17.xyzx, cb0[111].xxxx
dp3 r2.x, r2.xyzx, l(0.212673, 0.715152, 0.072175, 0.000000)
mov r42.x, r2.x  // Store ambient luminance for cubemap modulation
mov r5.w, l(1.000000)
mov r13.w, l(1.000000)
mov r2.yzw, l(0,0,0,0)
mov r3.y, l(1.000000)
mov r4.z, r1.y
mov r4.w, l(0)
loop
  lt r9.w, l(0.010000), r3.y
  ine r10.x, r4.z, l(0)
  and r10.x, r9.w, r10.x
  if_nz r10.x
    firstbit_lo r10.x, r4.z
    ishl r11.w, l(1), r10.x
    xor r4.z, r4.z, r11.w
    ishl r10.x, r10.x, l(3)
    dp4 r15.x, cb1[r10.x + 6].xyzw, r5.xyzw
    dp4 r15.y, cb1[r10.x + 7].xyzw, r5.xyzw
    dp4 r15.z, cb1[r10.x + 8].xyzw, r5.xyzw
    ge r16.xyz, cb1[r10.x + 5].xyzx, |r15.xyzx|
    and r11.w, r16.y, r16.x
    and r11.w, r16.z, r11.w
    if_nz r11.w
      mul r11.w, l(0.100000), cb1[r10.x + 5].x
      mul r16.xyz, |r15.xyzx|, l(0.100000, 0.100000, 0.100000, 0.000000)
      mul r16.xy, r16.xyxx, r16.xyxx
      add r18.xyz, -|r15.xyzx|, cb1[r10.x + 5].xyzx
      mul r18.xyz, r18.xyzx, cb1[r10.x + 9].xyzx
      eq r12.w, l(1.000000), cb1[r10.x + 10].x
      if_nz r12.w
        dp3 r19.x, cb1[r10.x + 6].xyzx, r14.xyzx
        dp3 r19.y, cb1[r10.x + 7].xyzx, r14.xyzx
        dp3 r19.z, cb1[r10.x + 8].xyzx, r14.xyzx
        add r20.xyz, -r15.xyzx, cb1[r10.x + 5].xyzx
        div r20.xyz, r20.xyzx, r19.xyzx
        add r21.xyz, -r15.xyzx, -cb1[r10.x + 5].xyzx
        div r21.xyz, r21.xyzx, r19.xyzx
        lt r22.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r19.xyzx
        movc r20.xyz, r22.xyzx, r20.xyzx, r21.xyzx
        min r12.w, r20.y, r20.x
        min r12.w, r20.z, r12.w
        mad r15.xyz, r19.xyzx, r12.wwww, r15.xyzx
      else
        mov r15.xyz, r14.xyzx
      endif
      dp3 r12.w, r15.xyzx, r15.xyzx
      rsq r12.w, r12.w
      mul r15.xyz, r12.wwww, r15.xyzx
      lt r19.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r15.xyzx
      lt r20.xyz, r15.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
      iadd r19.xyz, -r19.xyzx, r20.xyzx
      itof r19.xyz, r19.xyzx
      dp3 r12.w, r15.xyzx, r19.xyzx
      div r15.xyz, r15.xyzx, r12.wwww
      lt r12.w, r15.z, l(0.000000)
      add r15.zw, -|r15.yyyx|, l(0.000000, 0.000000, 1.000000, 1.000000)
      mul r15.zw, r15.zzzw, r19.xxxy
      movc r15.xy, r12.wwww, r15.zwzz, r15.xyxx
      dp4 r12.w, cb1[r10.x + 4].xyzw, r13.xyzw
      max r12.w, r12.w, l(0.000000)
      max r12.w, r12.w, l(0.000100)
      min r14.w, r18.z, r18.y
      min r14.w, r14.w, r18.x
      add r15.z, r16.y, r16.x
      mad r15.z, r16.z, r16.z, r15.z
      mad r11.w, r11.w, r11.w, -r15.z
      mul r11.w, r11.w, cb1[r10.x + 9].x
      mul r11.w, r11.w, cb1[r10.x + 9].x
      add r15.z, l(1.000000), -cb1[r10.x + 10].y
      mul r11.w, r11.w, r15.z
      mul r11.w, r11.w, l(100.000000)
      mad_sat r11.w, r14.w, cb1[r10.x + 10].y, r11.w
      mul r14.w, r11.w, cb1[r10.x + 10].w
      mad r15.xy, r15.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
      mad r15.xy, r15.xyxx, cb1[1].wwww, cb1[2].wwww
      mov r15.z, cb1[r10.x + 5].w
      sample_l_indexable(texture2darray)(float,float,float,float) r15.xyz, r15.xyzx, t5.xyzw, s3, r0.z
      mul r15.xyz, r15.xyzx, cb1[r10.x + 9].wwww
      div r15.w, r2.x, r12.w
      min r15.w, |r15.w|, l(1.000000)
      mad r15.w, r15.w, l(2.000000), r2.x
      add r12.w, r12.w, l(2.000000)
      div r12.w, r15.w, r12.w
      add r12.w, r12.w, l(-1.000000)
      mad r12.w, r12.w, cb0[112].w, l(1.000000)
      mul r15.xyz, r12.wwww, r15.xyzx
      mul r15.xyz, r14.wwww, r15.xyzx
      mad r2.yzw, r15.xxyz, r3.yyyy, r2.yyzw
      mad r10.x, -r11.w, cb1[r10.x + 10].w, l(1.000000)
      mul r3.y, r3.y, r10.x
    endif
    mov r4.w, l(-1)
    continue
  else
    mov r4.w, r9.w
    break
  endif
  mov r4.w, r9.w
endloop
if_nz r4.w
  dp3 r1.y, r14.xyzx, r14.xyzx
  rsq r1.y, r1.y
  mul r5.xzw, r1.yyyy, r14.xxyz
  lt r14.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r5.xzwx
  lt r15.xyz, r5.xzwx, l(0.000000, 0.000000, 0.000000, 0.000000)
  iadd r14.xyz, -r14.xyzx, r15.xyzx
  itof r14.xyz, r14.xyzx
  dp3 r1.y, r5.xzwx, r14.xyzx
  div r5.xzw, r5.xxzw, r1.yyyy
  lt r1.y, r5.w, l(0.000000)
  add r4.zw, -|r5.zzzx|, l(0.000000, 0.000000, 1.000000, 1.000000)
  mul r4.zw, r4.zzzw, r14.xxxy
  movc r4.zw, r1.yyyy, r4.zzzw, r5.xxxz
  mov r13.w, l(1.000000)
  dp4 r1.y, cb1[3].xyzw, r13.xyzw
  max r1.y, r1.y, l(0.000000)
  max r1.y, r1.y, l(0.000100)
  mad r4.zw, r4.zzzw, l(0.000000, 0.000000, 0.500000, 0.500000), l(0.000000, 0.000000, 0.500000, 0.500000)
  mad r13.xy, r4.zwzz, cb1[1].wwww, cb1[2].wwww
  mov r13.z, l(0)
  sample_l_indexable(texture2darray)(float,float,float,float) r5.xzw, r13.xyzx, t5.xwyz, s3, r0.z
  div r0.z, r2.x, r1.y
  min r0.z, |r0.z|, l(1.000000)
  mad r0.z, r0.z, l(2.000000), r2.x
  add r1.y, r1.y, l(2.000000)
  div r0.z, r0.z, r1.y
  add r0.z, r0.z, l(-1.000000)
  mad r0.z, r0.z, cb0[112].w, l(1.000000)
  mul r5.xzw, r0.zzzz, r5.xxzw
  mad r2.yzw, r5.xxzw, r3.yyyy, r2.yyzw
endif
mul r2.xyz, r2.yzwy, cb0[112].zzzz
mul r2.xyz, r2.xyzx, cb0[111].yyyy
// Cubemap ambient link modulation (cb13[13].y)
if_nz cb13[13].y
  max r42.x, r42.x, l(0.000000)
  min r42.x, r42.x, l(1.000000)
  mad r42.x, r42.x, l(0.750000), l(0.250000)
  mul r2.xyz, r2.xyzx, r42.xxxx
endif
if_nz r3.z
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t3.yzxw, s1, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r5.xzw, v1.xyxx, t2.xwyz, s1, cb0[108].x
  add r1.y, -r0.z, l(1.000000)
  mul r13.xyz, r1.yyyy, r2.xyzx
  mad r2.xyz, r5.xzwx, r0.zzzz, r13.xyzx
endif
mul r5.xzw, r9.xxyz, r17.xxyz
mul r5.xzw, r5.xxzw, cb0[111].xxxx
add r0.z, -r3.x, l(1.000000)
div r0.z, r0.z, r3.x
mul r1.xyz, r0.zzzz, r1.xzwx
mad r1.xyz, r1.xyzx, r10.yzwy, r10.yzwy
mul r1.xyz, r1.xyzx, r2.xyzx
mul r1.xyz, r11.xyzx, r1.xyzx
mad r1.xyz, r5.xzwx, r12.xyzx, r1.xyzx
add r1.xyz, r1.xyzx, r6.xyzx
mad r0.z, r5.y, cb0[156].w, cb0[157].w
max r0.z, r0.z, l(0.010000)
mad r1.w, r8.w, cb0[154].w, -cb0[153].w
max r1.w, r1.w, l(0.000000)
mul r2.x, r0.z, l(-1.442695)
exp r2.x, r2.x
add r2.x, -r2.x, l(1.000000)
div r0.z, r2.x, r0.z
mad r2.x, r5.y, cb0[156].w, cb0[158].w
mul r2.x, r2.x, l(1.442695)
exp r2.x, r2.x
mul r0.z, r0.z, r2.x
mul r0.z, r0.z, -r1.w
mul r2.xyz, r0.zzzz, cb0[155].xyzx
mul r2.xyz, r2.xyzx, l(1.442695, 1.442695, 1.442695, 0.000000)
exp r2.xyz, r2.xyzx
dp3 r0.z, -r8.xyzx, cb0[154].xyzx
mad r1.w, cb0[155].w, cb0[155].w, l(1.000000)
dp2 r2.w, r0.zzzz, cb0[155].wwww
add r1.w, r1.w, -r2.w
lt r2.w, l(0.000000), cb0[165].z
if_nz r2.w
  and r0.w, l(7), cb0[108].w
  imad r0.xyw, r0.xyxw, l(0x0019660d, 0x0019660d, 0, 0x0019660d), l(0x3c6ef35f, 0x3c6ef35f, 0, 0x3c6ef35f)
  imad r0.x, r0.y, r0.w, r0.x
  imad r0.y, r0.w, r0.x, r0.y
  imad r0.w, r0.x, r0.y, r0.w
  imad r3.x, r0.y, r0.w, r0.x
  dp3 r0.x, -r8.xyzx, -r7.xyzx
  add r2.w, r5.y, -cb0[44].y
  lt r3.z, l(0.000000), r0.x
  div r0.x, l(1.000000, 1.000000, 1.000000, 1.000000), r0.x
  and r0.x, r0.x, r3.z
  mul r0.x, r0.x, cb0[165].w
  div r3.z, l(1.000000, 1.000000, 1.000000, 1.000000), r8.w
  mul r4.z, r0.x, r3.z
  mad r4.w, r4.z, r2.w, cb0[44].y
  mad r2.w, -r4.z, r2.w, r2.w
  mad r0.x, -r0.x, r3.z, l(1.000000)
  mul r3.z, r8.w, r0.x
  mul r4.z, r2.w, cb0[159].z
  max r4.z, r4.z, l(-127.000000)
  mul r2.w, r2.w, cb0[162].x
  max r2.w, r2.w, l(-127.000000)
  add r5.x, r4.w, -cb0[159].x
  mul r5.x, r5.x, cb0[159].z
  max r5.x, r5.x, l(-127.000000)
  exp r5.x, -r5.x
  mul r5.x, r5.x, cb0[159].y
  lt r5.z, l(0.000000), |r4.z|
  exp r5.w, -r4.z
  add r5.w, -r5.w, l(1.000000)
  div r5.w, r5.w, r4.z
  mad r4.z, -r4.z, l(0.240227), l(0.693147)
  movc r4.z, r5.z, r5.w, r4.z
  add r4.w, r4.w, -cb0[162].z
  mul r4.w, r4.w, cb0[162].x
  max r4.w, r4.w, l(-127.000000)
  exp r4.w, -r4.w
  mul r4.w, r4.w, cb0[162].y
  lt r5.z, l(0.000000), |r2.w|
  exp r5.w, -r2.w
  add r5.w, -r5.w, l(1.000000)
  div r5.w, r5.w, r2.w
  mad r2.w, -r2.w, l(0.240227), l(0.693147)
  movc r2.w, r5.z, r5.w, r2.w
  mul r2.w, r2.w, r4.w
  mad r2.w, r5.x, r4.z, r2.w
  mad_sat r4.zw, r8.wwww, cb0[160].wwwy, cb0[160].zzzx
  mul r3.z, r3.z, r2.w
  exp r3.z, -r3.z
  min r3.z, r3.z, l(1.000000)
  max r3.z, r3.z, cb0[161].w
  add r3.z, r4.w, r3.z
  add r3.z, r4.z, r3.z
  min r3.z, r3.z, l(1.000000)
  imad r3.y, r0.w, r3.x, r0.y
  ushr r0.yw, r3.xxxy, l(0, 16, 0, 16)
  utof r0.yw, r0.yyyw
  mad r0.yw, r0.yyyw, l(0.000000, 0.000031, 0.000000, 0.000031), l(0.000000, -1.000000, 0.000000, -1.000000)
  mad r0.yw, r0.yyyw, cb0[169].wwww, r4.xxxy
  mul r6.xy, r0.ywyy, cb0[167].xyxx
  mad r0.y, |r3.w|, cb0[166].x, cb0[166].y
  log r0.y, r0.y
  mul r0.y, r0.y, cb0[166].z
  div r6.z, r0.y, cb0[165].z
  sample_l_indexable(texture3d)(float,float,float,float) r9.xyzw, r6.xyzx, t16.xyzw, s1, l(0.000000)
  add r0.y, |r3.w|, -cb0[168].z
  mul_sat r0.y, r0.y, l(1000000.000000)
  add r9.xyzw, r9.xyzw, l(-0.000000, -0.000000, -0.000000, -1.000000)
  mad r9.xyzw, r0.yyyy, r9.xyzw, l(0.000000, 0.000000, 0.000000, 1.000000)
  add r0.y, -r3.z, l(1.000000)
  dp3_sat r0.w, r8.xyzx, cb0[163].xyzx
  log r0.w, r0.w
  mul r0.w, r0.w, cb0[164].w
  exp r0.w, r0.w
  mul r3.xyw, r0.wwww, cb0[164].xyxz
  mad r0.x, r0.x, r8.w, -cb0[163].w
  max r0.x, r0.x, l(0.000000)
  mul r0.x, r0.x, r2.w
  exp r0.x, -r0.x
  min r0.x, r0.x, l(1.000000)
  add r0.x, -r0.x, l(1.000000)
  mul r3.xyw, r0.xxxx, r3.xyxw
  add r0.x, -r4.z, l(1.000000)
  mul r3.xyw, r0.xxxx, r3.xyxw
  mad r0.xyw, cb0[161].xyxz, r0.yyyy, r3.xyxw
  mad r0.xyw, r0.xyxw, r9.wwww, r9.xyxz
  mul r2.w, r3.z, r9.w
else
  add r3.x, r5.y, -cb0[44].y
  mul r3.y, r3.x, cb0[159].z
  mul r3.x, r3.x, cb0[162].x
  add r3.z, cb0[44].y, -cb0[159].x
  mul r3.z, r3.z, cb0[159].z
  max r3.xyz, r3.xyzx, l(-127.000000, -127.000000, -127.000000, 0.000000)
  exp r3.z, -r3.z
  mul r3.z, r3.z, cb0[159].y
  lt r3.w, l(0.000000), |r3.y|
  exp r4.x, -r3.y
  add r4.x, -r4.x, l(1.000000)
  div r4.x, r4.x, r3.y
  mad r3.y, -r3.y, l(0.240227), l(0.693147)
  movc r3.y, r3.w, r4.x, r3.y
  add r3.w, cb0[44].y, -cb0[162].z
  mul r3.w, r3.w, cb0[162].x
  max r3.w, r3.w, l(-127.000000)
  exp r3.w, -r3.w
  mul r3.w, r3.w, cb0[162].y
  lt r4.x, l(0.000000), |r3.x|
  exp r4.y, -r3.x
  add r4.y, -r4.y, l(1.000000)
  div r4.y, r4.y, r3.x
  mad r3.x, -r3.x, l(0.240227), l(0.693147)
  movc r3.x, r4.x, r4.y, r3.x
  mul r3.x, r3.x, r3.w
  mad r3.x, r3.z, r3.y, r3.x
  mad_sat r3.yz, r8.wwww, cb0[160].wwyw, cb0[160].zzxz
  mul r3.w, r8.w, r3.x
  exp r3.w, -r3.w
  min r3.w, r3.w, l(1.000000)
  max r3.w, r3.w, cb0[161].w
  add r3.z, r3.z, r3.w
  add r3.z, r3.y, r3.z
  min r2.w, r3.z, l(1.000000)
  add r3.z, -r2.w, l(1.000000)
  dp3_sat r3.w, r8.xyzx, cb0[163].xyzx
  log r3.w, r3.w
  mul r3.w, r3.w, cb0[164].w
  exp r3.w, r3.w
  mul r4.xyz, r3.wwww, cb0[164].xyzx
  mad r3.w, r6.w, r7.w, -cb0[163].w
  max r3.w, r3.w, l(0.000000)
  mul r3.x, r3.w, r3.x
  exp r3.x, -r3.x
  min r3.x, r3.x, l(1.000000)
  add r3.x, -r3.x, l(1.000000)
  mul r4.xyz, r3.xxxx, r4.xyzx
  add r3.x, -r3.y, l(1.000000)
  mul r3.xyw, r3.xxxx, r4.xyxz
  mad r0.xyw, cb0[161].xyxz, r3.zzzz, r3.xyxw
endif
mul r3.xyz, r2.wwww, r2.xyzx
max r1.xyz, r1.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
min r1.xyz, r1.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
mad r0.z, r0.z, r0.z, l(1.000000)
mul r0.z, r0.z, l(0.059683)
mad r4.xyz, cb0[156].xyzx, r0.zzzz, cb0[158].xyzx
mad r0.z, -cb0[155].w, cb0[155].w, l(1.000000)
mul r3.w, r1.w, l(12.566371)
sqrt r1.w, r1.w
mul r1.w, r1.w, r3.w
max r1.w, r1.w, l(0.001000)
div r0.z, r0.z, r1.w
mad_sat r4.xyz, cb0[157].xyzx, r0.zzzz, r4.xyzx
mul r4.xyz, r4.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
add r2.xyz, -r2.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r2.xyz, r2.xyzx, r4.xyzx
mad r0.xyz, r2.xyzx, r2.wwww, r0.xywx
lt r41.x, l(0.500000), cb13[12].y
if_nz r41.x
  mul r39.xyz, r3.xyzx, l(-1.000000, -1.000000, -1.000000, 0.000000)
  add r39.xyz, r39.xyzx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r39.xyz, r39.xyzx, l(0.350000, 0.350000, 0.350000, 0.000000), r3.xyzx
  mul r40.xyz, r0.xyzx, l(0.650000, 0.650000, 0.650000, 0.000000)
  mad o0.xyz, r1.xyzx, r39.xyzx, r40.xyzx
else
  mad o0.xyz, r1.xyzx, r3.xyzx, r0.xyzx
endif
dp3 o0.w, r3.xyzx, l(0.333333, 0.333333, 0.333333, 0.000000)
ret
// Approximately 0 instruction slots used
