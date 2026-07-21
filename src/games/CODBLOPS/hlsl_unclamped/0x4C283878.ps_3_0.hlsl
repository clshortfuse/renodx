// Mechanically reconstructed from 0x4C283878.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.0f, 0.0f, 0.0f, 0.0f);
    const float4 c1 = float4(-0.5f, 1.35000002f, 0.5f, 0.699999988f);
    const float4 c2 = float4(1.60000002f, 8.0f, 31.875f, 1.0f);
    const float4 c3 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.0f);
    const float4 c4 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c10 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.xyz = normalize(v1.xyz);
    r0.w = dot(r1.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r1.xyz);
    r0.w = c2.x;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.yyy);
    r1 = tex3D(s11, v4.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[8].xxx);
    r0.xyz = (r0.xyz) * (c2.zzz);
    r1.xy = (c1.xx) + (v3.xy);
    r1.xy = (r1.xy) * (c1.yy) + (c1.zz);
    r2.xy = lerp(c[7].xy, c[7].zw, r1.xy);
    r1 = tex2D(s4, r1.xy);
    r0.w = (r1.x) * (r1.x);
    r0.w = (r0.w) * (r0.w);
    r0.w = (r0.w) * (c[5].y);
    r0.w = (r0.w) * (c1.w);
    r1 = tex2D(s2, r2.xy);
    r1.y = r1.x;
    r3 = tex2D(s3, r2.xy);
    r2 = tex2D(s1, r2.xy);
    r1.xw = (r2.xx) * (c0.xy) + (c0.yx);
    r1.z = r3.x;
    r2.y = dot(c4, r1);
    r2.x = dot(c3.xyz, r1.xyw);
    r2.z = dot(c10.xyz, r1.xzw);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (c[9].xxx);
    r1.xyz = (r1.xyz) * (c2.yyy) + (-(r0.xyz));
    r0.xyz = (r0.www) * (r1.xyz) + (r0.xyz);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c2.w;

    return oC0;
}
