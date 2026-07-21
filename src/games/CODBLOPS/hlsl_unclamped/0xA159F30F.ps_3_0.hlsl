// Mechanically reconstructed from 0xA159F30F.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.200000003f);
    const float4 c1 = float4(8.0f, 0.797884583f, 1.0f, 0.5f);
    const float4 c2 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c7 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r1 = tex2D(s0, v1.xy);
    r0 = (r1.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = (r1.w) * (v0.w) + (c0.x);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c0.z)), ((r2.w) >= 0.0f ? (r0.y) : (c0.z)), ((r2.w) >= 0.0f ? (r0.z) : (c0.z)), ((r2.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r1 = tex2D(s1, v1.xy);
    r0.xy = (r1.ww) * (c0.zy) + (c0.wz);
    r8.w = ((r2.w) >= 0.0f ? (r1.y) : (c0.z));
    r4.xy = float2(((r2.w) >= 0.0f ? (r0.x) : (c0.z)), ((r2.w) >= 0.0f ? (r0.y) : (c0.y)));
    r0.z = dot(v4.xyz, v4.xyz);
    r1.x = (r4.y) * (c1.y);
    r0.z = rsqrt(r0.z);
    r1.w = (r4.y) * (-(c1.y)) + (c1.z);
    r2.xyz = (r0.zzz) * (v4.xyz);
    r3.xyz = (v4.xyz) * (-(r0.zzz)) + (c[17].xyz);
    r0.xyz = normalize(v2.xyz);
    r1.y = saturate(dot(r0.xyz, -(r2.xyz)));
    r2.w = saturate(dot(r0.xyz, c[17].xyz));
    r1.z = (r1.y) * (r1.w) + (r1.x);
    r1.w = (r2.w) * (r1.w) + (r1.x);
    r10.w = (-(r1.y)) + (c0.y);
    r1.w = (r1.w) * (r1.z) + (c4.x);
    r1.w = 1.0f / (r1.w);
    r1.xyz = normalize(r3.xyz);
    r3.w = (r2.w) * (r1.w);
    r4.w = saturate(dot(r0.xyz, r1.xyz));
    r1.z = saturate(dot(r1.xyz, c[17].xyz));
    r1.xy = (r4.yy) * (c7.xy) + (c7.zw);
    r1.w = exp2(r1.y);
    r1.z = (-(r1.z)) + (c0.y);
    r3.z = pow(abs(r4.w), r1.w);
    r1.y = (r1.z) * (r1.z);
    r1.w = (r1.w) * (c4.y) + (c4.z);
    r1.y = (r1.y) * (r1.y);
    r1.w = (r3.z) * (r1.w);
    r1.z = (r1.z) * (r1.y);
    r7.w = (r4.x) * (r4.x);
    r6.w = (r4.x) * (-(r4.x)) + (c0.y);
    r1.w = (r3.w) * (r1.w);
    r1.z = (r6.w) * (r1.z) + (r7.w);
    r8.xyz = (r2.www) * (c[18].xyz);
    r1.w = (r1.w) * (r1.z);
    r9.w = 1.0f / (r1.x);
    r1.w = (r8.w) * (r1.w);
    r2.w = (r4.y) * (c1.x);
    r4.xyz = (r1.www) * (c[19].xyz);
    r1 = tex2D(s12, v1.zw);
    r3.xy = (v1.zw) * (c1.zw);
    r3 = tex2D(s13, r3.xy);
    r5.xy = (v1.zw) * (c2.xy) + (c2.zy);
    r5 = tex2D(s13, r5.xy);
    r3.w = r5.y;
    r7.xy = (r3.yw) * (c3.xx) + (c3.yy);
    r1.w = dot(r7.xy, r7.xy) + (c0.z);
    r7.xyz = (r4.xyz) * (r1.yyy);
    r1.w = exp2(-(r1.w));
    r4 = tex2D(s14, v1.zw);
    r10.xy = (r4.xy) * (c2.ww);
    r1.z = saturate((r1.w) * (c3.z) + (c3.w));
    r5.xy = (r5.xz) * (r10.yy);
    r1.w = (r4.y) * (c2.w) + (-(r5.x));
    r9.xz = (r5.xy) * (c3.xx);
    r1.w = (r5.z) * (-(r10.y)) + (r1.w);
    r3.xy = (r3.xz) * (r10.xx);
    r9.y = (r1.w) + (r1.w);
    r1.w = (r4.x) * (c2.w) + (-(r3.x));
    r4.xz = (r3.xy) * (c3.xx);
    r1.w = (r3.z) * (-(r10.x)) + (r1.w);
    r4.y = (r1.w) + (r1.w);
    r1.w = dot(r2.xyz, r0.xyz);
    r3.xyz = (r9.xyz) * (r1.zzz) + (r4.xyz);
    r1.w = (r1.w) + (r1.w);
    r3.xyz = (r8.www) * (r3.xyz);
    r2.xyz = (r0.xyz) * (-(r1.www)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r0.z = (r10.w) * (r10.w);
    r1.w = (r10.w) * (r0.z);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r9.w) * (r1.w);
    r0.xyz = (r8.www) * (r0.xyz);
    r1.w = (r6.w) * (r1.w) + (r7.w);
    r1.xyz = (r1.yyy) * (r8.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.xyz = (r6.xyz) * (r1.xyz) + (r7.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[5].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
