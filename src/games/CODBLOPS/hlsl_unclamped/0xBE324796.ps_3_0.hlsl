// Mechanically reconstructed from 0xBE324796.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 31.875f);
    const float4 c2 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r1.z = c1.y;
    r0 = tex2D(s0, v1.xy);
    r2.z = (r0.w) * (v0.w) + (c1.x);
    r4.xyz = float3(((r2.z) >= 0.0f ? (r1.x) : (c1.z)), ((r2.z) >= 0.0f ? (r1.y) : (c1.z)), ((r2.z) >= 0.0f ? (r1.z) : (c1.z)));
    r1 = v2;
    r1.xyz = (r4.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r4.yyy) * (v4.xyz) + (r1.xyz);
    r3.xyz = normalize(r1.xyz);
    r2.w = max(abs(r3.y), abs(r3.z));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.z = max(abs(r3.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r3.xyz) * (c[5].xyz);
    r0 = float4(((r2.z) >= 0.0f ? (r0.x) : (c1.z)), ((r2.z) >= 0.0f ? (r0.y) : (c1.z)), ((r2.z) >= 0.0f ? (r0.z) : (c1.z)), ((r2.z) >= 0.0f ? (r0.w) : (c1.z)));
    r1.xyz = (r1.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r1.xyz);
    r1.xyz = (-(v6.xyz)) + (c[6].xyz);
    r6.y = dot(r1.xyz, r1.xyz);
    r4.w = rsqrt(r6.y);
    r6.x = 1.0f / (r4.w);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r5.xy = saturate((r6.xx) * (c[10].xy) + (c[10].zw));
    r4.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c2.xx) + (c2.yy);
    r3.w = dot(c[9].yz, r6.xy) + (c[9].x);
    r4.xy = (r4.xy) * (r5.xy);
    r2.xyz = (r4.zzz) * (r2.xyz);
    r3.w = (r3.w) * (r4.x);
    r2.xyz = (r2.xyz) * (c1.www);
    r3.w = (r4.y) * (r3.w);
    r1.xyz = (r1.xyz) * (r4.www);
    r2.w = (r2.w) * (r3.w);
    r3.w = saturate(dot(r1.xyz, r3.xyz));
    r1.xyz = c[7].xyz;
    r1.xyz = (r1.xyz) * (c[8].xxx);
    r1.xyz = (r3.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r2.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r1.xyz) * (r0.xyz);
    r2.w = c1.y;
    r0.x = dot(r2, c[20]);
    r0.y = dot(r2, c[21]);
    r0.z = dot(r2, c[22]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
