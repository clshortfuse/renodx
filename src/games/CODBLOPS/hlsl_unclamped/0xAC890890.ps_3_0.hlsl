// Mechanically reconstructed from 0xAC890890.ps_3_0.cso.
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
    float4 v0 : TEXCOORD5;
    float4 v1 : TEXCOORD6;
    float4 v2 : TEXCOORD7;
    float4 v3 : TEXCOORD8;
    float vFaceInput : VFACE;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 vFace = input.vFaceInput.xxxx;
    const float4 c0 = float4(0.0166666675f, -241.199997f, -58.2000008f, -0.0f);
    const float4 c1 = float4(0.95105654f, 0.309017003f, -0.0f, -0.309017003f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(1.0f, -1.0f, -2.0f, 3.0f);
    const float4 c4 = float4(40.0f, 0.300000012f, -0.0f, 1.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = c0.x;
    r0.w = (r0.w) * (c[9].w);
    r0.w = frac(abs(r0.w));
    r0.w = ((c[9].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.w = (r0.w) * (c[11].x);
    r0.yw = (r0.ww) * (c0.yz) + (v3.yy);
    r0.xz = v3.xx;
    r0 = (r0) + (c0.wwww);
    r2.xy = (r0.zw) * (c[21].xy);
    r1.x = dot(c1.xy, r2.xy) + (c1.z);
    r1.y = dot(c1.wx, r2.xy) + (c1.z);
    r2 = tex2D(s1, r1.xy);
    r1 = tex2D(s0, r1.xy);
    r1.x = r2.y;
    r1.xy = (r1.xy) * (c2.xy) + (c2.zw);
    r0.xy = (r0.xy) * (c[20].xy);
    r4.xy = (r1.xy) * (c[22].yy);
    r1.x = dot(c1.xy, r0.xy) + (c1.z);
    r1.y = dot(c1.wx, r0.xy) + (c1.z);
    r0 = tex2D(s0, r1.xy);
    r1 = tex2D(s1, r1.xy);
    r0.x = r1.y;
    r3.xy = (r0.xy) * (c2.xy) + (c2.zw);
    r0.xyz = v2.xyz;
    r2.xyz = (r0.zxy) * (v0.yzx);
    r3.xy = (c[22].xx) * (r3.xy) + (r4.xy);
    r0.xyz = (r0.yzx) * (v0.zxy) + (-(r2.xyz));
    r0.xyz = (r3.yyy) * (-(r0.xyz));
    r0.xyz = (r3.xxx) * (v0.xyz) + (r0.xyz);
    r2.xyz = (r0.xyz) + (v2.xyz);
    r0.xyz = normalize(r2.xyz);
    r0.w = ((vFace.w) >= 0.0f ? (c3.x) : (c3.y));
    r0.xyz = (r0.xyz) * (r0.www);
    r2.xyz = (-(v1.xyz)) + (c[5].xyz);
    r0.w = dot(-(v1.xyz), -(v1.xyz));
    r5.y = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r1.w = rsqrt(r5.y);
    r2.xyz = (r2.xyz) * (r1.www);
    r5.x = 1.0f / (r1.w);
    r3.xyz = (-(v1.xyz)) * (r0.www) + (r2.xyz);
    r4.xy = saturate((r5.xx) * (c[8].xy) + (c[8].zw));
    r2.xy = (r4.xy) * (r4.xy);
    r4.xy = (r4.xy) * (c3.zz) + (c3.ww);
    r0.w = dot(c[7].yz, r5.xy) + (c[7].x);
    r4.xy = (r2.xy) * (r4.xy);
    r2.xyz = normalize(r3.xyz);
    r0.w = (r0.w) * (r4.x);
    r1.w = saturate(dot(r0.xyz, r2.xyz));
    r0.z = (r4.y) * (r0.w);
    r0.w = pow(abs(r1.w), c4.x);
    r0.xyz = (r0.zzz) * (c[6].xyz);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (c[23].xyz);
    r1.w = (-(r1.y)) + (c4.y);
    r0.w = saturate((c[24].x) * (r1.y) + (c[24].y));
    r1.w = ((r1.w) >= 0.0f ? (c4.z) : (c4.w));
    r0 = (r0) * (r1.wwww);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (v1.www);
    r0.xyz = max(((r0.xyz) * (c[10].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
