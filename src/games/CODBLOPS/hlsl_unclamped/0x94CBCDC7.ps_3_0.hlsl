// Mechanically reconstructed from 0x94CBCDC7.ps_3_0.cso.
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
sampler2D s9 : register(s9);
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
    const float4 c3 = float4(2.0f, -1.0f, -0.5f, 1.0f);
    const float4 c4 = float4(0.0f, 0.600000024f, 0.400000006f, 8.0f);
    const float4 c12 = float4(0.797884583f, 0.959999979f, 0.0399999991f, 31.875f);
    const float4 c13 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c16 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c33 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c34 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c35 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
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

    r0 = tex2D(s7, v7.zw);
    r1.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = (c3.xxxx) * (v8) + (c3.yyyy);
    r3.y = dot(r1.xy, r0.zw) + (c4.x);
    r3.x = dot(r1.xy, r0.xy) + (c4.x);
    r0 = tex2D(s1, v1.xy);
    r5.xy = (r0.wy) * (c1.xy) + (c1.zw);
    r0 = tex2D(s6, v7.zw);
    r2 = tex2D(s0, v1.xy);
    r1 = tex2D(s5, v7.xy);
    r2.w = (r1.w) * (v0.y) + (c3.z);
    r3.w = (r0.w) * (v0.z);
    r1.xyz = float3(((r2.w) >= 0.0f ? (r1.x) : (r2.x)), ((r2.w) >= 0.0f ? (r1.y) : (r2.y)), ((r2.w) >= 0.0f ? (r1.z) : (r2.z)));
    r4.xy = lerp(r5.xy, r3.xy, r3.ww);
    r2.xyz = lerp(r1.xyz, r0.xyz, r3.www);
    r1 = tex2D(s8, v1.xy);
    r1.z = ((r2.w) >= 0.0f ? (c3.w) : (r1.y));
    r0 = tex2D(s9, v7.zw);
    r6.w = lerp(r1.z, r0.y, r3.w);
    r7.w = lerp(r1.w, r0.w, r3.w);
    r9.xyz = (r2.xyz) * (r2.xyz);
    r10.w = (r7.w) * (-(c35.z)) + (c35.w);
    r1.w = dot(r4.xy, r4.xy) + (c4.x);
    r0.w = dot(v6.xyz, v6.xyz);
    r6.z = rsqrt(r0.w);
    r1.xyz = (-(v6.xyz)) + (c[5].xyz);
    r10.z = (r7.w) * (c12.x);
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r7.xyz = (r6.zzz) * (v6.xyz);
    r3.xyz = (r1.xyz) * (r0.www) + (-(r7.xyz));
    r0.xyz = v2.xyz;
    r2.xyz = (r4.xxx) * (v4.xyz) + (r0.xyz);
    r0.xyz = normalize(r3.xyz);
    r2.xyz = (r4.yyy) * (v3.xyz) + (r2.xyz);
    r8.xyz = normalize(r2.xyz);
    r1.xyz = (r1.xyz) * (r0.www);
    r0.w = saturate(dot(r1.xyz, r8.xyz));
    r8.w = saturate(dot(r8.xyz, -(r7.xyz)));
    r2.z = (r0.w) * (r10.w) + (r10.z);
    r9.w = (r8.w) * (r10.w) + (r10.z);
    r2.w = saturate(dot(r8.xyz, r0.xyz));
    r2.z = (r2.z) * (r9.w) + (c15.x);
    r0.z = saturate(dot(r0.xyz, r1.xyz));
    r0.y = 1.0f / (r2.z);
    r0.x = (r0.w) * (r0.y);
    r12.xy = (r7.ww) * (c34.xy) + (c34.zw);
    r4.z = exp2(r12.y);
    r0.y = (-(r0.z)) + (c3.w);
    r0.z = pow(abs(r2.w), r4.z);
    r2.w = (r0.y) * (r0.y);
    r4.w = (r4.z) * (c15.y) + (c15.z);
    r2.w = (r2.w) * (r2.w);
    r0.z = (r0.z) * (r4.w);
    r0.y = (r0.y) * (r2.w);
    r0.z = (r0.x) * (r0.z);
    r0.x = (r0.y) * (c12.y) + (c12.z);
    r0.y = exp2(-(r1.w));
    r0.z = (r0.z) * (r0.x);
    r3.w = (r0.y) * (c4.y) + (c4.z);
    r0.xyz = (r0.zzz) * (c[7].xyz);
    r5.w = dot(r1.xyz, c[22].xyz);
    r3.xyz = (r6.www) * (r0.xyz);
    r1.xyz = (r0.www) * (c[6].xyz);
    r0.xy = (v1.zw) * (-(c3.yz));
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v1.zw) * (c13.xy) + (c13.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r5.xyz = (r9.xyz) * (r1.xyz) + (r3.xyz);
    r6.xy = (r2.yw) * (c35.xx) + (c35.yy);
    r1 = tex2D(s14, v1.zw);
    r10.xy = (r1.xy) * (c12.ww);
    r0.w = dot(r6.xy, r4.xy) + (c4.x);
    r3.xy = (r2.xz) * (r10.xx);
    r0.y = (r1.x) * (c12.w) + (-(r3.x));
    r4.xy = (r0.xz) * (r10.yy);
    r0.x = (r2.z) * (-(r10.x)) + (r0.y);
    r0.y = (r1.y) * (c12.w) + (-(r4.x));
    r0.y = (r0.z) * (-(r10.y)) + (r0.y);
    r0.z = dot(r6.xy, r6.xy) + (c4.x);
    r6.y = (r0.x) + (r0.x);
    r0.z = exp2(-(r0.z));
    r0.y = (r0.y) + (r0.y);
    r0.z = (r0.z) * (c4.y) + (c4.z);
    r0.z = (r3.w) * (r0.z);
    r2.xyz = (v6.xyz) * (-(r6.zzz)) + (c[17].xyz);
    r1.w = saturate((r0.w) * (r0.z) + (r0.z));
    r1.xyz = normalize(r2.xyz);
    r0.xz = (r4.xy) * (c13.ww);
    r0.w = saturate(dot(r1.xyz, c[17].xyz));
    r0.xyz = (r0.xyz) * (r1.www);
    r0.w = (-(r0.w)) + (c3.w);
    r6.xz = (r3.xy) * (c13.ww);
    r1.w = (r0.w) * (r0.w);
    r2.w = (r1.w) * (r1.w);
    r1.w = saturate(dot(r8.xyz, c[17].xyz));
    r2.w = (r0.w) * (r2.w);
    r0.w = (r1.w) * (r10.w) + (r10.z);
    r1.y = saturate(dot(r8.xyz, r1.xyz));
    r1.z = (r0.w) * (r9.w) + (c15.x);
    r0.w = pow(abs(r1.y), r4.z);
    r1.z = 1.0f / (r1.z);
    r0.w = (r4.w) * (r0.w);
    r1.y = (r1.w) * (r1.z);
    r1.z = (r2.w) * (c12.y) + (c12.z);
    r0.w = (r0.w) * (r1.y);
    r0.xyz = (r6.xyz) * (r3.www) + (r0.xyz);
    r0.w = (r1.z) * (r0.w);
    r11.xyz = (r6.www) * (r0.xyz);
    r9.w = (r6.w) * (r0.w);
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (c13.x) : (c13.z));
    r10.xyz = (r1.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((c3.w) >= (v5.w))
        {
            r1 = (v5.xyzx) * (c13.xxxz);
            r0 = (r1) + (-(c33.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c14.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c14.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c33.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c15.zzzz);
            if ((c15.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c14.xx);
                r0.zw = (v5.zx) * (c13.xz);
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c14.zz);
                r1.zw = (v5.zx) * (c13.xz);
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c33.xy);
                r1.zw = (v5.zx) * (c13.xz);
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c33.xy));
                r1.zw = (v5.zx) * (c13.xz);
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c15.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c16.x) + (c16.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c13.w));
            r0.w = ((r0.w) >= 0.0f ? (c13.z) : (c13.x));
            if ((r0.w) != (-(r0.w)))
            {
                r13.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r13.xy) + (c14.xx);
                r1.zw = (v5.zz) * (c13.xz);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r13.xy) + (c14.zz);
                r2.zw = (v5.zz) * (c13.xz);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (c33.xy);
                r2.zw = (v5.zz) * (c13.xz);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (-(c33.xy));
                r2.zw = (v5.zz) * (c13.xz);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c15.zzzz);
                r0.w = saturate((v5.w) + (c14.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r1.xyz = (r9.www) * (c[19].xyz);
    r0.xyz = (r0.www) * (r10.xyz) + (r11.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r2.xyz = (r9.xyz) * (r0.xyz) + (r1.xyz);
    r0.w = (-(r8.w)) + (c3.w);
    r0.y = 1.0f / (r12.x);
    r0.z = (r0.w) * (r0.w);
    r0.z = (r0.w) * (r0.z);
    r0.w = dot(r7.xyz, r8.xyz);
    r1.w = (r0.y) * (r0.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = (r7.w) * (c4.w);
    r0.xyz = (r8.xyz) * (-(r0.zzz)) + (r7.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r1.w) * (c12.y) + (c12.z);
    r0.xyz = (r6.www) * (r0.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r0 = (v6.yyyy) * (c[25]);
    r1.xyz = (r6.xyz) * (r1.xyz);
    r0 = (v6.xxxx) * (c[24]) + (r0);
    r6.xyz = (r1.xyz) * (c4.www) + (r2.xyz);
    r0 = (v6.zzzz) * (c[26]) + (r0);
    r1.w = saturate((r5.w) * (c[23].x) + (c[23].y));
    r3 = (r0) + (c[27]);
    r0.z = (r1.w) * (c16.z) + (c16.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[28].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s3, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[28].xy)) + (r3.xy);
    r4 = tex2Dproj(s3, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[28].xy) + (r3.xy);
    r4 = tex2Dproj(s3, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[28].zw) + (r3.xy);
    r2 = tex2Dproj(s3, r1);
    r1 = (v6.xyzx) * (c13.xxxz) + (c13.zzzx);
    r0.z = r2.x;
    r2.w = dot(r1, c[21]);
    r2.w = 1.0f / (r2.w);
    r3.x = dot(r1, c[20]);
    r2.x = dot(r1, c[10]);
    r3.y = (r3.x) * (r3.x);
    r2.y = dot(r1, c[11]);
    r1.w = dot(c[8].yz, r3.xy) + (c[8].x);
    r1.z = saturate(1.0f / (r1.w));
    r1.xy = saturate((r3.xx) * (c[9].xy) + (c[9].zw));
    r3.xy = (r1.xy) * (c16.zz) + (c16.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r1.w = ((-abs(r1.w)) >= 0.0f ? (c4.x) : (r1.z));
    r1.z = (r3.x) * (r1.x);
    r1.w = (r1.w) * (r1.z);
    r1.z = (r1.y) * (-(r3.y)) + (c3.w);
    r1.xy = (r2.ww) * (r2.xy);
    r1.w = (r1.w) * (r1.z);
    r2.w = (r3.z) * (r1.w);
    r1.xy = (r1.xy) * (-(c3.zz)) + (-(c3.zz));
    r1 = tex2D(s4, r1.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r0.w = dot(r0, c15.zzzz);
    r0.xyz = (r2.www) * (r1.xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r0.w = dot(c[29].xyz, r7.xyz);
    r0.w = saturate((c[31].y) * (r0.w) + (c[31].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[30].xyz);
    r1.xyz = (r1.xyz) * (r5.xyz) + (r6.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[32].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c3.w;

    return oC0;
}
