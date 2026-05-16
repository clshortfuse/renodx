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
dcl_resource_texture3d (float,float,float,float) t29
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
movc r8.xyz, r6.xxxx, r6.yzwy, r7.xyzx
dp3 r6.x, r8.xyzx, r8.xyzx
max r7.w, r6.x, l(0.000000)
rsq r7.w, r7.w
mul r9.xyz, r7.wwww, r8.xyzx
mul r8.w, r6.x, r7.w
lt r9.w, l(0.000488), cb0[238].x
if_nz r9.w
  sample_b_indexable(texture2d)(float,float,float,float) r10.xy, v1.xyxx, t25.xyzw, s1, cb0[108].x
else
  mov r10.xy, l(1.000000,1.000000,0,0)
endif
lt r10.zw, l(0.000000, 0.000000, 0.500000, 0.500000), cb0[230].xxxy
if_nz r10.z
  add r10.z, |r2.y|, |r2.x|
  add r10.z, |r2.w|, r10.z
  div r10.z, l(1.000000, 1.000000, 1.000000, 1.000000), r10.z
  mul r11.xyz, |r2.xywx|, r10.zzzz
  mul r12.xyz, r5.xyzx, cb0[233].xxxx
  sample_l_indexable(texture3d)(float,float,float,float) r10.z, r12.xyzx, t10.yzxw, s2, l(0.000000)
  mul r12.xyzw, r11.xxyy, l(0.000000, 1.000000, 0.707106, 0.000000)
  add r11.xyw, r12.zwzz, r12.xxxy
  mad r11.xyz, r11.zzzz, l(1.000000, 0.000000, 0.000000, 0.000000), r11.xywx
  mad r11.w, r10.z, l(2.000000), l(-1.000000)
  mul r11.xyz, r11.wwww, r11.xyzx
  mov r11.w, |r2.y|
  add r11.w, r11.w, l(-0.700000)
  mul_sat r11.w, r11.w, l(4.000000)
  mad r12.x, r11.w, l(-2.000000), l(3.000000)
  mul r11.w, r11.w, r11.w
  mul r11.w, r11.w, r12.x
  add r12.x, -cb0[233].z, cb0[233].y
  mad r11.w, r11.w, r12.x, cb0[233].z
  mul r11.xyz, r11.wwww, r11.xyzx
else
  mov r11.xyz, l(0,0,0,0)
  mov r10.z, l(0)
endif
mad r11.w, -r3.y, r1.w, l(-0.200000)
if_nz r10.w
  mul r12.xyz, r2.xywx, cb0[237].zzzz
  mul r13.xyz, l(0.000000, 1.000000, 0.000000, 0.000000), cb0[229].yyyy
  mad r12.xyz, r12.xyzx, cb0[229].xxxx, r13.xyzx
  max r10.w, -r2.y, l(0.000000)
  min r10.w, r10.w, l(0.900000)
  add r10.w, -r10.w, l(1.000000)
  mul_sat r12.w, r11.w, l(-10.000000)
  mad r13.x, r12.w, l(-2.000000), l(3.000000)
  mul r12.w, r12.w, r12.w
  mul r12.w, r12.w, r13.x
  max r12.w, r12.w, l(0.100000)
  min r12.w, r12.w, l(1.000000)
  mul r10.w, r10.w, r12.w
  mad r12.xyz, r12.xyzx, r10.wwww, r5.xyzx
  add r11.xyz, r11.xyzx, r12.xyzx
  mul r12.xyz, r11.yyyy, cb5[1].xyzx
  mad r12.xyz, cb5[0].xyzx, r11.xxxx, r12.xyzx
  mad r11.xyz, cb5[2].xyzx, r11.zzzz, r12.xyzx
  add r11.xyz, r11.xyzx, cb5[3].xyzx
  mad r12.x, r11.x, l(0.500000), cb5[4].x
  mad r10.w, r11.y, l(0.500000), l(0.500000)
  add r12.z, -r10.w, cb5[4].y
  add r11.xy, r12.xzxx, l(0.500000, 1.000000, 0.000000, 0.000000)
  max r10.w, r11.z, l(0.000488)
  sample_c_lz_indexable(texture2d)(float,float,float,float) r10.w, r11.xyxx, t9.xxxx, s5, r10.w
else
  mov r10.w, l(1.000000)
endif
mov_sat r11.x, r2.y
add r11.y, l(1.000000), -cb0[234].w
mad r11.y, r11.x, r11.y, cb0[234].w
add r12.xy, r5.xzxx, -cb0[44].xzxx
max r11.z, |r12.y|, |r12.x|
mul r12.x, r10.w, r11.y
mul r12.y, l(0.050000), cb0[226].w
mad r12.z, -cb0[226].w, l(0.700000), r11.z
div r12.y, l(1.000000, 1.000000, 1.000000, 1.000000), r12.y
mul_sat r12.y, r12.y, r12.z
mad r12.z, r12.y, l(-2.000000), l(3.000000)
mul r12.y, r12.y, r12.y
mul r12.y, r12.y, r12.z
mad r10.w, -r11.y, r10.w, l(1.000000)
mad r10.w, r12.y, r10.w, r12.x
deriv_rty_fine r12.xyz, r5.zxyz
deriv_rtx_fine r13.xyz, r5.yzxy
mul r14.xyz, r12.xyzx, r13.xyzx
mad r12.xyz, r12.zxyz, r13.yzxy, -r14.xyzx
dp3 r12.x, r12.xyzx, r12.xyzx
max r12.x, r12.x, l(0.000000)
rsq r12.x, r12.x
mul_sat r12.x, r12.x, r12.y
mad r12.yz, cb0[227].zzzz, l(0.000000, 0.300000, 0.300000, 0.000000), l(0.000000, 0.686000, 0.687000, 0.000000)
add r12.w, |r3.w|, l(-15.000000)
mul_sat r12.w, r12.w, l(0.015000)
add r12.w, -r12.w, l(1.000000)
min r13.x, l(0.990000), cb0[232].w
max r12.y, r12.y, l(0.970000)
add r13.y, -r12.y, l(0.990000)
add r11.x, r11.x, -r12.y
div r12.y, l(1.000000, 1.000000, 1.000000, 1.000000), r13.y
mul_sat r11.x, r11.x, r12.y
mad r12.y, r11.x, l(-2.000000), l(3.000000)
mul r11.x, r11.x, r11.x
add r13.y, r12.x, l(-0.991000)
mul r13.y, r13.y, l(111.111069)
max r13.y, r13.y, l(0.000000)
mad r13.z, r13.y, l(-2.000000), l(3.000000)
mul r13.y, r13.y, r13.y
mul r13.y, r13.y, r13.z
mad r13.z, r10.z, l(0.200000), l(0.800000)
ge r13.z, r13.z, r1.y
and r13.z, r13.z, l(0x3f800000)
mul r13.y, r13.z, r13.y
mad r11.x, r12.y, r11.x, r13.y
min r11.x, r11.x, l(1.000000)
add r12.y, -r13.x, cb0[232].w
add r11.x, -r13.x, r11.x
div r12.y, l(1.000000, 1.000000, 1.000000, 1.000000), r12.y
mul_sat r11.x, r11.x, r12.y
mad r12.y, r11.x, l(-2.000000), l(3.000000)
mul r11.x, r11.x, r11.x
mul r11.x, r11.x, r12.y
lt r12.y, l(0.000488), cb0[227].y
add r12.x, -r12.z, r12.x
mul_sat r12.x, r12.x, l(-1000.012878)
mad r12.z, r12.x, l(-2.000000), l(3.000000)
mul r12.x, r12.x, r12.x
mul r12.x, r12.x, r12.z
mad r12.z, r3.y, r1.w, l(0.500000)
mul_sat r12.z, r12.z, l(2.500000)
mad r13.x, r12.z, l(-2.000000), l(3.000000)
mul r12.z, r12.z, r12.z
mul r12.z, r12.z, r13.x
mul r12.x, r12.z, r12.x
lt r12.x, l(0.000488), r12.x
and r12.x, r12.x, r12.y
if_nz r12.x
  mul r12.xy, |r2.xwxx|, |r2.xwxx|
  add r12.z, r12.y, r12.x
  div r12.z, l(1.000000, 1.000000, 1.000000, 1.000000), r12.z
  mul r12.xy, r12.zzzz, r12.xyxx
  mul r13.xyz, r2.ywxy, l(0.000000, 1.000000, 0.000000, 0.000000)
  mad r13.xyz, r2.xywx, l(1.000000, 0.000000, 0.000000, 0.000000), -r13.xyzx
  dp2 r12.z, r13.xyxx, r13.xyxx
  rsq r12.z, r12.z
  mul r13.xyz, r12.zzzz, r13.xyzx
  mul r14.xyz, r2.ywxy, r13.xyzx
  mad r14.xyz, r13.zxyz, r2.wxyw, -r14.xyzx
  dp3 r12.z, r14.xyzx, r14.xyzx
  rsq r12.z, r12.z
  mul r14.xyz, r12.zzzz, r14.xzyx
  mad r15.xyz, r5.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.314159, 0.314159, 0.314159, 0.000000)
  round_ni r15.xyz, r15.xyzx
  add r15.xyz, r15.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000)
  add r13.zw, r15.yyyy, r15.xxxz
  mul r13.zw, r13.zzzw, l(0.000000, 0.000000, 0.000977, 0.000977)
  ge r15.xy, r13.zwzz, -r13.zwzz
  frc r13.zw, |r13.zzzw|
  movc r13.zw, r15.xxxy, r13.zzzw, -r13.zzzw
  mul r13.zw, r13.zzzw, l(0.000000, 0.000000, 1024.000000, 1024.000000)
  dp2 r12.z, r13.zwzz, l(12.989800, 78.233002, 0.000000, 0.000000)
  sincos r12.z, null, r12.z
  mul r12.z, r12.z, l(43758.546875)
  frc r12.z, r12.z
  ge r13.zw, r2.wwwx, l(0.000000, 0.000000, 0.000000, 0.000000)
  movc r13.zw, r13.zzzw, l(0,0,1.000000,-1.000000), l(0,0,-1.000000,1.000000)
  mul r15.xy, r5.xzxx, r13.zwzz
  mul r13.z, r10.z, r12.z
  add r13.w, -r12.z, l(1.000000)
  mad r13.w, r13.w, l(0.700000), l(0.300000)
  mul r16.xy, r13.zzzz, l(3.000000, 6.000000, 0.000000, 0.000000)
  mad r13.z, -cb0[227].x, r13.w, r16.x
  frc r17.x, r13.z
  mad r13.z, cb0[227].x, l(-0.300000), r16.y
  frc r17.y, r13.z
  mul r12.z, r12.z, l(5.000000)
  round_ni r12.z, r12.z
  add r16.x, r12.z, l(1.000000)
  mul r16.y, r5.y, r16.x
  mov r5.w, l(0.100000)
  mul r13.zw, r5.yyyw, r16.xxxy
  frc r13.zw, r13.zzzw
  add r16.xy, r17.xyxx, l(-1.000000, -1.000000, 0.000000, 0.000000)
  add r16.xy, r13.zwzz, -r16.xyxx
  add r16.xy, r16.xyxx, l(-0.800000, -0.800000, 0.000000, 0.000000)
  mul_sat r16.xy, r16.xyxx, l(5.000000, 5.000000, 0.000000, 0.000000)
  mad r16.zw, r16.xxxy, l(0.000000, 0.000000, -2.000000, -2.000000), l(0.000000, 0.000000, 3.000000, 3.000000)
  mul r16.xy, r16.xyxx, r16.xyxx
  mul r16.xy, r16.xyxx, r16.zwzz
  add r16.zw, -r13.zzzw, r17.xxxy
  max r16.xy, r16.zwzz, r16.xyxx
  add r17.zw, -r17.xxxy, r13.zzzw
  add r17.zw, r17.zzzw, l(0.000000, 0.000000, -0.800000, -0.800000)
  mul r17.zw, r17.zzzw, l(0.000000, 0.000000, 5.000000, 5.000000)
  max r17.zw, r17.zzzw, l(0.000000, 0.000000, 0.000000, 0.000000)
  mad r18.xy, r17.zwzz, l(-2.000000, -2.000000, 0.000000, 0.000000), l(3.000000, 3.000000, 0.000000, 0.000000)
  mul r17.zw, r17.zzzw, r17.zzzw
  mul r17.zw, r17.zzzw, r18.xxxy
  add r16.zw, r16.zzzw, l(0.000000, 0.000000, 1.000000, 1.000000)
  max r16.zw, r16.zzzw, r17.zzzw
  ge r13.zw, r13.zzzw, r17.xxxy
  and r13.zw, r13.zzzw, l(0, 0, 0x3f800000, 0x3f800000)
  add r16.zw, -r16.xxxy, r16.zzzw
  mad r13.zw, r13.zzzw, r16.zzzw, r16.xxxy
  mad r12.z, r13.z, r13.z, l(-0.400000)
  mul_sat r12.z, r12.z, l(1.666667)
  mad r13.z, r12.z, l(-2.000000), l(3.000000)
  mul r12.z, r12.z, r12.z
  mul r12.z, r12.z, r13.z
  mad r13.z, r13.w, l(2.000000), l(-1.000000)
  mul r15.w, r12.z, l(0.010000)
  mul r16.x, r13.z, r15.w
  mad r16.x, r10.z, l(0.100000), r16.x
  mul r15.w, r12.z, r15.w
  mad r15.w, r15.w, r13.z, r10.z
  mul r16.y, r10.z, r15.w
  mov r15.z, r5.y
  mad r15.xyzw, r15.yzxz, cb0[228].xyxy, r16.xyxy
  sample_b_indexable(texture2d)(float,float,float,float) r16.xyzw, r15.xyxx, t11.xyzw, s2, cb0[108].x
  sample_b_indexable(texture2d)(float,float,float,float) r15.xyzw, r15.zwzz, t11.xyzw, s2, cb0[108].x
  mul r15.xyzw, r12.yyyy, r15.xyzw
  mad r15.xyzw, r16.xyzw, r12.xxxx, r15.xyzw
  mad r12.xy, r15.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), l(-1.000000, -1.000000, 0.000000, 0.000000)
  mad r15.x, r12.z, l(2.000000), l(-1.000000)
  mad_sat r13.w, r15.x, l(0.800000), r13.w
  mad r15.x, -r15.w, l(0.500000), l(1.000000)
  mad r13.w, r13.w, r15.x, l(-0.700000)
  mul_sat r13.w, r13.w, l(3.333333)
  mad r15.x, r13.w, l(-2.000000), l(3.000000)
  mul r13.w, r13.w, r13.w
  mul r13.w, r13.w, r15.x
  mul r13.z, r13.z, r15.w
  mad_sat r12.z, r13.z, l(0.500000), r12.z
  mad r12.z, r12.z, l(0.500000), l(0.100000)
  max r12.z, r12.z, r13.w
  add r13.z, -r12.z, l(1.000000)
  max r13.z, r13.z, l(0.000000)
  mul r13.w, r13.z, r13.z
  mul r13.w, r13.w, r13.w
  mul r13.z, r13.w, r13.z
  ge r13.z, r15.z, r13.z
  and r13.z, r13.z, l(0x3f800000)
  mad r12.z, r12.z, l(0.700000), l(0.200000)
  mad r12.z, r13.z, r12.z, l(0.100000)
  mul r12.z, r15.z, r12.z
  mul r12.z, r12.z, cb0[227].y
  mul r12.z, r12.z, l(0.330000)
  ge r13.z, r1.z, l(0.045000)
  and r13.z, r13.z, l(0x3f800000)
  mul r13.z, r10.w, r13.z
  mul r13.z, r13.z, cb0[226].x
  mul r13.z, r12.w, r13.z
  mul r12.z, r12.z, r13.z
  dp2 r13.z, r12.xyxx, r12.xyxx
  min r13.z, r13.z, l(1.000000)
  add r13.z, -r13.z, l(1.000000)
  sqrt r13.z, r13.z
  max r13.z, r13.z, l(0.000488)
  mul_sat r13.w, r12.z, l(10.000000)
  mad r15.x, r13.w, l(-2.000000), l(3.000000)
  mul r13.w, r13.w, r13.w
  mul r13.w, r13.w, r15.x
  mul r13.w, r13.w, cb0[227].y
  mul r15.xy, r12.xyxx, r13.wwww
  add r12.x, l(-1.500000), cb0[227].y
  mul_sat r12.x, r12.x, l(0.666667)
  mad r12.y, r12.x, l(-2.000000), l(3.000000)
  mul r12.x, r12.x, r12.x
  mul r12.x, r12.x, r12.y
  mul r12.y, r12.x, l(-0.200000)
  mad r12.x, -r12.x, l(-0.200000), r13.z
  mad r15.z, r12.z, r12.x, r12.y
  dp3 r12.x, r15.xyzx, r15.xyzx
  max r12.x, r12.x, l(0.000000)
  rsq r12.x, r12.x
  mul r15.xyz, r12.xxxx, r15.xyzx
  mov r16.x, r13.y
  mov r16.y, r14.x
  mov r16.z, r2.x
  dp3 r16.x, r16.xyzx, r15.xyzx
  mov r14.w, r2.y
  dp2 r16.y, r14.zwzz, r15.yzyy
  mov r14.x, r13.x
  mov r14.z, r2.w
  dp3 r16.z, r14.xyzx, r15.xyzx
  mad r3.xyz, -r3.xyzx, r1.wwww, r16.xyzx
  mad r13.xyz, r12.zzzz, r3.xyzx, r2.xywx
  mul r1.w, r12.z, cb0[227].y
  mul r1.w, r1.w, l(0.330000)
