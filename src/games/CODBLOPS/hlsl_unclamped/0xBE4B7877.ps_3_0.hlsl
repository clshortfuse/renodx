// Mechanically reconstructed from 0xBE4B7877.ps_3_0.cso.
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
sampler2D s8 : register(s8);
sampler2D s9 : register(s9);
sampler2D s10 : register(s10);
sampler2D s11 : register(s11);
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : COLOR0;
    float4 v1 : TEXCOORD0;
    float4 v2 : TEXCOORD1;
    float4 v3 : TEXCOORD2;
    float4 v4 : TEXCOORD3;
    float4 v5 : TEXCOORD4;
    float4 v6 : TEXCOORD5;
    float4 v7 : TEXCOORD6;
    float4 v8 : COLOR1;
    float4 v9 : TEXCOORD7;
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
    float4 v9 = input.v9;
    const float4 c1 = float4(2.0f, -1.0f, 0.0f, -0.5f);
    const float4 c3 = float4(0.0f, 1.0f, 0.200000003f, 8.0f);
    const float4 c4 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c12 = float4(0.600000024f, 0.400000006f, 0.797884583f, 31.875f);
    const float4 c13 = float4(4.0f, -2.0f, 0.797884583f, 1.0f);
    const float4 c14 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c15 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c16 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c41 = float4(4.0f, -3.0f, -2.0f, 3.0f);
    const float4 c42 = float4(3.5f, -13.0f, 1.0f, 13.0f);
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
    float4 r16 = 0.0f;
    float4 oC0 = 0.0f;

    r0 = tex2D(s7, v7.xy);
    r2.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0 = (c1.xxxx) * (v8) + (c1.yyyy);
    r1.y = dot(r2.xy, r0.zw) + (c1.z);
    r1.x = dot(r2.xy, r0.xy) + (c1.z);
    r0 = tex2D(s1, v1.xy);
    r3.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0 = tex2D(s8, v7.zw);
    r2.xy = (r0.wy) * (c4.xy) + (c4.zw);
    r0 = tex2D(s5, v7.xy);
    r6.w = (r0.w) * (v0.y) + (c1.w);
    r6.xy = float2(((r6.w) >= 0.0f ? (r1.x) : (r3.x)), ((r6.w) >= 0.0f ? (r1.y) : (r3.y)));
    r1 = (c1.xxxx) * (v9) + (c1.yyyy);
    r5.y = dot(r2.xy, r1.zw) + (c1.z);
    r5.x = dot(r2.xy, r1.xy) + (c1.z);
    r1 = tex2D(s0, v1.xy);
    r4.xyz = float3(((r6.w) >= 0.0f ? (r0.x) : (r1.x)), ((r6.w) >= 0.0f ? (r0.y) : (r1.y)), ((r6.w) >= 0.0f ? (r0.z) : (r1.z)));
    r0 = tex2D(s10, v7.xy);
    r2 = (r0.wwww) * (c3.xxxy) + (c3.zzzx);
    r3 = tex2D(s9, v1.xy);
    r1 = tex2D(s6, v7.zw);
    r5.w = (r1.w) * (v0.z);
    r3 = float4(((r6.w) >= 0.0f ? (r2.x) : (r3.x)), ((r6.w) >= 0.0f ? (r2.y) : (r3.y)), ((r6.w) >= 0.0f ? (r2.z) : (r3.z)), ((r6.w) >= 0.0f ? (r2.w) : (r3.w)));
    r11.xy = lerp(r6.xy, r5.xy, r5.ww);
    r2.xyz = lerp(r4.xyz, r1.xyz, r5.www);
    r0.w = dot(r11.xy, r11.xy) + (c1.z);
    r5.xyz = (r2.xyz) * (r2.xyz);
    r0.w = exp2(-(r0.w));
    r0.w = (r0.w) * (c12.x) + (c12.y);
    r0.z = dot(v6.xyz, v6.xyz);
    r8.w = rsqrt(r0.z);
    r1.xy = (v1.zw) * (-(c1.yw));
    r4 = tex2D(s13, r1.xy);
    r1.xy = (v1.zw) * (-(c1.yw)) + (-(c1.zw));
    r1 = tex2D(s13, r1.xy);
    r4.w = r1.y;
    r2 = tex2D(s14, v1.zw);
    r7.xy = (r2.xy) * (c12.ww);
    r8.xy = (r4.yw) * (c13.xx) + (c13.yy);
    r4.xy = (r4.xz) * (r7.xx);
    r0.z = dot(r8.xy, r11.xy) + (c1.z);
    r0.x = (r2.x) * (c12.w) + (-(r4.x));
    r1.y = (r4.z) * (-(r7.x)) + (r0.x);
    r6.xy = (r1.xz) * (r7.yy);
    r1.w = (r2.y) * (c12.w) + (-(r6.x));
    r0.x = dot(r8.xy, r8.xy) + (c1.z);
    r1.w = (r1.z) * (-(r7.y)) + (r1.w);
    r0.x = exp2(-(r0.x));
    r9.y = (r1.y) + (r1.y);
    r0.x = (r0.x) * (c12.x) + (c12.y);
    r1.y = (r1.w) + (r1.w);
    r0.x = (r0.w) * (r0.x);
    r0.z = saturate((r0.z) * (r0.x) + (r0.x));
    r1.xz = (r6.xy) * (c13.xx);
    r1.xyz = (r1.xyz) * (r0.zzz);
    r9.xz = (r4.xy) * (c13.xx);
    r8.xyz = (r9.xyz) * (r0.www) + (r1.xyz);
    r10.xyz = float3(((r6.w) >= 0.0f ? (r0.y) : (c[39].x)), ((r6.w) >= 0.0f ? (r0.y) : (c[39].y)), ((r6.w) >= 0.0f ? (r0.y) : (c[39].w)));
    r1 = tex2D(s11, v7.zw);
    r0.xyz = (-(v6.xyz)) + (c[20].xyz);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r6.xyz = (r8.www) * (v6.xyz);
    r2 = (r1.wwww) * (c3.xxxy) + (c3.zzzx);
    r7.xyz = (r0.xyz) * (r0.www) + (-(r6.xyz));
    r4.xyz = normalize(r7.xyz);
    r7.xyz = (r0.xyz) * (r0.www);
    r0 = lerp(r3, r2, r5.wwww);
    r1.w = saturate(dot(r4.xyz, r7.xyz));
    r13.xyz = lerp(r10.xyz, r1.yyy, r5.www);
    r1.w = (-(r1.w)) + (-(c1.y));
    r12.xyz = (r8.xyz) * (r13.yyy);
    r1.z = (r1.w) * (r1.w);
    r11.w = (r0.w) * (-(c13.z)) + (c13.w);
    r1.z = (r1.z) * (r1.z);
    r14.xyz = (r0.xyz) * (-(r0.xyz)) + (-(c1.yyy));
    r1.w = (r1.w) * (r1.z);
    r15.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = v2.xyz;
    r1.xyz = (r11.xxx) * (v4.xyz) + (r0.xyz);
    r0.xyz = (r14.xyz) * (r1.www) + (r15.xyz);
    r1.xyz = (r11.yyy) * (v3.xyz) + (r1.xyz);
    r12.w = (r0.w) * (c12.z);
    r10.xyz = normalize(r1.xyz);
    r6.w = saturate(dot(r7.xyz, r10.xyz));
    r1.w = saturate(dot(r10.xyz, -(r6.xyz)));
    r1.z = (r6.w) * (r11.w) + (r12.w);
    r10.w = (r1.w) * (r11.w) + (r12.w);
    r5.w = dot(r7.xyz, c[29].xyz);
    r1.z = (r1.z) * (r10.w) + (c14.x);
    r1.y = 1.0f / (r1.z);
    r2.xy = (r0.ww) * (c42.xy) + (c42.zw);
    r9.w = exp2(r2.y);
    r2.w = saturate(dot(r10.xyz, r4.xyz));
    r1.z = pow(abs(r2.w), r9.w);
    r7.w = (r9.w) * (c14.y) + (c14.z);
    r1.y = (r6.w) * (r1.y);
    r1.z = (r1.z) * (r7.w);
    r0.w = (r0.w) * (c3.w);
    r1.z = (r1.y) * (r1.z);
    r0.xyz = (r0.xyz) * (r1.zzz);
    r1.xyz = (v6.xyz) * (-(r8.www)) + (c[17].xyz);
    r16.xyz = normalize(r1.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r13.w = saturate(dot(r16.xyz, c[17].xyz));
    r7.xyz = (r13.zzz) * (r0.xyz);
    r0.x = 1.0f / (r2.x);
    r0.y = (-(r1.w)) + (-(c1.y));
    r1.w = (r0.y) * (r0.y);
    r0.z = dot(r6.xyz, r10.xyz);
    r0.y = (r0.y) * (r1.w);
    r0.z = (r0.z) + (r0.z);
    r1.w = (r0.x) * (r0.y);
    r0.xyz = (r10.xyz) * (-(r0.zzz)) + (r6.xyz);
    r0 = texCUBElod(s15, r0);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r13.xxx) * (r0.xyz);
    r1.xyz = (r14.xyz) * (r1.www) + (r15.xyz);
    r8.xyz = (r0.xyz) * (r1.xyz);
    r8.w = saturate(dot(r10.xyz, c[17].xyz));
    r0 = tex2D(s12, v1.zw);
    r0.w = ((-abs(r0.y)) >= 0.0f ? (-(c1.y)) : (-(c1.z)));
    r11.xyz = (r8.www) * (c[18].xyz);
    if ((r0.w) != (-(r0.w)))
    {
        r0.w = r0.y;
    }
    else
    {
        if ((-(c1.y)) >= (v5.w))
        {
            r1 = (v5.xyzx) * (-(c1.yyyz));
            r0 = (r1) + (-(c16.xyzz));
            r0 = tex2Dlod(s2, r0);
            r0.w = r0.x;
            r2 = (r1) + (c15.xxyy);
            r2 = tex2Dlod(s2, r2);
            r0.x = r2.x;
            r2 = (r1) + (c15.zzyy);
            r2 = tex2Dlod(s2, r2);
            r0.y = r2.x;
            r1 = (r1) + (c16.xyzz);
            r1 = tex2Dlod(s2, r1);
            r0.z = r1.x;
            r4.w = dot(r0, c14.zzzz);
            if ((c14.w) < (v5.w))
            {
                r4.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r0.xy = (r4.xy) + (c15.xx);
                r0.zw = (v5.zx) * (-(c1.yz));
                r0 = tex2Dlod(s2, r0);
                r1.xy = (r4.xy) + (c15.zz);
                r1.zw = (v5.zx) * (-(c1.yz));
                r3 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (c16.xy);
                r1.zw = (v5.zx) * (-(c1.yz));
                r2 = tex2Dlod(s2, r1);
                r1.xy = (r4.xy) + (-(c16.xy));
                r1.zw = (v5.zx) * (-(c1.yz));
                r1 = tex2Dlod(s2, r1);
                r0.y = r3.x;
                r0.z = r2.x;
                r0.w = r1.x;
                r0.w = dot(r0, c14.zzzz);
                r0.z = (-(r4.w)) + (r0.w);
                r0.w = (v5.w) * (c41.x) + (c41.y);
                r0.w = (r0.w) * (r0.z) + (r4.w);
            }
            else
            {
                r0.w = r4.w;
            }
        }
        else
        {
            r0.w = (v5.w) + (-(c13.x));
            r0.w = ((r0.w) >= 0.0f ? (-(c1.z)) : (-(c1.y)));
            if ((r0.w) != (-(r0.w)))
            {
                r13.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r13.xy) + (c15.xx);
                r1.zw = (v5.zz) * (-(c1.yz));
                r1 = tex2Dlod(s2, r1);
                r2.xy = (r13.xy) + (c15.zz);
                r2.zw = (v5.zz) * (-(c1.yz));
                r4 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (c16.xy);
                r2.zw = (v5.zz) * (-(c1.yz));
                r3 = tex2Dlod(s2, r2);
                r2.xy = (r13.xy) + (-(c16.xy));
                r2.zw = (v5.zz) * (-(c1.yz));
                r2 = tex2Dlod(s2, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.x = dot(r1, c14.zzzz);
                r0.w = saturate((v5.w) + (c15.w));
                r0.z = (r0.y) + (-(r0.x));
                r0.w = (r0.w) * (r0.z) + (r0.x);
            }
            else
            {
                r0.w = r0.y;
            }
        }
    }
    r0.z = (-(r13.w)) + (-(c1.y));
    r0.y = (r0.z) * (r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.z = (r0.z) * (r0.y);
    r0.y = (r8.w) * (r11.w) + (r12.w);
    r0.y = (r0.y) * (r10.w) + (c14.x);
    r1.w = saturate(dot(r10.xyz, r16.xyz));
    r0.x = 1.0f / (r0.y);
    r0.y = pow(abs(r1.w), r9.w);
    r0.x = (r8.w) * (r0.x);
    r0.y = (r7.w) * (r0.y);
    r1.w = (r0.x) * (r0.y);
    r0.xyz = (r14.xyz) * (r0.zzz) + (r15.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r13.zzz) * (r0.xyz);
    r1.xyz = (r0.xyz) * (c[19].xyz);
    r0.xyz = (r0.www) * (r11.xyz) + (r12.xyz);
    r1.xyz = (r0.www) * (r1.xyz);
    r1.xyz = (r5.xyz) * (r0.xyz) + (r1.xyz);
    r0.xyz = (r9.xyz) * (r8.xyz);
    r9.xyz = (r0.xyz) * (c3.www) + (r1.xyz);
    r0 = (v6.yyyy) * (c[32]);
    r1.xyz = (r6.www) * (c[21].xyz);
    r0 = (v6.xxxx) * (c[31]) + (r0);
    r8.xyz = (r5.xyz) * (r1.xyz) + (r7.xyz);
    r0 = (v6.zzzz) * (c[33]) + (r0);
    r1.w = saturate((r5.w) * (c[30].x) + (c[30].y));
    r3 = (r0) + (c[34]);
    r0.z = (r1.w) * (c41.z) + (c41.w);
    r2.zw = r3.zw;
    r0.w = (r1.w) * (r1.w);
    r4.zw = r2.zw;
    r3.z = (r0.z) * (r0.w);
    r0.zw = r4.zw;
    r1.xy = (r3.ww) * (-(c[35].zw)) + (r3.xy);
    r1.zw = r0.zw;
    r1 = tex2Dproj(s3, r1);
    r1.w = r1.x;
    r4.xy = (r2.ww) * (-(c[35].xy)) + (r3.xy);
    r4 = tex2Dproj(s3, r4);
    r1.y = r4.x;
    r2.xy = (r2.ww) * (c[35].xy) + (r3.xy);
    r4 = tex2Dproj(s3, r2);
    r1.x = r4.x;
    r0.xy = (r2.ww) * (c[35].zw) + (r3.xy);
    r0 = tex2Dproj(s3, r0);
    r1.z = r0.x;
    r0 = (v6.xyzx) * (-(c1.yyyz)) + (-(c1.zzzy));
    r5.w = dot(r1, c14.zzzz);
    r1.w = dot(r0, c[28]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c41.zz) + (c41.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (-(c1.y));
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r6.w = (r3.z) * (r0.w);
    r0.xy = (r0.xy) * (-(c1.ww)) + (-(c1.ww));
    r4 = tex2D(s4, r0.xy);
    r3 = (-(v6.yyyy)) + (c[6]);
    r2 = (-(v6.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v6.zzzz)) + (c[7]);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r0 = (r1) * (r1) + (r0);
    r7.xyz = (r6.www) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r7.xyz = (r5.www) * (r7.xyz);
    r3 = (r3) * (r4);
    r3 = (r10.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r10.xxxx) + (r3);
    r1 = saturate((r1) * (r10.zzzz) + (r2));
    r2.z = c1.y;
    r0 = saturate((r0) * (c[8]) + (-(r2.zzzz)));
    r2.xyz = (r7.xyz) * (r8.xyz) + (r9.xyz);
    r0 = (r1) * (r0);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.w = dot(c[36].xyz, r6.xyz);
    r0.w = saturate((c[38].y) * (r0.w) + (c[38].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[37].xyz);
    r1.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.www) * (r0.xyz) + (c[0].xyz);
    r1.xyz = (r0.xyz) * (-(c[0].www)) + (r1.xyz);
    r1.xyz = (r1.xyz) * (v2.www);
    r0.xyz = (r0.xyz) * (c[0].www) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[40].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = -(c1.y);

    return oC0;
}
