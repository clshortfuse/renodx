// Mechanically reconstructed from 0x86DC337F.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
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
    float4 v6 : TEXCOORD5;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c2 = float4(1.0f, 0.5f, -0.0f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 3.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c2.xy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r3.xy = (r0.yw) * (c3.xx) + (c3.yy);
    r1 = tex2D(s1, v1.xy);
    r6.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0.w = dot(r3.xy, r3.xy) + (c1.x);
    r0.y = dot(r6.xy, r6.xy) + (c1.x);
    r0.w = exp2(-(r0.w));
    r0.y = exp2(-(r0.y));
    r0.w = (r0.w) * (c1.y) + (c1.z);
    r2.w = (r0.y) * (c1.y) + (c1.z);
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c1.ww);
    r1.w = (r0.w) * (r2.w);
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = dot(r3.xy, r6.xy) + (c1.x);
    r0.y = (r1.y) * (c1.w) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.w) + (r1.w));
    r0.y = (r2.z) * (-(r4.y)) + (r0.y);
    r2.xz = (r2.xy) * (c2.ww);
    r2.y = (r0.y) + (r0.y);
    r3.xyz = (r0.www) * (r2.xyz);
    r0.xy = (r0.xz) * (r4.xx);
    r2.xyz = (-(v6.xyz)) + (c[20].xyz);
    r0.w = (r1.x) * (c1.w) + (-(r0.x));
    r5.y = dot(r2.xyz, r2.xyz);
    r1.xz = (r2.ww) * (r0.xy);
    r1.w = rsqrt(r5.y);
    r0.w = (r0.z) * (-(r4.x)) + (r0.w);
    r5.x = 1.0f / (r1.w);
    r1.y = (r2.w) * (r0.w);
    r4.xy = saturate((r5.xx) * (c[23].xy) + (c[23].zw));
    r0.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c3.yy) + (c3.ww);
    r0.w = dot(c[22].yz, r5.xy) + (c[22].x);
    r0.xy = (r0.xy) * (r4.xy);
    r5.xyz = (r1.xyz) * (c3.xzx) + (r3.xyz);
    r0.w = (r0.w) * (r0.x);
    r7.xyz = (r2.xyz) * (r1.www);
    r1.w = (r0.y) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r5.w = (r1.w) * (r0.y);
    r0.xyz = v2.xyz;
    r4.xyz = (r6.xxx) * (v5.xyz) + (r0.xyz);
    r3 = (-(v6.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r4.xyz = (r6.yyy) * (v4.xyz) + (r4.xyz);
    r0 = (r1) * (r1) + (r0);
    r6.xyz = normalize(r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r6.w = saturate(dot(r7.xyz, r6.xyz));
    r3 = (r3) * (r4);
    r3 = (r6.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r6.xxxx) + (r3);
    r3.w = c2.x;
    r0 = saturate((r0) * (c[8]) + (r3.wwww));
    r1 = saturate((r1) * (r6.zzzz) + (r2));
    r2.xyz = (r6.www) * (c[21].xyz);
    r1 = (r0) * (r1);
    r3.x = dot(c[9], r1);
    r3.y = dot(c[10], r1);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.z = dot(c[11], r1);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r2.xyz = (r5.www) * (r2.xyz) + (r5.xyz);
    r3.xyz = (r3.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
