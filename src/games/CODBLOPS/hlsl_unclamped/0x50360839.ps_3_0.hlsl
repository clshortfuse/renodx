// Mechanically reconstructed from 0x50360839.ps_3_0.cso.
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
    const float4 c1 = float4(8.0f, 31.875f, 1.0f, 0.797884583f);
    const float4 c3 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c14 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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
    r1.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r1.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r2.w = saturate(dot(r1.xyz, c[17].xyz));
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = (-(r2.w)) + (c1.z);
    r0.xyz = v2.xyz;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r2.w = (r0.w) * (r0.w);
    r0.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r2.w = (r2.w) * (r2.w);
    r7.xyz = normalize(r0.xyz);
    r6.w = (r0.w) * (r2.w);
    r2.w = max(abs(r7.y), abs(r7.z));
    r8.w = saturate(dot(r7.xyz, r1.xyz));
    r0.w = max(abs(r7.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r8.xyz = (r1.www) * (v7.xyz);
    r5.w = saturate(dot(r7.xyz, -(r8.xyz)));
    r0.xyz = (r7.xyz) * (c[5].xyz);
    r7.w = saturate(dot(r7.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v8.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[7].yyy);
    r11.xy = c[6].xy;
    r0.xyz = (r11.xxx) * (c[18].xyz);
    r9.xyz = (r1.xyz) * (c1.yyy);
    r5.xyz = (r7.www) * (r0.xyz);
    if ((c1.z) >= (v6.w))
    {
        r1 = (v6.xyzx) * (c12.xxxy);
        r0 = (r1) + (-(c13.xyzz));
        r0 = tex2Dlod(s2, r0);
        r0.w = r0.x;
        r2 = (r1) + (c12.zzyy);
        r2 = tex2Dlod(s2, r2);
        r0.x = r2.x;
        r2 = (r1) + (c12.wwyy);
        r2 = tex2Dlod(s2, r2);
        r0.y = r2.x;
        r1 = (r1) + (c13.xyzz);
        r1 = tex2Dlod(s2, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c3.zzzz);
        if ((c3.w) < (v6.w))
        {
            r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c12.zz);
            r0.zw = (v6.zx) * (c12.xy);
            r0 = tex2Dlod(s2, r0);
            r1.xy = (r4.xy) + (c12.ww);
            r1.zw = (v6.zx) * (c12.xy);
            r3 = tex2Dlod(s2, r1);
            r1.xy = (r4.xy) + (c13.xy);
            r1.zw = (v6.zx) * (c12.xy);
            r2 = tex2Dlod(s2, r1);
            r1.xy = (r4.xy) + (-(c13.xy));
            r1.zw = (v6.zx) * (c12.xy);
            r1 = tex2Dlod(s2, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.zzzz);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v6.w) * (c14.x) + (c14.y);
            r0.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r0.w = r4.w;
        }
    }
    else
    {
        r0.z = (v6.w) + (c13.w);
        r0.z = ((r0.z) >= 0.0f ? (c12.y) : (c12.x));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c12.zz);
            r1.zw = (v6.zz) * (c12.xy);
            r1 = tex2Dlod(s2, r1);
            r2.xy = (r0.xy) + (c12.ww);
            r2.zw = (v6.zz) * (c12.xy);
            r4 = tex2Dlod(s2, r2);
            r2.xy = (r0.xy) + (c13.xy);
            r2.zw = (v6.zz) * (c12.xy);
            r3 = tex2Dlod(s2, r2);
            r2.xy = (r0.xy) + (-(c13.xy));
            r2.zw = (v6.zz) * (c12.xy);
            r2 = tex2Dlod(s2, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c3.zzzz);
            r0.z = saturate((v6.w) + (c14.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
    }
    r1 = tex2D(s3, v1.xy);
    r3.xyz = (r1.xyz) * (-(r1.xyz)) + (c1.zzz);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r0.z = (r1.w) * (-(c1.w)) + (c1.z);
    r0.x = (r1.w) * (c1.w);
    r0.y = (r5.w) * (r0.z) + (r0.x);
    r0.z = (r7.w) * (r0.z) + (r0.x);
    r0.z = (r0.z) * (r0.y) + (c3.x);
    r10.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r0.x = 1.0f / (r0.z);
    r1.z = exp2(r10.y);
    r0.y = pow(abs(r8.w), r1.z);
    r0.z = (r1.z) * (c3.y) + (c3.z);
    r1.y = (r7.w) * (r0.x);
    r1.z = (r0.y) * (r0.z);
    r0.xyz = (r3.xyz) * (r6.www) + (r6.xyz);
    r1.z = (r1.y) * (r1.z);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r0.xyz = (r0.xyz) * (c[7].www);
    r1.xyz = (r11.yyy) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r4.xyz = (r0.www) * (r5.xyz) + (r9.xyz);
    r5.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r0.yzw) * (r0.yzw);
    r0.z = 1.0f / (r10.x);
    r0.w = (-(r5.w)) + (c1.z);
    r1.z = dot(r8.xyz, r7.xyz);
    r0.y = (r0.w) * (r0.w);
    r1.z = (r1.z) + (r1.z);
    r1.w = (r1.w) * (c1.x);
    r1.xyz = (r7.xyz) * (-(r1.zzz)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.w) * (r0.y);
    r7.xyz = (r1.xyz) * (c1.xxx);
    r1 = tex3D(s11, v8.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = (r0.z) * (r0.w);
    r1.xyz = (r7.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c1.yyy);
    r3.xyz = (r3.xyz) * (r0.www) + (r6.xyz);
    r2.xyz = (r2.xyz) * (r4.xyz) + (r5.xyz);
    r1.xyz = (r1.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c[7].xxx) + (r2.xyz);
    r1.xyz = (r0.xxx) * (r1.xyz);
    r1.w = c1.z;
    r2.z = dot(r1, c[11]);
    r2.x = dot(r1, c[9]);
    r2.y = dot(r1, c[10]);
    r1.xyz = (v3.xyz) * (-(r0.xxx)) + (r2.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r1.xyz = (v3.xyz) * (r0.xxx) + (r1.xyz);
    r1.xyz = max(((r1.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r1.x = rsqrt(r1.x);
    r1.y = rsqrt(r1.y);
    r1.z = rsqrt(r1.z);
    r0.w = rsqrt(r0.x);
    oC0.x = 1.0f / (r1.x);
    oC0.y = 1.0f / (r1.y);
    oC0.z = 1.0f / (r1.z);
    oC0.w = 1.0f / (r0.w);

    return oC0;
}
