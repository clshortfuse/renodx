// Mechanically reconstructed from 0x53194A5A.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
samplerCUBE s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
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
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(0.00333333341f, -2.0f, -0.5f, 3.0f);
    const float4 c1 = float4(1.0f, 0.999511719f, 9.99999994e-09f, -0.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
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

    r0 = tex2D(s3, v5.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[30].xyz;
    r0.xyz = (-(r0.yzx)) + (c[31].yzx);
    r7.xyz = (r0.www) * (r0.xyz) + (c[30].yzx);
    r0.w = c0.x;
    r0.w = (r0.w) * (c[24].w);
    r0.z = frac(r7.y);
    r0.w = frac(abs(r0.w));
    r1.w = (r7.y) + (-(r0.z));
    r0.w = ((c[24].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r2.w = (r0.z) + (c0.z);
    r0 = (r0.wwww) * (c3);
    r1.w = (r1.w) * (c0.y);
    r1.xy = (c[28].xy) * (r0.xx) + (v5.xy);
    r2.z = exp2(r1.w);
    r2.xy = (r1.xy) * (c[29].xx);
    r1.x = (r2.x) * (r2.z) + (r0.w);
    r1.z = (r2.z) * (r2.y);
    r1 = tex2D(s4, r1.xz);
    r3.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.xy = (r2.xy) * (r2.zz) + (r0.yz);
    r1 = tex2D(s4, r1.xy);
    r0.x = ((r2.w) >= 0.0f ? (-(c0.z)) : (-(c0.y)));
    r1.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.w = (r2.z) * (r0.x);
    r1.xy = (r3.xy) * (r1.xy);
    r0.x = (r2.x) * (r1.w) + (r0.w);
    r4.xy = (r2.xy) * (r1.ww) + (r0.yz);
    r0.z = (r2.y) * (r1.w);
    r0 = tex2D(s4, r0.xz);
    r3.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = tex2D(s4, r4.xy);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.w = (abs(r2.w)) + (abs(r2.w));
    r0.xy = (r0.xy) * (r3.xy) + (-(r1.xy));
    r0.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0.w = (r7.x) * (c[33].x);
    r4.xy = (r0.xy) * (r0.ww);
    r0 = tex2D(s2, r2.xy);
    r1 = tex2D(s5, r2.xy);
    r3.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = v0;
    r2.xyz = (r0.yzx) * (v3.zxy);
    r6.xy = (c[32].xx) * (r3.xy) + (r4.xy);
    r0.xyz = (v3.yzx) * (r0.zxy) + (-(r2.xyz));
    r0.xyz = (r6.yyy) * (-(r0.xyz));
    r5 = (-(v2.yyyy)) + (c[6]);
    r2 = (r5) * (r5);
    r4 = (-(v2.xxxx)) + (c[5]);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v2.zzzz)) + (c[7]);
    r0.xyz = (r6.xxx) * (v0.xyz) + (r0.xyz);
    r2 = (r3) * (r3) + (r2);
    r0.xyz = (r0.xyz) + (v3.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r8.xyz = normalize(r0.xyz);
    r5 = (r5) * (r6);
    r5 = (r8.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r8.xxxx) + (r5);
    r6.xy = c1.xy;
    r2 = saturate((r2) * (c[8]) + (r6.xxxx));
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r2 = (r2) * (r3);
    r3.xyz = (-(v2.xyz)) + (c[20].xyz);
    r0.x = dot(c[9], r2);
    r5.y = dot(r3.xyz, r3.xyz);
    r0.y = dot(c[10], r2);
    r1.w = rsqrt(r5.y);
    r0.z = dot(c[11], r2);
    r4.xyz = (r3.xyz) * (r1.www);
    r5.x = 1.0f / (r1.w);
    r3.w = saturate(dot(r8.xyz, r4.xyz));
    r1.w = dot(c[22].yz, r5.xy) + (c[22].x);
    r3.xy = saturate((r5.xx) * (c[23].xy) + (c[23].zw));
    r2.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c0.yy) + (c0.ww);
    r2.xy = (r2.xy) * (r3.xy);
    r2.w = dot(-(v2.xyz), -(v2.xyz));
    r1.w = (r1.w) * (r2.x);
    r2.w = rsqrt(r2.w);
    r1.w = (r2.y) * (r1.w);
    r2.xyz = (r2.www) * (-(v2.xyz));
    r3.xyz = (r1.www) * (c[21].xyz);
    r1.w = dot(-(r2.xyz), r8.xyz);
    r0.xyz = (r3.www) * (r3.xyz) + (r0.xyz);
    r1.w = (r1.w) + (r1.w);
    r5.xyz = (-(v2.xyz)) * (r2.www) + (r4.xyz);
    r2.xyz = (r8.xyz) * (-(r1.www)) + (-(r2.xyz));
    r2 = texCUBE(s1, r2.xyz);
    r4.xyz = (r2.xyz) * (c[27].xxx);
    r2.xyz = normalize(r5.xyz);
    r1.w = saturate(dot(r8.xyz, r2.xyz));
    r2.xy = (vPos.xy) * (c[25].zw);
    r2 = tex2D(s0, r2.xy);
    r2.w = (-abs(r2.x)) + (c1.y);
    r2.z = pow(abs(r1.w), c3.x);
    r1.w = max(c1.z, r2.w);
    r2.w = 1.0f / (r1.w);
    r1.w = (r6.y) * (c[4].x);
    r2.xyz = (r2.zzz) * (r3.xyz) + (r4.xyz);
    r2.w = (r1.w) * (r2.w) + (-(v1.z));
    r2.xyz = (r7.zzz) * (r2.xyz);
    r1.w = max(r2.w, c1.w);
    r1.w = (r1.w) * (c[34].x);
    r2.w = 1.0f / (c[35].x);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r1.x = saturate((r1.w) * (r2.w));
    r0.xyz = (r0.xyz) * (r1.xxx) + (-(v4.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v4.xyz);
    r0.xyz = max(((r0.xyz) * (c[26].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r1.x;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
