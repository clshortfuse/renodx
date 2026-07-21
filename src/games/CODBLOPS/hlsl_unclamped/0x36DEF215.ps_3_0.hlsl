// Mechanically reconstructed from 0x36DEF215.ps_3_0.cso.
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
    const float4 c0 = float4(-2.0f, 3.0f, 0.5f, 1.0f);
    const float4 c1 = float4(-28.0f, 30.0f, 8.0f, 31.875f);
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
    float4 oC0 = 0.0f;

    r0 = c4;
    r0.x = dot(c[11].wwww, r0);
    r0.x = frac(r0.x);
    r0.w = c[11].w;
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
    r0.x = 1.0f / (c[26].x);
    r0.y = 1.0f / (c[26].y);
    r0.xy = (v3.xy) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r0.xy);
    r0.w = c[11].w;
    r1.x = (r0.w) * (c2.w);
    r1.x = frac(r1.x);
    r1.x = (r0.w) * (c2.w) + (-(r1.x));
    r1.y = (r1.x) * (c3.x) + (v3.y);
    r1.x = c3.y;
    r1 = tex2D(s2, r1.xy);
    r1.x = (r1.x) * (-(c3.z)) + (v3.x);
    r1.x = (r1.x) * (c3.w) + (-(v3.x));
    r1.x = (c[27].x) * (r1.x) + (v3.x);
    r1.z = (-(r1.x)) + (c0.w);
    r1.zw = float2(((r1.z) >= 0.0f ? (c12.x) : (c12.y)), ((r1.x) >= 0.0f ? (c12.x) : (c12.y)));
    r1.x = saturate(r1.x);
    r1.z = (r1.z) + (r1.w);
    r1.w = frac(abs(v3.y));
    r1.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2 = tex2D(s3, r1.xy);
    r1.xyw = (r2.xyz) * (r2.xyz);
    r1.xyz = float3(((-(r1.z)) >= 0.0f ? (r1.x) : (c12.x)), ((-(r1.z)) >= 0.0f ? (r1.y) : (c12.x)), ((-(r1.z)) >= 0.0f ? (r1.w) : (c12.x)));
    r1.w = abs(c[11].w);
    r1.w = frac(r1.w);
    r2.y = ((c[11].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2.x = c12.x;
    r2 = tex2D(s2, r2.xy);
    r1.w = saturate((r2.x) * (c[25].x));
    r2.xyz = lerp(r1.xyz, r0.xyz, r1.www);
    r0.x = (r0.w) * (c[28].x);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r0.y = (c[32].x) + (-(v3.y));
    r0.y = (r0.y) + (c0.w);
    r0.x = (r0.x) + (r0.y);
    r0.y = frac(abs(r0.x));
    r0.x = ((r0.x) >= 0.0f ? (r0.y) : (-(r0.y)));
    r1.x = pow(abs(r0.x), c[31].x);
    r0.w = c0.w;
    r0.x = (r1.x) * (-(c[30].x)) + (r0.w);
    r1.xyz = lerp(c[29].xyz, r2.xyz, r0.xxx);
    r0.xyz = (c[6].xyz) + (-(v1.xyz));
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r2.x = 1.0f / (r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r2.y = (r2.x) * (r2.x);
    r0.w = dot(c[9].yz, r2.xy) + (c[9].x);
    r2.xy = saturate((r2.xx) * (c[10].xy) + (c[10].zw));
    r2.zw = (r2.xy) * (r2.xy);
    r2.xy = (r2.xy) * (c0.xx) + (c0.yy);
    r2.xy = (r2.zw) * (r2.xy);
    r0.w = (r0.w) * (r2.x);
    r0.w = (r2.y) * (r0.w);
    r2.xyz = normalize(v2.xyz);
    r1.w = max(abs(r2.y), abs(r2.z));
    r3.x = max(abs(r2.x), r1.w);
    r1.w = 1.0f / (r3.x);
    r3.xyz = (r2.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r1.www) + (v4.xyz);
    r3 = tex3D(s11, r3.xyz);
    r0.w = (r0.w) * (r3.w);
    r3.xyz = (r0.www) * (c[7].xyz);
    r3.xyz = (r3.xyz) * (c[8].yyy);
    r0.w = dot(-(r0.xyz), r2.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r2.xyz) * (-(r0.www)) + (-(r0.xyz));
    r5.xyz = normalize(v1.xyz);
    r0.w = saturate(dot(r4.xyz, -(r5.xyz)));
    r0.x = dot(r0.xyz, r5.xyz);
    r0.x = saturate((r0.x) * (c0.z) + (c0.z));
    r0.y = (r0.x) * (c1.x) + (c1.y);
    r0.x = (r0.x) + (c0.w);
    r1.w = pow(abs(r0.w), r0.y);
    r0.yzw = (r3.xyz) * (r1.www);
    r0.xyz = (r0.xxx) * (r0.yzw);
    r0.w = dot(r5.xyz, r2.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r2.xyz) * (-(r0.www)) + (r5.xyz);
    r2 = texCUBE(s15, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c1.zzz);
    r3 = tex3D(s11, v4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c[24].xxx);
    r2.xyz = (r2.xyz) * (c1.www);
    r0.xyz = (r0.xyz) * (c2.xyz) + (r2.xyz);
    r0.xyz = (r1.xyz) + (r0.xyz);
    r0.w = c0.w;
    r1.x = dot(r0, c[21]);
    r1.y = dot(r0, c[22]);
    r1.z = dot(r0, c[23]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.w;

    return oC0;
}
