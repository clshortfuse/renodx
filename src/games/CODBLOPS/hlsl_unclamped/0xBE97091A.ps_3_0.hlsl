// Mechanically reconstructed from 0xBE97091A.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

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
    const float4 c1 = float4(-0.5f, 1.0f, -0.0f, 0.200000003f);
    const float4 c2 = float4(8.0f, 31.875f, 0.797884583f, 1.0f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s2, v1.xy);
    r1.zw = (r2.ww) * (c1.zy) + (c1.wz);
    r0 = tex2D(s0, v1.xy);
    r2.w = (r0.w) * (v0.w) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r3 = float4(((r2.w) >= 0.0f ? (r1.x) : (c1.z)), ((r2.w) >= 0.0f ? (r1.y) : (c1.z)), ((r2.w) >= 0.0f ? (r1.z) : (c1.z)), ((r2.w) >= 0.0f ? (r1.w) : (c1.y)));
    r4.z = (r3.w) * (c2.z);
    r4.w = (r3.w) * (-(c2.z)) + (c2.w);
    r2.z = dot(v6.xyz, v6.xyz);
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r2.z = rsqrt(r2.z);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r7.xyz = (r2.zzz) * (v6.xyz);
    r6.xyz = normalize(r1.xyz);
    r1.y = saturate(dot(r6.xyz, -(r7.xyz)));
    r2.x = saturate(dot(r6.xyz, c[17].xyz));
    r1.x = (r1.y) * (r4.w) + (r4.z);
    r1.z = (r2.x) * (r4.w) + (r4.z);
    r4.xyz = (v6.xyz) * (-(r2.zzz)) + (c[17].xyz);
    r1.z = (r1.z) * (r1.x) + (c3.x);
    r8.w = (-(r1.y)) + (c1.y);
    r1.z = 1.0f / (r1.z);
    r2.z = (r2.x) * (r1.z);
    r1.xyz = normalize(r4.xyz);
    r5.xyz = (r2.xxx) * (c[18].xyz);
    r3.x = saturate(dot(r6.xyz, r1.xyz));
    r3.y = saturate(dot(r1.xyz, c[17].xyz));
    r1.xy = (r3.ww) * (c4.xy) + (c4.zw);
    r1.z = exp2(r1.y);
    r7.w = 1.0f / (r1.x);
    r2.x = pow(abs(r3.x), r1.z);
    r1.y = (-(r3.y)) + (c1.y);
    r1.z = (r1.z) * (c3.y) + (c3.z);
    r1.x = (r1.y) * (r1.y);
    r1.z = (r2.x) * (r1.z);
    r1.x = (r1.x) * (r1.x);
    r1.z = (r2.z) * (r1.z);
    r1.y = (r1.y) * (r1.x);
    r6.w = (r3.z) * (r3.z);
    r5.w = (r3.z) * (-(r3.z)) + (c1.y);
    r3.w = (r3.w) * (c2.x);
    r1.y = (r5.w) * (r1.y) + (r6.w);
    r1.z = (r1.z) * (r1.y);
    r4.w = ((r2.w) >= 0.0f ? (r2.y) : (c1.z));
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c1.z)), ((r2.w) >= 0.0f ? (r0.y) : (c1.z)), ((r2.w) >= 0.0f ? (r0.z) : (c1.z)), ((r2.w) >= 0.0f ? (r0.w) : (c1.z)));
    r2.w = max(abs(r6.y), abs(r6.z));
    r1.z = (r1.z) * (r4.w);
    r1.y = max(abs(r6.x), r2.w);
    r2.w = 1.0f / (r1.y);
    r2.xyz = (r6.xyz) * (c[5].xyz);
    r1.xyz = (r1.zzz) * (c[19].xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r2.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r4.xyz = (r1.xyz) * (r2.www);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.z = dot(r7.xyz, r6.xyz);
    r0.xyz = (r4.www) * (r0.xyz);
    r3.z = (r2.z) + (r2.z);
    r2.xyz = (r0.xyz) * (c2.yyy);
    r3.xyz = (r6.xyz) * (-(r3.zzz)) + (r7.xyz);
    r3 = texCUBElod(s15, r3);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r2.www) * (r5.xyz) + (r2.xyz);
    r5.xyz = (r0.xyz) * (c2.xxx);
    r2 = tex3D(s11, v7.xyz);
    r2.w = (r8.w) * (r8.w);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r8.w) * (r2.w);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r2.w = (r7.w) * (r2.w);
    r0.xyz = (r0.xyz) * (c2.yyy);
    r2.w = (r5.w) * (r2.w) + (r6.w);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r2.www);
    r0.xyz = (r0.xyz) * (r4.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
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
