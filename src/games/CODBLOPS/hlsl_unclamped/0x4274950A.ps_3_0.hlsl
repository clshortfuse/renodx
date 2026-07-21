// Mechanically reconstructed from 0x4274950A.ps_3_0.cso.
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
    const float4 c0 = float4(1.0f, 8.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 r13 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v3.xyz, v3.xyz);
    r1.x = rsqrt(r0.w);
    r10.xyz = (r1.xxx) * (v3.xyz);
    r9.xyz = normalize(v1.xyz);
    r1.y = saturate(dot(r9.xyz, -(r10.xyz)));
    r0 = tex2D(s2, v0.xy);
    r2.z = (r0.w) * (c0.z);
    r1.z = (r0.w) * (-(c0.z)) + (c0.x);
    r1.w = saturate(dot(r9.xyz, c[17].xyz));
    r2.w = (r1.y) * (r1.z) + (r2.z);
    r1.z = (r1.w) * (r1.z) + (r2.z);
    r1.z = (r1.z) * (r2.w) + (c3.x);
    r2.xyz = (v3.xyz) * (-(r1.xxx)) + (c[17].xyz);
    r1.z = 1.0f / (r1.z);
    r7.w = (-(r1.y)) + (c0.x);
    r2.w = (r1.w) * (r1.z);
    r11.xyz = (r1.www) * (c[18].xyz);
    r1.xyz = normalize(r2.xyz);
    r2.y = saturate(dot(r9.xyz, r1.xyz));
    r3.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r1.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.z = exp2(r3.y);
    r1.x = pow(abs(r2.y), r2.z);
    r1.w = (-(r1.w)) + (c0.x);
    r1.y = (r2.z) * (c3.y) + (c3.z);
    r1.z = (r1.w) * (r1.w);
    r1.y = (r1.x) * (r1.y);
    r1.z = (r1.z) * (r1.z);
    r2.w = (r2.w) * (r1.y);
    r1.w = (r1.w) * (r1.z);
    r7.xyz = (r0.xyz) * (r0.xyz);
    r6.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.xxx);
    r0.xyz = (r6.xyz) * (r1.www) + (r7.xyz);
    r1.w = c0.x;
    r2.xyz = (r1.www) + (-(c[5].xyw));
    r1 = tex2D(s1, v4.zw);
    r8.w = (r1.w) * (v4.y);
    r0.xyz = (r2.www) * (r0.xyz);
    r8.xyz = (r8.www) * (r2.xyz) + (c[5].xyw);
    r6.w = 1.0f / (r3.x);
    r0.xyz = (r0.xyz) * (r8.zzz);
    r0.w = (r0.w) * (c0.y);
    r12.xyz = (r0.xyz) * (c[19].xyz);
    r2 = tex2D(s12, v0.zw);
    r0.xy = (v0.zw) * (c0.xw);
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r5 = tex2D(s13, r0.xy);
    r3.w = r5.y;
    r0.xy = (r3.yw) * (c2.xx) + (c2.yy);
    r0.z = dot(r0.xy, r0.xy) + (c1.z);
    r4 = tex2D(s14, v0.zw);
    r13.xy = (r4.xy) * (c1.ww);
    r0.z = exp2(-(r0.z));
    r0.xy = (r5.xz) * (r13.yy);
    r2.w = saturate((r0.z) * (c2.z) + (c2.w));
    r2.z = (r4.y) * (c1.w) + (-(r0.x));
    r0.xz = (r0.xy) * (c2.xx);
    r3.xy = (r3.xz) * (r13.xx);
    r0.y = (r5.z) * (-(r13.y)) + (r2.z);
    r2.z = (r4.x) * (c1.w) + (-(r3.x));
    r0.y = (r0.y) + (r0.y);
    r2.z = (r3.z) * (-(r13.x)) + (r2.z);
    r3.xz = (r3.xy) * (c2.xx);
    r3.y = (r2.z) + (r2.z);
    r0.xyz = (r0.xyz) * (r2.www) + (r3.xyz);
    r0.xyz = (r8.yyy) * (r0.xyz);
    r5.xyz = (r12.xyz) * (r2.yyy);
    r4.xyz = (r2.yyy) * (r11.xyz) + (r0.xyz);
    r2 = tex2D(s0, v0.xy);
    r0.xyz = lerp(r2.xyz, r1.xyz, r8.www);
    r2.w = (r2.w) * (-(v4.x)) + (c0.x);
    r1.z = dot(r10.xyz, r9.xyz);
    r1.w = (r1.w) * (-(v4.y)) + (c0.x);
    r2.z = (r1.z) + (r1.z);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r9.xyz) * (-(r2.zzz)) + (r10.xyz);
    r0 = texCUBElod(s15, r0);
    r0.w = (r7.w) * (r7.w);
    r0.w = (r7.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r6.w) * (r0.w);
    r0.xyz = (r8.xxx) * (r0.xyz);
    r2.xyz = (r6.xyz) * (r0.www) + (r7.xyz);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r5.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.w = (r2.w) * (-(r1.w)) + (c0.x);
    r0.xyz = (r0.xyz) * (c0.yyy) + (r1.xyz);
    r1.xyz = (r0.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
