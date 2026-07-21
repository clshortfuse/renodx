// Mechanically reconstructed from 0x5F0D7444.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(-1.0f, 1.0f, 8.0f, 3.5f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r2 = tex2D(s13, r0.xy);
    r1.w = r2.y;
    r0.xy = (r1.yw) * (c2.xx) + (c2.yy);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r1.w = exp2(-(r0.w));
    r0 = tex2D(s14, v1.zw);
    r5.xy = (r0.xy) * (c1.ww);
    r1.w = saturate((r1.w) * (c2.z) + (c2.w));
    r2.xy = (r2.xz) * (r5.yy);
    r0.w = (r0.y) * (c1.w) + (-(r2.x));
    r3.xz = (r2.xy) * (c2.xx);
    r0.w = (r2.z) * (-(r5.y)) + (r0.w);
    r1.xy = (r1.xz) * (r5.xx);
    r3.y = (r0.w) + (r0.w);
    r2.w = (r0.x) * (c1.w) + (-(r1.x));
    r0 = tex2D(s2, v5.zw);
    r2.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s1, v5.xy);
    r0.xyz = (r0.xyz) + (c0.xxx);
    r9.xyz = (v0.zzz) * (r2.xyz) + (c0.yyy);
    r7.xyz = (v0.yyy) * (r0.xyz) + (c0.yyy);
    r0 = tex2D(s3, v1.xy);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r2.xz = (r1.xy) * (c2.xx);
    r4.xyz = (r9.xyz) * (r0.xyz);
    r2.w = (r1.z) * (-(r5.x)) + (r2.w);
    r1.xyz = (r4.xyz) * (-(r4.xyz)) + (c0.yyy);
    r0.xyz = normalize(v4.xyz);
    r8.xyz = normalize(v2.xyz);
    r3.w = (r0.w) * (c0.w) + (c0.y);
    r2.y = saturate(dot(r8.xyz, -(r0.xyz)));
    r0.w = (r0.w) * (c0.z);
    r2.y = (-(r2.y)) + (c0.y);
    r4.w = 1.0f / (r3.w);
    r3.w = (r2.y) * (r2.y);
    r3.w = (r2.y) * (r3.w);
    r2.y = dot(r0.xyz, r8.xyz);
    r3.w = (r4.w) * (r3.w);
    r2.y = (r2.y) + (r2.y);
    r1.xyz = (r1.xyz) * (r3.www);
    r0.xyz = (r8.xyz) * (-(r2.yyy)) + (r0.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r4.xyz) * (r4.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) * (c[20].xxx);
    r2.y = (r2.w) + (r2.w);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r3.xyz) * (r1.www) + (r2.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r5.xyz = (r1.xyz) * (c[20].yyy);
    r6.xyz = (r0.xyz) * (c0.zzz);
    r4 = tex2D(s0, v1.xy);
    r3 = (-(v4.yyyy)) + (c[6]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r7.xyz = (r7.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = (r9.xyz) * (r7.xyz);
    r3 = (r3) * (r4);
    r3 = (r8.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r8.xxxx) + (r3);
    r3.z = c0.y;
    r0 = saturate((r0) * (c[8]) + (r3.zzzz));
    r1 = saturate((r1) * (r8.zzzz) + (r2));
    r2.xyz = (r7.xyz) * (r7.xyz);
    r0 = (r0) * (r1);
    r3.xyz = (r2.xyz) * (r5.xyz) + (r6.xyz);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r2.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
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
