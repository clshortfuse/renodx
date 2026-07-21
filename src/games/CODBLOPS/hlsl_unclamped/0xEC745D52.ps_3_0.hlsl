// Mechanically reconstructed from 0xEC745D52.ps_3_0.cso.
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
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD3;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
    float4 v6 : TEXCOORD6;
    float4 v7 : TEXCOORD7;
    float4 v8 : TEXCOORD8;
    float4 v9 : TEXCOORD9;
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
    float4 v6 = input.v6;
    float4 v7 = input.v7;
    float4 v8 = input.v8;
    float4 v9 = input.v9;
    float4 vPos = float4(input.vPosInput.xy, 0.0f, 0.0f);
    const float4 c1 = float4(0.00333333341f, -2.0f, -0.5f, -1.0f);
    const float4 c3 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c13 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c14 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c15 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c16 = float4(4.0f, -2.0f, 1000.0f, 8.0f);
    const float4 c19 = float4(0.5f, -0.5f, 0.0f, 0.0f);
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

    r0 = tex2D(s4, v9.xy);
    r0.w = saturate(r0.y);
    r0.xyz = c[27].xyz;
    r0.xyz = (-(r0.yzx)) + (c[28].yzx);
    r6.xyz = (r0.www) * (r0.xyz) + (c[27].yzx);
    r0.z = frac(r6.y);
    r7.xw = c1.xw;
    r0.w = (r7.x) * (c[8].w);
    r0.y = (r6.y) + (-(r0.z));
    r0.w = frac(abs(r0.w));
    r0.y = (r0.y) * (c1.y);
    r0.w = ((c[8].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r3.w = exp2(r0.y);
    r2.w = (r0.z) + (c1.z);
    r0 = (r0.wwww) * (c3);
    r1.w = ((r2.w) >= 0.0f ? (-(c1.z)) : (-(c1.y)));
    r1.xy = (c[25].xy) * (r0.xx) + (v9.xy);
    r2.z = (r3.w) * (r1.w);
    r12.xy = (r1.xy) * (c[26].xx);
    r3.x = (r12.x) * (r2.z) + (r0.w);
    r1.x = (r12.x) * (r3.w) + (r0.w);
    r1.z = (r3.w) * (r12.y);
    r1 = tex2D(s5, r1.xz);
    r2.xy = (r1.wy) * (c4.xy) + (c4.zw);
    r1.xy = (r12.xy) * (r3.ww) + (r0.yz);
    r1 = tex2D(s5, r1.xy);
    r1.xy = (r1.wy) * (c4.xy) + (c4.zw);
    r1.xy = (r2.xy) * (r1.xy);
    r0.xy = (r12.xy) * (r2.zz) + (r0.yz);
    r0 = tex2D(s5, r0.xy);
    r2.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r3.z = (r2.z) * (r12.y);
    r0 = tex2D(s5, r3.xz);
    r0.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.z = (abs(r2.w)) + (abs(r2.w));
    r0.xy = (r2.xy) * (r0.xy) + (-(r1.xy));
    r0.w = (r6.x) * (c[30].x);
    r0.xy = (r0.zz) * (r0.xy) + (r1.xy);
    r3.xy = (r0.ww) * (r0.xy);
    r0 = tex2D(s3, r12.xy);
    r2.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0.xyz = v8.xyz;
    r1.xyz = (r0.zxy) * (v5.yzx);
    r2.xy = (c[29].xx) * (r2.xy) + (r3.xy);
    r11.xyz = (r0.yzx) * (v5.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r11.xyz));
    r0.w = dot(-(v7.xyz), -(v7.xyz));
    r0.xyz = (r2.xxx) * (v5.xyz) + (r0.xyz);
    r6.w = rsqrt(r0.w);
    r0.xyz = (r0.xyz) + (v8.xyz);
    r8.xyz = normalize(r0.xyz);
    r9.xyz = (r6.www) * (-(v7.xyz));
    r0.z = dot(v8.xyz, v8.xyz);
    r0.w = dot(-(r9.xyz), r8.xyz);
    r6.y = rsqrt(r0.z);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r8.xyz) * (-(r0.www)) + (-(r9.xyz));
    r0.w = c14.y;
    r0 = texCUBElod(s15, r0);
    r1.xyz = (vPos.yyy) * (c[11].xyz);
    r1.xyz = (vPos.xxx) * (c[10].xyz) + (r1.xyz);
    r2.xyz = (r1.xyz) + (c[20].xyz);
    r1.xyz = normalize(r2.xyz);
    r0.w = dot(-(r1.xyz), r8.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r8.xyz) * (-(r0.www)) + (-(r1.xyz));
    r10.xyz = (r6.yyy) * (v8.xyz);
    r0.w = dot(r1.xyz, r10.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (r0.w) : (c14.y));
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r0.www) * (-(r10.xyz)) + (r1.xyz);
    r2.xyz = (r1.yyy) * (v3.xyw);
    r2.xyz = (r1.xxx) * (v2.xyw) + (r2.xyz);
    r2.xyz = (r1.zzz) * (v4.xyw) + (r2.xyz);
    r0.w = 1.0f / (r2.z);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xy = (r2.xy) * (r0.ww);
    r0.xyz = (r0.xyz) * (c[22].xxx);
    r1.w = max(abs(r2.x), abs(r2.y));
    r1.xyz = (r0.xyz) * (c16.www);
    r0.w = pow(abs(r1.w), c[23].x);
    r1.w = 1.0f / (c[21].x);
    r0.w = saturate((-(r0.w)) + (-(c1.w)));
    r2.w = ((-(r2.z)) >= 0.0f ? (c14.y) : (r0.w));
    r0.xy = (r2.xy) * (c19.xy) + (c19.xx);
    r0 = tex2D(s2, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(r8.xyz, r10.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.w = (r0.w) + (c1.w);
    r0.xyz = (r0.xyz) * (c[24].xxx) + (-(r1.xyz));
    r1.w = (r0.w) * (c[31].x);
    r7.xyz = (r2.www) * (r0.xyz) + (r1.xyz);
    r0 = v1;
    r1 = (r0) * (r1.wwww) + (v0);
    if ((-(c1.w)) >= (r1.w))
    {
        r2 = (r1.xyzx) * (c14.xxxy);
        r0 = (r2) + (c14.zzyy);
        r0 = tex2Dlod(s0, r0);
        r3 = (r2) + (c14.wwyy);
        r5 = tex2Dlod(s0, r3);
        r3 = (r2) + (c12.xyzz);
        r3 = tex2Dlod(s0, r3);
        r4 = (r2) + (-(c12.xyzz));
        r2 = tex2Dlod(s0, r4);
        r0.y = r5.x;
        r0.z = r3.x;
        r0.w = r2.x;
        r1.z = dot(r0, c12.wwww);
        if ((c13.x) < (r1.w))
        {
            r3.zw = r4.zw;
            r2.zw = r3.zw;
            r1.xy = (r1.xy) * (c[2].ww) + (c[2].xy);
            r0.zw = r2.zw;
            r0.xy = (r1.xy) + (-(c12.xy));
            r0 = tex2Dlod(s0, r0);
            r0.w = r0.x;
            r4.xy = (r1.xy) + (c14.zz);
            r4 = tex2Dlod(s0, r4);
            r0.x = r4.x;
            r3.xy = (r1.xy) + (c14.ww);
            r3 = tex2Dlod(s0, r3);
            r0.y = r3.x;
            r2.xy = (r1.xy) + (c12.xy);
            r2 = tex2Dlod(s0, r2);
            r0.z = r2.x;
            r0.w = dot(r0, c12.wwww);
            r0.z = (-(r1.z)) + (r0.w);
            r0.w = (r1.w) * (c13.y) + (c13.z);
            r4.w = (r0.w) * (r0.z) + (r1.z);
        }
        else
        {
            r4.w = r1.z;
        }
    }
    else
    {
        r0.w = (r1.w) + (c13.w);
        r2.w = ((r0.w) >= 0.0f ? (c14.y) : (c14.x));
        r0 = tex2D(s12, v9.zw);
        if ((r2.w) != (-(r2.w)))
        {
            r5.zw = (r1.zz) * (c14.xy);
            r4.zw = r5.zw;
            r1.xy = (r1.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = r4.zw;
            r2.xy = (r1.xy) + (-(c12.xy));
            r2.zw = r3.zw;
            r2 = tex2Dlod(s0, r2);
            r2.w = r2.x;
            r5.xy = (r1.xy) + (c14.zz);
            r5 = tex2Dlod(s0, r5);
            r2.x = r5.x;
            r4.xy = (r1.xy) + (c14.ww);
            r4 = tex2Dlod(s0, r4);
            r2.y = r4.x;
            r3.xy = (r1.xy) + (c12.xy);
            r3 = tex2Dlod(s0, r3);
            r2.z = r3.x;
            r0.x = dot(r2, c12.wwww);
            r0.w = saturate((r1.w) + (c13.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r4.w = r0.w;
    }
    r0 = tex2D(s6, r12.xy);
    r1.xy = (v9.zw) * (-(c1.wz));
    r2 = tex2D(s13, r1.xy);
    r1.xy = (v9.zw) * (c15.xy) + (c15.zy);
    r1 = tex2D(s13, r1.xy);
    r2.w = r1.y;
    r4.xy = (r2.yw) * (c16.xx) + (c16.yy);
    r3.xyz = (r11.xyz) * (v5.www);
    r3.xyz = (r4.yyy) * (r3.xyz);
    r3.xyz = (r4.xxx) * (v5.xyz) + (r3.xyz);
    r4.xyz = (v8.xyz) * (r6.yyy) + (r3.xyz);
    r3.xyz = normalize(r4.xyz);
    r0.w = dot(r3.xyz, r10.xyz);
    r3 = tex2D(s14, v9.zw);
    r6.xy = (r3.xy) * (c15.ww);
    r5.xy = (r2.xz) * (r6.xx);
    r4.xy = (r1.xz) * (r6.yy);
    r1.y = (r3.x) * (c15.w) + (-(r5.x));
    r1.w = (r3.y) * (c15.w) + (-(r4.x));
    r1.y = (r2.z) * (-(r6.x)) + (r1.y);
    r1.w = (r1.z) * (-(r6.y)) + (r1.w);
    r2.y = (r1.y) + (r1.y);
    r1.y = (r1.w) + (r1.w);
    r2.xz = (r5.xy) * (c13.yy);
    r1.xz = (r4.xy) * (c13.yy);
    r2.xyz = (r0.www) * (r1.xyz) + (r2.xyz);
    r3.xyz = normalize(c[17].xyz);
    r0.w = saturate(dot(r10.xyz, r3.xyz));
    r1.xyz = (r4.www) * (c[18].xyz);
    r2.xyz = (r0.www) * (r1.xyz) + (r2.xyz);
    r2.xyz = (r0.xyz) * (r2.xyz);
    r3.xyz = (-(v7.xyz)) * (r6.www) + (r3.xyz);
    r0.xyz = normalize(r3.xyz);
    r0.w = saturate(dot(r8.xyz, r9.xyz));
    r1.w = saturate(dot(r8.xyz, r0.xyz));
    r0.w = (-(r0.w)) + (-(c1.w));
    r0.z = pow(abs(r1.w), c16.z);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r0.zzz) * (r1.xyz) + (r7.xyz);
    r1.w = (r1.w) * (r1.w);
    r1.xyz = (r0.xyz) * (r6.zzz) + (-(r2.xyz));
    r0.w = (r0.w) * (r1.w);
    r1.w = (-(r7.w)) + (-(c[32].x));
    r0.xyz = normalize(v7.xyz);
    r1.w = saturate((r0.w) * (r1.w) + (c[32].x));
    r0.w = dot(c[5].xyz, r0.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v6.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r1.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.xy = (vPos.xy) * (c[9].zw);
    r0 = tex2D(s1, r0.xy);
    r1.w = (abs(r0.x)) + (-(v6.z));
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    r0.w = max(r1.w, c14.y);
    r0.w = (r0.w) * (c[33].x);
    r1.w = 1.0f / (c[34].x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = saturate((r0.w) * (r1.w));

    return oC0;
}
