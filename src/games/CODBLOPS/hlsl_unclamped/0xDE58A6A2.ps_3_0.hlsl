// Mechanically reconstructed from 0xDE58A6A2.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
    float4 v8 : TEXCOORD6;
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
    float4 v8 = input.v8;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c14 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r0.w);
    r1.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r3.xyz = normalize(r1.xyz);
    r0 = v2;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r1.xyz = (r2.www) * (v7.xyz);
    r1.w = (-(r1.w)) + (c1.w);
    r0.y = saturate(dot(r10.xyz, -(r1.xyz)));
    r0.x = (r1.w) * (r1.w);
    r0.z = (-(r0.y)) + (c1.w);
    r2.w = (r0.x) * (r0.x);
    r0.x = (r0.z) * (r0.z);
    r9.w = (r1.w) * (r2.w);
    r4.w = (r0.z) * (r0.x);
    r2 = tex2D(s3, v1.xy);
    r0.z = (r2.w) * (-(c3.x)) + (c3.y);
    r4.z = (r2.w) * (c3.x);
    r3.w = (r0.y) * (r0.z) + (r4.z);
    r0.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r1.w = (r2.w) * (c1.y);
    r0.x = 1.0f / (r0.x);
    r2.w = (r4.w) * (r0.x);
    r4.w = exp2(r0.y);
    r3.z = saturate(dot(r10.xyz, r3.xyz));
    r2.z = saturate(dot(r10.xyz, c[17].xyz));
    r0.x = pow(abs(r3.z), r4.w);
    r0.y = (r2.z) * (r0.z) + (r4.z);
    r0.z = (r4.w) * (c12.x) + (c12.y);
    r0.y = (r0.y) * (r3.w) + (c3.z);
    r0.z = (r0.x) * (r0.z);
    r0.y = 1.0f / (r0.y);
    r0.y = (r2.z) * (r0.y);
    r3.w = max(abs(r10.y), abs(r10.z));
    r8.w = (r0.z) * (r0.y);
    r0.z = max(abs(r10.x), r3.w);
    r3.w = 1.0f / (r0.z);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r4.w = dot(r1.xyz, r10.xyz);
    r0.xyz = (r0.xyz) * (r3.www) + (v8.xyz);
    r3 = tex3D(s11, r0.xyz);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r10.w = (r4.w) + (r4.w);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r9.xyz = (r0.xyz) * (c1.zzz);
    r8.xyz = (r2.zzz) * (c[18].xyz);
    if ((c1.w) >= (v6.w))
    {
        r4 = (v6.xyzx) * (c3.yyyw);
        r3 = (r4) + (-(c13.xyzz));
        r3 = tex2Dlod(s2, r3);
        r3.w = r3.x;
        r5 = (r4) + (c12.zzww);
        r5 = tex2Dlod(s2, r5);
        r3.x = r5.x;
        r5 = (r4) + (-(c12.zzww));
        r5 = tex2Dlod(s2, r5);
        r3.y = r5.x;
        r4 = (r4) + (c13.xyzz);
        r4 = tex2Dlod(s2, r4);
        r3.z = r4.x;
        r2.z = dot(r3, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c12.zz);
            r3.zw = (v6.zx) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c12.zz));
            r4.zw = (v6.zx) * (c3.yw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c13.xy);
            r4.zw = (v6.zx) * (c3.yw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c13.xy));
            r4.zw = (v6.zx) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.z = dot(r3, c12.yyyy);
            r0.y = (-(r2.z)) + (r0.z);
            r0.z = (v6.w) * (c14.x) + (c14.y);
            r2.z = (r0.z) * (r0.y) + (r2.z);
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.xy = (r0.xy) + (c12.zz);
            r4.zw = (v6.zz) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r5.xy = (r0.xy) + (-(c12.zz));
            r5.zw = (v6.zz) * (c3.yw);
            r7 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (c13.xy);
            r5.zw = (v6.zz) * (c3.yw);
            r6 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (-(c13.xy));
            r5.zw = (v6.zz) * (c3.yw);
            r5 = tex2Dlod(s2, r5);
            r4.y = r7.x;
            r4.z = r6.x;
            r4.w = r5.x;
            r0.x = dot(r4, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r3.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r3.w;
        }
        r2.z = r0.z;
    }
    r1.xyz = (r10.xyz) * (-(r10.www)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r7.xyz = (r2.zzz) * (r8.xyz) + (r9.xyz);
    r4.xyz = (r0.xyz) * (c1.yyy);
    r3 = tex3D(s11, v8.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = lerp(r1.xyz, c1.xxx, r2.xxx);
    r9.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.www);
    r11.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r9.xyz) * (r9.www) + (r11.xyz);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r0.xyz = (r8.www) * (r0.xyz);
    r6.xyz = (r4.xyz) * (r3.xyz);
    r3.xyz = (r2.yyy) * (r0.xyz);
    r0.xyz = (r2.xxx) * (r1.xyz);
    r1.xyz = (r3.xyz) * (c[19].xyz);
    r8.xyz = (r2.zzz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r5 = (-(v7.yyyy)) + (c[7]);
    r4 = (-(v7.xxxx)) + (c[6]);
    r1 = (r5) * (r5);
    r1 = (r4) * (r4) + (r1);
    r3 = (-(v7.zzzz)) + (c[8]);
    r7.xyz = (r0.xyz) * (r7.xyz) + (r8.xyz);
    r1 = (r3) * (r3) + (r1);
    r8.xyz = (r6.xyz) * (c1.zzz);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r9.xyz = (r9.xyz) * (r2.www) + (r11.xyz);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r2.x = c1.w;
    r1 = saturate((r1) * (c[9]) + (r2.xxxx));
    r4.xyz = (r8.xyz) * (r9.xyz);
    r1 = (r3) * (r1);
    r3.xyz = (r4.xyz) * (r2.yyy) + (r7.xyz);
    r2.z = dot(c[20], r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.w;

    return oC0;
}
