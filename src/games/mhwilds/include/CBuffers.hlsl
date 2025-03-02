cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);  // overall brightness
  float HDRMapping_000z : packoffset(c000.z);  // displayMaxNits
  float HDRMapping_009x : packoffset(c009.x);  // toeEnd
  float HDRMapping_009y : packoffset(c009.y);  // toeStrength
  float HDRMapping_009z : packoffset(c009.z);  // blackPoint
  float HDRMapping_009w : packoffset(c009.w);  // shoulderStartPoint
  float HDRMapping_010x : packoffset(c010.x);  // shoulderStrength
  float HDRMapping_010z : packoffset(c010.z);  // saturationOnDisplayMapping
  float HDRMapping_014x : packoffset(c014.x);  // shoulderAngle
};

cbuffer OCIOTransformXYZMatrix : register(b1) {
  float OCIOTransformXYZMatrix_000x : packoffset(c000.x);
  float OCIOTransformXYZMatrix_000y : packoffset(c000.y);
  float OCIOTransformXYZMatrix_000z : packoffset(c000.z);
  float OCIOTransformXYZMatrix_001x : packoffset(c001.x);
  float OCIOTransformXYZMatrix_001y : packoffset(c001.y);
  float OCIOTransformXYZMatrix_001z : packoffset(c001.z);
  float OCIOTransformXYZMatrix_002x : packoffset(c002.x);
  float OCIOTransformXYZMatrix_002y : packoffset(c002.y);
  float OCIOTransformXYZMatrix_002z : packoffset(c002.z);
  float OCIOTransformXYZMatrix_004x : packoffset(c004.x);
  float OCIOTransformXYZMatrix_004y : packoffset(c004.y);
  float OCIOTransformXYZMatrix_004z : packoffset(c004.z);
  float OCIOTransformXYZMatrix_005x : packoffset(c005.x);
  float OCIOTransformXYZMatrix_005y : packoffset(c005.y);
  float OCIOTransformXYZMatrix_005z : packoffset(c005.z);
  float OCIOTransformXYZMatrix_006x : packoffset(c006.x);
  float OCIOTransformXYZMatrix_006y : packoffset(c006.y);
  float OCIOTransformXYZMatrix_006z : packoffset(c006.z);
};
