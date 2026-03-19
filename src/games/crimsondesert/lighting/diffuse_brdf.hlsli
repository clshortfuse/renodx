// All functions return a scalar diffuse factor (no albedo weighting)
// The game's pipeline applies albedo downstream
// Multiply the return value by saturate(NdotL) externally if needed

#ifndef DIFFUSE_BRDF_HLSLI
#define DIFFUSE_BRDF_HLSLI

static const float RDXL_PI     = 3.14159265f;
static const float RDXL_INV_PI = 0.31830987334251404f;

// ============================================================================
// Hammon 2017 Diffuse BRDF (scalar)
// ----------------------------------------------------------------------------
// Earl Hammon Jr., GDC 2017
//
// Energy conserving diffuse with multi scatter compensation.
// Returns scalar: single + multi (no albedo, no NdotL).
// ============================================================================
float HammonDiffuseScalar(
    float NdotL, float NdotV, float NdotH, float VdotH,
    float roughness)
{
  float facing = 0.5f + 0.5f * VdotH;
  float rough  = facing * (0.9f - 0.4f * facing)
               * ((0.5f + NdotH) / max(NdotH, 0.1f));

  float oneMinusNdotL = 1.0f - NdotL;
  float NdotL5 = oneMinusNdotL * oneMinusNdotL;
  NdotL5 *= NdotL5 * oneMinusNdotL;

  float oneMinusNdotV = 1.0f - NdotV;
  float NdotV5 = oneMinusNdotV * oneMinusNdotV;
  NdotV5 *= NdotV5 * oneMinusNdotV;

  float smooth_val = 1.05f * (1.0f - NdotL5) * (1.0f - NdotV5);
  float single = lerp(smooth_val, rough, roughness) * RDXL_INV_PI;
  float multi  = 0.1159f * roughness;
  return single + multi;
}

// ============================================================================
// EON 2025 — Energy Preserving Oren Nayar Diffuse BRDF (scalar, exact)
// ----------------------------------------------------------------------------
// Portsmouth, Kutz & Hill 2025 — "EON: A Practical Energy Preserving
// Rough Diffuse BRDF"
//
// Uses the EXACT directional albedo (not polynomial approximation)
// Returns scalar: (f_ss + f_ms) with rho = 1 (no albedo, no NdotL)
//
// We use world space dot products but we did two intentional raster adaptations since 
// RT is kinda bad for Crimson + ran into issue with full EON
//
// - sovertF denominator is clamped to 0.1 minimum
// - f_ss is clamped to ≥ 0
//
// Game does scalar BRDF × albedo, we could fixing it but that would require passing 
// per channel albedo into the BRDF, which needs a restructuring
// ============================================================================

// FON constants
static const float EON_C1 = 0.5f - 2.0f / (3.0f * RDXL_PI); 
static const float EON_C2 = 2.0f / 3.0f - 28.0f / (15.0f * RDXL_PI); 

// FON Directional Albedo — Exact closed form
float EON_E_FON_Exact_L(float mu, float r)
{
  float AF = 1.0f / (1.0f + EON_C1 * r);
  float BF = r * AF;
  float Si = sqrt(max(1.0f - mu * mu, 0.0f));
  float G  = Si * (acos(clamp(mu, -1.0f, 1.0f)) - Si * mu)
           + (2.0f / 3.0f) * ((Si / max(mu, 1e-7f)) * (1.0f - Si * Si * Si) - Si);
  return AF + (BF * RDXL_INV_PI) * G;
}

