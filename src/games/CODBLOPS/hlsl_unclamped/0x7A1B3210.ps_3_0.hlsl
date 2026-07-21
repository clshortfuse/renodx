// Mechanically reconstructed from 0x7A1B3210.ps_3_0.cso.
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
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c2.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r3.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r1.w = dot(r3.xy, r3.xy) + (c1.x);
    r0 = tex2D(s1, v1.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.z = exp2(-(r1.w));
    r0.w = dot(r0.xy, r0.xy) + (c1.x);
    r1.y = (r0.z) * (c1.y) + (c1.z);
    r0.w = exp2(-(r0.w));
    r1.w = dot(r3.xy, r0.xy) + (c1.x);
    r2.w = (r0.w) * (c1.y) + (c1.z);
    r0 = tex2D(s14, v1.zw);
    r4.xy = (r0.xy) * (c1.ww);
    r0.w = (r1.y) * (r2.w);
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = saturate((r1.w) * (r0.w) + (r0.w));
    r0.z = (r0.y) * (c1.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c2.ww);
    r0.z = (r2.z) * (-(r4.y)) + (r0.z);
    r3.y = (r0.z) + (r0.z);
    r1.xy = (r1.xz) * (r4.xx);
    r3.xyz = (r0.www) * (r3.xyz);
    r1.w = (r0.x) * (c1.w) + (-(r1.x));
    r2.xz = (r2.ww) * (r1.xy);
    r0 = (v4.yyyy) * (c[31]);
    r1.w = (r1.z) * (-(r4.x)) + (r1.w);
    r0 = (v4.xxxx) * (c[30]) + (r0);
    r2.y = (r2.w) * (r1.w);
    r0 = (v4.zzzz) * (c[32]) + (r0);
    r6.xyz = (r2.xyz) * (c3.xzx) + (r3.xyz);
    r0 = (r0) + (c[33]);
    r3.xy = (r0.ww) * (c[34].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s2, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[34].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s2, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[34].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[34].zw) + (r0.xy);
    r2 = tex2Dproj(s2, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s2, r0);
    r0 = (v4.xyzx) * (c2.xxxz) + (c2.zzzx);
    r2.w = dot(r0, c[27]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[24]);
    r2.y = dot(r0, c[25]);
    r1.w = dot(r1, c3.wwww);
    r2.xy = (r2.ww) * (r2.xy);
    r1.x = dot(r0, c[26]);
    r0.xy = (r2.xy) * (c2.yy) + (c2.yy);
    r0 = tex2D(s3, r0.xy);
    r1.y = (r1.x) * (r1.x);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(c[22].yz, r1.xy) + (c[22].x);
    r1.xy = saturate((r1.xx) * (c[23].xy) + (c[23].zw));
    r1.z = saturate(1.0f / (r0.w));
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.x) : (r1.z));
    r3.xy = (r1.xy) * (r1.xy);
    r4.xy = (r1.xy) * (c4.xx) + (c4.yy);
    r2.xyz = (-(v4.xyz)) + (c[20].xyz);
    r3.w = (r3.x) * (r4.x);
    r1.xyz = normalize(r2.xyz);
    r2.y = (r3.y) * (-(r4.y)) + (c2.x);
    r2.w = dot(r1.xyz, c[28].xyz);
    r0.w = (r0.w) * (r3.w);
    r2.z = saturate((r2.w) * (c[29].x) + (c[29].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c4.x) + (c4.y);
    r0.w = (r2.y) * (r0.w);
    r2.w = (r2.w) * (r2.z);
    r0.w = (r0.w) * (r2.w);
    r9.xyz = normalize(v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = saturate(dot(r1.xyz, r9.xyz));
    r7.xyz = (r1.www) * (r0.xyz);
    r8.xyz = (r0.www) * (c[21].xyz);
    r4 = tex2D(s0, v1.xy);
    r3 = (-(v4.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r4.xyz = (r4.xyz) * (v0.xyz);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = (r4.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r8.xyz = (r8.xyz) * (r5.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r3.w = c2.x;
    r0 = saturate((r0) * (c[8]) + (r3.wwww));
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.xyz = (r7.xyz) * (r8.xyz);
    r0 = (r0) * (r1);
    r2.xyz = (r5.xyz) * (r6.xyz) + (r2.xyz);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c2.x;

    return oC0;
}
