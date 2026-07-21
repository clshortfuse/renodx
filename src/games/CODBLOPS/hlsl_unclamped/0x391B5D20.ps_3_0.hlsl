// Mechanically reconstructed from 0x391B5D20.ps_3_0.cso.
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
    r0.xyz = (r0.xyz) * (c[5].xyz);
    r1.z = 1.0f / (r2.x);
    r0.xyz = (r0.xyz) * (r1.zzz) + (v4.xyz);
    r2 = tex3D(s11, r0.xyz);
    r0.xyz = (r2.www) * (c[19].xyz);
    r0.xyz = (r0.xyz) * (c[6].yyy);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r1.yyy) * (r0.xyz);
    r0.xyz = (r1.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c2.yyy);
    r3 = tex2D(s4, v3.xy);
    r1.yzw = (r3.xyz) * (r3.xyz);
    r0.xyz = (r0.xyz) * (r1.yzw);
    r1.yz = lerp(c[8].xy, c[8].zw, v3.xy);
    r3 = tex2D(s2, r1.yz);
    r3.y = r3.x;
    r4 = tex2D(s3, r1.yz);
    r5 = tex2D(s1, r1.yz);
    r3.xw = (r5.xx) * (c2.zw) + (c2.wz);
    r3.z = r4.x;
    r1.z = dot(c4, r3);
    r1.y = dot(c3.xyz, r3.xyw);
    r1.w = dot(c0.xyz, r3.xzw);
    r1.yzw = (r1.yzw) * (r1.yzw);
    r1.yzw = (r1.yzw) * (c[10].xxx);
    r3 = tex2D(s5, v3.xy);
    r4 = (r3) * (r3);
    r3.w = (r3.w) * (-(r3.w)) + (c[11].x);
    r3.xyz = (r1.yzw) * (c3.www) + (-(r4.xyz));
    r3 = (c[7].xxxx) * (r3) + (r4);
    r0.xyz = (r0.xyz) * (r3.www);
    r1.yzw = (r2.www) * (c[18].xyz);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r1.yzw = (r1.yzw) * (c[6].xxx);
    r1.xyz = (r1.xxx) * (r1.yzw);
    r1.xyz = (r2.xyz) * (c0.www) + (r1.xyz);
    r3.xyz = (r1.xyz) * (r3.xyz) + (r0.xyz);
    r0 = max(r3, c2.wwww);
    oC0.w = r0.w;
    r0.w = v1.w;
    r1.xyz = lerp(v0.xyz, r0.xyz, r0.www);
    r0.xyz = max(((r1.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);

    return oC0;
}
