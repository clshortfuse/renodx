// Mechanically reconstructed from 0xBEDA8A1F.ps_3_0.cso.
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
    const float4 c12 = float4(2.0f, -1.0f, 9.99999975e-06f, 1e-15f);
    const float4 c13 = float4(1.44269502f, 0.100000001f, 8.0f, 31.875f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(v2.xyz, v2.xyz);
    r0.x = rsqrt(r0.x);
    r0.yzw = (r0.xxx) * (v2.xyz);
    r1.xyz = (r0.wyz) * (v3.yzx);
    r1.xyz = (r0.zwy) * (v3.zxy) + (-(r1.xyz));
    r1.xyz = (r1.xyz) * (v3.www);
    r1.w = max(abs(r0.z), abs(r0.w));
    r2.x = max(abs(r0.y), r1.w);
    r2.yzw = (r0.yzw) * (c[5].xyz);
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
    r5.xy = ddx(v4.xy);
    r5.zw = ddy(v4.xy);
    r6.xy = (c[27].xx) * (v4.xy);
    r6 = tex2D(s2, r6.xy);
    r6.xy = (r6.wy) * (c4.xy) + (c4.zw);
    r6.xy = (r6.xy) * (c3.ww) + (c3.ww);
    r6.xy = (r6.xy) * (c12.xx) + (c12.yy);
    r1.xyz = (r1.xyz) * (r6.yyy);
    r1.xyz = (r6.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r6.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[21].xxx);
    r0.x = saturate(dot(r6.xyz, r4.xyz));
    r1.xyz = (r1.xyz) * (r0.xxx);
    r2.xyz = (r3.xyz) * (c[21].yyy);
    r3 = tex2D(s4, v4.xy);
    r1.w = (r3.x) * (c[30].x);
    r2.w = max(c12.z, r1.w);
    r1.w = dot(-(v1.xyz), -(v1.xyz));
    r1.w = rsqrt(r1.w);
    r7.xyz = (r1.www) * (-(v1.xyz));
    r3.w = saturate(dot(r6.xyz, r7.xyz));
    r2.w = (r2.w) * (r2.w);
    r2.w = 1.0f / (r2.w);
    r4.xyz = (-(v1.xyz)) * (r1.www) + (r4.xyz);
    r8.xyz = normalize(r4.xyz);
    r1.w = saturate(dot(r6.xyz, r8.xyz));
    r4.x = (r1.w) * (r1.w) + (c12.w);
    r4.x = 1.0f / (r4.x);
    r4.y = (-(r4.x)) + (c0.x);
    r4.y = (r2.w) * (r4.y);
    r4.y = (r4.y) * (c13.x);
    r4.y = exp2(r4.y);
    r4.x = (r4.x) * (r4.x);
    r4.x = (r4.y) * (r4.x);
    r1.w = (r1.w) + (r1.w);
    r4.y = 1.0f / (r3.w);
    r1.w = (r1.w) * (r4.y);
    r4.y = min(r3.w, r0.x);
    r1.w = saturate((r1.w) * (r4.y));
    r0.x = (r0.x) * (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r4.x) * (r0.x);
    r2.xyz = (r2.xyz) * (r0.xxx);
    r0.x = saturate(dot(r0.yzw, r7.xyz));
    r0.x = (r3.w) + (r0.x);
    r0.x = (r0.x) * (c3.w);
    r1.w = max(c13.y, r0.x);
    r0.x = 1.0f / (r1.w);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r2.xyz = (r2.xyz) * (r0.xxx);
    r2.xyz = (r2.www) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c[29].xxx);
    r2.xyz = (r2.xyz) * (c0.www) + (c0.xxx);
    r4.xy = c0.xy;
    r0.x = max(c[28].x, r4.y);
    r0.x = (r0.x) + (-(c0.x));
    r4.y = log2(abs(r2.x));
    r4.z = log2(abs(r2.y));
    r4.w = log2(abs(r2.z));
    r2.xyz = (r0.xxx) * (r4.yzw);
    r4.y = exp2(r2.x);
    r4.z = exp2(r2.y);
    r4.w = exp2(r2.z);
    r2.xyz = normalize(v1.xyz);
    r0.x = dot(r2.xyz, r6.xyz);
    r0.x = (r0.x) + (r0.x);
    r2.xyz = (r6.xyz) * (-(r0.xxx)) + (r2.xyz);
    r2 = texCUBE(s15, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c13.zzz);
    r7 = tex3D(s11, v5.xyz);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r2.xyz = (r2.xyz) * (r7.xyz);
    r2.xyz = (r2.xyz) * (c13.www);
    r3.xyz = (r3.xyz) * (c[26].xxx);
    r2.xyz = (r2.xyz) * (r3.xyz);
    r2.xyz = (r4.yzw) * (c[28].yyy) + (r2.xyz);
    r0.x = max(abs(r6.y), abs(r6.z));
    r1.w = max(abs(r6.x), r0.x);
    r3.xyz = (r6.xyz) * (c[5].xyz);
    r0.x = 1.0f / (r1.w);
    r3.xyz = (r3.xyz) * (r0.xxx) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r5 = tex2Dgrad(s3, v4.xy, r5.xy, r5.zw);
    r5 = (r5) * (r5);
    r1.xyz = (r3.xyz) * (c13.www) + (r1.xyz);
    r2.xyz = (r2.xyz) * (c[31].xxx);
    r5.xyz = (r1.xyz) * (r5.xyz) + (r2.xyz);
    r1 = max(r5, c0.yyyy);
    r2 = (c[6]) + (-(v1.xxxx));
    r3 = (c[7]) + (-(v1.yyyy));
    r5 = (c[8]) + (-(v1.zzzz));
    r6 = (r3) * (r3);
    r6 = (r2) * (r2) + (r6);
    r6 = (r5) * (r5) + (r6);
    r7.x = rsqrt(r6.x);
    r7.y = rsqrt(r6.y);
    r7.z = rsqrt(r6.z);
    r7.w = rsqrt(r6.w);
    r2 = (r2) * (r7);
    r3 = (r3) * (r7);
    r5 = (r5) * (r7);
    r4 = saturate((r6) * (c[9]) + (r4.xxxx));
    r3 = (r0.zzzz) * (r3);
    r2 = (r2) * (r0.yyyy) + (r3);
    r0 = saturate((r5) * (r0.wwww) + (r2));
    r0 = (r4) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    r0.w = c0.x;
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
    oC0.w = r1.w;

    return oC0;
}
