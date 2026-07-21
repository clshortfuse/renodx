// Mechanically reconstructed from 0x8E65315F.ps_3_0.cso.
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
    const float4 c0 = float4(31.875f, 8.0f, 3.0f, -3.0f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c12 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c13 = float4(0.5f, 2.0f, -1.0f, 0.0357140005f);
    const float4 c14 = float4(-0.600000024f, -0.800000012f, 10.0f, 0.107143f);
    const float4 c15 = float4(6.0f, 1.25f, 0.0199999996f, 3.33333325f);
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
    if ((c4.x) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c4.xxxy) + (c4.zzzx);
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
        r1.w = dot(r4, c1.wwww);
        if ((c3.x) < (v6.w))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zx) * (c4.xy) + (c4.zx);
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
            r2.y = (v6.w) * (c3.y) + (c3.z);
            r3.x = lerp(r1.w, r2.x, r2.y);
            r1.w = r3.x;
        }
    }
    else
    {
        r2.x = (c3.w) + (v6.w);
        r2.x = ((r2.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r2.x) != (-(r2.x)))
        {
            r3.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = (v6.zz) * (c4.xy) + (c4.zx);
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
            r2.y = saturate((c3.z) + (v6.w));
            r1.w = lerp(r2.x, r2.w, r2.y);
        }
        else
        {
            r1.w = r2.w;
        }
    }
    r2.xyz = (r1.www) * (c[18].xyz);
    r3.xyz = normalize(c[17].xyz);
    r4 = tex2D(s3, v4.xy);
    r4.xy = (r4.wy) * (c12.xy) + (c12.zw);
    r4.xy = (r4.xy) * (c13.xx) + (c13.xx);
    r4.xy = (r4.xy) * (c13.yy) + (c13.zz);
    r5 = tex2D(s2, v4.xy);
    r4.zw = (r5.wy) * (c12.xy) + (c12.zw);
    r4.zw = (r4.zw) * (c13.xx) + (c13.xx);
    r4.zw = (r4.zw) * (c13.yy) + (c13.zz);
    r1.w = saturate((c[28].x) * (v7.z));
    r2.w = (r1.w) * (c[30].x);
    r4.zw = (r4.zw) * (r2.ww);
    r4.xy = (c[29].xx) * (r4.xy) + (r4.zw);
    r1.xyz = (r1.xyz) * (r4.yyy);
    r1.xyz = (r4.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (v2.xyz) * (r0.xxx) + (r1.xyz);
    r4.xyz = normalize(r1.xyz);
    r1.xy = v4.xy;
    r5.xy = (r1.xy) * (c[33].xx) + (v7.xy);
    r5 = tex2D(s8, r5.xy);
    r2.xyz = (r2.xyz) * (c[21].xxx);
    r0.x = saturate(dot(r4.xyz, r3.xyz));
    r2.xyz = (r2.xyz) * (r0.xxx);
    r0.x = max(abs(r4.y), abs(r4.z));
    r1.z = max(abs(r4.x), r0.x);
    r3.xyz = (r4.xyz) * (c[5].xyz);
    r0.x = 1.0f / (r1.z);
    r3.xyz = (r3.xyz) * (r0.xxx) + (v5.xyz);
    r3 = tex3D(s11, r3.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.xy = (r1.xy) * (c[34].xx) + (v7.xy);
    r6 = tex2D(s8, r1.xy);
    r7 = tex2D(s5, v4.xy);
    r1.xyz = (r7.xyz) * (r7.xyz);
    r5.yzw = (r7.xyz) * (-(r7.xyz)) + (c13.www);
    r5.yzw = (r6.yyy) * (r5.yzw) + (r1.xyz);
    r2.xyz = (r3.xyz) * (c0.xxx) + (r2.xyz);
    r3.xyz = (r5.yzw) * (r2.xyz);
    r5.yzw = max(r3.xyz, c4.yyy);
    r3.xyz = normalize(v1.xyz);
    r0.x = dot(r3.xyz, r4.xyz);
    r0.x = (r0.x) + (r0.x);
    r3.xyz = (r4.xyz) * (-(r0.xxx)) + (r3.xyz);
    r3.w = c0.y;
    r3 = texCUBElod(s15, r3);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r4.xyz = (r3.xyz) * (c0.yyy);
    r6 = tex3D(s11, v5.xyz);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r6.xyz = (r6.xyz) * (c0.xxx);
    r4.xyz = (r4.xyz) * (r6.xyz);
    r4.xyz = (r4.xyz) * (c[27].xxx);
    r7 = tex2D(s4, v4.xy);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r4.xyz = (r4.xyz) * (r7.xyz) + (r1.xyz);
    r8.xyz = max(r4.xyz, c4.yyy);
    r2.w = c[22].w;
    r4.xy = (r2.ww) * (c[32].xy);
    r4.xy = (r4.xy) * (c[31].xx);
    r4.xy = (v4.xy) * (c[31].xx) + (r4.xy);
    r4 = tex2D(s7, r4.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r4.xyz) * (c[35].xxx);
    r9 = tex2D(s6, v4.xy);
    r9.xyz = saturate((r9.xyz) * (-(c3.zzz)));
    r4.xyz = (r4.xyz) * (r9.xyz);
    r3.xyz = (r3.xyz) * (r6.xyz);
    r3.xyz = (r3.xyz) * (c[27].xxx);
    r3.xyz = (r3.xyz) * (c0.yyy);
    r1.xyz = (r3.xyz) * (r7.xyz) + (r1.xyz);
    r6.xyz = max(r1.xyz, c4.yyy);
    r0.x = (r5.x) * (c0.z) + (c0.w);
    r1.w = saturate(r1.w);
    r0.x = (r1.w) * (c15.x) + (r0.x);
    r1.x = (-(r0.x)) + (c4.x);
    r1.y = (r1.x) * (c15.y);
    r2.w = min(r1.y, c4.x);
    r1.y = (r2.w) * (r2.w) + (-(c4.x));
    r1.z = ddx(r1.y);
    r1.w = ddy(r1.y);
    r1.y = (r1.y) * (c15.z);
    r2.w = dot(r1.zw, r1.zw) + (c4.y);
    r2.w = rsqrt(r2.w);
    r1.zw = (r1.zw) * (r2.ww);
    r1.yz = (r1.yy) * (r1.zw) + (v4.xy);
    r7 = tex2D(s5, r1.yz);
    r7.xyz = (r7.xyz) * (r7.xyz);
    r9 = tex2D(s4, r1.yz);
    r1.yzw = (r3.xyz) * (r9.xyz);
    r1.yzw = (r2.xyz) * (r7.xyz) + (r1.yzw);
    r2.xyz = max(r1.yzw, c4.yyy);
    r1.y = saturate((r0.x) * (c15.w));
    r1.y = rsqrt(r1.y);
    r1.y = 1.0f / (r1.y);
    r3.xyz = lerp(r2.xyz, r5.yzw, r1.yyy);
    r1.yz = (r0.xx) + (c14.xy);
    r1.yz = saturate((r1.yz) * (c14.zz));
    r0.x = rsqrt(r1.y);
    r0.x = 1.0f / (r0.x);
    r2.xyz = (r8.xyz) * (r4.xyz) + (-(r3.xyz));
    r2.xyz = (r0.xxx) * (r2.xyz) + (r3.xyz);
    r0.x = rsqrt(r1.z);
    r0.x = 1.0f / (r0.x);
    r1.yzw = (r6.xyz) * (c14.www) + (-(r2.xyz));
    r1.yzw = (r0.xxx) * (r1.yzw) + (r2.xyz);
    oC0.w = ((r1.x) >= 0.0f ? (c4.x) : (c4.y));
    r2 = (c[6]) + (-(v1.xxxx));
    r3 = (c[7]) + (-(v1.yyyy));
    r4 = (c[8]) + (-(v1.zzzz));
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
    r5 = saturate((r5) * (c[9]) + (r0.xxxx));
    r3 = (r0.zzzz) * (r3);
    r2 = (r2) * (r0.yyyy) + (r3);
    r0 = saturate((r4) * (r0.wwww) + (r2));
    r0 = (r5) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.yzw) * (r2.xyz) + (r1.yzw);
    r0.w = c4.x;
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r1.z = dot(r0, c[26]);
    r0.w = v1.w;
    r2.xyz = lerp(v0.xyz, r1.xyz, r0.www);
    r0.xyz = max(((r2.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
