#ifndef SRC_GAMES_RDR2VK_CANVAS_GLSL_
#define SRC_GAMES_RDR2VK_CANVAS_GLSL_

const int renodx_canvas_MODE_NORMAL = 0x00;
const int renodx_canvas_MODE_INVERT = 0x01;
const int renodx_canvas_MODE_UNDERLINE = 0x02;
const int renodx_canvas_MODE_BLINVERT = 0x04;
const int renodx_canvas_MODE_BLINK = 0x08;

// Source bitmap size for the built-in 8x12 font. Keep these values integral.
const vec2 renodx_canvas_internal_GLYPH_SIZE = vec2(8.0, 12.0);
const float renodx_canvas_internal_BLINK_RATE = 2.0;

#define RENODX_CANVAS_GLYPH(X, Y, Z, W) uvec4(uint(X), uint(Y), uint(Z), uint(W))

const uvec4 renodx_canvas_internal_GLYPH_MASK =
    RENODX_CANVAS_GLYPH(0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF);

// Forked from Flyguy's 96-bit 8x12 font sheet. Entries cover ASCII 32-126.
const uvec4 renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[95] = uvec4[95](
    RENODX_CANVAS_GLYPH(0x000000, 0x000000, 0x000000, 0x000000),
    RENODX_CANVAS_GLYPH(0x1E0C00, 0x0C1E1E, 0x0C000C, 0x00000C),
    RENODX_CANVAS_GLYPH(0x666600, 0x002466, 0x000000, 0x000000),
    RENODX_CANVAS_GLYPH(0x363600, 0x36367F, 0x367F36, 0x000036),
    RENODX_CANVAS_GLYPH(0x3E0C0C, 0x1E0303, 0x1F3030, 0x000C0C),
    RENODX_CANVAS_GLYPH(0x000000, 0x183323, 0x33060C, 0x000031),
    RENODX_CANVAS_GLYPH(0x1B0E00, 0x5F0E1B, 0x3B337B, 0x00006E),
    RENODX_CANVAS_GLYPH(0x0C0C00, 0x00060C, 0x000000, 0x000000),
    RENODX_CANVAS_GLYPH(0x183000, 0x06060C, 0x180C06, 0x000030),
    RENODX_CANVAS_GLYPH(0x0C0600, 0x303018, 0x0C1830, 0x000006),
    RENODX_CANVAS_GLYPH(0x000000, 0xFF3C66, 0x00663C, 0x000000),
    RENODX_CANVAS_GLYPH(0x000000, 0x7E1818, 0x001818, 0x000000),
    RENODX_CANVAS_GLYPH(0x000000, 0x000000, 0x1C0000, 0x00061C),
    RENODX_CANVAS_GLYPH(0x000000, 0x7F0000, 0x000000, 0x000000),
    RENODX_CANVAS_GLYPH(0x000000, 0x000000, 0x1C0000, 0x00001C),
    RENODX_CANVAS_GLYPH(0x400000, 0x183060, 0x03060C, 0x000001),
    RENODX_CANVAS_GLYPH(0x633E00, 0x6F7B73, 0x636367, 0x00003E),
    RENODX_CANVAS_GLYPH(0x0C0800, 0x0C0C0F, 0x0C0C0C, 0x00003F),
    RENODX_CANVAS_GLYPH(0x331E00, 0x183033, 0x33060C, 0x00003F),
    RENODX_CANVAS_GLYPH(0x331E00, 0x1C3030, 0x333030, 0x00001E),
    RENODX_CANVAS_GLYPH(0x383000, 0x33363C, 0x30307F, 0x000078),
    RENODX_CANVAS_GLYPH(0x033F00, 0x1F0303, 0x333030, 0x00001E),
    RENODX_CANVAS_GLYPH(0x061C00, 0x1F0303, 0x333333, 0x00001E),
    RENODX_CANVAS_GLYPH(0x637F00, 0x306063, 0x0C0C18, 0x00000C),
    RENODX_CANVAS_GLYPH(0x331E00, 0x1E3733, 0x33333B, 0x00001E),
    RENODX_CANVAS_GLYPH(0x331E00, 0x3E3333, 0x0C1818, 0x00000E),
    RENODX_CANVAS_GLYPH(0x000000, 0x001C1C, 0x1C1C00, 0x000000),
    RENODX_CANVAS_GLYPH(0x000000, 0x001C1C, 0x1C1C00, 0x000C18),
    RENODX_CANVAS_GLYPH(0x183000, 0x03060C, 0x180C06, 0x000030),
    RENODX_CANVAS_GLYPH(0x000000, 0x007E00, 0x00007E, 0x000000),
    RENODX_CANVAS_GLYPH(0x0C0600, 0x603018, 0x0C1830, 0x000006),
    RENODX_CANVAS_GLYPH(0x331E00, 0x0C1830, 0x0C000C, 0x00000C),
    RENODX_CANVAS_GLYPH(0x633E00, 0x7B7B63, 0x03037B, 0x00003E),
    RENODX_CANVAS_GLYPH(0x1E0C00, 0x333333, 0x33333F, 0x000033),
    RENODX_CANVAS_GLYPH(0x663F00, 0x3E6666, 0x666666, 0x00003F),
    RENODX_CANVAS_GLYPH(0x663C00, 0x030363, 0x666303, 0x00003C),
    RENODX_CANVAS_GLYPH(0x361F00, 0x666666, 0x366666, 0x00001F),
    RENODX_CANVAS_GLYPH(0x467F00, 0x3E2606, 0x460626, 0x00007F),
    RENODX_CANVAS_GLYPH(0x667F00, 0x3E2646, 0x060626, 0x00000F),
    RENODX_CANVAS_GLYPH(0x663C00, 0x030363, 0x666373, 0x00007C),
    RENODX_CANVAS_GLYPH(0x333300, 0x3F3333, 0x333333, 0x000033),
    RENODX_CANVAS_GLYPH(0x0C1E00, 0x0C0C0C, 0x0C0C0C, 0x00001E),
    RENODX_CANVAS_GLYPH(0x307800, 0x303030, 0x333333, 0x00001E),
    RENODX_CANVAS_GLYPH(0x666700, 0x1E3636, 0x663636, 0x000067),
    RENODX_CANVAS_GLYPH(0x060F00, 0x060606, 0x666646, 0x00007F),
    RENODX_CANVAS_GLYPH(0x776300, 0x6B7F7F, 0x636363, 0x000063),
    RENODX_CANVAS_GLYPH(0x636300, 0x7F6F67, 0x63737B, 0x000063),
    RENODX_CANVAS_GLYPH(0x361C00, 0x636363, 0x366363, 0x00001C),
    RENODX_CANVAS_GLYPH(0x663F00, 0x3E6666, 0x060606, 0x00000F),
    RENODX_CANVAS_GLYPH(0x361C00, 0x636363, 0x3E7B73, 0x007830),
    RENODX_CANVAS_GLYPH(0x663F00, 0x3E6666, 0x666636, 0x000067),
    RENODX_CANVAS_GLYPH(0x331E00, 0x0E0333, 0x333318, 0x00001E),
    RENODX_CANVAS_GLYPH(0x2D3F00, 0x0C0C0C, 0x0C0C0C, 0x00001E),
    RENODX_CANVAS_GLYPH(0x333300, 0x333333, 0x333333, 0x00001E),
    RENODX_CANVAS_GLYPH(0x333300, 0x333333, 0x1E3333, 0x00000C),
    RENODX_CANVAS_GLYPH(0x636300, 0x6B6363, 0x36366B, 0x000036),
    RENODX_CANVAS_GLYPH(0x333300, 0x0C1E33, 0x33331E, 0x000033),
    RENODX_CANVAS_GLYPH(0x333300, 0x1E3333, 0x0C0C0C, 0x00001E),
    RENODX_CANVAS_GLYPH(0x737F00, 0x0C1819, 0x634606, 0x00007F),
    RENODX_CANVAS_GLYPH(0x0C3C00, 0x0C0C0C, 0x0C0C0C, 0x00003C),
    RENODX_CANVAS_GLYPH(0x010000, 0x0C0603, 0x603018, 0x000040),
    RENODX_CANVAS_GLYPH(0x303C00, 0x303030, 0x303030, 0x00003C),
    RENODX_CANVAS_GLYPH(0x361C08, 0x000063, 0x000000, 0x000000),
    RENODX_CANVAS_GLYPH(0x000000, 0x000000, 0x000000, 0x00FF00),
    RENODX_CANVAS_GLYPH(0x0C0600, 0x00180C, 0x000000, 0x000000),
    RENODX_CANVAS_GLYPH(0x000000, 0x301E00, 0x33333E, 0x00006E),
    RENODX_CANVAS_GLYPH(0x060700, 0x663E06, 0x666666, 0x00003B),
    RENODX_CANVAS_GLYPH(0x000000, 0x331E00, 0x330303, 0x00001E),
    RENODX_CANVAS_GLYPH(0x303800, 0x333E30, 0x333333, 0x00006E),
    RENODX_CANVAS_GLYPH(0x000000, 0x331E00, 0x33033F, 0x00001E),
    RENODX_CANVAS_GLYPH(0x361C00, 0x1F0606, 0x060606, 0x00000F),
    RENODX_CANVAS_GLYPH(0x000000, 0x336E00, 0x3E3333, 0x1E3330),
    RENODX_CANVAS_GLYPH(0x060700, 0x6E3606, 0x666666, 0x000067),
    RENODX_CANVAS_GLYPH(0x181800, 0x181E00, 0x181818, 0x00007E),
    RENODX_CANVAS_GLYPH(0x303000, 0x303C00, 0x303030, 0x1E3333),
    RENODX_CANVAS_GLYPH(0x060700, 0x366606, 0x66361E, 0x000067),
    RENODX_CANVAS_GLYPH(0x181E00, 0x181818, 0x181818, 0x00007E),
    RENODX_CANVAS_GLYPH(0x000000, 0x6B3F00, 0x6B6B6B, 0x000063),
    RENODX_CANVAS_GLYPH(0x000000, 0x331F00, 0x333333, 0x000033),
    RENODX_CANVAS_GLYPH(0x000000, 0x331E00, 0x333333, 0x00001E),
    RENODX_CANVAS_GLYPH(0x000000, 0x663B00, 0x666666, 0x0F063E),
    RENODX_CANVAS_GLYPH(0x000000, 0x336E00, 0x333333, 0x78303E),
    RENODX_CANVAS_GLYPH(0x000000, 0x763700, 0x06066E, 0x00000F),
    RENODX_CANVAS_GLYPH(0x000000, 0x331E00, 0x331806, 0x00001E),
    RENODX_CANVAS_GLYPH(0x040000, 0x063F06, 0x360606, 0x00001C),
    RENODX_CANVAS_GLYPH(0x000000, 0x333300, 0x333333, 0x00006E),
    RENODX_CANVAS_GLYPH(0x000000, 0x333300, 0x1E3333, 0x00000C),
    RENODX_CANVAS_GLYPH(0x000000, 0x636300, 0x366B6B, 0x000036),
    RENODX_CANVAS_GLYPH(0x000000, 0x366300, 0x361C1C, 0x000063),
    RENODX_CANVAS_GLYPH(0x000000, 0x666600, 0x3C6666, 0x0F1830),
    RENODX_CANVAS_GLYPH(0x000000, 0x313F00, 0x230618, 0x00003F),
    RENODX_CANVAS_GLYPH(0x0C3800, 0x03060C, 0x0C0C06, 0x000038),
    RENODX_CANVAS_GLYPH(0x181800, 0x001818, 0x181818, 0x000018),
    RENODX_CANVAS_GLYPH(0x0C0700, 0x30180C, 0x0C0C18, 0x000007),
    RENODX_CANVAS_GLYPH(0x5BCE00, 0x000073, 0x000000, 0x000000));

