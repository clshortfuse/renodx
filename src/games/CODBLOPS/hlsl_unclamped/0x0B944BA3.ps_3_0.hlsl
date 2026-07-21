// Mechanically reconstructed from 0x0B944BA3.ps_3_0.cso.
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
    const float4 c0 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c1 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.5f, 2.0f, -1.0f, 9.99999975e-06f);
    const float4 c13 = float4(1e-15f, 1.44269502f, 0.100000001f, 9.99999997e-07f);
    const float4 c14 = float4(0.25f, 1.0f, 0.0f, 0.0f);
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
    if ((c1.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c1.xxxy) + (c1.zzzx);
        r2 = (r2) * (c1.xxxy);
        r3 = (r2) + (c1.wwyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c1.wwyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c0.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c0.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r1.w = dot(r3, c0.wwww);
        if ((c3.x) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c1.xy) + (c1.zx);
            r2 = (r2) * (c1.xxxy);
            r3 = (r2) + (c1.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c1.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c0.wwww);
            r2.y = (v5.w) * (c3.y) + (c3.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.w) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c1.y) : (c1.x));
        if ((r2.x) != (-(r2.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c1.xy) + (c1.zx);
            r2 = (r2) * (c1.xxxy);
            r3 = (r2) + (c1.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c1.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c0.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c0.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c0.wwww);
            r2.y = saturate((c3.z) + (v5.w));
            r1.w = (r2.y) * (-(r2.x)) + (r2.x);
        }
        else
        {
            r1.w = c1.y;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5.xy = ddx(v4.xy);
    r5.zw = ddy(v4.xy);
    r6.xy = (c[11].xx) * (v4.xy);
    r6 = tex2D(s2, r6.xy);
    r6.xy = (r6.wy) * (c4.xy) + (c4.zw);
    r6.xy = (r6.xy) * (c12.xx) + (c12.xx);
    r6.xy = (r6.xy) * (c12.yy) + (c12.zz);
    r1.xyz = (r1.xyz) * (r6.yyy);
    r1.xyz = (r6.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r6.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[5].xxx);
    r0.x = saturate(dot(r6.xyz, r4.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r2.xyz = (r3.xyz) * (c[5].yyy);
    r3 = tex2D(s4, v4.xy);
    r1.w = (r3.x) * (c[22].x);
    r2.w = max(c12.w, r1.w);
    r1.w = dot(-(v1.xyz), -(v1.xyz));
    r1.w = rsqrt(r1.w);
    r7.xyz = (r1.www) * (-(v1.xyz));
    r3.w = saturate(dot(r6.xyz, r7.xyz));
    r2.w = (r2.w) * (r2.w);
    r2.w = 1.0f / (r2.w);
    r4.xyz = (-(v1.xyz)) * (r1.www) + (r4.xyz);
    r8.xyz = normalize(r4.xyz);
    r1.w = saturate(dot(r6.xyz, r8.xyz));
    r4.x = (r1.w) * (r1.w) + (c13.x);
    r4.x = 1.0f / (r4.x);
    r4.y = (-(r4.x)) + (c1.x);
    r4.y = (r2.w) * (r4.y);
    r4.y = (r4.y) * (c13.y);
    r4.y = exp2(r4.y);
    r4.x = (r4.x) * (r4.x);
    r4.x = (r4.y) * (r4.x);
    r1.w = (r1.w) + (r1.w);
    r4.y = 1.0f / (r3.w);
    r1.w = (r1.w) * (r4.y);
    r4.y = min(r3.w, r0.x);
    r1.w = saturate((r1.w) * (r4.y));
    r0.x = (r0.x) * (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r4.x) * (r0.x);
    r2.xyz = (r2.xyz) * (r0.xxx);
    r0.x = saturate(dot(r0.yzw, r7.xyz));
    r0.x = (r3.w) + (r0.x);
    r0.x = (r0.x) * (c12.x);
    r1.w = max(c13.z, r0.x);
    r0.x = 1.0f / (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.xyz = (r2.xyz) * (r0.xxx);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[21].xxx);
    r0.xyz = (r0.xyz) * (c14.xxx) + (c14.yyy);
    r2.y = c1.y;
    r0.w = max(c[20].x, r2.y);
    r0.w = (r0.w) + (-(c1.x));
    r2.x = log2(abs(r0.x));
    r2.y = log2(abs(r0.y));
    r2.z = log2(abs(r0.z));
    r0.xyz = (r0.www) * (r2.xyz);
    r2.x = exp2(r0.x);
    r2.y = exp2(r0.y);
    r2.z = exp2(r0.z);
    r0.xyz = normalize(v1.xyz);
    r0.y = dot(r0.xyz, r6.xyz);
    r0.y = (r0.y) + (r0.y);
    r0.x = (r6.x) * (-(r0.y)) + (r0.x);
    r0.x = (r0.x) * (c13.w);
    r0.yzw = (r3.xyz) * (c[10].xxx);
    r0.xyz = (r0.xxx) * (r0.yzw);
    r0.xyz = (r2.xyz) * (c[20].yyy) + (r0.xyz);
    r2 = tex2Dgrad(s3, v4.xy, r5.xy, r5.zw);
    r2 = (r2) * (r2);
    r0.xyz = (r0.xyz) * (c[23].xxx);
    r2.xyz = (r1.xyz) * (r2.xyz) + (r0.xyz);
    r0 = max(r2, c1.yyyy);
    r1 = (r0.xyzx) * (c1.xxxy) + (c1.zzzx);
    r0.x = dot(r1, c[7]);
    r0.y = dot(r1, c[8]);
    r0.z = dot(r1, c[9]);
    r1.w = v1.w;
    r2.xyz = lerp(v0.xyz, r0.xyz, r1.www);
    r0.xyz = max(((r2.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
