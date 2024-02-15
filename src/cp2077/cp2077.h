#ifndef SRC_CP2077_CP2077_H_
#define SRC_CP2077_CP2077_H_

// Must be 32x4
struct ShaderInjectData {
  float toneMapperType;
  float toneMapperPaperWhite;
  float toneMapperExposure;
  float toneMapperContrast;

  float toneMapperHighlights;
  float toneMapperShadows;
  float colorGradingWorkflow;
  float colorGradingStrength;

  float colorGradingScaling;
  float colorGradingLift;
  float colorGradingGamma;
  float colorGradingGain;

  float filmGrainStrength;
  float filmGrainFPSLimit;
  float filmGrainPeakY;
  float filmGrainSeed;

  float debugValue00;
  float debugValue01;
  float debugValue02;
  float debugValue03;
};

#define TONE_MAPPER_TYPE__NONE    0.f
#define TONE_MAPPER_TYPE__VANILLA 1.f
#define TONE_MAPPER_TYPE__OPENDRT 2.f
#define TONE_MAPPER_TYPE__DICE    3.f
#define TONE_MAPPER_TYPE__ACES    4.f

#define OUTPUT_TYPE_SRGB8  0u
#define OUTPUT_TYPE_PQ     1u
#define OUTPUT_TYPE_SCRGB  2u
#define OUTPUT_TYPE_SRGB10 3u

#endif  // SRC_CP2077_CP2077_H_
