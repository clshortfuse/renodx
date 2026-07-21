// Mechanically reconstructed from 0x412A6A9E.ps_3_0.cso.
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
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
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
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c14 = float4(4.0f, -3.0f, 1.0f, 0.5f);
    const float4 c15 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c16 = float4(300.0f, 3.0f, 0.25f, -2.0f);
    const float4 c19 = float4(4.0f, -2.0f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v7.zw) * (c14.zw);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v7.zw) * (c15.xy) + (c15.zy);
    r0 = tex2D(s13, r0.xy);
    r1.w = r0.y;
    r3.xy = (r1.yw) * (c19.xx) + (c19.yy);
    r0.w = dot(v5.xyz, v5.xyz);
    r2.xyz = (r3.yyy) * (v2.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = (r3.xxx) * (v1.xyz) + (r2.xyz);
    r2 = tex2D(s6, v7.xy);
    r5.xy = (r2.wy) * (c4.xy) + (c4.zw);
    r4.xyz = (v5.xyz) * (r0.www) + (r3.xyz);
    r3.xyz = (r5.yyy) * (v2.xyz);
    r2.xyz = normalize(r4.xyz);
    r3.xyz = (r5.xxx) * (v1.xyz) + (r3.xyz);
    r10.xyz = normalize(-(v4.xyz));
    r3.xyz = (r3.xyz) + (v5.xyz);
    r7.w = dot(r2.xyz, r10.xyz);
    r7.xyz = normalize(r3.xyz);
    r1.w = dot(r2.xyz, r7.xyz);
    r9.xyz = normalize(c[17].xyz);
    if ((c3.y) >= (v0.w))
    {
        r3 = (v0.xyzx) * (c3.yyyw);
        r2 = (r3) + (-(c13.xyzz));
        r2 = tex2Dlod(s0, r2);
        r2.w = r2.x;
        r4 = (r3) + (c12.xxyy);
        r4 = tex2Dlod(s0, r4);
        r2.x = r4.x;
        r4 = (r3) + (c12.zzyy);
        r4 = tex2Dlod(s0, r4);
        r2.y = r4.x;
        r3 = (r3) + (c13.xyzz);
        r3 = tex2Dlod(s0, r3);
        r2.z = r3.x;
        r1.y = dot(r2, c16.zzzz);
        if ((c12.w) < (v0.w))
        {
            r6.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r6.xy) + (c12.xx);
            r2.zw = (v0.zx) * (c3.yw);
            r2 = tex2Dlod(s0, r2);
            r3.xy = (r6.xy) + (c12.zz);
            r3.zw = (v0.zx) * (c3.yw);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r6.xy) + (c13.xy);
            r3.zw = (v0.zx) * (c3.yw);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r6.xy) + (-(c13.xy));
            r3.zw = (v0.zx) * (c3.yw);
            r3 = tex2Dlod(s0, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.w = dot(r2, c16.zzzz);
            r0.y = (-(r1.y)) + (r0.w);
            r0.w = (v0.w) * (c14.x) + (c14.y);
            r1.y = (r0.w) * (r0.y) + (r1.y);
        }
    }
    else
    {
        r0.w = (v0.w) + (c13.w);
        r0.w = ((r0.w) >= 0.0f ? (c3.w) : (c3.y));
        r2 = tex2D(s12, v7.zw);
        if ((r0.w) != (-(r0.w)))
        {
            r8.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r8.xy) + (c12.xx);
            r3.zw = (v0.zz) * (c3.yw);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r8.xy) + (c12.zz);
            r4.zw = (v0.zz) * (c3.yw);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r8.xy) + (c13.xy);
            r4.zw = (v0.zz) * (c3.yw);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r8.xy) + (-(c13.xy));
            r4.zw = (v0.zz) * (c3.yw);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r1.y = dot(r3, c16.zzzz);
            r0.w = saturate((v0.w) + (-(c16.y)));
            r0.y = (r2.y) + (-(r1.y));
            r0.w = (r0.w) * (r0.y) + (r1.y);
        }
        else
        {
            r0.w = r2.y;
        }
        r1.y = r0.w;
    }
    r0.y = saturate(dot(r10.xyz, r9.xyz));
    r2.xyz = (-(v4.xyz)) + (c[5].xyz);
    r8.xyz = normalize(r2.xyz);
    r2 = (v4.yyyy) * (c[24]);
    r0.w = saturate(dot(r10.xyz, r8.xyz));
    r2 = (v4.xxxx) * (c[23]) + (r2);
    r3.w = dot(r8.xyz, c[21].xyz);
    r2 = (v4.zzzz) * (c[25]) + (r2);
    r3.w = saturate((r3.w) * (c[22].x) + (c[22].y));
    r5 = (r2) + (c[26]);
    r2.z = (r3.w) * (c16.w) + (c16.y);
    r4.zw = r5.zw;
    r2.w = (r3.w) * (r3.w);
    r6.zw = r4.zw;
    r5.z = (r2.z) * (r2.w);
    r3.zw = r6.zw;
    r2.xy = (r5.ww) * (-(c[27].zw)) + (r5.xy);
    r2.zw = r3.zw;
    r2 = tex2Dproj(s1, r2);
    r2.w = r2.x;
    r6.xy = (r4.ww) * (-(c[27].xy)) + (r5.xy);
    r6 = tex2Dproj(s1, r6);
    r2.y = r6.x;
    r4.xy = (r4.ww) * (c[27].xy) + (r5.xy);
    r6 = tex2Dproj(s1, r4);
    r2.x = r6.x;
    r3.xy = (r4.ww) * (c[27].zw) + (r5.xy);
    r4 = tex2Dproj(s1, r3);
    r3 = (v4.xyzx) * (c3.yyyw) + (c3.wwwy);
    r2.z = r4.x;
    r4.w = dot(r3, c[20]);
    r4.w = 1.0f / (r4.w);
    r5.x = dot(r3, c[11]);
    r4.x = dot(r3, c[9]);
    r5.y = (r5.x) * (r5.x);
    r4.y = dot(r3, c[10]);
    r3.w = dot(c[7].yz, r5.xy) + (c[7].x);
    r3.z = saturate(1.0f / (r3.w));
    r3.xy = saturate((r5.xx) * (c[8].xy) + (c[8].zw));
    r5.xy = (r3.xy) * (c16.ww) + (c16.yy);
    r3.xy = (r3.xy) * (r3.xy);
    r3.w = ((-abs(r3.w)) >= 0.0f ? (c0.y) : (r3.z));
    r3.z = (r5.x) * (r3.x);
    r3.w = (r3.w) * (r3.z);
    r3.z = (r3.y) * (-(r5.y)) + (c3.y);
    r3.xy = (r4.ww) * (r4.xy);
    r3.w = (r3.w) * (r3.z);
    r4.w = (r5.z) * (r3.w);
    r3.xy = (r3.xy) * (c0.ww) + (c0.ww);
    r3 = tex2D(s2, r3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r2.w = dot(r2, c16.zzzz);
    r2.xyz = (r4.www) * (r3.xyz);
    r2.xyz = (r2.www) * (r2.xyz);
    r6.xyz = (r1.yyy) * (c[18].xyz);
    r5.xyz = (r2.xyz) * (c[6].xyz);
    r3.xyz = (r0.yyy) * (r6.xyz);
    r2 = tex2D(s14, v7.zw);
    r4.xy = (r2.xy) * (c15.ww);
    r3.xyz = (r0.www) * (r5.xyz) + (r3.xyz);
    r11.xy = (r1.xz) * (r4.xx);
    r1.xy = (r0.xz) * (r4.yy);
    r0.y = (r2.x) * (c15.w) + (-(r11.x));
    r0.w = (r2.y) * (c15.w) + (-(r1.x));
    r0.y = (r1.z) * (-(r4.x)) + (r0.y);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r4.y = (r0.y) + (r0.y);
    r0.y = (r0.w) + (r0.w);
    r0.w = dot(r10.xyz, r7.xyz);
    r4.xz = (r11.xy) * (-(c13.ww));
    r0.w = (r0.w) * (-(r0.w)) + (c3.y);
    r0.xz = (r1.xy) * (-(c13.ww));
    r0.w = rsqrt(r0.w);
    r2.xyz = (r7.www) * (r0.xyz) + (r4.xyz);
    r0.w = 1.0f / (r0.w);
    r2.w = saturate((r0.w) * (c16.z));
    r1.z = saturate(dot(r7.xyz, r9.xyz));
    r0.w = saturate(dot(r7.xyz, r8.xyz));
    r1.xyz = (r6.xyz) * (r1.zzz);
    r3.xyz = (r3.xyz) * (r2.www);
    r1.xyz = (r0.www) * (r5.xyz) + (r1.xyz);
    r1.xyz = (r1.xyz) * (c12.www) + (r3.xyz);
    r3.yzw = c3.yzw;
    r0.w = (r3.z) * (c[28].w);
    r2.xyz = (r2.xyz) * (r2.www);
    r0.w = frac(abs(r0.w));
    r0.xyz = (r1.www) * (r0.xyz) + (r4.xyz);
    r0.w = ((c[28].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.xyz = (r0.xyz) * (c12.www) + (r2.xyz);
    r0.w = (r0.w) * (c[32].x);
    r4.xyz = (r1.xyz) + (r0.xyz);
    r0.xy = (r0.ww) * (c16.xy);
    r0 = tex2D(s4, r0.xy);
    r0.w = saturate(r0.x);
    r0.xy = frac(v7.xy);
    r1.w = c[34].x;
    r1.z = (c[33].x) * (-(r1.w)) + (r1.w);
    r0.xy = (r0.xy) + (c0.xx);
    r0.z = dot(v3.xyz, v3.xyz);
    r1.y = dot(r0.xy, r0.xy) + (c0.x);
    r1.x = (r0.z) * (r1.y);
    r1.y = dot(v3.xy, r0.xy) + (c0.y);
    r1.z = (r0.w) * (r1.z);
    r0.w = (r1.y) * (r1.y) + (-(r1.x));
    r3.z = (c[33].x) * (r1.w) + (r1.z);
    r0.w = rsqrt(r0.w);
    r1.w = 1.0f / (r0.z);
    r0.w = 1.0f / (r0.w);
    r0.z = dot(v3.xy, -(r0.xy)) + (r0.w);
    r1.xy = c1.xy;
    r0.w = (c[31].x) * (r1.x) + (r1.y);
    r0.z = (r1.w) * (r0.z);
    r0.w = frac(r0.w);
    r0.xy = (v3.xy) * (r0.zz) + (r0.xy);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xy = (r0.xy) * (c[30].xy);
    r2.xy = float2(cos(r0.w), sin(r0.w));
    r1.xy = (r2.yx) * (c3.xy);
    r6.xy = (r0.xy) * (c0.zz);
    r5.y = dot(r1.xy, r6.xy) + (c0.y);
    r1.xy = (r0.xy) * (c0.zz) + (c0.ww);
    r0 = tex2D(s7, v7.xy);
    r0.xyz = saturate((r4.xyz) * (r0.xyz));
    r5.x = dot(r2.xy, r6.xy) + (c0.y);
    r1.zw = (r3.wy) * (c[35].xx);
    r1 = tex2Dbias(s5, r1);
    r1 = (r3.zzzz) * (r1);
    r3.xy = (r5.xy) + (c0.ww);
    r2 = (r1) * (c[36]);
    r1 = tex2D(s3, r3.xy);
    r0.xyz = (r1.xyz) * (-(r2.xyz)) + (r0.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v6.xyz));
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v6.xyz);
    r1.w = (r1.w) * (-(r2.w)) + (c3.y);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
