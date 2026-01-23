#ifndef SRC_SHADERS_REINHARD_HLSL_
#define SRC_SHADERS_REINHARD_HLSL_

namespace renodx {
namespace tonemap {

// Multiple functions expanded and optimized
// See: https://www.desmos.com/calculator/7vt7aa3hs4

float Reinhard(float x, float peak = 1.f, float minimum = 0.f) {
  // return (x + minimum) / (x / peak + 1.f);

  // Micro-optimized version below:

  // y = x + m / (x / p + 1)
  // y = p(x + m) / (x + p)
  float num = peak * (x + minimum);
  float den = x + peak;

  // OR
  // y = x * (p - m) / (x + p) + m
  // return (x * (peak - minimum)) / (x + peak) + minimum;

  return num / den;
}

float3 Reinhard(float3 color, float3 peak = 1.f, float3 minimum = 0.f) {
  //   return (x + minimum) / (x / peak + 1.f);
  float3 num3 = peak * (color + minimum);
  float3 den3 = color + peak;
  return num3 / den3;
}

float ReinhardExtended(float x, float clip = 1000.f / 203.f, float peak = 1.f, float minimum = 0.f) {
  // float increase = (peak - minimum) / (clip * (clip + minimum));
  // float scaler = (1.f + (x * increase));
  // return Reinhard(x, peak, minimum) * scaler;

  // Micro-optimized version below:

  // y = (x + m) / (x/p + 1) * (1 + x(p - m) / c(c + m))
  // y = p(x + m) / (x + p) * (1 + x(p - m) / c(c + m))
  // y = p(x + m) * (1 + x(p - m) / c(c + m)) / (x + p)
  // y = p(x + m) * (c(c + m) + x(p - m)) / ((x + p) * c(c + m))
  // y = p(x + m) * (c(c + m) + x(p - m)) / ((x + p) * c(c + m))

  // float x_plus_m = x + minimum;                 // (x + m)
  // float c_plus_m = clip + minimum;              // (c + m)
  // float cc_plus_cm = clip * c_plus_m;           // c(c + m)
  // float p_minus_m = peak - minimum;             // (p - m)
  // float num_a = mad(x, p_minus_m, cc_plus_cm);  // c(c+m) + x(p-m)
  // float px_plus_pm = peak * x_plus_m;           // p * (x + m)
  // float num = px_plus_pm * num_a;               // p * (x + m) * (c(c+m) + x(p-m))
  // float x_plus_p = x + peak;                    // (x + p)
  // float den = x_plus_p * cc_plus_cm;            // (x + p) * c(c+m)
  // return num / den;

  // Faster if using outside m, though slightly different

  // y = q(x + 0) * (c(c + 0) + x(q - 0)) / ((x + q) * c(c + 0)) + m
  // y = q(x) * (c(c + 0) + x(q - 0)) / ((x + q) * c(c + 0)) + m
  // y = qx * (cc + xq) / ((x + q) * cc) + m
  // y = xq(cc + xq) / cc(x + q) + m

  float q = peak - minimum;              // q = p - m
  float xq = x * q;                      // x * q
  float cc = clip * clip;                // c * c
  float cc_plus_xq = cc + xq;            // cc + xq
  float num0 = xq * cc_plus_xq;          // xq(cc + xq)
  float x_plus_q = x + q;                // x + q
  float den0 = cc * x_plus_q;            // cc(x + q)
  float result = num0 / den0 + minimum;  // (xqcc + xqxq) / (ccx + ccq) + m
  return result;
}

float3 ReinhardExtended(float3 color, float3 clip = 1000.f / 203.f, float3 peak = 1.f, float3 minimum = 0.f) {
  float3 q = peak - minimum;              // q = p - m
  float3 xq = color * q;                  // x * q
  float3 cc = clip * clip;                // c * c
  float3 cc_plus_xq = cc + xq;            // cc + xq
  float3 num0 = xq * cc_plus_xq;          // xq(cc + xq)
  float3 x_plus_q = color + q;            // x + q
  float3 den0 = cc * x_plus_q;            // cc(x + q)
  float3 result = num0 / den0 + minimum;  // (xqcc + xqxq) / (ccx + ccq) + m
  return result;
}

float ComputeReinhardScale(float peak = 1.f, float minimum = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  //  s = (p * y - p * m) / (x * p - x * y)

  float num = peak * (gray_out - minimum);  // p * (y - m)
  float den = gray_in * (peak - gray_out);  // x * (p - y)

  return num / den;
}

float ReinhardScalable(float x, float peak = 1.f, float minimum = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  // float exposure = ComputeReinhardScale(peak, minimum, gray_in, gray_out);
  // return Reinhard(x * exposure, peak, minimum);

  // Micro-optimized version below:

  // (sx + m) / ((sx/p + 1)
  // p(sx + m) / (sx + p)
  // (sxp + pm) / (sx + p)
  // s = (py - pm) / (gp - gy)
  // ((py - pm) / (gp - gy)xp + pm) / ((py - pm) / (gp - gy)x + p)
  // (xp(py - pm) / (gp - gy) + pm) / (x(py - pm) / (gp - gy) + p)
  //
  // Multiple num/den by (gp - gy)
  //
  // (xp(py - pm) + pm(gp-gy)) / (x(py - pm) + p(gp-gy))
  // (xppy - xppm + gppm-gypm) / (xpy - xpm + gpp-gyp)
  //
  // Remove p from all
  // (xpy - xpm + gpm-gym) / (xy - xm + gp-gy)
  // (xp(y - m) + gm(p - y)) / (x(y - m) + g(p - y))
  // (px(y - m) + mg(p - y)) / (x(y - m) + g(p - y))

  // float ysubm = gray_out - minimum;           // y - m
  // float psuby = peak - gray_out;              // p - y
  // float x_ysubm = x * ysubm;                  // x * (y - m)
  // float g_psuby = gray_in * psuby;            // g * (p - y)
  // float m_g_psuby = minimum * g_psuby;        // m * g * (p - y)
  // float num = mad(peak, x_ysubm, m_g_psuby);  // p * (x * (y - m)) + (m * g * (p - y))
  // float den = x_ysubm + g_psuby;              // x * (y - m) + (g * (p - y))
  // return num / den;

  // q = p - m;
  // z = y - m;
  // (sx) / ((sx/q + 1) + m
  // qsx / (sx + q) + m
  // sxq / (sx + q) + m
  // s = (qz) / (gq - gz)
  // (qz / (gq - gz)xq) / ((qz) / (gq - gz)x + q) + m
  // (xq(qz) / (gq - gz)) / (x(qz) / (gq - gz) + q)
  //
  // Multiple num/den by (gq - gz)
  //
  // (xq(qz)) / (x(qz) + q(gq-gz))
  // (xqqz) / (xqz + gqq-gzq)
  //
  // Remove q from all
  // (xqz) / (xz + gq-gz) + m
  // (xqz) / (xz + g(q - z)) + m
  // (xz)q / (xz + g(q - z)) + m

  // \frac{xz\cdot q}{xz+g_{in}\left(q-z\right)}+m

  float z = gray_out - minimum;             // z = y - m
  float q = peak - minimum;                 // q = p - m
  float xz = x * z;                         // x * z
  float num = xz * q;                       // (x * z) * q
  float q_minus_z = q - z;                  // q - z
  float den = mad(gray_in, q_minus_z, xz);  // x * z + g * (q - z)
  return num / den + minimum;               // ((x * z) * q) / (x * z + g * (q - z)) + m
}

float3 ReinhardScalable(float3 x, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float exposure = ComputeReinhardScale(x_max, x_min, gray_in, gray_out);
  return mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);
}

float ReinhardPiecewise(float x, float x_max = 1.f, float shoulder = 0.18f) {
  const float x_min = 0.f;
  float exposure = ComputeReinhardScale(x_max, x_min, shoulder, shoulder);
  float tonemapped = mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);

