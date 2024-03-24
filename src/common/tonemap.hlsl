// https://www.glowybits.com/blog/2016/12/21/ifl_iss_hdr_1/
float3 RgbAcesHdrSrgb(float3 x) {
  x = (x * (x * (x * (x * 2708.7142 + 6801.1525) + 1079.5474) + 1.1614649) - 0.00004139375) / (x * (x * (x * (x * 983.38937 + 4132.0662) + 2881.6522) + 128.35911) + 1.0);
  return max(x, 0.0);
}

// Convert a linear RGB color to an sRGB-encoded color after applying approximate ACES SDR
//  tonemapping (with input scaled by 2.05). Input is assumed to be non-negative.

float3 RgbAcesSdrSrgb(float3 x) {
  return saturate(
    (x * (x * (x * (x * 8.4680 + 1.0) - 0.002957) + 0.0001004) - 0.0000001274) / (x * (x * (x * (x * 8.3604 + 1.8227) + 0.2189) - 0.002117) + 0.00003673)
  );
}

// https://www.slideshare.net/ozlael/hable-john-uncharted2-hdr-lighting
// http://filmicworlds.com/blog/filmic-tonemapping-operators/

const float uncharted2Tonemap_W = 11.2;  // Linear White

float3 uncharted2Tonemap(float x) {
  float A = 0.22;  // Shoulder Strength
  float B = 0.30;  // Linear Strength
  float C = 0.10;  // Linear Angle
  float D = 0.20;  // Toe Strength
  float E = 0.01;  // Toe Numerator
  float F = 0.30;  // Toe Denominator

  return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

