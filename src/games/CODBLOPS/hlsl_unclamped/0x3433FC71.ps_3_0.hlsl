// Mechanically reconstructed from 0x3433FC71.ps_3_0.cso.
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
    const float4 c3 = float4(-2.0f, 3.0f, 0.75f, -4.0f);
    const float4 c4 = float4(1.0f, 0.25f, 0.0f, 0.000244140625f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 31.875f);
    const float4 c13 = float4(9.99999975e-05f, 0.100000001f, 0.0f, 0.0f);
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
    float4 oC0 = 0.0f;

    r8.xy = (v6.xy) * (c[30].xy);
    r0 = tex2D(s3, r8.xy);
    r2.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r0.xyz = v4.xyz;
    r1.xyz = (r0.zxy) * (v2.yzx);
    r2.xy = (r2.xy) * (c[31].xx);
    r0.xyz = (r0.yzx) * (v2.zxy) + (-(r1.xyz));
    r0.xyz = (r2.yyy) * (-(r0.xyz));
    r0.xyz = (r2.xxx) * (v2.xyz) + (r0.xyz);
    r0.xyz = (r0.xyz) + (v4.xyz);
    r6.xyz = normalize(-(v3.xyz));
    r5.xyz = normalize(r0.xyz);
    r1.xyz = normalize(c[17].xyz);
    r1.w = max(abs(r5.y), abs(r5.z));
    r5.w = saturate(dot(r5.xyz, r1.xyz));
    r0.w = max(abs(r5.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r5.xyz) * (c[5].xyz);
    r7.z = dot(r1.xyz, r6.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v1.xyz);
    r0 = tex3D(s11, r0.xyz);
    if ((c4.x) >= (v0.w))
    {
        r2 = (v0.xyzx) * (c4.xxxz);
        r1 = (r2) + (-(c12.xyzz));
        r1 = tex2Dlod(s0, r1);
        r1.w = r1.x;
        r3 = (r2) + (c4.wwzz);
        r3 = tex2Dlod(s0, r3);
        r1.x = r3.x;
        r3 = (r2) + (-(c4.wwzz));
        r3 = tex2Dlod(s0, r3);
        r1.y = r3.x;
        r2 = (r2) + (c12.xyzz);
        r2 = tex2Dlod(s0, r2);
        r1.z = r2.x;
        r0.w = dot(r1, c4.yyyy);
        if ((c3.z) < (v0.w))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r7.xy) + (c4.ww);
            r1.zw = (v0.zx) * (c4.xz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r7.xy) + (-(c4.ww));
            r2.zw = (v0.zx) * (c4.xz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r7.xy) + (c12.xy);
            r2.zw = (v0.zx) * (c4.xz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r7.xy) + (-(c12.xy));
            r2.zw = (v0.zx) * (c4.xz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.w = dot(r1, c4.yyyy);
            r1.z = (-(r0.w)) + (r1.w);
            r1.w = (v0.w) * (-(c3.w)) + (-(c3.y));
            r3.w = (r1.w) * (r1.z) + (r0.w);
        }
        else
        {
            r3.w = r0.w;
        }
    }
    else
    {
        r1.w = (v0.w) + (c3.w);
        r1.w = ((r1.w) >= 0.0f ? (c4.z) : (c4.x));
        if ((r1.w) != (-(r1.w)))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r7.xy) + (c4.ww);
            r1.zw = (v0.zz) * (c4.xz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r7.xy) + (-(c4.ww));
            r2.zw = (v0.zz) * (c4.xz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r7.xy) + (c12.xy);
            r2.zw = (v0.zz) * (c4.xz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r7.xy) + (-(c12.xy));
            r2.zw = (v0.zz) * (c4.xz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r1.z = dot(r1, c4.yyyy);
            r1.w = saturate((v0.w) + (-(c3.y)));
            r0.w = (r0.w) + (-(r1.z));
            r0.w = (r1.w) * (r0.w) + (r1.z);
        }
        r3.w = r0.w;
    }
    r0.w = (c[32].x) * (c[32].x);
    r1.zw = c1.zw;
    r2.xy = (c[32].xx) * (c[32].xx) + (r1.zw);
    r1.xy = (r0.ww) * (c1.xy);
    r2.x = 1.0f / (r2.x);
    r2.y = 1.0f / (r2.y);
    r6.w = (r1.y) * (r2.y);
    r8.w = (r1.x) * (-(r2.x)) + (c4.x);
    r7.w = saturate(dot(r5.xyz, r6.xyz));
    r0.w = saturate((r5.w) * (-(r7.w)) + (r7.z));
    r1.w = 1.0f / (r7.w);
    r0.w = (r6.w) * (r0.w);
    r1.z = saturate((r5.w) * (r1.w));
    r0.w = (r0.w) * (r1.z);
    r1.xyz = (-(v3.xyz)) + (c[6].xyz);
    r2.w = (r8.w) * (r5.w) + (r0.w);
    r2.xyz = normalize(r1.xyz);
    r0.w = dot(r2.xyz, r6.xyz);
    r8.z = saturate(dot(r5.xyz, r2.xyz));
    r1.xyz = (r3.www) * (c[18].xyz);
    r0.w = saturate((r8.z) * (-(r7.w)) + (r0.w));
    r7.xyz = (r2.www) * (r1.xyz);
    r0.w = (r6.w) * (r0.w);
    r2.w = saturate((r1.w) * (r8.z));
    r1 = (v3.yyyy) * (c[25]);
    r9.w = (r0.w) * (r2.w);
    r1 = (v3.xxxx) * (c[24]) + (r1);
    r0.w = dot(r2.xyz, c[22].xyz);
    r1 = (v3.zzzz) * (c[26]) + (r1);
    r0.w = saturate((r0.w) * (c[23].x) + (c[23].y));
    r4 = (r1) + (c[27]);
    r1.w = (r0.w) * (c3.x) + (c3.y);
    r3.zw = r4.zw;
    r0.w = (r0.w) * (r0.w);
    r5.zw = r3.zw;
    r4.z = (r1.w) * (r0.w);
    r2.zw = r5.zw;
    r1.xy = (r4.ww) * (-(c[28].zw)) + (r4.xy);
    r1.zw = r2.zw;
    r1 = tex2Dproj(s1, r1);
    r1.w = r1.x;
    r5.xy = (r3.ww) * (-(c[28].xy)) + (r4.xy);
    r5 = tex2Dproj(s1, r5);
    r1.y = r5.x;
    r3.xy = (r3.ww) * (c[28].xy) + (r4.xy);
    r5 = tex2Dproj(s1, r3);
    r1.x = r5.x;
    r2.xy = (r3.ww) * (c[28].zw) + (r4.xy);
    r3 = tex2Dproj(s1, r2);
    r2 = (v3.xyzx) * (c4.xxxz) + (c4.zzzx);
    r1.z = r3.x;
    r0.w = dot(r2, c[21]);
    r3.w = 1.0f / (r0.w);
    r4.x = dot(r2, c[20]);
    r3.x = dot(r2, c[10]);
    r4.y = (r4.x) * (r4.x);
    r3.y = dot(r2, c[11]);
    r0.w = dot(c[8].yz, r4.xy) + (c[8].x);
    r2.w = saturate(1.0f / (r0.w));
    r2.xy = saturate((r4.xx) * (c[9].xy) + (c[9].zw));
    r4.xy = (r2.xy) * (c3.xx) + (c3.yy);
    r2.xy = (r2.xy) * (r2.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c4.z) : (r2.w));
    r2.w = (r4.x) * (r2.x);
    r0.w = (r0.w) * (r2.w);
    r2.w = (r2.y) * (-(r4.y)) + (c4.x);
    r2.xy = (r3.ww) * (r3.xy);
    r0.w = (r0.w) * (r2.w);
    r3.w = (r4.z) * (r0.w);
    r2.xy = (r2.xy) * (c1.xx) + (c1.xx);
    r2 = tex2D(s2, r2.xy);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r0.w = dot(r1, c4.yyyy);
    r1.xyz = (r3.www) * (r2.xyz);
    r1.w = (r8.w) * (r8.z) + (r9.w);
    r1.xyz = (r0.www) * (r1.xyz);
    r2.xyz = (r1.xyz) * (c[7].xyz);
    r2.w = max(abs(r6.y), abs(r6.z));
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.w = max(abs(r6.x), r2.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r1.xyz = (r8.www) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v1.xyz);
    r0 = tex3D(s11, r0.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xyz = (r1.xyz) * (c12.www);
    r2.xyz = (r2.xyz) * (r1.www) + (r7.xyz);
    r0.xyz = (r0.xyz) * (r3.xyz);
    r1.xyz = (r1.xyz) * (c12.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (c12.www);
    r1.w = (r7.w) * (-(r7.w)) + (c4.x);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = (r7.w) * (r7.w);
    r0.x = 1.0f / (r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = 1.0f / (r0.z);
    r0.w = ((-(r0.w)) >= 0.0f ? (c4.x) : (r1.w));
    r0.xyz = (r6.www) * (r0.xyz);
    r2.xyz = normalize(v4.xyz);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s4, r8.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = dot(r6.xyz, r2.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (-(v5.xyz));
    r2.w = max(c13.x, r1.w);
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v5.xyz);
    r1.w = pow(abs(r2.w), c13.y);
    r0.xyz = max(((r0.xyz) * (c[29].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r0.w = (r0.w) + (-(c4.x));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = (r1.w) * (r0.w) + (c4.x);

    return oC0;
}
