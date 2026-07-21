// Mechanically reconstructed from 0x4B77CD9C.ps_3_0.cso.
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
sampler2D s9 : register(s9);
sampler2D s10 : register(s10);
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
    const float4 c0 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c3 = float4(4.0f, -3.0f, -4.0f, 0.5f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(2.0f, -1.0f, 6.28318548f, 0.25f);
    const float4 c13 = float4(3.14159274f, 0.159154937f, 0.5f, -6.28318548f);
    const float4 c14 = float4(0.5f, -0.5f, 9.99999975e-06f, 1e-15f);
    const float4 c15 = float4(1.44269502f, 0.100000001f, 8.0f, 31.875f);
    const float4 c16 = float4(-0.00537109375f, 30.0f, 2.5f, -2.5f);
    const float4 c26 = float4(5.0f, 0.833333313f, 1.5f, 0.0f);
    const float4 c27 = float4(3.5f, 1.0f, 12.0f, 0.600000024f);
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
    r2.xyz = (r2.yzw) * (r1.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c0.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c0.xxxy) + (c0.yyyx);
        r3 = (r3) * (c0.xxxy);
        r4 = (r3) + (c0.zzyy);
        r4 = tex2Dlod(s1, r4);
        r5 = (r3) + (-(c0.zzyy));
        r5 = tex2Dlod(s1, r5);
        r6 = (r3) + (c1.xyzz);
        r6 = tex2Dlod(s1, r6);
        r3 = (r3) + (-(c1.xyzz));
        r3 = tex2Dlod(s1, r3);
        r4.y = r5.x;
        r4.z = r6.x;
        r4.w = r3.x;
        r1.w = dot(r4, c0.wwww);
        if ((c1.w) < (v6.w))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zx) * (c0.xy) + (c0.yx);
            r3 = (r3) * (c0.xxxy);
            r4 = (r3) + (c0.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c0.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c0.wwww);
            r2.y = (v6.w) * (c3.x) + (c3.y);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.z) + (v6.w);
        r2.x = ((r2.x) >= 0.0f ? (c0.y) : (c0.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zz) * (c0.xy) + (c0.yx);
            r3 = (r3) * (c0.xxxy);
            r4 = (r3) + (c0.zzyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c0.zzyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c0.wwww);
            r2.y = saturate((c3.y) + (v6.w));
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
    r5 = tex2D(s5, v4.xy);
    r5.xy = (r5.wy) * (c4.xy) + (c4.zw);
    r5.xy = (r5.xy) * (c3.ww) + (c3.ww);
    r5.xy = (r5.xy) * (c12.xx) + (c12.yy);
    r6 = tex2D(s4, v4.xy);
    r5.zw = (r6.wy) * (c4.xy) + (c4.zw);
    r5.zw = (r5.zw) * (c3.ww) + (c3.ww);
    r5.zw = (r5.zw) * (c12.xx) + (c12.yy);
    r6 = tex2D(s2, v4.xy);
    r7.x = c0.x;
    r1.w = (r7.x) + (-(c[8].y));
    r1.w = saturate(r1.w);
    r7.xyz = (r6.xyz) * (c12.zzw);
    r8.x = c12.x;
    r6.zw = (c[7].ww) * (r8.xx) + (r7.xy);
    r2.w = (r6.z) + (c13.x);
    r2.w = (r2.w) * (c13.y) + (c13.z);
    r2.w = frac(r2.w);
    r2.w = (r2.w) * (-(c13.w)) + (-(c13.x));
    r8.x = cos(r2.w);
    r2.w = (r8.x) * (c14.x) + (c14.y);
    r2.w = (r1.w) * (r2.w) + (c0.x);
    r8 = tex2D(s3, v4.xy);
    r7.xy = (r8.wy) * (c4.xy) + (c4.zw);
    r7.xy = (r7.xy) * (c3.ww) + (c3.ww);
    r7.xy = (r7.xy) * (c12.xx) + (c12.yy);
    r3.w = (r6.w) * (c13.y) + (c13.z);
    r3.w = frac(r3.w);
    r3.w = (r3.w) * (-(c13.w)) + (-(c13.x));
    r8.x = cos(r3.w);
    r3.w = (r8.x) * (c3.w) + (c3.w);
    r1.w = (r1.w) * (r3.w);
    r6.zw = (r7.xy) * (r1.ww);
    r5.zw = (r2.ww) * (r5.zw) + (r6.zw);
    r6.zw = lerp(r5.xy, r5.zw, c[8].zz);
    r1.xyz = (r1.xyz) * (r6.www);
    r1.xyz = (r6.zzz) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.z = c[8].z;
    r0.x = c[23].x;
    r0.x = saturate((r1.z) * (r0.x) + (c[24].x));
    r1.x = lerp(r6.x, r6.y, c3.w);
    r1.yzw = (r2.xyz) * (c[6].xxx);
    r2.x = saturate(dot(r5.xyz, r4.xyz));
    r2.yzw = (r3.xyz) * (c[6].yyy);
    r3 = tex2D(s8, v4.xy);
    r4.w = max(c14.z, r3.x);
    r3.y = dot(-(v1.xyz), -(v1.xyz));
    r3.y = rsqrt(r3.y);
    r6.xyz = (r3.yyy) * (-(v1.xyz));
    r3.z = saturate(dot(r5.xyz, r6.xyz));
    r3.w = (r4.w) * (r4.w);
    r3.w = 1.0f / (r3.w);
    r7.xyw = (-(v1.xyz)) * (r3.yyy) + (r4.xyz);
    r8.xyz = normalize(r7.xyw);
    r3.y = saturate(dot(r5.xyz, r8.xyz));
    r4.w = (r3.y) * (r3.y) + (c14.w);
    r4.w = 1.0f / (r4.w);
    r5.w = (-(r4.w)) + (c0.x);
    r5.w = (r3.w) * (r5.w);
    r5.w = (r5.w) * (c15.x);
    r5.w = exp2(r5.w);
    r4.w = (r4.w) * (r4.w);
    r4.w = (r5.w) * (r4.w);
    r3.y = (r3.y) + (r3.y);
    r5.w = 1.0f / (r3.z);
    r3.y = (r3.y) * (r5.w);
    r5.w = min(r3.z, r2.x);
    r3.y = saturate((r3.y) * (r5.w));
    r3.y = (r2.x) * (r3.y);
    r3.y = rsqrt(r3.y);
    r3.y = 1.0f / (r3.y);
    r3.y = (r4.w) * (r3.y);
    r2.yzw = (r2.yzw) * (r3.yyy);
    r0.z = saturate(dot(r0.zwy, r6.xyz));
    r0.z = (r3.z) + (r0.z);
    r0.z = (r0.z) * (c3.w);
    r3.y = max(c15.y, r0.z);
    r0.z = 1.0f / (r3.y);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r2.yzw = (r2.yzw) * (r0.zzz);
    r0.z = (r3.w) * (c0.w);
    r2.yzw = (r2.yzw) * (r0.zzz);
    r8.xyz = normalize(v1.xyz);
    r0.z = dot(r8.xyz, r5.xyz);
    r0.w = (r0.z) + (r0.z);
    r8.xyz = (r5.xyz) * (-(r0.www)) + (r8.xyz);
    r8.w = (r3.x) * (c15.z);
    r3 = texCUBElod(s15, r8);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c15.zzz);
    r8 = tex3D(s11, v5.xyz);
    r7.xyw = (r8.xyz) * (r8.xyz);
    r3.xyz = (r3.xyz) * (r7.xyw);
    r3.xyz = (r3.xyz) * (c[21].xxx);
    r3.xyz = (r3.xyz) * (c15.www);
    r8 = tex2D(s7, v4.xy);
    r0.z = saturate(r0.z);
    r0.z = (-(r0.z)) + (c0.x);
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r8.w) * (c27.x) + (c27.y);
    r0.w = 1.0f / (r0.w);
    r0.z = (r0.z) * (r0.w);
    r7.xyw = lerp(r8.xyz, c0.xxx, r0.zzz);
    r3.xyz = (r3.xyz) * (r7.xyw);
    r2.yzw = (r2.yzw) * (c0.www) + (r3.xyz);
    r3.xyz = (-(r2.yzw)) + (c0.xxx);
    r2.yzw = (c[8].xxx) * (r3.xyz) + (r2.yzw);
    r0.z = max(abs(r5.y), abs(r5.z));
    r3.x = max(abs(r5.x), r0.z);
    r3.yzw = (r5.xyz) * (c[5].xyz);
    r0.z = 1.0f / (r3.x);
    r3.xyz = (r3.yzw) * (r0.zzz) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c15.www);
    r7.x = c[6].x;
    r7.xyw = (r7.xxx) * (c[18].xyz);
    r9 = tex2D(s10, v4.xy);
    r0.z = (r9.x) * (c[25].x);
    r0.w = dot(-(r4.xyz), r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r5.xyz = (r5.xyz) * (-(r0.www)) + (-(r4.xyz));
    r0.w = dot(r4.xyz, -(r6.xyz));
    r0.w = saturate((r0.w) * (c3.w) + (c3.w));
    r0.w = (r0.w) + (r0.w);
    r4.x = pow(abs(r0.w), c27.z);
    r0.z = (r0.z) * (r4.x);
    r0.w = (r4.x) * (c16.x) + (c16.y);
    r0.z = (r0.z) * (c0.z);
    r4.x = saturate(dot(r5.xyz, r6.xyz));
    r5.x = pow(abs(r4.x), r0.w);
    r4.xyz = max(r7.xyw, c0.xxx);
    r4.xyz = (r5.xxx) * (r4.xyz);
    r4.xyz = (r0.zzz) * (r4.xyz);
    r0.y = saturate(r0.y);
    r0.y = (r3.w) * (r0.y);
    r0.yzw = (r4.xyz) * (r0.yyy) + (r3.xyz);
    r4 = tex2D(s9, v4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0.yzw = (r2.xxx) * (r1.yzw) + (r0.yzw);
    r5.xyz = (r8.xyz) * (r2.yzw);
    r0.yzw = (r0.yzw) * (r4.xyz) + (r5.xyz);
    r4.xyz = max(r0.yzw, c0.yyy);
    r5 = tex2D(s6, v4.xy);
    r0.yzw = (r5.xyz) * (r5.xyz);
    r1.yzw = (r2.xxx) * (r1.yzw) + (r3.xyz);
    r2.xyz = (r7.zzz) * (r2.yzw);
    r0.yzw = (r1.yzw) * (r0.yzw) + (r2.xyz);
    r1.yzw = max(r0.yzw, c0.yyy);
    r0.yzw = lerp(r4.xyz, r1.yzw, c27.www);
    r1.x = (r1.x) * (c16.z) + (c16.w);
    r0.x = (r0.x) * (c26.x) + (r1.x);
    r1.x = saturate((r0.x) * (c26.y));
    r1.x = (r1.x) * (r1.x);
    r0.yzw = (r0.yzw) * (c[22].xyz) + (-(r4.xyz));
    r0.yzw = (r1.xxx) * (r0.yzw) + (r4.xyz);
    r0.x = (r0.x) + (-(c27.w));
    r0.x = saturate((r0.x) * (c26.z));
    r2.xyz = lerp(r0.yzw, r1.yzw, r0.xxx);
    r2.w = c0.x;
    r0.x = dot(r2, c[10]);
    r0.y = dot(r2, c[11]);
    r0.z = dot(r2, c[20]);
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.x;

    return oC0;
}
