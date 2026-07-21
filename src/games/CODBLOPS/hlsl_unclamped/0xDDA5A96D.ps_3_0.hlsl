// Mechanically reconstructed from 0xDDA5A96D.ps_3_0.cso.
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
    const float4 c3 = float4(0.959999979f, 0.0399999991f, 0.0009765625f, 0.25f);
    const float4 c4 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c7 = float4(0.125f, 0.25f, 1.0f, 0.0f);
    const float4 c8 = float4(0.00048828125f, -0.000122070312f, 0.0f, -4.0f);
    const float4 c9 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c10 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.w = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r1.xyz = normalize(r0.xyz);
    r1.w = saturate(dot(r1.xyz, c[17].xyz));
    r0 = tex2D(s1, v1.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.w = (-(r1.w)) + (c1.z);
    r0.xyz = v2.xyz;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r6.xyz = normalize(r0.xyz);
    r2.z = (r0.w) * (r1.w);
    r2.y = saturate(dot(r6.xyz, r1.xyz));
    r1 = tex2D(s3, v1.xy);
    r7.xyz = (r2.www) * (v7.xyz);
    r0.z = (r1.w) * (-(c1.w)) + (c1.z);
    r0.w = saturate(dot(r6.xyz, -(r7.xyz)));
    r0.x = (r1.w) * (c1.w);
    r2.w = saturate(dot(r6.xyz, c[17].xyz));
    r0.y = (r0.w) * (r0.z) + (r0.x);
    r0.z = (r2.w) * (r0.z) + (r0.x);
    r0.z = (r0.z) * (r0.y) + (c3.z);
    r0.xy = (r1.ww) * (c4.xy) + (c4.zw);
    r1.z = 1.0f / (r0.z);
    r1.x = exp2(r0.y);
    r0.y = pow(abs(r2.y), r1.x);
    r0.z = (r1.x) * (c7.x) + (c7.y);
    r1.z = (r2.w) * (r1.z);
    r0.z = (r0.y) * (r0.z);
    r0.y = (r2.z) * (c3.x) + (c3.y);
    r0.z = (r1.z) * (r0.z);
    r1.x = (r0.y) * (r0.z);
    r2.z = 1.0f / (r0.x);
    r0.w = (-(r0.w)) + (c1.z);
    r0.z = (r0.w) * (r0.w);
    r2.y = max(abs(r6.y), abs(r6.z));
    r1.z = (r0.w) * (r0.z);
    r0.w = max(abs(r6.x), r2.y);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r1.z = (r2.z) * (r1.z);
    r0.xyz = (r0.xyz) * (r0.www) + (v8.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.z = (r1.z) * (c3.x) + (c3.y);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r9.xyz = (r0.xyz) * (c1.yyy);
    r8.xyz = (r2.www) * (c[18].xyz);
    if ((c1.z) >= (v6.w))
    {
        r2 = (v6.xyzx) * (c7.zzzw);
        r0 = (r2) + (-(c8.xyzz));
        r0 = tex2Dlod(s2, r0);
        r0.w = r0.x;
        r3 = (r2) + (c9.xxyy);
        r3 = tex2Dlod(s2, r3);
        r0.x = r3.x;
        r3 = (r2) + (c9.zzyy);
        r3 = tex2Dlod(s2, r3);
        r0.y = r3.x;
        r2 = (r2) + (c8.xyzz);
        r2 = tex2Dlod(s2, r2);
        r0.z = r2.x;
        r5.w = dot(r0, c3.wwww);
        if ((c9.w) < (v6.w))
        {
            r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r5.xy) + (c9.xx);
            r0.zw = (v6.zx) * (c7.zw);
            r0 = tex2Dlod(s2, r0);
            r2.xy = (r5.xy) + (c9.zz);
            r2.zw = (v6.zx) * (c7.zw);
            r4 = tex2Dlod(s2, r2);
            r2.xy = (r5.xy) + (c8.xy);
            r2.zw = (v6.zx) * (c7.zw);
            r3 = tex2Dlod(s2, r2);
            r2.xy = (r5.xy) + (-(c8.xy));
            r2.zw = (v6.zx) * (c7.zw);
            r2 = tex2Dlod(s2, r2);
            r0.y = r4.x;
            r0.z = r3.x;
            r0.w = r2.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r5.w)) + (r0.w);
            r0.w = (v6.w) * (c10.x) + (c10.y);
            r0.w = (r0.w) * (r0.z) + (r5.w);
        }
        else
        {
            r0.w = r5.w;
        }
    }
    else
    {
        r0.z = (v6.w) + (c8.w);
        r0.z = ((r0.z) >= 0.0f ? (c7.w) : (c7.z));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r0.xy) + (c9.xx);
            r2.zw = (v6.zz) * (c7.zw);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r0.xy) + (c9.zz);
            r3.zw = (v6.zz) * (c7.zw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c8.xy);
            r3.zw = (v6.zz) * (c7.zw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c8.xy));
            r3.zw = (v6.zz) * (c7.zw);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c3.wwww);
            r0.z = saturate((v6.w) + (c10.y));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
    }
    r0.z = (r1.y) * (r1.x);
    r0.xyz = (r0.zzz) * (c[19].xyz);
    r4.xyz = (r0.www) * (r8.xyz) + (r9.xyz);
    r5.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r1.x = dot(r7.xyz, r6.xyz);
    r1.x = (r1.x) + (r1.x);
    r2.w = (r1.w) * (c1.x);
    r2.xyz = (r6.xyz) * (-(r1.xxx)) + (r7.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r2.xyz) * (c1.xxx);
    r2 = tex3D(s11, v8.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0 = (r0.wxyz) * (v0.wxyz);
    r2.xyz = (r3.xyz) * (r2.xyz);
    r3.xyz = (r0.yzw) * (r0.yzw);
    r2.xyz = (r2.xyz) * (c1.yyy);
    r3.xyz = (r3.xyz) * (r4.xyz) + (r5.xyz);
    r2.xyz = (r1.zzz) * (r2.xyz);
    r1.xyz = (r2.xyz) * (r1.yyy) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