  return lerp(x, tonemapped, step(shoulder, x));
}

float3 ReinhardPiecewise(float3 x, float x_max = 1.f, float shoulder = 0.18f) {
  const float x_min = 0.f;
  float exposure = ComputeReinhardScale(x_max, x_min, shoulder, shoulder);
  float3 tonemapped = mad(x, exposure, x_min) / mad(x, exposure / x_max, 1.f - x_min);

  return lerp(x, tonemapped, step(shoulder, x));
}

float ComputeReinhardExtendableScale(float clip = 100.f, float peak = 1.f, float minimum = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  // y = (s*x / (s*x/p + 1) * (1 + s*x * (p/(s*c*s*c)))
  // s = (p*c^2*y - (p*x)*x) / (c^2 * (p*x - x*y))
  // s= ((pccy) - (xpxp)) / (ccxp - ccxy)
  // q = p - m
  // z = y - m
  // s= (qccz - xqxq) / (ccxq - ccxz)
  // s= (ccqz - qxqx) / (ccqx - ccxz)
  // s= (cc*qz - (qx*qx)) / ccx(q - z)
  // s= (cc*qz - (qx*qx)) / cc*qx - ccx*z)

  float q = peak - minimum;        // q = p - m
  float z = gray_out - minimum;    // z = y - m
  float cc = clip * clip;          // c * c
  float qz = q * z;                // q * z
  float qx = q * gray_in;          // q * x
  float qxqx = qx * qx;            // q * x * q * x
  float num = mad(cc, qz, -qxqx);  // (c * c * q * z) - (q * x * q * x)
  float ccx = cc * gray_in;        // c * c * x
  float q_minus_z = q - z;         // (q - z)
  float den = ccx * q_minus_z;     // c * c * x * (q - z)

  return num / den;
}

