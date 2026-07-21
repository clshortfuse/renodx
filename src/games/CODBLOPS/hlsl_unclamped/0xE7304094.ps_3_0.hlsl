// Mechanically reconstructed from 0xE7304094.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(8.0f, 1.0f, 0.797884583f, 0.5f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 0.0009765625f);
    const float4 c3 = float4(0.959999979f, 0.0399999991f, 31.875f, 4.0f);
    const float4 c4 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c12 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c13 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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

    r1.w = dot(v5.xyz, v5.xyz);
    r0.xy = (v1.zw) * (c0.yw);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c3.zz);
    r1.w = rsqrt(r1.w);
    r4.xy = (r0.xz) * (r5.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c3.z) + (-(r4.x));
    r1.z = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r5.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c3.z) + (-(r3.x));
    r0.xy = (r1.xy) * (c4.xx) + (c4.yy);
    r0.z = (r0.z) * (-(r5.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r0.w = exp2(-(r0.w));
    r6.y = (r1.z) + (r1.z);
    r0.y = (r0.z) + (r0.z);
    r0.w = saturate((r0.w) * (c4.z) + (c4.w));
    r6.xz = (r4.xy) * (c3.ww);
    r0.xz = (r3.xy) * (c3.ww);
    r2.xyz = (r0.xyz) * (r0.www) + (r6.xyz);
    r1.xyz = (v5.xyz) * (-(r1.www)) + (c[17].xyz);
    r0.xyz = normalize(r1.xyz);
    r3.xyz = (-(v5.xyz)) + (c[20].xyz);
    r5.y = saturate(dot(r0.xyz, c[17].xyz));
    r0.w = dot(r3.xyz, r3.xyz);
    r0.w = rsqrt(r0.w);
    r9.xyz = (r1.www) * (v5.xyz);
    r1.xyz = (r3.xyz) * (r0.www) + (-(r9.xyz));
    r4.xyz = (r3.xyz) * (r0.www);
    r3.xyz = normalize(r1.xyz);
    r0.w = dot(r4.xyz, c[29].xyz);
    r1.w = saturate(dot(r3.xyz, r4.xyz));
    r0.w = saturate((r0.w) * (c[30].x) + (c[30].y));
    r1.z = (r0.w) * (c15.z) + (c15.w);
    r3.w = (-(r1.w)) + (c0.y);
    r1.w = (r0.w) * (r0.w);
    r0.w = (r3.w) * (r3.w);
    r6.w = (r1.z) * (r1.w);
    r5.x = (r0.w) * (r0.w);
    r1 = tex2D(s4, v1.xy);
    r5.w = (r1.w) * (-(c0.z)) + (c0.y);
    r5.z = (r1.w) * (c0.z);
    r10.xyz = normalize(v2.xyz);
    r1.z = saturate(dot(r4.xyz, r10.xyz));
    r2.w = saturate(dot(r10.xyz, -(r9.xyz)));
    r0.w = (r1.z) * (r5.w) + (r5.z);
    r4.w = (r2.w) * (r5.w) + (r5.z);
    r4.z = (r3.w) * (r5.x);
    r0.w = (r0.w) * (r4.w) + (c1.w);
    r5.x = 1.0f / (r0.w);
    r4.xy = (r1.ww) * (c12.xy) + (c12.zw);
    r0.w = saturate(dot(r10.xyz, r3.xyz));
    r3.w = exp2(r4.y);
    r1.x = pow(abs(r0.w), r3.w);
    r0.w = (r3.w) * (c13.x) + (c13.y);
    r3.y = (r1.z) * (r5.x);
    r1.x = (r1.x) * (r0.w);
    r3.z = (r4.z) * (c3.x) + (c3.y);
    r1.x = (r3.y) * (r1.x);
    r1.x = (r3.z) * (r1.x);
    r3.z = 1.0f / (r4.x);
    r8.xyz = (r2.xyz) * (r1.yyy);
    r2.z = (-(r5.y)) + (c0.y);
    r2.y = (r2.z) * (r2.z);
    r2.w = (-(r2.w)) + (c0.y);
    r2.x = (r2.y) * (r2.y);
    r2.y = (r2.w) * (r2.w);
    r2.z = (r2.z) * (r2.x);
    r2.w = (r2.w) * (r2.y);
    r2.y = (r3.z) * (r2.w);
    r2.w = saturate(dot(r10.xyz, c[17].xyz));
    r8.w = (r2.y) * (c3.x) + (c3.y);
    r2.x = (r2.w) * (r5.w) + (r5.z);
    r2.y = saturate(dot(r10.xyz, r0.xyz));
    r0.z = (r2.x) * (r4.w) + (c1.w);
    r0.y = pow(abs(r2.y), r3.w);
    r0.z = 1.0f / (r0.z);
    r0.w = (r0.w) * (r0.y);
    r0.y = (r2.w) * (r0.z);
    r0.z = (r2.z) * (c3.x) + (c3.y);
    r0.w = (r0.w) * (r0.y);
    r0.z = (r0.z) * (r0.w);
    r0.w = dot(r9.xyz, r10.xyz);
    r7.w = (r1.y) * (r0.z);
    r9.w = (r0.w) + (r0.w);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.z));
    r7.xyz = (r2.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r2.w = r0.w;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c1.xxxz);
            r0 = (r2) + (-(c14.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r3 = (r2) + (c13.zzww);
            r3 = tex2Dlod(s1, r3);
            r0.x = r3.x;
            r3 = (r2) + (-(c13.zzww));
            r3 = tex2Dlod(s1, r3);
            r0.y = r3.x;
            r2 = (r2) + (c14.xyzz);
            r2 = tex2Dlod(s1, r2);
            r0.z = r2.x;
            r5.w = dot(r0, c13.yyyy);
            if ((c14.w) < (v4.w))
            {
                r5.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r5.xy) + (c13.zz);
                r0.zw = (v4.zx) * (c1.xz);
                r0 = tex2Dlod(s1, r0);
                r2.xy = (r5.xy) + (-(c13.zz));
                r2.zw = (v4.zx) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c14.xy);
                r2.zw = (v4.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c14.xy));
                r2.zw = (v4.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r0.y = r4.x;
                r0.z = r3.x;
                r0.w = r2.x;
                r0.w = dot(r0, c13.yyyy);
                r0.z = (-(r5.w)) + (r0.w);
                r0.w = (v4.w) * (c15.x) + (c15.y);
                r2.w = (r0.w) * (r0.z) + (r5.w);
            }
            else
            {
                r2.w = r5.w;
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c3.w));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r11.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r11.xy) + (c13.zz);
                r2.zw = (v4.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r11.xy) + (-(c13.zz));
                r3.zw = (v4.zz) * (c1.xz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r11.xy) + (c14.xy);
                r3.zw = (v4.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r11.xy) + (-(c14.xy));
                r3.zw = (v4.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.yyyy);
                r0.w = saturate((v4.w) + (c15.y));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r2.w = r0.w;
        }
    }
    r0.w = (r1.w) * (c0.x);
    r0.xyz = (r10.xyz) * (-(r9.www)) + (r9.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4.xyz = (r2.www) * (r7.xyz) + (r8.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r2.xyz = (r8.www) * (r0.xyz);
    r0.xyz = (r7.www) * (c[19].xyz);
    r3.xyz = (r6.xyz) * (r2.xyz);
    r5.xyz = (r2.www) * (r0.xyz);
    r0 = tex2D(s0, v1.xy);
    r0 = (r0.wxyz) * (v0.wxyz);
    r6.xyz = (r0.yzw) * (r0.yzw);
    r2 = (v5.yyyy) * (c[32]);
    r4.xyz = (r6.xyz) * (r4.xyz) + (r5.xyz);
    r2 = (v5.xxxx) * (c[31]) + (r2);
    r8.xyz = (r3.xyz) * (c0.xxx) + (r4.xyz);
    r2 = (v5.zzzz) * (c[33]) + (r2);
    r3.xyz = (r1.xxx) * (c[22].xyz);
    r4 = (r2) + (c[34]);
    r2.xyz = (r1.yyy) * (r3.xyz);
    r3.zw = r4.zw;
    r1.xyz = (r1.zzz) * (c[21].xyz);
    r5.zw = r3.zw;
    r7.xyz = (r6.xyz) * (r1.xyz) + (r2.xyz);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[35].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s2, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[35].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[35].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[35].zw) + (r4.xy);
    r1 = tex2Dproj(s2, r1);
    r2.z = r1.x;
    r1 = (v5.xyzx) * (c1.xxxz) + (c1.zzzx);
    r0.w = dot(r2, c13.yyyy);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r3.x = dot(r1, c[27]);
    r2.x = dot(r1, c[25]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r3.xy) + (c[23].x);
    r0.y = saturate(1.0f / (r0.z));
    r1.xy = saturate((r3.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r1.xy) * (c15.zz) + (c15.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.z) : (r0.y));
    r0.y = (r3.x) * (r1.x);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r1.y) * (-(r3.y)) + (c0.y);
    r1.xy = (r2.ww) * (r2.xy);
    r0.z = (r0.z) * (r0.y);
    r0.z = (r6.w) * (r0.z);
    r1.xy = (r1.xy) * (c0.ww) + (c0.ww);
    r5 = tex2D(s3, r1.xy);
    r4 = (-(v5.yyyy)) + (c[6]);
    r3 = (-(v5.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r9.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r9.xyz = (r0.zzz) * (r9.xyz);
    r4 = (r4) * (r5);
    r4 = (r10.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r10.xxxx) + (r4);
    r2 = saturate((r2) * (r10.zzzz) + (r3));
    r0.z = c0.y;
    r1 = saturate((r1) * (c[8]) + (r0.zzzz));
    r3.xyz = (r0.www) * (r9.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r3.xyz) * (r7.xyz) + (r8.xyz);
    r2.z = dot(c[11], r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r1.xyz = (r6.xyz) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r0.xxx) * (v3.xyz);
    r1.xyz = (r1.xyz) * (r0.xxx) + (-(r2.xyz));
    r1.xyz = (v2.www) * (r1.xyz) + (r2.xyz);
    r1.xyz = max(((r1.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
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
