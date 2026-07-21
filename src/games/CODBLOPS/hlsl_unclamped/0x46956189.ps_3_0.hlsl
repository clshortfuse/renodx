// Mechanically reconstructed from 0x46956189.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c3 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c4 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c13 = float4(31.875f, 9.99999975e-05f, 0.100000001f, 0.0f);
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

    r0.w = (c[24].x) * (c[24].x);
    r0.z = c[24].x;
    r1.xy = (r0.zz) * (r0.zz) + (c1.zw);
    r0.xy = (r0.ww) * (c1.xy);
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r8.w = (r0.y) * (r1.y);
    r7.w = (r0.x) * (-(r1.x)) + (c3.x);
    r7.xyz = normalize(-(v3.xyz));
    r11.xy = (v6.xy) * (c[22].xy);
    r0 = tex2D(s1, r11.xy);
    r0.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r5.xy = (r0.xy) * (c[23].xx);
    r0.xyz = v4.xyz;
    r1.xyz = (r0.zxy) * (v2.yzx);
    r4.xyz = (r0.yzx) * (v2.zxy) + (-(r1.xyz));
    r3 = (-(v3.yyyy)) + (c[7]);
    r0 = (-(v3.xxxx)) + (c[6]);
    r1 = (r3) * (r3);
    r1 = (r0) * (r0) + (r1);
    r2 = (-(v3.zzzz)) + (c[8]);
    r4.xyz = (r5.yyy) * (-(r4.xyz));
    r1 = (r2) * (r2) + (r1);
    r4.xyz = (r5.xxx) * (v2.xyz) + (r4.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r6.xyz = (r4.xyz) + (v4.xyz);
    r4 = (r3) * (r5);
    r3 = (r0) * (r5);
    r0 = (r7.yyyy) * (r4);
    r2 = (r2) * (r5);
    r0 = (r3) * (r7.xxxx) + (r0);
    r8.xyz = normalize(r6.xyz);
    r0 = saturate((r2) * (r7.zzzz) + (r0));
    r5.w = c3.x;
    r1 = saturate((r1) * (c[9]) + (r5.wwww));
    r4 = (r4) * (r8.yyyy);
    r0 = (r0) * (r1);
    r3 = (r3) * (r8.xxxx) + (r4);
    r9.z = dot(c[20], r0);
    r2 = saturate((r2) * (r8.zzzz) + (r3));
    r1 = (r1) * (r2);
    r3.w = max(abs(r8.y), abs(r8.z));
    r10.z = dot(c[20], r1);
    r2.w = max(abs(r8.x), r3.w);
    r2.w = 1.0f / (r2.w);
    r2.z = max(abs(r7.y), abs(r7.z));
    r3.w = max(abs(r7.x), r2.z);
    r2.xyz = (r8.xyz) * (c[5].xyz);
    r9.w = 1.0f / (r3.w);
    r2.xyz = (r2.xyz) * (r2.www) + (v1.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c3.x) >= (v0.w))
    {
        r4 = (v0.xyzx) * (c3.xxxy);
        r3 = (r4) + (-(c12.xyzz));
        r3 = tex2Dlod(s0, r3);
        r3.w = r3.x;
        r5 = (r4) + (c3.zzyy);
        r5 = tex2Dlod(s0, r5);
        r3.x = r5.x;
        r5 = (r4) + (c3.wwyy);
        r5 = tex2Dlod(s0, r5);
        r3.y = r5.x;
        r4 = (r4) + (c12.xyzz);
        r4 = tex2Dlod(s0, r4);
        r3.z = r4.x;
        r2.w = dot(r3, c12.wwww);
        if ((c4.x) < (v0.w))
        {
            r9.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r9.xy) + (c3.zz);
            r3.zw = (v0.zx) * (c3.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r9.xy) + (c3.ww);
            r4.zw = (v0.zx) * (c3.xy);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r9.xy) + (c12.xy);
            r4.zw = (v0.zx) * (c3.xy);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r9.xy) + (-(c12.xy));
            r4.zw = (v0.zx) * (c3.xy);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r3.w = dot(r3, c12.wwww);
            r3.z = (-(r2.w)) + (r3.w);
            r3.w = (v0.w) * (c4.y) + (c4.z);
            r3.w = (r3.w) * (r3.z) + (r2.w);
        }
        else
        {
            r3.w = r2.w;
        }
    }
    else
    {
        r3.w = (v0.w) + (c4.w);
        r3.w = ((r3.w) >= 0.0f ? (c3.y) : (c3.x));
        if ((r3.w) != (-(r3.w)))
        {
            r9.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r3.xy = (r9.xy) + (c3.zz);
            r3.zw = (v0.zz) * (c3.xy);
            r3 = tex2Dlod(s0, r3);
            r4.xy = (r9.xy) + (c3.ww);
            r4.zw = (v0.zz) * (c3.xy);
            r6 = tex2Dlod(s0, r4);
            r4.xy = (r9.xy) + (c12.xy);
            r4.zw = (v0.zz) * (c3.xy);
            r5 = tex2Dlod(s0, r4);
            r4.xy = (r9.xy) + (-(c12.xy));
            r4.zw = (v0.zz) * (c3.xy);
            r4 = tex2Dlod(s0, r4);
            r3.y = r6.x;
            r3.z = r5.x;
            r3.w = r4.x;
            r3.z = dot(r3, c12.wwww);
            r3.w = saturate((v0.w) + (c4.z));
            r2.w = (r2.w) + (-(r3.z));
            r2.w = (r3.w) * (r2.w) + (r3.z);
        }
        r3.w = r2.w;
    }
    r2.xyz = (r2.xyz) * (r2.xyz);
    r10.x = dot(c[10], r1);
    r10.y = dot(c[11], r1);
    r1.xyz = (r7.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (c13.xxx) + (r10.xyz);
    r1.xyz = (r1.xyz) * (r9.www) + (v1.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r9.x = dot(c[10], r0);
    r9.y = dot(c[11], r0);
    r2.xyz = (r7.www) * (r2.xyz);
    r0.xyz = (r1.xyz) * (c13.xxx) + (r9.xyz);
    r0.xyz = (r2.xyz) * (r0.xyz);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.x = 1.0f / (r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = 1.0f / (r0.z);
    r0.xyz = (r8.www) * (r0.xyz);
    r0.w = saturate(dot(r8.xyz, r7.xyz));
    r2.w = (r0.w) * (-(r0.w)) + (c3.x);
    r1.xyz = normalize(c[17].xyz);
    r3.z = dot(r1.xyz, r7.xyz);
    r1.w = saturate(dot(r8.xyz, r1.xyz));
    r1.z = saturate((r1.w) * (-(r0.w)) + (r3.z));
    r1.y = 1.0f / (r0.w);
    r1.z = (r8.w) * (r1.z);
    r1.y = saturate((r1.w) * (r1.y));
    r0.w = (r0.w) * (r0.w);
    r1.z = (r1.z) * (r1.y);
    r1.w = (r7.w) * (r1.w) + (r1.z);
    r1.xyz = (r3.www) * (c[18].xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c3.x) : (r2.w));
    r1.xyz = (r1.xyz) * (r1.www) + (r2.xyz);
    r2.xyz = normalize(v4.xyz);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s2, r11.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = dot(r7.xyz, r2.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (-(v5.xyz));
    r2.w = max(c13.y, r1.w);
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v5.xyz);
    r1.w = pow(abs(r2.w), c13.z);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.w) + (-(c3.x));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (r0.w) + (c3.x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
