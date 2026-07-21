// Mechanically reconstructed from 0x27A80928.ps_3_0.cso.
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
sampler2D s7 : register(s7);
sampler2D s8 : register(s8);
sampler2D s9 : register(s9);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
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
    const float4 c0 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c1 = float4(4.0f, -3.0f, -4.0f, 0.5f);
    const float4 c3 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(3.14159274f, 0.159154937f, 0.5f, -6.28318548f);
    const float4 c13 = float4(0.5f, -0.5f, 9.99999975e-06f, 1e-15f);
    const float4 c14 = float4(1.44269502f, 0.100000001f, 9.99999997e-07f, 0.600000024f);
    const float4 c15 = float4(3.5f, 1.0f, 2.5f, -2.5f);
    const float4 c16 = float4(2.0f, -1.0f, 6.28318548f, 0.25f);
    const float4 c31 = float4(5.0f, 0.833333313f, 1.5f, 0.0f);
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

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    if ((c3.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c3.xxxy) + (c3.yyyx);
        r2 = (r2) * (c3.xxxy);
        r3 = (r2) + (c3.zzyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c3.zzyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c0.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c0.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r1.w = dot(r3, c3.wwww);
        if ((c0.w) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c3.xy) + (c3.yx);
            r2 = (r2) * (c3.xxxy);
            r3 = (r2) + (c3.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c3.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c3.wwww);
            r2.y = (v5.w) * (c1.x) + (c1.y);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c1.z) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c3.y) : (c3.x));
        if ((r2.x) != (-(r2.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c3.xy) + (c3.yx);
            r2 = (r2) * (c3.xxxy);
            r3 = (r2) + (c3.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c3.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c3.wwww);
            r2.y = saturate((c1.y) + (v5.w));
            r1.w = (r2.y) * (-(r2.x)) + (r2.x);
        }
        else
        {
            r1.w = c3.y;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5 = tex2D(s5, v4.xy);
    r5.xy = (r5.wy) * (c4.xy) + (c4.zw);
    r5.xy = (r5.xy) * (c1.ww) + (c1.ww);
    r5.xy = (r5.xy) * (c16.xx) + (c16.yy);
    r6 = tex2D(s4, v4.xy);
    r5.zw = (r6.wy) * (c4.xy) + (c4.zw);
    r5.zw = (r5.zw) * (c1.ww) + (c1.ww);
    r5.zw = (r5.zw) * (c16.xx) + (c16.yy);
    r6 = tex2D(s2, v4.xy);
    r7.x = c3.x;
    r1.w = (r7.x) + (-(c[22].y));
    r1.w = saturate(r1.w);
    r7.yzw = (r6.xyz) * (c16.zzw);
    r8.x = c16.x;
    r6.zw = (c[21].ww) * (r8.xx) + (r7.yz);
    r2.w = (r6.z) + (c12.x);
    r2.w = (r2.w) * (c12.y) + (c12.z);
    r2.w = frac(r2.w);
    r2.w = (r2.w) * (-(c12.w)) + (-(c12.x));
    r8.x = cos(r2.w);
    r2.w = (r8.x) * (c13.x) + (c13.y);
    r2.w = (r1.w) * (r2.w) + (c3.x);
    r8 = tex2D(s3, v4.xy);
    r7.yz = (r8.wy) * (c4.xy) + (c4.zw);
    r7.yz = (r7.yz) * (c1.ww) + (c1.ww);
    r7.yz = (r7.yz) * (c16.xx) + (c16.yy);
    r3.w = (r6.w) * (c12.y) + (c12.z);
    r3.w = frac(r3.w);
    r3.w = (r3.w) * (-(c12.w)) + (-(c12.x));
    r8.x = cos(r3.w);
    r3.w = (r8.x) * (c1.w) + (c1.w);
    r1.w = (r1.w) * (r3.w);
    r6.zw = (r7.yz) * (r1.ww);
    r5.zw = (r2.ww) * (r5.zw) + (r6.zw);
    r6.zw = lerp(r5.xy, r5.zw, c[22].zz);
    r1.xyz = (r1.xyz) * (r6.www);
    r1.xyz = (r6.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.z = c[22].z;
    r0.x = c[29].x;
    r0.x = saturate((r1.z) * (r0.x) + (c[30].x));
    r1.x = lerp(r6.x, r6.y, c1.w);
    r1.yzw = (r2.xyz) * (c[20].xxx);
    r2.x = saturate(dot(r5.xyz, r4.xyz));
    r1.yzw = (r1.yzw) * (r2.xxx);
    r2.yzw = (r3.xyz) * (c[20].yyy);
    r3 = tex2D(s8, v4.xy);
    r4.w = max(c13.z, r3.x);
    r3.x = dot(-(v1.xyz), -(v1.xyz));
    r3.x = rsqrt(r3.x);
    r3.yzw = (r3.xxx) * (-(v1.xyz));
    r5.w = saturate(dot(r5.xyz, r3.yzw));
    r4.w = (r4.w) * (r4.w);
    r4.w = 1.0f / (r4.w);
    r4.xyz = (-(v1.xyz)) * (r3.xxx) + (r4.xyz);
    r6.xyz = normalize(r4.xyz);
    r3.x = saturate(dot(r5.xyz, r6.xyz));
    r4.x = (r3.x) * (r3.x) + (c13.w);
    r4.x = 1.0f / (r4.x);
    r4.y = (-(r4.x)) + (c3.x);
    r4.y = (r4.w) * (r4.y);
    r4.y = (r4.y) * (c14.x);
    r4.y = exp2(r4.y);
    r4.x = (r4.x) * (r4.x);
    r4.x = (r4.y) * (r4.x);
    r3.x = (r3.x) + (r3.x);
    r4.y = 1.0f / (r5.w);
    r3.x = (r3.x) * (r4.y);
    r4.y = min(r5.w, r2.x);
    r3.x = saturate((r3.x) * (r4.y));
    r2.x = (r2.x) * (r3.x);
    r2.x = rsqrt(r2.x);
    r2.x = 1.0f / (r2.x);
    r2.x = (r4.x) * (r2.x);
    r2.xyz = (r2.yzw) * (r2.xxx);
    r2.w = saturate(dot(r0.yzw, r3.yzw));
    r2.w = (r5.w) + (r2.w);
    r2.w = (r2.w) * (c1.w);
    r3.x = max(c14.y, r2.w);
    r2.w = 1.0f / (r3.x);
    r2.w = rsqrt(r2.w);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r2.xyz) * (r2.www);
    r2.w = (r4.w) * (c3.w);
    r2.xyz = (r2.xyz) * (r2.www);
    r3.xyz = normalize(v1.xyz);
    r2.w = dot(r3.xyz, r5.xyz);
    r3.y = (r2.w) + (r2.w);
    r3.x = (r5.x) * (-(r3.y)) + (r3.x);
    r3.x = (r3.x) * (c[27].x);
    r3.x = (r3.x) * (c14.z);
    r4 = tex2D(s7, v4.xy);
    r2.w = saturate(r2.w);
    r2.w = (-(r2.w)) + (c3.x);
    r3.y = (r2.w) * (r2.w);
    r2.w = (r2.w) * (r3.y);
    r3.y = (r4.w) * (c15.x) + (c15.y);
    r3.y = 1.0f / (r3.y);
    r2.w = (r2.w) * (r3.y);
    r3.yzw = lerp(r4.xyz, c3.xxx, r2.www);
    r3.xyz = (r3.xxx) * (r3.yzw);
    r2.xyz = (r2.xyz) * (c3.www) + (r3.xyz);
    r3.xyz = (-(r2.xyz)) + (c3.xxx);
    r2.xyz = (c[22].xxx) * (r3.xyz) + (r2.xyz);
    r3 = tex2D(s9, v4.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4.xyz = (r4.xyz) * (r2.xyz);
    r3.xyz = (r1.yzw) * (r3.xyz) + (r4.xyz);
    r4.xyz = max(r3.xyz, c3.yyy);
    r3 = tex2D(s6, v4.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.xyz = (r7.www) * (r2.xyz);
    r1.yzw = (r1.yzw) * (r3.xyz) + (r2.xyz);
    r2.xyz = max(r1.yzw, c3.yyy);
    r1.yzw = lerp(r4.xyz, r2.xyz, c14.www);
    r1.x = (r1.x) * (c15.z) + (c15.w);
    r0.x = (r0.x) * (c31.x) + (r1.x);
    r1.x = saturate((r0.x) * (c31.y));
    r1.x = (r1.x) * (r1.x);
    r1.yzw = (r1.yzw) * (c[28].xyz) + (-(r4.xyz));
    r1.xyz = (r1.xxx) * (r1.yzw) + (r4.xyz);
    r0.x = (r0.x) + (-(c14.w));
    r0.x = saturate((r0.x) * (c31.z));
    r3.xyz = lerp(r1.xyz, r2.xyz, r0.xxx);
    r1 = (c[5]) + (-(v1.xxxx));
    r2 = (c[6]) + (-(v1.yyyy));
    r4 = (c[7]) + (-(v1.zzzz));
    r5 = (r2) * (r2);
    r5 = (r1) * (r1) + (r5);
    r5 = (r4) * (r4) + (r5);
    r6.x = rsqrt(r5.x);
    r6.y = rsqrt(r5.y);
    r6.z = rsqrt(r5.z);
    r6.w = rsqrt(r5.w);
    r1 = (r1) * (r6);
    r2 = (r2) * (r6);
    r4 = (r4) * (r6);
    r5 = saturate((r5) * (c[8]) + (r7.xxxx));
    r2 = (r0.zzzz) * (r2);
    r1 = (r1) * (r0.yyyy) + (r2);
    r0 = saturate((r4) * (r0.wwww) + (r1));
    r0 = (r5) * (r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r1.z = dot(c[11], r0);
    r0.xyz = (r3.xyz) * (r1.xyz) + (r3.xyz);
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
