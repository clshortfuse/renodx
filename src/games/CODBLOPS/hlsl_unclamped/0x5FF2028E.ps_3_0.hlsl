// Mechanically reconstructed from 0x5FF2028E.ps_3_0.cso.
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
    const float4 c1 = float4(0.600000024f, 0.400000006f, 8.0f, 0.797884583f);
    const float4 c3 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c4 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c12 = float4(1.0f, -1.0f, 0.200000003f, 0.0f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c15 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    float4 oC0 = 0.0f;

    r1 = tex2D(s7, v1.xy);
    r0 = tex2D(s5, v8.xy);
    r1.z = (r0.w) * (v0.y);
    r11.w = (r1.w) * (-(c4.z)) + (c4.w);
    r7.w = lerp(r1.y, c12.x, r1.z);
    r2 = tex2D(s1, v1.xy);
    r1.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s0, v1.xy);
    r1.xy = (r1.zz) * (-(r1.xy)) + (r1.xy);
    r0.w = dot(r1.xy, r1.xy) + (c12.w);
    r8.xyz = lerp(r2.xyz, r0.xyz, r1.zzz);
    r0.w = exp2(-(r0.w));
    r4.w = (r0.w) * (c1.x) + (c1.y);
    r0.w = dot(v7.xyz, v7.xyz);
    r8.w = rsqrt(r0.w);
    r0.xy = (v1.zw) * (c3.xy);
    r3 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c3.xy) + (c3.zy);
    r0 = tex2D(s13, r0.xy);
    r3.w = r0.y;
    r2 = tex2D(s14, v1.zw);
    r5.xy = (r2.xy) * (c3.ww);
    r6.xy = (r3.yw) * (c4.xx) + (c4.yy);
    r3.xy = (r3.xz) * (r5.xx);
    r0.w = dot(r6.xy, r1.xy) + (c12.w);
    r0.y = (r2.x) * (c3.w) + (-(r3.x));
    r1.z = (r3.z) * (-(r5.x)) + (r0.y);
    r4.xy = (r0.xz) * (r5.yy);
    r0.y = (r2.y) * (c3.w) + (-(r4.x));
    r0.x = dot(r6.xy, r6.xy) + (c12.w);
    r0.y = (r0.z) * (-(r5.y)) + (r0.y);
    r0.z = exp2(-(r0.x));
    r7.y = (r1.z) + (r1.z);
    r0.z = (r0.z) * (c1.x) + (c1.y);
    r0.y = (r0.y) + (r0.y);
    r0.z = (r4.w) * (r0.z);
    r0.w = saturate((r0.w) * (r0.z) + (r0.z));
    r0.xz = (r4.xy) * (c4.xx);
    r2.xyz = (r0.xyz) * (r0.www);
    r0 = v2;
    r0.xyz = (r1.xxx) * (v5.xyz) + (r0.xyz);
    r7.xz = (r3.xy) * (c4.xx);
    r1.xyz = (r1.yyy) * (v4.xyz) + (r0.xyz);
    r0.xyz = (r7.xyz) * (r4.www) + (r2.xyz);
    r9.xyz = normalize(r1.xyz);
    r11.xyz = (r7.www) * (r0.xyz);
    r10.w = saturate(dot(r9.xyz, c[17].xyz));
    r2 = tex2D(s12, v1.zw);
    r0.z = ((-abs(r2.y)) >= 0.0f ? (c12.x) : (c12.w));
    r10.xyz = (r10.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r2.y;
        r5.w = r0.z;
    }
    else
    {
        if ((c12.x) >= (v6.w))
        {
            r3 = (v6.xyzx) * (c12.xxxw);
            r2 = (r3) + (-(c14.xyzz));
            r2 = tex2Dlod(s2, r2);
            r2.w = r2.x;
            r4 = (r3) + (c13.xxyy);
            r4 = tex2Dlod(s2, r4);
            r2.x = r4.x;
            r4 = (r3) + (c13.zzyy);
            r4 = tex2Dlod(s2, r4);
            r2.y = r4.x;
            r3 = (r3) + (c14.xyzz);
            r3 = tex2Dlod(s2, r3);
            r2.z = r3.x;
            r0.z = dot(r2, c15.zzzz);
            if ((c15.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c13.xx);
                r2.zw = (v6.zx) * (c12.xw);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c13.zz);
                r3.zw = (v6.zx) * (c12.xw);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c14.xy);
                r3.zw = (v6.zx) * (c12.xw);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c14.xy));
                r3.zw = (v6.zx) * (c12.xw);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.y = dot(r2, c15.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c16.x) + (c16.y);
                r5.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r5.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.x));
            r0.z = ((r0.z) >= 0.0f ? (c12.w) : (c12.x));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r3.xy = (r0.xy) + (c13.xx);
                r3.zw = (v6.zz) * (c12.xw);
                r3 = tex2Dlod(s2, r3);
                r4.xy = (r0.xy) + (c13.zz);
                r4.zw = (v6.zz) * (c12.xw);
                r6 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (c14.xy);
                r4.zw = (v6.zz) * (c12.xw);
                r5 = tex2Dlod(s2, r4);
                r4.xy = (r0.xy) + (-(c14.xy));
                r4.zw = (v6.zz) * (c12.xw);
                r4 = tex2Dlod(s2, r4);
                r3.y = r6.x;
                r3.z = r5.x;
                r3.w = r4.x;
                r0.x = dot(r3, c15.zzzz);
                r0.z = saturate((v6.w) + (c13.w));
                r0.y = (r2.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r2.y;
            }
            r5.w = r0.z;
        }
    }
    r2.xyz = (-(v7.xyz)) + (c[20].xyz);
    r0.z = dot(r2.xyz, r2.xyz);
    r2.w = rsqrt(r0.z);
    r1.xyz = (r8.www) * (v7.xyz);
    r3.xyz = (r2.xyz) * (r2.www) + (-(r1.xyz));
    r0.xyz = normalize(r3.xyz);
    r2.xyz = (r2.xyz) * (r2.www);
    r2.w = saturate(dot(r0.xyz, r2.xyz));
    r2.w = (-(r2.w)) + (c12.x);
    r3.xyz = (r5.www) * (r10.xyz) + (r11.xyz);
    r4.w = (r2.w) * (r2.w);
    r3.w = dot(r2.xyz, c[29].xyz);
    r4.w = (r4.w) * (r4.w);
    r4.z = (r2.w) * (r4.w);
    r10.x = (r1.w) * (c1.w);
    r4.w = saturate(dot(r2.xyz, r9.xyz));
    r2.w = saturate(dot(r9.xyz, -(r1.xyz)));
    r2.z = (r4.w) * (r11.w) + (r10.x);
    r10.y = (r2.w) * (r11.w) + (r10.x);
    r2.z = (r2.z) * (r10.y) + (c15.x);
    r2.w = (-(r2.w)) + (c12.x);
    r2.y = 1.0f / (r2.z);
    r2.z = (r2.w) * (r2.w);
    r4.x = (r4.w) * (r2.y);
    r2.w = (r2.w) * (r2.z);
    r2.z = dot(r1.xyz, r9.xyz);
    r2.xy = (r1.ww) * (c37.xy) + (c37.zw);
    r11.z = (r2.z) + (r2.z);
    r2.z = 1.0f / (r2.x);
    r10.z = exp2(r2.y);
    r2.y = saturate(dot(r9.xyz, r0.xyz));
    r0.z = pow(abs(r2.y), r10.z);
    r9.w = (r10.z) * (c15.y) + (c15.z);
    r6.w = (r2.w) * (r2.z);
    r4.y = (r0.z) * (r9.w);
    r2 = tex2D(s6, v8.zw);
    r0.xyz = (r2.xyz) + (c12.yyy);
    r2.w = (r4.x) * (r4.y);
    r2.xyz = (v0.zzz) * (r0.xyz) + (c12.xxx);
    r0.xyz = (r8.xyz) * (r2.xyz);
    r2.xyz = (r2.xyz) * (c12.zzz);
    r5.xyz = (r2.xyz) * (-(r2.xyz)) + (c12.xxx);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r5.xyz) * (r4.zzz) + (r6.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r1.w) * (c1.z);
    r1.xyz = (r9.xyz) * (-(r11.zzz)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r8.xyz = (v7.xyz) * (-(r8.www)) + (c[17].xyz);
    r2.xyz = normalize(r8.xyz);
    r1.w = saturate(dot(r2.xyz, c[17].xyz));
    r1.w = (-(r1.w)) + (c12.x);
    r8.w = (r1.w) * (r1.w);
    r8.w = (r8.w) * (r8.w);
    r8.w = (r1.w) * (r8.w);
    r1.w = (r10.w) * (r11.w) + (r10.x);
    r1.w = (r1.w) * (r10.y) + (c15.x);
    r2.y = saturate(dot(r9.xyz, r2.xyz));
    r2.z = 1.0f / (r1.w);
    r1.w = pow(abs(r2.y), r10.z);
    r2.z = (r10.w) * (r2.z);
    r1.w = (r9.w) * (r1.w);
    r1.w = (r2.z) * (r1.w);
    r2.xyz = (r5.xyz) * (r8.www) + (r6.xyz);
    r2.xyz = (r1.www) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r2.xyz = (r7.www) * (r2.xyz);
    r1.xyz = (r7.www) * (r1.xyz);
    r2.xyz = (r2.xyz) * (c[19].xyz);
    r5.xyz = (r5.xyz) * (r6.www) + (r6.xyz);
    r2.xyz = (r5.www) * (r2.xyz);
    r1.xyz = (r1.xyz) * (r5.xyz);
    r3.xyz = (r0.xyz) * (r3.xyz) + (r2.xyz);
    r2.xyz = (r7.xyz) * (r1.xyz);
    r1.xyz = (r2.www) * (r4.xyz);
    r7.xyz = (r2.xyz) * (c1.zzz) + (r3.xyz);
    r1.xyz = (r1.xyz) * (c[22].xyz);
    r3.xyz = (r7.www) * (r1.xyz);
    r1 = (v7.yyyy) * (c[32]);
    r2.xyz = (r4.www) * (c[21].xyz);
    r1 = (v7.xxxx) * (c[31]) + (r1);
    r6.xyz = (r0.xyz) * (r2.xyz) + (r3.xyz);
    r1 = (v7.zzzz) * (c[33]) + (r1);
    r2.w = saturate((r3.w) * (c[30].x) + (c[30].y));
    r4 = (r1) + (c[34]);
    r1.z = (r2.w) * (c16.z) + (c16.w);
    r3.zw = r4.zw;
    r1.w = (r2.w) * (r2.w);
    r5.zw = r3.zw;
    r4.z = (r1.z) * (r1.w);
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
    r1 = (v7.xyzx) * (c12.xxxw) + (c12.wwwx);
    r6.w = dot(r2, c15.zzzz);
    r2.w = dot(r1, c[28]);
    r2.w = 1.0f / (r2.w);
    r3.x = dot(r1, c[27]);
    r2.x = dot(r1, c[25]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[26]);
    r1.w = dot(c[23].yz, r3.xy) + (c[23].x);
    r1.z = saturate(1.0f / (r1.w));
    r1.xy = saturate((r3.xx) * (c[24].xy) + (c[24].zw));
    r3.xy = (r1.xy) * (c16.zz) + (c16.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c12.w) : (r1.z));
    r1.z = (r3.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = (r1.y) * (-(r3.y)) + (c12.x);
    r1.xy = (r2.ww) * (r2.xy);
    r1.w = (r1.w) * (r1.z);
    r7.w = (r4.z) * (r1.w);
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
    r3.w = c12.x;
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
    oC0.w = c12.x;

    return oC0;
}
