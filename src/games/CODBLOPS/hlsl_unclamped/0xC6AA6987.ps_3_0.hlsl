// Mechanically reconstructed from 0xC6AA6987.ps_3_0.cso.
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
    float4 r14 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = tex2D(s1, v1.xy);
    r0 = tex2D(s0, v1.xy);
    r2.w = (r0.w) * (v0.w) + (c0.x);
    r1 = float4(((r2.w) >= 0.0f ? (r1.x) : (c0.z)), ((r2.w) >= 0.0f ? (r1.y) : (c0.z)), ((r2.w) >= 0.0f ? (r1.z) : (c0.z)), ((r2.w) >= 0.0f ? (r1.w) : (c0.y)));
    r2.y = (r1.w) * (c3.x);
    r2.z = dot(v4.xyz, v4.xyz);
    r0.w = (r1.w) * (-(c3.x)) + (c3.y);
    r3.w = rsqrt(r2.z);
    r12.xyz = (r3.www) * (v4.xyz);
    r9.xyz = normalize(v2.xyz);
    r2.x = saturate(dot(r9.xyz, -(r12.xyz)));
    r2.z = saturate(dot(r9.xyz, c[17].xyz));
    r3.z = (r2.x) * (r0.w) + (r2.y);
    r2.y = (r2.z) * (r0.w) + (r2.y);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r2.y = (r2.y) * (r3.z) + (c1.w);
    r3.xyz = (v4.xyz) * (-(r3.www)) + (c[17].xyz);
    r2.y = 1.0f / (r2.y);
    r7.w = (-(r2.x)) + (c0.y);
    r3.w = (r2.z) * (r2.y);
    r6.xyz = (r2.zzz) * (c[18].xyz);
    r2.xyz = normalize(r3.xyz);
    r4.w = saturate(dot(r9.xyz, r2.xyz));
    r3.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r2.y = saturate(dot(r2.xyz, c[17].xyz));
    r2.z = exp2(r3.y);
    r6.w = 1.0f / (r3.x);
    r2.y = (-(r2.y)) + (c0.y);
    r3.z = pow(abs(r4.w), r2.z);
    r2.x = (r2.y) * (r2.y);
    r2.z = (r2.z) * (c2.z) + (c2.w);
    r2.x = (r2.x) * (r2.x);
    r2.z = (r3.z) * (r2.z);
    r2.y = (r2.y) * (r2.x);
    r11.xyz = (r1.xyz) * (r1.xyz);
    r10.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r2.z = (r3.w) * (r2.z);
    r1.xyz = (r10.xyz) * (r2.yyy) + (r11.xyz);
    r1.xyz = (r2.zzz) * (r1.xyz);
    r14.yz = c0.yz;
    r7.xyz = float3(((r2.w) >= 0.0f ? (c[20].x) : (r14.z)), ((r2.w) >= 0.0f ? (c[20].y) : (r14.z)), ((r2.w) >= 0.0f ? (c[20].w) : (r14.z)));
    r1.w = (r1.w) * (c0.w);
    r1.xyz = (r1.xyz) * (r7.zzz);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c0.z)), ((r2.w) >= 0.0f ? (r0.y) : (c0.z)), ((r2.w) >= 0.0f ? (r0.z) : (c0.z)), ((r2.w) >= 0.0f ? (r0.w) : (c0.z)));
    r13.xyz = (r1.xyz) * (c[19].xyz);
    r2 = tex2D(s12, v1.zw);
    r1.xy = (v1.zw) * (c3.yz);
    r3 = tex2D(s13, r1.xy);
    r1.xy = (v1.zw) * (c3.yz) + (c3.wz);
    r5 = tex2D(s13, r1.xy);
    r3.w = r5.y;
    r1.xy = (r3.yw) * (c1.yy) + (c1.zz);
    r1.z = dot(r1.xy, r1.xy) + (c0.z);
    r4 = tex2D(s14, v1.zw);
    r8.xy = (r4.xy) * (c1.xx);
    r1.z = exp2(-(r1.z));
    r1.xy = (r5.xz) * (r8.yy);
    r2.w = saturate((r1.z) * (c2.x) + (c2.y));
    r2.z = (r4.y) * (c1.x) + (-(r1.x));
    r1.xz = (r1.xy) * (c1.yy);
    r3.xy = (r3.xz) * (r8.xx);
    r1.y = (r5.z) * (-(r8.y)) + (r2.z);
    r2.z = (r4.x) * (c1.x) + (-(r3.x));
    r1.y = (r1.y) + (r1.y);
    r2.z = (r3.z) * (-(r8.x)) + (r2.z);
    r8.xz = (r3.xy) * (c1.yy);
    r8.y = (r2.z) + (r2.z);
    r1.xyz = (r1.xyz) * (r2.www) + (r8.xyz);
    r1.xyz = (r7.yyy) * (r1.xyz);
    r3.xyz = (r13.xyz) * (r2.yyy);
    r1.xyz = (r2.yyy) * (r6.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.w = dot(r12.xyz, r9.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r6.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r1.xyz = (r9.xyz) * (-(r2.www)) + (r12.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r7.xxx) * (r1.xyz);
    r1.w = (r7.w) * (r7.w);
    r5.w = (r7.w) * (r1.w);
    r4 = (-(v4.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[7]);
    r5.w = (r6.w) * (r5.w);
    r1 = (r2) * (r2) + (r1);
    r10.xyz = (r10.xyz) * (r5.www) + (r11.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r7.xyz = (r7.xyz) * (r10.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r1 = saturate((r1) * (c[8]) + (r14.yyyy));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.xyz = (r8.xyz) * (r7.xyz);
    r1 = (r1) * (r2);
    r3.xyz = (r3.xyz) * (c0.www) + (r6.xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
