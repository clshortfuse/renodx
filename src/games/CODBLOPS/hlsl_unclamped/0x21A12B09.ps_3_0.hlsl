// Mechanically reconstructed from 0x21A12B09.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD2;
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
    const float4 c2 = float4(1.0f, 31.875f, 9.99999975e-05f, 0.100000001f);
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
    float4 oC0 = 0.0f;

    r1.xy = (v5.xy) * (c[22].xy);
    r0 = tex2D(s1, r1.xy);
    r6 = tex2D(s0, r1.xy);
    r7.xyz = normalize(-(v2.xyz));
    r2.w = max(abs(r7.y), abs(r7.z));
    r1.w = max(abs(r7.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r7.xyz) * (c[5].xyz);
    r7.w = (r0.w) + (-(c2.x));
    r1.xyz = (r1.xyz) * (r1.www) + (v0.xyz);
    r3 = tex3D(s11, r1.xyz);
    r5 = (-(v2.yyyy)) + (c[7]);
    r1 = (r5) * (r5);
    r4 = (-(v2.xxxx)) + (c[6]);
    r1 = (r4) * (r4) + (r1);
    r2 = (-(v2.zzzz)) + (c[8]);
    r8.xyz = (r3.xyz) * (r3.xyz);
    r1 = (r2) * (r2) + (r1);
    r3.x = rsqrt(r1.x);
    r3.y = rsqrt(r1.y);
    r3.z = rsqrt(r1.z);
    r3.w = rsqrt(r1.w);
    r0.w = c2.x;
    r1 = saturate((r1) * (c[9]) + (r0.wwww));
    r4 = (r4) * (r3);
    r5 = (r5) * (r3);
    r10.xy = (r6.wy) * (c0.xy) + (c0.zw);
    r6.xyz = v3.xyz;
    r9.xyz = (r6.zxy) * (v1.yzx);
    r10.xy = (r10.xy) * (c[23].xx);
    r6.xyz = (r6.yzx) * (v1.zxy) + (-(r9.xyz));
    r2 = (r2) * (r3);
    r6.xyz = (r10.yyy) * (-(r6.xyz));
    r3 = (r7.yyyy) * (r5);
    r6.xyz = (r10.xxx) * (v1.xyz) + (r6.xyz);
    r3 = (r4) * (r7.xxxx) + (r3);
    r9.xyz = (r6.xyz) + (v3.xyz);
    r3 = saturate((r2) * (r7.zzzz) + (r3));
    r6.xyz = normalize(r9.xyz);
    r3 = (r1) * (r3);
    r5 = (r5) * (r6.yyyy);
    r9.x = dot(c[10], r3);
    r4 = (r4) * (r6.xxxx) + (r5);
    r9.y = dot(c[11], r3);
    r2 = saturate((r2) * (r6.zzzz) + (r4));
    r9.z = dot(c[20], r3);
    r1 = (r1) * (r2);
    r2.x = dot(c[10], r1);
    r2.w = max(abs(r6.y), abs(r6.z));
    r2.y = dot(c[11], r1);
    r0.w = max(abs(r6.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r3.xyz = (r6.xyz) * (c[5].xyz);
    r2.z = dot(c[20], r1);
    r1.xyz = (r3.xyz) * (r0.www) + (v0.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (c[24].x) * (c[24].x);
    r2.w = c[24].x;
    r3.xy = (r2.ww) * (r2.ww) + (c1.zw);
    r4.xy = (r0.ww) * (c1.xy);
    r5.x = 1.0f / (r3.x);
    r5.y = 1.0f / (r3.y);
    r2.xyz = (r1.xyz) * (c2.yyy) + (r2.xyz);
    r0.w = (r4.x) * (-(r5.x)) + (c2.x);
    r1.xyz = (r8.xyz) * (c2.yyy) + (r9.xyz);
    r3.xyz = (r2.xyz) * (r0.www);
    r2.xyz = (r1.www) * (c[18].xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r4.w = (r4.y) * (r5.y);
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r1.w = saturate(dot(r6.xyz, r7.xyz));
    r4.xyz = normalize(c[17].xyz);
    r2.w = saturate(dot(r6.xyz, r4.xyz));
    r3.w = dot(r4.xyz, r7.xyz);
    r3.w = saturate((r2.w) * (-(r1.w)) + (r3.w));
    r4.z = 1.0f / (r1.w);
    r3.w = (r4.w) * (r3.w);
    r4.z = saturate((r2.w) * (r4.z));
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r1.z = 1.0f / (r1.z);
    r3.w = (r3.w) * (r4.z);
    r1.xyz = (r4.www) * (r1.xyz);
    r2.w = (r0.w) * (r2.w) + (r3.w);
    r0.w = (r1.w) * (r1.w);
    r1.w = (r1.w) * (-(r1.w)) + (c2.x);
    r3.xyz = (r2.xyz) * (r2.www) + (r3.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c2.x) : (r1.w));
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.www) + (r3.xyz);
    r1.xyz = normalize(v3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (-(v4.xyz));
    r0.w = dot(r7.xyz, r1.xyz);
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v4.xyz);
    r1.w = max(c2.z, r0.w);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = pow(abs(r1.w), c2.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (r7.w) + (c2.x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
