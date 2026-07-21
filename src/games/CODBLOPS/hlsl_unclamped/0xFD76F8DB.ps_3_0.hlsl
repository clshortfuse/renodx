// Mechanically reconstructed from 0xFD76F8DB.ps_3_0.cso.
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
sampler3D s11 : register(s11);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
    float4 v3 : TEXCOORD4;
    float4 v4 : TEXCOORD5;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(1.16412354f, 2.01782227f, -1.08166885f, 31.875f);
    const float4 c1 = float4(9.99999975e-06f, 1e-15f, 1.0f, 1.44269502f);
    const float4 c2 = float4(0.100000001f, 0.25f, 1.0f, 0.0f);
    const float4 c3 = float4(1.16412354f, 1.59579468f, -0.87065506f, 8.0f);
    const float4 c4 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.x = dot(-(v1.xyz), -(v1.xyz));
    r0.x = rsqrt(r0.x);
    r1.xyz = normalize(c[17].xyz);
    r0.yzw = (-(v1.xyz)) * (r0.xxx) + (r1.xyz);
    r2.xyz = (r0.xxx) * (-(v1.xyz));
    r3.xyz = normalize(r0.yzw);
    r0.xyz = normalize(v2.xyz);
    r0.w = saturate(dot(r0.xyz, r3.xyz));
    r1.w = (r0.w) + (r0.w);
    r0.w = (r0.w) * (r0.w) + (c1.y);
    r0.w = 1.0f / (r0.w);
    r2.x = saturate(dot(r0.xyz, r2.xyz));
    r2.y = 1.0f / (r2.x);
    r1.w = (r1.w) * (r2.y);
    r1.x = saturate(dot(r0.xyz, r1.xyz));
    r3.x = min(r2.x, r1.x);
    r1.y = max(c2.x, r2.x);
    r1.y = 1.0f / (r1.y);
    r1.y = rsqrt(r1.y);
    r1.y = 1.0f / (r1.y);
    r1.z = saturate((r1.w) * (r3.x));
    r1.z = (r1.x) * (r1.z);
    r1.z = rsqrt(r1.z);
    r1.z = 1.0f / (r1.z);
    r2 = tex2D(s6, v3.xy);
    r1.w = (r2.x) * (r2.x);
    r2.x = max(c1.x, r1.w);
    r1.w = (r2.x) * (r2.x);
    r1.w = 1.0f / (r1.w);
    r2.x = (-(r0.w)) + (c1.z);
    r0.w = (r0.w) * (r0.w);
    r2.x = (r1.w) * (r2.x);
    r2.x = (r2.x) * (c1.w);
    r2.x = exp2(r2.x);
    r0.w = (r0.w) * (r2.x);
    r0.w = (r1.z) * (r0.w);
    r1.z = max(abs(r0.y), abs(r0.z));
    r2.x = max(abs(r0.x), r1.z);
    r1.z = 1.0f / (r2.x);
    r2.xyz = (r0.xyz) * (c[5].xyz);
    r2.xyz = (r2.xyz) * (r1.zzz) + (v4.xyz);
    r2 = tex3D(s11, r2.xyz);
    r3.xyz = (r2.www) * (c[19].xyz);
    r3.xyz = (r3.xyz) * (c[21].yyy);
    r3.xyz = (r0.www) * (r3.xyz);
    r3.xyz = (r1.yyy) * (r3.xyz);
    r1.yzw = (r1.www) * (r3.xyz);
    r1.yzw = (r1.yzw) * (c2.yyy);
    r3 = tex2D(s4, v3.xy);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r1.yzw = (r1.yzw) * (r3.xyz);
    r3.xy = lerp(c[23].xy, c[23].zw, v3.xy);
    r4 = tex2D(s2, r3.xy);
    r4.y = r4.x;
    r5 = tex2D(s3, r3.xy);
    r3 = tex2D(s1, r3.xy);
    r4.xw = (r3.xx) * (c2.zw) + (c2.wz);
    r4.z = r5.x;
    r3.y = dot(c4, r4);
    r3.x = dot(c3.xyz, r4.xyw);
    r3.z = dot(c0.xyz, r4.xzw);
    r3.xyz = (r3.xyz) * (r3.xyz);
    r3.xyz = (r3.xyz) * (c[25].xxx);
    r4 = tex2D(s5, v3.xy);
    r5 = (r4) * (r4);
    r4.w = (r4.w) * (-(r4.w)) + (c[26].x);
    r4.xyz = (r3.xyz) * (c3.www) + (-(r5.xyz));
    r3 = (c[22].xxxx) * (r4) + (r5);
    r1.yzw = (r1.yzw) * (r3.www);
    r4.xyz = (r2.www) * (c[18].xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r4.xyz = (r4.xyz) * (c[21].xxx);
    r4.xyz = (r1.xxx) * (r4.xyz);
    r2.xyz = (r2.xyz) * (c0.www) + (r4.xyz);
    r3.xyz = (r2.xyz) * (r3.xyz) + (r1.yzw);
    r1 = max(r3, c2.wwww);
    r2 = (c[7]) + (-(v1.yyyy));
    r3 = (r2) * (r2);
    r4 = (c[6]) + (-(v1.xxxx));
    r3 = (r4) * (r4) + (r3);
    r5 = (c[8]) + (-(v1.zzzz));
    r3 = (r5) * (r5) + (r3);
    r6.x = rsqrt(r3.x);
    r6.y = rsqrt(r3.y);
    r6.z = rsqrt(r3.z);
    r6.w = rsqrt(r3.w);
    r7.z = c1.z;
    r3 = saturate((r3) * (c[9]) + (r7.zzzz));
    r2 = (r2) * (r6);
    r2 = (r0.yyyy) * (r2);
    r4 = (r4) * (r6);
    r5 = (r5) * (r6);
    r2 = (r4) * (r0.xxxx) + (r2);
    r0 = saturate((r5) * (r0.zzzz) + (r2));
    r0 = (r3) * (r0);
    r2.x = dot(c[10], r0);
    r2.y = dot(c[11], r0);
    r2.z = dot(c[20], r0);
    r0.xyz = (r1.xyz) * (r2.xyz) + (r1.xyz);
    oC0.w = r1.w;
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[24].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
