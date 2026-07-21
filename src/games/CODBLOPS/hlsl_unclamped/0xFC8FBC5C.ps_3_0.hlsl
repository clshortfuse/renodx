// Mechanically reconstructed from 0xFC8FBC5C.ps_3_0.cso.
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
    const float4 c0 = float4(8.0f, 31.875f, 0.200000003f, 0.142857f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c12 = float4(7.0f, 0.5f, 2.0f, -1.0f);
    const float4 c13 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c14 = float4(4.0f, -2.0f, 0.0f, 0.0f);
    const float4 c15 = float4(1.0f, 0.5f, 0.0f, 0.0f);
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
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    if ((c4.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c4.xxxy) + (c4.zzzx);
        r2 = (r2) * (c4.xxxy);
        r3 = (r2) + (c4.wwyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c4.wwyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c1.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c1.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r1.w = dot(r3, c1.wwww);
        if ((c3.x) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c4.xy) + (c4.zx);
            r2 = (r2) * (c4.xxxy);
            r3 = (r2) + (c4.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c4.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c1.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c1.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c1.wwww);
            r2.y = (v5.w) * (c3.y) + (c3.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2 = tex2D(s12, v4.zw);
        r2.x = (c3.w) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v5.zz) * (c4.xy) + (c4.zx);
            r3 = (r3) * (c4.xxxy);
            r4 = (r3) + (c4.wwyy);
            r4 = tex2Dlod(s1, r4);
            r5 = (r3) + (-(c4.wwyy));
            r5 = tex2Dlod(s1, r5);
            r6 = (r3) + (c1.xyzz);
            r6 = tex2Dlod(s1, r6);
            r3 = (r3) + (-(c1.xyzz));
            r3 = tex2Dlod(s1, r3);
            r4.y = r5.x;
            r4.z = r6.x;
            r4.w = r3.x;
            r2.x = dot(r4, c1.wwww);
            r2.z = saturate((c3.z) + (v5.w));
            r1.w = lerp(r2.x, r2.y, r2.z);
        }
        else
        {
            r1.w = r2.y;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = normalize(c[17].xyz);
    r1.w = c[21].w;
    r4.xy = (r1.ww) * (c[27].xy);
    r4.xy = (r4.xy) * (c[26].xx);
    r4.xy = (v4.xy) * (c[26].xx) + (r4.xy);
    r4 = tex2D(s7, r4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (v6.xxx);
    r4.xyz = (r4.xyz) * (c12.xxx);
    r5.xy = (r1.ww) * (c[28].xy);
    r5.xy = (r5.xy) * (c[29].xx);
    r5.xy = (v4.xy) * (c[29].xx) + (r5.xy);
    r5 = tex2D(s6, r5.xy);
    r6.xyz = (r4.xyz) * (r5.xyz);
    r7 = tex2D(s3, v4.xy);
    r7.xy = (r7.wy) * (c13.xy) + (c13.zw);
    r7.xy = (r7.xy) * (c12.yy) + (c12.yy);
    r7.xy = (r7.xy) * (c12.zz) + (c12.ww);
    r7.yzw = (r1.xyz) * (r7.yyy);
    r7.xyz = (r7.xxx) * (v3.xyz) + (r7.yzw);
    r7.xyz = (v2.xyz) * (r0.xxx) + (r7.xyz);
    r0.x = dot(r7.xyz, r7.xyz);
    r0.x = rsqrt(r0.x);
    r8.xyz = (r7.xyz) * (r0.xxx);
    r2.xyz = (r2.xyz) * (c[20].xxx);
    r1.w = saturate(dot(r8.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r1.www);
    r3.xyz = normalize(v1.xyz);
    r1.w = dot(r3.xyz, r8.xyz);
    r1.w = (r1.w) + (r1.w);
    r3.xyz = (r8.xyz) * (-(r1.www)) + (r3.xyz);
    r3.w = c0.x;
    r3 = texCUBElod(s15, r3);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c0.xxx);
    r9 = tex2D(s14, v4.zw);
    r9.zw = (abs(c12.wy)) * (v4.zw);
    r10 = tex2D(s13, r9.zw);
    r9.zw = (r9.xy) * (c0.yy);
    r10.xw = (r10.xz) * (r9.zz);
    r11.xz = (r10.xw) * (c3.yy);
    r1.w = (r9.x) * (c0.y) + (-(r10.x));
    r1.w = (r10.z) * (-(r9.z)) + (r1.w);
    r11.y = (r1.w) + (r1.w);
    r3.xyz = (r3.xyz) * (r11.xyz);
    r3.xyz = (r3.xyz) * (c0.zzz);
    r12.xyz = normalize(v3.xyz);
    r13.xyz = normalize(r1.xyz);
    r1.xy = (v4.zw) * (c15.xy) + (c15.zy);
    r1 = tex2D(s13, r1.xy);
    r9.xz = (r9.ww) * (r1.xz);
    r10.xw = (r9.xz) * (c3.yy);
    r1.w = (r9.y) * (c0.y) + (-(r9.x));
    r1.z = (r1.z) * (-(r9.w)) + (r1.w);
    r10.z = (r1.z) + (r1.z);
    r1.x = r10.y;
    r1.xy = (r1.xy) * (c14.xx) + (c14.yy);
    r1.yzw = (r13.xyz) * (r1.yyy);
    r1.xyz = (r1.xxx) * (r12.xyz) + (r1.yzw);
    r1.xyz = (r7.xyz) * (r0.xxx) + (r1.xyz);
    r7.xyz = normalize(r1.xyz);
    r0.x = dot(r7.xyz, r8.xyz);
    r1.xyz = (r0.xxx) * (r10.xzw) + (r11.xyz);
    r7 = tex2D(s5, v4.xy);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r8 = tex2D(s4, v4.xy);
    r8.xyz = (r8.xyz) * (r8.xyz);
    r1.xyz = (r2.xyz) * (c0.www) + (r1.xyz);
    r2.xyz = (r3.xyz) * (r8.xyz);
    r1.xyz = (r1.xyz) * (r7.xyz) + (r2.xyz);
    r2.xyz = max(r1.xyz, c4.yyy);
    r1 = tex2D(s2, v4.xy);
    r0.x = (-(r1.x)) + (c4.x);
    r1.xyz = (r4.xyz) * (-(r5.xyz)) + (r2.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz) + (r6.xyz);
    r2 = (c[5]) + (-(v1.xxxx));
    r3 = (c[6]) + (-(v1.yyyy));
    r4 = (c[7]) + (-(v1.zzzz));
    r5 = (r3) * (r3);
    r5 = (r2) * (r2) + (r5);
    r5 = (r4) * (r4) + (r5);
    r6.x = rsqrt(r5.x);
    r6.y = rsqrt(r5.y);
    r6.z = rsqrt(r5.z);
    r6.w = rsqrt(r5.w);
    r2 = (r2) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r6);
    r0.x = c4.x;
    r5 = saturate((r5) * (c[8]) + (r0.xxxx));
    r3 = (r0.zzzz) * (r3);
    r2 = (r2) * (r0.yyyy) + (r3);
    r0 = saturate((r4) * (r0.wwww) + (r2));
    r0 = (r5) * (r0);
    r2.x = dot(c[9], r0);
    r2.y = dot(c[10], r0);
    r2.z = dot(c[11], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c4.x;
    r1.x = dot(r0, c[23]);
    r1.y = dot(r0, c[24]);
    r1.z = dot(r0, c[25]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c4.x;

    return oC0;
}
