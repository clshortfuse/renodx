// Mechanically reconstructed from 0xE95A6C41.ps_3_0.cso.
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
sampler2D s8 : register(s8);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c3 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c4 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c12 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c14 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c38 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 r18 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = dot(v6.xyz, v6.xyz);
    r1.w = rsqrt(r0.w);
    r0 = tex2D(s1, v0.xy);
    r1.xyz = (-(v6.xyz)) + (c[20].xyz);
    r0.z = dot(r1.xyz, r1.xyz);
    r0.z = rsqrt(r0.z);
    r15.xyz = (r1.www) * (v6.xyz);
    r2.xyz = (r1.xyz) * (r0.zzz) + (-(r15.xyz));
    r14.xyz = normalize(r2.xyz);
    r16.xyz = (r1.xyz) * (r0.zzz);
    r0.z = saturate(dot(r14.xyz, r16.xyz));
    r0.z = (-(r0.z)) + (-(c1.y));
    r5.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.y = (r0.z) * (r0.z);
    r0.w = dot(r16.xyz, c[29].xyz);
    r0.y = (r0.y) * (r0.y);
    r5.w = (r0.z) * (r0.y);
    r0.xyz = (v6.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.w = saturate((r0.w) * (c[30].x) + (c[30].y));
    r13.xyz = normalize(r0.xyz);
    r0.z = (r0.w) * (c16.z) + (c16.w);
    r0.y = saturate(dot(r13.xyz, c[17].xyz));
    r0.w = (r0.w) * (r0.w);
    r1.w = (-(r0.y)) + (-(c1.y));
    r7.w = (r0.z) * (r0.w);
    r0.w = (r1.w) * (r1.w);
    r1.z = (r0.w) * (r0.w);
    r0.xy = (v0.zw) * (-(c1.yw));
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v0.zw);
    r6.xy = (r2.xy) * (c4.ww);
    r8.w = (r1.w) * (r1.z);
    r3.xy = (r0.xz) * (r6.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c4.w) + (-(r3.x));
    r1.w = (r0.z) * (-(r6.x)) + (r0.w);
    r0.xy = (v0.zw) * (-(c1.yw)) + (-(c1.zw));
    r0 = tex2D(s13, r0.xy);
    r4.xy = (r6.yy) * (r0.xz);
    r8.y = (r1.w) + (r1.w);
    r0.w = (r2.y) * (c4.w) + (-(r4.x));
    r1.w = (r0.z) * (-(r6.y)) + (r0.w);
    r1.y = r0.y;
    r0 = tex2D(s6, v7.zw);
    r6.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r2.y = dot(r6.xy, r0.zw) + (c1.z);
    r2.x = dot(r6.xy, r0.xy) + (c1.z);
    r0 = tex2D(s5, v7.zw);
    r4.w = (r0.w) * (v7.y) + (c1.w);
    r6.xy = (r1.xy) * (c12.xx) + (c12.yy);
    r5.xy = float2(((r4.w) >= 0.0f ? (r2.x) : (r5.x)), ((r4.w) >= 0.0f ? (r2.y) : (r5.y)));
    r2.y = (r1.w) + (r1.w);
    r2.w = dot(r6.xy, r5.xy) + (c1.z);
    r1 = tex2D(s0, v0.xy);
    r0.w = dot(r5.xy, r5.xy) + (c1.z);
    r1.w = dot(r6.xy, r6.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r1.w = exp2(-(r1.w));
    r0.w = (r0.w) * (c4.x) + (c4.y);
    r1.w = (r1.w) * (c4.x) + (c4.y);
    r0.xyz = float3(((r4.w) >= 0.0f ? (r0.x) : (r1.x)), ((r4.w) >= 0.0f ? (r0.y) : (r1.y)), ((r4.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1.w = (r0.w) * (r1.w);
    r1.w = saturate((r2.w) * (r1.w) + (r1.w));
    r2.xz = (r4.xy) * (c12.xx);
    r1.xyz = (r2.xyz) * (r1.www);
    r8.xz = (r3.xy) * (c12.xx);
    r4.xyz = (r8.xyz) * (r0.www) + (r1.xyz);
    r7.xyz = (r0.xyz) * (r0.xyz);
    r1 = tex2D(s12, v0.zw);
    r3 = tex2D(s8, v7.zw);
    r0 = (r3.wwww) * (c3.xxxy) + (c3.zzzx);
    r2 = tex2D(s7, v0.xy);
    r2 = float4(((r4.w) >= 0.0f ? (r0.x) : (r2.x)), ((r4.w) >= 0.0f ? (r0.y) : (r2.y)), ((r4.w) >= 0.0f ? (r0.z) : (r2.z)), ((r4.w) >= 0.0f ? (r0.w) : (r2.w)));
    r1.w = ((-abs(r1.y)) >= 0.0f ? (-(c1.y)) : (-(c1.z)));
    r11.xyz = (r2.xyz) * (-(r2.xyz)) + (-(c1.yyy));
    r12.xyz = (r2.xyz) * (r2.xyz);
    r0 = v1;
    r0.xyz = (r5.xxx) * (v4.xyz) + (r0.xyz);
    r10.xyz = (r11.xyz) * (r5.www) + (r12.xyz);
    r0.xyz = (r5.yyy) * (v3.xyz) + (r0.xyz);
    r10.w = (r2.w) * (-(c12.z)) + (c12.w);
    r9.xyz = normalize(r0.xyz);
    r2.xyz = float3(((r4.w) >= 0.0f ? (r3.y) : (c[36].x)), ((r4.w) >= 0.0f ? (r3.y) : (c[36].y)), ((r4.w) >= 0.0f ? (r3.y) : (c[36].w)));
    r9.w = saturate(dot(r9.xyz, c[17].xyz));
    r18.xyz = (r4.xyz) * (r2.yyy);
    r17.xyz = (r9.www) * (c[18].xyz);
    if ((r1.w) != (-(r1.w)))
    {
        r0.z = r1.y;
        r3.w = r0.z;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r3 = (v5.xyzx) * (-(c1.yyyz));
            r1 = (r3) + (-(c13.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r4 = (r3) + (c15.xxyy);
            r4 = tex2Dlod(s2, r4);
            r1.x = r4.x;
            r4 = (r3) + (c15.zzyy);
            r4 = tex2Dlod(s2, r4);
            r1.y = r4.x;
            r3 = (r3) + (c13.xyzz);
            r3 = tex2Dlod(s2, r3);
            r1.z = r3.x;
            r0.z = dot(r1, c14.zzzz);
            if ((c14.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c15.xx);
                r1.zw = (v5.zx) * (-(c1.yz));
                r1 = tex2Dlod(s2, r1);
                r3.xy = (r0.xy) + (c15.zz);
                r3.zw = (v5.zx) * (-(c1.yz));
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c13.xy);
                r3.zw = (v5.zx) * (-(c1.yz));
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c13.xy));
                r3.zw = (v5.zx) * (-(c1.yz));
                r3 = tex2Dlod(s2, r3);
                r1.y = r5.x;
                r1.z = r4.x;
                r1.w = r3.x;
                r0.y = dot(r1, c14.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c16.x) + (c16.y);
                r3.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r3.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c12.x));
            r0.z = ((r0.z) >= 0.0f ? (-(c1.z)) : (-(c1.y)));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c15.xx);
                r3.zw = (v5.zz) * (-(c1.yz));
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c15.zz);
                r4.zw = (v5.zz) * (-(c1.yz));
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c13.xy);
                r4.zw = (v5.zz) * (-(c1.yz));
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c13.xy));
                r4.zw = (v5.zz) * (-(c1.yz));
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c14.zzzz);
                r0.z = saturate((v5.w) + (c15.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r3.w = r0.z;
        }
    }
    r4.xyz = (r3.www) * (r17.xyz) + (r18.xyz);
    r5.z = (r2.w) * (c4.z);
    r2.y = saturate(dot(r16.xyz, r9.xyz));
    r0.z = saturate(dot(r9.xyz, -(r15.xyz)));
    r0.y = (r2.y) * (r10.w) + (r5.z);
    r5.w = (r0.z) * (r10.w) + (r5.z);
    r0.x = (r0.y) * (r5.w) + (c14.x);
    r0.y = dot(r15.xyz, r9.xyz);
    r3.z = 1.0f / (r0.x);
    r0.y = (r0.y) + (r0.y);
    r1.w = (r2.w) * (c3.w);
    r1.xyz = (r9.xyz) * (-(r0.yyy)) + (r15.xyz);
    r1 = texCUBElod(s15, r1);
    r0.z = (-(r0.z)) + (-(c1.y));
    r0.y = (r0.z) * (r0.z);
    r5.xy = (r2.ww) * (c38.xy) + (c38.zw);
    r1.w = (r0.z) * (r0.y);
    r2.w = 1.0f / (r5.x);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r0.xyz = (r2.xxx) * (r0.xyz);
    r1.xyz = (r11.xyz) * (r1.www) + (r12.xyz);
    r2.w = (r2.y) * (r3.z);
    r3.xyz = (r0.xyz) * (r1.xyz);
    r4.w = exp2(r5.y);
    r2.x = saturate(dot(r9.xyz, r14.xyz));
    r1.w = (r4.w) * (c14.y) + (c14.z);
    r0.z = (r9.w) * (r10.w) + (r5.z);
    r0.z = (r0.z) * (r5.w) + (c14.x);
    r1.z = saturate(dot(r9.xyz, r13.xyz));
    r0.y = 1.0f / (r0.z);
    r0.z = pow(abs(r1.z), r4.w);
    r0.y = (r9.w) * (r0.y);
    r0.z = (r1.w) * (r0.z);
    r1.y = (r0.y) * (r0.z);
    r0.xyz = (r11.xyz) * (r8.www) + (r12.xyz);
    r1.z = pow(abs(r2.x), r4.w);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r1.w = (r1.w) * (r1.z);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r1.w = (r2.w) * (r1.w);
    r1.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r10.xyz) * (r1.www);
    r1.xyz = (r3.www) * (r1.xyz);
    r4.xyz = (r7.xyz) * (r4.xyz) + (r1.xyz);
    r1 = (v6.yyyy) * (c[32]);
    r3.xyz = (r8.xyz) * (r3.xyz);
    r1 = (v6.xxxx) * (c[31]) + (r1);
    r8.xyz = (r3.xyz) * (c3.www) + (r4.xyz);
    r1 = (v6.zzzz) * (c[33]) + (r1);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r4 = (r1) + (c[34]);
    r1.xyz = (r2.zzz) * (r0.xyz);
    r3.zw = r4.zw;
    r0.xyz = (r2.yyy) * (c[21].xyz);
    r5.zw = r3.zw;
    r6.xyz = (r7.xyz) * (r0.xyz) + (r1.xyz);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[35].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[35].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[35].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[35].zw) + (r4.xy);
    r1 = tex2Dproj(s3, r1);
    r2.z = r1.x;
    r1 = (v6.xyzx) * (-(c1.yyyz)) + (-(c1.zzzy));
    r6.w = dot(r2, c14.zzzz);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r2.x = dot(r1, c[27]);
    r0.x = dot(r1, c[25]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r1.xy) * (c16.zz) + (c16.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (-(c1.y));
    r0.xy = (r2.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r7.w = (r7.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.ww)) + (-(c1.ww));
    r5 = tex2D(s4, r0.xy);
    r4 = (-(v6.yyyy)) + (c[6]);
    r3 = (-(v6.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v6.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r7.www) * (r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.z = c1.y;
    r1 = saturate((r1) * (c[8]) + (-(r3.zzzz)));
    r0.xyz = (r6.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r6.xyz) + (r8.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r7.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c1.y);

    return oC0;
}
