// Mechanically reconstructed from 0x628D405B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
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
    float4 v4 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.0f, 0.5f, 31.875f, 15.0f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c12 = float4(0.5f, -28.0f, 30.0f, 8.0f);
    const float4 c13 = float4(0.38647899f, 0.392856985f, 0.364796013f, 0.00749999983f);
    const float4 c14 = float4(4.0f, 2.0f, 0.0399999991f, 0.782500029f);
    const float4 c15 = float4(1.00750005f, 0.0f, 0.0f, 0.0f);
    const float4 c16 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    if ((c4.x) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c4.xxxy) + (c4.zzzx);
        r1 = (r1) * (c4.xxxy);
        r2 = (r1) + (c4.wwyy);
        r2 = tex2Dlod(s1, r2);
        r3 = (r1) + (-(c4.wwyy));
        r3 = tex2Dlod(s1, r3);
        r4 = (r1) + (c1.xyzz);
        r4 = tex2Dlod(s1, r4);
        r1 = (r1) + (-(c1.xyzz));
        r1 = tex2Dlod(s1, r1);
        r2.y = r3.x;
        r2.z = r4.x;
        r2.w = r1.x;
        r0.w = dot(r2, c1.wwww);
        if ((c3.x) < (v4.w))
        {
            r1.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.zw = (v4.zx) * (c4.xy) + (c4.zx);
            r1 = (r1) * (c4.xxxy);
            r2 = (r1) + (c4.wwyy);
            r2 = tex2Dlod(s1, r2);
            r3 = (r1) + (-(c4.wwyy));
            r3 = tex2Dlod(s1, r3);
            r4 = (r1) + (c1.xyzz);
            r4 = tex2Dlod(s1, r4);
            r1 = (r1) + (-(c1.xyzz));
            r1 = tex2Dlod(s1, r1);
            r2.y = r3.x;
            r2.z = r4.x;
            r2.w = r1.x;
            r1.x = dot(r2, c1.wwww);
            r1.y = (v4.w) * (c3.y) + (c3.z);
            r2.x = lerp(r0.w, r1.x, r1.y);
            r0.w = r2.x;
        }
    }
    else
    {
        r1 = tex2D(s12, v3.zw);
        r1.x = (c3.w) + (v4.w);
        r1.x = ((r1.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r1.x) != (-(r1.x)))
        {
            r2.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v4.zz) * (c4.xy) + (c4.zx);
            r2 = (r2) * (c4.xxxy);
            r3 = (r2) + (c4.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c4.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r1.x = dot(r3, c1.wwww);
            r1.z = saturate((c3.z) + (v4.w));
            r0.w = lerp(r1.x, r1.y, r1.z);
        }
        else
        {
            r0.w = r1.y;
        }
    }
    r1.xyz = (r0.www) * (c[19].xyz);
    r2.xyz = normalize(c[17].xyz);
    r1.xyz = (r1.xyz) * (c[5].yyy);
    r3.xyz = normalize(v1.xyz);
    r0.w = dot(-(r2.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r0.xyz) * (-(r0.www)) + (-(r2.xyz));
    r0.w = dot(r2.xyz, r3.xyz);
    r0.w = saturate((r0.w) * (c12.x) + (c12.x));
    r1.w = (r0.w) * (c12.y) + (c12.z);
    r0.w = (r0.w) + (c4.x);
    r2.x = saturate(dot(r4.xyz, -(r3.xyz)));
    r3.w = pow(abs(r2.x), r1.w);
    r1.xyz = (r1.xyz) * (r3.www);
    r1.xyz = (r0.www) * (r1.xyz);
    r0.w = dot(r3.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r3.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c12.www);
    r2 = tex2D(s14, v3.zw);
    r2.yz = (c0.xy) * (v3.zw);
    r3 = tex2D(s13, r2.yz);
    r0.w = (r2.x) * (c0.z);
    r2.yz = (r3.xz) * (r0.ww);
    r3.xw = (r0.xz) * (r2.yz);
    r0.x = (r2.x) * (c0.z) + (-(r2.y));
    r0.x = (r3.z) * (-(r0.w)) + (r0.x);
    r3.y = (r0.y) * (r0.x);
    r0.xyz = (r3.xyw) * (c[11].xxx);
    r0.xyz = (r0.xyz) * (c14.xyx);
    r0.xyz = (r1.xyz) * (c13.xyz) + (r0.xyz);
    r0.w = c[6].w;
    r1.x = (r0.w) * (c0.w);
    r1.x = frac(r1.x);
    r1.x = (r0.w) * (c0.w) + (-(r1.x));
    r1.y = (r1.x) * (c14.z) + (v3.y);
    r1.x = c14.w;
    r1 = tex2D(s3, r1.xy);
    r1.x = (r1.x) * (-(c13.w)) + (v3.x);
    r1.x = (r1.x) * (c15.x) + (-(v3.x));
    r1.x = (c[22].x) * (r1.x) + (v3.x);
    r1.z = frac(abs(v3.y));
    r1.y = ((v3.y) >= 0.0f ? (r1.z) : (-(r1.z)));
    r1.z = ((r1.x) >= 0.0f ? (c4.y) : (c4.x));
    r1.w = (-(r1.x)) + (c4.x);
    r1.w = ((r1.w) >= 0.0f ? (c4.y) : (c4.x));
    r1.z = (r1.z) + (r1.w);
    r1.x = saturate(r1.x);
    r2 = tex2D(s4, r1.xy);
    r1.xyw = (r2.xyz) * (r2.xyz);
    r1.xyz = float3(((-(r1.z)) >= 0.0f ? (r1.x) : (c4.y)), ((-(r1.z)) >= 0.0f ? (r1.y) : (c4.y)), ((-(r1.z)) >= 0.0f ? (r1.w) : (c4.y)));
    r1.w = abs(c[6].w);
    r1.w = frac(r1.w);
    r2.y = ((c[6].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2.x = c4.y;
    r2 = tex2D(s3, r2.xy);
    r1.w = saturate((r2.x) * (c[20].x));
    r2.x = 1.0f / (c[21].x);
    r2.y = 1.0f / (c[21].y);
    r2.z = dot(r0.wwww, c16);
    r3.x = frac(r2.z);
    r3.w = c[6].w;
    r2.z = dot(r3.xwww, c16);
    r3.y = frac(r2.z);
    r2.z = dot(r3.xyww, c16);
    r3.z = frac(r2.z);
    r2.z = dot(r3, c16);
    r3.w = frac(r2.z);
    r2.z = dot(r3, c16);
    r3.x = frac(r2.z);
    r2.z = dot(r3, c16);
    r3.y = frac(r2.z);
    r2.xy = (v3.xy) * (r2.xy) + (r3.xy);
    r2 = tex2D(s2, r2.xy);
    r3.xyz = lerp(r1.xyz, r2.xyz, r1.www);
    r1.x = (c[27].x) + (-(v3.y));
    r1.x = (r1.x) + (c4.x);
    r0.w = (r0.w) * (c[23].x);
    r1.y = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.y) : (-(r1.y)));
    r0.w = (r1.x) + (r0.w);
    r1.x = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.x) : (-(r1.x)));
    r1.x = pow(abs(r0.w), c[26].x);
    r2.x = c4.x;
    r0.w = (r1.x) * (-(c[25].x)) + (r2.x);
    r1.xyz = lerp(c[24].xyz, r3.xyz, r0.www);
    r0.xyz = (r0.xyz) + (r1.xyz);
    r0.w = c4.x;
    r1.x = dot(r0, c[8]);
    r1.y = dot(r0, c[9]);
    r1.z = dot(r0, c[10]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.x;

    return oC0;
}
