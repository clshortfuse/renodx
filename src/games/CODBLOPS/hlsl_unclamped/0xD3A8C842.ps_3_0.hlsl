// Mechanically reconstructed from 0xD3A8C842.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c2 = float4(31.875f, 0.797884583f, -2.0f, 3.0f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.0f, 0.0f);
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

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c1.x);
    r5.xyz = (-(v6.xyz)) + (c[6].xyz);
    r2.xy = float2(((r3.w) >= 0.0f ? (r1.x) : (c1.z)), ((r3.w) >= 0.0f ? (r1.y) : (c1.z)));
    r6.y = dot(r5.xyz, r5.xyz);
    r1 = v2;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r4.w = rsqrt(r6.y);
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r3.xyz = (r5.xyz) * (r4.www);
    r4.xyz = normalize(r1.xyz);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r6.w = saturate(dot(r4.xyz, r3.xyz));
    r2 = tex2D(s2, v1.xy);
    r2 = float4(((r3.w) >= 0.0f ? (r2.x) : (c1.z)), ((r3.w) >= 0.0f ? (r2.y) : (c1.z)), ((r3.w) >= 0.0f ? (r2.z) : (c1.z)), ((r3.w) >= 0.0f ? (r2.w) : (c1.y)));
    r5.w = (r2.w) * (c2.y);
    r9.xyz = normalize(v6.xyz);
    r1.y = (r2.w) * (-(c3.x)) + (c3.y);
    r1.x = saturate(dot(r4.xyz, -(r9.xyz)));
    r1.z = (r6.w) * (r1.y) + (r5.w);
    r1.y = (r1.x) * (r1.y) + (r5.w);
    r5.w = (-(r1.x)) + (c1.y);
    r1.z = (r1.z) * (r1.y) + (c3.z);
    r1.z = 1.0f / (r1.z);
    r5.xyz = (r5.xyz) * (r4.www) + (-(r9.xyz));
    r6.z = (r6.w) * (r1.z);
    r1.xyz = normalize(r5.xyz);
    r6.x = 1.0f / (r4.w);
    r5.z = saturate(dot(r4.xyz, r1.xyz));
    r1.z = saturate(dot(r1.xyz, r3.xyz));
    r1.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r1.y = exp2(r1.y);
    r4.w = 1.0f / (r1.x);
    r3.z = pow(abs(r5.z), r1.y);
    r1.z = (-(r1.z)) + (c1.y);
    r1.x = (r1.y) * (c12.x) + (c12.y);
    r1.y = (r1.z) * (r1.z);
    r1.x = (r3.z) * (r1.x);
    r1.y = (r1.y) * (r1.y);
    r3.z = (r6.z) * (r1.x);
    r1.z = (r1.z) * (r1.y);
    r8.xyz = (r2.xyz) * (r2.xyz);
    r7.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r2.w = (r2.w) * (c1.w);
    r1.xyz = (r7.xyz) * (r1.zzz) + (r8.xyz);
    r2.xyz = (r3.zzz) * (r1.xyz);
    r1.y = c1.z;
    r1.xyz = float3(((r3.w) >= 0.0f ? (c[20].x) : (r1.y)), ((r3.w) >= 0.0f ? (c[20].y) : (r1.y)), ((r3.w) >= 0.0f ? (c[20].w) : (r1.y)));
    r2.xyz = (r2.xyz) * (r1.zzz);
    r10.xy = c[9].xy;
    r3.xyz = (r10.yyy) * (c[8].xyz);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c1.z)), ((r3.w) >= 0.0f ? (r0.y) : (c1.z)), ((r3.w) >= 0.0f ? (r0.z) : (c1.z)), ((r3.w) >= 0.0f ? (r0.w) : (c1.z)));
    r5.xyz = (r2.xyz) * (r3.xyz);
    r1.z = dot(c[10].yz, r6.xy) + (c[10].x);
    r3.xy = saturate((r6.xx) * (c[11].xy) + (c[11].zw));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c2.zz) + (c2.ww);
    r3.xy = (r2.xy) * (r3.xy);
    r3.w = max(abs(r4.y), abs(r4.z));
    r1.z = (r1.z) * (r3.x);
    r2.z = max(abs(r4.x), r3.w);
    r3.w = 1.0f / (r2.z);
    r2.xyz = (r4.xyz) * (c[5].xyz);
    r1.z = (r3.y) * (r1.z);
    r2.xyz = (r2.xyz) * (r3.www) + (v7.xyz);
    r3 = tex3D(s11, r2.xyz);
    r3.w = (r1.z) * (r3.w);
    r2.xyz = (r3.xyz) * (r3.xyz);
    r6.xyz = (r5.xyz) * (r3.www);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r3.xyz = (r2.xyz) * (c2.xxx);
    r2.xyz = (r10.xxx) * (c[7].xyz);
    r2.xyz = (r6.www) * (r2.xyz);
    r1.z = dot(r9.xyz, r4.xyz);
    r5.xyz = (r3.www) * (r2.xyz) + (r3.xyz);
    r1.z = (r1.z) + (r1.z);
    r3.xyz = (r0.xyz) * (v0.xyz);
    r2.xyz = (r4.xyz) * (-(r1.zzz)) + (r9.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r0.xyz) * (c1.www);
    r2 = tex3D(s11, v7.xyz);
    r1.z = (r5.w) * (r5.w);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.z = (r5.w) * (r1.z);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.z = (r4.w) * (r1.z);
    r0.xyz = (r0.xyz) * (c2.xxx);
    r3.xyz = (r7.xyz) * (r1.zzz) + (r8.xyz);
    r2.xyz = (r4.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r2.xyz = (r0.xyz) * (r1.xxx) + (r2.xyz);
    r2.w = c1.y;
    r0.x = dot(r2, c[22]);
    r0.y = dot(r2, c[23]);
    r0.z = dot(r2, c[24]);
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
