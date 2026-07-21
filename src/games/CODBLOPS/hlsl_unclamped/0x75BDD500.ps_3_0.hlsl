// Mechanically reconstructed from 0x75BDD500.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 31.875f);
    const float4 c2 = float4(0.25f, -2.0f, 3.0f, 0.0f);
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

    r0 = (v6.yyyy) * (c[32]);
    r0 = (v6.xxxx) * (c[31]) + (r0);
    r0 = (v6.zzzz) * (c[33]) + (r0);
    r1 = (r0) + (c[34]);
    r3.xy = (r1.ww) * (c[35].xy) + (r1.xy);
    r3.zw = r1.zw;
    r0 = tex2Dproj(s2, r3);
    r2.zw = r3.zw;
    r1.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[35].zw)) + (r1.xy);
    r4.zw = r1.zw;
    r4 = tex2Dproj(s2, r4);
    r0.w = r4.x;
    r2.xy = (r3.ww) * (-(c[35].xy)) + (r1.xy);
    r1.xy = (r3.ww) * (c[35].zw) + (r1.xy);
    r2 = tex2Dproj(s2, r2);
    r0.y = r2.x;
    r2 = tex2Dproj(s2, r1);
    r1 = (v6.xyzx) * (c1.yyyz) + (c1.zzzy);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r3.x = dot(r1, c[25]);
    r3.y = dot(r1, c[26]);
    r0.z = r2.x;
    r3.xy = (r2.ww) * (r3.xy);
    r2.x = dot(r1, c[27]);
    r1.xy = (r3.xy) * (-(c1.xx)) + (-(c1.xx));
    r1 = tex2D(s3, r1.xy);
    r2.y = (r2.x) * (r2.x);
    r1.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r2.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.w = saturate(1.0f / (r1.w));
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c1.z) : (r2.w));
    r3.xy = (r2.xy) * (r2.xy);
    r5.xy = (r2.xy) * (c2.yy) + (c2.zz);
    r2.xyz = (-(v6.xyz)) + (c[21].xyz);
    r3.w = (r3.x) * (r5.x);
    r4.xyz = normalize(r2.xyz);
    r2.y = (r3.y) * (-(r5.y)) + (c1.y);
    r2.w = dot(r4.xyz, c[29].xyz);
    r1.w = (r1.w) * (r3.w);
    r2.z = saturate((r2.w) * (c[30].x) + (c[30].y));
    r2.w = (r2.z) * (r2.z);
    r2.z = (r2.z) * (c2.y) + (c2.z);
    r1.w = (r2.y) * (r1.w);
    r2.w = (r2.w) * (r2.z);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r3.w = dot(r0, c2.xxxx);
    r2.xyz = (r1.xyz) * (r1.www);
    r0 = tex2D(s0, v1.xy);
    r2.w = (r0.w) * (v0.w) + (c1.x);
    r1 = tex2D(s1, v1.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r1.z = c1.y;
    r3.xyz = (r3.www) * (r2.xyz);
    r2.xyz = float3(((r2.w) >= 0.0f ? (r1.x) : (c1.z)), ((r2.w) >= 0.0f ? (r1.y) : (c1.z)), ((r2.w) >= 0.0f ? (r1.z) : (c1.z)));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1 = v2;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c1.z)), ((r2.w) >= 0.0f ? (r0.y) : (c1.z)), ((r2.w) >= 0.0f ? (r0.z) : (c1.z)), ((r2.w) >= 0.0f ? (r0.w) : (c1.z)));
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r9.xyz = normalize(r1.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.z = saturate(dot(r4.xyz, r9.xyz));
    r1.xyz = (r1.zzz) * (c[22].xyz);
    r2.w = max(abs(r9.y), abs(r9.z));
    r4.xyz = (r0.xyz) * (r1.xyz);
    r1.z = max(abs(r9.x), r2.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r9.xyz) * (c[5].xyz);
    r8.xyz = (r3.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.www) + (v7.xyz);
    r4 = tex3D(s11, r1.xyz);
    r1.xyz = (r4.xyz) * (r4.xyz);
    r1.xyz = (r2.zzz) * (r1.xyz);
    r6 = (-(v6.yyyy)) + (c[7]);
    r2 = (r6) * (r6);
    r5 = (-(v6.xxxx)) + (c[6]);
    r2 = (r5) * (r5) + (r2);
    r3 = (-(v6.zzzz)) + (c[8]);
    r4.xyz = (r1.xyz) * (c1.www);
    r2 = (r3) * (r3) + (r2);
    r1.z = saturate(dot(c[17].xyz, r9.xyz));
    r7.x = rsqrt(r2.x);
    r7.y = rsqrt(r2.y);
    r7.z = rsqrt(r2.z);
    r7.w = rsqrt(r2.w);
    r1.xyz = (r1.zzz) * (c[18].xyz);
    r6 = (r6) * (r7);
    r6 = (r9.yyyy) * (r6);
    r5 = (r5) * (r7);
    r3 = (r3) * (r7);
    r5 = (r5) * (r9.xxxx) + (r6);
    r6.z = c1.y;
    r2 = saturate((r2) * (c[9]) + (r6.zzzz));
    r3 = saturate((r3) * (r9.zzzz) + (r5));
    r1.xyz = (r4.www) * (r1.xyz) + (r4.xyz);
    r2 = (r2) * (r3);
    r3.xyz = (r0.xyz) * (r1.xyz) + (r8.xyz);
    r1.x = dot(c[10], r2);
    r1.y = dot(c[11], r2);
    r1.z = dot(c[20], r2);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
