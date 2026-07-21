// Mechanically reconstructed from 0xAAC1D434.ps_3_0.cso.
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
    float4 oC0 = 0.0f;

    r0 = (v6.yyyy) * (c[25]);
    r0 = (v6.xxxx) * (c[24]) + (r0);
    r0 = (v6.zzzz) * (c[26]) + (r0);
    r0 = (r0) + (c[27]);
    r3.xy = (r0.ww) * (c[29].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s2, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[29].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s2, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[29].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[29].zw) + (r0.xy);
    r2 = tex2Dproj(s2, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s2, r0);
    r0 = (v6.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = dot(r0, c[21]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[10]);
    r2.y = dot(r0, c[11]);
    r3.w = dot(r1, c2.xxxx);
    r1.xy = (r2.ww) * (r2.xy);
    r2.x = dot(r0, c[20]);
    r0.xy = (r1.xy) * (-(c1.xx)) + (-(c1.xx));
    r0 = tex2D(s3, r0.xy);
    r2.y = (r2.x) * (r2.x);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(c[8].yz, r2.xy) + (c[8].x);
    r0.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r0.z = saturate(1.0f / (r0.w));
    r1.w = ((-abs(r0.w)) >= 0.0f ? (c1.z) : (r0.z));
    r2.xy = (r0.xy) * (r0.xy);
    r3.xy = (r0.xy) * (c2.yy) + (c2.zz);
    r0.xyz = (-(v6.xyz)) + (c[6].xyz);
    r2.w = (r2.x) * (r3.x);
    r5.xyz = normalize(r0.xyz);
    r0.x = (r2.y) * (-(r3.y)) + (c1.y);
    r0.w = dot(r5.xyz, c[22].xyz);
    r0.y = (r1.w) * (r2.w);
    r0.z = saturate((r0.w) * (c[23].x) + (c[23].y));
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (c2.y) + (c2.z);
    r1.w = (r0.x) * (r0.y);
    r3.z = (r0.w) * (r0.z);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2.z = c1.y;
    r0 = tex2D(s0, v1.xy);
    r2.w = (r0.w) * (v0.w) + (c1.x);
    r0.w = (r1.w) * (r3.z);
    r3.xyz = float3(((r2.w) >= 0.0f ? (r2.x) : (c1.z)), ((r2.w) >= 0.0f ? (r2.y) : (c1.z)), ((r2.w) >= 0.0f ? (r2.z) : (c1.z)));
    r2.xyz = (r1.xyz) * (r0.www);
    r1 = v2;
    r1.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r4.xyz = (r3.www) * (r2.xyz);
    r1.xyz = (r3.yyy) * (v4.xyz) + (r1.xyz);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.xyz = normalize(r1.xyz);
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (c1.z)), ((r2.w) >= 0.0f ? (r0.y) : (c1.z)), ((r2.w) >= 0.0f ? (r0.z) : (c1.z)), ((r2.w) >= 0.0f ? (r0.w) : (c1.z)));
    r1.z = saturate(dot(r5.xyz, r2.xyz));
    r1.xyz = (r1.zzz) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.w = max(abs(r2.y), abs(r2.z));
    r5.xyz = (r1.xyz) * (r0.xyz);
    r1.z = max(abs(r2.x), r3.w);
    r2.w = 1.0f / (r1.z);
    r1.xyz = (r2.xyz) * (c[5].xyz);
    r3.w = saturate(dot(c[17].xyz, r2.xyz));
    r1.xyz = (r1.xyz) * (r2.www) + (v7.xyz);
    r2 = tex3D(s11, r1.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r3.zzz) * (r1.xyz);
    r1.xyz = c[18].xyz;
    r1.xyz = (r1.xyz) * (c[28].xxx);
    r3.xyz = (r2.xyz) * (c1.www);
    r1.xyz = (r3.www) * (r1.xyz);
    r2.xyz = (r4.xyz) * (r5.xyz);
    r1.xyz = (r2.www) * (r1.xyz) + (r3.xyz);
    r2.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r2.w = c1.y;
    r0.x = dot(r2, c[31]);
    r0.y = dot(r2, c[32]);
    r0.z = dot(r2, c[33]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
