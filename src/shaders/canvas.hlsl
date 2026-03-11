#ifndef SRC_SHADERS_CANVAS_HLSL_
#define SRC_SHADERS_CANVAS_HLSL_

namespace renodx {
namespace canvas {

static const int MODE_NORMAL = 0x00;
static const int MODE_INVERT = 0x01;
static const int MODE_UNDERLINE = 0x02;
static const int MODE_BLINVERT = 0x04;
static const int MODE_BLINK = 0x08;

// Internal raster/layout helpers. Only the Context-based API below is intended
// for external use.
namespace internal {

// Source bitmap size for the built-in 8x12 font. Keep these values integral.
static const float2 GLYPH_SIZE = float2(8.0f, 12.0f);

#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
#define CANVAS_GLYPH4                   uint4
#define CANVAS_GLYPH_SCALAR             uint
#define CANVAS_GLYPH4_CONST(X, Y, Z, W) uint4(X##u, Y##u, Z##u, W##u)
#else
#define CANVAS_GLYPH4                   float4
#define CANVAS_GLYPH_SCALAR             float
#define CANVAS_GLYPH4_CONST(X, Y, Z, W) float4(X, Y, Z, W)
#endif

// Forked from Flyguy's 96-bit 8x12 font sheet.
static const float BLINK_RATE = 2.0f;
static const CANVAS_GLYPH4 GLYPH_MASK = CANVAS_GLYPH4_CONST(0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF, 0x00FFFFFF);

static const CANVAS_GLYPH4 GLYPH_SPACE = CANVAS_GLYPH4_CONST(0x000000, 0x000000, 0x000000, 0x000000);
static const CANVAS_GLYPH4 GLYPH_EXCLAMATION = CANVAS_GLYPH4_CONST(0x1E0C00, 0x0C1E1E, 0x0C000C, 0x00000C);
static const CANVAS_GLYPH4 GLYPH_QUOTE = CANVAS_GLYPH4_CONST(0x666600, 0x002466, 0x000000, 0x000000);
static const CANVAS_GLYPH4 GLYPH_HASH = CANVAS_GLYPH4_CONST(0x363600, 0x36367F, 0x367F36, 0x000036);
static const CANVAS_GLYPH4 GLYPH_DOLLAR = CANVAS_GLYPH4_CONST(0x3E0C0C, 0x1E0303, 0x1F3030, 0x000C0C);
static const CANVAS_GLYPH4 GLYPH_PERCENT = CANVAS_GLYPH4_CONST(0x000000, 0x183323, 0x33060C, 0x000031);
static const CANVAS_GLYPH4 GLYPH_AMPERSAND = CANVAS_GLYPH4_CONST(0x1B0E00, 0x5F0E1B, 0x3B337B, 0x00006E);
static const CANVAS_GLYPH4 GLYPH_APOSTROPHE = CANVAS_GLYPH4_CONST(0x0C0C00, 0x00060C, 0x000000, 0x000000);
static const CANVAS_GLYPH4 GLYPH_LEFT_PAREN = CANVAS_GLYPH4_CONST(0x183000, 0x06060C, 0x180C06, 0x000030);
static const CANVAS_GLYPH4 GLYPH_RIGHT_PAREN = CANVAS_GLYPH4_CONST(0x0C0600, 0x303018, 0x0C1830, 0x000006);
static const CANVAS_GLYPH4 GLYPH_ASTERISK = CANVAS_GLYPH4_CONST(0x000000, 0xFF3C66, 0x00663C, 0x000000);
static const CANVAS_GLYPH4 GLYPH_PLUS = CANVAS_GLYPH4_CONST(0x000000, 0x7E1818, 0x001818, 0x000000);
static const CANVAS_GLYPH4 GLYPH_COMMA = CANVAS_GLYPH4_CONST(0x000000, 0x000000, 0x1C0000, 0x00061C);
static const CANVAS_GLYPH4 GLYPH_DASH = CANVAS_GLYPH4_CONST(0x000000, 0x7F0000, 0x000000, 0x000000);
static const CANVAS_GLYPH4 GLYPH_DOT = CANVAS_GLYPH4_CONST(0x000000, 0x000000, 0x1C0000, 0x00001C);
static const CANVAS_GLYPH4 GLYPH_SLASH = CANVAS_GLYPH4_CONST(0x400000, 0x183060, 0x03060C, 0x000001);

// Zero uses the diagonal slash variant for readability in debug overlays.
static const CANVAS_GLYPH4 GLYPH_0 = CANVAS_GLYPH4_CONST(0x633E00, 0x6F7B73, 0x636367, 0x00003E);
static const CANVAS_GLYPH4 GLYPH_1 = CANVAS_GLYPH4_CONST(0x0C0800, 0x0C0C0F, 0x0C0C0C, 0x00003F);
static const CANVAS_GLYPH4 GLYPH_2 = CANVAS_GLYPH4_CONST(0x331E00, 0x183033, 0x33060C, 0x00003F);
static const CANVAS_GLYPH4 GLYPH_3 = CANVAS_GLYPH4_CONST(0x331E00, 0x1C3030, 0x333030, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_4 = CANVAS_GLYPH4_CONST(0x383000, 0x33363C, 0x30307F, 0x000078);
static const CANVAS_GLYPH4 GLYPH_5 = CANVAS_GLYPH4_CONST(0x033F00, 0x1F0303, 0x333030, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_6 = CANVAS_GLYPH4_CONST(0x061C00, 0x1F0303, 0x333333, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_7 = CANVAS_GLYPH4_CONST(0x637F00, 0x306063, 0x0C0C18, 0x00000C);
static const CANVAS_GLYPH4 GLYPH_8 = CANVAS_GLYPH4_CONST(0x331E00, 0x1E3733, 0x33333B, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_9 = CANVAS_GLYPH4_CONST(0x331E00, 0x3E3333, 0x0C1818, 0x00000E);

static const CANVAS_GLYPH4 GLYPH_COLON = CANVAS_GLYPH4_CONST(0x000000, 0x001C1C, 0x1C1C00, 0x000000);
static const CANVAS_GLYPH4 GLYPH_SEMICOLON = CANVAS_GLYPH4_CONST(0x000000, 0x001C1C, 0x1C1C00, 0x000C18);
static const CANVAS_GLYPH4 GLYPH_LESS_THAN = CANVAS_GLYPH4_CONST(0x183000, 0x03060C, 0x180C06, 0x000030);
static const CANVAS_GLYPH4 GLYPH_EQUALS = CANVAS_GLYPH4_CONST(0x000000, 0x007E00, 0x00007E, 0x000000);
static const CANVAS_GLYPH4 GLYPH_GREATER_THAN = CANVAS_GLYPH4_CONST(0x0C0600, 0x603018, 0x0C1830, 0x000006);
static const CANVAS_GLYPH4 GLYPH_QUESTION = CANVAS_GLYPH4_CONST(0x331E00, 0x0C1830, 0x0C000C, 0x00000C);
static const CANVAS_GLYPH4 GLYPH_AT = CANVAS_GLYPH4_CONST(0x633E00, 0x7B7B63, 0x03037B, 0x00003E);

static const CANVAS_GLYPH4 GLYPH_A = CANVAS_GLYPH4_CONST(0x1E0C00, 0x333333, 0x33333F, 0x000033);
static const CANVAS_GLYPH4 GLYPH_B = CANVAS_GLYPH4_CONST(0x663F00, 0x3E6666, 0x666666, 0x00003F);
static const CANVAS_GLYPH4 GLYPH_C = CANVAS_GLYPH4_CONST(0x663C00, 0x030363, 0x666303, 0x00003C);
static const CANVAS_GLYPH4 GLYPH_D = CANVAS_GLYPH4_CONST(0x361F00, 0x666666, 0x366666, 0x00001F);
static const CANVAS_GLYPH4 GLYPH_E = CANVAS_GLYPH4_CONST(0x467F00, 0x3E2606, 0x460626, 0x00007F);
static const CANVAS_GLYPH4 GLYPH_F = CANVAS_GLYPH4_CONST(0x667F00, 0x3E2646, 0x060626, 0x00000F);
static const CANVAS_GLYPH4 GLYPH_G = CANVAS_GLYPH4_CONST(0x663C00, 0x030363, 0x666373, 0x00007C);
static const CANVAS_GLYPH4 GLYPH_H = CANVAS_GLYPH4_CONST(0x333300, 0x3F3333, 0x333333, 0x000033);
static const CANVAS_GLYPH4 GLYPH_I = CANVAS_GLYPH4_CONST(0x0C1E00, 0x0C0C0C, 0x0C0C0C, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_J = CANVAS_GLYPH4_CONST(0x307800, 0x303030, 0x333333, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_K = CANVAS_GLYPH4_CONST(0x666700, 0x1E3636, 0x663636, 0x000067);
static const CANVAS_GLYPH4 GLYPH_L = CANVAS_GLYPH4_CONST(0x060F00, 0x060606, 0x666646, 0x00007F);
static const CANVAS_GLYPH4 GLYPH_M = CANVAS_GLYPH4_CONST(0x776300, 0x6B7F7F, 0x636363, 0x000063);
static const CANVAS_GLYPH4 GLYPH_N = CANVAS_GLYPH4_CONST(0x636300, 0x7F6F67, 0x63737B, 0x000063);
static const CANVAS_GLYPH4 GLYPH_O = CANVAS_GLYPH4_CONST(0x361C00, 0x636363, 0x366363, 0x00001C);
static const CANVAS_GLYPH4 GLYPH_P = CANVAS_GLYPH4_CONST(0x663F00, 0x3E6666, 0x060606, 0x00000F);
static const CANVAS_GLYPH4 GLYPH_Q = CANVAS_GLYPH4_CONST(0x361C00, 0x636363, 0x3E7B73, 0x007830);
static const CANVAS_GLYPH4 GLYPH_R = CANVAS_GLYPH4_CONST(0x663F00, 0x3E6666, 0x666636, 0x000067);
static const CANVAS_GLYPH4 GLYPH_S = CANVAS_GLYPH4_CONST(0x331E00, 0x0E0333, 0x333318, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_T = CANVAS_GLYPH4_CONST(0x2D3F00, 0x0C0C0C, 0x0C0C0C, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_U = CANVAS_GLYPH4_CONST(0x333300, 0x333333, 0x333333, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_V = CANVAS_GLYPH4_CONST(0x333300, 0x333333, 0x1E3333, 0x00000C);
static const CANVAS_GLYPH4 GLYPH_W = CANVAS_GLYPH4_CONST(0x636300, 0x6B6363, 0x36366B, 0x000036);
static const CANVAS_GLYPH4 GLYPH_X = CANVAS_GLYPH4_CONST(0x333300, 0x0C1E33, 0x33331E, 0x000033);
static const CANVAS_GLYPH4 GLYPH_Y = CANVAS_GLYPH4_CONST(0x333300, 0x1E3333, 0x0C0C0C, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_Z = CANVAS_GLYPH4_CONST(0x737F00, 0x0C1819, 0x634606, 0x00007F);

static const CANVAS_GLYPH4 GLYPH_LEFT_BRACKET = CANVAS_GLYPH4_CONST(0x0C3C00, 0x0C0C0C, 0x0C0C0C, 0x00003C);
static const CANVAS_GLYPH4 GLYPH_BACKSLASH = CANVAS_GLYPH4_CONST(0x010000, 0x0C0603, 0x603018, 0x000040);
static const CANVAS_GLYPH4 GLYPH_RIGHT_BRACKET = CANVAS_GLYPH4_CONST(0x303C00, 0x303030, 0x303030, 0x00003C);
static const CANVAS_GLYPH4 GLYPH_CARET = CANVAS_GLYPH4_CONST(0x361C08, 0x000063, 0x000000, 0x000000);
static const CANVAS_GLYPH4 GLYPH_UNDERSCORE = CANVAS_GLYPH4_CONST(0x000000, 0x000000, 0x000000, 0x00FF00);
static const CANVAS_GLYPH4 GLYPH_GRAVE = CANVAS_GLYPH4_CONST(0x0C0600, 0x00180C, 0x000000, 0x000000);

static const CANVAS_GLYPH4 GLYPH_a = CANVAS_GLYPH4_CONST(0x000000, 0x301E00, 0x33333E, 0x00006E);
static const CANVAS_GLYPH4 GLYPH_b = CANVAS_GLYPH4_CONST(0x060700, 0x663E06, 0x666666, 0x00003B);
static const CANVAS_GLYPH4 GLYPH_c = CANVAS_GLYPH4_CONST(0x000000, 0x331E00, 0x330303, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_d = CANVAS_GLYPH4_CONST(0x303800, 0x333E30, 0x333333, 0x00006E);
static const CANVAS_GLYPH4 GLYPH_e = CANVAS_GLYPH4_CONST(0x000000, 0x331E00, 0x33033F, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_f = CANVAS_GLYPH4_CONST(0x361C00, 0x1F0606, 0x060606, 0x00000F);
static const CANVAS_GLYPH4 GLYPH_g = CANVAS_GLYPH4_CONST(0x000000, 0x336E00, 0x3E3333, 0x1E3330);
static const CANVAS_GLYPH4 GLYPH_h = CANVAS_GLYPH4_CONST(0x060700, 0x6E3606, 0x666666, 0x000067);
static const CANVAS_GLYPH4 GLYPH_i = CANVAS_GLYPH4_CONST(0x181800, 0x181E00, 0x181818, 0x00007E);
static const CANVAS_GLYPH4 GLYPH_j = CANVAS_GLYPH4_CONST(0x303000, 0x303C00, 0x303030, 0x1E3333);
static const CANVAS_GLYPH4 GLYPH_k = CANVAS_GLYPH4_CONST(0x060700, 0x366606, 0x66361E, 0x000067);
static const CANVAS_GLYPH4 GLYPH_l = CANVAS_GLYPH4_CONST(0x181E00, 0x181818, 0x181818, 0x00007E);
static const CANVAS_GLYPH4 GLYPH_m = CANVAS_GLYPH4_CONST(0x000000, 0x6B3F00, 0x6B6B6B, 0x000063);
static const CANVAS_GLYPH4 GLYPH_n = CANVAS_GLYPH4_CONST(0x000000, 0x331F00, 0x333333, 0x000033);
static const CANVAS_GLYPH4 GLYPH_o = CANVAS_GLYPH4_CONST(0x000000, 0x331E00, 0x333333, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_p = CANVAS_GLYPH4_CONST(0x000000, 0x663B00, 0x666666, 0x0F063E);
static const CANVAS_GLYPH4 GLYPH_q = CANVAS_GLYPH4_CONST(0x000000, 0x336E00, 0x333333, 0x78303E);
static const CANVAS_GLYPH4 GLYPH_r = CANVAS_GLYPH4_CONST(0x000000, 0x763700, 0x06066E, 0x00000F);
static const CANVAS_GLYPH4 GLYPH_s = CANVAS_GLYPH4_CONST(0x000000, 0x331E00, 0x331806, 0x00001E);
static const CANVAS_GLYPH4 GLYPH_t = CANVAS_GLYPH4_CONST(0x040000, 0x063F06, 0x360606, 0x00001C);
static const CANVAS_GLYPH4 GLYPH_u = CANVAS_GLYPH4_CONST(0x000000, 0x333300, 0x333333, 0x00006E);
static const CANVAS_GLYPH4 GLYPH_v = CANVAS_GLYPH4_CONST(0x000000, 0x333300, 0x1E3333, 0x00000C);
static const CANVAS_GLYPH4 GLYPH_w = CANVAS_GLYPH4_CONST(0x000000, 0x636300, 0x366B6B, 0x000036);
static const CANVAS_GLYPH4 GLYPH_x = CANVAS_GLYPH4_CONST(0x000000, 0x366300, 0x361C1C, 0x000063);
static const CANVAS_GLYPH4 GLYPH_y = CANVAS_GLYPH4_CONST(0x000000, 0x666600, 0x3C6666, 0x0F1830);
static const CANVAS_GLYPH4 GLYPH_z = CANVAS_GLYPH4_CONST(0x000000, 0x313F00, 0x230618, 0x00003F);

static const CANVAS_GLYPH4 GLYPH_LEFT_BRACE = CANVAS_GLYPH4_CONST(0x0C3800, 0x03060C, 0x0C0C06, 0x000038);
static const CANVAS_GLYPH4 GLYPH_PIPE = CANVAS_GLYPH4_CONST(0x181800, 0x001818, 0x181818, 0x000018);
static const CANVAS_GLYPH4 GLYPH_RIGHT_BRACE = CANVAS_GLYPH4_CONST(0x0C0700, 0x30180C, 0x0C0C18, 0x000007);
static const CANVAS_GLYPH4 GLYPH_TILDE = CANVAS_GLYPH4_CONST(0x5BCE00, 0x000073, 0x000000, 0x000000);

static const CANVAS_GLYPH4 GLYPHS_PRINTABLE_ASCII[95] = {
  GLYPH_SPACE,
  GLYPH_EXCLAMATION,
  GLYPH_QUOTE,
  GLYPH_HASH,
  GLYPH_DOLLAR,
  GLYPH_PERCENT,
  GLYPH_AMPERSAND,
  GLYPH_APOSTROPHE,
  GLYPH_LEFT_PAREN,
  GLYPH_RIGHT_PAREN,
  GLYPH_ASTERISK,
  GLYPH_PLUS,
  GLYPH_COMMA,
  GLYPH_DASH,
  GLYPH_DOT,
  GLYPH_SLASH,
  GLYPH_0,
  GLYPH_1,
  GLYPH_2,
  GLYPH_3,
  GLYPH_4,
  GLYPH_5,
  GLYPH_6,
  GLYPH_7,
  GLYPH_8,
  GLYPH_9,
  GLYPH_COLON,
  GLYPH_SEMICOLON,
  GLYPH_LESS_THAN,
  GLYPH_EQUALS,
  GLYPH_GREATER_THAN,
  GLYPH_QUESTION,
  GLYPH_AT,
  GLYPH_A,
  GLYPH_B,
  GLYPH_C,
  GLYPH_D,
  GLYPH_E,
  GLYPH_F,
  GLYPH_G,
  GLYPH_H,
  GLYPH_I,
  GLYPH_J,
  GLYPH_K,
  GLYPH_L,
  GLYPH_M,
  GLYPH_N,
  GLYPH_O,
  GLYPH_P,
  GLYPH_Q,
  GLYPH_R,
  GLYPH_S,
  GLYPH_T,
  GLYPH_U,
  GLYPH_V,
  GLYPH_W,
  GLYPH_X,
  GLYPH_Y,
  GLYPH_Z,
  GLYPH_LEFT_BRACKET,
  GLYPH_BACKSLASH,
  GLYPH_RIGHT_BRACKET,
  GLYPH_CARET,
  GLYPH_UNDERSCORE,
  GLYPH_GRAVE,
  GLYPH_a,
  GLYPH_b,
  GLYPH_c,
  GLYPH_d,
  GLYPH_e,
  GLYPH_f,
  GLYPH_g,
  GLYPH_h,
  GLYPH_i,
  GLYPH_j,
  GLYPH_k,
  GLYPH_l,
  GLYPH_m,
  GLYPH_n,
  GLYPH_o,
  GLYPH_p,
  GLYPH_q,
  GLYPH_r,
  GLYPH_s,
  GLYPH_t,
  GLYPH_u,
  GLYPH_v,
  GLYPH_w,
  GLYPH_x,
  GLYPH_y,
  GLYPH_z,
  GLYPH_LEFT_BRACE,
  GLYPH_PIPE,
  GLYPH_RIGHT_BRACE,
  GLYPH_TILDE,
};

int Pow10(float exponent) {
  if (exponent < 1.0f) return 1;
  if (exponent < 2.0f) return 10;
  if (exponent < 3.0f) return 100;
  if (exponent < 4.0f) return 1000;
  if (exponent < 5.0f) return 10000;
  if (exponent < 6.0f) return 100000;
  if (exponent < 7.0f) return 1000000;
  if (exponent < 8.0f) return 10000000;
  if (exponent < 9.0f) return 100000000;
  return 1000000000;
}

float Pow10f(float exponent) {
  if (exponent < 1.0f) return 1.0f;
  if (exponent < 2.0f) return 10.0f;
  if (exponent < 3.0f) return 100.0f;
  if (exponent < 4.0f) return 1000.0f;
  if (exponent < 5.0f) return 10000.0f;
  if (exponent < 6.0f) return 100000.0f;
  if (exponent < 7.0f) return 1000000.0f;
  if (exponent < 8.0f) return 10000000.0f;
  if (exponent < 9.0f) return 100000000.0f;
  return 1000000000.0f;
}

bool TextModeEnabled(int mode, int flag) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  return (mode & flag) != 0;
#else
  return flag != 0 && ((mode / flag) % 2) != 0;
#endif
}

bool TestGlyphPixel(CANVAS_GLYPH4 glyph, float2 glyph_uv) {
  float2 glyph_pixel = floor(glyph_uv);
  if (glyph_pixel.x < 0.0f || glyph_pixel.y < 0.0f || glyph_pixel.x >= 8.0f || glyph_pixel.y >= 12.0f) return false;

  // The packed glyph data stores 3 rows per 24-bit lane.
  float lane_index = floor(glyph_pixel.y / 3.0f);
  float row_in_lane = glyph_pixel.y - lane_index * 3.0f;
  float bit_shift = mad(row_in_lane, 8.0f, glyph_pixel.x);
  CANVAS_GLYPH_SCALAR glyph_lane = lane_index == 0.0f  ? glyph[0]
                                   : lane_index == 1.0f ? glyph[1]
                                   : lane_index == 2.0f ? glyph[2]
                                                        : glyph[3];
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  return ((glyph_lane >> uint(bit_shift)) & 1u) != 0u;
#else
  return frac(glyph_lane / exp2(bit_shift + 1.0f)) >= 0.5f;
#endif
}

bool BlinkPhase(float time) {
  return frac(time * (BLINK_RATE * 0.5f)) < 0.5f;
}

CANVAS_GLYPH4 ApplyTextMode(CANVAS_GLYPH4 glyph, int mode, bool blink_phase) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  if ((mode & MODE_UNDERLINE) != 0) {
    glyph.w = (glyph.w & 0x00FFFF00u) | 0x000000FFu;
  }

  bool invert = (mode & MODE_INVERT) != 0;
  if ((mode & MODE_BLINVERT) != 0 && blink_phase) {
    invert = !invert;
  }

  if (invert) {
    glyph ^= GLYPH_MASK;
  }
#else
  if (TextModeEnabled(mode, MODE_UNDERLINE)) {
    glyph.w = (glyph.w / 256) * 256 + 255;
  }

  bool invert = TextModeEnabled(mode, MODE_INVERT);
  if (TextModeEnabled(mode, MODE_BLINVERT) && blink_phase) {
    invert = !invert;
  }

  if (invert) {
    glyph = GLYPH_MASK - glyph;
  }
#endif

  return glyph;
}

CANVAS_GLYPH4 DigitGlyph(int digit) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  if (digit >= 0 && digit <= 9) return GLYPHS_PRINTABLE_ASCII[digit + ('0' - 32)];
#else
  if (digit == 0) return GLYPH_0;
  if (digit == 1) return GLYPH_1;
  if (digit == 2) return GLYPH_2;
  if (digit == 3) return GLYPH_3;
  if (digit == 4) return GLYPH_4;
  if (digit == 5) return GLYPH_5;
  if (digit == 6) return GLYPH_6;
  if (digit == 7) return GLYPH_7;
  if (digit == 8) return GLYPH_8;
  if (digit == 9) return GLYPH_9;
#endif
  return GLYPH_SPACE;
}

CANVAS_GLYPH4 GlyphFromAscii(int ascii) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  if (ascii >= 32 && ascii <= 126) return GLYPHS_PRINTABLE_ASCII[ascii - 32];
#else
  if (ascii == 32) return GLYPH_SPACE;
  if (ascii == 33) return GLYPH_EXCLAMATION;
  if (ascii == 34) return GLYPH_QUOTE;
  if (ascii == 35) return GLYPH_HASH;
  if (ascii == 36) return GLYPH_DOLLAR;
  if (ascii == 37) return GLYPH_PERCENT;
  if (ascii == 38) return GLYPH_AMPERSAND;
  if (ascii == 39) return GLYPH_APOSTROPHE;
  if (ascii == 40) return GLYPH_LEFT_PAREN;
  if (ascii == 41) return GLYPH_RIGHT_PAREN;
  if (ascii == 42) return GLYPH_ASTERISK;
  if (ascii == 43) return GLYPH_PLUS;
  if (ascii == 44) return GLYPH_COMMA;
  if (ascii == 45) return GLYPH_DASH;
  if (ascii == 46) return GLYPH_DOT;
  if (ascii == 47) return GLYPH_SLASH;
  if (ascii == 48) return GLYPH_0;
  if (ascii == 49) return GLYPH_1;
  if (ascii == 50) return GLYPH_2;
  if (ascii == 51) return GLYPH_3;
  if (ascii == 52) return GLYPH_4;
  if (ascii == 53) return GLYPH_5;
  if (ascii == 54) return GLYPH_6;
  if (ascii == 55) return GLYPH_7;
  if (ascii == 56) return GLYPH_8;
  if (ascii == 57) return GLYPH_9;
  if (ascii == 58) return GLYPH_COLON;
  if (ascii == 59) return GLYPH_SEMICOLON;
  if (ascii == 60) return GLYPH_LESS_THAN;
  if (ascii == 61) return GLYPH_EQUALS;
  if (ascii == 62) return GLYPH_GREATER_THAN;
  if (ascii == 63) return GLYPH_QUESTION;
  if (ascii == 64) return GLYPH_AT;
  if (ascii == 65) return GLYPH_A;
  if (ascii == 66) return GLYPH_B;
  if (ascii == 67) return GLYPH_C;
  if (ascii == 68) return GLYPH_D;
  if (ascii == 69) return GLYPH_E;
  if (ascii == 70) return GLYPH_F;
  if (ascii == 71) return GLYPH_G;
  if (ascii == 72) return GLYPH_H;
  if (ascii == 73) return GLYPH_I;
  if (ascii == 74) return GLYPH_J;
  if (ascii == 75) return GLYPH_K;
  if (ascii == 76) return GLYPH_L;
  if (ascii == 77) return GLYPH_M;
  if (ascii == 78) return GLYPH_N;
  if (ascii == 79) return GLYPH_O;
  if (ascii == 80) return GLYPH_P;
  if (ascii == 81) return GLYPH_Q;
  if (ascii == 82) return GLYPH_R;
  if (ascii == 83) return GLYPH_S;
  if (ascii == 84) return GLYPH_T;
  if (ascii == 85) return GLYPH_U;
  if (ascii == 86) return GLYPH_V;
  if (ascii == 87) return GLYPH_W;
  if (ascii == 88) return GLYPH_X;
  if (ascii == 89) return GLYPH_Y;
  if (ascii == 90) return GLYPH_Z;
  if (ascii == 91) return GLYPH_LEFT_BRACKET;
  if (ascii == 92) return GLYPH_BACKSLASH;
  if (ascii == 93) return GLYPH_RIGHT_BRACKET;
  if (ascii == 94) return GLYPH_CARET;
  if (ascii == 95) return GLYPH_UNDERSCORE;
  if (ascii == 96) return GLYPH_GRAVE;
  if (ascii == 97) return GLYPH_a;
  if (ascii == 98) return GLYPH_b;
  if (ascii == 99) return GLYPH_c;
  if (ascii == 100) return GLYPH_d;
  if (ascii == 101) return GLYPH_e;
  if (ascii == 102) return GLYPH_f;
  if (ascii == 103) return GLYPH_g;
  if (ascii == 104) return GLYPH_h;
  if (ascii == 105) return GLYPH_i;
  if (ascii == 106) return GLYPH_j;
  if (ascii == 107) return GLYPH_k;
  if (ascii == 108) return GLYPH_l;
  if (ascii == 109) return GLYPH_m;
  if (ascii == 110) return GLYPH_n;
  if (ascii == 111) return GLYPH_o;
  if (ascii == 112) return GLYPH_p;
  if (ascii == 113) return GLYPH_q;
  if (ascii == 114) return GLYPH_r;
  if (ascii == 115) return GLYPH_s;
  if (ascii == 116) return GLYPH_t;
  if (ascii == 117) return GLYPH_u;
  if (ascii == 118) return GLYPH_v;
  if (ascii == 119) return GLYPH_w;
  if (ascii == 120) return GLYPH_x;
  if (ascii == 121) return GLYPH_y;
  if (ascii == 122) return GLYPH_z;
  if (ascii == 123) return GLYPH_LEFT_BRACE;
  if (ascii == 124) return GLYPH_PIPE;
  if (ascii == 125) return GLYPH_RIGHT_BRACE;
  if (ascii == 126) return GLYPH_TILDE;
#endif
  return GLYPH_SPACE;
}

bool TestGlyphCoverage(float2 position, CANVAS_GLYPH4 glyph, float2 origin, float2 glyph_size, int mode, float time) {
  float2 local = position - origin;
  if (local.x < 0.0f || local.y < 0.0f || local.x >= glyph_size.x || local.y >= glyph_size.y) return false;

  float2 sprite_uv = local * (GLYPH_SIZE / glyph_size);
  if (mode == MODE_NORMAL) {
    return TestGlyphPixel(glyph, sprite_uv);
  }

#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  bool uses_blink_phase = (mode & (MODE_BLINK | MODE_BLINVERT)) != 0;
  bool blink_hidden = (mode & MODE_BLINK) != 0;
#else
  bool uses_blink_phase = TextModeEnabled(mode, MODE_BLINK) || TextModeEnabled(mode, MODE_BLINVERT);
  bool blink_hidden = TextModeEnabled(mode, MODE_BLINK);
#endif
  bool blink_phase = uses_blink_phase ? BlinkPhase(time) : false;
  if (blink_hidden && blink_phase) {
    return false;
  }

  glyph = ApplyTextMode(glyph, mode, blink_phase);
  bool has_coverage = TestGlyphPixel(glyph, sprite_uv);
  if (!has_coverage) return false;

  return true;
}

bool TestGlyphCoverage(float2 position, int ascii, float2 origin, float2 glyph_size, int mode, float time) {
  return TestGlyphCoverage(position, GlyphFromAscii(ascii), origin, glyph_size, mode, time);
}

bool TestGlyphCoverage(float2 position, CANVAS_GLYPH4 glyph, float2 origin, float2 glyph_size) {
  return TestGlyphCoverage(position, glyph, origin, glyph_size, MODE_NORMAL, 0.0f);
}

bool TestGlyphCoverage(float2 position, int ascii, float2 origin, float2 glyph_size) {
  return TestGlyphCoverage(position, ascii, origin, glyph_size, MODE_NORMAL, 0.0f);
}

float IntegerDigitCount(int value) {
  if (value <= -1000000000 || value >= 1000000000) return 10.0f;
  if (value <= -100000000 || value >= 100000000) return 9.0f;
  if (value <= -10000000 || value >= 10000000) return 8.0f;
  if (value <= -1000000 || value >= 1000000) return 7.0f;
  if (value <= -100000 || value >= 100000) return 6.0f;
  if (value <= -10000 || value >= 10000) return 5.0f;
  if (value <= -1000 || value >= 1000) return 4.0f;
  if (value <= -100 || value >= 100) return 3.0f;
  if (value <= -10 || value >= 10) return 2.0f;
  return 1.0f;
}

float IntegerDigitCount(float value) {
  if (value <= -1000000000.0f || value >= 1000000000.0f) return 10.0f;
  if (value <= -100000000.0f || value >= 100000000.0f) return 9.0f;
  if (value <= -10000000.0f || value >= 10000000.0f) return 8.0f;
  if (value <= -1000000.0f || value >= 1000000.0f) return 7.0f;
  if (value <= -100000.0f || value >= 100000.0f) return 6.0f;
  if (value <= -10000.0f || value >= 10000.0f) return 5.0f;
  if (value <= -1000.0f || value >= 1000.0f) return 4.0f;
  if (value <= -100.0f || value >= 100.0f) return 3.0f;
  if (value <= -10.0f || value >= 10.0f) return 2.0f;
  return 1.0f;
}

float IntegerFieldGlyphCount(int value, float max_digits, bool reserve_sign) {
  return max_digits + ((reserve_sign || value < 0) ? 1.0f : 0.0f);
}

float FloatFieldGlyphCount(float digits, float decimals, bool reserve_sign, bool negative) {
  float count = digits + (decimals > 0.0f ? 1.0f + decimals : 0.0f);
  if (reserve_sign || negative) count += 1.0f;
  return count;
}

CANVAS_GLYPH4 IntegerGlyphAt(float index, int value, float digits, bool leading_zeros = false, bool reserve_sign = false) {
  bool negative = value < 0;
  float sign_width = (negative || reserve_sign) ? 1.0f : 0.0f;
  if (index < sign_width) {
    return negative ? GLYPH_DASH : GLYPH_SPACE;
  }

  float digit_index = index - sign_width;
  int divisor = Pow10(digits - 1.0f - digit_index);
  int quotient = value / divisor;
  int digit = quotient % 10;
  if (digit < 0) digit = -digit;

  bool show_digit = leading_zeros || quotient != 0 || (digit_index == digits - 1.0f);
  return show_digit ? DigitGlyph(digit) : GLYPH_SPACE;
}

CANVAS_GLYPH4 FloatGlyphAt(
    float index,
    float integer_part,
    float fractional_part,
    float digits,
    float frac_digits,
    bool negative = false,
    bool leading_zeros = false,
    bool reserve_sign = false) {
  float sign_width = (negative || reserve_sign) ? 1.0f : 0.0f;
  float dot_index = sign_width + digits;
  if (index < sign_width) {
    return negative ? GLYPH_DASH : GLYPH_SPACE;
  }

  if (index < sign_width + digits) {
    float digit_index = index - sign_width;
    int divisor = Pow10(digits - 1.0f - digit_index);
    int integer_value = int(integer_part);
    int digit = (integer_value / divisor) % 10;
    bool show_digit = leading_zeros || (integer_value >= divisor) || (digit_index == digits - 1.0f);
    return show_digit ? DigitGlyph(digit) : GLYPH_SPACE;
  }

  if (frac_digits > 0.0f && index == dot_index) {
    return GLYPH_DOT;
  }

  if (frac_digits > 0.0f) {
    float frac_index = index - dot_index - 1.0f;
    int divisor = Pow10(frac_digits - 1.0f - frac_index);
    int fractional_value = int(fractional_part);
    int digit = (fractional_value / divisor) % 10;
    return DigitGlyph(digit);
  }

  return GLYPH_SPACE;
}

float TextLength(
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  if (a == 0) return 0.0f;
  if (b == 0) return 1.0f;
  if (c == 0) return 2.0f;
  if (d == 0) return 3.0f;
  if (e == 0) return 4.0f;
  if (f == 0) return 5.0f;
  if (g == 0) return 6.0f;
  if (h == 0) return 7.0f;
  if (i == 0) return 8.0f;
  if (j == 0) return 9.0f;
  if (k == 0) return 10.0f;
  if (l == 0) return 11.0f;
  if (m == 0) return 12.0f;
  if (n == 0) return 13.0f;
  if (o == 0) return 14.0f;
  if (p == 0) return 15.0f;
  return 16.0f;
}

int TextAsciiAt(
    float index,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  if (index < 1.0f) return a;
  if (index < 2.0f) return b;
  if (index < 3.0f) return c;
  if (index < 4.0f) return d;
  if (index < 5.0f) return e;
  if (index < 6.0f) return f;
  if (index < 7.0f) return g;
  if (index < 8.0f) return h;
  if (index < 9.0f) return i;
  if (index < 10.0f) return j;
  if (index < 11.0f) return k;
  if (index < 12.0f) return l;
  if (index < 13.0f) return m;
  if (index < 14.0f) return n;
  if (index < 15.0f) return o;
  return p;
}

float DecodeSRGB(float value) {
  return value <= 0.04045f
             ? value / 12.92f
             : pow(mad(value, 1.f / 1.055f, 0.055f / 1.055f), 2.4f);
}

float3 ColorFromRGB8(int rgb) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  uint rgb8 = uint(rgb);
  float3 srgb = float3(
      float((rgb8 >> 16u) & 255u),
      float((rgb8 >> 8u) & 255u),
      float(rgb8 & 255u)) * (1.0f / 255.0f);
#else
  int red = rgb / 65536;
  int green = (rgb / 256) % 256;
  int blue = rgb % 256;
  float3 srgb = float3(float(red), float(green), float(blue)) * (1.0f / 255.0f);
#endif
  return float3(DecodeSRGB(srgb.r), DecodeSRGB(srgb.g), DecodeSRGB(srgb.b));
}

}  // namespace internal

bool TestRectCoverage(float2 position, float2 min_corner, float2 max_corner) {
  return position.x >= min_corner.x && position.y >= min_corner.y && position.x <= max_corner.x && position.y <= max_corner.y;
}

float ComputeRectMask(float2 position, float2 min_corner, float2 max_corner) {
  return TestRectCoverage(position, min_corner, max_corner) ? 1.0f : 0.0f;
}

struct Context {
  float2 position;
  float2 origin;
  float2 cursor;
  float2 glyph_size;
  float line_height;
  int mode;
  float time;
  float3 color;
  float alpha_scale;
  float intensity_scale;
  float3 output_color;
  float output_alpha;
};

Context CreateContext(
    float2 position = float2(0.0f, 0.0f),
    float2 origin = float2(0.0f, 0.0f),
    float2 glyph_size = float2(8.0f, 12.0f),
    float3 output_color = float3(0.0f, 0.0f, 0.0f),
    float output_alpha = 0.0f,
    float3 color = float3(1.0f, 1.0f, 1.0f),
    float alpha_scale = 1.0f,
    float intensity_scale = 1.0f,
    int mode = MODE_NORMAL,
    float time = 0.0f,
    float line_height = 1.0f) {
  Context context;
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

float4 GetOutput(Context context) {
  return float4(context.output_color, context.output_alpha);
}

void SetPosition(inout Context context, float2 position) {
  context.position = position;
}

void SetCursor(inout Context context, float2 cursor) {
  context.cursor = cursor;
}

void ResetCursor(inout Context context) {
  context.cursor = context.origin;
}

void AdvanceCursor(inout Context context, float glyph_count = 1.0f) {
  context.cursor.x = mad(glyph_count, context.glyph_size.x, context.cursor.x);
}

void SetLineHeight(inout Context context, float line_height) {
  context.line_height = line_height;
}

void SetTime(inout Context context, float time) {
  context.time = time;
}

void InsertSpaces(inout Context context, float count = 1.0f) {
  AdvanceCursor(context, count);
}

void InsertSpace(inout Context context) {
  InsertSpaces(context, 1.0f);
}

void NewLine(inout Context context, float line_count = 1.0f) {
  context.cursor = float2(context.origin.x, mad(line_count * context.line_height, context.glyph_size.y, context.cursor.y));
}

void SetMode(inout Context context, int mode) {
  context.mode = mode;
}

void SetColor(inout Context context, float3 color, float alpha_scale = 1.0f, float intensity_scale = 1.0f) {
  context.color = color;
  context.alpha_scale = alpha_scale;
  context.intensity_scale = intensity_scale;
}

// Literal 0xRRGGBB inputs default to sRGB decode and constant-fold in fxc/dxc.
void SetColor(inout Context context, int srgb, float alpha_scale = 1.0f, float intensity_scale = 1.0f) {
  SetColor(context, internal::ColorFromRGB8(srgb), alpha_scale, intensity_scale);
}

void SetAlphaScale(inout Context context, float alpha_scale) {
  context.alpha_scale = alpha_scale;
}

void SetIntensityScale(inout Context context, float intensity_scale) {
  context.intensity_scale = intensity_scale;
}

void EnableMode(inout Context context, int flag) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  context.mode |= flag;
#else
  if (!internal::TextModeEnabled(context.mode, flag)) {
    context.mode += flag;
  }
#endif
}

void DisableMode(inout Context context, int flag) {
#if (defined(VULKAN) || __SHADER_TARGET_MAJOR >= 4)
  context.mode &= ~flag;
#else
  if (internal::TextModeEnabled(context.mode, flag)) {
    context.mode -= flag;
  }
#endif
}

void SetUnderline(inout Context context, bool enabled = true) {
  if (enabled) {
    EnableMode(context, MODE_UNDERLINE);
  } else {
    DisableMode(context, MODE_UNDERLINE);
  }
}

void RemoveUnderline(inout Context context) {
  SetUnderline(context, false);
}

void SetInvert(inout Context context, bool enabled = true) {
  if (enabled) {
    EnableMode(context, MODE_INVERT);
  } else {
    DisableMode(context, MODE_INVERT);
  }
}

void RemoveInvert(inout Context context) {
  SetInvert(context, false);
}

void SetBlink(inout Context context, bool enabled = true) {
  if (enabled) {
    EnableMode(context, MODE_BLINK);
  } else {
    DisableMode(context, MODE_BLINK);
  }
}

void RemoveBlink(inout Context context) {
  SetBlink(context, false);
}

void SetBlinkInvert(inout Context context, bool enabled = true) {
  if (enabled) {
    EnableMode(context, MODE_BLINVERT);
  } else {
    DisableMode(context, MODE_BLINVERT);
  }
}

void RemoveBlinkInvert(inout Context context) {
  SetBlinkInvert(context, false);
}

void CompositeMask(inout Context context, float mask) {
  float alpha = saturate(mask * context.intensity_scale) * context.alpha_scale;
  context.output_color = lerp(context.output_color, context.color, alpha);
  context.output_alpha = max(context.output_alpha, alpha);
}

void CompositeCoverage(inout Context context) {
  float alpha = saturate(context.intensity_scale) * context.alpha_scale;
  context.output_color = lerp(context.output_color, context.color, alpha);
  context.output_alpha = max(context.output_alpha, alpha);
}

void DrawGlyph(inout Context context, CANVAS_GLYPH4 glyph, float2 origin) {
  bool has_coverage = context.mode == MODE_NORMAL
                          ? internal::TestGlyphCoverage(context.position, glyph, origin, context.glyph_size)
                          : internal::TestGlyphCoverage(context.position, glyph, origin, context.glyph_size, context.mode, context.time);
  if (has_coverage) {
    CompositeCoverage(context);
  }
}

void DrawGlyph(inout Context context, int ascii, float2 origin) {
  bool has_coverage = context.mode == MODE_NORMAL
                          ? internal::TestGlyphCoverage(context.position, ascii, origin, context.glyph_size)
                          : internal::TestGlyphCoverage(context.position, ascii, origin, context.glyph_size, context.mode, context.time);
  if (has_coverage) {
    CompositeCoverage(context);
  }
}

void FillRect(inout Context context, float2 min_corner, float2 max_corner) {
  if (TestRectCoverage(context.position, min_corner, max_corner)) {
    CompositeMask(context, 1.0f);
  }
}

// Compiler will constant-fold count inference for literal character arguments.
void DrawText(
    inout Context context,
    int a, int b = 0, int c = 0, int d = 0,
    int e = 0, int f = 0, int g = 0, int h = 0,
    int i = 0, int j = 0, int k = 0, int l = 0,
    int m = 0, int n = 0, int o = 0, int p = 0) {
  float count = internal::TextLength(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
  float2 origin = context.cursor;
  AdvanceCursor(context, count);

  float2 local = context.position - origin;

  if (local.x >= 0.0f && local.y >= 0.0f && local.y < context.glyph_size.y) {
    float glyph_index = floor(local.x / context.glyph_size.x);
    if (glyph_index < count) {
      int ascii = internal::TextAsciiAt(glyph_index, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p);
      float2 glyph_origin = origin + float2(glyph_index * context.glyph_size.x, 0.0f);
      DrawGlyph(context, ascii, glyph_origin);
    }
  }
}

void DrawInteger(inout Context context, int value, float max_digits = 0.0f, bool leading_zeros = false, bool reserve_sign = false) {
  float digits = max_digits > 0.0f ? max_digits : internal::IntegerDigitCount(value);
  float2 origin = context.cursor;
  float total_digits = internal::IntegerFieldGlyphCount(value, digits, reserve_sign);
  AdvanceCursor(context, total_digits);

  float2 local = context.position - origin;

  if (local.x >= 0.0f && local.y >= 0.0f && local.y < context.glyph_size.y) {
    float glyph_index = floor(local.x / context.glyph_size.x);
    if (glyph_index < total_digits) {
      float2 glyph_origin = origin + float2(glyph_index * context.glyph_size.x, 0.0f);
      CANVAS_GLYPH4 glyph = internal::IntegerGlyphAt(glyph_index, value, digits, leading_zeros, reserve_sign);
      if (glyph.x != 0 || glyph.y != 0 || glyph.z != 0 || glyph.w != 0) {
        DrawGlyph(context, glyph, glyph_origin);
      }
    }
  }
}

void DrawFloat(inout Context context, float value, float max_digits = 0.0f, float decimals = 2.0f, bool leading_zeros = false, bool reserve_sign = false) {
  bool negative = value < 0.0f;
  float expected_digits = max_digits > 0.0f ? max_digits : 1.0f;

  bool is_nan = (value != value);
  if (is_nan) {
    float total_digits = internal::FloatFieldGlyphCount(expected_digits, decimals, reserve_sign, false);
    if (total_digits < 3.0f) total_digits = 3.0f;
    float pad_digits = total_digits - 3.0f;
    if (pad_digits > 0.0f) {
      if (leading_zeros) {
        DrawInteger(context, 0, pad_digits, true);
      } else {
        InsertSpaces(context, pad_digits);
      }
    }
    DrawText(context, 'N', 'a', 'N');
    return;
  }

  bool is_inf = (value - value) != 0.0f;
  if (is_inf) {
    float total_digits = internal::FloatFieldGlyphCount(expected_digits, decimals, reserve_sign, negative);
    if (total_digits < (negative ? 4.0f : 3.0f)) total_digits = negative ? 4.0f : 3.0f;
    if (negative) {
      DrawText(context, '-');
      float pad_digits = total_digits - 4.0f;
      if (pad_digits > 0.0f) {
        if (leading_zeros) {
          DrawInteger(context, 0, pad_digits, true);
        } else {
          InsertSpaces(context, pad_digits);
        }
      }
      DrawText(context, 'I', 'n', 'f');
    } else {
      float pad_digits = total_digits - 3.0f;
      if (pad_digits > 0.0f) {
        if (leading_zeros) {
          DrawInteger(context, 0, pad_digits, true);
        } else {
          InsertSpaces(context, pad_digits);
        }
      }
      DrawText(context, 'I', 'n', 'f');
    }
    return;
  }

  float scale = internal::Pow10f(decimals);
  float magnitude = negative ? -value : value;
  float integer_part = trunc(magnitude);
  float fractional_part = round(frac(magnitude) * scale);
  if (fractional_part >= scale) {
    integer_part += 1.0f;
    fractional_part -= scale;
  }
  float digits = max_digits > 0.0f ? max_digits : internal::IntegerDigitCount(integer_part);
  float2 origin = context.cursor;
  float total_digits = internal::FloatFieldGlyphCount(digits, decimals, reserve_sign, negative);
  AdvanceCursor(context, total_digits);

  float2 local = context.position - origin;

  if (local.x >= 0.0f && local.y >= 0.0f && local.y < context.glyph_size.y) {
    float glyph_index = floor(local.x / context.glyph_size.x);
    if (glyph_index < total_digits) {
      float2 glyph_origin = origin + float2(glyph_index * context.glyph_size.x, 0.0f);
      CANVAS_GLYPH4 glyph = internal::FloatGlyphAt(glyph_index, integer_part, fractional_part, digits, decimals, negative, leading_zeros, reserve_sign);
      if (glyph.x != 0 || glyph.y != 0 || glyph.z != 0 || glyph.w != 0) {
        DrawGlyph(context, glyph, glyph_origin);
      }
    }
  }
}

}  // namespace canvas
}  // namespace renodx

#undef CANVAS_GLYPH4_CONST
#undef CANVAS_GLYPH_SCALAR
#undef CANVAS_GLYPH4

#endif  // SRC_SHADERS_CANVAS_HLSL_
