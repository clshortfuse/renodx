// Mechanically reconstructed from 0xEA057574.ps_3_0.cso.
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
    float4 v0 : TEXCOORD0;
    centroid float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD6;
    float4 v5 : COLOR0;
    float2 vPosInput : VPOS;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, 0.25f, 0.5f, 0.75f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0450000018f);
    const float4 c13 = float4(4.0f, -3.0f, 10.0f, -1.44269502f);
    const float4 c14 = float4(8.0f, -9.99999975e-05f, 64.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 r8 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s0, v2.xy);
    r0.x = r0.w;
    r1 = tex2D(s0, v2.zw);
    r0.zw = r1.wy;
    r1 = tex2D(s1, v3.xy);
    r1.x = r1.w;
    r2 = tex2D(s1, v3.zw);
    r1.zw = r2.wy;
    r0 = (r0) * (c[25].xxxx) + (c[25].yyyy);
    r1 = (r1) * (c[25].zzzz) + (c[25].wwww);
    r0 = (r0) + (r1);
    r0.xy = (r0.zw) + (r0.xy);
    r0.z = c1.x;
    r1.w = dot(v1.xyz, v1.xyz);
    r0.w = dot(r0.xyz, r0.xyz);
    r7.w = rsqrt(r1.w);
    r5.z = rsqrt(r0.w);
    r5.w = 1.0f / (r7.w);
    r5.xy = (r0.xy) * (r5.zz);
    r0 = tex2D(s12, v0.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c1.x) : (c1.z));
    r6.xyz = (r7.www) * (v1.xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
        r4.w = r0.w;
    }
    else
    {
        if ((c1.x) >= (v4.w))
        {
            r1 = (v4.xyzx) * (c1.xxxz);
            r0 = (r1) + (-(c12.xyzz));
            r0 = tex2Dlod(s3, r0);
            r0.w = r0.x;
            r2 = (r1) + (c4.xxyy);
            r2 = tex2Dlod(s3, r2);
            r0.x = r2.x;
            r2 = (r1) + (c4.zzyy);
            r2 = tex2Dlod(s3, r2);
            r0.y = r2.x;
            r1 = (r1) + (c12.xyzz);
            r1 = tex2Dlod(s3, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c3.yyyy);
            if ((c3.w) < (v4.w))
            {
                r4.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c4.xx);
                r0.zw = (v4.zx) * (c1.xz);
                r0 = tex2Dlod(s3, r0);
                r1.xy = (r4.xy) + (c4.zz);
                r1.zw = (v4.zx) * (c1.xz);
                r3 = tex2Dlod(s3, r1);
                r1.xy = (r4.xy) + (c12.xy);
                r1.zw = (v4.zx) * (c1.xz);
                r2 = tex2Dlod(s3, r1);
                r1.xy = (r4.xy) + (-(c12.xy));
                r1.zw = (v4.zx) * (c1.xz);
                r1 = tex2Dlod(s3, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c3.yyyy);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v4.w) * (c13.x) + (c13.y);
                r4.w = (r0.w) * (r0.z) + (r4.w);
            }
        }
        else
        {
            r0.w = (v4.w) + (-(c3.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r7.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r7.xy) + (c4.xx);
                r1.zw = (v4.zz) * (c1.xz);
                r1 = tex2Dlod(s3, r1);
                r2.xy = (r7.xy) + (c4.zz);
                r2.zw = (v4.zz) * (c1.xz);
                r4 = tex2Dlod(s3, r2);
                r2.xy = (r7.xy) + (c12.xy);
                r2.zw = (v4.zz) * (c1.xz);
                r3 = tex2Dlod(s3, r2);
                r2.xy = (r7.xy) + (-(c12.xy));
                r2.zw = (v4.zz) * (c1.xz);
                r2 = tex2Dlod(s3, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c3.yyyy);
                r0.w = saturate((v4.w) + (c4.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
            r4.w = r0.w;
        }
    }
    r0.w = dot(r6.xyz, r5.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r5.xyz) * (-(r0.www)) + (r6.xyz);
    r0 = texCUBE(s15, r0.xyz);
    r3.w = saturate(dot(r5.xyz, -(r6.xyz)));
    r1.w = (-(r3.w)) + (c1.x);
    r0.w = (r1.w) * (r1.w);
    r0.w = (r0.w) * (r0.w);
    r3.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r1.w) * (r0.w);
    r8.w = (c[20].w) * (r0.w) + (c[20].z);
    r0.xy = (v0.zw) * (c1.xy);
    r2 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v0.zw);
    r4.xy = (r1.xy) * (c1.ww);
    r1.w = (-(r8.w)) + (c1.x);
    r2.xy = (r2.xz) * (r4.xx);
    r2.w = (r1.x) * (c1.w) + (-(r2.x));
    r0.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r1.xz = (r4.yy) * (r0.xz);
    r0.y = (r2.z) * (-(r4.x)) + (r2.w);
    r0.w = (r1.y) * (c1.w) + (-(r1.x));
    r0.y = (r0.y) + (r0.y);
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r0.xz = (r2.xy) * (c3.xx);
    r1.y = (r0.w) * (c1.y);
    r6.w = saturate(dot(r5.xyz, c[17].xyz));
    r4.xyz = (r1.xyz) + (r0.xyz);
    r2.w = dot(r4.xzy, c3.yyz);
    r0.xyz = c[22].xyz;
    r0.xyz = (-(r0.xyz)) + (c[23].xyz);
    r1.xyz = (r3.www) * (r0.xyz) + (c[22].xyz);
    r0.xyz = (r4.www) * (c[18].xyz);
    r2.xyz = (r0.xyz) * (r6.www) + (r4.xyz);
    r0.w = saturate(c[17].z);
    r1.xyz = (r1.xyz) * (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (r2.www);
    r1.xyz = (r1.www) * (r1.xyz);
    r7.xyz = (r0.xyz) * (c[24].xyz);
    r0.xy = (vPos.xy) * (c[10].zw);
    r0.zw = c1.zx;
    r0 = tex2Dproj(s4, r0);
    r0.z = (abs(r0.x)) + (-(v1.w));
    r0.w = saturate((r5.w) * (c[24].w));
    r1.w = saturate((r0.z) * (c12.w));
    r0.z = (r0.w) * (c13.w);
    r0.w = rsqrt(r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xy = (r5.xy) * (c13.zz);
    r3.w = exp2(r0.z);
    r0.xy = (r0.xy) * (r0.ww) + (vPos.xy);
    r2.xyz = lerp(r7.xyz, r1.xyz, r3.www);
    r0.xy = (r0.xy) * (c[10].zw);
    r0 = tex2D(s2, r0.xy);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[11].x);
    r0.z = (v5.w) * (c[22].w);
    r2.xyz = (r1.xyz) * (-(r0.www)) + (r2.xyz);
    r2.w = (r1.w) * (r0.z);
    r0.xyz = (r3.xyz) * (r4.xyz);
    r2.xyz = (r2.xyz) * (r2.www);
    r2.xyz = (r1.xyz) * (r0.www) + (r2.xyz);
    r0.xyz = (r8.www) * (r0.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r3.xyz = (v1.xyz) * (-(r7.www)) + (c[17].xyz);
    r1.xyz = (r1.www) * (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r1.xyz = (r1.xyz) * (c14.xxx) + (r2.xyz);
    r0.w = saturate(dot(r0.xyz, c[17].xyz));
    r2.w = dot(c[7].xyz, r6.xyz);
    r0.w = (-(r0.w)) + (c1.x);
    r2.z = saturate(dot(r0.xyz, -(r6.xyz)));
    r2.y = (r0.w) * (r0.w);
    r2.z = (r2.z) * (c3.x);
    r2.y = (r2.y) * (r2.y);
    r2.z = 1.0f / (r2.z);
    r0.w = (r0.w) * (r2.y);
    r2.y = (c[20].w) * (r0.w) + (c[20].z);
    r0.w = saturate(dot(r5.xyz, r0.xyz));
    r0.z = (r6.w) * (r2.y);
    r0.w = log2(abs(r0.w));
    r2.y = (r2.z) * (r0.z);
    r0.xy = (r0.ww) * (c[20].xy);
    r0.x = exp2(r0.x);
    r0.y = exp2(r0.y);
    r0.z = (c[5].w) * (v1.z) + (c[5].x);
    r0.w = c1.z;
    r0.w = dot(r0.xy, c[21].xy) + (r0.w);
    r2.z = min(r0.z, c14.z);
    r0.x = (r2.y) * (r0.w);
    r0.w = (r2.z) * (-(c13.w));
    r2.y = exp2(r0.w);
    r0.y = (v1.z) * (c[5].w);
    r2.z = (r0.z) + (c1.x);
    r0.w = (abs(r0.y)) + (c14.y);
    r0.z = ((r0.z) >= 0.0f ? (r2.z) : (r2.y));
    r0.y = ((r0.w) >= 0.0f ? (r0.y) : (c1.x));
    r0.z = (r0.z) + (-(c[6].x));
    r0.y = 1.0f / (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = saturate(c[6].x);
    r2.z = (r0.x) * (c[23].w);
    r0.w = ((r0.w) >= 0.0f ? (r0.z) : (r0.y));
    r0.xyz = (r4.www) * (c[19].xyz);
    r0.w = (r0.w) * (c[5].y);
    r0.xyz = (r2.zzz) * (r0.xyz);
    r0.w = (r0.w) * (r5.w) + (c[5].z);
    r0.xyz = (r3.www) * (r0.xyz);
    r0.w = saturate(exp2(r0.w));
    r1.xyz = (r0.xyz) * (r1.www) + (r1.xyz);
    r0.w = (-(r0.w)) + (c1.x);
    r2.w = saturate((c[9].y) * (r2.w) + (c[9].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[8].xyz);
    r0.w = (r0.w) * (c[8].w);
    r0.xyz = (r2.www) * (r0.xyz) + (c[0].xyz);
    r0.w = (r1.w) * (r0.w);
    r0.xyz = (r0.xyz) * (c[0].www) + (-(r1.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[11].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.x;

    return oC0;
}
