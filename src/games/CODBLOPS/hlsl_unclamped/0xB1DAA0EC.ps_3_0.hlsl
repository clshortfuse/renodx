// Mechanically reconstructed from 0xB1DAA0EC.ps_3_0.cso.
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
    const float4 c0 = float4(-1.0f, 1.0f, 8.0f, 0.797884583f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c2 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
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

    r1.xyz = (-(v3.xyz)) + (c[5].xyz);
    r5.y = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r5.y);
    r2.xyz = (r1.xyz) * (r1.www);
    r9.xyz = normalize(v1.xyz);
    r2.w = saturate(dot(r9.xyz, r2.xyz));
    r0 = tex2D(s2, v0.xy);
    r3.x = (r0.w) * (c0.w);
    r10.xyz = normalize(v3.xyz);
    r3.y = (r0.w) * (-(c0.w)) + (c0.y);
    r3.z = saturate(dot(r9.xyz, -(r10.xyz)));
    r3.w = (r2.w) * (r3.y) + (r3.x);
    r3.y = (r3.z) * (r3.y) + (r3.x);
    r3.w = (r3.w) * (r3.y) + (c3.x);
    r3.w = 1.0f / (r3.w);
    r6.w = (-(r3.z)) + (c0.y);
    r3.w = (r2.w) * (r3.w);
    r6.xyz = (r2.www) * (c[6].xyz);
    r3.xyz = (r1.xyz) * (r1.www) + (-(r10.xyz));
    r5.x = 1.0f / (r1.w);
    r1.xyz = normalize(r3.xyz);
    r3.z = saturate(dot(r9.xyz, r1.xyz));
    r3.xy = (r0.ww) * (c4.xy) + (c4.zw);
    r1.y = saturate(dot(r1.xyz, r2.xyz));
    r2.w = exp2(r3.y);
    r5.w = 1.0f / (r3.x);
    r1.z = pow(abs(r3.z), r2.w);
    r1.w = (r2.w) * (c3.y) + (c3.z);
    r2.z = (-(r1.y)) + (c0.y);
    r2.w = (r1.z) * (r1.w);
    r2.y = (r2.z) * (r2.z);
    r1 = tex2D(s1, v4.zw);
    r1.xyz = (r1.xyz) + (c0.xxx);
    r1.w = (r2.y) * (r2.y);
    r4.xyz = (v4.yyy) * (r1.xyz) + (c0.yyy);
    r1.z = (r2.z) * (r1.w);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r7.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r1.w = (r3.w) * (r2.w);
    r0.xyz = (r7.xyz) * (r1.zzz) + (r8.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r2.xy = saturate((r5.xx) * (c[9].xy) + (c[9].zw));
    r1.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c12.xx) + (c12.yy);
    r1.w = dot(c[8].yz, r5.xy) + (c[8].x);
    r1.xy = (r1.xy) * (r2.xy);
    r0.xyz = (r0.xyz) * (c[10].www);
    r1.w = (r1.w) * (r1.x);
    r0.xyz = (r0.xyz) * (c[7].xyz);
    r2.w = (r1.y) * (r1.w);
    r1 = tex2D(s12, v0.zw);
    r4.w = (r2.w) * (r1.y);
    r0.w = (r0.w) * (c0.z);
    r5.xyz = (r0.xyz) * (r4.www);
    r2 = tex2D(s0, v0.xy);
    r0.xy = (v0.zw) * (c1.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r3 = tex2D(s13, r0.xy);
    r1.w = r3.y;
    r11.xy = (r1.yw) * (c2.xx) + (c2.yy);
    r0.xyz = (r4.xyz) * (r2.xyz);
    r1.w = dot(r11.xy, r11.xy) + (c1.z);
    r4.xyz = (r0.xyz) * (r0.xyz);
    r0.z = exp2(-(r1.w));
    r2 = tex2D(s14, v0.zw);
    r11.xy = (r2.xy) * (c1.ww);
    r2.w = saturate((r0.z) * (c2.z) + (c2.w));
    r0.xy = (r3.xz) * (r11.yy);
    r1.w = (r2.y) * (c1.w) + (-(r0.x));
    r0.xz = (r0.xy) * (c2.xx);
    r0.y = (r3.z) * (-(r11.y)) + (r1.w);
    r1.xy = (r1.xz) * (r11.xx);
    r0.y = (r0.y) + (r0.y);
    r1.w = (r2.x) * (c1.w) + (-(r1.x));
    r2.xz = (r1.xy) * (c2.xx);
    r1.w = (r1.z) * (-(r11.x)) + (r1.w);
    r2.y = (r1.w) + (r1.w);
    r1.w = dot(r10.xyz, r9.xyz);
    r0.xyz = (r0.xyz) * (r2.www) + (r2.xyz);
    r1.w = (r1.w) + (r1.w);
    r1.xyz = (r0.xyz) * (c[10].yyy);
    r0.xyz = (r9.xyz) * (-(r1.www)) + (r10.xyz);
    r0 = texCUBElod(s15, r0);
    r0.w = (r6.w) * (r6.w);
    r0.w = (r6.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r5.w) * (r0.w);
    r0.xyz = (r0.xyz) * (c[10].xxx);
    r3.xyz = (r7.xyz) * (r0.www) + (r8.xyz);
    r1.xyz = (r4.www) * (r6.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r4.xyz) * (r1.xyz) + (r5.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.zzz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
