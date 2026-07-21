// Mechanically reconstructed from 0xDD23A38E.ps_3_0.cso.
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
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0f);
    const float4 c2 = float4(0.600000024f, 0.400000006f, 0.0f, 0.0f);
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

    r1 = (v4.xyzx) * (c0.yyyz) + (c0.zzzy);
    r0.w = dot(r1, c[29]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[26]);
    r0.y = dot(r1, c[27]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[30].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[31].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[31].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[28]);
    r0.z = (r2.x) * (c[32].x);
    r0.y = (r2.y) * (c[32].y) + (-(r0.z));
    r0.z = c[32].y;
    r0.z = (r2.y) * (r0.z) + (-(c[31].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[24];
    r1 = saturate((r2.zyxz) * (r1) + (c[25]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[32].zzzz) * (r3) + (c[32].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[31].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[23].yz, r2.zw) + (c[23].x);
    r0.z = (r0.y) * (r0.z);
    r2.w = (r1.x) * (r0.z);
    r1 = c[33];
    r1.x = dot(r0.xw, r1.xy) + (c[22].x);
    r1.y = dot(r0.xw, r1.zw) + (c[22].z);
    r0 = tex2D(s1, r1.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r2.www) * (r0.xyz);
    r1 = tex2D(s12, v1.zw);
    r0.xy = (v1.zw) * (c0.yw);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c0.yw) + (c0.zw);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r4.xy = (r2.yw) * (c1.yy) + (c1.zz);
    r6.xyz = (r3.xyz) * (r1.yyy);
    r0.w = dot(r4.xy, r4.xy) + (c0.z);
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c1.xx);
    r0.w = exp2(-(r0.w));
    r2.xy = (r2.xz) * (r4.xx);
    r2.w = saturate((r0.w) * (c2.x) + (c2.y));
    r0.w = (r1.x) * (c1.x) + (-(r2.x));
    r3.xz = (r2.xy) * (c1.yy);
    r0.xy = (r0.xz) * (r4.yy);
    r1.w = (r2.z) * (-(r4.x)) + (r0.w);
    r0.w = (r1.y) * (c1.x) + (-(r0.x));
    r3.y = (r1.w) + (r1.w);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r1.xz = (r0.xy) * (c1.yy);
    r1.y = (r0.w) + (r0.w);
    r0 = tex2D(s0, v1.xy);
    r1.w = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r1.xyz = (r1.xyz) * (r2.www) + (r3.xyz);
    r0 = float4(((r1.w) >= 0.0f ? (r0.x) : (c0.z)), ((r1.w) >= 0.0f ? (r0.y) : (c0.z)), ((r1.w) >= 0.0f ? (r0.z) : (c0.z)), ((r1.w) >= 0.0f ? (r0.w) : (c0.z)));
    r7.xyz = (r1.xyz) * (r0.www);
    r4 = (-(v4.yyyy)) + (c[6]);
    r1 = (r4) * (r4);
    r3 = (-(v4.xxxx)) + (c[5]);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[7]);
    r5.xyz = (-(v4.xyz)) + (c[20].xyz);
    r1 = (r2) * (r2) + (r1);
    r8.xyz = normalize(r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r9.xyz = normalize(v2.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r4.z = c0.y;
    r1 = saturate((r1) * (c[8]) + (r4.zzzz));
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.w = saturate(dot(r8.xyz, r9.xyz));
    r1 = (r1) * (r2);
    r3.xyz = (r3.www) * (c[21].xyz);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r6.xyz) * (r3.xyz) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[34].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
