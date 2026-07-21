// Mechanically reconstructed from 0x83CC2CB0.ps_3_0.cso.
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
    const float4 c3 = float4(-2.0f, 3.0f, 0.75f, -4.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 31.875f);
    const float4 c12 = float4(1.0f, 0.25f, 0.0f, 0.000244140625f);
    const float4 c13 = float4(4.0f, -2.0f, 0.100000001f, 0.0f);
    const float4 c14 = float4(1.0f, 0.5f, 0.0f, 9.99999975e-05f);
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
    float4 oC0 = 0.0f;

    r0.w = dot(v4.xyz, v4.xyz);
    r5.w = rsqrt(r0.w);
    r0.y = (c[31].x) * (c[31].x);
    r0.zw = c1.zw;
    r1.xy = (c[31].xx) * (c[31].xx) + (r0.zw);
    r0.xy = (r0.yy) * (c1.xy);
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r6.w = (r0.y) * (r1.y);
    r7.w = (r0.x) * (-(r1.x)) + (c12.x);
    r5.xyz = normalize(-(v3.xyz));
    r6.xyz = normalize(c[17].xyz);
    if ((c12.x) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c12.xxxz);
        r0 = (r1) + (-(c4.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c12.wwzz);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (-(c12.wwzz));
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c4.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r7.y = dot(r0, c12.yyyy);
        if ((c3.z) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c12.ww);
            r0.zw = (v0.zx) * (c12.xz);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (-(c12.ww));
            r1.zw = (v0.zx) * (c12.xz);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c4.xy);
            r1.zw = (v0.zx) * (c12.xz);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c4.xy));
            r1.zw = (v0.zx) * (c12.xz);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c12.yyyy);
            r0.z = (-(r7.y)) + (r0.w);
            r0.w = (v0.w) * (-(c3.w)) + (-(c3.y));
            r7.y = (r0.w) * (r0.z) + (r7.y);
        }
    }
    else
    {
        r0.w = (v0.w) + (c3.w);
        r1.w = ((r0.w) >= 0.0f ? (c12.z) : (c12.x));
        r0 = tex2D(s12, v6.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r7.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r7.xy) + (c12.ww);
            r1.zw = (v0.zz) * (c12.xz);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r7.xy) + (-(c12.ww));
            r2.zw = (v0.zz) * (c12.xz);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r7.xy) + (c4.xy);
            r2.zw = (v0.zz) * (c12.xz);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r7.xy) + (-(c4.xy));
            r2.zw = (v0.zz) * (c12.xz);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c12.yyyy);
            r0.w = saturate((v0.w) + (-(c3.y)));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r7.y = r0.w;
    }
    r0 = (v3.yyyy) * (c[24]);
    r0 = (v3.xxxx) * (c[23]) + (r0);
    r0 = (v3.zzzz) * (c[25]) + (r0);
    r3 = (r0) + (c[26]);
    r2.zw = r3.zw;
    r4.zw = r2.zw;
    r7.z = dot(r6.xyz, r5.xyz);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[27].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s1, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[27].xy)) + (r3.xy);
    r4 = tex2Dproj(s1, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[27].xy) + (r3.xy);
    r4 = tex2Dproj(s1, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[27].zw) + (r3.xy);
    r1 = tex2Dproj(s1, r1);
    r8.xy = (v6.xy) * (c[29].xy);
    r2 = tex2D(s3, r8.xy);
    r4.xy = (r2.wy) * (c0.xy) + (c0.zw);
    r2.xyz = v4.xyz;
    r3.xyz = (r2.zxy) * (v1.yzx);
    r4.xy = (r4.xy) * (c[30].xx);
    r2.xyz = (r2.yzx) * (v1.zxy) + (-(r3.xyz));
    r2.xyz = (r4.yyy) * (-(r2.xyz));
    r0.z = r1.x;
    r1.xyz = (r4.xxx) * (v1.xyz) + (r2.xyz);
    r1.w = dot(r0, c12.yyyy);
    r0.xyz = (r1.xyz) + (v4.xyz);
    r1.xyz = (r7.yyy) * (c[18].xyz);
    r4.xyz = normalize(r0.xyz);
    r3.w = saturate(dot(r4.xyz, r5.xyz));
    r0.w = saturate(dot(r4.xyz, r6.xyz));
    r0.z = saturate((r0.w) * (-(r3.w)) + (r7.z));
    r4.w = 1.0f / (r3.w);
    r0.z = (r6.w) * (r0.z);
    r0.y = saturate((r0.w) * (r4.w));
    r0.z = (r0.z) * (r0.y);
    r2.xyz = (-(v3.xyz)) + (c[5].xyz);
    r3.z = (r7.w) * (r0.w) + (r0.z);
    r0.xyz = normalize(r2.xyz);
    r0.w = dot(r0.xyz, r5.xyz);
    r2.w = saturate(dot(r4.xyz, r0.xyz));
    r3.xyz = (r1.xyz) * (r3.zzz);
    r0.w = saturate((r2.w) * (-(r3.w)) + (r0.w));
    r1.z = (r6.w) * (r0.w);
    r0.w = dot(r0.xyz, c[21].xyz);
    r0.z = saturate((r4.w) * (r2.w));
    r0.w = saturate((r0.w) * (c[22].x) + (c[22].y));
    r2.z = (r1.z) * (r0.z);
    r1.y = (r0.w) * (c3.x) + (c3.y);
    r1.z = (r0.w) * (r0.w);
    r0 = (v3.xyzx) * (c12.xxxz) + (c12.zzzx);
    r1.z = (r1.y) * (r1.z);
    r1.y = dot(r0, c[20]);
    r4.w = 1.0f / (r1.y);
    r2.x = dot(r0, c[11]);
    r1.x = dot(r0, c[9]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[10]);
    r0.w = dot(c[7].yz, r2.xy) + (c[7].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[8].xy) + (c[8].zw));
    r2.xy = (r0.xy) * (c3.xx) + (c3.yy);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c12.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c12.x);
    r0.xy = (r4.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r1.z = (r1.z) * (r0.w);
    r0.xy = (r0.xy) * (c1.xx) + (c1.xx);
    r0 = tex2D(s2, r0.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r4.w = (r7.w) * (r2.w) + (r2.z);
    r0.xyz = (r1.zzz) * (r0.xyz);
    r6.xyz = (r1.www) * (r0.xyz);
    r0.xy = (v6.zw) * (c14.xy);
    r2 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v6.zw);
    r10.xy = (r1.xy) * (c4.ww);
    r0.xy = (v6.zw) * (c14.xy) + (c14.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r9.xy = (r2.xz) * (r10.xx);
    r2.xy = (r2.yw) * (c13.xx) + (c13.yy);
    r0.w = (r1.x) * (c4.w) + (-(r9.x));
    r7.xyz = (r2.yyy) * (v2.xyz);
    r0.y = (r2.z) * (-(r10.x)) + (r0.w);
    r2.xyz = (r2.xxx) * (v1.xyz) + (r7.xyz);
    r7.xy = (r10.yy) * (r0.xz);
    r2.xyz = (v4.xyz) * (r5.www) + (r2.xyz);
    r0.w = (r1.y) * (c4.w) + (-(r7.x));
    r1.xyz = normalize(r2.xyz);
    r0.w = (r0.z) * (-(r10.y)) + (r0.w);
    r1.w = dot(r1.xyz, r4.xyz);
    r2.y = (r0.y) + (r0.y);
    r0.y = (r0.w) + (r0.w);
    r2.xz = (r9.xy) * (-(c3.ww));
    r0.xz = (r7.xy) * (-(c3.ww));
    r0.w = dot(r1.xyz, r5.xyz);
    r1.xyz = (r1.www) * (r0.xyz) + (r2.xyz);
    r4.xyz = (r0.www) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r7.www) * (r1.xyz);
    r2.xyz = (r6.xyz) * (c[6].xyz);
    r0.xyz = (r4.xyz) * (r0.xyz);
    r2.xyz = (r2.xyz) * (r4.www) + (r3.xyz);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r1.xyz = (r7.www) * (r1.xyz) + (r2.xyz);
    r0.x = 1.0f / (r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = 1.0f / (r0.z);
    r1.w = (r3.w) * (-(r3.w)) + (c12.x);
    r0.w = (r3.w) * (r3.w);
    r0.xyz = (r6.www) * (r0.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c12.x) : (r1.w));
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s4, r8.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (-(v5.xyz));
    r1.xyz = (r5.www) * (v4.xyz);
    r1.w = v1.w;
    r0.xyz = (r1.www) * (r0.xyz) + (v5.xyz);
    r1.w = dot(r5.xyz, r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r2.w = max(c14.w, r1.w);
    r1.w = pow(abs(r2.w), c13.z);
    r0.w = (r0.w) + (-(c12.x));
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = (r1.w) * (r0.w) + (c12.x);

    return oC0;
}
