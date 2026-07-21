// Mechanically reconstructed from 0xE8AC101A.ps_3_0.cso.
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
    r1.xyz = (r1.xyz) * (c[6].yyy);
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
    r0.xyz = (r0.xyz) * (-(r0.www)) + (r3.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c4.www);
    r2 = tex3D(s11, v4.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (c[20].xxx);
    r0.xyz = (r0.xyz) * (c12.xxx);
    r0.xyz = (r1.xyz) * (c12.yzw) + (r0.xyz);
    r0.w = c[7].w;
    r1.x = (r0.w) * (c13.x);
    r1.x = frac(r1.x);
    r1.x = (r0.w) * (c13.x) + (-(r1.x));
    r1.y = (r1.x) * (c13.y) + (v3.y);
    r1.x = c13.z;
    r1 = tex2D(s3, r1.xy);
    r1.x = (r1.x) * (-(c13.w)) + (v3.x);
    r1.x = (r1.x) * (c14.x) + (-(v3.x));
    r1.x = (c[23].x) * (r1.x) + (v3.x);
    r1.z = frac(abs(v3.y));
    r1.y = ((v3.y) >= 0.0f ? (r1.z) : (-(r1.z)));
    r1.z = ((r1.x) >= 0.0f ? (c3.y) : (c3.x));
    r1.w = (-(r1.x)) + (c3.x);
    r1.w = ((r1.w) >= 0.0f ? (c3.y) : (c3.x));
    r1.z = (r1.z) + (r1.w);
    r1.x = saturate(r1.x);
    r2 = tex2D(s4, r1.xy);
    r1.xyw = (r2.xyz) * (r2.xyz);
    r1.xyz = float3(((-(r1.z)) >= 0.0f ? (r1.x) : (c3.y)), ((-(r1.z)) >= 0.0f ? (r1.y) : (c3.y)), ((-(r1.z)) >= 0.0f ? (r1.w) : (c3.y)));
    r1.w = abs(c[7].w);
    r1.w = frac(r1.w);
    r2.y = ((c[7].w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r2.x = c3.y;
    r2 = tex2D(s3, r2.xy);
    r1.w = saturate((r2.x) * (c[21].x));
    r2.x = 1.0f / (c[22].x);
    r2.y = 1.0f / (c[22].y);
    r2.z = dot(r0.wwww, c15);
    r3.x = frac(r2.z);
    r3.w = c[7].w;
    r2.z = dot(r3.xwww, c15);
    r3.y = frac(r2.z);
    r2.z = dot(r3.xyww, c15);
    r3.z = frac(r2.z);
    r2.z = dot(r3, c15);
    r3.w = frac(r2.z);
    r2.z = dot(r3, c15);
    r3.x = frac(r2.z);
    r2.z = dot(r3, c15);
    r3.y = frac(r2.z);
    r2.xy = (v3.xy) * (r2.xy) + (r3.xy);
    r2 = tex2D(s2, r2.xy);
    r3.xyz = lerp(r1.xyz, r2.xyz, r1.www);
    r1.x = (c[28].x) + (-(v3.y));
    r1.x = (r1.x) + (c3.x);
    r0.w = (r0.w) * (c[24].x);
    r1.y = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.y) : (-(r1.y)));
    r0.w = (r1.x) + (r0.w);
    r1.x = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.x) : (-(r1.x)));
    r1.x = pow(abs(r0.w), c[27].x);
    r2.x = c3.x;
    r0.w = (r1.x) * (-(c[26].x)) + (r2.x);
    r1.xyz = lerp(c[25].xyz, r3.xyz, r0.www);
    r0.xyz = (r0.xyz) + (r1.xyz);
    r0.w = c3.x;
    r1.x = dot(r0, c[9]);
    r1.y = dot(r0, c[10]);
    r1.z = dot(r0, c[11]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.x;

    return oC0;
}
