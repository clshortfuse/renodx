#include "./color.hlsl"

namespace renodx {
namespace tonemap {
namespace inverse {
namespace bt2446a {
// BT2446A method
// Input color should be SDR at 100 nits in BT.1886 (2.4)
float3 BT2020(float3 color, float sdr_nits, float target_nits) {
  const float3 k_bt2020 = float3(0.262698338956556, 0.678008765772817, 0.0592928952706273);
  const float k_bt2020_r_helper = 1.47460332208689;  // 2 - 2 * 0.262698338956556
  const float k_bt2020_b_helper = 1.88141420945875;  // 2 - 2 * 0.0592928952706273

  // gamma
  const float inverse_gamma = 2.4f;
  const float gamma = 1.f / inverse_gamma;

  // RGB->R'G'B' gamma compression
  color = pow(color, gamma);

  // Rec. ITU-R BT.2020-2 Table 4
  // Y'tmo
  const float y_tmo = dot(color, renodx::color::BT2020_TO_XYZ_MAT[1].rgb);

  const float luma = y_tmo;
  float3 chromas_bt2020 = (2.f - 2.f * renodx::color::BT2020_TO_XYZ_MAT[1].rgb);
  float3 chromas_sdr = (color.rgb - luma) / chromas_bt2020.rgb;

  // C'b,tmo
  //  const float c_b_tmo = (color.b - y_tmo) / k_bt2020_b_helper;
  // C'r,tmo
  //  const float c_r_tmo = (color.r - y_tmo) / k_bt2020_r_helper;

  // adjusted luma component (inverse)
  // get Y'sdr
  const float y_sdr = y_tmo + max(0.1f * chromas_sdr.r, 0.f);

  // Tone mapping step 3 (inverse)
  // get Y'c
  const float p_sdr = 1 + 32 * pow(sdr_nits / 10000.f, gamma);
  // Y'c
  const float y_c = log((y_sdr * (p_sdr - 1)) + 1) / log(p_sdr);  // log = ln

  // Tone mapping step 2 (inverse)
  // get Y'p
  float y_p = 0.f;

  const float y_p_0 = y_c / 1.0770f;
  const float y_p_2 = (y_c - 0.5000f) / 0.5000f;

  const float _first = -2.7811f;
  const float _sqrt = sqrt(4.83307641 - 4.604 * y_c);
  const float _div = -2.302f;
  const float y_p_1 = (_first + _sqrt) / _div;

  if (y_p_0 <= 0.7399f) {
    y_p = y_p_0;
  } else if (y_p_1 > 0.7399f && y_p_1 < 0.9909f) {
    y_p = y_p_1;
  } else if (y_p_2 >= 0.9909f) {
    y_p = y_p_2;
  } else  // y_p_1 sometimes (about 0.12% out of the full RGB range)
          // is less than 0.7399f or more than 0.9909f because of float inaccuracies
  {
    // error is small enough (less than 0.001) for this to be OK
    // ideally you would choose between y_p_0 and y_p_1 if y_p_1 < 0.7399f depending on which is closer to 0.7399f
    // or between y_p_1 and y_p_2 if y_p_1 > 0.9909f depending on which is closer to 0.9909f
    y_p = y_p_1;

    // this clamps it to 2 float steps above 0.7399f or 2 float steps below 0.9909f
    // if (y_p_1 < 0.7399f)
    //	y_p = 0.7399001f;
    // else
    //	y_p = 0.99089986f;
  }

  // Tone mapping step 1 (inverse)
  // get Y'
  const float p_hdr = 1 + 32 * pow(target_nits / 10000.f, gamma);
  // Y'
  const float y_ = (pow(p_hdr, y_p) - 1) / (p_hdr - 1);

  // Colour scaling function
  float col_scale = y_ > 0 ? y_sdr / (1.1f * y_) : 1.f;

  // Colour difference signals (inverse) and Luma (inverse)
  // get R'G'B'
  color = (chromas_bt2020 * chromas_sdr) / col_scale + y_;
  // color.b = ((c_b_tmo * k_bt2020_b_helper) / col_scale) + y_;
  // color.r = ((c_r_tmo * k_bt2020_r_helper) / col_scale) + y_;
  // color.g = (y_ - (k_bt2020.r * color.r + k_bt2020.b * color.b)) / k_bt2020.g;

  // safety
  //  color.r = clamp(color.r, 0.f, 1.f);
  //  color.g = clamp(color.g, 0.f, 1.f);
  //  color.b = clamp(color.b, 0.f, 1.f);

  color = saturate(color);

  // R'G'B' gamma expansion
  color = pow(color, inverse_gamma);

  // map target luminance into 10000 nits
  color = color * target_nits;

  return color;
}

float3 BT709(float3 bt709, float sdr_nits, float target_nits) {
  float3 bt2020 = renodx::color::bt2020::from::BT709(bt709);
  float3 new_color = BT2020(bt2020, sdr_nits, target_nits);
  return renodx::color::bt709::from::BT2020(new_color);
}

}  // namespace bt2446a
}  // namespace inverse
}  // namespace tonemap
}  // namespace renodx
