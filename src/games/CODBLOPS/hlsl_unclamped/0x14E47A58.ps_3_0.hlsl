// Mechanically reconstructed from 0x14E47A58.ps_3_0.cso.
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
sampler3D s11 : register(s11);
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
    const float4 c1 = float4(-0.5f, 0.5f, 4.06451607f, -2.06451607f);
    const float4 c3 = float4(4.0f, -0.5f, -2.07999992f, 1.0f);
    const float4 c4 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c12 = float4(0.75f, 4.0f, -3.0f, 200.0f);
    const float4 c13 = float4(1.0f, 0.0f, 0.000244140625f, -0.000244140625f);
    const float4 c14 = float4(31.875f, 8.0f, 0.0f, 0.0f);
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

    r2.xy = c1.xy;
    r0.xy = (v8.xy) * (c[20].xx) + (r2.xx);
    r0.xy = (r0.xy) * (c[21].xx) + (r2.yy);
    r0 = tex2D(s2, r0.xy);
    r8.xy = (v8.xy) * (c[20].xx);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r1.xy = (r8.xy) * (c3.xx) + (c3.yy);
    r0.y = (r0.w) * (c1.z) + (c1.w);
    r1.xy = (r1.xy) * (c[22].xx) + (r2.yy);
    r1 = tex2D(s3, r1.xy);
    r0.w = (r1.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c3.zz;
    r3.xy = (r0.zw) * (c[24].xx);
    r1.xyz = v7.xyz;
    r2.xyz = (r1.zxy) * (v5.yzx);
    r3.xy = (c[23].xx) * (r0.xy) + (r3.xy);
    r0.xyz = (r1.yzx) * (v5.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.w = dot(-(v6.xyz), -(v6.xyz));
    r0.xyz = (r3.xxx) * (v5.xyz) + (r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = (r0.xyz) + (v7.xyz);
    r6.xyz = normalize(r0.xyz);
    r0.xyz = (r0.www) * (-(v6.xyz));
    r1.w = dot(-(r0.xyz), r6.xyz);
    r1.w = (r1.w) + (r1.w);
    r0.xyz = (r6.xyz) * (-(r1.www)) + (-(r0.xyz));
    r7.xyz = normalize(c[17].xyz);
    r1.xyz = (r0.yyy) * (v3.xyw);
    r3.xyz = (-(v6.xyz)) * (r0.www) + (r7.xyz);
    r1.xyz = (r0.xxx) * (v2.xyw) + (r1.xyz);
    r2.xyz = normalize(r3.xyz);
    r1.xyz = (r0.zzz) * (v4.xyw) + (r1.xyz);
    r1.w = saturate(dot(r6.xyz, r2.xyz));
    r0.w = 1.0f / (r1.z);
    r5.w = pow(abs(r1.w), c12.w);
    r1.xy = (r1.xy) * (r0.ww);
    r3.w = 1.0f / (c[9].x);
    r2.w = max(abs(r1.x), abs(r1.y));
    r0.w = c13.y;
    r1.w = saturate((r2.w) * (-(r2.w)) + (c3.w));
    r2.w = ((-(r1.z)) >= 0.0f ? (c13.y) : (r1.w));
    r1.xy = (r1.xy) * (c1.yx) + (c1.yy);
    r1 = tex2D(s1, r1.xy);
    r2.xyz = (r1.xyz) * (r1.xyz);
    r0 = texCUBElod(s15, r0);
    r1.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r3.www) * (r2.xyz);
    r1.xyz = (r1.xyz) * (c[10].xxx);
    r2.xyz = (r1.xyz) * (c14.yyy);
    r1.w = max(abs(r6.y), abs(r6.z));
    r1.xyz = (r0.xyz) * (c[11].xxx) + (-(r2.xyz));
    r0.w = max(abs(r6.x), r1.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r6.xyz) * (c[5].xyz);
    r5.xyz = (r2.www) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r0.www) + (v1.xyz);
    r1 = tex3D(s11, r0.xyz);
    if ((c3.w) >= (v0.w))
    {
        r2 = (v0.xyzx) * (c13.xxxy);
        r0 = (r2) + (-(c4.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r3 = (r2) + (c13.zzyy);
        r3 = tex2Dlod(s0, r3);
        r0.x = r3.x;
        r3 = (r2) + (c13.wwyy);
        r3 = tex2Dlod(s0, r3);
        r0.y = r3.x;
        r2 = (r2) + (c4.xyzz);
        r2 = tex2Dlod(s0, r2);
        r0.z = r2.x;
        r1.w = dot(r0, c4.wwww);
        if ((c12.x) < (v0.w))
        {
            r9.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r9.xy) + (c13.zz);
            r0.zw = (v0.zx) * (c13.xy);
            r0 = tex2Dlod(s0, r0);
            r2.xy = (r9.xy) + (c13.ww);
            r2.zw = (v0.zx) * (c13.xy);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r9.xy) + (c4.xy);
            r2.zw = (v0.zx) * (c13.xy);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r9.xy) + (-(c4.xy));
            r2.zw = (v0.zx) * (c13.xy);
            r2 = tex2Dlod(s0, r2);
            r0.y = r4.x;
            r0.z = r3.x;
            r0.w = r2.x;
            r0.w = dot(r0, c4.wwww);
            r0.z = (-(r1.w)) + (r0.w);
            r0.w = (v0.w) * (c12.y) + (c12.z);
            r0.w = (r0.w) * (r0.z) + (r1.w);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (-(c3.x));
        r0.w = ((r0.w) >= 0.0f ? (c13.y) : (c13.x));
        if ((r0.w) != (-(r0.w)))
        {
            r9.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r9.xy) + (c13.zz);
            r0.zw = (v0.zz) * (c13.xy);
            r0 = tex2Dlod(s0, r0);
            r2.xy = (r9.xy) + (c13.ww);
            r2.zw = (v0.zz) * (c13.xy);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r9.xy) + (c4.xy);
            r2.zw = (v0.zz) * (c13.xy);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r9.xy) + (-(c4.xy));
            r2.zw = (v0.zz) * (c13.xy);
            r2 = tex2Dlod(s0, r2);
            r0.y = r4.x;
            r0.z = r3.x;
            r0.w = r2.x;
            r0.y = dot(r0, c4.wwww);
            r0.w = saturate((v0.w) + (c12.z));
            r0.z = (r1.w) + (-(r0.y));
            r0.w = (r0.w) * (r0.z) + (r0.y);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r2.xyz = (r0.www) * (c[18].xyz);
    r1.w = saturate(dot(r6.xyz, r7.xyz));
    r3.xyz = (r5.www) * (r2.xyz) + (r5.xyz);
    r0 = tex2D(s5, r8.xy);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.xyz = (r1.xyz) * (c14.xxx);
    r3.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r1.www) * (r2.xyz) + (r1.xyz);
    r0 = tex2D(s4, r8.xy);
    r4.xyz = normalize(v6.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[6].xyz, r4.xyz);
    r1.w = saturate((c[8].y) * (r0.z) + (c[8].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[7].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v6.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
