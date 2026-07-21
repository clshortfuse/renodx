// Mechanically reconstructed from 0xA47D4B23.ps_3_0.cso.
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
sampler2D s12 : register(s12);
sampler2D s13 : register(s13);
sampler2D s14 : register(s14);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD8;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
    float4 v5 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    const float4 c0 = float4(-0.5f, 1.0f, 8.0f, 0.797884583f);
    const float4 c1 = float4(1.0f, 0.5f, 0.0f, 31.875f);
    const float4 c3 = float4(4.0f, -2.0f, 0.600000024f, 0.400000006f);
    const float4 c4 = float4(0.0009765625f, 0.125f, 0.25f, 0.75f);
    const float4 c12 = float4(0.000244140625f, 0.0f, -0.000244140625f, -3.0f);
    const float4 c13 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.0f);
    const float4 c14 = float4(4.0f, -3.0f, -2.0f, 3.0f);
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
    float4 oC0 = 0.0f;

    r0.xy = (v0.zw) * (c1.xy);
    r0 = tex2D(s13, r0.xy);
    r2 = tex2D(s14, v0.zw);
    r5.xy = (r2.xy) * (c1.ww);
    r4.xy = (r0.xz) * (r5.xx);
    r0.w = (r2.x) * (c1.w) + (-(r4.x));
    r1.x = r0.y;
    r0.w = (r0.z) * (-(r5.x)) + (r0.w);
    r7.y = (r0.w) + (r0.w);
    r0.xy = (v0.zw) * (c1.xy) + (c1.zy);
    r0 = tex2D(s13, r0.xy);
    r3.xy = (r5.yy) * (r0.xz);
    r1.y = r0.y;
    r0.w = (r2.y) * (c1.w) + (-(r3.x));
    r0.xy = (r1.xy) * (c3.xx) + (c3.yy);
    r0.z = (r0.z) * (-(r5.y)) + (r0.w);
    r0.w = dot(r0.xy, r0.xy) + (c1.z);
    r0.y = (r0.z) + (r0.z);
    r0.w = exp2(-(r0.w));
    r1.w = saturate((r0.w) * (c3.z) + (c3.w));
    r7.xz = (r4.xy) * (c3.xx);
    r0.xz = (r3.xy) * (c3.xx);
    r0.w = dot(v4.xyz, v4.xyz);
    r2.xyz = (r0.xyz) * (r1.www) + (r7.xyz);
    r9.w = rsqrt(r0.w);
    r1 = tex2D(s12, v0.zw);
    r1.w = ((-abs(r1.y)) >= 0.0f ? (c1.x) : (c1.z));
    r0 = tex2D(s4, v5.zw);
    r7.w = (r0.w) * (v5.y) + (c0.x);
    r9.xyz = normalize(v1.xyz);
    r6.w = c0.y;
    r6.xyz = float3(((r7.w) >= 0.0f ? (r6.w) : (c[36].x)), ((r7.w) >= 0.0f ? (r6.w) : (c[36].y)), ((r7.w) >= 0.0f ? (r6.w) : (c[36].w)));
    r8.w = saturate(dot(r9.xyz, c[17].xyz));
    r10.xyz = (r2.xyz) * (r6.yyy);
    r8.xyz = (r8.www) * (c[18].xyz);
    if ((r1.w) != (-(r1.w)))
    {
        r0.w = r1.y;
        r5.w = r0.w;
    }
    else
    {
        if ((c0.y) >= (v3.w))
        {
            r2 = (v3.xyzx) * (c1.xxxz);
            r1 = (r2) + (-(c13.xyzz));
            r1 = tex2Dlod(s1, r1);
            r1.w = r1.x;
            r3 = (r2) + (c12.xxyy);
            r3 = tex2Dlod(s1, r3);
            r1.x = r3.x;
            r3 = (r2) + (c12.zzyy);
            r3 = tex2Dlod(s1, r3);
            r1.y = r3.x;
            r2 = (r2) + (c13.xyzz);
            r2 = tex2Dlod(s1, r2);
            r1.z = r2.x;
            r5.w = dot(r1, c4.zzzz);
            if ((c4.w) < (v3.w))
            {
                r5.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r1.xy = (r5.xy) + (c12.xx);
                r1.zw = (v3.zx) * (c1.xz);
                r1 = tex2Dlod(s1, r1);
                r2.xy = (r5.xy) + (c12.zz);
                r2.zw = (v3.zx) * (c1.xz);
                r4 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (c13.xy);
                r2.zw = (v3.zx) * (c1.xz);
                r3 = tex2Dlod(s1, r2);
                r2.xy = (r5.xy) + (-(c13.xy));
                r2.zw = (v3.zx) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r1.y = r4.x;
                r1.z = r3.x;
                r1.w = r2.x;
                r0.w = dot(r1, c4.zzzz);
                r1.w = (-(r5.w)) + (r0.w);
                r0.w = (v3.w) * (c14.x) + (c14.y);
                r5.w = (r0.w) * (r1.w) + (r5.w);
            }
        }
        else
        {
            r0.w = (v3.w) + (-(c3.x));
            r0.w = ((r0.w) >= 0.0f ? (c1.z) : (c1.x));
            if ((r0.w) != (-(r0.w)))
            {
                r11.xy = (v3.xy) * (c[2].ww) + (c[2].xy);
                r2.xy = (r11.xy) + (c12.xx);
                r2.zw = (v3.zz) * (c1.xz);
                r2 = tex2Dlod(s1, r2);
                r3.xy = (r11.xy) + (c12.zz);
                r3.zw = (v3.zz) * (c1.xz);
                r5 = tex2Dlod(s1, r3);
                r3.xy = (r11.xy) + (c13.xy);
                r3.zw = (v3.zz) * (c1.xz);
                r4 = tex2Dlod(s1, r3);
                r3.xy = (r11.xy) + (-(c13.xy));
                r3.zw = (v3.zz) * (c1.xz);
                r3 = tex2Dlod(s1, r3);
                r2.y = r5.x;
                r2.z = r4.x;
                r2.w = r3.x;
                r1.z = dot(r2, c4.zzzz);
                r0.w = saturate((v3.w) + (c12.w));
                r1.w = (r1.y) + (-(r1.z));
                r0.w = (r0.w) * (r1.w) + (r1.z);
            }
            else
            {
                r0.w = r1.y;
            }
            r5.w = r0.w;
        }
    }
    r1.xyz = (-(v4.xyz)) + (c[20].xyz);
    r2.xyz = (r5.www) * (r8.xyz) + (r10.xyz);
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = (v4.xyz) * (-(r9.www)) + (c[17].xyz);
    r8.xyz = (r9.www) * (v4.xyz);
    r11.xyz = normalize(r3.xyz);
    r3.xyz = (r1.xyz) * (r0.www) + (-(r8.xyz));
    r3.w = saturate(dot(r11.xyz, c[17].xyz));
    r4.xyz = normalize(r3.xyz);
    r12.xyz = (r1.xyz) * (r0.www);
    r0.w = saturate(dot(r4.xyz, r12.xyz));
    r2.w = dot(r12.xyz, c[29].xyz);
    r1 = tex2D(s0, v0.xy);
    r0.xyz = float3(((r7.w) >= 0.0f ? (r0.x) : (r1.x)), ((r7.w) >= 0.0f ? (r0.y) : (r1.y)), ((r7.w) >= 0.0f ? (r0.z) : (r1.z)));
    r1.z = (-(r3.w)) + (c0.y);
    r1.w = (r1.z) * (r1.z);
    r0.w = (-(r0.w)) + (c0.y);
    r1.y = (r1.w) * (r1.w);
    r1.w = (r0.w) * (r0.w);
    r7.w = (r1.z) * (r1.y);
    r1.w = (r1.w) * (r1.w);
    r1.z = (r0.w) * (r1.w);
    r5.xyz = (r0.xyz) * (r0.xyz);
    r0 = tex2D(s5, v0.xy);
    r3.xyz = (r0.xyz) * (-(r0.xyz)) + (c0.yyy);
    r10.xyz = (r0.xyz) * (r0.xyz);
    r10.w = (r0.w) * (-(c0.w)) + (c0.y);
    r11.w = (r0.w) * (c0.w);
    r4.w = saturate(dot(r12.xyz, r9.xyz));
    r6.y = saturate(dot(r9.xyz, -(r8.xyz)));
    r1.w = (r4.w) * (r10.w) + (r11.w);
    r9.w = (r6.y) * (r10.w) + (r11.w);
    r0.xyz = (r3.xyz) * (r1.zzz) + (r10.xyz);
    r1.w = (r1.w) * (r9.w) + (c4.x);
    r1.z = 1.0f / (r1.w);
    r1.w = dot(r8.xyz, r9.xyz);
    r3.w = (r4.w) * (r1.z);
    r1.z = (r1.w) + (r1.w);
    r1.w = (r0.w) * (c0.z);
    r1.xyz = (r9.xyz) * (-(r1.zzz)) + (r8.xyz);
    r1 = texCUBElod(s15, r1);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = (-(r6.y)) + (c0.y);
    r6.y = (r1.w) * (r1.w);
    r12.xy = (r0.ww) * (c15.xy) + (c15.zw);
    r0.w = (r1.w) * (r6.y);
    r1.w = 1.0f / (r12.x);
    r1.xyz = (r6.xxx) * (r1.xyz);
    r0.w = (r0.w) * (r1.w);
    r8.xyz = (r3.xyz) * (r0.www) + (r10.xyz);
    r6.y = exp2(r12.y);
    r0.w = (r6.y) * (c4.y) + (c4.z);
    r1.w = (r8.w) * (r10.w) + (r11.w);
    r1.w = (r1.w) * (r9.w) + (c4.x);
    r9.w = saturate(dot(r9.xyz, r11.xyz));
    r6.x = 1.0f / (r1.w);
    r1.w = pow(abs(r9.w), r6.y);
    r6.x = (r8.w) * (r6.x);
    r1.w = (r0.w) * (r1.w);
    r1.w = (r6.x) * (r1.w);
    r3.xyz = (r3.xyz) * (r7.www) + (r10.xyz);
    r1.xyz = (r1.xyz) * (r8.xyz);
    r3.xyz = (r1.www) * (r3.xyz);
    r4.z = saturate(dot(r9.xyz, r4.xyz));
    r3.xyz = (r6.zzz) * (r3.xyz);
    r1.w = pow(abs(r4.z), r6.y);
    r3.xyz = (r3.xyz) * (c[19].xyz);
    r0.w = (r0.w) * (r1.w);
    r3.xyz = (r5.www) * (r3.xyz);
    r0.w = (r3.w) * (r0.w);
    r2.xyz = (r5.xyz) * (r2.xyz) + (r3.xyz);
    r1.xyz = (r7.xyz) * (r1.xyz);
    r0.xyz = (r0.xyz) * (r0.www);
    r7.xyz = (r1.xyz) * (c0.zzz) + (r2.xyz);
    r0.xyz = (r0.xyz) * (c[22].xyz);
    r1.xyz = (r6.zzz) * (r0.xyz);
    r0 = (v4.yyyy) * (c[32]);
    r1.w = saturate((r2.w) * (c[30].x) + (c[30].y));
    r0 = (v4.xxxx) * (c[31]) + (r0);
    r2.w = (r1.w) * (c14.z) + (c14.w);
    r0 = (v4.zzzz) * (c[33]) + (r0);
    r1.w = (r1.w) * (r1.w);
    r3 = (r0) + (c[34]);
    r7.w = (r2.w) * (r1.w);
    r2.zw = r3.zw;
    r0.xyz = (r4.www) * (c[21].xyz);
    r4.zw = r2.zw;
    r6.xyz = (r5.xyz) * (r0.xyz) + (r1.xyz);
    r0.zw = r4.zw;
    r1.xy = (r3.ww) * (-(c[35].zw)) + (r3.xy);
    r1.zw = r0.zw;
    r1 = tex2Dproj(s2, r1);
    r1.w = r1.x;
    r4.xy = (r2.ww) * (-(c[35].xy)) + (r3.xy);
    r4 = tex2Dproj(s2, r4);
    r1.y = r4.x;
    r2.xy = (r2.ww) * (c[35].xy) + (r3.xy);
    r4 = tex2Dproj(s2, r2);
    r1.x = r4.x;
    r0.xy = (r2.ww) * (c[35].zw) + (r3.xy);
    r0 = tex2Dproj(s2, r0);
    r1.z = r0.x;
    r0 = (v4.xyzx) * (c1.xxxz) + (c1.zzzx);
    r5.w = dot(r1, c4.zzzz);
    r1.w = dot(r0, c[28]);
    r1.w = 1.0f / (r1.w);
    r2.x = dot(r0, c[27]);
    r1.x = dot(r0, c[25]);
    r2.y = (r2.x) * (r2.x);
    r1.y = dot(r0, c[26]);
    r0.w = dot(c[23].yz, r2.xy) + (c[23].x);
    r0.z = saturate(1.0f / (r0.w));
    r0.xy = saturate((r2.xx) * (c[24].xy) + (c[24].zw));
    r2.xy = (r0.xy) * (c14.zz) + (c14.ww);
    r0.xy = (r0.xy) * (r0.xy);
    r0.w = ((-abs(r0.w)) >= 0.0f ? (c1.z) : (r0.z));
    r0.z = (r2.x) * (r0.x);
    r0.w = (r0.w) * (r0.z);
    r0.z = (r0.y) * (-(r2.y)) + (c0.y);
    r0.xy = (r1.ww) * (r1.xy);
    r0.w = (r0.w) * (r0.z);
    r7.w = (r7.w) * (r0.w);
    r0.xy = (r0.xy) * (-(c0.xx)) + (-(c0.xx));
    r4 = tex2D(s3, r0.xy);
    r3 = (-(v4.yyyy)) + (c[6]);
    r2 = (-(v4.xxxx)) + (c[5]);
    r0 = (r3) * (r3);
    r0 = (r2) * (r2) + (r0);
    r1 = (-(v4.zzzz)) + (c[7]);
    r0 = (r1) * (r1) + (r0);
    r8.xyz = (r4.xyz) * (r4.xyz);
    r4.x = rsqrt(r0.x);
    r4.y = rsqrt(r0.y);
    r4.z = rsqrt(r0.z);
    r4.w = rsqrt(r0.w);
    r8.xyz = (r7.www) * (r8.xyz);
    r3 = (r3) * (r4);
    r3 = (r9.yyyy) * (r3);
    r2 = (r2) * (r4);
    r1 = (r1) * (r4);
    r2 = (r2) * (r9.xxxx) + (r3);
    r1 = saturate((r1) * (r9.zzzz) + (r2));
    r0 = saturate((r0) * (c[8]) + (r6.wwww));
    r2.xyz = (r5.www) * (r8.xyz);
    r0 = (r1) * (r0);
    r2.xyz = (r2.xyz) * (r6.xyz) + (r7.xyz);
    r1.z = dot(c[11], r0);
    r1.x = dot(c[9], r0);
    r1.y = dot(c[10], r0);
    r0.xyz = (r5.xyz) * (r1.xyz) + (r2.xyz);
    r0.xyz = (r0.xyz) + (-(v2.xyz));
    r0.w = v1.w;
    r0.xyz = (r0.www) * (r0.xyz) + (v2.xyz);
    r0.xyz = max(((r0.xyz) * (c[37].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = c0.y;

    return oC0;
}
