// Mechanically reconstructed from 0x76A02AAF.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 2.0f, 0.25f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 4.0f);
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

    r0.xy = (v1.zw) * (c3.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r3.xy = (r1.yw) * (c2.xx) + (c2.yy);
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.z = dot(r3.xy, r3.xy) + (c1.x);
    r0.w = dot(r5.xy, r5.xy) + (c1.x);
    r0.z = exp2(-(r0.z));
    r0.w = exp2(-(r0.w));
    r1.y = (r0.z) * (c1.y) + (c1.z);
    r1.w = (r0.w) * (c1.y) + (c1.z);
    r0 = tex2D(s14, v1.zw);
    r4.xy = (r0.xy) * (c1.ww);
    r1.y = (r1.y) * (r1.w);
    r2.xy = (r2.xz) * (r4.yy);
    r0.w = dot(r3.xy, r5.xy) + (c1.x);
    r0.z = (r0.y) * (c1.w) + (-(r2.x));
    r0.w = saturate((r0.w) * (r1.y) + (r1.y));
    r0.z = (r2.z) * (-(r4.y)) + (r0.z);
    r2.xz = (r2.xy) * (c3.ww);
    r2.y = (r0.z) + (r0.z);
    r2.xyz = (r0.www) * (r2.xyz);
    r1.xy = (r1.xz) * (r4.xx);
    r2.w = (r0.x) * (c1.w) + (-(r1.x));
    r0 = v2;
    r3.xyz = (r5.xxx) * (v5.xyz) + (r0.xyz);
    r0.xz = (r1.ww) * (r1.xy);
    r3.xyz = (r5.yyy) * (v4.xyz) + (r3.xyz);
    r0.y = (r1.z) * (-(r4.x)) + (r2.w);
    r9.xyz = normalize(r3.xyz);
    r0.y = (r1.w) * (r0.y);
    r1.w = saturate(dot(c[17].xyz, r9.xyz));
    r8.xyz = (r0.xyz) * (c2.xzx) + (r2.xyz);
    r7.xyz = (r1.www) * (c[18].xyz);
    r1 = tex2D(s12, v1.zw);
    r2 = (v6.yyyy) * (c[24]);
    r2 = (v6.xxxx) * (c[23]) + (r2);
    r2 = (v6.zzzz) * (c[25]) + (r2);
    r2 = (r2) + (c[26]);
    r5.xy = (r2.ww) * (c[27].xy) + (r2.xy);
    r5.zw = r2.zw;
    r3 = tex2Dproj(s2, r5);
    r4.zw = r5.zw;
    r2.zw = r4.zw;
    r6.xy = (r5.ww) * (-(c[27].zw)) + (r2.xy);
    r6.zw = r2.zw;
    r6 = tex2Dproj(s2, r6);
    r3.w = r6.x;
    r4.xy = (r5.ww) * (-(c[27].xy)) + (r2.xy);
    r2.xy = (r5.ww) * (c[27].zw) + (r2.xy);
    r4 = tex2Dproj(s2, r4);
    r3.y = r4.x;
    r4 = tex2Dproj(s2, r2);
    r2 = (v6.xyzx) * (c3.xxxz) + (c3.zzzx);
    r0.z = dot(r2, c[20]);
    r3.z = r4.x;
    r0.z = 1.0f / (r0.z);
    r0.x = dot(r2, c[9]);
    r0.y = dot(r2, c[10]);
    r1.w = dot(r3, c2.wwww);
    r3.xy = (r0.zz) * (r0.xy);
    r0.x = dot(r2, c[11]);
    r2.xy = (r3.xy) * (c3.yy) + (c3.yy);
    r2 = tex2D(s3, r2.xy);
    r0.y = (r0.x) * (r0.x);
    r0.z = dot(c[7].yz, r0.xy) + (c[7].x);
    r0.xy = saturate((r0.xx) * (c[8].xy) + (c[8].zw));
    r1.z = saturate(1.0f / (r0.z));
    r1.x = ((-abs(r0.z)) >= 0.0f ? (c1.x) : (r1.z));
    r4.xy = (r0.xy) * (r0.xy);
    r5.xy = (r0.xy) * (c4.xx) + (c4.yy);
    r0.xyz = (-(v6.xyz)) + (c[5].xyz);
    r2.w = (r4.x) * (r5.x);
    r3.xyz = normalize(r0.xyz);
    r1.z = (r4.y) * (-(r5.y)) + (c3.x);
    r0.z = dot(r3.xyz, c[21].xyz);
    r0.x = (r1.x) * (r2.w);
    r0.y = saturate((r0.z) * (c[22].x) + (c[22].y));
    r0.z = (r0.y) * (r0.y);
    r0.y = (r0.y) * (c4.x) + (c4.y);
    r1.z = (r1.z) * (r0.x);
    r1.x = (r0.z) * (r0.y);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.x = (r1.z) * (r1.x);
    r1.z = saturate(dot(r3.xyz, r9.xyz));
    r4.xyz = (r0.xyz) * (r1.xxx);
    r2 = tex2D(s0, v1.xy);
    r0.xyz = (r2.xyz) * (v0.xyz);
    r3.xyz = (r1.zzz) * (c[6].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r1.www) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r1.yyy) * (r7.xyz) + (r8.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
