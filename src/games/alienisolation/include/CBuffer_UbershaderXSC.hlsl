cbuffer cbUbershaderXSC : register(b5) {
  float4 rp_parameter_vs[32] : packoffset(c0);
  float4 rp_parameter_ps[32] : packoffset(c32);
}
