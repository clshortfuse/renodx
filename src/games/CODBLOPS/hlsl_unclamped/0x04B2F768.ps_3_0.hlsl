// Mechanically reconstructed from 0x04B2F768.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r1.xy = (r2.yw) * (c0.xx) + (c0.yy);
    r0.w = dot(r1.xy, r1.xy) + (c1.z);
    r1 = tex2D(s14, v1.zw);
    r3.xy = (r1.xy) * (c1.ww);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r3.xx);
    r0.w = saturate((r0.w) * (c0.z) + (c0.w));
    r1.w = (r1.x) * (c1.w) + (-(r2.x));
    r1.xz = (r2.xy) * (c0.xx);
    r0.xy = (r0.xz) * (r3.yy);
    r2.w = (r2.z) * (-(r3.x)) + (r1.w);
    r1.w = (r1.y) * (c1.w) + (-(r0.x));
    r1.y = (r2.w) + (r2.w);
    r1.w = (r0.z) * (-(r3.y)) + (r1.w);
    r0.xz = (r0.xy) * (c0.xx);
    r0.y = (r1.w) + (r1.w);
    r6.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r1 = tex2D(s12, v1.zw);
    r4 = (-(v4.yyyy)) + (c[6]);
    r0 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[5]);
    r0 = (r3) * (r3) + (r0);
    r2 = (-(v4.zzzz)) + (c[7]);
    r0 = (r2) * (r2) + (r0);
    r7.xyz = normalize(v2.xyz);
    r5.x = rsqrt(r0.x);
    r5.y = rsqrt(r0.y);
    r5.z = rsqrt(r0.z);
    r5.w = rsqrt(r0.w);
    r1.w = saturate(dot(c[17].xyz, r7.xyz));
    r4 = (r4) * (r5);
    r4 = (r7.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r7.xxxx) + (r4);
    r1.z = c1.x;
    r0 = saturate((r0) * (c[8]) + (r1.zzzz));
    r2 = saturate((r2) * (r7.zzzz) + (r3));
    r4.xyz = (r1.www) * (c[18].xyz);
    r2 = (r0) * (r2);
    r3.x = dot(c[9], r2);
    r3.y = dot(c[10], r2);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r3.z = dot(c[11], r2);
    r2.xyz = (r0.yzw) * (r0.yzw);
    r1.xyz = (r1.yyy) * (r4.xyz) + (r6.xyz);
    r3.xyz = (r3.xyz) * (r2.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
