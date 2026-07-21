// Mechanically reconstructed from 0x84046A78.ps_3_0.cso.
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
    const float4 c0 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c3 = float4(4.0f, -3.0f, -4.0f, 7.0f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.5f, 2.0f, -1.0f, 0.142857f);
    const float4 c13 = float4(8.0f, 6.375f, 31.875f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
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
        r0.y = dot(r4, c0.wwww);
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
            r0.z = dot(r4, c0.wwww);
            r0.w = (v6.w) * (c3.x) + (c3.y);
            r1.w = lerp(r0.y, r0.z, r0.w);
            r0.y = r1.w;
        }
    }
    else
    {
        r0.z = (c3.z) + (v6.w);
        r0.z = ((r0.z) >= 0.0f ? (c0.y) : (c0.x));
        if ((r0.z) != (-(r0.z)))
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
            r1.w = dot(r4, c0.wwww);
            r2.x = saturate((c3.y) + (v6.w));
            r0.y = lerp(r1.w, r2.w, r2.x);
        }
        else
        {
            r0.y = r2.w;
        }
    }
    r0.yzw = (r0.yyy) * (c[18].xyz);
    r2.xyz = normalize(c[17].xyz);
    r1.w = c[7].w;
    r3.xy = (r1.ww) * (c[21].xy);
    r3.xy = (r3.xy) * (c[20].xx);
    r3.xy = (v4.xy) * (c[20].xx) + (r3.xy);
    r3 = tex2D(s7, r3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (v7.xxx);
    r3.xyz = (r3.xyz) * (c3.www);
    r4.xy = (r1.ww) * (c[22].xy);
    r4.xy = (r4.xy) * (c[23].xx);
    r4.xy = (v4.xy) * (c[23].xx) + (r4.xy);
    r4 = tex2D(s6, r4.xy);
    r5.xyz = (r3.xyz) * (r4.xyz);
    r6 = tex2D(s3, v4.xy);
    r6.xy = (r6.wy) * (c4.xy) + (c4.zw);
    r6.xy = (r6.xy) * (c12.xx) + (c12.xx);
    r6.xy = (r6.xy) * (c12.yy) + (c12.zz);
    r1.xyz = (r1.xyz) * (r6.yyy);
    r1.xyz = (r6.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r6.xyz = normalize(r1.xyz);
    r0.xyz = (r0.yzw) * (c[6].xxx);
    r0.w = saturate(dot(r6.xyz, r2.xyz));
    r0.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r0.xyz) * (c12.www);
    r1.xyz = normalize(v1.xyz);
    r0.w = dot(r1.xyz, r6.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r6.xyz) * (-(r0.www)) + (r1.xyz);
    r1.w = c13.x;
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c13.xxx);
    r2 = tex3D(s11, v5.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r1.xyz = (r1.xyz) * (c13.yyy);
    r0.w = max(abs(r6.y), abs(r6.z));
    r1.w = max(abs(r6.x), r0.w);
    r2.xyz = (r6.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r2.xyz = (r2.xyz) * (r0.www) + (v5.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r6 = tex2D(s5, v4.xy);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r7 = tex2D(s4, v4.xy);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r0.xyz = (r2.xyz) * (c13.zzz) + (r0.xyz);
    r1.xyz = (r1.xyz) * (r7.xyz);
    r0.xyz = (r0.xyz) * (r6.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c0.yyy);
    r0 = tex2D(s2, v4.xy);
    r0.x = (-(r0.x)) + (c0.x);
    r0.yzw = (r3.xyz) * (-(r4.xyz)) + (r1.xyz);
    r0.xyz = (r0.xxx) * (r0.yzw) + (r5.xyz);
    r0.w = c0.x;
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
    oC0.w = c0.x;

    return oC0;
}
