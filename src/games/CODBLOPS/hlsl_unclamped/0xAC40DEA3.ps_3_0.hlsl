// Mechanically reconstructed from 0xAC40DEA3.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(1.0f, 0.0f, 31.875f, 0.0f);
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

    r1 = (v4.xyzx) * (c0.xxxy) + (c0.yyyx);
    r0.w = dot(r1, c[30]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[27]);
    r0.y = dot(r1, c[28]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[31].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[32].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[32].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[29]);
    r0.z = (r2.x) * (c[33].x);
    r0.y = (r2.y) * (c[33].y) + (-(r0.z));
    r0.z = c[33].y;
    r0.z = (r2.y) * (r0.z) + (-(c[32].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[25];
    r1 = saturate((r2.zyxz) * (r1) + (c[26]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[33].zzzz) * (r3) + (c[33].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[32].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[24].yz, r2.zw) + (c[24].x);
    r0.z = (r0.y) * (r0.z);
    r2.w = (r1.x) * (r0.z);
    r1 = c[34];
    r1.x = dot(r0.xw, r1.xy) + (c[23].x);
    r1.y = dot(r0.xw, r1.zw) + (c[23].z);
    r0 = tex2D(s1, r1.xy);
    r7.xyz = normalize(v2.xyz);
    r1.w = max(abs(r7.y), abs(r7.z));
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = max(abs(r7.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r1.xyz = (r2.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r5.xyz = (r1.xyz) * (r0.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r6.xyz = (r0.xyz) * (c0.zzz);
    r3 = (-(v4.yyyy)) + (c[7]);
    r0 = (r3) * (r3);
    r2 = (-(v4.xxxx)) + (c[6]);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[8]);
    r4.xyz = (-(v4.xyz)) + (c[21].xyz);
    r0 = (r1) * (r1) + (r0);
    r8.xyz = normalize(r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.w = saturate(dot(r8.xyz, r7.xyz));
    r3 = (r3) * (r4);
    r3 = (r7.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r7.xxxx) + (r3);
    r3.w = c0.x;
    r0 = saturate((r0) * (c[9]) + (r3.wwww));
    r1 = saturate((r1) * (r7.zzzz) + (r2));
    r3.xyz = (r5.www) * (c[22].xyz);
    r0 = (r0) * (r1);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r1 = tex2D(s0, v1.xy);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r5.xyz) * (r3.xyz) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}
