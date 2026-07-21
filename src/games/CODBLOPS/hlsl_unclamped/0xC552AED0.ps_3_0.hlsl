// Mechanically reconstructed from 0xC552AED0.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : COLOR0;
    float4 v8 : TEXCOORD8;
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
    float4 v7 = input.v7;
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(31.875f, 1.0f, -0.0f, 0.5f);
    const float4 c2 = float4(-2.0f, 3.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v0.xy);
    r2.xyz = (-(v8.xyz)) + (c[21].xyz);
    r1.xyz = normalize(r2.xyz);
    r0.xyz = (r0.xyz) * (c[31].xyz);
    r1.w = dot(r1.xyz, c[29].xyz);
    r2.z = saturate((r1.w) * (c[30].x) + (c[30].y));
    r1 = (v8.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = (r2.z) * (r2.z);
    r2.x = dot(r1, c[27]);
    r2.z = (r2.z) * (c2.x) + (c2.y);
    r2.y = (r2.x) * (r2.x);
    r2.w = (r2.w) * (r2.z);
    r2.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r3.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r3.w = saturate(1.0f / (r2.z));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c2.xx) + (c2.yy);
    r3.w = ((-abs(r2.z)) >= 0.0f ? (c1.z) : (r3.w));
    r2.x = (r2.x) * (r3.x);
    r3.z = (r2.y) * (-(r3.y)) + (c1.y);
    r2.z = dot(r1, c[28]);
    r3.w = (r3.w) * (r2.x);
    r2.z = 1.0f / (r2.z);
    r2.x = dot(r1, c[25]);
    r2.y = dot(r1, c[26]);
    r1.w = (r3.z) * (r3.w);
    r1.xy = (r2.zz) * (r2.xy);
    r3.w = (r2.w) * (r1.w);
    r1.xy = (r1.xy) * (c1.ww) + (c1.ww);
    r1 = tex2D(s2, r1.xy);
    r1.w = dot(v1.xyz, v1.xyz);
    r3.xyz = normalize(v2.xyz);
    r2 = tex2D(s1, v0.xy);
    r4.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r1.w = rsqrt(r1.w);
    r2.xyz = (r3.xyz) * (r4.xxx);
    r3.xyz = (v1.xyz) * (r1.www) + (r2.xyz);
    r2.xyz = normalize(v3.xyz);
    r3.xyz = (r4.yyy) * (r2.xyz) + (r3.xyz);
    r2.xyz = normalize(r3.xyz);
    r4.w = max(abs(r2.y), abs(r2.z));
    r3.xyz = (r1.xyz) * (r1.xyz);
    r1.w = max(abs(r2.x), r4.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.www) * (r3.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    r2.w = saturate(dot(r2.xyz, c[17].xyz));
    r1.w = (r1.w) * (r2.w);
    r4.xyz = normalize(v6.xyz);
    r2.w = (r1.w) * (c[33].x) + (c[33].y);
    r3.w = saturate(dot(r2.xyz, r4.xyz));
    r1.w = (r2.w) * (v5.w);
    r2.z = pow(abs(r3.w), v1.w);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.z);
    r2.xyz = (r2.www) * (c[18].xyz);
    r5.xyz = (r1.www) * (c[19].xyz);
    r1 = tex2D(s3, v0.xy);
    r6.xyz = (r4.xyz) * (v0.zzz);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (c1.xxx);
    r5.xyz = (r5.xyz) * (r4.xyz);
    r4.xyz = (r2.xyz) * (v7.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1 = (-(v8.yyyy)) + (c[7]);
    r2 = (r1) * (r1);
    r1 = (-(v8.xxxx)) + (c[6]);
    r2 = (r1) * (r1) + (r2);
    r1 = (-(v8.zzzz)) + (c[8]);
    r4.xyz = (r0.xyz) * (r4.xyz) + (r5.xyz);
    r1 = (r1) * (r1) + (r2);
    r2.xyz = (r0.xyz) * (c[22].xyz);
    r2.w = c1.y;
    r1 = saturate((r1) * (c[9]) + (r2.wwww));
    r3.xyz = (r3.xyz) * (r2.xyz) + (r4.xyz);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r2.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v5.xyz));
    r1.xyz = v5.xyz;
    r0.xyz = (v4.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = saturate((r0.w) + (r0.w));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
