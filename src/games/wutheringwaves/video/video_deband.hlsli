#ifndef WUTHERINGWAVES_VIDEO_DEBAND_HLSLI
#define WUTHERINGWAVES_VIDEO_DEBAND_HLSLI

//
// MIT License
//
// Copyright (c) 2015 Niklas Haas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

static inline float DebandRand(float x) { return frac(x / 41.0f); }

static inline float DebandPermute(float x) { return ((34.0f * x + 1.0f) * x) % 289.0f; }

// Returns the debanded color, or the original if no banding is detected.
// Operates on the input encoding (linear or gamma), outputs the same.
static inline float3 DebandVideo(
    Texture2D<float4> tex,
    SamplerState samp,
    float2 uv,
    float2 texel_size,
    float random_seed) {
  float3 ori = tex.SampleLevel(samp, uv, 0.0f).rgb;

  // PRNG from position + random seed
  float3 m = float3(uv + 1.0f, random_seed + 1.0f);
  float h = DebandPermute(DebandPermute(DebandPermute(m.x) + m.y) + m.z);
  float dir = DebandRand(DebandPermute(h)) * 6.2831853f;
  float2 o;
  sincos(dir, o.y, o.x);

  float2 pt;
  for (int i = 1; i <= DEBAND_ITERATIONS; ++i) {
    float dist = DebandRand(h) * (float)DEBAND_RADIUS * (float)i;
    pt = dist * texel_size;
    h = DebandPermute(h);
  }

  // 4 samples at quarter-turn offsets
  float3 ref[4] = {
      tex.SampleLevel(samp, mad(pt, o, uv), 0.0f).rgb,
      tex.SampleLevel(samp, mad(pt, -o, uv), 0.0f).rgb,
      tex.SampleLevel(samp, mad(pt, float2(-o.y, o.x), uv), 0.0f).rgb,
      tex.SampleLevel(samp, mad(pt, float2(o.y, -o.x), uv), 0.0f).rgb,
  };

  // Weber ratio
  float3 mean = (ori + ref[0] + ref[1] + ref[2] + ref[3]) * 0.2f;
  float3 k = abs(ori - mean);
  [unroll] for (int j = 0; j < 4; ++j) k += abs(ref[j] - mean);
  k = k * 0.2f / max(mean, 1e-6f);

  // Standard deviation
  float3 sd = 0.0f;
  [unroll] for (int j = 0; j < 4; ++j) sd += pow(ref[j] - ori, 2);
  sd = sqrt(sd * 0.25f);

  float3 blended = (ref[0] + ref[1] + ref[2] + ref[3]) * 0.25f;

  // Banding mask: both tests must pass (weber AND std dev)
  float3 banding = float3(
      k.x <= DEBAND_T2 * (float)DEBAND_ITERATIONS && sd.x <= DEBAND_T1 * (float)DEBAND_ITERATIONS,
      k.y <= DEBAND_T2 * (float)DEBAND_ITERATIONS && sd.y <= DEBAND_T1 * (float)DEBAND_ITERATIONS,
      k.z <= DEBAND_T2 * (float)DEBAND_ITERATIONS && sd.z <= DEBAND_T1 * (float)DEBAND_ITERATIONS);

  return lerp(ori, blended, banding);
}

#endif
