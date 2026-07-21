// Mechanically reconstructed from 0x2D3E0F20.ps_3_0.cso.
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
    float4 r10 = 0.0f;
    float4 r11 = 0.0f;
    float4 r12 = 0.0f;
    float4 r13 = 0.0f;
    float4 r14 = 0.0f;
    float4 r15 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = (v3.yyyy) * (c[32]);
    r0 = (v3.xxxx) * (c[31]) + (r0);
    r0 = (v3.zzzz) * (c[33]) + (r0);
    r3 = (r0) + (c[34]);
    r1.zw = r3.zw;
    r4.zw = r1.zw;
    r8.z = (c[39].x) * (c[39].x);
    r0.zw = r4.zw;
    r2.xy = (r3.ww) * (-(c[35].zw)) + (r3.xy);
    r2.zw = r0.zw;
    r2 = tex2Dproj(s1, r2);
    r2.w = r2.x;
    r4.xy = (r1.ww) * (-(c[35].xy)) + (r3.xy);
    r4 = tex2Dproj(s1, r4);
    r2.y = r4.x;
    r10.xyz = normalize(-(v3.xyz));
    r1.xy = (r1.ww) * (c[35].xy) + (r3.xy);
    r4 = tex2Dproj(s1, r1);
    r2.x = r4.x;
    r0.xy = (r1.ww) * (c[35].zw) + (r3.xy);
    r6 = tex2Dproj(s1, r0);
    r4 = (-(v3.yyyy)) + (c[7]);
    r0 = (-(v3.xxxx)) + (c[6]);
    r1 = (r4) * (r4);
    r1 = (r0) * (r0) + (r1);
    r3 = (-(v3.zzzz)) + (c[8]);
    r1 = (r3) * (r3) + (r1);
    r7.x = rsqrt(r1.x);
    r7.y = rsqrt(r1.y);
    r7.z = rsqrt(r1.z);
    r7.w = rsqrt(r1.w);
    r5 = (r4) * (r7);
    r4 = (r0) * (r7);
    r0 = (r10.yyyy) * (r5);
    r3 = (r3) * (r7);
    r0 = (r4) * (r10.xxxx) + (r0);
    r0 = saturate((r3) * (r10.zzzz) + (r0));
    r2.z = c4.x;
    r1 = saturate((r1) * (c[9]) + (r2.zzzz));
    r2.z = r6.x;
    r0 = (r0) * (r1);
    r8.w = dot(r2, c4.yyyy);
    r12.z = dot(c[20], r0);
    r6.xy = (r8.zz) * (c1.xy);
    r2.zw = c1.zw;
    r2.xy = (c[39].xx) * (c[39].xx) + (r2.zw);
    r7.x = 1.0f / (r2.x);
    r7.y = 1.0f / (r2.y);
    r2.xyz = (-(v3.xyz)) + (c[21].xyz);
    r10.w = (r6.y) * (r7.y);
    r14.xyz = normalize(r2.xyz);
    r12.w = (r6.x) * (-(r7.x)) + (c4.x);
    r2.w = dot(r14.xyz, c[29].xyz);
    r15.w = dot(r14.xyz, r10.xyz);
    r2.w = saturate((r2.w) * (c[30].x) + (c[30].y));
    r2.z = (r2.w) * (c3.x) + (c3.y);
    r2.w = (r2.w) * (r2.w);
    r6.w = (r2.z) * (r2.w);
    r15.xy = (v6.xy) * (c[37].xy);
    r7.xyz = normalize(c[17].xyz);
    r2 = (v3.xyzx) * (c4.xxxz) + (c4.zzzx);
    r7.w = dot(r7.xyz, r10.xyz);
    r6.z = dot(r2, c[28]);
    r6.z = 1.0f / (r6.z);
    r8.x = dot(r2, c[27]);
    r6.x = dot(r2, c[25]);
    r8.y = (r8.x) * (r8.x);
    r6.y = dot(r2, c[26]);
    r2.w = dot(c[23].yz, r8.xy) + (c[23].x);
    r2.z = saturate(1.0f / (r2.w));
    r2.xy = saturate((r8.xx) * (c[24].xy) + (c[24].zw));
    r8.xy = (r2.xy) * (c3.xx) + (c3.yy);
    r2.xy = (r2.xy) * (r2.xy);
    r2.w = ((-abs(r2.w)) >= 0.0f ? (c4.z) : (r2.z));
    r2.z = (r8.x) * (r2.x);
    r2.w = (r2.w) * (r2.z);
    r2.z = (r2.y) * (-(r8.y)) + (c4.x);
    r2.xy = (r6.zz) * (r6.xy);
    r2.w = (r2.w) * (r2.z);
    r2.xy = (r2.xy) * (c1.xx) + (c1.xx);
    r9.w = (r6.w) * (r2.w);
    r2 = tex2D(s2, r2.xy);
    r6 = tex2D(s3, r15.xy);
    r9.xy = (r6.wy) * (c0.xy) + (c0.zw);
    r6.xyz = v4.xyz;
    r8.xyz = (r6.zxy) * (v2.yzx);
    r9.xy = (r9.xy) * (c[38].xx);
    r6.xyz = (r6.yzx) * (v2.zxy) + (-(r8.xyz));
    r6.xyz = (r9.yyy) * (-(r6.xyz));
    r2.xyz = (r2.xyz) * (r2.xyz);
    r6.xyz = (r9.xxx) * (v2.xyz) + (r6.xyz);
    r2.xyz = (r9.www) * (r2.xyz);
    r6.xyz = (r6.xyz) + (v4.xyz);
    r2.xyz = (r8.www) * (r2.xyz);
    r13.xyz = normalize(r6.xyz);
    r11.w = saturate(dot(r13.xyz, r10.xyz));
    r6.w = saturate(dot(r13.xyz, r7.xyz));
    r11.xyz = (r2.xyz) * (c[22].xyz);
    r2.w = saturate((r6.w) * (-(r11.w)) + (r7.w));
    r2.w = (r10.w) * (r2.w);
    r14.w = 1.0f / (r11.w);
    r2.z = saturate((r6.w) * (r14.w));
    r6.y = max(abs(r13.y), abs(r13.z));
    r6.z = (r2.w) * (r2.z);
    r2.w = max(abs(r13.x), r6.y);
    r2.w = 1.0f / (r2.w);
    r2.xyz = (r13.xyz) * (c[5].xyz);
    r13.w = (r12.w) * (r6.w) + (r6.z);
    r2.xyz = (r2.xyz) * (r2.www) + (v1.xyz);
    r2 = tex3D(s11, r2.xyz);
    if ((c4.x) >= (v0.w))
    {
        r7 = (v0.xyzx) * (c4.xxxz);
        r6 = (r7) + (-(c12.xyzz));
        r6 = tex2Dlod(s0, r6);
        r6.w = r6.x;
        r8 = (r7) + (c4.wwzz);
        r8 = tex2Dlod(s0, r8);
        r6.x = r8.x;
        r8 = (r7) + (-(c4.wwzz));
        r8 = tex2Dlod(s0, r8);
        r6.y = r8.x;
        r7 = (r7) + (c12.xyzz);
        r7 = tex2Dlod(s0, r7);
        r6.z = r7.x;
        r2.w = dot(r6, c4.yyyy);
        if ((c3.z) < (v0.w))
        {
            r12.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r6.xy = (r12.xy) + (c4.ww);
            r6.zw = (v0.zx) * (c4.xz);
            r6 = tex2Dlod(s0, r6);
            r7.xy = (r12.xy) + (-(c4.ww));
            r7.zw = (v0.zx) * (c4.xz);
            r9 = tex2Dlod(s0, r7);
            r7.xy = (r12.xy) + (c12.xy);
            r7.zw = (v0.zx) * (c4.xz);
            r8 = tex2Dlod(s0, r7);
            r7.xy = (r12.xy) + (-(c12.xy));
            r7.zw = (v0.zx) * (c4.xz);
            r7 = tex2Dlod(s0, r7);
            r6.y = r9.x;
            r6.z = r8.x;
            r6.w = r7.x;
            r6.w = dot(r6, c4.yyyy);
            r6.z = (-(r2.w)) + (r6.w);
            r6.w = (v0.w) * (-(c3.w)) + (-(c3.y));
            r6.w = (r6.w) * (r6.z) + (r2.w);
        }
        else
        {
            r6.w = r2.w;
        }
    }
    else
    {
        r6.w = (v0.w) + (c3.w);
        r6.w = ((r6.w) >= 0.0f ? (c4.z) : (c4.x));
        if ((r6.w) != (-(r6.w)))
        {
            r12.xy = (v0.xy) * (c[2].ww) + (c[2].xy);
            r6.xy = (r12.xy) + (c4.ww);
            r6.zw = (v0.zz) * (c4.xz);
            r6 = tex2Dlod(s0, r6);
            r7.xy = (r12.xy) + (-(c4.ww));
            r7.zw = (v0.zz) * (c4.xz);
            r9 = tex2Dlod(s0, r7);
            r7.xy = (r12.xy) + (c12.xy);
            r7.zw = (v0.zz) * (c4.xz);
            r8 = tex2Dlod(s0, r7);
            r7.xy = (r12.xy) + (-(c12.xy));
            r7.zw = (v0.zz) * (c4.xz);
            r7 = tex2Dlod(s0, r7);
            r6.y = r9.x;
            r6.z = r8.x;
            r6.w = r7.x;
            r6.z = dot(r6, c4.yyyy);
            r6.w = saturate((v0.w) + (-(c3.y)));
            r2.w = (r2.w) + (-(r6.z));
            r2.w = (r6.w) * (r2.w) + (r6.z);
        }
        r6.w = r2.w;
    }
    r2.w = saturate(dot(r13.xyz, r14.xyz));
    r6.z = saturate((r2.w) * (-(r11.w)) + (r15.w));
    r6.z = (r10.w) * (r6.z);
    r6.y = saturate((r14.w) * (r2.w));
    r5 = (r5) * (r13.yyyy);
    r6.z = (r6.z) * (r6.y);
    r4 = (r4) * (r13.xxxx) + (r5);
    r2.w = (r12.w) * (r2.w) + (r6.z);
    r3 = saturate((r3) * (r13.zzzz) + (r4));
    r4.xyz = (r6.www) * (c[18].xyz);
    r1 = (r1) * (r3);
    r3.z = dot(c[20], r1);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.x = dot(c[10], r1);
    r3.w = max(abs(r10.y), abs(r10.z));
    r3.y = dot(c[11], r1);
    r1.w = max(abs(r10.x), r3.w);
    r1.w = 1.0f / (r1.w);
    r1.xyz = (r10.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (c12.www) + (r3.xyz);
    r1.xyz = (r1.xyz) * (r1.www) + (v1.xyz);
    r1 = tex3D(s11, r1.xyz);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r12.x = dot(c[10], r0);
    r12.y = dot(c[11], r0);
    r3.xyz = (r1.xyz) * (c12.www) + (r12.xyz);
    r0.xyz = (r12.www) * (r2.xyz);
    r1.xyz = (r13.www) * (r4.xyz);
    r0.xyz = (r3.xyz) * (r0.xyz);
    r1.xyz = (r11.xyz) * (r2.www) + (r1.xyz);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    r1.xyz = (r12.www) * (r2.xyz) + (r1.xyz);
    r0.x = 1.0f / (r0.x);
    r0.y = 1.0f / (r0.y);
    r0.z = 1.0f / (r0.z);
    r1.w = (r11.w) * (-(r11.w)) + (c4.x);
    r0.w = (r11.w) * (r11.w);
    r0.xyz = (r10.www) * (r0.xyz);
    r0.w = ((-(r0.w)) >= 0.0f ? (c4.x) : (r1.w));
    r2.xyz = normalize(v4.xyz);
    r1.xyz = (r0.xyz) * (r0.www) + (r1.xyz);
    r0 = tex2D(s4, r15.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r1.w = dot(r10.xyz, r2.xyz);
    r0.xyz = (r1.xyz) * (r0.xyz) + (-(v5.xyz));
    r2.w = max(c13.x, r1.w);
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v5.xyz);
    r1.w = pow(abs(r2.w), c13.y);
    r0.xyz = max(((r0.xyz) * (c[36].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.w) + (-(c4.x));
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = (r1.w) * (r0.w) + (c4.x);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
