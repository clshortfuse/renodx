// Mechanically reconstructed from 0x2C8E1DE1.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 0.0f, 0.600000024f, 0.400000006f);
    const float4 c3 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c4 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(4.0f, -2.0f, 0.125f, 0.25f);
    const float4 c16 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
    const float4 c37 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s1, v0.xy);
    r4.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0 = tex2D(s5, v7.zw);
    r3.w = (r0.w) * (v7.y) + (c1.x);
    r1 = tex2D(s6, v0.xy);
    r2 = tex2D(s0, v0.xy);
    r2.xyz = float3(((r3.w) >= 0.0f ? (r0.x) : (r2.x)), ((r3.w) >= 0.0f ? (r0.y) : (r2.y)), ((r3.w) >= 0.0f ? (r0.z) : (r2.z)));
    r0 = tex2D(s7, v7.zw);
    r12.xy = float2(((r3.w) >= 0.0f ? (r0.w) : (r1.w)), ((r3.w) >= 0.0f ? (r0.y) : (r1.y)));
    r6.xyz = (r2.xyz) * (r2.xyz);
    r0.w = dot(r4.xy, r4.xy) + (c1.y);
    r4.z = (r12.x) * (-(c3.z)) + (c3.y);
    r0.w = exp2(-(r0.w));
    r3.z = (r0.w) * (c1.z) + (c1.w);
    r0.w = dot(v6.xyz, v6.xyz);
    r3.w = rsqrt(r0.w);
    r0.xy = (v0.zw) * (c16.xy) + (c16.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v0.zw) * (c3.yw);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1 = tex2D(s14, v0.zw);
    r5.xy = (r1.xy) * (c4.zz);
    r7.xy = (r0.wy) * (c15.xx) + (c15.yy);
    r2.xy = (r2.xz) * (r5.xx);
    r0.w = dot(r7.xy, r4.xy) + (c1.y);
    r0.y = (r1.x) * (c4.z) + (-(r2.x));
    r1.w = (r2.z) * (-(r5.x)) + (r0.y);
    r3.xy = (r0.xz) * (r5.yy);
    r0.y = (r1.y) * (c4.z) + (-(r3.x));
    r0.x = dot(r7.xy, r7.xy) + (c1.y);
    r0.y = (r0.z) * (-(r5.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r7.y = (r1.w) + (r1.w);
    r0.z = (r0.z) * (c1.z) + (c1.w);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r3.z) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r3.xy) * (c4.ww);
    r1.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (-(v6.xyz)) + (c[20].xyz);
    r7.xz = (r2.xy) * (c4.ww);
    r0.w = dot(r0.xyz, r0.xyz);
    r1.xyz = (r7.xyz) * (r3.zzz) + (r1.xyz);
    r0.w = rsqrt(r0.w);
    r8.xyz = (r3.www) * (v6.xyz);
    r3.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r8.xyz));
    r0.w = dot(r3.xyz, c[29].xyz);
    r2.xyz = normalize(r0.xyz);
    r0.w = saturate((r0.w) * (c[30].x) + (c[30].y));
    r8.w = saturate(dot(r2.xyz, r3.xyz));
    r2.w = (r0.w) * (c14.z) + (c14.w);
    r1.w = (r0.w) * (r0.w);
    r0 = v1;
    r0.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r7.w = (r2.w) * (r1.w);
    r0.xyz = (r4.yyy) * (v3.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r4.y = (r12.x) * (c3.z);
    r6.w = saturate(dot(r3.xyz, r9.xyz));
    r0.z = saturate(dot(r9.xyz, -(r8.xyz)));
    r0.y = (r6.w) * (r4.z) + (r4.y);
    r4.w = (r0.z) * (r4.z) + (r4.y);
    r0.y = (r0.y) * (r4.w) + (c16.w);
    r0.z = (-(r0.z)) + (c3.y);
    r0.x = 1.0f / (r0.y);
    r0.y = (r0.z) * (r0.z);
    r12.w = (r6.w) * (r0.x);
    r0.z = (r0.z) * (r0.y);
    r1.w = dot(r8.xyz, r9.xyz);
    r0.xy = (r12.xx) * (c37.xy) + (c37.zw);
    r10.w = (r1.w) + (r1.w);
    r0.x = 1.0f / (r0.x);
    r9.w = (r0.z) * (r0.x);
    r3.xyz = (v6.xyz) * (-(r3.www)) + (c[17].xyz);
    r3.w = exp2(r0.y);
    r0.xyz = normalize(r3.xyz);
    r3.z = saturate(dot(r9.xyz, r2.xyz));
    r1.w = saturate(dot(r0.xyz, c[17].xyz));
    r2.z = pow(abs(r3.z), r3.w);
    r2.y = (-(r1.w)) + (c3.y);
    r1.w = (r3.w) * (c15.z) + (c15.w);
    r2.w = (r2.y) * (r2.y);
    r2.x = (r2.w) * (r2.w);
    r2.w = saturate(dot(r9.xyz, c[17].xyz));
    r2.y = (r2.y) * (r2.x);
    r3.z = (r2.w) * (r4.z) + (r4.y);
    r2.x = saturate(dot(r9.xyz, r0.xyz));
    r0.y = (r3.z) * (r4.w) + (c16.w);
    r0.z = pow(abs(r2.x), r3.w);
    r0.y = 1.0f / (r0.y);
    r0.z = (r1.w) * (r0.z);
    r0.x = (r2.w) * (r0.y);
    r0.y = (r2.y) * (c4.x) + (c4.y);
    r0.z = (r0.z) * (r0.x);
    r11.w = (r2.z) * (r1.w);
    r0.z = (r0.y) * (r0.z);
    r11.xyz = (r12.yyy) * (r1.xyz);
    r12.z = (r12.y) * (r0.z);
    r1 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c16.x) : (c16.z));
    r10.xyz = (r2.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r1.w = r0.z;
    }
    else
    {
        if ((c3.y) >= (v5.w))
        {
            r2 = (v5.xyzx) * (c16.xxxz);
            r1 = (r2) + (-(c13.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c12.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c12.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c13.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c15.wwww);
            if ((c12.w) < (v5.w))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c12.xx);
                r1.zw = (v5.zx) * (c16.xz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c12.zz);
                r2.zw = (v5.zx) * (c16.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c13.xy);
                r2.zw = (v5.zx) * (c16.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c13.xy));
                r2.zw = (v5.zx) * (c16.xz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c15.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v5.w) * (c14.x) + (c14.y);
                r1.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r1.w = r0.z;
            }
        }
        else
        {
            r0.z = (v5.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c16.z) : (c16.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c12.xx);
                r2.zw = (v5.zz) * (c16.xz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c12.zz);
                r3.zw = (v5.zz) * (c16.xz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c13.xy);
                r3.zw = (v5.zz) * (c16.xz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c13.xy));
                r3.zw = (v5.zz) * (c16.xz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c15.wwww);
                r0.z = saturate((v5.w) + (c13.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r1.w = r0.z;
        }
    }
    r1.xyz = (r12.zzz) * (c[19].xyz);
    r0.xyz = (r1.www) * (r10.xyz) + (r11.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r2.w = (r12.w) * (r11.w);
    r2.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
    r1.w = (r12.x) * (c3.x);
    r1.xyz = (r9.xyz) * (-(r10.www)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r0.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r9.w) * (c4.x) + (c4.y);
    r0.xyz = (r12.yyy) * (r0.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r1.w = (-(r8.w)) + (c3.y);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r1.z = (r1.w) * (r1.w);
    r8.xyz = (r0.xyz) * (c3.xxx) + (r2.xyz);
    r0.z = (r1.z) * (r1.z);
    r0.z = (r1.w) * (r0.z);
    r1 = (v6.yyyy) * (c[32]);
    r0.z = (r0.z) * (c4.x) + (c4.y);
    r1 = (v6.xxxx) * (c[31]) + (r1);
    r0.z = (r2.w) * (r0.z);
    r1 = (v6.zzzz) * (c[33]) + (r1);
    r0.xyz = (r0.zzz) * (c[22].xyz);
    r4 = (r1) + (c[34]);
    r1.xyz = (r12.yyy) * (r0.xyz);
    r3.zw = r4.zw;
    r0.xyz = (r6.www) * (c[21].xyz);
    r5.zw = r3.zw;
    r7.xyz = (r6.xyz) * (r0.xyz) + (r1.xyz);
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
    r1 = (v6.xyzx) * (c16.xxxz) + (c16.zzzx);
    r6.w = dot(r2, c15.wwww);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r2.x = dot(r1, c[27]);
    r0.x = dot(r1, c[25]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r1.xy) * (c14.zz) + (c14.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.y) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c3.y);
    r0.xy = (r2.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r7.w = (r7.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.xx)) + (-(c1.xx));
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
    r3.z = c3.y;
    r1 = saturate((r1) * (c[8]) + (r3.zzzz));
    r0.xyz = (r6.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r7.xyz) + (r8.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r6.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.y;

    return oC0;
}