int renodx_canvas_internal_Pow10(float exponent) {
  if (exponent < 1.0) return 1;
  if (exponent < 2.0) return 10;
  if (exponent < 3.0) return 100;
  if (exponent < 4.0) return 1000;
  if (exponent < 5.0) return 10000;
  if (exponent < 6.0) return 100000;
  if (exponent < 7.0) return 1000000;
  if (exponent < 8.0) return 10000000;
  if (exponent < 9.0) return 100000000;
  return 1000000000;
}

float renodx_canvas_internal_Pow10f(float exponent) {
  if (exponent < 1.0) return 1.0;
  if (exponent < 2.0) return 10.0;
  if (exponent < 3.0) return 100.0;
  if (exponent < 4.0) return 1000.0;
  if (exponent < 5.0) return 10000.0;
  if (exponent < 6.0) return 100000.0;
  if (exponent < 7.0) return 1000000.0;
  if (exponent < 8.0) return 10000000.0;
  if (exponent < 9.0) return 100000000.0;
  return 1000000000.0;
}

bool renodx_canvas_internal_TestGlyphPixel(uvec4 glyph, vec2 glyph_uv) {
  vec2 glyph_pixel = floor(glyph_uv);
  if (glyph_pixel.x < 0.0 || glyph_pixel.y < 0.0 || glyph_pixel.x >= 8.0 || glyph_pixel.y >= 12.0) return false;

  float lane_index = floor(glyph_pixel.y / 3.0);
  float row_in_lane = glyph_pixel.y - lane_index * 3.0;
  uint bit_shift = uint(fma(row_in_lane, 8.0, glyph_pixel.x));
  uint glyph_lane = glyph[int(lane_index)];
  return ((glyph_lane >> bit_shift) & 1u) != 0u;
}

