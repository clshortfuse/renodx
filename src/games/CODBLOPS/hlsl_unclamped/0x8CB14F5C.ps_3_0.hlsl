// Mechanically reconstructed from 0x8CB14F5C.ps_3_0.cso.
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
sampler2D s4 : register(s4);
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
    const float4 c0 = float4(-1.0f, 1.0f, 0.0f, 0.200000003f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c7 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v7.xy);
    r0.xyz = (r0.xyz) + (c0.xxx);
    r3.xyz = (v0.yyy) * (r0.xyz) + (c0.yyy);
    r2 = tex2D(s0, v1.xy);
    r0 = tex2D(s2, v7.zw);
    r4.w = (r0.w) * (v0.z);
    r1 = tex2D(s3, v7.zw);
    r1.xy = (r1.wy) * (c1.xy) + (c1.zw);
    r0.xyz = (r2.xyz) * (-(r3.xyz)) + (r0.xyz);
    r9.xy = (r4.ww) * (r1.xy);
    r4.xyz = (r4.www) * (r0.xyz);
    r0 = v2;
    r0.xyz = (r9.xxx) * (v5.xyz) + (r0.xyz);
    r1.xyz = (r9.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = dot(v6.xyz, v6.xyz);
    r0.xyz = normalize(r1.xyz);
    r3.w = rsqrt(r1.w);
    r1 = tex2D(s4, v7.zw);
    r1.yzw = (r1.wyy) + (c0.xzx);
    r8.xyz = (r3.www) * (v6.xyz);
    r11.xy = (r4.ww) * (r1.yw) + (c0.yy);
    r2.w = saturate(dot(r0.xyz, -(r8.xyz)));
    r5.z = (r11.x) * (c2.w);
    r1.w = (r11.x) * (-(c4.z)) + (c4.w);
    r1.y = saturate(dot(r0.xyz, c[17].xyz));
    r1.x = (r2.w) * (r1.w) + (r5.z);
    r1.w = (r1.y) * (r1.w) + (r5.z);
    r2.xyz = (r2.xyz) * (r3.xyz) + (r4.xyz);
    r1.w = (r1.w) * (r1.x) + (c7.x);
    r5.xyz = (r2.xyz) * (r2.xyz);
    r1.w = 1.0f / (r1.w);
    r3.xyz = (v6.xyz) * (-(r3.www)) + (c[17].xyz);
    r3.w = (r1.y) * (r1.w);
    r2.xyz = normalize(r3.xyz);
    r3.xy = (r11.xx) * (c8.xy) + (c8.zw);
    r4.z = saturate(dot(r0.xyz, r2.xyz));
    r3.z = exp2(r3.y);
    r2.z = saturate(dot(r2.xyz, c[17].xyz));
    r1.x = pow(abs(r4.z), r3.z);
    r1.w = (r3.z) * (c7.y) + (c7.z);
    r2.z = (-(r2.z)) + (c0.y);
    r1.w = (r1.x) * (r1.w);
    r1.x = (r2.z) * (r2.z);
    r2.y = (r1.x) * (r1.x);
    r1.x = c0.w;
    r2.z = (r2.z) * (r2.y);
    r10.xz = (r4.ww) * (r1.xz);
    r6.w = (r10.x) * (r10.x);
    r5.w = (r10.x) * (-(r10.x)) + (c0.y);
    r1.w = (r3.w) * (r1.w);
    r1.z = (r5.w) * (r2.z) + (r6.w);
    r8.w = (-(r2.w)) + (c0.y);
    r1.w = (r1.w) * (r1.z);
    r7.xyz = (r1.yyy) * (c[18].xyz);
    r1.w = (r10.z) * (r1.w);
    r7.w = 1.0f / (r3.x);
    r3.xyz = (r1.www) * (c[19].xyz);
    r1 = tex2D(s12, v1.zw);
    r2.xy = (v1.zw) * (c3.xy);
    r2 = tex2D(s13, r2.xy);
    r4.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r4 = tex2D(s13, r4.xy);
    r2.w = r4.y;
    r6.xyz = (r3.xyz) * (r1.yyy);
    r3.xy = (r2.yw) * (c4.xx) + (c4.yy);
    r1.w = dot(r9.xy, r9.xy) + (c0.z);
    r1.z = dot(r3.xy, r3.xy) + (c0.z);
    r1.w = exp2(-(r1.w));
    r1.z = exp2(-(r1.z));
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r1.x = (r1.z) * (c2.x) + (c2.y);
    r1.z = dot(r3.xy, r9.xy) + (c0.z);
    r1.x = (r1.w) * (r1.x);
    r3 = tex2D(s14, v1.zw);
    r10.xy = (r3.xy) * (c3.ww);
    r1.x = saturate((r1.z) * (r1.x) + (r1.x));
    r4.xy = (r4.xz) * (r10.yy);
    r1.z = (r3.y) * (c3.w) + (-(r4.x));
    r9.xz = (r4.xy) * (c4.xx);
    r1.z = (r4.z) * (-(r10.y)) + (r1.z);
    r2.xy = (r2.xz) * (r10.xx);
    r9.y = (r1.z) + (r1.z);
    r1.z = (r3.x) * (c3.w) + (-(r2.x));
    r4.xyz = (r1.xxx) * (r9.xyz);
    r1.z = (r2.z) * (-(r10.x)) + (r1.z);
    r3.xz = (r2.xy) * (c4.xx);
    r3.y = (r1.z) + (r1.z);
    r2.xyz = (r3.xyz) * (r1.www) + (r4.xyz);
    r1.w = dot(r8.xyz, r0.xyz);
    r4.xyz = (r11.yyy) * (r2.xyz);
    r1.w = (r1.w) + (r1.w);
    r2.w = (r11.x) * (c2.z);
    r2.xyz = (r0.xyz) * (-(r1.www)) + (r8.xyz);
    r2 = texCUBElod(s15, r2);
    r0.z = (r8.w) * (r8.w);
    r1.w = (r8.w) * (r0.z);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r7.w) * (r1.w);
    r0.xyz = (r10.zzz) * (r0.xyz);
    r1.w = (r5.w) * (r1.w) + (r6.w);
    r1.xyz = (r1.yyy) * (r7.xyz) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r6.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c[5].w;

    return oC0;
}
