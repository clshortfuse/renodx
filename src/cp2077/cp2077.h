#ifndef SRC_CP2077_CP2077_H_
#define SRC_CP2077_CP2077_H_

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
};

#define TONE_MAPPER_TYPE__NONE 0.f
#define TONE_MAPPER_TYPE__VANILLA 1.f
#define TONE_MAPPER_TYPE__OPENDRT 2.f
#define TONE_MAPPER_TYPE__DICE 3.f
#define TONE_MAPPER_TYPE__ACES 4.f

#endif  // SRC_CP2077_CP2077_H_
