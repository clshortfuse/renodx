// Mechanically reconstructed from 0x5ACAD056.ps_3_0.cso.
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
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD0;
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
    const float4 c0 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c4 = float4(-0.5f, 0.5f, 1e-15f, 1.44269502f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(0.200000003f, 5.0f, -2.0f, 3.0f);
    const float4 c14 = float4(31.875f, 0.100000001f, 8.0f, 0.0f);
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

    r0.xy = (v7.xy) + (c4.xx);
    r0.z = c4.y;
    r11.xy = (r0.xy) * (c[24].xx) + (r0.zz);
    r2.xy = ddx(r11.xy);
    r3.xy = ddy(r11.yx);
    r0.xy = ddy(v7.xy);
    r1.xy = (r2.yy) * (r0.xy);
    r0.xy = ddx(v7.xy);
    r1.xy = (r0.xy) * (r3.xx) + (-(r1.xy));
    r0.w = (r2.y) * (r3.y);
    r0.xyz = (r1.yyy) * (v3.xyz);
    r1.w = (r2.x) * (r3.x) + (-(r0.w));
    r1.xyz = (v2.xyz) * (r1.xxx) + (r0.xyz);
    r0 = tex2D(s1, v7.xy);
    r3.xy = (r0.wy) * (c12.xy) + (c12.zw);
    r0 = v2;
    r2.xyz = (r0.yzx) * (v5.zxy);
    r4.xy = (r3.xy) * (c[23].xx);
    r0.xyz = (v5.yzx) * (r0.zxy) + (-(r2.xyz));
    r3.xyz = float3(((r1.w) >= 0.0f ? (r1.x) : (-(r1.x))), ((r1.w) >= 0.0f ? (r1.y) : (-(r1.y))), ((r1.w) >= 0.0f ? (r1.z) : (-(r1.z))));
    r0.xyz = (r4.yyy) * (-(r0.xyz));
    r1.w = dot(-(v4.xyz), -(v4.xyz));
    r0.xyz = (r4.xxx) * (v2.xyz) + (r0.xyz);
    r7.w = rsqrt(r1.w);
    r0.xyz = (r0.xyz) + (v5.xyz);
    r10.xyz = normalize(v5.xyz);
    r1.w = dot(r0.xyz, r0.xyz);
    r9.xyz = (r7.www) * (-(v4.xyz));
    r5.w = rsqrt(r1.w);
    r1 = tex2D(s2, r11.xy);
    r2.xyz = (r0.xyz) * (r5.www);
    r1.z = dot(r3.xyz, r2.xyz);
    r3.xyz = (r1.zzz) * (-(r2.xyz)) + (r3.xyz);
    r5.xyz = normalize(r3.xyz);
    r3.xy = (r1.wy) * (c12.xy) + (c12.zw);
    r1.xyz = (r2.zxy) * (r5.yzx);
    r7.xy = (r3.xy) * (c[25].xx);
    r1.xyz = (r2.yzx) * (r5.zxy) + (-(r1.xyz));
    r6.xyz = (r7.yyy) * (-(r1.xyz));
    r4 = (-(v4.yyyy)) + (c[7]);
    r3 = (-(v4.xxxx)) + (c[6]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v4.zzzz)) + (c[8]);
    r5.xyz = (r7.xxx) * (r5.xyz) + (r6.xyz);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = (r0.xyz) * (r5.www) + (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r8.xyz = normalize(r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r8.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r8.xxxx) + (r4);
    r7.y = saturate(dot(r9.xyz, r10.xyz));
    r2 = saturate((r2) * (r8.zzzz) + (r3));
    r0.z = c0.x;
    r1 = saturate((r1) * (c[9]) + (r0.zzzz));
    r3.w = max(abs(r10.y), abs(r10.z));
    r1 = (r2) * (r1);
    r0.z = max(abs(r10.x), r3.w);
    r2.w = 1.0f / (r0.z);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r7.z = dot(c[20], r1);
    r0.xyz = (r0.xyz) * (r2.www) + (v1.xyz);
    r2 = tex3D(s11, r0.xyz);
    if ((c0.x) >= (v0.w))
    {
        r3 = (v0.xyzx) * (c0.xxxy);
        r2 = (r3) + (-(c3.xyzz));
        r2 = tex2Dlod(s0, r2);
        r2.w = r2.x;
        r4 = (r3) + (c0.zzyy);
        r4 = tex2Dlod(s0, r4);
        r2.x = r4.x;
        r4 = (r3) + (c0.wwyy);
        r4 = tex2Dlod(s0, r4);
        r2.y = r4.x;
        r3 = (r3) + (c3.xyzz);
        r3 = tex2Dlod(s0, r3);
        r2.z = r3.x;
        r0.z = dot(r2, c3.wwww);
        if ((c1.x) < (v0.w))
        {
            r0.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c0.zz);
            r2.zw = (v0.zx) * (c0.xy);
            r2 = tex2Dlod(s0, r2);
            r3.xy = (r0.xy) + (c0.ww);
            r3.zw = (v0.zx) * (c0.xy);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r0.xy) + (c3.xy);
            r3.zw = (v0.zx) * (c0.xy);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r0.xy) + (-(c3.xy));
            r3.zw = (v0.zx) * (c0.xy);
            r3 = tex2Dlod(s0, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c3.wwww);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v0.w) * (c1.y) + (c1.z);
            r4.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r4.w = r0.z;
        }
    }
    else
    {
        r0.z = (v0.w) + (c1.w);
        r0.z = ((r0.z) >= 0.0f ? (c0.y) : (c0.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c0.zz);
            r3.zw = (v0.zz) * (c0.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r0.xy) + (c0.ww);
            r4.zw = (v0.zz) * (c0.xy);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r0.xy) + (c3.xy);
            r4.zw = (v0.zz) * (c0.xy);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r0.xy) + (-(c3.xy));
            r4.zw = (v0.zz) * (c0.xy);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c3.wwww);
            r0.z = saturate((v0.w) + (c1.z));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r4.w = r0.z;
    }
    r5.w = saturate(dot(r9.xyz, r8.xyz));
    r2.w = max(abs(r8.y), abs(r8.z));
    r3.w = (r7.y) + (r5.w);
    r0.z = max(abs(r8.x), r2.w);
    r2.w = 1.0f / (r0.z);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r7.x = dot(c[10], r1);
    r0.xyz = (r0.xyz) * (r2.www) + (v1.xyz);
    r2 = tex3D(s11, r0.xyz);
    r3.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = normalize(c[17].xyz);
    r7.y = dot(c[11], r1);
    r1.w = dot(r4.xyz, r10.xyz);
    r0.xyz = (r4.www) * (c[18].xyz);
    r1.w = (r1.w) + (c13.x);
    r4.w = saturate((r1.w) * (c13.y));
    r2.xyz = (-(v4.xyz)) * (r7.www) + (r4.xyz);
    r2.w = saturate(dot(r8.xyz, r4.xyz));
    r1.xyz = normalize(r2.xyz);
    r1.w = dot(r1.xyz, r9.xyz);
    r2.y = saturate(dot(r1.xyz, r8.xyz));
    r1.z = 1.0f / (r1.w);
    r1.w = (r2.y) + (r2.y);
    r1.w = (r1.z) * (r1.w);
    r1.z = min(r5.w, r2.w);
    r1.y = (r4.w) * (r4.w);
    r1.w = saturate((r1.w) * (r1.z));
    r1.z = (r4.w) * (c13.z) + (c13.w);
    r1.w = (r2.w) * (r1.w);
    r1.z = (r1.y) * (r1.z);
    r1.w = rsqrt(r1.w);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r2.z = 1.0f / (r1.w);
    r1 = tex2D(s3, r11.xy);
    r1.w = (r1.x) * (r1.x);
    r1.z = (r2.y) * (r2.y) + (c4.z);
    r1.w = 1.0f / (r1.w);
    r1.y = 1.0f / (r1.z);
    r1.z = (r1.y) * (r1.y);
    r1.y = (-(r1.y)) + (c0.x);
    r1.y = (r1.w) * (r1.y);
    r2.y = (r3.w) * (c4.y);
    r1.x = (r1.y) * (c4.w);
    r1.y = max(c14.y, r2.y);
    r1.x = exp2(r1.x);
    r1.y = 1.0f / (r1.y);
    r1.z = (r1.z) * (r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = (r2.z) * (r1.z);
    r3.w = 1.0f / (r1.y);
    r2.z = dot(-(r9.xyz), r8.xyz);
    r1.xyz = (r0.xyz) * (r1.zzz);
    r2.z = (r2.z) + (r2.z);
    r4.xyz = (r1.www) * (r1.xyz);
    r1.w = c[22].x;
    r1.xyz = (r8.xyz) * (-(r2.zzz)) + (-(r9.xyz));
    r1 = texCUBElod(s15, r1);
    r2.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r4.xyz) * (c3.www);
    r2.xyz = (r2.xyz) * (c14.zzz);
    r3.xyz = (r3.xyz) * (c14.xxx) + (r7.xyz);
    r2.xyz = (r1.xyz) * (r3.www) + (r2.xyz);
    r1 = tex2D(s5, r11.xy);
    r1.xyz = (r1.xyz) * (c[26].xxx);
    r0.xyz = (r2.www) * (r0.xyz) + (r3.xyz);
    r2.xyz = (r2.xyz) * (r1.xyz);
    r1 = tex2D(s4, r11.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v6.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v6.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}
