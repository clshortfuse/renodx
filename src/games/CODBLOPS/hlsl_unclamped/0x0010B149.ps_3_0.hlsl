// Mechanically reconstructed from 0x0010B149.ps_3_0.cso.
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
    const float4 c1 = float4(0.00333333341f, -0.0f, 0.075000003f, 0.400000006f);
    const float4 c3 = float4(-2.0f, -0.5f, 0.5f, 2.0f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(300.0f, -64.0301971f, 9.40301991f, 60.0f);
    const float4 c13 = float4(0.000244140625f, -0.0f, -0.000244140625f, 0.25f);
    const float4 c14 = float4(0.00048828125f, -0.000122070312f, -0.0f, 0.75f);
    const float4 c15 = float4(0.00249999994f, -1.0f, 1.0f, -0.0f);
    const float4 c16 = float4(4.0f, -3.0f, -4.0f, 31.875f);
    const float4 c19 = float4(4.0f, -2.0f, 8.0f, 0.0f);
    const float4 c32 = float4(1.0f, 0.5f, -0.0f, 1000.0f);
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

    r0.w = c1.x;
    r0.w = (r0.w) * (c[8].w);
    r0.w = frac(abs(r0.w));
    r0.w = ((c[8].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r1 = tex2D(s4, v9.xy);
    r0 = (r0.wwww) * (c12);
    r5.xy = (c[22].xy) * (r0.xx) + (v9.xy);
    r11.xy = (r5.xy) * (c[23].xx);
    r2.xy = ddy(r11.xy);
    r0.x = dot(r2.xy, r2.xy) + (c1.y);
    r2.xy = ddx(r11.xy);
    r0.x = dot(r2.xy, r2.xy) + (r0.x);
    r2.w = log2(abs(r0.x));
    r0.x = (r2.w) * (c1.z) + (c1.w);
    r1.z = frac(r0.x);
    r1.w = (r0.x) + (-(r1.z));
    r0.x = saturate(r1.y);
    r1.w = (r1.w) * (c3.x);
    r1.w = exp2(r1.w);
    r1.z = (r1.z) + (c3.y);
    r3.w = (abs(r1.z)) + (abs(r1.z));
    r1.z = ((r1.z) >= 0.0f ? (c3.z) : (c3.w));
    r2.z = (r1.w) * (r1.z);
    r1.xy = (r11.xy) * (r1.ww);
    r1 = tex2D(s3, r1.xy);
    r3.xy = (r1.wy) * (c4.xy) + (c4.zw);
    r1.xy = (r11.xy) * (r2.zz);
    r1 = tex2D(s3, r1.xy);
    r2.xyz = c[24].xyz;
    r2.xyz = (-(r2.yzx)) + (c[25].yzx);
    r6.xyz = (r0.xxx) * (r2.xyz) + (c[24].yzx);
    r0.x = (r2.w) * (c15.x) + (r6.y);
    r1.z = frac(r0.x);
    r0.x = (r0.x) + (-(r1.z));
    r0.x = (r0.x) * (c3.x);
    r2.w = (r1.z) + (c3.y);
    r0.x = exp2(r0.x);
    r1.z = ((r2.w) >= 0.0f ? (c3.z) : (c3.w));
    r1.xy = (r1.wy) * (c4.xy) + (c4.zw);
    r2.z = (r0.x) * (r1.z);
    r2.xy = (-(r3.xy)) + (r1.xy);
    r7.x = (r11.x) * (r2.z) + (r0.w);
    r1.x = (r11.x) * (r0.x) + (r0.w);
    r1.z = (r11.y) * (r0.x);
    r1 = tex2D(s5, r1.xz);
    r4.xy = (r1.wy) * (c4.xy) + (c4.zw);
    r1.xy = (r11.xy) * (r0.xx) + (r0.yz);
    r1 = tex2D(s5, r1.xy);
    r1.xy = (r1.wy) * (c4.xy) + (c4.zw);
    r4.xy = (r4.xy) * (r1.xy);
    r0.xy = (r11.xy) * (r2.zz) + (r0.yz);
    r0 = tex2D(s5, r0.xy);
    r1.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r7.z = (r11.y) * (r2.z);
    r0 = tex2D(s5, r7.xz);
    r0.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r3.xy = (r3.ww) * (r2.xy) + (r3.xy);
    r2.xy = (r1.xy) * (r0.xy) + (-(r4.xy));
    r1.w = (abs(r2.w)) + (abs(r2.w));
    r7.xy = ddx(r5.xy);
    r8.xy = ddy(r5.yx);
    r0.xy = ddy(v9.xy);
    r9.xy = (r7.yy) * (r0.xy);
    r0.xyz = v8.xyz;
    r1.xyz = (r0.zxy) * (v5.yzx);
    r5.xy = ddx(v9.xy);
    r0.xyz = (r0.yzx) * (v5.zxy) + (-(r1.xyz));
    r5.xy = (r5.xy) * (r8.xx) + (-(r9.xy));
    r1.xyz = (r0.xyz) * (v5.www);
    r0.w = (r7.y) * (r8.y);
    r0.xyz = (r5.yyy) * (r1.xyz);
    r0.w = (r7.x) * (r8.x) + (-(r0.w));
    r0.xyz = (v5.xyz) * (r5.xxx) + (r0.xyz);
    r4.xy = (r1.ww) * (r2.xy) + (r4.xy);
    r2.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (-(r0.x))), ((r0.w) >= 0.0f ? (r0.y) : (-(r0.y))), ((r0.w) >= 0.0f ? (r0.z) : (-(r0.z))));
    r0.w = (r6.x) * (c[27].x);
    r0.xyz = normalize(r2.xyz);
    r4.xy = (r4.xy) * (r0.ww);
    r2.xyz = (r0.yzx) * (v8.zxy);
    r3.xy = (c[26].xx) * (r3.xy) + (r4.xy);
    r2.xyz = (v8.yzx) * (r0.zxy) + (-(r2.xyz));
    r0.w = dot(v8.xyz, v8.xyz);
    r2.xyz = (r3.yyy) * (-(r2.xyz));
    r0.xyz = (r3.xxx) * (r0.xyz) + (r2.xyz);
    r1.w = dot(-(v7.xyz), -(v7.xyz));
    r0.xyz = (r0.xyz) + (v8.xyz);
    r3.w = rsqrt(r1.w);
    r9.xyz = normalize(r0.xyz);
    r10.xyz = (r3.www) * (-(v7.xyz));
    r1.w = rsqrt(r0.w);
    r6.w = saturate(dot(r9.xyz, r10.xyz));
    r8.xyz = (r1.www) * (v8.xyz);
    r0.xy = (v9.zw) * (c32.xy);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v9.zw) * (c32.xy) + (c32.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r3.xyz = normalize(c[17].xyz);
    r5.xy = (r2.yw) * (c19.xx) + (c19.yy);
    r6.x = saturate(dot(r8.xyz, r3.xyz));
    r1.xyz = (r1.xyz) * (r5.yyy);
    r4.xyz = (-(v7.xyz)) * (r3.www) + (r3.xyz);
    r1.xyz = (r5.xxx) * (v5.xyz) + (r1.xyz);
    r3.xyz = normalize(r4.xyz);
    r1.xyz = (v8.xyz) * (r1.www) + (r1.xyz);
    r6.y = saturate(dot(r9.xyz, r3.xyz));
    r3.xyz = normalize(r1.xyz);
    r1 = tex2D(s14, v9.zw);
    r4.xy = (r1.xy) * (c16.ww);
    r0.w = dot(r3.xyz, r8.xyz);
    r3.xy = (r2.xz) * (r4.xx);
    r0.y = (r1.x) * (c16.w) + (-(r3.x));
    r2.xy = (r0.xz) * (r4.yy);
    r0.y = (r2.z) * (-(r4.x)) + (r0.y);
    r0.x = (r1.y) * (c16.w) + (-(r2.x));
    r0.z = (r0.z) * (-(r4.y)) + (r0.x);
    r1.y = (r0.y) + (r0.y);
    r0.y = (r0.z) + (r0.z);
    r0.z = dot(r9.xyz, r8.xyz);
    r1.xz = (r3.xy) * (c16.xx);
    r1.w = (r0.z) + (c15.y);
    r0.xz = (r2.xy) * (c16.xx);
    r1.w = (r1.w) * (c[28].x);
    r7.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0 = v1;
    r1 = (r0) * (r1.wwww) + (v0);
    if ((c15.z) >= (r1.w))
    {
        r2 = (r1.xyzx) * (c15.zzzw);
        r0 = (r2) + (c13.xxyy);
        r0 = tex2Dlod(s0, r0);
        r3 = (r2) + (c13.zzyy);
        r5 = tex2Dlod(s0, r3);
        r3 = (r2) + (c14.xyzz);
        r3 = tex2Dlod(s0, r3);
        r4 = (r2) + (-(c14.xyzz));
        r2 = tex2Dlod(s0, r4);
        r0.y = r5.x;
        r0.z = r3.x;
        r0.w = r2.x;
        r1.z = dot(r0, c13.wwww);
        if ((c14.w) < (r1.w))
        {
            r3.zw = r4.zw;
            r2.zw = r3.zw;
            r1.xy = (r1.xy) * (c[2].ww) + (c[2].xy);
            r0.zw = r2.zw;
            r0.xy = (r1.xy) + (-(c14.xy));
            r0 = tex2Dlod(s0, r0);
            r0.w = r0.x;
            r4.xy = (r1.xy) + (c13.xx);
            r4 = tex2Dlod(s0, r4);
            r0.x = r4.x;
            r3.xy = (r1.xy) + (c13.zz);
            r3 = tex2Dlod(s0, r3);
            r0.y = r3.x;
            r2.xy = (r1.xy) + (c14.xy);
            r2 = tex2Dlod(s0, r2);
            r0.z = r2.x;
            r0.w = dot(r0, c13.wwww);
            r0.z = (-(r1.z)) + (r0.w);
            r0.w = (r1.w) * (c16.x) + (c16.y);
            r2.w = (r0.w) * (r0.z) + (r1.z);
        }
        else
        {
            r2.w = r1.z;
        }
    }
    else
    {
        r0.w = (r1.w) + (c16.z);
        r2.w = ((r0.w) >= 0.0f ? (c15.w) : (c15.z));
        r0 = tex2D(s12, v9.zw);
        if ((r2.w) != (-(r2.w)))
        {
            r5.zw = (r1.zz) * (c15.zw);
            r4.zw = r5.zw;
            r1.xy = (r1.xy) * (c[2].ww) + (c[2].xy);
            r3.zw = r4.zw;
            r2.xy = (r1.xy) + (-(c14.xy));
            r2.zw = r3.zw;
            r2 = tex2Dlod(s0, r2);
            r2.w = r2.x;
            r5.xy = (r1.xy) + (c13.xx);
            r5 = tex2Dlod(s0, r5);
            r2.x = r5.x;
            r4.xy = (r1.xy) + (c13.zz);
            r4 = tex2Dlod(s0, r4);
            r2.y = r4.x;
            r3.xy = (r1.xy) + (c14.xy);
            r3 = tex2Dlod(s0, r3);
            r2.z = r3.x;
            r0.x = dot(r2, c13.wwww);
            r0.w = saturate((r1.w) + (c16.y));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r2.w = r0.w;
    }
    r1 = tex2D(s6, r11.xy);
    r0.w = dot(-(r10.xyz), r9.xyz);
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r9.xyz) * (-(r0.www)) + (-(r10.xyz));
    r0.w = dot(r0.xyz, r8.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (r0.w) : (c1.y));
    r0.w = (r0.w) + (r0.w);
    r0.xyz = (r0.www) * (-(r8.xyz)) + (r0.xyz);
    r2.xyz = (r0.yyy) * (v3.xyw);
    r2.xyz = (r0.xxx) * (v2.xyw) + (r2.xyz);
    r4.xyz = (r0.zzz) * (v4.xyw) + (r2.xyz);
    r0.w = 1.0f / (r4.z);
    r3.xyz = (r2.www) * (c[18].xyz);
    r4.xy = (r4.xy) * (r0.ww);
    r2.xyz = (r6.xxx) * (r3.xyz) + (r7.xyz);
    r1.w = max(abs(r4.x), abs(r4.y));
    r2.xyz = (r1.xyz) * (r2.xyz);
    r0.w = pow(abs(r1.w), c[20].x);
    r2.w = pow(abs(r6.y), c32.w);
    r0.w = saturate((-(r0.w)) + (c15.z));
    r3.w = ((-(r4.z)) >= 0.0f ? (c1.y) : (r0.w));
    r1.xy = (r4.xy) * (c3.zy) + (c3.zz);
    r1 = tex2D(s2, r1.xy);
    r4.xyz = (r1.xyz) * (r1.xyz);
    r0.w = c1.y;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[10].x);
    r1.xyz = (r0.xyz) * (c[11].xxx);
    r0.xyz = (r4.xyz) * (r0.www);
    r1.xyz = (r1.xyz) * (c19.zzz);
    r0.xyz = (r0.xyz) * (c[21].xxx) + (-(r1.xyz));
    r0.w = (-(r6.w)) + (c15.z);
    r0.xyz = (r3.www) * (r0.xyz) + (r1.xyz);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r2.www) * (r3.xyz) + (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r1.xyz = (r0.xyz) * (r6.zzz) + (-(r2.xyz));
    r0.w = (r0.w) * (r1.w);
    r0.y = c15.z;
    r1.w = (r0.y) + (-(c[29].x));
    r0.xyz = normalize(v7.xyz);
    r1.w = saturate((r0.w) * (r1.w) + (c[29].x));
    r0.w = dot(c[5].xyz, r0.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[6].xyz);
    r1.xyz = (r1.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v6.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r1.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.xy = (vPos.xy) * (c[9].zw);
    r0 = tex2D(s1, r0.xy);
    r1.w = (abs(r0.x)) + (-(v6.z));
    r0.x = rsqrt(r1.x);
    r0.y = rsqrt(r1.y);
    r0.z = rsqrt(r1.z);
    r0.w = max(r1.w, c1.y);
    r0.w = (r0.w) * (c[30].x);
    r1.w = 1.0f / (c[31].x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = saturate((r0.w) * (r1.w));

    return oC0;
}
