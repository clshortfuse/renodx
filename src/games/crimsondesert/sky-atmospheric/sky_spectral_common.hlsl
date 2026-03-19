#ifndef SKY_LMS_COMMON_HLSL_
#define SKY_LMS_COMMON_HLSL_

#include "../shared.h"

// ============================================================================
// Spectral atmospheric scattering support
// Based on Garcia Linan, "Real time spectral rendering of the atmospheric medium"
// Adapted to 3-wavelength (630nm, 560nm, 490nm) pipeline.
// ============================================================================

// --- Rayleigh β ratios (Bucholtz 1995, relative to 490nm reference) ----------
static const float SKY_RAYLEIGH_CH1 = 0.3585776330f;  // 630nm
static const float SKY_RAYLEIGH_CH2 = 0.5792616721f;  // 560nm
static const float SKY_RAYLEIGH_CH3 = 1.0000000000f;  // 490nm (reference)

// --- Ozone absorption constants (game units, Gorshelev et al. 2014) ----------
static const float SKY_OZONE_CH1 = 4.416554727381943e-06f;  // 630nm
static const float SKY_OZONE_CH2 = 4.978800461685751e-06f;  // 560nm
static const float SKY_OZONE_CH3 = 1.715994333881982e-06f;  // 490nm

// --- Spectral → BT.2020 conversion matrix ------------------------------------
// = normalize( M_xyz_to_bt2020 × M_cmf_riemann_weights )
// CIE 1931 2° CMFs at 630/560/490nm, midpoint Riemann partition, Y-row sum = 1.
static const float3x3 SKY_SPECTRAL_TO_BT2020 = float3x3(
    1.4694646167f,  0.3669925672f, -0.2165157196f,
    0.0001303464f,  0.6682570564f,  0.3316125972f,
   -0.0000034055f, -0.0156549124f,  0.8974954385f
);

// --- Vanilla constants (for toggle fallback) ---------------------------------
static const float3x3 SKY_VANILLA_BT709_TO_BT2020 = float3x3(
    0.6131200194358826f,  0.3395099937915802f,  0.047370001673698425f,
    0.07020000368356705f, 0.9163600206375122f,  0.013450000435113907f,
    0.02061999961733818f, 0.10958000272512436f, 0.8697999715805054f
);

// --- Convenience macros: select spectral vs vanilla constants ----------------
#define SKY_OZONE_1 (SKY_SCATTERING ? SKY_OZONE_CH1 : 2.05560013455397e-06f)
#define SKY_OZONE_2 (SKY_SCATTERING ? SKY_OZONE_CH2 : 4.978800461685751e-06f)
#define SKY_OZONE_3 (SKY_SCATTERING ? SKY_OZONE_CH3 : 2.1360001767334325e-07f)

// --- Transmittance matrix: always vanilla BT.709→BT.2020 ---------------------
// Transmittance is multiplicative (applied to display-space scene colour), so the
// matrix must preserve row sums ≈ 1.0. The spectral matrix has row[0] sum = 1.62
// which would create T > 1 (physically impossible for extinction).
#define _sky_mtx SKY_VANILLA_BT709_TO_BT2020

// --- In-scatter helper macros (Garcia Linan split path) ----------------------
// Rayleigh in-scatter is TRUE spectral data → use spectral→BT.2020 matrix.
// Mie in-scatter is display-space BT.709 colour → use vanilla matrix.
//
// Garcia Linan formulation for in-scatter:
//   L_display[row] = Σᵢ M_spectral[row][i] × T(λᵢ) × β(λᵢ) × phase
//                  + (Σᵢ M_vanilla[row][i] × T(λᵢ)) × S_mie[row_colour]

// Spectral Rayleigh: per-wavelength T×β then matrix-convert to display
#define SKY_RAY_INSCATTER(row, T0,T1,T2, b0,b1,b2, phase) \
  (SKY_SPECTRAL_TO_BT2020[row][0]*(T0)*(b0)*(phase) \
 + SKY_SPECTRAL_TO_BT2020[row][1]*(T1)*(b1)*(phase) \
 + SKY_SPECTRAL_TO_BT2020[row][2]*(T2)*(b2)*(phase))

// Vanilla BT.709→BT.2020 dot product (for Mie and transmittance paths)
#define SKY_VAN_DOT(row, T0,T1,T2) \
  (SKY_VANILLA_BT709_TO_BT2020[row][0]*(T0) \
 + SKY_VANILLA_BT709_TO_BT2020[row][1]*(T1) \
 + SKY_VANILLA_BT709_TO_BT2020[row][2]*(T2))

#endif  // SKY_LMS_COMMON_HLSL_
