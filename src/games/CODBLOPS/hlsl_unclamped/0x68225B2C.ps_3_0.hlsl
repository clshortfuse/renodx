// Mechanically reconstructed from 0x68225B2C.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(-1.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c13 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c14 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 oC0 = 0.0f;

    r1.w = dot(v4.xyz, v4.xyz);
    r0.xy = (v0.zw) * (c14.yz);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v0.zw);
    r5.xy = (r2.xy) * (c1.xx);
    r1.w = rsqrt(r1.w);
    r3.xy = (r0.xz) * (r5.xx);
    r1.x = r0.y;
    r0.w = (r2.x) * (c1.x) + (-(r3.x));
    r1.z = (r0.z) * (-(r5.x)) + (r0.w);
    r0.xy = (v0.zw) * (c14.yz) + (c14.wz);
    r0 = tex2D(s13, r0.xy);
    r4.xy = (r5.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c1.x) + (-(r4.x));
    r0.xy = (r1.xy) * (c1.yy) + (c1.zz);
    r0.z = (r0.z) * (-(r5.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c14.w);
    r6.y = (r1.z) + (r1.z);
    r0.y = (r0.z) + (r0.z);
    r0.w = exp2(-(r0.w));
    r2.xyz = (-(v4.xyz)) + (c[20].xyz);
    r2.w = saturate((r0.w) * (c3.x) + (c3.y));
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r7.xyz = (r1.www) * (v4.xyz);
    r6.xz = (r3.xy) * (c1.yy);
    r3.xyz = (r2.xyz) * (r0.www) + (-(r7.xyz));
    r1.xyz = normalize(r3.xyz);
    r3.xyz = (r2.xyz) * (r0.www);
    r0.xz = (r4.xy) * (c1.yy);
    r0.w = saturate(dot(r1.xyz, r3.xyz));
    r2.xyz = (r0.xyz) * (r2.www) + (r6.xyz);
    r2.w = (-(r0.w)) + (c0.y);
    r6.w = dot(r3.xyz, c[29].xyz);
    r3.w = (r2.w) * (r2.w);
    r0 = tex2D(s5, v0.xy);
    r13.z = (r0.w) * (-(c14.x)) + (c14.y);
    r13.y = (r0.w) * (c14.x);
    r9.xyz = normalize(v1.xyz);
    r7.w = saturate(dot(r3.xyz, r9.xyz));
    r0.z = saturate(dot(r9.xyz, -(r7.xyz)));
    r0.x = (r7.w) * (r13.z) + (r13.y);
    r13.w = (r0.z) * (r13.z) + (r13.y);
    r3.w = (r3.w) * (r3.w);
    r0.x = (r0.x) * (r13.w) + (c1.w);
    r9.w = (r2.w) * (r3.w);
    r0.x = 1.0f / (r0.x);
    r0.x = (r7.w) * (r0.x);
    r2.w = (-(r0.z)) + (c0.y);
    r3.w = (r2.w) * (r2.w);
    r0.z = dot(r7.xyz, r9.xyz);
    r2.w = (r2.w) * (r3.w);
    r10.w = (r0.z) + (r0.z);
    r3.w = saturate(dot(r9.xyz, r1.xyz));
    r1.xy = (r0.ww) * (c15.xy) + (c15.zw);
    r1.z = 1.0f / (r1.x);
    r12.z = exp2(r1.y);
    r0.z = pow(abs(r3.w), r12.z);
    r11.w = (r12.z) * (c3.z) + (c3.w);
    r8.w = (r2.w) * (r1.z);
    r0.z = (r0.z) * (r11.w);
    r0.x = (r0.x) * (r0.z);
    r1.xyz = (v4.xyz) * (-(r1.www)) + (c[17].xyz);
    r11.xyz = (r2.xyz) * (r0.yyy);
    r8.xyz = normalize(r1.xyz);
    r12.w = saturate(dot(r9.xyz, c[17].xyz));
    r13.x = saturate(dot(r8.xyz, c[17].xyz));
    r1 = tex2D(s12, v0.zw);
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c14.y) : (c14.w));
    r10.xyz = (r12.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
    }
    else
    {
        if ((c0.y) >= (v3.w))
        {
            r2 = (v3.xyzx) * (c14.yyyw);
            r1 = (r2) + (-(c4.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c12.xxyy);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (c12.zzyy);
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c4.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c3.wwww);
            if ((c12.w) < (v3.w))
            {
                r5.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c12.xx);
                r1.zw = (v3.zx) * (c14.yw);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (c12.zz);
                r2.zw = (v3.zx) * (c14.yw);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c4.xy);
                r2.zw = (v3.zx) * (c14.yw);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c4.xy));
                r2.zw = (v3.zx) * (c14.yw);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r1.w = dot(r1, c3.wwww);
                r1.z = (-(r0.z)) + (r1.w);
                r1.w = (v3.w) * (c13.x) + (c13.y);
                r0.z = (r1.w) * (r1.z) + (r0.z);
            }
        }
        else
        {
            r0.z = (v3.w) + (-(c1.y));
            r0.z = ((r0.z) >= 0.0f ? (c14.w) : (c14.y));
            if ((r0.z) != (-(r0.z)))
            {
                r12.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r12.xy) + (c12.xx);
                r2.zw = (v3.zz) * (c14.yw);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r12.xy) + (c12.zz);
                r3.zw = (v3.zz) * (c14.yw);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r12.xy) + (c4.xy);
                r3.zw = (v3.zz) * (c14.yw);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r12.xy) + (-(c4.xy));
                r3.zw = (v3.zz) * (c14.yw);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r1.z = dot(r2, c3.wwww);
                r0.z = saturate((v3.w) + (c4.w));
                r1.w = (r1.y) + (-(r1.z));
                r0.z = (r0.z) * (r1.w) + (r1.z);
            }
            else
            {
                r0.z = r1.y;
            }
        }
    }
    r1.y = (-(r13.x)) + (c0.y);
    r3.xyz = (r0.zzz) * (r10.xyz) + (r11.xyz);
    r1.w = (r1.y) * (r1.y);
    r1.x = (r1.w) * (r1.w);
    r1.w = (r12.w) * (r13.z) + (r13.y);
    r1.w = (r1.w) * (r13.w) + (c1.w);
    r2.w = saturate(dot(r9.xyz, r8.xyz));
    r1.z = 1.0f / (r1.w);
    r1.w = pow(abs(r2.w), r12.z);
    r1.z = (r12.w) * (r1.z);
    r1.w = (r11.w) * (r1.w);
    r4.w = (r1.y) * (r1.x);
    r3.w = (r1.z) * (r1.w);
    r1.w = (r0.w) * (c0.w);
    r1.xyz = (r9.xyz) * (-(r10.www)) + (r7.xyz);
    r1 = texCUBElod(s15, r1);
    r2 = tex2D(s4, v5.zw);
    r2.xyz = (r2.xyz) + (c0.xxx);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r5.xyz = (v5.yyy) * (r2.xyz) + (c0.yyy);
    r4.xyz = (r0.yyy) * (r1.xyz);
    r1.xyz = (r5.xyz) * (c0.zzz);
    r7.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r8.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r7.xyz) * (r9.www) + (r8.xyz);
    r1.xyz = (r7.xyz) * (r4.www) + (r8.xyz);
    r7.xyz = (r7.xyz) * (r8.www) + (r8.xyz);
    r1.xyz = (r3.www) * (r1.xyz);
    r4.xyz = (r4.xyz) * (r7.xyz);
    r1.xyz = (r0.yyy) * (r1.xyz);
    r2.xyz = (r0.xxx) * (r2.xyz);
    r7.xyz = (r1.xyz) * (c[19].xyz);
    r1 = tex2D(s0, v0.xy);
    r5.xyz = (r5.xyz) * (r1.xyz);
    r1.xyz = (r0.zzz) * (r7.xyz);
    r5.xyz = (r5.xyz) * (r5.xyz);
    r3.xyz = (r5.xyz) * (r3.xyz) + (r1.xyz);
    r1.xyz = (r6.xyz) * (r4.xyz);
    r7.xyz = (r1.xyz) * (c0.www) + (r3.xyz);
    r1.xyz = (r2.xyz) * (c[22].xyz);
    r2.xyz = (r0.yyy) * (r1.xyz);
    r0 = (v4.yyyy) * (c[32]);
    r1.xyz = (r7.www) * (c[21].xyz);
    r0 = (v4.xxxx) * (c[31]) + (r0);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0 = (v4.zzzz) * (c[33]) + (r0);
    r1.w = saturate((r6.w) * (c[30].x) + (c[30].y));
    r3 = (r0) + (c[34]);
    r0.z = (r1.w) * (c13.z) + (c13.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r0.zw = r4.zw;
    r1.xy = (r3.ww) * (-(c[35].zw)) + (r3.xy);
    r1.zw = r0.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r4.xy = (r2.ww) * (-(c[35].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r1.y = r4.x;
    r2.xy = (r2.ww) * (c[35].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r1.x = r4.x;
    r0.xy = (r2.ww) * (c[35].zw) + (r3.xy);
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0 = (v4.xyzx) * (c14.yyyw) + (c14.wwwy);
    r5.w = dot(r1, c3.wwww);
    r1.w = dot(r0, c[28]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c13.zz) + (c13.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c14.w) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c0.y);
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r6.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (c14.zz) + (c14.zz);
    r4 = tex2D(s3, r0.xy);
    r3 = (-(v4.yyyy)) + (c[6]);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r8.xyz = (r6.www) * (r8.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r2.z = c0.y;
    r0 = saturate((r0) * (c[8]) + (r2.zzzz));
    r2.xyz = (r5.www) * (r8.xyz);
    r0 = (r1) * (r0);
    r2.xyz = (r2.xyz) * (r6.xyz) + (r7.xyz);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
