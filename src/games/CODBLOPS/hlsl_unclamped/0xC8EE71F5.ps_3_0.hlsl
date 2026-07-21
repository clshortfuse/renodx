// Mechanically reconstructed from 0xC8EE71F5.ps_3_0.cso.
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
    const float4 c0 = float4(2.0f, -1.0f, 0.0357140005f, 31.875f);
    const float4 c1 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 0.5f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(-0.600000024f, -0.800000012f, 0.107143f, 0.0f);
    const float4 c14 = float4(8.0f, 3.0f, -3.0f, 6.0f);
    const float4 c15 = float4(1.25f, 0.0199999996f, 3.33333325f, 10.0f);
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
    r0.yzw = (r0.yzw) * (c[5].xyz);
    r1.w = 1.0f / (r2.x);
    r0.yzw = (r0.yzw) * (r1.www) + (v5.xyz);
    r2 = tex3D(s11, r0.yzw);
    if ((c1.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c1.xxxy) + (c1.yyyx);
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
        r0.y = dot(r4, c1.wwww);
        if ((c3.w) < (v6.w))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zx) * (c1.xy) + (c1.yx);
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
            r0.z = dot(r4, c1.wwww);
            r0.w = (v6.w) * (c4.x) + (c4.y);
            r1.w = lerp(r0.y, r0.z, r0.w);
            r0.y = r1.w;
        }
    }
    else
    {
        r0.z = (c4.z) + (v6.w);
        r0.z = ((r0.z) >= 0.0f ? (c1.y) : (c1.x));
        if ((r0.z) != (-(r0.z)))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zz) * (c1.xy) + (c1.yx);
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
            r1.w = dot(r4, c1.wwww);
            r2.x = saturate((c4.y) + (v6.w));
            r0.y = lerp(r1.w, r2.w, r2.x);
        }
        else
        {
            r0.y = r2.w;
        }
    }
    r0.yzw = (r0.yyy) * (c[18].xyz);
    r2.xyz = normalize(c[17].xyz);
    r3 = tex2D(s3, v4.xy);
    r3.xy = (r3.wy) * (c12.xy) + (c12.zw);
    r3.xy = (r3.xy) * (c4.ww) + (c4.ww);
    r3.xy = (r3.xy) * (c0.xx) + (c0.yy);
    r4 = tex2D(s2, v4.xy);
    r3.zw = (r4.wy) * (c12.xy) + (c12.zw);
    r3.zw = (r3.zw) * (c4.ww) + (c4.ww);
    r3.zw = (r3.zw) * (c0.xx) + (c0.yy);
    r1.w = saturate((c[21].x) * (v7.z));
    r2.w = (r1.w) * (c[23].x);
    r3.zw = (r3.zw) * (r2.ww);
    r3.xy = (c[22].xx) * (r3.xy) + (r3.zw);
    r1.xyz = (r1.xyz) * (r3.yyy);
    r1.xyz = (r3.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r3.xyz = normalize(r1.xyz);
    r1.xy = v4.xy;
    r4.xy = (r1.xy) * (c[26].xx) + (v7.xy);
    r4 = tex2D(s8, r4.xy);
    r0.xyz = (r0.yzw) * (c[6].xxx);
    r0.w = saturate(dot(r3.xyz, r2.xyz));
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = max(abs(r3.y), abs(r3.z));
    r1.z = max(abs(r3.x), r0.w);
    r2.xyz = (r3.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.z);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xy = (r1.xy) * (c[27].xx) + (v7.xy);
    r5 = tex2D(s8, r1.xy);
    r6 = tex2D(s5, v4.xy);
    r1.xyz = (r6.xyz) * (r6.xyz);
    r4.yzw = (r6.xyz) * (-(r6.xyz)) + (c0.zzz);
    r4.yzw = (r5.yyy) * (r4.yzw) + (r1.xyz);
    r0.xyz = (r2.xyz) * (c0.www) + (r0.xyz);
    r2.xyz = (r4.yzw) * (r0.xyz);
    r4.yzw = max(r2.xyz, c1.yyy);
    r2.xyz = normalize(v1.xyz);
    r0.w = dot(r2.xyz, r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r3.xyz) * (-(r0.www)) + (r2.xyz);
    r2.w = c14.x;
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r2.xyz) * (c14.xxx);
    r5 = tex3D(s11, v5.xyz);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r5.xyz = (r5.xyz) * (c0.www);
    r3.xyz = (r3.xyz) * (r5.xyz);
    r3.xyz = (r3.xyz) * (c[20].xxx);
    r6 = tex2D(s4, v4.xy);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r3.xyz = (r3.xyz) * (r6.xyz) + (r1.xyz);
    r7.xyz = max(r3.xyz, c1.yyy);
    r0.w = c[7].w;
    r3.xy = (r0.ww) * (c[25].xy);
    r3.xy = (r3.xy) * (c[24].xx);
    r3.xy = (v4.xy) * (c[24].xx) + (r3.xy);
    r3 = tex2D(s7, r3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c[28].xxx);
    r8 = tex2D(s6, v4.xy);
    r8.xyz = saturate((r8.xyz) * (-(c4.yyy)));
    r3.xyz = (r3.xyz) * (r8.xyz);
    r2.xyz = (r2.xyz) * (r5.xyz);
    r2.xyz = (r2.xyz) * (c[20].xxx);
    r2.xyz = (r2.xyz) * (c14.xxx);
    r1.xyz = (r2.xyz) * (r6.xyz) + (r1.xyz);
    r5.xyz = max(r1.xyz, c1.yyy);
    r0.w = (r4.x) * (c14.y) + (c14.z);
    r1.w = saturate(r1.w);
    r0.w = (r1.w) * (c14.w) + (r0.w);
    r1.x = (-(r0.w)) + (c1.x);
    r1.y = (r1.x) * (c15.x);
    r2.w = min(r1.y, c1.x);
    r1.y = (r2.w) * (r2.w) + (-(c1.x));
    r1.z = ddx(r1.y);
    r1.w = ddy(r1.y);
    r1.y = (r1.y) * (c15.y);
    r2.w = dot(r1.zw, r1.zw) + (c1.y);
    r2.w = rsqrt(r2.w);
    r1.zw = (r1.zw) * (r2.ww);
    r1.yz = (r1.yy) * (r1.zw) + (v4.xy);
    r6 = tex2D(s5, r1.yz);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r8 = tex2D(s4, r1.yz);
    r1.yzw = (r2.xyz) * (r8.xyz);
    r0.xyz = (r0.xyz) * (r6.xyz) + (r1.yzw);
    r1.yzw = max(r0.xyz, c1.yyy);
    r0.x = saturate((r0.w) * (c15.z));
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r2.xyz = lerp(r1.yzw, r4.yzw, r0.xxx);
    r0.xy = (r0.ww) + (c13.xy);
    r0.xy = saturate((r0.xy) * (c15.ww));
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r1.yzw = (r7.xyz) * (r3.xyz) + (-(r2.xyz));
    r0.xzw = (r0.xxx) * (r1.yzw) + (r2.xyz);
    r0.y = rsqrt(r0.y);
    r0.y = 1.0f / (r0.y);
    r1.yzw = (r5.xyz) * (c13.zzz) + (-(r0.xzw));
    r0.xyz = (r0.yyy) * (r1.yzw) + (r0.xzw);
    oC0.w = ((r1.x) >= 0.0f ? (c1.x) : (c1.y));
    r0.w = c1.x;
    r1.x = dot(r0, c[9]);
    r1.y = dot(r0, c[10]);
    r1.z = dot(r0, c[11]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
