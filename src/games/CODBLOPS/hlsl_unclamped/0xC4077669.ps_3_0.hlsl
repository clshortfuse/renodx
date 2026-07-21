// Mechanically reconstructed from 0xC4077669.ps_3_0.cso.
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
sampler2D s7 : register(s7);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
    float4 v8 : COLOR1;
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
    const float4 c1 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c4 = float4(0.200000003f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c9 = float4(0.797884583f, 31.875f, 4.0f, -2.0f);
    const float4 c10 = float4(0.797884583f, 1.0f, 0.0009765625f, 0.25f);
    const float4 c11 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c12 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
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
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 r15 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s5, v7.xy);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v8) + (c3.yyyy);
    r2.y = dot(r1.xy, r0.zw) + (c3.z);
    r2.x = dot(r1.xy, r0.xy) + (c3.z);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r1 = tex2D(s6, v1.xy);
    r4 = tex2D(s0, v1.xy);
    r0 = tex2D(s3, v7.xy);
    r1.z = (r0.w) * (v0.y) + (c3.w);
    r3.z = r1.w;
    r4.xyz = float3(((r1.z) >= 0.0f ? (r0.x) : (r4.x)), ((r1.z) >= 0.0f ? (r0.y) : (r4.y)), ((r1.z) >= 0.0f ? (r0.z) : (r4.z)));
    r0 = tex2D(s7, v7.xy);
    r2.z = r0.w;
    r11.xyz = float3(((r1.z) >= 0.0f ? (r2.x) : (r3.x)), ((r1.z) >= 0.0f ? (r2.y) : (r3.y)), ((r1.z) >= 0.0f ? (r2.z) : (r3.z)));
    r0.w = dot(v6.xyz, v6.xyz);
    r5.w = ((r1.z) >= 0.0f ? (r0.y) : (r1.y));
    r5.z = rsqrt(r0.w);
    r4.w = (r11.z) * (-(c10.x)) + (c10.y);
    r0.xyz = (v6.xyz) * (-(r5.zzz)) + (c[17].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = dot(r11.xy, r11.xy) + (c3.z);
    r6.w = saturate(dot(r3.xyz, c[17].xyz));
    r0.w = exp2(-(r0.w));
    r3.w = (r0.w) * (c4.y) + (c4.z);
    r0.xy = (v1.zw) * (-(c3.yw)) + (-(c3.zw));
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (-(c3.yw));
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1 = tex2D(s14, v1.zw);
    r6.xy = (r1.xy) * (c9.yy);
    r7.xy = (r0.wy) * (c9.zz) + (c9.ww);
    r2.xy = (r2.xz) * (r6.xx);
    r0.w = dot(r7.xy, r11.xy) + (c3.z);
    r0.y = (r1.x) * (c9.y) + (-(r2.x));
    r1.w = (r2.z) * (-(r6.x)) + (r0.y);
    r5.xy = (r0.xz) * (r6.yy);
    r0.y = (r1.y) * (c9.y) + (-(r5.x));
    r0.x = dot(r7.xy, r7.xy) + (c3.z);
    r0.y = (r0.z) * (-(r6.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r6.y = (r1.w) + (r1.w);
    r0.z = (r0.z) * (c4.y) + (c4.z);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r3.w) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r5.xy) * (c9.zz);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = (-(r6.w)) + (-(c3.y));
    r6.xz = (r2.xy) * (c9.zz);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r6.xyz) * (r3.www) + (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r14.xyz = (r5.www) * (r0.xyz);
    r3.w = (r0.w) * (r1.w);
    r0 = tex2D(s4, v7.zw);
    r0.xyz = (r0.xyz) + (c3.yyy);
    r1.xyz = (v0.zzz) * (r0.xyz) + (-(c3.yyy));
    r0.xyz = v2.xyz;
    r2.xyz = (r11.xxx) * (v4.xyz) + (r0.xyz);
    r0.xyz = (r1.xyz) * (c4.xxx);
    r2.xyz = (r11.yyy) * (v3.xyz) + (r2.xyz);
    r8.xyz = (r0.xyz) * (-(r0.xyz)) + (-(c3.yyy));
    r10.xyz = normalize(r2.xyz);
    r9.xyz = (r0.xyz) * (r0.xyz);
    r2.z = saturate(dot(r10.xyz, r3.xyz));
    r0.y = (r11.z) * (c9.x);
    r11.xy = (r11.zz) * (c11.xy) + (c11.zw);
    r2.w = exp2(r11.y);
    r5.xyz = (r5.zzz) * (v6.xyz);
    r6.w = saturate(dot(r10.xyz, -(r5.xyz)));
    r1.w = saturate(dot(r10.xyz, c[17].xyz));
    r0.z = (r6.w) * (r4.w) + (r0.y);
    r0.w = (r1.w) * (r4.w) + (r0.y);
    r0.y = pow(abs(r2.z), r2.w);
    r0.z = (r0.w) * (r0.z) + (c10.z);
    r0.w = (r2.w) * (c12.x) + (c12.y);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.y) * (r0.w);
    r2.w = (r1.w) * (r0.z);
    r0.xyz = (r8.xyz) * (r3.www) + (r9.xyz);
    r0.w = (r0.w) * (r2.w);
    r1.xyz = (r4.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r7.xyz = (r1.xyz) * (r1.xyz);
    r12.xyz = (r5.www) * (r0.xyz);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (-(c3.y)) : (-(c3.z)));
    r13.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((-(c3.y)) >= (v5.w))
        {
            r1 = (v5.xyzx) * (-(c3.yyyz));
            r0 = (r1) + (-(c13.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c12.zzww);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (-(c12.zzww));
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c13.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c10.wwww);
            if ((c13.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c12.zz);
                r0.zw = (v5.zx) * (-(c3.yz));
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (-(c12.zz));
                r1.zw = (v5.zx) * (-(c3.yz));
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c13.xy);
                r1.zw = (v5.zx) * (-(c3.yz));
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c13.xy));
                r1.zw = (v5.zx) * (-(c3.yz));
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c10.wwww);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c14.x) + (c14.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c9.z));
            r0.w = ((r0.w) >= 0.0f ? (-(c3.z)) : (-(c3.y)));
            if ((r0.w) != (-(r0.w)))
            {
                r15.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r15.xy) + (c12.zz);
                r1.zw = (v5.zz) * (-(c3.yz));
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r15.xy) + (-(c12.zz));
                r2.zw = (v5.zz) * (-(c3.yz));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r15.xy) + (c13.xy);
                r2.zw = (v5.zz) * (-(c3.yz));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r15.xy) + (-(c13.xy));
                r2.zw = (v5.zz) * (-(c3.yz));
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c10.wwww);
                r0.w = saturate((v5.w) + (c14.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r2.xyz = (r0.www) * (r13.xyz) + (r14.xyz);
    r0.xyz = (r12.xyz) * (c[19].xyz);
    r3.xyz = (r0.www) * (r0.xyz);
    r0.w = (-(r6.w)) + (-(c3.y));
    r0.y = 1.0f / (r11.x);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.w) * (r0.z);
    r0.w = dot(r5.xyz, r10.xyz);
    r1.w = (r0.y) * (r0.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r11.z) * (c4.w);
    r0.xyz = (r10.xyz) * (-(r0.zzz)) + (r5.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r5.www) * (r0.xyz);
    r1.xyz = (r8.xyz) * (r1.www) + (r9.xyz);
    r2.xyz = (r7.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.xyz);
    r1.xyz = (r6.xyz) * (r0.xyz);
    r0.w = dot(c[5].xyz, r5.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.xyz) * (c4.www) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c3.y);

    return oC0;
}
