// Mechanically reconstructed from 0x3F077A86.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD5;
    float4 v2 : TEXCOORD6;
    float4 v3 : TEXCOORD7;
    float4 v4 : TEXCOORD8;
    float4 v5 : TEXCOORD9;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c1 = float4(6.28318548f, -3.14159274f, 0.0f, 1.0f);
    const float4 c3 = float4(-0.5f, 0.5f, 1.0f, 1.52587891e-05f);
    const float4 c4 = float4(0.707106769f, 0.5f, 0.000244140625f, 0.0f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c14 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c15 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c16 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = (v5.zw) * (c15.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v5.zw) * (c15.xy) + (c15.zy);
    r0 = tex2D(s13, r0.xy);
    r2.xyz = v4.xyz;
    r3.xyz = (r2.zxy) * (v1.yzx);
    r1.w = r0.y;
    r2.xyz = (r2.yzx) * (v1.zxy) + (-(r3.xyz));
    r3.xy = (r1.yw) * (c16.xx) + (c16.yy);
    r8.xyz = (r2.xyz) * (v1.www);
    r0.w = dot(v4.xyz, v4.xyz);
    r2.xyz = (r3.yyy) * (r8.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = (r3.xxx) * (v1.xyz) + (r2.xyz);
    r2.xyz = (v4.xyz) * (r0.www) + (r2.xyz);
    r11.xyz = normalize(r2.xyz);
    r10.xyz = normalize(-(v3.xyz));
    r7.w = dot(r11.xyz, r10.xyz);
    r2 = tex2D(s14, v5.zw);
    r3.xy = (r2.xy) * (c15.ww);
    r5.xy = (r1.xz) * (r3.xx);
    r4.xy = (r0.xz) * (r3.yy);
    r0.w = (r2.x) * (c15.w) + (-(r5.x));
    r0.y = (r2.y) * (c15.w) + (-(r4.x));
    r0.w = (r1.z) * (-(r3.x)) + (r0.w);
    r4.w = (r0.z) * (-(r3.y)) + (r0.y);
    r9.y = (r0.w) + (r0.w);
    r1 = (-(v3.yyyy)) + (c[6]);
    r3 = (-(v3.xxxx)) + (c[5]);
    r0 = (r1) * (r1);
    r0 = (r3) * (r3) + (r0);
    r2 = (-(v3.zzzz)) + (c[7]);
    r6.y = (r4.w) + (r4.w);
    r0 = (r2) * (r2) + (r0);
    r9.xz = (r5.xy) * (c14.yy);
    r5.x = rsqrt(r0.x);
    r5.y = rsqrt(r0.y);
    r5.z = rsqrt(r0.z);
    r5.w = rsqrt(r0.w);
    r6.xz = (r4.xy) * (c14.yy);
    r4 = (r1) * (r5);
    r1 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r1 = (r3) * (r10.xxxx) + (r1);
    r1 = saturate((r2) * (r10.zzzz) + (r1));
    r6.w = c1.w;
    r0 = saturate((r0) * (c[8]) + (r6.wwww));
    r5.xyz = (r7.www) * (r6.xyz) + (r9.xyz);
    r1 = (r1) * (r0);
    r7.z = dot(c[11], r1);
    r7.x = dot(c[9], r1);
    r7.y = dot(c[10], r1);
    r7.w = dot(v2.xyz, v2.xyz);
    r7.xyz = (r5.xyz) + (r7.xyz);
    r5.w = 1.0f / (r7.w);
    r5.xy = frac(v5.xy);
    r1.xy = (v5.xy) + (c3.xx);
    r13.xy = (r5.xy) + (c3.xx);
    r1.z = c3.y;
    r1.xy = (r1.xy) * (c[24].xy) + (r1.zz);
    r1 = tex2D(s1, r1.xy);
    r14.xy = (r1.xy) * (c[25].xx);
    r8.w = dot(r13.xy, r13.xy) + (c3.x);
    r1.w = (r14.y) * (c3.z) + (c3.y);
    r1.xyz = ddy(v5.xyx);
    r1.w = frac(r1.w);
    r12.xyz = (r1.xyy) * (r1.xyz);
    r9.w = (r1.w) * (c1.x) + (c1.y);
    r5.xyz = ddx(v5.xyx);
    r1.xy = float2(cos(r9.w), sin(r9.w));
    r1.w = (r14.x) * (r14.x);
    r1.xyz = (r1.xyx) * (r1.xyy);
    r5.xyz = (r5.xyz) * (r5.xyy) + (r12.xyz);
    r1.z = (r1.w) * (r1.z);
    r1.xy = (r1.ww) * (r1.xy) + (r1.ww);
    r7.w = (r7.w) * (r8.w);
    r5.xyz = (r1.xyz) * (c3.www) + (r5.xyz);
    r1.w = dot(v2.xy, r13.xy) + (c1.z);
    r1.x = rsqrt(r5.x);
    r1.y = rsqrt(r5.y);
    r1.w = (r1.w) * (r1.w) + (-(r7.w));
    r14.x = 1.0f / (r1.x);
    r14.y = 1.0f / (r1.y);
    r1.z = rsqrt(r1.w);
    r1.w = (r14.y) * (r14.x);
    r1.z = 1.0f / (r1.z);
    r1.w = 1.0f / (r1.w);
    r1.z = dot(v2.xy, -(r13.xy)) + (r1.z);
    r1.w = (r5.z) * (r1.w);
    r5.w = (r5.w) * (r1.z);
    r1.x = ((-abs(r5.z)) >= 0.0f ? (c1.z) : (r1.w));
    r13.xy = (v2.xy) * (r5.ww) + (r13.xy);
    r1.w = (r1.x) * (-(r1.x)) + (c1.w);
    r5.z = (-(r5.x)) + (r5.y);
    r1.w = rsqrt(r1.w);
    r1.z = 1.0f / (r1.w);
    r1.yw = c1.wz;
    r1 = float4(((r5.z) >= 0.0f ? (r1.x) : (r1.y)), ((r5.z) >= 0.0f ? (r1.y) : (r1.x)), ((r5.z) >= 0.0f ? (r1.z) : (r1.w)), ((r5.z) >= 0.0f ? (r1.w) : (r1.z)));
    r5.xy = (r5.ww) * (v2.xy);
    r12.xy = ddy(r5.xy);
    r5.xy = ddx(r5.xy);
    r12.xy = (r14.xy) * (r1.zw) + (r12.xy);
    r5.xy = (r14.xy) * (r1.xy) + (r5.xy);
    r1.xy = (r13.xy) * (c[26].xy);
    r5.xy = (r5.xy) * (c[26].xy);
    r12.xy = (r12.xy) * (c[26].xy);
    r5.xy = (r5.xy) * (c4.xx);
    r12.xy = (r12.xy) * (c4.xx);
    r1.xy = (r1.xy) * (c4.xx) + (c4.yy);
    r1 = tex2Dgrad(s2, r1.xy, r5.xy, r12.xy);
    r5 = tex2D(s3, v5.xy);
    r12.xy = (r5.wy) * (c12.xy) + (c12.zw);
    r5.xyz = (r8.xyz) * (r12.yyy);
    r5.xyz = (r12.xxx) * (v1.xyz) + (r5.xyz);
    r5.xyz = (r5.xyz) + (v4.xyz);
    r8.xyz = normalize(r5.xyz);
    r5.w = dot(r10.xyz, r8.xyz);
    r4 = (r4) * (r8.yyyy);
    r5.w = (r5.w) * (-(r5.w)) + (c1.w);
    r3 = (r3) * (r8.xxxx) + (r4);
    r4.w = rsqrt(r5.w);
    r2 = saturate((r2) * (r8.zzzz) + (r3));
    r3.w = 1.0f / (r4.w);
    r0 = (r0) * (r2);
    r7.w = saturate((r3.w) * (c13.w));
    r2.z = dot(c[11], r0);
    r7.xyz = (r7.xyz) * (r7.www);
    r2.w = dot(r11.xyz, r8.xyz);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r0.xyz = (r2.www) * (r6.xyz) + (r9.xyz);
    r6.xyz = (r2.xyz) + (r0.xyz);
    r9.xyz = normalize(c[17].xyz);
    if ((c1.w) >= (v0.w))
    {
        r2 = (v0.xyzx) * (c1.wwwz);
        r0 = (r2) + (-(c13.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r3 = (r2) + (c4.zzww);
        r3 = tex2Dlod(s0, r3);
        r0.x = r3.x;
        r3 = (r2) + (-(c4.zzww));
        r3 = tex2Dlod(s0, r3);
        r0.y = r3.x;
        r2 = (r2) + (c13.xyzz);
        r2 = tex2Dlod(s0, r2);
        r0.z = r2.x;
        r5.w = dot(r0, c13.wwww);
        if ((c14.x) < (v0.w))
        {
            r5.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r5.xy) + (c4.zz);
            r0.zw = (v0.zx) * (c1.wz);
            r0 = tex2Dlod(s0, r0);
            r2.xy = (r5.xy) + (-(c4.zz));
            r2.zw = (v0.zx) * (c1.wz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (c13.xy);
            r2.zw = (v0.zx) * (c1.wz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (-(c13.xy));
            r2.zw = (v0.zx) * (c1.wz);
            r2 = tex2Dlod(s0, r2);
            r0.y = r4.x;
            r0.z = r3.x;
            r0.w = r2.x;
            r0.w = dot(r0, c13.wwww);
            r0.z = (-(r5.w)) + (r0.w);
            r0.w = (v0.w) * (c14.y) + (c14.z);
            r0.w = (r0.w) * (r0.z) + (r5.w);
        }
        else
        {
            r0.w = r5.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (c14.w);
        r2.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.w));
        r0 = tex2D(s12, v5.zw);
        if ((r2.w) != (-(r2.w)))
        {
            r11.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r11.xy) + (c4.zz);
            r2.zw = (v0.zz) * (c1.wz);
            r2 = tex2Dlod(s0, r2);
            r3.xy = (r11.xy) + (-(c4.zz));
            r3.zw = (v0.zz) * (c1.wz);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r11.xy) + (c13.xy);
            r3.zw = (v0.zz) * (c1.wz);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r11.xy) + (-(c13.xy));
            r3.zw = (v0.zz) * (c1.wz);
            r3 = tex2Dlod(s0, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.x = dot(r2, c13.wwww);
            r0.w = saturate((v0.w) + (c14.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
    }
    r2.w = saturate(dot(r10.xyz, r9.xyz));
    r0.xyz = (r0.www) * (c[18].xyz);
    r0.w = saturate(dot(r8.xyz, r9.xyz));
    r2.xyz = (r2.www) * (r0.xyz);
    r3.xyz = (r7.www) * (r2.xyz);
    r2.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r6.xyz) * (c14.xxx) + (r7.xyz);
    r2.xyz = (r2.xyz) * (c14.xxx) + (r3.xyz);
    r2.xyz = (r0.xyz) + (r2.xyz);
    r0 = tex2D(s4, v5.xy);
    r0.xyz = saturate((r2.xyz) * (r0.xyz));
    r2.xyz = (r1.xyz) * (-(c[27].xyz)) + (r0.xyz);
    r0.xyz = normalize(v3.xyz);
    r1.xyz = (r1.xyz) * (c[27].xyz);
    r0.z = dot(c[20].xyz, r0.xyz);
    r2.w = saturate((c[22].y) * (r0.z) + (c[22].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[21].xyz);
    r1.xyz = (r0.www) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r2.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r1.w = (r1.w) * (-(c[27].w)) + (r6.w);
    r0.xyz = max(((r0.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (-(r0.w)) + (c1.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (-(r0.w)) + (c1.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
