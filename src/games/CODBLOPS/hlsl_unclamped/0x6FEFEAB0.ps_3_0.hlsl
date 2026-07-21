// Mechanically reconstructed from 0x6FEFEAB0.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD3;
    float4 v2 : TEXCOORD4;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
    float4 v6 : TEXCOORD8;
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
    const float4 c0 = float4(75.0f, 0.5f, -0.5f, 3.68000007f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.00333333341f, 300.0f, -64.0301971f, 9.40301991f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c12 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c13 = float4(60.0f, 1.0f, 0.0f, 0.000244140625f);
    const float4 c14 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c15 = float4(2.75f, -2.0f, 0.5f, 2.0f);
    const float4 c16 = float4(4.0f, -2.0f, 100.0f, 8.0f);
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

    r0.w = c3.x;
    r0.w = (r0.w) * (c[20].w);
    r0.w = frac(abs(r0.w));
    r4.z = ((c[20].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r3.y = (r4.z) * (c13.x);
    r0.z = dot(v4.xyz, v4.xyz);
    r0.w = dot(-(v3.xyz), -(v3.xyz));
    r4.w = rsqrt(r0.z);
    r6.w = rsqrt(r0.w);
    r0 = tex2D(s2, v6.xy);
    r10.xy = (v6.xy) * (c[23].xx);
    r1.xy = (r10.xy) * (c[26].xx);
    r3.xzw = (r4.zzz) * (c3.yzw);
    r2.xy = (c[28].xx) * (r3.xx) + (r1.xy);
    r2 = tex2D(s4, r2.xy);
    r1.xy = (c[27].xy) * (r3.xx) + (r1.xy);
    r1 = tex2D(s4, r1.xy);
    r0.w = (r2.x) + (r1.x);
    r0.z = (r0.w) + (r0.w);
    r0.w = saturate(r0.y);
    r0.z = (r4.z) * (-(c0.x)) + (r0.z);
    r1.w = (r0.z) + (c0.y);
    r0.xyz = c[24].xyz;
    r0.xyz = (-(r0.yzx)) + (c[25].yzx);
    r1.w = frac(r1.w);
    r5.xyz = (r0.www) * (r0.xyz) + (c[24].yzx);
    r0.w = (r1.w) + (c0.z);
    r0.z = frac(r5.y);
    r1.w = (abs(r0.w)) * (c0.w);
    r0.w = (r5.y) + (-(r0.z));
    r0.w = (r0.w) * (c15.y);
    r1.z = (r0.z) + (c0.z);
    r2.z = exp2(r0.w);
    r0.z = ((r1.z) >= 0.0f ? (c15.z) : (c15.w));
    r0.w = pow(abs(r1.w), c15.x);
    r2.w = (r2.z) * (r0.z);
    r1.w = lerp(c[29].x, c[29].y, r0.w);
    r3.x = (r10.x) * (r2.w) + (r3.y);
    r0.x = (r10.x) * (r2.z) + (r3.y);
    r0.z = (r10.y) * (r2.z);
    r0 = tex2D(s3, r0.xz);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0.xy = (r10.xy) * (r2.zz) + (r3.zw);
    r0 = tex2D(s3, r0.xy);
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1.xy = (r1.xy) * (r0.xy);
    r0.xy = (r10.xy) * (r2.ww) + (r3.zw);
    r0 = tex2D(s3, r0.xy);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r3.z = (r10.y) * (r2.w);
    r0 = tex2D(s3, r3.xz);
    r0.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0.xy = (r2.xy) * (r0.xy) + (-(r1.xy));
    r0.w = (abs(r1.z)) + (abs(r1.z));
    r2.w = (r5.x) * (r1.w);
    r2.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r10.xy);
    r4.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0.xy = (v6.zw) * (c14.xy);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v6.zw);
    r3.xy = (r1.xy) * (c14.ww);
    r5.xy = (r2.ww) * (r2.xy) + (r4.xy);
    r11.xy = (r0.xz) * (r3.xx);
    r2.x = r0.y;
    r0.w = (r1.x) * (c14.w) + (-(r11.x));
    r1.w = (r0.z) * (-(r3.x)) + (r0.w);
    r0.xy = (v6.zw) * (c14.xy) + (c14.zy);
    r0 = tex2D(s13, r0.xy);
    r2.y = r0.y;
    r7.y = (r1.w) + (r1.w);
    r4.xy = (r2.xy) * (c16.xx) + (c16.yy);
    r8.xy = (r3.yy) * (r0.xz);
    r2.xyz = (r4.yyy) * (v2.xyz);
    r0.w = (r1.y) * (c14.w) + (-(r8.x));
    r1.xyz = (r4.xxx) * (v1.xyz) + (r2.xyz);
    r0.w = (r0.z) * (-(r3.y)) + (r0.w);
    r0.xyz = (v4.xyz) * (r4.www) + (r1.xyz);
    r6.y = (r0.w) + (r0.w);
    r4.xyz = normalize(r0.xyz);
    r9.xyz = (r4.www) * (v4.xyz);
    r3 = (-(v3.yyyy)) + (c[6]);
    r2 = (-(v3.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r5.w = dot(r4.xyz, r9.xyz);
    r0 = (r1) * (r1) + (r0);
    r7.xz = (r11.xy) * (c12.yy);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r6.xz = (r8.xy) * (c12.yy);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r3.xyz = (r5.www) * (r6.xyz) + (r7.xyz);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.z = c13.y;
    r0 = saturate((r0) * (c[8]) + (r2.zzzz));
    r2.xyz = v4.xyz;
    r4.xyz = (r2.zxy) * (v1.yzx);
    r0 = (r1) * (r0);
    r2.xyz = (r2.yzx) * (v1.zxy) + (-(r4.xyz));
    r1.z = dot(c[11], r0);
    r2.xyz = (r5.yyy) * (-(r2.xyz));
    r1.x = dot(c[9], r0);
    r2.xyz = (r5.xxx) * (v1.xyz) + (r2.xyz);
    r1.y = dot(c[10], r0);
    r0.xyz = (r2.xyz) + (v4.xyz);
    r8.xyz = (r3.xyz) + (r1.xyz);
    r6.xyz = normalize(r0.xyz);
    r7.xyz = (r6.www) * (-(v3.xyz));
    r1.xyz = normalize(c[17].xyz);
    r5.w = saturate(dot(r6.xyz, r7.xyz));
    r0.xyz = (-(v3.xyz)) * (r6.www) + (r1.xyz);
    r6.w = saturate(dot(r9.xyz, r1.xyz));
    r9.xyz = normalize(r0.xyz);
    if ((c13.y) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c13.yyyz);
        r0 = (r1) + (-(c4.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c13.wwzz);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (-(c13.wwzz));
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c4.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c4.wwww);
        if ((c12.x) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c13.ww);
            r0.zw = (v0.zx) * (c13.yz);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (-(c13.ww));
            r1.zw = (v0.zx) * (c13.yz);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c4.xy);
            r1.zw = (v0.zx) * (c13.yz);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c4.xy));
            r1.zw = (v0.zx) * (c13.yz);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c4.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v0.w) * (c12.y) + (c12.z);
            r1.z = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r1.z = r4.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (c12.w);
        r1.w = ((r0.w) >= 0.0f ? (c13.z) : (c13.y));
        r0 = tex2D(s12, v6.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r5.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c13.ww);
            r1.zw = (v0.zz) * (c13.yz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r5.xy) + (-(c13.ww));
            r2.zw = (v0.zz) * (c13.yz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (c4.xy);
            r2.zw = (v0.zz) * (c13.yz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (-(c4.xy));
            r2.zw = (v0.zz) * (c13.yz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c4.wwww);
            r0.w = saturate((v0.w) + (c12.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r1.z = r0.w;
    }
    r1.w = saturate(dot(r6.xyz, r9.xyz));
    r0 = tex2D(s6, r10.xy);
    r2.xyz = (r1.zzz) * (c[18].xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r6.www) * (r2.xyz) + (r8.xyz);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r0.w = dot(-(r7.xyz), r6.xyz);
    r2.w = pow(abs(r1.w), c16.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = c[22].x;
    r0.xyz = (r6.xyz) * (-(r0.zzz)) + (-(r7.xyz));
    r0 = texCUBElod(s15, r0);
    r0.w = (-(r5.w)) + (c13.y);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r0.xyz) * (c16.www);
    r1.w = (r1.w) * (r1.w);
    r2.xyz = (r2.www) * (r2.xyz) + (r0.xyz);
    r1.w = (r0.w) * (r1.w);
    r0 = tex2D(s5, r10.xy);
    r2.w = (-(r0.x)) + (c13.y);
    r0.xyz = (r2.xyz) * (r5.zzz) + (-(r1.xyz));
    r0.w = saturate(lerp(r2.w, c13.y, r1.w));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v5.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v5.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c13.y;

    return oC0;
}
