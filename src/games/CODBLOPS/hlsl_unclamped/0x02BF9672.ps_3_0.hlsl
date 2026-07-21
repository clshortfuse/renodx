// Mechanically reconstructed from 0x02BF9672.ps_3_0.cso.
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
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
    const float4 c12 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c14 = float4(0.75f, 4.0f, -3.0f, -4.0f);
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
    r0.xyz = c[34].xyz;
    r0.xyz = (-(r0.yzx)) + (c[35].yzx);
    r6.xw = c1.xw;
    r1.w = (r6.x) * (c[23].w);
    r6.xyz = (r0.www) * (r0.xyz) + (c[34].yzx);
    r0.w = frac(abs(r1.w));
    r0.z = frac(r6.y);
    r0.w = ((c[23].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.y = (r6.y) + (-(r0.z));
    r0.x = dot(v8.xyz, v8.xyz);
    r0.y = (r0.y) * (c1.y);
    r3.w = rsqrt(r0.x);
    r3.y = exp2(r0.y);
    r2.z = (r0.z) + (c1.z);
    r0 = (r0.wwww) * (c4);
    r1.w = ((r2.z) >= 0.0f ? (-(c1.z)) : (-(c1.y)));
    r1.xy = (c[32].xy) * (r0.xx) + (v9.xy);
    r3.z = (r3.y) * (r1.w);
    r12.xy = (r1.xy) * (c[33].xx);
    r2.w = dot(-(v7.xyz), -(v7.xyz));
    r3.x = (r12.x) * (r3.z) + (r0.w);
    r1.x = (r12.x) * (r3.y) + (r0.w);
    r1.z = (r3.y) * (r12.y);
    r1 = tex2D(s5, r1.xz);
    r2.xy = (r1.wy) * (c3.xy) + (c3.zw);
    r1.xy = (r12.xy) * (r3.yy) + (r0.yz);
    r1 = tex2D(s5, r1.xy);
    r1.xy = (r1.wy) * (c3.xy) + (c3.zw);
    r1.xy = (r2.xy) * (r1.xy);
    r0.xy = (r12.xy) * (r3.zz) + (r0.yz);
    r0 = tex2D(s5, r0.xy);
    r2.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r3.z = (r3.z) * (r12.y);
    r0 = tex2D(s5, r3.xz);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.z = (abs(r2.z)) + (abs(r2.z));
    r0.xy = (r2.xy) * (r0.xy) + (-(r1.xy));
    r0.w = (r6.x) * (c[37].x);
    r0.xy = (r0.zz) * (r0.xy) + (r1.xy);
    r6.y = rsqrt(r2.w);
    r3.xy = (r0.ww) * (r0.xy);
    r0 = tex2D(s3, r12.xy);
    r2.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xyz = v8.xyz;
    r1.xyz = (r0.zxy) * (v5.yzx);
    r5.xy = (c[36].xx) * (r2.xy) + (r3.xy);
    r1.xyz = (r0.yzx) * (v5.zxy) + (-(r1.xyz));
    r3.xyz = (r5.yyy) * (-(r1.xyz));
    r0.xy = (v9.zw) * (-(c1.wz));
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v9.zw) * (c15.xy) + (c15.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r4.xy = (r2.yw) * (c16.xx) + (c16.yy);
    r1.xyz = (r1.xyz) * (v5.www);
    r3.xyz = (r5.xxx) * (v5.xyz) + (r3.xyz);
    r1.xyz = (r4.yyy) * (r1.xyz);
    r3.xyz = (r3.xyz) + (v8.xyz);
    r1.xyz = (r4.xxx) * (v5.xyz) + (r1.xyz);
    r8.xyz = normalize(r3.xyz);
    r1.xyz = (v8.xyz) * (r3.www) + (r1.xyz);
    r3.xyz = normalize(r1.xyz);
    r5.xyz = (r3.www) * (v8.xyz);
    r1 = tex2D(s14, v9.zw);
    r4.xy = (r1.xy) * (c15.ww);
    r4.w = dot(r3.xyz, r5.xyz);
    r2.xy = (r2.xz) * (r4.xx);
    r0.w = (r1.x) * (c15.w) + (-(r2.x));
    r0.xy = (r0.xz) * (r4.yy);
    r1.w = (r2.z) * (-(r4.x)) + (r0.w);
    r0.w = (r1.y) * (c15.w) + (-(r0.x));
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r7.y = (r1.w) + (r1.w);
    r4.y = (r0.w) + (r0.w);
    r7.xz = (r2.xy) * (c14.yy);
    r4.xz = (r0.xy) * (c14.yy);
    r3 = (-(v7.yyyy)) + (c[6]);
    r2 = (-(v7.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v7.zzzz)) + (c[7]);
    r7.xyz = (r4.www) * (r4.xyz) + (r7.xyz);
    r0 = (r1) * (r1) + (r0);
    r9.xyz = (r6.yyy) * (-(v7.xyz));
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r5.w = dot(-(r9.xyz), r8.xyz);
    r3 = (r3) * (r4);
    r2 = (r2) * (r4);
    r3 = (r5.yyyy) * (r3);
    r1 = (r1) * (r4);
    r2 = (r2) * (r5.xxxx) + (r3);
    r1 = saturate((r1) * (r5.zzzz) + (r2));
    r0 = saturate((r0) * (c[8]) + (-(r6.wwww)));
    r2.w = (r5.w) + (r5.w);
    r1 = (r1) * (r0);
    r0.xyz = (r8.xyz) * (-(r2.www)) + (-(r9.xyz));
    r2.z = dot(c[11], r1);
    r2.x = dot(c[9], r1);
    r2.y = dot(c[10], r1);
    r11.xyz = (r7.xyz) + (r2.xyz);
    r0.w = c12.y;
    r0 = texCUBElod(s15, r0);
    r1.xyz = (vPos.yyy) * (c[26].xyz);
    r1.xyz = (vPos.xxx) * (c[25].xyz) + (r1.xyz);
    r2.xyz = (r1.xyz) + (c[27].xyz);
    r1.xyz = normalize(r2.xyz);
    r0.w = dot(-(r1.xyz), r8.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r8.xyz) * (-(r0.www)) + (-(r1.xyz));
    r0.w = dot(r1.xyz, r5.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (r0.w) : (c12.y));
    r0.w = (r0.w) + (r0.w);
    r2.xyz = (r0.www) * (-(r5.xyz)) + (r1.xyz);
    r1.xyz = (r2.yyy) * (v3.xyw);
    r3.xyz = (r2.xxx) * (v2.xyw) + (r1.xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r2.zzz) * (v4.xyw) + (r3.xyz);
    r1.xyz = (r1.xyz) * (c[29].xxx);
    r0.w = 1.0f / (r0.z);
    r1.xyz = (r1.xyz) * (c16.www);
    r0.xy = (r0.xy) * (r0.ww);
    r1.w = 1.0f / (c[28].x);
    r2.w = max(abs(r0.x), abs(r0.y));
    r10.xyz = normalize(c[17].xyz);
    r0.w = pow(abs(r2.w), c[30].x);
    r6.x = saturate(dot(r5.xyz, r10.xyz));
    r0.w = saturate((-(r0.w)) + (-(c1.w)));
    r2.w = ((-(r0.z)) >= 0.0f ? (c12.y) : (r0.w));
    r0.xy = (r0.xy) * (c19.xy) + (c19.xx);
    r0 = tex2D(s2, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = dot(r8.xyz, r5.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.w = (r0.w) + (c1.w);
    r0.xyz = (r0.xyz) * (c[31].xxx) + (-(r1.xyz));
    r1.w = (r0.w) * (c[38].x);
    r7.xyz = (r2.www) * (r0.xyz) + (r1.xyz);
    r0 = v1;
    r1 = (r0) * (r1.wwww) + (v0);
    if ((-(c1.w)) >= (r1.w))
    {
        r2 = (r1.xyzx) * (c12.xxxy);
        r0 = (r2) + (c12.zzyy);
        r0 = tex2Dlod(s0, r0);
        r3 = (r2) + (c12.wwyy);
        r5 = tex2Dlod(s0, r3);
        r3 = (r2) + (c13.xyzz);
        r3 = tex2Dlod(s0, r3);
        r4 = (r2) + (-(c13.xyzz));
        r2 = tex2Dlod(s0, r4);
        r0.y = r5.x;
        r0.z = r3.x;
        r0.w = r2.x;
        r1.z = dot(r0, c13.wwww);
        if ((c14.x) < (r1.w))
        {
            r3.zw = r4.zw;
            r2.zw = r3.zw;
            r1.xy = (r1.xy) * (c[2].ww) + (c[2].xy);
            r0.zw = r2.zw;
            r0.xy = (r1.xy) + (-(c13.xy));
            r0 = tex2Dlod(s0, r0);
            r0.w = r0.x;
            r4.xy = (r1.xy) + (c12.zz);
            r4 = tex2Dlod(s0, r4);
            r0.x = r4.x;
            r3.xy = (r1.xy) + (c12.ww);
            r3 = tex2Dlod(s0, r3);
            r0.y = r3.x;
            r2.xy = (r1.xy) + (c13.xy);
            r2 = tex2Dlod(s0, r2);
            r0.z = r2.x;
            r0.w = dot(r0, c13.wwww);
            r0.z = (-(r1.z)) + (r0.w);
            r0.w = (r1.w) * (c14.y) + (c14.z);
            r1.w = (r0.w) * (r0.z) + (r1.z);
        }
        else
        {
            r1.w = r1.z;
        }
    }
    else
    {
        r0.w = (r1.w) + (c14.w);
        r2.w = ((r0.w) >= 0.0f ? (c12.y) : (c12.x));
        r0 = tex2D(s12, v9.zw);
        if ((r2.w) != (-(r2.w)))
        {
            r5.zw = (r1.zz) * (c12.xy);
            r4.zw = r5.zw;
            r1.xy = (r1.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = r4.zw;
            r2.xy = (r1.xy) + (-(c13.xy));
            r2.zw = r3.zw;
            r2 = tex2Dlod(s0, r2);
            r2.w = r2.x;
            r5.xy = (r1.xy) + (c12.zz);
            r5 = tex2Dlod(s0, r5);
            r2.x = r5.x;
            r4.xy = (r1.xy) + (c12.ww);
            r4 = tex2Dlod(s0, r4);
            r2.y = r4.x;
            r3.xy = (r1.xy) + (c13.xy);
            r3 = tex2Dlod(s0, r3);
            r2.z = r3.x;
            r0.x = dot(r2, c13.wwww);
            r0.w = saturate((r1.w) + (c14.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r1.w = r0.w;
    }
    r0 = tex2D(s6, r12.xy);
    r1.xyz = (r1.www) * (c[18].xyz);
    r2.xyz = (r6.xxx) * (r1.xyz) + (r11.xyz);
    r2.xyz = (r0.xyz) * (r2.xyz);
    r3.xyz = (-(v7.xyz)) * (r6.yyy) + (r10.xyz);
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
    r1.w = (-(r6.w)) + (-(c[39].x));
    r0.xyz = normalize(v7.xyz);
    r1.w = saturate((r0.w) * (r1.w) + (c[39].x));
    r0.w = dot(c[20].xyz, r0.xyz);
    r0.w = saturate((c[22].y) * (r0.w) + (c[22].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[21].xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v6.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r1.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.xy = (vPos.xy) * (c[24].zw);
    r0 = tex2D(s1, r0.xy);
    r1.w = (abs(r0.x)) + (-(v6.z));
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    r0.w = max(r1.w, c12.y);
    r0.w = (r0.w) * (c[40].x);
    r1.w = 1.0f / (c[41].x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = saturate((r0.w) * (r1.w));

    return oC0;
}
