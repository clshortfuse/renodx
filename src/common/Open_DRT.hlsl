
/*  OpenDRT -------------------------------------------------/
      v0.2.8
      Written by Jed Smith
      https://github.com/jedypod/open-display-transform

      License: GPL v3
-------------------------------------------------*/

// Gamut Conversion Matrices

/* Math helper functions ----------------------------*/

#define LOG_OF_2 0.6931471805599453f
#define LOG_OF_100 4.605170185988092f

// // Safe division of float a by float b
// float sdivf(float a, float b) {
//   if (b == 0.0f) return 0.0f;
//   else return a/b;
// }

// // Safe division of float3 a by float b
// float3 sdivf3f(float3 a, float b) {
//   return float3(sdivf(a.x, b), sdivf(a.y, b), sdivf(a.z, b));
// }

// // Safe division of float3 a by float3 b
// float3 sdivf3f3(float3 a, float3 b) {
//   return float3(sdivf(a.x, b.x), sdivf(a.y, b.y), sdivf(a.z, b.z));
// }

// Safe power function raising float a to power float b
// Never returns negative [0+]
// float spowf(float a, float b) {
//   return pow(abs(a), b);
// }


// [0-2]
float3 narrow_hue_angles(float3 v) {
  // Refactor: Clamp and vector subtraction
  // return float3(
  //   min(2.0f, max(0.0f, v.x - (v.y + v.z))),
  //   min(2.0f, max(0.0f, v.y - (v.x + v.z))),
  //   min(2.0f, max(0.0f, v.z - (v.x + v.y))));
  return clamp(v - float3(
    (v.y + v.z),
    (v.x + v.z),
    (v.x + v.y)
  ), 0, 2.f);
}

// [0+]
float tonescale(float x, float m, float s, float c) {
  // Perf spowf not needed
  return pow(m*x/(x + s), c);
}

// x is tonescale which is >=0 [0+]
float flare(float x, float fl) {
  return (x*x) / (x+fl);
}

// If x>=0 returns >=0
float flare_invert(float x, float fl) {
  return (x + sqrt(x * ((4.0f * fl) + x))) / 2.0f;
}

// // https://www.desmos.com/calculator/jrff9lrztn
// float powerptoe(float x, float p, float m, float t0) {
//   return (x > t0)
//     ? x
//     : ((x - t0) * spowf(spowf((t0 - x) / (t0 - m), 1.0f / p) + 1.0f, -p) + t0);
// }

// p = 0.05, m = -0.05, t0 = 1.f
// [0.01586+]
float powerptoe_fixed(float x) {
  if (x > 1.f) return x;
  return ((x - 1.f) * pow(pow((1.f - x) / (1.05f), 1.0f / 0.05f) + 1.0f, -0.05f) + 1.f);
}

/* Shadow Contrast
    Invertible cubic shadow exposure function
    https://www.desmos.com/calculator/ubgteikoke
    https://colab.research.google.com/drive/1JT_-S96RZyfHPkZ620QUPIRfxmS_rKlx
*/
float3 shd_con(float3 rgb, float ex, float str) {
  // Parameter setup
  const float m = exp2(ex);
  // Perf: explicit cube
  // const float w = pow(str, 3.0f);
  const float w = str * str * str;

  const float n = max(rgb.x, max(rgb.y, rgb.z));
  const float n2 = n*n;
  const float dividend = n2 + w;
  const float s = dividend ? (n2 + m*w) / dividend : 1.f; // Implicit divide by n
  return rgb * s;
}


/* Highlight Contrast
    Invertible quadratic highlight contrast function. Same as ex_high without lin ext
    https://www.desmos.com/calculator/p7j4udnwkm
*/
float3 hl_con(float3 rgb, float ex, float th) {
  // Parameter setup
  const float p = exp2(-ex);
  const float t0 = 0.18f*exp2(th);
  const float a = pow(t0, 1.0f - p)/p;
  const float b = t0*(1.0f - 1.0f/p);

  const float n = max(rgb.x, max(rgb.y, rgb.z));
  if (n == 0.0f || n < t0) return rgb;
  return rgb * (pow((n - b)/a, 1.0f/p) / n);
}

