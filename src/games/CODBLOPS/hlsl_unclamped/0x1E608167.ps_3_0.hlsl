// Mechanically reconstructed from 0x1E608167.ps_3_0.cso.
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
    const float4 c1 = float4(31.875f, 0.797884583f, -2.0f, 3.0f);
    const float4 c2 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.125f, 0.25f, 0.0f, 0.0f);
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

    r1 = tex2D(s1, v1.xy);
    r0 = tex2D(s0, v1.xy);
    r2.w = (r0.w) * (v0.w) + (c0.x);
    r2.xyz = (-(v4.xyz)) + (c[6].xyz);
    r1 = float4(((r2.w) >= 0.0f ? (r1.x) : (c0.z)), ((r2.w) >= 0.0f ? (r1.y) : (c0.z)), ((r2.w) >= 0.0f ? (r1.z) : (c0.z)), ((r2.w) >= 0.0f ? (r1.w) : (c0.y)));
    r10.y = dot(r2.xyz, r2.xyz);
    r5.y = (r1.w) * (c1.y);
    r3.w = rsqrt(r10.y);
    r5.w = (r1.w) * (-(c2.x)) + (c2.y);
    r3.xyz = (r2.xyz) * (r3.www);
    r4.xyz = normalize(v2.xyz);
    r9.xyz = normalize(v4.xyz);
    r5.z = saturate(dot(r4.xyz, r3.xyz));
    r4.w = saturate(dot(r4.xyz, -(r9.xyz)));
    r0.w = (r5.z) * (r5.w) + (r5.y);
    r5.w = (r4.w) * (r5.w) + (r5.y);
    r5.w = (r0.w) * (r5.w) + (c2.z);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r5.w = 1.0f / (r5.w);
    r4.w = (-(r4.w)) + (c0.y);
    r5.w = (r5.z) * (r5.w);
    r5.xyz = (r5.zzz) * (c[7].xyz);
    r6.xyz = (r2.xyz) * (r3.www) + (-(r9.xyz));
    r10.x = 1.0f / (r3.w);
    r2.xyz = normalize(r6.xyz);
    r6.w = saturate(dot(r4.xyz, r2.xyz));
    r6.xy = (r1.ww) * (c3.xy) + (c3.zw);
    r2.y = saturate(dot(r2.xyz, r3.xyz));
    r2.z = exp2(r6.y);
    r3.w = 1.0f / (r6.x);
    r2.y = (-(r2.y)) + (c0.y);
    r3.z = pow(abs(r6.w), r2.z);
    r2.x = (r2.y) * (r2.y);
    r2.z = (r2.z) * (c4.x) + (c4.y);
    r2.x = (r2.x) * (r2.x);
    r2.z = (r3.z) * (r2.z);
    r2.y = (r2.y) * (r2.x);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r2.z = (r5.w) * (r2.z);
    r1.xyz = (r7.xyz) * (r2.yyy) + (r8.xyz);
    r1.xyz = (r2.zzz) * (r1.xyz);
    r2.y = c0.z;
    r3.xyz = float3(((r2.w) >= 0.0f ? (c[11].x) : (r2.y)), ((r2.w) >= 0.0f ? (c[11].y) : (r2.y)), ((r2.w) >= 0.0f ? (c[11].w) : (r2.y)));
    r1.w = (r1.w) * (c0.w);
    r1.xyz = (r1.xyz) * (r3.zzz);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c0.z)), ((r2.w) >= 0.0f ? (r0.y) : (c0.z)), ((r2.w) >= 0.0f ? (r0.z) : (c0.z)), ((r2.w) >= 0.0f ? (r0.w) : (c0.z)));
    r6.xyz = (r1.xyz) * (c[8].xyz);
    r1.z = dot(c[9].yz, r10.xy) + (c[9].x);
    r2.xy = saturate((r10.xx) * (c[10].xy) + (c[10].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c1.zz) + (c1.ww);
    r2.xy = (r1.xy) * (r2.xy);
    r2.w = max(abs(r4.y), abs(r4.z));
    r2.z = (r1.z) * (r2.x);
    r1.z = max(abs(r4.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r4.xyz) * (c[5].xyz);
    r3.z = (r2.y) * (r2.z);
    r1.xyz = (r1.xyz) * (r2.www) + (v5.xyz);
    r2 = tex3D(s11, r1.xyz);
    r3.z = (r3.z) * (r2.w);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r6.xyz = (r6.xyz) * (r3.zzz);
    r1.xyz = (r3.yyy) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c1.xxx);
    r2.w = dot(r9.xyz, r4.xyz);
    r5.xyz = (r3.zzz) * (r5.xyz) + (r1.xyz);
    r1.z = (r2.w) + (r2.w);
    r2.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r4.xyz) * (-(r1.zzz)) + (r9.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r0.xyz) * (c0.www);
    r1 = tex3D(s11, v5.xyz);
    r1.w = (r4.w) * (r4.w);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r4.w) * (r1.w);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r0.xyz) * (c1.xxx);
    r2.xyz = (r7.xyz) * (r1.www) + (r8.xyz);
    r1.xyz = (r4.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
