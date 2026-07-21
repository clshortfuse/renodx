// Mechanically reconstructed from 0x819CBE51.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, -0.0f, 0.5f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 31.875f, 4.0f);
    const float4 c3 = float4(4.0f, -2.0f, 2.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.yw);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.yw) + (c1.zw);
    r3 = tex2D(s13, r0.xy);
    r1.w = r3.y;
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2.z = c1.y;
    r0 = tex2D(s0, v1.xy);
    r3.w = (r0.w) * (v0.w) + (c1.x);
    r4.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r7.xyz = float3(((r3.w) >= 0.0f ? (r2.x) : (c1.z)), ((r3.w) >= 0.0f ? (r2.y) : (c1.z)), ((r3.w) >= 0.0f ? (r2.z) : (c1.z)));
    r0.w = dot(r4.xy, r4.xy) + (c1.z);
    r1.w = dot(r7.xy, r7.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r1.w = exp2(-(r1.w));
    r0.w = (r0.w) * (c2.x) + (c2.y);
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r1.y = (r0.w) * (r1.w);
    r0.w = dot(r4.xy, r7.xy) + (c1.z);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c2.zz);
    r2.w = saturate((r0.w) * (r1.y) + (r1.y));
    r3.xy = (r3.xz) * (r5.yy);
    r0.w = (r2.y) * (c2.z) + (-(r3.x));
    r4.xz = (r3.xy) * (c2.ww);
    r0.w = (r3.z) * (-(r5.y)) + (r0.w);
    r1.xy = (r1.xz) * (r5.xx);
    r4.y = (r0.w) + (r0.w);
    r0.w = (r2.x) * (c2.z) + (-(r1.x));
    r2.xyz = (r2.www) * (r4.xyz);
    r0.w = (r1.z) * (-(r5.x)) + (r0.w);
    r1.xz = (r1.ww) * (r1.xy);
    r1.y = (r1.w) * (r0.w);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.xyz = (r1.xyz) * (c3.xzx) + (r2.xyz);
    r0 = float4(((r3.w) >= 0.0f ? (r0.x) : (c1.z)), ((r3.w) >= 0.0f ? (r0.y) : (c1.z)), ((r3.w) >= 0.0f ? (r0.z) : (c1.z)), ((r3.w) >= 0.0f ? (r0.w) : (c1.z)));
    r8.xyz = (r7.zzz) * (r1.xyz);
    r2 = tex2D(s12, v1.zw);
    r6 = (-(v6.yyyy)) + (c[6]);
    r1 = (r6) * (r6);
    r5 = (-(v6.xxxx)) + (c[5]);
    r3 = (r5) * (r5) + (r1);
    r4 = (-(v6.zzzz)) + (c[7]);
    r1 = v2;
    r1.xyz = (r7.xxx) * (v5.xyz) + (r1.xyz);
    r3 = (r4) * (r4) + (r3);
    r9.xyz = (r7.yyy) * (v4.xyz) + (r1.xyz);
    r7.x = rsqrt(r3.x);
    r7.y = rsqrt(r3.y);
    r7.z = rsqrt(r3.z);
    r7.w = rsqrt(r3.w);
    r1.xyz = normalize(r9.xyz);
    r6 = (r6) * (r7);
    r6 = (r1.yyyy) * (r6);
    r5 = (r5) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r1.xxxx) + (r6);
    r2.z = c1.y;
    r3 = saturate((r3) * (c[8]) + (r2.zzzz));
    r4 = saturate((r4) * (r1.zzzz) + (r5));
    r1.z = saturate(dot(c[17].xyz, r1.xyz));
    r3 = (r3) * (r4);
    r1.xyz = (r1.zzz) * (c[18].xyz);
    r4.x = dot(c[9], r3);
    r4.y = dot(c[10], r3);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r4.z = dot(c[11], r3);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r2.yyy) * (r1.xyz) + (r8.xyz);
    r2.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
