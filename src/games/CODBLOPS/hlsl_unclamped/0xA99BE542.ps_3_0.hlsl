// Mechanically reconstructed from 0xA99BE542.ps_3_0.cso.
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
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD4;
    float4 v5 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(-0.5f, 1.0f, 0.0f, 8.0f);
    const float4 c1 = float4(31.875f, 4.0f, -2.0f, 0.0009765625f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.125f, 0.25f);
    const float4 c4 = float4(0.000244140625f, 0.0f, -0.000244140625f, 0.75f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, -3.0f);
    const float4 c13 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c14 = float4(0.797884583f, 1.0f, 0.5f, 0.0f);
    const float4 c15 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c14.yz);
    r0 = tex2D(s13, r0.xy);
    r1 = tex2D(s14, v1.zw);
    r5.xy = (r1.xy) * (c1.xx);
    r4.xy = (r0.xz) * (r5.xx);
    r0.w = (r1.x) * (c1.x) + (-(r4.x));
    r2.x = r0.y;
    r0.w = (r0.z) * (-(r5.x)) + (r0.w);
    r8.y = (r0.w) + (r0.w);
    r0.xy = (v1.zw) * (c14.yz) + (c14.wz);
    r0 = tex2D(s13, r0.xy);
    r2.y = r0.y;
    r3.xy = (r5.yy) * (r0.xz);
    r0.xy = (r2.xy) * (c1.yy) + (c1.zz);
    r1.w = (r1.y) * (c1.x) + (-(r3.x));
    r0.w = dot(r0.xy, r0.xy) + (c0.z);
    r0.z = (r0.z) * (-(r5.y)) + (r1.w);
    r0.w = exp2(-(r0.w));
    r0.y = (r0.z) + (r0.z);
    r0.w = saturate((r0.w) * (c3.x) + (c3.y));
    r8.xz = (r4.xy) * (c1.yy);
    r0.xz = (r3.xy) * (c1.yy);
    r1.xyz = (r0.xyz) * (r0.www) + (r8.xyz);
    r1.w = dot(v5.xyz, v5.xyz);
    r0 = tex2D(s0, v1.xy);
    r7.w = (r0.w) * (v0.w) + (c0.x);
    r0 = (r0.xyzx) * (c0.yyyz) + (c0.zzzy);
    r9.w = rsqrt(r1.w);
    r0 = float4(((r7.w) >= 0.0f ? (r0.x) : (c0.z)), ((r7.w) >= 0.0f ? (r0.y) : (c0.z)), ((r7.w) >= 0.0f ? (r0.z) : (c0.z)), ((r7.w) >= 0.0f ? (r0.w) : (c0.z)));
    r0.xyz = (r0.xyz) * (v0.xyz);
    r13.yz = c0.yz;
    r7.xyz = float3(((r7.w) >= 0.0f ? (c[36].x) : (r13.z)), ((r7.w) >= 0.0f ? (c[36].y) : (r13.z)), ((r7.w) >= 0.0f ? (c[36].w) : (r13.z)));
    r6.xyz = (r0.xyz) * (r0.xyz);
    r11.xyz = (r1.xyz) * (r7.yyy);
    r1 = tex2D(s12, v1.zw);
    r9.xyz = normalize(v2.xyz);
    r8.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c0.y) : (c0.z));
    r10.xyz = (r8.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r6.w = r0.z;
    }
    else
    {
        if ((c0.y) >= (v4.w))
        {
            r2 = (v4.xyzx) * (c0.yyyz);
            r1 = (r2) + (-(c12.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c4.xxyy);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (c4.zzyy);
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c12.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r6.w = dot(r1, c3.wwww);
            if ((c4.w) < (v4.w))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c4.xx);
                r1.zw = (v4.zx) * (c0.yz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r0.xy) + (c4.zz);
                r2.zw = (v4.zx) * (c0.yz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (c12.xy);
                r2.zw = (v4.zx) * (c0.yz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r0.xy) + (-(c12.xy));
                r2.zw = (v4.zx) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.z = dot(r1, c3.wwww);
                r0.y = (-(r6.w)) + (r0.z);
                r0.z = (v4.w) * (c13.x) + (c13.y);
                r6.w = (r0.z) * (r0.y) + (r6.w);
            }
        }
        else
        {
            r0.z = (v4.w) + (-(c1.y));
            r0.z = ((r0.z) >= 0.0f ? (c0.z) : (c0.y));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v4.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c4.xx);
                r2.zw = (v4.zz) * (c0.yz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r0.xy) + (c4.zz);
                r3.zw = (v4.zz) * (c0.yz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (c12.xy);
                r3.zw = (v4.zz) * (c0.yz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r0.xy) + (-(c12.xy));
                r3.zw = (v4.zz) * (c0.yz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c3.wwww);
                r0.z = saturate((v4.w) + (c12.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r6.w = r0.z;
        }
    }
    r0.xyz = (-(v5.xyz)) + (c[20].xyz);
    r3.xyz = (r6.www) * (r10.xyz) + (r11.xyz);
    r1.w = dot(r0.xyz, r0.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = (v5.xyz) * (-(r9.www)) + (c[17].xyz);
    r2.xyz = (r9.www) * (v5.xyz);
    r12.xyz = normalize(r1.xyz);
    r1.xyz = (r0.xyz) * (r1.www) + (-(r2.xyz));
    r2.w = saturate(dot(r12.xyz, c[17].xyz));
    r4.xyz = normalize(r1.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r1.w = saturate(dot(r4.xyz, r0.xyz));
    r3.w = dot(r0.xyz, c[29].xyz);
    r1.y = (-(r2.w)) + (c0.y);
    r1.w = (-(r1.w)) + (c0.y);
    r1.x = (r1.y) * (r1.y);
    r1.z = (r1.w) * (r1.w);
    r1.x = (r1.x) * (r1.x);
    r1.z = (r1.z) * (r1.z);
    r7.y = (r1.y) * (r1.x);
    r2.w = (r1.w) * (r1.z);
    r1 = tex2D(s4, v1.xy);
    r1 = float4(((r7.w) >= 0.0f ? (r1.x) : (c0.z)), ((r7.w) >= 0.0f ? (r1.y) : (c0.z)), ((r7.w) >= 0.0f ? (r1.z) : (c0.z)), ((r7.w) >= 0.0f ? (r1.w) : (c0.y)));
    r10.xyz = (r1.xyz) * (-(r1.xyz)) + (c0.yyy);
    r11.xyz = (r1.xyz) * (r1.xyz);
    r10.w = (r1.w) * (-(c14.x)) + (c14.y);
    r11.w = (r1.w) * (c14.x);
    r5.w = saturate(dot(r0.xyz, r9.xyz));
    r5.z = saturate(dot(r9.xyz, -(r2.xyz)));
    r1.z = (r5.w) * (r10.w) + (r11.w);
    r9.w = (r5.z) * (r10.w) + (r11.w);
    r0.xyz = (r10.xyz) * (r2.www) + (r11.xyz);
    r1.z = (r1.z) * (r9.w) + (c1.w);
    r1.y = 1.0f / (r1.z);
    r1.z = dot(r2.xyz, r9.xyz);
    r4.w = (r5.w) * (r1.y);
    r1.z = (r1.z) + (r1.z);
    r2.w = (r1.w) * (c0.w);
    r2.xyz = (r9.xyz) * (-(r1.zzz)) + (r2.xyz);
    r2 = texCUBElod(s15, r2);
    r1.xyz = (r2.xyz) * (r2.xyz);
    r2.w = (-(r5.z)) + (c0.y);
    r2.z = (r2.w) * (r2.w);
    r2.xy = (r1.ww) * (c15.xy) + (c15.zw);
    r1.w = (r2.w) * (r2.z);
    r2.w = 1.0f / (r2.x);
    r1.xyz = (r7.xxx) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r5.xyz = (r10.xyz) * (r1.www) + (r11.xyz);
    r7.w = exp2(r2.y);
    r1.w = (r7.w) * (c3.z) + (c3.w);
    r2.w = (r8.w) * (r10.w) + (r11.w);
    r2.w = (r2.w) * (r9.w) + (c1.w);
    r7.x = saturate(dot(r9.xyz, r12.xyz));
    r2.z = 1.0f / (r2.w);
    r2.w = pow(abs(r7.x), r7.w);
    r2.z = (r8.w) * (r2.z);
    r2.w = (r1.w) * (r2.w);
    r2.w = (r2.z) * (r2.w);
    r2.xyz = (r10.xyz) * (r7.yyy) + (r11.xyz);
    r1.xyz = (r1.xyz) * (r5.xyz);
    r2.xyz = (r2.www) * (r2.xyz);
    r4.z = saturate(dot(r9.xyz, r4.xyz));
    r2.xyz = (r7.zzz) * (r2.xyz);
    r2.w = pow(abs(r4.z), r7.w);
    r2.xyz = (r2.xyz) * (c[19].xyz);
    r1.w = (r1.w) * (r2.w);
    r2.xyz = (r6.www) * (r2.xyz);
    r1.w = (r4.w) * (r1.w);
    r2.xyz = (r6.xyz) * (r3.xyz) + (r2.xyz);
    r1.xyz = (r8.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r8.xyz = (r1.xyz) * (c0.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r2.xyz = (r7.zzz) * (r0.xyz);
    r1 = (v5.yyyy) * (c[32]);
    r0.z = saturate((r3.w) * (c[30].x) + (c[30].y));
    r1 = (v5.xxxx) * (c[31]) + (r1);
    r0.y = (r0.z) * (c13.z) + (c13.w);
    r1 = (v5.zzzz) * (c[33]) + (r1);
    r0.z = (r0.z) * (r0.z);
    r4 = (r1) + (c[34]);
    r7.w = (r0.y) * (r0.z);
    r3.zw = r4.zw;
    r0.xyz = (r5.www) * (c[21].xyz);
    r5.zw = r3.zw;
    r7.xyz = (r6.xyz) * (r0.xyz) + (r2.xyz);
    r1.zw = r5.zw;
    r2.xy = (r4.ww) * (-(c[35].zw)) + (r4.xy);
    r2.zw = r1.zw;
    r2 = tex2Dproj(s2, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[35].xy)) + (r4.xy);
    r5 = tex2Dproj(s2, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[35].xy) + (r4.xy);
    r5 = tex2Dproj(s2, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[35].zw) + (r4.xy);
    r1 = tex2Dproj(s2, r1);
    r2.z = r1.x;
    r1 = (v5.xyzx) * (c0.yyyz) + (c0.zzzy);
    r6.w = dot(r2, c3.wwww);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r2.x = dot(r1, c[27]);
    r0.x = dot(r1, c[25]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r1.xy) * (c13.zz) + (c13.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c0.z) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c0.y);
    r0.xy = (r2.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r7.w = (r7.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c0.xx)) + (-(c0.xx));
    r5 = tex2D(s3, r0.xy);
    r4 = (-(v5.yyyy)) + (c[6]);
    r3 = (-(v5.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v5.zzzz)) + (c[7]);
    r1 = (r2) * (r2) + (r1);
    r0.xyz = (r5.xyz) * (r5.xyz);
    r5.x = rsqrt(r1.x);
    r5.y = rsqrt(r1.y);
    r5.z = rsqrt(r1.z);
    r5.w = rsqrt(r1.w);
    r0.xyz = (r7.www) * (r0.xyz);
    r4 = (r4) * (r5);
    r4 = (r9.yyyy) * (r4);
    r3 = (r3) * (r5);
    r2 = (r2) * (r5);
    r3 = (r3) * (r9.xxxx) + (r4);
    r2 = saturate((r2) * (r9.zzzz) + (r3));
    r1 = saturate((r1) * (c[8]) + (r13.yyyy));
    r0.xyz = (r6.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r7.xyz) + (r8.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r6.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r1.x = v2.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
