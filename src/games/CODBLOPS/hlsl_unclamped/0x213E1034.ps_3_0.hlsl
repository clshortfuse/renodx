// Mechanically reconstructed from 0x213E1034.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.5f);
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
    float4 oC0 = 0.0f;

    r3 = tex2D(s0, v1.xy);
    r0 = (v6.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.w = dot(r0, c[22]);
    r1.w = 1.0f / (r1.w);
    r1.x = dot(r0, c[11]);
    r1.y = dot(r0, c[20]);
    r1 = (r1.wwww) * (r1.xxyy);
    r2 = (r1) * (c[23].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[24].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[24].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r4.z = dot(r0, c[21]);
    r0.w = (r2.x) * (c[25].x);
    r0.z = (r2.y) * (c[25].y) + (-(r0.w));
    r0.y = c[25].y;
    r0.w = (r2.y) * (r0.y) + (-(c[24].z));
    r0.z = 1.0f / (r0.z);
    r4.xy = abs(r1.xw);
    r2.w = saturate((r0.w) * (r0.z));
    r0 = c[9];
    r0 = saturate((r4.zyxz) * (r0) + (c[10]));
    r2.x = (r0.w) * (r0.x);
    r2.yz = r0.yz;
    r0 = (r2) * (r2);
    r2 = (c[25].zzzz) * (r2) + (c[25].wwww);
    r2 = (r0) * (r2);
    r0 = (r3.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1.y = (r2.z) * (r2.y);
    r1.z = abs(c[24].w);
    r4.w = (r4.z) * (r4.z);
    r1.y = ((-(r1.z)) >= 0.0f ? (r1.y) : (r2.w));
    r1.z = dot(c[8].yz, r4.zw) + (c[8].x);
    r5.w = (r3.w) * (v0.w) + (c1.x);
    r1.z = (r1.y) * (r1.z);
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (c1.z)), ((r5.w) >= 0.0f ? (r0.y) : (c1.z)), ((r5.w) >= 0.0f ? (r0.z) : (c1.z)), ((r5.w) >= 0.0f ? (r0.w) : (c1.z)));
    r3.w = (r2.x) * (r1.z);
    r2 = c[26];
    r2.x = dot(r1.xw, r2.xy) + (c[7].x);
    r2.y = dot(r1.xw, r2.zw) + (c[7].z);
    r1 = tex2D(s2, r2.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r6.xyz = (r3.www) * (r1.xyz);
    r2 = tex2D(s12, v1.zw);
    r1.xy = (v1.zw) * (c1.yw);
    r1 = tex2D(s13, r1.xy);
    r3.xy = (v1.zw) * (c1.yw) + (c1.zw);
    r3 = tex2D(s13, r3.xy);
    r1.w = r3.y;
    r4 = tex2D(s1, v1.xy);
    r4.xy = (r4.wy) * (c0.xy) + (c0.zw);
    r4.z = c1.y;
    r7.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r5.xyz = float3(((r5.w) >= 0.0f ? (r4.x) : (c1.z)), ((r5.w) >= 0.0f ? (r4.y) : (c1.z)), ((r5.w) >= 0.0f ? (r4.z) : (c1.z)));
    r1.w = dot(r7.xy, r7.xy) + (c1.z);
    r1.y = dot(r5.xy, r5.xy) + (c1.z);
    r1.w = exp2(-(r1.w));
    r1.y = exp2(-(r1.y));
    r1.w = (r1.w) * (c2.x) + (c2.y);
    r3.w = (r1.y) * (c2.x) + (c2.y);
    r4.xyz = (r6.xyz) * (r2.yyy);
    r1.y = (r1.w) * (r3.w);
    r2 = tex2D(s14, v1.zw);
    r8.xy = (r2.xy) * (c2.zz);
    r1.w = dot(r7.xy, r5.xy) + (c1.z);
    r3.xy = (r3.xz) * (r8.yy);
    r1.w = saturate((r1.w) * (r1.y) + (r1.y));
    r1.y = (r2.y) * (c2.z) + (-(r3.x));
    r6.xz = (r3.xy) * (c2.ww);
    r1.y = (r3.z) * (-(r8.y)) + (r1.y);
    r6.y = (r1.y) + (r1.y);
    r1.xy = (r1.xz) * (r8.xx);
    r7.xyz = (r1.www) * (r6.xyz);
    r1.w = (r2.x) * (c2.z) + (-(r1.x));
    r6.xz = (r3.ww) * (r1.xy);
    r1.w = (r1.z) * (-(r8.x)) + (r1.w);
    r6.y = (r3.w) * (r1.w);
    r1 = v2;
    r1.xyz = (r5.xxx) * (v5.xyz) + (r1.xyz);
    r2.xyz = (r5.yyy) * (v4.xyz) + (r1.xyz);
    r1.xyz = (-(v6.xyz)) + (c[5].xyz);
    r3.xyz = normalize(r2.xyz);
    r2.xyz = normalize(r1.xyz);
    r1.xyz = (r6.xyz) * (c3.xzx) + (r7.xyz);
    r2.w = saturate(dot(r2.xyz, r3.xyz));
    r2.xyz = (r5.zzz) * (r1.xyz);
    r1.xyz = (r2.www) * (c[6].xyz);
    r1.xyz = (r4.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (c[27].w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
