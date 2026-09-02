#ifndef RENODX_SHADERS_TONEMAP_ALLENWP_HLSL_
#define RENODX_SHADERS_TONEMAP_ALLENWP_HLSL_

#include "../color.hlsl"
#include "../colorcorrect.hlsl"
#include "../math.hlsl"

/*
allenwp tonemapping curve; developed for use in the Godot game engine
Source and details: https://allenwp.com/blog/2025/05/29/allenwp-tonemapping-curve/
- Sigmoid power Toe
- Reinhard-like Shoulder

Copyright (c) 2025 Allen Pestaluky

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

namespace renodx {
namespace tonemap {
namespace allenwp {
namespace internal {

struct Parameters {
  float output_max_value;
  float awp_contrast;
  float awp_toe_a;
  float awp_slope;
  float awp_w;
  float awp_shoulder_max;
  float awp_crossover_point;
};

// Setup parameters to be used in the curve
// (It's supposed to be CPU-side for perf)
Parameters SetupParameters(float output_max_value, float awp_contrast = 1.25f, float awp_high_clip = 16.0f, float awp_crossover_point = 0.1841865f) {
    Parameters par;
    par.output_max_value = output_max_value;
    par.awp_contrast = awp_contrast;
    par.awp_crossover_point = awp_crossover_point;
    par.awp_toe_a = ((1.0f / par.awp_crossover_point) - 1.0f) * pow(par.awp_crossover_point, par.awp_contrast);
    float awp_slope_denom = pow(par.awp_crossover_point, par.awp_contrast) + par.awp_toe_a;
    par.awp_slope = (par.awp_contrast * pow(par.awp_crossover_point, par.awp_contrast - 1.0f) * par.awp_toe_a) / (awp_slope_denom * awp_slope_denom);
    par.awp_shoulder_max = par.output_max_value - par.awp_crossover_point;
    par.awp_w = awp_high_clip - par.awp_crossover_point;
    
    par.awp_w = par.awp_w * par.awp_w;
    par.awp_w = par.awp_w / par.awp_shoulder_max;
    par.awp_w = par.awp_w * par.awp_slope;
    
    return par;
}

#define ALLENWP_GENERATOR(T)                                                         \
T Curve(T x, Parameters par) {                                                       \
  T s = x - par.awp_crossover_point;                                                 \
  T slope_s = par.awp_slope * s;                                                     \
  s = slope_s * (1.0f + s / par.awp_w) / (1.0f + (slope_s / par.awp_shoulder_max));  \
  s += par.awp_crossover_point;                                                      \
  T t = pow(x, par.awp_contrast);                                                    \
  t = t / (t + par.awp_toe_a);                                                       \
  return renodx::math::Select(x < par.awp_crossover_point, t, s);                    \
}
ALLENWP_GENERATOR(float)
ALLENWP_GENERATOR(float3)
#undef ALLENWP_GENERATOR

}  // namespace internal

// Essentially Reinhard Piecewise Extended with a toe, or GTSport without white clippy shoulder.
// color - linear input, don't give negatives
// output_max_value - i.e. peak / paper white
// awp_contrast - toe contrast, 1.0 or greater
// awp_high_clip - white clip point, expected max of input
// awp_crossover_point - middle gray, piecewise point
float3 PerChannel(float3 color, float output_max_value, float awp_contrast = 1.25f, float awp_high_clip = 16.0f, float awp_crossover_point = 0.1841865f) {
  return internal::Curve(color, internal::SetupParameters(output_max_value, awp_contrast, awp_high_clip, awp_crossover_point));
}

// Essentially Reinhard Piecewise Extended with a toe, or GTSport without clippy shoulder.
// x - linear input, don't give negatives
// output_max_value - i.e. peak / paper white
// awp_contrast - toe contrast, 1.0 or greater
// awp_high_clip - white clip point, expected max of input
// awp_crossover_point - middle gray, piecewise point
float Curve(float x, float output_max_value, float awp_contrast = 1.25f, float awp_high_clip = 16.0f, float awp_crossover_point = 0.1841865f) {
  return internal::Curve(x, internal::SetupParameters(output_max_value, awp_contrast, awp_high_clip, awp_crossover_point));
}

// Essentially Reinhard Piecewise Extended with a toe, or GTSport without clippy shoulder.
// color - linear input, don't give negatives
// output_max_value - i.e. peak / paper white
// awp_contrast - toe contrast, 1.0 or greater
// awp_high_clip - white clip point, expected max of input
// awp_crossover_point - middle gray, piecewise point
float3 MaxChannel(float3 color, float output_max_value, float awp_contrast = 1.25f, float awp_high_clip = 16.0f, float awp_crossover_point = 0.1841865f) {
  float max_channel = max(max(color.r, color.g), color.b);
  float new_max = internal::Curve(max_channel, internal::SetupParameters(output_max_value, awp_contrast, awp_high_clip, awp_crossover_point));
  float scale = max_channel != 0 ? (new_max / max_channel) : 0.f;
  return color * scale;
}

// Essentially Reinhard Piecewise Extended with a toe, or GTSport without clippy shoulder.
// color - linear input, don't give negatives
// output_max_value - i.e. peak / paper white
// awp_contrast - toe contrast, 1.0 or greater
// awp_high_clip - white clip point, expected max of input
// awp_crossover_point - middle gray, piecewise point
float3 BT709(float3 color, float output_max_value, float awp_contrast = 1.25f, float awp_high_clip = 16.0f, float awp_crossover_point = 0.1841865f) {
  float y = renodx::color::y::from::BT709(color);
  float new_y = internal::Curve(y, internal::SetupParameters(output_max_value, awp_contrast, awp_high_clip, awp_crossover_point));
  float scale = y != 0 ? (new_y / y) : 0.f;
  return color * scale;
}

// Essentially Reinhard Piecewise Extended with a toe, or GTSport without clippy shoulder.
// color - linear input, don't give negatives
// output_max_value - i.e. peak / paper white
// awp_contrast - toe contrast, 1.0 or greater
// awp_high_clip - white clip point, expected max of input
// awp_crossover_point - middle gray, piecewise point
float3 BT2020(float3 color, float output_max_value, float awp_contrast = 1.25f, float awp_high_clip = 16.0f, float awp_crossover_point = 0.1841865f) {
  float y = renodx::color::y::from::BT2020(color);
  float new_y = internal::Curve(y, internal::SetupParameters(output_max_value, awp_contrast, awp_high_clip, awp_crossover_point));
  float scale = y != 0 ? (new_y / y) : 0.f;
  return color * scale;
}

} // namespace allenwp
} // namespace tonemap
} // namespace renodx

#endif  // RENODX_SHADERS_TONEMAP_ALLENWP_HLSL_