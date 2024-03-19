#ifndef SRC_SEAOFSTARS_SHARED_H_
#define SRC_SEAOFSTARS_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapType;
  float toneMapPeakNits;
  float toneMapGameNits;
  float toneMapUINits;
  float colorGradeHighlights;
  float colorGradeShadows;
  float colorGradeContrast;
  float colorGradeSaturation;
};

#endif  // SRC_SEAOFSTARS_SHARED_H_
