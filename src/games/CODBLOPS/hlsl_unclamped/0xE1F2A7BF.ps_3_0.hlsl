// Mechanically reconstructed from 0xE1F2A7BF.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    const float4 c0 = float4(8.0f, 31.875f, 4.0f, 2.0f);
    const float4 c1 = float4(0.5f, -28.0f, 30.0f, 1.0f);
    const float4 c2 = float4(0.38647899f, 0.392856985f, 0.364796013f, 15.0f);
    const float4 c3 = float4(0.0399999991f, 0.782500029f, 0.00749999983f, 1.00750005f);
    const float4 c4 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    const float4 c12 = float4(0.0f, 1.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = c4;
    r0.x = dot(c[21].wwww, r0);
    r0.x = frac(r0.x);
    r0.w = c[21].w;
    r1.x = dot(r0.xwww, c4);
    r0.y = frac(r1.x);
    r1.x = dot(r0.xyww, c4);
    r0.z = frac(r1.x);
    r1.x = dot(r0, c4);
    r0.w = frac(r1.x);
    r1.yzw = r0.yzw;
    r0.x = dot(r0, c4);
    r1.x = frac(r0.x);
    r0.x = dot(r1, c4);
    r1.y = frac(r0.x);
    r0.x = 1.0f / (c[28].x);
    r0.y = 1.0f / (c[28].y);
    r0.xy = (v3.xy) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r0.xy);
    r0.w = c[21].w;
    r1.x = (r0.w) * (c2.w);
    r1.x = frac(r1.x);
    r1.x = (r0.w) * (c2.w) + (-(r1.x));
    r1.y = (r1.x) * (c3.x) + (v3.y);
    r1.x = c3.y;
    r1 = tex2D(s2, r1.xy);
    r1.x = (r1.x) * (-(c3.z)) + (v3.x);
    r1.x = (r1.x) * (c3.w) + (-(v3.x));
    r1.x = (c[29].x) * (r1.x) + (v3.x);
    r1.z = (-(r1.x)) + (c1.w);
    r1.zw = float2(((r1.z) >= 0.0f ? (c12.x) : (c12.y)), ((r1.x) >= 0.0f ? (c12.x) : (c12.y)));
    r1.x = saturate(r1.x);
    r1.z = (r1.z) + (r1.w);
    r1.w = frac(abs(v3.y));
    r1.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2 = tex2D(s3, r1.xy);
    r1.xyw = (r2.xyz) * (r2.xyz);
    r1.xyz = float3(((-(r1.z)) >= 0.0f ? (r1.x) : (c12.x)), ((-(r1.z)) >= 0.0f ? (r1.y) : (c12.x)), ((-(r1.z)) >= 0.0f ? (r1.w) : (c12.x)));
    r1.w = abs(c[21].w);
    r1.w = frac(r1.w);
    r2.y = ((c[21].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2.x = c12.x;
    r2 = tex2D(s2, r2.xy);
    r1.w = saturate((r2.x) * (c[27].x));
    r2.xyz = lerp(r1.xyz, r0.xyz, r1.www);
    r0.x = (r0.w) * (c[30].x);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r0.y = (c[34].x) + (-(v3.y));
    r0.y = (r0.y) + (c1.w);
    r0.x = (r0.x) + (r0.y);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r1.x = pow(abs(r0.x), c[33].x);
    r0.w = c1.w;
    r0.x = (r1.x) * (-(c[32].x)) + (r0.w);
    r1.xyz = lerp(c[31].xyz, r2.xyz, r0.xxx);
    r0.xy = (c1.wx) * (v3.zw);
    r2 = tex2D(s13, r0.xy);
    r3 = tex2D(s14, v3.zw);
    r0.x = (r3.x) * (c0.y);
    r0.yz = (r2.xz) * (r0.xx);
    r1.w = (r3.x) * (c0.y) + (-(r0.y));
    r0.x = (r2.z) * (-(r0.x)) + (r1.w);
    r2.xyz = normalize(v1.xyz);
    r3.xyz = normalize(v2.xyz);
    r1.w = dot(r2.xyz, r3.xyz);
    r1.w = (r1.w) + (r1.w);
    r4.xyz = (r3.xyz) * (-(r1.www)) + (r2.xyz);
    r4 = texCUBE(s15, r4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c0.xxx);
    r5.xyz = (r0.yxz) * (r4.xyz);
    r0.xyz = (r5.xyz) * (c[26].xxx);
    r0.xyz = (r0.xyz) * (c0.zwz);
    r4.xyz = normalize(c[17].xyz);
    r1.w = dot(-(r4.xyz), r3.xyz);
    r1.w = (r1.w) + (r1.w);
    r5.xyz = (r3.xyz) * (-(r1.www)) + (-(r4.xyz));
    r1.w = dot(r4.xyz, r2.xyz);
    r2.x = saturate(dot(r5.xyz, -(r2.xyz)));
    r1.w = saturate((r1.w) * (c1.x) + (c1.x));
    r2.y = (r1.w) * (c1.y) + (c1.z);
    r1.w = (r1.w) + (c1.w);
    r3.w = pow(abs(r2.x), r2.y);
    r2 = tex2D(s12, v3.zw);
    r2.xyz = (r2.yyy) * (c[19].xyz);
    r2.xyz = (r2.xyz) * (c[20].yyy);
    r2.xyz = (r3.www) * (r2.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r0.xyz = (r2.xyz) * (c2.xyz) + (r0.xyz);
    r0.xyz = (r1.xyz) + (r0.xyz);
    r1 = (c[6]) + (-(v1.yyyy));
    r2 = (r1) * (r1);
    r4 = (c[5]) + (-(v1.xxxx));
    r2 = (r4) * (r4) + (r2);
    r5 = (c[7]) + (-(v1.zzzz));
    r2 = (r5) * (r5) + (r2);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r2 = saturate((r2) * (c[8]) + (r0.wwww));
    r1 = (r1) * (r6);
    r1 = (r3.yyyy) * (r1);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r1 = (r4) * (r3.xxxx) + (r1);
    r1 = saturate((r5) * (r3.zzzz) + (r1));
    r1 = (r2) * (r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r2.z = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r0.xyz);
    r0.w = c1.w;
    r1.x = dot(r0, c[23]);
    r1.y = dot(r0, c[24]);
    r1.z = dot(r0, c[25]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c1.w;

    return oC0;
}
