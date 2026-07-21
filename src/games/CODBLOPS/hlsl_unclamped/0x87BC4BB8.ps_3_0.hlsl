// Mechanically reconstructed from 0x87BC4BB8.ps_3_0.cso.
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
    const float4 c0 = float4(31.875f, 0.25f, 1.0f, 0.0f);
    const float4 c1 = float4(-2.0f, 3.0f, 0.5f, 0.0f);
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

    r8.xyz = normalize(v2.xyz);
    r1.w = max(abs(r8.y), abs(r8.z));
    r0.w = max(abs(r8.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r0.xyz) * (c0.xxx);
    r0 = (v4.yyyy) * (c[25]);
    r2.w = saturate(dot(c[17].xyz, r8.xyz));
    r0 = (v4.xxxx) * (c[24]) + (r0);
    r1.xyz = c[18].xyz;
    r1.xyz = (r1.xyz) * (c[28].xxx);
    r0 = (v4.zzzz) * (c[26]) + (r0);
    r6.xyz = (r2.www) * (r1.xyz);
    r0 = (r0) + (c[27]);
    r4.xy = (r0.ww) * (c[29].xy) + (r0.xy);
    r4.zw = r0.zw;
    r2 = tex2Dproj(s1, r4);
    r3.zw = r4.zw;
    r0.zw = r3.zw;
    r5.xy = (r4.ww) * (-(c[29].zw)) + (r0.xy);
    r5.zw = r0.zw;
    r5 = tex2Dproj(s1, r5);
    r2.w = r5.x;
    r3.xy = (r4.ww) * (-(c[29].xy)) + (r0.xy);
    r0.xy = (r4.ww) * (c[29].zw) + (r0.xy);
    r3 = tex2Dproj(s1, r3);
    r2.y = r3.x;
    r3 = tex2Dproj(s1, r0);
    r0 = (v4.xyzx) * (c0.zzzw) + (c0.wwwz);
    r1.z = dot(r0, c[21]);
    r2.z = r3.x;
    r1.z = 1.0f / (r1.z);
    r1.x = dot(r0, c[10]);
    r1.y = dot(r0, c[11]);
    r2.w = dot(r2, c0.yyyy);
    r2.xy = (r1.zz) * (r1.xy);
    r1.x = dot(r0, c[20]);
    r0.xy = (r2.xy) * (c1.zz) + (c1.zz);
    r0 = tex2D(s2, r0.xy);
    r1.y = (r1.x) * (r1.x);
    r0.w = dot(c[8].yz, r1.xy) + (c[8].x);
    r1.xy = saturate((r1.xx) * (c[9].xy) + (c[9].zw));
    r1.z = saturate(1.0f / (r0.w));
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c0.w) : (r1.z));
    r3.xy = (r1.xy) * (r1.xy);
    r4.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r2.xyz = (-(v4.xyz)) + (c[6].xyz);
    r3.w = (r3.x) * (r4.x);
    r1.xyz = normalize(r2.xyz);
    r2.x = (r3.y) * (-(r4.y)) + (c0.z);
    r2.z = dot(r1.xyz, c[22].xyz);
    r0.w = (r0.w) * (r3.w);
    r2.y = saturate((r2.z) * (c[23].x) + (c[23].y));
    r2.z = (r2.y) * (r2.y);
    r2.y = (r2.y) * (c1.x) + (c1.y);
    r0.w = (r2.x) * (r0.w);
    r2.z = (r2.z) * (r2.y);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r0.w) * (r2.z);
    r1.z = saturate(dot(r1.xyz, r8.xyz));
    r3.xyz = (r0.xyz) * (r0.www);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r1.zzz) * (c[7].xyz);
    r1.xyz = (r0.yzw) * (r0.yzw);
    r3.xyz = (r2.www) * (r3.xyz);
    r4.xyz = (r2.xyz) * (r1.xyz);
    r2.xyz = (r1.www) * (r6.xyz) + (r7.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz);
    r1.w = c0.z;
    r2.x = dot(r1, c[31]);
    r2.y = dot(r1, c[32]);
    r2.z = dot(r1, c[33]);
    r1.xyz = (v3.xyz) * (-(r0.xxx)) + (r2.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r1.xyz = (v3.xyz) * (r0.xxx) + (r1.xyz);
    r1.xyz = max(((r1.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = rsqrt(r0.x);
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
