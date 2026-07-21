// Mechanically reconstructed from 0xD8B8E904.ps_3_0.cso.
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
    const float4 c7 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c8 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c9 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r1.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r1.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r2.w = (-(r0.w)) + (c1.w);
    r2.z = (r2.w) * (r2.w);
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2.z = (r2.z) * (r2.z);
    r0 = v2;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r9.w = (r2.w) * (r2.z);
    r0.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r8.xyz = normalize(r0.xyz);
    r9.xyz = (r1.www) * (v7.xyz);
    r3.w = saturate(dot(r8.xyz, r1.xyz));
    r7.w = saturate(dot(r8.xyz, -(r9.xyz)));
    r1 = tex2D(s3, v1.xy);
    r0.z = (r1.w) * (-(c3.x)) + (c3.y);
    r12.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r0.x = (r1.w) * (c3.x);
    r1.z = exp2(r12.y);
    r0.y = (r7.w) * (r0.z) + (r0.x);
    r2.z = pow(abs(r3.w), r1.z);
    r2.w = (r1.z) * (c7.x) + (c7.y);
    r1.z = saturate(dot(r8.xyz, c[17].xyz));
    r3.w = (r2.z) * (r2.w);
    r0.z = (r1.z) * (r0.z) + (r0.x);
    r0.z = (r0.z) * (r0.y) + (c3.z);
    r2.w = max(abs(r8.y), abs(r8.z));
    r2.z = 1.0f / (r0.z);
    r0.z = max(abs(r8.x), r2.w);
    r2.w = 1.0f / (r0.z);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r3.z = (r1.z) * (r2.z);
    r0.xyz = (r0.xyz) * (r2.www) + (v8.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r8.w = (r3.w) * (r3.z);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r11.xyz = (r0.xyz) * (c1.zzz);
    r10.xyz = (r1.zzz) * (c[18].xyz);
    if ((c1.w) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c3.yyyw);
        r2 = (r3) + (-(c8.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c7.zzww);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (-(c7.zzww));
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c8.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r1.z = dot(r2, c7.yyyy);
        if ((c8.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c7.zz);
            r2.zw = (v6.zx) * (c3.yw);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (-(c7.zz));
            r3.zw = (v6.zx) * (c3.yw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c8.xy);
            r3.zw = (v6.zx) * (c3.yw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c8.xy));
            r3.zw = (v6.zx) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.z = dot(r2, c7.yyyy);
            r0.y = (-(r1.z)) + (r0.z);
            r0.z = (v6.w) * (c9.x) + (c9.y);
            r1.z = (r0.z) * (r0.y) + (r1.z);
        }
    }
    else
    {
        r0.z = (v6.w) + (c9.z);
        r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c7.zz);
            r3.zw = (v6.zz) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c7.zz));
            r4.zw = (v6.zz) * (c3.yw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c8.xy);
            r4.zw = (v6.zz) * (c3.yw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c8.xy));
            r4.zw = (v6.zz) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c7.yyyy);
            r0.z = saturate((v6.w) + (c9.y));
            r0.y = (r2.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r2.w;
        }
        r1.z = r0.z;
    }
    r2 = tex2D(s0, v1.xy);
    r0.xyz = lerp(r2.xyz, c1.xxx, r1.xxx);
    r3.xyz = (r0.xyz) * (-(r0.xyz)) + (c1.www);
    r7.xyz = (r0.xyz) * (r0.xyz);
    r5.xyz = (r1.zzz) * (r10.xyz) + (r11.xyz);
    r0.xyz = (r3.xyz) * (r9.www) + (r7.xyz);
    r2.xyz = (r1.xxx) * (r2.xyz);
    r0.xyz = (r8.www) * (r0.xyz);
    r2.xyz = (r2.xyz) * (v0.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (c[19].xyz);
    r6.xyz = (r1.zzz) * (r0.xyz);
    r1.z = 1.0f / (r12.x);
    r1.x = (-(r7.w)) + (c1.w);
    r0.z = dot(r9.xyz, r8.xyz);
    r3.w = (r1.x) * (r1.x);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r1.w) * (c1.y);
    r2.xyz = (r8.xyz) * (-(r0.zzz)) + (r9.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.x) * (r3.w);
    r8.xyz = (r0.xyz) * (c1.yyy);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = (r1.z) * (r1.w);
    r0.xyz = (r8.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c1.zzz);
    r3.xyz = (r3.xyz) * (r1.www) + (r7.xyz);
    r2.xyz = (r4.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.yyy) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.w;

    return oC0;
}
