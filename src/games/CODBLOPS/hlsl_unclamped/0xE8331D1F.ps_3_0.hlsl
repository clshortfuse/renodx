// Mechanically reconstructed from 0xE8331D1F.ps_3_0.cso.
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
    float4 r9 = 0.0f;
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = c4.x;
    r0.w = (r0.w) * (c[21].w);
    r0.w = frac(abs(r0.w));
    r4.w = ((c[21].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.w = dot(-(v3.xyz), -(v3.xyz));
    r3.y = (r4.w) * (c14.x);
    r5.w = rsqrt(r0.w);
    r0 = tex2D(s2, v6.xy);
    r11.xy = (v6.xy) * (c[24].xx);
    r1.xy = (r11.xy) * (c[27].xx);
    r3.xzw = (r4.www) * (c4.yzw);
    r2.xy = (c[29].xx) * (r3.xx) + (r1.xy);
    r2 = tex2D(s4, r2.xy);
    r1.xy = (c[28].xy) * (r3.xx) + (r1.xy);
    r1 = tex2D(s4, r1.xy);
    r0.w = (r2.x) + (r1.x);
    r0.z = (r0.w) + (r0.w);
    r0.w = saturate(r0.y);
    r0.z = (r4.w) * (-(c1.x)) + (r0.z);
    r1.w = (r0.z) + (c1.y);
    r0.xyz = c[25].xyz;
    r0.xyz = (-(r0.yzx)) + (c[26].yzx);
    r1.w = frac(r1.w);
    r6.xyz = (r0.www) * (r0.xyz) + (c[25].yzx);
    r0.w = (r1.w) + (c1.z);
    r0.z = frac(r6.y);
    r1.w = (abs(r0.w)) * (c1.w);
    r0.w = (r6.y) + (-(r0.z));
    r0.w = (r0.w) * (c0.y);
    r1.z = (r0.z) + (c1.z);
    r2.z = exp2(r0.w);
    r0.z = ((r1.z) >= 0.0f ? (c0.z) : (c0.w));
    r0.w = pow(abs(r1.w), c0.x);
    r2.w = (r2.z) * (r0.z);
    r1.w = lerp(c[30].x, c[30].y, r0.w);
    r3.x = (r11.x) * (r2.w) + (r3.y);
    r0.x = (r11.x) * (r2.z) + (r3.y);
    r0.z = (r11.y) * (r2.z);
    r0 = tex2D(s3, r0.xz);
    r1.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xy = (r11.xy) * (r2.zz) + (r3.zw);
    r0 = tex2D(s3, r0.xy);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r1.xy = (r1.xy) * (r0.xy);
    r0.xy = (r11.xy) * (r2.ww) + (r3.zw);
    r0 = tex2D(s3, r0.xy);
    r2.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r3.z = (r11.y) * (r2.w);
    r0 = tex2D(s3, r3.xz);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xy = (r2.xy) * (r0.xy) + (-(r1.xy));
    r0.w = (abs(r1.z)) + (abs(r1.z));
    r1.w = (r6.x) * (r1.w);
    r1.xy = (r0.ww) * (r0.xy) + (r1.xy);
    r0 = tex2D(s1, r11.xy);
    r0.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r6.xy = (r1.ww) * (r1.xy) + (r0.xy);
    r3 = (-(v3.yyyy)) + (c[7]);
    r2 = (-(v3.xxxx)) + (c[6]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v3.zzzz)) + (c[8]);
    r10.xyz = normalize(v4.xyz);
    r0 = (r1) * (r1) + (r0);
    r5.xyz = normalize(c[17].xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.w = saturate(dot(r10.xyz, r5.xyz));
    r3 = (r3) * (r4);
    r3 = (r10.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r10.xxxx) + (r3);
    r1 = saturate((r1) * (r10.zzzz) + (r2));
    r2.xyz = v4.xyz;
    r3.xyz = (r2.zxy) * (v2.yzx);
    r2.w = c14.y;
    r0 = saturate((r0) * (c[9]) + (r2.wwww));
    r2.xyz = (r2.yzx) * (v2.zxy) + (-(r3.xyz));
    r0 = (r1) * (r0);
    r1.xyz = (r6.yyy) * (-(r2.xyz));
    r9.z = dot(c[20], r0);
    r1.xyz = (r6.xxx) * (v2.xyz) + (r1.xyz);
    r1.xyz = (r1.xyz) + (v4.xyz);
    r2.xyz = (-(v3.xyz)) * (r5.www) + (r5.xyz);
    r7.xyz = normalize(r1.xyz);
    r1.xyz = normalize(r2.xyz);
    r6.x = saturate(dot(r7.xyz, r1.xyz));
    r2.w = max(abs(r7.y), abs(r7.z));
    r1.w = max(abs(r7.x), r2.w);
    r8.xyz = (r5.www) * (-(v3.xyz));
    r1.w = 1.0f / (r1.w);
    r6.w = saturate(dot(r7.xyz, r8.xyz));
    r2.w = dot(-(r8.xyz), r7.xyz);
    r1.xyz = (r7.xyz) * (c[5].xyz);
    r6.y = (r2.w) + (r2.w);
    r1.xyz = (r1.xyz) * (r1.www) + (v1.xyz);
    r1 = tex3D(s11, r1.xyz);
    if ((c14.y) >= (v0.w))
    {
        r2 = (v0.xyzx) * (c14.yyyz);
        r1 = (r2) + (-(c12.xyzz));
        r1 = tex2Dlod(s0, r1);
        r1.w = r1.x;
        r3 = (r2) + (c14.wwzz);
        r3 = tex2Dlod(s0, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c14.wwzz));
        r3 = tex2Dlod(s0, r3);
        r1.y = r3.x;
        r2 = (r2) + (c12.xyzz);
        r2 = tex2Dlod(s0, r2);
        r1.z = r2.x;
        r5.w = dot(r1, c12.wwww);
        if ((c13.x) < (v0.w))
        {
            r5.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r5.xy) + (c14.ww);
            r1.zw = (v0.zx) * (c14.yz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r5.xy) + (-(c14.ww));
            r2.zw = (v0.zx) * (c14.yz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (c12.xy);
            r2.zw = (v0.zx) * (c14.yz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r5.xy) + (-(c12.xy));
            r2.zw = (v0.zx) * (c14.yz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c12.wwww);
            r1.z = (-(r5.w)) + (r1.w);
            r1.w = (v0.w) * (c13.y) + (c13.z);
            r2.w = (r1.w) * (r1.z) + (r5.w);
        }
        else
        {
            r2.w = r5.w;
        }
    }
    else
    {
        r1.z = (v0.w) + (c13.w);
        r1.z = ((r1.z) >= 0.0f ? (c14.z) : (c14.y));
        if ((r1.z) != (-(r1.z)))
        {
            r1.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r2.xy = (r1.xy) + (c14.ww);
            r2.zw = (v0.zz) * (c14.yz);
            r2 = tex2Dlod(s0, r2);
            r3.xy = (r1.xy) + (-(c14.ww));
            r3.zw = (v0.zz) * (c14.yz);
            r5 = tex2Dlod(s0, r3);
            r3.xy = (r1.xy) + (c12.xy);
            r3.zw = (v0.zz) * (c14.yz);
            r4 = tex2Dlod(s0, r3);
            r3.xy = (r1.xy) + (-(c12.xy));
            r3.zw = (v0.zz) * (c14.yz);
            r3 = tex2Dlod(s0, r3);
            r2.y = r5.x;
            r2.z = r4.x;
            r2.w = r3.x;
            r1.y = dot(r2, c12.wwww);
            r1.z = saturate((v0.w) + (c13.z));
            r1.w = (r1.w) + (-(r1.y));
            r1.w = (r1.z) * (r1.w) + (r1.y);
        }
        r2.w = r1.w;
    }
    r2.z = max(abs(r10.y), abs(r10.z));
    r1.w = max(abs(r10.x), r2.z);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r10.xyz) * (c[5].xyz);
    r9.x = dot(c[10], r0);
    r1.xyz = (r1.xyz) * (r1.www) + (v1.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r9.y = dot(c[11], r0);
    r3.xyz = (r1.xyz) * (c15.xxx) + (r9.xyz);
    r0 = tex2D(s6, r11.xy);
    r2.xyz = (r2.www) * (c[18].xyz);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r7.www) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r1.xyz) * (r0.xyz);
    r2.w = pow(abs(r6.x), c15.y);
    r0.w = c[23].x;
    r0.xyz = (r7.xyz) * (-(r6.yyy)) + (-(r8.xyz));
    r0 = texCUBElod(s15, r0);
    r0.w = (-(r6.w)) + (c14.y);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = (r0.w) * (r0.w);
    r0.xyz = (r0.xyz) * (c15.zzz);
    r1.w = (r1.w) * (r1.w);
    r2.xyz = (r2.www) * (r2.xyz) + (r0.xyz);
    r1.w = (r0.w) * (r1.w);
    r0 = tex2D(s5, r11.xy);
    r2.w = (-(r0.x)) + (c14.y);
    r0.xyz = (r2.xyz) * (r6.zzz) + (-(r1.xyz));
    r0.w = saturate(lerp(r2.w, c14.y, r1.w));
    r0.xyz = (r0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r0.xyz) + (-(v5.xyz));
    r0.w = v2.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v5.xyz);
    r0.xyz = max(((r0.xyz) * (c[22].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c14.y;

    return oC0;
}
