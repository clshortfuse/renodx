#include "../shared.h"

float3 ApplyBoostSky(float3 sky) {
  if (CUSTOM_BOOST_SKY != 0.f) {
    sky = lerp(sky, renodx::color::grade::UserColorGrading(sky, 1.f, 1.175f, 1.f, 1.f, 1.1f), saturate(sky));
    sky = max(0, sky);
  }
  return sky;
}