bool renodx_canvas_internal_BlinkPhase(float time) {
  return fract(time * (renodx_canvas_internal_BLINK_RATE * 0.5)) < 0.5;
}

uvec4 renodx_canvas_internal_ApplyTextMode(uvec4 glyph, int mode, bool blink_phase) {
  if ((mode & renodx_canvas_MODE_UNDERLINE) != 0) {
    glyph.w = (glyph.w & 0x00FFFF00u) | 0x000000FFu;
  }

  bool invert = (mode & renodx_canvas_MODE_INVERT) != 0;
  if ((mode & renodx_canvas_MODE_BLINVERT) != 0 && blink_phase) {
    invert = !invert;
  }

  if (invert) {
    glyph = glyph ^ renodx_canvas_internal_GLYPH_MASK;
  }
  return glyph;
}

uvec4 renodx_canvas_internal_DigitGlyph(int digit) {
  if (digit >= 0 && digit <= 9) {
    return renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[digit + 16];
  }
  return renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
}

uvec4 renodx_canvas_internal_GlyphFromAscii(int ascii) {
  if (ascii >= 32 && ascii <= 126) {
    return renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[ascii - 32];
  }
  return renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
}

bool renodx_canvas_internal_TestGlyphCoverage(
    vec2 position,
    uvec4 glyph,
    vec2 origin,
    vec2 glyph_size,
    int mode,
    float time) {
  vec2 local = position - origin;
  if (local.x < 0.0 || local.y < 0.0 || local.x >= glyph_size.x || local.y >= glyph_size.y) return false;

  vec2 sprite_uv = local * (renodx_canvas_internal_GLYPH_SIZE / glyph_size);
  if (mode == renodx_canvas_MODE_NORMAL) {
    return renodx_canvas_internal_TestGlyphPixel(glyph, sprite_uv);
  }

  bool uses_blink_phase = (mode & (renodx_canvas_MODE_BLINK | renodx_canvas_MODE_BLINVERT)) != 0;
  bool blink_hidden = (mode & renodx_canvas_MODE_BLINK) != 0;
  bool blink_phase = uses_blink_phase ? renodx_canvas_internal_BlinkPhase(time) : false;
  if (blink_hidden && blink_phase) return false;

  glyph = renodx_canvas_internal_ApplyTextMode(glyph, mode, blink_phase);
  return renodx_canvas_internal_TestGlyphPixel(glyph, sprite_uv);
}

bool renodx_canvas_internal_TestGlyphCoverage(
    vec2 position,
    int ascii,
    vec2 origin,
    vec2 glyph_size,
    int mode,
    float time) {
  return renodx_canvas_internal_TestGlyphCoverage(
      position,
      renodx_canvas_internal_GlyphFromAscii(ascii),
      origin,
      glyph_size,
      mode,
      time);
}

bool renodx_canvas_internal_TestGlyphCoverage(vec2 position, uvec4 glyph, vec2 origin, vec2 glyph_size) {
  return renodx_canvas_internal_TestGlyphCoverage(
      position, glyph, origin, glyph_size, renodx_canvas_MODE_NORMAL, 0.0);
}

bool renodx_canvas_internal_TestGlyphCoverage(vec2 position, int ascii, vec2 origin, vec2 glyph_size) {
  return renodx_canvas_internal_TestGlyphCoverage(
      position, ascii, origin, glyph_size, renodx_canvas_MODE_NORMAL, 0.0);
}

float renodx_canvas_internal_IntegerDigitCount(int value) {
  if (value <= -1000000000 || value >= 1000000000) return 10.0;
  if (value <= -100000000 || value >= 100000000) return 9.0;
  if (value <= -10000000 || value >= 10000000) return 8.0;
  if (value <= -1000000 || value >= 1000000) return 7.0;
  if (value <= -100000 || value >= 100000) return 6.0;
  if (value <= -10000 || value >= 10000) return 5.0;
  if (value <= -1000 || value >= 1000) return 4.0;
  if (value <= -100 || value >= 100) return 3.0;
  if (value <= -10 || value >= 10) return 2.0;
  return 1.0;
}

