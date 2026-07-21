// Mechanically reconstructed from 0x04E4639F.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 31.875f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 3.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex2D(s0, v1.xy);
    r0 = (r1.xyzx) * (c1.yyyz) + (c1.zzzy);
    r4.w = (r1.w) * (v0.w) + (c1.x);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c1.z)), ((r4.w) >= 0.0f ? (r0.y) : (c1.z)), ((r4.w) >= 0.0f ? (r0.z) : (c1.z)), ((r4.w) >= 0.0f ? (r0.w) : (c1.z)));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xy = (v1.zw) * (c1.yw);
    r1 = tex2D(s13, r1.xy);
    r2.xy = (v1.zw) * (c1.yw) + (c1.zw);
    r3 = tex2D(s13, r2.xy);
    r1.w = r3.y;
    r2 = tex2D(s1, v1.xy);
    r2.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2.z = c1.y;
    r4.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r5.xyz = float3(((r4.w) >= 0.0f ? (r2.x) : (c1.z)), ((r4.w) >= 0.0f ? (r2.y) : (c1.z)), ((r4.w) >= 0.0f ? (r2.z) : (c1.z)));
    r1.w = dot(r4.xy, r4.xy) + (c1.z);
    r1.y = dot(r5.xy, r5.xy) + (c1.z);
    r1.w = exp2(-(r1.w));
    r1.y = exp2(-(r1.y));
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r3.w = (r1.y) * (c2.x) + (c2.y);
    r2 = tex2D(s14, v1.zw);
    r6.xy = (r2.xy) * (c2.zz);
    r2.w = (r1.w) * (r3.w);
    r3.xy = (r3.xz) * (r6.yy);
    r1.w = dot(r4.xy, r5.xy) + (c1.z);
    r1.y = (r2.y) * (c2.z) + (-(r3.x));
    r1.w = saturate((r1.w) * (r2.w) + (r2.w));
    r1.y = (r3.z) * (-(r6.y)) + (r1.y);
    r3.xz = (r3.xy) * (c2.ww);
    r3.y = (r1.y) + (r1.y);
    r4.xyz = (r1.www) * (r3.xyz);
    r1.xy = (r1.xz) * (r6.xx);
    r1.w = (r2.x) * (c2.z) + (-(r1.x));
    r2.xyz = (-(v6.xyz)) + (c[5].xyz);
    r3.xz = (r3.ww) * (r1.xy);
    r6.y = dot(r2.xyz, r2.xyz);
    r1.w = (r1.z) * (-(r6.x)) + (r1.w);
    r2.w = rsqrt(r6.y);
    r3.y = (r3.w) * (r1.w);
    r6.x = 1.0f / (r2.w);
    r1.xyz = (r3.xyz) * (c3.xzx) + (r4.xyz);
    r4.xy = saturate((r6.xx) * (c[8].xy) + (c[8].zw));
    r3.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c3.yy) + (c3.ww);
    r1.w = dot(c[7].yz, r6.xy) + (c[7].x);
    r6.xy = (r3.xy) * (r4.xy);
    r3.xyz = (r5.zzz) * (r1.xyz);
    r1.w = (r1.w) * (r6.x);
    r4.xyz = (r2.xyz) * (r2.www);
    r3.w = (r6.y) * (r1.w);
    r2 = tex2D(s12, v1.zw);
    r1 = v2;
    r1.xyz = (r5.xxx) * (v5.xyz) + (r1.xyz);
    r5.xyz = (r5.yyy) * (v4.xyz) + (r1.xyz);
    r1.xyz = normalize(r5.xyz);
    r1.z = saturate(dot(r4.xyz, r1.xyz));
    r2.w = (r3.w) * (r2.y);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r1.xyz = (r2.www) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[9].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
