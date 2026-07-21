// Mechanically reconstructed from 0xD86882A8.ps_3_0.cso.
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
    const float4 c0 = float4(0.999511719f, 9.99999994e-09f, 1.0f, 0.5f);
    const float4 c1 = float4(-2.0f, 3.0f, 31.875f, 0.25f);
    const float4 c2 = float4(1.0f, 0.0f, 0.0f, 0.0f);
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

    r0.xy = (vPos.xy) * (c[33].zw);
    r0 = tex2D(s3, r0.xy);
    r1.w = (-abs(r0.x)) + (c0.x);
    r0.w = max(c0.y, r1.w);
    r0.y = 1.0f / (r0.w);
    r0.w = c0.x;
    r0.z = (r0.w) * (c[4].x);
    r0.w = 1.0f / (v0.z);
    r0.z = (r0.y) * (r0.z);
    r0.xy = (r0.ww) * (v0.xy);
    r0.xy = (r0.zz) * (r0.xy);
    r0.w = c0.z;
    r2.y = dot(r0, v3);
    r2.z = dot(r0, v4);
    r2.x = dot(r0, v2);
    r1.xyz = (r2.xyz) * (c0.www) + (c0.www);
    r8.w = (-abs(r2.x)) + (c0.z);
    r0 = r1.xxxx;
    clip(r0.wwxx);
    r0 = r1.yyyy;
    clip(r0.wwxx);
    r0 = r1.zzzz;
    clip(r0.wwxx);
    r0 = (-(r1.xxxx)) + (c0.zzzz);
    clip(r0.wwxx);
    r2 = (-(r1.yyyy)) + (c0.zzzz);
    r0 = tex2D(s0, r1.yz);
    r3 = (v6.yyyy) * (c[25]);
    r3 = (v6.xxxx) * (c[24]) + (r3);
    r3 = (v6.zzzz) * (c[26]) + (r3);
    r0.xyz = (r0.xyz) * (r0.xyz);
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
    r3 = (v6.xyzx) * (c2.xxxy) + (c2.yyyx);
    r1.w = dot(r3, c[21]);
    r4.z = r5.x;
    r5.w = 1.0f / (r1.w);
    r1.x = dot(r3, c[10]);
    r1.y = dot(r3, c[11]);
    r1.w = dot(r4, c1.wwww);
    r4.xy = (r5.ww) * (r1.xy);
    r1.x = dot(r3, c[20]);
    r3.xy = (r4.xy) * (c0.ww) + (c0.ww);
    r3 = tex2D(s2, r3.xy);
    r1.y = (r1.x) * (r1.x);
    r1.y = dot(c[8].yz, r1.xy) + (c[8].x);
    r4.xy = saturate((r1.xx) * (c[9].xy) + (c[9].zw));
    r1.x = saturate(1.0f / (r1.y));
    r3.w = ((-abs(r1.y)) >= 0.0f ? (c2.y) : (r1.x));
    r1.xy = (r4.xy) * (r4.xy);
    r6.xy = (r4.xy) * (c1.xx) + (c1.yy);
    r4.xyz = (-(v6.xyz)) + (c[6].xyz);
    r5.w = (r1.x) * (r6.x);
    r5.xyz = normalize(r4.xyz);
    r4.w = (r1.y) * (-(r6.y)) + (c0.z);
    r1.x = dot(r5.xyz, c[22].xyz);
    r1.y = (r3.w) * (r5.w);
    r3.w = saturate((r1.x) * (c[23].x) + (c[23].y));
    r1.x = (r3.w) * (r3.w);
    r3.w = (r3.w) * (c1.x) + (c1.y);
    r1.y = (r4.w) * (r1.y);
    r1.x = (r1.x) * (r3.w);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.y = (r1.y) * (r1.x);
    r3.xyz = (r3.xyz) * (r1.yyy);
    r7.xyz = normalize(v5.xyz);
    r4.xyz = (r1.www) * (r3.xyz);
    r3.w = max(abs(r7.y), abs(r7.z));
    r1.y = saturate(dot(r5.xyz, r7.xyz));
    r1.w = max(abs(r7.x), r3.w);
    r6.xyz = (r1.yyy) * (c[7].xyz);
    r1.w = 1.0f / (r1.w);
    r5.x = v5.w;
    r5.y = v0.w;
    r5.z = v1.z;
    r3.xyz = (r7.xyz) * (c[5].xyz);
    r6.xyz = (r0.xyz) * (r6.xyz);
    r3.xyz = (r3.xyz) * (r1.www) + (r5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r8.xyz = (-(v6.xyz)) + (c[28].xyz);
    r9.y = dot(r8.xyz, r8.xyz);
    r4.w = rsqrt(r9.y);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r9.x = 1.0f / (r4.w);
    r5.xyz = (r3.xyz) * (c1.zzz);
    r3.xy = saturate((r9.xx) * (c[31].xy) + (c[31].zw));
    r1.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c1.xx) + (c1.yy);
    r1.w = dot(c[30].yz, r9.xy) + (c[30].x);
    r1.xy = (r1.xy) * (r3.xy);
    r3.xyz = (r8.xyz) * (r4.www);
    r1.w = (r1.w) * (r1.x);
    r1.w = (r1.y) * (r1.w);
    r1.y = saturate(dot(r3.xyz, r7.xyz));
    r1.w = (r3.w) * (r1.w);
    r3.xyz = (r1.yyy) * (c[29].xyz);
    r4.xyz = (r4.xyz) * (r6.xyz);
    r3.xyz = (r1.www) * (r3.xyz) + (r5.xyz);
    clip(r2.wwxx);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r4.xyz);
    r1 = (-(r1.zzzz)) + (c0.zzzz);
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
