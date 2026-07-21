// Mechanically reconstructed from 0x881E6077.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);
sampler2D s4 : register(s4);
sampler2D s5 : register(s5);
sampler2D s6 : register(s6);
sampler2D s7 : register(s7);
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
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
    const float4 c0 = float4(1.16412354f, 2.01782227f, -1.08166885f, 31.875f);
    const float4 c1 = float4(0.75f, 4.0f, -3.0f, -4.0f);
    const float4 c3 = float4(0.00048828125f, -0.000122070312f, 0.0f, 0.25f);
    const float4 c4 = float4(1.0f, 0.0f, -0.0f, 0.000244140625f);
    const float4 c12 = float4(9.99999975e-06f, 1e-15f, 1.44269502f, 0.100000001f);
    const float4 c13 = float4(1.16412354f, 1.59579468f, -0.87065506f, 8.0f);
    const float4 c14 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = normalize(v2.xyz);
    r1.x = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.x);
    r1.xyz = (r0.xyz) * (c[5].xyz);
    r0.w = 1.0f / (r2.x);
    r1.xyz = (r1.xyz) * (r0.www) + (v4.xyz);
    r1 = tex3D(s11, r1.xyz);
    if ((c4.x) >= (v5.w))
    {
        r2 = (v5.xyzx) * (c4.xxxy) + (c4.zzzx);
        r2 = (r2) * (c4.xxxy);
        r3 = (r2) + (c4.wwyy);
        r3 = tex2Dlod(s1, r3);
        r4 = (r2) + (-(c4.wwyy));
        r4 = tex2Dlod(s1, r4);
        r5 = (r2) + (c3.xyzz);
        r5 = tex2Dlod(s1, r5);
        r2 = (r2) + (-(c3.xyzz));
        r2 = tex2Dlod(s1, r2);
        r3.y = r4.x;
        r3.z = r5.x;
        r3.w = r2.x;
        r0.w = dot(r3, c3.wwww);
        if ((c1.x) < (v5.w))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zx) * (c4.xy) + (c4.zx);
            r2 = (r2) * (c4.xxxy);
            r3 = (r2) + (c4.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c4.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c3.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c3.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c3.wwww);
            r2.y = (v5.w) * (c1.y) + (c1.z);
            r3.x = lerp(r0.w, r2.x, r2.y);
            r0.w = r3.x;
        }
    }
    else
    {
        r2.x = (c1.w) + (v5.w);
        r2.x = ((r2.x) >= 0.0f ? (c4.y) : (c4.x));
        if ((r2.x) != (-(r2.x)))
        {
            r2.xy = (v5.xy) * (c[2].ww) + (c[2].xy);
            r2.zw = (v5.zz) * (c4.xy) + (c4.zx);
            r2 = (r2) * (c4.xxxy);
            r3 = (r2) + (c4.wwyy);
            r3 = tex2Dlod(s1, r3);
            r4 = (r2) + (-(c4.wwyy));
            r4 = tex2Dlod(s1, r4);
            r5 = (r2) + (c3.xyzz);
            r5 = tex2Dlod(s1, r5);
            r2 = (r2) + (-(c3.xyzz));
            r2 = tex2Dlod(s1, r2);
            r3.y = r4.x;
            r3.z = r5.x;
            r3.w = r2.x;
            r2.x = dot(r3, c3.wwww);
            r2.y = saturate((c1.z) + (v5.w));
            r0.w = lerp(r2.x, r1.w, r2.y);
        }
        else
        {
            r0.w = r1.w;
        }
    }
    r2.xyz = (r0.www) * (c[18].xyz);
    r3.xyz = (r0.www) * (c[19].xyz);
    r4.xyz = normalize(c[17].xyz);
    r2.xyz = (r2.xyz) * (c[6].xxx);
    r0.w = saturate(dot(r0.xyz, r4.xyz));
    r2.xyz = (r2.xyz) * (r0.www);
    r3.xyz = (r3.xyz) * (c[6].yyy);
    r5 = tex2D(s7, v3.xy);
    r1.w = (r5.x) * (r5.x);
    r2.w = max(c12.x, r1.w);
    r1.w = dot(-(v1.xyz), -(v1.xyz));
    r1.w = rsqrt(r1.w);
    r5.xyz = (r1.www) * (-(v1.xyz));
    r3.w = saturate(dot(r0.xyz, r5.xyz));
    r2.w = (r2.w) * (r2.w);
    r2.w = 1.0f / (r2.w);
    r4.xyz = (-(v1.xyz)) * (r1.www) + (r4.xyz);
    r5.xyz = normalize(r4.xyz);
    r0.x = saturate(dot(r0.xyz, r5.xyz));
    r0.y = (r0.x) * (r0.x) + (c12.y);
    r0.y = 1.0f / (r0.y);
    r0.z = (-(r0.y)) + (c4.x);
    r0.z = (r2.w) * (r0.z);
    r0.z = (r0.z) * (c12.z);
    r0.z = exp2(r0.z);
    r0.y = (r0.y) * (r0.y);
    r0.y = (r0.z) * (r0.y);
    r0.x = (r0.x) + (r0.x);
    r0.z = 1.0f / (r3.w);
    r0.x = (r0.x) * (r0.z);
    r1.w = min(r3.w, r0.w);
    r0.x = saturate((r0.x) * (r1.w));
    r0.x = (r0.w) * (r0.x);
    r0.x = rsqrt(r0.x);
    r0.x = 1.0f / (r0.x);
    r0.x = (r0.y) * (r0.x);
    r0.xyz = (r3.xyz) * (r0.xxx);
    r0.w = max(c12.w, r3.w);
    r0.w = 1.0f / (r0.w);
    r0.w = rsqrt(r0.w);
    r0.w = 1.0f / (r0.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r2.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c3.www);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r3 = tex2D(s6, v3.xy);
    r4 = (r3) * (r3);
    r3.xy = lerp(c[8].xy, c[8].zw, v3.xy);
    r5 = tex2D(s2, r3.xy);
    r6 = tex2D(s3, r3.xy);
    r7 = tex2D(s4, r3.xy);
    r5.xw = (r5.xx) * (c4.xy) + (c4.zx);
    r5.y = r6.x;
    r3.x = dot(c13.xyz, r5.xyw);
    r5.z = r7.x;
    r3.y = dot(c14, r5);
    r3.z = dot(c0.xyz, r5.xzw);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c[10].xxx);
    r5.xyz = (r3.xyz) * (c13.www) + (-(r4.xyz));
    r5.w = (r3.w) * (-(r3.w)) + (c[11].x);
    r3 = (c[7].xxxx) * (r5) + (r4);
    r4 = tex2D(s5, v3.xy);
    r4.xyz = (r4.xyz) * (r4.xyz);
    r1.xyz = (r1.xyz) * (c0.www) + (r2.xyz);
    r0.xyz = (r0.xyz) * (r4.xyz);
    r0.xyz = (r3.www) * (r0.xyz);
    r3.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r0 = max(r3, c4.yyyy);
    r1.w = v1.w;
    r2.xyz = lerp(v0.xyz, r0.xyz, r1.www);
    r0.xyz = max(((r2.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
