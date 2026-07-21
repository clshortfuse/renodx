// Mechanically reconstructed from 0x72571206.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    float4 v7 = input.v7;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c4 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v6.ww) * (c[26].xy) + (v6.xy);
    r0.zw = v6.zw;
    r0 = tex2Dproj(s2, r0);
    r1.xy = (v6.ww) * (-(c[26].xy)) + (v6.xy);
    r1.zw = v6.zw;
    r1 = tex2Dproj(s2, r1);
    r0.y = r1.x;
    r1.xy = (v6.ww) * (c[26].zw) + (v6.xy);
    r1.zw = v6.zw;
    r1 = tex2Dproj(s2, r1);
    r0.z = r1.x;
    r1.xy = (v6.ww) * (-(c[26].zw)) + (v6.xy);
    r1.zw = v6.zw;
    r1 = tex2Dproj(s2, r1);
    r0.w = r1.x;
    r1.w = dot(r0, c3.wwww);
    r0 = tex2D(s12, v1.zw);
    r1.xyz = (-(v7.xyz)) + (c[20].xyz);
    r2.y = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r2.y);
    r7.xyz = (r1.xyz) * (r0.zzz);
    r0.w = dot(r7.xyz, c[22].xyz);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r2.x = 1.0f / (r0.z);
    r0.w = (r0.w) * (c[23].w);
    r3.w = lerp(r0.y, r1.w, r0.w);
    r1.xy = saturate((r2.xx) * (c[25].xy) + (c[25].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c4.xx) + (c4.yy);
    r0.w = dot(c[24].yz, r2.xy) + (c[24].x);
    r1.xy = (r0.xy) * (r1.xy);
    r1.w = (r0.w) * (r1.x);
    r0.xy = (v1.zw) * (c2.xy);
    r0 = tex2D(s13, r0.xy);
    r2.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r2.xy);
    r0.w = r2.y;
    r2.w = (r1.y) * (r1.w);
    r3.xy = (r0.yw) * (c3.xx) + (c3.yy);
    r1 = tex2D(s1, v1.xy);
    r5.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.x);
    r0.y = dot(r5.xy, r5.xy) + (c1.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c1.y) + (c1.z);
    r4.w = (r0.y) * (c1.y) + (c1.z);
    r0.y = (r0.w) * (r4.w);
    r0.w = dot(r3.xy, r5.xy) + (c1.x);
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c1.ww);
    r1.w = saturate((r0.w) * (r0.y) + (r0.y));
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = (r1.y) * (c1.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c2.ww);
    r0.w = (r2.z) * (-(r4.y)) + (r0.w);
    r0.xy = (r0.xz) * (r4.xx);
    r3.y = (r0.w) + (r0.w);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r1.xyz = (r1.www) * (r3.xyz);
    r0.w = (r0.z) * (-(r4.x)) + (r0.w);
    r0.xz = (r4.ww) * (r0.xy);
    r0.y = (r4.w) * (r0.w);
    r6.w = (r3.w) * (r2.w);
    r6.xyz = (r0.xyz) * (c3.xzx) + (r1.xyz);
    r0 = v2;
    r0.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r4 = (-(v7.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r5.xyz = (r5.yyy) * (v4.xyz) + (r0.xyz);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = normalize(r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r7.w = saturate(dot(r7.xyz, r0.xyz));
    r4 = (r4) * (r5);
    r4 = (r0.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r0.xxxx) + (r4);
    r0.y = c2.x;
    r1 = saturate((r1) * (c[8]) + (r0.yyyy));
    r2 = saturate((r2) * (r0.zzzz) + (r3));
    r4.xyz = (r7.www) * (c[21].xyz);
    r1 = (r1) * (r2);
    r3.x = dot(c[9], r1);
    r3.y = dot(c[10], r1);
    r2 = tex2D(s0, v1.xy);
    r0.xyz = (r2.xyz) * (v0.xyz);
    r3.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r6.www) * (r4.xyz) + (r6.xyz);
    r2.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[27].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.x;

    return oC0;
}
