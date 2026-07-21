// Mechanically reconstructed from 0xAE815250.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
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
    const float4 c0 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c13 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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

    r0.w = dot(v5.xyz, v5.xyz);
    r1.w = rsqrt(r0.w);
    r0.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.xyz = (r1.www) * (v5.xyz);
    r9.xyz = normalize(v2.xyz);
    r2.z = (-(r0.w)) + (c0.w);
    r0.w = saturate(dot(r9.xyz, -(r0.xyz)));
    r2.w = (r2.z) * (r2.z);
    r1.w = (-(r0.w)) + (c0.w);
    r2.y = (r2.w) * (r2.w);
    r2.w = (r1.w) * (r1.w);
    r6.w = (r2.z) * (r2.y);
    r1.w = (r1.w) * (r2.w);
    r3 = tex2D(s2, v1.xy);
    r2.z = (r3.w) * (-(c1.x)) + (c1.y);
    r3.z = (r3.w) * (c1.x);
    r2.w = (r0.w) * (r2.z) + (r3.z);
    r2.xy = (r3.ww) * (c3.xy) + (c3.zw);
    r0.w = (r3.w) * (c0.y);
    r3.w = 1.0f / (r2.x);
    r2.y = exp2(r2.y);
    r2.x = saturate(dot(r9.xyz, r1.xyz));
    r3.w = (r1.w) * (r3.w);
    r1.y = pow(abs(r2.x), r2.y);
    r1.z = (r2.y) * (c4.x) + (c4.y);
    r1.w = saturate(dot(r9.xyz, c[17].xyz));
    r1.z = (r1.y) * (r1.z);
    r1.y = (r1.w) * (r2.z) + (r3.z);
    r1.y = (r1.y) * (r2.w) + (c1.z);
    r1.x = dot(r0.xyz, r9.xyz);
    r1.y = 1.0f / (r1.y);
    r1.x = (r1.x) + (r1.x);
    r1.y = (r1.w) * (r1.y);
    r0.xyz = (r9.xyz) * (-(r1.xxx)) + (r0.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.z = (r1.z) * (r1.y);
    r2.xyz = (r0.xyz) * (c0.yyy);
    r0 = tex3D(s11, v6.xyz);
    r2.w = max(abs(r9.y), abs(r9.z));
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = max(abs(r9.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r9.xyz) * (c[5].xyz);
    r1.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r7.xyz = (r1.xyz) * (c0.zzz);
    r0.xyz = (r3.yyy) * (r0.xyz);
    r11.xyz = (r0.xyz) * (c0.zzz);
    r8.xyz = (r1.www) * (c[18].xyz);
    if ((c0.w) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c1.yyyw);
        r0 = (r1) + (-(c12.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c4.zzww);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (-(c4.zzww));
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c12.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r5.w = dot(r0, c4.yyyy);
        if ((c12.w) < (v4.w))
        {
            r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r5.xy) + (c4.zz);
            r0.zw = (v4.zx) * (c1.yw);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r5.xy) + (-(c4.zz));
            r1.zw = (v4.zx) * (c1.yw);
            r4 = tex2Dlod(s1, r1);
            r1.xy = (r5.xy) + (c12.xy);
            r1.zw = (v4.zx) * (c1.yw);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r5.xy) + (-(c12.xy));
            r1.zw = (v4.zx) * (c1.yw);
            r1 = tex2Dlod(s1, r1);
            r0.y = r4.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c4.yyyy);
            r0.z = (-(r5.w)) + (r0.w);
            r0.w = (v4.w) * (c13.x) + (c13.y);
            r1.w = (r0.w) * (r0.z) + (r5.w);
        }
        else
        {
            r1.w = r5.w;
        }
    }
    else
    {
        r0.z = (v4.w) + (c13.z);
        r0.z = ((r0.z) >= 0.0f ? (c1.w) : (c1.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c4.zz);
            r1.zw = (v4.zz) * (c1.yw);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (-(c4.zz));
            r2.zw = (v4.zz) * (c1.yw);
            r5 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c12.xy);
            r2.zw = (v4.zz) * (c1.yw);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c12.xy));
            r2.zw = (v4.zz) * (c1.yw);
            r2 = tex2Dlod(s1, r2);
            r1.y = r5.x;
            r1.z = r4.x;
            r1.w = r2.x;
            r0.y = dot(r1, c4.yyyy);
            r0.z = saturate((v4.w) + (c13.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r1.w = r0.w;
    }
    r0 = tex2D(s0, v1.xy);
    r1.xyz = lerp(r0.xyz, c0.xxx, r3.xxx);
    r6.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.www);
    r10.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (r6.www) + (r10.xyz);
    r1.xyz = (r3.zzz) * (r1.xyz);
    r8.xyz = (r1.www) * (r8.xyz) + (r11.xyz);
    r1.xyz = (r3.yyy) * (r1.xyz);
    r0.xyz = (r3.xxx) * (r0.xyz);
    r1.xyz = (r1.xyz) * (c[19].xyz);
    r11.xyz = (r1.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r5 = (-(v5.yyyy)) + (c[7]);
    r4 = (-(v5.xxxx)) + (c[6]);
    r1 = (r5) * (r5);
    r1 = (r4) * (r4) + (r1);
    r2 = (-(v5.zzzz)) + (c[8]);
    r8.xyz = (r0.xyz) * (r8.xyz) + (r11.xyz);
    r1 = (r2) * (r2) + (r1);
    r10.xyz = (r6.xyz) * (r3.www) + (r10.xyz);
    r6.x = rsqrt(r1.x);
    r6.y = rsqrt(r1.y);
    r6.z = rsqrt(r1.z);
    r6.w = rsqrt(r1.w);
    r7.xyz = (r7.xyz) * (r10.xyz);
    r5 = (r5) * (r6);
    r5 = (r9.yyyy) * (r5);
    r4 = (r4) * (r6);
    r2 = (r2) * (r6);
    r4 = (r4) * (r9.xxxx) + (r5);
    r2 = saturate((r2) * (r9.zzzz) + (r4));
    r3.x = c0.w;
    r1 = saturate((r1) * (c[9]) + (r3.xxxx));
    r3.xyz = (r7.xyz) * (r3.yyy) + (r8.xyz);
    r1 = (r2) * (r1);
    r2.z = dot(c[20], r1);
    r2.x = dot(c[10], r1);
    r2.y = dot(c[11], r1);
    r0.w = (r0.w) * (v0.w);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r0.www) * (v3.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = rsqrt(r0.w);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
