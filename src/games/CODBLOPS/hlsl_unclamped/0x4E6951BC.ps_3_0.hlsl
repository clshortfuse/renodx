// Mechanically reconstructed from 0x4E6951BC.ps_3_0.cso.
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
    float2 vPosInput : VPOS;
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
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(31.875f, 0.25f, 1.0f, 0.0f);
    const float4 c1 = float4(1.0f, 0.5f, -2.0f, 3.0f);
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
    float4 oC0 = 0.0f;

    r0.w = 1.0f / (v0.z);
    r1.xy = (r0.ww) * (v0.xy);
    r0.xy = (vPos.xy) * (c[33].zw);
    r0 = tex2D(s3, r0.xy);
    r0.z = abs(r0.x);
    r0.xy = (r1.xy) * (r0.zz);
    r0.w = c1.x;
    r2.y = dot(r0, v3);
    r2.z = dot(r0, v4);
    r2.x = dot(r0, v2);
    r1.xyz = (r2.xyz) * (c1.yyy) + (c1.yyy);
    r8.w = (-abs(r2.x)) + (c1.x);
    r0 = r1.xxxx;
    clip(r0.wwxx);
    r0 = r1.yyyy;
    clip(r0.wwxx);
    r0 = r1.zzzz;
    clip(r0.wwxx);
    r0 = (-(r1.xxxx)) + (c1.xxxx);
    clip(r0.wwxx);
    r2 = (-(r1.yyyy)) + (c1.xxxx);
    r0 = tex2D(s0, r1.yz);
    r3.xyz = (-(v6.xyz)) + (c[28].xyz);
    r5.y = dot(r3.xyz, r3.xyz);
    r3.w = rsqrt(r5.y);
    r5.x = 1.0f / (r3.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4.xy = saturate((r5.xx) * (c[31].xy) + (c[31].zw));
    r1.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c1.zz) + (c1.ww);
    r1.w = dot(c[30].yz, r5.xy) + (c[30].x);
    r1.xy = (r1.xy) * (r4.xy);
    r4.xyz = (r3.xyz) * (r3.www);
    r1.w = (r1.w) * (r1.x);
    r5.x = v5.w;
    r10.xyz = normalize(v5.xyz);
    r5.y = v0.w;
    r3.w = max(abs(r10.y), abs(r10.z));
    r5.z = v1.z;
    r1.x = max(abs(r10.x), r3.w);
    r1.x = 1.0f / (r1.x);
    r3.xyz = (r10.xyz) * (c[5].xyz);
    r1.w = (r1.y) * (r1.w);
    r3.xyz = (r3.xyz) * (r1.xxx) + (r5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r1.w = (r1.w) * (r3.w);
    r5.xyz = (r3.xyz) * (r3.xyz);
    r3 = (v6.yyyy) * (c[25]);
    r9.xyz = (r5.xyz) * (c0.xxx);
    r3 = (v6.xxxx) * (c[24]) + (r3);
    r1.y = saturate(dot(r4.xyz, r10.xyz));
    r3 = (v6.zzzz) * (c[26]) + (r3);
    r8.xyz = (r1.yyy) * (c[29].xyz);
    r3 = (r3) + (c[27]);
    r6.xy = (r3.ww) * (c[32].xy) + (r3.xy);
    r6.zw = r3.zw;
    r4 = tex2Dproj(s1, r6);
    r5.zw = r6.zw;
    r3.zw = r5.zw;
    r7.xy = (r6.ww) * (-(c[32].zw)) + (r3.xy);
    r7.zw = r3.zw;
    r7 = tex2Dproj(s1, r7);
    r4.w = r7.x;
    r5.xy = (r6.ww) * (-(c[32].xy)) + (r3.xy);
    r3.xy = (r6.ww) * (c[32].zw) + (r3.xy);
    r5 = tex2Dproj(s1, r5);
    r4.y = r5.x;
    r5 = tex2Dproj(s1, r3);
    r3 = (v6.xyzx) * (c0.zzzw) + (c0.wwwz);
    r1.y = dot(r3, c[21]);
    r4.z = r5.x;
    r5.w = 1.0f / (r1.y);
    r1.x = dot(r3, c[10]);
    r1.y = dot(r3, c[11]);
    r4.w = dot(r4, c0.yyyy);
    r4.xy = (r5.ww) * (r1.xy);
    r1.x = dot(r3, c[20]);
    r3.xy = (r4.xy) * (c1.yy) + (c1.yy);
    r3 = tex2D(s2, r3.xy);
    r1.y = (r1.x) * (r1.x);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.y = dot(c[8].yz, r1.xy) + (c[8].x);
    r4.xy = saturate((r1.xx) * (c[9].xy) + (c[9].zw));
    r1.x = saturate(1.0f / (r1.y));
    r3.w = ((-abs(r1.y)) >= 0.0f ? (c0.w) : (r1.x));
    r1.xy = (r4.xy) * (r4.xy);
    r6.xy = (r4.xy) * (c1.zz) + (c1.ww);
    r5.xyz = (-(v6.xyz)) + (c[6].xyz);
    r1.x = (r1.x) * (r6.x);
    r4.xyz = normalize(r5.xyz);
    r5.w = (r1.y) * (-(r6.y)) + (c1.x);
    r1.y = dot(r4.xyz, c[22].xyz);
    r1.x = (r3.w) * (r1.x);
    r3.w = saturate((r1.y) * (c[23].x) + (c[23].y));
    r1.y = (r3.w) * (r3.w);
    r3.w = (r3.w) * (c1.z) + (c1.w);
    r1.x = (r5.w) * (r1.x);
    r3.w = (r1.y) * (r3.w);
    r1.y = saturate(dot(r4.xyz, r10.xyz));
    r1.x = (r1.x) * (r3.w);
    r4.xyz = (r3.xyz) * (r1.xxx);
    r3.xyz = (r1.yyy) * (c[7].xyz);
    r4.xyz = (r4.www) * (r4.xyz);
    r5.xyz = (r0.xyz) * (r3.xyz);
    r3.xyz = (r1.www) * (r8.xyz) + (r9.xyz);
    r4.xyz = (r4.xyz) * (r5.xyz);
    clip(r2.wwxx);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r4.xyz);
    r1 = (-(r1.zzzz)) + (c1.xxxx);
    r0.xyz = max(((r0.xyz) * (c[34].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    clip(r1.wwxx);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r8.w) * (r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
