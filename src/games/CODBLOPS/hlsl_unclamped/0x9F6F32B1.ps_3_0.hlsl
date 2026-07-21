// Mechanically reconstructed from 0x9F6F32B1.ps_3_0.cso.
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
    const float4 c0 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(-0.25f, -0.5f, -0.75f, 0.125f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(2.0f, -1.0f, 9.99999975e-06f, 1e-15f);
    const float4 c14 = float4(1.44269502f, 0.100000001f, 0.25f, 1.0f);
    const float4 c15 = float4(9.99999997e-07f, 0.0f, 0.0f, 0.0f);
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
    if ((c0.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c0.xxxy) + (c0.zzzx);
        r2 = (r2) * (c0.xxxy);
        r3 = (r2) + (c0.wwyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c0.wwyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c1.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c1.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r1.w = dot(r3, c1.wwww);
        if ((c3.x) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c0.xy) + (c0.zx);
            r2 = (r2) * (c0.xxxy);
            r3 = (r2) + (c0.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c0.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c1.wwww);
            r2.y = (v5.w) * (c3.y) + (c3.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.w) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c0.y) : (c0.x));
        if ((r2.x) != (-(r2.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c0.xy) + (c0.zx);
            r2 = (r2) * (c0.xxxy);
            r3 = (r2) + (c0.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c0.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c1.wwww);
            r2.y = saturate((c3.z) + (v5.w));
            r1.w = (r2.y) * (-(r2.x)) + (r2.x);
        }
        else
        {
            r1.w = c0.y;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5.xy = ddx(v4.xy);
    r5.zw = ddy(v4.xy);
    r1.w = (c[6].x) * (v4.x);
    r6.y = c3.y;
    r7.w = (r1.w) * (r6.y) + (c[7].x);
    r6.xzw = (c4.xyz) + (v4.xxx);
    r8.xyz = (r6.xzw) * (c[6].xxx);
    r7.z = (r8.x) * (r6.y) + (c[7].z);
    r9.y = c[6].y;
    r7.xy = (v4.yy) * (r9.yy) + (c[7].yw);
    r8.xy = (r8.yz) * (r6.yy) + (c[8].xz);
    r8.zw = (v4.yy) * (r9.yy) + (c[8].yw);
    r6.yw = float2(((r6.w) >= 0.0f ? (r8.y) : (r8.x)), ((r6.w) >= 0.0f ? (r8.w) : (r8.z)));
    r6.yz = float2(((r6.z) >= 0.0f ? (r6.y) : (r7.z)), ((r6.z) >= 0.0f ? (r6.w) : (r7.y)));
    r6.xy = float2(((r6.x) >= 0.0f ? (r6.y) : (r7.w)), ((r6.x) >= 0.0f ? (r6.z) : (r7.x)));
    r5 = (r5) * (c4.wwww);
    r7 = tex2Dgrad(s3, r6.xy, r5.xy, r5.zw);
    r6.zw = (r7.wy) * (c12.xy) + (c12.zw);
    r6.zw = (r6.zw) * (-(c4.yy)) + (-(c4.yy));
    r6.zw = (r6.zw) * (c13.xx) + (c13.yy);
    r7.xy = (r6.xy) * (c[22].xx);
    r7 = tex2D(s2, r7.xy);
    r7.xy = (r7.wy) * (c12.xy) + (c12.zw);
    r7.xy = (r7.xy) * (-(c4.yy)) + (-(c4.yy));
    r6.zw = (r7.xy) * (c13.xx) + (r6.zw);
    r6.zw = (r6.zw) + (-(c0.xx));
    r1.xyz = (r1.xyz) * (r6.www);
    r1.xyz = (r6.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r7.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[5].xxx);
    r0.x = saturate(dot(r7.xyz, r4.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r2.xyz = (r3.xyz) * (c[5].yyy);
    r3.z = c13.z;
    r1.w = max(r3.z, c[25].x);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r3.xyz = (r2.www) * (-(v1.xyz));
    r3.w = saturate(dot(r7.xyz, r3.xyz));
    r1.w = (r1.w) * (r1.w);
    r1.w = 1.0f / (r1.w);
    r4.xyz = (-(v1.xyz)) * (r2.www) + (r4.xyz);
    r8.xyz = normalize(r4.xyz);
    r2.w = saturate(dot(r7.xyz, r8.xyz));
    r4.x = (r2.w) * (r2.w) + (c13.w);
    r4.x = 1.0f / (r4.x);
    r4.y = (-(r4.x)) + (c0.x);
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
    r0.x = (r0.x) * (-(c4.y));
    r2.w = max(c14.y, r0.x);
    r0.x = 1.0f / (r2.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.xyz = (r2.xyz) * (r0.xxx);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[24].xxx);
    r0.xyz = (r0.xyz) * (c14.zzz) + (c14.www);
    r2.y = c0.y;
    r0.w = max(c[23].x, r2.y);
    r0.w = (r0.w) + (-(c0.x));
    r2.x = log2(abs(r0.x));
    r2.y = log2(abs(r0.y));
    r2.z = log2(abs(r0.z));
    r0.xyz = (r0.www) * (r2.xyz);
    r2.x = exp2(r0.x);
    r2.y = exp2(r0.y);
    r2.z = exp2(r0.z);
    r0.xyz = normalize(v1.xyz);
    r0.y = dot(r0.xyz, r7.xyz);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r7.x) * (-(r0.y)) + (r0.x);
    r0.x = (r0.x) * (c[21].x);
    r0.x = (r0.x) * (c15.x);
    r0.xyz = (r2.xyz) * (c[23].yyy) + (r0.xxx);
    r2 = tex2Dgrad(s4, r6.xy, r5.xy, r5.zw);
    r2 = (r2) * (r2);
    r0.xyz = (r0.xyz) * (c[26].xxx);
    r2.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0 = max(r2, c0.yyyy);
    r1 = (r0.xyzx) * (c0.xxxy) + (c0.zzzx);
    r0.x = dot(r1, c[10]);
    r0.y = dot(r1, c[11]);
    r0.z = dot(r1, c[20]);
    r1.w = v1.w;
    r2.xyz = lerp(v0.xyz, r0.xyz, r1.www);
    r0.xyz = max(((r2.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