float renodx_canvas_internal_IntegerDigitCount(float value) {
  if (value <= -1000000000.0 || value >= 1000000000.0) return 10.0;
  if (value <= -100000000.0 || value >= 100000000.0) return 9.0;
  if (value <= -10000000.0 || value >= 10000000.0) return 8.0;
  if (value <= -1000000.0 || value >= 1000000.0) return 7.0;
  if (value <= -100000.0 || value >= 100000.0) return 6.0;
  if (value <= -10000.0 || value >= 10000.0) return 5.0;
  if (value <= -1000.0 || value >= 1000.0) return 4.0;
  if (value <= -100.0 || value >= 100.0) return 3.0;
  if (value <= -10.0 || value >= 10.0) return 2.0;
  return 1.0;
}

float renodx_canvas_internal_IntegerFieldGlyphCount(int value, float max_digits, bool reserve_sign) {
  return max_digits + ((reserve_sign || value < 0) ? 1.0 : 0.0);
}

float renodx_canvas_internal_FloatFieldGlyphCount(float digits, float decimals, bool reserve_sign, bool negative) {
  float count = digits + (decimals > 0.0 ? 1.0 + decimals : 0.0);
  if (reserve_sign || negative) count += 1.0;
  return count;
}

uvec4 renodx_canvas_internal_IntegerGlyphAt(
    float index,
    int value,
    float digits,
    bool leading_zeros,
    bool reserve_sign) {
  bool negative = value < 0;
  float sign_width = (negative || reserve_sign) ? 1.0 : 0.0;
  if (index < sign_width) {
    return negative
               ? renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[13]
               : renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
  }

  float digit_index = index - sign_width;
  int divisor = renodx_canvas_internal_Pow10(digits - 1.0 - digit_index);
  int quotient = value / divisor;
  int digit = quotient % 10;
  if (digit < 0) digit = -digit;

  bool show_digit = leading_zeros || quotient != 0 || digit_index == digits - 1.0;
  return show_digit
             ? renodx_canvas_internal_DigitGlyph(digit)
             : renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
}

uvec4 renodx_canvas_internal_FloatGlyphAt(
    float index,
    float integer_part,
    float fractional_part,
    float digits,
    float frac_digits,
    bool negative,
    bool leading_zeros,
    bool reserve_sign) {
  float sign_width = (negative || reserve_sign) ? 1.0 : 0.0;
  float dot_index = sign_width + digits;
  if (index < sign_width) {
    return negative
               ? renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[13]
               : renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
  }

  if (index < sign_width + digits) {
    float digit_index = index - sign_width;
    int divisor = renodx_canvas_internal_Pow10(digits - 1.0 - digit_index);
    int integer_value = int(integer_part);
    int digit = (integer_value / divisor) % 10;
    bool show_digit = leading_zeros || integer_value >= divisor || digit_index == digits - 1.0;
    return show_digit
               ? renodx_canvas_internal_DigitGlyph(digit)
               : renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
  }

  if (frac_digits > 0.0 && index == dot_index) {
    return renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[14];
  }

  if (frac_digits > 0.0) {
    float frac_index = index - dot_index - 1.0;
    int divisor = renodx_canvas_internal_Pow10(frac_digits - 1.0 - frac_index);
    int fractional_value = int(fractional_part);
    int digit = (fractional_value / divisor) % 10;
    return renodx_canvas_internal_DigitGlyph(digit);
  }
  return renodx_canvas_internal_GLYPHS_PRINTABLE_ASCII[0];
}

float renodx_canvas_internal_TextLength(
    int a, int b, int c, int d,
    int e, int f, int g, int h,
    int i, int j, int k, int l,
    int m, int n, int o, int p) {
  if (a == 0) return 0.0;
  if (b == 0) return 1.0;
  if (c == 0) return 2.0;
  if (d == 0) return 3.0;
  if (e == 0) return 4.0;
  if (f == 0) return 5.0;
  if (g == 0) return 6.0;
  if (h == 0) return 7.0;
  if (i == 0) return 8.0;
  if (j == 0) return 9.0;
  if (k == 0) return 10.0;
  if (l == 0) return 11.0;
  if (m == 0) return 12.0;
  if (n == 0) return 13.0;
  if (o == 0) return 14.0;
  if (p == 0) return 15.0;
  return 16.0;
}

int renodx_canvas_internal_TextAsciiAt(
    float index,
    int a, int b, int c, int d,
    int e, int f, int g, int h,
    int i, int j, int k, int l,
    int m, int n, int o, int p) {
  if (index < 1.0) return a;
  if (index < 2.0) return b;
  if (index < 3.0) return c;
  if (index < 4.0) return d;
  if (index < 5.0) return e;
  if (index < 6.0) return f;
  if (index < 7.0) return g;
  if (index < 8.0) return h;
  if (index < 9.0) return i;
  if (index < 10.0) return j;
  if (index < 11.0) return k;
  if (index < 12.0) return l;
  if (index < 13.0) return m;
  if (index < 14.0) return n;
  if (index < 15.0) return o;
  return p;
}

float renodx_canvas_internal_DecodeSRGB(float value) {
  return value <= 0.04045
             ? value / 12.92
             : pow(fma(value, 1.0 / 1.055, 0.055 / 1.055), 2.4);
}

vec3 renodx_canvas_internal_ColorFromRGB8(int rgb) {
  uint rgb8 = uint(rgb);
  vec3 srgb = vec3(
                  float((rgb8 >> 16u) & 255u),
                  float((rgb8 >> 8u) & 255u),
                  float(rgb8 & 255u))
              * (1.0 / 255.0);
  return vec3(
      renodx_canvas_internal_DecodeSRGB(srgb.r),
      renodx_canvas_internal_DecodeSRGB(srgb.g),
      renodx_canvas_internal_DecodeSRGB(srgb.b));
}

