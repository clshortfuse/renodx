// Mechanically reconstructed from 0x93358BBC.ps_3_0.cso.
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
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, -0.0f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v4.xyz, v4.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = (r0.www) * (v4.xyz);
    r10.xyz = normalize(v2.xyz);
    r3.xyz = (v4.xyz) * (-(r0.www)) + (c[17].xyz);
    r2.y = saturate(dot(r10.xyz, -(r1.xyz)));
    r0 = tex2D(s1, v1.xy);
    r2.x = (r0.w) * (c0.z);
    r1.w = (r0.w) * (-(c0.z)) + (c0.y);
    r2.w = saturate(dot(r10.xyz, c[17].xyz));
    r2.z = (r2.y) * (r1.w) + (r2.x);
    r1.w = (r2.w) * (r1.w) + (r2.x);
    r6.w = (-(r2.y)) + (c0.y);
    r1.w = (r1.w) * (r2.z) + (c3.x);
    r1.w = 1.0f / (r1.w);
    r2.xyz = normalize(r3.xyz);
    r3.w = (r2.w) * (r1.w);
    r4.w = saturate(dot(r10.xyz, r2.xyz));
    r2.z = saturate(dot(r2.xyz, c[17].xyz));
    r2.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r1.w = exp2(r2.y);
    r2.z = (-(r2.z)) + (c0.y);
    r3.z = pow(abs(r4.w), r1.w);
    r2.y = (r2.z) * (r2.z);
    r1.w = (r1.w) * (c3.y) + (c3.z);
    r2.y = (r2.y) * (r2.y);
    r1.w = (r3.z) * (r1.w);
    r2.z = (r2.z) * (r2.y);
    r11.xyz = (r0.xyz) * (r0.xyz);
    r5.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r1.w = (r3.w) * (r1.w);
    r0.xyz = (r5.xyz) * (r2.zzz) + (r11.xyz);
    r6.xyz = (r2.www) * (c[18].xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r5.w = 1.0f / (r2.x);
    r0.xyz = (r0.xyz) * (c[20].www);
    r1.w = (r0.w) * (c0.x);
    r7.xyz = (r0.xyz) * (c[19].xyz);
    r0 = tex2D(s12, v1.zw);
    r2.xy = (v1.zw) * (c0.yw);
    r2 = tex2D(s13, r2.xy);
    r3.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r4 = tex2D(s13, r3.xy);
    r2.w = r4.y;
    r3.xy = (r2.yw) * (c2.xx) + (c2.yy);
    r0.w = dot(r3.xy, r3.xy) + (c1.z);
    r3 = tex2D(s14, v1.zw);
    r9.xy = (r3.xy) * (c1.ww);
    r0.w = exp2(-(r0.w));
    r4.xy = (r4.xz) * (r9.yy);
    r0.w = saturate((r0.w) * (c2.z) + (c2.w));
    r0.z = (r3.y) * (c1.w) + (-(r4.x));
    r8.xz = (r4.xy) * (c2.xx);
    r2.xy = (r2.xz) * (r9.xx);
    r0.x = (r4.z) * (-(r9.y)) + (r0.z);
    r0.z = (r3.x) * (c1.w) + (-(r2.x));
    r8.y = (r0.x) + (r0.x);
    r0.z = (r2.z) * (-(r9.x)) + (r0.z);
    r9.xz = (r2.xy) * (c2.xx);
    r9.y = (r0.z) + (r0.z);
    r2.xyz = (r8.xyz) * (r0.www) + (r9.xyz);
    r2.xyz = (r2.xyz) * (c[20].yyy);
    r3.xyz = (r7.xyz) * (r0.yyy);
    r2.xyz = (r0.yyy) * (r6.xyz) + (r2.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.w = dot(r1.xyz, r10.xyz);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r0.w = (r2.w) + (r2.w);
    r7.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r10.xyz) * (-(r0.www)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r8.xyz = (r1.xyz) * (c[20].xxx);
    r0.w = (r6.w) * (r6.w);
    r0.w = (r6.w) * (r0.w);
    r4 = (-(v4.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[7]);
    r0.w = (r5.w) * (r0.w);
    r1 = (r2) * (r2) + (r1);
    r11.xyz = (r5.xyz) * (r0.www) + (r11.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r8.xyz = (r8.xyz) * (r11.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r0.z = c0.y;
    r1 = saturate((r1) * (c[8]) + (r0.zzzz));
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r3.xyz = (r9.xyz) * (r8.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r3.xyz) * (c0.xxx) + (r7.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