else
  mov r13.xyz, r2.xywx
  mov r1.w, l(0)
endif
lt r3.x, l(0.000488), r11.x
if_nz r3.x
  mul r3.xy, -r5.xzxx, cb0[232].xyxx
  frc r12.xy, r3.xyxx
  lt r14.xy, l(0.000488, 0.000488, 0.000000, 0.000000), cb0[231].ywyy
  if_nz r14.x
    round_ni r3.xy, r3.xyxx
    mul r3.xy, r3.xyxx, l(0.000977, 0.000977, 0.000000, 0.000000)
    ge r14.xz, r3.xxyx, -r3.xxyx
    frc r3.xy, |r3.xyxx|
    movc r3.xy, r14.xzxx, r3.xyxx, -r3.xyxx
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
    add r14.xz, -r12.xxyx, r12.yyxy
    mad r12.xy, r3.xxxx, r14.xzxx, r12.xyxx
    div r3.x, r3.y, cb0[232].z
    ge r12.z, r3.x, -r3.x
    frc r3.x, |r3.x|
    movc r3.x, r12.z, r3.x, -r3.x
    mul r3.x, r3.x, cb0[232].z
    mul r15.x, r3.x, r3.z
    add r3.x, l(-1.000000), cb0[232].z
    mul r3.y, r3.z, r3.y
    round_ni r3.y, r3.y
    add r3.x, -r3.y, r3.x
    mul r15.y, r3.x, r3.z
    mad r3.xy, r12.xyxx, r3.zzzz, r15.xyxx
    frc r3.xy, r3.xyxx
    sample_b_indexable(texture2d)(float,float,float,float) r3.xy, r3.xyxx, t12.xyzw, s1, cb0[108].x
    mul r3.xy, r3.xyxx, cb0[231].yyyy
    mad r3.xy, r3.xyxx, l(2.000000, 2.000000, 0.000000, 0.000000), -cb0[231].yyyy
  else
    mov r3.xy, l(0,0,0,0)
  endif
  if_nz r14.y
    mov r14.xw, l(0,0,0,0.500000)
    mov r14.y, cb0[231].z
    mad r12.xy, -r5.xzxx, cb0[232].xyxx, r14.xyxx
    mul r14.z, r10.z, l(0.500000)
    add r12.xy, r12.xyxx, r14.zwzz
    add r12.xy, r12.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
    sample_b_indexable(texture2d)(float,float,float,float) r14.xy, r12.xyxx, t12.zwxy, s2, cb0[108].x
    mov r12.xz, cb0[231].zzwz
    mov r12.y, l(0)
    mad r12.xy, -r5.xzxx, cb0[232].xyxx, -r12.xyxx
    add r15.y, -r10.z, l(1.000000)
    mov r15.x, l(0.500000)
    mad r15.xy, l(1.000000, 0.500000, 0.000000, 0.000000), r15.xyxx, l(-0.500000, -0.500000, 0.000000, 0.000000)
    add r12.xy, r12.xyxx, -r15.xyxx
    sample_b_indexable(texture2d)(float,float,float,float) r14.zw, r12.xyxx, t12.xyzw, s2, cb0[108].x
    mul r14.xyzw, r14.xyzw, cb0[231].wwww
    mad r14.xyzw, r14.xyzw, l(2.000000, 2.000000, 2.000000, 2.000000), -r12.zzzz
    mul r14.xyzw, r10.zzzz, r14.xyzw
    add r12.xy, r14.zwzz, r14.xyxx
    add r3.xy, r3.xyxx, r12.xyxx
  endif
  mul r12.x, r2.z, l(0.300000)
  mad r12.x, r10.z, l(0.700000), r12.x
  add r12.y, r2.z, l(-0.100000)
  mul_sat r12.y, r12.y, l(100.000000)
  mul r12.x, r12.y, r12.x
  mul r12.y, r1.y, r12.x
  min r12.y, r12.y, l(0.990000)
  mad_sat r12.x, r12.x, r1.y, l(0.600000)
  add r12.x, -r12.y, r12.x
  add r12.y, -r12.y, cb0[232].w
  div r12.x, l(1.000000, 1.000000, 1.000000, 1.000000), r12.x
  mul_sat r12.x, r12.x, r12.y
  mad r12.y, r12.x, l(-2.000000), l(3.000000)
  mul r12.x, r12.x, r12.x
  mul r12.x, r12.x, r12.y
  mul r11.x, r11.x, cb0[226].x
  dp2 r12.y, r3.xyxx, r3.xyxx
  min r12.y, r12.y, l(1.000000)
  add r12.y, -r12.y, l(1.000000)
  sqrt r12.y, r12.y
  max r3.z, r12.y, l(0.000488)
  dp3 r12.y, r3.xyzx, r3.xyzx
  rsq r12.y, r12.y
  mul r3.xyz, r3.yzxy, r12.yyyy
  mul r12.y, r3.y, l(1.000000)
  mul r12.z, r12.x, r11.x
  mul r12.z, r10.w, r12.z
  mul r12.z, r12.w, r12.z
  mad r3.xyz, r3.xyzx, l(1.000000, 1.000000, -1.000000, 0.000000), -r2.xywx
  mad r13.xyz, r12.zzzz, r3.xyzx, r2.xywx
  mul r3.x, r1.y, l(0.200000)
  add r3.y, -r10.z, l(1.000000)
  mul r3.y, r3.y, cb0[232].w
  mul r3.z, r3.y, l(0.500000)
  mad r3.y, -r3.y, l(0.500000), l(1.000000)
  mad r3.y, r12.x, r3.y, r3.z
  add r3.z, l(-0.600000), cb0[232].w
  mul_sat r3.z, r3.z, l(2.500000)
  mad r10.z, r3.z, l(-2.000000), l(3.000000)
  mul r3.z, r3.z, r3.z
  mul r3.z, r3.z, r10.z
  mad_sat r3.y, r3.z, l(0.600000), r3.y
  mul r3.y, r3.y, r11.x
  mul r3.y, r12.y, r3.y
  div r3.x, l(1.000000, 1.000000, 1.000000, 1.000000), r3.x
  mul_sat r3.x, r3.x, r3.y
  mad r3.y, r3.x, l(-2.000000), l(3.000000)
  mul r3.x, r3.x, r3.x
  mul r3.x, r3.x, r3.y
  mul r3.x, r10.w, r3.x
  mul r3.x, r12.w, r3.x
  max r3.x, r3.x, l(0.000000)
else
  mov r3.x, l(0)
