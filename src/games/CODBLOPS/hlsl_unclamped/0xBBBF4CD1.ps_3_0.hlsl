// Mechanically reconstructed from 0xBBBF4CD1.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
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

    r1 = tex2D(s0, v1.xy);
    r0 = (r1.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.w = (r1.w) * (v0.w) + (c0.x);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c0.z)), ((r2.w) >= 0.0f ? (r0.y) : (c0.z)), ((r2.w) >= 0.0f ? (r0.z) : (c0.z)), ((r2.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r6.xyz = (r0.xyz) * (r0.xyz);
    r1 = tex2D(s1, v1.xy);
    r1 = float4(((r2.w) >= 0.0f ? (r1.x) : (c0.z)), ((r2.w) >= 0.0f ? (r1.y) : (c0.z)), ((r2.w) >= 0.0f ? (r1.z) : (c0.z)), ((r2.w) >= 0.0f ? (r1.w) : (c0.y)));
    r0.y = c0.z;
    r11.xyz = float3(((r2.w) >= 0.0f ? (c[5].x) : (r0.y)), ((r2.w) >= 0.0f ? (c[5].y) : (r0.y)), ((r2.w) >= 0.0f ? (c[5].w) : (r0.y)));
    r0.z = dot(v4.xyz, v4.xyz);
    r3.x = (r1.w) * (c3.x);
    r0.z = rsqrt(r0.z);
    r2.w = (r1.w) * (-(c3.x)) + (c3.y);
    r2.xyz = (r0.zzz) * (v4.xyz);
    r4.xyz = (v4.xyz) * (-(r0.zzz)) + (c[17].xyz);
    r0.xyz = normalize(v2.xyz);
    r3.y = saturate(dot(r0.xyz, -(r2.xyz)));
    r3.w = saturate(dot(r0.xyz, c[17].xyz));
    r3.z = (r3.y) * (r2.w) + (r3.x);
    r2.w = (r3.w) * (r2.w) + (r3.x);
    r7.w = (-(r3.y)) + (c0.y);
    r2.w = (r2.w) * (r3.z) + (c1.w);
    r2.w = 1.0f / (r2.w);
    r3.xyz = normalize(r4.xyz);
    r4.w = (r3.w) * (r2.w);
    r5.w = saturate(dot(r0.xyz, r3.xyz));
    r3.z = saturate(dot(r3.xyz, c[17].xyz));
    r3.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r2.w = exp2(r3.y);
    r3.z = (-(r3.z)) + (c0.y);
    r4.z = pow(abs(r5.w), r2.w);
    r3.y = (r3.z) * (r3.z);
    r2.w = (r2.w) * (c2.z) + (c2.w);
    r3.y = (r3.y) * (r3.y);
    r2.w = (r4.z) * (r2.w);
    r3.z = (r3.z) * (r3.y);
    r10.xyz = (r1.xyz) * (r1.xyz);
    r9.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r2.w = (r4.w) * (r2.w);
    r1.xyz = (r9.xyz) * (r3.zzz) + (r10.xyz);
    r8.xyz = (r3.www) * (c[18].xyz);
    r1.xyz = (r2.www) * (r1.xyz);
    r6.w = 1.0f / (r3.x);
    r1.xyz = (r11.zzz) * (r1.xyz);
    r2.w = (r1.w) * (c0.w);
    r4.xyz = (r1.xyz) * (c[19].xyz);
    r1 = tex2D(s12, v1.zw);
    r3.xy = (v1.zw) * (c3.yz);
    r3 = tex2D(s13, r3.xy);
    r5.xy = (v1.zw) * (c3.yz) + (c3.wz);
    r5 = tex2D(s13, r5.xy);
    r3.w = r5.y;
    r7.xy = (r3.yw) * (c1.yy) + (c1.zz);
    r1.w = dot(r7.xy, r7.xy) + (c0.z);
    r7.xyz = (r4.xyz) * (r1.yyy);
    r1.w = exp2(-(r1.w));
    r4 = tex2D(s14, v1.zw);
    r13.xy = (r4.xy) * (c1.xx);
    r1.z = saturate((r1.w) * (c2.x) + (c2.y));
    r5.xy = (r5.xz) * (r13.yy);
    r1.w = (r4.y) * (c1.x) + (-(r5.x));
    r12.xz = (r5.xy) * (c1.yy);
    r1.w = (r5.z) * (-(r13.y)) + (r1.w);
    r3.xy = (r3.xz) * (r13.xx);
    r12.y = (r1.w) + (r1.w);
    r1.w = (r4.x) * (c1.x) + (-(r3.x));
    r4.xz = (r3.xy) * (c1.yy);
    r1.w = (r3.z) * (-(r13.x)) + (r1.w);
    r4.y = (r1.w) + (r1.w);
    r1.w = dot(r2.xyz, r0.xyz);
    r3.xyz = (r12.xyz) * (r1.zzz) + (r4.xyz);
    r1.w = (r1.w) + (r1.w);
    r3.xyz = (r11.yyy) * (r3.xyz);
    r2.xyz = (r0.xyz) * (-(r1.www)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r0.z = (r7.w) * (r7.w);
    r1.w = (r7.w) * (r0.z);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r6.w) * (r1.w);
    r0.xyz = (r11.xxx) * (r0.xyz);
    r2.xyz = (r9.xyz) * (r1.www) + (r10.xyz);
    r1.xyz = (r1.yyy) * (r8.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r6.xyz) * (r1.xyz) + (r7.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[6].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
