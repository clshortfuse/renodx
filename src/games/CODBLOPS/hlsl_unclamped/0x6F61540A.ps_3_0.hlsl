// Mechanically reconstructed from 0x6F61540A.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(8.0f, 1.0f, 3.5f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.xy = (r0.yw) * (c2.xx) + (c2.yy);
    r0.w = dot(r1.xy, r1.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r1 = tex2D(s14, v0.zw);
    r3.xy = (r1.xy) * (c1.ww);
    r5.w = saturate((r0.w) * (c2.z) + (c2.w));
    r2.xy = (r2.xz) * (r3.yy);
    r0.w = (r1.y) * (c1.w) + (-(r2.x));
    r6.xz = (r2.xy) * (c2.xx);
    r0.w = (r2.z) * (-(r3.y)) + (r0.w);
    r0.xy = (r0.xz) * (r3.xx);
    r6.y = (r0.w) + (r0.w);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r5.xz = (r0.xy) * (c2.xx);
    r0.w = (r0.z) * (-(r3.x)) + (r0.w);
    r5.y = (r0.w) + (r0.w);
    r0.xy = c[5].xy;
    r1.xy = (-(r0.xy)) + (c[6].xy);
    r0 = tex2D(s1, v4.zw);
    r8.xyz = normalize(v3.xyz);
    r7.xyz = normalize(v1.xyz);
    r1.w = dot(r8.xyz, r7.xyz);
    r0.w = (r0.w) * (v4.y);
    r1.w = (r1.w) + (r1.w);
    r9.xy = (r0.ww) * (r1.xy) + (c[5].xy);
    r2.xyz = (r7.xyz) * (-(r1.www)) + (r8.xyz);
    r4 = tex2D(s2, v0.xy);
    r3 = tex2D(s3, v4.zw);
    r1 = lerp(r4, r3, r0.wwww);
    r3.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r2.w = (r1.w) * (c0.x);
    r2 = texCUBElod(s15, r2);
    r3.w = (-(r3.w)) + (c0.y);
    r3.z = (r3.w) * (r3.w);
    r2.w = (r1.w) * (c0.z) + (c0.y);
    r1.w = (r3.w) * (r3.z);
    r2.w = 1.0f / (r2.w);
    r1.w = (r1.w) * (r2.w);
    r4.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r3.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r1.www) * (r4.xyz);
    r3.xyz = (r9.xxx) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz) + (r2.xyz);
    r2.xyz = (r6.xyz) * (r5.www) + (r5.xyz);
    r1.xyz = (r3.xyz) * (r1.xyz);
    r2.xyz = (r9.yyy) * (r2.xyz);
    r4.xyz = (r5.xyz) * (r1.xyz);
    r1 = tex2D(s0, v0.xy);
    r3.xyz = lerp(r1.xyz, r0.xyz, r0.www);
    r1.xyz = (r4.xyz) * (c0.xxx);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
