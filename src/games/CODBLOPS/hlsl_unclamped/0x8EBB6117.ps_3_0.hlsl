// Mechanically reconstructed from 0x8EBB6117.ps_3_0.cso.
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
    const float4 c0 = float4(-0.5f, 0.5f, 1.0f, 0.0f);
    const float4 c1 = float4(1.16412354f, 1.59579468f, -0.87065506f, 8.0f);
    const float4 c2 = float4(1.16412354f, -0.813476562f, -0.391448975f, 0.529705048f);
    const float4 c3 = float4(1.16412354f, 2.01782227f, -1.08166885f, 0.0f);
    const float4 c4 = float4(0.330000013f, 0.340000004f, 0.0f, 0.0f);
    const float4 c12 = float4(81.2394867f, 17.3480244f, 37.3498383f, 59.3948402f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = c[5].w;
    r0.x = (r0.w) * (c[20].x);
    r0.x = frac(r0.x);
    r0.x = (r0.w) * (c[20].x) + (-(r0.x));
    r0.y = 1.0f / (c[20].x);
    r1.w = (r0.x) * (r0.y);
    r0.x = dot(r1.wwww, c12);
    r1.x = frac(r0.x);
    r0.x = dot(r1.xwww, c12);
    r1.y = frac(r0.x);
    r0.x = dot(r1.xyww, c12);
    r1.z = frac(r0.x);
    r0.x = dot(r1, c12);
    r1.w = frac(r0.x);
    r2.yzw = r1.yzw;
    r0.x = dot(r1, c12);
    r2.x = frac(r0.x);
    r0.x = dot(r2, c12);
    r2.y = frac(r0.x);
    r0.x = 1.0f / (c[10].x);
    r0.y = 1.0f / (c[10].y);
    r0.xy = (v2.xy) * (r0.xy) + (r2.xy);
    r1 = tex2D(s5, r0.xy);
    r0.xyz = (r1.xyz) + (-(c0.zzz));
    r1.xyz = c0.xyz;
    r0.xyz = (c[9].xxx) * (r0.xyz) + (r1.zzz);
    r1.z = saturate(v2.x);
    r1.w = v2.y;
    r2.xy = lerp(c[7].xy, c[7].zw, r1.zw);
    r3 = tex2D(s2, r2.xy);
    r3.y = r3.x;
    r4 = tex2D(s3, r2.xy);
    r2 = tex2D(s1, r2.xy);
    r3.xw = (r2.xx) * (c0.zw) + (c0.wz);
    r3.z = r4.x;
    r2.y = dot(c2, r3);
    r2.x = dot(c1.xyz, r3.xyw);
    r2.z = dot(c3.xyz, r3.xzw);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r3.xyz = (r2.xyz) * (c1.www);
    r1.z = dot(r3.xzy, c4.xxy);
    r2.xyz = (r2.xyz) * (-(c1.www)) + (r1.zzz);
    r2.xyz = (c[26].xxx) * (r2.xyz) + (r3.xyz);
    r2.xyz = (r2.xyz) * (c[27].xyz);
    r0.xyz = (r0.xyz) * (r2.xyz);
    r1.z = (r0.w) * (c[22].x);
    r1.z = frac(r1.z);
    r0.w = (r0.w) * (c[22].x) + (-(r1.z));
    r1.z = 1.0f / (c[22].x);
    r2.w = (r0.w) * (r1.z);
    r0.w = dot(r2.wwww, c12);
    r2.x = frac(r0.w);
    r0.w = dot(r2.xwww, c12);
    r2.y = frac(r0.w);
    r0.w = dot(r2.xyww, c12);
    r2.z = frac(r0.w);
    r0.w = dot(r2, c12);
    r2.w = frac(r0.w);
    r0.w = dot(r2, c12);
    r0.w = frac(r0.w);
    r2.x = c[23].x;
    r1.z = (-(r2.x)) + (c[21].x);
    r0.w = (r0.w) * (r1.z) + (c[23].x);
    r0.xyz = (r0.xyz) * (r0.www);
    r2 = tex2D(s4, v2.xy);
    r0.w = pow(abs(r2.x), c[25].x);
    r0.w = saturate((r0.w) * (c[24].x));
    r0.xyz = (r0.xyz) * (r0.www) + (c[11].xyz);
    r1.zw = (c0.xx) + (v2.xy);
    r1.yz = (r1.zw) * (c[28].xy) + (r1.yy);
    r2 = tex2D(s6, r1.yz);
    r0.w = (r1.x) + (c[6].x);
    r0.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (r2.x)), ((r0.w) >= 0.0f ? (r0.y) : (r2.y)), ((r0.w) >= 0.0f ? (r0.z) : (r2.z)));
    r0.xyz = (r0.xyz) + (-(v0.xyz));
    r1.xyz = v0.xyz;
    r0.xyz = (v1.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[8].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    oC0.x = 1.0f / (r0.x);
    r0.x = rsqrt(r0.y);
    r0.y = rsqrt(r0.z);
    oC0.z = 1.0f / (r0.y);
    oC0.y = 1.0f / (r0.x);
    oC0.w = c0.z;

    return oC0;
}
