#ifndef SONIC_X_SHADOW_GENERATIONS_FSR_DISPATCH_HLSLI_
#define SONIC_X_SHADOW_GENERATIONS_FSR_DISPATCH_HLSLI_

// Each 64-thread group covers four 8x8 quadrants of a 16x16 output tile.
uint2 FsrTilePixel(uint2 group, uint lane) {
  return group * 16u + uint2((lane >> 1u) & 7u, ((lane >> 3u) & 6u) | (lane & 1u));
}

#endif
