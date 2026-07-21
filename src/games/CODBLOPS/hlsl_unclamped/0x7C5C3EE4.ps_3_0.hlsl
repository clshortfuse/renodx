// Mechanically reconstructed from 0x7C5C3EE4.ps_3_0.cso.
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
    const float4 c0 = float4(1.44269502f, 0.100000001f, 8.0f, 31.875f);
    const float4 c1 = float4(1.0f, 0.0f, 0.000244140625f, 0.25f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 0.5f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(2.0f, -1.0f, 9.99999975e-06f, 1e-15f);
    const float4 c14 = float4(-0.00537109375f, 30.0f, 0.0f, 0.0f);
    const float4 c15 = float4(3.5f, 1.0f, 12.0f, 0.0f);
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
        r3 = (v7.xyzx) * (c1.xxxy) + (c1.yyyx);
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
        if ((c3.w) < (v7.w))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zx) * (c1.xy) + (c1.yx);
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
            r2.y = (v7.w) * (c4.x) + (c4.y);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c4.z) + (v7.w);
        r2.x = ((r2.x) >= 0.0f ? (c1.y) : (c1.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v7.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v7.zz) * (c1.xy) + (c1.yx);
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
            r2.y = saturate((c4.y) + (v7.w));
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
    r5.xy = (c[23].xx) * (v5.xy);
    r5 = tex2D(s3, r5.xy);
    r5.xy = (r5.wy) * (c12.xy) + (c12.zw);
    r5.xy = (r5.xy) * (c4.ww) + (c4.ww);
    r5.xy = (r5.xy) * (c13.xx) + (c13.yy);
    r6 = tex2D(s2, v5.xy);
    r5.zw = (r6.wy) * (c12.xy) + (c12.zw);
    r5.zw = (r5.zw) * (c4.ww) + (c4.ww);
    r5.zw = (r5.zw) * (c13.xx) + (c13.yy);
    r5.xy = (c[24].xx) * (r5.xy) + (r5.zw);
    r1.xyz = (r1.xyz) * (r5.yyy);
    r1.xyz = (r5.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r5.xyz = normalize(r1.xyz);
    r1.xyz = (r2.xyz) * (c[6].xxx);
    r0.x = saturate(dot(r5.xyz, r4.xyz));
    r2.xyz = (r3.xyz) * (c[6].yyy);
    r3 = tex2D(s6, v5.xy);
    r1.w = max(c13.z, r3.x);
    r2.w = dot(-(v1.xyz), -(v1.xyz));
    r2.w = rsqrt(r2.w);
    r3.yzw = (r2.www) * (-(v1.xyz));
    r4.w = saturate(dot(r5.xyz, r3.yzw));
    r1.w = (r1.w) * (r1.w);
    r1.w = 1.0f / (r1.w);
    r6.xyz = (-(v1.xyz)) * (r2.www) + (r4.xyz);
    r7.xyz = normalize(r6.xyz);
    r2.w = saturate(dot(r5.xyz, r7.xyz));
    r5.w = (r2.w) * (r2.w) + (c13.w);
    r5.w = 1.0f / (r5.w);
    r6.x = (-(r5.w)) + (c1.x);
    r6.x = (r1.w) * (r6.x);
    r6.x = (r6.x) * (c0.x);
    r6.x = exp2(r6.x);
    r5.w = (r5.w) * (r5.w);
    r5.w = (r6.x) * (r5.w);
    r2.w = (r2.w) + (r2.w);
    r6.x = 1.0f / (r4.w);
    r2.w = (r2.w) * (r6.x);
    r6.x = min(r4.w, r0.x);
    r2.w = saturate((r2.w) * (r6.x));
    r2.w = (r0.x) * (r2.w);
    r2.w = rsqrt(r2.w);
    r2.w = 1.0f / (r2.w);
    r2.w = (r5.w) * (r2.w);
    r2.xyz = (r2.xyz) * (r2.www);
    r0.z = saturate(dot(r0.zwy, r3.yzw));
    r0.z = (r4.w) + (r0.z);
    r0.z = (r0.z) * (c4.w);
    r2.w = max(c0.y, r0.z);
    r0.z = 1.0f / (r2.w);
    r0.z = rsqrt(r0.z);
    r0.z = 1.0f / (r0.z);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r0.z = (r1.w) * (c1.w);
    r2.xyz = (r2.xyz) * (r0.zzz);
    r6.xyz = normalize(v1.xyz);
    r0.z = dot(r6.xyz, r5.xyz);
    r0.w = (r0.z) + (r0.z);
    r6.xyz = (r5.xyz) * (-(r0.www)) + (r6.xyz);
    r6.w = (r3.x) * (c0.z);
    r6 = texCUBElod(s15, r6);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r6.xyz = (r6.xyz) * (c0.zzz);
    r7 = tex3D(s11, v6.xyz);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r6.xyz = (r6.xyz) * (r7.xyz);
    r6.xyz = (r6.xyz) * (c[22].xxx);
    r6.xyz = (r6.xyz) * (c0.www);
    r7 = tex2D(s4, v5.xy);
    r0.z = saturate(r0.z);
    r0.z = (-(r0.z)) + (c1.x);
    r0.w = (r0.z) * (r0.z);
    r0.z = (r0.z) * (r0.w);
    r0.w = (r7.w) * (c15.x) + (c15.y);
    r0.w = 1.0f / (r0.w);
    r0.z = (r0.z) * (r0.w);
    r8.xyz = lerp(r7.xyz, c1.xxx, r0.zzz);
    r6.xyz = (r6.xyz) * (r8.xyz);
    r2.xyz = (r2.xyz) * (c1.www) + (r6.xyz);
    r2.xyz = (c[7].xxx) * (-(r2.xyz)) + (r2.xyz);
    r0.z = max(abs(r5.y), abs(r5.z));
    r1.w = max(abs(r5.x), r0.z);
    r6.xyz = (r5.xyz) * (c[5].xyz);
    r0.z = 1.0f / (r1.w);
    r6.xyz = (r6.xyz) * (r0.zzz) + (v6.xyz);
    r6 = tex3D(s11, r6.xyz);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r3.x = c[6].x;
    r8.xyz = (r3.xxx) * (c[18].xyz);
    r0.z = dot(-(r4.xyz), r5.xyz);
    r0.z = (r0.z) + (r0.z);
    r5.xyz = (r5.xyz) * (-(r0.zzz)) + (-(r4.xyz));
    r0.z = dot(r4.xyz, -(r3.yzw));
    r0.z = saturate((r0.z) * (c4.w) + (c4.w));
    r0.z = (r0.z) + (r0.z);
    r1.w = pow(abs(r0.z), c15.z);
    r0.z = (r1.w) * (c[25].x);
    r0.w = (r1.w) * (c14.x) + (c14.y);
    r0.z = (r0.z) * (c1.z);
    r1.w = saturate(dot(r5.xyz, r3.yzw));
    r2.w = pow(abs(r1.w), r0.w);
    r3.xyz = max(r8.xyz, c1.xxx);
    r3.xyz = (r2.www) * (r3.xyz);
    r3.xyz = (r0.zzz) * (r3.xyz);
    r0.y = saturate(r0.y);
    r0.y = (r6.w) * (r0.y);
    r0.yzw = (r3.xyz) * (r0.yyy);
    r0.yzw = (r6.xyz) * (c0.www) + (r0.yzw);
    r3 = tex2D(s5, v5.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (v4.xyz);
    r0.xyz = (r0.xxx) * (r1.xyz) + (r0.yzw);
    r1.xyz = (r7.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = max(r0.xyz, c1.yyy);
    r0 = c[8];
    r0.w = (r0.w) * (c[21].x);
    r2.xyz = lerp(c1.xxx, r0.xyz, r0.www);
    r0.xyz = (r1.xyz) * (r2.xyz);
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
