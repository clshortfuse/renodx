// Mechanically reconstructed from 0xE4474AB3.ps_3_0.cso.
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
    const float4 c1 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c3 = float4(31.875f, 0.797884583f, 1.0f, 0.0009765625f);
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
    float4 r12 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = (-(r0.w)) + (c1.y);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.z) * (r0.z);
    r5.w = (r0.w) * (r0.z);
    r0 = tex2D(s0, v1.xy);
    r4.w = (r0.w) * (v0.w) + (c1.x);
    r0 = (r0.xyzx) * (c1.yyyz) + (c1.zzzy);
    r1 = tex2D(s1, v1.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r0 = float4(((r4.w) >= 0.0f ? (r0.x) : (c1.z)), ((r4.w) >= 0.0f ? (r0.y) : (c1.z)), ((r4.w) >= 0.0f ? (r0.z) : (c1.z)), ((r4.w) >= 0.0f ? (r0.w) : (c1.z)));
    r4.xy = float2(((r4.w) >= 0.0f ? (r1.x) : (c1.z)), ((r4.w) >= 0.0f ? (r1.y) : (c1.z)));
    r2.xyz = (r0.xyz) * (v0.xyz);
    r1 = v2;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r10.xyz = normalize(r0.xyz);
    r5.xyz = (r2.www) * (v7.xyz);
    r2 = tex2D(s3, v1.xy);
    r2 = float4(((r4.w) >= 0.0f ? (r2.x) : (c1.z)), ((r4.w) >= 0.0f ? (r2.y) : (c1.z)), ((r4.w) >= 0.0f ? (r2.z) : (c1.z)), ((r4.w) >= 0.0f ? (r2.w) : (c1.y)));
    r0.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.yyy);
    r4.xyz = (r2.xyz) * (r2.xyz);
    r3.w = saturate(dot(r10.xyz, -(r5.xyz)));
    r2.xyz = (r0.xyz) * (r5.www) + (r4.xyz);
    r7.z = (r2.w) * (-(c3.y)) + (c3.z);
    r7.y = (r2.w) * (c3.y);
    r6.z = (r3.w) * (r7.z) + (r7.y);
    r3.w = (-(r3.w)) + (c1.y);
    r5.w = (r3.w) * (r3.w);
    r6.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r3.w = (r3.w) * (r5.w);
    r5.w = 1.0f / (r6.x);
    r2.w = (r2.w) * (c1.w);
    r5.w = (r3.w) * (r5.w);
    r7.w = exp2(r6.y);
    r3.w = dot(r10.xyz, c[17].xyz);
    r3.z = saturate(dot(r10.xyz, r3.xyz));
    r3.y = saturate(r3.w);
    r6.w = pow(abs(r3.z), r7.w);
    r3.x = (r3.y) * (r7.z) + (r7.y);
    r3.z = (r7.w) * (c12.x) + (c12.y);
    r3.x = (r3.x) * (r6.z) + (c3.w);
    r3.z = (r6.w) * (r3.z);
    r3.x = 1.0f / (r3.x);
    r3.x = (r3.y) * (r3.x);
    r3.y = dot(r5.xyz, r10.xyz);
    r3.z = (r3.z) * (r3.x);
    r6.w = (r3.y) + (r3.y);
    r3.xyz = (r2.xyz) * (r3.zzz);
    r2.xyz = (r10.xyz) * (-(r6.www)) + (r5.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r5.xyz = (r2.xyz) * (c1.www);
    r4.xyz = (r0.xyz) * (r5.www) + (r4.xyz);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r5.w = max(abs(r10.y), abs(r10.z));
    r0.xyz = (r0.xyz) * (c3.xxx);
    r2.w = max(abs(r10.x), r5.w);
    r7.xyz = (r4.xyz) * (r0.xyz);
    r2.w = 1.0f / (r2.w);
    r12.yz = c1.yz;
    r0.xyz = float3(((r4.w) >= 0.0f ? (c[21].x) : (r12.z)), ((r4.w) >= 0.0f ? (c[21].y) : (r12.z)), ((r4.w) >= 0.0f ? (c[21].w) : (r12.z)));
    r2.xyz = (r10.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r0.zzz);
    r2.xyz = (r2.xyz) * (r2.www) + (v8.xyz);
    r2 = tex3D(s11, r2.xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r9.xyz = (r3.xyz) * (c[19].xyz);
    r2.xyz = (r0.yyy) * (r2.xyz);
    r11.xyz = (r2.xyz) * (c3.xxx);
    r8.xyz = (abs(r3.www)) * (c[18].xyz);
    if ((c1.y) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c1.yyyz);
        r2 = (r3) + (-(c13.xyzz));
        r2 = tex2Dlod(s2, r2);
        r2.w = r2.x;
        r4 = (r3) + (c12.zzww);
        r4 = tex2Dlod(s2, r4);
        r2.x = r4.x;
        r4 = (r3) + (-(c12.zzww));
        r4 = tex2Dlod(s2, r4);
        r2.y = r4.x;
        r3 = (r3) + (c13.xyzz);
        r3 = tex2Dlod(s2, r3);
        r2.z = r3.x;
        r0.z = dot(r2, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r6.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r6.xy) + (c12.zz);
            r2.zw = (v6.zx) * (c1.yz);
            r2 = tex2Dlod(s2, r2);
            r3.xy = (r6.xy) + (-(c12.zz));
            r3.zw = (v6.zx) * (c1.yz);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r6.xy) + (c13.xy);
            r3.zw = (v6.zx) * (c1.yz);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r6.xy) + (-(c13.xy));
            r3.zw = (v6.zx) * (c1.yz);
            r3 = tex2Dlod(s2, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r0.y = dot(r2, c12.yyyy);
            r2.w = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c14.x) + (c14.y);
            r0.z = (r0.y) * (r2.w) + (r0.z);
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c1.z) : (c1.y));
        if ((r0.z) != (-(r0.z)))
        {
            r2.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r2.xy) + (c12.zz);
            r3.zw = (v6.zz) * (c1.yz);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r2.xy) + (-(c12.zz));
            r4.zw = (v6.zz) * (c1.yz);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r2.xy) + (c13.xy);
            r4.zw = (v6.zz) * (c1.yz);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r2.xy) + (-(c13.xy));
            r4.zw = (v6.zz) * (c1.yz);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r2.z = dot(r3, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r2.w) + (-(r2.z));
            r0.z = (r0.z) * (r0.y) + (r2.z);
        }
        else
        {
            r0.z = r2.w;
        }
    }
    r5 = (-(v7.yyyy)) + (c[7]);
    r4 = (-(v7.xxxx)) + (c[6]);
    r2 = (r5) * (r5);
    r2 = (r4) * (r4) + (r2);
    r3 = (-(v7.zzzz)) + (c[8]);
    r2 = (r3) * (r3) + (r2);
    r8.xyz = (r0.zzz) * (r8.xyz) + (r11.xyz);
    r6.x = rsqrt(r2.x);
    r6.y = rsqrt(r2.y);
    r6.z = rsqrt(r2.z);
    r6.w = rsqrt(r2.w);
    r9.xyz = (r9.xyz) * (r0.zzz);
    r5 = (r5) * (r6);
    r5 = (r10.yyyy) * (r5);
    r4 = (r4) * (r6);
    r3 = (r3) * (r6);
    r4 = (r4) * (r10.xxxx) + (r5);
    r3 = saturate((r3) * (r10.zzzz) + (r4));
    r2 = saturate((r2) * (c[9]) + (r12.yyyy));
    r4.xyz = (r1.xyz) * (r8.xyz) + (r9.xyz);
    r2 = (r3) * (r2);
    r3.xyz = (r7.xyz) * (r0.xxx) + (r4.xyz);
    r0.z = dot(c[20], r2);
    r0.x = dot(c[10], r2);
    r0.y = dot(c[11], r2);
    r0.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