// EON scalar evaluation (exact E_FON, rho = 1)
// NdotL, NdotV : saturated cos theta for light/view
// LdotV        : dot(L, V) — NOT saturated, can be negative
// roughness    : linear roughness [0,1]
float EON_DiffuseScalar(
    float NdotL, float NdotV, float LdotV, float roughness)
{
  float mu_i = NdotL;
  float mu_o = NdotV;

  // Azimuthal s-term: dot(wi, wo) - mu_i * mu_o
  // In tangent space: s = dot(wi_local, wo_local) - wi_local.z * wo_local.z
  // In world space:   s = dot(L, V) - NdotL * NdotV
  float s = LdotV - mu_i * mu_o;

  // FON s/t ratio — clamped denominator for stability.
  // The paper's formulation diverges when both mu_i and mu_o are small
  // (grazing foliage, complex geometry). Threshold 0.1 matches Hammon's approach
  // for NdotH and caps sovertF at s/0.1 ≈ 10 max
  float sovertF = (s > 0.0f) ? (s / max(max(mu_i, mu_o), 0.1f)) : s;

  // FON A coefficient
  float AF = 1.0f / (1.0f + EON_C1 * roughness);

  // Single scatter (rho = 1) — clamped to non negative.
  // Negative values occur when s is large negative (backlit geometry)
  // with high roughness: (1 + r * s) < 0.  The paper handles this
  // via multi scatter energy compensation, but with rho=1 scalar
  // mode the correction is imperfect.  Clamping f_ss ≥ 0 prevents
  // the darker than Lambert artifact
  float f_ss = max(0.0f, RDXL_INV_PI * AF * (1.0f + roughness * sovertF));

  // Directional albedos (exact)
  float EFo = EON_E_FON_Exact_L(mu_o, roughness);
  float EFi = EON_E_FON_Exact_L(mu_i, roughness);

  // Average albedo
  float avgEF = AF * (1.0f + EON_C2 * roughness);

  // Multi scatter with rho = 1:
  //   rho_ms = rho^2 * avgEF / (1 - rho * (1 - avgEF))
  //          = 1 * avgEF / (1 - 1 * (1 - avgEF))
  //          = avgEF / avgEF = 1
  //   f_ms = 1 * (1/PI) * (1-EFo) * (1-EFi) / (1-avgEF)
  float f_ms = RDXL_INV_PI
             * max(1e-7f, 1.0f - EFo)
             * max(1e-7f, 1.0f - EFi)
             / max(1e-7f, 1.0f - avgEF);

  return f_ss + f_ms;
}

// ============================================================================
// Callisto Smooth Terminator
// ----------------------------------------------------------------------------
// Taken from Striking Distance Studios — slides 90/98
// Softens the hard light/dark boundary on low poly geometry where
// interpolated normals create a visible faceted terminator line
// Returns scalar c2 that multiplies the entire BRDF (diffuse + specular)
//
// Solves some harsh lines that I saw from local lights
//
//   o — intensity [0,1] (0 = off, higher = smoother)
//   p — edge length [0,1] (default 0.5)
// ============================================================================
float CallistoSmoothTerminator(
    float NdotL, float VdotH, float NdotH,
    float o, float p)
{
  float d3 = 1.0f - VdotH;
  d3 = d3 * d3 * d3;
  float h3 = 1.0f - NdotH;
  h3 = h3 * h3 * h3;

  float alpha_s = (1.0f - d3) * (1.0f - h3);

  float edge      = alpha_s * p;
  float cosTheta_i = max(NdotL, 0.0f);
  float s          = smoothstep(0.0f, edge, cosTheta_i);

  return lerp(1.0f, s, alpha_s * o);
}

// ============================================================================
// Geometric Specular Anti Aliasing 
// ----------------------------------------------------------------------------
// Tokuyoshi & Kaplanyan 2021: "Improved Geometric Specular Anti Aliasing"
// Adapted for compute shaders using QuadReadAcrossX/Y instead of ddx/ddy
//
// Widens roughness based on screen space normal derivatives to eliminate
// specular shimmer on distant surfaces where normals alias at sub pixel
//
// This does more than just AA since the base game nuked specular details on
// some meshes and decals like puddles during the night
//
//   normalWS  — world space shading normal (normalised)
//   roughness — linear roughness [0,1]
//   strength  — user control [0,1]: 0=off, 1=full filtering
//
// Returns: filtered linear roughness
// ============================================================================
float NDFFilterRoughnessCS(
    float3 normalWS,
    float  roughness,
    float  strength)
{
  // Approximate screen space derivatives via wave quad intrinsics
  float3 dndu = QuadReadAcrossX(normalWS) - normalWS;
  float3 dndv = QuadReadAcrossY(normalWS) - normalWS;

  static const float SIGMA2 = 0.15915494f;  // 1/(2pi)
  float kernelRoughness2 = 2.0f * SIGMA2 * (dot(dndu, dndu) + dot(dndv, dndv));

  // kappa = 0.18 clamping threshold 
  static const float KAPPA = 0.18f;
  float clampedKernel = min(kernelRoughness2, KAPPA) * strength;

  float alpha  = roughness * roughness;
  float alpha2 = saturate(alpha * alpha + clampedKernel);
  return sqrt(sqrt(alpha2)); 
}

