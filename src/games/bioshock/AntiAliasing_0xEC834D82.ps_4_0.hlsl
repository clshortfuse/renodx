cbuffer _Globals : register(b0)
{
  float2 resolution : packoffset(c0);
  float2 invResolution : packoffset(c0.z);
}

SamplerState s_framebuffer_s : register(s0);
Texture2D<float4> s_framebuffer : register(t0);

#define cmp -

static const float3 Rec709_Luminance = float3(0.2126f, 0.7152f, 0.0722f);

float GetLuminance( float3 color )
{
	return dot( color, Rec709_Luminance );
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
#if 0 // Disable AA
  o0 = s_framebuffer.Load(v0.xyz);
#else
  //TODO: implemented more modern spatial AA
  float4 r0,r1,r2,r3,r4,r5;
  r0.xyzw = resolution.xyxy * v1.xyxy;
  r1.xyzw = s_framebuffer.Sample(s_framebuffer_s, v1.xy).xyzw;
  r2.xyzw = s_framebuffer.Sample(s_framebuffer_s, w1.xy).xyzw;
  r3.xyzw = s_framebuffer.Sample(s_framebuffer_s, v2.xy).xyzw;
  r4.xyzw = s_framebuffer.Sample(s_framebuffer_s, w2.xy).xyzw;
  r5.xyzw = s_framebuffer.Sample(s_framebuffer_s, v3.xy).xyzw;
  // RenoDX: fixed BT.601 luminance coeffs //TODO: fix more of these (e.g. bloom?)
  r1.x = GetLuminance(r1.xyz);
  r1.y = GetLuminance(r2.xyz);
  r1.z = GetLuminance(r3.xyz);
  r1.w = GetLuminance(r4.xyz);
  r2.x = GetLuminance(r5.xyz);
  r2.y = min(r1.y, r1.z);
  r2.z = min(r2.x, r1.w);
  r2.y = min(r2.y, r2.z);
  r2.y = min(r2.y, r1.x);
  r2.z = max(r1.y, r1.z);
  r2.w = max(r2.x, r1.w);
  r2.z = max(r2.z, r2.w);
  r2.z = max(r2.z, r1.x);
  r2.w = r1.y + r1.z;
  r3.x = r2.x + r1.w;
  r3.x = -r3.x + r2.w;
  r4.xz = -r3.xx;
  r1.y = r1.y + r1.w;
  r1.z = r2.x + r1.z;
  r4.yw = r1.yy + -r1.zz;
  r1.y = r2.w + r1.w;
  r1.y = r1.y + r2.x;
  r1.y = 0.03125 * r1.y;
  r1.y = max(0.0078125, r1.y);
  r1.z = min(abs(r4.w), abs(r3.x));
  r1.y = r1.z + r1.y;
  r1.y = 1 / r1.y;
  r3.xyzw = r4.xyzw * r1.yyyy;
  r3.xyzw = max(float4(-8,-8,-8,-8), r3.xyzw);
  r3.xyzw = min(float4(8,8,8,8), r3.xyzw);
  r3.xyzw = invResolution.xyxy * r3.xyzw;
  r0.xyzw = invResolution.xyxy * r0.xyzw;
  r4.xyzw = r3.zwzw * float4(-0.166666672,-0.166666672,0.166666672,0.166666672) + r0.zwzw;
  r5.xyzw = s_framebuffer.Sample(s_framebuffer_s, r4.xy).xyzw;
  r4.xyzw = s_framebuffer.Sample(s_framebuffer_s, r4.zw).xyzw;
  r1.yzw = r5.xyz + r4.xyz;
  r0.xyzw = r3.xyzw * float4(-0.5,-0.5,0.5,0.5) + r0.xyzw;
  r3.xyzw = s_framebuffer.Sample(s_framebuffer_s, r0.xy).xyzw;
  r0.xyzw = s_framebuffer.Sample(s_framebuffer_s, r0.zw).xyzw;
  r0.xyz = r3.xyz + r0.xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r0.xyz = r1.yzw * float3(0.25,0.25,0.25) + r0.xyz;
  r0.w = dot(r0.xyz, r1.xxx);
  r1.x = cmp(r0.w < r2.y);
  r0.w = cmp(r2.z < r0.w);
  r0.w = (int)r0.w | (int)r1.x;
  if (r0.w != 0) {
    o0.xyz = float3(0.5,0.5,0.5) * r1.yzw;
  } else {
    o0.xyz = r0.xyz;
  }
  o0.w = 0;
#endif
}