bool renodx_canvas_TestRectCoverage(vec2 position, vec2 min_corner, vec2 max_corner) {
  return position.x >= min_corner.x && position.y >= min_corner.y
         && position.x <= max_corner.x && position.y <= max_corner.y;
}

float renodx_canvas_ComputeRectMask(vec2 position, vec2 min_corner, vec2 max_corner) {
  return renodx_canvas_TestRectCoverage(position, min_corner, max_corner) ? 1.0 : 0.0;
}

struct renodx_canvas_Context {
  vec2 position;
  vec2 origin;
  vec2 cursor;
  vec2 glyph_size;
  float line_height;
  int mode;
  float time;
  vec3 color;
  float alpha_scale;
  float intensity_scale;
  vec3 output_color;
  float output_alpha;
};

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position,
    vec2 origin,
    vec2 glyph_size,
    vec3 output_color,
    float output_alpha,
    vec3 color,
    float alpha_scale,
    float intensity_scale,
    int mode,
    float time,
    float line_height) {
  renodx_canvas_Context context;
  context.position = position;
  context.origin = origin;
  context.cursor = origin;
  context.glyph_size = glyph_size;
  context.line_height = line_height;
  context.mode = mode;
  context.time = time;
  context.color = color;
  context.alpha_scale = alpha_scale;
  context.intensity_scale = intensity_scale;
  context.output_color = output_color;
  context.output_alpha = output_alpha;
  return context;
}

renodx_canvas_Context renodx_canvas_CreateContext() {
  return renodx_canvas_CreateContext(
      vec2(0.0), vec2(0.0), vec2(8.0, 12.0), vec3(0.0), 0.0,
      vec3(1.0), 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(vec2 position) {
  return renodx_canvas_CreateContext(
      position, vec2(0.0), vec2(8.0, 12.0), vec3(0.0), 0.0,
      vec3(1.0), 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(vec2 position, vec2 origin) {
  return renodx_canvas_CreateContext(
      position, origin, vec2(8.0, 12.0), vec3(0.0), 0.0,
      vec3(1.0), 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(vec2 position, vec2 origin, vec2 glyph_size) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, vec3(0.0), 0.0,
      vec3(1.0), 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position, vec2 origin, vec2 glyph_size, vec3 output_color) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, 0.0,
      vec3(1.0), 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position, vec2 origin, vec2 glyph_size, vec3 output_color, float output_alpha) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, output_alpha,
      vec3(1.0), 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position,
    vec2 origin,
    vec2 glyph_size,
    vec3 output_color,
    float output_alpha,
    vec3 color) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, output_alpha,
      color, 1.0, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position,
    vec2 origin,
    vec2 glyph_size,
    vec3 output_color,
    float output_alpha,
    vec3 color,
    float alpha_scale) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, output_alpha,
      color, alpha_scale, 1.0, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position,
    vec2 origin,
    vec2 glyph_size,
    vec3 output_color,
    float output_alpha,
    vec3 color,
    float alpha_scale,
    float intensity_scale) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, output_alpha,
      color, alpha_scale, intensity_scale, renodx_canvas_MODE_NORMAL, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position,
    vec2 origin,
    vec2 glyph_size,
    vec3 output_color,
    float output_alpha,
    vec3 color,
    float alpha_scale,
    float intensity_scale,
    int mode) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, output_alpha,
      color, alpha_scale, intensity_scale, mode, 0.0, 1.0);
}

renodx_canvas_Context renodx_canvas_CreateContext(
    vec2 position,
    vec2 origin,
    vec2 glyph_size,
    vec3 output_color,
    float output_alpha,
    vec3 color,
    float alpha_scale,
    float intensity_scale,
    int mode,
    float time) {
  return renodx_canvas_CreateContext(
      position, origin, glyph_size, output_color, output_alpha,
      color, alpha_scale, intensity_scale, mode, time, 1.0);
}

vec4 renodx_canvas_GetOutput(renodx_canvas_Context context) {
  return vec4(context.output_color, context.output_alpha);
}

void renodx_canvas_SetPosition(inout renodx_canvas_Context context, vec2 position) {
  context.position = position;
}

void renodx_canvas_SetCursor(inout renodx_canvas_Context context, vec2 cursor) {
  context.cursor = cursor;
}

void renodx_canvas_ResetCursor(inout renodx_canvas_Context context) {
  context.cursor = context.origin;
}

void renodx_canvas_AdvanceCursor(inout renodx_canvas_Context context, float glyph_count) {
  context.cursor.x = fma(glyph_count, context.glyph_size.x, context.cursor.x);
}

void renodx_canvas_AdvanceCursor(inout renodx_canvas_Context context) {
  renodx_canvas_AdvanceCursor(context, 1.0);
}

void renodx_canvas_SetLineHeight(inout renodx_canvas_Context context, float line_height) {
  context.line_height = line_height;
}

void renodx_canvas_SetTime(inout renodx_canvas_Context context, float time) {
  context.time = time;
}

void renodx_canvas_InsertSpaces(inout renodx_canvas_Context context, float count) {
  renodx_canvas_AdvanceCursor(context, count);
}

void renodx_canvas_InsertSpaces(inout renodx_canvas_Context context) {
  renodx_canvas_InsertSpaces(context, 1.0);
}

void renodx_canvas_InsertSpace(inout renodx_canvas_Context context) {
  renodx_canvas_InsertSpaces(context, 1.0);
}

void renodx_canvas_NewLine(inout renodx_canvas_Context context, float line_count) {
  context.cursor = vec2(
      context.origin.x,
      fma(line_count * context.line_height, context.glyph_size.y, context.cursor.y));
}

void renodx_canvas_NewLine(inout renodx_canvas_Context context) {
  renodx_canvas_NewLine(context, 1.0);
}

void renodx_canvas_SetMode(inout renodx_canvas_Context context, int mode) {
  context.mode = mode;
}

