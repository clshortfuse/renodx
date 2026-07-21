// Mechanically reconstructed from 0xC69145D9.ps_3_0.cso.
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
    const float4 c1 = float4(1.0f, -1.0f, 0.200000003f, 0.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.0f);
    const float4 c6 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
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
    float4 r11 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s2, v6.zw);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s1, v6.zw);
    r9.w = (r0.w) * (v6.y);
    r1.w = dot(v5.xyz, v5.xyz);
    r9.xy = (r1.xy) * (r9.ww);
    r3.z = rsqrt(r1.w);
    r1.xyz = v1.xyz;
    r1.xyz = (r9.xxx) * (v4.xyz) + (r1.xyz);
    r6.xyz = (r3.zzz) * (v5.xyz);
    r2.xyz = (r9.yyy) * (v3.xyz) + (r1.xyz);
    r1 = tex2D(s3, v6.zw);
    r1.yz = (r1.wy) + (c1.yy);
    r5.xyz = normalize(r2.xyz);
    r10.xy = (r9.ww) * (r1.yz) + (c1.xx);
    r3.w = saturate(dot(r5.xyz, -(r6.xyz)));
    r1.y = (r10.x) * (c2.w);
    r1.w = (r10.x) * (-(c6.z)) + (c6.w);
    r2.w = saturate(dot(r5.xyz, c[17].xyz));
    r1.z = (r3.w) * (r1.w) + (r1.y);
    r1.w = (r2.w) * (r1.w) + (r1.y);
    r1.w = (r1.w) * (r1.z) + (c4.x);
    r1.w = 1.0f / (r1.w);
    r2.xyz = (v5.xyz) * (-(r3.zzz)) + (c[17].xyz);
    r3.z = (r2.w) * (r1.w);
    r1.xyz = normalize(r2.xyz);
    r2.xy = (r10.xx) * (c7.xy) + (c7.zw);
    r3.y = saturate(dot(r5.xyz, r1.xyz));
    r2.z = exp2(r2.y);
    r1.z = saturate(dot(r1.xyz, c[17].xyz));
    r1.y = pow(abs(r3.y), r2.z);
    r1.w = (r2.z) * (c4.y) + (c4.z);
    r1.z = (-(r1.z)) + (c1.x);
    r1.w = (r1.y) * (r1.w);
    r1.y = (r1.z) * (r1.z);
    r1.x = (r1.y) * (r1.y);
    r1.y = c1.z;
    r1.z = (r1.z) * (r1.x);
    r1.y = (r9.w) * (r1.y);
    r6.w = (r1.y) * (r1.y);
    r5.w = (r1.y) * (-(r1.y)) + (c1.x);
    r1.w = (r3.z) * (r1.w);
    r1.z = (r5.w) * (r1.z) + (r6.w);
    r8.w = (-(r3.w)) + (c1.x);
    r1.w = (r1.w) * (r1.z);
    r7.xyz = (r2.www) * (c[18].xyz);
    r1.w = (r10.y) * (r1.w);
    r7.w = 1.0f / (r2.x);
    r8.xyz = (r1.www) * (c[19].xyz);
    r1 = tex2D(s12, v0.zw);
    r2.xy = (v0.zw) * (c3.xy);
    r2 = tex2D(s13, r2.xy);
    r3.xy = (v0.zw) * (c3.xy) + (c3.zy);
    r4 = tex2D(s13, r3.xy);
    r2.w = r4.y;
    r3.xy = (r2.yw) * (c6.xx) + (c6.yy);
    r1.z = dot(r3.xy, r3.xy) + (c1.w);
    r1.w = dot(r9.xy, r9.xy) + (c1.w);
    r1.z = exp2(-(r1.z));
    r1.w = exp2(-(r1.w));
    r1.x = (r1.z) * (c2.x) + (c2.y);
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r1.z = dot(r3.xy, r9.xy) + (c1.w);
    r1.x = (r1.x) * (r1.w);
    r3 = tex2D(s14, v0.zw);
    r11.xy = (r3.xy) * (c3.ww);
    r1.x = saturate((r1.z) * (r1.x) + (r1.x));
    r4.xy = (r4.xz) * (r11.yy);
    r1.z = (r3.y) * (c3.w) + (-(r4.x));
    r9.xz = (r4.xy) * (c6.xx);
    r1.z = (r4.z) * (-(r11.y)) + (r1.z);
    r2.xy = (r2.xz) * (r11.xx);
    r9.y = (r1.z) + (r1.z);
    r1.z = (r3.x) * (c3.w) + (-(r2.x));
    r3.xyz = (r1.xxx) * (r9.xyz);
    r1.z = (r2.z) * (-(r11.x)) + (r1.z);
    r2.xz = (r2.xy) * (c6.xx);
    r2.y = (r1.z) + (r1.z);
    r3.xyz = (r2.xyz) * (r1.www) + (r3.xyz);
    r3.xyz = (r10.yyy) * (r3.xyz);
    r4.xyz = (r8.xyz) * (r1.yyy);
    r3.xyz = (r1.yyy) * (r7.xyz) + (r3.xyz);
    r1 = tex2D(s0, v0.xy);
    r7.xyz = lerp(r1.xyz, r0.xyz, r9.www);
    r1.w = (r1.w) * (-(v6.x)) + (c1.x);
    r2.w = (r0.w) * (-(v6.y)) + (c1.x);
    r0.w = dot(r6.xyz, r5.xyz);
    r1.xyz = (r7.xyz) * (r7.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r5.xyz) * (-(r0.www)) + (r6.xyz);
    r0.w = (r10.x) * (c2.z);
    r0 = texCUBElod(s15, r0);
    r0.w = (r8.w) * (r8.w);
    r0.w = (r8.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r7.w) * (r0.w);
    r0.xyz = (r10.yyy) * (r0.xyz);
    r0.w = (r5.w) * (r0.w) + (r6.w);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.w = (r1.w) * (-(r2.w)) + (c1.x);
    r0.xyz = (r0.xyz) * (c2.zzz) + (r1.xyz);
    r1.xyz = (r0.www) * (v2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
