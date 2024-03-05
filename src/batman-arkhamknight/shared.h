#ifndef SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_
#define SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_

// Must be 32bit aligned
// Should be 4x32
struct ShaderInjectData {
  float toneMapperEnum;
  float gamePeakWhite;
  float gamePaperWhite;
  float uiPaperWhite;
};

#endif  // SRC_BATMAN_ARKHAMKNIGHT_SHARED_H_