// ============================================================================
// Diffraction on Rough Surfaces (Werner et al. 2024, JCGT)
// ----------------------------------------------------------------------------
// Spectral shift + speckle noise for metallic specular highlights.
// 
// Since we dont have access to per metal, we use F0 aware. This allows us to
// still have metal dependant hue shifts
//
// neutral metal - red to blue
// gold - yellow to orange/red
// ect
//
// Paper params (Table 1):
//   Rough (α≈0.39): w=2.3394, h=0.001025
//   Smooth (α≈0.14): w=6.4455, h=0.00077
//   shiftScatter = (1.0, 0.88, 0.76), shiftIntensity = (0.95, 1.0, 1.05)
// ============================================================================

// 3D Simplex Noise (Gustavson) — for RGB speckle
float4 _dfr_permute4(float4 x) { return fmod((x * 34.0 + 1.0) * x, 289.0); }
float4 _dfr_taylorInvSqrt(float4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

float _dfr_snoise3(float3 v)
{
  static const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);
  float3 i  = floor(v + dot(v, C.yyy));
  float3 x0 = v - i + dot(i, C.xxx);
  float3 g  = step(x0.yzx, x0.xyz);
  float3 l  = 1.0 - g;
  float3 i1 = min(g, l.zxy);
  float3 i2 = max(g, l.zxy);
  float3 x1 = x0 - i1 + C.xxx;
  float3 x2 = x0 - i2 + C.yyy;
  float3 x3 = x0 - 0.5;
  i = fmod(i, 289.0);
  float4 p = _dfr_permute4(
    _dfr_permute4(
      _dfr_permute4(
        i.z + float4(0.0, i1.z, i2.z, 1.0))
      + i.y + float4(0.0, i1.y, i2.y, 1.0))
    + i.x + float4(0.0, i1.x, i2.x, 1.0));
  float4 j  = p - 49.0 * floor(p / 49.0);
  float4 x_ = floor(j / 7.0);
  float4 y_ = floor(j - 7.0 * x_);
  float4 gx = x_ / 7.0 + 1.0 / 14.0 - 0.5;
  float4 gy = y_ / 7.0 + 1.0 / 14.0 - 0.5;
  float4 gz = 1.0 - abs(gx) - abs(gy);
  float4 b0 = float4(gx.xy, gy.xy);
  float4 b1 = float4(gx.zw, gy.zw);
  float4 s0 = floor(b0) * 2.0 + 1.0;
  float4 s1 = floor(b1) * 2.0 + 1.0;
  float4 sh = -step(gz, 0.0);
  float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
  float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
  float3 g0 = float3(a0.xy, gz.x);
  float3 g1 = float3(a0.zw, gz.y);
  float3 g2 = float3(a1.xy, gz.z);
  float3 g3 = float3(a1.zw, gz.w);
  float4 norm = _dfr_taylorInvSqrt(float4(
      dot(g0, g0), dot(g1, g1), dot(g2, g2), dot(g3, g3)));
  g0 *= norm.x;  g1 *= norm.y;  g2 *= norm.z;  g3 *= norm.w;
  float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1),
                               dot(x2, x2), dot(x3, x3)), 0.0);
  m = m * m;
  return 42.0 * dot(m * m, float4(dot(g0, x0), dot(g1, x1),
                                   dot(g2, x2), dot(g3, x3)));
}

