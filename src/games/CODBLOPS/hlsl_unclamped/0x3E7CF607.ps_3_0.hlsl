// Mechanically reconstructed from 0x3E7CF607.ps_3_0.cso.
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
    const float4 c1 = float4(4.0f, -3.0f, -4.0f, 0.125f);
    const float4 c3 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c4 = float4(2.0f, -1.0f, 9.99999975e-06f, 1e-15f);
    const float4 c12 = float4(-0.25f, -0.5f, -0.75f, 0.5f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(1.44269502f, 0.100000001f, 9.99999997e-07f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 r9 = 0.0f;
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
    r5.xy = ddx(v4.xy);
    r5.zw = ddy(v4.xy);
    r1.w = (c[21].x) * (v4.x);
    r6.x = c1.x;
    r7.w = (r1.w) * (r6.x) + (c[22].x);
    r6.yzw = (c12.xyz) + (v4.xxx);
    r8.xyz = (r6.yzw) * (c[21].xxx);
    r7.z = (r8.x) * (r6.x) + (c[22].z);
    r9.y = c[21].y;
    r7.xy = (v4.yy) * (r9.yy) + (c[22].yw);
    r8.xy = (r8.yz) * (r6.xx) + (c[23].xz);
    r8.zw = (v4.yy) * (r9.yy) + (c[23].yw);
    r6.xw = float2(((r6.w) >= 0.0f ? (r8.y) : (r8.x)), ((r6.w) >= 0.0f ? (r8.w) : (r8.z)));
    r6.xz = float2(((r6.z) >= 0.0f ? (r6.x) : (r7.z)), ((r6.z) >= 0.0f ? (r6.w) : (r7.y)));
    r6.xy = float2(((r6.y) >= 0.0f ? (r6.x) : (r7.w)), ((r6.y) >= 0.0f ? (r6.z) : (r7.x)));
    r5 = (r5) * (c1.wwww);
    r7 = tex2Dgrad(s3, r6.xy, r5.xy, r5.zw);
    r6.zw = (r7.wy) * (c13.xy) + (c13.zw);
    r6.zw = (r6.zw) * (c12.ww) + (c12.ww);
    r6.zw = (r6.zw) * (c4.xx) + (c4.yy);
    r7.xy = (r6.xy) * (c[29].xx);
    r7 = tex2D(s2, r7.xy);
    r7.xy = (r7.wy) * (c13.xy) + (c13.zw);
    r7.xy = (r7.xy) * (c12.ww) + (c12.ww);
    r6.zw = (r7.xy) * (c4.xx) + (r6.zw);
    r6.zw = (r6.zw) + (-(c3.xx));
    r1.xyz = (r1.xyz) * (r6.www);
    r1.xyz = (r6.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r7.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[20].xxx);
    r0.x = saturate(dot(r7.xyz, r4.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r2.xyz = (r3.xyz) * (c[20].yyy);
    r3.z = c4.z;
    r1.w = max(r3.z, c[32].x);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r3.xyz = (r2.www) * (-(v1.xyz));
    r3.w = saturate(dot(r7.xyz, r3.xyz));
    r1.w = (r1.w) * (r1.w);
    r1.w = 1.0f / (r1.w);
    r4.xyz = (-(v1.xyz)) * (r2.www) + (r4.xyz);
    r8.xyz = normalize(r4.xyz);
    r2.w = saturate(dot(r7.xyz, r8.xyz));
    r4.x = (r2.w) * (r2.w) + (c4.w);
    r4.x = 1.0f / (r4.x);
    r4.y = (-(r4.x)) + (c3.x);
    r4.y = (r1.w) * (r4.y);
    r4.y = (r4.y) * (c14.x);
    r4.y = exp2(r4.y);
    r4.x = (r4.x) * (r4.x);
    r4.x = (r4.y) * (r4.x);
    r2.w = (r2.w) + (r2.w);
    r4.y = 1.0f / (r3.w);
    r2.w = (r2.w) * (r4.y);
    r4.y = min(r3.w, r0.x);
    r2.w = saturate((r2.w) * (r4.y));
    r0.x = (r0.x) * (r2.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r4.x) * (r0.x);
    r2.xyz = (r2.xyz) * (r0.xxx);
    r0.x = saturate(dot(r0.yzw, r3.xyz));
    r0.x = (r3.w) + (r0.x);
    r0.x = (r0.x) * (c12.w);
    r2.w = max(c14.y, r0.x);
    r0.x = 1.0f / (r2.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r2.xyz = (r2.xyz) * (r0.xxx);
    r2.xyz = (r1.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[31].xxx);
    r2.xyz = (r2.xyz) * (c3.www) + (c3.xxx);
    r3.xy = c3.xy;
    r0.x = max(c[30].x, r3.y);
    r0.x = (r0.x) + (-(c3.x));
    r3.y = log2(abs(r2.x));
    r3.z = log2(abs(r2.y));
    r3.w = log2(abs(r2.z));
    r2.xyz = (r0.xxx) * (r3.yzw);
    r3.y = exp2(r2.x);
    r3.z = exp2(r2.y);
    r3.w = exp2(r2.z);
    r2.xyz = normalize(v1.xyz);
    r0.x = dot(r2.xyz, r7.xyz);
    r0.x = (r0.x) + (r0.x);
    r0.x = (r7.x) * (-(r0.x)) + (r2.x);
    r0.x = (r0.x) * (c[28].x);
    r0.x = (r0.x) * (c14.z);
    r2.xyz = (r3.yzw) * (c[30].yyy) + (r0.xxx);
    r4 = tex2Dgrad(s4, r6.xy, r5.xy, r5.zw);
    r4 = (r4) * (r4);
    r2.xyz = (r2.xyz) * (c[33].xxx);
    r4.xyz = (r1.xyz) * (r4.xyz) + (r2.xyz);
    r1 = max(r4, c3.yyyy);
    r2 = (c[5]) + (-(v1.xxxx));
    r4 = (c[6]) + (-(v1.yyyy));
    r5 = (c[7]) + (-(v1.zzzz));
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
    r3 = saturate((r6) * (c[8]) + (r3.xxxx));
    r4 = (r0.zzzz) * (r4);
    r2 = (r2) * (r0.yyyy) + (r4);
    r0 = saturate((r5) * (r0.wwww) + (r2));
    r0 = (r3) * (r0);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r2.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c3.x;
    r1.x = dot(r0, c[25]);
    r1.y = dot(r0, c[26]);
    r1.z = dot(r0, c[27]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r1.w;

    return oC0;
}
