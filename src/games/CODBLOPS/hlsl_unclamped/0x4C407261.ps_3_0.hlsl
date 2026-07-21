// Mechanically reconstructed from 0x4C407261.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 31.875f, 1.0f, 0.0f);
    const float4 c1 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c3 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.25f);
    const float4 c4 = float4(4.0f, -3.0f, -4.0f, 0.0f);
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

    r8.xyz = normalize(v2.xyz);
    r1.w = max(abs(r8.y), abs(r8.z));
    r0.w = max(abs(r8.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r8.xyz) * (c[5].xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r1.w = saturate(dot(c[17].xyz, r8.xyz));
    r0.xyz = c[18].xyz;
    r0.xyz = (r0.xyz) * (c[21].xxx);
    r7.xyz = (r1.xyz) * (c0.yyy);
    r6.xyz = (r1.www) * (r0.xyz);
    if ((c0.z) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c0.zzzw);
        r0 = (r1) + (-(c1.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c3.xxyy);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (c3.zzyy);
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c1.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r6.w = dot(r0, c3.wwww);
        if ((c1.w) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c3.xx);
            r0.zw = (v4.zx) * (c0.zw);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (c3.zz);
            r1.zw = (v4.zx) * (c0.zw);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c1.xy);
            r1.zw = (v4.zx) * (c0.zw);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c1.xy));
            r1.zw = (v4.zx) * (c0.zw);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r6.w)) + (r0.w);
            r0.w = (v4.w) * (c4.x) + (c4.y);
            r6.w = (r0.w) * (r0.z) + (r6.w);
        }
    }
    else
    {
        r0.z = (v4.w) + (c4.z);
        r0.z = ((r0.z) >= 0.0f ? (c0.w) : (c0.z));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c3.xx);
            r1.zw = (v4.zz) * (c0.zw);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c3.zz);
            r2.zw = (v4.zz) * (c0.zw);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c1.xy);
            r2.zw = (v4.zz) * (c0.zw);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c1.xy));
            r2.zw = (v4.zz) * (c0.zw);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c3.wwww);
            r0.z = saturate((v4.w) + (c4.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r6.w = r0.w;
    }
    r0.xy = (v1.xy) * (c[22].xy);
    r0 = tex2D(s2, r0.xy);
    r9.xyz = (r0.xyz) + (c0.xxx);
    r5 = tex2D(s0, v1.xy);
    r3 = (-(v5.yyyy)) + (c[7]);
    r2 = (-(v5.xxxx)) + (c[6]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[8]);
    r0 = (r1) * (r1) + (r0);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.xyz = saturate((r9.xyz) * (r5.www) + (r5.xyz));
    r3 = (r3) * (r4);
    r3 = (r8.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r8.xxxx) + (r3);
    r1 = saturate((r1) * (r8.zzzz) + (r2));
    r2.y = c0.z;
    r0 = saturate((r0) * (c[9]) + (r2.yyyy));
    r0 = (r1) * (r0);
    r1.xyz = (r5.xyz) * (v0.xyz);
    r2.z = dot(c[20], r0);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r0.xyz = (r6.www) * (r6.xyz) + (r7.xyz);
    r2.xyz = (r2.xyz) * (r1.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r2.xyz);
    r0.w = c0.z;
    r1.z = dot(r0, c[26]);
    r1.x = dot(r0, c[24]);
    r1.y = dot(r0, c[25]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[23].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
