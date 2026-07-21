// Mechanically reconstructed from 0x8B90728F.ps_3_0.cso.
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
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD8;
    float4 v4 : TEXCOORD2;
    float4 v5 : TEXCOORD3;
    float4 v6 : TEXCOORD4;
    float4 v7 : TEXCOORD5;
    float4 v8 : TEXCOORD6;
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
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(-0.5f, 0.0f, 1.0f, 8.0f);
    const float4 c3 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c4 = float4(1.0f, 0.5f, 0.0f, 4.0f);
    const float4 c12 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c13 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c14 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c15 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c16 = float4(3.5f, -13.0f, 1.0f, 13.0f);
    const float4 c38 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v1.zw) * (c4.xy);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v1.zw);
    r3.xy = (r2.xy) * (c3.ww);
    r5.xy = (r0.xz) * (r3.xx);
    r0.x = r0.y;
    r0.w = (r2.x) * (c3.w) + (-(r5.x));
    r0.w = (r0.z) * (-(r3.x)) + (r0.w);
    r1.xy = (v1.zw) * (c4.xy) + (c4.zy);
    r1 = tex2D(s13, r1.xy);
    r6.xy = (r3.yy) * (r1.xz);
    r8.y = (r0.w) + (r0.w);
    r0.w = (r2.y) * (c3.w) + (-(r6.x));
    r0.w = (r1.z) * (-(r3.y)) + (r0.w);
    r0.y = r1.y;
    r7.xy = (r0.xy) * (c38.xx) + (c38.yy);
    r3.y = (r0.w) + (r0.w);
    r0 = tex2D(s1, v1.xy);
    r1.xy = (r0.wy) * (c0.xy) + (c0.zw);
    r2 = tex2D(s0, v1.xy);
    r0 = tex2D(s6, v8.zw);
    r0.w = (r0.w) * (v0.z);
    r4.xy = (r0.ww) * (-(r1.xy)) + (r1.xy);
    r3.w = dot(r7.xy, r4.xy) + (c1.y);
    r1 = tex2D(s5, v8.xy);
    r2.w = (r1.w) * (v0.y) + (c1.x);
    r1.w = dot(r4.xy, r4.xy) + (c1.y);
    r3.z = dot(r7.xy, r7.xy) + (c1.y);
    r1.w = exp2(-(r1.w));
    r3.z = exp2(-(r3.z));
    r1.w = (r1.w) * (c3.x) + (c3.y);
    r3.z = (r3.z) * (c3.x) + (c3.y);
    r2.xyz = float3(((r2.w) >= 0.0f ? (r1.x) : (r2.x)), ((r2.w) >= 0.0f ? (r1.y) : (r2.y)), ((r2.w) >= 0.0f ? (r1.z) : (r2.z)));
    r1.z = (r1.w) * (r3.z);
    r3.w = saturate((r3.w) * (r1.z) + (r1.z));
    r3.xz = (r6.xy) * (c4.ww);
    r1.xyz = lerp(r2.xyz, r0.xyz, r0.www);
    r0.xyz = (r3.xyz) * (r3.www);
    r8.xz = (r5.xy) * (c4.ww);
    r12.yz = c1.yz;
    r2.xyz = float3(((r2.w) >= 0.0f ? (r12.y) : (c[36].x)), ((r2.w) >= 0.0f ? (r12.z) : (c[36].y)), ((r2.w) >= 0.0f ? (r12.y) : (c[36].w)));
    r0.xyz = (r8.xyz) * (r1.www) + (r0.xyz);
    r7.xyz = lerp(r2.xyz, c1.zzz, r0.www);
    r6.xyz = (r1.xyz) * (r1.xyz);
    r11.xyz = (r0.xyz) * (r7.yyy);
    r1 = tex2D(s12, v1.zw);
    r0 = v2;
    r0.xyz = (r4.xxx) * (v5.xyz) + (r0.xyz);
    r0.xyz = (r4.yyy) * (v4.xyz) + (r0.xyz);
    r9.xyz = normalize(r0.xyz);
    r8.w = saturate(dot(r9.xyz, c[17].xyz));
    r0.z = ((-abs(r1.y)) >= 0.0f ? (c1.z) : (c1.y));
    r10.xyz = (r8.www) * (c[18].xyz);
    if ((r0.z) != (-(r0.z)))
    {
        r0.z = r1.y;
        r4.w = r0.z;
    }
    else
    {
        if ((c1.z) >= (v6.w))
        {
            r2 = (v6.xyzx) * (c1.zzzy);
            r1 = (r2) + (-(c12.xyzz));
            r1 = tex2Dlod(s2, r1);
            r1.w = r1.x;
            r3 = (r2) + (c14.xxyy);
            r3 = tex2Dlod(s2, r3);
            r1.x = r3.x;
            r3 = (r2) + (c14.zzyy);
            r3 = tex2Dlod(s2, r3);
            r1.y = r3.x;
            r2 = (r2) + (c12.xyzz);
            r2 = tex2Dlod(s2, r2);
            r1.z = r2.x;
            r0.z = dot(r1, c13.zzzz);
            if ((c13.w) < (v6.w))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r0.xy) + (c14.xx);
                r1.zw = (v6.zx) * (c1.zy);
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r0.xy) + (c14.zz);
                r2.zw = (v6.zx) * (c1.zy);
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (c12.xy);
                r2.zw = (v6.zx) * (c1.zy);
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r0.xy) + (-(c12.xy));
                r2.zw = (v6.zx) * (c1.zy);
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.y = dot(r1, c13.zzzz);
                r0.x = (-(r0.z)) + (r0.y);
                r0.y = (v6.w) * (c15.x) + (c15.y);
                r4.w = (r0.y) * (r0.x) + (r0.z);
            }
            else
            {
                r4.w = r0.z;
            }
        }
        else
        {
            r0.z = (v6.w) + (-(c4.w));
            r0.z = ((r0.z) >= 0.0f ? (c1.y) : (c1.z));
            if ((r0.z) != (-(r0.z)))
            {
                r0.xy = (v6.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r0.xy) + (c14.xx);
                r2.zw = (v6.zz) * (c1.zy);
                r2 = tex2Dlod(s2, r2);
                r3.xy = (r0.xy) + (c14.zz);
                r3.zw = (v6.zz) * (c1.zy);
                r5 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (c12.xy);
                r3.zw = (v6.zz) * (c1.zy);
                r4 = tex2Dlod(s2, r3);
                r3.xy = (r0.xy) + (-(c12.xy));
                r3.zw = (v6.zz) * (c1.zy);
                r3 = tex2Dlod(s2, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r0.x = dot(r2, c13.zzzz);
                r0.z = saturate((v6.w) + (c14.w));
                r0.y = (r1.y) + (-(r0.x));
                r0.z = (r0.z) * (r0.y) + (r0.x);
            }
            else
            {
                r0.z = r1.y;
            }
            r4.w = r0.z;
        }
    }
    r3.xyz = (r4.www) * (r10.xyz) + (r11.xyz);
    r0.xyz = (-(v7.xyz)) + (c[20].xyz);
    r1.z = dot(v7.xyz, v7.xyz);
    r1.w = dot(r0.xyz, r0.xyz);
    r2.w = rsqrt(r1.z);
    r1.w = rsqrt(r1.w);
    r1.xyz = (r2.www) * (v7.xyz);
    r4.xyz = (v7.xyz) * (-(r2.www)) + (c[17].xyz);
    r2.xyz = (r0.xyz) * (r1.www) + (-(r1.xyz));
    r5.xyz = normalize(r4.xyz);
    r10.xyz = normalize(r2.xyz);
    r11.xyz = (r0.xyz) * (r1.www);
    r0.y = saturate(dot(r5.xyz, c[17].xyz));
    r0.z = saturate(dot(r10.xyz, r11.xyz));
    r3.w = dot(r11.xyz, c[29].xyz);
    r0.z = (-(r0.z)) + (c1.z);
    r0.y = (-(r0.y)) + (c1.z);
    r1.w = (r0.z) * (r0.z);
    r0.x = (r0.y) * (r0.y);
    r1.w = (r1.w) * (r1.w);
    r0.x = (r0.x) * (r0.x);
    r0.z = (r0.z) * (r1.w);
    r2 = tex2D(s7, v1.xy);
    r4.xyz = (r2.xyz) * (-(r2.xyz)) + (c1.zzz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r7.y = (r0.y) * (r0.x);
    r0.xyz = (r4.xyz) * (r0.zzz) + (r2.xyz);
    r10.w = (r2.w) * (-(c38.z)) + (c38.w);
    r11.w = (r2.w) * (c3.z);
    r5.w = saturate(dot(r11.xyz, r9.xyz));
    r7.w = saturate(dot(r9.xyz, -(r1.xyz)));
    r1.w = (r5.w) * (r10.w) + (r11.w);
    r9.w = (r7.w) * (r10.w) + (r11.w);
    r6.w = (r1.w) * (r9.w) + (c13.x);
    r1.w = dot(r1.xyz, r9.xyz);
    r6.w = 1.0f / (r6.w);
    r11.z = (r1.w) + (r1.w);
    r1.w = (r2.w) * (c1.w);
    r1.xyz = (r9.xyz) * (-(r11.zzz)) + (r1.xyz);
    r1 = texCUBElod(s15, r1);
    r1.w = (-(r7.w)) + (c1.z);
    r7.w = (r1.w) * (r1.w);
    r12.xy = (r2.ww) * (c16.xy) + (c16.zw);
    r1.w = (r1.w) * (r7.w);
    r2.w = 1.0f / (r12.x);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (r1.w) * (r2.w);
    r1.xyz = (r7.xxx) * (r1.xyz);
    r11.xyz = (r4.xyz) * (r1.www) + (r2.xyz);
    r2.w = (r5.w) * (r6.w);
    r1.xyz = (r1.xyz) * (r11.xyz);
    r7.w = exp2(r12.y);
    r6.w = saturate(dot(r9.xyz, r10.xyz));
    r1.w = (r7.w) * (c13.y) + (c13.z);
    r7.x = (r8.w) * (r10.w) + (r11.w);
    r9.w = (r7.x) * (r9.w) + (c13.x);
    r7.x = saturate(dot(r9.xyz, r5.xyz));
    r5.y = 1.0f / (r9.w);
    r5.z = pow(abs(r7.x), r7.w);
    r5.y = (r8.w) * (r5.y);
    r5.z = (r1.w) * (r5.z);
    r5.z = (r5.y) * (r5.z);
    r2.xyz = (r4.xyz) * (r7.yyy) + (r2.xyz);
    r4.z = pow(abs(r6.w), r7.w);
    r2.xyz = (r5.zzz) * (r2.xyz);
    r1.w = (r1.w) * (r4.z);
    r2.xyz = (r7.zzz) * (r2.xyz);
    r1.w = (r2.w) * (r1.w);
    r2.xyz = (r2.xyz) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (r1.www);
    r2.xyz = (r4.www) * (r2.xyz);
    r2.xyz = (r6.xyz) * (r3.xyz) + (r2.xyz);
    r1.xyz = (r8.xyz) * (r1.xyz);
    r8.xyz = (r1.xyz) * (c1.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r2.xyz = (r7.zzz) * (r0.xyz);
    r1 = (v7.yyyy) * (c[32]);
    r0.z = saturate((r3.w) * (c[30].x) + (c[30].y));
    r1 = (v7.xxxx) * (c[31]) + (r1);
    r0.y = (r0.z) * (c15.z) + (c15.w);
    r1 = (v7.zzzz) * (c[33]) + (r1);
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
    r2 = tex2Dproj(s3, r2);
    r2.w = r2.x;
    r5.xy = (r3.ww) * (-(c[35].xy)) + (r4.xy);
    r5 = tex2Dproj(s3, r5);
    r2.y = r5.x;
    r3.xy = (r3.ww) * (c[35].xy) + (r4.xy);
    r5 = tex2Dproj(s3, r3);
    r2.x = r5.x;
    r1.xy = (r3.ww) * (c[35].zw) + (r4.xy);
    r1 = tex2Dproj(s3, r1);
    r2.z = r1.x;
    r1 = (v7.xyzx) * (c1.zzzy) + (c1.yyyz);
    r6.w = dot(r2, c13.zzzz);
    r0.z = dot(r1, c[28]);
    r2.w = 1.0f / (r0.z);
    r2.x = dot(r1, c[27]);
    r0.x = dot(r1, c[25]);
    r2.y = (r2.x) * (r2.x);
    r0.y = dot(r1, c[26]);
    r0.z = dot(c[23].yz, r2.xy) + (c[23].x);
    r1.w = saturate(1.0f / (r0.z));
    r1.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r1.xy) * (c15.zz) + (c15.ww);
    r1.xy = (r1.xy) * (r1.xy);
    r0.z = ((-abs(r0.z)) >= 0.0f ? (c1.y) : (r1.w));
    r1.w = (r2.x) * (r1.x);
    r0.z = (r0.z) * (r1.w);
    r1.w = (r1.y) * (-(r2.y)) + (c1.z);
    r0.xy = (r2.ww) * (r0.xy);
    r0.z = (r0.z) * (r1.w);
    r7.w = (r7.w) * (r0.z);
    r0.xy = (r0.xy) * (-(c1.xx)) + (-(c1.xx));
    r5 = tex2D(s4, r0.xy);
    r4 = (-(v7.yyyy)) + (c[6]);
    r3 = (-(v7.xxxx)) + (c[5]);
    r1 = (r4) * (r4);
    r1 = (r3) * (r3) + (r1);
    r2 = (-(v7.zzzz)) + (c[7]);
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
    r1 = saturate((r1) * (c[8]) + (r12.zzzz));
    r0.xyz = (r6.www) * (r0.xyz);
    r1 = (r2) * (r1);
    r2.xyz = (r0.xyz) * (r7.xyz) + (r8.xyz);
    r0.z = dot(c[11], r1);
    r0.x = dot(c[9], r1);
    r0.y = dot(c[10], r1);
    r0.xyz = (r6.xyz) * (r0.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v3.xyz));
    r0.xyz = (r0.www) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c1.z;

    return oC0;
}
