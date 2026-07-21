// Mechanically reconstructed from 0x1CBDCAA5.ps_3_0.cso.
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
    const float4 c0 = float4(31.875f, 3.5f, 1.0f, 0.0f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(60.0f, -50.0f, 1.70000005f, 0.100000001f);
    const float4 c14 = float4(0.5f, 2.0f, -1.0f, 50.0f);
    const float4 c15 = float4(9.99999975e-06f, 1e-15f, 1.44269502f, 8.0f);
    const float4 c16 = float4(-5.5f, 30.0f, 0.0f, 0.0f);
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
    if ((c3.x) >= (v7.w))
    {
        r3 = (v7.xyzx) * (c3.xxxy) + (c3.zzzx);
        r3 = (r3) * (c3.xxxy);
        r4 = (r3) + (c3.wwyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c3.wwyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c4.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c4.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r1.w = dot(r4, c4.wwww);
        if ((c1.x) < (v7.w))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zx) * (c3.xy) + (c3.zx);
            r3 = (r3) * (c3.xxxy);
            r4 = (r3) + (c3.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c3.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c4.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c4.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c4.wwww);
            r2.y = (v7.w) * (c1.y) + (c1.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c1.w) + (v7.w);
        r2.x = ((r2.x) >= 0.0f ? (c3.y) : (c3.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zz) * (c3.xy) + (c3.zx);
            r3 = (r3) * (c3.xxxy);
            r4 = (r3) + (c3.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c3.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c4.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c4.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c4.wwww);
            r2.y = saturate((c1.z) + (v7.w));
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
    r5 = tex2D(s2, v5.xy);
    r5.xy = (r5.wy) * (c12.xy) + (c12.zw);
    r5.xy = (r5.xy) * (c14.xx) + (c14.xx);
    r5.xy = (r5.xy) * (c14.yy) + (c14.zz);
    r1.xyz = (r1.xyz) * (r5.yyy);
    r1.xyz = (r5.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[6].xxx);
    r0.x = saturate(dot(r5.xyz, r4.xyz));
    r2.xyz = (r3.xyz) * (c[6].yyy);
    r3 = tex2D(s5, v5.xy);
    r6 = c13;
    r1.w = (c[7].y) * (r6.x) + (r6.y);
    r2.w = (c[22].x) * (r6.z) + (r6.w);
    r1.w = (r3.x) * (c14.w) + (r1.w);
    r3.x = saturate(lerp(c14.x, r1.w, r2.w));
    r6 = tex2D(s7, v5.xy);
    r3.yz = (c[25].xx) * (v5.xy);
    r7 = tex2D(s3, r3.yz);
    r1.w = (r7.w) * (r6.x) + (-(r6.x));
    r1.w = (r3.x) * (r1.w) + (r6.x);
    r2.w = max(c15.x, r1.w);
    r3.y = dot(-(v1.xyz), -(v1.xyz));
    r3.y = rsqrt(r3.y);
    r6.xyz = (r3.yyy) * (-(v1.xyz));
    r3.z = saturate(dot(r5.xyz, r6.xyz));
    r2.w = (r2.w) * (r2.w);
    r2.w = 1.0f / (r2.w);
    r8.xyz = (-(v1.xyz)) * (r3.yyy) + (r4.xyz);
    r9.xyz = normalize(r8.xyz);
    r3.y = saturate(dot(r5.xyz, r9.xyz));
    r3.w = (r3.y) * (r3.y) + (c15.y);
    r3.w = 1.0f / (r3.w);
    r4.w = (-(r3.w)) + (c3.x);
    r4.w = (r2.w) * (r4.w);
    r4.w = (r4.w) * (c15.z);
    r4.w = exp2(r4.w);
    r3.w = (r3.w) * (r3.w);
    r3.w = (r4.w) * (r3.w);
    r3.y = (r3.y) + (r3.y);
    r4.w = 1.0f / (r3.z);
    r3.y = (r3.y) * (r4.w);
    r4.w = min(r3.z, r0.x);
    r3.y = saturate((r3.y) * (r4.w));
    r3.y = (r0.x) * (r3.y);
    r3.y = rsqrt(r3.y);
    r3.y = 1.0f / (r3.y);
    r3.y = (r3.w) * (r3.y);
    r2.xyz = (r2.xyz) * (r3.yyy);
    r0.z = saturate(dot(r0.zwy, r6.xyz));
    r0.z = (r3.z) + (r0.z);
    r0.z = (r0.z) * (c14.x);
    r3.y = max(c13.w, r0.z);
    r0.z = 1.0f / (r3.y);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r0.z = (r2.w) * (c4.w);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r8.xyz = normalize(v1.xyz);
    r0.z = dot(r8.xyz, r5.xyz);
    r0.w = (r0.z) + (r0.z);
    r8.xyz = (r5.xyz) * (-(r0.www)) + (r8.xyz);
    r8.w = (r1.w) * (c15.w);
    r8 = texCUBElod(s15, r8);
    r3.yzw = (r8.xyz) * (r8.xyz);
    r3.yzw = (r3.yzw) * (c15.www);
    r8 = tex3D(s11, v6.xyz);
    r8.xyz = (r8.xyz) * (r8.xyz);
    r3.yzw = (r3.yzw) * (r8.xyz);
    r3.yzw = (r3.yzw) * (c[23].xxx);
    r3.yzw = (r3.yzw) * (c0.xxx);
    r8 = tex2D(s4, v5.xy);
    r8 = (r3.xxxx) * (r7) + (r8);
    r0.z = saturate(r0.z);
    r0.z = (-(r0.z)) + (c3.x);
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r8.w) * (c0.y) + (c0.z);
    r0.w = 1.0f / (r0.w);
    r0.z = (r0.z) * (r0.w);
    r9.xyz = lerp(r8.xyz, c3.xxx, r0.zzz);
    r3.yzw = (r3.yzw) * (r9.xyz);
    r2.xyz = (r2.xyz) * (c4.www) + (r3.yzw);
    r2.xyz = (c[7].xxx) * (-(r2.xyz)) + (r2.xyz);
    r0.z = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.z);
    r3.yzw = (r5.xyz) * (c[5].xyz);
    r0.z = 1.0f / (r1.w);
    r3.yzw = (r3.yzw) * (r0.zzz) + (v6.xyz);
    r9 = tex3D(s11, r3.yzw);
    r3.yzw = (r9.xyz) * (r9.xyz);
    r9.x = c[6].x;
    r9.xyz = (r9.xxx) * (c[18].xyz);
    r0.z = dot(-(r4.xyz), r5.xyz);
    r0.z = (r0.z) + (r0.z);
    r5.xyz = (r5.xyz) * (-(r0.zzz)) + (-(r4.xyz));
    r0.z = dot(r4.xyz, -(r6.xyz));
    r0.z = saturate((r0.z) * (c14.x) + (c14.x));
    r0.z = (r0.z) + (r0.z);
    r0.z = (r0.z) * (r0.z);
    r0.w = (r0.z) * (c[24].x);
    r0.z = (r0.z) * (c16.x) + (c16.y);
    r0.w = (r0.w) * (c4.w);
    r1.w = saturate(dot(r5.xyz, r6.xyz));
    r2.w = pow(abs(r1.w), r0.z);
    r4.xyz = max(r9.xyz, c3.xxx);
    r4.xyz = (r2.www) * (r4.xyz);
    r4.xyz = (r0.www) * (r4.xyz);
    r0.y = saturate(r0.y);
    r0.y = (r9.w) * (r0.y);
    r0.yzw = (r4.xyz) * (r0.yyy);
    r0.yzw = (r3.yzw) * (c0.xxx) + (r0.yzw);
    r4 = tex2D(s6, v5.xy);
    r3.yzw = (r4.xyz) * (r4.xyz);
    r3.yzw = (r3.yzw) * (v4.xyz);
    r1.w = (r7.x) * (r7.w);
    r4.x = c3.x;
    r1.w = (r1.w) * (-(c[27].x)) + (r4.x);
    r4.yzw = (r3.yzw) * (c[26].xyz) + (-(r3.yzw));
    r4.yzw = (r1.www) * (r4.yzw);
    r3.xyz = (r3.xxx) * (r4.yzw) + (r3.yzw);
    r0.xyz = (r0.xxx) * (r1.xyz) + (r0.yzw);
    r1.xyz = (r8.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c3.yyy);
    r0.w = c[8].w;
    r0.x = (r0.w) * (c[21].x);
    r0.yzw = (-(r4.xxx)) + (c[8].xyz);
    r0.xyz = (r0.xxx) * (r0.yzw) + (c3.xxx);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r0.w = c3.x;
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
    oC0.w = c3.x;

    return oC0;
}
