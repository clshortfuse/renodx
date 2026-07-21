// Mechanically reconstructed from 0xDD8520C0.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);

struct PS_INPUT
{
    float4 v0 : TEXCOORD2;
    float4 v1 : TEXCOORD4;
    float4 v2 : TEXCOORD5;
    float4 v3 : TEXCOORD6;
    float4 v4 : TEXCOORD7;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    const float4 c0 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c1 = float4(1.0f, -2.0f, 3.0f, 9.99999975e-05f);
    const float4 c2 = float4(0.5f, 0.449999988f, 0.330000013f, 0.0900000036f);
    const float4 c3 = float4(0.100000001f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 oC0 = 0.0f;

    r0.xyz = v2.xyz;
    r1.xyz = (r0.zxy) * (v0.yzx);
    r2.xyz = (r0.yzx) * (v0.zxy) + (-(r1.xyz));
    r0.xy = (v4.xy) * (c[10].xy);
    r1 = tex2D(s0, r0.xy);
    r0 = tex2D(s1, r0.xy);
    r1.xy = (r1.wy) * (c0.xy) + (c0.zw);
    r3.xy = (r1.xy) * (c[11].xx);
    r1.xyz = (-(r2.xyz)) * (r3.yyy);
    r1.xyz = (r3.xxx) * (v0.xyz) + (r1.xyz);
    r2.xyz = (r1.xyz) + (v2.xyz);
    r1.xyz = (-(v1.xyz)) + (c[5].xyz);
    r3.xyz = normalize(r2.xyz);
    r4.y = dot(r1.xyz, r1.xyz);
    r2.xyz = normalize(-(v1.xyz));
    r3.w = rsqrt(r4.y);
    r1.w = saturate(dot(r3.xyz, r2.xyz));
    r1.xyz = (r1.xyz) * (r3.www);
    r2.w = saturate(dot(r3.xyz, r1.xyz));
    r1.z = dot(r1.xyz, r2.xyz);
    r4.x = 1.0f / (r3.w);
    r3.w = saturate((r2.w) * (-(r1.w)) + (r1.z));
    r1.z = (c[20].x) * (c[20].x);
    r1.y = c[20].x;
    r3.xy = (r1.yy) * (r1.yy) + (c2.zw);
    r1.xy = (r1.zz) * (c2.xy);
    r3.x = 1.0f / (r3.x);
    r3.y = 1.0f / (r3.y);
    r1.z = 1.0f / (r1.w);
    r1.y = (r1.y) * (r3.y);
    r1.w = (r1.x) * (-(r3.x)) + (c1.x);
    r3.w = (r3.w) * (r1.y);
    r3.z = saturate((r2.w) * (r1.z));
    r3.xy = saturate((r4.xx) * (c[8].xy) + (c[8].zw));
    r1.xy = (r3.xy) * (r3.xy);
    r3.xy = (r3.xy) * (c1.yy) + (c1.zz);
    r1.z = dot(c[7].yz, r4.xy) + (c[7].x);
    r1.xy = (r1.xy) * (r3.xy);
    r3.w = (r3.w) * (r3.z);
    r1.z = (r1.z) * (r1.x);
    r1.w = (r1.w) * (r2.w) + (r3.w);
    r1.z = (r1.y) * (r1.z);
    r1.xyz = (r1.zzz) * (c[6].xyz);
    r3.xyz = normalize(v2.xyz);
    r1.xyz = (r1.www) * (r1.xyz);
    r1.w = dot(r2.xyz, r3.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.w = max(c1.w, r1.w);
    r1.w = (r0.w) + (-(c1.x));
    r0.w = pow(abs(r2.w), c3.x);
    r0.xyz = (r1.xyz) * (r0.xyz);
    r0.w = (r0.w) * (r1.w) + (c1.x);
    r0.xyz = (r0.xyz) * (r0.www) + (-(v3.xyz));
    r1.x = v0.w;
    r0.xyz = (r1.xxx) * (r0.xyz) + (v3.xyz);
    r0.xyz = max(((r0.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
