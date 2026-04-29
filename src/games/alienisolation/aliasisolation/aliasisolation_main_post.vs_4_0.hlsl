cbuffer cbDefaultVSC : register(b1) {
  float4x4 ProjMatrix : packoffset(c0.x);
  float4x4 TextureTransform : packoffset(c4.x);
  float4x4 InvViewProj : packoffset(c8.x);
  float4x4 PrevViewProj : packoffset(c12.x);
  float4x4 PrevSecViewProj : packoffset(c16.x);
  float4 TextureScaleBias : packoffset(c20.x);
  float4 RenderTargetSizeVS : packoffset(c21.x);
  float4 RenderTargetResolutionVS : packoffset(c22.x);
  float4 MorphTargetParams : packoffset(c23.x);
  float4 OnePixelStepForS0VS : packoffset(c24.x);
  float4 ScreenRes : packoffset(c25.x);
  float4 ClearSurfaceColor : packoffset(c27.x);
  float4 ClearSurfaceDepth : packoffset(c28.x);
  float4 VertexDepthClamp : packoffset(c29.x);
  float4 FlareScreenAspect : packoffset(c30.x);
  float4 DecalParams : packoffset(c31.x);
  float4 UserClipPlane0 : packoffset(c32.x);
  float4 UserClipPlane1 : packoffset(c33.x);
  float4 UserClipPlane2 : packoffset(c34.x);
  float4 UserClipPlane3 : packoffset(c35.x);
  float4 DecalScaleParams : packoffset(c36.x);
  float4 MipLevel : packoffset(c37.x);
};

cbuffer cbUbershaderXSC : register(b5) {
  float4 rp_parameter_vs[32] : packoffset(c0.x);
  float4 rp_parameter_ps : packoffset(c32.x);
};

struct VSInput {
  float2 param0 : POSITION;
};

struct VSOutput {
  float4 param0 : TEXCOORD0;
  float4 param1 : TEXCOORD1;
  float4 param2 : SV_Position;
};

VSOutput main(in VSInput IN) {
  VSOutput OUT = (VSOutput)0;

#if 0
	float2 clipXY = IN.param0;

	OUT.param0 = float4((IN.param0.xy * float2(0.5, -0.5)) + float2(0.5, 0.5), 0, 0);
	OUT.param1 = float4(0, 0, exp2(-1 * dot(clipXY, clipXY)), 0);
	OUT.param2 = float4(clipXY, 0, 1);
#else

  float unusedParam;
  float4 r0;
  r0.xy = (IN.param0.xyxx * float4(0.500000, -0.500000, 0.000000, 0.000000) + float4(0.500000, 0.500000, 0.000000, 0.000000)).xy;
  r0.xy = (r0.xyxx * RenderTargetSizeVS.xyxx + RenderTargetSizeVS.zwzz).xy;
  r0.zw = (IN.param0.xxxy * RenderTargetSizeVS.xxxy + RenderTargetSizeVS.zzzw).zw;
  OUT.param0.xyzw = (r0.xyzw).xyzw;
  r0.xy = (r0.xyxx + rp_parameter_vs[0].xyxx).xy;
  OUT.param1.xy = (r0.xyxx * rp_parameter_vs[0].zzzz).xy;
  r0.x = (dot(r0.zwzz.xy, r0.zwzz.xy)).x;
  r0.y = (r0.x * r0.x).x;
  r0.y = (r0.y * rp_parameter_vs[1].x).x;
  r0.x = (r0.x * r0.y + float1(1.000000)).x;
  OUT.param1.z = (float4(1.000000, 1.000000, 1.000000, 1.000000) / r0.x).x;
  OUT.param1.w = (float1(0)).x;
  r0.x = (dot(IN.param0.xyxx.xy, IN.param0.xyxx.xy)).x;
  r0.x = (r0.x + float1(0.000010)).x;
  r0.x = (sqrt(r0.x)).x;
  r0.y = (min(r0.x, float1(1.000000))).x;
  r0.y = (r0.y * float1(1.570796)).x;
  sincos(r0.y, unusedParam, r0.y);
  r0.y = (-r0.y * rp_parameter_vs[1].z + float1(1.000000)).x;
  r0.y = (r0.y * rp_parameter_vs[1].y).x;
  r0.y = (r0.y * r0.x + float1(1.000000)).x;
  r0.y = (r0.y * r0.x).x;
  r0.xz = (IN.param0.xxyx / r0.xxxx).xz;
  r0.y = (r0.y * rp_parameter_vs[1].w).x;
  OUT.param2.xy = (r0.yyyy * r0.xzxx).xy;
  OUT.param2.zw = (float4(0.000000, 0.000000, 0.000000, 1.000000)).zw;

  // Kill the barrel distortion
  OUT.param2.xy = IN.param0;

  return OUT;

#endif

  return OUT;
}
