// Mechanically reconstructed from 0x9A3011EB.ps_3_0.cso.
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.200000003f, 8.0f, 31.875f, 1.0f);
    const float4 c3 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c12 = float4(4.0f, -3.0f, -4.0f, 2.0f);
    const float4 c13 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.0f);
    const float4 c14 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c15 = float4(0.5f, 0.0f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v7.xyz, v7.xyz);
    r0.xyz = (-(v7.xyz)) + (c[6].xyz);
    r4.w = rsqrt(r0.w);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = (r4.www) * (v7.xyz);
    r3.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r2.xyz = normalize(r3.xyz);
    r8.xyz = (r0.xyz) * (r0.www);
    r1.w = saturate(dot(r2.xyz, r8.xyz));
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r4.z = (-(r1.w)) + (c1.w);
    r0.xyz = v2.xyz;
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.w = (r4.z) * (r4.z);
    r0.xyz = (r3.yyy) * (v4.xyz) + (r0.xyz);
    r4.y = (r0.w) * (r0.w);
    r3.xyz = normalize(r0.xyz);
    r4.x = saturate(dot(r3.xyz, r2.xyz));
    r5.w = saturate(dot(r8.xyz, r3.xyz));
    r2 = tex2D(s5, v1.xy);
    r9.w = (r2.w) * (-(c13.x)) + (c13.y);
    r10.w = (r2.w) * (c13.x);
    r1.w = saturate(dot(r3.xyz, -(r1.xyz)));
    r0.w = (r5.w) * (r9.w) + (r10.w);
    r8.w = (r1.w) * (r9.w) + (r10.w);
    r0.w = (r0.w) * (r8.w) + (c13.z);
    r5.xy = (r2.ww) * (c14.xy) + (c14.zw);
    r0.z = 1.0f / (r0.w);
    r3.w = exp2(r5.y);
    r0.w = pow(abs(r4.x), r3.w);
    r7.w = (r3.w) * (c3.x) + (c3.y);
    r0.z = (r5.w) * (r0.z);
    r0.w = (r0.w) * (r7.w);
    r5.z = (r4.z) * (r4.y);
    r2.z = (r0.z) * (r0.w);
    r0 = tex2D(s0, v1.xy);
    r4.xyz = lerp(r0.xyz, c1.xxx, r2.xxx);
    r13.xyz = (r4.xyz) * (-(r4.xyz)) + (c1.www);
    r14.xyz = (r4.xyz) * (r4.xyz);
    r4.xyz = (r2.xxx) * (r0.xyz);
    r0.xyz = (r13.xyz) * (r5.zzz) + (r14.xyz);
    r4.xyz = (r4.xyz) * (v0.xyz);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r10.xyz = (r4.xyz) * (r4.xyz);
    r0.xyz = (r0.xyz) * (c[8].xyz);
    r4.xyz = (r2.yyy) * (r0.xyz);
    r0.xyz = (r5.www) * (c[7].xyz);
    r7.xyz = (r10.xyz) * (r0.xyz) + (r4.xyz);
    r2.x = 1.0f / (r5.x);
    r0.y = (-(r1.w)) + (c1.w);
    r0.x = (r0.y) * (r0.y);
    r0.z = dot(r1.xyz, r3.xyz);
    r2.z = (r0.y) * (r0.x);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r2.w) * (c1.y);
    r1.xyz = (r3.xyz) * (-(r0.zzz)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r2.w = (r2.x) * (r2.z);
    r4.xyz = (r0.xyz) * (c1.yyy);
    r1 = tex3D(s11, v8.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r4.xyz = (v7.xyz) * (-(r4.www)) + (c[17].xyz);
    r1.xyz = (r0.xyz) * (c1.zzz);
    r0.xyz = normalize(r4.xyz);
    r4.xyz = (r13.xyz) * (r2.www) + (r14.xyz);
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r9.xyz = (r1.xyz) * (r4.xyz);
    r1.z = (-(r1.w)) + (c1.w);
    r1.w = (r1.z) * (r1.z);
    r2.w = max(abs(r3.y), abs(r3.z));
    r1.y = (r1.w) * (r1.w);
    r1.w = max(abs(r3.x), r2.w);
    r2.w = (r1.z) * (r1.y);
    r1.w = 1.0f / (r1.w);
    r1.z = saturate(dot(r3.xyz, r0.xyz));
    r0.xyz = (r3.xyz) * (c[5].xyz);
    r2.x = pow(abs(r1.z), r3.w);
    r0.xyz = (r0.xyz) * (r1.www) + (v8.xyz);
    r1 = tex3D(s11, r0.xyz);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r2.z = saturate(dot(r3.xyz, c[17].xyz));
    r12.xyz = (r0.xyz) * (c1.zzz);
    r11.xyz = (r2.zzz) * (c[18].xyz);
    if ((c1.w) >= (v6.w))
    {
        r3 = (v6.xyzx) * (c13.yyyw);
        r1 = (r3) + (-(c4.xyzz));
        r1 = tex2Dlod(s2, r1);
        r1.w = r1.x;
        r4 = (r3) + (c3.zzww);
        r4 = tex2Dlod(s2, r4);
        r1.x = r4.x;
        r4 = (r3) + (-(c3.zzww));
        r4 = tex2Dlod(s2, r4);
        r1.y = r4.x;
        r3 = (r3) + (c4.xyzz);
        r3 = tex2Dlod(s2, r3);
        r1.z = r3.x;
        r0.z = dot(r1, c3.yyyy);
        if ((c4.w) < (v6.w))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c3.zz);
            r1.zw = (v6.zx) * (c13.yw);
            r1 = tex2Dlod(s2, r1);
            r3.xy = (r0.xy) + (-(c3.zz));
            r3.zw = (v6.zx) * (c13.yw);
            r5 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (c4.xy);
            r3.zw = (v6.zx) * (c13.yw);
            r4 = tex2Dlod(s2, r3);
            r3.xy = (r0.xy) + (-(c4.xy));
            r3.zw = (v6.zx) * (c13.yw);
            r3 = tex2Dlod(s2, r3);
            r1.y = r5.x;
            r1.z = r4.x;
            r1.w = r3.x;
            r0.y = dot(r1, c3.yyyy);
            r0.x = (-(r0.z)) + (r0.y);
            r0.y = (v6.w) * (c12.x) + (c12.y);
            r1.w = (r0.y) * (r0.x) + (r0.z);
        }
        else
        {
            r1.w = r0.z;
        }
    }
    else
    {
        r0.z = (v6.w) + (c12.z);
        r0.z = ((r0.z) >= 0.0f ? (c13.w) : (c13.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r0.xy) + (c3.zz);
            r3.zw = (v6.zz) * (c13.yw);
            r3 = tex2Dlod(s2, r3);
            r4.xy = (r0.xy) + (-(c3.zz));
            r4.zw = (v6.zz) * (c13.yw);
            r6 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (c4.xy);
            r4.zw = (v6.zz) * (c13.yw);
            r5 = tex2Dlod(s2, r4);
            r4.xy = (r0.xy) + (-(c4.xy));
            r4.zw = (v6.zz) * (c13.yw);
            r4 = tex2Dlod(s2, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r0.x = dot(r3, c3.yyyy);
            r0.z = saturate((v6.w) + (c12.y));
            r0.y = (r1.w) + (-(r0.x));
            r0.z = (r0.z) * (r0.y) + (r0.x);
        }
        else
        {
            r0.z = r1.w;
        }
        r1.w = r0.z;
    }
    r0.z = (r2.z) * (r9.w) + (r10.w);
    r0.z = (r0.z) * (r8.w) + (c13.z);
    r0.y = 1.0f / (r0.z);
    r0.z = (r7.w) * (r2.x);
    r0.y = (r2.z) * (r0.y);
    r1.z = (r0.z) * (r0.y);
    r0.xyz = (r13.xyz) * (r2.www) + (r14.xyz);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = (r2.yyy) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r1.www) * (r11.xyz) + (r12.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r0.xyz = (r10.xyz) * (r0.xyz) + (r1.xyz);
    r1 = (v7.yyyy) * (c[26]);
    r6.xyz = (r9.xyz) * (r2.yyy) + (r0.xyz);
    r1 = (v7.xxxx) * (c[25]) + (r1);
    r0.z = dot(r8.xyz, c[23].xyz);
    r1 = (v7.zzzz) * (c[27]) + (r1);
    r0.z = saturate((r0.z) * (c[24].x) + (c[24].y));
    r4 = (r1) + (c[28]);
    r0.y = (r0.z) * (-(c12.w)) + (-(c12.y));
    r3.zw = r4.zw;
    r0.z = (r0.z) * (r0.z);
    r5.zw = r3.zw;
    r4.z = (r0.y) * (r0.z);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[29].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[29].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[29].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[29].zw) + (r4.xy);
    r3 = tex2Dproj(s3, r2);
    r2 = (v7.xyzx) * (c13.yyyw) + (c13.wwwy);
    r1.z = r3.x;
    r0.z = dot(r2, c[22]);
    r3.w = 1.0f / (r0.z);
    r3.x = dot(r2, c[21]);
    r0.x = dot(r2, c[11]);
    r3.y = (r3.x) * (r3.x);
    r0.y = dot(r2, c[20]);
    r0.z = dot(c[9].yz, r3.xy) + (c[9].x);
    r2.w = saturate(1.0f / (r0.z));
    r2.xy = saturate((r3.xx) * (c[10].xy) + (c[10].zw));
    r3.xy = (r2.xy) * (-(c12.ww)) + (-(c12.yy));
    r2.xy = (r2.xy) * (r2.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c13.w) : (r2.w));
    r2.w = (r3.x) * (r2.x);
    r0.z = (r0.z) * (r2.w);
    r2.w = (r2.y) * (-(r3.y)) + (c1.w);
    r0.xy = (r3.ww) * (r0.xy);
    r0.z = (r0.z) * (r2.w);
    r3.w = (r4.z) * (r0.z);
    r0.xy = (r0.xy) * (c15.xx) + (c15.xx);
    r2 = tex2D(s4, r0.xy);
    r0.xyz = (r2.xyz) * (r2.xyz);
    r1.w = dot(r1, c3.yyyy);
    r0.xyz = (r3.www) * (r0.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.w = (r0.w) * (v0.w);
    r0.xyz = (r0.xyz) * (r7.xyz) + (r6.xyz);
    r1.xyz = (r0.www) * (v3.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v2.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[30].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
