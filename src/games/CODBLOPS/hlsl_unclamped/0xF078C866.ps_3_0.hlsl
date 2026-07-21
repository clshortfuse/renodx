// Mechanically reconstructed from 0xF078C866.ps_3_0.cso.
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
    const float4 c1 = float4(0.999511719f, 9.99999994e-09f, -0.0f, 0.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s3, v5.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[23].xyz;
    r0.xyz = (-(r0.yzx)) + (c[24].yzx);
    r3.xyz = (r0.www) * (r0.xyz) + (c[23].yzx);
    r0.w = c0.x;
    r0.w = (r0.w) * (c[9].w);
    r0.z = frac(r3.y);
    r0.w = frac(abs(r0.w));
    r1.w = (r3.y) + (-(r0.z));
    r0.w = ((c[9].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r2.w = (r0.z) + (c0.z);
    r0 = (r0.wwww) * (c3);
    r1.w = (r1.w) * (c0.y);
    r1.xy = (c[21].xy) * (r0.xx) + (v5.xy);
    r2.z = exp2(r1.w);
    r2.xy = (r1.xy) * (c[22].xx);
    r1.x = (r2.x) * (r2.z) + (r0.w);
    r1.z = (r2.z) * (r2.y);
    r1 = tex2D(s4, r1.xz);
    r4.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.xy = (r2.xy) * (r2.zz) + (r0.yz);
    r1 = tex2D(s4, r1.xy);
    r0.x = ((r2.w) >= 0.0f ? (-(c0.z)) : (-(c0.y)));
    r1.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.w = (r2.z) * (r0.x);
    r1.xy = (r4.xy) * (r1.xy);
    r0.x = (r2.x) * (r1.w) + (r0.w);
    r5.xy = (r2.xy) * (r1.ww) + (r0.yz);
    r0.z = (r2.y) * (r1.w);
    r0 = tex2D(s4, r0.xz);
    r4.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = tex2D(s4, r5.xy);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.w = (abs(r2.w)) + (abs(r2.w));
    r0.xy = (r0.xy) * (r4.xy) + (-(r1.xy));
    r0.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0.w = (r3.x) * (c[26].x);
    r4.xy = (r0.xy) * (r0.ww);
    r0 = tex2D(s2, r2.xy);
    r1 = tex2D(s5, r2.xy);
    r3.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = v0;
    r2.xyz = (r0.yzx) * (v3.zxy);
    r3.xy = (c[25].xx) * (r3.xy) + (r4.xy);
    r0.xyz = (v3.yzx) * (r0.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.xyz = (r3.xxx) * (v0.xyz) + (r0.xyz);
    r1.w = dot(-(v2.xyz), -(v2.xyz));
    r2.xyz = (r0.xyz) + (v3.xyz);
    r1.w = rsqrt(r1.w);
    r0.xyz = normalize(r2.xyz);
    r2.xyz = (r1.www) * (-(v2.xyz));
    r2.w = dot(-(r2.xyz), r0.xyz);
    r2.w = (r2.w) + (r2.w);
    r2.xyz = (r0.xyz) * (-(r2.www)) + (-(r2.xyz));
    r2 = texCUBE(s1, r2.xyz);
    r5.xyz = (-(v2.xyz)) + (c[5].xyz);
    r6.y = dot(r5.xyz, r5.xyz);
    r4.xyz = (r2.xyz) * (c[20].xxx);
    r2.w = rsqrt(r6.y);
    r2.xyz = (r5.xyz) * (r2.www);
    r6.x = 1.0f / (r2.w);
    r5.xyz = (-(v2.xyz)) * (r1.www) + (r2.xyz);
    r3.w = saturate(dot(r0.xyz, r2.xyz));
    r2.xyz = normalize(r5.xyz);
    r5.xy = saturate((r6.xx) * (c[8].xy) + (c[8].zw));
    r3.xy = (r5.xy) * (r5.xy);
    r5.xy = (r5.xy) * (c0.yy) + (c0.ww);
    r1.w = dot(c[7].yz, r6.xy) + (c[7].x);
    r3.xy = (r3.xy) * (r5.xy);
    r0.y = saturate(dot(r0.xyz, r2.xyz));
    r0.z = (r1.w) * (r3.x);
    r1.w = pow(abs(r0.y), c3.x);
    r0.z = (r3.y) * (r0.z);
    r0.xyz = (r0.zzz) * (c[6].xyz);
    r2.xy = (vPos.xy) * (c[10].zw);
    r2 = tex2D(s0, r2.xy);
    r2.w = (-abs(r2.x)) + (c1.x);
    r2.xyz = (r1.www) * (r0.xyz) + (r4.xyz);
    r1.w = max(c1.y, r2.w);
    r2.w = 1.0f / (r1.w);
    r1.w = c1.x;
    r1.w = (r1.w) * (c[4].x);
    r0.xyz = (r3.www) * (r0.xyz);
    r2.w = (r1.w) * (r2.w) + (-(v1.z));
    r2.xyz = (r3.zzz) * (r2.xyz);
    r1.w = max(r2.w, c1.z);
    r1.w = (r1.w) * (c[27].x);
    r2.w = 1.0f / (c[28].x);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r1.x = saturate((r1.w) * (r2.w));
    r0.xyz = (r0.xyz) * (r1.xxx) + (-(v4.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v4.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r1.x;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
