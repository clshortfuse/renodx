// Mechanically reconstructed from 0xAB6084AD.ps_3_0.cso.
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
    float4 oC0 = 0.0f;

    r0 = c4;
    r0.x = dot(c[7].wwww, r0);
    r0.x = frac(r0.x);
    r0.w = c[7].w;
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
    r0.x = 1.0f / (c[22].x);
    r0.y = 1.0f / (c[22].y);
    r0.xy = (v3.xy) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r0.xy);
    r0.w = c[7].w;
    r1.x = (r0.w) * (c2.z);
    r1.x = frac(r1.x);
    r1.x = (r0.w) * (c2.z) + (-(r1.x));
    r1.y = (r1.x) * (c2.w) + (v3.y);
    r1.x = c1.w;
    r1 = tex2D(s2, r1.xy);
    r1.x = (r1.x) * (-(c3.x)) + (v3.x);
    r1.x = (r1.x) * (c3.y) + (-(v3.x));
    r1.x = (c[23].x) * (r1.x) + (v3.x);
    r1.z = (-(r1.x)) + (c0.w);
    r1.zw = float2(((r1.z) >= 0.0f ? (c3.z) : (c3.w)), ((r1.x) >= 0.0f ? (c3.z) : (c3.w)));
    r1.x = saturate(r1.x);
    r1.z = (r1.z) + (r1.w);
    r1.w = frac(abs(v3.y));
    r1.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2 = tex2D(s3, r1.xy);
    r1.xyw = (r2.xyz) * (r2.xyz);
    r1.xyz = float3(((-(r1.z)) >= 0.0f ? (r1.x) : (c3.z)), ((-(r1.z)) >= 0.0f ? (r1.y) : (c3.z)), ((-(r1.z)) >= 0.0f ? (r1.w) : (c3.z)));
    r1.w = abs(c[7].w);
    r1.w = frac(r1.w);
    r2.y = ((c[7].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2.x = c3.z;
    r2 = tex2D(s2, r2.xy);
    r1.w = saturate((r2.x) * (c[21].x));
    r2.xyz = lerp(r1.xyz, r0.xyz, r1.www);
    r0.x = (r0.w) * (c[24].x);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r0.y = (c[28].x) + (-(v3.y));
    r0.y = (r0.y) + (c0.w);
    r0.x = (r0.x) + (r0.y);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r1.x = pow(abs(r0.x), c[27].x);
    r0.w = c0.w;
    r0.x = (r1.x) * (-(c[26].x)) + (r0.w);
    r1.xyz = lerp(c[25].xyz, r2.xyz, r0.xxx);
    r0.xyz = normalize(v2.xyz);
    r1.w = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.w);
    r0.w = 1.0f / (r2.x);
    r2.xyz = (r0.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r0.www) + (v4.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.www) * (c[19].xyz);
    r2.xyz = (r2.xyz) * (c[6].yyy);
    r3.xyz = normalize(c[17].xyz);
    r0.w = dot(-(r3.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r0.xyz) * (-(r0.www)) + (-(r3.xyz));
    r5.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r4.xyz, -(r5.xyz)));
    r1.w = dot(r3.xyz, r5.xyz);
    r1.w = saturate((r1.w) * (c0.x) + (c0.x));
    r2.w = (r1.w) * (c0.y) + (c0.z);
    r1.w = (r1.w) + (c0.w);
    r3.x = pow(abs(r0.w), r2.w);
    r2.xyz = (r2.xyz) * (r3.xxx);
    r2.xyz = (r1.www) * (r2.xyz);
    r0.w = dot(r5.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r5.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.xxx);
    r3 = tex3D(s11, v4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (c[20].xxx);
    r0.xyz = (r0.xyz) * (c2.yyy);
    r0.xyz = (r2.xyz) * (c1.xyz) + (r0.xyz);
    r0.xyz = (r1.xyz) + (r0.xyz);
    r0.w = c0.w;
    r1.x = dot(r0, c[9]);
    r1.y = dot(r0, c[10]);
    r1.z = dot(r0, c[11]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.w;

    return oC0;
}
