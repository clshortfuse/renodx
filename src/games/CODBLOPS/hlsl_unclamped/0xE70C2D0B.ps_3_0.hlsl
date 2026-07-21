// Mechanically reconstructed from 0xE70C2D0B.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
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
    const float4 c12 = float4(0.5f, -28.0f, 30.0f, 0.136841998f);
    const float4 c13 = float4(0.38647899f, 0.392856985f, 0.364796013f, 10.0f);
    const float4 c14 = float4(9.0f, 15.0f, 4.0f, 11.0f);
    const float4 c15 = float4(9.99999994e-09f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.xy = (v3.xy) * (c[27].xy) + (c[27].zw);
    r1.z = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.z);
    r2.yzw = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r2.xyz = (r2.yzw) * (r0.www) + (v4.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c0.x) >= (v5.w))
    {
        r3 = (v5.xyzx) * (c0.xxxy) + (c0.yyyx);
        r3 = (r3) * (c0.xxxy);
        r4 = (r3) + (c0.zzyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c0.zzyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c1.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c1.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r0.w = dot(r4, c0.wwww);
        if ((c1.w) < (v5.w))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zx) * (c0.xy) + (c0.yx);
            r3 = (r3) * (c0.xxxy);
            r4 = (r3) + (c0.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c0.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r1.z = dot(r4, c0.wwww);
            r1.w = (v5.w) * (c3.x) + (c3.y);
            r3.x = lerp(r0.w, r1.z, r1.w);
            r0.w = r3.x;
        }
    }
    else
    {
        r1.z = (c3.z) + (v5.w);
        r1.z = ((r1.z) >= 0.0f ? (c0.y) : (c0.x));
        if ((r1.z) != (-(r1.z)))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zz) * (c0.xy) + (c0.yx);
            r3 = (r3) * (c0.xxxy);
            r4 = (r3) + (c0.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c0.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r1.z = dot(r4, c0.wwww);
            r1.w = saturate((c3.y) + (v5.w));
            r0.w = lerp(r1.z, r2.w, r1.w);
        }
        else
        {
            r0.w = r2.w;
        }
    }
    r3.xyz = (r0.www) * (c[18].xyz);
    r4.xyz = (r0.www) * (c[19].xyz);
    r5.xyz = normalize(c[17].xyz);
    r3.xyz = (r3.xyz) * (c[21].xxx);
    r0.w = saturate(dot(r0.xyz, r5.xyz));
    r3.xyz = (r3.xyz) * (r0.www);
    r6.x = c[26].x;
    r7 = (-(r6.xxxx)) + (c4);
    r6.yzw = float3(((-abs(r7.x)) >= 0.0f ? (r3.x) : (c0.y)), ((-abs(r7.x)) >= 0.0f ? (r3.y) : (c0.y)), ((-abs(r7.x)) >= 0.0f ? (r3.z) : (c0.y)));
    r8.x = log2(abs(r3.x));
    r8.y = log2(abs(r3.y));
    r8.z = log2(abs(r3.z));
    r3.xyz = (r8.xyz) * (c1.www);
    r8.x = exp2(r3.x);
    r8.y = exp2(r3.y);
    r8.z = exp2(r3.z);
    r3.xyz = float3(((-abs(r7.y)) >= 0.0f ? (r8.x) : (r6.y)), ((-abs(r7.y)) >= 0.0f ? (r8.y) : (r6.z)), ((-abs(r7.y)) >= 0.0f ? (r8.z) : (r6.w)));
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c3.www) + (r8.xyz);
    r3.xyz = float3(((-abs(r7.z)) >= 0.0f ? (r2.x) : (r3.x)), ((-abs(r7.z)) >= 0.0f ? (r2.y) : (r3.y)), ((-abs(r7.z)) >= 0.0f ? (r2.z) : (r3.z)));
    r4.xyz = (r4.xyz) * (c[21].yyy);
    r7.xyz = normalize(v1.xyz);
    r0.w = dot(-(r5.xyz), r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r6.yzw = (r0.xyz) * (-(r0.www)) + (-(r5.xyz));
    r0.w = dot(r5.xyz, r7.xyz);
    r0.w = saturate((r0.w) * (c12.x) + (c12.x));
    r1.z = (r0.w) * (c12.y) + (c12.z);
    r0.w = (r0.w) + (c0.x);
    r1.w = saturate(dot(r6.yzw, -(r7.xyz)));
    r2.w = pow(abs(r1.w), r1.z);
    r4.xyz = (r4.xyz) * (r2.www);
    r4.xyz = (r0.www) * (r4.xyz);
    r3.xyz = float3(((-abs(r7.w)) >= 0.0f ? (r4.x) : (r3.x)), ((-abs(r7.w)) >= 0.0f ? (r4.y) : (r3.y)), ((-abs(r7.w)) >= 0.0f ? (r4.z) : (r3.z)));
    r5.xyz = (r4.xyz) * (c13.xyz);
    r8 = (-(r6.xxxx)) + (c14);
    r3.xyz = float3(((-abs(r8.x)) >= 0.0f ? (r5.x) : (r3.x)), ((-abs(r8.x)) >= 0.0f ? (r5.y) : (r3.y)), ((-abs(r8.x)) >= 0.0f ? (r5.z) : (r3.z)));
    r0.w = dot(r7.xyz, r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.xyz = (r0.xyz) * (-(r0.www)) + (r7.xyz);
    r5 = texCUBE(s15, r5.xyz);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r5.xyz) * (c4.zzz);
    r7 = tex3D(s11, v4.xyz);
    r6.yzw = (r7.xyz) * (r7.xyz);
    r5.xyz = (r5.xyz) * (r6.yzw);
    r5.xyz = (r5.xyz) * (c3.www);
    r3.xyz = float3(((-abs(r8.y)) >= 0.0f ? (r5.x) : (r3.x)), ((-abs(r8.y)) >= 0.0f ? (r5.y) : (r3.y)), ((-abs(r8.y)) >= 0.0f ? (r5.z) : (r3.z)));
    r5.xyz = (r5.xyz) * (c[28].xxx);
    r3.xyz = float3(((-abs(r8.z)) >= 0.0f ? (r5.x) : (r3.x)), ((-abs(r8.z)) >= 0.0f ? (r5.y) : (r3.y)), ((-abs(r8.z)) >= 0.0f ? (r5.z) : (r3.z)));
    r4.xyz = (r4.xyz) * (c13.xyz) + (r5.xyz);
    r3.xyz = float3(((-abs(r8.w)) >= 0.0f ? (r4.x) : (r3.x)), ((-abs(r8.w)) >= 0.0f ? (r4.y) : (r3.y)), ((-abs(r8.w)) >= 0.0f ? (r4.z) : (r3.z)));
    r4.xyz = (r4.xyz) * (c12.www);
    r1 = tex2D(s2, r1.xy);
    r1.xyz = (r2.xyz) * (r1.xyz) + (r4.xyz);
    r2.xyz = max(r1.xyz, c0.yyy);
    r0.w = (-(r6.x)) + (c13.w);
    r1.xyz = float3(((-abs(r0.w)) >= 0.0f ? (r2.x) : (r3.x)), ((-abs(r0.w)) >= 0.0f ? (r2.y) : (r3.y)), ((-abs(r0.w)) >= 0.0f ? (r2.z) : (r3.z)));
    r0.w = abs(c[26].x);
    r1.xyz = float3(((-(r0.w)) >= 0.0f ? (r2.x) : (r1.x)), ((-(r0.w)) >= 0.0f ? (r2.y) : (r1.y)), ((-(r0.w)) >= 0.0f ? (r2.z) : (r1.z)));
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
    r7.x = c0.x;
    r6 = saturate((r6) * (c[9]) + (r7.xxxx));
    r4 = (r0.yyyy) * (r4);
    r3 = (r3) * (r0.xxxx) + (r4);
    r0 = saturate((r5) * (r0.zzzz) + (r3));
    r0 = (r6) * (r0);
    r3.x = dot(c[10], r0);
    r3.y = dot(c[11], r0);
    r3.z = dot(c[20], r0);
    r0.xyz = (r2.xyz) * (r3.xyz) + (r2.xyz);
    r1.xyz = (r0.xyz) * (c15.xxx) + (r1.xyz);
    r0.xyz = float3(((c[26].x) >= 0.0f ? (r1.x) : (r0.x)), ((c[26].x) >= 0.0f ? (r1.y) : (r0.y)), ((c[26].x) >= 0.0f ? (r1.z) : (r0.z)));
    r0.w = c0.x;
    r1.x = dot(r0, c[23]);
    r1.y = dot(r0, c[24]);
    r1.z = dot(r0, c[25]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}
