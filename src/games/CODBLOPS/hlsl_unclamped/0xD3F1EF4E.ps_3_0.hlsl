// Mechanically reconstructed from 0xD3F1EF4E.ps_3_0.cso.
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
    const float4 c0 = float4(0.0f, 1.0f, 8.0f, 3.5f);
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
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c1.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1.xy = (r0.yw) * (c2.xx) + (c2.yy);
    r0.w = dot(r1.xy, r1.xy) + (c0.x);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c1.ww);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r4.yy);
    r2.w = saturate((r0.w) * (c2.z) + (c2.w));
    r0.w = (r1.y) * (c1.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c2.xx);
    r0.w = (r2.z) * (-(r4.y)) + (r0.w);
    r3.y = (r0.w) + (r0.w);
    r0.xy = (r0.xz) * (r4.xx);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r2.xz = (r0.xy) * (c2.xx);
    r2.y = (r0.z) * (-(r4.x)) + (r0.w);
    r11.xy = c0.xy;
    r4.xy = (r11.xy) + (-(c[20].xy));
    r5 = tex2D(s1, v4.zw);
    r5.w = (r5.w) * (v4.y);
    r0 = tex2D(s2, v0.xy);
    r1.xyz = normalize(v3.xyz);
    r10.xyz = normalize(v1.xyz);
    r1.w = saturate(dot(r10.xyz, -(r1.xyz)));
    r1.w = (-(r1.w)) + (c0.y);
    r3.w = (r0.w) * (c0.w) + (c0.y);
    r4.w = (r1.w) * (r1.w);
    r3.w = 1.0f / (r3.w);
    r1.w = (r1.w) * (r4.w);
    r7.xy = (r5.ww) * (r4.xy) + (c[20].xy);
    r3.w = (r3.w) * (r1.w);
    r4.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r1.w = dot(r1.xyz, r10.xyz);
    r6.xyz = (r3.www) * (r4.xyz);
    r3.w = (r1.w) + (r1.w);
    r1.w = (r0.w) * (c0.z);
    r1.xyz = (r10.xyz) * (-(r3.www)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz) + (r6.xyz);
    r0.xyz = (r7.xxx) * (r4.xyz);
    r2.y = (r2.y) + (r2.y);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r3.xyz) * (r2.www) + (r2.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r7.xyz = (r7.yyy) * (r1.xyz);
    r8.xyz = (r0.xyz) * (c0.zzz);
    r6 = tex2D(s0, v0.xy);
    r3 = (-(v3.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v3.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r9.xyz = lerp(r6.xyz, r5.xyz, r5.www);
    r3 = (r3) * (r4);
    r3 = (r10.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r10.xxxx) + (r3);
    r0 = saturate((r0) * (c[8]) + (r11.yyyy));
    r1 = saturate((r1) * (r10.zzzz) + (r2));
    r2.xyz = (r9.xyz) * (r9.xyz);
    r0 = (r0) * (r1);
    r3.xyz = (r2.xyz) * (r7.xyz) + (r8.xyz);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
