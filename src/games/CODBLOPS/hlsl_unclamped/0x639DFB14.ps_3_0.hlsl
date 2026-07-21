// Mechanically reconstructed from 0x639DFB14.ps_3_0.cso.
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
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c4 = float4(0.5f, -28.0f, 30.0f, 8.0f);
    const float4 c12 = float4(31.875f, 0.38647899f, 0.392856985f, 0.364796013f);
    const float4 c13 = float4(15.0f, 0.0399999991f, 0.782500029f, 0.00749999983f);
    const float4 c14 = float4(1.00750005f, 0.0f, 0.0f, 0.0f);
    const float4 c15 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    if ((c3.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c3.xxxy) + (c3.zzzx);
        r2 = (r2) * (c3.xxxy);
        r3 = (r2) + (c3.wwyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c3.wwyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c0.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c0.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r0.w = dot(r3, c0.wwww);
        if ((c1.x) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c3.xy) + (c3.zx);
            r2 = (r2) * (c3.xxxy);
            r3 = (r2) + (c3.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c3.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r1.x = dot(r3, c0.wwww);
            r1.y = (v5.w) * (c1.y) + (c1.z);
            r2.x = lerp(r0.w, r1.x, r1.y);
            r0.w = r2.x;
        }
    }
    else
    {
        r1.x = (c1.w) + (v5.w);
        r1.x = ((r1.x) >= 0.0f ? (c3.y) : (c3.x));
        if ((r1.x) != (-(r1.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c3.xy) + (c3.zx);
            r2 = (r2) * (c3.xxxy);
            r3 = (r2) + (c3.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c3.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r1.x = dot(r3, c0.wwww);
            r1.y = saturate((c1.z) + (v5.w));
            r0.w = lerp(r1.x, r1.w, r1.y);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r1.xyz = (r0.www) * (c[19].xyz);
    r2.xyz = normalize(c[17].xyz);
    r1.xyz = (r1.xyz) * (c[21].yyy);
    r3.xyz = normalize(v1.xyz);
    r0.w = dot(-(r2.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r0.xyz) * (-(r0.www)) + (-(r2.xyz));
    r0.w = dot(r2.xyz, r3.xyz);
    r0.w = saturate((r0.w) * (c4.x) + (c4.x));
    r1.w = (r0.w) * (c4.y) + (c4.z);
    r0.w = (r0.w) + (c3.x);
    r2.x = saturate(dot(r4.xyz, -(r3.xyz)));
    r3.w = pow(abs(r2.x), r1.w);
    r1.xyz = (r1.xyz) * (r3.www);
    r1.xyz = (r0.www) * (r1.xyz);
    r0.w = dot(r3.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r0.xyz) * (-(r0.www)) + (r3.xyz);
    r2 = texCUBE(s15, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c4.www);
    r3 = tex3D(s11, v4.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r2.xyz) * (c[27].xxx);
    r2.xyz = (r2.xyz) * (c12.xxx);
    r1.xyz = (r1.xyz) * (c12.yzw) + (r2.xyz);
    r0.w = c[22].w;
    r1.w = (r0.w) * (c13.x);
    r1.w = frac(r1.w);
    r1.w = (r0.w) * (c13.x) + (-(r1.w));
    r2.y = (r1.w) * (c13.y) + (v3.y);
    r2.x = c13.z;
    r2 = tex2D(s3, r2.xy);
    r1.w = (r2.x) * (-(c13.w)) + (v3.x);
    r1.w = (r1.w) * (c14.x) + (-(v3.x));
    r2.x = (c[30].x) * (r1.w) + (v3.x);
    r1.w = frac(abs(v3.y));
    r2.y = ((v3.y) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = ((r2.x) >= 0.0f ? (c3.y) : (c3.x));
    r2.z = (-(r2.x)) + (c3.x);
    r2.z = ((r2.z) >= 0.0f ? (c3.y) : (c3.x));
    r1.w = (r1.w) + (r2.z);
    r2.x = saturate(r2.x);
    r2 = tex2D(s4, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = float3(((-(r1.w)) >= 0.0f ? (r2.x) : (c3.y)), ((-(r1.w)) >= 0.0f ? (r2.y) : (c3.y)), ((-(r1.w)) >= 0.0f ? (r2.z) : (c3.y)));
    r1.w = abs(c[22].w);
    r1.w = frac(r1.w);
    r3.y = ((c[22].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r3.x = c3.y;
    r3 = tex2D(s3, r3.xy);
    r1.w = saturate((r3.x) * (c[28].x));
    r3.x = 1.0f / (c[29].x);
    r3.y = 1.0f / (c[29].y);
    r2.w = dot(r0.wwww, c15);
    r4.x = frac(r2.w);
    r4.w = c[22].w;
    r2.w = dot(r4.xwww, c15);
    r4.y = frac(r2.w);
    r2.w = dot(r4.xyww, c15);
    r4.z = frac(r2.w);
    r2.w = dot(r4, c15);
    r4.w = frac(r2.w);
    r2.w = dot(r4, c15);
    r4.x = frac(r2.w);
    r2.w = dot(r4, c15);
    r4.y = frac(r2.w);
    r3.xy = (v3.xy) * (r3.xy) + (r4.xy);
    r3 = tex2D(s2, r3.xy);
    r4.xyz = lerp(r2.xyz, r3.xyz, r1.www);
    r1.w = (c[35].x) + (-(v3.y));
    r1.w = (r1.w) + (c3.x);
    r0.w = (r0.w) * (c[31].x);
    r2.x = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r2.x) : (-(r2.x)));
    r0.w = (r1.w) + (r0.w);
    r1.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r1.w = pow(abs(r0.w), c[34].x);
    r2.x = c3.x;
    r0.w = (r1.w) * (-(c[33].x)) + (r2.x);
    r2.yzw = lerp(c[32].xyz, r4.xyz, r0.www);
    r1.xyz = (r1.xyz) + (r2.yzw);
    r3 = (c[6]) + (-(v1.xxxx));
    r4 = (c[7]) + (-(v1.yyyy));
    r5 = (c[8]) + (-(v1.zzzz));
    r6 = (r4) * (r4);
    r6 = (r3) * (r3) + (r6);
    r6 = (r5) * (r5) + (r6);
    r7.x = rsqrt(r6.x);
    r7.y = rsqrt(r6.y);
    r7.z = rsqrt(r6.z);
    r7.w = rsqrt(r6.w);
    r3 = (r3) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r7);
    r2 = saturate((r6) * (c[9]) + (r2.xxxx));
    r4 = (r0.yyyy) * (r4);
    r3 = (r3) * (r0.xxxx) + (r4);
    r0 = saturate((r5) * (r0.zzzz) + (r3));
    r0 = (r2) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c3.x;
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r1.z = dot(r0, c[26]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
