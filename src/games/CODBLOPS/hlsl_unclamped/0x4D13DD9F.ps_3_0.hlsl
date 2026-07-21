// Mechanically reconstructed from 0x4D13DD9F.ps_3_0.cso.
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
    const float4 c0 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c1 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c3 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, -0.0f, -4.0f);
    const float4 c12 = float4(1.0f, -0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c13 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r1.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.xyz = normalize(r1.xyz);
    r0.w = saturate(dot(r0.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c0.z);
    r1.z = (r0.w) * (r0.w);
    r1.z = (r1.z) * (r1.z);
    r6.xyz = normalize(v2.xyz);
    r6.w = (r0.w) * (r1.z);
    r1.z = max(abs(r6.y), abs(r6.z));
    r8.w = saturate(dot(r6.xyz, r0.xyz));
    r0.w = max(abs(r6.x), r1.z);
    r0.w = 1.0f / (r0.w);
    r7.xyz = (r1.www) * (v5.xyz);
    r5.w = saturate(dot(r6.xyz, -(r7.xyz)));
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r7.w = saturate(dot(r6.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v6.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[7].yyy);
    r11.xy = c[6].xy;
    r0.xyz = (r11.xxx) * (c[18].xyz);
    r9.xyz = (r1.xyz) * (c0.yyy);
    r8.xyz = (r7.www) * (r0.xyz);
    if ((c0.z) >= (v4.w))
    {
        r1 = (v4.xyzx) * (c12.xxxy);
        r0 = (r1) + (-(c4.xyzz));
        r0 = tex2Dlod(s1, r0);
        r0.w = r0.x;
        r2 = (r1) + (c12.zzyy);
        r2 = tex2Dlod(s1, r2);
        r0.x = r2.x;
        r2 = (r1) + (c12.wwyy);
        r2 = tex2Dlod(s1, r2);
        r0.y = r2.x;
        r1 = (r1) + (c4.xyzz);
        r1 = tex2Dlod(s1, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c1.zzzz);
        if ((c1.w) < (v4.w))
        {
            r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c12.zz);
            r0.zw = (v4.zx) * (c12.xy);
            r0 = tex2Dlod(s1, r0);
            r1.xy = (r4.xy) + (c12.ww);
            r1.zw = (v4.zx) * (c12.xy);
            r3 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (c4.xy);
            r1.zw = (v4.zx) * (c12.xy);
            r2 = tex2Dlod(s1, r1);
            r1.xy = (r4.xy) + (-(c4.xy));
            r1.zw = (v4.zx) * (c12.xy);
            r1 = tex2Dlod(s1, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c1.zzzz);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v4.w) * (c13.x) + (c13.y);
            r1.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r1.w = r4.w;
        }
    }
    else
    {
        r0.z = (v4.w) + (c4.w);
        r0.z = ((r0.z) >= 0.0f ? (c12.y) : (c12.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c12.zz);
            r1.zw = (v4.zz) * (c12.xy);
            r1 = tex2Dlod(s1, r1);
            r2.xy = (r0.xy) + (c12.ww);
            r2.zw = (v4.zz) * (c12.xy);
            r4 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (c4.xy);
            r2.zw = (v4.zz) * (c12.xy);
            r3 = tex2Dlod(s1, r2);
            r2.xy = (r0.xy) + (-(c4.xy));
            r2.zw = (v4.zz) * (c12.xy);
            r2 = tex2Dlod(s1, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c1.zzzz);
            r0.z = saturate((v4.w) + (c13.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r1.w = r0.w;
    }
    r0 = tex2D(s2, v1.xy);
    r2.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.zzz);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0.z = (r0.w) * (-(c0.w)) + (c0.z);
    r0.x = (r0.w) * (c0.w);
    r0.y = (r5.w) * (r0.z) + (r0.x);
    r0.z = (r7.w) * (r0.z) + (r0.x);
    r0.z = (r0.z) * (r0.y) + (c1.x);
    r10.xy = (r0.ww) * (c3.xy) + (c3.zw);
    r0.x = 1.0f / (r0.z);
    r1.z = exp2(r10.y);
    r0.y = pow(abs(r8.w), r1.z);
    r0.z = (r1.z) * (c1.y) + (c1.z);
    r1.y = (r7.w) * (r0.x);
    r1.z = (r0.y) * (r0.z);
    r0.xyz = (r2.xyz) * (r6.www) + (r5.xyz);
    r1.z = (r1.y) * (r1.z);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r0.xyz = (r0.xyz) * (c[7].www);
    r1.xyz = (r11.yyy) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r3.xyz = (r1.www) * (r8.xyz) + (r9.xyz);
    r4.xyz = (r1.www) * (r0.xyz);
    r1 = tex2D(s0, v1.xy);
    r0.xyz = (r1.xyz) * (v0.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r2.w = 1.0f / (r10.x);
    r1.w = (-(r5.w)) + (c0.z);
    r0.z = dot(r7.xyz, r6.xyz);
    r3.w = (r1.w) * (r1.w);
    r0.z = (r0.z) + (r0.z);
    r0.w = (r0.w) * (c0.x);
    r0.xyz = (r6.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r1.w) * (r3.w);
    r6.xyz = (r0.xyz) * (c0.xxx);
    r0 = tex3D(s11, v6.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r2.w) * (r1.w);
    r0.xyz = (r6.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.yyy);
    r2.xyz = (r2.xyz) * (r0.www) + (r5.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (c[7].xxx) + (r1.xyz);
    r0.w = c0.z;
    r1.z = dot(r0, c[11]);
    r1.x = dot(r0, c[9]);
    r1.y = dot(r0, c[10]);
    r0.xyz = (r1.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.z;

    return oC0;
}
