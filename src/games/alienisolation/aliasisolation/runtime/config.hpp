#pragma once

/*
 * Compile-time feature toggles for Alias Isolation extras.
 *
 * Set either value to 0 from the build or before including the runtime headers
 * to remove that optional replacement path from Alien Isolation's
 * `custom_shaders` map. TAA, jitter, and the shadow fixes stay independent of
 * these toggles.
 */

#ifndef ALIENISOLATION_ENABLE_BARREL_DISTORTION_REMOVAL
#define ALIENISOLATION_ENABLE_BARREL_DISTORTION_REMOVAL 0
#endif

#ifndef ALIENISOLATION_ENABLE_BLOOM_MERGE_REPLACEMENT
#define ALIENISOLATION_ENABLE_BLOOM_MERGE_REPLACEMENT 0
#endif
