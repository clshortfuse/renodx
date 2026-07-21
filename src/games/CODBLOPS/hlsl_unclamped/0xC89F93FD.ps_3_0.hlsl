// Mechanically reconstructed from 0xC89F93FD.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler3D s11 : register(s11);

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
    const float4 c0 = float4(1.0f, -0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, -0.0f, 0.25f);
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

    r4 = tex2D(s0, v1.xy);
    r4.xyz = (r4.xyz) * (v0.www);
    r3 = (-(v5.yyyy)) + (c[7]);
    r2 = (-(v5.xxxx)) + (c[6]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[8]);
    r4.xyz = (r4.www) * (r4.xyz);
    r0 = (r1) * (r1) + (r0);
    r6.xyz = (r4.xyz) * (v0.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = normalize(v2.xyz);
    r3 = (r3) * (r4);
    r3 = (r5.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r5.xxxx) + (r3);
    r6.xyz = (r6.xyz) * (r6.xyz);
    r1 = saturate((r1) * (r5.zzzz) + (r2));
    r2.w = c0.x;
    r0 = saturate((r0) * (c[9]) + (r2.wwww));
    r2.w = max(abs(r5.y), abs(r5.z));
    r0 = (r1) * (r0);
    r1.w = max(abs(r5.x), r2.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r5.xyz) * (c[5].xyz);
    r7.z = dot(c[20], r0);
    r1.xyz = (r1.xyz) * (r1.www) + (v6.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.z = saturate(dot(c[17].xyz, r5.xyz));
    r7.x = dot(c[10], r0);
    r8.xyz = (r1.zzz) * (c[18].xyz);
    if ((c0.x) >= (v4.w))
    {
        r2 = (v4.xyzx) * (c0.xxxy);
        r1 = (r2) + (-(c3.xyzz));
        r1 = tex2Dlod(s1, r1);
        r1.w = r1.x;
        r3 = (r2) + (c0.zzyy);
        r3 = tex2Dlod(s1, r3);
        r1.x = r3.x;
        r3 = (r2) + (c0.wwyy);
        r3 = tex2Dlod(s1, r3);
        r1.y = r3.x;
        r2 = (r2) + (c3.xyzz);
        r2 = tex2Dlod(s1, r2);
        r1.z = r2.x;
        r5.w = dot(r1, c3.wwww);
        if ((c1.x) < (v4.w))
        {
            r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c0.zz);
            r1.zw = (v4.zx) * (c0.xy);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r5.xy) + (c0.ww);
            r2.zw = (v4.zx) * (c0.xy);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (c3.xy);
            r2.zw = (v4.zx) * (c0.xy);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r5.xy) + (-(c3.xy));
            r2.zw = (v4.zx) * (c0.xy);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c3.wwww);
            r1.z = (-(r5.w)) + (r1.w);
            r1.w = (v4.w) * (c1.y) + (c1.z);
            r1.w = (r1.w) * (r1.z) + (r5.w);
        }
        else
        {
            r1.w = r5.w;
        }
    }
    else
    {
        r1.z = (v4.w) + (c1.w);
        r1.z = ((r1.z) >= 0.0f ? (c0.y) : (c0.x));
        if ((r1.z) != (-(r1.z)))
        {
            r1.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c0.zz);
            r2.zw = (v4.zz) * (c0.xy);
            r2 = tex2Dlod(s1, r2);
            r3.xy = (r1.xy) + (c0.ww);
            r3.zw = (v4.zz) * (c0.xy);
            r5 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (c3.xy);
            r3.zw = (v4.zz) * (c0.xy);
            r4 = tex2Dlod(s1, r3);
            r3.xy = (r1.xy) + (-(c3.xy));
            r3.zw = (v4.zz) * (c0.xy);
            r3 = tex2Dlod(s1, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.y = dot(r2, c3.wwww);
            r1.z = saturate((v4.w) + (c1.z));
            r1.w = (r1.w) + (-(r1.y));
            r1.w = (r1.z) * (r1.w) + (r1.y);
        }
    }
    r7.y = dot(c[11], r0);
    r0.xyz = (r8.xyz) * (r1.www);
    r1.xyz = (r6.xyz) * (r7.xyz);
    r0.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
