// Mechanically reconstructed from 0xD6116517.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-1.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c11 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
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

    r0 = tex2D(s0, v0.xy);
    r1 = tex2D(s1, v4.zw);
    r1.xyz = (r1.xyz) + (c0.xxx);
    r1.xyz = (v4.yyy) * (r1.xyz) + (c0.yyy);
    r2.xyz = (r0.xyz) * (r1.xyz);
    r0.xyz = (-(v3.xyz)) + (c[5].xyz);
    r1.xyz = (r1.xyz) * (c0.zzz);
    r5.y = dot(r0.xyz, r0.xyz);
    r1.w = rsqrt(r5.y);
    r11.xyz = normalize(v3.xyz);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r0.xyz) * (r1.www) + (-(r11.xyz));
    r0.xyz = (r0.xyz) * (r1.www);
    r2.xyz = normalize(r3.xyz);
    r9.xyz = (r1.xyz) * (r1.xyz);
    r0.w = saturate(dot(r2.xyz, r0.xyz));
    r8.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r0.w = (-(r0.w)) + (c0.y);
    r5.x = 1.0f / (r1.w);
    r1.w = (r0.w) * (r0.w);
    r1.w = (r1.w) * (r1.w);
    r10.xyz = normalize(v1.xyz);
    r1.z = (r0.w) * (r1.w);
    r3.w = saturate(dot(r10.xyz, r0.xyz));
    r0 = tex2D(s2, v0.xy);
    r1.y = (r0.w) * (c3.x);
    r1.w = (r0.w) * (-(c3.x)) + (c3.y);
    r0.x = saturate(dot(r10.xyz, -(r11.xyz)));
    r0.z = (r3.w) * (r1.w) + (r1.y);
    r1.w = (r0.x) * (r1.w) + (r1.y);
    r1.xyz = (r8.xyz) * (r1.zzz) + (r9.xyz);
    r0.z = (r0.z) * (r1.w) + (c1.w);
    r0.x = (-(r0.x)) + (c0.y);
    r0.z = 1.0f / (r0.z);
    r2.w = (r3.w) * (r0.z);
    r3.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r2.z = saturate(dot(r10.xyz, r2.xyz));
    r0.z = exp2(r3.y);
    r1.w = pow(abs(r2.z), r0.z);
    r0.z = (r0.z) * (c2.z) + (c2.w);
    r6.xyz = (r3.www) * (c[6].xyz);
    r1.w = (r1.w) * (r0.z);
    r0.z = 1.0f / (r3.x);
    r1.w = (r2.w) * (r1.w);
    r1.xyz = (r1.xyz) * (r1.www);
    r3.xy = saturate((r5.xx) * (c[9].xy) + (c[9].zw));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c11.xx) + (c11.yy);
    r1.w = dot(c[8].yz, r5.xy) + (c[8].x);
    r2.xy = (r2.xy) * (r3.xy);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r1.w = (r1.w) * (r2.x);
    r5.xyz = (r1.xyz) * (c[7].xyz);
    r4.w = (r2.y) * (r1.w);
    r2 = tex2D(s12, v0.zw);
    r1.xy = (v0.zw) * (c3.yz);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (v0.zw) * (c3.yz) + (c3.wz);
    r3 = tex2D(s13, r3.xy);
    r1.w = r3.y;
    r3.w = (r4.w) * (r2.y);
    r2.xy = (r1.yw) * (c1.yy) + (c1.zz);
    r5.xyz = (r5.xyz) * (r3.www);
    r1.w = dot(r2.xy, r2.xy) + (c3.w);
    r2 = tex2D(s14, v0.zw);
    r12.xy = (r2.xy) * (c1.xx);
    r1.w = exp2(-(r1.w));
    r3.xy = (r3.xz) * (r12.yy);
    r1.w = saturate((r1.w) * (c2.x) + (c2.y));
    r2.w = (r2.y) * (c1.x) + (-(r3.x));
    r7.xz = (r3.xy) * (c1.yy);
    r1.xy = (r1.xz) * (r12.xx);
    r2.z = (r3.z) * (-(r12.y)) + (r2.w);
    r2.w = (r2.x) * (c1.x) + (-(r1.x));
    r7.y = (r2.z) + (r2.z);
    r1.z = (r1.z) * (-(r12.x)) + (r2.w);
    r2.xz = (r1.xy) * (c1.yy);
    r2.y = (r1.z) + (r1.z);
    r1.xyz = (r7.xyz) * (r1.www) + (r2.xyz);
    r1.w = dot(r11.xyz, r10.xyz);
    r7.xyz = (r0.yyy) * (r1.xyz);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r10.xyz) * (-(r1.www)) + (r11.xyz);
    r1.w = (r0.w) * (c0.w);
    r1 = texCUBElod(s15, r1);
    r0.w = (r0.x) * (r0.x);
    r0.w = (r0.x) * (r0.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.z) * (r0.w);
    r0.xyz = (r0.yyy) * (r1.xyz);
    r3.xyz = (r8.xyz) * (r0.www) + (r9.xyz);
    r1.xyz = (r3.www) * (r6.xyz) + (r7.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r4.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
