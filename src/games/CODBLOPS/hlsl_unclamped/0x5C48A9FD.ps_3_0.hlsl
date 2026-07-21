// Mechanically reconstructed from 0x5C48A9FD.ps_3_0.cso.
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
sampler2D s4 : register(s4);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
    float4 v7 : TEXCOORD8;
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
    const float4 c1 = float4(-0.5f, 0.5f, 4.06451607f, -2.06451607f);
    const float4 c2 = float4(4.0f, -0.5f, -2.07999992f, 200.0f);
    const float4 c3 = float4(-2.0f, 3.0f, 1.0f, 31.875f);
    const float4 c4 = float4(0.0f, 8.0f, 0.0f, 0.0f);
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

    r2.xy = c1.xy;
    r0.xy = (v7.xy) * (c[31].xx) + (r2.xx);
    r0.xy = (r0.xy) * (c[32].xx) + (r2.yy);
    r0 = tex2D(s1, r0.xy);
    r5.xy = (v7.xy) * (c[31].xx);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r1.xy = (r5.xy) * (c2.xx) + (c2.yy);
    r0.y = (r0.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[33].xx) + (r2.yy);
    r1 = tex2D(s2, r1.xy);
    r0.w = (r1.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c2.zz;
    r3.xy = (r0.zw) * (c[35].xx);
    r1.xyz = v6.xyz;
    r2.xyz = (r1.zxy) * (v4.yzx);
    r3.xy = (c[34].xx) * (r0.xy) + (r3.xy);
    r0.xyz = (r1.yzx) * (v4.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.xyz = (r3.xxx) * (v4.xyz) + (r0.xyz);
    r0.w = dot(-(v5.xyz), -(v5.xyz));
    r0.xyz = (r0.xyz) + (v6.xyz);
    r2.w = rsqrt(r0.w);
    r10.xyz = normalize(r0.xyz);
    r0.xyz = (r2.www) * (-(v5.xyz));
    r0.w = dot(-(r0.xyz), r10.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r10.xyz) * (-(r0.www)) + (-(r0.xyz));
    r1.xyz = (r0.yyy) * (v2.xyw);
    r1.xyz = (r0.xxx) * (v1.xyw) + (r1.xyz);
    r3.xyz = (r0.zzz) * (v3.xyw) + (r1.xyz);
    r0.w = 1.0f / (r3.z);
    r3.xy = (r3.xy) * (r0.ww);
    r1.xy = (r3.xy) * (c1.yx) + (c1.yy);
    r1 = tex2D(s0, r1.xy);
    r2.xyz = (r1.xyz) * (r1.xyz);
    r0.w = c4.x;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[28].x);
    r1.xyz = (r0.xyz) * (c[29].xxx);
    r0.xyz = (r2.xyz) * (r0.www);
    r2.xyz = (r1.xyz) * (c4.yyy);
    r0.w = max(abs(r3.x), abs(r3.y));
    r1.xyz = (r0.xyz) * (c[30].xxx) + (-(r2.xyz));
    r0.w = saturate((r0.w) * (-(r0.w)) + (c3.z));
    r3.w = max(abs(r10.y), abs(r10.z));
    r1.w = ((-(r3.z)) >= 0.0f ? (c4.x) : (r0.w));
    r0.w = max(abs(r10.x), r3.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v0.xyz);
    r0 = tex3D(s11, r0.xyz);
    r2.xyz = (-(v5.xyz)) + (c[21].xyz);
    r6.y = dot(r2.xyz, r2.xyz);
    r3.w = rsqrt(r6.y);
    r6.x = 1.0f / (r3.w);
    r4.xy = saturate((r6.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c3.xx) + (c3.yy);
    r1.w = dot(c[23].yz, r6.xy) + (c[23].x);
    r3.xy = (r3.xy) * (r4.xy);
    r2.xyz = (r2.xyz) * (r3.www);
    r1.w = (r1.w) * (r3.x);
    r1.w = (r3.y) * (r1.w);
    r4.xyz = (-(v5.xyz)) * (r2.www) + (r2.xyz);
    r0.w = (r0.w) * (r1.w);
    r3.xyz = normalize(r4.xyz);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r1.w = saturate(dot(r10.xyz, r3.xyz));
    r7.xyz = (r0.www) * (c[22].xyz);
    r0.w = pow(abs(r1.w), c2.w);
    r7.w = saturate(dot(r10.xyz, r2.xyz));
    r9.xyz = (r0.www) * (r7.xyz) + (r1.xyz);
    r1 = tex2D(s4, r5.xy);
    r0 = tex2D(s3, r5.xy);
    r5 = (-(v5.yyyy)) + (c[7]);
    r2 = (r5) * (r5);
    r4 = (-(v5.xxxx)) + (c[6]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v5.zzzz)) + (c[8]);
    r2 = (r3) * (r3) + (r2);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r1.w = c3.z;
    r2 = saturate((r2) * (c[9]) + (r1.wwww));
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r2 = (r2) * (r3);
    r4.x = dot(c[10], r2);
    r4.y = dot(c[11], r2);
    r4.z = dot(c[20], r2);
    r3.xyz = (r9.xyz) * (r1.xyz);
    r1.xyz = (r8.xyz) * (c3.www) + (r4.xyz);
    r1.xyz = (r7.www) * (r7.xyz) + (r1.xyz);
    r4.xyz = normalize(v5.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[25].xyz, r4.xyz);
    r1.w = saturate((c[27].y) * (r0.z) + (c[27].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[26].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v5.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