// spectral shift + speckle + F0 aware hue modulation.
// Returns float3 modifier centered around 1.0 to multiply into specular.
float3 DiffractionShiftAndSpeckleCS(
    float  NdotH,
    float  NdotV,
    float  roughness,
    float2 screenUV,
    float  linearDepth,
    float3 halfVec,
    float3 normal,
    float3 F0)
{
  // -- Roughness interpolated params (paper Table 1) --
  float t = saturate((0.3922 - roughness) / (0.3922 - 0.14033));
  float w = lerp(2.3394, 6.4455, t);
  float h = lerp(0.001025, 0.00077, t);
  static const float3 shiftScatter   = float3(1.0, 0.88, 0.76);
  static const float3 shiftIntensity = float3(0.95, 1.0, 1.05);

  // -- Spectral shift (paper Eq. 7) --
  float thetaM = acos(NdotH);
  float cosWT  = cos(w * thetaM);
  float3 rawShift = shiftScatter * cosWT * h + shiftIntensity;
  float3 shiftDev = rawShift - 1.0;

  // -- F0-aware hue modulation --
  float  F0avg  = max(dot(F0, float3(0.333, 0.333, 0.333)), 0.01);
  float3 F0norm = F0 / F0avg;
  float  chromaSpread = max(max(F0norm.x, F0norm.y), F0norm.z)
                      - min(min(F0norm.x, F0norm.y), F0norm.z);
  float  coloredness  = saturate(chromaSpread * 1.5);
  float3 coloredDev   = (F0norm - 1.0) * abs(shiftDev.x + shiftDev.z) * 0.5;
  float3 finalDev     = lerp(shiftDev, coloredDev, coloredness);
  float3 shift        = 1.0 + finalDev * 4.0 * 0.7;

  // -- Speckle noise (paper Listing 2, compute-shader path) --
  float uvScale = lerp(500.0, 800.0, t);
  float2 scaledUV = screenUV * uvScale;

  // Screen space derivatives via quad intrinsics
  float2 duvdx = QuadReadAcrossX(scaledUV) - scaledUV;
  float2 duvdy = QuadReadAcrossY(scaledUV) - scaledUV;
  float  delta_uv = max(length(duvdx), length(duvdy));
  float  sqrtSPP  = delta_uv * 2.0;  // / UV_TO_SPECKLE_FACTOR(0.5)

  // Amplitude reduction (paper Eq. 14)
  float ampMod = 1.0 - saturate(max(sqrtSPP - 1.0, 0.0));

  // Polar encoded half vector for view/light dependent pattern (paper §5.2)
  float  hr = length(halfVec);
  float  h_a = (atan2(halfVec.y, halfVec.x) - atan2(normal.y, normal.x)) * 7.0;
  float  h_p = (asin(clamp(halfVec.z / max(hr, 1e-7), -1.0, 1.0))
              - asin(clamp(normal.z / max(length(normal), 1e-7), -1.0, 1.0))) * 7.0;

  // Sample noise — 3 decorrelated channels
  float3 noise = float3(0.0, 0.0, 0.0);
  if (sqrtSPP <= 1.0) {
    noise.r = _dfr_snoise3(float3(scaledUV, h_a));
    noise.g = _dfr_snoise3(float3(scaledUV + 17.3, h_a + 7.1));
    noise.b = _dfr_snoise3(float3(scaledUV + 31.7, h_p));
  } else if (sqrtSPP <= 2.0) {
    // Transition: 4-tap multisample
    static const float2 msOff[4] = {
      float2(-0.25, -0.25), float2(0.25, -0.25),
      float2(-0.25,  0.25), float2(0.25,  0.25)
    };
    [unroll] for (int s = 0; s < 4; s++) {
      float2 uv = scaledUV + msOff[s] * delta_uv;
      noise.r += _dfr_snoise3(float3(uv, h_a));
      noise.g += _dfr_snoise3(float3(uv + 17.3, h_a + 7.1));
      noise.b += _dfr_snoise3(float3(uv + 31.7, h_p));
    }
    noise *= 0.25;
  }

  // Covariance scaling (paper Eq. 12) — floored so speckle is visible at highlight peak
  float covCos = cos(w * thetaM);
  float covScale = sqrt(max(1.0 - covCos * covCos, 0.15)) * lerp(0.5, 0.3, t);
  noise *= covScale * ampMod;

  // F0 tinted speckle
  float3 speckleTint = lerp(float3(1.0, 1.0, 1.0), F0norm, coloredness * 0.5);
  float3 speckle = noise * 0.5 * speckleTint;

  return shift + speckle;
}

#endif  // DIFFUSE_BRDF_HLSLI
