// Mechanically reconstructed from 0xACDA3C11.ps_3_0.cso.
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
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD3;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c2 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 9.99999975e-05f, 0.100000001f);
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
    float4 r12 = 0.0f;
    float4 oC0 = 0.0f;

    r1.xy = (v5.xy) * (c[21].xy);
    r0 = tex2D(s1, r1.xy);
    r4 = tex2D(s0, r1.xy);
    r1.xy = (v5.zw) * (c2.xy);
    r3 = tex2D(s13, r1.xy);
    r1.xy = (v5.zw) * (c2.xy) + (c2.zy);
    r1 = tex2D(s13, r1.xy);
    r3.w = r1.y;
    r5.xy = (r3.yw) * (c3.xx) + (c3.yy);
    r1.w = dot(v3.xyz, v3.xyz);
    r2.xyz = (r5.yyy) * (v1.xyz);
    r7.w = rsqrt(r1.w);
    r2.xyz = (r5.xxx) * (v0.xyz) + (r2.xyz);
    r7.xyz = normalize(-(v2.xyz));
    r5.xyz = (v3.xyz) * (r7.www) + (r2.xyz);
    r2 = tex2D(s14, v5.zw);
    r6.xy = (r2.xy) * (c2.ww);
    r12.xyz = normalize(r5.xyz);
    r3.xy = (r3.xz) * (r6.xx);
    r4.z = dot(r12.xyz, r7.xyz);
    r1.w = (r2.x) * (c2.w) + (-(r3.x));
    r11.xz = (r3.xy) * (c3.xx);
    r1.w = (r3.z) * (-(r6.x)) + (r1.w);
    r11.y = (r1.w) + (r1.w);
    r1.xy = (r1.xz) * (r6.yy);
    r1.w = (r2.y) * (c2.w) + (-(r1.x));
    r10.xz = (r1.xy) * (c3.xx);
    r4.x = (r1.z) * (-(r6.y)) + (r1.w);
    r5 = (-(v2.yyyy)) + (c[6]);
    r1 = (r5) * (r5);
    r3 = (-(v2.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v2.zzzz)) + (c[7]);
    r10.y = (r4.x) + (r4.x);
    r1 = (r2) * (r2) + (r1);
    r8.xyz = (r4.zzz) * (r10.xyz) + (r11.xyz);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r4.z = c2.x;
    r1 = saturate((r1) * (c[8]) + (r4.zzzz));
    r3 = (r3) * (r6);
    r5 = (r5) * (r6);
    r2 = (r2) * (r6);
    r9.xy = (r4.wy) * (c0.xy) + (c0.zw);
    r4.xyz = v3.xyz;
    r6.xyz = (r4.zxy) * (v0.yzx);
    r9.xy = (r9.xy) * (c[22].xx);
    r6.xyz = (r4.yzx) * (v0.zxy) + (-(r6.xyz));
    r4 = (r7.yyyy) * (r5);
    r6.xyz = (r9.yyy) * (-(r6.xyz));
    r4 = (r3) * (r7.xxxx) + (r4);
    r6.xyz = (r9.xxx) * (v0.xyz) + (r6.xyz);
    r4 = saturate((r2) * (r7.zzzz) + (r4));
    r9.xyz = (r6.xyz) + (v3.xyz);
    r4 = (r1) * (r4);
    r6.xyz = normalize(r9.xyz);
    r9.x = dot(c[9], r4);
    r5 = (r5) * (r6.yyyy);
    r9.y = dot(c[10], r4);
    r3 = (r3) * (r6.xxxx) + (r5);
    r9.z = dot(c[11], r4);
    r2 = saturate((r2) * (r6.zzzz) + (r3));
    r3.w = dot(r12.xyz, r6.xyz);
    r1 = (r1) * (r2);
    r2.xyz = (r3.www) * (r10.xyz) + (r11.xyz);
    r3.x = dot(c[9], r1);
    r3.y = dot(c[10], r1);
    r3.z = dot(c[11], r1);
    r1.w = (c[23].x) * (c[23].x);
    r1.z = c[23].x;
    r1.xy = (r1.zz) * (r1.zz) + (c1.zw);
    r4.xy = (r1.ww) * (c1.xy);
    r5.x = 1.0f / (r1.x);
    r5.y = 1.0f / (r1.y);
    r2.xyz = (r2.xyz) + (r3.xyz);
    r1.w = (r4.x) * (-(r5.x)) + (c2.x);
    r1.xyz = (r8.xyz) + (r9.xyz);
    r2.xyz = (r2.xyz) * (r1.www);
    r2.w = (r0.w) + (-(c2.x));
    r1.xyz = (r1.xyz) * (r2.xyz);
    r4.z = (r4.y) * (r5.y);
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r4.w = saturate(dot(r6.xyz, r7.xyz));
    r3.xyz = normalize(c[17].xyz);
    r0.w = saturate(dot(r6.xyz, r3.xyz));
    r3.w = dot(r3.xyz, r7.xyz);
    r3.w = saturate((r0.w) * (-(r4.w)) + (r3.w));
    r3.z = 1.0f / (r4.w);
    r3.w = (r4.z) * (r3.w);
    r3.z = saturate((r0.w) * (r3.z));
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r1.z = 1.0f / (r1.z);
    r3.w = (r3.w) * (r3.z);
    r3.xyz = (r4.zzz) * (r1.xyz);
    r3.w = (r1.w) * (r0.w) + (r3.w);
    r1 = tex2D(s12, v5.zw);
    r1.xyz = (r1.yyy) * (c[18].xyz);
    r0.w = (r4.w) * (r4.w);
    r1.w = (r4.w) * (-(r4.w)) + (c2.x);
    r1.xyz = (r1.xyz) * (r3.www) + (r2.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c2.x) : (r1.w));
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r3.xyz) * (r0.www) + (r1.xyz);
    r1.xyz = (r7.www) * (v3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (-(v4.xyz));
    r0.w = dot(r7.xyz, r1.xyz);
    r1.x = v0.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v4.xyz);
    r1.w = max(c3.z, r0.w);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = pow(abs(r1.w), c3.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (r2.w) + (c2.x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