endif
min r3.y, r10.y, r10.x
mul r3.z, r11.y, cb0[234].z
mad r10.z, -cb0[234].z, r11.y, l(1.000000)
mad r3.z, r10.w, r10.z, r3.z
mad r10.z, cb0[234].x, cb0[226].w, -cb0[226].w
add r10.w, r11.z, -cb0[226].w
div r10.z, l(1.000000, 1.000000, 1.000000, 1.000000), r10.z
mul_sat r10.z, r10.z, r10.w
mad r10.w, r10.z, l(-2.000000), l(3.000000)
mul r10.z, r10.z, r10.z
mul r10.z, r10.z, r10.w
add r10.w, -r3.z, cb0[234].y
mad r3.z, r10.z, r10.w, r3.z
add r3.z, -r3.z, l(1.000000)
mul r10.z, r3.z, r10.x
add r1.z, r1.z, l(-0.050000)
add r10.w, -r2.z, l(1.000000)
mad_sat r11.x, r10.w, cb0[226].z, cb0[226].y
mad r11.x, r1.w, cb0[228].z, r11.x
mul r11.y, r2.z, r3.x
mad_sat r11.x, r11.y, l(0.100000), r11.x
add r11.y, -r11.x, l(1.000000)
mad r11.x, r1.x, r11.y, r11.x
mul_sat r11.y, r11.w, l(3.333333)
mad r11.z, r11.y, l(-2.000000), l(3.000000)
mul r11.y, r11.y, r11.y
mad r11.y, -r11.z, r11.y, l(1.000000)
mul r11.z, r11.x, cb0[226].x
add r11.w, -r1.x, l(1.000000)
mul r11.z, r11.w, r11.z
mul r11.z, r11.y, r11.z
mad r11.z, r11.z, l(-0.750000), l(1.000000)
mad r11.x, r11.x, l(-0.300000), l(0.900000)
sqrt r11.w, r10.w
add r11.x, r11.w, r11.x
add_sat r11.x, r11.x, l(-0.600000)
max r11.x, r10.w, r11.x
min r11.x, r11.x, l(0.990000)
add_sat r11.w, l(2.000000), -cb0[226].x
mul r11.w, r11.w, cb0[226].x
mul r11.y, r11.y, r11.w
mad r3.z, -r10.x, r3.z, l(1.000000)
mul r3.z, r3.z, r11.y
add r10.x, -r10.w, r11.x
mad r3.z, r3.z, r10.x, r10.w
add r3.z, -r3.z, l(1.000000)
mul_sat r1.zw, r1.zzzw, l(0.000000, 0.000000, 1.052600, 20.000000)
mad r10.x, r1.w, l(-2.000000), l(3.000000)
mul r1.w, r1.w, r1.w
mul r1.w, r1.w, r10.x
max r1.w, r1.w, r3.x
mad r1.w, r1.w, l(-0.900000), l(1.000000)
mul r3.x, r1.w, r3.z
add r10.x, r10.y, l(-1.000000)
mad r10.x, r1.z, r10.x, l(1.000000)
add r10.y, -r1.z, l(1.000000)
movc r10.xy, r9.wwww, r10.xyxx, l(1.000000,1.000000,0,0)
min r1.z, r3.x, r10.x
mad r1.w, r3.z, r1.w, -r1.z
mad r1.z, r3.y, r1.w, r1.z
add r1.w, -r1.z, r2.z
mad r12.w, r10.z, r1.w, r1.z
ld_indexable(texture2d)(float,float,float,float) r11.xyw, r0.xyzz, t28.xywz
min r1.z, r11.z, r10.y
add r1.w, -r1.z, r11.z
mad r1.z, r3.y, r1.w, r1.z
add r1.w, -r1.z, l(1.000000)
mad r1.z, r10.z, r1.w, r1.z
mul r3.xyz, r1.zzzz, r11.xywx
mul r10.xyz, r1.xxxx, r3.xyzx
mad r10.xyz, r11.xywx, r1.zzzz, -r10.xyzx
mad r1.z, -r1.x, l(0.040000), l(0.040000)
mad r1.xzw, r3.xxyz, r1.xxxx, r1.zzzz
dp3 r2.z, r13.xyzx, r9.xyzx
max r11.x, r2.z, l(0.000000)
mul r3.y, r12.w, r12.w
mul r14.x, r11.x, r11.x
mul r14.z, r11.x, r14.x
mul r2.z, r3.y, r3.y
mul r3.z, r3.y, r2.z
mov r11.yzw, l(0,0.036546,9.063200,0.990440)
dp2 r15.x, l(3.327070, 1.000000, 0.000000, 0.000000), r11.xyxx
dp2 r15.y, l(-9.047560, 1.000000, 0.000000, 0.000000), r11.xzxx
mov r3.x, l(1.000000)
dp2 r9.w, r15.xyxx, r3.xyxx
mov r14.yw, l(0,9.044010,0,1.000000)
dp3 r15.x, l(3.596850, -1.367720, 1.000000, 0.000000), r14.xzwx
dp3 r15.y, l(-16.317400, 1.000000, 9.229490, 0.000000), r14.xyzx
mov r16.x, l(5.565890)
mov r16.yz, r14.xxzx
dp3 r15.z, l(1.000000, 19.788601, -20.212299, 0.000000), r16.xyzx
dp3 r10.w, r15.xyzx, r3.xyzx
div r9.w, r9.w, r10.w
dp2 r15.x, l(-1.285140, 1.000000, 0.000000, 0.000000), r11.xwxx
mov r14.x, l(1.296780)
mov r14.y, r11.x
dp2 r15.y, l(1.000000, -0.755907, 0.000000, 0.000000), r14.xyxx
dp2 r10.w, r15.xyxx, r3.xyxx
dp3 r15.x, l(2.923380, 59.418800, 1.000000, 0.000000), r14.yzwy
mov r14.xw, l(20.322500,0,0,121.563004)
dp3 r15.y, l(1.000000, -27.030199, 222.591995, 0.000000), r14.xyzx
dp3 r15.z, l(626.130005, 316.627014, 1.000000, 0.000000), r14.yzwy
dp3 r3.x, r15.xyzx, r3.xyzx
div r3.x, r10.w, r3.x
mad r11.yzw, r1.xxzw, r9.wwww, r3.xxxx
add r3.x, r3.x, r9.w
ld_indexable(texture2d)(float,float,float,float) r14.x, r0.xyzz, t7.xyzw
lt r0.z, l(0.001000), r14.x
if_nz r0.z
  dp3 r0.z, -r9.xyzx, r13.xyzx
  add r0.z, r0.z, r0.z
  mad r15.xyz, r13.xyzx, -r0.zzzz, -r9.xyzx
  dp3 r0.z, -cb3[0].xyzx, r15.xyzx
  mad r16.xyz, cb3[0].xyzx, r0.zzzz, r15.xyzx
  lt r0.z, r0.z, cb3[4].z
  dp3 r3.z, r16.xyzx, r16.xyzx
  max r3.z, r3.z, l(0.000061)
  rsq r3.z, r3.z
  mul r16.xyz, r3.zzzz, r16.xyzx
  mul r16.xyz, r16.xyzx, cb3[4].yyyy
  mad r16.xyz, -cb3[0].xyzx, cb3[4].zzzz, r16.xyzx
  dp3 r3.z, r16.xyzx, r16.xyzx
  rsq r3.z, r3.z
  mul r16.xyz, r3.zzzz, r16.xyzx
  movc r15.xyz, r0.zzzz, r16.xyzx, r15.xyzx
  mad r16.xyz, r8.xyzx, r7.wwww, r15.xyzx
  dp3 r0.z, r16.xyzx, r16.xyzx
  max r0.z, r0.z, l(0.000061)
  rsq r0.z, r0.z
  mul r16.xyz, r0.zzzz, r16.xyzx
  dp3_sat r12.y, r15.xyzx, r13.xyzx
  dp3_sat r0.z, r13.xyzx, r16.xyzx
  min r12.z, r11.x, l(1.000000)
  mad r3.z, r0.z, r2.z, -r0.z
  mad r0.z, r3.z, r0.z, l(1.000000)
  dp3_sat r3.z, r9.xyzx, r16.xyzx
  add r3.z, -r3.z, l(1.000000)
  mul r9.w, r3.z, r3.z
  mul r9.w, r9.w, r9.w
  mul r10.w, r3.z, r9.w
  add r14.z, -r12.w, l(1.000000)
  mad r14.w, -r14.z, l(0.383026), l(-0.076195)
  mad r14.w, r14.z, r14.w, l(1.049970)
  mad r14.z, r14.z, r14.w, l(0.409255)
  min r14.z, r14.z, l(0.999000)
  add r14.w, -r14.z, l(1.000000)
  add r16.xyz, -r1.xzwx, l(1.000000, 1.000000, 1.000000, 0.000000)
  mad r16.xyz, r16.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r1.xzwx
  mad r3.z, -r9.w, r3.z, l(1.000000)
  mad r17.xyz, r1.xzwx, r3.zzzz, r10.wwww
  mul r0.z, r0.z, r0.z
  div r0.z, r2.z, r0.z
  mad r18.xy, -r12.zyzz, r2.zzzz, r12.zyzz
  mad r18.xy, r18.xyxx, r12.zyzz, r2.zzzz
  sqrt r18.xy, r18.xyxx
  mul r18.xy, r12.yzyy, r18.xyxx
  add r2.z, r18.y, r18.x
  add r2.z, r2.z, l(0.000100)
  div r2.z, l(0.500000), r2.z
  mul r0.z, r0.z, r2.z
  mul r17.xyz, r0.zzzz, r17.xyzx
  min r17.xyz, r17.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
  mad r18.xyzw, r12.zwyw, l(0.968750, 0.968750, 0.968750, 0.968750), l(0.015625, 0.015625, 0.015625, 0.015625)
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r18.xyxx, t13.yzxw, s1, l(0.000000)
  sample_l_indexable(texture2d)(float,float,float,float) r2.z, r18.zwzz, t13.yzxw, s1, l(0.000000)
  mul r0.z, r0.z, r2.z
  mul r0.z, r14.z, r0.z
  div r0.z, r0.z, r14.w
  mul r18.xyz, r16.xyzx, r16.xyzx
  mul r18.xyz, r0.zzzz, r18.xyzx
  mad r16.xyz, -r16.xyzx, r14.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
  div r16.xyz, r18.xyzx, r16.xyzx
  add r16.xyz, r16.xyzx, r17.xyzx
  mul r16.xyz, r16.xyzx, cb3[4].xxxx
  max r16.xyz, r16.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  min r16.xyz, r16.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
  dp3_sat r0.z, r15.xyzx, r2.xywx
  mul r15.xyz, r0.zzzz, r10.xyzx
  mad r15.xyz, r16.xyzx, r12.yyyy, r15.xyzx
  mul r15.xyz, r15.xyzx, cb3[1].xyzx
  mov r14.y, l(0.500000)
  sample_b_indexable(texture2d)(float,float,float,float) r14.yzw, r14.xyxx, t8.wxyz, s1, cb0[108].x
  add r0.z, -r14.x, l(1.000000)
  mad r14.xyz, r15.xyzx, r14.yzwy, -r15.xyzx
  mad r14.xyz, r0.zzzz, r14.xyzx, r15.xyzx
  sample_l_indexable(texture2d)(float,float,float,float) r0.z, r4.zwzz, t14.yzxw, s1, l(0.000000)
  min r0.z, r0.z, l(1.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
else
  mov r14.xyz, l(0,0,0,0)
endif
mul r12.yz, r4.xxyx, l(0.000000, 0.031250, 0.031250, 0.000000)
round_ni r12.yz, r12.yyzy
mad r0.z, r12.z, cb2[1].y, r12.y
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
dp3 r9.w, -r9.xyzx, r13.xyzx
add r9.w, r9.w, r9.w
mad r15.xyz, r13.xyzx, -r9.wwww, -r9.xyzx
min r12.x, r11.x, l(1.000000)
add r9.w, -r12.w, l(1.000000)
mad r10.w, -r9.w, l(0.383026), l(-0.076195)
mad r10.w, r9.w, r10.w, l(1.049970)
mad r9.w, r9.w, r10.w, l(0.409255)
min r9.w, r9.w, l(0.999000)
add r10.w, -r9.w, l(1.000000)
add r16.xyz, -r1.xzwx, l(1.000000, 1.000000, 1.000000, 0.000000)
mad r16.xyz, r16.xyzx, l(0.047619, 0.047619, 0.047619, 0.000000), r1.xzwx
mad r12.yz, r12.xxwx, l(0.000000, 0.968750, 0.968750, 0.000000), l(0.000000, 0.015625, 0.015625, 0.000000)
sample_l_indexable(texture2d)(float,float,float,float) r11.x, r12.yzyy, t13.xyzw, s1, l(0.000000)
mad r17.xyz, -r16.xyzx, r10.wwww, l(1.000000, 1.000000, 1.000000, 0.000000)
mul r16.xyz, r16.xyzx, r16.xyzx
mov r18.w, l(1.000000)
mov r19.y, l(1.000000)
mov r20.z, r12.w
mov r21.xyz, l(0,0,0,0)
mov r12.yz, l(0,1.000000,0,0)
loop
  ilt r14.w, l(7), r12.z
  breakc_nz r14.w
  iadd r14.w, r0.z, r12.z
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r14.w, r14.w, l(0), t0.xxxx
  iadd r15.w, r3.z, r12.z
  ld_structured_indexable(structured_buffer, stride=4)(mixed,mixed,mixed,mixed) r15.w, r15.w, l(0), t0.xxxx
  and r14.w, r14.w, r15.w
  and r14.w, r2.z, r14.w
  ishl r15.w, r12.z, l(5)
  mov r22.xyz, l(0,0,0,0)
  mov r16.w, r12.y
  mov r17.w, r14.w
  loop
    breakc_z r17.w
    firstbit_lo r19.z, r17.w
    ishl r19.w, l(1), r19.z
    xor r19.w, r17.w, r19.w
    iadd r19.z, r15.w, r19.z
    bfi r23.xyzw, l(29, 29, 29, 29), l(3, 3, 3, 3), r19.zzzz, l(1, 3, 5, 6)
    bfi r20.w, l(29), l(3), r19.z, l(7)
    ftou r21.w, cb3[r23.z + 6].w
    ieq r21.w, r21.w, l(1)
    if_nz r21.w
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
      dp4 r21.w, r18.xyzw, r28.xyzw
      mov r26.x, r24.y
      mov r26.z, r25.y
      mov r26.w, r27.x
      dp4 r22.w, r18.xyzw, r26.xyzw
      mov r27.xz, r25.xxzx
      dp4 r18.x, r18.xyzw, r27.xyzw
      max r18.y, |r21.w|, |r22.w|
      max r18.x, |r18.x|, r18.y
      mad r18.y, cb3[r20.w + 6].x, l(0.500000), l(0.500000)
      add r18.x, -r18.y, r18.x
      mad r18.y, -cb3[r20.w + 6].x, l(0.500000), l(0.500000)
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
      mov r17.w, r19.w
      continue
    endif
    ishl r18.z, r19.z, l(3)
    bfi r19.z, l(29), l(3), r19.z, l(2)
    lt r21.w, cb3[r18.z + 6].w, l(1.500000)
    if_nz r21.w
      mad r21.w, cb3[r19.z + 6].y, l(0.500000), l(0.500000)
      add r24.x, r21.w, -|cb3[r19.z + 6].x|
      add r24.y, -r24.x, cb3[r19.z + 6].y
      add r21.w, -|r24.x|, l(1.000000)
      add r21.w, -|r24.y|, r21.w
      ge r22.w, cb3[r19.z + 6].x, l(0.000000)
      max r23.z, r21.w, l(0.000488)
      movc r24.z, r22.w, r23.z, -r23.z
      dp3 r23.z, r24.xyzx, r24.xyzx
      rsq r23.z, r23.z
      mul r25.xyz, r23.zzzz, r24.xyzx
      add r26.xyz, -r5.xyzx, cb3[r23.x + 6].xyzx
      dp3 r23.z, r26.xyzx, r26.xyzx
      rsq r24.z, r23.z
      mul r27.xyz, r24.zzzz, r26.xyzx
      dp3_sat r19.x, r13.xyzx, r27.xyzx
      ftoi r25.w, cb3[r20.w + 6].w
      mul r28.xyz, r25.xyzx, cb3[r19.z + 6].zzzz
      mad r29.xyz, -r28.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r26.xyzx
      mad r30.xyz, r28.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r26.xyzx
      ftou r26.w, cb3[r18.z + 6].w
      and r26.w, r26.w, l(1)
      ieq r27.w, r26.w, l(0)
      not r27.w, r27.w
      lt r28.w, l(0.000000), cb3[r19.z + 6].z
      and r27.w, r27.w, r28.w
      dp3 r28.w, r29.xyzx, r29.xyzx
      sqrt r28.w, r28.w
      dp3 r29.w, r30.xyzx, r30.xyzx
      sqrt r29.w, r29.w
      dp3 r30.w, r13.xyzx, r29.xyzx
      div r30.w, r30.w, r28.w
      dp3 r31.x, r13.xyzx, r30.xyzx
      div r31.x, r31.x, r29.w
      add r30.w, r30.w, r31.x
      mul_sat r31.x, r30.w, l(0.500000)
      dp3 r30.x, r29.xyzx, r30.xyzx
      mad r28.w, r28.w, r29.w, r30.x
      mad r28.w, r28.w, l(0.500000), l(1.000000)
      div r31.y, l(1.000000, 1.000000, 1.000000, 1.000000), r28.w
      movc r20.xy, r27.wwww, r31.xyxx, r19.xyxx
      lt r28.w, cb3[r23.w + 6].w, l(0.000000)
      if_nz r28.w
        mul r28.w, cb3[r23.x + 6].w, cb3[r23.x + 6].w
        mul r28.w, r23.z, r28.w
        mad r28.w, -r28.w, r28.w, l(1.000000)
        max r28.w, r28.w, l(0.000000)
        add r23.z, r23.z, l(1.000000)
        div r23.z, l(1.000000, 1.000000, 1.000000, 1.000000), r23.z
        and r29.w, r27.w, l(0x3f800000)
        add r30.x, r20.y, -r23.z
        mad r23.z, r29.w, r30.x, r23.z
        mul r28.w, r28.w, r28.w
        mul r23.z, r23.z, r28.w
      else
        mul r30.xyz, r26.xyzx, cb3[r23.x + 6].wwww
        dp3 r28.w, r30.xyzx, r30.xyzx
        min r28.w, r28.w, l(1.000000)
        add r28.w, -r28.w, l(1.000000)
        log r28.w, r28.w
        mul r28.w, r28.w, cb3[r23.w + 6].w
        exp r28.w, r28.w
        mul r23.z, r20.y, r28.w
      endif
      dp3 r20.y, r27.xyzx, -r25.xyzx
      add r20.y, r20.y, -cb3[r19.z + 6].z
      mul_sat r20.y, r20.y, cb3[r19.z + 6].w
      mul r20.y, r20.y, r20.y
      movc r20.y, r26.w, l(1.000000), r20.y
      mul r20.y, r20.y, r23.z
      not r23.z, r27.w
      ige r25.x, r25.w, l(0)
      and r23.z, r23.z, r25.x
      if_nz r23.z
        if_z r26.w
          ishl r23.z, r25.w, l(2)
          mul r25.xyz, r5.yyyy, cb6[r23.z + 33].xywx
          mad r25.xyz, cb6[r23.z + 32].xywx, r5.xxxx, r25.xyzx
          mad r25.xyz, cb6[r23.z + 34].xywx, r5.zzzz, r25.xyzx
          add r25.xyz, r25.xyzx, cb6[r23.z + 35].xywx
          div_sat r25.xy, r25.xyxx, r25.zzzz
          mad r25.xy, r25.xyxx, cb6[r25.w + 0].zwzz, cb6[r25.w + 0].xyxx
        else
          ishl r23.z, r25.w, l(2)
          dp3 r30.x, -r26.xyzx, cb6[r23.z + 32].xyzx
          dp3 r30.y, -r26.xyzx, cb6[r23.z + 33].xyzx
          dp3 r30.z, -r26.xyzx, cb6[r23.z + 34].xyzx
          lt r23.z, |r30.x|, |r30.y|
          and r23.z, r23.z, l(1)
          dp2 r25.z, |r30.xyxx|, icb[r23.z + 0].xyxx
          lt r25.z, r25.z, |r30.z|
          movc r23.z, r25.z, l(2), r23.z
          dp3 r25.z, r30.xyzx, icb[r23.z + 0].xyzx
          lt r25.z, r25.z, l(0.000000)
          bfi r23.z, l(31), l(1), r23.z, r25.z
          ushr r25.z, r23.z, l(1)
          dp3 r25.z, r30.xyzx, icb[r25.z + 0].xyzx
          div r28.w, l(0.000244), cb6[r25.w + 0].w
          add r28.w, -r28.w, l(0.500000)
          utof r29.w, r23.z
          ult r30.w, r23.z, l(2)
          and r30.w, r30.w, l(2)
          dp2 r30.x, r30.xzxx, icb[r30.w + 0].xzxx
          mul r30.x, r30.x, icb[r23.z + 4].z
          div r30.x, r30.x, |r25.z|
          mad r29.w, r30.x, r28.w, r29.w
          add r29.w, r29.w, l(0.500000)
          mul_sat r31.x, r29.w, l(0.166667)
          iadd r29.w, l(-1), icb[r23.z + 4].y
          dp2 r29.w, r30.yzyy, icb[r29.w + 0].xyxx
          mul r23.z, r29.w, icb[r23.z + 4].w
          div r23.z, r23.z, |r25.z|
          mad_sat r31.y, -r23.z, r28.w, l(0.500000)
          mad r25.xy, r31.xyxx, cb6[r25.w + 0].zwzz, cb6[r25.w + 0].xyxx
        endif
        sample_l_indexable(texture2d)(float,float,float,float) r23.z, r25.xyxx, t15.yzxw, s1, l(0.000000)
        mul r20.y, r20.y, r23.z
      endif
      lt r23.z, l(0.000000), r20.y
      if_nz r23.z
        if_z r26.w
          ftoi r25.x, cb3[r23.y + 6].x
        else
          add r25.yzw, r5.xxyz, -cb3[r23.x + 6].xxyz
          lt r30.xyz, |r25.zwwz|, |r25.yyzy|
          and r26.w, r30.y, r30.x
          lt r25.yzw, l(0.000000, 0.000000, 0.000000, 0.000000), r25.yyzw
          ushr r28.w, cb3[r19.z + 6].w, l(24)
          ubfe r30.xy, l(8, 8, 0, 0), l(16, 8, 0, 0), cb3[r19.z + 6].wwww
          movc r25.y, r25.y, r28.w, r30.x
          and r28.w, l(255), cb3[r19.z + 6].w
          movc r25.z, r25.z, r30.y, r28.w
          ubfe r28.w, l(8), l(8), cb3[r23.y + 6].x
          and r29.w, l(255), cb3[r23.y + 6].x
          movc r25.w, r25.w, r28.w, r29.w
          movc r25.z, r30.z, r25.z, r25.w
          movc r25.y, r26.w, r25.y, r25.z
          ilt r25.z, r25.y, l(80)
          movc r25.x, r25.z, r25.y, l(-1)
        endif
        ishl r25.y, r25.x, l(2)
        mad r30.xyz, r27.xyzx, cb4[r25.x + 288].xxxx, r5.xyzx
        mul r25.z, l(5.000000), cb4[r25.x + 288].y
        mad r30.xyz, r13.xyzx, r25.zzzz, r30.xyzx
        mul r31.xyzw, r30.yyyy, cb4[r25.y + 65].xyzw
        mad r31.xyzw, cb4[r25.y + 64].xyzw, r30.xxxx, r31.xyzw
        mad r30.xyzw, cb4[r25.y + 66].xyzw, r30.zzzz, r31.xyzw
        add r30.xyzw, r30.xyzw, cb4[r25.y + 67].xyzw
        div r25.yzw, r30.xxyz, r30.wwww
        ge r30.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r25.yzwy
        ge r31.xyz, r25.yzwy, l(1.000000, 1.000000, 1.000000, 0.000000)
        add r32.xy, -cb4[r25.x + 344].xyxx, cb4[r25.x + 344].zwzz
        mad r25.yz, r25.yyzy, r32.xxyx, cb4[r25.x + 344].xxyx
        mad r32.xy, r25.yzyy, cb4[400].zwzz, l(0.500000, 0.500000, 0.000000, 0.000000)
        round_ni r32.xy, r32.xyxx
        mad r25.yz, r25.yyzy, cb4[400].zzwz, -r32.xxyx
        add r33.xyzw, r25.yyzz, l(0.500000, 1.000000, 0.500000, 1.000000)
        mul r34.xyzw, r33.xxzz, r33.xxzz
        add r32.zw, -r25.yyyz, l(0.000000, 0.000000, 1.000000, 1.000000)
        min r33.xz, r25.yyzy, l(0.000000, 0.000000, 0.000000, 0.000000)
        max r35.xy, r25.yzyy, l(0.000000, 0.000000, 0.000000, 0.000000)
        mul r36.xy, r32.zwzz, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r35.xy, -r35.xyxx, r35.xyxx, r33.ywyy
        add r35.xy, r35.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
        mul r35.xy, r35.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r34.xz, r34.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
        mad r25.yz, r34.yywy, l(0.000000, 0.500000, 0.500000, 0.000000), -r25.yyzy
        mul r37.xy, r25.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
        mad r25.yz, -r33.xxzx, r33.xxzx, r32.zzwz
        add r25.yz, r25.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
        mul r38.xy, r25.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
        mul r25.yz, r33.yywy, l(0.000000, 0.160000, 0.160000, 0.000000)
        mov r37.z, r38.x
        mov r37.w, r25.y
        mov r36.z, r35.x
        mov r36.w, r34.x
        add r33.xyzw, r36.zwxz, r37.zwxz
        mov r38.z, r37.y
        mov r38.w, r25.z
        mov r35.z, r36.y
        mov r35.w, r34.z
        add r34.xyz, r35.zywz, r38.zywz
        div r36.xyz, r36.xzwx, r33.zwyz
        add r36.xyz, r36.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r36.xyz, r36.yxzy, cb4[400].xxxx
        div r35.xyz, r35.zywz, r34.xyzx
        add r35.xyz, r35.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
        mul r35.xyz, r35.xyzx, cb4[400].yyyy
        mov r36.w, r35.x
        mad r37.xyzw, r32.xyxy, cb4[400].xyxy, r36.ywxw
        mad r25.yz, r32.xxyx, cb4[400].xxyx, r36.zzwz
        mov r35.w, r36.y
        mov r36.yw, r35.yyyz
        mad r38.xyzw, r32.xyxy, cb4[400].xyxy, r36.xyzy
        mad r35.xyzw, r32.xyxy, cb4[400].xyxy, r35.wywz
        mad r32.xyzw, r32.xyxy, cb4[400].xyxy, r36.xwzw
        mul r36.xyzw, r33.zwyz, r34.xxxy
        sample_c_lz_indexable(texture2d)(float,float,float,float) r26.w, r37.xyxx, t6.xxxx, s4, r25.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r28.w, r37.zwzz, t6.xxxx, s4, r25.w
        mul r28.w, r28.w, r36.y
        mad r26.w, r36.x, r26.w, r28.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.y, r25.yzyy, t6.xxxx, s4, r25.w
        mad r25.y, r36.z, r25.y, r26.w
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.z, r35.xyxx, t6.xxxx, s4, r25.w
        mad r25.y, r36.w, r25.z, r25.y
        mul r36.xyzw, r33.xyzw, r34.yyzz
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.z, r38.xyxx, t6.xxxx, s4, r25.w
        mad r25.y, r36.x, r25.z, r25.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.z, r38.zwzz, t6.xxxx, s4, r25.w
        mad r25.y, r36.y, r25.z, r25.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.z, r35.zwzz, t6.xxxx, s4, r25.w
        mad r25.y, r36.z, r25.z, r25.y
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.z, r32.xyxx, t6.xxxx, s4, r25.w
        mad r25.y, r36.w, r25.z, r25.y
        ige r25.z, r25.x, l(0)
        or r30.xyz, r30.xyzx, r31.xyzx
        or r26.w, r30.y, r30.x
        or r26.w, r30.z, r26.w
        and r28.w, r25.w, l(0x7fffffff)
        ult r28.w, l(0x7f800000), r28.w
        or r26.w, r26.w, r28.w
        mul r28.w, r33.y, r34.z
        sample_c_lz_indexable(texture2d)(float,float,float,float) r25.w, r32.zwzz, t6.xxxx, s4, r25.w
        mad r25.y, r28.w, r25.w, r25.y
        add r25.y, r25.y, l(-1.000000)
        mad r25.x, cb4[r25.x + 288].w, r25.y, l(1.000000)
        movc r25.x, r26.w, l(1.000000), r25.x
        movc r25.x, r25.z, r25.x, l(1.000000)
      else
        mov r25.x, l(1.000000)
      endif
      if_nz r27.w
        dp3 r25.y, r15.xyzx, r28.xyzx
        mul_sat r25.z, r24.z, cb3[r19.z + 6].z
        mad r25.z, r25.z, l(0.500000), r3.y
        min r25.z, r25.z, l(1.000000)
        div r25.z, r3.y, r25.z
        mad r30.xyz, r15.xyzx, r25.yyyy, -r28.xyzx
        dp3 r25.w, r29.xyzx, r30.xyzx
        mul r25.y, r25.y, r25.y
        mad r25.y, cb3[r19.z + 6].z, cb3[r19.z + 6].z, -r25.y
        div_sat r25.y, r25.w, r25.y
        mad r28.xyz, r28.xyzx, r25.yyyy, r29.xyzx
        dp3 r25.y, r28.xyzx, r28.xyzx
        rsq r25.y, r25.y
        mul r27.xyz, r25.yyyy, r28.xyzx
      else
        mov r25.z, l(1.000000)
      endif
      if_nz r23.z
        mul_sat r23.z, r24.z, cb3[r20.w + 6].y
        mad r27.xyz, r8.xyzx, r7.wwww, r27.xyzx
        dp3 r24.z, r27.xyzx, r27.xyzx
        max r24.z, r24.z, l(0.000061)
        rsq r24.z, r24.z
        mul r27.xyz, r24.zzzz, r27.xyzx
        max r21.w, r21.w, l(0.000000)
        movc r24.w, r22.w, r21.w, -r21.w
        dp3 r21.w, r24.xywx, r24.xywx
        rsq r21.w, r21.w
        mul r24.xyz, r21.wwww, r24.xywx
        mul r24.xyz, r24.xyzx, cb3[r19.z + 6].zzzz
        mad r28.xyz, -r24.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r26.xyzx
        mad r24.xyz, r24.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), r26.xyzx
        dp3 r21.w, r13.xyzx, r28.xyzx
        dp3 r22.w, r28.xyzx, r28.xyzx
        sqrt r22.w, r22.w
        div r21.w, r21.w, r22.w
        dp3 r22.w, r13.xyzx, r24.xyzx
        dp3 r24.x, r24.xyzx, r24.xyzx
        sqrt r24.x, r24.x
        div r22.w, r22.w, r24.x
        add r21.w, r21.w, r22.w
        mul_sat r21.w, r21.w, l(0.500000)
        movc r19.x, r27.w, r21.w, r19.x
        dp3_sat r21.w, r13.xyzx, r27.xyzx
        dp3_sat r22.w, r9.xyzx, r27.xyzx
        lt r24.x, l(0.000000), r23.z
        mul r23.z, r23.z, r23.z
        mad r24.y, r22.w, l(3.600000), l(0.400000)
        div r23.z, r23.z, r24.y
        mad r23.z, r12.w, r12.w, r23.z
        min r23.z, r23.z, l(1.000000)
        movc r23.z, r24.x, r23.z, r3.y
        mul r23.z, r23.z, r23.z
        mad r24.x, r21.w, r23.z, -r21.w
        mad r21.w, r24.x, r21.w, l(1.000000)
        add r22.w, -r22.w, l(1.000000)
        mul r24.x, r22.w, r22.w
        mul r24.x, r24.x, r24.x
        mul r24.y, r22.w, r24.x
        mad r22.w, -r24.x, r22.w, l(1.000000)
        mad r24.xyz, r1.xzwx, r22.wwww, r24.yyyy
        mul r21.w, r21.w, r21.w
        div r21.w, r23.z, r21.w
        mul r21.w, r25.z, r21.w
        mad r22.w, -r12.x, r23.z, r12.x
        mad r22.w, r22.w, r12.x, r23.z
        sqrt r22.w, r22.w
        mad r24.w, -r20.x, r23.z, r20.x
        mad r23.z, r24.w, r20.x, r23.z
        sqrt r23.z, r23.z
        mul r23.z, r12.x, r23.z
        mad r22.w, r20.x, r22.w, r23.z
        add r22.w, r22.w, l(0.000100)
        div r22.w, l(0.500000), r22.w
        mul r21.w, r21.w, r22.w
        mul r24.xyz, r21.wwww, r24.xyzx
        min r24.xyz, r24.xyzx, l(2048.000000, 2048.000000, 2048.000000, 0.000000)
        mad r25.yz, r20.xxzx, l(0.000000, 0.968750, 0.968750, 0.000000), l(0.000000, 0.015625, 0.015625, 0.000000)
        sample_l_indexable(texture2d)(float,float,float,float) r21.w, r25.yzyy, t13.yzwx, s1, l(0.000000)
        mul r21.w, r11.x, r21.w
        mul r21.w, r9.w, r21.w
        div r21.w, r21.w, r10.w
        mul r25.yzw, r16.xxyz, r21.wwww
        div r25.yzw, r25.yyzw, r17.xxyz
        add r24.xyz, r24.xyzx, r25.yzwy
        mul r24.xyz, r24.xyzx, cb3[r20.w + 6].zzzz
        max r24.xyz, r24.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
        min r24.xyz, r24.xyzx, l(1000.000000, 1000.000000, 1000.000000, 0.000000)
        mul r25.yzw, r10.xxyz, r19.xxxx
        mad r24.xyz, r24.xyzx, r20.xxxx, r25.yzwy
        mul r25.yzw, r20.yyyy, cb3[r18.z + 6].xxyz
        mul r25.xyz, r25.xxxx, r25.yzwy
        mul r25.xyz, r18.xxxx, r25.xyzx
        mul r24.xyz, r24.xyzx, r25.xyzx
      else
        mov r24.xyz, l(0,0,0,0)
      endif
    else
      if_z r18.y
        mad r18.x, cb3[r19.z + 6].y, l(0.500000), l(0.500000)
        add r25.x, r18.x, -|cb3[r19.z + 6].x|
        add r25.y, -r25.x, cb3[r19.z + 6].y
        add r18.x, -|r25.x|, l(1.000000)
        add r18.x, -|r25.y|, r18.x
        max r18.x, r18.x, l(0.000488)
        ge r18.y, cb3[r19.z + 6].x, l(0.000000)
        movc r25.z, r18.y, r18.x, -r18.x
        dp3 r18.x, r25.xyzx, r25.xyzx
        rsq r18.x, r18.x
        mul r25.xyz, r18.xxxx, r25.xyzx
        add r26.xyz, -r5.xyzx, cb3[r23.x + 6].xyzx
        dp3 r18.x, r26.xyzx, r26.xyzx
        rsq r18.y, r18.x
        mul r27.xyz, r18.yyyy, r26.xyzx
        ftoi r18.y, cb3[r20.w + 6].w
        mul r20.xyw, r25.xyxz, cb3[r19.z + 6].zzzz
        mad r28.xyz, -r20.xywx, l(0.500000, 0.500000, 0.500000, 0.000000), r26.xyzx
        mad r20.xyw, r20.xyxw, l(0.500000, 0.500000, 0.000000, 0.500000), r26.xyxz
        ftou r18.z, cb3[r18.z + 6].w
        and r18.z, r18.z, l(1)
        ieq r19.x, r18.z, l(0)
        not r19.x, r19.x
        lt r21.w, l(0.000000), cb3[r19.z + 6].z
        and r19.x, r19.x, r21.w
        dp3 r21.w, r28.xyzx, r28.xyzx
        sqrt r21.w, r21.w
        dp3 r22.w, r20.xywx, r20.xywx
        sqrt r22.w, r22.w
        dp3 r20.x, r28.xyzx, r20.xywx
        mad r20.x, r21.w, r22.w, r20.x
        mad r20.x, r20.x, l(0.500000), l(1.000000)
        div r20.x, l(1.000000, 1.000000, 1.000000, 1.000000), r20.x
        movc r20.x, r19.x, r20.x, l(1.000000)
        lt r20.y, cb3[r23.w + 6].w, l(0.000000)
        if_nz r20.y
          mul r20.y, cb3[r23.x + 6].w, cb3[r23.x + 6].w
          mul r20.y, r18.x, r20.y
          mad r20.y, -r20.y, r20.y, l(1.000000)
          max r20.y, r20.y, l(0.000000)
          add r18.x, r18.x, l(1.000000)
          div r18.x, l(1.000000, 1.000000, 1.000000, 1.000000), r18.x
          and r20.w, r19.x, l(0x3f800000)
          add r21.w, -r18.x, r20.x
          mad r18.x, r20.w, r21.w, r18.x
          mul r20.y, r20.y, r20.y
          mul r18.x, r18.x, r20.y
        else
          mul r28.xyz, r26.xyzx, cb3[r23.x + 6].wwww
          dp3 r20.y, r28.xyzx, r28.xyzx
          min r20.y, r20.y, l(1.000000)
          add r20.y, -r20.y, l(1.000000)
          log r20.y, r20.y
          mul r20.y, r20.y, cb3[r23.w + 6].w
          exp r20.y, r20.y
          mul r18.x, r20.y, r20.x
        endif
        dp3 r20.x, r27.xyzx, -r25.xyzx
        add r20.x, r20.x, -cb3[r19.z + 6].z
        mul_sat r20.x, r20.x, cb3[r19.z + 6].w
        mul r20.x, r20.x, r20.x
        movc r20.x, r18.z, l(1.000000), r20.x
        mul r18.x, r18.x, r20.x
        not r19.x, r19.x
        ige r20.x, r18.y, l(0)
        and r19.x, r19.x, r20.x
        if_nz r19.x
          if_z r18.z
            ishl r19.x, r18.y, l(2)
            mul r20.xyw, r5.yyyy, cb6[r19.x + 33].xyxw
            mad r20.xyw, cb6[r19.x + 32].xyxw, r5.xxxx, r20.xyxw
            mad r20.xyw, cb6[r19.x + 34].xyxw, r5.zzzz, r20.xyxw
            add r20.xyw, r20.xyxw, cb6[r19.x + 35].xyxw
            div_sat r20.xy, r20.xyxx, r20.wwww
            mad r20.xy, r20.xyxx, cb6[r18.y + 0].zwzz, cb6[r18.y + 0].xyxx
          else
            ishl r19.x, r18.y, l(2)
            dp3 r25.x, -r26.xyzx, cb6[r19.x + 32].xyzx
            dp3 r25.y, -r26.xyzx, cb6[r19.x + 33].xyzx
            dp3 r25.z, -r26.xyzx, cb6[r19.x + 34].xyzx
            lt r19.x, |r25.x|, |r25.y|
            and r19.x, r19.x, l(1)
            dp2 r20.w, |r25.xyxx|, icb[r19.x + 0].xyxx
            lt r20.w, r20.w, |r25.z|
            movc r19.x, r20.w, l(2), r19.x
            dp3 r20.w, r25.xyzx, icb[r19.x + 0].xyzx
            lt r20.w, r20.w, l(0.000000)
            bfi r19.x, l(31), l(1), r19.x, r20.w
            ushr r20.w, r19.x, l(1)
            dp3 r20.w, r25.xyzx, icb[r20.w + 0].xyzx
            div r21.w, l(0.000244), cb6[r18.y + 0].w
            add r21.w, -r21.w, l(0.500000)
            utof r22.w, r19.x
            ult r23.z, r19.x, l(2)
            and r23.z, r23.z, l(2)
            dp2 r23.z, r25.xzxx, icb[r23.z + 0].xzxx
            mul r23.z, r23.z, icb[r19.x + 4].z
            div r23.z, r23.z, |r20.w|
            mad r22.w, r23.z, r21.w, r22.w
            add r22.w, r22.w, l(0.500000)
            mul_sat r26.x, r22.w, l(0.166667)
            iadd r22.w, l(-1), icb[r19.x + 4].y
            dp2 r22.w, r25.yzyy, icb[r22.w + 0].xyxx
            mul r19.x, r22.w, icb[r19.x + 4].w
            div r19.x, r19.x, |r20.w|
            mad_sat r26.y, -r19.x, r21.w, l(0.500000)
            mad r20.xy, r26.xyxx, cb6[r18.y + 0].zwzz, cb6[r18.y + 0].xyxx
          endif
          sample_l_indexable(texture2d)(float,float,float,float) r18.y, r20.xyxx, t15.yxzw, s1, l(0.000000)
          mul r18.x, r18.y, r18.x
        endif
        lt r18.x, l(0.000000), r18.x
        if_nz r18.x
          if_z r18.z
            ftoi r18.x, cb3[r23.y + 6].x
          else
            add r20.xyw, r5.xyxz, -cb3[r23.x + 6].xyxz
            lt r23.xzw, |r20.yyww|, |r20.xxxy|
            and r18.y, r23.z, r23.x
            lt r20.xyw, l(0.000000, 0.000000, 0.000000, 0.000000), r20.xyxw
            ushr r18.z, cb3[r19.z + 6].w, l(24)
            ubfe r23.xz, l(8, 0, 8, 0), l(16, 0, 8, 0), cb3[r19.z + 6].wwww
            movc r18.z, r20.x, r18.z, r23.x
            and r19.x, l(255), cb3[r19.z + 6].w
            movc r19.x, r20.y, r23.z, r19.x
            ubfe r19.z, l(8), l(8), cb3[r23.y + 6].x
            and r20.x, l(255), cb3[r23.y + 6].x
            movc r19.z, r20.w, r19.z, r20.x
            movc r19.x, r23.w, r19.x, r19.z
            movc r18.y, r18.y, r18.z, r19.x
            ilt r18.z, r18.y, l(80)
            movc r18.x, r18.z, r18.y, l(-1)
          endif
          ishl r18.y, r18.x, l(2)
          mad r20.xyw, r27.xyxz, cb4[r18.x + 288].xxxx, r5.xyxz
          mul r18.z, l(5.000000), cb4[r18.x + 288].y
          mad r20.xyw, r2.xyxw, r18.zzzz, r20.xyxw
          mul r23.xyzw, r20.yyyy, cb4[r18.y + 65].xyzw
          mad r23.xyzw, cb4[r18.y + 64].xyzw, r20.xxxx, r23.xyzw
          mad r23.xyzw, cb4[r18.y + 66].xyzw, r20.wwww, r23.xyzw
          add r23.xyzw, r23.xyzw, cb4[r18.y + 67].xyzw
          div r20.xyw, r23.xyxz, r23.wwww
          ge r23.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r20.xywx
          ge r25.xyz, r20.xywx, l(1.000000, 1.000000, 1.000000, 0.000000)
          add r18.yz, -cb4[r18.x + 344].xxyx, cb4[r18.x + 344].zzwz
          mad r18.yz, r20.xxyx, r18.yyzy, cb4[r18.x + 344].xxyx
          mad r19.xz, r18.yyzy, cb4[400].zzwz, l(0.500000, 0.000000, 0.500000, 0.000000)
          round_ni r19.xz, r19.xxzx
          mad r18.yz, r18.yyzy, cb4[400].zzwz, -r19.xxzx
          add r26.xyzw, r18.yyzz, l(0.500000, 1.000000, 0.500000, 1.000000)
          mul r27.xyzw, r26.xxzz, r26.xxzz
          add r20.xy, -r18.yzyy, l(1.000000, 1.000000, 0.000000, 0.000000)
          min r26.xz, r18.yyzy, l(0.000000, 0.000000, 0.000000, 0.000000)
          max r28.xy, r18.yzyy, l(0.000000, 0.000000, 0.000000, 0.000000)
          mul r29.xy, r20.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r28.xy, -r28.xyxx, r28.xyxx, r26.ywyy
          add r28.xy, r28.xyxx, l(1.000000, 1.000000, 0.000000, 0.000000)
          mul r28.xy, r28.xyxx, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r27.xz, r27.xxzx, l(0.080000, 0.000000, 0.080000, 0.000000)
          mad r18.yz, r27.yywy, l(0.000000, 0.500000, 0.500000, 0.000000), -r18.yyzy
          mul r30.xy, r18.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mad r18.yz, -r26.xxzx, r26.xxzx, r20.xxyx
          add r18.yz, r18.yyzy, l(0.000000, 1.000000, 1.000000, 0.000000)
          mul r31.xy, r18.yzyy, l(0.160000, 0.160000, 0.000000, 0.000000)
          mul r18.yz, r26.yywy, l(0.000000, 0.160000, 0.160000, 0.000000)
          mov r30.z, r31.x
          mov r30.w, r18.y
          mov r29.z, r28.x
          mov r29.w, r27.x
          add r26.xyzw, r29.zwxz, r30.zwxz
          mov r31.z, r30.y
          mov r31.w, r18.z
          mov r28.z, r29.y
          mov r28.w, r27.z
          add r27.xyz, r28.zywz, r31.zywz
          div r29.xyz, r29.xzwx, r26.zwyz
          add r29.xyz, r29.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r29.xyz, r29.yxzy, cb4[400].xxxx
          div r28.xyz, r28.zywz, r27.xyzx
          add r28.xyz, r28.xyzx, l(-2.500000, -0.500000, 1.500000, 0.000000)
          mul r28.xyz, r28.xyzx, cb4[400].yyyy
          mov r29.w, r28.x
          mad r30.xyzw, r19.xzxz, cb4[400].xyxy, r29.ywxw
          mad r18.yz, r19.xxzx, cb4[400].xxyx, r29.zzwz
          mov r28.w, r29.y
          mov r29.yw, r28.yyyz
          mad r31.xyzw, r19.xzxz, cb4[400].xyxy, r29.xyzy
          mad r28.xyzw, r19.xzxz, cb4[400].xyxy, r28.wywz
          mad r29.xyzw, r19.xzxz, cb4[400].xyxy, r29.xwzw
          mul r32.xyzw, r26.zwyz, r27.xxxy
          sample_c_lz_indexable(texture2d)(float,float,float,float) r19.x, r30.xyxx, t6.xxxx, s4, r20.w
          sample_c_lz_indexable(texture2d)(float,float,float,float) r19.z, r30.zwzz, t6.xxxx, s4, r20.w
          mul r19.z, r19.z, r32.y
          mad r19.x, r32.x, r19.x, r19.z
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.y, r18.yzyy, t6.xxxx, s4, r20.w
          mad r18.y, r32.z, r18.y, r19.x
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.z, r28.xyxx, t6.xxxx, s4, r20.w
          mad r18.y, r32.w, r18.z, r18.y
          mul r30.xyzw, r26.xyzw, r27.yyzz
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.z, r31.xyxx, t6.xxxx, s4, r20.w
          mad r18.y, r30.x, r18.z, r18.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.z, r31.zwzz, t6.xxxx, s4, r20.w
          mad r18.y, r30.y, r18.z, r18.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.z, r28.zwzz, t6.xxxx, s4, r20.w
          mad r18.y, r30.z, r18.z, r18.y
          sample_c_lz_indexable(texture2d)(float,float,float,float) r18.z, r29.xyxx, t6.xxxx, s4, r20.w
          mad r18.y, r30.w, r18.z, r18.y
          ige r18.z, r18.x, l(0)
          or r23.xyz, r23.xyzx, r25.xyzx
          or r19.x, r23.y, r23.x
          or r19.x, r23.z, r19.x
          and r19.z, r20.w, l(0x7fffffff)
          ult r19.z, l(0x7f800000), r19.z
          or r19.x, r19.z, r19.x
          mul r19.z, r26.y, r27.z
          sample_c_lz_indexable(texture2d)(float,float,float,float) r20.x, r29.zwzz, t6.xxxx, s4, r20.w
          mad r18.y, r19.z, r20.x, r18.y
          add r18.y, r18.y, l(-1.000000)
          mad r18.x, cb4[r18.x + 288].w, r18.y, l(1.000000)
          movc r18.x, r19.x, l(1.000000), r18.x
          movc r18.x, r18.z, r18.x, l(1.000000)
        else
          mov r18.x, l(1.000000)
        endif
      else
        mov r18.x, l(1.000000)
      endif
      mul r16.w, r16.w, r18.x
      mov r24.xyz, l(0,0,0,0)
    endif
    add r22.xyz, r22.xyzx, r24.xyzx
    mov r17.w, r19.w
  endloop
  mov r12.y, r16.w
  add r21.xyz, r21.xyzx, r22.xyzx
  iadd r12.z, r12.z, l(1)
