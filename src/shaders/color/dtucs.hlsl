#ifndef RENODX_SHADERS_COLOR_DTUCS_HLSL
#define RENODX_SHADERS_COLOR_DTUCS_HLSL

#include "../math.hlsl"
#include "./rgb.hlsl"

namespace renodx {
namespace color {
//  Copyright 2022 - Aurélien PIERRE / darktable project
//  URL: https://eng.aurelienpierre.com/2022/02/color-saturation-control-for-the-21th-century/
//  The following source code is released under the MIT license
//  (https://opensource.org/licenses/MIT) with the following addenda:
//  * Any reuse of this code shall include the names of the author and of the project, as well as the source URL,
//  * Any implementation of this colour space MUST call it "darktable Uniform Color Space" or
//    "darktable UCS" in the end - user interface of the software.
namespace dtucs {
const static float L_WHITE_VALUE = 1.f;
const static float L_WHITE_HAT = pow(L_WHITE_VALUE, 0.631651345306265f);
const static float L_WHITE = (2.098883786377f * L_WHITE_HAT) / (L_WHITE_HAT + 1.12426773749357f);

namespace uvY {
namespace from {
static const float3x3 xyToUVD = {
  -0.783941002840055f, 0.277512987809202f, 0.153836578598858f,
  0.745273540913283f, -0.205375866083878f, -0.165478376301988f,
  0.318707282433486f, 2.16743692732158f, 0.291320554395942f
};

static const float2x2 UVStarToUVStarPrime = {
  -1.124983854323892f, -0.980483721769325f,
  1.86323315098672f, 1.971853092390862f
};

float3 BT709(float3 bt709) {
  float3 xyY = xyY::from::BT709(bt709);
  float3 value;
  if (xyY[2] == 0.f) {
    value = 0;
  } else {
    float3 UVD = mul(xyToUVD, float3(xyY.xy, 1.f));

    float2 UV = UVD.xy / UVD.z;

    float2 UVStar = float2(1.39656225667f, 1.4513954287f) * UV / (abs(UV) + float2(1.49217352929f, 1.52488637914f));

    float2 UVStarPrime = mul(UVStarToUVStarPrime, UVStar);

    value = float3(UVStarPrime, xyY[2]);
  }
  return value;
}
}  // namespace from
}  // namespace uvY

namespace jch {
namespace from {
float3 BT709(float3 bt709, float cz = 1.f) {
  float3 uvY = uvY::from::BT709(bt709);

  float L_star_hat = pow(uvY[2], 0.631651345306265f);
  float L_star = 2.098883786377f * L_star_hat / (L_star_hat + 1.12426773749357f);

  float M2 = dot(uvY.xy, uvY.xy);

  float C = 15.932993652962535 * pow(L_star, 0.6523997524738018) * pow(M2, 0.6007557017508491) / L_WHITE;
  float J = pow(L_star / L_WHITE, cz);
  float H = atan2(uvY[1], uvY[0]);

  return float3(J, C, H);
}
}  // from
}  // jch

namespace hcb {
namespace from {
float3 BT709(float3 bt709, float cz = 1.f) {
  float3 jch = jch::from::BT709(bt709);
  float J = jch[0];
  float C = jch[1];
  float H = jch[2];

  float B = J * (pow(C, 1.33654221029386) + 1.f);

  return float3(H, C, B);
}
}  // from
}  // hcb

namespace hsb {
namespace from {
float3 BT709(float3 bt709, float cz = 1.f) {
  float3 hcb = hcb::from::BT709(bt709);
  float H = hcb[0];
  float C = hcb[1];
  float B = hcb[2];

  float S = C / B;

  return float3(H, S, B);
}
}  // from
}  // hsb

}  // namespace dtucs

namespace bt709 {
namespace from {
namespace dtucs {
static const float2x2 UVStarPrimeToUVStar = {
  -5.037522385190711f, -2.504856328185843f,
  4.760029407436461f, 2.874012963239247f
};

static const float3x3 UVToxyD = {
  0.167171472114775f, 0.141299802443708f, -0.00801531300850582f,
  -0.150959086409163f, -0.155185060382272f, -0.00843312433578007f,
  0.940254742367256f, 1.f, -0.0256325967652889f
};

float3 uvY(float3 uvY) {
  float2 UVStar = mul(UVStarPrimeToUVStar, uvY.xy);

  float2 UV = float2(-1.49217352929f, -1.52488637914f) * UVStar / (abs(UVStar) - float2(1.39656225667f, 1.4513954287f));

  float3 xyD = mul(UVToxyD, float3(UV, 1.f));

  float3 xyY;

  xyY.xy = renodx::math::DivideSafe(xyD.xy, xyD.z, 0);

  xyY[2] = uvY[2];

  return bt709::from::xyY(xyY);
}

float3 JCH(float3 jch, float cz = 1.f) {
  float J = jch[0];
  float C = jch[1];
  float H = jch[2];

  float L_star = pow(J, (1 / cz)) * color::dtucs::L_WHITE;

  float M = pow(C * color::dtucs::L_WHITE / (15.932993652962535 * pow(L_star, 0.6523997524738018)), 0.8322850678616855);

  float Y = pow(-1.12426773749357f * L_star / (L_star - 2.098883786377), 1.5831518565279648f);

  return bt709::from::dtucs::uvY(float3(M * cos(H), M * sin(H), Y));
}

float3 HCB(float3 hcb, float cz = 1.f) {
  float H = hcb[0];
  float C = hcb[1];
  float B = hcb[2];

  float J = B / (pow(C, 1.33654221029386) + 1.f);

  return bt709::from::dtucs::JCH(float3(J, C, H), cz);
}

float3 HSB(float3 hsb, float cz = 1.f) {
  float H = hsb[0];
  float S = hsb[1];
  float B = hsb[2];

  float C = S * B;

  return bt709::from::dtucs::HCB(float3(H, C, B), cz);
}

}  // dtucs
}  // namespace from
}  // namespace bt709
}  // namespace color
}  // namespace renodx
#endif  // RENODX_SHADERS_COLOR_DTUCS_HLSL
