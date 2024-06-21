#include "./p5r.h"

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_TARGET0)
{
  o0 = v1;

  return;
}
