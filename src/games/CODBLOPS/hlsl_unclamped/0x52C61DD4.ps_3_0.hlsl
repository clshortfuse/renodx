// Mechanically reconstructed from 0x52C61DD4.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, -2.0f, 3.0f, 31.875f);
    const float4 c1 = float4(0.25f, 1.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = (-(v4.xyz)) + (c[28].xyz);
    r3.y = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r3.y);
    r3.x = 1.0f / (r0.w);
    r1.xyz = (r0.xyz) * (r0.www);
    r2.xy = saturate((r3.xx) * (c[32].xy) + (c[32].zw));
    r0.w = dot(c[31].yz, r3.xy) + (c[31].x);
    r0.xy = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c0.yy) + (c0.zz);
    r7.xyz = normalize(v2.xyz);
    r2.xy = (r0.xy) * (r2.xy);
    r2.w = max(abs(r7.y), abs(r7.z));
    r1.w = (r0.w) * (r2.x);
    r0.w = max(abs(r7.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r1.w = (r2.y) * (r1.w);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r5.w = (r1.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r6.xyz = (r0.xyz) * (c0.www);
    r0 = (v4.yyyy) * (c[25]);
    r1.w = saturate(dot(r1.xyz, r7.xyz));
    r0 = (v4.xxxx) * (c[24]) + (r0);
    r1.xyz = c[29].xyz;
    r1.xyz = (r1.xyz) * (c[30].xxx);
    r0 = (v4.zzzz) * (c[26]) + (r0);
    r5.xyz = (r1.www) * (r1.xyz);
    r0 = (r0) + (c[27]);
    r3.xy = (r0.ww) * (c[33].xy) + (r0.xy);
    r3.zw = r0.zw;
    r1 = tex2Dproj(s1, r3);
    r2.zw = r3.zw;
    r0.zw = r2.zw;
    r4.xy = (r3.ww) * (-(c[33].zw)) + (r0.xy);
    r4.zw = r0.zw;
    r4 = tex2Dproj(s1, r4);
    r1.w = r4.x;
    r2.xy = (r3.ww) * (-(c[33].xy)) + (r0.xy);
    r0.xy = (r3.ww) * (c[33].zw) + (r0.xy);
    r2 = tex2Dproj(s1, r2);
    r1.y = r2.x;
    r2 = tex2Dproj(s1, r0);
    r0 = (v4.xyzx) * (c1.yyyz) + (c1.zzzy);
    r2.w = dot(r0, c[21]);
    r1.z = r2.x;
    r2.w = 1.0f / (r2.w);
    r2.x = dot(r0, c[10]);
    r2.y = dot(r0, c[11]);
    r1.w = dot(r1, c1.xxxx);
    r1.xy = (r2.ww) * (r2.xy);
    r2.x = dot(r0, c[20]);
    r0.xy = (r1.xy) * (-(c0.xx)) + (-(c0.xx));
    r0 = tex2D(s2, r0.xy);
    r2.y = (r2.x) * (r2.x);
    r0.w = dot(c[8].yz, r2.xy) + (c[8].x);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.z = saturate(1.0f / (r0.w));
    r2.xy = saturate((r2.xx) * (c[9].xy) + (c[9].zw));
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.z) : (r0.z));
    r0.xy = (r2.xy) * (r2.xy);
    r3.xy = (r2.xy) * (c0.yy) + (c0.zz);
    r2.w = (r0.x) * (r3.x);
    r2.xyz = (-(v4.xyz)) + (c[6].xyz);
    r3.w = (r0.y) * (-(r3.y)) + (c1.y);
    r0.xyz = normalize(r2.xyz);
    r0.w = (r0.w) * (r2.w);
    r2.w = dot(r0.xyz, c[22].xyz);
    r0.w = (r3.w) * (r0.w);
    r2.w = saturate((r2.w) * (c[23].x) + (c[23].y));
    r2.z = (r2.w) * (r2.w);
    r2.y = (r2.w) * (c0.y) + (c0.z);
    r2.w = saturate(dot(r0.xyz, r7.xyz));
    r0.z = (r2.z) * (r2.y);
    r3.w = (r0.w) * (r0.z);
    r0.xy = (v1.xy) * (c[34].xy);
    r0 = tex2D(s3, r0.xy);
    r2.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = saturate((r2.xyz) * (r0.www) + (r0.xyz));
    r2.xyz = (r1.xyz) * (r3.www);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r2.www) * (c[7].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r3.xyz = (r1.xyz) * (r0.xyz);
    r1.xyz = (r5.www) * (r5.xyz) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.w = c1.y;
    r1.x = dot(r0, c[36]);
    r1.y = dot(r0, c[37]);
    r1.z = dot(r0, c[38]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[35].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.y;

    return oC0;
}
