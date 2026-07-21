// Mechanically reconstructed from 0xA200F57E.ps_3_0.cso.
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
sampler2D s5 : register(s5);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
    float4 v7 : TEXCOORD8;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    float4 v7 = input.v7;
    const float4 c0 = float4(-0.5f, 0.0f, 0.707106769f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 6.28318548f, -3.14159274f);
    const float4 c3 = float4(-1.0f, 1.0f, 0.00333333341f, 0.0f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c13 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c14 = float4(300.0f, 3.0f, 0.000244140625f, 0.0f);
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
    float4 r15 = 0.0f;
    float4 r16 = 0.0f;
    float4 r17 = 0.0f;
    float4 oC0 = 0.0f;

    r4.w = dot(v5.xyz, v5.xyz);
    r1 = (-(v4.yyyy)) + (c[6]);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r1) * (r1);
    r0 = (r2) * (r2) + (r0);
    r3 = (-(v4.zzzz)) + (c[7]);
    r10.x = rsqrt(r4.w);
    r0 = (r3) * (r3) + (r0);
    r11.xyz = normalize(-(v4.xyz));
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r3 = (r3) * (r4);
    r5 = (r1) * (r4);
    r1 = (r11.yyyy) * (r5);
    r4 = (r2) * (r4);
    r1 = (r4) * (r11.xxxx) + (r1);
    r2.xy = frac(v7.xy);
    r1 = saturate((r3) * (r11.zzzz) + (r1));
    r2.xy = (r2.xy) + (c0.xx);
    r2.w = dot(v3.xyz, v3.xyz);
    r2.z = dot(r2.xy, r2.xy) + (c0.x);
    r6.w = (r2.w) * (r2.z);
    r2.z = dot(v3.xy, r2.xy) + (c0.y);
    r10.yzw = c3.yzw;
    r0 = saturate((r0) * (c[8]) + (r10.yyyy));
    r2.z = (r2.z) * (r2.z) + (-(r6.w));
    r6 = (r1) * (r0);
    r1.w = rsqrt(r2.z);
    r2.w = 1.0f / (r2.w);
    r1.w = 1.0f / (r1.w);
    r1.z = dot(v3.xy, -(r2.xy)) + (r1.w);
    r1.xy = c1.xy;
    r1.w = (c[23].x) * (r1.x) + (r1.y);
    r1.z = (r2.w) * (r1.z);
    r1.w = frac(r1.w);
    r1.xy = (v3.xy) * (r1.zz) + (r2.xy);
    r1.w = (r1.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[22].xy);
    r2.xy = float2(cos(r1.w), sin(r1.w));
    r7.xy = (r2.yx) * (c3.xy);
    r16.xy = (r1.xy) * (c0.zz);
    r14.z = dot(c[11], r6);
    r15.y = dot(r7.xy, r16.xy) + (c0.y);
    r1.xy = (r1.xy) * (c0.zz) + (c0.ww);
    r7.xy = (v7.zw) * (c15.xy);
    r9 = tex2D(s13, r7.xy);
    r8 = tex2D(s14, v7.zw);
    r17.xy = (r8.xy) * (c15.ww);
    r7.xy = (v7.zw) * (c15.xy) + (c15.zy);
    r7 = tex2D(s13, r7.xy);
    r9.w = r7.y;
    r14.xy = (r9.xz) * (r17.xx);
    r9.xy = (r9.yw) * (c16.xx) + (c16.yy);
    r1.w = (r8.x) * (c15.w) + (-(r14.x));
    r12.xyz = (r9.yyy) * (v2.xyz);
    r2.w = (r9.z) * (-(r17.x)) + (r1.w);
    r9.xyz = (r9.xxx) * (v1.xyz) + (r12.xyz);
    r7.xy = (r17.yy) * (r7.xz);
    r9.xyz = (v5.xyz) * (r10.xxx) + (r9.xyz);
    r1.w = (r8.y) * (c15.w) + (-(r7.x));
    r13.xyz = normalize(r9.xyz);
    r1.z = (r7.z) * (-(r17.y)) + (r1.w);
    r1.w = dot(r13.xyz, r11.xyz);
    r12.y = (r2.w) + (r2.w);
    r9.y = (r1.z) + (r1.z);
    r12.xz = (r14.xy) * (c13.yy);
    r9.xz = (r7.xy) * (c13.yy);
    r7 = tex2D(s4, v7.xy);
    r17.xy = (r7.wy) * (c4.xy) + (c4.zw);
    r8.xyz = (r1.www) * (r9.xyz) + (r12.xyz);
    r7.xyz = (r17.yyy) * (v2.xyz);
    r14.x = dot(c[9], r6);
    r7.xyz = (r17.xxx) * (v1.xyz) + (r7.xyz);
    r14.y = dot(c[10], r6);
    r7.xyz = (r7.xyz) + (v5.xyz);
    r6.xyz = (r14.xyz) + (r8.xyz);
    r8.xyz = normalize(r7.xyz);
    r5 = (r5) * (r8.yyyy);
    r1.w = dot(r11.xyz, r8.xyz);
    r4 = (r4) * (r8.xxxx) + (r5);
    r1.w = (r1.w) * (-(r1.w)) + (c3.y);
    r3 = saturate((r3) * (r8.zzzz) + (r4));
    r1.w = rsqrt(r1.w);
    r0 = (r0) * (r3);
    r1.w = 1.0f / (r1.w);
    r4.z = dot(c[11], r0);
    r1.z = saturate((r1.w) * (c12.w));
    r1.w = dot(r13.xyz, r8.xyz);
    r4.x = dot(c[9], r0);
    r4.y = dot(c[10], r0);
    r0.xyz = (r1.www) * (r9.xyz) + (r12.xyz);
    r3.xyz = (r6.xyz) * (r1.zzz);
    r0.xyz = (r4.xyz) + (r0.xyz);
    r7.xyz = (r0.xyz) * (c13.xxx) + (r3.xyz);
    r9.xyz = normalize(c[17].xyz);
    if ((c3.y) >= (v0.w))
    {
        r3 = (v0.xyzx) * (c3.yyyw);
        r0 = (r3) + (-(c12.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r4 = (r3) + (c14.zzww);
        r4 = tex2Dlod(s0, r4);
        r0.x = r4.x;
        r4 = (r3) + (-(c14.zzww));
        r4 = tex2Dlod(s0, r4);
        r0.y = r4.x;
        r3 = (r3) + (c12.xyzz);
        r3 = tex2Dlod(s0, r3);
        r0.z = r3.x;
        r1.w = dot(r0, c12.wwww);
        if ((c13.x) < (v0.w))
        {
            r6.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r6.xy) + (c14.zz);
            r0.zw = (v0.zx) * (c3.yw);
            r0 = tex2Dlod(s0, r0);
            r3.xy = (r6.xy) + (-(c14.zz));
            r3.zw = (v0.zx) * (c3.yw);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r6.xy) + (c12.xy);
            r3.zw = (v0.zx) * (c3.yw);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r6.xy) + (-(c12.xy));
            r3.zw = (v0.zx) * (c3.yw);
            r3 = tex2Dlod(s0, r3);
            r0.y = r5.x;
            r0.z = r4.x;
            r0.w = r3.x;
            r0.w = dot(r0, c12.wwww);
            r0.z = (-(r1.w)) + (r0.w);
            r0.w = (v0.w) * (c13.y) + (c13.z);
            r0.z = (r0.w) * (r0.z) + (r1.w);
        }
        else
        {
            r0.z = r1.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (c13.w);
        r1.w = ((r0.w) >= 0.0f ? (c3.w) : (c3.y));
        r0 = tex2D(s12, v7.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r12.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r12.xy) + (c14.zz);
            r3.zw = (v0.zz) * (c3.yw);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r12.xy) + (-(c14.zz));
            r4.zw = (v0.zz) * (c3.yw);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r12.xy) + (c12.xy);
            r4.zw = (v0.zz) * (c3.yw);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r12.xy) + (-(c12.xy));
            r4.zw = (v0.zz) * (c3.yw);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c12.wwww);
            r0.w = saturate((v0.w) + (-(c14.y)));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r0.z = r0.w;
    }
    r2.w = saturate(dot(r11.xyz, r9.xyz));
    r1.w = saturate(dot(r8.xyz, r9.xyz));
    r0.w = (r10.z) * (c[20].w);
    r0.xyz = (r0.zzz) * (c[18].xyz);
    r0.w = frac(abs(r0.w));
    r3.xyz = (r2.www) * (r0.xyz);
    r0.w = ((c[20].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r4.xyz = (r1.zzz) * (r3.xyz);
    r0.w = (r0.w) * (c[24].x);
    r3.xyz = (r1.www) * (r0.xyz);
    r0.xy = (r0.ww) * (c14.xy);
    r0 = tex2D(s2, r0.xy);
    r0.w = saturate(r0.x);
    r1.w = c[26].x;
    r1.z = (c[25].x) * (-(r1.w)) + (r1.w);
    r0.xyz = (r3.xyz) * (c13.xxx) + (r4.xyz);
    r0.w = (r0.w) * (r1.z);
    r3.xyz = (r7.xyz) + (r0.xyz);
    r2.w = (c[25].x) * (r1.w) + (r0.w);
    r0 = tex2D(s5, v7.xy);
    r0.xyz = saturate((r3.xyz) * (r0.xyz));
    r15.x = dot(r2.xy, r16.xy) + (c0.y);
    r1.zw = (r10.wy) * (c[27].xx);
    r1 = tex2Dbias(s3, r1);
    r1 = (r2.wwww) * (r1);
    r3.xy = (r15.xy) + (c0.ww);
    r2 = (r1) * (c[28]);
    r1 = tex2D(s1, r3.xy);
    r0.xyz = (r1.xyz) * (-(r2.xyz)) + (r0.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v6.xyz));
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v6.xyz);
    r1.w = (r1.w) * (-(r2.w)) + (c3.y);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (-(r0.w)) + (c3.y);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (-(r0.w)) + (c3.y);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