float ReinhardScalableExtended(float x, float white_max = 100.f, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  // float exposure = ComputeReinhardExtendableScale(white_max, x_max, x_min, gray_in, gray_out);
  // float extended = ReinhardExtended(x * exposure, white_max * exposure, x_max);
  // return min(extended, x_max);

  // Micro-optimized version below:

  // y = sx / (sx/(p-m)+1) * (1 + sx * ((p - m)/(sc*sc))) + m
  // q = p - m
  // y = sxq / (sx+q) * (1 + sx * (q/(sc*sc)) + m
  // y = sxq / (sx+q) * (1 + (sxq)/(sc*sc)) + m
  // y = sxq / (sx+q) * (1 + (xq)/(scc)) + m
  // y = sxq * (1 + (xq)/(scc)) / (sx+q) + m
  // y = sxq * (1 + (xq)/(scc))) / (sx+q) + m
  // y = sxq * (1 + (xq)/(scc))) / (sx+q) + m
  // y = sxq * (1 + xq/(scc)) / (sx+q) + m
  // y = sxq * (scc + xq) / (scc * (sx+q)) + m
  // y = (sxq * (scc + xq)) / (scc * (sx+q)) + m
  // y = s*(xq * (scc + xq)) / s(cc * (sx+q)) + m
  // y = (xq * (scc + xq)) / (cc * (sx+q)) + m
  // z = y-m
  // s = ((cc*qz - qg*qg) / (cc*qg - ccg*z))
  // Reshape for easier denominator handling
  // y = (xqscc + xqxq) / (ccsx+ccq) + m
  // y = (sxqcc + xqxq) / (sccx+ccq) + m
  // y = (((cc*qz - qg*qg) / (cc*qg - ccg*z))xqcc + xqxq) / (((cc*qz - qg*qg) / (cc*qg - ccg*z))ccx+ccq) + m
  // Factor (cc*qg - ccg*z)
  // y = (((cc*qz - qg*qg))xqcc + (cc*qg - ccg*z)xqxq) / (((cc*qz - qg*qg))ccx+(cc*qg - ccg*z)ccq) + m
  // y = (ccqx(ccqz - ggqq) + qqxx(ccgq - ccgz)) / (ccx(ccqz - ggqq)+ccq(ccgq - ccgz)) + m
  // y = (ccqqx(ccz - ggq) + ccgqqxx(q - z)) / (ccqx(ccz - ggq)+ccccgq(q - z)) + m
  // y = ccqqx((ccz - ggq) + gx(q - z)) / ccq(x(ccz - ggq)+ccg(q - z)) + m
  // y = qx((ccz - ggq) + gx(q - z)) / (x(ccz - ggq)+ccg(q - z)) + m
  // Expand x for optimization
  // y = q(x(ccz - ggq) + gxx(q - z)) / (x(ccz - ggq)+ccg(q - z)) + m

  // \frac { q\left(x\left(ccz - ggq\right) + gxx\left(q - z\right)\right) } { x\left(ccz - ggq\right) + ccg\left(q - z\right) } + m

  float g = gray_in;
  float c = white_max;

  float q = x_max - x_min;                             // q = p - m
  float z = gray_out - x_min;                          // z = y - m
  float cc = c * c;                                    // c * c
  float gg = g * g;                                    // g * g
  float ggq = gg * q;                                  // g * g * q
  float ccz_minus_ggq = mad(cc, z, -ggq);              // ccz - ggq
  float x_ccz_minus_ggq = x * ccz_minus_ggq;           // x * (ccz - ggq)
  float q_minus_z = q - z;                             // q - z
  float xx = x * x;                                    // x * x
  float gxx = g * xx;                                  // g * x * x
  float num_0 = mad(gxx, q_minus_z, x_ccz_minus_ggq);  // x * (ccz - ggq) + g * x * x * (q - z)
  float num = q * num_0;                               // q * (x * (ccz - ggq) + g * x * x * (q - z))
  float ccg = cc * g;                                  // c * c * g
  float den = mad(ccg, q_minus_z, x_ccz_minus_ggq);    // x * (ccz - ggq) + c * c * g * (q - z)
  return min(num / den + x_min, white_max);
}
float3 ReinhardScalableExtended(float3 x, float white_max = 100.f, float x_max = 1.f, float x_min = 0.f, float gray_in = 0.18f, float gray_out = 0.18f) {
  float exposure = ComputeReinhardExtendableScale(white_max, x_max, x_min, gray_in, gray_out);
  float3 extended = ReinhardExtended(x * exposure, white_max * exposure, x_max);
  return min(extended, x_max);
}

float ReinhardPiecewiseExtended(float x, float white_max, float x_max = 1.f, float shoulder = 0.18f) {
  float extended = ReinhardScalableExtended(x, white_max, x_max, 0.f, shoulder, shoulder);
  return lerp(x, extended, step(shoulder, x));
}

float3 ReinhardPiecewiseExtended(float3 x, float white_max, float x_max = 1.f, float shoulder = 0.18f) {
  float3 extended = ReinhardScalableExtended(x, white_max, x_max, 0.f, shoulder, shoulder);
  return lerp(x, extended, step(shoulder, x));
}

}
}

#endif  // SRC_SHADERS_TONEMAP_HLSL_