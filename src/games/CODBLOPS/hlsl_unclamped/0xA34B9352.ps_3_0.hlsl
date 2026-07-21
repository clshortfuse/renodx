// Mechanically reconstructed from 0xA34B9352.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c2 = float4(1.0f, -0.0f, 31.875f, 9.99999975e-05f);
    const float4 c3 = float4(0.100000001f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r1.xy = (v5.xy) * (c[29].xy);
    r0 = tex2D(s2, r1.xy);
    r2 = tex2D(s1, r1.xy);
    r3 = (v2.xyzx) * (c2.xxxy) + (c2.yyyx);
    r1.w = dot(r3, c[23]);
    r1.w = 1.0f / (r1.w);
    r1.x = dot(r3, c[20]);
    r1.y = dot(r3, c[21]);
    r1 = (r1.wwww) * (r1.xxyy);
    r4 = (r1) * (c[24].zwxy);
    r4.x = log2(abs(r4.x));
    r4.y = log2(abs(r4.y));
    r4.z = log2(abs(r4.z));
    r4.w = log2(abs(r4.w));
    r4 = (r4) * (c[25].xxxx);
    r4.x = exp2(r4.x);
    r4.y = exp2(r4.y);
    r4.z = exp2(r4.z);
    r4.w = exp2(r4.w);
    r4.xy = (r4.zw) + (r4.xy);
    r4.x = log2(abs(r4.x));
    r4.y = log2(abs(r4.y));
    r4.xy = (r4.xy) * (c[25].yy);
    r4.x = exp2(r4.x);
    r4.y = exp2(r4.y);
    r4.z = dot(r3, c[22]);
    r1.z = (r4.x) * (c[26].x);
    r1.y = (r4.y) * (c[26].y) + (-(r1.z));
    r1.z = c[26].y;
    r1.z = (r4.y) * (r1.z) + (-(c[25].z));
    r1.y = 1.0f / (r1.y);
    r4.xy = abs(r1.xw);
    r5.w = saturate((r1.z) * (r1.y));
    r3 = c[10];
    r3 = saturate((r4.zyxz) * (r3) + (c[11]));
    r5.x = (r3.w) * (r3.x);
    r5.yz = r3.yz;
    r3 = (r5) * (r5);
    r5 = (c[26].zzzz) * (r5) + (c[26].wwww);
    r3 = (r3) * (r5);
    r1.y = (r3.z) * (r3.y);
    r1.z = abs(c[25].w);
    r4.w = (r4.z) * (r4.z);
    r1.y = ((-(r1.z)) >= 0.0f ? (r1.y) : (r3.w));
    r1.z = dot(c[9].yz, r4.zw) + (c[9].x);
    r4.w = (r0.w) + (-(c2.x));
    r0.w = (r1.y) * (r1.z);
    r4.xyz = normalize(-(v2.xyz));
    r5.w = (r3.x) * (r0.w);
    r3 = c[27];
    r3.x = dot(r1.xw, r3.xy) + (c[8].x);
    r3.y = dot(r1.xw, r3.zw) + (c[8].z);
    r1 = tex2D(s0, r3.xy);
    r5.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2.xyz = v3.xyz;
    r3.xyz = (r2.zxy) * (v1.yzx);
    r5.xy = (r5.xy) * (c[30].xx);
    r2.xyz = (r2.yzx) * (v1.zxy) + (-(r3.xyz));
    r2.xyz = (r5.yyy) * (-(r2.xyz));
    r2.xyz = (r5.xxx) * (v1.xyz) + (r2.xyz);
    r2.xyz = (r2.xyz) + (v3.xyz);
    r5.xyz = normalize(r2.xyz);
    r1.w = max(abs(r5.y), abs(r5.z));
    r2.xyz = (r1.xyz) * (r1.xyz);
    r0.w = max(abs(r5.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r1.xyz = (r5.xyz) * (c[5].xyz);
    r2.xyz = (r5.www) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r0.www) + (v0.xyz);
    r1 = tex3D(s11, r1.xyz);
    r2.xyz = (r2.xyz) * (r1.www);
    r6.xyz = (-(v2.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r3.xyz = normalize(r6.xyz);
    r2.xyz = (r2.xyz) * (c[7].xyz);
    r5.w = saturate(dot(r5.xyz, r3.xyz));
    r3.w = saturate(dot(r5.xyz, r4.xyz));
    r0.w = dot(r3.xyz, r4.xyz);
    r1.w = (c[31].x) * (c[31].x);
    r2.w = c[31].x;
    r5.xy = (r2.ww) * (r2.ww) + (c1.zw);
    r3.xy = (r1.ww) * (c1.xy);
    r5.x = 1.0f / (r5.x);
    r5.y = 1.0f / (r5.y);
    r1.w = saturate((r5.w) * (-(r3.w)) + (r0.w));
    r2.w = (r3.y) * (r5.y);
    r0.w = (r3.x) * (-(r5.x)) + (c2.x);
    r5.z = (r1.w) * (r2.w);
    r5.y = 1.0f / (r3.w);
    r5.x = max(abs(r4.y), abs(r4.z));
    r3.xyz = (r1.xyz) * (r0.www);
    r1.w = max(abs(r4.x), r5.x);
    r1.xyz = (r4.xyz) * (c[5].xyz);
    r1.w = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (c2.zzz);
    r1.xyz = (r1.xyz) * (r1.www) + (v0.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = saturate((r5.w) * (r5.y));
    r1.xyz = (r3.xyz) * (r1.xyz);
    r1.w = (r5.z) * (r1.w);
    r1.xyz = (r1.xyz) * (c2.zzz);
    r0.w = (r0.w) * (r5.w) + (r1.w);
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r3.xyz = (r2.xyz) * (r0.www) + (r3.xyz);
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r1.z = 1.0f / (r1.z);
    r0.w = (r3.w) * (r3.w);
    r1.w = (r3.w) * (-(r3.w)) + (c2.x);
    r1.xyz = (r2.www) * (r1.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c2.x) : (r1.w));
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.www) + (r3.xyz);
    r1.xyz = normalize(v3.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz) + (-(v4.xyz));
    r0.w = dot(r4.xyz, r1.xyz);
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v4.xyz);
    r1.w = max(c2.w, r0.w);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = pow(abs(r1.w), c3.x);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r0.w) * (r4.w) + (c2.x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
