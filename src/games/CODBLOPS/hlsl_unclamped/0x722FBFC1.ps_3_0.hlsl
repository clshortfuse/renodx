// Mechanically reconstructed from 0x722FBFC1.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
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
    const float4 c0 = float4(31.875f, 0.200000003f, 4.0f, -2.0f);
    const float4 c1 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 7.0f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(0.5f, 2.0f, -1.0f, 8.0f);
    const float4 c14 = float4(1.0f, 0.5f, 0.0f, 0.142857f);
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

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r0.yzw = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r0.yzw = (r0.yzw) * (v3.www);
    if ((c1.x) >= (v5.w))
    {
        r1 = (v5.xyzx) * (c1.xxxy) + (c1.yyyx);
        r1 = (r1) * (c1.xxxy);
        r2 = (r1) + (c1.zzyy);
        r2 = tex2Dlod(s1, r2);
        r3 = (r1) + (-(c1.zzyy));
        r3 = tex2Dlod(s1, r3);
        r4 = (r1) + (c3.xyzz);
        r4 = tex2Dlod(s1, r4);
        r1 = (r1) + (-(c3.xyzz));
        r1 = tex2Dlod(s1, r1);
        r2.y = r3.x;
        r2.z = r4.x;
        r2.w = r1.x;
        r1.x = dot(r2, c1.wwww);
        if ((c3.w) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c1.xy) + (c1.yx);
            r2 = (r2) * (c1.xxxy);
            r3 = (r2) + (c1.zzyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c1.zzyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c3.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c3.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r1.y = dot(r3, c1.wwww);
            r1.z = (v5.w) * (c4.x) + (c4.y);
            r2.x = lerp(r1.x, r1.y, r1.z);
            r1.x = r2.x;
        }
    }
    else
    {
        r2 = tex2D(s12, v4.zw);
        r1.y = (c4.z) + (v5.w);
        r1.y = ((r1.y) >= 0.0f ? (c1.y) : (c1.x));
        if ((r1.y) != (-(r1.y)))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zz) * (c1.xy) + (c1.yx);
            r3 = (r3) * (c1.xxxy);
            r4 = (r3) + (c1.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c1.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c3.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c3.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c1.wwww);
            r2.z = saturate((c4.y) + (v5.w));
            r1.x = lerp(r2.x, r2.y, r2.z);
        }
        else
        {
            r1.x = r2.y;
        }
    }
    r1.xyz = (r1.xxx) * (c[18].xyz);
    r2.xyz = normalize(c[17].xyz);
    r1.w = c[6].w;
    r3.xy = (r1.ww) * (c[20].xy);
    r3.xy = (r3.xy) * (c[11].xx);
    r3.xy = (v4.xy) * (c[11].xx) + (r3.xy);
    r3 = tex2D(s7, r3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (v6.xxx);
    r3.xyz = (r3.xyz) * (c4.www);
    r4.xy = (r1.ww) * (c[21].xy);
    r4.xy = (r4.xy) * (c[22].xx);
    r4.xy = (v4.xy) * (c[22].xx) + (r4.xy);
    r4 = tex2D(s6, r4.xy);
    r5.xyz = (r3.xyz) * (r4.xyz);
    r6 = tex2D(s3, v4.xy);
    r6.xy = (r6.wy) * (c12.xy) + (c12.zw);
    r6.xy = (r6.xy) * (c13.xx) + (c13.xx);
    r6.xy = (r6.xy) * (c13.yy) + (c13.zz);
    r6.yzw = (r0.yzw) * (r6.yyy);
    r6.xyz = (r6.xxx) * (v3.xyz) + (r6.yzw);
    r6.xyz = (v2.xyz) * (r0.xxx) + (r6.xyz);
    r0.x = dot(r6.xyz, r6.xyz);
    r0.x = rsqrt(r0.x);
    r7.xyz = (r6.xyz) * (r0.xxx);
    r1.xyz = (r1.xyz) * (c[5].xxx);
    r1.w = saturate(dot(r7.xyz, r2.xyz));
    r1.xyz = (r1.xyz) * (r1.www);
    r2.xyz = normalize(v1.xyz);
    r1.w = dot(r2.xyz, r7.xyz);
    r1.w = (r1.w) + (r1.w);
    r2.xyz = (r7.xyz) * (-(r1.www)) + (r2.xyz);
    r2.w = c13.w;
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c13.www);
    r8 = tex2D(s14, v4.zw);
    r8.zw = (abs(c13.zx)) * (v4.zw);
    r9 = tex2D(s13, r8.zw);
    r8.zw = (r8.xy) * (c0.xx);
    r9.xw = (r9.xz) * (r8.zz);
    r10.xz = (r9.xw) * (c4.xx);
    r1.w = (r8.x) * (c0.x) + (-(r9.x));
    r1.w = (r9.z) * (-(r8.z)) + (r1.w);
    r10.y = (r1.w) + (r1.w);
    r2.xyz = (r2.xyz) * (r10.xyz);
    r2.xyz = (r2.xyz) * (c0.yyy);
    r11.xyz = normalize(v3.xyz);
    r12.xyz = normalize(r0.yzw);
    r0.yz = (v4.zw) * (c14.xy) + (c14.zy);
    r13 = tex2D(s13, r0.yz);
    r0.yz = (r8.ww) * (r13.xz);
    r9.xw = (r0.yz) * (c4.xx);
    r0.y = (r8.y) * (c0.x) + (-(r0.y));
    r0.y = (r13.z) * (-(r8.w)) + (r0.y);
    r9.z = (r0.y) + (r0.y);
    r13.x = r9.y;
    r0.yz = (r13.xy) * (c0.zz) + (c0.ww);
    r8.xyz = (r12.xyz) * (r0.zzz);
    r0.yzw = (r0.yyy) * (r11.xyz) + (r8.xyz);
    r0.xyz = (r6.xyz) * (r0.xxx) + (r0.yzw);
    r6.xyz = normalize(r0.xyz);
    r0.x = dot(r6.xyz, r7.xyz);
    r0.xyz = (r0.xxx) * (r9.xzw) + (r10.xyz);
    r6 = tex2D(s5, v4.xy);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r7 = tex2D(s4, v4.xy);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r0.xyz = (r1.xyz) * (c14.www) + (r0.xyz);
    r1.xyz = (r2.xyz) * (r7.xyz);
    r0.xyz = (r0.xyz) * (r6.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c1.yyy);
    r0 = tex2D(s2, v4.xy);
    r0.x = (-(r0.x)) + (c1.x);
    r0.yzw = (r3.xyz) * (-(r4.xyz)) + (r1.xyz);
    r0.xyz = (r0.xxx) * (r0.yzw) + (r5.xyz);
    r0.w = c1.x;
    r1.x = dot(r0, c[8]);
    r1.y = dot(r0, c[9]);
    r1.z = dot(r0, c[10]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
