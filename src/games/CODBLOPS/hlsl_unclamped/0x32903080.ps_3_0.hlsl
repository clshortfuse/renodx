// Mechanically reconstructed from 0x32903080.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
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
    const float4 c0 = float4(1.0f, 8.0f, 3.5f, 0.5f);
    const float4 c1 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
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

    r0.xy = (v0.zw) * (c0.xw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.xy = (r0.yw) * (c1.xx) + (c1.yy);
    r0.w = dot(r1.xy, r1.xy) + (c2.z);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c2.ww);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r4.yy);
    r3.w = saturate((r0.w) * (c1.z) + (c1.w));
    r0.w = (r1.y) * (c2.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c1.xx);
    r0.w = (r2.z) * (-(r4.y)) + (r0.w);
    r3.y = (r0.w) + (r0.w);
    r0.xy = (r0.xz) * (r4.xx);
    r0.w = (r1.x) * (c2.w) + (-(r0.x));
    r2.xz = (r0.xy) * (c1.xx);
    r2.y = (r0.z) * (-(r4.x)) + (r0.w);
    r7.w = c0.x;
    r5.xy = (r7.ww) + (-(c[20].xy));
    r4 = tex2D(s1, v4.zw);
    r2.w = (r4.w) * (v4.y);
    r0 = tex2D(s2, v0.xy);
    r1.xyz = normalize(v3.xyz);
    r8.xyz = normalize(v1.xyz);
    r1.w = saturate(dot(r8.xyz, -(r1.xyz)));
    r1.w = (-(r1.w)) + (c0.x);
    r5.w = (r0.w) * (c0.z) + (c0.x);
    r5.z = (r1.w) * (r1.w);
    r5.w = 1.0f / (r5.w);
    r1.w = (r1.w) * (r5.z);
    r7.xy = (r2.ww) * (r5.xy) + (c[20].xy);
    r5.w = (r5.w) * (r1.w);
    r5.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.xxx);
    r1.w = dot(r1.xyz, r8.xyz);
    r6.xyz = (r5.www) * (r5.xyz);
    r5.w = (r1.w) + (r1.w);
    r1.w = (r0.w) * (c0.y);
    r1.xyz = (r8.xyz) * (-(r5.www)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r5.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz) + (r6.xyz);
    r0.xyz = (r7.xxx) * (r5.xyz);
    r2.y = (r2.y) + (r2.y);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r3.xyz) * (r3.www) + (r2.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r6.xyz = (r7.yyy) * (r1.xyz);
    r7.xyz = (r0.xyz) * (c0.yyy);
    r5 = tex2D(s0, v0.xy);
    r9.xyz = lerp(r5.xyz, r4.xyz, r2.www);
    r3 = (-(v3.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v3.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r5.w = (r5.w) * (-(v4.x)) + (c0.x);
    r0 = (r1) * (r1) + (r0);
    r6.w = (r4.w) * (-(v4.y)) + (c0.x);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = (r9.xyz) * (r9.xyz);
    r3 = (r3) * (r4);
    r3 = (r8.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r8.xxxx) + (r3);
    r0 = saturate((r0) * (c[8]) + (r7.wwww));
    r1 = saturate((r1) * (r8.zzzz) + (r2));
    r2.xyz = (r5.xyz) * (r6.xyz) + (r7.xyz);
    r0 = (r0) * (r1);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.w = (r5.w) * (-(r6.w)) + (c0.x);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r1.xyz = (r0.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
