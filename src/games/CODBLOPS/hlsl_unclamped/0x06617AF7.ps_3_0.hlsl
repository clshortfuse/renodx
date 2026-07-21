// Mechanically reconstructed from 0x06617AF7.ps_3_0.cso.
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

struct PS_INPUT
{
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD4;
    float4 v2 : TEXCOORD5;
    float4 v3 : TEXCOORD6;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    const float4 c1 = float4(-2.0f, 3.0f, 0.5f, 0.449999988f);
    const float4 c2 = float4(0.330000013f, 0.0900000036f, 1.0f, -1.0f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 oC0 = 0.0f;

    r3.xy = ddx(v3.xy);
    r2.xy = ddy(v3.yx);
    r0.w = (r3.y) * (r2.y);
    r0.xyz = ddy(v1.xyz);
    r1.xyz = (r3.yyy) * (r0.xyz);
    r0.xyz = ddx(v1.xyz);
    r0.w = (r3.x) * (r2.x) + (-(r0.w));
    r0.xyz = (r0.xyz) * (r2.xxx) + (-(r1.xyz));
    r1.xyz = float3(((r0.w) >= 0.0f ? (r0.x) : (-(r0.x))), ((r0.w) >= 0.0f ? (r0.y) : (-(r0.y))), ((r0.w) >= 0.0f ? (r0.z) : (-(r0.z))));
    r0.xyz = normalize(v2.xyz);
    r0.w = dot(r1.xyz, r0.xyz);
    r0.xyz = (r0.www) * (-(r0.xyz)) + (r1.xyz);
    r1.xyz = normalize(r0.xyz);
    r0.xyz = (r1.yzx) * (v2.zxy);
    r2.xyz = (v2.yzx) * (r1.zxy) + (-(r0.xyz));
    r0 = tex2D(s0, v3.xy);
    r3.xy = (r0.wy) * (c3.xy) + (c3.zw);
    r0.xyz = (r2.xyz) * (r3.yyy);
    r0.xyz = (r3.xxx) * (r1.xyz) + (r0.xyz);
    r0.xyz = (r0.xyz) + (v2.xyz);
    r2.xyz = normalize(r0.xyz);
    r0.xyz = (-(v1.xyz)) + (c[5].xyz);
    r1.xyz = normalize(-(v1.xyz));
    r3.y = dot(r0.xyz, r0.xyz);
    r0.w = saturate(dot(r2.xyz, r1.xyz));
    r1.w = rsqrt(r3.y);
    r0.xyz = (r0.xyz) * (r1.www);
    r3.x = 1.0f / (r1.w);
    r1.w = saturate(dot(r2.xyz, r0.xyz));
    r0.z = dot(r0.xyz, r1.xyz);
    r1.z = saturate((r1.w) * (-(r0.w)) + (r0.z));
    r2.w = 1.0f / (r0.w);
    r0 = tex2D(s1, v3.xy);
    r0.w = (r0.x) * (r0.x);
    r1.xy = (r0.xx) * (r0.xx) + (c2.xy);
    r0.xy = (r0.ww) * (c1.zw);
    r1.x = 1.0f / (r1.x);
    r1.y = 1.0f / (r1.y);
    r0.z = (r0.y) * (r1.y);
    r0.w = (r0.x) * (-(r1.x)) + (c2.z);
    r1.z = (r1.z) * (r0.z);
    r1.xy = saturate((r3.xx) * (c[8].xy) + (c[8].zw));
    r0.xy = (r1.xy) * (r1.xy);
    r1.xy = (r1.xy) * (c1.xx) + (c1.yy);
    r0.z = dot(c[7].yz, r3.xy) + (c[7].x);
    r0.xy = (r0.xy) * (r1.xy);
    r1.y = saturate((r1.w) * (r2.w));
    r0.z = (r0.z) * (r0.x);
    r0.x = (r1.z) * (r1.y);
    r0.z = (r0.y) * (r0.z);
    r0.w = (r0.w) * (r1.w) + (r0.x);
    r0.xyz = (r0.zzz) * (c[6].xyz);
    r1.xyz = (r0.www) * (r0.xyz);
    r0 = tex2D(s2, v3.xy);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r3.xy = (v3.xy) + (-(c1.zz));
    r2.xyz = (r1.xyz) * (r0.xyz);
    r0.y = c1.z;
    r0.xy = (r3.xy) * (c[22].xx) + (r0.yy);
    r0 = tex2D(s3, r0.xy);
    r1.z = (r0.x) + (c2.w);
    r0.xyz = normalize(v1.xyz);
    r1.y = c2.z;
    r0.w = min(c[20].x, r1.y);
    r0.z = dot(c[9].xyz, r0.xyz);
    r1.w = saturate((c[11].y) * (r0.z) + (c[11].x));
    r0.xyz = c[0].xyz;
    r0.xyz = (-(r0.xyz)) + (c[10].xyz);
    r0.w = (-(c1.x)) * (r0.w) + (r1.z);
    r0.xyz = (r1.www) * (r0.xyz) + (c[0].xyz);
    r0.w = saturate((-(r0.w)) + (c2.z));
    r1.xyz = (r0.xyz) * (c[0].www);
    r0.xyz = (r2.xyz) * (r0.www) + (-(r1.xyz));
    r0.xyz = (v0.www) * (r0.xyz) + (r1.xyz);
    r0.xyz = max(((r0.xyz) * (c[21].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