endloop
mad r8.xyz, r21.xyzx, r12.yyyy, r14.xyzx
ne r3.yz, l(0.000000, 0.000000, 0.000000, 0.000000), cb0[112].xxyx
if_nz r3.y
  sample_b_indexable(texture2d)(float,float,float,float) r0.z, v1.xyxx, t4.yzxw, s0, cb0[108].x
  min r0.z, r1.y, r0.z
  dp3 r2.z, r2.xywx, r9.xyzx
  max r2.z, r2.z, l(0.000000)
  add r2.z, r0.z, r2.z
  mad r3.y, r12.w, l(-16.000000), l(-1.000000)
  exp r3.y, r3.y
  log r2.z, |r2.z|
  mul r2.z, r2.z, r3.y
  exp r2.z, r2.z
  add r2.z, r0.z, r2.z
  add r2.z, r2.z, l(-1.000000)
  mov_sat r12.xyz, r2.zzzz
  mad r14.xyz, r10.xyzx, l(2.040400, 2.040400, 2.040400, 0.000000), l(-0.332400, -0.332400, -0.332400, 0.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
  mad r14.xyz, r10.xyzx, l(-4.795100, -4.795100, -4.795100, 0.000000), r14.xyzx
  add r14.xyz, r14.xyzx, l(0.641700, 0.641700, 0.641700, 0.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
  mad r14.xyz, r10.xyzx, l(2.755200, 2.755200, 2.755200, 0.000000), r14.xyzx
  add r14.xyz, r14.xyzx, l(0.690300, 0.690300, 0.690300, 0.000000)
  mul r14.xyz, r0.zzzz, r14.xyzx
  max r14.xyz, r0.zzzz, r14.xyzx
else
  mov r12.xyz, r1.yyyy
  mov r14.xyz, r1.yyyy
endif
mad r16.xyz, r2.xywx, l(0.250000, 0.250000, 0.250000, 0.000000), r5.xyzx
round_z r0.z, cb0[216].x
mad r17.xy, r0.zzzz, l(2.083000, 4.867000, 0.000000, 0.000000), r4.xyxx
dp2 r0.z, r17.xyxx, l(0.067111, 0.005837, 0.000000, 0.000000)
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
add r1.y, |r17.z|, l(-208.000000)
mul_sat r1.y, r1.y, l(0.031250)
max r0.z, r0.z, r1.y
ne r1.y, l(0.000000), cb0[214].w
lt r2.z, r0.z, l(1.000000)
and r1.y, r1.y, r2.z
if_nz r1.y
  mad r17.xyz, cb0[6].xzyx, -cb0[216].yyyy, cb0[214].xzyx
  add r17.xyz, r16.xzyx, -r17.xyzx
  max r1.y, |r17.y|, |r17.x|
  add r1.y, r1.y, l(-29.000000)
  mul_sat r1.y, r1.y, l(0.500000)
  add r2.z, |r17.z|, l(-13.000000)
  mul_sat r2.z, r2.z, l(0.500000)
  max r1.y, r1.y, r2.z
  lt r2.z, r1.y, l(1.000000)
  if_nz r2.z
    mad r17.xyz, r16.xyzx, l(2.000000, 2.000000, 2.000000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r18.xyz, r17.xyzx, cb0[215].xyzx
    round_ni r18.xyz, r18.xyzx
    mad r17.xyz, r17.xyzx, cb0[215].xyzx, -r18.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r18.xyw, r17.xyzx, t19.yzwx, s2, l(0.000000)
    add r2.z, -r1.y, l(1.000000)
    mul r3.y, l(0.500000), cb0[215].y
    mad r9.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r3.y, r3.y, r17.y
    min r3.y, r9.w, r3.y
    mul r17.w, r3.y, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyzw, r17.xwzx, t20.xyzw, s1, l(0.000000)
    mad r3.y, r19.w, r2.z, r0.z
    add r20.xyz, r17.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r20.xyz, r20.xyzx, t20.xyzw, s1, l(0.000000)
    mad r20.xyz, r20.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r20.xyz, r18.yyyy, r20.xyzx
    mov r20.w, r18.y
    mul r20.xyzw, r2.zzzz, r20.xyzw
    add r17.xyz, r17.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r17.xyz, r17.xyzx, t20.xyzw, s1, l(0.000000)
    mad r17.xyz, r17.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r17.xyz, r18.xxxx, r17.xyzx
    mov r17.w, r18.x
    mul r17.xyzw, r2.zzzz, r17.xyzw
    mad r19.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r18.xyz, r18.wwww, r19.xyzx
    mul r18.xyzw, r2.zzzz, r18.xyzw
  else
    mov r20.xyzw, l(0,0,0,0)
    mov r17.xyzw, l(0,0,0,0)
    mov r18.xyzw, l(0,0,0,0)
    mov r3.y, r0.z
  endif
  mad r19.xyz, cb0[6].xzyx, -cb0[216].zzzz, cb0[214].xzyx
  add r19.xyz, r16.xzyx, -r19.xyzx
  max r2.z, |r19.y|, |r19.x|
  add r2.z, r2.z, l(-116.000000)
  mul_sat r2.z, r2.z, l(0.125000)
  add r9.w, |r19.z|, l(-52.000000)
  mul_sat r9.w, r9.w, l(0.125000)
  max r2.z, r2.z, r9.w
  lt r9.w, r2.z, l(1.000000)
  if_nz r9.w
    mad r19.xyz, r16.xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r21.xyz, r19.xyzx, cb0[215].xyzx
    round_ni r21.xyz, r21.xyzx
    mad r19.xyz, r19.xyzx, cb0[215].xyzx, -r21.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyw, r19.xyzx, t21.yzwx, s2, l(0.000000)
    add r9.w, -r2.z, l(1.000000)
    mul r1.y, r1.y, r9.w
    mul r9.w, l(0.500000), cb0[215].y
    mad r10.w, -cb0[215].y, l(0.500000), l(1.000000)
    max r9.w, r9.w, r19.y
    min r9.w, r10.w, r9.w
    mul r19.w, r9.w, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyzw, r19.xwzx, t22.xyzw, s1, l(0.000000)
    mad r3.y, r22.w, r1.y, r3.y
    add r23.xyz, r19.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r23.xyz, r23.xyzx, t22.xyzw, s1, l(0.000000)
    mad r23.xyz, r23.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r23.xyz, r21.yyyy, r23.xyzx
    mov r23.w, r21.y
    mad r20.xyzw, r23.xyzw, r1.yyyy, r20.xyzw
    add r19.xyz, r19.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyz, r19.xyzx, t22.xyzw, s1, l(0.000000)
    mad r19.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r19.xyz, r21.xxxx, r19.xyzx
    mov r19.w, r21.x
    mad r17.xyzw, r19.xyzw, r1.yyyy, r17.xyzw
    mad r19.xyz, r22.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r21.wwww, r19.xyzx
    mad r18.xyzw, r21.xyzw, r1.yyyy, r18.xyzw
  endif
  lt r1.y, l(0.000000), r2.z
  if_nz r1.y
    mad r16.xyz, r16.xyzx, l(0.125000, 0.125000, 0.125000, 0.000000), l(0.500000, 0.500000, 0.500000, 0.000000)
    mul r19.xyz, r16.xyzx, cb0[215].xyzx
    mul r21.xyz, l(0.500000, 0.500000, 0.500000, 0.000000), cb0[215].xyzx
    round_ni r19.xyz, r19.xyzx
    mad r16.xyz, r16.xyzx, cb0[215].xyzx, -r19.xyzx
    mad r19.xyz, -cb0[215].xyzx, l(0.500000, 0.500000, 0.500000, 0.000000), l(1.000000, 1.000000, 1.000000, 0.000000)
    max r16.xyz, r21.xyzx, r16.xyzx
    min r16.xyz, r19.xyzx, r16.xyzx
    sample_l_indexable(texture3d)(float,float,float,float) r22.xyw, r16.xyzx, t23.yzwx, s2, l(0.000000)
    add r1.y, -r0.z, l(1.000000)
    mul r1.y, r1.y, r2.z
    max r2.z, r21.y, r16.y
    min r2.z, r19.y, r2.z
    mul r16.w, r2.z, l(0.333333)
    sample_l_indexable(texture3d)(float,float,float,float) r19.xyzw, r16.xwzx, t24.xyzw, s1, l(0.000000)
    add r21.xyz, r16.xwzx, l(0.000000, 0.666667, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r21.xyz, r21.xyzx, t24.xyzw, s1, l(0.000000)
    mad r21.xyz, r21.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r21.xyz, r22.yyyy, r21.xyzx
    mov r21.w, r22.y
    mad r20.xyzw, r21.xyzw, r1.yyyy, r20.xyzw
    add r16.xyz, r16.xwzx, l(0.000000, 0.333333, 0.000000, 0.000000)
    sample_l_indexable(texture3d)(float,float,float,float) r16.xyz, r16.xyzx, t24.xyzw, s1, l(0.000000)
    mad r16.xyz, r16.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r16.xyz, r22.xxxx, r16.xyzx
    mov r16.w, r22.x
    mad r17.xyzw, r16.xyzw, r1.yyyy, r17.xyzw
    mad r16.xyz, r19.xyzx, l(4.000000, 4.000000, 4.000000, 0.000000), l(-2.000000, -2.000000, -2.000000, 0.000000)
    mul r22.xyz, r22.wwww, r16.xyzx
    mad r18.xyzw, r22.xyzw, r1.yyyy, r18.xyzw
    mad r3.y, r19.w, r1.y, r3.y
  endif
  mad_sat r1.y, r3.y, l(2.000000), l(-1.000000)
  add r16.x, -r0.z, r1.y
  add r0.z, r0.z, r1.y
  mul r16.y, r0.z, l(0.500000)
else
  mov r20.xyzw, l(0,0,0,0)
  mov r17.xyzw, l(0,0,0,0)
  mov r18.xyzw, l(0,0,0,0)
  mov r16.xy, l(0,1.000000,0,0)
endif
mul r19.xyzw, r16.yxyy, cb0[217].ywzx
mad r19.y, r19.y, l(0.500000), r19.x
mul r16.zw, r16.yyyx, cb0[217].wwwy
mad r19.x, r16.w, l(0.375000), r16.z
add r18.xyzw, r18.xyzw, r19.wyzx
mul r19.xyzw, r16.yxyy, cb0[218].ywzx
mad r19.y, r19.y, l(0.500000), r19.x
mul r16.zw, r16.yyyx, cb0[218].wwwy
mad r19.x, r16.w, l(0.375000), r16.z
add r17.xyzw, r17.xyzw, r19.wyzx
mul r19.xyzw, r16.yxyy, cb0[219].ywzx
mad r19.y, r19.y, l(0.500000), r19.x
mul r16.xy, r16.yxyy, cb0[219].wyww
mad r19.x, r16.y, l(0.375000), r16.x
add r16.xyzw, r19.wyzx, r20.xyzw
ge r19.xy, r4.zwzz, l(0.000000, 0.000000, 0.000000, 0.000000)
and r0.z, r19.y, r19.x
if_nz r0.z
  sample_l_indexable(texture2d)(float,float,float,float) r19.xyzw, r4.zwzz, t18.xyzw, s1, l(0.000000)
  lt r20.xyzw, l(0.000100, 0.000100, 0.000100, 0.000100), |r19.xyzw|
  or r4.zw, r20.zzzw, r20.xxxy
  or r0.z, r4.w, r4.z
  if_nz r0.z
    dp3 r0.z, r19.yzwy, r19.yzwy
    sqrt r0.z, r0.z
    mov r4.z, l(1.000000)
    mov r4.w, r0.z
    mov r1.y, l(0)
    loop
      ge r2.z, l(4.600000), r4.w
      breakc_nz r2.z
      iadd r2.z, r1.y, l(1)
      mul r20.xy, r4.zwzz, l(0.500000, 0.500000, 0.000000, 0.000000)
      mov r4.zw, r20.xxxy
      mov r1.y, r2.z
      continue
    endloop
    mul r19.xyzw, r4.zzzz, r19.xyzw
    dp3 r0.z, r19.yzwy, r19.yzwy
    sqrt r0.z, r0.z
    mad r0.z, r0.z, cb7[3].x, cb7[3].y
    mad r0.z, r0.z, l(255.000000), l(0.500000)
    mul r20.x, r0.z, l(0.003906)
    mov r20.y, l(0.500000)
    sample_l_indexable(texture2d)(float,float,float,float) r4.zw, r20.xyxx, t17.zwxy, s1, l(0.000000)
    mad r4.zw, r4.zzzw, cb7[2].xxxy, cb7[2].zzzw
    mul r20.x, r4.z, l(3.544908)
    mul r20.yzw, r4.wwww, r19.yyzw
    mul r0.z, r19.x, l(0.406977)
    exp r0.z, r0.z
    mul r19.xyzw, r0.zzzz, r20.xyzw
    mov r20.xyzw, r19.xyzw
    mov r0.z, l(0)
    loop
      uge r2.z, r0.z, r1.y
      breakc_nz r2.z
      mul r21.xyzw, r20.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
      dp4 r2.z, r21.xyzw, r20.xyzw
      dp2 r3.y, r21.yxyy, r20.xyxx
      dp2 r4.z, r21.zxzz, r20.xzxx
      dp2 r4.w, r21.wxww, r20.xwxx
      iadd r9.w, r0.z, l(1)
      mov r20.x, r2.z
      mov r20.y, r3.y
      mov r20.zw, r4.zzzw
      mov r0.z, r9.w
      continue
    endloop
    mul r19.xyzw, r20.xyzw, l(0.282095, 0.282095, 0.282095, 0.282095)
    mul r20.xyzw, r18.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r0.z, r19.xyzw, r20.xyzw
    dp2 r1.y, r19.yxyy, r20.xyxx
    dp2 r2.z, r19.zxzz, r20.xzxx
    dp2 r3.y, r19.wxww, r20.xwxx
    mul r20.xyzw, r17.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r4.z, r19.xyzw, r20.xyzw
    dp2 r4.w, r19.yxyy, r20.xyxx
    dp2 r9.w, r19.zxzz, r20.xzxx
    dp2 r10.w, r19.wxww, r20.xwxx
    mul r20.xyzw, r16.wyzx, l(1.128379, -0.977205, 0.977205, -0.977205)
    dp4 r11.x, r19.xyzw, r20.xyzw
    dp2 r14.w, r19.yxyy, r20.xyxx
    dp2 r15.w, r19.zxzz, r20.xzxx
    dp2 r19.x, r19.wxww, r20.xwxx
    mul r18.w, r0.z, l(0.886227)
    mul r18.x, r3.y, l(-1.023327)
    mul r18.y, r1.y, l(-1.023327)
    mul r18.z, r2.z, l(1.023327)
    mul r17.x, r10.w, l(-1.023327)
    mul r17.yw, r4.wwwz, l(0.000000, -1.023327, 0.000000, 0.886227)
    mul r17.z, r9.w, l(1.023327)
    mul r16.w, r11.x, l(0.886227)
    mul r16.x, r19.x, l(-1.023327)
    mul r16.y, r14.w, l(-1.023327)
    mul r16.z, r15.w, l(1.023327)
  endif
endif
dp3 r0.z, r18.xyzx, r2.xywx
add r0.z, r18.w, r0.z
max r18.x, r0.z, l(0.000000)
dp3 r0.z, r17.xyzx, r2.xywx
add r0.z, r17.w, r0.z
max r18.y, r0.z, l(0.000000)
dp3 r0.z, r16.xyzx, r2.xywx
add r0.z, r16.w, r0.z
max r18.z, r0.z, l(0.000000)
add r0.z, l(-1.000000), cb0[113].x
max r1.y, r12.w, l(0.001000)
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
mul r2.xyz, r18.xyzx, cb0[111].xxxx
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
  ine r10.w, r4.z, l(0)
  and r10.w, r9.w, r10.w
  if_nz r10.w
    firstbit_lo r10.w, r4.z
    ishl r11.x, l(1), r10.w
    xor r4.z, r4.z, r11.x
    ishl r10.w, r10.w, l(3)
    dp4 r16.x, cb1[r10.w + 6].xyzw, r5.xyzw
    dp4 r16.y, cb1[r10.w + 7].xyzw, r5.xyzw
    dp4 r16.z, cb1[r10.w + 8].xyzw, r5.xyzw
    ge r17.xyz, cb1[r10.w + 5].xyzx, |r16.xyzx|
    and r11.x, r17.y, r17.x
    and r11.x, r17.z, r11.x
    if_nz r11.x
      mul r11.x, l(0.100000), cb1[r10.w + 5].x
      mul r17.xyz, |r16.xyzx|, l(0.100000, 0.100000, 0.100000, 0.000000)
      mul r17.xy, r17.xyxx, r17.xyxx
      add r19.xyz, -|r16.xyzx|, cb1[r10.w + 5].xyzx
      mul r19.xyz, r19.xyzx, cb1[r10.w + 9].xyzx
      eq r12.w, l(1.000000), cb1[r10.w + 10].x
      if_nz r12.w
        dp3 r20.x, cb1[r10.w + 6].xyzx, r15.xyzx
        dp3 r20.y, cb1[r10.w + 7].xyzx, r15.xyzx
        dp3 r20.z, cb1[r10.w + 8].xyzx, r15.xyzx
        add r21.xyz, -r16.xyzx, cb1[r10.w + 5].xyzx
        div r21.xyz, r21.xyzx, r20.xyzx
        add r22.xyz, -r16.xyzx, -cb1[r10.w + 5].xyzx
        div r22.xyz, r22.xyzx, r20.xyzx
        lt r23.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r20.xyzx
        movc r21.xyz, r23.xyzx, r21.xyzx, r22.xyzx
        min r12.w, r21.y, r21.x
        min r12.w, r21.z, r12.w
        mad r16.xyz, r20.xyzx, r12.wwww, r16.xyzx
      else
        mov r16.xyz, r15.xyzx
      endif
      dp3 r12.w, r16.xyzx, r16.xyzx
      rsq r12.w, r12.w
      mul r16.xyz, r12.wwww, r16.xyzx
      lt r20.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r16.xyzx
      lt r21.xyz, r16.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
      iadd r20.xyz, -r20.xyzx, r21.xyzx
      itof r20.xyz, r20.xyzx
      dp3 r12.w, r16.xyzx, r20.xyzx
      div r16.xyz, r16.xyzx, r12.wwww
      lt r12.w, r16.z, l(0.000000)
      add r16.zw, -|r16.yyyx|, l(0.000000, 0.000000, 1.000000, 1.000000)
      mul r16.zw, r16.zzzw, r20.xxxy
      movc r16.xy, r12.wwww, r16.zwzz, r16.xyxx
      dp4 r12.w, cb1[r10.w + 4].xyzw, r13.xyzw
      max r12.w, r12.w, l(0.000000)
      max r12.w, r12.w, l(0.000100)
      min r14.w, r19.z, r19.y
      min r14.w, r14.w, r19.x
      add r15.w, r17.y, r17.x
      mad r15.w, r17.z, r17.z, r15.w
      mad r11.x, r11.x, r11.x, -r15.w
      mul r11.x, r11.x, cb1[r10.w + 9].x
      mul r11.x, r11.x, cb1[r10.w + 9].x
      add r15.w, l(1.000000), -cb1[r10.w + 10].y
      mul r11.x, r11.x, r15.w
      mul r11.x, r11.x, l(100.000000)
      mad_sat r11.x, r14.w, cb1[r10.w + 10].y, r11.x
      mul r14.w, r11.x, cb1[r10.w + 10].w
      mad r16.xy, r16.xyxx, l(0.500000, 0.500000, 0.000000, 0.000000), l(0.500000, 0.500000, 0.000000, 0.000000)
      mad r16.xy, r16.xyxx, cb1[1].wwww, cb1[2].wwww
      mov r16.z, cb1[r10.w + 5].w
      sample_l_indexable(texture2darray)(float,float,float,float) r16.xyz, r16.xyzx, t5.xyzw, s3, r0.z
      mul r16.xyz, r16.xyzx, cb1[r10.w + 9].wwww
      div r15.w, r2.x, r12.w
      min r15.w, |r15.w|, l(1.000000)
      mad r15.w, r15.w, l(2.000000), r2.x
      add r12.w, r12.w, l(2.000000)
      div r12.w, r15.w, r12.w
      add r12.w, r12.w, l(-1.000000)
      mad r12.w, r12.w, cb0[112].w, l(1.000000)
      mul r16.xyz, r12.wwww, r16.xyzx
      mul r16.xyz, r14.wwww, r16.xyzx
      mad r2.yzw, r16.xxyz, r3.yyyy, r2.yyzw
      mad r10.w, -r11.x, cb1[r10.w + 10].w, l(1.000000)
      mul r3.y, r3.y, r10.w
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
  dp3 r1.y, r15.xyzx, r15.xyzx
  rsq r1.y, r1.y
  mul r15.xyz, r1.yyyy, r15.xyzx
  lt r16.xyz, l(0.000000, 0.000000, 0.000000, 0.000000), r15.xyzx
  lt r17.xyz, r15.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
  iadd r16.xyz, -r16.xyzx, r17.xyzx
  itof r16.xyz, r16.xyzx
  dp3 r1.y, r15.xyzx, r16.xyzx
  div r15.xyz, r15.xyzx, r1.yyyy
  lt r1.y, r15.z, l(0.000000)
  add r4.zw, -|r15.yyyx|, l(0.000000, 0.000000, 1.000000, 1.000000)
  mul r4.zw, r4.zzzw, r16.xxxy
  movc r4.zw, r1.yyyy, r4.zzzw, r15.xxxy
  mov r13.w, l(1.000000)
  dp4 r1.y, cb1[3].xyzw, r13.xyzw
  max r1.y, r1.y, l(0.000000)
  max r1.y, r1.y, l(0.000100)
  mad r4.zw, r4.zzzw, l(0.000000, 0.000000, 0.500000, 0.500000), l(0.000000, 0.000000, 0.500000, 0.500000)
  mad r13.xy, r4.zwzz, cb1[1].wwww, cb1[2].wwww
  mov r13.z, l(0)
  sample_l_indexable(texture2darray)(float,float,float,float) r13.xyz, r13.xyzx, t5.xyzw, s3, r0.z
  div r0.z, r2.x, r1.y
  min r0.z, |r0.z|, l(1.000000)
  mad r0.z, r0.z, l(2.000000), r2.x
  add r1.y, r1.y, l(2.000000)
  div r0.z, r0.z, r1.y
  add r0.z, r0.z, l(-1.000000)
  mad r0.z, r0.z, cb0[112].w, l(1.000000)
  mul r13.xyz, r0.zzzz, r13.xyzx
  mad r2.yzw, r13.xxyz, r3.yyyy, r2.yyzw
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
  sample_b_indexable(texture2d)(float,float,float,float) r13.xyz, v1.xyxx, t2.xyzw, s1, cb0[108].x
  add r1.y, -r0.z, l(1.000000)
  mul r15.xyz, r1.yyyy, r2.xyzx
  mad r2.xyz, r13.xyzx, r0.zzzz, r15.xyzx
endif
mul r10.xyz, r10.xyzx, r18.xyzx
mul r10.xyz, r10.xyzx, cb0[111].xxxx
add r0.z, -r3.x, l(1.000000)
div r0.z, r0.z, r3.x
mul r1.xyz, r0.zzzz, r1.xzwx
mad r1.xyz, r1.xyzx, r11.yzwy, r11.yzwy
mul r1.xyz, r1.xyzx, r2.xyzx
mul r1.xyz, r12.xyzx, r1.xyzx
mad r1.xyz, r10.xyzx, r14.xyzx, r1.xyzx
add r1.xyz, r1.xyzx, r8.xyzx
max r1.xyz, r1.xyzx, l(0.000000, 0.000000, 0.000000, 0.000000)
min r1.xyz, r1.xyzx, l(255.000000, 255.000000, 255.000000, 0.000000)
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
dp3 r0.z, -r9.xyzx, cb0[154].xyzx
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
  dp3 r0.x, -r9.xyzx, -r7.xyzx
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
  add r5.w, r4.w, -cb0[159].x
  mul r5.w, r5.w, cb0[159].z
  max r5.w, r5.w, l(-127.000000)
  exp r5.w, -r5.w
  mul r5.w, r5.w, cb0[159].y
  lt r7.x, l(0.000000), |r4.z|
  exp r7.y, -r4.z
  add r7.y, -r7.y, l(1.000000)
  div r7.y, r7.y, r4.z
  mad r4.z, -r4.z, l(0.240227), l(0.693147)
  movc r4.z, r7.x, r7.y, r4.z
  add r4.w, r4.w, -cb0[162].z
  mul r4.w, r4.w, cb0[162].x
  max r4.w, r4.w, l(-127.000000)
  exp r4.w, -r4.w
  mul r4.w, r4.w, cb0[162].y
  lt r7.x, l(0.000000), |r2.w|
  exp r7.y, -r2.w
  add r7.y, -r7.y, l(1.000000)
  div r7.y, r7.y, r2.w
  mad r2.w, -r2.w, l(0.240227), l(0.693147)
  movc r2.w, r7.x, r7.y, r2.w
  mul r2.w, r2.w, r4.w
  mad r2.w, r5.w, r4.z, r2.w
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
  mul r7.xy, r0.ywyy, cb0[167].xyxx
  mad r0.y, |r3.w|, cb0[166].x, cb0[166].y
  log r0.y, r0.y
  mul r0.y, r0.y, cb0[166].z
  div r7.z, r0.y, cb0[165].z
  sample_l_indexable(texture3d)(float,float,float,float) r10.xyzw, r7.xyzx, t16.xyzw, s1, l(0.000000)
  add r0.y, |r3.w|, -cb0[168].z
  mul_sat r0.y, r0.y, l(1000000.000000)
  add r10.xyzw, r10.xyzw, l(-0.000000, -0.000000, -0.000000, -1.000000)
  mad r10.xyzw, r0.yyyy, r10.xyzw, l(0.000000, 0.000000, 0.000000, 1.000000)
  add r0.y, -r3.z, l(1.000000)
  dp3_sat r0.w, r9.xyzx, cb0[163].xyzx
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
  mad r0.xyw, r0.xyxw, r10.wwww, r10.xyxz
  mul r2.w, r3.z, r10.w
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
  dp3_sat r3.w, r9.xyzx, cb0[163].xyzx
  log r3.w, r3.w
  mul r3.w, r3.w, cb0[164].w
  exp r3.w, r3.w
  mul r4.xyz, r3.wwww, cb0[164].xyzx
  mad r3.w, r6.x, r7.w, -cb0[163].w
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
  mad r0.xyz, r1.xyzx, r39.xyzx, r40.xyzx
else
  mad r0.xyz, r1.xyzx, r3.xyzx, r0.xyzx
endif
dp3 r0.w, r3.xyzx, l(0.333333, 0.333333, 0.333333, 0.000000)
dp3 r1.w, r6.yzwy, r6.yzwy
sqrt r1.w, r1.w
mad_sat r1.w, -r1.w, cb0[171].z, l(1.000000)
mul r2.x, r1.w, cb0[171].x
mad r1.w, -cb0[171].x, r1.w, l(1.000000)
mul r2.yzw, cb0[170].xxyz, cb0[185].wwww
mad r2.yzw, r5.xxyz, cb0[171].yyyy, r2.yyzw
sample_l_indexable(texture3d)(float,float,float,float) r2.y, r2.yzwy, t29.xwyz, s2, l(0.000000)
dp2 r2.x, r2.yyyy, r2.xxxx
add r1.w, r1.w, r2.x
add r2.x, r0.w, l(1.000000)
min r1.w, r1.w, r2.x
add r0.xyz, -r1.xyzx, r0.xyzx
mad o0.xyz, r1.wwww, r0.xyzx, r1.xyzx
mov o0.w, r0.w
ret
// Approximately 0 instruction slots used
