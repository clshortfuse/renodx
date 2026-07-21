// Mechanically reconstructed from 0x328EE322.ps_3_0.cso.
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
sampler2D s6 : register(s6);
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
    const float4 c0 = float4(-0.5f, 8.0f, 31.875f, 1.0f);
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.xy) * (c[8].xy);
    r0 = tex2D(s4, r0.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s1, v1.xy);
    r0.z = dot(v7.xyz, v7.xyz);
    r2.w = rsqrt(r0.z);
    r2.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r2.xy = (c[8].zz) * (r1.xy) + (r2.xy);
    r1.xyz = normalize(r0.xyz);
    r1.w = saturate(dot(r1.xyz, c[17].xyz));
    r0 = v2;
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r2.yyy) * (v4.xyz) + (r0.xyz);
    r1.w = (-(r1.w)) + (c0.w);
    r12.xyz = normalize(r0.xyz);
    r0.z = (r1.w) * (r1.w);
    r3.z = saturate(dot(r12.xyz, r1.xyz));
    r0.z = (r0.z) * (r0.z);
    r3.w = (r1.w) * (r0.z);
    r0.xy = (v1.xy) * (c[9].xy);
    r1 = tex2D(s5, r0.xy);
    r0.xyz = (r1.xyz) + (c0.xxx);
    r1 = tex2D(s0, v1.xy);
    r13.xyz = (r2.www) * (v7.xyz);
    r1.xyz = saturate((r0.xyz) * (r1.www) + (r1.xyz));
    r8.w = saturate(dot(r12.xyz, -(r13.xyz)));
    r2 = tex2D(s3, v1.xy);
    r10.xyz = (r2.xyz) * (-(r2.xyz)) + (c0.www);
    r0.z = (r2.w) * (-(c3.x)) + (c3.y);
    r0.x = (r2.w) * (c3.x);
    r11.xyz = (r2.xyz) * (r2.xyz);
    r0.y = (r8.w) * (r0.z) + (r0.x);
    r15.xy = (r2.ww) * (c4.xy) + (c4.zw);
    r4.w = saturate(dot(r12.xyz, c[17].xyz));
    r1.w = exp2(r15.y);
    r0.z = (r4.w) * (r0.z) + (r0.x);
    r0.x = pow(abs(r3.z), r1.w);
    r0.z = (r0.z) * (r0.y) + (c3.z);
    r0.y = (r1.w) * (c12.x) + (c12.y);
    r0.z = 1.0f / (r0.z);
    r1.w = (r0.x) * (r0.y);
    r2.z = (r4.w) * (r0.z);
    r0.xyz = (r10.xyz) * (r3.www) + (r11.xyz);
    r1.w = (r1.w) * (r2.z);
    r1.xyz = (r1.xyz) * (v0.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[7].www);
    r1 = tex2D(s6, v1.xy);
    r3.w = max(abs(r12.y), abs(r12.z));
    r2.xyz = (r0.xyz) * (r1.www);
    r0.z = max(abs(r12.x), r3.w);
    r3.w = 1.0f / (r0.z);
    r0.xyz = (r12.xyz) * (c[5].xyz);
    r5.xy = c[6].xy;
    r4.xyz = (r5.yyy) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r3.www) + (v8.xyz);
    r3 = tex3D(s11, r0.xyz);
    r0.xyz = (r3.xyz) * (r3.xyz);
    r9.xyz = (r2.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (c[7].yyy);
    r2.xyz = (r5.xxx) * (c[18].xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r2.xyz = (r4.www) * (r2.xyz);
    r14.xyz = (r0.xyz) * (c0.zzz);
    if ((c0.w) >= (v6.w))
    {
        r4 = (v6.xyzx) * (c3.yyyw);
        r3 = (r4) + (-(c13.xyzz));
        r3 = tex2Dlod(s2, r3);
        r3.w = r3.x;
        r5 = (r4) + (c12.zzww);
        r5 = tex2Dlod(s2, r5);
        r3.x = r5.x;
        r5 = (r4) + (-(c12.zzww));
        r5 = tex2Dlod(s2, r5);
        r3.y = r5.x;
        r4 = (r4) + (c13.xyzz);
        r4 = tex2Dlod(s2, r4);
        r3.z = r4.x;
        r1.w = dot(r3, c12.yyyy);
        if ((c13.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c12.zz);
            r3.zw = (v6.zx) * (c3.yw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c12.zz));
            r4.zw = (v6.zx) * (c3.yw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c13.xy);
            r4.zw = (v6.zx) * (c3.yw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c13.xy));
            r4.zw = (v6.zx) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.z = dot(r3, c12.yyyy);
            r0.y = (-(r1.w)) + (r0.z);
            r0.z = (v6.w) * (c14.x) + (c14.y);
            r1.w = (r0.z) * (r0.y) + (r1.w);
        }
    }
    else
    {
        r0.z = (v6.w) + (c14.z);
        r0.z = ((r0.z) >= 0.0f ? (c3.w) : (c3.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r4.xy = (r0.xy) + (c12.zz);
            r4.zw = (v6.zz) * (c3.yw);
            r4 = tex2Dlod(s2, r4);
            r5.xy = (r0.xy) + (-(c12.zz));
            r5.zw = (v6.zz) * (c3.yw);
            r7 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (c13.xy);
            r5.zw = (v6.zz) * (c3.yw);
            r6 = tex2Dlod(s2, r5);
            r5.xy = (r0.xy) + (-(c13.xy));
            r5.zw = (v6.zz) * (c3.yw);
            r5 = tex2Dlod(s2, r5);
            r4.y = r7.x;
            r4.z = r6.x;
            r4.w = r5.x;
            r0.x = dot(r4, c12.yyyy);
            r0.z = saturate((v6.w) + (c14.y));
            r0.y = (r3.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r3.w;
        }
        r1.w = r0.z;
    }
    r3.xyz = (r1.www) * (r2.xyz) + (r14.xyz);
    r4.w = 1.0f / (r15.x);
    r3.w = (-(r8.w)) + (c0.w);
    r0.z = dot(r13.xyz, r12.xyz);
    r4.z = (r3.w) * (r3.w);
    r0.z = (r0.z) + (r0.z);
    r2.w = (r2.w) * (c0.y);
    r2.xyz = (r12.xyz) * (-(r0.zzz)) + (r13.xyz);
    r2 = texCUBElod(s15, r2);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r3.w = (r3.w) * (r4.z);
    r4.xyz = (r0.xyz) * (c0.yyy);
    r2 = tex3D(s11, v8.xyz);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (r4.w) * (r3.w);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c0.zzz);
    r4.xyz = (r10.xyz) * (r2.www) + (r11.xyz);
    r2.xyz = (r9.xyz) * (r1.www);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r2.xyz = (r8.xyz) * (r3.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (c[7].xxx);
    r1.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
    r1.w = c0.w;
    r0.z = dot(r1, c[21]);
    r0.x = dot(r1, c[11]);
    r0.y = dot(r1, c[20]);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.w;

    return oC0;
}
