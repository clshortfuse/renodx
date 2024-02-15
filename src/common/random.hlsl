// https://www.shadertoy.com/view/4djSRW
// 3 out, 3 in...
float3 hash33(float3 p3) {
  p3 = frac(p3 * float3(0.1031, 0.1030, 0.0973));
  p3 += dot(p3, p3.yxz + 33.33);
  return frac((p3.xxy + p3.yxx) * p3.zyx);
}
