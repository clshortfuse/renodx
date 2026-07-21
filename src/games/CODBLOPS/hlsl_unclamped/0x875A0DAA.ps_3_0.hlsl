// Mechanically reconstructed from 0x875A0DAA.ps_3_0.cso.
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
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r1.xyz = normalize(v2.xyz);
    r2.w = max(abs(r1.y), abs(r1.z));
    r0.w = max(abs(r1.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r1.xyz) * (c[5].xyz);
    r1.w = saturate(dot(c[17].xyz, r1.xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v5.xyz);
    r0 = tex3D(s11, r0.xyz);
    r5.xyz = (r1.www) * (c[18].xyz);
    if ((c0.x) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c0.xxxy);
        r0 = (r1) + (-(c3.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c0.zzyy);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (c0.wwyy);
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c3.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c3.wwww);
        if ((c1.x) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c0.zz);
            r0.zw = (v4.zx) * (c0.xy);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (c0.ww);
            r1.zw = (v4.zx) * (c0.xy);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c3.xy);
            r1.zw = (v4.zx) * (c0.xy);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c3.xy));
            r1.zw = (v4.zx) * (c0.xy);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v4.w) * (c1.y) + (c1.z);
            r1.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r1.w = r4.w;
        }
    }
    else
    {
        r0.z = (v4.w) + (c1.w);
        r0.z = ((r0.z) >= 0.0f ? (c0.y) : (c0.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c0.zz);
            r1.zw = (v4.zz) * (c0.xy);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c0.ww);
            r2.zw = (v4.zz) * (c0.xy);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c3.xy);
            r2.zw = (v4.zz) * (c0.xy);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c3.xy));
            r2.zw = (v4.zz) * (c0.xy);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c3.wwww);
            r0.z = saturate((v4.w) + (c1.z));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r1.w = r0.w;
    }
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r0.xyz) * (v0.www);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (v0.xyz);
    r1.xyz = (r5.xyz) * (r1.www);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
