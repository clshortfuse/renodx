// Mechanically reconstructed from 0x3FBBDEE8.ps_3_0.cso.
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
    const float4 c0 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(-0.5f, 0.5f, 1e-15f, 1.44269502f);
    const float4 c13 = float4(0.200000003f, 5.0f, -2.0f, 3.0f);
    const float4 c14 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c15 = float4(4.0f, -2.0f, 0.100000001f, 8.0f);
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
    float4 oC0 = 0.0f;

    r5.w = dot(-(v3.xyz), -(v3.xyz));
    if ((c0.x) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c0.xxxy);
        r0 = (r1) + (-(c3.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c0.zzyy);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (c0.wwyy);
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c3.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r6.w = dot(r0, c3.wwww);
        if ((c1.x) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c0.zz);
            r0.zw = (v0.zx) * (c0.xy);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (c0.ww);
            r1.zw = (v0.zx) * (c0.xy);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c3.xy);
            r1.zw = (v0.zx) * (c0.xy);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c3.xy));
            r1.zw = (v0.zx) * (c0.xy);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r6.w)) + (r0.w);
            r0.w = (v0.w) * (c1.y) + (c1.z);
            r6.w = (r0.w) * (r0.z) + (r6.w);
        }
    }
    else
    {
        r0.w = (v0.w) + (c1.w);
        r1.w = ((r0.w) >= 0.0f ? (c0.y) : (c0.x));
        r0 = tex2D(s12, v6.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r5.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c0.zz);
            r1.zw = (v0.zz) * (c0.xy);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r5.xy) + (c0.ww);
            r2.zw = (v0.zz) * (c0.xy);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (c3.xy);
            r2.zw = (v0.zz) * (c0.xy);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (-(c3.xy));
            r2.zw = (v0.zz) * (c0.xy);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c3.wwww);
            r0.w = saturate((v0.w) + (c1.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r6.w = r0.w;
    }
    r7.w = rsqrt(r5.w);
    r0.w = dot(v4.xyz, v4.xyz);
    r0.xy = (v6.xy) + (c12.xx);
    r3.w = rsqrt(r0.w);
    r0.z = c12.y;
    r10.xy = (r0.xy) * (c[23].xx) + (r0.zz);
    r1.xy = ddx(r10.xy);
    r2.xy = ddy(r10.yx);
    r0.xy = ddy(v6.xy);
    r0.z = (r1.y) * (r2.y);
    r1.w = (r1.x) * (r2.x) + (-(r0.z));
    r4.xy = (r1.yy) * (r0.xy);
    r0 = tex2D(s1, v6.xy);
    r3.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.xyz = v4.xyz;
    r1.xyz = (r0.zxy) * (v1.yzx);
    r3.xy = (r3.xy) * (c[22].xx);
    r0.xyz = (r0.yzx) * (v1.zxy) + (-(r1.xyz));
    r1.xy = ddx(v6.xy);
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r2.xy = (r1.xy) * (r2.xx) + (-(r4.xy));
    r1.xyz = (r3.xxx) * (v1.xyz) + (r0.xyz);
    r0.xyz = (r2.yyy) * (v2.xyz);
    r1.xyz = (r1.xyz) + (v4.xyz);
    r0.xyz = (v1.xyz) * (r2.xxx) + (r0.xyz);
    r0.w = dot(r1.xyz, r1.xyz);
    r2.xyz = float3(((r1.w) >= 0.0f ? (r0.x) : (-(r0.x))), ((r1.w) >= 0.0f ? (r0.y) : (-(r0.y))), ((r1.w) >= 0.0f ? (r0.z) : (-(r0.z))));
    r1.w = rsqrt(r0.w);
    r0 = tex2D(s2, r10.xy);
    r3.xyz = (r1.xyz) * (r1.www);
    r0.z = dot(r2.xyz, r3.xyz);
    r4.xyz = (r0.zzz) * (-(r3.xyz)) + (r2.xyz);
    r2.xyz = normalize(r4.xyz);
    r4.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.xyz = (r3.zxy) * (r2.yzx);
    r4.xy = (r4.xy) * (c[24].xx);
    r0.xyz = (r3.yzx) * (r2.zxy) + (-(r0.xyz));
    r5.xyz = (r3.www) * (v4.xyz);
    r0.xyz = (r4.yyy) * (-(r0.xyz));
    r7.xyz = (r7.www) * (-(v3.xyz));
    r0.xyz = (r4.xxx) * (r2.xyz) + (r0.xyz);
    r5.w = saturate(dot(r7.xyz, r5.xyz));
    r0.xyz = (r1.xyz) * (r1.www) + (r0.xyz);
    r6.xyz = normalize(r0.xyz);
    r0.xy = (v6.zw) * (c14.xy);
    r2 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v6.zw);
    r3.xy = (r1.xy) * (c14.ww);
    r12.xy = (r2.xz) * (r3.xx);
    r0.xy = (v6.zw) * (c14.xy) + (c14.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r0.w = (r1.x) * (c14.w) + (-(r12.x));
    r4.xy = (r2.yw) * (c15.xx) + (c15.yy);
    r4.z = (r2.z) * (-(r3.x)) + (r0.w);
    r2.xyz = (r4.yyy) * (v2.xyz);
    r11.xy = (r3.yy) * (r0.xz);
    r2.xyz = (r4.xxx) * (v1.xyz) + (r2.xyz);
    r0.w = (r1.y) * (c14.w) + (-(r11.x));
    r1.xyz = (v4.xyz) * (r3.www) + (r2.xyz);
    r4.w = (r0.z) * (-(r3.y)) + (r0.w);
    r0.xyz = normalize(r1.xyz);
    r8.w = dot(r0.xyz, r6.xyz);
    r3 = (-(v3.yyyy)) + (c[6]);
    r2 = (-(v3.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v3.zzzz)) + (c[7]);
    r9.y = (r4.z) + (r4.z);
    r0 = (r1) * (r1) + (r0);
    r8.y = (r4.w) + (r4.w);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r9.xz = (r12.xy) * (c1.yy);
    r3 = (r3) * (r4);
    r3 = (r6.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r6.xxxx) + (r3);
    r1 = saturate((r1) * (r6.zzzz) + (r2));
    r2.w = c0.x;
    r0 = saturate((r0) * (c[8]) + (r2.wwww));
    r8.xz = (r11.xy) * (c1.yy);
    r0 = (r1) * (r0);
    r3.xyz = (r8.www) * (r8.xyz) + (r9.xyz);
    r4.z = dot(c[11], r0);
    r4.x = dot(c[9], r0);
    r2.xyz = normalize(c[17].xyz);
    r4.y = dot(c[10], r0);
    r0.w = dot(r2.xyz, r5.xyz);
    r0.xyz = (r6.www) * (c[18].xyz);
    r0.w = (r0.w) + (c13.x);
    r6.w = saturate((r0.w) * (c13.y));
    r5.xyz = (-(v3.xyz)) * (r7.www) + (r2.xyz);
    r3.w = (r6.w) * (r6.w);
    r1.xyz = normalize(r5.xyz);
    r1.w = saturate(dot(r6.xyz, r2.xyz));
    r0.w = dot(r1.xyz, r7.xyz);
    r2.w = saturate(dot(r7.xyz, r6.xyz));
    r2.y = saturate(dot(r1.xyz, r6.xyz));
    r1.z = 1.0f / (r0.w);
    r0.w = (r2.y) + (r2.y);
    r0.w = (r1.z) * (r0.w);
    r4.w = min(r2.w, r1.w);
    r1.z = (r6.w) * (c13.z) + (c13.w);
    r0.w = saturate((r0.w) * (r4.w));
    r1.z = (r3.w) * (r1.z);
    r0.w = (r1.w) * (r0.w);
    r1.xyz = (r0.xyz) * (r1.zzz);
    r0.w = rsqrt(r0.w);
    r2.z = (r5.w) + (r2.w);
    r2.w = 1.0f / (r0.w);
    r0 = tex2D(s3, r10.xy);
    r0.w = (r0.x) * (r0.x);
    r0.z = (r2.y) * (r2.y) + (c12.z);
    r0.w = 1.0f / (r0.w);
    r0.y = 1.0f / (r0.z);
    r0.z = (r0.y) * (r0.y);
    r0.y = (-(r0.y)) + (c0.x);
    r0.y = (r0.w) * (r0.y);
    r2.z = (r2.z) * (c12.y);
    r0.x = (r0.y) * (c12.w);
    r0.y = max(c15.z, r2.z);
    r0.x = exp2(r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = (r0.z) * (r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = (r2.w) * (r0.z);
    r2.w = 1.0f / (r0.y);
    r2.z = dot(-(r7.xyz), r6.xyz);
    r0.xyz = (r1.xyz) * (r0.zzz);
    r2.z = (r2.z) + (r2.z);
    r5.xyz = (r0.www) * (r0.xyz);
    r0.w = c[21].x;
    r0.xyz = (r6.xyz) * (-(r2.zzz)) + (-(r7.xyz));
    r0 = texCUBElod(s15, r0);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r5.xyz) * (c3.www);
    r2.xyz = (r2.xyz) * (c15.www);
    r3.xyz = (r3.xyz) + (r4.xyz);
    r2.xyz = (r0.xyz) * (r2.www) + (r2.xyz);
    r0 = tex2D(s5, r10.xy);
    r0.xyz = (r0.xyz) * (c[25].xxx);
    r1.xyz = (r1.www) * (r1.xyz) + (r3.xyz);
    r2.xyz = (r2.xyz) * (r0.xyz);
    r0 = tex2D(s4, r10.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v5.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v5.xyz);
    r0.xyz = max(((r0.xyz) * (c[20].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}
