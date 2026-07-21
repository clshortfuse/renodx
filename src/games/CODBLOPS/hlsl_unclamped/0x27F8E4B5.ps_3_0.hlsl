// Mechanically reconstructed from 0x27F8E4B5.ps_3_0.cso.
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
    const float4 c15 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c16 = float4(1.0f, 0.5f, 0.0f, 31.875f);
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
    float4 oC0 = 0.0f;

    r0.xy = frac(v7.xy);
    r0.xy = (r0.xy) + (c0.xx);
    r0.z = dot(v3.xyz, v3.xyz);
    r0.w = dot(r0.xy, r0.xy) + (c0.x);
    r1.w = (r0.z) * (r0.w);
    r0.w = dot(v3.xy, r0.xy) + (c0.y);
    r0.w = (r0.w) * (r0.w) + (-(r1.w));
    r0.w = rsqrt(r0.w);
    r1.w = dot(v5.xyz, v5.xyz);
    r0.w = 1.0f / (r0.w);
    r0.z = 1.0f / (r0.z);
    r0.w = dot(v3.xy, -(r0.xy)) + (r0.w);
    r1.w = rsqrt(r1.w);
    r0.w = (r0.z) * (r0.w);
    r0.xy = (v3.xy) * (r0.ww) + (r0.xy);
    r1.xy = c1.xy;
    r0.w = (c[8].x) * (r1.x) + (r1.y);
    r12.xy = (r0.xy) * (c[7].xy);
    r0.w = frac(r0.w);
    r1.z = (r0.w) * (c1.z) + (c1.w);
    r0.xy = (v7.zw) * (c16.xy);
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v7.zw) * (c16.xy) + (c16.zy);
    r0 = tex2D(s13, r0.xy);
    r3.w = r0.y;
    r2.xy = float2(cos(r1.z), sin(r1.z));
    r5.xy = (r3.yw) * (c15.xx) + (c15.yy);
    r4.xy = (r2.yx) * (c3.xy);
    r1.xyz = (r5.yyy) * (v2.xyz);
    r11.xy = (r12.xy) * (c0.zz);
    r1.xyz = (r5.xxx) * (v1.xyz) + (r1.xyz);
    r10.y = dot(r4.xy, r11.xy) + (c0.y);
    r5.xyz = (v5.xyz) * (r1.www) + (r1.xyz);
    r1 = tex2D(s14, v7.zw);
    r7.xy = (r1.xy) * (c16.ww);
    r4.xyz = normalize(r5.xyz);
    r6.xy = (r3.xz) * (r7.xx);
    r9.xyz = normalize(-(v4.xyz));
    r0.w = (r1.x) * (c16.w) + (-(r6.x));
    r1.w = dot(r4.xyz, r9.xyz);
    r2.w = (r3.z) * (-(r7.x)) + (r0.w);
    r3 = tex2D(s4, v7.xy);
    r8.xy = (r3.wy) * (c4.xy) + (c4.zw);
    r5.xy = (r0.xz) * (r7.yy);
    r3.xyz = (r8.yyy) * (v2.xyz);
    r0.w = (r1.y) * (c16.w) + (-(r5.x));
    r1.xyz = (r8.xxx) * (v1.xyz) + (r3.xyz);
    r0.w = (r0.z) * (-(r7.y)) + (r0.w);
    r0.xyz = (r1.xyz) + (v5.xyz);
    r3.y = (r2.w) + (r2.w);
    r7.xyz = normalize(r0.xyz);
    r0.y = (r0.w) + (r0.w);
    r0.w = dot(r9.xyz, r7.xyz);
    r3.xz = (r6.xy) * (c13.yy);
    r0.w = (r0.w) * (-(r0.w)) + (c3.y);
    r0.xz = (r5.xy) * (c13.yy);
    r0.w = rsqrt(r0.w);
    r1.xyz = (r1.www) * (r0.xyz) + (r3.xyz);
    r1.w = 1.0f / (r0.w);
    r0.w = dot(r4.xyz, r7.xyz);
    r2.w = saturate((r1.w) * (c12.w));
    r1.xyz = (r1.xyz) * (r2.www);
    r0.xyz = (r0.www) * (r0.xyz) + (r3.xyz);
    r6.xyz = (r0.xyz) * (c13.xxx) + (r1.xyz);
    r8.xyz = normalize(c[17].xyz);
    if ((c3.y) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c3.yyyw);
        r0 = (r1) + (-(c12.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r3 = (r1) + (c14.zzww);
        r3 = tex2Dlod(s0, r3);
        r0.x = r3.x;
        r3 = (r1) + (-(c14.zzww));
        r3 = tex2Dlod(s0, r3);
        r0.y = r3.x;
        r1 = (r1) + (c12.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r2.z = dot(r0, c12.wwww);
        if ((c13.x) < (v0.w))
        {
            r5.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r5.xy) + (c14.zz);
            r0.zw = (v0.zx) * (c3.yw);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r5.xy) + (-(c14.zz));
            r1.zw = (v0.zx) * (c3.yw);
            r4 = tex2Dlod(s0, r1);
            r1.xy = (r5.xy) + (c12.xy);
            r1.zw = (v0.zx) * (c3.yw);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r5.xy) + (-(c12.xy));
            r1.zw = (v0.zx) * (c3.yw);
            r1 = tex2Dlod(s0, r1);
            r0.y = r4.x;
            r0.z = r3.x;
            r0.w = r1.x;
            r0.w = dot(r0, c12.wwww);
            r0.z = (-(r2.z)) + (r0.w);
            r0.w = (v0.w) * (c13.y) + (c13.z);
            r0.z = (r0.w) * (r0.z) + (r2.z);
        }
        else
        {
            r0.z = r2.z;
        }
    }
    else
    {
        r0.w = (v0.w) + (c13.w);
        r1.w = ((r0.w) >= 0.0f ? (c3.w) : (c3.y));
        r0 = tex2D(s12, v7.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r13.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r13.xy) + (c14.zz);
            r1.zw = (v0.zz) * (c3.yw);
            r1 = tex2Dlod(s0, r1);
            r3.xy = (r13.xy) + (-(c14.zz));
            r3.zw = (v0.zz) * (c3.yw);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r13.xy) + (c12.xy);
            r3.zw = (v0.zz) * (c3.yw);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r13.xy) + (-(c12.xy));
            r3.zw = (v0.zz) * (c3.yw);
            r3 = tex2Dlod(s0, r3);
            r1.y = r5.x;
            r1.z = r4.x;
            r1.w = r3.x;
            r0.x = dot(r1, c12.wwww);
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
    r0.w = saturate(dot(r9.xyz, r8.xyz));
    r0.xyz = (r0.zzz) * (c[18].xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r3.yzw = c3.yzw;
    r0.w = (r3.z) * (c[5].w);
    r1.xyz = (r2.www) * (r1.xyz);
    r0.w = frac(abs(r0.w));
    r1.w = saturate(dot(r7.xyz, r8.xyz));
    r0.w = ((c[5].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.xyz = (r0.xyz) * (r1.www);
    r0.w = (r0.w) * (c[9].x);
    r1.xyz = (r0.xyz) * (c13.xxx) + (r1.xyz);
    r0.xy = (r0.ww) * (c14.xy);
    r0 = tex2D(s2, r0.xy);
    r0.w = saturate(r0.x);
    r0.z = c[11].x;
    r0.y = (c[10].x) * (-(r0.z)) + (r0.z);
    r4.xyz = (r6.xyz) + (r1.xyz);
    r0.w = (r0.w) * (r0.y);
    r1.xy = (r12.xy) * (c0.zz) + (c0.ww);
    r2.w = (c[10].x) * (r0.z) + (r0.w);
    r0 = tex2D(s5, v7.xy);
    r0.xyz = saturate((r4.xyz) * (r0.xyz));
    r10.x = dot(r2.xy, r11.xy) + (c0.y);
    r1.zw = (r3.wy) * (c[20].xx);
    r1 = tex2Dbias(s3, r1);
    r1 = (r2.wwww) * (r1);
    r3.xy = (r10.xy) + (c0.ww);
    r2 = (r1) * (c[21]);
    r1 = tex2D(s1, r3.xy);
    r0.xyz = (r1.xyz) * (-(r2.xyz)) + (r0.xyz);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v6.xyz));
    r1.x = v1.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v6.xyz);
    r1.w = (r1.w) * (-(r2.w)) + (c3.y);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
