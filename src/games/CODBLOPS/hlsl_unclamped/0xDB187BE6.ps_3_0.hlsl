// Mechanically reconstructed from 0xDB187BE6.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(0.5f, -28.0f, 30.0f, 1.0f);
    const float4 c1 = float4(0.38647899f, 0.392856985f, 0.364796013f, 0.782500029f);
    const float4 c2 = float4(8.0f, 31.875f, 15.0f, 0.0399999991f);
    const float4 c3 = float4(0.00749999983f, 1.00750005f, 0.0f, 1.0f);
    const float4 c4 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = c4;
    r0.x = dot(c[22].wwww, r0);
    r0.x = frac(r0.x);
    r0.w = c[22].w;
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
    r0.x = 1.0f / (c[29].x);
    r0.y = 1.0f / (c[29].y);
    r0.xy = (v3.xy) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r0.xy);
    r0.w = c[22].w;
    r1.x = (r0.w) * (c2.z);
    r1.x = frac(r1.x);
    r1.x = (r0.w) * (c2.z) + (-(r1.x));
    r1.y = (r1.x) * (c2.w) + (v3.y);
    r1.x = c1.w;
    r1 = tex2D(s2, r1.xy);
    r1.x = (r1.x) * (-(c3.x)) + (v3.x);
    r1.x = (r1.x) * (c3.y) + (-(v3.x));
    r1.x = (c[30].x) * (r1.x) + (v3.x);
    r1.z = (-(r1.x)) + (c0.w);
    r1.zw = float2(((r1.z) >= 0.0f ? (c3.z) : (c3.w)), ((r1.x) >= 0.0f ? (c3.z) : (c3.w)));
    r1.x = saturate(r1.x);
    r1.z = (r1.z) + (r1.w);
    r1.w = frac(abs(v3.y));
    r1.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2 = tex2D(s3, r1.xy);
    r1.xyw = (r2.xyz) * (r2.xyz);
    r1.xyz = float3(((-(r1.z)) >= 0.0f ? (r1.x) : (c3.z)), ((-(r1.z)) >= 0.0f ? (r1.y) : (c3.z)), ((-(r1.z)) >= 0.0f ? (r1.w) : (c3.z)));
    r1.w = abs(c[22].w);
    r1.w = frac(r1.w);
    r2.y = ((c[22].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2.x = c3.z;
    r2 = tex2D(s2, r2.xy);
    r1.w = saturate((r2.x) * (c[28].x));
    r2.xyz = lerp(r1.xyz, r0.xyz, r1.www);
    r0.x = (r0.w) * (c[31].x);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r0.y = (c[35].x) + (-(v3.y));
    r0.y = (r0.y) + (c0.w);
    r0.x = (r0.x) + (r0.y);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r1.x = pow(abs(r0.x), c[34].x);
    r0.w = c0.w;
    r0.x = (r1.x) * (-(c[33].x)) + (r0.w);
    r1.xyz = lerp(c[32].xyz, r2.xyz, r0.xxx);
    r0.xyz = normalize(v2.xyz);
    r1.w = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.w);
    r1.w = 1.0f / (r2.x);
    r2.xyz = (r0.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r1.www) + (v4.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.www) * (c[19].xyz);
    r2.xyz = (r2.xyz) * (c[21].yyy);
    r3.xyz = normalize(c[17].xyz);
    r1.w = dot(-(r3.xyz), r0.xyz);
    r1.w = (r1.w) + (r1.w);
    r4.xyz = (r0.xyz) * (-(r1.www)) + (-(r3.xyz));
    r5.xyz = normalize(v1.xyz);
    r1.w = saturate(dot(r4.xyz, -(r5.xyz)));
    r2.w = dot(r3.xyz, r5.xyz);
    r2.w = saturate((r2.w) * (c0.x) + (c0.x));
    r3.x = (r2.w) * (c0.y) + (c0.z);
    r2.w = (r2.w) + (c0.w);
    r4.x = pow(abs(r1.w), r3.x);
    r2.xyz = (r2.xyz) * (r4.xxx);
    r2.xyz = (r2.www) * (r2.xyz);
    r1.w = dot(r5.xyz, r0.xyz);
    r1.w = (r1.w) + (r1.w);
    r3.xyz = (r0.xyz) * (-(r1.www)) + (r5.xyz);
    r3 = texCUBE(s15, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c2.xxx);
    r4 = tex3D(s11, v4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (r4.xyz);
    r3.xyz = (r3.xyz) * (c[27].xxx);
    r3.xyz = (r3.xyz) * (c2.yyy);
    r2.xyz = (r2.xyz) * (c1.xyz) + (r3.xyz);
    r1.xyz = (r1.xyz) + (r2.xyz);
    r2 = (c[7]) + (-(v1.yyyy));
    r3 = (r2) * (r2);
    r4 = (c[6]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[8]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r3 = saturate((r3) * (c[9]) + (r0.wwww));
    r2 = (r2) * (r6);
    r2 = (r0.yyyy) * (r2);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r2 = (r4) * (r0.xxxx) + (r2);
    r0 = saturate((r5) * (r0.zzzz) + (r2));
    r0 = (r3) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c0.w;
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r1.z = dot(r0, c[26]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.w;

    return oC0;
}
