// Mechanically reconstructed from 0xC9A12926.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
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
    const float4 c1 = float4(8.0f, 0.797884583f, 1.0f, 0.5f);
    const float4 c2 = float4(0.125f, 0.25f, 0.0f, 0.0f);
    const float4 c3 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0009765625f, 0.0f);
    const float4 c7 = float4(-0.0f, 1.0f, 0.600000024f, 0.400000006f);
    const float4 c8 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0.xy = (v0.zw) * (c1.zw);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r3 = tex2D(s13, r1.xy);
    r0.w = r3.y;
    r1 = tex2D(s1, v0.xy);
    r2.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1 = tex2D(s2, v6.zw);
    r7.w = (r1.w) * (v6.y);
    r4.xy = (r0.yw) * (c4.xx) + (c4.yy);
    r5.xy = (r7.ww) * (-(r2.xy)) + (r2.xy);
    r0.y = dot(r4.xy, r4.xy) + (c7.x);
    r0.w = dot(r5.xy, r5.xy) + (c7.x);
    r0.y = exp2(-(r0.y));
    r0.w = exp2(-(r0.w));
    r0.y = (r0.y) * (c7.z) + (c7.w);
    r0.w = (r0.w) * (c7.z) + (c7.w);
    r1.w = (r0.y) * (r0.w);
    r2 = tex2D(s14, v0.zw);
    r6.xy = (r2.xy) * (c3.ww);
    r0.y = dot(r4.xy, r5.xy) + (c7.x);
    r3.xy = (r3.xz) * (r6.yy);
    r1.w = saturate((r0.y) * (r1.w) + (r1.w));
    r0.y = (r2.y) * (c3.w) + (-(r3.x));
    r4.xz = (r3.xy) * (c4.xx);
    r0.y = (r3.z) * (-(r6.y)) + (r0.y);
    r4.y = (r0.y) + (r0.y);
    r0.xy = (r0.xz) * (r6.xx);
    r3.xyz = (r1.www) * (r4.xyz);
    r1.w = (r2.x) * (c3.w) + (-(r0.x));
    r4.xz = (r0.xy) * (c4.xx);
    r0.z = (r0.z) * (-(r6.x)) + (r1.w);
    r4.y = (r0.z) + (r0.z);
    r0.xy = c7.xy;
    r2.xyz = (r0.xyx) + (-(c[5].xyw));
    r0.xyz = (r4.xyz) * (r0.www) + (r3.xyz);
    r9.xyz = (r7.www) * (r2.xyz) + (c[5].xyw);
    r11.xyz = (r0.xyz) * (r9.yyy);
    r2 = tex2D(s12, v0.zw);
    r0 = v1;
    r0.xyz = (r5.xxx) * (v4.xyz) + (r0.xyz);
    r3.xyz = (r5.yyy) * (v3.xyz) + (r0.xyz);
    r1.w = dot(v5.xyz, v5.xyz);
    r0.xyz = normalize(r3.xyz);
    r4.w = rsqrt(r1.w);
    r2.w = saturate(dot(r0.xyz, c[17].xyz));
    r10.xyz = (r4.www) * (v5.xyz);
    r6.xyz = (r2.www) * (c[18].xyz);
    r1.w = saturate(dot(r0.xyz, -(r10.xyz)));
    r3 = tex2D(s3, v0.xy);
    r5.z = (r3.w) * (c1.y);
    r2.z = (r3.w) * (-(c1.y)) + (c1.z);
    r2.x = (r1.w) * (r2.z) + (r5.z);
    r2.z = (r2.w) * (r2.z) + (r5.z);
    r7.xyz = (v5.xyz) * (-(r4.www)) + (c[17].xyz);
    r2.z = (r2.z) * (r2.x) + (c4.z);
    r2.z = 1.0f / (r2.z);
    r5.xyz = normalize(r7.xyz);
    r2.x = (r2.w) * (r2.z);
    r4.w = saturate(dot(r0.xyz, r5.xyz));
    r2.z = saturate(dot(r5.xyz, c[17].xyz));
    r12.xy = (r3.ww) * (c8.xy) + (c8.zw);
    r2.w = exp2(r12.y);
    r2.z = (-(r2.z)) + (c7.y);
    r5.w = pow(abs(r4.w), r2.w);
    r4.w = (r2.z) * (r2.z);
    r2.w = (r2.w) * (c2.x) + (c2.y);
    r4.w = (r4.w) * (r4.w);
    r2.w = (r5.w) * (r2.w);
    r2.z = (r2.z) * (r4.w);
    r8.xyz = (r3.xyz) * (r3.xyz);
    r7.xyz = (r3.xyz) * (-(r3.xyz)) + (c7.yyy);
    r2.w = (r2.x) * (r2.w);
    r5.xyz = (r7.xyz) * (r2.zzz) + (r8.xyz);
    r3.xyz = (r2.yyy) * (r6.xyz) + (r11.xyz);
    r5.xyz = (r2.www) * (r5.xyz);
    r5.w = (-(r1.w)) + (c7.y);
    r5.xyz = (r9.zzz) * (r5.xyz);
    r4.w = 1.0f / (r12.x);
    r5.xyz = (r5.xyz) * (c[19].xyz);
    r1.w = (r3.w) * (c1.x);
    r5.xyz = (r2.yyy) * (r5.xyz);
    r2 = tex2D(s0, v0.xy);
    r2.w = dot(r10.xyz, r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r6.xyz = lerp(r2.xyz, r1.xyz, r7.www);
    r1.xyz = (r0.xyz) * (-(r2.www)) + (r10.xyz);
    r1 = texCUBElod(s15, r1);
    r0.z = (r5.w) * (r5.w);
    r1.w = (r5.w) * (r0.z);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r4.w) * (r1.w);
    r0.xyz = (r9.xxx) * (r0.xyz);
    r2.xyz = (r7.xyz) * (r1.www) + (r8.xyz);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r5.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.xxx) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c7.y;

    return oC0;
}
