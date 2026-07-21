// Mechanically reconstructed from 0xA600B5A7.ps_3_0.cso.
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
sampler2D s4 : register(s4);

struct PS_INPUT
{
    float4 v0 : TEXCOORD5;
    float4 v1 : TEXCOORD6;
    float4 v2 : TEXCOORD7;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD9;
    float2 vPosInput : VPOS;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c0 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
    const float4 c1 = float4(0.00333333341f, -2.0f, -0.5f, 3.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(1.0f, 1000.0f, -0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s2, v4.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[22].xyz;
    r0.xyz = (-(r0.yzx)) + (c[23].yzx);
    r3.xyz = (r0.www) * (r0.xyz) + (c[22].yzx);
    r0.w = c1.x;
    r0.w = (r0.w) * (c[9].w);
    r0.z = frac(r3.y);
    r0.w = frac(abs(r0.w));
    r1.w = (r3.y) + (-(r0.z));
    r0.w = ((c[9].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r2.w = (r0.z) + (c1.z);
    r0 = (r0.wwww) * (c0);
    r1.w = (r1.w) * (c1.y);
    r1.xy = (c[20].xy) * (r0.xx) + (v4.xy);
    r2.z = exp2(r1.w);
    r2.xy = (r1.xy) * (c[21].xx);
    r1.x = (r2.x) * (r2.z) + (r0.w);
    r1.z = (r2.z) * (r2.y);
    r1 = tex2D(s3, r1.xz);
    r4.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.xy = (r2.xy) * (r2.zz) + (r0.yz);
    r1 = tex2D(s3, r1.xy);
    r0.x = ((r2.w) >= 0.0f ? (-(c1.z)) : (-(c1.y)));
    r1.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.w = (r2.z) * (r0.x);
    r1.xy = (r4.xy) * (r1.xy);
    r0.x = (r2.x) * (r1.w) + (r0.w);
    r5.xy = (r2.xy) * (r1.ww) + (r0.yz);
    r0.z = (r2.y) * (r1.w);
    r0 = tex2D(s3, r0.xz);
    r4.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = tex2D(s3, r5.xy);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.w = (abs(r2.w)) + (abs(r2.w));
    r0.xy = (r0.xy) * (r4.xy) + (-(r1.xy));
    r0.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0.w = (r3.x) * (c[25].x);
    r4.xy = (r0.xy) * (r0.ww);
    r1 = tex2D(s1, r2.xy);
    r0 = tex2D(s4, r2.xy);
    r3.xy = (r1.wy) * (c2.xy) + (c2.zw);
    r1.xyz = v3.xyz;
    r2.xyz = (r1.zxy) * (v0.yzx);
    r3.xy = (c[24].xx) * (r3.xy) + (r4.xy);
    r1.xyz = (r1.yzx) * (v0.zxy) + (-(r2.xyz));
    r1.xyz = (r3.yyy) * (-(r1.xyz));
    r1.xyz = (r3.xxx) * (v0.xyz) + (r1.xyz);
    r2.xyz = (r1.xyz) + (v3.xyz);
    r1.xyz = normalize(r2.xyz);
    r2.xyz = (-(v2.xyz)) + (c[5].xyz);
    r0.w = dot(-(v2.xyz), -(v2.xyz));
    r7.y = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r1.w = rsqrt(r7.y);
    r5.xyz = (r2.xyz) * (r1.www);
    r7.x = 1.0f / (r1.w);
    r6.xyz = (-(v2.xyz)) * (r0.www) + (r5.xyz);
    r2.xyz = (r0.www) * (-(v2.xyz));
    r4.xyz = normalize(r6.xyz);
    r6.xy = saturate((r7.xx) * (c[8].xy) + (c[8].zw));
    r3.xy = (r6.xy) * (r6.xy);
    r6.xy = (r6.xy) * (c1.yy) + (c1.ww);
    r0.w = dot(c[7].yz, r7.xy) + (c[7].x);
    r3.xy = (r3.xy) * (r6.xy);
    r2.w = saturate(dot(r1.xyz, r4.xyz));
    r1.w = (r0.w) * (r3.x);
    r0.w = saturate(dot(r1.xyz, r2.xyz));
    r1.z = (r3.y) * (r1.w);
    r1.w = pow(abs(r2.w), c3.y);
    r2.xyz = (r1.zzz) * (c[6].xyz);
    r1.xyz = (r1.www) * (r2.xyz);
    r4.xyz = normalize(v3.xyz);
    r1.w = saturate(dot(r4.xyz, r5.xyz));
    r0.w = (-(r0.w)) + (c3.x);
    r2.xyz = (r2.xyz) * (r1.www);
    r1.w = (r0.w) * (r0.w);
    r2.xyz = (r0.xyz) * (r2.xyz);
    r0.z = (r1.w) * (r1.w);
    r1.xyz = (r1.xyz) * (r3.zzz) + (-(r2.xyz));
    r2.w = (r0.w) * (r0.z);
    r0.w = c3.x;
    r3.w = (r0.w) + (-(c[26].x));
    r0.xy = (vPos.xy) * (c[10].zw);
    r0 = tex2D(s0, r0.xy);
    r1.w = (abs(r0.x)) + (-(v1.z));
    r0.z = saturate((r2.w) * (r3.w) + (c[26].x));
    r0.w = max(r1.w, c3.z);
    r0.w = (r0.w) * (c[27].x);
    r1.w = 1.0f / (c[28].x);
    r0.xyz = (r0.zzz) * (r1.xyz) + (r2.xyz);
    r0.w = saturate((r0.w) * (r1.w));
    r0.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r0.xyz) * (v1.www);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