void renodx_canvas_SetColor(
    inout renodx_canvas_Context context,
    vec3 color,
    float alpha_scale,
    float intensity_scale) {
  context.color = color;
  context.alpha_scale = alpha_scale;
  context.intensity_scale = intensity_scale;
}

void renodx_canvas_SetColor(inout renodx_canvas_Context context, vec3 color, float alpha_scale) {
  renodx_canvas_SetColor(context, color, alpha_scale, 1.0);
}

void renodx_canvas_SetColor(inout renodx_canvas_Context context, vec3 color) {
  renodx_canvas_SetColor(context, color, 1.0, 1.0);
}

// Literal 0xRRGGBB inputs are decoded from sRGB.
void renodx_canvas_SetColor(
    inout renodx_canvas_Context context,
    int srgb,
    float alpha_scale,
    float intensity_scale) {
  renodx_canvas_SetColor(
      context,
      renodx_canvas_internal_ColorFromRGB8(srgb),
      alpha_scale,
      intensity_scale);
}

void renodx_canvas_SetColor(inout renodx_canvas_Context context, int srgb, float alpha_scale) {
  renodx_canvas_SetColor(context, srgb, alpha_scale, 1.0);
}

void renodx_canvas_SetColor(inout renodx_canvas_Context context, int srgb) {
  renodx_canvas_SetColor(context, srgb, 1.0, 1.0);
}

void renodx_canvas_SetAlphaScale(inout renodx_canvas_Context context, float alpha_scale) {
  context.alpha_scale = alpha_scale;
}

void renodx_canvas_SetIntensityScale(inout renodx_canvas_Context context, float intensity_scale) {
  context.intensity_scale = intensity_scale;
}

void renodx_canvas_EnableMode(inout renodx_canvas_Context context, int flag) {
  context.mode |= flag;
}

void renodx_canvas_DisableMode(inout renodx_canvas_Context context, int flag) {
  context.mode &= ~flag;
}

void renodx_canvas_SetUnderline(inout renodx_canvas_Context context, bool enabled) {
  if (enabled) {
    renodx_canvas_EnableMode(context, renodx_canvas_MODE_UNDERLINE);
  } else {
    renodx_canvas_DisableMode(context, renodx_canvas_MODE_UNDERLINE);
  }
}

void renodx_canvas_SetUnderline(inout renodx_canvas_Context context) {
  renodx_canvas_SetUnderline(context, true);
}

void renodx_canvas_RemoveUnderline(inout renodx_canvas_Context context) {
  renodx_canvas_SetUnderline(context, false);
}

void renodx_canvas_SetInvert(inout renodx_canvas_Context context, bool enabled) {
  if (enabled) {
    renodx_canvas_EnableMode(context, renodx_canvas_MODE_INVERT);
  } else {
    renodx_canvas_DisableMode(context, renodx_canvas_MODE_INVERT);
  }
}

void renodx_canvas_SetInvert(inout renodx_canvas_Context context) {
  renodx_canvas_SetInvert(context, true);
}

void renodx_canvas_RemoveInvert(inout renodx_canvas_Context context) {
  renodx_canvas_SetInvert(context, false);
}

void renodx_canvas_SetBlink(inout renodx_canvas_Context context, bool enabled) {
  if (enabled) {
    renodx_canvas_EnableMode(context, renodx_canvas_MODE_BLINK);
  } else {
    renodx_canvas_DisableMode(context, renodx_canvas_MODE_BLINK);
  }
}

void renodx_canvas_SetBlink(inout renodx_canvas_Context context) {
  renodx_canvas_SetBlink(context, true);
}

void renodx_canvas_RemoveBlink(inout renodx_canvas_Context context) {
  renodx_canvas_SetBlink(context, false);
}

void renodx_canvas_SetBlinkInvert(inout renodx_canvas_Context context, bool enabled) {
  if (enabled) {
    renodx_canvas_EnableMode(context, renodx_canvas_MODE_BLINVERT);
  } else {
    renodx_canvas_DisableMode(context, renodx_canvas_MODE_BLINVERT);
  }
}

void renodx_canvas_SetBlinkInvert(inout renodx_canvas_Context context) {
  renodx_canvas_SetBlinkInvert(context, true);
}

void renodx_canvas_RemoveBlinkInvert(inout renodx_canvas_Context context) {
  renodx_canvas_SetBlinkInvert(context, false);
}

void renodx_canvas_CompositeMask(inout renodx_canvas_Context context, float mask) {
  float alpha = clamp(mask * context.intensity_scale, 0.0, 1.0) * context.alpha_scale;
  context.output_color = mix(context.output_color, context.color, alpha);
  context.output_alpha = max(context.output_alpha, alpha);
}

void renodx_canvas_CompositeCoverage(inout renodx_canvas_Context context) {
  float alpha = clamp(context.intensity_scale, 0.0, 1.0) * context.alpha_scale;
  context.output_color = mix(context.output_color, context.color, alpha);
  context.output_alpha = max(context.output_alpha, alpha);
}

void renodx_canvas_DrawGlyph(
    inout renodx_canvas_Context context,
    uvec4 glyph,
    vec2 origin) {
  bool has_coverage = context.mode == renodx_canvas_MODE_NORMAL
                          ? renodx_canvas_internal_TestGlyphCoverage(
                                context.position, glyph, origin, context.glyph_size)
                          : renodx_canvas_internal_TestGlyphCoverage(
                                context.position, glyph, origin, context.glyph_size,
                                context.mode, context.time);
  if (has_coverage) renodx_canvas_CompositeCoverage(context);
}

void renodx_canvas_DrawGlyph(
    inout renodx_canvas_Context context,
    int ascii,
    vec2 origin) {
  bool has_coverage = context.mode == renodx_canvas_MODE_NORMAL
                          ? renodx_canvas_internal_TestGlyphCoverage(
                                context.position, ascii, origin, context.glyph_size)
                          : renodx_canvas_internal_TestGlyphCoverage(
                                context.position, ascii, origin, context.glyph_size,
                                context.mode, context.time);
  if (has_coverage) renodx_canvas_CompositeCoverage(context);
}

