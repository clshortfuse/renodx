// Mechanically reconstructed from 0x7BD23622.ps_3_0.cso.
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
sampler3D s11 : register(s11);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
    float4 v6 : TEXCOORD8;
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
    const float4 c0 = float4(2.75f, -2.0f, 0.5f, 2.0f);
    const float4 c1 = float4(75.0f, 0.5f, -0.5f, 3.68000007f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(0.00333333341f, 300.0f, -64.0301971f, 9.40301991f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c13 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c14 = float4(60.0f, 1.0f, 0.0f, 0.000244140625f);
    const float4 c15 = float4(31.875f, 100.0f, 8.0f, 0.0f);
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

    r0.w = c4.x;
    r0.w = (r0.w) * (c[6].w);
    r0.w = frac(abs(r0.w));
    r4.w = ((c[6].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r3.y = (r4.w) * (c14.x);
    r0 = tex2D(s2, v6.xy);
    r8.xy = (v6.xy) * (c[9].xx);
    r1.xy = (r8.xy) * (c[20].xx);
    r3.xzw = (r4.www) * (c4.yzw);
    r2.xy = (c[22].xx) * (r3.xx) + (r1.xy);
    r2 = tex2D(s4, r2.xy);
    r1.xy = (c[21].xy) * (r3.xx) + (r1.xy);
    r1 = tex2D(s4, r1.xy);
    r0.w = (r2.x) + (r1.x);
    r0.z = (r0.w) + (r0.w);
    r0.w = saturate(r0.y);
    r0.z = (r4.w) * (-(c1.x)) + (r0.z);
    r1.w = (r0.z) + (c1.y);
    r0.xyz = c[10].xyz;
    r0.xyz = (-(r0.yzx)) + (c[11].yzx);
    r1.w = frac(r1.w);
    r5.xyz = (r0.www) * (r0.xyz) + (c[10].yzx);
    r0.w = (r1.w) + (c1.z);
    r0.z = frac(r5.y);
    r1.w = (abs(r0.w)) * (c1.w);
    r0.w = (r5.y) + (-(r0.z));
    r0.w = (r0.w) * (c0.y);
    r1.z = (r0.z) + (c1.z);
    r2.z = exp2(r0.w);
    r0.z = ((r1.z) >= 0.0f ? (c0.z) : (c0.w));
    r0.w = pow(abs(r1.w), c0.x);
    r2.w = (r2.z) * (r0.z);
    r1.w = lerp(c[23].x, c[23].y, r0.w);
    r3.x = (r8.x) * (r2.w) + (r3.y);
    r0.x = (r8.x) * (r2.z) + (r3.y);
    r0.z = (r8.y) * (r2.z);
    r0 = tex2D(s3, r0.xz);
    r1.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xy = (r8.xy) * (r2.zz) + (r3.zw);
    r0 = tex2D(s3, r0.xy);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r1.xy = (r1.xy) * (r0.xy);
    r0.xy = (r8.xy) * (r2.ww) + (r3.zw);
    r0 = tex2D(s3, r0.xy);
    r2.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r3.z = (r8.y) * (r2.w);
    r0 = tex2D(s3, r3.xz);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xy = (r2.xy) * (r0.xy) + (-(r1.xy));
    r0.w = (abs(r1.z)) + (abs(r1.z));
    r1.w = (r5.x) * (r1.w);
    r2.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r8.xy);
    r3.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xyz = v4.xyz;
    r1.xyz = (r0.zxy) * (v2.yzx);
    r2.xy = (r1.ww) * (r2.xy) + (r3.xy);
    r0.xyz = (r0.yzx) * (v2.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r0.xyz));
    r0.w = dot(-(v3.xyz), -(v3.xyz));
    r0.xyz = (r2.xxx) * (v2.xyz) + (r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = (r0.xyz) + (v4.xyz);
    r2.xyz = normalize(r0.xyz);
    r1.xyz = (r0.www) * (-(v3.xyz));
    r0.xyz = normalize(v4.xyz);
    r3.xyz = normalize(c[17].xyz);
    r5.w = saturate(dot(r2.xyz, r1.xyz));
    r5.y = saturate(dot(r0.xyz, r3.xyz));
    r4.xyz = (-(v3.xyz)) * (r0.www) + (r3.xyz);
    r2.w = max(abs(r0.y), abs(r0.z));
    r3.xyz = normalize(r4.xyz);
    r1.w = max(abs(r0.x), r2.w);
    r0.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r1.w);
    r5.x = saturate(dot(r2.xyz, r3.xyz));
    r0.xyz = (r0.xyz) * (r0.www) + (v1.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r6.xyz = (r0.xyz) * (c15.xxx);
    r1.w = max(abs(r2.y), abs(r2.z));
    r0.z = max(abs(r2.x), r1.w);
    r0.w = dot(-(r1.xyz), r2.xyz);
    r1.w = 1.0f / (r0.z);
    r0.z = (r0.w) + (r0.w);
    r0.w = c[8].x;
    r0.xyz = (r2.xyz) * (-(r0.zzz)) + (-(r1.xyz));
    r0 = texCUBElod(s15, r0);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r2.xyz) * (c[5].xyz);
    r7.xyz = (r1.xyz) * (c15.zzz);
    r0.xyz = (r0.xyz) * (r1.www) + (v1.xyz);
    r0 = tex3D(s11, r0.xyz);
    if ((c14.y) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c14.yyyz);
        r0 = (r1) + (-(c12.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c14.wwzz);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (-(c14.wwzz));
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c12.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c12.wwww);
        if ((c13.x) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c14.ww);
            r0.zw = (v0.zx) * (c14.yz);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (-(c14.ww));
            r1.zw = (v0.zx) * (c14.yz);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c12.xy);
            r1.zw = (v0.zx) * (c14.yz);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c12.xy));
            r1.zw = (v0.zx) * (c14.yz);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c12.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v0.w) * (c13.y) + (c13.z);
            r0.z = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r0.z = r4.w;
        }
    }
    else
    {
        r0.z = (v0.w) + (c13.w);
        r0.z = ((r0.z) >= 0.0f ? (c14.z) : (c14.y));
        if ((r0.z) != (-(r0.z)))
        {
            r0.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r0.xy) + (c14.ww);
            r1.zw = (v0.zz) * (c14.yz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r0.xy) + (-(c14.ww));
            r2.zw = (v0.zz) * (c14.yz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r0.xy) + (c12.xy);
            r2.zw = (v0.zz) * (c14.yz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r0.xy) + (-(c12.xy));
            r2.zw = (v0.zz) * (c14.yz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.y = dot(r1, c12.wwww);
            r0.z = saturate((v0.w) + (c13.z));
            r0.w = (r0.w) + (-(r0.y));
            r0.w = (r0.z) * (r0.w) + (r0.y);
        }
        r0.z = r0.w;
    }
    r0.w = pow(abs(r5.x), c15.y);
    r0.xyz = (r0.zzz) * (c[18].xyz);
    r2.xyz = (r0.www) * (r0.xyz) + (r7.xyz);
    r1.xyz = (r5.yyy) * (r0.xyz) + (r6.xyz);
    r0 = tex2D(s6, r8.xy);
    r0.w = (-(r5.w)) + (c14.y);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r1.w) * (r1.w);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r1.w = (r0.w) * (r1.w);
    r0 = tex2D(s5, r8.xy);
    r2.w = (-(r0.x)) + (c14.y);
    r0.xyz = (r2.xyz) * (r5.zzz) + (-(r1.xyz));
    r0.w = saturate(lerp(r2.w, c14.y, r1.w));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v5.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v5.xyz);
    r0.xyz = max(((r0.xyz) * (c[7].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c14.y;

    return oC0;
}
