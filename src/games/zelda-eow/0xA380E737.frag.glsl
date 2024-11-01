// Tonemapper

#version 450

layout(set = 0, binding = 0, std140) uniform support_buffer {
  uint _m0;
  uint _m1[8];
  vec4 _m2;
  vec4 _m3;
  int _m4;
  float _m5[73];
  ivec4 _m6;
  int _m7;
}
support_buffer_1;

layout(set = 0, binding = 22, std140) uniform fp_c3 { vec4 _m0[4096]; }
fp_c3_1;

layout(set = 0, binding = 25, std140) uniform fp_c6 { vec4 _m0[4096]; }
fp_c6_1;

layout(set = 0, binding = 24, std140) uniform fp_c5 { vec4 _m0[4096]; }
fp_c5_1;

layout(set = 0, binding = 20, std140) uniform fp_c1 { vec4 _m0[4096]; }
fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 _33;
layout(location = 0) out vec4 _36;

vec3 ReinhardScalable(vec3 color, vec3 channel_max, vec3 channel_min,
                      vec3 gray_in, vec3 gray_out) {
  vec3 exposure =
      (channel_max * (channel_min * gray_out + channel_min - gray_out)) /
      (gray_in * (gray_out - channel_max));
  return fma(color.rgb, exposure, channel_min) /
         fma(color, exposure / channel_max, 1.f - channel_min);
}

const mat3 BT709_TO_XYZ_MAT = mat3(0.4123907993f, 0.3575843394f, 0.1804807884f,
                                   0.2126390059f, 0.7151686788f, 0.0721923154f,
                                   0.0193308187f, 0.1191947798f, 0.9505321522f);

const mat3 XYZ_TO_BT709_MAT = mat3(
    3.2409699419f, -1.5373831776f, -0.4986107603f, -0.9692436363f,
    1.8759675015f, 0.0415550574f, 0.0556300797f, -0.2039769589f, 1.0569715142f);

const mat3 XYZ_TO_LMS_MAT =
    mat3(0.3592832590121217f, 0.6976051147779502f, -0.0358915932320290f,
         -0.1920808463704993f, 1.1004767970374321f, 0.0753748658519118f,
         0.0070797844607479f, 0.0748396662186362f, 0.8433265453898765f);

const mat3 LMS_TO_XYZ_MAT =
    mat3(2.07018005669561320, -1.32645687610302100, 0.206616006847855170,
         0.36498825003265756, 0.68046736285223520, -0.045421753075853236,
         -0.04959554223893212, -0.04942116118675749, 1.187995941732803400);

const float PEAK_NITS = 800.f;
const float GAME_NITS = 203.f;
const float UI_NITS = 203.f;

float HejlDawsonCustom(float color, float a, float b) {
  color = max(0, color - 0.004f);
  color = (color * (a * color + 0.5f)) / (color * (a * color + 1.7f) + b);
  return pow(color, 2.2f);
}

float HejlDawson(float color, float a, float b) {
  return HejlDawsonCustom(color, 6.2f, 0.06f);
}

vec3 EncodePQ(vec3 color, float scaling) {
  float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  float C1 = 3424.f / 4096.f;            // 0.8359375f;
  float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;
  color *= (scaling / 10000.f);
  vec3 y_m1 = pow(color, vec3(M1));
  return pow((vec3(C1) + vec3(C2) * y_m1) / (1.f + vec3(C3) * y_m1), vec3(M2));
}
vec3 EncodePQ(vec3 color) { return EncodePQ(color, 10000.f); }

vec3 DecodePQ(vec3 in_color, float scaling) {
  float M1 = 2610.f / 16384.f;           // 0.1593017578125f;
  float M2 = 128.f * (2523.f / 4096.f);  // 78.84375f;
  float C1 = 3424.f / 4096.f;            // 0.8359375f;
  float C2 = 32.f * (2413.f / 4096.f);   // 18.8515625f;
  float C3 = 32.f * (2392.f / 4096.f);   // 18.6875f;

  vec3 e_m12 = pow(in_color, 1.f / vec3(M2));
  vec3 out_color = pow(max(e_m12 - vec3(C1), 0) / (vec3(C2) - vec3(C3) * e_m12),
                       1.f / vec3(M1));
  return out_color * (10000.f / scaling);
}
vec3 DecodePQ(vec3 color) { return DecodePQ(color, 10000.f); }

