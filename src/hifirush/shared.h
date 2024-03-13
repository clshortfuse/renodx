#ifndef SRC_HIFIRUSH_SHARED_H_
#define SRC_HIFIRUSH_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapperEnum;
  float gamePeakWhite;
  float gamePaperWhite;
  float uiPaperWhite;
};

#endif  // SRC_HIFIRUSH_SHARED_H_