void renodx_canvas_FillRect(
    inout renodx_canvas_Context context,
    vec2 min_corner,
    vec2 max_corner) {
  if (renodx_canvas_TestRectCoverage(context.position, min_corner, max_corner)) {
    renodx_canvas_CompositeMask(context, 1.0);
  }
}

void renodx_canvas_internal_DrawTextBody(
    inout renodx_canvas_Context context,
    int count,
    int a, int b, int c, int d,
    int e, int f, int g, int h,
    int i, int j, int k, int l,
    int m, int n, int o, int p) {
  vec2 origin = context.cursor;
  renodx_canvas_AdvanceCursor(context, float(count));

  vec2 local = context.position - origin;
  if (local.x < 0.0 || local.y < 0.0 || local.y >= context.glyph_size.y) return;

  float glyph_index = floor(local.x / context.glyph_size.x);
  if (glyph_index >= float(count)) return;

  int ascii = renodx_canvas_internal_TextAsciiAt(
      glyph_index, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  vec2 glyph_origin = origin + vec2(glyph_index * context.glyph_size.x, 0.0);
  renodx_canvas_DrawGlyph(context, renodx_canvas_internal_GlyphFromAscii(ascii), glyph_origin);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a) {
  renodx_canvas_internal_DrawTextBody(context, 1, a, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b) {
  renodx_canvas_internal_DrawTextBody(context, 2, a, b, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b, int c) {
  renodx_canvas_internal_DrawTextBody(context, 3, a, b, c, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b, int c, int d) {
  renodx_canvas_internal_DrawTextBody(context, 4, a, b, c, d, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b, int c, int d, int e) {
  renodx_canvas_internal_DrawTextBody(context, 5, a, b, c, d, e, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b, int c, int d, int e, int f) {
  renodx_canvas_internal_DrawTextBody(context, 6, a, b, c, d, e, f, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b, int c, int d, int e, int f, int g) {
  renodx_canvas_internal_DrawTextBody(context, 7, a, b, c, d, e, f, g, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(inout renodx_canvas_Context context, int a, int b, int c, int d, int e, int f, int g, int h) {
  renodx_canvas_internal_DrawTextBody(context, 8, a, b, c, d, e, f, g, h, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i) {
  renodx_canvas_internal_DrawTextBody(context, 9, a, b, c, d, e, f, g, h, i, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i, int j) {
  renodx_canvas_internal_DrawTextBody(context, 10, a, b, c, d, e, f, g, h, i, j, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k) {
  renodx_canvas_internal_DrawTextBody(context, 11, a, b, c, d, e, f, g, h, i, j, k, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k, int l) {
  renodx_canvas_internal_DrawTextBody(context, 12, a, b, c, d, e, f, g, h, i, j, k, l, 0, 0, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h,
    int i, int j, int k, int l, int m) {
  renodx_canvas_internal_DrawTextBody(context, 13, a, b, c, d, e, f, g, h, i, j, k, l, m, 0, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g,
    int h, int i, int j, int k, int l, int m, int n) {
  renodx_canvas_internal_DrawTextBody(context, 14, a, b, c, d, e, f, g, h, i, j, k, l, m, n, 0, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h,
    int i, int j, int k, int l, int m, int n, int o) {
  renodx_canvas_internal_DrawTextBody(context, 15, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, 0);
}

void renodx_canvas_DrawText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h,
    int i, int j, int k, int l, int m, int n, int o, int p) {
  renodx_canvas_internal_DrawTextBody(context, 16, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d,
    int e, int f, int g, int h,
    int i, int j, int k, int l,
    int m, int n, int o, int p) {
  float count = renodx_canvas_internal_TextLength(
      a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  if (count <= 0.0) return;

  vec2 origin = context.cursor;
  renodx_canvas_AdvanceCursor(context, count);

  vec2 local = context.position - origin;
  if (local.x < 0.0 || local.y < 0.0 || local.y >= context.glyph_size.y) return;

  float glyph_index = floor(local.x / context.glyph_size.x);
  if (glyph_index >= count) return;

  int ascii = renodx_canvas_internal_TextAsciiAt(
      glyph_index, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  vec2 glyph_origin = origin + vec2(glyph_index * context.glyph_size.x, 0.0);
  renodx_canvas_DrawGlyph(context, ascii, glyph_origin);
}

void renodx_canvas_DrawDynamicText(inout renodx_canvas_Context context, int a) {
  renodx_canvas_DrawDynamicText(context, a, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(inout renodx_canvas_Context context, int a, int b) {
  renodx_canvas_DrawDynamicText(context, a, b, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(inout renodx_canvas_Context context, int a, int b, int c) {
  renodx_canvas_DrawDynamicText(context, a, b, c, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(inout renodx_canvas_Context context, int a, int b, int c, int d) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, 0, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, 0, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, 0, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i, int j) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, 0, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h, int i, int j, int k) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, 0, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f,
    int g, int h, int i, int j, int k, int l) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, 0, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g,
    int h, int i, int j, int k, int l, int m) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, 0, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g,
    int h, int i, int j, int k, int l, int m, int n) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, 0, 0);
}

void renodx_canvas_DrawDynamicText(
    inout renodx_canvas_Context context,
    int a, int b, int c, int d, int e, int f, int g, int h,
    int i, int j, int k, int l, int m, int n, int o) {
  renodx_canvas_DrawDynamicText(context, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, 0);
}

void renodx_canvas_DrawInteger(
    inout renodx_canvas_Context context,
    int value,
    float max_digits,
    bool leading_zeros,
    bool reserve_sign) {
  float digits = max_digits > 0.0
                     ? max_digits
                     : renodx_canvas_internal_IntegerDigitCount(value);
  vec2 origin = context.cursor;
  float total_digits = renodx_canvas_internal_IntegerFieldGlyphCount(
      value, digits, reserve_sign);
  renodx_canvas_AdvanceCursor(context, total_digits);

  vec2 local = context.position - origin;
  if (local.x >= 0.0 && local.y >= 0.0 && local.y < context.glyph_size.y) {
    float glyph_index = floor(local.x / context.glyph_size.x);
    if (glyph_index < total_digits) {
      vec2 glyph_origin = origin + vec2(glyph_index * context.glyph_size.x, 0.0);
      uvec4 glyph = renodx_canvas_internal_IntegerGlyphAt(
          glyph_index, value, digits, leading_zeros, reserve_sign);
      if (any(notEqual(glyph, uvec4(0u)))) {
        renodx_canvas_DrawGlyph(context, glyph, glyph_origin);
      }
    }
  }
}

void renodx_canvas_DrawInteger(inout renodx_canvas_Context context, int value) {
  renodx_canvas_DrawInteger(context, value, 0.0, false, false);
}

void renodx_canvas_DrawInteger(
    inout renodx_canvas_Context context,
    int value,
    float max_digits) {
  renodx_canvas_DrawInteger(context, value, max_digits, false, false);
}

void renodx_canvas_DrawInteger(
    inout renodx_canvas_Context context,
    int value,
    float max_digits,
    bool leading_zeros) {
  renodx_canvas_DrawInteger(context, value, max_digits, leading_zeros, false);
}

void renodx_canvas_DrawFloat(
    inout renodx_canvas_Context context,
    float value,
    float max_digits,
    float decimals,
    bool leading_zeros,
    bool reserve_sign) {
  bool negative = value < 0.0;
  float expected_digits = max_digits > 0.0 ? max_digits : 1.0;

  if (isnan(value)) {
    float total_digits = renodx_canvas_internal_FloatFieldGlyphCount(
        expected_digits, decimals, reserve_sign, false);
    if (total_digits < 3.0) total_digits = 3.0;
    float pad_digits = total_digits - 3.0;
    if (pad_digits > 0.0) {
      if (leading_zeros) {
        renodx_canvas_DrawInteger(context, 0, pad_digits, true);
      } else {
        renodx_canvas_InsertSpaces(context, pad_digits);
      }
    }
    renodx_canvas_DrawText(context, 78, 97, 78);  // NaN
    return;
  }

  if (isinf(value)) {
    float total_digits = renodx_canvas_internal_FloatFieldGlyphCount(
        expected_digits, decimals, reserve_sign, negative);
    float minimum_digits = negative ? 4.0 : 3.0;
    if (total_digits < minimum_digits) total_digits = minimum_digits;

    if (negative) {
      renodx_canvas_DrawText(context, 45);  // '-'
      float pad_digits = total_digits - 4.0;
      if (pad_digits > 0.0) {
        if (leading_zeros) {
          renodx_canvas_DrawInteger(context, 0, pad_digits, true);
        } else {
          renodx_canvas_InsertSpaces(context, pad_digits);
        }
      }
    } else {
      float pad_digits = total_digits - 3.0;
      if (pad_digits > 0.0) {
        if (leading_zeros) {
          renodx_canvas_DrawInteger(context, 0, pad_digits, true);
        } else {
          renodx_canvas_InsertSpaces(context, pad_digits);
        }
      }
    }
    renodx_canvas_DrawText(context, 73, 110, 102);  // Inf
    return;
  }

  float scale = renodx_canvas_internal_Pow10f(decimals);
  float magnitude = negative ? -value : value;
  float integer_part = trunc(magnitude);
  float fractional_part = roundEven(fract(magnitude) * scale);
  if (fractional_part >= scale) {
    integer_part += 1.0;
    fractional_part -= scale;
  }

  float digits = max_digits > 0.0
                     ? max_digits
                     : renodx_canvas_internal_IntegerDigitCount(integer_part);
  vec2 origin = context.cursor;
  float total_digits = renodx_canvas_internal_FloatFieldGlyphCount(
      digits, decimals, reserve_sign, negative);
  renodx_canvas_AdvanceCursor(context, total_digits);

  vec2 local = context.position - origin;
  if (local.x >= 0.0 && local.y >= 0.0 && local.y < context.glyph_size.y) {
    float glyph_index = floor(local.x / context.glyph_size.x);
    if (glyph_index < total_digits) {
      vec2 glyph_origin = origin + vec2(glyph_index * context.glyph_size.x, 0.0);
      uvec4 glyph = renodx_canvas_internal_FloatGlyphAt(
          glyph_index,
          integer_part,
          fractional_part,
          digits,
          decimals,
          negative,
          leading_zeros,
          reserve_sign);
      if (any(notEqual(glyph, uvec4(0u)))) {
        renodx_canvas_DrawGlyph(context, glyph, glyph_origin);
      }
    }
  }
}

void renodx_canvas_DrawFloat(inout renodx_canvas_Context context, float value) {
  renodx_canvas_DrawFloat(context, value, 0.0, 2.0, false, false);
}

void renodx_canvas_DrawFloat(
    inout renodx_canvas_Context context,
    float value,
    float max_digits) {
  renodx_canvas_DrawFloat(context, value, max_digits, 2.0, false, false);
}

void renodx_canvas_DrawFloat(
    inout renodx_canvas_Context context,
    float value,
    float max_digits,
    float decimals) {
  renodx_canvas_DrawFloat(context, value, max_digits, decimals, false, false);
}

void renodx_canvas_DrawFloat(
    inout renodx_canvas_Context context,
    float value,
    float max_digits,
    float decimals,
    bool leading_zeros) {
  renodx_canvas_DrawFloat(context, value, max_digits, decimals, leading_zeros, false);
}

#undef RENODX_CANVAS_GLYPH

#endif  // SRC_GAMES_RDR2VK_CANVAS_GLSL_