vec3 IctcpFromBT709(vec3 bt709_color) {
  vec3 xyz_color = bt709_color * BT709_TO_XYZ_MAT;
  vec3 lms_color = xyz_color * XYZ_TO_LMS_MAT;

  mat3 mat = mat3(0.5000, 0.5000, 0.0000, 1.6137, -3.3234, 1.7097, 4.3780,
                  -4.2455, -0.1325);

  return EncodePQ(lms_color, 100.0f) * mat;
}

vec3 BT709FromICtCp(vec3 col) {
  mat3 mat = mat3(1.0, 0.00860514569398152, 0.11103560447547328, 1.0,
                  -0.00860514569398152, -0.11103560447547328, 1.0,
                  0.56004885956263900, -0.32063747023212210);
  col = col * mat;

  // 1.0f = 100 nits, 100.0f = 10k nits
  col = DecodePQ(col, 100.f);
  col = col * LMS_TO_XYZ_MAT;
  return col * XYZ_TO_BT709_MAT;
}

float EncodeSRGB(float channel) {
  return (channel <= 0.0031308f) ? (channel * 12.92f)
                                 : (1.055f * pow(channel, 1.f / 2.4f) - 0.055f);
}

float DecodeSRGB(float channel) {
  return (channel <= 0.04045f) ? (channel / 12.92f)
                               : pow((channel + 0.055f) / 1.055f, 2.4f);
}

vec3 renodrt(vec3 bt709, float nits_peak, float mid_gray_value,
             float mid_gray_nits, float exposure, float highlights,
             float shadows, float contrast, float saturation, float dechroma,
             float flare, float hue_correction_strength,
             vec3 hue_correction_source) {
  const float n_r = 100.f;
  float n = 1000.f;

  // drt cam
  // n_r = 100
  // g = 1.15
  // c = 0.18
  // c_d = 10.013
  // w_g = 0.14
  // t_1 = 0.04
  // r_hit_min = 128
  // r_hit_max = 896

  float g = 1.1;            // gamma/contrast
  float c = 0.18;           // scene-referred gray
  float c_d = 10.013;       // output gray in nits
  const float w_g = 0.00f;  // gray change
  float t_1 = 0.01;         // shadow toe
  const float r_hit_min = 128;
  const float r_hit_max = 256;

  g = contrast;
  c = mid_gray_value;
  c_d = mid_gray_nits;
  n = nits_peak;
  t_1 = flare;

  vec3 signs = sign(bt709);

  bt709 = abs(bt709);

  float y_original =
      dot(bt709, vec3(0.2126390059f, 0.7151686788f, 0.0721923154f));

  vec3 perceptual_old = IctcpFromBT709(hue_correction_source);

  float y = y_original * exposure;

  float y_normalized = y / 0.18f;

  float y_highlighted = pow(y_normalized, highlights);
  y_highlighted = mix(y_normalized, y_highlighted, clamp(y_normalized, 0, 1.f));

  float y_shadowed = pow(y_highlighted, -1.f * (shadows - 2.f));
  y_shadowed = mix(y_shadowed, y_highlighted, clamp(y_highlighted, 0, 1.f));
  y_shadowed *= 0.18f;
  y = y_shadowed;

  float m_0 = (n / n_r);
  float ts;
  float m_1 = 0.5 * (m_0 + sqrt(m_0 * (m_0 + (4.0 * t_1))));
  float r_hit =
      r_hit_min + ((r_hit_max - r_hit_min) * (log(m_0) / log(10000.0 / 100.0)));

  float u = pow((r_hit / m_1) / ((r_hit / m_1) + 1.0), g);
  const float m = m_1 / u;
  const float w_i = log(n / 100.0) / log(2.0);
  const float c_t = (c_d / n_r) * (1.0 + (w_i * w_g));
  const float g_ip = 0.5 * (c_t + sqrt(c_t * (c_t + (4.0 * t_1))));
  const float g_ipp2 =
      -m_1 * pow(g_ip / m, 1.0 / g) / (pow(g_ip / m, 1.0 / g) - 1.0);
  const float w_2 = c / g_ipp2;
  const float s_2 = w_2 * m_1;
  float u_2 = pow((r_hit / m_1) / ((r_hit / m_1) + w_2), g);
  float m_2 = m_1 / u_2;

  ts = pow(max(0, y) / (y + s_2), g) * m_2;

  float flared = max(0, (ts * ts) / (ts + t_1));

  float y_new = clamp(flared, 0, m_0);

  vec3 color_output =
      signs * bt709 * (y_original > 0 ? (y_new / y_original) : 0);
  vec3 color = color_output;

  if (dechroma != 0.f || saturation != 1.f || hue_correction_strength != 0.f) {
    vec3 perceptual_new = IctcpFromBT709(color_output);

    if (hue_correction_strength != 0.f) {
      // Save chrominance to apply black
      float chrominance_pre_adjust = distance(perceptual_new.yz, vec2(0));

      perceptual_new.yz =
          mix(perceptual_new.yz, perceptual_old.yz, hue_correction_strength);

      float chrominance_post_adjust = distance(perceptual_new.yz, vec2(0));

      // Apply back previous chrominance
      if (chrominance_post_adjust != 0.f) {
        perceptual_new.yz *= chrominance_pre_adjust / chrominance_post_adjust;
      }
    }

    if (dechroma != 0.f) {
      perceptual_new.yz *= mix(
          1.f, 0.f,
          clamp(pow(y_original / (10000.f / 100.f), (1.f - dechroma)), 0, 1.f));
    }

    perceptual_new.yz *= saturation;

    color = BT709FromICtCp(perceptual_new);

    // color = renodx::color::bt709::clamp::AP1(color);
    color = min(vec3(m_0), color);  // Clamp to Peak
  }

  return color;
}

