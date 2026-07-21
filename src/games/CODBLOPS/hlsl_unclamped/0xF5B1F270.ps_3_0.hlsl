// Mechanically reconstructed from 0xF5B1F270.ps_3_0.cso.
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
sampler2D s7 : register(s7);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
    float4 v6 : TEXCOORD7;
    float4 v7 : TEXCOORD8;
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
    const float4 c1 = float4(-0.5f, 0.5f, 4.06451607f, -2.06451607f);
    const float4 c3 = float4(4.0f, -0.5f, -2.07999992f, 0.25f);
    const float4 c4 = float4(1.0f, 0.0f, -2.0f, 3.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.75f);
    const float4 c13 = float4(200.0f, 0.000244140625f, 0.0f, -0.000244140625f);
    const float4 c14 = float4(4.0f, -3.0f, 1.0f, 0.5f);
    const float4 c15 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c16 = float4(4.0f, -2.0f, 8.0f, 0.0f);
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

    r0.w = dot(v6.xyz, v6.xyz);
    r2.xy = c1.xy;
    r0.xy = (v7.xy) * (c[41].xx) + (r2.xx);
    r1.w = rsqrt(r0.w);
    r0.xy = (r0.xy) * (c[42].xx) + (r2.yy);
    r0 = tex2D(s4, r0.xy);
    r8.xy = (v7.xy) * (c[41].xx);
    r1.xy = (r8.xy) * (c3.xx) + (c3.yy);
    r1.z = (r0.y) * (c1.z) + (c1.w);
    r0.xy = (r1.xy) * (c[43].xx) + (r2.yy);
    r0 = tex2D(s5, r0.xy);
    r0.w = (r0.y) * (c1.z) + (c1.w);
    r0.w = (r0.w) * (c1.z) + (c1.w);
    r0.xz = c3.zz;
    r0.y = (r1.z) * (c1.z) + (c1.w);
    r1.xy = (r0.zw) * (c[45].xx);
    r5.xy = (c[44].xx) * (r0.xy) + (r1.xy);
    r0.xyz = v6.xyz;
    r1.xyz = (r0.zxy) * (v4.yzx);
    r3.xyz = (r0.yzx) * (v4.zxy) + (-(r1.xyz));
    r0.xy = (v7.zw) * (c14.zw);
    r2 = tex2D(s13, r0.xy);
    r0.xy = (v7.zw) * (c15.xy) + (c15.zy);
    r0 = tex2D(s13, r0.xy);
    r2.w = r0.y;
    r4.xy = (r2.yw) * (c16.xx) + (c16.yy);
    r1.xyz = (r3.xyz) * (v4.www);
    r3.xyz = (r5.yyy) * (-(r3.xyz));
    r1.xyz = (r4.yyy) * (r1.xyz);
    r3.xyz = (r5.xxx) * (v4.xyz) + (r3.xyz);
    r1.xyz = (r4.xxx) * (v4.xyz) + (r1.xyz);
    r3.xyz = (r3.xyz) + (v6.xyz);
    r1.xyz = (v6.xyz) * (r1.www) + (r1.xyz);
    r6.xyz = normalize(r3.xyz);
    r3.xyz = normalize(r1.xyz);
    r1 = tex2D(s14, v7.zw);
    r4.xy = (r1.xy) * (c15.ww);
    r5.w = dot(r3.xyz, r6.xyz);
    r9.xy = (r2.xz) * (r4.xx);
    r0.w = (r1.x) * (c15.w) + (-(r9.x));
    r3.xy = (r0.xz) * (r4.yy);
    r0.y = (r2.z) * (-(r4.x)) + (r0.w);
    r0.w = (r1.y) * (c15.w) + (-(r3.x));
    r0.w = (r0.z) * (-(r4.y)) + (r0.w);
    r7.y = (r0.y) + (r0.y);
    r5.y = (r0.w) + (r0.w);
    r4 = (-(v5.yyyy)) + (c[6]);
    r2 = (-(v5.xxxx)) + (c[5]);
    r0 = (r4) * (r4);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v5.zzzz)) + (c[7]);
    r7.xz = (r9.xy) * (c3.xx);
    r0 = (r1) * (r1) + (r0);
    r5.xz = (r3.xy) * (c3.xx);
    r3.x = rsqrt(r0.x);
    r3.y = rsqrt(r0.y);
    r3.z = rsqrt(r0.z);
    r3.w = rsqrt(r0.w);
    r5.xyz = (r5.www) * (r5.xyz) + (r7.xyz);
    r4 = (r4) * (r3);
    r4 = (r6.yyyy) * (r4);
    r2 = (r2) * (r3);
    r2 = (r2) * (r6.xxxx) + (r4);
    r1 = (r1) * (r3);
    r2 = saturate((r1) * (r6.zzzz) + (r2));
    r1 = (v5.yyyy) * (c[31]);
    r3.w = c4.x;
    r0 = saturate((r0) * (c[8]) + (r3.wwww));
    r1 = (v5.xxxx) * (c[30]) + (r1);
    r0 = (r2) * (r0);
    r1 = (v5.zzzz) * (c[32]) + (r1);
    r7.z = dot(c[11], r0);
    r3 = (r1) + (c[33]);
    r7.x = dot(c[9], r0);
    r2.zw = r3.zw;
    r7.y = dot(c[10], r0);
    r4.zw = r2.zw;
    r5.xyz = (r5.xyz) + (r7.xyz);
    r1.zw = r4.zw;
    r0.xy = (r3.ww) * (-(c[34].zw)) + (r3.xy);
    r0.zw = r1.zw;
    r0 = tex2Dproj(s1, r0);
    r0.w = r0.x;
    r4.xy = (r2.ww) * (-(c[34].xy)) + (r3.xy);
    r4 = tex2Dproj(s1, r4);
    r0.y = r4.x;
    r2.xy = (r2.ww) * (c[34].xy) + (r3.xy);
    r4 = tex2Dproj(s1, r2);
    r0.x = r4.x;
    r1.xy = (r2.ww) * (c[34].zw) + (r3.xy);
    r1 = tex2Dproj(s1, r1);
    r0.z = r1.x;
    r1.w = dot(-(v5.xyz), -(v5.xyz));
    r7.w = rsqrt(r1.w);
    r1.xyz = normalize(c[17].xyz);
    r6.w = dot(r0, c3.wwww);
    r0.xyz = (-(v5.xyz)) * (r7.www) + (r1.xyz);
    r5.w = saturate(dot(r6.xyz, r1.xyz));
    r7.xyz = normalize(r0.xyz);
    if ((c4.x) >= (v0.w))
    {
        r1 = (v0.xyzx) * (c4.xxxy);
        r0 = (r1) + (-(c12.xyzz));
        r0 = tex2Dlod(s0, r0);
        r0.w = r0.x;
        r2 = (r1) + (c13.yyzz);
        r2 = tex2Dlod(s0, r2);
        r0.x = r2.x;
        r2 = (r1) + (c13.wwzz);
        r2 = tex2Dlod(s0, r2);
        r0.y = r2.x;
        r1 = (r1) + (c12.xyzz);
        r1 = tex2Dlod(s0, r1);
        r0.z = r1.x;
        r4.w = dot(r0, c3.wwww);
        if ((c12.w) < (v0.w))
        {
            r4.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r0.xy = (r4.xy) + (c13.yy);
            r0.zw = (v0.zx) * (c4.xy);
            r0 = tex2Dlod(s0, r0);
            r1.xy = (r4.xy) + (c13.ww);
            r1.zw = (v0.zx) * (c4.xy);
            r3 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (c12.xy);
            r1.zw = (v0.zx) * (c4.xy);
            r2 = tex2Dlod(s0, r1);
            r1.xy = (r4.xy) + (-(c12.xy));
            r1.zw = (v0.zx) * (c4.xy);
            r1 = tex2Dlod(s0, r1);
            r0.y = r3.x;
            r0.z = r2.x;
            r0.w = r1.x;
            r0.w = dot(r0, c3.wwww);
            r0.z = (-(r4.w)) + (r0.w);
            r0.w = (v0.w) * (c14.x) + (c14.y);
            r3.z = (r0.w) * (r0.z) + (r4.w);
        }
        else
        {
            r3.z = r4.w;
        }
    }
    else
    {
        r0.w = (v0.w) + (-(c3.x));
        r1.w = ((r0.w) >= 0.0f ? (c4.y) : (c4.x));
        r0 = tex2D(s12, v7.zw);
        if ((r1.w) != (-(r1.w)))
        {
            r9.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r1.xy = (r9.xy) + (c13.yy);
            r1.zw = (v0.zz) * (c4.xy);
            r1 = tex2Dlod(s0, r1);
            r2.xy = (r9.xy) + (c13.ww);
            r2.zw = (v0.zz) * (c4.xy);
            r4 = tex2Dlod(s0, r2);
            r2.xy = (r9.xy) + (c12.xy);
            r2.zw = (v0.zz) * (c4.xy);
            r3 = tex2Dlod(s0, r2);
            r2.xy = (r9.xy) + (-(c12.xy));
            r2.zw = (v0.zz) * (c4.xy);
            r2 = tex2Dlod(s0, r2);
            r1.y = r4.x;
            r1.z = r3.x;
            r1.w = r2.x;
            r0.x = dot(r1, c3.wwww);
            r0.w = saturate((v0.w) + (-(c4.w)));
            r0.z = (r0.y) + (-(r0.x));
            r0.w = (r0.w) * (r0.z) + (r0.x);
        }
        else
        {
            r0.w = r0.y;
        }
        r3.z = r0.w;
    }
    r1.xyz = (-(v5.xyz)) + (c[20].xyz);
    r0.xyz = normalize(r1.xyz);
    r1.w = saturate(dot(r6.xyz, r7.xyz));
    r0.w = dot(r0.xyz, c[28].xyz);
    r3.w = pow(abs(r1.w), c13.x);
    r0.w = saturate((r0.w) * (c[29].x) + (c[29].y));
    r2.w = saturate(dot(r6.xyz, r0.xyz));
    r1.w = (r0.w) * (c4.z) + (c4.w);
    r0.w = (r0.w) * (r0.w);
    r1.xyz = (-(v5.xyz)) * (r7.www) + (r0.xyz);
    r2.z = (r1.w) * (r0.w);
    r0.xyz = normalize(r1.xyz);
    r2.y = saturate(dot(r6.xyz, r0.xyz));
    r0 = (v5.xyzx) * (c4.xxxy) + (c4.yyyx);
    r1.w = pow(abs(r2.y), c13.x);
    r1.z = dot(r0, c[27]);
    r1.z = 1.0f / (r1.z);
    r2.x = dot(r0, c[26]);
    r1.x = dot(r0, c[24]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[25]);
    r0.w = dot(c[22].yz, r2.xy) + (c[22].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[23].xy) + (c[23].zw));
    r2.xy = (r0.xy) * (c4.zz) + (c4.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c4.y) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c4.x);
    r0.xy = (r1.zz) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r1.z = (r2.z) * (r0.w);
    r0.xy = (r0.xy) * (c1.yy) + (c1.yy);
    r0 = tex2D(s2, r0.xy);
    r2.xyz = (r7.www) * (-(v5.xyz));
    r0.w = dot(-(r2.xyz), r6.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r1.zzz) * (r0.xyz);
    r0.xyz = (r6.xyz) * (-(r0.www)) + (-(r2.xyz));
    r2.xyz = (r6.www) * (r1.xyz);
    r1.xyz = (r0.yyy) * (v2.xyw);
    r4.xyz = (r2.xyz) * (c[21].xyz);
    r2.xyz = (r0.xxx) * (v1.xyw) + (r1.xyz);
    r1.xyz = (r3.zzz) * (c[18].xyz);
    r7.xyz = (r0.zzz) * (v3.xyw) + (r2.xyz);
    r2.xyz = (r3.www) * (r1.xyz);
    r0.w = 1.0f / (r7.z);
    r2.xyz = (r1.www) * (r4.xyz) + (r2.xyz);
    r3.xy = (r7.xy) * (r0.ww);
    r6.xyz = (r5.www) * (r1.xyz);
    r0.w = max(abs(r3.x), abs(r3.y));
    r3.w = saturate((r0.w) * (-(r0.w)) + (c4.x));
    r1.xy = (r3.xy) * (c1.yx) + (c1.yy);
    r1 = tex2D(s3, r1.xy);
    r3.xyz = (r1.xyz) * (r1.xyz);
    r0.w = c4.y;
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.w = 1.0f / (c[38].x);
    r1.xyz = (r0.xyz) * (c[39].xxx);
    r0.xyz = (r3.xyz) * (r0.www);
    r3.xyz = (r1.xyz) * (c16.zzz);
    r0.w = ((-(r7.z)) >= 0.0f ? (c4.y) : (r3.w));
    r0.xyz = (r0.xyz) * (c[40].xxx) + (-(r3.xyz));
    r1.xyz = (r2.www) * (r4.xyz) + (r6.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (r3.xyz);
    r1.xyz = (r5.xyz) + (r1.xyz);
    r2.xyz = (r2.xyz) + (r0.xyz);
    r0 = tex2D(s7, r8.xy);
    r3.xyz = (r2.xyz) * (r0.xyz);
    r0 = tex2D(s6, r8.xy);
    r4.xyz = normalize(v5.xyz);
    r2.xyz = (r0.xyz) * (r0.xyz);
    r0.z = dot(c[35].xyz, r4.xyz);
    r1.w = saturate((c[37].y) * (r0.z) + (c[37].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[36].xyz);
    r1.xyz = (r1.xyz) * (r2.xyz) + (r3.xyz);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v5.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[38].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
