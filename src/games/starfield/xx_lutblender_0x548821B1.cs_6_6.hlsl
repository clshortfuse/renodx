cbuffer _19_21 : register(b0, space0) {
  float4 _21_m0[2] : packoffset(c0);
}

Texture2D<float4> _8 : register(t0, space8);
Texture2D<float4> _9 : register(t1, space8);
Texture2D<float4> _10 : register(t2, space8);
Texture2D<float4> _11 : register(t3, space8);
RWTexture3D<float4> _14 : register(u0, space8);

static uint3 gl_GlobalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

[numthreads(16, 16, 1)] void main(SPIRV_Cross_Input stage_input) {
  uint _36 = (gl_GlobalInvocationID.z << 4u) + gl_GlobalInvocationID.x;
  float _50 = asfloat(asuint(_21_m0[1u]).x);
  float4 _55 = _8.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  uint4 _63 = asuint(_21_m0[0u]);
  float _65 = asfloat(_63.x);

  float4 _70 = _9.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  float _76 = asfloat(_63.y);
  float4 _81 = _10.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  float _87 = asfloat(_63.z);
  float4 _92 = _11.Load(int3(uint2(_36, gl_GlobalInvocationID.y), 0u));
  float _98 = asfloat(_63.w);
  
  float _111 = ((((_65 * _55.x) + ((float(gl_GlobalInvocationID.x) * 0.066666670143604278564453125f) * _50)) + (_76 * _70.x)) + (_87 * _81.x)) + (_98 * _92.x);

  float4 outputColor = float4(_111, ((((_65 * _55.y) + ((float(gl_GlobalInvocationID.y) * 0.066666670143604278564453125f) * _50)) + (_76 * _70.y)) + (_87 * _81.y)) + (_98 * _92.y), ((((_65 * _55.z) + ((float(gl_GlobalInvocationID.z) * 0.066666670143604278564453125f) * _50)) + (_76 * _70.z)) + (_87 * _81.z)) + (_98 * _92.z), _111);

  _14[uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z)] = outputColor;
}
