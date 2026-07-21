// Mechanically reconstructed from 0x92B06C0F.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(31.875f, 0.797884583f, 1.0f, 0.0009765625f);
    const float4 c2 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c3 = float4(0.125f, 0.25f, 0.0f, 0.0f);
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

    r0.w = dot(v4.xyz, v4.xyz);
    r1.w = rsqrt(r0.w);
    r0.xyz = (v4.xyz) * (-(r1.www)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.y);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r2.xyz = (r1.www) * (v4.xyz);
    r4.y = (r0.w) * (r0.z);
    r1 = tex2D(s1, v1.xy);
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1 = float4(((r3.w) >= 0.0f ? (r1.x) : (c0.z)), ((r3.w) >= 0.0f ? (r1.y) : (c0.z)), ((r3.w) >= 0.0f ? (r1.z) : (c0.z)), ((r3.w) >= 0.0f ? (r1.w) : (c0.y)));
    r11.xyz = (r1.xyz) * (r1.xyz);
    r5.z = (r1.w) * (c1.y);
    r4.w = (r1.w) * (-(c1.y)) + (c1.z);
    r10.xyz = normalize(v2.xyz);
    r4.z = saturate(dot(r10.xyz, -(r2.xyz)));
    r2.w = saturate(dot(r10.xyz, c[17].xyz));
    r4.x = (r4.z) * (r4.w) + (r5.z);
    r4.w = (r2.w) * (r4.w) + (r5.z);
    r9.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r4.w = (r4.w) * (r4.x) + (c1.w);
    r1.xyz = (r9.xyz) * (r4.yyy) + (r11.xyz);
    r4.w = 1.0f / (r4.w);
    r5.w = (-(r4.z)) + (c0.y);
    r4.w = (r2.w) * (r4.w);
    r5.xyz = (r2.www) * (c[18].xyz);
    r4.xy = (r1.ww) * (c2.xy) + (c2.zw);
    r4.z = exp2(r4.y);
    r2.w = saturate(dot(r10.xyz, r3.xyz));
    r3.z = (r4.z) * (c3.x) + (c3.y);
    r3.y = pow(abs(r2.w), r4.z);
    r2.w = (r1.w) * (c0.w);
    r1.w = (r3.z) * (r3.y);
    r6.w = 1.0f / (r4.x);
    r1.w = (r4.w) * (r1.w);
    r1.xyz = (r1.xyz) * (r1.www);
    r12.yz = c0.yz;
    r6.xyz = float3(((r3.w) >= 0.0f ? (c[21].x) : (r12.z)), ((r3.w) >= 0.0f ? (c[21].y) : (r12.z)), ((r3.w) >= 0.0f ? (c[21].w) : (r12.z)));
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c0.z)), ((r3.w) >= 0.0f ? (r0.y) : (c0.z)), ((r3.w) >= 0.0f ? (r0.z) : (c0.z)), ((r3.w) >= 0.0f ? (r0.w) : (c0.z)));
    r3.w = max(abs(r10.y), abs(r10.z));
    r3.xyz = (r1.xyz) * (r6.zzz);
    r1.w = max(abs(r10.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r10.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (c[19].xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v5.xyz);
    r1 = tex3D(s11, r1.xyz);
    r3.xyz = (r3.xyz) * (r1.www);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.w = dot(r2.xyz, r10.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r3.w = (r3.w) + (r3.w);
    r4.xyz = (r6.yyy) * (r1.xyz);
    r2.xyz = (r10.xyz) * (-(r3.www)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r7.xyz = (r4.xyz) * (c1.xxx);
    r4.xyz = (r1.xyz) * (c0.www);
    r2 = tex3D(s11, v5.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r1.www) * (r5.xyz) + (r7.xyz);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r7.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r8.xyz = (r1.xyz) * (c1.xxx);
    r5.z = (r5.w) * (r5.w);
    r4 = (-(v4.yyyy)) + (c[7]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[6]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[8]);
    r5.w = (r5.w) * (r5.z);
    r1 = (r2) * (r2) + (r1);
    r6.w = (r6.w) * (r5.w);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r9.xyz = (r9.xyz) * (r6.www) + (r11.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r1 = saturate((r1) * (c[9]) + (r12.yyyy));
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r3.xyz = (r8.xyz) * (r9.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r3.xyz) * (r6.xxx) + (r7.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
