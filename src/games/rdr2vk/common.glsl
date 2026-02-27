#include "./macleod_boynton.glsl"
#include "./shared.h"


// START INCLUDES

// --- sRGB ENCODING ---
float EncodeSRGB(float x) {
  return mix(
      x * 12.92,
      1.055 * pow(x, 1.0 / 2.4) - 0.055,
      step(0.0031308, x));
}

vec3 EncodeSRGB(vec3 x) {
  return mix(
      x * 12.92,
      1.055 * pow(x, vec3(1.0 / 2.4)) - 0.055,
      step(vec3(0.0031308), x));
}

// --- sRGB DECODING ---
float DecodeSRGB(float x) {
  return mix(
      x / 12.92,
      pow((x + 0.055) / 1.055, 2.4),
      step(0.04045, x));
}

vec3 DecodeSRGB(vec3 x) {
  return mix(
      x / 12.92,
      pow((x + 0.055) / 1.055, vec3(2.4)),
      step(vec3(0.04045), x));
}

// --- GAMMA ENCODING ---
float EncodeGamma(float x, float gamma) {
  return pow(x, 1.0 / gamma);
}

vec3 EncodeGamma(vec3 x, float gamma) {
  return pow(x, vec3(1.0 / gamma));
}

// --- GAMMA DECODING ---
float DecodeGamma(float x, float gamma) {
  return pow(x, gamma);
}

vec3 DecodeGamma(vec3 x, float gamma) {
  return pow(x, vec3(gamma));
}

// Fix or undo gamma mismatch by converting between sRGB and gamma 2.2
float CorrectGammaMismatch(float x, bool inverse) {
  return inverse
             ? DecodeSRGB(EncodeGamma(x, 2.2))   // undo fix
             : DecodeGamma(EncodeSRGB(x), 2.2);  // apply fix
}

vec3 CorrectGammaMismatch(vec3 x, bool inverse) {
  vec3 s = sign(x);
  vec3 a = abs(x);

  vec3 result = inverse
                    ? DecodeSRGB(EncodeGamma(a, 2.2))
                    : DecodeGamma(EncodeSRGB(a), 2.2);

  return s * result;
}

const mat3 BT709_TO_BT2020_MAT = mat3(
    vec3(0.6274039149284363, 0.06909728795289993, 0.0163914393633604),
    vec3(0.3292830288410187, 0.9195404052734375, 0.08801330626010895),
    vec3(0.04331306740641594, 0.01136231515556574, 0.8955952525138855));

const mat3 BT2020_TO_BT709_MAT = mat3(
    vec3(1.6604909896850586, -0.12455047667026520, -0.01815076358616352),
    vec3(-0.5876411199569702, 1.1328998804092407, -0.10057889670133591),
    vec3(-0.07284986227750778, -0.00834942236542702, 1.1187297105789185));

vec3 BT2020FromBT709(vec3 bt709) {
  return BT709_TO_BT2020_MAT * bt709;
}

vec3 BT709FromBT2020(vec3 bt2020) {
  return BT2020_TO_BT709_MAT * bt2020;
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
vec3 EncodePQ(vec3 color) {
  return EncodePQ(color, 10000.f);
}

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
vec3 DecodePQ(vec3 color) {
  return DecodePQ(color, 10000.f);
}

// Safe divide (float & vec2 versions)
float DivideSafe(float a, float b, float fallback) {
  return (b == 0.0) ? fallback : a / b;
}
float DivideSafe(float a, float b) {
  return DivideSafe(a, b, 3.4028235e38);
}
vec2 DivideSafe(vec2 a, vec2 b, vec2 fallback) {
  return vec2(DivideSafe(a.x, b.x, fallback.x), DivideSafe(a.y, b.y, fallback.y));
}
vec2 DivideSafe(vec2 a, vec2 b) {
  return DivideSafe(a, b, vec2(3.4028235e38));
}

// END INCLUDES
