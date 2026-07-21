// Mechanically reconstructed from 0x29061C17.ps_3_0.cso.
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
    float4 r9 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s2, v1.xy);
    r1.zw = (r2.ww) * (c1.zy) + (c1.wz);
    r0 = tex2D(s0, v1.xy);
    r2.z = (r0.w) * (v0.w) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r3 = float4(((r2.z) >= 0.0f ? (r1.x) : (c1.z)), ((r2.z) >= 0.0f ? (r1.y) : (c1.z)), ((r2.z) >= 0.0f ? (r1.z) : (c1.z)), ((r2.z) >= 0.0f ? (r1.w) : (c1.y)));
    r5.z = (r3.w) * (c2.z);
    r2.x = (r3.w) * (-(c2.z)) + (c2.w);
    r2.w = dot(v6.xyz, v6.xyz);
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r4.w = rsqrt(r2.w);
    r4.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r1.xyz = (r4.www) * (v6.xyz);
    r8.xyz = normalize(r4.xyz);
    r3.y = saturate(dot(r8.xyz, -(r1.xyz)));
    r2.w = saturate(dot(r8.xyz, c[17].xyz));
    r3.x = (r3.y) * (r2.x) + (r5.z);
    r2.x = (r2.w) * (r2.x) + (r5.z);
    r5.xyz = (v6.xyz) * (-(r4.www)) + (c[17].xyz);
    r2.x = (r2.x) * (r3.x) + (c3.x);
    r6.w = (-(r3.y)) + (c1.y);
    r2.x = 1.0f / (r2.x);
    r4.w = (r2.w) * (r2.x);
    r3.xy = (r3.ww) * (c4.xy) + (c4.zw);
    r6.xyz = (r2.www) * (c[18].xyz);
    r5.w = exp2(r3.y);
    r9.w = 1.0f / (r3.x);
    r4.xyz = normalize(r5.xyz);
    r2.w = (r5.w) * (c3.y) + (c3.z);
    r2.x = saturate(dot(r4.xyz, c[17].xyz));
    r4.z = saturate(dot(r8.xyz, r4.xyz));
    r2.x = (-(r2.x)) + (c1.y);
    r3.x = pow(abs(r4.z), r5.w);
    r3.y = (r2.x) * (r2.x);
    r2.w = (r2.w) * (r3.x);
    r3.y = (r3.y) * (r3.y);
    r2.w = (r4.w) * (r2.w);
    r2.x = (r2.x) * (r3.y);
    r9.z = (r3.z) * (r3.z);
    r8.w = (r3.z) * (-(r3.z)) + (c1.y);
    r3.w = (r3.w) * (c2.x);
    r2.x = (r8.w) * (r2.x) + (r9.z);
    r2.w = (r2.w) * (r2.x);
    r7.w = ((r2.z) >= 0.0f ? (r2.y) : (c1.z));
    r0 = float4(((r2.z) >= 0.0f ? (r0.x) : (c1.z)), ((r2.z) >= 0.0f ? (r0.y) : (c1.z)), ((r2.z) >= 0.0f ? (r0.z) : (c1.z)), ((r2.z) >= 0.0f ? (r0.w) : (c1.z)));
    r3.y = max(abs(r8.y), abs(r8.z));
    r3.z = (r2.w) * (r7.w);
    r2.w = max(abs(r8.x), r3.y);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r8.xyz) * (c[5].xyz);
    r3.xyz = (r3.zzz) * (c[19].xyz);
    r2.xyz = (r2.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r2.xyz);
    r4.xyz = (r3.xyz) * (r2.www);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.z = dot(r1.xyz, r8.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.z = (r3.z) + (r3.z);
    r2.xyz = (r7.www) * (r2.xyz);
    r3.xyz = (r8.xyz) * (-(r3.zzz)) + (r1.xyz);
    r3 = texCUBElod(s15, r3);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c2.yyy);
    r5.xyz = (r1.xyz) * (c2.xxx);
    r3 = tex3D(s11, v7.xyz);
    r1.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.www) * (r6.xyz) + (r2.xyz);
    r1.xyz = (r5.xyz) * (r1.xyz);
    r7.xyz = (r0.xyz) * (r2.xyz) + (r4.xyz);
    r1.xyz = (r1.xyz) * (c2.yyy);
    r6.z = (r6.w) * (r6.w);
    r5 = (-(v6.yyyy)) + (c[7]);
    r2 = (r5) * (r5);
    r4 = (-(v6.xxxx)) + (c[6]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v6.zzzz)) + (c[8]);
    r6.w = (r6.w) * (r6.z);
    r2 = (r3) * (r3) + (r2);
    r9.w = (r9.w) * (r6.w);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r8.w = (r8.w) * (r9.w) + (r9.z);
    r5 = (r5) * (r6);
    r5 = (r8.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r8.xxxx) + (r5);
    r5.z = c1.y;
    r2 = saturate((r2) * (c[9]) + (r5.zzzz));
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r1.xyz = (r1.xyz) * (r8.www);
    r2 = (r2) * (r3);
    r3.xyz = (r1.xyz) * (r7.www) + (r7.xyz);
    r1.x = dot(c[10], r2);
    r1.y = dot(c[11], r2);
    r1.z = dot(c[20], r2);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
