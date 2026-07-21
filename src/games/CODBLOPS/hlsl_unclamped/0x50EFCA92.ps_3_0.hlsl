// Mechanically reconstructed from 0x50EFCA92.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s3 : register(s3);
samplerCUBE s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    centroid float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : COLOR0;
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
    const float4 c1 = float4(0.0185589511f, 0.0155677656f, 0.00873362459f, 0.00732600736f);
    const float4 c3 = float4(9.99999975e-06f, 1.0f, 0.5f, 0.0f);
    const float4 c4 = float4(-9.25f, -4.625f, 10.0f, 5.0f);
    const float4 c12 = float4(31.875f, 4.0f, 0.25f, 0.5f);
    const float4 c13 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c15 = float4(4.0f, -3.0f, -1.44269502f, -9.99999975e-05f);
    const float4 c16 = float4(64.0f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s12, v0.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c3.y) : (c3.w));
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r5.w = r0.w;
    }
    else
    {
        if ((c3.y) >= (v6.w))
        {
            r1 = (v6.xyzx) * (c3.yyyw);
            r0 = (r1) + (-(c14.xyzz));
            r0 = tex2Dlod(s3, r0);
            r0.w = r0.x;
            r2 = (r1) + (c13.xxyy);
            r2 = tex2Dlod(s3, r2);
            r0.x = r2.x;
            r2 = (r1) + (c13.zzyy);
            r2 = tex2Dlod(s3, r2);
            r0.y = r2.x;
            r1 = (r1) + (c14.xyzz);
            r1 = tex2Dlod(s3, r1);
            r0.z = r1.x;
            r5.w = dot(r0, c12.zzzz);
            if ((c13.w) < (v6.w))
            {
                r4.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c13.xx);
                r0.zw = (v6.zx) * (c3.yw);
                r0 = tex2Dlod(s3, r0);
                r1.xy = (r4.xy) + (c13.zz);
                r1.zw = (v6.zx) * (c3.yw);
                r3 = tex2Dlod(s3, r1);
                r1.xy = (r4.xy) + (c14.xy);
                r1.zw = (v6.zx) * (c3.yw);
                r2 = tex2Dlod(s3, r1);
                r1.xy = (r4.xy) + (-(c14.xy));
                r1.zw = (v6.zx) * (c3.yw);
                r1 = tex2Dlod(s3, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c12.zzzz);
                r0.z = (-(r5.w)) + (r0.w);
                r0.w = (v6.w) * (c15.x) + (c15.y);
                r5.w = (r0.w) * (r0.z) + (r5.w);
            }
        }
        else
        {
            r0.w = (v6.w) + (-(c12.y));
            r0.w = ((r0.w) >= 0.0f ? (c3.w) : (c3.y));
            if ((r0.w) != (-(r0.w)))
            {
                r5.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c13.xx);
                r1.zw = (v6.zz) * (c3.yw);
                r1 = tex2Dlod(s3, r1);
                r2.xy = (r5.xy) + (c13.zz);
                r2.zw = (v6.zz) * (c3.yw);
                r4 = tex2Dlod(s3, r2);
                r2.xy = (r5.xy) + (c14.xy);
                r2.zw = (v6.zz) * (c3.yw);
                r3 = tex2Dlod(s3, r2);
                r2.xy = (r5.xy) + (-(c14.xy));
                r2.zw = (v6.zz) * (c3.yw);
                r2 = tex2Dlod(s3, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c12.zzzz);
                r0.w = saturate((v6.w) + (c14.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r5.w = r0.w;
        }
    }
    r1 = tex2D(s1, v3.xy);
    r1.x = r1.w;
    r0 = tex2D(s1, v3.zw);
    r1.zw = r0.wy;
    r0 = tex2D(s0, v2.zw);
    r0.zw = r0.wy;
    r2 = tex2D(s0, v2.xy);
    r0.xy = r2.wy;
    r1 = (r1) * (c[25].zzzz) + (c[25].wwww);
    r0 = (r0) * (c[25].xxxx) + (c[25].yyyy);
    r0 = (r1) + (r0);
    r3.x = c[10].w;
    r1.xy = (r3.xx) * (c1.xy);
    r1.x = (v0.x) * (c1.z) + (r1.x);
    r2.y = (v0.y) * (c1.w) + (r1.y);
    r1.y = (v0.y) * (c1.w);
    r2.x = (v0.x) * (c1.z);
    r1 = tex2D(s6, r1.xy);
    r2 = tex2D(s6, r2.xy);
    r1 = (r1) * (r2) + (c3.xxxx);
    r6.xy = (r0.zw) + (r0.xy);
    r0.w = dot(r1, c3.yyyy);
    r0.y = 1.0f / (r0.w);
    r0.zw = (v0.yx) * (c[27].zw);
    r2 = (r1) * (r0.yyyy);
    r4.zw = (v0.yx) * (c[27].xy);
    r3 = (r3.xxxx) * (c[28]);
    r0.xy = (v0.xy) * (c[27].zw) + (r3.zw);
    r1 = tex2D(s5, r0.xz);
    r0 = tex2D(s5, r0.wy);
    r4.xy = (v0.xy) * (c[27].xy) + (r3.xy);
    r3 = tex2D(s5, r4.xz);
    r4 = tex2D(s5, r4.wy);
    r3.y = r4.x;
    r3.z = r1.x;
    r3.w = r0.x;
    r0.xy = (v0.zw) * (c3.yz);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v0.zw);
    r7.xy = (r1.xy) * (c12.xx);
    r0.w = dot(r2, r3);
    r0.xy = (r0.xz) * (r7.xx);
    r3.w = log2(abs(r0.w));
    r0.w = (r1.x) * (c12.x) + (-(r0.x));
    r1.w = dot(v1.xyz, v1.xyz);
    r0.w = (r0.z) * (-(r7.x)) + (r0.w);
    r6.w = rsqrt(r1.w);
    r4.y = (r0.w) + (r0.w);
    r4.xz = (r0.xy) * (c12.yy);
    r0.xy = (v0.zw) * (c3.yz) + (c3.wz);
    r0 = tex2D(s13, r0.xy);
    r2.xyz = v4.xyz;
    r3.xyz = (r2.zxy) * (v5.yzx);
    r5.xyz = (r2.yzx) * (v5.zxy) + (-(r3.xyz));
    r1.xz = (r7.yy) * (r0.xz);
    r2.xyz = (r6.xxx) * (v4.xyz) + (r5.xyz);
    r0.w = (r1.y) * (c12.x) + (-(r1.x));
    r6.xyz = (r6.yyy) * (v5.xyz) + (r2.xyz);
    r3.xyz = (r6.www) * (v1.xyz);
    r2.xyz = normalize(r6.xyz);
    r0.z = (r0.z) * (-(r7.y)) + (r0.w);
    r0.w = saturate(dot(r2.xyz, -(r3.xyz)));
    r1.y = (r0.z) * (c3.z);
    r1.w = (-(r0.w)) + (c3.y);
    r4.xyz = (r4.xyz) + (r1.xyz);
    r0.w = (r1.w) * (r1.w);
    r0.xyz = normalize(r5.xyz);
    r0.w = (r0.w) * (r0.w);
    r2.w = saturate(dot(c[17].xyz, r0.xyz));
    r0.w = (r1.w) * (r0.w);
    r1.w = dot(c[7].xyz, r3.xyz);
    r7.w = (c[20].w) * (r0.w) + (c[20].z);
    r0.w = dot(r3.xyz, r2.xyz);
    r0.xy = (v7.zz) * (c4.xy) + (c4.zw);
    r0.w = (r0.w) + (r0.w);
    r0.xy = (r3.ww) * (r0.xy);
    r4.w = saturate(dot(r2.xyz, c[17].xyz));
    r7.x = exp2(r0.x);
    r7.y = exp2(r0.y);
    r0.xyz = c[22].xyz;
    r0.xyz = (-(r0.xyz)) + (c[23].xyz);
    r1.xyz = (r5.www) * (c[18].xyz);
    r0.xyz = (r7.yyy) * (r0.xyz) + (c[22].xyz);
    r5.xyz = (r1.xyz) * (r4.www) + (r4.xyz);
    r0.xyz = (r0.xyz) * (r5.xyz);
    r3.w = dot(r4.xzy, c12.zzw);
    r1.xyz = (r1.xyz) * (r2.www) + (r3.www);
    r2.w = 1.0f / (r6.w);
    r4.z = (-(r7.w)) + (c3.y);
    r3.w = saturate((r2.w) * (c[24].w));
    r5.xyz = (r0.xyz) * (r4.zzz);
    r0.z = (r3.w) * (c15.z);
    r3.w = exp2(r0.z);
    r6.xyz = (r1.xyz) * (c[24].xyz);
    r0.xyz = (r2.xyz) * (-(r0.www)) + (r3.xyz);
    r4.xyz = lerp(r6.xyz, r5.xyz, r3.www);
    r0 = texCUBE(s4, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.xyz = (r7.xxx) * (r1.xyz);
    r0.xyz = (r0.xyz) * (c[26].xyz);
    r0.w = (r3.w) * (r3.w);
    r0.xyz = (r7.www) * (r0.xyz);
    r1.xyz = (r0.www) * (r1.xyz) + (r4.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r0.w = (-(r7.x)) + (c3.y);
    r4.xyz = (v1.xyz) * (-(r6.www)) + (c[17].xyz);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0.xyz = normalize(r4.xyz);
    r3.z = saturate(dot(r0.xyz, -(r3.xyz)));
    r0.w = saturate(dot(r0.xyz, c[17].xyz));
    r3.z = (r3.z) * (c12.y);
    r0.w = (-(r0.w)) + (c3.y);
    r3.z = 1.0f / (r3.z);
    r3.y = (r0.w) * (r0.w);
    r3.y = (r3.y) * (r3.y);
    r0.z = saturate(dot(r2.xyz, r0.xyz));
    r0.w = (r0.w) * (r3.y);
    r0.z = log2(abs(r0.z));
    r0.w = (c[20].w) * (r0.w) + (c[20].z);
    r0.xy = (r0.zz) * (c[20].xy);
    r0.w = (r4.w) * (r0.w);
    r0.x = exp2(r0.x);
    r0.y = exp2(r0.y);
    r0.z = (r3.z) * (r0.w);
    r0.w = c3.w;
    r0.w = dot(r0.xy, c[21].xy) + (r0.w);
    r0.w = (r0.z) * (r0.w);
    r2.z = (c[5].w) * (v1.z) + (c[5].x);
    r2.x = (r0.w) * (c[23].w);
    r0.w = min(r2.z, c16.x);
    r0.xyz = (r5.www) * (c[19].xyz);
    r0.w = (r0.w) * (-(c15.z));
    r3.y = exp2(r0.w);
    r2.y = (v1.z) * (c[5].w);
    r3.z = (r2.z) + (c3.y);
    r0.w = (abs(r2.y)) + (c15.w);
    r2.z = ((r2.z) >= 0.0f ? (r3.z) : (r3.y));
    r2.y = ((r0.w) >= 0.0f ? (r2.y) : (c3.y));
    r2.z = (r2.z) + (-(c[6].x));
    r2.y = 1.0f / (r2.y);
    r2.z = (r2.z) * (r2.y);
    r2.y = saturate(c[6].x);
    r0.xyz = (r2.xxx) * (r0.xyz);
    r0.w = ((r0.w) >= 0.0f ? (r2.z) : (r2.y));
    r1.xyz = (r0.xyz) * (r3.www) + (r1.xyz);
    r0.w = (r0.w) * (c[5].y);
    r1.w = saturate((c[9].y) * (r1.w) + (c[9].x));
    r0.w = (r0.w) * (r2.w) + (c[5].z);
    r0.w = saturate(exp2(r0.w));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[8].xyz);
    r0.w = (-(r0.w)) + (c3.y);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r0.w = (r0.w) * (c[8].w);
    r0.xyz = (r0.xyz) * (c[0].www) + (-(r1.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.y;

    return oC0;
}
