#pragma once

#include <cstdint>
#include <cstring>

inline uint32_t FloatAsUint32(float a) {
  uint32_t r;
  memcpy(&r, &a, sizeof r);
  return r;
}

inline uint16_t Float2Half(float a) {
  uint32_t ia = FloatAsUint32(a);
  uint16_t ir;

  ir = (ia >> 16) & 0x8000;
  if ((ia & 0x7f800000) == 0x7f800000) {
    if ((ia & 0x7fffffff) == 0x7f800000) {
      ir |= 0x7c00; /* infinity */
    } else {
      ir |= 0x7e00 | ((ia >> (24 - 11)) & 0x1ff); /* NaN, quietened */
    }
  } else if ((ia & 0x7f800000) >= 0x33000000) {
    const int shift = static_cast<int>((ia >> 23) & 0xff) - 127;
    if (shift > 15) {
      ir |= 0x7c00; /* infinity */
    } else {
      ia = (ia & 0x007fffff) | 0x00800000; /* extract mantissa */
      if (shift < -14) {                   /* denormal */
        ir |= ia >> (-1 - shift);
        ia = ia << (32 - (-1 - shift));
      } else { /* normal */
        ir |= ia >> (24 - 11);
        ia = ia << (32 - (24 - 11));
        ir = ir + ((14 + shift) << 10);
      }
      /* IEEE-754 round to nearest of even */
      if ((ia > 0x80000000) || ((ia == 0x80000000) && ((ir & 1) != 0))) {
        ir++;
      }
    }
  }
  return ir;
}
