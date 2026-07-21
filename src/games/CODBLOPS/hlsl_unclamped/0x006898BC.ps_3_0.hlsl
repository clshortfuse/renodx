// Mechanically reconstructed from 0x006898BC.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-1.0f, 1.0f, 0.200000003f, 8.0f);
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

    r0 = tex2D(s0, v0.xy);
    r1 = tex2D(s1, v4.zw);
    r0.w = dot(v3.xyz, v3.xyz);
    r2.w = rsqrt(r0.w);
    r2.xyz = (r1.xyz) + (c0.xxx);
    r1.xyz = (v3.xyz) * (-(r2.www)) + (c[17].xyz);
    r3.xyz = (v4.yyy) * (r2.xyz) + (c0.yyy);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = (r0.xyz) * (r3.xyz);
    r0.w = saturate(dot(r2.xyz, c[17].xyz));
    r0.xyz = (r3.xyz) * (c0.zzz);
    r0.w = (-(r0.w)) + (c0.y);
    r5.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r0.w) * (r0.w);
    r12.xyz = (r2.www) * (v3.xyz);
    r1.w = (r1.w) * (r1.w);
    r3.w = (r0.w) * (r1.w);
    r11.xyz = normalize(v1.xyz);
    r10.xyz = (r0.xyz) * (r0.xyz);
    r2.w = saturate(dot(r11.xyz, -(r12.xyz)));
    r1 = tex2D(s2, v0.xy);
    r3.z = (r1.w) * (c3.x);
    r1.z = (r1.w) * (-(c3.x)) + (c3.y);
    r0.w = saturate(dot(r11.xyz, c[17].xyz));
    r1.x = (r2.w) * (r1.z) + (r3.z);
    r1.z = (r0.w) * (r1.z) + (r3.z);
    r9.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r0.z = (r1.z) * (r1.x) + (c1.w);
    r0.x = 1.0f / (r0.z);
    r3.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r1.x = saturate(dot(r11.xyz, r2.xyz));
    r1.z = exp2(r3.y);
    r0.y = pow(abs(r1.x), r1.z);
    r0.z = (r1.z) * (c2.z) + (c2.w);
    r1.x = (r0.w) * (r0.x);
    r1.z = (r0.y) * (r0.z);
    r0.xyz = (r9.xyz) * (r3.www) + (r10.xyz);
    r1.z = (r1.x) * (r1.z);
    r1.x = (-(r2.w)) + (c0.y);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r7.xyz = (r0.www) * (c[18].xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r1.z = 1.0f / (r3.x);
    r3.xyz = (r0.xyz) * (c[19].xyz);
    r0 = tex2D(s12, v0.zw);
    r2.xy = (v0.zw) * (c3.yz);
    r2 = tex2D(s13, r2.xy);
    r4.xy = (v0.zw) * (c3.yz) + (c3.wz);
    r4 = tex2D(s13, r4.xy);
    r2.w = r4.y;
    r8.xy = (r2.yw) * (c1.yy) + (c1.zz);
    r6.xyz = (r3.xyz) * (r0.yyy);
    r0.w = dot(r8.xy, r8.xy) + (c3.w);
    r3 = tex2D(s14, v0.zw);
    r13.xy = (r3.xy) * (c1.xx);
    r0.w = exp2(-(r0.w));
    r4.xy = (r4.xz) * (r13.yy);
    r0.w = saturate((r0.w) * (c2.x) + (c2.y));
    r0.z = (r3.y) * (c1.x) + (-(r4.x));
    r8.xz = (r4.xy) * (c1.yy);
    r2.xy = (r2.xz) * (r13.xx);
    r0.x = (r4.z) * (-(r13.y)) + (r0.z);
    r0.z = (r3.x) * (c1.x) + (-(r2.x));
    r8.y = (r0.x) + (r0.x);
    r0.z = (r2.z) * (-(r13.x)) + (r0.z);
    r3.xz = (r2.xy) * (c1.yy);
    r3.y = (r0.z) + (r0.z);
    r2.xyz = (r8.xyz) * (r0.www) + (r3.xyz);
    r0.w = dot(r12.xyz, r11.xyz);
    r8.xyz = (r1.yyy) * (r2.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r11.xyz) * (-(r0.www)) + (r12.xyz);
    r2.w = (r1.w) * (c0.w);
    r2 = texCUBElod(s15, r2);
    r0.w = (r1.x) * (r1.x);
    r0.w = (r1.x) * (r0.w);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.w = (r1.z) * (r0.w);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r4.xyz = (r9.xyz) * (r0.www) + (r10.xyz);
    r1.xyz = (r0.yyy) * (r7.xyz) + (r8.xyz);
    r0.xyz = (r2.xyz) * (r4.xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r6.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
