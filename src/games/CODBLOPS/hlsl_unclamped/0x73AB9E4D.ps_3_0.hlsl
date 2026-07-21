// Mechanically reconstructed from 0x73AB9E4D.ps_3_0.cso.
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
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
sampler2D s8 : register(s8);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
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
    const float4 c0 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c1 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c4 = float4(60.0f, -50.0f, 1.70000005f, 0.100000001f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(0.200000003f, -0.5f, 0.5f, 0.00400000019f);
    const float4 c14 = float4(-31.7392902f, 0.769999981f, 0.370000005f, 9.99999975e-06f);
    const float4 c15 = float4(1e-15f, 1.44269502f, 8.0f, 31.875f);
    const float4 c16 = float4(3.5f, 1.0f, -5.5f, 30.0f);
    const float4 c27 = float4(2.0f, -1.0f, 0.0043394831f, 230.442184f);
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

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.zxy);
    r1.xyz = (r0.yzw) * (v3.yzx);
    r1.xyz = (r0.wyz) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r1.w = max(abs(r0.w), abs(r0.y));
    r2.x = max(abs(r0.z), r1.w);
    r2.yzw = (r0.zwy) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r2.xyz = (r2.yzw) * (r1.www) + (v6.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c1.x) >= (v7.w))
    {
        r3 = (v7.xyzx) * (c1.xxxy) + (c1.zzzx);
        r3 = (r3) * (c1.xxxy);
        r4 = (r3) + (c1.wwyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c1.wwyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c3.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c3.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r1.w = dot(r4, c3.wwww);
        if ((c0.x) < (v7.w))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zx) * (c1.xy) + (c1.zx);
            r3 = (r3) * (c1.xxxy);
            r4 = (r3) + (c1.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c1.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c3.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c3.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c3.wwww);
            r2.y = (v7.w) * (c0.y) + (c0.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c0.w) + (v7.w);
        r2.x = ((r2.x) >= 0.0f ? (c1.y) : (c1.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zz) * (c1.xy) + (c1.zx);
            r3 = (r3) * (c1.xxxy);
            r4 = (r3) + (c1.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c1.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c3.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c3.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c3.wwww);
            r2.y = saturate((c0.z) + (v7.w));
            r1.w = lerp(r2.x, r2.w, r2.y);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = (r1.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r5 = tex2D(s4, v5.xy);
    r5 = (r5.wxyz) * (r5.wxyz);
    r6 = c4;
    r1.w = (c[7].z) * (r6.x) + (r6.y);
    r2.w = (c[23].x) * (r6.z) + (r6.w);
    r3.w = (r5.x) * (c13.x);
    r4.w = (r5.x) * (-(c4.y)) + (r1.w);
    r4.w = (r4.w) + (c13.y);
    r2.w = saturate((r2.w) * (r4.w) + (c13.z));
    r6 = tex2D(s3, v5.xy);
    r6.xy = (r6.wy) * (c12.xy) + (c12.zw);
    r6.xy = (r6.xy) * (c13.zz) + (c13.zz);
    r6.xy = (r6.xy) * (c27.xx) + (c27.yy);
    r6.zw = (c[24].xy) * (v5.xy);
    r7 = tex2D(s2, r6.zw);
    r7.xy = (r7.wy) * (c12.xy) + (c12.zw);
    r7.xy = (r7.xy) * (c13.zz) + (c13.zz);
    r7.xy = (r7.xy) * (c27.xx) + (c27.yy);
    r6.xy = (r2.ww) * (r7.xy) + (r6.xy);
    r1.xyz = (r1.xyz) * (r6.yyy);
    r1.xyz = (r6.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r7.xyz = normalize(r1.xyz);
    r0.x = saturate((r1.w) * (c13.w) + (r3.w));
    r1.x = pow(abs(r0.x), c27.z);
    r0.x = (-(r0.x)) + (c1.x);
    r1.y = pow(abs(r0.x), c27.w);
    r0.x = (-(r1.y)) + (c1.x);
    r0.x = (r1.x) * (r0.x);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r0.x) + (c13.y);
    r0.x = (r0.x) * (r0.x);
    r0.x = (r0.x) * (c14.x);
    r0.x = exp2(r0.x);
    r0.x = (r0.x) + (c13.y);
    r0.x = (r0.x) * (c14.y) + (c14.z);
    r1.x = max(r0.x, c1.y);
    r1.yzw = (r2.xyz) * (c[6].xxx);
    r0.x = saturate(dot(r7.xyz, r4.xyz));
    r2.xyz = (r3.xyz) * (c[6].yyy);
    r3 = tex2D(s8, v5.xy);
    r8 = tex2D(s5, r6.zw);
    r3.y = (r8.w) * (r3.x) + (-(r3.x));
    r3.x = (r2.w) * (r3.y) + (r3.x);
    r4.w = max(c14.w, r3.x);
    r3.y = dot(-(v1.xyz), -(v1.xyz));
    r3.y = rsqrt(r3.y);
    r9.xyz = (r3.yyy) * (-(v1.xyz));
    r3.z = saturate(dot(r7.xyz, r9.xyz));
    r3.w = (r4.w) * (r4.w);
    r3.w = 1.0f / (r3.w);
    r10.xyz = (-(v1.xyz)) * (r3.yyy) + (r4.xyz);
    r11.xyz = normalize(r10.xyz);
    r3.y = saturate(dot(r7.xyz, r11.xyz));
    r4.w = (r3.y) * (r3.y) + (c15.x);
    r4.w = 1.0f / (r4.w);
    r5.x = (-(r4.w)) + (c1.x);
    r5.x = (r3.w) * (r5.x);
    r5.x = (r5.x) * (c15.y);
    r5.x = exp2(r5.x);
    r4.w = (r4.w) * (r4.w);
    r4.w = (r5.x) * (r4.w);
    r3.y = (r3.y) + (r3.y);
    r5.x = 1.0f / (r3.z);
    r3.y = (r3.y) * (r5.x);
    r5.x = min(r3.z, r0.x);
    r3.y = saturate((r3.y) * (r5.x));
    r3.y = (r0.x) * (r3.y);
    r3.y = rsqrt(r3.y);
    r3.y = 1.0f / (r3.y);
    r3.y = (r4.w) * (r3.y);
    r2.xyz = (r2.xyz) * (r3.yyy);
    r0.z = saturate(dot(r0.zwy, r9.xyz));
    r0.z = (r3.z) + (r0.z);
    r0.z = (r0.z) * (c13.z);
    r3.y = max(c4.w, r0.z);
    r0.z = 1.0f / (r3.y);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r0.z = (r3.w) * (c3.w);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r10.xyz = normalize(v1.xyz);
    r0.z = dot(r10.xyz, r7.xyz);
    r0.w = (r0.z) + (r0.z);
    r10.xyz = (r7.xyz) * (-(r0.www)) + (r10.xyz);
    r10.w = (r3.x) * (c15.z);
    r3 = texCUBElod(s15, r10);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c15.zzz);
    r10 = tex3D(s11, v6.xyz);
    r10.xyz = (r10.xyz) * (r10.xyz);
    r3.xyz = (r3.xyz) * (r10.xyz);
    r3.xyz = (r3.xyz) * (c[22].xxx);
    r3.xyz = (r3.xyz) * (c15.www);
    r10 = tex2D(s6, v5.xy);
    r8 = (r2.wwww) * (r8) + (r10);
    r0.z = saturate(r0.z);
    r0.z = (-(r0.z)) + (c1.x);
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r8.w) * (c16.x) + (c16.y);
    r0.w = 1.0f / (r0.w);
    r0.z = (r0.z) * (r0.w);
    r10.xyz = lerp(r8.xyz, c1.xxx, r0.zzz);
    r3.xyz = (r3.xyz) * (r10.xyz);
    r2.xyz = (r2.xyz) * (c3.www) + (r3.xyz);
    r2.xyz = (c[7].xxx) * (-(r2.xyz)) + (r2.xyz);
    r0.z = max(abs(r7.y), abs(r7.z));
    r3.x = max(abs(r7.x), r0.z);
    r3.yzw = (r7.xyz) * (c[5].xyz);
    r0.z = 1.0f / (r3.x);
    r3.xyz = (r3.yzw) * (r0.zzz) + (v6.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r5.x = c[6].x;
    r10.xyz = (r5.xxx) * (c[18].xyz);
    r0.z = dot(-(r4.xyz), r7.xyz);
    r0.z = (r0.z) + (r0.z);
    r7.xyz = (r7.xyz) * (-(r0.zzz)) + (-(r4.xyz));
    r0.z = dot(r4.xyz, -(r9.xyz));
    r0.z = saturate((r0.z) * (c13.z) + (c13.z));
    r0.z = (r0.z) + (r0.z);
    r0.z = (r0.z) * (r0.z);
    r0.w = (r0.z) * (c[26].x);
    r0.z = (r0.z) * (c16.z) + (c16.w);
    r0.w = (r0.w) * (c3.w);
    r4.x = saturate(dot(r7.xyz, r9.xyz));
    r5.x = pow(abs(r4.x), r0.z);
    r4.xyz = max(r10.xyz, c1.xxx);
    r4.xyz = (r5.xxx) * (r4.xyz);
    r4.xyz = (r0.www) * (r4.xyz);
    r0.y = saturate(r0.y);
    r0.y = (r3.w) * (r0.y);
    r0.yzw = (r4.xyz) * (r0.yyy);
    r0.yzw = (r3.xyz) * (c15.www) + (r0.yzw);
    r3.xyz = (r5.yzw) * (v4.xyz);
    r4 = tex2D(s7, r6.zw);
    r4 = (r4.wxyz) * (r4.wxyz);
    r6.xyz = (r5.yzw) * (v4.xyz) + (-(r4.yzw));
    r4.xyz = (r4.xxx) * (r6.xyz) + (r4.yzw);
    r4.xyz = (r5.yzw) * (-(v4.xyz)) + (r4.xyz);
    r3.xyz = (r2.www) * (r4.xyz) + (r3.xyz);
    r0.xyz = (r0.xxx) * (r1.yzw) + (r0.yzw);
    r1.yzw = (r8.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.yzw);
    r1.yzw = max(r0.xyz, c1.yyy);
    r0.xyz = (r1.xxx) * (c[25].xyz) + (r1.yzw);
    r1 = c[8];
    r0.w = (r1.w) * (c[21].x);
    r2.xyz = lerp(c1.xxx, r1.xyz, r0.www);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.w = c1.x;
    r1.x = dot(r0, c[10]);
    r1.y = dot(r0, c[11]);
    r1.z = dot(r0, c[20]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
