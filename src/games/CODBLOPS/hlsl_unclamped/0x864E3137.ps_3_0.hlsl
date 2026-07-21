// Mechanically reconstructed from 0x864E3137.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    const float4 c1 = float4(31.875f, 0.25f, 1.0f, 0.0f);
    const float4 c2 = float4(-2.0f, 3.0f, 0.5f, 0.0f);
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

    r0 = (v6.yyyy) * (c[32]);
    r0 = (v6.xxxx) * (c[31]) + (r0);
    r0 = (v6.zzzz) * (c[33]) + (r0);
    r0 = (r0) + (c[34]);
    r3.xy = (r0.ww) * (c[35].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s2, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[35].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s2, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[35].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[35].zw) + (r0.xy);
    r2 = tex2Dproj(s2, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s2, r0);
    r0 = (v6.xyzx) * (c1.zzzw) + (c1.wwwz);
    r2.w = dot(r0, c[28]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[25]);
    r2.y = dot(r0, c[26]);
    r1.w = dot(r1, c1.yyyy);
    r2.xy = (r2.ww) * (r2.xy);
    r1.x = dot(r0, c[27]);
    r0.xy = (r2.xy) * (c2.zz) + (c2.zz);
    r0 = tex2D(s3, r0.xy);
    r1.y = (r1.x) * (r1.x);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(c[23].yz, r1.xy) + (c[23].x);
    r0.xy = saturate((r1.xx) * (c[24].xy) + (c[24].zw));
    r0.z = saturate(1.0f / (r0.w));
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.w) : (r0.z));
    r3.xy = (r0.xy) * (r0.xy);
    r4.xy = (r0.xy) * (c2.xx) + (c2.yy);
    r0.xyz = (-(v6.xyz)) + (c[21].xyz);
    r2.w = (r3.x) * (r4.x);
    r1.xyz = normalize(r0.xyz);
    r0.z = (r3.y) * (-(r4.y)) + (c1.z);
    r0.y = dot(r1.xyz, c[29].xyz);
    r0.w = (r0.w) * (r2.w);
    r3.z = saturate((r0.y) * (c[30].x) + (c[30].y));
    r2.w = (r0.z) * (r0.w);
    r3.w = (r3.z) * (r3.z);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = (r3.z) * (c2.x) + (c2.y);
    r0.xyz = v2.xyz;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.w = (r3.w) * (r0.w);
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r0.w = (r2.w) * (r0.w);
    r10.xyz = normalize(r0.xyz);
    r0.xyz = (r2.xyz) * (r0.www);
    r0.w = saturate(dot(r1.xyz, r10.xyz));
    r2.xyz = (r1.www) * (r0.xyz);
    r1.xyz = (r0.www) * (c[22].xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r7.xyz = (r0.yzw) * (r0.yzw);
    r1.w = max(abs(r10.y), abs(r10.z));
    r3.xyz = (r1.xyz) * (r7.xyz);
    r0.w = max(abs(r10.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r1.xyz = (r10.xyz) * (c[5].xyz);
    r8.xyz = (r2.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r0.www) + (v7.xyz);
    r3 = tex3D(s11, r1.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r5 = (-(v6.yyyy)) + (c[7]);
    r1 = (r5) * (r5);
    r4 = (-(v6.xxxx)) + (c[6]);
    r1 = (r4) * (r4) + (r1);
    r2 = (-(v6.zzzz)) + (c[8]);
    r9.xyz = (r3.xyz) * (c1.xxx);
    r1 = (r2) * (r2) + (r1);
    r0.w = saturate(dot(c[17].xyz, r10.xyz));
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r3.xyz = (r0.www) * (c[18].xyz);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r2 = (r2) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r0.y = c1.z;
    r1 = saturate((r1) * (c[9]) + (r0.yyyy));
    r2 = saturate((r2) * (r10.zzzz) + (r4));
    r3.xyz = (r3.www) * (r3.xyz) + (r9.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r7.xyz) * (r3.xyz) + (r8.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r1.xyz = (r7.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
