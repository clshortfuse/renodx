// Mechanically reconstructed from 0xC4A45FC1.ps_3_0.cso.
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
sampler2D s5 : register(s5);

struct PS_INPUT
{
    float4 v0 : TEXCOORD3;
    float4 v1 : TEXCOORD5;
    float4 v2 : TEXCOORD6;
    float4 v3 : TEXCOORD7;
    float4 v4 : TEXCOORD8;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(2.75f, -2.0f, 0.5f, 2.0f);
    const float4 c1 = float4(75.0f, 0.5f, -0.5f, 3.68000007f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.00333333341f, 300.0f, -64.0301971f, 9.40301991f);
    const float4 c4 = float4(60.0f, -2.0f, 3.0f, 1.0f);
    const float4 c12 = float4(100.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s1, v4.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[20].xyz;
    r0.xyz = (-(r0.yzx)) + (c[21].yzx);
    r3.xyz = (r0.www) * (r0.xyz) + (c[20].yzx);
    r0.w = frac(r3.y);
    r0.z = (r3.y) + (-(r0.w));
    r2.w = (r0.w) + (c1.z);
    r0.w = c3.x;
    r0.w = (r0.w) * (c[9].w);
    r0.z = (r0.z) * (c0.y);
    r0.w = frac(abs(r0.w));
    r2.z = exp2(r0.z);
    r3.y = ((c[9].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r1.y = (r3.y) * (c4.x);
    r5.xy = (v4.xy) * (c[11].xx);
    r0.x = (r5.x) * (r2.z) + (r1.y);
    r0.z = (r2.z) * (r5.y);
    r0 = tex2D(s2, r0.xz);
    r1.xzw = (r3.yyy) * (c3.yzw);
    r2.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.xy = (r5.xy) * (r2.zz) + (r1.zw);
    r0 = tex2D(s2, r0.xy);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.w = ((r2.w) >= 0.0f ? (c0.z) : (c0.w));
    r4.xy = (r2.xy) * (r0.xy);
    r0.w = (r2.z) * (r0.w);
    r3.w = (abs(r2.w)) + (abs(r2.w));
    r0.x = (r5.x) * (r0.w) + (r1.y);
    r0.z = (r5.y) * (r0.w);
    r2.xy = (r5.xy) * (r0.ww) + (r1.zw);
    r0 = tex2D(s2, r0.xz);
    r6.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0 = tex2D(s2, r2.xy);
    r2.xy = (r5.xy) * (c[22].xx);
    r7.xy = (c[23].xy) * (r1.xx) + (r2.xy);
    r2.xy = (c[24].xx) * (r1.xx) + (r2.xy);
    r1 = tex2D(s3, r7.xy);
    r2 = tex2D(s3, r2.xy);
    r0.z = (r1.x) + (r2.x);
    r0.z = (r0.z) + (r0.z);
    r0.z = (r3.y) * (-(c1.x)) + (r0.z);
    r0.z = (r0.z) + (c1.y);
    r0.z = frac(r0.z);
    r0.z = (r0.z) + (c1.z);
    r0.z = (abs(r0.z)) * (c1.w);
    r0.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r1.w = pow(abs(r0.z), c0.x);
    r0.xy = (r0.xy) * (r6.xy) + (-(r4.xy));
    r0.w = lerp(c[25].x, c[25].y, r1.w);
    r2.xy = (r3.ww) * (r0.xy) + (r4.xy);
    r1.w = (r3.x) * (r0.w);
    r0 = tex2D(s0, r5.xy);
    r3.xy = (r0.wy) * (c2.xy) + (c2.zw);
    r0.xyz = v2.xyz;
    r1.xyz = (r0.zxy) * (v0.yzx);
    r2.xy = (r1.ww) * (r2.xy) + (r3.xy);
    r0.xyz = (r0.yzx) * (v0.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r0.xyz));
    r1.xyz = (r2.xxx) * (v0.xyz) + (r0.xyz);
    r0.xyz = (-(v1.xyz)) + (c[5].xyz);
    r1.xyz = (r1.xyz) + (v2.xyz);
    r3.y = dot(r0.xyz, r0.xyz);
    r0.w = dot(-(v1.xyz), -(v1.xyz));
    r1.w = rsqrt(r3.y);
    r0.w = rsqrt(r0.w);
    r2.xyz = (r0.xyz) * (r1.www);
    r0.xyz = normalize(r1.xyz);
    r1.xyz = (-(v1.xyz)) * (r0.www) + (r2.xyz);
    r3.x = 1.0f / (r1.w);
    r4.xyz = normalize(r1.xyz);
    r1.xyz = (r0.www) * (-(v1.xyz));
    r3.w = saturate(dot(r0.xyz, r4.xyz));
    r2.w = saturate(dot(r0.xyz, r1.xyz));
    r1.xy = saturate((r3.xx) * (c[8].xy) + (c[8].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c4.yy) + (c4.zz);
    r0.w = dot(c[7].yz, r3.xy) + (c[7].x);
    r0.xy = (r0.xy) * (r1.xy);
    r1.w = pow(abs(r3.w), c12.x);
    r0.w = (r0.w) * (r0.x);
    r0.w = (r0.y) * (r0.w);
    r1.xyz = normalize(v2.xyz);
    r0.xyz = (r0.www) * (c[6].xyz);
    r0.w = saturate(dot(r1.xyz, r2.xyz));
    r2.xyz = (r1.www) * (r0.xyz);
    r4.xyz = (r0.xyz) * (r0.www);
    r1 = tex2D(s5, r5.xy);
    r0 = tex2D(s4, r5.xy);
    r0.w = (-(r2.w)) + (c4.w);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r0.w) * (r0.w);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r0.z = (r0.z) * (r0.z);
    r2.w = (-(r0.x)) + (c4.w);
    r1.w = (r0.w) * (r0.z);
    r0.xyz = (r2.xyz) * (r3.zzz) + (-(r1.xyz));
    r0.w = saturate(lerp(r2.w, c4.w, r1.w));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v0.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.w;

    return oC0;
}
