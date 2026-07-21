// Mechanically reconstructed from 0xBA3F68BD.ps_3_0.cso.
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
    float4 oC0 = 0.0f;

    r0.xy = (v5.zw) * (c15.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v5.zw) * (c15.xy) + (c15.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xyz = v4.xyz;
    r3.xyz = (r1.zxy) * (v1.yzx);
    r2.w = r0.y;
    r1.xyz = (r1.yzx) * (v1.zxy) + (-(r3.xyz));
    r3.xy = (r2.yw) * (c16.xx) + (c16.yy);
    r4.xyz = (r1.xyz) * (v1.www);
    r0.w = dot(v4.xyz, v4.xyz);
    r1.xyz = (r3.yyy) * (r4.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = (r3.xxx) * (v1.xyz) + (r1.xyz);
    r5.xyz = (v4.xyz) * (r0.www) + (r1.xyz);
    r1 = tex2D(s14, v5.zw);
    r7.xy = (r1.xy) * (c15.ww);
    r3.xyz = normalize(r5.xyz);
    r6.xy = (r2.xz) * (r7.xx);
    r9.xyz = normalize(-(v3.xyz));
    r0.w = (r1.x) * (c15.w) + (-(r6.x));
    r1.w = dot(r3.xyz, r9.xyz);
    r3.w = (r2.z) * (-(r7.x)) + (r0.w);
    r2 = tex2D(s3, v5.xy);
    r8.xy = (r2.wy) * (c12.xy) + (c12.zw);
    r5.xy = (r0.xz) * (r7.yy);
    r2.xyz = (r4.xyz) * (r8.yyy);
    r0.w = (r1.y) * (c15.w) + (-(r5.x));
    r1.xyz = (r8.xxx) * (v1.xyz) + (r2.xyz);
    r0.w = (r0.z) * (-(r7.y)) + (r0.w);
    r0.xyz = (r1.xyz) + (v4.xyz);
    r1.y = (r3.w) + (r3.w);
    r7.xyz = normalize(r0.xyz);
    r0.y = (r0.w) + (r0.w);
    r0.w = dot(r9.xyz, r7.xyz);
    r1.xz = (r6.xy) * (c14.yy);
    r0.w = (r0.w) * (-(r0.w)) + (c1.w);
    r0.xz = (r5.xy) * (c14.yy);
    r0.w = rsqrt(r0.w);
    r2.xyz = (r1.www) * (r0.xyz) + (r1.xyz);
    r1.w = 1.0f / (r0.w);
    r0.w = dot(r3.xyz, r7.xyz);
    r5.w = saturate((r1.w) * (c13.w));
    r2.xyz = (r2.xyz) * (r5.www);
    r3.xy = (v5.xy) + (c3.xx);
    r1.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.z = c3.y;
    r0.xy = (r3.xy) * (c[9].xy) + (r0.zz);
    r0 = tex2D(s1, r0.xy);
    r3.xy = (r0.xy) * (c[10].xx);
    r6.xyz = (r1.xyz) * (c14.xxx) + (r2.xyz);
    r0.w = (r3.y) * (c3.z) + (c3.y);
    r0.xyz = ddy(v5.xyx);
    r0.w = frac(r0.w);
    r2.xyz = (r0.xyy) * (r0.xyz);
    r1.w = (r0.w) * (c1.x) + (c1.y);
    r1.xyz = ddx(v5.xyx);
    r0.xy = float2(cos(r1.w), sin(r1.w));
    r0.w = (r3.x) * (r3.x);
    r0.xyz = (r0.xyx) * (r0.xyy);
    r1.xyz = (r1.xyz) * (r1.xyy) + (r2.xyz);
    r0.z = (r0.w) * (r0.z);
    r0.xy = (r0.ww) * (r0.xy) + (r0.ww);
    r5.xyz = (r0.xyz) * (c3.www) + (r1.xyz);
    r8.xyz = normalize(c[17].xyz);
    if ((c1.w) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c1.wwwz);
        r0 = (r1) + (-(c13.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c4.zzww);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (-(c4.zzww));
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c13.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c13.wwww);
        if ((c14.x) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c4.zz);
            r0.zw = (v0.zx) * (c1.wz);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (-(c4.zz));
            r1.zw = (v0.zx) * (c1.wz);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c13.xy);
            r1.zw = (v0.zx) * (c1.wz);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c13.xy));
            r1.zw = (v0.zx) * (c1.wz);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c13.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v0.w) * (c14.y) + (c14.z);
            r0.z = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r0.z = r4.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (c14.w);
        r1.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.w));
        r0 = tex2D(s12, v5.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r10.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r10.xy) + (c4.zz);
            r1.zw = (v0.zz) * (c1.wz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r10.xy) + (-(c4.zz));
            r2.zw = (v0.zz) * (c1.wz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r10.xy) + (c13.xy);
            r2.zw = (v0.zz) * (c1.wz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r10.xy) + (-(c13.xy));
            r2.zw = (v0.zz) * (c1.wz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c13.wwww);
            r0.w = saturate((v0.w) + (c14.z));
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
    r0.w = saturate(dot(r7.xyz, r8.xyz));
    r1.xyz = (r5.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r2.w = (-(r5.x)) + (r5.y);
    r0.xyz = (r0.xyz) * (c14.xxx) + (r1.xyz);
    r2.xyz = (r6.xyz) + (r0.xyz);
    r0.xy = frac(v5.xy);
    r0.w = dot(v2.xyz, v2.xyz);
    r3.xy = (r0.xy) + (c3.xx);
    r0.z = 1.0f / (r0.w);
    r0.y = dot(r3.xy, r3.xy) + (c3.x);
    r1.w = (r0.w) * (r0.y);
    r0.x = rsqrt(r5.x);
    r0.y = rsqrt(r5.y);
    r0.w = dot(v2.xy, r3.xy) + (c1.z);
    r1.x = 1.0f / (r0.x);
    r1.y = 1.0f / (r0.y);
    r0.w = (r0.w) * (r0.w) + (-(r1.w));
    r0.y = (r1.y) * (r1.x);
    r0.w = rsqrt(r0.w);
    r0.y = 1.0f / (r0.y);
    r0.w = 1.0f / (r0.w);
    r0.y = (r5.z) * (r0.y);
    r0.w = dot(v2.xy, -(r3.xy)) + (r0.w);
    r0.x = ((-abs(r5.z)) >= 0.0f ? (c1.z) : (r0.y));
    r1.w = (r0.z) * (r0.w);
    r0.w = (r0.x) * (-(r0.x)) + (c1.w);
    r4.xy = (v2.xy) * (r1.ww) + (r3.xy);
    r0.w = rsqrt(r0.w);
    r0.z = 1.0f / (r0.w);
    r0.yw = c1.wz;
    r0 = float4(((r2.w) >= 0.0f ? (r0.x) : (r0.y)), ((r2.w) >= 0.0f ? (r0.y) : (r0.x)), ((r2.w) >= 0.0f ? (r0.z) : (r0.w)), ((r2.w) >= 0.0f ? (r0.w) : (r0.z)));
    r5.xy = (r1.ww) * (v2.xy);
    r3.xy = ddy(r5.xy);
    r5.xy = ddx(r5.xy);
    r3.xy = (r1.xy) * (r0.zw) + (r3.xy);
    r1.xy = (r1.xy) * (r0.xy) + (r5.xy);
    r0.xy = (r4.xy) * (c[11].xy);
    r1.xy = (r1.xy) * (c[11].xy);
    r3.xy = (r3.xy) * (c[11].xy);
    r1.xy = (r1.xy) * (c4.xx);
    r3.xy = (r3.xy) * (c4.xx);
    r0.xy = (r0.xy) * (c4.xx) + (c4.yy);
    r1 = tex2Dgrad(s2, r0.xy, r1.xy, r3.xy);
    r0 = tex2D(s4, v5.xy);
    r0.xyz = saturate((r2.xyz) * (r0.xyz));
    r2.xyz = (r1.xyz) * (-(c[20].xyz)) + (r0.xyz);
    r0.xyz = normalize(v3.xyz);
    r1.xyz = (r1.xyz) * (c[20].xyz);
    r0.z = dot(c[5].xyz, r0.xyz);
    r2.w = saturate((c[7].y) * (r0.z) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r0.www) * (r2.xyz) + (r1.xyz);
    r0.xyz = (r2.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r1.x = c1.w;
    r1.w = (r1.w) * (-(c[20].w)) + (r1.x);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
