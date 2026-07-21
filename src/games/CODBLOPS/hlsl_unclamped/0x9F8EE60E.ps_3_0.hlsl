// Mechanically reconstructed from 0x9F8EE60E.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);

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
    const float4 c0 = float4(0.95105654f, 0.309017003f, 0.0f, -0.309017003f);
    const float4 c1 = float4(0.0166666675f, -241.199997f, -58.2000008f, 0.0f);
    const float4 c2 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c3 = float4(1.0f, -1.0f, 0.0f, 40.0f);
    const float4 c4 = float4(0.300000012f, 0.0f, 0.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 oC0 = 0.0f;

    r1 = (v1.xyzx) * (c3.xxxz) + (c3.zzzx);
    r0.w = dot(r1, c[22]);
    r0.w = 1.0f / (r0.w);
    r0.x = dot(r1, c[11]);
    r0.y = dot(r1, c[20]);
    r0 = (r0.wwww) * (r0.xxyy);
    r2 = (r0) * (c[23].zwxy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.z = log2(abs(r2.z));
    r2.w = log2(abs(r2.w));
    r2 = (r2) * (c[24].xxxx);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = exp2(r2.z);
    r2.w = exp2(r2.w);
    r2.xy = (r2.zw) + (r2.xy);
    r2.x = log2(abs(r2.x));
    r2.y = log2(abs(r2.y));
    r2.xy = (r2.xy) * (c[24].yy);
    r2.x = exp2(r2.x);
    r2.y = exp2(r2.y);
    r2.z = dot(r1, c[21]);
    r0.z = (r2.x) * (c[25].x);
    r0.y = (r2.y) * (c[25].y) + (-(r0.z));
    r0.z = c[25].y;
    r0.z = (r2.y) * (r0.z) + (-(c[24].z));
    r0.y = 1.0f / (r0.y);
    r2.xy = abs(r0.xw);
    r3.w = saturate((r0.z) * (r0.y));
    r1 = c[9];
    r1 = saturate((r2.zyxz) * (r1) + (c[10]));
    r3.x = (r1.w) * (r1.x);
    r3.yz = r1.yz;
    r1 = (r3) * (r3);
    r3 = (c[25].zzzz) * (r3) + (c[25].wwww);
    r1 = (r1) * (r3);
    r0.y = (r1.z) * (r1.y);
    r0.z = abs(c[24].w);
    r2.w = (r2.z) * (r2.z);
    r0.y = ((-(r0.z)) >= 0.0f ? (r0.y) : (r1.w));
    r0.z = dot(c[8].yz, r2.zw) + (c[8].x);
    r0.z = (r0.y) * (r0.z);
    r4.w = (r1.x) * (r0.z);
    r1 = c[26];
    r1.x = dot(r0.xw, r1.xy) + (c[7].x);
    r1.y = dot(r0.xw, r1.zw) + (c[7].z);
    r0 = tex2D(s0, r1.xy);
    r0.w = c1.x;
    r0.w = (r0.w) * (c[27].w);
    r0.w = frac(abs(r0.w));
    r0.w = ((c[27].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.w = (r0.w) * (c[29].x);
    r1.yw = (r0.ww) * (c1.yz) + (v3.yy);
    r1.xz = v3.xx;
    r1 = (r1) + (c1.wwww);
    r3.xy = (r1.zw) * (c[31].xy);
    r2.x = dot(c0.xy, r3.xy) + (c0.z);
    r2.y = dot(c0.wx, r3.xy) + (c0.z);
    r3 = tex2D(s2, r2.xy);
    r2 = tex2D(s1, r2.xy);
    r2.x = r3.y;
    r3.xy = (r2.xy) * (c2.xy) + (c2.zw);
    r2.xy = (r1.xy) * (c[30].xy);
    r5.xy = (r3.xy) * (c[32].yy);
    r1.x = dot(c0.xy, r2.xy) + (c0.z);
    r1.y = dot(c0.wx, r2.xy) + (c0.z);
    r2 = tex2D(s1, r1.xy);
    r1 = tex2D(s2, r1.xy);
    r2.x = r1.y;
    r4.xy = (r2.xy) * (c2.xy) + (c2.zw);
    r2.xyz = v2.xyz;
    r3.xyz = (r2.zxy) * (v0.yzx);
    r4.xy = (c[32].xx) * (r4.xy) + (r5.xy);
    r2.xyz = (r2.yzx) * (v0.zxy) + (-(r3.xyz));
    r2.xyz = (r4.yyy) * (-(r2.xyz));
    r2.xyz = (r4.xxx) * (v0.xyz) + (r2.xyz);
    r3.xyz = (r2.xyz) + (v2.xyz);
    r0.xyz = (r0.xyz) * (r0.xyz);
    r2.xyz = normalize(r3.xyz);
    r0.w = dot(-(v1.xyz), -(v1.xyz));
    r4.xyz = (-(v1.xyz)) + (c[5].xyz);
    r1.w = rsqrt(r0.w);
    r3.xyz = normalize(r4.xyz);
    r0.w = ((vFace.w) >= 0.0f ? (c3.x) : (c3.y));
    r4.xyz = (-(v1.xyz)) * (r1.www) + (r3.xyz);
    r2.xyz = (r2.xyz) * (r0.www);
    r3.xyz = normalize(r4.xyz);
    r0.xyz = (r4.www) * (r0.xyz);
    r1.w = saturate(dot(r2.xyz, r3.xyz));
    r0.xyz = (r0.xyz) * (c[6].xyz);
    r0.w = pow(abs(r1.w), c3.w);
    r0.xyz = (r0.xyz) * (r0.www);
    r0.xyz = (r0.xyz) * (c[33].xyz);
    r1.w = (-(r1.y)) + (c4.x);
    r0.w = saturate((c[34].x) * (r1.y) + (c[34].y));
    r1.w = ((r1.w) >= 0.0f ? (c3.z) : (c3.x));
    r0 = (r0) * (r1.wwww);
    r0.xyz = (r0.www) * (r0.xyz);
    r0.xyz = (r0.xyz) * (v1.www);
    r0.xyz = max(((r0.xyz) * (c[28].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.w = r0.w;
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);

    return oC0;
}
