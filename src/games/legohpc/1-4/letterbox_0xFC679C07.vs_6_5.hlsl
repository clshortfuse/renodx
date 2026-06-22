#include "../shared.h"
// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

struct OutputSignature {
  precise noperspective float4 SV_Position : SV_Position;
  float4 __out_COLOR : COLOR;
};

OutputSignature main(
  float4 POSITION : POSITION,
  float4 COLOR : COLOR,
  float4 NORMAL : NORMAL
) {
  float4 SV_Position;
  float4 __out_COLOR;
  SV_Position.x = POSITION.x;
  SV_Position.y = POSITION.y;
  SV_Position.z = POSITION.z;
  SV_Position.w = POSITION.w;
  if (!LETTERBOX) SV_Position.w = 0;
  __out_COLOR.x = COLOR.x;
  __out_COLOR.y = COLOR.y;
  __out_COLOR.z = COLOR.z;
  __out_COLOR.w = NORMAL.w;
  OutputSignature output_signature = { SV_Position, __out_COLOR };
  return output_signature;
}