void main() {
  float _43 = _33.x;
  float _45 = _33.y;
  vec4 _48 = textureLodOffset(fp_t_tcb_8, vec2(_43, _45), 0.0, ivec2(0)).xyzw;
  float _50 = _48.x;
  float _52 = _48.y;
  float _54 = _48.z;
  float _56 = _48.w;
  precise float _217 = 1.0 / fp_c3_1._m0[0].z;
  float _58 = _217;
  float _60 = -fp_c3_1._m0[0].x;
  precise float _223 = _43 + _60;
  float _62 = _223;
  precise float _227 = 1.0 / fp_c3_1._m0[0].w;
  float _64 = _227;
  float _66 = -fp_c3_1._m0[0].y;
  precise float _233 = _45 + _66;
  float _68 = _233;
  float _70 = fma(_62, _58, fp_c6_1._m0[1].x);
  float _72 = fma(_68, _64, fp_c6_1._m0[1].y);
  precise float _247 = _70 + (-0.5);
  float _74 = _247;
  precise float _249 = _72 + (-0.5);
  float _76 = _249;
  precise float _252 = _74 * _74;
  float _78 = _252;
  precise float _256 = _76 * fp_c6_1._m0[0].w;
  float _80 = _256;
  float _82 = fma(_80, _80, _78);
  float _84 = -fp_c6_1._m0[0].x;
  float _86 = fma(_82, _84, fp_c6_1._m0[0].x);
  float _88 = clamp(_86, 0.0, 1.0);
  float _90 = log2(_88);
  precise float _276 = _90 * fp_c6_1._m0[0].y;
  float _92 = _276;
  float _94 = exp2(_92);
  precise float _282 = _94 + fp_c6_1._m0[0].z;
  float _96 = _282;
  float _98 = clamp(_96, 0.0, 1.0);
  precise float _287 = _98 * _50;
  float _100 = _287;
  precise float _290 = _98 * _52;
  float _102 = _290;
  precise float _293 = _98 * _54;
  float _104 = _293;
  float _106 = fma(_100, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _108 = fma(_102, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _110 = fma(_104, fp_c5_1._m0[0].x, -0.0040000001899898052215576171875);
  float _112 = max(0.0, _106);
  float _114 = max(0.0, _110);
  float _116 = max(0.0, _108);
  float _118 = fma(_112, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _120 = fma(_114, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _122 = fma(_114, fp_c1_1._m0[0].x, 0.5);
  float _124 = fma(_116, fp_c1_1._m0[0].x, 1.7000000476837158203125);
  float _126 = fma(_112, fp_c1_1._m0[0].x, 0.5);
  float _128 = fma(_112, _118, fp_c1_1._m0[0].y);
  float _130 = fma(_116, fp_c1_1._m0[0].x, 0.5);
  float _132 = fma(_114, _120, fp_c1_1._m0[0].y);
  precise float _350 = 1.0 / _128;
  float _134 = _350;
  precise float _353 = _114 * _122;
  float _136 = _353;
  float _138 = fma(_116, _124, fp_c1_1._m0[0].y);
  precise float _360 = 1.0 / _132;
  float _140 = _360;
  precise float _363 = _112 * _126;
  float _142 = _363;
  precise float _365 = 1.0 / _138;
  float _144 = _365;
  precise float _368 = _116 * _130;
  float _146 = _368;
  precise float _371 = _142 * _134;
  float _148 = _371;
  precise float _374 = _136 * _140;
  float _150 = _374;
  float _152 = abs(_148);
  float _154 = log2(_152);
  precise float _381 = _146 * _144;
  float _156 = _381;
  float _158 = abs(_150);
  float _160 = log2(_158);
  float _162 = abs(_156);
  float _164 = log2(_162);
  precise float _392 = _154 * 2.2000000476837158203125;
  float _166 = _392;
  precise float _394 = _160 * 2.2000000476837158203125;
  float _168 = _394;
  precise float _397 = _98 * _56;
  float _170 = _397;
  precise float _399 = _164 * 2.2000000476837158203125;
  float _172 = _399;
  float _174 = exp2(_166);
  float _176 = clamp(_174, 0.0, 1.0);
  precise float _407 = _170 * fp_c5_1._m0[0].x;
  float _178 = _407;
  float _180 = exp2(_168);
  float _182 = clamp(_180, 0.0, 1.0);
  float _184 = exp2(_172);
  float _186 = clamp(_184, 0.0, 1.0);
  _36.x = _176;
  _36.y = _186;
  _36.z = _182;
  _36.w = _178;

  vec3 untonemapped = vec3(_100, _102, _104);
  float vanilla_mid_gray =
      HejlDawsonCustom(0.18f, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y);  // 0.225f
  untonemapped *= fp_c5_1._m0[0].x;  // 2x exposure
  vec3 vanilla =
      vec3(HejlDawsonCustom(_36.r, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y),
           HejlDawsonCustom(_36.g, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y),
           HejlDawsonCustom(_36.b, fp_c1_1._m0[0].x, fp_c1_1._m0[0].y));

  float peak = PEAK_NITS / GAME_NITS;
  peak = DecodeSRGB(pow(peak, 1.f / 2.2f));

  _36.rgb = renodrt(untonemapped, peak * 100.f, 0.18f, vanilla_mid_gray * 100.f,
                    1.0f,  // float exposure,
                    1.0f,  // float highlights,
                    1.1f,  // float shadows,
                    1.2f,  // float contrast,
                    1.6f,  // float saturation,
                    0.8,   // float dechroma,
                    0.25,  // float flare,
                    0.5f,  // float hue_correction_strength,
                    vanilla.rgb);
  // _36.rgb = vec3(vanilla_mid_gray * 1.f / 80.f);
  // _36.rgb = ReinhardScalable(_36.rgb, (800.f / 203.f).xxx, (0).xxx,
  // (0.18f).xxx, (0.18f).xxx); _36.w = 0;
}
