// Mechanically reconstructed from 0x8D9AB152.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s3 : register(s3);

struct PS_INPUT
{
    float4 v0 : TEXCOORD0;
    float4 v1 : TEXCOORD1;
    float4 v2 : TEXCOORD2;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    const float4 c0 = float4(1.16412354f, 1.59579468f, -0.87065506f, 0.0f);
    const float4 c1 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c2 = float4(1.0f, 0.0f, 8.0f, 0.0f);
    const float4 c3 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xy = lerp(c[7].xy, c[7].zw, v2.xy);
    r1 = tex2D(s2, r0.xy);
    r1.y = r1.x;
    r2 = tex2D(s3, r0.xy);
    r0 = tex2D(s1, r0.xy);
    r1.xw = (r0.xx) * (c2.xy) + (c2.yx);
    r1.z = r2.x;
    r0.y = dot(c1, r1);
    r0.x = dot(c0.xyz, r1.xyw);
    r0.z = dot(c3.xyz, r1.xzw);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[8].xxx);
    r0.xyz = (r0.xyz) * (c2.zzz) + (-(v0.xyz));
    r1.xyz = v0.xyz;
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[6].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c[5].y;

    return oC0;
}
