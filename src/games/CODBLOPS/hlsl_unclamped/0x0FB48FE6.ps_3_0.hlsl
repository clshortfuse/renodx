// Mechanically reconstructed from 0x0FB48FE6.ps_3_0.cso.
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
sampler2D s5 : register(s5);
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
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
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
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 r15 = 0.0f;
    float4 r16 = 0.0f;
    float4 r17 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r3.w = rsqrt(r0.w);
    r0.xyz = (v7.xyz) * (-(r3.www)) + (c[17].xyz);
    r4.xyz = normalize(r0.xyz);
    r0.w = saturate(dot(r4.xyz, c[17].xyz));
    r0.z = (-(r0.w)) + (c0.y);
    r0.y = (r0.z) * (r0.z);
    r0.w = c0.y;
    r0.y = (r0.y) * (r0.y);
    r3.z = (r0.z) * (r0.y);
    r0.xy = (v1.xy) * (c[23].xy);
    r1 = tex2D(s4, r0.xy);
    r0.xyz = (r1.xyz) + (c0.xxx);
    r1 = tex2D(s0, v1.xy);
    r5.w = (r1.w) * (v0.w) + (c0.x);
    r2 = tex2D(s1, v1.xy);
    r2.xy = (r2.wy) * (c1.xy) + (c1.zw);
    r0.xyz = saturate((r0.xyz) * (r1.www) + (r1.xyz));
    r3.xy = float2(((r5.w) >= 0.0f ? (r2.x) : (c0.z)), ((r5.w) >= 0.0f ? (r2.y) : (c0.z)));
    r0 = float4(((r5.w) >= 0.0f ? (r0.x) : (c0.z)), ((r5.w) >= 0.0f ? (r0.y) : (c0.z)), ((r5.w) >= 0.0f ? (r0.z) : (c0.z)), ((r5.w) >= 0.0f ? (r0.w) : (c0.z)));
    r1 = v2;
    r2.xyz = (r3.xxx) * (v5.xyz) + (r1.xyz);
    r1.xyz = (r0.xyz) * (v0.xyz);
    r0.xyz = (r3.yyy) * (v4.xyz) + (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r10.xyz = normalize(r0.xyz);
    r2 = tex2D(s3, v1.xy);
    r2 = float4(((r5.w) >= 0.0f ? (r2.x) : (c0.z)), ((r5.w) >= 0.0f ? (r2.y) : (c0.z)), ((r5.w) >= 0.0f ? (r2.z) : (c0.z)), ((r5.w) >= 0.0f ? (r2.w) : (c0.y)));
    r11.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.yyy);
    r12.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r11.xyz) * (r3.zzz) + (r12.xyz);
    r2.xyz = (r3.www) * (v7.xyz);
    r0.z = (r2.w) * (-(c3.y)) + (c3.z);
    r9.w = saturate(dot(r10.xyz, -(r2.xyz)));
    r0.y = (r2.w) * (c3.y);
    r16.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r4.w = (r9.w) * (r0.z) + (r0.y);
    r5.z = exp2(r16.y);
    r4.z = saturate(dot(r10.xyz, r4.xyz));
    r3.w = saturate(dot(r10.xyz, c[17].xyz));
    r0.x = pow(abs(r4.z), r5.z);
    r0.y = (r3.w) * (r0.z) + (r0.y);
    r0.z = (r5.z) * (c12.x) + (c12.y);
    r0.y = (r0.y) * (r4.w) + (c3.w);
    r0.z = (r0.x) * (r0.z);
    r0.y = 1.0f / (r0.y);
    r0.y = (r3.w) * (r0.y);
    r4.w = max(abs(r10.y), abs(r10.z));
    r4.z = (r0.z) * (r0.y);
    r0.z = max(abs(r10.x), r4.w);
    r4.w = 1.0f / (r0.z);
    r0.xyz = (r10.xyz) * (c[5].xyz);
    r3.xyz = (r3.xyz) * (r4.zzz);
    r0.xyz = (r0.xyz) * (r4.www) + (v8.xyz);
    r4 = tex3D(s11, r0.xyz);
    r0.xyz = (r4.xyz) * (r4.xyz);
    r16.yz = c0.yz;
    r9.xyz = float3(((r5.w) >= 0.0f ? (c[22].x) : (r16.z)), ((r5.w) >= 0.0f ? (c[22].y) : (r16.z)), ((r5.w) >= 0.0f ? (c[22].w) : (r16.z)));
    r4.xyz = (r3.xyz) * (r9.zzz);
    r17.xy = c[21].xy;
    r3.xyz = (r17.xxx) * (c[18].xyz);
    r0.xyz = (r0.xyz) * (r9.yyy);
    r13.xyz = (r3.www) * (r3.xyz);
    r3 = tex2D(s5, v1.xy);
    r0.xyz = (r0.xyz) * (r3.www);
    r15.xyz = (r4.xyz) * (r3.www);
    r14.xyz = (r0.xyz) * (c3.xxx);
    if ((c0.y) >= (v6.w))
    {
        r5 = (v6.xyzx) * (c0.yyyz);
        r4 = (r5) + (-(c13.xyzz));
        r4 = tex2Dlod(s2, r4);
        r4.w = r4.x;
        r6 = (r5) + (c12.zzww);
        r6 = tex2Dlod(s2, r6);
        r4.x = r6.x;
        r6 = (r5) + (-(c12.zzww));
        r6 = tex2Dlod(s2, r6);
        r4.y = r6.x;
        r5 = (r5) + (c13.xyzz);
        r5 = tex2Dlod(s2, r5);
        r4.z = r5.x;
        r3.w = dot(r4, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.xy = (r0.xy) + (c12.zz);
            r4.zw = (v6.zx) * (c0.yz);
            r4 = tex2Dlod(s2, r4);
            r5.xy = (r0.xy) + (-(c12.zz));
            r5.zw = (v6.zx) * (c0.yz);
            r7 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (c13.xy);
            r5.zw = (v6.zx) * (c0.yz);
            r6 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (-(c13.xy));
            r5.zw = (v6.zx) * (c0.yz);
            r5 = tex2Dlod(s2, r5);
            r4.y = r7.x;
            r4.z = r6.x;
            r4.w = r5.x;
            r0.z = dot(r4, c12.yyyy);
            r0.y = (-(r3.w)) + (r0.z);
            r0.z = (v6.w) * (c14.x) + (c14.y);
            r3.w = (r0.z) * (r0.y) + (r3.w);
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r5.xy = (r0.xy) + (c12.zz);
            r5.zw = (v6.zz) * (c0.yz);
            r5 = tex2Dlod(s2, r5);
            r6.xy = (r0.xy) + (-(c12.zz));
            r6.zw = (v6.zz) * (c0.yz);
            r8 = tex2Dlod(s2, r6);
            r6.xy = (r0.xy) + (c13.xy);
            r6.zw = (v6.zz) * (c0.yz);
            r7 = tex2Dlod(s2, r6);
            r6.xy = (r0.xy) + (-(c13.xy));
            r6.zw = (v6.zz) * (c0.yz);
            r6 = tex2Dlod(s2, r6);
            r5.y = r8.x;
            r5.z = r7.x;
            r5.w = r6.x;
            r0.x = dot(r5, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r4.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r4.w;
        }
        r3.w = r0.z;
    }
    r0.xyz = (r17.yyy) * (c[19].xyz);
    r4.xyz = (r15.xyz) * (r0.xyz);
    r0.xyz = (r3.www) * (r13.xyz) + (r14.xyz);
    r4.xyz = (r3.www) * (r4.xyz);
    r8.xyz = (r1.xyz) * (r0.xyz) + (r4.xyz);
    r4.w = 1.0f / (r16.x);
    r0.y = (-(r9.w)) + (c0.y);
    r0.x = (r0.y) * (r0.y);
    r0.z = dot(r2.xyz, r10.xyz);
    r3.w = (r0.y) * (r0.x);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c0.w);
    r2.xyz = (r10.xyz) * (-(r0.zzz)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r3.w = (r4.w) * (r3.w);
    r4.xyz = (r0.xyz) * (c0.www);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r6 = (-(v7.yyyy)) + (c[7]);
    r5 = (-(v7.xxxx)) + (c[6]);
    r2 = (r6) * (r6);
    r2 = (r5) * (r5) + (r2);
    r4 = (-(v7.zzzz)) + (c[8]);
    r0.xyz = (r0.xyz) * (c3.xxx);
    r2 = (r4) * (r4) + (r2);
    r11.xyz = (r11.xyz) * (r3.www) + (r12.xyz);
    r7.x = rsqrt(r2.x);
    r7.y = rsqrt(r2.y);
    r7.z = rsqrt(r2.z);
    r7.w = rsqrt(r2.w);
    r0.xyz = (r0.xyz) * (r11.xyz);
    r6 = (r6) * (r7);
    r6 = (r10.yyyy) * (r6);
    r5 = (r5) * (r7);
    r4 = (r4) * (r7);
    r5 = (r5) * (r10.xxxx) + (r6);
    r4 = saturate((r4) * (r10.zzzz) + (r5));
    r2 = saturate((r2) * (c[9]) + (r16.yyyy));
    r0.xyz = (r9.xxx) * (r0.xyz);
    r2 = (r4) * (r2);
    r3.xyz = (r0.xyz) * (r3.xyz) + (r8.xyz);
    r0.z = dot(c[20], r2);
    r0.x = dot(c[10], r2);
    r0.y = dot(c[11], r2);
    r2.xyz = (r1.xyz) * (r0.xyz) + (r3.xyz);
    r2.w = c0.y;
    r0.z = dot(r2, c[27]);
    r0.x = dot(r2, c[25]);
    r0.y = dot(r2, c[26]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r1.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
