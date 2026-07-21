// Mechanically reconstructed from 0x746D6727.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, -2.0f, 3.0f);
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

    r0.xy = (v4.ww) * (c[20].xy) + (v4.xy);
    r0.zw = v4.zw;
    r0 = tex2Dproj(s1, r0);
    r1.xy = (v4.ww) * (-(c[20].xy)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.y = r1.x;
    r1.xy = (v4.ww) * (c[20].zw) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.xy = (v4.ww) * (-(c[20].zw)) + (v4.xy);
    r1.zw = v4.zw;
    r1 = tex2Dproj(s1, r1);
    r0.w = r1.x;
    r1.w = dot(r0, c12.yyyy);
    r0 = tex2D(s12, v1.zw);
    r1.xyz = (-(v5.xyz)) + (c[5].xyz);
    r3.y = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r3.y);
    r2.xyz = (r1.xyz) * (r0.zzz);
    r0.w = dot(r2.xyz, c[8].xyz);
    r0.w = saturate((r0.w) * (c[9].x) + (c[9].y));
    r0.w = (r0.w) * (c[9].w);
    r2.w = lerp(r0.y, r1.w, r0.w);
    r3.x = 1.0f / (r0.z);
    r0.w = dot(c[10].yz, r3.xy) + (c[10].x);
    r0.xy = saturate((r3.xx) * (c[11].xy) + (c[11].zw));
    r3.xy = (r0.xy) * (r0.xy);
    r8.xyz = normalize(v5.xyz);
    r4.xy = (r0.xy) * (c12.zz) + (c12.ww);
    r0.xyz = (r1.xyz) * (r0.zzz) + (-(r8.xyz));
    r3.xy = (r3.xy) * (r4.xy);
    r1.xyz = normalize(r0.xyz);
    r0.z = (r0.w) * (r3.x);
    r0.w = saturate(dot(r1.xyz, r2.xyz));
    r3.w = (r3.y) * (r0.z);
    r3.z = (-(r0.w)) + (c0.y);
    r0.w = (r3.z) * (r3.z);
    r7.xyz = normalize(v2.xyz);
    r3.y = (r0.w) * (r0.w);
    r1.w = saturate(dot(r7.xyz, r2.xyz));
    r0 = tex2D(s2, v1.xy);
    r2.y = (r0.w) * (c0.z);
    r2.z = (r0.w) * (-(c0.z)) + (c0.y);
    r0.x = saturate(dot(r7.xyz, -(r8.xyz)));
    r0.z = (r1.w) * (r2.z) + (r2.y);
    r2.y = (r0.x) * (r2.z) + (r2.y);
    r2.z = (r3.z) * (r3.y);
    r0.z = (r0.z) * (r2.y) + (c3.w);
    r3.z = 1.0f / (r0.z);
    r2.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r3.y = saturate(dot(r7.xyz, r1.xyz));
    r0.z = exp2(r2.y);
    r1.z = pow(abs(r3.y), r0.z);
    r0.z = (r0.z) * (c12.x) + (c12.y);
    r1.y = (r1.w) * (r3.z);
    r0.z = (r1.z) * (r0.z);
    r1.z = (r2.z) * (c1.x) + (c1.y);
    r0.z = (r1.y) * (r0.z);
    r4.w = (r2.w) * (r3.w);
    r0.z = (r1.z) * (r0.z);
    r0.x = (-(r0.x)) + (c0.y);
    r0.z = (r0.y) * (r0.z);
    r6.xyz = (r1.www) * (c[6].xyz);
    r1.xyz = (r0.zzz) * (c[7].xyz);
    r0.z = 1.0f / (r2.x);
    r5.xyz = (r4.www) * (r1.xyz);
    r2 = tex2D(s0, v1.xy);
    r1.xy = (v1.zw) * (c0.yw);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r3 = tex2D(s13, r3.xy);
    r1.w = r3.y;
    r2.xyz = (r2.xyz) * (v0.xyz);
    r9.xy = (r1.yw) * (c2.xx) + (c2.yy);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r9.xy, r9.xy) + (c3.z);
    r2 = tex2D(s14, v1.zw);
    r10.xy = (r2.xy) * (c1.zz);
    r1.w = exp2(-(r1.w));
    r3.xy = (r3.xz) * (r10.yy);
    r1.w = saturate((r1.w) * (c2.z) + (c2.w));
    r2.w = (r2.y) * (c1.z) + (-(r3.x));
    r9.xz = (r3.xy) * (c1.ww);
    r1.xy = (r1.xz) * (r10.xx);
    r2.z = (r3.z) * (-(r10.y)) + (r2.w);
    r2.w = (r2.x) * (c1.z) + (-(r1.x));
    r9.y = (r2.z) + (r2.z);
    r1.z = (r1.z) * (-(r10.x)) + (r2.w);
    r2.xz = (r1.xy) * (c1.ww);
    r2.y = (r1.z) + (r1.z);
    r1.xyz = (r9.xyz) * (r1.www) + (r2.xyz);
    r1.w = dot(r8.xyz, r7.xyz);
    r3.xyz = (r0.yyy) * (r1.xyz);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r7.xyz) * (-(r1.www)) + (r8.xyz);
    r1.w = (r0.w) * (c0.x);
    r1 = texCUBElod(s15, r1);
    r0.w = (r0.x) * (r0.x);
    r0.w = (r0.x) * (r0.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.z) * (r0.w);
    r0.xyz = (r0.yyy) * (r1.xyz);
    r0.w = (r0.w) * (c1.x) + (c1.y);
    r1.xyz = (r4.www) * (r6.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r1.xyz = (r4.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[21].w;

    return oC0;
}