float3 ex_high(float3 rgb, float ex, float pv, float fa) {
  // Zoned highlight exposure with falloff : https://www.desmos.com/calculator/ylq5yvkhoq

  // Parameter setup
  const float f = 5.0f * pow(fa, 1.6f) + 1.0f;
  const float p = abs(ex + f) < 1e-8f ? 1e-8f : (ex + f) / f;
  const float m = exp2(ex);
  const float t0 = 0.18f * exp2(pv);
  const float a = pow(t0, 1.0f - p) / p;
  const float b = t0 * (1.0f - 1.0f / p);
  const float x1 = t0 * exp2(f);
  const float y1 = a * pow(x1, p) + b;

  // Calculate scale factor for rgb
  const float n = max(rgb.x, max(rgb.y, rgb.z));
  if (n < t0) return rgb;
  if (n > x1) return rgb * ((m * (n - x1) + y1) / n);
  return rgb * ((a * pow(n, p) + b) / n);
}

// Adjust to ACES Highlights
float3 apply_aces_highlights(float3 rgb) {
  rgb = ex_high(rgb, -0.55f, -6.0f, 0.5f);
  rgb = ex_high(rgb, 0.5f, -3.0f, 0.5f);
  rgb = ex_high(rgb, 0.924f, -1.0f, 0.5f);
  rgb = ex_high(rgb, -0.15f, 2.68f, 0.19f);
  return rgb;
}

float3 apply_user_shadows(float3 rgb, float shadows = 1.f) {
  // Perf: explicit cube
  // rgb = shd_con(rgb, -1.8f, pow(2.f - shadows, 3) * 0.04); // 0.04 @ 1
  rgb = shd_con(rgb, -1.8f, pow(2.f - shadows, 4.f) * 0.025); // 0.04 @ 1
  rgb = shd_con(rgb, -0.50f * shadows * (1.f - shadows), 0.25f); // 0 @ 1

  return rgb;
}

float3 apply_user_highlights(float3 rgb, float highlights = 1.f) {
  rgb = hl_con(rgb, highlights, 2.f);
  return rgb;
}

