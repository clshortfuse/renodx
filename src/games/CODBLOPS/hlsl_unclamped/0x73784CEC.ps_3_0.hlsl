// Mechanically reconstructed from 0x73784CEC.ps_3_0.cso.
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
sampler2D s4 : register(s4);
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 0.200000003f);
    const float4 c3 = float4(8.0f, 31.875f, 0.797884583f, 1.0f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c8 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c10 = float4(0.000244140625f, 0.0f, -0.000244140625f, -4.0f);
    const float4 c11 = float4(4.0f, -3.0f, 0.0f, 0.0f);
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

    r0.xy = (v1.xy) * (c[6].xy);
    r0 = tex2D(s4, r0.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s1, v1.xy);
    r0.z = dot(v7.xyz, v7.xyz);
    r4.w = rsqrt(r0.z);
    r1.xyz = (v7.xyz) * (-(r4.www)) + (c[17].xyz);
    r4.xyz = normalize(r1.xyz);
    r0.z = saturate(dot(r4.xyz, c[17].xyz));
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r5.w = (-(r0.z)) + (c1.y);
    r1.xy = (c[6].zz) * (r2.xy) + (r0.xy);
    r2.w = (r5.w) * (r5.w);
    r3 = tex2D(s3, v1.xy);
    r1.zw = (r3.ww) * (c1.zy) + (c1.wz);
    r0 = tex2D(s0, v1.xy);
    r3.x = (r0.w) * (v0.w) + (c1.x);
    r0.w = (r2.w) * (r2.w);
    r2 = float4(((r3.x) >= 0.0f ? (r1.x) : (c1.z)), ((r3.x) >= 0.0f ? (r1.y) : (c1.z)), ((r3.x) >= 0.0f ? (r1.z) : (c1.z)), ((r3.x) >= 0.0f ? (r1.w) : (c1.y)));
    r0.w = (r5.w) * (r0.w);
    r1 = v2;
    r1.xyz = (r2.xxx) * (v5.xyz) + (r1.xyz);
    r9.w = (r2.z) * (-(r2.z)) + (c1.y);
    r1.xyz = (r2.yyy) * (v4.xyz) + (r1.xyz);
    r10.w = (r2.z) * (r2.z);
    r2.xyz = normalize(r1.xyz);
    r5.w = (r9.w) * (r0.w) + (r10.w);
    r3.z = saturate(dot(r2.xyz, r4.xyz));
    r8.w = ((r3.x) >= 0.0f ? (r3.y) : (c1.z));
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r3.w = (r2.w) * (-(c3.z)) + (c3.w);
    r0 = float4(((r3.x) >= 0.0f ? (r0.x) : (c1.z)), ((r3.x) >= 0.0f ? (r0.y) : (c1.z)), ((r3.x) >= 0.0f ? (r0.z) : (c1.z)), ((r3.x) >= 0.0f ? (r0.w) : (c1.z)));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r8.xyz = (r4.www) * (v7.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r11.w = saturate(dot(r2.xyz, -(r8.xyz)));
    r0.z = (r2.w) * (c3.z);
    r4.w = saturate(dot(r2.xyz, c[17].xyz));
    r0.y = (r11.w) * (r3.w) + (r0.z);
    r0.z = (r4.w) * (r3.w) + (r0.z);
    r0.z = (r0.z) * (r0.y) + (c4.x);
    r11.xy = (r2.ww) * (c8.xy) + (c8.zw);
    r0.z = 1.0f / (r0.z);
    r3.w = exp2(r11.y);
    r3.y = (r4.w) * (r0.z);
    r0.y = pow(abs(r3.z), r3.w);
    r0.z = (r3.w) * (c4.y) + (c4.z);
    r3.w = max(abs(r2.y), abs(r2.z));
    r3.z = (r0.y) * (r0.z);
    r0.z = max(abs(r2.x), r3.w);
    r3.w = 1.0f / (r0.z);
    r0.xyz = (r2.xyz) * (c[5].xyz);
    r4.z = (r3.y) * (r3.z);
    r0.xyz = (r0.xyz) * (r3.www) + (v8.xyz);
    r3 = tex3D(s11, r0.xyz);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r11.z = (r5.w) * (r4.z);
    r0.xyz = (r8.www) * (r0.xyz);
    r10.xyz = (r0.xyz) * (c3.yyy);
    r9.xyz = (r4.www) * (c[18].xyz);
    if ((c1.y) >= (v6.w))
    {
        r4 = (v6.xyzx) * (c1.yyyz);
        r3 = (r4) + (-(c9.xyzz));
        r3 = tex2Dlod(s2, r3);
        r3.w = r3.x;
        r5 = (r4) + (c10.xxyy);
        r5 = tex2Dlod(s2, r5);
        r3.x = r5.x;
        r5 = (r4) + (c10.zzyy);
        r5 = tex2Dlod(s2, r5);
        r3.y = r5.x;
        r4 = (r4) + (c9.xyzz);
        r4 = tex2Dlod(s2, r4);
        r3.z = r4.x;
        r0.z = dot(r3, c4.zzzz);
        if ((c4.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c10.xx);
            r3.zw = (v6.zx) * (c1.yz);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (c10.zz);
            r4.zw = (v6.zx) * (c1.yz);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c9.xy);
            r4.zw = (v6.zx) * (c1.yz);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c9.xy));
            r4.zw = (v6.zx) * (c1.yz);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.y = dot(r3, c4.zzzz);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c11.x) + (c11.y);
            r3.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r3.w = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c10.w);
        r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.xy = (r0.xy) + (c10.xx);
            r4.zw = (v6.zz) * (c1.yz);
            r4 = tex2Dlod(s2, r4);
            r5.xy = (r0.xy) + (c10.zz);
            r5.zw = (v6.zz) * (c1.yz);
            r7 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (c9.xy);
            r5.zw = (v6.zz) * (c1.yz);
            r6 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (-(c9.xy));
            r5.zw = (v6.zz) * (c1.yz);
            r5 = tex2Dlod(s2, r5);
            r4.y = r7.x;
            r4.z = r6.x;
            r4.w = r5.x;
            r0.x = dot(r4, c4.zzzz);
            r0.z = saturate((v6.w) + (c9.w));
            r0.y = (r3.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r3.w;
        }
        r3.w = r0.z;
    }
    r0.z = (r8.w) * (r11.z);
    r3.xyz = (r3.www) * (r9.xyz) + (r10.xyz);
    r0.xyz = (r0.zzz) * (c[19].xyz);
    r4.xyz = (r3.www) * (r0.xyz);
    r4.w = 1.0f / (r11.x);
    r3.w = (-(r11.w)) + (c1.y);
    r0.z = dot(r8.xyz, r2.xyz);
    r5.w = (r3.w) * (r3.w);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c3.x);
    r2.xyz = (r2.xyz) * (-(r0.zzz)) + (r8.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r3.w = (r3.w) * (r5.w);
    r5.xyz = (r0.xyz) * (c3.xxx);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r4.w) * (r3.w);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r2.w = (r9.w) * (r2.w) + (r10.w);
    r0.xyz = (r0.xyz) * (c3.yyy);
    r1.xyz = (r1.xyz) * (r3.xyz) + (r4.xyz);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (r8.www) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
