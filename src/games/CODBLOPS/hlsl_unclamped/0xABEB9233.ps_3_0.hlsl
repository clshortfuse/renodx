// Mechanically reconstructed from 0xABEB9233.ps_3_0.cso.
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
    float4 v6 : TEXCOORD6;
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
    const float4 c0 = float4(-1.0f, 1.0f, 8.0f, 0.797884583f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c1.xy);
    r1 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r1.w = r0.y;
    r2.xy = (r1.yw) * (c3.xx) + (c3.yy);
    r0.y = dot(v5.xyz, v5.xyz);
    r0.w = dot(r2.xy, r2.xy) + (c1.z);
    r6.w = rsqrt(r0.y);
    r0.w = exp2(-(r0.w));
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c1.ww);
    r4.xy = (r1.xz) * (r5.xx);
    r3.xy = (r0.xz) * (r5.yy);
    r0.y = (r2.x) * (c1.w) + (-(r4.x));
    r0.x = (r2.y) * (c1.w) + (-(r3.x));
    r0.y = (r1.z) * (-(r5.x)) + (r0.y);
    r0.z = (r0.z) * (-(r5.y)) + (r0.x);
    r6.y = (r0.y) + (r0.y);
    r1.xyz = (v5.xyz) * (-(r6.www)) + (c[17].xyz);
    r0.y = (r0.z) + (r0.z);
    r10.xyz = normalize(r1.xyz);
    r1.z = saturate((r0.w) * (c3.z) + (c3.w));
    r0.w = saturate(dot(r10.xyz, c[17].xyz));
    r6.xz = (r4.xy) * (c3.xx);
    r0.w = (-(r0.w)) + (c0.y);
    r0.xz = (r3.xy) * (c3.xx);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r1.zzz) + (r6.xyz);
    r1.w = (r1.w) * (r1.w);
    r7.xyz = (r0.xyz) * (c[36].yyy);
    r5.w = (r0.w) * (r1.w);
    r0 = tex2D(s12, v1.zw);
    r9.xyz = normalize(v2.xyz);
    r7.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.z));
    r5.xyz = (r7.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r3.w = r0.w;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r1 = (v4.xyzx) * (c1.xxxz);
            r0 = (r1) + (-(c12.xyzz));
            r0 = tex2Dlod(s1, r0);
            r0.w = r0.x;
            r2 = (r1) + (c4.xxyy);
            r2 = tex2Dlod(s1, r2);
            r0.x = r2.x;
            r2 = (r1) + (c4.zzyy);
            r2 = tex2Dlod(s1, r2);
            r0.y = r2.x;
            r1 = (r1) + (c12.xyzz);
            r1 = tex2Dlod(s1, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c13.zzzz);
            if ((c13.w) < (v4.w))
            {
                r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c4.xx);
                r0.zw = (v4.zx) * (c1.xz);
                r0 = tex2Dlod(s1, r0);
                r1.xy = (r4.xy) + (c4.zz);
                r1.zw = (v4.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (c12.xy);
                r1.zw = (v4.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r1);
                r1.xy = (r4.xy) + (-(c12.xy));
                r1.zw = (v4.zx) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c13.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v4.w) * (c14.x) + (c14.y);
                r3.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r3.w = r4.w;
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c3.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r8.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r8.xy) + (c4.xx);
                r1.zw = (v4.zz) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r8.xy) + (c4.zz);
                r2.zw = (v4.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r8.xy) + (c12.xy);
                r2.zw = (v4.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r8.xy) + (-(c12.xy));
                r2.zw = (v4.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c13.zzzz);
                r0.w = saturate((v4.w) + (c4.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r3.w = r0.w;
        }
    }
    r0.xyz = (-(v5.xyz)) + (c[20].xyz);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = (r6.www) * (v5.xyz);
    r2.xyz = (r0.xyz) * (r0.www) + (-(r3.xyz));
    r1.xyz = normalize(r2.xyz);
    r11.xyz = (r0.xyz) * (r0.www);
    r0.w = saturate(dot(r1.xyz, r11.xyz));
    r1.w = (-(r0.w)) + (c0.y);
    r0.w = (r1.w) * (r1.w);
    r2.xyz = (r3.www) * (r5.xyz) + (r7.xyz);
    r2.w = (r0.w) * (r0.w);
    r0 = tex2D(s4, v6.xy);
    r4.xyz = (r0.xyz) + (c0.xxx);
    r0 = tex2D(s5, v6.zw);
    r0.xyz = (r0.xyz) + (c0.xxx);
    r7.xyz = (v0.yyy) * (r4.xyz) + (c0.yyy);
    r5.xyz = (v0.zzz) * (r0.xyz) + (c0.yyy);
    r0 = tex2D(s6, v1.xy);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r2.w = (r1.w) * (r2.w);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r4.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r8.xyz = (r0.xyz) * (r0.xyz);
    r1.w = dot(r11.xyz, c[29].xyz);
    r0.xyz = (r4.xyz) * (r2.www) + (r8.xyz);
    r10.w = (r0.w) * (-(c0.w)) + (c0.y);
    r11.w = (r0.w) * (c0.w);
    r2.w = saturate(dot(r11.xyz, r9.xyz));
    r4.w = saturate(dot(r9.xyz, -(r3.xyz)));
    r6.w = (r2.w) * (r10.w) + (r11.w);
    r8.w = (r4.w) * (r10.w) + (r11.w);
    r6.w = (r6.w) * (r8.w) + (c13.x);
    r4.w = (-(r4.w)) + (c0.y);
    r9.w = 1.0f / (r6.w);
    r6.w = (r4.w) * (r4.w);
    r12.w = (r2.w) * (r9.w);
    r4.w = (r4.w) * (r6.w);
    r11.z = dot(r3.xyz, r9.xyz);
    r11.xy = (r0.ww) * (c15.xy) + (c15.zw);
    r6.w = saturate(dot(r9.xyz, r1.xyz));
    r9.w = exp2(r11.y);
    r1.z = pow(abs(r6.w), r9.w);
    r6.w = (r9.w) * (c13.y) + (c13.z);
    r11.z = (r11.z) + (r11.z);
    r1.z = (r1.z) * (r6.w);
    r1.y = 1.0f / (r11.x);
    r1.z = (r12.w) * (r1.z);
    r4.w = (r4.w) * (r1.y);
    r1.xyz = (r0.xyz) * (r1.zzz);
    r0.w = (r0.w) * (c0.z);
    r0.xyz = (r9.xyz) * (-(r11.zzz)) + (r3.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r0.xyz) * (c[36].xxx);
    r0.w = (r7.w) * (r10.w) + (r11.w);
    r0.w = (r0.w) * (r8.w) + (c13.x);
    r8.w = saturate(dot(r9.xyz, r10.xyz));
    r0.z = 1.0f / (r0.w);
    r0.w = pow(abs(r8.w), r9.w);
    r0.z = (r7.w) * (r0.z);
    r0.w = (r6.w) * (r0.w);
    r0.w = (r0.z) * (r0.w);
    r0.xyz = (r4.xyz) * (r5.www) + (r8.xyz);
    r4.xyz = (r4.xyz) * (r4.www) + (r8.xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r4.xyz = (r3.xyz) * (r4.xyz);
    r3.xyz = (r0.xyz) * (c[36].www);
    r0 = tex2D(s0, v1.xy);
    r0.xyz = (r7.xyz) * (r0.xyz);
    r3.xyz = (r3.xyz) * (c[19].xyz);
    r0.xyz = (r5.xyz) * (r0.xyz);
    r3.xyz = (r3.www) * (r3.xyz);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r6.xyz) * (r4.xyz);
    r2.xyz = (r5.xyz) * (r2.xyz) + (r3.xyz);
    r7.xyz = (r0.xyz) * (c0.zzz) + (r2.xyz);
    r0.xyz = (r1.xyz) * (c[22].xyz);
    r2.xyz = (r0.xyz) * (c[36].www);
    r0 = (v5.yyyy) * (c[32]);
    r1.xyz = (r2.www) * (c[21].xyz);
    r0 = (v5.xxxx) * (c[31]) + (r0);
    r6.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0 = (v5.zzzz) * (c[33]) + (r0);
    r1.w = saturate((r1.w) * (c[30].x) + (c[30].y));
    r3 = (r0) + (c[34]);
    r0.z = (r1.w) * (c14.z) + (c14.w);
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
    r0 = (v5.xyzx) * (c1.xxxz) + (c1.zzzx);
    r5.w = dot(r1, c13.zzzz);
    r1.w = dot(r0, c[28]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c14.zz) + (c14.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c0.y);
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r6.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (c1.yy) + (c1.yy);
    r4 = tex2D(s3, r0.xy);
    r3 = (-(v5.yyyy)) + (c[6]);
    r2 = (-(v5.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[7]);
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
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
