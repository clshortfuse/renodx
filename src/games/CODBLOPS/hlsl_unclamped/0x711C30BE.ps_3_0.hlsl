// Mechanically reconstructed from 0x711C30BE.ps_3_0.cso.
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
    const float4 c1 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.0009765625f, 0.25f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c13 = float4(0.125f, 0.25f, 0.000244140625f, 0.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c15 = float4(1.0f, 0.797884583f, 0.959999979f, 0.0399999991f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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

    r0 = tex2D(s1, v1.xy);
    r6.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.z = dot(v7.xyz, v7.xyz);
    r0.w = dot(r6.xy, r6.xy) + (c1.x);
    r3.w = rsqrt(r0.z);
    r0.w = exp2(-(r0.w));
    r3.z = (r0.w) * (c1.y) + (c1.z);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xy = (v1.zw) * (c3.xy);
    r2 = tex2D(s13, r1.xy);
    r0.w = r2.y;
    r1 = tex2D(s14, v1.zw);
    r4.xy = (r1.xy) * (c3.ww);
    r5.xy = (r0.wy) * (c4.xx) + (c4.yy);
    r3.xy = (r2.xz) * (r4.xx);
    r0.w = dot(r5.xy, r6.xy) + (c1.x);
    r0.y = (r1.x) * (c3.w) + (-(r3.x));
    r1.w = (r2.z) * (-(r4.x)) + (r0.y);
    r2.xy = (r0.xz) * (r4.yy);
    r0.y = (r1.y) * (c3.w) + (-(r2.x));
    r0.x = dot(r5.xy, r5.xy) + (c1.x);
    r0.y = (r0.z) * (-(r4.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r7.y = (r1.w) + (r1.w);
    r0.z = (r0.z) * (c1.y) + (c1.z);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r3.z) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r1.xyz = (v7.xyz) * (-(r3.www)) + (c[17].xyz);
    r0.xz = (r2.xy) * (c4.xx);
    r2.xyz = normalize(r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.w = saturate(dot(r2.xyz, c[17].xyz));
    r7.xz = (r3.xy) * (c4.xx);
    r0.w = (-(r0.w)) + (c15.x);
    r4.xyz = (r7.xyz) * (r3.zzz) + (r0.xyz);
    r0.z = (r0.w) * (r0.w);
    r1.w = (r0.z) * (r0.z);
    r0.xyz = (-(v7.xyz)) + (c[20].xyz);
    r1.w = (r0.w) * (r1.w);
    r0.w = dot(r0.xyz, r0.xyz);
    r12.w = (r1.w) * (c15.z) + (c15.w);
    r0.w = rsqrt(r0.w);
    r8.xyz = (r3.www) * (v7.xyz);
    r5.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r0.xyz) * (r0.www) + (-(r8.xyz));
    r0.w = dot(r5.xyz, c[29].xyz);
    r3.xyz = normalize(r0.xyz);
    r0.w = saturate((r0.w) * (c[30].x) + (c[30].y));
    r0.z = (r0.w) * (c14.z) + (c14.w);
    r0.w = (r0.w) * (r0.w);
    r8.w = saturate(dot(r3.xyz, r5.xyz));
    r7.w = (r0.z) * (r0.w);
    r1 = tex2D(s7, v1.xy);
    r0 = v2;
    r0.xyz = (r6.xxx) * (v5.xyz) + (r0.xyz);
    r3.w = (r1.w) * (-(c15.y)) + (c15.x);
    r0.xyz = (r6.yyy) * (v4.xyz) + (r0.xyz);
    r6.z = (r1.w) * (c15.y);
    r9.xyz = normalize(r0.xyz);
    r1.z = saturate(dot(r5.xyz, r9.xyz));
    r0.z = saturate(dot(r9.xyz, -(r8.xyz)));
    r0.y = (r1.z) * (r3.w) + (r6.z);
    r5.w = (r0.z) * (r3.w) + (r6.z);
    r11.xyz = (r4.xyz) * (r1.yyy);
    r0.y = (r0.y) * (r5.w) + (c4.z);
    r0.y = 1.0f / (r0.y);
    r0.z = (-(r0.z)) + (c15.x);
    r1.x = (r1.z) * (r0.y);
    r0.y = (r0.z) * (r0.z);
    r0.z = (r0.z) * (r0.y);
    r0.xy = (r1.ww) * (c16.xy) + (c16.zw);
    r2.w = dot(r8.xyz, r9.xyz);
    r0.x = 1.0f / (r0.x);
    r10.w = (r2.w) + (r2.w);
    r2.w = (r0.z) * (r0.x);
    r4.w = exp2(r0.y);
    r3.z = saturate(dot(r9.xyz, r3.xyz));
    r0.y = pow(abs(r3.z), r4.w);
    r0.z = (r4.w) * (c13.x) + (c13.y);
    r0.x = (r0.y) * (r0.z);
    r0.y = saturate(dot(r9.xyz, c[17].xyz));
    r1.x = (r1.x) * (r0.x);
    r0.x = (r0.y) * (r3.w) + (r6.z);
    r3.w = saturate(dot(r9.xyz, r2.xyz));
    r0.x = (r0.x) * (r5.w) + (c4.z);
    r2.z = pow(abs(r3.w), r4.w);
    r0.x = 1.0f / (r0.x);
    r0.z = (r0.z) * (r2.z);
    r0.x = (r0.y) * (r0.x);
    r9.w = (r2.w) * (c15.z) + (c15.w);
    r11.w = (r0.z) * (r0.x);
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c3.x) : (c3.z));
    r10.xyz = (r0.yyy) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r4.w = r0.z;
    }
    else
    {
        if ((c15.x) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c3.xxxz);
            r2 = (r3) + (-(c12.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c13.zzww);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (-(c13.zzww));
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c12.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c4.wwww);
            if ((c12.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c13.zz);
                r2.zw = (v6.zx) * (c3.xz);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (-(c13.zz));
                r3.zw = (v6.zx) * (c3.xz);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c12.xy);
                r3.zw = (v6.zx) * (c3.xz);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c12.xy));
                r3.zw = (v6.zx) * (c3.xz);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c4.wwww);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c14.x) + (c14.y);
                r4.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r4.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c3.z) : (c3.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c13.zz);
                r3.zw = (v6.zz) * (c3.xz);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (-(c13.zz));
                r4.zw = (v6.zz) * (c3.xz);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c12.xy);
                r4.zw = (v6.zz) * (c3.xz);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c12.xy));
                r4.zw = (v6.zz) * (c3.xz);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c4.wwww);
                r0.z = saturate((v6.w) + (c14.y));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r4.w = r0.z;
        }
    }
    r4.xyz = (r4.www) * (r10.xyz) + (r11.xyz);
    r5.w = (r12.w) * (r11.w);
    r3 = tex2D(s0, v1.xy);
    r2 = tex2D(s5, v8.xy);
    r0.xyz = (r2.xyz) * (v0.yyy);
    r3.w = (r1.y) * (r5.w);
    r3.xyz = (r0.xyz) * (r2.www) + (r3.xyz);
    r2 = tex2D(s6, v8.zw);
    r0.xyz = (r2.xyz) * (v0.zzz);
    r0.xyz = (r0.xyz) * (r2.www) + (r3.xyz);
    r2.xyz = (r3.www) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r4.www) * (r2.xyz);
    r2.w = (r1.w) * (c1.w);
    r2.xyz = (r9.xyz) * (-(r10.www)) + (r8.xyz);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r0.xyz) * (r4.xyz) + (r3.xyz);
    r2.xyz = (r1.yyy) * (r2.xyz);
    r2.xyz = (r9.www) * (r2.xyz);
    r1.w = (-(r8.w)) + (c15.x);
    r2.xyz = (r7.xyz) * (r2.xyz);
    r2.w = (r1.w) * (r1.w);
    r7.xyz = (r2.xyz) * (c1.www) + (r3.xyz);
    r2.w = (r2.w) * (r2.w);
    r1.w = (r1.w) * (r2.w);
    r2 = (v7.yyyy) * (c[32]);
    r1.w = (r1.w) * (c15.z) + (c15.w);
    r2 = (v7.xxxx) * (c[31]) + (r2);
    r1.w = (r1.x) * (r1.w);
    r2 = (v7.zzzz) * (c[33]) + (r2);
    r3.xyz = (r1.www) * (c[22].xyz);
    r4 = (r2) + (c[34]);
    r2.xyz = (r1.yyy) * (r3.xyz);
    r3.zw = r4.zw;
    r1.xyz = (r1.zzz) * (c[21].xyz);
    r5.zw = r3.zw;
    r6.xyz = (r0.xyz) * (r1.xyz) + (r2.xyz);
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
    r1 = (v7.xyzx) * (c3.xxxz) + (c3.zzzx);
    r6.w = dot(r2, c4.wwww);
    r2.w = dot(r1, c[28]);
    r2.w = 1.0f / (r2.w);
    r3.x = dot(r1, c[27]);
    r2.x = dot(r1, c[25]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[26]);
    r1.w = dot(c[23].yz, r3.xy) + (c[23].x);
    r1.z = saturate(1.0f / (r1.w));
    r1.xy = saturate((r3.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r1.xy) * (c14.zz) + (c14.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c1.x) : (r1.z));
    r1.z = (r3.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = (r1.y) * (-(r3.y)) + (c15.x);
    r1.xy = (r2.ww) * (r2.xy);
    r1.w = (r1.w) * (r1.z);
    r7.w = (r7.w) * (r1.w);
    r1.xy = (r1.xy) * (c3.yy) + (c3.yy);
    r5 = tex2D(s4, r1.xy);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r8.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r8.xyz = (r7.www) * (r8.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r3.w = c15.x;
    r1 = saturate((r1) * (c[8]) + (r3.wwww));
    r3.xyz = (r6.www) * (r8.xyz);
    r1 = (r2) * (r1);
    r3.xyz = (r3.xyz) * (r6.xyz) + (r7.xyz);
    r2.z = dot(c[11], r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r0.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c15.x;

    return oC0;
}
