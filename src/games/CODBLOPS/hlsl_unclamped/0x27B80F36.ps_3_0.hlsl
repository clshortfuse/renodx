// Mechanically reconstructed from 0x27B80F36.ps_3_0.cso.
// HDR edit: terminal RGB upper clamp removed; zero floor retained.
// Original terminal path: saturate(linear RGB) -> sqrt encode.
// Modified terminal path: max(linear RGB, 0) -> sqrt encode.
// Intermediate clamps, alpha clamps, masks, depth, and control flow are unchanged.
// Entry point: main    Target: ps_3_0

float4 c[224] : register(c0);
sampler2D s0 : register(s0);
sampler2D s1 : register(s1);
sampler2D s2 : register(s2);
sampler2D s12 : register(s12);
samplerCUBE s15 : register(s15);

struct PS_INPUT
{
    float4 v0 : TEXCOORD1;
    float4 v1 : TEXCOORD2;
    float4 v2 : TEXCOORD3;
    float4 v3 : TEXCOORD5;
    float4 v4 : TEXCOORD6;
    float4 v5 : TEXCOORD7;
    float4 v6 : TEXCOORD8;
    float vFaceInput : VFACE;
};

float4 main(PS_INPUT input) : COLOR0
{
    float4 v0 = input.v0;
    float4 v1 = input.v1;
    float4 v2 = input.v2;
    float4 v3 = input.v3;
    float4 v4 = input.v4;
    float4 v5 = input.v5;
    float4 v6 = input.v6;
    float4 vFace = input.vFaceInput.xxxx;
    const float4 c1 = float4(0.95105654f, 0.309017003f, 0.0f, -0.309017003f);
    const float4 c2 = float4(0.0166666675f, -241.199997f, -58.2000008f, 0.0f);
    const float4 c3 = float4(4.07999992f, 4.06451607f, -2.07999992f, -2.06451607f);
    const float4 c4 = float4(8.0f, 0.5f, -0.5f, 0.300000012f);
    const float4 c12 = float4(1.0f, -1.0f, 40.0f, 0.0f);
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;
    float4 r7 = 0.0f;
    float4 oC0 = 0.0f;

    r0.w = c2.x;
    r0.w = (r0.w) * (c[8].w);
    r0.w = frac(abs(r0.w));
    r0.w = ((c[8].w) >= 0.0f ? (r0.w) : (-(r0.w)));
    r0.w = (r0.w) * (c[20].x);
    r0.yw = (r0.ww) * (c2.yz) + (v6.yy);
    r0.xz = v6.xx;
    r0 = (r0) + (c2.wwww);
    r2.xy = (r0.zw) * (c[22].xy);
    r1.x = dot(c1.xy, r2.xy) + (c1.z);
    r1.y = dot(c1.wx, r2.xy) + (c1.z);
    r2 = tex2D(s2, r1.xy);
    r1 = tex2D(s1, r1.xy);
    r1.x = r2.y;
    r2.xy = (r1.xy) * (c3.xy) + (c3.zw);
    r1.xy = (r0.xy) * (c[21].xy);
    r4.xy = (r2.xy) * (c[23].yy);
    r0.x = dot(c1.xy, r1.xy) + (c1.z);
    r0.y = dot(c1.wx, r1.xy) + (c1.z);
    r1 = tex2D(s1, r0.xy);
    r0 = tex2D(s2, r0.xy);
    r1.x = r0.y;
    r3.xy = (r1.xy) * (c3.xy) + (c3.zw);
    r1.xyz = v5.xyz;
    r2.xyz = (r1.zxy) * (v3.yzx);
    r3.xy = (c[23].xx) * (r3.xy) + (r4.xy);
    r1.xyz = (r1.yzx) * (v3.zxy) + (-(r2.xyz));
    r1.xyz = (r3.yyy) * (-(r1.xyz));
    r1.xyz = (r3.xxx) * (v3.xyz) + (r1.xyz);
    r1.xyz = (r1.xyz) + (v5.xyz);
    r3.xyz = normalize(r1.xyz);
    r4.xyz = normalize(-(v4.xyz));
    r0.w = dot(-(r4.xyz), r3.xyz);
    r0.w = (r0.w) + (r0.w);
    r1.xyz = (r3.xyz) * (-(r0.www)) + (-(r4.xyz));
    r2.xyz = (r1.yyy) * (v1.xyw);
    r2.xyz = (r1.xxx) * (v0.xyw) + (r2.xyz);
    r7.xyz = (r1.zzz) * (v2.xyw) + (r2.xyz);
    r0.w = 1.0f / (r7.z);
    r2.xy = (r7.xy) * (r0.ww);
    r0.w = max(abs(r2.x), abs(r2.y));
    r0.w = (r0.w) * (r0.w);
    r2.xy = (r2.xy) * (c4.yz) + (c4.yy);
    r0.w = saturate((r0.w) * (-(r0.w)) + (c12.x));
    r2 = tex2D(s0, r2.xy);
    r6.xyz = (r2.xyz) * (r2.xyz);
    r2 = (r1.xyzx) * (c12.xxxw);
    r2 = texCUBElod(s15, r2);
    r2.xyz = (r2.xyz) * (r2.xyz);
    r5.xyz = (r2.xyz) * (c4.xxx);
    r0.z = 1.0f / (c[9].x);
    r0.w = ((-(r7.z)) >= 0.0f ? (c2.w) : (r0.w));
    r2.xyz = (r6.xyz) * (r0.zzz) + (-(r5.xyz));
    r2.xyz = (r0.www) * (r2.xyz) + (r5.xyz);
    r2.xyz = (r2.xyz) * (c[11].xxx);
    r1.w = c[10].x;
    r1 = texCUBElod(s15, r1);
    r0.w = dot(c[17].xyz, c[17].xyz);
    r0.w = rsqrt(r0.w);
    r5.xyz = (c[17].xyz) * (r0.www) + (r4.xyz);
    r0.w = ((vFace.w) >= 0.0f ? (c12.x) : (c12.y));
    r4.xyz = normalize(r5.xyz);
    r3.xyz = (r3.xyz) * (r0.www);
    r1.xyz = (r1.xyz) * (r1.xyz);
    r1.w = saturate(dot(r3.xyz, r4.xyz));
    r2.xyz = (r1.xyz) * (c4.xxx) + (r2.xyz);
    r0.w = pow(abs(r1.w), c12.z);
    r1 = tex2D(s12, v6.zw);
    r1.xyz = (r1.yyy) * (c[18].xyz);
    r1.xyz = (r0.www) * (r1.xyz) + (r2.xyz);
    r2.xyz = normalize(v4.xyz);
    r1.xyz = (r1.xyz) * (c[24].xyz);
    r0.w = dot(c[5].xyz, r2.xyz);
    r0.w = saturate((c[7].y) * (r0.w) + (c[7].x));
    r2.xyz = c[0].xyz;
    r2.xyz = (-(r2.xyz)) + (c[6].xyz);
    r2.xyz = (r0.www) * (r2.xyz) + (c[0].xyz);
    r0.w = (-(r0.y)) + (c4.w);
    r2.xyz = (r2.xyz) * (c[0].www);
    r0.w = ((r0.w) >= 0.0f ? (c12.w) : (c12.x));
    r1.xyz = (r0.www) * (r1.xyz) + (-(r2.xyz));
    r1.xyz = (v4.www) * (r1.xyz) + (r2.xyz);
    r1.w = saturate((c[25].x) * (r0.y) + (c[25].y));
    r0.xyz = max(((r1.xyz) * (c[9].xxx)), 0.0f); // HDR: removed only the 1.0 ceiling
    r0.w = (r0.w) * (r1.w);
    r0.x = rsqrt(r0.x);
    r0.y = rsqrt(r0.y);
    r0.z = rsqrt(r0.z);
    oC0.x = 1.0f / (r0.x);
    oC0.y = 1.0f / (r0.y);
    oC0.z = 1.0f / (r0.z);
    oC0.w = r0.w;

    return oC0;
}