float3 open_drt_transform(
  float3 rgb,
  float Lp = 100.f,
  float gb = 0.12,
  float contrast = 1.f
  )
{

  // **************************************************
  // Parameter Setup
  // --------------------------------------------------

  // Dechroma

  const static float dch = 0.40f; // 0.40f

  // Chroma contrast
  const static float chc_p = 1.2f; // 1.2 // amount of contrast
  const static float chc_m = 0.5f; // 0.5 // pivot of contrast curve

  // Tonescale parameters
  const float c = 1.1f * contrast; // 1.1 contrast
  const static float fl = 0.01f; // flare/glare compensation

  // Weights: controls the "vibrancy" of each channel, and influences all other aspects of the display-rendering.
  const float3 static weights = float3(
    0.25f, // 0.25
    0.45f, // 0.45
    0.30f  // 0.30
  );

  // Weights are assumed add to 1, but also affect vibrancy.
  // Use sum to later correct lum
  float weightSum = weights.x + weights.y + weights.z;

  // Hue Shift RGB controls
  float3 static hs = float3(
    0.30f, // 0.30f
    -0.10f,   // -0.1f
    -0.50f   // -0.5f
  );
  
  /* Tonescale Parameters 
      ----------------------
    For the tonescale compression function, we use one inspired by the wisdom shared by Daniele Siragusano
    on the tonescale thread on acescentral: https://community.acescentral.com/t/output-transform-tone-scale/3498/224

    This is a variation which puts the power function _after_ the display-linear scale, which allows a simpler and exact
    solution for the intersection constraints. The resulting function is pretty much identical to Daniele's but simpler.
    Here is a desmos graph with the math. https://www.desmos.com/calculator/hglnae2ame

    And for more info on the derivation, see the "Michaelis-Menten Constrained" Tonescale Function here:
    https://colab.research.google.com/drive/1aEjQDPlPveWPvhNoEfK4vGH5Tet8y1EB#scrollTo=Fb_8dwycyhlQ

    For the user parameter space, we include the following creative controls:
    - Lp: display peak luminance. This sets the display device peak luminance and allows rendering for HDR.
    - contrast: This is a pivoted power function applied after the hyperbolic compress function, 
        which keeps middle grey and peak white the same but increases contrast in between.
    - flare: Applies a parabolic toe compression function after the hyperbolic compression function. 
        This compresses values near zero without clipping. Used for flare or glare compensation.
    - gb: Grey Boost. This parameter controls how many stops to boost middle grey per stop of peak luminance increase.

    Notes on the other non user-facing parameters:
    - (px, py): This is the peak luminance intersection constraint for the compression function.
        px is the input scene-linear x-intersection constraint. That is, the scene-linear input value 
        which is mapped to py through the compression function. By default this is set to 128 at Lp=100, and 256 at Lp=1000.
        Here is the regression calculation using a logarithmic function to match: https://www.desmos.com/calculator/chdqwettsj
    - (gx, gy): This is the middle grey intersection constraint for the compression function.
        Scene-linear input value gx is mapped to display-linear output gy through the function.
        Why is gy set to 0.11696 at Lp=100? This matches the position of middle grey through the Rec709 system.
        We use this value for consistency with the Arri and TCAM Rec.1886 display rendering transforms.
  */

  // input scene-linear peak x intercept
  float px = 256.0*log(Lp)/LOG_OF_100 - 128.0f;
  // output display-linear peak y intercept
  float py = Lp/100.0f;
  // input scene-linear middle grey x intercept
  float gx = 0.18f;
  // output display-linear middle grey y intercept
  float gy = 11.696f/100.0f*(1.0f + gb*log(py)/LOG_OF_2);
  // s0 and s are input x scale for middle grey intersection constraint
  // m0 and m are output y scale for peak white intersection constraint
  float s0 = flare_invert(gy, fl); // [0+]
  float m0 = flare_invert(py, fl); // [0+]
  const float ip = 1.0f/c;
  float m0_ip = pow(m0, ip); // [0+]
  float s0_ip = pow(s0, ip); // [0+]
  // Perf: Store pow(m0, ip) and pow(s0, ip)
  // float s = (px*gx*(m0_ip - s0_ip))/(px*s0_ip - gx*m0_ip);
  float s = (px*gx*(m0_ip - s0_ip))/(px*s0_ip - gx*m0_ip);
  float m = m0_ip*(s + px)/px;



  /* Rendering Code ------------------------------------------ */

  // Convert into display gamut
  // rgb = mul(in_to_xyz, rgb);
  // rgb = mul(xyz_to_display, rgb);

  /* Take the the weighted sum of RGB. The weights
      scale the vector of each color channel, controlling the "vibrancy".
      We use this as a vector norm for separating color and intensity.
  */ 
  
  // Perf: Use dot for mult+add
  // weights *= rgb; // multiply rgb by weights
  // float lum = max(1e-8f, weights.x + weights.y + weights.z); // take the norm
  // Perf: Use safe division later instead of max
  float lum = dot(rgb, weights); // take the norm

  // Correct the unbalanced weights
  lum *= 1.f / weightSum;

  // RGB Ratios
  // Perf: lum is > 0 (1e-8f)
  // float3 rats = sdivf3f(rgb, lum);
  // Perf: If rgb is zero, ratio is actually 1:1:1, also avoid divide by 0
  // TODO: Support negative input channels
  float3 rats = lum ? rgb / lum : 1.f;

  // Apply tonescale function to lum
  float ts;
  ts = tonescale(lum, m, s, c); // [0+]
  ts = flare(ts, fl); // [0+]

  // Normalize so peak luminance is at 1.0
  ts *= 100.0f/Lp;

  // Clamp ts to display peak
  // Required when using low contrast
  ts = min(1.0f, ts); // [0-1]

  /* Gamut Compress ------------------------------------------ *
    Most of our data is now inside of the display gamut cube, but there may still be some gradient disruptions
    due to highly chromatic colors going outside of the display cube on the lower end and then being clipped
    whether implicitly or explicitly. To combat this, our last step is to do a soft clip or gamut compression.
    In RGB Ratios, 0,0,0 is the gamut boundary, and anything outside of gamut will have one or more negative 
    components. So to compress the gamut we use lift these negative values and compress them into a small range
    near 0. We use the "PowerP" hyperbolic compression function but it could just as well be anything.
  */

  // Perf: Fold in values to avoid spowf
  // rats.x = powerptoe(rats.x, 0.05f, -0.05f, 1.0f);

  // Perf: Input and Output gamut are the same, skip compression
  // rats.x = powerptoe_fixed(rats.x);
  // rats.y = powerptoe_fixed(rats.y);
  // rats.z = powerptoe_fixed(rats.z);

  /* Calculate RGB CMY hue angles from the input RGB.
    The classical way of calculating hue angle from RGB is something like this
    mx = max(r,g,b)
    mn = min(r,g,b)
    c = mx - mn
    hue = (c==0?0:r==mx?((g-b)/c+6)%6:g==mx?(b-r)/c+2:b==mx?(r-g)/c+4:0)
    With normalized chroma (distance from achromatic), being calculated like this
    chroma = (mx - mn)/mx
    chroma can also be calculated as 1 - mn/mx

    Here we split apart the calculation for hue and chroma so that we have access to RGB CMY
    individually without having to linear step extract the result again.

    To do this, we first calculate the "wide" hue angle: 
      wide hue RGB = (RGB - mn)/mx
      wide hue CMY = (mx - RGB)/mx
    and then "narrow down" the hue angle for each with channel subtraction (see narrow_hue_angles() function).
  */
  
  const float mx = max(rats.x, max(rats.y, rats.z));
  const float mn = min(rats.x, min(rats.y, rats.z));

  // Perf: rats > 0.01
  // float3 rats_h = sdivf3f(rats - mn, mx);
  float3 rats_h = (rats - mn) / mx;
  rats_h = narrow_hue_angles(rats_h);

  // Calculate "Chroma" (the normalized distance from achromatic).
  // Perf: rats > 0.01
  // float rats_ch = 1.0f - sdivf(mn, mx);
  float rats_ch = 1.0f - (mn / mx);


  /* Chroma Value Compression ------------------------------------------ *
      RGB ratios may be greater than 1.0, which can result in discontinuities in highlight gradients.
      We compensate for this by normalizing the RGB Ratios so that max(r,g,b) does not exceed 1, and then mix
      the result. The factor for the mix is derived from tonescale * chroma, then taking only the top end of
      this with a compression function, so that we normalize only bright and saturated pixels.
  */

  // Normalization mix factor based on ccf * rgb chroma, smoothing transitions between r->g hue gradients

  // Perf: narrow_hue_angles ensures rats_h is never negative, no need for safe pow
  // float chf = ts*max(spowf(rats_h.x, 2.0f), max(spowf(rats_h.y, 2.0f), spowf(rats_h.z, 2.0f)));
  // float chf = ts*max(rats_h.x * rats_h.x, max(rats_h.y *  rats_h.y, rats_h.z *  rats_h.z));
  // Perf: All values squared is self*self
  float3 rats_h2 = rats_h * rats_h;
  float chf = ts * max(rats_h2.x, max(rats_h2.y, rats_h2.z)); // [0+]
  
  const float chf_m = 0.25f;
  const float chf_p = 0.65f;
  // Perf: chf is never negative
  // chf = 1.0f - spowf(spowf(chf/chf_m, 1.0f/chf_p)+1.0f, -chf_p);
  chf = 1.0f - pow(pow(chf/chf_m, 1.0f/chf_p)+1.0f, -chf_p);

  // Max of rgb ratios
  // Perf: rats is unchanged, use mx
  // float rats_mx = max(rats.x, max(rats.y, rats.z));
  float rats_mx = mx;

  // Normalized rgb ratios
  // Perf: rats is > 0.01
  // float3 rats_n = sdivf3f(rats, rats_mx);
  float3 rats_n = (rats / rats_mx);

  // Mix based on chf
  rats = rats_n*chf + rats*(1.0f - chf);


  /* Chroma Compression ------------------------------------------ *
      Here we set up the chroma compression factor, used to lerp towards 1.0
      in RGB Ratios, thereby compressing color towards display peak.
      This factor is driven by ts, biased by a power function to control chroma compression amount `dch`.
  */
  // float ccf = 1.0f - pow(ts, 1.0f/dch);
  // float ccf = 1.0f - (pow(ts, 1.0f/dch)*(1.0f-ts) + ts*ts);
  float overallDechroma = 1.f;
  float dechromaDelay = 3.f;
  float dechromaStrength = 0.15f;
  float dechromaBias = 0.10f;
  float ccf = 1.0f - overallDechroma*(pow(ts, dechromaDelay/dch)*(1.0f-ts*dechromaStrength) + ts*ts*dechromaBias);

  // Apply chroma compression to RGB Ratios
  rats = rats*ccf + 1.0f - ccf;


  /* Chroma Compression Hue Shift ------------------------------------------ *
      Since we compress chroma by lerping in a straight line towards 1.0 in rgb ratios, this can result in perceptual hue shifts
      due to the Abney effect. For example, pure blue compressed in a straight line towards achromatic appears to shift in hue towards purple.

      To combat this, and to add another important user control for image appearance, we add controls to curve the hue paths 
      as they move towards achromatic. We include only controls for primary colors: RGB. In my testing, it was of limited use to
      control hue paths for CMY.

      To accomplish this, we use the inverse of the chroma compression factor multiplied by the RGB hue angles as a factor
      for a lerp between the various rgb components.

      We don't include the toe chroma compression for this hue shift. It is mostly important for highlights.
  */
  float3 hsf = ccf*rats_h;
  
  // Apply hue shift to RGB Ratios
  float3 rats_hs = float3(
    rats.x + hsf.z*hs.z - hsf.y*hs.y,
    rats.y + hsf.x*hs.x - hsf.z*hs.z,
    rats.z + hsf.y*hs.y - hsf.x*hs.x
  );

  // Mix hue shifted RGB ratios by ts, so that we shift where highlights were chroma compressed plus a bit.
  rats = rats_hs*ts + rats*(1.0f - ts);


  /* Chroma Contrast
      Without this step, mid-range chroma in shadows and midtones looks too grey and dead.
      This is common with chromaticity-linear view transforms.
      In order to improve skin-tone rendering and overal "vibrance" of the image, which we
      are used to seeing with per-channel style view transforms, we boost mid-range chroma
      in shadows and midtones using a "chroma contrast" setup.
      
      Basically we take classical chroma (distance from achromatic), we take the compressed tonescale curve, 
      and we apply a contrast to the tonescale curve mixed by a parabolic center extraction of chroma, 
      so that we do not boost saturation at grey (increases noise), nor do we boost saturation of highly
      saturated colors which might already be near the edge of the gamut volume.
  */
  float chc_f = 4.0f*rats_ch*(1.0f - rats_ch);
  // Perf: chc_m is > 0
  // float chc_sa = min(2.0f, sdivf(lum, chc_m*spowf(sdivf(lum, chc_m), chc_p)*chc_f + lum*(1.0f - chc_f)));
  // float chc_sa = min(2.0f, sdivf(lum, chc_m*spowf(lum / chc_m, chc_p)*chc_f + lum*(1.0f - chc_f)));
  // Perf: lum is > 0 && chc_f < 1
  float chc_sa = min(2.0f, lum / (chc_m * pow(lum / chc_m, chc_p)*chc_f + lum*(1.0f - chc_f)));
  // Perf: use dot for mult+add
  // float chc_L = 0.23f*rats.x + 0.69f*rats.y + 0.08f*rats.z; // Roughly P3 weights, doesn't matter
  const static float3 chc_L_weights = float3(0.21f, 0.71f, 0.072f); // Roughly P3 weights, doesn't matter
  float chc_L = dot(rats, chc_L_weights);

  // Apply mid-range chroma contrast saturation boost
  rats = chc_L*(1.0f - chc_sa) + rats*chc_sa;

  // Apply tonescale to RGB Ratios
  rgb = rats*ts;

  // Clamp:
  // Colors below 0 are not yet supported (and will be clipped).
  // Colors past 1 could introduce hue shift but should be done externally
  // Despite being 0-1, output range does not mean SDR range.
  // Output is still scene-linear, only compressed to output range.
  rgb = saturate(rgb);

  return rgb;
}


float3 open_drt_transform_custom(
  float3 rgb,
  float peakNits = 203.f,
  float midGrayAdjustment = 1.f,
  float contrast = 1.f,
  float highlights = 0.575f,
  float shadows = 1.f
  )
{
  rgb = apply_user_shadows(rgb, shadows);
  rgb = apply_user_highlights(rgb, (2.f * highlights - 1.15f) * 203.f/peakNits);
  rgb = open_drt_transform(
    rgb * midGrayAdjustment,
    peakNits,
    (0.12f * 203.f/peakNits),
    contrast
  );

  return rgb;
}
