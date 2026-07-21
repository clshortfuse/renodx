// Mechanically reconstructed from 0x1D3D92DD.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
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
    const float4 c3 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c4 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c9 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c10 = float4(4.0f, -2.0f, 9.99999975e-05f, 0.100000001f);
    const float4 c11 = float4(1.0f, 0.5f, 0.0f, 31.875f);
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

    r0.w = dot(v4.xyz, v4.xyz);
    r5.w = rsqrt(r0.w);
    r0.xy = (v6.zw) * (c11.xy);
    r2 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v6.zw);
    r4.xy = (r1.xy) * (c11.ww);
    r3.xy = (r2.xz) * (r4.xx);
    r0.xy = (v6.zw) * (c11.xy) + (c11.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r0.w = (r1.x) * (c11.w) + (-(r3.x));
    r5.xy = (r2.yw) * (c10.xx) + (c10.yy);
    r1.w = (r2.z) * (-(r4.x)) + (r0.w);
    r2.xyz = (r5.yyy) * (v2.xyz);
    r0.xy = (r4.yy) * (r0.xz);
    r2.xyz = (r5.xxx) * (v1.xyz) + (r2.xyz);
    r0.w = (r1.y) * (c11.w) + (-(r0.x));
    r1.xyz = (v4.xyz) * (r5.www) + (r2.xyz);
    r10.xyz = normalize(r1.xyz);
    r5.xyz = normalize(-(v3.xyz));
    r0.z = (r0.z) * (-(r4.y)) + (r0.w);
    r0.w = dot(r10.xyz, r5.xyz);
    r9.y = (r1.w) + (r1.w);
    r8.y = (r0.z) + (r0.z);
    r9.xz = (r3.xy) * (c3.yy);
    r8.xz = (r0.xy) * (c3.yy);
    r7.xyz = (r0.www) * (r8.xyz) + (r9.xyz);
    r6.xyz = normalize(c[17].xyz);
    if ((c4.x) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c4.xxxy);
        r0 = (r1) + (-(c9.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c4.zzyy);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (c4.wwyy);
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c9.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c9.wwww);
        if ((c3.x) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c4.zz);
            r0.zw = (v0.zx) * (c4.xy);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (c4.ww);
            r1.zw = (v0.zx) * (c4.xy);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c9.xy);
            r1.zw = (v0.zx) * (c4.xy);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c9.xy));
            r1.zw = (v0.zx) * (c4.xy);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c9.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v0.w) * (c3.y) + (c3.z);
            r3.w = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r3.w = r4.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (c3.w);
        r1.w = ((r0.w) >= 0.0f ? (c4.y) : (c4.x));
        r0 = tex2D(s12, v6.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r11.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r11.xy) + (c4.zz);
            r1.zw = (v0.zz) * (c4.xy);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r11.xy) + (c4.ww);
            r2.zw = (v0.zz) * (c4.xy);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r11.xy) + (c9.xy);
            r2.zw = (v0.zz) * (c4.xy);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r11.xy) + (-(c9.xy));
            r2.zw = (v0.zz) * (c4.xy);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c9.wwww);
            r0.w = saturate((v0.w) + (c3.z));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r3.w = r0.w;
    }
    r3.xy = (v6.xy) * (c[6].xy);
    r0 = tex2D(s1, r3.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xyz = v4.xyz;
    r1.xyz = (r0.zxy) * (v1.yzx);
    r2.xy = (r2.xy) * (c[7].xx);
    r0.xyz = (r0.yzx) * (v1.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r0.xyz));
    r0.xyz = (r2.xxx) * (v1.xyz) + (r0.xyz);
    r0.xyz = (r0.xyz) + (v4.xyz);
    r1.xyz = normalize(r0.xyz);
    r0.w = dot(r10.xyz, r1.xyz);
    r0.z = (c[8].x) * (c[8].x);
    r0.y = c[8].x;
    r0.xy = (r0.yy) * (r0.yy) + (c1.zw);
    r4.xy = (r0.zz) * (c1.xy);
    r10.x = 1.0f / (r0.x);
    r10.y = 1.0f / (r0.y);
    r1.w = (r4.x) * (-(r10.x)) + (c4.x);
    r0.xyz = (r0.www) * (r8.xyz) + (r9.xyz);
    r2.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r7.xyz) * (r2.xyz);
    r4.w = dot(r6.xyz, r5.xyz);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r3.z = (r4.y) * (r10.y);
    r0.x = 1.0f / (r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = 1.0f / (r0.z);
    r0.xyz = (r3.zzz) * (r0.xyz);
    r0.w = saturate(dot(r1.xyz, r5.xyz));
    r2.w = (r0.w) * (-(r0.w)) + (c4.x);
    r1.z = saturate(dot(r1.xyz, r6.xyz));
    r1.y = saturate((r1.z) * (-(r0.w)) + (r4.w));
    r1.x = 1.0f / (r0.w);
    r1.y = (r3.z) * (r1.y);
    r1.x = saturate((r1.z) * (r1.x));
    r0.w = (r0.w) * (r0.w);
    r1.y = (r1.y) * (r1.x);
    r1.w = (r1.w) * (r1.z) + (r1.y);
    r1.xyz = (r3.www) * (c[18].xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c4.x) : (r2.w));
    r1.xyz = (r1.xyz) * (r1.www) + (r2.xyz);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s2, r3.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (-(v5.xyz));
    r1.xyz = (r5.www) * (v4.xyz);
    r1.w = v1.w;
    r0.xyz = (r1.www) * (r0.xyz) + (v5.xyz);
    r1.w = dot(r5.xyz, r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[5].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r2.w = max(c10.z, r1.w);
    r1.w = pow(abs(r2.w), c10.w);
    r0.w = (r0.w) + (-(c4.x));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = (r1.w) * (r0.w) + (c4.x);

    return oC0;
}
