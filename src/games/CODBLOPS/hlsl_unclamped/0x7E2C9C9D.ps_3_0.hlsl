// Mechanically reconstructed from 0x7E2C9C9D.ps_3_0.cso.
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
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);
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
    const float4 c0 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c3 = float4(4.0f, -3.0f, -4.0f, 31.875f);
    const float4 c4 = float4(6.0f, 13.0f, 8.0f, 12.0f);
    const float4 c12 = float4(0.5f, -28.0f, 30.0f, 24.0f);
    const float4 c13 = float4(0.38647899f, 0.392856985f, 0.364796013f, 0.0166666675f);
    const float4 c14 = float4(9.0f, 14.0f, 4.0f, 11.0f);
    const float4 c15 = float4(0.419999987f, -0.589999974f, -0.5f, 9.99999994e-09f);
    const float4 c16 = float4(1.22077894f, 2.0f, 0.857142985f, 0.0f);
    const float4 c38 = float4(30.0f, 10.0f, 0.0f, 0.0f);
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
    if ((c0.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c0.xxxy) + (c0.yyyx);
        r2 = (r2) * (c0.xxxy);
        r3 = (r2) + (c0.zzyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c0.zzyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c1.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c1.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r0.w = dot(r3, c0.wwww);
        if ((c1.w) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c0.xy) + (c0.yx);
            r2 = (r2) * (c0.xxxy);
            r3 = (r2) + (c0.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c0.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c0.wwww);
            r2.y = (v5.w) * (c3.x) + (c3.y);
            r3.x = lerp(r0.w, r2.x, r2.y);
            r0.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.z) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c0.y) : (c0.x));
        if ((r2.x) != (-(r2.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c0.xy) + (c0.yx);
            r2 = (r2) * (c0.xxxy);
            r3 = (r2) + (c0.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c0.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c0.wwww);
            r2.y = saturate((c3.y) + (v5.w));
            r0.w = lerp(r2.x, r1.w, r2.y);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r2.xyz = (r0.www) * (c[18].xyz);
    r3.xyz = (r0.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r2.xyz = (r2.xyz) * (c[21].xxx);
    r0.w = saturate(dot(r0.xyz, r4.xyz));
    r2.xyz = (r2.xyz) * (r0.www);
    r5.x = c[27].x;
    r6 = (-(r5.xxxx)) + (c4);
    r5.yzw = float3(((-abs(r6.x)) >= 0.0f ? (r2.x) : (c0.y)), ((-abs(r6.x)) >= 0.0f ? (r2.y) : (c0.y)), ((-abs(r6.x)) >= 0.0f ? (r2.z) : (c0.y)));
    r7.x = log2(abs(r2.x));
    r7.y = log2(abs(r2.y));
    r7.z = log2(abs(r2.z));
    r2.xyz = (r7.xyz) * (c1.www);
    r7.x = exp2(r2.x);
    r7.y = exp2(r2.y);
    r7.z = exp2(r2.z);
    r2.xyz = float3(((-abs(r6.y)) >= 0.0f ? (r7.x) : (r5.y)), ((-abs(r6.y)) >= 0.0f ? (r7.y) : (r5.z)), ((-abs(r6.y)) >= 0.0f ? (r7.z) : (r5.w)));
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c3.www) + (r7.xyz);
    r2.xyz = float3(((-abs(r6.z)) >= 0.0f ? (r1.x) : (r2.x)), ((-abs(r6.z)) >= 0.0f ? (r1.y) : (r2.y)), ((-abs(r6.z)) >= 0.0f ? (r1.z) : (r2.z)));
    r3.xyz = (r3.xyz) * (c[21].yyy);
    r6.xyz = normalize(v1.xyz);
    r0.w = dot(-(r4.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.yzw = (r0.xyz) * (-(r0.www)) + (-(r4.xyz));
    r0.w = dot(r4.xyz, r6.xyz);
    r0.w = saturate((r0.w) * (c12.x) + (c12.x));
    r1.w = (r0.w) * (c12.y) + (c12.z);
    r0.w = (r0.w) + (c0.x);
    r2.w = saturate(dot(r5.yzw, -(r6.xyz)));
    r3.w = pow(abs(r2.w), r1.w);
    r3.xyz = (r3.xyz) * (r3.www);
    r3.xyz = (r0.www) * (r3.xyz);
    r2.xyz = float3(((-abs(r6.w)) >= 0.0f ? (r3.x) : (r2.x)), ((-abs(r6.w)) >= 0.0f ? (r3.y) : (r2.y)), ((-abs(r6.w)) >= 0.0f ? (r3.z) : (r2.z)));
    r4.xyz = (r3.xyz) * (c13.xyz);
    r7 = (-(r5.xxxx)) + (c14);
    r2.xyz = float3(((-abs(r7.x)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r7.x)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r7.x)) >= 0.0f ? (r4.z) : (r2.z)));
    r0.w = dot(r6.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r4.xyz = (r0.xyz) * (-(r0.www)) + (r6.xyz);
    r4 = texCUBE(s15, r4.xyz);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c4.zzz);
    r6 = tex3D(s11, v4.xyz);
    r5.yzw = (r6.xyz) * (r6.xyz);
    r4.xyz = (r4.xyz) * (r5.yzw);
    r4.xyz = (r4.xyz) * (c3.www);
    r2.xyz = float3(((-abs(r7.y)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r7.y)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r7.y)) >= 0.0f ? (r4.z) : (r2.z)));
    r4.xyz = (r4.xyz) * (c[28].xxx);
    r2.xyz = float3(((-abs(r7.z)) >= 0.0f ? (r4.x) : (r2.x)), ((-abs(r7.z)) >= 0.0f ? (r4.y) : (r2.y)), ((-abs(r7.z)) >= 0.0f ? (r4.z) : (r2.z)));
    r3.xyz = (r3.xyz) * (c13.xyz) + (r4.xyz);
    r2.xyz = float3(((-abs(r7.w)) >= 0.0f ? (r3.x) : (r2.x)), ((-abs(r7.w)) >= 0.0f ? (r3.y) : (r2.y)), ((-abs(r7.w)) >= 0.0f ? (r3.z) : (r2.z)));
    r4 = tex2D(s6, v3.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r6 = tex2D(s5, v3.xy);
    r5.yzw = (r6.xyz) * (r6.xyz);
    r0.w = c12.w;
    r1.w = (r0.w) * (c[22].w);
    r1.w = frac(r1.w);
    r0.w = (c[22].w) * (r0.w) + (-(r1.w));
    r6.y = (r0.w) * (c13.w);
    r6.x = c15.x;
    r6 = tex2D(s3, r6.xy);
    r7.xy = c[37].xy;
    r6.yz = (-(r7.xy)) + (c[29].xy);
    r6.xy = (r6.xx) * (r6.yz) + (c[37].xy);
    r7.xy = lerp(-(c15.yz), v3.xy, r6.xy);
    r0.w = c[22].w;
    r6.xy = (r0.ww) * (c[36].xy) + (r7.xy);
    r6 = tex2D(s4, r6.xy);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r6.xyz = (r6.xyz) * (c16.xyz);
    r5.yzw = (r5.yzw) * (c[35].xxx) + (r6.xyz);
    r0.w = (r0.w) * (c[33].x);
    r1.w = frac(abs(r0.w));
    r0.w = ((r0.w) >= 0.0f ? (r1.w) : (-(r1.w)));
    r0.w = (-(r0.w)) + (v3.y);
    r6.y = (r0.w) * (c[34].x);
    r6.x = v3.x;
    r6 = tex2D(s2, r6.xy);
    r0.w = pow(abs(r6.y), c[30].x);
    r6.xyz = (r0.www) * (c[32].xyz);
    r5.yzw = (r6.xyz) * (c[31].xxx) + (r5.yzw);
    r6.xy = (-(r5.xx)) + (c38.xy);
    r2.xyz = float3(((-abs(r6.x)) >= 0.0f ? (r5.y) : (r2.x)), ((-abs(r6.x)) >= 0.0f ? (r5.z) : (r2.y)), ((-abs(r6.x)) >= 0.0f ? (r5.w) : (r2.z)));
    r4.xyz = (r4.xyz) * (r5.yzw);
    r1.xyz = (r1.xyz) * (r4.xyz) + (r3.xyz);
    r3.xyz = max(r1.xyz, c0.yyy);
    r1.xyz = float3(((-abs(r6.y)) >= 0.0f ? (r3.x) : (r2.x)), ((-abs(r6.y)) >= 0.0f ? (r3.y) : (r2.y)), ((-abs(r6.y)) >= 0.0f ? (r3.z) : (r2.z)));
    r0.w = abs(c[27].x);
    r1.xyz = float3(((-(r0.w)) >= 0.0f ? (r3.x) : (r1.x)), ((-(r0.w)) >= 0.0f ? (r3.y) : (r1.y)), ((-(r0.w)) >= 0.0f ? (r3.z) : (r1.z)));
    r2 = (c[6]) + (-(v1.xxxx));
    r4 = (c[7]) + (-(v1.yyyy));
    r5 = (c[8]) + (-(v1.zzzz));
    r6 = (r4) * (r4);
    r6 = (r2) * (r2) + (r6);
    r6 = (r5) * (r5) + (r6);
    r7.x = rsqrt(r6.x);
    r7.y = rsqrt(r6.y);
    r7.z = rsqrt(r6.z);
    r7.w = rsqrt(r6.w);
    r2 = (r2) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r7);
    r7.x = c0.x;
    r6 = saturate((r6) * (c[9]) + (r7.xxxx));
    r4 = (r0.yyyy) * (r4);
    r2 = (r2) * (r0.xxxx) + (r4);
    r0 = saturate((r5) * (r0.zzzz) + (r2));
    r0 = (r6) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r3.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.xyz) * (c15.www) + (r1.xyz);
    r0.xyz = float3(((c[27].x) >= 0.0f ? (r1.x) : (r0.x)), ((c[27].x) >= 0.0f ? (r1.y) : (r0.y)), ((c[27].x) >= 0.0f ? (r1.z) : (r0.z)));
    r0.w = c0.x;
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
    oC0.w = c0.x;

    return oC0;
}
