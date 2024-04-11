static const uint DrawToneMapperSize = 512;
static const uint ToneMapperPadding = 8;
static const uint ToneMapperBins = DrawToneMapperSize - (2 * ToneMapperPadding);

struct DrawToneMapperParams {
  bool drawToneMapper;
  uint toneMapperY;
  float valueX;
  float3 outputColor;
  float peakNits;
  float scale;
};

DrawToneMapperParams DrawToneMapperStart(float2 position, float3 inputColor, float width, float height, float peakNits, float scale = 80.f) {
  DrawToneMapperParams dtmParams = {false, -1u, 0, inputColor, peakNits, scale};
  int2 offset = int2(
    position.x - (width - DrawToneMapperSize),
    (DrawToneMapperSize)-position.y
  );
  if (offset.x >= 0 && offset.y >= 0) {
    dtmParams.outputColor = float3(0.15f, 0.15f, 0.15f);
    if (
      offset.x >= ToneMapperPadding
      && offset.y >= ToneMapperPadding
      && offset.x < (DrawToneMapperSize - ToneMapperPadding)
      && offset.y < (DrawToneMapperSize - ToneMapperPadding)
    ) {
      dtmParams.drawToneMapper = true;
      uint toneMapperX = offset.x - ToneMapperPadding;
      dtmParams.toneMapperY = offset.y - ToneMapperPadding;

      // From 0.01 to Peak nits (in log)
      const float xMin = log10(0.01 / scale);
      const float xMax = log10(10000.f / scale);
      const float xRange = xMax - xMin;
      dtmParams.valueX = (float(toneMapperX) / float(ToneMapperBins)) * (xRange) + xMin;
      dtmParams.valueX = pow(10.f, dtmParams.valueX);
      dtmParams.outputColor = float3(dtmParams.valueX, dtmParams.valueX, dtmParams.valueX);
    }
  }
  return dtmParams;
}

DrawToneMapperParams DrawToneMapperStart(float2 position, float3 inputColor, Texture2D<float3> textureUntonemapped, float peakNits, float scale = 80.f) {
  float width;
  float height;
  textureUntonemapped.GetDimensions(width, height);
  return DrawToneMapperStart(position, inputColor, width, height, peakNits, scale);
}

DrawToneMapperParams DrawToneMapperStart(float2 position, float3 inputColor, Texture2D<float4> textureUntonemapped, float peakNits, float scale = 80.f) {
  float width;
  float height;
  textureUntonemapped.GetDimensions(width, height);
  return DrawToneMapperStart(position, inputColor, width, height, peakNits, scale);
}

float3 DrawToneMapperEnd(float3 inputColor, inout DrawToneMapperParams dtmParams) {
  // From 0.01 to Peak nits (in log)
  const float yMin = log10(0.01);
  const float yMax = log10(10000.f);
  const float yRange = yMax - yMin;
  float valueY = (float(dtmParams.toneMapperY) / float(ToneMapperBins)) * (yRange) + yMin;
  float peakNits = dtmParams.peakNits;
  float scale = dtmParams.scale;
  valueY = pow(10.f, valueY);
  valueY /= scale;
  float outputY = yFromBT709(inputColor);
  if (outputY > valueY) {
    if (outputY < 0.18f) {
      return float3(0.3f, 0, 0.3f);
    } else if (outputY > peakNits / scale) {
      return float3(0, 0.3f, 0.3f);
    } else {
      return max(0.05f, valueY);
    }
  } else {
    if (dtmParams.valueX < 0.18f) {
      return float3(0, 0.3f, 0);
    } else if (valueY >= peakNits / scale) {
      return float3(0, 0, 0.3f);
    } else {
      return 0.05f;
    }
  }
}
